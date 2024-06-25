unit umenu_venda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TMButton = Class(TButton)
  public
    V_Tag:string;
  end;

  TF_MenuVenda = Class(TForm)
    PImagem: TPanel;
    Imagem: TImage;
    PBotao: TPanel;
    PDados: TPanel;
    EDados: TEdit;
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
