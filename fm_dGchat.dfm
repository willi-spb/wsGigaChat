object GChatDirForm: TGChatDirForm
  Left = 0
  Top = 0
  Caption = 'GChatDirForm'
  ClientHeight = 774
  ClientWidth = 1209
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbl_State: TLabel
    Left = 592
    Top = 488
    Width = 51
    Height = 13
    Caption = 'lbl_State'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object imgR: TImage
    Left = 592
    Top = 47
    Width = 497
    Height = 323
    Proportional = True
    Stretch = True
  end
  object btnuploadImage: TButton
    Left = 32
    Top = 16
    Width = 153
    Height = 25
    Action = act_uploadImage
    TabOrder = 0
  end
  object btndownloadImage: TButton
    Left = 32
    Top = 80
    Width = 193
    Height = 25
    Action = act_downloadImage
    TabOrder = 1
  end
  object btngenerateImage: TButton
    Left = 24
    Top = 329
    Width = 161
    Height = 25
    Action = act_generateImage
    TabOrder = 2
  end
  object btngetResponse: TButton
    Left = 328
    Top = 240
    Width = 193
    Height = 25
    Action = act_getResponse
    TabOrder = 3
  end
  object btngetAnswerForImage: TButton
    Left = 328
    Top = 288
    Width = 193
    Height = 25
    Action = act_getAnswerForImage
    TabOrder = 4
  end
  object btnfileList: TButton
    Left = 456
    Top = 104
    Width = 121
    Height = 25
    Action = act_fileList
    TabOrder = 5
  end
  object btndescForRentgen: TButton
    Left = 592
    Top = 424
    Width = 169
    Height = 25
    Action = act_descForRentgen
    TabOrder = 6
  end
  object btnloadImage: TButton
    Left = 592
    Top = 16
    Width = 145
    Height = 25
    Action = act_loadImage
    TabOrder = 7
  end
  object mmoDesc: TMemo
    Left = 24
    Top = 360
    Width = 481
    Height = 89
    Lines.Strings = (
      'mmoDesc')
    TabOrder = 8
  end
  object edtUploadID: TEdit
    Left = 208
    Top = 18
    Width = 337
    Height = 21
    TabOrder = 9
  end
  object lbledt_desc: TLabeledEdit
    Left = 592
    Top = 397
    Width = 569
    Height = 21
    EditLabel.Width = 39
    EditLabel.Height = 13
    EditLabel.Caption = #1047#1072#1087#1088#1086#1089':'
    TabOrder = 10
    Text = 
      #1054#1087#1080#1096#1080' '#1076#1080#1072#1075#1085#1086#1079' '#1089#1090#1086#1084#1072#1090#1086#1083#1086#1075#1080#1095#1077#1089#1082#1086#1075#1086' '#1079#1072#1073#1086#1083#1077#1074#1072#1085#1080#1103' '#1087#1086' '#1088#1077#1085#1090#1075#1077#1085#1086#1074#1089#1082#1086#1084#1091' '#1089 +
      #1085#1080#1084#1082#1091' '#1079#1091#1073#1086#1074'.'
  end
  object chk_fileID: TCheckBox
    Left = 792
    Top = 427
    Width = 273
    Height = 17
    Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' ID '#1092#1072#1081#1083#1072
    TabOrder = 11
  end
  object edt_descRID: TEdit
    Left = 592
    Top = 455
    Width = 369
    Height = 21
    TabOrder = 12
  end
  object btnsmList: TButton
    Left = 32
    Top = 232
    Width = 75
    Height = 25
    Action = act_smList
    TabOrder = 13
  end
  object btndescForImageTH: TButton
    Left = 592
    Top = 520
    Width = 209
    Height = 25
    Action = act_descForImageTH
    TabOrder = 14
  end
  object actlstGC: TActionList
    Left = 400
    Top = 64
    object act_uploadImage: TAction
      Caption = 'act_uploadImage'
      OnExecute = act_uploadImageExecute
    end
    object act_Auth: TAction
      Caption = 'act_Auth'
      OnExecute = act_AuthExecute
    end
    object act_downloadImage: TAction
      Caption = 'act_downloadImage'
      OnExecute = act_downloadImageExecute
    end
    object act_generateImage: TAction
      Caption = 'act_generateImage'
      OnExecute = act_generateImageExecute
      OnUpdate = act_generateImageUpdate
    end
    object act_getResponse: TAction
      Caption = 'act_getResponse'
      OnExecute = act_getResponseExecute
    end
    object act_getAnswerForImage: TAction
      Caption = 'act_getAnswerForImage'
      OnExecute = act_getAnswerForImageExecute
    end
    object act_fileList: TAction
      Caption = 'act_fileList'
      OnExecute = act_fileListExecute
    end
    object act_descForRentgen: TAction
      Caption = 'act_descForRentgen'
      OnExecute = act_descForRentgenExecute
      OnUpdate = act_descForRentgenUpdate
    end
    object act_loadImage: TAction
      Caption = 'act_loadImage'
      OnExecute = act_loadImageExecute
    end
    object act_smList: TAction
      Caption = 'act_smList'
      OnExecute = act_smListExecute
    end
    object act_descForImageTH: TAction
      Caption = 'act_descForImageTH'
      OnExecute = act_descForImageTHExecute
      OnUpdate = act_descForRentgenUpdate
    end
  end
  object dlgOpenPict: TOpenPictureDialog
    DefaultExt = 'jpg'
    FilterIndex = 3
    Left = 312
    Top = 64
  end
  object dlgSavePict_1: TSavePictureDialog
    DefaultExt = 'jpg'
    FilterIndex = 3
    Left = 312
    Top = 144
  end
end
