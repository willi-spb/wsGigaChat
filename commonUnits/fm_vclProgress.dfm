object VCLProgressForm: TVCLProgressForm
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'VCLProgressForm'
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
  OnCreate = FormCreate
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
    Top = 7
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
    Transparent = True
  end
  object pbar_Loading: TProgressBar
    Left = 8
    Top = 42
    Width = 273
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Position = 12
    Smooth = True
    MarqueeInterval = 1
    Step = 1
    TabOrder = 0
  end
  object tmrProgressLoading: TTimer
    Enabled = False
    Interval = 200
    OnTimer = tmrProgressLoadingTimer
    Left = 200
    Top = 48
  end
end
