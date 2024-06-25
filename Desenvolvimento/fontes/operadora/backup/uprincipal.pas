unit uprincipal;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
    ComCtrls, Base64, rxspin, LbClass, LbCipher;

type
    TLBytes = array of byte;
    { TForm1 }

    TTransacaoStatus = (tsEfetivada, tsNegada, tsCancelada, tsProcessando, tsAguardandoComando, tsNaoLocalizada, tsInicializada, tsComErro, tsAbortada);

    TServidorRecebimentoLib = function(VP_Codigo: integer; VP_Transmissao_ID, VP_DadosRecebidos: pansichar; VP_IP: pansichar;
        VP_ID: integer; VP_Chave: pansichar): integer; cdecl;

    Tiniciarconexao = function(VP_ArquivoLog, VP_Chave, VP_IP_Caixa, VP_IP_Servico: pansichar; VP_PortaCaixa, VP_PortaServico: integer;
        VO_RetornoCaixa, VO_Retorno_Servico: TServidorRecebimentoLib; VP_Identificacao: pansichar): integer; cdecl;
    Tfinalizaconexao = function(): integer; cdecl;
    TResponde = function(VP_Transmissao_ID, VP_Mensagem: pansichar; VP_ID: integer): integer; cdecl;

    TTMensagemCreate = function(var VO_Mensagem: Pointer): integer; cdecl;
    TTMensagemCarregaTags = function(VP_Mensagem: Pointer; VP_Dados: pansichar): integer; cdecl;
    TTMensagemComando = function(VP_Mensagem: Pointer; var VO_Dados: pansichar): integer; cdecl;
    TTMensagemComandoDados = function(VP_Mensagem: Pointer; var VO_Dados: pansichar): integer; cdecl;
    TTMensagemFree = procedure(VP_Mensagem: Pointer); cdecl;
    TTMensagemaddtag = function(VP_Mensagem: Pointer; VP_Tag, VP_Dados: pansichar): integer; cdecl;
    TTMensagemaddcomando = function(VP_Mensagem: Pointer; VP_Tag, VP_Dados: pansichar): integer; cdecl;
    TTMensagemTagAsString = function(VP_Mensagem: Pointer; var VO_Dados: pansichar): integer; cdecl;
    TTMensagemTagCount = function(VP_Mensagem: Pointer): integer; cdecl;
    TTMensagemGetTag = function(VP_Mensagem: Pointer; VP_Tag: pansichar; var VO_Dados: pansichar): integer; cdecl;
    TTMensagemGetTagIdx = function(VP_Mensagem: Pointer; VL_Idx: integer; var VO_Tag: pansichar; var VO_Dados: pansichar): integer; cdecl;
    TTMensagemTagToStr = function(VP_Mensagem: Pointer; var VO_Dados: pansichar): integer; cdecl;
    TTMensagemLimpar = procedure(VP_Mensagem: Pointer); cdecl;
    TTMensagemerro = function(VP_CodigoErro: integer; var VO_RespostaMensagem: pansichar): integer; cdecl;

    TDescriptaSenha3Des = function(VP_Wk, VP_pan, VP_Senha: pansichar): pansichar; cdecl;
    TEncriptaSenha3Des = function(VP_Wk, VP_pan, VP_Senha: pansichar): pansichar; cdecl;
    Twkc = function(): ansistring; cdecl;
    Timk = function(): integer; cdecl;
    TpinFromPindPad = function(Pin, Pan, WK: string): string;

    { TOpenTef }

    TRecOpeTef = record

        V_ID: integer;
        V_ConexaoID: string;
        V_Tipo: string;  // C=CAIXA S=SERVICO
        V_Chave: string;
        V_IP: string;

    end;

    { TOpenTef }

    TOpenTef = class
        V_Lista: TList;
    public
        constructor Create;
        destructor Destroy; override;
        function GetRecOpeTef(VP_Idex: integer): TRecOpeTef;
        function Count: integer;
        function Add(VP_ID: integer; VP_ConexaoID, VP_Tipo, VP_Chave, VP_IP: string): integer;
        function Remove(VP_ID: integer): integer;
    end;

    TRecTransacao = record
        V_Transacao_ID: string;
        V_FotoEnviadaPDV: boolean;
        V_QrCodeEnviadoPDV: boolean;
        V_QrCodeEnviadoPinpad: boolean;
    end;

    TTransacao = class
        V_Lista: TList;
    public
        constructor Create;
        destructor Destroy; override;
        function Add(VP_Transacao_ID: string): TRecTransacao;
        function Remove(VP_Transacao_ID: string): integer;
        function Salvar(VP_Transacao_ID: string; VP_Rec_Transacao: TRecTransacao): integer;
    end;


    TForm1 = class(TForm)
        BAtiva: TButton;
        BConsultarTef: TButton;
        BMostrarMensagem: TButton;
        BDataNascimentoPinPad: TButton;
        BQrcodePdv: TButton;
        BDesativar: TButton;
        Bevel1: TBevel;
        BInicializaDll: TButton;
        Button1: TButton;
        Button2: TButton;
        cCpfPdv: TCheckBox;
        cQrcodePdv: TCheckBox;
        cMensagemPdv: TCheckBox;
        cImprimir: TCheckBox;
        cFotoPdv: TCheckBox;
        cQrcodePinPad: TCheckBox;
        cSenhaPinPad: TCheckBox;
        cSenhaPdv: TCheckBox;
        EChave: TEdit;
        EIdentificacao: TEdit;
        ECodigoLoja: TEdit;
        ECodigoPDV: TEdit;
        ECaixaIdentificacao: TEdit;
        EIPCaixa: TEdit;
        EIPServico: TEdit;
        EPortaCaixa: TRxSpinEdit;
        EPortaServico: TRxSpinEdit;
        GVenda: TGroupBox;
        GPdv: TGroupBox;
        GConexao: TGroupBox;
        IFoto: TImage;
        IQrCodePinpad: TImage;
        IQrCode: TImage;
        LChave: TLabel;
        LPortaCaixa: TLabel;
        LPortaServico: TLabel;
        LIPCaixa: TLabel;
        LIPServico: TLabel;
        LCodigoLoja: TLabel;
        LCaixaIdentificacao: TLabel;
        LCodigoPDV: TLabel;
        LbRijndael1: TLbRijndael;
        LIdentificacao: TLabel;
        PageControl1: TPageControl;
        TabSheet1: TTabSheet;
        TabSheet2: TTabSheet;
        procedure BAtivaClick(Sender: TObject);
        procedure BConsultarTefClick(Sender: TObject);
        procedure BDataNascimentoPinPadClick(Sender: TObject);
        procedure BDesativarClick(Sender: TObject);
        procedure BInicializaDllClick(Sender: TObject);
        procedure BMostrarMensagemClick(Sender: TObject);
        procedure BQrcodePdvClick(Sender: TObject);
        procedure Button1Click(Sender: TObject);
        procedure Button2Click(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
    private

    public

    end;


    { ThProcessaSolicitacoes }

    ThProcessaSolicitacoes = class(TThread)
    private
        fVP_Transmissao_ID: string;
        fVP_DadosRecebidos: string;
        fIP: string;
        fVP_ID: integer;
        fVP_Retorno: TResponde;
    protected
        procedure Execute; override;
    public
        constructor Create(VP_Transmissao_ID, VP_DadosRecebidos, VP_IP: string; VP_ID: integer; VP_Retorno: TResponde);

    end;


function ServidorRecebimentoCaixa(VP_Erro: integer; VP_Transmissao_ID, VP_DadosRecebidos: pansichar; VP_IP: pansichar;
    VP_ID: integer; VP_Chave: pansichar): integer; cdecl;
function ServidorRecebimentoServico(VP_Erro: integer; VP_Transmissao_ID, VP_DadosRecebidos: pansichar; VP_IP: pansichar;
    VP_ID: integer; VP_Chave: pansichar): integer; cdecl;
function ByteToHex(const Value: array of byte): string;

procedure ImagemToStr(var Dados: string; Imagem: TImage);


var
    Form1: TForm1;
    FMCom: THandle;
    FKey: THandle;
    finalizaconexao: Tfinalizaconexao;
    iniciarconexao: Tiniciarconexao;
    respondeservico, respondecaixa: TResponde;

    F_MensagemCreate: TTMensagemcreate;
    F_MensagemCarregaTags: TTMensagemCarregaTags;
    F_MensagemComando: TTMensagemComando;
    F_MensagemComandoDados: TTMensagemComandoDados;
    F_MensagemFree: TTMensagemFree;
    F_MensagemAddTag: TTMensagemaddtag;
    F_MensagemAddComando: TTMensagemaddcomando;
    F_MensagemTagAsString: TTMensagemTagAsString;
    F_MensagemTagCount: TTMensagemTagCount;
    F_MensagemGetTag: TTMensagemGetTag;
    F_MensagemGetTagIdx: TTMensagemGetTagIdx;
    F_MensagemTagToStr: TTMensagemTagToStr;
    F_MensagemLimpar: TTMensagemLimpar;
    F_Mensagem: Pointer;
    F_Erro: TTMensagemerro;

    F_DescriptaSenha3Des: TDescriptaSenha3Des;
    F_EncriptaSenha3Des: TEncriptaSenha3Des;
    F_Wk: Twkc;
    F_Imk: Timk;
    F_PinFromPindPad: TpinFromPindPad;

    F_OpenTef: TOpenTef;
    F_Transacao: TTransacao;


implementation

function ServidorRecebimentoCaixa(VP_Erro: integer; VP_Transmissao_ID, VP_DadosRecebidos: pansichar; VP_IP: pansichar;
    VP_ID: integer; VP_Chave: pansichar): integer; cdecl;
var
    VL_Mensagem: Pointer;
    VL_Comando: PChar;

begin

    VL_Comando := '';
    VL_Mensagem := nil;

    Result := VP_Erro;

    if VP_Erro = 96 then // cliente desconectado
    begin
        F_OpenTef.remove(VP_ID); // desconctar
        exit;
    end;

    if Result <> 0 then
        exit;

    F_MensagemCreate(VL_Mensagem);
    Result := F_MensagemCarregaTags(VL_Mensagem, VP_DadosRecebidos);
    if Result <> 0 then
        exit;

    F_MensagemComando(VL_Mensagem, VL_Comando);


    if VL_Comando = '0001' then // login
        F_OpenTef.Add(VP_ID, VP_Transmissao_ID, 'C', VP_Chave, VP_IP)
    else
        ThProcessaSolicitacoes.Create(VP_Transmissao_ID, VP_DadosRecebidos, VP_IP, VP_ID, respondecaixa);

end;

function ServidorRecebimentoServico(VP_Erro: integer; VP_Transmissao_ID, VP_DadosRecebidos: pansichar; VP_IP: pansichar;
    VP_ID: integer; VP_Chave: pansichar): integer; cdecl;
var
    VL_Mensagem: Pointer;
    VL_Comando: PChar;

begin

    VL_Comando := '';
    VL_Mensagem := nil;

    Result := VP_Erro;

    if VP_Erro = 96 then // cliente desconectado
    begin
        F_OpenTef.remove(VP_ID); // desconctar
        exit;
    end;

    if Result <> 0 then
        exit;

    F_MensagemCreate(VL_Mensagem);
    Result := F_MensagemCarregaTags(VL_Mensagem, VP_DadosRecebidos);
    if Result <> 0 then
        exit;

    F_MensagemComando(VL_Mensagem, VL_Comando);

    if VL_Comando = '0001' then // login
        F_OpenTef.Add(VP_ID, VP_Transmissao_ID, 'S', VP_Chave, VP_IP)
    else
        ThProcessaSolicitacoes.Create(VP_Transmissao_ID, VP_DadosRecebidos, VP_IP, VP_ID, respondeservico);

end;

function ByteToHex(const Value: array of byte): string;
var
    I: integer;
begin
    Result := '';
    for I := 0 to Length(Value) - 1 do
    begin
        Result := Result + IntToHex(Value[I], 2);
    end;
end;

{$R *.lfm}

{ TOpenTef }

constructor TOpenTef.Create;
begin
    inherited Create;
    V_Lista := TList.Create;
end;

destructor TOpenTef.Destroy;
var
    VL_OpenTef: ^TRecOpeTef;
begin

    while V_Lista.Count > 0 do
    begin
        VL_OpenTef := V_Lista[0];
        Dispose(VL_OpenTef);
        V_Lista.Delete(0);
    end;

    V_Lista.Free;
    inherited Destroy;
end;

function TOpenTef.GetRecOpeTef(VP_Idex: integer): TRecOpeTef;

begin

    if V_Lista.Count < VP_Idex + 1 then
        Exit;

    Result := TRecOpeTef(V_Lista.Items[VP_Idex]^);



    //    if V_Lista.Count = 0 then
    //        Exit;

    //    for VL_I := 0 to V_Lista.Count - 1 do
    //    begin
    //        VL_RecOpenTef := V_Lista.Items[VL_I];
    //        if VL_RecOpenTef^.V_Chave = VP_Chave then
    //        begin
    //            Result := VL_RecOpenTef^.V_ID;
    //            Exit;
    //        end;
    //    end;

end;

function TOpenTef.Count: integer;
begin
    Result := V_Lista.Count;
end;

function TOpenTef.Add(VP_ID: integer; VP_ConexaoID, VP_Tipo, VP_Chave, VP_IP: string): integer;
var
    VL_RecOpenTef: ^TRecOpeTef;
begin
    Result := 0;

    new(VL_RecOpenTef);

    VL_RecOpenTef^.V_ID := VP_ID;
    VL_RecOpenTef^.V_ConexaoID := VP_ConexaoID;
    VL_RecOpenTef^.V_Chave := Trim(VP_Chave);
    VL_RecOpenTef^.V_Tipo := VP_Tipo;
    VL_RecOpenTef^.V_IP := VP_IP;

    V_Lista.Add(VL_RecOpenTef);
end;

function TOpenTef.Remove(VP_ID: integer): integer;
var
    VL_RecOpenTef: ^TRecOpeTef;
    VL_I: integer;
begin
    Result := 0;

    if V_Lista.Count = 0 then
        Exit;

    for VL_I := 0 to V_Lista.Count - 1 do
    begin
        VL_RecOpenTef := V_Lista.Items[VL_I];
        if VL_RecOpenTef^.V_ID = VP_ID then
        begin
            V_Lista.Remove(VL_RecOpenTef);
            Dispose(VL_RecOpenTef);
            Break;
        end;
    end;
end;

{TTransacao}

constructor TTransacao.Create;
begin
    inherited Create;
    V_Lista := TList.Create;
end;

destructor TTransacao.Destroy;
var
    VL_Transacao: ^TRecTransacao;
begin

    while V_Lista.Count > 0 do
    begin
        VL_Transacao := V_Lista[0];
        Dispose(VL_Transacao);
        V_Lista.Delete(0);
    end;

    V_Lista.Free;
    inherited Destroy;
end;

function TTransacao.Add(VP_Transacao_ID: string): TRecTransacao;
var
    VL_RecTransacao: ^TRecTransacao;
    VL_I: integer;
begin
    for VL_I := 0 to V_Lista.Count - 1 do
    begin
        VL_RecTransacao := V_Lista.Items[VL_I];
        if VL_RecTransacao^.V_Transacao_ID = VP_Transacao_ID then
        begin
            Result := VL_RecTransacao^;
            Exit;
        end;
    end;

    new(VL_RecTransacao);

    VL_RecTransacao^.V_Transacao_ID := VP_Transacao_ID;
    VL_RecTransacao^.V_FotoEnviadaPDV := False;
    VL_RecTransacao^.V_QrCodeEnviadoPDV := False;
    VL_RecTransacao^.V_QrCodeEnviadoPinpad := False;

    V_Lista.Add(VL_RecTransacao);
    Result := VL_RecTransacao^;
end;

function TTransacao.Remove(VP_Transacao_ID: string): integer;
var
    VL_RecTransacao: ^TRecTransacao;
    VL_I: integer;
begin
    Result := 0;

    if V_Lista.Count = 0 then
        Exit;

    for VL_I := 0 to V_Lista.Count - 1 do
    begin
        VL_RecTransacao := V_Lista.Items[VL_I];
        if VL_RecTransacao^.V_Transacao_ID = VP_Transacao_ID then
        begin
            V_Lista.Remove(VL_RecTransacao);
            Dispose(VL_RecTransacao);
            Break;
        end;
    end;
end;

function TTransacao.Salvar(VP_Transacao_ID: string; VP_Rec_Transacao: TRecTransacao): integer;
var
    VL_RecTransacao: ^TRecTransacao;
    VL_I: integer;
begin
    Result := 0;

    if V_Lista.Count = 0 then
        Exit;

    for VL_I := 0 to V_Lista.Count - 1 do
    begin
        VL_RecTransacao := V_Lista.Items[VL_I];
        if VL_RecTransacao^.V_Transacao_ID = VP_Transacao_ID then
        begin
            VL_RecTransacao^ := VP_Rec_Transacao;
            V_Lista.Insert(VL_I, VL_RecTransacao);
            Exit;
        end;
    end;
end;

procedure ImagemToStr(var Dados: string; Imagem: TImage);
var
    Sm: TStringStream;
    //        I: integer;
    S: string;
begin
    Dados := '';
    Sm := TStringStream.Create('');
    Imagem.Picture.SaveToStream(Sm);
    S := sm.DataString;

    Dados := EncodeStringBase64(S);
    //        for i := 0 to Length(S) - 1 do
    //          Dados := Dados + HexStr(Ord(S[i + 1]), 2);


    Sm.Free;
end;

{ ThProcessaSolicitacoes }

procedure ThProcessaSolicitacoes.Execute;
var
    VL_Mensagem_Entrada: Pointer;
    VL_Mensagem_Saida: Pointer;
    VL_Mensagem_ChaveTransacao: Pointer;
    VL_Mensagem_DadosProtegidos: Pointer;
    VL_Mensagem_Auxiliar: Pointer;

    VL_RecTransacao: TRecTransacao;

    VL_Erro: integer;
    VL_ChaveTamanho: integer;

    VL_Senha: PChar;
    VL_Valor: PChar;
    VL_Comando, VL_ComandoDados: PChar;
    VL_Cpf: PChar;
    VL_Cartao: PChar;
    VL_TagDados: PChar;
    VL_Pan: PChar;
    VL_PChar: PChar;
    VL_ChaveExpoente: PChar;
    VL_ChaveModulo: PChar;
    VL_ChaveComunicacaoSolicitacao: PChar;
    VL_ChaveComunicacaoResposta: PChar;
    VL_Tag: PChar;
    VL_Autorizacao: PChar;
    VL_DescricaoErro: PChar;
    VL_DadosEnviados: PChar;
    VL_Bin: PChar;
    VL_BotaoSelecionado: PChar;
    VL_BotaoDados: PChar;
    VL_Transacao_ID: PChar;

    VL_ImagemDados: string;
    VL_String: string;
begin
    VL_Mensagem_Entrada := nil;
    VL_Mensagem_Saida := nil;
    VL_Mensagem_ChaveTransacao := nil;
    VL_Mensagem_DadosProtegidos := nil;
    VL_Mensagem_Auxiliar := nil;
    try
        F_MensagemCreate(VL_Mensagem_Entrada);
        F_MensagemCreate(VL_Mensagem_Saida);
        F_MensagemCreate(VL_Mensagem_ChaveTransacao);
        F_MensagemCreate(VL_Mensagem_DadosProtegidos);
        F_MensagemCreate(VL_Mensagem_Auxiliar);

        VL_Senha := '';
        VL_TagDados := '';
        VL_String := '';
        VL_Valor := '';
        VL_Pan := '';
        VL_PChar := '';
        VL_Cpf := '';
        VL_Cartao := '';
        VL_ChaveTamanho := 0;
        VL_ChaveExpoente := '';
        VL_ChaveModulo := '';
        VL_Comando := '';
        VL_ComandoDados := '';
        VL_Tag := '';
        VL_Autorizacao := '';
        VL_DescricaoErro := '';
        VL_ChaveComunicacaoSolicitacao := '';
        VL_ChaveComunicacaoResposta := '';
        VL_DadosEnviados := '';
        VL_Bin := '';
        VL_BotaoSelecionado := '';
        VL_BotaoDados := '';
        VL_ImagemDados := '';
        VL_Transacao_ID := '';

        vl_erro := F_MensagemCarregaTags(VL_Mensagem_Entrada, PChar(fVP_DadosRecebidos));

        if vl_erro <> 0 then
        begin
            Exit;
        end;

        F_MensagemCarregaTags(VL_Mensagem_Saida, PChar(fVP_DadosRecebidos));

        F_MensagemGetTag(VL_Mensagem_Entrada, PChar('0008'), VL_ChaveModulo); // CHAVE PUBLICA MODULO
        F_MensagemGetTag(VL_Mensagem_Entrada, PChar('0027'), VL_ChaveExpoente); // CHAVE PUBLICA EXPOENTE
        F_MensagemGetTag(VL_Mensagem_Entrada, PChar('00E4'), VL_PChar); // CHAVE PUBLICA TAMANHO
        F_MensagemGetTag(VL_Mensagem_Entrada, PChar('010E'), VL_ChaveComunicacaoSolicitacao);  // CHAVE DE COMUNICACAO (AES) CRIPTOGRAFADA SOLICITACAO
        F_MensagemGetTag(VL_Mensagem_Entrada, PChar('010F'), VL_ChaveComunicacaoResposta); // CHAVE DE COMUNICACAO (AES) CRIPTOGRAFADA RESPOSTA
        if VL_PChar <> '' then
            VL_ChaveTamanho := StrToInt(VL_PChar);

        F_MensagemComando(VL_Mensagem_Entrada, VL_Comando);
        F_MensagemComandoDados(VL_Mensagem_Entrada, VL_ComandoDados);


        if VL_Comando = '0026' then        // RETORNO DO COMANDO COM ERRO
        begin
            if VL_ComandoDados <> '' then
            begin
                F_Erro(StrToInt(VL_ComandoDados), VL_DescricaoErro);
                ShowMessage('Erro: ' + VL_ComandoDados + #13 + 'Descrição: ' + VL_DescricaoErro);
            end;

            Exit;
        end;


        if ((VL_Comando = '00CD') and (VL_ComandoDados = 'S')) then                     // atualiza bins
        begin
            F_MensagemLimpar(VL_Mensagem_Saida);
            F_MensagemAddComando(VL_Mensagem_Saida, '00CD', 'R'); // retorno da tabela de bin
            F_MensagemAddTag(VL_Mensagem_Saida, '004D', PChar('0')); // retorno com erro
            F_MensagemAddTag(VL_Mensagem_Saida, '00CE', PChar('629867')); // bin
            F_MensagemTagAsString(VL_Mensagem_Saida, VL_DadosEnviados);     //converte em string a mensagem
            fVP_Retorno(PChar(fVP_Transmissao_ID), VL_DadosEnviados, fVP_ID);
            Exit;
        end;

        if ((VL_Comando = '00CF') and (VL_ComandoDados = 'S')) then                            //MENU DE VENDA
        begin
            F_MensagemLimpar(VL_Mensagem_Saida);
            F_MensagemAddComando(VL_Mensagem_Saida, '00CF', 'R');              // RETORNO DO COMANDO VAZIO
            F_MensagemAddTag(VL_Mensagem_Saida, '004D', PChar('0'));   // retorno com erro
            F_MensagemAddTag(VL_Mensagem_Saida, '007D', PChar(''));  // mensagem vazia
            F_MensagemTagAsString(VL_Mensagem_Saida, VL_DadosEnviados);  //converte em string a mensagem
            fVP_Retorno(PChar(fVP_Transmissao_ID), VL_DadosEnviados, fVP_ID);
            Exit;
        end;

        if ((VL_Comando = '00D4') and (VL_ComandoDados = 'S')) then                          // MENU DE OPERACAO
        begin
            F_MensagemLimpar(VL_Mensagem_Saida);
            F_MensagemAddComando(VL_Mensagem_Saida, '00D4', 'R');      //renorno do comando
            F_MensagemAddTag(VL_Mensagem_Saida, '004D', PChar('0'));  //comando realizado com sucesso

            F_MensagemLimpar(VL_Mensagem_Auxiliar);
            F_MensagemAddComando(VL_Mensagem_Auxiliar, '0018', PChar('R'));   //renorno da lista de menu
            F_MensagemAddTag(VL_Mensagem_Auxiliar, '00D3', PChar('Cancela Venda')); //item do menu
            F_MensagemAddTag(VL_Mensagem_Auxiliar, 'FFD3', PChar('Cancela Plano')); //item do menu
            F_MensagemTagAsString(VL_Mensagem_Auxiliar, VL_PChar);     //converte em string a mensagem

            F_MensagemAddTag(VL_Mensagem_Saida, '007D', VL_PChar);  // coloca a mensagem na tag de mensagem
            F_MensagemTagAsString(VL_Mensagem_Saida, VL_DadosEnviados); //converte em string a mensagem
            fVP_Retorno(PChar(fVP_Transmissao_ID), VL_DadosEnviados, fVP_ID); // envia de volta o comando
            Exit;
        end;

        if ((VL_Comando = '0105') and (VL_ComandoDados = 'R')) then                          // RETORNO DO COMANDO EXECUTADO NO PDV
        begin
            // carregando a chave da transacao
            F_MensagemGetTag(VL_Mensagem_Entrada, PChar('00F1'), VL_TagDados);

            vl_erro := F_MensagemCarregaTags(VL_Mensagem_ChaveTransacao, PChar(VL_TagDados));

            if vl_erro <> 0 then
            begin
                Exit;
            end;

            // carregando os dados protegidos
            F_MensagemGetTag(VL_Mensagem_Entrada, PChar('00E3'), VL_TagDados);

            vl_erro := F_MensagemCarregaTags(VL_Mensagem_DadosProtegidos, PChar(VL_TagDados));

            if vl_erro <> 0 then
            begin
                Exit;
            end;

            F_MensagemGetTag(VL_Mensagem_DadosProtegidos, PChar('0005'), VL_PChar);            // versao do tef

            if VL_PChar <> '' then
            begin
                ShowMessage('Versão do tef: ' + VL_PChar);
            end;

            F_MensagemGetTag(VL_Mensagem_DadosProtegidos, PChar('0060'), VL_PChar);

            if VL_PChar <> '' then
            begin
                ShowMessage('Data do nascimento: ' + F_DescriptaSenha3Des('', '6298676000000510152', VL_PChar));
            end;


            Exit;
        end;

        if ((VL_Comando = '00F6') and (VL_ComandoDados = 'S')) then         // CANCELAMENTO DE VENDA
        begin
            {
            VL_TagDados := '';
            F_MensagemGetTag(VL_Mensagem, '007D', VL_TagDados);
            if VL_TagDados <> '' then
                F_MensagemCarregaTags(VL_Mensagem_Dados, VL_TagDados);

            F_MensagemLimpar(VL_Mensagem);

            F_MensagemAddTag(VL_Mensagem, PChar('00E3'), PChar(''));  // solicita dados protegidos
            F_MensagemAddTag(VL_Mensagem, PChar('0024'), VL_ChaveModulo);
            F_MensagemAddTag(VL_Mensagem, PChar('0023'), VL_ChaveExpoente);
            F_MensagemAddTag(VL_Mensagem, PChar('0028'), VL_PChar);

            F_MensagemGetTag(VL_Mensagem_Dados, PChar('0033'), VL_TagDados);         // dados capturados

            F_MensagemGetTag(VL_Mensagem_Dados, PChar('00D5'), VL_PChar);            // BOTAO SELECIONADO

            F_MensagemGetTag(VL_Mensagem_Dados, PChar('00F1'), VL_ChaveTransacao);   // chave da transacao

            VL_ChaveTransacao := PChar(Trim(string(VL_ChaveTransacao))); // eliminando espacos e formatacoes para nao ocorrer erros

            if (VL_ChaveTransacao = '') or (VL_ChaveTransacao = #1) then // chave da transacao nao enviada
            begin
                //F_MensagemLimpar(VL_Mensagem_Dados);
                F_MensagemAddComando(VL_Mensagem_Dados, PChar('0026'), PChar('89')); // resposta com erro
                F_MensagemAddTag(VL_Mensagem_Dados, '00A4', PChar(IntToStr(Ord(tsAbortada))));  // transacao obortada
                F_MensagemTagAsString(VL_Mensagem_Dados, VL_Tag);   //converte em string a mensagem
                fVP_Retorno(PChar(fVP_Transmissao_ID), VL_Tag, fVP_ID); // envia de volta o comando
            end;

            vl_erro := F_MensagemCarregaTags(VL_ChaveMensagem, VL_ChaveTransacao); // carrega a chave em uma mensagem

            if vl_erro <> 0 then
            begin
                F_MensagemAddComando(VL_Mensagem, '0026', PChar(IntToStr(VL_Erro))); // retorno com erro
                fVP_Retorno(PChar(fVP_Transmissao_ID), VL_Mensagem, fVP_ID); // envia de volta o comando
                F_MensagemAddTag(VL_Mensagem_Dados, '00A4', PChar(IntToStr(Ord(tsAbortada))));  // transacao obortada
                Exit;
            end;

            F_MensagemGetTag(VL_ChaveMensagem, PChar('00F7'), VL_Autorizacao);   // autorizacao da venda

            if (VL_Autorizacao = '') or (VL_Autorizacao = #1) then // autorizacao nao enviada
            begin
                //F_MensagemLimpar(VL_Mensagem_Dados);
                F_MensagemAddComando(VL_Mensagem_Dados, PChar('0026'), PChar('90')); // resposta com erro
                F_MensagemTagAsString(VL_Mensagem_Dados, VL_Tag);   //converte em string a mensagem
                fVP_Retorno(PChar(fVP_Transmissao_ID), VL_Tag, fVP_ID); // envia de volta o comando
                F_MensagemAddTag(VL_Mensagem_Dados, '00A4', PChar(IntToStr(Ord(tsAbortada))));  // transacao obortada
                Exit;
            end;

            // mostra mensagem na tela
            VL_String := 'Cancelamento da venda realizado com sucesso';
            F_MensagemAddComando(VL_Mensagem_Dados, PChar('002C'), PChar('S'));   //MENSAGEM OPERADOR
            F_MensagemAddTag(VL_Mensagem_Dados, '00DA', PChar(VL_String));  // mensagem no pdv
            F_MensagemAddTag(VL_Mensagem_Dados, '00A4', PChar(IntToStr(Ord(tsEfetivada))));  // transacao obortada
            F_MensagemTagAsString(VL_Mensagem_Dados, VL_Tag);    //converte em string a mensagem
            fVP_Retorno(PChar(fVP_Transmissao_ID), VL_Tag, fVP_ID); // envia de volta o comando
            Exit;
            }
        end;

        if ((VL_Comando = '00F3') and (VL_ComandoDados = 'S')) then                          // CONSULTAR SALDO
        begin
            F_MensagemGetTag(VL_Mensagem_Entrada, PChar('00F1'), VL_TagDados);  // carregando a chave da transacao

            vl_erro := F_MensagemCarregaTags(VL_Mensagem_ChaveTransacao, PChar(VL_TagDados));

            if vl_erro <> 0 then
            begin
                F_MensagemAddComando(VL_Mensagem_DadosProtegidos, PChar('002C'), PChar('S'));   //MENSAGEM OPERADOR
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '00DA', PChar('Erro ao carregar a tag'));  // mensagem no pdv
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '00A4', PChar(IntToStr(Ord(tsNegada))));  // transacao obortada
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '004A', PChar('Erro ao carregar a tag'));  // mensagem erro descricao

                F_MensagemTagAsString(VL_Mensagem_DadosProtegidos, VL_Tag);  //converte em string a mensagem

                F_MensagemAddComando(VL_Mensagem_Saida, PChar('002C'), PChar('S'));   //solicita dados da venda
                F_MensagemAddTag(VL_Mensagem_Saida, PChar('00E3'), VL_Tag); // transacao criptografa

                F_MensagemTagAsString(VL_Mensagem_Saida, VL_DadosEnviados);     //converte em string a mensagem

                fVP_Retorno(PChar(fVP_Transmissao_ID), VL_DadosEnviados, fVP_ID); // envia de volta o comando
                Exit;
            end;

            // carregando os dados protegidos
            F_MensagemGetTag(VL_Mensagem_Entrada, PChar('00E3'), VL_TagDados);

            vl_erro := F_MensagemCarregaTags(VL_Mensagem_DadosProtegidos, PChar(VL_TagDados));

            if vl_erro <> 0 then
            begin
                F_MensagemAddComando(VL_Mensagem_DadosProtegidos, PChar('002C'), PChar('S'));   //MENSAGEM OPERADOR
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '00DA', PChar('Erro ao carregar a tag'));  // mensagem no pdv
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '00A4', PChar(IntToStr(Ord(tsNegada))));  // transacao obortada
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '004A', PChar('Erro ao carregar a tag'));  // mensagem erro descricao

                F_MensagemTagAsString(VL_Mensagem_DadosProtegidos, VL_Tag);  //converte em string a mensagem

                F_MensagemAddComando(VL_Mensagem_Saida, PChar('002C'), PChar('S'));   //solicita dados da venda
                F_MensagemAddTag(VL_Mensagem_Saida, PChar('00E3'), VL_Tag); // transacao criptografa

                F_MensagemTagAsString(VL_Mensagem_Saida, VL_DadosEnviados);     //converte em string a mensagem

                fVP_Retorno(PChar(fVP_Transmissao_ID), VL_DadosEnviados, fVP_ID); // envia de volta o comando
                Exit;
            end;

            F_MensagemGetTag(VL_Mensagem_DadosProtegidos, PChar('00D9'), VL_Pan);                 // pan nao enviado de proposito
            F_MensagemGetTag(VL_Mensagem_DadosProtegidos, PChar('0033'), VL_BotaoDados);            // dados capturados
            F_MensagemGetTag(VL_Mensagem_DadosProtegidos, PChar('00D5'), VL_BotaoSelecionado);            // BOTAO SELECIONADO
            F_MensagemGetTag(VL_Mensagem_DadosProtegidos, PChar('0060'), VL_Senha);      // senha criptografada dados capturados
            F_MensagemGetTag(VL_Mensagem_DadosProtegidos, PChar('00E7'), VL_Cartao);    // cartao dados capturados
            F_MensagemGetTag(VL_Mensagem_DadosProtegidos, PChar('0036'), VL_Bin);    // bin

            if VL_Pan = '' then
                F_MensagemGetTag(VL_Mensagem_DadosProtegidos, PChar('011A'), VL_Pan);   // pan digitado pelo pinpad

            VL_Cartao := PChar(Copy(VL_Pan, Length(VL_Bin) + 1, Length(VL_Pan) - Length(VL_Bin) + 1));

            if (VL_BotaoSelecionado = '00E8') and (VL_Senha = '') then
            begin
                VL_Senha := VL_BotaoDados;

                // informando que e necessario incluir a senha
                if VL_Senha = '' then
                begin
                    F_MensagemAddComando(VL_Mensagem_DadosProtegidos, PChar('002C'), PChar('S'));   //MENSAGEM OPERADOR
                    F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '00DA', PChar('Senha não informada'));  // mensagem no pdv
                    F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '00A4', PChar(IntToStr(Ord(tsNegada))));  // transacao obortada
                    F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '004A', PChar('Senha não informada'));  // mensagem erro descricao

                    F_MensagemTagAsString(VL_Mensagem_DadosProtegidos, VL_Tag);  //converte em string a mensagem

                    F_MensagemAddComando(VL_Mensagem_Saida, PChar('002C'), PChar('S'));   //solicita dados da venda
                    F_MensagemAddTag(VL_Mensagem_Saida, PChar('00E3'), VL_Tag); // transacao criptografa

                    F_MensagemTagAsString(VL_Mensagem_Saida, VL_DadosEnviados);     //converte em string a mensagem

                    fVP_Retorno(PChar(fVP_Transmissao_ID), VL_DadosEnviados, fVP_ID); // envia de volta o comando
                    Exit;
                end;

                F_MensagemAddComando(VL_Mensagem_DadosProtegidos, PChar('008C'), PChar('S'));   //solicita atualiza transacao
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, PChar('0060'), PChar(VL_Senha));  // senha cripttografada

                F_MensagemTagAsString(VL_Mensagem_DadosProtegidos, VL_PChar);     //converte em string a mensagem

                F_MensagemAddComando(VL_Mensagem_Saida, PChar('008C'), PChar('S'));   //solicita atualiza transacao
                F_MensagemAddTag(VL_Mensagem_Saida, PChar('00E3'), VL_PChar);  // transacao criptografada
                F_MensagemAddTag(VL_Mensagem_Saida, PChar('00D5'), PChar(''));  // botao selecionado

                F_MensagemTagAsString(VL_Mensagem_Saida, VL_DadosEnviados);     //converte em string a mensagem
                fVP_Retorno(PChar(fVP_Transmissao_ID), VL_DadosEnviados, fVP_ID); // envia de volta o comando
                Exit;

            end;

            if VL_Senha = '' then // exemplo de captura de senha
            begin
                F_MensagemLimpar(VL_Mensagem_Auxiliar);
                F_MensagemAddComando(VL_Mensagem_Auxiliar, '0000', 'S');
                F_MensagemAddTag(VL_Mensagem_Auxiliar, '00E8', PChar('OK'));    //BOTAO OK
                F_MensagemTagAsString(VL_Mensagem_Auxiliar, VL_PChar);     //converte em string a mensagem

                F_MensagemAddComando(VL_Mensagem_DadosProtegidos, PChar('002A'), PChar('S'));   //solicita dados pdv
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '00DA', PChar('DIGITE A SENHA'));    //MENSAGEM A SER MOSTRADA
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '00DD', PChar(VL_PChar));    //BOTOES A MOSTRAR
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '0033', PChar('M'));    //campo para capturar com mascara
                F_MensagemTagAsString(VL_Mensagem_DadosProtegidos, VL_PChar);     //converte em string a mensagem

                F_MensagemAddComando(VL_Mensagem_Saida, PChar('002A'), PChar('S'));   //solicita dados pdv
                F_MensagemAddTag(VL_Mensagem_Saida, PChar('00E3'), VL_PChar);  // transacao criptografada
                F_MensagemTagAsString(VL_Mensagem_Saida, VL_DadosEnviados);     //converte em string a mensagem

                fVP_Retorno(PChar(fVP_Transmissao_ID), VL_DadosEnviados, fVP_ID); // envia de volta o comando

                Exit;
            end;

            VL_String := 'Cartão:' + VL_Cartao + '<br>Saldo: R$100,00';
            F_MensagemAddComando(VL_Mensagem_DadosProtegidos, PChar('002C'), PChar('S'));   //MENSAGEM OPERADOR
            F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '00DA', PChar(VL_String));  // mensagem no pdv
            Exit;

            {
            VL_TagDados := '';
            F_MensagemGetTag(VL_Mensagem, '007D', VL_TagDados);
            if VL_TagDados <> '' then
                F_MensagemCarregaTags(VL_Mensagem_Dados, VL_TagDados);

            F_MensagemLimpar(VL_Mensagem);

            F_MensagemAddTag(VL_Mensagem, PChar('00E3'), PChar(''));  // solicita dados protegidos
            F_MensagemAddTag(VL_Mensagem, PChar('0024'), VL_ChaveModulo);
            F_MensagemAddTag(VL_Mensagem, PChar('0023'), VL_ChaveExpoente);
            F_MensagemAddTag(VL_Mensagem, PChar('0028'), VL_PChar);

            F_MensagemGetTag(VL_Mensagem_Dados, PChar('0033'), VL_TagDados);         // dados capturados

            F_MensagemGetTag(VL_Mensagem_Dados, PChar('00D5'), VL_PChar);            // BOTAO SELECIONADO

            F_MensagemGetTag(VL_Mensagem_Dados, PChar('0060'), VL_Senha);            // senha criptografada dados capturados

            F_MensagemGetTag(VL_Mensagem_Dados, PChar('00E7'), VL_Cartao);            // cartao dados capturados DIGITADO

            F_MensagemGetTag(VL_Mensagem_Dados, PChar('00D9'), VL_Pan);            // pan

            // tirando o bin do cartao
            if (VL_Cartao = '') and (VL_Pan <> '') then
            begin
                VL_Cartao := VL_Pan;


                VL_String := copy(VL_Cartao, 7, 13);

                VL_Cartao := StrAlloc(Length(VL_String) + 1);
                StrPCopy(VL_Cartao, VL_String);
            end;


            if (VL_PChar = '00E8') and (string(VL_Senha) = '') then
            begin
                VL_Senha := VL_TagDados;
            end;

            if VL_Senha = '' then
            begin

                F_MensagemLimpar(VL_Mensagem_Dados);

                // INFORMA OS BOTOES DENTRO DA TAG DE COMANDO DO BOTAO 0018

                F_MensagemAddComando(VL_Mensagem_Dados, '0000', 'S');
                F_MensagemAddTag(VL_Mensagem_Dados, '00E8', PChar('OK'));    //BOTAO OK

                F_MensagemTagAsString(VL_Mensagem_Dados, VL_Tag);     //converte em string a mensagem

                F_MensagemLimpar(VL_Mensagem_Dados);

                F_MensagemAddComando(VL_Mensagem_Dados, PChar('002A'), PChar('S'));   //solicita dados pdv
                F_MensagemAddTag(VL_Mensagem_Dados, '00DA', PChar('DIGITE A SENHA'));    //MENSAGEM A SER MOSTRADA
                F_MensagemAddTag(VL_Mensagem_Dados, '00DD', VL_Tag);    //BOTOES A MOSTRAR
                F_MensagemAddTag(VL_Mensagem_Dados, '0033', PChar('M'));    //campo para capturar com mascara

                F_MensagemTagAsString(VL_Mensagem_Dados, VL_Tag);     //converte em string a mensagem

                F_MensagemAddComando(VL_Mensagem, PChar('002A'), PChar('S'));   //solicita dados pdv
                F_MensagemAddTag(VL_Mensagem, PChar('00E3'), VL_Tag);    // mensagem
                F_MensagemTagAsString(VL_Mensagem, VL_Tag);     //converte em string a mensagem

                fVP_Retorno(PChar(fVP_Transmissao_ID), VL_Tag, fVP_ID); // envia de volta o comando

                Exit;
            end;

            // mostra mensagem na tela
            VL_String := 'Cartão:' + VL_Cartao + '<br>Saldo: R$100,00';
            F_MensagemAddComando(VL_Mensagem_Dados, PChar('002C'), PChar('S'));   //MENSAGEM OPERADOR
            F_MensagemAddTag(VL_Mensagem_Dados, '00DA', PChar(VL_String));  // mensagem no pdv
            F_MensagemAddTag(VL_Mensagem_Dados, '00A4', PChar(IntToStr(Ord(tsEfetivada))));  // transacao obortada
            F_MensagemTagAsString(VL_Mensagem_Dados, VL_Tag);   //converte em string a mensagem
            fVP_Retorno(PChar(fVP_Transmissao_ID), VL_Tag, fVP_ID); // envia de volta o comando
            Exit;
           }
        end;

        if ((VL_Comando = '000A') and (VL_ComandoDados = 'S')) then        // APROVACAO DA TRANSACAO
        begin
            F_MensagemGetTag(VL_Mensagem_Entrada, PChar('00F1'), VL_TagDados);  // carregando a chave da transacao

            vl_erro := F_MensagemCarregaTags(VL_Mensagem_ChaveTransacao, PChar(VL_TagDados));

            if vl_erro <> 0 then
            begin
                F_MensagemAddComando(VL_Mensagem_DadosProtegidos, PChar('002C'), PChar('S'));   //MENSAGEM OPERADOR
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '00DA', PChar('Erro ao carregar a tag'));  // mensagem no pdv
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '00A4', PChar(IntToStr(Ord(tsNegada))));  // transacao obortada
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '004A', PChar('Erro ao carregar a tag'));  // mensagem erro descricao

                F_MensagemTagAsString(VL_Mensagem_DadosProtegidos, VL_Tag);  //converte em string a mensagem

                F_MensagemAddComando(VL_Mensagem_Saida, PChar('002C'), PChar('S'));   //solicita dados da venda
                F_MensagemAddTag(VL_Mensagem_Saida, PChar('00E3'), VL_Tag); // transacao criptografa

                F_MensagemTagAsString(VL_Mensagem_Saida, VL_DadosEnviados);     //converte em string a mensagem

                fVP_Retorno(PChar(fVP_Transmissao_ID), VL_DadosEnviados, fVP_ID); // envia de volta o comando
                Exit;
            end;

            F_MensagemGetTag(VL_Mensagem_ChaveTransacao, PChar('0034'), VL_Transacao_ID); // transacao_id
            VL_RecTransacao := F_Transacao.Add(VL_Transacao_ID);

            // carregando os dados protegidos
            F_MensagemGetTag(VL_Mensagem_Entrada, PChar('00E3'), VL_TagDados);

            vl_erro := F_MensagemCarregaTags(VL_Mensagem_DadosProtegidos, PChar(VL_TagDados));

            if vl_erro <> 0 then
            begin
                F_MensagemAddComando(VL_Mensagem_DadosProtegidos, PChar('002C'), PChar('S'));   //MENSAGEM OPERADOR
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '00DA', PChar('Erro ao carregar a tag'));  // mensagem no pdv
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '00A4', PChar(IntToStr(Ord(tsNegada))));  // transacao obortada
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '004A', PChar('Erro ao carregar a tag'));  // mensagem erro descricao

                F_MensagemTagAsString(VL_Mensagem_DadosProtegidos, VL_Tag);  //converte em string a mensagem

                F_MensagemAddComando(VL_Mensagem_Saida, PChar('002C'), PChar('S'));   //solicita dados da venda
                F_MensagemAddTag(VL_Mensagem_Saida, PChar('00E3'), VL_Tag); // transacao criptografa

                F_MensagemTagAsString(VL_Mensagem_Saida, VL_DadosEnviados);     //converte em string a mensagem

                fVP_Retorno(PChar(fVP_Transmissao_ID), VL_DadosEnviados, fVP_ID); // envia de volta o comando
                Exit;
            end;

            F_MensagemGetTag(VL_Mensagem_DadosProtegidos, PChar('00E9'), VL_Cpf);            // CPF
            F_MensagemGetTag(VL_Mensagem_DadosProtegidos, PChar('00D9'), VL_Pan);                 // pan nao enviado de proposito
            F_MensagemGetTag(VL_Mensagem_DadosProtegidos, PChar('0033'), VL_BotaoDados);            // dados capturados
            F_MensagemGetTag(VL_Mensagem_DadosProtegidos, PChar('00D5'), VL_BotaoSelecionado);            // BOTAO SELECIONADO
            F_MensagemGetTag(VL_Mensagem_DadosProtegidos, PChar('0060'), VL_Senha);      // senha criptografada dados capturados
            F_MensagemGetTag(VL_Mensagem_DadosProtegidos, PChar('0013'), VL_Valor);     // valor dados capturados
            F_MensagemGetTag(VL_Mensagem_DadosProtegidos, PChar('00E7'), VL_Cartao);    // cartao dados capturados
            F_MensagemGetTag(VL_Mensagem_DadosProtegidos, PChar('0036'), VL_Bin);    // bin

            if VL_Pan = '' then
                F_MensagemGetTag(VL_Mensagem_DadosProtegidos, PChar('011A'), VL_Pan);   // pan digitado pelo pinpad

            VL_Cartao := PChar(Copy(VL_Pan, Length(VL_Bin) + 1, Length(VL_Pan) - Length(VL_Bin) + 1));

            if VL_Valor = '' then
            begin
                F_MensagemAddComando(VL_Mensagem_DadosProtegidos, PChar('00E1'), PChar('S'));   //solicita dados da venda

                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '0013', ''); // solicita valor total da venda
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '000C', ''); // solicita data da venda
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '000D', ''); // solicita hora da venda
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '000B', ''); // solicita nsu
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '0040', ''); // solicita observacoes
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '00E6', ''); // solicita desconto
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '000F', ''); // solicita quantidade de parcela
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '0012', ''); // solicita operador de caixa
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '0011', ''); // solicita numero do caixa
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '0017', ''); // solicita xml da venda

                F_MensagemTagAsString(VL_Mensagem_DadosProtegidos, VL_Tag);     //converte em string a mensagem

                F_MensagemAddComando(VL_Mensagem_Saida, PChar('00E1'), PChar('S'));   //solicita dados da venda
                F_MensagemAddTag(VL_Mensagem_Saida, PChar('00E3'), VL_Tag); // transacao criptografa

                F_MensagemTagAsString(VL_Mensagem_Saida, VL_DadosEnviados);     //converte em string a mensagem
                fVP_Retorno(PChar(fVP_Transmissao_ID), VL_DadosEnviados, fVP_ID); // envia de volta o comando
                Exit;
            end;

            // verifica os dados obrigatorio
            if VL_Valor = #1 then // valor veio nulo
            begin
                F_MensagemAddComando(VL_Mensagem_DadosProtegidos, PChar('002C'), PChar('S'));   //MENSAGEM OPERADOR
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '00DA', PChar('CPF não informado'));  // mensagem no pdv
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '00A4', PChar(IntToStr(Ord(tsNegada))));  // transacao obortada
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '004A', PChar('Valor não informado'));  // mensagem erro descricao

                F_MensagemTagAsString(VL_Mensagem_DadosProtegidos, VL_Tag);  //converte em string a mensagem

                F_MensagemAddComando(VL_Mensagem_Saida, PChar('002C'), PChar('S'));   //solicita dados da venda
                F_MensagemAddTag(VL_Mensagem_Saida, PChar('00E3'), VL_Tag); // transacao criptografa

                F_MensagemTagAsString(VL_Mensagem_Saida, VL_DadosEnviados);     //converte em string a mensagem

                fVP_Retorno(PChar(fVP_Transmissao_ID), VL_DadosEnviados, fVP_ID); // envia de volta o comando
                Exit;
            end;

            if Form1.cCpfPdv.Checked then
            begin
                if (VL_BotaoSelecionado = '002F') and (VL_Cpf = '') then  // retorno do cpf
                begin
                    VL_Cpf := VL_BotaoDados;

                    // informando que e necessario incluir o cpf
                    if VL_Cpf = '' then
                    begin
                        F_MensagemAddComando(VL_Mensagem_DadosProtegidos, PChar('002C'), PChar('S'));   //MENSAGEM OPERADOR
                        F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '00DA', PChar('CPF não informado'));  // mensagem no pdv
                        F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '00A4', PChar(IntToStr(Ord(tsNegada))));  // transacao obortada
                        F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '004A', PChar('CPF não informado'));  // mensagem erro descricao

                        F_MensagemTagAsString(VL_Mensagem_DadosProtegidos, VL_Tag);  //converte em string a mensagem

                        F_MensagemAddComando(VL_Mensagem_Saida, PChar('002C'), PChar('S'));   //solicita dados da venda
                        F_MensagemAddTag(VL_Mensagem_Saida, PChar('00E3'), VL_Tag); // transacao criptografa

                        F_MensagemTagAsString(VL_Mensagem_Saida, VL_DadosEnviados);     //converte em string a mensagem

                        fVP_Retorno(PChar(fVP_Transmissao_ID), VL_DadosEnviados, fVP_ID); // envia de volta o comando
                        Exit;
                    end;

                    F_MensagemAddComando(VL_Mensagem_DadosProtegidos, PChar('008C'), PChar('S'));     //solicita atualiza transacao
                    F_MensagemAddTag(VL_Mensagem_DadosProtegidos, PChar('00E9'), PChar(VL_Cpf));       // cpf criptografado

                    F_MensagemTagAsString(VL_Mensagem_DadosProtegidos, VL_PChar);     //converte em string a mensagem

                    F_MensagemAddComando(VL_Mensagem_Saida, PChar('008C'), PChar('S')); //solicita atualiza transacao
                    F_MensagemAddTag(VL_Mensagem_Saida, PChar('00E3'), VL_PChar);  // transacao criptografada
                    F_MensagemAddTag(VL_Mensagem_Saida, PChar('00D5'), PChar(''));      // botao selecionado

                    F_MensagemTagAsString(VL_Mensagem_Saida, VL_DadosEnviados);     //converte em string a mensagem

                    fVP_Retorno(PChar(fVP_Transmissao_ID), VL_DadosEnviados, fVP_ID); // envia de volta o comando
                    Exit;

                end;


                if VL_Cpf = '' then         // exemplo de captura de dados   CPF
                begin
                    F_MensagemLimpar(VL_Mensagem_Auxiliar);
                    F_MensagemAddComando(VL_Mensagem_Auxiliar, '0000', 'S');
                    F_MensagemAddTag(VL_Mensagem_Auxiliar, '002F', PChar('OK'));    //BOTAO OK

                    F_MensagemTagAsString(VL_Mensagem_Auxiliar, VL_PChar);     //converte em string a mensagem

                    F_MensagemAddComando(VL_Mensagem_DadosProtegidos, PChar('002A'), PChar('S'));   //solicita dados pdv
                    F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '00DA', PChar('INFORME O CPF'));    //MENSAGEM A SER MOSTRADA
                    F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '00DD', VL_PChar);    //BOTOES A MOSTRAR
                    F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '0033', PChar('A'));    //campo para capturar sem mascara

                    F_MensagemTagAsString(VL_Mensagem_DadosProtegidos, VL_PChar);     //converte em string a mensagem

                    F_MensagemAddComando(VL_Mensagem_Saida, PChar('002A'), PChar('S'));   //solicita dados pdv
                    F_MensagemAddTag(VL_Mensagem_Saida, PChar('00E3'), VL_PChar);
                    F_MensagemTagAsString(VL_Mensagem_Saida, VL_DadosEnviados);     //converte em string a mensagem


                    fVP_Retorno(PChar(fVP_Transmissao_ID), VL_DadosEnviados, fVP_ID); // envia de volta o comando
                    Exit;
                end;
            end;

            if Form1.cSenhaPdv.Checked then
            begin
                if (VL_BotaoSelecionado = '00E8') and (VL_Senha = '') then
                begin
                    VL_Senha := VL_BotaoDados;

                    // informando que e necessario incluir a senha
                    if VL_Senha = '' then
                    begin
                        F_MensagemAddComando(VL_Mensagem_DadosProtegidos, PChar('002C'), PChar('S'));   //MENSAGEM OPERADOR
                        F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '00DA', PChar('Senha não informada'));  // mensagem no pdv
                        F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '00A4', PChar(IntToStr(Ord(tsNegada))));  // transacao obortada
                        F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '004A', PChar('Senha não informada'));  // mensagem erro descricao

                        F_MensagemTagAsString(VL_Mensagem_DadosProtegidos, VL_Tag);  //converte em string a mensagem

                        F_MensagemAddComando(VL_Mensagem_Saida, PChar('002C'), PChar('S'));   //solicita dados da venda
                        F_MensagemAddTag(VL_Mensagem_Saida, PChar('00E3'), VL_Tag); // transacao criptografa

                        F_MensagemTagAsString(VL_Mensagem_Saida, VL_DadosEnviados);     //converte em string a mensagem

                        fVP_Retorno(PChar(fVP_Transmissao_ID), VL_DadosEnviados, fVP_ID); // envia de volta o comando
                        Exit;
                    end;

                    F_MensagemAddComando(VL_Mensagem_DadosProtegidos, PChar('008C'), PChar('S'));   //solicita atualiza transacao
                    F_MensagemAddTag(VL_Mensagem_DadosProtegidos, PChar('0060'), PChar(VL_Senha));  // senha cripttografada

                    F_MensagemTagAsString(VL_Mensagem_DadosProtegidos, VL_PChar);     //converte em string a mensagem

                    F_MensagemAddComando(VL_Mensagem_Saida, PChar('008C'), PChar('S'));   //solicita atualiza transacao
                    F_MensagemAddTag(VL_Mensagem_Saida, PChar('00E3'), VL_PChar);  // transacao criptografada
                    F_MensagemAddTag(VL_Mensagem_Saida, PChar('00D5'), PChar(''));  // botao selecionado

                    F_MensagemTagAsString(VL_Mensagem_Saida, VL_DadosEnviados);     //converte em string a mensagem
                    fVP_Retorno(PChar(fVP_Transmissao_ID), VL_DadosEnviados, fVP_ID); // envia de volta o comando
                    Exit;

                end;

                if VL_Senha = '' then // exemplo de captura de senha
                begin
                    F_MensagemLimpar(VL_Mensagem_Auxiliar);
                    F_MensagemAddComando(VL_Mensagem_Auxiliar, '0000', 'S');
                    F_MensagemAddTag(VL_Mensagem_Auxiliar, '00E8', PChar('OK'));    //BOTAO OK
                    F_MensagemTagAsString(VL_Mensagem_Auxiliar, VL_PChar);     //converte em string a mensagem

                    F_MensagemAddComando(VL_Mensagem_DadosProtegidos, PChar('002A'), PChar('S'));   //solicita dados pdv
                    F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '00DA', PChar('DIGITE A SENHA'));    //MENSAGEM A SER MOSTRADA
                    F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '00DD', PChar(VL_PChar));    //BOTOES A MOSTRAR
                    F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '0033', PChar('M'));    //campo para capturar com mascara
                    F_MensagemTagAsString(VL_Mensagem_DadosProtegidos, VL_PChar);     //converte em string a mensagem

                    F_MensagemAddComando(VL_Mensagem_Saida, PChar('002A'), PChar('S'));   //solicita dados pdv
                    F_MensagemAddTag(VL_Mensagem_Saida, PChar('00E3'), VL_PChar);  // transacao criptografada
                    F_MensagemTagAsString(VL_Mensagem_Saida, VL_DadosEnviados);     //converte em string a mensagem

                    fVP_Retorno(PChar(fVP_Transmissao_ID), VL_DadosEnviados, fVP_ID); // envia de volta o comando

                    Exit;
                end;
            end;

            if (Form1.cQrcodePdv.Checked) and (not VL_RecTransacao.V_QrCodeEnviadoPDV) then
            begin
                VL_RecTransacao.V_QrCodeEnviadoPDV := True;
                F_Transacao.Salvar(VL_RecTransacao.V_Transacao_ID, VL_RecTransacao);

                F_MensagemLimpar(VL_Mensagem_Auxiliar);
                F_MensagemAddComando(VL_Mensagem_Auxiliar, '0000', 'S');
                F_MensagemAddTag(VL_Mensagem_Auxiliar, '002E', PChar('CONFIRMAR'));    //BOTAO OK
                F_MensagemTagAsString(VL_Mensagem_Auxiliar, VL_PChar);     //converte em string a mensagem

                F_MensagemAddComando(VL_Mensagem_DadosProtegidos, PChar('002A'), PChar('S'));   //solicita dados pdv
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '00DA', PChar('escaneie o qr code'));    //MENSAGEM A SER MOSTRADA
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '00DD', PChar(VL_PChar));    //BOTOES A MOSTRAR
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '0033', PChar(''));    // sem campo para solicitar
                ImagemToStr(VL_ImagemDados, Form1.IQrCode); // converte a imagem em string
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '002E', PChar(VL_ImagemDados));    //campo enviar imagem
                F_MensagemTagAsString(VL_Mensagem_DadosProtegidos, VL_PChar);     //converte em string a mensagem
                F_MensagemTagAsString(VL_Mensagem_DadosProtegidos, VL_PChar);     //converte em string a mensagem

                F_MensagemAddComando(VL_Mensagem_Saida, PChar('002A'), PChar('S'));   //solicita dados pdv
                F_MensagemAddTag(VL_Mensagem_Saida, PChar('00E3'), VL_PChar);  // transacao criptografada

                F_MensagemTagAsString(VL_Mensagem_Saida, VL_DadosEnviados);     //converte em string a mensagem
                fVP_Retorno(PChar(fVP_Transmissao_ID), VL_DadosEnviados, fVP_ID); // envia de volta o comando

                Exit;
            end;

            if (Form1.cFotoPdv.Checked) and (not VL_RecTransacao.V_FotoEnviadaPDV) then
            begin
                VL_RecTransacao.V_FotoEnviadaPDV := True;
                F_Transacao.Salvar(VL_RecTransacao.V_Transacao_ID, VL_RecTransacao);

                F_MensagemLimpar(VL_Mensagem_Auxiliar);
                F_MensagemAddComando(VL_Mensagem_Auxiliar, '0000', 'S');
                F_MensagemAddTag(VL_Mensagem_Auxiliar, '002E', PChar('CONFIRMAR'));    //BOTAO OK
                F_MensagemTagAsString(VL_Mensagem_Auxiliar, VL_PChar);     //converte em string a mensagem

                F_MensagemAddComando(VL_Mensagem_DadosProtegidos, PChar('002A'), PChar('S'));   //solicita dados pdv
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '00DA', PChar('foto do cliente'));    //MENSAGEM A SER MOSTRADA
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '00DD', PChar(VL_PChar));    //BOTOES A MOSTRAR
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '0033', PChar(''));    // sem campo para solicitar
                ImagemToStr(VL_ImagemDados, Form1.IFoto); // converte a imagem em string
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '002E', PChar(VL_ImagemDados));    //campo enviar imagem
                F_MensagemTagAsString(VL_Mensagem_DadosProtegidos, VL_PChar);     //converte em string a mensagem
                F_MensagemTagAsString(VL_Mensagem_DadosProtegidos, VL_PChar);     //converte em string a mensagem

                F_MensagemAddComando(VL_Mensagem_Saida, PChar('002A'), PChar('S'));   //solicita dados pdv
                F_MensagemAddTag(VL_Mensagem_Saida, PChar('00E3'), VL_PChar);  // transacao criptografada

                F_MensagemTagAsString(VL_Mensagem_Saida, VL_DadosEnviados);     //converte em string a mensagem

                fVP_Retorno(PChar(fVP_Transmissao_ID), VL_DadosEnviados, fVP_ID); // envia de volta o comando

                Exit;
            end;

            if (Form1.cQrcodePinPad.Checked) and (not VL_RecTransacao.V_QrCodeEnviadoPinpad) then    // mostra o qr code no pinpad
            begin
                VL_RecTransacao.V_QrCodeEnviadoPinpad := True;
                F_Transacao.Salvar(VL_RecTransacao.V_Transacao_ID, VL_RecTransacao);

                F_MensagemAddComando(VL_Mensagem_DadosProtegidos, PChar('00FC'), PChar('S'));   //solicita MOSTRAR O QR CODE
                ImagemToStr(VL_String, Form1.IQrCodePinpad);
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, PChar('00FE'), PChar(VL_String));  // IMAGEM
                F_MensagemTagAsString(VL_Mensagem_DadosProtegidos, VL_PChar);     //converte em strin

                F_MensagemAddComando(VL_Mensagem_Saida, PChar('00FC'), PChar('S'));   //solicita MOSTRAR O QR CODE
                F_MensagemAddTag(VL_Mensagem_Saida, PChar('00E3'), VL_PChar);  // transacao criptografada

                F_MensagemTagAsString(VL_Mensagem_Saida, VL_DadosEnviados);     //converte em string a mensagem
                fVP_Retorno(PChar(fVP_Transmissao_ID), VL_DadosEnviados, fVP_ID); // envia de volta o comando
                Exit;
            end;

            if Form1.cSenhaPinPad.Checked then
            begin
                if VL_Senha = '' then
                begin
                    // solicita senha pin pad
                    F_MensagemAddComando(VL_Mensagem_DadosProtegidos, PChar('005A'), PChar('S'));   //solicita senha

                    F_MensagemAddTag(VL_Mensagem_DadosProtegidos, PChar('005B'), PChar(IntToStr(F_Imk())));
                    F_MensagemAddTag(VL_Mensagem_DadosProtegidos, PChar('005C'), PChar(' DIGITE A SENHA'));
                    F_MensagemAddTag(VL_Mensagem_DadosProtegidos, PChar('005D'), PChar('4'));
                    F_MensagemAddTag(VL_Mensagem_DadosProtegidos, PChar('005E'), PChar('8'));
                    F_MensagemAddTag(VL_Mensagem_DadosProtegidos, PChar('005F'), PChar(F_Wk()));
                    F_MensagemAddTag(VL_Mensagem_DadosProtegidos, PChar('00D9'), VL_Pan);

                    F_MensagemTagAsString(VL_Mensagem_DadosProtegidos, VL_PChar);     //converte em string a mensagem

                    F_MensagemAddComando(VL_Mensagem_Saida, PChar('005A'), PChar('S')); //solicita atualiza transacao
                    F_MensagemAddTag(VL_Mensagem_Saida, PChar('00E3'), VL_PChar);  // transacao criptografada

                    F_MensagemTagAsString(VL_Mensagem_Saida, VL_DadosEnviados);     //converte em string a mensagem

                    fVP_Retorno(PChar(fVP_Transmissao_ID), VL_DadosEnviados, fVP_ID); // envia de volta o comando
                    Exit;
                end
                else
                begin
                    // descriptografar senha vinda do pinpad
                    VL_Senha := F_DescriptaSenha3Des('', VL_Pan, VL_Senha);
                end;
            end;

            // verifica se veio com autorizacao
            F_MensagemGetTag(VL_Mensagem_ChaveTransacao, '00F7', VL_Autorizacao);
            if VL_Autorizacao = '' then // nao tem autorizacao entao fara a venda
            begin
                F_MensagemAddComando(VL_Mensagem_DadosProtegidos, PChar('008C'), PChar('S'));     //solicita atualiza transacao
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, PChar('00F7'), '214');   // autorizacao de teste
                F_MensagemTagAsString(VL_Mensagem_DadosProtegidos, VL_Tag);     //converte em string a mensagem

                F_MensagemAddComando(VL_Mensagem_Saida, PChar('008C'), PChar('S')); //solicita atualiza transacao
                F_MensagemAddTag(VL_Mensagem_Saida, PChar('00E3'), VL_Tag);  // transacao criptografada
                F_MensagemTagAsString(VL_Mensagem_Saida, VL_DadosEnviados);     //converte em string a mensagem

                fVP_Retorno(PChar(fVP_Transmissao_ID), VL_DadosEnviados, fVP_ID); // envia de volta o comando
                Exit;
            end;

            // texto a ser impresso
            VL_String := 'Cartão: ' + VL_Cartao + '<br>Valor:R$' + VL_Valor;
            VL_String := VL_String + '<br>CPF:' + VL_Cpf;
            VL_String := VL_String + '<br>SENHA:' + VL_Senha;
            VL_String := VL_String + '<br>Valor dos itens:' + VL_Valor;
            VL_String := VL_String + '<br>_____________________________<br>ASSINATURA';

            if Form1.cMensagemPdv.Checked then
            begin
                F_MensagemAddComando(VL_Mensagem_DadosProtegidos, PChar('002C'), PChar('S'));   //MENSAGEM OPERADOR
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '00DA', PChar(VL_String));  // mensagem no pdv
            end;

            if Form1.cImprimir.Checked then
            begin
                F_MensagemAddTag(VL_Mensagem_DadosProtegidos, PChar('002D'), PChar(VL_String));  // imprimir
            end;

            F_MensagemAddTag(VL_Mensagem_DadosProtegidos, '00A4', PChar(IntToStr(Ord(tsEfetivada))));  // transacao efetivada
            F_Transacao.Remove(VL_Transacao_ID);

            F_MensagemTagAsString(VL_Mensagem_DadosProtegidos, VL_Tag);   //converte em string a mensagem

            F_MensagemAddComando(VL_Mensagem_Saida, PChar('002C'), PChar('S')); //solicita atualiza transacao
            F_MensagemAddTag(VL_Mensagem_Saida, PChar('00E3'), VL_Tag);  // transacao criptografada
            F_MensagemTagAsString(VL_Mensagem_Saida, VL_DadosEnviados);     //converte em string a mensagem

            fVP_Retorno(PChar(fVP_Transmissao_ID), VL_DadosEnviados, fVP_ID); // envia de volta o comando
            Exit;

            {

            if Form1.cbxSenha.Checked then
            begin
                if (VL_PChar = '00E8') and (string(VL_Senha) = '') then
                begin
                    VL_Senha := VL_TagDados;
                    if string(VL_Senha) <> '' then
                    begin

                        F_MensagemLimpar(VL_Mensagem_Dados);
                        F_MensagemAddComando(VL_Mensagem_Dados, PChar('008C'), PChar('S'));   //solicita atualiza transacao
                        F_MensagemAddTag(VL_Mensagem_Dados, PChar('0060'), PChar(VL_Senha));  // senha cripttografada

                        F_MensagemTagAsString(VL_Mensagem_Dados, VL_PChar);     //converte em string a mensagem

                        F_MensagemAddComando(VL_Mensagem, PChar('008C'), PChar('S'));   //solicita atualiza transacao
                        F_MensagemAddTag(VL_Mensagem, PChar('00E3'), VL_PChar);  // transacao criptografada
                        F_MensagemAddTag(VL_Mensagem, PChar('00D5'), PChar(''));  // botao selecionado

                        F_MensagemTagAsString(VL_Mensagem, VL_PChar);     //converte em string a mensagem
                        fVP_Retorno(PChar(fVP_Transmissao_ID), VL_PChar, fVP_ID); // envia de volta o comando
                        Exit;

                    end;

                end;

                if VL_Senha = '' then // exemplo de captura de senha
                begin
                    {
                    F_MensagemLimpar(VL_Mensagem_Dados);

                    // INFORMA OS BOTOES DENTRO DA TAG DE COMANDO DO BOTAO 0018

                    F_MensagemAddComando(VL_Mensagem_Dados, '0000', 'S');
                    F_MensagemAddTag(VL_Mensagem_Dados, '00E8', PChar('OK'));    //BOTAO OK

                    F_MensagemTagAsString(VL_Mensagem_Dados, VL_PChar);     //converte em string a mensagem

                    F_MensagemLimpar(VL_Mensagem_Dados);

                    F_MensagemAddComando(VL_Mensagem_Dados, PChar('002A'), PChar('S'));   //solicita dados pdv
                    F_MensagemAddTag(VL_Mensagem_Dados, '00DA', PChar('DIGITE A SENHA'));    //MENSAGEM A SER MOSTRADA
                    F_MensagemAddTag(VL_Mensagem_Dados, '00DD', PChar(VL_PChar));    //BOTOES A MOSTRAR
                    F_MensagemAddTag(VL_Mensagem_Dados, '0033', PChar('M'));    //campo para capturar sem mascara

                    if Form1.cbxQrcode.Checked then
                    begin
                        ImagemToStr(VL_String, Form1.Image2); // converte a imagem em string
                        F_MensagemAddTag(VL_Mensagem_Dados, '002E', PChar(VL_String));    //campo enviar imagem
                    end;

                    F_MensagemTagAsString(VL_Mensagem_Dados, VL_PChar);     //converte em string a mensagem

                    F_MensagemAddComando(VL_Mensagem, PChar('002A'), PChar('S'));   //solicita dados pdv
                    F_MensagemAddTag(VL_Mensagem, PChar('00E3'), VL_PChar);  // transacao criptografada

                    F_MensagemTagAsString(VL_Mensagem, VL_PChar);     //converte em string a mensagem

                    fVP_Retorno(PChar(fVP_Transmissao_ID), VL_PChar, fVP_ID); // envia de volta o comando

                    Exit;
                    }


                    // solicita senha pin pad
                    F_MensagemLimpar(VL_Mensagem_Dados);
                    F_MensagemAddComando(VL_Mensagem_Dados, PChar('005A'), PChar('S'));   //solicita senha

                    F_MensagemAddTag(VL_Mensagem_Dados, PChar('005B'), PChar(IntToStr(F_Imk())));
                    F_MensagemAddTag(VL_Mensagem_Dados, PChar('005C'), PChar(' DIGITE A SENHA'));
                    F_MensagemAddTag(VL_Mensagem_Dados, PChar('005D'), PChar('4'));
                    F_MensagemAddTag(VL_Mensagem_Dados, PChar('005E'), PChar('8'));
                    F_MensagemAddTag(VL_Mensagem_Dados, PChar('005F'), PChar(F_Wk()));
                    F_MensagemAddTag(VL_Mensagem_Dados, PChar('00D9'), VL_Pan);

                    F_MensagemTagAsString(VL_Mensagem_Dados, VL_PChar);     //converte em string a mensagem

                    F_MensagemAddComando(VL_Mensagem, PChar('005A'), PChar('S')); //solicita atualiza transacao
                    F_MensagemAddTag(VL_Mensagem, PChar('00E3'), VL_PChar);  // transacao criptografada


                    VL_String := '';

                    F_MensagemTagAsString(VL_Mensagem, VL_PChar);     //converte em string a mensagem

                    VL_String := VL_PChar;

                    fVP_Retorno(PChar(fVP_Transmissao_ID), VL_PChar, fVP_ID); // envia de volta o comando
                    Exit;
                end;

            end;

            if ((Form1.cbxQrcodePinPad.Checked) and (VL_QrCodeEnviado <> 'T')) then    // mostra o qr code no pinpad
            begin

                F_MensagemLimpar(VL_Mensagem_Dados);
                F_MensagemAddComando(VL_Mensagem_Dados, PChar('00FC'), PChar('S'));   //solicita MOSTRAR O QR CODE

                ImagemToStr(VL_String, Form1.Image1);

                //                VL_String:=GerarQRCodeAsString('teste');

                F_MensagemAddTag(VL_Mensagem_Dados, PChar('00FE'), PChar(VL_String));  // IMAGEM

                F_MensagemTagAsString(VL_Mensagem_Dados, VL_PChar);     //converte em string a mensagem

                F_MensagemAddTag(VL_Mensagem, PChar('00E3'), VL_PChar);  // transacao criptografada

                F_MensagemTagAsString(VL_Mensagem, VL_PChar);     //converte em string a mensagem
                fVP_Retorno(PChar(fVP_Transmissao_ID), VL_PChar, fVP_ID); // envia de volta o comando
                Exit;

            end;

            vl_erro := F_MensagemCarregaTags(VL_ChaveMensagem, VL_ChaveTransacao);  // carrega os dados da chave da transacao

            if vl_erro <> 0 then
            begin
                F_MensagemLimpar(VL_Mensagem_Dados);

                F_MensagemAddComando(VL_Mensagem_Dados, PChar('0000'), PChar('S'));
                F_MensagemAddComando(VL_Mensagem_Dados, PChar('000A'), PChar('R')); // retorno
                F_MensagemAddTag(VL_Mensagem_Dados, PChar('004D'), PChar(IntToStr(VL_Erro))); // resposta com erro
                F_MensagemAddTag(VL_Mensagem_Dados, '00A4', PChar(IntToStr(Ord(tsAbortada))));  // transacao obortada

                F_MensagemTagAsString(VL_Mensagem, VL_Tag);     //converte em string a mensagem

                F_MensagemAddComando(VL_Mensagem, PChar('000A'), PChar('R'));   //solicita dados da venda
                F_MensagemAddTag(VL_Mensagem, PChar('00E3'), VL_Tag); // transacao criptografa

                F_MensagemTagAsString(VL_Mensagem_Dados, VL_Tag);   //converte em string a mensagem

                fVP_Retorno(PChar(fVP_Transmissao_ID), VL_Tag, fVP_ID); // envia de volta o comando
                Exit;
            end;

            // verifica se veio com autorizacao
            F_MensagemGetTag(VL_ChaveMensagem, '00F7', VL_Autorizacao);
            if VL_Autorizacao = '' then // nao tem autorizacao entao fara a venda
            begin
                F_MensagemLimpar(VL_Mensagem_Dados);

                //F_MensagemAddComando(VL_Mensagem_Dados, '0000', 'S');
                F_MensagemAddComando(VL_Mensagem_Dados, PChar('008C'), PChar('S'));     //solicita atualiza transacao
                F_MensagemAddTag(VL_Mensagem_Dados, PChar('00F7'), '214');   // autorizacao de teste

                F_MensagemTagAsString(VL_Mensagem_Dados, VL_Tag);     //converte em string a mensagem

                //F_MensagemLimpar(VL_Mensagem_Dados);

                F_MensagemAddComando(VL_Mensagem, PChar('008C'), PChar('S')); //solicita atualiza transacao
                F_MensagemAddTag(VL_Mensagem, PChar('00E3'), VL_Tag);  // transacao criptografada
                F_MensagemTagAsString(VL_Mensagem, VL_Tag);     //converte em string a mensagem

                fVP_Retorno(PChar(fVP_Transmissao_ID), VL_Tag, fVP_ID); // envia de volta o comando
                Exit;
            end
            else
            begin
                // F_MensagemLimpar(VL_Mensagem_Dados);

                // texto a ser impresso
                VL_String := 'Cartão: ' + VL_Cartao + '<br>Valor:R$' + VL_Valor;
                if Form1.cbxCPF.Checked then
                    VL_String := VL_String + '<br>CPF:' + VL_Cpf;

                VL_String := VL_String + '<br>_____________________________<br>ASSINATURA';

                F_MensagemAddTag(VL_Mensagem_Dados, PChar('002D'), PChar(VL_String));  // imprimir

                //VL_String := 'Cartão:' + VL_Cartao +'<br> Senha:'+F_DescriptaSenha3Des('',VL_Pan, VL_Senha)+ '<br>Valor dos itens:' + VL_Valor;
                VL_String := 'Cartão:' + VL_Cartao + '<br> Senha:' + VL_Senha + '<br>Valor dos itens:' + VL_Valor;
                if Form1.cbxCPF.Checked then
                    VL_String := VL_String + '<br>CPF:' + VL_Cpf;

                F_MensagemAddComando(VL_Mensagem_Dados, PChar('002C'), PChar('S'));   //MENSAGEM OPERADOR
                F_MensagemAddTag(VL_Mensagem_Dados, '00DA', PChar(VL_String));  // mensagem no pdv
                F_MensagemAddTag(VL_Mensagem_Dados, '00A4', PChar(IntToStr(Ord(tsEfetivada))));  // transacao efetivada

                F_MensagemTagAsString(VL_Mensagem_Dados, VL_PChar);   //converte em string a mensagem

                F_MensagemAddComando(VL_Mensagem, PChar('002C'), PChar('S')); //solicita atualiza transacao
                F_MensagemAddTag(VL_Mensagem, PChar('00E3'), VL_Tag);  // transacao criptografada
                F_MensagemTagAsString(VL_Mensagem, VL_Tag);     //converte em string a mensagem

                fVP_Retorno(PChar(fVP_Transmissao_ID), VL_PChar, fVP_ID); // envia de volta o comando

            end;
            Exit;
            }
        end;

        if ((VL_Comando = '0113') and (VL_ComandoDados = 'S')) then        // SOLICITA CONCILIACAO
        begin
            {
            VL_TagDados := '';
            F_MensagemGetTag(VL_Mensagem, '007D', VL_TagDados);
            if VL_TagDados <> '' then
                F_MensagemCarregaTags(VL_Mensagem_Dados, VL_TagDados);

            F_MensagemLimpar(VL_Mensagem);
            F_MensagemAddTag(VL_Mensagem, PChar('00E3'), PChar(''));  // solicita dados protegidos
            F_MensagemAddTag(VL_Mensagem, PChar('0024'), VL_ChaveModulo);
            F_MensagemAddTag(VL_Mensagem, PChar('0023'), VL_ChaveExpoente);
            F_MensagemAddTag(VL_Mensagem, PChar('0028'), VL_PChar);
            F_MensagemAddTag(VL_Mensagem, PChar('010E'), VL_ChaveComunicacaoSolicitacao);
            F_MensagemAddTag(VL_Mensagem, PChar('010F'), VL_ChaveComunicacaoResposta);

            F_MensagemGetTag(VL_Mensagem_Dados, PChar('0114'), VL_TagDados);            // dados capturados

            if (VL_TagDados = '') then
            begin

                F_MensagemLimpar(VL_Mensagem_Dados);
                F_MensagemAddComando(VL_Mensagem_Dados, PChar('00E1'), PChar('S'));   //solicita dados da venda

                if VL_Valor = '' then
                    F_MensagemAddTag(VL_Mensagem_Dados, PChar('0114'), PChar(''));  // solicita valor total da venda

                F_MensagemTagAsString(VL_Mensagem_Dados, VL_Tag);     //converte em string a mensagem

                F_MensagemAddComando(VL_Mensagem, PChar('00E1'), PChar('S'));   //solicita dados da venda
                F_MensagemAddTag(VL_Mensagem, PChar('00E3'), VL_Tag); // transacao criptografa

                F_MensagemTagAsString(VL_Mensagem, VL_Tag);     //converte em string a mensagem
                fVP_Retorno(PChar(fVP_Transmissao_ID), VL_Tag, fVP_ID); // envia de volta o comando
                Exit;
            end;

            // verifica os dados obrigatorio

            if VL_TagDados = #1 then // valor veio nulo
            begin
                F_MensagemLimpar(VL_Mensagem_Dados);

                F_MensagemAddComando(VL_Mensagem_Dados, '0000', 'S');
                VL_String := 'Versao da conciliacao nao informada';
                F_MensagemAddComando(VL_Mensagem_Dados, PChar('002C'), PChar('S'));   //MENSAGEM OPERADOR
                F_MensagemAddTag(VL_Mensagem_Dados, '00DA', PChar(VL_String));  // mensagem no pdv
                F_MensagemAddTag(VL_Mensagem_Dados, '00A4', PChar(IntToStr(Ord(tsNegada))));  // transacao obortada
                F_MensagemAddTag(VL_Mensagem_Dados, '004A', PChar(VL_String));  // mensagem erro descricao

                F_MensagemTagAsString(VL_Mensagem_Dados, VL_Tag);  //converte em string a mensagem

                F_MensagemAddComando(VL_Mensagem, PChar('00E1'), PChar('S'));   //solicita dados da venda
                F_MensagemAddTag(VL_Mensagem, PChar('00E3'), VL_Tag); // transacao criptografa

                F_MensagemTagAsString(VL_Mensagem, VL_Tag);     //converte em string a mensagem

                fVP_Retorno(PChar(fVP_Transmissao_ID), VL_Tag, fVP_ID); // envia de volta o comando
                Exit;
            end;
            }
        end;

    finally
        F_MensagemFree(VL_Mensagem_Entrada);
        F_MensagemFree(VL_Mensagem_Saida);
        F_MensagemFree(VL_Mensagem_ChaveTransacao);
        F_MensagemFree(VL_Mensagem_DadosProtegidos);
        F_MensagemFree(VL_Mensagem_Auxiliar);
    end;
end;

constructor ThProcessaSolicitacoes.Create(VP_Transmissao_ID, VP_DadosRecebidos, VP_IP: string; VP_ID: integer; VP_Retorno: TResponde);
begin
    FreeOnTerminate := True;
    fVP_Transmissao_ID := VP_Transmissao_ID;
    fVP_DadosRecebidos := VP_DadosRecebidos;
    fIP := VP_IP;
    fVP_ID := VP_ID;
    fVP_Retorno := VP_Retorno;
    inherited Create(False);
end;

{ TForm1 }

procedure TForm1.BInicializaDllClick(Sender: TObject);
begin
    {$IF DEFINED(WIN64)}
           FMCom := LoadLibrary(PChar(ExtractFilePath(ParamStr(0)) + '..\..\mcom_lib\win64\mcom_lib.dll'));
    {$ENDIF}

    {$IF DEFINED(WIN32)}
           FMCom := LoadLibrary(PChar(ExtractFilePath(ParamStr(0)) + '..\..\mcom_lib\win32\mcom_lib.dll'));
    {$ENDIF}

    {$IF DEFINED(LINUX64)}
           FMCom := LoadLibrary(PChar(ExtractFilePath(ParamStr(0)) + '../../mcom_lib/linux64/libmcom_lib.so'));
    {$ENDIF}

    {$IF DEFINED(LINUX32)}
           FMCom := LoadLibrary(PChar(ExtractFilePath(ParamStr(0)) + '../../mcom_lib/linux32/libmcom_lib.so'));
    {$ENDIF}

    Pointer(finalizaconexao) := GetProcAddress(FMCom, 'finalizaconexao');
    Pointer(iniciarconexao) := GetProcAddress(FMCom, 'iniciarconexao');
    Pointer(respondecaixa) := GetProcAddress(FMCom, 'respondecaixa');
    Pointer(respondeservico) := GetProcAddress(FMCom, 'respondeservico');

    Pointer(F_MensagemCreate) := GetProcAddress(FMCom, 'mensagemcreate');
    Pointer(F_MensagemCarregaTags) := GetProcAddress(FMCom, 'mensagemcarregatags');
    Pointer(F_MensagemComando) := GetProcAddress(FMCom, 'mensagemcomando');
    Pointer(F_MensagemComandoDados) := GetProcAddress(FMCom, 'mensagemcomandodados');
    Pointer(F_MensagemFree) := GetProcAddress(FMCom, 'mensagemfree');
    Pointer(F_Mensagemaddtag) := GetProcAddress(FMCom, 'mensagemaddtag');
    Pointer(F_Mensagemaddcomando) := GetProcAddress(FMCom, 'mensagemaddcomando');
    Pointer(F_MensagemTagAsString) := GetProcAddress(FMCom, 'mensagemtagasstring');
    Pointer(F_MensagemTagCount) := GetProcAddress(FMCom, 'mensagemtagcount');
    Pointer(F_MensagemGetTag) := GetProcAddress(FMCom, 'mensagemgettag');
    Pointer(F_MensagemGetTagIdx) := GetProcAddress(FMCom, 'mensagemgettagidx');
    Pointer(F_MensagemTagToStr) := GetProcAddress(FMCom, 'mensagemtagtostr');
    Pointer(F_MensagemLimpar) := GetProcAddress(FMCom, 'mensagemlimpar');
    Pointer(F_Erro) := GetProcAddress(FMCom, 'mensagemerro');


    FKey := LoadLibrary(PChar(ExtractFilePath(ParamStr(0)) + 'key_lib.dll'));

    Pointer(F_DescriptaSenha3Des) := GetProcAddress(FKey, 'DescriptaSenha3Des');
    Pointer(F_EncriptaSenha3Des) := GetProcAddress(FKey, 'EncriptaSenha3Des');
    Pointer(F_Wk) := GetProcAddress(FKey, 'wkc');
    Pointer(F_Imk) := GetProcAddress(FKey, 'imk');
    Pointer(F_PinFromPindPad) := GetProcAddress(FKey, 'pinFromPindPad');

end;

procedure TForm1.BMostrarMensagemClick(Sender: TObject);
var
    VL_Erro: integer;
    VL_Mensagem: Pointer;
    VL_Chave00F1: Pointer;
    VL_Transacao: Pointer;
    VL_Dados: PChar;
    VL_DescricaoErro: PChar;
    VL_Id: integer;
    VL_RecOpenTef: TRecOpeTef;
    VL_I: integer;
begin
    VL_Mensagem := nil;
    VL_Chave00F1 := nil;
    VL_Transacao := nil;
    F_MensagemCreate(VL_Mensagem);
    F_MensagemCreate(VL_Chave00F1);
    F_MensagemCreate(VL_Transacao);

    try
        if not Assigned(respondeservico) then
        begin
            ShowMessage('Inicialize a lib');
            Exit;
        end;

        VL_Dados := '';
        VL_DescricaoErro := '';

        F_MensagemAddComando(VL_Chave00F1, '0000', '');
        F_MensagemAddTag(VL_Chave00F1, '00F2', '0068'); // tag do modulo
        F_MensagemAddTag(VL_Chave00F1, '0036', '629867'); // bin
        F_MensagemAddTag(VL_Chave00F1, '0110', 'S'); // conexao tipo s sistema c tipo caixa
        F_MensagemAddTag(VL_Chave00F1, '0109', PChar(EIdentificacao.Text)); // codigo da adquirencia- identificacao
        F_MensagemAddTag(VL_Chave00F1, '00A2', PChar('PDV')); // tipo do terminal
        F_MensagemAddTag(VL_Chave00F1, '00F9', PChar(ECodigoLoja.Text)); // codigo da loja
        F_MensagemAddTag(VL_Chave00F1, '0107', PChar(ECodigoPDV.Text)); // codigo do pdv
        F_MensagemAddTag(VL_Chave00F1, '0108', PChar(ECaixaIdentificacao.Text));  // identificacao do pdv

        F_MensagemTagAsString(VL_Chave00F1, VL_Dados);  //converte em string a mensagem

        F_MensagemAddComando(VL_Mensagem, '0105', 'S'); // solicita comando para ser executado no pdv
        F_MensagemAddTag(VL_Mensagem, '00F1', VL_Dados); // chave da transacao

        F_MensagemAddComando(VL_Transacao, '002C', 'S'); //MENSAGEM OPERADOR
        F_MensagemAddTag(VL_Transacao, '00DA', 'Mensagem enviada pela operadora'); // mensagem no pdv

        F_MensagemTagAsString(VL_Transacao, VL_Dados);  //converte em string a mensagem

        F_MensagemAddTag(VL_Mensagem, PChar('00E3'), VL_Dados);  // transacao criptografa

        F_MensagemTagAsString(VL_Mensagem, VL_Dados);  //converte em string a mensagem

        VL_Id := -1;

        for VL_I := 0 to F_OpenTef.Count - 1 do
        begin
            VL_RecOpenTef := F_OpenTef.GetRecOpeTef(VL_I);
            if VL_RecOpenTef.V_Tipo = 'S' then // servico
                VL_Id := VL_RecOpenTef.V_ID;
        end;

        if VL_Id = -1 then
        begin
            ShowMessage('Conexão não encontrada');
            Exit;
        end;

        VL_Erro := respondeservico('', VL_Dados, VL_Id);
        if VL_Erro <> 0 then
        begin
            F_Erro(VL_Erro, VL_DescricaoErro);
            ShowMessage('Erro: ' + IntToStr(VL_Erro) + #13 + 'Descrição: ' + VL_DescricaoErro);
        end;
    finally
        F_MensagemFree(VL_Mensagem);
        F_MensagemFree(VL_Chave00F1);
        F_MensagemFree(VL_Transacao);
    end;

end;

procedure TForm1.BQrcodePdvClick(Sender: TObject);
var
    VL_Erro: integer;
    VL_Mensagem: Pointer;
    VL_Chave00F1: Pointer;
    VL_Transacao: Pointer;
    VL_Dados: PChar;
    VL_DescricaoErro: PChar;
    VL_Id: integer;
    VL_RecOpenTef: TRecOpeTef;
    VL_I: integer;
    VL_String: string;
begin
    VL_Mensagem := nil;
    VL_Chave00F1 := nil;
    VL_Transacao := nil;
    F_MensagemCreate(VL_Mensagem);
    F_MensagemCreate(VL_Chave00F1);
    F_MensagemCreate(VL_Transacao);

    try
        if not Assigned(respondeservico) then
        begin
            ShowMessage('Inicialize a lib');
            Exit;
        end;

        VL_Dados := '';
        VL_DescricaoErro := '';
        VL_String := '';

        F_MensagemAddComando(VL_Chave00F1, '0000', '');
        F_MensagemAddTag(VL_Chave00F1, '00F2', '0068'); // tag do modulo
        F_MensagemAddTag(VL_Chave00F1, '0036', '629867'); // bin
        F_MensagemAddTag(VL_Chave00F1, '0110', 'S'); // conexao tipo s sistema c tipo caixa
        F_MensagemAddTag(VL_Chave00F1, '0109', PChar(EIdentificacao.Text)); // codigo da adquirencia- identificacao
        F_MensagemAddTag(VL_Chave00F1, '00A2', PChar('PDV')); // tipo do terminal
        F_MensagemAddTag(VL_Chave00F1, '00F9', PChar(ECodigoLoja.Text)); // codigo da loja
        F_MensagemAddTag(VL_Chave00F1, '0107', PChar(ECodigoPDV.Text)); // codigo do pdv
        F_MensagemAddTag(VL_Chave00F1, '0108', PChar(ECaixaIdentificacao.Text));  // identificacao do pdv

        F_MensagemTagAsString(VL_Chave00F1, VL_Dados);  //converte em string a mensagem

        F_MensagemAddComando(VL_Mensagem, '0105', 'S'); // solicita comando para ser executado no pdv
        F_MensagemAddTag(VL_Mensagem, '00F1', VL_Dados); // chave da transacao

        F_MensagemAddComando(VL_Transacao, '00FC', 'S'); //solicita MOSTRAR O QR CODE
        ImagemToStr(VL_String, Form1.IQrCodePinpad);
        F_MensagemAddTag(VL_Transacao, PChar('00FE'), PChar(VL_String));  // IMAGEM

        F_MensagemTagAsString(VL_Transacao, VL_Dados);  //converte em string a mensagem

        F_MensagemAddTag(VL_Mensagem, PChar('00E3'), VL_Dados);  // transacao criptografa

        F_MensagemTagAsString(VL_Mensagem, VL_Dados);  //converte em string a mensagem

        VL_Id := -1;

        for VL_I := 0 to F_OpenTef.Count - 1 do
        begin
            VL_RecOpenTef := F_OpenTef.GetRecOpeTef(VL_I);
            if VL_RecOpenTef.V_Tipo = 'S' then // servico
                VL_Id := VL_RecOpenTef.V_ID;
        end;

        if VL_Id = -1 then
        begin
            ShowMessage('Conexão não encontrada');
            Exit;
        end;

        VL_Erro := respondeservico('', VL_Dados, VL_Id);
        if VL_Erro <> 0 then
        begin
            F_Erro(VL_Erro, VL_DescricaoErro);
            ShowMessage('Erro: ' + IntToStr(VL_Erro) + #13 + 'Descrição: ' + VL_DescricaoErro);
        end;
    finally
        F_MensagemFree(VL_Mensagem);
        F_MensagemFree(VL_Chave00F1);
        F_MensagemFree(VL_Transacao);
    end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
    VL_Aes: TLbRijndael;
    VL_Texto: ansistring;
    VL_Key: TLBytes;
    VL_Chave: string;


    procedure HexToByte2(Value: string; var VO_Retorno: TLBytes);
    var
        i, T: integer;
    begin
        T := Length(Value);
        i := t div 2;

        SetLength(VO_Retorno, i);

        for i := 1 to T div 2 do
            VO_Retorno[i - 1] := StrToInt('$' + Copy(Value, (i - 1) * 2 + 1, 2));
    end;


    function ByteToHex2(Value: TLBytes): string;
    var
        I: integer;
    begin
        Result := '';
        for I := 0 to Length(Value) - 1 do
        begin
            Result := Result + IntToHex(Value[I], 2);
        end;
    end;

begin
{
    VL_Chave := '';
    VL_Texto := 'Mensagem';
    VL_Key := nil;

    VL_Aes := TLbRijndael.Create(nil);
    VL_Aes.KeySize := ks256;
    VL_Aes.CipherMode := cmECB;
    VL_Aes.GenerateKey(



    VL_Texto := VL_Aes.EncryptString(VL_Texto);

    SetLength(VL_Key,257);
    //
    VL_Aes.GetKey(VL_Key[1]);
    //
    VL_Chave := ByteToHex2(VL_Key);
    //
    //
    HexToByte2(VL_Chave,VL_Key);
    //
    //
    //
    VL_Aes.SetKey(VL_Key);










    VL_Texto := VL_Aes.DecryptString(VL_Texto);
    Caption:=VL_Texto;

    VL_Aes.Free;
    }
end;

procedure TForm1.Button2Click(Sender: TObject);
var
    VL_Pan, VL_WK, VL_Senha: pansichar;
    VL_Resultado: string;
begin
    VL_Resultado := '';
    VL_Pan := '0000600000051015000';
    VL_WK := '';
    VL_Senha := '4C4A33FFF0B1A57B';

    VL_Resultado := F_DescriptaSenha3Des(VL_WK, VL_Pan, VL_Senha);

    ShowMessage(VL_Resultado);
    ShowMessage(VL_Senha);
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
    F_OpenTef := TOpenTef.Create;
    F_Transacao := TTransacao.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
    F_OpenTef.Free;
    F_Transacao.Free;
end;

procedure TForm1.BDesativarClick(Sender: TObject);
begin
    if not Assigned(finalizaconexao) then
    begin
        ShowMessage('Inicialize a lib');
        Exit;
    end;

    finalizaconexao;
end;

procedure TForm1.BAtivaClick(Sender: TObject);
var
    VL_Erro: integer;
begin
    if (FMCom = 0) then
    begin
        ShowMessage('Inicialize a lib');
        Exit;
    end;

    VL_Erro := iniciarconexao(PChar(ExtractFilePath(ParamStr(0)) + 'operadora.log'), PChar(EChave.Text), PChar(EIPCaixa.Text), PChar(EIPServico.Text),
        EPortaCaixa.AsInteger, EPortaServico.AsInteger, @ServidorRecebimentoCaixa, @ServidorRecebimentoServico, PChar(EIdentificacao.Text));

    if VL_Erro <> 0 then
        ShowMessage('Erro: ' + IntToStr(VL_Erro));
end;

procedure TForm1.BConsultarTefClick(Sender: TObject);
var
    VL_Erro: integer;
    VL_Mensagem: Pointer;
    VL_Chave00F1: Pointer;
    VL_Transacao: Pointer;
    VL_Dados: PChar;
    VL_DescricaoErro: PChar;
    VL_Id: integer;
    VL_RecOpenTef: TRecOpeTef;
    VL_I: integer;
begin
    VL_Mensagem := nil;
    VL_Chave00F1 := nil;
    VL_Transacao := nil;
    F_MensagemCreate(VL_Mensagem);
    F_MensagemCreate(VL_Chave00F1);
    F_MensagemCreate(VL_Transacao);

    try
        if not Assigned(respondeservico) then
        begin
            ShowMessage('Inicialize a lib');
            Exit;
        end;

        VL_Dados := '';
        VL_DescricaoErro := '';

        F_MensagemAddComando(VL_Chave00F1, '0000', '');
        F_MensagemAddTag(VL_Chave00F1, '00F2', '0068'); // tag do modulo
        F_MensagemAddTag(VL_Chave00F1, '0036', '629867'); // bin
        F_MensagemAddTag(VL_Chave00F1, '0110', 'S'); // conexao tipo s sistema c tipo caixa
        F_MensagemAddTag(VL_Chave00F1, '0109', PChar(EIdentificacao.Text)); // codigo da adquirencia- identificacao
        F_MensagemAddTag(VL_Chave00F1, '00A2', PChar('PDV')); // tipo do terminal
        F_MensagemAddTag(VL_Chave00F1, '00F9', PChar(ECodigoLoja.Text)); // codigo da loja
        F_MensagemAddTag(VL_Chave00F1, '0107', PChar(ECodigoPDV.Text)); // codigo do pdv
        F_MensagemAddTag(VL_Chave00F1, '0108', PChar(ECaixaIdentificacao.Text));  // identificacao do pdv

        F_MensagemTagAsString(VL_Chave00F1, VL_Dados);  //converte em string a mensagem

        F_MensagemAddComando(VL_Mensagem, '0105', 'S'); // solicita comando para ser executado no pdv
        F_MensagemAddTag(VL_Mensagem, '00F1', VL_Dados); // chave da transacao

        F_MensagemAddComando(VL_Transacao, '0104', 'S'); // solicita tags
        F_MensagemAddTag(VL_Transacao, '0005', ''); // versao do tef

        F_MensagemTagAsString(VL_Transacao, VL_Dados);  //converte em string a mensagem

        F_MensagemAddTag(VL_Mensagem, PChar('00E3'), VL_Dados);  // transacao criptografa

        F_MensagemTagAsString(VL_Mensagem, VL_Dados);  //converte em string a mensagem

        VL_Id := -1;

        for VL_I := 0 to F_OpenTef.Count - 1 do
        begin
            VL_RecOpenTef := F_OpenTef.GetRecOpeTef(VL_I);
            if VL_RecOpenTef.V_Tipo = 'S' then // servico
                VL_Id := VL_RecOpenTef.V_ID;
        end;

        if VL_Id = -1 then
        begin
            ShowMessage('Conexão não encontrada');
            Exit;
        end;

        VL_Erro := respondeservico('', VL_Dados, VL_Id);
        if VL_Erro <> 0 then
        begin
            F_Erro(VL_Erro, VL_DescricaoErro);
            ShowMessage('Erro: ' + IntToStr(VL_Erro) + #13 + 'Descrição: ' + VL_DescricaoErro);
        end;
    finally
        F_MensagemFree(VL_Mensagem);
        F_MensagemFree(VL_Chave00F1);
        F_MensagemFree(VL_Transacao);
    end;
end;

procedure TForm1.BDataNascimentoPinPadClick(Sender: TObject);
var
    VL_Erro: integer;
    VL_Mensagem: Pointer;
    VL_Chave00F1: Pointer;
    VL_Transacao: Pointer;
    VL_Dados: PChar;
    VL_DescricaoErro: PChar;
    VL_Id: integer;
    VL_RecOpenTef: TRecOpeTef;
    VL_I: integer;
    VL_String: string;
begin
    VL_Mensagem := nil;
    VL_Chave00F1 := nil;
    VL_Transacao := nil;
    F_MensagemCreate(VL_Mensagem);
    F_MensagemCreate(VL_Chave00F1);
    F_MensagemCreate(VL_Transacao);

    try
        if not Assigned(respondeservico) then
        begin
            ShowMessage('Inicialize a lib');
            Exit;
        end;

        VL_Dados := '';
        VL_DescricaoErro := '';
        VL_String := '';

        F_MensagemAddComando(VL_Chave00F1, '0000', '');
        F_MensagemAddTag(VL_Chave00F1, '00F2', '0068'); // tag do modulo
        F_MensagemAddTag(VL_Chave00F1, '0036', '629867'); // bin
        F_MensagemAddTag(VL_Chave00F1, '0110', 'S'); // conexao tipo s sistema c tipo caixa
        F_MensagemAddTag(VL_Chave00F1, '0109', PChar(EIdentificacao.Text)); // codigo da adquirencia- identificacao
        F_MensagemAddTag(VL_Chave00F1, '00A2', PChar('PDV')); // tipo do terminal
        F_MensagemAddTag(VL_Chave00F1, '00F9', PChar(ECodigoLoja.Text)); // codigo da loja
        F_MensagemAddTag(VL_Chave00F1, '0107', PChar(ECodigoPDV.Text)); // codigo do pdv
        F_MensagemAddTag(VL_Chave00F1, '0108', PChar(ECaixaIdentificacao.Text));  // identificacao do pdv

        F_MensagemTagAsString(VL_Chave00F1, VL_Dados);  //converte em string a mensagem

        F_MensagemAddComando(VL_Mensagem, '0105', 'S'); // solicita comando para ser executado no pdv
        F_MensagemAddTag(VL_Mensagem, '00F1', VL_Dados); // chave da transacao

        F_MensagemAddComando(VL_Transacao, PChar('005A'), PChar('S'));   //solicita senha

        F_MensagemAddTag(VL_Transacao, PChar('005B'), PChar(IntToStr(F_Imk())));
        F_MensagemAddTag(VL_Transacao, PChar('005C'), PChar(' DIGITE A DATA DE NASCIMENTO'));
        F_MensagemAddTag(VL_Transacao, PChar('005D'), PChar('8'));
        F_MensagemAddTag(VL_Transacao, PChar('005E'), PChar('8'));
        F_MensagemAddTag(VL_Transacao, PChar('005F'), PChar(F_Wk()));
        F_MensagemAddTag(VL_Transacao, PChar('00D9'), '6298676000000510152');

        F_MensagemTagAsString(VL_Transacao, VL_Dados);  //converte em string a mensagem

        F_MensagemAddTag(VL_Mensagem, PChar('00E3'), VL_Dados);  // transacao criptografa

        F_MensagemTagAsString(VL_Mensagem, VL_Dados);  //converte em string a mensagem

        VL_Id := -1;

        for VL_I := 0 to F_OpenTef.Count - 1 do
        begin
            VL_RecOpenTef := F_OpenTef.GetRecOpeTef(VL_I);
            if VL_RecOpenTef.V_Tipo = 'S' then // servico
                VL_Id := VL_RecOpenTef.V_ID;
        end;

        if VL_Id = -1 then
        begin
            ShowMessage('Conexão não encontrada');
            Exit;
        end;

        VL_Erro := respondeservico('', VL_Dados, VL_Id);
        if VL_Erro <> 0 then
        begin
            F_Erro(VL_Erro, VL_DescricaoErro);
            ShowMessage('Erro: ' + IntToStr(VL_Erro) + #13 + 'Descrição: ' + VL_DescricaoErro);
        end;
    finally
        F_MensagemFree(VL_Mensagem);
        F_MensagemFree(VL_Chave00F1);
        F_MensagemFree(VL_Transacao);
    end;
end;

end.
