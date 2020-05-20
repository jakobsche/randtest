unit RndEdFrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons, StdCtrls;

type

  { TRandomEditForm }

  TRandomEditForm = class(TForm)
    BitBtn1: TBitBtn;
    SampleCountEdit: TEdit;
    ChartUpdateCheckBox: TCheckBox;
    CaseCountEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure CaseCountEditChange(Sender: TObject);
    procedure Label1Click(Sender: TObject);
  private

  public

  end;

var
  RandomEditForm: TRandomEditForm;

implementation

{$R *.lfm}

{ TRandomEditForm }

procedure TRandomEditForm.Label1Click(Sender: TObject);
begin

end;

procedure TRandomEditForm.CaseCountEditChange(Sender: TObject);
begin

end;

end.

