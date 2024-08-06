unit uinterface;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ComCtrls,
  ExtCtrls, StdCtrls, DBGrids, DBCtrls,
  funcoes, IniFiles, DB, rxmemds, RxDBGrid, def,
  {telas}
  ulogin,
  ucadloja,
  ucadpdv,
  ucadpinpad,
  ucadadquirente,
  ucadmultloja,
  ucadmodulo,
  umoduloconfig;

type

  { TFInterface }

  TResposta = record
    Codigo: integer;
    Dados: string;
  end;

  //TConexaoStatus = (csDesconectado, csLink, csChaveado, csLogado);

  PResposta = ^TResposta;

  TPResposta = procedure(VP_Transmissao_ID: PChar; VP_Codigo: integer; VP_Dados: PChar); cdecl;

  TFInterface = class(TForm)
    EStatus: TLabel;
    LUsuario: TLabel;
    ListaImg: TImageList;
    LStatus: TLabel;
    MCadPdv: TMenuItem;
    MCadPinPad: TMenuItem;
    MCadAdquirente: TMenuItem;
    MCadLoja: TMenuItem;
    MCadMult: TMenuItem;
    MGerModulo: TMenuItem;
    MCadModulo: TMenuItem;
    MConfigModulo: TMenuItem;
    MMenu: TMainMenu;
    MCad: TMenuItem;
    MCadLojaMult: TMenuItem;
    MConectar: TMenuItem;
    PStatus: TPanel;
    MDTabela: TRxMemoryData;
    procedure ComboBox1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MCadAdquirenteClick(Sender: TObject);
    procedure MCadClick(Sender: TObject);
    procedure MCadLojaClick(Sender: TObject);
    procedure MCadMultClick(Sender: TObject);
    procedure MCadPinPadClick(Sender: TObject);
    procedure MConectarClick(Sender: TObject);
    procedure MCadPdvClick(Sender: TObject);
    procedure MCadModuloClick(Sender: TObject);
    procedure MConfigModuloClick(Sender: TObject);
  private
    procedure IniciarLib;
  public
    V_Erro: PChar;
    procedure Conectar(VP_Tipo, VP_Senha: string);
    procedure Desconecta;
    function SolicitacaoBloc(VP_Dados: ansistring; var VO_Retorno: ansistring; VP_Tempo: integer): integer;
    function PesquisaTabelas(VP_TagComando, VP_DadosComando, VP_Tag: ansistring; VP_ID: integer; VP_TagLote: ansistring): ansistring;
    function FiltrarTabela(VP_DBGrid: TRxDBGrid; var VO_RotuloCaption: string; VP_EditFiltrado: TEdit): string;
    function FiltrarTabela(VP_DBGrid: TDBGrid; var VO_RotuloCaption: string; VP_EditFiltrado: TEdit): string;
    function IncluirRegistro(VP_Tabela: TRxMemoryData; VP_TagComando, VP_TagComandoDados, VP_TagTabela: string; var VO_Retorno: ansistring): integer;
    function ExcluirRegistro(VP_Tag: string; VP_ID: integer; VP_TagComando, VP_TagComandoDados: string; var VO_Retorno: ansistring): integer;
    function AlterarRegistro(VP_TagTabela: string; VP_Tabela: TRxMemoryData; VP_Tag: string; VP_ID: int64; VP_TagComando, VP_TagComandoDados: string; var VO_Retorno: ansistring): integer;
    function ValidarChave(VP_TagChave: string; VP_Chave: ansistring; VP_TagComando, VP_TagComandoDados: string; var VO_Retorno: ansistring): integer;
    procedure Desconectar;
  end;

  TTefInicializar = function(var VO_Com: Pointer; VP_Procedimento: TRetorno; VP_ArquivoLog: PChar): integer; cdecl;
  TTefFinalizar = function(VP_Com: pointer): integer; cdecl;
  TTDesconectar = function(VP_Com: pointer): integer; cdecl;
  TTLogin = function(VP_Com: pointer; VP_Host: PChar; VP_Porta: integer; VP_ChaveComunicacao: PChar; VP_Versao_Comunicacao: integer; VP_Senha: PChar;
    VP_Tipo: PChar; VP_Terminal_ID: integer; VP_Identificacao: PChar): integer; cdecl;
  TTOpenTefStatus = function(VP_Com: pointer; var VO_StatusRetorno: integer): integer; cdecl;
  TTSolicitacaoBlocante = function(VP_Com: pointer; VP_Dados: PChar; var VO_Retorno: PChar; VP_Tempo: integer): integer; cdecl;
  TTMensagemerro = function(VP_CodigoErro: integer; var VO_RespostaMensagem: PChar): integer; cdecl;
  TTMensagemDispose = procedure(VP_PChar: PChar); cdecl;

procedure Retorno(VP_ClassePai: pointer; VP_Tranmissao_ID: PChar; VP_PrcID, VP_Erro: integer; VP_Dados: PChar); cdecl;

var
  FInterface: TFInterface;
  F_ComLib: THandle;
  F_Com: Pointer;
  F_Inicializar: TTefInicializar;
  F_Finalizar: TTefFinalizar;
  F_Desconectar: TTDesconectar;
  F_Login: TTLogin;
  F_OpenTefStatus: TTOpenTefStatus;
  F_SolicitacaoBlocante: TTSolicitacaoBlocante;
  F_MensagemDispose: TTMensagemDispose;
  F_Host: string;
  F_Porta: integer;
  F_Chave: string;
  F_Identificador: string;
  F_Titulo: string;
  F_Terminal_ID: integer;
  F_Permissao: boolean;
  F_Navegar: boolean;
  F_TipoConfigurador: TPermissao;
  F_TipoTag: TTipoTag;
  F_Erro: TTMensagemerro;

const
  C_Versao_ConfTef = '1.1.1';
  C_PermissaoFormatado = 'NDF' + #13 + 'Configurador' + #13 + 'Administrador' + #13 + 'Usuario';
  {$IFDEF DEBUG}
    C_TempoSolicitacao=200000;
  {$ELSE}
  C_TempoSolicitacao = 20000;
  {$ENDIF}

implementation

procedure Retorno(VP_ClassePai: pointer; VP_Tranmissao_ID: PChar; VP_PrcID, VP_Erro: integer; VP_Dados: PChar); cdecl;
begin
  if VP_Erro = 96 then
    FInterface.Desconecta;
end;

{$R *.lfm}

{ TFInterface }

procedure TFInterface.MCadModuloClick(Sender: TObject);
var
  VL_FCadModulo: TFCadModulo;
  VL_Status: integer;
begin
  F_OpenTefStatus(F_Com, VL_Status);
  if VL_Status <> Ord(csLogado) then
  begin
    ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
    //  Desconectar(F_Com);
    Exit;
  end;
  if F_Permissao = False then
  begin
    ShowMessage('Voce não tem permissão para acessar este menu');
    exit;
  end;

  VL_FCadModulo := TFCadModulo.Create(self);
  VL_FCadModulo.ShowModal;

end;

procedure TFInterface.MConfigModuloClick(Sender: TObject);
var
  VL_FModuloConfg: TFModuloConfig;
  VL_Status: integer;
begin
  F_OpenTefStatus(F_Com, VL_Status);
  if VL_Status <> Ord(csLogado) then
  begin
    ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
    //Desconectar;
    Exit;
  end;
  if F_Permissao = False then
  begin
    ShowMessage('Voce não tem permissão para acessar este menu');
    exit;
  end;

  VL_FModuloConfg := TFModuloConfig.Create(self);
  VL_FModuloConfg.ShowModal;

end;


procedure TFInterface.IniciarLib;
var
  VL_CaminhoLib: string;
begin
  {$IFDEF USADLL}
      VL_CaminhoLib := '';

    {$IF DEFINED(DEBUG)}

  {$IF DEFINED(WIN64)}
      VL_CaminhoLib := ExtractFilePath(ParamStr(0)) + '..\..\com_lib\win64\com_lib.dll';
 {$ENDIF}

 {$IF DEFINED(WIN32)}
 VL_CaminhoLib := ExtractFilePath(ParamStr(0)) + '..\..\com_lib\win32\com_lib.dll';
 {$ENDIF}

 {$ELSE}
 VL_CaminhoLib := ExtractFilePath(ParamStr(0)) + 'com_lib.dll';
 {$ENDIF}

    F_ComLib := LoadLibrary(PChar(VL_CaminhoLib));

    if F_ComLib = 0 then
    begin
        ShowMessage('Não foi possível carregar a lib');
        Application.terminate;
        Exit;
    end;

    Pointer(F_Inicializar) := GetProcAddress(F_ComLib, 'inicializar');
    Pointer(F_Finalizar) := GetProcAddress(F_ComLib, 'finalizar');
    Pointer(F_Desconectar) := GetProcAddress(F_ComLib, 'desconectar');
    Pointer(F_Login) := GetProcAddress(F_ComLib, 'login');
    Pointer(F_SolicitacaoBlocante) := GetProcAddress(F_ComLib, 'solicitacaoblocante');
    Pointer(F_OpenTefStatus) := GetProcAddress(F_ComLib, 'opentefstatus');
    Pointer(F_MensagemDispose) := GetProcAddress(F_ComLib, 'mensagemdispose');

    F_Inicializar(F_Com,@Retorno, PChar(ExtractFilePath(ParamStr(0)) + 'config_app_com_lib.log'));

  {$ELSE}

  F_Inicializar := @inicializar;
  F_Finalizar := @finalizar;
  F_Login := @login;
  F_Desconectar := @desconectar;
  F_SolicitacaoBlocante := @solicitacaoblocante;
  F_OpenTefStatus := @opentefstatus;
  F_Inicializar(@Retorno, PChar(ExtractFilePath(ParamStr(0)) + 'config_app_com_lib.log'));

  {$ENDIF}

end;

procedure TFInterface.Conectar(VP_Tipo, VP_Senha: string);
var
  VL_Codigo, VL_Status: integer;
  VL_TMensagem: TMensagem;
  VL_Conf: TIniFile;
begin
  VL_Conf := nil;
  VL_TMensagem := TMensagem.Create;
  try
    //verifica arquivo ini
    if not FileExists(ExtractFilePath(ParamStr(0)) + 'config_tef.ini') then
    begin
      VL_Conf := TIniFile.Create(PChar(ExtractFilePath(ParamStr(0)) + 'config_tef.ini'));
      VL_Conf.WriteInteger('Servidor', 'Porta', 0);
      VL_Conf.WriteString('Servidor', 'Host', '');
      VL_Conf.WriteString('Servidor', 'Chave', '');
      VL_Conf.WriteString('Servidor', 'ID', '');
      VL_Conf.WriteString('Servidor', 'IDENTIFICADOR', '');
      VL_Conf.Free;
      VL_Conf := nil;
    end;

    VL_Conf := TIniFile.Create(PChar(ExtractFilePath(ParamStr(0)) + 'config_tef.ini'));

    if VL_Conf.ReadInteger('Servidor', 'Porta', 0) <> 0 then
    begin
      F_Porta := VL_Conf.ReadInteger('Servidor', 'Porta', 0);
      F_Host := VL_Conf.ReadString('Servidor', 'Host', '');
      F_Chave := VL_Conf.ReadString('Servidor', 'Chave', '');
      F_Terminal_ID := StrToInt(VL_Conf.ReadString('Servidor', 'ID', ''));
      F_Identificador := VL_Conf.ReadString('Servidor', 'Identificacao', '');
    end;

    //conecta
    VL_Codigo := F_Login(F_Com, PChar(F_Host), F_Porta, PChar(F_Chave), C_Mensagem, PChar(VP_Senha), PChar(VP_Tipo), F_Terminal_ID, PChar(F_Identificador));

    if VL_Codigo > 0 then
    begin
      mensagemerro(VL_Codigo, V_Erro);
      ShowMessage('Erro:' + IntToStr(VL_Codigo) + #13 + V_Erro);
      Exit;
    end;
    //carrega status
    F_OpenTefStatus(F_Com, VL_Status);
    if VL_Status = Ord(csLogado) then
    begin
      EStatus.Caption := 'Logado';
      EStatus.Font.Color := clGreen;
      F_Permissao := True;
    end
    else
    begin
      EStatus.Caption := 'Desconectado';
      EStatus.Font.Color := clRed;
      F_Permissao := False;
    end;
    LUsuario.Caption := 'Usuário:' + PermissaoToStrFormatada(StrToPermissao(VP_Tipo));
    F_TipoConfigurador := StrToPermissao(VP_Tipo);
  finally
    VL_TMensagem.Free;
    if Assigned(VL_Conf) then
      VL_Conf.Free;
  end;
end;

procedure TFInterface.Desconecta;
var
  VL_Codigo: integer;
  VL_DescricaoErro: PChar;
begin
  VL_Codigo := F_Desconectar(F_Com);

  if VL_Codigo <> 0 then
  begin
    F_Erro(VL_Codigo, VL_DescricaoErro);
    ShowMessage('Erro: ' + IntToStr(VL_Codigo) + #13 + 'Descrição: ' + VL_DescricaoErro);
    exit;
  end;
  EStatus.Caption := 'Desconectado';
  EStatus.Font.Color := clRed;
  F_Permissao := False;
  F_TipoConfigurador := pmS;
end;

function TFInterface.SolicitacaoBloc(VP_Dados: ansistring; var VO_Retorno: ansistring; VP_Tempo: integer): integer;
var
  VL_PTag, VL_Retorno: PChar;
begin
  VL_Retorno := nil;
  VL_PTag := PChar(VP_Dados);

  Result := F_SolicitacaoBlocante(F_Com, VL_PTag, VL_Retorno, VP_Tempo);

  VO_Retorno := VL_Retorno;
  F_MensagemDispose(VL_Retorno);
end;

function TFInterface.PesquisaTabelas(VP_TagComando, VP_DadosComando, VP_Tag: ansistring; VP_ID: integer; VP_TagLote: ansistring): ansistring;
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
    if F_Permissao = False then
      exit;
    F_Navegar := False;

    //carrega tabela
    VL_Mensagem.Limpar;
    if VP_TagLote = '' then
    begin
      VL_Mensagem.AddComando(VP_TagComando, VP_DadosComando);
      VL_Mensagem.AddTag(VP_Tag, VP_ID);
    end
    else
      VL_Mensagem.CarregaTags(VP_TagLote);

    VL_Mensagem.TagToStr(VL_Tag);
    VL_Codigo := SolicitacaoBloc(VL_Tag, VL_Tag, C_TempoSolicitacao);
    if VL_Codigo <> 0 then
    begin
      ShowMessage(IntToStr(VL_Codigo));
      exit;
    end;
    Result := VL_Tag;
    F_Navegar := True;
  finally
    VL_Mensagem.Free;
  end;
end;

function TFInterface.FiltrarTabela(VP_DBGrid: TRxDBGrid; var VO_RotuloCaption: string; VP_EditFiltrado: TEdit): string;
var
  VL_Filtro: string;
begin
  VL_Filtro := VP_DBGrid.SelectedColumn.FieldName;

  if VP_DBGrid.SelectedColumn.Field.DataType = ftBoolean then
    VL_Filtro := '';

  if VL_Filtro = '' then
  begin
    VL_Filtro := VP_DBGrid.Columns[1].FieldName;
    VO_RotuloCaption := 'Filtrar por ' + VP_DBGrid.Columns[1].Title.Caption;
    VP_DBGrid.SelectedIndex := 1;
  end
  else
    VO_RotuloCaption := 'Filtrar por ' + VP_DBGrid.SelectedColumn.Title.Caption;

  Result := VL_Filtro + ' = (''*' + VP_EditFiltrado.Text + '*'')';

end;

function TFInterface.FiltrarTabela(VP_DBGrid: TDBGrid; var VO_RotuloCaption: string; VP_EditFiltrado: TEdit): string;
var
  VL_Filtro: string;
begin
  VL_Filtro := VP_DBGrid.SelectedColumn.FieldName;

  if VL_Filtro = '' then
  begin
    VL_Filtro := VP_DBGrid.Columns[1].FieldName;
    VO_RotuloCaption := 'Filtrar por ' + VP_DBGrid.Columns[1].Title.Caption;
    VP_DBGrid.SelectedIndex := 1;
  end
  else
    VO_RotuloCaption := 'Filtrar por ' + VP_DBGrid.SelectedColumn.Title.Caption;

  if VL_Filtro = 'ID' then
    if VP_EditFiltrado.Text = '' then
      Result := ''
    else
      Result := VL_Filtro + ' = ' + VP_EditFiltrado.Text
  else
    Result := VL_Filtro + ' = (''*' + VP_EditFiltrado.Text + '*'')';

end;

function TFInterface.IncluirRegistro(VP_Tabela: TRxMemoryData; VP_TagComando, VP_TagComandoDados, VP_TagTabela: string; var VO_Retorno: ansistring): integer;
var
  VL_Tabela: string;
  VL_Mensagem: TMensagem;
  VL_Tag: ansistring;
begin
  VL_Mensagem := TMensagem.Create;
  VL_Tabela := '';
  VL_Tag := '';
  try
    VL_Tabela := RxMemDataToStr(VP_Tabela);

    VL_Mensagem.AddComando(VP_TagComando, VP_TagComandoDados);
    VL_Mensagem.AddTag(VP_TagTabela, VL_Tabela);
    VL_Mensagem.TagToStr(VL_Tag);

    Result := SolicitacaoBloc(VL_Tag,VO_Retorno,C_TempoSolicitacao);
  finally
    begin
      VL_Mensagem.Free;
      F_Navegar := True;
    end;
  end;
end;

function TFInterface.ExcluirRegistro(VP_Tag: string; VP_ID: integer; VP_TagComando, VP_TagComandoDados: string; var VO_Retorno: ansistring): integer;
var
  VL_Status: integer;
  VL_Mensagem: TMensagem;
  VL_Tag: string;
begin
  F_OpenTefStatus(F_Com, VL_Status);
  if VL_Status <> Ord(csLogado) then
  begin
    ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
    finterface.Desconecta;
    Exit;
  end;
  VL_Mensagem := TMensagem.Create;
  try
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando(VP_TagComando, '');
    VL_Mensagem.AddTag(VP_Tag, VP_ID);

    VL_Mensagem.TagToStr(VL_Tag);
    Result := SolicitacaoBloc(VL_Tag, VO_Retorno, C_TempoSolicitacao);
  finally
    VL_Mensagem.Free;
  end;

end;

function TFInterface.AlterarRegistro(VP_TagTabela: string; VP_Tabela: TRxMemoryData; VP_Tag: string; VP_ID: int64; VP_TagComando, VP_TagComandoDados: string; var VO_Retorno: ansistring): integer;
var
  VL_Mensagem: TMensagem;
  VL_Tabela: string;
  VL_Tag: ansistring;
begin
  VL_Mensagem := TMensagem.Create;
  VL_Tag := '';
  VL_Tabela := '';
  F_Navegar := False;
  try
    VL_Tabela := RxMemDataToStr(VP_Tabela);
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando(VP_TagComando, VP_TagComandoDados);
    VL_Mensagem.AddTag(VP_TagTabela, VL_Tabela);
    VL_Mensagem.AddTag(VP_Tag, VP_ID);


    VL_Mensagem.TagToStr(VL_Tag);
    Result := SolicitacaoBloc(VL_Tag, VO_Retorno, C_TempoSolicitacao);

  finally
    VL_Mensagem.Free;
    F_Navegar := True;
  end;

end;

function TFInterface.ValidarChave(VP_TagChave: string; VP_Chave: ansistring; VP_TagComando, VP_TagComandoDados: string; var VO_Retorno: ansistring): integer;
var
  VL_Mensagem: TMensagem;
begin
  if VP_TagChave = '' then
    exit;
  VL_Mensagem := TMensagem.Create;
  try
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando(VP_TagComando, VP_TagComandoDados);
    VL_Mensagem.AddTag(VP_TagChave, VP_Chave);
    Result := SolicitacaoBloc(VL_Mensagem.TagsAsString, VO_Retorno, C_TempoSolicitacao);
  finally
    VL_Mensagem.Free;
  end;
end;

procedure TFInterface.MCadPinPadClick(Sender: TObject);
var
  VL_FCadPinPad: TFCadPinPad;
  VL_Status: integer;
begin
  F_OpenTefStatus(F_Com, VL_Status);
  if VL_Status <> Ord(csLogado) then
  begin
    ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
    Desconectar;
    Exit;
  end;
  if F_Permissao = False then
  begin
    ShowMessage('Voce não tem permissão para acessar este menu');
    exit;
  end;

  VL_FCadPinPad := TFCadPinPad.Create(self);
  VL_FCadPinPad.Show;
end;

procedure TFInterface.Desconectar;
begin
  F_Desconectar(F_Com);
end;

procedure TFInterface.MConectarClick(Sender: TObject);
var
  VL_FLogin: TFLogin;
begin
  VL_FLogin := nil;
  try
    VL_FLogin := TFLogin.Create(self, C_PermissaoFormatado);
    VL_FLogin.ShowModal;
    if VL_FLogin.V_Conectar then
      Conectar(VL_FLogin.V_Tipo, VL_FLogin.ESenha.Text)
    else
      Desconecta;
  finally
    VL_FLogin.Free;
  end;

end;

procedure TFInterface.MCadPdvClick(Sender: TObject);
var
  VL_FCadPdv: TFCadPdv;
  VL_Status: integer;
begin
  F_OpenTefStatus(F_Com, VL_Status);
  if VL_Status <> Ord(csLogado) then
  begin
    ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
    Desconectar;
    Exit;
  end;
  if F_Permissao = False then
  begin
    ShowMessage('Voce não tem permissão para acessar este menu');
    exit;
  end;

  VL_FCadPdv := TFCadPdv.Create(self);
  VL_FCadPdv.Show;
end;

procedure TFInterface.FormCreate(Sender: TObject);
begin
  F_Com := nil;
  F_Navegar := True;
  F_Permissao := False;
  F_TipoConfigurador := pmS;
  IniciarLib;
  F_Titulo := 'Configurador OpenTef versão ' + C_Versao_ConfTef;
end;

procedure TFInterface.FormDblClick(Sender: TObject);
begin

end;

procedure TFInterface.FormDestroy(Sender: TObject);
begin

end;

procedure TFInterface.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if Assigned(F_Finalizar) then
    F_Finalizar(F_Com);

  if F_ComLib > 0 then
    UnloadLibrary(F_ComLib);
end;

procedure TFInterface.ComboBox1Click(Sender: TObject);
begin

end;

procedure TFInterface.FormShow(Sender: TObject);
begin
  FInterface.Caption := F_Titulo;
  LUsuario.Caption := 'Usuário:';
end;

procedure TFInterface.MCadAdquirenteClick(Sender: TObject);
var
  VL_FCadAdquirente: TFCadAdquirente;
  VL_Status: integer;
begin
  F_OpenTefStatus(F_Com, VL_Status);
  if VL_Status <> Ord(csLogado) then
  begin
    ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
    Desconectar;
    Exit;
  end;
  if F_Permissao = False then
  begin
    ShowMessage('Voce não tem permissão para acessar este menu');
    exit;
  end;

  VL_FCadAdquirente := TFCadAdquirente.Create(self);
  VL_FCadAdquirente.Show;

end;

procedure TFInterface.MCadClick(Sender: TObject);
begin

end;

procedure TFInterface.MCadLojaClick(Sender: TObject);
var
  VL_FCadLoja: TFCadLoja;
  VL_Status: integer;
begin
  F_OpenTefStatus(F_Com, VL_Status);
  if VL_Status <> Ord(csLogado) then
  begin
    ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
    Desconectar;
    Exit;
  end;
  if F_Permissao = False then
  begin
    ShowMessage('Voce não tem permissão para acessar este menu');
    exit;
  end;

  VL_FCadLoja := TFCadLoja.Create(self);
  VL_FCadLoja.Show;

end;

procedure TFInterface.MCadMultClick(Sender: TObject);
var
  VL_FCadMultiLoja: TFCadMultloja;
  VL_Status: integer;
begin
  F_OpenTefStatus(F_Com, VL_Status);
  if VL_Status <> Ord(csLogado) then
  begin
    ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
    Desconectar;
    Exit;
  end;
  if F_Permissao = False then
  begin
    ShowMessage('Voce não tem permissão para acessar este menu');
    exit;
  end;

  VL_FCadMultiLoja := TFCadMultloja.Create(self);
  VL_FCadMultiLoja.Show;

end;

end.
