unit CustomCalendarExam;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, CustomCalendar, Vcl.StdCtrls,
  Vcl.ExtCtrls, VCLTee.TeCanvas;

type
  TfrmMainSimple = class(TForm)
    pnlBody: TPanel;
    btnDisplay: TButton;
    btnCalendarDisplayColored: TButton;

    procedure btnDisplayClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMainSimple: TfrmMainSimple;

implementation


{$R *.dfm}


procedure TfrmMainSimple.btnDisplayClick(Sender: TObject);
begin
  frmMainSimple.Hide;
  frmMain.CallerFrom := frmMainSimple;
  if (sender as TButton).Name = 'btnDisplay' then begin
    frmMain.AllowButtonsDisplay := True ;
    frmMain.HighlighterSunday := clWhite;
    frmMain.HighlighterSaturday := clWhite;
    frmMain.Height := 280;
  end else begin
    frmMain.AllowButtonsDisplay := False ;
    frmMain.HighlighterSunday := $008F9EF1;
    frmMain.HighlighterSaturday := clAqua;
    frmMain.Height := 240;
  end;
  frmMain.Show;
end;

end.
