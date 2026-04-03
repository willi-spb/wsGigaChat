unit fm_Progress;
///  окно процесса (прогрессбар) показа чего-то
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxProgressBar, Vcl.StdCtrls, Vcl.ExtCtrls,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit;

type
  TProgressStateRec=record
    regime:integer;
    Position:Double;
    Caption,CommentText:string;
    Stage:Integer;
  end;

  TProgressForm = class(TForm)
    cxpbar_Loading: TcxProgressBar;
    lblLoading: TLabel;
    tmrProgressLoading: TTimer;
    lblLoadCaption: TLabel;
    procedure tmrProgressLoadingTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    FRegime:integer;
  protected
    FDelayFlag:Boolean;
    FIsShow:Boolean;
    FCurrState:TProgressStateRec;
  public
    { Public declarations }
    procedure fillPosInfo(const aPosCaption,aLoadingText:string; aPos:Double);
    procedure prepareForm(aRg:integer; const aCapt,aHomeLoadCaption:string; aShowDelay:Integer=0);
    procedure showPosition(const aPosCaption,aLoadingText:string; aPos:Double; aAllSetFlag:Boolean=false);
    procedure RefreshPosition(aMessFlag:Boolean=true);
    procedure closeProgress;
    property IsShow:Boolean read FIsShow;
    property currState:TProgressStateRec read FCurrState write FCurrState;
  end;

var
  ProgressForm: TProgressForm;
    /// <summary>
  ///    показать (aDelay>0 - с заданной задержкой мс)
  /// </summary>
  procedure Progress_Show(aRg:integer; AOwner:TComponent; const aCapt,aHomeLoadCaption:string; aShowDelay:Integer=0);
  procedure Progress_Close;
  procedure Progress_ShowPosition(const aPosCaption,aLoadingText:string; aPos:Double; aAllSetFlag:Boolean=false);
  procedure Progress_ShowPos(const aPosCaption,aLoadingText:string; aPos:Double);
  ///
  /// <summary>
  ///    обновить окно - если оно есть и видимо
  /// </summary>;
  procedure Progress_Refresh(aMessFlag:Boolean=true);
  ///
  /// <summary>
  ///      выставить значения прогресса для таймера
  /// </summary>
  procedure Progress_SetPosInfo(const aPosCaption,aLoadingText:string; aPos:Double);


implementation

{$R *.dfm}


 procedure Progress_Show(aRg:integer; AOwner:TComponent; const aCapt,aHomeLoadCaption:string; aShowDelay:Integer=0);
  begin
   if Assigned(ProgressForm) then
      FreeAndNil(ProgressForm);
   ProgressForm:=TProgressForm.Create(AOwner);
   ProgressForm.prepareForm(aRg,aCapt,aHomeLoadCaption,aShowDelay);
  end;

{ TProgressForm }

procedure Progress_ShowPosition(const aPosCaption,aLoadingText:string; aPos:Double; aAllSetFlag:Boolean=false);
begin
 if (Assigned(ProgressForm)) then
   ProgressForm.showPosition(aPosCaption,aLoadingText,aPos,aAllSetFlag);
end;

procedure Progress_ShowPos(const aPosCaption,aLoadingText:string; aPos:Double);
 begin
   if (Assigned(ProgressForm)) then
      ProgressForm.showPosition(aPosCaption,aLoadingText,aPos,True);
 end;


procedure Progress_Refresh(aMessFlag:Boolean=true);
 begin
   if Assigned(ProgressForm) then
      ProgressForm.RefreshPosition(aMessFlag);
 end;


procedure Progress_Close;
 begin
   if Assigned(ProgressForm) then
    try
     ProgressForm.closeProgress;
     finally
       FreeAndNil(ProgressForm);
     end;
 end;


procedure Progress_SetPosInfo(const aPosCaption,aLoadingText:string; aPos:Double);
 begin
  if Assigned(ProgressForm) then
     with ProgressForm do
       fillPosInfo(aPosCaption,aLoadingText,aPos);
 end;

procedure TProgressForm.closeProgress;
begin
  try
    tmrProgressLoading.Enabled:=False;
    FIsShow:=False;
    ModalResult:=mrCancel;
   finally
  end;
end;

procedure TProgressForm.fillPosInfo(const aPosCaption, aLoadingText: string;
  aPos: Double);
begin
  if aPosCaption='*' then
           begin
            FCurrState.Position:=cxpbar_Loading.Position;
            FCurrState.Caption:=lblLoadCaption.Caption;
            FCurrState.CommentText:=lblLoading.Caption;
           end
  else
   begin
     FCurrState.Position:=aPos;
     FCurrState.Caption:=aPosCaption;
     FCurrState.CommentText:=aLoadingText;
   end;
 {        if tmrProgressLoading.Enabled=false then
            tmrProgressLoading.Enabled:=True;
  }
end;

procedure TProgressForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=not(FIsShow);
end;

procedure TProgressForm.prepareForm(aRg: integer; const aCapt,
  aHomeLoadCaption: string; aShowDelay:Integer=0);
begin
  if (Assigned(Owner)) and (Owner is TCustomForm) then
        begin
          Position:=poOwnerFormCenter;
        end
     else Position:=poScreenCenter;
     ///
     FRegime:=aRg;
     tmrProgressLoading.Enabled:=False;
     FIsShow:=True;
     Caption:=' '+aCapt;
     lblLoadCaption.Caption:=aHomeLoadCaption;
     lblLoading.Caption:='';
     cxpbar_Loading.Position:=0;
     ///
     case FRegime of
       0: Color:=$00CA6928;
       1: Color:=$008C812B;
       2: Color:=$009B3C69;
       3: Color:=$009B3C69;
       4: Color:=$00706D4B;
     end;
     ///
     if aShowDelay=0 then
      begin
       FDelayFlag:=False;
       Show; // !
       BringToFront;
      end
     else
      begin
        FDelayFlag:=True;
        tmrProgressLoading.Interval:=aShowDelay;
        tmrProgressLoading.Enabled:=True;
      end;
end;

procedure TProgressForm.RefreshPosition(aMessFlag: Boolean);
begin
  if Visible=true then
       begin
        lblLoadCaption.Refresh;
        cxpbar_Loading.Update;
        lblLoading.Refresh;
       // Update;
        Refresh;
        if aMessFlag then
           Application.ProcessMessages;
       end;
end;

procedure TProgressForm.showPosition(const aPosCaption, aLoadingText: string;
  aPos: Double; aAllSetFlag: Boolean);
 var LPos:Double;
begin
 if (Visible=True) or (aAllSetFlag=True) then
   begin
    if aPosCaption<>'' then
       lblLoadCaption.Caption:=aPosCaption;
    if aLoadingText<>'' then
       lblLoading.Caption:=aLoadingText;
    if aPos>100 then LPos:=100
    else LPos:=aPos;
    cxpbar_Loading.Position:=LPos;
    fillPosInfo('*','',0);
   end;
end;

procedure TProgressForm.tmrProgressLoadingTimer(Sender: TObject);
begin
 if FIsShow then
  begin
    if Self.FDelayFlag=true then
     begin
       FDelayFlag:=False;
       tmrProgressLoading.Enabled:=False;
       Self.Show;
       Self.BringToFront;
     end;
    if (Self.WindowState=wsMinimized) then
       begin
            ShowWindow(Handle, SW_RESTORE);
           // Self.Show;
            Self.BringToFront;
       end;
    //Progress_ShowPosition(FCurrState.Caption,FCurrState.CommentText,FCurrState.Position,True);
    fillPosInfo('*','',0);
    Application.ProcessMessages;
  end;
end;

end.
