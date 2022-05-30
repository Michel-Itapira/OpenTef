unit tef;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils, comunicador, funcoes, def;

{ TDTef }
type

    TSolicitaDadosPDV = function(VP_Menu: PChar; var VO_Botao, VO_Dados: PChar): integer; stdcall;
    TSolicitaDadosTransacao = function(VP_Mensagem: PChar; var  VO_Dados: PChar): integer; stdcall;
    TImprime = function(VP_Dados: PChar): integer; stdcall;
    TMostraMenu = function(VP_Dados: PChar; var VO_Selecionado: PChar): integer; stdcall;
    TMensagemOperador = function(VP_Dados: PChar): integer; stdcall;

    TPinPadDescarrega = function(): integer; stdcall;
    TPinPadCarrega = function(VP_PinPadModelo: TPinPadModelo; VP_PinPadModeloLib, VP_PinPadModeloPorta: PChar;
        VP_RespostaPinPad: TRespostaPinPad): integer; stdcall;
    TPinPadConectar = function(var VO_Mensagem: PChar): integer; stdcall;
    TPinPadDesconectar = function(VL_Mensagem: PChar): integer; stdcall;
    TPinPadComando = function(VP_Processo_ID: integer; VP_Mensagem: PChar; var VO_Mensagem: PChar; VP_RespostaPinPad: TRespostaPinPad): integer; stdcall;

    TThProcesso = class(TThread)
    private
        fdados: ansistring;
        fprocedimento: TRetorno;
        ftempo: integer;
        ftransmissaoID: string;
    protected
        procedure Execute; override;
    public
        constructor Create(VP_Suspenso: boolean; VP_Transmissao_ID, VP_Dados: string; VP_Procedimento: TRetorno; VP_TempoAguarda: integer);

    end;

    { ThTransacao }

    TThTransacao = class(TThread)
    private
        ftransacao: TTransacao;
        ftempo: integer;
        fID: integer;
        ftransmissaoID: string;
    protected
        procedure Execute; override;
    public
        constructor Create(VP_Suspenso: boolean; VP_Transmissao_ID: string; VP_Transacao: TTransacao; VP_TempoAguarda: integer);

    end;



    TDTef = class(TDataModule)
    private

    end;

function inicializar(VP_PinPadModelo: integer; VP_PinPadModeloLib, VP_PinPadModeloPorta, VP_PinPadLib, VP_ArquivoLog: PChar;
    VP_Procedimento: TRetorno;VP_SolicitaDadosTransacao: TSolicitaDadosTransacao; VP_SolicitaDadosPDV: TSolicitaDadosPDV; VP_Imprime: TImprime; VP_MostraMenu: TMostraMenu;
    VP_MensagemOperador: TMensagemOperador): integer; stdcall;
function finalizar(): integer; stdcall;
function login(VP_Host: PChar; VP_Porta: integer; VP_ChaveTerminal: PChar; VP_Versao_Comunicacao: integer): integer; stdcall;
function solicitacao(VP_Transmissao_ID, VP_Dados: PChar; VP_Procedimento: TRetorno; VP_TempoAguarda: integer): integer; stdcall;
function solicitacaoblocante(var VO_Transmissao_ID, VP_Dados: PChar; var VO_Retorno: PChar; VP_TempoAguarda: integer): integer; stdcall;
function opentefstatus(var VO_StatusRetorno: integer): integer; stdcall;
function transacaocreate(VP_IdentificadorCaixa: PChar; var VO_TransacaoID: PChar; VP_TempoAguarda: integer): integer; stdcall;
function transacaostatus(var VO_Status: integer; VP_TransacaoID: PChar): integer; stdcall;
function transacaocancela(var VO_Resposta: integer; VP_TransacaoID: PChar): integer; stdcall;
procedure transacaofree(VP_TransacaoID: PChar); stdcall;

procedure RespostaPinPad(VP_Processo_ID: integer; VP_Mensagem: TMensagem);


var
    DTef: TDTef;
    V_Inicializado: boolean = False;
    F_ChaveTerminal: ansistring;
    F_Versao_Comunicacao: integer;
    F_DComunicador: TDComunicador;
    F_ListaTransacao: TList;
    F_SolicitaDadosPDV: TSolicitaDadosPDV;
    F_SolicitaDadosTransacao: TSolicitaDadosTransacao;
    F_Imprime: TImprime;
    F_MostraMenu: TMostraMenu;
    F_MensagemOperador: TMensagemOperador;


    F_PinPadModelo: TPinPadModelo;
    F_PinPadLib, F_PinPadModeloLib, F_PinPadModeloPorta: string;

    F_PinPadCarrega: TPinPadCarrega;
    F_PinPadDescarrega: TPinPadDescarrega;
    F_PinPadConectar: TPinPadConectar;
    F_PinPadDesconectar: TPinPadDesconectar;
    F_PinPadComando: TPinPadComando;


    F_ArquivoLog: string;
    F_Processo_ID: integer;

    F_PinPad: THandle;



implementation

{$R *.lfm}


procedure RespostaPinPad(VP_Processo_ID: integer; VP_Mensagem: TMensagem);
begin

end;


{ ThTransacao }

procedure TThTransacao.Execute;
var
    VL_Dados: PChar;
    VL_Botao: PChar;
    VL_Erro: integer;
    VL_I: integer;
    VL_Mensagem: TMensagem;
    VL_Tag, VL_TagDados: string;
begin
    try
        VL_Dados := '';
        VL_Botao := '';
        VL_Tag := '';
        VL_TagDados := '';
        VL_Mensagem := TMensagem.Create;
        VL_Erro := 0;
     {
     1º recebe uma transacao tag 007A
     solicitar o menu no open tef
     havendo erro suspende
     mostrar o menu no pdv e para

     2º recebe tag
      }


        ftransacao.STATUS := tsProcessando;
        while not Terminated do
        begin
            if VL_Erro <> 0 then
            begin
                ftransacao.erro := VL_Erro;
                ftransacao.STATUS := tsComErro;
                Exit;
            end;

            VL_Erro := VL_Mensagem.GetTagAsInteger('004D'); // TESTA SE VEIO ERRO

            if VL_Erro <> 0 then
            begin
                ftransacao.erro := VL_Erro;
                ftransacao.STATUS := tsComErro;
                Exit;
            end;

            if (VL_Mensagem.Comando() = '0018') then  // SOLICITACAO DE CAPTURA OPÇÃO DO MENU
            begin
                VL_Erro := F_MostraMenu(PChar(VL_Mensagem.TagsAsString), VL_Botao);
                if VL_Erro <> 0 then
                begin
                    ftransacao.erro := VL_Erro;
                    ftransacao.STATUS := tsComErro;
                    Exit;
                end;
                if ((VL_Botao = '0030') or (VL_Botao = '')) then  // botao cancela
                begin
                    ftransacao.STATUS := tsCancelada;
                    exit;
                end
                else
                begin
                    ftransacao.fMensagem.AddTag('00D5', VL_Botao);
                    VL_Mensagem.AddComando('000A', 'S');
                    VL_Mensagem.AddTag('007D', ftransacao.fMensagem.TagsAsString);
                    VL_Erro := F_DComunicador.ClienteTransmiteSolicitacao(ftransmissaoID, VL_Mensagem, VL_Mensagem, nil, ftempo, True);

                    if VL_Erro <> 0 then
                    begin
                        ftransacao.erro := VL_Erro;
                        ftransacao.STATUS := tsComErro;
                        Exit;
                    end;

                end;

            end
            else
            if (VL_Mensagem.Comando() = '002A') then  // SOLICITACAO DE CAPTURA DE DADOS NO PDV
            begin
                VL_Erro := F_SolicitaDadosPDV(PChar(VL_Mensagem.TagsAsString), VL_Botao, VL_Dados);
                VL_Mensagem.Limpar;
                if VL_Erro <> 0 then
                begin
                    ftransacao.erro := VL_Erro;
                    ftransacao.STATUS := tsComErro;
                    Exit;
                end;
                if (VL_Botao = '0030') then  // botao cancela
                begin
                    ftransacao.STATUS := tsCancelada;
                    exit;
                end
                else
                    ftransacao.fMensagem.AddTag('0033', VL_Dados);
            end
            else
            if (VL_Mensagem.Comando() = '00E1') then  // SOLICITACAO DE DADOS DA VENDA
            begin
                VL_Erro := F_SolicitaDadosTransacao(PChar(VL_Mensagem.TagsAsString),VL_Dados);
                VL_Mensagem.Limpar;
                if VL_Erro <> 0 then
                begin
                    ftransacao.erro := VL_Erro;
                    ftransacao.STATUS := tsComErro;
                    Exit;
                end;
                VL_Erro:=VL_Mensagem.CarregaTags(VL_Dados);
                if VL_Erro <> 0 then
                begin
                    ftransacao.erro := VL_Erro;
                    ftransacao.STATUS := tsComErro;
                    Exit;
                end;
                for VL_I:=1 to VL_Mensagem.TagCount do
                begin
                    VL_Mensagem.GetTag(VL_I,VL_Tag,VL_TagDados);
                    ftransacao.fMensagem.AddTag(VL_Tag,VL_TagDados);
                end;
            end
            else
            if (VL_Mensagem.Comando() = '0048') then  // SOLICITACAO DE CAPTURA DO CARTÃO
            begin
                try
                    VL_Erro := F_PinPadCarrega(F_PinPadModelo, PChar(F_PinPadModeloLib), PChar(F_PinPadModeloPorta), @RespostaPinPad);
                    if VL_Erro <> 0 then
                    begin
                        ftransacao.erro := VL_Erro;
                        ftransacao.STATUS := tsComErro;
                        Exit;
                    end;
                    VL_Erro := F_PinPadConectar(VL_Dados);
                    if VL_Erro <> 0 then
                    begin
                        ftransacao.erro := VL_Erro;
                        ftransacao.STATUS := tsComErro;
                        VL_Mensagem.CarregaTags(VL_Dados);
                        ftransacao.erroDescricao := VL_Mensagem.GetTagAsAstring('004A');
                        Exit;
                    end;
                    VL_Erro := F_PinPadComando(-1, PChar(VL_Mensagem.TagsAsString), VL_Dados, nil);
                    if VL_Erro <> 0 then
                    begin
                        ftransacao.erro := VL_Erro;
                        ftransacao.STATUS := tsComErro;
                        VL_Mensagem.CarregaTags(VL_Dados);
                        ftransacao.erroDescricao := VL_Mensagem.GetTagAsAstring('004A');
                        Exit;
                    end;
                    VL_Erro := VL_Mensagem.CarregaTags(VL_Dados);
                    if VL_Erro <> 0 then
                    begin
                        ftransacao.erro := VL_Erro;
                        ftransacao.STATUS := tsComErro;
                        Exit;
                    end;

                finally
                    F_PinPadDesconectar('    OpenTef    ');
                    F_PinPadDescarrega;

                end;
                ftransacao.fMensagem.AddTag('004D', 0);
                ftransacao.fMensagem.AddTag('0046', VL_Mensagem.GetTagAsAstring('0046'));
                ftransacao.fMensagem.AddTag('004E', VL_Mensagem.GetTagAsAstring('004E'));
                ftransacao.fMensagem.AddTag('004F', VL_Mensagem.GetTagAsAstring('004F'));
                ftransacao.fMensagem.AddTag('0050', VL_Mensagem.GetTagAsAstring('0050'));

                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('000A', 'S');
                VL_Mensagem.AddTag('007D', ftransacao.fMensagem.TagsAsString);
                VL_Erro := F_DComunicador.ClienteTransmiteSolicitacao(ftransmissaoID, VL_Mensagem, VL_Mensagem, nil, ftempo, True);
                if VL_Erro <> 0 then
                begin
                    ftransacao.erro := VL_Erro;
                    ftransacao.STATUS := tsComErro;
                    Exit;
                end;

            end
            else
            if (VL_Mensagem.Comando() = '005A') then  // SOLICITACAO DE CAPTURA DE SENHA
            begin
                try
                    VL_Erro := F_PinPadCarrega(F_PinPadModelo, PChar(F_PinPadModeloLib), PChar(F_PinPadModeloPorta), @RespostaPinPad);
                    if VL_Erro <> 0 then
                    begin
                        ftransacao.erro := VL_Erro;
                        ftransacao.STATUS := tsComErro;
                        Exit;
                    end;
                    VL_Erro := F_PinPadConectar(VL_Dados);
                    if VL_Erro <> 0 then
                    begin
                        ftransacao.erro := VL_Erro;
                        ftransacao.STATUS := tsComErro;
                        VL_Mensagem.CarregaTags(VL_Dados);
                        ftransacao.erroDescricao := VL_Mensagem.GetTagAsAstring('004A');
                        Exit;
                    end;
                    VL_Erro := F_PinPadComando(-1, PChar(VL_Mensagem.TagsAsString), VL_Dados, nil);
                    if VL_Erro <> 0 then
                    begin
                        ftransacao.erro := VL_Erro;
                        ftransacao.STATUS := tsComErro;
                        VL_Mensagem.CarregaTags(VL_Dados);
                        ftransacao.erroDescricao := VL_Mensagem.GetTagAsAstring('004A');
                        Exit;
                    end;
                    VL_Erro := VL_Mensagem.CarregaTags(VL_Dados);
                    if VL_Erro <> 0 then
                    begin
                        ftransacao.erro := VL_Erro;
                        ftransacao.STATUS := tsComErro;
                        Exit;
                    end;

                finally
                    F_PinPadDesconectar('    OpenTef    ');
                    F_PinPadDescarrega;

                end;
                ftransacao.fMensagem.AddTag('004D', 0);
                ftransacao.fMensagem.AddTag('0060', VL_Mensagem.GetTagAsAstring('0060'));

                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('000A', 'S');
                VL_Mensagem.AddTag('007D', ftransacao.fMensagem.TagsAsString);
                VL_Erro := F_DComunicador.ClienteTransmiteSolicitacao(ftransmissaoID, VL_Mensagem, VL_Mensagem, nil, ftempo, True);
                if VL_Erro <> 0 then
                begin
                    ftransacao.erro := VL_Erro;
                    ftransacao.STATUS := tsComErro;
                    Exit;
                end;

            end
            else
            if (VL_Mensagem.Comando() = '008C') then  // SOLICITACAO ATUALIZAÇÃO DE TAGS
            begin
                for VL_I := 1 to VL_Mensagem.TagCount do
                begin
                    VL_Erro := VL_Mensagem.GetTag(VL_I, VL_Tag, VL_TagDados);
                    if VL_Erro <> 0 then
                    begin
                        ftransacao.erro := VL_Erro;
                        ftransacao.STATUS := tsComErro;
                        Exit;
                    end;
                    ftransacao.fMensagem.AddTag(VL_Tag, VL_TagDados);
                end;
                VL_Mensagem.Limpar;
            end
            else
            if (VL_Mensagem.Comando() = '002C') then  // mensagem ao operador
            begin
                ftransacao.STATUS:=IntToTransacaoStatus(VL_Mensagem.GetTagAsInteger('004A'));
                F_MensagemOperador(PChar(VL_Mensagem.GetTagAsAstring('00DA')));

                if(ftransacao.STATUS<>tsProcessando) and (ftransacao.STATUS<>tsAguardandoComando) then
                Exit;
            end
            else

            begin
                VL_Mensagem.AddComando('000A', 'S');
                VL_Mensagem.AddTag('007D', ftransacao.fMensagem.TagsAsString);
                VL_Erro := F_DComunicador.ClienteTransmiteSolicitacao(ftransmissaoID, VL_Mensagem, VL_Mensagem, nil, ftempo, True);
                if VL_Erro <> 0 then
                begin
                    ftransacao.erro := VL_Erro;
                    ftransacao.STATUS := tsComErro;
                    Exit;
                end;

            end;

        end;

    finally
        VL_Mensagem.Free;
    end;

end;

constructor TThTransacao.Create(VP_Suspenso: boolean; VP_Transmissao_ID: string; VP_Transacao: TTransacao; VP_TempoAguarda: integer);
begin
    fID := F_Processo_ID;
    F_Processo_ID := F_Processo_ID + 1;
    ftempo := VP_TempoAguarda;
    ftransacao := VP_Transacao;
    FreeOnTerminate := True;
    ftransmissaoID := VP_Transmissao_ID;
    inherited Create(VP_Suspenso);
end;

{ TDTef }


constructor TThProcesso.Create(VP_Suspenso: boolean; VP_Transmissao_ID, VP_Dados: string; VP_Procedimento: TRetorno; VP_TempoAguarda: integer);

begin
    FreeOnTerminate := True;
    fdados := VP_Dados;
    fprocedimento := VP_Procedimento;
    ftempo := VP_TempoAguarda;
    ftransmissaoID := VP_Transmissao_ID;
    inherited Create(VP_Suspenso);

end;

procedure TThProcesso.Execute;
var
    VL_Mensagem: TMensagem;
    VL_Erro: integer;
begin
    VL_Mensagem := TMensagem.Create;
    try
        VL_Mensagem.CarregaTags(fdados);
        VL_Erro := F_DComunicador.ClienteTransmiteSolicitacao(ftransmissaoID, VL_Mensagem, VL_Mensagem, nil, ftempo, True);
        fprocedimento(PChar(ftransmissaoID), 0, VL_Erro, PChar(VL_Mensagem.TagsAsString));
    finally
        VL_Mensagem.Free;
    end;
end;

function inicializar(VP_PinPadModelo: integer; VP_PinPadModeloLib, VP_PinPadModeloPorta, VP_PinPadLib, VP_ArquivoLog: PChar;
    VP_Procedimento: TRetorno;VP_SolicitaDadosTransacao: TSolicitaDadosTransacao; VP_SolicitaDadosPDV: TSolicitaDadosPDV; VP_Imprime: TImprime; VP_MostraMenu: TMostraMenu;
    VP_MensagemOperador: TMensagemOperador): integer; stdcall;
begin

    if not Assigned(F_DComunicador) then
        F_DComunicador := TDComunicador.Create(nil);

    F_DComunicador.V_ConexaoCliente := TTConexao.Create(@F_DComunicador);
    F_DComunicador.V_ThRecebeEscuta := TThRecebe.Create(True, @F_DComunicador, VP_ArquivoLog);
    F_DComunicador.V_ThRecebeEscuta.Start;

    F_DComunicador.V_ClienteRecebimento := VP_Procedimento;
    F_ListaTransacao := TList.Create;
    F_SolicitaDadosPDV := VP_SolicitaDadosPDV;
    F_SolicitaDadosTransacao := VP_SolicitaDadosTransacao;
    F_Imprime := VP_Imprime;
    F_MostraMenu := VP_MostraMenu;
    F_MensagemOperador := VP_MensagemOperador;
    F_ArquivoLog := VP_ArquivoLog;
    F_Processo_ID := 0;

    F_PinPadLib := VP_PinPadLib;
    F_PinPadModeloLib := VP_PinPadModeloLib;
    F_PinPadModelo := IntToPinPadModelo(VP_PinPadModelo);
    F_PinPadModeloPorta := VP_PinPadModeloPorta;


    if F_PinPadModelo <> pNDF then
    begin
        F_PinPad := LoadLibrary(PChar(F_PinPadLib));

        if F_PinPad = 0 then
        begin
            Result := 77;
            Exit;
        end;

        Pointer(F_PinPadCarrega) := GetProcAddress(F_PinPad, 'pinpadcarrega');
        Pointer(F_PinPadDescarrega) := GetProcAddress(F_PinPad, 'pinpaddescarrega');
        Pointer(F_PinPadConectar) := GetProcAddress(F_PinPad, 'pinpadconectar');
        Pointer(F_PinPadDesconectar) := GetProcAddress(F_PinPad, 'pinpaddesconectar');
        Pointer(F_PinPadComando) := GetProcAddress(F_PinPad, 'pinpadcomando');

        Result := 0;
        // Result := F_PinPadCarrega(F_PinPadModelo,Pchar(F_PinPadModeloLib), PChar(F_PinPadModeloPorta), nil);
        // F_PinPadDescarrega;
    end
    else
        Result := 0;

end;

function finalizar(): integer; stdcall;
begin
    if Assigned(F_DComunicador.V_ThRecebeEscuta) then
    begin
        F_DComunicador.V_ConexaoCliente.ConexaoAtivadada := False;
        F_DComunicador.V_ThRecebeEscuta.Parar;
        F_DComunicador.V_ThRecebeEscuta.Terminate;
    end;
    F_ListaTransacao.Free;
    F_DComunicador.Free;

    if F_PinPadModelo <> pNDF then
    begin
        F_PinPadDesconectar('    OpenTef    ');
        F_PinPadDescarrega;
        UnloadLibrary(F_PinPad);
    end;

    Result := 0;
end;

function login(VP_Host: PChar; VP_Porta: integer; VP_ChaveTerminal: PChar; VP_Versao_Comunicacao: integer): integer; stdcall;
var
    VL_Mensagem: TMensagem;
    VL_S, VL_Dados: ansistring;
    VL_DadosI: int64;
    VL_Transmissao_ID: string;
begin
    VL_S := '';
    VL_Dados := '';
    VL_Transmissao_ID := '';
    VL_Mensagem := TMensagem.Create;
    try

        if Length(VP_host) = 0 then
        begin
            Result := 9;
            exit;
        end;
        if VP_Porta < 1 then
        begin
            Result := 11;
            exit;
        end;
        if VP_Versao_Comunicacao < 1 then
        begin
            Result := 13;
            exit;
        end;
        if length(VP_ChaveTerminal) = 0 then
        begin
            Result := 15;
            exit;
        end;
        if ((F_DComunicador.V_ConexaoCliente.ServidorHost <> VP_Host) or
            (F_DComunicador.V_ConexaoCliente.ServidorPorta <> VP_Porta) or
            (F_ChaveTerminal <> VP_ChaveTerminal) or
            (F_Versao_Comunicacao <> VP_Versao_Comunicacao)) then
        begin
            F_DComunicador.DesconectarCliente;
            F_DComunicador.V_ConexaoCliente.ServidorHost := VP_Host;
            F_DComunicador.V_ConexaoCliente.ServidorPorta := VP_Porta;
            F_ChaveTerminal := VP_ChaveTerminal;
            F_Versao_Comunicacao := VP_Versao_Comunicacao;
        end;

        F_DComunicador.V_ConexaoCliente.ConexaoAtivadada := True;
        Result := F_DComunicador.ConectarCliente;

        if Result <> 0 then
            Exit;

        if F_DComunicador.V_ConexaoCliente.Status = csLogado then
        begin
            Result := 0;
            Exit;
        end;

        if F_DComunicador.V_ConexaoCliente.Status = csChaveado then
        begin
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('0001', '');
            VL_Mensagem.AddTag('0002', VP_ChaveTerminal);
            VL_Mensagem.AddTag('0005', IntToStr(C_versao[0]) + '.' + IntToStr(C_versao[1]) + '.' + IntToStr(C_versao[2]));
            VL_Mensagem.AddTag('0006', IntToStr(C_mensagem));
            VL_Mensagem.AddTag('0037', 'S');

            Result := F_DComunicador.ClienteTransmiteSolicitacao(VL_Transmissao_ID, VL_Mensagem, VL_Mensagem, nil, 10000, True);
            if Result <> 0 then
                Exit;
            VL_Mensagem.GetComando(VL_S, VL_Dados);
            VL_S := VL_Mensagem.Comando;
            if VL_S = '0028' then
                F_DComunicador.V_ConexaoCliente.Status := csLogado
            else
            if VL_S = '0029' then
            begin
                VL_DadosI := 0;
                VL_Mensagem.GetTag('0036', VL_DadosI);
                Result := VL_DadosI;
            end
            else
                Result := 34;

        end;

    finally
        VL_Mensagem.Free;
    end;

end;

function solicitacao(VP_Transmissao_ID, VP_Dados: PChar; VP_Procedimento: TRetorno; VP_TempoAguarda: integer): integer; stdcall;
var
    VL_Th: TThProcesso;
begin
    Result := 0;
    VL_Th := TThProcesso.Create(True, VP_Transmissao_ID, VP_Dados, VP_Procedimento, VP_TempoAguarda);
    VL_Th.Start;

end;

function solicitacaoblocante(var VO_Transmissao_ID, VP_Dados: PChar; var VO_Retorno: PChar; VP_TempoAguarda: integer): integer; stdcall;
var
    VL_Transmissao_ID, VL_String: ansistring;
    VL_MensagensOUT, VL_MensagensIN: TMensagem;
begin
    VL_String := '';
    VL_Transmissao_ID := VO_Transmissao_ID;
    try
        VL_MensagensOUT := TMensagem.Create;
        VL_MensagensOUT.CarregaTags(VP_Dados);
        VL_MensagensIN := TMensagem.Create;
        Result := F_DComunicador.ClienteTransmiteSolicitacao(VL_Transmissao_ID, VL_MensagensOUT, VL_MensagensIN, nil, VP_TempoAguarda, True);

        VO_Transmissao_ID := StrAlloc(Length(VL_Transmissao_ID) + 1);
        StrPCopy(VO_Transmissao_ID, VL_Transmissao_ID);


        VL_MensagensIN.TagToStr(VL_String);

        VO_Retorno := StrAlloc(Length(VL_String) + 1);
        StrPCopy(VO_Retorno, VL_String);

    finally
        VL_MensagensIN.Free;
        VL_MensagensOUT.Free;
    end;

end;

function opentefstatus(var VO_StatusRetorno: integer): integer; stdcall;
begin
    Result := 0;
    VO_StatusRetorno := Ord(F_DComunicador.V_ConexaoCliente.Status);
    if not F_DComunicador.V_ConexaoCliente.ConexaoAtivadada then
        VO_StatusRetorno := Ord(csNaoInicializado);
end;

function transacaocreate(VP_IdentificadorCaixa: PChar; var VO_TransacaoID: PChar; VP_TempoAguarda: integer): integer; stdcall;
var
    VL_Transacao: TTransacao;
    VL_Mensagem: TMensagem;
    VL_ThTransacao: TThTransacao;
    VL_Transmissao_ID: string;
begin
    Result := 0;
    VL_Transmissao_ID := '';
    try
        try
            VL_Mensagem := TMensagem.Create;
            VL_Mensagem.AddComando('007A', 'S');
            VL_Mensagem.AddTag('00A6', VP_IdentificadorCaixa);
            Result := F_DComunicador.ClienteTransmiteSolicitacao(VL_Transmissao_ID, VL_Mensagem, VL_Mensagem, nil, 10000, True);

            if Result <> 0 then
                Exit;

            if (VL_Mensagem.Comando() = '007A') and (VL_Mensagem.ComandoDados() = 'R') then
            begin
                VL_Transacao := TTransacao.Create('', 0, VL_Mensagem.TagsAsString);
                VO_TransacaoID := StrAlloc(Length(VL_Transacao.ID) + 1);
                StrPCopy(VO_TransacaoID, VL_Transacao.ID);
                VL_Transacao.fMensagem.AddComando('0042', '');
                VL_Transacao.fMensagem.AddTag('007D', VL_Mensagem.TagsAsString);
                VL_ThTransacao := TThTransacao.Create(True, VO_TransacaoID, VL_Transacao, VP_TempoAguarda);
                F_ListaTransacao.Add(VL_Transacao);
                VL_ThTransacao.Start;
            end
            else
                Result := 61;
        except
            on e: EInOutError do
            begin
                Result := 58;
                GravaLog(F_ArquivoLog, 0, '', 'tef_lib', '140520221140', 'Erro na transacaocreate ' + e.ClassName + '/' + e.Message, '', 58);
            end;

        end;

    finally
        VL_Mensagem.Free;
    end;
end;

function transacaostatus(var VO_Status: integer; VP_TransacaoID: PChar): integer; stdcall;
var
    VL_Transacao: TTransacao;
    VL_I: integer;
begin
    Result := 0;
    VO_Status := Ord(tsNaoLocalizada);
    try
        for VL_I := 0 to F_ListaTransacao.Count - 1 do
        begin
            Pointer(VL_Transacao) := F_ListaTransacao.Items[VL_I];
            if VL_Transacao.ID = VP_TransacaoID then
            begin
                Result := VL_Transacao.Erro;
                VO_Status := Ord(VL_Transacao.Status);
                Exit;
            end;
        end;
    except
        on e: EInOutError do
        begin
            Result := 59;
            GravaLog(F_ArquivoLog, 0, '', 'tef_lib', '140520221200', 'Erro na transacaostatus ' + e.ClassName + '/' + e.Message, '', 59);
        end;
    end;

end;

function transacaocancela(var VO_Resposta: integer; VP_TransacaoID: PChar): integer; stdcall;
begin

end;

procedure transacaofree(VP_TransacaoID: PChar); stdcall;
var
    VL_I: integer;
    VL_Transacao: TTransacao;
begin
    try
        for VL_I := 0 to F_ListaTransacao.Count - 1 do
        begin
            Pointer(VL_Transacao) := F_ListaTransacao.Items[VL_I];
            if VL_Transacao.ID = VP_TransacaoID then
            begin
                F_ListaTransacao.Remove(VL_Transacao);
                VL_Transacao.Free;
                Exit;
            end;
        end;
    except
        on e: EInOutError do
        begin
            GravaLog(F_ArquivoLog, 0, '', 'tef_lib', '140520221225', 'Erro na transacaofree ' + e.ClassName + '/' + e.Message, '', 60);
        end;
    end;

end;



end.
