unit uprincipal;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls,
    StdCtrls, DBGrids, MaskEdit, DBCtrls, Buttons, ZDataset, ZConnection, funcoes,
    IniFiles, DB, BufDataset, rxmemds, RxDBGrid, rxlookup;
type

    { Tfprincipal }

    TResposta = record
        Codigo: integer;
        Dados: string;
    end;

    TTipoConfigurador = (tcConfigurador, tcAdministrador, tcUsuario);

    TConexaoStatus = (csDesconectado, csLink, csChaveado, csLogado);

    PResposta = ^TResposta;

    TPResposta = procedure(VP_Codigo: integer; VP_Dados: ansistring); stdcall;

    Tfprincipal = class(TForm)
        CTipo: TComboBox;
        DSPinPad: TDataSource;
        DSConfigurador: TDataSource;
        Label1: TLabel;
        MDLoja: TRxMemoryData;
        MDPdv: TRxMemoryData;
        MDPinPad: TRxMemoryData;
        MDLojaPDV: TRxMemoryData;
        MDConfigurador: TRxMemoryData;
        PTipoConfigurador: TPageControl;
        TabPdvCLoja: TRxDBLookupCombo;
        TabConfBGeraChave: TSpeedButton;
        TabSheet1: TTabSheet;
        TabSheet2: TTabSheet;
        TabSheet3: TTabSheet;
        TabSheet4: TTabSheet;
        TabSheet5: TTabSheet;
        TabTipoConfESenha: TEdit;
        TabTipoAdmESenha: TEdit;
        TabTipoUsuESenha: TEdit;
        TabTipoConfLSenha: TLabel;
        TabTipoAdmLSenha: TLabel;
        TabTipoUsuLSenha: TLabel;
        TabPdvEChave: TMemo;
        TabPdvBGeraChave: TSpeedButton;
        DSLojaPdv: TDataSource;
        DSPdv: TDataSource;
        DSLoja: TDataSource;
        LTipo: TLabel;
        TabConfEChave: TMemo;
        TabPinPadMFabricante: TMemo;
        PageCadastro: TPageControl;
        TabConfBAdicionar: TToggleBox;
        TabConfBExcluir: TToggleBox;
        TabConfBModificar: TToggleBox;
        TabConfEDescricao: TEdit;
        TabConfEFiltro: TEdit;
        TabConfEID: TEdit;
        TabConfEIP: TEdit;
        TabConfGrid: TDBGrid;
        TabConfLChave: TLabel;
        TabConfLDescricao: TLabel;
        TabConfLFiltro: TLabel;
        TabConfLID: TLabel;
        TabConfLIP: TLabel;
        TabConfPPrincipal: TPanel;
        TabLojaBAdicionar: TToggleBox;
        TabPinPadBAdicionar: TToggleBox;
        TabLojaBExcluir: TToggleBox;
        TabPinPadBExcluir: TToggleBox;
        TabLojaBModificar: TToggleBox;
        TabPinPadBModificar: TToggleBox;
        TabLojaECnpj: TMaskEdit;
        TabLojaEFantasia: TEdit;
        TabLojaEFiltro: TEdit;
        TabPinPadEFiltro: TEdit;
        TabLojaEID: TEdit;
        TabPinPadEID: TEdit;
        TabLojaERazao: TEdit;
        TabLojaGrid: TDBGrid;
        TabPinPadGrid: TDBGrid;
        TabLojaLCnpj: TLabel;
        TabLojaLFantasia: TLabel;
        TabLojaLFiltro: TLabel;
        TabPinPadLFiltro: TLabel;
        TabLojaLID: TLabel;
        TabPinPadLID: TLabel;
        TabLojaLRazao: TLabel;
        TabPinPadLFabricante: TLabel;
        TabLojaPPrincipal: TPanel;
        ESenha: TEdit;
        LSenha: TLabel;
        LStatus: TLabel;
        EStatus: TLabel;
        PagePrincipal: TPageControl;
        PTopo: TPanel;
        PPrincipal: TPanel;
        PStatus: TPanel;
        TabCadastro: TTabSheet;
        TabPinPadPPrincipal: TPanel;
        TabPdvBAdicionar: TToggleBox;
        TabPdvBExcluir: TToggleBox;
        TabPdvBModificar: TToggleBox;
        TabPdvEDescricao: TEdit;
        TabPdvEFiltro: TEdit;
        TabPdvEID: TEdit;
        TabPdvEIP: TEdit;
        TabPdvGrid: TDBGrid;
        TabPdvLChave: TLabel;
        TabPdvLDescricao: TLabel;
        TabPdvLFiltro: TLabel;
        TabPdvLID: TLabel;
        TabPdvLIP: TLabel;
        TabPdvLLoja: TLabel;
        TabPdvPPrincipal: TPanel;
        BConectar: TToggleBox;
        TabLoja: TTabSheet;
        TabPDV: TTabSheet;
        TabPinPad: TTabSheet;
        TabConf: TTabSheet;
        TabTipoConf: TTabSheet;
        TabTipoAdm: TTabSheet;
        TabTipoUsu: TTabSheet;
        procedure BConectarChange(Sender: TObject);
        procedure BConectarClick(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure FormShow(Sender: TObject);
        function ErroLogin(VP_Erro: integer): string;
        procedure MDConfiguradorAfterScroll(DataSet: TDataSet);
        procedure MDConfiguradorFilterRecord(DataSet: TDataSet; var Accept: boolean);
        procedure MDLojaAfterScroll(DataSet: TDataSet);
        procedure MDLojaFilterRecord(DataSet: TDataSet; var Accept: boolean);
        procedure MDPdvAfterScroll(DataSet: TDataSet);
        procedure MDPdvFilterRecord(DataSet: TDataSet; var Accept: boolean);
        procedure MDPinPadAfterScroll(DataSet: TDataSet);
        procedure MDPinPadFilterRecord(DataSet: TDataSet; var Accept: boolean);
        procedure TabConfBAdicionarClick(Sender: TObject);
        procedure TabConfBGeraChaveClick(Sender: TObject);
        procedure TabConfBModificarClick(Sender: TObject);
        procedure TabConfEFiltroChange(Sender: TObject);
        procedure TabConfGridCellClick(Column: TColumn);
        procedure TabLojaBAdicionarClick(Sender: TObject);
        procedure TabLojaBModificarClick(Sender: TObject);
        procedure TabLojaEFiltroChange(Sender: TObject);
        procedure TabLojaGridCellClick(Column: TColumn);
        procedure TabPdvBAdicionarClick(Sender: TObject);
        procedure TabPdvBGeraChaveClick(Sender: TObject);
        procedure TabPdvBModificarClick(Sender: TObject);
        procedure TabPdvEFiltroChange(Sender: TObject);
        procedure TabPdvGridCellClick(Column: TColumn);
        procedure TabPinPadBAdicionarClick(Sender: TObject);
        procedure TabPinPadBModificarClick(Sender: TObject);
        procedure TabPinPadEFiltroChange(Sender: TObject);
    private
        procedure Conectar;
        procedure Desconectar;
        procedure LimparTela;
        procedure CarregaCampos;
        procedure CarregarTabelas;
        function GravaRegistros(VP_Tab: string; VP_Incluir: boolean = False): boolean;
        procedure IncluirRegistro(VP_Tabela: TRxMemoryData; VP_TagComando, VP_TagComandoDados: string);
        procedure AlterarRegistro(VP_Tabela: TRxMemoryData; VP_ID: string; VP_TagComando, VP_TagComandoDados: string);

    public

    end;

    TTefInicializar = function(): integer; stdcall;
    TTefFinalizar = function(): integer; stdcall;
    TTLogin = function(VP_Host: ansistring; VP_Porta: integer; VP_Chave: ansistring; VP_Versao_Comunicacao: integer;
        VP_Senha: ansistring; VP_Tipo: ansistring; var VO_Mensagem: ansistring): integer; stdcall;
    TTOpenTefStatus = function(var VO_StatusRetorno: integer): integer; stdcall;
    TTSolicitacaoBlocante = function(VP_Dados: ansistring; var VO_Retorno: ansistring): integer; stdcall;


var
    F_Principal: Tfprincipal;
    F_ComLib: THandle;
    F_TefInicializar: TTefInicializar;
    F_TefFinalizar: TTefFinalizar;
    F_TLogin: TTLogin;
    F_TOpenTefStatus: TTOpenTefStatus;
    F_TSolicitacaoBlocante: TTSolicitacaoBlocante;
    F_Conf: TIniFile;
    F_Host: string;
    F_Porta: integer;
    F_Chave: string;
    F_Permissao: string;
    F_Funcao: TDFuncoes;
    F_Navegar: boolean;
    F_TipoConfigurador: TTipoConfigurador;

const
    C_Versao_TefLib = '1.1.1';
    C_Versao_Mensagem = 1;

implementation

{$R *.lfm}

{ Tfprincipal }

procedure Tfprincipal.BConectarClick(Sender: TObject);
var
    VL_Codigo, VL_Status: integer;
    VL_TMensagem: TMensagem;
    VL_Tag: string;
    VL_Senha: ansistring;
    VL_Tipo: ansistring;
    VL_SMensage: ansistring;
begin
    if BConectar.Caption = 'Desconectar' then
    begin
        Desconectar;
        Exit;
    end;
    VL_TMensagem := TMensagem.Create;
    VL_Tag := '';
    VL_Senha := '';
    VL_Tipo := '';
    VL_SMensage := '';
    VL_Status := 0;
    if not FileExists(ExtractFilePath(ParamStr(0)) + 'config_tef.ini') then
    begin
        F_Conf := TIniFile.Create(PChar(ExtractFilePath(ParamStr(0)) + 'config_tef.ini'));
        F_Conf.WriteInteger('Servidor', 'Porta', 0);
        F_Conf.WriteString('Servidor', 'Host', '');
        F_Conf.WriteString('Servidor', 'Chave', '');
        F_Conf.Free;
    end;

    F_Conf := TIniFile.Create(PChar(ExtractFilePath(ParamStr(0)) + 'config_tef.ini'));

    if F_Conf.ReadInteger('Servidor', 'Porta', 0) <> 0 then
    begin
        F_Porta := F_Conf.ReadInteger('Servidor', 'Porta', 0);
        F_Host := F_Conf.ReadString('Servidor', 'Host', '');
        F_Chave := F_Conf.ReadString('Servidor', 'Chave', '');
    end;
    VL_Senha := ESenha.Text;
    case CTipo.ItemIndex of
        Ord(tcConfigurador): VL_Tipo := 'C';
        Ord(tcAdministrador): VL_Tipo := 'A';
        Ord(tcUsuario): VL_Tipo := 'U';
        else
            VL_Tipo := 'ndf';
    end;

    if VL_Tipo = 'ndf' then
    begin
        ShowMessage('Define um tipo de configurador para logar');
        exit;
    end;

    VL_Codigo := F_TLogin(F_Host, F_Porta, F_Chave, C_Versao_Mensagem, VL_Senha, VL_Tipo, VL_SMensage);


    if VL_Codigo <> 0 then
        ShowMessage(IntToStr(VL_Codigo));

    F_TOpenTefStatus(VL_Status);

    VL_TMensagem.CarregaTags(VL_SMensage);
    VL_TMensagem.GetTag('0038', F_Permissao);

    if Ord(csLogado) = VL_Status then
    begin
        EStatus.Caption := 'Logado';
        EStatus.Font.Color := clGreen;
        BConectar.Caption := 'Desconectar';
        CarregarTabelas;
        Exit;
    end;


    VL_TMensagem.GetTag('0036', VL_Tag);

    if VL_Tag <> '0' then
        ShowMessage(ErroLogin(StrToInt(vl_tag)));

end;

procedure Tfprincipal.BConectarChange(Sender: TObject);
begin

end;

procedure Tfprincipal.FormCreate(Sender: TObject);
begin
    Conectar;
    F_Funcao := TDFuncoes.Create(self);
    F_Navegar := True;
end;

procedure Tfprincipal.FormShow(Sender: TObject);
begin
    LimparTela;
    //carrega pagetag
    TabConf.TabVisible := False;
end;

function Tfprincipal.ErroLogin(VP_Erro: integer): string;
begin
    if VP_Erro = 0 then
        exit;
    Result := '';

    case VP_Erro of
        36:
            Result := 'IP não informado para o TEF';
        37:
            Result := 'Senha não informada para o TEF';
        38:
            Result := 'IP não compativel para o Terminal';
        39:
            Result := 'Senha não compativel para o Terminal';
        40:
            Result := 'Erro ao validar o Terminal';
        41:
            Result := 'Chave do Terminal não localizada';
    end;
end;

procedure Tfprincipal.MDConfiguradorAfterScroll(DataSet: TDataSet);
begin
    if ((MDConfigurador.Active = False) or (MDConfigurador.RecordCount = 0) or (F_Navegar = False)) then
        exit;
    CarregaCampos;
end;

procedure Tfprincipal.MDConfiguradorFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin

end;

procedure Tfprincipal.CarregaCampos;
begin
    if length(F_Permissao) = 0 then
        exit;
    //monta configurador
    if F_Permissao = 'C' then
    begin
        TabConf.TabVisible := True;
    end
    else
    if F_Permissao = 'A' then
    begin
        TabConf.TabVisible := False;
    end
    else
    if F_Permissao = 'U' then
    begin
        TabConf.TabVisible := False;
    end
    else
    begin
        ShowMessage('Permissão não configurada');
        exit;
    end;

    //TabLoja
    TabLojaEID.Text := MDLoja.FieldByName('ID').AsString;
    TabLojaECnpj.Text := MDLoja.FieldByName('CNPJ').AsString;
    TabLojaERazao.Text := MDLoja.FieldByName('RAZAO').AsString;
    TabLojaEFantasia.Text := MDLoja.FieldByName('FANTASIA').AsString;
    //TabPdv
    MDLojaPdv.Locate('ID', MDPdv.FieldByName('LOJA_ID').AsInteger, []);
    TabPdvCLoja.KeyValue := MDLojaPdv.FieldByName('RAZAO').AsVariant;
    TabPdvEID.Text := MDPdv.FieldByName('ID').AsString;
    TabPdvEIP.Text := MDPdv.FieldByName('IP').AsString;
    TabPdvEDescricao.Text := MDPdv.FieldByName('DESCRICAO').AsString;
    TabPdvEChave.Text := MDPdv.FieldByName('CHAVE').AsString;
    //TabPinPad
    TabPinPadEID.Text := MDPinPad.FieldByName('ID').AsString;
    TabPinPadMFabricante.Lines.Text :=
        MDPinPad.FieldByName('FABRICANTE_MODELO').AsString;
    //TabConfigurador
    TabConfEID.Text := MDConfigurador.FieldByName('ID').AsString;
    TabConfEDescricao.Text := MDConfigurador.FieldByName('DESCRICAO').AsString;
    TabConfEIP.Text := MDConfigurador.FieldByName('IP').AsString;
    TabConfEChave.Lines.Text := MDConfigurador.FieldByName('CHAVE').AsString;
    TabTipoConfESenha.Text := MDConfigurador.FieldByName('SENHA_CONFIGURADOR').AsString;
    TabTipoAdmESenha.Text := MDConfigurador.FieldByName('SENHA_ADMINISTRADOR').AsString;
    TabTipoUsuESenha.Text := MDConfigurador.FieldByName('SENHA_USUARIO').AsString;
end;

function Tfprincipal.GravaRegistros(VP_Tab: string; VP_Incluir: boolean = False): boolean;
var
    VL_ID: integer;
    VL_TipoConfigurador: TTipoConfigurador;
begin
    Result := False;
    F_Navegar := False;
    try
        //grava TabLoja
        if VP_Tab = 'TabLoja' then
        begin
            if F_Permissao = 'U' then
            begin
                ShowMessage('Sem Permissão de Gravação, usuário apenas de leitura');
                F_Navegar := True;
                exit;
            end;
            if VP_Incluir then
                VL_ID := 0
            else
                VL_ID := MDLoja.FieldByName('ID').AsInteger;

            if VP_Incluir then
                MDLoja.Insert
            else
                MDLoja.Edit;

            MDLoja.FieldByName('ID').AsInteger := VL_ID;
            MDLoja.FieldByName('CNPJ').AsString := TabLojaECnpj.Text;
            MDLoja.FieldByName('RAZAO').AsString := TabLojaERazao.Text;
            MDLoja.FieldByName('FANTASIA').AsString := TabLojaEFantasia.Text;

            MDLoja.Post;
            Result := True;
        end
        else
        //grava TabPdv
        if VP_Tab = 'TabPdv' then
        begin
            if F_Permissao = 'U' then
            begin
                ShowMessage('Sem Permissão de Gravação, usuário apenas de leitura');
                F_Navegar := True;
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
            MDLojaPDV.Locate('RAZAO', TabPdvCLoja.KeyValue, []);
            MDPdv.FieldByName('LOJA_ID').AsInteger :=
                MDLojaPdv.FieldByName('ID').AsInteger;
            MDPdv.FieldByName('IP').AsString := TabPdvEIP.Text;
            MDPdv.FieldByName('DESCRICAO').AsString := TabPdvEDescricao.Text;
            MDPdv.FieldByName('CHAVE').AsString := TabPdvEChave.Text;
            MDPdv.Post;
            Result := True;
        end
        else
        //grava TabPinPad
        if VP_Tab = 'TabPinPad' then
        begin
            if F_Permissao = 'U' then
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
            MDPinPad.FieldByName('FABRICANTE_MODELO').AsString :=
                TabPinPadMFabricante.Lines.Text;
            MDPinPad.Post;
            Result := True;
        end
        else
        //grava TabConf
        if VP_Tab = 'TabConf' then
        begin
            if F_Permissao = 'U' then
            begin
                ShowMessage('Sem Permissão de Gravação, usuário apenas de leitura');
                F_Navegar := True;
                exit;
            end;
            if VP_Incluir then
                VL_ID := 0
            else
                VL_ID := MDConfigurador.FieldByName('ID').AsInteger;

            if VP_Incluir then
                MDConfigurador.Insert
            else
                MDConfigurador.Edit;

            MDConfigurador.FieldByName('ID').AsInteger := VL_ID;
            MDConfigurador.FieldByName('IP').AsString := TabConfEIP.Text;
            MDConfigurador.FieldByName('DESCRICAO').AsString := TabConfEDescricao.Text;
            MDConfigurador.FieldByName('CHAVE').AsString := TabConfEChave.Lines.Text;
            MDConfigurador.FieldByName('SENHA_CONFIGURADOR').AsString := TabTipoConfESenha.Text;
            MDConfigurador.FieldByName('SENHA_ADMINISTRADOR').AsString := TabTipoAdmESenha.Text;
            MDConfigurador.FieldByName('SENHA_USUARIO').AsString := TabTipoUsuESenha.Text;
            MDConfigurador.Post;
            Result := True;
        end;

    finally
        F_Navegar := True;
    end;
end;

procedure Tfprincipal.IncluirRegistro(VP_Tabela: TRxMemoryData; VP_TagComando, VP_TagComandoDados: string);
var
    VL_Tabela: string;
    VL_Mensagem: TMensagem;
    VL_Tag: ansistring;
    VL_Codigo: integer;
    VL_Retorno: ansistring;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Tabela := '';
    try
        VL_Tabela := F_Funcao.RxMemDataToStr(VP_Tabela);
        VL_Mensagem.AddComando(VP_TagComando, VP_TagComandoDados);
        VL_Mensagem.AddTag('003A', VL_Tabela);
        VL_Mensagem.AddTag('0037', F_Permissao);

        VL_Mensagem.TagToStr(VL_Tag);
        VL_Codigo := F_TSolicitacaoBlocante(VL_Tag, VL_Tag);

        if VL_Codigo <> 0 then
        begin
            ShowMessage(IntToStr(VL_Codigo));
            exit;
        end;

        VL_Mensagem.Limpar;
        VL_Mensagem.CarregaTags(VL_Tag);
        VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

        case VL_Retorno of
            '0026':
            begin
                VL_Mensagem.GetTag('0026', VL_Tag);
                ShowMessage('ERRO:' + VL_Tag);
                VP_Tabela.Delete;
                Exit;
            end;
            '003B':
            begin
                VL_Mensagem.GetTag('0036', VL_Tag);
                F_Navegar := False;
                if VP_Tabela.Locate('ID', 0, []) then
                begin
                    VP_Tabela.Edit;
                    VP_Tabela.FieldByName('ID').AsString := VL_Tag;
                    VP_Tabela.Post;
                end;
            end;
        end;
        CarregaCampos;
        ShowMessage('Registro incluido com sucesso');
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;
end;

procedure Tfprincipal.AlterarRegistro(VP_Tabela: TRxMemoryData; VP_ID: string; VP_TagComando, VP_TagComandoDados: string);
var
    VL_Mensagem: TMensagem;
    VL_Tabela: string;
    VL_Tag: ansistring;
    VL_Codigo: integer;
    VL_Retorno: ansistring;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Tag := '';
    VL_Tabela := '';
    VL_Codigo := 0;
    VL_Retorno := '';
    try
        VL_Tabela := F_Funcao.RxMemDataToStr(VP_Tabela);
        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando(VP_TagComando, VP_TagComandoDados);
        VL_Mensagem.AddTag('003A', VL_Tabela);
        VL_Mensagem.AddTag('003D', VP_ID);
        VL_Mensagem.AddTag('0037', F_Permissao);

        VL_Mensagem.TagToStr(VL_Tag);
        VL_Codigo := F_TSolicitacaoBlocante(VL_Tag, VL_Tag);

        if VL_Codigo <> 0 then
        begin
            ShowMessage(IntToStr(VL_Codigo));
            exit;
        end;
        VL_Mensagem.Limpar;
        VL_Mensagem.CarregaTags(VL_Tag);
        VL_Mensagem.GetComando(VL_Retorno, VL_Tag);
        case VL_Retorno of
            '0026':
            begin
                VL_Mensagem.GetTag('0026', VL_Tag);
                ShowMessage('ERRO:' + VL_Tag);
                CarregarTabelas;
                MDLoja.Locate('ID', VP_ID, []);
                CarregaCampos;
                Exit;
            end;
            '0042':
                ShowMessage('Registro alterado com sucesso');
        end;
    finally
        VL_Mensagem.Free;
    end;
end;

procedure Tfprincipal.CarregarTabelas;
var
    VL_Mensagem: TMensagem;
    VL_Codigo: integer;
    VL_Tag: ansistring;
    VL_Retorno: ansistring;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_Tag := '';
    VL_Retorno := '';
    try
        F_Navegar := False;
        //carrega tabela de lojas
        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('003C', '');
        VL_Mensagem.AddTag('0040', 'ID');
        VL_Mensagem.AddTag('003D', '0');
        VL_Mensagem.TagToStr(VL_Tag);
        VL_Codigo := F_TSolicitacaoBlocante(VL_Tag, VL_Tag);
        if VL_Codigo <> 0 then
        begin
            ShowMessage(IntToStr(VL_Codigo));
            exit;
        end;
        VL_Mensagem.Limpar;
        VL_Mensagem.CarregaTags(VL_Tag);
        VL_Mensagem.GetComando(VL_Retorno, VL_Tag);
        case VL_Retorno of
            '0026':
            begin
                VL_Mensagem.GetTag('0026', VL_Tag);
                ShowMessage('ERRO:' + VL_Tag);
                Exit;
            end;
            '003E':
            begin
                if MDLoja.Active then
                    MDLoja.EmptyTable;
                if MDLojaPdv.Active then
                    MDLojaPdv.EmptyTable;
                VL_Mensagem.GetTag('0038', VL_Tag);
                F_Funcao.StrToRxMemData(VL_Tag, MDLoja);
                MDLoja.Open;
                F_Funcao.StrToRxMemData(VL_Tag, MDLojaPdv);
                MDLojaPdv.Open;
            end;
        end;
        //carrega tabela pdv
        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('0043', '');
        VL_Mensagem.AddTag('0040', 'ID');
        VL_Mensagem.AddTag('003D', '0');
        VL_Mensagem.TagToStr(VL_Tag);
        VL_Codigo := F_TSolicitacaoBlocante(VL_Tag, VL_Tag);
        if VL_Codigo <> 0 then
        begin
            ShowMessage(IntToStr(VL_Codigo));
            exit;
        end;
        VL_Mensagem.Limpar;
        VL_Mensagem.CarregaTags(VL_Tag);
        VL_Mensagem.GetComando(VL_Retorno, VL_Tag);
        case VL_Retorno of
            '0026':
            begin
                VL_Mensagem.GetTag('0026', VL_Tag);
                ShowMessage('ERRO:' + VL_Tag);
                Exit;
            end;
            '003E':
            begin
                if MDPdv.Active then
                    MDPdv.EmptyTable;
                VL_Mensagem.GetTag('0038', VL_Tag);
                F_Funcao.StrToRxMemData(VL_Tag, MDPdv);
                MDPdv.Open;
            end;
        end;
        //carrega tabela pinpad
        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('0054', '');
        VL_Mensagem.AddTag('0040', 'ID');
        VL_Mensagem.AddTag('003D', '0');
        VL_Mensagem.TagToStr(VL_Tag);
        VL_Codigo := F_TSolicitacaoBlocante(VL_Tag, VL_Tag);
        if VL_Codigo <> 0 then
        begin
            ShowMessage(IntToStr(VL_Codigo));
            exit;
        end;
        VL_Mensagem.Limpar;
        VL_Mensagem.CarregaTags(VL_Tag);
        VL_Mensagem.GetComando(VL_Retorno, VL_Tag);
        case VL_Retorno of
            '0026':
            begin
                VL_Mensagem.GetTag('0026', VL_Tag);
                ShowMessage('ERRO:' + VL_Tag);
                Exit;
            end;
            '003E':
            begin
                if MDPinPad.Active then
                    MDPinPad.EmptyTable;
                VL_Mensagem.GetTag('0038', VL_Tag);
                F_Funcao.StrToRxMemData(VL_Tag, MDPinPad);
                MDPinPad.Open;
            end;
        end;
        //carrega tabela configurador
        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('0056', '');
        VL_Mensagem.AddTag('0040', 'ID');
        VL_Mensagem.AddTag('003D', '0');
        VL_Mensagem.TagToStr(VL_Tag);
        VL_Codigo := F_TSolicitacaoBlocante(VL_Tag, VL_Tag);
        if VL_Codigo <> 0 then
        begin
            ShowMessage(IntToStr(VL_Codigo));
            exit;
        end;
        VL_Mensagem.Limpar;
        VL_Mensagem.CarregaTags(VL_Tag);
        VL_Mensagem.GetComando(VL_Retorno, VL_Tag);
        case VL_Retorno of
            '0026':
            begin
                VL_Mensagem.GetTag('0026', VL_Tag);
                ShowMessage('ERRO:' + VL_Tag);
                Exit;
            end;
            '003E':
            begin
                if MDConfigurador.Active then
                    MDConfigurador.EmptyTable;
                VL_Mensagem.GetTag('0038', VL_Tag);
                F_Funcao.StrToRxMemData(VL_Tag, MDConfigurador);
                MDConfigurador.Open;
            end;
        end;

        F_Navegar := True;
        CarregaCampos;
    finally
        VL_Mensagem.Free;
    end;
end;

procedure Tfprincipal.Conectar;
var
    VL_Status: integer;
begin
    F_ComLib := LoadLibrary(PChar(ExtractFilePath(ParamStr(0)) + '..\..\com_lib\win64\com_lib.dll'));
    Pointer(F_TefInicializar) := GetProcAddress(F_ComLib, 'inicializar');
    Pointer(F_TefFinalizar) := GetProcAddress(F_ComLib, 'finalizar');
    Pointer(F_TLogin) := GetProcAddress(F_ComLib, 'login');
    Pointer(F_TSolicitacaoBlocante) := GetProcAddress(F_ComLib, 'solicitacaoblocante');
    Pointer(F_TOpenTefStatus) := GetProcAddress(F_ComLib, 'opentefstatus');

    F_TefInicializar();
    F_TOpenTefStatus(VL_Status);
    if VL_Status = Ord(csLogado) then
    begin
        BConectar.Caption := 'Desconectar';
        EStatus.Caption := 'Logado';
        EStatus.Font.Color := clGreen;
    end
    else
    begin
        BConectar.Caption := 'Conectar';
        EStatus.Caption := 'Desconectado';
        EStatus.Font.Color := clRed;
    end;
end;

procedure Tfprincipal.Desconectar;
begin
    F_TefInicializar();
    LimparTela;
    BConectar.Caption := 'Conectar';
    EStatus.Caption := 'Desconectado';
    EStatus.Font.Color := clRed;
end;

procedure Tfprincipal.LimparTela;
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
                tmaskedit(Components[i]).Text := '';
            if Components[i] is TComboBox then
                TComboBox(Components[i]).ItemIndex := -1;
            if Components[i] is TMemo then
                TMemo(Components[i]).Clear;
        end;
    end;
    MDLoja.EmptyTable;
    MDLojaPdv.EmptyTable;
    MDPdv.EmptyTable;
    MDPinPad.EmptyTable;
    MDConfigurador.EmptyTable;
end;

procedure Tfprincipal.MDLojaAfterScroll(DataSet: TDataSet);
begin
    if ((MDLoja.Active = False) or (MDLoja.RecordCount = 0) or (F_Navegar = False)) then
        exit;
    CarregaCampos;
end;

procedure Tfprincipal.MDLojaFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin

end;

procedure Tfprincipal.MDPdvAfterScroll(DataSet: TDataSet);
begin
    if ((MDPdv.Active = False) or (MDPdv.RecordCount = 0) or (F_Navegar = False)) then
        exit;
    CarregaCampos;
end;

procedure Tfprincipal.MDPdvFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin

end;

procedure Tfprincipal.MDPinPadAfterScroll(DataSet: TDataSet);
begin
    if ((MDPinPad.Active = False) or (MDPinPad.RecordCount = 0) or (F_Navegar = False)) then
        exit;
    CarregaCampos;
end;

procedure Tfprincipal.MDPinPadFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin

end;

procedure Tfprincipal.TabConfBAdicionarClick(Sender: TObject);
var
    VL_Status: integer;
    VL_TipoConfigurador: TTipoConfigurador;
begin
    F_TOpenTefStatus(VL_Status);
    if VL_Status <> Ord(csLogado) then
    begin
        ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
        Desconectar;
        Exit;
    end;
    if MDConfigurador.Active = False then
    begin
        ShowMessage('MDConfigurador não está ativo');
        Exit;
    end;
    if TabConfEDescricao.Text = '' then
    begin
        ShowMessage('Descricao é um campo obrigatório');
        exit;
    end;
    if TabTipoConfESenha.Text = '' then
    begin
        ShowMessage('Senha é um campo obrigatório');
        exit;
    end;

    if GravaRegistros('TabConf', True) then
        IncluirRegistro(MDConfigurador, '0057', '');
end;

procedure Tfprincipal.TabConfBGeraChaveClick(Sender: TObject);
var
    VL_Mensagem: TMensagem;
    VL_Chave: string;
    VL_Tag: ansistring;
    VL_Codigo: integer;
    VL_Retorno: ansistring;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Tag := '';
    VL_Codigo := 0;
    try
        F_Funcao.CriarChaveTerminal(VL_Chave);
        if Length(VL_Chave) = 0 then
        begin
            ShowMessage('Erro ao gerar chave');
            exit;
        end;
        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('0059', '');
        VL_Mensagem.AddTag('0041', VL_Chave);
        VL_Mensagem.TagToStr(VL_Tag);
        VL_Codigo := F_TSolicitacaoBlocante(VL_Tag, VL_Tag);
        if VL_Codigo <> 0 then
        begin
            ShowMessage('Erro:' + IntToStr(VL_Codigo));
            Exit;
        end;
        VL_Mensagem.Limpar;
        VL_Mensagem.CarregaTags(VL_Tag);
        VL_Mensagem.GetComando(VL_Retorno, VL_Tag);
        case VL_Retorno of
            '0026':
            begin
                VL_Mensagem.GetTag('0026', VL_Tag);
                ShowMessage('ERRO:' + VL_Tag);
                Exit;
            end;
            '0046':
                TabConfEChave.Lines.Text := VL_Chave;
        end;
    finally
        VL_Mensagem.Free;
    end;

end;


procedure Tfprincipal.TabConfBModificarClick(Sender: TObject);
var
    VL_Status: integer;
begin
    VL_Status := 0;
    F_TOpenTefStatus(VL_Status);
    if VL_Status <> Ord(csLogado) then
    begin
        ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
        Desconectar;
        Exit;
    end;
    if MDConfigurador.Active = False then
    begin
        ShowMessage('MDConfigurador não está ativo');
        Exit;
    end;
    if TabConfEDescricao.Text = '' then
    begin
        ShowMessage('Descricao é um campo obrigatório');
        exit;
    end;
    if GravaRegistros('TabConf', False) then
        AlterarRegistro(MDConfigurador, TabConfEID.Text, '0058', '');

end;

procedure Tfprincipal.TabConfEFiltroChange(Sender: TObject);
var
    VL_Filtro: string;
begin
    VL_Filtro := TabConfGrid.SelectedColumn.FieldName;
    TabConfLFiltro.Caption := 'Filtrar por ' + VL_Filtro;
    if VL_Filtro='ID' then
       if TabConfEFiltro.Text<>'' then
           MDConfigurador.Filter := VL_Filtro +'='+ TabConfEFiltro.Text
       else
        MDConfigurador.Filter :=''
    else
    MDConfigurador.Filter := VL_Filtro + ' = (''*' + TabConfEFiltro.Text + '*'')';
    MDConfigurador.Filtered := True;

end;

procedure Tfprincipal.TabConfGridCellClick(Column: TColumn);
begin
    TabConfLFiltro.Caption := 'Filtrar por ' + TabConfGrid.SelectedColumn.FieldName;
end;

procedure Tfprincipal.TabLojaBAdicionarClick(Sender: TObject);
var
    VL_Status: integer;
begin
    F_TOpenTefStatus(VL_Status);
    if VL_Status <> Ord(csLogado) then
    begin
        ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
        Desconectar;
        Exit;
    end;
    if MDLoja.Active = False then
    begin
        ShowMessage('MDLoja não está ativo');
        Exit;
    end;
    if TabLojaECnpj.Text = '' then
    begin
        ShowMessage('CNPJ é um campo obrigatório');
        exit;
    end;
    if TabLojaERazao.Text = '' then
    begin
        ShowMessage('Razão é um campo obrigatório');
        exit;
    end;
    if GravaRegistros('TabLoja', True) then
        IncluirRegistro(MDLoja, '0039', '');
end;

procedure Tfprincipal.TabLojaBModificarClick(Sender: TObject);
var
    VL_Status: integer;
begin
    F_TOpenTefStatus(VL_Status);
    if VL_Status <> Ord(csLogado) then
    begin
        ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
        Desconectar;
        Exit;
    end;
    if MDLoja.Active = False then
    begin
        ShowMessage('MDLoja não está ativo');
        Exit;
    end;
    if TabLojaECnpj.Text = '' then
    begin
        ShowMessage('CNPJ é um campo obrigatório');
        exit;
    end;
    if TabLojaERazao.Text = '' then
    begin
        ShowMessage('Razão é um campo obrigatório');
        exit;
    end;
    if GravaRegistros('TabLoja', False) then
        AlterarRegistro(MDLoja, TabLojaEID.Text, '003F', '');
end;

procedure Tfprincipal.TabLojaEFiltroChange(Sender: TObject);
var
    VL_Filtro: string;
begin
    VL_Filtro := TabLojaGrid.SelectedColumn.FieldName;
    TabLojaLFiltro.Caption := 'Filtrar por ' + VL_Filtro;
    MDLoja.Filter := VL_Filtro + ' = (''*' + TabLojaEFiltro.Text + '*'')';
    MDLoja.Filtered := True;
end;

procedure Tfprincipal.TabLojaGridCellClick(Column: TColumn);
begin
    TabLojaLFiltro.Caption := 'Filtrar por ' + TabLojaGrid.SelectedColumn.FieldName;
end;

procedure Tfprincipal.TabPdvBAdicionarClick(Sender: TObject);
var
    VL_Status: integer;
begin
    F_TOpenTefStatus(VL_Status);
    if VL_Status <> Ord(csLogado) then
    begin
        ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
        Desconectar;
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
    if TabPdvCLoja.LookupDisplayIndex = -1 then
    begin
        ShowMessage('Voce deve selecionar uma loja para cadastrar o PDV.');
        Exit;
    end;
    if GravaRegistros('TabPdv', True) then
        IncluirRegistro(MDPdv, '0044', '');

end;

procedure Tfprincipal.TabPdvBGeraChaveClick(Sender: TObject);
var
    VL_Mensagem: TMensagem;
    VL_Chave: string;
    VL_Tag: ansistring;
    VL_Codigo: integer;
    VL_Retorno: ansistring;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Tag := '';
    VL_Codigo := 0;
    try
        F_Funcao.CriarChaveTerminal(VL_Chave);
        if Length(VL_Chave) = 0 then
        begin
            ShowMessage('Erro ao gerar chave');
            exit;
        end;
        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('0045', '');
        VL_Mensagem.AddTag('0041', VL_Chave);
        VL_Mensagem.TagToStr(VL_Tag);
        VL_Codigo := F_TSolicitacaoBlocante(VL_Tag, VL_Tag);
        if VL_Codigo <> 0 then
        begin
            ShowMessage('Erro:' + IntToStr(VL_Codigo));
            Exit;
        end;
        VL_Mensagem.Limpar;
        VL_Mensagem.CarregaTags(VL_Tag);
        VL_Mensagem.GetComando(VL_Retorno, VL_Tag);
        case VL_Retorno of
            '0026':
            begin
                VL_Mensagem.GetTag('0026', VL_Tag);
                ShowMessage('ERRO:' + VL_Tag);
                Exit;
            end;
            '0046':
                TabPdvEChave.Text := VL_Chave;
        end;
    finally
        VL_Mensagem.Free;
    end;

end;

procedure Tfprincipal.TabPdvBModificarClick(Sender: TObject);
var
    VL_Status: integer;
begin
    VL_Status := 0;
    F_TOpenTefStatus(VL_Status);
    if VL_Status <> Ord(csLogado) then
    begin
        ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
        Desconectar;
        Exit;
    end;
    if MDPdv.Active = False then
    begin
        ShowMessage('MDPdv não está ativo');
        Exit;
    end;
    if TabPdvEDescricao.Text = '' then
    begin
        ShowMessage('Descrição é um campo obrigatório');
        exit;
    end;
    if TabPdvCLoja.Text = '' then
    begin
        ShowMessage('Voce deve selecionar uma loja para incluir o Pdv, campo obrigatório');
        exit;
    end;
    if GravaRegistros('TabPdv', False) then
        AlterarRegistro(MDPdv, TabPdvEID.Text, '004B', '');

end;

procedure Tfprincipal.TabPdvEFiltroChange(Sender: TObject);
var
    VL_Filtro: string;
begin
        VL_Filtro := TabPdvGrid.SelectedColumn.FieldName;
        TabPdvLFiltro.Caption := 'Filtrar por ' + VL_Filtro;
        if VL_Filtro = 'LOJA_ID'  then
           if TabPdvEFiltro.Text<>'' then
            MDPdv.Filter := VL_Filtro + ' = ' + TabPdvEFiltro.Text
           else
            MDPdv.Filter :=''
        else
            MDPdv.Filter := VL_Filtro + ' = (''*' + TabPdvEFiltro.Text + '*'')';
        MDPdv.Filtered := True;

end;

procedure Tfprincipal.TabPdvGridCellClick(Column: TColumn);
begin
    TabPdvLFiltro.Caption := 'Filtrar por ' + TabPdvGrid.SelectedColumn.FieldName;
end;

procedure Tfprincipal.TabPinPadBAdicionarClick(Sender: TObject);
var
    VL_Status: integer;
begin
    F_TOpenTefStatus(VL_Status);
    if VL_Status <> Ord(csLogado) then
    begin
        ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
        Desconectar;
        Exit;
    end;
    if MDPinPad.Active = False then
    begin
        ShowMessage('MDPinPad não está ativo');
        Exit;
    end;
    if GravaRegistros('TabPinPad', True) then
        IncluirRegistro(MDPinPad, '0053', '');

end;

procedure Tfprincipal.TabPinPadBModificarClick(Sender: TObject);
var
    VL_Status: integer;
begin
    VL_Status := 0;
    F_TOpenTefStatus(VL_Status);
    if VL_Status <> Ord(csLogado) then
    begin
        ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
        Desconectar;
        Exit;
    end;
    if MDPinPad.Active = False then
    begin
        ShowMessage('MDPinPad não está ativo');
        Exit;
    end;
    if TabPinPadMFabricante.Lines.Text = '' then
    begin
        ShowMessage('Modelo do PinPad é um campo obrigatório');
        exit;
    end;
    if GravaRegistros('TabPinPad', False) then
        AlterarRegistro(MDPinPad, TabPinPadEID.Text, '0055', '');

end;

procedure Tfprincipal.TabPinPadEFiltroChange(Sender: TObject);
begin
    MDPinPad.Filter := 'FABRICANTE_MODELO=(''*' + TabPinPadEFiltro.Text + '*'')';
    MDPinPad.Filtered := True;
end;

end.
