unit com;

{$mode ObjFPC}{$H+}

interface

uses
    Classes,
    SysUtils,
    comunicador,
    funcoes;

{ TDCom }
type

    ThProcesso = class(TThread)
    private
        fdados: ansistring;
        fprocedimento: TRetorno;
        ftempo: integer;
        ftransmissaoID:String;
    protected
        procedure Execute; override;
    public
        constructor Create(VP_Suspenso: boolean;VP_Transmissao_ID, VP_Dados: ansistring; VP_Procedimento: TRetorno; VP_TempoAguarda: integer);

    end;



    TDCom = class(TDataModule)

    private

    end;

function inicializar(VP_Procedimento: TRetorno;VP_ArquivoLog: PChar): integer; stdcall;
function finalizar(): integer; stdcall;
function desconectar(): integer; stdcall;
function login(VP_Host: PChar; VP_Porta: integer; VP_ChaveTerminal: PChar; VP_Versao_Comunicacao: integer; VP_Senha: PChar; VP_Tipo: PChar;
    var VO_Mensagem: PChar): integer; stdcall;
function solicitacao(VP_Dados: PChar; VP_Procedimento: TRetorno; VP_TempoAguarda: integer): integer; stdcall;
function solicitacaoblocante(VP_Dados: PChar; var VO_Retorno: PChar; VP_TempoAguarda: integer): integer;stdcall;
function opentefstatus(var VO_StatusRetorno: integer): integer; stdcall;

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


constructor ThProcesso.Create(VP_Suspenso: boolean;VP_Transmissao_ID, VP_Dados: ansistring; VP_Procedimento: TRetorno; VP_TempoAguarda: integer);

begin
    FreeOnTerminate := True;
    fdados := VP_Dados;
    ftempo := VP_TempoAguarda;
    fprocedimento := VP_Procedimento;
    ftransmissaoID:=VP_Transmissao_ID;
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
        VL_Erro := DComunicador.ClienteTransmiteSolicitacao(ftransmissaoID, VL_Mensagem, VL_Mensagem, nil, ftempo,True);
        fprocedimento(PChar(ftransmissaoID),0, VL_Erro, PChar(VL_Mensagem.TagsAsString));
    finally
        VL_Mensagem.Free;
    end;
end;

function inicializar(VP_Procedimento: TRetorno;VP_ArquivoLog: PChar): integer; stdcall;
begin

    DCom := TDCom.Create(nil);

    if not Assigned(DComunicador) then
        DComunicador := TDComunicador.Create(nil);

    DComunicador.V_ConexaoCliente := TTConexao.Create(@DComunicador);
    DComunicador.V_ThRecebeEscuta := TThRecebe.Create(True, @DComunicador,VP_ArquivoLog);
    DComunicador.V_ThRecebeEscuta.Start;


    DComunicador.V_ClienteRecebimento := VP_Procedimento;

    Result := 0;

end;

function finalizar(): integer; stdcall;
begin

    if Assigned(DComunicador.V_ThRecebeEscuta) then
    begin
        DComunicador.V_ThRecebeEscuta.Parar;
        DComunicador.V_ThRecebeEscuta.Terminate;
    end;


    DComunicador.Free;
    DCom.Free;

    Result := 0;
end;

function desconectar: integer; stdcall;
begin
    Result := 0;
    DComunicador.desativartodasconexao;
end;

function login(VP_Host: PChar; VP_Porta: integer; VP_ChaveTerminal: PChar; VP_Versao_Comunicacao: integer; VP_Senha: PChar;
    VP_Tipo: PChar; var VO_Mensagem: PChar): integer; stdcall;
var
    VL_Mensagem: TMensagem;
    VL_S: string;
    VL_Erro: string;
    VL_Transmissao_id:String;
begin
    VL_S := '';
    VL_Transmissao_id:='';
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
            DComunicador.DesconectarCliente;
            DComunicador.V_ConexaoCliente.ServidorHost := VP_Host;
            DComunicador.V_ConexaoCliente.ServidorPorta := VP_Porta;
            F_ChaveTerminal := VP_ChaveTerminal;
            F_Versao_Comunicacao := VP_Versao_Comunicacao;
        end;


        Result := DComunicador.ConectarCliente;

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
            VL_Mensagem.AddComando('0001', '');
            VL_Mensagem.AddTag('0002', VP_ChaveTerminal);
            VL_Mensagem.AddTag('0005', IntToStr(C_lib_versao[0]) + '.' + IntToStr(C_lib_versao[1]) + '.' + IntToStr(C_lib_versao[2]));
            VL_Mensagem.AddTag('0006', IntToStr(C_lib_versao[0]));
            VL_Mensagem.AddTag('0035', VP_Senha);
            VL_Mensagem.AddTag('0037', VP_Tipo);
            //envia ao cliente
            Result := DComunicador.ClienteTransmiteSolicitacao(VL_Transmissao_id,VL_Mensagem, VL_Mensagem, nil, 10000,True);
            if Result <> 0 then
                Exit;
            VL_Mensagem.TagToStr(VL_S);
            StrPCopy(VO_Mensagem, VL_S);
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

function solicitacao(VP_Dados: PChar; VP_Procedimento: TRetorno; VP_TempoAguarda: integer): integer; stdcall;
var
    VL_Th: ThProcesso;
begin
    Result := 0;
    VL_Th := ThProcesso.Create(True,'', VP_Dados, VP_Procedimento, VP_TempoAguarda);
    VL_Th.Start;

end;

function solicitacaoblocante(VP_Dados: PChar; var VO_Retorno: PChar; VP_TempoAguarda: integer): integer;stdcall;
var
    VL_String,VL_Transamissao_ID: string;
    VL_Mensagens: TMensagem;
begin
    VL_String := '';
    VL_Transamissao_ID:='';
    try
        VL_String := VP_Dados;
        VL_Mensagens := TMensagem.Create;
        VL_Mensagens.CarregaTags(VL_String);
        Result := DComunicador.ClienteTransmiteSolicitacao(VL_Transamissao_ID,VL_Mensagens, VL_Mensagens, nil, VP_TempoAguarda,True);
        VL_Mensagens.TagToStr(VL_String);

        VO_Retorno := StrAlloc(Length(VL_String) + 1);
        StrPCopy(VO_Retorno, VL_String);

    finally
        VL_Mensagens.Free;
    end;

end;

function opentefstatus(var VO_StatusRetorno: integer): integer; stdcall;
begin
    Result := 0;
    VO_StatusRetorno := Ord(DComunicador.V_ConexaoCliente.Status);
end;



end.
