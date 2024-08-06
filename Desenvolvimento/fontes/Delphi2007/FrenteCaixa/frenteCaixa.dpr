program frenteCaixa;

uses
  Forms,
  uprincipal in 'uprincipal.pas' {F_Principal},
  umenu_venda in 'umenu_venda.pas' {F_MenuVenda},
  uimpressao in 'uimpressao.pas' {FImpressao};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TF_Principal, F_Principal);
  Application.CreateForm(TF_MenuVenda, F_MenuVenda);
  Application.CreateForm(TFImpressao, FImpressao);
  Application.Run;
end.
