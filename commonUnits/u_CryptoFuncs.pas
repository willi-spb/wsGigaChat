unit u_CryptoFuncs;

interface

function ch_EncryptStr(const S :WideString; Key: Word): String;
function ch_DecryptStr(const S: String; Key: Word): String;

{
  txt2.Text:= EncryptStr(txt1.Text, 223);
  lbl1.Caption:= DecryptStr(txt2.Text, 223);
 }

function base64Encode(const AText:string):string;
function base64Decode(const AText:string):string;


implementation

uses System.Classes,System.SysUtils,
/// for Base64
  System.NetEncoding;

const CKEY1 = 53761;
      CKEY2 = 32618;

function ch_EncryptStr(const S :WideString; Key: Word): String;
var   i          :Integer;
      RStr       :RawByteString;
      RStrB      :TBytes Absolute RStr;
begin
  Result:= '';
  RStr:= UTF8Encode(S);
  for i := 0 to Length(RStr)-1 do begin
    RStrB[i] := RStrB[i] xor (Key shr 8);
    Key := (RStrB[i] + Key) * CKEY1 + CKEY2;
  end;
  for i := 0 to Length(RStr)-1 do begin
    Result:= Result + IntToHex(RStrB[i], 2);
  end;
end;

function ch_DecryptStr(const S: String; Key: Word): String;
var   i, tmpKey  :Integer;
      RStr       :RawByteString;
      RStrB      :TBytes Absolute RStr;
      tmpStr     :string;
begin
  tmpStr:= UpperCase(S);
  SetLength(RStr, Length(tmpStr) div 2);
  i:= 1;
  try
    while (i < Length(tmpStr)) do begin
      RStrB[i div 2]:= StrToInt('$' + tmpStr[i] + tmpStr[i+1]);
      Inc(i, 2);
    end;
  except
    Result:= '';
    Exit;
  end;
  for i := 0 to Length(RStr)-1 do begin
    tmpKey:= RStrB[i];
    RStrB[i] := RStrB[i] xor (Key shr 8);
    Key := (tmpKey + Key) * CKEY1 + CKEY2;
  end;
  Result:= UTF8Decode(RStr);
end;

function base64Encode(const AText:string):string;
 begin
  try
    Result:=TNetEncoding.Base64.Encode(AText);
    except on E:Exception do
     Result:='';
  end;
 end;



function base64Decode(const AText:string):string;
 begin
  try
    Result:=TNetEncoding.Base64.Decode(AText);
    except on E:Exception do
     Result:='';
  end;
 end;



end.
