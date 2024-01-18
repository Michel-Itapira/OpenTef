unit uopentef;

{$mode ObjFPC}{$H+}

interface

uses
    Classes,
    SysUtils,
    Forms,
    Dialogs;

type
    TConexaoStatus = (csNaoInicializado, csDesconectado, csLink, csChaveado, csChaveadoAssinado, csLogado);
    TransacaoStatus = (tsEfetivada, tsNegada, tsCancelada, tsProcessando, tsAguardandoComando, tsNaoLocalizada, tsInicializada,
        tsComErro, tsAbortada, tsAguardandoDadosPDV);

    TRetorno = function(VP_DadosEntrada: PChar; var VO_DadosSaida: PChar): integer; cdecl;
    TSolicitaDadosPDV = function(VP_Menu: PChar; var VO_Botao, VO_Dados: PChar): integer; cdecl;
    TSolicitaDadosTransacao = function(VP_Mensagem: PChar; var VO_Dados: PChar): integer; cdecl;
    TImprime = function(VP_Dados: PChar): integer; cdecl;
    TMostraMenu = function(VP_Menu: PChar; var VO_Botao: PChar): integer; cdecl;
    TMensagemOperador = function(VP_Dados: PChar): integer; cdecl;

    TTefInicializar = function(VP_PinPadModelo: integer; VP_PinPadModeloLib, VP_PinPadModeloPorta, VP_PinPadLib, VP_ArquivoLog: PChar;
        VP_RetornoCliente: TRetorno; VP_SolicitaDadosTransacao: TSolicitaDadosTransacao; VP_SolicitaDadosPDV: TSolicitaDadosPDV;
        VP_Imprime: TImprime; VP_MostraMenu: TMostraMenu; VP_MensagemOperador: TMensagemOperador; VP_AmbienteTeste: integer): integer; cdecl;
    TTLogin = function(VP_Host: PChar; VP_Porta, VP_ID: integer; VP_Chave: PChar; VP_Versao_Comunicacao: integer; VP_Identificador: PChar): integer; cdecl;

    TTMensagemCreate = function(var VO_Mensagem: Pointer): integer; cdecl;
    TTMensagemCarregaTags = function(VP_Mensagem: Pointer; VP_Dados: PChar): integer; cdecl;
    TTMensagemComando = function(VP_Mensagem: Pointer; var VP_Dados: PChar): integer; cdecl;
    TTMensagemComandoDados = function(VP_Mensagem: Pointer; var VP_Dados: PChar): integer; cdecl;
    TTMensagemFree = procedure(VP_Mensagem: Pointer); cdecl;
    TTMensagemLimpar = procedure(VP_Mensagem: Pointer); cdecl;
    TTMensagemAddtag = function(VP_Mensagem: Pointer; VP_Tag, VP_Dados: PChar): integer; cdecl;
    TTMensagemAddcomando = function(VP_Mensagem: Pointer; VP_Tag, VP_Dados: PChar): integer; cdecl;
    TTMensagemTagAsString = function(VP_Mensagem: Pointer; var VO_PChar: PChar): integer; cdecl;
    TTMensagemTagCount = function(VO_Mensagem: Pointer): integer; cdecl;
    TTMensagemGetTag = function(VO_Mensagem: Pointer; VP_Tag: PChar; var VO_Dados: PChar): integer; cdecl;
    TTMensagemGetTagIdx = function(VO_Mensagem: Pointer; VL_Idx: integer; var VO_Tag: PChar; var VO_Dados: PChar): integer; cdecl;
    TTMensagemTagToStr = function(VO_Mensagem: Pointer; var VO_Dados: PChar): integer; cdecl;
    TTMensagemerro = function(VP_CodigoErro: integer; var VO_RespostaMensagem: PChar): integer; cdecl;
    TTMensagemGetTagPosicao = function(VP_Mensagem: Pointer; VP_Posicao: integer; VP_Tag: PChar; var VO_Dados: PChar): integer; cdecl;
    TTMensagemAddTagPosicao = function(VP_Mensagem: Pointer; VP_Posicao: integer; VP_Tag, VP_Dados: PChar): integer; cdecl;

    TTransacaocreate = function(VP_Comando, VP_IdentificadorCaixa: PChar; var VO_TransacaID: PChar; VP_TempoAguarda: integer): integer; cdecl;
    TTransacaostatus = function(var VO_Status: integer; var VO_TransacaoChave: PChar; VP_TransacaoID: PChar): integer; cdecl;
    TTransacaostatusdescricao = function(var VO_Status: PChar; VP_TransacaoID: PChar): integer; cdecl;
    TTransacaocancela = function(var VO_Resposta: integer; VP_TransacaoChave, VP_TransacaoID: PChar): integer; cdecl;
    TTransacaofree = procedure(VP_TransacaoID: PChar); cdecl;

    TTransacaogettag = function(VP_TransacaoID, VP_Tag: PChar; var VO_Dados: PChar): integer; cdecl;

var
    F_TefLib: THandle;
    F_TefInicializar: TTefInicializar;
    F_Login: TTLogin;
    F_MensagemCreate: TTMensagemcreate;
    F_MensagemCarregaTags: TTMensagemCarregaTags;
    F_MensagemComando: TTMensagemComando;
    F_MensagemComandoDados: TTMensagemComandoDados;
    F_MensagemFree: TTMensagemFree;
    F_MensagemLimpar: TTMensagemLimpar;
    F_MensagemAddTag: TTMensagemaddtag;
    F_MensagemAddComando: TTMensagemaddcomando;
    F_MensagemTagAsString: TTMensagemTagAsString;
    F_MensagemTagCount: TTMensagemTagCount;
    F_MensagemGetTag: TTMensagemGetTag;
    F_MensagemGetTagIdx: TTMensagemGetTagIdx;
    F_MensagemTagToStr: TTMensagemTagToStr;
    F_MensagemGetTagPosicao: TTMensagemGetTagPosicao;
    F_MensagemAddTagPosicao: TTMensagemAddTagPosicao;

    F_TransacaoCancela: TTransacaocancela;
    F_TransacaoCreate: TTransacaocreate;
    F_TransacaoFree: TTransacaofree;
    F_TransacaoStatus: TTransacaostatus;
    F_TransacaoStatusDescricao: TTransacaostatusdescricao;
    F_TransacaoGetTag: TTransacaogettag;

    F_Erro: TTMensagemerro;

const
    PINPAD_MODELO: integer = 0;
    PINPAD_PORTA: PChar = '';
    PINPAD_MODELO_LIB: PChar = '';
    PINPAD_LIB: PChar = '';
    AMBIENTE_TESTE: integer = 1;

    OPENTEF_HOST: string = 'opentef.ioiosoftware.com.br';
    OPENTEF_PORTA: integer = 39001;
    OPENTEF_ID: integer = 12;
    OPENTEF_CHAVE: string = '123';
    OPENTEF_IDENTIFICADOR: string = '313311';
    OPENTEF_VERSAO_MENSAGEM: integer = 1;

    CAIXA: string = 'CX10';
    TEMPO_ESPERA: integer = 60000;

procedure incializar;
procedure login;

implementation

uses uinterface;

procedure incializar;
var
    VL_Codigo: integer;
    VL_DescricaoErro: PChar;
begin
    VL_DescricaoErro := '';

    F_TefLib := LoadLibrary(PChar(ExtractFilePath(ParamStr(0)) + 'tef_lib.dll'));

    if F_TefLib = 0 then
    begin
        ShowMessage('Não foi possível carregar a lib');
        Application.Terminate;
    end;

    Pointer(F_TefInicializar) := GetProcAddress(F_TefLib, 'inicializar');
    Pointer(F_Login) := GetProcAddress(F_TefLib, 'login');

    Pointer(F_MensagemCreate) := GetProcAddress(F_TefLib, 'mensagemcreate');
    Pointer(F_MensagemCarregaTags) := GetProcAddress(F_TefLib, 'mensagemcarregatags');
    Pointer(F_MensagemComando) := GetProcAddress(F_TefLib, 'mensagemcomando');
    Pointer(F_MensagemComandoDados) := GetProcAddress(F_TefLib, 'mensagemcomandodados');
    Pointer(F_MensagemFree) := GetProcAddress(F_TefLib, 'mensagemfree');
    Pointer(F_MensagemLimpar) := GetProcAddress(F_TefLib, 'mensagemlimpar');
    Pointer(F_Mensagemaddtag) := GetProcAddress(F_TefLib, 'mensagemaddtag');
    Pointer(F_Mensagemaddcomando) := GetProcAddress(F_TefLib, 'mensagemaddcomando');
    Pointer(F_MensagemTagAsString) := GetProcAddress(F_TefLib, 'mensagemtagasstring');
    Pointer(F_MensagemTagCount) := GetProcAddress(F_TefLib, 'mensagemtagcount');
    Pointer(F_MensagemGetTag) := GetProcAddress(F_TefLib, 'mensagemgettag');
    Pointer(F_MensagemGetTagIdx) := GetProcAddress(F_TefLib, 'mensagemgettagidx');
    Pointer(F_MensagemTagToStr) := GetProcAddress(F_TefLib, 'mensagemtagtostr');
    Pointer(F_Erro) := GetProcAddress(F_TefLib, 'mensagemerro');
    Pointer(F_MensagemGetTagPosicao) := GetProcAddress(F_TefLib, 'mensagemgettagposicao');
    Pointer(F_MensagemAddTagPosicao) := GetProcAddress(F_TefLib, 'mensagemaddtagposicao');

    Pointer(F_TransacaoCancela) := GetProcAddress(F_TefLib, 'transacaocancela');
    Pointer(F_TransacaoCreate) := GetProcAddress(F_TefLib, 'transacaocreate');
    Pointer(F_TransacaoFree) := GetProcAddress(F_TefLib, 'transacaofree');
    Pointer(F_TransacaoStatus) := GetProcAddress(F_TefLib, 'transacaostatus');
    Pointer(F_TransacaoStatusDescricao) := GetProcAddress(F_TefLib, 'transacaostatusdescricao');
    Pointer(F_TransacaoGetTag) := GetProcAddress(F_TefLib, 'transacaogettag');

    VL_Codigo := F_TefInicializar(PINPAD_MODELO, PChar(PINPAD_MODELO_LIB), PINPAD_PORTA, PINPAD_LIB,
        PChar(ExtractFilePath(ParamStr(0)) + 'logs.log'), @uinterface.Retorno, @uinterface.solicitadadostransacao,
        @uinterface.solicitadadospdv, @uinterface.imprime, @uinterface.mostramenu, @uinterface.mensagemoperador, AMBIENTE_TESTE);

    if VL_Codigo <> 0 then
    begin
        F_Erro(VL_Codigo, VL_DescricaoErro);
        ShowMessage('Erro: ' + IntToStr(VL_Codigo) + #13 + 'Descrição: ' + VL_DescricaoErro);
        exit;
    end;
end;

procedure login;
var
    VL_Codigo: integer;
    VL_DescricaoErro: PChar;
begin
    VL_DescricaoErro := '';

    VL_Codigo := F_Login(PChar(OPENTEF_HOST), OPENTEF_PORTA, OPENTEF_ID, PChar(OPENTEF_CHAVE),
        OPENTEF_VERSAO_MENSAGEM, PChar(OPENTEF_IDENTIFICADOR));

    if VL_Codigo <> 0 then
    begin
        F_Erro(VL_Codigo, VL_DescricaoErro);
        ShowMessage('Erro: ' + IntToStr(VL_Codigo) + #13 + 'Descrição: ' + VL_DescricaoErro);
        exit;
    end;
end;

end.
