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
  Forms, memdslaz, uPrincipal, rxnew, zcomponent, indylaz, uPesquisaTags, uPesquisaadquirentes, def, uPesquisamoduloconf, funcoes, uconfigopentef;

{$R *.res}

begin
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(Tfprincipal, f_principal);
  Application.Run;
end.

