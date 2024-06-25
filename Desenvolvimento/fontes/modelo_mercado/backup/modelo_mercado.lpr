program modelo_mercado;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  uinterface,
  rxnew,
  uprodutos,
  uopentef,
  umenuvenda,
  uimpressao
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TFInterface, FInterface);
  Application.CreateForm(TFMenuVenda, FMenuVenda);
  Application.CreateForm(TFImpressao, FImpressao);
  Application.Run;
end.

