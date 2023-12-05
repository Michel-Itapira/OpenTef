unit ucadloja;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils, DB, Forms, funcoes, Controls, Graphics, Dialogs, ExtCtrls,
    StdCtrls, Buttons, DBGrids, ComCtrls, MaskEdit, RxDBGrid, rxlookup, rxmemds;

type

    { TFCadLoja }

    TFCadLoja = class(TForm)
        DSLoja: TDataSource;
        DSLojaFuncao: TDataSource;
        DSLojaModuloConf: TDataSource;
        DSLojaModuloConfFuncao: TDataSource;
        DSMultiLojaLoja: TDataSource;
        DSPesquisaModulo: TDataSource;
        MDLojaFuncao: TRxMemoryData;
        MDLojaFuncaoDEFINICAO: TStringField;
        MDLojaFuncaoHABILITADO: TStringField;
        MDLojaFuncaoHABILITADO_F: TBooleanField;
        MDLojaFuncaoID: TLargeintField;
        MDLojaFuncaoLOJA_ID: TLargeintField;
        MDLojaFuncaoTAG_NUMERO: TStringField;
        MDLojaFuncaoTAG_TIPO: TStringField;
        MDLojaFuncaoVALIDADO: TStringField;
        MDLojaFuncaoVALIDADO_F: TBooleanField;
        MDLojaModuloConf: TRxMemoryData;
        MDLojaModuloConfFuncao: TRxMemoryData;
        MDLojaModuloConfFuncaoDEFINICAO: TStringField;
        MDLojaModuloConfFuncaoHABILITADO: TStringField;
        MDLojaModuloConfFuncaoHABILITADO_F: TBooleanField;
        MDLojaModuloConfFuncaoID: TLargeintField;
        MDLojaModuloConfFuncaoLOJA_MODULO_CONF_ID: TLargeintField;
        MDLojaModuloConfFuncaoTAG_NUMERO: TStringField;
        MDLojaModuloConfFuncaoTAG_TIPO: TStringField;
        MDLojaModuloConfFuncaoVALIDADO: TStringField;
        MDLojaModuloConfFuncaoVALIDADO_F: TBooleanField;
        MDMultiLojaLoja: TRxMemoryData;
        MDPesquisaModulo: TRxMemoryData;
        PagePrincipal: TPageControl;
        PTitulo: TPanel;
        Panel2: TPanel;
        PCadastro: TPanel;
        Panel4: TPanel;
        Panel5: TPanel;
        BAdicionar: TBitBtn;
        BExcluir: TBitBtn;
        BPesquisar: TBitBtn;
        BLimpar: TBitBtn;
        BModificar: TBitBtn;
        CkHabilitar: TCheckBox;
        CkPessoa: TCheckBox;
        CMultLoja: TRxDBLookupCombo;
        ECnpj: TMaskEdit;
        EFantasia: TEdit;
        EID: TEdit;
        ERazao: TEdit;
        MDLoja: TRxMemoryData;
        TabModuloFuncaoBVoltar: TBitBtn;
        TabLojaFuncaoCKSelecionada: TCheckBox;
        TabLojaFuncaoBVoltar: TBitBtn;
        TabModuloFuncaoCKSelecionada: TCheckBox;
        TabLojaFuncaoEFiltro: TEdit;
        TabModuloFuncaoEFiltro: TEdit;
        TabLojaFuncaoETipoFiltro: TComboBox;
        TabModuloFuncaoETipoFiltro: TComboBox;
        TabLojaFuncaoGrid: TRxDBGrid;
        TabModuloFuncaoGrid: TRxDBGrid;
        TabLojaFuncaoLFiltro: TLabel;
        TabModuloFuncaoLFiltro: TLabel;
        TabLojaFuncaoLTipoFiltro: TLabel;
        TabModuloFuncaoLTipoFiltro: TLabel;
        LCnpj: TLabel;
        LFantasia: TLabel;
        LID: TLabel;
        LMultLoja: TLabel;
        LRazao: TLabel;
        LTitulo: TLabel;
        TabLojaModuloBAdicionar: TBitBtn;
        BFuncaoLoja: TBitBtn;
        TabLojaModuloBFuncaoModulo: TBitBtn;
        TabLojaModuloBExcluir: TBitBtn;
        TabLojaModuloBLimpar: TBitBtn;
        TabLojaModuloBModificar: TBitBtn;
        TabLojaModuloBPesquisaModuloConf: TBitBtn;
        TabLojaModuloCkHabilitar: TCheckBox;
        TabLojaModuloECodigo: TEdit;
        TabLojaModuloEFiltro: TEdit;
        TabLojaModuloEID: TEdit;
        TabLojaModuloEModuloConf: TEdit;
        TabLojaModuloEModuloConfID: TEdit;
        TabLojaModuloGrid: TRxDBGrid;
        TabLojaModuloLCodigo: TLabel;
        TabLojaModuloLFiltro: TLabel;
        TabLojaModuloLID: TLabel;
        TabLojaModuloLModuloConf: TLabel;
        TabLojaModulo: TTabSheet;
        TabLojaFuncao: TTabSheet;
        TabModuloFuncao: TTabSheet;
        procedure BAdicionarClick(Sender: TObject);
        procedure BExcluirClick(Sender: TObject);
        procedure BFuncaoLojaClick(Sender: TObject);
        procedure BLimparClick(Sender: TObject);
        procedure BModificarClick(Sender: TObject);
        procedure BPesquisarClick(Sender: TObject);
        procedure CkPessoaClick(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure MDLojaFuncaoCalcFields(DataSet: TDataSet);
        procedure MDLojaFuncaoFilterRecord(DataSet: TDataSet; var Accept: boolean);
        procedure MDLojaModuloConfAfterScroll(DataSet: TDataSet);
        procedure MDLojaModuloConfFuncaoCalcFields(DataSet: TDataSet);
        procedure MDLojaModuloConfFuncaoFilterRecord(DataSet: TDataSet; var Accept: boolean);
        procedure MDPesquisaModuloFilterRecord(DataSet: TDataSet; var Accept: boolean);
        procedure TabLojaFuncaoBVoltarClick(Sender: TObject);
        procedure TabLojaFuncaoCKSelecionadaChange(Sender: TObject);
        procedure TabLojaFuncaoEFiltroChange(Sender: TObject);
        procedure TabLojaFuncaoETipoFiltroChange(Sender: TObject);
        procedure TabLojaFuncaoGridCellClick(Column: TColumn);
        procedure TabLojaModuloBAdicionarClick(Sender: TObject);
        procedure TabLojaModuloBExcluirClick(Sender: TObject);
        procedure TabLojaModuloBFuncaoModuloClick(Sender: TObject);
        procedure TabLojaModuloBLimparClick(Sender: TObject);
        procedure TabLojaModuloBModificarClick(Sender: TObject);
        procedure TabLojaModuloBPesquisaModuloConfClick(Sender: TObject);
        procedure TabLojaModuloEFiltroChange(Sender: TObject);
        procedure TabLojaModuloGridColEnter(Sender: TObject);
        procedure TabLojaModuloGridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
        procedure TabModuloFuncaoBVoltarClick(Sender: TObject);
        procedure TabModuloFuncaoCKSelecionadaChange(Sender: TObject);
        procedure TabModuloFuncaoEFiltroChange(Sender: TObject);
        procedure TabModuloFuncaoETipoFiltroChange(Sender: TObject);
        procedure TabModuloFuncaoGridCellClick(Column: TColumn);
    private
        procedure CarregarLoja(VP_LojaID, VP_ModuloConfID: integer);
        function GravaRegistros(VP_Tab: string; VP_Incluir: boolean = False): boolean;
    public
        V_Erro: PChar;
        procedure LimpaTela;
        procedure CarregaCampos;
    end;

var
    FCadLoja: TFCadLoja;

implementation

{$R *.lfm}
uses
    uinterface, uPesquisamoduloconf, upesquisaloja;

{ TFCadLoja }

procedure TFCadLoja.BLimparClick(Sender: TObject);
begin
    LimpaTela;
    PagePrincipal.PageIndex := 0;
    TabLojaModulo.TabVisible := True;
    TabLojaFuncao.TabVisible := False;
    TabModuloFuncao.TabVisible := False;
end;

procedure TFCadLoja.BModificarClick(Sender: TObject);
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
    if MDLoja.Active = False then
    begin
        ShowMessage('MDLoja não está ativo');
        Exit;
    end;
    if ECnpj.Text = '' then
    begin
        ShowMessage(LCnpj.Caption + ' é um campo obrigatório');
        exit;
    end;
    if ERazao.Text = '' then
    begin
        ShowMessage(LRazao.Caption + ' é um campo obrigatório');
        exit;
    end;

    if MDLoja.FieldByName('MULT').AsString = 'T' then
    begin
        ShowMessage('Esta Loja esta configurada como Mult-Loja Master,' + #13 + 'todas as alterações irão impactar em suas gerenciadas.');
    end;

    if (CMultLoja.Text = '') then
    begin
        ShowMessage('Você deve selecionar uma Mult-Loja para incluir a Loja');
        exit;
    end;

    if GravaRegistros('TabLoja', False) then
    begin
        VL_Codigo := finterface.AlterarRegistro('003E', MDLoja, '003C', StrToInt(EID.Text), '003F', 'S', vl_tag);

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
                mdloja.Locate('ID', StrToInt(EID.Text), []);
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
        mdloja.Locate('ID', StrToInt(EID.Text), []);
        CarregaCampos;
        VL_Mensagem.Free;
    end;
end;

procedure TFCadLoja.BPesquisarClick(Sender: TObject);
var
    VL_FPesquisaLoja: TFPesquisaLoja;
begin
    if F_Permissao = False then
        exit;
    CarregarLoja(0, 0);
    VL_FPesquisaLoja := TFPesquisaLoja.Create(Self);
    VL_FPesquisaLoja.F_Tabela := RxMemDataToStr(MDLoja);
    LimpaTela;
    VL_FPesquisaLoja.ShowModal;
    if VL_FPesquisaLoja.F_Carregado then
    begin
        CarregarLoja(VL_FPesquisaLoja.MDPesquisaLoja.FieldByName('ID').AsInteger, 0);
        CarregaCampos;
    end;
end;

procedure TFCadLoja.CkPessoaClick(Sender: TObject);
begin
    if CkPessoa.Checked then
    begin
        LCnpj.Caption := 'C.P.F:';
        LFantasia.Caption := 'Apelido (nome usado nos relatórios)';
        LRazao.Caption := 'Nome:';
        ECnpj.EditMask := '999.999.999-99;0;_';
    end
    else
    begin
        LCnpj.Caption := 'C.N.P.J:';
        LFantasia.Caption := 'Fantasia';
        LRazao.Caption := 'Razão:';
        ECnpj.EditMask := '99.999.999/9999-99;0;_';
    end;
end;

procedure TFCadLoja.BFuncaoLojaClick(Sender: TObject);
begin
    if ((F_Navegar) and (F_Permissao) and (MDLoja.RecordCount > 0)) then
    begin
        CarregarLoja(MDLoja.FieldByName('ID').AsInteger, 0);
        TabLojaFuncaoETipoFiltro.ItemIndex := 0;
        TabLojaFuncaoCKSelecionada.Checked := False;
        TabLojaFuncaoETipoFiltro.OnChange(self);
    end
    else
        MDLojaFuncao.EmptyTable;

    TabLojaFuncao.TabVisible := True;
    TabModuloFuncao.TabVisible := False;
    TabLojaModulo.TabVisible := False;
end;

procedure TFCadLoja.BAdicionarClick(Sender: TObject);
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
        if LENGTH(EID.Text) > 0 then
        begin
            ShowMessage('Limpe o cadastro antes de Adicionar uma loja');
            exit;
        end;
        if ECnpj.Text = '' then
        begin
            ShowMessage(LCnpj.Caption + ' é um campo obrigatório');
            exit;
        end;
        if ERazao.Text = '' then
        begin
            ShowMessage(LRazao.Caption + ' é um campo obrigatório');
            exit;
        end;
        if (CMultLoja.Text = '') then
        begin
            ShowMessage('Você deve selecionar uma Mult-Loja para incluir a Loja');
            exit;
        end;
        if GravaRegistros('TabLoja', True) then
        begin
            VL_Codigo := finterface.IncluirRegistro(MDLoja, '0039', 'S', '003E', VL_Tag);

            if mensagemerro(VL_Codigo, V_Erro) <> 0 then
            begin
                ShowMessage('Erro: ' + IntToStr(VL_Codigo) + #13 + V_Erro);
                if MDLoja.Locate('ID', 0, []) then
                    MDLoja.Delete;
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
                    if MDLoja.Locate('ID', 0, []) then
                        MDLoja.Delete;
                    Exit;
                end;
                '0039':
                begin
                    if VL_Tag <> 'R' then
                    begin
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                        if MDLoja.Locate('ID', 0, []) then
                            MDLoja.Delete;
                        Exit;
                    end;
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    if vl_tag <> '0' then
                    begin
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        mensagemerro(StrToInt(VL_Tag), V_Erro);
                        ShowMessage('ERRO: ' + VL_Tag + #13 + V_Erro);
                        if MDLoja.Locate('ID', 0, []) then
                            MDLoja.Delete;
                        Exit;
                    end;
                    VL_Mensagem.GetTag('003C', VL_ID); //RETORNO DO ID DA LOJA
                    F_Navegar := False;
                    if MDLoja.Locate('ID', 0, []) then
                    begin
                        MDLoja.Edit;
                        MDLoja.FieldByName('ID').AsInteger := VL_ID;
                        MDLoja.Post;
                    end;
                    F_Navegar := True;
                end;
            end;
            MDLoja.Locate('ID', VL_ID, []);
            CarregaCampos;
            ShowMessage('Registro incluido com sucesso');
        end;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;

end;

procedure TFCadLoja.BExcluirClick(Sender: TObject);
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
        if MDLoja.Active = False then
        begin
            ShowMessage('MDLoja não está ativo');
            Exit;
        end;
        if length(EID.Text) = 0 then
        begin
            ShowMessage('Não existe registro selecionado para exclusão');
            Exit;
        end;

        MDLoja.Locate('ID', EID.Text, []);

        if MDLoja.FieldByName('MULT').AsString = 'T' then
        begin
            ShowMessage('Esta Loja esta configurada como Mult-Loja Master,não podera sofrer alteração');
            exit;
        end;
        VL_Codigo := finterface.ExcluirRegistro('003C', StrToInt(EID.Text), '0069', 'S', VL_Tag);

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
                ShowMessage('ERRO: ' + IntToStr(VL_ID) + #13 + V_Erro);
                Exit;
            end;
            '0069':
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
                F_Navegar := False;
                if MDLoja.Locate('ID', EID.Text, []) then
                    MDLoja.Delete;
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

procedure TFCadLoja.FormCreate(Sender: TObject);
begin
    MDLojaFuncao.Open;
    MDLojaModuloConfFuncao.Open;
    CarregarLoja(0, 0);
    Width := 776;
    Height := 530;
end;

procedure TFCadLoja.FormShow(Sender: TObject);
begin
    //prepara a tela
    LimpaTela;
    PagePrincipal.PageIndex := 0;
    TabLojaFuncao.TabVisible := False;
    TabModuloFuncao.TabVisible := False;
    CMultLoja.KeyValue := MDMultiLojaLoja.FieldByName('RAZAO').AsVariant;
end;

procedure TFCadLoja.MDLojaFuncaoCalcFields(DataSet: TDataSet);
begin
    if (F_Permissao) then
    begin
        DataSet.FieldByName('VALIDADO_F').AsBoolean := DataSet.FieldByName('VALIDADO').AsBoolean;
        DataSet.FieldByName('HABILITADO_F').AsBoolean := DataSet.FieldByName('HABILITADO').AsBoolean;
    end;
end;

procedure TFCadLoja.MDLojaFuncaoFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin

end;

procedure TFCadLoja.MDLojaModuloConfAfterScroll(DataSet: TDataSet);
begin
    if ((MDLojaModuloConf.Active = False) or (MDLojaModuloConf.RecordCount < 1)) then
        exit;
    CarregaCampos;
end;

procedure TFCadLoja.MDLojaModuloConfFuncaoCalcFields(DataSet: TDataSet);
begin
    if (F_Permissao) then
    begin
        DataSet.FieldByName('VALIDADO_F').AsBoolean := DataSet.FieldByName('VALIDADO').AsBoolean;
        DataSet.FieldByName('HABILITADO_F').AsBoolean := DataSet.FieldByName('HABILITADO').AsBoolean;
    end;
end;

procedure TFCadLoja.MDLojaModuloConfFuncaoFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin

end;

procedure TFCadLoja.MDPesquisaModuloFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin

end;

procedure TFCadLoja.TabLojaFuncaoBVoltarClick(Sender: TObject);
begin
    TabLojaFuncao.TabVisible := False;
    TabModuloFuncao.TabVisible := False;
    TabLojaModulo.TabVisible := True;
end;

procedure TFCadLoja.TabLojaFuncaoCKSelecionadaChange(Sender: TObject);
begin
    if TabLojaFuncaoCKSelecionada.Checked then
    begin
        MDLojaFuncao.Filter := 'VALIDADO=''T''';
        MDLojaFuncao.Filtered := True;
    end
    else
    begin
        TabLojaFuncaoETipoFiltro.ItemIndex := 0;
        TabLojaFuncaoETipoFiltro.OnChange(SELF);
    end;
end;

procedure TFCadLoja.TabLojaFuncaoEFiltroChange(Sender: TObject);
var
    VL_Filtro: string;
begin
    if F_Permissao = False then
        EXIT;
    VL_Filtro := '';
    MDLojaFuncao.Filter := FInterface.FiltrarTabela(TabLojaFuncaoGrid, VL_Filtro, TabLojaFuncaoEFiltro);
    TabLojaFuncaoLFiltro.Caption := VL_Filtro;
    MDLojaFuncao.Filtered := True;

end;

procedure TFCadLoja.TabLojaFuncaoETipoFiltroChange(Sender: TObject);
begin
    TabLojaFuncaoCKSelecionada.Checked := False;
    if TabLojaFuncaoETipoFiltro.ItemIndex < 1 then
    begin
        MDLojaFuncao.Filter := '';
        MDLojaFuncao.Filtered := False;
    end
    else
    begin
        MDLojaFuncao.Filter := 'TAG_TIPO=''' + TabLojaFuncaoETipoFiltro.Text + '''';
        MDLojaFuncao.Filtered := True;
    end;
end;

procedure TFCadLoja.TabLojaFuncaoGridCellClick(Column: TColumn);
var
    VL_Status: integer;
    VL_Mensagem: TMensagem;
    VL_Codigo: integer;
    VL_ID: int64;
    VL_Retorno, VL_Tag, VL_Validado, VL_Habilitado: string;
label
    sair;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    VL_Validado := '';
    VL_Habilitado := '';

    if TabLojaFuncaoGrid.SelectedColumn.FieldName <> 'VALIDADO_F' then
        TabLojaFuncaoLFiltro.Caption := 'Filtrar por ' + TabLojaFuncaoGrid.SelectedColumn.Title.Caption;
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            FInterface.Desconectar;
            Exit;
        end;
        if (MDLoja.Active = False) then
            exit;
        if (MDLojaFuncao.Active = False) then
            exit;
        F_Navegar := False;
        if ((TabLojaFuncaoGrid.SelectedColumn.FieldName = 'VALIDADO_F') or
            (TabLojaFuncaoGrid.SelectedColumn.FieldName = 'HABILITADO_F')) then
        begin
            VL_ID := MDLojaFuncaoID.AsInteger;
            VL_Tag := MDLojaFuncaoTAG_NUMERO.AsString;
            VL_Validado := copy(BoolToStr(MDLojaFuncao.FieldByName('VALIDADO_F').AsBoolean, True), 0, 1);
            VL_Habilitado := copy(BoolToStr(MDLojaFuncao.FieldByName('HABILITADO_F').AsBoolean, True), 0, 1);

            if MDLojaFuncao.Filtered then
            begin
                MDLojaFuncao.Filtered := False;
                if VL_ID = 0 then
                    MDLojaFuncao.Locate('TAG_NUMERO', VL_Tag, [])
                else
                    MDLojaFuncao.Locate('ID', VL_ID, []);
            end;

            if (TabLojaFuncaoGrid.SelectedColumn.FieldName = 'VALIDADO_F') then
            begin
                MDLojaFuncao.Edit;
                MDLojaFuncao.FieldByName('VALIDADO').AsString := VL_Validado;
                MDLojaFuncao.Post;
            end;
            if (TabLojaFuncaoGrid.SelectedColumn.FieldName = 'HABILITADO_F') then
            begin
                MDLojaFuncao.Edit;
                MDLojaFuncao.FieldByName('HABILITADO').AsString := VL_Habilitado;
                MDLojaFuncao.Post;
            end;

            if ((MDLojaFuncao.FieldByName('VALIDADO').AsString = 'T') and (VL_ID < 1)) then
            begin
                MDLojaFuncao.Edit;
                MDLojaFuncao.FieldByName('LOJA_ID').AsString := MDLoja.FieldByName('ID').AsString;
                MDLojaFuncao.FieldByName('ID').AsInteger := 0;
                MDLojaFuncao.Post;
                //incluir LOJA função
                VL_Codigo := FInterface.IncluirRegistro(MDLojaFuncao, '00AA', 'S', '00A7', VL_Tag);
                if mensagemerro(VL_Codigo, V_Erro) <> 0 then
                begin
                    ShowMessage('Erro:' + IntToStr(VL_Codigo) + #13 + V_Erro);
                    if MDLojaFuncao.Locate('ID', 0, []) then
                        MDLojaFuncao.Delete;
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
                        if MDLojaFuncao.Locate('ID', 0, []) then
                            MDLojaFuncao.Delete;
                        Exit;
                    end;
                    '00AA':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                            if MDLojaFuncao.Locate('ID', 0, []) then
                                MDLojaFuncao.Delete;
                            Exit;
                        end;
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        if vl_tag <> '0' then
                        begin
                            mensagemerro(StrToInt(VL_Tag), V_erro);
                            ShowMessage('ERRO:' + VL_Tag + V_Erro);
                            if MDLojaFuncao.Locate('ID', 0, []) then
                                MDLojaFuncao.Delete;
                            Exit;
                        end;
                        VL_Mensagem.GetTag('00AB', VL_ID); //RETORNO DO ID DO LOJA_FUNCAO
                        F_Navegar := False;
                        if MDLojaFuncao.Locate('ID', 0, []) then
                        begin
                            MDLojaFuncao.Edit;
                            MDLojaFuncao.FieldByName('ID').AsInteger := VL_ID;
                            MDLojaFuncao.Post;
                        end;
                        F_Navegar := True;
                    end;
                end;
            end
            else
            if ((MDLojaFuncao.FieldByName('VALIDADO').AsString = 'T') and (VL_ID > 0)) then
            begin
                //ALTERA LOJA_FUNCAO
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00AC', 'S');
                VL_Mensagem.AddTag('00AB', VL_ID);
                VL_Mensagem.AddTag('00A8', MDLojaFuncao.FieldByName('HABILITADO').AsString);
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
                        ShowMessage('ERRO:' + VL_Tag + #13 + V_Erro);
                        Exit;
                    end;
                    '00AC':
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
                            ShowMessage('ERRO: ' + VL_Tag + #13 + V_Erro);
                            Exit;
                        end;
                    end;
                end;
            end
            else
            begin
                //EXCLUIR multloja função
                VL_Codigo := finterface.ExcluirRegistro('00AB', VL_ID, '00AD', 'S', VL_Tag);

                if mensagemerro(vL_Codigo, V_Erro) <> 0 then
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
                        ShowMessage('ERRO: ' + VL_Tag + #13 + V_Erro);
                    end;
                    '00AD':
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
                                ShowMessage('ERRO: ' + VL_Tag + #13 + V_Erro);
                            end;
                        end;
                    end;
                end;
                sair:
                    MDLojaFuncao.Edit;
                MDLojaFuncao.FieldByName('ID').AsInteger := -1;
                MDLojaFuncao.FieldByName('HABILITADO').AsString := 'F';
                MDLojaFuncao.FieldByName('HABILITADO_F').AsBoolean := False;
                MDLojaFuncao.Post;
            end;
        end;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
        MDLojaFuncao.Filtered := True;
    end;

end;

procedure TFCadLoja.TabLojaModuloBAdicionarClick(Sender: TObject);
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
        if MDLojaModuloConf.Active = False then
        begin
            ShowMessage('MDLojaModulo não está ativo');
            Exit;
        end;
        if length(TabLojaModuloEID.Text) > 0 then
        begin
            ShowMessage('Para Adicionar um módulo, Limpe antes o Cadastro');
            exit;
        end;
        if length(TabLojaModuloEModuloConfID.Text) < 1 then
        begin
            ShowMessage('Nenhuma configuração foi selecionada para Adicionar um módulo');
            exit;
        end;

        if GravaRegistros('TabLojaModulo', True) then
        begin
            VL_Codigo := finterface.IncluirRegistro(MDLojaModuloConf, '00AE', 'S', '00A7', VL_Tag);

            if mensagemerro(VL_Codigo, V_Erro) <> 0 then
            begin
                ShowMessage('Erro: ' + IntToStr(VL_Codigo) + #13 + V_Erro);
                if MDLojaModuloConf.Locate('ID', 0, []) then
                    MDLojaModuloConf.Delete;
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
                    if MDLojaModuloConf.Locate('ID', 0, []) then
                        MDLojaModuloConf.Delete;
                    Exit;
                end;
                '00AE':
                begin
                    if VL_Tag <> 'R' then
                    begin
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                        if MDLojaModuloConf.Locate('ID', 0, []) then
                            MDLojaModuloConf.Delete;
                        Exit;
                    end;
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    if vl_tag <> '0' then
                    begin
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        mensagemerro(StrToInt(VL_Tag), V_Erro);
                        ShowMessage('ERRO: ' + VL_Tag + #13 + V_Erro);
                        if MDLojaModuloConf.Locate('ID', 0, []) then
                            MDLojaModuloConf.Delete;
                        Exit;
                    end;
                    VL_Mensagem.GetTag('00AF', VL_ID); //RETORNO DO ID DO LOJA_MODULO_ID
                    F_Navegar := False;
                    if MDLojaModuloConf.Locate('ID', 0, []) then
                    begin
                        MDLojaModuloConf.Edit;
                        MDLojaModuloConf.FieldByName('ID').AsInteger := VL_ID;
                        MDLojaModuloConf.Post;
                    end;
                    F_Navegar := True;
                end;
            end;
            MDLojaModuloConf.Locate('ID', VL_ID, []);
            ShowMessage('Registro incluido com sucesso');
        end;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;

end;

procedure TFCadLoja.TabLojaModuloBExcluirClick(Sender: TObject);
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
            FINTERFACE.Desconectar;
            Exit;
        end;
        if MDLojaModuloConf.Active = False then
        begin
            ShowMessage('MDLojaModulo não está ativo');
            Exit;
        end;
        if length(TabLojaModuloEID.Text) = 0 then
        begin
            ShowMessage('Não existe registro selecionado para exclusão');
            Exit;
        end;
        VL_Codigo := FINTERFACE.ExcluirRegistro('00AF', StrToInt(TabLojaModuloEID.Text), '00B2', 'S', VL_Tag);

        if mensagemerro(VL_Codigo, V_Erro) <> 0 then
        begin
            ShowMessage('Erro: ' + IntToStr(VL_Codigo) + #13 + V_Erro);
            FINTERFACE.Desconectar;
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
            '00B2':
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
                    mensagemerro(StrToInt(VL_Tag), V_Erro);
                    ShowMessage('ERRO: ' + IntToStr(VL_ID) + #13 + V_Erro);
                    Exit;
                end;
                VL_Mensagem.GetTag('00AF', VL_ID);
                F_Navegar := False;
                if MDLojaModuloConf.Locate('ID', VL_ID, []) then
                    MDLojaModuloConf.Delete;
                F_Navegar := True;
            end;
        end;
        if MDLojaModuloConf.RecordCount = 0 then
            MDLojaModuloConf.EmptyTable;

        ShowMessage('Registro Excluido com sucesso');
        CarregaCampos;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;

end;

procedure TFCadLoja.TabLojaModuloBFuncaoModuloClick(Sender: TObject);
begin
    if (TabLojaModuloEID.Text = '') then
        exit;

    if ((F_Navegar) and (F_Permissao) and (MDLojaModuloConf.RecordCount > 0)) then
    begin
        CarregarLoja(MDLoja.FieldByName('ID').AsInteger, MDLojaModuloConf.FieldByName('ID').AsInteger);
        TabModuloFuncaoETipoFiltro.ItemIndex := 0;
        TabModuloFuncaoCKSelecionada.Checked := False;
        TabModuloFuncaoETipoFiltro.OnChange(SELF);
    end
    else
        MDLojaModuloConfFuncao.EmptyTable;

    TabLojaFuncao.TabVisible := False;
    TabModuloFuncao.TabVisible := True;
    TabLojaModulo.TabVisible := False;
end;

procedure TFCadLoja.TabLojaModuloBLimparClick(Sender: TObject);
begin
    //limpa modulo loja
    TabLojaModuloECodigo.Text := '';
    TabLojaModuloEID.Text := '';
    TabLojaModuloEModuloConf.Text := '';
    TabLojaModuloEModuloConfID.Text := '';
    TabLojaModuloCkHabilitar.Checked := False;
    TabLojaModuloEFiltro.Text := '';
end;

procedure TFCadLoja.TabLojaModuloBModificarClick(Sender: TObject);
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
    if MDLojaModuloConf.Active = False then
    begin
        ShowMessage('MDLojaModulo não está ativo');
        Exit;
    end;
    if length(TabLojaModuloEID.Text) < 1 then
    begin
        ShowMessage('Não existe modulo para fazer alteração, selecione um módulo');
        Exit;
    end;

    if GravaRegistros('TabLojaModulo', False) then
    begin
        vl_Codigo := finterface.AlterarRegistro('00A7', MDLojaModuloConf, '00AF', StrToInt(TabLojaModuloEID.Text), '00B1', 'S', vl_tag);

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
                MDLojaModuloConf.Locate('ID', StrToInt(TabLojaModuloEID.Text), []);
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
        MDLojaModuloConf.Locate('ID', StrToInt(TabLojaModuloEID.Text), []);
        CarregaCampos;
    end;
    VL_Mensagem.Free;
end;

procedure TFCadLoja.TabLojaModuloBPesquisaModuloConfClick(Sender: TObject);
var
    VL_FPesquisaModulo: TFPesquisaModuloConf;
begin
    if ((F_Permissao = False)) then
        exit;
    VL_FPesquisaModulo := TFPesquisaModuloConf.Create(Self);
    VL_FPesquisaModulo.F_Tabela := RxMemDataToStr(MDPesquisaModulo);
    VL_FPesquisaModulo.ShowModal;
    if VL_FPesquisaModulo.F_Carregado then
    begin
        TabLojaModuloEModuloConfID.Text := VL_FPesquisaModulo.MDPesquisaModulo.FieldByName('MODULO_CONF_ID').AsString;
        TabLojaModuloEModuloConf.Text := VL_FPesquisaModulo.MDPesquisaModulo.FieldByName('MODULO_CONF_DESCRICAO').AsString;
    end;

end;

procedure TFCadLoja.TabLojaModuloEFiltroChange(Sender: TObject);
var
    VL_Filtro: string;
begin
    if ((F_Permissao = False) or (MDLojaModuloConf.RecordCount < 1)) then
        EXIT;
    VL_Filtro := '';
    MDLojaModuloConf.Filter := finterface.FiltrarTabela(TabLojaModuloGrid, VL_Filtro, TabLojaModuloEFiltro);
    TabLojaModuloLFiltro.Caption := VL_Filtro;
    MDLojaModuloConf.Filtered := True;

end;

procedure TFCadLoja.TabLojaModuloGridColEnter(Sender: TObject);
begin
    if ((MDLojaModuloConf.Active = False) or (MDLojaModuloConf.RecordCount < 1)) then
        exit;
    CarregaCampos;
end;

procedure TFCadLoja.TabLojaModuloGridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin

end;

procedure TFCadLoja.TabModuloFuncaoBVoltarClick(Sender: TObject);
begin
    TabLojaFuncao.TabVisible := False;
    TabModuloFuncao.TabVisible := False;
    TabLojaModulo.TabVisible := True;
end;

procedure TFCadLoja.TabModuloFuncaoCKSelecionadaChange(Sender: TObject);
begin
    if TabModuloFuncaoCKSelecionada.Checked then
    begin
        MDLojaModuloConfFuncao.Filter := 'VALIDADO=''T''';
        MDLojaModuloConfFuncao.Filtered := True;
    end
    else
    begin
        TabModuloFuncaoETipoFiltro.ItemIndex := 0;
        TabModuloFuncaoETipoFiltro.OnChange(SELF);
    end;
end;

procedure TFCadLoja.TabModuloFuncaoEFiltroChange(Sender: TObject);
var
    VL_Filtro: string;
begin
    if F_Permissao = False then
        EXIT;
    VL_Filtro := '';
    MDLojaModuloConfFuncao.Filter := finterface.FiltrarTabela(TabModuloFuncaoGrid, VL_Filtro, TabModuloFuncaoEFiltro);
    TabModuloFuncaoLFiltro.Caption := VL_Filtro;
    MDLojaModuloConfFuncao.Filtered := True;

end;

procedure TFCadLoja.TabModuloFuncaoETipoFiltroChange(Sender: TObject);
begin
    TabModuloFuncaoCKSelecionada.Checked := False;
    if TabModuloFuncaoETipoFiltro.ItemIndex < 1 then
    begin
        MDLojaModuloConfFuncao.Filter := '';
        MDLojaModuloConfFuncao.Filtered := False;
    end
    else
    begin
        MDLojaModuloConfFuncao.Filter := 'TAG_TIPO=''' + TabModuloFuncaoETipoFiltro.Text + '''';
        MDLojaModuloConfFuncao.Filtered := True;
    end;
end;

procedure TFCadLoja.TabModuloFuncaoGridCellClick(Column: TColumn);
var
    VL_Status: integer;
    VL_Mensagem: TMensagem;
    VL_Codigo: integer;
    VL_ID: int64;
    VL_Retorno, VL_Tag, VL_Validado, VL_Habilitado: string;
label
    sair;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    VL_Validado := '';
    VL_Habilitado := '';

    if TabModuloFuncaoGrid.SelectedColumn.FieldName <> 'VALIDADO_F' then
        TabModuloFuncaoLFiltro.Caption := 'Filtrar por ' + TabModuloFuncaoGrid.SelectedColumn.Title.Caption;
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            finterface.Desconectar;
            Exit;
        end;
        if (MDLojaModuloConf.Active = False) then
            exit;
        if (MDLojaModuloConfFuncao.Active = False) then
            exit;
        F_Navegar := False;
        if ((TabModuloFuncaoGrid.SelectedColumn.FieldName = 'VALIDADO_F') or
            (TabModuloFuncaoGrid.SelectedColumn.FieldName = 'HABILITADO_F')) then
        begin
            VL_ID := MDLojaModuloConfFuncaoID.AsInteger;
            VL_Tag := MDLojaModuloConfFuncaoTAG_NUMERO.AsString;
            VL_Validado := COPY(BoolToStr(MDLojaModuloConfFuncao.FieldByName('VALIDADO_F').AsBoolean, True), 0, 1);
            VL_Habilitado := COPY(BoolToStr(MDLojaModuloConfFuncao.FieldByName('HABILITADO_F').AsBoolean, True), 0, 1);

            if MDLojaModuloConfFuncao.Filtered then
            begin
                MDLojaModuloConfFuncao.Filtered := False;
                if VL_ID = 0 then
                    MDLojaModuloConfFuncao.Locate('TAG_NUMERO', VL_Tag, [])
                else
                    MDLojaModuloConfFuncao.Locate('ID', VL_ID, []);
            end;

            if (TabModuloFuncaoGrid.SelectedColumn.FieldName = 'VALIDADO_F') then
            begin
                MDLojaModuloConfFuncao.Edit;
                MDLojaModuloConfFuncao.FieldByName('VALIDADO').AsString := VL_Validado;
                MDLojaModuloConfFuncao.Post;
            end;
            if (TabModuloFuncaoGrid.SelectedColumn.FieldName = 'HABILITADO_F') then
            begin
                MDLojaModuloConfFuncao.Edit;
                MDLojaModuloConfFuncao.FieldByName('HABILITADO').AsString := VL_Habilitado;
                MDLojaModuloConfFuncao.Post;
            end;

            if ((MDLojaModuloConfFuncao.FieldByName('VALIDADO').AsString = 'T') and (VL_ID < 1)) then
            begin
                MDLojaModuloConfFuncao.Edit;
                MDLojaModuloConfFuncao.FieldByName('LOJA_MODULO_CONF_ID').AsString := MDLojaModuloConf.FieldByName('ID').AsString;
                MDLojaModuloConfFuncao.FieldByName('ID').AsInteger := 0;
                MDLojaModuloConfFuncao.Post;
                //incluir loja_modulo_conf_funcao
                VL_Codigo := finterface.IncluirRegistro(MDLojaModuloConfFuncao, '009B', 'S', '0098', VL_Tag);

                if mensagemerro(VL_Codigo, V_Erro) <> 0 then
                begin
                    ShowMessage('Erro: ' + IntToStr(VL_Codigo) + #13 + V_Erro);
                    if MDLojaModuloConfFuncao.Locate('ID', 0, []) then
                        MDLojaModuloConfFuncao.Delete;
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
                        if MDLojaModuloConfFuncao.Locate('ID', 0, []) then
                            MDLojaModuloConfFuncao.Delete;
                        Exit;
                    end;
                    '009B':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                            if MDLojaModuloConfFuncao.Locate('ID', 0, []) then
                                MDLojaModuloConfFuncao.Delete;
                            Exit;
                        end;
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        if vl_tag <> '0' then
                        begin
                            mensagemerro(StrToInt(VL_Tag), V_Erro);
                            ShowMessage('ERRO:' + VL_Tag + #13 + V_Erro);
                            if MDLojaModuloConfFuncao.Locate('ID', 0, []) then
                                MDLojaModuloConfFuncao.Delete;
                            Exit;
                        end;
                        VL_Mensagem.GetTag('00BC', VL_ID); //RETORNO DO ID DO LOJA_MODULO_CONF_FUNCAO
                        F_Navegar := False;
                        if MDLojaModuloConfFuncao.Locate('ID', 0, []) then
                        begin
                            MDLojaModuloConfFuncao.Edit;
                            MDLojaModuloConfFuncao.FieldByName('ID').AsInteger := VL_ID;
                            MDLojaModuloConfFuncao.Post;
                        end;
                        F_Navegar := True;
                    end;
                end;
            end
            else
            if ((MDLojaModuloConfFuncao.FieldByName('VALIDADO').AsString = 'T') and (VL_ID > 0)) then
            begin
                //ALTERA LOJA_MODULO_CONF_FUNCAO
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00BF', 'S');
                VL_Mensagem.AddTag('00BC', VL_ID);
                VL_Mensagem.AddTag('0089', MDLojaModuloConfFuncao.FieldByName('HABILITADO').AsString);
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
                        ShowMessage('ERRO: ' + VL_Tag + #13 + V_Erro);
                        Exit;
                    end;
                    '00BF':
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
                            ShowMessage('ERRO: ' + VL_Tag + #13 + V_Erro);
                            Exit;
                        end;
                    end;
                end;
            end
            else
            begin
                //alterar multloja função
                VL_Codigo := finterface.ExcluirRegistro('00BC', VL_ID, '0087', 'S', VL_Tag);

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
                        ShowMessage('ERRO: ' + VL_Tag + #13 + V_Erro);
                    end;
                    '0087':
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
                                ShowMessage('ERRO: ' + VL_Tag + #13 + V_Erro);
                            end;
                        end;
                    end;
                end;
                sair:
                    MDLojaModuloConfFuncao.Edit;
                MDLojaModuloConfFuncao.FieldByName('ID').AsString := '-1';
                MDLojaModuloConfFuncao.FieldByName('HABILITADO').AsString := 'F';
                MDLojaModuloConfFuncao.FieldByName('HABILITADO_F').AsBoolean := False;
                MDLojaModuloConfFuncao.Post;
            end;
        end;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
        MDLojaModuloConfFuncao.Filtered := True;
    end;

end;

procedure TFCadLoja.CarregarLoja(VP_LojaID, VP_ModuloConfID: integer);
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
        VL_Mensagem.AddTag('0065', 0); //multloja_id
        VL_Mensagem.AddTag('006C', 0); //modulo_id

        VL_Mensagem.TagToStr(VL_Tag);

        if VP_LojaID = 0 then
            VL_Tag := FInterface.PesquisaTabelas('0070', 'S', '003C', VP_LojaID, VL_Tag)
        else
        if VP_ModuloConfID = 0 then
            VL_Tag := FInterface.PesquisaTabelas('0070', 'S', '003C', VP_LojaID, '')
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
                    vl_tag := IntToStr(mdloja.RecordCount);
                    if FInterface.MDTabela.RecordCount > 0 then
                    begin
                        MDMultiLojaLoja.EmptyTable;
                        CopiaDadosSimples(FInterface.MDTabela, MDMultiLojaLoja);
                    end;
                end;
                //TABELA MULT-LOJA
                if VL_Mensagem.GetTag('0080', VL_Tag) = 0 then
                begin
                    if MDMultiLojaLoja.Active then
                        MDMultiLojaLoja.EmptyTable;

                    if FInterface.MDTabela.Active then
                        FInterface.MDTabela.EmptyTable;

                    StrToRxMemData(VL_Tag, MDMultiLojaLoja);

                    MDMultiLojaLoja.Open;
                    //CRIA CAMPO NDF
                    MDMultiLojaLoja.Insert;
                    MDMultiLojaLoja.FieldByName('ID').AsInteger := -1;
                    MDMultiLojaLoja.FieldByName('RAZAO').AsString := 'NÃO DEFINIDO';
                    MDMultiLojaLoja.Post;

                    vl_tag := RxMemDataToStr(MDMultiLojaLoja);
                    StrToRxMemData(vl_tag, FInterface.MDTabela);
                end;
                //TABELA LOJA-MODULO
                if VL_Mensagem.GetTag('00A7', VL_Tag) = 0 then
                begin
                    if MDLojaModuloConf.Active then
                        MDLojaModuloConf.EmptyTable;
                    StrToRxMemData(VL_Tag, MDLojaModuloConf);
                    MDLojaModuloConf.Open;
                end;
                //TABELA LOJA-FUNÇÃO
                if VL_Mensagem.GetTag('00A9', VL_Tag) = 0 then
                begin
                    if MDLojaFuncao.Active then
                        MDLojaFuncao.EmptyTable;

                    if VL_Tabela.Active then
                        VL_Tabela.EmptyTable;

                    StrToRxMemData(VL_Tag, VL_Tabela);
                    CopiaDadosSimples(VL_Tabela, MDLojaFuncao);
                end;
                //TABELA LOJA-MODULOCONF-FUNCAO
                if VL_Mensagem.GetTag('0098', VL_Tag) = 0 then
                begin
                    if MDLojaModuloConfFuncao.Active then
                        MDLojaModuloConfFuncao.EmptyTable;

                    if VL_Tabela.Active then
                        VL_Tabela.EmptyTable;
                    StrToRxMemData(VL_Tag, VL_Tabela);
                    CopiaDadosSimples(VL_Tabela, MDLojaModuloConfFuncao);
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

function TFCadLoja.GravaRegistros(VP_Tab: string; VP_Incluir: boolean): boolean;
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
        //grava TabLoja
        if VP_Tab = 'TabLoja' then
        begin
            if not (F_Permissao) then
            begin
                ShowMessage('Sem Permissão de Gravação, usuário apenas de leitura');
                F_Navegar := True;
                exit;
            end;
            if VP_Incluir then
            begin
                VL_ID := 0;
                VL_Bool := 'F';
            end
            else
            begin
                VL_ID := MDLoja.FieldByName('ID').AsInteger;
                VL_Bool := MDLoja.FieldByName('MULT').AsString;
            end;

            if VP_Incluir then
                MDLoja.Insert
            else
                MDLoja.Edit;

            MDLoja.FieldByName('ID').AsInteger := VL_ID;
            MDLoja.FieldByName('DOC').AsString := ECnpj.Text;
            VL_Tabela := ECnpj.Text;
            MDLoja.FieldByName('RAZAO').AsString := ERazao.Text;
            VL_Tabela := ERazao.Text;
            MDLoja.FieldByName('FANTASIA').AsString := EFantasia.Text;
            MDLoja.FieldByName('MULTILOJA_ID').AsString := MDMultiLojaLoja.FieldByName('ID').AsString;
            MDLoja.FieldByName('MULT').AsString := VL_BOOL;
            if CkHabilitar.Checked then
                MDLoja.FieldByName('HABILITADO').AsString := 'T'
            else
                MDLoja.FieldByName('HABILITADO').AsString := 'F';
            MDLoja.Post;
            Result := True;
        end
        else
        //grava TabLojaModulo
        if VP_Tab = 'TabLojaModulo' then
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
                VL_ID := MDLojaModuloConf.FieldByName('ID').AsInteger;

            if VP_Incluir then
                MDLojaModuloConf.Insert
            else
                MDLojaModuloConf.Edit;

            MDLojaModuloConf.FieldByName('ID').AsInteger := VL_ID;
            MDLojaModuloConf.FieldByName('LOJA_ID').AsInteger := MDLoja.FieldByName('ID').AsInteger;
            if MDPesquisaModulo.locate('MODULO_CONF_ID', TabLojaModuloEModuloConfID.Text, []) then
                MDLojaModuloConf.FieldByName('MODULO').AsString := MDPesquisaModulo.FieldByName('MODULO_DESCRICAO').AsString;
            MDLojaModuloConf.FieldByName('MODULO_CONF_ID').AsString := TabLojaModuloEModuloConfID.Text;
            MDLojaModuloConf.FieldByName('MODULO_CONF').AsString := TabLojaModuloEModuloConf.Text;
            MDLojaModuloConf.FieldByName('CODIGO').AsString := TabLojaModuloECodigo.Text;
            if TabLojaModuloCkHabilitar.Checked then
                MDLojaModuloConf.FieldByName('HABILITADO').AsString := 'T'
            else
                MDLojaModuloConf.FieldByName('HABILITADO').AsString := 'F';
            MDLojaModuloConf.Post;
            Result := True;
        end
    finally
        F_Navegar := True;
    end;

end;

procedure TFCadLoja.LimpaTela;
var
    i: integer;
begin
    with self do
    begin
        for i := 0 to ComponentCount - 1 do
        begin
            if Components[i] is TEdit then
                TEdit(Components[i]).Text := '';
            if Components[i] is TMaskEdit then
                TMaskEdit(Components[i]).Text := '';
            if Components[i] is TCheckBox then
                TCheckBox(Components[i]).Checked := False;
            if Components[i] is TRxMemoryData then
                if TRxMemoryData(Components[i]).Active then
                    if ((TRxMemoryData(Components[i]) <> TRxMemoryData(MDPesquisaModulo)) and
                        (TRxMemoryData(Components[i]) <> TRxMemoryData(MDMultiLojaLoja))) then
                        TRxMemoryData(Components[i]).EmptyTable;
        end;
    end;
end;

procedure TFCadLoja.CarregaCampos;
begin
    //CARREGA OS CAMPOS
    if F_Navegar = False then
        exit;
    //CARREGA LOJA
    if length(MDLoja.FieldByName('DOC').AsString) > 12 then
        CkPessoa.Checked := False
    else
        CkPessoa.Checked := True;

    if MDLoja.FieldByName('HABILITADO').AsString = 'T' then
        CkHabilitar.Checked := True
    else
        CkHabilitar.Checked := False;

    if MDMultiLojaLoja.Locate('ID', MDLoja.FieldByName('MULTILOJA_ID').AsInteger, []) then
    begin
        CMultLoja.KeyValue := MDMultiLojaLoja.FieldByName('RAZAO').AsVariant;
    end
    else
    begin
        CMultLoja.KeyValue := 'Não Definido';
    end;
    EID.Text := MDLoja.FieldByName('ID').AsString;
    ECnpj.Text := MDLoja.FieldByName('DOC').AsString;
    ERazao.Text := MDLoja.FieldByName('RAZAO').AsString;
    EFantasia.Text := MDLoja.FieldByName('FANTASIA').AsString;

    //CARREGA LOJA-MODULO /LOJA-FUNCAO
    if ((MDLojaModuloConf.Active = False) or (MDLojaModuloConf.RecordCount = 0)) then
        CarregarLoja(MDLoja.FieldByName('ID').AsInteger, 0);

    TabLojaModuloEID.Text := MDLojaModuloConf.FieldByName('ID').AsString;
    TabLojaModuloECodigo.Text := MDLojaModuloConf.FieldByName('CODIGO').AsString;
    if MDLojaModuloConf.FieldByName('HABILITADO').AsString = 'T' then
        TabLojaModuloCkHabilitar.Checked := True
    else
        TabLojaModuloCkHabilitar.Checked := False;
    TabLojaModuloEModuloConfID.Text := MDLojaModuloConf.FieldByName('MODULO_CONF_ID').AsString;
    TabLojaModuloEModuloConf.Text := MDLojaModuloConf.FieldByName('MODULO_CONF').AsString;

end;

end.
