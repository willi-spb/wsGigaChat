unit u_wsGigaChat;

interface

 uses  System.SysUtils, System.Classes,  IdHTTP, IdSSL, IdSSLOpenSSL,
  xSuperObject, System.Generics.Collections;

  type
   TreqGGChatAutorizationRegime=(rggABasic,rggABeaver);

   TOnGGchatErrorEvent=procedure(Sender:TObject; const aMethodName,aErrorStr,aParamStr:String) of object;
   TFinishGGChatEvent=procedure(Sender:TObject; const aAsyncMethodName,aMess:String;
     aCompleteFlag:Boolean; aResObj:ISuperObject; aResStr:TStream) of object;

   TwsGigaChatThread=class;

   TwsGigaChat=class(TComponent)
     private
       const
          SBER_GIGACHAT_OAUTH = 'https://ngw.devices.sberbank.ru:9443/api/v2/oauth';
          SBER_GIGACHAT_OAUTH_SCOPE = 'GIGACHAT_API_PERS';
          SBER_GIGACHAT_API_LPART='https://gigachat.devices.sberbank.ru/api/v1';
     private
      FEnabled:Boolean;
      FModel:string;
      FClientID: string;
      FAuthorizationKey: string;
      FAccessToken: string;
      FExpiresAt: TDateTime;
      FactiveThreadItems:TDictionary<String,TwsGigaChatThread>;
      FOnGGchatErrorEvent:TOnGGchatErrorEvent;
      FOnFinishGChatEvent:TFinishGGChatEvent;
     protected
       procedure setReqParams(aReq:TIdHTTPRequest; aRegime:TreqGGChatAutorizationRegime; addSign:integer); virtual;
       function createSSLHandler(aHttp:TIdHTTP; acreateRg:Integer=0):TIdSSLIOHandlerSocketOpenSSL; virtual;
       procedure GError(aE:Exception; const aMethodName,aErrorMessStr:string; const aParamStr:string=''); virtual;
     // не вызывается для случая Terminate
     ///  procedure do_ThTerminate(Sender:TObject);
     public
      constructor Create(AOwner:TComponent); override;
      destructor Destroy; override;
      ///
      procedure setAuthParams(const aClientID,aAuthorizationKey:string);
      ///
      function updateToken:Boolean; virtual;
      /// <summary>
      ///    загрузить данные (изображение) в хранилище
      /// </summary>
      function uploadFileFromStream(const aStr:TStream; var aObj: ISuperObject; const aTempFileName:string;
          const aContentType: string='image/jpeg'): Boolean;
      /// <summary>
      ///    загрузить изображение или файл в хранилище
      /// </summary>
      function uploadFile(const aFileName:string; var aObj:ISuperObject; const aContentType:string='image/jpeg'):Boolean; virtual;
      /// <summary>
      ///    получить запись по файлу в хранилище
      /// </summary>
      function getFileInfo(const aFileID:string; var aObj:ISuperObject):boolean; virtual;
      /// <summary>
      ///    получить список файлов в хранилище
      /// </summary>
      function getFileList(var aObj:ISuperObject):boolean; virtual;
      /// <summary>
      ///    удалить из хранилища
      /// </summary>
      function deleteFile(const aFileID:string):boolean; virtual;
      /// <summary>
      ///    загрузить файл в поток из хранилища
      /// </summary>
      function downloadFileToStream(const aFileID:string; AStr:TStream):Boolean; virtual;
      /// <summary>
      ///    надстройка - загрузить файл из хранилища на диск
      /// </summary>
      function downloadFile(const aFileID,aFileName:string):Boolean; virtual;
      /// <summary>
      ///     в списке найти файл по имени и размеру
      /// </summary>
      class function getFileIDFromFileList(aObj:ISuperObject; const aFileName:string; aSize:Int64; const aObjType:String='file'):string;
      class function existsIDFromFileList(aObj:ISuperObject; const aID:string; const aObjType:String='file'):Boolean;
      ///
      function sendText(const aText,aAttachFileID:string; var aObj:ISuperObject; autoFlag:Boolean=False):boolean; virtual;
      /// <summary>
      ///         узнать - запущены ли методы обработки - если спросить с пустым названием - проверим хотя бы 1 запущеный
      /// </summary>
      function asyncMethodsIsActive(const aMethodNames:string):Boolean; virtual;

      function asyncGetDescForImage(const aFileID,aFileName:string; aFileSize:Int64; const aReqText:string):Boolean; virtual;
      ///
      property Model:string read FModel write FModel;
      property Enabled:boolean read FEnabled;
      property ClientID:string read FClientID;
      property AuthorizationKey: string read FAuthorizationKey;
      property ExpiresAt: TDateTime read FExpiresAt;
      property AccessToken: string read FAccessToken;
      property OnGGchatError:TOnGGchatErrorEvent read FOnGGchatErrorEvent write FOnGGchatErrorEvent;
      property OnFinishGChatEvent:TFinishGGChatEvent read FOnFinishGChatEvent write FOnFinishGChatEvent;
   end;

     TwsGigaChatThread=class(TThread)
      protected
       FRegime:integer;
       FMethodName:string;
       FFileID,FFileName:string;
       FFilesize:Int64;
       FRequestText:string;
       FsrcStream:TStream;
       ///
       FChatRef: TwsGigaChat;
       procedure Execute; override;
      public
       constructor Create;
       procedure AssignOptions(AChat:TwsGigaChat; const aMethodName:string;
       const aFileID,aFileName:string; aFileSize:Int64; const aReqText:string; FsrcStream:TStream;
       aRegime: Integer=1);
     end;

function imgSrc_extractImageUID(const aText:string):string;
function getFileExtForContentType(const aContentType:string):string;


implementation

  uses IdMultipartFormData,IdGlobal,
       System.DateUtils, u_wCodeTrace, u_wResources;

function imgSrc_extractImageUID(const aText:string):string;
var iL,kk:integer;
const L_prx='img src="';
 begin
  Result:='';
  iL:=AnsiPos(L_prx,aText);
  if IL>0 then
   begin
     for kk:=iL+Length(L_prx) to Length(aText) do
      begin
        if aText[kk]='"' then
         begin
           Result:=Copy(aText,iL+Length(L_prx),kk-iL-Length(L_prx));
           break;
         end;
      end;
   end;
 end;

function getFileExtForContentType(const aContentType:string):string;
 begin
   if SameText(aContentType,'image/jpeg') then Result:='.jpg'
   else
     if SameText(aContentType,'text/plain') then Result:='.txt'
     else
      if SameText(aContentType,'image/png') then Result:='.png'
      else
       Result:='.dat';
 end;

{ TwsGigaChat }

function TwsGigaChat.asyncGetDescForImage(const aFileID, aFileName: string;
  aFileSize: Int64; const aReqText: string):Boolean;
var L_methodName:string;
    L_TH:TwsGigaChatThread;
begin
  Result:=False;
  L_methodName:='asyncGetDescForImage';
  if FactiveThreadItems.ContainsKey(L_methodName)=False then
   begin
     L_TH:=TwsGigaChatThread.Create;
     L_TH.AssignOptions(Self,L_methodName,aFileID, aFileName,aFileSize,aReqText,nil,1);
    ///  не работает - L_TH.OnTerminate:=do_ThTerminate;
     FactiveThreadItems.Add(L_methodName,L_TH);
     L_TH.Resume;
   end;
end;

function TwsGigaChat.asyncMethodsIsActive(const aMethodNames: string): Boolean;
var L_meth:string;
begin
  if Length(aMethodNames)<2 then
     Result:=(FactiveThreadItems.Count>0)
  else
   begin
     L_meth:=aMethodNames;
     Result:=FactiveThreadItems.ContainsKey(L_meth);
   end;
end;

constructor TwsGigaChat.Create(AOwner: TComponent);
begin
  inherited;
  FEnabled:=False;
  FAccessToken :='';
  FModel:='GigaChat';
  FactiveThreadItems:=TDictionary<String,TwsGigaChatThread>.Create(0);
end;

function TwsGigaChat.createSSLHandler(aHttp: TIdHTTP;
  acreateRg: Integer): TIdSSLIOHandlerSocketOpenSSL;
begin
  Result:=TIdSSLIOHandlerSocketOpenSSL.Create(aHTTP);
  Result.SSLOptions.SSLVersions := [sslvTLSv1_2];
  aHTTP.IOHandler :=Result;
  Result.SSLOptions.VerifyMode :=[];//  [sslvrfPeer]; // Аутентификация
end;

function TwsGigaChat.deleteFile(const aFileID: string): boolean;
 var L_HTTP: TIdHTTP;
     L_SSLHandler: TIdSSLIOHandlerSocketOpenSSL;
     LStr:TMemoryStream;
     L_text:string;
     L_Obj:ISuperObject;
begin
 /// '6bf1abdc-cb76-4a1c-baa8-232653e3302e'
  Result:=false;
  L_HTTP := TIdHTTP.Create(nil);
  LStr:=TMemoryStream.Create;
  try
    L_SSLHandler:=createSSLHandler(L_HTTP,0);
    setReqParams(L_HTTP.Request,rggABeaver,0);
    try
      L_text:=L_HTTP.Post(SBER_GIGACHAT_API_LPART+'/files/'+aFileID+'/delete',LStr);
     // '{"id":"545bc734-5b80-4966-80e6-008fc5db90db","deleted":true}'
      if stringIsJsonObject(L_text) then
       try
          L_Obj:=SO(L_text);
          if SameText(L_Obj.S['id'],aFileID) then
             Result:=L_Obj.B['deleted'];
         except on E:Exception do
           GError(E,'deleteFile','JobjectERROR',aFileID);
        end;
     except on E:Exception do
       GError(E,'deleteFile','getERROR',aFileID);
    end;
  finally
    L_HTTP.Free;
    LStr.Free;
  end;
end;

destructor TwsGigaChat.Destroy;
var L_methName:string;
    L_item:TwsGigaChatThread;
    il:integer;
begin
 /// если активно выполенние засинхронных запросов - прервать их и дождаться очистки их списка... (при выходе из Execute)
  for L_methName in FactiveThreadItems.Keys do
   begin
     L_item:=FactiveThreadItems.Items[L_methName];
     if Assigned(L_item) then
        L_item.Terminate;
   end;
 /// если выполняется какой-то запрос - не выходим
  il:=0;
  while (asyncMethodsIsActive('*')) and (il<10) do
   begin
    Sleep(1000);
    Inc(il);
   end;
  ///
  FactiveThreadItems.Clear;
  FactiveThreadItems.Free;
  inherited;
end;

function TwsGigaChat.downloadFile(const aFileID, aFileName: string): Boolean;
 var LStream:TMemoryStream;
     L_text,LFileName:string;
begin
  Result:=false;
  LFileName:=aFileName;
  LStream:=TMemoryStream.Create;
  try
   Result:=downloadFileToStream(aFileID,LStream);
   if LStream.Size>1 then
    try
     Result:=False;
     if Length(LFileName)=0 then
               LFileName:=FormatDateTime('yyyy-mm-dd_hh_nn_ss.jpg',Now);
     LStream.SaveToFile(aFileName);
     Result:=True;
     except on E:Exception do
           GError(E,'downloadFile','SaveERROR',aFileID);
    end;
  finally
    LStream.Free;
  end;
end;

function TwsGigaChat.downloadFileToStream(const aFileID: string;
  AStr: TStream): Boolean;
 var L_HTTP: TIdHTTP;
     L_SSLHandler: TIdSSLIOHandlerSocketOpenSSL;
     L_text:string;
begin
  Result:=false;
  L_HTTP := TIdHTTP.Create(nil);
  try
    L_SSLHandler:=createSSLHandler(L_HTTP,0);
    setReqParams(L_HTTP.Request,rggABeaver,0);
    try
      L_HTTP.Get(SBER_GIGACHAT_API_LPART+'/files/'+aFileID+'/content',AStr);
      AStr.Seek(0,0);
      ///
      L_text:=L_HTTP.Response.ResponseText;
      ///
      if (AStr.Size>1) and (L_HTTP.Response.ResponseCode=200) then
         Result:=True;
     except on E:Exception do
       GError(E,'downloadFileToStream','getERROR',aFileID);
    end;
  finally
    L_HTTP.Free;
  end;
end;

{
procedure TwsGigaChat.do_ThTerminate(Sender: TObject);
var L_method:string;
begin
  if Sender is TwsGigaChatThread then
   with Sender as TwsGigaChatThread do
    begin
      L_method:=FMethodName;
      if FactiveThreadItems.ContainsKey(L_method) then
         FactiveThreadItems.Remove(L_method);
    end;
end;
}

class function TwsGigaChat.existsIDFromFileList(aObj: ISuperObject; const aID,
  aObjType: String): Boolean;
var  ii:integer;
     L_type:string;
     L_obj:ISuperObject;
begin
  Result:=False;
  if Length(aObjType)=0 then
     L_type:='file'
  else L_type:=aObjType;
  if (aObj<>nil) and (aObj.A['data']<>nil) and (aObj.A['data'].Length>0) then
   for ii:=0 to aObj.A['data'].Length-1 do
    begin
      L_obj:=aObj.A['data'].O[ii];
      if (L_obj<>nil) and (SameText(L_obj.S['object'],L_type)) and
        (SameText(aID,L_obj.S['id'])) then
        begin
          Result:=True;
          Exit;
        end;
    end;
end;

procedure TwsGigaChat.GError(aE:Exception; const aMethodName, aErrorMessStr:string; const aParamStr:string);
var LSS,L_errMess:string;
begin
  if aE<>nil then
     LSS:=aE.ClassName+' : '+aE.Message
  else LSS:='GGERROR';
  if Length(aErrorMessStr)>0 then
     LSS:=LSS+' '+aErrorMessStr;
  L_errMess:=Self.ClassName+'.'+aMethodName+'='+LSS;
  if Length(aParamStr)>0 then
     L_errMess:=L_errMess+' | '+aParamStr;
  wLog('e',L_errMess);
  if Assigned(FOnGGchatErrorEvent) then
     FOnGGchatErrorEvent(Self,aMethodName,LSS,aParamStr);
end;

class function TwsGigaChat.getFileIDFromFileList(aObj: ISuperObject;
  const aFileName: string; aSize: Int64; const aObjType:String='file'): string;
var  ii:integer;
     L_type:string;
     L_obj:ISuperObject;
begin
  Result:='';
  if Length(aObjType)=0 then
     L_type:='file'
  else L_type:=aObjType;
  if (aObj<>nil) and (aObj.A['data']<>nil) and (aObj.A['data'].Length>0) then
   for ii:=0 to aObj.A['data'].Length-1 do
    begin
      L_obj:=aObj.A['data'].O[ii];
      if (L_obj<>nil) and (SameText(L_obj.S['object'],L_type)) and
        (AnsiSameStr(aFileName,L_obj.S['filename'])) and
        ((aSize<=0) or (Abs(aSize-L_obj.I['bytes'])<=1)) then
        begin
          Result:=L_obj.S['id'];
          Exit;
        end;
    end;
end;

function TwsGigaChat.getFileInfo(const aFileID: string;
  var aObj: ISuperObject): boolean;
 var L_HTTP: TIdHTTP;
     L_SSLHandler: TIdSSLIOHandlerSocketOpenSSL;
     L_text,LS:string;
begin
 /// '6bf1abdc-cb76-4a1c-baa8-232653e3302e'
  Result:=false;
  aObj:=nil;
  L_HTTP := TIdHTTP.Create(nil);
  try
    L_SSLHandler:=createSSLHandler(L_HTTP,0);
    setReqParams(L_HTTP.Request,rggABeaver,0);
    try
      L_text:=L_HTTP.Get(SBER_GIGACHAT_API_LPART+'/files/'+aFileID);
      if stringIsJsonObject(L_text) then
       try
        // TFile '{"id":"6bf1abdc-cb76-4a1c-baa8-232653e3302e","object":"file","bytes":1223006,"access_policy":"private","created_at":1774946193,"filename":"image_R.jpg","purpose":"general","modalities":[]}'
          aObj:=SO(L_text);
          Result:=True;
         except on E:Exception do
           GError(E,'getFileInfo','JobjectERROR',aFileID);
        end;
     except on E:Exception do
       GError(E,'getFileInfo','getERROR',aFileID);
    end;
  finally
    L_HTTP.Free;
  end;
end;

function TwsGigaChat.getFileList(var aObj: ISuperObject): boolean;
 var L_HTTP: TIdHTTP;
     L_SSLHandler: TIdSSLIOHandlerSocketOpenSSL;
     L_text:string;
begin
  Result:=false;
  aObj:=nil;
  L_HTTP := TIdHTTP.Create(nil);
  try
    L_SSLHandler:=createSSLHandler(L_HTTP,0);
    setReqParams(L_HTTP.Request,rggABeaver,0);
    try
      L_text:=L_HTTP.Get(SBER_GIGACHAT_API_LPART+'/files');
      if stringIsJsonObject(L_text) then
       try
          aObj:=SO(L_text);
          Result:=True;
         except on E:Exception do
           GError(E,'getFileList','JobjectERROR');
        end;
     except on E:Exception do
       GError(E,'getFileList','getERROR');
    end;
  finally
    L_HTTP.Free;
  end;
end;

(*
'{
  "model": "GigaChat",
  "messages": [
    {
      "role": "system",
      "content": "Ты — Василий Кандинский"
    },
    {
      "role": "user",
      "content": "Нарисуй розового кота"
    }
  ],
  "function_call": "auto"
}'
  *)


function TwsGigaChat.sendText(const aText,aAttachFileID: string;
  var aObj: ISuperObject; autoFlag:Boolean=False): boolean;
 var L_HTTP: TIdHTTP;
     L_SSLHandler: TIdSSLIOHandlerSocketOpenSSL;
     L_JStr:TStringStream;
     L_obj,L_iOb,L_itemObj:ISuperObject;
     L_text,LS:string;
     L_attachFlag:Boolean;
begin
  Result:=false;
  aObj:=nil;
  if (Length(aText)=0) then Exit;
  L_attachFlag:=false;
  L_HTTP := TIdHTTP.Create(nil);
  L_JStr:=TStringStream.Create('',TEncoding.UTF8);
  try
    L_SSLHandler:=createSSLHandler(L_HTTP,0);
    setReqParams(L_HTTP.Request,rggABeaver,0);
    L_HTTP.Request.ContentType:='application/json';
    ///
    L_obj:=SO('{"model": "'+FModel+'"}');
      L_iOb:=SO('{"role": "user"}');
      L_iOb.S['content']:=aText;
      if Length(aAttachFileID)>1 then
       begin
        // L_obj.S['model']:='GigaChat-Pro';
         L_iOb.A['attachments'].Add(aAttachFileID);
         L_attachFlag:=True;
       end;
    //  L_iOb.S['content']:='Draw a sketch with oil paints using broad strokes - a blue puppy.';
    //  L_iOb.S['content']:='Нарисовать эскиз маслом широкими мазками с помощью мастихина - голубой щенок.';
    L_obj.A['messages'].Add(L_iOb);
    if autoFlag then
       L_obj.S['function_call']:='auto';
    if L_attachFlag then
     begin
       L_obj.B['stream']:=False;
       L_obj.I['update_interval']:=0;
     end;
    ///
    L_JStr.WriteString(L_obj.AsJSON());
    L_JStr.SaveToFile('test.json');
    L_obj:=nil;
    L_JStr.Seek(0,0);
    try
      L_text:=L_HTTP.Post(SBER_GIGACHAT_API_LPART+'/chat/completions',L_JStr);
      if stringIsJsonObject(L_text) then
       try
          aObj:=SO(L_text);
          L_itemObj:=aObj.A['choices'].O[0];
          LS:=L_itemObj.O['message'].S['content'];
          if Length(LS)>10 then
              begin
               if (autoFlag) and (L_attachFlag=False) then
                 begin
                  aObj.S['imgSrcID']:=imgSrc_extractImageUID(LS);
                  Result:=aObj.S['imgSrcID']<>'';
                 end
               else
                begin
                 aObj.S['answerText']:=LS;
                 Result:=Length(LS)>0;
                end;
              end;
         except on E:Exception do
           GError(E,'sendText','JobjectERROR');
        end;
     except on E:Exception do
       GError(E,'sendText','postERROR',L_HTTP.ResponseText);
    end;
  finally
    L_HTTP.Free;
    L_JStr.Free;
  end;
end;

procedure TwsGigaChat.setAuthParams(const aClientID, aAuthorizationKey: string);
begin
 FClientID:=aClientID;
 FAuthorizationKey:=aAuthorizationKey;
end;

procedure TwsGigaChat.setReqParams(aReq: TIdHTTPRequest;
  aRegime: TreqGGChatAutorizationRegime; addSign: integer);
begin
 with aReq do
  begin
    Accept:= 'application/json';
    AcceptCharSet:='utf-8';
    UserAgent:= 'Mozilla/5.0 (Windows NT 10.0; WOW64; rv:42.0) Gecko/20100101 Firefox/42.0';
    case aRegime of
      rggABasic:  begin
                    CustomHeaders.Values['RqUID'] := FClientID;
                    CustomHeaders.Values['Authorization'] := 'Basic ' + FAuthorizationKey;
                  end;
      rggABeaver: CustomHeaders.Values['Authorization'] :='Bearer ' +FAccessToken;
    end;
  end;
end;

function TwsGigaChat.updateToken: Boolean;
 var L_HTTP: TIdHTTP;
     L_SSLHandler: TIdSSLIOHandlerSocketOpenSSL;
     LContent:TStrings;
     L_text,LS:string;
     L_Obj:ISuperObject;
begin
  Result:=false;
  FEnabled:=False;
  L_text:='';
  L_HTTP := TIdHTTP.Create(nil);
  LContent:=TStringList.Create;
  try
    L_SSLHandler:=createSSLHandler(L_HTTP,0);
    setReqParams(L_HTTP.Request,rggABasic,0);
    L_HTTP.Request.ContentType:='application/x-www-form-urlencoded';
    ///
    LContent.Add('scope='+SBER_GIGACHAT_OAUTH_SCOPE);
    try
      L_text:=L_HTTP.Post(SBER_GIGACHAT_OAUTH,LContent);
      if stringIsJsonObject(L_text) then
       try
          L_Obj:=SO(L_text);
          FAccessToken :=L_Obj.S['access_token'];
          FExpiresAt:=UnixToDateTime(L_Obj.I['expires_at'] div MSecsPerSec,False);
          Result:=True;
          FEnabled:=(Length(FAccessToken)>10) and (FExpiresAt>=Now);
         except on E:Exception do
           GError(E,'updateToken','JobjectERROR','');
        end;
        L_Obj:=nil;
     except on E:Exception do
       begin
         GError(E,'updateToken','postError','');
       end;
     end;
  finally
    L_HTTP.Free;
    LContent.Free;
  end;
end;

function TwsGigaChat.uploadFileFromStream(const aStr:TStream; var aObj: ISuperObject; const aTempFileName:string;
  const aContentType: string): Boolean;
 var L_HTTP: TIdHTTP;
     L_SSLHandler: TIdSSLIOHandlerSocketOpenSSL;
     LStream: TIdMultipartFormDataStream;
     L_contentType,L_fileExt,L_fileName,L_text:string;
begin
  Result:=false;
  aObj:=nil;
  if Length(aContentType)=0 then
     L_contentType:='image/jpeg'
  else L_contentType:=aContentType;
  ///
  L_fileName:=Trim(aTempFileName);
  if Length(L_fileName)=0 then
   begin
     L_fileExt:=getFileExtForContentType(L_contentType);
     L_fileName:=FormatDateTime('YYYY-MM-DD_hh_nn_ss',Now)+L_fileExt;
   end;
  ///
  L_HTTP := TIdHTTP.Create(nil);
  LStream := TIdMultipartFormDataStream.Create;
  try
    L_SSLHandler:=createSSLHandler(L_HTTP,0);
    setReqParams(L_HTTP.Request,rggABeaver,0);
    L_HTTP.Request.ContentType:='multipart/form-data';
   // LStream.AddObject('file',L_contentType,'utf-8',aStr,''); 0c4bd427-25dc-4914-9bbf-5b3c1e1aa3f7
    LStream.AddObject('file',L_contentType,'',aStr,L_fileName);
    LStream.AddFormField('purpose', 'general');
     try
      L_text:=L_HTTP.Post(SBER_GIGACHAT_API_LPART+'/files',LStream);
      if stringIsJsonObject(L_text) then
       try
          aObj:=SO(L_text);
          Result:=True;
         except on E:Exception do
           GError(E,'uploadFile','JobjectERROR');
        end;
     except on E:Exception do
       GError(E,'uploadFile','postERROR');
    end;
  finally
    L_HTTP.Free;
    LStream.Free;
  end;
end;


function TwsGigaChat.uploadFile(const aFileName: string; var aObj: ISuperObject;
  const aContentType: string): Boolean;
 var L_HTTP: TIdHTTP;
     L_SSLHandler: TIdSSLIOHandlerSocketOpenSSL;
     LStream: TIdMultipartFormDataStream;
     L_contentType,L_text:string;
begin
  Result:=false;
  aObj:=nil;
  if Length(aContentType)=0 then
     L_contentType:='image/jpeg'
  else L_contentType:=aContentType;
  L_HTTP := TIdHTTP.Create(nil);
  LStream := TIdMultipartFormDataStream.Create;
  try
    L_SSLHandler:=createSSLHandler(L_HTTP,0);
    setReqParams(L_HTTP.Request,rggABeaver,0);
    L_HTTP.Request.ContentType:='multipart/form-data';
    LStream.AddFile('file',aFileName,L_contentType);
    LStream.AddFormField('purpose', 'general');
     try
      L_text:=L_HTTP.Post(SBER_GIGACHAT_API_LPART+'/files',LStream);
      if stringIsJsonObject(L_text) then
       try
          aObj:=SO(L_text);
          Result:=True;
         except on E:Exception do
           GError(E,'uploadFile','JobjectERROR');
        end;
     except on E:Exception do
       GError(E,'uploadFile','postERROR');
    end;
  finally
    L_HTTP.Free;
    LStream.Free;
  end;
end;

{ TwsGigaChatThread }

constructor TwsGigaChatThread.Create;
begin
 inherited Create(true);
// FreeOnTerminate := true;
end;

procedure TwsGigaChatThread.AssignOptions(AChat: TwsGigaChat; const aMethodName:string;
  const aFileID,aFileName:string; aFileSize:Int64; const aReqText:string; FsrcStream:TStream;
  aRegime: Integer);
begin
 FChatRef:=AChat;
 FRegime := aRegime;
 FMethodName:=aMethodName;
 FFileID:=aFileID;
 FFileName:=aFileName;
 FFilesize:=aFileSize;
 FRequestText:=aReqText;
 ///
 FreeOnTerminate:=True;
 Suspended:=True;
end;

procedure TwsGigaChatThread.Execute;
var L_ob,L_ob2:ISuperObject;
    L_fid,L_Mess:string;
    L_CompleteFlag:Boolean;
    L_str:TStream;
begin
  if FChatRef.Enabled then
    with FChatRef do
     try
       L_fid:='';
       L_Mess:='';
       L_str:=nil;
       L_CompleteFlag:=false;
       Model:='GigaChat';
       if SameText(FMethodName,'asyncGetDescForImage') then
        begin
           if (getFileList(L_ob)) and (L_ob<>nil) then
            begin
              if Length(FFileID)>10 then
               begin
                 if existsIDFromFileList(L_ob,FFileID) then
                    L_fid:=FFileID;
               end;
              if (Length(L_fid)=0) and (Length(FFileName)>1) then
                 L_fid:=getFileIDFromFileList(L_ob,ExtractFileName(FfileName),FFilesize);
              ///
              if (Terminated=False) and (Length(L_fid)<10) and (Length(FFileName)>1) then
               begin
                /// загрузка файла
                if (uploadFile(FFileName,L_ob2)) and (L_ob2<>nil) then
                 begin
                     L_fid:=L_ob2.S['id'];
                     L_ob2:=nil;
                 end
                else ;
               end;
             L_ob:=nil;
            end;
            ///
           if (Terminated=False) and (Length(L_fid)>10) then
              try
                Model:='GigaChat-2-Max'; // !!
                if (sendText(FRequestText,L_fid,L_ob,false)) and (L_ob<>nil) then
                     begin
                        L_Mess:=L_ob.S['answerText'];
                        L_CompleteFlag:=True;
                     end
              finally
                 Model:='GigaChat';
              end;
        end;
     finally
      try
       if (Terminated=False) then
         Synchronize(procedure
          begin
           if Assigned(OnFinishGChatEvent) then
            OnFinishGChatEvent(FChatRef,FMethodName,L_Mess,L_CompleteFlag,L_ob,L_str);
          end);
      finally
       if Assigned(FChatRef) then
           if FChatRef.FactiveThreadItems.ContainsKey(FMethodName) then
              FChatRef.FactiveThreadItems.Remove(FMethodName);
      end;
    end;
end;

end.
