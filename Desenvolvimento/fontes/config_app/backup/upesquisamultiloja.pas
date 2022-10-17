unit upesquisamultiloja;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, DBGrids,
  Buttons, StdCtrls, MaskEdit, rxmemds;

type

  { TFPesquisaMultiLoja }

  TFPesquisaMultiLoja = class(TForm)
    BCarregar: TBitBtn;
    BPesquisar: TBitBtn;
    BSair: TBitBtn;
    CKPessoa: TCheckBox;
    DSPesquisaMultiLoja: TDataSource;
    ECodigo: TEdit;
    EDoc: TMaskEdit;
    ERazao: TEdit;
    Grid: TDBGrid;
    LCodigo: TLabel;
    LDoc: TLabel;
    LPesquisaTags: TLabel;
    LRazao: TLabel;
    MDPesquisaMultiLoja: TRxMemoryData;
    pnlTopo: TPanel;
    procedure BCarregarClick(Sender: TObject);
    procedure BPesquisarClick(Sender: TObject);
    procedure BSairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
      procedure LimpaTela;
  public
      F_Tabela: string;
      F_Carregado: boolean;

  end;

var
  FPesquisaMultiLoja: TFPesquisaMultiLoja;

implementation

{$R *.lfm}

{ TFPesquisaMultiLoja }

procedure TFPesquisaMultiLoja.FormShow(Sender: TObject);
begin
  LimpaTela;
  F_Carregado := False;
end;

procedure TFPesquisaMultiLoja.BCarregarClick(Sender: TObject);
begin
  F_Carregado := True;
  Close;
end;

procedure TFPesquisaMultiLoja.BPesquisarClick(Sender: TObject);
var
    VL_Filtro: string;
begin
    VL_Filtro := '';
    if MDPesquisaMultiLoja.Active then
        MDPesquisaMultiLoja.EmptyTable;

    StrToRxMemData(F_Tabela, MDPesquisaMultiLoja);
    MDPesquisaMultiLoja.Open;

    if Length(ECodigo.Text) > 0 then
        if VL_Filtro = '' then
            VL_Filtro := 'ID=' + ECodigo.Text
        else
            VL_Filtro := VL_Filtro + ' AND ID=' + ECodigo.Text;

    if Length(EDoc.Text) > 0 then
        if VL_Filtro = '' then
            VL_Filtro := 'DOC=(''*' + EDoc.Text + '*'')'
        else
            VL_Filtro := VL_Filtro + ' AND DOC=(''*' + EDoc.Text + '*'')';

    if Length(ERazao.Text) > 0 then
        if VL_Filtro = '' then
            VL_Filtro := 'RAZAO=(''*' + ERazao.Text + '*'') OR FANTASIA=(''*'+ ERazao.TEXT +'*'')'
        else
            VL_Filtro := VL_Filtro + ' AND RAZAO=(''*' + ERazao.Text + '*'') OR FANTASIA=(''*'+ ERazao.TEXT +'*'')';

    MDPesquisaMultiLoja.Filter:=VL_Filtro;
    MDPesquisaMultiLoja.Filtered:=TRUE;;

end;

procedure TFPesquisaMultiLoja.BSairClick(Sender: TObject);
begin
  close;
end;

procedure TFPesquisaMultiLoja.LimpaTela;
begin
  ECodigo.Text := '';
  EDoc.Text := '';
  ERazao.Text := '';
  CKPessoa.Checked := False;
  if MDPesquisaMultiLoja.Active then
      MDPesquisaMultiLoja.EmptyTable;
end;

end.

