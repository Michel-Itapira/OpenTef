unit umoduloconfig;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils, DB, Forms, Controls, funcoes, Graphics, Dialogs, ExtCtrls, StdCtrls,
    Buttons, ComCtrls, RxDBGrid, rxlookup, rxmemds, DBGrids;

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
        EIdentificador: TMemo;
        LIdentificador: TLabel;
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
        procedure BAdicionarClick(Sender: TObject);
        procedure BExcluirClick(Sender: TObject);
        procedure BFuncaoModuloConfigClick(Sender: TObject);
        procedure BGeraChaveClick(Sender: TObject);
        procedure BLimparClick(Sender: TObject);
        procedure BModificarClick(Sender: TObject);
        procedure BPesquisaAdquirenteClick(Sender: TObject);
        procedure BPesquisarClick(Sender: TObject);
        procedure BVinculoClick(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure MDAdquirenteFilterRecord(DataSet: TDataSet; var Accept: boolean);
        procedure MDBinFilterRecord(DataSet: TDataSet; var Accept: boolean);
        procedure MDModuloConfFuncaoCalcFields(DataSet: TDataSet);
        procedure MDModuloConfFuncaoFilterRecord(DataSet: TDataSet; var Accept: boolean);
        procedure TabBinBAdicionarClick(Sender: TObject);
        procedure TabBinBExcluirClick(Sender: TObject);
        procedure TabConfigFuncaoBVoltarClick(Sender: TObject);
        procedure TabConfigFuncaoCKSelecionadaChange(Sender: TObject);
        procedure TabConfigFuncaoEFiltroChange(Sender: TObject);
        procedure TabConfigFuncaoETipoFiltroChange(Sender: TObject);
        procedure TabConfigFuncaoGridCellClick(Column: TColumn);
    private
        procedure CarregarModulo(VP_ModuloID: integer);
        procedure vincular(VP_AtivarVinculo: boolean);
        function GravaRegistros(VP_Tab: string; VP_Incluir: boolean = False): boolean;
    public
        V_Erro: PChar;
        V_ModuloID: integer;
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
    V_ModuloID := 0;
    Width := 773;
    Height := 635;

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
        CarregarModulo(MDModuloConfig.FieldByName('ID').AsInteger);
        TabConfigFuncaoETipoFiltro.ItemIndex := 0;
        TabConfigFuncaoCKSelecionada.Checked := False;
        TabConfigFuncaoETipoFiltro.OnChange(self);
    end
    else
        MDModuloConfFuncao.EmptyTable;

    TabConfigFuncao.TabVisible := True;
    TabBin.TabVisible := False;
end;

procedure TFModuloConfig.BGeraChaveClick(Sender: TObject);
var
    VL_Chave, vl_tag: ansistring;
    VL_Retorno: string;
    VL_Codigo: integer;
    VL_Mensagem: TMensagem;

begin
    VL_Chave := '';
    VL_Tag := '';
    VL_Retorno := '';
    VL_Mensagem := TMensagem.Create;
    try
        if LENGTH(EID.Text) > 0 then
            if F_TipoConfigurador <> pmC then
            begin
                ShowMessage('SEM PERMISSÃO PARA ALTERAR CHAVE');
                Exit;
            end;
        CriarChaveTerminal(tcModuloConfig, 'LKJUYREQXM', VL_Chave);

        VL_Codigo := FInterface.ValidarChave('0041', VL_Chave, '0071', 'S', VL_Retorno);

        if mensagemerro(VL_Codigo, V_Erro) <> 0 then
        begin
            ShowMessage('Erro: ' + IntToStr(VL_Codigo) + #13 + V_Erro);
            exit;
        end;

        VL_Mensagem.Limpar;
        VL_Mensagem.CarregaTags(VL_Retorno);

        case VL_Mensagem.Comando of
            '0026':
            begin
                mensagemerro(StrToInt(VL_Mensagem.ComandoDados), V_Erro);
                ShowMessage('ERRO:' + VL_Mensagem.ComandoDados + #13 + V_Erro);
            end;
            '0071':
            begin
                if VL_Mensagem.ComandoDados <> 'R' then
                begin
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                    Exit;
                end;
                VL_Mensagem.GetTag('004D', VL_Tag);
                if vl_tag <> '0' then
                begin
                    mensagemerro(StrToInt(vl_tag), V_Erro);
                    ShowMessage('ERRO:' + VL_Tag + #13 + V_Erro);
                    Exit;
                end;
            end;
        end;
        EChave.Lines.Text := VL_Chave;
    finally
        VL_Mensagem.Free;
    end;
end;

procedure TFModuloConfig.BAdicionarClick(Sender: TObject);
var
    VL_Status: integer;
    VL_Mensagem: TMensagem;
    VL_Codigo: integer;
    VL_ID: int64;
    VL_Retorno, VL_Tag: string;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            FInterface.Desconecta;
            Exit;
        end;
        if MDModuloConfig.Active = False then
        begin
            ShowMessage('MDModuloConf não está ativo');
            Exit;
        end;
        if MDModulo.Active = False then
        begin
            ShowMessage('MDModulo não está ativo');
            Exit;
        end;
        if LENGTH(EID.Text) <> 0 then
        begin
            ShowMessage('Para inserir uma configuração primeiro limpe os dados ');
            exit;
        end;
        if LENGTH(EAdquirenteID.Text) = 0 then
        begin
            ShowMessage(LAdquirente.Caption + ' é um campo obrigatório para a inclusão');
            exit;
        end;
        if LENGTH(EIdentificador.Text) = 0 then
        begin
            ShowMessage(LIdentificador.Caption + ' é um campo obrigatório para a inclusão');
            exit;
        end;
        if LENGTH(EChave.Text) = 0 then
        begin
            ShowMessage(LChave.Caption + ' é um campo obrigatório para a inclusão');
            exit;
        end;

        if GravaRegistros('TabModuloConf', True) then
        begin
            VL_Codigo := FINTERFACE.IncluirRegistro(MDModuloConfig, '0073', 'S', '003A', VL_Tag);

            if mensagemerro(VL_Codigo, V_Erro) <> 0 then
            begin
                ShowMessage('Erro: ' + IntToStr(VL_Codigo) + #13 + V_Erro);
                if MDModuloConfig.Locate('ID', 0, []) then
                    MDModuloConfig.Delete;
                exit;
            end;

            VL_Mensagem.Limpar;
            VL_Mensagem.CarregaTags(VL_Tag);
            VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

            case VL_Retorno of
                '0026':
                begin
                    VL_Mensagem.GetTag('0026', VL_Tag);
                    mensagemerro(StrToInt(VL_Tag), V_Erro);
                    ShowMessage('Erro: ' + VL_Tag + #13 + V_Erro);
                    if MDModuloConfig.Locate('ID', 0, []) then
                        MDModuloConfig.Delete;
                    Exit;
                end;
                '0073':
                begin
                    if VL_Tag <> 'R' then
                    begin
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                        if MDModuloConfig.Locate('ID', 0, []) then
                            MDModuloConfig.Delete;
                        Exit;
                    end;
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    if vl_tag <> '0' then
                    begin
                        mensagemerro(StrToInt(VL_Tag), V_Erro);
                        ShowMessage('Erro: ' + VL_Tag + #13 + V_Erro);
                        if MDModuloConfig.Locate('ID', 0, []) then
                            MDModuloConfig.Delete;
                        Exit;
                    end;
                    VL_Mensagem.GetTag('007B', VL_ID); //RETORNO DO ID DO MODULO_CONF
                    F_Navegar := False;
                    if MDModuloConfig.Locate('ID', 0, []) then
                    begin
                        MDModuloConfig.Edit;
                        MDModuloConfig.FieldByName('ID').AsInteger := VL_ID;
                        MDModuloConfig.Post;
                    end;
                    F_Navegar := True;
                end;
            end;
            MDModuloConfig.Locate('ID', VL_ID, []);
            CarregaCampos;
            ShowMessage('Registro incluido com sucesso');
        end;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;

end;

procedure TFModuloConfig.BExcluirClick(Sender: TObject);
var
    VL_Status: integer;
    VL_Codigo: integer;
    VL_Mensagem: TMensagem;
    VL_Retorno, VL_Tag: string;
    VL_ID: int64;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            FINTERFACE.Desconecta;
            Exit;
        end;
        if MDModuloConfig.Active = False then
        begin
            ShowMessage('MDModuloConfig não está ativo');
            Exit;
        end;
        if length(MDModuloConfig.FieldByName('ID').AsString) = 0 then
        begin
            ShowMessage('Não existe registro selecionado para exclusão');
            Exit;
        end;
        VL_Codigo := FINTERFACE.ExcluirRegistro('007B', StrToInt(MDModuloConfig.FieldByName('ID').AsString), '00BA', 'S', VL_Tag);

        if mensagemerro(VL_Codigo, V_Erro) <> 0 then
        begin
            ShowMessage('Erro: ' + IntToStr(VL_Codigo) + #13 + V_Erro);
            FINTERFACE.Desconecta;
            exit;
        end;
        VL_Mensagem.Limpar;
        VL_Mensagem.CarregaTags(VL_Tag);
        VL_Mensagem.GetComando(VL_Retorno, VL_Tag);
        case VL_Retorno of
            '0026':
            begin
                VL_Mensagem.GetTag('0026', VL_ID);
                mensagemerro(VL_ID, V_Erro);
                ShowMessage('Erro: ' + IntToStr(VL_ID) + #13 + V_Erro);
                Exit;
            end;
            '00BA':
            begin
                if VL_Tag <> 'R' then
                begin
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                    Exit;
                end;
                VL_Mensagem.GetTag('004D', VL_Tag);
                if vl_tag <> '0' then
                begin
                    VL_Mensagem.GetTag('004D', VL_ID);
                    mensagemerro(VL_ID, V_Erro);
                    ShowMessage('Erro: ' + IntToStr(VL_ID) + #13 + V_Erro);
                    Exit;
                end;
                VL_Mensagem.GetTag('007B', VL_ID);
                F_Navegar := False;
                if MDModuloConfig.Locate('ID', VL_ID, []) then
                    MDModuloConfig.Delete;
                F_Navegar := True;
            end;
        end;
        ShowMessage('Registro Excluido com sucesso');
        LimpaTela;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;

end;

procedure TFModuloConfig.BLimparClick(Sender: TObject);
begin
    LimpaTela;
    if MDBin.RecordCount > 0 then
        MDBIN.EmptyTable;
end;

procedure TFModuloConfig.BModificarClick(Sender: TObject);
var
    VL_Status, VL_Codigo: integer;
    VL_Retorno, VL_Tag: string;
    VL_Mensagem: TMensagem;
begin
    VL_Status := 0;
    VL_Codigo := 0;
    VL_Retorno := '';
    VL_Tag := '';
    VL_Mensagem := TMensagem.Create;

    F_OpenTefStatus(VL_Status);
    if VL_Status <> Ord(csLogado) then
    begin
        ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
        FINTERFACE.Desconecta;
        Exit;
    end;
    if MDModuloConfig.Active = False then
    begin
        ShowMessage('MDModuloConfig não está ativo');
        Exit;
    end;
    if ((EID.Text = '') or (EID.Text = '0')) then
    begin
        ShowMessage('Operação cancelada, selecione uma configuração para alterar');
        exit;
    end;
    if GravaRegistros('TabModuloConf', False) then
    begin
        VL_Codigo := FINTERFACE.AlterarRegistro('003A', MDModuloConfig, '007B', StrToInt(EID.Text), '0072', 'S', VL_Tag);

        if mensagemerro(VL_Codigo, V_Erro) <> 0 then
        begin
            ShowMessage('Erro: ' + IntToStr(VL_Codigo) + #13 + V_Erro);
            finterface.Desconecta;
            exit;
        end;
        VL_Mensagem.Limpar;
        VL_Mensagem.CarregaTags(VL_Tag);
        VL_Mensagem.GetComando(VL_Retorno, VL_Tag);
        case VL_Retorno of
            '0026':
            begin
                VL_Mensagem.GetTag('0026', VL_Tag);
                mensagemerro(StrToInt(VL_Tag), V_Erro);
                ShowMessage('ERRO:' + VL_Tag + #13 + V_Erro);
                // CarregarTabelas;
                MDModuloConfig.Locate('ID', StrToInt(EID.Text), []);
                CarregaCampos;
                F_Navegar := True;
                Exit;
            end;
            else
            begin
                if VL_Tag <> 'R' then
                begin
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    mensagemerro(StrToInt(VL_Tag), V_Erro);
                    ShowMessage('ERRO: ' + VL_Tag + #13 + V_Erro);
                    Exit;
                end;
                VL_Mensagem.GetTag('004D', VL_Tag);
                if VL_Tag = '0' then
                    ShowMessage('Registro alterado com sucesso')
                else
                begin
                    mensagemerro(StrToInt(VL_Tag), V_Erro);
                    ShowMessage('ERRO: ' + VL_Tag + #13 + V_Erro);
                    LimpaTela;
                    Exit;
                end;
            end;
        end;
        MDModuloConfig.Locate('ID', StrToInt(EID.Text), []);
        CarregaCampos;
        VL_Mensagem.Free;
    end;
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

    VL_FPesquisaModuloConf.F_ModuloID := V_ModuloID;
    VL_FPesquisaModuloConf.EDescricaoModulo.Text := CModulo.KeyValue;
    VL_FPesquisaModuloConf.EDescricaoModulo.ReadOnly := True;
    VL_FPesquisaModuloConf.EDescricaoModulo.Color := clHighlight;
    VL_FPesquisaModuloConf.EDescricaoModulo.Font.Color := clWhite;
    LimpaTela;

    VL_FPesquisaModuloConf.ShowModal;
    if VL_FPesquisaModuloConf.F_Carregado then
    begin
        CarregarModulo(VL_FPesquisaModuloConf.F_ModuloID);
        if MDModuloConfig.Locate('ID', VL_FPesquisaModuloConf.F_ModuloConfigID, []) then
            CarregaCampos
        else
            BLimparClick(BLimpar);
    end;
end;

procedure TFModuloConfig.FormShow(Sender: TObject);
begin
    //prepara a tela
    LimpaTela;
    PagePrincipal.PageIndex := 0;
    TabConfigFuncao.TabVisible := False;
    self.Height := 69;
    CarregarModulo(V_ModuloID);
    if V_ModuloID > 0 then
    begin
        if MDModulo.Locate('ID', V_ModuloID, []) then
            CModulo.KeyValue := MDModulo.FieldByName('DESCRICAO').AsString;
        BVinculoClick(BVINCULO);
    end;
    //FILTRA BINS
    MDBin.Filter := 'MODULO_CONF_ID=' + IntToStr(V_ModuloID);
    MDBin.FILTERED := True;
end;

procedure TFModuloConfig.MDAdquirenteFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin

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

procedure TFModuloConfig.TabBinBAdicionarClick(Sender: TObject);
var
    VL_Status: integer;
    VL_Mensagem: TMensagem;
    VL_Codigo: integer;
    VL_ID: int64;
    VL_Retorno, VL_Tag: string;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            FINTERFACE.Desconecta;
            Exit;
        end;
        if LENGTH(EID.Text) < 1 then
        begin
            ShowMessage('Para adicionar um Bin, pesquise antes uma configuração');
            Exit;
        end;
        if MDBin.Active = False then
        begin
            ShowMessage('MDBin não está ativo');
            Exit;
        end;
        if TabBinEBin.Text = '' then
        begin
            ShowMessage('Número do B.I.N é um campo obrigatório');
            exit;
        end;

        if GravaRegistros('TabBin', True) then
        begin
            VL_Codigo := finterface.IncluirRegistro(MDBin, '0077', 'S', '0083', VL_Tag);

            if mensagemerro(VL_Codigo, V_Erro) <> 0 then
            begin
                ShowMessage('Erro: ' + IntToStr(VL_Codigo) + #13 + V_Erro);
                if MDBin.Locate('ID', 0, []) then
                    MDBin.Delete;
                exit;
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
                    if MDBin.Locate('ID', 0, []) then
                        MDBin.Delete;
                    Exit;
                end;
                '0077':
                begin
                    if VL_Tag <> 'R' then
                    begin
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        mensagemerro(StrToInt(VL_Tag), V_Erro);
                        ShowMessage('ERRO: ' + VL_Tag + #13 + V_Erro);
                        if MDBin.Locate('ID', 0, []) then
                            MDBin.Delete;
                        Exit;
                    end;

                    VL_Mensagem.GetTag('004D', VL_Tag);
                    if vl_tag <> '0' then
                    begin
                        mensagemerro(StrToInt(VL_Tag), V_Erro);
                        ShowMessage('ERRO: ' + VL_Tag + #13 + V_Erro);
                        if MDBin.Locate('ID', 0, []) then
                            MDBin.Delete;
                        Exit;
                    end;
                    VL_Mensagem.GetTag('0076', VL_ID); //RETORNO DO ID DO BIN
                    F_Navegar := False;
                    if MDBin.Locate('ID', 0, []) then
                    begin
                        MDBin.Edit;
                        MDBin.FieldByName('ID').AsInteger := VL_ID;
                        MDBin.Post;
                    end;
                    F_Navegar := True;
                end;
            end;
            MDBin.Locate('ID', VL_ID, []);
            CarregaCampos;
            ShowMessage('Registro incluido com sucesso');
        end;
    finally
        VL_Mensagem.Free;
        TabBinEBin.Text := '';
        F_Navegar := True;
    end;

end;

procedure TFModuloConfig.TabBinBExcluirClick(Sender: TObject);
var
    VL_Status: integer;
    VL_Codigo: integer;
    VL_Mensagem: TMensagem;
    VL_Retorno, VL_Tag: string;
    VL_ID: int64;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            FInterface.Desconecta;
            Exit;
        end;
        if MDBin.Active = False then
        begin
            ShowMessage('MDBin não está ativo');
            Exit;
        end;
        if TabBinGrid.DataSource.DataSet.IsEmpty then
        begin
            ShowMessage('Não existe Bin para ser excluido');
            exit;
        end;
        VL_Codigo := finterface.ExcluirRegistro('0076', StrToInt(MDBin.FieldByName('ID').AsString), '0078', 'S', VL_Tag);

        if mensagemerro(VL_Codigo, V_Erro) <> 0 then
        begin
            ShowMessage('Erro: ' + IntToStr(VL_Codigo) + #13 + V_Erro);
            exit;
        end;
        VL_Mensagem.Limpar;
        VL_Mensagem.CarregaTags(VL_Tag);
        VL_Mensagem.GetComando(VL_Retorno, VL_Tag);
        case VL_Retorno of
            '0026':
            begin
                VL_Mensagem.GetTag('0026', VL_ID);
                mensagemerro(VL_ID, V_Erro);
                ShowMessage('Erro: ' + IntToStr(VL_ID) + #13 + V_Erro);
                Exit;
            end;
            '0078':
            begin
                if VL_Tag <> 'R' then
                begin
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                    Exit;
                end;
                VL_Mensagem.GetTag('004D', VL_Tag);
                if vl_tag <> '0' then
                begin
                    VL_Mensagem.GetTag('004D', VL_ID);
                    mensagemerro(VL_ID, V_Erro);
                    ShowMessage('Erro: ' + IntToStr(VL_ID) + #13 + V_Erro);
                    Exit;
                end;
                VL_Mensagem.GetTag('0076', VL_ID); //BIN_ID
                F_Navegar := False;
                if MDBin.Locate('ID', VL_ID, []) then
                    MDBin.Delete;
                F_Navegar := True;
            end;
        end;
        CarregaCampos;
        ShowMessage('Registro Excluido com sucesso');
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;

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

procedure TFModuloConfig.TabConfigFuncaoGridCellClick(Column: TColumn);
var
    VL_Status: integer;
    VL_Mensagem: TMensagem;
    VL_Codigo: integer;
    VL_ID: int64;
    VL_Retorno, VL_Tag: string;
label
    sair;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';

    if TabConfigFuncaoGrid.SelectedColumn.FieldName <> 'VALIDADO_F' then
        TabConfigFuncaoLFiltro.Caption := 'Filtrar por ' + TabConfigFuncaoGrid.SelectedColumn.Title.Caption;
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            finterface.Desconecta;
            Exit;
        end;
        if ((MDModulo.Active = False) or (MDModulo.RecordCount < 1)) then
            exit;
        if ((MDModuloConfFuncao.Active = False) or (MDModuloConfFuncao.RecordCount < 1)) then
            exit;
        F_Navegar := False;
        if ((TabConfigFuncaoGrid.SelectedColumn.FieldName = 'VALIDADO_F') or
            (TabConfigFuncaoGrid.SelectedColumn.FieldName = 'HABILITADO_F')) then
        begin
            VL_ID := MDModuloConfFuncaoID.AsInteger;
            VL_Tag := MDModuloConfFuncaoTAG_NUMERO.AsString;

            if MDModuloConfFuncao.Filtered then
            begin
                MDModuloConfFuncao.Filtered := False;
                if VL_ID = 0 then
                    MDModuloConfFuncao.Locate('TAG_NUMERO', VL_Tag, [])
                else
                    MDModuloConfFuncao.Locate('ID', VL_ID, []);
            end;

            if (TabConfigFuncaoGrid.SelectedColumn.FieldName = 'VALIDADO_F') then
            begin
                MDModuloConfFuncao.Edit;
                MDModuloConfFuncao.FieldByName('VALIDADO').AsBoolean := not MDModuloConfFuncao.FieldByName('VALIDADO').AsBoolean;
                MDModuloConfFuncao.Post;
            end;
            if (TabConfigFuncaoGrid.SelectedColumn.FieldName = 'HABILITADO_F') then
            begin
                MDModuloConfFuncao.Edit;
                MDModuloConfFuncao.FieldByName('HABILITADO').AsBoolean := not MDModuloConfFuncao.FieldByName('HABILITADO').AsBoolean;
                MDModuloConfFuncao.Post;
            end;
            if ((MDModuloConfFuncao.FieldByName('VALIDADO').AsBoolean = True) and (VL_ID < 1)) then
            begin
                MDModuloConfFuncao.Edit;
                MDModuloConfFuncao.FieldByName('MODULO_CONF_ID').AsString := MDModuloConfig.FieldByName('ID').AsString;
                MDModuloConfFuncao.FieldByName('ID').AsInteger := 0;
                MDModuloConfFuncao.Post;
                //incluir MODULOCONF função
                VL_Codigo := finterface.IncluirRegistro(MDModuloConfFuncao, '0079', 'S', '0093', VL_Tag);

                if mensagemerro(VL_Codigo, V_Erro) <> 0 then
                begin
                    ShowMessage('Erro: ' + IntToStr(VL_Codigo) + #13 + V_Erro);
                    if MDModuloConfFuncao.Locate('ID', 0, []) then
                        MDModuloConfFuncao.Delete;
                    exit;
                end;

                VL_Mensagem.Limpar;
                VL_Mensagem.CarregaTags(VL_Tag);
                VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

                case VL_Retorno of
                    '0026':
                    begin
                        VL_Mensagem.GetTag('0026', VL_Tag);
                        mensagemerro(StrToInt(VL_Tag), V_Erro);
                        ShowMessage('Erro: ' + VL_Tag + #13 + V_Erro);
                        if MDModuloConfFuncao.Locate('ID', 0, []) then
                            MDModuloConfFuncao.Delete;
                        Exit;
                    end;
                    '0079':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                            if MDModuloConfFuncao.Locate('ID', 0, []) then
                                MDModuloConfFuncao.Delete;
                            Exit;
                        end;
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        if vl_tag <> '0' then
                        begin
                            mensagemerro(StrToInt(VL_Tag), V_Erro);
                            ShowMessage('Erro: ' + VL_Tag + #13 + V_Erro);
                            if MDModuloConfFuncao.Locate('ID', 0, []) then
                                MDModuloConfFuncao.Delete;
                            Exit;
                        end;
                        VL_Mensagem.GetTag('006D', VL_ID); //RETORNO DO ID DO MODULO_CONF_FUNCAO
                        F_Navegar := False;
                        if MDModuloConfFuncao.Locate('ID', 0, []) then
                        begin
                            MDModuloConfFuncao.Edit;
                            MDModuloConfFuncao.FieldByName('ID').AsInteger := VL_ID;
                            MDModuloConfFuncao.Post;
                        end;
                        F_Navegar := True;
                    end;
                end;
            end
            else
            if ((MDModuloConfFuncao.FieldByName('VALIDADO').AsBoolean = True) and (VL_ID > 0)) then
            begin
                //ALTERA MODULO_CONF_FUNCAO
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0085', 'S');
                VL_Mensagem.AddTag('006D', VL_ID);
                VL_Mensagem.AddTag('0086', MDModuloConfFuncao.FieldByName('HABILITADO').AsString);
                VL_Mensagem.TagToStr(VL_Tag);
                VL_Codigo := finterface.SolicitacaoBloc(VL_Tag, VL_Tag, C_TempoSolicitacao);

                if mensagemerro(VL_Codigo, V_Erro) <> 0 then
                begin
                    ShowMessage('Erro: ' + IntToStr(VL_Codigo) + #13 + V_Erro);
                    exit;
                end;
                VL_Mensagem.Limpar;
                VL_Mensagem.CarregaTags(VL_Tag);
                VL_Mensagem.GetComando(VL_Retorno, VL_Tag);
                case VL_Retorno of
                    '0026':
                    begin
                        VL_Mensagem.GetTag('0026', VL_Tag);
                        mensagemerro(StrToInt(VL_Tag), V_Erro);
                        ShowMessage('Erro: ' + VL_Tag + #13 + V_Erro);
                        Exit;
                    end;
                    '0085':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                            Exit;
                        end;
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        if vl_tag <> '0' then
                        begin
                            mensagemerro(StrToInt(VL_Tag), V_Erro);
                            ShowMessage('Erro: ' + VL_Tag + #13 + V_Erro);
                            Exit;
                        end;
                    end;
                end;
            end
            else
            begin
                //alterar MODULO função
                VL_Codigo := finterface.ExcluirRegistro('006D', VL_ID, '008A', 'S', VL_Tag);

                if mensagemerro(VL_Codigo, V_Erro) <> 0 then
                begin
                    ShowMessage('Erro: ' + IntToStr(VL_Codigo) + #13 + V_Erro);
                    goto sair;
                end;
                VL_Mensagem.Limpar;
                VL_Mensagem.CarregaTags(VL_Tag);
                VL_Mensagem.GetComando(VL_Retorno, VL_Tag);
                case VL_Retorno of
                    '0026':
                    begin
                        VL_Mensagem.GetTag('0026', VL_Tag);
                        mensagemerro(StrToInt(VL_Tag), V_Erro);
                        ShowMessage('Erro: ' + VL_Tag + #13 + V_Erro);
                    end;
                    '008A':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                        end
                        else
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            if vl_tag <> '0' then
                            begin
                                mensagemerro(StrToInt(VL_Tag), V_Erro);
                                ShowMessage('Erro: ' + VL_Tag + #13 + V_Erro);
                            end;
                        end;
                    end;
                end;
                sair:
                    MDModuloConfFuncao.Edit;
                MDModuloConfFuncao.FieldByName('ID').AsInteger := -1;
                MDModuloConfFuncao.FieldByName('HABILITADO').AsString := 'F';
                MDModuloConfFuncao.FieldByName('HABILITADO_F').AsBoolean := False;
                MDModuloConfFuncao.Post;
            end;
        end;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
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
        self.Height := 635;
        CModulo.Enabled := False;
        CModulo.Color := clHighlight;
        BVinculo.Caption := 'Desvincular Módulo';
        BVinculo.ImageIndex := 12;
        if MDModulo.Locate('DESCRICAO', CModulo.KeyValue, []) then
            V_ModuloID := MDModulo.FieldByName('ID').AsInteger;
    end
    else
    begin
        self.Height := 66;
        CModulo.Enabled := True;
        CModulo.Color := clWindow;
        BVinculo.Caption := 'Vincular Módulo';
        BVinculo.ImageIndex := 10;
        V_ModuloID := 0;
    end;
end;

function TFModuloConfig.GravaRegistros(VP_Tab: string; VP_Incluir: boolean): boolean;
var
    VL_ID: integer;
    VL_Bool: string;
    VL_Tabela: string;
begin
    Result := False;
    F_Navegar := False;
    VL_Bool := 'F';
    VL_Tabela := '';
    try
        //grava TabModuloConf
        if VP_Tab = 'TabModuloConf' then
        begin
            if not (F_Permissao) then
            begin
                ShowMessage('Sem Permissão de Gravação, usuário não é um Configurador');
                F_Navegar := True;
                exit;
            end;
            if VP_Incluir then
                VL_ID := 0
            else
                VL_ID := MDModuloConfig.FieldByName('ID').AsInteger;

            if VP_Incluir then
                MDModuloConfig.Insert
            else
                MDModuloConfig.Edit;

            MDModuloConfig.FieldByName('ID').AsInteger := VL_ID;
            MDModuloConfig.FieldByName('MODULO_ID').AsString := MDModulo.FieldByName('ID').AsString;
            MDModuloConfig.FieldByName('ADQUIRENTE_ID').AsString := EAdquirenteID.Text;
            MDModuloConfig.FieldByName('ADQUIRENTE_DESCRICAO').AsString := EAdquirente.Text;
            MDModuloConfig.FieldByName('CHAVE_COMUNICACAO').AsString := EChave.Lines.Text;
            MDModuloConfig.FieldByName('IDENTIFICADOR').AsString := EIdentificador.Lines.Text;
            MDModuloConfig.FieldByName('DESCRICAO').AsString := EDescricao.Text;
            MDModuloConfig.FieldByName('SERVICO_HOST').AsString := EHostServico.Text;
            MDModuloConfig.FieldByName('SERVICO_PORTA').AsInteger := StrToIntDef(EPortaServico.Text, 0);
            MDModuloConfig.FieldByName('CAIXA_HOST').AsString := EHostCaixa.Text;
            MDModuloConfig.FieldByName('CAIXA_PORTA').AsInteger := StrToIntDef(EPortaCaixa.Text, 0);
            if CKBin.Checked then
                MDModuloConfig.FieldByName('BIN_ESTATICO').AsString := 'T'
            else
                MDModuloConfig.FieldByName('BIN_ESTATICO').AsString := 'F';

            if CKMenu.Checked then
                MDModuloConfig.FieldByName('MENU_ESTATICO').AsString := 'T'
            else
                MDModuloConfig.FieldByName('MENU_ESTATICO').AsString := 'F';

            if CKMenuOp.Checked then
                MDModuloConfig.FieldByName('MENU_ESTATICO_OPERACIONAL').AsString := 'T'
            else
                MDModuloConfig.FieldByName('MENU_ESTATICO_OPERACIONAL').AsString := 'F';

            if CKHabilitar.Checked then
                MDModuloConfig.FieldByName('HABILITADO').AsString := 'T'
            else
                MDModuloConfig.FieldByName('HABILITADO').AsString := 'F';
            MDModuloConfig.Post;
            Result := True;
        end
        else
        //grava TabBin
        if VP_Tab = 'TabBin' then
        begin
            if not (F_Permissao) then
            begin
                ShowMessage('Sem Permissão de Gravação, usuário não é um Configurador');
                F_Navegar := True;
                exit;
            end;
            if VP_Incluir then
                VL_ID := 0
            else
                VL_ID := MDBin.FieldByName('ID').AsInteger;

            if VP_Incluir then
                MDBin.Insert
            else
                MDBin.Edit;

            MDBin.FieldByName('ID').AsInteger := VL_ID;
            MDBin.FieldByName('MODULO_CONF_ID').AsString := MDModuloConfig.FieldByName('ID').AsString;
            MDBin.FieldByName('IIN').AsString := TabBinEBin.Text;
            MDBin.Post;
            Result := True;
        end
    finally
        F_Navegar := True;
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
    EChave.Text := MDModuloConfig.FieldByName('CHAVE_COMUNICACAO').AsString;
    EIdentificador.Lines.Text := MDModuloConfig.FieldByName('IDENTIFICADOR').AsString;
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
