unit fm_GchatList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, dxmdaset, Vcl.ExtCtrls,
  cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid,
  XSuperObject,
  u_wsGigaChat, System.Actions, Vcl.ActnList, Vcl.StdCtrls;

type
  TGChatListForm = class(TForm)
    cxgrdv_List: TcxGridDBTableView;
    cxgrdLVL_Grid1Level1: TcxGridLevel;
    cxgrd_List: TcxGrid;
    pnlTop: TPanel;
    dxmdt_glist: TdxMemData;
    dsGList: TDataSource;
    strngfld_glistid: TStringField;
    strngfld_glistobject: TStringField;
    strngfld_glistaccess_policy: TStringField;
    dtmfld_glistcreated_at: TDateTimeField;
    dxmdt_glistfilename: TWideStringField;
    strngfld_glistpurpose: TStringField;
    strngfld_glistmodalItems: TStringField;
    cxgrdbclmn_ListRecId: TcxGridDBColumn;
    cxgrdbclmn_Listid: TcxGridDBColumn;
    cxgrdbclmn_Listobject: TcxGridDBColumn;
    cxgrdbclmn_Listaccess_policy: TcxGridDBColumn;
    cxgrdbclmn_Listcreated_at: TcxGridDBColumn;
    cxgrdbclmn_Listfilename: TcxGridDBColumn;
    cxgrdbclmn_Listpurpose: TcxGridDBColumn;
    cxgrdbclmn_ListmodalItems: TcxGridDBColumn;
    btndelete: TButton;
    actlst_GList: TActionList;
    act_delete: TAction;
    procedure act_deleteUpdate(Sender: TObject);
    procedure act_deleteExecute(Sender: TObject);
  private
    { Private declarations }
    F_type:string;
    F_ListObj:ISuperObject;
    F_GChatRef:TwsGigaChat;
  public
    { Public declarations }
    function loadList(const aType:string):integer;
    function loadDataToDs:Boolean;
  end;

var
  GChatListForm: TGChatListForm;

  function sm_GChatListDlg(AOwner:TComponent; aGChat:TObject):Boolean;

implementation

{$R *.dfm}

 uses System.DateUtils, u_wCodeTrace, wAddFuncs, dlg_mess, u_wResources;


 function sm_GChatListDlg(AOwner:TComponent; aGChat:TObject):Boolean;
 var il:integer;
  begin
   Result:=False;
    with TGChatListForm.Create(AOwner) do
     try
      F_type:='file';
      F_GChatRef:=TwsGigaChat(aGChat);
      il:=loadList(F_type);
      if il>0 then
       begin
         if loadDataToDs then
            Result:=ShowModal=mrOk;
       end;
     finally
       Free;
     end;
  end;

{ TGChatListForm }

procedure TGChatListForm.act_deleteExecute(Sender: TObject);
var L_id:string;
begin
  L_id:=dsGList.DataSet.FieldByName('id').AsString;
  if Length(L_id)>10 then
   begin
      if F_GChatRef.deleteFile(L_id) then
         MessMngr.MessDlg(nil,'DELETE item in Storage','Выполнено');
      try
       dsGList.DataSet.DisableControls;
       if loadList(F_type)>=0 then
         if loadDataToDs then ;
       ///
      finally
       dsGList.DataSet.EnableControls;
      end;
   end;
end;

procedure TGChatListForm.act_deleteUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled:=(dsGList.DataSet.Active) and (Length(dsGList.DataSet.FieldByName('id').AsString)>10);
end;

function TGChatListForm.loadDataToDs: Boolean;
var L_obj:ISuperObject;
    ii:integer;
begin
 Result:=False;
 if dsGList.DataSet.Active then dsGList.DataSet.Close;
 dsGList.DataSet.Active:=True;
 for ii:=0 to F_ListObj.A['data'].Length-1 do
  begin
    L_obj:=F_ListObj.A['data'].O[ii];
    dsGList.DataSet.Append;
    xJobjToDataset(dsGList.DataSet,'modalItems,created_at',L_obj,true);
    with dsGList.DataSet do
     begin
       FieldByName('created_at').AsDateTime:= UnixToDateTime(L_obj.I['created_at']);
     end;
    dsGList.DataSet.Post;
  end;
 Result:=(dsGList.DataSet.Active=True);
end;

function TGChatListForm.loadList(const aType: string): integer;
begin
  Result:=-1;
  F_ListObj:=nil;
  if (F_GChatRef.getFileList(F_ListObj)) and (F_ListObj<>nil) then
   begin
     Result:=F_ListObj.A['data'].Length;
   end;
end;

end.
