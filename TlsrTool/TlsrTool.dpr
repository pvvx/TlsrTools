program TlsrTool;

uses
  Forms,
  ComPort in 'ComPort.pas',
  HexUtils in 'HexUtils.pas',
  MainFrm in 'MainFrm.pas' {frmMain},
  STMGpio in 'STMGpio.pas' {FormStmGpio};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'TLSR Tool';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TFormStmGpio, FormStmGpio);
  Application.Run;
end.
