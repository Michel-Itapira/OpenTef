unit funcoes;

{$mode ObjFPC}{$H+}

interface

uses
    Classes,
    SysUtils,
    StrUtils,
    ZDataset,
    ZConnection,
    DB,
    IdContext,
    IdSSLOpenSSL,
    {$IF DEFINED(OPEN_TEF) OR DEFINED(TEF_LIB)OR DEFINED(COM_LIB)}
    def,
    {$ENDIF}
    IdTime,
    syncobjs,
    ExtCtrls,
    Graphics,
    ubarcodes,
    Math,
    rxmemds;

type

    TImagem = (TI_Jpg, TI_Png, TI_BMP, TI_GIF);

    TTag = record
        Tag: ansistring;
        Qt: ansistring;
        Tamanho: longint;
        Dados: ansistring;
    end;


    { TMensagem }
    TMensagem = class
    private
        fTags: array of TTag;
    public
        function CarregaTags(VP_Dados: ansistring): integer;
        function TagToStr(var VO_Dados: ansistring): integer;
        function AddComando(VP_Tag, VP_Dados: ansistring): integer;
        function GetComando(var VO_Tag: ansistring; var VO_Dados: ansistring): integer;
        function GetComandoInt(var VO_Tag: integer; var VO_Dados: ansistring): integer;
        function GetTag(VP_Tag: ansistring; var VO_Dados: ansistring): integer;
        function GetTag(VP_Posicao: integer; var VO_Tag: ansistring; var VO_Dados: ansistring): integer;
        function GetTag(VP_Posicao: integer; var VO_Tag: TTag): integer;
        function GetTag(VP_Tag: ansistring; var VO_Dados: int64): integer;
        function GetTagAsAstring(VP_Tag: ansistring): ansistring;
        function Comando(): ansistring;
        function ComandoDados(): ansistring;
        function TagsAsString: ansistring;
        function TagCount(): integer;
        function GetTagAsInteger(VP_Tag: ansistring): integer;
        function AddTag(VP_Tag, VP_Dados: ansistring): integer;
        function AddTag(VP_Tag: ansistring; VP_Dados: integer): integer;
        procedure Limpar;
        constructor Create;
    end;


    { TErroMensagem }

    TErroMensagem = class
    private

    public

    end;

    TPinPadModelo = (pNDF, pGERTEC_PPC930);
    TRespostaPinPad = procedure(VP_Processo_ID: integer; VP_Mensagem: TMensagem);
    TPinPadErro = procedure(errCode: int16; msg: pansichar);


    TConexaoTipo = (cnCaixa, cnServico, cnNaoDefinido);
    TAguardaEvento = (agTempo, agEvento, agAborta);
    TRetornoModulo = procedure(VP_Transmissao_ID: PChar; VP_Tarefa_ID, VP_ProcID, VP_Codigo: integer; VP_Dados: PChar); cdecl;
    TRetorno = procedure(VP_Transmissao_ID: PChar; VP_ProcID, VP_Codigo: integer; VP_Dados: PChar); cdecl;
    TServidorRecebimento = procedure(VP_Codigo: integer; VP_Transmissao_ID, VP_DadosRecebidos: string; var VO_AContext: TIdContext);
    TServidorRecebimentoLib = function(VP_Codigo: integer; VP_Transmissao_ID, VP_DadosRecebidos: PChar; VP_IP: PChar; VP_ID: integer): integer; cdecl;
    TConexaoStatus = (csDesconectado, csLink, csChaveado, csLogado, csNaoInicializado);
    TTransacaoStatus = (tsEfetivada, tsNegada, tsCancelada, tsProcessando, tsAguardandoComando, tsNaoLocalizada, tsInicializada,
        tsComErro, tsAbortada, tsAguardandoDadosPDV);


    TPermissao = (pmS, pmC, pmA, pmU);  // pmS=permissao de sistema
    // pmC=permissao de controlador permissao maxima
    // pmA permissao de administrador pode gerenciar as transacao e fazer cadastros
    // pmU permissao de usuario consulta e visualizacao das transacoes

    TTipoDocumento = (tdCNPJ, tdCPF); // tipo do documento prar formatação

    TTipoChave = (tcC50, tcPDV, tcConfigurador, tcModuloConfig); // tipo de chaves de validação

    TTipoTag = (ttNDF, ttCOMANDO, ttDADOS, ttMENU_PDV, ttMENU_OPERACIONAL, ttPINPAD_FUNC, ttMODULO); //tipo de tag cadastrado no banco de dados

    { TTEmporizadorEvento }

    TTEmporizadorTThread = class(TThread)
    private
        fTempo: cardinal;
        fTemporizador: Pointer;
    protected
        procedure Execute; override;
    public
        f_parar: boolean;
        constructor Create(VP_Suspenso: boolean; VP_Temporizador: Pointer);
    end;


    { TTEmporizador }
    TTemporizador = class
    private
        fTEmporizadorTThread: TTEmporizadorTThread;
        fEvento: TAguardaEvento;

    public
        V_Dados: string;
        V_Executado: boolean;
        V_Aguardando: boolean;
        V_Aborta: boolean;
        V_ID: string;
        constructor Create;
        procedure parar;
        procedure abortar;
        function aguarda(VP_Tempo: cardinal; VP_Reaguardar: boolean; VP_Temporizador: Pointer): TAguardaEvento;
        destructor Destroy; override;

    end;

    { TTransacao }

    TTransacao = class
        fMensagem: TMensagem;
        fcomando: string;
        fTemporizador: TTemporizador;
    private
        function GetErro: integer;
        function GetErroDescricao: string;
        procedure SetErro(VP_Erro: integer);
        function GetStatus: TTransacaoStatus;
        procedure SetErroDescricao(VP_Descricao: string);
        procedure SetStatus(VP_Status: TTransacaoStatus);
        function GetID: ansistring;
        function GetChaveTransacao: ansistring;


    public
        constructor Create(VP_Comando, VP_Terminal_Tipo, VP_Doc: ansistring; VP_Terminal_ID: int64; VP_TransacaoString: ansistring);
        destructor Destroy; override;
        function AsString: ansistring;
        function TempoAguarda: integer;
        property erro: integer read GetErro write SetErro;
        property erroDescricao: string read GetErroDescricao write SetErroDescricao;
        property ID: ansistring read GetID;
        property chaveTransacao: ansistring read GetChaveTransacao;
        property STATUS: TTransacaoStatus read GetSTATUS write SetStatus;
    end;


    { TDFuncoes }

    TDFuncoes = class(TDataModule)
    private
    public
    end;

procedure StrToRxMemData(VP_Dados: ansistring; var VO_MemDataSet: TRxMemoryData);
function RxMemDataToStr(VO_MemDataSet: TRxMemoryData): ansistring;
function ZQueryToStrRxMemData(VO_ZQuery: TZQuery): ansistring;
procedure CriarChaveTerminal(VP_TipoChave: TTipoChave; VP_ValorChave: string; var VO_Chave: ansistring);
{$IF DEFINED(OPEN_TEF) OR DEFINED(TEF_LIB) or DEFINED(com_lib)}
procedure GravaLog(VP_Arquivo: string; VP_Modulo_ID: integer; VP_Tag_Comando, VP_Unit, VP_Linha, VP_Ocorrencia, VP_Tag: ansistring; VP_CodigoErro: integer;VP_Debug:Boolean=True);
{$ENDIF }
function CalculaDigito(Texto: string): string;
function PermissaoToStr(VP_Permissao: TPermissao): ansistring;
function StrToPermissao(VP_Permissao: ansistring): TPermissao;
function TipoTagToStr(VP_TipoTag: integer): ansistring;
function StrToTipoTag(VP_TipoTag: ansistring): integer;
function ConexaoStatusToInt(VP_ConexaoStatus: TConexaoStatus): integer;
function IntToConexaoStatus(VP_ConexaoStatus: integer): TConexaoStatus;
function ConexaoTipoToInt(VP_ConexaoTipo: TConexaoTipo): integer;
function ConexaoTipoToStr(VP_ConexaoTipo: TConexaoTipo): string;
function IntToConexaoTipo(VP_ConexaoTipo: integer): TConexaoTipo;
function IntToTransacaoStatus(VP_TranscaoStatus: integer): TTransacaoStatus;
function TransacaoStatusToInt(VP_TransacaoStatus: TTransacaoStatus): integer;
function PinPadModeloToInt(VP_PinPadModelo: TPinPadModelo): integer;
function PinPadModeloTipoToStr(VP_PinPadModelo: TPinPadModelo): string;
function IntToPinPadModelo(VP_PinPadModelo: integer): TPinPadModelo;
function StrToPinPadModelo(VP_PinPadModelo: string): TPinPadModelo;
function FormataDoc(VP_Tipo: TTipoDocumento; VP_Documento: string): string;
function TempoPassouMiliSegundos(VP_Agora: TDateTime): Real;
procedure StrToImagem(Dados: string; var Imagem: Timage; Tipo_Imagem: TImagem = TI_JPG);
procedure ImagemToStr(var Dados: string; Imagem: TImage);
procedure BarcodeToStr(var Dados: string; Barcode: TBarcodeQR);


procedure CopiaDadosSimples(VO_TOrigemMemDataset: TRxMemoryData; VO_TDestinoMemDataset: TRxMemoryData; VL_Linha: boolean = False);

function mensagemcreate(var VP_Mensagem: Pointer): integer; cdecl;
function mensagemcarregatags(VP_Mensagem: Pointer; VP_Dados: PChar): integer; cdecl;
function mensagemcomando(VP_Mensagem: Pointer; var VO_Dados: PChar): integer; cdecl;
function mensagemcomandodados(VP_Mensagem: Pointer; var VO_Dados: PChar): integer; cdecl;
procedure mensagemfree(VP_Mensagem: Pointer); cdecl;
function mensagemaddtag(VP_Mensagem: Pointer; VP_Tag, VP_Dados: PChar): integer; cdecl;
function mensagemaddcomando(VP_Mensagem: Pointer; VP_Tag, VP_Dados: PChar): integer; cdecl;
function mensagemtagasstring(VP_Mensagem: Pointer; var VO_Dados: PChar): integer; cdecl;
function mensagemtagcount(VP_Mensagem: Pointer): integer; cdecl;
function mensagemgettag(VP_Mensagem: Pointer; VP_Tag: PChar; var VO_Dados: PChar): integer; cdecl;
function mensagemgettagidx(VP_Mensagem: Pointer; VL_Idx: integer; var VO_Tag: PChar; var VO_Dados: PChar): integer; cdecl;
function mensagemtagtostr(VP_Mensagem: Pointer; var VO_Dados: PChar): integer; cdecl;
procedure mensagemlimpar(VP_Mensagem: Pointer); cdecl;
function mensagemerro(VP_CodigoErro: Integer; var VO_RespostaMensagem: PChar): integer; cdecl;



var
    VF_Sequencia: longint;
    VF_CriticoLog: TRTLCriticalSection;

const
    Letra: array [0..35] of string = ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'X', 'Z', 'W',
        'Y', 'Z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9');


implementation

function CalculaDigito(Texto: string): string;
var
    i, k, Soma, Digito: integer;
begin
    Result := '00';
    Soma := 990;
    k := 23;
    for i := Length(Texto) downto 1 do
    begin
        Soma := Soma + (Ord(Texto[i]) - Ord('0')) * k;
        Inc(k);
        if (k > 9) then
            k := 2;
    end;
    Digito := Soma mod 101;
    if Digito >= 100 then
        Digito := 0;
    Result := IntToStr(Digito);
    if Length(Result) < 2 then
        Result := '0' + Result;
end;

{function GetAdapterInfo(Lana: char): string;
var
    Adapter: TADAPTER_STATUS;
    NCB: _NCB;
begin
    FillChar(NCB, SizeOf(NCB), 0);
    NCB.ncb_command := byte(NCBRESET);
    NCB.ncb_lana_num := byte(Lana);
    if Netbios(@NCB) <> byte(NRC_GOODRET) then
    begin
        Result := 'Address not known';
        Exit;
    end;

    FillChar(NCB, SizeOf(NCB), 0);
    NCB.ncb_command := byte(NCBASTAT);
    NCB.ncb_lana_num := byte(Lana);
    NCB.ncb_callname[0] := byte('*');

    FillChar(Adapter, SizeOf(Adapter), 0);
    NCB.ncb_buffer := @Adapter;
    NCB.ncb_length := SizeOf(Adapter);
    if Netbios(@NCB) <> byte(NRC_GOODRET) then
    begin
        Result := 'Address not known';
        Exit;
    end;
    Result :=
        IntToHex(byte(Adapter.adapter_address[0]), 2) + '-' +
        IntToHex(byte(Adapter.adapter_address[1]), 2) + '-' +
        IntToHex(byte(Adapter.adapter_address[2]), 2) + '-' +
        IntToHex(byte(Adapter.adapter_address[3]), 2) + '-' +
        IntToHex(byte(Adapter.adapter_address[4]), 2) + '-' +
        IntToHex(byte(Adapter.adapter_address[5]), 2);
end;

function GetMACAddress: string;
var
    AdapterList: TLANA_ENUM;
    NCB: _NCB;
begin
    FillChar(NCB, SizeOf(NCB), 0);
    NCB.ncb_command := byte(NCBENUM);
    NCB.ncb_buffer := @AdapterList;
    NCB.ncb_length := SizeOf(AdapterList);
    Netbios(@NCB);
    if byte(AdapterList.length) > 0 then
        Result := GetAdapterInfo(char(AdapterList.lana[0]))
    else
        Result := 'Address not known';
end;
 }

procedure StrToImagem(Dados: string; var Imagem: Timage; Tipo_Imagem: TImagem = TI_JPG);
var
    JP: TJPEGImage;
    PNG: TPortableNetworkGraphic;
    BPM: TBitmap;
    Sm: TStringStream;
    i: integer;
    S, L: string;
begin
    s := '';
    L := '';
    if Dados = '' then
    begin
        Imagem.Picture.Graphic := nil;
        exit;
    end;

    for i := 0 to Length(Dados) div 2 - 1 do
    begin
        L := copy(Dados, ((1 + i) * 2) - 1, 2);
        s := s + char(Hex2Dec(L));
    end;


    Sm := TStringStream.Create(s);


    if Length(s) > 5 then
    begin
        if ((char(s[2]) = 'P') and (char(s[3]) = 'N') and (char(s[4]) = 'G')) then
            Tipo_Imagem := TI_Png;
        if ((char(s[1]) = 'B') and (char(s[2]) = 'M')) then
            Tipo_Imagem := TI_BMP;
    end;


    if Tipo_Imagem = TI_JPG then
    begin
        JP := TJPEGImage.Create;
        JP.LoadFromStream(Sm);
        Imagem.Picture.Assign(JP);
        JP.Free;
        Sm.Free;
    end
    else
    if Tipo_Imagem = TI_Png then
    begin
        PNG := TPortableNetworkGraphic.Create;
        PNG.LoadFromStream(Sm);
        Imagem.Picture.Assign(PNG);
        PNG.Free;
        Sm.Free;
    end
    else
    if Tipo_Imagem = TI_BMP then
    begin
        BPM := TBitmap.Create;
        BPM.LoadFromStream(Sm);
        Imagem.Picture.Assign(BPM);
        BPM.Free;
        Sm.Free;
    end;

end;

procedure ImagemToStr(var Dados: string; Imagem: TImage);
var
    Sm: TStringStream;
    I: integer;
    S: string;
begin
    Dados := '';
    Sm := TStringStream.Create('');
    Imagem.Picture.SaveToStream(Sm);
    S := sm.DataString;

    for i := 0 to Length(S) - 1 do
        Dados := Dados + HexStr(Ord(S[i + 1]), 2);


    Sm.Free;
end;

procedure BarcodeToStr(var Dados: string; Barcode: TBarcodeQR);
var
    bmp: TFPImageBitmap;
    img: TImage;
begin
    bmp := TBitmap.Create;
    img := TImage.Create(nil);
    try
        bmp.SetSize(Barcode.Width, Barcode.Height);
        bmp.Canvas.Brush.Color := clWhite;
        bmp.Canvas.FillRect(0, 0, bmp.Width, bmp.Height);
        Barcode.PaintOnCanvas(bmp.Canvas, Rect(0, 0, bmp.Width, bmp.Height));

        img.Picture.Assign(bmp);

        ImagemToStr(Dados, img);


    finally
        bmp.Free;
        img.Free;
    end;

end;


function mensagemcreate(var VP_Mensagem: Pointer): integer; cdecl;
begin
    Result := 0;
    Pointer(VP_Mensagem) := pointer(TMensagem.Create);

end;

function mensagemcarregatags(VP_Mensagem: Pointer; VP_Dados: PChar): integer; cdecl;
begin
    Result := TMensagem(VP_Mensagem).CarregaTags(VP_Dados);
end;

function mensagemcomando(VP_Mensagem: Pointer; var VO_Dados: PChar): integer; cdecl;
var
    VL_Dados: ansistring;

begin
    Result := 0;
    VL_Dados := TMensagem(VP_Mensagem).Comando();
    VO_Dados := StrAlloc(Length(VL_Dados) + 1);
    StrPCopy(VO_Dados, VL_Dados);
end;

function mensagemcomandodados(VP_Mensagem: Pointer; var VO_Dados: PChar): integer; cdecl;
var
    VL_String: string;
begin
    Result := 0;
    VL_String := TMensagem(VP_Mensagem).ComandoDados();
    VO_Dados := StrAlloc(Length(VL_String) + 1);
    StrPCopy(VO_Dados, VL_String);
end;

procedure mensagemfree(VP_Mensagem: Pointer); cdecl;
begin
    if Assigned(VP_Mensagem) then
        TMensagem(VP_Mensagem).Free;
end;

function mensagemaddtag(VP_Mensagem: Pointer; VP_Tag, VP_Dados: PChar): integer; cdecl;
begin
    Result := TMensagem(VP_Mensagem).AddTag(VP_Tag, VP_Dados);
end;

function mensagemaddcomando(VP_Mensagem: Pointer; VP_Tag, VP_Dados: PChar): integer; cdecl;
begin
    Result := TMensagem(VP_Mensagem).AddComando(VP_Tag, VP_Dados);
end;

function mensagemtagasstring(VP_Mensagem: Pointer; var VO_Dados: PChar): integer; cdecl;
var
    VL_String: string;
begin
    Result := 0;
    VL_String := TMensagem(VP_Mensagem).TagsAsString;
    VO_Dados := StrAlloc(Length(VL_String) + 1);
    StrPCopy(VO_Dados, VL_String);
end;

function mensagemtagcount(VP_Mensagem: Pointer): integer; cdecl;
begin
    Result := TMensagem(VP_Mensagem).TagCount;
end;

function mensagemgettag(VP_Mensagem: Pointer; VP_Tag: PChar; var VO_Dados: PChar): integer; cdecl;
var
    VL_Dados: ansistring;
begin
    VL_Dados := '';
    Result := TMensagem(VP_Mensagem).GetTag(VP_Tag, VL_Dados);

    VO_Dados := StrAlloc(Length(VL_Dados) + 1);
    StrPCopy(VO_Dados, VL_Dados);

end;

function mensagemgettagidx(VP_Mensagem: Pointer; VL_Idx: integer; var VO_Tag: PChar; var VO_Dados: PChar): integer; cdecl;
var
    VL_Dados, VL_Tag: ansistring;
begin
    VL_Tag := '';
    VL_Dados := '';
    Result := TMensagem(VP_Mensagem).GetTag(VL_Idx, VL_Tag, VL_Dados);

    VO_Dados := StrAlloc(Length(VL_Dados) + 1);
    StrPCopy(VO_Dados, VL_Dados);

    VO_Tag := StrAlloc(Length(VL_Tag) + 1);
    StrPCopy(VO_Tag, VL_Tag);
end;

function mensagemtagtostr(VP_Mensagem: Pointer; var VO_Dados: PChar): integer; cdecl;
var
    VL_Dados: ansistring;

begin
    VL_Dados := '';
    Result := TMensagem(VP_Mensagem).TagToStr(VL_Dados);
    VO_Dados := StrAlloc(Length(VL_Dados) + 1);
    StrPCopy(VO_Dados, VL_Dados);
end;

procedure mensagemlimpar(VP_Mensagem: Pointer); cdecl;
begin
    TMensagem(VP_Mensagem).Limpar;
end;


{$R *.lfm}

{ TErroMensagem }


function mensagemerro(VP_CodigoErro: Integer; var VO_RespostaMensagem: PChar): integer; cdecl;
var
    VL_String:String;
begin

    VO_RespostaMensagem := StrAlloc(2);
    StrPCopy(VO_RespostaMensagem, '');

    Result := 0;

    if VP_CodigoErro = 0 then
        exit
    else
    begin
        case VP_CodigoErro of
            2: VL_String := 'PORTA PINPAD NÃO INFORMADA';
            3: VL_String := 'MODELO PINPAD NÃO INFORMADO';
            4: VL_String := 'MODELO PINPAD NÃO SUPORTADO';
            5: VL_String := 'FALHA NA CONEXÃO COM PINPAD';
            6: VL_String := 'PINPAD RETORNOU FALHA(CONSULTA Nº DA FALHA NO RETORNO AUXILIAR)';
            7: VL_String := 'DLL OU S.O DO PINPAD NÃO ENCONTRADA';
            8: VL_String := 'DLL OU S.O DO PINPAD NÃO COMPATÍVEL(VERIFIQUE 32 OU 64 BITS)';
            9: VL_String := 'HOST  NÃO INFORMADO PARA O TEF';
            10: VL_String := 'HOST NÃO COMPATÍVEL PARA O TEF';
            11: VL_String := 'PORTA NÃO INFORMADA PARA O TEF';
            12: VL_String := 'PORTA NÃO COMPATÍVEL PARA O TEF';
            13: VL_String := 'VERSÃO_COMUNICAÇÃO NÃO INFORMADA PARA O TEF';
            14: VL_String := 'VERSÃO_COMUNICAÇÃO NÃO COMPATÍVEL PARA O TEF';
            15: VL_String := 'CHAVE NÃO INFORMADA PARA O TEF';
            16: VL_String := 'CHAVE NÃO COMPATÍVEL PARA O TEF';
            17: VL_String := 'VERSÃO DLL DO TEF NÃO COMPATÍVEL (SUGERE ATUALIZAÇÃO)';
            18: VL_String := 'PACOTE COM A PRIMEIRA TAG DIFERENTE DE ‘0000’';
            19: VL_String := 'ERRO O TAMANHO DO PACOTE NÃO PODE SER ZERO';
            20: VL_String := 'ERRO O TAMANHO DO PACOTE DIFERENTE DO TAMANHO DA MENSAGEM';
            21: VL_String := 'ERRO OS DADOS DO PACOTE MAIOR QUE OS DADOS DA MENSAGEM';
            22: VL_String := 'ERRO NÃO EXISTE PACOTE PARA A FUNÇÃO GET DA TAG';
            23: VL_String := 'ERRO NÃO EXISTE PACOTE PARA A FUNÇÃO “TAGTOSTR”';
            24: VL_String := 'NÃO FOI POSSÍVEL ENVIAR MENSAGEM';
            25: VL_String := 'NÃO FOI POSSÍVEL CONECTAR AO SERVIDOR PARA ESCUTAR';
            26: VL_String := 'NÃO FOI POSSÍVEL CONECTAR AO SERVIDOR ABERTURA SOCKET';
            27: VL_String := 'ERRO NÃO EXISTE PACOTE PARA A FUNÇÃO ADD DA TAG';
            28: VL_String := 'ERRO, PARÂMETRO NULO OU DIFERENTE DA ESTRUTURA DA TAG';
            29: VL_String := 'ERRO TAG NÃO LOCALIZADA NO PACOTE DA FUNÇÃO GET DA TAG';
            30: VL_String := 'DADOS DO PACOTE MAL FORMATADO OU INCOMPATÍVEL, IMPOSSÍVEL DE LER';
            31: VL_String := 'CHAVE PUBLICA NÃO LOCALIZADA';
            32: VL_String := 'PROBLEMA NAS TROCAS DE CHAVES NO CONECTAR';
            33: VL_String := 'SOCKET DO SERVIDOR VINCULADO ESTA DESCONECTADO';
            34: VL_String := 'LOGIN RECUSADO';
            35: VL_String := 'SERVIDOR NÃO ESTA EM STATUS DE LOGADO';
            36: VL_String := 'CHAVE NÃO LOCALIZADA PARA OPENTEF';
            37: VL_String := 'SENHA DE ACESSO NÃO INFORMADO PARA O TEF';
            38: VL_String := 'IP NÃO NÃO COMPATIVEL PARA O TERMINAL';
            39: VL_String := 'SENHA NÃO COMPATÍVEL PARA O TERMINAL';
            40: VL_String := 'ERRO VALIDAÇÃO DO TERMINAL';
            41: VL_String := 'CHAVE DO TERMINAL NÃO LOCALIZADA';
            42: VL_String := 'TIPO DE PERMISSÃO NÃO INFORMADA PARA O TEF';
            43: VL_String := 'REGISTRO EM DUPLICIDADE NO BANCO DE DADOS';
            44: VL_String := 'ERRO NA INCLUSÃO DO REGISTRO';
            45: VL_String := 'PERMISSÃO NÃO AUTORIZADO PARA ESTE PROCEDIMENTO';
            46: VL_String := 'ERRO NA ALTERAÇÃO DO REGISTRO';
            47: VL_String := 'DADOS INFORMADO NÃO PODE SER ZERO';
            48: VL_String := 'TABELA SEM REGISTRO NO BANCO DE DADOS';
            49: VL_String := 'DADOS CHAVES PARA O CADASTRO NÃO PODEM SOFRER ALTERAÇÃO';
            50: VL_String := 'BIBLIOTECA DO PINPAD NÃO FOI POSSIVEL CARREGAR';
            51: VL_String := 'TIPO DE LEITURA DE CARTÃO NÃO SUPORTADO';
            52: VL_String := 'CAMPO OBRIGATÓRIO NÃO PODE SER NULO';
            53: VL_String := 'NÃO FOI POSSIVEL ENVIAR A MENSAGEM DE RETORNO PARA O ID INFORMADO';
            54: VL_String := 'NÃO FOI POSSIVEL INICIALIZAR O MODULO';
            55: VL_String := 'ERRO NA PESQUISA DA TABELA';
            56: VL_String := 'NÃO FOI ENCONTRADO NENHUMA CONFIGURAÇÃO DE MENU DE CAIXA';
            57: VL_String := 'ERRO NO FLUXO DAS TRANSAÇÕES DA TAG 0018';
            58: VL_String := 'ERRO AO CRIAR A TRANSACAO';
            59: VL_String := 'ERRO AO PEGAR O STATUS DA TRANSACAO';
            60: VL_String := 'ERRO AO EXCLUIR UMA TRANSACAO NO TEF_LIB';
            61: VL_String := 'ERRO AO RECEBER A FUNCAO TRANSACAO CREATE DO OPENTEF';
            62: VL_String := 'ERRO NO PEDIDO DE CRIAÇÃO DE TRANSAÇÃO';
            63: VL_String := 'BIN JA ESTAVA CADASTRADO PARA OUTRO MODULO';
            64: VL_String := 'REGISTRO DE MODULO NÃO CARREGADO OU NÃO LOCALIZADO';
            65: VL_String := 'NÃO FOI POSSIVEL ATUALIZAR A TABELA DE BINS';
            66: VL_String := 'CONEXAO DO TEMPORIZADOR NAO ENCONTRADA';
            67: VL_String := 'A TRANSMISSAO NAO RESPONDIDA EM TEMPO HABIL';
            68: VL_String := 'DADOS DA TRANSMISSÃO NÃO TEM COMANDO 00D1';
            69: VL_String := 'A COMUNICACAO FOI ABORTADA';
            70: VL_String := 'Modulo config não carregado para incluir solicitação';
            71: VL_String := 'NAO FOI POSSIVEL ATUALIZAR A TABELA DE MENUS';
            72: VL_String := 'MENU JA ESTAVA CADASTRADO PARA OUTRO MODULO';
            73: VL_String := 'MENU NÃO ESTA NA LISTA DE MENUS OFICIAIS HABILITADOS USE TAG INICIO “FF”';
            74: VL_String := 'BIN inválido';
            75: VL_String := 'Tag do botao do menu inválido';
            76: VL_String := 'Texto do botao do menu inválido';
            77: VL_String := 'pinpad_lib  NÃO CARREGADO';
            78: VL_String := 'COMANDO NAO IMPLEMENTADO PELO PINPD';
            79: VL_String := 'Não foi possível achar uma operadora para processar o cartão';
            80: VL_String := 'Essa solicitação de aprovação não esta em conformidade';
            81: VL_String := 'ESSA CONEXAO NÃO PERMITE APROVAÇÃO';
            82: VL_String := 'ERRO NA EXCLUSÃO DO REGISTRO';
            83: VL_String := 'A CONEXÃO FOI DESCONECTA INESPERADAMENTE';
            84: VL_String := 'A OPERADORA/ADQUIRENTE EXIGE CRIPTOGRAFIA, MAIS NÃO ENVIOU AS CHAVES';
            85: VL_String := 'Erro de tempo em capturar a senha no pinpad';
            86: VL_String := 'Erro ao cancelar uma transação';
            87: VL_String := 'Erro na exclusão, TAG oficial não pode ser excluida';
            88: VL_String := 'TAG não é um valor Hexadecimal';
            89: VL_String := 'Chave da transação não localizada';
            90: VL_String := 'Autorização da venda não localizada';
            91: VL_String := 'Código da loja não localizado';

            else
            begin
                Result := 1;
                VL_String := 'Erro Desconhecido ou não catalogado';
            end;
        end;

            VO_RespostaMensagem := StrAlloc(Length(VL_String)+1);
            StrPCopy(VO_RespostaMensagem, VL_String);
    end;
end;


{ TTemporizador }

constructor TTemporizador.Create;
begin
    VF_Sequencia := VF_Sequencia + 1;
    V_ID := IntToStr(VF_Sequencia);
    inherited Create;
    V_ID := V_ID + FormatDateTime('dd/mm/yyyy hh:mm:ss:zzz', Now);
    Randomize;
    V_Executado := False;
    V_Aborta := False;
    V_Dados := '';
    V_Aguardando := False;
    V_ID := V_ID + IntToStr(Random(999));
end;

procedure TTemporizador.parar;
begin
    V_Executado := True;
    V_Aguardando := False;
    V_Aborta := False;
    if Assigned(fTEmporizadorTThread) then
        if not fTEmporizadorTThread.f_parar then
        begin
            fTEmporizadorTThread.f_parar := True;
            fTEmporizadorTThread.Terminate;
        end;
end;

procedure TTemporizador.abortar;
begin
    V_Executado := False;
    V_Aguardando := False;
    V_Aborta := True;
    if Assigned(fTEmporizadorTThread) then
        if not fTEmporizadorTThread.f_parar then
        begin
            fTEmporizadorTThread.f_parar := True;
            fTEmporizadorTThread.Terminate;
        end;

end;

function TTemporizador.aguarda(VP_Tempo: cardinal; VP_Reaguardar: boolean; VP_Temporizador: Pointer): TAguardaEvento;
begin
    V_Aguardando := True;
    Result := agTempo;
    try
        if VP_Reaguardar then
            V_Executado := False;

        if V_Executado then
        begin
            Result := agEvento;
            Exit;
        end;
        fTEmporizadorTThread := TTEmporizadorTThread.Create(True, VP_Temporizador);
        fTEmporizadorTThread.fTempo := VP_Tempo;
        fTEmporizadorTThread.Start;
        fTEmporizadorTThread.WaitFor;
        if Assigned(fTEmporizadorTThread) then
        begin
            //            fTEmporizadorTThread.free;
            fTEmporizadorTThread := nil;
        end;

        if V_Executado then
            Result := agEvento
        else
            Result := agTempo;
        if V_Aborta then
            Result := agAborta;

    finally
        V_Aguardando := False;
    end;

end;

destructor TTemporizador.Destroy;
begin
    if Assigned(fTEmporizadorTThread) then
        if not fTEmporizadorTThread.f_parar then
        begin
            fTEmporizadorTThread.f_parar := True;
            fTEmporizadorTThread.Terminate;
            fTEmporizadorTThread.WaitFor;
        end;
    inherited Destroy;
end;

{ TTEmporizadorEvento }

procedure TTEmporizadorTThread.Execute;
var
    VL_Data: TDateTime;
begin
    VL_Data := now;
    while not Terminated do
    begin
        sleep(1);
        if ((fTempo <> INFINITE) and
            ((TimeStampToMSecs(DateTimeToTimeStamp(now)) - TimeStampToMSecs(DateTimeToTimeStamp(VL_Data))) > fTempo)) then
        begin
            if Assigned(fTemporizador) then
                TTemporizador(fTemporizador).fEvento := agTempo;
            exit;
        end;
    end;
end;



constructor TTEmporizadorTThread.Create(VP_Suspenso: boolean; VP_Temporizador: Pointer);
begin
    inherited Create(VP_Suspenso);
    TTemporizador(VP_Temporizador).fEvento := agEvento;
    fTemporizador := VP_Temporizador;
    FreeOnTerminate := True;
    f_parar := False;

end;

{ TTransacao }

function TTransacao.GetErro: integer;
begin
    Result := fMensagem.GetTagAsInteger('004D');
end;

function TTransacao.GetErroDescricao: string;
begin
    Result := fMensagem.GetTagAsAstring('004A');
end;

procedure TTransacao.SetErro(VP_Erro: integer);
begin
    fMensagem.AddTag('004D', VP_Erro);
end;

function TTransacao.GetStatus: TTransacaoStatus;
begin
    Result := IntToTransacaoStatus(fMensagem.GetTagAsInteger('00A4'));
end;

procedure TTransacao.SetErroDescricao(VP_Descricao: string);
begin
    fMensagem.AddTag('004A', VP_Descricao);
end;

procedure TTransacao.SetStatus(VP_Status: TTransacaoStatus);
begin
    fMensagem.AddTag('00A4', TransacaoStatusToInt(VP_Status));
end;

function TTransacao.GetID: ansistring;
begin
    Result := fMensagem.GetTagAsAstring('0034');
end;

function TTransacao.GetChaveTransacao: ansistring;
begin
    Result := fMensagem.GetTagAsAstring('00F1');
end;


constructor TTransacao.Create(VP_Comando, VP_Terminal_Tipo, VP_Doc: ansistring; VP_Terminal_ID: int64; VP_TransacaoString: ansistring);
begin
    inherited Create;
    fcomando := VP_Comando;
    fMensagem := TMensagem.Create;

    if VP_TransacaoString <> '' then
    begin
        fMensagem.CarregaTags(VP_TransacaoString);
        fMensagem.AddComando('007A', fMensagem.ComandoDados());
        Exit;
    end;

    VF_Sequencia := VF_Sequencia + 1;
    fMensagem.AddComando('007A', '');
    fMensagem.AddTag('00A3', VP_Terminal_ID);
    fMensagem.AddTag('0051', 20000);
    fMensagem.AddTag('00A2', VP_Terminal_Tipo);
    fMensagem.AddTag('0091', VP_Doc);
    fMensagem.AddTag('007C', FloatToStr(Now));
    fMensagem.AddTag('00A4', TransacaoStatusToInt(tsAguardandoComando));
    fMensagem.AddTag('0034', IntToStr(VF_Sequencia) + '-' + VP_Terminal_Tipo + '-' + IntToStr(VP_Terminal_ID) + '-' +
        FormatDateTime('dd/mm/yyyy hh:mm:ss:zzz', Now));

end;

destructor TTransacao.Destroy;
begin
    fMensagem.Free;
    fTemporizador.Free;
    inherited Destroy;
end;

function TTransacao.AsString: ansistring;
begin
    Result := fMensagem.TagsAsString;
end;

function TTransacao.TempoAguarda: integer;
begin
    Result := fMensagem.GetTagAsInteger('0051');
end;

{ TDFuncoes }



function RxMemDataToStr(VO_MemDataSet: TRxMemoryData): ansistring;
var
    VL_MemString: TStringStream;
    VL_Mem: TMemoryStream;
    VL_String: ansistring;
    VL_bytes: array of byte;
    VL_i: integer;
begin
    VL_bytes := nil;

    VL_MemString := TStringStream.Create;
    VL_Mem := TMemoryStream.Create;

    VO_MemDataSet.SaveToStream(VL_Mem);

    VL_Mem.SaveToStream(VL_MemString);

    VL_String := VL_MemString.DataString;

    //  converte em bytes
    for VL_i := 0 to Length(VL_String) - 1 do
    begin
        SetLength(VL_bytes, Length(VL_bytes) + 1);
        VL_bytes[VL_i] := Ord(VL_String[VL_i + 1]);
    end;
    // converte em hex
    VL_String := '';
    for VL_i := 0 to Length(VL_bytes) - 1 do
        VL_String := VL_String + HexStr(VL_bytes[VL_i], 2);

    Result := VL_String;
    VL_MemString.Free;
    VL_Mem.Free;
end;

procedure StrToRxMemData(VP_Dados: ansistring; var VO_MemDataSet: TRxMemoryData);
var
    VL_bytes: array of byte;
    VL_i: integer;
    VL_String: ansistring;
    VL_MemString: TStringStream;
    VL_Mem: TMemoryStream;
begin

    VL_bytes := nil;
    // converte em bytes
    if VP_Dados = '' then
        exit;

    for VL_i := 0 to (Length(VP_Dados) div 2) - 1 do
    begin
        SetLength(VL_bytes, Length(VL_bytes) + 1);
        VL_bytes[VL_i] := Hex2Dec(copy(VP_Dados, ((VL_i + 1) * 2) - 1, 2));
    end;

    VL_String := '';


    for VL_i := 0 to Length(VL_bytes) - 1 do
    begin
        SetLength(VL_String, Length(VL_String) + 1);
        VL_String[VL_i + 1] := char(VL_bytes[VL_i]);
    end;

    VL_MemString := TStringStream.Create(VL_String);
    VL_Mem := TMemoryStream.Create;

    VL_MemString.SaveToStream(VL_Mem);

    VO_MemDataSet.LoadFromStream(VL_Mem);
    VL_MemString.Free;
    VL_Mem.Free;

end;


function ZQueryToStrRxMemData(VO_ZQuery: TZQuery): ansistring;
var
    VL_MemDataset: TRxMemoryData;
begin
    Result := '';
    VL_MemDataset := TRxMemoryData.Create(nil);
    try
        VO_ZQuery.First;
        VL_MemDataset.LoadFromDataSet(VO_ZQuery, MaxInt, lmCopy);
        Result := RxMemDataToStr(VL_MemDataset);
    finally
        VL_MemDataset.Free;
    end;
end;


procedure CriarChaveTerminal(VP_TipoChave: TTipoChave; VP_ValorChave: string; var VO_Chave: ansistring);
var
    VL_Chave: ansistring;
    I, II: integer;
    Intervalo: int64;
    VL_String: string;
begin
    VL_Chave := '';
    VO_Chave := '';
    Randomize;
    case VP_TipoChave of
        tcC50:
        begin
            for I := 0 to 50 do
            begin
                if Length(VL_Chave) < 50 then
                    VL_Chave := VL_Chave + IntToStr(Random(99)) + IntToStr(Random(999));
            end;
            VO_Chave := Copy(VL_Chave, 1, 50);
        end;
        tcPDV:
        begin
            VL_Chave := '';
            VL_String := '';
            if length(VP_ValorChave) = 0 then
                exit;
            VL_String := IntToStr(RandomRange(10000000, 99999999));
            VL_String := Copy(VL_String, Length(VL_String) - 8, 8);

            for I := 0 to Length(VP_ValorChave) - 1 do
            begin
                for II := 0 to 10 - 1 do
                begin
                    VL_String := floattostr(trunc((strtofloat(VL_String) * 0.9)));
                    Intervalo := StrToInt(Copy(VL_String, Length(VL_String) - 2, 2));
                    if Intervalo > 35 then
                        Intervalo := Intervalo div 3;
                    VL_Chave := VL_Chave + Letra[Intervalo];
                end;
                VL_Chave := VL_Chave + COPY(VP_ValorChave, I, 1);
            end;
            VO_Chave := COPY(VL_Chave, 1, 50);
        end;
        else
        begin
            VL_Chave := '';
            VL_String := '';
            if length(VP_ValorChave) = 0 then
                exit;
            VL_String := IntToStr(RandomRange(10000000, 99999999));
            VL_String := Copy(VL_String, Length(VL_String) - 8, 8);

            for I := 0 to Length(VP_ValorChave) - 1 do
            begin
                for II := 0 to 10 - 1 do
                begin
                    VL_String := floattostr(trunc((strtofloat(VL_String) * 0.9)));
                    Intervalo := StrToInt(Copy(VL_String, Length(VL_String) - 2, 2));
                    if Intervalo > 35 then
                        Intervalo := Intervalo div 3;
                    VL_Chave := VL_Chave + Letra[Intervalo];
                end;
                VL_Chave := VL_Chave + COPY(VP_ValorChave, I, 1);
            end;
            VO_Chave := COPY(VL_Chave, 1, 50);
        end;
    end;
end;

{$IF DEFINED(OPEN_TEF) OR DEFINED(TEF_LIB)or defined(com_lib)}
procedure GravaLog(VP_Arquivo: string; VP_Modulo_ID: integer; VP_Tag_Comando, VP_Unit, VP_Linha, VP_Ocorrencia, VP_Tag: ansistring; VP_CodigoErro: integer;VP_Debug:Boolean=True);
var
    VL_Arquivo: TextFile;
begin
    if VP_Arquivo = '' then
        exit;

    if not VP_Debug then
    Exit;

    EnterCriticalSection(VF_CriticoLog);
    try
        AssignFile(VL_Arquivo, PChar(VP_Arquivo));

        if not FileExists(VP_Arquivo) then
            Rewrite(VL_Arquivo)
        else
            Append(VL_Arquivo);

        WriteLn(VL_Arquivo, '[ Data:' + DateToStr(now) + '] - [ Hora:' + TimeToStr(now) + '] - [ Linha:' + VP_Linha +
            '] - [ Modulo_ID:' + IntToStr(VP_Modulo_ID) +
            ']- [ TagComando:' + VP_Tag_Comando + '] - [ Programa:' + C_Programa + '] - [ Unit:' +
            VP_Unit + '] - [ VersaoMensage:' + IntToStr(C_Mensagem) + '] - [ Versao:' + IntToStr(C_Versao[0]) + '.' +
            IntToStr(C_Versao[1]) + '.' + IntToStr(C_Versao[1]) + '] -  [ CodigoErro:' +
            IntToStr(VP_CodigoErro) + ']  - [ Ocorrencia:' + VP_Ocorrencia + '] - [ TMensagem:' + VP_Tag + ']');

        CloseFile(VL_Arquivo);

    finally
        LeaveCriticalSection(VF_CriticoLog);
    end;

end;

{$ENDIF}

function PermissaoToStr(VP_Permissao: TPermissao): ansistring;
begin
    case VP_Permissao of
        pmA: Result := 'A';
        pmC: Result := 'C';
        pmU: Result := 'U';
        pmS: Result := 'S';
        else
            Result := '';
    end;
end;

function StrToPermissao(VP_Permissao: ansistring): TPermissao;
begin
    case VP_Permissao of
        'A': Result := pmA;
        'C': Result := pmC;
        'U': Result := pmU;
        'S': Result := pmS;
        else
            raise Exception.Create('Esse valor:"' + VP_Permissao + '" não é uma permissao');
    end;

end;

function TipoTagToStr(VP_TipoTag: integer): ansistring;
begin
    case VP_TipoTag of
        ord(ttNDF): Result := 'NDF';
        ord(ttCOMANDO): Result := 'COMANDO';
        ord(ttDADOS): Result := 'DADOS';
        ord(ttMENU_PDV): Result := 'MENU_PDV';
        ord(ttMENU_OPERACIONAL): Result := 'MENU_OPERACIONAL';
        ord(ttPINPAD_FUNC): Result := 'PINPAD_FUNC';
        ord(ttMODULO): Result := 'MODULO';
        else
            Result := '';

    end;
end;

function StrToTipoTag(VP_TipoTag: ansistring): integer;
begin

    case VP_TipoTag of
        'NDF': Result := ord(ttNDF);
        'COMANDO': Result := ord(ttCOMANDO);
        'DADOS': Result := ord(ttDADOS);
        'MENU_PDV': Result := ord(ttMENU_PDV);
        'MENU_OPERACIONAL': Result := ord(ttMENU_OPERACIONAL);
        'PINPAD_FUNC': Result := ord(ttPINPAD_FUNC);
        'MODULO': Result := ord(ttMODULO);
        else
            raise Exception.Create('Esse valor:"' +  VP_TipoTag + '" não é um Tipo de Tag Válido');
    end;
end;

function ConexaoStatusToInt(VP_ConexaoStatus: TConexaoStatus): integer;
begin
    Result := Ord(VP_ConexaoStatus);
end;

function TransacaoStatusToInt(VP_TransacaoStatus: TTransacaoStatus): integer;
begin
    Result := Ord(VP_TransacaoStatus);
end;

function PinPadModeloToInt(VP_PinPadModelo: TPinPadModelo): integer;
begin
    Result := Ord(VP_PinPadModelo);
end;

function PinPadModeloTipoToStr(VP_PinPadModelo: TPinPadModelo): string;
begin
    Result := '';
    case VP_PinPadModelo of
        pGERTEC_PPC930: Result := 'GERTEC_PPC930';
        pNDF: Result := 'NDF';
        else
            raise Exception.Create('Esse valor:"' + IntToStr(PinPadModeloToInt(VP_PinPadModelo)) + '" não é um pinpad valido');
    end;
end;

function IntToPinPadModelo(VP_PinPadModelo: integer): TPinPadModelo;
begin
    case VP_PinPadModelo of
        0: Result := pNDF;
        1: Result := pGERTEC_PPC930;

        else
            Result := pNDF;
    end;

end;

function StrToPinPadModelo(VP_PinPadModelo: string): TPinPadModelo;
begin
    VP_PinPadModelo := UpperCase(VP_PinPadModelo);
    case VP_PinPadModelo of
        'NDF': Result := pNDF;
        'GERTEC_PPC930': Result := pGERTEC_PPC930;
        else
            Result := pNDF;
    end;

end;

function FormataDoc(VP_Tipo: TTipoDocumento; VP_Documento: string): string;
begin
    if VP_Tipo = tdCNPJ then
    begin
        if ((Length(VP_Documento) = 0) or (Length(VP_Documento) <> 14)) then
        begin
            Result := '';
            exit;
        end;
        Result := copy(VP_Documento, 0, 2) + '.' +
            copy(VP_Documento, 2, 3) + '.' +
            copy(VP_Documento, 6, 3) + '/' +
            copy(VP_Documento, 9, 4) + '-' +
            copy(VP_Documento, 13, 2);
    end;
    if VP_Tipo = tdCPF then
    begin
        if ((Length(VP_Documento) = 0) or (Length(VP_Documento) <> 11)) then
        begin
            Result := '';
            exit;
        end;
        Result := copy(VP_Documento, 0, 3) + '.' +
            copy(VP_Documento, 3, 3) + '.' +
            copy(VP_Documento, 6, 3) + '-' +
            copy(VP_Documento, 9, 2);
    end;
end;

function IntToTransacaoStatus(VP_TranscaoStatus: integer): TTransacaoStatus;
begin
    Result := tsNaoLocalizada;

    case VP_TranscaoStatus of
        0: Result := tsEfetivada;
        1: Result := tsNegada;
        2: Result := tsCancelada;
        3: Result := tsProcessando;
        4: Result := tsAguardandoComando;
        5: Result := tsNaoLocalizada;
        6: Result := tsInicializada;
        7: Result := tsComErro;
        8: Result := tsAbortada;
        9: Result := tsAguardandoDadosPDV;

    end;

end;


function IntToConexaoStatus(VP_ConexaoStatus: integer): TConexaoStatus;
begin
    Result := csDesconectado;
    case VP_ConexaoStatus of
        0: Result := csDesconectado;
        1: Result := csLink;
        2: Result := csChaveado;
        3: Result := csLogado;
        4: Result := csNaoInicializado;
    end;

end;

function ConexaoTipoToInt(VP_ConexaoTipo: TConexaoTipo): integer;
begin
    Result := Ord(VP_ConexaoTipo);
end;

function ConexaoTipoToStr(VP_ConexaoTipo: TConexaoTipo): string;
begin
    Result := '';
    case VP_ConexaoTipo of
        cnCaixa: Result := 'Caixa';
        cnServico: Result := 'Servico';
    end;

end;

function IntToConexaoTipo(VP_ConexaoTipo: integer): TConexaoTipo;
begin
    Result := cnNaoDefinido;
    case VP_ConexaoTipo of
        0: Result := cnCaixa;
        1: Result := cnServico;
    end;

end;


procedure CopiaDadosSimples(VO_TOrigemMemDataset: TRxMemoryData; VO_TDestinoMemDataset: TRxMemoryData; VL_Linha: boolean);
var
    I: integer;
begin
    if not Assigned(VO_TOrigemMemDataset) then
        exit;
    if not Assigned(VO_TDestinoMemDataset) then
        exit;
    if not VO_TOrigemMemDataset.Active then
        exit;
    if not VO_TDestinoMemDataset.Active then
        exit;
    if VL_Linha = False then
        VO_TOrigemMemDataset.First;
    while not VO_TOrigemMemDataset.EOF do
    begin
        for I := 0 to VO_TOrigemMemDataset.FieldCount - 1 do
        begin
            if VO_TDestinoMemDataset.FindField(VO_TOrigemMemDataset.Fields[I].FieldName) <> nil then
            begin
                if not (VO_TDestinoMemDataset.State in [dsInsert, dsEdit]) then
                    VO_TDestinoMemDataset.Insert;
                VO_TDestinoMemDataset.FindField(VO_TOrigemMemDataset.Fields[I].FieldName).AsString := VO_TOrigemMemDataset.Fields[I].AsString;
            end;
        end;
        if VO_TDestinoMemDataset.State in [DsInsert, DsEdit] then
            VO_TDestinoMemDataset.Post;
        if VL_Linha then
            Break;
        VO_TOrigemMemDataset.Next;
    end;

end;


function TMensagem.GetComando(var VO_Tag: ansistring; var VO_Dados: ansistring): integer;
begin
    Result := 0;
    if Length(fTags) > 0 then
    begin
        VO_Tag := fTags[0].Tag;
        self.GetTag(VO_Tag, VO_Dados);
    end;
end;

function TMensagem.GetComandoInt(var VO_Tag: integer; var VO_Dados: ansistring): integer;
begin
    Result := 0;
    if Length(fTags) > 0 then
    begin
        VO_Tag := Hex2Dec(fTags[0].Tag);
        self.GetTag(fTags[0].Tag, VO_Dados);
    end;
end;


function TMensagem.CarregaTags(VP_Dados: ansistring): integer;
var
    VL_Qtd, VL_Resto, VL_Tamanho: longint;

begin
    Result := 0;
    try
        // zera tags
        SetLength(fTags, 0);

        // testa pacote
        if Copy(VP_Dados, 1, 4) <> '0000' then
        begin
            Result := 18;
            Exit;
        end;

        //tamanho de digitos do tamanho total do pacote
        VL_Qtd := Hex2Dec(copy(VP_Dados, 5, 1));

        // tamanho na mensagem completa
        VL_Tamanho := StrToInt64(copy(VP_Dados, 6, VL_Qtd));

        if VL_Tamanho = 0 then
        begin
            Result := 19;
            Exit;
        end;

        if VL_Tamanho <> Length(VP_Dados) then
        begin
            Result := 20;
            Exit;
        end;

        VP_Dados := Copy(VP_Dados, VL_Qtd + 6, Length(VP_Dados) - (5 + VL_Qtd));

        VL_Resto := Length(VP_Dados);

        while True do
        begin
            SetLength(fTags, Length(fTags) + 1);
            fTags[Length(fTags) - 1].Tag := Copy(VP_Dados, 1, 4);
            fTags[Length(fTags) - 1].Qt := Copy(VP_Dados, 5, 1);
            fTags[Length(fTags) - 1].Tamanho :=
                StrToInt64Def(Copy(VP_Dados, 6, Hex2Dec(fTags[Length(fTags) - 1].Qt)), 0);
            fTags[Length(fTags) - 1].Dados :=
                Copy(VP_Dados, 6 + Hex2Dec(fTags[Length(fTags) - 1].Qt), fTags[Length(fTags) - 1].Tamanho);

            VP_Dados := Copy(VP_Dados, 6 + Hex2Dec(fTags[Length(fTags) - 1].Qt) + fTags[Length(fTags) - 1].Tamanho, MaxInt);

            if Length(VP_Dados) >= VL_Resto then
            begin
                Result := 21;
                Exit;
            end;
            VL_Resto := Length(VP_Dados);

            if VL_Resto = 0 then
                Break;

        end;

    except
        Result := 30;
    end;
end;

function TMensagem.TagToStr(var VO_Dados: ansistring): integer;
var
    VL_Digitos, i: integer;
    VL_TamanhoPacote: longint;
    VL_Dados: ansistring;

begin

    VL_Dados := '';
    if length(fTags) = 0 then
    begin
        Result := 23;
        Exit;
    end;
    for i := 0 to length(fTags) - 1 do
    begin
        VL_Dados := VL_Dados + fTags[i].Tag + fTags[i].Qt + IntToStr(fTags[i].Tamanho) + fTags[i].Dados;
    end;
    VL_TamanhoPacote := length(VL_Dados) + 5;

    VL_Digitos := Length(IntToStr(VL_TamanhoPacote));

    VL_Digitos := Length(IntToStr(VL_TamanhoPacote + VL_Digitos));

    VL_TamanhoPacote := VL_TamanhoPacote + VL_Digitos;

    VL_Dados := '0000' + HexStr((VL_Digitos), 1) + IntToStr(VL_TamanhoPacote) + VL_Dados;
    VO_Dados := VL_Dados;


    Result := 0;
end;

function TMensagem.GetTag(VP_Tag: ansistring; var VO_Dados: ansistring): integer;
var
    i: integer;
begin
    VO_Dados := '';
    //Tag não encontrada no pacote
    Result := 29;

    //Verifica se existe o pacote
    if length(fTags) = 0 then
    begin
        Result := 22;
        Exit;
    end;
    //Verifica se o parametro é nulo ou diferente da estrutura
    if Length(VP_Tag) <> 4 then
    begin
        Result := 28;
        Exit;
    end;
    for i := 0 to length(fTags) - 1 do
    begin
        if fTags[i].Tag = VP_Tag then
        begin
            VO_Dados := fTags[i].Dados;
            Result := 0;
            Exit;
        end;
    end;
end;

function TMensagem.GetTag(VP_Posicao: integer; var VO_Tag: ansistring; var VO_Dados: ansistring): integer;
begin
    Result := 0;
    VO_Dados := '';
    if Length(fTags) > VP_Posicao then
    begin
        VO_Tag := fTags[VP_Posicao].Tag;
        VO_Dados := fTags[VP_Posicao].Dados;
    end;
end;

function TMensagem.GetTag(VP_Posicao: integer; var VO_Tag: TTag): integer;
begin
    Result := 0;
    if Length(fTags) > VP_Posicao then
    begin
        VO_Tag := fTags[VP_Posicao];
    end;
end;

function TMensagem.GetTag(VP_Tag: ansistring; var VO_Dados: int64): integer;
var
    i: integer;
begin
    //Tag não encontrada no pacote

    Result := 29;

    //Verifica se existe o pacote
    if length(fTags) = 0 then
    begin
        Result := 22;
        Exit;
    end;
    //Verifica se o parametro é nulo ou diferente da estrutura
    if Length(VP_Tag) <> 4 then
    begin
        Result := 28;
        Exit;
    end;
    for i := 0 to length(fTags) - 1 do
    begin
        if fTags[i].Tag = VP_Tag then
        begin
            VO_Dados := StrToInt(fTags[i].Dados);
            Result := 0;
            Exit;
        end;
    end;
end;

function TMensagem.GetTagAsAstring(VP_Tag: ansistring): ansistring;
var
    VL_String: ansistring;
begin
    Result := '';
    VL_String := '';
    if GetTag(VP_Tag, VL_String) = 0 then
        Result := VL_String;
end;

function TMensagem.Comando: ansistring;
begin
    Result := '';
    if Length(fTags) > 0 then
    begin
        Result := fTags[0].Tag;
    end;

end;

function TMensagem.ComandoDados: ansistring;
begin
    Result := '';
    if Length(fTags) > 0 then
    begin
        Result := fTags[0].Dados;
    end;

end;

function TMensagem.TagsAsString: ansistring;
begin
    Result := '';
    TagToStr(Result);
end;

function TMensagem.TagCount: integer;
begin
    Result := Length(fTags) - 1;
end;

function TempoPassouMiliSegundos(VP_Agora: TDateTime): Real;
begin
    Result := TimeStampToMSecs(DateTimeToTimeStamp(now)) - TimeStampToMSecs(DateTimeToTimeStamp(VP_Agora));
end;

function TMensagem.GetTagAsInteger(VP_Tag: ansistring): integer;
var
    VL_String: ansistring;
begin
    Result := 0;
    VL_String := '';
    if GetTag(VP_Tag, VL_String) = 0 then
        if VL_String <> '' then
            Result := StrToInt(VL_String);
end;


function TMensagem.AddTag(VP_Tag, VP_Dados: ansistring): integer;
var
    i: integer;

    procedure incluir(VP_Posicao: integer);
    begin
        fTags[VP_Posicao].Tag := VP_Tag;
        fTags[VP_Posicao].Qt := HexStr(length(IntToStr(Length(VP_Dados))), 1);
        fTags[VP_Posicao].Tamanho := Length(VP_Dados);
        fTags[VP_Posicao].Dados := VP_Dados;
    end;

begin
    Result := 0;

    //Verifica se existe o pacote
    if length(fTags) = 0 then
    begin
        AddComando('0000', '');
    end;
    //verifica se o parametro dados contem valor
    for i := 0 to length(fTags) - 1 do
    begin
        if fTags[i].Tag = VP_Tag then
        begin
            incluir(i);
            Exit;
        end;
    end;
    SetLength(fTags, Length(fTags) + 1);
    incluir(Length(fTags) - 1);

end;

function TMensagem.AddTag(VP_Tag: ansistring; VP_Dados: integer): integer;
var
    i: integer;

    procedure incluir(VP_Posicao: integer);
    begin
        fTags[VP_Posicao].Tag := VP_Tag;
        fTags[VP_Posicao].Qt := HexStr(length(IntToStr(Length(IntToStr(VP_Dados)))), 1);
        fTags[VP_Posicao].Tamanho := Length(IntToStr(VP_Dados));
        fTags[VP_Posicao].Dados := IntToStr(VP_Dados);
    end;

begin
    Result := 0;
    //Verifica se existe o pacote
    if length(fTags) = 0 then
    begin
        AddComando('0000', '');
    end;
    //verifica se o parametro dados contem valor
    for i := 0 to length(fTags) - 1 do
    begin
        if fTags[i].Tag = VP_Tag then
        begin
            incluir(i);
            Exit;
        end;
    end;
    SetLength(fTags, Length(fTags) + 1);
    incluir(Length(fTags) - 1);

end;

procedure TMensagem.Limpar;
begin
    SetLength(fTags, 0);
end;

constructor TMensagem.Create;
begin
    inherited Create;
    AddComando('0000', '');
end;

function TMensagem.AddComando(VP_Tag, VP_Dados: ansistring): integer;
begin
    Result := 0;

    //Verifica se existe o pacote
    if length(fTags) = 0 then
        SetLength(fTags, Length(fTags) + 1);

    fTags[0].Tag := VP_Tag;
    fTags[0].Qt := HexStr(length(IntToStr(Length(VP_Dados))), 1);
    fTags[0].Tamanho := Length(VP_Dados);
    fTags[0].Dados := VP_Dados;

end;


initialization
    VF_Sequencia := 0;
    InitCriticalSection(VF_CriticoLog);

finalization
    DoneCriticalSection(VF_CriticoLog);
end.
