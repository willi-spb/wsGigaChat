program wsGChat1;

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Vcl.Forms,
  fm_dGchat in 'fm_dGchat.pas' {GChatDirForm},
  RzCommon in '..\MMLite\common\RzCommon.pas',
  RzGrafx in '..\MMLite\common\RzGrafx.pas',
  u_getVersion in '..\MMLite\common\u_getVersion.pas',
  u_wCodeTrace in '..\MMLite\common\u_wCodeTrace.pas',
  u_wsGigaChat in 'u_wsGigaChat.pas',
  fm_GchatList in 'fm_GchatList.pas' {GChatListForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TGChatDirForm, GChatDirForm);
  Application.Run;
end.
