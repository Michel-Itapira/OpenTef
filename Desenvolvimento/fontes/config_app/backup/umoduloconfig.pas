unit umoduloconfig;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils, DB, Forms, Controls, funcoes, Graphics, Dialogs, ExtCtrls, StdCtrls,
    Buttons, ComCtrls, RxDBGrid, rxlookup, rxmemds;

type

    { TFModuloConfig }

    TFModuloConfig = class(TForm)
        BAdicionar: TBitBtn;
        DSAdquirente: TDataSource;
        DSBin: TDataSource;
        DSModulo: TDataSource;
        DSModuloConfFuncao: TDataSource;
        DSModuloConfig: TDataSource;
        DSPesquisaModulo: TDataSource;
        MDAdquirente: TRxMemoryData;
        MDBin: TRxMemoryData;
        MDModulo: TRxMemoryData;
        MDModuloConfFuncao: TRxMemoryData;
        MDModuloConfFuncaoDEFINICAO: TStringField;
        MDModuloConfFuncaoHABILITADO: TStringField;
        MDModuloConfFuncaoHABILITADO_F: TBooleanField;
        MDModuloConfFuncaoID: TLargeintField;
        MDModuloConfFuncaoMODULO_CONF_ID: TLargeintField;
        MDModuloConfFuncaoTAG_NUMERO: TStringField;
        MDModuloConfFuncaoTAG_TIPO: TStringField;
        MDModuloConfFuncaoVALIDADO: TStringField;
        MDModuloConfFuncaoVALIDADO_F: TBooleanField;
        MDModuloConfig: TRxMemoryData;
        MDPesquisaModulo: TRxMemoryData;
        TabBinBAdicionar: TBitBtn;
        BExcluir: TBitBtn;
        TabBinBExcluir: TBitBtn;
        BFuncaoModuloConfig: TBitBtn;
        BGeraChave: TSpeedButton;
        BLimpar: TBitBtn;
        BModificar: TBitBtn;
        BPesquisar: TBitBtn;
        BVinculo: TBitBtn;
        CModulo: TRxDBLookupCombo;
        EChave: TMemo;
        EDescricao: TEdit;
        EID: TEdit;
        EHostServico: TEdit;
        EHostCaixa: TEdit;
        EPortaServico: TEdit;
        EPortaCaixa: TEdit;
        GParametro: TGroupBox;
        LChave: TLabel;
        LDescricao: TLabel;
        LID: TLabel;
        LHostServico: TLabel;
        LHostCaixa: TLabel;
        LPortaServico: TLabel;
        LPortaCaixa: TLabel;
        LSelecioneModulo: TLabel;
        LTitulo: TLabel;
        PBotoes: TPanel;
        PModulo: TPanel;
        PModuloConfig: TPanel;
        PTitulo: TPanel;
        CKBin: TCheckBox;
        CKHabilitar: TCheckBox;
        CKMenu: TCheckBox;
        CKMenuOp: TCheckBox;
        TabBinEBin: TEdit;
        TabBinGrid: TRxDBGrid;
        TabBinLBin: TLabel;
        PagePrincipal: TPageControl;
        TabConfigFuncao: TTabSheet;
        TabConfigFuncaoCKSelecionada: TCheckBox;
        TabConfigFuncaoEFiltro: TEdit;
        TabConfigFuncaoETipoFiltro: TComboBox;
        TabConfigFuncaoGrid: TRxDBGrid;
        TabConfigFuncaoLFiltro: TLabel;
        TabConfigFuncaoLTipoFiltro: TLabel;
        BPesquisaAdquirente: TBitBtn;
        EAdquirente: TEdit;
        EAdquirenteID: TEdit;
        LAdquirente: TLabel;
        TabBin: TTabSheet;
        TabConfigFuncaoBVoltar: TBitBtn;
        procedure BFuncaoModuloConfigClick(Sender: TObject);
        procedure BLimparClick(Sender: TObject);
        procedure BPesquisaAdquirenteClick(Sender: TObject);
        procedure BPesquisarClick(Sender: TObject);
        procedure BVinculoClick(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure MDBinFilterRecord(DataSet: TDataSet; var Accept: boolean);
        procedure MDModuloConfFuncaoCalcFields(DataSet: TDataSet);
        procedure MDModuloConfFuncaoFilterRecord(DataSet: TDataSet; var Accept: boolean);
        procedure TabConfigFuncaoBVoltarClick(Sender: TObject);
        procedure TabConfigFuncaoCKSelecionadaChange(Sender: TObject);
        procedure TabConfigFuncaoEFiltroChange(Sender: TObject);
        procedure TabConfigFuncaoETipoFiltroChange(Sender: TObject);
    private
        procedure CarregarModulo(VP_ModuloID: integer);
        procedure vincular(VP_AtivarVinculo: boolean);
    public
        V_Erro: PChar;
        procedure LimpaTela;
        procedure CarregaCampos;
    end;

var
    FModuloConfig: TFModuloConfig;

implementation

{$R *.lfm}
uses
    uinterface, uPesquisamoduloconf, uPesquisaadquirentes;

{ TFModuloConfig }

procedure TFModuloConfig.FormCreate(Sender: TObject);
begin
    MDModuloConfFuncao.Open;
end;

procedure TFModuloConfig.BVinculoClick(Sender: TObject);
begin
    LimpaTela;
    if CModulo.Text = '' then
    begin
        ShowMessage('Você deve selecionar um Módulo para vincular a Configuração');
        exit;
    end;
    if BVinculo.Caption = 'Vincular Módulo' then
        vincular(True)
    else
        vincular(False);
end;

procedure TFModuloConfig.BPesquisaAdquirenteClick(Sender: TObject);
var
    VL_FPesquisaAdquirente: TFPesquisaAdquirente;
begin
    VL_FPesquisaAdquirente := TFPesquisaAdquirente.Create(Self);
    VL_FPesquisaAdquirente.F_Tabela := RxMemDataToStr(MDAdquirente);
    VL_FPesquisaAdquirente.ShowModal;
    if VL_FPesquisaAdquirente.F_Carregado then
    begin
        EAdquirenteID.Text := VL_FPesquisaAdquirente.MDAdquirente.FieldByName('ID').AsString;
        EAdquirente.Text := VL_FPesquisaAdquirente.MDAdquirente.FieldByName('DESCRICAO').AsString;
    end;
end;

procedure TFModuloConfig.BFuncaoModuloConfigClick(Sender: TObject);
begin
    if ((F_Navegar) and (F_Permissao) and (MDModuloConfig.RecordCount > 0)) then
    begin
        CarregarModulo(MDModulo.FieldByName('ID').AsInteger);
        TabConfigFuncaoETipoFiltro.ItemIndex := 0;
        TabConfigFuncaoCKSelecionada.Checked := False;
        TabConfigFuncaoETipoFiltro.OnChange(self);
    end
    else
        MDModuloConfFuncao.EmptyTable;

    TabConfigFuncao.TabVisible := True;
    TabBin.TabVisible := False;
end;

procedure TFModuloConfig.BLimparClick(Sender: TObject);
begin
  LimpaTela;
end;

procedure TFModuloConfig.BPesquisarClick(Sender: TObject);
var
    VL_FPesquisaModuloConf: TFPesquisaModuloConf;
begin
    if F_Permissao = False then
        exit;
    CarregarModulo(0);
    VL_FPesquisaModuloConf := TFPesquisaModuloConf.Create(Self);
    VL_FPesquisaModuloConf.F_Tabela := RxMemDataToStr(MDPesquisaModulo);

    if MDPesquisaModulo.Locate('MODULO_DESCRICAO', CModulo.KeyValue, []) then
        VL_FPesquisaModuloConf.F_ModuloID := MDPesquisaModulo.FieldByName('ID').AsInteger;
    VL_FPesquisaModuloConf.EDescricaoModulo.Text := CModulo.KeyValue;
    VL_FPesquisaModuloConf.EDescricaoModulo.ReadOnly=true;
    VL_FPesquisaModuloConf.EDescricaoModulo.Color:=clHighlight;
    VL_FPesquisaModuloConf.EDescricaoModulo.Font.Color:=clWhite;
    LimpaTela;

    VL_FPesquisaModuloConf.ShowModal;
    if VL_FPesquisaModuloConf.F_Carregado then
    begin
        CarregarModulo(VL_FPesquisaModuloConf.MDPesquisaModulo.FieldByName('ID').AsInteger);
        CarregaCampos;
    end;
end;

procedure TFModuloConfig.FormShow(Sender: TObject);
begin
    //prepara a tela
    LimpaTela;
    PagePrincipal.PageIndex := 0;
    TabConfigFuncao.TabVisible := False;
    self.Height := 69;
    CarregarModulo(0);
end;

procedure TFModuloConfig.MDBinFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin

end;

procedure TFModuloConfig.MDModuloConfFuncaoCalcFields(DataSet: TDataSet);
begin
    if (F_Permissao) then
    begin
        DataSet.FieldByName('VALIDADO_F').AsBoolean := DataSet.FieldByName('VALIDADO').AsBoolean;
        DataSet.FieldByName('HABILITADO_F').AsBoolean := DataSet.FieldByName('HABILITADO').AsBoolean;
    end;
end;

procedure TFModuloConfig.MDModuloConfFuncaoFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin

end;

procedure TFModuloConfig.TabConfigFuncaoBVoltarClick(Sender: TObject);
begin
    TabConfigFuncao.TabVisible := False;
    TabBin.TabVisible := True;
end;

procedure TFModuloConfig.TabConfigFuncaoCKSelecionadaChange(Sender: TObject);
begin
    if TabConfigFuncaoCKSelecionada.Checked then
    begin
        MDModuloConfFuncao.Filter := 'VALIDADO=''T''';
        MDModuloConfFuncao.Filtered := True;
    end
    else
    begin
        TabConfigFuncaoETipoFiltro.ItemIndex := 0;
        TabConfigFuncaoETipoFiltro.OnChange(SELF);
    end;
end;

procedure TFModuloConfig.TabConfigFuncaoEFiltroChange(Sender: TObject);
var
    VL_Filtro: string;
begin
    if F_Permissao = False then
        EXIT;
    VL_Filtro := '';
    MDModuloConfFuncao.Filter := finterface.FiltrarTabela(TabConfigFuncaoGrid, VL_Filtro, TabConfigFuncaoEFiltro);
    TabConfigFuncaoLFiltro.Caption := VL_Filtro;
    MDModuloConfFuncao.Filtered := True;

end;

procedure TFModuloConfig.TabConfigFuncaoETipoFiltroChange(Sender: TObject);
begin
    TabConfigFuncaoCKSelecionada.Checked := False;
    if TabConfigFuncaoETipoFiltro.ItemIndex < 1 then
    begin
        MDModuloConfFuncao.Filter := '';
        MDModuloConfFuncao.Filtered := False;
    end
    else
    begin
        MDModuloConfFuncao.Filter := 'TAG_TIPO=''' + TabConfigFuncaoETipoFiltro.Text + '''';
        MDModuloConfFuncao.Filtered := True;
    end;
end;

procedure TFModuloConfig.CarregarModulo(VP_ModuloID: integer);
var
    VL_Mensagem: TMensagem;
    VL_Tag: string;
    VL_Retorno: string;
    VL_Tabela: TRxMemoryData;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Tag := '';
    VL_Retorno := '';
    VL_Tabela := TRxMemoryData.Create(nil);
    try
        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('0070', 'S');
        VL_Mensagem.AddTag('006F', 0); //adquirente_id
        VL_Mensagem.AddTag('0076', 0); //bin_id
        VL_Mensagem.AddTag('006C', 0); //modulo_id

        if VP_ModuloID = 0 then
        begin
            VL_Mensagem.TagToStr(VL_Tag);
            VL_Tag := FInterface.PesquisaTabelas('0070', 'S', '006C', VP_ModuloID, VL_Tag);
        end
        else
        begin
            VL_Mensagem.AddTag('007B', VP_ModuloID); //modulo_conf_funcao_id
            VL_Mensagem.TagToStr(VL_Tag);
            VL_Tag := FInterface.PesquisaTabelas('0070', 'S', '006C', VP_ModuloID, VL_Tag);
        end;

        VL_Mensagem.Limpar;
        VL_Mensagem.CarregaTags(VL_Tag);
        VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

        case VL_Retorno of
            '0026':
            begin
                VL_Mensagem.GetTag('0026', VL_Tag);
                mensagemerro(StrToInt(VL_Tag), V_Erro);
                ShowMessage('ERRO: ' + VL_Tag + #13 + V_Erro);
                Exit;
            end;
            '0070':
            begin
                //verifica se é um retorno
                if VL_Tag <> 'R' then
                begin
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    mensagemerro(StrToInt(VL_Tag), V_Erro);
                    ShowMessage('ERRO: ' + VL_Tag + #13 + V_Erro);
                    Exit;
                end;
                //TABELA ADQUIRENTE
                if VL_Mensagem.GetTag('0082', VL_Tag) = 0 then
                begin
                    if MDAdquirente.Active then
                        MDAdquirente.EmptyTable;
                    StrToRxMemData(VL_Tag, MDAdquirente);
                    MDAdquirente.Open;
                end;
                //TABELA BIN
                if VL_Mensagem.GetTag('0083', VL_Tag) = 0 then
                begin
                    if MDBin.Active then
                        MDBin.EmptyTable;
                    StrToRxMemData(VL_Tag, MDBin);
                    MDBin.Open;
                end;
                //TABELA MODULO
                if VL_Mensagem.GetTag('0090', VL_Tag) = 0 then
                begin
                    if MDModulo.Active then
                        MDModulo.EmptyTable;
                    StrToRxMemData(VL_Tag, MDModulo);
                    MDModulo.Open;
                end;
                //TABELA MODULO_CONFIG
                if VL_Mensagem.GetTag('003A', VL_Tag) = 0 then
                begin
                    if MDModuloConfig.Active then
                        MDModuloConfig.EmptyTable;
                    StrToRxMemData(VL_Tag, MDModuloConfig);
                    MDModuloConfig.Open;
                end;
                //TABELA MODULO_CONF_FUNCAO
                if VL_Mensagem.GetTag('0093', VL_Tag) = 0 then
                begin
                    if MDModuloConfFuncao.Active then
                        MDModuloConfFuncao.EmptyTable;

                    if VL_Tabela.Active then
                        VL_Tabela.EmptyTable;
                    StrToRxMemData(VL_Tag, VL_Tabela);
                    CopiaDadosSimples(VL_Tabela, MDModuloConfFuncao);
                end;
                //TABELA PESQUISA MODULO
                if VL_Mensagem.GetTag('0095', VL_Tag) = 0 then
                begin
                    if MDPesquisaModulo.Active then
                        MDPesquisaModulo.EmptyTable;
                    StrToRxMemData(VL_Tag, MDPesquisaModulo);
                    MDPesquisaModulo.Open;
                end;
            end;
        end;
    finally
        VL_Tabela.Free;
        VL_Mensagem.Free;
    end;
end;

procedure TFModuloConfig.vincular(VP_AtivarVinculo: boolean);
begin
    if VP_AtivarVinculo then
    begin
        self.Height := 618;
        CModulo.Enabled := False;
        CModulo.Color := clHighlight;
        BVinculo.Caption := 'Desvincular Módulo';
        BVinculo.ImageIndex := 12;
    end
    else
    begin
        self.Height := 69;
        CModulo.Enabled := True;
        CModulo.Color := clWindow;
        BVinculo.Caption := 'Vincular Módulo';
        BVinculo.ImageIndex := 10;
    end;
end;

procedure TFModuloConfig.LimpaTela;
var
    i: integer;
begin
    with self do
    begin
        for i := 0 to ComponentCount - 1 do
        begin
            if Components[i] is TEdit then
                TEdit(Components[i]).Text := '';
            if Components[i] is TCheckBox then
                TCheckBox(Components[i]).Checked := False;
            if Components[i] is TMemo then
                TMemo(Components[i]).Clear;
            if Components[i] is TRxMemoryData then
                if TRxMemoryData(Components[i]).Active then
                    if ((TRxMemoryData(Components[i]) <> TRxMemoryData(MDModulo)) and
                        (TRxMemoryData(Components[i]) <> TRxMemoryData(MDPesquisaModulo)) and
                        (TRxMemoryData(Components[i]) <> TRxMemoryData(MDBin)) and
                        (TRxMemoryData(Components[i]) <> TRxMemoryData(MDAdquirente))) then
                        TRxMemoryData(Components[i]).EmptyTable;
        end;
    end;
end;

procedure TFModuloConfig.CarregaCampos;
begin
    //CARREGA OS CAMPOS
    if F_Navegar = False then
        exit;

    EID.Text := MDModuloConfig.FieldByName('ID').AsString;
    EAdquirenteID.Text := MDModuloConfig.FieldByName('ADQUIRENTE_ID').AsString;
    EAdquirente.Text := MDModuloConfig.FieldByName('ADQUIRENTE_DESCRICAO').AsString;
    EDescricao.Text := MDModuloConfig.FieldByName('DESCRICAO').AsString;
    EHostServico.Text := MDModuloConfig.FieldByName('SERVICO_HOST').AsString;
    EPortaServico.Text := MDModuloConfig.FieldByName('SERVICO_PORTA').AsString;
    EHostCaixa.Text := MDModuloConfig.FieldByName('CAIXA_HOST').AsString;
    EPortaCaixa.Text := MDModuloConfig.FieldByName('CAIXA_PORTA').AsString;
    EChave.Text := MDModuloConfig.FieldByName('CHAVE').AsString;
    if MDModuloConfig.FieldByName('HABILITADO').AsString = 'T' then
        CKHabilitar.Checked := True
    else
        CKHabilitar.Checked := False;
    if MDModuloConfig.FieldByName('BIN_ESTATICO').AsString = 'T' then
        CKBin.Checked := True
    else
        CKBin.Checked := False;

    if MDModuloConfig.FieldByName('MENU_ESTATICO').AsString = 'T' then
        CKMenu.Checked := True
    else
        CKMenu.Checked := False;

    if MDModuloConfig.FieldByName('MENU_ESTATICO_OPERACIONAL').AsString = 'T' then
        CKMenuOp.Checked := True
    else
        CKMenuOp.Checked := False;

    //TABELA BI
    if length(EID.Text) > 0 then
        MDBin.Filter := 'MODULO_CONF_ID=' + EID.Text
    else
        MDBin.Filter := 'MODULO_CONF_ID=0';
    MDBin.Filtered := True;
end;

end.
