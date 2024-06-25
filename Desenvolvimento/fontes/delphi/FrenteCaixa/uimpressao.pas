unit uimpressao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

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
