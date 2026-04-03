object GChatListForm: TGChatListForm
  Left = 0
  Top = 0
  Caption = 'GChatListForm'
  ClientHeight = 459
  ClientWidth = 1035
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object cxgrd_List: TcxGrid
    Left = 0
    Top = 49
    Width = 1035
    Height = 410
    Align = alClient
    TabOrder = 0
    ExplicitTop = 44
    object cxgrdv_List: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = dsGList
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      OptionsView.Indicator = True
      object cxgrdbclmn_ListRecId: TcxGridDBColumn
        DataBinding.FieldName = 'RecId'
        Visible = False
        HeaderAlignmentHorz = taCenter
      end
      object cxgrdbclmn_Listid: TcxGridDBColumn
        DataBinding.FieldName = 'id'
        HeaderAlignmentHorz = taCenter
        Width = 176
      end
      object cxgrdbclmn_Listobject: TcxGridDBColumn
        DataBinding.FieldName = 'object'
        HeaderAlignmentHorz = taCenter
        Width = 49
      end
      object cxgrdbclmn_Listaccess_policy: TcxGridDBColumn
        DataBinding.FieldName = 'access_policy'
        HeaderAlignmentHorz = taCenter
        Width = 100
      end
      object cxgrdbclmn_Listcreated_at: TcxGridDBColumn
        DataBinding.FieldName = 'created_at'
        HeaderAlignmentHorz = taCenter
        Width = 116
      end
      object cxgrdbclmn_Listfilename: TcxGridDBColumn
        DataBinding.FieldName = 'filename'
        HeaderAlignmentHorz = taCenter
        Width = 346
      end
      object cxgrdbclmn_Listpurpose: TcxGridDBColumn
        DataBinding.FieldName = 'purpose'
        HeaderAlignmentHorz = taCenter
        Width = 146
      end
      object cxgrdbclmn_ListmodalItems: TcxGridDBColumn
        DataBinding.FieldName = 'modalItems'
        HeaderAlignmentHorz = taCenter
        Width = 88
      end
    end
    object cxgrdLVL_Grid1Level1: TcxGridLevel
      GridView = cxgrdv_List
    end
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 1035
    Height = 49
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 1115
    object btndelete: TButton
      Left = 24
      Top = 13
      Width = 75
      Height = 25
      Action = act_delete
      TabOrder = 0
    end
  end
  object dxmdt_glist: TdxMemData
    Indexes = <>
    SortOptions = []
    Left = 96
    Top = 128
    object strngfld_glistid: TStringField
      FieldName = 'id'
      Size = 40
    end
    object strngfld_glistobject: TStringField
      FieldName = 'object'
    end
    object strngfld_glistaccess_policy: TStringField
      FieldName = 'access_policy'
    end
    object dtmfld_glistcreated_at: TDateTimeField
      FieldName = 'created_at'
    end
    object dxmdt_glistfilename: TWideStringField
      FieldName = 'filename'
      Size = 255
    end
    object strngfld_glistpurpose: TStringField
      FieldName = 'purpose'
    end
    object strngfld_glistmodalItems: TStringField
      FieldName = 'modalItems'
      Size = 120
    end
  end
  object dsGList: TDataSource
    DataSet = dxmdt_glist
    Left = 200
    Top = 152
  end
  object actlst_GList: TActionList
    Left = 272
    Top = 112
    object act_delete: TAction
      Caption = 'Delete'
      OnExecute = act_deleteExecute
      OnUpdate = act_deleteUpdate
    end
  end
end
