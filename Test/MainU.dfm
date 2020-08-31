object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'WtsApi test'
  ClientHeight = 339
  ClientWidth = 275
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    275
    339)
  PixelsPerInch = 96
  TextHeight = 13
  object lblServername: TLabel
    Left = 8
    Top = 8
    Width = 61
    Height = 13
    Caption = 'Server name'
  end
  object Sessions: TLabel
    Left = 8
    Top = 51
    Width = 41
    Height = 13
    Caption = 'Sessions'
  end
  object btnGetSessions: TButton
    Left = 192
    Top = 24
    Width = 75
    Height = 21
    Caption = 'Get sessions'
    TabOrder = 0
    OnClick = btnGetSessionsClick
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
    Width = 259
    Height = 150
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
    ExplicitHeight = 110
  end
  object lbSessionInfo: TListBox
    Left = 8
    Top = 223
    Width = 259
    Height = 108
    Anchors = [akLeft, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 3
    ExplicitTop = 183
  end
end
