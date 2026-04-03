unit u_wDataTypes;
///
///
///  Типы CAllback процедур и типы данных этих процедур
///  используются в wAddFiles


interface

type
  TwProgressEvent = procedure(aType: integer; adataPtr: Pointer;
    var aContinueFlag: boolean) of object;

  /// aType - дублирует тип   -- 1..3.     ВАЖНО! - если тип <0  -  это просто проход по внутри
  ///                                                               функций при этом adataPtr=nil !!
  /// я добавил aType<0 в каждый! шаг функций, чтобы можно было прервать их выполнение,
  ///  изменив флаг aContinue
  ///
  ///  ПРИМЕР:   ищем по маске ключи в реестре - только если находим - вызывается cbProc с aType=2
  ///            а на каждом шаге цикла поиска вызывается cbProc(-2,nil, aContinueFlag)
  ///     т.о. можно отключить поиск в любой момент
  ///

  /// состояние операции - структура - общая для всех наследуемых классов baseCleanItem
  /// смысл - передать из функций рекурсивного поиска данные в класс и выше в событие при поиске (удалении-изменении)
  ///

  TwCleanRecord = packed record
    RecType: integer;
    /// 1 - файловая запись  2 - реестровая  3 - другая
    Regime: integer;
    /// 1 - добавление  2 - удаление 3 - изменение записи в таблице   0 - не определен для таблицы
    id: int64;
    /// внутренний код - например номер записи
    ///
    rowNum: int64;
    /// номер строки в таблице (непосредственный и текущий на момент запроса только лишь)
    ///
    CL_iD: integer;
    /// код ID для Clean
    pID: integer;
    /// условный код операции (например в реестре) - что нужно делать - только для реестра
    ///
    ///
    ///
    Size: int64;
    /// только для файлов и структур - размер в байтах
    Date: TDateTime;
    /// две даты (общий случай)
    mDate: TDateTime;
    State: integer;
    /// состояние Item
    Active: boolean;
    /// флаг активности Item
    Name: widestring;
    Desc: widestring;
    SizeStr: string;
    /// размер в "дружественной" форме   типа 12 Mb
    ///
    /// реестровая добавка
    HomekeyID: integer;
    /// код корневого ключа 0 CR   1 - CU и т.д.
    DtType: integer;
    /// тип переменной  =2 строка
    Value: widestring;
    /// значение параметра (или сам параметр) - см. pID
    wvalue: int64;
    /// не исп.   (кроме 10 - корзина - указываю кол-во файлов в ней)
  end;

  pwCleanRecord = ^TwCleanRecord;
  ///
procedure wCleanRec(var Tcrec: TwCleanRecord);

///
///
/// для других - непохожих на вышеприведенную - структур
///
///
type
  TwCleanAddRecord = packed record
    RecType: integer;
    /// 1 - файловая запись  2 - реестровая  3 - другая
    Regime: integer;
    /// 1 - добавление  2 - удаление 3 - изменение записи в таблице   0 - не определен для таблицы
    id: int64;
    /// внутренний код - например номер записи
    ///
    cData: array [0 .. 7] of string;
    /// строки - данные для столбцов
    Value: widestring;
    /// значение - обычно не используется
    Active: boolean;
    /// флаг активности записи
    Enable: boolean;
    /// флаг доступности записи
  end;

 pwCleanAddRecord =^TwCleanAddRecord;


procedure wCleanAddRec(var tcAddRec: TwCleanAddRecord);

/// ////////////////////////////////////////////////////////////////////////////////////////
///
/// для проверки на наличие в списке ИСКЛЮЧЕНИЙ
///
type
  TwCompExcludeEvent = procedure(aExType: integer; const aItemStr: string;
    var aContinueFlag: boolean) of object;
  /// aContinueFlag - true - если НЕ подтвердилось наличие в исключениях строки!
  ///
  /// это для вызова проверки получения результата сразу --  просто обертка
  /// true --  если строка НЕ НАЙДЕНА в ИСКЛЮЧЕНИЯХ!
function wCompExcludeStr(aExType: integer; const aItemStr: string;
  cbCompEvent: TwCompExcludeEvent): boolean;

implementation

procedure wCleanRec(var Tcrec: TwCleanRecord);
begin
  with Tcrec do
  begin
    RecType := 0;
    Regime := 0;
    id := 0;
    CL_iD := 0;
    pID := 0;
    Size := 0;
    Date := 0;
    mDate := 0;
    State := 0;
    Active := false;
    Name := '';
    Desc := '';
    ///
    HomekeyID := 1;
    DtType := 2;
    Value := '';
    wvalue := 0;
  end;
end;

procedure wCleanAddRec(var tcAddRec: TwCleanAddRecord);
var
  il: integer;
begin
  with tcAddRec do
  begin
    RecType := 3;
    Regime := 0;
    for il := Low(cData) to High(cData) do
      cData[il] := '';
    Value := '';
    Active := false;
    Enable := false;
  end;
end;

function wCompExcludeStr(aExType: integer; const aItemStr: string;
  cbCompEvent: TwCompExcludeEvent): boolean;
begin
  Result := true;
  if Assigned(cbCompEvent) then
    cbCompEvent(aExType, aItemStr, Result);
end;

end.
