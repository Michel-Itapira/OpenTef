unit funcoes;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils, StrUtils, ZDataset, ZConnection, DB, rxmemds, IdContext, IdSSLOpenSSL, syncobjs, def, ExtCtrls, Graphics,ubarcodes,nb30;

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
        function TrataErro(VP_CodigoErro: variant; var VO_RespostaMensagem: string): integer;
    end;

    TPinPadModelo = (pNDF, pGERTEC_PPC930);
    TRespostaPinPad = procedure(VP_Processo_ID: integer; VP_Mensagem: TMensagem);
    TPinPadErro = procedure(errCode: int16; msg: pansichar);


    TConexaoTipo = (cnCaixa, cnServico, cnNaoDefinido);
    TAguardaEvento = (agTempo, agEvento, agAborta);
    TRetornoModulo = procedure(VP_Transmissao_ID: PChar; VP_Tarefa_ID, VP_ProcID, VP_Codigo: integer; VP_Dados: PChar); stdcall;
    TRetorno = procedure(VP_Transmissao_ID: PChar; VP_ProcID, VP_Codigo: integer; VP_Dados: PChar); stdcall;
    TServidorRecebimento = procedure(VP_Codigo: integer; VP_Transmissao_ID, VP_DadosRecebidos: string; var VO_AContext: TIdContext);
    TServidorRecebimentoLib = function(VP_Codigo: integer; VP_Transmissao_ID, VP_DadosRecebidos: PChar; VP_IP: PChar; VP_ID: integer): integer; stdcall;
    TConexaoStatus = (csDesconectado, csLink, csChaveado, csLogado, csNaoInicializado);
    TTransacaoStatus = (tsEfetivada, tsNegada, tsCancelada, tsProcessando, tsAguardandoComando, tsNaoLocalizada, tsInicializada,
        tsComErro, tsAbortada, tsAguardandoDadosPDV);


    TPermissao = (pmS, pmC, pmA, pmU);  // pmS=permissao de sistema
    // pmC=permissao de controlador permissao maxima
    // pmA permissao de administrador pode gerenciar as transacao e fazer cadastros
    // pmU permissao de usuario consulta e visualizacao das transacoes

    TTipoDocumento = (tdCNPJ, tdCPF); // tipo do documento prar formata????o

    TTipoChave = (tcC50,tcPDV,tcConfigurador,tcModuloConfig); // tipo de chaves de valida????o

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
        constructor Create(VP_Terminal_Tipo: ansistring; VP_Terminal_ID: int64; VP_TransacaoString: ansistring);
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
procedure CriarChaveTerminal(VP_TipoChave : TTipoChave;VP_ValorChave : string; var VO_Chave: ansistring);
procedure GravaLog(VP_Arquivo: string; VP_Modulo_ID: integer; VP_Tag_Comando, VP_Unit, VP_Linha, VP_Ocorrencia, VP_Tag: ansistring; VP_CodigoErro: integer);
function PermissaoToStr(VP_Permissao: TPermissao): ansistring;
function StrToPermissao(VP_Permissao: ansistring): TPermissao;
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
function TempoPassouMiliSegundos(VP_Agora: TDateTime): integer;
procedure StrToImagem(Dados: string; var Imagem: Timage; Tipo_Imagem: TImagem = TI_JPG);
procedure ImagemToStr(var Dados: string; Imagem: TImage);
procedure BarcodeToStr(var Dados:String;Barcode: TBarcodeQR);


procedure CopiaDadosSimples(VO_TOrigemMemDataset: TRxMemoryData; VO_TDestinoMemDataset: TRxMemoryData; VL_Linha: boolean = False);

function mensagemcreate(var VP_Mensagem: Pointer): integer; stdcall;
function mensagemcarregatags(VP_Mensagem: Pointer; VP_Dados: PChar): integer; stdcall;
function mensagemcomando(VP_Mensagem: Pointer): PChar; stdcall;
function mensagemcomandodados(VP_Mensagem: Pointer): PChar; stdcall;
procedure mensagemfree(VP_Mensagem: Pointer); stdcall;
function mensagemaddtag(VP_Mensagem: Pointer; VP_Tag, VP_Dados: PChar): integer; stdcall;
function mensagemaddcomando(VP_Mensagem: Pointer; VP_Tag, VP_Dados: PChar): integer; stdcall;
function mensagemtagasstring(VP_Mensagem: Pointer): PChar; stdcall;
function mensagemtagcount(VP_Mensagem: Pointer): integer; stdcall;
function mensagemgettag(VP_Mensagem: Pointer; VP_Tag: PChar; var VO_Dados: PChar): integer; stdcall;
function mensagemgettagidx(VP_Mensagem: Pointer; VL_Idx: integer; var VO_Tag: PChar; var VO_Dados: PChar): integer; stdcall;
function mensagemtagtostr(VP_Mensagem: Pointer; var VO_Dados: PChar): integer; stdcall;
procedure mensagemlimpar(VP_Mensagem: Pointer); stdcall;

var
    VF_Sequencia: longint;
    VF_CriticoLog: TRTLCriticalSection;


implementation

function GetAdapterInfo(Lana: Char): string;
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
IntToHex(Byte(Adapter.adapter_address[5]), 2);
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
if Byte(AdapterList.length) > 0 then
Result := GetAdapterInfo(char(AdapterList.lana[0]))
else
Result := 'Address not known';
end;


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
    Dados:='';
    Sm := TStringStream.Create('');
    Imagem.Picture.SaveToStream(Sm);
    S := sm.DataString;

    for i := 0 to Length(S) -1  do
        Dados := Dados + HexStr(Ord(S[i+1]), 2);


    Sm.Free;
end;

procedure BarcodeToStr(var Dados:String;Barcode: TBarcodeQR);
  var
  bmp: TFPImageBitmap;
  img:TImage;
begin
    bmp := TBitmap.Create;
    img:=TImage.Create(nil);
  try
    bmp.SetSize(Barcode.Width,Barcode.Height);
    bmp.Canvas.Brush.Color := clWhite;
    bmp.Canvas.FillRect(0, 0, bmp.Width, bmp.Height);
    Barcode.PaintOnCanvas(bmp.Canvas, Rect(0, 0, bmp.Width, bmp.Height));

    img.Picture.Assign(bmp);

    ImagemToStr(Dados,img);


  finally
    bmp.Free;
    img.Free;
  end;

end;


function mensagemcreate(var VP_Mensagem: Pointer): integer; stdcall;
begin
    Result := 0;
    Pointer(VP_Mensagem) := pointer(TMensagem.Create);

end;

function mensagemcarregatags(VP_Mensagem: Pointer; VP_Dados: PChar): integer; stdcall;
begin
    Result := TMensagem(VP_Mensagem).CarregaTags(VP_Dados);
end;

function mensagemcomando(VP_Mensagem: Pointer): PChar; stdcall;
begin
    Result := PChar(TMensagem(VP_Mensagem).Comando());
end;

function mensagemcomandodados(VP_Mensagem: Pointer): PChar; stdcall;
begin
    Result := PChar(TMensagem(VP_Mensagem).ComandoDados());
end;

procedure mensagemfree(VP_Mensagem: Pointer); stdcall;
begin
    if Assigned(VP_Mensagem) then
        TMensagem(VP_Mensagem).Free;
end;

function mensagemaddtag(VP_Mensagem: Pointer; VP_Tag, VP_Dados: PChar): integer; stdcall;
begin
    Result := TMensagem(VP_Mensagem).AddTag(VP_Tag, VP_Dados);
end;

function mensagemaddcomando(VP_Mensagem: Pointer; VP_Tag, VP_Dados: PChar): integer; stdcall;
begin
    Result := TMensagem(VP_Mensagem).AddComando(VP_Tag, VP_Dados);
end;

function mensagemtagasstring(VP_Mensagem: Pointer): PChar; stdcall;
begin
    Result := PChar(TMensagem(VP_Mensagem).TagsAsString());
end;

function mensagemtagcount(VP_Mensagem: Pointer): integer; stdcall;
begin
    Result := TMensagem(VP_Mensagem).TagCount;
end;

function mensagemgettag(VP_Mensagem: Pointer; VP_Tag: PChar; var VO_Dados: PChar): integer; stdcall;
var
    VL_Dados: ansistring;
begin
    VL_Dados := '';
    Result := TMensagem(VP_Mensagem).GetTag(VP_Tag, VL_Dados);

    VO_Dados := StrAlloc(Length(VL_Dados) + 1);
    StrPCopy(VO_Dados, VL_Dados);

end;

function mensagemgettagidx(VP_Mensagem: Pointer; VL_Idx: integer; var VO_Tag: PChar; var VO_Dados: PChar): integer; stdcall;
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

function mensagemtagtostr(VP_Mensagem: Pointer; var VO_Dados: PChar): integer; stdcall;
var
    VL_Dados: ansistring;

begin
    VL_Dados := '';
    Result := TMensagem(VP_Mensagem).TagToStr(VL_Dados);
    VO_Dados := StrAlloc(Length(VL_Dados) + 1);
    StrPCopy(VO_Dados, VL_Dados);
end;

procedure mensagemlimpar(VP_Mensagem: Pointer); stdcall;
begin
    TMensagem(VP_Mensagem).Limpar;
end;


{$R *.lfm}

{ TErroMensagem }

function TErroMensagem.TrataErro(VP_CodigoErro: variant; var VO_RespostaMensagem: string): integer;

begin
    VO_RespostaMensagem := '';
    Result := 0;

    if StrToIntDef(VP_CodigoErro, 0) = 0 then
        VP_CodigoErro := 0;

    if VP_CodigoErro = 0 then
    begin
        Result := 0;
        exit;
    end
    else
    begin
        case VP_CodigoErro of
            2: VO_RespostaMensagem := 'PORTA PINPAD N??O INFORMADA';
            3: VO_RespostaMensagem := 'MODELO PINPAD N??O INFORMADO';
            4: VO_RespostaMensagem := 'MODELO PINPAD N??O SUPORTADO';
            5: VO_RespostaMensagem := 'FALHA NA CONEX??O COM PINPAD';
            6: VO_RespostaMensagem := 'PINPAD RETORNOU FALHA(CONSULTA N?? DA FALHA NO RETORNO AUXILIAR)';
            7: VO_RespostaMensagem := 'DLL OU S.O DO PINPAD N??O ENCONTRADA';
            8: VO_RespostaMensagem := 'DLL OU S.O DO PINPAD N??O COMPAT??VEL(VERIFIQUE 32 OU 64 BITS)';
            9: VO_RespostaMensagem := 'HOST  N??O INFORMADO PARA O TEF';
            10: VO_RespostaMensagem := 'HOST N??O COMPAT??VEL PARA O TEF';
            11: VO_RespostaMensagem := 'PORTA N??O INFORMADA PARA O TEF';
            12: VO_RespostaMensagem := 'PORTA N??O COMPAT??VEL  PARA O TEF';
            13: VO_RespostaMensagem := 'VERS??O_COMUNICA????O N??O INFORMADA PARA O TEF';
            14: VO_RespostaMensagem := 'VERS??O_COMUNICA????O N??O COMPAT??VEL PARA O TEF';
            15: VO_RespostaMensagem := 'CHAVE N??O INFORMADA PARA O TEF';
            16: VO_RespostaMensagem := 'CHAVE N??O COMPAT??VEL PARA O TEF';
            17: VO_RespostaMensagem := 'VERS??O DLL DO TEF N??O COMPAT??VEL (SUGERE ATUALIZA????O)';
            18: VO_RespostaMensagem := 'PACOTE COM A PRIMEIRA TAG DIFERENTE DE ???0000???';
            19: VO_RespostaMensagem := 'ERRO O TAMANHO DO PACOTE N??O PODE SER ZERO';
            20: VO_RespostaMensagem := 'ERRO O TAMANHO DO PACOTE DIFERENTE DO TAMANHO DA MENSAGEM';
            21: VO_RespostaMensagem := 'ERRO OS DADOS DO PACOTE MAIOR QUE OS DADOS DA MENSAGEM';
            22: VO_RespostaMensagem := 'ERRO N??O EXISTE PACOTE PARA A FUN????O GET DA TAG';
            23: VO_RespostaMensagem := 'ERRO N??O EXISTE PACOTE PARA A FUN????O ???TAGTOSTR???';
            24: VO_RespostaMensagem := 'N??O FOI POSS??VEL ENVIAR MENSAGEM';
            25: VO_RespostaMensagem := 'N??O FOI POSS??VEL CONECTAR AO SERVIDOR PARA ESCUTAR';
            26: VO_RespostaMensagem := 'N??O FOI POSS??VEL CONECTAR AO SERVIDOR ABERTURA SOCKET';
            27: VO_RespostaMensagem := 'ERRO N??O EXISTE PACOTE PARA A FUN????O ADD DA TAG';
            28: VO_RespostaMensagem := 'ERRO, PAR??METRO NULO OU DIFERENTE DA ESTRUTURA DA TAG';
            29: VO_RespostaMensagem := 'ERRO TAG N??O LOCALIZADA NO PACOTE DA FUN????O GET DA TAG';
            30: VO_RespostaMensagem := 'DADOS DO PACOTE MAL FORMATADO OU INCOMPAT??VEL, IMPOSS??VEL DE LER';
            31: VO_RespostaMensagem := 'CHAVE PUBLICA N??O LOCALIZADA';
            32: VO_RespostaMensagem := 'PROBLEMA NAS TROCAS DE CHAVES NO CONECTAR';
            33: VO_RespostaMensagem := 'SOCKET DO SERVIDOR VINCULADO ESTA DESCONECTADO';
            34: VO_RespostaMensagem := 'LOGIN RECUSADO';
            35: VO_RespostaMensagem := 'SERVIDOR N??O ESTA EM STATUS DE LOGADO';
            36: VO_RespostaMensagem := 'CHAVE N??O LOCALIZADA PARA OPENTEF';
            37: VO_RespostaMensagem := 'SENHA DE ACESSO N??O INFORMADO PARA O TEF';
            38: VO_RespostaMensagem := 'IP N??O N??O COMPATIVEL PARA O TERMINAL';
            39: VO_RespostaMensagem := 'SENHA N??O COMPAT??VEL PARA O TERMINAL';
            40: VO_RespostaMensagem := 'ERRO VALIDA????O DO TERMINAL';
            41: VO_RespostaMensagem := 'CHAVE DO TERMINAL N??O LOCALIZADA';
            42: VO_RespostaMensagem := 'TIPO DE PERMISS??O N??O INFORMADA PARA O TEF';
            43: VO_RespostaMensagem := 'REGISTRO EM DUPLICIDADE NO BANCO DE DADOS';
            44: VO_RespostaMensagem := 'ERRO NA INCLUS??O DO REGISTRO';
            45: VO_RespostaMensagem := 'PERMISS??O N??O AUTORIZADO PARA ESTE PROCEDIMENTO';
            46: VO_RespostaMensagem := 'ERRO NA ALTERA????O DO REGISTRO';
            47: VO_RespostaMensagem := 'DADOS INFORMADO N??O PODE SER ZERO';
            48: VO_RespostaMensagem := 'TABELA SEM REGISTRO NO BANCO DE DADOS';
            49: VO_RespostaMensagem := 'DADOS CHAVES PARA O CADASTRO N??O PODEM SOFRER ALTERA????O';
            50: VO_RespostaMensagem := 'BIBLIOTECA DO PINPAD N??O FOI POSSIVEL CARREGAR';
            51: VO_RespostaMensagem := 'TIPO DE LEITURA DE CART??O N??O SUPORTADO';
            52: VO_RespostaMensagem := 'CAMPO OBRIGAT??RIO N??O PODE SER NULO';
            53: VO_RespostaMensagem := 'N??O FOI POSSIVEL ENVIAR A MENSAGEM DE RETORNO PARA O ID INFORMADO';
            54: VO_RespostaMensagem := 'N??O FOI POSSIVEL INICIALIZAR O MODULO';
            55: VO_RespostaMensagem := 'ERRO NA PESQUISA DA TABELA';
            56: VO_RespostaMensagem := 'N??O FOI ENCONTRADO NENHUMA CONFIGURA????O DE MENU DE CAIXA';
            57: VO_RespostaMensagem := 'ERRO NO FLUXO DAS TRANSA????ES DA TAG 0018';
            58: VO_RespostaMensagem := 'ERRO AO CRIAR A TRANSACAO';
            59: VO_RespostaMensagem := 'ERRO AO PEGAR O STATUS DA TRANSACAO';
            60: VO_RespostaMensagem := 'ERRO AO EXCLUIR UMA TRANSACAO NO TEF_LIB';
            61: VO_RespostaMensagem := 'ERRO AO RECEBER A FUNCAO TRANSACAO CREATE DO OPENTEF';
            62: VO_RespostaMensagem := 'ERRO NO PEDIDO DE CRIA????O DE TRANSA????O';
            63: VO_RespostaMensagem := 'BIN JA ESTAVA CADASTRADO PARA OUTRO MODULO';
            64: VO_RespostaMensagem := 'REGISTRO DE MODULO N??O CARREGADO OU N??O LOCALIZADO';
            65: VO_RespostaMensagem := 'N??O FOI POSSIVE ATUALIZAR A TABELA DE BINS';
            66: VO_RespostaMensagem := 'CONEXAO DO TEMPORIZADOR NAO ENCONTRADA';
            67: VO_RespostaMensagem := 'A TRANSMISSAO NAO REPONDIDA EM TEMPO HABIL';
            68: VO_RespostaMensagem := 'DADOS DA TRANSMISS??O N??O TEM COMANDO 00D1';
            69: VO_RespostaMensagem := 'A COMUNICACAO FOI ABORTADA';
            70: VO_RespostaMensagem := 'Modulo config n??o carregado para incluir solicita????o';
            71: VO_RespostaMensagem := 'NAO FOI POSSIVEL ATUALIZAR A TABELA DE MENUS';
            72: VO_RespostaMensagem := 'MENU JA ESTAVA CADASTRADO PARA OUTRO MODULO';
            73: VO_RespostaMensagem := 'MENU N??O ESTA NA LISTA DE MENUS OFICIAIS HABILITADOS USE TAG INICIO ???FF???';
            74: VO_RespostaMensagem := 'BIN inv??lido';
            75: VO_RespostaMensagem := 'Tag do botao do menu inv??lido';
            76: VO_RespostaMensagem := 'Texto do botao do menu inv??lido';
            77: VO_RespostaMensagem := 'pinpad_lib  N??O CARREGADO';
            78: VO_RespostaMensagem := 'COMANDO NAO IMPLEMENTADO PELO PINPD';
            79: VO_RespostaMensagem := 'N??o foi poss??vel achar uma operadora para processar o cart??o';
            80: VO_RespostaMensagem := 'Essa solicita????o de aprova????o n??o esta em conformidade';
            81: VO_RespostaMensagem := 'ESSA CONEXAO N??O PERMITE APROVA????O';
            82: VO_RespostaMensagem := 'ERRO NA EXCLUS??O DO REGISTRO';
            83: VO_RespostaMensagem := 'A CONEX??O FOI DESCONECTA INESPERADAMENTE';
            84: VO_RespostaMensagem := 'A OPERADORA/ADQUIRENTE EXIGE CRIPTOGRAFIA, MAIS N??O ENVIOU AS CHAVES';
            85: VO_RespostaMensagem := 'Erro de tempo em capturar a senha no pinpad';
            else
            begin
                Result := 1;
                VO_RespostaMensagem := 'Erro Desconhecido ou n??o catalogado';
                exit;
            end;
        end;
        Result := VP_CodigoErro;
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
   Result := fMensagem.GetTagAsAstring('00F0');
end;


constructor TTransacao.Create(VP_Terminal_Tipo: ansistring; VP_Terminal_ID: int64; VP_TransacaoString: ansistring);
begin
    inherited Create;

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
    fMensagem.AddTag('007C', FloatToStr(Now));
    fMensagem.AddTag('00A4', TransacaoStatusToInt(tsAguardandoComando));
    fMensagem.AddTag('0034', IntToStr(VF_Sequencia) + '-' + VP_Terminal_Tipo + '-' + IntToStr(VP_Terminal_ID) + '-' + FormatDateTime('dd/mm/yyyy hh:mm:ss:zzz', Now));

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


procedure CriarChaveTerminal(VP_TipoChave : TTipoChave;VP_ValorChave : string; var VO_Chave: ansistring);
var
    VL_Chave: ansistring;
    I: integer;
begin
    VL_Chave := '';
    VO_Chave:='';
    Randomize;
    case VP_TipoChave of
       tcC50 :
         begin
             for I := 0 to 50 do
             begin
                 if Length(VL_Chave) < 50 then
                     VL_Chave := VL_Chave + IntToStr(Random(99)) + IntToStr(Random(999));
             end;
             VO_Chave := Copy(VL_Chave, 1, 50);
         end;
       tcPDV :
       begin
            VL_Chave:='';
            if length(VP_ValorChave)=0 then
               exit;

            //gera o mac
                   // n??o feito
            VL_Chave := GetMACAddress;

            VL_Chave:= VP_ValorChave+VL_Chave;
            VO_Chave:=VL_Chave;
       end;
    end;
end;

procedure GravaLog(VP_Arquivo: string; VP_Modulo_ID: integer; VP_Tag_Comando, VP_Unit, VP_Linha, VP_Ocorrencia, VP_Tag: ansistring; VP_CodigoErro: integer);
var
    VL_Arquivo: TextFile;
begin
    if VP_Arquivo = '' then
        exit;
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
            raise Exception.Create('Esse valor:"' + VP_Permissao + '" n??o ?? uma permissao');
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
            raise Exception.Create('Esse valor:"' + IntToStr(PinPadModeloToInt(VP_PinPadModelo)) + '" n??o ?? um pinpad valido');
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
    I: int64;
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
    //Tag n??o encontrada no pacote
    Result := 29;

    //Verifica se existe o pacote
    if length(fTags) = 0 then
    begin
        Result := 22;
        Exit;
    end;
    //Verifica se o parametro ?? nulo ou diferente da estrutura
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
    //Tag n??o encontrada no pacote

    Result := 29;

    //Verifica se existe o pacote
    if length(fTags) = 0 then
    begin
        Result := 22;
        Exit;
    end;
    //Verifica se o parametro ?? nulo ou diferente da estrutura
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

function TempoPassouMiliSegundos(VP_Agora: TDateTime): integer;
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
    AddComando('0000','');
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
