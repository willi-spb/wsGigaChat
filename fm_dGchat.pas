unit fm_dGchat;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtDlgs, System.Actions,
  Vcl.ActnList, Vcl.StdCtrls,
  XSuperObject,
  u_wsGigaChat,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, Vcl.ExtCtrls;

type
  TGChatDirForm = class(TForm)
    btnuploadImage: TButton;
    actlstGC: TActionList;
    act_uploadImage: TAction;
    dlgOpenPict: TOpenPictureDialog;
    act_Auth: TAction;
    act_downloadImage: TAction;
    btndownloadImage: TButton;
    dlgSavePict_1: TSavePictureDialog;
    act_generateImage: TAction;
    btngenerateImage: TButton;
    btngetResponse: TButton;
    btngetAnswerForImage: TButton;
    act_getResponse: TAction;
    act_getAnswerForImage: TAction;
    btnfileList: TButton;
    act_fileList: TAction;
    btndescForRentgen: TButton;
    act_descForRentgen: TAction;
    lbl_State: TLabel;
    imgR: TImage;
    act_loadImage: TAction;
    btnloadImage: TButton;
    mmoDesc: TMemo;
    edtUploadID: TEdit;
    lbledt_desc: TLabeledEdit;
    chk_fileID: TCheckBox;
    edt_descRID: TEdit;
    btnsmList: TButton;
    act_smList: TAction;
    act_descForImageTH: TAction;
    btndescForImageTH: TButton;
    procedure act_uploadImageExecute(Sender: TObject);
    procedure act_AuthExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure act_downloadImageExecute(Sender: TObject);
    procedure act_generateImageExecute(Sender: TObject);
    procedure act_getResponseExecute(Sender: TObject);
    procedure act_getAnswerForImageExecute(Sender: TObject);
    procedure act_fileListExecute(Sender: TObject);
    procedure act_descForRentgenExecute(Sender: TObject);
    procedure act_loadImageExecute(Sender: TObject);
    procedure act_descForRentgenUpdate(Sender: TObject);
    procedure act_generateImageUpdate(Sender: TObject);
    procedure act_smListExecute(Sender: TObject);
    procedure act_descForImageTHExecute(Sender: TObject);
  private
    { Private declarations }
    FGChat:TwsGigaChat;
    F_fileName:string;
    procedure doFinishGChat(Sender:TObject; const aAsyncMethodName,aMess:String;
              aCompleteFlag:Boolean; aResObj:ISuperObject; aResStr:TStream);
  public
    { Public declarations }
    procedure setStage(aRg:Integer; const aCapt:string; const aDesc:string='');
  end;

var
  GChatDirForm: TGChatDirForm;

implementation

{$R *.dfm}

 uses Jpeg, System.IOUtils,
 u_CryptoFuncs,
 u_wCodeTrace, wAddFuncs, dlg_mess,
 fm_GchatList;


procedure TGChatDirForm.act_AuthExecute(Sender: TObject);
begin
  if FGChat.updateToken=false then
    MessMngr.MessDlg(nil,'','Ошибка аутентификации');

end;

procedure TGChatDirForm.act_descForImageTHExecute(Sender: TObject);
var L_ob,L_ob2:ISuperObject;
    L_fileName,L_rID,L_srcText:string;
    L_size:Int64;
begin
  L_fileName:=''; L_size:=0;
  L_srcText:=Trim(lbledt_desc.Text);
  if FGChat.Enabled then
   begin
    edt_descRID.Clear;
    if chk_fileID.Checked then
     begin
       L_rID:=Trim(edtUploadID.Text);
     end
    else
     begin
       L_fileName:=F_fileName;
       L_size:=get_FileSize(L_fileName);
     end;
    FGChat.asyncGetDescForImage(L_rID,L_fileName,L_size,L_srcText);
    setStage(2,'запуск потока');
   end;
end;

procedure TGChatDirForm.act_descForRentgenExecute(Sender: TObject);
var L_ob,L_ob2:ISuperObject;
    L_fileName,L_rID,L_dd,L_Mess:string;
    L_size:Int64;
begin

 L_dd:=Trim(lbledt_desc.Text);
 if FGChat.Enabled then
//  if dlgOpenPict.Execute then
   begin
    edt_descRID.Clear;
    if chk_fileID.Checked then
     begin
       L_rID:=Trim(edtUploadID.Text);
     end
    else
     begin
       L_fileName:=F_fileName;
       L_size:=get_FileSize(L_fileName);
       setStage(2,'запрос списка снимков');
       FGChat.getFileList(L_ob);
       if L_ob<>nil then
        begin
        //  L_Mess:=divTextToLines(L_ob.AsJSON(),100);
          L_rID:=FGChat.getFileIDFromFileList(L_ob,ExtractFileName(L_fileName),L_size);
          if (Length(L_rID)<10) then
           begin
            // L_fileName:='puPPT_rrt1.jpg';
            setStage(2,'загрузка снимка');
            if (FGChat.uploadFile(L_fileName,L_ob2)) and (L_ob2<>nil) then
               begin
                 setStage(1,'загружено');
                 L_rID:=L_ob2.S['id'];
               end
            else
               setStage(4,'ошибка при загрузке снимка');
           end
          else
            setStage(1,'снимок найден');
        end;
        L_ob:=nil; L_ob2:=nil;
     end;
       ///
     if Length(L_rID)>10 then
          try
            edt_descRID.Text:=L_rID;
            ///
            setStage(2,'анализ снимка');
            FGChat.Model:='GigaChat-2-Max'; // !!
            if (FGChat.sendText(L_dd,L_rID,L_ob,false)) and (L_ob<>nil) then
                 begin
                    L_Mess:=L_ob.S['answerText'];
                    setStage(0,'выполнено');
                    MessMngr.MessDlg(nil,'response',L_Mess,mdtInfo,[mbnOk],1);
                 end
             else
               setStage(2,'ошибка запроса описания');

            setStage(0,'завершено');
          finally
             FGChat.Model:='GigaChat';
          end
       else
         setStage(2,'ошибка обработки снимка');
      end
     else
        setStage(2,'ошибка запроса списка');
     ///https://probolezny.ru/pulpit-zuba/case-2445/
end;

procedure TGChatDirForm.act_descForRentgenUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled:=((Length(F_fileName)>0) and (FileExists(F_fileName))) or
   ((chk_fileID.Checked=True) and (Length(Trim(edtUploadID.Text))>0));
end;

procedure TGChatDirForm.act_downloadImageExecute(Sender: TObject);
var L_ob:ISuperObject;
    L_id,L_fileName,L_Mess:string;
begin
 if FGChat.Enabled then
 // if dlgSavePict_1.Execute then
   begin
   { L_id:='545bc734-5b80-4966-80e6-008fc5db90db';
    if (FGChat.deleteFile(L_id)) then
     begin
       ShowMessage('DEL');
     end;
     Exit;
    }
    L_fileName:='roma_R1.jpg';
    L_id:='6bf1abdc-cb76-4a1c-baa8-232653e3302e';
    if (FGChat.downloadFile(L_id,L_fileName)) then
      begin
        MessMngr.MessDlg(nil,'downFile','LOAD_file '+L_fileName,mdtInfo,[mbnOk],1);
      end;
   end;
end;

procedure TGChatDirForm.act_fileListExecute(Sender: TObject);
var L_ob:ISuperObject;
    L_Mess:string;
begin
  if FGChat.Enabled then
   begin
     FGChat.getFileList(L_ob);
     if L_ob<>nil then
       begin
        L_Mess:=divTextToLines(L_ob.AsJSON(),100);
      //  L_Mess:=FGChat.getFileIDFromFileList(L_ob,L_fName,L_size);
        MessMngr.MessDlg(nil,'FILES',L_Mess,mdtInfo,[mbnOk],1);
       end;
   end;
end;

procedure TGChatDirForm.act_generateImageExecute(Sender: TObject);
var L_ob:ISuperObject;
    L_fileName,L_desc,L_Mess:string;
begin
 if FGChat.Enabled then
  if dlgSavePict_1.Execute then
    begin
     L_fileName:=dlgSavePict_1.FileName;
     // 'Нарисовать эскиз маслом широкими мазками с помощью мастихина - голубой щенок.'
     L_desc:=Trim(mmoDesc.Lines.Text);
     if (FGChat.sendText(L_desc,'',L_ob,true)) and (L_ob<>nil) then
      begin
       L_Mess:=L_ob.AsJSON();
      // MessMngr.MessDlg(nil,'response',L_Mess,mdtInfo,[mbnOk],1);
       if L_ob.S['imgSrcID']<>'' then
          if (FGChat.downloadFile(L_ob.S['imgSrcID'],L_fileName)) then
         begin
          // MessMngr.MessDlg(nil,'downFile','LOAD_file '+'blue_dog.jpg',mdtInfo,[mbnOk],1);
          imgR.Picture.LoadFromFile(L_fileName);
         end;
      end;
   end;
end;

procedure TGChatDirForm.act_generateImageUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled:=(Length(Trim(mmoDesc.Lines.Text))>0);
end;

procedure TGChatDirForm.act_getAnswerForImageExecute(Sender: TObject);
var L_ob:ISuperObject;
    L_id,L_Mess:string;
begin
 if FGChat.Enabled then
   try
     FGChat.Model:='GigaChat-2-Max'; // !!
     L_id:='6bf1abdc-cb76-4a1c-baa8-232653e3302e'; // ромашки
   //  L_id:='3fbe481c-9cc9-410d-94f8-69f0192c501a'; // кошелёк
     if (FGChat.sendText('Опиши кратко, что изображено на этой фотографии?',L_id,L_ob,false)) and (L_ob<>nil) then
      begin
       L_Mess:=L_ob.S['answerText'];
       MessMngr.MessDlg(nil,'response',L_Mess,mdtInfo,[mbnOk],1);
      end;
    finally
     FGChat.Model:='GigaChat';
   end;
end;

procedure TGChatDirForm.act_getResponseExecute(Sender: TObject);
var L_ob:ISuperObject;
    L_Mess:string;
begin
 if FGChat.Enabled then
   begin
     if (FGChat.sendText('Определить русское название цветка Matricaria.','',L_ob,false)) and (L_ob<>nil) then
      begin
       L_Mess:=L_ob.S['answerText'];
       MessMngr.MessDlg(nil,'response',L_Mess,mdtInfo,[mbnOk],1);
      end;
   end;
end;

procedure TGChatDirForm.act_loadImageExecute(Sender: TObject);
begin
  if dlgOpenPict.Execute then
   try
     imgR.Picture.LoadFromFile(dlgOpenPict.FileName);
     F_fileName:=dlgOpenPict.FileName;
     except on E:Exception do
        MessMngr.MessDlgErr(E,'Ошибка изображения');
   end;
end;

procedure TGChatDirForm.act_smListExecute(Sender: TObject);
begin
 if FGChat.Enabled then
  if sm_GChatListDlg(Self,FGChat) then ;

end;

procedure TGChatDirForm.act_uploadImageExecute(Sender: TObject);
var L_ob:ISuperObject;
    L_Mess,L_fID:string;
    L_Str:TMemoryStream;
    L_jp:TJpegImage;
    L_size:Int64;
begin
 if FGChat.Enabled then
  if dlgOpenPict.Execute then
   begin
     L_Str:=TMemoryStream.Create;
     try
      L_jp:=TJpegImage.Create;
      try
       L_Str.LoadFromFile(dlgOpenPict.FileName);
       L_jp.LoadFromStream(L_str);
       L_Str.Seek(0,0);
      // imgR.Picture.Assign(L_jp);
      finally
        L_jp.Free;
      end;
     ///
      L_size:=get_FileSize(dlgOpenPict.FileName);
      setStage(2,'запрос списка файлов');
      FGChat.getFileList(L_ob);
      if L_ob<>nil then
        begin
          L_fID:=FGChat.getFileIDFromFileList(L_ob,ExtractFileName(dlgOpenPict.FileName),L_size);
          if (Length(L_fID)<10) then
           begin
            setStage(2,'загрузка изображения');
           // if (FGChat.uploadFile(dlgOpenPict.FileName,L_ob)) and (L_ob<>nil) then
            if (FGChat.uploadFileFromStream(L_Str,L_ob,'')) and (L_ob<>nil) then
              begin
                 L_fID:=L_ob.S['id'];
              end
           end
          else
            setStage(1,'найдено в списке');
        end;
     finally
      L_Str.Free;
     end;
          ///
     if Length(L_fID)>10 then
                   begin
                     edtUploadID.Text:=L_fID;
                     setStage(1,'выполнено');
                     L_Str:=TMemoryStream.Create;
                     try
                       setStage(2,'проверка файла в хранилище');
                       if (FGChat.downloadFileToStream(L_fID,L_str)) then
                           try
                            L_Str.Seek(0,0);
                            L_jp:=TJpegImage.Create;
                            try
                              L_jp.LoadFromStream(L_Str);
                              imgR.Picture.Assign(L_jp);
                              finally
                               L_jp.Free;
                             end;
                            setStage(1,'подтверждено');
                            except on E:Exception do
                              MessMngr.MessDlgErr(E,'Ошибка формата изображения');
                           end;
                     finally
                       L_Str.Free;
                     end;
                   end;
   end;
end;

procedure TGChatDirForm.doFinishGChat(Sender: TObject; const aAsyncMethodName,
  aMess: String; aCompleteFlag: Boolean; aResObj: ISuperObject;
  aResStr: TStream);
begin
 if SameText(aAsyncMethodName,'asyncGetDescForImage') then
  begin
    if aCompleteFlag then
       mmoDesc.Lines.Text:=aMess;
  end;
  setStage(0,'завершено');
end;

procedure TGChatDirForm.FormCreate(Sender: TObject);
var L_path,L_CliID,L_Akey:string;
begin
 wCode.Enabled:=True;

  FGChat:=TwsGigaChat.Create(Self);
  ///
  ///  если свои ClientID и AuthKey - подстаить их в поля вместо моего внешнего файла
  L_CliID:='';
  L_Akey:='';
  ///
  if Length(L_CliID)=0 then
   with TStringList.Create do
    begin
      LoadFromFile('..\..\..\'+'ggLoginKeys.dat');
      if Count>=2 then
       begin
         L_CliID:=ch_DecryptStr(Strings[0],45);
         L_Akey:=ch_DecryptStr(Strings[1],45);
       end;
    end;
  ///
  if (Length(L_Akey)>10) then
   begin
     FGChat.setAuthParams(L_CliID,L_Akey);
   end;
end;

procedure TGChatDirForm.FormShow(Sender: TObject);
var L_ob:ISuperObject;
    L_fName,L_Mess:string;
    L_size:Int64;
begin
  act_Auth.Execute;
  if FGChat.Enabled then
   begin
   { L_fName:='image_R.jpg';
    L_size:=get_FileSize(L_fName);
    }
    FGChat.OnFinishGChatEvent:=doFinishGChat;
    // FGChat.getFileInfo('6bf1abdc-cb76-4a1c-baa8-232653e3302e',L_ob);
   { FGChat.getFileList(L_ob);
     if L_ob<>nil then
       begin
      //  L_Mess:=divTextToLines(L_ob.AsJSON(),100);
        L_Mess:=FGChat.getFileIDFromFileList(L_ob,L_fName,L_size);
        MessMngr.MessDlg(nil,'FILES',L_Mess,mdtInfo,[mbnOk],1);
       end;
    }
   end;
 end;


procedure TGChatDirForm.setStage(aRg:Integer; const aCapt, aDesc: string);
begin
 lbl_State.Caption:=aCapt;
 case aRG of
  1: lbl_State.Font.Color:=clGreen;
  2: lbl_State.Font.Color:=clMaroon;
  3: lbl_State.Font.Color:=clBlue;
  4: lbl_State.Font.Color:=clRed;
  else
    lbl_State.Font.Color:=clWindowText;
 end;
 Application.ProcessMessages;
 Sleep(120);
end;

end.
