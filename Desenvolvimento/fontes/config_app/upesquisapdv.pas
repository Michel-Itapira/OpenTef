unit upesquisapdv;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, funcoes, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, DBGrids, rxmemds;

type

  { TFPesquisaPdv }

  TFPesquisaPdv = class(TForm)
    BCarregar: TBitBtn;
    BPesquisar: TBitBtn;
    BSair: TBitBtn;
    DSPesquisaPdv: TDataSource;
    ERazao: TEdit;
    EID: TEdit;
    EDescricao: TEdit;
    EIdentificacao: TEdit;
    Grid: TDBGrid;
    LRazao: TLabel;
    LID: TLabel;
    LDescricao: TLabel;
    LIdentificacao: TLabel;
    LPesquisaPdv: TLabel;
    MDPesquisaPdv: TRxMemoryData;
    Panel1: TPanel;
    PnlBase: TPanel;
    procedure BCarregarClick(Sender: TObject);
    procedure BPesquisarClick(Sender: TObject);
    procedure BSairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MDPesquisaPdvFilterRecord(DataSet: TDataSet; var Accept: Boolean);
  private
    procedure LimpaTela;
public
    F_Tabela: string;
    F_Carregado: boolean;
    F_LojaID : integer;
  end;

var
  FPesquisaPdv: TFPesquisaPdv;

implementation

{$R *.lfm}

{ TFPesquisaPdv }

procedure TFPesquisaPdv.BSairClick(Sender: TObject);
begin
  close;
end;

procedure TFPesquisaPdv.FormShow(Sender: TObject);
begin
  LimpaTela;
  F_Carregado := False;
end;

procedure TFPesquisaPdv.MDPesquisaPdvFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin

end;

procedure TFPesquisaPdv.LimpaTela;
begin
EID.Text:='';
EIdentificacao.Text:='';
EDescricao.Text:='';
end;

procedure TFPesquisaPdv.BCarregarClick(Sender: TObject);
begin
    IF MDPesquisaPdv.RecordCount=0 THEN
    BEGIN
       ShowMessage('Nenhum registro foi pesquisado');
       EXIT;
    end;
  F_Carregado := True;
  Close;
end;

procedure TFPesquisaPdv.BPesquisarClick(Sender: TObject);
var
    VL_Filtro: string;
begin
    if F_LojaID=0 then
    begin
      ShowMessage('Não existe Loja vinculada para a pesquisa');
      exit;
    end;
    VL_Filtro := '';
    if MDPesquisaPdv.Active then
        MDPesquisaPdv.EmptyTable;

    StrToRxMemData(F_Tabela, MDPesquisaPdv);
    MDPesquisaPdv.Open;

    VL_Filtro:='LOJA_ID='+INTTOSTR(F_LojaID);

    if Length(EID.Text) > 0 then
        if VL_Filtro = '' then
            VL_Filtro := 'ID=' + EID.Text
        else
            VL_Filtro := VL_Filtro + ' AND ID=' + EID.Text;

    if Length(EIdentificacao.Text) > 0 then
        if VL_Filtro = '' then
            VL_Filtro := 'IDENTIDICACAO=(''*' + EIdentificacao.Text + '*'')'
        else
            VL_Filtro := VL_Filtro + ' AND IDENTIFICACAO=(''*' + EIdentificacao.Text + '*'')';

    if Length(EDescricao.Text) > 0 then
        if VL_Filtro = '' then
            VL_Filtro := 'DESCRICAO=(''*' + EDescricao.Text + '*'')'
        else
            VL_Filtro := VL_Filtro + ' AND DESCRICAO=(''*' + EDescricao.Text + '*'')';

    MDPesquisaPdv.Filter:=VL_Filtro;
    MDPesquisaPdv.Filtered:=TRUE;

end;

end.

