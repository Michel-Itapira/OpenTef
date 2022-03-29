unit app;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,opentefnucleo;

type

  { TFApp }

  TFApp = class(TForm)
    BIniciar: TButton;
    Button1: TButton;
    procedure BIniciarClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  FApp: TFApp;

implementation

{$R *.lfm}

{ TFApp }

procedure TFApp.BIniciarClick(Sender: TObject);
begin
   DNucleo:=TDNucleo.Create(Self);
   DNucleo.iniciar;
end;


end.

