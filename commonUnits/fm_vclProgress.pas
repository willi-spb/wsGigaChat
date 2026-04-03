unit fm_vclProgress;
///  окно процесса (прогрессбар) показа чего-то
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls;


type
  TProgressStateRec=record
    regime:integer;
    Position:Double;
    Caption,CommentText:string;
    Stage:Integer;
  end;

  TprogressParamType=(pbarStyle,pbarChangeRegime);

  TVCLProgressForm = class(TForm)
   // cxpbar_Loading: TcxProgressBar;
    lblLoading: TLabel;
    tmrProgressLoading: TTimer;
    lblLoadCaption: TLabel;
    pbar_Loading: TProgressBar;
    procedure tmrProgressLoadingTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  protected
    FRegime:integer;
    FDelayFlag:Boolean;
    FIsShow:Boolean;
    FCurrState:TProgressStateRec;
  public
    { Public declarations }
    /// <summary>
    ///    при true - вызывать App.ProcMess - но только если изменились название или позиция на 1
    ///    по умолч - false;
    /// </summary>
    changeInfoUpdated:Boolean;
    procedure fillPosInfo(const aPosCaption,aLoadingText:string; aPos:Double);
    procedure prepareForm(aRg:integer; const aCapt,aHomeLoadCaption:string; aShowDelay:Integer=0);
    procedure showPosition(const aPosCaption,aLoadingText:string; aPos:Double; aAllSetFlag:Boolean=false);
    procedure RefreshPosition(aMessFlag:Boolean=true);
    procedure closeProgress;
    property IsShow:Boolean read FIsShow;
    property currState:TProgressStateRec read FCurrState write FCurrState;
  end;

var
  VCLProgressForm: TVCLProgressForm;
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
  /// <summary>
  ///      выставить режимы для прогресса
  /// </summary>
  procedure Progress_SetParam(aParamType:TprogressParamType; aVal:Integer);


implementation

{$R *.dfm}


 procedure Progress_Show(aRg:integer; AOwner:TComponent; const aCapt,aHomeLoadCaption:string; aShowDelay:Integer=0);
  begin
   if Assigned(VCLProgressForm) then
      FreeAndNil(VCLProgressForm);
   VCLProgressForm:=TVCLProgressForm.Create(AOwner);
   VCLProgressForm.prepareForm(aRg,aCapt,aHomeLoadCaption,aShowDelay);
  end;

{ TProgressForm }

procedure Progress_ShowPosition(const aPosCaption,aLoadingText:string; aPos:Double; aAllSetFlag:Boolean=false);
begin
 if (Assigned(VCLProgressForm)) then
   VCLProgressForm.showPosition(aPosCaption,aLoadingText,aPos,aAllSetFlag);
end;

procedure Progress_ShowPos(const aPosCaption,aLoadingText:string; aPos:Double);
 begin
   if (Assigned(VCLProgressForm)) then
      VCLProgressForm.showPosition(aPosCaption,aLoadingText,aPos,True);
 end;


procedure Progress_Refresh(aMessFlag:Boolean=true);
 begin
   if Assigned(VCLProgressForm) then
      VCLProgressForm.RefreshPosition(aMessFlag);
 end;


procedure Progress_Close;
 begin
   if Assigned(VCLProgressForm) then
    try
     VCLProgressForm.closeProgress;
     finally
       FreeAndNil(VCLProgressForm);
     end;
 end;


procedure Progress_SetPosInfo(const aPosCaption,aLoadingText:string; aPos:Double);
 begin
  if Assigned(VCLProgressForm) then
     with VCLProgressForm do
       fillPosInfo(aPosCaption,aLoadingText,aPos);
 end;


procedure Progress_SetParam(aParamType:TprogressParamType; aVal:Integer);
 begin
   if Assigned(VCLProgressForm) then
     with VCLProgressForm do
       case aParamType of
        pbarStyle: FRegime:=aVal;
        pbarChangeRegime: changeInfoUpdated:=(aVal=1);
       end;
 end;

procedure TVCLProgressForm.closeProgress;
begin
  try
    tmrProgressLoading.Enabled:=False;
    FIsShow:=False;
    ModalResult:=mrCancel;
   finally
  end;
end;

procedure TVCLProgressForm.fillPosInfo(const aPosCaption, aLoadingText: string;
  aPos: Double);
begin
  if aPosCaption='*' then
           begin
            FCurrState.Position:=pbar_Loading.Position;
            FCurrState.Caption:=lblLoadCaption.Hint;
            FCurrState.CommentText:=lblLoading.Caption;
           end
  else
   begin
     FCurrState.Position:=Trunc(aPos);
     FCurrState.Caption:=aPosCaption;
     FCurrState.CommentText:=aLoadingText;
   end;
 {        if tmrProgressLoading.Enabled=false then
            tmrProgressLoading.Enabled:=True;
  }
end;

procedure TVCLProgressForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=not(FIsShow);
end;

procedure TVCLProgressForm.FormCreate(Sender: TObject);
begin
  changeInfoUpdated:=false;
end;

procedure TVCLProgressForm.prepareForm(aRg: integer; const aCapt,
  aHomeLoadCaption: string; aShowDelay:Integer=0);
begin
  changeInfoUpdated:=false;
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
     lblLoadCaption.Hint:=aHomeLoadCaption;
     lblLoading.Caption:='';
     pbar_Loading.Position:=0;
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

procedure TVCLProgressForm.RefreshPosition(aMessFlag: Boolean);
begin
  if Visible=true then
       begin
        lblLoadCaption.Refresh;
        pbar_Loading.Update;
        lblLoading.Refresh;
       // Update;
        Refresh;
        if aMessFlag then
           Application.ProcessMessages;
       end;
end;

procedure TVCLProgressForm.showPosition(const aPosCaption, aLoadingText: string;
  aPos: Double; aAllSetFlag: Boolean);
 var LPos:double;
     L_appPrMessFlag:Boolean;
     L_capt:string;
begin
 if (Visible=True) or (aAllSetFlag=True) then
   begin
    L_appPrMessFlag:=false;
    if aPos>100 then LPos:=100
    else LPos:=aPos;
    if changeInfoUpdated then
      begin
        L_appPrMessFlag:=(Trunc(Lpos)<>pbar_Loading.Position) or
        ((Length(aPosCaption)>0) and (AnsiSameStr(lblLoadCaption.Hint,aPosCaption)=false)) or
        ((Length(aLoadingText)>0) and (AnsiSameStr(lblLoading.Caption,aLoadingText)=false));
      end;
    if aPosCaption<>'' then
       lblLoadCaption.Hint:=aPosCaption;
    ///
    lblLoadCaption.Caption:=aPosCaption+lblLoadCaption.Hint+': '+FormatFloat('0.#',Lpos)+'%';
    if aLoadingText<>'' then
       lblLoading.Caption:=aLoadingText;
    pbar_Loading.Position:=TRunc(LPos);
    fillPosInfo('*','',0);
    if L_appPrMessFlag then
       Application.ProcessMessages;
   end;
end;

procedure TVCLProgressForm.tmrProgressLoadingTimer(Sender: TObject);
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
