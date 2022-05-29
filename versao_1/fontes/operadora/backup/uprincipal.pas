unit uprincipal;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, rxspin;

type

    { TForm1 }
    TServidorRecebimentoLib = function(VP_Codigo: integer; VP_Transmissao_ID, VP_DadosRecebidos: PChar; VP_IP: PChar; VP_ID: integer): integer; stdcall;

    Tiniciarconexao = function(VP_ArquivoLog, VP_Chave, VP_IP_Caixa, VP_IP_Servico: PChar; VP_PortaCaixa, VP_PortaServico: integer;
        VO_RetornoCaixa, VO_Retorno_Servico: TServidorRecebimentoLib): integer; stdcall;
    Tfinalizaconexao = function(): integer; stdcall;
    TResponde = function(VP_Transmissao_ID, VP_Mesagem: PChar; VP_ID: integer): integer; stdcall;

    TTMensagemCreate = function(var VO_Mensagem: Pointer): integer; stdcall;
    TTMensagemCarregaTags = function(VP_Mensagem: Pointer; VP_Dados: PChar): integer; stdcall;
    TTMensagemComando = function(VP_Mensagem: Pointer): PChar; stdcall;
    TTMensagemComandoDados = function(VP_Mensagem: Pointer): PChar; stdcall;
    TTMensagemFree = procedure(VP_Mensagem: Pointer); stdcall;
    TTMensagemaddtag = function(VP_Mensagem: Pointer; VP_Tag, VP_Dados: PChar): integer; stdcall;
    TTMensagemaddcomando = function(VP_Mensagem: Pointer; VP_Tag, VP_Dados: PChar): integer; stdcall;
    TTMensagemTagAsString = function(VP_Mensagem: Pointer): PChar; stdcall;
    TTMensagemTagCount = function(VP_Mensagem: Pointer): integer; stdcall;
    TTMensagemGetTag = function(VP_Mensagem: Pointer; VP_Tag: PChar; var VO_Dados: PChar): integer; stdcall;
    TTMensagemGetTagIdx = function(VP_Mensagem: Pointer; VL_Idx: integer; var VO_Tag: PChar; var VO_Dados: PChar): integer; stdcall;
    TTMensagemTagToStr = function(VP_Mensagem: Pointer; var VO_Dados: PChar): integer; stdcall;
    TTMensagemLimpar = procedure(VP_Mensagem: Pointer); stdcall;

    TDescriptaSenha3Des = function(VP_Wk, VP_pan, VP_Senha: ansistring): ansistring; stdcall;
    TEncriptaSenha3Des = function(VP_Wk, VP_pan, VP_Senha: ansistring): ansistring; stdcall;
    Twkc = function(): ansistring; stdcall;
    Timk = function(): integer; stdcall;




    TForm1 = class(TForm)
        BInicializaDll: TButton;
        BAtiva: TButton;
        BDesativar: TButton;
        EIPCaixa: TEdit;
        EChave: TEdit;
        EIPServico: TEdit;
        Label1: TLabel;
        Label2: TLabel;
        Label3: TLabel;
        Label4: TLabel;
        EPortaCaixa: TRxSpinEdit;
        EPortaServico: TRxSpinEdit;
        Label5: TLabel;
        procedure BAtivaClick(Sender: TObject);
        procedure BDesativarClick(Sender: TObject);
        procedure BInicializaDllClick(Sender: TObject);
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


function ServidorRecebimentoCaixa(VP_Codigo: integer; VP_Transmissao_ID, VP_DadosRecebidos: PChar; VP_IP: PChar; VP_ID: integer): integer; stdcall;
function ServidorRecebimentoServico(VP_Codigo: integer; VP_Transmissao_ID, VP_DadosRecebidos: PChar; VP_IP: PChar; VP_ID: integer): integer; stdcall;



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

    F_DescriptaSenha3Des: TDescriptaSenha3Des;
    F_EncriptaSenha3Des: TEncriptaSenha3Des;
    F_Wk: Twkc;
    F_Imk: Timk;



implementation

function ServidorRecebimentoCaixa(VP_Codigo: integer; VP_Transmissao_ID, VP_DadosRecebidos: PChar; VP_IP: PChar; VP_ID: integer): integer; stdcall;
begin
    Result := VP_Codigo;
    if Result <> 0 then exit;
    ThProcessaSolicitacoes.Create(VP_Transmissao_ID, VP_DadosRecebidos, VP_IP, VP_ID, respondecaixa);

end;

function ServidorRecebimentoServico(VP_Codigo: integer; VP_Transmissao_ID, VP_DadosRecebidos: PChar; VP_IP: PChar; VP_ID: integer): integer; stdcall;
begin
    Result := VP_Codigo;
    if Result <> 0 then exit;
    Result := 0;
    ThProcessaSolicitacoes.Create(VP_Transmissao_ID, VP_DadosRecebidos, VP_IP, VP_ID, respondeservico);

end;

{$R *.lfm}

{ ThProcessaSolicitacoes }

procedure ThProcessaSolicitacoes.Execute;
var
    VL_Erro: integer;
    VL_Dados: PChar;
    VL_Mensagem: Pointer;
    VL_Mensagem_Dados: Pointer;
    VL_TagDados: PChar;
    VL_Pan: PChar;
    VL_String: string;

begin
    try
        VL_Mensagem := nil;
        VL_Mensagem_Dados := nil;
        F_MensagemCreate(VL_Mensagem);
        F_MensagemCreate(VL_Mensagem_Dados);
        VL_Dados := '';
        VL_TagDados := '';
        VL_String := '';
        ;

        vl_erro := F_MensagemCarregaTags(VL_Mensagem, PChar(fVP_DadosRecebidos));

        if vl_erro <> 0 then
        begin

        end;

        if ((F_MensagemComando(VL_Mensagem) = '00CD') and (F_MensagemComandoDados(VL_Mensagem) = 'S')) then                     // atualiza bins
        begin

            F_MensagemLimpar(VL_Mensagem);

            F_MensagemAddComando(VL_Mensagem, '00CD', 'R');

            F_MensagemAddTag(VL_Mensagem, '004D', PChar('0'));

            F_MensagemAddTag(VL_Mensagem, '00CE', PChar('629867'));

            VL_String := F_MensagemTagAsString(VL_Mensagem);

            fVP_Retorno(PChar(fVP_Transmissao_ID), PChar(VL_String), fVP_ID);

        end;

        if ((F_MensagemComando(VL_Mensagem) = '00CF') and (F_MensagemComandoDados(VL_Mensagem) = 'S')) then                            //MENU DE VENDA
        begin

            F_MensagemLimpar(VL_Mensagem);

            F_MensagemAddComando(VL_Mensagem, '00CF', 'R');              // RETORNO VAZIO

            F_MensagemAddTag(VL_Mensagem, '004D', PChar('0'));
            F_MensagemAddTag(VL_Mensagem, '007D', PChar(''));

            VL_String := F_MensagemTagAsString(VL_Mensagem);

            fVP_Retorno(PChar(fVP_Transmissao_ID), PChar(VL_String), fVP_ID);

        end;

        if ((F_MensagemComando(VL_Mensagem) = '00D4') and (F_MensagemComandoDados(VL_Mensagem) = 'S')) then                          // MENU DE OPERACAO
        begin

            F_MensagemLimpar(VL_Mensagem);

            F_MensagemAddComando(VL_Mensagem, '00D4', 'R');      //renorno do comando

            F_MensagemAddTag(VL_Mensagem, '004D', PChar('0'));  //comando realizado com sucesso

            F_MensagemAddComando(VL_Mensagem_Dados, '0018', PChar('R'));   //renorno da lista de menu
            F_MensagemAddTag(VL_Mensagem_Dados, '00D3', PChar('Cancela Venda')); //item do menu
            F_MensagemAddTag(VL_Mensagem_Dados, 'FFD3', PChar('Cancela Plano')); //item do menu

            VL_String := F_MensagemTagAsString(VL_Mensagem_Dados);     //converte em string a mensagem

            F_MensagemAddTag(VL_Mensagem, '007D', PChar(VL_String));  // coloca a mensagem na tag de mensagem

            VL_String := F_MensagemTagAsString(VL_Mensagem); //converte em string a mensagem

            fVP_Retorno(PChar(fVP_Transmissao_ID), PChar(VL_String), fVP_ID); // envia de volta o comando

        end;

        if ((F_MensagemComando(VL_Mensagem) = '000A') and (F_MensagemComandoDados(VL_Mensagem) = 'S')) then        // APROVACAO DA TRANSACAO
        begin

            F_MensagemGetTag(VL_Mensagem, '007D', VL_TagDados);
            F_MensagemCarregaTags(VL_Mensagem_Dados, VL_TagDados);

            VL_Pan := '';

            F_MensagemGetTag(VL_Mensagem_Dados, PChar('0060'), VL_TagDados);            // senha criptografada
            F_MensagemGetTag(VL_Mensagem_Dados, PChar('00D9'), VL_Pan);                 // pan
            if VL_TagDados = '' then
            begin
                F_MensagemLimpar(VL_Mensagem_Dados);
                F_MensagemAddComando(VL_Mensagem_Dados, PChar('005A'), PChar('S'));   //solicita senha

                F_MensagemAddTag(VL_Mensagem_Dados, PChar('005B'), PChar(IntToStr(F_Imk())));
                F_MensagemAddTag(VL_Mensagem_Dados, PChar('005C'), PChar(' DIGITE A SENHA'));
                F_MensagemAddTag(VL_Mensagem_Dados, PChar('005D'), PChar('4'));
                F_MensagemAddTag(VL_Mensagem_Dados, PChar('005E'), PChar('8'));
                F_MensagemAddTag(VL_Mensagem_Dados, PChar('005F'), PChar(F_Wk()));
                F_MensagemAddTag(VL_Mensagem_Dados, PChar('0062'), VL_Pan);

                VL_String := F_MensagemTagAsString(VL_Mensagem_Dados);     //converte em string a mensagem
                fVP_Retorno(PChar(fVP_Transmissao_ID), PChar(VL_String), fVP_ID); // envia de volta o comando

            end
            else
            begin

                F_MensagemLimpar(VL_Mensagem);
                F_MensagemGetTag(VL_Mensagem_Dados, PChar('0062'), VL_Pan);                 // pan
                VL_String:=F_DescriptaSenha3Des('',VL_Pan,VL_TagDados);
                F_MensagemAddComando(VL_Mensagem, PChar('002C'), PChar('S'));   //MENSAGEM OPERADOR
                F_MensagemAddTag(VL_Mensagem, '00DA', PChar(VL_String));
                VL_String := F_MensagemTagAsString(VL_Mensagem);
                fVP_Retorno(PChar(fVP_Transmissao_ID), PChar(VL_String), fVP_ID); // envia de volta o comando
            end;

        Exit;
        end;



        F_MensagemLimpar(VL_Mensagem);

        F_MensagemAddComando(VL_Mensagem, '0018', PChar('S'));   //renorno da lista de menu
        F_MensagemAddTag(VL_Mensagem, '00D3', PChar('Cancela Venda')); //item do menu
        F_MensagemAddTag(VL_Mensagem, 'FFD3', PChar('Cancela Plano')); //item do menu

        VL_String := F_MensagemTagAsString(VL_Mensagem);     //converte em string a mensagem

        fVP_Retorno(PChar(fVP_Transmissao_ID), PChar(VL_String), fVP_ID); // envia de volta o comando


    finally
        F_MensagemFree(VL_Mensagem);
        F_MensagemFree(VL_Mensagem_Dados);
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


    FKey := LoadLibrary(PChar(ExtractFilePath(ParamStr(0)) + 'key_lib.dll'));

    Pointer(F_DescriptaSenha3Des) := GetProcAddress(FKey, 'DescriptaSenha3Des');
    Pointer(F_EncriptaSenha3Des) := GetProcAddress(FKey, 'EncriptaSenha3Des');
    Pointer(F_Wk) := GetProcAddress(FKey, 'wkc');
    Pointer(F_Imk) := GetProcAddress(FKey, 'imk');

end;

procedure TForm1.BDesativarClick(Sender: TObject);
begin
    finalizaconexao;
end;

procedure TForm1.BAtivaClick(Sender: TObject);
begin
    iniciarconexao(PChar(ExtractFilePath(ParamStr(0)) + 'operadora.log'), PChar(EChave.Text), PChar(EIPCaixa.Text), PChar(EIPServico.Text),
        EPortaCaixa.AsInteger, EPortaServico.AsInteger, @ServidorRecebimentoCaixa, @ServidorRecebimentoServico);
end;

end.
