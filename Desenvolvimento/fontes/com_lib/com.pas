unit com;

{$mode ObjFPC}{$H+}

interface

uses
  Classes,
  SysUtils,
  comunicador,
  funcoes,
  LbClass,
  def;

  { TDCom }
type

  ThProcesso = class(TThread)
  private
    fcom: pointer;
    fdados: ansistring;
    fprocedimento: TRetorno;
    ftempo: integer;
    ftransmissaoID: string;
  protected
    procedure Execute; override;
  public
    constructor Create(VP_Com: Pointer; VP_Suspenso: boolean; VP_Transmissao_ID, VP_Dados: ansistring; VP_Procedimento: TRetorno; VP_TempoAguarda: integer);

  end;



  TDCom = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);

  private

  public
    F_Inicializado: boolean;
    F_ArquivoLog: string;
    F_Comunicador: TDComunicador;
  end;


function inicializar(var VO_Com: Pointer; VP_Procedimento: TRetorno; VP_ArquivoLog: PChar): integer; cdecl;
function finalizar(VP_Com: pointer): integer; cdecl;
function desconectar(VP_Com: pointer): integer; cdecl;
function login(VP_Com: pointer; VP_Host: PChar; VP_Porta: integer; VP_ChaveComunicacao: PChar; VP_Versao_Comunicacao: integer; VP_Senha: PChar; VP_Tipo: PChar;
  VP_Terminal_ID: integer; VP_Identificacao: PChar): integer; cdecl;
function solicitacao(VP_Com: pointer; VP_Dados: PChar; VP_Procedimento: TRetorno; VP_TempoAguarda: integer): integer; cdecl;
function solicitacaoblocante(VP_Com: pointer; VP_Dados: PChar; var VO_Retorno: PChar; VP_TempoAguarda: integer): integer; cdecl;
function opentefstatus(VP_Com: pointer; var VO_StatusRetorno: integer): integer; cdecl;
procedure alterarnivellog(VP_Nivel: integer); cdecl;


implementation

{$R *.lfm}

{ TDCom }


{ TDCom }


constructor ThProcesso.Create(VP_Com: Pointer; VP_Suspenso: boolean; VP_Transmissao_ID, VP_Dados: ansistring; VP_Procedimento: TRetorno; VP_TempoAguarda: integer);
begin
  FreeOnTerminate := True;
  fcom := VP_Com;
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
    VL_Erro := TDCom(fcom).F_Comunicador.ClienteTransmiteSolicitacao(TDCom(fcom).F_Comunicador, ftransmissaoID, VL_Mensagem, VL_Mensagem, nil, ftempo, True);
    fprocedimento(TDCom(fcom).F_Comunicador.V_ClassePai, PChar(ftransmissaoID), 0, VL_Erro, PChar(VL_Mensagem.TagsAsString));
  finally
    VL_Mensagem.Free;
  end;
end;

procedure TDCom.DataModuleCreate(Sender: TObject);
begin
  F_Inicializado := False;
end;

function inicializar(var VO_Com: Pointer; VP_Procedimento: TRetorno; VP_ArquivoLog: PChar): integer; cdecl;
begin
  if Assigned(VO_Com) and TDCom(VO_Com).F_Inicializado then
  begin
    Result := 112;
    Exit;
  end;

  VO_Com := TDCom.Create(nil);
  TDCom(VO_Com).F_Comunicador := TDComunicador.Create(nil);
  TDCom(VO_Com).F_Comunicador.V_ClienteRecebimento := VP_Procedimento;
  TDCom(VO_Com).F_ArquivoLog := VP_ArquivoLog;

  TDCom(VO_Com).F_Inicializado := True;

  Result := 0;

end;

function finalizar(VP_Com: Pointer): integer; cdecl;
begin
  if not Assigned(VP_Com) then
  begin
    Result := 130;
    Exit;
  end;

  try
    if not TDCom(VP_Com).F_Inicializado then
    begin
      Result := 132;
      exit;
    end;

    TDCom(VP_Com).F_Inicializado := False;
    TDCom(VP_Com).F_Comunicador.Free;
    TDCom(VP_Com).Free;
    VP_Com := nil;

    Result := 0;

  except
    on e: Exception do
    begin
      Result := 1;
      GravaLog(TDCom(VP_Com).F_ArquivoLog, 0, '', 'com_lib', '160720241054', 'Erro na finalizar ' + e.ClassName + '/' + e.Message, '', 1, 1);
    end;
  end;

end;

function desconectar(VP_Com: pointer): integer; cdecl;
begin
  Result := 0;

  if not Assigned(VP_Com) then
  begin
    Result := 130;
    Exit;
  end;

  TDCom(VP_Com).F_Comunicador.DesconectarCliente(TDCom(VP_Com).F_Comunicador);
end;

function login(VP_Com: pointer; VP_Host: PChar; VP_Porta: integer; VP_ChaveComunicacao: PChar; VP_Versao_Comunicacao: integer; VP_Senha: PChar; VP_Tipo: PChar;
  VP_Terminal_ID: integer; VP_Identificacao: PChar): integer; cdecl;
var
  VL_Mensagem: TMensagem;
  VL_Comando: string;
  VL_Erro: string;
  VL_Transmissao_id: string;
begin
  Result := 0;
  VL_Comando := '';
  VL_Transmissao_id := '';
  VL_Mensagem := TMensagem.Create;
  try
    if not Assigned(VP_Com) then
    begin
      Result := 130;
      Exit;
    end;

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

    if length(VP_ChaveComunicacao) = 0 then
    begin
      Result := 15;
      exit;
    end;

    if Length(VP_Tipo) = 0 then
    begin
      Result := 42;
      Exit;
    end;

    if ((TDCom(VP_Com).F_Comunicador.V_ConexaoCliente.ServidorHost <> VP_Host) or (TDCom(VP_Com).F_Comunicador.V_ConexaoCliente.ServidorPorta <> VP_Porta) or
      (F_Comunicacao <> VP_ChaveComunicacao) or (TDCom(VP_Com).F_Comunicador.V_ConexaoCliente.Identificador <> VP_Identificacao) or (F_Versao_Comunicacao <> VP_Versao_Comunicacao)) then
    begin
      TDCom(VP_Com).F_Comunicador.DesconectarCliente(TDCom(VP_Com).F_Comunicador);
      TDCom(VP_Com).F_Comunicador.V_ConexaoCliente.ServidorHost := VP_Host;
      TDCom(VP_Com).F_Comunicador.V_ConexaoCliente.ServidorPorta := VP_Porta;
      TDCom(VP_Com).F_Comunicador.V_ConexaoCliente.Identificador := VP_Identificacao;
      F_Comunicacao := VP_ChaveComunicacao;
    end;

    TDCom(VP_Com).F_Comunicador.V_ConexaoCliente.Aes.GenerateKey(F_Comunicacao);

    Result := TDCom(VP_Com).F_Comunicador.ConectarCliente(TDCom(VP_Com).F_Comunicador);

    if Result <> 0 then
      Exit;

    if TDCom(VP_Com).F_Comunicador.V_ConexaoCliente.Status = csLogado then
    begin
      Result := 0;
      Exit;
    end;

    if TDCom(VP_Com).F_Comunicador.V_ConexaoCliente.Status > csLink then
    begin
      VL_Mensagem.Limpar;

      VL_Mensagem.AddComando('0001', ''); // login
      VL_Mensagem.AddTag('0005', IntToStr(C_Versao[0]) + '.' + IntToStr(C_Versao[1]) + '.' + IntToStr(C_Versao[2]));  // versao da lib
      VL_Mensagem.AddTag('0006', IntToStr(C_Mensagem)); // versao da mensagem
      VL_Mensagem.AddTag('00A3', IntToStr(VP_Terminal_ID)); // TERMINAL ID
      VL_Mensagem.AddTag('0035', VP_Senha); // senha do terminal
      VL_Mensagem.AddTag('0037', VP_Tipo);  // tipo de permissao do terminal
      VL_Mensagem.AddTag('003D', C_Programa); // NOME DA DLL

      GravaLog(TDCom(VP_Com).F_ArquivoLog, 0, 'login', 'com_lib', '171120231101', 'mensagem enviada', VL_Mensagem.TagsAsString, 0, 2);

      //envia ao cliente
      Result := TDCom(VP_Com).F_Comunicador.ClienteTransmiteSolicitacao(TDCom(VP_Com).F_Comunicador, VL_Transmissao_id, VL_Mensagem, VL_Mensagem, nil, 10000, True);

      if Result <> 0 then
      begin
        GravaLog(TDCom(VP_Com).F_ArquivoLog, 0, 'login', 'com_lib', '171120231102', 'Erro ao enviar mensagem', VL_Mensagem.TagsAsString, Result, 1);
        Exit;
      end;

      VL_Mensagem.GetTag('004D', VL_Erro); // tag com erro

      if VL_Erro <> '0' then
      begin
        Result := StrToInt(VL_Erro);
        GravaLog(TDCom(VP_Com).F_ArquivoLog, 0, 'login', 'com_lib', '171120231104', 'Mensagem recebida com erro', VL_Mensagem.TagsAsString, Result, 1);
        Exit;
      end;

      TDCom(VP_Com).F_Comunicador.V_ConexaoCliente.Status := csLogado;

    end;

  finally
    VL_Mensagem.Free;
  end;

end;

function solicitacao(VP_Com: pointer; VP_Dados: PChar; VP_Procedimento: TRetorno; VP_TempoAguarda: integer): integer; cdecl;
var
  VL_Th: ThProcesso;
begin
  Result := 0;

  if not Assigned(VP_Com) then
  begin
    Result := 130;
    Exit;
  end;

  VL_Th := ThProcesso.Create(VP_Com, True, '', VP_Dados, VP_Procedimento, VP_TempoAguarda);
  VL_Th.Start;
end;

function solicitacaoblocante(VP_Com: pointer; VP_Dados: PChar; var VO_Retorno: PChar; VP_TempoAguarda: integer): integer; cdecl;
var
  VL_String, VL_Transamissao_ID: string;
  VL_Mensagens: TMensagem;
begin
  VL_String := '';
  VL_Transamissao_ID := '';

  if not Assigned(VP_Com) then
  begin
    Result := 130;
    Exit;
  end;

  try
    VL_String := VP_Dados;
    VL_Mensagens := TMensagem.Create;
    VL_Mensagens.CarregaTags(VL_String);

    GravaLog(TDCom(VP_Com).F_ArquivoLog, 0, 'solicitacaoblocante', 'com_lib', '171120231059', 'Mensagem  enviada', VL_String, 0, 2);

    Result := TDCom(VP_Com).F_Comunicador.ClienteTransmiteSolicitacao(TDCom(VP_Com).F_Comunicador, VL_Transamissao_ID, VL_Mensagens, VL_Mensagens, nil, VP_TempoAguarda, True);

    if Result <> 0 then
      GravaLog(TDCom(VP_Com).F_ArquivoLog, 0, 'solicitacaoblocante', 'com_lib', '171120231059', 'Erro ao enviar mensagem', VL_String, Result, 1);

    VL_Mensagens.TagToStr(VL_String);

    VO_Retorno := StrAlloc(Length(VL_String) + 1);
    StrPCopy(VO_Retorno, VL_String);

  finally
    VL_Mensagens.Free;
  end;
end;

function opentefstatus(VP_Com: pointer; var VO_StatusRetorno: integer): integer; cdecl;
begin
  Result := 0;

  if not Assigned(VP_Com) then
  begin
    Result := 130;
    Exit;
  end;

  VO_StatusRetorno := Ord(TDCom(VP_Com).F_Comunicador.V_ConexaoCliente.Status);
end;

procedure alterarnivellog(VP_Nivel: integer); cdecl;
begin
  F_NivelLog := VP_Nivel;
end;

end.
