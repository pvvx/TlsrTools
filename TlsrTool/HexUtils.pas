unit HexUtils;

interface
uses Windows,SysUtils;

function BufToHexStr(Buf:Pointer; BufLen: integer): string;
function BufToHex_Str(Buf:Pointer; BufLen: integer; ch : char): string;
function HexToByteStr(Buf:Pointer; BufLen: integer): string;
function HexTopByte(Buf:Pointer; BufLen: integer; OutBuf : pointer): integer;
//function HexToByteStr(Buf:Pointer; BufLen: integer): string;
function BinToStr( bin: dword; bits: integer): string;
function StrToBin(const s: string): dword;
function Int2Digs(num,len : dword): string;

implementation

function Int2Digs(num,len : dword): string;
begin
   if len>10 then len := 10;
   result:=IntToStr(num);
   while dword(length(result))<len do result:='0'+result;
end;

function BufToHexStr(Buf:Pointer; BufLen: integer): string;
begin
 Result:='';
  while BufLen > 0 do begin
   Result:=Result+IntToHex(Byte(Buf^), 2);
   inc(Integer(Buf)); dec(BufLen);
  end;
end;

function BufToHex_Str(Buf:Pointer; BufLen: integer; ch : char): string;
begin
  Result:='';
  while BufLen > 1 do begin
   Result:=Result+IntToHex(Byte(Buf^), 2)+ch;
   inc(Integer(Buf)); dec(BufLen);
  end;
  if BufLen > 0 then Result:=Result+IntToHex(Byte(Buf^), 2);
end;

function HexToByteStr(Buf:Pointer; BufLen: integer): string;
var
 i: integer;
 defHex : string;
begin
  defHex := '$PV'; i:=1;
  SetLength(Result,BufLen);
  while i<=BufLen do begin
   while not(((Char(Buf^)>='0') and (Char(Buf^)<='9'))
          or ((Char(Buf^)>='a') and (Char(Buf^)<='f'))
          or ((Char(Buf^)>='A') and (Char(Buf^)<='F'))) do
     if(Byte(Buf^)=0) then exit else inc(Dword(Buf));
   defHex[2] := Char(Buf^); inc(Dword(Buf));
   if not (((Char(Buf^)>='0') and (Char(Buf^)<='9'))
        or ((Char(Buf^)>='a') and (Char(Buf^)<='f'))
        or ((Char(Buf^)>='A') and (Char(Buf^)<='F'))) then begin
    defHex[3]:=defHex[2];
    defHex[2]:='0';
   end
   else begin
    defHex[3] := Char(Buf^); inc(Dword(Buf));
   end;
   Byte(Result[i]) := StrToIntDef(defHex,0);
   inc(i);
  end;
end;

function HexTopByte(Buf:Pointer; BufLen: integer; OutBuf : pointer): integer;
var
 i: integer;
 defHex : string;
begin
  defHex := '$PV'; i:=1;
  Result := 0;
  while i<=BufLen do begin
   while not(((Char(Buf^)>='0') and (Char(Buf^)<='9'))
          or ((Char(Buf^)>='a') and (Char(Buf^)<='f'))
          or ((Char(Buf^)>='A') and (Char(Buf^)<='F'))) do
     if(Byte(Buf^)=0) then exit else inc(Dword(Buf));
   defHex[2] := Char(Buf^); inc(Dword(Buf));
   if not (((Char(Buf^)>='0') and (Char(Buf^)<='9'))
        or ((Char(Buf^)>='a') and (Char(Buf^)<='f'))
        or ((Char(Buf^)>='A') and (Char(Buf^)<='F'))) then begin
    defHex[3] := defHex[2];
    defHex[2] := '0';
   end
   else begin
    defHex[3] := Char(Buf^); inc(Dword(Buf));
   end;
   Byte(OutBuf^) := StrToIntDef(defHex,0);
   inc(integer(OutBuf));
   inc(Result);
   inc(i);
  end;
end;

function BinToStr( bin: dword; bits: integer): string;
var
 i,x : integer;
 mask : dword;
 Buffer : array[0..32] of Char;
begin
  result:='';
  if bits=0 then begin
   result:='0';
   exit;
  end;
  mask := 1 shl (bits-1);
  x := bits;
  if x > 32 then x:=32;
  for i:=0 to x do begin
   if (bin and mask) <> 0 then
     Buffer[i]:='1'
   else
     Buffer[i]:='0';
   mask := mask shr 1;
  end;
  Buffer[x]:=#0;
  result := Buffer;
end;

function StrToBin(const s: string): dword;
var
 i: integer;
 m: dword;
begin
    i:=1;
    m:=1;
    result := 0;
    while (i <= Length(s)) and ((s[i] = '1') or (s[i] = '0')) do inc(i);
    while i>1 do begin
      dec(i);
      if s[i] = '1' then
        result := result or m;
      m := m shl 1;
    end;
end;


end.