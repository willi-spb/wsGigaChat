unit u_wsGigaChat_H;

interface

 uses   System.SysUtils, System.Classes,
  System.Net.HttpClient,
  System.Net.HttpClientComponent,
  System.Net.Mime,
  System.Net.URLClient;

 type
   TwsGigaChat=class(TComponent)
     private
       const
          SBER_GIGACHAT_OAUTH = 'https://ngw.devices.sberbank.ru:9443/api/v2/oauth';
          SBER_GIGACHAT_OAUTH_SCOPE = 'GIGACHAT_API_PERS';
     private
      FEnabled:Boolean;
      FClientID: string;
      FAuthorizationKey: string;
      FAccessToken: string;
      FExpiresAt: TDateTime;
      procedure DoNeedClientCertificate(const Sender: TObject; const ARequest: TURLRequest; const ACertificateList: TCertificateList;
                var AnIndex: Integer);
      procedure DoValidateServerCertificate(const Sender: TObject; const ARequest: TURLRequest;
                                  const Certificate: TCertificate; var Accepted: Boolean);
     public
      constructor Create(AOwner:TComponent); override;
      destructor Destroy; override;
      ///
      procedure setAuthParams(const aClientID,aAuthorizationKey:string);
      ///
      function updateToken:Boolean; virtual;
      ///
      property Enabled:boolean read FEnabled;
      property ClientID:string read FClientID;
      property AuthorizationKey: string read FAuthorizationKey;
      property ExpiresAt: TDateTime read FExpiresAt;
      property AccessToken: string read FAccessToken;
   end;


implementation

 uses System.DateUtils, u_wCodeTrace, u_wResources, xSuperObject,
  Winapi.Windows;


{ TwsGigaChat }

constructor TwsGigaChat.Create(AOwner: TComponent);
begin
  inherited;
  FEnabled:=False;
  FAccessToken :='';
end;

destructor TwsGigaChat.Destroy;
begin

  inherited;
end;

function TwsGigaChat.updateToken: Boolean;
var LClient:TNetHTTPClient;
    LContent:TStrings;
   // LReq: TNetHTTPRequest;
    LResp:IHTTPResponse;
    L_text:string;
    L_Obj:ISuperObject;
 begin
  Result:=false;
  FEnabled:=False;
  LClient:=TNetHTTPClient.Create(nil);
  LContent:=TStringList.Create;
  try
    LClient.UserAgent := 'Mozilla/5.0 (Windows NT 10.0; WOW64; rv:42.0) Gecko/20100101 Firefox/42.0';
    LClient.ContentType:='application/x-www-form-urlencoded';
   // LClient.OnNeedClientCertificate:=DoNeedClientCertificate;
   // LClient.OnValidateServerCertificate:=DoValidateServerCertificate;
    LClient.AcceptCharSet := 'utf-8';
    LClient.Accept := 'application/json';
    LClient.CustomHeaders['RqUID'] := FClientID;
    LClient.CustomHeaders['Authorization'] := 'Basic ' + FAuthorizationKey;
    // LReq.OnValidateServerCertificate :=DoValidateServerCertificate;
    // LReq.ConnectionTimeout := 3000;
    { LReq.Client :=LClient;
     LReq.URL:=SBER_GIGACHAT_OAUTH;

     LResp:=LReq.Post(SBER_GIGACHAT_OAUTH,LContent);
     }
    LContent.Add('scope='+SBER_GIGACHAT_OAUTH_SCOPE);
    LResp:=LClient.Post(SBER_GIGACHAT_OAUTH,LContent);
     if LResp<>nil then
      begin
       L_text:=LResp.ContentAsString;
       if (LResp.StatusCode=200) and (stringIsJsonObject(L_text)) then
        try
          L_Obj:=SO(L_text);
          FAccessToken :=L_Obj.S['access_token'];
          FExpiresAt:=UnixToDateTime(L_Obj.I['expires_at'] div MSecsPerSec,False);
          Result:=True;
          FEnabled:=(Length(FAccessToken)>10) and (FExpiresAt>=Now);
         except on E:Exception do
           wLogE('TwsGigaChat.updateToken',E);
        end;
        L_Obj:=nil;
      end;
  finally
    LClient.Free;
    LContent.Free;
  end;
end;

procedure TwsGigaChat.DoValidateServerCertificate(const Sender: TObject;
  const ARequest: TURLRequest; const Certificate: TCertificate;
  var Accepted: Boolean);
var LS:string;
begin
 if Certificate.Subject<>'' then
   with Certificate do
     LS:=Format('subject=%s,  Issuer=%s, protocolName=%s, AlgSignature=%s, AlgEncryption=%s',
         [Subject,Issuer,ProtocolName,AlgSignature,AlgEncryption]);
 // wLog('i',LS);
  Accepted:=True;
end;

procedure TwsGigaChat.setAuthParams(const aClientID, aAuthorizationKey: string);
begin
   FClientID:=aClientID;
   FAuthorizationKey:=aAuthorizationKey;
end;

{
procedure THTTPClient.Do_ValidateServerCertificate(LRequest: THTTPRequest);
var
  LServerCertAccepted: Boolean;
  LServerCertificate: TCertificate;
begin
  LServerCertAccepted := False;
  if Assigned(FValidateServerCertificateCallback) or Assigned(FValidateServerCertificateEvent) then
  begin
    LServerCertificate := DoGetSSLCertificateFromServer(LRequest);
    if LServerCertificate.IsEmpty then
      raise ENetHTTPCertificateException.CreateRes(@SNetHttpGetServerCertificate);
    if Assigned(FValidateServerCertificateCallback) then
      FValidateServerCertificateCallback(Self, LRequest, LServerCertificate, LServerCertAccepted)
    else
      FValidateServerCertificateEvent(Self, LRequest, LServerCertificate, LServerCertAccepted);
  end
  else
    raise ENetHTTPCertificateException.CreateRes(@SNetHttpInvalidServerCertificate);
  if not LServerCertAccepted then
    raise ENetHTTPCertificateException.CreateRes(@SNetHttpServerCertificateNotAccepted)
  else
    DoServerCertificateAccepted(LRequest);
end;
}

procedure TwsGigaChat.DoNeedClientCertificate(const Sender: TObject;
  const ARequest: TURLRequest; const ACertificateList: TCertificateList;
  var AnIndex: Integer);
var il:Integer;
    LS:string;
begin
  wLog('n','need');
  for il := 0 to ACertificateList.Count-1 do
   with ACertificateList.Items[il] do
    begin
     LS:=Format('i=%d, subject=%s,  Issuer=%s, protocolName=%s, AlgSignature=%s, AlgEncryption=%s',
      [il,Subject,Issuer,ProtocolName,AlgSignature,AlgEncryption]);
     wLog('i',LS);
    end;
end;

{
procedure TwsGigaChat.DoServerCertificateAccepted(const ARequest: THTTPRequest);
var
  LFlags: DWORD;
begin

  LFlags := SECURITY_FLAG_IGNORE_UNKNOWN_CA or SECURITY_FLAG_IGNORE_CERT_WRONG_USAGE or
    SECURITY_FLAG_IGNORE_CERT_CN_INVALID or SECURITY_FLAG_IGNORE_CERT_DATE_INVALID;

  WinHttpSetOption(TWinHTTPRequest(ARequest).FWRequest, WINHTTP_OPTION_SECURITY_FLAGS, @LFlags, SizeOf(LFlags));
  TWinHTTPRequest(ARequest).FServerCertificateValidated := True;
  TWinHTTPRequest(ARequest).FServerCertificateAccepted := True;
end;
}

end.
