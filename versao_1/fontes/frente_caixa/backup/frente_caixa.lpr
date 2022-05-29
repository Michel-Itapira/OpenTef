program frente_caixa;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, datetimectrls, uprincipal, utestepinpad, rxnew, umenuvenda, Unit1, indylaz, def;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TF_Principal, F_Principal);
  Application.CreateForm(TFTestePinPad, F_TestePinPad);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

