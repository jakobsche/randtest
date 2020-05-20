unit StatForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons;

type

  { TStatusForm }

  TStatusForm = class(TForm)
    BitBtn1: TBitBtn;
    Label1: TLabel;
    Timer1: TTimer;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public

  end;

var
  StatusForm: TStatusForm;

implementation

uses Unit1;

{$R *.lfm}

{ TStatusForm }

procedure TStatusForm.Timer1Timer(Sender: TObject);
begin
  Label1.Caption := Format('%:7.3f %% fertig', [Form1.Sample / Form1.SampleCount * 100]);
end;

procedure TStatusForm.FormShow(Sender: TObject);
begin
  Label1.Caption := 'Warte!';
  Timer1.Enabled := True
end;

procedure TStatusForm.Label1Click(Sender: TObject);
begin

end;

procedure TStatusForm.FormHide(Sender: TObject);
begin
  Timer1.Enabled := False
end;

procedure TStatusForm.BitBtn1Click(Sender: TObject);
begin
  Close
end;

procedure TStatusForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Form1.Calculating := False
end;

initialization

StatusForm := nil;

end.

