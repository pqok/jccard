object frmMain: TfrmMain
  Left = 210
  Top = 127
  Width = 870
  Height = 450
  Caption = #26223#31574#21457#21345
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StringGrid1: TStringGrid
    Left = 0
    Top = 118
    Width = 854
    Height = 209
    Align = alClient
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
    TabOrder = 1
    OnSelectCell = StringGrid1SelectCell
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 854
    Height = 78
    Align = alTop
    Color = 16767438
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 13
      Width = 26
      Height = 13
      Caption = #24037#21378
    end
    object Label2: TLabel
      Left = 15
      Top = 51
      Width = 26
      Height = 13
      Caption = #23703#20301
    end
    object ComboBox1: TComboBox
      Left = 44
      Top = 9
      Width = 509
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 3
    end
    object ComboBox2: TComboBox
      Left = 44
      Top = 48
      Width = 100
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 4
      Text = #20840#37096
      Items.Strings = (
        #20840#37096
        '[0]'#26410#30693
        '[1]'#32455#24067#24037
        '[2]'#39564#24067#24037
        '[3]'#32479#35745#21592
        '[4]'#21378#38271
        '[5]'#32769#26495)
    end
    object LabeledEdit1: TLabeledEdit
      Left = 279
      Top = 48
      Width = 100
      Height = 21
      EditLabel.Width = 118
      EditLabel.Height = 13
      EditLabel.Caption = #22995#21517'('#25903#25345#27169#31946#21305#37197')'
      LabelPosition = lpLeft
      TabOrder = 0
    end
    object BitBtn1: TBitBtn
      Left = 568
      Top = 9
      Width = 75
      Height = 61
      Caption = #26597#35810'F5'
      TabOrder = 2
      OnClick = BitBtn1Click
    end
    object LabeledEdit4: TLabeledEdit
      Left = 431
      Top = 48
      Width = 121
      Height = 21
      EditLabel.Width = 39
      EditLabel.Height = 13
      EditLabel.Caption = #25163#26426#21495
      LabelPosition = lpLeft
      TabOrder = 1
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 327
    Width = 854
    Height = 45
    Align = alBottom
    Color = 16767438
    TabOrder = 2
    object Label3: TLabel
      Left = 250
      Top = 16
      Width = 26
      Height = 13
      Caption = #26435#38480
    end
    object Label4: TLabel
      Left = 2
      Top = 16
      Width = 39
      Height = 13
      Caption = #21345#31867#21035
    end
    object ComboBox3: TComboBox
      Left = 279
      Top = 12
      Width = 100
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 0
      Text = '1'
      Items.Strings = (
        '1'
        '2'
        '3'
        '4'
        '5'
        '6')
    end
    object BitBtn2: TBitBtn
      Left = 431
      Top = 10
      Width = 75
      Height = 25
      Caption = #21457#21345'F3'
      TabOrder = 1
      OnClick = BitBtn2Click
    end
    object LYLed1: TLYLed
      Left = 568
      Top = 13
      Width = 19
      Height = 19
      Cursor = crDefault
      Hint = #21457#21345#22120#36830#25509#25351#31034#28783
      Value = False
      OnColor = clLime
      OffColor = clBtnFace
      Interval = 500
      Blink = True
      BorderColor = clMaroon
      ShowHint = True
      hasSound = True
      SoundString = '.\Wave\Driveby.wav'
      SoundInValue = True
    end
    object ComboBox4: TComboBox
      Left = 44
      Top = 12
      Width = 121
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 3
      Text = '[1]'#26723#36710#24037#21345
      Items.Strings = (
        '[1]'#26723#36710#24037#21345
        '[2]'#26426#20462#21345
        '[3]'#31649#29702#21592#21345
        '[4]'#36229#32423#26435#38480#21345)
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 78
    Width = 854
    Height = 40
    Align = alTop
    TabOrder = 3
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 200
      Height = 38
      Align = alLeft
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -19
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object Panel3: TPanel
      Left = 201
      Top = 1
      Width = 252
      Height = 38
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -19
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object Panel6: TPanel
      Left = 453
      Top = 1
      Width = 400
      Height = 38
      Align = alRight
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -19
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 372
    Width = 854
    Height = 19
    Panels = <
      item
        Text = #26223#31574#31185#25216
        Width = 100
      end
      item
        Width = 300
      end
      item
        Width = 300
      end
      item
        Width = 300
      end
      item
        Width = 50
      end>
  end
  object DosMove1: TDosMove
    Active = True
    Left = 652
    Top = 16
  end
  object ActionList1: TActionList
    Left = 684
    Top = 16
    object Action1: TAction
      Caption = 'Action1'
      ShortCut = 116
      OnExecute = BitBtn1Click
    end
    object Action2: TAction
      Caption = 'Action2'
      ShortCut = 114
      OnExecute = BitBtn2Click
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 716
    Top = 16
  end
  object MainMenu1: TMainMenu
    Left = 748
    Top = 16
    object N1: TMenuItem
      Caption = #25991#20214
      object N2: TMenuItem
        Caption = #25163#21160#36830#25509#21457#21345#22120
        OnClick = N2Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object N3: TMenuItem
        Caption = #35835#21345
        OnClick = N3Click
      end
    end
  end
end
