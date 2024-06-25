unit mcom;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, def, comunicador, IdContext, funcoes, LbRSA,
  LbAsym, LbClass, md5, LbCipher;

type

  { ThProcesso }

  ThProcesso = class(TThread)
  private
    fdados: ansistring;
    fprocedimento: TRetorno;
    fTransmissaoID: string;

  protected
    procedure Execute; override;
  public
    constructor Create(VP_Suspenso: boolean; VP_Transmissao_ID, VP_Dados: ansistring;
      VP_Procedimento: TRetorno);

  end;


  { TDMCom }

  TDMCom = class(TDataModule)
    CriptoAes: TLbRijndael;
    CriptoRsa: TLbRSA;

  private

  public
    VF_Chave, VF_Identificacao, VF_IP_Caixa, VF_IP_Servico: string;
    VF_PortaCaixa, VF_PortaServico: integer;

    ModuloPublico: ansistring;
    ExpoentePublico: ansistring;
    TamanhoPublico: integer;
    ChaveComunicacao: ansistring;

    function iniciar(VP_Chave, VP_IP_Caixa, VP_IP_Servico: string;
      VP_PortaCaixa, VP_PortaServico: integer; VP_Identificacao: string): integer;
    function RecebeComandoCaixa(VP_Erro: integer;
      VP_Transmissao_ID, VP_DadosRecebidos: string; VP_Conexao_ID: integer;
      VP_ClienteIP: string; VP_Terminal_Status: TConexaoStatus): integer;
    function RecebeComandoServico(VP_Erro: integer;
      VP_Transmissao_ID, VP_DadosRecebidos: string; VP_Conexao_ID: integer;
      VP_ClienteIP: string; VP_Terminal_Status: TConexaoStatus): integer;

    function comando0001(VP_Transmissao_ID: string; VP_Mensagem: TMensagem;
      VP_Conexao_ID: integer; VP_DComunicador: TDComunicador;
      VP_Terminal_Status: TConexaoStatus; VP_ClienteIP: string): integer;
    function comando0021(VP_Transmissao_ID: string; VP_Mensagem: TMensagem;
      VP_Conexao_ID: integer; VP_DComunicador: TDComunicador;
      VP_Terminal_Status: TConexaoStatus): integer;
    function comando0111(VP_Transmissao_ID: string; VP_Mensagem: TMensagem;
      VP_Conexao_ID: integer; VP_DComunicador: TDComunicador): integer;
    function TransmissaoComando(AOwner: Pointer; VP_Conexao_ID: integer;
      VP_Transmissao_ID, VP_Comando: string; var VO_Dados: string): integer;


  end;

function iniciarconexao(VP_ArquivoLog, VP_Chave, VP_IP_Caixa, VP_IP_Servico: PChar;
  VP_PortaCaixa, VP_PortaServico: integer;
  VO_RetornoCaixa, VO_RetornoServico: TServidorRecebimentoLib;
  VP_Identificacao: PChar; VP_NivelLog: integer): integer; cdecl;
function finalizaconexao(): integer; cdecl;
function respondecaixa(VP_Transmissao_ID, VP_Dados: PChar;
  VP_ID: integer): integer; cdecl;
function respondeservico(VP_Transmissao_ID, VP_Dados: PChar;
  VP_ID: integer): integer; cdecl;
procedure alterarnivellog(VP_Nivel: integer); cdecl;

var
  DMCom: TDMCom;
  F_Mensagem: TMensagem;
  F_ArquivoLog: string;
  F_Inicializado: boolean = False;
  F_ChaveTerminal: ansistring;
  F_Versao_Comunicacao: integer;
  F_ComunicadorCaixa: TDComunicador;
  F_ComunicadorServico: TDComunicador;
  F_ServidorRecebimentoLibCaixa, F_ServidorRecebimentoLibServico:
  TServidorRecebimentoLib;

procedure ComandoCaixa(VP_Erro: integer; VP_Transmissao_ID, VP_DadosRecebidos: string;
  VP_Conexao_ID: integer; VP_Terminal_Tipo: string; VP_Terminal_ID: integer;
  VP_DOC: string; VP_Terminal_Status: TConexaoStatus;
  VP_Terminal_Identificacao: string; VP_Permissao: TPermissao; VP_ClienteIP: string);
procedure ComandoServico(VP_Erro: integer; VP_Transmissao_ID, VP_DadosRecebidos: string;
  VP_Conexao_ID: integer; VP_Terminal_Tipo: string; VP_Terminal_ID: integer;
  VP_DOC: string; VP_Terminal_Status: TConexaoStatus;
  VP_Terminal_Identificacao: string; VP_Permissao: TPermissao; VP_ClienteIP: string);


implementation


{$R *.lfm}


function iniciarconexao(VP_ArquivoLog, VP_Chave, VP_IP_Caixa, VP_IP_Servico: PChar;
  VP_PortaCaixa, VP_PortaServico: integer;
  VO_RetornoCaixa, VO_RetornoServico: TServidorRecebimentoLib;
  VP_Identificacao: PChar; VP_NivelLog: integer): integer; cdecl;
begin
  try
    F_ArquivoLog := string(VP_ArquivoLog);
    F_NivelLog := VP_NivelLog;

    GravaLog(VP_ArquivoLog, 0, '', 'mcom', '11122023214806', 'f_arquivo:' +
      F_ArquivoLog + ' vparquivo:' + VP_ArquivoLog + ' vp_chave:' +
      VP_Chave + ' identificacao:' + VP_Identificacao, '', 0, 2);


    DMCom := TDMCom.Create(nil);
    Result := DMCom.iniciar(VP_Chave, VP_IP_Caixa, VP_IP_Servico,
      VP_PortaCaixa, VP_PortaServico, VP_Identificacao);
    F_ServidorRecebimentoLibCaixa := VO_RetornoCaixa;
    F_ServidorRecebimentoLibServico := VO_RetornoServico;

  except
    on e: Exception do
    begin
      Result := 1;
      GravaLog(F_ArquivoLog, 0, 'iniciarconexao', 'mcom',
        '070620241647', e.ClassName + '/' + e.Message, '', Result, 1);
    end;
  end;
end;

function finalizaconexao: integer; cdecl;
begin
  try
    if Assigned(F_ComunicadorCaixa.V_ThRecebeEscuta) then
    begin
      //F_ComunicadorCaixa.V_ThRecebeEscuta.Parar;
      F_ComunicadorCaixa.V_ThRecebeEscuta.Terminate;
    end;

    if Assigned(F_ComunicadorServico.V_ThRecebeEscuta) then
    begin
      //F_ComunicadorServico.V_ThRecebeEscuta.Parar;
      F_ComunicadorServico.V_ThRecebeEscuta.Terminate;
    end;


    F_ComunicadorCaixa.DesconectarCliente(F_ComunicadorCaixa);
    F_ComunicadorServico.DesconectarCliente(F_ComunicadorServico);

    F_ComunicadorServico.Free;
    F_ComunicadorCaixa.Free;
    DMCom.Free;
    F_Mensagem.Free;
    Result := 0;

  except
    on e: Exception do
    begin
      Result := 1;
      GravaLog(F_ArquivoLog, 0, 'finalizaconexao', 'mcom',
        '070620241648', e.ClassName + '/' + e.Message, '', Result, 1);
    end;
  end;
end;

function respondecaixa(VP_Transmissao_ID, VP_Dados: PChar;
  VP_ID: integer): integer; cdecl;
var
  VL_Mensagem, VL_Chaves: TMensagem;
  VL_TagDados: string;
  VL_ModuloPublico: ansistring;
  VL_ExpoentePublico: ansistring;
  VL_TamanhoPublico: int64;
  VL_Rsa: TLbRSA;
  VL_Aes: TLbRijndael;
  VL_ChaveComunicacao: string;
begin
  VL_TagDados := '';
  VL_ChaveComunicacao := '';
  VL_Rsa := nil;
  VL_Aes := nil;
  try
    try
      VL_Mensagem := TMensagem.Create;
      VL_Chaves := TMensagem.Create;

      Result := VL_Mensagem.CarregaTags(VP_Dados);

      if Result <> 0 then
      begin
        GravaLog(F_ArquivoLog, 0, '', 'mcom', '290820221240', '', '', Result, 1);
        Exit;
      end;

      VL_ModuloPublico := '';
      VL_ExpoentePublico := '';
      VL_TamanhoPublico := 0;


      if VL_Mensagem.GetTag('00E3', VL_TagDados) = 0 then
      begin
        VL_Mensagem.GetTag('0028', VL_TamanhoPublico);        //tamanho chave
        VL_Mensagem.GetTag('0023', VL_ExpoentePublico);        //expoente
        VL_Mensagem.GetTag('0024', VL_ModuloPublico);        //modulos

        if VL_Mensagem.GetTagAsAstring('010E') <> '' then
          // chave de comunicacao criptografada aes da solicitação
        begin
          VL_ChaveComunicacao :=
            DMCom.CriptoRsa.DecryptString(VL_Mensagem.GetTagAsAstring('010E'));
          VL_Mensagem.AddTag('010F', VL_Mensagem.GetTagAsAstring('010E'));
          VL_Mensagem.AddTag('010E', '');
        end
        else
        if VL_Mensagem.GetTagAsAstring('010F') <> '' then
          // chave de comunicacao criptografada aes da resposta
        begin
          VL_ChaveComunicacao := DMCom.ChaveComunicacao;
        end;

        VL_Aes := TLbRijndael.Create(nil);
        VL_Aes.KeySize := F_ComunicadorServico.CriptoAes.KeySize;
        VL_Aes.CipherMode := F_ComunicadorServico.CriptoAes.CipherMode;
        VL_Aes.GenerateKey(VL_ChaveComunicacao);

        GravaLog(F_ArquivoLog, 0, 'respondecaixa', 'mcom',
          '131120230937', 'mensagem enviada descriptografada', VL_TagDados, 0, 2);

        VL_TagDados := VL_Aes.EncryptString(VL_TagDados);
        VL_Mensagem.AddTag('00E3', VL_TagDados);        // mensagem criptografada

        if VL_ChaveComunicacao = DMCom.ChaveComunicacao then
        begin
          if ((VL_ModuloPublico = '') or (VL_ExpoentePublico = '')) then
          begin
            VL_Chaves.AddComando('0111', 'S');
            VL_Chaves.AddTag('00F1', VL_Mensagem.GetTagAsAstring('00F1'));

            GravaLog(F_ArquivoLog, 0, 'respondecaixa', 'mcom',
              '131120230936', 'mensagem enviada', VL_Chaves.TagsAsString, 0, 2);

            Result :=
              F_ComunicadorServico.ServidorTransmiteSolicitacaoID(
              F_ComunicadorServico, 30000, True, nil, '', VL_Chaves, VL_Chaves, VP_ID);

            if Result <> 0 then
            begin
              GravaLog(F_ArquivoLog, 0, '', 'mcom',
                '310820221737', '', '', Result, 1);
              Exit;
            end;

            GravaLog(F_ArquivoLog, 0, 'respondecaixa', 'mcom',
              '131120230935', 'mensagem recebida', VL_Chaves.TagsAsString, 0, 2);

            VL_Chaves.GetTag('0028', VL_TamanhoPublico);        //tamanho chave
            VL_Chaves.GetTag('0023', VL_ExpoentePublico);        //expoente
            VL_Chaves.GetTag('0024', VL_ModuloPublico);        //modulos

            if (VL_ModuloPublico = '') or (VL_ExpoentePublico = '') then
              Result := 98;

            if Result <> 0 then
            begin
              GravaLog(F_ArquivoLog, 0, '', 'mcom',
                '310820221737', '', '', Result, 1);
              Exit;
            end;
          end;

          VL_Rsa := TLbRSA.Create(nil);
          VL_Rsa.PublicKey.KeySize := TLbAsymKeySize(VL_TamanhoPublico);
          VL_Rsa.PublicKey.ExponentAsString := VL_ExpoentePublico;
          VL_Rsa.PublicKey.ModulusAsString := VL_ModuloPublico;

          VL_ChaveComunicacao := VL_Rsa.EncryptString(DMCom.ChaveComunicacao);
          VL_Mensagem.AddTag('010E', VL_ChaveComunicacao);
          // chave de comunicacao criptografada
          VL_Mensagem.AddTag('010F', '');
        end;
      end;

      VL_Mensagem.AddTag('0028', DMCom.TamanhoPublico);        //tamanho chave
      VL_Mensagem.AddTag('0023', DMCom.ExpoentePublico);        //expoente
      VL_Mensagem.AddTag('0024', DMCom.ModuloPublico);        //modulos

      GravaLog(F_ArquivoLog, 0, 'respondecaixa', 'mcom', '131120230934',
        'mensagem enviada', VL_Mensagem.TagsAsString, 0, 2);

      Result := F_ComunicadorCaixa.ServidorTransmiteSolicitacaoID(
        F_ComunicadorCaixa, 3000, False, nil, VP_Transmissao_ID,
        VL_Mensagem, F_Mensagem, VP_ID);
      if Result <> 0 then
      begin
        GravaLog(F_ArquivoLog, 0, '', 'mcom', '200920221311', '', '', Result, 1);
        Exit;
      end;

    except
      on e: Exception do
      begin
        Result := 1;
        GravaLog(F_ArquivoLog, 0, 'respondecaixa', 'mcom',
          '070620241649', e.ClassName + '/' + e.Message, VP_Dados, Result, 1);
      end;
    end;

  finally
    VL_Mensagem.Free;
    VL_Chaves.Free;
    if Assigned(VL_Aes) then
      VL_Aes.Free;
    if Assigned(VL_Rsa) then
      VL_Rsa.Free;
  end;
end;

function respondeservico(VP_Transmissao_ID, VP_Dados: PChar;
  VP_ID: integer): integer; cdecl;
var
  VL_Mensagem, VL_Chaves: TMensagem;
  VL_TagDados: string;
  VL_Transmissao_ID: string;
  VL_ModuloPublico: ansistring;
  VL_ExpoentePublico: ansistring;
  VL_TamanhoPublico: int64;
  VL_Rsa: TLbRSA;
  VL_Aes: TLbRijndael;
  VL_ChaveComunicacao: string;
begin
  try
    try
      VL_Rsa := nil;
      VL_Aes := nil;
      VL_ChaveComunicacao := '';
      VL_TagDados := '';
      VL_Transmissao_ID := VP_Transmissao_ID;
      VL_Mensagem := TMensagem.Create;
      VL_Chaves := TMensagem.Create;

      Result := VL_Mensagem.CarregaTags(VP_Dados);

      if Result <> 0 then
      begin
        GravaLog(F_ArquivoLog, 0, '', 'mcom', '290820221350', '', '', Result, 1);
        Exit;
      end;

      VL_ModuloPublico := '';
      VL_ExpoentePublico := '';
      VL_TamanhoPublico := 0;

      if (VL_Mensagem.Comando = '0105') and (VL_Mensagem.ComandoDados = 'S') then
      begin
        VL_Mensagem.AddTag('010E', '');
        VL_Mensagem.AddTag('010F', DMCom.ChaveComunicacao);
      end;

      if VL_Mensagem.GetTag('00E3', VL_TagDados) = 0 then
      begin
        VL_Mensagem.GetTag('0028', VL_TamanhoPublico);        //tamanho chave
        VL_Mensagem.GetTag('0023', VL_ExpoentePublico);        //expoente
        VL_Mensagem.GetTag('0024', VL_ModuloPublico);        //modulos

        if VL_Mensagem.GetTagAsAstring('010E') <> '' then
          // chave de comunicacao criptografada aes da solicitação
        begin
          VL_ChaveComunicacao :=
            DMCom.CriptoRsa.DecryptString(VL_Mensagem.GetTagAsAstring('010E'));
          VL_Mensagem.AddTag('010F', VL_Mensagem.GetTagAsAstring('010E'));
          VL_Mensagem.AddTag('010E', '');
        end
        else
        if VL_Mensagem.GetTagAsAstring('010F') <> '' then
          // chave de comunicacao criptografada aes da resposta
          VL_ChaveComunicacao := DMCom.ChaveComunicacao;

        VL_Aes := TLbRijndael.Create(nil);
        VL_Aes.KeySize := F_ComunicadorServico.CriptoAes.KeySize;
        VL_Aes.CipherMode := F_ComunicadorServico.CriptoAes.CipherMode;
        VL_Aes.GenerateKey(VL_ChaveComunicacao);

        GravaLog(F_ArquivoLog, 0, 'respondeservico', 'mcom',
          '131120230933', 'mensagem enviada descriptografada', VL_TagDados, 0, 2);

        VL_TagDados := VL_Aes.EncryptString(VL_TagDados);
        VL_Mensagem.AddTag('00E3', VL_TagDados);        // mensagem criptografada

        if VL_ChaveComunicacao = DMCom.ChaveComunicacao then
        begin
          if ((VL_ModuloPublico = '') or (VL_ExpoentePublico = '')) then
          begin
            VL_Chaves.AddComando('0111', 'S');
            VL_Chaves.AddTag('00F1', VL_Mensagem.GetTagAsAstring('00F1'));

            GravaLog(F_ArquivoLog, 0, 'respondeservico',
              'mcom', '131120230931', 'mensagem enviada', VL_Chaves.TagsAsString, 0, 2);

            Result :=
              F_ComunicadorServico.ServidorTransmiteSolicitacaoID(
              F_ComunicadorServico, 30000, True, nil, '', VL_Chaves, VL_Chaves, VP_ID);

            if Result <> 0 then
            begin
              GravaLog(F_ArquivoLog, 0, '', 'mcom',
                '310820221737', '', '', Result, 1);
              Exit;
            end;

            GravaLog(F_ArquivoLog, 0, 'respondeservico',
              'mcom', '131120230932', 'mensagem recebida', VL_Chaves.TagsAsString, 0, 2);

            VL_Chaves.GetTag('0028', VL_TamanhoPublico);        //tamanho chave
            VL_Chaves.GetTag('0023', VL_ExpoentePublico);        //expoente
            VL_Chaves.GetTag('0024', VL_ModuloPublico);        //modulos

            if (VL_ModuloPublico = '') or (VL_ExpoentePublico = '') then
              Result := 98;

            if Result <> 0 then
            begin
              GravaLog(F_ArquivoLog, 0, '', 'mcom',
                '310820221737', '', '', Result, 1);
              Exit;
            end;
          end;

          VL_Rsa := TLbRSA.Create(nil);
          VL_Rsa.PublicKey.KeySize := TLbAsymKeySize(VL_TamanhoPublico);
          VL_Rsa.PublicKey.ExponentAsString := VL_ExpoentePublico;
          VL_Rsa.PublicKey.ModulusAsString := VL_ModuloPublico;

          VL_ChaveComunicacao := VL_Rsa.EncryptString(DMCom.ChaveComunicacao);
          VL_Mensagem.AddTag('010E', VL_ChaveComunicacao);
          // chave de comunicacao criptografada
          VL_Mensagem.AddTag('010F', '');
        end;
      end;

      VL_Mensagem.AddTag('0028', DMCom.TamanhoPublico);        //tamanho chave
      VL_Mensagem.AddTag('0023', DMCom.ExpoentePublico);        //expoente
      VL_Mensagem.AddTag('0024', DMCom.ModuloPublico);        //modulos

      GravaLog(F_ArquivoLog, 0, 'respondeservico', 'mcom', '131120230930',
        'mensagem enviada', VL_Mensagem.TagsAsString, 0, 2);

      Result := F_ComunicadorServico.ServidorTransmiteSolicitacaoID(
        F_ComunicadorServico, 3000, False, nil, VL_Transmissao_ID,
        VL_Mensagem, F_Mensagem, VP_ID);
      if Result <> 0 then
      begin
        GravaLog(F_ArquivoLog, 0, '', 'mcom', '200920221312', '', '', Result, 1);
        Exit;
      end;

    except
      on e: Exception do
      begin
        Result := 1;
        GravaLog(F_ArquivoLog, 0, 'respondeservico', 'mcom',
          '070620241650', e.ClassName + '/' + e.Message, VP_Dados, Result, 1);
      end;
    end;

  finally
    VL_Chaves.Free;
    VL_Mensagem.Free;
    if Assigned(VL_Aes) then
      VL_Aes.Free;
    if Assigned(VL_Rsa) then
      VL_Rsa.Free;
  end;
end;

{ ThProcesso }

procedure ThProcesso.Execute;
begin
  sleep(5000);
  fprocedimento(PChar(fTransmissaoID), 0, 1, PChar('tok' + fdados));
end;

constructor ThProcesso.Create(VP_Suspenso: boolean;
  VP_Transmissao_ID, VP_Dados: ansistring; VP_Procedimento: TRetorno);
begin
  FreeOnTerminate := True;
  fdados := VP_Dados;
  fTransmissaoID := VP_Transmissao_ID;
  fprocedimento := VP_Procedimento;
  inherited Create(VP_Suspenso);
end;

procedure ComandoCaixa(VP_Erro: integer; VP_Transmissao_ID, VP_DadosRecebidos: string;
  VP_Conexao_ID: integer; VP_Terminal_Tipo: string; VP_Terminal_ID: integer;
  VP_DOC: string; VP_Terminal_Status: TConexaoStatus;
  VP_Terminal_Identificacao: string; VP_Permissao: TPermissao; VP_ClienteIP: string);
begin
  DMCom.RecebeComandoCaixa(VP_Erro, VP_Transmissao_ID, VP_DadosRecebidos,
    VP_Conexao_ID, VP_ClienteIP, VP_Terminal_Status);
end;

procedure ComandoServico(VP_Erro: integer; VP_Transmissao_ID, VP_DadosRecebidos: string;
  VP_Conexao_ID: integer; VP_Terminal_Tipo: string; VP_Terminal_ID: integer;
  VP_DOC: string; VP_Terminal_Status: TConexaoStatus;
  VP_Terminal_Identificacao: string; VP_Permissao: TPermissao; VP_ClienteIP: string);
begin
  DMCom.RecebeComandoServico(VP_Erro, VP_Transmissao_ID, VP_DadosRecebidos,
    VP_Conexao_ID, VP_ClienteIP, VP_Terminal_Status);
end;


function TDMCom.iniciar(VP_Chave, VP_IP_Caixa, VP_IP_Servico: string;
  VP_PortaCaixa, VP_PortaServico: integer; VP_Identificacao: string): integer;
begin
  Result := 1;

  VF_Chave := VP_Chave;
  VF_Identificacao := VP_Identificacao;

  VF_PortaCaixa := VP_PortaCaixa;
  VF_PortaServico := VP_PortaServico;

  VF_IP_Caixa := VP_IP_Caixa;
  VF_IP_Servico := VP_IP_Servico;

  F_ComunicadorCaixa := TDComunicador.Create(Self);
  F_ComunicadorServico := TDComunicador.Create(Self);

  self.CriptoRsa.KeySize := F_ComunicadorCaixa.CriptoRsa.KeySize;
  self.CriptoRsa.GenerateKeyPair;

  self.ModuloPublico := self.CriptoRsa.PublicKey.ModulusAsString;
  self.ExpoentePublico := self.CriptoRsa.PublicKey.ExponentAsString;
  self.TamanhoPublico := Ord(self.CriptoRsa.PublicKey.KeySize);

  self.CriptoAes.KeySize := F_ComunicadorCaixa.CriptoAes.KeySize;
  self.CriptoAes.CipherMode := F_ComunicadorCaixa.CriptoAes.CipherMode;
  self.ChaveComunicacao := CriaChave(50);
  self.CriptoAes.GenerateKey(self.ChaveComunicacao);

  F_ComunicadorCaixa.V_TransmissaoComando := @TransmissaoComando;
  F_ComunicadorCaixa.V_ServidorRecebimento := @ComandoCaixa;
  F_ComunicadorCaixa.V_ArquivoLog := F_ArquivoLog;
  F_ComunicadorCaixa.IdTCPServidor.DefaultPort := VP_PortaCaixa;
  F_ComunicadorCaixa.IdTCPServidor.Active := True;

  F_ComunicadorServico.V_TransmissaoComando := @TransmissaoComando;
  F_ComunicadorServico.V_ServidorRecebimento := @ComandoServico;
  F_ComunicadorServico.V_ArquivoLog := F_ArquivoLog;
  F_ComunicadorServico.IdTCPServidor.DefaultPort := VP_PortaServico;
  F_ComunicadorServico.IdTCPServidor.Active := True;

  F_Mensagem := TMensagem.Create;

  Result := 0;
end;

function TDMCom.RecebeComandoCaixa(VP_Erro: integer;
  VP_Transmissao_ID, VP_DadosRecebidos: string; VP_Conexao_ID: integer;
  VP_ClienteIP: string; VP_Terminal_Status: TConexaoStatus): integer;
var
  VL_Mensagem: TMensagem;
  VL_DadosCriptografados: string;
  VL_ChaveComunicacao: string;
  VL_Aes: TLbRijndael;
begin
  VL_DadosCriptografados := '';
  VL_ChaveComunicacao := '';
  VL_Aes := nil;
  VL_Mensagem := nil;
  try
    try
      GravaLog(F_ArquivoLog, 0, 'RecebeComandoCaixa', 'mcom',
        '131120230927', 'mensagem recebida', VP_DadosRecebidos, VP_Erro, 2);

      if VP_Erro = 96 then
      begin
        F_ServidorRecebimentoLibCaixa(VP_Erro, PChar(VP_Transmissao_ID),
          PChar(VP_DadosRecebidos), PChar(VP_ClienteIP),
          VP_Conexao_ID, PChar(VF_Chave));
        Exit;
      end;

      VL_Mensagem := TMensagem.Create;

      if VL_Mensagem.CarregaTags(VP_DadosRecebidos) <> 0 then
      begin
        F_ComunicadorCaixa.DesconectarClienteID(F_ComunicadorCaixa,
          VP_Conexao_ID);
        Exit;
      end;
      if VF_IP_Caixa <> '' then
      begin
        if VF_IP_Caixa <> VP_ClienteIP then
        begin
          F_ComunicadorCaixa.DesconectarClienteID(F_ComunicadorCaixa,
            VP_Conexao_ID);
          Exit;
        end;
      end;

      if VL_Mensagem.GetTagAsAstring('010E') <> '' then
        // chave de comunicacao criptografada aes da solicitação
        VL_ChaveComunicacao :=
          DMCom.CriptoRsa.DecryptString(VL_Mensagem.GetTagAsAstring('010E'))
      else
      if VL_Mensagem.GetTagAsAstring('010F') <> '' then
        // chave de comunicacao criptografada aes da resposta
        VL_ChaveComunicacao := DMCom.ChaveComunicacao;

      VL_DadosCriptografados := VL_Mensagem.GetTagAsAstring('00E3');
      // mensagem criptografada

      if VL_DadosCriptografados <> '' then
      begin
        if VL_ChaveComunicacao = '' then
        begin
          Result := 109;
          Exit;
        end;

        VL_Aes := TLbRijndael.Create(nil);
        VL_Aes.KeySize := F_ComunicadorServico.CriptoAes.KeySize;
        VL_Aes.CipherMode := F_ComunicadorServico.CriptoAes.CipherMode;
        VL_Aes.GenerateKey(VL_ChaveComunicacao);

        VL_DadosCriptografados := VL_Aes.DecryptString(VL_DadosCriptografados);
        VL_Mensagem.AddTag('00E3', VL_DadosCriptografados);
        // mensagem criptografada

        VP_DadosRecebidos := VL_Mensagem.TagsAsString;

        GravaLog(F_ArquivoLog, 0, 'RecebeComandoCaixa', 'mcom',
          '131120230928', 'dados descriptografado', VP_DadosRecebidos, 0, 2);
      end;


      case VL_Mensagem.Comando() of
        '0001': comando0001(VP_Transmissao_ID, VL_Mensagem,
            VP_Conexao_ID, F_ComunicadorCaixa, VP_Terminal_Status, VP_ClienteIP);
        '0021': comando0021(VP_Transmissao_ID, VL_Mensagem,
            VP_Conexao_ID, F_ComunicadorCaixa, VP_Terminal_Status);
        '0111': comando0111(VP_Transmissao_ID, VL_Mensagem,
            VP_Conexao_ID, F_ComunicadorCaixa);
        else
          F_ServidorRecebimentoLibCaixa(VP_Erro,
            PChar(VP_Transmissao_ID), PChar(VP_DadosRecebidos), PChar(VP_ClienteIP),
            VP_Conexao_ID, PChar(VF_Chave));
      end;


      Result := 0;
    except
      on e: Exception do
      begin
        Result := 1;
        GravaLog(F_ArquivoLog, 0, 'RecebeComandoCaixa', 'mcom',
          '080820231603', e.ClassName + '/' + e.Message, VP_DadosRecebidos, Result, 1);
      end;
    end;
  finally
    begin
      if Assigned(VL_Aes) then
        VL_Aes.Free;
      if Assigned(VL_Mensagem) then
        VL_Mensagem.Free;
    end;
  end;

end;

function TDMCom.RecebeComandoServico(VP_Erro: integer;
  VP_Transmissao_ID, VP_DadosRecebidos: string; VP_Conexao_ID: integer;
  VP_ClienteIP: string; VP_Terminal_Status: TConexaoStatus): integer;
var
  VL_Mensagem: TMensagem;
  VL_DadosCriptografados: string;
  VL_ChaveComunicacao: string;
  VL_Aes: TLbRijndael;
begin
  VL_DadosCriptografados := '';
  VL_Aes := nil;
  VL_Mensagem := nil;
  try
    try
      GravaLog(F_ArquivoLog, 0, 'RecebeComandoServico', 'mcom',
        '131120230926', 'mensagem recebida', VP_DadosRecebidos, VP_Erro, 2);

      if VP_Erro = 96 then
      begin
        F_ServidorRecebimentoLibServico(VP_Erro, PChar(VP_Transmissao_ID),
          PChar(VP_DadosRecebidos), PChar(VP_ClienteIP),
          VP_Conexao_ID, PChar(VF_Chave));
        Exit;
      end;

      VL_Mensagem := TMensagem.Create;

      if VL_Mensagem.CarregaTags(VP_DadosRecebidos) <> 0 then
      begin
        F_ComunicadorServico.DesconectarClienteID(F_ComunicadorServico,
          VP_Conexao_ID);
        Exit;
      end;
      if VF_IP_Servico <> '' then
      begin
        if VF_IP_Servico <> VP_ClienteIP then
        begin
          F_ComunicadorServico.DesconectarClienteID(
            F_ComunicadorServico, VP_Conexao_ID);
          Exit;
        end;
      end;

      if VL_Mensagem.GetTagAsAstring('010E') <> '' then
        // chave de comunicacao criptografada aes da solicitação
      begin
        try
          VL_ChaveComunicacao :=
            CriptoRsa.DecryptString(VL_Mensagem.GetTagAsAstring('010E'));
        except
          on e: Exception do
          begin
            Result := 1;
            GravaLog(F_ArquivoLog, 0, 'RecebeComandoServico',
              'mcom', '080820231605', e.ClassName + '/' + e.Message,
              VP_DadosRecebidos, Result, 1);
          end;
        end;
      end
      else
      if VL_Mensagem.GetTagAsAstring('010F') <> '' then
        // chave de comunicacao criptografada aes da resposta
        VL_ChaveComunicacao := DMCom.ChaveComunicacao;

      VL_DadosCriptografados := VL_Mensagem.GetTagAsAstring('00E3');
      // mensagem criptografada

      if VL_DadosCriptografados <> '' then
      begin
        if VL_ChaveComunicacao = '' then
        begin
          Result := 109;
          Exit;
        end;

        VL_Aes := TLbRijndael.Create(nil);
        VL_Aes.KeySize := F_ComunicadorServico.CriptoAes.KeySize;
        VL_Aes.CipherMode := F_ComunicadorServico.CriptoAes.CipherMode;
        VL_Aes.GenerateKey(VL_ChaveComunicacao);

        VL_DadosCriptografados := VL_Aes.DecryptString(VL_DadosCriptografados);
        VL_Mensagem.AddTag('00E3', VL_DadosCriptografados);

        VP_DadosRecebidos := VL_Mensagem.TagsAsString;

        GravaLog(F_ArquivoLog, 0, 'RecebeComandoServico',
          'mcom', '131120230929', 'dados descriptografado', VP_DadosRecebidos, 0, 2);
      end;

      case VL_Mensagem.Comando() of
        '0001': comando0001(VP_Transmissao_ID, VL_Mensagem,
            VP_Conexao_ID, F_ComunicadorServico, VP_Terminal_Status, VP_ClienteIP);
        '0021': comando0021(VP_Transmissao_ID, VL_Mensagem,
            VP_Conexao_ID, F_ComunicadorServico, VP_Terminal_Status);
        '0111': comando0111(VP_Transmissao_ID, VL_Mensagem,
            VP_Conexao_ID, F_ComunicadorServico);
        else
          F_ServidorRecebimentoLibServico(VP_Erro,
            PChar(VP_Transmissao_ID), PChar(VP_DadosRecebidos), PChar(VP_ClienteIP),
            VP_Conexao_ID, PChar(VF_Chave));
      end;

      Result := 0;
    except
      on e: Exception do
      begin
        Result := 1;
        GravaLog(F_ArquivoLog, 0, 'RecebeComandoServico',
          'mcom', '080820231605', e.ClassName + '/' + e.Message,
          VP_DadosRecebidos, Result, 1);
      end;
    end;
  finally
    begin
      if Assigned(VL_Aes) then
        VL_Aes.Free;
      if Assigned(VL_Mensagem) then
        VL_Mensagem.Free;
    end;
  end;
end;

function TDMCom.comando0001(VP_Transmissao_ID: string; VP_Mensagem: TMensagem;
  VP_Conexao_ID: integer; VP_DComunicador: TDComunicador;
  VP_Terminal_Status: TConexaoStatus; VP_ClienteIP: string): integer; // login
var
  VL_Mensagem: TMensagem;
  VL_TipoConexao: string;
  VL_AContext: TIdContext;
begin
  Result := 0;
  VL_Mensagem := TMensagem.Create;
  VL_TipoConexao := '';
  VL_AContext := nil;
  try
    //inicio do processo
    if not VP_DComunicador.V_ConexaoCliente.GetSocketServidor(
      VP_DComunicador, VP_Conexao_ID, VL_AContext) then
    begin
      GravaLog(F_ArquivoLog, 0, '', 'mcom', '130920221654',
        'Erro no comando0001 conexão do cliente não encontrada ', '', 99, 1);
      Result := 99;
      Exit;
    end;

    VP_Mensagem.GetTag('0110', VL_TipoConexao); // tipo da conexao

    VL_Mensagem.AddComando('0001', 'R'); // retorno do login
    VL_Mensagem.AddTag('004D', '0'); // erro


    if VL_TipoConexao = 'C' then // caixa
      Result := F_ServidorRecebimentoLibCaixa(0, PChar(VP_Transmissao_ID),
        PChar(VL_Mensagem.TagsAsString), PChar(VP_ClienteIP),
        VP_Conexao_ID, PChar(VF_Chave))
    else
      Result := F_ServidorRecebimentoLibServico(0, PChar(VP_Transmissao_ID),
        PChar(VL_Mensagem.TagsAsString), PChar(VP_ClienteIP),
        VP_Conexao_ID, PChar(VF_Chave));

    if Result = 0 then
      TTConexao(VL_AContext.Data).Status := csLogado
    else
      VL_Mensagem.AddComando('004D', IntToStr(Result));

    GravaLog(F_ArquivoLog, 0, 'comando0001', 'mcom', '131120230925',
      'mensagem enviada', VL_Mensagem.TagsAsString, 0, 2);

    Result := VP_DComunicador.ServidorTransmiteSolicitacaoID(
      VP_DComunicador, 3000, False, nil, VP_Transmissao_ID, VL_Mensagem,
      F_Mensagem, VP_Conexao_ID);
    if Result <> 0 then
    begin
      GravaLog(F_ArquivoLog, 0, '', 'mcom', '200920221313', '',
        'comando0001', Result, 1);
      Exit;
    end;

  finally
    VL_Mensagem.Free;
  end;

end;

function TDMCom.comando0021(VP_Transmissao_ID: string; VP_Mensagem: TMensagem;
  VP_Conexao_ID: integer; VP_DComunicador: TDComunicador; // PEDIDO DE CONEXÃO
  VP_Terminal_Status: TConexaoStatus): integer;
var
  VL_Dados: string;
  VL_ExpoentePublico, VL_ModuloPublico: string;
  VL_Mensagem: TMensagem;
  VL_AContext: TIdContext;
begin
  Result := 0;
{
    VL_Mensagem := TMensagem.Create;
    VL_Dados := '';
    VL_ModuloPublico := '';
    VL_ExpoentePublico := '';
    VL_AContext := nil;
    try
        if not VP_DComunicador.V_ConexaoCliente.GetSocketServidor(VP_DComunicador, VP_Conexao_ID, VL_AContext) then
        begin
            GravaLog(F_ArquivoLog, 0, '', 'mcom', '130920221654', 'Erro no comando0021 conexão do cliente não encontrada ', '', 99);
            Result := 99;
            Exit;
        end;


        if VP_Terminal_Status = csDesconectado then
        begin
            Result := 33;
            Exit;
        end;

        VL_Mensagem.limpar;
        VL_Mensagem.AddComando('0025', '');  // ENVIO DE CHAVE SIMÉTRICA CONEXÃO ACEITA
        VP_Mensagem.GetTag('0008', VL_ModuloPublico); // CHAVE PUBLICA MODULO
        VP_Mensagem.GetTag('0027', VL_ExpoentePublico);  // CHAVE PUBLICA EXPOENTE

        if ((VL_ExpoentePublico = '') or (VL_ModuloPublico = '')) then
        begin
            Result := 31;
            VL_Mensagem.AddComando('0026', '31'); // RETORNO COM ERRO
            VL_Mensagem.TagToStr(VL_Dados);

            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('00D1', VP_Transmissao_ID);
            VL_Mensagem.AddTag('00D2', VL_Dados);

            VL_AContext.Connection.Socket.WriteLn(VL_Mensagem.TagsAsString);
            Exit;
        end;

        TTConexao(VL_AContext.Data).setModuloPublico(VL_ModuloPublico);
        TTConexao(VL_AContext.Data).setExpoentePublico(VL_ExpoentePublico);

        VL_Mensagem.AddTag('0008', TDComunicador(VP_DComunicador).V_ConexaoCliente.ModuloPublico); // CHAVE PUBLICA MODULO
        VL_Mensagem.AddTag('0027', TDComunicador(VP_DComunicador).V_ConexaoCliente.ExpoentePublico); // CHAVE PUBLICA EXPOENTE

        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('00D1', VP_Transmissao_ID);
        VL_Mensagem.AddTag('00D2', VL_Dados);

        TDComunicador(VP_DComunicador).V_ConexaoCliente.Status := csChaveado;

        VL_AContext.Connection.Socket.WriteLn(VL_Mensagem.TagsAsString);
        Result := 0;


    finally
        VL_Mensagem.Free;
    end;
 }
end;

function TDMCom.comando0111(VP_Transmissao_ID: string; VP_Mensagem: TMensagem;
  VP_Conexao_ID: integer; VP_DComunicador: TDComunicador): integer;
  // SOLICITA CHAVE PÚBLICA
var
  VL_Mensagem: TMensagem;
begin
  try
    VL_Mensagem := TMensagem.Create;

    Result := VL_Mensagem.CarregaTags(VP_Mensagem.TagsAsString);

    if Result <> 0 then
    begin
      GravaLog(F_ArquivoLog, 0, '', 'mcom', '200920221314', '',
        'comando0111', Result, 1);
      Exit;
    end;

    VL_Mensagem.AddComando('0111', 'R'); // SOLICITA CHAVE PÚBLICA
    VL_Mensagem.AddTag('004D', '0'); // erro
    VL_Mensagem.AddTag('0024', CriptoRsa.PublicKey.ModulusAsString);
    VL_Mensagem.AddTag('0023', CriptoRsa.PublicKey.ExponentAsString);
    VL_Mensagem.AddTag('0028', Ord(CriptoRsa.PublicKey.KeySize));

    GravaLog(F_ArquivoLog, 0, 'comando0111', 'mcom', '131120230924',
      'mensagem enviada', VL_Mensagem.TagsAsString, 0, 2);

    Result := VP_DComunicador.ServidorTransmiteSolicitacaoID(
      VP_DComunicador, 3000, False, nil, VP_Transmissao_ID, VL_Mensagem,
      F_Mensagem, VP_Conexao_ID);
    if Result <> 0 then
    begin
      GravaLog(F_ArquivoLog, 0, '', 'mcom', '200920221314', '',
        'comando0111', Result, 1);
      Exit;
    end;
  finally
    VL_Mensagem.Free;
  end;

end;

function TDMCom.TransmissaoComando(AOwner: Pointer; VP_Conexao_ID: integer;
  VP_Transmissao_ID, VP_Comando: string; var VO_Dados: string): integer;
var
  VL_Mensagem: TMensagem;
begin
  VL_Mensagem := nil;
  VO_Dados := '';
  Result := 0;
  try
    GravaLog(F_ArquivoLog, 0, 'TransmissaoComando', 'mcom',
      '131120230947', 'mensagem recebida', VP_Comando, 0, 2);

    VL_Mensagem := TMensagem.Create;

    Result := VL_Mensagem.CarregaTags(VP_Comando);

    if Result <> 0 then
    begin
      Exit;
    end;

    if ((VL_Mensagem.Comando = '0022') and (VL_Mensagem.ComandoDados = 'S')) then
      // SOLICITA DADOS DA IDENTIFICACAO
    begin
      if trim(VF_Identificacao) <> trim(VL_Mensagem.GetTagAsAstring('0108')) then
        // identificacao
      begin
        Result := 106;
        Exit;
      end;

      VL_Mensagem.Limpar;
      VL_Mensagem.AddComando('0022', 'R');  // RETORNA DADOS DA IDENTIFICACAO
      VL_Mensagem.AddTag('0023', VF_Chave); // CHAVE DE COMUNICACAO

      VO_Dados := VL_Mensagem.TagsAsString;

      Exit;
    end;

  finally
    VL_Mensagem.Free;
  end;
end;

procedure alterarnivellog(VP_Nivel: integer); cdecl;
begin
  F_NivelLog := VP_Nivel;
end;

end.
