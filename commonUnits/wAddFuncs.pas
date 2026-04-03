unit wAddFuncs;
///
///
///  СВОДНЫЙ модуль функций по работе с реестром и файлами - адаптация для wincleaner
///

interface

uses System.SysUtils, System.Classes, Winapi.Windows,
  u_wDatatypes,  // !
  System.Win.registry;

/// СompareText  c вхождением строки в строку  независимо от регистра символов
/// причем только сначала строки!
function wLeftFoundSubStr(const ASubStr, aStr: string): boolean;
///
///
/// сокращение файлового имени в строке
function wa_TruncFileName(const aStr: string; aMaxLen: integer): string;
///
///  сокращение реестрового ключа или переменной   обязат первые пять символов - это ключ ветки реестра "HKCU\"
function wa_TruncRegValue(const aStr: string; aMaxLen: integer):string;
///
/// темп директорий
function wa_GetTempDirectory(): String;

/// каталог винды
function wa_GetWindowsDirectory(): String;

/// разные каталоги
function wa_GetSpecialFolderPath(afolder: integer): string;
/// параметр aFolder
/// есть в модуле  SHlobj
/// см.
/// Winapi.ShlObj   -->>  Line 9330 !
///
{ const
  CSIDL_DESKTOP = $0000;
  // Виртуальный каталог, представляющий Рабочий стол. (Корень в проводнике)
  CSIDL_INTERNET = $0001;
  // Виртуальный каталог для Internet Explorer.
  CSIDL_PROGRAMS = $0002;
  // Меню Пуск -&gt; Программы
  CSIDL_CONTROLS = $0003;
  // Виртуальный каталог, содержащий иконки пунктов панели управления
  CSIDL_PRINTERS = $0004;
  // Виртуальный каталог, содержащий установленные принтеры
  CSIDL_PERSONAL = $0005;
  // Виртуальный каталог, представляющий папку "Мои документы"
  // До Vista ссылался на каталог "Мои документы" на жёстком диске
  CSIDL_FAVORITES = $0006;
  // Избранное. (обычно C:\Documents and Settings\username\Favorites)
  CSIDL_STARTUP = $0007;
  // Пуск -&gt; Программы -&gt; Автозагрузка
  CSIDL_RECENT = $0008;
  // Недавние документы (обычно C:\Documents and Settings\username\My Recent Documents
  // Для добавления ссылки документа используйте SHAddToRecentDocs
  CSIDL_SENDTO = $0009;
  // Папка, содержащая ярлыки меню "Отправить" (Sent to...)
  //(обычно C:\Documents and Settings\username\SendTo)
  CSIDL_BITBUCKET = $000a;
  // Виртуальный каталог, содержащий файлы в корзине текущего пользователя
  CSIDL_STARTMENU = $000b;
  // Элементы меню Пуск текущего пользователя
  //(обычно C:\Documents and Settings\username\Start Menu)
  CSIDL_DESKTOPDIRECTORY = $0010;
  // Рабочий стол текущего пользователя (обычно C:\Documents and Settings\username\Desktop)
  CSIDL_DRIVES = $0011;
  // Виртуальный каталог, представляющий папку "Мой компьютер"
  CSIDL_NETWORK = $0012;
  // Виртуальный каталог, представляющий "Сетевое окружение"
  CSIDL_NETHOOD = $0013;
  // Папка "My Nethood Places" (обычно C:\Documents and Settings\username\NetHood)
  // В неё ссылки на избранные расшаренные ресурсы
  CSIDL_FONTS = $0014;
  // Папка, содержащая установленные шрифты. (обычно C:\Windows\Fonts)
  CSIDL_TEMPLATES = $0015;
  // Шаблоны документов. (Обычно Settings\username\Templates)
  CSIDL_COMMON_STARTMENU = $0016;
  // Элементы меню Пуск для всех пользователей.
  //(обычно C:\Documents and Settings\All Users\Start Menu)
  // Константы, начинающиеся на CSIDL_COMMON_ существуют только в NT версиях
  CSIDL_COMMON_PROGRAMS = $0017;
  // Меню Пуск -&gt; программы для всех пользователей
  //(обычно C:\Documents and Settings\All Users\Start Menu\Programs)
  CSIDL_COMMON_STARTUP = $0018;
  // Меню Пуск -&gt; Программы -&gt; Автозагрузка для всех пользователей
  //(обычно C:\Documents and Settings\All Users\Start Menu\Programs\Startup)
  CSIDL_COMMON_DESKTOPDIRECTORY = $0019;
  // Элементы Рабочего стола для всех пользователей
  //(обычно C:\Documents and Settings\All Users\Desktop)
  CSIDL_APPDATA = $001a;
  // Папка, в которой программы должны хранить свои данные
  //(C:\Documents and Settings\username\Application Data)
  CSIDL_PRINTHOOD = $001b;
  // Установленные принтеры.
  //(обычно C:\Documents and Settings\username\PrintHood)
  CSIDL_ALTSTARTUP = $001d; // DBCS
  // user's nonlocalized Startup program group. Устарело.
  CSIDL_COMMON_ALTSTARTUP = $001e; // DBCS
  // Устарело
  CSIDL_COMMON_FAVORITES = $001f;
  // Ссылки "Избранное" для всех пользователей
  CSIDL_INTERNET_CACHE = $0020;
  // Временные Internet файлы
  //(обычно C:\Documents and Settings\username\Local Settings\Temporary Internet Files)
  CSIDL_COOKIES = $0021;
  // Папка для хранения Cookies (обычно C:\Documents and Settings\username\Cookies)
  CSIDL_HISTORY = $0022;
  // Хранит ссылки интернет истории IE
  ///
  /////////   Дополнительные константы - их нет в ShObj
  CSIDL_ADMINTOOLS = $30;
  // Административные инструменты текущего пользователя (например консоль MMC). Win2000+
  CSIDL_CDBURN_AREA = $3b;
  // Папка для файлов, подготовленных к записи на CD/DVD
  // Обычно
  //C:\Documents and Settings\username\Local Settings\Application Data\Microsoft\CD Burning)
  ///
  CSIDL_COMMON_ADMINTOOLS = $2f;
  // Папка, содержащая инструменты администрирования
  CSIDL_COMMON_APPDATA = $23;
  // Папка AppData для всех пользователей.
  //(обычно C:\Documents and Settings\All Users\Application Data)
  ///
  CSIDL_COMMON_DOCUMENTS = $2e;
  // Папка "Общие документы" (обычно C:\Documents and Settings\All Users\Documents)
  CSIDL_COMMON_TEMPLATES = $2d;
  // Папка шаблонов документов для всех пользователей
  //(Обычно C:\Documents and Settings\All Users\Templates)
  ///
  CSIDL_COMMON_MUSIC = $35;
  // Папка "Моя музыка" для всех пользователей.
  //(обычно C:\Documents and Settings\All Users\Documents\My Music)
  ///
  CSIDL_COMMON_PICTURES = $36;
  // Папка "Мои рисунки" для всех пользователей.
  //(обычно C:\Documents and Settings\All Users\Documents\My Pictures)
  ///
  CSIDL_COMMON_VIDEO = $37;
  // Папка "Моё видео" для всех пользователей
  //(C:\Documents and Settings\All Users\Documents\My Videos)
  ///
  CSIDL_COMPUTERSNEARME = $3d;
  // Виртуальная папка, представляет список компьютеров в вашей рабочей группе
  ///
  CSIDL_CONNECTIONS = $31;
  // Виртуальная папка, представляет список сетевых подключений
  ///
  CSIDL_LOCAL_APPDATA = $1c;
  // AppData для приложений, которые не переносятся на другой компьютер
  //(обычно C:\Documents and Settings\username\Local Settings\Application Data)
  ///
  CSIDL_MYDOCUMENTS = $0c;
  // Виртуальный каталог, представляющий папку "Мои документы"
  ///
  CSIDL_MYMUSIC = $0d;
  // Папка "Моя музыка"
  ///
  CSIDL_MYPICTURES = $27;
  // Папка "Мои картинки"
  ///
  CSIDL_MYVIDEO = $0e;
  // Папка "Моё видео"
  ///
  CSIDL_PROFILE = $28;
  // Папка пользователя (обычно C:\Documents and Settings\username)
  ///
  CSIDL_PROGRAM_FILES = $26;
  // Папка Program Files (обычно C:\Program Files)
  ///
  CSIDL_PROGRAM_FILESX86 = $2a;
  ///
  CSIDL_PROGRAM_FILES_COMMON = $2b;
  // Папка Program Files\Common (обычно C:\Program Files\Common)
  ///
  CSIDL_PROGRAM_FILES_COMMONX86 = $2c;
  ///
  CSIDL_RESOURCES = $38;
  // Папка для ресерсов. Vista и выше (обычно C:\Windows\Resources)
  ///
  CSIDL_RESOURCES_LOCALIZED = $39;
  ///
  CSIDL_SYSTEM = $25;
  // Папака System (обычно C:\Windows\System32 или C:\Windows\System)
  ///
  CSIDL_SYSTEMX86 = $29;
  ///
  CSIDL_WINDOWS = $24;
  // Папка Windows. Она же %windir% или %SYSTEMROOT% (обычно C:\Windows)
  //////////////////////////////////////////////////////////////////////////////////////////
  ////
  ///   взято из http://www.sqldoc.net/get-system-folder-in-delphi.html
  ///
}
/// получить строку с размером в байтах, Кбайтах и прочее
function wa_BytesFriendlyStr(const aBytes: int64; aPrec:Integer=2): string;
function wa_BytesFriendlyStrMLang(aRuFlag: boolean; const aBytes: int64; aPrec: Integer = 2): string;
///
/// из сплошной строки вытащить дату с разделителем  20120608  год сначала
function wa_FormatDateFromFillString(const aFStr: string;
  const aSep: string = '/'): string;
///
///
/// для повторного вызова можно использовать флаги (чтобы не обращаться к dll лишний раз
///
/// Определить 64
function wa_Is64Sys(aRegime: integer = 0): boolean;
///
/// версия WIN
procedure wa_GetWindowsVersion(var Major: integer; var Minor: integer);
/// определить версию Windows  - краткая строка
function wa_GetWindowsVersionStr(aRegime: integer = 1): string;
///
/// xp=5  vista=6 win7 =7 win8=8      aRG=1
function wa_GetWindowsVersionNum(aRg,aMajor,aMinor: integer): integer;
///
/// получить версию файла
procedure wa_GetFileVersion(FileName: string; var Major1, Major2, Minor1,
  Minor2: integer);
/// получить строку с ФАйловой версией
function wa_GetFileVersionToStr(const aFileName: string;
  const aDelim: string = '.'): string;
///
///
/// РЕЕСТР - реконструктор
///
/// замена стандартного конструктора на свой - смотри реализацию   crRegime - различные
/// =0  - полный доступ к реестру для 64 и 32
/// =2 - только чтение
function wa_CreateRegistry(aCrRegime: integer): TRegistry;

///
/////////////////
///
///
/// поиск файлов
///
///
/// проверка наличия файла
function wa_AngryFileExists(const aFileName: string): boolean;

/// Внимание!  - ручная установка флага редирекшн - использовать с осторожностью и try-finally !
/// заканчивать всегда нужно TRUE!
function wa_AngrySetFlag(aNewFlag: boolean): boolean;

/// аналогично проврека каталога без переадресации
function wa_AngryDirectoryExists(const aDirectoryname: string): boolean;
///
/// проверить файл по путям окружения - для случаев файла без указания каталога и не в SYS32
function wa_FileInEnviromentPathsExists(const aFileName: string): boolean;

///
/// только в каталоге
// function wa_FindFilesOnlyInDir(const aDirmask:string; const ADS:Tdataset):boolean;
///
///
/// найти размер файлов в каталоге и подкаталогах
function wa_GetDirKSizeAndCount(const aPath, aMask: string;
  var aSize: double): int64;
///
/// с подкаталогами
///
/// aFindRegime: 0 - все файлы  по маске
/// 1 - кроме указанных имен
/// 2 - кроме content.dat
function wa_FindFiles(aFindRegime: integer; const aPath, aMask: string;
  const AExcpList: Tstrings; cbproc: TwProgressEvent;
  cbExcludeEvent: TwCompExcludeEvent; ArecurFlag: boolean = true): boolean;

function wa_FindAllFiles(aFindRegime: integer; const aPath, aMask: string;
  const AExcpList: Tstrings; cbproc: TwProgressEvent;
  cbExcludeEvent: TwCompExcludeEvent; ArecurFlag: boolean = true): boolean;

/// удалить по маске файлы в каталоге   - исключение 1 файл
function wa_DeleteFilesFromMask(const aDir, aMask, aExcludeFilename
  : string): boolean;

/// очистить внутри каталог
function wa_ClearDir(const aDir:string;  selfDeleteFlag:Boolean=false):Boolean;
/// замена путей вида %%%  на полные
function wa_ReplaceEnvironmentString(const aStr: string;
    aUserRepl: boolean = true): string;

/// / поиск ярлыков программъ
function wa_findFilesFromLinks(aFindRegime: integer; const aPath, aMask: string;
  const AExcpList: Tstrings; cbproc: TwProgressEvent;
  cbExcludeEvent: TwCompExcludeEvent): boolean;

/// /////////////////
///
/// реестровые
///
/// получить ID и наоборот вытащить Hkey
function wa_findRegRootkey(const aStr: string; var aHKey: HKey): string;
function wa_GetRegRootkeyID(const aHKey: HKey): integer;
function wa_GetRegRootkey(aID: integer): HKey;
function wa_GetRegRootkeyIDFromStr(const aStr: string): integer;
function wa_GetRegRootkeyStr(aID: integer): string;
/// например 'HKCU'  - для работы с параметром hkey в ключах реестра
///
///
/// подсчет общего (без проверки условий) количества параметров по ключу с рекурсией
function wa_GetValuesCount(const aKeyStr: string;
  ArecurFlag: boolean = true): int64;
///
/// проверить - есть ли сам ключ
function wa_RegKeyExists(const aKeyStr: string; aReadFlag: boolean): boolean;
///
/// найти значение параметра (строковое)   ='' если не найдено  '-' - если пустое
function wa_GetRegValue(const adirKeyStr, aName: string;
  ArecurFlag: boolean = false): string;
/// узнать и выставить состояние в AutoRun programs
 function wa_GetAutoRunState(const aProgramName:string; cuFlag:boolean):boolean;
 function wa_SetAutoRunState(const aProgramName,aAppFileValue:string; cuFlag:boolean):boolean;
 function wa_DeleteAutoRunState(const aProgramName:string; cuFlag:boolean):boolean;
///  для ветки WoW6432
 function wa_GetAutoRunWOWState(const aProgramName:string):boolean;
 function wa_SetAutoRunWOWState(const aProgramName,aAppFileValue:string):boolean;
 function wa_DeleteAutoRunWOWState(const aProgramName:string):boolean;


/// aFindRegime  0 - если есть ключ
/// 1 - проверка ненулевого значения
/// 2 - проверка файлов ( например для библиотек и каталогов)
///

function wa_FindInReg(aFindRegime: integer; const aKeyStr: string;
  cbproc: TwProgressEvent; ArecurFlag: boolean = true): boolean;

///
/// удаление ключа aRootKeyID - 0..6  из таблицы
function wa_DeleteKeyInReg(const AregObj: Tobject; aRootKeyID: integer;
  const aKeyStr: string): boolean;
///
///
/// удаление параметра из таблицы
function wa_DeleteParamInReg(const AregObj: Tobject; aRootKeyID: integer;
  const aKeyStr, aParamStr: string): boolean;
///
///
/// поиск некорректных расширений в реестре
function wa_FindInvExtensionInReg(const aKeyStr: string;
  cbproc: TwProgressEvent): boolean;
/// пустые ключи в HKCR
function wa_FindInvExtensionInHKCRReg(cbproc: TwProgressEvent): boolean;
///
/// найти количество параметров по ключу (информационное)
function wa_CountParamsInReg(const aKeyStr: string): integer;
/// удаление всех параметров ключа в реестре
function wa_ClearParamsInReg(const aKeyStr: string): boolean;

///
///   считать переменную в реестре с проверкой типа по Try Except  -
///   КЛЮЧ должен быть открыт!
function wa_ReadIntegerFromReg(const aReg:Tregistry; const aValueName:string; const aDefValue:integer=-1):integer;
function wa_ReadStringFromReg(const aReg:Tregistry; const aValueName:string; const aDefStr:string=''):string;
///
///
/// Дополнительные файловые
///
/// получить имя файла из строки ярлыка вида: "C:\Program Files (x86)\2345Pic\2345PicViewer.exe" "%1"
function wa_ExtractFullFilenameFromStr(const aStr: string): string;
///
/// реестр
///
function wa_FindErrorsInHKCR(aFindRegime: integer;
  cbproc: TwProgressEvent): boolean;
///
/// поиск несуществующих шрифтов
function wa_FindErrorsInFonts(aFindRegime: integer; const aKeyStr: string;
  cbproc: TwProgressEvent): boolean;
///
///
/// поиск путей приложений - разделено на 2 части
function wa_FindAppPaths1(aFindRegime: integer; const aKeyStr: string;
  cbproc: TwProgressEvent): boolean;
///
function wa_FindAppPaths_Values(aFindRegime: integer; const aKeyStr: string;
  cbproc: TwProgressEvent): boolean;
///
///
/// поиск только по указанному ключу - перебор всех значений и проверка на наличие указанных в их именах файлов
/// принцип - файл - это имя    значение параметра - это путь
/// aP_id   p_ID
function wa_FindRegValuePathFiles(aFindRegime, aP_id: integer;
  const aKeyStr: string; cbproc: TwProgressEvent): boolean;
///
///
/// проверка путей в реестре по именам параметров
function wa_FindRegValueInstallPaths(aFindRegime, aP_id: integer;
  const aKeyStr: string; cbproc: TwProgressEvent): boolean;
///
/// по Uninstall
function wa_FindRegValueUnInstall(aFindRegime, aP_id: integer;
  const aKeyStr: string; cbproc: TwProgressEvent): boolean;
///
///
/// пустые ключи с пустым набором параметров
///
function wa_FindEmptyKeys(aFindRegime, aP_id: integer; const aKeyStr: string;
  cbproc: TwProgressEvent): boolean;
/// /
/// найти несуществующие файлы (по значенимя параметров (любых) реестра
function wa_FindRegDataFiles(aFindRegime, aP_id: integer; const aKeyStr: string;
  cbproc: TwProgressEvent): boolean;
///
/// то же -- но имя файла = имени параметра
function wa_FindRegNameFiles(aFindRegime, aP_id: integer; const aKeyStr: string;
  cbproc: TwProgressEvent): boolean;

/// получить информацию об exe файле
/// оказалось, что этот вариант некорректно возвращает инфу для языков  - function wa_GetversionInformation(const aExeFilename:string; const aList:TStrings):boolean;
function wa_GetversionInfo(const aExeFilename: string;
  const aList: Tstrings): boolean;

/// проверка возможности записи файла или записи на диск
///
/// диск
function wa_IsDriveReady(DriveLetter: char): bool;
///
function wa_IsCreateFile(const aFileName: string): boolean;
///
/// путь к папке AppData
function wa_GetAppdataFolder: string;
///
///
/// проверить флаг доступности системы точек восстановления
/// HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsNT\CurrentVersion\SystemRestore
function wa_GetRegRestorePointsState(agetRg: integer): integer;

///
///  частота процессора - вернее тактов
function wa_GetPerfFrequency:int64;
function wa_GetPerfCounter:int64;
///
///  каталог винды (вариант)
function wa_aWinDir:string;
///  корневой путь
function wa_GetSysDiskPath:string;
/// буква системного диска
function wa_GetSysDisk:char;
function wa_aSysDisk:char; assembler; // быстрый вариант через путь библиотек ntdll и kernel32
///
function wa_GetDiskSizes(const aDisk:string; var aTotalMb,aFreeMb:double):boolean;
/// ниже надстройка с определением системного диска и вычислением по функции выше
  function wa_GetSystemDiskSizes(var aTotalMb,aFreeMb:double):boolean;

///  дополнено от 04/09/2014

/// создать каталог в папке юзера Roaming  с названием  приложения
///  0 - успешно создан каталог - иначе ошибка (например нет прав доступа) - 10
function wa_CreateAppCurrentUserDirectory(const nAppName:string; var aResultDir:string; aRegime:Integer=0):Integer;
///
///  дополнено от 15/09/2014
///   память в Mб
function wa_GetGlobalMemorySizes(var aTotalMb,aFreeMb:double):boolean;
 /// <summary>
 ///    корректировка часового пояса
 /// </summary>
function CorrectTimeForTimeZone(aDt:TDatetime; aServerHourShift:Integer=0):TDateTime;

function wa_getDownloadsPath:string;

function GetProcessByEXE(exename: string): THandle;
// https://translated.turbopages.org/proxy_u/en-ru.ru.7b9e27f9-69c3deed-f155a3bb-74722d776562/https/stackoverflow.com/questions/59444919/delphi-how-can-i-get-list-of-running-applications-with-starting-path
function GetFullPathForPID(Pid:Cardinal) : UnicodeString;
/// <summary>
///  проверить именно из указанного пути - запущен ли файл в процессах
///  false также в случае ошибки внутри
/// </summary>
function IsRunForFullFileName(const aExeFileName: string):Boolean;

function get_FileSize(const fileName :String) : Int64;

implementation

uses SHFolder, Data.DB,
  /// для ярлыков
  ComObj, ActiveX, ShlObj,
  /// для логирования
 // u_wCodeSite,
  System.SyncObjs,
  TlHelp32,
  System.IOUtils,
  System.DateUtils; // for UnixDatetime


/// //////////////////////////////////////////////////////////////////////////
///
/// строковые и файловые
///

function wLeftFoundSubStr(const ASubStr, aStr: string): boolean;
begin
  Result := (Pos(AnsiUpperCase(ASubStr), AnsiUpperCase(aStr)) = 1);
end;

function wa_TruncFileName_old(const aStr: string; aMaxLen: integer;
  aiRg: integer = 0): string;
var
  L_id, il, iMin, iCurr: integer;
  L_HomeStr: string;
begin
  Result := aStr;
  if Length(aStr) > aMaxLen then
  begin
    L_id := Pos(':', aStr);
    if (L_id > 0) and (L_id < 25) and (L_id < Length(aStr)) then
      L_HomeStr := Copy(aStr, Low(aStr), L_id + 1)
    else
      L_HomeStr := '';
    Result := '';
    iCurr := 0;
    il := Length(aStr) - 1;
    iMin := il - aMaxLen + Length(L_HomeStr) + 2;
    while (il > 0) do
    begin
      if (aStr[il] = PathDelim) or (aStr[il] in ['\', '/']) then
        iCurr := il;
      if il < iMin then
      begin
        if iCurr = 0 then
          Result := Copy(aStr, il + 1, Length(aStr) - il)
        else
          Result := Copy(aStr, iCurr, Length(aStr) - iCurr + 1);
        break;
      end;
      Dec(il);
    end;
    ///
    if Length(Result) > 1 then
      Result := Concat(L_HomeStr, '..', Result)
    else if (Length(aStr) > iMin) then
      Result := Concat(L_HomeStr, Copy(aStr, iMin, Length(aStr) - iMin))
    else
      Result := Copy(aStr, Length(aStr) - aMaxLen);
    // wCodeSite.SendMsg('wa_TruncFileName: trunc<'+'Result='+Result);
  end;
end;

 function CopyR(const LLSS:string; aLL:Integer):string;
   var ii:Integer;
     begin
       Result:='';
       ii:=Length(LLSS);
       while ii>(Length(LLSS)-aLL) do
        begin
          Result:=LLSS[ii]+result;
          Dec(ii);
        end;
     end;

function wa_TruncFileName(const aStr: string; aMaxLen: integer): string;
var
  L_HomeStr,L_EndStr: string;
begin
  Result := aStr;
  if Length(aStr) > aMaxLen then
  begin
    L_HomeStr:=Concat(ExtractFileDrive(aStr),PathDelim);
    L_EndStr:=ExtractFileName(aStr);
    if Length(L_HomeStr)+Length(L_EndStr)>=amaxLen-3 then
       begin
         L_EndStr:=CopyR(L_EndStr,aMaxLen-3-Length(L_HomeStr));
         Result:=Concat(L_HomeStr,'...',L_endStr);
       end
    else
     begin
      L_HomeStr:=ExtractFilePath(aStr);
      if Length(L_HomeStr)+Length(L_EndStr)>=amaxLen-3 then
        begin
          L_HomeStr:=Copy(L_HomeStr,1,aMaxLen-3-Length(L_EndStr));
          Result:=Concat(L_HomeStr,'..',PathDelim,L_endStr);
        end;
     end;
  // wCodeSite.SendMsg('wa_TruncFileName:<'+'Result='+Result+'||'+IntToStr(Length(Result)));
 // if Length(Result)>80 then raise Exception.Create('Error asddgfsdgsdf   Message');
  end;
end;

function wa_TruncRegValue(const aStr: string; aMaxLen: integer):string;
 var L_HomeStr,L_EndStr: string;
 begin
    Result:=aStr;
    Result := aStr;
    if Length(aStr) > aMaxLen then
     begin
      L_HomeStr:=Copy(aStr,1,5);
      L_EndStr:=CopyR(aStr,aMaxLen-7);
      Result:=Concat(L_HomeStr,'..',L_endStr);
    //  wCodeSite.SendMsg('wa_TruncRegValue:<'+'Result='+Result+'||'+IntToStr(Length(Result)));
     end;
 end;

function wa_GetTempDirectory(): String;
var
  tempFolder: array [0 .. MAX_PATH] of char;
begin
  GetTempPath(MAX_PATH, @tempFolder);
  Result := StrPas(tempFolder);
end;

function wa_GetTempDirectory1(): wideString;
var
  l: cardinal;
  s: wideString;
begin
  l := GetTempPath(0, PwideChar(s));
  SetLength(s, l);
  GetTempPath(l, PwideChar(s));
  Result := s;
end;

function wa_GetWindowsDirectory(): String;
var
  WindirP: PChar;
  Res: cardinal;
begin
  Result := '';
  WindirP := StrAlloc(MAX_PATH);
  Res := GetWindowsDirectory(WindirP, MAX_PATH);
  if Res > 0 then
    Result := StrPas(WindirP);
  StrDispose(WindirP);
end;

///
function wa_GetSpecialFolderPath(afolder: integer): string;
const
  SHGFP_TYPE_CURRENT = 0;
var
  path: array [0 .. MAX_PATH] of char;
begin
  if SUCCEEDED(SHGetFolderPath(0, afolder, 0, SHGFP_TYPE_CURRENT, @path[0]))
  then
    Result := path
  else
    Result := '';
end;

{ faReadOnly - файлы, у которых установлен аттрибут "Только для чтения".
  faHidden - файлы, у которых установлен атрибут "Скрытые".
  faSysFile - файлы, у которых установлен атрибут "Системный".
  faArchive - файлы, у которых установлен атрибут "Архивный".
  faDirectory - директория. То есть поиск поддиректорий в директории.
  faAnyFile - любой файл (в том числе и faDirectory, и faVolumeID).
}

(* function wa_FindFilesOnlyInDir(const aDirmask:string; const ADS:Tdataset):boolean;
  var
  F: TSearchRec;
  LPath: string;
  Attr: Integer;
  begin
  LPath :=aDirmask;
  { имеют атрибуты}
  Attr := faHidden + faArchive + faSysFile;
  FindFirst(LPath, Attr, F);
  {Если хотя бы один файл найден, то продолжить поиск}
  if F.name <> '' then
  begin
  ADS.Append;
  ADS.FieldByName('NAME').AsWideString:=F.Name;
  ADS.FieldByName('SIZE').AsFloat:=F.Size*0.001;
  ADS.FieldByName('DATE').AsDateTime:=FileDateToDateTime(F.Time);
  ADS.FieldByName('STATE').AsInteger:=1; // !!`
  ADS.post; //
  end;
  SYSTEM.SysUtils.FindClose(F);
  end;
*)

function wa_BytesFriendlyStr(const aBytes: int64; aPrec:Integer=2): string;
var Lpp:string;
begin
  if aBytes<0 then
   begin
     Result:='-';
     exit;
   end;
  if aBytes < 1024 then
  begin
    Result := Format('%s', [IntToStr(aBytes)]) + '';
    Exit;
  end;
  Lpp:=IntToStr(aPrec);
  if (aBytes >= 1024) and (aBytes < (1024 * 1024)) then
  begin
    Result := Format('%.'+Lpp+'n', [aBytes / 1024]) + ' Kb';
    Exit;
  end;
  if (aBytes >= (1024 * 1024)) and (aBytes < (1024 * 1024 * 1024)) then
  begin
    Result := Format('%.'+Lpp+'n', [aBytes / (1024 * 1024)]) + ' Mb';
    Exit;
  end;
  if aBytes >= (1024 * 1024 * 1024) then
  begin
    Result := Format('%.'+Lpp+'n', [aBytes / (1024 * 1024 * 1024)]) + ' Gb';
    Exit;
  end;
end;

function wa_BytesFriendlyStrMLang(aRuFlag: boolean; const aBytes: int64; aPrec: Integer = 2): string;
var
  Lpp: string;
  LB, LKb, LMb, LGb: string;
begin
  if aRuFlag then
  begin
    LB := ' байт';
    LKb := ' Кбайт';
    LMb := ' Мбайт';
    LGb := ' Гбайт';
  end
  else
  begin
    LB := ' b';
    LKb := ' Kb';
    LMb := ' Mb';
    LGb := ' Gb';
  end;
  if aBytes < 0 then
  begin
    Result := '-';
    exit;
  end;
  if aBytes < 1024 then
  begin
    Result := Format('%s', [IntToStr(aBytes)]) + LB;
    Exit;
  end;
  Lpp := IntToStr(aPrec);
  if (aBytes >= 1024) and (aBytes < (1024 * 1024)) then
  begin
    Result := Format('%.' + Lpp + 'n', [aBytes / 1024]) + LKb;
    Exit;
  end;
  if (aBytes >= (1024 * 1024)) and (aBytes < (1024 * 1024 * 1024)) then
  begin
    Result := Format('%.' + Lpp + 'n', [aBytes / (1024 * 1024)]) + LMb;
    Exit;
  end;
  if aBytes >= (1024 * 1024 * 1024) then
  begin
    Result := Format('%.' + Lpp + 'n', [aBytes / (1024 * 1024 * 1024)]) + LGb;
    Exit;
  end;
end;



function wa_FormatDateFromFillString(const aFStr: string;
  const aSep: string = '/'): string;
var
  LS: string;
  il: integer;
begin
  Result := '';
  LS := Trim(aFStr);
  if LS = '' then
    Exit;
  il := Low(LS);
  while il <= Length(LS) do
  begin
    Result := Concat(Result, LS[il]);
    if il in [4, 6] then
      Result := Concat(Result, aSep);
    Inc(il);
  end;
end;

procedure GetDirSize_Alt(const aPath: string; var SizeDir: int64;
  var ANum: int64);
var
  SR: TSearchRec;
  LPath: string;
begin
  LPath := IncludeTrailingBackSlash(aPath);
  if FindFirst(LPath + '*.*', faAnyFile, SR) = 0 then
  begin
    try
      repeat
        if (SR.Name = '.') or (SR.Name = '..') then
          Continue;
        if ((SR.Attr and faDirectory) <> 0) and
          ((SR.Attr and System.SysUtils.faReadonly) = 0) then
        begin
          GetDirSize_Alt(LPath + SR.Name, SizeDir, ANum);
          Continue;
        end;
        SizeDir := SizeDir + (SR.FindData.nFileSizeHigh shl 32) +
          SR.FindData.nFileSizeLow;
        Inc(ANum);
      until FindNext(SR) <> 0;
    finally
      System.SysUtils.FindClose(SR);
    end;
  end;
end;

procedure GetDirSize1(const aPath, aMask: string; var SizeDir, ANum: int64);
var
  SR: TSearchRec;
  LPath, LFname: string;

begin
  LPath := aPath;
  if (LPath[Length(LPath)] = '\') then
    SetLength(LPath, Length(LPath) - 1);
  ///
  if DirectoryExists(LPath) = false then
    Exit;
  if FindFirst(LPath + '\' + '*.*', faDirectory, SR) = 0 then
    try
      repeat
        if (SR.Attr and (faDirectory) = faDirectory) and (SR.Name <> '.') and
          (SR.Name <> '..') and (SR.Attr and (faVolumeID) = 0) then
          GetDirSize1(LPath + '\' + SR.Name, aMask, SizeDir, ANum);
      until FindNext(SR) <> 0;
    finally
      System.SysUtils.FindClose(SR);
    end;
  ///
  if FindFirst((LPath + '\' + aMask), faAnyFile - faDirectory, SR) = 0 then
    try
      repeat
        if (SR.Attr and System.SysUtils.faReadonly) = 0 then
        begin
          LFname := LPath + '\' + SR.Name;
          SizeDir := SizeDir + (SR.FindData.nFileSizeHigh shl 32) +
            SR.FindData.nFileSizeLow;
          Inc(ANum);
        end;
      until FindNext(SR) <> 0;
    finally
      System.SysUtils.FindClose(SR);
    end;
end;

function wa_FileTimeToDateTime(FileTime: TFileTime): TDateTime;
var
  ModifiedTime: TFileTime;
  SystemTime: TSystemTime;
begin
  Result := 0;
  if (FileTime.dwLowDateTime = 0) and (FileTime.dwHighDateTime = 0) then
    Exit;
  try
    FileTimeToLocalFileTime(FileTime, ModifiedTime);
    FileTimeToSystemTime(ModifiedTime, SystemTime);
    Result := SystemTimeToDateTime(SystemTime);
  except
    Result := Now; // Something to return in case of error
  end;
end;

function wa_DateTimeToFileTime(FileTime: TDateTime): TFileTime;
var
  LocalFileTime, Ft: TFileTime;
  SystemTime: TSystemTime;
begin
  Result.dwLowDateTime := 0;
  Result.dwHighDateTime := 0;
  DateTimeToSystemTime(FileTime, SystemTime);
  SystemTimeToFileTime(SystemTime, LocalFileTime);
  LocalFileTimeToFileTime(LocalFileTime, Ft);
  Result := Ft;
end;

function wa_GetDirKSizeAndCount(const aPath, aMask: string;
  var aSize: double): int64;
var
  LSize, LNum: int64;
begin
  Result := 0;
  LSize := 0;
  LNum := 0;
  GetDirSize1(aPath, aMask, LSize, LNum);
  aSize := LSize * 0.001;
  Result := LNum;
end;


// Function Wow64DisableWow64FsRedirection(x:Pointer):bool; stdcall; external 'Kernel32.dll' name 'Wow64DisableWow64FsRedirection';
// Function Wow64RevertWow64FsRedirection(x:boolean):boolean; stdcall; external 'Kernel32.dll' name 'Wow64RevertWow64FsRedirection';

function wa_AngryFileExists(const aFileName: string): boolean;
var
  SR: TSearchRec;
  p: Pointer;
  LDr: string;
  ///
type
  L_typeDisableRR = Function(x: Pointer): boolean; stdcall;
  L_typeEnableRR = Function(x: boolean): boolean; stdcall;
  L_typeRevertRR = Function(x: boolean): boolean; stdcall;
  ///
var
  L_WDisable: L_typeDisableRR;
  L_WEnable: L_typeEnableRR;
  L_WRevert: L_typeRevertRR;
begin
  p := nil;
  Result := false;
  ///
  LDr := ExtractFileDrive(aFileName);
  if LDr <> '' then
  begin
    if LDr[Length(LDr)] <> PathDelim then
      LDr := Concat(LDr, PathDelim);
    try
      if GetDriveType(PChar(LDr)) <> DRIVE_FIXED then
      begin
       // wCodeSite.SendWarning('wa_AngryFileExists - disk not exists=' + LDr);
        Exit;
      end;
    except
    end;
  end;
  ///
  L_WDisable := nil;
  L_WRevert := nil;
  // @L_WDisable:=GetProcAddress(GetModuleHandle(kernel32),'Wow64DisableWow64FsRedirection');
  L_WEnable := GetProcAddress(GetModuleHandle(kernel32),
    'Wow64EnableWow64FsRedirection');
  // @L_WRevert:=GetProcAddress(GetModuleHandle(kernel32),'Wow64RevertWow64FsRedirection');
  ///
  if (Assigned(@L_WEnable) = true) then
  /// and (Assigned(@L_WRevert)=true) then
  begin
    ///
    try
      if L_WEnable(false) then
      begin
        Result := (FindFirst(aFileName, faAnyFile, SR) = 0);
      end
      else
        Result := (FindFirst(aFileName, faAnyFile, SR) = 0);
    finally
      L_WEnable(true); // !
      System.SysUtils.FindClose(SR);
    end;
  end
  else
  begin
    Result := (FindFirst(aFileName, faAnyFile, SR) = 0);
    System.SysUtils.FindClose(SR);
  end;
end;

function wa_AngrySetFlag(aNewFlag: boolean): boolean;
type
  L_typeEnableRR = Function(x: boolean): boolean; stdcall;
  ///
var
  L_WEnable: L_typeEnableRR;
begin
  L_WEnable := GetProcAddress(GetModuleHandle(kernel32),
    'Wow64EnableWow64FsRedirection');
  Result := L_WEnable(aNewFlag);
end;

function wa_AngryDirectoryExists(const aDirectoryname: string): boolean;
var
  SR: TSearchRec;
  p: Pointer;
  iAtt: integer;
  ///
type
  L_typeDisableRR = Function(x: Pointer): boolean; stdcall;
  L_typeEnableRR = Function(x: boolean): boolean; stdcall;
  L_typeRevertRR = Function(x: boolean): boolean; stdcall;
  ///
var
  L_WDisable: L_typeDisableRR;
  L_WEnable: L_typeEnableRR;
  L_WRevert: L_typeRevertRR;
begin
  p := nil;
  Result := false;
  iAtt := faAnyFile; // !!~~~
  ///
  L_WDisable := nil;
  L_WRevert := nil;
  // @L_WDisable:=GetProcAddress(GetModuleHandle(kernel32),'Wow64DisableWow64FsRedirection');
  L_WEnable := GetProcAddress(GetModuleHandle(kernel32),
    'Wow64EnableWow64FsRedirection');
  // @L_WRevert:=GetProcAddress(GetModuleHandle(kernel32),'Wow64RevertWow64FsRedirection');
  ///
  if (Assigned(@L_WEnable) = true) then
  /// and (Assigned(@L_WRevert)=true) then
  begin
    ///
    try
      if L_WEnable(false) then
      begin
        Result := (FindFirst(aDirectoryname, iAtt, SR) = 0);
      end
      else
        Result := (FindFirst(aDirectoryname, iAtt, SR) = 0);
    finally
      L_WEnable(true); // !
      System.SysUtils.FindClose(SR);
    end;
  end
  else
  begin
    Result := (FindFirst(aDirectoryname, iAtt, SR) = 0);
    System.SysUtils.FindClose(SR);
  end;
end;

function wa_GetpathEnvVar: string;
var
  i: integer;
begin
  Result := '';
  try
    i := GetEnvironmentVariable('PATH', nil, 0);
    if i > 0 then
    begin
      SetLength(Result, i);
      GetEnvironmentVariable('PATH', PChar(Result), i);
    end;
  except
    Result := '';
  end;
end;

function wa_FileInEnviromentPathsExists(const aFileName: string): boolean;
var
  LLISt: Tstrings;
  il: integer;
  LS: string;
begin
  Result := false;
  if Trim(aFileName) = '' then
    Exit;
  if ExtractFilePath(aFileName) <> '' then
    Exit; // ?
  LLISt := TstringList.Create;
  try
    LLISt.StrictDelimiter := true;
    LLISt.Delimiter := ';';
    LLISt.DelimitedText := wa_GetpathEnvVar;
    il := 0;
    while il < LLISt.Count do
    begin
      LS := Concat(LLISt.Strings[il], PathDelim, aFileName);
      if wa_AngryFileExists(LS) = true then
      begin
        Result := true;
        break;
      end;
      Inc(il);
    end;
  finally
    LLISt.Free;
  end;
end;

/// есть ли в списке имя файла?
function wa_FindFileinList(const aFileName: string;
  const aExnames: Tstrings): boolean;
var
  il: integer;
  LS: string;
  LFlag: boolean;
begin
  Result := false;
  il := 0;
  while il < aExnames.Count do
  begin
    LS := aExnames.Strings[il];
    if (LS[Length(LS)] = '*') then
    begin
      SetLength(LS, Length(LS) - 1);
      LFlag := true;
    end
    else
      LFlag := false;
    ///
    if ((LFlag = false) and (AnsiCompareText(aFileName, LS) = 0)) or
      ((LFlag = true) and (wLeftFoundSubStr(LS, aFileName))) then
    begin
      Result := true;
      break;
    end;
    Inc(il);
  end;
end;

/// файл находится по указанным в списке путям или файл сам есть в списке
/// при этом используются включения в каталогах - если запрещен каталог то и все подкаталоги тоже
function wa_FileIncludePaths(const aFileName: string;
  const aExnames: Tstrings): boolean;
var
  il: integer;
  LS: string;
  LFlag: boolean;
begin
  Result := false;
  il := 0;
  while il < aExnames.Count do
  begin
    LS := aExnames.Strings[il];
    if (LS[Length(LS)] = '*') then
    begin
      SetLength(LS, Length(LS) - 1);
      LFlag := true;
    end
    else
      LFlag := false;
    ///
    if (wLeftFoundSubStr(LS, aFileName)) then
    begin
      Result := true;
      break;
    end;
    Inc(il);
  end;
end;

function wa_FindFiles(aFindRegime: integer; const aPath, aMask: string;
  const AExcpList: Tstrings; cbproc: TwProgressEvent;
  cbExcludeEvent: TwCompExcludeEvent; ArecurFlag: boolean = true): boolean;

{
  Path  - путь поиска
  maska - маска поиска
  recur - true  - искать и в подкаталогах
  false - искать только в указанной папке
  sl    - список найденных файлов
}
var
  SR: TSearchRec;
  LPath, LFname: string;
  L_RunFlag: boolean;
  L_wrec: TwCleanRecord;
begin
  Result := false;

  // wCodeSite.EnterMethod('wa_FindFiles');
  if Assigned(cbproc) = false then
    L_RunFlag := true; // !
  LPath := aPath;
  if (LPath[Length(LPath)] = '\') then
    SetLength(LPath, Length(LPath) - 1);
  /// ADS.DisableControls;
  try
    if (FindFirst(LPath + '\' + aMask, faAnyFile, SR) = 0) then
    begin
      if ((SR.Attr or faDirectory) = SR.Attr) and
        (wa_FindFileinList(SR.Name, AExcpList) = false) and
        (wCompExcludeStr(1, SR.Name, cbExcludeEvent) = true) then
      begin
        if (ArecurFlag = true) then
        begin
          if (SR.Name <> '.') and (SR.Name <> '..') and
            (SR.Attr and (faVolumeID) = 0) then
            wa_FindFiles(aFindRegime, LPath + '\' + SR.Name, aMask, AExcpList,
              cbproc, cbExcludeEvent, ArecurFlag);
        end
      end
      else if ((SR.Attr and System.SysUtils.faReadonly) = 0) and
        (wa_FindFileinList(SR.Name, AExcpList) = false) and
        (wCompExcludeStr(1, SR.Name, cbExcludeEvent) = true)
      /// !!
      then
      /// ((sr.Attr shr 1)shl 1)=sr.Attr then  /// faReadOnly=$1
      begin
        LFname := LPath + '\' + SR.Name;
        if Assigned(cbproc) then
        begin
          wCleanRec(L_wrec);
          L_wrec.RecType := 1;
          /// files
          L_wrec.id := 0;
          L_wrec.Regime := 0;
          L_wrec.CL_ID := 0;
          L_wrec.pID := 0;
          L_wrec.Size := SR.Size;
          try
           L_wrec.Date := FileDateToDateTime(SR.Time);
           except L_wrec.Date :=SR.TimeStamp;
          end;
          L_wrec.mDate := SR.TimeStamp;
          L_wrec.State := 1;
          L_wrec.Active := true;
          L_wrec.Name := LFname;
          L_wrec.desc := '';
          cbproc(1, Addr(L_wrec), L_RunFlag);
        end;
        if L_RunFlag = false then
          Exit; // !
      end;
      ///
      ///
      while FindNext(SR) = 0 do
        ///
         cbproc(-1,nil,L_RunFlag);  //
         if L_RunFlag = false then Exit;
        ///
        if (SR.Attr or faDirectory) = SR.Attr then
        begin
          if (ArecurFlag = true) then
          begin
            if (SR.Name <> '.') and (SR.Name <> '..') and
              (SR.Attr and (faVolumeID) = 0) and
              (wa_FindFileinList(SR.Name, AExcpList) = false) and
              (wCompExcludeStr(2, SR.Name, cbExcludeEvent) = true) // !
            then
              wa_FindFiles(aFindRegime, LPath + '\' + SR.Name, aMask, AExcpList,
                cbproc, cbExcludeEvent, ArecurFlag);
          end
        end
        else if ((SR.Attr and System.SysUtils.faReadonly) = 0) and
          (wa_FindFileinList(SR.Name, AExcpList) = false) and
          (wCompExcludeStr(1, SR.Name, cbExcludeEvent) = true) then
        begin
          LFname := LPath + '\' + SR.Name;
          if Assigned(cbproc) then
          begin
            L_wrec.id := 0;
            L_wrec.Regime := 0;
            L_wrec.CL_ID := 0;
            L_wrec.pID := 0;
            L_wrec.Size := SR.Size;
            L_wrec.Date := FileDateToDateTime(SR.Time);
            L_wrec.mDate := SR.TimeStamp;
            L_wrec.State := 1;
            L_wrec.Active := true;
            L_wrec.Name := LFname;
            L_wrec.desc := '';
            cbproc(1, Addr(L_wrec), L_RunFlag);
            if L_RunFlag = false then
              Exit; // !
          end;
        end;
    end;
    Result := true;
  finally
    System.SysUtils.FindClose(SR);
    // wCodeSite.ExitMethod('wa_FindFiles');
    // ADS.EnableControls;
  end;
end;

function wa_FindAllFiles(aFindRegime: integer; const aPath, aMask: string;
  const AExcpList: Tstrings; cbproc: TwProgressEvent;
  cbExcludeEvent: TwCompExcludeEvent; ArecurFlag: boolean = true): boolean;
{
  Path  - путь поиска
  maska - маска поиска
  recur - true  - искать и в подкаталогах
  false - искать только в указанной папке
  sl    - список найденных файлов
}
var
  SR: TSearchRec;
  LPath, LFname: string;
  L_RunFlag: boolean;
  L_wrec: TwCleanRecord;
begin
  Result := false;
  if Assigned(cbproc) = false then
    L_RunFlag := true; // !
  LPath := aPath;
  if (LPath[Length(LPath)] = '\') then
    SetLength(LPath, Length(LPath) - 1);
  /// поиск подкаталогов для дальнейшего поиска в них
  if (ArecurFlag = true) then
    try
      if (FindFirst(LPath + PathDelim + '*.*', faAnyFile, SR) = 0) then
      begin
        repeat
          cbproc(-1,nil,L_RunFlag);
          if L_RunFlag = false then Exit;
          if ((SR.Attr and faDirectory) <> 0) then
          // если найденный файл - папка
          begin
            if ((SR.Name <> '.') and (SR.Name <> '..')) and
              (SR.Attr and (faVolumeID) = 0) and // игнорировать служебные папки
              (wa_FindFileinList(SR.Name, AExcpList) = false) then
            begin
              Result := wa_FindAllFiles(aFindRegime, LPath + '\' + SR.Name,
                aMask, AExcpList, cbproc, cbExcludeEvent);
            end;
          end;
        until FindNext(SR) <> 0;
      end;
    finally
      System.SysUtils.FindClose(SR);
    end;
  /// по маске только файлы данного каталога
  Result := wa_FindFiles(aFindRegime, aPath, aMask, AExcpList, cbproc,
    cbExcludeEvent, false);
end;

function wa_DeleteFilesFromMask(const aDir, aMask, aExcludeFilename
  : string): boolean;
var
  SR: TSearchRec;
  LPath: string;
begin
  Result := false;
{$I-}
  LPath := aDir;
  if (LPath <> '') and (LPath[Length(LPath)] = '\') then
    Delete(LPath, Length(LPath), 1);
  LPath := Concat(LPath, PathDelim);
  if FindFirst(Concat(LPath, aMask), faDirectory + faHidden + faSysFile +
    System.SysUtils.faReadonly + faArchive, SR) = 0 then
    repeat
      if (SR.Name = '.') or (SR.Name = '..') then
        Continue;
      if (SR.Attr and faDirectory <> faDirectory) then
      begin
        if (aExcludeFilename = '') or (aExcludeFilename <> SR.Name) then
        begin
          FileSetReadOnly(LPath + SR.Name, false);
          System.SysUtils.DeleteFile(LPath + SR.Name);
          Result := true;
        end;
      end
      until FindNext(SR) <> 0;
      System.SysUtils.FindClose(SR);
{$I+}
    end;


function wa_ClearDir(const aDir:string; selfDeleteFlag:Boolean=false):Boolean;
 var
  SR: TSearchRec;
  LPath,LDir: string;
begin
  Result := false;
{$I-}
  LPath := aDir;
  if (LPath <> '') and (LPath[Length(LPath)] = '\') then
    Delete(LPath, Length(LPath), 1);
  LDir:=LPath;
  if DirectoryExists(LDir)=false then Exit;
  ///
  LPath := Concat(LPath, PathDelim);
  //
  if FindFirst(Lpath + '*.*', faAnyFile, sr) = 0 then
  begin
    repeat
      if sr.Attr and faDirectory = 0 then
      begin
        System.SysUtils.DeleteFile(Lpath + sr.name);
        Result:=True;
      end
      else
      begin
        if pos('.', sr.name) <= 0 then
          wa_ClearDir(Lpath + sr.name,true);
      end;
    until
      FindNext(sr) <> 0;
  end;
  System.SysUtils.FindClose(sr);
  if selfDeleteFlag then
     RemoveDirectory(PChar(LDir));
{$I+}
 end;

  /// ////////////////////////////////////////////////////////////////////
  /// /
  ///
  { **** UBPFD *********** by delphibase.endimus.com ****
    >> Получение имени файла из его ярлыка

    В параметре LinkFileName необходимо указать полное имя файлы-ярлыка.
    Функция возвратит полное имя файла, на который ссылается рассматриваемый ярлык

    Зависимости: ComObj, SysUtils, Windows, ActiveX, System, ShlObj
    Автор:       VID, vidsnap@mail.ru, ICQ:132234868, Махачкала
    Copyright:   некий FAQ... не помню какой
    Дата:        27 апреля 2002 г.
    ***************************************************** }

  function GetFileNamefromLink32(const LinkFileName: string): string;
  var
    MyObject: IUnknown;
    MySLink: IShellLink;
    MyPFile: IPersistFile;
    FileInfo32: TWin32FINDDATA;
    WidePath: array [0 .. MAX_PATH] of WideChar;
    Buff: array [0 .. MAX_PATH] of char;
    L_CritSection: TCriticalSection;
  begin
    Result := '';
    if (fileexists(LinkFileName) = false) then
      Exit;
    ///
    // L_CritSection:=TCriticalSection.Create;
    // L_CritSection.Acquire;
    try
      CoInitialize(nil);
      MyObject := CreateComObject(CLSID_ShellLink);
      MyPFile := MyObject as IPersistFile;
      MySLink := MyObject as IShellLink;
      StringToWideChar(LinkFileName, WidePath, SizeOf(WidePath));
      MyPFile.Load(WidePath, STGM_READ);
      ///
      MySLink.GetPath(Buff, MAX_PATH, FileInfo32, SLGP_UNCPRIORITY);
      /// MySLink.GetPath(Buff, Max_PATH, FileInfo32, SLGP_UNCPRIORITY);
      ///
      Result := Buff;
    finally
      // CoUninitialize;
      // L_CritSection.Release;
    end;
  end;

  function wa_GetFileNamefromLink(const LinkFileName: string): string;
  var
    LLISt: Tstrings;
    il: integer;
    LFlag: boolean;
  begin
    Result := GetFileNamefromLink32(LinkFileName);
    { if (wa_IS64Sys) then
      begin
      if (Pos('SYSTEM32',AnsiUppercase(Result))>0) then
      begin
      LFlag:=false;
      LList:=TStringList.Create;
      try
      /// непереадресуемые каталоги
      LList.Add('\system32\catroot');
      LList.Add('\system32\catroot2');
      //   LList.Add('\system32\driverstore');   //  ``
      LList.Add('\system32\drivers\etc');
      LList.Add('\system32\logfiles');
      LList.Add('\system32\spool');
      il:=0;
      while il<LList.Count do begin
      if Pos(UpperCase(LList.Strings[il]),AnsiUppercase(Result))>0 then
      begin
      LFlag:=true; break;
      end;
      Inc(il);
      end;
      if LFlag=false then
      Result:=StringReplace(Result,'System32','SysWOW64',[rfIgnoreCase]);
      finally
      LList.Free;
      end;
      end;
      end;
    }
  end;

  function wa_FileIsExe(const aFileName: string): boolean;
  var
    L_ext: string;
  begin
    Result := false;
    L_ext := ExtractFileExt(aFileName);
    if CompareText(L_ext, '.exe') = 0 then
      Result := true
    else if CompareText(L_ext, '.bat') = 0 then
      Result := true
    else if CompareText(L_ext, '.com') = 0 then
      Result := true
  end;

  /// /  заменить системные переменные %%%
  function wa_ReplaceEnvironmentString(const aStr: string;
    aUserRepl: boolean = true): string;
  var
    Buff: string;
    BuffSize: integer;
    ///
    L_S, L_res1: string;
  begin
    Result := '';
    ///
    begin
      L_res1 := AnsiUpperCase(aStr);
      if Pos('%USERPROFILE%', L_res1) > 0 then
        Result := StringReplace(aStr, '%USERPROFILE%',
          wa_GetSpecialFolderPath(CSIDL_PROFILE), [rfIgnoreCase]);
      if Pos('%SYSTEMROOT%', L_res1) > 0 then
        Result := StringReplace(aStr, '%SystemRoot%',
          wa_GetSpecialFolderPath(CSIDL_WINDOWS), [rfIgnoreCase])
      else if Pos('%WINDIR%', L_res1) > 0 then
        Result := StringReplace(aStr, '%windir%',
          wa_GetSpecialFolderPath(CSIDL_WINDOWS), [rfIgnoreCase]);
      if Pos('%ALLUSERSPROFILE%', L_res1) > 0 then
      begin
        L_S := StringReplace(wa_GetSpecialFolderPath(CSIDL_COMMON_TEMPLATES),
          '\Templates', '', [rfIgnoreCase]);
        Result := StringReplace(aStr, '%ALLUSERSPROFILE%', L_S, [rfIgnoreCase]);
      end;
      if Pos('%PROGRAMFILES%', L_res1) > 0 then
      begin
        Result := StringReplace(aStr, '%ProgramFiles%',
          wa_GetSpecialFolderPath(CSIDL_PROGRAM_FILES), [rfIgnoreCase]);
      end;
    end;
    ///
    if Result = '' then
    begin
      BuffSize := ExpandEnvironmentStrings(PChar(aStr), nil, 0);
      if BuffSize < 0 then
        RaiseLastWin32Error
      else if BuffSize > 0 then
      begin
        SetLength(Buff, BuffSize);
        if ExpandEnvironmentStrings(PChar(aStr), PChar(Buff), BuffSize) < 0 then
          RaiseLastWin32Error
        else
          Result := Buff;
        SetLength(Result, Length(Buff) - 1);
      end;
    end;
  end;

  /// проврека файла - если он в каталоге PROGRAM FILES - неизвестно 32 или 64
  function wa_x86Exists(const aFileName: string;
    aExistRegime: integer = 1): boolean;
  var
    LFname: string;
  begin
    Result := false;
    if (Pos('PROGRAM FILES (X86)', AnsiUpperCase(aFileName)) > 0) then
    begin
      LFname := StringReplace(aFileName, 'Program Files (x86)', 'Program Files',
        [rfIgnoreCase]);
      Result := fileexists(LFname);
      Exit;
    end;
    ///
  end;

  function wa_findFilesFromLinks(aFindRegime: integer;
    const aPath, aMask: string; const AExcpList: Tstrings;
    cbproc: TwProgressEvent; cbExcludeEvent: TwCompExcludeEvent): boolean;
  var
    SR: TSearchRec;
    LPath, LLinkname, LFname: string;
    L_RunFlag: boolean;
    L_wrec: TwCleanRecord;
    L_attr: integer;

  begin
    Result := false;
    if Assigned(cbproc) = false then
      L_RunFlag := true; // !
    LPath := aPath;
    if (LPath[Length(LPath)] = '\') then
      SetLength(LPath, Length(LPath) - 1);
    /// поиск подкаталогов для дальнейшего поиска в них
    try
      if FindFirst(LPath + PathDelim + '*.*', faAnyFile, SR) = 0 then
        repeat
          cbproc(-1,nil,L_RunFlag);
          if L_RunFlag = false then Exit;
          if ((SR.Name <> '.') and (SR.Name <> '..')) and
            (SR.Attr and (faVolumeID) = 0) and // игнорировать служебные папки
            (wa_FindFileinList(SR.Name, AExcpList) = false) then
          begin
            if ((SR.Attr and faDirectory) = faDirectory) then
            begin
              /// / if (sr.Attr and (faDirectory) <> 0) then begin
              wa_findFilesFromLinks(aFindRegime, LPath + '\' + SR.Name, aMask,
                AExcpList, cbproc, cbExcludeEvent);
            end
            else
            begin
              ///
              LLinkname := Concat(LPath, '\', SR.Name);
              if CompareText(ExtractFileExt(SR.Name), '.lnk') = 0 then
              begin
                ///
                LFname := wa_GetFileNamefromLink(LLinkname);
                ///
                ///
                if (Trim(LFname) <> '') and (Pos('\\', LFname) <= 0) and
                /// найден файл ярлыка и он не СЕТЕВОЙ
                  (wa_FileIncludePaths(LFname, AExcpList) = false) then
                /// файл не в запрещенном каталоге
                  if // (wa_FileIsExe(LFName)=true) and
                    (wa_AngryFileExists(LFname) = false) and
                    (wa_x86Exists(LFname, 1) = false) then
                  begin
                    L_attr := FileGetAttr(LLinkname);
                    if (L_attr and (System.SysUtils.faReadonly) = 0) and
                      (L_attr and (faSysFile) = 0) then
                    begin
                      if Assigned(cbproc) then
                      begin
                        L_wrec.id := 0;
                        L_wrec.Regime := 0;
                        L_wrec.CL_ID := 0;
                        L_wrec.pID := 0;
                        L_wrec.Size := SR.Size;
                        L_wrec.Date := FileDateToDateTime(SR.Time);
                        L_wrec.mDate := SR.TimeStamp;
                        L_wrec.State := 1;
                        L_wrec.Active := true;
                        L_wrec.Name := LLinkname;
                        L_wrec.Value := LFname; //
                        L_wrec.desc := '';
                        cbproc(1, Addr(L_wrec), L_RunFlag);
                        if L_RunFlag = false then
                          Exit;
                      end;
                    end;
                    if Assigned(cbproc) then
                      if L_RunFlag = false then
                        Exit;
                  end;
              end;
            end;
          end;
        until (FindNext(SR) <> 0);
    finally
      System.SysUtils.FindClose(SR);
    end;
  end;

  /// ////////////////////////////////////
  ///
  /// REGISTER
  ///
  /// uses winapi.Windows
  function wa_findRegRootkey(const aStr: string; var aHKey: HKey): string;
  begin
    Result := '';
    if Pos('HKCR', aStr) = 1 then
    begin
      aHKey := HKEY_CLASSES_ROOT;
      Result := Copy(aStr, 6, Length(aStr) - 5);
    end;
    if Pos('HKCU', aStr) = 1 then
    begin
      aHKey := HKEY_CURRENT_USER;
      Result := Copy(aStr, 6, Length(aStr) - 5);
    end;
    if Pos('HKLM', aStr) = 1 then
    begin
      aHKey := HKEY_LOCAL_MACHINE;
      Result := Copy(aStr, 6, Length(aStr) - 5);
    end;
    if Pos('HKU', aStr) = 1 then
    begin
      aHKey := HKEY_USERS;
      Result := Copy(aStr, 5, Length(aStr) - 4);
    end;
    if Pos('HKPD', aStr) = 1 then
    begin
      aHKey := HKEY_PERFORMANCE_DATA;
      Result := Copy(aStr, 6, Length(aStr) - 5);
    end;
    if Pos('HKCC', aStr) = 1 then
    begin
      aHKey := HKEY_CURRENT_CONFIG;
      Result := Copy(aStr, 6, Length(aStr) - 5);
    end;
    if Pos('HKDD', aStr) = 1 then
    begin
      aHKey := HKEY_DYN_DATA;
      Result := Copy(aStr, 6, Length(aStr) - 5);
    end;
  end;

  /// коды для корневых ключе реестра - мои
  function wa_GetRegRootkeyID(const aHKey: HKey): integer;
  begin
    case aHKey of
      HKEY_CLASSES_ROOT:
        Result := 0;
      HKEY_CURRENT_USER:
        Result := 1;
      HKEY_LOCAL_MACHINE:
        Result := 2;
      HKEY_USERS:
        Result := 3;
      HKEY_PERFORMANCE_DATA:
        Result := 4;
      HKEY_CURRENT_CONFIG:
        Result := 5;
      HKEY_DYN_DATA:
        Result := 6;
      else Result:=1;
    end;
  end;

  function wa_GetRegRootkey(aID: integer): HKey;
  begin
    case aID of
      0:
        Result := HKEY_CLASSES_ROOT;
      1:
        Result := HKEY_CURRENT_USER;
      2:
        Result := HKEY_LOCAL_MACHINE;
      3:
        Result := HKEY_USERS;
      4:
        Result := HKEY_PERFORMANCE_DATA;
      5:
        Result := HKEY_CURRENT_CONFIG;
      6:
        Result := HKEY_DYN_DATA;
     else
        Result := HKEY_CURRENT_USER;
    end;
  end;

  function wa_GetRegRootkeyIDFromStr(const aStr: string): integer;
  begin
    Result := -1;
    if Pos('HKCR', aStr) = 1 then
      Result := 0;
    if Pos('HKCU', aStr) = 1 then
      Result := 1;
    if Pos('HKLM', aStr) = 1 then
      Result := 2;
    if Pos('HKU', aStr) = 1 then
      Result := 3;
    if Pos('HKPD', aStr) = 1 then
      Result := 4;
    if Pos('HKCC', aStr) = 1 then
      Result := 5;
    if Pos('HKDD', aStr) = 1 then
      Result := 6;
  end;

  function wa_GetRegRootkeyStr(aID: integer): string;
  begin
    case aID of
      0:
        Result := 'HKCR';
      1:
        Result := 'HKCU';
      2:
        Result := 'HKLM';
      3:
        Result := 'HKU';
      4:
        Result := 'HKPD';
      5:
        Result := 'HKCC';
      6:
        Result := 'HKDD';
    else
      Result := '';
    end;
  end;

  /// / TRegDataType = (rdUnknown, rdString, rdExpandString, rdInteger, rdBinary);

  /// рекурсивный поиск количества переменных в ключах - внутренняя
  procedure wa_Inner_ValuesCount(akey: HKey; var akeyCount: int64;
    ArecurFlag: boolean = true);
  var
    L_list: TstringList;
    n: integer;
    L_RunFlag: boolean;
    { TRegKeyInfo = record
      NumSubKeys: Integer;
      MaxSubKeyLen: Integer;
      NumValues: Integer;
      MaxValueLen: Integer;
      MaxDataLen: Integer;
      FileTime: TFileTime;
      end;
    }
    L_keyInfo: TRegKeyInfo;
  begin
    L_RunFlag := true;
    with TRegistry.Create do
      try
        RootKey := akey;
        OpenKey(EmptyStr, false);
        if GetKeyInfo(L_keyInfo) = true then
          akeyCount := akeyCount + L_keyInfo.NumValues
        else
          akeyCount := akeyCount + 1;
        ///
        L_list := TstringList.Create;
        try
          GetKeynames(L_list);
          if L_RunFlag = false then
            Exit; // !
          CloseKey;
          n := 0;
          if ArecurFlag then
            while n < L_list.Count do
            begin
              if L_RunFlag = false then
                Exit; // !
              if OpenKey(L_list.Strings[n], false) then
              begin
                wa_Inner_ValuesCount(CurrentKey, akeyCount, ArecurFlag);
                CloseKey;
              end;
              Inc(n);
            end;
        finally
          L_list.Free;
        end;
      finally
        Free;
      end;
  end;

  /// поиск количества ключей
  function wa_GetValuesCount(const aKeyStr: string;
    ArecurFlag: boolean = true): int64;
  var
    L_Rootkey: HKey;
    L_Keyname: string;
    L_Key: HKey;
    L_reg: TRegistry;
    L_ValueCount: int64;
  begin
    Result := 0;
    L_ValueCount := 0;
    L_Keyname := wa_findRegRootkey(aKeyStr, L_Rootkey);
    L_reg := TRegistry.Create;
    try
      L_reg.RootKey := L_Rootkey;
      if L_reg.OpenKeyReadOnly(L_Keyname) = true then
      begin
        L_Key := L_reg.CurrentKey;
        wa_Inner_ValuesCount(L_Key, L_ValueCount, ArecurFlag);
      end;
      Result := L_ValueCount;
    finally
      L_reg.Free;
    end;
  end;

  function wa_RegKeyExists(const aKeyStr: string; aReadFlag: boolean): boolean;
  var
    L_Rootkey: HKey;
    L_Keyname: string;
    L_Key: HKey;
    L_reg: TRegistry;
  begin
    Result := false;
    if aReadFlag = true then
      L_reg := wa_CreateRegistry(2)
    else
      L_reg := wa_CreateRegistry(0);
    L_Keyname := wa_findRegRootkey(aKeyStr, L_Rootkey);
    try
      L_reg.RootKey := L_Rootkey;
      if L_reg.KeyExists(L_Keyname) = true then
      begin
        Result := true;
      end;
    finally
      L_reg.Free;
    end;
  end;

  /// поиск значения - внутренняя
  ///
  procedure wa_Inner_GetRegValue(akey: HKey; const aName: string;
    var AResValue: string; ArecurFlag: boolean = false);
  var
    L_list, L_keyList: TstringList;
    n: integer;
    LS: string;
    L_dataType: TRegDataType;
  begin
    if AResValue <> '' then
      Exit;
    ///
    if Pos('*', aName) = Length(aName) then
      LS := Copy(aName, 1, Length(aName) - 1)
    else
      LS := '';
    ///
    with TRegistry.Create do
      try
        RootKey := akey;
        OpenKeyReadOnly(EmptyStr);
        L_list := TstringList.Create;
        L_keyList := TstringList.Create;
        try
          GetValueNames(L_list);
          GetKeynames(L_keyList);
          /// Showmessage(L_List.GetText);
          if LS = '' then
          begin
            n := L_list.IndexOf(aName);
            if n >= 0 then
              try
                L_dataType := GetDataType(aName);
                if (L_dataType = rdString) or (L_dataType = rdUnknown) then
                begin
                  AResValue := ReadString(aName);
                  if Trim(AResValue) = '' then
                    AResValue := '-';
                  /// чтобы избежать бесконечности
                  Exit; // !
                end;
              finally
              end;
          end
          else
          begin
            n := 0;
            while n < L_list.Count do
            begin
              try
                L_dataType := GetDataType(aName);
                if (L_dataType = rdString) or (L_dataType = rdUnknown) then
                  if WideCompareText(LS, L_list.Strings[n]) <= 0 then
                  begin
                    AResValue := ReadString(L_list.Strings[n]);
                    if Trim(AResValue) = '' then
                      AResValue := '-';
                    /// чтобы избежать 8
                    Exit; // !
                  end;
              finally
              end;
              Inc(n);
            end;
          end;
          ///
          if AResValue <> '' then
            Exit;
          ///
          n := 0;
          if (ArecurFlag = true) then
            while n < L_keyList.Count do
            begin
              if AResValue <> '' then
                break;
              if OpenKeyReadOnly(L_keyList.Strings[n]) then
              begin
                wa_Inner_GetRegValue(CurrentKey, aName, AResValue, ArecurFlag);
                CloseKey;
              end;
              Inc(n);
            end;
        finally
          CloseKey;
          L_list.Free;
          L_keyList.Free;
        end;
      finally
        Free;
      end;
  end;

  /// найти значение параметра (строковое)   ='' если не найдено  '-' - если пустое
  function wa_GetRegValue(const adirKeyStr, aName: string;
    ArecurFlag: boolean = false): string;
  var
    L_Rootkey: HKey;
    L_Keyname, L_result, L_res1, L_S: string;
    L_Key: HKey;
    L_reg: TRegistry;
  begin
    L_result := '';
    L_Keyname := wa_findRegRootkey(adirKeyStr, L_Rootkey);
    L_reg := TRegistry.Create;
    try
      L_reg.RootKey := L_Rootkey;
      if L_reg.OpenKeyReadOnly(L_Keyname) = true then
      begin
        L_Key := L_reg.CurrentKey;
        wa_Inner_GetRegValue(L_Key, aName, L_result, ArecurFlag);
        if L_result = '-' then;
        ///
        L_result := wa_ReplaceEnvironmentString(L_result);
        ///
        ///
        Result := L_result;
      end;
    finally
      L_reg.CloseKey;
      L_reg.Free;
    end;

  end;


  function wa_GetAutoRunState(const aProgramName:string; cuFlag:boolean):boolean;
   var L_Rootkey: HKey;
       reg: TRegistry;
       LS:string;
    begin
     Result:=False;
     reg := TRegistry.Create;
     try
      if cuFlag then reg.RootKey := HKEY_CURRENT_USER
      else reg.RootKey := HKEY_LOCAL_MACHINE;
      try
       reg.OpenKeyReadOnly('Software\Microsoft\Windows\CurrentVersion\Run');
       LS:=wa_ReadStringFromReg(reg,aProgramName,'');
       if (LS<>'') then Result:=True;
       except begin Result:=False; Exit; end;
      end;
     finally
     reg.Free;
    end;
   end;

  function wa_SetAutoRunState(const aProgramName,aAppFileValue:string; cuFlag:boolean):boolean;
     var L_Rootkey: HKey;
       reg: TRegistry;
    begin
     Result:=False;
     reg := TRegistry.Create;
     try
      if cuFlag then reg.RootKey := HKEY_CURRENT_USER
      else reg.RootKey := HKEY_LOCAL_MACHINE;
      try
       reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run',true);
       reg.WriteString(aProgramName,aAppFileValue);
       Result:=True;
       except begin Result:=False; Exit; end;
      end;
     finally
     reg.Free;
    end;
   end;

  function wa_DeleteAutoRunState(const aProgramName:string; cuFlag:boolean):boolean;
    var L_Rootkey: HKey;
       reg: TRegistry;
    begin
     Result:=False;
     reg := TRegistry.Create;
     try
       if cuFlag then reg.RootKey := HKEY_CURRENT_USER
       else reg.RootKey := HKEY_LOCAL_MACHINE;
       try
       reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run',true);
       reg.DeleteValue(aProgramName);
      { if cuFlag=false then
        begin
          reg.CloseKey;
          reg.OpenKey('Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Run',true);
          reg.DeleteValue(aProgramName);
        end;
        }
        except begin Result:=False; Exit; end;
       end;
       Result:=True;
      finally
      reg.Free;
     end;
    end;

  function wa_GetAutoRunWOWState(const aProgramName:string):boolean;
  var L_Rootkey: HKey;
       reg: TRegistry;
       LS:string;
    begin
     Result:=False;
     reg := TRegistry.Create;
     try
      try
       reg.RootKey := HKEY_LOCAL_MACHINE;
       reg.OpenKeyReadOnly('Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Run');
       LS:=wa_ReadStringFromReg(reg,aProgramName,'');
       if (LS<>'') then Result:=True;
      except Result:=False;
      end;
     finally
     reg.Free;
    end;
   end;

   function wa_SetAutoRunWOWState(const aProgramName,aAppFileValue:string):boolean;
     var L_Rootkey: HKey;
       reg: TRegistry;
    begin
     Result:=False;
     reg := TRegistry.Create;
     try
      try
       reg.RootKey := HKEY_LOCAL_MACHINE;
       reg.OpenKey('Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Run',true);
       reg.WriteString(aProgramName,aAppFileValue);
       Result:=True;
       except
             begin Result:=False; Exit; end;
      end;
     finally
     reg.Free;
    end;
   end;

    function wa_DeleteAutoRunWOWState(const aProgramName:string):boolean;
    var L_Rootkey: HKey;
       reg: TRegistry;
    begin
     Result:=False;
     reg := TRegistry.Create;
     try
       reg.RootKey := HKEY_LOCAL_MACHINE;
       try
        reg.OpenKey('Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Run',true);
        reg.DeleteValue(aProgramName);
        Result:=True;
        except begin Result:=False; Exit; end;
       end;
      finally
      reg.Free;
     end;
    end;


  /// ///////////////////////////////////////////////////////////////////////////
  /// /
  /// Определить разрядность win
  ///
  /// /////
  function IsWow64: bool;
  type
    TIsWow64Process = function(hProcess: THandle; var Wow64Process: bool)
      : bool; stdcall;
  var
    IsWow64Process: TIsWow64Process;
  begin
    Result := false;
    @IsWow64Process := GetProcAddress(GetModuleHandle(kernel32),
      'IsWow64Process');
    if Assigned(@IsWow64Process) then
      IsWow64Process(GetCurrentProcess, Result);
  end;

  const
    PROCESSOR_ARCHITECTURE_AMD64 = 9;
    PROCESSOR_ARCHITECTURE_IA64 = 6;

  type
    TGetNativeSystemInfo = procedure(var lpSystemInfo: TSystemInfo); stdcall;

  function Is64bits: boolean;
  var
    h: THandle;
    si: TSystemInfo;
    getinfo: TGetNativeSystemInfo;
  begin
    Result := false;
    h := GetModuleHandle('kernel32.dll');
    try
      ZeroMemory(@si, SizeOf(si));
      getinfo := TGetNativeSystemInfo(GetProcAddress(h, 'GetNativeSystemInfo'));
      if not Assigned(@getinfo) then
        Exit;
      getinfo(si);
      if si.wProcessorArchitecture in [PROCESSOR_ARCHITECTURE_AMD64,
        PROCESSOR_ARCHITECTURE_IA64] then
        Result := true;
    finally
      FreeLibrary(h);
    end;
  end;

  function wa_Is64Sys(aRegime: integer = 0): boolean;
  var
    LS: string;
  begin
    case aRegime of
      0:
        Result := Is64bits;
      1:
        Result := IsWow64;
      2:
        begin
          LS := wa_GetRegValue
            ('HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
            'PROCESSOR_ARCHITECTURE');
          if Pos('64', LS) > 0 then
            Result := true
          else
            Result := false;
        end;
    end;
  end;

{$IFDEF WIN32}

  // function GetVersionEx(lpOs: pointer): BOOL; stdcall;
  // external 'kernel32' name 'GetVersionExA';
{$ENDIF}

  procedure wa_GetWindowsVersion(var Major: integer; var Minor: integer);
  type
    TGetVersionExfunc = function(lpOs: Pointer): bool; stdcall;
  var
    h: THandle;
    L_GetFunc: TGetVersionExfunc;
  var
    (* {$IFDEF WIN32}
      lpOS, lpOS2: POsVersionInfo;
      {$ELSE}
    *)
    l: longint;
    // {$ENDIF}
  begin
    (*
      {$IFDEF WIN32}
      H := GetModuleHandle('kernel32.dll');
      L_GetFunc:=TGetVersionExfunc(GetProcAddress(h,'GetVersionExA'));
      if Assigned(@L_GetFunc) then
      begin
      GetMem(lpOS, SizeOf(TOsVersionInfo));
      lpOs^.dwOSVersionInfoSize := SizeOf(TOsVersionInfo);
      if L_GetFunc(lpOS)=false then
      begin
      GetMem(lpos2, lpos^.dwOSVersionInfoSize + 1);
      lpOs2^.dwOSVersionInfoSize := lpOs^.dwOSVersionInfoSize + 1;
      FreeMem(lpOs, lpOs^.dwOSVersionInfoSize);
      lpOS := lpOs2;
      end;
      Major := lpOs^.dwMajorVersion;
      Minor := lpOs^.dwMinorVersion;
      FreeMem(lpOs, lpOs^.dwOSVersionInfoSize);
      end;
      {$ELSE}
    *)
    l := GetVersion;
    Major := LoByte(LoWord(l));
    Minor := HiByte(LoWord(l));
    (* {$ENDIF}
    *)
  end;

  function wa_GetWindowsVersionStr(aRegime: integer = 1): string;
  var
    L_Major, L_Minor: integer;
    LS: string;
  begin
    Result := '';
    LS := '';
    L_Major := 0;
    L_Minor := 0;
    { L_Major
      Windows 95 - 4
      Windows 98 - 4
      Windows Me - 4
      Windows NT 3.51 - 3
      Windows NT 4.0 - 4
      Windows 2000 - 5
      Windows XP - 5
      ///
      L_minor
      Windows 95 - 0
      Windows 98 - 10
      Windows Me - 90
      Windows NT 3.51 - 51
      Windows NT 4.0 - 0
      Windows 2000 - 0
      Windows XP - 1
    }
    wa_GetWindowsVersion(L_Major, L_Minor);
    if aRegime = 1 then
      case L_Major of
        3:
          case L_Minor of
            51:
              LS := 'win351';
          else
            LS := 'win3';
          end;
        4:
          case L_Minor of
            0:
              LS := 'win95';
            10:
              LS := 'win98';
            90:
              LS := 'winME';
          else
            LS := 'win9';
          end;
        5:
          case L_Minor of
            0:
              LS := 'win2000';
            1:
              LS := 'winXP';
          else
            LS := 'winXP';
          end;
        6:
          case L_Minor of
            0:
              LS := 'winVISTA';
            1:
              LS := 'win7';
          else
            LS := 'win8';
          end;
        8: LS := 'win8';
        10: LS := 'win10';
        11: LS := 'win11';
      end;
    Result := LS;
  end;

  function wa_GetWindowsVersionNum(aRg,aMajor,aMinor: integer): integer;
  var
    L_Major, L_Minor: integer;
  begin
    Result := -1;
    L_Major:=aMajor;
    L_Minor:=aMinor;
    ///
    if aRg = 1 then
      case L_Major of
        3:
          case L_Minor of
            51:
              Result := 1;
          else
            Result := 1;
          end;
        4:
          case L_Minor of
            0:
              Result := 2;
            10:
              Result := 2;
            90:
              Result := 3;
          else
            Result := 2;
          end;
        5:
          case L_Minor of
            0:
              Result := 4;
            1:
              Result := 5;
          else
            Result := 5;
          end;
        6:
          case L_Minor of
            0:
              Result := 6;
            1:
              Result := 7;
          else
            Result := 8;
          end;
         8: Result:=8;
         10: Result:=10;
         11: Result:=11;
        else
         begin
           Result:=0;
         end;
      end;
  end;

  procedure wa_GetFileVersion(FileName: string;
    var Major1, Major2, Minor1, Minor2: integer);
  { Helper function to get the actual file version information }
  var
    Info: Pointer;
    InfoSize: DWORD;
    FileInfo: PVSFixedFileInfo;
    FileInfoSize: DWORD;
    Tmp: DWORD;
  begin
    // Get the size of the FileVersionInformatioin
    InfoSize := GetFileVersionInfoSize(PChar(FileName), Tmp);
    // If InfoSize = 0, then the file may not exist, or
    // it may not have file version information in it.
    if InfoSize = 0 then
      raise Exception.Create
        ('wa_GetFileVersion - Can''t get file version information for ' +
        FileName);
    // Allocate memory for the file version information
    GetMem(Info, InfoSize);
    try
      // Get the information
      GetFileVersionInfo(PChar(FileName), 0, InfoSize, Info);
      // Query the information for the version
      VerQueryValue(Info, '\', Pointer(FileInfo), FileInfoSize);
      // Now fill in the version information
      Major1 := FileInfo.dwFileVersionMS shr 16;
      Major2 := FileInfo.dwFileVersionMS and $FFFF;
      Minor1 := FileInfo.dwFileVersionLS shr 16;
      Minor2 := FileInfo.dwFileVersionLS and $FFFF;
    finally
      FreeMem(Info, FileInfoSize);
    end;
  end;

  function wa_GetFileVersionToStr(const aFileName: string;
    const aDelim: string = '.'): string;
  var
    Major1, Major2, Minor1, Minor2: integer;
  begin
    wa_GetFileVersion(aFileName, Major1, Major2, Minor1, Minor2);
    Result := Concat(IntToStr(Major1), aDelim, IntToStr(Major2), aDelim,
      IntToStr(Minor1), aDelim, IntToStr(Minor2));
  end;

  /// /////////////////////////////////////////////////////////////////////////////
  ///
  /// снова реестр
  ///
  ///
  /// замена стандартного конструктора на свой
  function wa_CreateRegistry(aCrRegime: integer): TRegistry;
  var
    L_K: integer;
  begin
    if aCrRegime = 2 then
      L_K := KEY_READ
    else
      L_K := KEY_ALL_ACCESS;
    if wa_Is64Sys = true then
      Result := TRegistry.Create(L_K OR $0100)
    else
      Result := TRegistry.Create(L_K);
  end;

  /// рекурсивный поиск значений ключей - внутренняя
  ///
  procedure wa_Inner_EnumAllKeys(aFindRegime: integer; aRootKeyID: integer;
    const aKeyname: string; akey: HKey; cbproc: TwProgressEvent;
    ArecurFlag: boolean = true);
  var
    L_list, L_params: TstringList;
    n: integer;
    L_RunFlag: boolean;
    LS: string;
    Lw: int64;
    L_dataType: TRegDataType;
    L_notdataFlag, L_AddFlag: boolean;
    ///
    L_ext: string;
    L_rec: TwCleanRecord;
    /// /
  begin
    L_RunFlag := true;
    with wa_CreateRegistry(0) do
      try
        RootKey := akey;
        OpenKeyReadOnly(EmptyStr);
        L_list := TstringList.Create;
        L_params := TstringList.Create;
        try
          GetKeynames(L_list);
          GetValueNames(L_params);
          if L_RunFlag = false then
            Exit; // !
          n := 0;
          while n < L_params.Count do
          begin
            LS := '';
            Lw := 0;
            cbproc(-2,nil,L_RunFlag);
            if L_RunFlag = false then Exit;
            ///
            if (L_params.Strings[n] <> '') then
            begin
              LS := L_params.Strings[n];
              /// условие проверки параметра
              ///
              case aFindRegime of
                0:
                  L_AddFlag := true;
                1:
                  L_AddFlag := (LS <> '');
                2:
                  begin
                    L_ext := ExtractFileExt(LS);
                    { if L_ext='' then begin
                      L_AddFlag:=DirectoryExists(LS)=false
                      end
                      else
                    }
                    L_AddFlag := (wa_AngryFileExists(LS) = false) and
                      (fileexists(LS) = false);
                  end;
              end;
              ///
              ///
              if L_AddFlag then
              begin
                if Assigned(cbproc) then
                begin
                  wCleanRec(L_rec);
                  L_rec.RecType := 2;
                  /// Reg
                  L_rec.id := 0;
                  L_rec.Regime := 0;
                  L_rec.CL_ID := 0;
                  L_rec.pID := 1;
                  L_rec.HomekeyID := aRootKeyID;
                  L_rec.Date := 0;
                  L_rec.mDate := 0;
                  L_rec.State := 1;
                  L_rec.Active := true;
                  L_rec.Name := aKeyname;
                  L_rec.Value := LS;
                  L_rec.wvalue := 0;
                  L_rec.DtType := 2;
                  L_rec.desc := '';
                  cbproc(2, Addr(L_rec), L_RunFlag);
                  // !!  запись в базу - внутри
                  ///
                  if L_RunFlag = false then
                    Exit; // !
                end;
              end;
            end; //
            Inc(n);
          end;
          CloseKey;
          n := 0;
          if ArecurFlag then
            while n < L_list.Count do
            begin
              cbproc(-2,nil,L_RunFlag);
              if L_RunFlag = false then
                Exit; // !
              if OpenKeyReadOnly(L_list.Strings[n]) then
              begin
                wa_Inner_EnumAllKeys(aFindRegime, aRootKeyID, L_list.Strings[n],
                  CurrentKey, cbproc, ArecurFlag);
                CloseKey;
              end;
              Inc(n);
            end;
        finally
          L_list.Free;
          L_params.Free;
        end;
      finally
        Free;
      end;
  end;

  function wa_FindInReg(aFindRegime: integer; const aKeyStr: string;
    cbproc: TwProgressEvent; ArecurFlag: boolean = true): boolean;
  var
    L_Rootkey: HKey;
    L_Keyname: string;
    L_Key: HKey;
    L_reg: TRegistry;
  begin
    Result := false;
    L_Keyname := wa_findRegRootkey(aKeyStr, L_Rootkey);
    ///
    L_reg := wa_CreateRegistry(0);
    try
      L_reg.RootKey := L_Rootkey;
      if L_reg.OpenKeyReadOnly(L_Keyname) = true then
      begin
        L_Key := L_reg.CurrentKey;
        wa_Inner_EnumAllKeys(aFindRegime, wa_GetRegRootkeyID(L_Rootkey),
          L_Keyname, L_Key, cbproc);
      end;
      Result := true;
    finally
      L_reg.Free;
    end;
  end;

  function wa_DeleteKeyInReg(const AregObj: Tobject; aRootKeyID: integer;
    const aKeyStr: string): boolean;
  var
    L_reg: TRegistry;
  begin
    if AregObj = nil then
      ///
      L_reg := wa_CreateRegistry(0)
      ///
    else
      L_reg := TRegistry(AregObj);
    try
      L_reg.RootKey := wa_GetRegRootkey(aRootKeyID);
      Result := L_reg.DeleteKey(aKeyStr);
    finally
      L_reg.CloseKey;
      if AregObj = nil then
        L_reg.Free;
    end;
  end;

  function wa_DeleteParamInReg(const AregObj: Tobject; aRootKeyID: integer;
    const aKeyStr, aParamStr: string): boolean;
  var
    L_reg: TRegistry;
  begin
    if AregObj = nil then
      ///
      L_reg := wa_CreateRegistry(0)
    else
      L_reg := TRegistry(AregObj);
    try
      L_reg.RootKey := wa_GetRegRootkey(aRootKeyID);
      if L_reg.OpenKey(aKeyStr, false) = true then
      begin
        Result := L_reg.DeleteValue(aParamStr);
      end;
    finally
      L_reg.CloseKey;
      if AregObj = nil then
        L_reg.Free;
    end;
  end;

  /// ////////////////////////////////////////////////////////////////////////////////////////////
  ///
  ///
  /// заполнить список значениями расширений из раздеоа CR
  function wa_Inner_FillExtensionInHKCRReg(const aList: Tstrings): boolean;
  var
    L_reg: TRegistry;
    i: integer;
  begin
    Result := false;
    aList.Clear;
    L_reg := wa_CreateRegistry(0);
    with L_reg do
      try
        RootKey := HKEY_CLASSES_ROOT;
        /// LRootKeyID:=wa_GetRegRootkeyID(RootKey);
        try
         OpenKeyReadOnly(EmptyStr);
         GetKeynames(aList);
        except
          ///
        end;
        CloseKey;
      finally
        L_reg.Free;
      end;
    i := 0;
    while i < aList.Count do
    begin
      if (Pos('.', aList.Strings[i]) <> 1) then
        aList.Delete(i)
      else
        Inc(i);
    end;
    Result := (aList.Count > 0);
  end;

  /// AHKCRExtList - список исключений из раздела HKCR  c точкой в начале имени
  procedure wa_Inner_InvExtensionKeys(aRootKeyID: integer;
    const aKeyname: string; akey: HKey; const AHKCRExtList: Tstrings;
    cbproc: TwProgressEvent);
  var
    L_list, L_subList: TstringList;
    n, i: integer;
    L_RunFlag: boolean;
    L_AddFlag: boolean;
    LS, LLS: string;
    L_keyInfo: TRegKeyInfo;
    L_rec: TwCleanRecord;
    LTS: TFileTime;
    L_delFlag: boolean;
    ///
  begin
    L_RunFlag := true;
    with wa_CreateRegistry(0) do
      try
        RootKey := akey;
        OpenKey(EmptyStr, false);
        L_list := TstringList.Create;
        L_subList := TstringList.Create;
        try
          GetKeynames(L_list);
          CloseKey;
          i := 0;
          while i < L_list.Count do
          begin
            // if L_list.Strings[i]='.'
            L_delFlag := false;
            n := Pos('.', L_list.Strings[i]);
            ///
            if (n = 0) or (n > 1) then
              L_delFlag := true;
            ///
            if (AHKCRExtList.IndexOf(L_list.Strings[i]) >= 0) then
              L_delFlag := true;
            ///
            if L_delFlag = true then
              L_list.Delete(i)
            else
              Inc(i);
          end;
          i := 0;
          n := 0;
          while n < L_list.Count do
          begin
            cbproc(-2,nil,L_RunFlag);
            if L_RunFlag = false then Exit;
            L_AddFlag := true;
            LS := L_list.Strings[n];
            if OpenKeyReadOnly(L_list.Strings[n]) = true then
            begin
              L_subList.Clear;
              GetKeynames(L_subList);
              CloseKey;
              i := 0;
              while (i < L_subList.Count) and (L_AddFlag = true) do
              begin
                cbproc(-2,nil,L_RunFlag);
                if L_RunFlag = false then Exit;
                if L_subList.Strings[i] = 'UserChoice' then
                  L_AddFlag := false;
                if L_AddFlag = true then
                begin
                  LLS := Concat(LS, '\', L_subList.Strings[i]);
                  if OpenKeyReadOnly(LLS) = true then
                  begin
                    if (GetKeyInfo(L_keyInfo) = true) then
                      if (L_keyInfo.NumValues > 0) or (L_keyInfo.NumSubKeys > 0)
                      then
                        L_AddFlag := false;
                  end;
                  CloseKey;
                end;
                Inc(i);
              end;
            end;
            if L_AddFlag = true then
            begin
              if Assigned(cbproc) then
              begin
                wCleanRec(L_rec);
                L_rec.RecType := 2;
                /// Reg
                L_rec.id := 0;
                L_rec.Regime := 0;
                L_rec.CL_ID := 0;
                L_rec.pID := 1;
                L_rec.HomekeyID := aRootKeyID;
                LTS.dwLowDateTime := L_keyInfo.FileTime.dwLowDateTime;
                LTS.dwHighDateTime := L_keyInfo.FileTime.dwHighDateTime;
                L_rec.Date := wa_FileTimeToDateTime(LTS);
                L_rec.mDate := 0;
                L_rec.State := 1;
                L_rec.Active := true;
                L_rec.Name := aKeyname;
                L_rec.Value := ExtractFileExt(LS);
                L_rec.wvalue := 0;
                L_rec.DtType := 2;
                L_rec.desc := '';
                cbproc(2, Addr(L_rec), L_RunFlag);
                if L_RunFlag = false then
                  Exit; // !
                ///
              end;
            end;
            Inc(n);
          end;
        finally
          L_list.Free;
          L_subList.Free;
        end;
      finally
        Free;
      end;
  end;

  function wa_FindInvExtensionInReg(const aKeyStr: string;
    cbproc: TwProgressEvent): boolean;
  var
    L_Rootkey: HKey;
    L_Keyname: string;
    L_Key: HKey;
    L_reg: TRegistry;
    L_HKCRExtList: Tstrings;
  begin
    Result := false;
    L_Keyname := wa_findRegRootkey(aKeyStr, L_Rootkey);
    L_reg := wa_CreateRegistry(0);
    L_HKCRExtList := TstringList.Create;
    wa_Inner_FillExtensionInHKCRReg(L_HKCRExtList);
    try
      L_reg.RootKey := L_Rootkey;
      if L_reg.OpenKey(L_Keyname, false) = true then
      begin
        L_Key := L_reg.CurrentKey;
        wa_Inner_InvExtensionKeys(wa_GetRegRootkeyID(L_Rootkey), L_Keyname,
          L_Key, L_HKCRExtList, cbproc);
      end;
      Result := true;
    finally
      L_reg.Free;
      L_HKCRExtList.Free;
    end;
  end;

  function wa_FindInvExtensionInHKCRReg(cbproc: TwProgressEvent): boolean;
  var
    LS: String;
    L_list: Tstrings;
    L_Keyname: string;
    L_reg: TRegistry;
    il: integer;
    L_keyInfo: TRegKeyInfo;
    LRootKeyID: int64;
    L_RunFlag, L_AddFlag: boolean;
    L_rec: TwCleanRecord;
  begin
    Result := false;
    L_RunFlag := true;
    ///
    L_reg := wa_CreateRegistry(0);
    ///
    L_list := TstringList.Create;
    with L_reg do
      try
        RootKey := HKEY_CLASSES_ROOT;
        LRootKeyID := wa_GetRegRootkeyID(RootKey);
        L_Keyname := '';
        OpenKeyReadOnly(EmptyStr);
        GetKeynames(L_list);
        CloseKey;
        il := 0;
        while il < L_list.Count do
        begin
          cbproc(-2,nil,L_RunFlag);
          if L_RunFlag = false then Exit;
          LS := L_list.Strings[il];
          L_AddFlag := false;
          if L_reg.OpenKeyReadOnly(LS) = true then
            try
              if (GetKeyInfo(L_keyInfo) = true) then
                if (L_keyInfo.NumSubKeys = 0) and
                  ((L_keyInfo.NumValues = 0) or ((L_keyInfo.NumValues = 1) and
                  (L_keyInfo.MaxValueLen = 0) and (L_keyInfo.MaxDataLen <= 2)))
                then
                begin
                  if Assigned(cbproc) then
                  begin
                    wCleanRec(L_rec);
                    L_rec.RecType := 2;
                    /// Reg
                    L_rec.Regime := 0;
                    L_rec.CL_ID := 0;
                    L_rec.pID := 2;
                    L_rec.HomekeyID := LRootKeyID;
                    L_rec.Date := wa_FileTimeToDateTime(L_keyInfo.FileTime);
                    L_rec.mDate := 0;
                    L_rec.State := 1;
                    L_rec.Active := true;
                    L_rec.Name := '';
                    L_rec.Value := LS;
                    L_rec.wvalue := 0;
                    L_rec.DtType := 2;
                    L_rec.desc := '';
                    cbproc(2, Addr(L_rec), L_RunFlag);
                    if L_RunFlag = false then
                      Exit;
                  end;
                  L_AddFlag := true;
                end;
               CloseKey;
            finally
            end;
          Inc(il);
        end;
        Result := true;
      finally
        L_list.Free;
        L_reg.Free;
      end;
  end;

  ///
  function wa_CountParamsInReg(const aKeyStr: string): integer;
  var
    L_Rootkey: HKey;
    L_Keyname: string;
    L_reg: TRegistry;
    L_keyInfo: TRegKeyInfo;
  begin
    Result := 0;
    L_Keyname := wa_findRegRootkey(aKeyStr, L_Rootkey);
    L_reg := wa_CreateRegistry(0);
    try
      L_reg.RootKey := L_Rootkey;
      if L_reg.OpenKeyReadOnly(L_Keyname) = true then
      begin
        if (L_reg.GetKeyInfo(L_keyInfo) = true) then
          Result := L_keyInfo.NumValues
        else
        begin
          /// можно попробовать с проходом по values
        end;
      end;
      L_reg.CloseKey;
    finally
      L_reg.Free;
    end;
  end;

  function wa_ClearParamsInReg(const aKeyStr: string): boolean;
  var
    L_Rootkey: HKey;
    L_Keyname: string;
    L_reg: TRegistry;
    LLISt: Tstrings;
    il: integer;
  begin
    Result := false;
    L_Keyname := wa_findRegRootkey(aKeyStr, L_Rootkey);
    ///
    L_reg := wa_CreateRegistry(0);
    ///
    LLISt := TstringList.Create;
    try
      L_reg.RootKey := L_Rootkey;
      if L_reg.OpenKeyReadOnly(L_Keyname) = true then
      begin
        L_reg.GetValueNames(LLISt);
        il := 0;
        while il < LLISt.Count do
        begin
          if L_reg.DeleteValue(LLISt.Strings[il]) then
            LLISt.Delete(il)
          else
            Inc(il);
        end;
      end;
      Result := (LLISt.Count = 0);
    finally
      L_reg.Free;
      LLISt.Free;
    end;
  end;

function wa_ReadIntegerFromReg(const aReg:Tregistry; const aValueName:string; const aDefValue:integer=-1):integer;
var L_dataType:TRegDataType;//  = (rdUnknown, rdString, rdExpandString, rdInteger, rdBinary);
    LS:string;
    Buff: array of Byte;
 begin
  Result:=aDefValue;
  if aReg.ValueExists(aValueName)=false then exit;
  L_dataType := aReg.GetDataType(aValueName);
  if (L_dataType = rdString) or (L_dataType = rdUnknown) or (L_dataType = rdExpandString) then
     try
       LS:=IntToStr(aDefvalue);
       LS:=aReg.ReadString(aValueName);
       TryStrToInt(LS,Result);
       except
     end;
  if (L_dataType = rdInteger) then
     try
       Result:=aReg.ReadInteger(aValueName);
       except
     end;
  if (L_dataType = rdBinary) then
     try
       SetLength(Buff,4);
       Result:=aReg.ReadBinaryData(aValueName,Buff[0],4);
       if Result>0 then
          Result:=Integer(Buff);
       except
         Result:=aDefValue;
     end;
 end;

function wa_ReadStringFromReg(const aReg:Tregistry; const aValueName:string; const aDefStr:string=''):string;
var L_dataType:TRegDataType;//  = (rdUnknown, rdString, rdExpandString, rdInteger, rdBinary);
    LS:string;
    Buff: array of Byte;
 begin
  Result:=aDefStr;
  if aReg.ValueExists(aValueName)=false then exit;
  L_dataType := aReg.GetDataType(aValueName);
  if (L_dataType = rdString) or (L_dataType = rdUnknown) or (L_dataType = rdExpandString) then
     try
       Result:=aReg.ReadString(aValueName);
       except
     end;
  if (L_dataType = rdInteger) then
     try
       Result:=IntToStr(aReg.ReadInteger(aValueName));
       except
     end;
 { спросить сначала TRegDataInfo  - чтобы узнать длину - затем остальное
   if (L_dataType = rdBinary) then
     try
       SetLength(Buff,4);
       Result:=aReg.ReadBinaryData(aValueName,Buff[0],4);
       if Result>0 then
          Result:=Integer(Buff);
       except
         Result:=aDefValue;
     end;
   }
  end;
  ////////////////////////////////////////////////////////////////////////////////////

  function wa_ExtractFullFilenameFromStr(const aStr: string): string;
  var
    il: integer;
    L_flag: boolean;
    LStr, LS: string;
  begin
    Result := aStr;
    il := Low(aStr);
    LS := '';
    L_flag := false;
    while il <= Length(aStr) do
    begin
      if aStr[il] = '"' then
        if L_flag = false then
          L_flag := true
        else
          break
      else
      begin
        if aStr[il] in [',', ';'] then
          break
        else if L_flag = true then
          LS := Concat(LS, aStr[il]);
      end;
      Inc(il);
    end;
    if LS = '' then
    begin
      il := Pos('.exe', LowerCase(aStr));
      if il > 0 then
        LStr := Copy(aStr, 1, il + 3)
      else
        LStr := aStr;
      il := Low(LStr);
      LS := '';
      while il <= Length(LStr) do
      begin
        if LStr[il] in [',', ';'] then
          break
        else
          LS := Concat(LS, LStr[il]);
        Inc(il);
      end;
    end;
    Result := wa_ReplaceEnvironmentString(LS, true)
  end;

  function wa_ExtractCommandFilenameFromStr(const aStr: string): string;
  var
    il: integer;
    L_flag: boolean;
    LStr, LS: string;
  begin
    Result := aStr;
    il := Low(aStr);
    LS := '';
    L_flag := false;
    while il <= Length(aStr) do
    begin
      if aStr[il] in [' ', '/'] then
        break
      else
        LS := Concat(LS, aStr[il]);
      Inc(il);
    end;
    Result := LS;
  end;

  function wa_FindErrorsInHKCR(aFindRegime: integer;
    cbproc: TwProgressEvent): boolean;
  var
    LKeys, LSubKeys: Tstrings;
    // LCurrKey:hKey;
    il, jl: integer;
    L_reg: TRegistry;
    LCurrKeyname, LS, L_RegItemName, LReg_Filename, LT_Filename,
      L_Filename: string;
    L_rec: TwCleanRecord;
    L_RunFlag: boolean;
  begin
    Result := false;
    L_RunFlag := true; // !
    ///
    L_reg := wa_CreateRegistry(0);
    LKeys := TstringList.Create;
    LSubKeys := TstringList.Create;
    with L_reg do
      try
        L_reg.RootKey := HKEY_CLASSES_ROOT;
        OpenKeyReadOnly(EmptyStr);
        GetKeynames(LKeys);
        // LCurrKey:=CurrentKey;
        CloseKey;
        il := 0;
        While il < LKeys.Count do
        begin
          cbproc(-2,nil,L_RunFlag);
          if L_RunFlag = false then Exit;
          LCurrKeyname := LKeys.Strings[il];
          if (LCurrKeyname <> '') and (LCurrKeyname <> '*') and
            (LCurrKeyname[1] <> '.') and (LCurrKeyname <> 'Folder') and
            (LCurrKeyname <> 'Application.Manifest') and
            (OpenKeyReadOnly(LCurrKeyname) = true) then
          begin
            GetKeynames(LSubKeys);
            jl := 0;
            while jl < LSubKeys.Count do
            begin
              cbproc(-2,nil,L_RunFlag);
              if L_RunFlag = false then Exit;
              /// неверный значок
              if CompareText('DefaultIcon', LSubKeys.Strings[jl]) = 0 then
              begin
                ///
                L_RegItemName := LSubKeys.Strings[jl];
                if OpenKeyReadOnly(L_RegItemName) = true then
                begin
                  LReg_Filename :=wa_ReadStringFromReg(L_reg,EmptyStr,'');
                  if (LReg_Filename <> '') then
                  begin
                    LT_Filename := wa_ExtractFullFilenameFromStr(LReg_Filename);
                    ///

                    ///
                    if (LT_Filename <> '') and (LT_Filename[1] <> '%') then
                    begin
                      if (ExtractFilePath(LT_Filename) = '') then
                        L_Filename :=
                          Concat(wa_GetSpecialFolderPath(CSIDL_SYSTEM),
                          PathDelim, LT_Filename);
                      ///
                      if (L_Filename <> '') and (L_Filename[1] <> '@') and
                        (wa_AngryFileExists(L_Filename) = false) and
                        (wa_x86Exists(L_Filename, 1) = false) then
                      begin
                        if Assigned(cbproc) then
                        begin
                          wCleanRec(L_rec);
                          L_rec.RecType := 2;
                          /// Reg
                          L_rec.Regime := 0;
                          L_rec.CL_ID := 0;
                          L_rec.pID := 2;
                          L_rec.HomekeyID := 0; // !
                          L_rec.Date := 0;
                          // wa_FileTimeToDateTime(L_KeyInfo.FileTime);
                          L_rec.mDate := 0;
                          L_rec.State := 1;
                          L_rec.Active := true;
                          L_rec.Name := CurrentPath;
                          L_rec.Value := L_Filename;
                          L_rec.wvalue := 0;
                          L_rec.DtType := 2;
                          L_rec.desc := '';
                          cbproc(2, Addr(L_rec), L_RunFlag);
                          if L_RunFlag = false then
                            Exit;
                        end;
                      end;
                    end;
                  end;
                  CloseKey;
                end;
              end;
              ///
              /// открыть с помощью не туда
              if (Pos('shell', LowerCase(LSubKeys.Strings[jl])) = 1) then
                if OpenKeyReadOnly(LKeys.Strings[il]) = true then
                begin
                  LS := Concat('shell\open\command');
                  if Pos('VSTA', Uppercase(LKeys.Strings[il])) > 0 then
                  begin
                    { Showmessage('JJJ:'+LKeys.Strings[il]+'____:='+LS+'    t='+LKeys.Strings[il]);
                      if OpenKeyReadOnly(LKeys.Strings[il])=false then
                      ShowMessage('KEY__Y');
                      if KeyExists(LS)=false then
                      ShowMessage('FAAA');
                    }
                  end;
                  if OpenKeyReadOnly(LS) = true then
                  begin
                    L_RegItemName := LSubKeys.Strings[jl];
                    LReg_Filename := wa_ReadStringFromReg(L_reg,EmptyStr,'');
                    if (LReg_Filename <> '') then
                    begin
                      LT_Filename := wa_ExtractFullFilenameFromStr
                        (LReg_Filename);
                      if (LT_Filename <> '') and (LT_Filename[1] <> '%') then
                      begin
                        if (ExtractFilePath(LT_Filename) = '') then
                          L_Filename :=
                            Concat(wa_GetSpecialFolderPath(CSIDL_SYSTEM),
                            PathDelim, LT_Filename);
                        ///
                        if (wa_AngryFileExists(L_Filename) = false) and
                          (wa_x86Exists(L_Filename, 1) = false) then
                        begin
                          if Assigned(cbproc) then
                          begin
                            wCleanRec(L_rec);
                            L_rec.RecType := 2;
                            /// Reg
                            L_rec.Regime := 0;
                            L_rec.CL_ID := 0;
                            L_rec.pID := 3;
                            L_rec.HomekeyID :=
                              wa_GetRegRootkeyID(HKEY_CLASSES_ROOT); // !
                            L_rec.Date := 0;
                            // wa_FileTimeToDateTime(L_KeyInfo.FileTime);
                            L_rec.mDate := 0;
                            L_rec.State := 1;
                            L_rec.Active := true;
                            L_rec.Name := CurrentPath;
                            L_rec.Value := L_Filename;
                            L_rec.wvalue := 0;
                            L_rec.DtType := 2;
                            L_rec.desc := '';
                            cbproc(2, Addr(L_rec), L_RunFlag);
                            if L_RunFlag = false then
                              Exit;
                          end;
                        end;
                      end;
                    end;
                  end;
                end;
              ///
              Inc(jl)
            end;
            CloseKey;
          end;
          Inc(il);
        end;
      finally
        L_reg.Free;
        LKeys.Free;
        LSubKeys.Free;
      end;
  end;

  function wa_FindErrorsInFonts(aFindRegime: integer; const aKeyStr: string;
    cbproc: TwProgressEvent): boolean;
  var
    LNames: Tstrings;
    L_Rootkey: HKey;
    il, jl: integer;
    L_reg: TRegistry;
    L_Keyname, L_Filename, L_Fontpath, L_path: string;
    L_rec: TwCleanRecord;
    L_RunFlag: boolean;
  begin
    Result := false;
    L_Fontpath := wa_GetSpecialFolderPath(CSIDL_FONTS);
    if L_Fontpath[Length(L_Fontpath)] <> PathDelim then
      L_Fontpath := Concat(L_Fontpath, PathDelim);
    /// / Showmessage(L_Fontpath);
    L_Keyname := wa_findRegRootkey(aKeyStr, L_Rootkey);
    ///
    L_reg := wa_CreateRegistry(0);
    ///
    LNames := TstringList.Create;
    with L_reg do
      try
        RootKey := L_Rootkey;
        if OpenKey(L_Keyname, false) = true then
        begin
          GetValueNames(LNames);
          il := 0;
          while il < LNames.Count do
          begin
            cbproc(-2,nil,L_RunFlag);
            if L_RunFlag = false then Exit;
            L_Filename :=wa_ReadStringFromReg(L_reg,LNames.Strings[il],'');
            L_path := ExtractFilePath(L_Filename);
            if L_path = '' then
              L_path := L_Fontpath
            else
              L_path := '';
            L_Filename := Concat(L_path, L_Filename);
            // if Lnames.Strings[il]='MT Extra (TrueType)' then
            if (wa_AngryFileExists(L_Filename) = false) and
              (wa_x86Exists(L_Filename, 1) = false) then
            begin
              if Assigned(cbproc) then
              begin
                wCleanRec(L_rec);
                L_rec.RecType := 2;
                /// Reg
                L_rec.Regime := 0;
                L_rec.CL_ID := 0;
                L_rec.pID := 1;
                L_rec.HomekeyID := wa_GetRegRootkeyID(HKEY_LOCAL_MACHINE); // !
                L_rec.Date := 0; // wa_FileTimeToDateTime(L_KeyInfo.FileTime);
                L_rec.mDate := 0;
                L_rec.State := 1;
                L_rec.Active := true;
                L_rec.Name := CurrentPath;
                L_rec.Value := LNames[il];
                L_rec.wvalue := 0;
                L_rec.DtType := 2;
                L_rec.desc := '';
                cbproc(2, Addr(L_rec), L_RunFlag);
                if L_RunFlag = false then
                  Exit;
              end;
            end;
            Inc(il);
          end;
        end;
        Result := true;
      finally
        L_reg.Free;
        LNames.Free;
      end;
  end;

  function wa_FindAppPaths1(aFindRegime: integer; const aKeyStr: string;
    cbproc: TwProgressEvent): boolean;
  var
    LKeys: Tstrings;
    L_Rootkey: HKey;
    il, jl: integer;
    L_reg: TRegistry;
    L_Keyname, // L_Syspath,
    LS, L_Filename, L_FullFilename, L_path: string;
    L_rec: TwCleanRecord;
    L_PVFlag, L_RunFlag: boolean;
  begin
    Result := false;
    // L_Syspath:=Concat(wa_GetSpecialFolderPath(CSIDL_WINDOWS),'\Sysnative\');
    L_Keyname := wa_findRegRootkey(aKeyStr, L_Rootkey);
    ///
    L_reg := wa_CreateRegistry(0);
    ///
    LKeys := TstringList.Create;
    with L_reg do
      try
        RootKey := L_Rootkey;
        if OpenKey(L_Keyname, false) = true then
        begin
          GetKeynames(LKeys);
          CloseKey;
          il := 0;
          while il < LKeys.Count do
          begin
            cbproc(-2,nil,L_RunFlag);
            if L_RunFlag = false then Exit;
            if OpenKeyReadOnly(Concat(L_Keyname, '\', LKeys.Strings[il])) = true
            then
            begin
              L_Filename:=wa_ReadStringFromReg(L_reg,EmptyStr,'');
              L_Filename := StringReplace(L_Filename, '"', '', [rfReplaceAll]);
              L_Filename := wa_ReplaceEnvironmentString(L_Filename);
              L_FullFilename := L_Filename;
              L_path := ExtractFilePath(L_Filename);
              // if L_path='' then L_path:=L_Syspath else L_path:='';
              // L_FullFilename:=Concat(L_path,L_Filename);
              if (L_path <> '') and (Pos('\\', L_path) <= 0) and
                (wa_AngryFileExists(L_FullFilename) = false) and
                (wa_x86Exists(L_FullFilename, 1) = false) then
              begin
                if Assigned(cbproc) then
                begin
                  wCleanRec(L_rec);
                  L_rec.RecType := 2;
                  /// Reg
                  L_rec.Regime := 0;
                  L_rec.CL_ID := 0;
                  L_rec.pID := 1;
                  L_rec.HomekeyID := 0; // !
                  L_rec.Date := 0; // wa_FileTimeToDateTime(L_KeyInfo.FileTime);
                  L_rec.mDate := 0;
                  L_rec.State := 1;
                  L_rec.Active := true;
                  L_rec.Name := CurrentPath;
                  L_rec.Value := LKeys[il];
                  L_rec.wvalue := 0;
                  L_rec.DtType := 2;
                  L_rec.desc := '';
                  cbproc(2, Addr(L_rec), L_RunFlag);
                  if L_RunFlag = false then
                    Exit;
                end;
              end;
              ///
              { L_PVFlag:=ValueExists('Path');
                if L_PVFlag=true then
                begin
                L_path:=ReadString('Path');
                if L_path<>'' then
                if L_path[Length(L_path)]=PathDelim then L_path:=Copy(L_Path,1,Length(L_path)-1);
                if DirectoryExists(L_path)=false then
                if Assigned(cbProc) then
                begin
                wCleanRec(L_rec);
                L_rec.RecType:=2; /// Reg
                L_rec.Regime:=0;
                L_rec.CL_iD:=0;
                L_rec.pID:=2;
                L_rec.HomekeyID:=0; // !
                L_rec.Date:=0;//wa_FileTimeToDateTime(L_KeyInfo.FileTime);
                L_rec.mDate:=0;
                L_rec.State:=1;
                L_rec.Active:=true;
                L_rec.Name:=CurrentPath;
                L_rec.Value:=L_path;
                L_rec.wvalue:=0;
                L_rec.DtType:=2;
                L_rec.desc:='';
                cbProc(2,Addr(L_rec),L_RunFlag);
                if L_RunFlag=false then exit;
                end;
                end;
              }
              CloseKey;
            end;
            Inc(il);
          end;
        end;
        Result := true;
      finally
        L_reg.Free;
        LKeys.Free;
      end;
  end;

  function wa_FindAppPaths_Values(aFindRegime: integer; const aKeyStr: string;
    cbproc: TwProgressEvent): boolean;
  var
    LValues: Tstrings;
    L_Rootkey: HKey;
    il: integer;
    L_reg: TRegistry;
    L_Keyname, L_Filename, L_path: string;
    L_rec: TwCleanRecord;
    L_PVFlag, L_RunFlag: boolean;
  begin
    Result := false;
    L_Keyname := wa_findRegRootkey(aKeyStr, L_Rootkey);
    ///
    L_reg := wa_CreateRegistry(0);
    ///
    LValues := TstringList.Create;
    with L_reg do
      try
        RootKey := L_Rootkey;
        if OpenKey(L_Keyname, false) = true then
        begin
          GetValueNames(LValues);
          CloseKey;
          il := 0;
          while il < LValues.Count do
          begin
            cbproc(-2,nil,L_RunFlag);
            if L_RunFlag = false then Exit;
            L_Filename := LValues.Strings[il];
            L_path := ExtractFilePath(L_Filename);
            if (L_path <> '') and (Pos('\\', L_path) <= 0) and
              (Pos('=', L_Filename) <= 0) and
              (wa_AngryFileExists(L_Filename) = false) and
              (wa_x86Exists(L_Filename, 1) = false) then
            begin
              if Assigned(cbproc) then
              begin
                wCleanRec(L_rec);
                L_rec.RecType := 2;
                /// Reg
                L_rec.Regime := 0;
                L_rec.CL_ID := 0;
                L_rec.pID := 2;
                L_rec.HomekeyID := wa_GetRegRootkeyID(L_Rootkey); // !
                L_rec.Date := 0; // wa_FileTimeToDateTime(L_KeyInfo.FileTime);
                L_rec.mDate := 0;
                L_rec.State := 1;
                L_rec.Active := true;
                L_rec.Name := L_Keyname;
                L_rec.Value := LValues[il];
                L_rec.wvalue := 0;
                L_rec.DtType := 2;
                L_rec.desc := '';
                cbproc(2, Addr(L_rec), L_RunFlag);
                if L_RunFlag = false then
                  Exit;
              end;
            end;
            Inc(il);
          end;
        end;
        Result := true;
      finally
        L_reg.Free;
        LValues.Free;
      end;
  end;

  function wa_FindRegValuePathFiles(aFindRegime, aP_id: integer;
    const aKeyStr: string; cbproc: TwProgressEvent): boolean;
  var
    LNames: Tstrings;
    L_Rootkey: HKey;
    il, jl: integer;
    L_reg: TRegistry;
    L_Keyname, // L_Syspath,
    LS, L_Filename, L_FullFilename, L_path: string;
    L_rec: TwCleanRecord;
    L_PVFlag, L_RunFlag: boolean;
  begin
    Result := false;
    // L_Syspath:=Concat(wa_GetSpecialFolderPath(CSIDL_WINDOWS),'\Sysnative\');
    L_Keyname := wa_findRegRootkey(aKeyStr, L_Rootkey);
    ///
    L_reg := wa_CreateRegistry(0);
    ///
    LNames := TstringList.Create;
    with L_reg do
      try
        RootKey := L_Rootkey;
        if OpenKeyReadOnly(L_Keyname) = true then
        begin
          GetValueNames(LNames); // !
          il := 0;
          while il < LNames.Count do
          begin
            cbproc(-2,nil,L_RunFlag);
            if L_RunFlag = false then Exit;
            L_Filename := LNames.Strings[il];
            L_path :=wa_ReadStringFromReg(L_reg,L_Filename,'');
            if L_path<>'' then
             begin
              L_path := StringReplace(L_path, '"', '', [rfReplaceAll]);
              L_path := wa_ReplaceEnvironmentString(L_path);
             end;
            if (Length(L_path) > 0) and (L_path[Length(L_path)] <> PathDelim)
            then
              L_path := Concat(L_path, PathDelim);
            L_FullFilename := Concat(L_path, L_Filename);
            if (L_path <> '') and (Pos('\\', L_path) <= 0) and
              (wa_AngryFileExists(L_FullFilename) = false) and
              (wa_x86Exists(L_FullFilename, 1) = false) then
            begin
              if Assigned(cbproc) then
              begin
                wCleanRec(L_rec);
                L_rec.RecType := 2;
                /// Reg
                L_rec.Regime := 0;
                L_rec.CL_ID := 0;
                L_rec.pID := aP_id;
                L_rec.HomekeyID := wa_GetRegRootkeyID(L_Rootkey); // !
                L_rec.Date := 0; // wa_FileTimeToDateTime(L_KeyInfo.FileTime);
                L_rec.mDate := 0;
                L_rec.State := 1;
                L_rec.Active := true;
                L_rec.Name := CurrentPath;
                L_rec.Value := LNames[il];
                L_rec.wvalue := 0;
                L_rec.DtType := 2;
                L_rec.desc := '';
                cbproc(2, Addr(L_rec), L_RunFlag);
                if L_RunFlag = false then
                  Exit;
              end;
            end;
            ///
            Inc(il);
          end;
          CloseKey;
        end;
        Result := true;
      finally
        L_reg.Free;
        LNames.Free;
      end;
  end;

  function wa_FindRegValueInstallPaths(aFindRegime, aP_id: integer;
    const aKeyStr: string; cbproc: TwProgressEvent): boolean;
  var
    LNames: Tstrings;
    L_Rootkey: HKey;
    il, jl: integer;
    L_reg: TRegistry;
    L_Keyname, // L_Syspath,
    LS, L_path: string;
    L_rec: TwCleanRecord;
    L_PVFlag, L_RunFlag: boolean;
  begin
    Result := false;
    // L_Syspath:=Concat(wa_GetSpecialFolderPath(CSIDL_WINDOWS),'\Sysnative\');
    L_Keyname := wa_findRegRootkey(aKeyStr, L_Rootkey);
    L_reg := wa_CreateRegistry(0);
    LNames := TstringList.Create;
    with L_reg do
      try
        RootKey := L_Rootkey;
        if OpenKeyReadOnly(L_Keyname) = true then
        begin
          GetValueNames(LNames); // !
          il := 0;
          while il < LNames.Count do
          begin
            cbproc(-2,nil,L_RunFlag);
            if L_RunFlag = false then Exit;
            L_path := LNames.Strings[il];
            L_path := wa_ReplaceEnvironmentString(L_path);
            if (Length(L_path) > 0) and (L_path[Length(L_path)] = PathDelim)
            then
              SetLength(L_path, Length(L_path) - 1);
            if (L_path <> '\') and (L_path <> '') and (Pos('\\', L_path) <= 0)
              and (DirectoryExists(L_path) = false) then
            begin
              if Assigned(cbproc) then
              begin
                wCleanRec(L_rec);
                L_rec.RecType := 2;
                /// Reg
                L_rec.Regime := 0;
                L_rec.CL_ID := 0;
                L_rec.pID := aP_id;
                L_rec.HomekeyID := wa_GetRegRootkeyID(L_Rootkey); // !
                L_rec.Date := 0; // wa_FileTimeToDateTime(L_KeyInfo.FileTime);
                L_rec.mDate := 0;
                L_rec.State := 1;
                L_rec.Active := true;
                L_rec.Name := CurrentPath;
                L_rec.Value := LNames[il];
                L_rec.wvalue := 0;
                L_rec.DtType := 2;
                L_rec.desc := '';
                cbproc(2, Addr(L_rec), L_RunFlag);
                if L_RunFlag = false then
                  Exit;
              end;
            end;
            ///
            Inc(il);
          end;
          CloseKey;
        end;
        Result := true;
      finally
        L_reg.Free;
        LNames.Free;
      end;
  end;

  function wa_FindRegValueUnInstall(aFindRegime, aP_id: integer;
    const aKeyStr: string; cbproc: TwProgressEvent): boolean;
  var
    LKeys: Tstrings;
    L_Rootkey: HKey;
    il, jl: integer;
    L_reg: TRegistry;
    L_RKeyname, L_Keyname, // L_Syspath,
    LS, L_Filename, L_Filepath: string;
    L_rec: TwCleanRecord;
    L_PVFlag, L_RunFlag: boolean;
  begin
    Result := false;
    // L_Syspath:=Concat(wa_GetSpecialFolderPath(CSIDL_WINDOWS),'\Sysnative\');
    L_RKeyname := wa_findRegRootkey(aKeyStr, L_Rootkey);
    L_reg := wa_CreateRegistry(0);
    LKeys := TstringList.Create;
    with L_reg do
      try
        RootKey := L_Rootkey;
        if OpenKeyReadOnly(L_RKeyname) = true then
        begin
          GetKeynames(LKeys); // !
          CloseKey;
          il := 0;
          while il < LKeys.Count do
          begin
            cbproc(-2,nil,L_RunFlag);
            if L_RunFlag = false then Exit;
            L_Keyname := Concat(L_RKeyname, '\', LKeys.Strings[il]);
            /// if Pos('home',LowerCase(L_Keyname))>0 then
            /// Showmessage(LKeys.Strings[il]);
            if OpenKeyReadOnly(L_Keyname) and (Pos('{', LKeys.Strings[il]) <> 1)
            then
            begin
              LS :=wa_ReadStringFromReg(L_reg,'UninstallString','');
              if LS <> '' then
              begin
                LS := wa_ExtractFullFilenameFromStr(LS);
                L_Filename := ExtractFileName(LS);
                L_Filepath := ExtractFilePath(LS);
                LS := wa_ReplaceEnvironmentString(LS);
                if (L_Filename <> '') and (L_Filepath <> '') and (LS <> '') and
                  (Pos('\\', LS) <= 0) and (Pos('MSIEXEC', Uppercase(LS)) <= 0)
                  and (Pos('RUNDLL', Uppercase(LS)) <= 0) and
                  (wa_AngryFileExists(LS) = false) and
                  (wa_x86Exists(LS, 1) = false) then
                begin
                  if Assigned(cbproc) then
                  begin
                    wCleanRec(L_rec);
                    L_rec.RecType := 2;
                    /// Reg
                    L_rec.Regime := 0;
                    L_rec.CL_ID := 0;
                    L_rec.pID := aP_id;
                    L_rec.HomekeyID := wa_GetRegRootkeyID(L_Rootkey); // !
                    L_rec.Date := 0;
                    // wa_FileTimeToDateTime(L_KeyInfo.FileTime);
                    L_rec.mDate := 0;
                    L_rec.State := 1;
                    L_rec.Active := true;
                    L_rec.Name := CurrentPath;
                    L_rec.Value := LS;
                    L_rec.wvalue := 0;
                    L_rec.DtType := 2;
                    L_rec.desc := '';
                    cbproc(2, Addr(L_rec), L_RunFlag);
                    if L_RunFlag = false then
                      Exit;
                  end;
                end;
              end;
              CloseKey;
            end;
            Inc(il);
          end;
          ///
        end;
        Result := true;
      finally
        L_reg.Free;
        LKeys.Free;
      end;
  end;

  function wa_FindEmptyKeys(aFindRegime, aP_id: integer; const aKeyStr: string;
    cbproc: TwProgressEvent): boolean;
  var
    LKeys: Tstrings;
    L_Rootkey: HKey;
    il: integer;
    L_reg: TRegistry;
    L_RKeyname, L_Keyname: string;
    L_keyInfo: TRegKeyInfo;
    L_rec: TwCleanRecord;
    L_RunFlag: boolean;
  begin
    Result := false;
    L_RKeyname := wa_findRegRootkey(aKeyStr, L_Rootkey);
    L_reg := wa_CreateRegistry(0);
    LKeys := TstringList.Create;
    with L_reg do
      try
        RootKey := L_Rootkey;
        if OpenKeyReadOnly(L_RKeyname) = true then
        begin
          GetKeynames(LKeys); // !
          CloseKey;
          il := 0;
          while il < LKeys.Count do
          begin
            cbproc(-2,nil,L_RunFlag);
            if L_RunFlag = false then Exit;
            L_Keyname := Concat(L_RKeyname, '\', LKeys.Strings[il]);
            /// if Pos('home',LowerCase(L_Keyname))>0 then
            /// Showmessage(LKeys.Strings[il]);
            if OpenKeyReadOnly(L_Keyname) then
            begin
              GetKeyInfo(L_keyInfo);
              if (L_keyInfo.NumSubKeys = 0) and (L_keyInfo.NumValues = 0) then
              begin
                if Assigned(cbproc) then
                begin
                  wCleanRec(L_rec);
                  L_rec.RecType := 2;
                  /// Reg
                  L_rec.Regime := 0;
                  L_rec.CL_ID := 0;
                  L_rec.pID := aP_id;
                  L_rec.HomekeyID := wa_GetRegRootkeyID(L_Rootkey); // !
                  L_rec.Date := 0; // wa_FileTimeToDateTime(L_KeyInfo.FileTime);
                  L_rec.mDate := 0;
                  L_rec.State := 1;
                  L_rec.Active := true;
                  L_rec.Name := CurrentPath;
                  L_rec.Value := L_Keyname;
                  L_rec.wvalue := 0;
                  L_rec.DtType := 2;
                  L_rec.desc := '';
                  cbproc(2, Addr(L_rec), L_RunFlag);
                  if L_RunFlag = false then
                    Exit;
                end;
              end;
              CloseKey;
            end;
            Inc(il);
          end;
          ///
        end;
        Result := true;
      finally
        L_reg.Free;
        LKeys.Free;
      end;
  end;

  function wa_FindRegDataFiles(aFindRegime, aP_id: integer;
    const aKeyStr: string; cbproc: TwProgressEvent): boolean;
  var
    LNames: Tstrings;
    L_Rootkey: HKey;
    il: integer;
    J: int64;
    L_reg: TRegistry;
    L_Keyname, // L_Syspath,
    L_Data, L_Filename, L_path: string;
    L_rec: TwCleanRecord;
    L_PVFlag, L_RunFlag: boolean;
    LValInfo: TRegDataInfo;
  begin
    Result := false;
    // L_Syspath:=Concat(wa_GetSpecialFolderPath(CSIDL_WINDOWS),'\Sysnative\');
    L_Keyname := wa_findRegRootkey(aKeyStr, L_Rootkey);
    ///
    L_reg := wa_CreateRegistry(0);
    ///
    LNames := TstringList.Create;
    with L_reg do
      try
        RootKey := L_Rootkey;
        if OpenKeyReadOnly(L_Keyname) = true then
        begin
          try
           GetValueNames(LNames); // !
           except Lnames.Clear;
          end;
          il := 0;
          while il < LNames.Count do
          begin
            cbproc(-2,nil,L_RunFlag);
            if L_RunFlag = false then Exit;
            L_Data :=wa_ReadStringFromReg(L_reg,LNames.Strings[il],'');
            if (L_Data <> '') and (TryStrToInt64(L_Data, J) = false) then
            begin
              L_Filename := L_Data;
              L_Filename := wa_ExtractFullFilenameFromStr(L_Filename);
              if (wa_AngryFileExists(L_Filename) = false) and
                (wa_x86Exists(L_Filename, 1) = false) then
              begin
                if Assigned(cbproc) then
                begin
                  wCleanRec(L_rec);
                  L_rec.RecType := 2;
                  /// Reg
                  L_rec.Regime := 0;
                  L_rec.CL_ID := 0;
                  L_rec.pID := aP_id;
                  L_rec.HomekeyID := wa_GetRegRootkeyID(L_Rootkey); // !
                  L_rec.Date := 0; // wa_FileTimeToDateTime(L_KeyInfo.FileTime);
                  L_rec.mDate := 0;
                  L_rec.State := 1;
                  L_rec.Active := true;
                  L_rec.Name := Concat(CurrentPath);
                  L_rec.Value := LNames.Strings[il];
                  L_rec.wvalue := 0;
                  L_rec.DtType := 2;
                  L_rec.desc := L_Data;
                  cbproc(2, Addr(L_rec), L_RunFlag);
                  if L_RunFlag = false then
                    Exit;
                end;
              end;
            end;
            ///
            Inc(il);
          end;
          CloseKey;
        end;
        Result := true;
      finally
        L_reg.Free;
        LNames.Free;
      end;
  end;

  function wa_FindRegNameFiles(aFindRegime, aP_id: integer;
    const aKeyStr: string; cbproc: TwProgressEvent): boolean;
  var
    LNames: Tstrings;
    L_Rootkey: HKey;
    il: integer;
    J: int64;
    L_reg: TRegistry;
    L_Keyname, L_Syspath, L_Data, L_Filename, L_path: string;
    L_rec: TwCleanRecord;
    L_flag, L_PVFlag, L_RunFlag: boolean;
    LValInfo: TRegDataInfo;
  begin
    Result := false;
    // L_Syspath:=Concat(wa_GetSpecialFolderPath(CSIDL_WINDOWS),'\Sysnative\');
    L_Keyname := wa_findRegRootkey(aKeyStr, L_Rootkey);
    ///
    L_reg := wa_CreateRegistry(0);
    ///
    LNames := TstringList.Create;
    with L_reg do
      try
        RootKey := L_Rootkey;
        if OpenKeyReadOnly(L_Keyname) = true then
        begin
          GetValueNames(LNames); // !
          il := 0;
          while il < LNames.Count do
          begin
            cbproc(-2,nil,L_RunFlag);
            if L_RunFlag = false then Exit;
            // L_Data:=ReadString(LNames.Strings[il]);
            L_Filename := LNames.Strings[il];
            /// доп условия проверки от режима вызова
            L_flag := true;
            if aFindRegime = 1 then
              L_flag := Pos('@', L_Filename) <> 1;
            ///
            if (L_flag = true) and (L_Filename <> '') and
              (Pos('\\', L_Filename) = 0) and (Pos(':', L_Filename) <> 0) then
            begin
              L_Filename := wa_ExtractFullFilenameFromStr(L_Filename);
              if (wa_AngryFileExists(L_Filename) = false) and
                (wa_x86Exists(L_Filename, 1) = false) then
              begin
                if Assigned(cbproc) then
                begin
                  wCleanRec(L_rec);
                  L_rec.RecType := 2;
                  /// Reg
                  L_rec.Regime := 0;
                  L_rec.CL_ID := 0;
                  L_rec.pID := aP_id;
                  L_rec.HomekeyID := wa_GetRegRootkeyID(L_Rootkey); // !
                  L_rec.Date := 0; // wa_FileTimeToDateTime(L_KeyInfo.FileTime);
                  L_rec.mDate := 0;
                  L_rec.State := 1;
                  L_rec.Active := true;
                  L_rec.Name := Concat(CurrentPath);
                  L_rec.Value := LNames.Strings[il];
                  L_rec.wvalue := 0;
                  L_rec.DtType := 2;
                  L_rec.desc := '';
                  cbproc(2, Addr(L_rec), L_RunFlag);
                  if L_RunFlag = false then
                    Exit;
                end;
              end;
            end;
            ///
            Inc(il);
          end;
          CloseKey;
        end;
        Result := true;
      finally
        L_reg.Free;
        LNames.Free;
      end;
  end;

  function wa_GetversionInformation(const aExeFilename: string;
    const aList: Tstrings): boolean;
  const
    L_InfoNum = 10;
    L_InfoStr: array [1 .. L_InfoNum] of string = ('CompanyName',
      'FileDescription', 'FileVersion', 'InternalName', 'LegalCopyright',
      'LegalTradeMarks', 'OriginalFileName', 'ProductName', 'ProductVersion',
      'Comments');
  var
    s, LS: string;
    n, Len, i: DWORD;
    Buf: PChar;
    Value: PChar;
  begin
    Result := false;
    s := aExeFilename;
    aList.Clear;
    n := GetFileVersionInfoSize(PChar(s), n);
    if n > 0 then
    begin
      Buf := AllocMem(n);
      /// StrOut := StrOut + 'Размер буфера = ' + IntToStr(n);
      GetFileVersionInfo(PChar(s), 0, n, Buf);
      for i := 1 to L_InfoNum do
        if VerQueryValue(Buf, PChar('StringFileInfo\040904E4\' + L_InfoStr[i]),
          Pointer(Value), Len) then
          aList.Add(Concat(L_InfoStr[i], '=', Value))
        else
          aList.Add(Concat(L_InfoStr[i], '=', ''));
      FreeMem(Buf, n);
      Result := (aList.Count > 0);
    end
    else
      Result := false;
  end;

  function wa_GetversionInfo11(const aExeFilename: string;
    const aList: Tstrings): boolean;
  ///
  const
    L_InfoNum = 10;
    L_InfoStr: array [1 .. L_InfoNum] of string = ('CompanyName',
      'FileDescription', 'FileVersion', 'InternalName', 'LegalCopyright',
      'OriginalFileName', 'ProductName', 'ProductVersion', 'Comments',
      'LegalTradeMarks');
    VerTranslation: PChar = '\VarFileInfo\Translation';
    ///
  var
    VISize: cardinal;
    VIBuff: Pointer;
    trans: Pointer;
    BuffSize: cardinal;
    temp: integer;
    str: PChar;
    LangCharSet: string;
    L_LanguageInfo: string;
    i: integer;
    ///
    function GetStringValue(const From: string): string;
    begin
      VerQueryValue(VIBuff, PChar('\StringFileInfo\' + L_LanguageInfo + '\' +
        From), Pointer(str), BuffSize);
      if BuffSize > 0 then
        Result := str
      else
        Result := 'n/a';
    end;

  begin
    ///
    LangCharSet := '';
    Result := false;
    aList.Clear;
    ///
    VIBuff := nil;
    VISize := GetFileVersionInfoSize(PChar(aExeFilename), BuffSize);
    if VISize < 1 then
      Exit;
    /// raise EReadError.Create('Invalid version info record in file '+Filename);
    VIBuff := AllocMem(VISize);
    try
      GetFileVersionInfo(PChar(aExeFilename), cardinal(0), VISize, VIBuff);
      ///
      if VerQueryValue(VIBuff, VerTranslation, trans, BuffSize) then
      begin
        if BuffSize >= 4 then
        begin
          temp := 0;
          StrLCopy(@temp, PChar(trans), 2);
          LangCharSet := IntToHex(temp, 4);
          /// '040904E4'
          StrLCopy(@temp, PChar(trans) + 2, 2);
          L_LanguageInfo := LangCharSet; // +IntToHex(temp, 4);
        end
        else
          Exit;
        /// raise EReadError.Create('Invalid language info in file '+Filename);
        ///
        for i := 1 to L_InfoNum - 1 do
          aList.Add(Concat(L_InfoStr[i], '=', GetStringValue(L_InfoStr[i])));
        Result := true;
      end;
      ///
    finally
      FreeMem(VIBuff, VISize);
    end;
  end;

  { function wa_GetversionInfo(const aExeFilename:string; const aList:TStrings):boolean;
    var
    InfoSize, puLen: DWORD;
    Pt, InfoPtr: Pointer;
    VerInfo : TVSFixedFileInfo;
    begin
    aList.Clear;
    InfoSize := GetFileVersionInfoSize( PChar(aExeFilename), puLen );
    FillChar(VerInfo, SizeOf(TVSFixedFileInfo), 0);
    if InfoSize > 0 then
    begin
    GetMem(Pt,InfoSize);
    GetFileVersionInfo( PChar(aExeFilename), 0, InfoSize, Pt);
    VerQueryValue(Pt,'\',InfoPtr,puLen);
    Move(InfoPtr^, VerInfo, sizeof(TVSFixedFileInfo) );
    FreeMem(Pt);
    Result := True;
    aList.Add(Concat('CompanyName','=',VerInfo.
    end
    else Result := False;
    end;
  }

  function wa_GetversionInfo(const aExeFilename: string;
    const aList: Tstrings): boolean;
  const
    L_InfoNum = 10;
    L_InfoStr: array [1 .. L_InfoNum] of string = ('CompanyName',
      'FileDescription', 'FileVersion', 'InternalName', 'LegalCopyright',
      'OriginalFileName', 'ProductName', 'ProductVersion', 'Comments',
      'LegalTradeMarks');
    L_VerTranslation: PChar = '\\VarFileInfo\\Translation';
  type
    PDWORD = ^DWORD;
    PLangAndCodePage = ^TLangAndCodePage;

    TLangAndCodePage = packed record
      wLanguage: WORD;
      wCodePage: WORD;
    end;

    PLangAndCodePageArray = ^TLangAndCodePageArray;
    TLangAndCodePageArray = array [0 .. 0] of TLangAndCodePage;
  var
    loc_InfoBufSize: DWORD;
    loc_InfoBuf: PChar;
    loc_VerBufSize: DWORD;
    loc_VerBuf: PChar;
    cbTranslate: DWORD;
    lpTranslate: PDWORD;
    i, J: DWORD;
    L_Break: boolean;
  begin
    Result := false;
    aList.Clear;
    if (Length(aExeFilename) = 0) or (not fileexists(aExeFilename)) then
      Exit;
    loc_InfoBufSize := GetFileVersionInfoSize(PChar(aExeFilename),
      loc_InfoBufSize);
    if loc_InfoBufSize > 0 then
    begin
      loc_VerBuf := nil;
      loc_InfoBuf := AllocMem(loc_InfoBufSize);
      try
        if not GetFileVersionInfo(PChar(aExeFilename), 0, loc_InfoBufSize,
          loc_InfoBuf) then
          Exit;
        if not VerQueryValue(loc_InfoBuf, L_VerTranslation,
          Pointer(lpTranslate), DWORD(cbTranslate)) then
          Exit;
        if cbTranslate=0 then Exit;
        for i := 0 to (cbTranslate div SizeOf(TLangAndCodePage)) - 1 do
        begin
          L_Break := false;
          for J := 1 to L_InfoNum do
            if VerQueryValue(loc_InfoBuf,
              PChar(Format(Concat('StringFileInfo\0%x0%x\', L_InfoStr[J]),
              [PLangAndCodePageArray(lpTranslate)[i].wLanguage,
              PLangAndCodePageArray(lpTranslate)[i].wCodePage])),
              Pointer(loc_VerBuf), DWORD(loc_VerBufSize)) then
            begin
              aList.Add(Concat(L_InfoStr[J], '=', loc_VerBuf));
              L_Break := true;
            end;
          if L_Break = true then
          begin
            Result := true;
            break;
          end;
        end;
      finally
        FreeMem(loc_InfoBuf, loc_InfoBufSize);
      end;
    end;
  end;

  function wa_IsDriveReady(DriveLetter: char): bool;
  var
    OldErrorMode: WORD;
    OldDirectory: string;
  begin
    OldErrorMode := SetErrorMode(SEM_NOOPENFILEERRORBOX);
    GetDir(0, OldDirectory);
{$I-}
    ChDir(DriveLetter + ':\');
{$I+}
    if IoResult <> 0 then
      Result := false
    else
      Result := true;

    ChDir(OldDirectory);
    SetErrorMode(OldErrorMode);
  end;

  function wa_IsCreateFile(const aFileName: string): boolean;
  var
    TFS: TFileStream;
  begin
    Result := false;
    try
      // TFS:=TFileStream.Create(aFileName,fmOpenWrite);
      TFS := TFileStream.Create(aFileName, fmCreate);
      TFS.Free;
      Result := true;
    except
      // если попали сюда, значит файл занят (или отсутствует)
      Result := false;
    end;
  end;

  function wa_GetSpecialFolder(const CSIDL: integer): string;
  var
    RecPath: PwideChar;
  begin
    RecPath := StrAlloc(MAX_PATH);
    try
      FillChar(RecPath^, MAX_PATH, 0);
      if SHGetSpecialFolderPath(0, RecPath, CSIDL, false) then
        Result := RecPath
      else
        Result := '';
    finally
      StrDispose(RecPath);
    end;
  end;

  function wa_GetAppdataFolder: string;
  begin
    Result := wa_GetSpecialFolder(CSIDL_APPDATA);
  end;

  /// HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsNT\CurrentVersion\SystemRestore
  function wa_GetRegRestorePointsState(agetRg: integer): integer;
  var
    L_reg: TRegistry;
    L_Keyname: string;
    il, il1: integer;
  begin
    ///
    Result := -1;
    L_reg := wa_CreateRegistry(2); // Read
    ///
    with L_reg do
      try
        RootKey := HKEY_LOCAL_MACHINE;
        L_Keyname :=
          'SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore';
        if OpenKeyReadOnly(L_Keyname) = true then
        begin
          il := -1;
          if ValueExists('DisableSR') then
            il := ReadInteger('DisableSR');
          il1 := -1;
          if ValueExists('DisableConfig') then
            il1 := ReadInteger('DisableConfig');
        end;
        if (il < 0) and (il1 < 0) then
        begin
          CloseKey;
          L_Keyname :=
            'SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore\Setup_Last';
          if OpenKeyReadOnly(L_Keyname) = true then
          begin
            il := -1;
            if ValueExists('Generalize_DisableSR') then
              il := ReadInteger('Generalize_DisableSR');
            il1 := -1;
            if ValueExists('DisableSR') then
              il1 := ReadInteger('DisableSR');
            if (il > 0) or (il1 > 0) then
              Result := 0
            else if (il = 0) or (il1 = 0) then
              Result := 1;
          end
        end
        else
        begin
          if (il = 1) then
            Result := 0
          else if il = 0 then
            Result := 1
          else
            Result := 1;
        end;
      finally
        L_reg.Free;
      end;
  end;


function wa_GetPerfFrequency:int64;
 var L_Frequency: Int64;
begin
   Result:=0;
  try
   if QueryPerformanceFrequency(L_Frequency) then
    begin Result:=L_Frequency; exit; end;
   except
  end;
end;

function wa_GetPerfCounter:int64;
 var L_Count: Int64;
 begin
   Result:=0;
  try
   if QueryPerformanceCounter(L_Count) then
    begin Result:=L_Count; end;
   except
  end;
 end;

function wa_aWinDir:string;
   Var IntLen: Integer;
       StrBuffer: String;
 Begin
  SetLength(StrBuffer,1000);
  IntLen:=GetWindowsDirectory(PChar(StrBuffer),1000);
  Result:=Trim(Copy(StrBuffer,1,IntLen));
 end;

function wa_GetSysDiskPath:string;
 var LS:string;
 begin
  LS:=wa_aWinDir;
  Delete(LS,4,Length(LS)-3);
 end;

function wa_GetSysDisk:char;
var LS:string;
 begin
  LS:=wa_aWinDir;
  Result:=LS[1];
 end;

function wa_aSysDisk:char; assembler;
 asm
   mov eax,FS:[30h] // PEB
   mov eax,[eax+12] //  PPEB_LDR_DATA
   mov eax,[eax+28] // LIST_ENTRY
   mov eax,[eax] // LDR_DATA_TABLE_ENTRY
   mov eax,[eax+24] // FULL_NAME
   mov al,[eax]
 end;

 function wa_GetDiskSizes(const aDisk:string; var aTotalMb,aFreeMb:double):boolean;
 var ls:string;
     FreeBytesAvailableToCaller: TLargeInteger;
     FreeSize: TLargeInteger;
     TotalSize: TLargeInteger;
   begin
     Result:=false;
     LS:=aDisk;   //  'c:'
     if GetDiskFreeSpaceEx(Pchar(LS), FreeBytesAvailableToCaller, Totalsize, @FreeSize)=true then
      Result:=true;
     aTotalMb:=TotalSize/(1024*1024);
     aFreeMb:=FreeSize/(1024*1024);
   end;

  function wa_GetSystemDiskSizes(var aTotalMb,aFreeMb:double):boolean;
   begin
     Result:=wa_GetDiskSizes(Concat(wa_GetSysDisk,':'),aTotalMb,aFreeMb);
   end;

///////////////////////////////////////////////////////////////////////////////////////////////
///
function wa_CreateAppCurrentUserDirectory(const nAppName:string; var aResultDir:string; aRegime:Integer=0):Integer;
var LS:string;
    LFlag:Boolean;
 begin
  Result:=-1;
  Assert(nAppName<>'','CreateAppCurrentUserDirectory: application name is empty!');
  try
   LS:=Tpath.GetHomePath;
   except LS:='';
  end;
  if LS='' then
   try
     LS:=wa_GetSpecialFolderPath(CSIDL_LOCAL_APPDATA);
    except
      LS:='';
   end;
  ///
  if LS='' then begin Result:=-100; Exit; end;
  //
  LS:=Concat(LS,TPath.DirectorySeparatorChar,nAppName);
  try
   LFlag:=False;
   LFlag:=ForceDirectories(LS);
   except
    begin
     Result:=100;
     Exit;
    end;
  end;
  if LFlag=false then begin Result:=10; Exit; end;
  ///
  Result:=0; // !
  aResultDir:=LS;
 end;


function wa_GetGlobalMemorySizes(var aTotalMb,aFreeMb:double):boolean;
   var
       memInfo : TMemoryStatus;
begin
   Result:=False;
   MemInfo.dwLength := Sizeof(memInfo);
   GlobalMemoryStatus(memInfo);
   Result:=True;
   aTotalMb:=memInfo.dwTotalPhys/(1024*1024);
   aFreeMb:=memInfo.dwAvailPhys/(1024*1024);
 end;

 function CorrectTimeForTimeZone(aDt:TDatetime; aServerHourShift:Integer=0):TDateTime;
 begin
    Result:=TTimeZone.Local.ToLocalTime(aDt);
    if aServerHourShift<>0 then
       Result:=IncHour(Result,aServerHourShift);
 end;


type
  KnownFolderID = TGuid;

function SHGetKnownFolderPath(const rfid: KnownFolderID;
  dwFlags: DWORD; hToken: THandle; out ppszPath: PWideChar) :
  HResult; stdcall; external 'Shell32.dll';

function GetKnownFolderPath(const ID : KnownFolderID): WideString;
var
  Buffer: PWideChar;
begin
  Result := '';
  if Succeeded(SHGetKnownFolderPath(ID, 0, 0, Buffer)) then
  try
    Result := Buffer;
  finally
    CoTaskMemFree(Buffer);
  end;
end;

const FOLDERID_Downloads: KnownFolderID =
  '{374DE290-123F-4565-9164-39C4925E467B}';

function wa_getDownloadsPath:string;
 begin
  Result:=GetKnownFolderPath(FOLDERID_Downloads);
 end;

 ///   часть проверки запуска программы
///

function GetProcessByEXE(exename: string): THandle;
var
  hSnapshoot: THandle;
  pe32: TProcessEntry32;
  L_exeName: string;
begin
  Result := 0;
  hSnapshoot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if (hSnapshoot = 0) then
    Exit;
  pe32.dwSize := SizeOf(TProcessEntry32);
  if (Process32First(hSnapshoot, pe32)) then
    repeat
      L_exeName := WideCharToString(pe32.szExeFile);
      if (L_exeName <> '') and (AnsiCompareText(L_exeName, exename) = 0) then
      begin
        Result := pe32.th32ProcessID;
        exit;
      end;
    until not Process32Next(hSnapshoot, pe32);
end;


Function QueryFullProcessImageNameW(hProcess:THandle; dwFlags:Cardinal; lpExeName:PWideChar; Var lpdwSize:Cardinal) : Boolean; StdCall; External 'Kernel32.dll' Name 'QueryFullProcessImageNameW';

///  не работает на XP! - там отдельный вызов другого метода другой библиотеки

function GetFullPathForPID(Pid:Cardinal) : UnicodeString;
         Var   rLength:Cardinal;
               Handle:THandle;
         Begin Result:='';
               Handle:=OpenProcess(PROCESS_QUERY_INFORMATION, False, Pid);
               If Handle = INVALID_HANDLE_VALUE Then Exit;
               rLength:=256; // allocation buffer
               SetLength(Result, rLength+1); // for trailing space
               If Not QueryFullProcessImageNameW(Handle, 0, @Result[1],rLength) Then  Result:='' Else SetLength(Result, rLength);
               End;

function IsRunForFullFileName(const aExeFileName: string):Boolean;
var
  hSnapshoot: THandle;
  pe32: TProcessEntry32;
  L_fileOnlyName,L_exeName,L_fullFileName: string;
begin
  Result :=False;
  L_fileOnlyName:=ExtractFileName(aExeFileName);
  try
    hSnapshoot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if (hSnapshoot = 0) then
      Exit;
    pe32.dwSize := SizeOf(TProcessEntry32);
    if (Process32First(hSnapshoot, pe32)) then
      repeat
        L_exeName := WideCharToString(pe32.szExeFile);
        if (L_exeName <> '') and (AnsiCompareText(L_exeName,L_fileOnlyName) = 0) and (pe32.th32ProcessID>0) then
        begin
          ///
          try
            L_fullFileName:=GetFullPathForPID(pe32.th32ProcessID);
           except on E:Exception do
            L_fullFileName:='';
          end;
          if (Length(L_fullFileName)>0) and (AnsiCompareText(L_fullFileName,aExeFileName) = 0) then
           begin
             Result:=True;
             exit;
           end;
        end;
      until not Process32Next(hSnapshoot, pe32);
   except on E:Exception do
     Result:=False;
  end;
end;

 function get_FileSize(const fileName :String) : Int64;
 var
   sr : TSearchRec;
 begin
   if System.SysUtils.FindFirst(fileName, faAnyFile, sr ) = 0 then
      result := Int64(sr.FindData.nFileSizeHigh) shl Int64(32) + Int64(sr.FindData.nFileSizeLow)
   else
      result := -1;
   System.SysUtils.FindClose(sr);
 end;



end.
