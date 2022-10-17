unit uPesquisamoduloconf;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, funcoes, ExtCtrls, StdCtrls, Buttons, RxDBGrid, rxmemds;

type

    { TFPesquisaModuloConf }

    TFPesquisaModuloConf = class(TForm)
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
        procedure FormCreate(Sender: TObject);
        procedure FormShow(Sender: TObject);
    private
        procedure LimpaTela;
    public
        F_Tabela: string;
        F_Carregado: boolean;
        F_ModuloID: integer;
    end;

var
    FPesquisaModuloConf: TFPesquisaModuloConf;

implementation

{$R *.lfm}

{ TFPesquisaModuloConf }

procedure TFPesquisaModuloConf.BSairClick(Sender: TObject);
begin
    Close;
end;

procedure TFPesquisaModuloConf.FormCreate(Sender: TObject);
begin
    F_ModuloID := 0;
end;

procedure TFPesquisaModuloConf.BCarregarClick(Sender: TObject);
begin
    F_Carregado := True;
    Close;
end;

procedure TFPesquisaModuloConf.BPesquisarClick(Sender: TObject);
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

procedure TFPesquisaModuloConf.FormShow(Sender: TObject);
begin
    LimpaTela;
    F_Carregado := False;
end;

procedure TFPesquisaModuloConf.LimpaTela;
begin
    if F_ModuloID = 0 then
        EDescricaoModulo.Text := '';
    EDescricaoModuloConf.Text := '';
    EAdquirente.Text := '';
    CKModuloAtivo.Checked := False;
    if MDPesquisaModulo.Active then
        MDPesquisaModulo.EmptyTable;
end;

end.
