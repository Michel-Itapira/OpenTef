unit umenuvenda;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

    TMButton = class(TButton)
    public
        V_Tag: string;
    end;

    { TFMenuVenda }

    TFMenuVenda = class(TForm)
        EDados: TEdit;
        Imagem: TImage;
        LMensagem: TLabel;
        PBotao: TPanel;
        PDados: TGroupBox;
        PImagem: TPanel;
        PMensagem: TPanel;
    private

    public
        V_Mensagem: Pointer;
        V_Botao: string;
    end;

var
    FMenuVenda: TFMenuVenda;

implementation

{$R *.lfm}

end.
