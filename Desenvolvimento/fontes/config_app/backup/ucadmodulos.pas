unit ucadmodulos;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, Buttons, ComCtrls, RxDBGrid;

type

  { TFCadModulos }

  TFCadModulos = class(TForm)
    BLocalizaTag: TBitBtn;
    EID: TEdit;
    EDescricao: TEdit;
    ETagModulo: TEdit;
    EPesquisaModulo: TEdit;
    LID: TLabel;
    LDescricao: TLabel;
    LTagModulo: TLabel;
    LPesquisaModulo: TLabel;
    PagePrincipal: TPageControl;
    PnlPesquisaModulo: TPanel;
    PnlPrincipal_Topo: TPanel;
    PnlPesquisa_Topo: TPanel;
    PnlTopo: TPanel;
    PnlPrincipal: TPanel;
    PnlBase: TPanel;
    BAdicionar: TBitBtn;
    BExcluir: TBitBtn;
    BModificar: TBitBtn;
    LTitulo: TLabel;
    GridPesquisaModulo: TRxDBGrid;
    TabConfiguracao: TTabSheet;
    TabFuncao: TTabSheet;
  private

  public

  end;

var
  FCadModulos: TFCadModulos;

implementation

{$R *.lfm}

end.

