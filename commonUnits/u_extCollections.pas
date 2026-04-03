unit u_extCollections;
////////////////
///
///

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, Vcl.Forms;

type


///   регистрация действия для определенного типа Характеристик
///   Например, Поставщик товара - вызывается список поставщиков

  TExtShellRef = reference to function(ASender: TObject; aOwner: TComponent; var aExtID: UInt64; var aextDesc: string): Boolean;

  TExtIDRecord = record
    extID: UInt64;
    extStr: string;
    extRef: TExtShellRef;
  end;

  pExtIDRecord = ^TExtIDRecord;

  TExtIDCollection = class(TDictionary<Uint64, TExtIDRecord>)
    function ShellFromCharTypeID(ASender: TObject; aOwner: TComponent; aID: UInt64; var aextID: UInt64; var aDesc: string): Boolean;
    function RegisterCharTypeIDRef(aTypeID, hmExtID: UInt64; const hmStr: string; aRef: TExtShellRef): Boolean;
  end;

  TCallProcRef = reference to procedure(aSndr: TObject; aPtr: Pointer);

 /// <summary>
 ///   для стандартизации передачи инфо по указателю
 /// </summary>
  TExtDataRecord = record
    dRegime: integer;
    dataType: integer;
    dValue: Variant;
    dStr: string;
    dID,dResID,dAltID: UInt64;
    dProcRef: TCallProcRef;
    dEvent: TNotifyEvent;
    dObj: TObject;
    procedure SetEmpty;
  end;

  pExtDataRecord = ^TExtDataRecord;

  tExtArrayRecord=record
   aRefs : array[0..9] of Pointer;
   procedure SetEmpty;
  end;

  pExtArrayRecord=^tExtArrayRecord;

  TModalFunc = function(aOwner: TObject; aPtr: Pointer): Integer;

  TMdiShowFunc = function(aOwner: TObject; aPtr: Pointer): TCustomForm;

  TexDataProc = procedure(aDataAr:Variant; aPtr: Pointer);

  TexDataEvent = procedure(aSender:TObject; aDataAr:Variant; aPtr: Pointer) of object;

//  TexDataCB = procedure(aSender:TObject; aDataAr:Variant; aPtr: Pointer; a) of object;

  TexActionItem = class(TPersistent)
  public
    Ident: string[80];
    mdResult: Integer;
    iProcRef: TCallProcRef;
    mdFunc: TModalFunc;
    mdiShowFunc: TMdiShowFunc;
    cFormRef: TCustomForm;
    Event: TNotifyEvent;
    dataProc: TexDataProc;
    dataEvent: TexDataEvent;
    constructor Create(const AIdent: string);
  end;
  ///
  ///
  TExActionCallEvent=procedure(aCallType,aID:Integer; const AIdent:string; aSndr:TObject; aRef:Pointer; var aResSign:integer) of object;
  /// <summary>
  ///    словарь для вызова зарегистрированных действий - показ окон, показ окон в mdi, вызов процедур
  ///    коллекция - это набор записей с уникальным ИД и справочной строкой-идентификатором для описания
  ///   (можно искать по строке) --
  ///   т.о. после регистрации можно любое окно вызвать на показ МДИ (если форма существует)
  ///   НЕ рекомендую использовать ссылки на экземпляры форм cFormRef - т.к. формы могут удаляться, а здесь отслеживания указателей не встроено
  /// </summary>
  TExActionDict = class(TObjectDictionary<Integer, TexActionItem>)
   private
    FName:string;
    FBeforeCallEvent,FAfterCallEvent:TExActionCallEvent;
   public
    constructor Create(const aDName:string);
    function AddwithIdent(aID: Integer; const AIdent: string): TexActionItem;
    function GetFromIdent(const AIdent: string): TexActionItem;
    function DeleteFromIdent(const AIdent: string):Boolean;
    function DeleteItem(aID: Integer):Boolean;
    function CallmdFunc(aID: Integer; AOwner: TObject; aRef: Pointer): Boolean;
    function CallmdiShowFunc(aID: Integer; AOwner: TObject; aRef: Pointer): Boolean;
    function CallEvent(aID: Integer; aSndr: TObject): Boolean;
    function CallProcRef(aID: Integer; aSndr: TObject; aRef: Pointer = nil): Boolean;
    procedure CallDataProc(aID: Integer; aDataAr:Variant; aRef: Pointer);
    procedure CallDataEvent(aID: Integer; aSender:TObject; aDataAr:Variant; aRef: Pointer);
  /// <summary>
  ///      service-> создать и добавить процедуру за раз
  /// </summary>
    function AddOrSetwithIdentAndProc(aID: Integer; const AIdent: string; aProc: TCallProcRef): TexActionItem;
    ///
    property Name:string read FName;
    ///
    property BeforeCallEvent:TExActionCallEvent read FBeforeCallEvent write FBeforeCallEvent;
    property AfterCallEvent:TExActionCallEvent read FAfterCallEvent write FAfterCallEvent;
  end;

function GetExActionDict: TExActionDict;

procedure SetExActionDict(aexActDict: TObject);
/// <summary>
///   centralAssignFlag=true - назначить на указатель _ExActionDict
///  Не рекомендуется (категорич) ставить его false!
/// </summary>
function CreateOrGetActionDict(centralAssignFlag: Boolean = true): TExActionDict;

procedure FreeActionDict;

procedure SetActionDictAllEvents(ABeforeCallEvent,AAfterCallEvent:TExActionCallEvent; centralAssignFlag: Boolean = true);

/// <summary>
///    найти действие в словаре по ID или (если ID=0) по имени
/// </summary>
function GetExActionForIDorName(aID:Integer; const aName:string=''):TexActionItem;

var
  ExtCollection: TExtIDCollection;

implementation

uses
  Variants;

var
  _ExActionDict: TExActionDict;

function GetExActionDict: TExActionDict;
begin
  if Assigned(_ExActionDict) then
    Result := _ExActionDict
  else
    Result := nil;
end;

procedure SetExActionDict(aexActDict: TObject);
begin
  _ExActionDict := TExActionDict(aexActDict);
end;

function CreateOrGetActionDict(centralAssignFlag: Boolean = true): TExActionDict;
begin
  Result := nil;
  if (centralAssignFlag) and (Assigned(_ExActionDict)) then
    Result := _ExActionDict;
  if Result = nil then
    Result := TExActionDict.Create('CENTRAL');
  if (centralAssignFlag) then
    _ExActionDict := Result; // !
end;

procedure FreeActionDict;
begin
  if Assigned(_ExActionDict) then
    FreeAndNil(_ExActionDict);
  _ExActionDict := nil;
end;

procedure SetActionDictAllEvents(ABeforeCallEvent,AAfterCallEvent:TExActionCallEvent; centralAssignFlag: Boolean = true);
var L_ADict:TExActionDict;
 begin
   L_ADict:=CreateOrGetActionDict(centralAssignFlag);
   L_ADict.BeforeCallEvent:=ABeforeCallEvent;
   L_ADict.AfterCallEvent:=AAfterCallEvent;
 end;

function GetExActionForIDorName(aID:Integer; const aName:string=''):TexActionItem;
 var L_ActDict:TExActionDict;
     iD:Integer;
 begin
   Result:=nil;
   L_ActDict:=GetExActionDict;
   if L_ActDict<>nil then
    begin
     if (aID<>0) and(L_ActDict.ContainsKey(aID)) then
         Result:=L_ActDict.Items[aID]
     else
      if Trim(aName)<>'' then
       for iD in L_ActDict.Keys do
          if L_ActDict.Items[iD].Ident=aName then
             begin
               Result:=L_ActDict.Items[iD];
               Break;
             end;
    end;
 end;

//////////////////////////////////////////////////////////////////////////////////
{ TExtIDCollection }

function TExtIDCollection.RegisterCharTypeIDRef(aTypeID, hmExtID: UInt64; const hmStr: string; aRef: TExtShellRef): Boolean;
var
  LRec: TExtIDRecord;
begin
  if (ContainsKey(aTypeID) = False) then
  begin
    LRec.extID := hmExtID;
    LRec.extStr := '';
    LRec.extRef := aRef;
    Add(aTypeID, LRec);
  end;
end;

function TExtIDCollection.ShellFromCharTypeID(ASender: TObject; aOwner: TComponent; aID: UInt64; var aextID: UInt64; var aDesc: string): Boolean;
var
  LRec: TExtIDRecord;
begin
  Result := False;
  if (ContainsKey(aID)) and (Items[aID].extRef <> nil) then
  begin
    LRec := Items[aID];
    LRec.extID := aextID;
    LRec.extStr := aDesc;
    if Items[aID].extRef(ASender, aOwner, LRec.extID, LRec.extStr) then
    begin
      Items[aID] := LRec;
      aextID := LRec.extID;
      aDesc := LRec.extStr;
      Result := True;
    end;
  end;
end;

{ TextActionItem }

constructor TexActionItem.Create(const AIdent: string);
var
  i: Integer;
begin
  inherited Create;
  Ident := AIdent;
  mdResult := 0;
  iProcRef := nil;
  mdFunc := nil;
  mdiShowFunc := nil;
  Event := nil;
  cFormRef := nil;
  dataProc := nil;
  dataEvent := nil;
end;

{ TExActionDict }

function TExActionDict.AddOrSetwithIdentAndProc(aID: Integer; const AIdent: string; aProc: TCallProcRef): TexActionItem;
var
  LItem: TexActionItem;
begin
  Result := nil;
  if ContainsKey(aID) then
    LItem := Items[aID]
  else
    LItem := AddwithIdent(aID, AIdent);
  if (AIdent <> '') and (AIdent <> '*') then
    LItem.Ident := AIdent;
  LItem.iProcRef := aProc;
  Result := LItem;
end;

function TExActionDict.AddwithIdent(aID: Integer; const AIdent: string): TexActionItem;
var
  LItem: TexActionItem;
begin
  Result := nil;
  Assert(ContainsKey(aID) = False, 'TExActionDict.AddwithIdent Duplicate ID=' + IntToStr(aID));
  LItem := TexActionItem.Create(AIdent);
  Add(aID, LItem);
  Result := LItem;
end;

function TExActionDict.CallEvent(aID: Integer; aSndr: TObject): Boolean;
var L_resSign:integer;
begin
  Result := False;
  if ContainsKey(aID) then
    if (Assigned(Items[aID].Event) = true) then
    begin
      L_resSign:=1;
      if Assigned(FBeforeCallEvent) then
        FBeforeCallEvent(2,aID,Items[aID].Ident,aSndr,Nil,L_resSign);
      if L_resSign>0 then
       begin
        Items[aID].Event(aSndr);
        Result := True;
        if Assigned(FAfterCallEvent) then
           FAfterCallEvent(2,aID,Items[aID].Ident,aSndr,NIL,L_resSign);
       end;
    end;
end;

function TExActionDict.CallmdFunc(aID: Integer; AOwner: TObject; aRef: Pointer): Boolean;
var L_resSign:integer;
begin
  Result := False;
  if ContainsKey(aID) then
    if (Assigned(Items[aID].mdFunc)) then
    begin
      L_resSign:=1;
      if Assigned(FBeforeCallEvent) then
        FBeforeCallEvent(1,aID,Items[aID].Ident,aOwner,aRef,L_resSign);
      if L_resSign>0 then
       begin
        Items[aID].mdResult := Items[aID].mdFunc(AOwner, aRef);
        Result := True;
        if Assigned(FAfterCallEvent) then
           FAfterCallEvent(1,aID,Items[aID].Ident,aOwner,aRef,L_resSign);
       end;
    end;
end;

function TExActionDict.CallmdiShowFunc(aID: Integer; AOwner: TObject; aRef: Pointer): Boolean;
var L_resSign:integer;
begin
  Result := False;
  if ContainsKey(aID) then
   /// Willi: корректировка от 11.02.2020 - допускается повторный вызов mdi
   /// (оно м.б. где-то закрыто и поэтому нужно вызывать несмотря на указатель фыормы)
    if (Assigned(Items[aID].mdiShowFunc)) {and (Assigned(Items[aID].cFormRef) = False)} then
    begin
     L_resSign:=1;
      if Assigned(FBeforeCallEvent) then
        FBeforeCallEvent(3,aID,Items[aID].Ident,aOwner,aRef,L_resSign);
     if L_resSign>0 then
       begin
        Items[aID].cFormRef := Items[aID].mdiShowFunc(AOwner, aRef);
        Result := Assigned(Items[aID].cFormRef);
        if Assigned(FAfterCallEvent) then
           FAfterCallEvent(3,aID,Items[aID].Ident,aOwner,aRef,L_resSign);
       end;
    end;
end;

function TExActionDict.CallProcRef(aID: Integer; aSndr: TObject; aRef: Pointer): Boolean;
var L_resSign:integer;
begin
  Result := False;
  if ContainsKey(aID) then
    if (Items[aID].iProcRef <> nil) then
    begin
     L_resSign:=1;
     if Assigned(FBeforeCallEvent) then
        FBeforeCallEvent(0,aID,'',aSndr,aRef,L_resSign);
     if L_resSign>0 then
       begin
        Items[aID].iProcRef(aSndr, aRef);
        Result := True;
        if Assigned(FAfterCallEvent) then
           FAfterCallEvent(0,aID,Items[aID].Ident,aSndr,aRef,L_resSign);
       end;
    end;
end;

constructor TExActionDict.Create(const aDName: string);
begin
 inherited Create([doOwnsValues]);
 FName:=Trim(FName);
 FBeforeCallEvent:=nil;
 FAfterCallEvent:=nil;
end;

function TExActionDict.GetFromIdent(const AIdent: string): TexActionItem;
var
  i: Integer;
begin
  Result := nil;
  for i in Keys do
    if Items[i].Ident = AIdent then
    begin
      Result := Items[i];
      Break;
    end;
end;

function TExActionDict.DeleteFromIdent(const AIdent: string):Boolean;
var
  i,L_FirstIndex: Integer;
begin
  Result:=False;
  L_FirstIndex:=0;
  for i in Keys do
    if Items[i].Ident = AIdent then
    begin
      L_firstIndex:=i;
      Result:=False;
      Break;
    end;
 if Result then
    Remove(L_FirstIndex);
end;

function TExActionDict.DeleteItem(aID: Integer): Boolean;
begin
 Result:=False;
 if ContainsKey(aID) then
  begin
    Remove(aID);
    Result:=True;
  end;
end;

procedure TExActionDict.CallDataEvent(aID: Integer; aSender: TObject;
  aDataAr: Variant; aRef: Pointer);
begin
  if (ContainsKey(aID)=True) and (Assigned(aSender)=True) then
   if Assigned(Items[aID].dataEvent) then
    begin
      Items[aID].dataEvent(aSender,aDataAr,aRef);
    end;
end;

procedure TExActionDict.CallDataProc(aID: Integer; aDataAr:Variant; aRef: Pointer);
begin
  if ContainsKey(aID) then
    if Assigned(Items[aID].dataProc) then
    begin
      Items[aID].dataProc(aDataAr,aRef);
    end;
end;

{ TExtDataRecord }

procedure TExtDataRecord.SetEmpty;
begin
  dValue := null;
  dataType := 0;
  dRegime:=0;
  dStr := '';
  dID := 0;
  dResID := 0;
  dAltID:=0;
  dProcRef := nil;
  dEvent := nil;
  dObj := nil;
end;

{ tExtArrayRecord }

procedure tExtArrayRecord.SetEmpty;
var i:integer;
begin
 for i := Low(aRefs) to High(aRefs) do
    aRefs[i]:=nil;
end;

initialization
  ExtCollection := TExtIDCollection.Create;
  _ExActionDict := nil;
// ExActionDict:=TExActionDict.Create([doOwnsValues]);

finalization
  FreeAndNil(ExtCollection);

  FreeActionDict;

end.

