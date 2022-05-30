program config_app;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, memdslaz, uPrincipal, rxnew, zcomponent, indylaz,funcoes, comunicador, uPesquisaTags, uPesquisaadquirentes, def, uPesquisamoduloconf, com;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(Tfprincipal, f_principal);
  Application.Run;
end.

