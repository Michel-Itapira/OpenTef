program config_app;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}
  cthreads,
      {$ENDIF} {$IFDEF HASAMIGA}
  athreads,
      {$ENDIF}
    Interfaces, // this includes the LCL widgetset
    Forms,
    memdslaz,
    uPrincipal,
    rxnew,
    zcomponent,
    indylaz,
    uPesquisaTags,
    uPesquisaadquirentes,
    def,
    uPesquisamoduloconf,
    funcoes,
    uconfigopentef,
    uinterface,
    ulogin,
    ucadloja,
    upesquisaloja,
    ucadpdv,
    upesquisapdv,
    ucadpinpad,
    upesquisapinpad,
    ucadadquirente,
    ucadmultloja,
    upesquisamultiloja,
    ucadmodulo, upesquisamodulo, umoduloconfig, com;

{$R *.res}
begin
  Application.Scaled:=True;
    Application.Initialize;
    Application.CreateForm(TFInterface, FInterface);
    //    Application.CreateForm(Tfprincipal, F_Principal);
    Application.Run;
end.
