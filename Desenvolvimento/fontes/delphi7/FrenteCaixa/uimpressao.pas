unit uimpressao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFImpressao = class(TForm)
    MImpressao: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FImpressao: TFImpressao;

implementation

{$R *.dfm}

end.
