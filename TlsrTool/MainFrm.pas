unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, IniFiles;
const
  FLASH_SIZE = $1000000;
  FLASH_826x_MAX_SIZE = $400000;
  FLASH_SEC_SIZE = 4096;

	FLASH_WRITE_CMD			=	$02;
	FLASH_READ_CMD			=	$03;
	FLASH_WRITE_ENABLE_CMD 	= 	$06;
	FLASH_WRITE_DISABLE_CMD = 	$04;
	FLASH_WRITE_STATUS_CMD	=	$01;
	FLASH_READ_STATUS_CMD	=	$05;
	FLASH_SECT_ERASE_CMD	=	$20;
	FLASH_BLK_ERASE_CMD		=	$D8;
  FLASH_CHIP_ERASE_CMD =  $60;
	FLASH_POWER_DOWN		=	$B9;
	FLASH_GET_JEDEC_ID		=	$9F;

  MCU_USB_ID_8266		= $5325;
  MCU_USB_ID_8267		= $5326;
  MCU_USB_ID_8269		= $5327;

  RAM_SIZE = $10000;

  BOOT_EXT_ADDR = $8004;
  BOOT_EXT_LEN = 16;
  BOOT_BUF_LEN = 8192;

type
  t_ext = packed record
      faddr    : Dword;
      pbuf     : Dword;
      count    : word;
      cmd      : word;
      iack     : word;
      oack     : word;
  end;
  t_stm = packed record
      ver   : word;
      pa    : word;
      pb    : word;
      pc    : word;
  end;
  t_gpio = packed record
      rd_ok : boolean;
      odr   : array[0..3] of dword;
      crx   : array[0..5] of dword;
  end;

  TfrmMain = class(TForm)
    ComboBox: TComboBox;
    ButtonOpen: TButton;
    ButtonLoad: TButton;
    ButtonRdAll: TButton;
    ButtonReScanComDevices: TButton;
    StatusBar: TStatusBar;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    EditRegAddr: TEdit;
    ButtonWrite: TButton;
    ButtonRead: TButton;
    EditRegData: TEdit;
    EditLdAddr: TEdit;
    ButtonFWrite: TButton;
    ButtonChErase: TButton;
    ButtonFRead: TButton;
    EditFAddr: TEdit;
    EditFwAddr: TEdit;
    EditFRLen: TEdit;
    ButtonSoftReset: TButton;
    ButtonCPURun: TButton;
    ButtonActivate: TButton;
    EditACount: TEdit;
    EditSpeed: TEdit;
    ButtonReset: TButton;
    ButtonSpeed: TButton;
    ButtonCpuStop: TButton;
    ButtonRSTGND: TButton;
    ButtonTest: TButton;
    EditFCmd: TEdit;
    ButtonASpeed: TButton;
    EditTimeReset: TEdit;
    ButtonSectorErase: TButton;
    CheckBoxFSEEna: TCheckBox;
    ButtonFFRead: TButton;
    ButtonBreak: TButton;
    ButtonSFWrite: TButton;
    LabelFLoaderVer: TLabel;
    Timer: TTimer;
    PanelSTM: TPanel;
    CheckBoxChkGpio: TCheckBox;
    LabelStm: TLabel;
    ShapePB0: TShape;
    LabelNameGPIO: TLabel;
    ShapePB1: TShape;
    ShapePB2: TShape;
    ShapePB3: TShape;
    ShapePB4: TShape;
    ShapePB5: TShape;
    ShapePB6: TShape;
    ShapePB7: TShape;
    LabelGPIO: TLabel;
    ShapePB8: TShape;
    ShapePB9: TShape;
    ShapePB10: TShape;
    ShapePB11: TShape;
    ShapePB12: TShape;
    ShapePB13: TShape;
    ShapePB14: TShape;
    ShapePB15: TShape;
    ButtonRSTOff: TButton;
    ShapeRun: TShape;
    ShapePC13: TShape;
    ShapePC14: TShape;
    ShapePC15: TShape;
    Label1: TLabel;
    ShapePA0: TShape;
    ShapePA1: TShape;
    ShapePA2: TShape;
    ShapePA3: TShape;
    ShapePA4: TShape;
    ShapePA5: TShape;
    ShapePA6: TShape;
    ShapePA7: TShape;
    ShapePA8: TShape;
    ShapePA9: TShape;
    ShapePA10: TShape;
    Label2: TLabel;
    ShapePA15: TShape;
    ButtonAnaRead: TButton;
    EditSTMSpeed: TEdit;
    LabelSWM: TLabel;
    LabelDevID: TLabel;
    ButtonAWrite: TButton;
    ButtonARdAll: TButton;
    procedure ReScanComDevices;
    procedure ButtonReScanComDevicesClick(Sender: TObject);
//    procedure CloseChkGPIO;
    procedure ReadIni;
    procedure WriteIni;
    procedure MenuDisable;
    procedure MenuEnable;
    procedure GetVarSpeedSwmSws;
    function AutoSpeedSwm : boolean;
    function IndexOfComName(const S: String): Integer;
    function StmCmd(cmd : byte) : boolean;
    function StmCmdByte(cmd : byte; data: byte) : boolean;
    function StmCmdWord(cmd : byte; data: word) : boolean;
    function StmCmdPDword(cmd : Byte; pdata : pDword) : boolean;
    function StmCmdSetSCS(addr : Dword; data: byte) : boolean;
    function StmCmdSetSRC(addr : Dword) : boolean;
    function StmCmdActivate : boolean;
    function StmCmdVersion : boolean;
    function StmRdRegs : boolean;
    function ARegEnable : boolean;
    function SwireCpuStop : boolean;
    function SwireFlashSetCsHigh : boolean;
    function SwireFlashSectorErase(faddr: Dword) : boolean;
    function SwireFlashRead(faddr: Dword; DataLen: Dword) : boolean;
    function SwireFlashWrite(faddr: Dword; DataLen: Dword) : boolean;
    function SwireFlashChipErase : boolean;
    function SwireRead(Addr: Dword; DataLen: Dword) : boolean;
    function SwireWrite(Addr: Dword; Data: Dword; DataLen: Dword) : boolean;
    function SwireWrBuf(Addr: Dword; Buf: Pointer; DataLen: Dword) : boolean;
    function SwireGetStatusFlash : Dword;
    function SwireFlashWriteStatus(fsta: Byte) : boolean;
    function SwireFlashWriteEnable : boolean;
    function StartFLoader : boolean;
    function CommandFLoader : boolean;
    function WaitCommandFLoader : boolean;
    function AdapSwireSpeed(start : Dword; stop: Dword) : boolean;
    function SetComName: boolean;
    procedure ButtonOpenClick(Sender: TObject);
    procedure SetGPIO(areg : dword);
    procedure FormCreate(Sender: TObject);
    procedure ComboBoxChange(Sender: TObject);
    procedure ButtonReadClick(Sender: TObject);
    procedure ButtonWriteClick(Sender: TObject);
    procedure ButtonReadAllClick(Sender: TObject);
    procedure ButtonLoadClick(Sender: TObject);
    procedure ButtonFWriteClick(Sender: TObject);
    procedure ButtonEraAllClick(Sender: TObject);
    procedure ButtonFReadClick(Sender: TObject);
    procedure ButtonRebootClick(Sender: TObject);
    procedure ButtonCPURunClick(Sender: TObject);
    procedure ButtonActivateClick(Sender: TObject);
    procedure ButtonResetClick(Sender: TObject);
    procedure ButtonSpeedClick(Sender: TObject);
    procedure ButtonCpuStopClick(Sender: TObject);
    procedure ButtonRSTGNDClick(Sender: TObject);
    procedure ButtonTestClick(Sender: TObject);
    procedure ButtonASpeedClick(Sender: TObject);
    procedure ButtonSectorEraseClick(Sender: TObject);
    procedure ButtonFFReadClick(Sender: TObject);
    procedure ButtonBreakClick(Sender: TObject);
    procedure ButtonSFWriteClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CheckBoxChkGpioClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure ButtonRSTOffClick(Sender: TObject);
    procedure ShapePB0MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapePB1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapePB2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapePB3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapePB4MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapePB5MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapePB6MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapePB7MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapePB8MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapePB9MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapePB10MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapePB11MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapePB12MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapePB13MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapePB14MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapePB15MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapePC13MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapePC15MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapePC14MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapePA0MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapePA1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapePA5MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapePA7MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapePA6MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapePA2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapePA3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapePA8MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapePA9MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapePA10MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapePA4MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapePA15MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ButtonAnaReadClick(Sender: TObject);
    procedure ButtonAWriteClick(Sender: TObject);
    procedure ButtonARdAllClick(Sender: TObject);
  private
    { Private declarations }

    flgReadGpioOn : boolean;
    ConnectStartTime : Dword;
    ConnectTime : Dword;
    SigBreak : boolean;
    old_sec_erase : Dword;
    ext_addr : Dword;
    ext : t_ext;
    stm : t_stm;
    gpio : t_gpio;
    cntrun : dword;
    swdata : array[0..65535] of byte;
    fldata : array[0..16777215] of byte;
    SoC_ID : word;

{
32 MHz CLK CPU TLSR826x:
 reg_swire_clk_div = 0x7f -> swire bit = 19.82 us ~ 50 Kbps
 reg_swire_clk_div = 5 -> swire bit = 0.782 us    ~ 1.28 Mbps
 reg_swire_clk_div = 2 -> swire bit = 0.312556 us ~ 3.2 Mbps
 reg_swire_clk_div = 1 -> swire bit = 0.156222 us ~ 6.4 Mbps
 reg_swire_clk_div = 0 -> swire bit = 2.637333 us ~ 380 Kbps - ???

     speed_sws_bps := tlsr_clk (div 5) div speed_sws;

Speed SPI STM32F103:
	0: 36 MHz (72 MHz / 2)
	1: 18 MHz (72 MHz / 4)
	2: 9 MHz (72 MHz / 8)
	3: 4.5 MHz (72 MHz / 16)
	4: 2.25 MHz (72 MHz / 32)
	5: 1.125 MHz (72 MHz / 64)
	6: 562 kHz (72 MHz / 128)
	7: 281 kHz (72 MHz / 256)

SWM Speed STM32F103 (SPI_BITS 7):
	0: 5142857.1 bps (72 MHz / 2 / 7)
	1: 2571428.5 bps (72 MHz / 4 / 7)
	2: 1285714.3 bps (72 MHz / 8 / 7)
	3: 642857.1 bps (72 MHz / 16 / 7)
	4: 321428.6 bps (72 MHz / 32 / 7)
	5: 160714.3 bps (72 MHz / 64 / 7)
	6: 80357.1 bps (72 MHz / 128 / 7)
	7: 40178.6 bps (72 MHz / 256 / 7)

     speed_swm_bps := ((36000000 div (1 shl speed_stm)) div 7);
     speed_swm_mbps := speed_swm_bps / 1000000.0;
}
    speed_sws : Dword;
    speed_stm : Dword;
    speed_swm_bps : Dword; // bps
    speed_swm_mbps : double; // mbps

  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
  FlashLoaderFname : string = 'floader8269.bin';
  FlashLoaderExtpAddr : dword = BOOT_EXT_ADDR;
  IniFile : TIniFile = nil;
  IniFileName : string = '.\tlsrtool.ini';
  BuildInfoString: string;

implementation

uses
  StrUtils, ComPort, HexUtils, STMGpio;

{$R *.dfm}

function Str2dword(const s: string): Dword;
var
 i: integer;
 o : string;
 hex : boolean;
begin
    i := 1;
    hex := False;
//  result := 0;
    while (i <= Length(s)) do begin
      if ((s[i] = '0') and (s[i+1] = 'x')) then begin
       hex := True;
       inc(i);
      end
      else if (s[i] = '$') then  hex := True
      else if (((s[i] >= 'a') and (s[i] <= 'f'))
      or ((s[i] >= 'A') and (s[i] <= 'F'))) then begin
       hex := True;
       o := o + s[i];
      end
      else if ((s[i] >= '0') and (s[i] <= '9')) then o := o + s[i];
      inc(i);
    end;
    if hex then result := StrToIntDef('$'+o,0)
    else result := StrToIntDef(o,0)
end;

function TfrmMain.IndexOfComName(const S: String): Integer;
var
  I : Integer;
begin
  Result := -1;
  for I := 0 to ComboBox.Items.Count-1 do
  begin
    if ComboBox.Items.Strings[I] = S then
    begin
      Result := I;
      Exit;
    end;
  end;
end;

// Чтение переменных из .ini
procedure TfrmMain.ReadIni;
begin
   if IniFile = nil then IniFile := TIniFile.Create(IniFileName);
   if IniFile.ReadString('System','Version','') = '' then begin
     IniFile.WriteString('System','Version', BuildInfoString);
     IniFile.WriteString('System','Version', Caption);
     IniFile.WriteString('FlashLoader','FileName', FlashLoaderFname);
     IniFile.WriteInteger('FlashLoader','ExtAddr', FlashLoaderExtpAddr);
     IniFile.WriteInteger('Setup','Top',Top);
     IniFile.WriteInteger('Setup','Left',Left);
     IniFile.WriteInteger('Setup','Width',Width);
     IniFile.WriteInteger('Setup','Height',Height);
//     IniFile.WriteFloat('System','TriggerI', TriggerI);
   end
   else begin
     FlashLoaderFname := IniFile.ReadString('FlashLoader','FileName', FlashLoaderFname);
     FlashLoaderExtpAddr := IniFile.ReadInteger('FlashLoader','ExtAddr', FlashLoaderExtpAddr);

     Top := IniFile.ReadInteger('Setup','Top',0);
     Left := IniFile.ReadInteger('Setup','Left',0);
     if Screen.DesktopHeight <= Top then Top := 10;
     if Screen.DesktopWidth <= Left then Left := 10;
     Height := IniFile.ReadInteger('Setup','Height',Height);
     Width := IniFile.ReadInteger('Setup','Width',Width);
     sComNane := IniFile.ReadString('Setup','ComPort', sComNane);
   end;
   IniFile.UpdateFile;
end;

// Запись переменных в *.ini
procedure TfrmMain.WriteIni;
begin
     IniFile.WriteString('System','Version', BuildInfoString);
     IniFile.WriteInteger('Setup','Top',Top);
     IniFile.WriteInteger('Setup','Left',Left);
     IniFile.WriteInteger('Setup','Width',Width);
     IniFile.WriteInteger('Setup','Height',Height);
     IniFile.WriteString('Setup','ComPort',sComNane);
     IniFile.WriteInteger('FlashLoader','ExtAddr', FlashLoaderExtpAddr);
     IniFile.UpdateFile;
end;

//Достает из строки с нуль-терминированными подстроками следующую нуль-терминированную
//подстроку начиная с позиции aStartPos, потом устанавливает aStartPos на символ
//следующий за терминирующим #0.
function GetNextSubstring(aBuf: string; var aStartPos: integer): string;
var
  vLastPos: integer;
begin
  if (aStartPos < 1) then
    begin
      raise ERangeError.Create('aStartPos должен быть больше 0');
    end;

  if (aStartPos > Length(aBuf) ) then
    begin
      Result := '';
      Exit;
    end;

  vLastPos := PosEx(#0, aBuf, aStartPos);
  Result := Copy(aBuf, aStartPos, vLastPos - aStartPos);
  aStartPos := aStartPos + (vLastPos - aStartPos) + 1;
end;


//Заполняет список aList наденными в системе COM портами
procedure GetComPorts(aList: TStrings; aNameStart: string);
var
  vBuf: string;
  vRes: integer;
  vErr: Integer;
  vBufSize: Integer;
  vNameStartPos: Integer;
  vName: string;
begin
  vBufSize := 1024 * 5;
  vRes := 0;

  while vRes = 0 do
    begin
      setlength(vBuf, vBufSize) ;
      SetLastError(ERROR_SUCCESS);
      vRes := QueryDosDevice(nil, @vBuf[1], vBufSize) ;
      vErr := GetLastError();

      //Вариант для двухтонки
      if (vRes <> 0) and (vErr = ERROR_INSUFFICIENT_BUFFER) then
        begin
          vBufSize := vRes;
          vRes := 0;
        end;

      if (vRes = 0) and (vErr = ERROR_INSUFFICIENT_BUFFER) then
        begin
          vBufSize := vBufSize + 1024;
        end;

      if (vErr <> ERROR_SUCCESS) and (vErr <> ERROR_INSUFFICIENT_BUFFER) then
        begin
          raise Exception.Create(SysErrorMessage(vErr) );
        end
    end;
  setlength(vBuf, vRes) ;

  vNameStartPos := 1;
  vName := GetNextSubstring(vBuf, vNameStartPos);

  aList.BeginUpdate();
  try
    aList.Clear();
    while vName <> '' do
      begin
        if AnsiStartsStr(aNameStart, vName) then
          aList.Add(vName);
        vName := GetNextSubstring(vBuf, vNameStartPos);
      end;
  finally
    aList.EndUpdate();
  end;
end;

function TfrmMain.SetComName: boolean;
begin
  result:=False;
  sComNane:=ComboBox.Items.Strings[ComboBox.ItemIndex];
  if(sComNane='') then begin
    StatusBar.Panels[0].Text:='COM?';
    StatusBar.Panels[1].Text:='Не выбран COM порт!';
  end
  else begin
    StatusBar.Panels[0].Text:=sComNane;
    StatusBar.Panels[1].Text:='Выбран '+sComNane+'.';
    result:=True;
  end;
end;

procedure TfrmMain.ReScanComDevices;
begin
  ComboBox.Items.Clear;
  GetComPorts(ComboBox.Items, 'COM');
  if(sComNane <> '') then begin
    ComboBox.ItemIndex := IndexOfComName(sComNane);
  end
  else
    ComboBox.ItemIndex:=0;
  SetComName;
end;

procedure TfrmMain.ButtonReScanComDevicesClick(Sender: TObject);
begin
  ReScanComDevices;
end;

procedure TfrmMain.MenuEnable;
begin
          ButtonRdAll.Enabled := True;
          ButtonLoad.Enabled := True;
          ButtonWrite.Enabled := True;
          ButtonRead.Enabled := True;
          ButtonFRead.Enabled := True;
          ButtonFWrite.Enabled := True;
          ButtonReset.Enabled := True;
          ButtonActivate.Enabled := True;
          ButtonSpeed.Enabled := True;
          ButtonSoftReset.Enabled := True;
          ButtonCPURun.Enabled := True;
          ButtonChErase.Enabled := True;
          ButtonCpuStop.Enabled := True;
          ButtonRSTGND.Enabled := True;
          ButtonRSTOff.Enabled := True;
          ButtonTest.Enabled := True;
          ButtonASpeed.Enabled := True;
          ButtonSectorErase.Enabled := True;
          ButtonFFRead.Enabled := True;
          ButtonSFWrite.Enabled := True;
          ButtonAnaRead.Enabled := True;
          ButtonAWrite.Enabled := True;
          ButtonARdAll.Enabled := True;
          flgReadGpioOn := True;
end;

procedure TfrmMain.MenuDisable;
begin
     flgReadGpioOn := False;
     ButtonRdAll.Enabled := False;
     ButtonLoad.Enabled := False;
     ButtonWrite.Enabled := False;
     ButtonRead.Enabled := False;
     ButtonFRead.Enabled := False;
     ButtonFWrite.Enabled := False;
     ButtonReset.Enabled := False;
     ButtonActivate.Enabled := False;
     ButtonSpeed.Enabled := False;
     ButtonSoftReset.Enabled := False;
     ButtonCPURun.Enabled := False;
     ButtonChErase.Enabled := False;
     ButtonCpuStop.Enabled := False;
     ButtonRSTGND.Enabled := False;
     ButtonRSTOff.Enabled := False;
     ButtonTest.Enabled := False;
     ButtonASpeed.Enabled := False;
     ButtonSectorErase.Enabled := False;
     ButtonFFRead.Enabled := False;
     ButtonSFWrite.Enabled := False;
     ButtonAnaRead.Enabled := False;
     ButtonAWrite.Enabled := False;
     ButtonARdAll.Enabled := False;
     if flgComOpen then
          PurgeCom(PURGE_TXCLEAR or PURGE_RXCLEAR);
end;

procedure TfrmMain.ButtonOpenClick(Sender: TObject);
begin
   if not flgComOpen then begin
    if SetComName then begin
      iComBaud := 1500000;
      if OpenCom(sComNane) then begin
//        if GetDevVersion then begin
          ButtonOpen.Caption := 'Close';
          ComboBox.Enabled := False;
          ButtonReScanComDevices.Enabled := False;
          MenuEnable;
          StatusBar.Panels[1].Text:=sComNane+' открыт.';
          SigBreak := False;
          flgReadGpioOn := False;
          PurgeCom(PURGE_TXCLEAR or PURGE_RXCLEAR);
          if StmCmdVersion then begin
            StmRdRegs;
            if(stm.ver > 5) then begin
              if not StmCmdByte(8, 3) then begin
                StatusBar.Panels[1].Text:='Ошибка установоки конфигурации!';
                ShowMessage(StatusBar.Panels[1].Text);
              end;
            end;
          end;
          flgReadGpioOn := True;
      end
       else begin
       StatusBar.Panels[1].Text:='Ошибка откытия '+sComNane;
       ShowMessage(StatusBar.Panels[1].Text);
       end;
    end
    else begin
      StatusBar.Panels[1].Text:='Выберите COM порт!';
    end;
  end
  else begin
     SigBreak := True;
     sleep(10);
     CloseCom;
     ButtonOpen.Caption := 'Open';
     MenuDisable;
     ComboBox.Enabled := True;
     ButtonReScanComDevices.Enabled := True;
     LabelStm.Caption := 'Device not open';
     StatusBar.Panels[1].Text:=sComNane+' закрыт.';
  end;
end;

procedure GetBuildInfo(var V1, V2, V3, V4: word);
var
  VerInfoSize, VerValueSize, Dummy: DWORD;
  VerInfo: Pointer;
  VerValue: PVSFixedFileInfo;
begin
  VerInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), Dummy);
  if VerInfoSize > 0 then
  begin
      GetMem(VerInfo, VerInfoSize);
      try
        if GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo) then
        begin
          VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
          with VerValue^ do
          begin
            V1 := dwFileVersionMS shr 16;
            V2 := dwFileVersionMS and $FFFF;
            V3 := dwFileVersionLS shr 16;
            V4 := dwFileVersionLS and $FFFF;
          end;
        end;
      finally
        FreeMem(VerInfo, VerInfoSize);
      end;
  end;
end;

function GetBuildInfoAsString: string;
var
  V1, V2, V3, V4: word;
begin
  GetBuildInfo(V1, V2, V3, V4);
  Result := IntToStr(V1) + '.' + IntToStr(V2) + '.' +
    IntToStr(V3) + '.' + IntToStr(V4);
end;

function TfrmMain.SwireRead(Addr: Dword; DataLen: Dword) : boolean;
var
buftx : array [0..63] of byte;
bufrx : array [0..127] of byte;
i : Dword;
begin
     result := False;
     if DataLen > 64-5 then
       exit;
     buftx[0]:=$5a;
     buftx[1] := Addr shr 8;
     buftx[2] := Addr;
     buftx[3]:=$80;
     FillChar(buftx[4], DataLen + 1, $ff);
     if not WriteCom(@buftx, DataLen+5) then begin
//         StatusBar.Panels[1].Text:='Ошибка записи в '+ sComNane+'!';
         exit;
     end;
     Application.ProcessMessages;
     if not ReadCom(@bufrx, (DataLen+5)*2) then begin
//         StatusBar.Panels[1].Text:='Ошибка чтения в '+ sComNane+'!';
       exit;
     end;
     if (bufrx[0] <> 2)
     or (bufrx[1] <> buftx[0])
     or (bufrx[2] <> 0)
     or (bufrx[3] <> buftx[1])
     or (bufrx[4] <> 0)
     or (bufrx[5] <> buftx[2])
     or (bufrx[6] <> 0)
     or (bufrx[7] <> buftx[3])
     or (bufrx[(4+DataLen)*2] <> 2)
     or (bufrx[(4+DataLen)*2 + 1] <> $ff) then begin
//         StatusBar.Panels[1].Text:='Ошибки в считанном блоке! (нарушение синзронизации?)';
       exit;
     end;
     i := 0;
     while i < DataLen do begin
       if bufrx[(i + 4)*2] <> 0 then begin
//            StatusBar.Panels[1].Text:='Ошибки в считанных данных!';
         exit;
       end;
       swdata[Addr + i] := bufrx[(i + 4)*2 + 1];
       i := i + 1;
     end;
     result := True;
end;

function TfrmMain.SwireWrite(Addr: Dword; Data: Dword; DataLen: Dword) : boolean;
var
buftx : array [0..3] of byte;
begin
    if DataLen = 1 then
      buftx[0] := Data
    else
    if DataLen = 2 then begin
      buftx[0] := Data;
      buftx[1] := Data shr 8;
    end else if DataLen = 3 then begin
      buftx[0] := Data;
      buftx[1] := Data shr 8;
      buftx[2] := Data shr 16;
    end else begin
      buftx[0] := Data;
      buftx[1] := Data shr 8;
      buftx[2] := Data shr 16;
      buftx[3] := Data shr 24;
    end;
    result := SwireWrBuf(Addr, @buftx[0], DataLen);
end;

function TfrmMain.SwireWrBuf(Addr: Dword; Buf: Pointer; DataLen: Dword) : boolean;
var
buftx : array [0..63] of byte;
bufrx : array [0..127] of byte;
i : Dword;
begin
     result := False;
     if DataLen > 64-5 then exit;
     buftx[0]:=$5a;
     buftx[1] := Addr shr 8;
     buftx[2] := Addr;
     buftx[3] := 0;
     Move(Buf^, buftx[4], DataLen);
     buftx[DataLen + 4] := $ff;
     if not WriteCom(@buftx, DataLen+5) then begin
         StatusBar.Panels[1].Text:='Ошибка записи в '+ sComNane+'!';
         exit;
     end;
     Application.ProcessMessages;
     if not ReadCom(@bufrx, (DataLen+5)*2) then begin
        StatusBar.Panels[1].Text:='Ошибка чтения в '+ sComNane+'!';
       exit;
     end;
     if (bufrx[0] <> 2)
     or (bufrx[1] <> buftx[0])
     or (bufrx[2] <> 0)
     or (bufrx[3] <> buftx[1])
     or (bufrx[4] <> 0)
     or (bufrx[5] <> buftx[2])
     or (bufrx[6] <> 0)
     or (bufrx[7] <> buftx[3])
     or (bufrx[(4+DataLen)*2] <> 2)
     or (bufrx[(4+DataLen)*2 + 1] <> $ff) then begin
         StatusBar.Panels[1].Text:='Ошибки в считанном блоке! (нарушение синзронизации?)';
       exit;
     end;
     i := 0;
     while i < DataLen do begin
       if bufrx[(i + 4)*2] <> 0 then begin
            StatusBar.Panels[1].Text:='Ошибки в считанных данных!';
         exit;
       end;
       swdata[i] := bufrx[(i + 4)*2 + 1];
       i := i + 1;
     end;
     result := True;
end;


procedure TfrmMain.FormCreate(Sender: TObject);
begin
//  flgValueChg := True;
  BuildInfoString := GetBuildInfoAsString;
  Caption := Application.Title + ' ver ' + BuildInfoString;
  ReadIni;
  cntrun := 0;
  ReScanComDevices;
  ext_addr := $9900;
  Timer.Enabled := CheckBoxChkGpio.Checked;
end;

procedure TfrmMain.ComboBoxChange(Sender: TObject);
begin
   SetComName;
end;

procedure TfrmMain.ButtonReadClick(Sender: TObject);
var
  regaddr, regdata : DWORD;
begin
    MenuDisable;
    regaddr := Str2dword(EditRegAddr.Text) and $ffff;
    EditRegAddr.Text := '0x'+IntToHex(regaddr,4);
//    regdata := Str2dword(EditRegData.Text);
//    EditRegData.Text := '0x'+IntToHex(regdata,8);
    StatusBar.Panels[1].Text:='Чтение адреса 0x'+ IntToHex(regaddr, 4);
    if not SwireRead(regaddr, 4) then begin
         StatusBar.Panels[1].Text:='Ошибка чтения по адресу 0x'+ IntToHex(regaddr, 4)+' !';
         ShowMessage(StatusBar.Panels[1].Text);
         MenuEnable;
         exit;
    end;
    regdata := swdata[regaddr] or (swdata[regaddr+1] shl 8) or (swdata[regaddr+2] shl 16) or (swdata[regaddr+3] shl 24);
    EditRegData.Text := '0x'+IntToHex(regdata,8);
    StatusBar.Panels[1].Text:='Считано 0x'+ IntToHex(regdata, 8)+' по адресу 0x'+ IntToHex(regaddr, 4);
    MenuEnable;
end;

procedure TfrmMain.ButtonWriteClick(Sender: TObject);
var
  regaddr, regdata : DWORD;
//  buftx : array [0..7] of byte;
begin
    MenuDisable;
    regaddr := Str2dword(EditRegAddr.Text) and $ffff;
    EditRegAddr.Text := '0x'+IntToHex(regaddr,4);
    regdata := Str2dword(EditRegData.Text);
    EditRegData.Text := '0x'+IntToHex(regdata,8);
    StatusBar.Panels[1].Text:='Запись 0x'+ IntToHex(regdata, 8)+' по адресу 0x'+ IntToHex(regaddr, 4) + '...';
    if not SwireWrite(regaddr, regdata, 4) then begin
         StatusBar.Panels[1].Text:='Ошибка записи 0x'+ IntToHex(regdata, 8)+' по адресу 0x'+ IntToHex(regaddr, 4)+' !';
         ShowMessage(StatusBar.Panels[1].Text);
         MenuEnable;
         exit;
    end;
    StatusBar.Panels[1].Text:='Записано 0x'+ IntToHex(regdata, 8)+' по адресу 0x'+ IntToHex(regaddr, 4) + '.';
    MenuEnable;
end;

procedure TfrmMain.ButtonLoadClick(Sender: TObject);
var
  F : File;
  fsize: Cardinal;
  ldaddr, segsize : DWORD;
  sldaddr, wrfsize  : DWORD;
//  xx : cardinal;
begin
  MenuDisable;
  ldaddr := Str2dword(EditLdAddr.Text) and $ffff;
  sldaddr := ldaddr;
  EditLdAddr.Text := '0x'+IntToHex(ldaddr,4);
  with OpenDialog do begin
      FilterIndex := 0;
      FileName := '*.bin';
      InitialDir := ExtractFilePath(FileName);
//      FileName := ChangeFileExt(ExtractFileName(FileName),'');
      if InitialDir = '' then InitialDir := '.\';
      if not DirectoryExists(InitialDir) then InitialDir := '.\';
      DefaultExt := 'bin';
      Filter := 'bin files (*.bin)|*.bin|All files (*.*)|*.*';
      Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
        +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
        -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
        -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
      Title:='File write to SRAM';
  end;//with
  if OpenDialog.Execute then begin      { Display Open dialog box }
//    Memo1.Lines.Add('Read File ' + OpenDialog.FileName);
//    FillChar(swdata,SizeOf(swdata),$ff);
    ConnectStartTime := GetTickCount();
{$I+}
    AssignFile(F, OpenDialog.FileName); // File selected in dialog
    Reset(F,1);
//    fsize := FileSize(F);
    StatusBar.Panels[1].Text:='Размер файла '+IntToStr(fsize)+' байт.';
//    if fsize > SizeOf(swdata) - ldaddr then
//       fsize := SizeOf(swdata) - ldaddr;
//    if (PageControlWrFlash.TabIndex = 0) then begin
//      Seek(f,rdfaddr);
//    end;
    BlockRead(F, swdata[ldaddr], SizeOf(swdata) - ldaddr, fsize);
    CloseFile(F);
{$I-}
    if fsize = 0 then begin
     Beep;
     ShowMessage('File size = 0!');
     MenuEnable;
     Exit;
    end;
    Application.ProcessMessages;

    wrfsize := 0;
    segsize := 48;
    while wrfsize < fsize do begin
      if segsize > fsize - wrfsize then
              segsize := fsize - wrfsize;
      StatusBar.Panels[1].Text:='Запись '+ IntToStr(segsize)+' байт по адресу 0x'+ IntToHex(ldaddr, 4) + '...';
      if not SwireWrBuf(ldaddr, @swdata[ldaddr], segsize) then begin
         StatusBar.Panels[1].Text:='Ошибка записи по адресу 0x'+ IntToHex(ldaddr, 4)+' !';
         ShowMessage(StatusBar.Panels[1].Text);
         MenuEnable;
         exit;
      end;
      ldaddr := ldaddr + segsize;
      wrfsize := wrfsize + segsize;
      Application.ProcessMessages;
    end;
    ConnectTime := GetTickCount - ConnectStartTime;
    StatusBar.Panels[1].Text:='Записано '+ IntToStr(wrfsize)+' байт по адресу 0x'+ IntToHex(sldaddr, 4) + '. (' + IntToStr(ConnectTime) + ' мс)';
  end;
  MenuEnable;
end;

procedure TfrmMain.ButtonReadAllClick(Sender: TObject);
var
Addr : Dword;
bfile : THandle;
begin
  MenuDisable;
  SigBreak := False;
     ConnectStartTime := GetTickCount();
     StatusBar.Panels[1].Text:='Чтение SRAM...';
     Addr := 0;
     while Addr < RAM_SIZE do begin
       StatusBar.Panels[1].Text:='Чтение блока по адресу 0x'+ IntToHex(Addr, 4)+'..';
       if not SwireRead(Addr, 32) then begin
         StatusBar.Panels[1].Text:='Ошибки чтения блока по адресу 0x'+ IntToHex(Addr, 4)+' !';
         ShowMessage('Ошибки чтения блока по адресу 0x'+ IntToHex(Addr, 4)+' !');
         MenuEnable;
         exit;
       end;
       if SigBreak then begin
         StatusBar.Panels[1].Text:='Чтения блока по адресу 0x'+ IntToHex(Addr, 4)+' прервано!';
         SigBreak := False;
         MenuEnable;
         exit;
       end;
       Addr := Addr + 32;
       Application.ProcessMessages;
     end;
     ConnectTime := GetTickCount() - ConnectStartTime;
     StatusBar.Panels[1].Text:='Чтение 64 кбайта - ок. (' + IntToStr(ConnectTime) + ' мс)';
     with SaveDialog do begin
      FilterIndex:=0;
      FileName := 'swdata.bin';
      InitialDir := '.';
      DefaultExt := 'bin';
      Filter := 'bin files (*.bin)|*.bin';
      Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
        +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
        -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
        -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
      Title:='Сохранить блок в файл';
     end;//with
     if SaveDialog.Execute then begin
      Repaint;
      bfile:=FileCreate(SaveDialog.FileName);
      if bfile<>INVALID_HANDLE_VALUE then FileWrite(bfile,swdata[0],sizeof(swdata));
      FileClose(bfile);
     end;
  MenuEnable;
end;

function TfrmMain.SwireCpuStop : boolean;
begin
    result := SwireWrite( $0602, $05, 1); // reset mcu
end;

function TfrmMain.SwireFlashWriteEnable : boolean;
begin
//    SwireWr( $0d, $01, 1); // set csn high
    SwireWrite( $0d, $00, 1); // set csn low
    SwireWrite( $0c, FLASH_WRITE_ENABLE_CMD, 1); // send write enable command
    result := SwireWrite( $0d, $01, 1); // set csn high
end;

function TfrmMain.SwireFlashSetCsHigh : boolean;
begin
    result := SwireWrite( $0d, $01, 1); // set csn high
end;

function TfrmMain.SwireGetStatusFlash : Dword;
begin
    SwireWrite( $0d, $00, 1); // set csn low
    SwireWrite( $0c, FLASH_READ_STATUS_CMD, 1); // send get status command
    SwireWrite( $0c, $ff, 1); // start SPI
    if not SwireRead( $0c, 1) then
      result := $ffffffff
    else
      result := swdata[$0c];
    SwireWrite( $0d, $01, 1); // set csn high
end;

function TfrmMain.SwireFlashSectorErase(faddr: Dword) : boolean;
begin
  result := SwireFlashWriteEnable;
  if result then begin
    SwireWrite( $0d, $00, 1); // set csn low
    SwireWrite( $0c, FLASH_SECT_ERASE_CMD, 1); // send sector erase command
    SwireWrite( $0c, faddr shr 16, 1); // send 16..23 bits addr
    SwireWrite( $0c, faddr shr 8, 1); // send 8..15 bits addr
    SwireWrite( $0c, faddr, 1);  // send 0..7 bits addr
    result := SwireWrite( $0d, $01, 1); // set csn high
  end;
end;

function TfrmMain.SwireFlashRead(faddr: Dword; DataLen: Dword) : boolean;
var
i : Dword;
begin
  result := SwireFlashWriteEnable;
  if result then begin
    SwireWrite( $0d, $00, 1); // set csn low
    SwireWrite( $0c, FLASH_READ_CMD, 1); // send read command
    SwireWrite( $0c, faddr shr 16, 1); // send 16..23 bits addr
    SwireWrite( $0c, faddr shr 8, 1); // send 8..15 bits addr
    SwireWrite( $0c, faddr, 1);  // send 0..7 bits addr

    i := 0;
    while i < DataLen do begin
        SwireWrite( $0c, $ff, 1); // start SPI
        if not SwireRead( $0c, 1) then begin
          result := False;
          break;
        end;
        fldata[faddr+i] := swdata[$0c];
        Inc(i);
    end;
    // set csn high
    SwireWrite( $0d, $01, 1);
  end;
end;

function TfrmMain.SwireFlashWrite(faddr: Dword; DataLen: Dword) : boolean;
var
i : Dword;
begin
    result := SwireFlashWriteEnable;
    if not result then exit;

    SwireWrite( $0d, $00, 1); // set csn low
    SwireWrite( $0c, FLASH_WRITE_CMD, 1); // send write command
    SwireWrite( $0c, faddr shr 16, 1); // send 16..23 bits addr
    SwireWrite( $0c, faddr shr 8, 1); // send 8..15 bits addr
    SwireWrite( $0c, faddr, 1); // send 0..7 bits addr

    i := 0;
    while i < DataLen do begin
        SwireWrite( $0c, fldata[faddr + i], 1); //
        Inc(i);
    end;
    // set csn high
    result := SwireWrite( $0d, $01, 1);
end;

function TfrmMain.SwireFlashChipErase : boolean;
begin
    SwireWrite( $0d, $00, 1); // set csn low
    SwireWrite( $0c, FLASH_CHIP_ERASE_CMD, 1); // send Chip Erase command
    // set csn high
    result := SwireWrite( $0d, $01, 1);
end;

function TfrmMain.SwireFlashWriteStatus(fsta: Byte) : boolean;
begin
    SwireWrite( $0d, $00, 1); // set csn low
    SwireWrite( $0c, FLASH_WRITE_STATUS_CMD, 1); // send Write Status command
    SwireWrite( $0c, fsta, 1);
    // set csn high
    result := SwireWrite( $0d, $01, 1);
end;

procedure TfrmMain.ButtonFWriteClick(Sender: TObject);
var
  F : File;
  fsize: Cardinal;
  sfaddr, faddr, wrfsize, segsize, x : DWORD;
//  buftx : array [0..7] of byte;
//  bufrx : array [0..15] of byte;
  i : DWORD;
  flg, era : boolean;
begin
  MenuDisable;
  old_sec_erase := $ffffffff;
  faddr := Str2dword(EditFwAddr.Text) and (FLASH_SIZE - 1);
  sfaddr := faddr;
  EditFwAddr.Text := '0x'+IntToHex(faddr, 6);
  with OpenDialog do begin
      FilterIndex := 0;
      FileName := '*.bin';
      InitialDir := ExtractFilePath(FileName);
//      FileName := ChangeFileExt(ExtractFileName(FileName),'');
      if InitialDir = '' then InitialDir := '.\';
      if not DirectoryExists(InitialDir) then InitialDir := '.\';
      DefaultExt := 'bin';
      Filter := 'bin files (*.bin)|*.bin|All files (*.*)|*.*';
      Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
        +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
        -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
        -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
      Title:='File write to Flash';
  end;//with
  if OpenDialog.Execute then begin      { Display Open dialog box }
//    Memo1.Lines.Add('Read File ' + OpenDialog.FileName);
//    FillChar(swdata,SizeOf(swdata),$ff);
{$I+}
    AssignFile(F, OpenDialog.FileName); // File selected in dialog
    Reset(F,1);
    BlockRead(F, fldata[faddr], FLASH_SIZE - faddr, fsize);
    StatusBar.Panels[1].Text:='Размер файла '+IntToStr(fsize)+' байт.';
    CloseFile(F);
{$I-}
    if fsize = 0 then begin
     Beep;
     ShowMessage('File size = 0!');
     MenuEnable;
     Exit;
    end;
    StatusBar.Panels[1].Text:='Инициализация записи Flash...';
    if (not SwireCpuStop)
    or (not SwireFlashSetCsHigh) then begin
         StatusBar.Panels[1].Text:='Ошибка инициализции записи Flash: Нет связи по swire!';
         ShowMessage(StatusBar.Panels[1].Text);
         MenuEnable;
         exit;
    end;
    Application.ProcessMessages;
    wrfsize := 0;
    segsize := 32;
    while wrfsize < fsize do begin
      if segsize > fsize - wrfsize then
              segsize := fsize - wrfsize;
      flg := False;
      for i := 0 to segsize do begin
         if  fldata[faddr + i] <> $ff then begin
           flg := True;
           Break;
         end;
      end;
      if flg then begin
        if SigBreak then begin
          StatusBar.Panels[1].Text:='Запись сектора Flash по адресу 0x'+ IntToHex(faddr, 5)+' прерывана!';
          SigBreak := False;
          MenuEnable;
          exit;
        end;
        if CheckBoxFSEEna.Checked then begin
          era := False;
          x := faddr and (not (FLASH_SEC_SIZE-1));
          if old_sec_erase <> x then begin
            old_sec_erase := x;
            era := True;
          end;
          x := (faddr + segsize - 1) and (not (FLASH_SEC_SIZE-1));
          if old_sec_erase <> x then begin
            old_sec_erase := x;
            era := True;
          end;
          if era then begin
            StatusBar.Panels[1].Text:='Стирание сектора Flash по адресу 0x'+ IntToHex(old_sec_erase, 5) + '...';
            if not SwireFlashSectorErase(old_sec_erase) then begin
               StatusBar.Panels[1].Text:='Ошибка стирания сектора Flash по адресу 0x'+ IntToHex(old_sec_erase, 5)+'!';
               ShowMessage(StatusBar.Panels[1].Text);
               MenuEnable;
               exit;
            end;
            i := 0;
            while(True) do begin
              x := SwireGetStatusFlash;
              if ((x and $100) = 0) then begin
                if ((x and $1c) = 0) then begin
                 if ((x and $01) = 0) then break;
                end
                else begin
                 StatusBar.Panels[1].Text:='Ошибка стирания сектора Flash по адресу 0x'+ IntToHex(old_sec_erase, 5)+'(FlashStatus 0x'+IntToHex(x, 2)+')!';
                 ShowMessage(StatusBar.Panels[1].Text);
                 MenuEnable;
                 exit;
                end;
              end;
              Inc(i);
              if (i > 33) // tests = ~ 7
              or ((x and $100) <> 0) then begin
               StatusBar.Panels[1].Text:='Ошибка стирания сектора Flash по адресу 0x'+ IntToHex(old_sec_erase, 5)+'!';
               ShowMessage(StatusBar.Panels[1].Text);
               MenuEnable;
               exit;
              end;
              Application.ProcessMessages;
            end;
          end;
        end;
        StatusBar.Panels[1].Text:='Запись блока Flash в '+ IntToStr(segsize)+' байт по адресу 0x'+ IntToHex(faddr, 5) + '...';
        if not SwireFlashWrite(faddr, segsize) then begin
           StatusBar.Panels[1].Text:='Ошибка записи Flash по адресу 0x'+ IntToHex(faddr, 5)+' !';
           ShowMessage(StatusBar.Panels[1].Text);
           MenuEnable;
           exit;
        end;
      end;
      faddr := faddr + segsize;
      wrfsize := wrfsize + segsize;
      Application.ProcessMessages;
    end;
    StatusBar.Panels[1].Text:='Записано '+ IntToStr(wrfsize)+' байт с адреса 0x'+ IntToHex(sfaddr, 5) + ' Flash.';
  end;
  MenuEnable;
end;


procedure TfrmMain.ButtonEraAllClick(Sender: TObject);
var
i, x : Dword;
begin
  MenuDisable;
    StatusBar.Panels[1].Text:='Инициализация стирания Flash...';
    if (not SwireCpuStop)
    or (not SwireFlashSetCsHigh)
    or (not SwireFlashWriteEnable) then begin
         StatusBar.Panels[1].Text:='Ошибка инициализции стирания Flash: Нет связи по swire!';
         ShowMessage(StatusBar.Panels[1].Text);
         MenuEnable;
         exit;
    end;
    Application.ProcessMessages;

    StatusBar.Panels[1].Text:='Erase All Flash...';

    if not SwireFlashWriteStatus($02) then begin
         StatusBar.Panels[1].Text:='Ошибка записи регистра status Flash!';
         ShowMessage(StatusBar.Panels[1].Text);
         MenuEnable;
         exit;
    end;
    if (not SwireFlashWriteEnable) then begin
         StatusBar.Panels[1].Text:='Ошибка инициализции стирания Flash: Нет связи по swire!';
         ShowMessage(StatusBar.Panels[1].Text);
         MenuEnable;
         exit;
    end;
    // set csn high
    if not SwireFlashChipErase then begin
         StatusBar.Panels[1].Text:='Ошибка стирания Flash!';
         ShowMessage(StatusBar.Panels[1].Text);
         MenuEnable;
         exit;
    end;
    i := 0;
    while(True) do begin
      sleep(100);
      x := SwireGetStatusFlash;
      if ((x and $100) = 0) then begin
        if ((x and $1c) = 0) then begin
          if ((x and $01) = 0) then break;
        end
        else begin
          StatusBar.Panels[1].Text:='Ошибка стирания Flash, FlashStatus: 0x'+ IntToHex(x, 2)+'!';
          ShowMessage(StatusBar.Panels[1].Text);
          MenuEnable;
          exit;
        end;
      end;
      Inc(i);
      if (i > 45)
       or ((x and $100) <> 0) then begin
        StatusBar.Panels[1].Text:='Ошибка стирания Flash, FlashStatus: 0x'+ IntToHex(x, 2)+'!';
        ShowMessage(StatusBar.Panels[1].Text);
        MenuEnable;
        exit;
        end;
      Application.ProcessMessages;
    end;

    StatusBar.Panels[1].Text:='Flash очищена.'; //  + IntToStr(i)
    MenuEnable;
end;

procedure TfrmMain.ButtonFReadClick(Sender: TObject);
var
  faddr, fcaddr : DWORD;
  frdlen, frdcur, frdblksize : DWORD;
  i : DWORD;
  bfile : THandle;
begin
    MenuDisable;
    SigBreak := False;
    faddr := Str2dword(EditFAddr.Text) and (FLASH_SIZE - 1);
    EditFAddr.Text := '0x'+IntToHex(faddr,6);

    frdlen := Str2dword(EditFRLen.Text) and $1ffffff;
    EditFRLen.Text := '0x'+IntToHex(frdlen,7);
    if frdlen = 0 then begin
      StatusBar.Panels[1].Text:='Задана нулевая длина чтения!';
      MenuEnable;
      exit;
    end;
    if faddr + frdlen > SizeOf(fldata) then begin
        StatusBar.Panels[1].Text:='Размер чтения выходи за объем буфера Flash!';
        frdlen := FLASH_SIZE - faddr; // SizeOf(fldata)
        EditFRLen.Text := '0x'+IntToHex(frdlen,7);
        MenuEnable;
        exit;
    end;
    StatusBar.Panels[1].Text:='Подготовка к чтению Flash...';
    Application.ProcessMessages;
    if (not SwireCpuStop)
    or (not SwireFlashSetCsHigh)
    then begin
         StatusBar.Panels[1].Text:='Ошибка подготовки к чтению Flash!';
         ShowMessage(StatusBar.Panels[1].Text);
         MenuEnable;
         exit;
    end;
    frdcur := 0;
    fcaddr := faddr;
    frdblksize := 32;
    while  frdcur < frdlen do begin
      if frdlen - frdcur < frdblksize then
         frdblksize := frdlen - frdcur;
      StatusBar.Panels[1].Text:='Чтение '+ IntToStr(frdblksize)+' байт из Flash по адресу 0x'+ IntToHex(fcaddr, 6)+'...';
      Application.ProcessMessages;
       if SigBreak then begin
         StatusBar.Panels[1].Text:='Чтение '+ IntToStr(frdblksize)+' байт из Flash по адресу 0x'+ IntToHex(fcaddr, 6)+' прервано!';
         SigBreak := False;
         MenuEnable;
         exit;
       end;
      if not SwireFlashRead(fcaddr, frdblksize) then begin
         StatusBar.Panels[1].Text:='Ошибка чтения Flash по адресу 0x'+ IntToHex(fcaddr, 6)+' !';
         ShowMessage(StatusBar.Panels[1].Text);
         MenuEnable;
         exit;
      end;
      fcaddr := fcaddr + frdblksize;
      frdcur := frdcur + frdblksize;
   end;
   if frdlen < 16 then
        i := frdlen
   else
        i := 16;
   StatusBar.Panels[1].Text:='Считано '+ IntToStr(frdlen)+' байт из Flash по адресу 0x'+ IntToHex(faddr, 6)+': '+BufToHex_Str(@fldata[faddr], i, ',' )+',..';
     with SaveDialog do begin
      FilterIndex := 0;
      FileName := IntToHex(faddr, 6)+'_'+IntToHex(frdlen,7)+'.bin';
      InitialDir := '.';
      DefaultExt := 'bin';
      Filter := 'bin files (*.bin)|*.bin';
      Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
        +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
        -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
        -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
      Title:='Сохранить блок в файл';
     end;//with
     if SaveDialog.Execute then begin
      Repaint;
      bfile := FileCreate(SaveDialog.FileName);
      if bfile<>INVALID_HANDLE_VALUE then FileWrite(bfile,fldata[faddr], frdlen );
      FileClose(bfile);
     end;
  MenuEnable;
end;

procedure TfrmMain.ButtonRebootClick(Sender: TObject);
begin
  MenuDisable;
{
#define reg_pwdn_ctrl			REG_ADDR8(0x6f)
	FLD_PWDN_CTRL_REBOOT = 		BIT(5)
	FLD_PWDN_CTRL_SLEEP =		BIT(7)
}
     if SwireWrite( $06f, $20, 1) then // soft reset mcu
       StatusBar.Panels[1].Text:='CPU Reset.'
     else
       StatusBar.Panels[1].Text:='Ошибки на swire!';
  MenuEnable;
end;

procedure TfrmMain.ButtonCPURunClick(Sender: TObject);
begin
  MenuDisable;
     if SwireWrite( $0602, $88, 1) then // cpu go
       StatusBar.Panels[1].Text:='CPU Run.'
     else
       StatusBar.Panels[1].Text:='Ошибки на swire!';
  MenuEnable;
end;

// use speed_stm
function TfrmMain.StmCmdActivate : boolean;
var
buftx : array [0..3] of byte;
bufrx : array [0..31] of byte;
temp_speed_stm, temp_speed_swm : dword;
cnt, asteps : dword;
regaddr : dword;
begin
    result := False;

    cnt := Str2dword(EditACount.Text) and $ffff;
    EditACount.Text := IntToStr(cnt);

    GetVarSpeedSwmSws;

    if cnt > 0 then begin
      if not StmCmd(0) then begin
        StatusBar.Panels[1].Text:='Ошибка команды сброса CPU!';
        ShowMessage(StatusBar.Panels[1].Text);
        exit;
      end;

      sleep(10);
      StmCmdVersion;
      Application.ProcessMessages;

      if stm.ver > 5 then begin
        if ( // (not StmCmdByte(8, 3)) or
        (not StmCmdSetSCS($0602, $05)) or (not StmCmdSetSRC($00B2))) then begin
          StatusBar.Panels[1].Text:='Ошибка установоки конфигурации!';
          ShowMessage(StatusBar.Panels[1].Text);
          exit;
        end;
      end;

      temp_speed_stm := 3;
      if not StmCmdByte(5, temp_speed_stm) then begin
        temp_speed_swm := ((36000000 div (1 shl temp_speed_stm)) div 7);
        StatusBar.Panels[1].Text:='Ошибка установки скорости STM SWM '+ IntToStr(temp_speed_swm) +' bps!';
        ShowMessage(StatusBar.Panels[1].Text);
        exit;
      end;

      // 3.3 сек 65535 cnt (3300 ms) при speed_stm = 2 (!)
      // 6.6 сек 65535 cnt (6600 ms) при speed_stm = 3 (?)
      // (65536*(1<<2))/3300 = 79
      if cnt > 3300 then  cnt := 3300;
      asteps := (cnt * 79) shr temp_speed_stm;
      // Activate
      buftx[0] := $55;
      buftx[1] := $02;
      buftx[2] := asteps shr 8;
      buftx[3] := asteps;
      if not WriteCom(@buftx, 4) then begin
        StatusBar.Panels[1].Text:='Ошибка записи в '+ sComNane+'!';
        ShowMessage(StatusBar.Panels[1].Text);
        exit;
      end;

      if cnt > 0 then sleep(cnt);
      //  0  1  2  3  4  5  6  7  8  9  10 11
      // 02 5A 00 00 00 B2 00 80 00 05 02 FF
      if not ReadCom(@bufrx, 12) then begin
        StatusBar.Panels[1].Text:='Таймаут устройства на '+ sComNane+'!';
        ShowMessage(StatusBar.Panels[1].Text);
        exit;
      end;
    end
    else begin
     if SwireWrite( $06f, $20, 1) then // soft reset mcu
       StatusBar.Panels[1].Text:='CPU Reset.'
     else begin
       StatusBar.Panels[1].Text:='Ошибки на swire!';
     end;
    end;

    StatusBar.Panels[1].Text:='Установка скорости SWM '+ IntToStr(speed_swm_bps) +' bps...';

    if not StmCmdByte(5, speed_stm) then begin
      StatusBar.Panels[1].Text:='Ошибка установки скорости STM SWM '+ IntToStr(speed_swm_bps) +' bps!';
      ShowMessage(StatusBar.Panels[1].Text);
      exit;
    end;

    regaddr := $00b2;

    StatusBar.Panels[1].Text:='Запись 0x'+ IntToHex(speed_sws, 2)+' по адресу 0x'+ IntToHex(regaddr, 4) + '...';
    if not SwireWrite(regaddr, speed_sws, 1) then begin
         StatusBar.Panels[1].Text:='Ошибка записи 0x'+ IntToHex(speed_sws, 2)+' по адресу 0x'+ IntToHex(regaddr, 4)+' !';
         ShowMessage(StatusBar.Panels[1].Text);
         exit;
    end;
//    StatusBar.Panels[1].Text:='Записано 0x'+ IntToHex(speed_sws, 2)+' по адресу 0x'+ IntToHex(regaddr, 4) + '.';

    StatusBar.Panels[1].Text:='Чтение адреса 0x'+ IntToHex(regaddr, 4);
    if not SwireRead(regaddr, 1) then begin
         StatusBar.Panels[1].Text:='Ошибка чтения по адресу 0x'+ IntToHex(regaddr, 4)+' !';
         result := AutoSpeedSwm;
         exit;
    end;
//    StatusBar.Panels[1].Text:='Считано 0x'+ IntToHex(regdata, 2)+' по адресу 0x'+ IntToHex(regaddr, 4);
    if swdata[regaddr] <> speed_sws then  begin
        StatusBar.Panels[1].Text:='Неудачная попытка!';
        // требуется понизить скорость SWM ?
        result := AutoSpeedSwm;
    end
    else begin
      regaddr := $007E;
      if not SwireRead(regaddr,2) then begin
        StatusBar.Panels[1].Text:='Ошибка чтения по адресу 0x'+ IntToHex(regaddr, 4)+' !';
        LabelDevID.Caption := 'SoC ID: ?';
      end
      else begin
        SoC_ID := swdata[regaddr] + (swdata[regaddr+1] shl 8);
        if SoC_ID = MCU_USB_ID_8266 then
          LabelDevID.Caption := 'SoC ID: 0x'+ IntToHex(SoC_ID, 2) + #13#10 + 'Chip: TLSR8266'
        else if SoC_ID = MCU_USB_ID_8267 then
          LabelDevID.Caption := 'SoC ID: 0x'+ IntToHex(SoC_ID, 2) + #13#10 + 'Chip: TLSR8267'
        else if SoC_ID = MCU_USB_ID_8269 then
          LabelDevID.Caption := 'SoC ID: 0x'+ IntToHex(SoC_ID, 2) + #13#10 + 'Chip: TLSR8269'
        else
          LabelDevID.Caption := 'SoC ID: '+ IntToHex(SoC_ID, 2);
      end;

      StatusBar.Panels[1].Text:='Activate ok!';
//        result := AutoSpeedSwm;
//        if result then begin
//        end;
      result := True;
    end;
end;

function TfrmMain.StmCmdPDword(cmd : Byte; pdata : pDword) : boolean;
var
data : Dword;
buftx : array [0..7] of byte;
bufrx : array [0..7] of byte;
begin
     result := False;
//     PurgeCom(PURGE_TXCLEAR or PURGE_RXCLEAR);
     data := pdata^;
     buftx[0] := $55;
     buftx[1] := cmd;
     buftx[2] := data shr 24;
     buftx[3] := data shr 16;
     buftx[4] := data shr 8;
     buftx[5] := data;
     if not WriteCom(@buftx, 6) then begin
         StatusBar.Panels[1].Text:='Ошибка записи в '+ sComNane+'!';
         ShowMessage(StatusBar.Panels[1].Text);
         exit;
     end;
     Application.ProcessMessages;
     if not ReadCom(@bufrx, 6) then begin
        StatusBar.Panels[1].Text:='Ошибка чтения в '+ sComNane+'!';
        ShowMessage(StatusBar.Panels[1].Text);
       exit;
     end;
     if (bufrx[0] <> buftx[0])
     and (bufrx[1] <> buftx[1]) then begin
        StatusBar.Panels[1].Text:='Не то устройство на '+ sComNane+'!';
        ShowMessage(StatusBar.Panels[1].Text);
        exit;
     end;
     data := (bufrx[2] shl 24) or (bufrx[3] shl 16) or (bufrx[4] shl 8) or bufrx[5];
     pdata^ := data;
     result := True;
end;

function TfrmMain.StmRdRegs : boolean;
begin
    result := False;
    ZeroMemory(@gpio, SizeOf(gpio));
    if StmCmdPDWord($10, @gpio.odr[0]) then
    if StmCmdPDWord($11, @gpio.odr[1]) then
    if StmCmdPDWord($12, @gpio.odr[2]) then
    if StmCmdPDWord($30, @gpio.crx[0]) then
    if StmCmdPDWord($31, @gpio.crx[1]) then
    if StmCmdPDWord($32, @gpio.crx[2]) then
    if StmCmdPDWord($33, @gpio.crx[3]) then
    if StmCmdPDWord($34, @gpio.crx[4]) then
    if StmCmdPDWord($35, @gpio.crx[5]) then begin
      gpio.rd_ok := True;
          result := True;
    end;
end;

function TfrmMain.StmCmdVersion : boolean;
var
buftx : array [0..7] of byte;
bufrx : array [0..15] of byte;
begin
     result := False;
     buftx[0] := $55;
     buftx[1] := $4;
     if not WriteCom(@buftx, 2) then begin
//         StatusBar.Panels[1].Text:='Ошибка записи в '+ sComNane+'!';
//         ShowMessage(StatusBar.Panels[1].Text);
         LabelStm.Caption := 'Device not found';
         PurgeCom(PURGE_TXCLEAR or PURGE_RXCLEAR);
         exit;
     end;
     Application.ProcessMessages;
     if not ReadCom(@bufrx, 10) then begin
//        StatusBar.Panels[1].Text:='Ошибка чтения в '+ sComNane+'!';
//        ShowMessage(StatusBar.Panels[1].Text);
         LabelStm.Caption := 'Device not found';
         ShapeRun.Brush.Color := clSilver;
         PurgeCom(PURGE_TXCLEAR or PURGE_RXCLEAR);
         exit;
     end;
     if (bufrx[0] <> buftx[0])
     and (bufrx[1] <> buftx[1]) then begin
//        StatusBar.Panels[1].Text:='Не то устройство на '+ sComNane+'!';
//        ShowMessage(StatusBar.Panels[1].Text);
         LabelStm.Caption := 'Device not found';
         ShapeRun.Brush.Color := clSilver;
         PurgeCom(PURGE_TXCLEAR or PURGE_RXCLEAR);
         exit;
     end;
     stm.ver :=  (bufrx[2] shl 8) or bufrx[3];
     stm.pa :=  (bufrx[4] shl 8) or bufrx[5];
     stm.pb :=  (bufrx[6] shl 8) or bufrx[7];
     stm.pc :=  (bufrx[8] shl 8) or bufrx[9];
     LabelStm.Caption := 'Device ver: ' + IntToHex(stm.ver, 4);
     if CheckBoxChkGpio.Checked then begin
        if (stm.pa and $0001) <> 0 then ShapePA0.Brush.Color := clRed
        else ShapePA0.Brush.Color := clBlack;
        if (stm.pa and $0002) <> 0 then ShapePA1.Brush.Color := clRed
        else ShapePA1.Brush.Color := clBlack;
        if (stm.pa and $0004) <> 0 then ShapePA2.Brush.Color := clRed
        else ShapePA2.Brush.Color := clBlack;
        if (stm.pa and $0008) <> 0 then ShapePA3.Brush.Color := clRed
        else ShapePA3.Brush.Color := clBlack;
        if (stm.pa and $0010) <> 0 then ShapePA4.Brush.Color := clRed
        else ShapePA4.Brush.Color := clBlack;
        if (stm.pa and $0020) <> 0 then ShapePA5.Brush.Color := clRed
        else ShapePA5.Brush.Color := clBlack;
        if (stm.pa and $0040) <> 0 then ShapePA6.Brush.Color := clRed
        else ShapePA6.Brush.Color := clBlack;
        if (stm.pa and $0080) <> 0 then ShapePA7.Brush.Color := clRed
        else ShapePA7.Brush.Color := clBlack;
        if (stm.pa and $0100) <> 0 then ShapePA8.Brush.Color := clRed
        else ShapePA8.Brush.Color := clBlack;
        if (stm.pa and $0200) <> 0 then ShapePA9.Brush.Color := clRed
        else ShapePA9.Brush.Color := clBlack;
        if (stm.pa and $0400) <> 0 then ShapePA10.Brush.Color := clRed
        else ShapePA10.Brush.Color := clBlack;

        if (stm.pa and $8000) <> 0 then ShapePA15.Brush.Color := clRed
        else ShapePA15.Brush.Color := clBlack;

        if (stm.pb and $0001) <> 0 then ShapePB0.Brush.Color := clRed
        else ShapePB0.Brush.Color := clBlack;
        if (stm.pb and $0002) <> 0 then ShapePB1.Brush.Color := clRed
        else ShapePB1.Brush.Color := clBlack;
        if (stm.pb and $0004) <> 0 then ShapePB2.Brush.Color := clRed
        else ShapePB2.Brush.Color := clBlack;
        if (stm.pb and $0008) <> 0 then ShapePB3.Brush.Color := clRed
        else ShapePB3.Brush.Color := clBlack;
        if (stm.pb and $0010) <> 0 then ShapePB4.Brush.Color := clRed
        else ShapePB4.Brush.Color := clBlack;
        if (stm.pb and $0020) <> 0 then ShapePB5.Brush.Color := clRed
        else ShapePB5.Brush.Color := clBlack;
        if (stm.pb and $0040) <> 0 then ShapePB6.Brush.Color := clRed
        else ShapePB6.Brush.Color := clBlack;
        if (stm.pb and $0080) <> 0 then ShapePB7.Brush.Color := clRed
        else ShapePB7.Brush.Color := clBlack;
        if (stm.pb and $0100) <> 0 then ShapePB8.Brush.Color := clRed
        else ShapePB8.Brush.Color := clBlack;
        if (stm.pb and $0200) <> 0 then ShapePB9.Brush.Color := clRed
        else ShapePB9.Brush.Color := clBlack;
        if (stm.pb and $0400) <> 0 then ShapePB10.Brush.Color := clRed
        else ShapePB10.Brush.Color := clBlack;
        if (stm.pb and $0800) <> 0 then ShapePB11.Brush.Color := clRed
        else ShapePB11.Brush.Color := clBlack;
        if (stm.pb and $1000) <> 0 then ShapePB12.Brush.Color := clRed
        else ShapePB12.Brush.Color := clBlack;
        if (stm.pb and $2000) <> 0 then ShapePB13.Brush.Color := clRed
        else ShapePB13.Brush.Color := clBlack;
        if (stm.pb and $4000) <> 0 then ShapePB14.Brush.Color := clRed
        else ShapePB14.Brush.Color := clBlack;
        if (stm.pb and $8000) <> 0 then ShapePB15.Brush.Color := clRed
        else ShapePB15.Brush.Color := clBlack;

        if (stm.pc and (1 shl 13)) <> 0 then ShapePC13.Brush.Color := clRed
        else ShapePC13.Brush.Color := clBlack;
        if (stm.pc and (1 shl 14)) <> 0 then ShapePC14.Brush.Color := clRed
        else ShapePC14.Brush.Color := clBlack;
        if (stm.pc and (1 shl 15)) <> 0 then ShapePC15.Brush.Color := clRed
        else ShapePC15.Brush.Color := clBlack;

        Inc(cntrun);
        if (cntrun and 1) = 0 then ShapeRun.Brush.Color := clSkyBlue
        else ShapeRun.Brush.Color := clMoneyGreen;
        LabelGPIO.Caption := 'PA:' + IntToHex(stm.pa, 4) + #13#10 + 'PB:' + IntToHex(stm.pb, 4) + #13#10 + 'PC:' + IntToHex(stm.pc, 4);
//        PanelSTM.Refresh;
     end;
     result := True;
end;

function TfrmMain.StmCmd(cmd : byte) : boolean;
var
buftx : array [0..3] of byte;
bufrx : array [0..3] of byte;
begin
     result := False;
     buftx[0] := $55;
     buftx[1] := cmd;
     if not WriteCom(@buftx, 2) then begin
         StatusBar.Panels[1].Text:='Ошибка записи в '+ sComNane+'!';
         ShowMessage(StatusBar.Panels[1].Text);
         exit;
     end;
     Application.ProcessMessages;
     if not ReadCom(@bufrx, 2) then begin
        StatusBar.Panels[1].Text:='Ошибка чтения в '+ sComNane+'!';
        ShowMessage(StatusBar.Panels[1].Text);
       exit;
     end;
     if (bufrx[0] <> buftx[0])
     and (bufrx[1] <> buftx[1]) then begin
        StatusBar.Panels[1].Text:='Не то устройство на '+ sComNane+'!';
        ShowMessage(StatusBar.Panels[1].Text);
        exit;
     end;
     result := True;
end;

function TfrmMain.StmCmdByte(cmd : byte; data: byte) : boolean;
var
buftx : array [0..3] of byte;
bufrx : array [0..3] of byte;
begin
     result := False;
     buftx[0] := $55;
     buftx[1] := cmd;
     buftx[2] := data;
     if not WriteCom(@buftx, 3) then begin
         StatusBar.Panels[1].Text:='Ошибка записи в '+ sComNane+'!';
         ShowMessage(StatusBar.Panels[1].Text);
         exit;
     end;
     Application.ProcessMessages;
     if not ReadCom(@bufrx, 3) then begin
        StatusBar.Panels[1].Text:='Ошибка чтения в '+ sComNane+'!';
        ShowMessage(StatusBar.Panels[1].Text);
       exit;
     end;
     if (bufrx[0] <> buftx[0])
     and (bufrx[1] <> buftx[1])
     and (bufrx[2] <> buftx[2]) then begin
        StatusBar.Panels[1].Text:='Не то устройство на '+ sComNane+'!';
        ShowMessage(StatusBar.Panels[1].Text);
        exit;
     end;
     result := True;
end;

function TfrmMain.StmCmdWord(cmd : byte; data: word) : boolean;
var
buftx : array [0..3] of byte;
bufrx : array [0..3] of byte;
begin
     result := False;
     buftx[0] := $55;
     buftx[1] := cmd;
     buftx[2] := data;
     if not WriteCom(@buftx, 3) then begin
         StatusBar.Panels[1].Text:='Ошибка записи в '+ sComNane+'!';
         ShowMessage(StatusBar.Panels[1].Text);
         exit;
     end;
     Application.ProcessMessages;
     if not ReadCom(@bufrx, 3) then begin
        StatusBar.Panels[1].Text:='Ошибка чтения в '+ sComNane+'!';
        ShowMessage(StatusBar.Panels[1].Text);
       exit;
     end;
     if (bufrx[0] <> buftx[0])
     and (bufrx[1] <> buftx[1])
     and (bufrx[2] <> buftx[2]) then begin
        StatusBar.Panels[1].Text:='Не то устройство на '+ sComNane+'!';
        ShowMessage(StatusBar.Panels[1].Text);
        exit;
     end;
     result := True;
end;

function TfrmMain.StmCmdSetSCS(addr : Dword; data: byte) : boolean;
var
buftx : array [0..9] of byte;
bufrx : array [0..9] of byte;
begin
     result := False;
     buftx[0] := $55;
     buftx[1] := 6;
     buftx[2] := $5a;
     buftx[3] := addr shr 8;
     buftx[4] := addr;
     buftx[5] := 0;
     buftx[6] := data;
     buftx[7] := $ff;
     buftx[8] := $ff;
     if not WriteCom(@buftx, 9) then begin
       StatusBar.Panels[1].Text:='Ошибка записи в '+ sComNane+'!';
       ShowMessage(StatusBar.Panels[1].Text);
       exit;
     end;
     Application.ProcessMessages;
     if not ReadCom(@bufrx, 9) then begin
       StatusBar.Panels[1].Text:='Ошибка чтения в '+ sComNane+'!';
       ShowMessage(StatusBar.Panels[1].Text);
       exit;
     end;
     if (bufrx[0] <> buftx[0])
     and (bufrx[1] <> buftx[1])
     and (bufrx[2] <> buftx[2]) then begin
        StatusBar.Panels[1].Text:='Не то устройство на '+ sComNane+'!';
        ShowMessage(StatusBar.Panels[1].Text);
        exit;
     end;
     result := True;
end;

function TfrmMain.StmCmdSetSRC(addr : Dword) : boolean;
var
buftx : array [0..9] of byte;
bufrx : array [0..9] of byte;
begin
     result := False;
     buftx[0] := $55;
     buftx[1] := 7;
     buftx[2] := $5a;
     buftx[3] := addr shr 8;
     buftx[4] := addr;
     buftx[5] := $80;
     buftx[6] := $ff;
     buftx[7] := $ff;
     buftx[8] := $ff;
     if not WriteCom(@buftx, 9) then begin
         StatusBar.Panels[1].Text:='Ошибка записи в '+ sComNane+'!';
         ShowMessage(StatusBar.Panels[1].Text);
         exit;
     end;
     Application.ProcessMessages;
     if not ReadCom(@bufrx, 9) then begin
        StatusBar.Panels[1].Text:='Ошибка чтения в '+ sComNane+'!';
        ShowMessage(StatusBar.Panels[1].Text);
       exit;
     end;
     if (bufrx[0] <> buftx[0])
     and (bufrx[1] <> buftx[1])
     and (bufrx[2] <> buftx[2]) then begin
        StatusBar.Panels[1].Text:='Не то устройство на '+ sComNane+'!';
        ShowMessage(StatusBar.Panels[1].Text);
        exit;
     end;
     result := True;
end;


procedure TfrmMain.GetVarSpeedSwmSws;
begin
     speed_stm := Str2dword(EditSTMSpeed.Text) and $7;
     EditSTMSpeed.Text := IntToStr(speed_stm);

     speed_sws := Str2dword(EditSpeed.Text) and $7f;
     EditSpeed.Text := IntToStr(speed_sws);
     speed_swm_bps := ((36000000 div (1 shl speed_stm)) div 7);
     speed_swm_mbps := speed_swm_bps / 1000000.0;

     LabelSWM.Caption := 'SWM '+FormatFloat('#0.000', speed_swm_mbps)+' Mbps';

end;

procedure TfrmMain.ButtonActivateClick(Sender: TObject);
begin
     MenuDisable;
     SigBreak := False;
     StmCmdActivate;
     MenuEnable;
end;

procedure TfrmMain.ButtonResetClick(Sender: TObject);
var
tres_ms : Dword;
begin
    MenuDisable;
    tres_ms := Str2dword(EditTimeReset.Text);
    EditTimeReset.Text := IntToStr(tres_ms);
    StmCmdVersion;
    if StmCmd(0) then begin
      StmCmdVersion;
      Application.ProcessMessages;
      sleep(tres_ms);
      StmCmdVersion;
      Application.ProcessMessages;
      if StmCmd(1) then
        StatusBar.Panels[1].Text:='Reset ok. (GPIO_PB0 -> Reset!)';
    end;
    MenuEnable;
end;

procedure TfrmMain.ButtonSpeedClick(Sender: TObject);
var
  regaddr: DWORD;
begin
    MenuDisable;

    GetVarSpeedSwmSws;

    StatusBar.Panels[1].Text:='Установка скорости SWM '+ IntToStr(speed_swm_bps) +' bps...';

    if not StmCmdByte(5, speed_stm) then begin
      StatusBar.Panels[1].Text:='Ошибка установки скорости STM SWM '+ IntToStr(speed_swm_bps) +' bps!';
      ShowMessage(StatusBar.Panels[1].Text);
      MenuEnable;
      exit;
    end;

    regaddr := $00b2;
    StatusBar.Panels[1].Text:='Запись 0x'+ IntToHex(speed_sws, 2)+' по адресу 0x'+ IntToHex(regaddr, 4) + '...';
    if not SwireWrite(regaddr, speed_sws, 1) then begin
         StatusBar.Panels[1].Text:='Ошибка записи 0x'+ IntToHex(speed_sws, 2)+' по адресу 0x'+ IntToHex(regaddr, 4)+' !';
         ShowMessage(StatusBar.Panels[1].Text);
         MenuEnable;
         exit;
    end;
    StatusBar.Panels[1].Text:='Записано 0x'+ IntToHex(speed_sws, 2)+' по адресу 0x'+ IntToHex(regaddr, 4) + '.';
    MenuEnable;
end;

procedure TfrmMain.ButtonCpuStopClick(Sender: TObject);
begin
    MenuDisable;
     if SwireCpuStop then // cpu stop
       StatusBar.Panels[1].Text:='CPU Stop.'
     else
       StatusBar.Panels[1].Text:='Ошибки на swire!';
    MenuEnable;
end;

procedure TfrmMain.ButtonRSTGNDClick(Sender: TObject);
begin
    MenuDisable;
    if StmCmd(0) then begin
      StatusBar.Panels[1].Text:='RST to GND ok. (GPIO_PB0 -> Reset -> GND)';
      StmCmdVersion;
    end;
    MenuEnable;
end;

procedure TfrmMain.ButtonRSTOffClick(Sender: TObject);
begin
    MenuDisable;
    if StmCmd(1) then begin
      StatusBar.Panels[1].Text:='Relise RST ok.';
      StmCmdVersion;
    end;
    MenuEnable;
end;

procedure TfrmMain.ButtonTestClick(Sender: TObject);
var
  fcmd, faddr, fcaddr : DWORD;
  frdlen, frdcur, frdblksize : DWORD;
  i : DWORD;
  bfile : THandle;
begin
    MenuDisable;
    faddr := 0;
    fcmd := Str2dword(EditFCmd.Text) and $ff;
    EditFCmd.Text := '0x'+IntToHex(fcmd,2);
    frdlen := Str2dword(EditFRLen.Text) and $1ffffff;
    EditFRLen.Text := '0x'+IntToHex(frdlen,7);

    SwireCpuStop; // Stop mcu
    SwireWrite( $0d, $01, 1); // set csn high
    frdcur := 0;
    fcaddr := faddr;
    frdblksize := 32;
    while  frdcur < frdlen do begin
      if frdlen - frdcur < frdblksize then
         frdblksize := frdlen - frdcur;
      StatusBar.Panels[1].Text:='Чтение '+ IntToStr(frdblksize)+' байт из Flash (индекс: 0x'+ IntToHex(fcaddr, 5)+')..';
      Application.ProcessMessages;
      SwireWrite( $0d, $00, 1); // set csn low
      SwireWrite( $0c, fcmd , 1); // send read command
      i := 0;
      while i < frdblksize do begin
        if SigBreak then begin
          StatusBar.Panels[1].Text:='Чтение Flash 0x'+ IntToHex(fcaddr, 5)+' прерывано!';
          SigBreak := False;
          MenuEnable;
          exit;
        end;
        SwireWrite( $0c, $00, 1); // set csn high
        if not SwireRead( $0c, 1) then begin
         SwireWrite( $0d, $01, 1);
         StatusBar.Panels[1].Text:='Ошибка чтения байта из Flash 0x'+ IntToHex(fcaddr, 5)+' !';
         ShowMessage(StatusBar.Panels[1].Text);
         MenuEnable;
         exit;
        end;
        fldata[fcaddr] := swdata[$0c];
        Inc(fcaddr);
        Inc(frdcur);
        Inc(i);
      end;
      SwireWrite( $0d, $01, 1); // set csn high
   end;
   if frdlen < 16 then
        i := frdlen
   else
        i := 16;
   if i <> 0 then begin
   StatusBar.Panels[1].Text:='Считано '+ IntToStr(frdlen)+' байт из Flash: '+BufToHex_Str(@fldata[faddr], i, ',' )+',..';
     with SaveDialog do begin
      FilterIndex:=0;
      FileName := 'CMD_' +IntToHex(fcmd, 2) + '_' + IntToHex(faddr, 6)+'_'+IntToHex(frdlen,7)+'.bin';
      InitialDir := '.';
      DefaultExt := 'bin';
      Filter := 'bin files (*.bin)|*.bin';
      Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
        +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
        -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
        -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
      Title:='Сохранить блок в файл';
     end;//with
     if SaveDialog.Execute then begin
      Repaint;
      bfile:=FileCreate(SaveDialog.FileName);
      if bfile<>INVALID_HANDLE_VALUE then FileWrite(bfile,fldata[faddr], frdlen );
      FileClose(bfile);
     end;
   end;
   MenuEnable;
end;

function TfrmMain.AdapSwireSpeed(start : Dword; stop: Dword) : boolean;
var
  regaddr, regdata : DWORD;
  buftx : array [0..7] of byte;
begin
    buftx[0] := 0;
    buftx[1] := $80;
    buftx[3] := 0;
    regaddr := $b0;
    result := False;
    buftx[2] := start;
    while buftx[2] < stop do begin
      StatusBar.Panels[1].Text:='Запись 0x0080'+ IntToHex(buftx[2], 2)+'00 по адресу 0x'+ IntToHex(regaddr, 4) + '...';
      if not SwireWrBuf(regaddr, @buftx[0], 4) then begin
         StatusBar.Panels[1].Text:='Ошибка записи 0x'+ IntToHex(buftx[2], 2)+' по адресу 0x'+ IntToHex(regaddr, 4)+' !';
         ShowMessage(StatusBar.Panels[1].Text);
         exit;
      end;
      if SwireRead(regaddr, 4) then begin
         regdata := (swdata[regaddr] shl 24) + (swdata[regaddr+1] shl 16) + (swdata[regaddr+2] shl 8) + swdata[regaddr+3];
         if regdata = ($00800000 or (buftx[2] shl 8)) then begin
           StatusBar.Panels[1].Text:='Сорость swire синхронизована.';
           EditSpeed.Text := IntToStr(buftx[2]);
           result := True;
           exit;
         end;
      end;
      buftx[2] := buftx[2] + 1;
    end;
    buftx[2] := Str2dword(EditSpeed.Text) and $ff;
    SwireWrBuf(regaddr, @buftx[0], 4);
    StatusBar.Panels[1].Text:='Сорость swire не синхронизована!';
    ShowMessage(StatusBar.Panels[1].Text);
end;

function TfrmMain.AutoSpeedSwm : boolean;
var
 swm, sws : byte;
 swm_ok : byte;
 sws_ok, delta : byte;
 fclk, speed, speed_swmf : double;
 data, speed_swm  : dword;
begin
  swm_ok := 0;
  sws_ok := 0;
//  result := False;
  if(stm.ver > 1) then begin
  // STM swm speed:                SWS speed
  // 0: 36000000/7 = 5142857 bps
  // 1: 18000000/7 = 2571428 bps
  // 2:  9000000/7 = 1285714 bps   5
  // 3:  4500000/7 = 642857 bps    9
  // 4:  2250000/7 = 321428 bps    19
  // 5:  1125000/7 = 160714 bps    40
  // 6:   562500/7 = 80357 bps     79
  // 7:   281250/7 = 40178 bps     over
    swm := 6; // Str2dword(EditSTMSpeed.Text) and $7;
    EditSTMSpeed.Text := IntToStr(swm);
//    swm := 4; // SWM 160714 bps
    speed_swm := (36000000 div (1 shl swm)) div 7;
    StatusBar.Panels[1].Text:='Установка скорости SWM '+ IntToStr(speed_swm) +' bps...';
    if StmCmdByte(5, swm) then begin
      sws := 2;
      while(sws < 128) do begin
        data := $00008000 or (sws shl 16);
        StatusBar.Panels[1].Text:='Запись 0x'+ IntToHex(data, 4)+' по адресу 0x0b2...';
        if not SwireWrite($0b0, data, 4) then begin
           StatusBar.Panels[1].Text:='Ошибка записи 0x'+ IntToHex(data, 8)+' по адресу 0x0b0!';
           break;
        end;
        if SwireRead($0b0, 4)
           and (swdata[$b0] = 0)
           and (swdata[$b1] = $80)
           and (swdata[$b2] = sws)
           and (swdata[$b3] = 0) then begin
           swm_ok := swm;
           sws_ok := sws;
           break;
        end
        else begin
           sws := sws + 1;
        end;
      end;
      if sws_ok <> 0 then begin
        delta := sws_ok div 13;
        //if (sws_ok mod 13) > 7 then delta := delta + 1;
        if delta <> 0 then begin
          sws := sws + delta;
          data := $00008000 or (sws shl 16);
          StatusBar.Panels[1].Text:='Запись 0x'+ IntToHex(data, 4)+' по адресу 0x0b2...';
          if not SwireWrite($0b0, data, 4) then begin
             StatusBar.Panels[1].Text:='Ошибка записи 0x'+ IntToHex(data, 8)+' по адресу 0x0b0!';
          end;
          if SwireRead($0b0, 4)
             and (swdata[$b0] = 0)
             and (swdata[$b1] = $80)
             and (swdata[$b2] = sws)
             and (swdata[$b3] = 0) then begin
             swm_ok := swm;
             sws_ok := sws;
          end;
        end;
        EditSpeed.Text := IntToStr(sws);
        while (sws > 1) and (swm > 0) do begin
           swm := swm - 1;
           sws := (sws shr 1) + (sws and 1);
           data := $00008000 or (sws shl 16);
           if SwireWrite($0b0, data, 4) then begin
             if StmCmdByte(5, swm) then begin
               if SwireRead($0b0, 4)
                 and (swdata[$b0] = 0)
                 and (swdata[$b1] = $80)
                 and (swdata[$b2] = sws)
                 and (swdata[$b3] = 0) then begin
                 swm_ok := swm;
                 sws_ok := sws;
               end
               else
                 break;
             end
             else
               break;
           end
           else
             break;
        end;
        StmCmdByte(5, swm_ok);
        data := $00008000 or (sws_ok shl 16);
        SwireWrite($0b0, data, 4);
        EditSpeed.Text := IntToStr(sws_ok);
        EditSTMSpeed.Text := IntToStr(swm_ok);
        speed_swm := (36000000 div (1 shl swm_ok)) div 7;
        speed := (speed_swm * sws_ok) / 1000000.0;
        fclk := 1 shl swm_ok;
        fclk := (6.4*4.0) * sws_ok / fclk;
        if fclk >= 44.79 then begin
           fclk := 48.0;
           speed := fclk/5.0;
        end;
        speed_swmf := speed_swm / 1000000.0;
        StatusBar.Panels[1].Text:='Максимум SWS ~'+ FormatFloat('#0.00', speed) + ' Mbps (CLK '+FormatFloat('#0.00', fclk)+' МГц?) . Текущая на SWM ' + FormatFloat('#0.00', speed_swmf) + ' Mbps.';
        LabelSWM.Caption := 'SWM '+FormatFloat('#0.000', speed_swmf)+' Mbps';
        result := True;
      end
      else begin
        StatusBar.Panels[1].Text:='Ошибка подбора скоростей swire!';
        ShowMessage(StatusBar.Panels[1].Text);
        result := False;
      end;
    end
    else begin
        StatusBar.Panels[1].Text:='Ошибка установки скорости STM SWM '+ IntToStr(speed_swm) +' bps!';
        ShowMessage(StatusBar.Panels[1].Text);
        result := False;
    end;
  end
  else begin
      AdapSwireSpeed(2, 128);
      result := True;
  end;
end;


procedure TfrmMain.ButtonASpeedClick(Sender: TObject);
begin
  MenuDisable;
  AutoSpeedSwm;
  MenuEnable;
end;

procedure TfrmMain.ButtonSectorEraseClick(Sender: TObject);
var
faddr, i, x : Dword;
begin
  MenuDisable;
    faddr := Str2dword(EditFwAddr.Text) and (FLASH_SIZE - 1);
    EditFwAddr.Text := '0x'+IntToHex(faddr, 5);
    old_sec_erase := faddr and (not (FLASH_SEC_SIZE-1));
    StatusBar.Panels[1].Text:='Инициализация стирания сектора Flash...';
    if (not SwireCpuStop)
    or (not SwireFlashSetCsHigh) then begin
         StatusBar.Panels[1].Text:='Ошибка инициализции стирания сектора Flash: Нет связи по swire!';
         ShowMessage(StatusBar.Panels[1].Text);
         MenuEnable;
         exit;
    end;
    Application.ProcessMessages;
    if not SwireFlashSectorErase(old_sec_erase) then begin
      StatusBar.Panels[1].Text:='Ошибка стирания сектора Flash по адресу 0x'+ IntToHex(old_sec_erase, 6) + '!';
      ShowMessage(StatusBar.Panels[1].Text);
      MenuEnable;
      exit;
    end;
    i := 0;
    while(True) do begin
      x := SwireGetStatusFlash;
      if ((x and $100) = 0)
       and ((x and $01) = 0) then
        break;
      Inc(i);
      if (i > 33) // tests = ~ 7
       or ((x and $100) <> 0) then begin
        StatusBar.Panels[1].Text:='Ошибка стирания сектора Flash по адресу 0x'+ IntToHex(old_sec_erase, 6)+'!';
        ShowMessage(StatusBar.Panels[1].Text);
        MenuEnable;
        exit;
        end;
      Application.ProcessMessages;
    end;
    StatusBar.Panels[1].Text:='Сектор Flash по адресу 0x'+ IntToHex(old_sec_erase, 6) + ' стерт.'; //  + IntToStr(i)
  MenuEnable;
end;

function TfrmMain.StartFLoader : boolean;
var
  F : File;
  ldaddr, sldaddr, wrfsize, segsize : Dword;
  fsize: Cardinal;
begin
    ldaddr := $8000;
    sldaddr := ldaddr;
    result := False;

    if not StmCmdActivate then begin
//      result := False;
      exit;
    end;
    if (not SwireCpuStop)
    or (not SwireFlashSetCsHigh) then begin
      StatusBar.Panels[1].Text:='Ошибка инициализции flash-loader: Нет связи по swire!';
      ShowMessage(StatusBar.Panels[1].Text);
//      result := False;
      exit;
    end;
{$I+}
    AssignFile(F, FlashLoaderFname);
    Reset(F,1);
    StatusBar.Panels[1].Text:='Размер файла '+IntToStr(fsize)+' байт.';
    BlockRead(F, swdata[ldaddr], SizeOf(swdata) - ldaddr, fsize);
    CloseFile(F);
{$I-}
    if fsize = 0 then begin
     Beep;
     ShowMessage('File size = 0!');
     result := False;
     Exit;
    end;
    Application.ProcessMessages;

    wrfsize := 0;
    segsize := 48;
    while wrfsize < fsize do begin
      if segsize > fsize - wrfsize then
              segsize := fsize - wrfsize;
      StatusBar.Panels[1].Text:='Запись '+ IntToStr(segsize)+' байт по адресу 0x'+ IntToHex(ldaddr, 4) + '...';
      if not SwireWrBuf(ldaddr, @swdata[ldaddr], segsize) then begin
         StatusBar.Panels[1].Text:='Ошибка записи по адресу 0x'+ IntToHex(ldaddr, 4)+' !';
         ShowMessage(StatusBar.Panels[1].Text);
         result := False;
         exit;
      end;
      ldaddr := ldaddr + segsize;
      wrfsize := wrfsize + segsize;
      Application.ProcessMessages;
    end;
    StatusBar.Panels[1].Text:='Записано '+ IntToStr(wrfsize)+' байт по адресу 0x'+ IntToHex(sldaddr, 4) + '.';

    result := SwireWrite($0602, $88, 1);

    if not result then begin
       StatusBar.Panels[1].Text:='Нет связи по swire!';
       ShowMessage(StatusBar.Panels[1].Text);
       exit;
    end;
    sleep(50);

    ext_addr := swdata[FlashLoaderExtpAddr+0] or (swdata[FlashLoaderExtpAddr+1] shl 8);

    result := SwireRead(ext_addr, BOOT_EXT_LEN);
    if not result then begin
       StatusBar.Panels[1].Text:='Нет связи с FlashLoader!';
       ShowMessage(StatusBar.Panels[1].Text);
       exit;
    end;

    ext.faddr :=  swdata[ext_addr+0] or (swdata[ext_addr+1] shl 8) or (swdata[ext_addr+2] shl 16) or (swdata[ext_addr+3] shl 24);
    ext.pbuf :=  swdata[ext_addr+4] or (swdata[ext_addr+5] shl 8) or (swdata[ext_addr+6] shl 16) or (swdata[ext_addr+7] shl 24);
    ext.count :=  swdata[ext_addr+8] or (swdata[ext_addr+9] shl 8);
    ext.cmd :=  swdata[ext_addr+10] or (swdata[ext_addr+11] shl 8);
    ext.iack :=  swdata[ext_addr+12] or (swdata[ext_addr+13] shl 8);
    ext.oack :=  swdata[ext_addr+14] or (swdata[ext_addr+15] shl 8);



    LabelFLoaderVer.Caption :=
    'FLoader ver: '+ IntToHex(ext.iack, 4) + #13#10 +
    'Buffer: ' + IntToHex(ext.pbuf, 6) + ':' + IntToHex(ext.count, 4) + #13#10 +
    'Flash ID: '+ IntToHex((ext.faddr shr 16) and $ffff, 4)+ IntToHex(ext.faddr and $ff, 2);

    if ext.count < BOOT_BUF_LEN then begin
       StatusBar.Panels[1].Text:='Maл буфер у FlashLoader!';
       ShowMessage(StatusBar.Panels[1].Text);
       result := False;
    end;

end;

function TfrmMain.WaitCommandFLoader : boolean;
var
i, x : Dword;
begin
      result := False;
      i := 0;
      ext.oack := ext.oack + 1;
      while True do begin
          if (i > 250)    // test 14..15
          or (not SwireRead(ext_addr + 14, 2)) then begin
             x :=  swdata[ext_addr + 14] or (swdata[ext_addr + 15] shl 8);
             StatusBar.Panels[1].Text:='Потеря связи с FlashLoader на faddr: 0x' + IntToHex(ext.faddr, 6)
              + '! (' + IntToHex(swdata[ext_addr + 14] or (swdata[ext_addr + 15] shl 8), 4) + '#'
              + IntToHex(ext.iack, 4) + ')';
             ShowMessage(StatusBar.Panels[1].Text);
             exit;
          end;
          x :=  swdata[ext_addr + 14] or (swdata[ext_addr + 15] shl 8);
          if x = ext.oack then begin
             result := True;
             break;
          end;
          Inc(i);
          Application.ProcessMessages;
      end;
end;

function TfrmMain.CommandFLoader : boolean;
begin
      ext.iack := (ext.iack + 1) and $ff;
      swdata[ext_addr+0] := ext.faddr;
      swdata[ext_addr+1] := ext.faddr shr 8;
      swdata[ext_addr+2] := ext.faddr shr 16;
      swdata[ext_addr+3] := ext.faddr shr 24;
      swdata[ext_addr+4] := ext.pbuf;
      swdata[ext_addr+5] := ext.pbuf shr 8;
      swdata[ext_addr+6] := ext.pbuf shr 16;
      swdata[ext_addr+7] := ext.pbuf shr 24;
      swdata[ext_addr+8] := ext.count;
      swdata[ext_addr+9] := ext.count shr 8;
      swdata[ext_addr+10] := ext.cmd;
      swdata[ext_addr+11] := ext.cmd shr 8;
      swdata[ext_addr+12] := ext.iack;
      swdata[ext_addr+13] := ext.iack shr 8;
      result := SwireWrBuf(ext_addr, @swdata[ext_addr], BOOT_EXT_LEN - 2);
      if not result then begin
         StatusBar.Panels[1].Text:='Потеря связи с FlashLoader на faddr: 0x' + IntToHex(ext.faddr, 6) + '!';
         ShowMessage(StatusBar.Panels[1].Text);
         exit;
      end;

end;

procedure TfrmMain.ButtonFFReadClick(Sender: TObject);
var
  bfile : THandle;
  sfaddr, frdlen, faddr, fcaddr, bufaddr, buflen, cntread, blksz : DWORD;
begin
    MenuDisable;
    SigBreak := False;

    faddr := Str2dword(EditFAddr.Text) and (FLASH_SIZE - 1);
    EditFAddr.Text := '0x'+IntToHex(faddr,6);
    sfaddr := faddr;

    frdlen := Str2dword(EditFRLen.Text) and $1ffffff;
    EditFRLen.Text := '0x'+IntToHex(frdlen,7);
    if frdlen = 0 then begin
      StatusBar.Panels[1].Text:='Задана нулевая длина чтения!';
      MenuEnable;
      exit;
    end;

    if faddr + frdlen > SizeOf(fldata) then begin
        StatusBar.Panels[1].Text:='Размер чтения выходит за объем буфера Flash!';
        frdlen := FLASH_SIZE - faddr; // SizeOf(fldata)
        EditFRLen.Text := '0x'+IntToHex(frdlen,7);
        MenuEnable;
        exit;
    end;

    ConnectStartTime := GetTickCount();
    if not StartFLoader then begin
       MenuEnable;
       exit;
    end;
    buflen := BOOT_BUF_LEN;
    blksz := 32;
    cntread := 0;
    while cntread < frdlen do begin
      if frdlen - cntread < buflen then buflen := frdlen - cntread;
      StatusBar.Panels[1].Text:='Чтение сектора Flash по адресу 0x'+ IntToHex(faddr, 6)+'...';
      ext.faddr := faddr;
      ext.count := buflen;
      ext.cmd := FLASH_READ_CMD;
      if (not CommandFLoader)
       or (not WaitCommandFLoader) then begin
        MenuEnable;
        exit;
       end;
       bufaddr := 0;
       fcaddr := faddr;
       while bufaddr < buflen do begin
         if bufaddr - buflen < blksz then blksz := bufaddr - buflen;

//         StatusBar.Panels[1].Text:='Чтение блока по адресу 0x'+ IntToHex(fcaddr, 6)+'..';
         if not SwireRead((ext.pbuf and $ffff) + bufaddr, blksz) then begin
           StatusBar.Panels[1].Text:='Ошибки чтения блока по адресу 0x'+ IntToHex(fcaddr + bufaddr, 6)+' !';
           ShowMessage(StatusBar.Panels[1].Text);
           MenuEnable;
           exit;
         end;
         bufaddr := bufaddr + blksz;
         cntread := cntread + blksz;
         Application.ProcessMessages;
         if SigBreak then begin
           StatusBar.Panels[1].Text:='Чтение блока Flash по адресу 0x'+ IntToHex(fcaddr, 6)+' прервано!';
           SigBreak := False;
           MenuEnable;
           exit;
         end;
       end;
       CopyMemory(@fldata[fcaddr], @swdata[ext.pbuf and $ffff], buflen);
       faddr := faddr + buflen;
    end;

    ConnectTime := GetTickCount() - ConnectStartTime;
//     StatusBar.Panels[1].Text:='Чтение '+IntToStr(frdlen)+' байт - ок. (' + IntToStr(ConnectTime) + ' мс)';
    StatusBar.Panels[1].Text:='Считано '+ IntToStr(frdlen)+' байт из Flash по адресу 0x'+ IntToHex(sfaddr, 6)+': '+BufToHex_Str(@fldata[sfaddr], 4, ',' )+',.. (' + IntToStr(ConnectTime) + ' мс)';
    with SaveDialog do begin
      FilterIndex:=0;
      FileName := IntToHex(sfaddr, 6)+'_'+IntToHex(frdlen,7)+'.bin';
      InitialDir := '.';
      DefaultExt := 'bin';
      Filter := 'bin files (*.bin)|*.bin';
      Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
        +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
        -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
        -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
      Title:='Сохранить блок в файл';
    end;//with
    if SaveDialog.Execute then begin
      Repaint;
      bfile := FileCreate(SaveDialog.FileName);
      if bfile<>INVALID_HANDLE_VALUE then FileWrite(bfile, fldata[sfaddr], frdlen );
      FileClose(bfile);
    end;
    MenuEnable;
end;

procedure TfrmMain.ButtonBreakClick(Sender: TObject);
begin
      SigBreak := True;
end;

procedure TfrmMain.ButtonSFWriteClick(Sender: TObject);
var
  F : File;
  fsize : Cardinal;
  sfaddr, faddr, wrfsize, segsize, sldaddr, blksz : DWORD;
  flg, era : boolean;
begin
  MenuDisable;

  SigBreak := False;

  ConnectStartTime := GetTickCount();
  old_sec_erase := $ffffffff;
  faddr := Str2dword(EditFwAddr.Text) and (FLASH_SIZE - 1);
  if (faddr and (FLASH_SEC_SIZE-1)) <> 0 then begin
      StatusBar.Panels[1].Text:='Запись только для кратных сектору стартовых адресов!';
      ShowMessage(StatusBar.Panels[1].Text);
      MenuEnable;
      exit;
  end;
  sfaddr := faddr;
  EditFwAddr.Text := '0x'+IntToHex(faddr, 6);
  with OpenDialog do begin
      FilterIndex := 0;
      FileName := '*.bin';
      InitialDir := ExtractFilePath(FileName);
//      FileName := ChangeFileExt(ExtractFileName(FileName),'');
      if InitialDir = '' then InitialDir := '.\';
      if not DirectoryExists(InitialDir) then InitialDir := '.\';
      DefaultExt := 'bin';
      Filter := 'bin files (*.bin)|*.bin|All files (*.*)|*.*';
      Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
        +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
        -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
        -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
      Title:='File write to Flash';
  end;//with
  if OpenDialog.Execute then begin      { Display Open dialog box }
{$I+}
    AssignFile(F, OpenDialog.FileName); // File selected in dialog
    Reset(F,1);
    BlockRead(F, fldata[faddr], FLASH_SIZE - faddr, fsize);
    StatusBar.Panels[1].Text:='Размер файла '+IntToStr(fsize)+' байт.';
    CloseFile(F);
{$I-}
    if fsize = 0 then begin
     Beep;
     ShowMessage('File size = 0!');
     MenuEnable;
     Exit;
    end;

    StatusBar.Panels[1].Text:='Инициализация записи Flash...';
//------------------------------------------------------------------
    if not StartFLoader then begin
       MenuEnable;
       exit;
    end;
//-----------------------------------
    era := CheckBoxFSEEna.Checked;
    wrfsize := 0;
    segsize := FLASH_SEC_SIZE;
    blksz := 32;
    while wrfsize < fsize do begin
      if SigBreak then begin
        StatusBar.Panels[1].Text:='Запись сектора Flash по адресу 0x'+ IntToHex(faddr, 6)+' прерывана!';
        SigBreak := False;
        MenuEnable;
        exit;
      end;
      if (fsize - wrfsize) < segsize then
            segsize :=  fsize - wrfsize;
      if era then begin
        StatusBar.Panels[1].Text:='Стирание сектора Flash по адресу 0x'+ IntToHex(faddr, 6)+'...';
        ext.faddr := faddr;
        ext.count := FLASH_SEC_SIZE;
        ext.cmd := FLASH_SECT_ERASE_CMD;
        if not CommandFLoader then begin
          MenuEnable;
          exit; //     or (not WaitCommandFLoader) далее
        end;
      end;
      // Test sector all 0xFF
      flg := False;
      for sldaddr := 0 to segsize do begin
         if  fldata[faddr + sldaddr] <> $ff then begin
           flg := True;
           Break;
         end;
      end;
      if flg then begin
        StatusBar.Panels[1].Text:='Запись сектора Flash по адресу 0x'+ IntToHex(faddr, 6)+'...';
        sldaddr := 0;
        while sldaddr < segsize do begin
          if not SwireWrBuf((ext.pbuf and $ffff) + sldaddr, @fldata[faddr + sldaddr], blksz) then begin
             StatusBar.Panels[1].Text:='Ошибки записи блока по адресу 0x'+ IntToHex(faddr, 6)+' !';
             ShowMessage(StatusBar.Panels[1].Text);
            SigBreak := False;
            MenuEnable;
            exit;
          end;
          sldaddr := sldaddr + blksz;
//          wrfsize := wrfsize + blksz;
          if SigBreak then begin
            StatusBar.Panels[1].Text:='Запись сектора Flash по адресу 0x'+ IntToHex(faddr, 6)+' прерывана!';
            SigBreak := False;
            MenuEnable;
            exit;
          end;
          Application.ProcessMessages;
        end;
      end;
      if era then begin
        if not WaitCommandFLoader then break;
      end;
      if flg then begin
        ext.faddr := faddr;
        ext.count := segsize;
        ext.cmd := FLASH_WRITE_CMD;
        if (not CommandFLoader)
         or (not WaitCommandFLoader) then begin
          MenuEnable;
          exit;
         end;
      end;
      faddr := faddr + segsize;
      wrfsize := wrfsize + segsize;
    end;
//-------------------
    ConnectTime := GetTickCount() - ConnectStartTime;
    StatusBar.Panels[1].Text:='Записано '+ IntToStr(wrfsize)+' байт во Flash по адресу 0x'+ IntToHex(sfaddr, 6) + '. (' + IntToStr(ConnectTime) + ' мс) #' + IntToStr(ext.iack)
  end;
  MenuEnable;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   SigBreak := True;
   WriteIni;
end;

procedure TfrmMain.CheckBoxChkGpioClick(Sender: TObject);
begin
    Timer.Enabled := CheckBoxChkGpio.Checked;
    if not Timer.Enabled then  ShapeRun.Brush.Color := clSilver
    else ShapeRun.Brush.Color := clYellow;
end;


procedure TfrmMain.TimerTimer(Sender: TObject);
begin
   if flgComOpen
   and flgReadGpioOn then begin
      StmCmdVersion;
   end
   else
   if not flgComOpen then ShapeRun.Brush.Color := clSilver
   else ShapeRun.Brush.Color := clYellow;
end;

// areg : 0..16 -> pa0..15, 16..31 -> pb0..15, 32..47 -> pc0..15
procedure TfrmMain.SetGPIO(areg : dword);
var
dreg : dword;
cmd, idx : byte;
begin
    if flgComOpen then begin
      flgReadGpioOn := False;
      PurgeCom(PURGE_TXCLEAR or PURGE_RXCLEAR);
      FormStmGpio.Caption := 'STM32F103C6T8 GPIO P'+Char(65 + (areg shr 4)) + IntToStr(areg and $0f);
      FormStmGpio.cnf_mode := (gpio.crx[areg shr 3]  shr ((areg and $07)*4)) and $0f;
      FormStmGpio.odr_bit := (gpio.odr[areg shr 4]  shr (areg and $0F)) and $01;
      if FormStmGpio.ShowModal = mrOk then begin
        // set/clr ord
        cmd := (areg shr 4) or $10;
        idx := areg and $0f;
        if FormStmGpio.odr_bit <> 0 then
          dreg := 1 shl idx
        else
          dreg := 1 shl (idx + 16);
        if StmCmdPDWord(cmd, @dreg) then
          gpio.odr[areg shr 4] := dreg;
        // set mode/config crx
        cmd := (areg shr 3) or $20; // cmd crx &= data
        idx := (areg and $07) * 4;
        dreg := not ($0f shl idx);
        if StmCmdPDWord(cmd, @dreg) then
          gpio.crx[areg shr 3] := dreg;
        if FormStmGpio.cnf_mode <> 0 then begin
          cmd := (areg shr 3) or $30; // cmd crx |= data
          dreg := (FormStmGpio.cnf_mode and $0f) shl idx;
          if StmCmdPDWord(cmd, @dreg) then
            gpio.crx[areg shr 3] := dreg;
        end;
      end;
    end;
    Timer.Enabled := CheckBoxChkGpio.Checked;
    if not Timer.Enabled then ShapeRun.Brush.Color := clSilver
    else ShapeRun.Brush.Color := clYellow;
    flgReadGpioOn := True;
end;

procedure TfrmMain.ShapePB0MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
      if Button = mbRight then begin // mbLeft,  mbMiddle
        SetGPIO(16);
      end;
end;

procedure TfrmMain.ShapePB1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
      if Button = mbRight then begin // mbLeft,  mbMiddle
        SetGPIO(17);
      end;
end;

procedure TfrmMain.ShapePB2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//      ShowMessage('Boot1!');
      if Button = mbRight then begin // mbLeft,  mbMiddle
        SetGPIO(18);
      end;
end;

procedure TfrmMain.ShapePB3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
      if Button = mbRight then begin // mbLeft,  mbMiddle
        SetGPIO(19);
      end;
end;

procedure TfrmMain.ShapePB4MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
      if Button = mbRight then begin // mbLeft,  mbMiddle
        SetGPIO(20);
      end;
end;

procedure TfrmMain.ShapePB5MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
      if Button = mbRight then begin // mbLeft,  mbMiddle
        SetGPIO(21);
      end;
end;

procedure TfrmMain.ShapePB6MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
      if Button = mbRight then begin // mbLeft,  mbMiddle
        SetGPIO(22);
      end;
end;

procedure TfrmMain.ShapePB7MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
      if Button = mbRight then begin // mbLeft,  mbMiddle
        SetGPIO(23);
      end;
end;

procedure TfrmMain.ShapePB8MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
      if Button = mbRight then begin // mbLeft,  mbMiddle
        SetGPIO(24);
      end;
end;

procedure TfrmMain.ShapePB9MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
      if Button = mbRight then begin // mbLeft,  mbMiddle
        SetGPIO(25);
      end;
end;

procedure TfrmMain.ShapePB10MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
      if Button = mbRight then begin // mbLeft,  mbMiddle
        SetGPIO(26);
      end;
end;

procedure TfrmMain.ShapePB11MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
      if Button = mbRight then begin // mbLeft,  mbMiddle
        SetGPIO(27);
      end;
end;

procedure TfrmMain.ShapePB12MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
      if Button = mbRight then begin // mbLeft,  mbMiddle
        SetGPIO(28);
      end;
end;

procedure TfrmMain.ShapePB13MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
      if Button = mbRight then begin // mbLeft,  mbMiddle
        SetGPIO(29);
      end;
end;

procedure TfrmMain.ShapePB14MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
      if Button = mbRight then begin // mbLeft,  mbMiddle
        SetGPIO(30);
      end;
end;

procedure TfrmMain.ShapePB15MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
      if Button = mbRight then begin // mbLeft,  mbMiddle
        SetGPIO(31);
      end;
end;

procedure TfrmMain.ShapePC13MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
      if Button = mbRight then begin // mbLeft,  mbMiddle
        SetGPIO(45);
      end;
end;

procedure TfrmMain.ShapePC14MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
      if Button = mbRight then begin // mbLeft,  mbMiddle
        SetGPIO(46);
      end;
end;

procedure TfrmMain.ShapePC15MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
      if Button = mbRight then begin // mbLeft,  mbMiddle
        SetGPIO(47);
      end;
end;


procedure TfrmMain.ShapePA0MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
      if Button = mbRight then begin // mbLeft,  mbMiddle
        SetGPIO(0);
      end;
end;

procedure TfrmMain.ShapePA1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
      if Button = mbRight then begin // mbLeft,  mbMiddle
        SetGPIO(1);
      end;
end;

procedure TfrmMain.ShapePA5MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
      if Button = mbRight then begin // mbLeft,  mbMiddle
        SetGPIO(5);
      end;
end;

procedure TfrmMain.ShapePA7MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
      if Button = mbRight then begin // mbLeft,  mbMiddle
        SetGPIO(7);
      end;
end;

procedure TfrmMain.ShapePA6MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
      if Button = mbRight then begin // mbLeft,  mbMiddle
        SetGPIO(6);
      end;
end;

procedure TfrmMain.ShapePA2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
      if Button = mbRight then begin // mbLeft,  mbMiddle
        SetGPIO(2);
      end;
end;

procedure TfrmMain.ShapePA3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
      if Button = mbRight then begin // mbLeft,  mbMiddle
        SetGPIO(3);
      end;
end;

procedure TfrmMain.ShapePA8MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
      if Button = mbRight then begin // mbLeft,  mbMiddle
        SetGPIO(8);
      end;
end;

procedure TfrmMain.ShapePA9MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
      if Button = mbRight then begin // mbLeft,  mbMiddle
        SetGPIO(9);
      end;
end;

procedure TfrmMain.ShapePA10MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
      if Button = mbRight then begin // mbLeft,  mbMiddle
        SetGPIO(10);
      end;
end;

procedure TfrmMain.ShapePA4MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
       if Button = mbRight then begin // mbLeft,  mbMiddle
        SetGPIO(4);
      end;
end;

procedure TfrmMain.ShapePA15MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
      if Button = mbRight then begin // mbLeft,  mbMiddle
        SetGPIO(15);
      end;
end;

function TfrmMain.ARegEnable : boolean;
begin
    result := False;
    if SwireRead($0061,1) then begin
      if SwireWrite($0061, swdata[$61] and $fd, 1) then begin
        if SwireRead($0064,1) then begin
          if SwireWrite($0064, swdata[$64] or $02, 1) then begin
            result := True;
          end;
        end;
      end;
    end;
end;


procedure TfrmMain.ButtonAnaReadClick(Sender: TObject);
var
  i : integer;
  regaddr, regdata : DWORD;
begin
    MenuDisable;
     if not ARegEnable then begin
         StatusBar.Panels[1].Text:='Ошибка активации ALGM!';
         ShowMessage(StatusBar.Panels[1].Text);
         MenuEnable;
         exit;
     end;
    regaddr := Str2dword(EditRegAddr.Text) and $ff;
    EditRegAddr.Text := '0x'+IntToHex(regaddr,2);
//    regdata := Str2dword(EditRegData.Text);
//    EditRegData.Text := '0x'+IntToHex(regdata,8);
    StatusBar.Panels[1].Text:='Чтение регистра analog controls по адресу 0x'+ IntToHex(regaddr, 2);
    if not SwireWrite($b8, (regaddr and $ff) or $40ff00, 3) then begin
         StatusBar.Panels[1].Text:='Ошибка записи по адресу 0x00B8!';
         ShowMessage(StatusBar.Panels[1].Text);
         MenuEnable;
         exit;
    end;
    i := 3;
    while (i > 0) do begin
      if not SwireRead($b9, 2) then begin
        StatusBar.Panels[1].Text:='Ошибка чтения по адресу 0x00B9!';
        ShowMessage(StatusBar.Panels[1].Text);
        MenuEnable;
        exit;
      end;
      if (swdata[$ba] and 1) = 0 then begin
        regdata := swdata[$b9];
        SwireWrite($ba,0,1);
        EditRegData.Text := '0x'+IntToHex(regdata,2);
        StatusBar.Panels[1].Text:='Считано 0x'+ IntToHex(regdata, 2)+' из регистра analog controls по адресу 0x'+ IntToHex(regaddr, 2);
        MenuEnable;
        exit;
      end;
      Dec(i);
    end;
    StatusBar.Panels[1].Text:='Ошибка чтения регистра analog controls по адресу 0x'+ IntToHex(regaddr, 2);
    ShowMessage(StatusBar.Panels[1].Text);
    MenuEnable;
end;

procedure TfrmMain.ButtonAWriteClick(Sender: TObject);
var
  i : integer;
  regaddr, regdata : DWORD;
begin
    MenuDisable;
     if not ARegEnable then begin
         StatusBar.Panels[1].Text:='Ошибка активации ALGM!';
         ShowMessage(StatusBar.Panels[1].Text);
         MenuEnable;
         exit;
     end;
//    SwireCpuStop;
    regaddr := Str2dword(EditRegAddr.Text) and $ff;
    EditRegAddr.Text := '0x'+IntToHex(regaddr,2);
    regdata := Str2dword(EditRegData.Text) and $ff;
    EditRegData.Text := '0x'+IntToHex(regdata,2);
    StatusBar.Panels[1].Text:='Запись регистра analog controls по адресу 0x'+ IntToHex(regaddr, 2);
    if not SwireWrite($b8, (regaddr and $ff) or $600000 or (regdata shl 8), 3) then begin
         StatusBar.Panels[1].Text:='Ошибка записи по адресу 0x00B8!';
         ShowMessage(StatusBar.Panels[1].Text);
         MenuEnable;
         exit;
    end;
    i := 3;
    while (i > 0) do begin
      if not SwireRead($b9, 2) then begin
        StatusBar.Panels[1].Text:='Ошибка чтения по адресу 0x00B9!';
        ShowMessage(StatusBar.Panels[1].Text);
        MenuEnable;
        exit;
      end;
      if (swdata[$ba] and 1) = 0 then begin
//        regdata := swdata[$b9];
        SwireWrite($ba, 0, 1);
//        SwireWrite( $0602, $88, 1);// cpu go
        EditRegData.Text := '0x'+IntToHex(regdata,2);
//        StatusBar.Panels[1].Text:='Считано 0x'+ IntToHex(regdata, 2)+' из регистра analog controls по адресу 0x'+ IntToHex(regaddr, 2);
        StatusBar.Panels[1].Text:='Записано 0x'+ IntToHex(regdata, 2)+' в регистра analog controls по адресу 0x'+ IntToHex(regaddr, 2);
        MenuEnable;
        exit;
      end;
      Dec(i);
    end;
    StatusBar.Panels[1].Text:='Ошибка чтения регистра analog controls по адресу 0x'+ IntToHex(regaddr, 2);
    ShowMessage(StatusBar.Panels[1].Text);
    MenuEnable;
end;

procedure TfrmMain.ButtonARdAllClick(Sender: TObject);
var
i : integer;
regaddr : Dword;
bfile : THandle;
adata : array[0..255] of byte;
begin
  MenuDisable;
  SigBreak := False;
     ConnectStartTime := GetTickCount();
     StatusBar.Panels[1].Text:='Чтение analog регистров...';
     if not ARegEnable then begin
         StatusBar.Panels[1].Text:='Ошибка активации ALGM!';
         ShowMessage(StatusBar.Panels[1].Text);
         MenuEnable;
         exit;
     end;
     regaddr := 0;
     while regaddr < $100 do begin
       StatusBar.Panels[1].Text:='Чтение регистра analog controls по адресу 0x'+ IntToHex(regaddr, 2);
       if not SwireWrite($b8, (regaddr and $ff) or $40ff00, 3) then begin
         StatusBar.Panels[1].Text:='Ошибка записи по адресу 0x00B8!';
         ShowMessage(StatusBar.Panels[1].Text);
         MenuEnable;
         exit;
       end;
       i := 3;
       while (i > 0) do begin
         if not SwireRead($b9, 2) then begin
           StatusBar.Panels[1].Text:='Ошибка чтения по адресу 0x00B9!';
           ShowMessage(StatusBar.Panels[1].Text);
           MenuEnable;
           exit;
         end;
         if (swdata[$ba] and 1) = 0 then begin
           SwireWrite($ba,0,1);
           adata[regaddr] := swdata[$b9];
//           StatusBar.Panels[1].Text:='Считано 0x'+ IntToHex(regdata, 2)+' из регистра analog controls по адресу 0x'+ IntToHex(regaddr, 2);
           regaddr := regaddr + 1;
           break;
         end;
         Dec(i);
      end;
      if i = 0 then begin
        SwireWrite($ba,0,1);
        StatusBar.Panels[1].Text:='Ошибка чтения регистра analog controls по адресу 0x'+ IntToHex(regaddr, 2);
        ShowMessage(StatusBar.Panels[1].Text);
        MenuEnable;
      end;
    end;
     ConnectTime := GetTickCount() - ConnectStartTime;
     StatusBar.Panels[1].Text:='Чтение 256 analog регистров - ок. (' + IntToStr(ConnectTime) + ' мс)';
     with SaveDialog do begin
      FilterIndex:=0;
      FileName := 'ardata.bin';
      InitialDir := '.';
      DefaultExt := 'bin';
      Filter := 'bin files (*.bin)|*.bin';
      Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
        +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
        -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
        -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
      Title:='Сохранить блок в файл';
     end;//with
     if SaveDialog.Execute then begin
      Repaint;
      bfile:=FileCreate(SaveDialog.FileName);
      if bfile<>INVALID_HANDLE_VALUE then FileWrite(bfile,adata,sizeof(adata));
      FileClose(bfile);
     end;
  MenuEnable;
end;

end.
