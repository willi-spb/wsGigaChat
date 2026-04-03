unit u_imgFuncs;

interface

uses System.Classes, Vcl.Graphics;

 function imf_getLastErrorStr:string;
 procedure imf_clearErrors;
 function imf_IsErrors:Boolean;
 function imf_GetFullFileName(const aName,aPath:string):string;
 function imf_GetPicture(const aName,aPath:string; aDst:TPicture):Boolean;
 function imf_SetPicture(const aName,aPath:string; aSrc:TPicture):Boolean;
 function imf_ReplaceFile(const anewName,anewPath,aName,aPath:string; aDeleteNewFlag:boolean):Boolean;
 function imf_getSHA1String(const AStream:TStream):string;
 function imf_getSHA1FileToString(const aName,aPath:string):string;
 /// <summary>
 ///   под вопросом
 /// </summary>
 function imf_VerifyPicture(const aName,aPath:string; aSrc:TPicture):Boolean;
 function imf_IsEqualFiles(const aName1,aPath1,aName2,aPath2:string):Boolean;
 /// <summary>
 ///   проверяем по Sha1 - если не совпадают или нет старого, то записываем новый вместо старого
 /// </summary>
 function imf_UpdateFile(const anewName,anewPath,aName,aPath:string; aDeleteNewFlag:boolean):Boolean;


implementation

 uses System.SysUtils, System.Hash,
      System.IOUtils;

 var lastErrorStr:string;

  function imf_getLastErrorStr:string;
   begin
     Result:=lastErrorStr;
   end;

  procedure imf_clearErrors;
   begin
    lastErrorStr:='';
   end;

  function imf_IsErrors:Boolean;
   begin
     Result:=(Length(lastErrorStr)>0);
   end;

 function imf_GetFullFileName(const aName,aPath:string):string;
  begin
   if Length(aPath)>0 then
      Result:=IncludeTrailingPathDelimiter(aPath)+aName
   else Result:=aName;
  end;

 function imf_GetPicture(const aName,aPath:string; aDst:TPicture):Boolean;
 var L_FileName:string;
  begin
    Result:=False;
    L_FileName:=imf_GetFullFileName(aName,aPath);
    if FileExists(L_FileName)=false then
       begin
         lastErrorStr:='File '+aName+' not found!';
         Exit;
       end
    else
      try
       aDst.LoadFromFile(L_FileName);
       if (aDst.Height=0) or (aDst.Width=0) then
          lastErrorStr:='In file not correct image!'
       else Result:=True;
       except on E:Exception do
        lastErrorStr:='imf_GetPicture Error:'+E.ClassName+' '+E.Message;
    end;
  end;

 function imf_SetPicture(const aName,aPath:string; aSrc:TPicture):Boolean;
 var L_FileName:string;
  begin
    Result:=False;
    if (aSrc.Height=0) or (aSrc.Width=0) then
       lastErrorStr:='imf_SetPicture - empty picture!'
    else
     begin
      L_FileName:=imf_GetFullFileName(aName,aPath);
      if FileExists(L_FileName) then
       try
        DeleteFile(L_FileName);
        except on E:Exception do
        lastErrorStr:='imf_SetPicture Delete File: '+aName+' Error:'+E.ClassName+' '+E.Message;
       end;
       try
        aSrc.SaveToFile(L_FileName);
        Result:=FileExists(L_FileName);
        if Result=false then
          lastErrorStr:='File not write!';
        except on E:Exception do
         lastErrorStr:='imf_SetPicture Error:'+E.ClassName+' '+E.Message;
       end;
     end;
   end;

function imf_ReplaceFile(const anewName,anewPath,aName,aPath:string; aDeleteNewFlag:boolean):Boolean;
var L_FileName,L_NewFileName:string;
 begin
   Result:=false;
   L_NewFileName:=imf_GetFullFileName(anewName,anewPath);
   L_FileName:=imf_GetFullFileName(aName,aPath);
   if FileExists(L_NewFileName)=false then
      lastErrorStr:='imf_UpdateFile - not found New file!'
   else
    begin
    { if FileExists(L_FileName) then
       try
        DeleteFile(L_FileName);
        except on E:Exception do
        lastErrorStr:='imf_UpdateFile Delete File: '+aName+' Error:'+E.ClassName+' '+E.Message;
       end;
       }
      try
        TFile.Copy(L_NewFileName,L_FileName,True);
        Result:=FileExists(L_FileName);
        except on E:Exception do
        lastErrorStr:='imf_UpdateFile Copy File: '+aName+' Error:'+E.ClassName+' '+E.Message;
      end;
      if (Result=True) and (aDeleteNewFlag=True) then
         if FileExists(L_NewFileName) then
           try
            Result:=False;
            DeleteFile(L_NewFileName);
            Result:=True;
            except on E:Exception do
             lastErrorStr:='imf_UpdateFile Delete NEWFile: '+aName+' Error:'+E.ClassName+' '+E.Message;
           end;
    end;
 end;

function imf_getSHA1String(const AStream:TStream):string;
var HashSHA1:THashSHA1;
    read: integer;
    buffer: array[0..16383] of byte;
begin
  Result:='';
  HashSHA1:=THashSHA1.Create; // record
  try
    repeat
     read :=AStream.Read(buffer,Sizeof(buffer));
     HashSHA1.Update(buffer,read);
    until read <> Sizeof(buffer);
    Result:=HashSHA1.HashAsString;
    except on E:Exception do
         lastErrorStr:='imf_getSHA1String READ Error:'+E.ClassName+' '+E.Message;
  end;
end;

function imf_getSHA1FileToString(const aName,aPath:string):string;
var FS: TFileStream;
    L_FileName:string;
begin
  Result:='';
  L_FileName:=imf_GetFullFileName(aName,aPath);
    if FileExists(L_FileName)=false then
       begin
         lastErrorStr:='File '+aName+' not found!';
         Exit;
       end
    else
      try
       try
        FS:=TFile.OpenRead(L_FileName);
        Result:=imf_getSHA1String(FS);
        except on E:Exception do
            lastErrorStr:='imf_getSHA1FileToString READ File Error:'+E.ClassName+' '+E.Message;
       end;
      finally
        FS.Free;
      end;
end;

function imf_VerifyPicture(const aName,aPath:string; aSrc:TPicture):Boolean;
var L_fileHash,L_picHash:string;
    L_pstr:TMemoryStream;
 begin
   Result:=False;
   L_fileHash:=imf_getSHA1FileToString(aName,aPath);
   if Length(L_fileHash)>0 then
     begin
       L_pstr:=TMemoryStream.Create;
       try
        aSrc.Bitmap.SaveToStream(L_pstr);
        L_pstr.Seek(0,0);
        L_picHash:=imf_getSHA1String(L_pStr);
        if Length(L_picHash)>0 then
           Result:=CompareText(L_fileHash,L_picHash)=0;
       finally
        L_pstr.Free;
       end;
     end;
 end;

function imf_IsEqualFiles(const aName1,aPath1,aName2,aPath2:string):Boolean;
var L_Hash1,L_Hash2:string;
 begin
   Result:=False;
   L_Hash1:=imf_getSHA1FileToString(aName1,aPath1);
   L_Hash2:=imf_getSHA1FileToString(aName2,aPath2);
   if (Length(L_Hash1)>0) and (Length(L_Hash2)>0) then
       Result:=CompareText(L_Hash1,L_Hash2)=0;
 end;

function imf_UpdateFile(const anewName,anewPath,aName,aPath:string; aDeleteNewFlag:boolean):Boolean;
var L_Hash,L_NewHash:string;
 begin
   Result:=False;
   L_Hash:=imf_getSHA1FileToString(aName,aPath);
   L_NewHash:=imf_getSHA1FileToString(anewName,anewPath);
   if (Length(L_newHash)>0) then
     if CompareText(L_Hash,L_newHash)<>0 then
       begin
         Result:=imf_ReplaceFile(anewName,anewPath,aName,aPath,aDeleteNewFlag);
       end;
 end;


end.
