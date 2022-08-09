unit comunicador;


{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils, LbRSA, StrUtils, LbClass, IdTCPClient, IdTCPServer, funcoes, IdContext, IdComponent, IdGlobal;

type

    { TDComunicador }


    TKey = array [0..31] of byte;

    TTChaveComunicacao = record
        ID: int64;
        ChaveComunicacao: ansistring;
    end;

    TTChaveConexao = class
    private
        fChaveComunicacao: array of TTChaveComunicacao;
        fContador: integer;
    public
        constructor Create;
        function getChave(VP_ID: integer): TTChaveComunicacao;
        function addChave(VP_ChaveComunicacao: ansistring): integer;

    end;


    { TEventoSocket }

    TEventoSocket = class
        fTemporizadores: TList;
    public
        constructor Create;
        destructor Destroy; override;
        procedure add(VP_Temporizador: TTemporizador);
        procedure remove(VP_Temporizador: TTemporizador);
        function parar(VP_ID: string): integer;
        function abortar(VP_ID: string): integer;
        function SetDados(VP_ID, VP_Dados: string): integer;
        function GetDados(VP_ID: string; var VO_Dados: string): integer;
    end;



    TTConexao = class
        Aes: TLbRijndael;
        Rsa: TLbRSA;
        ClienteIp: string;
        ClientePorta: integer;
        ServidorHost: ansistring;
        ServidorPorta: integer;
        Hora: TDateTime;
        ID: integer;
        DOC:String;
        Terminal_Tipo: ansistring;
        Terminal_ID: integer;
        ChaveComunicacaoIDX: integer;
        ModuloPublico: ansistring;
        ExpoentePublico: ansistring;
        Status: TConexaoStatus;
        DComunicador: Pointer;
        Permissao: TPermissao;
        EventoSocket: TEventoSocket;
        ConexaoAtivadada: boolean;
    public
        constructor Create(VP_DComunicador: Pointer);
        destructor Destroy; override;
        procedure setModuloPublico(VP_Dados: ansistring);
        procedure setExpoentePublico(VP_Dados: ansistring);
        procedure setChaveComunicacao(VP_Chave: ansistring);
        function getChavePublica: ansistring;
        function getChaveComunicacao: ansistring;
    end;

    { TThRecebe }

    TThRecebe = class(TThread)
    private
        f_parar: boolean;
    protected
        procedure Execute; override;
    public
        f_DComunicador: Pointer;
        f_ArquivoLog: string;
        procedure parar;
        constructor Create(VP_Suspenso: boolean; VP_DComunicador: Pointer; VP_ArquivoLog: string);
    end;


    { TThRecebeAguarda }

    { TEvento }


    TDComunicador = class(TDataModule)
        IdTCPServidor: TIdTCPServer;
        IdTCPCliente: TIdTCPClient;
        CriptoAes: TLbRijndael;
        CriptoRsa: TLbRSA;
        procedure DataModuleCreate(Sender: TObject);
        procedure DataModuleDestroy(Sender: TObject);
        procedure IdTCPServidorConnect(AContext: TIdContext);
        procedure IdTCPServidorDisconnect(AContext: TIdContext);
        procedure IdTCPServidorExecute(AContext: TIdContext);
        procedure IdTCPClienteConnected(Sender: TObject);
        procedure IdTCPClienteDisconnected(Sender: TObject);
    private

    public
        V_Chave_Terminal: ansistring;
        V_Versao_Comunicacao: integer;
        V_ThRecebeEscuta: TThRecebe;
        V_EventoSocketCliente: TEventoSocket;
        V_ConexaoCliente: TTConexao;
        V_ChavesDasConexoes: TTChaveConexao;
        V_ServidorRecebimento: TServidorRecebimento;   //procedure disparado no envento que o IdTCPServidor recebe passa a conexão do cliente
        V_ClienteRecebimento: TRetorno;   //procedure disparado no envento que o IdTCPCliente recebe sem ter solicitado ou quando a solicitação expirou
        V_ArquivoLog: string;
        V_ProcID: integer;
        function DesconectarCliente: integer;
        function ConectarCliente: integer;

        function ClienteVerificaConexao: integer;
        function ClienteTransmiteDados(var VO_Transmissao_ID: string; var VO_DadosO, VO_DadosI: ansistring; VP_TempoAguarda: integer;
            VP_AguardaRetorno: boolean): integer;
        function ClienteTransmiteSolicitacao(var VO_Transmissao_ID: string; var VO_Dados: TMensagem; var VO_Retorno: TMensagem;
            VP_Procedimento: TRetorno; VP_TempoAguarda: integer; VP_AguardaRetorno: boolean): integer;

        function ServidorTransmiteSolicitacao(VP_TempoAguarda: integer; VP_AguardaRetorno: boolean; VP_Procedimento: TServidorRecebimento;
            VP_Transmissao_ID: string; VP_Mensagem: TMensagem; var VO_Mensagem: TMensagem; VP_AContext: TIdContext): integer;
        function ServidorTransmiteSolicitacaoID(VP_TempoAguarda: integer; VP_AguardaRetorno: boolean; VP_Procedimento: TServidorRecebimento;
            VP_Transmissao_ID: string; VP_Mensagem: TMensagem; var VO_Mensagem: TMensagem; VP_ID: integer): integer;

        procedure desativartodasconexao;

    end;

var


    F_NumeroConexao: integer;


implementation


{$R *.lfm}

{ TEvento }

constructor TEventoSocket.Create;
begin
    fTemporizadores := TList.Create;
end;

destructor TEventoSocket.Destroy;
begin
    while fTemporizadores.Count > 0 do
    begin
        TTemporizador(fTemporizadores[0]).abortar;
        fTemporizadores.Delete(0);
    end;
    fTemporizadores.Free;
    inherited Destroy;
end;

procedure TEventoSocket.add(VP_Temporizador: TTemporizador);
begin
    fTemporizadores.Add(VP_Temporizador);
end;

procedure TEventoSocket.remove(VP_Temporizador: TTemporizador);
begin
    fTemporizadores.Remove(VP_Temporizador);
end;

function TEventoSocket.parar(VP_ID: string): integer;
var
    VL_I: integer;
begin
    Result := 66;
    for VL_I := 0 to fTemporizadores.Count - 1 do
    begin
        if TTemporizador(fTemporizadores[VL_I]).V_ID = VP_ID then
        begin
            TTemporizador(fTemporizadores[VL_I]).parar;
            Result := 0;
        end;
    end;
end;

function TEventoSocket.abortar(VP_ID: string): integer;
var
    VL_I: integer;
begin
    Result := 66;
    for VL_I := 0 to fTemporizadores.Count - 1 do
    begin
        if TTemporizador(fTemporizadores[VL_I]).V_ID = VP_ID then
        begin
            TTemporizador(fTemporizadores[VL_I]).abortar;
            Result := 0;
        end;
    end;

end;

function TEventoSocket.SetDados(VP_ID, VP_Dados: string): integer;
var
    VL_I: integer;
begin
    Result := 66;
    for VL_I := 0 to fTemporizadores.Count - 1 do
    begin
        if TTemporizador(fTemporizadores[VL_I]).V_ID = VP_ID then
        begin
            TTemporizador(fTemporizadores[VL_I]).V_Dados := VP_Dados;
            Result := 0;
        end;
    end;

end;

function TEventoSocket.GetDados(VP_ID: string; var VO_Dados: string): integer;
var
    VL_I: integer;
begin
    Result := 66;
    for VL_I := 0 to fTemporizadores.Count - 1 do
    begin
        if TTemporizador(fTemporizadores[VL_I]).V_ID = VP_ID then
        begin
            VO_Dados := TTemporizador(fTemporizadores[VL_I]).V_Dados;
            Result := 0;
        end;
    end;

end;


{ TDComunicador }

function TDComunicador.ConectarCliente: integer;
var
    VL_Mensagem: TMensagem;
    VL_Comando: ansistring;
    VL_Dados, VL_DadosO, VL_DadosI: ansistring;
    VL_ChaveComunicacao: ansistring;
    VL_OK: ansistring;
    VL_ChaveComunicacaoIDX: ansistring;
    VL_ExpoentePublico, VL_ModuloPublico: ansistring;
    VL_Transmissao_ID: string;

begin

    VL_Mensagem := TMensagem.Create;
    VL_ModuloPublico := '';
    VL_ExpoentePublico := '';
    VL_ChaveComunicacao := '';
    VL_ChaveComunicacaoIDX := '';
    VL_OK := '';
    VL_Dados := '';
    VL_DadosO := '';
    VL_DadosI := '';
    VL_Comando := '';
    VL_Transmissao_ID := '';
    try

        if (V_ConexaoCliente.Status = csChaveado) or (V_ConexaoCliente.Status = csLogado) then
        begin
            Result := 0;
            exit;
        end;


        if idTCPCliente.Connected then
            DesconectarCliente;

        idTCPCliente.Host := V_ConexaoCliente.ServidorHost;
        idTCPCliente.Port := V_ConexaoCliente.ServidorPorta;

        try
            idTCPCliente.Connect;
            idTCPCliente.IOHandler.MaxLineLength := MaxInt;
            idTCPCliente.IOHandler.SendBufferSize := MaxInt;
        except
            begin
                Result := 26;
                Exit;
            end;
        end;

        if idTCPCliente.Connected = False then
        begin
            Result := 26;
            Exit;
        end;


        VL_Mensagem.Limpar;

        VL_Mensagem.AddComando('0021', '');
        VL_Mensagem.AddTag('0022', IntToStr(V_ConexaoCliente.ChaveComunicacaoIDX));
        VL_Mensagem.AddTag('0008', V_ConexaoCliente.ModuloPublico);
        VL_Mensagem.AddTag('0027', V_ConexaoCliente.ExpoentePublico);

        if V_ConexaoCliente.ChaveComunicacaoIDX > 0 then
            VL_Mensagem.AddTag('0023', V_ConexaoCliente.Aes.EncryptString('OK'));

        VL_DadosO := VL_Mensagem.TagsAsString;


        ClienteTransmiteDados(VL_Transmissao_ID, VL_DadosO, VL_DadosI, 15000, True);

        Result := VL_Mensagem.CarregaTags(VL_DadosI);

        if Result <> 0 then
            Exit;

        VL_Mensagem.GetComando(VL_Comando, VL_Dados);

        if VL_Comando = '0024' then
        begin
            V_ConexaoCliente.Status := csChaveado;
            Result := 0;
            Exit;
        end;

        if VL_Comando = '0026' then
        begin
            VL_Mensagem.GetTag('0026', VL_Comando);
            Result := StrToInt(VL_Comando);
            Exit;
        end;

        if VL_Comando = '0025' then
        begin
            VL_Mensagem.GetTag('0008', VL_ModuloPublico);
            VL_Mensagem.GetTag('0027', VL_ExpoentePublico);
            VL_Mensagem.GetTag('0009', VL_ChaveComunicacao);
            VL_Mensagem.GetTag('0022', VL_ChaveComunicacaoIDX);
            VL_Mensagem.GetTag('0023', VL_OK);


            V_ConexaoCliente.setExpoentePublico(VL_ExpoentePublico);
            V_ConexaoCliente.setModuloPublico(VL_ModuloPublico);
            VL_ChaveComunicacao := V_ConexaoCliente.Rsa.DecryptString(VL_ChaveComunicacao);
            V_ConexaoCliente.setChaveComunicacao(VL_ChaveComunicacao);
            V_ConexaoCliente.ChaveComunicacaoIDX := StrToInt(VL_ChaveComunicacaoIDX);
            VL_OK := V_ConexaoCliente.Aes.DecryptString(VL_OK);


            if VL_OK <> 'OK' then
            begin
                Result := 32;
                Exit;
            end;
            V_ConexaoCliente.Status := csChaveado;
        end;


    finally
        VL_Mensagem.Free;
    end;

end;

function TDComunicador.ClienteVerificaConexao: integer;
var
    VL_Dados, VL_Transmissao_ID: string;
begin
    try
        IdTCPCliente.CheckForGracefulDisconnect(True);
        VL_Dados := '000021400E211S';
        VL_Transmissao_ID := '';
        Result := ClienteTransmiteDados(VL_Transmissao_ID, VL_Dados, VL_Dados, 2000, True);

    except
        begin
            Result := 83;
            DesconectarCliente;
        end;
    end;
end;


constructor TTChaveConexao.Create;
begin
    fContador := 0;
    inherited Create;
end;



function TTChaveConexao.getChave(VP_ID: integer): TTChaveComunicacao;
var
    i: integer;
begin
    for i := 0 to Length(fChaveComunicacao) - 1 do
    begin
        if VP_ID = fChaveComunicacao[i].ID then
        begin
            Result := fChaveComunicacao[i];
            Exit;
        end;
    end;
end;

function TTChaveConexao.addChave(VP_ChaveComunicacao: ansistring): integer;
begin
    fContador := fContador + 1;
    SetLength(fChaveComunicacao, Length(fChaveComunicacao) + 1);
    fChaveComunicacao[Length(fChaveComunicacao) - 1].ID := fContador;
    fChaveComunicacao[Length(fChaveComunicacao) - 1].ChaveComunicacao := VP_ChaveComunicacao;
    Result := fContador;

end;


constructor TTConexao.Create(VP_DComunicador: Pointer);
var
    VL_Key: TMemoryStream;
begin
    Status := csDesconectado;
    DComunicador := VP_DComunicador;
    ConexaoAtivadada := False;

    ServidorHost := '';
    ServidorPorta := 0;

    ClienteIp := '';
    ClientePorta := 0;

    DOC:='';
    Terminal_Tipo := '';
    Terminal_ID := 0;

    VL_Key := TMemoryStream.Create;
    Aes := TLbRijndael.Create(nil);
    Rsa := TLbRSA.Create(nil);

    Aes.KeySize := TDComunicador(DComunicador^).CriptoAes.KeySize;
    Aes.CipherMode := TDComunicador(DComunicador^).CriptoAes.CipherMode;
    Aes.GenerateRandomKey;

    Rsa.KeySize := TDComunicador(DComunicador^).CriptoRsa.KeySize;

    F_NumeroConexao := F_NumeroConexao + 1;
    ID := F_NumeroConexao;

    TDComunicador(DComunicador^).CriptoRsa.PrivateKey.StoreToStream(VL_Key);
    VL_Key.Position := 0;
    Rsa.PrivateKey.LoadFromStream(VL_Key);

    ExpoentePublico := TDComunicador(DComunicador^).CriptoRsa.PublicKey.ExponentAsString;
    ModuloPublico := TDComunicador(DComunicador^).CriptoRsa.PublicKey.ModulusAsString;

    EventoSocket := TEventoSocket.Create;

    VL_Key.Free;
    inherited Create;
end;

destructor TTConexao.Destroy;
var
    VL_I: integer;
begin

    for VL_I := 0 to EventoSocket.fTemporizadores.Count - 1 do
        EventoSocket.abortar(TTemporizador(EventoSocket.fTemporizadores[VL_I]).V_ID);
    Aes.Free;
    Rsa.Free;
    EventoSocket.Free;
    inherited Destroy;
end;


procedure TTConexao.setModuloPublico(VP_Dados: ansistring);
begin
    Rsa.PublicKey.ModulusAsString := VP_Dados;
end;

procedure TTConexao.setExpoentePublico(VP_Dados: ansistring);
begin
    Rsa.PublicKey.ExponentAsString := VP_Dados;
end;

function TTConexao.getChavePublica: ansistring;
var
    i: integer;
    h: array of byte;
    s: ansistring;
    Key: TMemoryStream;
begin
    h := nil;
    SetLength(h, 0);
    Key := TMemoryStream.Create;

    Rsa.PublicKey.StoreToStream(Key);

    if Key.Size > 0 then
        SetLength(h, Key.Size);
    Key.Position := 0;
    Key.ReadBuffer(pointer(h)^, Key.Size);

    s := '';
    for i := 0 to Length(h) - 1 do
    begin
        s := s + HexStr(h[i], 2);
    end;
    Result := s;
    Key.Free;

end;


function TTConexao.getChaveComunicacao: ansistring;
var
    s: ansistring;
    i: integer;
    Key: array [0..31] of byte;
begin
    s := '';
    for i := 0 to 31 do
        key[i] := 0;

    Aes.GetKey(Key);
    for i := 0 to Length(key) - 1 do
    begin
        s := s + HexStr(key[i], 2);
    end;
    Result := s;
end;

procedure TTConexao.setChaveComunicacao(VP_Chave: ansistring);
var
    i: integer;
    c: ansistring;
    Key: array [0..31] of byte;
begin
    if not Length(VP_Chave) > 0 then
        Exit;
    for i := 0 to Length(VP_Chave) div 2 - 1 do
    begin
        c := copy(VP_Chave, ((1 + i) * 2) - 1, 2);
        Key[i] := Hex2Dec(c);
    end;
    Aes.SetKey(Key);
end;



procedure TDComunicador.DataModuleCreate(Sender: TObject);
begin
    V_ProcID := 0;
    V_EventoSocketCliente := TEventoSocket.Create;
    V_ChavesDasConexoes := TTChaveConexao.Create;
    CriptoRsa.GenerateKeyPair;
    F_NumeroConexao := 0;

end;

procedure TDComunicador.DataModuleDestroy(Sender: TObject);
var
    VL_I: integer;
    VL_Temporizador: TTemporizador;
begin
    desativartodasconexao;

    for VL_I := 0 to V_EventoSocketCliente.fTemporizadores.Count - 1 do
        V_EventoSocketCliente.abortar(TTemporizador(V_EventoSocketCliente.fTemporizadores[VL_I]).V_ID);

  {  VL_Temporizador := TTemporizador.Create;
    VL_Temporizador.aguarda(2000, True, VL_Temporizador);
    VL_Temporizador.Free;}


    V_ChavesDasConexoes.Free;
    V_ChavesDasConexoes := nil;
    if Assigned(V_ConexaoCliente) then
    begin
        V_ConexaoCliente.Free;
        V_ConexaoCliente := nil;
    end;

    if Assigned(V_ThRecebeEscuta) then
    begin
        V_ThRecebeEscuta.parar;
        V_ThRecebeEscuta.Terminate;
        V_ThRecebeEscuta.WaitFor;
        V_ThRecebeEscuta:=nil;
    end;


    V_EventoSocketCliente.Free;

end;



procedure TDComunicador.IdTCPServidorConnect(AContext: TIdContext);
var
    TConexao: TTConexao;
begin
    AContext.Connection.IOHandler.MaxLineLength := 0;
    AContext.Connection.IOHandler.SendBufferSize := MaxInt;
    TConexao := TTConexao.Create(@self);
    TConexao.Hora := Now;
    TConexao.ID := F_NumeroConexao;
    TConexao.ClienteIp := AContext.Connection.Socket.Binding.PeerIP;
    TConexao.ClientePorta := AContext.Connection.Socket.Binding.PeerPort;
    TConexao.Status := csLink;
    TConexao.ChaveComunicacaoIDX := V_ChavesDasConexoes.addChave(TConexao.getChaveComunicacao);
    AContext.Data := TConexao;
end;

procedure TDComunicador.IdTCPServidorDisconnect(AContext: TIdContext);
begin
    if Assigned(TTConexao(AContext.Data)) then
    begin
        TTConexao(AContext.Data).Free;
        AContext.Data := nil;
    end;
end;



procedure TDComunicador.IdTCPServidorExecute(AContext: TIdContext);
var
    VL_DadosRecebidos: ansistring;
    VL_Mensagem: TMensagem;
    VL_Erro: integer;
    VL_TransmissaoID: string;
begin
    VL_Erro := 0;
    VL_TransmissaoID := '';
    VL_DadosRecebidos := AContext.Connection.IOHandler.ReadLn(LF, 100, -1, nil, nil);
    if VL_DadosRecebidos = '' then
        Exit;

    if AContext.Data = nil then
        Exit;

    try
        VL_Mensagem := TMensagem.Create;
        VL_Erro := VL_Mensagem.CarregaTags(VL_DadosRecebidos);
        if VL_Erro <> 0 then
        begin
            GravaLog(V_ArquivoLog, 0, '', 'comunicador', '250520221716', 'TDComunicador.IdTCPServidorExecute; ', '', VL_Erro);
            Exit;
        end;

        if VL_Mensagem.Comando <> '00D1' then
        begin
            GravaLog(V_ArquivoLog, 0, '', 'comunicador', '250520221717', 'TDComunicador.IdTCPServidorExecute; ', '', 68);
            Exit;
        end;
        VL_TransmissaoID := VL_Mensagem.ComandoDados;
        VL_DadosRecebidos := VL_Mensagem.GetTagAsAstring('00D2');

        if (TTConexao(AContext.Data).Status = csChaveado) or (TTConexao(AContext.Data).Status = csLogado) then
            VL_DadosRecebidos := Copy(VL_DadosRecebidos, 1, 5) + TTConexao(AContext.Data).Aes.DecryptString(Copy(VL_DadosRecebidos, 6, MaxInt));


        if VL_DadosRecebidos = '000021400E211S' then  // comando de eco
        begin
            VL_Mensagem.CarregaTags('000021400E211R');
            ServidorTransmiteSolicitacao(300, False, nil, VL_TransmissaoID, VL_Mensagem, VL_Mensagem, AContext);
            Exit;
        end;


        if (VL_TransmissaoID = '') then
        begin
            if Assigned(V_ServidorRecebimento) then
                V_ServidorRecebimento(VL_Erro, VL_Mensagem.ComandoDados, VL_DadosRecebidos, AContext)
            else
                GravaLog(V_ArquivoLog, 0, '', 'comunicador', '250520221718', 'TDComunicador.IdTCPServidorExecute;', '', 0);

        end
        else
        begin

            VL_Erro := TTConexao(AContext.Data).EventoSocket.SetDados(VL_TransmissaoID, VL_DadosRecebidos);

            if VL_Erro <> 0 then
            begin
                if Assigned(V_ServidorRecebimento) then
                    V_ServidorRecebimento(0, VL_TransmissaoID, VL_DadosRecebidos, AContext)
                else
                    GravaLog(V_ArquivoLog, 0, '', 'comunicador', '250520221719', 'TDComunicador.IdTCPServidorExecute; ', '', VL_Erro);
            end
            else
                TTConexao(AContext.Data).EventoSocket.parar(VL_TransmissaoID);
        end;




    finally
        VL_Mensagem.Free;
    end;

end;


procedure TDComunicador.IdTCPClienteConnected(Sender: TObject);
begin
    V_ConexaoCliente.Status := csLink;
end;

procedure TDComunicador.IdTCPClienteDisconnected(Sender: TObject);
begin
    V_ConexaoCliente.Status := csDesconectado;

end;

function TDComunicador.DesconectarCliente: integer;
begin
    Result := 0;
    if Assigned(V_ConexaoCliente) then
        V_ConexaoCliente.Status := csDesconectado;
    while idTCPCliente.Connected do
    begin
        idTCPCliente.Disconnect;
        //        idTCPCliente.IOHandler.InputBuffer.Clear;
        //        idTCPCliente.IOHandler.Close;
        sleep(100);
    end;
end;

function TDComunicador.ServidorTransmiteSolicitacao(VP_TempoAguarda: integer; VP_AguardaRetorno: boolean;
    VP_Procedimento: TServidorRecebimento; VP_Transmissao_ID: string; VP_Mensagem: TMensagem; var VO_Mensagem: TMensagem; VP_AContext: TIdContext): integer;
var
    VL_Dados: ansistring;
    VL_Temporizador: TTemporizador;
    VL_Evento: TAguardaEvento;
begin
    try
        Result := 0;
        VL_Dados := '';
        VP_Mensagem.TagToStr(VL_Dados);


        VL_Dados := Copy(VL_Dados, 1, 5) + TTConexao(VP_AContext.Data).Aes.EncryptString(Copy(VL_Dados, 6, MaxInt));

        VP_Mensagem.Limpar;
        VP_Mensagem.AddComando('00D1', VP_Transmissao_ID);
        VP_Mensagem.AddTag('00D2', VL_Dados);




        if VP_AguardaRetorno then
        begin
            Result := 67;

            VL_Temporizador := TTemporizador.Create;
            VL_Temporizador.V_Aguardando := True;
            VL_Temporizador.V_Executado := False;

            if VP_Transmissao_ID <> '' then
                VL_Temporizador.V_ID := VP_Transmissao_ID;

            VP_Mensagem.AddComando('00D1', VL_Temporizador.V_ID);


            TTConexao(VP_AContext.Data).EventoSocket.add(VL_Temporizador);
            VP_AContext.Connection.Socket.WriteLn(VP_Mensagem.TagsAsString);
            VL_Evento := VL_Temporizador.aguarda(VP_TempoAguarda, True, VL_Temporizador);
            case VL_Evento of
                agEvento:
                begin
                    Result := VO_Mensagem.CarregaTags(VL_Temporizador.V_Dados);
                end;

                agTempo: Result := 67;
                agAborta: Result := 69;
            end;

            if Assigned(TTConexao(VP_AContext.Data).EventoSocket) then
                TTConexao(VP_AContext.Data).EventoSocket.remove(VL_Temporizador);
            VL_Temporizador.Free;
            if Assigned(VP_Procedimento) then
                VP_Procedimento(Result, VP_Transmissao_ID, VL_Temporizador.V_Dados, VP_AContext);

        end
        else
            VP_AContext.Connection.Socket.WriteLn(VP_Mensagem.TagsAsString);

    except
        on e: EInOutError do
        begin
            Result := 1;
            GravaLog(V_ArquivoLog, 0, '', 'comunicador', '090620221843', 'ServidorTransmiteSolicitacao' + e.ClassName + '/' + e.Message, '', 1);
        end;

    end;
end;

function TDComunicador.ServidorTransmiteSolicitacaoID(VP_TempoAguarda: integer; VP_AguardaRetorno: boolean;
    VP_Procedimento: TServidorRecebimento; VP_Transmissao_ID: string; VP_Mensagem: TMensagem; var VO_Mensagem: TMensagem; VP_ID: integer): integer;
var
    VL_I: integer;
    VL_Clientes: TIdContextList;
    VL_Mensagem: TMensagem;
    VL_Dados: ansistring;
    VL_Temporizador: TTemporizador;
    VL_Evento: TAguardaEvento;
    VL_AContext: TIdContext;
begin
    try
        Result := 53;
        VL_Dados := '';
        VP_Mensagem.TagToStr(VL_Dados);


        try
            VL_Clientes := IdTCPServidor.Contexts.LockList;

            for VL_I := 0 to VL_Clientes.Count - 1 do
                if TTConexao(TIdContext(VL_Clientes.Items[VL_I]).Data).ID = VP_ID then
                begin
                    VL_AContext := TIdContext(VL_Clientes.Items[VL_I]);
                    Result := 0;
                    Break;
                end;
        finally
            IdTCPServidor.Contexts.UnlockList;
        end;
        if Result <> 0 then
            Exit;

        try
            VL_Mensagem := TMensagem.Create;

            VL_Dados := Copy(VL_Dados, 1, 5) + TTConexao(VL_AContext.Data).Aes.EncryptString(Copy(VL_Dados, 6, MaxInt));

            VP_Mensagem.Limpar;
            VP_Mensagem.AddComando('00D1', VP_Transmissao_ID);
            VP_Mensagem.AddTag('00D2', VL_Dados);


            Result := 0;

            if VP_AguardaRetorno then
            begin
                Result := 67;

                VL_Temporizador := TTemporizador.Create;
                VL_Temporizador.V_Aguardando := True;
                VL_Temporizador.V_Executado := False;

                if VP_Transmissao_ID <> '' then
                    VL_Temporizador.V_ID := VP_Transmissao_ID;

                VP_Mensagem.AddComando('00D1', VL_Temporizador.V_ID);


                TTConexao(VL_AContext.Data).EventoSocket.add(VL_Temporizador);
                VL_AContext.Connection.Socket.WriteLn(VP_Mensagem.TagsAsString);
                VL_Evento := VL_Temporizador.aguarda(VP_TempoAguarda, True, VL_Temporizador);
                case VL_Evento of
                    agEvento:
                    begin
                        Result := VO_Mensagem.CarregaTags(VL_Temporizador.V_Dados);
                    end;

                    agTempo: Result := 67;
                    agAborta: Result := 69;
                end;

                if Assigned(TTConexao(VL_AContext.Data).EventoSocket) then
                    TTConexao(VL_AContext.Data).EventoSocket.remove(VL_Temporizador);
                VL_Temporizador.Free;
                if Assigned(VP_Procedimento) then
                    VP_Procedimento(Result, VP_Transmissao_ID, VL_Temporizador.V_Dados, VL_AContext);

            end
            else
                VL_AContext.Connection.Socket.WriteLn(VP_Mensagem.TagsAsString);

        finally
            VL_Mensagem.Free;
        end;

    except
        on e: EInOutError do
        begin
            Result := 1;
            GravaLog(V_ArquivoLog, 0, '', 'comunicador', '090620221846', 'ServidorTransmiteSolicitacaoID' + e.ClassName + '/' + e.Message, '', 1);
        end;

    end;

end;

procedure TDComunicador.desativartodasconexao;
begin
    try
        if IdTCPCliente.Connected then
            DesconectarCliente;

        if IdTCPServidor.Active then
        begin
            IdTCPServidor.StopListening;
            IdTCPServidor.Active := False;
        end;

    except
        on e: EInOutError do
            GravaLog(V_ArquivoLog, 0, '', 'comunicador', '090520221723', 'Erro na TDComunicador.desativartodasconexao ' +
                e.ClassName + '/' + e.Message, '', 1);

    end;
end;

constructor TThRecebe.Create(VP_Suspenso: boolean; VP_DComunicador: Pointer; VP_ArquivoLog: string);
begin
    FreeOnTerminate := True;
    f_DComunicador := VP_DComunicador;
    f_parar := False;
    f_ArquivoLog := VP_ArquivoLog;
    inherited Create(VP_Suspenso);
end;

procedure TThRecebe.Execute;
var
    VL_Dados: string;
    VL_TransmissaoID: string;
    VL_Linha: string;
    VL_Mensagem: TMensagem;
    VL_Erro: integer;
begin
    VL_Dados := '';
    VL_TransmissaoID := '';
    VL_Mensagem := TMensagem.Create;
    VL_Erro := 0;
    try
        try
            while not Terminated do
            begin
                VL_Linha := '090520221728';
                if f_parar then
                    Exit;

                VL_Linha := '090520221729';
                if not Assigned(f_DComunicador) then
                    Exit;
                VL_Linha := '090520221741';


                if f_parar then
                    Exit;


                if TDComunicador(f_DComunicador^).IdTCPCliente.Connected then
                    TDComunicador(f_DComunicador^).IdTCPCliente.IOHandler.CheckForDisconnect;

                if f_parar then
                    Exit;

                if TDComunicador(f_DComunicador^).IdTCPCliente.Connected then
                    if not TDComunicador(f_DComunicador^).IdTCPCliente.IOHandler.InputBufferIsEmpty then
                    begin
                        VL_Linha := '090520221747';
                        try
                            VL_Dados := TDComunicador(f_DComunicador^).IdTCPCliente.Socket.ReadLn;
                        except
                            VL_Linha := '090520221750';
                        end;
                        VL_Linha := '090520221730';
                        if f_parar then
                            Exit;
                        VL_Linha := '090520221731';
                        if not Assigned(f_DComunicador) then
                            Exit;

                        if VL_Dados <> '' then
                        begin
                            VL_Erro := VL_Mensagem.CarregaTags(VL_Dados);
                            if VL_Erro <> 0 then
                            begin
                                if Assigned(TDComunicador(f_DComunicador^).V_ClienteRecebimento) then
                                    TDComunicador(f_DComunicador^).V_ClienteRecebimento('', TDComunicador(f_DComunicador^).V_ProcID, VL_Erro, PChar(VL_Dados))
                                else
                                    GravaLog(f_ArquivoLog, 0, '', 'comunicador', '220520221207', 'Erro na TThRecebe.Execute ', '', VL_Erro);
                            end
                            else
                            begin
                                VL_TransmissaoID := VL_Mensagem.ComandoDados;

                                if (VL_Mensagem.Comando <> '00D1') then
                                begin
                                    if Assigned(TDComunicador(f_DComunicador^).V_ClienteRecebimento) then
                                        TDComunicador(f_DComunicador^).V_ClienteRecebimento('', TDComunicador(f_DComunicador^).V_ProcID, 68, PChar(VL_Dados))
                                    else
                                        GravaLog(f_ArquivoLog, 0, '', 'comunicador', '220520221207', 'Erro na TThRecebe.Execute ', '', VL_Erro);
                                end
                                else

                                if (VL_TransmissaoID = '') then
                                begin
                                    if Assigned(TDComunicador(f_DComunicador^).V_ClienteRecebimento) then
                                    begin
                                        if (TDComunicador(f_DComunicador^).V_ConexaoCliente.Status = csLogado) or
                                            (TDComunicador(f_DComunicador^).V_ConexaoCliente.Status = csChaveado) then
                                            VL_Dados := Copy(VL_Dados, 1, 5) + TDComunicador(f_DComunicador^).V_ConexaoCliente.Aes.DecryptString(
                                                Copy(VL_Dados, 6, MaxInt));

                                        TDComunicador(f_DComunicador^).V_ClienteRecebimento('', TDComunicador(f_DComunicador^).V_ProcID, 0, PChar(VL_Dados));

                                    end
                                    else
                                        GravaLog(f_ArquivoLog, 0, '', 'comunicador', '220520221217',
                                            'Erro na TThRecebe.Execute não veio VAZIA tag 00D0 ', '', 0);

                                end
                                else
                                begin
                                    VL_Dados := VL_Mensagem.GetTagAsAstring('00D2');
                                    if (TDComunicador(f_DComunicador^).V_ConexaoCliente.Status = csLogado) or
                                        (TDComunicador(f_DComunicador^).V_ConexaoCliente.Status = csChaveado) then
                                        VL_Dados := Copy(VL_Dados, 1, 5) + TDComunicador(f_DComunicador^).V_ConexaoCliente.Aes.DecryptString(
                                            Copy(VL_Dados, 6, MaxInt));

                                    VL_Erro := TDComunicador(f_DComunicador^).V_EventoSocketCliente.SetDados(VL_TransmissaoID, VL_Dados);

                                    if VL_Erro <> 0 then
                                    begin
                                        if Assigned(TDComunicador(f_DComunicador^).V_ClienteRecebimento) then
                                            TDComunicador(f_DComunicador^).V_ClienteRecebimento(PChar(VL_TransmissaoID),
                                                TDComunicador(f_DComunicador^).V_ProcID, 0,
                                                PChar(VL_Dados))
                                        else
                                            GravaLog(f_ArquivoLog, 0, '', 'comunicador', '220520221207', 'Erro na TThRecebe.Execute ', '', VL_Erro);
                                    end
                                    else
                                        TDComunicador(f_DComunicador^).V_EventoSocketCliente.parar(VL_TransmissaoID);
                                end;

                            end;
                            VL_Dados := '';
                            VL_Mensagem.Limpar;
                        end;
                    end;
                sleep(10);
                VL_Linha := '090520221748';
            end;
            VL_Linha := '090520221744';
        except
            on e: EInOutError do
                GravaLog(f_ArquivoLog, 0, '', 'comunicador', VL_Linha, 'Erro na TThRecebe.Execute ' + e.ClassName + '/' + e.Message, '', 1);
        end;
    finally
        begin
            sleep(100);
        end;
    end;

end;


{ TThRecebeAguarda }


procedure TThRecebe.parar;
begin
    f_parar := True;
end;


function TDComunicador.ClienteTransmiteDados(var VO_Transmissao_ID: string; var VO_DadosO, VO_DadosI: ansistring;
    VP_TempoAguarda: integer; VP_AguardaRetorno: boolean): integer;
var
    VL_Evento: TAguardaEvento;
    VL_Temporizador: TTemporizador;
    VL_Mensagem: TMensagem;
    VL_DadosCriptografado: string;
    VL_DadosEnviar: string;
begin
    Result := 0;
    VL_DadosCriptografado := '';
    VL_DadosEnviar := '';
    try
        try
            VL_Mensagem := TMensagem.Create;

            if (V_ConexaoCliente.Status = csChaveado) or (V_ConexaoCliente.Status = csLogado) then
            begin
                VL_DadosCriptografado := Copy(VO_DadosO, 1, 5) + V_ConexaoCliente.Aes.EncryptString(Copy(VO_DadosO, 6, MaxInt));
                VL_DadosEnviar := VL_DadosCriptografado;
            end
            else
                VL_DadosEnviar := VO_DadosO;


            if VP_AguardaRetorno then
            begin
                Result := 67;

                VL_Temporizador := TTemporizador.Create;
                VL_Temporizador.V_Aguardando := True;
                VL_Temporizador.V_Executado := False;

                if VO_Transmissao_ID <> '' then
                    VL_Temporizador.V_ID := VO_Transmissao_ID
                else
                    VO_Transmissao_ID := VL_Temporizador.V_ID;

                VL_Mensagem.AddComando('00D1', VL_Temporizador.V_ID);
                VL_Mensagem.AddTag('00D2', VL_DadosEnviar);
                V_EventoSocketCliente.add(VL_Temporizador);
                IdTCPCliente.Socket.WriteLn(VL_Mensagem.TagsAsString);
                VL_Evento := VL_Temporizador.aguarda(VP_TempoAguarda, True, VL_Temporizador);
                case VL_Evento of
                    agEvento:
                    begin
                        VO_DadosI := VL_Temporizador.V_Dados;
                        Result := 0;
                    end;

                    agTempo: Result := 67;
                    agAborta: Result := 69;
                end;

                if Assigned(V_EventoSocketCliente) then
                    V_EventoSocketCliente.remove(VL_Temporizador);
                VL_Temporizador.Free;

            end
            else
            begin
                VL_Mensagem.AddComando('00D1', VO_Transmissao_ID);
                VL_Mensagem.AddTag('00D2', VL_DadosEnviar);
                IdTCPCliente.Socket.WriteLn(VL_Mensagem.TagsAsString);
            end;



        except
            Result := 83;
            DesconectarCliente;
        end;

    finally
        VL_Mensagem.Free;
    end;

end;

function TDComunicador.ClienteTransmiteSolicitacao(var VO_Transmissao_ID: string; var VO_Dados: TMensagem; var VO_Retorno: TMensagem;
    VP_Procedimento: TRetorno; VP_TempoAguarda: integer; VP_AguardaRetorno: boolean): integer;
var
    VL_Dados: ansistring;
    VL_Mensagem: TMensagem;
begin
    Result := 0;
    VL_Dados := '';
    try
        try
            VL_Mensagem := TMensagem.Create;
            VL_Mensagem.CarregaTags(VO_Dados.TagsAsString);
            VO_Dados.Limpar;
            VO_Retorno.Limpar;

            if (V_ConexaoCliente.Status <> csChaveado) and (V_ConexaoCliente.Status <> csLogado) then
            begin
                Result := ConectarCliente;
                if Result <> 0 then
                    Exit;
            end;
            Result := VL_Mensagem.TagToStr(VL_Dados);
            if Result <> 0 then
            begin
                GravaLog(V_ArquivoLog, 0, '', 'comunicador', '190520222159', 'Erro na TDComunicador.ClienteTransmiteSolicitacao ', '', Result);
                Exit;
            end;

            Result := ClienteVerificaConexao;

            if Result <> 0 then
            begin
                GravaLog(V_ArquivoLog, 0, '', 'comunicador', '190520222159', 'Erro na TDComunicador.ClienteTransmiteSolicitacao ', '', Result);
                Exit;
            end;

            Result := ClienteTransmiteDados(VO_Transmissao_ID, VL_Dados, VL_Dados, VP_TempoAguarda, VP_AguardaRetorno);
            if Result <> 0 then
            begin
                GravaLog(V_ArquivoLog, 0, '', 'comunicador', '190520222101', 'Erro na TDComunicador.ClienteTransmiteSolicitacao ', '', Result);
                Exit;

            end;
            if VP_AguardaRetorno then
            begin
                if VL_Dados = '' then
                begin
                    Result := 24;
                    V_ConexaoCliente.Status := csDesconectado;
                    if idTCPCliente.Connected then
                        DesconectarCliente;
                    GravaLog(V_ArquivoLog, 0, '', 'comunicador', '210520222014', 'Erro na TDComunicador.ClienteTransmiteSolicitacao ', '', Result);
                    Exit;

                end;

                Result := VO_Retorno.CarregaTags(VL_Dados);
                if Assigned(VP_Procedimento) then
                    VP_Procedimento(PChar(VO_Transmissao_ID), V_ProcID, Result, PChar(VL_Dados));
            end;
        except
            on e: EInOutError do
            begin
                Result := 24;
                GravaLog(V_ArquivoLog, 0, '', 'comunicador', '090520221723', 'Erro na TDComunicador.ClienteTransmiteSolicitacao ' +
                    e.ClassName + '/' + e.Message, '', Result);

                V_ConexaoCliente.Status := csDesconectado;
                if idTCPCliente.Connected then
                    DesconectarCliente;
            end;
        end;
    finally
        VL_Mensagem.Free;
    end;
end;



end.
