unit STMGpio;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFormStmGpio = class(TForm)
    RadioGroupPinMode: TRadioGroup;
    RadioGroupPinConf0: TRadioGroup;
    RadioGroupPinConf1: TRadioGroup;
    ButtonOk: TButton;
    RadioGroupPull: TRadioGroup;
    RadioGroupOut: TRadioGroup;
    procedure FormActivate(Sender: TObject);
    procedure ButtonOkClick(Sender: TObject);
    procedure RadioGroupPinModeClick(Sender: TObject);
    procedure RadioGroupPinConf1Click(Sender: TObject);
    procedure RadioGroupPinConf0Click(Sender: TObject);
    procedure RadioGroupPullClick(Sender: TObject);
    procedure RadioGroupOutClick(Sender: TObject);
  private
    { Private declarations }
    ChgEna : boolean;
  public
    { Public declarations }
    cnf_mode : dword;
    odr_bit : dword;
    gpio_mode : dword;
    gpio_cnf : dword;
  end;

var
  FormStmGpio: TFormStmGpio;

implementation

{$R *.dfm}

procedure TFormStmGpio.FormActivate(Sender: TObject);
begin
    ChgEna := False;
    gpio_mode := cnf_mode and $03;
    gpio_cnf := (cnf_mode shr 2) and $03;
    RadioGroupPinMode.ItemIndex := gpio_mode;
    RadioGroupPull.ItemIndex := odr_bit and 1;
    RadioGroupOut.ItemIndex := odr_bit and 1;
    RadioGroupPinConf0.ItemIndex := gpio_cnf;
    RadioGroupPinConf1.ItemIndex := gpio_cnf;
    if gpio_mode = 0 then begin
      RadioGroupPinConf1.Visible := False;
      RadioGroupOut.Visible := False;
      RadioGroupPinConf0.Visible := True;
      RadioGroupOut.Visible := False;
      if gpio_cnf = 2 then RadioGroupPull.Visible := True
      else RadioGroupPull.Visible := False;
    end else begin
      RadioGroupPinConf0.Visible := False;
      RadioGroupPull.Visible := False;
      RadioGroupPinConf1.Visible := True;
      RadioGroupOut.Visible := True;
    end;
    ChgEna := True;
end;

procedure TFormStmGpio.ButtonOkClick(Sender: TObject);
begin
   gpio_mode := RadioGroupPinMode.ItemIndex;
   if gpio_mode = 0 then
     gpio_cnf := RadioGroupPinConf0.ItemIndex
   else
     gpio_cnf := RadioGroupPinConf1.ItemIndex;
   cnf_mode :=  (gpio_mode and 3) or ((gpio_cnf and 3) shl 2);
end;

procedure TFormStmGpio.RadioGroupPinModeClick(Sender: TObject);
var
new_mode : dword;
begin
    if ChgEna then begin
      gpio_mode := RadioGroupPinMode.ItemIndex;
      ChgEna := False;
      RadioGroupPull.ItemIndex := odr_bit and 1;
      RadioGroupPinConf0.ItemIndex := gpio_cnf;
      RadioGroupPinConf1.ItemIndex := gpio_cnf;
      if gpio_mode = 0 then begin
          RadioGroupPinConf1.Visible := False;
          RadioGroupOut.Visible := False;
          RadioGroupPinConf0.Visible := True;
          if gpio_cnf = 2 then RadioGroupPull.Visible := True
          else RadioGroupPull.Visible := False;
      end else begin
          RadioGroupPinConf0.Visible := False;
          RadioGroupPull.Visible := False;
          RadioGroupPinConf1.Visible := True;
          RadioGroupOut.Visible := True;
      end;
      ChgEna := True;
    end;
end;

procedure TFormStmGpio.RadioGroupPinConf1Click(Sender: TObject);
begin
    if ChgEna then begin
      gpio_cnf := RadioGroupPinConf1.ItemIndex;
    end;
end;

procedure TFormStmGpio.RadioGroupPinConf0Click(Sender: TObject);
begin
    if ChgEna then begin
      gpio_cnf := RadioGroupPinConf0.ItemIndex;
      if gpio_cnf = 2 then RadioGroupPull.Visible := True
      else RadioGroupPull.Visible := False;
    end;
end;

procedure TFormStmGpio.RadioGroupPullClick(Sender: TObject);
begin
    if ChgEna then begin
      odr_bit := RadioGroupPull.ItemIndex;
    end;
end;

procedure TFormStmGpio.RadioGroupOutClick(Sender: TObject);
begin
    if ChgEna then begin
      odr_bit := RadioGroupOut.ItemIndex;
    end;
end;

end.
