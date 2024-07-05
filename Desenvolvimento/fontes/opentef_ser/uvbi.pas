unit uvbi;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, IdTCPClient, funcoes;

type
  TVBIRetorno = record
    erro: integer;
    descricao: string;
  end;

  TTagVBIDados = record
    tag: string;
    dados: string;
  end;

  TTagVBI = class
  private
    F_Tag: array of TTagVBIDados;
    function formatarDadosMensagemLimite(VP_Mensagem: string): string;
  public
    procedure addTag(VP_Tag: string; VP_Dados: string);
    function getTag(VP_Tag: string): string;
    function GetTagIdx(VP_Posicao: integer; var VO_Tag: string;
      var VO_Dados: string): integer;
    function getTagAsArray(VP_Tag: string): TStringArray;
    procedure limpar;
    function tagsAsString: string;
    function tagCount: integer;
    function carregaMensagem(VP_Mensagem: string): integer;
    function automacaoColeta: boolean;
    procedure Copiar(VP_Tag: TTagVBI);
  end;

  TVBIIntergrador = class
  private
    VF_IdTCPCliente: TIdTCPClient;

    VF_Sequencia: integer;
    VF_SequenciaAutomacaoColeta: integer;
    VF_ServicoAtual: string;

    VF_Porta: integer;
    VF_Host: string;
    VF_ArquivoLog: string;

    VF_Aplicacao: string;
    VF_AplicacaoTela: string;
    VF_Estabelecimento: string;
    VF_Loja: string;
    VF_Terminal: string;

    function conectar: integer;
    function desconectar: integer;
    function enviarMensagemSocket(VP_DadosEnviados: string;
      var VO_DadosRecebidos: string): TVBIRetorno;
    function enviarMensagem(VP_DadosEnviados: TTagVBI;
      var VO_DadosRecebidos: TTagVBI): TVBIRetorno;
  public
    constructor Create(VP_ArquivoLog: string; VP_Host: string;
      VP_Porta: integer; VP_Aplicacao: string;
      VP_AplicacaoTela, VP_Estabelecimento, VP_Loja, VP_Terminal: string);
    destructor Destroy; override;

    function inicializarTransacao: TVBIRetorno;
    function venderCartaoCredito: TVBIRetorno;
  end;

procedure limparVBIRetorno(var VO_Retorno: TVBIRetorno);

const
  C_Comunicacao_Terminacao: string =
    char($0D) + char($0A) + char($09) + char($09) + char($0D) + char($0A) +
    char($09) + char($09) + char($09) + char($0D) + char($0A) + char($09) +
    char($09) + char($0D) + char($0A) + char($09);
  C_TempoAgurde: integer = 60;

implementation

procedure limparVBIRetorno(var VO_Retorno: TVBIRetorno);
begin
  VO_Retorno.erro := 0;
  VO_Retorno.descricao := '';
end;

procedure TTagVBI.addTag(VP_Tag: string; VP_Dados: string);
var
  VL_I: integer;
  VL_Dados: string;
begin
  VL_Dados := '';
  VL_Dados := VP_Dados;
  VL_Dados := StringReplace(VL_Dados, #$00, '', [rfReplaceAll]);

  if length(F_Tag) >= 1 then
  begin
    for VL_I := 0 to length(F_Tag) - 1 do
    begin
      if F_Tag[VL_I].tag = VP_Tag then
      begin
        F_Tag[VL_I].dados := VL_Dados;
        Exit;
      end;
    end;
  end;

  SetLength(F_Tag, Length(F_Tag) + 1);
  F_Tag[Length(F_Tag) - 1].tag := VP_Tag;
  F_Tag[Length(F_Tag) - 1].dados := VL_Dados;
end;

procedure TTagVBI.limpar;
begin
  SetLength(F_Tag, 0);
end;

function TTagVBI.tagCount: integer;
begin
  Result := Length(F_Tag) - 1;
end;

function TTagVBI.tagsAsString: string;
var
  VL_I: integer;
  VL_Dados: string;
begin
  Result := '';

  for VL_I := 0 to length(F_Tag) - 1 do
  begin
    VL_Dados := '';
    VL_Dados := StringReplace(F_Tag[VL_I].dados, '"', '""', [rfReplaceAll]);
    Result := Result + F_Tag[VL_I].tag + '="' + VL_Dados + '"';
  end;
end;

function TTagVBI.getTag(VP_Tag: string): string;
var
  VL_I: integer;
begin
  Result := '';

  for VL_I := 0 to length(F_Tag) - 1 do
  begin
    if F_Tag[VL_I].tag = VP_Tag then
    begin
      Result := F_Tag[VL_I].dados;
      Exit;
    end;
  end;
end;

function TTagVBI.GetTagIdx(VP_Posicao: integer; var VO_Tag: string;
  var VO_Dados: string): integer;
begin
  Result := 0;
  VO_Dados := '';
  VO_Tag := '';
  if Length(F_Tag) > VP_Posicao then
  begin
    VO_Tag := F_Tag[VP_Posicao].tag;
    VO_Dados := F_Tag[VP_Posicao].dados;
  end;
end;

function TTagVBI.getTagAsArray(VP_Tag: string): TStringArray;
var
  VL_I: integer;
  VL_Dados: string;
begin
  Result := nil;
  SetLength(Result, 0);
  VL_Dados := '';

  for VL_I := 0 to length(F_Tag) - 1 do
  begin
    if F_Tag[VL_I].tag = VP_Tag then
    begin
      VL_Dados := F_Tag[VL_I].dados;
      VL_Dados := StringReplace(VL_Dados, '"', '', [rfReplaceAll]);
      Result := VL_Dados.Split(';');
      Exit;
    end;
  end;
end;

function TTagVBI.formatarDadosMensagemLimite(VP_Mensagem: string): string;
var
  VL_Mensagem: string;
  VL_QuantidadeAspasSeguidas: integer;
  VL_Aspas: string;
  VL_LetraAnterior: string;
begin
  Result := '';
  VL_LetraAnterior := '';
  VL_Mensagem := '';
  VL_Mensagem := VP_Mensagem;

  while length(VL_Mensagem) > 0 do
  begin
    if VL_Mensagem[1] <> '"' then
    begin
      Result := Result + VL_Mensagem[1];
      VL_LetraAnterior := VL_Mensagem[1];
      Delete(VL_Mensagem, 1, 1);
      continue;
    end;

    if (VL_Mensagem[2] = ';') or (VL_LetraAnterior = ';') then
    begin
      Result := Result + VL_Mensagem[1];
      VL_LetraAnterior := VL_Mensagem[1];
      Delete(VL_Mensagem, 1, 1);
      continue;
    end;

    if VL_Mensagem[2] = '"' then
    begin
      VL_QuantidadeAspasSeguidas := 2;
      VL_Aspas := '""';

      while VL_Mensagem[VL_QuantidadeAspasSeguidas + 1] = '"' do
      begin
        VL_QuantidadeAspasSeguidas := VL_QuantidadeAspasSeguidas + 1;
        VL_Aspas := VL_Aspas + '"';
        Result := Result + '"';
      end;

      if VL_QuantidadeAspasSeguidas mod 2 <> 0 then
        break;

      VL_Mensagem := Copy(VL_Mensagem, length(VL_Aspas) + 1,
        length(VL_Mensagem) - length(VL_Aspas));
      VL_LetraAnterior := '"';
      continue;
    end;

    break;
  end;
end;

function TTagVBI.automacaoColeta: boolean;
var
  VL_I: integer;
begin
  Result := False;

  for VL_I := 0 to length(F_Tag) - 1 do
  begin
    if F_Tag[VL_I].tag.StartsWith('automacao_coleta') then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

procedure TTagVBI.Copiar(VP_Tag: TTagVBI);
var
  VL_I: integer;
  VL_Dados, VL_Tag: string;
begin
  self.limpar;

  for VL_I := 0 to VP_Tag.tagCount do
  begin
    VP_Tag.GetTagIdx(VL_I, VL_Tag, VL_Dados);
    self.addTag(VL_Tag, VL_dados);
  end;
end;

function TTagVBI.carregaMensagem(VP_Mensagem: string): integer;
var
  VL_Mensagem: string;
  VL_Campo: string;
  VL_Dados: string;
  VL_Posicao: integer;
begin
  Result := 0;
  self.limpar;

  VL_Mensagem := '';
  VL_Mensagem := VP_Mensagem;
  VL_Mensagem := StringReplace(VL_Mensagem, #$0A, '', [rfReplaceAll]);
  VL_Mensagem := StringReplace(VL_Mensagem, #$00, '', [rfReplaceAll]);
  VL_Mensagem := trim(VL_Mensagem);

  while not (trim(VL_Mensagem) = '') do
  begin
    VL_Campo := '';
    VL_Dados := '';

    VL_Posicao := Pos('=', VL_Mensagem);

    if VL_Posicao = 0 then
    begin
      Result := 1;
      Exit;
    end;

    VL_Campo := Copy(VL_Mensagem, 0, VL_Posicao - 1);
    VL_Mensagem := Copy(VL_Mensagem, VL_Posicao + 2, length(VL_Mensagem) - 3);

    VL_Dados := formatarDadosMensagemLimite(VL_Mensagem);
    VL_Mensagem := Copy(VL_Mensagem, length(VL_Dados) + 2, length(VL_Mensagem) -
      length(VL_Dados) - 1);

    VL_Dados := StringReplace(VL_Dados, '""', '"', [rfReplaceAll]);
    self.addTag(VL_Campo, VL_Dados);
  end;
end;

constructor TVBIIntergrador.Create(VP_ArquivoLog: string; VP_Host: string;
  VP_Porta: integer; VP_Aplicacao, VP_AplicacaoTela, VP_Estabelecimento,
  VP_Loja, VP_Terminal: string);
begin
  VF_IdTCPCliente := nil;

  VF_Sequencia := 1;
  VF_SequenciaAutomacaoColeta := 1;
  VF_ServicoAtual := '';

  VF_Host := VP_Host;
  VF_Porta := VP_Porta;
  VF_ArquivoLog := VP_ArquivoLog;

  VF_Aplicacao := VP_Aplicacao;
  VF_AplicacaoTela := VP_AplicacaoTela;
  VF_Estabelecimento := VP_Estabelecimento;
  VF_Loja := VP_Loja;
  VF_Terminal := VP_Terminal;

  VF_IdTCPCliente := TIdTCPClient.Create;

  VF_IdTCPCliente.Host := VP_Host;
  VF_IdTCPCliente.Port := VP_Porta;

  inherited Create;
end;

destructor TVBIIntergrador.Destroy;
begin
  if Assigned(VF_IdTCPCliente) then
    FreeAndNil(VF_IdTCPCliente);

  inherited Destroy;
end;

function TVBIIntergrador.conectar: integer;
begin
  Result := 0;

  if VF_IdTCPCliente.Connected then
    Exit;

  try
    begin
      VF_IdTCPCliente.Connect;
      VF_IdTCPCliente.IOHandler.MaxLineLength := MaxInt;
      VF_IdTCPCliente.IOHandler.SendBufferSize := MaxInt;
      VF_IdTCPCliente.IOHandler.RecvBufferSize := maxInt;
    end;
  except
    on e: Exception do
    begin
      GravaLog(VF_ArquivoLog, 0, '',
        'TVBIIntergrador.ConectarCliente', '210620240852', ' ' +
        e.ClassName + '/' + e.Message, '', 103, 1);
      Result := 103;
      Exit;
    end;
  end;
end;

function TVBIIntergrador.desconectar: integer;
begin
  Result := 0;

  if not VF_IdTCPCliente.Connected then
    Exit;

  VF_IdTCPCliente.Disconnect;
end;

function TVBIIntergrador.enviarMensagemSocket(VP_DadosEnviados: string;
  var VO_DadosRecebidos: string): TVBIRetorno;
begin
  limparVBIRetorno(Result);
  VO_DadosRecebidos := '';

  Result.erro := conectar;

  if Result.erro <> 0 then
    Exit;

  VF_idTCPCliente.Socket.Write(VP_DadosEnviados);
  VF_idTCPCliente.Socket.Write(C_Comunicacao_Terminacao);

  VO_DadosRecebidos := VF_idTCPCliente.Socket.ReadLn(C_Comunicacao_Terminacao);
end;

function TVBIIntergrador.enviarMensagem(VP_DadosEnviados: TTagVBI;
  var VO_DadosRecebidos: TTagVBI): TVBIRetorno;
var
  VL_Dados: string;
begin
  limparVBIRetorno(Result);
  VL_Dados := '';

  if VP_DadosEnviados.automacaoColeta then
  begin
    VP_DadosEnviados.addTag('automacao_coleta_sequencial', IntToStr(
      VF_SequenciaAutomacaoColeta));
    VP_DadosEnviados.addTag('automacao_coleta_timeout', IntToStr(C_TempoAgurde));
  end
  else
  begin
    if (upperCase(VF_ServicoAtual) <> VP_DadosEnviados.getTag('servico')) and
      (VF_Sequencia <> 1) then
      VF_Sequencia := VF_Sequencia + 1;

    if upperCase(VF_ServicoAtual) <> VP_DadosEnviados.getTag('servico') then
      VF_ServicoAtual := VP_DadosEnviados.getTag('servico');

    VP_DadosEnviados.addTag('sequencial', IntToStr(VF_Sequencia));
  end;

  Result := enviarMensagemSocket(VP_DadosEnviados.tagsAsString, VL_Dados);

  if Result.erro <> 0 then
    Exit;

  Result.erro := VO_DadosRecebidos.carregaMensagem(VL_Dados);
  if Result.erro <> 0 then
  begin
    Result.descricao := 'Erro ao carregar a mensagem recebida do socket';
    Exit;
  end;

  if VO_DadosRecebidos.automacaoColeta then
  begin
    VF_SequenciaAutomacaoColeta :=
      StrToInt(VO_DadosRecebidos.getTag('automacao_coleta_sequencial'));

    if VO_DadosRecebidos.getTag('automacao_coleta_mensagem').StartsWith(
      'Transacao canceladaSequencial recebido') then
    begin
      VP_DadosEnviados.addTag('automacao_coleta_sequencial', IntToStr(
        VF_SequenciaAutomacaoColeta));
      Result := enviarMensagemSocket(VP_DadosEnviados.tagsAsString, VL_Dados);

      if Result.erro <> 0 then
        Exit;

      Result.erro := VO_DadosRecebidos.carregaMensagem(VL_Dados);
      if Result.erro <> 0 then
      begin
        Result.descricao := 'Erro ao carregar a mensagem recebida do socket';
        Exit;
      end;
    end;

    Exit;
  end;

  if VO_DadosRecebidos.getTag('retorno') = '2' then
  begin
    VF_Sequencia := StrToInt(VO_DadosRecebidos.getTag('sequencial'));
    VP_DadosEnviados.addTag('sequencial', IntToStr(VF_Sequencia));

    Result := enviarMensagemSocket(VP_DadosEnviados.tagsAsString, VL_Dados);

    if Result.erro <> 0 then
      Exit;

    Result.erro := VO_DadosRecebidos.carregaMensagem(VL_Dados);
    if Result.erro <> 0 then
    begin
      Result.descricao := 'Erro ao carregar a mensagem recebida do socket';
      Exit;
    end;
  end;

  if not ((VO_DadosRecebidos.getTag('retorno') = '1') or
    (VO_DadosRecebidos.getTag('retorno') = '0')) then
  begin
    Result.descricao := VO_DadosRecebidos.getTag('mensagem');
    Result.erro := 1;
    Exit;
  end;

end;

function TVBIIntergrador.inicializarTransacao: TVBIRetorno;
var
  VL_DadosEnviados, VL_DadosRecebidos: TTagVBI;
  VL_Versao: pansichar;
begin
  limparVBIRetorno(Result);
  VL_Versao := '';
  try
    VL_DadosEnviados := TTagVBI.Create;
    VL_DadosRecebidos := TTagVBI.Create;

    versao(VL_Versao);

    VL_DadosEnviados.addTag('versao', VL_Versao);
    VL_DadosEnviados.addTag('retorno', '1');
    VL_DadosEnviados.addTag('servico', 'iniciar');
    VL_DadosEnviados.addTag('aplicacao', VF_Aplicacao);
    VL_DadosEnviados.addTag('aplicacao_tela', VF_AplicacaoTela);
    VL_DadosEnviados.addTag('estabelecimento', VF_Estabelecimento);
    VL_DadosEnviados.addTag('loja', VF_Loja);
    VL_DadosEnviados.addTag('terminal', VF_Terminal);

    Result := enviarMensagem(VL_DadosEnviados, VL_DadosRecebidos);

    if Result.erro <> 0 then
      Exit;

    // testar do valor do estado retornado para ver se o pinpad foi carregado com sucesso
  finally
    VL_DadosEnviados.Free;
    VL_DadosRecebidos.Free;
  end;
end;

function TVBIIntergrador.venderCartaoCredito: TVBIRetorno;
begin
  limparVBIRetorno(Result);

  // consultar dados da venda valor,parcela
end;

end.
