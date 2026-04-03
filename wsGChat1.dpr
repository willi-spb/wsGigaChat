program wsGChat1;

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Vcl.Forms,
  fm_dGchat in 'fm_dGchat.pas' {GChatDirForm},
  u_wsGigaChat in 'u_wsGigaChat.pas',
  fm_GchatList in 'fm_GchatList.pas' {GChatListForm},
  RzCommon in 'commonUnits\RzMinFiles\RzCommon.pas',
  RzGrafx in 'commonUnits\RzMinFiles\RzGrafx.pas',
  XSuperJSON in 'components\x-superobject-master\XSuperJSON.pas',
  XSuperObject in 'components\x-superobject-master\XSuperObject.pas',
  dlg_Mess in 'commonUnits\dlg_Mess.pas' {Mess_Dlg},
  u_wCodeTrace in 'commonUnits\u_wCodeTrace.pas',
  u_wResources in 'commonUnits\u_wResources.pas',
  wAddFuncs in 'commonUnits\wAddFuncs.pas',
  u_CryptoFuncs in 'commonUnits\u_CryptoFuncs.pas',
  u_wDataTypes in 'commonUnits\u_wDataTypes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TGChatDirForm, GChatDirForm);
  Application.Run;
end.
