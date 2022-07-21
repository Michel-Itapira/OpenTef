unit opentefnucleo;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils, IniFiles, comunicador, ZConnection, ZDataset, funcoes, rxmemds, IdContext, cadastro;

type


    TMenuCompativel = function(VP_Modulo: Pointer; VP_Menu: PChar; var VO_Compativel: boolean): integer; stdcall;
    TGetFuncao = function(VP_Modulo: Pointer; VP_TagFuncao: PChar; var VO_Implementada: boolean): integer; stdcall;
    TLogin = function(VP_Modulo: Pointer; VP_Host: PChar; VP_Porta: integer; VP_ChaveTerminal: PChar): integer; stdcall;
    TFinalizar = function(VP_Modulo: Pointer): integer; stdcall;
    TModuloInicializar = function(VP_ModuloProcID: integer; var VO_Modulo: Pointer; VP_Recebimento: TRetornoModulo;
        VP_Modulo_ID: integer; VP_ArquivoLog: PChar): integer; stdcall;
    TSolicitacao = function(VP_Modulo: Pointer; VP_Transmissao_ID, VP_Dados: PChar; VP_Procedimento: TRetornoModulo;
        VP_Tarefa_ID, VP_TempoAguarda: integer): integer; stdcall;
    TSolicitacaoblocante = function(VP_Modulo: Pointer; VP_Transmissao_ID, VP_Dados: PChar; var VO_Retorno: PChar; VP_TempoAguarda: integer): integer; stdcall;
    TModuloStatus = function(VP_Modulo: Pointer; var VO_Versao: PChar; var VO_VersaoMensagem: integer; var VO_StatusRetorno: integer): integer; stdcall;




    TTarefa = record
        VF_ID: integer;
        VF_TipoConexao: TConexaoTipo;
        VF_ModuloConfig_ID: integer;
        VF_TempoEspera: integer;
        VF_SocketID: Integer;
        VF_SocketTransmissaoID: string;
        VF_TransmissaoID: string;
        VF_Tratando: boolean;
        VF_DataCriacao: TDateTime;
        VF_Mensagem: string;
    end;
    { TThModulo }
    TThModulo = class(TThread)
    private
        VF_LibCarregada: boolean;
        VF_Rodando: boolean;
        VF_Evento: TTemporizador;
        VF_ConexaoTipo: TConexaoTipo;
        VF_ArquivoLog: string;
    protected
        procedure Execute; override;
    public
        V_ListaTarefas: TList;
        VF_Modulo: Pointer;
        VF_DNucleo: Pointer;
        constructor Create(VP_Suspenso: boolean; VP_Modulo: Pointer; VP_ConexaoTipo: TConexaoTipo; VP_ArquivoLog: string; VP_DNucleo: Pointer);
        destructor Destroy; override;
    end;

    { TThTransacao }

    TThTransacao = class(TThread)
    private
    protected
        procedure Execute; override;
    public
        V_Mensagem: TMensagem;
        V_AContext: TIdContext;
        V_TransmissaoID: string;
        constructor Create(VP_Suspenso: boolean; VP_Trasmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext);
        destructor Destroy; override;
    end;


    { TRegModulos }

    TRegModulo = record
        ModuloProcID: integer;
        Tag: string;
        Handle: TLibHandle;
        Biblioteca: string;
        ModuloConfig_ID: integer;
        ConexaoTipo: TConexaoTipo;
        Host: ansistring;
        Porta: integer;
        Chave: ansistring;
        Descricao: string;
        Bin_Estatico: boolean;
        Menu_estatico: boolean;
        Menu_Operacional_estatico: boolean;
        Login: TLogin;
        Finalizar: TFinalizar;
        Inicializar: TModuloInicializar;
        Solicitacao: TSolicitacao;
        Solicitacaoblocante: TSolicitacaoblocante;
        ModuloStatus: TModuloStatus;
        MenuCompativel: TMenuCompativel;
        GetFuncoes: TGetFuncao;
        ThModulo: TThModulo;

    end;

    TRecBin = record
        IIN: ansistring;
        ModuloConfID: integer;
        Tag: string;
    end;

    TRecMenu = record
        ModuloConfID: integer;
        Tag: string;
        TextoBotao: string;
    end;

    { TBin }
    TBin = class
    public
        ListaBin: TList;
        constructor Create; overload;
        destructor Destroy; override;
        function Add(VP_IIN: ansistring; VP_ModuloConfID: integer; VP_Tag: string): integer;
        procedure Limpar;
        function Get(VP_Posicao: integer): TRecBin;
        function Count: integer;
        procedure RemovePorModuloConf(VP_ModuloConfID: integer);
        function RetornaModuloConfId(VP_IIN: ansistring): integer;
        function RetornaBIN(VP_IIN: ansistring): TRecBin;
    end;

    { TMenu }

    TMenu = class
    public
        ListaMenu: TList;
        constructor Create; overload;
        destructor Destroy; override;
        function Add(VP_Tag, VP_TextoBotao: ansistring; VP_ModuloConfID: integer): integer;
        procedure Limpar;
        function Get(VP_Posicao: integer): TRecMenu;
        function GetTag(VP_Posicao: integer): string;
        function GetTextoBotao(VP_Posicao: integer): string;
        function Count: integer;
        procedure RemovePorModuloConf(VP_ModuloConfID: integer);
        function RetornaModuloConfId(VP_Tag: ansistring): integer;


    end;




    { TDNucleo }
    TDNucleo = class(TDataModule)
        ZConexao: TZConnection;
        ZConsulta: TZQuery;
        procedure DataModuleCreate(Sender: TObject);
        procedure DataModuleDestroy(Sender: TObject);
    private
        function comando0001(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; // PEDIDO DE LOGIN
        function comando0021(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; // PEDIDO DE CONEXAO
        function comando000A(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; // PEDE APROVACAO DA TRANSACAO
        function comando0018(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; // SOLICITA MENU DE VENDA
        function comando007A(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; // TRANSACAO PARA APROVACAO AUTOMATIZADA
    public
        VF_Bin: TBin;
        VF_Menu: TMenu;
        VF_MenuOperacional: TMenu;
        procedure iniciar;
        procedure parar;
        function comando(VP_Codigo: integer; VP_Transmissao_ID: string; VP_DadosRecebidos: string; VP_AContext: TIdContext): integer;
        function ModuloCarrega(VP_ModuloConfig_ID: integer): integer;
        function ModuloDescarrega(VP_ModuloConfig_ID: integer): integer;
        function ModuloAddSolicitacao(VP_SocketID:Integer;VP_SocketTransmissaoID,VP_Transmissao_ID: string; VP_TempoEspera, VP_ModuloConfig_ID: integer; VP_Mensagem: TMensagem;
            VP_ConexaoTipo: TConexaoTipo): integer;
        function ModuloAddSolicitacao(VP_Transmissao_ID: string; VP_TempoEspera, VP_ModuloProcID: integer; VP_Mensagem: TMensagem): integer;
        function ModuloGetReg(VP_ModuloProc_ID: integer): TRegModulo;
        function AtualizaBIN(VP_Modulo: TRegModulo; VP_Mensagem: TMensagem): integer;
        function AtualizaMENU(VP_Modulo: TRegModulo; VP_Mensagem: TMensagem): integer;
        function AtualizaMENU_OPERACIONAL(VP_Modulo: TRegModulo; VP_Mensagem: TMensagem): integer;


    var
        VF_ListaThModulo: TList;



    end;




var
    DNucleo: TDNucleo;
    Conf: TIniFile;
    DComunicador: TDComunicador;
    F_ArquivoLog: string;
    F_P: Pointer;
    F_Modulo_ID_Contador: integer;
    F_Tarefa_ID_Contador: integer;


    {$IFDEF WIN}
    const
      C_Lib= '.dll';
    {$ENDIF WIN}


procedure ModuloCaixaRetorno(VP_Transmissao_ID: PChar; VP_Tarefa_ID, VP_ModuloProcID, VP_Codigo: integer; VP_Dados: PChar); stdcall;
procedure ModuloServicoRetorno(VP_Transmissao_ID: PChar; VP_Tarefa_ID, VP_ModuloProcID, VP_Codigo: integer; VP_Dados: PChar); stdcall;

procedure ServidorRecebimento(VP_Codigo: integer; VP_Transmissao_ID, VP_DadosRecebidos: string; var VO_AContext: TIdContext);

implementation


procedure TThModulo.Execute;
var
    VL_Erro: integer;
    VL_DadosInteger: integer;
    VL_ConexaoStatus: TConexaoStatus;
    VL_VersaoModulo: PChar;
    VL_VersaoMensagem: integer;
    VL_Modulo: ^TRegModulo;
    VL_Mensagem: TMensagem;
    VL_PModulo: Pointer;
    VL_Tarefa: ^TTarefa;
    VL_I: integer;

begin
    VL_PModulo := nil;
    VL_Tarefa := nil;
    VL_DadosInteger := 0;
    VL_VersaoModulo := '';
    VL_VersaoMensagem := 0;
    VF_Rodando := True;
    try
        try
            while not Terminated do
            begin
                if VF_LibCarregada = False then
                begin
                    TRegModulo(VF_modulo^).Handle := LoadLibrary(PChar(ExtractFilePath(ParamStr(0)) + 'modulo\' + TRegModulo(VF_modulo^).Biblioteca));
                    if TRegModulo(VF_modulo^).Handle = 0 then
                    begin
                        Terminate;
                        Exit;
                    end;
                    Pointer(TRegModulo(VF_modulo^).Login) := GetProcAddress(TRegModulo(VF_modulo^).Handle, 'login');
                    Pointer(TRegModulo(VF_modulo^).Finalizar) := GetProcAddress(TRegModulo(VF_modulo^).Handle, 'finalizar');
                    Pointer(TRegModulo(VF_modulo^).Inicializar) := GetProcAddress(TRegModulo(VF_modulo^).Handle, 'inicializar');
                    Pointer(TRegModulo(VF_modulo^).Solicitacao) := GetProcAddress(TRegModulo(VF_modulo^).Handle, 'solicitacao');
                    Pointer(TRegModulo(VF_modulo^).Solicitacaoblocante) := GetProcAddress(TRegModulo(VF_modulo^).Handle, 'solicitacaoblocante');
                    Pointer(TRegModulo(VF_modulo^).ModuloStatus) := GetProcAddress(TRegModulo(VF_modulo^).Handle, 'modulostatus');

                    if VF_ConexaoTipo = cnCaixa then
                        VL_Erro := TRegModulo(VF_modulo^).Inicializar(TRegModulo(VF_modulo^).ModuloProcID, VL_PModulo,
                            @ModuloCaixaRetorno, TRegModulo(VF_modulo^).ModuloConfig_ID,
                            PChar(VF_ArquivoLog))
                    else
                        VL_Erro := TRegModulo(VF_modulo^).Inicializar(TRegModulo(VF_modulo^).ModuloProcID, VL_PModulo,
                            @ModuloServicoRetorno, TRegModulo(VF_modulo^).ModuloConfig_ID, PChar(VF_ArquivoLog));

                    if VL_Erro <> 0 then
                    begin
                        GravaLog(VF_ArquivoLog, TRegModulo(VF_modulo^).ModuloConfig_ID, TRegModulo(VF_modulo^).Tag, 'opentefnucleo',
                            '030520221138', 'Erro ao tentar inicializar a dll:' + TRegModulo(VF_modulo^).Biblioteca, '', VL_Erro);
                        Terminate;
                        Exit;
                    end;
                    VF_LibCarregada := True;
                    if (VF_ConexaoTipo = cnServico) then
                        DNucleo.AtualizaBIN(TRegModulo(VF_modulo^), nil);
                end
                else
                begin

                    // pega o status da conexao
                    VL_Erro := TRegModulo(VF_modulo^).ModuloStatus(VL_PModulo, VL_VersaoModulo, VL_VersaoMensagem, VL_DadosInteger);
                    if VL_Erro <> 0 then
                    begin
                        GravaLog(VF_ArquivoLog, TRegModulo(VF_modulo^).ModuloConfig_ID, TRegModulo(VF_modulo^).Tag, 'opentefnucleo',
                            '030520221503', 'Erro ao tentar pegar status da conexao ' + ConexaoTipoToStr(VF_ConexaoTipo) + ' da dll:' +
                            TRegModulo(VF_modulo^).Biblioteca, '', VL_Erro);
                        Terminate;
                        Exit;
                    end;
                    VL_ConexaoStatus := IntToConexaoStatus(VL_DadosInteger);

                    if VL_ConexaoStatus <> csLogado then
                    begin
                        VL_Erro := TRegModulo(VF_modulo^).Login(VL_PModulo, PChar(TRegModulo(VF_modulo^).Host), TRegModulo(VF_modulo^).Porta,
                            PChar(TRegModulo(VF_modulo^).Chave));
                        if VL_Erro <> 0 then
                            GravaLog(VF_ArquivoLog, TRegModulo(VF_modulo^).ModuloConfig_ID, TRegModulo(VF_modulo^).Tag, 'opentefnucleo',
                                '030520221540', 'Erro ao tentar logar da conexao ' + ConexaoTipoToStr(VF_ConexaoTipo) + ' da dll:' +
                                TRegModulo(VF_modulo^).Biblioteca, '', VL_Erro)
                        else
                        begin
                            VL_Erro := TRegModulo(VF_modulo^).ModuloStatus(VL_PModulo, VL_VersaoModulo, VL_VersaoMensagem, VL_DadosInteger);
                            VL_ConexaoStatus := IntToConexaoStatus(VL_DadosInteger);
                        end;


                        if (VL_ConexaoStatus = csLogado) and (VF_ConexaoTipo = cnServico) and (TRegModulo(VF_modulo^).Menu_estatico = False) then
                        begin
                            // atualiza MENUS

                            VL_Mensagem := TMensagem.Create;
                            try
                                VL_Mensagem.AddComando('00CF', 'S'); //SOLICITA MENU VENDA
                                TRegModulo(VF_modulo^).Solicitacao(VL_PModulo, PChar(''), PChar(VL_Mensagem.TagsAsString), @ModuloServicoRetorno, 0, 60000);


                            finally
                                VL_Mensagem.Free;
                            end;

                        end;

                        if (VL_ConexaoStatus = csLogado) and (VF_ConexaoTipo = cnServico) and (TRegModulo(VF_modulo^).Menu_Operacional_estatico = False) then
                        begin
                            // atualiza MENUS  OPERACIONAL

                            VL_Mensagem := TMensagem.Create;
                            try

                                VL_Mensagem.AddComando('00D4', 'S'); //SOLICITA MENU OPERACIONAL
                                TRegModulo(VF_modulo^).Solicitacao(VL_PModulo, PChar(''), PChar(VL_Mensagem.TagsAsString), @ModuloServicoRetorno, 0, 60000);



                            finally
                                VL_Mensagem.Free;
                            end;

                        end;



                        if (VL_ConexaoStatus = csLogado) and (VF_ConexaoTipo = cnServico) and (TRegModulo(VF_modulo^).Menu_estatico = False) then
                        begin
                            // atualiza BINS

                            VL_Mensagem := TMensagem.Create;
                            try
                                VL_Mensagem.AddComando('00CD', 'S'); //SOLICITA BINS
                                TRegModulo(VF_modulo^).Solicitacao(VL_PModulo, PChar(''), PChar(VL_Mensagem.TagsAsString), @ModuloServicoRetorno, 0, 60000);



                            finally
                                VL_Mensagem.Free;
                            end;

                        end;

                    end;

                    // inicia as tratativas das solicitações
                    if VL_ConexaoStatus = csLogado then
                    begin
                        for VL_I := 0 to V_ListaTarefas.Count - 1 do
                        begin
                            VL_Tarefa := V_ListaTarefas[VL_I];

                            if VL_Tarefa^.VF_Tratando = False then
                            begin
                                VL_Tarefa^.VF_Tratando := True;
                                if VF_ConexaoTipo = cnCaixa then
                                    VL_Erro := TRegModulo(VF_modulo^).Solicitacao(VL_PModulo, PChar(VL_Tarefa^.VF_TransmissaoID),
                                        PChar(VL_Tarefa^.VF_Mensagem), @ModuloCaixaRetorno, VL_Tarefa^.VF_ID, VL_Tarefa^.VF_TempoEspera)
                                else
                                    VL_Erro := TRegModulo(VF_modulo^).Solicitacao(VL_PModulo, PChar(VL_Tarefa^.VF_TransmissaoID),
                                        PChar(VL_Tarefa^.VF_Mensagem), @ModuloServicoRetorno, VL_Tarefa^.VF_ID, VL_Tarefa^.VF_TempoEspera);
                             Sleep(50);
                            end;
                        end;

                        for VL_I := 0 to V_ListaTarefas.Count - 1 do
                        begin
                            VL_Tarefa := V_ListaTarefas[VL_I];
                            if ((TimeStampToMSecs(DateTimeToTimeStamp(now)) - TimeStampToMSecs(DateTimeToTimeStamp(VL_Tarefa^.VF_DataCriacao))) >
                                VL_Tarefa^.VF_TempoEspera) then
                            begin
                                // pode estudar uma opcao de enviar uma mensagem de erro
                                V_ListaTarefas.Remove(VL_Tarefa);
                                Dispose(VL_Tarefa);
                                Break;
                            end;
                        end;
                    end;
                end;
                if VF_ConexaoTipo = cnCaixa then
                    Sleep(100)
                else
                    Sleep(500);

            end;
            if VF_LibCarregada then
            begin
                TRegModulo(VF_modulo^).Finalizar(VL_PModulo);
                UnloadLibrary(TRegModulo(VF_modulo^).Handle);
                VL_Modulo := VF_Modulo;
                Dispose(VL_Modulo);
                VL_PModulo := nil;

            end;
        except
            on e: EInOutError do
                GravaLog(F_ArquivoLog, TRegModulo(VF_modulo^).ModuloConfig_ID, '', 'opentefnucleo', '200520220934', 'Erro na TThModulo.Execute ' +
                    e.ClassName + '/' + e.Message, '', VL_Erro);
        end;
    finally
        VF_Rodando := False;
    end;
end;



procedure TDNucleo.iniciar;
var
    VL_RegModulo: TRegModulo;
begin

    VL_RegModulo.Menu_Operacional_estatico := True;
    VL_RegModulo.Menu_estatico := True;
    VL_RegModulo.ModuloConfig_ID := 0;

    {$IFDEF DEBUG}
    ZConexao.Database := ExtractFilePath(ParamStr(0)) + 'opentef.fdb';
    ZConexao.HostName:='localhost';
    ZConexao.Port:=25050;
    ZConexao.Password:='2844';
    {$ELSE}
    ZConexao.LibraryLocation := ExtractFilePath(ParamStr(0)) + 'firebird\fbclient.dll';
    ZConexao.Database := ExtractFilePath(ParamStr(0)) + 'opentef.fdb';
    {$ENDIF DEBUG}



    ZConexao.Connect;


    DComunicador := TDComunicador.Create(Self);
    DComunicador.V_ServidorRecebimento := @ServidorRecebimento;

    DComunicador.V_ConexaoCliente := TTConexao.Create(@DComunicador);

    DComunicador.V_ThRecebeEscuta := TThRecebe.Create(True, @DComunicador, F_ArquivoLog);

    DComunicador.V_ThRecebeEscuta.Start;




    if not FileExists(ExtractFilePath(ParamStr(0)) + 'open_tef.ini') then
    begin
        Conf := TIniFile.Create(PChar(ExtractFilePath(ParamStr(0)) + 'open_tef.ini'));
        Conf.WriteInteger('Servidor', 'CaixaPorta', 0);
        Conf.WriteBool('Servidor', 'CaixaAtiva', True);
        Conf.WriteInteger('Servidor', 'ServicoPorta', 0);
        Conf.WriteBool('Servidor', 'ServicoAtiva', False);
        Conf.Free;
    end;

    Conf := TIniFile.Create(PChar(ExtractFilePath(ParamStr(0)) + 'open_tef.ini'));

    if Conf.ReadInteger('Servidor', 'Porta', 0) <> 0 then
    begin
        DComunicador.IdTCPServidor.DefaultPort := Conf.ReadInteger('Servidor', 'Porta', 0);
        DComunicador.IdTCPServidor.StartListening;
        DComunicador.IdTCPServidor.Active := Conf.ReadBool('Servidor', 'Ativa', False);

    end;
    F_Modulo_ID_Contador := 0;
    F_Tarefa_ID_Contador := 0;
    AtualizaMENU_OPERACIONAL(VL_RegModulo, nil);
    AtualizaMENU(VL_RegModulo, nil);
    ModuloCarrega(0);

end;

procedure TDNucleo.parar;
begin
    if not Assigned(DNucleo) then
        Exit;
    ModuloDescarrega(0);

    DComunicador.Free;
    DComunicador:=nil;

    ZConexao.Disconnect;
    DNucleo.free;
    DNucleo:=nil;
end;

function TDNucleo.ModuloCarrega(VP_ModuloConfig_ID: integer): integer;
var
    VL_RegModulo: ^TRegModulo;
begin

    F_Modulo_ID_Contador := F_Modulo_ID_Contador + 1;
    ZConsulta.Close;
    ZConsulta.SQL.Text := 'SELECT ' +
        ' MC.ID AS ID,MC.MODULO_ID,MC.ADQUIRENTE_ID,MC.SERVICO_HOST, ' +
        ' MC.SERVICO_PORTA,MC.CAIXA_HOST,MC.CAIXA_PORTA,MC.CHAVE,MC.DESCRICAO,MC.BIN_ESTATICO,MC.MENU_ESTATICO, ' +
        ' MC.MENU_ESTATICO_OPERACIONAL,M.TAG_NUMERO' +
        ' FROM MODULO_CONF MC ' +
        ' INNER JOIN MODULO M ON M.ID=MC.MODULO_ID ' +
        ' WHERE MC.HABILITADO=''T'' AND ((MC.ID=' + IntToStr(VP_ModuloConfig_ID) + ') OR (0=' + IntToStr(VP_ModuloConfig_ID) + '))';
    ZConsulta.Open;
    while not ZConsulta.EOF do
    begin
        new(VL_RegModulo);
        VL_RegModulo^.ConexaoTipo := cnServico;
        VL_RegModulo^.ModuloProcID := F_Modulo_ID_Contador;
        VL_RegModulo^.ModuloConfig_ID := ZConsulta.FieldByName('ID').AsInteger;
        VL_RegModulo^.Biblioteca := ZConsulta.FieldByName('TAG_NUMERO').AsString + C_Lib;
        VL_RegModulo^.Tag := ZConsulta.FieldByName('TAG_NUMERO').AsString;
        VL_RegModulo^.Host := ZConsulta.FieldByName('SERVICO_HOST').AsString;
        VL_RegModulo^.Porta := ZConsulta.FieldByName('SERVICO_PORTA').AsInteger;
        VL_RegModulo^.Chave := ZConsulta.FieldByName('CHAVE').AsString;
        VL_RegModulo^.Descricao := ZConsulta.FieldByName('DESCRICAO').AsString;
        VL_RegModulo^.Bin_Estatico := ZConsulta.FieldByName('BIN_ESTATICO').AsBoolean;
        VL_RegModulo^.Menu_Estatico := ZConsulta.FieldByName('MENU_ESTATICO').AsBoolean;
        VL_RegModulo^.Menu_Operacional_estatico := ZConsulta.FieldByName('MENU_ESTATICO_OPERACIONAL').AsBoolean;
        VL_RegModulo^.ThModulo := TThModulo.Create(True, VL_RegModulo, cnServico, PChar(ExtractFilePath(ParamStr(0)) +
            ZConsulta.FieldByName('TAG_NUMERO').AsString + '_servico.txt'), @DNucleo);
        VF_ListaThModulo.Add(VL_RegModulo^.ThModulo);
        VL_RegModulo^.ThModulo.Start;

        F_Modulo_ID_Contador := F_Modulo_ID_Contador + 1;
        new(VL_RegModulo);
        VL_RegModulo^.ModuloProcID := F_Modulo_ID_Contador;
        VL_RegModulo^.ModuloConfig_ID := ZConsulta.FieldByName('ID').AsInteger;
        VL_RegModulo^.Biblioteca := ZConsulta.FieldByName('TAG_NUMERO').AsString + C_Lib;
        VL_RegModulo^.Tag := ZConsulta.FieldByName('TAG_NUMERO').AsString;
        VL_RegModulo^.Host := ZConsulta.FieldByName('CAIXA_HOST').AsString;
        VL_RegModulo^.Porta := ZConsulta.FieldByName('CAIXA_PORTA').AsInteger;
        VL_RegModulo^.Chave := ZConsulta.FieldByName('CHAVE').AsString;
        VL_RegModulo^.Descricao := ZConsulta.FieldByName('DESCRICAO').AsString;
        VL_RegModulo^.Bin_Estatico := ZConsulta.FieldByName('BIN_ESTATICO').AsBoolean;
        VL_RegModulo^.Menu_Estatico := ZConsulta.FieldByName('MENU_ESTATICO').AsBoolean;
        VL_RegModulo^.Menu_Operacional_estatico := ZConsulta.FieldByName('MENU_ESTATICO_OPERACIONAL').AsBoolean;
        VL_RegModulo^.ThModulo := TThModulo.Create(True, VL_RegModulo, cnCaixa, PChar(ExtractFilePath(ParamStr(0)) +
            ZConsulta.FieldByName('TAG_NUMERO').AsString + '_caixa.txt'), @DNucleo);
        VF_ListaThModulo.Add(VL_RegModulo^.ThModulo);
        VL_RegModulo^.ThModulo.Start;
        ZConsulta.Next;

    end;
    Result := 0;
end;



function TDNucleo.ModuloDescarrega(VP_ModuloConfig_ID: integer): integer;
var
    VL_I: integer;
begin

    DNucleo.VF_Bin.RemovePorModuloConf(VP_ModuloConfig_ID);
    if VP_ModuloConfig_ID = 0 then
    begin
        if Assigned(VF_ListaThModulo) then
            while VF_ListaThModulo.Count > 0 do
            begin
                if Assigned(VF_ListaThModulo.Items[0]) then
                    if TThModulo(VF_ListaThModulo[0]).VF_Rodando then
                    begin
                        TThModulo(VF_ListaThModulo[0]).FreeOnTerminate := True;
                        TThModulo(VF_ListaThModulo[0]).Terminate;
                    end
                    else
                        TThModulo(VF_ListaThModulo[0]).Free;
                VF_ListaThModulo.Delete(0);
            end;
    end
    else
    if Assigned(VF_ListaThModulo) then
    begin
        for VL_I := 0 to VF_ListaThModulo.Count - 1 do
        begin
            if Assigned(VF_ListaThModulo.Items[VL_I]) then
                if (TRegModulo(TThModulo(VF_ListaThModulo[VL_I]).VF_modulo^).ModuloConfig_ID = VP_ModuloConfig_ID) then
                begin
                    if TThModulo(VF_ListaThModulo[VL_I]).VF_Rodando then
                    begin
                        TThModulo(VF_ListaThModulo[VL_I]).FreeOnTerminate := True;
                        TThModulo(VF_ListaThModulo[VL_I]).Terminate;
                    end
                    else
                        TThModulo(VF_ListaThModulo[VL_I]).Free;
                    VF_ListaThModulo.Delete(VL_I);
                Break;
                end;
            Result := 0;
        end;
        for VL_I := 0 to VF_ListaThModulo.Count - 1 do     // faz de novo pois cada modulo tem 2 threads
        begin
            if Assigned(VF_ListaThModulo.Items[VL_I]) then
                if (TRegModulo(TThModulo(VF_ListaThModulo[VL_I]).VF_modulo^).ModuloConfig_ID = VP_ModuloConfig_ID) then
                begin
                    if TThModulo(VF_ListaThModulo[VL_I]).VF_Rodando then
                    begin
                        TThModulo(VF_ListaThModulo[VL_I]).FreeOnTerminate := True;
                        TThModulo(VF_ListaThModulo[VL_I]).Terminate;
                    end
                    else
                        TThModulo(VF_ListaThModulo[VL_I]).Free;
                    VF_ListaThModulo.Delete(VL_I);
                Break;
                end;
            Result := 0;
        end;
    end;
end;

function TDNucleo.ModuloAddSolicitacao(VP_SocketID:Integer;VP_SocketTransmissaoID,VP_Transmissao_ID:string; VP_TempoEspera, VP_ModuloConfig_ID: integer;
    VP_Mensagem: TMensagem; VP_ConexaoTipo: TConexaoTipo): integer;
var
    VL_I: integer;
    VL_RegModulo: TRegModulo;
    VL_Tarefa: ^TTarefa;
begin
    Result := -1;
    VL_Tarefa := nil;
    for VL_I := 0 to VF_ListaThModulo.Count - 1 do
    begin
        if ((TRegModulo(TThModulo(VF_ListaThModulo[VL_I]).VF_Modulo^).ModuloConfig_ID = VP_ModuloConfig_ID) and
            (TRegModulo(TThModulo(VF_ListaThModulo[VL_I]).VF_Modulo^).ConexaoTipo = VP_ConexaoTipo)) then
        begin
            VL_RegModulo := TRegModulo(TThModulo(VF_ListaThModulo[VL_I]).VF_Modulo^);
            new(VL_Tarefa);
            F_Tarefa_ID_Contador := F_Tarefa_ID_Contador + 1;
            VL_Tarefa^.VF_ID := F_Tarefa_ID_Contador;
            VL_Tarefa^.VF_TipoConexao := VP_ConexaoTipo;
            VL_Tarefa^.VF_ModuloConfig_ID := VP_ModuloConfig_ID;
            VL_Tarefa^.VF_Tratando := False;
            VL_Tarefa^.VF_DataCriacao := now;
            VL_Tarefa^.VF_Mensagem := VP_Mensagem.TagsAsString;
            VL_Tarefa^.VF_TempoEspera := VP_TempoEspera;
            VL_Tarefa^.VF_TransmissaoID := VP_Transmissao_ID;
            VL_Tarefa^.VF_SocketID:=VP_SocketID;
            VL_Tarefa^.VF_SocketTransmissaoID:=VP_SocketTransmissaoID;

            VL_RegModulo.ThModulo.V_ListaTarefas.Add(VL_Tarefa);
        end
        else
            Result := 70;
    end;

end;

function TDNucleo.ModuloAddSolicitacao(VP_Transmissao_ID: string; VP_TempoEspera, VP_ModuloProcID: integer; VP_Mensagem: TMensagem): integer;
var
    VL_I: integer;
    VL_RegModulo: TRegModulo;
    VL_Tarefa: ^TTarefa;
begin
    Result := -1;
    VL_Tarefa := nil;
    for VL_I := 0 to VF_ListaThModulo.Count - 1 do
    begin
        VL_RegModulo := TRegModulo(TThModulo(VF_ListaThModulo[VL_I]).VF_Modulo^);
        if (VL_RegModulo.ModuloProcID = VP_ModuloProcID) then
        begin
            new(VL_Tarefa);
            F_Tarefa_ID_Contador := F_Tarefa_ID_Contador + 1;
            VL_Tarefa^.VF_ID := F_Tarefa_ID_Contador;
            VL_Tarefa^.VF_TipoConexao := VL_RegModulo.ConexaoTipo;
            VL_Tarefa^.VF_ModuloConfig_ID := VL_RegModulo.ModuloConfig_ID;
            VL_Tarefa^.VF_Tratando := False;
            VL_Tarefa^.VF_Tratando := False;
            VL_Tarefa^.VF_DataCriacao := now;
            VL_Tarefa^.VF_Mensagem := VP_Mensagem.TagsAsString;
            VL_Tarefa^.VF_TempoEspera := VP_TempoEspera;
            VL_Tarefa^.VF_TransmissaoID := VP_Transmissao_ID;
            VL_Tarefa^.VF_SocketID:=0;
            VL_Tarefa^.VF_SocketTransmissaoID:='';
            VL_RegModulo.ThModulo.V_ListaTarefas.Add(VL_Tarefa);
        end
        else
            Result := 70;
    end;

end;


function TDNucleo.AtualizaBIN(VP_Modulo: TRegModulo; VP_Mensagem: TMensagem): integer;
var
    VL_Consulta: TZQuery;
    VL_Bin: string;
    VL_Bins: TStringList;
    VL_ModuloConfID: integer;
    VL_I: integer;
begin
    Result := 0;

    if not Assigned(@VP_Modulo) then
    begin
        Result := 64;
        Exit;
    end;

    if VP_Modulo.ModuloConfig_ID < 1 then
    begin
        Result := 64;
        Exit;
    end;


    VL_ModuloConfID := 0;
    VL_Bin := '';
    try

        VL_Consulta := TZQuery.Create(Self);
        VL_Consulta.Connection := ZConexao;
        VL_Bins := TStringList.Create;

        VF_Bin.RemovePorModuloConf(VP_Modulo.ModuloConfig_ID);

        VL_Consulta.SQL.Text := 'SELECT MODULO.TAG_NUMERO, M.ID AS MODULO_CONF_ID, M.BIN_ESTATICO AS BIN_ESTATICO , B.IIN as BIN ' +
            ' FROM' +
            ' MODULO_CONF M' +
            ' INNER JOIN BIN B ON B.MODULO_CONF_ID=M.ID' +
            ' INNER JOIN MODULO ON MODULO.ID=M.MODULO_ID' +
            ' WHERE' +
            ' M.ID=' + IntToStr(VP_Modulo.ModuloConfig_ID);
        VL_Consulta.Open;

        while not VL_Consulta.EOF do
        begin
            VF_Bin.Add(VL_Consulta.FieldByName('BIN').AsString, VP_Modulo.ModuloConfig_ID, VL_Consulta.FieldByName('TAG_NUMERO').AsString);
            VL_Consulta.Next;
        end;

        VP_Modulo.Bin_estatico := (VL_Consulta.FieldByName('BIN_ESTATICO').AsString = 'T');

        if VP_Modulo.Bin_estatico = False then
        begin
            if Assigned(VP_Mensagem) then
            begin
                VL_Bin := VP_Mensagem.GetTagAsAstring('0036');         //BIN UNICO
                if VL_Bin <> '' then
                begin
                    VL_ModuloConfID := VF_Bin.RetornaModuloConfId(VL_Bin);
                    if VL_ModuloConfID = -1 then
                    begin
                        Result := VF_Bin.Add(VL_Bin, VP_Modulo.ModuloConfig_ID, VP_Modulo.Tag);
                        if Result <> 0 then
                            Exit;
                    end
                    else
                    if VL_ModuloConfID <> VP_Modulo.ModuloConfig_ID then
                    begin
                        Result := 63;
                        Exit;
                    end;

                end;

                //                testa antes de incluir
                VL_Bins.Text := VP_Mensagem.GetTagAsAstring('00CE');
                for VL_I := 0 to VL_Bins.Count - 1 do
                begin
                    VL_Bin := VL_Bins[VL_I];
                    if VL_Bin <> '' then
                    begin
                        VL_ModuloConfID := VF_Bin.RetornaModuloConfId(VL_Bin);
                        if (VL_ModuloConfID <> VP_Modulo.ModuloConfig_ID) and (VL_ModuloConfID <> -1) then
                        begin
                            Result := 63;
                            Exit;
                        end;
                    end;

                end;

                //              incluir bins
                for VL_I := 0 to VL_Bins.Count - 1 do
                begin
                    VL_Bin := VL_Bins[VL_I];
                    if VL_Bin <> '' then
                    begin
                        Result := VF_Bin.Add(VL_Bin, VP_Modulo.ModuloConfig_ID, VP_Modulo.Tag);
                        if Result <> 0 then
                            Exit;
                    end;
                end;
            end;

        end
        else
        if Assigned(VP_Mensagem) then
        begin
            if (VP_Mensagem.GetTagAsAstring('0036') <> '') or (VP_Mensagem.GetTagAsAstring('00CE') <> '') then
                Result := 65;

        end;

    finally
        VL_Consulta.Free;
        VL_Bins.Free;
    end;

end;

function TDNucleo.AtualizaMENU(VP_Modulo: TRegModulo; VP_Mensagem: TMensagem): integer;
var
    VL_Consulta: TZQuery;
    VL_Mensagem: TMensagem;
    VL_ModuloConfID: integer;
    VL_I: integer;
    VL_Tag: TTag;
begin
    Result := 0;
    VL_Tag.Dados := '';
    VL_Tag.Qt := '';
    VL_Tag.Tag := '';
    VL_Tag.Tamanho := 0;
    VL_ModuloConfID := 0;
    try
        VL_Mensagem := TMensagem.Create;
        VL_Consulta := TZQuery.Create(nil);
        VL_Consulta.Connection := ZConexao;



        if VP_Modulo.ModuloConfig_ID = 0 then
        begin
            VF_Menu.RemovePorModuloConf(0);
            VL_Consulta.Close;
            VL_Consulta.SQL.Text := 'SELECT  S_TAG_DADOS, S_TAG_NUMERO,S_HABILITADO' +
                ' FROM P_TAG_FUNCAO(0,''MENU_PDV'') WHERE S_HABILITADO=''T''';
            VL_Consulta.Open;
            while not VL_Consulta.EOF do
            begin
                VF_Menu.Add(VL_Consulta.FieldByName('S_TAG_NUMERO').AsString, VL_Consulta.FieldByName('S_TAG_DADOS').AsString, 0);
                VL_Consulta.Next;
            end;
            Exit;
        end;


        if not Assigned(@VP_Modulo) then
        begin
            Result := 64;
            Exit;
        end;

        if VP_Modulo.ModuloConfig_ID < 1 then
        begin
            Result := 64;
            Exit;
        end;

        VF_Menu.RemovePorModuloConf(VP_Modulo.ModuloConfig_ID);
        VL_Consulta.Close;
        VL_Consulta.SQL.Text := 'SELECT M.ID AS MODULO_CONF_ID, M.MENU_ESTATICO AS MENU_ESTATICO ' +
            ' FROM' +
            ' MODULO_CONF M' +
            ' WHERE' +
            ' M.ID=' + IntToStr(VP_Modulo.ModuloConfig_ID);
        VL_Consulta.Open;

        VP_Modulo.Menu_estatico := (VL_Consulta.FieldByName('MENU_ESTATICO').AsString = 'T');


        if ((VP_Mensagem.GetTagAsAstring('007D') = '') and (VP_Mensagem.GetTagAsAstring('004D') = '0')) then  // não é para atualizar o menu
            Exit;

        Result := VL_Mensagem.CarregaTags(VP_Mensagem.GetTagAsAstring('007D')); //TAG DE MENSAGEM CONTENDO O MENU

        if ((VP_Modulo.Menu_estatico = False) and (Result = 0)) then
        begin
            if Assigned(VP_Mensagem) then
            begin
                //                testa antes de incluir, permite incluir tag proprietaria ou official
                //                testa as tag oficiais e nao oficiais


                // testa as tags nao oficiais se ja foi incluida, testa as tag oficiais comparando com banco de dados

                VL_Consulta.Close;
                VL_Consulta.SQL.Text := 'SELECT  S_TAG_NUMERO,S_HABILITADO' +
                    ' FROM P_TAG_FUNCAO(0,''MENU_PDV'') WHERE S_HABILITADO=''T''';
                VL_Consulta.Open;


                for VL_I := 1 to VL_Mensagem.TagCount do
                begin
                    VL_Mensagem.GetTag(VL_I, VL_Tag);

                    if Length(Trim(VL_Tag.Tag)) = 0 then
                    begin
                        Result := 75;
                        Exit;
                    end;

                    if Length(Trim(VL_Tag.Dados)) = 0 then
                    begin
                        Result := 76;
                        Exit;
                    end;


                    VL_ModuloConfID := VF_Menu.RetornaModuloConfId(VL_Tag.Tag);
                    if VL_ModuloConfID <> 0 then
                        if (VL_ModuloConfID <> VP_Modulo.ModuloConfig_ID) and (VL_ModuloConfID <> -1) then
                        begin
                            Result := 72;
                            Exit;
                        end;

                    if Copy(VL_Tag.Tag, 1, 2) <> 'FF' then  //verifica a permissao de uso da tag oficial
                    begin
                        if not VL_Consulta.Locate('S_TAG_NUMERO', VL_Tag.Tag, []) then
                        begin
                            Result := 73;
                            Exit;
                        end;
                    end;
                end;


                //              incluir MENUS
                for VL_I := 1 to VL_Mensagem.TagCount do
                begin
                    VL_Mensagem.GetTag(VL_I, VL_Tag);
                    if Copy(VL_Tag.Tag, 1, 2) <> 'FF' then
                        Result := VF_Menu.Add(VL_Tag.Tag, VL_Tag.Dados, 0)
                    else
                        Result := VF_Menu.Add(VL_Tag.Tag, VL_Tag.Dados, VP_Modulo.ModuloConfig_ID);
                    if Result <> 0 then
                        Exit;
                end;
            end;

        end
        else
        if Assigned(VP_Mensagem) then
        begin
            if (VP_Mensagem.GetTagAsAstring('007D') <> '') then
                Result := 71;

        end;


    finally
        VL_Consulta.Close;
        VL_Consulta.Free;
    end;

end;

function TDNucleo.AtualizaMENU_OPERACIONAL(VP_Modulo: TRegModulo; VP_Mensagem: TMensagem): integer;
var
    VL_Consulta: TZQuery;
    VL_Mensagem: TMensagem;
    VL_ModuloConfID: integer;
    VL_I: integer;
    VL_Tag: TTag;
begin
    Result := 0;
    VL_Tag.Dados := '';
    VL_Tag.Qt := '';
    VL_Tag.Tag := '';
    VL_Tag.Tamanho := 0;
    VL_ModuloConfID := 0;
    try
        VL_Mensagem := TMensagem.Create;
        VL_Consulta := TZQuery.Create(nil);
        VL_Consulta.Connection := ZConexao;



        if VP_Modulo.ModuloConfig_ID = 0 then
        begin
            VF_MenuOperacional.RemovePorModuloConf(0);
            VL_Consulta.Close;
            VL_Consulta.SQL.Text := 'SELECT  S_TAG_DADOS, S_TAG_NUMERO,S_HABILITADO' +
                ' FROM P_TAG_FUNCAO(0,''MENU_OPERACIONAL'') WHERE S_HABILITADO=''T''';
            VL_Consulta.Open;
            while not VL_Consulta.EOF do
            begin
                VF_MenuOperacional.Add(VL_Consulta.FieldByName('S_TAG_NUMERO').AsString, VL_Consulta.FieldByName('S_TAG_DADOS').AsString, 0);
                VL_Consulta.Next;
            end;
            Exit;
        end;


        if not Assigned(@VP_Modulo) then
        begin
            Result := 64;
            Exit;
        end;

        if VP_Modulo.ModuloConfig_ID < 1 then
        begin
            Result := 64;
            Exit;
        end;

        VF_MenuOperacional.RemovePorModuloConf(VP_Modulo.ModuloConfig_ID);
        VL_Consulta.Close;
        VL_Consulta.SQL.Text := 'SELECT M.ID AS MODULO_CONF_ID, M.MENU_ESTATICO AS MENU_ESTATICO_OPERACIONAL ' +
            ' FROM' +
            ' MODULO_CONF M' +
            ' WHERE' +
            ' M.ID=' + IntToStr(VP_Modulo.ModuloConfig_ID);
        VL_Consulta.Open;

        VP_Modulo.Menu_estatico := (VL_Consulta.FieldByName('MENU_ESTATICO_OPERACIONAL').AsString = 'T');


        if ((VP_Mensagem.GetTagAsAstring('007D') = '') and (VP_Mensagem.GetTagAsAstring('004D') = '0')) then  // não é para atualizar o menu
            Exit;

        Result := VL_Mensagem.CarregaTags(VP_Mensagem.GetTagAsAstring('007D')); //TAG DE MENSAGEM CONTENDO O MENU


        if ((VP_Modulo.Menu_estatico = False) and (Result = 0)) then
        begin
            if Assigned(VP_Mensagem) then
            begin
                //                testa antes de incluir, permite incluir tag proprietaria ou official
                //                testa as tag oficiais e nao oficiais


                // testa as tags nao oficiais se ja foi incluida, testa as tag oficiais comparando com banco de dados

                VL_Consulta.Close;
                VL_Consulta.SQL.Text := 'SELECT  S_TAG_NUMERO,S_HABILITADO' +
                    ' FROM P_TAG_FUNCAO(0,''MENU_OPERACIONAL'') WHERE S_HABILITADO=''T''';
                VL_Consulta.Open;


                for VL_I := 1 to VL_Mensagem.TagCount do
                begin
                    VL_Mensagem.GetTag(VL_I, VL_Tag);

                    if Length(Trim(VL_Tag.Tag)) = 0 then
                    begin
                        Result := 75;
                        Exit;
                    end;

                    if Length(Trim(VL_Tag.Dados)) = 0 then
                    begin
                        Result := 76;
                        Exit;
                    end;


                    VL_ModuloConfID := VF_MenuOperacional.RetornaModuloConfId(VL_Tag.Tag);
                    if VL_ModuloConfID <> 0 then
                        if (VL_ModuloConfID <> VP_Modulo.ModuloConfig_ID) and (VL_ModuloConfID <> -1) then
                        begin
                            Result := 72;
                            Exit;
                        end;

                    if Copy(VL_Tag.Tag, 1, 2) <> 'FF' then  //verifica a permissao de uso da tag oficial
                    begin
                        if not VL_Consulta.Locate('S_TAG_NUMERO', VL_Tag.Tag, []) then
                        begin
                            Result := 73;
                            Exit;
                        end;
                    end;
                end;


                //              incluir MENUS
                for VL_I := 1 to VL_Mensagem.TagCount do
                begin
                    VL_Mensagem.GetTag(VL_I, VL_Tag);
                    if Copy(VL_Tag.Tag, 1, 2) <> 'FF' then
                        Result := VF_MenuOperacional.Add(VL_Tag.Tag, VL_Tag.Dados, 0)
                    else
                        Result := VF_MenuOperacional.Add(VL_Tag.Tag, VL_Tag.Dados, VP_Modulo.ModuloConfig_ID);
                    if Result <> 0 then
                        Exit;
                end;
            end;

        end
        else
        if Assigned(VP_Mensagem) then
        begin
            if (VP_Mensagem.GetTagAsAstring('007D') <> '') then
                Result := 71;

        end;


    finally
        VL_Consulta.Close;
        VL_Consulta.Free;
    end;

end;

function TDNucleo.ModuloGetReg(VP_ModuloProc_ID: integer): TRegModulo;
var
    VL_I: integer;
begin
    Result.ModuloConfig_ID := -1;
    Result.ModuloProcID := -1;
    for VL_I := 0 to VF_ListaThModulo.Count - 1 do
    begin
        if TRegModulo(TThModulo(VF_ListaThModulo[VL_I]).VF_Modulo^).ModuloProcID = VP_ModuloProc_ID then
        begin
            Result := TRegModulo(TThModulo(VF_ListaThModulo[VL_I]).VF_Modulo^);
            Exit;
        end;
    end;

end;




{ TBin }

constructor TBin.Create;
begin
    inherited;
    ListaBin := TList.Create;
end;

destructor TBin.Destroy;
var
    VL_Bin: ^TRecBin;
begin
    while ListaBin.Count > 0 do
    begin
        VL_Bin := ListaBin[0];
        Dispose(VL_Bin);
        ListaBin.Delete(0);
    end;


    ListaBin.Free;
    inherited Destroy;
end;

function TBin.Add(VP_IIN: ansistring; VP_ModuloConfID: integer; VP_Tag: string): integer;
var
    VL_Bin: ^TRecBin;
    VL_ModuloConfID: integer;
begin
    Result := 0;
    if Length(Trim(VP_IIN)) = 0 then
    begin
        Result := 74;
        Exit;
    end;
    VL_ModuloConfID := RetornaModuloConfId(VP_IIN);
    if (VL_ModuloConfID <> VP_ModuloConfID) and (VL_ModuloConfID <> -1) then
    begin
        Result := 63;
        Exit;
    end;
    new(VL_Bin);
    VL_Bin^.IIN := VP_IIN;
    VL_Bin^.Tag := VP_Tag;
    VL_Bin^.ModuloConfID := VP_ModuloConfID;
    ListaBin.Add(VL_Bin);
end;

procedure TBin.Limpar;
var
    VL_Bin: ^TRecBin;
begin
    while ListaBin.Count > 0 do
    begin
        VL_Bin := ListaBin[0];
        Dispose(VL_Bin);
        ListaBin.Delete(0);
    end;

end;

function TBin.Get(VP_Posicao: integer): TRecBin;
var
    VL_RecBin: ^TRecBin;
begin
    VL_RecBin := ListaBin.Items[VP_Posicao];
    Result := VL_RecBin^;
end;


function TBin.Count: integer;
begin
    Result := ListaBin.Count;
end;

procedure TBin.RemovePorModuloConf(VP_ModuloConfID: integer);
var
    VL_Bin: ^TRecBin;
    VL_Continua: boolean;
    VL_I: integer;
begin
    VL_Continua := True;

    while VL_Continua do
    begin

        VL_I := ListaBin.Count;
        if VL_I = 0 then
            exit;

        VL_Continua := False;

        for VL_I := 0 to ListaBin.Count - 1 do
        begin
            VL_Bin := ListaBin.Items[VL_I];
            if VL_Bin^.ModuloConfID = VP_ModuloConfID then
            begin
                VL_Continua := True;
                ListaBin.Remove(VL_Bin);
                Dispose(VL_Bin);
                Break;
            end;

        end;

    end;
end;

function TBin.RetornaModuloConfId(VP_IIN: ansistring): integer;
var
    VL_Bin: ^TRecBin;
    VL_I: integer;
begin
    Result := -1;

    if ListaBin.Count = 0 then
        Exit;

    for VL_I := 0 to ListaBin.Count - 1 do
    begin
        VL_Bin := ListaBin.Items[VL_I];
        if VL_Bin^.IIN = VP_IIN then
        begin
            Result := VL_Bin^.ModuloConfID;
            Exit;
        end;
    end;

end;

function TBin.RetornaBIN(VP_IIN: ansistring): TRecBin;
var
    VL_Bin: ^TRecBin;
    VL_I: integer;
begin
    Result.ModuloConfID := -1;
    Result.IIN := '';
    Result.Tag := '';

    if ListaBin.Count = 0 then
        Exit;

    for VL_I := 0 to ListaBin.Count - 1 do
    begin
        VL_Bin := ListaBin.Items[VL_I];
        if VL_Bin^.IIN = VP_IIN then
        begin
            Result := VL_Bin^;
            Exit;
        end;
    end;

end;

{ TMenu }

constructor TMenu.Create;
begin
    ListaMenu := TList.Create;
    inherited;
end;

destructor TMenu.Destroy;
var
    VL_Menu: ^TRecMenu;
begin
    while ListaMenu.Count > 0 do
    begin
        VL_Menu := ListaMenu[0];
        Dispose(VL_Menu);
        ListaMenu.Delete(0);
    end;

    ListaMenu.Free;
    inherited Destroy;
end;

function TMenu.Add(VP_Tag, VP_TextoBotao: ansistring; VP_ModuloConfID: integer): integer;
var
    VL_Menu: ^TRecMenu;
begin
    Result := 0;
    if Length(Trim(VP_Tag)) = 0 then
    begin
        Result := 75;
        Exit;
    end;

    if Length(Trim(VP_TextoBotao)) = 0 then
    begin
        Result := 76;
        Exit;
    end;


    new(VL_Menu);
    VL_Menu^.Tag := VP_Tag;
    VL_Menu^.TextoBotao := VP_TextoBotao;
    VL_Menu^.ModuloConfID := VP_ModuloConfID;
    ListaMenu.Add(VL_Menu);

end;

procedure TMenu.Limpar;
var
    VL_Menu: ^TRecMenu;
begin
    while ListaMenu.Count > 0 do
    begin
        VL_Menu := ListaMenu[0];
        Dispose(VL_Menu);
        ListaMenu.Delete(0);
    end;

end;

function TMenu.Get(VP_Posicao: integer): TRecMenu;
var
    VL_RecMenu: ^TRecMenu;
begin
    VL_RecMenu := ListaMenu.Items[VP_Posicao];
    Result := VL_RecMenu^;

end;

function TMenu.GetTag(VP_Posicao: integer): string;
var
    VL_RecMenu: ^TRecMenu;
begin
    VL_RecMenu := ListaMenu.Items[VP_Posicao];
    Result := VL_RecMenu^.Tag;

end;

function TMenu.GetTextoBotao(VP_Posicao: integer): string;
var
    VL_RecMenu: ^TRecMenu;
begin
    VL_RecMenu := ListaMenu.Items[VP_Posicao];
    Result := VL_RecMenu^.TextoBotao;

end;

function TMenu.Count: integer;
begin
    Result := ListaMenu.Count;
end;

procedure TMenu.RemovePorModuloConf(VP_ModuloConfID: integer);
var
    VL_Menu: ^TRecMenu;
    VL_Continua: boolean;
    VL_I: integer;
begin
    VL_Continua := True;

    while VL_Continua do
    begin

        if ListaMenu.Count = 0 then
            exit;

        VL_Continua := False;

        for VL_I := 0 to ListaMenu.Count - 1 do
        begin
            VL_Menu := ListaMenu.Items[VL_I];
            if VL_Menu^.ModuloConfID = VP_ModuloConfID then
            begin
                VL_Continua := True;
                ListaMenu.Remove(VL_Menu);
                Dispose(VL_Menu);
                Break;
            end;

        end;

    end;

end;

function TMenu.RetornaModuloConfId(VP_Tag: ansistring): integer;
var
    VL_Menu: ^TRecMenu;
    VL_I: integer;
begin
    Result := -1;

    if ListaMenu.Count = 0 then
        Exit;

    for VL_I := 0 to ListaMenu.Count - 1 do
    begin
        VL_Menu := ListaMenu.Items[VL_I];
        if VL_Menu^.Tag = VP_Tag then
        begin
            Result := VL_Menu^.ModuloConfID;
            Exit;
        end;
    end;

end;

{ TThTransacao }

procedure TThTransacao.Execute;
var
    VL_Transacao: TTransacao;
    VL_Mensagem: TMensagem;
    VL_I: integer;
    VL_Tag, VL_TagDados: string;
begin
    VL_Tag := '';
    VL_TagDados := '';
    if V_Mensagem.ComandoDados() <> 'S' then
    begin
        V_Mensagem.Limpar;
        V_Mensagem.AddComando('0026', '62');
        DComunicador.ServidorTransmiteSolicitacao(3000, False, nil, V_TransmissaoID, V_Mensagem, V_Mensagem, V_AContext);
        exit;
    end;
    VL_Mensagem := TMensagem.Create;
    VL_Transacao := TTransacao.Create(TTConexao(V_AContext.Data).Terminal_Tipo, TTConexao(V_AContext.Data).Terminal_ID, '');
    VL_Mensagem.CarregaTags(VL_Transacao.fMensagem.TagsAsString);

    for VL_I := 1 to V_Mensagem.TagCount do
    begin
        V_Mensagem.GetTag(VL_I, VL_Tag, VL_TagDados);

        case VL_Tag of
            '00A3': ;
            '0051': ;
            '00A2': ;
            '007C': ;
            '00A4': ;
            '0034':
            else
                VL_Mensagem.AddTag(VL_Tag, VL_TagDados);
        end;
        VL_Mensagem.AddComando('007A', 'R');
    end;
    DComunicador.ServidorTransmiteSolicitacao(3000, False, nil, V_TransmissaoID, VL_Mensagem, VL_Mensagem, V_AContext);
    VL_Transacao.Free;

end;

constructor TThTransacao.Create(VP_Suspenso: boolean; VP_Trasmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext);
begin
    V_Mensagem := TMensagem.Create;
    v_Mensagem.CarregaTags(VP_Mensagem.TagsAsString);
    V_AContext := VP_AContext;
    V_TransmissaoID := VP_Trasmissao_ID;
    FreeOnTerminate := True;
    inherited Create(VP_Suspenso);
end;

destructor TThTransacao.Destroy;
begin
    V_Mensagem.Free;
    inherited Destroy;
end;


{ TThModulo }


constructor TThModulo.Create(VP_Suspenso: boolean; VP_Modulo: Pointer; VP_ConexaoTipo: TConexaoTipo; VP_ArquivoLog: string; VP_DNucleo: Pointer);
begin
    FreeOnTerminate := True;
    VF_modulo := VP_Modulo;
    VF_DNucleo := VP_DNucleo;
    VF_LibCarregada := False;
    VF_Rodando := False;
    VF_Evento := TTemporizador.Create;
    VF_ConexaoTipo := VP_ConexaoTipo;
    V_ListaTarefas := TList.Create;
    VF_ArquivoLog := VP_ArquivoLog;
    inherited Create(VP_Suspenso);

end;

destructor TThModulo.Destroy;
begin
    VF_Evento.Free;
    VF_Evento:=nil;
    V_ListaTarefas.Free;
    V_ListaTarefas:=nil;
    if Assigned(DNucleo) then
        TDNucleo(VF_DNucleo^).VF_Bin.RemovePorModuloConf(TRegModulo(VF_modulo^).ModuloConfig_ID);
    inherited Destroy;
end;

{ TModulos }


procedure TDNucleo.DataModuleCreate(Sender: TObject);
begin
    VF_ListaThModulo := TList.Create;
    VF_Bin := TBin.Create;
    VF_Menu := TMenu.Create;
    VF_MenuOperacional := TMenu.Create;
end;

procedure TDNucleo.DataModuleDestroy(Sender: TObject);
begin
    VF_ListaThModulo.free;
    VF_ListaThModulo:=nil;
    VF_Bin.Free;
    VF_Menu.Free;
    VF_MenuOperacional.Free;
end;


function TDNucleo.comando(VP_Codigo: integer; VP_Transmissao_ID: string; VP_DadosRecebidos: string; VP_AContext: TIdContext): integer;
var
    VL_Mensagem: TMensagem;
begin

    if VP_Codigo <> 0 then
    begin
        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '250820221507', 'TDNucleo.comando, recebeu comando com erro', '', VP_Codigo);
    end;

    VL_Mensagem := TMensagem.Create;

    if VL_Mensagem.CarregaTags(VP_DadosRecebidos) <> 0 then
    begin
        VP_AContext.Connection.Disconnect;
        Exit;
    end;

    case VL_Mensagem.Comando() of
        '0001': Result := comando0001(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // LOGIN
        '0021': Result := comando0021(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // PEDIDO DE CONEXÃO TROCA DE CHAVES
        '000A': Result := comando000A(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // INICIA VENDA DO FRENTE DE CAIXA
        '0018': Result := comando0018(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // SOLICITANDO OU INFOMANDO A OPÇÃO DO MENU DE VENDA
        '002B': Result := comando002B(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // EXCLUIR MODULO
        '0039': Result := comando0039(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // INCLUIR LOJA
        '003F': Result := comando003F(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // ALTERAR LOJA
        '0044': Result := comando0044(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // INCLUIR PDV
        '0045': Result := comando0045(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // VALIDA CHAVE PDV
        '004B': Result := comando004B(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // ALTERAR PDV
        '0052': Result := comando0052(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // INCLUIR TAG
        '0053': Result := comando0053(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // INCLUIR PINPAD
        '0055': Result := comando0055(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // ALTERAR PINPAD
        '0057': Result := comando0057(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // INCLUIR CONFIGURADOR
        '0058': Result := comando0058(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // ALTERAR CONFIGURADOR
        '0059': Result := comando0059(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // VALIDA CHAVE CONFIGURADOR
        '0064': Result := comando0064(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // INCLUIR MULT-LOJA
        '0066': Result := comando0066(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // EXCLUIR MULT-LOJA
        '0067': Result := comando0067(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // ALTERAR MULT-LOJA
        '0069': Result := comando0069(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // EXCLUIR LOJA
        '006A': Result := comando006A(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // EXCLUIR PINPAD
        '006B': Result := comando006B(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // EXCLUIR PDV
        '0070': Result := comando0070(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // PESQUISA (TABELA EM LOTE)
        '0071': Result := comando0071(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // VALIDA CHAVE MODULO_CONF
        '0072': Result := comando0072(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // ALTERAR MODULO_CONF
        '0073': Result := comando0073(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // INCLUIR MODULO_CONF
        '0074': Result := comando0074(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // INCLUIR MODULO
        '0075': Result := comando0075(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // ALTERAR MODULO
        '0077': Result := comando0077(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // INCLUIR BIN
        '0078': Result := comando0078(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // EXCLUIR BIN
        '0079': Result := comando0079(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // INCLUIR MODULO_CONF_FUNCAO
        '007A': Result := comando007A(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // TRANSACAO PARA APROVACAO AUTOMATIZADA
        '007E': Result := comando007E(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // INCLUIR MODULO_FUNCAO
        '007F': Result := comando007F(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // EXCLUIR MODULO_FUNCAO
        '0085': Result := comando0085(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // ALTERAR MODULO_CONF_FUNCAO
        '0087': Result := comando0087(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // EXCLUIR LOJA_MODULO_CONF_FUNCAO
        '0088': Result := comando0088(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // EXCLUIR MULTILOJA_MODULO_CONF_FUNCAO
        '008A': Result := comando008A(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // EXCLUIR MODULO_CONF_FUNCAO
        '0096': Result := comando0096(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // INCLUIR MULTLOJA_MODULO
        '0099': Result := comando0099(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // EXCLUIR MULTLOJA_MODULO
        '009A': Result := comando009A(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // ALTERAR MULTLOJA_MODULO
        '009B': Result := comando009B(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // INCLUIR LOJA_MODULO_CONF_FUNCAO
        '009D': Result := comando009D(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // INCLUIR MULTLOJA_FUNCAO
        '009F': Result := comando009F(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // ALTERAR MULTLOJA_FUNCAO
        '00A0': Result := comando00A0(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // EXCLUIR MULTLOJA_FUNCAO
        '00AA': Result := comando00AA(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // INCLUIR LOJA_FUNCAO
        '00AC': Result := comando00AC(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // ALTERAR LOJA_FUNCAO
        '00AD': Result := comando00AD(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // EXCLUI LOJA_FUNCAO
        '00AE': Result := comando00AE(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // INCLUIR LOJA_MODULO
        '00B0': Result := comando00B0(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // ALTERAR MULTILOJA_MODULO_CONF_FUNCAO
        '00B1': Result := comando00B1(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // ALTERAR LOJA_MODULO
        '00B2': Result := comando00B2(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // EXCLUIR LOJA_MODULO
        '00B5': Result := comando00B5(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // INCLUIR PINPAD_FUNCAO
        '00B6': Result := comando00B6(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // ALTERAR PINPAD_FUNCAO
        '00B8': Result := comando00B8(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // EXCLUIR PINPAD_FUNCAO
        '00B9': Result := comando00B9(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // ALTERAR MODULO_FUNCAO
        '00BA': Result := comando00BA(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // EXCLUIR MODULO_CONF
        '00BB': Result := comando00BB(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // EXCLUIR CONFIGURADOR
        '00BF': Result := comando00BF(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // ALTERAR LOJA_MODULO_CONF_FUNCAO
        '00C2': Result := comando00C2(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // INCLUIR PDV_FUNCAO
        '00C4': Result := comando00C4(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // ALTERAR PDV_FUNCAO
        '00C5': Result := comando00C5(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // EXCLUIR PDV_FUNCAO
        '00C8': Result := comando00C8(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // INCLUIR PDV_MODULO
        '00CA': Result := comando00CA(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // INCLUIR MULTILOJA_MODULO_CONF_FUNCAO
        '00CB': Result := comando00CB(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // ALTERAR PDV_MODULO
        '00CC': Result := comando00CC(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // EXCLUIR PDV_MODULO
        '00DB': Result := comando00DB(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // ALTERAR TAG
        '00DC': Result := comando00DC(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // EXCLUIR TAG
        '00DE': Result := comando00DE(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // INCLUIR ADQUIRENTE
        '00DF': Result := comando00DF(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // ALTERAR ADQUIRENTE
        '00E0': Result := comando00E0(VP_Transmissao_ID, VL_Mensagem, VP_AContext);   // EXCLUIR ADQUIRENTE
        else
            VP_AContext.Connection.Disconnect(True);
    end;
    VL_Mensagem.Free;
end;

procedure ServidorRecebimento(VP_Codigo: integer; VP_Transmissao_ID, VP_DadosRecebidos: string; var VO_AContext: TIdContext);
begin
    DNucleo.comando(VP_Codigo, VP_Transmissao_ID, VP_DadosRecebidos, VO_AContext);
end;

function TDNucleo.comando0021(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;
var
    VL_Dados: string;
    VL_ExpoentePublico, VL_ModuloPublico: string;
    VL_TChaves: TTChaveComunicacao;
    VL_Mensagem: TMensagem;

begin
    VL_Mensagem := TMensagem.Create;
    VL_Dados := '';
    VL_TChaves.ID := 0;
    VL_TChaves.ChaveComunicacao := '';
    VL_ModuloPublico := '';
    VL_ExpoentePublico := '';
    try
        VP_Mensagem.GetTag('0023', VL_Dados);
        Result := 33;
        if TTConexao(VP_AContext.Data).Status = csDesconectado then
            Exit;
        if VL_Dados <> '' then
        begin
            VP_Mensagem.GetTag('0022', VL_TChaves.ID);
            VL_TChaves := DComunicador.V_ChavesDasConexoes.getChave((VL_TChaves.ID));
            if VL_TChaves.ID > 0 then
            begin
                TTConexao(VP_AContext.Data).setChaveComunicacao(VL_TChaves.ChaveComunicacao);
                try
                    if TTConexao(VP_AContext.Data).Aes.DecryptString(VL_Dados) = 'OK' then
                    begin
                        VL_Mensagem.AddComando('0024', '');
                        VL_Mensagem.TagToStr(VL_Dados);
                        TTConexao(VP_AContext.Data).Status := csChaveado;

                        VL_Dados := VL_Mensagem.TagsAsString;

                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('00D1', VP_Transmissao_ID);
                        VL_Mensagem.AddTag('00D2', VL_Dados);



                        VP_AContext.Connection.Socket.WriteLn(VL_Mensagem.TagsAsString);
                        Exit;
                    end;
                except

                end;
            end;
            VP_Mensagem.GetTag('0008', VL_ModuloPublico);
            VP_Mensagem.GetTag('0027', VL_ExpoentePublico);
            if VL_ExpoentePublico = '' then
            begin
                VL_Mensagem.AddComando('0026', '31');
                VL_Mensagem.TagToStr(VL_Dados);

                VL_Dados := VL_Mensagem.TagsAsString;

                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00D1', VP_Transmissao_ID);
                VL_Mensagem.AddTag('00D2', VL_Dados);


                VP_AContext.Connection.Socket.WriteLn(VL_Mensagem.TagsAsString);
                Exit;
            end;
        end;
        VL_Mensagem.limpar;
        VL_Mensagem.AddComando('0025', '');
        VP_Mensagem.GetTag('0008', VL_ModuloPublico);
        VP_Mensagem.GetTag('0027', VL_ExpoentePublico);

        TTConexao(VP_AContext.Data).setModuloPublico(VL_ModuloPublico);
        TTConexao(VP_AContext.Data).setExpoentePublico(VL_ExpoentePublico);

        VL_TChaves.ChaveComunicacao := TTConexao(VP_AContext.Data).getChaveComunicacao;
        VL_TChaves.ID := TTConexao(VP_AContext.Data).ChaveComunicacaoIDX;

        VL_Dados := TTConexao(VP_AContext.Data).Rsa.EncryptString(VL_TChaves.ChaveComunicacao);

        VL_Mensagem.AddTag('0009', VL_Dados);
        VL_Mensagem.AddTag('0022', VL_TChaves.ID);
        VL_Mensagem.AddTag('0008', TTConexao(VP_AContext.Data).ModuloPublico);
        VL_Mensagem.AddTag('0027', TTConexao(VP_AContext.Data).ExpoentePublico);
        VL_Mensagem.AddTag('0023', TTConexao(VP_AContext.Data).Aes.EncryptString('OK'));

        VL_Mensagem.TagToStr(VL_Dados);
        TTConexao(VP_AContext.Data).Status := csChaveado;

        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('00D1', VP_Transmissao_ID);
        VL_Mensagem.AddTag('00D2', VL_Dados);


        VP_AContext.Connection.Socket.WriteLn(VL_Mensagem.TagsAsString);

        Result := 0;


    finally
        VL_Mensagem.Free;
    end;

end;

function TDNucleo.comando0001(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;
var

    VL_ChaveTerminal, VL_IP, VL_TagDados: string;
    VL_Mensagem: TMensagem;
    VL_Consulta: TZQuery;
    VL_TerminalSenha: string;
    VL_Permissao: TPermissao;

begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_ChaveTerminal := '';
    VL_TerminalSenha := '';
    VL_TagDados := '';
    VL_Permissao := pmS;

    VL_Consulta := TZQuery.Create(DComunicador);
    VL_Consulta.Connection := DNucleo.ZConexao;
    try
        //inicio do processo
        VP_Mensagem.GetTag('0002', VL_ChaveTerminal);
        VP_Mensagem.GetTag('0035', VL_TerminalSenha);
        VP_Mensagem.GetTag('0037', VL_TagDados);    //  TIPO DE PERMISSAO DO TERMINAL

        VL_Permissao := StrToPermissao(VL_TagDados);

        VL_IP := TTConexao(VP_AContext.Data).ClienteIp;

        VL_Consulta.Close;
        VL_Consulta.SQL.Text := 'SELECT S_STATUS,S_ID,S_TERMINAL FROM P_VAL_TERMINAL(''' + VL_IP + ''',''' + VL_ChaveTerminal + ''',''' +
            VL_TerminalSenha + ''',''' + PermissaoToStr(VL_Permissao) + ''')';
        VL_Consulta.Open;

        if VL_Consulta.FieldByName('S_STATUS').AsInteger <> 0 then
        begin
            VL_Mensagem.AddComando('0029', '');
            VL_Mensagem.AddTag('0036', IntToStr(VL_Consulta.FieldByName('S_STATUS').AsInteger));
            Result := VL_Consulta.FieldByName('S_STATUS').AsInteger;
        end
        else
        if VL_Consulta.FieldByName('S_ID').AsInteger < 1 then
        begin
            VL_Mensagem.AddComando('0029', '');
            VL_Mensagem.AddTag('0036', '36');
            Result := 36;
        end
        else
        begin
            TTConexao(VP_AContext.Data).Status := csLogado;
            VL_Mensagem.AddComando('0028', '');
            TTConexao(VP_AContext.Data).Permissao := VL_Permissao;
            TTConexao(VP_AContext.Data).Terminal_ID := VL_Consulta.FieldByName('S_ID').AsInteger;
            TTConexao(VP_AContext.Data).Terminal_Tipo := VL_Consulta.FieldByName('S_TERMINAL').AsString;
        end;

        VL_Consulta.Close;
        DComunicador.ServidorTransmiteSolicitacao(3000, False, nil, VP_Transmissao_ID, VL_Mensagem, VL_Mensagem, VP_AContext);

    finally
        VL_Consulta.Close;
        VL_Mensagem.Free;
        VL_Consulta.Free;
    end;

end;


function TDNucleo.comando0018(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;// menu de venda
var
    VL_Consulta: TZQuery;
    VL_I: integer;
begin
    Result := 0;
    VL_Consulta := TZQuery.Create(nil);

    try
        if TTConexao(VP_AContext.Data).Status <> csLogado then
        begin
            VP_Mensagem.AddComando('0026', '35');
            DComunicador.ServidorTransmiteSolicitacao(3000, False, nil, VP_Transmissao_ID, VP_Mensagem, VP_Mensagem, VP_AContext);
            exit;
        end;

        VL_Consulta.Connection := ZConexao;

        if VP_Mensagem.ComandoDados() = 'S' then
        begin
            if VF_Menu.Count = 0 then
            begin
                VP_Mensagem.AddComando('0026', '56');
                DComunicador.ServidorTransmiteSolicitacao(3000, False, nil, VP_Transmissao_ID, VP_Mensagem, VP_Mensagem, VP_AContext);
                exit;
            end;

            VP_Mensagem.Limpar;
            VP_Mensagem.AddComando('0018', 'R');

            for VL_I := 0 to VF_Menu.Count - 1 do
                VP_Mensagem.AddTag(VF_Menu.GetTag(VL_I), VF_Menu.GetTextoBotao(VL_I));

            DComunicador.ServidorTransmiteSolicitacao(3000, False, nil, VP_Transmissao_ID, VP_Mensagem, VP_Mensagem, VP_AContext);
        end
        else
        begin
            VP_Mensagem.Limpar;
            VP_Mensagem.AddComando('0026', '57');
            DComunicador.ServidorTransmiteSolicitacao(3000, False, nil, VP_Transmissao_ID, VP_Mensagem, VP_Mensagem, VP_AContext);
            exit;
        end;

    finally
        begin
            VL_Consulta.Free;
        end;
    end;

end;

function TDNucleo.comando007A(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;
var
    VL_Transacao: TThTransacao;
begin
    Result := 0;
    VL_Transacao := TThTransacao.Create(True, VP_Transmissao_ID, VP_Mensagem, VP_AContext);
    VL_Transacao.Start;
end;

function TDNucleo.comando000A(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;
var
    VL_Transacao: TMensagem;
    VL_Consulta: TZQuery;
    VL_Bin: TRecBin;
    VL_TempoEmperaComandao: int64;
begin
    Result := 0;
    VL_TempoEmperaComandao := 0;
    VL_Transacao := TMensagem.Create;
    try
        //testa conexão devolve erro caso nao logado
        if TTConexao(VP_AContext.Data).Status <> csLogado then
        begin
            VP_Mensagem.Limpar;
            VP_Mensagem.AddComando('000A', 'R');
            VP_Mensagem.AddTag('004D', '35');
            DComunicador.ServidorTransmiteSolicitacao(3000, False, nil, VP_Transmissao_ID, VP_Mensagem, VP_Mensagem, VP_AContext);
            Exit;
        end;

        // começa testar os dados e solicitar os faltantes

        Result := VL_Transacao.CarregaTags(VP_Mensagem.GetTagAsAstring('007D'));

        VP_Mensagem.GetTag('0051', VL_TempoEmperaComandao);
        if VL_TempoEmperaComandao = 0 then
            VL_Transacao.GetTag('0051', VL_TempoEmperaComandao);
        if VL_TempoEmperaComandao = 0 then
            VL_TempoEmperaComandao := 30000;

        if Result <> 0 then
        begin
            VP_Mensagem.Limpar;
            VP_Mensagem.AddComando('0026', '35');
            DComunicador.ServidorTransmiteSolicitacao(VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID, VP_Mensagem, VP_Mensagem, VP_AContext);
            Exit;
        end;

        //verifica se tem o bin, para mandar para a operadora

        if ((VL_Transacao.GetTagAsAstring('00CE') = '') and (VL_Transacao.GetTagAsAstring('00D5') = '')) then //NAO TEM BIN E NÃO TEM BOTAO SELECIONAO
        begin
            VP_Mensagem.AddComando('0018', 'S');
            comando0018(VP_Transmissao_ID, VP_Mensagem, VP_AContext);
            Exit;
        end;


        //if ((VL_Transacao.GetTagAsAstring('00CE') = '') and (VL_Transacao.GetTagAsAstring('004F') <> '')) then //NAO TEM BIN E VEIO TRILHA 2
        //begin
        //    VP_Mensagem.Limpar;
        //    VP_Mensagem.AddComando('008C', 'S');
        //    VP_Mensagem.AddTag('00D9',VL_Transacao.GetTagAsAstring('004F'));                    // pan
        //    VP_Mensagem.AddTag('0062','0000'+ Copy(VL_Transacao.GetTagAsAstring('004F'),7,12));  //pan mascarado
        //    VP_Mensagem.AddTag('00CE', Copy(VL_Transacao.GetTagAsAstring('004F'), 1, 6));       //bin
        //
        //    DComunicador.ServidorTransmiteSolicitacao(VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID, VP_Mensagem, VP_Mensagem, VP_AContext);
        //    Exit;
        //
        //end;

        if ((VL_Transacao.GetTagAsAstring('00CE') = '') and (VL_Transacao.GetTagAsAstring('00D5') <> '')) then //NAO TEM BIN E SELECIONOU UMA OPÇÃO
        begin
            if VL_Transacao.GetTagAsAstring('00D5') = '001D' then  // LEITURA DE CARTAO
            begin
                VP_Mensagem.Limpar;
                VP_Mensagem.AddComando('0048', 'S');
                VP_Mensagem.AddTag('0051', '300000');
                DComunicador.ServidorTransmiteSolicitacao(VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID, VP_Mensagem, VP_Mensagem, VP_AContext);
                Exit;
            end;

            VP_Mensagem.AddComando('0018', 'S');
            comando0018(VP_Transmissao_ID, VP_Mensagem, VP_AContext);
            Exit;
        end;

        // tenta mandar a mensagem para o modulo ativo

        if (VL_Transacao.GetTagAsAstring('00CE') <> '') then // tem bin então tenta localizar o modulo
        begin
            VL_Bin := VF_Bin.RetornaBIN(VL_Transacao.GetTagAsAstring('00CE'));
            if VL_Bin.ModuloConfID = -1 then                                                      //MODULO NAO CARREGADO PARA ESSE BIN
            begin
                VP_Mensagem.AddComando('000A', 'R');
                VP_Mensagem.AddTag('004D', 79);
                DComunicador.ServidorTransmiteSolicitacao(VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID, VP_Mensagem, VP_Mensagem, VP_AContext);
                Exit;
            end;

                if TTConexao(VP_AContext.Data).Terminal_Tipo <> 'PDV' then          // CONEXAO NÃO É DO PDV E NÃO PODE FAZER VENDA
                begin
                    VP_Mensagem.AddComando('000A', 'R');
                    VP_Mensagem.AddTag('004D', 81);
                    DComunicador.ServidorTransmiteSolicitacao(VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID, VP_Mensagem, VP_Mensagem, VP_AContext);
                    Exit;
                end;
            // VERIFICA SE ESSE PDV TEM O MODULO_CONF LIBERADO NA LOJA
            try

                VL_Consulta := TZQuery.Create(nil);
                VL_Consulta.Connection := ZConexao;
                VL_Consulta.SQL.Text := 'SELECT S_HABILITADO,S_TAG_NUMERO FROM P_TAG_FUNCAO(' + IntToStr(TTConexao(VP_AContext.Data).Terminal_ID) +
                    ',''MODULO'')' +
                    ' WHERE S_HABILITADO=''T'' AND S_TAG_NUMERO=''' + VL_Bin.Tag + '''';
                VL_Consulta.Open;
                if VL_Consulta.FieldByName('S_HABILITADO').AsString <> 'T' then
                begin
                    VP_Mensagem.AddComando('000A', 'R');
                    VP_Mensagem.AddTag('004D', 79);
                    DComunicador.ServidorTransmiteSolicitacao(VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID, VP_Mensagem, VP_Mensagem, VP_AContext);
                    Exit;
                end;

                // encaminha para o modulo a solicitação
                // falta fazer as outras verificacoes como
                // venda parcelada, venda por cartao digitado...

                VP_Mensagem.AddComando('000A', 'S');
                VP_Mensagem.AddTag('007D', VL_Transacao.TagsAsString);        // TRANSACAO
                DNucleo.ModuloAddSolicitacao(TTConexao(VP_AContext.Data).ID,VP_Transmissao_ID,'',VL_TempoEmperaComandao,VL_Bin.ModuloConfID,VP_Mensagem,cnCaixa);

            finally
                VL_Consulta.Close;
                VL_Consulta.Free;
            end;
            Exit;
        end;

        VP_Mensagem.AddComando('000A', 'R');
        VP_Mensagem.AddTag('004D', 80);
        DComunicador.ServidorTransmiteSolicitacao(VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID, VP_Mensagem, VP_Mensagem, VP_AContext);

    finally
        VL_Transacao.Free;
    end;
end;

procedure ModuloCaixaRetorno(VP_Transmissao_ID: PChar; VP_Tarefa_ID, VP_ModuloProcID, VP_Codigo: integer; VP_Dados: PChar); stdcall;
var
    VL_Mensagem: TMensagem;
    VL_Tarefa:^TTarefa;
    VL_I:Integer;
    VL_RegModulo:TRegModulo;
begin
    try
    VL_Mensagem:=TMensagem.Create;
    VL_RegModulo:= TRegModulo(DNucleo.ModuloGetReg(VP_ModuloProcID));
    VL_Tarefa:=nil;

    for VL_I:=0 to VL_RegModulo.ThModulo.V_ListaTarefas.Count -1 do
    begin
        VL_Tarefa:=VL_RegModulo.ThModulo.V_ListaTarefas[VL_I];
        if VL_Tarefa^.VF_ID=VP_Tarefa_ID then
        Break;
    end;
    VL_Mensagem.CarregaTags(VP_Dados);
    if Assigned(VL_Tarefa) then
    DComunicador.ServidorTransmiteSolicitacaoID(3000,False,nil,VL_Tarefa^.VF_SocketTransmissaoID,VL_Mensagem,VL_Mensagem,VL_Tarefa^.VF_SocketID);

    finally
    VL_Mensagem.Free;
    end;

end;

procedure ModuloServicoRetorno(VP_Transmissao_ID: PChar; VP_Tarefa_ID, VP_ModuloProcID, VP_Codigo: integer; VP_Dados: PChar); stdcall;
var
    VL_Mensagem: TMensagem;
    VL_Erro: integer;
begin
    GravaLog(F_ArquivoLog, 0, '', 'opentef', '210520222110Servico', VP_Dados, '', VP_Codigo);

    if VP_Codigo <> 0 then
    begin
        EXIT;
    end;
    try
        VL_Mensagem := TMensagem.Create;

        VL_Erro := VL_Mensagem.CarregaTags(VP_Dados);
        if VL_Erro <> 0 then
        begin
            Exit;
        end;

        if (VL_Mensagem.Comando() = '00CD') and (VL_Mensagem.ComandoDados() = 'R') then //ATUALIZA BINS
        begin

            // COMANDO PRA ATUALIZAR TABELA DE BINS

            VL_Erro := DNucleo.AtualizaBIN(DNucleo.ModuloGetReg(VP_ModuloProcID), VL_Mensagem);
            if VL_Erro <> 0 then
            begin
                VL_Mensagem.AddComando('00CD', 'R');
                VL_Mensagem.AddTag('004D', VL_Erro);
                DNucleo.ModuloAddSolicitacao(VP_Transmissao_ID, 60000, VP_ModuloProcID, VL_Mensagem);

            end;

        end;

        if (VL_Mensagem.Comando() = '00CF') and (VL_Mensagem.ComandoDados() = 'R') then //ATUALIZA MENUS
        begin

            // COMANDO PRA ATUALIZAR MENUS

            VL_Erro := DNucleo.AtualizaMenu(DNucleo.ModuloGetReg(VP_ModuloProcID), VL_Mensagem);
            if VL_Erro <> 0 then
            begin
                VL_Mensagem.AddComando('00CF', 'R');
                VL_Mensagem.AddTag('004D', VL_Erro);
                DNucleo.ModuloAddSolicitacao(VP_Transmissao_ID, 60000, VP_ModuloProcID, VL_Mensagem);

            end;

        end;

        if (VL_Mensagem.Comando() = '00D4') and (VL_Mensagem.ComandoDados() = 'R') then //ATUALIZA MENUS OPERACIONAL
        begin

            // COMANDO PRA ATUALIZAR MENUS OPERACIONAL

            VL_Erro := DNucleo.AtualizaMENU_OPERACIONAL(DNucleo.ModuloGetReg(VP_ModuloProcID), VL_Mensagem);
            if VL_Erro <> 0 then
            begin
                VL_Mensagem.AddComando('00D4', 'R');
                VL_Mensagem.AddTag('004D', VL_Erro);
                DNucleo.ModuloAddSolicitacao(VP_Transmissao_ID, 60000, VP_ModuloProcID, VL_Mensagem);

            end;

        end;

        if VP_Tarefa_ID <> 0 then    // chegou um retorno para uma tarefa
        begin
            // verifica se o modulo que esta mandando é o mesmo que o open tef iniciou
            //            if VP_Tarefa_ID;
        end;


    finally
        VL_Mensagem.Free;
    end;

end;



{$R *.lfm}

end.
