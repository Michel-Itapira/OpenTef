unit comunicadorVbi;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, IdTCPClient;

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
    fTag: array of TTagVBIDados;
    function formatarDadosMensagemLimite(VP_Mensagem: string): string;
  public
    procedure addTag(VP_Tag: string; VP_Dados: string);
    function getTag(VP_Tag: string): string;
    function GetTagIdx(VP_Posicao: integer; var VO_Tag: string; var VO_Dados: string): integer;
    function getTagAsArray(VP_Tag: string): TStringArray;
    procedure limpar;
    function tagsAsString: string;
    function tagCount: integer;
    function carregaMensagem(VP_Mensagem: string): integer;
    function automacaoColeta: boolean;
    procedure Copiar(VP_Tag: TTagVBI);
  end;

  TComunicadorVBI = class
  private
    fSequencia: integer;
    fSequenciaAutomacaoColeta: integer;
    fServicoAtual: string;

    fIdTCPCliente: TIdTCPClient;
    fHost: string;
    fPorta: integer;

    procedure concentrar;

    procedure antesEnviarMensagem(var VO_DadosEnviados: TTagVBI);
    function enviarMensagemSocket(VP_DadosEnviados: string): string;
    function verificaErroSequecial(var VO_DadosEnviados: TTagVBI; var VO_DadosRecebidos: TTagVBI): integer;
    function verificaTagErro(VP_DadosEnviados: TTagVBI): TVBIRetorno;
  public
    constructor Create;
    destructor Destroy; override;

    procedure setConfig(VP_Host: string; VP_Porta: integer);

    function enviarMensagem(VP_DadosEnviados: TTagVBI; var VO_DadosRecebidos: TTagVBI): TVBIRetorno;
  end;

procedure limparRetornoVBI(var VO_Retorno: TVBIRetorno);

const
  C_Comunicacao_Terminacao: string = char($0D) + char($0A) + char($09) + char($09) + char($0D) + char($0A) + char($09) + char($09) + char($09) + char($0D) +
    char($0A) + char($09) + char($09) + char($0D) + char($0A) + char($09);
  C_TempoAgurde: integer = 60;


implementation

procedure limparRetornoVBI(var VO_Retorno: TVBIRetorno);
begin
  VO_Retorno.descricao := '';
  VO_Retorno.erro := 0;
end;

procedure TTagVBI.addTag(VP_Tag: string; VP_Dados: string);
var
  VL_I: integer;
  VL_Dados: string;
begin
  VL_Dados := '';
  VL_Dados := VP_Dados;
  VL_Dados := StringReplace(VL_Dados, #$00, '', [rfReplaceAll]);

  if length(fTag) >= 1 then
  begin
    for VL_I := 0 to length(fTag) - 1 do
    begin
      if fTag[VL_I].tag = VP_Tag then
      begin
        fTag[VL_I].dados := VL_Dados;
        Exit;
      end;
    end;
  end;

  SetLength(fTag, Length(fTag) + 1);
  fTag[Length(fTag) - 1].tag := VP_Tag;
  fTag[Length(fTag) - 1].dados := VL_Dados;
end;

procedure TTagVBI.limpar;
begin
  SetLength(fTag, 0);
end;

function TTagVBI.tagCount: integer;
begin
  Result := Length(fTag) - 1;
end;

function TTagVBI.tagsAsString: string;
var
  VL_I: integer;
  VL_Dados: string;
begin
  Result := '';

  for VL_I := 0 to length(fTag) - 1 do
  begin
    VL_Dados := '';
    VL_Dados := StringReplace(fTag[VL_I].dados, '"', '""', [rfReplaceAll]);
    Result := Result + fTag[VL_I].tag + '="' + VL_Dados + '"';
  end;
end;

function TTagVBI.getTag(VP_Tag: string): string;
var
  VL_I: integer;
begin
  Result := '';

  for VL_I := 0 to length(fTag) - 1 do
  begin
    if fTag[VL_I].tag = VP_Tag then
    begin
      Result := fTag[VL_I].dados;
      Exit;
    end;
  end;
end;

function TTagVBI.GetTagIdx(VP_Posicao: integer; var VO_Tag: string; var VO_Dados: string): integer;
begin
  Result := 0;
  VO_Dados := '';
  VO_Tag := '';
  if Length(fTag) > VP_Posicao then
  begin
    VO_Tag := fTag[VP_Posicao].tag;
    VO_Dados := fTag[VP_Posicao].dados;
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

  for VL_I := 0 to length(fTag) - 1 do
  begin
    if fTag[VL_I].tag = VP_Tag then
    begin
      VL_Dados := fTag[VL_I].dados;
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

    if length(VL_Mensagem) > 1 then
    begin
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

        VL_Mensagem := Copy(VL_Mensagem, length(VL_Aspas) + 1, length(VL_Mensagem) - length(VL_Aspas));
        VL_LetraAnterior := '"';
        continue;
      end;
    end;

    break;
  end;
end;

function TTagVBI.automacaoColeta: boolean;
var
  VL_I: integer;
begin
  Result := False;

  for VL_I := 0 to length(fTag) - 1 do
  begin
    if fTag[VL_I].tag.StartsWith('automacao_coleta') then
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
    VL_Mensagem := Copy(VL_Mensagem, length(VL_Dados) + 2, length(VL_Mensagem) - length(VL_Dados) - 1);

    VL_Dados := StringReplace(VL_Dados, '""', '"', [rfReplaceAll]);
    self.addTag(VL_Campo, VL_Dados);
  end;
end;

constructor TComunicadorVBI.Create;
begin
  fSequencia := 1;
  fSequenciaAutomacaoColeta := 1;
  fServicoAtual := '';
  fIdTCPCliente := TIdTCPClient.Create;
  inherited Create;
end;

destructor TComunicadorVBI.Destroy;
begin
  fIdTCPCliente.Free;
  inherited Destroy;
end;

procedure TComunicadorVBI.concentrar;
begin
  if fIdTCPCliente.Connected then
    Exit;

  fIdTCPCliente.Host := fHost;
  fIdTCPCliente.Port := fPorta;
  fIdTCPCliente.Connect;
  fIdTCPCliente.IOHandler.MaxLineLength := MaxInt;
  fIdTCPCliente.IOHandler.SendBufferSize := MaxInt;
end;

procedure TComunicadorVBI.setConfig(VP_Host: string; VP_Porta: integer);
begin
  if (fHost = VP_Host) and (fPorta = VP_Porta) then
    Exit;

  fHost := VP_Host;
  fPorta := VP_Porta;

  fIdTCPCliente.Disconnect;

  concentrar;
end;

procedure TComunicadorVBI.antesEnviarMensagem(var VO_DadosEnviados: TTagVBI);
begin
  if VO_DadosEnviados.automacaoColeta then
  begin
    VO_DadosEnviados.addTag('automacao_coleta_sequencial', IntToStr(fSequenciaAutomacaoColeta));
    VO_DadosEnviados.addTag('automacao_coleta_timeout', IntToStr(C_TempoAgurde));
  end
  else
  begin
    if (upperCase(fServicoAtual) <> VO_DadosEnviados.getTag('servico')) and (fSequencia <> 1) then
      fSequencia := fSequencia + 1;

    if upperCase(fServicoAtual) <> VO_DadosEnviados.getTag('servico') then
      fServicoAtual := VO_DadosEnviados.getTag('servico');

    VO_DadosEnviados.addTag('sequencial', IntToStr(fSequencia));
  end;
end;

function TComunicadorVBI.enviarMensagem(VP_DadosEnviados: TTagVBI; var VO_DadosRecebidos: TTagVBI): TVBIRetorno;
var
  VL_Dados: string;
begin
  limparRetornoVBI(Result);
  VL_Dados := '';

  antesEnviarMensagem(VP_DadosEnviados);

  VL_Dados := enviarMensagemSocket(VP_DadosEnviados.tagsAsString);
  Result.erro := VO_DadosRecebidos.carregaMensagem(VL_Dados);

  if Result.erro <> 0 then
  begin
    Result.descricao := 'Erro ao carregar a mensagem recebida do socket';
    Exit;
  end;

  Result.erro := verificaErroSequecial(VP_DadosEnviados, VO_DadosRecebidos);

  if Result.erro <> 0 then
    Exit;

  Result := verificaTagErro(VO_DadosRecebidos);
end;

function TComunicadorVBI.enviarMensagemSocket(VP_DadosEnviados: string): string;
begin
  Result := '';

  fIdTCPCliente.Socket.Write(VP_DadosEnviados);
  fIdTCPCliente.Socket.Write(C_Comunicacao_Terminacao);

  Result := fIdTCPCliente.Socket.ReadLn(C_Comunicacao_Terminacao);
end;

function TComunicadorVBI.verificaErroSequecial(var VO_DadosEnviados: TTagVBI; var VO_DadosRecebidos: TTagVBI): integer;
var
  VL_Dados: string;
begin
  Result := 0;
  VL_Dados := '';

  if VO_DadosRecebidos.automacaoColeta then
  begin
    fSequenciaAutomacaoColeta := StrToInt(VO_DadosRecebidos.getTag('automacao_coleta_sequencial'));

    if VO_DadosRecebidos.getTag('automacao_coleta_mensagem').StartsWith('Transacao canceladaSequencial recebido') then
    begin
      VO_DadosEnviados.addTag('automacao_coleta_sequencial', IntToStr(fSequenciaAutomacaoColeta));
      VL_Dados := enviarMensagemSocket(VO_DadosEnviados.tagsAsString);
      Result := VO_DadosRecebidos.carregaMensagem(VL_Dados);

      if Result <> 0 then
        Exit;

    end;

    exit;
  end;

  if VO_DadosRecebidos.getTag('retorno') = '2' then
  begin
    fSequencia := StrToInt(VO_DadosRecebidos.getTag('sequencial'));
    VO_DadosEnviados.addTag('sequencial', IntToStr(fSequencia));

    VL_Dados := enviarMensagemSocket(VO_DadosEnviados.tagsAsString);
    Result := VO_DadosRecebidos.carregaMensagem(VL_Dados);

    if Result <> 0 then
      Exit;
  end;

end;

function TComunicadorVBI.verificaTagErro(VP_DadosEnviados: TTagVBI): TVBIRetorno;
begin
  limparRetornoVBI(Result);

  if VP_DadosEnviados.tagCount <= 0 then
  begin
    Result.descricao := 'Tag está vazia';
    Result.erro := 1;
    Exit;
  end;

  if VP_DadosEnviados.getTag('retorno') <> '' then
  begin
    Result.erro := StrToInt(VP_DadosEnviados.getTag('retorno'));

    if ((Result.erro = 0) or (Result.erro = 1)) then
    begin
      Result.erro := 0;
      Exit;
    end;

    Result.descricao := VP_DadosEnviados.getTag('mensagem');
  end;
end;

end.
