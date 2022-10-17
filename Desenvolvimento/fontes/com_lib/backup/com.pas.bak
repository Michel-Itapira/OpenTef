unit com;

{$mode ObjFPC}{$H+}

interface

uses
    Classes,
    SysUtils,
    comunicador,
    funcoes, LbClass;

{ TDCom }
type

    ThProcesso = class(TThread)
    private
        fdados: ansistring;
        fprocedimento: TRetorno;
        ftempo: integer;
        ftransmissaoID: string;
    protected
        procedure Execute; override;
    public
        constructor Create(VP_Suspenso: boolean; VP_Transmissao_ID, VP_Dados: ansistring; VP_Procedimento: TRetorno; VP_TempoAguarda: integer);

    end;



    TDCom = class(TDataModule)
      CriptoAes: TLbRijndael;

    private

    end;

function inicializar(VP_Procedimento: TRetorno; VP_ArquivoLog: PChar): integer; cdecl;
function finalizar(): integer; cdecl;
function desconectar(): integer; cdecl;
function login(VP_Host: PChar; VP_Porta: integer; VP_ChaveTerminal: PChar; VP_Versao_Comunicacao: integer; VP_Senha: PChar;
    VP_Tipo: PChar; VP_Terminal_ID: integer): integer; cdecl;
function solicitacao(VP_Dados: PChar; VP_Procedimento: TRetorno; VP_TempoAguarda: integer): integer; cdecl;
function solicitacaoblocante(VP_Dados: PChar; var VO_Retorno: PChar; VP_TempoAguarda: integer): integer; cdecl;
function opentefstatus(var VO_StatusRetorno: integer): integer; cdecl;

var
    DCom: TDCom;
    V_Inicializado: boolean = False;
    F_ChaveTerminal: ansistring;
    F_Versao_Comunicacao: integer;
    DComunicador: TDComunicador;


const
    C_lib_versao: array  [0..2] of integer = (1, 0, 0);

implementation

{$R *.lfm}

{ TDCom }


{ TDCom }


constructor ThProcesso.Create(VP_Suspenso: boolean; VP_Transmissao_ID, VP_Dados: ansistring; VP_Procedimento: TRetorno; VP_TempoAguarda: integer);

begin
    FreeOnTerminate := True;
    fdados := VP_Dados;
    ftempo := VP_TempoAguarda;
    fprocedimento := VP_Procedimento;
    ftransmissaoID := VP_Transmissao_ID;
    inherited Create(VP_Suspenso);

end;

procedure ThProcesso.Execute;
var
    VL_Mensagem: TMensagem;
    VL_Erro: integer;
begin
    VL_Mensagem := TMensagem.Create;
    try
        VL_Mensagem.CarregaTags(fdados);
        VL_Erro := DComunicador.ClienteTransmiteSolicitacao(DComunicador, ftransmissaoID, VL_Mensagem, VL_Mensagem, nil, ftempo, True);
        fprocedimento(PChar(ftransmissaoID), 0, VL_Erro, PChar(VL_Mensagem.TagsAsString));
    finally
        VL_Mensagem.Free;
    end;
end;

function inicializar(VP_Procedimento: TRetorno; VP_ArquivoLog: PChar): integer; cdecl;
begin

    DCom := TDCom.Create(nil);

    if not Assigned(DComunicador) then
        DComunicador := TDComunicador.Create(nil);

    DComunicador.V_ClienteRecebimento := VP_Procedimento;

    Result := 0;

end;

function finalizar(): integer; cdecl;
begin

    DComunicador.Free;
    DCom.Free;

    Result := 0;
end;

function desconectar: integer; cdecl;
begin
    Result := 0;
    DComunicador.desativartodasconexao(DComunicador);
end;

function login(VP_Host: PChar; VP_Porta: integer; VP_ChaveTerminal: PChar; VP_Versao_Comunicacao: integer; VP_Senha: PChar;
    VP_Tipo: PChar;  VP_Terminal_ID: integer): integer; cdecl;
var
    VL_Mensagem: TMensagem;
    VL_S: string;
    VL_Erro: string;
    VL_Transmissao_id: string;
    VL_Desafio_ID: String;
    VL_Desafio: String;
begin
    VL_S := '';
    VL_Transmissao_id := '';
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
        if Length(VP_Tipo) = 0 then
        begin
            Result := 42;
            Exit;
        end;
        if ((DComunicador.V_ConexaoCliente.ServidorHost <> VP_Host) or
            (DComunicador.V_ConexaoCliente.ServidorPorta <> VP_Porta) or
            (F_ChaveTerminal <> VP_ChaveTerminal) or
            (F_Versao_Comunicacao <> VP_Versao_Comunicacao)) then
        begin
            DComunicador.DesconectarCliente(DComunicador);
            DComunicador.V_ConexaoCliente.ServidorHost := VP_Host;
            DComunicador.V_ConexaoCliente.ServidorPorta := VP_Porta;
            F_ChaveTerminal := VP_ChaveTerminal;
            F_Versao_Comunicacao := VP_Versao_Comunicacao;
        end;


        Result := DComunicador.ConectarCliente(DComunicador);

        if Result <> 0 then
            Exit;

        if DComunicador.V_ConexaoCliente.Status = csLogado then
        begin
            Result := 0;
            Exit;
        end;

        if DComunicador.V_ConexaoCliente.Status = csChaveado then
        begin
            VL_Mensagem.Limpar;

            DCom.CriptoAes.GenerateKey(VP_ChaveTerminal);
            VL_Desafio_ID := FloatToStr(Random(10000)) + '      ';
            VL_Desafio := DCom.CriptoAes.EncryptString(VL_Desafio_ID + DateTimeToStr(Now) + FloatToStr(Random(1000)));

            VL_Mensagem.AddComando('0001', '');
            VL_Mensagem.AddTag('0106', VL_Desafio); // desafio de chave
            VL_Mensagem.AddTag('0002', VP_ChaveTerminal);
            VL_Mensagem.AddTag('0005', IntToStr(C_lib_versao[0]) + '.' + IntToStr(C_lib_versao[1]) + '.' + IntToStr(C_lib_versao[2]));
            VL_Mensagem.AddTag('0006', IntToStr(C_lib_versao[0]));
            VL_Mensagem.AddTag('00A3', IntToStr(VP_Terminal_ID)); // TERMINAL ID
            VL_Mensagem.AddTag('0035', VP_Senha);
            VL_Mensagem.AddTag('0037', VP_Tipo);
            //envia ao cliente
            Result := DComunicador.ClienteTransmiteSolicitacao(DComunicador, VL_Transmissao_id, VL_Mensagem, VL_Mensagem, nil, 10000, True);
            if Result <> 0 then
                Exit;
            VL_Mensagem.TagToStr(VL_S);
            VL_S := VL_Mensagem.Comando;
            if VL_S = '0028' then
                DComunicador.V_ConexaoCliente.Status := csLogado
            else
            if VL_S = '0029' then
                Result := 34
            else
                Result := 34;

        end;

    finally
        VL_Mensagem.Free;
    end;

end;

function solicitacao(VP_Dados: PChar; VP_Procedimento: TRetorno; VP_TempoAguarda: integer): integer; cdecl;
var
    VL_Th: ThProcesso;
begin
    Result := 0;
    VL_Th := ThProcesso.Create(True, '', VP_Dados, VP_Procedimento, VP_TempoAguarda);
    VL_Th.Start;

end;

function solicitacaoblocante(VP_Dados: PChar; var VO_Retorno: PChar; VP_TempoAguarda: integer): integer; cdecl;
var
    VL_String, VL_Transamissao_ID: string;
    VL_Mensagens: TMensagem;
begin
    VL_String := '';
    VL_Transamissao_ID := '';
    try
        VL_String := VP_Dados;
        VL_Mensagens := TMensagem.Create;
        VL_Mensagens.CarregaTags(VL_String);
        Result := DComunicador.ClienteTransmiteSolicitacao(DComunicador, VL_Transamissao_ID, VL_Mensagens, VL_Mensagens, nil, VP_TempoAguarda, True);
        VL_Mensagens.TagToStr(VL_String);

        VO_Retorno := StrAlloc(Length(VL_String) + 1);
        StrPCopy(VO_Retorno, VL_String);

    finally
        VL_Mensagens.Free;
    end;

end;

function opentefstatus(var VO_StatusRetorno: integer): integer; cdecl;
begin
    Result := 0;
    VO_StatusRetorno := Ord(DComunicador.V_ConexaoCliente.Status);
end;



end.
