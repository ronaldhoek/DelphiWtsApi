object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'WtsApi test'
  ClientHeight = 311
  ClientWidth = 234
  Color = clBtnFace
  Constraints.MinHeight = 350
  Constraints.MinWidth = 250
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  DesignSize = (
    234
    311)
  PixelsPerInch = 96
  TextHeight = 13
  object lblServername: TLabel
    Left = 8
    Top = 8
    Width = 61
    Height = 13
    Caption = 'Server name'
  end
  object lblSessions: TLabel
    Left = 8
    Top = 51
    Width = 41
    Height = 13
    Caption = 'Sessions'
  end
  object btnGetSessions: TButton
    Left = 151
    Top = 24
    Width = 75
    Height = 21
    Anchors = [akTop, akRight]
    Caption = 'Get sessions'
    TabOrder = 0
    OnClick = btnGetSessionsClick
    ExplicitLeft = 214
  end
  object edtServerName: TEdit
    Left = 8
    Top = 24
    Width = 121
    Height = 21
    TabOrder = 1
    OnChange = edtServerNameChange
  end
  object lvSessions: TListView
    Left = 8
    Top = 67
    Width = 218
    Height = 105
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = 'Id'
      end
      item
        AutoSize = True
        Caption = 'Info'
      end
      item
        Caption = 'Status'
        Width = 100
      end>
    HotTrack = True
    HotTrackStyles = [htUnderlineHot]
    ReadOnly = True
    RowSelect = True
    TabOrder = 2
    ViewStyle = vsReport
    OnChange = lvSessionsChange
    ExplicitWidth = 259
    ExplicitHeight = 389
  end
  object lbSessionInfo: TListBox
    Left = 8
    Top = 178
    Width = 218
    Height = 108
    Anchors = [akLeft, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 3
    ExplicitTop = 212
    ExplicitWidth = 259
  end
  object stsMain: TStatusBar
    Left = 0
    Top = 292
    Width = 234
    Height = 19
    Panels = <>
    SimplePanel = True
    SimpleText = '<refresh not active>'
    ExplicitLeft = 144
    ExplicitTop = 184
    ExplicitWidth = 0
  end
  object tmrRefresh: TTimer
    Enabled = False
    OnTimer = tmrRefreshTimer
    Left = 120
    Top = 152
  end
end
