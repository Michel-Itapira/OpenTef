unit modulo;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, def, funcoes;

type
  TVbiInicializar = function(var VO_VbiLib: Pointer; VP_ArquivoLog: PChar): integer; cdecl;
  TVbiFinlizar = function(VP_VbiLib: Pointer): integer; cdecl;
  TVbiAlterarNivelLog = procedure(VP_Nivel: integer); cdecl;
  TVbiSolicitacao = function(VP_VbiLib: Pointer; VP_Dados: PChar; var VO_Retorno: PChar): integer; cdecl;
  TVbiStrDispose = procedure(VP_PChar: PChar); cdecl;

  { TDModulo }

  TDModulo = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
  private
    V_ArquivoLog: ansistring;
    V_Modulo: Pointer;

    V_VbiLib: THandle;
    V_Vbi: Pointer;

    V_VbiInicializar: TVbiInicializar;
    V_VbiFinalizar: TVbiFinlizar;
    V_VbiAlterarNivelLog: TVbiAlterarNivelLog;
    V_VbiSolicitacao: TVbiSolicitacao;
    V_VbiStrDispose: TVbiStrDispose;
  end;

function inicializar(VP_ModuloProcID: integer; var VO_Modulo: Pointer; VP_Recebimento: TRetornoModulo; VP_ModuloConf_ID: integer; VP_ArquivoLog: PChar): integer; cdecl;
function finalizar(VP_Modulo: Pointer): integer; cdecl;
function login(VP_Modulo: Pointer; VP_Host: PChar; VP_Porta: integer; VP_ChaveComunicacao, VP_TipoConexao, VP_Identificacao: PChar): integer; cdecl;
function solicitacao(VP_Modulo: Pointer; VP_Transmissao_ID, VP_Dados: PChar; VP_Procedimento: TRetornoModulo; VP_TarefaID, VP_TempoAguarda: integer): integer; cdecl;
function solicitacaoblocante(VP_Modulo: Pointer; VP_Transmissao_ID, VP_Dados: PChar; var VO_Retorno: PChar; VP_TempoAguarda: integer): integer; cdecl;
function modulostatus(VP_Modulo: Pointer; var VO_Versao: PChar; var VO_VersaoMensagem: integer; var VO_StatusRetorno: integer): integer; cdecl;
procedure Retorno(VP_Transmissao_ID: PChar; VP_TarefaID, VP_ModuloProcID, VP_Erro: integer; VP_Dados: PChar; VP_Modulo: Pointer); cdecl;
procedure alterarnivellog(VP_Nivel: integer); cdecl;

function solicitarMenu(VP_Modulo: Pointer; VP_MensagemRecebida: TMensagem; var VO_MensagemEnviada: TMensagem): integer;
function vendaCartao(VP_Modulo: Pointer; VP_MensagemRecebida: TMensagem; var VO_MensagemEnviada: TMensagem): integer;

implementation

{$R *.lfm}

function inicializar(VP_ModuloProcID: integer; var VO_Modulo: Pointer; VP_Recebimento: TRetornoModulo; VP_ModuloConf_ID: integer; VP_ArquivoLog: PChar): integer; cdecl;
var
  VL_Modulo: TDModulo;
begin
  Result := 0;
  try

    VL_Modulo := TDModulo.Create(nil);

    VO_Modulo := AllocMem(SizeOf(VL_Modulo) + 1);

    Pointer(VO_Modulo) := Pointer(VL_Modulo);
    TDModulo(VO_Modulo).V_Modulo := VO_Modulo;
    TDModulo(VO_Modulo).V_ArquivoLog := VP_ArquivoLog;

    {$IFDEF WIN}
       TDModulo(VO_Modulo).V_VbiLib := LoadLibrary(PChar(ExtractFilePath(ParamStr(0)) + 'modulo/vbi_lib.dll'));
    {$ELSE}
    TDModulo(VO_Modulo).V_VbiLib := LoadLibrary(PChar(ExtractFilePath(ParamStr(0)) + 'modulo\vbi_lib.so'));
    {$ENDIF}


    if TDModulo(VO_Modulo).V_VbiLib = 0 then
    begin
      Result := 141;
      Exit;
    end;

    Pointer(TDModulo(VO_Modulo).V_VbiInicializar) := GetProcAddress(TDModulo(VO_Modulo).V_VbiLib, 'inicializar');
    Pointer(TDModulo(VO_Modulo).V_VbiFinalizar) := GetProcAddress(TDModulo(VO_Modulo).V_VbiLib, 'finalizar');
    Pointer(TDModulo(VO_Modulo).V_VbiAlterarNivelLog) := GetProcAddress(TDModulo(VO_Modulo).V_VbiLib, 'alterarnivellog');
    Pointer(TDModulo(VO_Modulo).V_VbiSolicitacao) := GetProcAddress(TDModulo(VO_Modulo).V_VbiLib, 'solicitacao');
    Pointer(TDModulo(VO_Modulo).V_VbiStrDispose) := GetProcAddress(TDModulo(VO_Modulo).V_VbiLib, 'mensagemdispose');

    Result := TDModulo(VO_Modulo).V_VbiInicializar(TDModulo(VO_Modulo).V_Vbi, VP_ArquivoLog);

    if Result <> 0 then
      Exit;

    if not Assigned(TDModulo(VO_Modulo).V_Vbi) then
    begin
      Result := 142;
      Exit;
    end;

  except
    on e: Exception do
    begin
      Result := 54;
      GravaLog(TDModulo(VO_Modulo).V_ArquivoLog, 0, '', 'modulo', '160820241704', 'Erro de excecao no inicializar ' + e.ClassName + '/' + e.Message, '', 54, 1);
    end;
  end;
end;

function finalizar(VP_Modulo: Pointer): integer; cdecl;
begin
  Result := 0;
  try

    if Assigned(TDModulo(VP_Modulo).V_Vbi) then
    begin
      Result := TDModulo(VP_Modulo).V_VbiFinalizar(TDModulo(VP_Modulo).V_Vbi);

      if Result <> 0 then
        Exit;

      TDModulo(VP_Modulo).V_Vbi := nil;
    end;

    if TDModulo(VP_Modulo).V_VbiLib <> 0 then
    begin
      UnloadLibrary(TDModulo(VP_Modulo).V_VbiLib);
      TDModulo(VP_Modulo).V_VbiLib := 0;
    end;

    TDModulo(VP_Modulo).Free;
    VP_Modulo := nil;
  except
    on e: Exception do
    begin
      Result := 1;
      GravaLog(TDModulo(VP_Modulo).V_ArquivoLog, 0, '', 'modulo', '160820241708', 'Erro na finalizacao do modulo finalizar ' + e.ClassName + '/' + e.Message, '', 1, 1);
    end;
  end;
end;

function login(VP_Modulo: Pointer; VP_Host: PChar; VP_Porta: integer; VP_ChaveComunicacao, VP_TipoConexao, VP_Identificacao: PChar): integer; cdecl;
begin
  Result := 0;
end;

function solicitacao(VP_Modulo: Pointer; VP_Transmissao_ID, VP_Dados: PChar; VP_Procedimento: TRetornoModulo; VP_TarefaID, VP_TempoAguarda: integer): integer; cdecl;
begin
  Result := 0;
end;

function solicitacaoblocante(VP_Modulo: Pointer; VP_Transmissao_ID, VP_Dados: PChar; var VO_Retorno: PChar; VP_TempoAguarda: integer): integer; cdecl;
var
  VL_MensagemEnviadas, VL_MensagemRecebidas: TMensagem;
begin
  Result := 0;
  VL_MensagemRecebidas := TMensagem.Create;
  VL_MensagemEnviadas := TMensagem.Create;
  try
    try
      Result := VL_MensagemRecebidas.CarregaTags(VP_Dados);

      if Result <> 0 then
      begin
        GravaLog(TDModulo(VP_Modulo).V_ArquivoLog, 0, '', 'modulo', '210820241301', 'Erro ao carregar os dados recebidos ', VP_Dados, 1, 1);
        Exit;
      end;

      case VL_MensagemRecebidas.Comando() of
        '012E': Result := solicitarMenu(VP_Modulo, VL_MensagemRecebidas, VL_MensagemEnviadas);
        '0131': Result := vendaCartao(VP_Modulo, VL_MensagemRecebidas, VL_MensagemEnviadas);
        else
          Result := 101;
      end;

      if Result <> 0 then
      begin
        GravaLog(TDModulo(VP_Modulo).V_ArquivoLog, 0, '', 'modulo', '210820241321', 'Erro ao solicitar o comando do modulo ', VP_Dados, Result, 1);
        Exit;
      end;

      VO_Retorno := StrAlloc(Length(VL_MensagemEnviadas.TagsAsString) + 1);
      StrPCopy(VO_Retorno, VL_MensagemEnviadas.TagsAsString);

    except
      on e: Exception do
      begin
        Result := 1;
        GravaLog(TDModulo(VP_Modulo).V_ArquivoLog, 0, '', 'modulo', '210820241258', 'Erro de excecao no solicitacaoblocante ' + e.ClassName + '/' + e.Message, VP_Dados, 1, 1);
      end;
    end;
  finally
    VL_MensagemRecebidas.Free;
    VL_MensagemEnviadas.Free;
  end;
end;

function modulostatus(VP_Modulo: Pointer; var VO_Versao: PChar; var VO_VersaoMensagem: integer; var VO_StatusRetorno: integer): integer; cdecl;
var
  VL_Ansi: ansistring;
begin
  try
    Result := 0;

    VO_StatusRetorno := Ord(csLogado);

    VL_Ansi := IntToStr(C_versao[0]) + '.' + IntToStr(C_versao[1]) + '.' + IntToStr(C_versao[2]);

    VO_Versao := StrAlloc(Length(VL_Ansi) + 1);
    StrPCopy(VO_Versao, VL_Ansi);

    VO_VersaoMensagem := C_Mensagem;
  except
    on e: Exception do
    begin
      Result := 1;
      GravaLog(TDModulo(VP_Modulo).V_ArquivoLog, 0, '', 'modulo', '160820241710', 'Erro de excecao no modulostatus ' + e.ClassName + '/' + e.Message, '', 1, 1);
    end;
  end;
end;

procedure Retorno(VP_Transmissao_ID: PChar; VP_TarefaID, VP_ModuloProcID, VP_Erro: integer; VP_Dados: PChar; VP_Modulo: Pointer); cdecl;
begin
  sleep(5);
end;

procedure alterarnivellog(VP_Nivel: integer); cdecl;
begin
  F_NivelLog := VP_Nivel;
end;

function vendaCartao(VP_Modulo: Pointer; VP_MensagemRecebida: TMensagem; var VO_MensagemEnviada: TMensagem): integer;
var
  VL_Retorno: PUtf8Char;
  VL_Dados: string;
  VL_MensagemEnviada, VL_MensagemRecebida, VL_MensagemAuxiliar: TMensagem;
begin
  Result := 0;
  VL_Retorno := nil;
  VL_Dados := '';
  VO_MensagemEnviada.Limpar;
  try
    VL_MensagemEnviada := TMensagem.Create;
    VL_MensagemRecebida := TMensagem.Create;
    VL_MensagemAuxiliar := TMensagem.Create;

    VL_MensagemAuxiliar.Limpar;
    VL_MensagemAuxiliar.AddComando('0000', 'S');
    VL_MensagemAuxiliar.AddTag('0129', 'CRÉDITO');
    VL_MensagemAuxiliar.AddTag('0130', 'DÉBITO');

    VL_MensagemEnviada.Limpar;
    VL_MensagemEnviada.AddComando('002A', 'S'); //solicita dados pdv
    VL_MensagemEnviada.AddTag('00DA', 'SELECIONE A FORMA DA VENDA');
    VL_MensagemEnviada.AddTag('00DD', VL_MensagemAuxiliar.TagsAsString);

    GravaLog(TDModulo(VP_Modulo).V_ArquivoLog, 0, '', 'modulo_vbi', '230820241008', 'Mensagem enviada no SolicitaTransacaoCartaoVBI', VL_MensagemEnviada.TagsAsString, 0, 2);

    Result := DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, 60000, True, nil, VP_Transmissao_ID, VL_MensagemEnviada, VL_MensagemRecebida, VP_Conexao_ID);

    if Result <> 0 then
    begin
      Exit;
    end;

    VL_MensagemEnviada.Limpar;
    VL_MensagemEnviada.AddComando('00E1', 'S'); // solicita dados da transacao
    VL_MensagemEnviada.AddTag('0013', ''); // valor
    VL_MensagemEnviada.AddTag('000F', ''); // quantidade de parcela

    GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '230820241009', 'Mensagem enviada no SolicitaTransacaoCartaoVBI', VL_MensagemEnviada.TagsAsString, 0, 2);

    Result := DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, 60000, True, nil, VP_Transmissao_ID, VL_MensagemEnviada, VL_MensagemRecebida, VP_Conexao_ID);

    if Result <> 0 then
    begin
      Exit;
    end;

    if VP_MensagemRecebida.GetTagAsAstring('012F') = 'N' then
    begin
      if TDModulo(VP_Modulo).V_VbiLib = 0 then
      begin
        Result := 141;
        Exit;
      end;

      Result := TDModulo(VP_Modulo).V_VbiSolicitacao(TDModulo(VP_Modulo).V_Vbi, PUtf8Char(VP_MensagemRecebida.TagsAsString), VL_Retorno);

      if Result <> 0 then
        Exit;

      VL_Dados := VL_Retorno;
      TDModulo(VP_Modulo).V_VbiStrDispose(VL_Retorno);

      Result := VO_MensagemEnviada.CarregaTags(VL_Dados);

      if Result <> 0 then
        Exit;
    end
    else
    begin
      // mandar comando pro tef
    end;

  finally
    VL_MensagemEnviada.Free;
    VL_MensagemRecebida.Free;
    VL_MensagemAuxiliar.Free;
  end;
end;

function solicitarMenu(VP_Modulo: Pointer; VP_MensagemRecebida: TMensagem; var VO_MensagemEnviada: TMensagem): integer;
var
  VL_Retorno: PUtf8Char;
  VL_Dados: string;
begin
  Result := 0;
  VL_Retorno := nil;
  VL_Dados := '';

  VO_MensagemEnviada.Limpar;

  if VP_MensagemRecebida.GetTagAsAstring('012F') = 'N' then
  begin
    if TDModulo(VP_Modulo).V_VbiLib = 0 then
    begin
      Result := 141;
      Exit;
    end;

    Result := TDModulo(VP_Modulo).V_VbiSolicitacao(TDModulo(VP_Modulo).V_Vbi, PUtf8Char(VP_MensagemRecebida.TagsAsString), VL_Retorno);

    if Result <> 0 then
      Exit;

    VL_Dados := VL_Retorno;
    TDModulo(VP_Modulo).V_VbiStrDispose(VL_Retorno);

    Result := VO_MensagemEnviada.CarregaTags(VL_Dados);

    if Result <> 0 then
      Exit;
  end
  else
  begin
    // mandar comando pro tef
  end;
end;

{ TDModulo }

procedure TDModulo.DataModuleCreate(Sender: TObject);
begin
  V_Vbi := nil;
  V_VbiLib := 0;
end;

end.
