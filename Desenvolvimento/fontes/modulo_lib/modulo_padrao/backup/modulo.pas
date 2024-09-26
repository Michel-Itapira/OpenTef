unit modulo;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, comunicador, funcoes, def, LbClass;

  { TDModulo }
type

  TRetornoModuloL = procedure(VP_Transmissao_ID: PChar; VP_Tarefa_ID, VP_ProcID, VP_Erro: integer; VP_Dados: PChar); cdecl;

  ThProcesso = class(TThread)
  private
    fdados: ansistring;
    ftempo: integer;
    fprocedimento: TRetornoModuloL;
    fArquivoLog: string;
    f_DModulo: Pointer;
    f_transmissaoID: string;
    f_Tarefa_ID: integer;

  protected
    procedure Execute; override;
  public
    constructor Create(VP_Suspenso: boolean; VP_Transmissao_ID, VP_ArquivoLog, VP_Dados: ansistring; VP_Procedimento: TRetornoModulo; VP_DModulo: Pointer;
      VP_Tarefa_ID, VP_TempoAguarda: integer);

  end;



  TDModulo = class(TDataModule)
  private
    V_ModuloProcID: integer;
    //V_ChaveComunicacao: ansistring;
    //V_Identificacao: ansistring;
    V_ModuloConf_ID: integer;
    V_ArquivoLog: ansistring;
    V_DComunicador: TDComunicador;
    V_Modulo: Pointer;
    V_Retorno: TRetornoModulo; //caso receba alguma mensagem vindo da operadora sem solicitar
  end;

function inicializar(VP_ModuloProcID: integer; var VO_Modulo: Pointer; VP_Recebimento: TRetornoModulo; VP_ModuloConf_ID: integer; VP_ArquivoLog: PChar): integer; cdecl;
function finalizar(VP_Modulo: Pointer): integer; cdecl;
function login(VP_Modulo: Pointer; VP_Host: PChar; VP_Porta: integer; VP_ChaveComunicacao, VP_TipoConexao, VP_Identificador: PChar): integer; cdecl;
function solicitacao(VP_Modulo: Pointer; VP_Transmissao_ID, VP_Dados: PChar; VP_Procedimento: TRetornoModulo; VP_TarefaID, VP_TempoAguarda: integer): integer; cdecl;
function solicitacaoblocante(VP_Modulo: Pointer; VP_Transmissao_ID, VP_Dados: PChar; var VO_Retorno: PChar; VP_TempoAguarda: integer): integer; cdecl;
function modulostatus(VP_Modulo: Pointer; var VO_Versao: PChar; var VO_VersaoMensagem: integer; var VO_StatusRetorno: integer): integer; cdecl;
procedure Retorno(VP_Transmissao_ID: PChar; VP_TarefaID, VP_ModuloProcID, VP_Erro: integer; VP_Dados: PChar; VP_Modulo: Pointer); cdecl;
procedure alterarnivellog(VP_Nivel: integer); cdecl;


implementation

{$R *.lfm}

{ TDModulo }


{ TDModulo }


constructor ThProcesso.Create(VP_Suspenso: boolean; VP_Transmissao_ID, VP_ArquivoLog, VP_Dados: ansistring; VP_Procedimento: TRetornoModulo; VP_DModulo: Pointer;
  VP_Tarefa_ID, VP_TempoAguarda: integer);
begin
  FreeOnTerminate := True;
  fArquivoLog := VP_ArquivoLog;
  fdados := VP_Dados;
  f_DModulo := VP_DModulo;
  ftempo := VP_TempoAguarda;
  Pointer(fprocedimento) := VP_Procedimento;
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
    try
      VL_Erro := VL_MensagemOUT.CarregaTags(fdados);
      if VL_Erro <> 0 then
      begin
        GravaLog(fArquivoLog, 0, '', 'modulo', '210520221957', 'Erro no carregamento da tag ', '', 1, 1);
        fprocedimento(PChar(f_transmissaoID), f_Tarefa_ID, TDModulo(f_DModulo).V_ModuloProcID, VL_Erro, PChar(fdados));
        exit;
      end;

      GravaLog(fArquivoLog, 0, 'ThProcesso.Execute', 'modulo', '131120230953', 'mensagem enviada', VL_MensagemOUT.TagsAsString, 0, 2);

      VL_Erro := TDComunicador(TDModulo(f_DModulo).V_DComunicador).ClienteTransmiteSolicitacao(TDComunicador(TDModulo(f_DModulo).V_DComunicador),
        f_transmissaoID, VL_MensagemOUT, VL_MensagemIN, nil, ftempo, True);

      GravaLog(fArquivoLog, 0, 'ThProcesso.Execute', 'modulo', '131120230954', 'mensagem recebida', VL_MensagemIN.TagsAsString, 0, 2);

      if VL_Erro <> 0 then
      begin
        GravaLog(fArquivoLog, 0, '', 'modulo', '090920221522', 'Erro na ThProcesso.Execute', '', VL_Erro, 1);
        //fprocedimento(PChar(f_transmissaoID), f_Tarefa_ID, TDModulo(f_DModulo).V_ModuloProcID, VL_Erro, PChar(fdados));
        exit;
      end;

      fprocedimento(PChar(f_transmissaoID), f_Tarefa_ID, TDModulo(f_DModulo).V_ModuloProcID, VL_Erro, PChar(VL_MensagemIN.TagsAsString));
    except
      on e: Exception do
      begin
        GravaLog(TDModulo(f_DModulo).V_ArquivoLog, 0, '', 'modulo', '111220230848', 'Erro de excecao no ThProcesso.Execute ' + e.ClassName + '/' + e.Message, '', 1, 1);
      end;
    end;
  finally
    VL_MensagemOUT.Free;
    VL_MensagemIN.Free;
  end;
end;

procedure Retorno(VP_Transmissao_ID: PChar; VP_TarefaID, VP_ModuloProcID, VP_Erro: integer; VP_Dados: PChar; VP_Modulo: Pointer); cdecl;
begin
  try
    if Assigned(TDModulo(VP_Modulo).V_Retorno) then
      TDModulo(VP_Modulo).V_Retorno(VP_Transmissao_ID, 0, VP_ModuloProcID, VP_Erro, VP_Dados, VP_Modulo);
  except
    on e: Exception do
    begin
      GravaLog(TDModulo(VP_Modulo).V_ArquivoLog, 0, '', 'modulo', '111220230916', 'Erro de Retorno ' + e.ClassName + '/' + e.Message, '', 1, 1);
    end;
  end;
end;

function inicializar(VP_ModuloProcID: integer; var VO_Modulo: Pointer; VP_Recebimento: TRetornoModulo; VP_ModuloConf_ID: integer; VP_ArquivoLog: PChar): integer; cdecl;
var
  VL_Modulo: TDModulo;
begin
  try
    Result := 0;

    VL_Modulo := TDModulo.Create(nil);

    Pointer(VO_Modulo) := Pointer(VL_Modulo);
    TDModulo(VO_Modulo).V_Modulo := VO_Modulo;
    TDModulo(VO_Modulo).V_ModuloProcID := VP_ModuloProcID;
    TDModulo(VO_Modulo).V_ModuloConf_ID := VP_ModuloConf_ID;
    TDModulo(VO_Modulo).V_ArquivoLog := VP_ArquivoLog;
    TDModulo(VO_Modulo).V_DComunicador := TDComunicador.Create(nil);
    TDModulo(VO_Modulo).V_DComunicador.V_Modulo := VO_Modulo;
    TDModulo(VO_Modulo).V_DComunicador.V_ProcID := VP_ModuloProcID;
    TDModulo(VO_Modulo).V_DComunicador.V_ArquivoLog := VP_ArquivoLog;
    TDModulo(VO_Modulo).V_DComunicador.V_ClienteRecebimentoModulo := @Retorno;
    TDModulo(VO_Modulo).V_Retorno := VP_Recebimento;
  except
    on e: Exception do
    begin
      Result := 54;
      GravaLog(TDModulo(VO_Modulo).V_ArquivoLog, 0, '', 'modulo', '081220231707', 'Erro de excecao no inicializar ' + e.ClassName + '/' + e.Message, '', 54, 1);
    end;
  end;
end;

function finalizar(VP_Modulo: Pointer): integer; cdecl;
begin
  Result := 0;
  try
    TDModulo(VP_Modulo).V_DComunicador.Free;
    TDModulo(VP_Modulo).Free;
   // Freemem(VP_Modulo);
    VP_Modulo:= nil;
  except
    on e: Exception do
    begin
      Result := 1;
      GravaLog(TDModulo(VP_Modulo).V_ArquivoLog, 0, '', 'modulo', '190520221827', 'Erro na finalizacao do modulo finalizar() ' + e.ClassName + '/' + e.Message, '', 1, 1);
    end;
  end;
end;

function login(VP_Modulo: Pointer; VP_Host: PChar; VP_Porta: integer; VP_ChaveComunicacao, VP_TipoConexao, VP_Identificador: PChar): integer; cdecl;
var
  VL_MensagemIN, VL_MensagemOUT: TMensagem;
  VL_Transmissao_ID: string;
  VL_ArquivoLog: string;
begin
  Result := 0;
  VL_Transmissao_ID := '';

  VL_MensagemOUT := TMensagem.Create;
  VL_MensagemIN := TMensagem.Create;

  try
    try
      VL_ArquivoLog := TDModulo(VP_Modulo).V_ArquivoLog;

      if Length(VP_Host) = 0 then
      begin
        Result := 9;
        exit;
      end;
      if VP_Porta < 1 then
      begin
        Result := 11;
        exit;
      end;
      if length(VP_ChaveComunicacao) = 0 then
      begin
        Result := 15;
        exit;
      end;
      if ((TDModulo(VP_Modulo).V_DComunicador.V_ConexaoCliente.ServidorHost <> VP_Host) or (TDModulo(VP_Modulo).V_DComunicador.V_ConexaoCliente.ServidorPorta <> VP_Porta) or
        (TDModulo(VP_Modulo).V_DComunicador.V_ConexaoCliente.Identificador <> VP_Identificador) or (TDModulo(VP_Modulo).V_DComunicador.V_ConexaoCliente.Chave_Comunicacao <>
        VP_ChaveComunicacao)) then
      begin
        TDModulo(VP_Modulo).V_DComunicador.DesconectarCliente(TDModulo(VP_Modulo).V_DComunicador);
        TDModulo(VP_Modulo).V_DComunicador.V_ConexaoCliente.ServidorHost := VP_Host;
        TDModulo(VP_Modulo).V_DComunicador.V_ConexaoCliente.ServidorPorta := VP_Porta;
        TDModulo(VP_Modulo).V_DComunicador.V_ConexaoCliente.Chave_Comunicacao := VP_ChaveComunicacao;
        TDModulo(VP_Modulo).V_DComunicador.V_ConexaoCliente.Identificador := VP_Identificador;
      end;

      TDModulo(VP_Modulo).V_DComunicador.V_ConexaoCliente.Aes.GenerateKey(VP_ChaveComunicacao);

      Result := TDModulo(VP_Modulo).V_DComunicador.ConectarCliente(TDModulo(VP_Modulo).V_DComunicador);

      if Result <> 0 then
      begin
        GravaLog(VL_ArquivoLog, 0, '', 'modulo', '190920220909', 'Erro no login', '', Result, 1);
        Exit;
      end;

      if TDModulo(VP_Modulo).V_DComunicador.V_ConexaoCliente.Status = csLogado then
      begin
        Result := 0;
        Exit;
      end;

      if TDModulo(VP_Modulo).V_DComunicador.V_ConexaoCliente.Status > csLink then
      begin
        VL_MensagemOUT.Limpar;
        VL_MensagemOUT.AddComando('0001', 'S'); // login
        VL_MensagemOUT.AddTag('0005', IntToStr(C_versao[0]) + '.' + IntToStr(C_versao[1]) + '.' + IntToStr(C_versao[2])); // versao do modulo
        VL_MensagemOUT.AddTag('0006', IntToStr(C_mensagem)); // versao da mensageira
        VL_MensagemOUT.AddTag('0110', VP_TipoConexao); // TIPO CONEXAO S= SISTEMA C=CAIXA
        VL_MensagemOUT.AddTag('0037', 'S'); // permissao

        GravaLog(VL_ArquivoLog, 0, 'login', 'modulo', '131120230955', 'mensagem enviada', VL_MensagemOUT.TagsAsString, 0, 2);

        Result := TDModulo(VP_Modulo).V_DComunicador.ClienteTransmiteSolicitacao(TDModulo(VP_Modulo).V_DComunicador, VL_Transmissao_ID, VL_MensagemOUT, VL_MensagemIN, nil, 10000, True);

        if Result <> 0 then
        begin
          GravaLog(VL_ArquivoLog, 0, '', 'modulo', '160920220839', 'Erro no login', '', Result, 1);
          Exit;
        end;


        GravaLog(VL_ArquivoLog, 0, 'login', 'modulo', '131120230956', 'mensagem recebida', VL_MensagemIN.TagsAsString, 0, 2);

        if VL_MensagemIN.GetTagAsAstring('004D') <> '0' then
        begin
          Result := StrToInt(VL_MensagemIN.GetTagAsAstring('004D'));
          Exit;
        end;

        TDModulo(VP_Modulo).V_DComunicador.V_ConexaoCliente.Status := csLogado;

      end;
    except
      on e: Exception do
      begin
        Result := 1;
        GravaLog(VL_ArquivoLog, 0, '', 'modulo', '081220231706', 'Erro de excecao no login ' + e.ClassName + '/' + e.Message, '', 1, 1);
      end;
    end;
  finally
    VL_MensagemIN.Free;
    VL_MensagemOUT.Free;
  end;

end;



function solicitacao(VP_Modulo: Pointer; VP_Transmissao_ID, VP_Dados: PChar; VP_Procedimento: TRetornoModulo; VP_TarefaID, VP_TempoAguarda: integer): integer; cdecl;
var
  VL_Th: ThProcesso;
begin
  Result := 0;
  try
    VL_Th := ThProcesso.Create(True, VP_Transmissao_ID, TDModulo(VP_Modulo).V_ArquivoLog, VP_Dados, VP_Procedimento, TDModulo(VP_Modulo), VP_TarefaID, VP_TempoAguarda);
    VL_Th.Start;
  except
    on e: Exception do
    begin
      Result := 1;
      GravaLog(TDModulo(VP_Modulo).V_ArquivoLog, 0, '', 'modulo', '111220230845', 'Erro de excecao no solicitacao ' + e.ClassName + '/' + e.Message, '', 1, 1);
    end;
  end;
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
    try
      Result := 0;
      VL_Dados := '';

      GravaLog(TDModulo(VP_Modulo).V_ArquivoLog, 0, 'solicitacaoblocante', 'modulo', '131120230957', 'mensagem enviada', VP_Dados, 0, 2);

      VL_MensagemOUT.CarregaTags(VP_Dados);

      Result := TDModulo(VP_Modulo).V_DComunicador.ClienteTransmiteSolicitacao(TDModulo(VP_Modulo).V_DComunicador, VL_Transmissao_ID, VL_MensagemOUT,
        VL_MensagemIN, nil, VP_TempoAguarda, True);

      GravaLog(TDModulo(VP_Modulo).V_ArquivoLog, 0, 'solicitacaoblocante', 'modulo', '131120230958', 'mensagem recebida', VL_Dados, 0, 2);

      VL_MensagemIN.TagToStr(VL_Dados);

      VO_Retorno := StrAlloc(Length(VL_Dados) + 1);
      StrPCopy(VO_Retorno, VL_Dados);
    except
      on e: Exception do
      begin
        Result := 1;
        GravaLog(TDModulo(VP_Modulo).V_ArquivoLog, 0, '', 'modulo', '111220230846', 'Erro de excecao no solicitacaoblocante ' + e.ClassName + '/' + e.Message, '', 1, 1);
      end;
    end;
  finally
    VL_MensagemIN.Free;
    VL_MensagemOUT.Free;
  end;

end;

function modulostatus(VP_Modulo: Pointer; var VO_Versao: PChar; var VO_VersaoMensagem: integer; var VO_StatusRetorno: integer): integer; cdecl;
var
  VL_Ansi: ansistring;
begin
  try
    Result := 0;
    VO_StatusRetorno := Ord(TDModulo(VP_Modulo).V_DComunicador.V_ConexaoCliente.Status);

    if VO_StatusRetorno = Ord(csLogado) then
      TDModulo(VP_Modulo).V_DComunicador.IdTCPCliente.IOHandler.CheckForDisconnect(False);

    VO_StatusRetorno := Ord(TDModulo(VP_Modulo).V_DComunicador.V_ConexaoCliente.Status);

    VL_Ansi := IntToStr(C_versao[0]) + '.' + IntToStr(C_versao[1]) + '.' + IntToStr(C_versao[2]);

    VO_Versao := StrAlloc(Length(VL_Ansi) + 1);
    StrPCopy(VO_Versao, VL_Ansi);

    VO_VersaoMensagem := C_Mensagem;
  except
    on e: Exception do
    begin
      Result := 1;
      GravaLog(TDModulo(VP_Modulo).V_ArquivoLog, 0, '', 'modulo', '111220230847', 'Erro de excecao no modulostatus ' + e.ClassName + '/' + e.Message, '', 1, 1);
    end;
  end;
end;

procedure alterarnivellog(VP_Nivel: integer); cdecl;
begin
  F_NivelLog := VP_Nivel;
end;

end.
