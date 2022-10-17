unit ucadmultloja;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils, DB, Forms, funcoes, Controls, Graphics, Dialogs, ExtCtrls,
    StdCtrls, MaskEdit, Buttons, ComCtrls, rxlookup, RxDBGrid, rxmemds, DBGrids;

type

    { TFCadMultloja }

    TFCadMultloja = class(TForm)
        BAdicionar: TBitBtn;
        BExcluir: TBitBtn;
        BAdicionarGuardaChuva: TBitBtn;
        BFuncaoLoja: TBitBtn;
        BPesquisarLoja: TBitBtn;
        BLimpar: TBitBtn;
        BModificar: TBitBtn;
        DSLoja: TDataSource;
        DSMultiLoja: TDataSource;
        DSMultiLojaFuncao: TDataSource;
        DSMultiLojaModuloConf: TDataSource;
        DSLojaNG: TDataSource;
        DSLojaG: TDataSource;
        DSMultiLojaModuloConfFuncao: TDataSource;
        DSPesquisaModulo: TDataSource;
        MDLoja: TRxMemoryData;
        MDMultiLoja: TRxMemoryData;
        MDMultiLojaFuncao: TRxMemoryData;
        MDMultiLojaFuncaoDEFINICAO: TStringField;
        MDMultiLojaFuncaoHABILITADO: TStringField;
        MDMultiLojaFuncaoHABILITADO_F: TBooleanField;
        MDMultiLojaFuncaoID: TLargeintField;
        MDMultiLojaFuncaoMULTILOJA_ID: TLargeintField;
        MDMultiLojaFuncaoTAG_NUMERO: TStringField;
        MDMultiLojaFuncaoTAG_TIPO: TStringField;
        MDMultiLojaFuncaoVALIDADO: TStringField;
        MDMultiLojaFuncaoVALIDADO_F: TBooleanField;
        MDMultiLojaModuloConf: TRxMemoryData;
        MDMultiLojaModuloConfFuncao: TRxMemoryData;
        MDMultiLojaModuloConfFuncaoDEFINICAO: TStringField;
        MDMultiLojaModuloConfFuncaoHABILITADO: TStringField;
        MDMultiLojaModuloConfFuncaoHABILITADO_F: TBooleanField;
        MDMultiLojaModuloConfFuncaoID: TLargeintField;
        MDMultiLojaModuloConfFuncaoMULTILOJA_MODULO_CONF_ID: TLargeintField;
        MDMultiLojaModuloConfFuncaoTAG_NUMERO: TStringField;
        MDMultiLojaModuloConfFuncaoTAG_TIPO: TStringField;
        MDMultiLojaModuloConfFuncaoVALIDADO: TStringField;
        MDMultiLojaModuloConfFuncaoVALIDADO_F: TBooleanField;
        MDPesquisaModulo: TRxMemoryData;
        MDLojaNG: TRxMemoryData;
        MDLojaG: TRxMemoryData;
        TabGuardaLNaoPertence: TLabel;
        TabGuardaLPertence: TLabel;
        TabGuardaGridNaoPertence: TRxDBGrid;
        TabGuardaGridPertence: TRxDBGrid;
        TabGuardaBAdicionar: TBitBtn;
        TabGuardaBExcluir: TBitBtn;
        BPesquisar: TBitBtn;
        CkHabilitar: TCheckBox;
        ECnpj: TMaskEdit;
        EFantasia: TEdit;
        EID: TEdit;
        ERazao: TEdit;
        LCnpj: TLabel;
        LFantasia: TLabel;
        LID: TLabel;
        LRazao: TLabel;
        LTitulo: TLabel;
        PagePrincipal: TPageControl;
        PPrincipal: TPanel;
        Panel2: TPanel;
        Panel3: TPanel;
        Panel4: TPanel;
        Panel5: TPanel;
        Panel6: TPanel;
        PBotoes: TPanel;
        PTitulo: TPanel;
        TabGuardaBVoltar: TBitBtn;
        TabMultiLojaFuncao: TTabSheet;
        TabMultiLojaFuncaoBVoltar: TBitBtn;
        TabMultiLojaFuncaoCKSelecionada: TCheckBox;
        TabMultiLojaFuncaoEFiltro: TEdit;
        TabMultiLojaFuncaoETipoFiltro: TComboBox;
        TabMultiLojaFuncaoGrid: TRxDBGrid;
        TabMultiLojaFuncaoLFiltro: TLabel;
        TabMultiLojaFuncaoLTipoFiltro: TLabel;
        TabMultiLojaModulo: TTabSheet;
        TabMultiLojaModuloBAdicionar: TBitBtn;
        TabMultiLojaModuloBExcluir: TBitBtn;
        TabMultiLojaModuloBFuncaoModulo: TBitBtn;
        TabMultiLojaModuloBLimpar: TBitBtn;
        TabMultiLojaModuloBModificar: TBitBtn;
        TabMultiLojaModuloBPesquisaModuloConf: TBitBtn;
        TabMultiLojaModuloCkHabilitar: TCheckBox;
        TabMultiLojaModuloEFiltro: TEdit;
        TabMultiLojaModuloEID: TEdit;
        TabMultiLojaModuloEModuloConf: TEdit;
        TabMultiLojaModuloEModuloConfID: TEdit;
        TabMultiLojaModuloGrid: TRxDBGrid;
        TabMultiLojaModuloLFiltro: TLabel;
        TabMultiLojaModuloLID: TLabel;
        TabMultiLojaModuloLModuloConf: TLabel;
        TabModuloFuncao: TTabSheet;
        TabModuloFuncaoBVoltar: TBitBtn;
        TabModuloFuncaoCKSelecionada: TCheckBox;
        TabModuloFuncaoEFiltro: TEdit;
        TabModuloFuncaoETipoFiltro: TComboBox;
        TabModuloFuncaoGrid: TRxDBGrid;
        TabModuloFuncaoLFiltro: TLabel;
        TabModuloFuncaoLTipoFiltro: TLabel;
        TabGuarda: TTabSheet;
        procedure BAdicionarClick(Sender: TObject);
        procedure BAdicionarGuardaChuvaClick(Sender: TObject);
        procedure BExcluirClick(Sender: TObject);
        procedure BFuncaoLojaClick(Sender: TObject);
        procedure BLimparClick(Sender: TObject);
        procedure BModificarClick(Sender: TObject);
        procedure BPesquisarClick(Sender: TObject);
        procedure BPesquisarLojaClick(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure MDLojaGFilterRecord(DataSet: TDataSet; var Accept: boolean);
        procedure MDLojaNewRecord(DataSet: TDataSet);
        procedure MDLojaNGFilterRecord(DataSet: TDataSet; var Accept: boolean);
        procedure MDMultiLojaFuncaoCalcFields(DataSet: TDataSet);
        procedure MDMultiLojaFuncaoFilterRecord(DataSet: TDataSet; var Accept: boolean);
        procedure MDMultiLojaModuloConfAfterScroll(DataSet: TDataSet);
        procedure MDMultiLojaModuloConfFuncaoCalcFields(DataSet: TDataSet);
        procedure MDMultiLojaModuloConfFuncaoNewRecord(DataSet: TDataSet);
        procedure TabGuardaBAdicionarClick(Sender: TObject);
        procedure TabGuardaBExcluirClick(Sender: TObject);
        procedure TabGuardaBVoltarClick(Sender: TObject);
        procedure TabModuloFuncaoBVoltarClick(Sender: TObject);
        procedure TabModuloFuncaoCKSelecionadaChange(Sender: TObject);
        procedure TabModuloFuncaoEFiltroChange(Sender: TObject);
        procedure TabModuloFuncaoETipoFiltroChange(Sender: TObject);
        procedure TabModuloFuncaoGridCellClick(Column: TColumn);
        procedure TabMultiLojaFuncaoBVoltarClick(Sender: TObject);
        procedure TabMultiLojaFuncaoCKSelecionadaChange(Sender: TObject);
        procedure TabMultiLojaFuncaoEFiltroChange(Sender: TObject);
        procedure TabMultiLojaFuncaoETipoFiltroChange(Sender: TObject);
        procedure TabMultiLojaFuncaoGridCellClick(Column: TColumn);
        procedure TabMultiLojaModuloBAdicionarClick(Sender: TObject);
        procedure TabMultiLojaModuloBExcluirClick(Sender: TObject);
        procedure TabMultiLojaModuloBFuncaoModuloClick(Sender: TObject);
        procedure TabMultiLojaModuloBLimparClick(Sender: TObject);
        procedure TabMultiLojaModuloBModificarClick(Sender: TObject);
        procedure TabMultiLojaModuloBPesquisaModuloConfClick(Sender: TObject);
        procedure TabMultiLojaModuloEFiltroChange(Sender: TObject);
    private
        procedure CarregarMultiLoja(VP_MultiLojaID, VP_ModuloConfID: integer);
        function GravaRegistros(VP_Tab: string; VP_Incluir: boolean = False): boolean;

    public
        V_Erro: PChar;
        procedure LimpaTela;
        procedure CarregaCampos;
    end;

var
    FCadMultloja: TFCadMultloja;

implementation

{$R *.lfm}
uses
    uinterface, upesquisamultiloja, upesquisaloja, uPesquisamoduloconf;

{ TFCadMultloja }

procedure TFCadMultloja.BLimparClick(Sender: TObject);
begin
    LimpaTela;
end;

procedure TFCadMultloja.BModificarClick(Sender: TObject);
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
    if MDMultiLoja.Active = False then
    begin
        ShowMessage('MDMultLoja não está ativo');
        Exit;
    end;

    if GravaRegistros('TabMultLoja', False) then
    begin
        vl_codigo := finterface.AlterarRegistro('0080', MDMultiLoja, '0065', MDMultiLoja.FieldByName('ID').AsInteger, '0067', 'S', VL_Tag);
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
                MDMultiLoja.Locate('ID', StrToInt(EID.Text), []);
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
        MDMultiLoja.Locate('ID', StrToInt(EID.Text), []);
        CarregaCampos;
        VL_Mensagem.Free;
    end;
end;

procedure TFCadMultloja.BFuncaoLojaClick(Sender: TObject);
begin
    if ((F_Navegar) and (F_Permissao) and (MDMultiLoja.RecordCount > 0)) then
    begin
        CarregarMultiLoja(MDMultiLoja.FieldByName('ID').AsInteger, 0);
        TabMultiLojaFuncaoETipoFiltro.ItemIndex := 0;
        TabMultiLojaFuncaoCKSelecionada.Checked := False;
        TabMultiLojaFuncaoETipoFiltro.OnChange(self);
    end
    else
        MDMultiLojaFuncao.EmptyTable;

    TabMultiLojaFuncao.TabVisible := True;
    TabModuloFuncao.TabVisible := False;
    TabMultiLojaModulo.TabVisible := False;
    TabGuarda.TabVisible := False;

end;

procedure TFCadMultloja.BAdicionarClick(Sender: TObject);
var
    VL_Status: integer;
    VL_Codigo: integer;
    VL_ID: int64;
    VL_Retorno: ansistring;
    VL_Tag: ansistring;
    VL_Mensagem: TMensagem;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_Status := 0;
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
        if MDMultiLoja.Active = False then
        begin
            ShowMessage('MDMultiLoja não está ativo');
            Exit;
        end;

        if GravaRegistros('TabMultLoja', True) then
        begin
            VL_Codigo := finterface.IncluirRegistro(MDMultiLoja, '0064', 'S', '0080', VL_Tag);

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
                    if MDMultiLoja.Locate('ID', 0, []) then
                        MDMultiLoja.Delete;
                    Exit;
                end;
                '0064':
                begin
                    if VL_Tag <> 'R' then
                    begin
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        mensagemerro(StrToInt(VL_Tag), V_Erro);
                        ShowMessage('ERRO: ' + VL_Tag + #13 + V_Erro);
                        if MDMultiLoja.Locate('ID', 0, []) then
                            MDMultiLoja.Delete;
                        Exit;
                    end;
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    if VL_Tag <> '0' then
                    begin
                        mensagemerro(StrToInt(VL_Tag), V_Erro);
                        ShowMessage('ERRO: ' + VL_Tag + #13 + V_Erro);
                        if MDMultiLoja.Locate('ID', 0, []) then
                            MDMultiLoja.Delete;
                        Exit;
                    end;
                    VL_Mensagem.GetTag('0065', VL_ID); //MULT-LOJA_ID
                    F_Navegar := False;
                    if MDMultiLoja.Locate('ID', 0, []) then
                    begin
                        MDMultiLoja.Edit;
                        MDMultiLoja.FieldByName('ID').AsInteger := VL_ID;
                        MDMultiLoja.Post;
                        F_Navegar := True;
                    end;
                end;
            end;
            MDMultiLoja.Locate('ID', VL_ID, []);
            CarregaCampos;
            ShowMessage('Registro incluido com sucesso');
        end;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;

end;

procedure TFCadMultloja.BAdicionarGuardaChuvaClick(Sender: TObject);
begin
    //PREPARA AS TABELAS
    if ((F_Navegar) and (F_Permissao) and (MDMultiLoja.RecordCount > 0)) then
    begin
        if MDLojaNG.Active then
            MDLojaNG.EmptyTable;
        if MDLojaG.Active then
            MDLojaG.EmptyTable;
        CopiaDadosSimples(mdloja, mdlojanG);
        CopiaDadosSimples(mdloja, mdlojaG);

        //tabela loja Não Gerida
        MDLojaNG.Filtered := False;
        if MDLojaNG.RecordCount > 0 then
        begin
            MDLojaNG.Filter := 'MULTILOJA_ID <= 0';
            MDLojaNG.Filtered := True;
        end;
        //tabela loja Gerida
        MDLojaG.Filtered := False;
        if MDLojaG.RecordCount > 0 then
        begin
            MDLojaG.Filter := 'MULTILOJA_ID >= 1';
            MDLojaG.Filtered := True;
        end;
    end
    else
    begin
        MDLojaNG.EmptyTable;
        MDLojaG.EmptyTable;
    end;

    TabMultiLojaFuncao.TabVisible := False;
    TabModuloFuncao.TabVisible := False;
    TabMultiLojaModulo.TabVisible := False;
    TabGuarda.TabVisible := True;
end;

procedure TFCadMultloja.BExcluirClick(Sender: TObject);
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
        if MDMultiLoja.Active = False then
        begin
            ShowMessage('MDMultLoja não está ativo');
            Exit;
        end;
        VL_Codigo := finterface.ExcluirRegistro('0065', MDMultiLoja.FieldByName('ID').AsInteger, '0066', 'S', VL_Tag);

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
                ShowMessage('ERRO: ' + IntToStr(VL_ID) + #13 + V_Erro);
                Exit;
            end;
            '0066':
            begin
                if VL_Tag <> 'R' then
                begin
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    mensagemerro(StrToInt(VL_Tag), V_Erro);
                    ShowMessage('ERRO: ' + VL_Tag + #13 + V_Erro);
                    Exit;
                end;
                VL_Mensagem.GetTag('004D', VL_TAG);
                if VL_Tag <> '0' then
                begin
                    VL_Mensagem.GetTag('004D', VL_ID);
                    mensagemerro(VL_ID, V_Erro);
                    ShowMessage('ERRO: ' + IntToStr(VL_ID) + #13 + V_Erro);
                    Exit;
                end;
                F_Navegar := False;
                //ATUALIZA LOJA
                MDLoja.Locate('ID', MDMultiLoja.FieldByName('LOJA_ID').AsInteger, []);
                MDLoja.Edit;
                MDLoja.FieldByName('MULT').AsString := 'F';
                MDLoja.Post;
                MDMultiLoja.Delete;
                F_Navegar := True;
            end;
        end;
        CarregaCampos;
        ShowMessage('Registro Excluido com sucesso');
        LimpaTela;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;

end;

procedure TFCadMultloja.BPesquisarClick(Sender: TObject);
var
    VL_FPesquisaMultiLoja: TFPesquisaMultiLoja;
begin
    if F_Permissao = False then
        exit;
    CarregarMultiLoja(0, 0);
    VL_FPesquisaMultiLoja := TFPesquisaMultiLoja.Create(Self);
    VL_FPesquisaMultiLoja.F_Tabela := RxMemDataToStr(MDMultiLoja);
    LimpaTela;
    VL_FPesquisaMultiLoja.ShowModal;
    if VL_FPesquisaMultiLoja.F_Carregado then
    begin
        CarregarMultiLoja(VL_FPesquisaMultiLoja.MDPesquisaMultiLoja.FieldByName('ID').AsInteger, 0);
        CarregaCampos;
    end;

end;

procedure TFCadMultloja.BPesquisarLojaClick(Sender: TObject);
var
    VL_FPesquisaLoja: TFPesquisaLoja;
begin
    if (F_Permissao = False) then
        exit;
    if length(eid.Text) <> 0 then
    begin
        ShowMessage('Para carregar uma loja antes limpe a tela');
        exit;
    end;

    CarregarMultiLoja(0, 0);
    VL_FPesquisaLoja := TFPesquisaLoja.Create(Self);
    VL_FPesquisaLoja.F_Tabela := RxMemDataToStr(MDLoja);
    LimpaTela;
    VL_FPesquisaLoja.ShowModal;
    if VL_FPesquisaLoja.F_Carregado then
    begin
        //carrega campos pela loja
        if MDLoja.Locate('ID', VL_FPesquisaLoja.MDPesquisaLoja.FieldByName('ID').AsInteger, []) then
        begin
            if length(MDLoja.FieldByName('DOC').AsString) > 12 then
            begin
                LCnpj.Caption := 'C.N.P.J:';
                LFantasia.Caption := 'Fantasia';
                LRazao.Caption := 'Razão:';
                ECnpj.EditMask := '99.999.999/9999-99;0;_';
            end
            else
            begin
                LCnpj.Caption := 'C.P.F:';
                LFantasia.Caption := 'Apelido (nome usado nos relatórios)';
                LRazao.Caption := 'Nome:';
                ECnpj.EditMask := '999.999.999-99;0;_';
            end;
            EID.Text := '0';
            ECnpj.Text := MDLoja.FieldByName('DOC').AsString;
            ERazao.Text := MDLoja.FieldByName('RAZAO').AsString;
            EFantasia.Text := MDLoja.FieldByName('FANTASIA').AsString;
        end;
    end;
end;

procedure TFCadMultloja.FormCreate(Sender: TObject);
begin
    MDMultiLojaFuncao.Open;
    MDMultiLojaModuloConfFuncao.Open;
end;

procedure TFCadMultloja.FormShow(Sender: TObject);
begin
    //prepara a tela
    LimpaTela;
    PagePrincipal.PageIndex := 0;
    TabMultiLojaFuncao.TabVisible := False;
    TabModuloFuncao.TabVisible := False;
    TabGuarda.TabVisible := False;
end;

procedure TFCadMultloja.MDLojaGFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin

end;

procedure TFCadMultloja.MDLojaNewRecord(DataSet: TDataSet);
begin

end;

procedure TFCadMultloja.MDLojaNGFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin

end;

procedure TFCadMultloja.MDMultiLojaFuncaoCalcFields(DataSet: TDataSet);
begin
    if (F_Permissao) then
    begin
        DataSet.FieldByName('VALIDADO_F').AsBoolean := DataSet.FieldByName('VALIDADO').AsBoolean;
        DataSet.FieldByName('HABILITADO_F').AsBoolean := DataSet.FieldByName('HABILITADO').AsBoolean;
    end;
end;

procedure TFCadMultloja.MDMultiLojaFuncaoFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin

end;

procedure TFCadMultloja.MDMultiLojaModuloConfAfterScroll(DataSet: TDataSet);
begin
    if ((MDMultiLojaModuloConf.Active = False) or (MDMultiLojaModuloConf.RecordCount < 1)) then
        exit;
    CarregaCampos;
end;

procedure TFCadMultloja.MDMultiLojaModuloConfFuncaoCalcFields(DataSet: TDataSet);
begin
    if (F_Permissao) then
    begin
        DataSet.FieldByName('VALIDADO_F').AsBoolean := DataSet.FieldByName('VALIDADO').AsBoolean;
        DataSet.FieldByName('HABILITADO_F').AsBoolean := DataSet.FieldByName('HABILITADO').AsBoolean;
    end;
end;

procedure TFCadMultloja.MDMultiLojaModuloConfFuncaoNewRecord(DataSet: TDataSet);
begin

end;

procedure TFCadMultloja.TabGuardaBAdicionarClick(Sender: TObject);
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
        if (F_Permissao = False) then
            exit;
        //prepara para incluir loja na multiloja
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            finterface.Desconectar;
            Exit;
        end;
        if MDLojaNG.Active = False then
        begin
            ShowMessage('MDLojaNG não está ativo');
            Exit;
        end;
        if MDLojaG.Active = False then
        begin
            ShowMessage('MDLojaG não está ativo');
            Exit;
        end;
        if MDMultiLoja.Active = False then
        begin
            ShowMessage('MDMultiLoja não está ativo');
            Exit;
        end;
        if MDLojaNG.FieldByName('ID').AsInteger = MDMultiLoja.FieldByName('LOJA_ID').AsInteger then
        begin
            ShowMessage('Esta Loja já é uma Multiloja Gerenciadora, não podera ser adicionada');
            Exit;
        end;
        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('00FA', 'S');
        VL_Mensagem.AddTag('003C', MDLojaNG.FieldByName('ID').AsInteger);
        VL_Mensagem.AddTag('0065', MDMultiLoja.FieldByName('ID').AsInteger);

        VL_Mensagem.TagToStr(VL_Tag);

        VL_Codigo := FInterface.SolicitacaoBloc(VL_Tag, VL_Tag, C_TempoSolicitacao);

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
            '00FA':
            begin
                if VL_Tag <> 'R' then
                begin
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    ShowMessage('ERRO: O Comando não é um retorno, erro numero:' + VL_Tag);
                    Exit;
                end;
                VL_Mensagem.GetTag('004D', VL_Tag);
                if vl_tag <> '0' then
                begin
                    mensagemerro(StrToInt(VL_Tag), V_Erro);
                    ShowMessage('ERRO: ' + VL_Tag + #13 + V_Erro);
                    Exit;
                end;
                VL_Mensagem.GetTag('003C', VL_ID); //RETORNO DO ID DA LOJA
                F_Navegar := False;
                //ADICIONA REGISTRO NA TABELA LOJAG
                MDLOJAG.Filtered := False;
                if MDLojaG.Locate('ID', VL_ID, []) then
                begin
                    MDLojaG.Edit;
                    MDLojaG.FieldByName('MULTILOJA_ID').AsInteger := MDMultiLoja.FieldByName('ID').AsInteger;
                    MDLojaG.Post;
                end;
                MDLojaG.Filtered := True;

                //EXCLUI REGISTRO TABELA LOJANG
                MDLojaNG.Filtered := False;
                if MDLojaNG.Locate('ID', VL_ID, []) then
                begin
                    MDLojaNG.Edit;
                    MDLojaNG.FieldByName('MULTILOJA_ID').AsInteger := MDMultiLoja.FieldByName('ID').AsInteger;
                    MDLojaNG.Post;
                end;
                MDLojaNG.Filtered := True;
                F_Navegar := True;
            end;
        end;
    finally
        VL_Mensagem.Free;
    end;
end;

procedure TFCadMultloja.TabGuardaBExcluirClick(Sender: TObject);
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
        if (F_Permissao = False) then
            exit;
        //prepara para incluir loja na multiloja
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            finterface.Desconectar;
            Exit;
        end;
        if MDLojaNG.Active = False then
        begin
            ShowMessage('MDLojaNG não está ativo');
            Exit;
        end;
        if MDLojaG.Active = False then
        begin
            ShowMessage('MDLojaG não está ativo');
            Exit;
        end;
        if MDMultiLoja.Active = False then
        begin
            ShowMessage('MDMultiLoja não está ativo');
            Exit;
        end;
        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('00FB', 'S');
        VL_Mensagem.AddTag('003C', MDLojaG.FieldByName('ID').AsInteger);
        VL_Mensagem.AddTag('0065', MDMultiLoja.FieldByName('ID').AsInteger);

        VL_Mensagem.TagToStr(VL_Tag);

        VL_Codigo := FInterface.SolicitacaoBloc(VL_Tag, VL_Tag, C_TempoSolicitacao);

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
            '00FB':
            begin
                if VL_Tag <> 'R' then
                begin
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    ShowMessage('ERRO: O Comando não é um retorno, erro numero:' + VL_Tag);
                    Exit;
                end;
                VL_Mensagem.GetTag('004D', VL_Tag);
                if vl_tag <> '0' then
                begin
                    mensagemerro(StrToInt(VL_Tag), V_Erro);
                    ShowMessage('ERRO: ' + VL_Tag + #13 + V_Erro);
                    Exit;
                end;
                VL_Mensagem.GetTag('003C', VL_ID); //RETORNO DO ID DA LOJA
                F_Navegar := False;

                //ADICIONA REGISTRO NA TABELA LOJANG
                MDLOJANG.Filtered := False;
                if MDLojaNG.Locate('ID', VL_ID, []) then
                begin
                    MDLojaNG.EDIT;
                    MDLojaNG.FieldByName('MULTILOJA_ID').AsInteger := -1;
                    MDLojaNG.Post;
                end;
                MDLojaNG.Filtered := True;

                //EXCLUI REGISTRO TABELA LOJANG
                MDLojaG.Filtered := False;
                if MDLojaG.Locate('ID', VL_ID, []) then
                begin
                    MDLojaG.EDIT;
                    MDLojaG.FieldByName('MULTILOJA_ID').AsInteger := -1;
                    MDLojaG.Post;
                end;
                MDLojaG.Filtered := True;
                F_Navegar := True;
            end;
        end;
    finally
        VL_Mensagem.Free;
    end;
end;

procedure TFCadMultloja.TabGuardaBVoltarClick(Sender: TObject);
begin
    TabMultiLojaFuncao.TabVisible := False;
    TabModuloFuncao.TabVisible := False;
    TabMultiLojaModulo.TabVisible := True;
    TabGuarda.TabVisible := False;
end;

procedure TFCadMultloja.TabModuloFuncaoBVoltarClick(Sender: TObject);
begin
    TabMultiLojaFuncao.TabVisible := False;
    TabModuloFuncao.TabVisible := False;
    TabMultiLojaModulo.TabVisible := True;
    TabGuarda.TabVisible := False;
end;

procedure TFCadMultloja.TabModuloFuncaoCKSelecionadaChange(Sender: TObject);
begin
    if TabModuloFuncaoCKSelecionada.Checked then
    begin
        MDmultiLojaModuloConfFuncao.Filter := 'VALIDADO=''T''';
        MDmultiLojaModuloConfFuncao.Filtered := True;
    end
    else
    begin
        TabModuloFuncaoETipoFiltro.ItemIndex := 0;
        TabModuloFuncaoETipoFiltro.OnChange(SELF);
    end;
end;

procedure TFCadMultloja.TabModuloFuncaoEFiltroChange(Sender: TObject);
var
    VL_Filtro: string;
begin
    if F_Permissao = False then
        EXIT;
    VL_Filtro := '';
    MDMultiLojaModuloConfFuncao.Filter := finterface.FiltrarTabela(TabModuloFuncaoGrid, VL_Filtro, TabModuloFuncaoEFiltro);
    TabModuloFuncaoLFiltro.Caption := VL_Filtro;
    MDMultiLojaModuloConfFuncao.Filtered := True;

end;

procedure TFCadMultloja.TabModuloFuncaoETipoFiltroChange(Sender: TObject);
begin
    TabModuloFuncaoCKSelecionada.Checked := False;
    if TabModuloFuncaoETipoFiltro.ItemIndex < 1 then
    begin
        MDMultiLojaModuloConfFuncao.Filter := '';
        MDMultiLojaModuloConfFuncao.Filtered := False;
    end
    else
    begin
        MDMultiLojaModuloConfFuncao.Filter := 'TAG_TIPO=''' + TabModuloFuncaoETipoFiltro.Text + '''';
        MDMultiLojaModuloConfFuncao.Filtered := True;
    end;
end;

procedure TFCadMultloja.TabModuloFuncaoGridCellClick(Column: TColumn);
var
    VL_Status: integer;
    VL_Mensagem: TMensagem;
    VL_Codigo: integer;
    VL_ID: int64;
    VL_Retorno, VL_Tag: string;
    VL_Validado, VL_Habilitado: string;
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

    F_Navegar := False;
    if TabModuloFuncaoGrid.SelectedColumn.FieldName <> 'VALIDADO_F' then
        TabModuloFuncaoLFiltro.Caption := 'Filtrar por ' + TabModulofuncaoGrid.SelectedColumn.Title.Caption;
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            finterface.Desconectar;
            Exit;
        end;
        if ((MDMultiLojaModuloConf.Active = False) or (MDMultiLojaModuloConf.RecordCount < 1)) then
            exit;
        if ((MDMultiLojaModuloConfFuncao.Active = False) or (MDMultiLojaModuloConfFuncao.RecordCount < 1)) then
            exit;
        if ((TabModuloFuncaoGrid.SelectedColumn.FieldName = 'VALIDADO_F') or
            (TabModuloFuncaoGrid.SelectedColumn.FieldName = 'HABILITADO_F')) then
        begin
            VL_ID := MDMultiLojaModuloConfFuncaoID.AsInteger;
            VL_Tag := MDMultiLojaModuloConfFuncaoTAG_NUMERO.AsString;
            VL_Validado := COPY(BoolToStr(MDMultiLojaModuloConfFuncao.FieldByName('VALIDADO_F').AsBoolean, True), 0, 1);
            VL_Habilitado := COPY(BoolToStr(MDMultiLojaModuloConfFuncao.FieldByName('HABILITADO_F').AsBoolean, True), 0, 1);

            if MDMultiLojaModuloConfFuncao.Filtered then
            begin
                MDMultiLojaModuloConfFuncao.Filtered := False;
                if VL_ID = 0 then
                    MDMultiLojaModuloConfFuncao.Locate('TAG_NUMERO', VL_Tag, [])
                else
                    MDMultiLojaModuloConfFuncao.Locate('ID', VL_ID, []);
            end;

            if (TabModuloFuncaoGrid.SelectedColumn.FieldName = 'VALIDADO_F') then
            begin
                MDMultiLojaModuloConfFuncao.Edit;
                MDMultiLojaModuloConfFuncao.FieldByName('VALIDADO').AsString := VL_Validado;

                MDMultiLojaModuloConfFuncao.Post;
            end;
            if (TabModuloFuncaoGrid.SelectedColumn.FieldName = 'HABILITADO_F') then
            begin
                MDMultiLojaModuloConfFuncao.Edit;
                MDMultiLojaModuloConfFuncao.FieldByName('HABILITADO').AsString := VL_Habilitado;
                MDMultiLojaModuloConfFuncao.Post;
            end;

            if ((MDMultiLojaModuloConfFuncao.FieldByName('VALIDADO').AsString = 'T') and (VL_ID < 1)) then
            begin
                MDMultiLojaModuloConfFuncao.Edit;
                MDMultiLojaModuloConfFuncao.FieldByName('MULTILOJA_MODULO_CONF_ID').AsString := MDMultiLojaModuloConf.FieldByName('ID').AsString;
                MDMultiLojaModuloConfFuncao.FieldByName('ID').AsInteger := 0;
                MDMultiLojaModuloConfFuncao.Post;

                //incluir loja_modulo_conf_funcao
                VL_Codigo := finterface.IncluirRegistro(MDMultiLojaModuloConfFuncao, '00CA', 'S', '00D0', VL_Tag);
                if mensagemerro(VL_Codigo, V_Erro) <> 0 then
                begin
                    ShowMessage('Erro: ' + IntToStr(VL_Codigo) + #13 + V_Erro);
                    if MDMultiLojaModuloConfFuncao.Locate('ID', 0, []) then
                        MDMultiLojaModuloConfFuncao.Delete;
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
                        if MDMultiLojaModuloConfFuncao.Locate('ID', 0, []) then
                            MDMultiLojaModuloConfFuncao.Delete;
                        Exit;
                    end;
                    '00CA':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                            if MDMultiLojaModuloConfFuncao.Locate('ID', 0, []) then
                                MDMultiLojaModuloConfFuncao.Delete;
                            Exit;
                        end;
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        if vl_tag <> '0' then
                        begin
                            mensagemerro(StrToInt(VL_Tag), V_Erro);
                            ShowMessage('ERRO: ' + VL_Tag + #13 + V_Erro);
                            if MDMultiLojaModuloConfFuncao.Locate('ID', 0, []) then
                                MDMultiLojaModuloConfFuncao.Delete;
                            Exit;
                        end;
                        VL_Mensagem.GetTag('00BD', VL_ID); //RETORNO DO ID DO MULTILOJA_MODULO_CONF_FUNCAO
                        F_Navegar := False;
                        if MDMultiLojaModuloConfFuncao.Locate('ID', 0, []) then
                        begin
                            MDMultiLojaModuloConfFuncao.Edit;
                            MDMultiLojaModuloConfFuncao.FieldByName('ID').AsInteger := VL_ID;
                            MDMultiLojaModuloConfFuncao.Post;
                        end;
                        F_Navegar := True;
                    end;
                end;
            end
            else
            if ((MDMultiLojaModuloConfFuncao.FieldByName('VALIDADO').AsString = 'T') and (VL_ID > 0)) then
            begin
                //ALTERA MULTILOJA_MODULO_CONF_FUNCAO
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00B0', 'S');
                VL_Mensagem.AddTag('00BD', VL_ID);
                VL_Mensagem.AddTag('0084', MDMultiLojaModuloConfFuncao.FieldByName('HABILITADO').AsString);
                VL_Mensagem.TagToStr(VL_Tag);
                VL_Codigo := finterface.SolicitacaoBloc(VL_Tag, VL_Tag, C_TempoSolicitacao);
                if mensagemerro(VL_Codigo, V_Erro) <> 0 then
                begin
                    ShowMessage('Erro: ' + IntToStr(VL_Codigo) + #13 + V_Erro);
                    if MDMultiLojaModuloConfFuncao.Locate('ID', 0, []) then
                        MDMultiLojaModuloConfFuncao.Delete;
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
                        if MDMultiLojaModuloConfFuncao.Locate('ID', 0, []) then
                            MDMultiLojaModuloConfFuncao.Delete;
                        Exit;
                    end;
                    '00B0':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                            if MDMultiLojaModuloConfFuncao.Locate('ID', 0, []) then
                                MDMultiLojaModuloConfFuncao.Delete;
                            Exit;
                        end;
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        if vl_tag <> '0' then
                        begin
                            mensagemerro(StrToInt(VL_Tag), V_Erro);
                            ShowMessage('ERRO: ' + VL_Tag + #13 + V_Erro);
                            if MDMultiLojaModuloConfFuncao.Locate('ID', 0, []) then
                                MDMultiLojaModuloConfFuncao.Delete;
                            Exit;
                        end;
                    end;
                end;
            end
            else
            begin
                //excluir multloja_modulo_conf_função
                VL_Codigo := finterface.ExcluirRegistro('00BD', VL_ID, '0088', 'S', VL_Tag);

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
                    '0088':
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
                    MDMultiLojaModuloConfFuncao.Edit;
                MDMultiLojaModuloConfFuncao.FieldByName('ID').AsInteger := -1;
                MDMultiLojaModuloConfFuncao.FieldByName('HABILITADO').AsString := 'F';
                MDMultiLojaModuloConfFuncao.FieldByName('HABILITADO_F').AsBoolean := False;
                MDMultiLojaModuloConfFuncao.POST;
            end;
        end;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
        MDMultiLojaModuloConfFuncao.Filtered := True
    end;

end;

procedure TFCadMultloja.TabMultiLojaFuncaoBVoltarClick(Sender: TObject);
begin
    TabMULTILojaFuncao.TabVisible := False;
    TabModuloFuncao.TabVisible := False;
    TabMultiLojaModulo.TabVisible := True;
    TabGuarda.TabVisible := False;
end;

procedure TFCadMultloja.TabMultiLojaFuncaoCKSelecionadaChange(Sender: TObject);
begin
    if TabMultiLojaFuncaoCKSelecionada.Checked then
    begin
        MDMultiLojaFuncao.Filter := 'VALIDADO=''T''';
        MDMultiLojaFuncao.Filtered := True;
    end
    else
    begin
        TabMultiLojaFuncaoETipoFiltro.ItemIndex := 0;
        TabMultiLojaFuncaoETipoFiltro.OnChange(SELF);
    end;
end;

procedure TFCadMultloja.TabMultiLojaFuncaoEFiltroChange(Sender: TObject);
var
    VL_Filtro: string;
begin
    if F_Permissao = False then
        EXIT;
    VL_Filtro := '';
    MDMultiLojaFuncao.Filter := FInterface.FiltrarTabela(TabMultiLojaFuncaoGrid, VL_Filtro, TabMultiLojaFuncaoEFiltro);
    TabMultiLojaFuncaoLFiltro.Caption := VL_Filtro;
    MDMultiLojaFuncao.Filtered := True;

end;

procedure TFCadMultloja.TabMultiLojaFuncaoETipoFiltroChange(Sender: TObject);
begin
    TabMultiLojaFuncaoCKSelecionada.Checked := False;
    if TabMultiLojaFuncaoETipoFiltro.ItemIndex < 1 then
    begin
        MDMultiLojaFuncao.Filter := '';
        MDMultiLojaFuncao.Filtered := False;
    end
    else
    begin
        MDMultiLojaFuncao.Filter := 'TAG_TIPO=''' + TabMultiLojaFuncaoETipoFiltro.Text + '''';
        MDMultiLojaFuncao.Filtered := True;
    end;
end;

procedure TFCadMultloja.TabMultiLojaFuncaoGridCellClick(Column: TColumn);
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
    if TabMultiLojaFuncaoGrid.SelectedColumn.FieldName <> 'VALIDADO_F' then
        TabMultiLojaFuncaoLFiltro.Caption := 'Filtrar por ' + TabMultiLojaFuncaoGrid.SelectedColumn.Title.Caption;
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            finterface.Desconectar;
            Exit;
        end;
        if ((MDMultiLoja.Active = False) or (MDMultiLoja.RecordCount < 1)) then
            exit;
        if ((MDMultiLojaFuncao.Active = False) or (MDMultiLojaFuncao.RecordCount < 1)) then
            exit;
        F_Navegar := False;
        if ((TabMultiLojaFuncaoGrid.SelectedColumn.FieldName = 'VALIDADO_F') or
            (TabMultiLojaFuncaoGrid.SelectedColumn.FieldName = 'HABILITADO_F')) then
        begin
            VL_ID := MDMultiLojaFuncaoID.AsInteger;
            VL_Tag := MDMultiLojaFuncaoTAG_NUMERO.AsString;
            VL_Validado := COPY(BoolToStr(MDMultiLojaFuncao.FieldByName('VALIDADO_F').AsBoolean, True), 0, 1);
            VL_Habilitado := COPY(BoolToStr(MDMultiLojaFuncao.FieldByName('HABILITADO_F').AsBoolean, True), 0, 1);

            if MDMultiLojaFuncao.Filtered then
            begin
                MDMultiLojaFuncao.Filtered := False;
                if VL_ID = 0 then
                    MDMultiLojaFuncao.Locate('TAG_NUMERO', VL_Tag, [])
                else
                    MDMultiLojaFuncao.Locate('ID', VL_ID, []);
            end;

            if (TabMultiLojaFuncaoGrid.SelectedColumn.FieldName = 'VALIDADO_F') then
            begin
                MDMultiLojaFuncao.Edit;
                MDMultiLojaFuncao.FieldByName('VALIDADO').AsString := VL_Validado;
                MDMultiLojaFuncao.Post;
            end;
            if (TabMultiLojaFuncaoGrid.SelectedColumn.FieldName = 'HABILITADO_F') then
            begin
                MDMultiLojaFuncao.Edit;
                MDMultiLojaFuncao.FieldByName('HABILITADO').AsString := VL_Habilitado;
                MDMultiLojaFuncao.Post;
            end;

            //CLICOU NO VALIDADO A PRIMEIRA VEZ
            if ((MDMultiLojaFuncao.FieldByName('VALIDADO').AsBoolean = True) and (VL_ID < 1)) then
            begin
                MDMultiLojaFuncao.Edit;
                MDMultiLojaFuncao.FieldByName('MULTILOJA_ID').AsString := MDMultiLoja.FieldByName('ID').AsString;
                MDMultiLojaFuncao.FieldByName('ID').AsInteger := 0;
                MDMultiLojaFuncao.Post;
                //incluir MULTLOJA função
                VL_Codigo := finterface.IncluirRegistro(MDMultiLojaFuncao, '009D', 'S', '009C', VL_Tag);
                if mensagemerro(VL_Codigo, V_Erro) <> 0 then
                begin
                    ShowMessage('Erro: ' + IntToStr(VL_Codigo) + #13 + V_Erro);
                    if MDMultiLojaFuncao.Locate('ID', 0, []) then
                        MDMultiLojaFuncao.Delete;
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
                        if MDMultiLojaFuncao.Locate('ID', 0, []) then
                            MDMultiLojaFuncao.Delete;
                        Exit;
                    end;
                    '009D':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                            if MDMultiLojaFuncao.Locate('ID', 0, []) then
                                MDMultiLojaFuncao.Delete;
                            Exit;
                        end;
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        if VL_Tag <> '0' then
                        begin
                            mensagemerro(StrToInt(VL_Tag), V_Erro);
                            ShowMessage('ERRO: ' + VL_Tag + #13 + V_Erro);
                            if MDMultiLojaFuncao.Locate('ID', 0, []) then
                                MDMultiLojaFuncao.Delete;
                            Exit;
                        end;
                        VL_Mensagem.GetTag('009E', VL_ID); //MULTLOJA_FUNCAO_ID
                        F_Navegar := False;
                        if MDMultiLojaFuncao.Locate('ID', 0, []) then
                        begin
                            MDMultiLojaFuncao.Edit;
                            MDMultiLojaFuncao.FieldByName('ID').AsInteger := VL_ID;
                            MDMultiLojaFuncao.Post;
                        end;
                        F_Navegar := True;
                    end;
                end;
            end
            else
            if ((MDMultiLojaFuncao.FieldByName('VALIDADO').AsBoolean = True) and (VL_ID > 0)) then
            begin
                //ALTERA MULTLOJA_FUNCAO
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('009F', 'S');
                VL_Mensagem.AddTag('009E', VL_ID);
                VL_Mensagem.AddTag('00A1', MDMultiLojaFuncao.FieldByName('HABILITADO').AsString);
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
                        mensagemerro(StrToInt(VL_Tag), V_Erro);
                        VL_Mensagem.GetTag('0026', VL_Tag);
                        ShowMessage('ERRO: ' + VL_Tag + #13 + V_Erro);
                        Exit;
                    end;
                    '009F':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                            Exit;
                        end;
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        if VL_Tag <> '0' then
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
                VL_Codigo := finterface.ExcluirRegistro('009E', VL_ID, '00A0', 'S', VL_Tag);

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
                    '00A0':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                        end
                        else
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            if VL_Tag <> '0' then
                            begin
                                mensagemerro(StrToInt(VL_Tag), V_Erro);
                                ShowMessage('ERRO: ' + VL_Tag + #13 + V_Erro);
                            end;
                        end;
                    end;
                end;
                sair:
                    MDMultiLojaFuncao.Edit;
                MDMultiLojaFuncao.FieldByName('ID').AsInteger := -1;
                MDMultiLojaFuncao.FieldByName('HABILITADO').AsString := 'F';
                MDMultiLojaFuncao.FieldByName('HABILITADO_F').AsBoolean := False;
                MDMultiLojaFuncao.Post;
            end;
        end;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
        MDMultiLojaFuncao.Filtered := True;
    end;

end;

procedure TFCadMultloja.TabMultiLojaModuloBAdicionarClick(Sender: TObject);
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
            FINTERFACE.Desconectar;
            Exit;
        end;
        if MDMultiLojaModuloConf.Active = False then
        begin
            ShowMessage('MDMultiLojaModulo não está ativo');
            Exit;
        end;
        if MDMultiLoja.Active = False then
        begin
            ShowMessage('MDMultiLoja não está ativo');
            Exit;
        end;
        if TabMultiLojaModuloEModuloConfID.Text = '' then
        begin
            ShowMessage('Voce deve selecionar um modulo para a inclusão');
            Exit;
        end;
        if GravaRegistros('TabMultLojaModulo', True) then
        begin
            VL_Codigo := finterface.IncluirRegistro(MDMultiLojaModuloConf, '0096', 'S', '0094', VL_Tag);

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
                    ShowMessage('ERRO: ' + VL_Tag + #13 + V_Erro);
                    if MDMultiLojaModuloConf.Locate('ID', 0, []) then
                        MDMultiLojaModuloConf.Delete;
                    Exit;
                end;
                '0096':
                begin
                    if VL_Tag <> 'R' then
                    begin
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        ShowMessage('ERRO: ' + VL_Tag + #13 + 'Este não é um comando de retorno');
                        if MDMultiLojaModuloConf.Locate('ID', 0, []) then
                            MDMultiLojaModuloConf.Delete;
                        Exit;
                    end;
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    if VL_Tag <> '0' then
                    begin
                        mensagemerro(StrToInt(VL_Tag), V_Erro);
                        ShowMessage('ERRO:' + VL_Tag + #13 + V_Erro);
                        if MDMultiLojaModuloConf.Locate('ID', 0, []) then
                            MDMultiLojaModuloConf.Delete;
                        Exit;
                    end;
                    VL_Mensagem.GetTag('0097', VL_ID); //MULTLOJA_MODULO_ID
                    F_Navegar := False;
                    if MDMultiLojaModuloConf.Locate('ID', 0, []) then
                    begin
                        MDMultiLojaModuloConf.Edit;
                        MDMultiLojaModuloConf.FieldByName('ID').AsInteger := VL_ID;
                        MDMultiLojaModuloConf.Post;
                    end;
                    F_Navegar := True;
                end;
            end;
            MDMultiLojaModuloConf.Locate('ID', VL_ID, []);
            ShowMessage('Registro incluido com sucesso');
        end;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;

end;

procedure TFCadMultloja.TabMultiLojaModuloBExcluirClick(Sender: TObject);
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
        if MDMultiLojaModuloConf.Active = False then
        begin
            ShowMessage('MDMultLojaModulo não está ativo');
            Exit;
        end;
        if length(TabMultiLojaModuloEID.Text) = 0 then
        begin
            ShowMessage('Não existe registro selecionado para exclusão');
            Exit;
        end;

        VL_Codigo := finterface.ExcluirRegistro('0097', StrToInt(TabMultiLojaModuloEID.Text), '0099', 'S', VL_Tag);
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
            '0099':
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
                    mensagemerro(VL_id, V_Erro);
                    ShowMessage('ERRO: ' + IntToStr(VL_ID) + #13 + V_Erro);
                    Exit;
                end;
                VL_Mensagem.GetTag('0097', VL_ID);
                F_Navegar := False;
                if MDMultiLojaModuloConf.Locate('ID', VL_ID, []) then
                    MDMultiLojaModuloConf.Delete;
                F_Navegar := True;
            end;
        end;
        ShowMessage('Registro Excluido com sucesso');
        CarregaCampos;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;
end;

procedure TFCadMultloja.TabMultiLojaModuloBFuncaoModuloClick(Sender: TObject);
begin
    if (TabMultiLojaModuloEID.Text = '') then
        exit;

    if ((F_Navegar) and (F_Permissao) and (MDMultiLojaModuloConf.RecordCount > 0)) then
    begin
        CarregarMultiLoja(MDMultiLoja.FieldByName('ID').AsInteger, MDMultiLojaModuloConf.FieldByName('ID').AsInteger);
        TabModuloFuncaoETipoFiltro.ItemIndex := 0;
        TabModuloFuncaoCKSelecionada.Checked := False;
        TabModuloFuncaoETipoFiltro.OnChange(SELF);
    end
    else
        MDMultiLojaModuloConfFuncao.EmptyTable;


    TabMultiLojaFuncao.TabVisible := False;
    TabModuloFuncao.TabVisible := True;
    TabMultiLojaModulo.TabVisible := False;
    TabGuarda.TabVisible := False;
end;

procedure TFCadMultloja.TabMultiLojaModuloBLimparClick(Sender: TObject);
begin
    //limpa modulo multi-loja
    TabMultiLojaModuloEID.Text := '';
    TabMultiLojaModuloEModuloConf.Text := '';
    TabMultiLojaModuloEModuloConfID.Text := '';
    TabMultiLojaModuloCkHabilitar.Checked := False;
    TabMultiLojaModuloEFiltro.Text := '';
end;

procedure TFCadMultloja.TabMultiLojaModuloBModificarClick(Sender: TObject);
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
    if MDMultiLojaModuloConf.Active = False then
    begin
        ShowMessage('MDMultLojaModulo não está ativo');
        Exit;
    end;

    if TabMultiLojaModuloEID.Text = '' then
    begin
        ShowMessage('Não existe configuração selecionada para ser alterada');
        Exit;
    end;

    if GravaRegistros('TabMultLojaModulo', False) then
    begin
        VL_Codigo := finterface.AlterarRegistro('0094', MDMultiLojaModuloConf, '0097', StrToInt(TabMultiLojaModuloEID.Text), '009A', 'S', vl_tag);

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
                MDmultiLojaModuloConf.Locate('ID', StrToInt(TabmultiLojaModuloEID.Text), []);
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
                    ShowMessage('Módulo da MultiLoja alterado com sucesso')
                else
                begin
                    mensagemerro(StrToInt(VL_Tag), V_Erro);
                    ShowMessage('ERRO: ' + VL_Tag + #13 + V_Erro);
                    LimpaTela;
                    Exit;
                end;
            end;
        end;
        MDMultiLojaModuloConf.Locate('ID', StrToInt(TabMultiLojaModuloEID.Text), []);
        CarregaCampos;
    end;
end;

procedure TFCadMultloja.TabMultiLojaModuloBPesquisaModuloConfClick(Sender: TObject);
var
    VL_FPesquisaModulo: TFModuloConf;
begin
    if ((F_Permissao = False)) then
        exit;
    VL_FPesquisaModulo := TFModuloConf.Create(Self);
    VL_FPesquisaModulo.F_Tabela := RxMemDataToStr(MDPesquisaModulo);
    VL_FPesquisaModulo.ShowModal;
    if VL_FPesquisaModulo.F_Carregado then
    begin
        TabMultiLojaModuloEModuloConfID.Text := VL_FPesquisaModulo.MDPesquisaModulo.FieldByName('MODULO_CONF_ID').AsString;
        TabMultiLojaModuloEModuloConf.Text := VL_FPesquisaModulo.MDPesquisaModulo.FieldByName('MODULO_CONF_DESCRICAO').AsString;
    end;
end;

procedure TFCadMultloja.TabMultiLojaModuloEFiltroChange(Sender: TObject);
var
    VL_Filtro: string;
begin
    if ((F_Permissao = False) or (MDMultiLojaModuloConf.RecordCount < 1)) then
        EXIT;
    VL_Filtro := '';
    MDMultiLojaModuloConf.Filter := finterface.FiltrarTabela(TabMultiLojaModuloGrid, VL_Filtro, TabMultiLojaModuloEFiltro);
    TabMultiLojaModuloLFiltro.Caption := VL_Filtro;
    MDMultiLojaModuloConf.Filtered := True;

end;

procedure TFCadMultloja.CarregarMultiLoja(VP_MultiLojaID, VP_ModuloConfID: integer);
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

        if VP_MultiLojaID = 0 then
            VL_Tag := FInterface.PesquisaTabelas('0070', 'S', '0065', VP_MultiLojaID, VL_Tag)
        else
        if VP_ModuloConfID = 0 then
            VL_Tag := FInterface.PesquisaTabelas('0070', 'S', '0065', VP_MultiLojaID, '')
        else
            VL_Tag := FInterface.PesquisaTabelas('0070', 'S', '0097', VP_ModuloConfID, '');

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
                    if MDLojaNG.Active then
                        MDLojaNG.EmptyTable;
                    if MDLojaG.Active then
                        MDLojaG.EmptyTable;
                    StrToRxMemData(VL_Tag, MDLoja);
                    StrToRxMemData(VL_Tag, MDLojaNG);
                    StrToRxMemData(VL_Tag, MDLojaG);
                    MDLoja.Open;
                    MDLojaNG.Open;
                    MDLojaG.Open;
                    vl_tag := IntToStr(mdloja.RecordCount);
                    if FInterface.MDTabela.RecordCount > 0 then
                    begin
                        MDMultiLoja.EmptyTable;
                        CopiaDadosSimples(FInterface.MDTabela, MDMultiLoja);
                    end;
                end;
                //TABELA MULT-LOJA
                if VL_Mensagem.GetTag('0080', VL_Tag) = 0 then
                begin
                    if VL_Mensagem.GetTag('0080', VL_Tag) = 0 then
                    begin
                        if MDMultiLoja.Active then
                            MDMultiLoja.EmptyTable;

                        StrToRxMemData(VL_Tag, MDMultiLoja);
                        MDMultiLoja.Open;
                    end;
                end;
                //TABELA MultiLOJA-MODULO
                if VL_Mensagem.GetTag('0094', VL_Tag) = 0 then
                begin
                    if MDmultiLojaModuloConf.Active then
                        MDmultiLojaModuloConf.EmptyTable;
                    StrToRxMemData(VL_Tag, MDmultiLojaModuloConf);
                    MDmultiLojaModuloConf.Open;
                end;
                //TABELA multiLOJA-FUNÇÃO
                if VL_Mensagem.GetTag('009C', VL_Tag) = 0 then
                begin
                    if MDmultiLojaFuncao.Active then
                        MDmultiLojaFuncao.EmptyTable;

                    if VL_Tabela.Active then
                        VL_Tabela.EmptyTable;

                    StrToRxMemData(VL_Tag, VL_Tabela);
                    CopiaDadosSimples(VL_Tabela, MDmultiLojaFuncao);
                end;
                //TABELA multiLOJA-MODULOCONF-FUNCAO
                if VL_Mensagem.GetTag('00D0', VL_Tag) = 0 then
                begin
                    if MDmultiLojaModuloConfFuncao.Active then
                        MDmultiLojaModuloConfFuncao.EmptyTable;

                    if VL_Tabela.Active then
                        VL_Tabela.EmptyTable;
                    StrToRxMemData(VL_Tag, VL_Tabela);
                    CopiaDadosSimples(VL_Tabela, MDmultiLojaModuloConfFuncao);
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

function TFCadMultloja.GravaRegistros(VP_Tab: string; VP_Incluir: boolean): boolean;
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
        //grava TabMultLoja
        if VP_Tab = 'TabMultLoja' then
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
                VL_ID := MDMultiLoja.FieldByName('ID').AsInteger;

            if VP_Incluir then
                MDMultiLoja.Insert
            else
            begin
                //localiza loja_id
                MDLoja.Locate('ID', MDMultiLoja.FieldByName('LOJA_ID').AsInteger, []);
                MDMultiLoja.Edit;
            end;

            MDMultiLoja.FieldByName('ID').AsInteger := VL_ID;
            MDMultiLoja.FieldByName('LOJA_ID').AsString := MDLoja.FieldByName('ID').AsString;

            if CkHabilitar.Checked then
                MDMultiLoja.FieldByName('HABILITADO').AsString := 'T'
            else
                MDMultiLoja.FieldByName('HABILITADO').AsString := 'F';

            MDMultiLoja.Post;

            //ATUALIZA LOJA
            MDLoja.Edit;
            MDLoja.FieldByName('MULT').AsString := 'T';
            MDLoja.Post;
            Result := True;
        end
        else
        //grava TabMultLojaModulo
        if VP_Tab = 'TabMultLojaModulo' then
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
                VL_ID := MDMultiLojaModuloConf.FieldByName('ID').AsInteger;

            if VP_Incluir then
                MDMultiLojaModuloConf.Insert
            else
                MDMultiLojaModuloConf.Edit;

            MDMultiLojaModuloConf.FieldByName('ID').AsInteger := VL_ID;
            MDMultiLojaModuloConf.FieldByName('MULTILOJA_ID').AsInteger := MDMultiLoja.FieldByName('ID').AsInteger;
            if MDPesquisaModulo.locate('MODULO_CONF_ID', TabMultiLojaModuloEModuloConfID.Text, []) then
                MDMultiLojaModuloConf.FieldByName('MODULO').AsString := MDPesquisaModulo.FieldByName('MODULO_DESCRICAO').AsString;
            MDMultiLojaModuloConf.FieldByName('MODULO_CONF_ID').AsString := TabMultiLojaModuloEModuloConfID.Text;
            MDMultiLojaModuloConf.FieldByName('MODULO_CONF').AsString := TabMultiLojaModuloEModuloConf.Text;
            if TabMultiLojaModuloCkHabilitar.Checked then
                MDMultiLojaModuloConf.FieldByName('HABILITADO').AsString := 'T'
            else
                MDMultiLojaModuloConf.FieldByName('HABILITADO').AsString := 'F';
            MDMultiLojaModuloConf.Post;
            Result := True;
        end
    finally
        F_Navegar := True;
    end;
end;

procedure TFCadMultloja.LimpaTela;
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
                        (TRxMemoryData(Components[i]) <> TRxMemoryData(MDLoja))) then
                        TRxMemoryData(Components[i]).EmptyTable;
        end;
    end;
end;

procedure TFCadMultloja.CarregaCampos;
begin
    //CARREGA OS CAMPOS

    MDMultiLoja.FieldByName('ID').AsString;

    if F_Navegar = False then
        exit;
    //CARREGA LOJA
    if length(MDMultiLoja.FieldByName('DOC').AsString) > 12 then
    begin
        LCnpj.Caption := 'C.N.P.J:';
        LFantasia.Caption := 'Fantasia';
        LRazao.Caption := 'Razão:';
        ECnpj.EditMask := '99.999.999/9999-99;0;_';
    end
    else
    begin
        LCnpj.Caption := 'C.P.F:';
        LFantasia.Caption := 'Apelido (nome usado nos relatórios)';
        LRazao.Caption := 'Nome:';
        ECnpj.EditMask := '999.999.999-99;0;_';
    end;

    if MDMultiLoja.FieldByName('HABILITADO').AsString = 'T' then
        CkHabilitar.Checked := True
    else
        CkHabilitar.Checked := False;

    EID.Text := MDMultiLoja.FieldByName('ID').AsString;
    if MDLoja.locate('ID', MDMultiLoja.FieldByName('LOJA_ID').AsInteger, []) then
    begin
        ECnpj.Text := MDLoja.FieldByName('DOC').AsString;
        ERazao.Text := MDLoja.FieldByName('RAZAO').AsString;
        EFantasia.Text := MDLoja.FieldByName('FANTASIA').AsString;
    end;

    //CARREGA LOJA-MODULO /LOJA-FUNCAO
    if ((MDMultiLojaModuloConf.Active = False) or (MDmultiLojaModuloConf.RecordCount = 0)) then
        CarregarMultiLoja(MDMultiLoja.FieldByName('ID').AsInteger, 0);

    TabmultiLojaModuloEID.Text := MDmultiLojaModuloConf.FieldByName('ID').AsString;
    if MDmultiLojaModuloConf.FieldByName('HABILITADO').AsString = 'T' then
        TabmultiLojaModuloCkHabilitar.Checked := True
    else
        TabmultiLojaModuloCkHabilitar.Checked := False;
    TabmultiLojaModuloEModuloConfID.Text := MDmultiLojaModuloConf.FieldByName('MODULO_CONF_ID').AsString;
    TabmultiLojaModuloEModuloConf.Text := MDmultiLojaModuloConf.FieldByName('MODULO_CONF').AsString;
end;

end.
