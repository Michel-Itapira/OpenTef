program frenteCaixa;

uses
  Vcl.Forms,
  uprincipal in 'uprincipal.pas' {FPrincipal},
  umenu_venda in 'umenu_venda.pas' {F_MenuVenda},
  uimpressao in 'uimpressao.pas' {FImpressao};

{$R *.res}
begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFPrincipal, F_Principal);
  Application.Run;
end.
