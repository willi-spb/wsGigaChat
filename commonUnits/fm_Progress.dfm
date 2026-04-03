object ProgressForm: TProgressForm
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'ProgressForm'
  ClientHeight = 101
  ClientWidth = 289
  Color = 7368011
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  DesignSize = (
    289
    101)
  PixelsPerInch = 96
  TextHeight = 13
  object lblLoading: TLabel
    Left = 32
    Top = 65
    Width = 228
    Height = 28
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'wait...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object lblLoadCaption: TLabel
    Left = 30
    Top = 12
    Width = 230
    Height = 13
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Loading'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object cxpbar_Loading: TcxProgressBar
    Left = 30
    Top = 35
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Position = 12.500000000000000000
    Properties.PeakValue = 12.500000000000000000
    Properties.SolidTextColor = True
    Style.BorderStyle = ebsNone
    Style.Shadow = False
    TabOrder = 0
    Height = 24
    Width = 230
  end
  object tmrProgressLoading: TTimer
    Enabled = False
    Interval = 200
    OnTimer = tmrProgressLoadingTimer
    Left = 200
    Top = 48
  end
end
