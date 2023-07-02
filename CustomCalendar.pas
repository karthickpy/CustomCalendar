{*
 2023-07-01 - Karthick
              Created the initial version of Custom Calendar.
              The custom Calendar will display the values based on the caller's input
              The caller (CustomCalendarExam.pas) will pass the parameters such
              as 1. Display Buttons 2.Display label.
              The Delphi's inbuilt function is used to calculate the month's data

              Abbrevations:
               1. idx = Index
               2. rec = Record


*}




unit CustomCalendar;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls, Dateutils,
  Vcl.ExtCtrls;

type
  TMonthData = Record
    CalendarDate  : TDate;
    CalendarMonth : Integer;
    CalendarYear  : Integer;
    FirstDayIndex : Word;
    LastDayOfMonth : TDate;
    LastDay        : Integer;
  end;

  TfrmMain = class(TForm)
    sgdCalendar: TStringGrid;
    btnPrevMonth: TButton;
    btnNextMonth: TButton;
    lblToday: TLabel;
    procedure sgdCalendarDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure btnNextMonthClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lblTodayClick(Sender: TObject);
  private
    { Private declarations }
    Procedure CreateColHeaderValues;
    procedure GenerateCalendarMonthData(var recMonthData : TMonthData);
    procedure GetCalendarMonthDataAndPopulate(reqdDate : TDate);
  public
    { Public declarations }
    CallerFrom : TForm;                    //Populated in Caller form
    AllowButtonsDisplay : Boolean;         //Populated in Caller form
    HighlighterSunday: TColor;             //Populated in Caller form
    HighlighterSaturday : TColor;          //Populated in Caller form
    procedure InitializeCalendarGrid;
    procedure InitializeMonthDataRecord(Var recMonthdata : TMonthData);
    function GetTodaysDate : Integer;
  end;

var
  frmMain: TfrmMain;

const
   GRID_ROW_COUNT = 7;
   GRID_COL_COUNT = 7;

implementation

{$R *.dfm}


procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if NOT(CallerFrom = Nil) then
     CallerFrom.Show;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
   Self.Height := 280;
   HighlighterSunday := clWhite ;
   HighlighterSaturday := clwhite;
   sgdCalendar.HelpKeyword := FormatDateTime('yyyymmdd', Now());
end;

procedure TfrmMain.FormShow(Sender: TObject);
var
  DtCurrDate : String;
begin
  DtCurrDate :=  Format('%s/%s', [FormatDateTime('yyyy', Now()), FormatDateTime('mm', Now())]);
  Self.Caption := 'Calendar - '+ DtCurrDate;
  if NOT (AllowButtonsDisplay) then begin
    btnNextMonth.Visible := False;
    btnPrevMonth.Visible := False;
    lblToday.Visible := False;
  end else begin
    btnNextMonth.Visible := True;
    btnPrevMonth.Visible := True;
    lblToday.Visible := True;
  end;
  Self.GetCalendarMonthDataAndPopulate(EncodeDate(Yearof(Now), MonthOf(Now), 1));
end;

//Btn "Next Month" and "Previous Month" share the same buttonClick event
procedure TfrmMain.btnNextMonthClick(Sender: TObject);
var
  iMonth, iYear, iDay : Integer;
  sDate : String;
  dtNextmonth : TDate;
begin

  //The date is stored in the StringGrid Tag property in the format "yyyymmmdd"
  sDate  := IntToStr(sgdCalendar.Tag);         //Example Date = 20230701
  iDay   := 01; //StrToInt(Copy(sDate, 7 ,2));       //Date[7,2] =  01
  iMonth := StrToInt(Copy(sDate, 5 ,2));       //Date[5,2] =  07
  iYear  := StrToInt(Copy(SDate, 0, 4));       //Date[0,2] =  2023

  //Increment(Next Month) or Decrement(Previous Month) based on the caller
  if (Sender as TButton).Name = 'btnPrevMonth'	 then
      dtNextmonth := IncMonth(EncodeDate(iYear, iMonth, iDay), -1) //Decrement
  else
      dtNextmonth := IncMonth(EncodeDate(iYear, iMonth, iDay), 1); //Increment

  //Once the date is identified, Populate the date of the Months in the grid.
  Self.GetCalendarMonthDataAndPopulate(dtNextmonth)
end;

//Popuate the Headers(Day-Names) in the Stringgrid
procedure TfrmMain.CreateColHeaderValues;
const
  arDays :array[1..7] of string = ('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat');
var
  idx : integer;
begin
  for idx  := Low(arDays) to High(arDays) do
      sgdCalendar.Cells[idx-1, 0] := arDays[idx];
  sgdCalendar.DefaultColAlignment	 := taCenter;  //Align the Column values to center
end;

//Identify the Month's Attributes
procedure TfrmMain.GenerateCalendarMonthData(var recMonthData: TMonthData);
begin
  recMonthData.CalendarMonth   := MonthOf(recMonthData.CalendarDate);       //Identify the Year of the  Date
  recMonthData.CalendarYear    := YearOf(recMonthData.CalendarDate);        //Identify the Month of the Date
  recMonthData.FirstDayIndex   := DayOfWeek(recMonthData.CalendarDate) ;    //Identify the Index of the Date in the Firstweek
  recMonthData.LastDayOfMonth  := EndOfTheMonth(recMonthData.CalendarDate); //Identify the LastDate of the Month
  recMonthData.LastDay         := DayOf(recMonthData.LastDayOfMonth );      //Identify the Last day of the Month
end;

//Identify the Month's Data and Populate in the grid
procedure TfrmMain.GetCalendarMonthDataAndPopulate(reqdDate : TDate);
var
  idxRow, idxCol, DateVal : Integer;
  DtCurrDate : String;
  recMonthData : TMonthData ;
begin
  DtCurrDate :=  Format('%s/%s', [FormatDateTime('yyyy', reqdDate), FormatDateTime('mm', reqdDate)]);
  frmMain.Caption := 'Calendar - '+ DtCurrDate;
  sgdCalendar.Tag := StrToint(FormatdateTime('yyyymmdd', reqdDate));

  Self.InitializeMonthDataRecord(recMonthData);  //Initialize the Record before Populating the values
  recMonthData.CalendarDate := reqdDate;

  Self.GenerateCalendarMonthData(recMonthData); //Identify the Month's attributes(StartDay, EndDate etc.,)
  Self.CreateColHeaderValues;   //Populate the Headers - days
  Self.InitializeCalendarGrid;  //Clear all the Grid values to empty

  {*Since the Row and Col flowing is not linear or Continous and it is split.
   So, a running number (DateVal) is incremented manually. *}
  DateVal := 0 ;

  With recMonthData do begin
     for idxRow := 1 to GRID_ROW_COUNT do begin
         if (DateVal = -1) then break;       //break - idxRow Loop
       for idxCol := 1 to GRID_COL_COUNT do begin
          if (idxRow = 1) and (idxCol <  recMonthData.FirstDayIndex)	 then begin
              sgdCalendar.Cells[idxcol, idxRow] := '';
              Continue;
          end else if (idxCol = recMonthData.FirstDayIndex)	and (idxRow = 1) then begin
              DateVal := DateVal + 1;
              sgdCalendar.Cells[idxCol-1, idxRow] :=  IntToStr(DateVal);
          end else if DateVal = recMonthData.LastDay-1	 then begin
               DateVal := DateVal + 1;
               sgdCalendar.Cells[idxCol-1, idxRow] :=  IntToStr(DateVal);
               DateVal := -1;
               break;
          end else begin
               DateVal := DateVal + 1;
               sgdCalendar.Cells[idxCol-1, idxRow] :=  IntToStr(DateVal);
          end;  //End - if Loop
       end; //End for loop = idxCol
     end;  //End forLoop = idxRow
  end; //End with Statement
end;

//To Identify the today's date stored in the SgdCalendar HelpKeyword property
function TfrmMain.GetTodaysDate: Integer;
var
  iMonthCurr, iYearCurr, iDayCurr : Integer;
  iMonth, iYear : Integer;
  sDate : String;
begin
  result := -1;
  //Today's date is stored in the StringGrid HelpKeyword property in the format "yyyymmmdd"
  sDate  := (sgdCalendar.HelpKeyword);         //Example Date = 20230701
  iDayCurr   := StrToInt(Copy(sDate, 7 ,2));       //Date[7,2] =  01
  iMonthCurr := StrToInt(Copy(sDate, 5 ,2));       //Date[5,2] =  07
  iYearCurr  := StrToInt(Copy(SDate, 0, 4));       //Date[0,2] =  2023

  sDate  := IntToStr(sgdCalendar.Tag);         //Example Date = 20230701
  iMonth := StrToInt(Copy(sDate, 5 ,2));       //Date[5,2] =  07
  iYear  := StrToInt(Copy(SDate, 0, 4));       //Date[0,2] =  2023

  if (iMonthCurr = iMonth) and (iYearCurr = iYear) then begin
    result := iDayCurr;
  end;
end;


//Clear the Values in the String Grid (sgdCalendar)
procedure TfrmMain.InitializeCalendarGrid;
var
  idxRow, idxCol : Integer;
begin
   for idxCol  := 0 to (GRID_COL_COUNT	-1) do begin
     for idxRow := 1 to (GRID_ROW_COUNT-1) do begin
        sgdCalendar.Cells[idxCol, idxRow] := '';
     end; //idxRow Loop End
   end; //idxCol Loop End
end;

//Initialize the Month Data record
procedure TfrmMain.InitializeMonthDataRecord(var recMonthdata: TMonthData);
begin
  with recMonthdata do begin
    CalendarDate := 01/01/1900 ;
    CalendarMonth := 0;
    LastDayOfMonth := 01/01/1900;
    FirstDayIndex  := 0;
    LastDay        := 0;
  end;
end;

//This function is to get the Todays date stored in SgdCalendar - HelpKeyword property
procedure TfrmMain.lblTodayClick(Sender: TObject);
var
  iMonthCurr, iYearCurr, iDayCurr : Integer;
  sDate : String;
  dtCurrmonth : TDate;
begin
  //The date is stored in the StringGrid HelpKeyword property in the format "yyyymmmdd"
  sDate  := (sgdCalendar.HelpKeyword);         //Example Date = 20230701
  iDayCurr   :=  01; //StrToInt(Copy(sDate, 7 ,2));       //Date[7,2] =  01
  iMonthCurr := StrToInt(Copy(sDate, 5 ,2));       //Date[5,2] =  07
  iYearCurr  := StrToInt(Copy(SDate, 0, 4));       //Date[0,2] =  2023
  dtCurrmonth := EncodeDate(iYearCurr, iMonthCurr, iDayCurr);

  Self.GetCalendarMonthDataAndPopulate(dtCurrmonth);
end;

//This  inbuilt event of string grid is used to highlight color and font.
procedure TfrmMain.sgdCalendarDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
CONST
  IDX_COL_NO_SAT = 6;
  IDX_COL_NO_SUN = 0;
var
  LStrCell : String;
  idxLeft, iTodaysDate : Integer;
begin
  iTodaysDate := GetTodaysDate ;
  with (Sender as TStringGrid) do
  begin
    // Col No 0 = Sundays and Col no 6 = Saturdays
    if (ARow = 0) and (ACol <> 0) and (Acol <> 6) then  begin
      Canvas.Brush.Color := ClWhite;
      CanVas.font.Color := clBlack;
      Canvas.FrameRect(Rect);
      Canvas.Font.Style := [TFontStyle.fsBold];
      Canvas.TextRect(Rect, Rect.Left + 10, Rect.Top + 5, sgdCalendar.cells[acol, arow]);
    end else
    begin
      case Acol of
        IDX_COL_NO_SUN	:
        begin
          Canvas.Font.Color := clRed;
          Canvas.brush.Color := HighlighterSunday	;
          if (ARow = 0) then
             Canvas.Brush.Color := clwhite;
        end;
        IDX_COL_NO_SAT	:
          begin
          Canvas.Font.Color := clBlue;
          Canvas.Brush.Color := highlighterSaturday;
          if (ARow = 0) then
             Canvas.Brush.Color := ClWhite;
          end;
      end;  //end CASE statement
      // Draw the Band
      Rect.Left  := Rect.Left + 2;
      Rect.Top   := Rect.Top ;
      LStrCell  := sgdCalendar.Cells[ACol, ARow]  ;
      if Length(LStrCell) = 1 then
        idxLeft := 13
      else
        idxLeft := 10;
      if (LStrcell <> '') then  begin
      //  Canvas.Font.Color := clBlack;
        if (ACol <> 6) AND (ACol <> 0)AND (Arow > 0)  then
          Canvas.Font.Color := clBlack;
        if ((Arow > 0) AND (LStrCell <>  IntToStr(-1))	and (LStrCell	= IntToStr(iTodaysDate))) then
          Canvas.Brush.Color := clLime;
        Canvas.Font.Style := [TFontStyle.fsBold];
        Canvas.FrameRect(Rect);
        Canvas.TextRect(Rect, Rect.Left + idxLeft, Rect.Top+ 5, cells[acol, arow]);
      end else begin
        Canvas.Brush.Color := clwhite;
        Canvas.FrameRect(Rect);
        Canvas.Font.Color := clBlack;
      end;
    end; //end - WITH Sender statement
  end;
  sgdCalendar.Col := 0;             //Focus the Grid Cell = (0, 0) after populating the data
  sgdCalendar.Row := 0;             //Focus the Grid Cell = (0, 0) after populating the data
end;

end.
