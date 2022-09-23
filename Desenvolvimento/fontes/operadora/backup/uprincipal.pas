unit uprincipal;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
    ComCtrls, rxspin;

type

    { TForm1 }
    TTransacaoStatus = (tsEfetivada, tsNegada, tsCancelada, tsProcessando, tsAguardandoComando, tsNaoLocalizada, tsInicializada, tsComErro, tsAbortada);

    TServidorRecebimentoLib = function(VP_Codigo: integer; VP_Transmissao_ID, VP_DadosRecebidos: PChar; VP_IP: PChar;
        VP_ID: integer; VP_Chave: PChar): integer; cdecl;

    Tiniciarconexao = function(VP_ArquivoLog, VP_Chave, VP_IP_Caixa, VP_IP_Servico: PChar; VP_PortaCaixa, VP_PortaServico: integer;
        VO_RetornoCaixa, VO_Retorno_Servico: TServidorRecebimentoLib): integer; cdecl;
    Tfinalizaconexao = function(): integer; cdecl;
    TResponde = function(VP_Transmissao_ID, VP_Mesagem: PChar; VP_ID: integer): integer; cdecl;

    TTMensagemCreate = function(var VO_Mensagem: Pointer): integer; cdecl;
    TTMensagemCarregaTags = function(VP_Mensagem: Pointer; VP_Dados: PChar): integer; cdecl;
    TTMensagemComando = function(VP_Mensagem: Pointer; var VO_Dados: PChar): integer; cdecl;
    TTMensagemComandoDados = function(VP_Mensagem: Pointer; var VO_Dados: PChar): integer; cdecl;
    TTMensagemFree = procedure(VP_Mensagem: Pointer); cdecl;
    TTMensagemaddtag = function(VP_Mensagem: Pointer; VP_Tag, VP_Dados: PChar): integer; cdecl;
    TTMensagemaddcomando = function(VP_Mensagem: Pointer; VP_Tag, VP_Dados: PChar): integer; cdecl;
    TTMensagemTagAsString = function(VP_Mensagem: Pointer; var VO_Dados: PChar): integer; cdecl;
    TTMensagemTagCount = function(VP_Mensagem: Pointer): integer; cdecl;
    TTMensagemGetTag = function(VP_Mensagem: Pointer; VP_Tag: PChar; var VO_Dados: PChar): integer; cdecl;
    TTMensagemGetTagIdx = function(VP_Mensagem: Pointer; VL_Idx: integer; var VO_Tag: PChar; var VO_Dados: PChar): integer; cdecl;
    TTMensagemTagToStr = function(VP_Mensagem: Pointer; var VO_Dados: PChar): integer; cdecl;
    TTMensagemLimpar = procedure(VP_Mensagem: Pointer); cdecl;
    TTMensagemerro = function(VP_CodigoErro: integer; var VO_RespostaMensagem: PChar): integer; cdecl;

    TDescriptaSenha3Des = function(VP_Wk, VP_pan, VP_Senha: ansistring): ansistring; cdecl;
    TEncriptaSenha3Des = function(VP_Wk, VP_pan, VP_Senha: ansistring): ansistring; cdecl;
    Twkc = function(): ansistring; cdecl;
    Timk = function(): integer; cdecl;

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


    TForm1 = class(TForm)
        BAtiva: TButton;
        BConsultarTef: TButton;
        BDesativar: TButton;
        Bevel1: TBevel;
        BInicializaDll: TButton;
        cbxCPF: TCheckBox;
        cbxSenha: TCheckBox;
        cbxQrcode: TCheckBox;
        EChave: TEdit;
        ECodigoLoja: TEdit;
        ECodigoPDV: TEdit;
        EIdentificacao: TEdit;
        EIPCaixa: TEdit;
        EIPServico: TEdit;
        EPortaCaixa: TRxSpinEdit;
        EPortaServico: TRxSpinEdit;
        GroupBox1: TGroupBox;
        GroupBox2: TGroupBox;
        GroupBox3: TGroupBox;
        Image1: TImage;
        Label1: TLabel;
        Label2: TLabel;
        Label3: TLabel;
        Label4: TLabel;
        Label5: TLabel;
        Label6: TLabel;
        Label7: TLabel;
        Label8: TLabel;
        PageControl1: TPageControl;
        TabSheet1: TTabSheet;
        TabSheet2: TTabSheet;
        procedure BAtivaClick(Sender: TObject);
        procedure BConsultarTefClick(Sender: TObject);
        procedure BDesativarClick(Sender: TObject);
        procedure BInicializaDllClick(Sender: TObject);
        procedure FormCreate(Sender: TObject);
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


function ServidorRecebimentoCaixa(VP_Erro: integer; VP_Transmissao_ID, VP_DadosRecebidos: PChar; VP_IP: PChar; VP_ID: integer;
    VP_Chave: PChar): integer; cdecl;
function ServidorRecebimentoServico(VP_Erro: integer; VP_Transmissao_ID, VP_DadosRecebidos: PChar; VP_IP: PChar; VP_ID: integer;
    VP_Chave: PChar): integer; cdecl;



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

    F_OpenTef: TOpenTef;


implementation

function ServidorRecebimentoCaixa(VP_Erro: integer; VP_Transmissao_ID, VP_DadosRecebidos: PChar; VP_IP: PChar; VP_ID: integer;
    VP_Chave: PChar): integer; cdecl;
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


    if VL_Comando = '0028' then
        F_OpenTef.Add(VP_ID, VP_Transmissao_ID, 'C', VP_Chave, VP_IP)
    else
        ThProcessaSolicitacoes.Create(VP_Transmissao_ID, VP_DadosRecebidos, VP_IP, VP_ID, respondecaixa);

end;

function ServidorRecebimentoServico(VP_Erro: integer; VP_Transmissao_ID, VP_DadosRecebidos: PChar; VP_IP: PChar; VP_ID: integer;
    VP_Chave: PChar): integer; cdecl;
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

    if VL_Comando = '0028' then
        F_OpenTef.Add(VP_ID, VP_Transmissao_ID, 'S', VP_Chave, VP_IP)
    else
        ThProcessaSolicitacoes.Create(VP_Transmissao_ID, VP_DadosRecebidos, VP_IP, VP_ID, respondeservico);

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

    if V_Lista.Count = 0 then
        Exit;

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


{ ThProcessaSolicitacoes }

procedure ThProcessaSolicitacoes.Execute;
var
    VL_Erro: integer;
    VL_Senha: PChar;
    VL_Valor: PChar;
    VL_Comando, VL_ComandoDados: PChar;
    VL_Cpf: PChar;
    VL_Cartao: PChar;
    VL_Mensagem: Pointer;
    VL_Mensagem_Dados: Pointer;
    VL_TagDados: PChar;
    VL_Pan, VL_TK2: PChar;
    VL_String: string;
    VL_PChar: PChar;
    VL_Stream: TMemoryStream;
    VL_ChaveTamanho: integer;
    VL_ChaveExpoente: PChar;
    VL_ChaveModulo: PChar;
    VL_ChaveTransacao: PChar;
    VL_Tag: PChar;
    VL_ChaveMensagem: Pointer;
    VL_Autorizacao: PChar;
    VL_DescricaoErro: PChar;


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

begin
    try
        VL_Mensagem := nil;
        VL_Mensagem_Dados := nil;
        VL_ChaveMensagem := nil;
        F_MensagemCreate(VL_Mensagem);
        F_MensagemCreate(VL_Mensagem_Dados);
        F_MensagemCreate(VL_ChaveMensagem);
        VL_Senha := '';
        VL_TagDados := '';
        VL_String := '';
        VL_Valor := '';
        VL_TK2 := '';
        VL_Pan := '';
        VL_PChar := '';
        VL_Cpf := '';
        VL_Cartao := '';
        VL_ChaveTamanho := 0;
        VL_ChaveExpoente := '';
        VL_ChaveModulo := '';
        VL_Comando := '';
        VL_ComandoDados := '';
        VL_ChaveTransacao := '';
        VL_Tag := '';
        VL_Autorizacao := '';
        VL_DescricaoErro := '';



        vl_erro := F_MensagemCarregaTags(VL_Mensagem, PChar(fVP_DadosRecebidos));

        if vl_erro <> 0 then
        begin
            Exit;
        end;

        F_MensagemGetTag(VL_Mensagem, PChar('0008'), VL_ChaveModulo);
        F_MensagemGetTag(VL_Mensagem, PChar('0027'), VL_ChaveExpoente);
        F_MensagemGetTag(VL_Mensagem, PChar('00E4'), VL_PChar);
        if VL_PChar <> '' then
            VL_ChaveTamanho := StrToInt(VL_PChar);


        F_MensagemComando(VL_Mensagem, VL_Comando);
        F_MensagemComandoDados(VL_Mensagem, VL_ComandoDados);


        if VL_Comando = '0026' then        // RETORNO DO COMANDO
        begin
            VL_TagDados := '';
            F_MensagemGetTag(VL_Mensagem, '007D', VL_TagDados);
            if VL_TagDados <> '' then
                F_MensagemCarregaTags(VL_Mensagem_Dados, VL_TagDados);

            if VL_ComandoDados <> '' then
            begin
                F_Erro(StrToInt(VL_ComandoDados), VL_DescricaoErro);
                ShowMessage('Erro: ' + VL_ComandoDados + #13 + 'Descrição: ' + VL_DescricaoErro);
            end;

            Exit;
        end;


        if ((VL_Comando = '00CD') and (VL_ComandoDados = 'S')) then                     // atualiza bins
        begin

            F_MensagemLimpar(VL_Mensagem);
            F_MensagemAddComando(VL_Mensagem, '00CD', 'R');
            F_MensagemAddTag(VL_Mensagem, '004D', PChar('0'));
            F_MensagemAddTag(VL_Mensagem, '00CE', PChar('629867'));
            F_MensagemTagAsString(VL_Mensagem, VL_PChar);
            fVP_Retorno(PChar(fVP_Transmissao_ID), VL_PChar, fVP_ID);
            Exit;

        end;

        if ((VL_Comando = '00CF') and (VL_ComandoDados = 'S')) then                            //MENU DE VENDA
        begin

            F_MensagemLimpar(VL_Mensagem);
            F_MensagemAddComando(VL_Mensagem, '00CF', 'R');              // RETORNO VAZIO
            F_MensagemAddTag(VL_Mensagem, '004D', PChar('0'));
            F_MensagemAddTag(VL_Mensagem, '007D', PChar(''));
            F_MensagemTagAsString(VL_Mensagem, VL_PChar);
            fVP_Retorno(PChar(fVP_Transmissao_ID), VL_PChar, fVP_ID);
            Exit;

        end;

        if ((VL_Comando = '00D4') and (VL_ComandoDados = 'S')) then                          // MENU DE OPERACAO
        begin

            F_MensagemLimpar(VL_Mensagem);
            F_MensagemAddComando(VL_Mensagem, '00D4', 'R');      //renorno do comando
            F_MensagemAddTag(VL_Mensagem, '004D', PChar('0'));  //comando realizado com sucesso
            F_MensagemAddComando(VL_Mensagem_Dados, '0018', PChar('R'));   //renorno da lista de menu
            F_MensagemAddTag(VL_Mensagem_Dados, '00D3', PChar('Cancela Venda')); //item do menu
            F_MensagemAddTag(VL_Mensagem_Dados, 'FFD3', PChar('Cancela Plano')); //item do menu
            F_MensagemTagAsString(VL_Mensagem_Dados, VL_PChar);     //converte em string a mensagem
            F_MensagemAddTag(VL_Mensagem, '007D', VL_PChar);  // coloca a mensagem na tag de mensagem
            F_MensagemTagAsString(VL_Mensagem, VL_PChar); //converte em string a mensagem
            fVP_Retorno(PChar(fVP_Transmissao_ID), VL_PChar, fVP_ID); // envia de volta o comando
            Exit;

        end;

        if ((VL_Comando = '0105') and (VL_ComandoDados = 'R')) then                          // RETORNO DO COMANDO EXECUTADO NO PDV
        begin

            VL_TagDados := '';
            F_MensagemGetTag(VL_Mensagem, '007D', VL_TagDados);
            if VL_TagDados <> '' then
                F_MensagemCarregaTags(VL_Mensagem_Dados, VL_TagDados);

            F_MensagemGetTag(VL_Mensagem_Dados, PChar('0103'), VL_PChar);            // versao do tef

            ShowMessage('Versão do tef: ' + VL_PChar);
            Exit;
        end;

        if ((VL_Comando = '00F6') and (VL_ComandoDados = 'S')) then         // CANCELAMENTO DE VENDA
        begin
            VL_TagDados := '';
            F_MensagemGetTag(VL_Mensagem, '007D', VL_TagDados);
            if VL_TagDados <> '' then
                F_MensagemCarregaTags(VL_Mensagem_Dados, VL_TagDados);

            F_MensagemLimpar(VL_Mensagem);

            F_MensagemAddTag(VL_Mensagem, PChar('00E3'), PChar(''));  // solicita dados protegidos
            F_MensagemAddTag(VL_Mensagem, PChar('0008'), VL_ChaveModulo);
            F_MensagemAddTag(VL_Mensagem, PChar('0027'), VL_ChaveExpoente);
            F_MensagemAddTag(VL_Mensagem, PChar('00E4'), VL_PChar);

            F_MensagemGetTag(VL_Mensagem_Dados, PChar('0033'), VL_TagDados);         // dados capturados

            F_MensagemGetTag(VL_Mensagem_Dados, PChar('00D5'), VL_PChar);            // BOTAO SELECIONADO

            F_MensagemGetTag(VL_Mensagem_Dados, PChar('00F1'), VL_ChaveTransacao);   // chave da transacao

            VL_ChaveTransacao := PChar(Trim(string(VL_ChaveTransacao))); // eliminando espacos e formatacoes para nao ocorrer erros

            if (VL_ChaveTransacao = '') or (VL_ChaveTransacao = #1) then // chave da transacao nao enviada
            begin
                //F_MensagemLimpar(VL_Mensagem_Dados);
                F_MensagemAddComando(VL_Mensagem_Dados, PChar('0026'), PChar('89')); // resposta com erro
                F_MensagemAddTag(VL_Mensagem_Dados, '00A4', PChar(IntToStr(Ord(tsAbortada))));  // transacao obortada
                F_MensagemTagAsString(VL_Mensagem_Dados, VL_Tag);
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
                F_MensagemTagAsString(VL_Mensagem_Dados, VL_Tag);
                fVP_Retorno(PChar(fVP_Transmissao_ID), VL_Tag, fVP_ID); // envia de volta o comando
                F_MensagemAddTag(VL_Mensagem_Dados, '00A4', PChar(IntToStr(Ord(tsAbortada))));  // transacao obortada
                Exit;
            end;

            // mostra mensagem na tela
            VL_String := 'Cancelamento da venda realizado com sucesso';
            F_MensagemAddComando(VL_Mensagem_Dados, PChar('002C'), PChar('S'));   //MENSAGEM OPERADOR
            F_MensagemAddTag(VL_Mensagem_Dados, '00DA', PChar(VL_String));  // mensagem no pdv
            F_MensagemAddTag(VL_Mensagem_Dados, '00A4', PChar(IntToStr(Ord(tsEfetivada))));  // transacao obortada
            F_MensagemTagAsString(VL_Mensagem_Dados, VL_Tag);
            fVP_Retorno(PChar(fVP_Transmissao_ID), VL_Tag, fVP_ID); // envia de volta o comando
            Exit;

        end;

        if ((VL_Comando = '00F3') and (VL_ComandoDados = 'S')) then                          // CONSULTAR SALDO
        begin
            VL_TagDados := '';
            F_MensagemGetTag(VL_Mensagem, '007D', VL_TagDados);
            if VL_TagDados <> '' then
                F_MensagemCarregaTags(VL_Mensagem_Dados, VL_TagDados);

            F_MensagemLimpar(VL_Mensagem);

            F_MensagemAddTag(VL_Mensagem, PChar('00E3'), PChar(''));  // solicita dados protegidos
            F_MensagemAddTag(VL_Mensagem, PChar('0008'), VL_ChaveModulo);
            F_MensagemAddTag(VL_Mensagem, PChar('0027'), VL_ChaveExpoente);
            F_MensagemAddTag(VL_Mensagem, PChar('00E4'), VL_PChar);

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
            F_MensagemTagAsString(VL_Mensagem_Dados, VL_Tag);
            fVP_Retorno(PChar(fVP_Transmissao_ID), VL_Tag, fVP_ID); // envia de volta o comando
            Exit;

        end;

        if ((VL_Comando = '000A') and (VL_ComandoDados = 'S')) then        // APROVACAO DA TRANSACAO
        begin
            VL_TagDados := '';
            F_MensagemGetTag(VL_Mensagem, '007D', VL_TagDados);
            if VL_TagDados <> '' then
                F_MensagemCarregaTags(VL_Mensagem_Dados, VL_TagDados);

            F_MensagemLimpar(VL_Mensagem);
            F_MensagemAddTag(VL_Mensagem, PChar('00E3'), PChar(''));  // solicita dados protegidos
            F_MensagemAddTag(VL_Mensagem, PChar('0008'), VL_ChaveModulo);
            F_MensagemAddTag(VL_Mensagem, PChar('0027'), VL_ChaveExpoente);
            F_MensagemAddTag(VL_Mensagem, PChar('00E4'), VL_PChar);

            F_MensagemGetTag(VL_Mensagem_Dados, PChar('004F'), VL_TK2);            // tk2

            F_MensagemGetTag(VL_Mensagem_Dados, PChar('00E9'), VL_Cpf);            // CPF

            F_MensagemGetTag(VL_Mensagem_Dados, PChar('00D9'), VL_Pan);                 // pan nao enviado de proposito

            F_MensagemGetTag(VL_Mensagem_Dados, PChar('0033'), VL_TagDados);            // dados capturados

            F_MensagemGetTag(VL_Mensagem_Dados, PChar('00D5'), VL_PChar);            // BOTAO SELECIONADO

            F_MensagemGetTag(VL_Mensagem_Dados, PChar('0060'), VL_Senha);            // senha criptografada dados capturados

            F_MensagemGetTag(VL_Mensagem_Dados, PChar('0013'), VL_Valor);            // valor dados capturados

            F_MensagemGetTag(VL_Mensagem_Dados, PChar('00E7'), VL_Cartao);            // cartao dados capturados

            F_MensagemGetTag(VL_Mensagem_Dados, PChar('00F1'), VL_ChaveTransacao);   // chave da transacao

            if VL_Cartao = '' then
                VL_Cartao := VL_Pan;

            if (VL_Valor = '') then
            begin

                F_MensagemLimpar(VL_Mensagem_Dados);
                F_MensagemAddComando(VL_Mensagem_Dados, PChar('00E1'), PChar('S'));   //solicita dados da venda

                if VL_Valor = '' then
                    F_MensagemAddTag(VL_Mensagem_Dados, PChar('0013'), PChar(''));  // solicita valor total da venda

                F_MensagemTagAsString(VL_Mensagem_Dados, VL_Tag);     //converte em string a mensagem

                F_MensagemAddComando(VL_Mensagem, PChar('00E1'), PChar('S'));   //solicita dados da venda
                F_MensagemAddTag(VL_Mensagem, PChar('00E3'), VL_Tag); // transacao criptografa

                F_MensagemTagAsString(VL_Mensagem, VL_Tag);     //converte em string a mensagem
                fVP_Retorno(PChar(fVP_Transmissao_ID), VL_Tag, fVP_ID); // envia de volta o comando
                Exit;
            end;

            // verifica os dados obrigatorio

            if VL_Valor = #1 then // valor veio nulo
            begin
                F_MensagemLimpar(VL_Mensagem_Dados);

                F_MensagemAddComando(VL_Mensagem_Dados, '0000', 'S');
                VL_String := 'Valor não informado';
                F_MensagemAddComando(VL_Mensagem_Dados, PChar('002C'), PChar('S'));   //MENSAGEM OPERADOR
                F_MensagemAddTag(VL_Mensagem_Dados, '00DA', PChar(VL_String));  // mensagem no pdv
                F_MensagemAddTag(VL_Mensagem_Dados, '00A4', PChar(IntToStr(Ord(tsNegada))));  // transacao obortada
                F_MensagemAddTag(VL_Mensagem_Dados, '004A', PChar(VL_String));  // mensagem erro descricao

                F_MensagemTagAsString(VL_Mensagem_Dados, VL_Tag);

                fVP_Retorno(PChar(fVP_Transmissao_ID), VL_Tag, fVP_ID); // envia de volta o comando
                Exit;
            end;

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
                        ImagemToStr(VL_String, Form1.Image1); // converte a imagem em string
                        F_MensagemAddTag(VL_Mensagem_Dados, '002E', PChar(VL_String));    //campo enviar imagem
                    end;

                    F_MensagemTagAsString(VL_Mensagem_Dados, VL_PChar);     //converte em string a mensagem

                    F_MensagemAddComando(VL_Mensagem, PChar('002A'), PChar('S'));   //solicita dados pdv
                    F_MensagemAddTag(VL_Mensagem, PChar('00E3'), VL_PChar);

                    F_MensagemTagAsString(VL_Mensagem, VL_PChar);     //converte em string a mensagem

                    fVP_Retorno(PChar(fVP_Transmissao_ID), VL_PChar, fVP_ID); // envia de volta o comando

                    Exit;

                    { solicita senha pin pad
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
                    }
                end;

            end;


            if Form1.cbxCPF.Checked then
            begin
                if (VL_PChar = '002F') and (string(VL_Cpf) = '') then  // retorno do cpf
                begin
                    VL_Cpf := VL_TagDados;
                    if string(VL_Cpf) <> '' then
                    begin
                        F_MensagemLimpar(VL_Mensagem_Dados);
                        F_MensagemAddComando(VL_Mensagem_Dados, PChar('008C'), PChar('S'));     //solicita atualiza transacao
                        F_MensagemAddTag(VL_Mensagem_Dados, PChar('00E9'), PChar(VL_Cpf));       // cpf criptografado

                        F_MensagemTagAsString(VL_Mensagem_Dados, VL_PChar);     //converte em string a mensagem

                        F_MensagemAddComando(VL_Mensagem, PChar('008C'), PChar('S')); //solicita atualiza transacao
                        F_MensagemAddTag(VL_Mensagem, PChar('00E3'), VL_PChar);  // transacao criptografada
                        F_MensagemAddTag(VL_Mensagem, PChar('00D5'), PChar(''));      // botao selecionado


                        F_MensagemTagAsString(VL_Mensagem, VL_PChar);     //converte em string a mensagem

                        fVP_Retorno(PChar(fVP_Transmissao_ID), VL_PChar, fVP_ID); // envia de volta o comando
                        Exit;
                    end;

                end;


                if VL_Cpf = '' then         // exemplo de captura de dados   CPF
                begin
                    F_MensagemLimpar(VL_Mensagem_Dados);

                    // INFORMA OS BOTOES DENTRO DA TAG DE COMANDO DO BOTAO 0018

                    F_MensagemAddComando(VL_Mensagem_Dados, '0000', 'S');
                    F_MensagemAddTag(VL_Mensagem_Dados, '002F', PChar('OK'));    //BOTAO OK

                    F_MensagemTagAsString(VL_Mensagem_Dados, VL_PChar);     //converte em string a mensagem

                    F_MensagemLimpar(VL_Mensagem_Dados);

                    F_MensagemAddComando(VL_Mensagem_Dados, PChar('002A'), PChar('S'));   //solicita dados pdv
                    F_MensagemAddTag(VL_Mensagem_Dados, '00DA', PChar('INFORME O CPF'));    //MENSAGEM A SER MOSTRADA
                    F_MensagemAddTag(VL_Mensagem_Dados, '00DD', VL_PChar);    //BOTOES A MOSTRAR
                    F_MensagemAddTag(VL_Mensagem_Dados, '0033', PChar('A'));    //campo para capturar sem mascara

                    F_MensagemTagAsString(VL_Mensagem_Dados, VL_PChar);     //converte em string a mensagem

                    F_MensagemAddComando(VL_Mensagem, PChar('002A'), PChar('S'));   //solicita dados pdv
                    F_MensagemAddTag(VL_Mensagem, PChar('00E3'), VL_PChar);
                    F_MensagemTagAsString(VL_Mensagem, VL_PChar);     //converte em string a mensagem


                    fVP_Retorno(PChar(fVP_Transmissao_ID), VL_PChar, fVP_ID); // envia de volta o comando

                end;
            end;



            vl_erro := F_MensagemCarregaTags(VL_ChaveMensagem, VL_ChaveTransacao);  // carrega os dados da chave da transacao

            if vl_erro <> 0 then
            begin
                F_MensagemLimpar(VL_Mensagem_Dados);

                F_MensagemAddComando(VL_Mensagem_Dados, PChar('0000'), PChar('S'));
                F_MensagemAddComando(VL_Mensagem_Dados, PChar('000A'), PChar('R')); // retorno
                F_MensagemAddTag(VL_Mensagem_Dados, PChar('004D'), PChar(IntToStr(VL_Erro))); // resposta com erro
                F_MensagemAddTag(VL_Mensagem_Dados, '00A4', PChar(IntToStr(Ord(tsAbortada))));  // transacao obortada

                F_MensagemTagAsString(VL_Mensagem_Dados, VL_Tag);

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

                VL_String := 'Cartão:' + VL_Cartao + '<br>Valor dos itens:' + VL_Valor;
                if Form1.cbxCPF.Checked then
                    VL_String := VL_String + '<br>CPF:' + VL_Cpf;

                F_MensagemAddComando(VL_Mensagem_Dados, PChar('002C'), PChar('S'));   //MENSAGEM OPERADOR
                F_MensagemAddTag(VL_Mensagem_Dados, '00DA', PChar(VL_String));  // mensagem no pdv
                F_MensagemAddTag(VL_Mensagem_Dados, '00A4', PChar(IntToStr(Ord(tsEfetivada))));  // transacao obortada
                F_MensagemTagAsString(VL_Mensagem_Dados, VL_PChar);
                fVP_Retorno(PChar(fVP_Transmissao_ID), VL_PChar, fVP_ID); // envia de volta o comando

            end;
            Exit;
        end;



        //        F_MensagemLimpar(VL_Mensagem);

        //        F_MensagemAddTag(VL_Mensagem, '00E3', PChar('')); //dados protegidos
        //        F_MensagemAddComando(VL_Mensagem, '0018', PChar('S'));   //renorno da lista de menu
        //        F_MensagemAddTag(VL_Mensagem, '00D3', PChar('Cancela Venda')); //item do menu
        //        F_MensagemAddTag(VL_Mensagem, 'FFD3', PChar('Cancela Plano')); //item do menu

        //        F_MensagemTagAsString(VL_Mensagem, VL_PChar);     //converte em string a mensagem

        //        fVP_Retorno(PChar(fVP_Transmissao_ID), VL_PChar, fVP_ID); // envia de volta o comando


    finally
        F_MensagemFree(VL_Mensagem);
        F_MensagemFree(VL_Mensagem_Dados);
        F_MensagemFree(VL_ChaveMensagem);
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
    FMCom := LoadLibrary(PChar(ExtractFilePath(ParamStr(0)) + '..\..\mcom_lib\win64\mcom_lib.dll'));
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

end;


procedure TForm1.FormCreate(Sender: TObject);
begin
    F_OpenTef := TOpenTef.Create;
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
    if not Assigned(iniciarconexao) then
    begin
        ShowMessage('Inicialize a lib');
        Exit;
    end;

    VL_Erro := iniciarconexao(PChar(ExtractFilePath(ParamStr(0)) + 'operadora.log'), PChar(EChave.Text), PChar(EIPCaixa.Text), PChar(EIPServico.Text),
        EPortaCaixa.AsInteger, EPortaServico.AsInteger, @ServidorRecebimentoCaixa, @ServidorRecebimentoServico);

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
        F_MensagemAddTag(VL_Chave00F1, '00A2', PChar('PDV')); // tipo do terminal
        F_MensagemAddTag(VL_Chave00F1, '00F9', PChar(ECodigoLoja.Text)); // codigo da loja
        F_MensagemAddTag(VL_Chave00F1, '0107', PChar(ECodigoPDV.Text)); // codigo do pdv
        F_MensagemAddTag(VL_Chave00F1, '0108', PChar(EIdentificacao.Text));  // identificacao

        F_MensagemTagAsString(VL_Chave00F1, VL_Dados);

        F_MensagemAddComando(VL_Mensagem, '0105', 'S'); // solicita comando para ser executado no pdv
        F_MensagemAddTag(VL_Mensagem, '00F1', VL_Dados); // chave da transacao

        F_MensagemAddComando(VL_Transacao, '0104', 'S'); // solicita tags
        F_MensagemAddTag(VL_Transacao, '0103', ''); // versao do tef

        F_MensagemTagAsString(VL_Transacao, VL_Dados);

        F_MensagemAddTag(VL_Mensagem, PChar('00E3'), VL_Dados);  // transacao criptografa


        F_MensagemTagAsString(VL_Mensagem, VL_Dados);

        VL_Id := -1;

        for VL_I := 0 to F_OpenTef.Count - 1 do
        begin
            VL_RecOpenTef := F_OpenTef.GetRecOpeTef(VL_I);
            if VL_RecOpenTef.V_Tipo = 'S' then
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
