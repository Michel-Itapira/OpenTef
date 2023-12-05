unit ucadpdv;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils, DB, Forms, funcoes, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
    StdCtrls, ComCtrls, rxlookup, RxDBGrid, rxmemds, DBGrids;

type

    { TFCadPdv }

    TFCadPdv = class(TForm)
        BAdicionar: TBitBtn;
        BExcluir: TBitBtn;
        BFuncaoPdv: TBitBtn;
        BLimpar: TBitBtn;
        BModificar: TBitBtn;
        BPesquisar: TBitBtn;
        BVinculo: TBitBtn;
        DSLoja: TDataSource;
        DSPdv: TDataSource;
        DSPdvFuncao: TDataSource;
        DSPdvModulo: TDataSource;
        DSPesquisaModulo: TDataSource;
        DSPinPad: TDataSource;
        DSTags: TDataSource;
        EIdentificador: TEdit;
        EIdentificadorPdv: TEdit;
        LIdentificador: TLabel;
        LIdentificacaoPdv: TLabel;
        LTitulo: TLabel;
        LSelecioneLoja: TLabel;
        MDLoja: TRxMemoryData;
        MDPdv: TRxMemoryData;
        MDPdvFuncao: TRxMemoryData;
        MDPdvFuncaoDEFINICAO: TStringField;
        MDPdvFuncaoHABILITADO: TStringField;
        MDPdvFuncaoHABILITADO_F: TBooleanField;
        MDPdvFuncaoID: TLargeintField;
        MDPdvFuncaoPDV_ID: TLargeintField;
        MDPdvFuncaoTAG_NUMERO: TStringField;
        MDPdvFuncaoTAG_TIPO: TStringField;
        MDPdvFuncaoVALIDADO: TStringField;
        MDPdvFuncaoVALIDADO_F: TBooleanField;
        MDPdvModulo: TRxMemoryData;
        MDPesquisaModulo: TRxMemoryData;
        MDPinPad: TRxMemoryData;
        MDTags: TRxMemoryData;
        PagePrincipal: TPageControl;
        PLoja: TPanel;
        PBotoes: TPanel;
        Panel4: TPanel;
        Panel5: TPanel;
        PTitulo: TPanel;
        TabPdvFuncao: TTabSheet;
        TabPdvFuncaoBVoltar: TBitBtn;
        TabPdvFuncaoCKSelecionada: TCheckBox;
        TabPdvFuncaoEFiltro: TEdit;
        TabPdvFuncaoETipoFiltro: TComboBox;
        TabPdvFuncaoGrid: TRxDBGrid;
        TabPdvFuncaoLFiltro: TLabel;
        TabPdvFuncaoLTipoFiltro: TLabel;
        TabPdvModulo: TTabSheet;
        TabPdvModuloBAdicionar: TBitBtn;
        TabPdvModuloBExcluir: TBitBtn;
        TabPdvModuloBLimpar: TBitBtn;
        TabPdvModuloBModificar: TBitBtn;
        TabPdvModuloBPesquisaTag: TBitBtn;
        TabPdvModuloBPesquisaModuloConf: TBitBtn;
        TabPdvModuloCkHabilitar: TCheckBox;
        TabPdvModuloECodigo: TEdit;
        TabPdvModuloEFiltro: TEdit;
        TabPdvModuloEID: TEdit;
        TabPdvModuloETag: TEdit;
        TabPdvModuloEModuloConf: TEdit;
        TabPdvModuloETagID: TEdit;
        TabPdvModuloEModuloConfID: TEdit;
        TabPdvModuloGrid: TRxDBGrid;
        TabPdvModuloLCodigo: TLabel;
        TabPdvModuloLFiltro: TLabel;
        TabPdvModuloLID: TLabel;
        TabPdvModuloLTag: TLabel;
        TabPdvModuloLModuloConf: TLabel;
        BGeraChave: TSpeedButton;
        CkHabilitar: TCheckBox;
        CLoja: TRxDBLookupCombo;
        CPinPad: TRxDBLookupCombo;
        EChave: TMemo;
        EDescricao: TEdit;
        EID: TEdit;
        EIP: TEdit;
        EPinPadCom: TEdit;
        LChave: TLabel;
        LDescricao: TLabel;
        LID: TLabel;
        LIP: TLabel;
        LPinPad: TLabel;
        LPinPadCom: TLabel;
        PPdv: TPanel;
        procedure BAdicionarClick(Sender: TObject);
        procedure BExcluirClick(Sender: TObject);
        procedure BFuncaoPdvClick(Sender: TObject);
        procedure BGeraChaveClick(Sender: TObject);
        procedure BLimparClick(Sender: TObject);
        procedure BModificarClick(Sender: TObject);
        procedure BPesquisarClick(Sender: TObject);
        procedure BVinculoClick(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure MDPdvFuncaoCalcFields(DataSet: TDataSet);
        procedure MDPdvFuncaoFilterRecord(DataSet: TDataSet; var Accept: boolean);
        procedure TabPdvFuncaoBVoltarClick(Sender: TObject);
        procedure TabPdvFuncaoCKSelecionadaChange(Sender: TObject);
        procedure TabPdvFuncaoEFiltroChange(Sender: TObject);
        procedure TabPdvFuncaoETipoFiltroChange(Sender: TObject);
        procedure TabPdvFuncaoGridCellClick(Column: TColumn);
        procedure TabPdvModuloBAdicionarClick(Sender: TObject);
        procedure TabPdvModuloBExcluirClick(Sender: TObject);
        procedure TabPdvModuloBLimparClick(Sender: TObject);
        procedure TabPdvModuloBModificarClick(Sender: TObject);
        procedure TabPdvModuloBPesquisaModuloConfClick(Sender: TObject);
        procedure TabPdvModuloBPesquisaTagClick(Sender: TObject);
        procedure TabPdvModuloEFiltroChange(Sender: TObject);
    private
        procedure CarregarPdv(VP_PdvID, VP_ModuloConfID: integer);
        procedure vincular(VP_AtivarVinculo: boolean);
        function GravaRegistros(VP_Tab: string; VP_Incluir: boolean = False): boolean;
    public
        V_Erro: PChar;
        procedure LimpaTela;
        procedure CarregaCampos;
    end;

var
    FCadPdv: TFCadPdv;

implementation

{$R *.lfm}
uses
    uinterface, uPesquisamoduloconf, uPesquisaTags, upesquisapdv;

{ TFCadPdv }

procedure TFCadPdv.FormCreate(Sender: TObject);
begin
    MDPdvFuncao.Open;
    Width := 776;
    Height := 607;
end;

procedure TFCadPdv.BVinculoClick(Sender: TObject);
begin
    LimpaTela;
    if CLoja.Text = '' then
    begin
        ShowMessage('Você deve selecionar uma Loja para vincular o Pdv');
        exit;
    end;
    if BVinculo.Caption = 'Vincular a Loja' then
        vincular(True)
    else
        vincular(False);
end;

procedure TFCadPdv.BLimparClick(Sender: TObject);
begin
    LimpaTela;
end;

procedure TFCadPdv.BModificarClick(Sender: TObject);
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
        finterface.Desconectar;
        Exit;
    end;
    if MDPdv.Active = False then
    begin
        ShowMessage('MDPdv não está ativo');
        Exit;
    end;
    if (length(eid.Text)=0) or (eid.Text ='0') then
    begin
        ShowMessage('Não existe registro selecionado para alteração');
        Exit;
    end;
    if EIdentificadorPdv.Text = '' then
    begin
        ShowMessage(LIdentificacaoPdv.Caption + ' é um campo obrigatório');
        exit;
    end;
    if EIdentificador.Text = '' then
    begin
        ShowMessage(LIdentificador.Caption + ' é um campo obrigatório');
        exit;
    end;
    if EChave.Text = '' then
    begin
        ShowMessage(LChave.Caption + ' é um campo obrigatório');
        exit;
    end;

    if ((CLoja.Text = '') or (CLoja.LookupDisplayIndex = -1)) then
    begin
        ShowMessage('Voce deve selecionar uma loja para incluir o Pdv, campo obrigatório');
        exit;
    end;
    if GravaRegistros('TabPdv', False) then
    begin
        VL_Codigo := finterface.AlterarRegistro('008E', MDPdv, '0043', StrToInt(EID.Text), '004B', 'S', vl_tag);

        if mensagemerro(VL_Codigo, V_Erro) <> 0 then
        begin
            ShowMessage('Erro: ' + IntToStr(VL_Codigo) + #13 + V_Erro);
            finterface.Desconectar;
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
                MDPdv.Locate('ID', StrToInt(EID.Text), []);
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
        MDPdv.Locate('ID', StrToInt(EID.Text), []);
        CarregaCampos;
        VL_Mensagem.Free;
    end;
end;

procedure TFCadPdv.BPesquisarClick(Sender: TObject);
var
    VL_FPesquisaPdv: TFPesquisaPdv;
begin
    if F_Permissao = False then
        exit;
    CarregarPdv(0, 0);
    VL_FPesquisaPdv := TFPesquisaPdv.Create(Self);
    VL_FPesquisaPdv.F_Tabela := RxMemDataToStr(MDPdv);
    VL_FPesquisaPdv.ERazao.Text := CLoja.KeyValue;
    if MDLOJA.Locate('RAZAO', CLoja.KeyValue, []) then
        VL_FPesquisaPdv.F_LojaID := MDLoja.FieldByName('ID').AsInteger;
    LimpaTela;
    VL_FPesquisaPdv.ShowModal;
    if VL_FPesquisaPdv.F_Carregado then
    begin
        CarregarPdv(VL_FPesquisaPdv.MDPesquisaPdv.FieldByName('ID').AsInteger, 0);
        CarregaCampos;
    end;

end;

procedure TFCadPdv.BFuncaoPdvClick(Sender: TObject);
begin
    if EID.Text = '' then
        exit;

    if ((F_Navegar) and (F_Permissao) and (MDPdv.RecordCount > 0)) then
    begin
        CarregarPdv(MDPdv.FieldByName('ID').AsInteger, 0);
        TabPdvFuncaoETipoFiltro.ItemIndex := 0;
        TabPdvFuncaoCKSelecionada.Checked := False;
        TabPdvFuncaoETipoFiltro.OnChange(self);
    end
    else
        MDPdvFuncao.EmptyTable;

    TabPdvFuncao.TabVisible := True;
    TabPdvModulo.TabVisible := False;
end;

procedure TFCadPdv.BGeraChaveClick(Sender: TObject);
var
    VL_Chave, VL_Tag: ansistring;
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
        CriarChaveTerminal(tcPDV, 'LKJUYREQXM', VL_Chave);

        VL_Codigo := FInterface.ValidarChave('003B', VL_Chave, '0045', 'S', VL_Retorno);

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
            '0045':
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

procedure TFCadPdv.BAdicionarClick(Sender: TObject);
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
            finterface.Desconectar;
            Exit;
        end;
        if MDLoja.Active = False then
        begin
            ShowMessage('MDLoja não está ativo');
            Exit;
        end;
        if MDPdv.Active = False then
        begin
            ShowMessage('MDPdv não está ativo');
            Exit;
        end;
        if CLoja.LookupDisplayIndex = -1 then
        begin
            ShowMessage('Voce deve selecionar uma loja para cadastrar o PDV.');
            Exit;
        end;

        if LENGTH(EID.Text) > 0 then
        begin
            ShowMessage('Limpe o cadastro antes de Adicionar um PDV');
            exit;
        end;
        //campos obrigatório
        if LENGTH(EIdentificadorPdv.Text) = 0 then
        begin
            ShowMessage(LIdentificacaoPdv.Caption + ' é um campo obrigatório para a inclusão');
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


        if GravaRegistros('TabPdv', True) then
        begin
            VL_Codigo := finterface.IncluirRegistro(MDPdv, '0044', 'S', '008E', VL_Tag);

            if mensagemerro(VL_Codigo, V_Erro) <> 0 then
            begin
                ShowMessage('Erro: ' + IntToStr(VL_Codigo) + #13 + V_Erro);
                if MDPdv.Locate('ID', 0, []) then
                    MDPdv.Delete;
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
                    if MDPdv.Locate('ID', 0, []) then
                        MDPdv.Delete;
                    Exit;
                end;
                '0044':
                begin
                    if VL_Tag <> 'R' then
                    begin
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                        if MDPdv.Locate('ID', 0, []) then
                            MDPdv.Delete;
                        Exit;
                    end;
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    if vl_tag <> '0' then
                    begin
                        mensagemerro(StrToInt(vl_tag), V_Erro);
                        ShowMessage('ERRO:' + VL_Tag + #13 + V_Erro);
                        if MDPdv.Locate('ID', 0, []) then
                            MDPdv.Delete;
                        Exit;
                    end;
                    VL_Mensagem.GetTag('0043', VL_ID); //RETORNO DO ID DO PDV
                    F_Navegar := False;
                    if MDPdv.Locate('ID', 0, []) then
                    begin
                        MDPdv.Edit;
                        MDPdv.FieldByName('ID').AsInteger := VL_ID;
                        MDPdv.Post;
                    end;
                    F_Navegar := True;
                end;
            end;
            MDPdv.Locate('ID', VL_ID, []);
            CarregaCampos;
            ShowMessage('Registro incluido com sucesso');
        end;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;
end;

procedure TFCadPdv.BExcluirClick(Sender: TObject);
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
            finterface.Desconectar;
            Exit;
        end;
        if MDPdv.Active = False then
        begin
            ShowMessage('MDPdv não está ativo');
            Exit;
        end;
        if (length(EID.Text) = 0) or (eid.Text = '0') then
        begin
            ShowMessage('Não existe registro selecionado para exclusão');
            Exit;
        end;

        VL_Codigo := finterface.ExcluirRegistro('0043', StrToInt(EID.Text), '006B', 'S', VL_Tag);

        if mensagemerro(VL_Codigo, V_Erro) <> 0 then
        begin
            ShowMessage('Erro: ' + IntToStr(VL_Codigo) + #13 + V_Erro);
            finterface.Desconectar;
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
                ShowMessage('ERRO:' + IntToStr(VL_ID) + #13 + V_Erro);
                Exit;
            end;
            '006B':
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
                    ShowMessage('ERRO: ' + IntToStr(VL_ID) + #13 + V_Erro);
                    Exit;
                end;
                VL_Mensagem.GetTag('0043', VL_ID);
                F_Navegar := False;
                if MDPdv.Locate('ID', VL_ID, []) then
                    MDPdv.Delete;
                F_Navegar := True;
            end;
        end;
        MDPdv.First;
        CarregaCampos;
        ShowMessage('Registro Excluido com sucesso');
        LimpaTela;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;

end;

procedure TFCadPdv.FormShow(Sender: TObject);
begin
    //prepara a tela
    LimpaTela;
    PagePrincipal.PageIndex := 0;
    TabPdvFuncao.TabVisible := False;
    self.Height := 69;
    CarregarPdv(0, 0);
end;

procedure TFCadPdv.MDPdvFuncaoCalcFields(DataSet: TDataSet);
begin
    if (F_Permissao) then
    begin
        DataSet.FieldByName('VALIDADO_F').AsBoolean := DataSet.FieldByName('VALIDADO').AsBoolean;
        DataSet.FieldByName('HABILITADO_F').AsBoolean := DataSet.FieldByName('HABILITADO').AsBoolean;
    end;
end;

procedure TFCadPdv.MDPdvFuncaoFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin

end;

procedure TFCadPdv.TabPdvFuncaoBVoltarClick(Sender: TObject);
begin
    TabPdvFuncao.TabVisible := False;
    TabPdvModulo.TabVisible := True;
end;

procedure TFCadPdv.TabPdvFuncaoCKSelecionadaChange(Sender: TObject);
begin
    if TabPdvFuncaoCKSelecionada.Checked then
    begin
        MDPdvFuncao.Filter := 'VALIDADO=''T''';
        MDPdvFuncao.Filtered := True;
    end
    else
    begin
        TabPdvFuncaoETipoFiltro.ItemIndex := 0;
        TabPdvFuncaoETipoFiltro.OnChange(SELF);
    end;
end;

procedure TFCadPdv.TabPdvFuncaoEFiltroChange(Sender: TObject);
var
    VL_Filtro: string;
begin
    if F_Permissao = False then
        EXIT;
    VL_Filtro := '';
    MDPdvFuncao.Filter := FInterface.FiltrarTabela(TabPdvFuncaoGrid, VL_Filtro, TabPdvFuncaoEFiltro);
    TabPdvFuncaoLFiltro.Caption := VL_Filtro;
    MDPdvFuncao.Filtered := True;
end;

procedure TFCadPdv.TabPdvFuncaoETipoFiltroChange(Sender: TObject);
begin
    TabPdvFuncaoCKSelecionada.Checked := False;
    if TabPdvFuncaoETipoFiltro.ItemIndex < 1 then
    begin
        MDPdvFuncao.Filter := '';
        MDPdvFuncao.Filtered := False;
    end
    else
    begin
        MDPdvFuncao.Filter := 'TAG_TIPO=''' + TabPdvFuncaoETipoFiltro.Text + '''';
        MDPdvFuncao.Filtered := True;
    end;
end;

procedure TFCadPdv.TabPdvFuncaoGridCellClick(Column: TColumn);
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

    if TabPDVFuncaoGrid.SelectedColumn.FieldName <> 'VALIDADO_F' then
        TabPDVFuncaoLFiltro.Caption := 'Filtrar por ' + TabPDVFuncaoGrid.SelectedColumn.Title.Caption;
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            finterface.Desconectar;
            Exit;
        end;
        if ((MDPdv.Active = False) or (MDPdv.RecordCount < 1)) then
            exit;
        if ((MDPdvFuncao.Active = False) or (MDPdvFuncao.RecordCount < 1)) then
            exit;
        F_Navegar := False;
        if ((TabPDVFuncaoGrid.SelectedColumn.FieldName = 'VALIDADO_F') or
            (TabPDVFuncaoGrid.SelectedColumn.FieldName = 'HABILITADO_F')) then
        begin
            VL_ID := MDPdvFuncaoID.AsInteger;
            VL_Tag := MDPdvFuncaoTAG_NUMERO.AsString;

            if MDPdvFuncao.Filtered then
            begin
                MDPdvFuncao.Filtered := False;
                if VL_ID = 0 then
                    MDPdvFuncao.Locate('TAG_NUMERO', VL_Tag, [])
                else
                    MDPdvFuncao.Locate('ID', VL_ID, []);
            end;

            if (TabPDVFuncaoGrid.SelectedColumn.FieldName = 'VALIDADO_F') then
            begin
                MDPdvFuncao.Edit;
                MDPdvFuncao.FieldByName('VALIDADO').AsBoolean := not MDPdvFuncao.FieldByName('VALIDADO').AsBoolean;
                MDPdvFuncao.Post;
            end;
            if (TabPDVFuncaoGrid.SelectedColumn.FieldName = 'HABILITADO_F') then
            begin
                MDPdvFuncao.Edit;
                MDPdvFuncao.FieldByName('HABILITADO').AsBoolean := not MDPdvFuncao.FieldByName('HABILITADO').AsBoolean;
                MDPdvFuncao.Post;
            end;
            if ((MDPdvFuncao.FieldByName('VALIDADO').AsBoolean = True) and (VL_ID < 1)) then
            begin
                MDPdvFuncao.Edit;
                MDPdvFuncao.FieldByName('PDV_ID').AsString := MDPdv.FieldByName('ID').AsString;
                MDPdvFuncao.FieldByName('ID').AsInteger := 0;
                MDPdvFuncao.Post;
                //incluir PDV função
                VL_Codigo := finterface.IncluirRegistro(MDPdvFuncao, '00C2', 'S', '00C1', VL_Tag);

                if mensagemerro(VL_Codigo, V_Erro) <> 0 then
                begin
                    ShowMessage('Erro: ' + IntToStr(VL_Codigo) + #13 + V_Erro);
                    if MDPdvFuncao.Locate('ID', 0, []) then
                        MDPdvFuncao.Delete;
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
                        if MDPdvFuncao.Locate('ID', 0, []) then
                            MDPdvFuncao.Delete;
                        Exit;
                    end;
                    '00C2':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                            if MDPdvFuncao.Locate('ID', 0, []) then
                                MDPdvFuncao.Delete;
                            Exit;
                        end;
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        if vl_tag <> '0' then
                        begin
                            mensagemerro(StrToInt(VL_Tag), V_Erro);
                            ShowMessage('Erro: ' + VL_Tag + #13 + V_Erro);
                            if MDPdvFuncao.Locate('ID', 0, []) then
                                MDPdvFuncao.Delete;
                            Exit;
                        end;
                        VL_Mensagem.GetTag('00C3', VL_ID); //RETORNO DO ID DO PDV_FUNCAO
                        F_Navegar := False;
                        if MDPdvFuncao.Locate('ID', 0, []) then
                        begin
                            MDPdvFuncao.Edit;
                            MDPdvFuncao.FieldByName('ID').AsInteger := VL_ID;
                            MDPdvFuncao.Post;
                        end;
                        F_Navegar := True;
                    end;
                end;
            end
            else
            if ((MDPdvFuncao.FieldByName('VALIDADO').AsBoolean = True) and (VL_ID > 0)) then
            begin
                //ALTERA PDV_FUNCAO
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00C4', 'S');
                VL_Mensagem.AddTag('00C3', VL_ID);
                VL_Mensagem.AddTag('00C0', MDPdvFuncao.FieldByName('HABILITADO').AsString);
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
                    '00C4':
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
                //alterar PDV função
                VL_Codigo := finterface.ExcluirRegistro('00C3', VL_ID, '00C5', 'S', VL_Tag);

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
                    '00C5':
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
                    MDPdvFuncao.Edit;
                MDPdvFuncao.FieldByName('ID').AsInteger := -1;
                MDPdvFuncao.FieldByName('HABILITADO').AsString := 'F';
                MDPdvFuncao.FieldByName('HABILITADO_F').AsBoolean := False;
                MDPdvFuncao.Post;
            end;
        end;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
        MDPdvFuncao.Filtered := True;
    end;

end;

procedure TFCadPdv.TabPdvModuloBAdicionarClick(Sender: TObject);
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
            FInterface.Desconectar;
            Exit;
        end;
        if MDPdvModulo.Active = False then
        begin
            ShowMessage('MDPdvModulo não está ativo');
            Exit;
        end;
        if length(TabPdvModuloEID.Text) > 0 then
        begin
            ShowMessage('Limpe o cadastro antes de Adicionar um novo Módulo');
            exit;
        end;

        if length(TabPdvModuloEModuloConfID.Text)= 0 then
        begin
            ShowMessage( TabPdvModuloLModuloConf.Caption+' é um campo obrigatório');
            exit;
        end;

        if length(TabPdvModuloETagID.Text)= 0 then
        begin
            ShowMessage(TabPdvModuloLTag.Caption+' é um campo obrigatório');
            exit;
        end;

        if GravaRegistros('TabPdvModulo', True) then
        begin
            VL_Codigo := finterface.IncluirRegistro(MDPdvModulo, '00C8', 'S', '00C7', VL_Tag);

            if mensagemerro(VL_Codigo, V_Erro) <> 0 then
            begin
                ShowMessage('Erro: ' + IntToStr(VL_Codigo) + #13 + V_Erro);
                if MDPdvModulo.Locate('ID', 0, []) then
                    MDPdvModulo.Delete;
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
                    if MDPdvModulo.Locate('ID', 0, []) then
                        MDPdvModulo.Delete;
                    Exit;
                end;
                '00C8':
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
                        if MDPdvModulo.Locate('ID', 0, []) then
                            MDPdvModulo.Delete;
                        Exit;
                    end;
                    VL_Mensagem.GetTag('00C9', VL_ID); //RETORNO DO ID DO PDV_MODULO
                    F_Navegar := False;
                    if MDPdvModulo.Locate('ID', 0, []) then
                    begin
                        MDPdvModulo.Edit;
                        MDPdvModulo.FieldByName('ID').AsInteger := VL_ID;
                        MDPdvModulo.Post;
                    end;
                    F_Navegar := True;
                end;
            end;
            MDPdvModulo.Locate('ID', VL_ID, []);
            CarregaCampos;
            ShowMessage('Registro incluido com sucesso');
        end;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;

end;

procedure TFCadPdv.TabPdvModuloBExcluirClick(Sender: TObject);
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
            finterface.Desconectar;
            Exit;
        end;
        if MDPdvModulo.Active = False then
        begin
            ShowMessage('MDPdvModulo não está ativo');
            Exit;
        end;
        if length(TabPdvModuloEID.Text) = 0 then
        begin
            ShowMessage('Não existe registro selecionado para exclusão');
            Exit;
        end;
        VL_Codigo := finterface.ExcluirRegistro('00C9', StrToInt(TabPdvModuloEID.Text), '00CC', 'S', VL_Tag);

        if mensagemerro(VL_Codigo, V_Erro) <> 0 then
        begin
            ShowMessage('Erro: ' + IntToStr(VL_Codigo) + #13 + V_Erro);
            finterface.Desconectar;
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
                ShowMessage('ERRO:' + IntToStr(VL_ID) + #13 + V_Erro);
                Exit;
            end;
            '00CC':
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
                    ShowMessage('ERRO: ' + IntToStr(VL_ID) + #13 + V_Erro);
                    Exit;
                end;
                VL_Mensagem.GetTag('00C9', VL_ID);
                F_Navegar := False;
                if MDPdvModulo.Locate('ID', VL_ID, []) then
                    MDPdvModulo.Delete;
                F_Navegar := True;
            end;
        end;
        MDPdvModulo.First;
        ShowMessage('Registro Excluido com sucesso');
        CarregaCampos;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;

end;

procedure TFCadPdv.TabPdvModuloBLimparClick(Sender: TObject);
begin
    //limpa modulo pdv
    TabPdvModuloECodigo.Text := '';
    TabPdvModuloEID.Text := '';
    TabPdvModuloEModuloConf.Text := '';
    TabPdvModuloEModuloConfID.Text := '';
    TabPdvModuloETag.Text := '';
    TabPdvModuloETagID.Text := '';
    TabPdvModuloCkHabilitar.Checked := False;
    TabPdvModuloEFiltro.Text := '';
end;

procedure TFCadPdv.TabPdvModuloBModificarClick(Sender: TObject);
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
        finterface.Desconectar;
        Exit;
    end;
    if MDPdvModulo.Active = False then
    begin
        ShowMessage('MDPdvModulo não está ativo');
        Exit;
    end;

    if (length(tabpdvmoduloeid.Text)=0) or (tabpdvmoduloeid.Text='0') then
    begin
        ShowMessage('Não existe registro selecionado para alteração');
        Exit;
    end;

    if GravaRegistros('TabPdvModulo', False) then
    begin
        VL_Codigo := finterface.AlterarRegistro('00C7', MDPdvModulo, '00C9', StrToInt(TabPdvModuloEID.Text), '00CB', 'S', vl_tag);
        if mensagemerro(VL_Codigo, V_Erro) <> 0 then
        begin
            ShowMessage('Erro: ' + IntToStr(VL_Codigo) + #13 + V_Erro);
            finterface.Desconectar;
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
                MDPdvModulo.Locate('ID', StrToInt(TabPdvModuloEID.Text), []);
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
                    ShowMessage('Módulo da Loja alterado com sucesso')
                else
                begin
                    mensagemerro(StrToInt(VL_Tag), V_Erro);
                    ShowMessage('ERRO: ' + VL_Tag + #13 + V_Erro);
                    LimpaTela;
                    Exit;
                end;
            end;
        end;
        MDPdvModulo.Locate('ID', StrToInt(TabPdvModuloEID.Text), []);
        CarregaCampos;
    end;
    VL_Mensagem.Free;
end;

procedure TFCadPdv.TabPdvModuloBPesquisaModuloConfClick(Sender: TObject);
var
    VL_FPesquisaModulo: TFPesquisaModuloConf;
begin
    if ((F_Permissao = False) or (MDPdv.RecordCount < 1)) then
        exit;
    VL_FPesquisaModulo := TFPesquisaModuloConf.Create(Self);
    VL_FPesquisaModulo.F_Tabela := RxMemDataToStr(MDPesquisaModulo);
    VL_FPesquisaModulo.ShowModal;
    if VL_FPesquisaModulo.F_Carregado then
    begin
        TabpdvModuloEModuloConfID.Text := VL_FPesquisaModulo.MDPesquisaModulo.FieldByName('MODULO_CONF_ID').AsString;
        TabPdvModuloEModuloConf.Text := VL_FPesquisaModulo.MDPesquisaModulo.FieldByName('MODULO_CONF_DESCRICAO').AsString;
    end;

end;

procedure TFCadPdv.TabPdvModuloBPesquisaTagClick(Sender: TObject);
var
    VL_FPesquisaTag: TFTags;
begin
    if ((F_Permissao = False) or (MDPdv.RecordCount < 1)) then
        exit;
    VL_FPesquisaTag := TFTags.Create(Self);
    VL_FPesquisaTag.F_Tabela := RxMemDataToStr(MDTags);
    VL_FPesquisaTag.F_TagTipo := TipoTagToStr(Ord(ttNDF));  //TIPO NENHUM
    VL_FPesquisaTag.ShowModal;
    if VL_FPesquisaTag.F_Carregado then
    begin
        TabPdvModuloETagID.Text := VL_FPesquisaTag.MDTags.FieldByName('TAG_NUMERO').AsString;
        TabPdvModuloETag.Text := VL_FPesquisaTag.MDTags.FieldByName('DEFINICAO').AsString;
    end;
end;

procedure TFCadPdv.TabPdvModuloEFiltroChange(Sender: TObject);
var
    VL_Filtro: string;
begin
    if ((F_Permissao = False) or (MDPdvModulo.RecordCount < 1)) then
        EXIT;
    VL_Filtro := '';
    MDPdvModulo.Filter := finterface.FiltrarTabela(TabPdvModuloGrid, VL_Filtro, TabPdvModuloEFiltro);
    TabPdvModuloLFiltro.Caption := VL_Filtro;
    MDPdvModulo.Filtered := True;

end;

procedure TFCadPdv.CarregarPdv(VP_PdvID, VP_ModuloConfID: integer);
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
        VL_Mensagem.AddTag('003C', 0); //loja_id
        VL_Mensagem.AddTag('006E', 0); //tag_id
        VL_Mensagem.AddTag('0054', 0); //pinpad_id
        VL_Mensagem.AddTag('0043', 0); //pdv_id
        VL_Mensagem.AddTag('006C', 0); //modulo_id

        VL_Mensagem.TagToStr(VL_Tag);

        if VP_PdvID = 0 then
            VL_Tag := FInterface.PesquisaTabelas('0070', 'S', '0043', VP_PdvID, VL_Tag)
        else
        if VP_ModuloConfID = 0 then
            VL_Tag := FInterface.PesquisaTabelas('0070', 'S', '0043', VP_PdvID, '')
        else
            VL_Tag := FInterface.PesquisaTabelas('0070', 'S', '00AF', VP_ModuloConfID, '');

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
                //TABELA LOJA
                if VL_Mensagem.GetTag('003E', VL_Tag) = 0 then
                begin
                    if MDLoja.Active then
                        MDLoja.EmptyTable;
                    StrToRxMemData(VL_Tag, MDLoja);
                    MDLoja.Open;
                end;
                //TABELA TAG
                if VL_Mensagem.GetTag('0081', VL_Tag) = 0 then
                begin
                    if MDTags.Active then
                        MDTags.EmptyTable;
                    StrToRxMemData(VL_Tag, MDTags);
                    MDTags.Open;
                end;
                //TABELA PIN-PAD
                if VL_Mensagem.GetTag('008D', VL_Tag) = 0 then
                begin
                    if MDPinPad.Active then
                        MDPinPad.EmptyTable;
                    StrToRxMemData(VL_Tag, MDPinPad);
                    MDPinPad.Open;
                end;
                //TABELA PDV
                if VL_Mensagem.GetTag('008E', VL_Tag) = 0 then
                begin
                    if MDPdv.Active then
                        MDPdv.EmptyTable;
                    StrToRxMemData(VL_Tag, MDPdv);
                    MDPdv.Open;
                end;
                //TABELA PDV-MODULO
                if VL_Mensagem.GetTag('00C7', VL_Tag) = 0 then
                begin
                    if MDPdvModulo.Active then
                        MDPdvModulo.EmptyTable;
                    StrToRxMemData(VL_Tag, MDPdvModulo);
                    MDPdvModulo.Open;
                end;
                //TABELA PDV-FUNÇÃO
                if VL_Mensagem.GetTag('00C1', VL_Tag) = 0 then
                begin
                    if MDPdvFuncao.Active then
                        MDPdvFuncao.EmptyTable;

                    if VL_Tabela.Active then
                        VL_Tabela.EmptyTable;

                    StrToRxMemData(VL_Tag, VL_Tabela);
                    CopiaDadosSimples(VL_Tabela, MDPdvFuncao);
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

procedure TFCadPdv.vincular(VP_AtivarVinculo: boolean);
begin
    if VP_AtivarVinculo then
    begin
        self.Height := 607;
        cloja.Enabled := False;
        cloja.Color := clHighlight;
        BVinculo.Caption := 'Desvincular a Loja';
        BVinculo.ImageIndex := 12;
    end
    else
    begin
        self.Height := 67;
        cloja.Enabled := True;
        cloja.Color := clWindow;
        BVinculo.Caption := 'Vincular a Loja';
        BVinculo.ImageIndex := 10;
    end;
end;

function TFCadPdv.GravaRegistros(VP_Tab: string; VP_Incluir: boolean): boolean;
var
    VL_ID: integer;
begin
    Result := False;
    F_Navegar := False;
    try
        //grava TabPdv
        if VP_Tab = 'TabPdv' then
        begin
            if not (F_Permissao) then
            begin
                ShowMessage('Sem Permissão de Gravação, usuário apenas de leitura');
                F_Navegar := True;
                exit;
            end;
            if (VP_Incluir) and (EID.Text <> '') then
            begin
                ShowMessage('Para incluir um novo PDV, limpe a tela e inicie a inclusão');
                exit;
            end;

            if VP_Incluir then
                VL_ID := 0
            else
                VL_ID := MDPdv.FieldByName('ID').AsInteger;

            if VP_Incluir then
                MDPdv.Insert
            else
                MDPdv.Edit;

            MDPdv.FieldByName('ID').AsInteger := VL_ID;
            MDLoja.Locate('RAZAO', CLoja.KeyValue, []);
            MDPdv.FieldByName('LOJA_ID').AsInteger := MDLoja.FieldByName('ID').AsInteger;
            if not (CPinPad.Value = '') then
                if MDPinPad.Locate('FABRICANTE_MODELO', CPinPad.KeyValue, []) then
                    MDPdv.FieldByName('PINPAD_ID').AsInteger := MDPinPad.FieldByName('ID').AsInteger
                else
                    MDPdv.FieldByName('PINPAD_ID').AsInteger := 0;

            MDPdv.FieldByName('IP').AsString := EIP.Text;
            MDPdv.FieldByName('DESCRICAO').AsString := EDescricao.Text;
            MDPdv.FieldByName('IDENTIFICADOR_PDV').AsString := EIdentificadorPdv.Text;
            MDPdv.FieldByName('PINPAD_COM').AsString := EPinPadCom.Text;
            MDPdv.FieldByName('IDENTIFICADOR').AsString := EIdentificador.Text;
            MDPdv.FieldByName('CHAVE_COMUNICACAO').AsString := EChave.Text;
            if CkHabilitar.Checked then
                MDPdv.FieldByName('HABILITADO').AsString := 'T'
            else
                MDPdv.FieldByName('HABILITADO').AsString := 'F';

            MDPdv.Post;
            Result := True;
        end
        else
        //grava TabPdvModulo
        if VP_Tab = 'TabPdvModulo' then
        begin
            if not (F_Permissao) then
            begin
                ShowMessage('Sem Permissão de Gravação, usuário apenas de leitura');
                F_Navegar := True;
                exit;
            end;
            if VP_Incluir then
                VL_ID := 0
            else
                VL_ID := MDPdvModulo.FieldByName('ID').AsInteger;

            if VP_Incluir then
                MDPdvModulo.Insert
            else
                MDPdvModulo.Edit;

            MDPdvModulo.FieldByName('ID').AsInteger := VL_ID;
            MDPdvModulo.FieldByName('PDV_ID').AsInteger := MDPdv.FieldByName('ID').AsInteger;
            MDPdvModulo.FieldByName('TAG_NUMERO').AsString := TabPdvModuloETagID.Text;
            MDPdvModulo.FieldByName('DEFINICAO').AsString := TabPdvModuloETag.Text;
            MDPdvmodulo.FieldByName('CODIGO').AsString := TabPdvModuloECodigo.Text;
            if MDPesquisaModulo.locate('MODULO_CONF_ID', TabPdvModuloEModuloConfID.Text, []) then
                MDPdvModulo.FieldByName('MODULO').AsString := MDPesquisaModulo.FieldByName('MODULO_DESCRICAO').AsString;
            MDPdvModulo.FieldByName('MODULO_CONF_ID').AsString := TabPdvModuloEModuloConfID.Text;
            MDPdvModulo.FieldByName('MODULO_CONF').AsString := TabPdvModuloEModuloConf.Text;
            if TabPdvModuloCkHabilitar.Checked then
                MDPdvModulo.FieldByName('HABILITADO').AsString := 'T'
            else
                MDPdvModulo.FieldByName('HABILITADO').AsString := 'F';
            MDPdvModulo.Post;
            Result := True;
        end;
    finally
        F_Navegar := True;
    end;
end;

procedure TFCadPdv.LimpaTela;
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
                    if ((TRxMemoryData(Components[i]) <> TRxMemoryData(MDPesquisaModulo)) and
                        (TRxMemoryData(Components[i]) <> TRxMemoryData(MDLoja)) and
                        (TRxMemoryData(Components[i]) <> TRxMemoryData(MDPinPad)) and
                        (TRxMemoryData(Components[i]) <> TRxMemoryData(MDTags))) then
                        TRxMemoryData(Components[i]).EmptyTable;
        end;
    end;

end;

procedure TFCadPdv.CarregaCampos;
begin
    //CARREGA OS CAMPOS
    if F_Navegar = False then
        exit;
    //CARREGA PDV
    if MDPdv.FieldByName('HABILITADO').AsString = 'T' then
        CkHabilitar.Checked := True
    else
        CkHabilitar.Checked := False;

    if MDPinPad.Locate('ID', MDPdv.FieldByName('PINPAD_ID').AsInteger, []) then
    begin
        CPinPad.KeyValue := MDPinPad.FieldByName('FABRICANTE_MODELO').AsVariant;
    end
    else
    begin
        CPinPad.KeyValue := 'Não Definido';
    end;
    EID.Text := MDPdv.FieldByName('ID').AsString;
    EDescricao.Text := MDPdv.FieldByName('DESCRICAO').AsString;
    EIdentificador.Text := MDPdv.FieldByName('IDENTIFICADOR').AsString;
    EIdentificadorPdv.Text := MDPdv.FieldByName('IDENTIFICADOR_PDV').AsString;
    EIP.Text := MDPdv.FieldByName('IP').AsString;
    EPinPadCom.Text := MDPdv.FieldByName('PINPAD_COM').AsString;
    EChave.Lines.Text := MDPdv.FieldByName('CHAVE_COMUNICACAO').AsString;

    //CARREGA LOJA-MODULO /LOJA-FUNCAO
    if ((MDPdvModulo.Active = False) or (MDPdvModulo.RecordCount = 0)) then
        CarregarPdv(MDPdv.FieldByName('ID').AsInteger, 0);

    TabPdvModuloEID.Text := MDPdvModulo.FieldByName('ID').AsString;
    TabPdvModuloECodigo.Text := MDPdvModulo.FieldByName('CODIGO').AsString;
    if MDPdvModulo.FieldByName('HABILITADO').AsString = 'T' then
        TabPdvModuloCkHabilitar.Checked := True
    else
        TabPdvModuloCkHabilitar.Checked := False;

    TabPdvModuloETagID.Text := MDPdvModulo.FieldByName('TAG_NUMERO').AsString;
    TabPdvModuloETag.Text := MDPdvModulo.FieldByName('DEFINICAO').AsString;
    TabPdvModuloEModuloConfID.Text := MDPdvModulo.FieldByName('MODULO_CONF_ID').AsString;
    TabPdvModuloEModuloConf.Text := MDPdvModulo.FieldByName('MODULO_CONF').AsString;
end;

end.
