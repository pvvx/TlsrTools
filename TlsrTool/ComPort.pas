unit ComPort;

interface
uses Windows,SysUtils;

var
 sComNane     : string = 'COM1'; // COM порт
 iComBaud     : integer = 115200; // Скорость COM порта
 flgComOpen   : boolean = False;
 hCom         : THandle=INVALID_HANDLE_VALUE;
 ComTimeouts  : TCommTimeouts;
 txLen, rxLen : Dword;
 FlgOvrlp     : boolean = False;
 COMwr : OVERLAPPED;
 COMrd : OVERLAPPED;
 COMst : COMSTAT;
 DCB          : TDCB;
 ComSizeInputBuffer : integer = 8192; // $20000;
 ComSizeOutputBuffer : integer = 8192; // $20000;

{ Флаги в DCB :
0      DWORD fBinary: 1;          // binary mode, no EOF check
1      DWORD fParity: 1;          // enable parity checking
2      DWORD fOutxCtsFlow:1;      // CTS output flow control
3      DWORD fOutxDsrFlow:1;      // DSR output flow control
4..5   DWORD fDtrControl:2;       // DTR flow control type
6      DWORD fDsrSensitivity:1;   // DSR sensitivity
7      DWORD fTXContinueOnXoff:1; // XOFF continues Tx
8      DWORD fOutX: 1;        // XON/XOFF out flow control
9      DWORD fInX: 1;         // XON/XOFF in flow control
10     DWORD fErrorChar: 1;   // enable error replacement
11     DWORD fNull: 1;        // enable null stripping
12..13 DWORD fRtsControl:2;   // RTS flow control
14     DWORD fAbortOnError:1; // abort reads/writes on error
15..31 DWORD fDummy2:17;      // reserved}

function OpenCom(Name:string) : boolean;
procedure CloseCom;
function GetComDCB : boolean;
function SetComDCB : boolean;
function GetComTimeouts : boolean;
function SetComTimeouts : boolean;
function SetComRxTimeouts(NewIntervalTimeout,NewTimeoutMultiplier,NewTimeoutConstant:dword) : boolean;
function ReadCom(Buf:Pointer; BufLen:Dword) : boolean;
function WriteCom(Buf:Pointer; BufLen:Dword) : boolean;
function EscapeComFunction(dwFunc:Dword) : boolean;
function GetComModemStatus(lpModemStat: Pointer):boolean;
function GetComStat : boolean;
function PurgeCom(mode:Dword): boolean;
function WriteComStr(S: String): boolean;
function ChangeComSpeed(Baud:integer) : boolean;
function SetComBufs  : boolean;

implementation

function OpenCom(Name:string) : boolean;
var
dw : dword;
begin
 result:=FALSE;
  if hCom<>INVALID_HANDLE_VALUE then CloseCom;
  if FlgOvrlp then dw:=FILE_FLAG_OVERLAPPED
  else dw:=FILE_ATTRIBUTE_NORMAL;
  hCom:=CreateFile(PChar('\\?\'+Name),GENERIC_READ or GENERIC_WRITE,0,nil,OPEN_EXISTING,dw,0);
  if hCom<>INVALID_HANDLE_VALUE then begin
   SetupComm(hCom,ComSizeInputBuffer,ComSizeOutputBuffer); //8192, 8192); // Rd , Wr
   if GetComDCB then begin
    DCB.Flags := (DCB.Flags and $ffff8000) or $0011;   //$1011;
    DCB.ByteSize := 8;
    DCB.Parity := 0;
    DCB.StopBits := 0;
    DCB.BaudRate := iComBaud;
    if SetComDCB then begin
     ComTimeouts.ReadIntervalTimeout:=10; //0
     ComTimeouts.ReadTotalTimeoutMultiplier:=1; //0
     ComTimeouts.ReadTotalTimeoutConstant:= 40; //200
     ComTimeouts.WriteTotalTimeoutMultiplier := 0;//MAXDWORD;
     ComTimeouts.WriteTotalTimeoutConstant:= 0;//MAXDWORD;
     SetComTimeouts;
     // sleep(300);
//      PurgeCom(PURGE_TXCLEAR or PURGE_RXCLEAR);
     flgComOpen := TRUE;
     result := TRUE;
    end;
   end;
  end;
end;

procedure CloseCom;
var
x: THandle;
begin
 if hCom<>INVALID_HANDLE_VALUE then begin
  x:=hCom;
  hCom:=INVALID_HANDLE_VALUE;
  CloseHandle(x);
 end;
 flgComOpen := False;
// hCom:=INVALID_HANDLE_VALUE;
end;

function GetComDCB : boolean;
begin
 result := FALSE;
 if hCom<>INVALID_HANDLE_VALUE then
  result := GetCommState(hCom,DCB);
end;

function SetComDCB : boolean;
begin
 result:=FALSE;
 if hCom<>INVALID_HANDLE_VALUE then
  result := SetCommState(hCom,DCB);
end;

function ChangeComSpeed(Baud:integer) : boolean;
var
save_baud : integer;
begin
 result:=FALSE;
 save_baud:=dcb.BaudRate;
 if hCom<>INVALID_HANDLE_VALUE then begin
//  dcb.BaudRate:=Baud;
  if GetComDCB then begin
   if dcb.BaudRate<>Dword(Baud) then begin
    dcb.BaudRate:=Baud;
    result := SetCommState(hCom,DCB);
    EscapeComFunction(SETRTS);
    EscapeComFunction(SETDTR);
    if not result then begin
     dcb.BaudRate:=save_baud;
     SetCommState(hCom,DCB);
     EscapeComFunction(SETRTS);
     EscapeComFunction(SETDTR);
    end;
   end;
  end;
 end;
end;

function GetComTimeouts : boolean;
begin
 result:=FALSE;
 if hCom<>INVALID_HANDLE_VALUE then
  result := GetCommTimeouts(hCom,ComTimeouts);
end;

function SetComTimeouts : boolean;
begin
 result:=FALSE;
 if hCom<>INVALID_HANDLE_VALUE then
  if SetCommTimeouts(hCom,ComTimeouts) then result:=TRUE;
end;

function SetComRxTimeouts(NewIntervalTimeout,NewTimeoutMultiplier,NewTimeoutConstant:dword) : boolean;
begin
 result:=FALSE;
 if (ComTimeouts.ReadIntervalTimeout<>NewIntervalTimeout)
 or (ComTimeouts.ReadTotalTimeoutMultiplier<>NewTimeoutMultiplier)
 or (ComTimeouts.ReadTotalTimeoutConstant<>NewTimeoutConstant)
 then begin
  ComTimeouts.ReadIntervalTimeout:=NewIntervalTimeout;
  ComTimeouts.ReadTotalTimeoutMultiplier:=NewTimeoutMultiplier;
  ComTimeouts.ReadTotalTimeoutConstant:=NewTimeoutConstant;
  if hCom<>INVALID_HANDLE_VALUE then
   if SetCommTimeouts(hCom,ComTimeouts) then result:=TRUE;
 end
 else result:=TRUE;
end;

function  GetComStat : boolean;
var
  dErr : DWORD;
begin
 result:=FALSE;
 dErr := 0;
// rxLen := 0;
 if hCom<>INVALID_HANDLE_VALUE then begin
   if ClearCommError(hCom,dErr,@COMst) then begin
     // size Rx buff := COMst.cbInQue;
     Result := True;
   end;
 end;
end;

function ReadCom(Buf:Pointer; BufLen :Dword) : boolean;
var
 dErr: Dword;
begin
 result := False;
 if (hCom<>INVALID_HANDLE_VALUE)and(Buf<>Nil)and(BufLen<>0) then begin
  rxlen:=0;
  if FlgOvrlp then begin
   COMrd.hEvent:=CreateEvent(Nil,TRUE,FALSE,Nil);
   if not ReadFile(hCom,Buf^,BufLen,rxLen,@COMrd) then begin
    if not GetOverlappedResult(hCom,COMrd,rxLen,True) then begin
    end;
   end;
//   ResetEvent(COMrd.hEvent);
   CloseHandle(COMrd.hEvent);
  end
  else begin
   if not ReadFile(hCom,Buf^,BufLen,rxLen,Nil) then begin
//     ClearCommError(hCom,dErr,Nil);
//     exit;
   end;
  end;
  if rxLen = BufLen then result := True
  else ClearCommError(hCom,dErr,Nil);
 end;
end;

function WriteCom(Buf:Pointer; BufLen:Dword) : boolean;
Var
 dErr: Dword;
begin
 result:=FALSE;
 if (hCom<>INVALID_HANDLE_VALUE)and(Buf<>Nil)and(BufLen<>0) then begin
  txLen:=0;
  if FlgOvrlp then begin
   COMwr.hEvent:=CreateEvent(Nil,TRUE,FALSE,Nil);
   if not WriteFile(hCom,Buf^,BufLen,txLen,@COMwr) then begin
    if not GetOverlappedResult(hCom,COMwr,txLen,True) then begin
    end;
//     ClearCommError(hCom,dErr,Nil);
   end;
//   ResetEvent(COMwr.hEvent);
   CloseHandle(COMwr.hEvent);
  end
  else begin
   if not WriteFile(hCom,Buf^,BufLen,txLen,Nil) then begin
//     ClearCommError(hCom,dErr,Nil);
//     exit;
   end;
  end;
  if txLen = BufLen then result:=TRUE
  else ClearCommError(hCom,dErr,Nil);
 end;
end;

function WriteComStr(S: String): boolean;
begin
  Result:=WriteCom(@S[1],Length(S));
end;

function PurgeCom(mode:Dword): boolean; //function
begin
 result := PurgeComm(hCom,mode); // сбросить буфера
end;

function EscapeComFunction(dwFunc:Dword):boolean;
begin
 result:=FALSE;
 if hCom<>INVALID_HANDLE_VALUE then
  result := EscapeCommFunction(hCom,dwFunc);
end;


function GetComModemStatus(lpModemStat:Pointer):boolean;
begin
 result:=FALSE;
 if hCom<>INVALID_HANDLE_VALUE then
  result := GetCommModemStatus(hCom,LpDword(lpModemStat)^);
end;

function SetComBufs  : boolean;
begin
 if SetupComm(hCom,ComSizeInputBuffer,ComSizeOutputBuffer) then result:=TRUE
 else result:=FALSE;
end;


end.
