object frmMainSimple: TfrmMainSimple
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Examination Questions'
  ClientHeight = 122
  ClientWidth = 288
  Color = clBtnFace
  Constraints.MaxHeight = 180
  Constraints.MaxWidth = 310
  Constraints.MinHeight = 150
  Constraints.MinWidth = 300
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesktopCenter
  TextHeight = 15
  object pnlBody: TPanel
    Left = 0
    Top = 0
    Width = 288
    Height = 122
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 296
    ExplicitHeight = 119
    object btnDisplay: TButton
      Left = 28
      Top = 24
      Width = 241
      Height = 25
      Caption = 'Calendar Display'
      TabOrder = 0
      OnClick = btnDisplayClick
    end
    object btnCalendarDisplayColored: TButton
      Left = 30
      Top = 72
      Width = 239
      Height = 25
      Caption = 'Calendar Display with Colored'
      TabOrder = 1
      OnClick = btnDisplayClick
    end
  end
end
