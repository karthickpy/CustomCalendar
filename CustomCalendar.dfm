object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'frmMain'
  ClientHeight = 242
  ClientWidth = 317
  Color = clBtnFace
  Constraints.MaxHeight = 280
  Constraints.MaxWidth = 360
  Constraints.MinHeight = 270
  Constraints.MinWidth = 310
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object lblToday: TLabel
    Left = 258
    Top = 208
    Width = 35
    Height = 17
    Cursor = crHandPoint
    Caption = 'Today'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    OnClick = lblTodayClick
  end
  object sgdCalendar: TStringGrid
    Left = 10
    Top = 9
    Width = 290
    Height = 180
    ColCount = 7
    DefaultColWidth = 40
    DefaultColAlignment = taCenter
    FixedColor = 9412337
    FixedCols = 0
    RowCount = 7
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goFixedRowDefAlign]
    ParentFont = False
    ScrollBars = ssNone
    TabOrder = 0
    OnDrawCell = sgdCalendarDrawCell
  end
  object btnPrevMonth: TButton
    Left = 11
    Top = 204
    Width = 100
    Height = 25
    Caption = 'Previous Month'
    TabOrder = 1
    OnClick = btnNextMonthClick
  end
  object btnNextMonth: TButton
    Left = 124
    Top = 204
    Width = 100
    Height = 25
    Caption = 'Next Month'
    TabOrder = 2
    OnClick = btnNextMonthClick
  end
end
