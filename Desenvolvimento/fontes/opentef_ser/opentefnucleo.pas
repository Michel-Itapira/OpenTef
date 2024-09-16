unit opentefnucleo;

{$mode ObjFPC}{$H+}

interface

uses

  {$IFDEF UNIX}
  	CThreads,
  {$ENDIF}
  Classes, SysUtils, IniFiles, comunicador, ZConnection, ZDataset,
  funcoes, rxmemds, IdContext, cadastro, LbClass, base64,
  FMTBcd, DB, bancodados, Forms;

type

  TPTransmissaoComando = function(AOwner: Pointer; VP_Conexao_ID: integer; VP_Transmissao_ID, VP_Comando: string; var VO_Dados: string): integer of object;
  TMenuCompativel = function(VP_Modulo: Pointer; VP_Menu: PUtf8Char; var VO_Compativel: boolean): integer; cdecl;
  TGetFuncao = function(VP_Modulo: Pointer; VP_TagFuncao: PUtf8Char; var VO_Implementada: boolean): integer; cdecl;
  TLogin = function(VP_Modulo: Pointer; VP_Host: PUtf8Char; VP_Porta: integer; VP_ChaveComunicacao, VP_TipoConexao, VP_Identificacao: PUtf8Char): integer; cdecl;
  TFinalizar = function(VP_Modulo: Pointer): integer; cdecl;
  TModuloInicializar = function(VP_ModuloProcID: integer; var VO_Modulo: Pointer; VP_Recebimento: TRetornoModulo; VP_Modulo_ID: integer; VP_ArquivoLog: PUtf8Char): integer; cdecl;
  TSolicitacao = function(VP_Modulo: Pointer; VP_Transmissao_ID, VP_Dados: PUtf8Char; VP_Procedimento: TRetornoModulo; VP_Tarefa_ID, VP_TempoAguarda: integer): integer; cdecl;
  TSolicitacaoblocante = function(VP_Modulo: Pointer; VP_Transmissao_ID, VP_Dados: PUtf8Char; var VO_Retorno: PUtf8Char; VP_TempoAguarda: integer): integer; cdecl;
  TModuloStatus = function(VP_Modulo: Pointer; var VO_Versao: PUtf8Char; var VO_VersaoMensagem: integer; var VO_StatusRetorno: integer): integer; cdecl;
  TStrDispose = procedure(VP_PChar: PChar); cdecl;


  TTarefa = record
    VF_ID: integer;
    VF_TipoConexao: TConexaoTipo;
    VF_ModuloConfig_ID: integer;
    VF_TempoEspera: integer;
    VF_ConexaoID: integer;
    VF_TransmissaoID: string;
    VF_Tratando: boolean;
    VF_DataCriacao: TDateTime;
    VF_Mensagem: string;
  end;

  { TThModulo }
  TThModulo = class(TThread)
  private
    VF_Rodando: boolean;
    VF_ConexaoTipo: TConexaoTipo;
    VF_ArquivoLog: string;
    VF_DNucleo: Pointer;
    VF_RegModulo: Pointer;
  protected
    procedure Execute; override;
  public
    V_ListaTarefas: TList;
    VF_Sair: boolean;
    constructor Create(VP_Suspenso: boolean; VP_RegModulo: Pointer; VP_ConexaoTipo: TConexaoTipo; VP_ArquivoLog: string; VP_DNucleo: Pointer);
    destructor Destroy; override;
  end;




  { TThTransacao }

  TThTransacao = class(TThread)
  private
  protected
    procedure Execute; override;
  public
    V_Mensagem: TMensagem;
    V_Conexao_ID: integer;
    V_TransmissaoID: string;
    V_Terminal_Tipo: string;
    V_Terminal_ID: integer;
    V_Doc: string;
    constructor Create(VP_Suspenso: boolean; VP_Trasmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer; VP_Terminal_Tipo: string; VP_Terminal_ID: integer; VP_Doc: string);
    destructor Destroy; override;
  end;


  { TRegModulos }

  TRegModulo = record
    ModuloProcID: integer;
    Tag: string;
    AdquirenteTag: string;
    Handle: TLibHandle;
    PModulo: Pointer;
    Biblioteca: string;
    ModuloConfig_ID: integer;
    ConexaoTipo: TConexaoTipo;
    Adquirente_Identificacao: string;
    Host: ansistring;
    Porta: integer;
    Chave: ansistring;
    Descricao: string;
    Bin_Estatico: boolean;
    Menu_estatico: boolean;
    Menu_Operacional_estatico: boolean;
    Login: TLogin;
    Finalizar: TFinalizar;
    Inicializar: TModuloInicializar;
    Solicitacao: TSolicitacao;
    Solicitacaoblocante: TSolicitacaoblocante;
    ModuloStatus: TModuloStatus;
    StrDispose: TStrDispose;
    MenuCompativel: TMenuCompativel;
    GetFuncoes: TGetFuncao;
    ThModulo: TThModulo;
    Identificador: string;
  end;

  TRecModulo = record
    IIN: ansistring;
    ModuloConfID: integer;
    ModuloTag: string;
  end;

  TRecMenu = record
    ModuloConfID: integer;
    Tag: string;
    TextoBotao: string;
  end;

  { TBin }
  TModulo = class
  public
    ListaBin: TList;
    constructor Create; overload;
    destructor Destroy; override;
    function Add(VP_IIN: ansistring; VP_ModuloConfID: integer; VP_Tag: string): integer;
    procedure Limpar;
    function Get(VP_Posicao: integer): TRecModulo;
    function Count: integer;
    procedure RemovePorModuloConf(VP_ModuloConfID: integer);
    function RetornaModuloConfId(VP_IIN: ansistring): integer;
    function RetornaModulo(VP_IIN,VP_Tag: ansistring): TRecModulo;
    function RetornaBINPorTag(VP_Tag: ansistring): TRecModulo;
  end;

  { TMenu }

  TMenu = class
  public
    ListaMenu: TList;
    constructor Create; overload;
    destructor Destroy; override;
    function Add(VP_Tag: string; VP_TextoBotao: string; VP_ModuloConfID: integer): integer;
    function Delete(VP_Index: integer): integer;
    procedure Limpar;
    function Get(VP_Posicao: integer): TRecMenu;
    function GetTag(VP_Posicao: integer): string;
    function GetTextoBotao(VP_Posicao: integer): ansistring;
    function Count: integer;
    procedure RemovePorModuloConf(VP_ModuloConfID: integer);
    function RetornaModuloConfId(VP_Tag: ansistring): integer;
    function RetornaMenu(VP_Tag: ansistring; var VO_Menu: TRecMenu): integer;


  end;

  TRecDLL = record
    nome: string;
    instancia: integer;
    handle: TLibHandle;
  end;

  TDLL = class
  public
    ListaDLL: TList;
    constructor Create; overload;
    destructor Destroy; override;
    function carregarDLL(VP_DLL_Nome: string): TLibHandle;
    function descarregarDLL(VP_DLL_Nome: string): integer;
  end;

  TThConciliacao = class(TThread)
  private
    VF_Rodando: boolean;
    VF_ArquivoLog: string;
    VF_DNucleo: Pointer;
    VF_Modulo: TRecModulo;
    VF_Dados: string;
    VF_Transacao_ID: string;
    VF_TempoEspera: integer;
    VF_Conexao_ID: integer;
  protected
    procedure Execute; override;
  public
    VF_Sair: boolean;
    VF_Retorno: ansistring;
    VF_Status: TSolicitacaoStatus;
    VF_Transmissao_ID: string;

    constructor Create(VP_Suspenso: boolean; VP_Modulo: TRecModulo; VP_Dados: string; VP_Transacao_ID: string; VP_ArquivoLog: string; VP_DNucleo: Pointer;
      VP_Conexao_ID: integer; VP_TempoEspera: integer = 60000);
    destructor Destroy; override;
  end;

  TRecConciliacao = record
    modulo: TRecModulo;
    transacao_id: string;
    dados: string;
    ThConciliacao: TThConciliacao;
  end;

  TConciliacao = class
  private
    ListaConciliacao: TList;
  public
    TempoEspera: integer;
    TransmissaoID: string;
    Conexao_ID: integer;

    function add(VP_RecModulo: TRecModulo; VP_Transacao_ID, VP_Dados: string): integer;
    function consultar: ansistring;
    constructor Create(VP_Transmissao_ID: string; VP_Conexao_ID: integer; VP_TempoEspera: integer = 60000); overload;
    destructor Destroy; override;
    procedure remove(VP_Posicao: integer);
  end;

  { TDNucleo }
  TDNucleo = class(TDataModule)
    CriptoAes: TLbRijndael;
    ZConexao: TZConnection;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    function comando0001(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer): integer; // PEDIDO DE LOGIN
    function comando0021(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer): integer; // PEDIDO DE CONEXAO
    function comando000A(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer; VP_Terminal_Status: TConexaoStatus; VP_Terminal_ID: integer;
      VP_Terminal_Tipo, VP_Doc, VP_Terminal_Identificacao: string): integer;
    // PEDE APROVACAO DA TRANSACAO E CRIA CHAVE
    function comando0018(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer; VP_Terminal_Status: TConexaoStatus; VP_Terminal_ID: integer): integer;
    // SOLICITA MENU DE VENDA
    function comando00F5(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer; VP_Terminal_Status: TConexaoStatus; VP_Terminal_ID: integer): integer;
    // SOLICITA MENU OPERACIONAl
    function comando007A(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer; VP_Terminal_Tipo: string; VP_Terminal_ID: integer; VP_Doc: string): integer;
    // CRIA TRANSACAO PARA APROVACAO
    function comando00F4(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer; VP_Terminal_Status: TConexaoStatus; VP_Terminal_Tipo: string;
      VP_Terminal_ID: integer; VP_Doc, VP_Terminal_Identificacao: string): integer; // SOLICITA PARA MODULO
    function comando0105(VP_Transmissao_ID: string; VP_Tarefa_ID, VP_ModuloProID, VP_Conexao_ID, VP_ModuloConfigID, VP_Erro: integer; VP_Modulo_Tag, VP_Dados: string): integer;
    // SOLICITA PARA TERMINAIS
    function comando0111(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer): integer; // SOLICITA CHAVE PUBLICA
    function comando010D(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer): integer; // SOLICITA ATUALIZACAO DO TEF
    function comando0113(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer): integer; // SOLICITA CONCILIACAO
    function TransmissaoComando(AOwner: Pointer; VP_Conexao_ID: integer; VP_Transmissao_ID, VP_Comando: string; var VO_Dados: string): integer;
    // comando enviados pelo comunicador do servidor diretamente para o opentef

  public
    VF_Modulo: TModulo;
    VF_Menu: TMenu;
    VF_MenuOperacional: TMenu;
    VF_DLL: TDLL;
    procedure iniciar;
    procedure parar;
    procedure atualizaConfiguracao;
    procedure comando(VP_Erro: integer; VP_Transmissao_ID, VP_DadosRecebidos: string; VP_Conexao_ID: integer; VP_Terminal_Tipo: string; VP_Terminal_ID: integer;
      VP_DOC: string; VP_Terminal_Status: TConexaoStatus; VP_Terminal_Identificacao: string; VP_Permissao: TPermissao; VP_ClienteIP: string); // QUANDO VEM DIRETO PARA OPEN TEF (pdv)
    function ModuloCarrega(VP_ModuloConfig_ID: integer): integer;
    function ModuloDescarrega(VP_ModuloConfig_ID, VP_ModuloProcID: integer): integer;
    function ModuloAddSolicitacao(VP_ConexaoID: integer; VP_Transmissao_ID: string; VP_TempoEspera: int64; VP_ModuloConfig_ID: integer; VP_Mensagem: TMensagem;
      VP_ConexaoTipo: TConexaoTipo): integer;
    function ModuloAddSolicitacao(VP_Transmissao_ID: string; VP_TempoEspera, VP_ModuloProcID: integer; VP_Mensagem: TMensagem): integer;
    function ModuloAddSolicitacaoIdentificacaoAdquirente(VP_ConexaoID: integer; VP_Transmissao_ID: string; VP_TempoEspera: int64; VP_Adquirente_Identificacao: string;
      VP_Mensagem: TMensagem; VP_ConexaoTipo: TConexaoTipo): integer;
    function ModuloSolicitacaoBlocante(VP_MensagemEntrada: TMensagem; var VO_MensagemSaida: TMensagem; VP_Transmissao_ID: string; VP_TempoEspera: int64;
      VP_ModuloConfig_ID: integer; VP_ConexaoTipo: TConexaoTipo): integer;
    function ModuloValida(VP_RegModulo: TRegModulo): integer;
    function ModuloTarefaDel(VP_ModuloProcID, VP_Tarefa_ID: integer): integer;
    function ModuloTarefaGet(VP_ModuloProcID, VP_Tarefa_ID: integer): TTarefa;
    function ModuloGetReg(VP_ModuloProc_ID: integer): Pointer;
    function ModuloGetRegAdquirencia(VP_AdquirenciaIdentificacao, VP_Tag: string): TRegModulo;
    function ModuloGetModuloConfigID(VP_ModuloConfig_ID: integer; VP_ConexaoTipo: TConexaoTipo): TRegModulo;
    function AtualizaBIN(VP_RegModulo: TRegModulo; VP_Mensagem: TMensagem): integer;
    function AtualizaMENU(VP_RegModulo: TRegModulo; VP_Mensagem: TMensagem; VP_Sistema: boolean): integer;
    function AtualizaMENU_OPERACIONAL(VP_RegModulo: TRegModulo; VP_Mensagem: TMensagem; VP_Sistema: boolean): integer;


  var
    VF_ListaTRegModulo: TList;
  end;




var
  DNucleo: TDNucleo;
  DComunicador: TDComunicador;
  F_ArquivoLog: string;
  F_P: Pointer;
  F_Modulo_ID_Contador: integer;
  F_Tarefa_ID_Contador: integer;
  F_BloqueiaDLL: TMultiReadExclusiveWriteSynchronizer;

{$IFDEF WIN}
    const
      C_Lib= '.dll';
  {$ENDIF WIN}

{$IFDEF LINUX}
    const
      C_Lib= '.so';
  {$ENDIF LINUX}


procedure ModuloServicoRetorno(VP_Transmissao_ID: PUtf8Char; VP_Tarefa_ID, VP_ModuloProcID, VP_Erro: integer; VP_Dados: PUtf8Char; VP_Modulo: Pointer);
  cdecl; // QUANDO VEM DIRETO PARA OPEN TEF PELO MODULO (operadora)
procedure ModuloCaixaRetorno(VP_Transmissao_ID: PUtf8Char; VP_Tarefa_ID, VP_ModuloProcID, VP_Erro: integer; VP_Dados: PUtf8Char; VP_Modulo: Pointer); cdecl;
// QUANDO VEM DIRETO PARA OPEN TEF PELO MODULO (operadora)

implementation

uses
  def;

procedure ModuloCaixaRetorno(VP_Transmissao_ID: PUtf8Char; VP_Tarefa_ID, VP_ModuloProcID, VP_Erro: integer; VP_Dados: PUtf8Char; VP_Modulo: Pointer); cdecl;
var
  VL_Mensagem: TMensagem;
  VL_Tarefa: ^TTarefa;
  VL_I: integer;
  VL_PRegModulo: ^TRegModulo;
  VL_String: string;
  VL_Erro: integer;

  procedure Descarrega(VP_ModuloProcID: integer);
  begin
    DNucleo.ModuloDescarrega(-1, VP_ModuloProcID);
  end;

begin
  try
    try

      GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '101120231253', 'Mensagem recebida no ModuloCaixaRetorno', VP_Dados, VP_Erro, 2);

      VL_Mensagem := TMensagem.Create;
      VL_PRegModulo := DNucleo.ModuloGetReg(VP_ModuloProcID);

      if not Assigned(VL_PRegModulo) then
        exit;

      VL_Tarefa := nil;

      for VL_I := 0 to VL_PRegModulo^.ThModulo.V_ListaTarefas.Count - 1 do
      begin
        VL_Tarefa := VL_PRegModulo^.ThModulo.V_ListaTarefas[VL_I];
        if VL_Tarefa^.VF_ID = VP_Tarefa_ID then
          Break
        else
          VL_Tarefa := nil;
      end;

      if VP_Erro = 96 then
      begin
        with TThread.CreateAnonymousThread(TProcedure(@Descarrega)) do
        begin
          FreeOnTerminate := True;
          start;
        end;
        Exit;
      end;

      VL_Erro := VL_Mensagem.CarregaTags(VP_Dados);
      if VL_Erro <> 0 then
      begin
        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '090920221453', 'Erro no ModuloCaixaRetorno', '', VL_Erro, 1);
        Exit;
      end;

      VL_Mensagem.AddTag('00F8', 'F');  //  MENSAGEM VINDA DE FORA DO OPEN TEF

      if (VL_Mensagem.Comando() = '0111') and (VL_Mensagem.ComandoDados() = 'R') then
        // RETORNO CHAVE PUBLICA
      begin

        // COMANDO PRA SER EXECUTADO NO PDV

        VL_Mensagem.AddTag('00F8', 'F');  //  MENSAGEM VINDA DE FORA DO OPEN TEF

        VL_Erro := DNucleo.comando0105(VP_Transmissao_ID, VP_Tarefa_ID, VP_ModuloProcID, -1, VL_PRegModulo^.ModuloConfig_ID, VP_Erro, VL_PRegModulo^.Tag, VL_Mensagem.TagsAsString);
        //COMANDO PARA SER EXECUTADO NOS TERMINAIS CLIENTES

        //VL_Erro := VL_PRegModulo^.Solicitacao(VL_PRegModulo^.PModulo,
        //PUtf8Char(VP_Transmissao_ID), PUtf8Char(VL_String), nil, VP_Tarefa_ID, 30000);

        if VL_Erro <> 0 then
        begin
          VL_Mensagem.AddComando('0026', IntToStr(VL_Erro));
          // retorno com erro
          GravaLog(F_ArquivoLog, 0, '', 'opentef', '020920220945Caixa', VP_Dados, '', VL_Erro, 1);
          DNucleo.ModuloAddSolicitacao(VP_Transmissao_ID, 60000, VP_ModuloProcID, VL_Mensagem);
          Exit;
        end;
        Exit;
      end;


      if (VL_Mensagem.Comando() = '0111') and (VL_Mensagem.ComandoDados() = 'S') then
        // COMANDO PARA PEGAR CHAVE PUBLICA
      begin

        // COMANDO PRA SER EXECUTADO NO PDV

        VL_Mensagem.AddTag('00F8', 'F');  //  MENSAGEM VINDA DE FORA DO OPEN TEF

        VL_Erro := DNucleo.comando0105(VP_Transmissao_ID, VP_Tarefa_ID, VP_ModuloProcID, -1, VL_PRegModulo^.ModuloConfig_ID, VP_Erro, VL_PRegModulo^.Tag, VL_Mensagem.TagsAsString);
        if VL_Erro <> 0 then
        begin
          VL_Mensagem.AddComando('0026', IntToStr(VL_Erro));
          // retorno com erro
          GravaLog(F_ArquivoLog, 0, '', 'opentef', '010920220931Caixa', VP_Dados, '', VL_Erro, 1);
          DNucleo.ModuloAddSolicitacao(VP_Transmissao_ID, 60000, VP_ModuloProcID, VL_Mensagem);
        end;
        Exit;
      end;

      if Assigned(VL_Tarefa) then
      begin
        VL_Erro := DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, 3000, False, nil, VL_Tarefa^.VF_TransmissaoID, VL_Mensagem, VL_Mensagem, VL_Tarefa^.VF_ConexaoID);

        if VL_Erro <> 0 then
        begin
          VL_Mensagem.AddComando('0026', IntToStr(VL_Erro));
          // retorno com erro
          GravaLog(F_ArquivoLog, 0, '', 'opentef', '240620240906', VP_Dados, '', VL_Erro, 1);
          DNucleo.ModuloAddSolicitacao(VP_Transmissao_ID, 60000, VP_ModuloProcID, VL_Mensagem);
        end;
      end
      else
      begin
        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '111220231010', 'ModuloCaixaRetorno, tarefa não encontrada', 'Dados: ' + VP_Dados + ' Tarefa: ' + IntToStr(VP_Tarefa_ID), VP_Erro, 1);
      end;


    finally
      begin
        VL_Mensagem.Free;

        if VP_Tarefa_ID <> 0 then
          DNucleo.ModuloTarefaDel(VP_ModuloProcID, VP_Tarefa_ID);

        if VP_Erro <> 0 then
        begin
          GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '090920221435', 'ModuloCaixaRetorno, recebeu comando com erro', '', VP_Erro, 1);
        end;

      end;

    end;

  except
    on e: Exception do
      GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '120920220828', 'Erro no ModuloCaixaRetorno ' + e.ClassName + '/' + e.Message, '', VL_Erro, 1);
  end;
end;



procedure ModuloServicoRetorno(VP_Transmissao_ID: PUtf8Char; VP_Tarefa_ID, VP_ModuloProcID, VP_Erro: integer; VP_Dados: PUtf8Char; VP_Modulo: Pointer); cdecl;
var
  VL_Mensagem: TMensagem;
  VL_Erro: integer;
  VL_String: string;
  VL_PRegModulo: ^TRegModulo;

  procedure Descarrega();
  begin
    DNucleo.ModuloDescarrega(-1, VP_ModuloProcID);
    //  DNucleo.VF_Bin.RemovePorModuloConf(VL_PRegModulo^.ModuloConfig_ID);
  end;

begin

  VL_String := '';

  try
    GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '101120231254', 'Mensagem recebida no ModuloServicoRetorno', VP_Dados, VP_Erro, 2);

    VL_Mensagem := TMensagem.Create;
    VL_Mensagem.AddTag('00F8', 'F');

    VL_PRegModulo := DNucleo.ModuloGetReg(VP_ModuloProcID);

    if not Assigned(VL_PRegModulo) then
      exit;

    if VP_Erro = 96 then
    begin
      with TThread.CreateAnonymousThread(TProcedure(@Descarrega)) do
      begin
        FreeOnTerminate := True;
        start;
      end;
      Exit;
    end;

    VL_Erro := VL_Mensagem.CarregaTags(VP_Dados);
    if VL_Erro <> 0 then
    begin
      GravaLog(F_ArquivoLog, 0, '', 'opentef', '260820220900Servico', VP_Dados, '', VL_Erro, 1);
      VL_Mensagem.AddComando('0026', IntToStr(VL_Erro)); // comando de erro
      DNucleo.ModuloAddSolicitacao(VP_Transmissao_ID, 60000, VP_ModuloProcID, VL_Mensagem);
      Exit;
    end;

    if (VL_Mensagem.Comando() = '00CD') and (VL_Mensagem.ComandoDados() = 'R') then
      //ATUALIZA BINS
    begin

      // COMANDO PRA ATUALIZAR TABELA DE BINS

      VL_Erro := DNucleo.AtualizaBIN(VL_PRegModulo^, VL_Mensagem);
      if VL_Erro <> 0 then
      begin
        VL_Mensagem.AddComando('0026', IntToStr(VL_Erro)); // comando de erro
        GravaLog(F_ArquivoLog, 0, '', 'opentef', '260820220910Servico', VP_Dados, '', VL_Erro, 1);
        DNucleo.ModuloAddSolicitacao(VP_Transmissao_ID, 20000, VP_ModuloProcID, VL_Mensagem);
        Exit;
      end;

    end;

    if (VL_Mensagem.Comando() = '00CF') and (VL_Mensagem.ComandoDados() = 'R') then
      //ATUALIZA MENUS
    begin

      // COMANDO PRA ATUALIZAR MENUS

      VL_Erro := DNucleo.AtualizaMenu(VL_PRegModulo^, VL_Mensagem, False);
      if VL_Erro <> 0 then
      begin
        VL_Mensagem.AddComando('0026', IntToStr(VL_Erro)); // comando de erro
        GravaLog(F_ArquivoLog, 0, '', 'opentef', '260820220909Servico', VP_Dados, '', VL_Erro, 1);
        DNucleo.ModuloAddSolicitacao(VP_Transmissao_ID, 60000, VP_ModuloProcID, VL_Mensagem);
        Exit;
      end;

    end;

    if (VL_Mensagem.Comando() = '00D4') and (VL_Mensagem.ComandoDados() = 'R') then
      //ATUALIZA MENUS OPERACIONAL
    begin

      // COMANDO PRA ATUALIZAR MENUS OPERACIONAL

      VL_Erro := DNucleo.AtualizaMENU_OPERACIONAL(VL_PRegModulo^, VL_Mensagem, False);
      if VL_Erro <> 0 then
      begin
        VL_Mensagem.AddComando('0026', IntToStr(VL_Erro)); // comando de erro
        GravaLog(F_ArquivoLog, 0, '', 'opentef', '260820220908Servico',
          VP_Dados, '', VL_Erro, 1);
        DNucleo.ModuloAddSolicitacao(VP_Transmissao_ID, 60000,
          VP_ModuloProcID, VL_Mensagem);
        Exit;
      end;

    end;

    if (VL_Mensagem.Comando() = '0105') and (VL_Mensagem.ComandoDados() = 'S') then
      // COMANDO PARA SER EXECUTADO NO PDV
    begin

      // COMANDO PRA SER EXECUTADO NO PDV

      VL_Mensagem.AddTag('00F8', 'F');  //  MENSAGEM VINDA DE FORA DO OPEN TEF


      VL_Erro := DNucleo.comando0105(VP_Transmissao_ID, VP_Tarefa_ID, VP_ModuloProcID, -1, VL_PRegModulo^.ModuloConfig_ID, VP_Erro, VL_PRegModulo^.Tag, VL_Mensagem.TagsAsString);
      if VL_Erro <> 0 then
      begin
        VL_Mensagem.AddComando('0026', IntToStr(VL_Erro)); // comando de erro
        GravaLog(F_ArquivoLog, 0, '', 'opentef', '260820220907Servico',
          VP_Dados, '', VL_Erro, 1);
        DNucleo.ModuloAddSolicitacao(VP_Transmissao_ID, 60000,
          VP_ModuloProcID, VL_Mensagem);
        Exit;
      end;

    end;

    if (VL_Mensagem.Comando() = '0111') and (VL_Mensagem.ComandoDados() = 'R') then
      // COMANDO PARA PEGAR CHAVE PUBLICA
    begin

      // COMANDO PRA SER EXECUTADO NO PDV

      VL_Mensagem.AddTag('00F8', 'F');  //  MENSAGEM VINDA DE FORA DO OPEN TEF


      VL_Erro := DNucleo.comando0105(VP_Transmissao_ID, VP_Tarefa_ID, VP_ModuloProcID, -1, VL_PRegModulo^.ModuloConfig_ID, VP_Erro, VL_PRegModulo^.Tag, VL_Mensagem.TagsAsString);

      if VL_Erro <> 0 then
      begin
        VL_Mensagem.AddComando('0026', IntToStr(VL_Erro)); // comando de erro
        GravaLog(F_ArquivoLog, 0, '', 'opentef', '010920220930Servico',
          VP_Dados, '', VL_Erro, 1);
        DNucleo.ModuloAddSolicitacao(VP_Transmissao_ID, 60000,
          VP_ModuloProcID, VL_Mensagem);
        Exit;
      end;

    end;

    if (VL_Mensagem.Comando() = '0111') and (VL_Mensagem.ComandoDados() = 'S') then
    begin
      VL_Mensagem.AddTag('00F8', 'F');  //  MENSAGEM VINDA DE FORA DO OPEN TEF

      VL_String := VL_Mensagem.TagsAsString;

      VL_Erro := DNucleo.comando0105(VP_Transmissao_ID, VP_Tarefa_ID, VP_ModuloProcID, -1, VL_PRegModulo^.ModuloConfig_ID, VP_Erro, VL_PRegModulo^.Tag, VL_Mensagem.TagsAsString);

      if VL_Erro <> 0 then
      begin
        VL_Mensagem.AddComando('0026', IntToStr(VL_Erro)); // comando de erro
        GravaLog(F_ArquivoLog, 0, '', 'opentef', '010920220930Servico',
          VP_Dados, '', VL_Erro, 1);
        DNucleo.ModuloAddSolicitacao(VP_Transmissao_ID, 60000,
          VP_ModuloProcID, VL_Mensagem);
        Exit;
      end;
    end;


  finally
    VL_Mensagem.Free;
    if VP_Tarefa_ID <> 0 then
      DNucleo.ModuloTarefaDel(VP_ModuloProcID, VP_Tarefa_ID);

    if VP_Erro <> 0 then
    begin
      GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '090920220915',
        'ModuloServicoRetorno, recebeu comando com erro', '', VP_Erro, 1);
    end;

  end;
end;


procedure TThModulo.Execute;
var
  VL_Erro: integer;
  VL_DadosInteger: integer;
  VL_ConexaoStatus: TConexaoStatus;
  VL_VersaoModulo: string;
  VL_VersaoMensagem: integer;
  VL_Mensagem: TMensagem;
  VL_Tarefa: ^TTarefa;
  VL_I: integer;
  VL_TipoConexao: PUtf8Char;
  VL_Linha: string;
  VL_Retorno: PUtf8Char;
begin
  VF_Rodando := True;
  TRegModulo(VF_RegModulo^).PModulo := nil;
  VL_Tarefa := nil;
  VL_DadosInteger := 0;
  VL_VersaoModulo := '';
  VL_VersaoMensagem := 0;
  VL_Linha := '200520220934';
  VL_Retorno := nil;

  if VF_ConexaoTipo = cnCaixa then
    VL_TipoConexao := 'C'
  else
    VL_TipoConexao := 'S';

  try
    try
      begin
        while not Terminated do
        begin
          if VF_Sair then
            Exit;

          if TRegModulo(VF_RegModulo^).Handle = 0 then
          begin
            TRegModulo(VF_RegModulo^).Handle := DNucleo.VF_DLL.carregarDLL(ExtractFilePath(ParamStr(0)) + 'modulo/' + TRegModulo(VF_RegModulo^).Biblioteca);

            if TRegModulo(VF_RegModulo^).Handle = 0 then
            begin
              GravaLog(VF_ArquivoLog, TRegModulo(VF_RegModulo^).ModuloConfig_ID, TRegModulo(VF_RegModulo^).Tag, 'opentefnucleo', '12082022143300',
                'Erro ao tentar carregar a dll:' + TRegModulo(VF_RegModulo^).Biblioteca, '', 0, 1);
              Exit;
            end;

            Pointer(TRegModulo(VF_RegModulo^).Login) := GetProcAddress(TRegModulo(VF_RegModulo^).Handle, 'login');
            Pointer(TRegModulo(VF_RegModulo^).Finalizar) := GetProcAddress(TRegModulo(VF_RegModulo^).Handle, 'finalizar');
            Pointer(TRegModulo(VF_RegModulo^).Inicializar) := GetProcAddress(TRegModulo(VF_RegModulo^).Handle, 'inicializar');
            Pointer(TRegModulo(VF_RegModulo^).Solicitacao) := GetProcAddress(TRegModulo(VF_RegModulo^).Handle, 'solicitacao');
            Pointer(TRegModulo(VF_RegModulo^).Solicitacaoblocante) := GetProcAddress(TRegModulo(VF_RegModulo^).Handle, 'solicitacaoblocante');
            Pointer(TRegModulo(VF_RegModulo^).ModuloStatus) := GetProcAddress(TRegModulo(VF_RegModulo^).Handle, 'modulostatus');
            Pointer(TRegModulo(VF_RegModulo^).StrDispose) := GetProcAddress(TRegModulo(VF_RegModulo^).Handle, 'mensagemdispose');

            GravaLog(VF_ArquivoLog,
              TRegModulo(VF_RegModulo^).ModuloConfig_ID,
              TRegModulo(VF_RegModulo^).Tag,
              'opentefnucleo',
              '12082022154300', 'Carregando funções da dll' + TRegModulo(VF_RegModulo^).Biblioteca, '', 0, 3);

            if VF_Sair then
              Exit;

            VL_Linha := '24062024154801';
            if VF_ConexaoTipo = cnCaixa then
              VL_Erro := TRegModulo(VF_RegModulo^).Inicializar(TRegModulo(VF_RegModulo^).ModuloProcID, TRegModulo(VF_RegModulo^).PModulo,
                @ModuloCaixaRetorno, TRegModulo(VF_RegModulo^).ModuloConfig_ID, PUtf8Char(VF_ArquivoLog))
            else
              VL_Erro :=
                TRegModulo(VF_RegModulo^).Inicializar(TRegModulo(VF_RegModulo^).ModuloProcID, TRegModulo(VF_RegModulo^).PModulo, @ModuloServicoRetorno,
                TRegModulo(VF_RegModulo^).ModuloConfig_ID, PUtf8Char(VF_ArquivoLog));

            GravaLog(VF_ArquivoLog,
              TRegModulo(VF_RegModulo^).ModuloConfig_ID,
              TRegModulo(VF_RegModulo^).Tag,
              'opentefnucleo',
              '12082022154301 modulo' + IntToStr(TRegModulo(VF_RegModulo^).Handle),
              'Iniciando Mudulo' + TRegModulo(VF_RegModulo^).Biblioteca,
              '', 0, 3);


            if VL_Erro <> 0 then
            begin
              GravaLog(VF_ArquivoLog,
                TRegModulo(VF_RegModulo^).ModuloConfig_ID,
                TRegModulo(VF_RegModulo^).Tag,
                'opentefnucleo',
                '030520221138', 'Erro ao tentar inicializar a dll:' + TRegModulo(VF_RegModulo^).Biblioteca, '', VL_Erro, 1);
              Exit;
            end;

            VL_Linha := '24062024154800';
            if (VF_ConexaoTipo = cnServico) then
              DNucleo.AtualizaBIN(TRegModulo(VF_RegModulo^), nil);
          end
          else
          begin

            if VF_Sair then
              Exit;

            // pega o status da conexao
            VL_Linha := '24062024154200';
            VL_Erro := TRegModulo(VF_RegModulo^).ModuloStatus(TRegModulo(VF_RegModulo^).PModulo, VL_Retorno, VL_VersaoMensagem, VL_DadosInteger);

            VL_VersaoModulo := VL_Retorno;
            TRegModulo(VF_RegModulo^).StrDispose(VL_Retorno);

            if VL_Erro <> 0 then
            begin
              GravaLog(VF_ArquivoLog,
                TRegModulo(VF_RegModulo^).ModuloConfig_ID,
                TRegModulo(VF_RegModulo^).Tag,
                'opentefnucleo',
                '030520221503',
                'Erro ao tentar pegar status da conexao ' + ConexaoTipoToStr(VF_ConexaoTipo) + ' da dll:' + TRegModulo(VF_RegModulo^).Biblioteca,
                '', VL_Erro, 1);
              Exit;
            end;

            VL_Linha := '24062024154201';
            VL_ConexaoStatus := IntToConexaoStatus(VL_DadosInteger);

            if VL_ConexaoStatus <> csLogado then
            begin
              VL_Linha := '24062024154300';
              VL_Erro :=
                TRegModulo(VF_RegModulo^).Login(TRegModulo(VF_RegModulo^).PModulo, PUtf8Char(TRegModulo(VF_RegModulo^).Host), TRegModulo(VF_RegModulo^).Porta,
                PUtf8Char(TRegModulo(VF_RegModulo^).Chave), PUtf8Char(VL_TipoConexao), PUtf8Char(TRegModulo(VF_RegModulo^).Identificador));
              if VL_Erro <> 0 then
                GravaLog(VF_ArquivoLog,
                  TRegModulo(VF_RegModulo^).ModuloConfig_ID,
                  TRegModulo(VF_RegModulo^).Tag,
                  'opentefnucleo',
                  '030520221540', 'Erro ao tentar logar da conexao ' + ConexaoTipoToStr(VF_ConexaoTipo) + ' da dll:' + TRegModulo(VF_RegModulo^).Biblioteca,
                  '', VL_Erro, 1)
              else
              begin
                VL_Erro := TRegModulo(VF_RegModulo^).ModuloStatus(TRegModulo(VF_RegModulo^).PModulo, VL_Retorno, VL_VersaoMensagem, VL_DadosInteger);

                VL_VersaoModulo := VL_Retorno;
                TRegModulo(VF_RegModulo^).StrDispose(VL_Retorno);

                VL_ConexaoStatus := IntToConexaoStatus(VL_DadosInteger);
              end;

              if VF_Sair then
                Exit;

              VL_Linha := '24062024154400';
              if (VL_ConexaoStatus = csLogado) and (VF_ConexaoTipo = cnServico) and (TRegModulo(VF_RegModulo^).Menu_estatico = False) then
              begin
                // atualiza MENUS

                VL_Mensagem := TMensagem.Create;
                try
                  VL_Mensagem.AddComando('00CF', 'S'); //SOLICITA MENU VENDA
                  TRegModulo(VF_RegModulo^).Solicitacao(TRegModulo(VF_RegModulo^).PModulo, PUtf8Char(''), PUtf8Char(VL_Mensagem.TagsAsString), @ModuloServicoRetorno, 0, 60000);

                finally
                  VL_Mensagem.Free;
                end;

              end;

              VL_Linha := '24062024154401';
              if (VL_ConexaoStatus = csLogado) and (VF_ConexaoTipo = cnServico) and (TRegModulo(VF_RegModulo^).Menu_Operacional_estatico = False) then
              begin
                // atualiza MENUS  OPERACIONAL

                VL_Mensagem := TMensagem.Create;
                try

                  VL_Mensagem.AddComando('00D4', 'S');
                  //SOLICITA MENU OPERACIONAL
                  TRegModulo(VF_RegModulo^).Solicitacao(TRegModulo(VF_RegModulo^).PModulo, PUtf8Char(''), PUtf8Char(VL_Mensagem.TagsAsString), @ModuloServicoRetorno, 0, 60000);

                finally
                  VL_Mensagem.Free;
                end;

              end;


              if VF_Sair then
                Exit;


              VL_Linha := '24062024154402';
              if (VL_ConexaoStatus = csLogado) and (VF_ConexaoTipo = cnServico) and (TRegModulo(VF_RegModulo^).Bin_Estatico = False) then
              begin
                // atualiza BINS

                VL_Mensagem := TMensagem.Create;
                try
                  VL_Mensagem.AddComando('00CD', 'S'); //SOLICITA BINS
                  TRegModulo(VF_RegModulo^).Solicitacao(TRegModulo(VF_RegModulo^).PModulo, PUtf8Char(''), PUtf8Char(VL_Mensagem.TagsAsString), @ModuloServicoRetorno, 0, 60000);

                finally
                  VL_Mensagem.Free;
                end;

              end;

            end;

            VL_Linha := '24062024154403';
            // inicia as tratativas das solicitações
            if VL_ConexaoStatus = csLogado then
            begin

              if VF_Sair then
                Exit;

              VL_Linha := '24062024154404';
              for VL_I := 0 to V_ListaTarefas.Count - 1 do
              begin
                if VF_Sair then
                  Exit;


                VL_Tarefa := V_ListaTarefas[VL_I];

                if VL_Tarefa^.VF_Tratando = False then
                begin
                  VL_Tarefa^.VF_Tratando := True;
                  if VF_ConexaoTipo = cnCaixa then
                    VL_Erro :=
                      TRegModulo(VF_RegModulo^).Solicitacao(TRegModulo(VF_RegModulo^).PModulo, PUtf8Char(VL_Tarefa^.VF_TransmissaoID), PUtf8Char(VL_Tarefa^.VF_Mensagem),
                      @ModuloCaixaRetorno, VL_Tarefa^.VF_ID, VL_Tarefa^.VF_TempoEspera)
                  else
                    VL_Erro :=
                      TRegModulo(VF_RegModulo^).Solicitacao(TRegModulo(VF_RegModulo^).PModulo, PUtf8Char(VL_Tarefa^.VF_TransmissaoID), PUtf8Char(VL_Tarefa^.VF_Mensagem),
                      @ModuloServicoRetorno, VL_Tarefa^.VF_ID, VL_Tarefa^.VF_TempoEspera);

                end;
              end;

              VL_Linha := '24062024154405';
              for VL_I := 0 to V_ListaTarefas.Count - 1 do
              begin
                VL_Linha := '24062024155200';
                if VF_Sair then
                  Exit;


                VL_Tarefa := V_ListaTarefas[VL_I];
                VL_Linha := '2406202415700';
                if ((TimeStampToMSecs(DateTimeToTimeStamp(now)) - TimeStampToMSecs(DateTimeToTimeStamp(VL_Tarefa^.VF_DataCriacao))) > VL_Tarefa^.VF_TempoEspera) then
                begin
                  // pode estudar uma opcao de enviar uma mensagem de erro
                  VL_Linha := '2406202415701';
                  V_ListaTarefas.Remove(VL_Tarefa);
                  Dispose(VL_Tarefa);
                  Break;
                end;

              end;

              VL_Linha := '24062024154406';
            end;
          end;

          if VF_ConexaoTipo = cnCaixa then
            Sleep(100)
          else
            Sleep(500);

        end;

        if VF_ConexaoTipo = cnServico then
        begin
          VL_Linha := '24062024154500';
          DNucleo.VF_Modulo.RemovePorModuloConf(TRegModulo(VF_RegModulo^).ModuloConfig_ID);
          VL_Linha := '24062024154501';
        end;

      end;

    except
      on e: Exception do
        GravaLog(F_ArquivoLog, TRegModulo(VF_RegModulo^).ModuloConfig_ID, '', 'opentefnucleo', VL_Linha, 'Erro na TThModulo.Execute ' + e.ClassName + '/' + e.Message, '', VL_Erro, 1);
    end;
  finally
    try
      if TRegModulo(VF_RegModulo^).Handle <> 0 then
      begin
        VL_Erro := TRegModulo(VF_RegModulo^).Finalizar(TRegModulo(VF_RegModulo^).PModulo);

        if VL_Erro <> 0 then
        begin
          GravaLog(F_ArquivoLog, TRegModulo(VF_RegModulo^).ModuloConfig_ID, '', 'opentefnucleo', '111220231702', 'Erro no finalizar', '', VL_Erro, 1);
        end;

        Sleep(500);

        TRegModulo(VF_RegModulo^).PModulo := nil;
        DNucleo.VF_DLL.descarregarDLL(ExtractFilePath(ParamStr(0)) + 'modulo/' + TRegModulo(VF_RegModulo^).Biblioteca);
      end;
      VF_Rodando := False;
    except
      on e: Exception do
        GravaLog(F_ArquivoLog, TRegModulo(VF_RegModulo^).ModuloConfig_ID, '', 'opentefnucleo', '290820222000', 'Erro na TThModulo.Execute ' + e.ClassName + '/' + e.Message, '', VL_Erro, 1);
    end;
  end;
end;



procedure TDNucleo.iniciar;
var
  VL_RegModulo: TRegModulo;
  VL_Conf: TIniFile;
begin
  VL_Conf := nil;
  try
    try

      GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '2024061911261230',
        'TDNucleo.iniciar Iniciando', '', 0, 3);


      VL_RegModulo.Menu_Operacional_estatico := True;
      VL_RegModulo.Menu_estatico := True;
      VL_RegModulo.ModuloConfig_ID := 0;


      if not FileExists(ExtractFilePath(ParamStr(0)) + 'open_tef.ini') then
      begin
        VL_Conf := TIniFile.Create(PChar(ExtractFilePath(ParamStr(0)) + 'open_tef.ini'));
        VL_Conf.WriteInteger('Servidor', 'Porta', 39000);
        VL_Conf.WriteBool('Servidor', 'Ativa', True);
        VL_Conf.WriteBool('Servidor', 'Debug', False);
        {$IFDEF LINUX}
        VL_Conf.WriteString('BancoDados','LibraryLocation',  ExtractFilePath(ParamStr(0)) + 'bd/libfbclient.so');
        {$ELSE}
        VL_Conf.WriteString('BancoDados', 'LibraryLocation', ExtractFilePath(ParamStr(0)) + 'bd\fbclient.dll');
        {$ENDIF}
        VL_Conf.WriteString('BancoDados', 'HostName', 'localhost');
        VL_Conf.WriteInteger('BancoDados', 'Port', 3050);
        VL_Conf.WriteString('BancoDados', 'User', 'SYSDBA');
        VL_Conf.WriteString('BancoDados', 'Password', 'masterkey');
        {$IFDEF LINUX}
        VL_Conf.WriteString('BancoDados','Database', ExtractFilePath(ParamStr(0)) + 'bd/opentef.fdb');
        {$ELSE}
        VL_Conf.WriteString('BancoDados', 'Database', ExtractFilePath(ParamStr(0)) + 'bd\opentef.fdb');
        {$ENDIF}
        VL_Conf.Free;
      end;

      VL_Conf := TIniFile.Create(PChar(ExtractFilePath(ParamStr(0)) + 'open_tef.ini'));

      ZConexao.LibraryLocation := VL_Conf.ReadString('BancoDados', 'LibraryLocation', '');
      ZConexao.HostName := VL_Conf.ReadString('BancoDados', 'HostName', 'localhost');
      ZConexao.Database := VL_Conf.ReadString('BancoDados', 'Database', 'opentef');
      ZConexao.User := VL_Conf.ReadString('BancoDados', 'User', 'SYSDBA');
      ZConexao.Port := VL_Conf.ReadInteger('BancoDados', 'Port', 3050);
      ZConexao.Password := VL_Conf.ReadString('BancoDados', 'Password', 'masterkey');

      C_Debug := VL_Conf.ReadBool('Servidor', 'Debug', False);

      GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '2022110812319', 'TDNucleo.iniciar ' + 'Tentando Conectar Banco de dados LIB:' + ZConexao.LibraryLocation +
        ' banco:' + ZConexao.Database, '', 0, 3);

      ZConexao.Connect;

      ZConexao.Disconnect;

      GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '2022110812316', 'TDNucleo.iniciar ' + 'Conectado Banco de Dados...', '', 0, 3);

      Application.CreateForm(TDBancoDados, DBancoDados);
      DComunicador := TDComunicador.Create(Self);
      DComunicador.V_ArquivoLog := F_ArquivoLog;
      DComunicador.V_ServidorRecebimento := @comando;
      DComunicador.V_TransmissaoComando := @TransmissaoComando;

      if VL_Conf.ReadInteger('Servidor', 'Porta', 0) <> 0 then
      begin
        DComunicador.IdTCPServidor.DefaultPort := VL_Conf.ReadInteger('Servidor', 'Porta', 0);
        DComunicador.IdTCPServidor.Active := VL_Conf.ReadBool('Servidor', 'Ativa', False);
      end;

      F_Modulo_ID_Contador := 0;
      F_Tarefa_ID_Contador := 0;
      atualizaConfiguracao;
      AtualizaMENU_OPERACIONAL(VL_RegModulo, nil, True);
      AtualizaMENU(VL_RegModulo, nil, True);
      ModuloCarrega(0);

      GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '202211081230',
        'TDNucleo.iniciar Iniciado', '', 0, 3);


    finally
      if Assigned(VL_Conf) then
        VL_Conf.Free;
    end;
  except
    on e: Exception do
      GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '202211081229',
        'TDNucleo.iniciar ' + e.ClassName + '/' + e.Message, '', 0, 1);
  end;
end;

procedure TDNucleo.atualizaConfiguracao;
var
  VL_BancoDados: TDBancoDados;
begin
  try
    try
      VL_BancoDados := TDBancoDados.Create(nil);

      VL_BancoDados.ConsultaA.Close;
      VL_BancoDados.ConsultaA.SQL.Text := 'SELECT FIRST(1) NIVEL_LOG FROM CONFIG';
      VL_BancoDados.ConsultaA.Open;

      if VL_BancoDados.ConsultaA.RecordCount = 0 then
        Exit;

      F_NivelLog := VL_BancoDados.ConsultaA.FieldByName('NIVEL_LOG').AsInteger;

    except
      on e: Exception do
      begin
        GravaLog(F_ArquivoLog, 0, 'atualizaConfiguracao',
          'opentefnucleo', '141120231603',
          'excecao ' + e.ClassName + '/' + e.Message, '', 1, 1);
      end;
    end;
  finally
    VL_BancoDados.Free;
  end;
end;

procedure TDNucleo.parar;
begin
  if not Assigned(DNucleo) then
    Exit;
  ModuloDescarrega(0, 0);

  DComunicador.Free;
  DComunicador := nil;

  ZConexao.Disconnect;

  DNucleo.Free;
  DNucleo := nil;

  GravaLog(F_ArquivoLog, 0, 'ModuloDescarrega', 'opentefnucleo',
    '141120231650', 'fim do TDNucleo.parar', '', 0, 3);
end;

function TDNucleo.ModuloCarrega(VP_ModuloConfig_ID: integer): integer;
var
  VL_RegModulo: ^TRegModulo;
  VL_BancoDados: TDBancoDados;
begin
  VL_BancoDados := TDBancoDados.Create(nil);
  try
    try
      F_Modulo_ID_Contador := F_Modulo_ID_Contador + 1;
      VL_BancoDados.ConsultaA.Close;
      VL_BancoDados.ConsultaA.SQL.Text :=
        'SELECT MC.ID AS ID,MC.MODULO_ID,MC.ADQUIRENTE_ID,MC.SERVICO_HOST, ' + ' MC.SERVICO_PORTA,MC.CAIXA_HOST,MC.CAIXA_PORTA,MC.DESCRICAO,MC.BIN_ESTATICO,MC.MENU_ESTATICO, ' +
        ' MC.MENU_ESTATICO_OPERACIONAL,M.TAG_NUMERO, A.TAG_NUMERO AS ADQUIRENTE_TAG_NUMERO,C.CHAVE_COMUNICACAO,I.IDENTIFICADOR' + ' FROM MODULO_CONF MC ' +
        ' INNER JOIN MODULO M ON M.ID=MC.MODULO_ID ' + ' INNER JOIN ADQUIRENTE A ON MC.ADQUIRENTE_ID=A.ID ' + ' LEFT OUTER JOIN CHAVE C ' +
        ' ON MC.CHAVE_ID = C.ID ' + ' LEFT OUTER JOIN IDENTIFICACAO I ' + ' ON MC.IDENTIFICACAO_ID = I.ID ' + ' WHERE MC.HABILITADO=''T'' AND ((MC.ID=' +
        IntToStr(VP_ModuloConfig_ID) + ') OR (0=' + IntToStr(VP_ModuloConfig_ID) + '))';

      VL_BancoDados.ConsultaA.Open;
      while not VL_BancoDados.ConsultaA.EOF do
      begin
        new(VL_RegModulo);
        VL_RegModulo^.ConexaoTipo := cnServico;
        VL_RegModulo^.ModuloProcID := F_Modulo_ID_Contador;
        VL_RegModulo^.AdquirenteTag :=
          VL_BancoDados.ConsultaA.FieldByName('ADQUIRENTE_TAG_NUMERO').AsString;
        VL_RegModulo^.ModuloConfig_ID :=
          VL_BancoDados.ConsultaA.FieldByName('ID').AsInteger;
        VL_RegModulo^.Biblioteca :=
          VL_BancoDados.ConsultaA.FieldByName('TAG_NUMERO').AsString + C_Lib;
        VL_RegModulo^.Tag :=
          VL_BancoDados.ConsultaA.FieldByName('TAG_NUMERO').AsString;
        VL_RegModulo^.Host :=
          VL_BancoDados.ConsultaA.FieldByName('SERVICO_HOST').AsString;
        VL_RegModulo^.Porta :=
          VL_BancoDados.ConsultaA.FieldByName('SERVICO_PORTA').AsInteger;
        VL_RegModulo^.Chave :=
          VL_BancoDados.ConsultaA.FieldByName('CHAVE_COMUNICACAO').AsString;
        VL_RegModulo^.Descricao :=
          VL_BancoDados.ConsultaA.FieldByName('DESCRICAO').AsString;
        VL_RegModulo^.Bin_Estatico :=
          VL_BancoDados.ConsultaA.FieldByName('BIN_ESTATICO').AsBoolean;
        VL_RegModulo^.Menu_Estatico :=
          VL_BancoDados.ConsultaA.FieldByName('MENU_ESTATICO').AsBoolean;
        VL_RegModulo^.Identificador :=
          VL_BancoDados.ConsultaA.FieldByName('IDENTIFICADOR').AsString;
        VL_RegModulo^.Handle := 0;
        VL_RegModulo^.Menu_Operacional_estatico :=
          VL_BancoDados.ConsultaA.FieldByName('MENU_ESTATICO_OPERACIONAL').AsBoolean;
        VL_RegModulo^.ThModulo :=
          TThModulo.Create(True, VL_RegModulo, cnServico, PChar(ExtractFilePath(ParamStr(0)) + VL_BancoDados.ConsultaA.FieldByName('TAG_NUMERO').AsString + '_servico.txt'), DNucleo);
        VF_ListaTRegModulo.Add(VL_RegModulo);
        VL_RegModulo^.ThModulo.Start;


        F_Modulo_ID_Contador := F_Modulo_ID_Contador + 1;
        new(VL_RegModulo);
        VL_RegModulo^.ConexaoTipo := cnCaixa;
        VL_RegModulo^.ModuloProcID := F_Modulo_ID_Contador;
        VL_RegModulo^.ModuloConfig_ID :=
          VL_BancoDados.ConsultaA.FieldByName('ID').AsInteger;
        VL_RegModulo^.AdquirenteTag :=
          VL_BancoDados.ConsultaA.FieldByName('ADQUIRENTE_TAG_NUMERO').AsString;
        VL_RegModulo^.Biblioteca :=
          VL_BancoDados.ConsultaA.FieldByName('TAG_NUMERO').AsString + C_Lib;
        VL_RegModulo^.Tag :=
          VL_BancoDados.ConsultaA.FieldByName('TAG_NUMERO').AsString;
        VL_RegModulo^.Host :=
          VL_BancoDados.ConsultaA.FieldByName('CAIXA_HOST').AsString;
        VL_RegModulo^.Porta :=
          VL_BancoDados.ConsultaA.FieldByName('CAIXA_PORTA').AsInteger;
        VL_RegModulo^.Chave :=
          VL_BancoDados.ConsultaA.FieldByName('CHAVE_COMUNICACAO').AsString;
        VL_RegModulo^.Identificador :=
          VL_BancoDados.ConsultaA.FieldByName('IDENTIFICADOR').AsString;
        VL_RegModulo^.Descricao :=
          VL_BancoDados.ConsultaA.FieldByName('DESCRICAO').AsString;
        VL_RegModulo^.Bin_Estatico :=
          VL_BancoDados.ConsultaA.FieldByName('BIN_ESTATICO').AsBoolean;
        VL_RegModulo^.Menu_Estatico :=
          VL_BancoDados.ConsultaA.FieldByName('MENU_ESTATICO').AsBoolean;
        VL_RegModulo^.Handle := 0;
        VL_RegModulo^.Menu_Operacional_estatico :=
          VL_BancoDados.ConsultaA.FieldByName('MENU_ESTATICO_OPERACIONAL').AsBoolean;
        VL_RegModulo^.ThModulo :=
          TThModulo.Create(True, VL_RegModulo, cnCaixa, PChar(ExtractFilePath(ParamStr(0)) + VL_BancoDados.ConsultaA.FieldByName('TAG_NUMERO').AsString + '_caixa.txt'), DNucleo);
        VF_ListaTRegModulo.Add(VL_RegModulo);
        VL_RegModulo^.ThModulo.Start;



        VL_BancoDados.ConsultaA.Next;

      end;
      Result := 0;
    except
      on e: Exception do
      begin
        GravaLog(F_ArquivoLog, 0, 'ModuloCarrega', 'opentefnucleo',
          '141120231610',
          'excecao ' + e.ClassName + '/' + e.Message, '', 1, 1);
      end;
    end;
  finally
    VL_BancoDados.Free;
  end;
end;

function TDNucleo.ModuloDescarrega(VP_ModuloConfig_ID, VP_ModuloProcID: integer): integer;
var
  VL_I: integer;
  VL_RegModulo: ^TRegModulo;
begin
  Result := 0;

  try
    GravaLog(F_ArquivoLog, 0, 'ModuloDescarrega', 'opentefnucleo',
      '141120231631', 'comeco do  ModuloDescarrega', '', 0, 3);

    DNucleo.VF_Modulo.RemovePorModuloConf(VP_ModuloConfig_ID);
    if VP_ModuloConfig_ID = 0 then
    begin
      if Assigned(VF_ListaTRegModulo) then
      begin
        while VF_ListaTRegModulo.Count > 0 do
        begin
          if Assigned(VF_ListaTRegModulo.Items[0]) then
          begin
            VL_RegModulo := VF_ListaTRegModulo.Items[0];
            VL_RegModulo^.ThModulo.VF_Sair := True;
            if VL_RegModulo^.ThModulo.VF_Rodando then
              VL_RegModulo^.ThModulo.WaitFor;
            VL_RegModulo^.ThModulo.Free;
            Dispose(VL_RegModulo);
          end;
          VF_ListaTRegModulo.Delete(0);
        end;
      end;

    end
    else
    if VP_ModuloConfig_ID > 0 then
    begin
      if Assigned(VF_ListaTRegModulo) then
      begin
        for VL_I := 0 to VF_ListaTRegModulo.Count - 1 do
        begin
          if Assigned(VF_ListaTRegModulo.Items[VL_I]) then
          begin
            VL_RegModulo := VF_ListaTRegModulo.Items[VL_I];
            if VL_RegModulo^.ModuloConfig_ID = VP_ModuloConfig_ID then
            begin
              VL_RegModulo^.ThModulo.VF_Sair := True;
              if VL_RegModulo^.ThModulo.VF_Rodando then
                VL_RegModulo^.ThModulo.WaitFor;
              VL_RegModulo^.ThModulo.Free;
              Dispose(VL_RegModulo);
              VF_ListaTRegModulo.Delete(VL_I);
              Break;
            end;
          end;
        end;
      end;

      if Assigned(VF_ListaTRegModulo) then
      begin
        for VL_I := 0 to VF_ListaTRegModulo.Count - 1 do
        begin
          if Assigned(VF_ListaTRegModulo.Items[VL_I]) then
          begin
            VL_RegModulo := VF_ListaTRegModulo.Items[VL_I];
            if VL_RegModulo^.ModuloConfig_ID = VP_ModuloConfig_ID then
            begin
              VL_RegModulo^.ThModulo.VF_Sair := True;
              VL_RegModulo^.ThModulo.WaitFor;
              VL_RegModulo^.ThModulo.Free;
              Dispose(VL_RegModulo);
              VF_ListaTRegModulo.Delete(VL_I);
              Break;
            end;
          end;
        end;
      end;
    end
    else
    if VP_ModuloProcID > 0 then
    begin
      if Assigned(VF_ListaTRegModulo) then
      begin
        for VL_I := 0 to VF_ListaTRegModulo.Count - 1 do
        begin
          if Assigned(VF_ListaTRegModulo.Items[VL_I]) then
          begin
            VL_RegModulo := VF_ListaTRegModulo.Items[VL_I];
            if VL_RegModulo^.ModuloProcID = VP_ModuloProcID then
            begin
              VL_RegModulo^.ThModulo.VF_Sair := True;
              VL_RegModulo^.ThModulo.WaitFor;
              VL_RegModulo^.ThModulo.Free;
              VF_ListaTRegModulo.Remove(VL_RegModulo);
              Dispose(VL_RegModulo);
              Break;
            end;
          end;
        end;
      end;
    end;

    GravaLog(F_ArquivoLog, 0, 'ModuloDescarrega', 'opentefnucleo',
      '141120231632', 'fim do ModuloDescarrega', '', 0, 3);

  except
    on e: Exception do
    begin
      GravaLog(F_ArquivoLog, 0, 'ModuloDescarrega', 'opentefnucleo',
        '141120231631',
        'excecao ' + e.ClassName + '/' + e.Message, '', 1, 1);
    end;
  end;
end;

function TDNucleo.ModuloValida(VP_RegModulo: TRegModulo): integer;
var
  VL_DadosInteger: integer;
  VL_VersaoMensagem: integer;
  VL_ConexaoStatus: TConexaoStatus;
  VL_VersaoModulo: string;
  VL_Retorno: PUtf8Char;
begin
  // valida se o modulo esta habilitado a receber ou enviar solicitacao
  Result := 0;
  VL_DadosInteger := 0;
  VL_VersaoModulo := '';
  VL_VersaoMensagem := 0;
  VL_Retorno := nil;

  if not VP_RegModulo.ThModulo.Handle = 0 then
  begin
    Result := 110;
    Exit;
  end;

  Result := VP_RegModulo.ModuloStatus(VP_RegModulo.PModulo, VL_Retorno, VL_VersaoMensagem, VL_DadosInteger);

  VL_VersaoModulo := VL_Retorno;
  VP_RegModulo.StrDispose(VL_Retorno);

  if Result <> 0 then
  begin
    GravaLog(VP_RegModulo.ThModulo.VF_ArquivoLog,
      VP_RegModulo.ModuloConfig_ID, VP_RegModulo.Tag,
      'ModuloValida',
      '101120230904',
      'Erro ao tentar pegar status da conexao ' + ConexaoTipoToStr(VP_RegModulo.ThModulo.VF_ConexaoTipo) + ' da dll:' + VP_RegModulo.Biblioteca,
      '', Result, 1);
    Exit;
  end;

  VL_ConexaoStatus := IntToConexaoStatus(VL_DadosInteger);

  if VL_ConexaoStatus <> csLogado then
  begin
    Result := 111;
    Exit;
  end;
end;

function TDNucleo.ModuloAddSolicitacao(VP_ConexaoID: integer; VP_Transmissao_ID: string; VP_TempoEspera: int64; VP_ModuloConfig_ID: integer; VP_Mensagem: TMensagem;
  VP_ConexaoTipo: TConexaoTipo): integer;
var
  VL_I: integer;
  VL_RegModulo: ^TRegModulo;
  VL_Tarefa: ^TTarefa;
begin
  Result := -1;
  VL_Tarefa := nil;
  for VL_I := 0 to VF_ListaTRegModulo.Count - 1 do
  begin
    VL_RegModulo := VF_ListaTRegModulo[VL_I];
    if ((VL_RegModulo^.ModuloConfig_ID = VP_ModuloConfig_ID) and (VL_RegModulo^.ConexaoTipo = VP_ConexaoTipo)) then
    begin
      Result := ModuloValida(VL_RegModulo^);

      if Result <> 0 then
        Exit;

      new(VL_Tarefa);
      F_Tarefa_ID_Contador := F_Tarefa_ID_Contador + 1;
      VL_Tarefa^.VF_ID := F_Tarefa_ID_Contador;
      VL_Tarefa^.VF_TipoConexao := VP_ConexaoTipo;
      VL_Tarefa^.VF_ModuloConfig_ID := VP_ModuloConfig_ID;
      VL_Tarefa^.VF_Tratando := False;
      VL_Tarefa^.VF_DataCriacao := now;
      VL_Tarefa^.VF_Mensagem := VP_Mensagem.TagsAsString;
      VL_Tarefa^.VF_TempoEspera := VP_TempoEspera;
      VL_Tarefa^.VF_TransmissaoID := VP_Transmissao_ID;
      VL_Tarefa^.VF_ConexaoID := VP_ConexaoID;
      VL_RegModulo^.ThModulo.V_ListaTarefas.Add(VL_Tarefa);
      Result := 0;
      Exit;
    end
    else
      Result := 70;
  end;

end;

function TDNucleo.ModuloAddSolicitacaoIdentificacaoAdquirente(VP_ConexaoID: integer; VP_Transmissao_ID: string; VP_TempoEspera: int64; VP_Adquirente_Identificacao: string;
  VP_Mensagem: TMensagem; VP_ConexaoTipo: TConexaoTipo): integer;
var
  VL_I: integer;
  VL_RegModulo: ^TRegModulo;
  VL_Tarefa: ^TTarefa;
begin
  Result := -1;
  VL_Tarefa := nil;
  for VL_I := 0 to VF_ListaTRegModulo.Count - 1 do
  begin
    VL_RegModulo := VF_ListaTRegModulo.Items[VL_I];
    if ((VL_RegModulo^.Adquirente_Identificacao = VP_Adquirente_Identificacao) and (VL_RegModulo^.ConexaoTipo = VP_ConexaoTipo)) then
    begin
      new(VL_Tarefa);
      F_Tarefa_ID_Contador := F_Tarefa_ID_Contador + 1;
      VL_Tarefa^.VF_ID := F_Tarefa_ID_Contador;
      VL_Tarefa^.VF_TipoConexao := VP_ConexaoTipo;
      VL_Tarefa^.VF_Tratando := False;
      VL_Tarefa^.VF_DataCriacao := now;
      VL_Tarefa^.VF_Mensagem := VP_Mensagem.TagsAsString;
      VL_Tarefa^.VF_TempoEspera := VP_TempoEspera;
      VL_Tarefa^.VF_TransmissaoID := VP_Transmissao_ID;
      VL_Tarefa^.VF_ConexaoID := VP_ConexaoID;

      VL_RegModulo^.ThModulo.V_ListaTarefas.Add(VL_Tarefa);
      Result := 0;
      Exit;
    end
    else
      Result := 1;
  end;

end;

function TDNucleo.ModuloTarefaDel(VP_ModuloProcID, VP_Tarefa_ID: integer): integer;
var
  VL_I, VL_II: integer;
  VL_Tarefa: ^TTarefa;
  VL_RegModulo: ^TRegModulo;
begin
  Result := 97;

  if not Assigned(VF_ListaTRegModulo) then
    Exit;

  if VF_ListaTRegModulo.Count = 0 then
    Exit;

  for VL_I := 0 to VF_ListaTRegModulo.Count - 1 do
  begin
    if Assigned(VF_ListaTRegModulo.Items[VL_I]) then
    begin
      VL_RegModulo := VF_ListaTRegModulo.Items[VL_I];
      if (VL_RegModulo^.ModuloProcID = VP_ModuloProcID) then
      begin
        for VL_II := 0 to VL_RegModulo^.ThModulo.V_ListaTarefas.Count - 1 do
        begin
          VL_Tarefa := VL_RegModulo^.ThModulo.V_ListaTarefas.Items[VL_II];
          if VL_Tarefa^.VF_ID = VP_Tarefa_ID then
          begin
            VL_RegModulo^.ThModulo.V_ListaTarefas.Remove(VL_Tarefa);
            Dispose(VL_Tarefa);
            Result := 0;
            Exit;
          end;
        end;
      end;
    end;
  end;
end;

function TDNucleo.ModuloTarefaGet(VP_ModuloProcID, VP_Tarefa_ID: integer): TTarefa;
var
  VL_I, VL_II: integer;
  VL_RegModulo: ^TRegModulo;
  VL_Tarefa: ^TTarefa;
begin
  for VL_I := 0 to VF_ListaTRegModulo.Count - 1 do
  begin
    if Assigned(VF_ListaTRegModulo.Items[VL_I]) then
    begin
      VL_RegModulo := VF_ListaTRegModulo.Items[VL_I];
      if (VL_RegModulo^.ModuloProcID = VP_ModuloProcID) then
      begin
        for VL_II := 0 to VL_RegModulo^.ThModulo.V_ListaTarefas.Count - 1 do
        begin
          VL_Tarefa := VL_RegModulo^.ThModulo.V_ListaTarefas.Items[VL_II];
          if VL_Tarefa^.VF_ID = VP_Tarefa_ID then
          begin
            Result := VL_Tarefa^;
            Exit;
          end;
        end;
      end;
    end;
  end;
end;

function TDNucleo.ModuloAddSolicitacao(VP_Transmissao_ID: string; VP_TempoEspera, VP_ModuloProcID: integer; VP_Mensagem: TMensagem): integer;
var
  VL_I: integer;
  VL_RegModulo: ^TRegModulo;
  VL_Tarefa: ^TTarefa;
begin
  Result := -1;
  VL_Tarefa := nil;
  for VL_I := 0 to VF_ListaTRegModulo.Count - 1 do
  begin
    VL_RegModulo := VF_ListaTRegModulo.Items[VL_I];
    if (VL_RegModulo^.ModuloProcID = VP_ModuloProcID) then
    begin
      new(VL_Tarefa);
      F_Tarefa_ID_Contador := F_Tarefa_ID_Contador + 1;
      VL_Tarefa^.VF_ID := F_Tarefa_ID_Contador;
      VL_Tarefa^.VF_TipoConexao := VL_RegModulo^.ConexaoTipo;
      VL_Tarefa^.VF_ModuloConfig_ID := VL_RegModulo^.ModuloConfig_ID;
      VL_Tarefa^.VF_Tratando := False;
      VL_Tarefa^.VF_Tratando := False;
      VL_Tarefa^.VF_DataCriacao := now;
      VL_Tarefa^.VF_Mensagem := VP_Mensagem.TagsAsString;
      VL_Tarefa^.VF_TempoEspera := VP_TempoEspera;
      VL_Tarefa^.VF_TransmissaoID := VP_Transmissao_ID;
      VL_Tarefa^.VF_ConexaoID := 0;
      //            VL_Tarefa^.VF_SocketTransmissaoID := '';
      VL_RegModulo^.ThModulo.V_ListaTarefas.Add(VL_Tarefa);
    end
    else
      Result := 70;
  end;

end;

function TDNucleo.ModuloSolicitacaoBlocante(VP_MensagemEntrada: TMensagem; var VO_MensagemSaida: TMensagem; VP_Transmissao_ID: string; VP_TempoEspera: int64;
  VP_ModuloConfig_ID: integer; VP_ConexaoTipo: TConexaoTipo): integer;
var
  VL_I: integer;
  VL_RegModulo: ^TRegModulo;
  VL_PDadosRecebidos: PUTf8Char;
  VL_DadosRecebidos: string;
begin
  Result := -1;
  VL_PDadosRecebidos := nil;
  VL_DadosRecebidos := '';

  VO_MensagemSaida.Limpar;

  for VL_I := 0 to VF_ListaTRegModulo.Count - 1 do
  begin
    VL_RegModulo := VF_ListaTRegModulo[VL_I];
    if ((VL_RegModulo^.ModuloConfig_ID = VP_ModuloConfig_ID) and (VL_RegModulo^.ConexaoTipo = VP_ConexaoTipo)) then
    begin
      Result := ModuloValida(VL_RegModulo^);

      if Result <> 0 then
        Exit;

      Result := VL_RegModulo^.Solicitacaoblocante(VL_RegModulo^.PModulo, PUtf8Char(VP_Transmissao_ID), PUtf8Char(VP_MensagemEntrada.TagsAsString), VL_PDadosRecebidos, VP_TempoEspera);

      if Result <> 0 then
        Exit;

      VL_DadosRecebidos := VL_PDadosRecebidos;
      VL_RegModulo^.StrDispose(VL_PDadosRecebidos);

      VO_MensagemSaida.CarregaTags(VL_DadosRecebidos);

      Result := 0;
      Exit;
    end;
  end;

  Result := 70;
end;


function TDNucleo.AtualizaBIN(VP_RegModulo: TRegModulo; VP_Mensagem: TMensagem): integer;
var
  VL_BancoDados: TDBancoDados;
  VL_Bin: string;
  VL_Bins: TStringList;
  VL_ModuloConfID: integer;
  VL_I: integer;
begin
  Result := 0;
  GravaLog(F_ArquivoLog, 0, 'AtualizaBIN', 'opentefnucleo',
    '190620241531', 'iniciando AtualizaBIN', '', 1, 3);

  if not Assigned(@VP_RegModulo) then
  begin
    Result := 64;
    Exit;
  end;

  if VP_RegModulo.ModuloConfig_ID < 1 then
  begin
    Result := 64;
    Exit;
  end;

  VL_ModuloConfID := 0;
  VL_Bin := '';
  try
    try

      VL_BancoDados := TDBancoDados.Create(nil);
      VL_Bins := TStringList.Create;

      VF_Modulo.RemovePorModuloConf(VP_RegModulo.ModuloConfig_ID);

      VL_BancoDados.ConsultaA.Close;
      VL_BancoDados.ConsultaA.SQL.Text :=
        'SELECT MODULO.TAG_NUMERO, M.ID AS MODULO_CONF_ID, M.BIN_ESTATICO AS BIN_ESTATICO , B.IIN as BIN ' + ' FROM' + ' MODULO_CONF M' +
        ' INNER JOIN BIN B ON B.MODULO_CONF_ID=M.ID' + ' INNER JOIN MODULO ON MODULO.ID=M.MODULO_ID' + ' WHERE' + ' M.ID=' + IntToStr(VP_RegModulo.ModuloConfig_ID);
      VL_BancoDados.ConsultaA.Open;

      while not VL_BancoDados.ConsultaA.EOF do
      begin
        VF_Modulo.Add(VL_BancoDados.ConsultaA.FieldByName('BIN').AsString,
          VP_RegModulo.ModuloConfig_ID,
          VL_BancoDados.ConsultaA.FieldByName('TAG_NUMERO').AsString);
        VL_BancoDados.ConsultaA.Next;
      end;

      VP_RegModulo.Bin_estatico := (VL_BancoDados.ConsultaA.FieldByName('BIN_ESTATICO').AsString = 'T');

      if VP_RegModulo.Bin_estatico = False then
      begin
        if Assigned(VP_Mensagem) then
        begin
          VL_Bin := VP_Mensagem.GetTagAsAstring('0036');         //BIN UNICO
          if VL_Bin <> '' then
          begin
            VL_ModuloConfID := VF_Modulo.RetornaModuloConfId(VL_Bin);
            if VL_ModuloConfID = -1 then
            begin
              Result :=
                VF_Modulo.Add(VL_Bin, VP_RegModulo.ModuloConfig_ID, VP_RegModulo.Tag);
              if Result <> 0 then
                Exit;
            end
            else
            if VL_ModuloConfID <> VP_RegModulo.ModuloConfig_ID then
            begin
              Result := 63;
              Exit;
            end;

          end;

          //                testa antes de incluir
          VL_Bins.Text := VP_Mensagem.GetTagAsAstring('00CE');
          for VL_I := 0 to VL_Bins.Count - 1 do
          begin
            VL_Bin := VL_Bins[VL_I];
            if VL_Bin <> '' then
            begin
              VL_ModuloConfID := VF_Modulo.RetornaModuloConfId(VL_Bin);
              if (VL_ModuloConfID <> VP_RegModulo.ModuloConfig_ID) and (VL_ModuloConfID <> -1) then
              begin
                Result := 63;
                Exit;
              end;
            end;

          end;

          //              incluir bins
          for VL_I := 0 to VL_Bins.Count - 1 do
          begin
            VL_Bin := VL_Bins[VL_I];
            if VL_Bin <> '' then
            begin
              Result :=
                VF_Modulo.Add(VL_Bin, VP_RegModulo.ModuloConfig_ID, VP_RegModulo.Tag);
              if Result <> 0 then
                Exit;
            end;
          end;
        end;

      end
      else
      if Assigned(VP_Mensagem) then
      begin
        if (VP_Mensagem.GetTagAsAstring('0036') <> '') or (VP_Mensagem.GetTagAsAstring('00CE') <> '') then
          Result := 65;

      end;

    except
      on e: Exception do
      begin
        GravaLog(F_ArquivoLog, 0, 'AtualizaBIN', 'opentefnucleo', '141120231614',
          'excecao ' + e.ClassName + '/' + e.Message, '', 1, 1);
      end;
    end;
  finally
    VL_BancoDados.Free;
    VL_Bins.Free;
  end;

  GravaLog(F_ArquivoLog, 0, 'AtualizaBIN', 'opentefnucleo',
    '190620241532', 'finalizando AtualizaBIN', '', 1, 3);
end;

function TDNucleo.AtualizaMENU(VP_RegModulo: TRegModulo; VP_Mensagem: TMensagem; VP_Sistema: boolean): integer;
var
  VL_BancoDados: TDBancoDados;
  VL_Mensagem: TMensagem;
  VL_ModuloConfID: integer;
  VL_I: integer;
  VL_Tag: TTag;
  VL_Menu: TRecMenu;
begin
  Result := 0;
  VL_Tag.Dados := '';
  VL_Tag.Tag := '';
  VL_ModuloConfID := 0;
  try
    try
      VL_Mensagem := TMensagem.Create;
      VL_BancoDados := TDBancoDados.Create(nil);

      if not Assigned(@VP_RegModulo) then
      begin
        Result := 64;
        Exit;
      end;


      if VP_RegModulo.ModuloConfig_ID = 0 then
      begin
        VF_Menu.RemovePorModuloConf(0);
        VL_BancoDados.ConsultaA.Close;
        VL_BancoDados.ConsultaA.SQL.Text :=
          'SELECT  S_TAG_DADOS, S_TAG_NUMERO,S_HABILITADO' + ' FROM P_TAG_FUNCAO(0,''MENU_PDV'') WHERE S_HABILITADO=''T''';
        VL_BancoDados.ConsultaA.Open;
        while not VL_BancoDados.ConsultaA.EOF do
        begin
          VF_Menu.Add(VL_BancoDados.ConsultaA.FieldByName('S_TAG_NUMERO').AsString,
            VL_BancoDados.ConsultaA.FieldByName('S_TAG_DADOS').AsString, 0);
          VL_BancoDados.ConsultaA.Next;
        end;
        Exit;
      end;


      if VP_RegModulo.ModuloConfig_ID < 1 then
      begin
        Result := 64;
        Exit;
      end;

      VF_Menu.RemovePorModuloConf(VP_RegModulo.ModuloConfig_ID);



      if (VP_Sistema) and (VP_RegModulo.ModuloConfig_ID > 0) then
      begin

        VL_BancoDados.ConsultaA.Close;
        VL_BancoDados.ConsultaA.SQL.Text :=
          'SELECT TAG.DADOS,TAG.TAG_NUMERO,MODULO_FUNCAO.HABILITADO FROM MODULO_FUNCAO ' + 'INNER JOIN MODULO_CONF ON MODULO_CONF.MODULO_ID=MODULO_FUNCAO.MODULO_ID ' +
          'INNER JOIN TAG ON TAG.TAG_NUMERO=MODULO_FUNCAO.TAG_NUMERO AND TAG.TAG_TIPO=''MENU_PDV'' ' + 'WHERE MODULO_CONF.ID=' + IntToStr(VP_RegModulo.ModuloConfig_ID) +
          ' UNION ' + 'SELECT TAG.DADOS,TAG.TAG_NUMERO,MODULO_CONF_FUNCAO.HABILITADO FROM MODULO_CONF_FUNCAO ' +
          'INNER JOIN MODULO_CONF ON MODULO_CONF.ID = MODULO_CONF_FUNCAO.MODULO_CONF_ID AND MODULO_CONF.HABILITADO=''T'' ' +
          'INNER JOIN TAG ON TAG.TAG_NUMERO=MODULO_CONF_FUNCAO.TAG_NUMERO AND TAG.TAG_TIPO=''MENU_PDV'' WHERE MODULO_CONF.ID=' + IntToStr(VP_RegModulo.ModuloConfig_ID);

        VL_BancoDados.ConsultaA.Open;

        for VL_I := 1 to VL_BancoDados.ConsultaA.RecordCount do
        begin
          VL_Tag.Dados :=
            VL_BancoDados.ConsultaA.FieldByName('DADOS').AsString;
          VL_Tag.Tag :=
            VL_BancoDados.ConsultaA.FieldByName('TAG_NUMERO').AsString;

          Result := VF_Menu.Add(VL_Tag.Tag, VL_Tag.Dados, VP_RegModulo.ModuloConfig_ID);
          VL_ModuloConfID := VF_Menu.RetornaMenu(VL_Tag.Tag, VL_Menu);
          //VERIFICA SE O MENU É PARA EXCLUIR
          if VL_BancoDados.ConsultaA.FieldByName('HABILITADO').AsString = 'F' then
            VF_MENU.ListaMenu.Remove(
              VF_Menu.ListaMenu.Items[VL_ModuloConfID]);
        end;
        Exit;
      end;

      VL_BancoDados.ConsultaA.Close;
      VL_BancoDados.ConsultaA.SQL.Text :=
        'SELECT M.ID AS MODULO_CONF_ID, M.MENU_ESTATICO AS MENU_ESTATICO ' + ' FROM' + ' MODULO_CONF M' + ' WHERE' + ' M.ID=' + IntToStr(VP_RegModulo.ModuloConfig_ID);
      VL_BancoDados.ConsultaA.Open;

      VP_RegModulo.Menu_estatico :=
        (VL_BancoDados.ConsultaA.FieldByName('MENU_ESTATICO').AsString = 'T');


      if ((VP_Mensagem.GetTagAsAstring('007D') = '') and (VP_Mensagem.GetTagAsAstring('004D') = '0')) then
        // não é para atualizar o menu
        Exit;


      Result := VL_Mensagem.CarregaTags(VP_Mensagem.GetTagAsAstring('007D'));
      //TAG DE MENSAGEM CONTENDO O MENU

      if (((VP_RegModulo.Menu_estatico = False) or (VP_Sistema)) and (Result = 0)) then
      begin
        if Assigned(VP_Mensagem) then
        begin
          //                testa antes de incluir, permite incluir tag proprietaria ou official
          //                testa as tag oficiais e nao oficiais


          // testa as tags nao oficiais se ja foi incluida, testa as tag oficiais comparando com banco de dados

          VL_BancoDados.ConsultaA.Close;
          VL_BancoDados.ConsultaA.SQL.Text :=
            'SELECT  S_TAG_NUMERO,S_HABILITADO' + ' FROM P_TAG_FUNCAO(0,''MENU_PDV'') WHERE S_HABILITADO=''T''';
          VL_BancoDados.ConsultaA.Open;


          for VL_I := 1 to VL_Mensagem.TagCount do
          begin
            VL_Mensagem.GetTag(VL_I, VL_Tag);

            if Length(Trim(VL_Tag.Tag)) = 0 then
            begin
              Result := 75;
              Exit;
            end;

            if Length(Trim(VL_Tag.Dados)) = 0 then
            begin
              Result := 76;
              Exit;
            end;


            VL_ModuloConfID := VF_Menu.RetornaModuloConfId(VL_Tag.Tag);
            if VL_ModuloConfID <> 0 then
              if (VL_ModuloConfID <> VP_RegModulo.ModuloConfig_ID) and (VL_ModuloConfID <> -1) then
              begin
                Result := 72;
                Exit;
              end;

            if Copy(VL_Tag.Tag, 1, 2) <> 'FF' then
              //verifica a permissao de uso da tag oficial
            begin
              if not VL_BancoDados.ConsultaA.Locate('S_TAG_NUMERO', VL_Tag.Tag, []) then
              begin
                Result := 73;
                Exit;
              end;
            end;
          end;


          //              incluir MENUS
          for VL_I := 1 to VL_Mensagem.TagCount do
          begin
            VL_Mensagem.GetTag(VL_I, VL_Tag);
            if Copy(VL_Tag.Tag, 1, 2) <> 'FF' then
              Result := VF_Menu.Add(VL_Tag.Tag, VL_Tag.Dados, 0)
            else
              Result :=
                VF_Menu.Add(VL_Tag.Tag, VL_Tag.Dados, VP_RegModulo.ModuloConfig_ID);
            if Result <> 0 then
              Exit;
          end;
        end;

      end
      else
      if Assigned(VP_Mensagem) then
      begin
        if (VP_Mensagem.GetTagAsAstring('007D') <> '') then
          Result := 71;

      end;

    except
      on e: Exception do
      begin
        GravaLog(F_ArquivoLog, 0, 'AtualizaMENU', 'opentefnucleo',
          '141120231617',
          'excecao ' + e.ClassName + '/' + e.Message, '', 1, 1);
      end;
    end;
  finally
    VL_Mensagem.Free;
    VL_BancoDados.Free;
  end;

end;

function TDNucleo.AtualizaMENU_OPERACIONAL(VP_RegModulo: TRegModulo; VP_Mensagem: TMensagem; VP_Sistema: boolean): integer;
var
  VL_BancoDados: TDBancoDados;
  VL_Mensagem: TMensagem;
  VL_ModuloConfID: integer;
  VL_I: integer;
  VL_Tag: TTag;
begin
  Result := 0;
  VL_Tag.Dados := '';
  VL_Tag.Tag := '';
  VL_ModuloConfID := 0;
  try
    try
      VL_Mensagem := TMensagem.Create;
      VL_BancoDados := TDBancoDados.Create(nil);

      if not Assigned(@VP_RegModulo) then
      begin
        Result := 64;
        Exit;
      end;

      if VP_RegModulo.ModuloConfig_ID = 0 then
      begin
        VF_MenuOperacional.RemovePorModuloConf(0);
        VL_BancoDados.ConsultaA.Close;
        VL_BancoDados.ConsultaA.SQL.Text :=
          'SELECT  S_TAG_DADOS, S_TAG_NUMERO,S_HABILITADO' + ' FROM P_TAG_FUNCAO(0,''MENU_OPERACIONAL'') WHERE S_HABILITADO=''T''';
        VL_BancoDados.ConsultaA.Open;
        while not VL_BancoDados.ConsultaA.EOF do
        begin
          VF_MenuOperacional.Add(VL_BancoDados.ConsultaA.FieldByName('S_TAG_NUMERO').AsString,
            VL_BancoDados.ConsultaA.FieldByName('S_TAG_DADOS').AsString, 0);
          VL_BancoDados.ConsultaA.Next;
        end;
        Exit;
      end;

      if VP_RegModulo.ModuloConfig_ID < 1 then
      begin
        Result := 64;
        Exit;
      end;

      VF_MenuOperacional.RemovePorModuloConf(VP_RegModulo.ModuloConfig_ID);
      VL_BancoDados.ConsultaA.Close;
      VL_BancoDados.ConsultaA.SQL.Text :=
        'SELECT M.ID AS MODULO_CONF_ID, M.MENU_ESTATICO AS MENU_ESTATICO_OPERACIONAL ' + ' FROM' + ' MODULO_CONF M' + ' WHERE' + ' M.ID=' + IntToStr(VP_RegModulo.ModuloConfig_ID);
      VL_BancoDados.ConsultaA.Open;

      VP_RegModulo.Menu_estatico :=
        (VL_BancoDados.ConsultaA.FieldByName('MENU_ESTATICO_OPERACIONAL').AsString = 'T');


      if ((VP_Mensagem.GetTagAsAstring('007D') = '') and (VP_Mensagem.GetTagAsAstring('004D') = '0')) then
        // não é para atualizar o menu
        Exit;

      Result := VL_Mensagem.CarregaTags(VP_Mensagem.GetTagAsAstring('007D'));
      //TAG DE MENSAGEM CONTENDO O MENU


      if ((VP_RegModulo.Menu_estatico = False) and (Result = 0)) then
      begin
        if Assigned(VP_Mensagem) then
        begin
          //                testa antes de incluir, permite incluir tag proprietaria ou official
          //                testa as tag oficiais e nao oficiais


          // testa as tags nao oficiais se ja foi incluida, testa as tag oficiais comparando com banco de dados

          VL_BancoDados.ConsultaA.Close;
          VL_BancoDados.ConsultaA.SQL.Text :=
            'SELECT  S_TAG_NUMERO,S_HABILITADO' + ' FROM P_TAG_FUNCAO(0,''MENU_OPERACIONAL'') WHERE S_HABILITADO=''T''';
          VL_BancoDados.ConsultaA.Open;


          for VL_I := 1 to VL_Mensagem.TagCount do
          begin
            VL_Mensagem.GetTag(VL_I, VL_Tag);

            if Length(Trim(VL_Tag.Tag)) = 0 then
            begin
              Result := 75;
              Exit;
            end;

            if Length(Trim(VL_Tag.Dados)) = 0 then
            begin
              Result := 76;
              Exit;
            end;


            VL_ModuloConfID :=
              VF_MenuOperacional.RetornaModuloConfId(VL_Tag.Tag);
            if VL_ModuloConfID <> 0 then
              if (VL_ModuloConfID <> VP_RegModulo.ModuloConfig_ID) and (VL_ModuloConfID <> -1) then
              begin
                Result := 72;
                Exit;
              end;

            if Copy(VL_Tag.Tag, 1, 2) <> 'FF' then
              //verifica a permissao de uso da tag oficial
            begin
              if not VL_BancoDados.ConsultaA.Locate('S_TAG_NUMERO', VL_Tag.Tag, []) then
              begin
                Result := 73;
                Exit;
              end;
            end;
          end;


          //              incluir MENUS
          for VL_I := 1 to VL_Mensagem.TagCount do
          begin
            VL_Mensagem.GetTag(VL_I, VL_Tag);
            if Copy(VL_Tag.Tag, 1, 2) <> 'FF' then
              Result := VF_MenuOperacional.Add(VL_Tag.Tag, VL_Tag.Dados, 0)
            else
              Result :=
                VF_MenuOperacional.Add(VL_Tag.Tag, VL_Tag.Dados, VP_RegModulo.ModuloConfig_ID);
            if Result <> 0 then
              Exit;
          end;
        end;

      end
      else
      if Assigned(VP_Mensagem) then
      begin
        if (VP_Mensagem.GetTagAsAstring('007D') <> '') then
          Result := 71;

      end;

    except
      on e: Exception do
      begin
        GravaLog(F_ArquivoLog, 0, 'AtualizaMENU_OPERACIONAL',
          'opentefnucleo', '141120231619',
          'excecao ' + e.ClassName + '/' + e.Message, '', 1, 1);
      end;
    end;
  finally
    VL_Mensagem.Free;
    VL_BancoDados.Free;
  end;
end;

function TDNucleo.ModuloGetReg(VP_ModuloProc_ID: integer): Pointer;
var
  VL_I: integer;
  VL_RegModulo: ^TRegModulo;
begin

  Result := nil;

  if not Assigned(VF_ListaTRegModulo) then
    Exit;

  if VF_ListaTRegModulo.Count = 0 then
    Exit;

  for VL_I := 0 to VF_ListaTRegModulo.Count - 1 do
  begin
    VL_RegModulo := VF_ListaTRegModulo.Items[VL_I];
    if VL_RegModulo^.ModuloProcID = VP_ModuloProc_ID then
    begin
      Result := VL_RegModulo;
      Exit;
    end;
  end;

end;

function TDNucleo.ModuloGetRegAdquirencia(VP_AdquirenciaIdentificacao, VP_Tag: string): TRegModulo;
var
  VL_I: integer;
  VL_RegModulo: ^TRegModulo;
begin
  Result.ModuloConfig_ID := -1;
  Result.ModuloProcID := -1;

  if not Assigned(VF_ListaTRegModulo) then
    Exit;

  if VF_ListaTRegModulo.Count = 0 then
    Exit;

  for VL_I := 0 to VF_ListaTRegModulo.Count - 1 do
  begin
    VL_RegModulo := VF_ListaTRegModulo.Items[VL_I];
    if (VL_RegModulo^.Adquirente_Identificacao = VP_AdquirenciaIdentificacao) and (VL_RegModulo^.Tag = VP_Tag) then
    begin
      Result := VL_RegModulo^;
      Exit;
    end;
  end;

end;

function TDNucleo.ModuloGetModuloConfigID(VP_ModuloConfig_ID: integer; VP_ConexaoTipo: TConexaoTipo): TRegModulo;
var
  VL_I: integer;
  VL_RegModulo: ^TRegModulo;
begin
  Result.ModuloConfig_ID := -1;
  Result.ModuloProcID := -1;

  if not Assigned(VF_ListaTRegModulo) then
    Exit;

  if VF_ListaTRegModulo.Count = 0 then
    Exit;

  for VL_I := 0 to VF_ListaTRegModulo.Count - 1 do
  begin
    VL_RegModulo := VF_ListaTRegModulo.Items[VL_I];
    if ((VL_RegModulo^.ModuloConfig_ID = VP_ModuloConfig_ID) and (VL_RegModulo^.ConexaoTipo = VP_ConexaoTipo)) then
    begin
      Result := VL_RegModulo^;
      Exit;
    end;
  end;

end;

{ TBin }

constructor TModulo.Create;
begin
  inherited;
  ListaBin := TList.Create;
end;

destructor TModulo.Destroy;
var
  VL_RecModulo: ^TRecModulo;
begin
  while ListaBin.Count > 0 do
  begin
    VL_RecModulo := ListaBin[0];
    Dispose(VL_RecModulo);
    ListaBin.Delete(0);
  end;


  ListaBin.Free;
  inherited Destroy;
end;

function TModulo.Add(VP_IIN: ansistring; VP_ModuloConfID: integer; VP_Tag: string): integer;
var
  VL_RecModulo: ^TRecModulo;
  VL_ModuloConfID: integer;
begin
  Result := 0;
  if Length(Trim(VP_IIN)) = 0 then
  begin
    Result := 74;
    Exit;
  end;
  VL_ModuloConfID := RetornaModuloConfId(VP_IIN);
  if (VL_ModuloConfID <> VP_ModuloConfID) and (VL_ModuloConfID <> -1) then
  begin
    Result := 63;
    Exit;
  end;
  new(VL_RecModulo);
  VL_RecModulo^.IIN := VP_IIN;
  VL_RecModulo^.ModuloTag := VP_Tag;
  VL_RecModulo^.ModuloConfID := VP_ModuloConfID;
  ListaBin.Add(VL_RecModulo);
end;

procedure TModulo.Limpar;
var
  VL_RecModulo: ^TRecModulo;
begin
  while ListaBin.Count > 0 do
  begin
    VL_RecModulo := ListaBin[0];
    Dispose(VL_RecModulo);
    ListaBin.Delete(0);
  end;

end;

function TModulo.Get(VP_Posicao: integer): TRecModulo;
var
  VL_RecModulo: ^TRecModulo;
begin
  VL_RecModulo := ListaBin.Items[VP_Posicao];
  Result := VL_RecModulo^;
end;


function TModulo.Count: integer;
begin
  Result := ListaBin.Count;
end;

procedure TModulo.RemovePorModuloConf(VP_ModuloConfID: integer);
var
  VL_RecModulo: ^TRecModulo;
  VL_Continua: boolean;
  VL_I: integer;
begin
  VL_Continua := True;

  while VL_Continua do
  begin

    VL_I := Self.ListaBin.Count;
    if VL_I = 0 then
      exit;

    VL_Continua := False;

    for VL_I := 0 to Self.ListaBin.Count - 1 do
    begin
      VL_RecModulo := Self.ListaBin.Items[VL_I];
      if VL_RecModulo^.ModuloConfID = VP_ModuloConfID then
      begin
        VL_Continua := True;
        Self.ListaBin.Remove(VL_RecModulo);
        Dispose(VL_RecModulo);
        Break;
      end;

    end;

  end;
end;

function TModulo.RetornaModuloConfId(VP_IIN: ansistring): integer;
var
  VL_Modulo: ^TRecModulo;
  VL_I: integer;
begin
  Result := -1;

  if ListaBin.Count = 0 then
    Exit;

  for VL_I := 0 to ListaBin.Count - 1 do
  begin
    VL_Modulo := ListaBin.Items[VL_I];
    if VL_Modulo^.IIN = VP_IIN then
    begin
      Result := VL_Modulo^.ModuloConfID;
      Exit;
    end;
  end;

end;

function TModulo.RetornaModulo(VP_IIN,VP_Tag: ansistring): TRecModulo;
var
  VL_RecModulo: ^TRecModulo;
  VL_I: integer;
begin
  Result.ModuloConfID := -1;
  Result.IIN := '';
  Result.ModuloTag := '';

  if ListaBin.Count = 0 then
    Exit;

  for VL_I := 0 to ListaBin.Count - 1 do
  begin
    VL_RecModulo := ListaBin.Items[VL_I];
    if VL_RecModulo^.IIN = VP_IIN then
    begin
      Result := VL_RecModulo^;
      Exit;
    end;
  end;

end;

function TModulo.RetornaBINPorTag(VP_Tag: ansistring): TRecModulo;
var
  VL_RecModulo: ^TRecModulo;
  VL_I: integer;
begin
  Result.ModuloConfID := -1;
  Result.IIN := '';
  Result.ModuloTag := '';

  if ListaBin.Count = 0 then
    Exit;

  for VL_I := 0 to ListaBin.Count - 1 do
  begin
    VL_RecModulo := ListaBin.Items[VL_I];
    if VL_RecModulo^.ModuloTag = VP_Tag then
    begin
      Result := VL_RecModulo^;
      Exit;
    end;
  end;

end;

constructor TConciliacao.Create(VP_Transmissao_ID: string; VP_Conexao_ID: integer; VP_TempoEspera: integer = 60000);
begin
  inherited Create;
  ListaConciliacao := TList.Create;
  TempoEspera := VP_TempoEspera;
  TransmissaoID := VP_Transmissao_ID;
  Conexao_ID := VP_Conexao_ID;
end;

destructor TConciliacao.Destroy;
begin
  while ListaConciliacao.Count > 0 do
  begin
    remove(0);
  end;

  ListaConciliacao.Free;
  inherited Destroy;
end;

function TConciliacao.add(VP_RecModulo: TRecModulo; VP_Transacao_ID, VP_Dados: string): integer;
var
  VL_RecConciliacao: ^TRecConciliacao;
  VL_I: integer;
begin
  Result := 0;

  new(VL_RecConciliacao);
  VL_RecConciliacao^.modulo := VP_RecModulo;
  VL_RecConciliacao^.transacao_id := VP_Transacao_ID;
  VL_RecConciliacao^.dados := VP_Dados;
  VL_RecConciliacao^.ThConciliacao := nil;

  ListaConciliacao.Add(VL_RecConciliacao);
end;

procedure TConciliacao.remove(VP_Posicao: integer);
var
  VL_RecConciliacao: ^TRecConciliacao;
begin
  if ListaConciliacao.Count - 1 < VP_Posicao then
    Exit;

  VL_RecConciliacao := ListaConciliacao.Items[VP_Posicao];

  if assigned(VL_RecConciliacao^.ThConciliacao) then
  begin
    VL_RecConciliacao^.ThConciliacao.VF_Sair := True;
    if VL_RecConciliacao^.ThConciliacao.VF_Rodando then
      VL_RecConciliacao^.ThConciliacao.WaitFor;
    VL_RecConciliacao^.ThConciliacao.Free;
  end;

  Dispose(VL_RecConciliacao);
  ListaConciliacao.Delete(VP_Posicao);
end;

function TConciliacao.consultar: ansistring;
var
  VL_RecConciliacao: ^TRecConciliacao;
  VL_I, VL_II: integer;
  VL_TempoLimite: longint;
  VL_Mensagem, VL_Retorno: TMensagem;
  VL_Posicao: integer;
  VL_Tag, VL_Dados: ansistring;
begin
  Result := '';
  VL_Posicao := 0;
  VL_Mensagem := TMensagem.Create;
  VL_Retorno := TMensagem.Create;
  try
    VL_Mensagem.AddComando('0118', 'CONCILIACAO'); // tabela de informacao

    for VL_I := 0 to ListaConciliacao.Count - 1 do
    begin
      VL_RecConciliacao := ListaConciliacao.Items[VL_I];
      VL_RecConciliacao^.ThConciliacao :=
        TThConciliacao.Create(True, VL_RecConciliacao^.modulo, VL_RecConciliacao^.dados, VL_RecConciliacao^.transacao_id, F_ArquivoLog, DNucleo, self.Conexao_ID);
      VL_RecConciliacao^.ThConciliacao.VF_Transmissao_ID := self.TransmissaoID;
      VL_RecConciliacao^.ThConciliacao.Start;
    end;

    VL_TempoLimite := DateTimeToTimeStamp(now).Time + TempoEspera;

    while True do
    begin
      if ListaConciliacao.Count = 0 then
        Break;

      if DateTimeToTimeStamp(now).Time > VL_TempoLimite then
        // verifica se o tempo de espera foi ultrapassado
      begin
        for VL_I := 0 to ListaConciliacao.Count - 1 do
        begin
          VL_RecConciliacao := ListaConciliacao.Items[VL_I];

          if ((VL_RecConciliacao^.ThConciliacao.VF_Status = ssCriada) or (VL_RecConciliacao^.ThConciliacao.VF_Status = ssAguardandoResposta)) then
          begin
            VL_Mensagem.AddTag(VL_Posicao, '0000',
              VL_RecConciliacao^.transacao_id + VL_RecConciliacao^.modulo.IIN);
            VL_Mensagem.AddTag(VL_Posicao, '0036',
              VL_RecConciliacao^.modulo.IIN);
            VL_Mensagem.AddTag(VL_Posicao, '004D', '67');
          end
          else
          begin
            VL_Posicao := VL_Posicao + 1;
            VL_Mensagem.AddTag(VL_Posicao, '0000',
              VL_RecConciliacao^.transacao_id + VL_RecConciliacao^.modulo.IIN);
            VL_Mensagem.AddTag(VL_Posicao, '0036',
              VL_RecConciliacao^.modulo.IIN);

            VL_Retorno.Limpar;
            VL_Retorno.CarregaTags(
              VL_RecConciliacao^.ThConciliacao.VF_Retorno);

            for VL_II := 1 to VL_Retorno.TagCount do
            begin
              VL_Retorno.GetTag(VL_II, VL_Tag, VL_Dados);
              VL_Mensagem.AddTag(VL_Posicao, VL_Tag, VL_Dados);
            end;
          end;

          self.remove(VL_I);
        end;

        Break;
      end;

      for VL_I := 0 to ListaConciliacao.Count - 1 do
      begin
        VL_RecConciliacao := ListaConciliacao.Items[VL_I];

        if ((VL_RecConciliacao^.ThConciliacao.VF_Status = ssCriada) or (VL_RecConciliacao^.ThConciliacao.VF_Status = ssAguardandoResposta)) then
          continue;

        VL_Posicao := VL_Posicao + 1;
        VL_Mensagem.AddTag(VL_Posicao, '0000',
          VL_RecConciliacao^.transacao_id + VL_RecConciliacao^.modulo.IIN);
        VL_Mensagem.AddTag(VL_Posicao, '0036', VL_RecConciliacao^.modulo.IIN);

        VL_Retorno.Limpar;
        VL_Retorno.CarregaTags(VL_RecConciliacao^.ThConciliacao.VF_Retorno);

        for VL_II := 1 to VL_Retorno.TagCount do
        begin
          VL_Retorno.GetTag(VL_II, VL_Tag, VL_Dados);
          VL_Mensagem.AddTag(VL_Posicao, VL_Tag, VL_Dados);
        end;

        self.remove(VL_I);
      end;

    end;
  finally
    VL_Mensagem.AddTag('0119', VL_Posicao); // quantidade de linha na tabela
    VL_Mensagem.TagToStr(Result);

    VL_Mensagem.Free;
    VL_Retorno.Free;
  end;
end;

constructor TThConciliacao.Create(VP_Suspenso: boolean; VP_Modulo: TRecModulo; VP_Dados: string; VP_Transacao_ID: string; VP_ArquivoLog: string; VP_DNucleo: Pointer;
  VP_Conexao_ID: integer; VP_TempoEspera: integer = 60000);
begin
  inherited Create(VP_Suspenso);
  VF_Sair := False;
  FreeOnTerminate := False;
  VF_DNucleo := VP_DNucleo;
  VF_Rodando := False;
  VF_ArquivoLog := VP_ArquivoLog;
  VF_Dados := VP_Dados;
  VF_Transacao_ID := VP_Transacao_ID;
  VF_Modulo := VP_Modulo;
  VF_Retorno := '';
  VF_Status := ssCriada;
  VF_TempoEspera := VP_TempoEspera;
  VF_Transmissao_ID := '';
  VF_Conexao_ID := VP_Conexao_ID;
end;

destructor TThConciliacao.Destroy;
begin
  inherited Destroy;
end;

procedure TThConciliacao.Execute;
var
  VL_Erro: integer;
  VL_I: integer;
  VL_Mensagem, VL_Retorno: TMensagem;
  VL_TRegModulo: TRegModulo;
  VL_DadosRecebidos: PUtf8Char;
  VL_Tag, VL_Dados: ansistring;
begin
  VF_Rodando := True;
  VL_Mensagem := TMensagem.Create;
  VL_Retorno := TMensagem.Create;
  VL_Erro := 0;
  VL_DadosRecebidos := '';
  try
    try
      begin

        VL_Erro := VL_Mensagem.CarregaTags(VF_Dados);

        if VL_Erro <> 0 then
        begin
          VF_Status := ssErro;
          VL_Mensagem.Limpar;
          VL_Mensagem.AddComando('0000', '');
          VL_Mensagem.AddTag('004D', IntToStr(VL_Erro));
          VL_Mensagem.TagToStr(VF_Retorno);
          Exit;
        end;

        while not Terminated do
        begin

          if VF_Sair then
            Exit;

          if ((VF_Status <> ssCriada) and (VF_Status <> ssAguardandoResposta)) then
            Exit;

          if VF_Status = ssCriada then
          begin
            VL_TRegModulo :=
              DNucleo.ModuloGetModuloConfigID(VF_Modulo.ModuloConfID, cnServico);

            if VL_TRegModulo.ModuloConfig_ID = -1 then
              // modulo da operadora nao carregado
            begin
              VF_Status := ssErro;
              VL_Mensagem.Limpar;
              VL_Mensagem.AddComando('0000', '');
              VL_Mensagem.AddTag('004D', 79);
              VL_Mensagem.TagToStr(VF_Retorno);
              Exit;
            end;

            VL_Erro := DNucleo.ModuloValida(VL_TRegModulo);

            if VL_Erro <> 0 then
            begin
              VF_Status := ssErro;
              VL_Mensagem.Limpar;
              VL_Mensagem.AddComando('0000', '');
              VL_Mensagem.AddTag('004D', IntToStr(VL_Erro));
              VL_Mensagem.TagToStr(VF_Retorno);
              Exit;
            end;

            // atualiza tag com o bin para criptografia de informacoes

            VL_Mensagem.AddComando('008C', 'S');
            // solicita atualizacao da tag
            VL_Mensagem.AddTag('0036', VF_Modulo.IIN); // bin

            VL_Retorno.Limpar;

            VL_Erro :=
              DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, 30000, True, nil, VF_Transmissao_ID, VL_Mensagem, VL_Retorno, VF_Conexao_ID);

            if VL_Erro <> 0 then
            begin
              VF_Status := ssErro;
              VL_Mensagem.Limpar;
              VL_Mensagem.AddComando('0000', '');
              VL_Mensagem.AddTag('004D', IntToStr(VL_Erro));
              VL_Mensagem.TagToStr(VF_Retorno);
              Exit;
            end;

            if ((VL_Retorno.Comando <> '0111') and (VL_Retorno.ComandoDados <> 'S')) then
            begin
              VF_Status := ssErro;
              VL_Mensagem.Limpar;
              VL_Mensagem.AddComando('0000', '');
              VL_Mensagem.AddTag('004D', 1);
              VL_Mensagem.TagToStr(VF_Retorno);
              Exit;
            end;

            VL_Erro :=
              VL_TRegModulo.Solicitacaoblocante(VL_TRegModulo.PModulo, PUtf8Char(VF_Transmissao_ID), PUtf8Char(VL_Retorno.TagsAsString), VL_DadosRecebidos, VF_TempoEspera);

            if VL_Erro <> 0 then
            begin
              VF_Status := ssErro;
              VL_Mensagem.Limpar;
              VL_Mensagem.AddComando('0000', '');
              VL_Mensagem.AddTag('004D', IntToStr(VL_Erro));
              VL_Mensagem.TagToStr(VF_Retorno);
              Exit;
            end;

            VL_Retorno.Limpar;
            VL_Erro := VL_Retorno.CarregaTags(VL_DadosRecebidos);

            if VL_Erro <> 0 then
            begin
              VF_Status := ssErro;
              VL_Mensagem.Limpar;
              VL_Mensagem.AddComando('0000', '');
              VL_Mensagem.AddTag('004D', IntToStr(VL_Erro));
              VL_Mensagem.TagToStr(VF_Retorno);
              Exit;
            end;

            if ((VL_Retorno.Comando <> '0111') and (VL_Retorno.ComandoDados <> 'R')) then
            begin
              VF_Status := ssErro;
              VL_Mensagem.Limpar;
              VL_Mensagem.AddComando('0000', '');
              VL_Mensagem.AddTag('004D', 1);
              VL_Mensagem.TagToStr(VF_Retorno);
              Exit;
            end;

            VL_Erro :=
              DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, 30000, True, nil, VF_Transmissao_ID, VL_Retorno, VL_Retorno, VF_Conexao_ID);

            if VL_Erro <> 0 then
            begin
              VF_Status := ssErro;
              VL_Mensagem.Limpar;
              VL_Mensagem.AddComando('0000', '');
              VL_Mensagem.AddTag('004D', IntToStr(VL_Erro));
              VL_Mensagem.TagToStr(VF_Retorno);
              Exit;
            end;

            VF_Status := ssAguardandoResposta;

            VL_Mensagem.AddComando('0113', 'S'); // solicita conciliacao
            copiaTag(VL_Retorno, VL_Mensagem, False);

            VL_Erro :=
              VL_TRegModulo.Solicitacaoblocante(VL_TRegModulo.PModulo, PUtf8Char(VF_Transmissao_ID), PUtf8Char(VL_Mensagem.TagsAsString), VL_DadosRecebidos, VF_TempoEspera);

            if VL_Erro <> 0 then
            begin
              VF_Status := ssErro;
              VL_Mensagem.Limpar;
              VL_Mensagem.AddComando('0000', '');
              VL_Mensagem.AddTag('004D', IntToStr(VL_Erro));
              VL_Mensagem.TagToStr(VF_Retorno);
              Exit;
            end;

            VL_Mensagem.Limpar;

            VL_Erro := VL_Mensagem.CarregaTags(VL_DadosRecebidos);

            if VL_Erro <> 0 then
            begin
              VF_Status := ssErro;
              VL_Mensagem.Limpar;
              VL_Mensagem.AddComando('0000', '');
              VL_Mensagem.AddTag('004D', IntToStr(VL_Erro));
              VL_Mensagem.TagToStr(VF_Retorno);
              Exit;
            end;

            VL_Mensagem.TagToStr(VF_Retorno);

            VF_Status := ssRespondida;
          end;

        end;
      end;

    except
      on e: Exception do
        GravaLog(F_ArquivoLog, 0,
          '', 'opentefnucleo', '221120231050',
          'Erro na TThConciliacao.Execute ' + e.ClassName + '/' + e.Message, '', VL_Erro, 1);
    end;
  finally
    try
      VL_Mensagem.Free;
      VL_Retorno.Free;
      VF_Rodando := False;
    except
      on e: Exception do
        GravaLog(F_ArquivoLog, 0,
          '', 'opentefnucleo', '221120231051',
          'Erro na TThConciliacao.Execute ' + e.ClassName + '/' + e.Message, '', VL_Erro, 1);
    end;
  end;
end;

constructor TDLL.Create;
begin
  ListaDLL := TList.Create;
  inherited;
end;

destructor TDLL.Destroy;
var
  VL_RecDLL: ^TRecDLL;
begin
  try

    while ListaDLL.Count > 0 do
    begin
      VL_RecDLL := ListaDLL[0];
      if VL_RecDLL^.instancia <= 0 then
      begin
        UnloadLibrary(VL_RecDLL^.handle);
        Dispose(VL_RecDLL);
      end;
      ListaDLL.Delete(0);
    end;

    ListaDLL.Free;

  except
    on e: Exception do
      GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '111220231624', 'Erro no TDLL.Destroy ' + e.ClassName + '/' + e.Message, '', 1, 1);
  end;

  inherited Destroy;
end;

function TDLL.carregarDLL(VP_DLL_Nome: string): TLibHandle;
var
  VL_RecDLL: ^TRecDLL;
  VL_I: integer;
begin
  Result := 0;

  {$IFDEF WIN}
    VP_DLL_Nome := StringReplace(VP_DLL_Nome,'/','\',[rfReplaceAll]);
  {$ENDIF}

  try
    try
      F_BloqueiaDLL.Beginread;
      for VL_I := 0 to ListaDLL.Count - 1 do
      begin
        VL_RecDLL := ListaDLL.Items[VL_I];
        if VL_RecDLL^.nome = VP_DLL_Nome then
        begin
          VL_RecDLL^.instancia := VL_RecDLL^.instancia + 1;
          Result := VL_RecDLL^.handle;
          Exit;
        end;
      end;
    finally
      F_BloqueiaDLL.Endread;
    end;

    try

      F_BloqueiaDLL.Beginwrite;
      new(VL_RecDLL);
      VL_RecDLL^.handle := LoadLibrary(PChar(VP_DLL_Nome));
      if VL_RecDLL^.handle <= 0 then
      begin
        Dispose(VL_RecDLL);
        Exit;
      end;
      Result := VL_RecDLL^.handle;
      VL_RecDLL^.instancia := 1;
      VL_RecDLL^.nome := VP_DLL_Nome;
      ListaDLL.Add(VL_RecDLL);

    finally
      F_BloqueiaDLL.Endwrite;
    end;

  except
    on e: Exception do
      GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '100720240946', 'Erro no TDLL.carregarDLL ' + e.ClassName + '/' + e.Message, '', 1, 1);
  end;
end;

function TDLL.descarregarDLL(VP_DLL_Nome: string): integer;
var
  VL_RecDLL: ^TRecDLL;
  VL_I: integer;
begin
  Result := -1;

  {$IFDEF WIN}
      VP_DLL_Nome := StringReplace(VP_DLL_Nome,'/','\',[rfReplaceAll]);
  {$ENDIF}

  try
    try
      F_BloqueiaDLL.Beginread;

      if ListaDLL.Count = 0 then
        exit;

      for VL_I := 0 to ListaDLL.Count - 1 do
      begin
        VL_RecDLL := ListaDLL.Items[VL_I];
        if VL_RecDLL^.nome = VP_DLL_Nome then
        begin
          VL_RecDLL^.instancia := VL_RecDLL^.instancia - 1;
          if VL_RecDLL^.instancia <= 0 then
          begin
            VL_RecDLL^.instancia := 0;
            UnloadLibrary(VL_RecDLL^.handle);
            ListaDLL.Delete(VL_I);
            Dispose(VL_RecDLL);
          end;
          Result := 0;
          Exit;
        end;
      end;
    except
      on e: Exception do
        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '111220231623', 'Erro ao descarregar a dll ' + e.ClassName + '/' + e.Message, '', 1, 1);
    end;
  finally
    F_BloqueiaDLL.Endread;
  end;
end;

{ TMenu }

constructor TMenu.Create;
begin
  ListaMenu := TList.Create;
  inherited;
end;

destructor TMenu.Destroy;
var
  VL_Menu: ^TRecMenu;
begin
  while ListaMenu.Count > 0 do
  begin
    VL_Menu := ListaMenu[0];
    Dispose(VL_Menu);
    ListaMenu.Delete(0);
  end;

  ListaMenu.Free;
  inherited Destroy;
end;

function TMenu.Add(VP_Tag: string; VP_TextoBotao: string; VP_ModuloConfID: integer): integer;
var
  VL_PMenu: ^TRecMenu;
  VL_Menu: TRecMenu;
begin
  Result := 0;
  VL_Menu.ModuloConfID := 0;
  VL_Menu.Tag := '';
  VL_Menu.TextoBotao := '';

  if Length(Trim(VP_Tag)) = 0 then
  begin
    Result := 75;
    Exit;
  end;

  if Length(Trim(VP_TextoBotao)) = 0 then
  begin
    Result := 76;
    Exit;
  end;

  new(VL_PMenu);

  Result := RetornaMenu(VP_Tag, VL_Menu);
  if Result > 0 then
    self.Delete(Result);
  Result := 0;

  VL_PMenu^.Tag := VP_Tag;
  VL_PMenu^.TextoBotao := VP_TextoBotao;
  VL_PMenu^.ModuloConfID := VP_ModuloConfID;
  ListaMenu.Add(VL_PMenu);
end;

function TMenu.Delete(VP_Index: integer): integer;
var
  VL_Menu: ^TRecMenu;
begin
  Result := 0;

  if VP_Index >= ListaMenu.Count then
  begin
    Result := -1;
    Exit;
  end;

  VL_Menu := ListaMenu[VP_Index];
  Dispose(VL_Menu);
  ListaMenu.Delete(VP_Index);
end;

procedure TMenu.Limpar;
var
  VL_Menu: ^TRecMenu;
begin
  while ListaMenu.Count > 0 do
  begin
    VL_Menu := ListaMenu[0];
    Dispose(VL_Menu);
    ListaMenu.Delete(0);
  end;

end;

function TMenu.Get(VP_Posicao: integer): TRecMenu;
var
  VL_RecMenu: ^TRecMenu;
begin
  VL_RecMenu := ListaMenu.Items[VP_Posicao];
  Result := VL_RecMenu^;

end;

function TMenu.GetTag(VP_Posicao: integer): string;
var
  VL_RecMenu: ^TRecMenu;
begin
  VL_RecMenu := ListaMenu.Items[VP_Posicao];
  Result := VL_RecMenu^.Tag;

end;

function TMenu.GetTextoBotao(VP_Posicao: integer): ansistring;
var
  VL_RecMenu: ^TRecMenu;
begin
  VL_RecMenu := ListaMenu.Items[VP_Posicao];
  Result := VL_RecMenu^.TextoBotao;

end;

function TMenu.Count: integer;
begin
  Result := ListaMenu.Count;
end;

procedure TMenu.RemovePorModuloConf(VP_ModuloConfID: integer);
var
  VL_Menu: ^TRecMenu;
  VL_Continua: boolean;
  VL_I: integer;
begin
  VL_Continua := True;

  while VL_Continua do
  begin

    if ListaMenu.Count = 0 then
      exit;

    VL_Continua := False;

    for VL_I := 0 to ListaMenu.Count - 1 do
    begin
      VL_Menu := ListaMenu.Items[VL_I];
      if VL_Menu^.ModuloConfID = VP_ModuloConfID then
      begin
        VL_Continua := True;
        ListaMenu.Remove(VL_Menu);
        Dispose(VL_Menu);
        Break;
      end;

    end;

  end;

end;

function TMenu.RetornaModuloConfId(VP_Tag: ansistring): integer;
var
  VL_Menu: ^TRecMenu;
  VL_I: integer;
begin
  Result := -1;

  if ListaMenu.Count = 0 then
    Exit;

  for VL_I := 0 to ListaMenu.Count - 1 do
  begin
    VL_Menu := ListaMenu.Items[VL_I];
    if VL_Menu^.Tag = VP_Tag then
    begin
      Result := VL_Menu^.ModuloConfID;
      Exit;
    end;
  end;

end;

function TMenu.RetornaMenu(VP_Tag: ansistring; var VO_Menu: TRecMenu): integer;
var
  VL_Menu: ^TRecMenu;
  VL_I: integer;
begin

  Result := -1;

  if ListaMenu.Count = 0 then
    Exit;

  for VL_I := 0 to ListaMenu.Count - 1 do
  begin
    VL_Menu := ListaMenu.Items[VL_I];
    if VL_Menu^.Tag = VP_Tag then
    begin
      VO_Menu := VL_Menu^;
      Result := VL_I;
      Exit;
    end;
  end;

end;

{ TThTransacao }

procedure TThTransacao.Execute;
var
  VL_Transacao: TTransacao;
  VL_Mensagem: TMensagem;
  VL_I: integer;
  VL_Tag, VL_TagDados: string;
begin
  VL_Tag := '';
  VL_TagDados := '';
  VL_Transacao := nil;
  VL_Mensagem := nil;
  try
    if V_Mensagem.ComandoDados() <> 'S' then
    begin
      V_Mensagem.Limpar;
      V_Mensagem.AddComando('0026', '62');
      DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, 3000, False, nil, V_TransmissaoID, V_Mensagem, V_Mensagem, V_Conexao_ID);
      exit;
    end;

    VL_Mensagem := TMensagem.Create;
    VL_Transacao := TTransacao.Create(V_Mensagem.Comando(), V_Terminal_Tipo, V_Doc, V_Terminal_ID, '');
    VL_Mensagem.CarregaTags(VL_Transacao.fMensagem.TagsAsString);

    for VL_I := 1 to V_Mensagem.TagCount do
    begin
      V_Mensagem.GetTag(VL_I, VL_Tag, VL_TagDados);

      case VL_Tag of
        '00A3': ;
        '0051': ;
        '00A2': ;
        '007C': ;
        '00A4': ;
        '0034':
        else
          VL_Mensagem.AddTag(VL_Tag, VL_TagDados);
      end;
      VL_Mensagem.AddComando('007A', 'R');
    end;

    DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, 3000, False, nil, V_TransmissaoID, VL_Mensagem, VL_Mensagem, V_Conexao_ID);

  finally
    if Assigned(VL_Mensagem) then
      VL_Mensagem.Free;

    if Assigned(VL_Transacao) then
      VL_Transacao.Free;
  end;
end;

constructor TThTransacao.Create(VP_Suspenso: boolean; VP_Trasmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer; VP_Terminal_Tipo: string; VP_Terminal_ID: integer; VP_Doc: string);
begin
  V_Mensagem := TMensagem.Create;
  v_Mensagem.CarregaTags(VP_Mensagem.TagsAsString);
  V_Conexao_ID := VP_Conexao_ID;
  V_TransmissaoID := VP_Trasmissao_ID;
  V_Terminal_Tipo := VP_Terminal_Tipo;
  V_Terminal_ID := VP_Terminal_ID;
  V_Doc := VP_Doc;
  FreeOnTerminate := True;

  inherited Create(VP_Suspenso);
end;

destructor TThTransacao.Destroy;
begin
  V_Mensagem.Free;
  inherited Destroy;
end;


{ TThModulo }


constructor TThModulo.Create(VP_Suspenso: boolean; VP_RegModulo: Pointer; VP_ConexaoTipo: TConexaoTipo; VP_ArquivoLog: string; VP_DNucleo: Pointer);
begin
  inherited Create(VP_Suspenso);
  VF_Sair := False;
  FreeOnTerminate := False;
  VF_RegModulo := VP_RegModulo;
  VF_DNucleo := VP_DNucleo;
  VF_Rodando := False;
  VF_ConexaoTipo := VP_ConexaoTipo;
  V_ListaTarefas := TList.Create;
  VF_ArquivoLog := VP_ArquivoLog;
end;

destructor TThModulo.Destroy;
begin
  try
    if Assigned(V_ListaTarefas) then
    begin
      V_ListaTarefas.Free;
      V_ListaTarefas := nil;
    end;
    if ((Assigned(VF_DNucleo)) and (VF_ConexaoTipo = cnServico)) then
      TDNucleo(VF_DNucleo).VF_Modulo.RemovePorModuloConf(
        TRegModulo(VF_RegModulo^).ModuloConfig_ID);
  except
    on e: Exception do
      GravaLog(F_ArquivoLog, 0,
        '', 'opentefnucleo', '111220231625', 'Erro no TThModulo.Destroy ' + e.ClassName + '/' + e.Message, '', 1, 1);

  end;

  inherited Destroy;
end;

{ TModulos }


procedure TDNucleo.DataModuleCreate(Sender: TObject);
begin
  F_BloqueiaDLL := TMultiReadExclusiveWriteSynchronizer.Create;
  VF_ListaTRegModulo := TList.Create;
  VF_Modulo := TModulo.Create;
  VF_Menu := TMenu.Create;
  VF_MenuOperacional := TMenu.Create;
  VF_DLL := TDLL.Create;
  F_NivelLog := 1;
end;

procedure TDNucleo.DataModuleDestroy(Sender: TObject);
begin
  try
    GravaLog(F_ArquivoLog, 0, 'ModuloDescarrega', 'opentefnucleo',
      '141120231641', 'comeco do  TDNucleo.DataModuleDestroy', '', 0, 3);

    VF_ListaTRegModulo.Free;
    VF_ListaTRegModulo := nil;
    VF_Modulo.Free;
    VF_Menu.Free;
    VF_MenuOperacional.Free;
    VF_DLL.Free;
    F_BloqueiaDLL.Free;

    GravaLog(F_ArquivoLog, 0, 'ModuloDescarrega', 'opentefnucleo',
      '141120231642', 'fim do TDNucleo.DataModuleDestroy', '', 0, 3);
  except
    on e: Exception do
      GravaLog(F_ArquivoLog, 0,
        '', 'opentefnucleo', '111220231627',
        'Erro no TDNucleo.DataModuleDestroy ' + e.ClassName + '/' + e.Message, '', 1, 1);

  end;
end;


procedure TDNucleo.comando(VP_Erro: integer; VP_Transmissao_ID, VP_DadosRecebidos: string; VP_Conexao_ID: integer; VP_Terminal_Tipo: string; VP_Terminal_ID: integer;
  VP_DOC: string; VP_Terminal_Status: TConexaoStatus; VP_Terminal_Identificacao: string; VP_Permissao: TPermissao; VP_ClienteIP: string);
var
  VL_Mensagem: TMensagem;
  VL_Erro: integer;
begin
  VL_Mensagem := nil;
  try
    GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '101120231255',
      'Mensagem recebida no comando', VP_DadosRecebidos, VP_Erro, 2);

    VL_Erro := 0;
    if VP_Erro <> 0 then
    begin
      GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '250820221507',
        'TDNucleo.comando, recebeu comando com erro,status do terminal: ' + IntToStr(Ord(VP_Terminal_Status)),
        VP_DadosRecebidos + ' Conexao ID: ' + IntToStr(VP_Conexao_ID),
        VP_Erro, 1);

      if VP_Erro = 96 then
        DComunicador.DesconectarClienteID(DComunicador, VP_Conexao_ID);

      Exit;
    end;


    VL_Mensagem := TMensagem.Create;

    VL_Erro := VL_Mensagem.CarregaTags(VP_DadosRecebidos);

    if VL_Erro <> 0 then
    begin
      GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '120920220842',
        'TDNucleo.comando, erro ao carregar tags', VP_DadosRecebidos,
        VL_Erro, 1);
      DComunicador.DesconectarClienteID(DComunicador, VP_Conexao_ID);
      Exit;
    end;

    case VL_Mensagem.Comando() of
      '0001': VL_Erro := comando0001(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID);
      // LOGIN
      '0021': VL_Erro := comando0021(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID);
      // PEDIDO DE CONEXÃO TROCA DE CHAVES
      '000A': VL_Erro := comando000A(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Terminal_Status, VP_Terminal_ID, VP_Terminal_Tipo, VP_DOC, VP_Terminal_Identificacao);
      // INICIA VENDA DO FRENTE DE CAIXA
      '0018': VL_Erro := comando0018(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Terminal_Status, VP_Terminal_ID);
      // SOLICITANDO OU INFOMANDO A OPÇÃO DO MENU DE VENDA
      '002B': VL_Erro := comando002B(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR MODULO
      '0039': VL_Erro := comando0039(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR LOJA
      '003F': VL_Erro := comando003F(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR LOJA
      '0044': VL_Erro := comando0044(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR PDV
      '0045': VL_Erro := comando0045(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // VALIDA CHAVE PDV
      '004B': VL_Erro := comando004B(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR PDV
      '0052': VL_Erro := comando0052(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR TAG
      '0053': VL_Erro := comando0053(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR PINPAD
      '0055': VL_Erro := comando0055(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR PINPAD
      '0057': VL_Erro := comando0057(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR CONFIGURADOR
      '0058': VL_Erro := comando0058(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR CONFIGURADOR
      '0059': VL_Erro := comando0059(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // VALIDA CHAVE CONFIGURADOR
      '0064': VL_Erro := comando0064(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR MULT-LOJA
      '0066': VL_Erro := comando0066(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR MULT-LOJA
      '0067': VL_Erro := comando0067(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR MULT-LOJA
      '0069': VL_Erro := comando0069(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR LOJA
      '006A': VL_Erro := comando006A(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR PINPAD
      '006B': VL_Erro := comando006B(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR PDV
      '0070': VL_Erro := comando0070(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID);
      // PESQUISA (TABELA EM LOTE)
      '0071': VL_Erro := comando0071(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // VALIDA CHAVE MODULO_CONF
      '0072': VL_Erro := comando0072(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR MODULO_CONF
      '0073': VL_Erro := comando0073(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR MODULO_CONF
      '0074': VL_Erro := comando0074(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR MODULO
      '0075': VL_Erro := comando0075(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR MODULO
      '0077': VL_Erro := comando0077(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR BIN
      '0078': VL_Erro := comando0078(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR BIN
      '0079': VL_Erro := comando0079(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR MODULO_CONF_FUNCAO
      '007A': VL_Erro := comando007A(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Terminal_Tipo, VP_Terminal_ID, VP_DOC);
      // TRANSACAO PARA APROVACAO AUTOMATIZADA
      '007E': VL_Erro := comando007E(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR MODULO_FUNCAO
      '007F': VL_Erro := comando007F(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR MODULO_FUNCAO
      '0085': VL_Erro := comando0085(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR MODULO_CONF_FUNCAO
      '0087': VL_Erro := comando0087(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR LOJA_MODULO_CONF_FUNCAO
      '0088': VL_Erro := comando0088(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);
      // EXCLUIR MULTILOJA_MODULO_CONF_FUNCAO
      '008A': VL_Erro := comando008A(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR MODULO_CONF_FUNCAO
      '0096': VL_Erro := comando0096(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR MULTLOJA_MODULO
      '0099': VL_Erro := comando0099(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR MULTLOJA_MODULO
      '009A': VL_Erro := comando009A(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR MULTLOJA_MODULO
      '009B': VL_Erro := comando009B(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR LOJA_MODULO_CONF_FUNCAO
      '009D': VL_Erro := comando009D(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR MULTLOJA_FUNCAO
      '009F': VL_Erro := comando009F(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR MULTLOJA_FUNCAO
      '00A0': VL_Erro := comando00A0(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR MULTLOJA_FUNCAO
      '00AA': VL_Erro := comando00AA(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR LOJA_FUNCAO
      '00AC': VL_Erro := comando00AC(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR LOJA_FUNCAO
      '00AD': VL_Erro := comando00AD(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUI LOJA_FUNCAO
      '00AE': VL_Erro := comando00AE(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR LOJA_MODULO
      '00B0': VL_Erro := comando00B0(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);
      // ALTERAR MULTILOJA_MODULO_CONF_FUNCAO
      '00B1': VL_Erro := comando00B1(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR LOJA_MODULO
      '00B2': VL_Erro := comando00B2(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR LOJA_MODULO
      '00B5': VL_Erro := comando00B5(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR PINPAD_FUNCAO
      '00B6': VL_Erro := comando00B6(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR PINPAD_FUNCAO
      '00B8': VL_Erro := comando00B8(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR PINPAD_FUNCAO
      '00B9': VL_Erro := comando00B9(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR MODULO_FUNCAO
      '00BA': VL_Erro := comando00BA(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR MODULO_CONF
      '00BB': VL_Erro := comando00BB(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR CONFIGURADOR
      '00BF': VL_Erro := comando00BF(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR LOJA_MODULO_CONF_FUNCAO
      '00C2': VL_Erro := comando00C2(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR PDV_FUNCAO
      '00C4': VL_Erro := comando00C4(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR PDV_FUNCAO
      '00C5': VL_Erro := comando00C5(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR PDV_FUNCAO
      '00C8': VL_Erro := comando00C8(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR PDV_MODULO
      '00CA': VL_Erro := comando00CA(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);
      // INCLUIR MULTILOJA_MODULO_CONF_FUNCAO
      '00CB': VL_Erro := comando00CB(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR PDV_MODULO
      '00CC': VL_Erro := comando00CC(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR PDV_MODULO
      '00DB': VL_Erro := comando00DB(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR TAG
      '00DC': VL_Erro := comando00DC(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR TAG
      '00DE': VL_Erro := comando00DE(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR ADQUIRENTE
      '00DF': VL_Erro := comando00DF(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR ADQUIRENTE
      '00E0': VL_Erro := comando00E0(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR ADQUIRENTE
      '00FA': VL_Erro := comando00FA(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);
      // INCLUIR LOJA EM MULTILOJA(GUARDA-CHUVA)
      '00FB': VL_Erro := comando00FB(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);
      // EXCLUIR LOJA EM MULTILOJA(GUARDA-CHUVA)
      '00F3': VL_Erro := comando00F4(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Terminal_Status, VP_Terminal_Tipo, VP_Terminal_ID, VP_DOC, VP_Terminal_Identificacao);
      // SOLICITA SALDO
      '00F0': VL_Erro := comando00F4(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Terminal_Status, VP_Terminal_Tipo, VP_Terminal_ID, VP_DOC, VP_Terminal_Identificacao);
      // SOLICITA MENU OPERACIONAL
      '00F4': VL_Erro := comando00F4(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Terminal_Status, VP_Terminal_Tipo, VP_Terminal_ID, VP_DOC, VP_Terminal_Identificacao);
      // EXECUTAR MODULO
      '00F6': VL_Erro := comando00F4(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Terminal_Status, VP_Terminal_Tipo, VP_Terminal_ID, VP_DOC, VP_Terminal_Identificacao);
      // SOLICITA CANCELAMENTO DE TRANSACAO

      '0105': VL_Erro := comando0105(VP_Transmissao_ID, -1, -1, VP_Conexao_ID, -1, 0, '', VL_Mensagem.TagsAsString);
      // EXECUTA NO CLIENTE CONEXAO VINDA DIRETO NO OPENTEF

      '00F5': VL_Erro := comando00F5(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Terminal_Status, VP_Terminal_ID);
      // MENU OPERACIONAL
      '0111': VL_Erro := comando0111(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID);
      // SOLICITA CHAVE PUBLICA
      '010D': VL_Erro := comando010D(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID);
      // SOLICITA ATUALIZACAO DO TEF
      '0113': VL_Erro := comando0113(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID);
        // SOLICITA CONCILIACAO
      else
      begin
        VL_Mensagem.Limpar;
        VL_Erro := 101;
        VL_Mensagem.AddComando('0026', '101'); // retorno com erro
        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
          10000, False, nil, VP_Transmissao_ID,
          VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
        Exit;
        //DComunicador.DesconectarClienteID(DComunicador, VP_Conexao_ID);
      end;
    end;

  finally
    if Assigned(VL_Mensagem) then
      VL_Mensagem.Free;
  end;

end;

function TDNucleo.comando0021(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer): integer;
  //var
  //VL_Dados: string;
  //VL_ExpoentePublico, VL_ModuloPublico: string;
  //VL_Mensagem: TMensagem;
  //VL_AContext: TIdContext;
begin
  Result := 0;
{
    VL_Mensagem := TMensagem.Create;
    VL_Dados := '';
    VL_ModuloPublico := '';
    VL_ExpoentePublico := '';
    VL_AContext := nil;
    if not DComunicador.V_ConexaoCliente.GetSocketServidor(DComunicador,
        VP_Conexao_ID, VL_AContext) then
    begin
        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '130920221016',
            'Erro na comando0021 conexão do cliente não encontrada ', '', 99);
        Result := 99;
        Exit;
    end;

    try
        VP_Mensagem.GetTag('0023', VL_Dados);
        Result := 33;
        if TTConexao(VL_AContext.Data).Status = csDesconectado then
            Exit;
        if VL_Dados <> '' then
        begin
            VP_Mensagem.GetTag('0022', VL_TChaves.ID);
            VL_TChaves := DComunicador.V_ChavesDasConexoes.getChave((VL_TChaves.ID));
            if VL_TChaves.ID > 0 then
            begin
                TTConexao(VL_AContext.Data).setChaveComunicacao(
                    VL_TChaves.Chave_Comunicacao);
                try
                    if TTConexao(VL_AContext.Data).Aes.DecryptString(
                        VL_Dados) = 'OK' then
                    begin
                        VL_Mensagem.AddComando('0024', '');
                        VL_Mensagem.TagToStr(VL_Dados);
                        TTConexao(VL_AContext.Data).Status := csChaveado;

                        VL_Dados := VL_Mensagem.TagsAsString;

                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('00D1', VP_Transmissao_ID);
                        VL_Mensagem.AddTag('00D2', VL_Dados);

                        VL_AContext.Connection.Socket.WriteLn(VL_Mensagem.TagsAsString);
                        Exit;
                    end;
                except
                    on e: Exception do
                        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
                            '060920221730', 'Erro na comando0021 ' + e.ClassName +
                            '/' + e.Message, '', Result);
                end;
            end;
            VP_Mensagem.GetTag('0008', VL_ModuloPublico);
            VP_Mensagem.GetTag('0027', VL_ExpoentePublico);
            if VL_ExpoentePublico = '' then
            begin
                VL_Mensagem.AddComando('0026', '31');
                VL_Mensagem.TagToStr(VL_Dados);

                VL_Dados := VL_Mensagem.TagsAsString;

                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00D1', VP_Transmissao_ID);
                VL_Mensagem.AddTag('00D2', VL_Dados);


                VL_AContext.Connection.Socket.WriteLn(VL_Mensagem.TagsAsString);
                Exit;
            end;
        end;
        VL_Mensagem.limpar;
        VL_Mensagem.AddComando('0025', '');
        VP_Mensagem.GetTag('0008', VL_ModuloPublico);
        VP_Mensagem.GetTag('0027', VL_ExpoentePublico);

        TTConexao(VL_AContext.Data).setModuloPublico(VL_ModuloPublico);
        TTConexao(VL_AContext.Data).setExpoentePublico(VL_ExpoentePublico);

        VL_TChaves.Chave_Comunicacao := TTConexao(VL_AContext.Data).getChaveComunicacao;
        VL_TChaves.ID := TTConexao(VL_AContext.Data).ChaveComunicacaoIDX;

        VL_Dados := TTConexao(VL_AContext.Data).Rsa.EncryptString(
            VL_TChaves.Chave_Comunicacao);

        VL_Mensagem.AddTag('0009', VL_Dados);
        VL_Mensagem.AddTag('0022', VL_TChaves.ID);
        VL_Mensagem.AddTag('0008', TTConexao(VL_AContext.Data).ModuloPublico);
        VL_Mensagem.AddTag('0027', TTConexao(VL_AContext.Data).ExpoentePublico);
        VL_Mensagem.AddTag('0023', TTConexao(VL_AContext.Data).Aes.EncryptString('OK'));

        VL_Mensagem.TagToStr(VL_Dados);
        TTConexao(VL_AContext.Data).Status := csChaveado;

        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('00D1', VP_Transmissao_ID);
        VL_Mensagem.AddTag('00D2', VL_Dados);


        VL_AContext.Connection.Socket.WriteLn(VL_Mensagem.TagsAsString);

        Result := 0;


    finally
        VL_Mensagem.Free;
    end;
}
end;

function TDNucleo.comando0001(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer): integer;
var
  VL_ID, VL_IP, VL_TagDados, VL_Biblioteca_Versao: string;
  VL_Mensagem: TMensagem;
  VL_BancoDados: TDBancoDados;
  VL_TerminalSenha: string;
  VL_Permissao: TPermissao;
  VL_AContext, VL_AContextDuplicada: TIdContext;
  VL_VersaoAtual, VL_VersaoCliente: TVersao;
begin
  Result := 0;
  VL_TerminalSenha := '';
  VL_TagDados := '';
  VL_ID := '';
  VL_Biblioteca_Versao := '';
  VL_Permissao := pmS;
  VL_AContext := nil;
  VL_AContextDuplicada := nil;

  // verificando conexao
  if not DComunicador.V_ConexaoCliente.GetSocketServidor(DComunicador, VP_Conexao_ID, VL_AContext) then
  begin
    GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '130920221022',
      'Erro na comando0001 conexão do cliente não encontrada '
      , '', 99, 1);
    Result := 99;
    Exit;
  end;

  VL_Mensagem := TMensagem.Create;
  VL_BancoDados := TDBancoDados.Create(nil);
  try
    try
      //inicio do processo
      VP_Mensagem.GetTag('00A3', VL_ID); // TERMINAL ID
      VP_Mensagem.GetTag('0035', VL_TerminalSenha);  // terminal senha
      VP_Mensagem.GetTag('0037', VL_TagDados);    //  TIPO DE PERMISSAO DO TERMINAL
      VP_Mensagem.GetTag('0005', VL_Biblioteca_Versao); // versao da biblioteca

      VL_Permissao := StrToPermissao(VL_TagDados);  // permissao do terminal

      VL_Mensagem.AddComando('0001', 'R'); // retorno login
      VL_Mensagem.AddTag('004D', '0');  // erro

      VL_IP := TTConexao(VL_AContext.Data).ClienteIp;

      VL_BancoDados.ConsultaA.Close;
      VL_BancoDados.ConsultaA.SQL.Text :=
        'SELECT S_STATUS,S_TERMINAL,S_DOC,S_IDENTIFICADOR FROM P_VAL_TERMINAL(' + StrToSql(VL_IP, False, 40) + ',' + CLNValoresSQL(VL_ID) + ',' +
        StrToSql(VL_TerminalSenha, False, 20) + ',' + StrToSql(PermissaoToStr(VL_Permissao), False, 1) + ')';


      VL_BancoDados.ConsultaA.Open;

      if VL_BancoDados.ConsultaA.FieldByName('S_STATUS').AsInteger <> 0 then
      begin
        VL_Mensagem.AddTag('004D',
          VL_BancoDados.ConsultaA.FieldByName('S_STATUS').AsString);
        Result := VL_BancoDados.ConsultaA.FieldByName('S_STATUS').AsInteger;
        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
          3000, False, nil, VP_Transmissao_ID, VL_Mensagem,
          VL_Mensagem, VP_Conexao_ID);
        Exit;
      end;

      // BLOQUEIO DE ID DIFERENTE DO IDENTIFICADOR

      if VL_BancoDados.ConsultaA.FieldByName('S_IDENTIFICADOR').AsString <> TTConexao(VL_AContext.Data).Identificador then
      begin
        VL_Mensagem.AddComando('004D', '128');
        Result := 128;
        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, 3000, False, nil, VP_Transmissao_ID, VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
        exit;
      end;

      // bloqueando conexao duplicada pois so pode ter uma conexao acessando por terminal
      if DComunicador.V_ConexaoCliente.GetSocketServidorIdentificacao(DComunicador, VL_BancoDados.ConsultaA.FieldByName('S_TERMINAL').AsString,
        VL_BancoDados.ConsultaA.FieldByName('S_IDENTIFICADOR').AsString, VL_AContextDuplicada) then
      begin
        Result := DComunicador.DesconectarClienteID(DComunicador, TTConexao(VL_AContextDuplicada.Data).ID);

        if Result <> 0 then
        begin
          GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
            '101120231755',
            'Erro na comando0001 não foi possivel deburar a conexão duplicada ',
            '', Result, 1);
          Exit;
        end;
      end;


      TTConexao(VL_AContext.Data).Terminal_Tipo := VL_BancoDados.ConsultaA.FieldByName('S_TERMINAL').AsString;
      TTConexao(VL_AContext.Data).Permissao := VL_Permissao;
      TTConexao(VL_AContext.Data).Terminal_ID := StrToInt(VL_ID);
      TTConexao(VL_AContext.Data).DOC := VL_BancoDados.ConsultaA.FieldByName('S_DOC').AsString;

      // conferindo a versao da biblioteca

      VL_BancoDados.ConsultaA.Close;
      VL_BancoDados.ConsultaA.SQL.Text :=
        'SELECT VERSAO_TEF_LIB,VERSAO_COM_LIB FROM CONFIG';
      VL_BancoDados.ConsultaA.Open;

      if VL_BancoDados.ConsultaA.RecordCount <= 0 then
      begin
        VL_Mensagem.AddComando('004D', '104');
        Result := 104;
        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
          3000, False, nil, VP_Transmissao_ID, VL_Mensagem,
          VL_Mensagem, VP_Conexao_ID);
        exit;
      end;

      if VP_Mensagem.GetTagAsAstring('003D') = 'tef_lib' then
        VL_VersaoAtual :=
          StrToVer(VL_BancoDados.ConsultaA.FieldByName('VERSAO_TEF_LIB').AsString)
      else if VP_Mensagem.GetTagAsAstring('003D') = 'com_lib' then
        VL_VersaoAtual :=
          StrToVer(VL_BancoDados.ConsultaA.FieldByName('VERSAO_COM_LIB').AsString)
      else
        VL_VersaoAtual := StrToVer('1.0.0');

      VL_VersaoCliente := StrToVer(VL_Biblioteca_Versao);

      if CompVersao(VL_VersaoAtual, VL_VersaoCliente) = CvAtualizar then
      begin
        VL_Mensagem.AddTag('00FD', 'S'); // atualizacao obrigatoria
      end
      else if CompVersao(VL_VersaoAtual, VL_VersaoCliente) = CvDesatualizado then
      begin
        VL_Mensagem.AddTag('010A', 'S'); // atualizacao opcional
      end;

      TTConexao(VL_AContext.Data).Status := csLogado;

      GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '101120231256',
        'Mensagem enviada no comando0001', VL_Mensagem.TagsAsString, 0, 2);

      DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
        3000, False, nil, VP_Transmissao_ID, VL_Mensagem,
        VL_Mensagem, VP_Conexao_ID);
    except
      on E: Exception do
        GravaLog(F_ArquivoLog, 0, '0001', 'opentefnucleo',
          '141120231539', 'Excecao: ' + E.ClassName + '/' + E.Message, '', 1, 1);
    end;
  finally
    VL_Mensagem.Free;
    VL_BancoDados.Free;
  end;
end;


function TDNucleo.comando0018(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer; VP_Terminal_Status: TConexaoStatus; VP_Terminal_ID: integer): integer;// menu de venda
var
  VL_BancoDados: TDBancoDados;
  VL_I: integer;
begin
  Result := 0;
  VL_BancoDados := TDBancoDados.Create(nil);
  try
    try
      if VP_Terminal_Status <> csLogado then
      begin
        VP_Mensagem.AddComando('0026', '35');

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '101120231257', 'Mensagem enviada no comando0018', VP_Mensagem.TagsAsString, 0, 2);

        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, 3000, False, nil, VP_Transmissao_ID, VP_Mensagem, VP_Mensagem, VP_Conexao_ID);
        exit;
      end;

      if VP_Mensagem.ComandoDados() = 'S' then
      begin
        if VF_Menu.Count = 0 then
        begin
          VP_Mensagem.AddComando('0026', '56');

          GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '101120231258', 'Mensagem enviada no comando0018', VP_Mensagem.TagsAsString, 0, 2);

          DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, 3000, False, nil, VP_Transmissao_ID, VP_Mensagem, VP_Mensagem, VP_Conexao_ID);
          exit;
        end;

        VP_Mensagem.Limpar;
        VP_Mensagem.AddComando('0018', 'R');

        VL_BancoDados.ConsultaA.Close;
        VL_BancoDados.ConsultaA.SQL.Text :=
          'SELECT S_TAG_DADOS, S_TAG_NUMERO,S_HABILITADO ' + 'FROM P_TAG_FUNCAO(' + IntToStr(VP_Terminal_ID) + ',''MENU_PDV'')';

        VL_BancoDados.ConsultaA.Open;

        while not VL_BancoDados.ConsultaA.EOF do
        begin
          if VL_BancoDados.ConsultaA.FieldByName('S_HABILITADO').AsString = 'T' then
            VF_Menu.Add(VL_BancoDados.ConsultaA.FieldByName('S_TAG_NUMERO').AsString, VL_BancoDados.ConsultaA.FieldByName('S_TAG_DADOS').AsString, 0);

          VL_BancoDados.ConsultaA.Next;
        end;

        for vl_i := 0 to VF_Menu.Count - 1 do
        begin
          if VL_BancoDados.ConsultaA.Locate('S_TAG_NUMERO', VF_Menu.GetTag(VL_I), []) then
          begin
            if VL_BancoDados.ConsultaA.FieldByName('S_HABILITADO').AsString = 'T' then
              VP_Mensagem.AddTag(VF_Menu.GetTag(VL_I), VF_Menu.GetTextoBotao(VL_I));
          end
          else
            VP_Mensagem.AddTag(VF_Menu.GetTag(VL_I), VF_Menu.GetTextoBotao(VL_I));
        end;

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '101120231300', 'Mensagem enviada no comando0018', VP_Mensagem.TagsAsString, 0, 2);

        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, 3000, False, nil, VP_Transmissao_ID, VP_Mensagem, VP_Mensagem, VP_Conexao_ID);
      end
      else
      begin
        VP_Mensagem.Limpar;
        VP_Mensagem.AddComando('0026', '57');

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '101120231259', 'Mensagem enviada no comando0018', VP_Mensagem.TagsAsString, 0, 2);

        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, 3000, False, nil, VP_Transmissao_ID, VP_Mensagem, VP_Mensagem, VP_Conexao_ID);
        exit;
      end;

    except
      on E: Exception do
        GravaLog(F_ArquivoLog, 0, '0018', 'opentefnucleo', '141120231536', 'Excecao: ' + E.ClassName + '/' + E.Message, '', 1, 1);
    end;
  finally
    VL_BancoDados.Free;
  end;
end;

// menu de operacao
function TDNucleo.comando00F5(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer; VP_Terminal_Status: TConexaoStatus; VP_Terminal_ID: integer): integer;
var
  VL_BancoDados: TDBancoDados;
  VL_I: integer;
begin
  Result := 0;
  VL_BancoDados := TDBancoDados.Create(nil);
  try
    try
      if VP_Terminal_Status <> csLogado then
      begin
        VP_Mensagem.AddComando('0026', '35');

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
          '101120231301', 'Mensagem enviada no comando00F5',
          VP_Mensagem.TagsAsString, 0, 2);

        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
          3000, False, nil, VP_Transmissao_ID, VP_Mensagem,
          VP_Mensagem, VP_Conexao_ID);
        exit;
      end;

      if VP_Mensagem.ComandoDados() = 'S' then
      begin
        if VF_MenuOperacional.Count = 0 then
        begin
          VP_Mensagem.AddComando('0026', '56');

          GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
            '101120231302', 'Mensagem enviada no comando00F5',
            VP_Mensagem.TagsAsString, 0, 2);

          DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
            3000, False, nil, VP_Transmissao_ID, VP_Mensagem,
            VP_Mensagem, VP_Conexao_ID);
          exit;
        end;

        VP_Mensagem.Limpar;
        VP_Mensagem.AddComando('00F5', 'R');

        VL_BancoDados.ConsultaA.Close;
        VL_BancoDados.ConsultaA.SQL.Text :=
          'SELECT S_TAG_DADOS, S_TAG_NUMERO,S_HABILITADO ' + 'FROM P_TAG_FUNCAO(' + IntToStr(VP_Terminal_ID) + ',''MENU_OPERACIONAL'')';

        VL_BancoDados.ConsultaA.Open;

        while not VL_BancoDados.ConsultaA.EOF do
        begin
          if VL_BancoDados.ConsultaA.FieldByName('S_HABILITADO').AsString = 'T' then
            VF_MenuOperacional.Add(VL_BancoDados.ConsultaA.FieldByName('S_TAG_NUMERO').AsString,
              VL_BancoDados.ConsultaA.FieldByName('S_TAG_DADOS').AsString, 0);

          VL_BancoDados.ConsultaA.Next;
        end;

        for vl_i := 0 to VF_MenuOperacional.Count - 1 do
        begin
          if VL_BancoDados.ConsultaA.Locate('S_TAG_NUMERO', VF_MenuOperacional.GetTag(VL_I), []) then
          begin
            if VL_BancoDados.ConsultaA.FieldByName('S_HABILITADO').AsString = 'T' then
              VP_Mensagem.AddTag(VF_MenuOperacional.GetTag(VL_I),
                VF_MenuOperacional.GetTextoBotao(VL_I));
          end
          else
            VP_Mensagem.AddTag(VF_MenuOperacional.GetTag(VL_I),
              VF_MenuOperacional.GetTextoBotao(VL_I));
        end;

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
          '101120231303', 'Mensagem enviada no comando00F5',
          VP_Mensagem.TagsAsString, 0, 2);

        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
          3000, False, nil, VP_Transmissao_ID, VP_Mensagem,
          VP_Mensagem, VP_Conexao_ID);
      end
      else
      begin
        VP_Mensagem.Limpar;
        VP_Mensagem.AddComando('0026', '57');

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
          '101120231302', 'Mensagem enviada no comando00F5',
          VP_Mensagem.TagsAsString, 0, 2);

        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
          3000, False, nil, VP_Transmissao_ID, VP_Mensagem,
          VP_Mensagem, VP_Conexao_ID);
        exit;
      end;

    except
      on E: Exception do
        GravaLog(F_ArquivoLog, 0, '0018', 'opentefnucleo',
          '141120231540', 'Excecao: ' + E.ClassName + '/' + E.Message, '', 1, 1);
    end;
  finally
    VL_BancoDados.Free;
  end;
end;


function TDNucleo.comando007A(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer; VP_Terminal_Tipo: string; VP_Terminal_ID: integer; VP_Doc: string): integer;
var
  VL_Transacao: TThTransacao;
begin
  Result := 0;
  VL_Transacao := TThTransacao.Create(True, VP_Transmissao_ID, VP_Mensagem, VP_Conexao_ID, VP_Terminal_Tipo, VP_Terminal_ID, VP_Doc);
  VL_Transacao.Start;
end;

function TDNucleo.comando000A(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer; VP_Terminal_Status: TConexaoStatus; VP_Terminal_ID: integer;
  VP_Terminal_Tipo, VP_Doc, VP_Terminal_Identificacao: string): integer;
  // SOLICITA APROVACAO DA TRANSACAO
var
  VL_Chave00F1, VL_Mensagem, VL_Transacao: TMensagem;
  VL_BancoDados: TDBancoDados;
  VL_RecModulo: TRecModulo;
  VL_TempoEmperaComandao: int64;
  VL_String: string;
  VL_Erro: integer;
  VL_Adquirente_Identificacao: string;
  VL_Bin: string;
  VL_ChaveTransacao: string;
begin
  Result := 0;
  VL_Adquirente_Identificacao := '';
  VL_Bin := '';
  VL_ChaveTransacao := '';
  VL_TempoEmperaComandao := 0;
  VL_Transacao := TMensagem.Create;
  VL_Chave00F1 := TMensagem.Create;
  VL_Mensagem := TMensagem.Create;
  VL_BancoDados := TDBancoDados.Create(nil);
  try
    try
      VL_Erro := VL_Mensagem.CarregaTags(VP_Mensagem.TagsAsString);

      if VL_Erro <> 0 then
      begin
        GravaLog(F_ArquivoLog, 0, '.comando000A', 'opentefnucleo', '240820221056', '', '', VL_Erro, 1);
        DComunicador.DesconectarClienteID(DComunicador, VP_Conexao_ID);
        Result := VL_Erro;
        Exit;
      end;

      //testa conexão devolve erro caso nao logado
      if VP_Terminal_Status <> csLogado then
      begin
        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('000A', 'R'); // retorno
        VL_Mensagem.AddTag('004D', '35');  // resposta com erro

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '101120231304', 'Mensagem enviada no comando000A', VL_Mensagem.TagsAsString, 0, 2);

        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, 3000, False, nil, VP_Transmissao_ID, VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
        Result := 35;
        Exit;
      end;

      // começa testar os dados e solicitar os faltantes

      VL_Erro := VL_Transacao.CarregaTags(VL_Mensagem.GetTagAsAstring('007D'));

      if VL_Erro <> 0 then
      begin
        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('0026', IntToStr(VL_Erro)); // retorno com erro
        GravaLog(F_ArquivoLog, 0, '.comando000A', 'opentefnucleo', '260820220853', '', '', VL_Erro, 1);

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '101120231305', 'Mensagem enviada no comando000A', VL_Mensagem.TagsAsString, 0, 2);

        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID, VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
        Result := VL_Erro;
        Exit;
      end;

      VL_Mensagem.GetTag('0051', VL_TempoEmperaComandao);       // TEMPO DO COMANDO
      if VL_TempoEmperaComandao = 0 then
        VL_Transacao.GetTag('0051', VL_TempoEmperaComandao);
      if VL_TempoEmperaComandao = 0 then
        VL_TempoEmperaComandao := 30000;

      VL_Bin := VL_Transacao.GetTagAsAstring('0036');  // carrega bin
      VL_Adquirente_Identificacao := VL_Transacao.GetTagAsAstring('0109'); // carrega identificacao do adquirente

      if (VL_Transacao.GetTagAsAstring('00F1') <> '') and (VL_Transacao.GetTagAsAstring('00F1') <> #1) then // verifica se possui a chave da transacao
      begin
        VL_ChaveTransacao := VL_Mensagem.GetTagAsAstring('00F1').Trim; // eliminando espacos e formatacoes para nao ocorrer erros

        VL_Erro := VL_Chave00F1.CarregaTags(VL_ChaveTransacao); // carregando a chave como mensagem estruturada

        if VL_Erro <> 0 then
        begin
          VL_Mensagem.AddComando('000A', 'R'); // retorno
          VL_Mensagem.AddTag('004D', VL_Erro);  // retorno com erro
          Result := VL_Erro;
          GravaLog(F_ArquivoLog, 0, '.comando000A', 'opentefnucleo', '060920221622', '', '', VL_Erro, 1);

          GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '101120231306', 'Mensagem enviada no comando000A', VL_Mensagem.TagsAsString, 0, 2);

          DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID, VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
          Exit;
        end;

        if VL_Bin = '' then
          VL_Bin := VL_Chave00F1.GetTagAsAstring('0036');  // carrega bin

        if VL_Adquirente_Identificacao = '' then
          VL_Adquirente_Identificacao := VL_Chave00F1.GetTagAsAstring('0109'); // carrega identificacao do adquirente
      end;

      //verifica se tem o bin ou identificacao do adquirente, para mandar para a operadora
      if ((VL_Bin = '') and (VL_Transacao.GetTagAsAstring('00D5') = '') and (VL_Transacao.GetTagAsAstring('0109') = '')) then
        //NAO TEM BIN E NÃO TEM BOTAO SELECIONAO E NÃO TEM IDENTIFICACAO DO ADQUIRENTE
      begin
        // mostra menu venda
        VL_Mensagem.AddComando('0018', 'S');
        comando0018(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Terminal_Status, VP_Terminal_ID);
        Exit;
      end;

      //NAO TEM BIN NAO TEM IDENTIFICACAO DO ADQUIRENTE E VEIO TRILHA 2
      if ((VL_Bin = '') and (VL_Adquirente_Identificacao = '') and (VL_Transacao.GetTagAsAstring('004F') <> '')) then
      begin
        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('008C', 'S'); // solicita atualizacao da tag
        VL_Mensagem.AddTag('011A', VL_Transacao.GetTagAsAstring('004F'));
        // pan digitado pelo pinpad
        // pan
        VL_Mensagem.AddTag('0062', '0000' + Copy(VL_Transacao.GetTagAsAstring('004F'), 7, 12));  //pan mascarado
        VL_Mensagem.AddTag('0036',
          Copy(VL_Transacao.GetTagAsAstring('004F'), 1, 6));
        //bin

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
          '101120231307', 'Mensagem enviada no comando000A',
          VL_Mensagem.TagsAsString, 0, 2);

        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
          VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
          VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
        Exit;

      end;

      //NAO TEM BIN NAO TEM IDENTIFICACAO DO ADQUIRENTE E SELECIONOU UMA OPÇÃO
      if ((VL_Bin = '') and (VL_Adquirente_Identificacao = '') and (VL_Transacao.GetTagAsAstring('00D5') <> '')) then
      begin
        if VL_Transacao.GetTagAsAstring('00D5') = '001D' then
          // LEITURA DE CARTAO
        begin
          VL_Mensagem.Limpar;
          VL_Mensagem.AddComando('0048', 'S'); // PINPAD SOLICITA TARJA CARTÃO
          VL_Mensagem.AddTag('0051', '300000');  // TEMPO DE ESPERA DO COMANDO

          GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '101120231308', 'Mensagem enviada no comando000A', VL_Mensagem.TagsAsString, 0, 2);

          DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID, VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
          Exit;
        end
        else
        if VL_Transacao.GetTagAsAstring('00D5') = '0019' then
          // OPCAO DE CARTAO DIGITADO
        begin
          VL_Mensagem.Limpar;

          // INFORMA OS BOTOES DENTRO DA TAG DE COMANDO DO BOTAO 0018

          VL_Mensagem.AddComando('0000', 'S');
          VL_Mensagem.AddTag('00E7', 'OK'); //BOTAO PERSONALIZADO PARA IDENTIFICAR CARTÃO DIGITADO
          VL_String := VL_Mensagem.TagsAsString; //converte em string a mensagem
          VL_Mensagem.Limpar;
          VL_Mensagem.AddComando('002A', 'S');   //solicita dados pdv
          VL_Mensagem.AddTag('00DA', 'DIGITE O CARTÃO'); //MENSAGEM A SER MOSTRADA
          VL_Mensagem.AddTag('00DD', VL_String);    //BOTOES A MOSTRAR
          VL_Mensagem.AddTag('0033', 'A');    //campo para capturar sem mascara

          GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '101120231309', 'Mensagem enviada no comando000A', VL_Mensagem.TagsAsString, 0, 2);

          DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID, VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
          Exit;
        end
        else
        if VL_Transacao.GetTagAsAstring('00D5') = '0112' then
          // OPCAO DE PAGAMENTO PIX
        begin
          VL_Mensagem.Limpar;

          // INFORMA OS BOTOES DENTRO DA TAG DE COMANDO DO BOTAO 0018

          VL_Mensagem.AddComando('0000', 'S');
          VL_Mensagem.AddTag('00E7', 'OK');
          //BOTAO PERSONALIZADO PARA IDENTIFICAR CARTÃO DIGITADO
          VL_String := VL_Mensagem.TagsAsString;
          //converte em string a mensagem
          VL_Mensagem.Limpar;
          VL_Mensagem.AddComando('002A', 'S');   //solicita dados pdv
          VL_Mensagem.AddTag('00DA', 'DIGITE O CARTÃO');
          //MENSAGEM A SER MOSTRADA
          VL_Mensagem.AddTag('00DD', VL_String);    //BOTOES A MOSTRAR
          VL_Mensagem.AddTag('0033', 'A');    //campo para capturar sem mascara

          GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '101120231310', 'Mensagem enviada no comando000A', VL_Mensagem.TagsAsString, 0, 2);

          DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID, VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
          Exit;
        end
        else
        if VL_Transacao.GetTagAsAstring('00D5') = '00E7' then // RETONRO OPCAO DE CARTAO DIGITADO
        begin
          VL_Mensagem.Limpar;
          VL_Mensagem.AddComando('008C', 'S');  // solicita atualizacao da tag
          VL_Mensagem.AddTag('00D9', VL_Transacao.GetTagAsAstring('0033')); // pan
          VL_Mensagem.AddTag('0062', '0000' + Copy(VL_Transacao.GetTagAsAstring('0033'), 7, 12));  //pan mascarado
          VL_Mensagem.AddTag('0036', Copy(VL_Transacao.GetTagAsAstring('0033'), 1, 6)); //bin

          GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '101120231311', 'Mensagem enviada no comando000A', VL_Mensagem.TagsAsString, 0, 2);

          DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID, VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
          Exit;

        end;


      end;

      // tenta mandar a mensagem para o modulo ativo

      if (VL_Adquirente_Identificacao <> '') then
        // tem identificacao do adquirente então tenta localizar o modulo
      begin
        VL_Mensagem.AddComando('000A', 'S'); // retorno do comando para pdv
        VL_Mensagem.AddTag('007D', VL_Transacao.TagsAsString); // TRANSACAO
        VL_Erro := DNucleo.ModuloAddSolicitacaoIdentificacaoAdquirente(VP_Conexao_ID, VP_Transmissao_ID, VL_TempoEmperaComandao, VL_Adquirente_Identificacao, VL_Mensagem, cnCaixa);

        if VL_Erro <> 0 then
        begin
          VL_Mensagem.AddComando('00F4', 'R');  // retorno
          VL_Mensagem.AddTag('004D', VL_Erro); // retorno com erro
          Result := VL_Erro;
          GravaLog(F_ArquivoLog, 0, '.comando000A', 'opentefnucleo', '290820220834', '', '', VL_Erro, 1);

          GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '101120231312', 'Mensagem enviada no comando000A', VL_Mensagem.TagsAsString, 0, 2);

          DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
            VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
            VL_Mensagem, VL_Mensagem, VP_Conexao_ID);

        end;
        Exit;
      end;

      if (VL_Bin <> '') then // tem bin então tenta localizar o modulo
      begin
        VL_RecModulo := VF_Modulo.RetornaModulo(VL_Bin,'');
        if VL_RecModulo.ModuloConfID = -1 then
          //MODULO NAO CARREGADO PARA ESSE BIN
        begin
          VL_Mensagem.AddComando('000A', 'R');  // retorno
          VL_Mensagem.AddTag('004D', 79); // resposta com erro

          GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '101120231313', 'Mensagem enviada no comando000A', VL_Mensagem.TagsAsString, 0, 2);

          DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
            VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
            VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
          Result := 79;
          Exit;
        end;

        if VP_Terminal_Tipo = 'PDV' then
          // CONEXAO NÃO É DO PDV E NÃO PODE FAZER VENDA
        begin
          // VERIFICA SE ESSE PDV TEM O MODULO_CONF LIBERADO NA LOJA
          VL_BancoDados.ConsultaA.Close;
          VL_BancoDados.ConsultaA.SQL.Text :=
            'SELECT S_HABILITADO,S_TAG_NUMERO,S_LOJA_CODIGO, S_PDV_CODIGO FROM P_TAG_FUNCAO(' + StrToSql(IntToStr(VP_Terminal_ID)) + ',''MODULO'')' +
            ' WHERE S_HABILITADO=''T'' AND S_TAG_NUMERO=''' + VL_RecModulo.ModuloTag + '''';
          VL_BancoDados.ConsultaA.Open;

          if VL_BancoDados.ConsultaA.FieldByName('S_HABILITADO').AsString <> 'T' then
          begin
            VL_Mensagem.AddComando('000A', 'R'); // retorno
            VL_Mensagem.AddTag('004D', 133);  // resposta com erro
            Result := 133;

            GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '101120231314', 'Mensagem enviada no comando000A', VL_Mensagem.TagsAsString, 133, 2);

            DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID, VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
            Exit;
          end;

          // verifica se ja tem chave
          if VL_Transacao.GetTagAsAstring('00F1') = '' then
          begin
            VL_Chave00F1.AddComando('0000', '');
            VL_Chave00F1.AddTag('00F2', VL_RecModulo.ModuloTag); // tag do modulo
            VL_Chave00F1.AddTag('0036', VL_RecModulo.IIN);   // bin
            VL_Chave00F1.AddTag('0034', VL_Transacao.GetTagAsAstring('0034'));// id da transacao
            VL_Chave00F1.AddTag('0091', VP_Doc);  // documento(cpf ou cnpj)
            VL_Chave00F1.AddTag('00F9', VL_BancoDados.ConsultaA.FieldByName('S_LOJA_CODIGO').AsString); // codigo da loja
            VL_Chave00F1.AddTag('0107', VL_BancoDados.ConsultaA.FieldByName('S_PDV_CODIGO').AsString);// codigo do pdv
            VL_Chave00F1.AddTag('0108', VP_Terminal_Identificacao);// identificacao do caixa, configurador, gerenciado
            VL_Chave00F1.AddTag('00A2', 'PDV'); // tipo do terminal

            VL_Transacao.AddTag('00F1', VL_Chave00F1.TagsAsString);

            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('008C', 'S');
            // solicita atualizacao da tag
            VL_Mensagem.AddTag('00F1', VL_Chave00F1.TagsAsString);
            VL_Mensagem.AddTag('011B', ''); // SOLICITA O MODELO DO PINPAD A SER PREENCHIDO PELO TEF

            GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
              '101120231315', 'Mensagem enviada no comando000A',
              VL_Mensagem.TagsAsString, 0, 2);

            DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID, VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
            Exit;

          end;


          VL_Mensagem.AddComando('000A', 'S');   // solicita aprovacao
          VL_Mensagem.AddTag('007D', VL_Transacao.TagsAsString);// TRANSACAO

          GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '101120231316', 'Mensagem enviada no comando000A', VL_Mensagem.TagsAsString, 0, 2);

          VL_Erro := DNucleo.ModuloAddSolicitacao(VP_Conexao_ID, VP_Transmissao_ID, VL_TempoEmperaComandao, VL_RecModulo.ModuloConfID, VL_Mensagem, cnCaixa);

          if VL_Erro <> 0 then
          begin
            VL_Mensagem.AddComando('000A', 'R'); // retorno
            VL_Mensagem.AddTag('004D', VL_Erro); // retorno com erro
            Result := VL_Erro;
            GravaLog(F_ArquivoLog, 0, '.comando000A', 'opentefnucleo', '260820220854', '', '', VL_Erro, 1);

            GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '101120231317', 'Mensagem enviada no comando000A', VL_Mensagem.TagsAsString, 0, 2);

            DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID, VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
            Exit;
          end;

          Exit;
        end;
      end
      else
      begin
        VL_Mensagem.AddComando('000A', 'R');
        VL_Mensagem.AddTag('004D', 81);
        Result := 81;

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '101120231318', 'Mensagem enviada no comando000A', VL_Mensagem.TagsAsString, 0, 2);

        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID, VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
        Exit;
      end;

      VL_Mensagem.AddComando('000A', 'R'); // retorno
      VL_Mensagem.AddTag('004D', 80);  // retorno com erro
      Result := 80;

      GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '101120231319', 'Mensagem enviada no comando000A', VL_Mensagem.TagsAsString, 0, 2);

      DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,VP_Mensagem, VP_Mensagem, VP_Conexao_ID);

    except
      on E: Exception do
        GravaLog(F_ArquivoLog, 0, '000A', 'opentefnucleo', '141120231637', 'Excecao: ' + E.ClassName + '/' + E.Message, '', 1, 1);
    end;
  finally
    VL_Transacao.Free;
    VL_Chave00F1.Free;
    VL_Mensagem.Free;
    VL_BancoDados.Free;
  end;
end;

function TDNucleo.comando0113(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer): integer;
  // SOLICITA CONCILIACAO
var
  VL_Mensagem, VL_TagConciliacao, VL_TagLinha, VL_Transacao, VL_Chave00F1: TMensagem;
  VL_BancoDados: TDBancoDados;
  VL_Erro, VL_I: integer;
  VL_Bin: string;
  VL_RecModulo: TRecModulo;
  VL_AContext: TIdContext;
  VL_TConciliacao: TConciliacao;
  VL_DadosSolicitacao, VL_VersaoConciliacao: ansistring;
  VL_Transacao_ID: ansistring;
begin
  Result := 0;
  VL_AContext := nil;
  VL_DadosSolicitacao := '';
  VL_VersaoConciliacao := '';
  VL_Transacao_ID := '';
  VL_Mensagem := TMensagem.Create;
  VL_TagConciliacao := TMensagem.Create;
  VL_TagLinha := TMensagem.Create;
  VL_Transacao := TMensagem.Create;
  VL_Chave00F1 := TMensagem.Create;
  VL_TConciliacao := TConciliacao.Create(VP_Transmissao_ID, VP_Conexao_ID);
  VL_BancoDados := TDBancoDados.Create(nil);
  try
    try
      // verificando conexao
      if not DComunicador.V_ConexaoCliente.GetSocketServidor(DComunicador, VP_Conexao_ID, VL_AContext) then
      begin
        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '130920221022',
          'Erro na comando0113 conexão do cliente não encontrada '
          , '', 99, 1);
        Result := 99;

        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('0113', 'R'); // retorno
        VL_Mensagem.AddTag('004D', '99');  // resposta com erro

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
          '221120230825', 'Mensagem enviada no comando0113',
          VL_Mensagem.TagsAsString, 0, 2);

        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
          3000, False, nil, VP_Transmissao_ID, VL_Mensagem,
          VL_Mensagem, VP_Conexao_ID);
        Result := 99;
        Exit;
      end;

      //testa conexão devolve erro caso nao logado
      if TTConexao(VL_AContext.Data).Status <> csLogado then
      begin
        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '221120230826',
          'Erro na comando0113 conexao nao esta logada '
          , '', 99, 1);

        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('0113', 'R'); // retorno
        VL_Mensagem.AddTag('004D', '35');  // resposta com erro

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
          '211120231544', 'Mensagem enviada no comando0113',
          VL_Mensagem.TagsAsString, 0, 2);

        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
          3000, False, nil, VP_Transmissao_ID, VL_Mensagem,
          VL_Mensagem, VP_Conexao_ID);
        Result := 35;
        Exit;
      end;

      if TTConexao(VL_AContext.Data).Terminal_Tipo <> 'PDV' then
      begin
        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '221120230827',
          'Erro na comando0113 conexao nao e do tipo PDV '
          , '', 122, 1);

        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('0113', 'R'); // retorno
        VL_Mensagem.AddTag('004D', '122');  // resposta com erro

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
          '211120231654', 'Mensagem enviada no comando0113',
          VL_Mensagem.TagsAsString, 0, 2);

        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
          3000, False, nil, VP_Transmissao_ID, VL_Mensagem,
          VL_Mensagem, VP_Conexao_ID);
        Result := 122;
        Exit;
      end;

      VL_Erro := VL_Mensagem.CarregaTags(VP_Mensagem.TagsAsString);

      if VL_Erro <> 0 then
      begin
        GravaLog(F_ArquivoLog, 0, '.comando0113', 'opentefnucleo',
          '211120231543', '', '', VL_Erro, 1);
        Result := VL_Erro;

        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('0113', 'R'); // retorno
        VL_Mensagem.AddTag('004D', IntToStr(Result));  // resposta com erro

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
          '221120230828', 'Mensagem enviada no comando0113',
          VL_Mensagem.TagsAsString, 0, 2);

        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
          3000, False, nil, VP_Transmissao_ID, VL_Mensagem,
          VL_Mensagem, VP_Conexao_ID);
        Exit;
      end;

      VL_Erro := VL_Transacao.CarregaTags(VL_Mensagem.GetTagAsAstring('007D'));

      if VL_Erro <> 0 then
      begin
        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('0026', IntToStr(VL_Erro)); // retorno com erro
        GravaLog(F_ArquivoLog, 0, '.comando0113', 'opentefnucleo',
          '221120231631', '', '', VL_Erro, 1);

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
          '221120231632', 'Mensagem enviada no comando000A',
          VL_Mensagem.TagsAsString, 0, 2);

        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
          3000, False, nil, VP_Transmissao_ID,
          VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
        Result := VL_Erro;
        Exit;
      end;

      VL_Transacao.GetTag('0117', VL_DadosSolicitacao); // dados da conciliacao
      VL_Transacao.GetTag('0034', VL_Transacao_ID);  // transacao_id
      VL_Transacao.GetTag('0114', VL_VersaoConciliacao); // versao da conciliacao

      if ((VL_DadosSolicitacao = '') or (VL_VersaoConciliacao = '')) then
      begin
        VL_Mensagem.AddComando('00E1', 'S'); // solicita dados da transacao
        VL_Mensagem.AddTag('0117', ''); // dados da conciliacao
        VL_Mensagem.AddTag('0114', ''); // versao da conciliacao

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
          '221120231611', 'Mensagem enviada no comando0113',
          VL_Mensagem.TagsAsString, 0, 2);

        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
          3000, False, nil, VP_Transmissao_ID, VL_Mensagem,
          VL_Mensagem, VP_Conexao_ID);
        Exit;
      end
      else if VL_DadosSolicitacao = #1 then
      begin
        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('0113', 'R'); // retorno
        VL_Mensagem.AddTag('004D', '1');  // resposta com erro

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
          '221120231615', 'Mensagem enviada no comando0113',
          VL_Mensagem.TagsAsString, 0, 2);

        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
          3000, False, nil, VP_Transmissao_ID, VL_Mensagem,
          VL_Mensagem, VP_Conexao_ID);
        Result := 1;
        Exit;
      end
      else if VL_VersaoConciliacao = #1 then
      begin
        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('0113', 'R'); // retorno
        VL_Mensagem.AddTag('004D', '1');  // resposta com erro

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
          '241120231316', 'Mensagem enviada no comando0113',
          VL_Mensagem.TagsAsString, 0, 2);

        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
          3000, False, nil, VP_Transmissao_ID, VL_Mensagem,
          VL_Mensagem, VP_Conexao_ID);
        Result := 1;
        Exit;
      end;

      VL_Erro := VL_TagConciliacao.CarregaTags(VL_DadosSolicitacao);
      // CARREGA TABELA DE CONCILIACAO

      if VL_Erro <> 0 then
      begin
        GravaLog(F_ArquivoLog, 0, '.comando0113', 'opentefnucleo',
          '211120231629', 'Erro ao carregar a tag de conciliacao',
          '', VL_Erro, 1);
        Result := VL_Erro;

        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('0113', 'R'); // retorno
        VL_Mensagem.AddTag('004D', IntToStr(Result));  // resposta com erro

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
          '221120230831', 'Mensagem enviada no comando0113',
          VL_Mensagem.TagsAsString, 0, 2);

        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
          3000, False, nil, VP_Transmissao_ID, VL_Mensagem,
          VL_Mensagem, VP_Conexao_ID);
        Exit;
      end;

      // verifica se ja tem chave
      if VL_Transacao.GetTagAsAstring('00F1') = '' then
      begin
        VL_Chave00F1.AddComando('0000', '');
        VL_Chave00F1.AddTag('00F2', ''); // tag do modulo
        VL_Chave00F1.AddTag('0036', '');   // bin
        VL_Chave00F1.AddTag('0034', VL_Transacao_ID); // id da transacao
        VL_Chave00F1.AddTag('0091', TTConexao(VL_AContext.Data).DOC);
        // documento(cpf ou cnpj)
        VL_Chave00F1.AddTag('00F9', '');
        VL_Chave00F1.AddTag('0107', ''); // codigo do pdv
        VL_Chave00F1.AddTag('0108', TTConexao(VL_AContext.Data).Identificador);
        // identificacao do caixa, configurador, gerenciado
        VL_Chave00F1.AddTag('00A2', 'PDV'); // tipo do terminal

        VL_Transacao.AddTag('00F1', VL_Chave00F1.TagsAsString);

        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('008C', 'S');
        // solicita atualizacao da tag
        VL_Mensagem.AddTag('00F1', VL_Chave00F1.TagsAsString);

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
          '101120231315', 'Mensagem enviada no comando000A',
          VL_Mensagem.TagsAsString, 0, 2);

        DComunicador.ServidorTransmiteSolicitacaoID(
          DComunicador, 30000, False, nil, VP_Transmissao_ID,
          VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
        Exit;

      end;

      // CARREGANDO OS MODULOS VALIDOS

      VL_BancoDados.ConsultaA.Close;
      VL_BancoDados.ConsultaA.SQL.Text :=
        'SELECT S_TAG_NUMERO,S_HABILITADO,S_LOJA_CODIGO FROM ' + ' P_TAG_FUNCAO(' + IntToSql(TTConexao(VL_AContext.Data).Terminal_ID) + ',' + ' ''MODULO'') WHERE S_HABILITADO = ''T'' ';
      VL_BancoDados.ConsultaA.Open;

      if VL_BancoDados.ConsultaA.RecordCount <= 0 then
      begin
        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('0113', 'R'); // retorno
        VL_Mensagem.AddTag('004D', '79');  // resposta com erro

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
          '211120231656', 'Mensagem enviada no comando0113',
          VL_Mensagem.TagsAsString, 0, 2);

        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
          3000, False, nil, VP_Transmissao_ID, VL_Mensagem,
          VL_Mensagem, VP_Conexao_ID);
        Result := 79;
        Exit;
      end;

      // montando estrutura de dados

      for VL_I := 1 to VL_TagConciliacao.GetTagAsInteger('0119') do
        // quantidade de linha
      begin
        VL_TagConciliacao.GetTagTabelaPosicao(VL_I, '0036', VL_Bin); // bin
        copiaTagPosicao(VL_I, VL_TagConciliacao, VL_TagLinha);
        // copiando os dados dessa linha
        VL_TagLinha.AddTag('007D', VL_Transacao.TagsAsString);
        // dados da transacao
        VL_TagLinha.AddTag('0114', VL_VersaoConciliacao);
        // versao da conciliacao

        if VL_Bin = '' then // enviar para todas as operadoras
        begin
          VL_BancoDados.ConsultaA.First;

          while not VL_BancoDados.ConsultaA.EOF do
          begin
            VL_RecModulo := VF_Modulo.RetornaBINPorTag(VL_BancoDados.ConsultaA.FieldByName('S_TAG_NUMERO').AsString);

            if VL_RecModulo.ModuloConfID = -1 then
              //MODULO NAO CARREGADO PARA ESSE BIN
            begin
              Result := 79;
              GravaLog(F_ArquivoLog, 0, '.comando0113', 'opentefnucleo',
                '221120231531', 'Não foi encontrado o modulo deste bin',
                '', Result, 1);

              VL_Mensagem.Limpar;
              VL_Mensagem.AddComando('0113', 'R'); // retorno
              VL_Mensagem.AddTag('004D', IntToStr(Result));
              // resposta com erro

              GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
                '221120231532', 'Mensagem enviada no comando0113',
                VL_Mensagem.TagsAsString, 0, 2);

              DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
                3000, False, nil, VP_Transmissao_ID,
                VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
              Exit;
            end;

            VL_TagLinha.AddTag('00F9',
              VL_BancoDados.ConsultaA.FieldByName('S_LOJA_CODIGO').AsLargeInt);
            // codigo do comercio para adquirente

            Result :=
              VL_TConciliacao.add(VL_RecModulo, VL_Transacao_ID, VL_TagLinha.TagsAsString);

            if Result <> 0 then
            begin
              GravaLog(F_ArquivoLog, 0, '.comando0113', 'opentefnucleo',
                '221120231533',
                'Erro ao montar estrutura de dados da conciliacao', '', Result, 1);

              VL_Mensagem.Limpar;
              VL_Mensagem.AddComando('0113', 'R'); // retorno
              VL_Mensagem.AddTag('004D', IntToStr(Result));
              // resposta com erro

              GravaLog(F_ArquivoLog, 0, VL_Transacao_ID,
                'opentefnucleo', '221120231534', 'Mensagem enviada no comando0113',
                VL_Mensagem.TagsAsString, 0, 2);

              DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
                3000, False, nil, VP_Transmissao_ID,
                VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
              Exit;
            end;

            VL_BancoDados.ConsultaA.Next;
          end;
        end
        else // enviar para operadora especifica
        begin
          VL_RecModulo := VF_Modulo.RetornaModulo(VL_Bin,'');

          if VL_RecModulo.ModuloConfID = -1 then
            //MODULO NAO CARREGADO PARA ESSE BIN
          begin
            Result := 79;
            GravaLog(F_ArquivoLog, 0, '.comando0113', 'opentefnucleo',
              '221120231527', 'Não foi encontrado o modulo deste bin',
              '', Result, 1);

            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('0113', 'R'); // retorno
            VL_Mensagem.AddTag('004D', IntToStr(Result));
            // resposta com erro

            GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
              '221120231528', 'Mensagem enviada no comando0113',
              VL_Mensagem.TagsAsString, 0, 2);

            DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
              3000, False, nil, VP_Transmissao_ID,
              VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
            Exit;
          end;

          if not VL_BancoDados.ConsultaA.Locate('S_TAG_NUMERO', VL_RecModulo.ModuloTag, []) then // VERIFICA SE O PDV TEM ACESSO A ESTE MODULO
          begin
            Result := 79;
            GravaLog(F_ArquivoLog, 0, '.comando0113', 'opentefnucleo',
              '221120231529', 'o pdv não tem permissao para este modulo',
              '', Result, 1);

            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('0113', 'R'); // retorno
            VL_Mensagem.AddTag('004D', IntToStr(Result));
            // resposta com erro

            GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
              '221120231530', 'Mensagem enviada no comando0113',
              VL_Mensagem.TagsAsString, 0, 2);

            DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
              3000, False, nil, VP_Transmissao_ID,
              VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
            Exit;
          end;

          VL_TagLinha.AddTag('00F9',
            VL_BancoDados.ConsultaA.FieldByName('S_LOJA_CODIGO').AsLargeInt);
          // codigo do comercio para adquirente

          Result := VL_TConciliacao.add(VL_RecModulo, VL_Transacao_ID, VL_TagLinha.TagsAsString);

          if Result <> 0 then
          begin
            GravaLog(F_ArquivoLog, 0, '.comando0113', 'opentefnucleo',
              '221120231526',
              'Erro ao montar estrutura de dados da conciliacao', '', Result, 1);

            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('0113', 'R'); // retorno
            VL_Mensagem.AddTag('004D', IntToStr(Result));
            // resposta com erro

            GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
              '221120231527', 'Mensagem enviada no comando0113',
              VL_Mensagem.TagsAsString, 0, 2);

            DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
              3000, False, nil, VP_Transmissao_ID,
              VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
            Exit;
          end;
        end;
      end;

      VL_Mensagem.Limpar;
      VL_Mensagem.AddComando('0113', 'R'); // retorno
      VL_Mensagem.AddTag('0117', VL_TConciliacao.consultar);
      // dados da conciliacao

      GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '221120231753',
        'Mensagem enviada no comando0113', VL_Mensagem.TagsAsString, 0, 2);

      DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
        3000, False, nil, VP_Transmissao_ID, VL_Mensagem,
        VL_Mensagem, VP_Conexao_ID);
      Exit;

    except
      on E: Exception do
        GravaLog(F_ArquivoLog, 0, 'comando0113', 'opentefnucleo',
          '211120231545', 'Excecao: ' + E.ClassName + '/' + E.Message, '', 1, 1);
    end;
  finally
    VL_BancoDados.Free;
    VL_Mensagem.Free;
    VL_TagConciliacao.Free;
    VL_TConciliacao.Free;
    VL_TagLinha.Free;
    VL_Transacao.Free;
    VL_Chave00F1.Free;
  end;
end;

function TDNucleo.comando00F4(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer; VP_Terminal_Status: TConexaoStatus;
  VP_Terminal_Tipo: string; VP_Terminal_ID: integer; VP_Doc, VP_Terminal_Identificacao: string): integer;
  // EXECUTAR MODULO
var
  VL_Chave00F1, VL_Transacao, VL_Mensagem: TMensagem;
  VL_BancoDados: TDBancoDados;
  VL_RecModulo: TRecModulo;
  VL_TempoEmperaComandao: int64;
  VL_String: string;
  VL_ChaveTransacao: string;
  VL_Bin: string;
  VL_Erro: integer;
  VL_Adquirente_Identificacao: string;
begin
  Result := 0;
  VL_TempoEmperaComandao := 0;
  VL_ChaveTransacao := '';
  VL_Bin := '';
  VL_Adquirente_Identificacao := '';
  VL_Transacao := nil;
  VL_Chave00F1 := nil;
  VL_Mensagem := nil;
  try
    try
      VL_Transacao := TMensagem.Create;
      VL_Chave00F1 := TMensagem.Create;
      VL_Mensagem := TMensagem.Create;
      VL_Erro := VL_Mensagem.CarregaTags(VP_Mensagem.TagsAsString);

      if VL_Erro <> 0 then
      begin
        GravaLog(F_ArquivoLog, 0, '.comando00F4', 'opentefnucleo',
          '240820221028', '', '', VL_Erro, 1);
        Result := VL_Erro;
        DComunicador.DesconectarClienteID(DComunicador, VP_Conexao_ID);
        Exit;
      end;
      VL_BancoDados := TDBancoDados.Create(nil);
      //testa conexão devolve erro caso nao logado
      if VP_Terminal_Status <> csLogado then
      begin
        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('00F4', 'R'); // retorno
        VL_Mensagem.AddTag('004D', '35'); // retorno com erro

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
          '101120231320', 'Mensagem enviada no comando00F4',
          VL_Mensagem.TagsAsString, 0, 1);

        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
          3000, False, nil, VP_Transmissao_ID, VL_Mensagem,
          VL_Mensagem, VP_Conexao_ID);
        Exit;
      end;

      // começa testar os dados e solicitar os faltantes
      VL_Erro := VL_Transacao.CarregaTags(VL_Mensagem.GetTagAsAstring('007D'));

      if VL_Erro <> 0 then
      begin
        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('0026', IntToStr(VL_Erro)); // retorno com erro
        Result := VL_Erro;
        GravaLog(F_ArquivoLog, 0, '.comando00F4', 'opentefnucleo',
          '260820220848', '', '', VL_Erro, 1);

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
          '101120231321', 'Mensagem enviada no comando00F4',
          VL_Mensagem.TagsAsString, 0, 2);

        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
          VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
          VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
        Exit;
      end;

      VL_Mensagem.GetTag('0051', VL_TempoEmperaComandao);       // TEMPO DO COMANDO
      if VL_TempoEmperaComandao = 0 then
        VL_Transacao.GetTag('0051', VL_TempoEmperaComandao);
      if VL_TempoEmperaComandao = 0 then
        VL_TempoEmperaComandao := 30000;

      VL_Bin := VL_Transacao.GetTagAsAstring('0036');  // carrega bin
      VL_Adquirente_Identificacao := VL_Transacao.GetTagAsAstring('0109');
      // carrega identificacao do adquirente

      if (VL_Transacao.GetTagAsAstring('00F1') <> '') and (VL_Transacao.GetTagAsAstring('00F1') <> #1) then
        // verifica se possui a chave da transacao
      begin
        VL_ChaveTransacao := VL_Mensagem.GetTagAsAstring('00F1').Trim;
        // eliminando espacos e formatacoes para nao ocorrer erros

        VL_Erro := VL_Chave00F1.CarregaTags(VL_ChaveTransacao);
        // carregando a chave como mensagem estruturada

        if VL_Erro <> 0 then
        begin
          VL_Mensagem.AddComando('00F4', 'R'); // retorno
          VL_Mensagem.AddTag('004D', VL_Erro);  // retorno com erro
          Result := VL_Erro;
          GravaLog(F_ArquivoLog, 0, '.comando00F4', 'opentefnucleo',
            '060920221623', '', '', VL_Erro, 1);

          GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
            '101120231322', 'Mensagem enviada no comando00F4',
            VL_Mensagem.TagsAsString, 0, 2);

          DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
            VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
            VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
          Exit;
        end;

        if VL_Bin = '' then
          VL_Bin := VL_Chave00F1.GetTagAsAstring('0036');  // carrega bin

        if VL_Adquirente_Identificacao = '' then
          VL_Adquirente_Identificacao := VL_Chave00F1.GetTagAsAstring('0109');
        // carrega identificacao do adquirente
      end;


      if VL_Transacao.GetTagAsAstring('00D5') = '00D3' then
        // OPCAO CANCELAMENTO DE VENDA
      begin
        if VL_Transacao.GetTagAsAstring('00F1') = '' then
          // verifica se possui a chave da transacao
        begin
          VL_Mensagem.Limpar;

          VL_Mensagem.AddComando('00E1', 'S');
          //solicita dados da venda
          VL_Mensagem.AddTag('00F1', '');
          // solicita chave da transacao da venda

          GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
            '101120231323', 'Mensagem enviada no comando00F4',
            VL_Mensagem.TagsAsString, 0, 2);

          DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
            VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
            VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
          Exit;
        end;

        if VL_Transacao.GetTagAsAstring('00F1') = #1 then
          // chave da transacao veio nula
        begin
          //VL_Mensagem.Limpar;
          VL_Mensagem.AddComando('00F4', 'R');  // retorno
          VL_Mensagem.AddTag('004D', '89'); // retorno com erro

          GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
            '101120231324', 'Mensagem enviada no comando00F4',
            VL_Mensagem.TagsAsString, 0, 2);

          DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
            VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
            VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
          Exit;
        end;

        VL_RecModulo := VF_Modulo.RetornaModulo(VL_Bin,''); // carrega dados do bin

        if VL_RecModulo.ModuloConfID = -1 then  //MODULO NAO CARREGADO PARA ESSE BIN
        begin
          VL_Mensagem.AddComando('00F4', 'R'); // retorno
          VL_Mensagem.AddTag('004D', 79);  // retorno com erro
          Result := 79;

          GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
            '101120231325', 'Mensagem enviada no comando00F4',
            VL_Mensagem.TagsAsString, 0, 2);

          DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
            VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
            VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
          Exit;
        end;

        VL_Mensagem.AddComando('00F6', 'S');
        // solicita cancelamento da transacao
        VL_Mensagem.AddTag('007D', VL_Transacao.TagsAsString);
        // TRANSACAO

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
          '101120231326', 'Mensagem enviada no comando00F4',
          VL_Mensagem.TagsAsString, 0, 2);

        DNucleo.ModuloAddSolicitacao(VP_Conexao_ID, VP_Transmissao_ID,VL_TempoEmperaComandao,VL_RecModulo.ModuloConfID, VL_Mensagem, cnCaixa);
        Exit;

      end;

      //NAO TEM BIN NAO TEM IDENTIFICACAO DO ADQUIRENTE E VEIO TRILHA 2
      if ((VL_Bin = '') and (VL_Adquirente_Identificacao = '') and (VL_Transacao.GetTagAsAstring('004F') <> '')) then
      begin
        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('008C', 'S'); // solicita atualizacao das tags
        VL_Mensagem.AddTag('00D9', VL_Transacao.GetTagAsAstring('004F'));
        // pan
        VL_Mensagem.AddTag('0062', '0000' + Copy(VL_Transacao.GetTagAsAstring('004F'), 7, 12));  //pan mascarado
        VL_Mensagem.AddTag('0036',
          Copy(VL_Transacao.GetTagAsAstring('004F'), 1, 6));
        //bin

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
          '101120231327', 'Mensagem enviada no comando00F4',
          VL_Mensagem.TagsAsString, 0, 2);

        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
          VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
          VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
        Exit;

      end;

      //NAO TEM BIN NAO TEM IDENTIFICACAO DO ADQUIRENTE E SELECIONOU UMA OPÇÃO
      if ((VL_Bin = '') and (VL_Adquirente_Identificacao = '') and (VL_Transacao.GetTagAsAstring('00D5') <> '')) then
      begin
        if VL_Transacao.GetTagAsAstring('00D5') = '001D' then
          // LEITURA DE CARTAO
        begin
          VL_Mensagem.Limpar;
          VL_Mensagem.AddComando('0048', 'S');
          VL_Mensagem.AddTag('0051', '300000');

          GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
            '101120231328', 'Mensagem enviada no comando00F4',
            VL_Mensagem.TagsAsString, 0, 2);

          DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
            VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
            VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
          Exit;
        end
        else
        if VL_Transacao.GetTagAsAstring('00D5') = '00F0' then
          // OPCAO DE CONSULTAR SALDO
        begin
          VL_Mensagem.Limpar;

          // INFORMA OS BOTOES DENTRO DA TAG DE COMANDO DO BOTAO 0018
          VL_Mensagem.AddTag('00E7', 'OK');
          //BOTAO PERSONALIZADO PARA IDENTIFICAR CARTÃO DIGITADO
          VL_String := VL_Mensagem.TagsAsString;
          //converte em string a mensagem
          VL_Mensagem.Limpar;

          VL_Mensagem.AddComando('002A', 'S');   //solicita dados pdv
          VL_Mensagem.AddTag('00DA', 'DIGITE O CARTÃO');
          //MENSAGEM A SER MOSTRADA
          VL_Mensagem.AddTag('00DD', VL_String);    //BOTOES A MOSTRAR
          VL_Mensagem.AddTag('0033', 'A');    //campo para capturar sem mascara

          GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
            '101120231329', 'Mensagem enviada no comando00F4',
            VL_Mensagem.TagsAsString, 0, 2);

          DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
            VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
            VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
          Exit;
        end
        else
        if VL_Transacao.GetTagAsAstring('00D5') = '00E7' then
          // RETORNO DO CARTAO DIGITADO
        begin
          VL_Mensagem.Limpar;
          VL_Mensagem.AddComando('008C', 'S');  // solicita atualizacao da tag
          VL_Mensagem.AddTag('00D9', VL_Transacao.GetTagAsAstring('0033'));
          // pan DIGITADO
          VL_Mensagem.AddTag('0062', '0000' + Copy(VL_Transacao.GetTagAsAstring('0033'), 7, 12));
          //pan mascarado
          VL_Mensagem.AddTag('0036',
            Copy(VL_Transacao.GetTagAsAstring('0033'), 1, 6));
          //bin

          GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
            '101120231330', 'Mensagem enviada no comando00F4',
            VL_Mensagem.TagsAsString, 0, 2);

          DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
            VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
            VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
          Exit;

        end;


        // solicita menu operacional
        VL_Mensagem.AddComando('00F5', 'S');

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
          '101120231331', 'Mensagem enviada no comando00F4',
          VL_Mensagem.TagsAsString, 0, 2);

        comando00F5(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID,
          VP_Terminal_Status, VP_Terminal_ID);
        Exit;
      end;

      // tenta mandar a mensagem para o modulo ativo

      if (VL_Adquirente_Identificacao <> '') then
        // tem identificacao do adquirente então tenta localizar o modulo
      begin
        VL_Mensagem.AddComando('0105', 'R'); // retorno do comando para pdv
        VL_Mensagem.AddTag('007D', VL_Transacao.TagsAsString);
        // TRANSACAO

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
          '101120231332', 'Mensagem enviada no comando00F4',
          VL_Mensagem.TagsAsString, 0, 2);

        VL_Erro := DNucleo.ModuloAddSolicitacaoIdentificacaoAdquirente(VP_Conexao_ID, VP_Transmissao_ID, VL_TempoEmperaComandao, VL_Adquirente_Identificacao, VL_Mensagem, cnServico);

        if VL_Erro <> 0 then
        begin
          VL_Mensagem.AddComando('00F4', 'R');  // retorno
          VL_Mensagem.AddTag('004D', VL_Erro); // retorno com erro
          Result := VL_Erro;
          GravaLog(F_ArquivoLog, 0, '.comando00F4', 'opentefnucleo',
            '010920221035', '', '', VL_Erro, 1);

          GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
            '101120231333', 'Mensagem enviada no comando00F4',
            VL_Mensagem.TagsAsString, 0, 2);

          DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
            VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
            VL_Mensagem, VL_Mensagem, VP_Conexao_ID);

        end;
        Exit;
      end;

      if (VL_Bin <> '') then // tem bin então tenta localizar o modulo
      begin
        VL_RecModulo := VF_Modulo.RetornaModulo(VL_Bin,'');
        if VL_RecModulo.ModuloConfID = -1 then
          //MODULO NAO CARREGADO PARA ESSE BIN
        begin
          VL_Mensagem.AddComando('00F4', 'R'); // retorno
          VL_Mensagem.AddTag('004D', 79); // retorno com erro

          GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
            '101120231334', 'Mensagem enviada no comando00F4',
            VL_Mensagem.TagsAsString, 0, 2);

          DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
            VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
            VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
          Exit;
        end;

        if VP_Terminal_Tipo = 'PDV' then  // CONEXAO É DO PDV
        begin
          VL_BancoDados.ConsultaA.Close;
          VL_BancoDados.ConsultaA.SQL.Text :=
            'SELECT S_HABILITADO,S_TAG_NUMERO,S_LOJA_CODIGO, S_PDV_CODIGO FROM P_TAG_FUNCAO(' + StrToSql(IntToStr(VP_Terminal_ID)) + ',''MODULO'')' +
            ' WHERE S_HABILITADO=''T'' AND S_TAG_NUMERO=''' + VL_RecModulo.ModuloTag + '''';

          VL_BancoDados.ConsultaA.Open;

          if VL_BancoDados.ConsultaA.FieldByName('S_HABILITADO').AsString <> 'T' then
          begin
            VL_Mensagem.AddComando('00F4', 'R'); // retorno
            VL_Mensagem.AddTag('004D', 79); // retorno com erro

            GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
              '101120231335', 'Mensagem enviada no comando00F4',
              VL_Mensagem.TagsAsString, 0, 2);

            DComunicador.ServidorTransmiteSolicitacaoID(
              DComunicador, VL_TempoEmperaComandao,
              False, nil, VP_Transmissao_ID,
              VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
            Exit;
          end;

          // verifica se ja tem chave
          if VL_Transacao.GetTagAsAstring('00F1') = '' then
          begin

            VL_Chave00F1.AddComando('0000', '');
            VL_Chave00F1.AddTag('00F2', VL_RecModulo.ModuloTag);
            // tag do modulo
            VL_Chave00F1.AddTag('0036', VL_RecModulo.IIN);   // bin
            VL_Chave00F1.AddTag('0034',
              VL_Transacao.GetTagAsAstring('0034'));
            // id da transacao
            VL_Chave00F1.AddTag('0091', VP_Doc);  // documento(cpf ou cnpj)
            VL_Chave00F1.AddTag('00F9',
              VL_BancoDados.ConsultaA.FieldByName('S_LOJA_CODIGO').AsString);
            // codigo da loja
            VL_Chave00F1.AddTag('0107',
              VL_BancoDados.ConsultaA.FieldByName('S_PDV_CODIGO').AsString);
            // codigo do pdv
            VL_Chave00F1.AddTag('0108', VP_Terminal_Identificacao);
            // identificacao do caixa, configurador, gerenciado
            VL_Chave00F1.AddTag('00A2', 'PDV'); // tipo do terminal

            VL_Transacao.AddTag('00F1', VL_Chave00F1.TagsAsString);

            VL_Mensagem.Limpar;

            VL_Mensagem.AddComando('008C', 'S');
            // solicita atualizacao da tag
            VL_Mensagem.AddTag('00F1', VL_Chave00F1.TagsAsString);

            GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
              '101120231336', 'Mensagem enviada no comando00F4',
              VL_Mensagem.TagsAsString, 0, 2);

            DComunicador.ServidorTransmiteSolicitacaoID(
              DComunicador, VL_TempoEmperaComandao,
              False, nil, VP_Transmissao_ID,
              VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
            Exit;

          end;


          VL_Mensagem.AddComando('00F3', 'S'); // solicita saldo
          VL_Mensagem.AddTag('007D', VL_Transacao.TagsAsString);

          GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
            '101120231337', 'Mensagem enviada no comando00F4',
            VL_Mensagem.TagsAsString, 0, 2);

          // TRANSACAO
          VL_Erro := DNucleo.ModuloAddSolicitacao(VP_Conexao_ID, VP_Transmissao_ID, VL_TempoEmperaComandao, VL_RecModulo.ModuloConfID, VL_Mensagem, cnCaixa);

          if VL_Erro <> 0 then
          begin
            VL_Mensagem.AddComando('00F4', 'R');  // retorno
            VL_Mensagem.AddTag('004D', VL_Erro); // retorno com erro
            Result := VL_Erro;
            GravaLog(F_ArquivoLog, 0, '.comando00F4',
              'opentefnucleo', '260820220850', '', '', VL_Erro, 2);

            GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
              '101120231338', 'Mensagem enviada no comando00F4',
              VL_Mensagem.TagsAsString, 0, 2);

            DComunicador.ServidorTransmiteSolicitacaoID(
              DComunicador, VL_TempoEmperaComandao,
              False, nil, VP_Transmissao_ID,
              VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
          end;
          Exit;
        end
        else  // CONEXAO NÃO É DO PDV E NÃO PODE FAZER VENDA
        begin
          VL_Mensagem.AddComando('00F4', 'R'); // retorno
          VL_Mensagem.AddTag('004D', 81);  // retorno com erro

          GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
            '101120231339', 'Mensagem enviada no comando00F4',
            VL_Mensagem.TagsAsString, 0, 2);

          DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
            VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
            VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
          Exit;
        end;
        // VERIFICA SE ESSE PDV TEM O MODULO_CONF LIBERADO NA LOJA

        Exit;
      end;

      VL_Mensagem.AddComando('00F4', 'R'); // retorno
      VL_Mensagem.AddTag('004D', 80);  // retorno com erro

      GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '101120231340',
        'Mensagem enviada no comando00F4', VL_Mensagem.TagsAsString, 0, 2);

      DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
        VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
        VL_Mensagem, VL_Mensagem, VP_Conexao_ID);

    except
      on E: Exception do
        GravaLog(F_ArquivoLog, 0, '00F4', 'opentefnucleo',
          '141120231639', 'Excecao: ' + E.ClassName + '/' + E.Message, '', 1, 1);
    end;
  finally
    VL_Transacao.Free;
    VL_Chave00F1.Free;
    VL_Mensagem.Free;
    VL_BancoDados.Free;
  end;
end;

function TDNucleo.comando0105(VP_Transmissao_ID: string; VP_Tarefa_ID, VP_ModuloProID, VP_Conexao_ID, VP_ModuloConfigID, VP_Erro: integer; VP_Modulo_Tag, VP_Dados: string): integer;
  // SOLICITA PARA TERMINAIS
var
  VL_Chave00F1, VL_Transacao, VL_Mensagem: TMensagem;
  VL_TempoEmperaComandao: int64;
  VL_Identificacao: string;
  VL_TerminalTipo: string;
  VL_Erro: integer;
  VL_PRegModulo: ^TRegModulo;
  VL_BancoDados: TDBancoDados;
  VL_PDV_ID: integer;
  VL_Documento: string;
  VL_CodigoPDV: string;
  VL_CodigoLoja: string;
  VL_ConexaoTipo: TConexaoTipo;
begin
  Result := 0;
  VL_TempoEmperaComandao := 0;
  VL_Identificacao := '';
  VL_Documento := '';
  VL_CodigoLoja := '';
  VL_CodigoPDV := '';
  VL_TerminalTipo := '';
  try
    try
      VL_Transacao := TMensagem.Create;
      VL_Chave00F1 := TMensagem.Create;
      VL_Mensagem := TMensagem.Create;
      VL_BancoDados := TDBancoDados.Create(nil);

      VL_PRegModulo := ModuloGetReg(VP_ModuloProID);
      VL_Erro := VL_Mensagem.CarregaTags(VP_Dados);


      if VL_Erro <> 0 then
      begin
        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('0026', IntToStr(VL_Erro)); // retorno com erro
        Result := VL_Erro;

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
          '101120231341', 'Mensagem enviada no comando0105',
          VL_Mensagem.TagsAsString, 0, 2);

        VL_PRegModulo^.Solicitacao(VL_PRegModulo^.PModulo,
          PUtf8Char(VP_Transmissao_ID), PUtf8Char(VL_Mensagem.TagsAsString), nil,
          VP_Tarefa_ID, VL_TempoEmperaComandao);
        GravaLog(F_ArquivoLog, 0, '.comando0105', 'opentefnucleo',
          '290820221427', '', '', VL_Erro, 1);
        Exit;
      end;

      VL_Mensagem.GetTag('0051', VL_TempoEmperaComandao);       // TEMPO DO COMANDO
      if VL_TempoEmperaComandao = 0 then
        VL_Transacao.GetTag('0051', VL_TempoEmperaComandao);
      if VL_TempoEmperaComandao = 0 then
        VL_TempoEmperaComandao := 30000;

      VL_Erro := VL_Chave00F1.CarregaTags(VL_Mensagem.GetTagAsAstring('00F1'));

      if VL_Erro <> 0 then
      begin
        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('0026', IntToStr(VL_Erro)); // retorno com erro
        Result := VL_Erro;

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
          '101120231342', 'Mensagem enviada no comando0105',
          VL_Mensagem.TagsAsString, 0, 2);

        VL_PRegModulo^.Solicitacao(VL_PRegModulo^.PModulo,
          PUtf8Char(VP_Transmissao_ID), PUtf8Char(VL_Mensagem.TagsAsString), nil,
          VP_Tarefa_ID, VL_TempoEmperaComandao);
        GravaLog(F_ArquivoLog, 0, '.comando0105', 'opentefnucleo',
          '290820221429', '', '', VL_Erro, 1);
        Exit;
      end;

      if VL_Chave00F1.GetTagAsAstring('0110') = 'C' then // TIPO DA CONEXAO
        VL_ConexaoTipo := CnCaixa
      else
        VL_ConexaoTipo := CnServico;

      if VP_ModuloConfigID = -1 then  // conexão veio de um terminal
      begin
        VL_Erro := DNucleo.ModuloAddSolicitacaoIdentificacaoAdquirente(VP_Conexao_ID, VP_Transmissao_ID, VL_TempoEmperaComandao, VL_Chave00F1.GetTagAsAstring('0109'),
          VL_Mensagem, VL_ConexaoTipo);

        if VL_Erro <> 0 then
        begin
          VL_Mensagem.AddComando('00F4', 'R');  // retorno
          VL_Mensagem.AddTag('004D', VL_Erro); // retorno com erro
          Result := VL_Erro;
          GravaLog(F_ArquivoLog, 0, '.comando000A', 'opentefnucleo',
            '290820220834', '', '', VL_Erro, 1);

          GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
            '101120231312', 'Mensagem enviada no comando000A',
            VL_Mensagem.TagsAsString, 0, 2);

          DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
            VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
            VL_Mensagem, VL_Mensagem, VP_Conexao_ID);

        end;
        Exit;

      end;


      VL_Chave00F1.GetTag('0108', VL_Identificacao);
      // identificação do terminal
      VL_Chave00F1.GetTag('00F9', VL_CodigoLoja);  // codigo da loja
      VL_Chave00F1.GetTag('0107', VL_CodigoPDV);  // codigo do pdv
      VL_Chave00F1.GetTag('00A2', VL_TerminalTipo);        // tipo terminal


      if VL_TerminalTipo <> 'PDV' then
      begin
        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('0026', '1'); // retorno com erro
        VL_Mensagem.AddTag('004A', 'O tipo do terminal não é PDV');
        // descricao do erro
        VL_PRegModulo := ModuloGetReg(VP_ModuloProID);

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
          '101120231343', 'Mensagem enviada no comando0105',
          VL_Mensagem.TagsAsString, 0, 2);

        VL_PRegModulo^.Solicitacao(VL_PRegModulo^.PModulo,
          PUtf8Char(VP_Transmissao_ID), PUtf8Char(VL_Mensagem.TagsAsString), nil,
          VP_Tarefa_ID, VL_TempoEmperaComandao);
        Exit;
      end;

      VL_BancoDados.ConsultaA.Close;
      VL_BancoDados.ConsultaA.SQL.Text :=
        'SELECT P.ID, L.DOC FROM MODULO_CONF M ' + ' LEFT OUTER JOIN PDV_MODULO_CONF PMC ON PMC.MODULO_CONF_ID=M.ID AND  PMC.CODIGO= ' +
        StrToSql(VL_CodigoPDV, True) + ' LEFT OUTER JOIN MULTILOJA_MODULO_CONF MMC ON MMC.MODULO_CONF_ID=M.ID ' +
        ' LEFT OUTER JOIN LOJA_MODULO_CONF LMC ON LMC.MODULO_CONF_ID=M.ID and LMC.CODIGO=' + StrToSql(VL_CodigoLoja, True) + ' LEFT OUTER JOIN LOJA L ON  L.ID=LMC.LOJA_ID ' +
        ' LEFT OUTER JOIN PDV P ON P.id=pmc.PDV_ID AND  P.LOJA_ID=L.ID ' + ' LEFT OUTER JOIN IDENTIFICACAO I ON P.IDENTIFICACAO_ID = I.ID ' + ' WHERE M.ID=' +
        StrToSql(IntToStr(VP_ModuloConfigID), True) + ' AND (PMC.ID IS NOT NULL OR ' + StrToSql(VL_CodigoPDV, True) + ' IS NULL)' + ' AND I.IDENTIFICADOR= ' + StrToSql(VL_Identificacao, True);
      VL_BancoDados.ConsultaA.Open;


      if VL_BancoDados.ConsultaA.RecordCount <> 1 then
      begin
        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('0026', '1'); // retorno com erro
        GravaLog(F_ArquivoLog, 0, '.comando0105', 'opentefnucleo',
          '290820221430', '', '', 1, 1);
        VL_Mensagem.AddTag('004A',
          'PDV não encontrado com essas informações');
        // descricao do erro

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
          '101120231404', 'Mensagem enviada no comando0105',
          VL_Mensagem.TagsAsString, 0, 2);

        TRegModulo(VL_PRegModulo^).Solicitacao(VL_PRegModulo^.PModulo,
          PUtf8Char(VP_Transmissao_ID), PUtf8Char(VL_Mensagem.TagsAsString), nil,
          VP_Tarefa_ID, VL_TempoEmperaComandao);




        Exit;
      end;

      VL_PDV_ID := VL_BancoDados.ConsultaA.FieldByName('ID').AsInteger;
      VL_Documento := VL_BancoDados.ConsultaA.FieldByName('DOC').AsString;

      VL_BancoDados.ConsultaA.Close;
      VL_BancoDados.ConsultaA.SQL.Text :=
        'SELECT S_HABILITADO, S_TAG_NUMERO, S_LOJA_CODIGO, S_PDV_CODIGO FROM P_TAG_FUNCAO(' + StrToSql(IntToStr(VL_PDV_ID)) + ', ''MODULO'') ' +
        ' WHERE S_TAG_NUMERO = ' + StrToSql(VL_PRegModulo^.Tag);
      VL_BancoDados.ConsultaA.Open;

      if VL_BancoDados.ConsultaA.FieldByName('S_HABILITADO').AsString <> 'T' then
      begin
        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('0026', '1'); // retorno com erro
        VL_Mensagem.AddTag('004A', 'PDV não habilitado'); // descricao do erro

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
          '101120231405', 'Mensagem enviada no comando0105',
          VL_Mensagem.TagsAsString, 0, 2);

        VL_PRegModulo^.Solicitacao(VL_PRegModulo^.PModulo,
          PUtf8Char(VP_Transmissao_ID), PUtf8Char(VL_Mensagem.TagsAsString), nil,
          VP_Tarefa_ID, VL_TempoEmperaComandao);
        Exit;
      end;


      VL_Chave00F1.AddTag('00F2', VL_PRegModulo^.Tag); // tag do modulo
      VL_Chave00F1.AddTag('0109', VL_PRegModulo^.Adquirente_Identificacao);
      // identificacao do adquirente
      VL_Chave00F1.AddTag('0091', VL_Documento);
      // documento(cpf ou cnpj do estabelecimento)


      VL_Mensagem.AddTag('00F1', VL_Chave00F1.TagsAsString);  // chave da transacao

      GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '101120231406',
        'Mensagem enviada no comando0105', VL_Mensagem.TagsAsString, 0, 2);

      Result := DComunicador.ServidorTransmiteSolicitacaoIdentificacao(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID, VL_Mensagem, VL_Mensagem, VL_Identificacao);

      if Result <> 0 then
      begin
        VL_Mensagem.Limpar;
        GravaLog(F_ArquivoLog, 0, '.comando0105', 'opentefnucleo',
          '050920221433', '', '', Result, 1);
        VL_Mensagem.AddComando('0026', IntToStr(Result)); // retorno com erro

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
          '101120231407', 'Mensagem enviada no comando0105',
          VL_Mensagem.TagsAsString, 0, 2);

        VL_PRegModulo^.Solicitacao(VL_PRegModulo^.PModulo,
          PUtf8Char(VP_Transmissao_ID), PUtf8Char(VL_Mensagem.TagsAsString), nil,
          VP_Tarefa_ID, VL_TempoEmperaComandao);
        Exit;
      end;
      Exit;

    except
      on E: Exception do
        GravaLog(F_ArquivoLog, 0, '0105', 'opentefnucleo',
          '141120231644', 'Excecao: ' + E.ClassName + '/' + E.Message, '', 1, 1);
    end;
  finally
    VL_Transacao.Free;
    VL_Chave00F1.Free;
    VL_Mensagem.Free;
    VL_BancoDados.Free;
  end;
end;

function TDNucleo.comando010D(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer): integer; // solicita atualizacao
var
  VL_Mensagem: TMensagem;
  VL_BancoDados: TDBancoDados;
  VL_Arquivo: TStringStream;
begin
  Result := 0;

  VL_Mensagem := TMensagem.Create;
  VL_BancoDados := TDBancoDados.Create(nil);
  try
    try
      VL_BancoDados.ConsultaA.Close;
      VL_BancoDados.ConsultaA.SQL.Text :=
        'SELECT ARQUIVO FROM VERSAO WHERE PROGRAMA =  ' + StrToSql(VP_Mensagem.ComandoDados);
      VL_BancoDados.ConsultaA.Open;

      if VL_BancoDados.ConsultaA.RecordCount <= 0 then
      begin
        VL_Mensagem.AddComando('0029', '104');  // retorno com erro
        Result := 104;

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
          '101120231408', 'Mensagem enviada no comando010D',
          VL_Mensagem.TagsAsString, 0, 2);

        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
          30000, False, nil, VP_Transmissao_ID, VL_Mensagem,
          VL_Mensagem, VP_Conexao_ID);
        Exit;
      end;

      VL_Arquivo := TStringStream.Create;
      TBlobField(VL_BancoDados.ConsultaA.FieldByName('ARQUIVO')).SaveToStream(
        VL_Arquivo);
      VL_Arquivo.Position := 0;

      VL_Mensagem.AddComando('010D', 'R'); // retorno da atualizacao
      VL_Mensagem.AddTag('010B',
        EncodeStringBase64(VL_Arquivo.DataString)); // arquivo do programa
      VL_Arquivo.Free;

      GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '101120231409',
        'Mensagem enviada no comando010D', VL_Mensagem.TagsAsString, 0, 2);

      Result := DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, 30000, False, nil, VP_Transmissao_ID, VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
    except
      on E: Exception do
        GravaLog(F_ArquivoLog, 0, '010D', 'opentefnucleo',
          '141120231648', 'Excecao: ' + E.ClassName + '/' + E.Message, '', 1, 1);
    end;
  finally
    VL_Mensagem.Free;
    VL_BancoDados.Free;
  end;
end;

function TDNucleo.comando0111(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer): integer; // solicita chave publica
var
  VL_Mensagem: TMensagem;
  VL_Erro: integer;
  VL_Adquirente_Identificacao: string;
  VL_RecModulo: TRecModulo;
  VL_RegModulo: TRegModulo;
begin
  Result := 0;
  VL_Mensagem := TMensagem.Create;
  VL_Adquirente_Identificacao := '';
  try
    VL_Erro := VL_Mensagem.CarregaTags(VP_Mensagem.GetTagAsAstring('00F1'));
    // chave da transacao
    if VL_Erro <> 0 then
    begin
      VL_Mensagem.AddComando('0111', 'R');  // retorno
      VL_Mensagem.AddTag('004D', IntToStr(VL_Erro)); // resposta com erro
      Result := VL_Erro;
      GravaLog(F_ArquivoLog, 0, '.comando0111', 'opentefnucleo',
        '020920220840', '', '', VL_Erro, 2);

      GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '101120231410',
        'Mensagem enviada no comando0111', VL_Mensagem.TagsAsString, 0, 1);

      DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
        30000, False, nil, VP_Transmissao_ID,
        VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
    end;

    if (VL_Mensagem.GetTagAsAstring('0036') <> '') then
      // tem bin então tenta localizar o modulo
    begin
      VL_RecModulo := VF_Modulo.RetornaModulo(VL_Mensagem.GetTagAsAstring('0036'),'');
      if VL_RecModulo.ModuloConfID = -1 then
        //MODULO NAO CARREGADO PARA ESSE BIN
      begin
        VL_Mensagem.AddComando('0111', 'R');  // retorno
        VL_Mensagem.AddTag('004D', 79); // resposta com erro

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
          '101120231411', 'Mensagem enviada no comando0111',
          VL_Mensagem.TagsAsString, 0, 2);

        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
          30000, False, nil, VP_Transmissao_ID, VL_Mensagem,
          VL_Mensagem, VP_Conexao_ID);
        Result := 79;
        Exit;
      end;


      VP_Mensagem.AddComando('0111', 'R');   // retorno da chave

      if VP_Mensagem.GetTagAsAstring('0110') = 'C' then // tipo caixa
      begin
        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
          '101120231412', 'Mensagem enviada para o caixa no comando0111',
          VL_Mensagem.TagsAsString, 0, 2);

        VL_Erro := DNucleo.ModuloAddSolicitacao(VP_Conexao_ID, VP_Transmissao_ID, 30000, VL_RecModulo.ModuloConfID, VP_Mensagem, cnCaixa);
      end
      else    // tipo servico
      begin
        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
          '101120231413', 'Mensagem enviada para o servico no comando0111',
          VL_Mensagem.TagsAsString, 0, 2);

        VL_Erro := DNucleo.ModuloAddSolicitacao(VP_Conexao_ID, VP_Transmissao_ID, 30000, VL_RecModulo.ModuloConfID, VP_Mensagem, cnServico);
      end;

      if VL_Erro <> 0 then
      begin
        VL_Mensagem.AddComando('0111', 'R'); // retorno
        VL_Mensagem.AddTag('004D', VL_Erro); // retorno com erro
        Result := VL_Erro;

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
          '101120231414', 'Mensagem enviada no comando0111',
          VL_Mensagem.TagsAsString, 0, 2);

        GravaLog(F_ArquivoLog, 0, '.comando0111', 'opentefnucleo',
          '020920220845', '', '', VL_Erro, 1);
        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
          30000, False, nil, VP_Transmissao_ID, VL_Mensagem,
          VL_Mensagem, VP_Conexao_ID);
        Exit;
      end;
      Exit;
    end;

    if (VL_Mensagem.GetTagAsAstring('0109') <> '') then
      // tem identificacao do adquirente então tenta localizar o modulo
    begin

      VL_RegModulo := DNucleo.ModuloGetRegAdquirencia(VL_Mensagem.GetTagAsAstring('0109'), VL_Mensagem.GetTagAsAstring('00F2'));

      if VL_RegModulo.ModuloProcID = -1 then
      begin
        VL_Mensagem.AddComando('0111', 'R');  // retorno
        VL_Mensagem.AddTag('004D', 64); // resposta com erro

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
          '101120231415', 'Mensagem enviada no comando0111',
          VL_Mensagem.TagsAsString, 0, 2);

        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
          30000, False, nil, VP_Transmissao_ID, VP_Mensagem,
          VP_Mensagem, VP_Conexao_ID);
        Result := 64;
        Exit;
      end;

      VL_Mensagem.GetTag('0109', VL_Adquirente_Identificacao);


      VL_Mensagem.AddComando('0111', 'R'); // retorno do comando para pdv


      if VL_Mensagem.GetTagAsAstring('0110') = 'C' then  // tipo caixa
      begin
        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
          '101120231416', 'Mensagem enviada no comando0111',
          VL_Mensagem.TagsAsString, 0, 2);

        VL_Erro := DNucleo.ModuloAddSolicitacaoIdentificacaoAdquirente(VP_Conexao_ID, VP_Transmissao_ID, 30000, VL_Adquirente_Identificacao, VP_Mensagem, cnCaixa);
      end
      else  // tipo servico
      begin
        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
          '101120231417', 'Mensagem enviada no comando0111',
          VL_Mensagem.TagsAsString, 0, 2);

        VL_Erro := DNucleo.ModuloAddSolicitacaoIdentificacaoAdquirente(VP_Conexao_ID, VP_Transmissao_ID, 30000, VL_Adquirente_Identificacao, VP_Mensagem, cnServico);
      end;


      if VL_Erro <> 0 then
      begin
        VL_Mensagem.AddComando('0111', 'R');  // retorno
        VL_Mensagem.AddTag('004D', IntToStr(VL_Erro)); // resposta com erro
        Result := VL_Erro;
        GravaLog(F_ArquivoLog, 0, '.comando0111', 'opentefnucleo',
          '020920220838', '', '', VL_Erro, 1);

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo',
          '101120231418', 'Mensagem enviada no comando0111',
          VL_Mensagem.TagsAsString, 0, 2);

        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
          30000, False, nil, VP_Transmissao_ID,
          VP_Mensagem, VP_Mensagem, VP_Conexao_ID);
        Exit;
      end;
    end;

  finally
    VL_Mensagem.Free;
  end;
end;

function TDNucleo.TransmissaoComando(AOwner: Pointer; VP_Conexao_ID: integer; VP_Transmissao_ID, VP_Comando: string; var VO_Dados: string): integer;
  // comando enviados pelo comunicador do servidor diretamente para o opentef
var
  VL_Mensagem: TMensagem;
  VL_Erro: integer;
  VL_BancoDados: TDBancoDados;
  VL_Linha: string;
begin
  VL_Linha := '';
  VO_Dados := '';
  Result := 0;

  VL_Mensagem := nil;
  VL_BancoDados := TDBancoDados.Create(nil);
  try
    try
      VL_Linha := '280720231415';
      VL_Mensagem := TMensagem.Create;

      Result := VL_Mensagem.CarregaTags(VP_Comando);

      if Result <> 0 then
      begin
        Exit;
      end;

      if ((VL_Mensagem.Comando = '0022') and (VL_Mensagem.ComandoDados = 'S')) then
        // SOLICITA DADOS DA IDENTIFICACAO
      begin
        VL_Linha := '280720231440';

        if VL_Mensagem.GetTagAsAstring('0108') = '' then // identificacao
        begin
          Result := 107;
          Exit;
        end;

        VL_BancoDados.ConsultaA.Close;
        VL_BancoDados.ConsultaA.SQL.Text :=
          'select I.ID, ' + ' CASE ' + '    WHEN p.CHAVE_ID > 0 THEN (select CHAVE_COMUNICACAO FROM chave where id = p.CHAVE_ID) ' +
          '    WHEN c.CHAVE_ID > 0 THEN (select CHAVE_COMUNICACAO FROM chave where id = c.CHAVE_ID) ' +
          '    WHEN m.CHAVE_ID > 0 THEN (select CHAVE_COMUNICACAO FROM chave where id = m.CHAVE_ID) ' + '    ELSE '''' ' + ' END AS CHAVE_COMUNICACAO ' +
          ' from identificacao i ' + ' left outer join pdv p on ' + ' p.IDENTIFICACAO_ID = i.ID ' + ' left outer join CONFIGURADOR c on ' +
          ' c.IDENTIFICACAO_ID = i.ID ' + ' left outer join MODULO_CONF m on ' + ' m.IDENTIFICACAO_ID = i.ID ' + ' WHERE i.IDENTIFICADOR = ' + StrToSql(VL_Mensagem.GetTagAsAstring('0108'));

        VL_Linha := '280720231416';

        VL_BancoDados.ConsultaA.Open;

        if VL_BancoDados.ConsultaA.RecordCount = 0 then
        begin
          Result := 106;
          Exit;
        end;

        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('0022', 'R');  // RETORNA DADOS DA IDENTIFICACAO
        VL_Mensagem.AddTag('0023',
          VL_BancoDados.ConsultaA.FieldByName('CHAVE_COMUNICACAO').AsString);
        // CHAVE DE COMUNICACAO

        VO_Dados := VL_Mensagem.TagsAsString;

        Exit;

      end;
    except
      on E: Exception do
      begin
        Result := 105;
        GravaLog(F_ArquivoLog, 0, 'TransmissaoComando',
          'opentefnucleo', VL_Linha, 'Excecao: ' + E.ClassName + '/' + E.Message, '', VL_Erro, 1);
      end;
    end;
  finally
    VL_BancoDados.Free;
    VL_Mensagem.Free;
  end;
end;

{$R *.lfm}

end.
