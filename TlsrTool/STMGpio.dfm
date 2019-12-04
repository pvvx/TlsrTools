object FormStmGpio: TFormStmGpio
  Left = 886
  Top = 322
  BorderStyle = bsDialog
  Caption = 'STM GPIO'
  ClientHeight = 216
  ClientWidth = 496
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object RadioGroupPinMode: TRadioGroup
    Left = 8
    Top = 8
    Width = 225
    Height = 113
    Caption = 'Pin Mode'
    ItemIndex = 0
    Items.Strings = (
      '00: Input mode (reset state)'
      '01: Output mode, max speed 10 MHz.'
      '10: Output mode, max speed 2 MHz.'
      '11: Output mode, max speed 50 MHz.')
    TabOrder = 0
    OnClick = RadioGroupPinModeClick
  end
  object RadioGroupPinConf0: TRadioGroup
    Left = 240
    Top = 8
    Width = 249
    Height = 113
    Caption = 'Configuration'
    ItemIndex = 0
    Items.Strings = (
      '00: Analog mode'
      '01: Floating input (reset state)'
      '10: Input with pull-up / pull-down'
      '11: Reserved')
    TabOrder = 1
    OnClick = RadioGroupPinConf0Click
  end
  object RadioGroupPinConf1: TRadioGroup
    Left = 240
    Top = 8
    Width = 249
    Height = 113
    Caption = 'Configuration'
    ItemIndex = 0
    Items.Strings = (
      '00: General purpose output push-pull'
      '01: General purpose output Open-drain'
      '10: Alternate function output Push-pull'
      '11: Alternate function output Open-drain')
    TabOrder = 2
    OnClick = RadioGroupPinConf1Click
  end
  object ButtonOk: TButton
    Left = 200
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 3
    OnClick = ButtonOkClick
  end
  object RadioGroupPull: TRadioGroup
    Left = 144
    Top = 128
    Width = 185
    Height = 49
    Caption = 'Input Pull'
    ItemIndex = 0
    Items.Strings = (
      'Input pull-down'
      'Input pull-up')
    TabOrder = 4
    OnClick = RadioGroupPullClick
  end
  object RadioGroupOut: TRadioGroup
    Left = 144
    Top = 128
    Width = 185
    Height = 49
    Caption = 'Output'
    ItemIndex = 0
    Items.Strings = (
      'Set out '#39'0'#39
      'Set out '#39'1'#39)
    TabOrder = 5
    OnClick = RadioGroupOutClick
  end
end
