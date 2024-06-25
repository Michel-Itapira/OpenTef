unit ucadmodulo;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils, DB, Forms, funcoes, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
    Buttons, ComCtrls, rxmemds, RxDBGrid, DBGrids;

type

    { TFCadModulo }

    TFCadModulo = class(TForm)
        BAdicionar: TBitBtn;
        BExcluir: TBitBtn;
        BConfigModulo: TBitBtn;
        BFuncaoLoja: TBitBtn;
        BLimpar: TBitBtn;
        BModificar: TBitBtn;
        BPesquisar: TBitBtn;
        DSModulo: TDataSource;
        DSModuloFunc: TDataSource;
        DSTags: TDataSource;
        EDescricao: TEdit;
        EID: TEdit;
        LDescricao: TLabel;
        LID: TLabel;
        LTitulo: TLabel;
        MDModulo: TRxMemoryData;
        MDModuloFunc: TRxMemoryData;
        MDModuloFuncDEFINICAO: TStringField;
        MDModuloFuncHABILITADO: TStringField;
        MDModuloFuncHABILITADO_F: TBooleanField;
        MDModuloFuncID: TLargeintField;
        MDModuloFuncMODULO_ID: TLargeintField;
        MDModuloFuncTAG_NUMERO: TStringField;
        MDModuloFuncTAG_TIPO: TStringField;
        MDModuloFuncVALIDADO: TStringField;
        MDModuloFuncVALIDADO_F: TBooleanField;
        MDTags: TRxMemoryData;
        PagePrincipal: TPageControl;
        PBotoes: TPanel;
        PPrincipal: TPanel;
        PTitulo: TPanel;
        BPesquisaTag: TBitBtn;
        ETag: TEdit;
        ETagID: TEdit;
        TabModuloFuncao: TTabSheet;
        TabModuloFuncaoBVoltar: TBitBtn;
        TabModuloFuncaoCKSelecionada: TCheckBox;
        TabModuloFuncaoEFiltro: TEdit;
        TabModuloFuncaoETipoFiltro: TComboBox;
        TabModuloFuncaoGrid: TRxDBGrid;
        TabModuloFuncaoLFiltro: TLabel;
        TabModuloFuncaoLTipoFiltro: TLabel;
        TabPdvModuloLTag: TLabel;
        procedure BAdicionarClick(Sender: TObject);
        procedure BConfigModuloClick(Sender: TObject);
        procedure BExcluirClick(Sender: TObject);
        procedure BFuncaoLojaClick(Sender: TObject);
        procedure BLimparClick(Sender: TObject);
        procedure BModificarClick(Sender: TObject);
        procedure BPesquisarClick(Sender: TObject);
        procedure BPesquisaTagClick(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure MDModuloFuncCalcFields(DataSet: TDataSet);
        procedure MDModuloFuncFilterRecord(DataSet: TDataSet; var Accept: boolean);
        procedure TabModuloFuncaoBVoltarClick(Sender: TObject);
        procedure TabModuloFuncaoCKSelecionadaChange(Sender: TObject);
        procedure TabModuloFuncaoEFiltroChange(Sender: TObject);
        procedure TabModuloFuncaoETipoFiltroChange(Sender: TObject);
        procedure TabModuloFuncaoGridCellClick(Column: TColumn);
    private
        procedure CarregarModulo(VP_ModuloID: integer);
        function GravaRegistros(VP_Tab: string; VP_Incluir: boolean = False): boolean;
    public
        V_Erro: PChar;
        procedure LimpaTela;
        procedure CarregaCampos;
    end;

var
    FCadModulo: TFCadModulo;

implementation

{$R *.lfm}
uses
    uinterface, uPesquisaTags, upesquisamodulo,umoduloconfig;

{ TFCadModulo }

procedure TFCadModulo.FormCreate(Sender: TObject);
begin
    MDModuloFunc.Open;
end;

procedure TFCadModulo.BLimparClick(Sender: TObject);
begin
    PagePrincipal.PageIndex := 0;
    TabModuloFuncao.TabVisible := False;
    self.Height := 215;
    LimpaTela;
end;

procedure TFCadModulo.BModificarClick(Sender: TObject);
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
        finterface.Desconecta;
        Exit;
    end;
    if MDModulo.Active = False then
    begin
        ShowMessage('MDModulo não está ativo');
        Exit;
    end;
    if ((EID.Text = '') or (EID.Text = '0')) then
    begin
        ShowMessage('Operação cancelada, selecione um Módulo para alterar');
        exit;
    end;
    if GravaRegistros('TabModulo', False) then
    begin
        VL_Codigo := finterface.AlterarRegistro('0090', MDModulo, '006C', StrToInt(EID.Text), '0075', 'S', VL_Tag);

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
                MDModulo.Locate('ID', StrToInt(EID.Text), []);
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
        MDModulo.Locate('ID', StrToInt(EID.Text), []);
        CarregaCampos;
        VL_Mensagem.Free;
    end;
end;

procedure TFCadModulo.BPesquisarClick(Sender: TObject);
var
    VL_FPesquisaModulo: TFPesquisaModulo;
begin
    if F_Permissao = False then
        exit;
    CarregarModulo(0);
    VL_FPesquisaModulo := TFPesquisaModulo.Create(Self);
    VL_FPesquisaModulo.F_Tabela := RxMemDataToStr(MDModulo);
    LimpaTela;
    VL_FPesquisaModulo.ShowModal;
    if VL_FPesquisaModulo.F_Carregado then
    begin
        CarregarModulo(VL_FPesquisaModulo.MDModulo.FieldByName('ID').AsInteger);
        CarregaCampos;
    end;
end;

procedure TFCadModulo.BPesquisaTagClick(Sender: TObject);
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

procedure TFCadModulo.BFuncaoLojaClick(Sender: TObject);
begin
    if (EID.Text = '') then
        exit;

    if ((F_Navegar) and (F_Permissao) and (MDModulo.RecordCount > 0)) then
    begin
        CarregarModulo(MDModulo.FieldByName('ID').AsInteger);
        TabModuloFuncaoETipoFiltro.ItemIndex := 0;
        TabModuloFuncaoCKSelecionada.Checked := False;
        TabModuloFuncaoETipoFiltro.OnChange(SELF);
    end
    else
        MDModuloFunc.EmptyTable;

    TabModuloFuncao.TabVisible := True;
    self.Height := 480;
end;

procedure TFCadModulo.BAdicionarClick(Sender: TObject);
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
        if MDModulo.Active = False then
        begin
            ShowMessage('MDModulo não está ativo');
            Exit;
        end;
        if EDescricao.Text = '' then
        begin
            ShowMessage('Descricao é um campo obrigatório');
            exit;
        end;
        if LENGTH(EID.Text) > 0 then
        begin
            ShowMessage('Limpe o cadastro antes de Adicionar uma loja');
            exit;
        end;
        if GravaRegistros('TabModulo', True) then
        begin
            VL_Codigo := finterface.IncluirRegistro(MDModulo, '0074', 'S', '0090', VL_Tag);
            if mensagemerro(VL_Codigo, V_Erro) <> 0 then
            begin
                ShowMessage('Erro: ' + IntToStr(VL_Codigo) + #13 + V_Erro);
                if MDModulo.Locate('ID', 0, []) then
                    MDModulo.Delete;
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
                    if MDModulo.Locate('ID', 0, []) then
                        MDModulo.Delete;
                    Exit;
                end;
                '0074':
                begin
                    if VL_Tag <> 'R' then
                    begin
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                        if MDModulo.Locate('ID', 0, []) then
                            MDModulo.Delete;
                        Exit;
                    end;
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    if vl_tag <> '0' then
                    begin
                        mensagemerro(StrToInt(vL_Tag), V_Erro);
                        ShowMessage('Erro: ' + VL_Tag + #13 + V_Erro);
                        if MDModulo.Locate('ID', 0, []) then
                            MDModulo.Delete;
                        Exit;
                    end;
                    VL_Mensagem.GetTag('006C', VL_ID); //RETORNO DO ID DO MODULO
                    F_Navegar := False;
                    if MDModulo.Locate('ID', 0, []) then
                    begin
                        MDModulo.Edit;
                        MDModulo.FieldByName('ID').AsInteger := VL_ID;
                        MDModulo.Post;
                    end;
                    F_Navegar := True;
                end;
            end;
            MDModulo.Locate('ID', VL_ID, []);
            CarregaCampos;
            ShowMessage('Registro incluido com sucesso');
        end;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;

end;

procedure TFCadModulo.BConfigModuloClick(Sender: TObject);
VAR
    VL_FModuloConfig : TFModuloConfig;
begin
    if length(eid.Text) < 1 then
    begin
        ShowMessage('Voce deve selecionar um Módulo para abrir a configuração do mesmo');
        Exit;
    end;
    VL_FModuloConfig :=TFModuloConfig.Create(SELF);
    VL_FModuloConfig.V_ModuloID:=STRTOINT(EID.TEXT);
    VL_FModuloConfig.ShowModal;
end;

procedure TFCadModulo.BExcluirClick(Sender: TObject);
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
            finterface.Desconecta;
            Exit;
        end;
        if MDModulo.Active = False then
        begin
            ShowMessage('MDModulo não está ativo');
            Exit;
        end;
        if MDModulo.RecordCount = 0 then
        begin
            ShowMessage('Não existe Módulo para ser excluido');
            exit;
        end;
        VL_Codigo := finterface.ExcluirRegistro('006C', MDModulo.FieldByName('ID').AsInteger, '002B', 'S', VL_Tag);

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
                VL_Mensagem.GetTag('0026', VL_ID);
                mensagemerro(VL_ID, V_Erro);
                ShowMessage('Erro: ' + IntToStr(VL_ID) + #13 + V_Erro);
                Exit;
            end;
            '002B':
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
                VL_Mensagem.GetTag('006C', VL_ID); //MODULO_ID
                F_Navegar := False;
                if MDModulo.Locate('ID', VL_ID, []) then
                    MDModulo.Delete;
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

procedure TFCadModulo.FormShow(Sender: TObject);
begin
    //prepara a tela
    CarregarModulo(0);
    LimpaTela;
    PagePrincipal.PageIndex := 0;
    TabModuloFuncao.TabVisible := False;
    self.Height := 215;
end;

procedure TFCadModulo.MDModuloFuncCalcFields(DataSet: TDataSet);
begin
    if (F_Permissao) then
    begin
        DataSet.FieldByName('VALIDADO_F').AsBoolean := DataSet.FieldByName('VALIDADO').AsBoolean;
        DataSet.FieldByName('HABILITADO_F').AsBoolean := DataSet.FieldByName('HABILITADO').AsBoolean;
    end;
end;

procedure TFCadModulo.MDModuloFuncFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin

end;

procedure TFCadModulo.TabModuloFuncaoBVoltarClick(Sender: TObject);
begin
    PagePrincipal.PageIndex := 0;
    TabModuloFuncao.TabVisible := False;
    self.Height := 215;
end;

procedure TFCadModulo.TabModuloFuncaoCKSelecionadaChange(Sender: TObject);
begin
    if TabModuloFuncaoCKSelecionada.Checked then
    begin
        MDModuloFunc.Filter := 'VALIDADO=''T''';
        MDModuloFunc.Filtered := True;
    end
    else
    begin
        TabModuloFuncaoETipoFiltro.ItemIndex := 0;
        TabModuloFuncaoETipoFiltro.OnChange(SELF);
    end;
end;

procedure TFCadModulo.TabModuloFuncaoEFiltroChange(Sender: TObject);
var
    VL_Filtro: string;
begin
    if F_Permissao = False then
        EXIT;
    VL_Filtro := '';
    MDModuloFunc.Filter := finterface.FiltrarTabela(TabModuloFuncaoGrid, VL_Filtro, TabModuloFuncaoEFiltro);
    TabModuloFuncaoLFiltro.Caption := VL_Filtro;
    MDModuloFunc.Filtered := True;
end;

procedure TFCadModulo.TabModuloFuncaoETipoFiltroChange(Sender: TObject);
begin
    TabModuloFuncaoCKSelecionada.Checked := False;
    if TabModuloFuncaoETipoFiltro.ItemIndex < 1 then
    begin
        MDModuloFunc.Filter := '';
        MDModuloFunc.Filtered := False;
    end
    else
    begin
        MDModuloFunc.Filter := 'TAG_TIPO=''' + TabModuloFuncaoETipoFiltro.Text + '''';
        MDModuloFunc.Filtered := True;
    end;
end;

procedure TFCadModulo.TabModuloFuncaoGridCellClick(Column: TColumn);
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
        if ((MDModulo.Active = False) or (MDModulo.RecordCount < 1)) then
            exit;
        if (MDModuloFunc.Active = False) then
            exit;
        F_Navegar := False;
        if ((Column.FieldName = 'VALIDADO_F') or (Column.FieldName = 'HABILITADO_F')) then
        begin
            VL_ID := MDModuloFuncID.AsInteger;
            VL_Tag := MDModuloFuncTAG_NUMERO.AsString;

            if MDModuloFunc.Filtered then
            begin
                MDModuloFunc.Filtered := False;
                if VL_ID = 0 then
                    MDModuloFunc.Locate('TAG_NUMERO', VL_Tag, [])
                else
                    MDModuloFunc.Locate('ID', VL_ID, []);
            end;

            if (Column.FieldName = 'VALIDADO_F') then
            begin
                MDModuloFunc.Edit;
                MDModuloFunc.FieldByName('VALIDADO').AsBoolean := not MDModuloFunc.FieldByName('VALIDADO').AsBoolean;
                MDModuloFunc.Post;
            end;
            if (Column.FieldName = 'HABILITADO_F') then
            begin
                MDModuloFunc.Edit;
                MDModuloFunc.FieldByName('HABILITADO').AsBoolean := not MDModuloFunc.FieldByName('HABILITADO').AsBoolean;
                MDModuloFunc.Post;
            end;
            if ((MDModuloFunc.FieldByName('VALIDADO').AsString = 'T') and (VL_ID < 1)) then
            begin
                MDModuloFunc.Edit;
                MDModuloFunc.FieldByName('MODULO_ID').AsString := EID.Text;
                MDModuloFunc.FieldByName('ID').AsInteger := 0;
                MDModuloFunc.Post;
                //incluir modulo função
                VL_Codigo := finterface.IncluirRegistro(MDModuloFunc, '007E', 'S', '0092', VL_Tag);

                if mensagemerro(VL_Codigo, V_Erro) <> 0 then
                begin
                    ShowMessage('Erro: ' + IntToStr(VL_Codigo) + #13 + V_Erro);
                    if MDModuloFunc.Locate('ID', 0, []) then
                        MDModuloFunc.Delete;
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
                        if MDModuloFunc.Locate('ID', 0, []) then
                            MDModuloFunc.Delete;
                        Exit;
                    end;
                    '007E':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                            if MDModuloFunc.Locate('ID', 0, []) then
                                MDModuloFunc.Delete;
                            Exit;
                        end;
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        if vl_tag <> '0' then
                        begin
                            mensagemerro(StrToInt(VL_Tag), V_Erro);
                            ShowMessage('Erro:' + VL_Tag + #13 + V_Erro);
                            if MDModuloFunc.Locate('ID', 0, []) then
                                MDModuloFunc.Delete;
                            Exit;
                        end;
                        VL_Mensagem.GetTag('008B', VL_ID); //RETORNO DO ID DO MODULO_FUNC
                        F_Navegar := False;
                        if MDModuloFunc.Locate('ID', 0, []) then
                        begin
                            MDModuloFunc.Edit;
                            MDModuloFunc.FieldByName('ID').AsInteger := VL_ID;
                            MDModuloFunc.Post;
                        end;
                        F_Navegar := True;
                    end;
                end;
            end
            else
            if ((MDModuloFunc.FieldByName('VALIDADO').AsString = 'T') and (VL_ID > 0)) then
            begin
                //ALTERA MODULO_FUNCAO
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00B9', 'S');
                VL_Mensagem.AddTag('008B', VL_ID);
                VL_Mensagem.AddTag('00C6', MDModuloFunc.FieldByName('HABILITADO').AsString);
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
                    '00B9':
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
                //EXCLUIR modulo função
                VL_Codigo := finterface.ExcluirRegistro('008B', VL_ID, '007F', 'S', VL_Tag);

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
                    '007F':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                        end;
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        if vl_tag <> '0' then
                        begin
                            mensagemerro(StrToInt(VL_Tag), V_Erro);
                            ShowMessage('Erro: ' + VL_Tag + #13 + V_Erro);
                        end;
                    end;
                end;
                sair:
                    MDModuloFunc.Edit;
                MDModuloFunc.FieldByName('ID').AsInteger := -1;
                MDModuloFunc.FieldByName('HABILITADO').AsString := 'F';
                MDModuloFunc.FieldByName('HABILITADO_F').AsBoolean := False;
                MDModuloFunc.Post;
            end;
        end;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
        MDModuloFunc.Filtered := True;
    end;

end;

procedure TFCadModulo.CarregarModulo(VP_ModuloID: integer);
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
        VL_Mensagem.AddTag('006E', 0); //tag_id
        VL_Mensagem.AddTag('006C', 0); //modulo_id

        VL_Mensagem.TagToStr(VL_Tag);

        if VP_ModuloID = 0 then
            VL_Tag := FInterface.PesquisaTabelas('0070', 'S', '006C', VP_ModuloID, VL_Tag)
        else
            VL_Tag := FInterface.PesquisaTabelas('0070', 'S', '006C', VP_ModuloID, '');

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
                //TABELA MODULO
                if VL_Mensagem.GetTag('0090', VL_Tag) = 0 then
                begin
                    if MDModulo.Active then
                        MDModulo.EmptyTable;
                    StrToRxMemData(VL_Tag, MDModulo);
                    MDModulo.Open;
                end;
                //TABELA MODULO FUNCAO
                if VL_Mensagem.GetTag('0092', VL_Tag) = 0 then
                begin
                    if MDModuloFunc.Active then
                        MDModuloFunc.EmptyTable;

                    if VL_Tabela.Active then
                        VL_Tabela.EmptyTable;
                    StrToRxMemData(VL_Tag, VL_Tabela);
                    CopiaDadosSimples(VL_Tabela, MDModuloFunc);
                end;
            end;
        end;
    finally
        VL_Tabela.Free;
        VL_Mensagem.Free;
    end;

end;

function TFCadModulo.GravaRegistros(VP_Tab: string; VP_Incluir: boolean): boolean;
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
        //grava TabModulo
        if VP_Tab = 'TabModulo' then
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
                VL_ID := MDModulo.FieldByName('ID').AsInteger;

            if VP_Incluir then
                MDModulo.Insert
            else
                MDModulo.Edit;

            MDModulo.FieldByName('ID').AsInteger := VL_ID;
            MDModulo.FieldByName('DESCRICAO').AsString := EDescricao.Text;
            MDModulo.FieldByName('TAG_NUMERO').AsString := ETagID.Text;
            MDModulo.Post;
            Result := True;
        end;
    finally
        F_Navegar := True;
    end;
end;

procedure TFCadModulo.LimpaTela;
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
            if Components[i] is TRxMemoryData then
                if TRxMemoryData(Components[i]).Active then
                    if TRxMemoryData(Components[i]) <> TRxMemoryData(MDTags) then
                        TRxMemoryData(Components[i]).EmptyTable;
        end;
    end;

end;

procedure TFCadModulo.CarregaCampos;
begin
    //CARREGA OS CAMPOS
    if F_Navegar = False then
        exit;
    //CARREGA MODULO
    EID.Text := MDModulo.FieldByName('ID').AsString;
    EDescricao.Text := MDModulo.FieldByName('DESCRICAO').AsString;
    if MDTags.Locate('TAG_NUMERO', MDModulo.FieldByName('TAG_NUMERO').AsString, []) then
    begin
        ETagID.Text := MDTags.FieldByName('TAG_NUMERO').AsString;
        ETag.Text := MDTags.FieldByName('DEFINICAO').AsString;
    end;
end;

end.
