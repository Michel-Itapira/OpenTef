unit umenuvenda;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TF_MenuVenda }

  TMButton = Class(TButton)
    public
    V_Tag:string;
  end;


  TF_MenuVenda = class(TForm)
    EDados: TEdit;
    PDados: TGroupBox;
    Imagem: TImage;
    LMensagem: TLabel;
    PBotao: TPanel;
    PMensagem: TPanel;
    PImagem: TPanel;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private

  public
   V_Mensagem:Pointer;
   V_Botao:string;
  end;


var
  F_MenuVenda: TF_MenuVenda;

implementation

{$R *.lfm}

{ TF_MenuVenda }


procedure TF_MenuVenda.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

end;

end.

