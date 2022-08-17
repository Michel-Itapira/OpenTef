unit modulo;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils, comunicador, funcoes, def;

{ TDModulo }
type
    ThProcesso = class(TThread)
    private
        fdados: ansistring;
        ftempo: integer;
        fprocedimento: TRetornoModulo;
        fArquivoLog: string;
        f_DModulo: Pointer;
        f_transmissaoID: string;
        f_Tarefa_ID: integer;

    protected
        procedure Execute; override;
    public
        constructor Create(VP_Suspenso: boolean; VP_Transmissao_ID, VP_ArquivoLog, VP_Dados: ansistring; VP_Procedimento: TRetornoModulo;
            VP_DModulo: Pointer; VP_Tarefa_ID, VP_TempoAguarda: integer);

    end;



    TDModulo = class(TDataModule)
    private
        V_ModuloProcID: integer;
        F_ChaveTerminal: ansistring;
        V_ModuloConf_ID: integer;
        V_ArquivoLog: ansistring;
        V_DComunicador: TDComunicador;
        V_Modulo: Pointer;
    end;

function inicializar(VP_ModuloProcID: integer; var VO_Modulo: Pointer; VP_Recebimento: TRetornoModulo; VP_ModuloConf_ID: integer;
    VP_ArquivoLog: PChar): integer; stdcall; cdecl;
function finalizar(VP_Modulo: Pointer): integer; cdecl;
function login(VP_Modulo: Pointer; VP_Host: PChar; VP_Porta: integer; VP_ChaveTerminal: PChar): integer; cdecl;
function solicitacao(VP_Modulo: Pointer; VP_Transmissao_ID, VP_Dados: PChar; VP_Procedimento: TRetornoModulo; VP_TarefaID, VP_TempoAguarda: integer): integer;
    cdecl;
function solicitacaoblocante(VP_Modulo: Pointer; VP_Transmissao_ID, VP_Dados: PChar; var VO_Retorno: PChar; VP_TempoAguarda: integer): integer; cdecl;
function modulostatus(VP_Modulo: Pointer; var VO_Versao: PChar; var VO_VersaoMensagem: integer; var VO_StatusRetorno: integer): integer; cdecl;
procedure Retorno(VP_Transmissao_ID: PChar; VP_ModuloProcID, VP_Codigo: integer; VP_Dados: PChar); cdecl;

var
    F_RetornoModulo: TRetornoModulo; //caso receba alguma mensagem vindo da operadora sem solicitar

implementation

{$R *.lfm}


constructor ThProcesso.Create(VP_Suspenso: boolean; VP_Transmissao_ID, VP_ArquivoLog, VP_Dados: ansistring;
    VP_Procedimento: TRetornoModulo; VP_DModulo: Pointer; VP_Tarefa_ID, VP_TempoAguarda: integer);

begin
    FreeOnTerminate := True;
    fArquivoLog := VP_ArquivoLog;
    fdados := VP_Dados;
    f_DModulo := VP_DModulo;
    ftempo := VP_TempoAguarda;
    fprocedimento := VP_Procedimento;
    f_transmissaoID := VP_Transmissao_ID;
    f_Tarefa_ID := VP_Tarefa_ID;
    inherited Create(VP_Suspenso);

end;

procedure ThProcesso.Execute;
var
    VL_MensagemIN, VL_MensagemOUT: TMensagem;
    VL_Erro: integer;
begin
    VL_MensagemOUT := TMensagem.Create;
    VL_MensagemIN := TMensagem.Create;
    try
        VL_Erro := VL_MensagemOUT.CarregaTags(fdados);
        if VL_Erro <> 0 then
        begin
            GravaLog(fArquivoLog, 0, '', 'modulo', '210520221957', 'Erro no carregamento da tag ', '', 1);
            fprocedimento(PChar(f_transmissaoID), f_Tarefa_ID, TDModulo(f_DModulo).V_ModuloProcID, VL_Erro, PChar(fdados));
            exit;
        end;

        VL_Erro := TDComunicador(TDModulo(f_DModulo).V_DComunicador).ClienteTransmiteSolicitacao(f_transmissaoID, VL_MensagemOUT,
            VL_MensagemIN, nil, ftempo, True);

        fprocedimento(PChar(f_transmissaoID), f_Tarefa_ID, TDModulo(f_DModulo).V_ModuloProcID, VL_Erro, PChar(VL_MensagemIN.TagsAsString));
    finally
        VL_MensagemOUT.Free;
        VL_MensagemIN.Free;
    end;
end;

procedure Retorno(VP_Transmissao_ID: PChar; VP_ModuloProcID, VP_Codigo: integer; VP_Dados: PChar); cdecl;
begin
    if Assigned(F_RetornoModulo) then
        F_RetornoModulo(VP_Transmissao_ID, 0, VP_ModuloProcID, VP_Codigo, VP_Dados);
end;

function inicializar(VP_ModuloProcID: integer; var VO_Modulo: Pointer; VP_Recebimento: TRetornoModulo; VP_ModuloConf_ID: integer;
    VP_ArquivoLog: PChar): integer; cdecl;
begin
    try
        Result := 0;

        Pointer(VO_Modulo) := Pointer(TDModulo.Create(nil));
        TDModulo(VO_Modulo).V_Modulo := VO_Modulo;
        TDModulo(VO_Modulo).V_ModuloProcID := VP_ModuloProcID;
        TDModulo(VO_Modulo).V_ModuloConf_ID := VP_ModuloConf_ID;
        TDModulo(VO_Modulo).V_ArquivoLog := VP_ArquivoLog;
        TDModulo(VO_Modulo).V_DComunicador := TDComunicador.Create(nil);
        TDModulo(VO_Modulo).V_DComunicador.V_ProcID := VP_ModuloProcID;
        TDModulo(VO_Modulo).V_DComunicador.V_ArquivoLog := VP_ArquivoLog;
        TDModulo(VO_Modulo).V_DComunicador.V_ConexaoCliente := TTConexao.Create(@TDModulo(VO_Modulo).V_DComunicador);
        TDModulo(VO_Modulo).V_DComunicador.V_ThRecebeEscuta := TThRecebe.Create(True, @TDModulo(VO_Modulo).V_DComunicador, VP_ArquivoLog);
        TDModulo(VO_Modulo).V_DComunicador.V_ClienteRecebimento := @Retorno;
        TDModulo(VO_Modulo).V_DComunicador.V_ThRecebeEscuta.Start;

        F_RetornoModulo := VP_Recebimento;


    except
        Result := 54;
    end;

end;

function finalizar(VP_Modulo: Pointer): integer; cdecl;
var
    VL_ArquivoLog: string;
begin
    Result := 0;
    VL_ArquivoLog := TDModulo(VP_Modulo).V_ArquivoLog;
    try
        //if Assigned(TDModulo(VP_Modulo).V_DComunicador.V_ThRecebeEscuta) then
        //begin
        //    TDModulo(VP_Modulo).V_DComunicador.V_ThRecebeEscuta.Parar;
        //    TDModulo(VP_Modulo).V_DComunicador.V_ThRecebeEscuta.Terminate;
        //    TDModulo(VP_Modulo).V_DComunicador.V_ThRecebeEscuta.WaitFor;
        //end;

        TDModulo(VP_Modulo).V_DComunicador.Free;
        TDModulo(VP_Modulo).Free;


    except
        on e: EInOutError do
            GravaLog(VL_ArquivoLog, 0, '', 'modulo', '190520221827', 'Erro na finalizacao do modulo finalizar() ' + e.ClassName + '/' + e.Message, '', 1);

    end;

end;

function login(VP_Modulo: Pointer; VP_Host: PChar; VP_Porta: integer; VP_ChaveTerminal: PChar): integer; cdecl;
var
    VL_MensagemIN, VL_MensagemOUT: TMensagem;
    VL_S: string;
    VL_DadosI: string;
    VL_Transmissao_ID: string;
begin
    Result := 1;
    VL_S := '';
    VL_Transmissao_ID := '';

    VL_MensagemOUT := TMensagem.Create;
    VL_MensagemIN := TMensagem.Create;
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
        if length(VP_ChaveTerminal) = 0 then
        begin
            Result := 15;
            exit;
        end;
        if ((TDModulo(VP_Modulo).V_DComunicador.V_ConexaoCliente.ServidorHost <> VP_Host) or
            (TDModulo(VP_Modulo).V_DComunicador.V_ConexaoCliente.ServidorPorta <> VP_Porta) or
            (TDModulo(VP_Modulo).F_ChaveTerminal <> VP_ChaveTerminal)) then
        begin
            TDModulo(VP_Modulo).V_DComunicador.DesconectarCliente;
            TDModulo(VP_Modulo).V_DComunicador.V_ConexaoCliente.ServidorHost := VP_Host;
            TDModulo(VP_Modulo).V_DComunicador.V_ConexaoCliente.ServidorPorta := VP_Porta;
            TDModulo(VP_Modulo).F_ChaveTerminal := VP_ChaveTerminal;

        end;


        Result := TDModulo(VP_Modulo).V_DComunicador.ConectarCliente;

        if Result <> 0 then
            Exit;

        if TDModulo(VP_Modulo).V_DComunicador.V_ConexaoCliente.Status = csLogado then
        begin
            Result := 0;
            Exit;
        end;

        if TDModulo(VP_Modulo).V_DComunicador.V_ConexaoCliente.Status = csChaveado then
        begin
            VL_MensagemOUT.Limpar;
            VL_MensagemOUT.AddComando('0001', '');
            VL_MensagemOUT.AddTag('0002', VP_ChaveTerminal);
            VL_MensagemOUT.AddTag('0005', IntToStr(C_versao[0]) + '.' + IntToStr(C_versao[1]) + '.' + IntToStr(C_versao[2]));
            VL_MensagemOUT.AddTag('0006', IntToStr(C_mensagem));
            VL_MensagemOUT.AddTag('0037', 'S');

            Result := TDModulo(VP_Modulo).V_DComunicador.ClienteTransmiteSolicitacao(VL_Transmissao_ID, VL_MensagemOUT, VL_MensagemIN, nil, 10000, True);
            if Result <> 0 then
                Exit;
            VL_MensagemIN.GetComando(VL_S, VL_DadosI);
            if VL_S = '0028' then
                TDModulo(VP_Modulo).V_DComunicador.V_ConexaoCliente.Status := csLogado
            else
            if VL_S = '0029' then
            begin
                Result := StrToInt(VL_DadosI);
            end
            else
                Result := 34;

        end;

    finally
        VL_MensagemIN.Free;
        VL_MensagemOUT.Free;
    end;

end;



function solicitacao(VP_Modulo: Pointer; VP_Transmissao_ID, VP_Dados: PChar; VP_Procedimento: TRetornoModulo;
    VP_TarefaID, VP_TempoAguarda: integer): integer; cdecl;
var
    VL_Th: ThProcesso;
begin
    Result := 0;
    VL_Th := ThProcesso.Create(True, VP_Transmissao_ID, TDModulo(VP_Modulo).V_ArquivoLog, VP_Dados, VP_Procedimento,
        TDModulo(VP_Modulo), VP_TarefaID, VP_TempoAguarda);
    VL_Th.Start;

end;

function solicitacaoblocante(VP_Modulo: Pointer; VP_Transmissao_ID, VP_Dados: PChar; var VO_Retorno: PChar; VP_TempoAguarda: integer): integer; cdecl;
var
    VL_MensagemIN, VL_MensagemOUT: TMensagem;
    VL_Dados: ansistring;
    VL_Transmissao_ID: string;

begin
    VL_MensagemOUT := TMensagem.Create;
    VL_MensagemIN := TMensagem.Create;
    VL_Transmissao_ID := VP_Transmissao_ID;
    try
        Result := 0;
        VL_Dados := '';
        VL_MensagemOUT.CarregaTags(VP_Dados);
        Result := TDModulo(VP_Modulo).V_DComunicador.ClienteTransmiteSolicitacao(VL_Transmissao_ID, VL_MensagemOUT, VL_MensagemIN, nil, VP_TempoAguarda, True);
        VL_MensagemIN.TagToStr(VL_Dados);

        VO_Retorno := StrAlloc(Length(VL_Dados) + 1);
        StrPCopy(VO_Retorno, VL_Dados);

    finally
        VL_MensagemIN.Free;
        VL_MensagemOUT.Free;
    end;

end;

function modulostatus(VP_Modulo: Pointer; var VO_Versao: PChar; var VO_VersaoMensagem: integer; var VO_StatusRetorno: integer): integer; cdecl;
var
    VL_Ansi: ansistring;
begin
    Result := 0;
    VO_StatusRetorno := Ord(TDModulo(VP_Modulo).V_DComunicador.V_ConexaoCliente.Status);

    if VO_StatusRetorno = Ord(csLogado) then
        TDModulo(VP_Modulo).V_DComunicador.IdTCPCliente.IOHandler.CheckForDisconnect(False);

    VO_StatusRetorno := Ord(TDModulo(VP_Modulo).V_DComunicador.V_ConexaoCliente.Status);

    VL_Ansi := IntToStr(C_versao[0]) + '.' + IntToStr(C_versao[1]) + '.' + IntToStr(C_versao[2]);

    VO_Versao := StrAlloc(Length(VL_Ansi) + 1);
    StrPCopy(VO_Versao, VL_Ansi);

    VO_VersaoMensagem := C_Mensagem;

end;




end.
