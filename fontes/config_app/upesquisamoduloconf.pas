unit uPesquisamoduloconf;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs,funcoes, ExtCtrls, StdCtrls, Buttons, RxDBGrid, rxmemds;

type

    { TFModuloConf }

    TFModuloConf = class(TForm)
        BCarregar: TBitBtn;
        BPesquisar: TBitBtn;
        BSair: TBitBtn;
        CKModuloAtivo: TCheckBox;
        DSPesquisaModulo: TDataSource;
        EDescricaoModuloConf: TEdit;
        EDescricaoModulo: TEdit;
        EAdquirente: TEdit;
        LDescricaoModuloConf: TLabel;
        LPesquisaTags: TLabel;
        LDescricaoModulo: TLabel;
        LAdquirente: TLabel;
        pnlTopo: TPanel;
        pnlPrincipal: TPanel;
        pnlBase: TPanel;
        GridPrincipal: TRxDBGrid;
        MDPesquisaModulo: TRxMemoryData;
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
    FModuloConf: TFModuloConf;

implementation

{$R *.lfm}

{ TFModuloConf }

procedure TFModuloConf.BSairClick(Sender: TObject);
begin
    Close;
end;

procedure TFModuloConf.BCarregarClick(Sender: TObject);
begin
    F_Carregado := True;
    Close;
end;

procedure TFModuloConf.BPesquisarClick(Sender: TObject);
var
    VL_Filtro: string;
begin
    VL_Filtro := '';
    if MDPesquisaModulo.Active then
        MDPesquisaModulo.EmptyTable;
    StrToRxMemData(F_Tabela, MDPesquisaModulo);
    MDPesquisaModulo.Open;

    if length(EDescricaoModulo.Text) > 0 then
        if VL_Filtro = '' then
            VL_Filtro := 'MODULO_DESCRICAO=(''*' + EDescricaoModulo.Text + '*'')'
        else
            VL_Filtro := VL_Filtro + ' and MODULO_DESCRICAO=(''*' + EDescricaoModulo.Text + '*'')';

    if length(EDescricaoModuloConf.Text) > 0 then
        if VL_Filtro = '' then
            VL_Filtro := 'MODULO_CONF_DESCRICAO=(''*' + EDescricaoModuloConf.Text + '*'')'
        else
            VL_Filtro := VL_Filtro + ' and MODULO_CONF_DESCRICAO=(''*' + EDescricaoModuloConf.Text + '*'')';

    if length(EAdquirente.Text) > 0 then
        if VL_Filtro = '' then
            VL_Filtro := 'ADQUIRENTE_DESCRICAO=(''*' + EAdquirente.Text + '*'')'
        else
            VL_Filtro := VL_Filtro + ' and ADQUIRENTE_DESCRICAO=(''*' + EAdquirente.Text + '*'')';

    if CKModuloAtivo.Checked then
        if VL_Filtro = '' then
            VL_Filtro := 'HABILITADO=''T'''
        else
            VL_Filtro := VL_Filtro + ' and HABILITADO=''T''';

    MDPesquisaModulo.Filter := VL_Filtro;
    MDPesquisaModulo.Filtered := True;

end;

procedure TFModuloConf.FormShow(Sender: TObject);
begin
    LimpaTela;
    F_Carregado := False;
end;

procedure TFModuloConf.LimpaTela;
begin
    EDescricaoModulo.Text := '';
    EDescricaoModuloConf.Text := '';
    EAdquirente.Text := '';
    CKModuloAtivo.Checked := False;
    if MDPesquisaModulo.Active then
        MDPesquisaModulo.EmptyTable;
end;

end.
