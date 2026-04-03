unit u_wResources;

interface

uses System.Classes, System.SysUtils, Vcl.Forms, Data.DB, RzCommon, XSuperObject;

// ver 1.1

type
  TJsonDataEvent=procedure(Sender:Tobject; aRegime:Integer; aJsonObj:ISuperObject; aData:Variant; var aStatus:Integer) of object;

   function getMDIMainForm:Vcl.Forms.TForm;
   function getMdiForName(const aName:string):Vcl.Forms.TForm;
   function getMdiForClassName(const aClassName:string):Vcl.Forms.TForm;

   function FormatGuidStr(const aStr:string):string;
   function newGuidStr:string;
   function newGuidWithDivStr:string;

   function rpDateToStr(const ADate: TDateTime; aLowerCaseFlag,a00DayFlag:Boolean): string;
   function TimeToMinStr(const ADate: TDateTime): string;
   function defStrToDate(const aDtStr:string; aRg:Integer=1):TDateTime;
   function stringInCommaText(const aStr,aText:string):boolean;
   /// <summary>
   ///    получить кол-во дней в месяцах по расчету длительности
   ///  incDayRegime=1 включая день окончания - пока режим не работает
   /// </summary>
   function getMonthDays(aStartDate,aFinishDate:TDateTime; incDayRegime:Integer=0):Double;
   ///
   function stringIsEmailLogin(const aLoginStr:string; aMultiEmailFlag:boolean=false):Boolean;
   ///
   function DateTimeToJsonDbString(aDt:TDateTime; aTimeFlag:Boolean=True):string;
   function JsonDbValueToDateTime(const aDateStr:string):TDateTime;
    /// <summary>
   ///    вывести руб коп. на экран для суммы по hint - например из таблицы
   /// </summary>
   function correctCurrencyValue(aVal:Variant):string;
   ////
   /// <summary>
   ///    извлечь из строки 47 №003043401 от 16.05.2011 первую часть и дату
   /// </summary>
   function extractRegInfo(const aregInfo:string; var aRegParams:string; var aRegDate:TDateTime):Boolean;
   /// <summary>
   ///    извлечь из строки ФИО
   /// </summary>
   function extractFIO(const aFIO:string; var afamily,aName,aPat:string; aRg:Integer=1):Boolean;
   function convertFIOToBrief(const aFIO:string; aRg:Integer=1):string;
   function convertToFIO(const afamily,aName,aPat:string; aFullFlag:Boolean=false):string;
   function formatInfo(const aInfo:string; aFormatType:integer=1):string;
   ///
   /// <summary>
   ///   заменить первую букву на заглавную
   /// </summary>
   function upperFirstCharInString(const aSTr:string):string;
   function prepareFileNameStr(aRegime:Integer; const aStr:string):string;
   ///
   function stringIsJsonObject(const aStr:string):Boolean;
   function stringIsJsonArray(const aStr:string):Boolean;
   ///
   ///
   function saveJsonToFile(aJobj:ISuperObject; const aFileName:string):Boolean;
    /// <summary>
    ///     записать в реестр (или файл) раздел со спискoм полей из Json объекта
    /// </summary>
   function xJobjWriteToRegIniFile(const aRegIniFile:TRzRegIniFile; const aSectName:string; aJobj:ISuperObject):Boolean;
    /// <summary>
    ///     прочитать из реестра раздел со список полей и записать в Json объект с учетом типов!
    /// </summary>
   function xJobjReadFromRegIniFile(const aRegIniFile:TRzRegIniFile; const aSectName:string; aJobj:ISuperObject):Boolean;
    /// <summary>
    ///    записать текст в бинарном виде в ini
    /// </summary>
    procedure writeBinCStrToIni(const aRegIniFile:TRzRegIniFile; const aSect, aName, aStrValue: string);
    /// <summary>
    ///    прочитать текст из ini в бинарном виде
    /// </summary>
    function readBinCStrFromIni(const aRegIniFile:TRzRegIniFile; const aSect, aName,aDefStrValue: string): string;
    /// <summary>
    ///    прочитать закодированную строку из ini (кодировка сдвигом)
    /// </summary>
    function readCodeStringFromIni(const aRegIniFile:TRzRegIniFile; const aSect,aName:string;
      const aDefStrValue:string=''; aCodeShift:Integer=156):string;
    /// <summary>
    ///    записать закодированную строку в ini
    /// </summary>
    procedure writeCodeStringToIni(const aRegIniFile:TRzRegIniFile;
      const aSect,aName,aStrValue:string; aCodeShift:Integer=156);
    ///
    /// <summary>
    ///    запись полей в поля JSON
    /// </summary>
    function datasetToXJobj(aDS:TDataSet; const aFieldNames:string; aJobj:ISuperObject; aNotFlag:Boolean=false):Boolean;
    function datasetToXJobjString(aDS:TDataSet; const aFieldNames:string; aNotFlag:Boolean=false):string;
    /// <summary>
    ///    запись в поля
    /// </summary>
    function xJobjToDataset(aDS:TDataSet; const aFieldNames:string; aJobj:ISuperObject; aNotFlag:Boolean=false):Boolean;
     /// <summary>
     ///    загрузить из Json в Dataset все значения полей из структуры dataset - см. xJobjToDataset
     /// </summary>
    function fillJsonValuesToRecord(const aSrcJsonStr,aNotFieldNames:string; aDS:TDataSet):boolean;

    /// <summary>
    ///    добавить (заменить) в поля объекта поля включаемого объекта)
    /// </summary>
    function includeJsonToXObj(aJobj,aIncludeObj:ISuperObject):Boolean;
    ///
    /// <summary>
    ///    заполнить поля объекта Json из полей другого объекта - логика
    ///    1. если поля нет - добавлено 2. если поле есть и тип тот же - переустановить значение 3. если тип другой - попытка преобразовать
    /// </summary>
    function assignJsonToXObj(aSrcObj:ISuperObject; aDestObj:ISuperObject; aConvertTypesFlag:boolean=false):Boolean;
    ///
    function getUserSectionForName(const aSect:string; aUserID:Integer=0): string;
    /// <summary>
    ///    получить из ini-файла значение настройки пользователя программы - из ЕГО ветки настроек
    /// </summary>
    function loadUserValueFromIni(const aRegIniFile:TRzRegIniFile;
      const aKey,aValName:string; const aDefValue:string=''; aUserID:Integer=0):string;
    /// <summary>
    ///    записать в ini-файл значение настройки пользователя программы - из ЕГО ветки настроек
    /// </summary>
    procedure saveUserValueToIni(const aRegIniFile:TRzRegIniFile;
      const aKey,aValName,aVal:string; aUserID:Integer=0);

    function strMaxLen(const S: string; MaxLen: integer): string;
    function compareVersionStrings(const aver1,aver2:string; acompNumber:integer):Integer;
    /// <summary>
    ///   для поля отчетов - заполнить подстокой строку - например если символ *
    /// </summary>
    function fillStrWithSubStr(const subStr:string; aCount: integer): string;

    function getExceptStr(const aPlace:string; E:Exception; agetRegime:Integer=1):string;

    /// <summary>
    ///    использовать вложенность в полях Dataset при конвертировании в Json и обратно
    ///    (по умолч. =1 - т.е. если в поле лежит JsonObject - то его декодировать нужно вручную
    ///     если =2 - то из строки создается ПОДбъект
    /// </summary>
    function setConvertXObjLevel(aValue:Word):Boolean;
    ///
    var convertXObjLevel:word=1;

implementation

 uses System.Variants, System.DateUtils, System.IOUtils,  XSuperJSON, u_wCodeTrace,
    u_CryptoFuncs;



function strMaxLen(const S: string; MaxLen: integer): string;
 var
  i: Integer;
begin
   result := S;
   if Length(result)>MaxLen then
      Result:=Copy(S,1,MaxLen);
end;

function getExceptStr(const aPlace:string; E:Exception; agetRegime:Integer=1):string;
 begin
   Result:=E.ClassName+' : '+E.Message;
   if Length(aPlace)>0 then
      Result:=aPlace+' > '+Result;
 end;



function compareVersionStrings(const aver1,aver2:string; acompNumber:integer):Integer;
var L_ver1,L_ver2:array of Integer;
    ii:Integer;
    L_LIst:TStrings;
 begin
   Result:=0;
   SetLength(L_ver1,acompNumber);
   SetLength(L_ver2,acompNumber);
   for ii:=Low(L_ver1) to High(L_ver1) do
    begin
      L_ver1[ii]:=-1;
      L_ver2[ii]:=-1;
    end;
   L_LIst:=TStringList.Create;
   try
     L_LIst.StrictDelimiter:=False;
     L_LIst.Delimiter:='.';
     L_LIst.DelimitedText:=aver1;
     for ii:=0 to L_LIst.Count-1 do
         TryStrToInt(L_LIst.Strings[ii],L_ver1[ii]);
     L_LIst.DelimitedText:=aver2;
     for ii:=0 to L_LIst.Count-1 do
         TryStrToInt(L_LIst.Strings[ii],L_ver2[ii]);
     ///
     for ii:=Low(L_ver1) to High(L_ver1) do
      begin
        if (L_ver1[ii]>=0) and (L_ver2[ii]>=0) then
         begin
          if (L_ver1[ii]>L_ver2[ii]) then
           begin
              Result:=1;
              Break;
           end
          else
           if (L_ver1[ii]<L_ver2[ii]) then
             begin
              Result:=-1;
              Break;
           end
         end;
      end;
  finally
     L_LIst.Free;
   end;
 end;

 function fillStrWithSubStr(const subStr:string; aCount: integer): string;
 var ii:integer;
  begin
    Result:='';
    if aCount>0 then
     for ii:=1 to aCount do
      Result:=Result+subStr;
  end;


 function getMDIMainForm:Vcl.Forms.TForm;
 begin
   Result:=Application.MainForm;
 end;

function getMdiForName(const aName:string):Vcl.Forms.TForm;
var LMain:Vcl.Forms.TForm;
    ii:integer;
 begin
   Result:=nil;
   LMain:=getMDIMainForm;
   if Assigned(LMain) then
     with LMain do
       for ii:=MDIChildCount-1 downto 0 do
              if AnsiCompareText(MDIChildren[ii].Name,aName)=0 then
                begin
                 Result:=MDIChildren[ii];
                 Exit;
                end;
 end;


 function getMdiForClassName(const aClassName:string):Vcl.Forms.TForm;
var LMain:Vcl.Forms.TForm;
    ii:integer;
 begin
   Result:=nil;
   LMain:=getMDIMainForm;
   if Assigned(LMain) then
     with LMain do
       for ii:=MDIChildCount-1 downto 0 do
              if AnsiCompareText(MDIChildren[ii].ClassName,aClassName)=0 then
                begin
                 Result:=MDIChildren[ii];
                 Exit;
                end;
 end;

////////////////////////////////////////////////////////////////////

 function FormatGuidStr(const aStr:string):string;
 var i:integer;
     LS:string;
  begin
    Result:='';
    LS:=ChangeFileExt(aStr,'');
    for i:=1 to Length(LS) do
      if Not(LS[i] in ['{','}','[',']','-','_']) then
        Result:=Result+LS[i];
  end;

function newGuidStr:string;
 begin
   Result:=FormatGuidStr(GUIDToString(TGUID.NewGuid));
 end;

function newGuidWithDivStr:string;
  var i:integer;
     LS:string;
  begin
    Result:='';
    LS:=ChangeFileExt(GUIDToString(TGUID.NewGuid),'');
    for i:=1 to Length(LS) do
      if Not(LS[i] in ['{','}','[',']']) then
        Result:=Result+LS[i];
 end;

///////////////////////////////////////////////////////////////
function rpDateToStr(const ADate: TDateTime; aLowerCaseFlag,a00DayFlag:Boolean): string;
const
 MonthNames: array[1..12] of string = (
   'Января',
   'Февраля',
   'Марта',
   'Апреля',
   'Мая',
   'Июня',
   'Июля',
   'Августа',
   'Сентября',
   'Октября',
   'Ноября',
   'Декабря'
   );
var
 Day, Month, Year: WORD;
 LMonth:string;
 LDay:string;
begin
 DecodeDate(ADate, Year, Month, Day);
 LMonth:=MonthNames[Month];
 if aLowerCaseFlag then
    LMonth:=AnsiLowerCase(LMonth);
 if a00DayFlag then LDay:=FormatFloat('00', Day)
 else LDay:=IntToStr(Day);
 Result:=LDay+' '+LMonth+' '+IntToStr(Year);
end;

function TimeToMinStr(const ADate: TDateTime): string;
var Lminute:Word;
 begin
  Lminute:=MinuteOf(ADate);
  if Lminute=0 then Result:=FormatDateTime('h',ADate)
  else Result:=FormatDateTime('h:nn',ADate);
 end;

function defStrToDate(const aDtStr:string; aRg:Integer=1):TDateTime;
 var L_fs:TFormatSettings;
 begin
   Result:=0;
   try
    L_fs.dateseparator:='.';
    L_fs.timeseparator:=':';
    L_fs.ShortDateFormat:='dd.MM.yyyy';
    L_fs.ShortTimeFormat:='hh:nn:ss';
    Result:=StrToDate(aDtStr,L_fs);
    except on E:Exception do
     wLogE('defStrToDate Er',E);
   end;
 end;

function stringInCommaText(const aStr,aText:string):boolean;
 var L_List:TStrings;
     iL:integer;
 begin
   Result:=False;
   L_LIst:=TStringList.Create;
   try
     L_List.CommaText:=aText;
     iL:=0;
     while iL<L_List.Count do
      begin
        if AnsiSameText(L_List.Strings[iL],aStr) then
          begin
            Result:=True;
            Break;
          end;
        Inc(iL);
      end;
   finally
     L_List.Free;
   end;
 end;

function getMonthDays(aStartDate, aFinishDate: TDateTime; incDayRegime:Integer=0):Double;
var{ L_stM,L_stDays,L_finDays:Integer;
    L_dMonthDate,L_endMonth:TDateTime;
    L_startMonthDays,L_finishMonthDays:Integer;
    }
    L_st:Double;
    L_qstartDate,L_dt:TDateTime;
    L_y1,L_m1,L_d1:Word;
    L_M,L_D,L_y2,L_m2,L_d2:Word;
    L_montDays:integer;
begin
/// 1. День месяца - если 12.10  и 5.06 - то нужно вычесть 1мес. и сосчитать до 12.05  + разница дней между 5.06-12.05 / кол-во дней в 5 месяце
/// 2. если 12.10 и 15.06 - то взять разность месяцев и добавить разность дней 15-12 / кол-во дней в 6 месяце
 DecodeDate(aStartDate,L_y1,L_m1,L_d1);
 DecodeDate(aFinishDate,L_y2,L_m2,L_d2);
 if L_d2<L_d1 then
  begin
    L_qstartDate:=IncMonth(StartOfTheMonth(aFinishDate),-1);
    L_m2:=L_m2-1; // !
    if L_d1>1 then
       L_dt:=IncDay(L_qstartDate,L_d1-1)
    else L_dt:=L_qstartDate;
    L_D:=DaysBetween(aFinishDate,L_dt)+incDayRegime;
    L_montDays:=DaysInMonth(L_dt);
  end
 else
   begin
    L_D:=L_d2-L_d1+incDayRegime;
    L_montDays:=DaysInMonth(aFinishDate);
   end;
 L_st:=L_D/L_montDays;
 L_M:=(L_y2-L_y1)*12+L_m2-L_m1;
 Result:=L_M+L_st;
end;

function stringIsEmailLogin(const aLoginStr:string; aMultiEmailFlag:boolean=false):Boolean;
var i:integer;
    LS:string;
 begin
   Result:=False;
   i:=AnsiPos('@',aLoginStr);
   if (i>1) and (i<Length(aLoginStr)-2) then
    begin
     if aMultiEmailFlag then Result:=true
     else
      begin
       LS:=Copy(aLoginStr,i+1,MaxInt);
       Result:=(AnsiPos('@',LS)=0) and (AnsiPos('.',LS)>1);
      end;
    end;
 end;

function DateTimeToJsonDbString(aDt:TDateTime; aTimeFlag:Boolean=True):string;
 begin
   if aTimeFlag=false then
     Result:=FormatDateTime('YYYY-MM-DD',aDt)
   else
     Result:=FormatDateTime('YYYY-MM-DD hh:nn:ss',aDt);
 end;

function JsonDbValueToDateTime(const aDateStr:string):TDateTime;
var LDF:TFormatSettings;
 begin
  Result:=0;
  LDF.DateSeparator:='-';
  LDF.TimeSeparator:=':';
  LDF.ShortDateFormat:='YYYY-MM-DD';
  LDF.LongDateFormat:='YYYY-MM-DD hh:nn:ss';
 // '2022-08-25 00:00:00'
 // LDF.LongDateFormat:=
  TryStrToDateTime(aDateStr,Result,LDF);
 end;

 function correctCurrencyValue(aVal:Variant):string;
 var LS:string;
     i:integer;
     LVal:Double;
  begin
    if VarIsNull(aVal) then result:=''
    else
     if VarIsStr(aVal) then
       begin
         LS:=aVal;
         LVal:=0;
         for i:=1 to Length(LS) do
          if LS[i] in [',','.'] then
             LS[i]:=FormatSettings.DecimalSeparator;
         TryStrToFloat(Trim(LS),LVal);
         Result:=StringReplace(FormatFloat('#0.00',LVal),'.',',',[]);
       end
     else
      try
       Result:=StringReplace(FormatFloat('#0.00',aVal),'.',',',[]);
       except
        Result:='';
      end;
  end;
//////////////////////////////////////////////////////////////

function extractRegInfo(const aregInfo:string; var aRegParams:string; var aRegDate:TDateTime):Boolean;
var i:integer;
    LDateStr:string;
 begin
   Result:=false;
   i:=AnsiPos(' от ',aregInfo);
   if i>0 then
    begin
     aRegParams:=Trim(Copy(aregInfo,1,i-1));
     LDateStr:=Trim(Copy(aregInfo,i+4,MaxInt));
     ///
     aRegDate:=StrToDateDef(LDateStr,0);
     Result:=True;
    end;
 end;

function extractFIO(const aFIO:string; var afamily,aName,aPat:string; aRg:Integer=1):Boolean;
var LLIst:TStrings;
    i:integer;
 begin
   Result:=False;
   afamily:='';
   aName:='';
   aPat:='';
   LList:=TStringList.Create;
   try
     LLIst.StrictDelimiter:=False;
     LLIst.Delimiter:=' ';
     LLIst.DelimitedText:=aFIO;
     i:=0;
     while i<LLIst.Count do
      begin
        case i of
         0: afamily:=Trim(LList.Strings[i]);
         1: aName:=Trim(LList.Strings[i]);
         2: aPat:=Trim(LList.Strings[i]);
        end;
        Inc(i);
      end;
      Result:=(Length(aName)>0);
   finally
     LLIst.Free;
   end;
 end;

function convertFIOToBrief(const aFIO:string; aRg:Integer=1):string;
var Lfamily,LName,LPat:string;
 begin
   extractFIO(aFIO,Lfamily,LName,LPat,aRg);
   if Lfamily<>'' then
    begin
      Result:=Lfamily;
      if (LName<>'') then
       begin
         Result:=Result+' '+LName[1]+'.';
         if (LPat<>'') then
             Result:=Result+LPat[1]+'.';
       end;
    end
   else Result:=aFIO;
 end;

function convertToFIO(const afamily,aName,aPat:string; aFullFlag:Boolean=false):string;
 begin
   Result:=afamily;
   if Length(aName)>0 then
    begin
      if aFullFlag then
         Result:=Result+' '+aName
      else
         Result:=Result+' '+aName[1]+'.';
      if Length(aPat)>0 then
          if aFullFlag then
             Result:=Result+' '+aPat
          else
             Result:=Result+aPat[1]+'.';
    end;
 end;

 function formatInfo(const aInfo:string; aFormatType:integer=1):string;
  begin
    Result:=StringReplace(Trim(aInfo),'  ',' ',[rfReplaceAll]);
  end;

 function upperFirstCharInString(const aSTr:string):string;
 var ii:integer;
   begin
     ii:=Length(aSTr);
     case ii of
       0: Result:='';
       1: Result:=AnsiUpperCase(aSTr);
       else
          Result:=AnsiUpperCase(aSTr[1])+Copy(aSTr,2,MaxInt);
     end;
   end;

 function prepareFileNameStr(aRegime:Integer; const aStr:string):string;
 var ii,jj:Integer;
     L_notChars:TCharArray;
     L_notFlag:Boolean;
     LS:string;
  begin
    L_notChars:=TPath.GetInvalidFileNameChars;
    for ii:=1 to Length(aStr) do
      begin
        L_notFlag:=False;
        for jj:=Low(L_notChars) to High(L_notChars) do
          if aStr[ii]=L_notChars[jj] then
            begin
              L_notFlag:=True;
              Break;
            end;
        if L_notFlag=False then
           Result:=Result+aStr[ii];
      end;
    if aRegime=1 then
     begin
       LS:=Result;
       Result:='';
       for ii:=1 to Length(LS) do
         if // (LS[ii]='(') or (LS[ii]=')') or
            (LS[ii]='[') or (LS[ii]=']') or
            (LS[ii]='{') or (LS[ii]='}') or
            (LS[ii]='<') or (LS[ii]='>') then Result:=Result+'-'
         else
            if (LS[ii]=':') or (LS[ii]=';') then Result:=Result+' '
            else
             if (LS[ii]='.') and (ii=Length(LS)) then
                 Result:=Result
             else
               if (LS[ii]<>'!') and (LS[ii]<>'?')
                  then Result:=Result+LS[ii];
       Result:=Trim(Result);
     end;
    SetLength(L_notChars,0);
  end;

 function stringIsJsonObject(const aStr:string):Boolean;
var i:integer;
    LS:string;
 begin
   Result:=(Length(aStr)>1) and (aStr[1]='{') and (aStr[Length(aStr)]='}');
 end;

 function stringIsJsonArray(const aStr:string):Boolean;
var i:integer;
    LS:string;
 begin
   Result:=(Length(aStr)>1) and (aStr[1]='[') and (aStr[Length(aStr)]=']');
 end;

  /////////////////////////////////////////////////////////

  function saveJsonToFile(aJobj:ISuperObject; const aFileName:string):Boolean;
  var LStr:TFileStream;
   begin
     Result:=False;
     if aJobj<>nil then
      try
       LStr:=TFileStream.Create(aFileName,fmCreate);
       try
         aJobj.SaveTo(LStr);
         Result:=FileExists(aFileName);
         except on E:Exception do
           wLogE('saveJsonToFile',E);
       end;
      finally
       LStr.Free;
      end;
  end;


  function xJobjWriteToRegIniFile(const aRegIniFile:TRzRegIniFile; const aSectName:string; aJobj:ISuperObject):Boolean;
  var LSectionName,LValName:string;
      LDtype:XSuperJson.TDataType;
   begin
     Result:=false;
     LValName:='Value';
     try
       aJobj.First;
       while not(aJobj.EoF) do
        begin
         LSectionName:=aSectName+'\'+aJobj.CurrentKey;
         LDtype:=aJobj.CurrentValue.DataType;
         with aRegIniFile do
          begin
           case LDType of
             dtObject: WriteString(LSectionName,LValName,(aJobj.CurrentValue as ISuperObject).AsJSON);
             dtArray:  WriteString(LSectionName,LValName,(aJobj.CurrentValue as ISuperArray).AsJSON);
             dtString: WriteString(LSectionName,LValName,aJobj.S[aJobj.CurrentKey]);
             dtInteger: WriteInteger(LSectionName,LValName,aJobj.I[aJobj.CurrentKey]);
             dtFloat:  WriteString(LSectionName,LValName,FloatToStr(aJobj.F[aJobj.CurrentKey]));
             dtBoolean: WriteBool(LSectionName,LValName,aJobj.B[aJobj.CurrentKey]);
             dtDateTime: WriteString(LSectionName,LValName,DateTimeToStr(aJobj.D[aJobj.CurrentKey]));
             dtDate: WriteString(LSectionName,LValName,DateToStr(aJobj.Date[aJobj.CurrentKey]));
             dtTime: WriteString(LSectionName,LValName,TimeToStr(aJobj.Time[aJobj.CurrentKey]));
           end;
           if not (LDtype in [dtNil,dtNull]) then
             WriteInteger(LSectionName,'Type',Ord(LDType));
          end;
         aJobj.Next;
        end;
      except on E:Exception do
        wLogE('xJobjWriteToRegIniFile',E);
     end;
     Result:=True;
   end;

  function xJobjReadFromRegIniFile(const aRegIniFile:TRzRegIniFile; const aSectName:string; aJobj:ISuperObject):Boolean;
  var i,Ltype:integer;
      LKey,LS:string;
      L_rzRegIni:TRzRegIniFile;
      LDtype:XSuperJson.TDataType;
      LKeyList:TStrings;
      LNotValue,LDefValue:string;
      LIVal:Integer;
      LFVal:Extended;
      LDt:TDateTime;
   begin
     Result:=false;
    { LKeyList:=TStringList.Create;
     aRegIniFile.ReadSections(LKeyList);
     LKeyList.SaveToFile('hhhhh.txt');
     LKeyList.Free;
     }
   //  я не понял - но по имени секции всегда false :(
   //  if aRegIniFile.SectionExists(aSectName)=False then Exit;
     LNotValue:='**!*$';
     LKeyList:=TStringList.Create;
     L_rzRegIni:=TRzRegIniFile.Create(nil);
     try
       try
        L_rzRegIni.AutoUpdateIniFile:=false;
        L_rzRegIni.FileEncoding:=aRegIniFile.FileEncoding;
        L_rzRegIni.SpecialFolder:=aRegIniFile.SpecialFolder;
        L_rzRegIni.PathType:=aRegIniFile.PathType;
        L_rzRegIni.RegKey:=aRegIniFile.RegKey;
        L_rzRegIni.RegAccess:=[keyQueryValue,keyRead];
        L_rzRegIni.Path:=IncludeTrailingBackslash(aRegIniFile.Path)+aSectName;
        L_rzRegIni.ReadSections(LKeyList);
        i:=0;
        with L_rzRegIni do
         while i<LKeyList.Count do
          begin
           LKey:=LKeyList.Strings[i];
           if (ValueExists(LKey,'Type')) and (ValueExists(LKey,'Value')) then
             begin
              Ltype:=ReadInteger(LKey,'Type',-1);
              if (Ltype>=0) and (Ltype<=Ord(High(XSuperJson.TDataType))) then
                begin
                 LDtype:=XSuperJson.TDataType(Ltype);
                 case LDtype of
                 dtObject: begin
                             LS:=ReadString(LKey,'Value',LNotValue);
                             if (Length(LS)>=2) and (LS<>LNotValue) then
                                aJobj.O[LKey]:=SO(LS);
                           end;
                  dtArray: begin
                             LS:=ReadString(LKey,'Value',LNotValue);
                             if (Length(LS)>=2) and (LS<>LNotValue) then
                                aJobj.A[LKey]:=SA(LS);
                           end;
                 dtString: begin
                              LS:=ReadString(LKey,'Value',LNotValue);
                              if (LS<>LNotValue) then
                                aJobj.S[LKey]:=LS;
                           end;
                dtInteger: begin
                             LIVal:=ReadInteger(LKey,'Value',MaxInt);
                             if LIVal<MaxInt then
                                aJobj.I[LKey]:=LIVal;
                           end;
                  dtFloat: begin
                             LFVal:=-1e-65;
                             TryStrToFloat(ReadString(LKey,'Value',LNotValue),LFVal);
                             if LFVal>-1e-65 then
                                aJobj.F[LKey]:=LFVal;
                           end;
                dtBoolean: aJobj.B[LKey]:=ReadBool(LKey,'Value',false);
               dtDateTime: begin
                             LDt:=0;
                             TryStrToDateTime(ReadString(LKey,'Value','0'),LDt);
                             if LDt>100 then
                                aJobj.D[LKey]:=LDt;
                           end;
                   dtDate: begin
                             LDt:=0;
                             TryStrToDate(ReadString(LKey,'Value','0'),LDt);
                             if LDt>100 then
                                aJobj.Date[LKey]:=Ldt;
                           end;
                   dtTime: begin
                             LDt:=0;
                             TryStrToTime(ReadString(LKey,'Value','0'),LDt);
                             if LDt>0 then
                                aJobj.Time[LKey]:=LDt;
                           end;
                 end;
                end;
             end;
           Inc(i);
         end;
       Result:=(i>0);
       except on E:Exception do
        wLogE('xJobjReadFromRegIniFile',E);
       end;
     finally
       L_rzRegIni.Free;
       LKeyList.Free;
     end;
   end;

function xJobjToDataset(aDS:TDataSet; const aFieldNames:string; aJobj:ISuperObject; aNotFlag:Boolean=false):Boolean;
 var i:Integer;
    LList:TStrings;
    LFName,LVs:string;
 begin
   Result:=false;
   LList:=TStringList.Create;
   try
     LList.StrictDelimiter:=False;
     LList.CommaText:=LowerCase(aFieldNames);
    for i:=0 to aDS.FieldCount-1 do
     try
       LFName:=LowerCase(aDS.Fields[i].FieldName);
       if (aDS.Fields[i].ReadOnly=False) and
          (((aNotFlag=True) and (LList.IndexOf(LFName)<0)) or
          ((aNotFlag=False) and (LList.IndexOf(LFName)>=0))) then
          begin
           if (aJobj.Contains(LFName)) then
            begin
             Result:=True;
             case aDS.Fields[i].DataType of
              TFieldType.ftFloat,
              TFieldType.ftSingle,
              TFieldType.ftCurrency: aDS.Fields[i].AsFloat:=aJobj.F[LFName];
              TFieldType.ftAutoInc,
              TFieldType.ftInteger,
              TFieldType.ftWord,
              TFieldType.ftSmallint,
              TFieldType.ftLargeint,
              TFieldType.ftLongWord,
              TFieldType.ftShortint: aDS.Fields[i].AsInteger:=aJobj.I[LFName];
              TFieldType.ftTime:     aDS.Fields[i].AsDateTime:=aJobj.Time[LFName];
              TFieldType.ftDate:     aDS.Fields[i].AsDateTime:=aJobj.Date[LFName];
              TFieldType.ftDateTime: aDS.Fields[i].AsDateTime:=aJobj.D[LFName];
              TFieldType.ftString,
              TFieldType.ftMemo,
              TFieldType.ftWideString,
              TFieldType.ftWideMemo,
              TFieldType.ftFmtMemo: begin
                                      LVs:='';
                                      try
                                       if convertXObjLevel>1 then
                                        begin
                                         if (aJobj.Ancestor[LFName].DataType<>dtNil) then
                                          case aJobj.Ancestor[LFName].DataType of
                                           dtObject: LVs:=aJobj.O[LFName].AsJSON;
                                           dtArray: LVs:=aJobj.A[LFName].AsJSON;
                                           dtString: LVs:=aJobj.S[LFName];
                                           else
                                           if VarIsNull(aJobj.Ancestor[LFName].AsVariant)=False then
                                              LVs:=aJobj.Ancestor[LFName].AsVariant;
                                          end;
                                        end
                                       else LVs:=aJobj.S[LFName];
                                      except on E:Exception do
                                        wLogE('xJobjToDataset: ConvertError field='+LFName,E);
                                      end;
                                      aDS.Fields[i].AsWideString:=LVs;
                                    end;
              TFieldType.ftGuid: aDS.Fields[i].AsString:=aJobj.S[LFName];
              TFieldType.ftBoolean: aDS.Fields[i].AsBoolean:=aJobj.B[LFName];
              TFieldType.ftVariant: aDS.Fields[i].AsVariant:=aJobj.V[LFName];
             else aDS.Fields[i].Value:=aJobj.V[LFName];
            end;
            end;
          end;
       except on E:Exception do
        wLogE('xJobjToDataset',E);
     end;
   finally
     LList.Free;
   end;
  end;


function fillJsonValuesToRecord(const aSrcJsonStr,aNotFieldNames:string; aDS:TDataSet):boolean;
var L_obj:ISuperObject;
  begin
    Result:=False;
    if stringIsJsonObject(aSrcJsonStr) then
     try
      L_obj:=SO(aSrcJsonStr);
      Result:=xJobjToDataset(aDS,aNotFieldNames,L_obj,True);
     finally
      L_obj:=nil;
     end;
  end;



function includeJsonToXObj(aJobj,aIncludeObj:ISuperObject):Boolean;
 begin
   Result:=false;
   if aJobj<>nil then
     if aIncludeObj<>nil then
       begin
        aIncludeObj.First;
        while not(aIncludeObj.EoF) do
         try
           if aJobj.Contains(aIncludeObj.CurrentKey) then
             // if aJobj.DataType=aIncludeObj.CurrentValue.DataType then
                 aJobj.Remove(aIncludeObj.CurrentKey);
           aJobj.Add(aIncludeObj.CurrentKey,aIncludeObj.CurrentValue);
           aIncludeObj.Next;
          except on E:Exception do
            wLogE('includeJsonToXObj while_Err',E);
         end;
         Result:=True;
       end
     else Result:=False;
 end;

function assignJsonToXObj(aSrcObj:ISuperObject; aDestObj:ISuperObject; aConvertTypesFlag:boolean):Boolean;
var LKey:string;
    LV:Variant;
 begin
   Result:=false;
   if (aSrcObj<>nil) and (aDestObj<>nil) then
    begin
      aSrcObj.First;
      while not(aSrcObj.EoF) do
       begin
         LKey:=aSrcObj.CurrentKey;
         try
          if aConvertTypesFlag=false then
           begin
            if aDestObj.Contains(LKey) then
               aDestObj.Remove(LKey);
            aDestObj.Add(LKey,aSrcObj.CurrentValue);
            Result:=True;
           end
          else
           begin
             if aDestObj.Contains(LKey) then
              begin
               { if aSrcObj.CurrentValue.DataType=aDestObj.Ancestor[LKey].DataType then
                   aDestObj.Ancestor[LKey]:=aSrcObj.CurrentValue
                else
                }
                   try
                    LV:=aSrcObj.CurrentValue.AsVariant;
                    aDestObj.Ancestor[LKey].AsVariant:=LV;
                    Result:=True;
                   except on E:Exception do
                       wLogE('assignJsonToXObj convert_Error for Key='+LKey,E);
                   end;
              end;
           end;
          except on E:Exception do
            wLogE('assignJsonToXObj operation Err for Key='+LKey,E);
         end;
         aSrcObj.Next;
       end;
    end;

 end;


/////////////
////
procedure writeBinCStrToIni(const aRegIniFile:TRzRegIniFile; const aSect, aName, aStrValue: string);
var LStr:TStream;
    LS:string;
begin
  LS:=aStrValue;
  LStr:=TStringStream.Create(LS,TEncoding.UTF8);
  try
   aRegIniFile.WriteBinaryStream(aSect, aName,LStr);
  finally
    LStr.Free;
  end;
end;

function readBinCStrFromIni(const aRegIniFile:TRzRegIniFile; const aSect, aName,
  aDefStrValue: string): string;
var LStr:TStringStream;
    LS:string;
begin
  Result:=aDefStrValue;
  LStr:=TStringStream.Create('',TEncoding.UTF8);
  try
   aRegIniFile.ReadBinaryStream(aSect, aName,LStr);
   if LStr.Size>0 then
    begin
      LS:=LStr.DataString;
      Result:=LS;
    end;
  finally
    LStr.Free;
  end;
end;

function readCodeStringFromIni(const aRegIniFile:TRzRegIniFile;
     const aSect,aName:string; const aDefStrValue:string=''; aCodeShift:Integer=156):string;
var LS:string;
begin
  Result:=aDefStrValue;
  LS:='';
  LS:=aRegIniFile.ReadString(aSect,aName,LS);
  if Length(LS)>0 then
     Result:=ch_DecryptStr(LS,aCodeShift);
end;

procedure writeCodeStringToIni(const aRegIniFile:TRzRegIniFile;
  const aSect,aName,aStrValue:string; aCodeShift:Integer=156);
var LS:string;
begin
 if Length(aStrValue)>0 then
    LS:=ch_EncryptStr(aStrValue,aCodeShift)
 else LS:='';
 aRegIniFile.WriteString(aSect,aName,LS);
end;


function datasetToXJobj(aDS:TDataSet; const aFieldNames:string; aJobj:ISuperObject; aNotFlag:Boolean=false):Boolean;
var i:Integer;
    LList:TStrings;
    LFName,LVs:string;
 begin
   Result:=false;
   LList:=TStringList.Create;
   try
     LList.StrictDelimiter:=False;
     LList.CommaText:=LowerCase(aFieldNames);
    for i:=0 to aDS.FieldCount-1 do
     try
       LFName:=LowerCase(aDS.Fields[i].FieldName);
       if ((aNotFlag=True) and (LList.IndexOf(LFName)<0)) or
          ((aNotFlag=False) and (LList.IndexOf(LFName)>=0)) then
          begin
           Result:=True;
            case aDS.Fields[i].DataType of
             TFieldType.ftFloat,
             TFieldType.ftSingle,
             TFieldType.ftCurrency: aJobj.F[LFName]:=aDS.Fields[i].AsFloat;
             TFieldType.ftAutoInc,
             TFieldType.ftInteger,
             TFieldType.ftWord,
             TFieldType.ftSmallint,
             TFieldType.ftLargeint,
             TFieldType.ftLongWord,
             TFieldType.ftShortint: aJobj.I[LFName]:=aDS.Fields[i].AsInteger;
             TFieldType.ftTime:     aJobj.Time[LFName]:=aDS.Fields[i].AsDateTime;
             TFieldType.ftDate:     aJobj.Date[LFName]:=aDS.Fields[i].AsDateTime;
             TFieldType.ftDateTime: aJobj.D[LFName]:=aDS.Fields[i].AsDateTime;
             TFieldType.ftString,
             TFieldType.ftMemo,
             TFieldType.ftWideString,
             TFieldType.ftWideMemo,
             TFieldType.ftFmtMemo: begin
                                     try
                                      LVs:=aDS.Fields[i].AsWideString;
                                      if convertXObjLevel>1 then
                                        begin
                                          if stringIsJsonObject(LVs) then
                                             aJobj.O[LFName]:=SO(LVs)
                                          else
                                            if stringIsJsonArray(LVs) then
                                               aJobj.A[LFName]:=SA(LVs)
                                            else
                                              aJobj.S[LFName]:=LVs;
                                        end
                                      else
                                        aJobj.S[LFName]:=LVs;
                                      except on E:Exception do
                                          wLogE('datasetToXJobj: convertError field='+LFName,E);
                                      end
                                   end;
             TFieldType.ftGuid: aJobj.S[LFName]:=aDS.Fields[i].AsString;
             TFieldType.ftBoolean: aJobj.B[LFName]:=aDS.Fields[i].AsBoolean;
             TFieldType.ftVariant: aJobj.V[LFName]:=aDS.Fields[i].AsVariant;
             else aJobj.V[LFName]:=aDS.Fields[i].Value;
            end;
          end;
       except on E:Exception do
        wLogE('datasetToXJobj',E);
     end;
   finally
     LList.Free;
   end;
 end;

 function datasetToXJobjString(aDS:TDataSet; const aFieldNames:string; aNotFlag:Boolean=false):string;
 var L_Jobj:ISuperObject;
  begin
    Result:='';
    L_Jobj:=SO('{}');
    try
     if datasetToXJobj(aDS,aFieldNames,L_Jobj,aNotFlag) then
      begin
        Result:=L_Jobj.AsJSON;
        if Result='{}' then Result:='';
      end;
    finally
      L_Jobj:=nil;
    end;
  end;

function getUserSectionForName(const aSect:string; aUserID:Integer=0): string;
begin
 if Length(aSect)=0 then
    Result:='user_'+IntToStr(aUserID)
 else
    Result:='user_'+IntToStr(aUserID)+'\'+aSect;
end;


function loadUserValueFromIni(const aRegIniFile:TRzRegIniFile;
 const aKey, aValName: string; const aDefValue:string=''; aUserID:Integer=0):string;
var LkeyName:string;
begin
  Result:=aDefValue;
  if aUserID<0 then
     LkeyName:=getUserSectionForName(aKey)
  else
     if Length(aKey)=0 then
        LkeyName:='user_'+IntToStr(aUserID)
     else
        LkeyName:='user_'+IntToStr(aUserID)+'\'+aKey;
  Result:=aRegIniFile.ReadString(LkeyName,aValName,aDefValue);
end;

procedure saveUserValueToIni(const aRegIniFile:TRzRegIniFile;
   const aKey, aValName,aVal: string; aUserID: Integer=0);
var LkeyName:string;
begin
  if aUserID<0 then
     LkeyName:=getUserSectionForName(aKey)
  else
     if Length(aKey)=0 then
        LkeyName:='user_'+IntToStr(aUserID)
     else
        LkeyName:='user_'+IntToStr(aUserID)+'\'+aKey;
  try
    aRegIniFile.WriteString(LkeyName,aValName,aVal);
   except on E:Exception do
    wLogE(Format('saveUserValueToIni_Error: Key=%s, Name=%s, Val=%s',
    [LkeyName,aValName,aVal]),E);
  end;
end;

function setConvertXObjLevel(aValue:Word):Boolean;
 begin
   convertXObjLevel:=aValue;
   Result:=(convertXObjLevel>=0) and (convertXObjLevel<3);
 end;

initialization

  convertXObjLevel:=1;


end.
