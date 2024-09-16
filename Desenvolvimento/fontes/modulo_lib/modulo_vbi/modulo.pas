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

if VL_Transacao.GetTagAsAstring('00D5') = '0128' then // MENU VBI CARTAO VENDER
if VL_Transacao.GetTagAsAstring('00D5') = '011C' then // SOLICITA MENU DINAMICO VBI
 begin
   if VP_Terminal_Tipo <> 'PDV' then
   begin
     VL_Mensagem.AddComando('000A', 'R'); // retorno
     VL_Mensagem.AddTag('004D', 134);  // resposta com erro
     Result := 134;

     GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '160820241645', 'Mensagem enviada no comando000A', VL_Mensagem.TagsAsString, 134, 2);

     DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID, VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
     Exit;
   end;

   Result := SolicitaMenuVBI(VL_BancoDados, DComunicador, VP_Transmissao_ID, VP_Terminal_ID, VP_Conexao_ID, cnCaixa);

   if Result <> 0 then
   begin
     VL_Mensagem.AddComando('000A', 'R'); // retorno
     VL_Mensagem.AddTag('004D', Result);  // resposta com erro

     GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '210820241504', 'Mensagem enviada no comando000A', VL_Mensagem.TagsAsString, 134, 2);

     DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID, VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
     Exit;
   end;

   Exit;
 end;
function CarregaConfiguracaoVBI(VP_BancoDados: TDBancoDados; VP_Terminal_ID: integer; var VO_Host: string; var VO_Porta: integer; var VO_Estabelecimento: string;
      var VO_Loja: string; var VO_Terminal: string; var VO_Aplicacao: string; var VO_Instalacao: string; var VO_ModuloConfig_ID: integer): integer;
    function SolicitaTransacaoCartaoVBI(VP_BancoDados: TDBancoDados; VP_Comunicador: TDComunicador; VP_Transmissao_ID: string; VP_Terminal_ID, VP_Conexao_ID: integer;
      VP_ConexaoTipo: TConexaoTipo): integer;
    function SolicitaMenuVBI(VP_BancoDados: TDBancoDados; VP_Comunicador: TDComunicador; VP_Transmissao_ID: string; VP_Terminal_ID, VP_Conexao_ID: integer; VP_ConexaoTipo: TConexaoTipo): integer;
    function TDNucleo.CarregaConfiguracaoVBI(VP_BancoDados: TDBancoDados; VP_Terminal_ID: integer; var VO_Host: string; var VO_Porta: integer;
  var VO_Estabelecimento: string; var VO_Loja: string; var VO_Terminal: string; var VO_Aplicacao: string; var VO_Instalacao: string; var VO_ModuloConfig_ID: integer): integer;
var
  VL_ConsultaA: TZQuery;
begin
  Result := 0;
  VL_ConsultaA := nil;

  VO_Host := '';
  VO_Porta := 0;
  VO_Estabelecimento := '';
  VO_Loja := '';
  VO_Terminal := '';
  VO_Aplicacao := '';
  VO_Instalacao := '';
  VO_ModuloConfig_ID := 0;
  try
    VL_ConsultaA := TZQuery.Create(VP_BancoDados);
    VL_ConsultaA.Connection := VP_BancoDados.ZConexao;

    VL_ConsultaA.Close;
    VL_ConsultaA.SQL.Text := 'SELECT PDC.MODULO_CONF_ID, PDC.TEF_HOST,PDC.TEF_PORTA,PDC.TEF_ESTABELECIMENTO,PDC.TEF_LOJA,PDC.TEF_TERMINAL,PDC.TEF_APLICACAO,PDC.TEF_INSTALACAO  ' +
      ' FROM MODULO M INNER JOIN MODULO_CONF MD ON M.ID = MD.MODULO_ID INNER JOIN PDV_MODULO_CONF PDC ON PDC.MODULO_CONF_ID = MD.ID ' +
      ' WHERE M.TAG_NUMERO = ''011D'' AND PDC.HABILITADO = ''T'' AND PDC.PDV_ID = ' + IntToSQL(VP_Terminal_ID);
    VL_ConsultaA.Open;

    if VL_ConsultaA.RecordCount <= 0 then
    begin
      Result := 133;
      Exit;
    end;

    if trim(VL_ConsultaA.FieldByName('TEF_HOST').AsString) = '' then
    begin
      Result := 135;
      Exit;
    end;

    if VL_ConsultaA.FieldByName('TEF_PORTA').AsInteger <= 0 then
    begin
      Result := 136;
      Exit;
    end;

    if trim(VL_ConsultaA.FieldByName('TEF_ESTABELECIMENTO').AsString) = '' then
    begin
      Result := 137;
      Exit;
    end;

    if trim(VL_ConsultaA.FieldByName('TEF_LOJA').AsString) = '' then
    begin
      Result := 138;
      Exit;
    end;

    if trim(VP_BancoDados.ConsultaA.FieldByName('TEF_TERMINAL').AsString) = '' then
    begin
      Result := 139;
      Exit;
    end;

    if trim(VL_ConsultaA.FieldByName('TEF_APLICACAO').AsString) = '' then
    begin
      Result := 140;
      Exit;
    end;

    VO_Host := VL_ConsultaA.FieldByName('TEF_HOST').AsString;
    VO_Porta := VL_ConsultaA.FieldByName('TEF_PORTA').AsInteger;
    VO_Estabelecimento := VL_ConsultaA.FieldByName('TEF_ESTABELECIMENTO').AsString;
    VO_Loja := VL_ConsultaA.FieldByName('TEF_LOJA').AsString;
    VO_Terminal := VL_ConsultaA.FieldByName('TEF_TERMINAL').AsString;
    VO_Aplicacao := VL_ConsultaA.FieldByName('TEF_APLICACAO').AsString;
    VO_Instalacao := VL_ConsultaA.FieldByName('TEF_INSTALACAO').AsString;
    VO_ModuloConfig_ID := VL_ConsultaA.FieldByName('MODULO_CONF_ID').AsInteger;

  finally
    if Assigned(VL_ConsultaA) then
      VL_ConsultaA.Free;
  end;
end;

function TDNucleo.SolicitaMenuVBI(VP_BancoDados: TDBancoDados; VP_Comunicador: TDComunicador; VP_Transmissao_ID: string; VP_Terminal_ID, VP_Conexao_ID: integer;
  VP_ConexaoTipo: TConexaoTipo): integer;
var
  VL_MensagemEnviada, VL_MensagemRecebida: TMensagem;
  VL_Dados: string;
  VL_Host, VL_Estabelecimento, VL_Loja, VL_Terminal, VL_Aplicacao, VL_Instalacao: string;
  VL_Porta, VL_ModuloConfig_ID: integer;
  VL_ConsultaA: TZQuery;
begin
  Result := 0;
  VL_Dados := '';
  VL_ConsultaA := nil;
  VL_MensagemEnviada := TMensagem.Create;
  VL_MensagemRecebida := TMensagem.Create;
  try
    VL_ConsultaA := TZQuery.Create(VP_BancoDados);
    VL_ConsultaA.Connection := VP_BancoDados.ZConexao;

    VL_ConsultaA.Close;
    VL_ConsultaA.SQL.Text := 'SELECT T.TAG_NUMERO,T.DADOS FROM TAG T LEFT OUTER JOIN P_TAG_FUNCAO(' + IntToSql(VP_Terminal_ID) + ',''MENU_PDV_011C'') TG ' +
      ' ON TG.S_TAG_NUMERO=T.TAG_NUMERO ' + ' WHERE T.TAG_TIPO = ''MENU_PDV_011C'' AND (TG.S_TAG_NUMERO IS NULL OR TG.S_HABILITADO = ''T'') ';

    VL_ConsultaA.Open;

    VL_MensagemEnviada.AddComando('0018', 'S'); // retorno do menu

    while not VL_ConsultaA.EOF do
    begin
      VL_MensagemEnviada.AddTag(VL_ConsultaA.FieldByName('TAG_NUMERO').AsString, VL_ConsultaA.FieldByName('DADOS').AsString);
      VL_ConsultaA.Next;
    end;

    GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '210820241610', 'Mensagem enviada no SolicitaMenuVBI', VL_MensagemEnviada.TagsAsString, 0, 2);

    DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, 60000, False, nil, VP_Transmissao_ID, VL_MensagemEnviada, VL_MensagemRecebida, VP_Conexao_ID);

    {
    CONSULTANDO MENU LIBERADO PELA VBI E LIBERADO NA CONFIGURACAO DO OPENTEF

    Result := CarregaConfiguracaoVBI(VP_BancoDados, VP_Terminal_ID, VL_Host, VL_Porta, VL_Estabelecimento, VL_Loja, VL_Terminal, VL_Aplicacao,VL_Instalacao,VL_ModuloConfig_ID);

    if Result <> 0 then
    begin
      Exit;
    end;

    VL_MensagemEnviada.Limpar;
    VL_MensagemEnviada.AddComando('012E', 'S');
    VL_MensagemEnviada.AddTag('0003', VL_Host);
    VL_MensagemEnviada.AddTag('0004', VL_Porta);
    VL_MensagemEnviada.AddTag('012A', VL_Estabelecimento);
    VL_MensagemEnviada.AddTag('012B', VL_Loja);
    VL_MensagemEnviada.AddTag('012C', VL_Terminal);
    VL_MensagemEnviada.AddTag('012D', VL_Aplicacao);
    VL_MensagemEnviada.AddTag('012F', VL_Instalacao);

    Result := DNucleo.ModuloSolicitacaoBlocante(VL_MensagemEnviada, VL_MensagemRecebida, VP_Transmissao_ID, 60000, VL_ModuloConfig_ID, VP_ConexaoTipo);

    if Result <> 0 then
    begin
      Exit;
    end;

    VP_BancoDados.ConsultaA.Close;
    VP_BancoDados.ConsultaA.SQL.Text := 'SELECT S_TAG_NUMERO,S_HABILITADO FROM P_TAG_FUNCAO(' + IntToStr(VP_Terminal_ID) + ',''MENU_PDV_011C'')';

    VP_BancoDados.ConsultaA.Open;

    while not VP_BancoDados.ConsultaA.EOF do
    begin
      if VP_BancoDados.ConsultaA.FieldByName('S_HABILITADO').AsString = 'F' then
      begin
        if VL_MensagemRecebida.GetTag(VP_BancoDados.ConsultaA.FieldByName('S_TAG_NUMERO').AsString, VL_Dados) = 0 then
        begin
          VL_MensagemRecebida.DeleteTag(VP_BancoDados.ConsultaA.FieldByName('S_TAG_NUMERO').AsString);
        end;
      end;

      VP_BancoDados.ConsultaA.Next;
    end;

    VL_MensagemRecebida.AddComando('0018', 'S'); // retorno

    GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '210820241610', 'Mensagem enviada no SolicitaMenuVBI', VL_MensagemRecebida.TagsAsString, 0, 2);

    DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, 60000, False, nil, VP_Transmissao_ID, VL_MensagemRecebida, VL_MensagemRecebida, VP_Conexao_ID);
    Exit;
    }

  finally
    VL_MensagemEnviada.Free;
    VL_MensagemRecebida.Free;

    if Assigned(VL_ConsultaA) then
      VL_ConsultaA.Free;
  end;
end;

function TDNucleo.SolicitaTransacaoCartaoVBI(VP_BancoDados: TDBancoDados; VP_Comunicador: TDComunicador; VP_Transmissao_ID: string; VP_Terminal_ID, VP_Conexao_ID: integer;
  VP_ConexaoTipo: TConexaoTipo): integer;
var
  VL_MensagemEnviada, VL_MensagemRecebida: TMensagem;
  VL_Host, VL_Estabelecimento, VL_Loja, VL_Terminal, VL_Aplicacao, VL_Instalacao: string;
  VL_Porta, VL_ModuloConfig_ID: integer;
begin
  Result := 0;

  VL_MensagemEnviada := TMensagem.Create;
  VL_MensagemRecebida := TMensagem.Create;
  try
    Result := CarregaConfiguracaoVBI(VP_BancoDados, VP_Terminal_ID, VL_Host, VL_Porta, VL_Estabelecimento, VL_Loja, VL_Terminal, VL_Aplicacao,VL_Instalacao,VL_ModuloConfig_ID);

    if Result <> 0 then
    begin
      Exit;
    end;

    VL_MensagemEnviada.Limpar;
    VL_MensagemEnviada.AddComando('0131', 'S');
    VL_MensagemEnviada.AddTag('0003', VL_Host);
    VL_MensagemEnviada.AddTag('0004', VL_Porta);
    VL_MensagemEnviada.AddTag('012A', VL_Estabelecimento);
    VL_MensagemEnviada.AddTag('012B', VL_Loja);
    VL_MensagemEnviada.AddTag('012C', VL_Terminal);
    VL_MensagemEnviada.AddTag('012D', VL_Aplicacao);
    VL_MensagemEnviada.AddTag('012F', VL_Instalacao);

    Result := DNucleo.ModuloSolicitacaoBlocante(VL_MensagemEnviada, VL_MensagemRecebida, VP_Transmissao_ID, 60000, VL_ModuloConfig_ID, VP_ConexaoTipo);

    if Result <> 0 then
    begin
      Exit;
    end;

  finally
    VL_MensagemEnviada.Free;
    VL_MensagemRecebida.Free;
  end;
end;
