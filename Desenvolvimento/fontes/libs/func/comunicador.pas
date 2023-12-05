unit comunicador;


{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils, LbRSA, StrUtils, LbClass, IdTCPClient, IdTCPServer, funcoes, IdContext, IdComponent, IdGlobal, base64;

type

    { TDComunicador }

    TKey = array [0..31] of byte;

    TTransmissaoComando = function(AOwner: Pointer; VP_Conexao_ID: integer; VP_Transmissao_ID, VP_Comando: string; var VO_Dados: string): integer of object;

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

    { TTConexao }

    TTConexao = class
        Aes: TLbRijndael;
        Rsa: TLbRSA;
        ClienteIp: string;
        ClientePorta: integer;
        ServidorHost: ansistring;
        ServidorPorta: integer;
        Hora: TDateTime;
        ID: integer;
        DOC: string;
        Terminal_Tipo: ansistring;
        Terminal_ID: integer;
        Identificacao: string;    //unica em toda configuração do open tef para cada tipo de terminal, para uso como contigencia

        ModuloPublico: ansistring;
        ExpoentePublico: ansistring;
        Status: TConexaoStatus;
        StatusDesejado: TConexaoStatus;
        DComunicador: Pointer;
        Permissao: TPermissao;
        ConexaoAtivadada: boolean;
    public
        constructor Create(VP_DComunicador: Pointer);
        destructor Destroy; override;
        function getModuloPublico: ansistring;
        function getExpoentePublico: ansistring;
        procedure setModuloPublico(VP_Dados: ansistring);
        procedure setExpoentePublico(VP_Dados: ansistring);
        procedure setChaveComunicacao(VP_Chave: ansistring);
        function getChavePublica: ansistring;
        function getChaveComunicacao: ansistring;
        function GetSocketServidor(VP_DComunicador: Pointer; VP_Conexao_ID: integer; var VO_AContext: TIdContext): boolean;
        function GetSocketServidorIdentificacao(VP_DComunicador: Pointer; VP_TipoTerminal, VP_TerminalIdentificacao: string;
            var VO_AContext: TIdContext): boolean;

        property Chave_Comunicacao: ansistring read getChaveComunicacao write setChaveComunicacao;
    end;


    { TThRecebe }

    TThRecebe = class(TThread)
    protected
        f_DComunicador: Pointer;
        procedure Execute; override;
    public
        constructor Create(VP_DComunicador: Pointer);
    end;

    TThClienteProcessaRecebe = class(TThread)
    protected
        f_DComunicador: Pointer;
        f_Dados: string;
        procedure Execute; override;
    public
        constructor Create(VP_Comunicador: Pointer; VP_Dados: string);
    end;


    TThServidorProcessaRecebe = class(TThread)
    protected
        f_TConexao: TTConexao;
        f_DComunicador: Pointer;
        f_Dados: string;
        procedure Execute; override;
    public
        constructor Create(VP_Comunicador: Pointer; VP_Dados: string; VP_TConexao: TTConexao);
    end;


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
        V_Versao_Comunicacao: integer;
        V_ThRecebeEscuta: TThRecebe;
        V_EventoSocketAguardaResposta: TEventoSocket;
        V_ConexaoCliente: TTConexao;
        V_ServidorRecebimento: TServidorRecebimento;   //procedure disparado no envento que o IdTCPServidor recebe passa a conexão do cliente
        V_ClienteRecebimento: TRetorno;   //procedure disparado no envento que o IdTCPCliente recebe sem ter solicitado ou quando a solicitação expirou
        V_ClienteRecebimentoModulo: TRetornoModulo;
        //procedure disparado no envento que o IdTCPCliente recebe sem ter solicitado ou quando a solicitação expirou
        V_TransmissaoComando: TTransmissaoComando;
        // comando enviados pelo comunicador do servidor diretamente para o opentef
        V_ArquivoLog: string;
        V_ProcID: integer;
        V_Modulo: Pointer;
        V_Parar: boolean;
        V_DComunicador: Pointer;
        V_ListaThreads: TList;

        function DesconectarCliente(VP_DComunicador: Pointer): integer;
        function DesconectarClienteID(VP_DComunicador: Pointer; VP_Conexao_ID: integer): integer;
        function ConectarCliente(VP_DComunicador: Pointer): integer;

        function ClienteVerificaConexao(VP_DComunicador: Pointer): integer;


        function ClienteTransmiteDados(VP_DComunicador: Pointer; var VO_Transmissao_ID: string; var VO_DadosO, VO_DadosI: ansistring;
            VP_TempoAguarda: integer; VP_AguardaRetorno: boolean): integer;

        function ClienteTransmiteSolicitacao(VP_DComunicador: Pointer; var VO_Transmissao_ID: string; var VO_Dados: TMensagem;
            var VO_Retorno: TMensagem; VP_Procedimento: TRetorno; VP_TempoAguarda: integer; VP_AguardaRetorno: boolean): integer;


        function ServidorTransmiteSolicitacaoID(VP_DComunicador: Pointer; VP_TempoAguarda: integer; VP_AguardaRetorno: boolean;
            VP_Procedimento: TServidorRecebimento; VP_Transmissao_ID: string; VP_Mensagem: TMensagem; var VO_Mensagem: TMensagem;
            VP_Conexao_ID: integer): integer;

        function ServidorTransmiteSolicitacaoIdentificacao(VP_DComunicador: Pointer; VP_TempoAguarda: integer;
            VP_AguardaRetorno: boolean; VP_Procedimento: TServidorRecebimento; VP_Transmissao_ID: string; VP_Mensagem: TMensagem;
            var VO_Mensagem: TMensagem; VP_TipoTerminal, VP_TerminalIdentificacao: string): integer;

        procedure desativartodasconexao(VP_DComunicador: Pointer);

    end;

var

    F_NumeroConexao: integer;

const
    LFL = #01;

implementation

uses
    Def;

{$R *.lfm}

{ TThServidorConclui }

procedure TThServidorProcessaRecebe.Execute;
var
    VL_Mensagem: TMensagem;
    VL_Erro: integer;
    VL_TransmissaoID: string;
    VL_AContext: TIdContext;
    VL_Dados: string;
    VL_Desafio: string;
    VL_Identificacao: string;
begin
    VL_Erro := 0;
    VL_TransmissaoID := '';
    VL_Desafio := '';
    VL_Identificacao := '';
    VL_Mensagem := TMensagem.Create;
    VL_AContext := nil;
    try
        try

            GravaLog(TDComunicador(f_DComunicador).V_ArquivoLog, 0, '', 'comunicador', '141120231415', 'TThServidorProcessaRecebe.Execute', f_Dados, 0, 4);

            if Terminated then
                Exit;

            if TDComunicador(f_DComunicador).V_Parar then
                Exit;

            if (f_Dados = '') then
            begin
                Exit;
            end;

            if not Assigned(f_TConexao) then
            begin
                GravaLog(TDComunicador(f_DComunicador).V_ArquivoLog, 0, '', 'comunicador', '140920221152',
                    'TThServidorProcessaRecebe.Execute; ', '', 0, 1);
                Exit;
            end
            else
            if not f_TConexao.GetSocketServidor(f_DComunicador, f_TConexao.ID, VL_AContext) then
            begin
                GravaLog(TDComunicador(f_DComunicador).V_ArquivoLog, 0, '', 'comunicador', '140920221153',
                    'TThServidorProcessaRecebe.Execute; ', '', 0, 1);
                Exit;
            end;

            if VL_AContext = nil then
            begin
                GravaLog(TDComunicador(f_DComunicador).V_ArquivoLog, 0, '', 'comunicador', '140920221154',
                    'TThServidorProcessaRecebe.Execute; ', '', 0, 1);
                Exit;
            end;



            VL_Erro := VL_Mensagem.CarregaTags(f_Dados);
            if VL_Erro <> 0 then
            begin
                GravaLog(TDComunicador(f_DComunicador).V_ArquivoLog, 0, '', 'comunicador', '250520221716',
                    'TThServidorProcessaRecebe.Execute; ', '', VL_Erro, 1);
                Exit;
            end;


            if VL_Mensagem.Comando <> '00D1' then
            begin
                GravaLog(TDComunicador(f_DComunicador).V_ArquivoLog, 0, '', 'comunicador', '250520221717',
                    'TThServidorProcessaRecebe.Execute; ', '', 68, 1);

                Exit;
            end;


            VL_TransmissaoID := VL_Mensagem.ComandoDados;
            VL_Dados := VL_Mensagem.GetTagAsAstring('00D2');

            if (f_TConexao.Status = csChaveado) or (f_TConexao.Status = csLogado) then
                VL_Dados := Copy(VL_Dados, 1, 5) + f_TConexao.Aes.DecryptString(Copy(VL_Dados, 6, MaxInt));


            if VL_Dados = '00002161400E311S' then  // comando de eco
            begin
                VL_Mensagem.CarregaTags('00002161400E311R');
                TDComunicador(f_DComunicador).ServidorTransmiteSolicitacaoID(f_DComunicador, 3000, False, nil, VL_TransmissaoID,
                    VL_Mensagem, VL_Mensagem, f_TConexao.ID);

                Exit;
            end;


            if (VL_TransmissaoID = '') then
            begin

                GravaLog(TDComunicador(f_DComunicador).V_ArquivoLog, 0, '', 'comunicador', '250520221718',
                    'ID da transmissao vazia', '', 0, 1);
                Exit;

            end;

            VL_Mensagem.Limpar;
            VL_Mensagem.CarregaTags(VL_Dados);

            if ((VL_Mensagem.Comando = '0021') and (VL_Mensagem.ComandoDados = 'S')) then  // solicita conexao(troca de chave rsa)
            begin
                if Assigned(f_TConexao) then
                begin
                    TDComunicador(f_DComunicador).V_ConexaoCliente.setModuloPublico(VL_Mensagem.GetTagAsAstring('0008'));  // CHAVE PUBLICA MODULO
                    TDComunicador(f_DComunicador).V_ConexaoCliente.setExpoentePublico(VL_Mensagem.GetTagAsAstring('0027')); // CHAVE PUBLICA EXPOENTE

                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('0021', 'R'); // troca de chave rsa aceita
                    VL_Mensagem.AddTag('0008', f_TConexao.ModuloPublico); // CHAVE PUBLICA MODULO
                    VL_Mensagem.AddTag('0027', f_TConexao.ExpoentePublico); // CHAVE PUBLICA EXPOENTE

                    TDComunicador(f_DComunicador).ServidorTransmiteSolicitacaoID(f_DComunicador, 3000, False, nil, VL_TransmissaoID,
                        VL_Mensagem, VL_Mensagem, f_TConexao.ID);

                    exit;
                end;
            end;

            if ((VL_Mensagem.Comando = '0103') and (VL_Mensagem.ComandoDados = 'S')) then  // solicita desafio de chave
            begin
                if VL_Mensagem.GetTagAsAstring('00E3') = '' then // transacao criptografada
                begin
                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('0026', '92');

                    TDComunicador(f_DComunicador).ServidorTransmiteSolicitacaoID(f_DComunicador, 3000, False, nil, VL_TransmissaoID,
                        VL_Mensagem, VL_Mensagem, f_TConexao.ID);
                    Exit;
                end;

                VL_Dados := f_TConexao.Rsa.DecryptString(VL_Mensagem.GetTagAsAstring('00E3'));  // transacao criptografada

                VL_Mensagem.Limpar;
                VL_Erro := VL_Mensagem.CarregaTags(VL_Dados);

                if VL_Erro <> 0 then
                begin
                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('0026', '92');

                    TDComunicador(f_DComunicador).ServidorTransmiteSolicitacaoID(f_DComunicador, 3000, False, nil, VL_TransmissaoID,
                        VL_Mensagem, VL_Mensagem, f_TConexao.ID);
                    Exit;
                end;

                VL_Mensagem.GetTag('0106', VL_Desafio); // desafio
                VL_Mensagem.GetTag('0108', VL_Identificacao); // identificacao

                if VL_Identificacao = '' then // identificacao
                begin
                    f_TConexao.Aes.GenerateKey(VL_Mensagem.GetTagAsAstring('0009')); // chave simetrica aes
                end
                else
                begin
                    if not Assigned(TDComunicador(f_DComunicador).V_TransmissaoComando) then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('0026', '105');

                        TDComunicador(f_DComunicador).ServidorTransmiteSolicitacaoID(f_DComunicador, 3000, False, nil, VL_TransmissaoID,
                            VL_Mensagem, VL_Mensagem, f_TConexao.ID);
                        Exit;
                    end;

                    VL_Mensagem.GetTag('0108', VL_Identificacao); // identificador

                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('0022', 'S'); // SOLICITA DADOS DA IDENTIFICACAO
                    VL_Mensagem.AddTag('0108', VL_Identificacao); // IDENTIFICADOR

                    VL_Erro := TDComunicador(f_DComunicador).V_TransmissaoComando(TDComunicador(f_DComunicador), f_TConexao.ID,
                        VL_TransmissaoID, VL_Mensagem.TagsAsString, VL_Dados);

                    if VL_Erro <> 0 then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('0026', IntToStr(VL_Erro));

                        TDComunicador(f_DComunicador).ServidorTransmiteSolicitacaoID(f_DComunicador, 3000, False, nil, VL_TransmissaoID,
                            VL_Mensagem, VL_Mensagem, f_TConexao.ID);
                        Exit;
                    end;

                    VL_Mensagem.Limpar;
                    VL_Erro := VL_Mensagem.CarregaTags(VL_Dados);

                    if VL_Erro <> 0 then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('0026', IntToStr(VL_Erro));

                        TDComunicador(f_DComunicador).ServidorTransmiteSolicitacaoID(f_DComunicador, 3000, False, nil, VL_TransmissaoID,
                            VL_Mensagem, VL_Mensagem, f_TConexao.ID);
                        Exit;
                    end;

                    f_TConexao.Aes.GenerateKey(VL_Mensagem.GetTagAsAstring('0023')); // chave de comunicacao
                end;


                VL_Desafio := f_TConexao.Aes.DecryptString(VL_Desafio);

                if Copy(VL_Desafio, 1, 2) <> 'OK' then
                begin
                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('0026', '92');

                    TDComunicador(f_DComunicador).ServidorTransmiteSolicitacaoID(f_DComunicador, 3000, False, nil, VL_TransmissaoID,
                        VL_Mensagem, VL_Mensagem, f_TConexao.ID);
                    Exit;
                end;

                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0103', 'R'); // retorno do desafio da chave
                VL_Mensagem.AddTag('0106', f_TConexao.Aes.EncryptString(Formata('OKOK' +
                    DateTimeToStr(Now) + IntToStr(Random(999999)), ' ', 30, True))); // desafio

                VL_Dados := VL_Mensagem.TagsAsString;

                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0103', 'R'); // RETORNO DO DESAFIO DE CHAVE
                VL_Mensagem.AddTag('00E3', TDComunicador(f_DComunicador).V_ConexaoCliente.Rsa.EncryptString(VL_Dados)); // transacao criptografada

                TDComunicador(f_DComunicador).ServidorTransmiteSolicitacaoID(f_DComunicador, 3000, False, nil, VL_TransmissaoID,
                    VL_Mensagem, VL_Mensagem, f_TConexao.ID);
                if Assigned(f_TConexao) then
                    if VL_Identificacao = '' then // identificacao
                        F_Tconexao.Status := csChaveado
                    else
                        F_Tconexao.Status := csChaveadoAssinado;


                Exit;

            end;

            VL_Erro := TDComunicador(f_DComunicador).V_EventoSocketAguardaResposta.SetDados(VL_TransmissaoID, VL_Dados);

            if VL_Erro <> 0 then
            begin
                if Assigned(TDComunicador(f_DComunicador).V_ServidorRecebimento) then
                    TDComunicador(f_DComunicador).V_ServidorRecebimento(0, VL_TransmissaoID, VL_Dados,
                        f_TConexao.ID, f_TConexao.Terminal_Tipo,
                        f_TConexao.Terminal_ID, f_TConexao.DOC,
                        f_TConexao.Status, f_TConexao.Identificacao,
                        f_TConexao.Permissao, f_TConexao.ClienteIp)
                else
                    GravaLog(TDComunicador(f_DComunicador).V_ArquivoLog, 0, '', 'comunicador', '250520221719',
                        'TThServidorProcessaRecebe.Execute; ', '', VL_Erro, 1);
            end
            else
                TDComunicador(f_DComunicador).V_EventoSocketAguardaResposta.parar(VL_TransmissaoID);

        except
            on e: Exception do
                GravaLog(TDComunicador(f_DComunicador).V_ArquivoLog, 0, '', 'comunicador', '120920222118', 'TThServidorProcessaRecebe.Execute ' +
                    e.ClassName + '/' + e.Message, '', 1, 1);
        end;


    finally
        VL_Mensagem.Free;
    end;

end;

constructor TThServidorProcessaRecebe.Create(VP_Comunicador: Pointer; VP_Dados: string; VP_TConexao: TTConexao);
begin
    inherited Create(True);
    FreeOnTerminate := False;
    f_Dados := VP_Dados;
    f_TConexao := VP_TConexao;
    f_DComunicador := VP_Comunicador;
end;

{ TThRecebeConclui }

procedure TThClienteProcessaRecebe.Execute;
var
    VL_Dados: string;
    VL_TransmissaoID: string;
    VL_Linha: string;
    VL_Mensagem: TMensagem;
    VL_Erro: integer;
    VL_Desafio: ansistring;
begin
    VL_Linha := '';
    VL_Desafio := '';
    VL_Mensagem := TMensagem.Create;
    try
        try

            GravaLog(TDComunicador(f_DComunicador).V_ArquivoLog, 0, '', 'comunicador', '141120231417',
                'TThClienteProcessaRecebe.Execute', f_Dados, 0, 4);

            if ((TDComunicador(f_DComunicador).V_ConexaoCliente.Status = csDesconectado) and
                (TDComunicador(f_DComunicador).V_ConexaoCliente.StatusDesejado = csLogado)) then
            begin
                TDComunicador(f_DComunicador).V_ConexaoCliente.StatusDesejado := csDesconectado;
                if Assigned(TDComunicador(f_DComunicador).V_ClienteRecebimento) then
                    TDComunicador(f_DComunicador).V_ClienteRecebimento('', TDComunicador(f_DComunicador).V_ProcID, 96, PChar(''))
                else
                if Assigned(TDComunicador(f_DComunicador).V_ClienteRecebimentoModulo) then
                    TDComunicador(f_DComunicador).V_ClienteRecebimentoModulo('', 0, TDComunicador(f_DComunicador).V_ProcID,
                        96, PChar(''), TDComunicador(f_DComunicador).V_Modulo);
                Exit;
            end;


            if Terminated then
                Exit;

            if TDComunicador(f_DComunicador).V_Parar then
                Exit;

            VL_Dados := f_Dados;


            if TDComunicador(f_DComunicador).V_ConexaoCliente.Status = csDesconectado then
                exit;


            if VL_Dados = '' then
                exit;

            VL_Erro := VL_Mensagem.CarregaTags(VL_Dados);
            if VL_Erro <> 0 then
            begin
                if Assigned(TDComunicador(f_DComunicador).V_ClienteRecebimento) then
                    TDComunicador(f_DComunicador).V_ClienteRecebimento('', TDComunicador(f_DComunicador).V_ProcID,
                        VL_Erro, PChar(VL_Dados))
                else
                if Assigned(TDComunicador(f_DComunicador).V_ClienteRecebimentoModulo) then
                    TDComunicador(f_DComunicador).V_ClienteRecebimentoModulo('', 0, TDComunicador(f_DComunicador).V_ProcID,
                        VL_Erro, PChar(VL_Dados), TDComunicador(f_DComunicador).V_Modulo)
                else


                    GravaLog(TDComunicador(f_DComunicador).V_ArquivoLog, 0, '', 'comunicador',
                        '140920221150', 'Erro na TThRecebe.Execute ', '', VL_Erro, 1);
                exit;
            end;

            VL_TransmissaoID := VL_Mensagem.ComandoDados;

            if (VL_Mensagem.Comando <> '00D1') then
            begin
                if Assigned(TDComunicador(f_DComunicador).V_ClienteRecebimento) then
                    TDComunicador(f_DComunicador).V_ClienteRecebimento('', TDComunicador(f_DComunicador).V_ProcID,
                        68, PChar(VL_Dados))
                else
                if Assigned(TDComunicador(f_DComunicador).V_ClienteRecebimentoModulo) then
                    TDComunicador(f_DComunicador).V_ClienteRecebimentoModulo('', 0, TDComunicador(f_DComunicador).V_ProcID,
                        VL_Erro, PChar(VL_Dados), TDComunicador(f_DComunicador).V_Modulo)
                else

                    GravaLog(TDComunicador(f_DComunicador).V_ArquivoLog, 0, '', 'comunicador',
                        '140920221151', 'Erro na TThRecebe.Execute ', '', VL_Erro, 1);
                exit;
            end;


            if (VL_TransmissaoID = '') then
            begin
                GravaLog(TDComunicador(f_DComunicador).V_ArquivoLog, 0, '', 'comunicador', '220520221217',
                    'Erro na TThRecebe.Execute veio sem ID de transmissao ', '', 0, 1);

                exit;
            end;

            VL_Dados := VL_Mensagem.GetTagAsAstring('00D2');

            if TDComunicador(f_DComunicador).V_ConexaoCliente.Status > csLink then
                VL_Dados := Copy(VL_Dados, 1, 5) + TDComunicador(f_DComunicador).V_ConexaoCliente.Aes.DecryptString(Copy(VL_Dados, 6, MaxInt))
            else
                VL_Dados := Copy(VL_Dados, 1, 5) + DecodeStringBase64(Copy(VL_Dados, 6, MaxInt));

            if VL_Dados = '000021400E211S' then  // comando de eco
            begin
                VL_Dados := '000021400E211R';
                TDComunicador(f_DComunicador).ClienteTransmiteDados(f_DComunicador, VL_TransmissaoID, VL_Dados, VL_Dados, 3000, False);
                exit;
            end;

            VL_Mensagem.Limpar;
            VL_Mensagem.CarregaTags(VL_Dados);

            if ((VL_Mensagem.Comando = '0021') and (VL_Mensagem.ComandoDados = 'R')) then // troca da chave rsa
            begin
                if Assigned(TDComunicador(f_DComunicador).V_ConexaoCliente) then
                begin
                    TDComunicador(f_DComunicador).V_ConexaoCliente.setModuloPublico(VL_Mensagem.GetTagAsAstring('0008'));
                    TDComunicador(f_DComunicador).V_ConexaoCliente.setExpoentePublico(VL_Mensagem.GetTagAsAstring('0027'));

                    VL_Desafio := TDComunicador(f_DComunicador).V_ConexaoCliente.Aes.EncryptString(Formata('OK' +
                        DateTimeToStr(Now) + IntToStr(Random(999999)), ' ', 30, True));

                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('0103', 'S'); // SOLICITA DESAFIO DE CHAVE
                    VL_Mensagem.AddTag('0108', TDComunicador(f_DComunicador).V_ConexaoCliente.Identificacao); // IDENTIFICACAO
                    VL_Mensagem.AddTag('0106', VL_Desafio); // DESAFIO DA CHAVE

                    if TDComunicador(f_DComunicador).V_ConexaoCliente.Identificacao = '' then
                        VL_Mensagem.AddTag('0009', TDComunicador(f_DComunicador).V_ConexaoCliente.getChaveComunicacao); // CHAVE AES

                    VL_Dados := VL_Mensagem.TagsAsString;

                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('0103', 'S'); // SOLICITA DESAFIO DE CHAVE
                    VL_Mensagem.AddTag('00E3', TDComunicador(f_DComunicador).V_ConexaoCliente.Rsa.EncryptString(VL_Dados)); // transacao criptografada

                    VL_Dados := VL_Mensagem.TagsAsString;

                    TDComunicador(f_DComunicador).ClienteTransmiteDados(f_DComunicador, VL_TransmissaoID, VL_Dados, VL_Dados, 3000, False);
                    exit;
                end;
            end;

            if ((VL_Mensagem.Comando = '0103') and (VL_Mensagem.ComandoDados = 'R')) then // retorno do desafio de chave
            begin
                if VL_Mensagem.GetTagAsAstring('00E3') = '' then // transacao criptografada
                begin
                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('0026', '92');

                    VL_Dados := VL_Mensagem.TagsAsString;

                    TDComunicador(f_DComunicador).ClienteTransmiteDados(f_DComunicador, VL_TransmissaoID, VL_Dados, VL_Dados, 3000, False);
                    Exit;
                end;

                VL_Dados := TDComunicador(f_DComunicador).V_ConexaoCliente.Rsa.DecryptString(VL_Mensagem.GetTagAsAstring('00E3'));

                VL_Mensagem.Limpar;
                VL_Erro := VL_Mensagem.CarregaTags(VL_Dados);

                if VL_Erro <> 0 then
                begin
                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('0026', '92');

                    VL_Dados := VL_Mensagem.TagsAsString;

                    TDComunicador(f_DComunicador).ClienteTransmiteDados(f_DComunicador, VL_TransmissaoID, VL_Dados, VL_Dados, 3000, False);
                    Exit;
                end;

                VL_Desafio := TDComunicador(f_DComunicador).V_ConexaoCliente.Aes.DecryptString(VL_Mensagem.GetTagAsAstring('0106'));

                if Copy(VL_Desafio, 1, 4) <> 'OKOK' then
                begin
                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('0026', '92');

                    VL_Dados := VL_Mensagem.TagsAsString;

                    TDComunicador(f_DComunicador).ClienteTransmiteDados(f_DComunicador, VL_TransmissaoID, VL_Dados, VL_Dados, 3000, False);
                    Exit;
                end;

                if TDComunicador(f_DComunicador).V_ConexaoCliente.Identificacao = '' then
                    TDComunicador(f_DComunicador).V_ConexaoCliente.Status := csChaveado
                else
                    TDComunicador(f_DComunicador).V_ConexaoCliente.Status := csChaveadoAssinado;

            end;

            VL_Erro := TDComunicador(f_DComunicador).V_EventoSocketAguardaResposta.SetDados(VL_TransmissaoID, VL_Dados);

            if VL_Erro <> 0 then
            begin

                if Assigned(TDComunicador(f_DComunicador).V_ClienteRecebimento) then
                    TDComunicador(f_DComunicador).V_ClienteRecebimento(PChar(VL_TransmissaoID),
                        TDComunicador(f_DComunicador).V_ProcID, 0, PChar(VL_Dados))
                else
                if Assigned(TDComunicador(f_DComunicador).V_ClienteRecebimentoModulo) then
                    TDComunicador(f_DComunicador).V_ClienteRecebimentoModulo(PChar(VL_TransmissaoID), 0,
                        TDComunicador(f_DComunicador).V_ProcID, 0, PChar(VL_Dados), TDComunicador(f_DComunicador).V_Modulo);

            end
            else
                TDComunicador(f_DComunicador).V_EventoSocketAguardaResposta.parar(VL_TransmissaoID);

        except
            on e: Exception do
                GravaLog(TDComunicador(f_DComunicador).V_ArquivoLog, 0, '', 'comunicador', VL_Linha, 'Erro na TThRecebe.Execute ' +
                    e.ClassName + '/' + e.Message, '', 1, 1);
        end;
    finally
        begin
            VL_Mensagem.Free;

        end;
    end;

end;

constructor TThClienteProcessaRecebe.Create(VP_Comunicador: Pointer; VP_Dados: string);
begin
    inherited Create(True);
    Self.f_Dados := VP_Dados;
    Self.f_DComunicador := VP_Comunicador;
    Self.FreeOnTerminate := True;
    Self.Start;
end;

{ TEvento }

constructor TEventoSocket.Create;
begin
    fTemporizadores := TList.Create;
end;

destructor TEventoSocket.Destroy;
var

    VL_Temporizador: ^TTemporizador;

begin
    while fTemporizadores.Count > 0 do
    begin
        VL_Temporizador := fTemporizadores[0];
        if Assigned(VL_Temporizador) then
        begin
            VL_Temporizador^.abortar;
            VL_Temporizador^.Free;
            VL_Temporizador := nil;
        end;
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
        if Assigned(TTemporizador(fTemporizadores[VL_I])) then
        begin
            if TTemporizador(fTemporizadores[VL_I]).V_ID = VP_ID then
            begin
                TTemporizador(fTemporizadores[VL_I]).abortar;
                Result := 0;
            end;
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
        if Assigned(TTemporizador(fTemporizadores[VL_I])) then
        begin
            if TTemporizador(fTemporizadores[VL_I]).V_ID = VP_ID then
            begin
                TTemporizador(fTemporizadores[VL_I]).V_Dados := VP_Dados;
                Result := 0;
            end;
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




function TDComunicador.ConectarCliente(VP_DComunicador: Pointer): integer;
var
    VL_Mensagem: TMensagem;
    VL_Comando: ansistring;
    VL_Dados, VL_DadosO, VL_DadosI: ansistring;
    VL_ChaveComunicacao: ansistring;
    VL_ExpoentePublico, VL_ModuloPublico: ansistring;
    VL_Transmissao_ID: string;
    VL_Desafio: ansistring;
begin
    VL_Mensagem := TMensagem.Create;
    VL_ModuloPublico := '';
    VL_ExpoentePublico := '';
    VL_ChaveComunicacao := '';
    VL_Dados := '';
    VL_DadosO := '';
    VL_DadosI := '';
    VL_Comando := '';
    VL_Transmissao_ID := '';
    VL_Desafio := '';
    try
        begin
            if (TDComunicador(VP_DComunicador).V_ConexaoCliente.Status = csChaveado) or
                (TDComunicador(VP_DComunicador).V_ConexaoCliente.Status = csLogado) then
            begin
                Result := 0;
                exit;
            end;


            if TDComunicador(VP_DComunicador).idTCPCliente.Connected then
                DesconectarCliente(VP_DComunicador);

            TDComunicador(VP_DComunicador).idTCPCliente.Host := TDComunicador(VP_DComunicador).V_ConexaoCliente.ServidorHost;
            TDComunicador(VP_DComunicador).idTCPCliente.Port := TDComunicador(VP_DComunicador).V_ConexaoCliente.ServidorPorta;

            try
                begin
                    TDComunicador(VP_DComunicador).idTCPCliente.Connect;
                    TDComunicador(VP_DComunicador).idTCPCliente.IOHandler.MaxLineLength := MaxInt;
                    TDComunicador(VP_DComunicador).idTCPCliente.IOHandler.SendBufferSize := MaxInt;
                end;
            except
                on e: Exception do
                begin
                    GravaLog(TDComunicador(VP_DComunicador).V_ArquivoLog, 0, '', 'ConectarCliente', '281120231227',
                        ' ' + e.ClassName + '/' + e.Message, '', 103, 1);
                    Result := 103;
                    Exit;
                end;
            end;

            if TDComunicador(VP_DComunicador).idTCPCliente.Connected = False then
            begin
                Result := 26;
                Exit;
            end;


            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('0021', 'S'); // PEDIDO DE CONEXÃO(troca de chave rsa)
            VL_Mensagem.AddTag('0008', TDComunicador(VP_DComunicador).V_ConexaoCliente.ModuloPublico); // CHAVE PUBLICA MODULO
            VL_Mensagem.AddTag('0027', TDComunicador(VP_DComunicador).V_ConexaoCliente.ExpoentePublico); // CHAVE PUBLICA EXPOENTE

            VL_DadosO := VL_Mensagem.TagsAsString;

            Result := ClienteTransmiteDados(VP_DComunicador, VL_Transmissao_ID, VL_DadosO, VL_DadosI, 15000, True);

            if Result <> 0 then
                Exit;

            VL_Mensagem.Limpar;
            VL_Mensagem.CarregaTags(VL_DadosI);

            if VL_Mensagem.Comando = '0026' then
            begin
                Result := StrToInt(VL_Mensagem.ComandoDados);
                Exit;
            end;

            {
            if VL_Comando = '0025' then
            begin
                VL_Mensagem.GetTag('0008', VL_ModuloPublico);
                VL_Mensagem.GetTag('0027', VL_ExpoentePublico);
                VL_Mensagem.GetTag('0009', VL_ChaveComunicacao);
                VL_Mensagem.GetTag('0022', VL_ChaveComunicacaoIDX);
                VL_Mensagem.GetTag('0023', VL_OK);


                TDComunicador(VP_DComunicador).V_ConexaoCliente.setExpoentePublico(VL_ExpoentePublico);
                TDComunicador(VP_DComunicador).V_ConexaoCliente.setModuloPublico(VL_ModuloPublico);
                VL_ChaveComunicacao := TDComunicador(VP_DComunicador).V_ConexaoCliente.Rsa.DecryptString(VL_ChaveComunicacao);
                TDComunicador(VP_DComunicador).V_ConexaoCliente.setChaveComunicacao(VL_ChaveComunicacao);
                VL_OK := V_ConexaoCliente.Aes.DecryptString(VL_OK);


                if VL_OK <> 'OK' then
                begin
                    Result := 32;
                    Exit;
                end;
                TDComunicador(VP_DComunicador).V_ConexaoCliente.Status := csChaveado;
            end;
            }
        end;

    finally
        VL_Mensagem.Free;
    end;

end;

function TDComunicador.ClienteVerificaConexao(VP_DComunicador: Pointer): integer;
var
    VL_Dados, VL_Transmissao_ID: string;
begin
    try
        begin
            //    result:=0;
            //   exit;
            //TDComunicador(VP_DComunicador).IdTCPCliente.CheckForGracefulDisconnect(True);
            VL_Dados := '00002161400E311S';
            VL_Transmissao_ID := '';
            Result := ClienteTransmiteDados(VP_DComunicador, VL_Transmissao_ID, VL_Dados, VL_Dados, 30000, True);
        end;

    except
        on e: Exception do
        begin
            Result := 83;
            GravaLog(TDComunicador(VP_DComunicador).V_ArquivoLog, 0, '', 'TDComunicador.ClienteVerificaConexao', '160920221056',
                ' ' + e.ClassName + '/' + e.Message, '', 1, 1);
            DesconectarCliente(VP_DComunicador);
        end;
    end;
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

    DOC := '';
    Terminal_Tipo := '';
    Terminal_ID := 0;

    VL_Key := TMemoryStream.Create;
    Aes := TLbRijndael.Create(nil);
    Rsa := TLbRSA.Create(nil);

    Aes.KeySize := TDComunicador(DComunicador).CriptoAes.KeySize;
    Aes.CipherMode := TDComunicador(DComunicador).CriptoAes.CipherMode;
    Aes.GenerateRandomKey;

    Rsa.KeySize := TDComunicador(DComunicador).CriptoRsa.KeySize;

    F_NumeroConexao := F_NumeroConexao + 1;
    ID := F_NumeroConexao;

    TDComunicador(DComunicador).CriptoRsa.PrivateKey.StoreToStream(VL_Key);
    VL_Key.Position := 0;
    Rsa.PrivateKey.LoadFromStream(VL_Key);

    ExpoentePublico := TDComunicador(DComunicador).CriptoRsa.PublicKey.ExponentAsString;
    ModuloPublico := TDComunicador(DComunicador).CriptoRsa.PublicKey.ModulusAsString;

    VL_Key.Free;
    inherited Create;
end;

destructor TTConexao.Destroy;
begin
    Aes.Free;
    Rsa.Free;
    inherited Destroy;
end;

function TTConexao.getModuloPublico: ansistring;
begin
    Result := Rsa.PublicKey.ModulusAsString;
end;

function TTConexao.getExpoentePublico: ansistring;
begin
    Result := Rsa.PublicKey.ExponentAsString;
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

function TTConexao.GetSocketServidor(VP_DComunicador: Pointer; VP_Conexao_ID: integer; var VO_AContext: TIdContext): boolean;
var
    VL_I: integer;
    VL_Clientes: TIdContextList;
begin
    Result := False;
    VO_AContext := nil;
    if VP_Conexao_ID < 1 then
        exit;
    try
        VL_Clientes := TDComunicador(VP_DComunicador).IdTCPServidor.Contexts.LockList;

        for VL_I := 0 to VL_Clientes.Count - 1 do
            if TTConexao(TIdContext(VL_Clientes.Items[VL_I]).Data).ID = VP_Conexao_ID then
            begin
                VO_AContext := TIdContext(VL_Clientes.Items[VL_I]);
                Result := True;
                Exit;
            end;
    finally
        TDComunicador(VP_DComunicador).IdTCPServidor.Contexts.UnlockList;
    end;

end;

function TTConexao.GetSocketServidorIdentificacao(VP_DComunicador: Pointer; VP_TipoTerminal, VP_TerminalIdentificacao: string;
    var VO_AContext: TIdContext): boolean;
var
    VL_I: integer;
    VL_Clientes: TIdContextList;
begin
    Result := False;

    try
        VL_Clientes := TDComunicador(VP_DComunicador).IdTCPServidor.Contexts.LockList;

        for VL_I := 0 to VL_Clientes.Count - 1 do
            if (TTConexao(TIdContext(VL_Clientes.Items[VL_I]).Data).Terminal_Tipo = VP_TipoTerminal) and
                (TTConexao(TIdContext(VL_Clientes.Items[VL_I]).Data).Identificacao = VP_TerminalIdentificacao) then
            begin
                VO_AContext := TIdContext(VL_Clientes.Items[VL_I]);
                Result := True;
                Break;
            end;
    finally
        TDComunicador(VP_DComunicador).IdTCPServidor.Contexts.UnlockList;
    end;
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
    TDComunicador(Sender).V_DComunicador := Sender;
    TDComunicador(Sender).V_ListaThreads := TList.Create;
    TDComunicador(Sender).V_ProcID := 0;
    TDComunicador(Sender).V_Parar := False;
    TDComunicador(Sender).V_EventoSocketAguardaResposta := TEventoSocket.Create;
    TDComunicador(Sender).CriptoRsa.GenerateKeyPair;
    F_NumeroConexao := 0;
    TDComunicador(Sender).V_ClienteRecebimento := nil;
    TDComunicador(Sender).V_ClienteRecebimentoModulo := nil;
    TDComunicador(Sender).V_ServidorRecebimento := nil;
    TDComunicador(Sender).V_TransmissaoComando := nil;
    TDComunicador(Sender).V_ConexaoCliente := TTConexao.Create(Sender);
    TDComunicador(Sender).V_ThRecebeEscuta := TThRecebe.Create(Sender);
    TDComunicador(Sender).V_ThRecebeEscuta.Start;

end;

procedure TDComunicador.DataModuleDestroy(Sender: TObject);
var
    V_TEmporizadorTThread: ^TTEmporizadorTThread;
begin
    // avisa as threads que vai parar
    TDComunicador(Sender).V_Parar := True;

    while TDComunicador(Sender).V_ListaThreads.Count > 0 do
    begin
        V_TEmporizadorTThread := TDComunicador(Sender).V_ListaThreads.Items[0];
        if Assigned(V_TEmporizadorTThread) then
        begin
            V_TEmporizadorTThread^.Terminate;
            if Assigned(V_TEmporizadorTThread) then
                WaitForThreadTerminate(V_TEmporizadorTThread^.Handle, 5000);
        end;
        TDComunicador(Sender).V_ListaThreads.Remove(V_TEmporizadorTThread);
    end;

    // aguarda finalizar processamento da lista de solicitações da conexão dos clientes
    //   if Assigned(TDComunicador(Sender).V_ThClienteProcessaRecebe) then
    //   begin
    //      TDComunicador(Sender).V_ThClienteProcessaRecebe.Terminate;
    //      TDComunicador(Sender).V_ThClienteProcessaRecebe.WaitFor;
    //     TDComunicador(Sender).V_ThClienteProcessaRecebe.Free;
    //    TDComunicador(Sender).V_ThClienteProcessaRecebe := nil;
    // end;

    // aguarda finalizar processamento da lista de solicitações da conexão dos servidores



    // aguarda finalizar processamento da escuta do socket do cliente
    if Assigned(TDComunicador(Sender).V_ThRecebeEscuta) then
    begin
        TDComunicador(Sender).V_ThRecebeEscuta.Terminate;
        TDComunicador(Sender).V_ThRecebeEscuta.WaitFor;
        TDComunicador(Sender).V_ThRecebeEscuta := nil;
    end;



    // desativa socket
    desativartodasconexao(Sender);

    if Assigned(TDComunicador(Sender).V_ConexaoCliente) then
    begin
        TDComunicador(Sender).V_ConexaoCliente.Free;
        TDComunicador(Sender).V_ConexaoCliente := nil;
    end;

    if Assigned(TDComunicador(Sender).V_EventoSocketAguardaResposta) then
    begin
        TDComunicador(Sender).V_EventoSocketAguardaResposta.Free;
        TDComunicador(Sender).V_EventoSocketAguardaResposta := nil;
    end;

    TDComunicador(Sender).V_ListaThreads.Free;
end;




procedure TDComunicador.IdTCPServidorConnect(AContext: TIdContext);
var
    TConexao: TTConexao;
begin
    if self.V_Parar then
        Exit;
    AContext.Connection.IOHandler.MaxLineLength := 0;
    AContext.Connection.IOHandler.SendBufferSize := MaxInt;
    TConexao := TTConexao.Create(self);
    TConexao.Hora := Now;
    TConexao.ID := F_NumeroConexao;
    TConexao.ClienteIp := AContext.Connection.Socket.Binding.PeerIP;
    TConexao.ClientePorta := AContext.Connection.Socket.Binding.PeerPort;
    TConexao.Status := csLink;
    TConexao.StatusDesejado := csLogado;
    AContext.Data := TConexao;
end;

procedure TDComunicador.IdTCPServidorDisconnect(AContext: TIdContext);
begin
    if Assigned(TTConexao(AContext.Data)) then
    begin
        if Assigned(V_ServidorRecebimento) then
            if TTConexao(AContext.Data).StatusDesejado = csLogado then
                V_ServidorRecebimento(96, '', '', TTConexao(AContext.Data).ID, TTConexao(AContext.Data).Terminal_Tipo, TTConexao(
                    AContext.Data).Terminal_ID, TTConexao(AContext.Data).DOC, TTConexao(AContext.Data).Status,
                    TTConexao(AContext.Data).Identificacao, TTConexao(AContext.Data).Permissao, TTConexao(AContext.Data).ClienteIp);
        TTConexao(AContext.Data).Status := csDesconectado;
        TTConexao(AContext.Data).Free;
        AContext.Data := nil;
    end;
end;




procedure TDComunicador.IdTCPServidorExecute(AContext: TIdContext);
var
    VL_DadosRecebidos: string;
    VL_ThServidorProcessaRecebe: TThServidorProcessaRecebe;
begin
    sleep(10);

    VL_DadosRecebidos := AContext.Connection.IOHandler.ReadLn(LF, 100, -1, nil);
    if VL_DadosRecebidos = '' then
        Exit;

    if AContext.Data = nil then
        Exit;

    if self.V_Parar then
        Exit;


    //AContext.Connection.IOHandler.Write('0' + LFL);

    VL_ThServidorProcessaRecebe := TThServidorProcessaRecebe.Create(self.V_DComunicador, VL_DadosRecebidos, TTConexao(AContext.Data));
    VL_ThServidorProcessaRecebe.Start;

end;


procedure TDComunicador.IdTCPClienteConnected(Sender: TObject);
begin
    Self.V_ConexaoCliente.Status := csLink;
    self.V_ConexaoCliente.StatusDesejado := csLogado;
end;

procedure TDComunicador.IdTCPClienteDisconnected(Sender: TObject);
begin
    Self.V_ConexaoCliente.Status := csDesconectado;
    if Self.V_ConexaoCliente.StatusDesejado = csLogado then
    begin
        Self.V_ConexaoCliente.StatusDesejado := csDesconectado;
        if Assigned(TDComunicador(SELF.V_DComunicador).V_ClienteRecebimento) then
            TDComunicador(SELF.V_DComunicador).V_ClienteRecebimento('', 0, 96, PChar(''));
    end;
end;

function TDComunicador.DesconectarCliente(VP_DComunicador: Pointer): integer;
begin
    Result := 0;
    if Assigned(TDComunicador(VP_DComunicador).V_ConexaoCliente) then
    begin
        TDComunicador(VP_DComunicador).V_ConexaoCliente.StatusDesejado := csDesconectado;
        TDComunicador(VP_DComunicador).V_ConexaoCliente.Status := csDesconectado;
    end;
    if TDComunicador(VP_DComunicador).idTCPCliente.Connected then
        TDComunicador(VP_DComunicador).idTCPCliente.Disconnect;
end;

function TDComunicador.DesconectarClienteID(VP_DComunicador: Pointer; VP_Conexao_ID: integer): integer;
var
    VL_I: integer;
    VL_Clientes: TIdContextList;
    VL_AContext: TIdContext;
begin
    Result := 0;

    try
        VL_Clientes := TDComunicador(VP_DComunicador).IdTCPServidor.Contexts.LockList;

        for VL_I := 0 to VL_Clientes.Count - 1 do
            if TTConexao(TIdContext(VL_Clientes.Items[VL_I]).Data).ID = VP_Conexao_ID then
            begin
                TTConexao(TIdContext(VL_Clientes.Items[VL_I]).Data).StatusDesejado := csDesconectado;
                VL_AContext := TIdContext(VL_Clientes.Items[VL_I]);
                VL_AContext.Connection.Disconnect;
                Result := 0;
                Exit;
            end;
    finally
        TDComunicador(VP_DComunicador).IdTCPServidor.Contexts.UnlockList;
    end;

end;


function TDComunicador.ServidorTransmiteSolicitacaoID(VP_DComunicador: Pointer; VP_TempoAguarda: integer; VP_AguardaRetorno: boolean;
    VP_Procedimento: TServidorRecebimento; VP_Transmissao_ID: string; VP_Mensagem: TMensagem; var VO_Mensagem: TMensagem; VP_Conexao_ID: integer): integer;
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

        if VP_Transmissao_ID = '' then
            VP_Transmissao_ID := CriaID;
        try
            VL_Clientes := TDComunicador(VP_DComunicador).IdTCPServidor.Contexts.LockList;

            for VL_I := 0 to VL_Clientes.Count - 1 do
                if TTConexao(TIdContext(VL_Clientes.Items[VL_I]).Data).ID = VP_Conexao_ID then
                begin
                    VL_AContext := TIdContext(VL_Clientes.Items[VL_I]);
                    Result := 0;
                    Break;
                end;
        finally
            TDComunicador(VP_DComunicador).IdTCPServidor.Contexts.UnlockList;
        end;
        if Result <> 0 then
            Exit;

        try
            VL_Mensagem := TMensagem.Create;

            if TTConexao(VL_AContext.Data).Status > csLink then
                VL_Dados := Copy(VL_Dados, 1, 5) + TTConexao(VL_AContext.Data).Aes.EncryptString(Copy(VL_Dados, 6, MaxInt))
            else
                VL_Dados := Copy(VL_Dados, 1, 5) + EncodeStringBase64(Copy(VL_Dados, 6, MaxInt));

            VP_Mensagem.Limpar;
            VP_Mensagem.AddComando('00D1', VP_Transmissao_ID);
            VP_Mensagem.AddTag('00D2', VL_Dados);


            Result := 0;

            if VP_AguardaRetorno then
            begin
                Result := 67;

                VL_Temporizador := TTemporizador.Create(TDComunicador(VP_DComunicador).V_ListaThreads);
                VL_Temporizador.V_Executado := False;
                VL_Temporizador.V_ID := VP_Transmissao_ID;

                VP_Mensagem.AddComando('00D1', VL_Temporizador.V_ID);

                TDComunicador(VP_DComunicador).V_EventoSocketAguardaResposta.add(VL_Temporizador);
                VL_AContext.Connection.Socket.WriteLn(VP_Mensagem.TagsAsString);

                {
                VL_Dados := '';
                VL_Dados := VL_AContext.Connection.IOHandler.ReadLn(LFL, VP_TempoAguarda, -1, nil);

                Result := CLNInteiro(VL_Dados);

                if Result <> 0 then
                begin
                    VL_Temporizador.Free;
                    Exit;
                end;
                 }

                VL_Evento := VL_Temporizador.aguarda(VP_TempoAguarda, False, VL_Temporizador);

                if TDComunicador(VP_DComunicador).V_Parar then
                begin
                    TDComunicador(VP_DComunicador).V_EventoSocketAguardaResposta.remove(VL_Temporizador);
                    VL_Temporizador.Free;
                    Exit;
                end;



                case VL_Evento of
                    agEvento:
                    begin
                        Result := VO_Mensagem.CarregaTags(VL_Temporizador.V_Dados);
                    end;

                    agTempo: Result := 67;
                    agAborta: Result := 69;
                end;

                TDComunicador(VP_DComunicador).V_EventoSocketAguardaResposta.remove(VL_Temporizador);
                VL_Temporizador.Free;
                if Assigned(VP_Procedimento) then
                    VP_Procedimento(Result, VP_Transmissao_ID, VL_Temporizador.V_Dados, TTConexao(VL_AContext.Data).ID,
                        TTConexao(VL_AContext.Data).Terminal_Tipo, TTConexao(VL_AContext.Data).Terminal_ID,
                        TTConexao(VL_AContext.Data).DOC, TTConexao(VL_AContext.Data).Status, TTConexao(VL_AContext.Data).Identificacao,
                        TTConexao(VL_AContext.Data).Permissao, TTConexao(VL_AContext.Data).ClienteIp);

            end
            else
            begin

                VL_AContext.Connection.Socket.WriteLn(VP_Mensagem.TagsAsString);
                {
                VL_Dados := '';
                VL_Dados := VL_AContext.Connection.IOHandler.ReadLn(LFL, VP_TempoAguarda, -1, nil);

                Result := CLNInteiro(VL_Dados);
                }
            end;

        finally
            VL_Mensagem.Free;
        end;

    except
        on e: Exception do
        begin
            Result := 1;
            GravaLog(V_ArquivoLog, 0, '', 'comunicador', '090620221846', 'ServidorTransmiteSolicitacaoID' + e.ClassName + '/' + e.Message, '', 1, 1);
        end;

    end;

end;

function TDComunicador.ServidorTransmiteSolicitacaoIdentificacao(VP_DComunicador: Pointer; VP_TempoAguarda: integer;
    VP_AguardaRetorno: boolean; VP_Procedimento: TServidorRecebimento; VP_Transmissao_ID: string; VP_Mensagem: TMensagem;
    var VO_Mensagem: TMensagem; VP_TipoTerminal, VP_TerminalIdentificacao: string): integer;
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

        if VP_Transmissao_ID = '' then
            VP_Transmissao_ID := CriaID;



        try
            VL_Clientes := TDComunicador(VP_DComunicador).IdTCPServidor.Contexts.LockList;

            for VL_I := 0 to VL_Clientes.Count - 1 do
                if (TTConexao(TIdContext(VL_Clientes.Items[VL_I]).Data).Terminal_Tipo = VP_TipoTerminal) and
                    (TTConexao(TIdContext(VL_Clientes.Items[VL_I]).Data).Identificacao = VP_TerminalIdentificacao) then
                begin
                    VL_AContext := TIdContext(VL_Clientes.Items[VL_I]);
                    Result := 0;
                    Break;
                end;
        finally
            TDComunicador(VP_DComunicador).IdTCPServidor.Contexts.UnlockList;
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

                VL_Temporizador := TTemporizador.Create(TDComunicador(VP_DComunicador).V_ListaThreads);
                VL_Temporizador.V_Executado := False;

                VL_Temporizador.V_ID := VP_Transmissao_ID;

                VP_Mensagem.AddComando('00D1', VL_Temporizador.V_ID);

                TDComunicador(VP_DComunicador).V_EventoSocketAguardaResposta.add(VL_Temporizador);
                VL_AContext.Connection.Socket.WriteLn(VP_Mensagem.TagsAsString);

                {
                VL_Dados := '';
                VL_Dados := VL_AContext.Connection.IOHandler.ReadLn(LFL, VP_TempoAguarda, -1, nil);

                Result := CLNInteiro(VL_Dados);

                if Result <> 0 then
                begin
                    VL_Temporizador.Free;
                    Exit;
                end;
                }


                VL_Evento := VL_Temporizador.aguarda(VP_TempoAguarda, False, VL_Temporizador);

                if TDComunicador(VP_DComunicador).V_Parar then
                begin
                    TDComunicador(VP_DComunicador).V_EventoSocketAguardaResposta.remove(VL_Temporizador);
                    VL_Temporizador.Free;
                    Exit;
                end;



                case VL_Evento of
                    agEvento:
                    begin
                        Result := VO_Mensagem.CarregaTags(VL_Temporizador.V_Dados);
                    end;

                    agTempo: Result := 67;
                    agAborta: Result := 69;
                end;

                TDComunicador(VP_DComunicador).V_EventoSocketAguardaResposta.remove(VL_Temporizador);
                VL_Temporizador.Free;
                if Assigned(VP_Procedimento) then
                    VP_Procedimento(Result, VP_Transmissao_ID, VL_Temporizador.V_Dados, TTConexao(VL_AContext.Data).Id,
                        TTConexao(VL_AContext.Data).Terminal_Tipo, TTConexao(VL_AContext.Data).Terminal_ID,
                        TTConexao(VL_AContext.Data).DOC, TTConexao(VL_AContext.Data).Status, TTConexao(VL_AContext.Data).Identificacao,
                        TTConexao(VL_AContext.Data).Permissao, TTConexao(VL_AContext.Data).ClienteIp);

            end
            else
            begin
                VL_AContext.Connection.Socket.WriteLn(VP_Mensagem.TagsAsString);
                {
                VL_Dados := '';
                VL_Dados := VL_AContext.Connection.IOHandler.ReadLn(LFL, VP_TempoAguarda, -1, nil);

                Result := CLNInteiro(VL_Dados);
                }
            end;

        finally
            VL_Mensagem.Free;
        end;

    except
        on e: Exception do
        begin
            Result := 1;
            GravaLog(V_ArquivoLog, 0, '', 'comunicador', '260820220820', 'ServidorTransmiteSolicitacaoIdentificacao' +
                e.ClassName + '/' + e.Message, '', 1, 1);
        end;

    end;

end;

procedure TDComunicador.desativartodasconexao(VP_DComunicador: Pointer);
begin
    try
        begin
            if TDComunicador(VP_DComunicador).IdTCPCliente.Connected then
                DesconectarCliente(VP_DComunicador);

            if TDComunicador(VP_DComunicador).IdTCPServidor.Active then
            begin
                TDComunicador(VP_DComunicador).IdTCPServidor.StopListening;
                TDComunicador(VP_DComunicador).IdTCPServidor.Active := False;
            end;
        end;

    except
        on e: Exception do
            GravaLog(V_ArquivoLog, 0, '', 'comunicador', '120920220835', 'Erro na TDComunicador.desativartodasconexao ' +
                e.ClassName + '/' + e.Message, '', 1, 1);

    end;
end;

constructor TThRecebe.Create(VP_DComunicador: Pointer);
begin
    inherited Create(True);
    Self.FreeOnTerminate := False;
    Self.f_DComunicador := VP_DComunicador;
end;

procedure TThRecebe.Execute;
var
    VL_Dados: string;
    VL_Linha: string;
    VL_Mensagem: TMensagem;
begin
    VL_Mensagem := TMensagem.Create;
    try
        try
            while not Terminated do
            begin
                if not Assigned(TDComunicador(f_DComunicador)) then
                    Exit;

                VL_Linha := '090520221728';
                if TDComunicador(f_DComunicador).V_Parar then
                    Exit;

                VL_Linha := '090520221729';
                if not Assigned(f_DComunicador) then
                    Exit;
                VL_Linha := '090520221741';

                VL_Dados := '';

                if TDComunicador(f_DComunicador).V_Parar then
                    Exit;

                if TDComunicador(f_DComunicador).IdTCPCliente.Connected then
                    TDComunicador(f_DComunicador).IdTCPCliente.IOHandler.CheckForDisconnect
                else
                if ((TDComunicador(f_DComunicador).V_ConexaoCliente.StatusDesejado = csLogado) and
                    (TDComunicador(f_DComunicador).V_ConexaoCliente.Status = csLogado)) then
                begin
                    TDComunicador(f_DComunicador).V_ConexaoCliente.Status := csDesconectado;
                    TThClienteProcessaRecebe.Create(f_DComunicador, VL_Dados);
                end;

                if TDComunicador(f_DComunicador).V_Parar then
                    Exit;

                if TDComunicador(f_DComunicador).IdTCPCliente.Connected then
                begin
                    if not TDComunicador(f_DComunicador).IdTCPCliente.IOHandler.InputBufferIsEmpty then
                    begin
                        VL_Linha := '090520221747';
                        try
                            VL_Dados := TDComunicador(f_DComunicador).IdTCPCliente.Socket.ReadLn;
                        except
                            VL_Linha := '090520221750';
                        end;
                        VL_Linha := '090520221730';

                        if TDComunicador(f_DComunicador).V_Parar then
                            Exit;

                        VL_Linha := '090520221731';

                        if VL_Dados <> '' then
                        begin
                            //TDComunicador(f_DComunicador).IdTCPCliente.Socket.Write('0' + LFL);
                            TThClienteProcessaRecebe.Create(f_DComunicador, VL_Dados);

                        end;

                    end;
                end;
                sleep(10);
            end;


        except
            on e: Exception do
                GravaLog(TDComunicador(f_DComunicador).V_ArquivoLog, 0, '', 'comunicador', VL_Linha, 'Erro na TThRecebe.Execute ' +
                    e.ClassName + '/' + e.Message, '', 1, 1);
        end;
    finally
        begin
            VL_Mensagem.Free;

        end;

    end;

end;


function TDComunicador.ClienteTransmiteDados(VP_DComunicador: Pointer; var VO_Transmissao_ID: string; var VO_DadosO, VO_DadosI: ansistring;
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

            if VO_Transmissao_ID = '' then
                VO_Transmissao_ID := CriaID;

            if (TDComunicador(VP_DComunicador).V_ConexaoCliente.Status = csDesconectado) then
            begin
                Result := 100;
                Exit;
            end;
            if not TDComunicador(VP_DComunicador).IdTCPCliente.Connected then
            begin
                Result := 100;
                TDComunicador(VP_DComunicador).V_ConexaoCliente.Status := csDesconectado;
                Exit;
            end;

            if (TDComunicador(VP_DComunicador).V_ConexaoCliente.Status = csChaveado) or
                (TDComunicador(VP_DComunicador).V_ConexaoCliente.Status = csLogado) then
            begin
                VL_DadosCriptografado := Copy(VO_DadosO, 1, 5) + TDComunicador(VP_DComunicador).V_ConexaoCliente.Aes.EncryptString(
                    Copy(VO_DadosO, 6, MaxInt));
                VL_DadosEnviar := VL_DadosCriptografado;
            end
            else
                VL_DadosEnviar := VO_DadosO;

            VL_Mensagem.AddComando('00D1', VO_Transmissao_ID);
            VL_Mensagem.AddTag('00D2', VL_DadosEnviar);


            if VP_AguardaRetorno then
            begin
                Result := 67;


                VL_Temporizador := TTemporizador.Create(TDComunicador(VP_DComunicador).V_ListaThreads);
                VL_Temporizador.V_Executado := False;

                VL_Temporizador.V_ID := VO_Transmissao_ID;

                TDComunicador(VP_DComunicador).V_EventoSocketAguardaResposta.add(VL_Temporizador);

                TDComunicador(VP_DComunicador).IdTCPCliente.Socket.WriteLn(VL_Mensagem.TagsAsString);

                {
                VL_DadosEnviar := '';
                VL_DadosEnviar := TDComunicador(VP_DComunicador).IdTCPCliente.Socket.ReadLn(LFL, VP_TempoAguarda, -1, nil);
                Result := CLNInteiro(VL_DadosEnviar);
                if Result <> 0 then
                begin
                    VL_Temporizador.Free;
                    Exit;
                end;
                }

                VL_Evento := VL_Temporizador.aguarda(VP_TempoAguarda, False, VL_Temporizador);

                if TDComunicador(VP_DComunicador).V_Parar then
                begin
                    TDComunicador(VP_DComunicador).V_EventoSocketAguardaResposta.remove(VL_Temporizador);
                    VL_Temporizador.Free;
                    Exit;
                end;

                case VL_Evento of
                    agEvento:
                    begin
                        VO_DadosI := VL_Temporizador.V_Dados;
                        Result := 0;
                    end;

                    agTempo: Result := 67;
                    agAborta: Result := 69;
                end;

                TDComunicador(VP_DComunicador).V_EventoSocketAguardaResposta.remove(VL_Temporizador);
                VL_Temporizador.Free;

            end
            else
            begin
                TDComunicador(VP_DComunicador).IdTCPCliente.Socket.WriteLn(VL_Mensagem.TagsAsString);
                {
                VL_DadosEnviar := '';
                VL_DadosEnviar := TDComunicador(VP_DComunicador).IdTCPCliente.Socket.ReadLn(LFL, VP_TempoAguarda, -1, nil);
                Result := CLNInteiro(VL_DadosEnviar);
                if Result <> 0 then
                    Exit;
                }
            end;



        except
            on e: Exception do
            begin
                Result := 83;
                GravaLog(V_ArquivoLog, 0, '', 'comunicador', '0109202219:09', 'Erro na TDComunicador.ClienteTransmiteDados' +
                    e.ClassName + '/' + e.Message, '', Result, 1);
                DesconectarCliente(VP_DComunicador);

            end;
        end;

    finally
        VL_Mensagem.Free;
    end;

end;

function TDComunicador.ClienteTransmiteSolicitacao(VP_DComunicador: Pointer; var VO_Transmissao_ID: string; var VO_Dados: TMensagem;
    var VO_Retorno: TMensagem; VP_Procedimento: TRetorno; VP_TempoAguarda: integer; VP_AguardaRetorno: boolean): integer;
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
            if (TDComunicador(VP_DComunicador).V_ConexaoCliente.Status < csChaveado) then
            begin
                Result := ConectarCliente(VP_DComunicador);
                if Result <> 0 then
                    Exit;
            end;

            Result := VL_Mensagem.TagToStr(VL_Dados);
            if Result <> 0 then
            begin
                GravaLog(V_ArquivoLog, 0, '', 'comunicador', '190520222159', 'Erro na TDComunicador.ClienteTransmiteSolicitacao ', '', Result, 1);
                Exit;
            end;

            Result := ClienteVerificaConexao(VP_DComunicador);

            if Result <> 0 then
            begin
                GravaLog(V_ArquivoLog, 0, '', 'comunicador', '120920220834', 'Erro na TDComunicador.ClienteTransmiteSolicitacao ', '', Result, 1);
                Exit;
            end;

            Result := ClienteTransmiteDados(VP_DComunicador, VO_Transmissao_ID, VL_Dados, VL_Dados, VP_TempoAguarda, VP_AguardaRetorno);
            if Result <> 0 then
            begin
                GravaLog(V_ArquivoLog, 0, '', 'comunicador', '190520222101', 'Erro na TDComunicador.ClienteTransmiteSolicitacao ', '', Result, 1);
                Exit;

            end;
            if VP_AguardaRetorno then
            begin
                if VL_Dados = '' then
                begin
                    Result := 24;
                    TDComunicador(VP_DComunicador).V_ConexaoCliente.Status := csDesconectado;
                    if TDComunicador(VP_DComunicador).idTCPCliente.Connected then
                        DesconectarCliente(VP_DComunicador);
                    GravaLog(V_ArquivoLog, 0, '', 'comunicador', '210520222014', 'Erro na TDComunicador.ClienteTransmiteSolicitacao ', '', Result, 1);
                    Exit;

                end;

                Result := VO_Retorno.CarregaTags(VL_Dados);
                if Assigned(VP_Procedimento) then
                    VP_Procedimento(PChar(VO_Transmissao_ID), V_ProcID, Result, PChar(VL_Dados));
            end;
        except
            on e: Exception do
            begin
                Result := 24;
                GravaLog(V_ArquivoLog, 0, '', 'comunicador', '090520221723', 'Erro na TDComunicador.ClienteTransmiteSolicitacao ' +
                    e.ClassName + '/' + e.Message, '', Result, 1);

                TDComunicador(VP_DComunicador).V_ConexaoCliente.Status := csDesconectado;
                if TDComunicador(VP_DComunicador).idTCPCliente.Connected then
                    DesconectarCliente(VP_DComunicador);
            end;

        end;
    finally
        VL_Mensagem.Free;
    end;
end;



end.
