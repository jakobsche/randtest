unit Unit1;


{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ActnList,
  Menus, StdActns, TAGraph, TASeries, TASources;

type

  { TForm1 }

  TForm1 = class(TForm)
    FileExitAction: TFileExit;
    FileSaveAsAction: TFileSaveAs;
    MainMenu1: TMainMenu;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    RandomEditItem: TMenuItem;
    RandomEditAction: TAction;
    ActionList1: TActionList;
    Chart1: TChart;
    Chart1LineSeries1: TLineSeries;
    Panel1: TPanel;
    procedure FileSaveAsActionAccept(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RandomEditActionExecute(Sender: TObject);
  private

  public
    Calculating: Boolean;
    NumberCount: int64;
    Sample, SampleCount: Integer;
    Source: TListChartSource;
    procedure CalcChart;
    function IndexOf(x: Double): Integer;
    procedure UpdateChart;
  end;

var
  Form1: TForm1;

implementation

uses FormEx, RndEdFrm, StatForm;

{$R *.lfm}

{ TForm1 }

procedure TForm1.CalcChart;
var
  i, n: int64;
  x: Extended;
begin
  if Calculating then Exit;
  Calculating := True;
  Chart1LineSeries1.BeginUpdate;
  Source.Clear;
  Randomize;
  if not Assigned(StatusForm) then StatusForm := TStatusForm.Create(Self);
  StatusForm.Show;
  if NumberCount > 0 then begin
    for i := 0 to NumberCount - 1 do Source.Add(i, 0);
    for i := 1 to SampleCount do begin
      Sample := i;
      n := Random(NumberCount);
      Source.Item[n]^.Y := Source.Item[n]^.Y + 1;
      if i mod 1000 = 0 then begin
        {StatusForm.Label1.Caption := Format('%:7.3f %% fertig', [i / SampleCount * 100]);}
        Application.ProcessMessages;
        if not Calculating then Break;
      end;
    end;
    {for i := NumberCount - 1 downto 0 do
      if Source.Item[i]^.Y = 0 then Source.Delete(i);}
    Panel1.Caption := Format('Häufigkeit der ganzen Zufallszahlen 0 bis %d in %d Versuchen', [NumberCount - 1, SampleCount]);
    Chart1.Title.Text.Text := Panel1.Caption;
  end
  else begin
    for i := 1 to SampleCount do begin
      Sample := i;
      x := Random;
      {ShowMessage('Index finden');}
      n := IndexOf(x);
      {ShowMessageFmt('Index %d aktueisieren oder erstellen', [n]);}
      if n >= 0 then Source.Item[n]^.Y := Source.Item[n]^.Y + 1
      else Source.Add(x, 1);
      if Sample mod 1000 = 0 then begin
        {StatusForm.Label1.Caption := Format('%:7.3f %% fertig', [i / SampleCount * 100]);}
        Application.ProcessMessages;
        if not Calculating then Break
      end;
    end;
    Panel1.Caption := Format('Häufigkeit der gebrochenen Zufallszahlen in [0, 1) nach %d Versuchen', [SampleCount]);
    Chart1.Title.Text.Text := Panel1.Caption;
  end;
  for i := 0 to Source.Count - 1 do begin
    Source.Item[i]^.Y := Source.Item[i]^.Y / SampleCount
  end;
  StatusForm.Close;
  Chart1LineSeries1.EndUpdate;
  Calculating := False
end;

function TForm1.IndexOf(x: Double): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Source.Count - 1 do
    if x = Source.Item[i]^.X then begin
      Result := i;
      Exit
    end
    else if x > Source.Item[i]^.X then Exit;
end;

procedure TForm1.UpdateChart;
var
  a, b, c: Double;
  i: Integer;
begin
  Chart1LineSeries1.BeginUpdate;
  if Source.Count > 0 then
    with Chart1.LeftAxis.Range do begin
      if Source.Count = 1 then begin
        a := Source.Item[0]^.Y * 0.9;
        b := Source.Item[0]^.Y * 1.1;
      end
      else begin
        a := Source.Item[0]^.Y;
        b := Source.Item[1]^.Y;
        if a > b then begin
          c := a; a := b; b := c
        end;
        for i := 2 to Source.Count - 1 do
          if a > Source.Item[i]^.Y then a := Source.Item[i]^.Y
          else if b < Source.Item[i]^.Y then b := Source.Item[i]^.Y
      end;
      if a = b then begin
        Min := a * 0.9;
        Max := b * 1.1;
      end
      else begin
        Min := a;
        Max := b
      end;
      UseMin := True;
      UseMax := True;
      {ShowMessageFmt('[%g, %g]', [Min, Max])}
    end;
  Chart1LineSeries1.EndUpdate;
  Calculating := False;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Source := TListChartSource(Chart1LineSeries1.Source);
  Source.Sorted := True;
  NumberCount := 0;
  SampleCount := 100000;
  Show;
  CalcChart;
  {ShowMessage('Serie berechnet');}
  UpdateChart;
  FormAdjust(Self);
end;

procedure TForm1.FileSaveAsActionAccept(Sender: TObject);
begin
  Chart1.SaveToBitmapFile(FileSaveAsAction.Dialog.FileName);
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Calculating := False
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin

end;

procedure TForm1.RandomEditActionExecute(Sender: TObject);
begin
  with RandomEditForm do begin
    SampleCountEdit.Text:= IntToStr(SampleCount);
    CaseCountEdit.Text := IntToStr(NumberCount);
    ChartUpdateCheckBox.Checked := False;
    case ShowModal of
      mrOK: begin
          Application.ProcessMessages;
          SampleCount := StrToInt(SampleCountEdit.Text);
          NumberCount := StrToInt(CaseCountEdit.Text);
          CalcChart;
          if ChartUpdateCheckBox.Checked then UpdateChart;
        end;
    end;
  end;
end;

end.

