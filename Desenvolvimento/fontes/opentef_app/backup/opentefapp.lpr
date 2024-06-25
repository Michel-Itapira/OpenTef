program opentefapp;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, app, opentefnucleo, rxnew, zcomponent,
  indylaz, comunicador, funcoes, cadastro, def, bancodados, uvbi;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TFApp, FApp);
  Application.Run;
end.

