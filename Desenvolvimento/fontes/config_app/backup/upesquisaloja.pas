unit upesquisaloja;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, MaskEdit,
    DBGrids, StdCtrls, Buttons, rxmemds, funcoes;

type

    { TFPesquisaLoja }

    TFPesquisaLoja = class(TForm)
        BCarregar: TBitBtn;
        BPesquisar: TBitBtn;
        BSair: TBitBtn;
        CKPessoa: TCheckBox;
        DSPesquisaLoja: TDataSource;
        ERazao: TEdit;
        EDoc: TMaskEdit;
        ECodigo: TEdit;
        LRazao: TLabel;
        LCodigo: TLabel;
        LDoc: TLabel;
        LPesquisaTags: TLabel;
        MDPesquisaLoja: TRxMemoryData;
        pnlBase: TPanel;
        pnlTopo: TPanel;
        Grid: TDBGrid;
        procedure BCarregarClick(Sender: TObject);
        procedure BPesquisarClick(Sender: TObject);
        procedure BSairClick(Sender: TObject);
        procedure CKPessoaClick(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure MDPesquisaLojaFilterRecord(DataSet: TDataSet;
          var Accept: Boolean);
    private
        procedure LimpaTela;
    public
        F_Tabela: string;
        F_Carregado: boolean;
    end;

var
    FPesquisaLoja: TFPesquisaLoja;

implementation

{$R *.lfm}
uses
    ucadloja;

{ TFPesquisaLoja }

procedure TFPesquisaLoja.FormShow(Sender: TObject);
begin
    LimpaTela;
    F_Carregado := False;
end;

procedure TFPesquisaLoja.MDPesquisaLojaFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin

end;

procedure TFPesquisaLoja.BSairClick(Sender: TObject);
begin
    Close;
end;

procedure TFPesquisaLoja.CKPessoaClick(Sender: TObject);
begin
 if CKPessoa.Checked then
    Edoc.EditMask:='999.999.999-99;0;_'
 else
    Edoc.EditMask:=:='99.999.999/9999-99;0;_';
end;

procedure TFPesquisaLoja.BCarregarClick(Sender: TObject);
begin
        IF MDPesquisaLoja.RecordCount=0 THEN
    BEGIN
       ShowMessage('Nenhum registro foi pesquisado');
       EXIT;
    end;
    F_Carregado := True;
    Close;
end;

procedure TFPesquisaLoja.BPesquisarClick(Sender: TObject);
var
    VL_Filtro: string;
begin
    VL_Filtro := '';
    if MDPesquisaLoja.Active then
        MDPesquisaLoja.EmptyTable;

    StrToRxMemData(F_Tabela, MDPesquisaLoja);
    MDPesquisaLoja.Open;

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

    MDPesquisaLoja.Filter:=VL_Filtro;
    MDPesquisaLoja.Filtered:=TRUE;;

end;

procedure TFPesquisaLoja.LimpaTela;
begin
    ECodigo.Text := '';
    EDoc.Text := '';
    ERazao.Text := '';
    CKPessoa.Checked := False;
    if MDPesquisaLoja.Active then
        MDPesquisaLoja.EmptyTable;
end;

end.
