object frmMain: TfrmMain
  Left = 1245
  Top = 226
  Width = 600
  Height = 379
  Caption = 'TLSR Tool'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object LabelFLoaderVer: TLabel
    Left = 312
    Top = 216
    Width = 80
    Height = 13
    Caption = 'FLoader not load'
  end
  object LabelSWM: TLabel
    Left = 448
    Top = 182
    Width = 65
    Height = 13
    Caption = 'SWM ? Mbps'
  end
  object LabelDevID: TLabel
    Left = 312
    Top = 264
    Width = 46
    Height = 13
    Caption = 'SoC ID: ?'
  end
  object ButtonReScanComDevices: TButton
    Left = 8
    Top = 8
    Width = 65
    Height = 21
    Hint = #1055#1077#1088#1077#1089#1082#1072#1085#1080#1088#1086#1074#1072#1090#1100' COM '#1087#1086#1088#1090#1099
    Caption = 'ReScan'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = ButtonReScanComDevicesClick
  end
  object ComboBox: TComboBox
    Left = 88
    Top = 8
    Width = 73
    Height = 21
    Style = csOwnerDrawFixed
    ItemHeight = 15
    ItemIndex = 1
    Sorted = True
    TabOrder = 1
    Text = 'COM3'
    OnChange = ComboBoxChange
    Items.Strings = (
      'COM1'
      'COM3'
      'COM4')
  end
  object ButtonOpen: TButton
    Left = 176
    Top = 8
    Width = 73
    Height = 21
    Hint = #1054#1090#1082#1088#1099#1090#1100'/'#1079#1072#1082#1088#1099#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1099#1081' COM '#1087#1086#1088#1090
    Caption = 'Open'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = ButtonOpenClick
  end
  object ButtonLoad: TButton
    Left = 240
    Top = 152
    Width = 65
    Height = 21
    Hint = #1047#1072#1087#1080#1089#1072#1090#1100' SRAM/REG '#1080#1079' '#1092#1072#1081#1083#1072
    Caption = 'RWrite'
    Enabled = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = ButtonLoadClick
  end
  object ButtonRdAll: TButton
    Left = 168
    Top = 184
    Width = 81
    Height = 21
    Hint = #1057#1095#1080#1090#1072#1090#1100' '#1074' '#1092#1072#1081#1083' '#1074#1089#1077' 65536 '#1073#1072#1081#1090' SRAM'
    Caption = 'RRead All'
    Enabled = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnClick = ButtonReadAllClick
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 318
    Width = 584
    Height = 22
    Panels = <
      item
        Text = 'COM?'
        Width = 50
      end
      item
        Text = 'Open COM port!'
        Width = 50
      end>
  end
  object EditRegAddr: TEdit
    Left = 8
    Top = 152
    Width = 73
    Height = 21
    Hint = #1040#1076#1088#1077#1089' SRAM/REG'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    Text = '0x06bc'
  end
  object ButtonWrite: TButton
    Left = 88
    Top = 184
    Width = 65
    Height = 21
    Hint = #1047#1072#1087#1080#1089#1072#1090#1100' SRAM '#1080#1083#1080' '#1088#1077#1075#1080#1089#1090#1088
    Caption = 'RWrite'
    Enabled = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 7
    OnClick = ButtonWriteClick
  end
  object ButtonRead: TButton
    Left = 88
    Top = 152
    Width = 65
    Height = 21
    Hint = #1055#1088#1086#1095#1080#1090#1072#1090#1100' '#1088#1077#1075#1080#1089#1090#1088
    Caption = 'RRead'
    Enabled = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 8
    OnClick = ButtonReadClick
  end
  object EditRegData: TEdit
    Left = 8
    Top = 184
    Width = 73
    Height = 21
    Hint = #1047#1085#1072#1095#1077#1085#1080#1077' SRAM/REG'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
    Text = '0x00000000'
  end
  object EditLdAddr: TEdit
    Left = 176
    Top = 152
    Width = 57
    Height = 21
    Hint = #1057#1090#1072#1088#1090#1086#1074#1099#1081' '#1072#1076#1088#1077#1089' '#1074'  SRAM/REG'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 10
    Text = '0x8000'
  end
  object ButtonFWrite: TButton
    Left = 72
    Top = 248
    Width = 65
    Height = 21
    Hint = #1047#1072#1087#1080#1089#1100' Flash '#1080#1079' '#1092#1072#1081#1083#1072
    Caption = 'FWrite'
    Enabled = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 11
    OnClick = ButtonFWriteClick
  end
  object ButtonChErase: TButton
    Left = 232
    Top = 288
    Width = 73
    Height = 21
    Hint = #1057#1090#1077#1088#1077#1090#1100' '#1074#1089#1102' Flash'
    Caption = 'Flash Erase'
    Enabled = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 12
    OnClick = ButtonEraAllClick
  end
  object ButtonFRead: TButton
    Left = 152
    Top = 216
    Width = 65
    Height = 21
    Hint = #1063#1090#1077#1085#1080#1077' Flash '#1074' '#1092#1072#1081#1083
    Caption = 'FRead'
    Enabled = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 13
    OnClick = ButtonFReadClick
  end
  object EditFAddr: TEdit
    Left = 8
    Top = 216
    Width = 57
    Height = 21
    Hint = #1057#1090#1072#1088#1090#1086#1074#1099#1081' '#1072#1076#1088#1077#1089' '#1074' Flash'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 14
    Text = '0x000000'
  end
  object EditFwAddr: TEdit
    Left = 8
    Top = 248
    Width = 57
    Height = 21
    Hint = #1057#1090#1072#1088#1090#1086#1074#1099#1081' '#1072#1076#1088#1077#1089' '#1074' Flash'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 15
    Text = '0x000000'
  end
  object EditFRLen: TEdit
    Left = 72
    Top = 216
    Width = 73
    Height = 21
    Hint = #1056#1072#1079#1084#1077#1088' '#1095#1090#1077#1085#1080#1103' '#1080#1079' Flash'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 16
    Text = '0x0000010'
  end
  object ButtonSoftReset: TButton
    Left = 416
    Top = 240
    Width = 65
    Height = 21
    Hint = 'Reboot (Soft Reset)'
    Caption = 'Reboot'
    Enabled = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 17
    OnClick = ButtonRebootClick
  end
  object ButtonCPURun: TButton
    Left = 416
    Top = 288
    Width = 65
    Height = 21
    Hint = 'CPU Run (0x0602 <- 0x88)'
    Caption = 'CPU Run'
    Enabled = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 18
    OnClick = ButtonCPURunClick
  end
  object ButtonActivate: TButton
    Left = 312
    Top = 152
    Width = 89
    Height = 57
    Hint = 'Activate'
    Caption = 'Activate'
    Enabled = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 19
    OnClick = ButtonActivateClick
  end
  object EditACount: TEdit
    Left = 416
    Top = 152
    Width = 49
    Height = 21
    Hint = #1044#1083#1090#1077#1083#1100#1085#1086#1089#1090#1100' '#1089#1080#1075#1085#1072#1083#1072' Reset '#1074' '#1084#1089'.'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 20
    Text = '50'
  end
  object EditSpeed: TEdit
    Left = 488
    Top = 152
    Width = 25
    Height = 21
    Hint = #1047#1085#1072#1095#1077#1085#1080#1077' reg_swire_clk_div'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 21
    Text = '5'
  end
  object ButtonReset: TButton
    Left = 344
    Top = 8
    Width = 65
    Height = 21
    Hint = #1040#1087#1087#1087#1072#1088#1072#1090#1085#1099#1081' '#1089#1073#1088#1086#1089' (PORTB0->RST)'
    Caption = 'Reset'
    Enabled = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 22
    OnClick = ButtonResetClick
  end
  object ButtonSpeed: TButton
    Left = 416
    Top = 200
    Width = 65
    Height = 21
    Hint = #1059#1089#1090#1072#1085#1086#1074#1082#1072' '#1089#1082#1086#1088#1086#1089#1090#1080' swire '#1074' reg_swire_clk_div '
    Caption = 'Speed'
    Enabled = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 23
    OnClick = ButtonSpeedClick
  end
  object ButtonCpuStop: TButton
    Left = 416
    Top = 264
    Width = 65
    Height = 21
    Hint = 'CPU Stop (0x0602 <- 0x05)'
    Caption = 'CPU Stop'
    Enabled = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 24
    OnClick = ButtonCpuStopClick
  end
  object ButtonRSTGND: TButton
    Left = 424
    Top = 8
    Width = 65
    Height = 21
    Hint = #1055#1088#1080#1090#1103#1085#1091#1090#1100' RST '#1082' GND'
    Caption = 'RST On'
    Enabled = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 25
    OnClick = ButtonRSTGNDClick
  end
  object ButtonTest: TButton
    Left = 72
    Top = 280
    Width = 65
    Height = 21
    Hint = #1058#1077#1089#1090
    Caption = 'Test'
    Enabled = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 26
    OnClick = ButtonTestClick
  end
  object EditFCmd: TEdit
    Left = 8
    Top = 280
    Width = 57
    Height = 21
    Hint = #1050#1086#1084#1072#1085#1076#1072' '#1082' Flash'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 27
    Text = '0x9F'
  end
  object ButtonASpeed: TButton
    Left = 496
    Top = 200
    Width = 65
    Height = 21
    Hint = #1040#1074#1090#1086#1087#1086#1076#1073#1086#1088' '#1089#1082#1086#1088#1086#1089#1090#1080' swire '#1074' reg_swire_clk_div '
    Caption = 'ASpeed'
    Enabled = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 28
    OnClick = ButtonASpeedClick
  end
  object EditTimeReset: TEdit
    Left = 288
    Top = 8
    Width = 49
    Height = 21
    Hint = #1044#1083#1090#1077#1083#1100#1085#1086#1089#1090#1100' '#1089#1080#1075#1085#1072#1083#1072' Reset '#1074' '#1084#1089'.'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 29
    Text = '1000'
  end
  object ButtonSectorErase: TButton
    Left = 232
    Top = 264
    Width = 73
    Height = 21
    Hint = #1057#1090#1077#1088#1077#1090#1100' '#1089#1077#1082#1090#1086#1088' Flash'
    Caption = 'Sector Erase'
    Enabled = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 30
    OnClick = ButtonSectorEraseClick
  end
  object CheckBoxFSEEna: TCheckBox
    Left = 152
    Top = 250
    Width = 73
    Height = 17
    Hint = #1057#1090#1080#1088#1072#1090#1100' '#1089#1077#1082#1090#1086#1088#1072' Flash '#1087#1088#1080' '#1079#1072#1087#1080#1089#1080
    Caption = 'Sec.Erase'
    Checked = True
    ParentShowHint = False
    ShowHint = True
    State = cbChecked
    TabOrder = 31
  end
  object ButtonFFRead: TButton
    Left = 232
    Top = 216
    Width = 73
    Height = 37
    Hint = #1063#1090#1077#1085#1080#1077' Flash '#1095#1077#1088#1077#1079' FLoader (FastFlashRead)'
    Caption = 'FFRead'
    Enabled = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 32
    OnClick = ButtonFFReadClick
  end
  object ButtonBreak: TButton
    Left = 504
    Top = 288
    Width = 73
    Height = 21
    Hint = #1054#1089#1090#1072#1085#1086#1074#1080#1090#1100
    Caption = '#'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 33
    OnClick = ButtonBreakClick
  end
  object ButtonSFWrite: TButton
    Left = 152
    Top = 272
    Width = 73
    Height = 41
    Hint = #1047#1072#1087#1080#1089#1100' Flash '#1080#1079' '#1092#1072#1081#1083#1072' '#1095#1077#1088#1077#1079' FLoader (FastFlashWrite)'
    Caption = 'FFWrite'
    Enabled = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 34
    OnClick = ButtonSFWriteClick
  end
  object PanelSTM: TPanel
    Left = 8
    Top = 40
    Width = 569
    Height = 97
    BevelOuter = bvLowered
    TabOrder = 35
    object LabelStm: TLabel
      Left = 8
      Top = 8
      Width = 79
      Height = 13
      Caption = 'Device not open'
    end
    object ShapePB0: TShape
      Left = 104
      Top = 24
      Width = 17
      Height = 17
      Brush.Color = clSilver
      Shape = stCircle
      OnMouseDown = ShapePB0MouseDown
    end
    object LabelNameGPIO: TLabel
      Left = 104
      Top = 8
      Width = 458
      Height = 13
      Caption = 
        'PB0   PB1   PB2   PB3   PB4   PB5   PB6   PB7   PB8   PB9  PB10 ' +
        'PB11 PB12 PB13 PB14 PB15'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object ShapePB1: TShape
      Left = 133
      Top = 24
      Width = 17
      Height = 17
      Brush.Color = clSilver
      Shape = stCircle
      OnMouseDown = ShapePB1MouseDown
    end
    object ShapePB2: TShape
      Left = 162
      Top = 24
      Width = 17
      Height = 17
      Brush.Color = clSilver
      Shape = stCircle
      OnMouseDown = ShapePB2MouseDown
    end
    object ShapePB3: TShape
      Left = 191
      Top = 24
      Width = 17
      Height = 17
      Brush.Color = clSilver
      Shape = stCircle
      OnMouseDown = ShapePB3MouseDown
    end
    object ShapePB4: TShape
      Left = 220
      Top = 24
      Width = 17
      Height = 17
      Brush.Color = clSilver
      Shape = stCircle
      OnMouseDown = ShapePB4MouseDown
    end
    object ShapePB5: TShape
      Left = 249
      Top = 24
      Width = 17
      Height = 17
      Brush.Color = clSilver
      Shape = stCircle
      OnMouseDown = ShapePB5MouseDown
    end
    object ShapePB6: TShape
      Left = 278
      Top = 24
      Width = 17
      Height = 17
      Brush.Color = clSilver
      Shape = stCircle
      OnMouseDown = ShapePB6MouseDown
    end
    object ShapePB7: TShape
      Left = 307
      Top = 24
      Width = 17
      Height = 17
      Brush.Color = clSilver
      Shape = stCircle
      OnMouseDown = ShapePB7MouseDown
    end
    object LabelGPIO: TLabel
      Left = 8
      Top = 46
      Width = 3
      Height = 13
    end
    object ShapePB8: TShape
      Left = 336
      Top = 24
      Width = 17
      Height = 17
      Brush.Color = clSilver
      Shape = stCircle
      OnMouseDown = ShapePB8MouseDown
    end
    object ShapePB9: TShape
      Left = 365
      Top = 24
      Width = 17
      Height = 17
      Brush.Color = clSilver
      Shape = stCircle
      OnMouseDown = ShapePB9MouseDown
    end
    object ShapePB10: TShape
      Left = 394
      Top = 24
      Width = 17
      Height = 17
      Brush.Color = clSilver
      Shape = stCircle
      OnMouseDown = ShapePB10MouseDown
    end
    object ShapePB11: TShape
      Left = 452
      Top = 24
      Width = 17
      Height = 17
      Brush.Color = clSilver
      Shape = stCircle
      OnMouseDown = ShapePB11MouseDown
    end
    object ShapePB12: TShape
      Left = 423
      Top = 24
      Width = 17
      Height = 17
      Brush.Color = clSilver
      Shape = stCircle
      OnMouseDown = ShapePB12MouseDown
    end
    object ShapePB13: TShape
      Left = 481
      Top = 24
      Width = 17
      Height = 17
      Brush.Color = clSilver
      Shape = stCircle
      OnMouseDown = ShapePB13MouseDown
    end
    object ShapePB14: TShape
      Left = 510
      Top = 24
      Width = 17
      Height = 17
      Brush.Color = clSilver
      Shape = stCircle
      OnMouseDown = ShapePB14MouseDown
    end
    object ShapePB15: TShape
      Left = 539
      Top = 24
      Width = 17
      Height = 17
      Brush.Color = clSilver
      Shape = stCircle
      OnMouseDown = ShapePB15MouseDown
    end
    object ShapeRun: TShape
      Left = 74
      Top = 26
      Width = 12
      Height = 12
      Hint = 
        #1045#1089#1083#1080' '#1084#1080#1075#1072#1077#1090', '#1079#1085#1072#1095#1080#1090' '#1088#1072#1073#1086#1090#1077#1090' '#1086#1087#1088#1086#1089'. '#1055#1088#1072#1074#1086#1081' '#1082#1085#1086#1087#1082#1086#1081'  '#1084#1099#1096#1080'  '#1074#1099#1073#1080#1088#1072#1077 +
        #1090#1089#1103' '#1088#1077#1078#1080#1084' '#1087#1086#1088#1090#1072'.'
      Brush.Color = clYellow
      ParentShowHint = False
      Shape = stCircle
      ShowHint = True
    end
    object ShapePC13: TShape
      Left = 481
      Top = 72
      Width = 17
      Height = 17
      Brush.Color = clSilver
      Shape = stCircle
      OnMouseDown = ShapePC13MouseDown
    end
    object ShapePC14: TShape
      Left = 510
      Top = 72
      Width = 17
      Height = 17
      Brush.Color = clSilver
      Shape = stCircle
      OnMouseDown = ShapePC14MouseDown
    end
    object ShapePC15: TShape
      Left = 539
      Top = 72
      Width = 17
      Height = 17
      Brush.Color = clSilver
      Shape = stCircle
      OnMouseDown = ShapePC15MouseDown
    end
    object Label1: TLabel
      Left = 479
      Top = 56
      Width = 84
      Height = 13
      Caption = 'PC13 PC14 PC15'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object ShapePA0: TShape
      Left = 104
      Top = 72
      Width = 17
      Height = 17
      Brush.Color = clSilver
      Shape = stCircle
      OnMouseDown = ShapePA0MouseDown
    end
    object ShapePA1: TShape
      Left = 133
      Top = 72
      Width = 17
      Height = 17
      Brush.Color = clSilver
      Shape = stCircle
      OnMouseDown = ShapePA1MouseDown
    end
    object ShapePA2: TShape
      Left = 162
      Top = 72
      Width = 17
      Height = 17
      Brush.Color = clSilver
      Shape = stCircle
      OnMouseDown = ShapePA2MouseDown
    end
    object ShapePA3: TShape
      Left = 191
      Top = 72
      Width = 17
      Height = 17
      Brush.Color = clSilver
      Shape = stCircle
      OnMouseDown = ShapePA3MouseDown
    end
    object ShapePA4: TShape
      Left = 220
      Top = 72
      Width = 17
      Height = 17
      Brush.Color = clSilver
      Shape = stCircle
      OnMouseDown = ShapePA4MouseDown
    end
    object ShapePA5: TShape
      Left = 249
      Top = 72
      Width = 17
      Height = 17
      Brush.Color = clSilver
      Shape = stCircle
      OnMouseDown = ShapePA5MouseDown
    end
    object ShapePA6: TShape
      Left = 278
      Top = 72
      Width = 17
      Height = 17
      Brush.Color = clSilver
      Shape = stCircle
      OnMouseDown = ShapePA6MouseDown
    end
    object ShapePA7: TShape
      Left = 307
      Top = 72
      Width = 17
      Height = 17
      Brush.Color = clSilver
      Shape = stCircle
      OnMouseDown = ShapePA7MouseDown
    end
    object ShapePA8: TShape
      Left = 336
      Top = 72
      Width = 17
      Height = 17
      Brush.Color = clSilver
      Shape = stCircle
      OnMouseDown = ShapePA8MouseDown
    end
    object ShapePA9: TShape
      Left = 365
      Top = 72
      Width = 17
      Height = 17
      Brush.Color = clSilver
      Shape = stCircle
      OnMouseDown = ShapePA9MouseDown
    end
    object ShapePA10: TShape
      Left = 394
      Top = 72
      Width = 17
      Height = 17
      Brush.Color = clSilver
      Shape = stCircle
      OnMouseDown = ShapePA10MouseDown
    end
    object Label2: TLabel
      Left = 103
      Top = 56
      Width = 342
      Height = 13
      Caption = 
        'PA0   PA1   PA2   PA3   PA4   PA5   PA6   PA7   PA8   PA9  PA10 ' +
        'PA15'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object ShapePA15: TShape
      Left = 423
      Top = 72
      Width = 17
      Height = 17
      Brush.Color = clSilver
      Shape = stCircle
      OnMouseDown = ShapePA15MouseDown
    end
    object CheckBoxChkGpio: TCheckBox
      Left = 8
      Top = 24
      Width = 65
      Height = 17
      Hint = #1054#1087#1088#1086#1089' GPIO'
      Caption = 'RdGPIO'
      Checked = True
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 0
      OnClick = CheckBoxChkGpioClick
    end
  end
  object ButtonRSTOff: TButton
    Left = 496
    Top = 8
    Width = 65
    Height = 21
    Hint = #1055#1088#1080#1090#1103#1085#1091#1090#1100' RST '#1082' GND'
    Caption = 'RST Off'
    Enabled = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 36
    OnClick = ButtonRSTOffClick
  end
  object ButtonAnaRead: TButton
    Left = 504
    Top = 264
    Width = 65
    Height = 21
    Hint = #1055#1088#1086#1095#1080#1090#1072#1090#1100' '#1088#1077#1075#1080#1089#1090#1088#1099' analog controls'
    Caption = 'AnaRead'
    Enabled = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 37
    Visible = False
    OnClick = ButtonAnaReadClick
  end
  object EditSTMSpeed: TEdit
    Left = 528
    Top = 152
    Width = 25
    Height = 21
    Hint = 
      #1047#1085#1072#1095#1077#1085#1080#1077' stm_clk_div. 0: 5.1, 1: 2.57, 2: 1.286, 3: 0.643, 4: 0.' +
      '321, 5: 0.161, 6: 0.080, 7: 0.040 Mbps '
    ParentShowHint = False
    ShowHint = True
    TabOrder = 38
    Text = '2'
  end
  object SaveDialog: TSaveDialog
    Left = 576
    Top = 40
  end
  object OpenDialog: TOpenDialog
    Left = 576
    Top = 8
  end
  object Timer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TimerTimer
    Left = 568
    Top = 128
  end
end
