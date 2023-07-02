program POC_CustomCalendar;

uses
  Vcl.Forms,
  CustomCalendar in 'CustomCalendar.pas' {frmMain},
  CustomCalendarExam in 'CustomCalendarExam.pas' {frmMainSimple};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMainSimple, frmMainSimple);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
