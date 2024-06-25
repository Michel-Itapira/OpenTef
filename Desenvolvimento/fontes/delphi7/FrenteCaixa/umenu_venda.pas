unit umenu_venda;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TMButton = Class(TButton)
  public
    V_Tag:string;
  end;

  TF_MenuVenda = class(TForm)
    PBotao: TPanel;
    PDados: TPanel;
    EDados: TEdit;
    PImagem: TPanel;
    Imagem: TImage;
    PMensagem: TPanel;
    LMensagem: TLabel;
  private

  public
    V_Mensagem: Pointer;
    V_Botao   :string;
  end;

var
  F_MenuVenda: TF_MenuVenda;

implementation

{$R *.dfm}

end.
