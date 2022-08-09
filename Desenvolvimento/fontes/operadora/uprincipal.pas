unit uprincipal;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, rxspin;

type

    { TForm1 }
    TTransacaoStatus = (tsEfetivada, tsNegada, tsCancelada, tsProcessando, tsAguardandoComando, tsNaoLocalizada, tsInicializada, tsComErro, tsAbortada);

    TServidorRecebimentoLib = function(VP_Codigo: integer; VP_Transmissao_ID, VP_DadosRecebidos: PChar; VP_IP: PChar; VP_ID: integer): integer; stdcall;

    Tiniciarconexao = function(VP_ArquivoLog, VP_Chave, VP_IP_Caixa, VP_IP_Servico: PChar; VP_PortaCaixa, VP_PortaServico: integer;
        VO_RetornoCaixa, VO_Retorno_Servico: TServidorRecebimentoLib): integer; stdcall;
    Tfinalizaconexao = function(): integer; stdcall;
    TResponde = function(VP_Transmissao_ID, VP_Mesagem: PChar; VP_ID: integer): integer; stdcall;

    TTMensagemCreate = function(var VO_Mensagem: Pointer): integer; stdcall;
    TTMensagemCarregaTags = function(VP_Mensagem: Pointer; VP_Dados: PChar): integer; stdcall;
    TTMensagemComando = function(VP_Mensagem: Pointer;var VO_Dados:PChar): Integer; stdcall;
    TTMensagemComandoDados = function(VP_Mensagem: Pointer;var VO_Dados:PChar): Integer; stdcall;
    TTMensagemFree = procedure(VP_Mensagem: Pointer); stdcall;
    TTMensagemaddtag = function(VP_Mensagem: Pointer; VP_Tag, VP_Dados: PChar): integer; stdcall;
    TTMensagemaddcomando = function(VP_Mensagem: Pointer; VP_Tag, VP_Dados: PChar): integer; stdcall;
    TTMensagemTagAsString = function(VP_Mensagem: Pointer;var VO_Dados:PChar): integer; stdcall;
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
        Image1: TImage;
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
    VL_Senha: PChar;
    VL_Valor: PChar;
    VL_Comando,VL_ComandoDados:PChar;
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
        F_MensagemCreate(VL_Mensagem);
        F_MensagemCreate(VL_Mensagem_Dados);
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
        VL_Comando:='';
        VL_ComandoDados:='';



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


        F_MensagemComando(VL_Mensagem,VL_Comando);
        F_MensagemComandoDados(VL_Mensagem,VL_ComandoDados);
        if ((VL_Comando = '00CD') and (VL_ComandoDados = 'S')) then                     // atualiza bins
        begin

            F_MensagemLimpar(VL_Mensagem);
            F_MensagemAddComando(VL_Mensagem, '00CD', 'R');
            F_MensagemAddTag(VL_Mensagem, '004D', PChar('0'));
            F_MensagemAddTag(VL_Mensagem, '00CE', PChar('629867'));
            F_MensagemTagAsString(VL_Mensagem,VL_PChar);
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
            F_MensagemTagAsString(VL_Mensagem_Dados,VL_PChar);     //converte em string a mensagem
            F_MensagemAddTag(VL_Mensagem, '007D', VL_PChar);  // coloca a mensagem na tag de mensagem
            F_MensagemTagAsString(VL_Mensagem,VL_PChar); //converte em string a mensagem
            fVP_Retorno(PChar(fVP_Transmissao_ID), VL_PChar, fVP_ID); // envia de volta o comando
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



            if VL_Senha = '' then
                F_MensagemGetTag(VL_Mensagem_Dados, PChar('0060'), VL_Senha);            // senha criptografada
            F_MensagemGetTag(VL_Mensagem_Dados, PChar('004F'), VL_TK2);            // tk2

            F_MensagemGetTag(VL_Mensagem_Dados, PChar('00E9'), VL_Cpf);            // CPF

            F_MensagemGetTag(VL_Mensagem_Dados, PChar('00D9'), VL_Pan);                 // pan nao enviado de proposito

            F_MensagemGetTag(VL_Mensagem_Dados, PChar('0033'), VL_TagDados);            // dados capturados

            F_MensagemGetTag(VL_Mensagem_Dados, PChar('00D5'), VL_PChar);            // BOTAO SELECIONADO

            F_MensagemGetTag(VL_Mensagem_Dados, PChar('0060'), VL_Senha);            // senha criptografada dados capturados

            F_MensagemGetTag(VL_Mensagem_Dados, PChar('00E9'), VL_Cpf);            // cpf criptografado dados capturados

            F_MensagemGetTag(VL_Mensagem_Dados, PChar('0013'), VL_Valor);            // valor dados capturados

            F_MensagemGetTag(VL_Mensagem_Dados, PChar('00E7'), VL_Cartao);            // cartao dados capturados

            if VL_Cartao='' then
            VL_Cartao:=VL_Pan;

            if VL_Valor = '' then
            begin

                F_MensagemLimpar(VL_Mensagem_Dados);
                F_MensagemAddComando(VL_Mensagem_Dados, PChar('00E1'), PChar('S'));   //solicita dados da venda
                F_MensagemAddTag(VL_Mensagem_Dados, PChar('0013'), PChar(''));  // solicita valor total da venda

                F_MensagemTagAsString(VL_Mensagem_Dados,VL_PChar);     //converte em string a mensagem

                F_MensagemAddComando(VL_Mensagem, PChar('00E1'), PChar('S'));   //solicita dados da venda
                F_MensagemAddTag(VL_Mensagem, PChar('00E3'),VL_PChar);

                F_MensagemTagAsString(VL_Mensagem,VL_PChar);     //converte em string a mensagem
                fVP_Retorno(PChar(fVP_Transmissao_ID), VL_PChar, fVP_ID); // envia de volta o comando
                Exit;
            end;

            if (VL_PChar = '00E8') and (string(VL_Senha) = '') then
            begin
                VL_Senha := VL_TagDados;
                if string(VL_Senha) <> '' then
                begin

                    F_MensagemLimpar(VL_Mensagem_Dados);
                    F_MensagemAddComando(VL_Mensagem_Dados, PChar('008C'), PChar('S'));   //solicita atualiza transacao
                    F_MensagemAddTag(VL_Mensagem_Dados, PChar('0060'), PChar(VL_Senha));  // senha cripttografada

                    F_MensagemTagAsString(VL_Mensagem_Dados,VL_PChar);     //converte em string a mensagem

                    F_MensagemAddComando(VL_Mensagem, PChar('008C'), PChar('S'));   //solicita atualiza transacao
                    F_MensagemAddTag(VL_Mensagem, PChar('00E3'), VL_PChar);  // transacao criptografada
                    F_MensagemAddTag(VL_Mensagem, PChar('00D5'), PChar(''));  // botao selecionado

                    F_MensagemTagAsString(VL_Mensagem,VL_PChar);     //converte em string a mensagem
                    fVP_Retorno(PChar(fVP_Transmissao_ID), VL_PChar, fVP_ID); // envia de volta o comando
                    Exit;

                end;

            end;

            if (VL_PChar = '002F') and (string(VL_Cpf) = '') then
            begin

                VL_Cpf := VL_TagDados;

                if string(VL_Cpf) <> '' then
                begin
                    F_MensagemLimpar(VL_Mensagem_Dados);
                    F_MensagemAddComando(VL_Mensagem_Dados, PChar('008C'), PChar('S'));     //solicita atualiza transacao
                    F_MensagemAddTag(VL_Mensagem_Dados, PChar('00E9'), PChar(VL_Cpf));       // cpf criptografado

                    F_MensagemTagAsString(VL_Mensagem_Dados,VL_PChar);     //converte em string a mensagem

                    //F_MensagemLimpar(VL_Mensagem_Dados);
                    F_MensagemAddComando(VL_Mensagem, PChar('008C'), PChar('S')); //solicita atualiza transacao
                    F_MensagemAddTag(VL_Mensagem, PChar('00E3'),VL_PChar);  // transacao criptografada
                    F_MensagemAddTag(VL_Mensagem, PChar('00D5'), PChar(''));      // botao selecionado


                    F_MensagemTagAsString(VL_Mensagem,VL_PChar);     //converte em string a mensagem

                    fVP_Retorno(PChar(fVP_Transmissao_ID), VL_PChar, fVP_ID); // envia de volta o comando
                    Exit;
                end;

                Exit;
            end;

            if VL_Senha = '' then
            begin

                F_MensagemLimpar(VL_Mensagem_Dados);

                // INFORMA OS BOTOES DENTRO DA TAG DE COMANDO DO BOTAO 0018
               {
                F_MensagemAddComando(VL_Mensagem_Dados, '0000', 'S');
                F_MensagemAddTag(VL_Mensagem_Dados, '00E8', PChar('OK'));    //BOTAO OK

                VL_String := F_MensagemTagAsString(VL_Mensagem_Dados);     //converte em string a mensagem

                F_MensagemLimpar(VL_Mensagem_Dados);

                F_MensagemAddComando(VL_Mensagem_Dados, PChar('002A'), PChar('S'));   //solicita dados pdv
                F_MensagemAddTag(VL_Mensagem_Dados, '00DA', PChar('DIGITE A SENHA'));    //MENSAGEM A SER MOSTRADA
                F_MensagemAddTag(VL_Mensagem_Dados, '00DD', PChar(VL_String));    //BOTOES A MOSTRAR
                F_MensagemAddTag(VL_Mensagem_Dados, '0033', PChar('M'));    //campo para capturar sem mascara

                VL_String := F_MensagemTagAsString(VL_Mensagem_Dados);     //converte em string a mensagem

                F_MensagemAddComando(VL_Mensagem, PChar('002A'), PChar('S'));   //solicita dados pdv
                F_MensagemAddTag(VL_Mensagem, PChar('00E3'), PChar(VL_String));
                VL_String := F_MensagemTagAsString(VL_Mensagem);     //converte em string a mensagem

                fVP_Retorno(PChar(fVP_Transmissao_ID), PChar(VL_String), fVP_ID); // envia de volta o comando

                Exit;   }


                F_MensagemAddComando(VL_Mensagem_Dados, PChar('005A'), PChar('S'));   //solicita senha

                F_MensagemAddTag(VL_Mensagem_Dados, PChar('005B'), PChar(IntToStr(F_Imk())));
                F_MensagemAddTag(VL_Mensagem_Dados, PChar('005C'), PChar(' DIGITE A SENHA'));
                F_MensagemAddTag(VL_Mensagem_Dados, PChar('005D'), PChar('4'));
                F_MensagemAddTag(VL_Mensagem_Dados, PChar('005E'), PChar('8'));
                F_MensagemAddTag(VL_Mensagem_Dados, PChar('005F'), PChar(F_Wk()));
                F_MensagemAddTag(VL_Mensagem_Dados, PChar('00D9'), VL_Pan);

                F_MensagemTagAsString(VL_Mensagem_Dados,VL_PChar);     //converte em string a mensagem

                F_MensagemAddComando(VL_Mensagem, PChar('005A'), PChar('S')); //solicita atualiza transacao
                F_MensagemAddTag(VL_Mensagem, PChar('00E3'), VL_PChar);  // transacao criptografada

                VL_String:='';

                F_MensagemTagAsString(VL_Mensagem,VL_PChar);     //converte em string a mensagem

                VL_String:=VL_PChar;

                fVP_Retorno(PChar(fVP_Transmissao_ID), VL_PChar, fVP_ID); // envia de volta o comando
                Exit;
            end;

            if VL_Cpf = '' then         // exemplo de captura de dados   CPF
            begin
                F_MensagemLimpar(VL_Mensagem_Dados);

                // INFORMA OS BOTOES DENTRO DA TAG DE COMANDO DO BOTAO 0018

                F_MensagemAddComando(VL_Mensagem_Dados, '0000', 'S');
                F_MensagemAddTag(VL_Mensagem_Dados, '002F', PChar('OK'));    //BOTAO OK

                F_MensagemTagAsString(VL_Mensagem_Dados,VL_PChar);     //converte em string a mensagem

                F_MensagemLimpar(VL_Mensagem_Dados);

                F_MensagemAddComando(VL_Mensagem_Dados, PChar('002A'), PChar('S'));   //solicita dados pdv
                F_MensagemAddTag(VL_Mensagem_Dados, '00DA', PChar('INFORME O CPF'));    //MENSAGEM A SER MOSTRADA
                F_MensagemAddTag(VL_Mensagem_Dados, '00DD', VL_PChar);    //BOTOES A MOSTRAR
                F_MensagemAddTag(VL_Mensagem_Dados, '0033', PChar('A'));    //campo para capturar sem mascara

                ImagemToStr(VL_String, Form1.Image1);

                //GravaLog('c:\temp\imagem.txt',0,'','','','',VL_String,0);

                F_MensagemAddTag(VL_Mensagem_Dados, '002E', PChar(VL_String));    //campo enviar imagem


                F_MensagemTagAsString(VL_Mensagem_Dados,VL_PChar);     //converte em string a mensagem

                F_MensagemAddComando(VL_Mensagem, PChar('002A'), PChar('S'));   //solicita dados pdv
                F_MensagemAddTag(VL_Mensagem, PChar('00E3'), VL_PChar);
                F_MensagemTagAsString(VL_Mensagem,VL_PChar);     //converte em string a mensagem


                fVP_Retorno(PChar(fVP_Transmissao_ID), VL_PChar, fVP_ID); // envia de volta o comando

            end

            else
            begin
                //              F_MensagemLimpar(VL_Mensagem_Dados);
                VL_String := 'Cartão:' + VL_Cartao + #13 + 'Senha do cartão:' + F_DescriptaSenha3Des('', VL_Pan, VL_Senha) + #13 +
                    'CPF:' + VL_Cpf + #13 + 'Valor dos itens:' + VL_Valor;
                F_MensagemAddComando(VL_Mensagem_Dados, PChar('002C'), PChar('S'));   //MENSAGEM OPERADOR
                F_MensagemAddTag(VL_Mensagem_Dados, '00DA', PChar(VL_String));  // mensagem no pdv
                F_MensagemAddTag(VL_Mensagem_Dados, '004A', PChar(IntToStr(Ord(tsAbortada))));  // transacao obortada
                F_MensagemTagAsString(VL_Mensagem_Dados,VL_PChar);
                fVP_Retorno(PChar(fVP_Transmissao_ID), VL_PChar, fVP_ID); // envia de volta o comando

            end;
            Exit;
        end;



        F_MensagemLimpar(VL_Mensagem);

        F_MensagemAddTag(VL_Mensagem, '00E3', PChar('')); //dados protegidos
        F_MensagemAddComando(VL_Mensagem, '0018', PChar('S'));   //renorno da lista de menu
        F_MensagemAddTag(VL_Mensagem, '00D3', PChar('Cancela Venda')); //item do menu
        F_MensagemAddTag(VL_Mensagem, 'FFD3', PChar('Cancela Plano')); //item do menu

        F_MensagemTagAsString(VL_Mensagem,VL_PChar);     //converte em string a mensagem

        fVP_Retorno(PChar(fVP_Transmissao_ID), VL_PChar, fVP_ID); // envia de volta o comando


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
