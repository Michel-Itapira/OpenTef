unit ucadpinpad;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils, DB, Forms, funcoes, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
    ComCtrls, Buttons, rxmemds, RxDBGrid, DBGrids;

type

    { TFCadPinPad }

    TFCadPinPad = class(TForm)
        BAdicionar: TBitBtn;
        BExcluir: TBitBtn;
        BLimpar: TBitBtn;
        BModificar: TBitBtn;
        BPesquisar: TBitBtn;
        DSPinPad: TDataSource;
        DSPinPadFuncao: TDataSource;
        DSTags: TDataSource;
        LTitulo: TLabel;
        MDPinPad: TRxMemoryData;
        MDPinPadFuncao: TRxMemoryData;
        MDPinPadFuncaoDEFINICAO: TStringField;
        MDPinPadFuncaoHABILITADO: TStringField;
        MDPinPadFuncaoHABILITADO_F: TBooleanField;
        MDPinPadFuncaoID: TLargeintField;
        MDPinPadFuncaoPINPAD_ID: TLargeintField;
        MDPinPadFuncaoTAG_NUMERO: TStringField;
        MDPinPadFuncaoTAG_TIPO: TStringField;
        MDPinPadFuncaoVALIDADO: TStringField;
        MDPinPadFuncaoVALIDADO_F: TBooleanField;
        MDTags: TRxMemoryData;
        PPinPad: TPanel;
        PBotoes: TPanel;
        PTitulo: TPanel;
        BPesquisaTag: TBitBtn;
        ETag: TEdit;
        ETagID: TEdit;
        LTag: TLabel;
        EID: TEdit;
        TabPinPadFuncaoCKSelecionada: TCheckBox;
        TabPinPadFuncaoEFiltro: TEdit;
        TabPinPadFuncaoETipoFiltro: TComboBox;
        TabPinPadFuncaoGrid: TRxDBGrid;
        TabPinPadFuncaoLFiltro: TLabel;
        TabPinPadFuncaoLTipoFiltro: TLabel;
        TabPinPadFuncaoLTitulo: TLabel;
        LFabricante: TLabel;
        LID: TLabel;
        EFabricante: TEdit;
        PagePrincipal: TPageControl;
        TabPinPadFuncao: TTabSheet;
        procedure BAdicionarClick(Sender: TObject);
        procedure BExcluirClick(Sender: TObject);
        procedure BLimparClick(Sender: TObject);
        procedure BModificarClick(Sender: TObject);
        procedure BPesquisarClick(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure MDPinPadFuncaoCalcFields(DataSet: TDataSet);
        procedure MDPinPadFuncaoFilterRecord(DataSet: TDataSet; var Accept: boolean);
        procedure MDTagsFilterRecord(DataSet: TDataSet; var Accept: boolean);
        procedure TabPinPadFuncaoCKSelecionadaChange(Sender: TObject);
        procedure TabPinPadFuncaoEFiltroChange(Sender: TObject);
        procedure TabPinPadFuncaoETipoFiltroChange(Sender: TObject);
        procedure TabPinPadFuncaoGridCellClick(Column: TColumn);
        procedure TabPinPadFuncaoShow(Sender: TObject);
        procedure BPesquisaTagClick(Sender: TObject);
    private
        procedure CarregarPinPad(VP_PinPadID: integer);
        function GravaRegistros(VP_Tab: string; VP_Incluir: boolean = False): boolean;
    public
        V_Erro: PChar;
        procedure LimpaTela;
        procedure CarregaCampos;
    end;

var
    FCadPinPad: TFCadPinPad;

implementation

{$R *.lfm}
uses
    uinterface, upesquisapinpad, uPesquisaTags;

{ TFCadPinPad }

procedure TFCadPinPad.FormCreate(Sender: TObject);
begin
    MDPinPadFuncao.Open;
end;

procedure TFCadPinPad.BLimparClick(Sender: TObject);
begin
    LimpaTela;
end;

procedure TFCadPinPad.BModificarClick(Sender: TObject);
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
        FINTERFACE.Desconectar;
        Exit;
    end;
    if MDPinPad.Active = False then
    begin
        ShowMessage('MDPinPad não está ativo');
        Exit;
    end;
    if EFabricante.Text = '' then
    begin
        ShowMessage('Modelo do PinPad é um campo obrigatório');
        exit;
    end;
    if GravaRegistros('TabPinPad', False) then
    begin
        VL_Codigo := FINTERFACE.AlterarRegistro('008D', MDPinPad, '0054', StrToInt(EID.Text), '0055', 'S', VL_Tag);

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
                MDPinPad.Locate('ID', StrToInt(EID.Text), []);
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
        MDPinPad.Locate('ID', StrToInt(EID.Text), []);
        CarregaCampos;
        VL_Mensagem.Free;
    end;
end;

procedure TFCadPinPad.BAdicionarClick(Sender: TObject);
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
        if MDPinPad.Active = False then
        begin
            ShowMessage('MDPinPad não está ativo');
            Exit;
        end;
        if length(EID.Text) > 0 then
        begin
            ShowMessage('Para incluir PinPad, limpe antes o formulário');
            Exit;
        end;
        if GravaRegistros('TabPinPad', True) then
        begin
            vl_codigo := FINTERFACE.IncluirRegistro(MDPinPad, '0053', 'S', '008D', VL_Tag);

            if mensagemerro(VL_Codigo, V_Erro) <> 0 then
            begin
                ShowMessage('Erro: ' + IntToStr(VL_Codigo) + #13 + V_Erro);
                if MDPinPad.Locate('ID', 0, []) then
                    MDPinPad.Delete;
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
                    if MDPinPad.Locate('ID', 0, []) then
                        MDPinPad.Delete;
                    Exit;
                end;
                '0053':
                begin
                    if VL_Tag <> 'R' then
                    begin
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                        if MDPinPad.Locate('ID', 0, []) then
                            MDPinPad.Delete;
                        Exit;
                    end;
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    if vl_tag <> '0' then
                    begin
                        mensagemerro(StrToInt(VL_Tag), V_Erro);
                        ShowMessage('ERRO: ' + VL_Tag + #13 + V_Erro);
                        if MDPinPad.Locate('ID', 0, []) then
                            MDPinPad.Delete;
                        Exit;
                    end;
                    VL_Mensagem.GetTag('0054', VL_ID); //RETORNO DO ID DO PINPAD
                    F_Navegar := False;
                    if MDPinPad.Locate('ID', 0, []) then
                    begin
                        MDPinPad.Edit;
                        MDPinPad.FieldByName('ID').AsInteger := VL_ID;
                        MDPinPad.Post;
                    end;
                    F_Navegar := True;
                end;
            end;
            CarregarPinPad(VL_ID);
            CarregaCampos;
            ShowMessage('Registro incluido com sucesso');
        end;

    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;

end;

procedure TFCadPinPad.BExcluirClick(Sender: TObject);
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
        if MDPinPad.Active = False then
        begin
            ShowMessage('MDPinPad não está ativo');
            Exit;
        end;
        if length(EID.Text) = 0 then
        begin
            ShowMessage('Não existe registro selecionado para exclusão');
            Exit;
        end;

        VL_Codigo := FINTERFACE.ExcluirRegistro('0054', StrToInt(EID.Text), '006A', 'S', VL_Tag);

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
                mensagemerro(vl_id, V_Erro);
                ShowMessage('ERRO:' + IntToStr(VL_ID) + #13 + V_Erro);
                Exit;
            end;
            '006A':
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
                VL_Mensagem.GetTag('0054', VL_ID);
                F_Navegar := False;
                if MDPinPad.Locate('ID', VL_ID, []) then
                    MDPinPad.Delete;
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

procedure TFCadPinPad.BPesquisarClick(Sender: TObject);
var
    VL_FPesquisaPinPad: TFPesquisaPinPad;
begin
    if F_Permissao = False then
        exit;
    CarregarPinPad(0);
    VL_FPesquisaPinPad := TFPesquisaPinPad.Create(Self);
    VL_FPesquisaPinPad.F_Tabela := RxMemDataToStr(MDPinPad);
    LimpaTela;
    VL_FPesquisaPinPad.ShowModal;
    if VL_FPesquisaPinPad.F_Carregado then
    begin
        CarregarPinPad(VL_FPesquisaPinPad.MDPesquisaPinPad.FieldByName('ID').AsInteger);
        CarregaCampos;
    end;
end;

procedure TFCadPinPad.FormShow(Sender: TObject);
begin
    //prepara a tela
    CarregarPinPad(0);
    LimpaTela;
    PagePrincipal.PageIndex := 0;
end;

procedure TFCadPinPad.MDPinPadFuncaoCalcFields(DataSet: TDataSet);
begin
    if (F_Permissao) then
    begin
        DataSet.FieldByName('VALIDADO_F').AsBoolean := DataSet.FieldByName('VALIDADO').AsBoolean;
        DataSet.FieldByName('HABILITADO_F').AsBoolean := DataSet.FieldByName('HABILITADO').AsBoolean;
    end;
end;

procedure TFCadPinPad.MDPinPadFuncaoFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin

end;

procedure TFCadPinPad.MDTagsFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin

end;

procedure TFCadPinPad.TabPinPadFuncaoCKSelecionadaChange(Sender: TObject);
begin
    if TabPinPadFuncaoCKSelecionada.Checked then
    begin
        MDPinPadFuncao.Filter := 'VALIDADO=''T''';
        MDPinPadFuncao.Filtered := True;
    end
    else
    begin
        TabPinPadFuncaoETipoFiltro.ItemIndex := 0;
        TabPinPadFuncaoETipoFiltro.OnChange(SELF);
    end;
end;

procedure TFCadPinPad.TabPinPadFuncaoEFiltroChange(Sender: TObject);
var
    VL_Filtro: string;
begin
    if F_Permissao = False then
        EXIT;
    VL_Filtro := '';
    MDPinPadFuncao.Filter := finterface.FiltrarTabela(TabPinPadFuncaoGrid, VL_Filtro, TabPinPadFuncaoEFiltro);
    TabPinPadFuncaoLFiltro.Caption := VL_Filtro;
    MDPinPadFuncao.Filtered := True;

end;

procedure TFCadPinPad.TabPinPadFuncaoETipoFiltroChange(Sender: TObject);
begin
    TabPinPadFuncaoCKSelecionada.Checked := False;
    if TabPinPadFuncaoETipoFiltro.ItemIndex < 1 then
    begin
        MDPinPadFuncao.Filter := '';
        MDPinPadFuncao.Filtered := False;
    end
    else
    begin
        MDPinPadFuncao.Filter := 'TAG_TIPO=''' + TabPinPadFuncaoETipoFiltro.Text + '''';
        MDPinPadFuncao.Filtered := True;
    end;
end;

procedure TFCadPinPad.TabPinPadFuncaoGridCellClick(Column: TColumn);
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
    if TabPinPadFuncaoGrid.SelectedColumn.FieldName <> 'VALIDADO_F' then
        TabPinPadFuncaoLFiltro.Caption := 'Filtrar por ' + TabPinPadFuncaoGrid.SelectedColumn.Title.Caption;
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            FINTERFACE.Desconectar;
            Exit;
        end;
        if (MDPinPad.Active = False) then
            exit;
        if (MDPinPadFuncao.Active = False) then
            exit;
        F_Navegar := False;
        if ((TabPinPadFuncaoGrid.SelectedColumn.FieldName = 'VALIDADO_F') or
            (TabPinPadFuncaoGrid.SelectedColumn.FieldName = 'HABILITADO_F')) then
        begin
            VL_ID := MDPinPadFuncaoID.AsInteger;
            VL_Tag := MDPinPadFuncaoTAG_NUMERO.AsString;
            VL_Validado := copy(BoolToStr(MDPINPADFuncao.FieldByName('VALIDADO_F').AsBoolean, True), 0, 1);
            VL_Habilitado := copy(BoolToStr(MDPINPADFuncao.FieldByName('HABILITADO_F').AsBoolean, True), 0, 1);

            if MDPINPADFuncao.Filtered then
            begin
                MDPINPADFuncao.Filtered := False;
                if VL_ID = 0 then
                    MDPINPADFuncao.Locate('TAG_NUMERO', VL_Tag, [])
                else
                    MDPINPADFuncao.Locate('ID', VL_ID, []);
            end;

            if TabPinPadFuncaoGrid.SelectedColumn.FieldName = 'VALIDADO_F' then
            begin
                MDPinPadFuncao.Edit;
                MDPinPadFuncao.FieldByName('VALIDADO').AsString := VL_Validado;
                MDPinPadFuncao.Post;
            end;
            if TabPinPadFuncaoGrid.SelectedColumn.FieldName = 'HABILITADO_F' then
            begin
                MDPinPadFuncao.Edit;
                MDPinPadFuncao.FieldByName('HABILITADO').AsString := VL_Habilitado;
                MDPinPadFuncao.Post;
            end;
            if ((MDPINPADFuncao.FieldByName('VALIDADO').AsString = 'T') and (VL_ID < 1)) then
            begin
                MDPinPadFuncao.Edit;
                MDPinPadFuncao.FieldByName('PINPAD_ID').AsString := MDPinPad.FieldByName('ID').AsString;
                MDPinPadFuncao.FieldByName('ID').AsInteger := 0;
                MDPinPadFuncao.Post;
                //incluir PINPAD função
                VL_Codigo := FINTERFACE.IncluirRegistro(MDPinPadFuncao, '00B5', 'S', '00B4', VL_Tag);
                if mensagemerro(VL_Codigo, V_Erro) <> 0 then
                begin
                    ShowMessage('Erro: ' + IntToStr(VL_Codigo) + #13 + V_Erro);
                    if MDPinPadFuncao.Locate('ID', 0, []) then
                        MDPINPADFuncao.Delete;
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
                        if MDPinPadFuncao.Locate('ID', 0, []) then
                            MDPinPadFuncao.Delete;
                        Exit;
                    end;
                    '00B5':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                            if MDPinPadFuncao.Locate('ID', 0, []) then
                                MDPinPadFuncao.Delete;
                            Exit;
                        end;

                        VL_Mensagem.GetTag('004D', VL_Tag);

                        if vl_tag <> '0' then
                        begin
                            ShowMessage('ERRO:' + VL_Tag + #13 + VL_Retorno);
                            mensagemerro(StrToInt(VL_Tag), V_Erro);
                            if MDPinPadFuncao.Locate('ID', 0, []) then
                                MDPinPadFuncao.Delete;
                            Exit;
                        end;
                        VL_Mensagem.GetTag('00B7', VL_ID); //RETORNO DO ID DO PINPAD_FUNCAO_id
                        F_Navegar := False;
                        if MDPinPadFuncao.Locate('ID', 0, []) then
                        begin
                            MDPinPadFuncao.Edit;
                            MDPinPadFuncao.FieldByName('ID').AsInteger := VL_ID;
                            MDPinPadFuncao.Post;
                        end;
                        F_Navegar := True;
                    end;
                end;
            end
            else
            if ((MDPINPADFuncao.FieldByName('VALIDADO').AsString = 'T') and (VL_ID > 0)) then
            begin
                //ALTERA PINPAD_FUNCAO
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00B6', 'S');
                VL_Mensagem.AddTag('00B7', VL_ID);
                VL_Mensagem.AddTag('00B3', MDPinPadFuncao.FieldByName('HABILITADO').AsString);
                VL_Mensagem.TagToStr(VL_Tag);
                VL_Codigo := FINTERFACE.SolicitacaoBloc(VL_Tag, VL_Tag, C_TempoSolicitacao);

                if mensagemerro(Vl_Codigo, V_Erro) <> 0 then
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
                    '00B6':
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
                            ShowMessage('ERRO:' + VL_Tag);
                            Exit;
                        end;
                    end;
                end;
            end
            else
            begin
                //EXCLUIR PINPAD função
                VL_Codigo := FINTERFACE.ExcluirRegistro('00B7', VL_ID, '00B8', 'S', VL_Tag);

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
                    '00B8':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                        end
                        else
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            mensagemerro(StrToInt(VL_Tag), V_Erro);
                            if vl_tag <> '0' then
                                ShowMessage('ERRO: ' + VL_Tag + #13 + V_Erro);
                        end;
                    end;
                end;
                sair:
                    MDPinPadFuncao.Edit;
                MDPinPadFuncao.FieldByName('ID').AsInteger := -1;
                MDPinPadFuncao.FieldByName('HABILITADO').AsString := 'F';
                MDPinPadFuncao.FieldByName('HABILITADO_F').AsBoolean := False;
                MDPinPadFuncao.Post;
            end;
        end;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
        MDPinPadFuncao.Filtered := True;
    end;

end;

procedure TFCadPinPad.TabPinPadFuncaoShow(Sender: TObject);
begin
    if ((F_Navegar) and (F_Permissao) and (MDPinPad.RecordCount > 0)) then
    begin
        CarregarPinPad(MDPinPad.FieldByName('ID').AsInteger);
        TabPinPadFuncaoETipoFiltro.ItemIndex := 0;
        TabPinpadFuncaoCKSelecionada.Checked := False;
        TabPinpadFuncaoETipoFiltro.OnChange(self);
    end
    else
        MDPinpadFuncao.EmptyTable;

    TabPinPadFuncaoETipoFiltro.ItemIndex := 0;
end;

procedure TFCadPinPad.BPesquisaTagClick(Sender: TObject);
var
    VL_FPesquisaTag: TFTags;
begin
    if (F_Permissao = False) then
        exit;
    VL_FPesquisaTag := TFTags.Create(Self);
    VL_FPesquisaTag.F_Tabela := RxMemDataToStr(MDTags);
    VL_FPesquisaTag.F_TagTipo := TipoTagToStr(Ord(ttNDF));  //TIPO NENHUM
    VL_FPesquisaTag.ShowModal;
    if VL_FPesquisaTag.F_Carregado then
    begin
        ETagID.Text := VL_FPesquisaTag.MDTags.FieldByName('TAG_NUMERO').AsString;
        ETag.Text := VL_FPesquisaTag.MDTags.FieldByName('DEFINICAO').AsString;
    end;

end;

procedure TFCadPinPad.CarregarPinPad(VP_PinPadID: integer);
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
        VL_Mensagem.AddTag('0054', 0); //pinpad_id
        VL_Mensagem.AddTag('006E', 0); //tag_id

        VL_Mensagem.TagToStr(VL_Tag);

        if VP_PinPadID = 0 then
            VL_Tag := FInterface.PesquisaTabelas('0070', 'S', '0054', VP_PinPadID, VL_Tag)
        else
            VL_Tag := FInterface.PesquisaTabelas('0070', 'S', '0054', VP_PinPadID, '');

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
                //TABELA PINPAD-FUNCAO
                if VL_Mensagem.GetTag('00B4', VL_Tag) = 0 then
                begin
                    if MDPinPadFuncao.Active then
                        MDPinPadFuncao.EmptyTable;

                    if VL_Tabela.Active then
                        VL_Tabela.EmptyTable;
                    StrToRxMemData(VL_Tag, VL_Tabela);
                    CopiaDadosSimples(VL_Tabela, MDPinPadFuncao);
                end;
            end;
        end;
    finally
        VL_Tabela.Free;
        VL_Mensagem.Free;
    end;

end;

function TFCadPinPad.GravaRegistros(VP_Tab: string; VP_Incluir: boolean): boolean;
var
    VL_ID: integer;
begin
    Result := False;
    F_Navegar := False;
    try
        //grava TabPinPad
        if VP_Tab = 'TabPinPad' then
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
                VL_ID := MDPinPad.FieldByName('ID').AsInteger;

            if VP_Incluir then
                MDPinPad.Insert
            else
                MDPinPad.Edit;

            MDPinPad.FieldByName('ID').AsInteger := VL_ID;
            MDPinPad.FieldByName('FABRICANTE_MODELO').AsString := EFabricante.Text;
            MDPinPad.FieldByName('TAG_NUMERO').AsString := ETagID.Text;
            MDPinPad.Post;
            Result := True;
        end;
    finally
        F_Navegar := True;
    end;
end;

procedure TFCadPinPad.LimpaTela;
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
                    if ((TRxMemoryData(Components[i]) <> TRxMemoryData(MDTags))) then
                        TRxMemoryData(Components[i]).EmptyTable;
        end;
    end;

end;

procedure TFCadPinPad.CarregaCampos;
begin
    //CARREGA OS CAMPOS
    if F_Navegar = False then
        exit;
    //CARREGA PINPAD
    EID.Text := MDPinPad.FieldByName('ID').AsString;
    EFabricante.Text := MDPinPad.FieldByName('FABRICANTE_MODELO').AsString;
    ETagID.Text := MDPinPad.FieldByName('TAG_NUMERO').AsString;
    if MDTags.Locate('TAG_NUMERO', MDPinPad.FieldByName('TAG_NUMERO').AsString, []) then
        ETag.Text := MDTags.FieldByName('DEFINICAO').AsString;

end;

end.
