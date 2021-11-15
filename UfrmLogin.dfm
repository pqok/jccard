object frmLogin: TfrmLogin
  Left = 192
  Top = 123
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsSingle
  Caption = #30331#24405
  ClientHeight = 249
  ClientWidth = 375
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 375
    Height = 249
    Align = alClient
    BevelWidth = 2
    Color = 16767438
    TabOrder = 0
    object LabeledEdit1: TLabeledEdit
      Left = 144
      Top = 48
      Width = 121
      Height = 21
      EditLabel.Width = 26
      EditLabel.Height = 13
      EditLabel.Caption = #24080#21495
      LabelPosition = lpLeft
      TabOrder = 0
    end
    object LabeledEdit2: TLabeledEdit
      Left = 144
      Top = 96
      Width = 121
      Height = 21
      EditLabel.Width = 26
      EditLabel.Height = 13
      EditLabel.Caption = #23494#30721
      LabelPosition = lpLeft
      PasswordChar = '*'
      TabOrder = 1
    end
    object BitBtn1: TBitBtn
      Left = 80
      Top = 168
      Width = 75
      Height = 25
      Caption = #30331#24405
      TabOrder = 2
      OnClick = BitBtn1Click
    end
    object BitBtn2: TBitBtn
      Left = 216
      Top = 168
      Width = 75
      Height = 25
      Caption = #21462#28040
      TabOrder = 3
      OnClick = BitBtn2Click
    end
  end
  object DosMove1: TDosMove
    Active = True
    Left = 288
    Top = 56
  end
end
