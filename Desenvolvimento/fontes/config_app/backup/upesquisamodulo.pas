unit upesquisamodulo;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls,ufuncoes, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls, RxDBGrid, rxmemds;

type

  { TFPesquisaModulo }

  TFPesquisaModulo = class(TForm)
    BCarregar: TBitBtn;
    BPesquisar: TBitBtn;
    BSair: TBitBtn;
    DSModulo: TDataSource;
    EDescricao: TEdit;
    EID: TEdit;
    GridPrincipal: TRxDBGrid;
    LDescricao: TLabel;
    LID: TLabel;
    LPesquisaAdquirente: TLabel;
    MDModulo: TRxMemoryData;
    pnlPrincipal: TPanel;
    pnlBase: TPanel;
    pnlTopo: TPanel;
    procedure BCarregarClick(Sender: TObject);
    procedure BPesquisarClick(Sender: TObject);
    procedure BSairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public
    F_Tabela: string;
    F_Carregado: boolean;
  end;

var
  FPesquisaModulo: TFPesquisaModulo;

implementation

{$R *.lfm}

{ TFPesquisaModulo }

procedure TFPesquisaModulo.FormShow(Sender: TObject);
begin
  EID.Text := '';
  EDescricao.Text := '';
  if MDModulo.Active then
      MDModulo.EmptyTable;
  F_Carregado := False;
end;

procedure TFPesquisaModulo.BSairClick(Sender: TObject);
begin
  close;
end;

procedure TFPesquisaModulo.BCarregarClick(Sender: TObject);
begin
  F_Carregado := True;
  Close;
end;

procedure TFPesquisaModulo.BPesquisarClick(Sender: TObject);
var
    VL_Filtro: string;
begin
    VL_Filtro := '';
    if MDModulo.Active then
        MDModulo.EmptyTable;
    StrToRxMemData(F_Tabela, MDModulo);
    MDModulo.Open;

    if length(EID.Text) > 0 then
        if VL_Filtro = '' then
            VL_Filtro := 'ID=('+ EID.Text + ')'
        else
            VL_Filtro := VL_Filtro + ' and ID=('+ EID.Text + ')';
    if length(EDescricao.Text) > 0 then
        if VL_Filtro = '' then
            VL_Filtro := 'DESCRICAO=(''*' + EDescricao.Text + '*'')'
        else
            VL_Filtro := VL_Filtro + ' and DEESCRICAO=(''*' + EDescricao.Text + '*'')';
    MDModulo.Filter := VL_Filtro;
    MDModulo.Filtered := True;

end;

end.

