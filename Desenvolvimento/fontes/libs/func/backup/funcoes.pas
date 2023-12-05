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
    {$IF DEFINED(OPEN_TEF) OR DEFINED(TEF_LIB)OR DEFINED(COM_LIB)OR  DEFINED(pinpad_lib) OR  DEFINED(MCOM)}
    def,
    {$ENDIF}
    IdTime,
    syncobjs,
    ExtCtrls,
    Graphics,
    ubarcodes,
    Math,
    base64,
    typinfo,
    rxmemds;

type

    {$ifdef CPU64}
      THandle = QWord;
      ULONG_PTR = QWord;
    {$else CPU64}
    THandle = DWord;
    ULONG_PTR = DWord;
    {$endif CPU64}
    TThreadID = DWord;
    SIZE_T = ULONG_PTR;

    TImagem = (TI_Jpg, TI_Png, TI_BMP, TI_GIF);
    TLBytes = array of byte;

    TTag = record
        TagQt: ansistring;
        TagTamanho: longint;
        Tag: ansistring;

        DadosQt: ansistring;
        DadosTamanho: longint;
        Dados: ansistring;
    end;

    TCompatibilidade_Versao = (CvAtual, CvDesatualizado, CvAtualizar, CvPessoaIncompativel, CvProgramaIncompativel);

    TVersao = record
        Tipo: integer;
        Versao: integer;
        Compilacao: integer;
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
        function GetTagTabelaPosicao(VP_Posicao: integer; VP_Tag: ansistring; var VO_Dados: ansistring): integer;
        function GetTagAsAstring(VP_Tag: ansistring): ansistring;
        function Comando(): ansistring;
        function TagsAsString: ansistring;
        function TagCount(): integer;
        function ComandoDados(): ansistring;
        function GetTagAsInteger(VP_Tag: ansistring): integer;
        function AddTag(VP_Tag, VP_Dados: ansistring): integer;
        function AddTag(VP_Tag: ansistring; VP_Dados: integer): integer;
        function AddTag(VP_Posicao: integer; VP_Tag, VP_Dados: string): integer;
        procedure Limpar;
        constructor Create;
    end;

    TObjeto = class
        ID: integer;
        Objeto: Pointer;
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
    TConexaoStatus = (csNaoInicializado, csDesconectado, csLink, csChaveado, csChaveadoAssinado, csLogado);

    //csLink =  conectado sem criptografia,
    //csChaveado = troca de chave RSA com chave AES dinamica
    //csChaveadoAssinado= chave AES autenticada


    TPermissao = (pmS, pmC, pmA, pmU);
    // pmS=permissao de sistema
    // pmC=permissao de controlador permissao maxima
    // pmA permissao de administrador pode gerenciar as transacao e fazer cadastros
    // pmU permissao de usuario consulta e visualizacao das transacoes

    TRetornoModulo = procedure(VP_Transmissao_ID: PChar; VP_Tarefa_ID, VP_ProcID, VP_Erro: integer; VP_Dados: PChar; VP_Modulo: Pointer); cdecl;
    TRetorno = procedure(VP_Transmissao_ID: PChar; VP_ProcID, VP_Erro: integer; VP_Dados: PChar); cdecl;

    TRetornoDoCliente = function(VP_DadosEntrada: PChar; var VO_DadosSaida: PChar): integer; cdecl;
    TServidorRecebimento = procedure(VP_Erro: integer; VP_Transmissao_ID, VP_DadosRecebidos: string; VP_Conexao_ID: integer;
        VP_Terminal_Tipo: string; VP_Terminal_ID: integer; VP_DOC: string; VP_Terminal_Status: TConexaoStatus;
        VP_Terminal_Identificacao: string; VP_Permissao: TPermissao; VP_ClienteIP: string);
    TServidorRecebimentoLib = function(VP_Erro: integer; VP_Transmissao_ID, VP_DadosRecebidos: PChar; VP_IP: pansichar;
        VP_Conexao_ID: integer; VP_Chave: PChar): integer; cdecl;
    TTransacaoStatus = (tsEfetivada, tsNegada, tsCancelada, tsProcessando, tsAguardandoComando, tsNaoLocalizada, tsInicializada,
        tsComErro, tsAbortada, tsAguardandoDadosPDV);




    TTipoDocumento = (tdCNPJ, tdCPF); // tipo do documento prar formatação

    TTipoChave = (tcC50, tcPDV, tcConfigurador, tcModuloConfig); // tipo de chaves de validação

    TTipoTerminal = (ttrNDF, ttrPDV, ttrConfigurador, ttrModulo); // tipo de terminal

    TTipoTag = (ttNDF, ttCOMANDO, ttDADOS, ttMENU_PDV, ttMENU_OPERACIONAL, ttPINPAD_FUNC, ttMODULO); //tipo de tag cadastrado no banco de dados

    TSolicitacaoStatus = (ssCriada, ssAguardandoResposta, ssRespondida, ssErro);

    { TTEmporizadorEvento }

    TTEmporizadorTThread = class(TThread)
    private
        fTempo: cardinal;
        fTemporizador: Pointer;
    protected
        procedure Execute; override;
    public
        constructor Create(VP_Temporizador: Pointer);
    end;


    { TTEmporizador }
    TTemporizador = class
    private
        fTEmporizadorTThread: TTEmporizadorTThread;
        fEvento: TAguardaEvento;
        fListaThreads: TList;

    public
        V_Dados: string;
        V_Executado: boolean;
        V_Aborta: boolean;
        V_Aguardando: boolean;
        V_ID: string;
        constructor Create(VO_ListaThreads: TList);
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
        fAbortada: boolean;
    private
        function GetErro: integer;
        function GetErroDescricao: string;
        procedure SetErro(VP_Erro: integer);
        function GetStatus: TTransacaoStatus;
        procedure SetErroDescricao(VP_Descricao: string);
        procedure SetStatus(VP_Status: TTransacaoStatus);
        function GetChaveTransacao: ansistring;


    public
        constructor Create(VP_Comando, VP_Terminal_Tipo, VP_Doc: ansistring; VP_Terminal_ID: int64; VP_TransacaoString: ansistring);
        destructor Destroy; override;
        function AsString: ansistring;
        function GetID: ansistring;
        function TempoAguarda: integer;
        property erro: integer read GetErro write SetErro;
        property erroDescricao: string read GetErroDescricao write SetErroDescricao;
        property ID: ansistring read GetID;
        property chaveTransacao: ansistring read GetChaveTransacao;
        property STATUS: TTransacaoStatus read GetSTATUS write SetStatus;
    end;


    { TDFuncoes }

    TDFuncoes = class(TDataModule)
        procedure DataModuleCreate(Sender: TObject);
        procedure DataModuleDestroy(Sender: TObject);
    private
        ListaObjetos: TList;
        indice: integer;
    public
        function objetoAdd(VP_Objeto: Pointer): integer;
        function objetoDelete(VP_ID: integer): integer;
        function objetoGet(VP_ID: integer): Pointer;
    end;

function Formata(Texto, Espaco: string; Tamanho: int64; Alinha_Esquerda: boolean): string;
procedure StrToRxMemData(VP_Dados: ansistring; var VO_MemDataSet: TRxMemoryData);
function RxMemDataToStr(VO_MemDataSet: TRxMemoryData): ansistring;
function ZQueryToStrRxMemData(VO_ZQuery: TZQuery): ansistring;
procedure CriarChaveTerminal(VP_TipoChave: TTipoChave; VP_ValorChave: string; var VO_Chave: ansistring);
{$IF DEFINED(OPEN_TEF) OR DEFINED(TEF_LIB) OR DEFINED(com_lib) or DEFINED(pinpad_lib) OR  DEFINED(MCOM)}
procedure GravaLog(VP_Arquivo: string; VP_Modulo_ID: integer; VP_Tag_Comando, VP_Unit, VP_Linha, VP_Ocorrencia, VP_Tag: ansistring;
    VP_CodigoErro: integer; VP_NivelLog: integer);
function versao(var VO_Dados: PChar): integer; cdecl;
{$ENDIF }
function CalculaDigito(Texto: string): string;
function PermissaoToStr(VP_Permissao: TPermissao): ansistring;
function PermissaoToStrFormatada(VP_Permissao: TPermissao): ansistring;
function StrToPermissao(VP_Permissao: ansistring): TPermissao;
function TipoTagToStr(VP_TipoTag: integer): ansistring;
function StrToTipoTag(VP_TipoTag: ansistring): integer;
function TipoTerminalToStr(VP_TipoTerminal: integer): ansistring;
function StrToTipoTerminal(VP_TipoTerminal: ansistring): integer;
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
function TempoPassouMiliSegundos(VP_Agora: TDateTime): real;
procedure StrToImagem(Dados: string; var Imagem: Timage; Tipo_Imagem: TImagem = TI_JPG);
procedure ImagemToStr(var Dados: string; Imagem: TImage);
procedure BarcodeToStr(var Dados: string; Barcode: TBarcodeQR);
function IntToSQL(LetraNumero: int64; ConsideraZeroNull: boolean = False; ConsideraMenosUmNull: boolean = False): string;
function FloatToSql(VP_Valor: real; VP_ConsideraZeroNull: boolean = False; VP_ConsideraMenosUmNull: boolean = False): string;
function CLNValoresSQL(LetraNumero: string; ConsideraZeroNull: boolean = False; ConsideraMenosUmNull: boolean = False): string;
function StrToSql(S: string; ConsideraNull: boolean = False; VL_Tamanho: int64 = 0): string;
function VerificaSelect(Sql: string): string;
function ConverteSQL(Script: string): string;
function CriaID: string;
function GerarQRCodeAsString(QrCode: string): string;
function CompVersao(VersaoAtual, VersaoCliente: TVersao): TCompatibilidade_Versao;
function StrToVer(S: string): TVersao;
function VerToStr(Versao: TVersao): string;
function CLNInteiro(LetraNumero: string): int64;
function Tiraletra(DeixaZero: boolean; LetraNumero: string; RetornaEspaco: boolean = False): string;
function CLNNumeros(LetraNumero: string): real;
function StrToType(Tipo: PTypeInfo; Nome: string; Formata: boolean = False): variant;


function copiaTagPosicao(VP_Posicao: integer; VP_TagEntrada, VO_TagSaida: TMensagem): integer;
procedure copiaTag(VP_TagEntrada, VP_TagSaida: TMensagem; VP_LimparTagSaida: boolean);
procedure CopiaDadosSimples(VO_TOrigemMemDataset: TRxMemoryData; VO_TDestinoMemDataset: TRxMemoryData; VL_Linha: boolean = False);

function mensagemcreate_id(var VO_ID: integer): integer; cdecl;
function mensagemcreate(var VP_Mensagem: Pointer): integer; cdecl;
function mensagemcarregatags(VP_Mensagem: Pointer; VP_Dados: pansichar): integer; cdecl;
function mensagemcomando(VP_Mensagem: Pointer; var VO_Dados: pansichar): integer; cdecl;
function mensagemcomandodados(VP_Mensagem: Pointer; var VO_Dados: pansichar): integer; cdecl;
procedure mensagemfree(VP_Mensagem: Pointer); cdecl;
function mensagemfree_id(VP_ID: integer): integer; cdecl;
function mensagemaddtag(VP_Mensagem: Pointer; VP_Tag, VP_Dados: pansichar): integer; cdecl;
function mensagemaddcomando(VP_Mensagem: Pointer; VP_Tag, VP_Dados: pansichar): integer; cdecl;
function mensagemaddtagposicao(VP_Mensagem: Pointer; VP_Posicao: integer; VP_Tag, VP_Dados: pansichar): integer; cdecl;
function mensagemtagasstring(VP_Mensagem: Pointer; var VO_Dados: pansichar): integer; cdecl;
function mensagemtagcount(VP_Mensagem: Pointer): integer; cdecl;
function mensagemgettag(VP_Mensagem: Pointer; VP_Tag: pansichar; var VO_Dados: pansichar): integer; cdecl;
function mensagemgettagposicao(VP_Mensagem: Pointer; VP_Posicao: integer; VP_Tag: pansichar; var VO_Dados: pansichar): integer; cdecl;
function mensagemgettagidx(VP_Mensagem: Pointer; VL_Idx: integer; var VO_Tag: pansichar; var VO_Dados: pansichar): integer; cdecl;
function mensagemtagtostr(VP_Mensagem: Pointer; var VO_Dados: pansichar): integer; cdecl;
procedure mensagemlimpar(VP_Mensagem: Pointer); cdecl;
function mensagemerro(VP_CodigoErro: integer; var VO_RespostaMensagem: pansichar): integer; cdecl;
function Crc16(s: TLBytes; len: integer; Polynom: word = $1021; Seed: word = $00): word;
function ByteToHex(Value: TLBytes): string;
procedure HexToByte(Value: string; var VO_Retorno: TLBytes);
function CriaChave(Tamanho: int64): string;

var
    DFuncoes: TDFuncoes;

    VF_Sequencia: longint;
    VF_CriticoLog: TRTLCriticalSection;

const
    Letra: array [0..35] of string = ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'X', 'Z', 'W',
        'Y', 'Z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9');
    LetraHexadecimal: array [0..15] of string = ('A', 'B', 'C', 'D', 'E', 'F', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9');


implementation

function CLNInteiro(LetraNumero: string): int64;
begin
    try
        if Length(LetraNumero) = 0 then
            Result := 0
        else
        if Pos('-', LetraNumero) > 0 then
            Result := StrToInt(Tiraletra(False, LetraNumero)) * -1
        else
            Result := StrToInt(Tiraletra(False, LetraNumero));
    except
        Result := 0;

    end;
end;

function CLNNumeros(LetraNumero: string): real;

var
    LocalLetraFuncao, i: integer;
    ResultadoFuncao: string;
    TextoFuncao: string;
begin
    TextoFuncao := '';
    LocalLetraFuncao := 0;
    ResultadoFuncao := '';
    for i := 0 to Length(LetraNumero) do
        if ((TextoFuncao >= '0') and (TextoFuncao <= '9')) then
        begin
            ResultadoFuncao := ResultadoFuncao + Copy(LetraNumero, LocalLetraFuncao, 1);
            LocalLetraFuncao := LocalLetraFuncao + 1;
            TextoFuncao := Copy(LetraNumero, LocalLetraFuncao, 1);
        end
        else
        begin
            LocalLetraFuncao := LocalLetraFuncao + 1;
            TextoFuncao := Copy(LetraNumero, LocalLetraFuncao, 1);
        end;
    if ResultadoFuncao = '' then
        ResultadoFuncao := '0';
    Result := StrToFloat(ResultadoFuncao);
end;


function Tiraletra(DeixaZero: boolean; LetraNumero: string; RetornaEspaco: boolean = False): string;
var
    LocalLetraFuncao, i: integer;
    ResultadoFuncao: string;
    TextoFuncao: string;
begin
    TextoFuncao := '';
    LocalLetraFuncao := 0;
    ResultadoFuncao := '';
    for i := 0 to Length(LetraNumero) do
        if ((TextoFuncao >= '0') and (TextoFuncao <= '9')) then
        begin
            if (TextoFuncao = '0') and (DeixaZero = False) then
            begin
                if CLNNumeros(ResultadoFuncao) > 0 then
                    ResultadoFuncao := ResultadoFuncao + Copy(LetraNumero, LocalLetraFuncao, 1);
            end
            else
                ResultadoFuncao := ResultadoFuncao + Copy(LetraNumero, LocalLetraFuncao, 1);
            LocalLetraFuncao := LocalLetraFuncao + 1;
            TextoFuncao := Copy(LetraNumero, LocalLetraFuncao, 1);
        end
        else
        begin
            LocalLetraFuncao := LocalLetraFuncao + 1;
            TextoFuncao := Copy(LetraNumero, LocalLetraFuncao, 1);
        end;
    if (ResultadoFuncao = '') and (RetornaEspaco = False) then
        ResultadoFuncao := '0';
    Result := ResultadoFuncao;
end;

function StrToType(Tipo: PTypeInfo; Nome: string; Formata: boolean = False): variant;
begin
    if Formata then
        Nome := Copy(Tipo^.Name, 2, 2) + '_' + Nome;
    Result := GetEnumValue(Tipo, Nome);
end;


function StrToVer(S: string): TVersao;
begin
    Result.Tipo := CLNInteiro(Copy(S, 0, Pos('.', S)));
    S := Copy(S, Pos('.', S) + 1, MaxInt);
    //Result.Programa_ID  := CLNInteiro(Copy(S, 0, Pos('.', S)));
    S := Copy(S, Pos('.', S) + 1, MaxInt);
    Result.Versao := CLNInteiro(Copy(S, 0, Pos('.', S)));
    S := Copy(S, Pos('.', S) + 1, MaxInt);
    Result.Compilacao := CLNInteiro(S);
end;



function VerToStr(Versao: TVersao): string;
begin
    Result := IntToStr(Versao.Tipo) + '.' +
        //IntToStr(Versao.Programa_ID)+ '.' +
        IntToStr(Versao.Versao) + '.' +
        IntToStr(Versao.Compilacao);
end;


function CompVersao(VersaoAtual, VersaoCliente: TVersao): TCompatibilidade_Versao;
begin
    Result := CvAtual;
    if VersaoAtual.Tipo <> VersaoCliente.Tipo then
        Result := CvPessoaIncompativel
    else
    {
    if VersaoAtual.Programa_ID <> VersaoCliente.Programa_ID then
      Result := CvProgramaIncompativel
    else
    }
    if VersaoAtual.Versao <> VersaoCliente.Versao then
        Result := CvAtualizar
    else
    if (VersaoAtual.Compilacao > VersaoCliente.Compilacao) and (VersaoAtual.Versao = VersaoCliente.Versao) then
        Result := CvDesatualizado;
end;


function Formata(Texto, Espaco: string; Tamanho: int64; Alinha_Esquerda: boolean): string;
var
    i: integer;
begin
    Result := '';
    for i := 0 to Tamanho - Length(Texto) - 1 do
        Result := Result + Espaco;
    if Alinha_Esquerda then
        Result := Texto + Result
    else
        Result := Result + Texto;
    if Length(Result) > Tamanho then
        Result := Copy(Result, 1, Tamanho);
end;


function Crc16(s: TLBytes; len: integer; Polynom: word = $1021; Seed: word = $00): word;
var
    i, j: integer;
begin
    Result := Seed;
    for i := 0 to len - 1 do
    begin
        Result := Result xor (S[i] shl 8);
        for j := 0 to 7 do
        begin
            if (Result and $8000) <> 0 then
                Result := (Result shl 1) xor Polynom
            else
                Result := Result shl 1;
        end;
    end;
    Result := Result and $FFFF;

end;


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
    //    i: integer;
    S: string;
begin
    s := '';
    //L := '';
    if Dados = '' then
    begin
        Imagem.Picture.Graphic := nil;
        exit;
    end;

    //for i := 0 to Length(Dados) div 2 - 1 do
    //begin
    //L := copy(Dados, ((1 + i) * 2) - 1, 2);
    //s := s + char(Hex2Dec(L));
    //end;

    s := DecodeStringBase64(Dados);

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
    //I: integer;
    S: string;
begin
    Dados := '';
    Sm := TStringStream.Create('');
    Imagem.Picture.SaveToStream(Sm);
    S := sm.DataString;

    Dados := EncodeStringBase64(s);


    //for i := 0 to Length(S) - 1 do
    //Dados := Dados + HexStr(Ord(S[i + 1]), 2);


    Sm.Free;
end;


function GerarQRCodeAsString(QrCode: string): string;
var
    Barcode: TBarcodeQR;
    Dados: string;
begin
    Dados := '';
    Barcode := TBarcodeQR.Create(nil);
    Barcode.Width := 230;
    Barcode.Height := 230;
    Barcode.ECCLevel := eBarcodeQR_ECCLevel_Auto;
    //    Barcode.StrictSize:=False;
    Barcode.BackgroundColor := clNone;
    Barcode.Text := QrCode;
    BarcodeToStr(Dados, Barcode);
    Result := Dados;
    Barcode.Free;
end;

procedure BarcodeToStr(var Dados: string; Barcode: TBarcodeQR);
var
    R: TRect;
    png: TPortableNetworkGraphic;
    img: TImage;
begin
    png := TPortableNetworkGraphic.Create;
    img := TImage.Create(nil);
    try
        R := Rect(0, 0, Barcode.Width, Barcode.Height);
        png.SetSize(Barcode.Width, Barcode.Height);
        png.Monochrome := True;
        png.Canvas.Brush.Color := clWhite;
        png.Canvas.FillRect(R);

        Barcode.PaintOnCanvas(png.Canvas, R);
        img.Picture.Assign(png);

        ImagemToStr(Dados, img);
    finally
        png.Free;
        img.Free;
    end;

end;


function mensagemcreate_id(var VO_ID: integer): integer; cdecl;
var
    VL_Mensagem: ^TMensagem;
begin
    Result := mensagemcreate(VL_Mensagem);

    if Result <> 0 then
        Exit;

    VO_ID := DFuncoes.objetoAdd(VL_Mensagem);
end;

function mensagemcreate(var VP_Mensagem: Pointer): integer; cdecl;
begin
    Result := 0;
    Pointer(VP_Mensagem) := pointer(TMensagem.Create);
end;


function mensagemcarregatags(VP_Mensagem: Pointer; VP_Dados: pansichar): integer; cdecl;
begin
    Result := TMensagem(VP_Mensagem).CarregaTags(VP_Dados);
end;

{
function mensagemcarregatagsid(VP_ID: Pointer; VP_Dados: pansichar): integer; cdecl;
var
    //VL_RecMensagem: ^TRecMensagem.
begin
    //VL_RecMensagem := DFuncoes.get

    Result := TMensagem(VP_Mensagem).CarregaTags(VP_Dados);
end;
}

function mensagemcomando(VP_Mensagem: Pointer; var VO_Dados: pansichar): integer; cdecl;
var
    VL_Dados: ansistring;

begin
    Result := 0;
    VL_Dados := TMensagem(VP_Mensagem).Comando();
    VO_Dados := StrAlloc(Length(VL_Dados) + 1);
    StrPCopy(VO_Dados, VL_Dados);
end;

function mensagemcomandodados(VP_Mensagem: Pointer; var VO_Dados: pansichar): integer; cdecl;
var
    VL_String: ansistring;
begin
    Result := 0;
    VL_String := TMensagem(VP_Mensagem).ComandoDados();
    VO_Dados := StrAlloc(Length(VL_String) + 1);
    StrPCopy(VO_Dados, VL_String);
end;

procedure mensagemfree(VP_Mensagem: Pointer); cdecl;
begin
    if Assigned(VP_Mensagem) then
    begin
        TMensagem(VP_Mensagem).Free;
    end;
end;


function mensagemfree_id(VP_ID: integer): integer; cdecl;
var
    VL_Mensagem: ^Tmensagem;
begin
    try
        VL_Mensagem := DFuncoes.objetoGet(VP_ID);
        if not Assigned(VL_Mensagem) then
        begin
            Result := 1;
            Exit;
        end;

        VL_Mensagem^.Free;
        Result := DFuncoes.objetoDelete(VP_ID);
    except
        on e: Exception do
        begin
            Result := 1;
        end;
    end;
end;

function mensagemaddtag(VP_Mensagem: Pointer; VP_Tag, VP_Dados: pansichar): integer; cdecl;
begin
    Result := TMensagem(VP_Mensagem).AddTag(VP_Tag, VP_Dados);
end;

function mensagemaddtagposicao(VP_Mensagem: Pointer; VP_Posicao: integer; VP_Tag, VP_Dados: pansichar): integer; cdecl;
begin
    Result := TMensagem(VP_Mensagem).AddTag(VP_Posicao, VP_Tag, VP_Dados);
end;

function mensagemaddcomando(VP_Mensagem: Pointer; VP_Tag, VP_Dados: pansichar): integer; cdecl;
begin
    Result := TMensagem(VP_Mensagem).AddComando(VP_Tag, VP_Dados);
end;

function mensagemtagasstring(VP_Mensagem: Pointer; var VO_Dados: pansichar): integer; cdecl;
var
    VL_String: ansistring;
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

function mensagemgettag(VP_Mensagem: Pointer; VP_Tag: pansichar; var VO_Dados: pansichar): integer; cdecl;
var
    VL_Dados: ansistring;
begin
    VL_Dados := '';
    Result := TMensagem(VP_Mensagem).GetTag(VP_Tag, VL_Dados);

    VO_Dados := StrAlloc(Length(VL_Dados) + 1);
    StrPCopy(VO_Dados, VL_Dados);

end;

function mensagemgettagposicao(VP_Mensagem: Pointer; VP_Posicao: integer; VP_Tag: pansichar; var VO_Dados: pansichar): integer; cdecl;
var
    VL_Dados: ansistring;
begin
    VL_Dados := '';
    Result := TMensagem(VP_Mensagem).GetTagTabelaPosicao(VP_Posicao, VP_Tag, VL_Dados);

    VO_Dados := StrAlloc(Length(VL_Dados) + 1);
    StrPCopy(VO_Dados, VL_Dados);
end;

function mensagemgettagidx(VP_Mensagem: Pointer; VL_Idx: integer; var VO_Tag: pansichar; var VO_Dados: pansichar): integer; cdecl;
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

function mensagemtagtostr(VP_Mensagem: Pointer; var VO_Dados: pansichar): integer; cdecl;
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


function mensagemerro(VP_CodigoErro: integer; var VO_RespostaMensagem: pansichar): integer; cdecl;
var
    VL_String: string;
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
            84: VL_String := 'A OPERADORA/ADQUIRENTE EXIGE CRIPTOGRAFIA, MAS NÃO ENVIOU AS CHAVES';
            85: VL_String := 'Erro de tempo em capturar a senha no pinpad';
            86: VL_String := 'Erro ao cancelar uma transação';
            87: VL_String := 'Erro na exclusão, TAG oficial não pode ser excluida';
            88: VL_String := 'TAG não é um valor Hexadecimal';
            89: VL_String := 'Chave da transação não localizada';
            90: VL_String := 'Autorização da venda não localizada';
            91: VL_String := 'Código da loja não localizado';
            92: VL_String := 'Desafio da chave não completado';
            93: VL_String := 'ID do terminal não informada para o OPENTEF';
            94: VL_String := 'ID do terminal não encontrado para o OPENTEF';
            95: VL_String := 'Login negado pelo adquirente';
            96: VL_String := 'Cliente Desconectado do servidor';
            97: VL_String := 'Tarefa não encontrada para remoção';
            98: VL_String := 'Chaves públicas não trocada';
            99: VL_String := 'Conexão não encontrada';
            100: VL_String := 'Conexão não está estabelecida';
            101: VL_String := 'Comando inválido para o OPENTEF';
            102: VL_String := 'DADOS INFORMADOS DIFERENTE DOS DADOS DA TABELA NO BANCO DE DADOS';
            103: VL_String := 'NÃO FOI POSSÍVEL CONECTAR AO SERVIDOR ABERTURA SOCKET COM EXCECAO';
            104: VL_String := 'NÃO FOI ENCONTRADA OS DADOS DO ARQUIVO';
            105: VL_String := 'Erro insperado no servidor';
            106: VL_String := 'Identificação não localizada';
            107: VL_String := 'Identificação não informada';
            108: VL_String := 'Loja ja pertence a outra Multi-loja';
            109: VL_String := 'Chave de comunicação não informada para uma transação criptografa';
            110: VL_String := 'O Modulo não foi carregado';
            111: VL_String := 'O Modulo não está logado';
            112: VL_String := 'A biblioteca Tef já foi inicializada';
            113: VL_String := 'A função de retorno para o cliente não foi informada';
            114: VL_String := 'A função de solicita dados do pdv não foi informada';
            115: VL_String := 'A função de solicita dados da transação não foi informada';
            116: VL_String := 'A função de impressão não foi informada';
            117: VL_String := 'A função de mostra menu não foi informada';
            118: VL_String := 'A função de mensagem ao operador não foi informada';
            119: VL_String := 'ERRO AO PEGAR A TAG DA TRANSACAO';
            120: VL_String := 'Não é possível buscar essa tag pois ela é protegida';
            121: VL_String := 'Não é possível realizar a conciliacao, pois a versão está desatualizada';
            122: VL_String := 'ESSA CONEXAO NÃO PERMITE CONCILIAÇÃO';
            123: VL_String := 'Não é possível enviar mais de uma conciliacao para a mesma operadora';
            else
            begin
                Result := 1;
                VL_String := 'Erro Desconhecido ou não catalogado';
            end;
        end;

        VO_RespostaMensagem := StrAlloc(Length(VL_String) + 1);
        StrPCopy(VO_RespostaMensagem, VL_String);
    end;
end;

{ TDFuncoes }

procedure TDFuncoes.DataModuleCreate(Sender: TObject);
begin
    inherited;
    ListaObjetos := TList.Create;
    indice := 0;
end;

procedure TDFuncoes.DataModuleDestroy(Sender: TObject);
begin
    while ListaObjetos.Count > 0 do
    begin
        TObject(TObjeto(ListaObjetos.Items[0]).Objeto).Free;
        TObjeto(ListaObjetos.Items[0]).Free;
        ListaObjetos.Delete(0);
    end;

    ListaObjetos.Free;
    inherited Destroy;
end;

function TDFuncoes.objetoAdd(VP_Objeto: Pointer): integer;
var
    VL_objeto: TObjeto;
begin
    Result := -1;

    VL_objeto := TObjeto.Create;
    VL_objeto.Objeto := VP_Objeto;
    Inc(indice);
    VL_objeto.ID := indice;
    ListaObjetos.Add(VL_objeto);

    Result := indice;
end;

function TDFuncoes.objetoGet(VP_ID: integer): Pointer;
var
    VL_objeto: TObjeto;
    VL_I: integer;
begin
    Result := nil;

    if ListaObjetos.Count = 0 then
        Exit;

    for VL_I := 0 to ListaObjetos.Count - 1 do
    begin
        VL_objeto := TObjeto(ListaObjetos.Items[VL_I]);
        if VL_objeto.ID = VP_ID then
        begin
            Result := VL_objeto.Objeto;
            Exit;
        end;
    end;
end;

function TDFuncoes.objetoDelete(VP_ID: integer): integer;
var
    VL_objeto: TObjeto;
    VL_I: integer;
begin
    Result := 1;

    if ListaObjetos.Count = 0 then
        Exit;

    for VL_I := 0 to ListaObjetos.Count - 1 do
    begin
        VL_objeto := TObjeto(ListaObjetos.Items[VL_I]);
        if VL_objeto.ID = VP_ID then
        begin
            ListaObjetos.Delete(VL_I);
            Result := 0;
            Exit;
        end;
    end;
end;

{ TTemporizador }

constructor TTemporizador.Create(VO_ListaThreads: TList);
begin
    inherited Create;
    fListaThreads := VO_ListaThreads;
    V_Executado := False;
    V_Aborta := False;
    V_Aguardando := False;
    V_Dados := '';
    V_ID := '';

end;

procedure TTemporizador.parar;
begin
    V_Executado := True;
    V_Aborta := False;
    if Assigned(fTEmporizadorTThread) then
    begin
        fTEmporizadorTThread.Terminate;
        if not V_Aguardando then
        begin
            fTEmporizadorTThread.WaitFor;
            fTEmporizadorTThread.Free;
            fTEmporizadorTThread := nil;

        end;

    end;
end;

procedure TTemporizador.abortar;
begin
    V_Executado := False;
    V_Aborta := True;
    if Assigned(fTEmporizadorTThread) then
    begin
        fTEmporizadorTThread.Terminate;
        if not V_Aguardando then
        begin
            fTEmporizadorTThread.WaitFor;
            fTEmporizadorTThread.Free;
            fTEmporizadorTThread := nil;

        end;

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

        if V_Aborta then
        begin
            Result := agAborta;
            Exit;
        end;


        fTEmporizadorTThread := TTEmporizadorTThread.Create(VP_Temporizador);
        fTEmporizadorTThread.fTempo := VP_Tempo;
        if Assigned(fListaThreads) then
            fListaThreads.Add(@fTEmporizadorTThread);
        fTEmporizadorTThread.Start;

        WaitForThreadTerminate(fTEmporizadorTThread.Handle, VP_Tempo);
        if Assigned(fListaThreads) then
            fListaThreads.Remove(@fTEmporizadorTThread);

        //        fTEmporizadorTThread.WaitFor;
        fTEmporizadorTThread.Free;
        fTEmporizadorTThread := nil;

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
    begin
        fTEmporizadorTThread.Terminate;
        if not V_Aguardando then
        begin
            fTEmporizadorTThread.WaitFor;
            fTEmporizadorTThread.Free;
            fTEmporizadorTThread := nil;

        end;
    end;
    inherited Destroy;
end;

{ TTEmporizadorEvento }

procedure TTEmporizadorTThread.Execute;
var
    VL_Data: TDateTime;
begin
    try
        VL_Data := now;
        while not Terminated do
        begin
            if ((fTempo <> INFINITE) and
                ((TimeStampToMSecs(DateTimeToTimeStamp(now)) - TimeStampToMSecs(DateTimeToTimeStamp(VL_Data))) > fTempo)) then
            begin
                if Assigned(fTemporizador) then
                    TTemporizador(fTemporizador).fEvento := agTempo;
                exit;
            end;
            sleep(10);
        end;
    except

    end;
end;



constructor TTEmporizadorTThread.Create(VP_Temporizador: Pointer);
begin
    inherited Create(True);
    FreeOnTerminate := False;
    TTemporizador(VP_Temporizador).fEvento := agEvento;
    fTemporizador := VP_Temporizador;

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
    fAbortada := False;

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
    //VL_String: ansistring;
    //VL_bytes: array of byte;
    //VL_i: integer;
begin
    //VL_bytes := nil;

    VL_MemString := TStringStream.Create;
    VL_Mem := TMemoryStream.Create;

    VO_MemDataSet.SaveToStream(VL_Mem);

    VL_Mem.SaveToStream(VL_MemString);


    Result := EncodeStringBase64(VL_MemString.DataString);

{    VL_String := VL_MemString.DataString;

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

    Result := VL_String; }
    VL_MemString.Free;
    VL_Mem.Free;
end;

procedure StrToRxMemData(VP_Dados: ansistring; var VO_MemDataSet: TRxMemoryData);
var
    //VL_bytes: array of byte;
    //VL_i: integer;
    VL_String: ansistring;
    VL_MemString: TStringStream;
    VL_Mem: TMemoryStream;
begin

    //VL_bytes := nil;
    // converte em bytes
    if VP_Dados = '' then
        exit;

  {  for VL_i := 0 to (Length(VP_Dados) div 2) - 1 do
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
    }

    VL_MemString := TStringStream.Create(DecodeStringBase64(VP_Dados));

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
                    if Intervalo > 15 then
                        Intervalo := Intervalo div 10;
                    VL_Chave := VL_Chave + LetraHexadecimal[Intervalo];
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
                    if Intervalo > 16 then
                        Intervalo := Intervalo div 10;
                    VL_Chave := VL_Chave + LetraHexadecimal[Intervalo];
                end;
                VL_Chave := VL_Chave + COPY(VP_ValorChave, I, 1);
            end;
            VO_Chave := COPY(VL_Chave, 1, 50);
        end;
    end;
end;

{$IF DEFINED(OPEN_TEF) OR DEFINED(TEF_LIB) OR DEFINED(com_lib) or DEFINED(pinpad_lib) OR  DEFINED(MCOM)}
procedure GravaLog(VP_Arquivo: string; VP_Modulo_ID: integer; VP_Tag_Comando, VP_Unit, VP_Linha, VP_Ocorrencia, VP_Tag: ansistring;
    VP_CodigoErro: integer; VP_NivelLog: integer);
var
    VL_Arquivo: TextFile;
begin
    if VP_Arquivo = '' then
        exit;

    if VP_NivelLog > F_NivelLog then
        Exit;

    EnterCriticalSection(VF_CriticoLog);
    try
        AssignFile(VL_Arquivo, PChar(VP_Arquivo));

        if not FileExists(VP_Arquivo) then
            Rewrite(VL_Arquivo)
        else
            Append(VL_Arquivo);

        WriteLn(VL_Arquivo, '[ Nivel: ' + IntToStr(VP_NivelLog) + ' ] ' + '[ Data:' + DateToStr(now) + '] - [ Hora:' +
            TimeToStr(now) + '] - [ Linha:' + VP_Linha +
            '] - [ Modulo_ID:' + IntToStr(VP_Modulo_ID) +
            ']- [ TagComando:' + VP_Tag_Comando + '] - [ Programa:' + C_Programa + '] - [ Unit:' +
            VP_Unit + '] - [ VersaoMensagem:' + IntToStr(C_Mensagem) + '] - [ Versao:' + IntToStr(C_Versao[0]) + '.' +
            IntToStr(C_Versao[1]) + '.' + IntToStr(C_Versao[1]) + '] -  [ CodigoErro:' +
            IntToStr(VP_CodigoErro) + ']  - [ Ocorrencia:' + VP_Ocorrencia + '] - [ TMensagem:' + VP_Tag + ']');

        CloseFile(VL_Arquivo);

    finally
        LeaveCriticalSection(VF_CriticoLog);
    end;

end;

function versao(var VO_Dados: PChar): integer; cdecl;
begin
    try
        Result := 0;
        VO_Dados := StrAlloc(Length(IntToStr(C_Versao[0])) + Length(IntToStr(C_Versao[1])) + Length(IntToStr(C_Versao[2])) + 3);
        StrPCopy(VO_Dados, IntToStr(C_Versao[0]) + '.' + IntToStr(C_Versao[1]) + '.' + IntToStr(C_Versao[2]));
    except
        Result := 1;
    end;

end;

{$ENDIF}

function PermissaoToStrFormatada(VP_Permissao: TPermissao): ansistring;
begin
    case VP_Permissao of
        pmA: Result := 'Administrador';
        pmC: Result := 'Configurador';
        pmU: Result := 'Usuário';
        pmS: Result := 'Sistema';
        else
            Result := '';
    end;
end;

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




function TipoTerminalToStr(VP_TipoTerminal: integer): ansistring;
begin
    case VP_TipoTerminal of
        Ord(ttrNDF): Result := 'NDF';
        Ord(ttrPDV): Result := 'PDV';
        Ord(ttrConfigurador): Result := 'CONFIGURADOR';
        Ord(ttrModulo): Result := 'MODULO';
        else
            Result := '';

    end;
end;

function StrToTipoTerminal(VP_TipoTerminal: ansistring): integer;
begin

    case VP_TipoTerminal of
        'NDF': Result := Ord(ttrNDF);
        'PDV': Result := Ord(ttrPDV);
        'CONFIGUARADOR': Result := Ord(ttrConfigurador);
        'MODULO': Result := Ord(ttrModulo);
        else
            raise Exception.Create('Esse valor:"' + VP_TipoTerminal + '" não é um Tipo de Terminal Válido');
    end;
end;



function TipoTagToStr(VP_TipoTag: integer): ansistring;
begin
    case VP_TipoTag of
        Ord(ttNDF): Result := 'NDF';
        Ord(ttCOMANDO): Result := 'COMANDO';
        Ord(ttDADOS): Result := 'DADOS';
        Ord(ttMENU_PDV): Result := 'MENU_PDV';
        Ord(ttMENU_OPERACIONAL): Result := 'MENU_OPERACIONAL';
        Ord(ttPINPAD_FUNC): Result := 'PINPAD_FUNC';
        Ord(ttMODULO): Result := 'MODULO';
        else
            Result := '';

    end;
end;

function StrToTipoTag(VP_TipoTag: ansistring): integer;
begin

    case VP_TipoTag of
        'NDF': Result := Ord(ttNDF);
        'COMANDO': Result := Ord(ttCOMANDO);
        'DADOS': Result := Ord(ttDADOS);
        'MENU_PDV': Result := Ord(ttMENU_PDV);
        'MENU_OPERACIONAL': Result := Ord(ttMENU_OPERACIONAL);
        'PINPAD_FUNC': Result := Ord(ttPINPAD_FUNC);
        'MODULO': Result := Ord(ttMODULO);
        else
            raise Exception.Create('Esse valor:"' + VP_TipoTag + '" não é um Tipo de Tag Válido');
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
        0: Result := csNaoInicializado;
        1: Result := csDesconectado;
        2: Result := csLink;
        3: Result := csChaveado;
        4: Result := csChaveadoAssinado;
        5: Result := csLogado;

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

function copiaTagPosicao(VP_Posicao: integer; VP_TagEntrada, VO_TagSaida: TMensagem): integer;
var
    VL_I: integer;
    VL_Tag, VL_Dados, VL_Campo, VL_Posicao: ansistring;
begin
    Result := 0;

    VO_TagSaida.Limpar;

    if VP_TagEntrada.Comando <> '0118' then
    begin
        Result := 1;
        Exit;
    end;

    if ((VP_TagEntrada.GetTagAsInteger('0119') < VP_Posicao) or (VP_Posicao <= 0)) then
    begin
        Result := 1;
        Exit;
    end;

    for VL_I := 1 to VP_TagEntrada.TagCount do
    begin
        Result := VP_TagEntrada.GetTag(VL_I, VL_Tag, VL_Dados);
        if Result <> 0 then
            Exit;

        if Length(VL_Tag) <= 10 then
            continue;

        VL_Posicao := Copy(VL_Tag, 0, 10);
        VL_Campo := Copy(VL_Tag, 11, MaxInt);

        if VP_Posicao = StrToInt(VL_Posicao) then
            VO_TagSaida.AddTag(VL_Campo, VL_Dados);

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
            fTags[Length(fTags) - 1].TagQt := Copy(VP_Dados, 1, 1);
            fTags[Length(fTags) - 1].TagTamanho := StrToInt64Def(Copy(VP_Dados, 2, Hex2Dec(fTags[Length(fTags) - 1].TagQt)), 0);
            fTags[Length(fTags) - 1].Tag := Copy(VP_Dados, 2 + Hex2Dec(fTags[Length(fTags) - 1].TagQt), fTags[Length(fTags) - 1].TagTamanho);

            VP_Dados := Copy(VP_Dados, 2 + Hex2Dec(fTags[Length(fTags) - 1].TagQt) + fTags[Length(fTags) - 1].TagTamanho, MaxInt);

            fTags[Length(fTags) - 1].DadosQt := Copy(VP_Dados, 1, 1);
            fTags[Length(fTags) - 1].DadosTamanho := StrToInt64Def(Copy(VP_Dados, 2, Hex2Dec(fTags[Length(fTags) - 1].DadosQt)), 0);
            fTags[Length(fTags) - 1].Dados := Copy(VP_Dados, 2 + Hex2Dec(fTags[Length(fTags) - 1].DadosQt), fTags[Length(fTags) - 1].DadosTamanho);

            VP_Dados := Copy(VP_Dados, 2 + Hex2Dec(fTags[Length(fTags) - 1].DadosQt) + fTags[Length(fTags) - 1].DadosTamanho, MaxInt);

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
    if Length(fTags) = 0 then
    begin
        Result := 23;
        Exit;
    end;
    for i := 0 to Length(fTags) - 1 do
    begin
        VL_Dados := VL_Dados + fTags[i].TagQt + IntToStr(fTags[i].TagTamanho) + fTags[i].Tag + fTags[i].DadosQt +
            IntToStr(fTags[i].DadosTamanho) + fTags[i].Dados;
    end;
    VL_TamanhoPacote := Length(VL_Dados) + 5;

    VL_Digitos := Length(IntToStr(VL_TamanhoPacote));

    VL_Digitos := Length(IntToStr(VL_TamanhoPacote + VL_Digitos));

    VL_TamanhoPacote := VL_TamanhoPacote + VL_Digitos;

    VO_Dados := '0000' + IntToHex((VL_Digitos), 1) + IntToStr(VL_TamanhoPacote) + VL_Dados;

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

    for i := 0 to length(fTags) - 1 do
    begin
        if fTags[i].Tag = VP_Tag then
        begin
            if fTags[i].Dados <> '' then
                VO_Dados := StrToInt(fTags[i].Dados)
            else
                VO_Dados := 0;
            Result := 0;
            Exit;
        end;
    end;
end;

function TMensagem.GetTagTabelaPosicao(VP_Posicao: integer; VP_Tag: ansistring; var VO_Dados: ansistring): integer;
begin
    Result := self.GetTag((Formata(IntToStr(VP_Posicao), '0', 10, False) + VP_Tag), VO_Dados);
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

function TempoPassouMiliSegundos(VP_Agora: TDateTime): real;
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
        fTags[VP_Posicao].TagQt := IntToHex(Length(IntToStr(Length(VP_Tag))), 1);
        fTags[VP_Posicao].TagTamanho := Length(VP_Tag);
        fTags[VP_Posicao].Tag := VP_Tag;

        fTags[VP_Posicao].DadosQt := IntToHex(Length(IntToStr(Length(VP_Dados))), 1);
        fTags[VP_Posicao].DadosTamanho := Length(VP_Dados);
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
        fTags[VP_Posicao].TagQt := IntToHex(Length(IntToStr(Length(VP_Tag))), 1);
        fTags[VP_Posicao].TagTamanho := Length(VP_Tag);
        fTags[VP_Posicao].Tag := VP_Tag;

        fTags[VP_Posicao].DadosQt := IntToHex(Length(IntToStr(Length(IntToStr(VP_Dados)))), 1);
        fTags[VP_Posicao].DadosTamanho := Length(IntToStr(VP_Dados));
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

function TMensagem.AddTag(VP_Posicao: integer; VP_Tag, VP_Dados: string): integer;
begin
    Result := 0;
    AddTag(Formata(IntToStr(VP_Posicao), '0', 10, False) + VP_Tag, VP_Dados);
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

    // Verifica se existe o pacote
    if Length(fTags) = 0 then
        SetLength(fTags, Length(fTags) + 1);

    fTags[0].TagQt := IntToHex(Length(IntToStr(Length(VP_Tag))), 1);
    fTags[0].TagTamanho := Length(VP_Tag);
    fTags[0].Tag := VP_Tag;

    fTags[0].DadosQt := IntToHex(Length(IntToStr(Length(VP_Dados))), 1);
    fTags[0].DadosTamanho := Length(VP_Dados);
    fTags[0].Dados := VP_Dados;

end;

procedure copiaTag(VP_TagEntrada, VP_TagSaida: TMensagem; VP_LimparTagSaida: boolean);
var
    VL_I: integer;
    VL_Tag, VL_Dados: ansistring;
begin
    if VP_LimparTagSaida then
        VP_TagSaida.Limpar;

    for VL_I := 1 to VP_TagEntrada.TagCount do
    begin
        VP_TagEntrada.GetTag(VL_I, VL_Tag, VL_Dados);
        VP_TagSaida.AddTag(VL_Tag, VL_Dados);
    end;
end;

function FloatToSql(VP_Valor: real; VP_ConsideraZeroNull: boolean = False; VP_ConsideraMenosUmNull: boolean = False): string;
begin
    Result := CLNValoresSQL(FloatToStr(VP_Valor), VP_ConsideraZeroNull, VP_ConsideraMenosUmNull);
end;

function CLNValoresSQL(LetraNumero: string; ConsideraZeroNull: boolean = False; ConsideraMenosUmNull: boolean = False): string;
var
    SinalNegativo, Decimal: boolean;
    i: integer;
    ResultadoFuncao: string;
    TextoFuncao: string;
begin
    Decimal := False;
    TextoFuncao := '';
    SinalNegativo := False;
    ResultadoFuncao := '';
    if Trim(LetraNumero) = '' then
    begin
        if ConsideraZeroNull then
            Result := 'NULL'
        else
            Result := '0';
        Exit;
    end;
    for i := Length(LetraNumero) downto 1 do
    begin
        TextoFuncao := Copy(LetraNumero, i, 1);
        if ((TextoFuncao >= '0') and (TextoFuncao <= '9')) or (((TextoFuncao = '.') or (TextoFuncao = ',')) and (Decimal = False)) or
            ((TextoFuncao = '-') and (SinalNegativo = False)) then
        begin
            if ((TextoFuncao = ',') or (TextoFuncao = '.')) and (Decimal = False) then
            begin
                ResultadoFuncao := ResultadoFuncao + '.';
                Decimal := True;
            end
            else if TextoFuncao = '-' then
                SinalNegativo := True
            else
                ResultadoFuncao := ResultadoFuncao + Copy(LetraNumero, i, 1);
            TextoFuncao := Copy(LetraNumero, i, 1);
        end
        else
            TextoFuncao := Copy(LetraNumero, i, 1);
    end;
    TextoFuncao := ResultadoFuncao;
    ResultadoFuncao := '';
    for i := Length(TextoFuncao) downto 1 do
        ResultadoFuncao := ResultadoFuncao + Copy(TextoFuncao, i, 1);
    if ResultadoFuncao = '' then
        ResultadoFuncao := '0'
    else
    if SinalNegativo = True then
        ResultadoFuncao := '-' + ResultadoFuncao;
    if Copy(ResultadoFuncao, Length(ResultadoFuncao), 1) = '.' then
        Result := Copy(ResultadoFuncao, 1, Length(ResultadoFuncao) - 1)
    else
        Result := ResultadoFuncao;
    if Copy(ResultadoFuncao, 1, 1) = '.' then
        Result := '0' + ResultadoFuncao;
    while (Copy(Result, 1, 1) = '0') and (Copy(Result, 1, 2) <> '0.') and (Length(Result) > 1) do
        Result := Copy(Result, 2, Length(Result));
    if (Result = '0') and (ConsideraZeroNull) then
        Result := 'NULL';
    if (Result = '-1') and (ConsideraMenosUmNull) then
        Result := 'NULL';

end;

function IntToSQL(LetraNumero: int64; ConsideraZeroNull: boolean = False; ConsideraMenosUmNull: boolean = False): string;
begin
    Result := '';
    if (LetraNumero = 0) and (ConsideraZeroNull) then
        Result := 'NULL';
    if (ConsideraMenosUmNull) and (LetraNumero < 0) then
        Result := 'NULL';
    if Result = '' then

        Result := IntToStr(LetraNumero);
end;

function StrToSql(S: string; ConsideraNull: boolean = False; VL_Tamanho: int64 = 0): string;
begin
    if (ConsideraNull) and ((Trim(S) = '') or (UpperCase(Trim(S)) = 'NULL')) then
    begin
        Result := 'NULL';
        exit;
    end;

    Result := S;

    if VerificaSelect(Result) <> 'OK' then
        Result := '';

    // eric 28/10/2019
    if VL_Tamanho > 0 then
        Result := copy(Result, 0, VL_Tamanho);

    Result := '''' + ConverteSQL(Result) + '''';
end;

function VerificaSelect(Sql: string): string;
var
    VL_String: string;
begin
    VL_String := UpperCase(Sql);

    if ((pos(' OR ', VL_String) = 0) and
        (pos('OR  ', VL_String) = 0) and // linha nova
        (pos('  OR', VL_String) = 0) and // linha nova
        (pos('(OR:', VL_String) = 0) and
        (pos('(OR ', VL_String) = 0) and
        (pos('(OR' + #13, VL_String) = 0) and
        (pos('(OR--', VL_String) = 0) and
        (pos('(OR/', VL_String) = 0) and
        (pos('(OR(', VL_String) = 0) and
        (pos(' OR' + #13, VL_String) = 0) and
        (pos('OR' + #13, VL_String) = 0) and  // linha nova
        (pos('OR ' + #13, VL_String) = 0) and // linha nova
        (pos(' (OR' + #13, VL_String) = 0) and
        (pos(#$A + 'OR(', VL_String) = 0) and
        (pos(#$A + 'OR' + #13, VL_String) = 0) and
        (pos(#$A + 'OR ', VL_String) = 0) and
        (pos(#$A + 'OR/', VL_String) = 0) and
        (pos(#$A + 'OR:', VL_String) = 0) and
        (pos(' OR:', VL_String) = 0) and
        (pos('OR :', VL_String) = 0) and // linha nova
        (pos('OR:', VL_String) = 0) and  // linha nova
        (pos(' OR(', VL_String) = 0) and
        (pos('/OR', VL_String) = 0) and
        (pos('/ OR', VL_String) = 0) and
        (pos('OR/', VL_String) = 0) and
        (pos('OR /', VL_String) = 0) and // linha nova
        (pos('(OR ', VL_String) = 0) and
        (pos('OR--', VL_String) = 0) and
        (pos('OR --', VL_String) = 0) and
        (pos(' OR--', VL_String) = 0) and
        (pos(' OR''', VL_String) = 0) and
        (pos('''OR', VL_String) = 0) and // linha nova
        (pos('OR''', VL_String) = 0) and
        (pos(' OR ''', VL_String) = 0) and // linha nova
        (pos('OR ''', VL_String) = 0) and  // linha nova
        (pos('0OR', VL_String) = 0) and    // linha nova
        (pos('1OR', VL_String) = 0) and    // linha nova
        (pos('2OR', VL_String) = 0) and    // linha nova
        (pos('3OR', VL_String) = 0) and    // linha nova
        (pos('4OR', VL_String) = 0) and    // linha nova
        (pos('5OR', VL_String) = 0) and    // linha nova
        (pos('6OR', VL_String) = 0) and    // linha nova
        (pos('7OR', VL_String) = 0) and    // linha nova
        (pos('8OR', VL_String) = 0) and    // linha nova
        (pos('9OR', VL_String) = 0) and    // linha nova

        (pos(' SELECT ', VL_String) = 0) and
        (pos('SELECT ', VL_String) = 0) and
        (pos('(SELECT:', VL_String) = 0) and
        (pos('(SELECT ', VL_String) = 0) and
        (pos('(SELECT' + #13, VL_String) = 0) and
        (pos('(SELECT--', VL_String) = 0) and
        (pos('(SELECT/', VL_String) = 0) and
        (pos('(SELECT(', VL_String) = 0) and
        (pos(' SELECT' + #13, VL_String) = 0) and
        (pos(' (SELECT' + #13, VL_String) = 0) and
        (pos(#$A + 'SELECT(', VL_String) = 0) and
        (pos(#$A + 'SELECT' + #13, VL_String) = 0) and
        (pos(#$A + 'SELECT ' + #13, VL_String) = 0) and
        (pos(#$A + 'SELECT ', VL_String) = 0) and
        (pos(#$A + 'SELECT/', VL_String) = 0) and
        (pos(#$A + 'SELECT:', VL_String) = 0) and
        (pos(' SELECT:', VL_String) = 0) and
        (pos(' SELECT(', VL_String) = 0) and
        (pos('/SELECT', VL_String) = 0) and
        (pos('SELECT/', VL_String) = 0) and
        (pos('(SELECT ', VL_String) = 0) and
        (pos('SELECT--', VL_String) = 0) and
        (pos('SELECT --', VL_String) = 0) and
        (pos(' SELECT--', VL_String) = 0) and

        (pos(' DELETE ', VL_String) = 0) and
        (pos('DELETE ', VL_String) = 0) and
        (pos('(DELETE:', VL_String) = 0) and
        (pos('(DELETE ', VL_String) = 0) and
        (pos('(DELETE' + #13, VL_String) = 0) and
        (pos('(DELETE--', VL_String) = 0) and
        (pos('(DELETE/', VL_String) = 0) and
        (pos('(DELETE(', VL_String) = 0) and
        (pos(' DELETE' + #13, VL_String) = 0) and
        (pos('DELETE' + #13, VL_String) = 0) and
        (pos('DELETE ' + #13, VL_String) = 0) and
        (pos(' (DELETE' + #13, VL_String) = 0) and
        (pos(#$A + 'DELETE(', VL_String) = 0) and
        (pos(#$A + 'DELETE' + #13, VL_String) = 0) and
        (pos(#$A + 'DELETE ', VL_String) = 0) and
        (pos(#$A + 'DELETE/', VL_String) = 0) and
        (pos(#$A + 'DELETE:', VL_String) = 0) and
        (pos(' DELETE:', VL_String) = 0) and
        (pos(' DELETE(', VL_String) = 0) and
        (pos('/DELETE', VL_String) = 0) and
        (pos('DELETE/', VL_String) = 0) and
        (pos('(DELETE ', VL_String) = 0) and
        (pos('DELETE--', VL_String) = 0) and
        (pos('DELETE --', VL_String) = 0) and
        (pos(' DELETE--', VL_String) = 0) and

        (pos(' UPDATE ', VL_String) = 0) and
        (pos('UPDATE ', VL_String) = 0) and
        (pos('(UPDATE:', VL_String) = 0) and
        (pos('(UPDATE ', VL_String) = 0) and
        (pos('(UPDATE' + #13, VL_String) = 0) and
        (pos('(UPDATE--', VL_String) = 0) and
        (pos('(UPDATE/', VL_String) = 0) and
        (pos('(UPDATE(', VL_String) = 0) and
        (pos(' UPDATE' + #13, VL_String) = 0) and
        (pos(' (UPDATE' + #13, VL_String) = 0) and
        (pos('UPDATE' + #13, VL_String) = 0) and
        (pos('UPDATE ' + #13, VL_String) = 0) and
        (pos(#$A + 'UPDATE(', VL_String) = 0) and
        (pos(#$A + 'UPDATE' + #13, VL_String) = 0) and
        (pos(#$A + 'UPDATE ' + #13, VL_String) = 0) and
        (pos(#$A + 'UPDATE ', VL_String) = 0) and
        (pos(#$A + 'UPDATE/', VL_String) = 0) and
        (pos(#$A + 'UPDATE:', VL_String) = 0) and
        (pos(' UPDATE:', VL_String) = 0) and
        (pos(' UPDATE(', VL_String) = 0) and
        (pos('/UPDATE', VL_String) = 0) and
        (pos('UPDATE/', VL_String) = 0) and
        (pos('UPDATE /', VL_String) = 0) and
        (pos('(UPDATE ', VL_String) = 0) and
        (pos('UPDATE--', VL_String) = 0) and
        (pos('UPDATE --', VL_String) = 0) and
        (pos(' UPDATE--', VL_String) = 0) and

        (pos(' INSERT ', VL_String) = 0) and
        (pos('INSERT ', VL_String) = 0) and
        (pos('(INSERT:', VL_String) = 0) and
        (pos('(INSERT ', VL_String) = 0) and
        (pos('(INSERT' + #13, VL_String) = 0) and
        (pos('(INSERT--', VL_String) = 0) and
        (pos('(INSERT/', VL_String) = 0) and
        (pos('(INSERT(', VL_String) = 0) and
        (pos(' INSERT' + #13, VL_String) = 0) and
        (pos(' (INSERT' + #13, VL_String) = 0) and
        (pos('INSERT' + #13, VL_String) = 0) and
        (pos('INSERT ' + #13, VL_String) = 0) and
        (pos(#$A + 'INSERT(', VL_String) = 0) and
        (pos(#$A + 'INSERT' + #13, VL_String) = 0) and
        (pos(#$A + 'INSERT ', VL_String) = 0) and
        (pos(#$A + 'INSERT/', VL_String) = 0) and
        (pos(#$A + 'INSERT:', VL_String) = 0) and
        (pos(' INSERT:', VL_String) = 0) and
        (pos(' INSERT(', VL_String) = 0) and
        (pos('/INSERT', VL_String) = 0) and
        (pos('INSERT/', VL_String) = 0) and
        (pos('(INSERT ', VL_String) = 0) and
        (pos('INSERT--', VL_String) = 0) and
        (pos('INSERT --', VL_String) = 0) and
        (pos(' INSERT--', VL_String) = 0) and

        (pos(' DROP ', VL_String) = 0) and
        (pos('DROP ', VL_String) = 0) and
        (pos('(DROP:', VL_String) = 0) and
        (pos('(DROP ', VL_String) = 0) and
        (pos('(DROP' + #13, VL_String) = 0) and
        (pos('(DROP--', VL_String) = 0) and
        (pos('(DROP/', VL_String) = 0) and
        (pos('(DROP(', VL_String) = 0) and
        (pos(' DROP' + #13, VL_String) = 0) and
        (pos(' (DROP' + #13, VL_String) = 0) and
        (pos('DROP' + #13, VL_String) = 0) and
        (pos('DROP ' + #13, VL_String) = 0) and
        (pos(#$A + 'DROP(', VL_String) = 0) and
        (pos(#$A + 'DROP' + #13, VL_String) = 0) and
        (pos(#$A + 'DROP ', VL_String) = 0) and
        (pos(#$A + 'DROP/', VL_String) = 0) and
        (pos(#$A + 'DROP:', VL_String) = 0) and
        (pos(' DROP:', VL_String) = 0) and
        (pos(' DROP(', VL_String) = 0) and
        (pos('/DROP', VL_String) = 0) and
        (pos('DROP/', VL_String) = 0) and
        (pos('(DROP ', VL_String) = 0) and
        (pos('DROP--', VL_String) = 0) and
        (pos('DROP --', VL_String) = 0) and
        (pos(' DROP--', VL_String) = 0) and

        (pos(' ALTER ', VL_String) = 0) and
        (pos('ALTER ', VL_String) = 0) and
        (pos('(ALTER:', VL_String) = 0) and
        (pos('(ALTER ', VL_String) = 0) and
        (pos('(ALTER' + #13, VL_String) = 0) and
        (pos('(ALTER--', VL_String) = 0) and
        (pos('(ALTER/', VL_String) = 0) and
        (pos('(ALTER(', VL_String) = 0) and
        (pos(' ALTER' + #13, VL_String) = 0) and
        (pos(' (ALTER' + #13, VL_String) = 0) and
        (pos('ALTER' + #13, VL_String) = 0) and
        (pos('ALTER ' + #13, VL_String) = 0) and
        (pos(#$A + 'ALTER(', VL_String) = 0) and
        (pos(#$A + 'ALTER' + #13, VL_String) = 0) and
        (pos(#$A + 'ALTER ', VL_String) = 0) and
        (pos(#$A + 'ALTER/', VL_String) = 0) and
        (pos(#$A + 'ALTER:', VL_String) = 0) and
        (pos(' ALTER:', VL_String) = 0) and
        (pos(' ALTER(', VL_String) = 0) and
        (pos('/ALTER', VL_String) = 0) and
        (pos('ALTER/', VL_String) = 0) and
        (pos('(ALTER ', VL_String) = 0) and
        (pos('ALTER--', VL_String) = 0) and
        (pos('ALTER --', VL_String) = 0) and
        (pos(' ALTER--', VL_String) = 0) and

        (pos(' CREATE ', VL_String) = 0) and
        (pos('CREATE ', VL_String) = 0) and
        (pos('(CREATE:', VL_String) = 0) and
        (pos('(CREATE ', VL_String) = 0) and
        (pos('(CREATE' + #13, VL_String) = 0) and
        (pos('(CREATE--', VL_String) = 0) and
        (pos('(CREATE/', VL_String) = 0) and
        (pos('(CREATE(', VL_String) = 0) and
        (pos(' CREATE' + #13, VL_String) = 0) and
        (pos(' (CREATE' + #13, VL_String) = 0) and
        (pos('CREATE' + #13, VL_String) = 0) and
        (pos('CREATE ' + #13, VL_String) = 0) and
        (pos(#$A + 'CREATE(', VL_String) = 0) and
        (pos(#$A + 'CREATE' + #13, VL_String) = 0) and
        (pos(#$A + 'CREATE ', VL_String) = 0) and
        (pos(#$A + 'CREATE/', VL_String) = 0) and
        (pos(#$A + 'CREATE:', VL_String) = 0) and
        (pos(' CREATE:', VL_String) = 0) and
        (pos(' CREATE(', VL_String) = 0) and
        (pos('/CREATE', VL_String) = 0) and
        (pos('CREATE/', VL_String) = 0) and
        (pos('(CREATE ', VL_String) = 0) and
        (pos('CREATE--', VL_String) = 0) and
        (pos('CREATE --', VL_String) = 0) and
        (pos(' CREATE--', VL_String) = 0)) then

        Result := 'OK'
    else
        Result := 'Erro';

end;

function ConverteSQL(Script: string): string;
var
    LocalLetraFuncao: int64;
    i: integer;
    ResultadoFuncao: string;
    TextoFuncao: string;
begin
    Result := '';
    LocalLetraFuncao := 1;
    ResultadoFuncao := '';
    for I := 1 to Length(Script) do
    begin
        TextoFuncao := copy(Script, LocalLetraFuncao, 1);
        if TextoFuncao <> '''' then
            ResultadoFuncao := ResultadoFuncao + copy(Script, LocalLetraFuncao, 1)
        else
            ResultadoFuncao := ResultadoFuncao + '''''';
        LocalLetraFuncao := LocalLetraFuncao + 1;

    end;
    Result := ResultadoFuncao;
end;

function CriaID: string;
var
    VL_ID: string;
begin
    VF_Sequencia := VF_Sequencia + 1;
    VL_ID := IntToStr(VF_Sequencia);
    VL_ID := VL_ID + FormatDateTime('dd/mm/yyyy hh:mm:ss:zzz', Now);
    Randomize;
    Result := VL_ID + IntToStr(Random(999));

end;

function ByteToHex(Value: TLBytes): string;
var
    I: integer;
begin
    Result := '';
    for I := 0 to Length(Value) - 1 do
    begin
        Result := Result + IntToHex(Value[I], 2);
    end;
end;

procedure HexToByte(Value: string; var VO_Retorno: TLBytes);
var
    i, T: integer;
begin
    T := Length(Value);
    i := t div 2;

    SetLength(VO_Retorno, i);

    for i := 1 to T div 2 do
        VO_Retorno[i - 1] := StrToInt('$' + Copy(Value, (i - 1) * 2 + 1, 2));
end;

function CriaChave(Tamanho: int64): string;
var
    i: integer;
    Intervalo: int64;
    VS: string;
begin
    Result := '';
    VS := IntToStr(RandomRange(10000000, 99999999));
    VS := Copy(VS, Length(VS) - 8, 8);
    for i := 0 to Tamanho - 1 do
    begin
        VS := FloatToStr(CLNNumeros(FloatToStr(StrToFloat(VS) * 0.9)));
        Intervalo := StrToInt(Copy(VS, Length(VS) - 2, 2));
        if Intervalo > 35 then
            Intervalo := Intervalo div 3;
        Result := Result + Letra[Intervalo];
    end;
end;


initialization
    VF_Sequencia := 0;
    InitCriticalSection(VF_CriticoLog);

finalization
    DoneCriticalSection(VF_CriticoLog);
end.
