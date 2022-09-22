unit opentefnucleo;

{$mode ObjFPC}{$H+}

interface

uses

    {$IFDEF UNIX}
      CThreads,
    {$ENDIF}
    Classes, SysUtils, IniFiles, comunicador, ZConnection, ZDataset, funcoes, rxmemds, IdContext, cadastro, LbClass;

type


    TMenuCompativel = function(VP_Modulo: Pointer; VP_Menu: PChar; var VO_Compativel: boolean): integer; cdecl;
    TGetFuncao = function(VP_Modulo: Pointer; VP_TagFuncao: PChar; var VO_Implementada: boolean): integer; cdecl;
    TLogin = function(VP_Modulo: Pointer; VP_Host: PChar; VP_Porta: integer; VP_ChaveTerminal, VP_TipoConexao: PChar): integer; cdecl;
    TFinalizar = function(VP_Modulo: Pointer): integer; cdecl;
    TModuloInicializar = function(VP_ModuloProcID: integer; var VO_Modulo: Pointer; VP_Recebimento: TRetornoModulo;
        VP_Modulo_ID: integer; VP_ArquivoLog: PChar): integer; cdecl;
    TSolicitacao = function(VP_Modulo: Pointer; VP_Transmissao_ID, VP_Dados: PChar; VP_Procedimento: TRetornoModulo;
        VP_Tarefa_ID, VP_TempoAguarda: integer): integer; cdecl;
    TSolicitacaoblocante = function(VP_Modulo: Pointer; VP_Transmissao_ID, VP_Dados: PChar; var VO_Retorno: PChar; VP_TempoAguarda: integer): integer; cdecl;
    TModuloStatus = function(VP_Modulo: Pointer; var VO_Versao: PChar; var VO_VersaoMensagem: integer; var VO_StatusRetorno: integer): integer; cdecl;




    TTarefa = record
        VF_ID: integer;
        VF_TipoConexao: TConexaoTipo;
        VF_ModuloConfig_ID: integer;
        VF_TempoEspera: integer;
        VF_ConexaoID: integer;
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
        VF_ConexaoTipo: TConexaoTipo;
        VF_ArquivoLog: string;
        VF_DNucleo: Pointer;
        VF_RegModulo: Pointer;
    protected
        procedure Execute; override;
    public
        V_ListaTarefas: TList;
        VF_Sair: boolean;
        constructor Create(VP_Suspenso: boolean; VP_RegModulo: Pointer; VP_ConexaoTipo: TConexaoTipo; VP_ArquivoLog: string; VP_DNucleo: Pointer);
        destructor Destroy; override;
    end;

    { TThTransacao }

    TThTransacao = class(TThread)
    private
    protected
        procedure Execute; override;
    public
        V_Mensagem: TMensagem;
        V_Conexao_ID: integer;
        V_TransmissaoID: string;
        V_Terminal_Tipo: string;
        V_Terminal_ID: integer;
        V_Doc: string;
        constructor Create(VP_Suspenso: boolean; VP_Trasmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer;
            VP_Terminal_Tipo: string; VP_Terminal_ID: integer; VP_Doc: string);
        destructor Destroy; override;
    end;


    { TRegModulos }

    TRegModulo = record
        ModuloProcID: integer;
        Tag: string;
        Handle: TLibHandle;
        PModulo: Pointer;
        Biblioteca: string;
        ModuloConfig_ID: integer;
        ConexaoTipo: TConexaoTipo;
        Adquirente_Identificacao: string;
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
        ModuloTag: string;
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
        function RetornaMenu(VP_Tag: ansistring; var VO_Menu: TRecMenu): integer;


    end;




    { TDNucleo }
    TDNucleo = class(TDataModule)
        CriptoAes: TLbRijndael;
        ZConexao: TZConnection;
        ZConsulta: TZQuery;
        procedure DataModuleCreate(Sender: TObject);
        procedure DataModuleDestroy(Sender: TObject);
    private
        function comando0001(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer): integer; // PEDIDO DE LOGIN
        function comando0021(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer): integer; // PEDIDO DE CONEXAO
        function comando000A(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer; VP_Terminal_Status: TConexaoStatus;
            VP_Terminal_ID: integer; VP_Terminal_Tipo, VP_Doc, VP_Terminal_Identificacao: string): integer;
        // PEDE APROVACAO DA TRANSACAO E CRIA CHAVE
        function comando0018(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer; VP_Terminal_Status: TConexaoStatus;
            VP_Terminal_ID: integer): integer; // SOLICITA MENU DE VENDA
        function comando00F5(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer; VP_Terminal_Status: TConexaoStatus;
            VP_Terminal_ID: integer): integer; // SOLICITA MENU OPERACIONAl
        function comando007A(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer; VP_Terminal_Tipo: string;
            VP_Terminal_ID: integer; VP_Doc: string): integer; // CRIA TRANSACAO PARA APROVACAO
        function comando00F4(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer; VP_Terminal_Status: TConexaoStatus;
            VP_Terminal_Tipo: string; VP_Terminal_ID: integer; VP_Doc, VP_Terminal_Identificacao: string): integer; // SOLICITA PARA MODULO
        function comando0105(VP_Transmissao_ID: string; VP_Tarefa_ID, VP_ModuloProID, VP_ModuloConfigID, VP_Erro: integer;
            VP_Modulo_Tag, VP_Dados: string): integer;  // SOLICITA PARA TERMINAIS
        function comando0111(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer): integer; // SOLICITA CHAVE PUBLICA
    public
        VF_Bin: TBin;
        VF_Menu: TMenu;
        VF_MenuOperacional: TMenu;
        procedure iniciar;
        procedure parar;
        function comando(VP_Erro: integer; VP_Transmissao_ID, VP_DadosRecebidos: string; VP_Conexao_ID: integer;
            VP_Terminal_Tipo: string; VP_Terminal_ID: integer; VP_DOC: string; VP_Terminal_Status: TConexaoStatus;
            VP_Terminal_Identificacao: string; VP_Permissao: TPermissao; VP_ClienteIP: string): integer;
        function ModuloCarrega(VP_ModuloConfig_ID: integer): integer;
        function ModuloDescarrega(VP_ModuloConfig_ID: integer): integer;
        function ModuloAddSolicitacao(VP_ConexaoID: integer; VP_Transmissao_ID: string; VP_TempoEspera: int64;
            VP_ModuloConfig_ID: integer; VP_Mensagem: TMensagem; VP_ConexaoTipo: TConexaoTipo): integer;
        function ModuloAddSolicitacao(VP_Transmissao_ID: string; VP_TempoEspera, VP_ModuloProcID: integer; VP_Mensagem: TMensagem): integer;
        function ModuloAddSolicitacaoIdentificacaoAdquirente(VP_ConexaoID: integer; VP_Transmissao_ID: string;
            VP_TempoEspera: int64; VP_Adquirente_Identificacao: string; VP_Mensagem: TMensagem; VP_ConexaoTipo: TConexaoTipo): integer;
        function ModuloTarefaDel(VP_ModuloProcID, VP_Tarefa_ID: integer): integer;
        function ModuloTarefaGet(VP_ModuloProcID, VP_Tarefa_ID: integer): TTarefa;
        function ModuloGetReg(VP_ModuloProc_ID: integer): Pointer;
        function ModuloGetRegAdquirencia(VP_AdquirenciaIdentificacao, VP_Tag: string): TRegModulo;
        function AtualizaBIN(VP_RegModulo: TRegModulo; VP_Mensagem: TMensagem): integer;
        function AtualizaMENU(VP_RegModulo: TRegModulo; VP_Mensagem: TMensagem; VP_Sistema: boolean): integer;
        function AtualizaMENU_OPERACIONAL(VP_RegModulo: TRegModulo; VP_Mensagem: TMensagem; VP_Sistema: boolean): integer;


    var
        VF_ListaTRegModulo: TList;



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

    {$IFDEF LINUX}
    const
      C_Lib= '.so';
    {$ENDIF LINUX}


procedure ModuloServicoRetorno(VP_Transmissao_ID: PChar; VP_Tarefa_ID, VP_ModuloProcID, VP_Erro: integer; VP_Dados: PChar; VP_Modulo: Pointer);
    cdecl; // QUANDO VEM DIRETO PARA OPEN TEF PELO MODULO (operadora)
procedure ModuloCaixaRetorno(VP_Transmissao_ID: PChar; VP_Tarefa_ID, VP_ModuloProcID, VP_Erro: integer; VP_Dados: PChar; VP_Modulo: Pointer);
    cdecl;   // QUANDO VEM DIRETO PARA OPEN TEF PELO MODULO (operadora)

procedure ServidorRecebimento(VP_Erro: integer; VP_Transmissao_ID, VP_DadosRecebidos: string; VP_Conexao_ID: integer;
    VP_Terminal_Tipo: string; VP_Terminal_ID: integer; VP_DOC: string; VP_Terminal_Status: TConexaoStatus; VP_Terminal_Identificacao: string;
    VP_Permissao: TPermissao; VP_ClienteIP: string);
// QUANDO VEM DIRETO PARA OPEN TEF (pdv)

implementation

uses
    def;

procedure ModuloCaixaRetorno(VP_Transmissao_ID: PChar; VP_Tarefa_ID, VP_ModuloProcID, VP_Erro: integer; VP_Dados: PChar; VP_Modulo: Pointer); cdecl;
var
    VL_Mensagem: TMensagem;
    VL_Tarefa: ^TTarefa;
    VL_I: integer;
    VL_PRegModulo: ^TRegModulo;
    VL_String: string;
    VL_Erro: integer;
begin
    try
        try

            VL_Mensagem := TMensagem.Create;
            VL_PRegModulo := DNucleo.ModuloGetReg(VP_ModuloProcID);
            VL_Tarefa := nil;

            for VL_I := 0 to VL_PRegModulo^.ThModulo.V_ListaTarefas.Count - 1 do
            begin
                VL_Tarefa := VL_PRegModulo^.ThModulo.V_ListaTarefas[VL_I];
                if VL_Tarefa^.VF_ID = VP_Tarefa_ID then
                    Break
                else
                    VL_Tarefa := nil;
            end;

            VL_Erro := VL_Mensagem.CarregaTags(VP_Dados);
            if VL_Erro <> 0 then
            begin
                GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '090920221453', 'Erro no ModuloCaixaRetorno', '', VL_Erro);
                Exit;
            end;

            VL_Mensagem.AddTag('00F8', 'F');  //  MENSAGEM VINDA DE FORA DO OPEN TEF

            if (VL_Mensagem.Comando() = '0111') and (VL_Mensagem.ComandoDados() = 'R') then // RETORNO CHAVE PUBLICA
            begin

                // COMANDO PRA SER EXECUTADO NO PDV

                VL_Mensagem.AddTag('00F8', 'F');  //  MENSAGEM VINDA DE FORA DO OPEN TEF

                VL_String := VL_Mensagem.TagsAsString;

                VL_Erro := VL_PRegModulo^.Solicitacao(VL_PRegModulo^.PModulo, PChar(VP_Transmissao_ID), PChar(VL_String),
                    nil, VP_Tarefa_ID, 30000);
                if VL_Erro <> 0 then
                begin
                    VL_Mensagem.AddComando('0026', IntToStr(VL_Erro)); // retorno com erro
                    GravaLog(F_ArquivoLog, 0, '', 'opentef', '020920220945Caixa', VP_Dados, '', VL_Erro);
                    DNucleo.ModuloAddSolicitacao(VP_Transmissao_ID, 60000, VP_ModuloProcID, VL_Mensagem);
                    Exit;
                end;
                Exit;
            end;


            if (VL_Mensagem.Comando() = '0111') and (VL_Mensagem.ComandoDados() = 'S') then // COMANDO PARA PEGAR CHAVE PUBLICA
            begin

                // COMANDO PRA SER EXECUTADO NO PDV

                VL_Mensagem.AddTag('00F8', 'F');  //  MENSAGEM VINDA DE FORA DO OPEN TEF

                VL_String := VL_Mensagem.TagsAsString;

                VL_Erro := DNucleo.comando0105(VP_Transmissao_ID, VP_Tarefa_ID, VP_ModuloProcID, VL_PRegModulo^.ModuloConfig_ID,
                    VP_Erro, VL_PRegModulo^.Tag, VL_String);
                if VL_Erro <> 0 then
                begin
                    VL_Mensagem.AddComando('0026', IntToStr(VL_Erro)); // retorno com erro
                    GravaLog(F_ArquivoLog, 0, '', 'opentef', '010920220931Caixa', VP_Dados, '', VL_Erro);
                    DNucleo.ModuloAddSolicitacao(VP_Transmissao_ID, 60000, VP_ModuloProcID, VL_Mensagem);
                end;
                Exit;
            end;

            if Assigned(VL_Tarefa) then
                DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, 3000, False, nil, VL_Tarefa^.VF_TransmissaoID, VL_Mensagem,
                    VL_Mensagem, VL_Tarefa^.VF_ConexaoID);

        finally
            VL_Mensagem.Free;

            if VP_Tarefa_ID <> 0 then
                DNucleo.ModuloTarefaDel(VP_ModuloProcID, VP_Tarefa_ID);

            if VP_Erro <> 0 then
            begin
                GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '090920221435', 'ModuloCaixaRetorno, recebeu comando com erro', '', VP_Erro);
                Exit;
            end;

        end;

    except
        on e: EInOutError do
            GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '120920220828', 'Erro no ModuloCaixaRetorno ' +
                e.ClassName + '/' + e.Message, '', VL_Erro);
    end;

end;



procedure ModuloServicoRetorno(VP_Transmissao_ID: PChar; VP_Tarefa_ID, VP_ModuloProcID, VP_Erro: integer; VP_Dados: PChar; VP_Modulo: Pointer); cdecl;
var
    VL_Mensagem: TMensagem;
    VL_Erro: integer;
    VL_String: string;
    VL_PRegModulo: ^TRegModulo;
begin

    VL_String := '';

    try
        VL_Mensagem := TMensagem.Create;
        VL_Mensagem.AddTag('00F8', 'F');

        VL_PRegModulo := DNucleo.ModuloGetReg(VP_ModuloProcID);

        VL_Erro := VL_Mensagem.CarregaTags(VP_Dados);
        if VL_Erro <> 0 then
        begin
            GravaLog(F_ArquivoLog, 0, '', 'opentef', '260820220900Servico', VP_Dados, '', VL_Erro);
            VL_Mensagem.AddComando('0026', IntToStr(VL_Erro)); // comando de erro
            DNucleo.ModuloAddSolicitacao(VP_Transmissao_ID, 60000, VP_ModuloProcID, VL_Mensagem);
            Exit;
        end;

        if (VL_Mensagem.Comando() = '00CD') and (VL_Mensagem.ComandoDados() = 'R') then //ATUALIZA BINS
        begin

            // COMANDO PRA ATUALIZAR TABELA DE BINS

            VL_Erro := DNucleo.AtualizaBIN(VL_PRegModulo^, VL_Mensagem);
            if VL_Erro <> 0 then
            begin
                VL_Mensagem.AddComando('0026', IntToStr(VL_Erro)); // comando de erro
                GravaLog(F_ArquivoLog, 0, '', 'opentef', '260820220910Servico', VP_Dados, '', VL_Erro);
                DNucleo.ModuloAddSolicitacao(VP_Transmissao_ID, 20000, VP_ModuloProcID, VL_Mensagem);
                Exit;
            end;

        end;

        if (VL_Mensagem.Comando() = '00CF') and (VL_Mensagem.ComandoDados() = 'R') then //ATUALIZA MENUS
        begin

            // COMANDO PRA ATUALIZAR MENUS

            VL_Erro := DNucleo.AtualizaMenu(VL_PRegModulo^, VL_Mensagem, False);
            if VL_Erro <> 0 then
            begin
                VL_Mensagem.AddComando('0026', IntToStr(VL_Erro)); // comando de erro
                GravaLog(F_ArquivoLog, 0, '', 'opentef', '260820220909Servico', VP_Dados, '', VL_Erro);
                DNucleo.ModuloAddSolicitacao(VP_Transmissao_ID, 60000, VP_ModuloProcID, VL_Mensagem);
                Exit;
            end;

        end;

        if (VL_Mensagem.Comando() = '00D4') and (VL_Mensagem.ComandoDados() = 'R') then //ATUALIZA MENUS OPERACIONAL
        begin

            // COMANDO PRA ATUALIZAR MENUS OPERACIONAL

            VL_Erro := DNucleo.AtualizaMENU_OPERACIONAL(VL_PRegModulo^, VL_Mensagem, False);
            if VL_Erro <> 0 then
            begin
                VL_Mensagem.AddComando('0026', IntToStr(VL_Erro)); // comando de erro
                GravaLog(F_ArquivoLog, 0, '', 'opentef', '260820220908Servico', VP_Dados, '', VL_Erro);
                DNucleo.ModuloAddSolicitacao(VP_Transmissao_ID, 60000, VP_ModuloProcID, VL_Mensagem);
                Exit;
            end;

        end;

        if (VL_Mensagem.Comando() = '0105') and (VL_Mensagem.ComandoDados() = 'S') then // COMANDO PARA SER EXECUTADO NO PDV
        begin

            // COMANDO PRA SER EXECUTADO NO PDV

            VL_Mensagem.AddTag('00F8', 'F');  //  MENSAGEM VINDA DE FORA DO OPEN TEF

            VL_String := VL_Mensagem.TagsAsString;

            VL_Erro := DNucleo.comando0105(VP_Transmissao_ID, VP_Tarefa_ID, VP_ModuloProcID, VL_PRegModulo^.ModuloConfig_ID,
                VP_Erro, VL_PRegModulo^.Tag, VL_String);
            if VL_Erro <> 0 then
            begin
                VL_Mensagem.AddComando('0026', IntToStr(VL_Erro)); // comando de erro
                GravaLog(F_ArquivoLog, 0, '', 'opentef', '260820220907Servico', VP_Dados, '', VL_Erro);
                DNucleo.ModuloAddSolicitacao(VP_Transmissao_ID, 60000, VP_ModuloProcID, VL_Mensagem);
                Exit;
            end;

        end;

        if (VL_Mensagem.Comando() = '0111') and (VL_Mensagem.ComandoDados() = 'S') then // COMANDO PARA PEGAR CHAVE PUBLICA
        begin

            // COMANDO PRA SER EXECUTADO NO PDV

            VL_Mensagem.AddTag('00F8', 'F');  //  MENSAGEM VINDA DE FORA DO OPEN TEF

            VL_String := VL_Mensagem.TagsAsString;

            VL_Erro := DNucleo.comando0105(VP_Transmissao_ID, VP_Tarefa_ID, VP_ModuloProcID, VL_PRegModulo^.ModuloConfig_ID,
                VP_Erro, VL_PRegModulo^.Tag, VL_String);

            if VL_Erro <> 0 then
            begin
                VL_Mensagem.AddComando('0026', IntToStr(VL_Erro)); // comando de erro
                GravaLog(F_ArquivoLog, 0, '', 'opentef', '010920220930Servico', VP_Dados, '', VL_Erro);
                DNucleo.ModuloAddSolicitacao(VP_Transmissao_ID, 60000, VP_ModuloProcID, VL_Mensagem);
                Exit;
            end;

        end;


    finally
        VL_Mensagem.Free;
        if VP_Tarefa_ID <> 0 then
            DNucleo.ModuloTarefaDel(VP_ModuloProcID, VP_Tarefa_ID);

        if VP_Erro <> 0 then
        begin
            GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '090920220915', 'ModuloServicoRetorno, recebeu comando com erro', '', VP_Erro);
            Exit;
        end;

    end;
end;


procedure TThModulo.Execute;
var
    VL_Erro: integer;
    VL_DadosInteger: integer;
    VL_ConexaoStatus: TConexaoStatus;
    VL_VersaoModulo: PChar;
    VL_VersaoMensagem: integer;
    VL_Mensagem: TMensagem;
    VL_Tarefa: ^TTarefa;
    VL_I: integer;
    VL_TipoConexao: PChar;

begin
    VF_Rodando := True;
    TRegModulo(VF_RegModulo^).PModulo := nil;
    VL_Tarefa := nil;
    VL_DadosInteger := 0;
    VL_VersaoModulo := '';
    VL_VersaoMensagem := 0;
    if VF_ConexaoTipo = cnCaixa then
        VL_TipoConexao := 'C'
    else
        VL_TipoConexao := 'S';
    try
        try
            while not Terminated do
            begin

                if VF_Sair then
                    Exit;

                if VF_LibCarregada = False then
                begin
                    {$IFDEF UNIX}
                    TRegModulo(VF_RegModulo^).Handle := LoadLibrary(PChar(ExtractFilePath(ParamStr(0)) + 'modulo/' + TRegModulo(VF_RegModulo^).Biblioteca));
                    {$ELSE}
                    TRegModulo(VF_RegModulo^).Handle := LoadLibrary(PChar(ExtractFilePath(ParamStr(0)) + 'modulo\' + TRegModulo(VF_RegModulo^).Biblioteca));
                    {$ENDIF}
                    if TRegModulo(VF_RegModulo^).Handle = 0 then
                    begin
                        GravaLog(VF_ArquivoLog, TRegModulo(VF_RegModulo^).ModuloConfig_ID, TRegModulo(VF_RegModulo^).Tag, 'opentefnucleo',
                            '12082022143300', 'Erro ao tentar carregar a dll:' + TRegModulo(VF_RegModulo^).Biblioteca, '', 0);
                        Exit;
                    end;
                    Pointer(TRegModulo(VF_RegModulo^).Login) := GetProcAddress(TRegModulo(VF_RegModulo^).Handle, 'login');
                    Pointer(TRegModulo(VF_RegModulo^).Finalizar) := GetProcAddress(TRegModulo(VF_RegModulo^).Handle, 'finalizar');
                    Pointer(TRegModulo(VF_RegModulo^).Inicializar) := GetProcAddress(TRegModulo(VF_RegModulo^).Handle, 'inicializar');
                    Pointer(TRegModulo(VF_RegModulo^).Solicitacao) := GetProcAddress(TRegModulo(VF_RegModulo^).Handle, 'solicitacao');
                    Pointer(TRegModulo(VF_RegModulo^).Solicitacaoblocante) := GetProcAddress(TRegModulo(VF_RegModulo^).Handle, 'solicitacaoblocante');
                    Pointer(TRegModulo(VF_RegModulo^).ModuloStatus) := GetProcAddress(TRegModulo(VF_RegModulo^).Handle, 'modulostatus');


                    GravaLog(VF_ArquivoLog, TRegModulo(VF_RegModulo^).ModuloConfig_ID, TRegModulo(VF_RegModulo^).Tag, 'opentefnucleo',
                        '12082022154300', 'Carregando funções da dll' + TRegModulo(VF_RegModulo^).Biblioteca, '', 0, C_Debug);

                    if VF_Sair then
                        Exit;


                    if VF_ConexaoTipo = cnCaixa then
                        VL_Erro := TRegModulo(VF_RegModulo^).Inicializar(TRegModulo(VF_RegModulo^).ModuloProcID,
                            TRegModulo(VF_RegModulo^).PModulo, @ModuloCaixaRetorno, TRegModulo(VF_RegModulo^).ModuloConfig_ID,
                            PChar(VF_ArquivoLog))
                    else
                        VL_Erro := TRegModulo(VF_RegModulo^).Inicializar(TRegModulo(VF_RegModulo^).ModuloProcID,
                            TRegModulo(VF_RegModulo^).PModulo, @ModuloServicoRetorno, TRegModulo(VF_RegModulo^).ModuloConfig_ID, PChar(VF_ArquivoLog));

                    GravaLog(VF_ArquivoLog, TRegModulo(VF_RegModulo^).ModuloConfig_ID, TRegModulo(VF_RegModulo^).Tag, 'opentefnucleo',
                        '12082022154301', 'Iniciando Mudulo' + TRegModulo(VF_RegModulo^).Biblioteca, '', 0, C_Debug);


                    if VL_Erro <> 0 then
                    begin
                        GravaLog(VF_ArquivoLog, TRegModulo(VF_RegModulo^).ModuloConfig_ID, TRegModulo(VF_RegModulo^).Tag, 'opentefnucleo',
                            '030520221138', 'Erro ao tentar inicializar a dll:' + TRegModulo(VF_RegModulo^).Biblioteca, '', VL_Erro);
                        Exit;
                    end;
                    VF_LibCarregada := True;
                    if (VF_ConexaoTipo = cnServico) then
                        DNucleo.AtualizaBIN(TRegModulo(VF_RegModulo^), nil);
                end
                else
                begin

                    if VF_Sair then
                        Exit;

                    // pega o status da conexao
                    VL_Erro := TRegModulo(VF_RegModulo^).ModuloStatus(TRegModulo(VF_RegModulo^).PModulo, VL_VersaoModulo, VL_VersaoMensagem, VL_DadosInteger);
                    if VL_Erro <> 0 then
                    begin
                        GravaLog(VF_ArquivoLog, TRegModulo(VF_RegModulo^).ModuloConfig_ID, TRegModulo(VF_RegModulo^).Tag, 'opentefnucleo',
                            '030520221503', 'Erro ao tentar pegar status da conexao ' + ConexaoTipoToStr(VF_ConexaoTipo) + ' da dll:' +
                            TRegModulo(VF_RegModulo^).Biblioteca, '', VL_Erro);
                        Exit;
                    end;
                    VL_ConexaoStatus := IntToConexaoStatus(VL_DadosInteger);

                    if VL_ConexaoStatus <> csLogado then
                    begin
                        VL_Erro := TRegModulo(VF_RegModulo^).Login(TRegModulo(VF_RegModulo^).PModulo, PChar(TRegModulo(VF_RegModulo^).Host),
                            TRegModulo(VF_RegModulo^).Porta,
                            PChar(TRegModulo(VF_RegModulo^).Chave), VL_TipoConexao);
                        if VL_Erro <> 0 then
                            GravaLog(VF_ArquivoLog, TRegModulo(VF_RegModulo^).ModuloConfig_ID, TRegModulo(VF_RegModulo^).Tag, 'opentefnucleo',
                                '030520221540', 'Erro ao tentar logar da conexao ' + ConexaoTipoToStr(VF_ConexaoTipo) + ' da dll:' +
                                TRegModulo(VF_RegModulo^).Biblioteca, '', VL_Erro)
                        else
                        begin
                            VL_Erro := TRegModulo(VF_RegModulo^).ModuloStatus(TRegModulo(VF_RegModulo^).PModulo, VL_VersaoModulo,
                                VL_VersaoMensagem, VL_DadosInteger);
                            VL_ConexaoStatus := IntToConexaoStatus(VL_DadosInteger);
                        end;

                        if VF_Sair then
                            Exit;


                        if (VL_ConexaoStatus = csLogado) and (VF_ConexaoTipo = cnServico) and (TRegModulo(VF_RegModulo^).Menu_estatico = False) then
                        begin
                            // atualiza MENUS

                            VL_Mensagem := TMensagem.Create;
                            try
                                VL_Mensagem.AddComando('00CF', 'S'); //SOLICITA MENU VENDA
                                TRegModulo(VF_RegModulo^).Solicitacao(TRegModulo(VF_RegModulo^).PModulo, PChar(''),
                                    PChar(VL_Mensagem.TagsAsString), @ModuloServicoRetorno, 0, 60000);


                            finally
                                VL_Mensagem.Free;
                            end;

                        end;

                        if (VL_ConexaoStatus = csLogado) and (VF_ConexaoTipo = cnServico) and
                            (TRegModulo(VF_RegModulo^).Menu_Operacional_estatico = False) then
                        begin
                            // atualiza MENUS  OPERACIONAL

                            VL_Mensagem := TMensagem.Create;
                            try

                                VL_Mensagem.AddComando('00D4', 'S'); //SOLICITA MENU OPERACIONAL
                                TRegModulo(VF_RegModulo^).Solicitacao(TRegModulo(VF_RegModulo^).PModulo, PChar(''),
                                    PChar(VL_Mensagem.TagsAsString), @ModuloServicoRetorno, 0, 60000);



                            finally
                                VL_Mensagem.Free;
                            end;

                        end;


                        if VF_Sair then
                            Exit;


                        if (VL_ConexaoStatus = csLogado) and (VF_ConexaoTipo = cnServico) and (TRegModulo(VF_RegModulo^).Menu_estatico = False) then
                        begin
                            // atualiza BINS

                            VL_Mensagem := TMensagem.Create;
                            try
                                VL_Mensagem.AddComando('00CD', 'S'); //SOLICITA BINS
                                TRegModulo(VF_RegModulo^).Solicitacao(TRegModulo(VF_RegModulo^).PModulo, PChar(''),
                                    PChar(VL_Mensagem.TagsAsString), @ModuloServicoRetorno, 0, 60000);



                            finally
                                VL_Mensagem.Free;
                            end;

                        end;

                    end;

                    // inicia as tratativas das solicitações
                    if VL_ConexaoStatus = csLogado then
                    begin

                        if VF_Sair then
                            Exit;

                        for VL_I := 0 to V_ListaTarefas.Count - 1 do
                        begin
                            if VF_Sair then
                                Exit;


                            VL_Tarefa := V_ListaTarefas[VL_I];

                            if VL_Tarefa^.VF_Tratando = False then
                            begin
                                VL_Tarefa^.VF_Tratando := True;
                                if VF_ConexaoTipo = cnCaixa then
                                    VL_Erro := TRegModulo(VF_RegModulo^).Solicitacao(TRegModulo(VF_RegModulo^).PModulo, PChar(VL_Tarefa^.VF_TransmissaoID),
                                        PChar(VL_Tarefa^.VF_Mensagem), @ModuloCaixaRetorno, VL_Tarefa^.VF_ID, VL_Tarefa^.VF_TempoEspera)
                                else
                                    VL_Erro := TRegModulo(VF_RegModulo^).Solicitacao(TRegModulo(VF_RegModulo^).PModulo, PChar(VL_Tarefa^.VF_TransmissaoID),
                                        PChar(VL_Tarefa^.VF_Mensagem), @ModuloServicoRetorno, VL_Tarefa^.VF_ID, VL_Tarefa^.VF_TempoEspera);

                            end;
                        end;

                        for VL_I := 0 to V_ListaTarefas.Count - 1 do
                        begin

                            if VF_Sair then
                                Exit;


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
        except
            on e: EInOutError do
                GravaLog(F_ArquivoLog, TRegModulo(VF_RegModulo^).ModuloConfig_ID, '', 'opentefnucleo', '200520220934', 'Erro na TThModulo.Execute ' +
                    e.ClassName + '/' + e.Message, '', VL_Erro);
        end;
    finally
        try
            if VF_LibCarregada then
            begin
                TRegModulo(VF_RegModulo^).Finalizar(TRegModulo(VF_RegModulo^).PModulo);
                UnloadLibrary(TRegModulo(VF_RegModulo^).Handle);
                TRegModulo(VF_RegModulo^).PModulo := nil;
            end;
            VF_Rodando := False;
        except
            on e: EInOutError do
                GravaLog(F_ArquivoLog, TRegModulo(VF_RegModulo^).ModuloConfig_ID, '', 'opentefnucleo', '290820222000', 'Erro na TThModulo.Execute ' +
                    e.ClassName + '/' + e.Message, '', VL_Erro);

        end;
    end;
end;



procedure TDNucleo.iniciar;
var
    VL_RegModulo: TRegModulo;
begin
    try

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '202211081230', 'TDNucleo.iniciar Iniciando...', '', 0, C_Debug);


        VL_RegModulo.Menu_Operacional_estatico := True;
        VL_RegModulo.Menu_estatico := True;
        VL_RegModulo.ModuloConfig_ID := 0;

    {$IFDEF DEBUG}
    {$IFDEF UNIX}
//    ZConexao.LibraryLocation := ExtractFilePath(ParamStr(0)) + 'firebird/libfbclient.so';
    ZConexao.Database := ExtractFilePath(ParamStr(0)) + 'OPENTEF.FDB';
    {$ELSE}
    ZConexao.Database := ExtractFilePath(ParamStr(0)) + 'opentef.fdb';
    ZConexao.HostName:='localhost';
    ZConexao.Port:=25050;
    ZConexao.Password:='2844';
    {$ENDIF UNIX}
    {$ELSE}
    {$IFDEF UNIX}
//    ZConexao.LibraryLocation := ExtractFilePath(ParamStr(0)) + 'firebird/libfbclient.so';
    ZConexao.Database := ExtractFilePath(ParamStr(0)) + 'OPENTEF.FDB';
    {$ELSE}
        ZConexao.LibraryLocation := ExtractFilePath(ParamStr(0)) + 'firebird\fbclient.dll';
        ZConexao.Database := ExtractFilePath(ParamStr(0)) + 'opentef.fdb';
    {$ENDIF UNIX}


    {$ENDIF DEBUG}

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '2022110812319', 'TDNucleo.iniciar ' +
            'TentandoConectandoBanco LIB:' + ZConexao.LibraryLocation + ' banco:' + ZConexao.Database, '', 0, C_Debug);


        ZConexao.Connect;

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '2022110812316', 'TDNucleo.iniciar ' +
            'ConectandoBanco...', '', 0, C_Debug);



        DComunicador := TDComunicador.Create(Self);
        DComunicador.V_ArquivoLog := F_ArquivoLog;
        DComunicador.V_ServidorRecebimento := @ServidorRecebimento;


        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '2022110812317', 'TDNucleo.iniciar ' +
            'ConectadoBanco...', '', 0, C_Debug);



        if not FileExists(ExtractFilePath(ParamStr(0)) + 'open_tef.ini') then
        begin
            Conf := TIniFile.Create(PChar(ExtractFilePath(ParamStr(0)) + 'open_tef.ini'));
            Conf.WriteInteger('Servidor', 'Porta', 0);
            Conf.WriteBool('Servidor', 'Ativa', True);
            Conf.WriteBool('Servidor', 'Debug', False);
            Conf.Free;
        end;

        Conf := TIniFile.Create(PChar(ExtractFilePath(ParamStr(0)) + 'open_tef.ini'));

        if Conf.ReadInteger('Servidor', 'Porta', 0) <> 0 then
        begin
            DComunicador.IdTCPServidor.DefaultPort := Conf.ReadInteger('Servidor', 'Porta', 0);
            DComunicador.IdTCPServidor.StartListening;
            DComunicador.IdTCPServidor.Active := Conf.ReadBool('Servidor', 'Ativa', False);

        end;

        C_Debug := Conf.ReadBool('Servidor', 'Debug', False);

        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '202211081230', 'TDNucleo.iniciar Iniciando...', '', 0, C_Debug);




        F_Modulo_ID_Contador := 0;
        F_Tarefa_ID_Contador := 0;
        AtualizaMENU_OPERACIONAL(VL_RegModulo, nil, True);
        AtualizaMENU(VL_RegModulo, nil, True);
        ModuloCarrega(0);

    except
        on e: EInOutError do
            GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '202211081229', 'TDNucleo.iniciar ' +
                e.ClassName + '/' + e.Message, '', 0);
    end;

end;

procedure TDNucleo.parar;
begin
    if not Assigned(DNucleo) then
        Exit;
    ModuloDescarrega(0);

    DComunicador.Free;
    DComunicador := nil;

    ZConexao.Disconnect;
    DNucleo.Free;
    DNucleo := nil;
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
        ' MC.MENU_ESTATICO_OPERACIONAL,M.TAG_NUMERO, A.IDENTIFICACAO' +
        ' FROM MODULO_CONF MC ' +
        ' INNER JOIN MODULO M ON M.ID=MC.MODULO_ID ' +
        ' INNER JOIN ADQUIRENTE A ON MC.ADQUIRENTE_ID=A.ID ' +
        ' WHERE MC.HABILITADO=''T'' AND ((MC.ID=' + IntToStr(VP_ModuloConfig_ID) + ') OR (0=' + IntToStr(VP_ModuloConfig_ID) + '))';
    ZConsulta.Open;
    while not ZConsulta.EOF do
    begin
        new(VL_RegModulo);
        VL_RegModulo^.ConexaoTipo := cnServico;
        VL_RegModulo^.ModuloProcID := F_Modulo_ID_Contador;
        VL_RegModulo^.Adquirente_Identificacao := ZConsulta.FieldByName('IDENTIFICACAO').AsString;
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
            ZConsulta.FieldByName('TAG_NUMERO').AsString + '_servico.txt'), DNucleo);
        VF_ListaTRegModulo.Add(VL_RegModulo);
        VL_RegModulo^.ThModulo.Start;

        F_Modulo_ID_Contador := F_Modulo_ID_Contador + 1;
        new(VL_RegModulo);
        VL_RegModulo^.ConexaoTipo := cnCaixa;
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
            ZConsulta.FieldByName('TAG_NUMERO').AsString + '_caixa.txt'), DNucleo);
        VF_ListaTRegModulo.Add(VL_RegModulo);
        VL_RegModulo^.ThModulo.Start;
        ZConsulta.Next;

    end;
    Result := 0;
end;



function TDNucleo.ModuloDescarrega(VP_ModuloConfig_ID: integer): integer;
var
    VL_I: integer;
    VL_RegModulo: ^TRegModulo;
begin
    Result := 0;
    DNucleo.VF_Bin.RemovePorModuloConf(VP_ModuloConfig_ID);
    if VP_ModuloConfig_ID = 0 then
    begin
        if Assigned(VF_ListaTRegModulo) then
        begin
            while VF_ListaTRegModulo.Count > 0 do
            begin
                if Assigned(VF_ListaTRegModulo.Items[0]) then
                begin
                    VL_RegModulo := VF_ListaTRegModulo.Items[0];
                    VL_RegModulo^.ThModulo.VF_Sair := True;
                    VL_RegModulo^.ThModulo.WaitFor;
                    VL_RegModulo^.ThModulo.Free;
                    Dispose(VL_RegModulo);
                end;
                VF_ListaTRegModulo.Delete(0);
            end;
        end;

    end
    else
    begin
        if Assigned(VF_ListaTRegModulo) then
        begin
            for VL_I := 0 to VF_ListaTRegModulo.Count - 1 do
            begin
                if Assigned(VF_ListaTRegModulo.Items[VL_I]) then
                begin
                    VL_RegModulo := VF_ListaTRegModulo.Items[VL_I];
                    if VL_RegModulo^.ModuloConfig_ID = VP_ModuloConfig_ID then
                    begin
                        VL_RegModulo^.ThModulo.VF_Sair := True;
                        VL_RegModulo^.ThModulo.WaitFor;
                        VL_RegModulo^.ThModulo.Free;
                        Dispose(VL_RegModulo);
                        VF_ListaTRegModulo.Delete(VL_I);
                        Break;
                    end;
                end;
            end;
        end;

        if Assigned(VF_ListaTRegModulo) then
        begin
            for VL_I := 0 to VF_ListaTRegModulo.Count - 1 do
            begin
                if Assigned(VF_ListaTRegModulo.Items[VL_I]) then
                begin
                    VL_RegModulo := VF_ListaTRegModulo.Items[VL_I];
                    if VL_RegModulo^.ModuloConfig_ID = VP_ModuloConfig_ID then
                    begin
                        VL_RegModulo^.ThModulo.VF_Sair := True;
                        VL_RegModulo^.ThModulo.WaitFor;
                        VL_RegModulo^.ThModulo.Free;
                        Dispose(VL_RegModulo);
                        VF_ListaTRegModulo.Delete(VL_I);
                        Break;
                    end;
                end;
            end;
        end;
    end;
end;

function TDNucleo.ModuloAddSolicitacao(VP_ConexaoID: integer; VP_Transmissao_ID: string; VP_TempoEspera: int64;
    VP_ModuloConfig_ID: integer; VP_Mensagem: TMensagem; VP_ConexaoTipo: TConexaoTipo): integer;
var
    VL_I: integer;
    VL_RegModulo: ^TRegModulo;
    VL_Tarefa: ^TTarefa;
begin
    Result := -1;
    VL_Tarefa := nil;
    for VL_I := 0 to VF_ListaTRegModulo.Count - 1 do
    begin
        VL_RegModulo := VF_ListaTRegModulo[VL_I];
        if ((VL_RegModulo^.ModuloConfig_ID = VP_ModuloConfig_ID) and
            (VL_RegModulo^.ConexaoTipo = VP_ConexaoTipo)) then
        begin
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
            VL_Tarefa^.VF_ConexaoID := VP_ConexaoID;
            VL_RegModulo^.ThModulo.V_ListaTarefas.Add(VL_Tarefa);
            Result := 0;
            Exit;
        end
        else
            Result := 70;
    end;

end;

function TDNucleo.ModuloAddSolicitacaoIdentificacaoAdquirente(VP_ConexaoID: integer; VP_Transmissao_ID: string;
    VP_TempoEspera: int64; VP_Adquirente_Identificacao: string; VP_Mensagem: TMensagem; VP_ConexaoTipo: TConexaoTipo): integer;
var
    VL_I: integer;
    VL_RegModulo: ^TRegModulo;
    VL_Tarefa: ^TTarefa;
begin
    Result := -1;
    VL_Tarefa := nil;
    for VL_I := 0 to VF_ListaTRegModulo.Count - 1 do
    begin
        VL_RegModulo := VF_ListaTRegModulo.Items[VL_I];
        if ((VL_RegModulo^.Adquirente_Identificacao = VP_Adquirente_Identificacao) and
            (VL_RegModulo^.ConexaoTipo = VP_ConexaoTipo)) then
        begin
            new(VL_Tarefa);
            F_Tarefa_ID_Contador := F_Tarefa_ID_Contador + 1;
            VL_Tarefa^.VF_ID := F_Tarefa_ID_Contador;
            VL_Tarefa^.VF_TipoConexao := VP_ConexaoTipo;
            VL_Tarefa^.VF_Tratando := False;
            VL_Tarefa^.VF_DataCriacao := now;
            VL_Tarefa^.VF_Mensagem := VP_Mensagem.TagsAsString;
            VL_Tarefa^.VF_TempoEspera := VP_TempoEspera;
            VL_Tarefa^.VF_TransmissaoID := VP_Transmissao_ID;
            VL_Tarefa^.VF_ConexaoID := VP_ConexaoID;

            VL_RegModulo^.ThModulo.V_ListaTarefas.Add(VL_Tarefa);
            Result := 0;
            Exit;
        end
        else
            Result := 1;
    end;

end;

function TDNucleo.ModuloTarefaDel(VP_ModuloProcID, VP_Tarefa_ID: integer): integer;
var
    VL_I, VL_II: integer;
    VL_Tarefa: ^TTarefa;
    VL_RegModulo: ^TRegModulo;
begin
    Result := 97;

    if not Assigned(VF_ListaTRegModulo) then
        Exit;

    if VF_ListaTRegModulo.Count = 0 then
        Exit;

    for VL_I := 0 to VF_ListaTRegModulo.Count - 1 do
    begin
        if Assigned(VF_ListaTRegModulo.Items[VL_I]) then
        begin
            VL_RegModulo := VF_ListaTRegModulo.Items[VL_I];
            if (VL_RegModulo^.ModuloProcID = VP_ModuloProcID) then
            begin
                for VL_II := 0 to VL_RegModulo^.ThModulo.V_ListaTarefas.Count - 1 do
                begin
                    VL_Tarefa := VL_RegModulo^.ThModulo.V_ListaTarefas.Items[VL_II];
                    if VL_Tarefa^.VF_ID = VP_Tarefa_ID then
                    begin
                        VL_RegModulo^.ThModulo.V_ListaTarefas.Remove(VL_Tarefa);
                        Dispose(VL_Tarefa);
                        Result := 0;
                        Exit;
                    end;
                end;
            end;
        end;
    end;
end;

function TDNucleo.ModuloTarefaGet(VP_ModuloProcID, VP_Tarefa_ID: integer): TTarefa;
var
    VL_I, VL_II: integer;
    VL_RegModulo: ^TRegModulo;
    VL_Tarefa: ^TTarefa;
begin
    for VL_I := 0 to VF_ListaTRegModulo.Count - 1 do
    begin
        if Assigned(VF_ListaTRegModulo.Items[VL_I]) then
        begin
            VL_RegModulo := VF_ListaTRegModulo.Items[VL_I];
            if (VL_RegModulo^.ModuloProcID = VP_ModuloProcID) then
            begin
                for VL_II := 0 to VL_RegModulo^.ThModulo.V_ListaTarefas.Count - 1 do
                begin
                    VL_Tarefa := VL_RegModulo^.ThModulo.V_ListaTarefas.Items[VL_II];
                    if VL_Tarefa^.VF_ID = VP_Tarefa_ID then
                    begin
                        Result := VL_Tarefa^;
                        Exit;
                    end;
                end;
            end;
        end;
    end;
end;

function TDNucleo.ModuloAddSolicitacao(VP_Transmissao_ID: string; VP_TempoEspera, VP_ModuloProcID: integer; VP_Mensagem: TMensagem): integer;
var
    VL_I: integer;
    VL_RegModulo: ^TRegModulo;
    VL_Tarefa: ^TTarefa;
begin
    Result := -1;
    VL_Tarefa := nil;
    for VL_I := 0 to VF_ListaTRegModulo.Count - 1 do
    begin
        VL_RegModulo := VF_ListaTRegModulo.Items[VL_I];
        if (VL_RegModulo^.ModuloProcID = VP_ModuloProcID) then
        begin
            new(VL_Tarefa);
            F_Tarefa_ID_Contador := F_Tarefa_ID_Contador + 1;
            VL_Tarefa^.VF_ID := F_Tarefa_ID_Contador;
            VL_Tarefa^.VF_TipoConexao := VL_RegModulo^.ConexaoTipo;
            VL_Tarefa^.VF_ModuloConfig_ID := VL_RegModulo^.ModuloConfig_ID;
            VL_Tarefa^.VF_Tratando := False;
            VL_Tarefa^.VF_Tratando := False;
            VL_Tarefa^.VF_DataCriacao := now;
            VL_Tarefa^.VF_Mensagem := VP_Mensagem.TagsAsString;
            VL_Tarefa^.VF_TempoEspera := VP_TempoEspera;
            VL_Tarefa^.VF_TransmissaoID := VP_Transmissao_ID;
            VL_Tarefa^.VF_ConexaoID := 0;
            //            VL_Tarefa^.VF_SocketTransmissaoID := '';
            VL_RegModulo^.ThModulo.V_ListaTarefas.Add(VL_Tarefa);
        end
        else
            Result := 70;
    end;

end;


function TDNucleo.AtualizaBIN(VP_RegModulo: TRegModulo; VP_Mensagem: TMensagem): integer;
var
    VL_Consulta: TZQuery;
    VL_Bin: string;
    VL_Bins: TStringList;
    VL_ModuloConfID: integer;
    VL_I: integer;
begin
    Result := 0;

    if not Assigned(@VP_RegModulo) then
    begin
        Result := 64;
        Exit;
    end;

    if VP_RegModulo.ModuloConfig_ID < 1 then
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

        VF_Bin.RemovePorModuloConf(VP_RegModulo.ModuloConfig_ID);

        VL_Consulta.SQL.Text := 'SELECT MODULO.TAG_NUMERO, M.ID AS MODULO_CONF_ID, M.BIN_ESTATICO AS BIN_ESTATICO , B.IIN as BIN ' +
            ' FROM' +
            ' MODULO_CONF M' +
            ' INNER JOIN BIN B ON B.MODULO_CONF_ID=M.ID' +
            ' INNER JOIN MODULO ON MODULO.ID=M.MODULO_ID' +
            ' WHERE' +
            ' M.ID=' + IntToStr(VP_RegModulo.ModuloConfig_ID);
        VL_Consulta.Open;

        while not VL_Consulta.EOF do
        begin
            VF_Bin.Add(VL_Consulta.FieldByName('BIN').AsString, VP_RegModulo.ModuloConfig_ID, VL_Consulta.FieldByName('TAG_NUMERO').AsString);
            VL_Consulta.Next;
        end;

        VP_RegModulo.Bin_estatico := (VL_Consulta.FieldByName('BIN_ESTATICO').AsString = 'T');

        if VP_RegModulo.Bin_estatico = False then
        begin
            if Assigned(VP_Mensagem) then
            begin
                VL_Bin := VP_Mensagem.GetTagAsAstring('0036');         //BIN UNICO
                if VL_Bin <> '' then
                begin
                    VL_ModuloConfID := VF_Bin.RetornaModuloConfId(VL_Bin);
                    if VL_ModuloConfID = -1 then
                    begin
                        Result := VF_Bin.Add(VL_Bin, VP_RegModulo.ModuloConfig_ID, VP_RegModulo.Tag);
                        if Result <> 0 then
                            Exit;
                    end
                    else
                    if VL_ModuloConfID <> VP_RegModulo.ModuloConfig_ID then
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
                        if (VL_ModuloConfID <> VP_RegModulo.ModuloConfig_ID) and (VL_ModuloConfID <> -1) then
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
                        Result := VF_Bin.Add(VL_Bin, VP_RegModulo.ModuloConfig_ID, VP_RegModulo.Tag);
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

function TDNucleo.AtualizaMENU(VP_RegModulo: TRegModulo; VP_Mensagem: TMensagem; VP_Sistema: boolean): integer;
var
    VL_Consulta: TZQuery;
    VL_Mensagem: TMensagem;
    VL_ModuloConfID: integer;
    VL_I: integer;
    VL_Tag: TTag;
    VL_Menu: TRecMenu;
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

        if not Assigned(@VP_RegModulo) then
        begin
            Result := 64;
            Exit;
        end;


        if VP_RegModulo.ModuloConfig_ID = 0 then
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


        if VP_RegModulo.ModuloConfig_ID < 1 then
        begin
            Result := 64;
            Exit;
        end;

        VF_Menu.RemovePorModuloConf(VP_RegModulo.ModuloConfig_ID);



        if (VP_Sistema) and (VP_RegModulo.ModuloConfig_ID > 0) then
        begin

            VL_Consulta.Close;
            VL_Consulta.SQL.Text := 'SELECT TAG.DADOS,TAG.TAG_NUMERO,MODULO_FUNCAO.HABILITADO FROM MODULO_FUNCAO ' +
                'INNER JOIN MODULO_CONF ON MODULO_CONF.MODULO_ID=MODULO_FUNCAO.MODULO_ID ' +
                'INNER JOIN TAG ON TAG.TAG_NUMERO=MODULO_FUNCAO.TAG_NUMERO AND TAG.TAG_TIPO=''MENU_PDV'' ' +
                'WHERE MODULO_CONF.ID=' + IntToStr(VP_RegModulo.ModuloConfig_ID) + ' UNION ' +
                'SELECT TAG.DADOS,TAG.TAG_NUMERO,MODULO_CONF_FUNCAO.HABILITADO FROM MODULO_CONF_FUNCAO ' +
                'INNER JOIN MODULO_CONF ON MODULO_CONF.ID = MODULO_CONF_FUNCAO.MODULO_CONF_ID AND MODULO_CONF.HABILITADO=''T'' ' +
                'INNER JOIN TAG ON TAG.TAG_NUMERO=MODULO_CONF_FUNCAO.TAG_NUMERO AND TAG.TAG_TIPO=''MENU_PDV'' WHERE MODULO_CONF.ID=' +
                IntToStr(VP_RegModulo.ModuloConfig_ID);

            VL_Consulta.Open;

            for VL_I := 1 to VL_Consulta.RecordCount do
            begin
                VL_Tag.Dados := VL_Consulta.FieldByName('DADOS').AsString;
                VL_Tag.Tag := VL_Consulta.FieldByName('TAG_NUMERO').AsString;

                Result := VF_Menu.Add(VL_Tag.Tag, VL_Tag.Dados, VP_RegModulo.ModuloConfig_ID);
                VL_ModuloConfID := VF_Menu.RetornaMenu(VL_Tag.Tag, VL_Menu);
                //VERIFICA SE O MENU É PARA EXCLUIR
                if VL_Consulta.FieldByName('HABILITADO').AsString = 'F' then
                    VF_MENU.ListaMenu.Remove(VF_Menu.ListaMenu.Items[VL_ModuloConfID]);
            end;
            Exit;
        end;

        VL_Consulta.Close;
        VL_Consulta.SQL.Text := 'SELECT M.ID AS MODULO_CONF_ID, M.MENU_ESTATICO AS MENU_ESTATICO ' +
            ' FROM' +
            ' MODULO_CONF M' +
            ' WHERE' +
            ' M.ID=' + IntToStr(VP_RegModulo.ModuloConfig_ID);
        VL_Consulta.Open;

        VP_RegModulo.Menu_estatico := (VL_Consulta.FieldByName('MENU_ESTATICO').AsString = 'T');


        if ((VP_Mensagem.GetTagAsAstring('007D') = '') and (VP_Mensagem.GetTagAsAstring('004D') = '0')) then  // não é para atualizar o menu
            Exit;


        Result := VL_Mensagem.CarregaTags(VP_Mensagem.GetTagAsAstring('007D')); //TAG DE MENSAGEM CONTENDO O MENU

        if (((VP_RegModulo.Menu_estatico = False) or (VP_Sistema)) and (Result = 0)) then
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
                        if (VL_ModuloConfID <> VP_RegModulo.ModuloConfig_ID) and (VL_ModuloConfID <> -1) then
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
                        Result := VF_Menu.Add(VL_Tag.Tag, VL_Tag.Dados, VP_RegModulo.ModuloConfig_ID);
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

function TDNucleo.AtualizaMENU_OPERACIONAL(VP_RegModulo: TRegModulo; VP_Mensagem: TMensagem; VP_Sistema: boolean): integer;
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

        if not Assigned(@VP_RegModulo) then
        begin
            Result := 64;
            Exit;
        end;


        if VP_RegModulo.ModuloConfig_ID = 0 then
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



        if VP_RegModulo.ModuloConfig_ID < 1 then
        begin
            Result := 64;
            Exit;
        end;

        VF_MenuOperacional.RemovePorModuloConf(VP_RegModulo.ModuloConfig_ID);
        VL_Consulta.Close;
        VL_Consulta.SQL.Text := 'SELECT M.ID AS MODULO_CONF_ID, M.MENU_ESTATICO AS MENU_ESTATICO_OPERACIONAL ' +
            ' FROM' +
            ' MODULO_CONF M' +
            ' WHERE' +
            ' M.ID=' + IntToStr(VP_RegModulo.ModuloConfig_ID);
        VL_Consulta.Open;

        VP_RegModulo.Menu_estatico := (VL_Consulta.FieldByName('MENU_ESTATICO_OPERACIONAL').AsString = 'T');


        if ((VP_Mensagem.GetTagAsAstring('007D') = '') and (VP_Mensagem.GetTagAsAstring('004D') = '0')) then  // não é para atualizar o menu
            Exit;

        Result := VL_Mensagem.CarregaTags(VP_Mensagem.GetTagAsAstring('007D')); //TAG DE MENSAGEM CONTENDO O MENU


        if ((VP_RegModulo.Menu_estatico = False) and (Result = 0)) then
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
                        if (VL_ModuloConfID <> VP_RegModulo.ModuloConfig_ID) and (VL_ModuloConfID <> -1) then
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
                        Result := VF_MenuOperacional.Add(VL_Tag.Tag, VL_Tag.Dados, VP_RegModulo.ModuloConfig_ID);
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

function TDNucleo.ModuloGetReg(VP_ModuloProc_ID: integer): Pointer;
var
    VL_I: integer;
    VL_RegModulo: ^TRegModulo;
begin

    Result := nil;

    if not Assigned(VF_ListaTRegModulo) then
        Exit;

    if VF_ListaTRegModulo.Count = 0 then
        Exit;

    for VL_I := 0 to VF_ListaTRegModulo.Count - 1 do
    begin
        VL_RegModulo := VF_ListaTRegModulo.Items[VL_I];
        if VL_RegModulo^.ModuloProcID = VP_ModuloProc_ID then
        begin
            Result := VL_RegModulo;
            Exit;
        end;
    end;

end;

function TDNucleo.ModuloGetRegAdquirencia(VP_AdquirenciaIdentificacao, VP_Tag: string): TRegModulo;
var
    VL_I: integer;
    VL_RegModulo: ^TRegModulo;
begin
    Result.ModuloConfig_ID := -1;
    Result.ModuloProcID := -1;

    if not Assigned(VF_ListaTRegModulo) then
        Exit;

    if VF_ListaTRegModulo.Count = 0 then
        Exit;

    for VL_I := 0 to VF_ListaTRegModulo.Count - 1 do
    begin
        VL_RegModulo := VF_ListaTRegModulo.Items[VL_I];
        if (VL_RegModulo^.Adquirente_Identificacao = VP_AdquirenciaIdentificacao) and
            (VL_RegModulo^.Tag = VP_Tag) then
        begin
            Result := VL_RegModulo^;
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
    VL_Bin^.ModuloTag := VP_Tag;
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

        VL_I := Self.ListaBin.Count;
        if VL_I = 0 then
            exit;

        VL_Continua := False;

        for VL_I := 0 to Self.ListaBin.Count - 1 do
        begin
            VL_Bin := Self.ListaBin.Items[VL_I];
            if VL_Bin^.ModuloConfID = VP_ModuloConfID then
            begin
                VL_Continua := True;
                Self.ListaBin.Remove(VL_Bin);
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
    Result.ModuloTag := '';

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
    VL_PMenu: ^TRecMenu;
    VL_Menu: TRecMenu;
begin
    Result := 0;
    VL_Menu.ModuloConfID := 0;
    VL_Menu.Tag := '';
    VL_Menu.TextoBotao := '';

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

    new(VL_PMenu);
    Result := RetornaMenu(VP_Tag, VL_Menu);
    if Result > 0 then
        ListaMenu.Delete(Result);
    Result := 0;
    VL_PMenu^.Tag := VP_Tag;
    VL_PMenu^.TextoBotao := VP_TextoBotao;
    VL_PMenu^.ModuloConfID := VP_ModuloConfID;
    ListaMenu.Add(VL_PMenu);

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

function TMenu.RetornaMenu(VP_Tag: ansistring; var VO_Menu: TRecMenu): integer;
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
            VO_Menu := VL_Menu^;
            Result := VL_I;
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
        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, 3000, False, nil, V_TransmissaoID, V_Mensagem, V_Mensagem, V_Conexao_ID);
        exit;
    end;
    VL_Mensagem := TMensagem.Create;
    VL_Transacao := TTransacao.Create(V_Mensagem.Comando(), V_Terminal_Tipo, V_Doc, V_Terminal_ID, '');
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
    DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, 3000, False, nil, V_TransmissaoID, VL_Mensagem, VL_Mensagem, V_Conexao_ID);
    VL_Transacao.Free;

end;

constructor TThTransacao.Create(VP_Suspenso: boolean; VP_Trasmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer;
    VP_Terminal_Tipo: string; VP_Terminal_ID: integer; VP_Doc: string);
begin
    V_Mensagem := TMensagem.Create;
    v_Mensagem.CarregaTags(VP_Mensagem.TagsAsString);
    V_Conexao_ID := VP_Conexao_ID;
    V_TransmissaoID := VP_Trasmissao_ID;
    V_Terminal_Tipo := VP_Terminal_Tipo;
    V_Terminal_ID := VP_Terminal_ID;
    V_Doc := VP_Doc;
    FreeOnTerminate := True;

    inherited Create(VP_Suspenso);
end;

destructor TThTransacao.Destroy;
begin
    V_Mensagem.Free;
    inherited Destroy;
end;


{ TThModulo }


constructor TThModulo.Create(VP_Suspenso: boolean; VP_RegModulo: Pointer; VP_ConexaoTipo: TConexaoTipo; VP_ArquivoLog: string; VP_DNucleo: Pointer);
begin
    inherited Create(VP_Suspenso);
    VF_Sair := False;
    FreeOnTerminate := False;
    VF_RegModulo := VP_RegModulo;
    VF_DNucleo := VP_DNucleo;
    VF_LibCarregada := False;
    VF_Rodando := False;
    VF_ConexaoTipo := VP_ConexaoTipo;
    V_ListaTarefas := TList.Create;
    VF_ArquivoLog := VP_ArquivoLog;

end;

destructor TThModulo.Destroy;
begin
    V_ListaTarefas.Free;
    V_ListaTarefas := nil;
    if Assigned(VF_DNucleo) then
        TDNucleo(VF_DNucleo).VF_Bin.RemovePorModuloConf(TRegModulo(VF_RegModulo^).ModuloConfig_ID);
    //DNucleo.VF_Bin.RemovePorModuloConf(TRegModulo(VF_RegModulo^).ModuloConfig_ID);
    inherited Destroy;
end;

{ TModulos }


procedure TDNucleo.DataModuleCreate(Sender: TObject);
begin
    VF_ListaTRegModulo := TList.Create;
    VF_Bin := TBin.Create;
    VF_Menu := TMenu.Create;
    VF_MenuOperacional := TMenu.Create;
end;

procedure TDNucleo.DataModuleDestroy(Sender: TObject);
begin
    VF_ListaTRegModulo.Free;
    VF_ListaTRegModulo := nil;
    VF_Bin.Free;
    VF_Menu.Free;
    VF_MenuOperacional.Free;
end;


function TDNucleo.comando(VP_Erro: integer; VP_Transmissao_ID, VP_DadosRecebidos: string; VP_Conexao_ID: integer;
    VP_Terminal_Tipo: string; VP_Terminal_ID: integer; VP_DOC: string; VP_Terminal_Status: TConexaoStatus;
    VP_Terminal_Identificacao: string; VP_Permissao: TPermissao; VP_ClienteIP: string): integer;
var
    VL_Mensagem: TMensagem;
    VL_Erro: integer;
begin
    try
        VL_Erro := 0;
        if VP_Erro <> 0 then
        begin
            GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '250820221507', 'TDNucleo.comando, recebeu comando com erro', '', VP_Erro);
            Exit;
        end;


        VL_Mensagem := TMensagem.Create;

        VL_Erro := VL_Mensagem.CarregaTags(VP_DadosRecebidos);

        if VL_Erro <> 0 then
        begin
            GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '120920220842', 'TDNucleo.comando, erro ao carregar tags', '', VL_Erro);
            DComunicador.DesconectarClienteID(DComunicador, VP_Conexao_ID);
            Exit;
        end;

        case VL_Mensagem.Comando() of
            '0001': Result := comando0001(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID);   // LOGIN
            '0021': Result := comando0021(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID);   // PEDIDO DE CONEXÃO TROCA DE CHAVES
            '000A': Result := comando000A(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Terminal_Status, VP_Terminal_ID,
                    VP_Terminal_Tipo, VP_DOC, VP_Terminal_Identificacao);
            // INICIA VENDA DO FRENTE DE CAIXA
            '0018': Result := comando0018(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Terminal_Status, VP_Terminal_ID);
            // SOLICITANDO OU INFOMANDO A OPÇÃO DO MENU DE VENDA
            '002B': Result := comando002B(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR MODULO
            '0039': Result := comando0039(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR LOJA
            '003F': Result := comando003F(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR LOJA
            '0044': Result := comando0044(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR PDV
            '0045': Result := comando0045(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // VALIDA CHAVE PDV
            '004B': Result := comando004B(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR PDV
            '0052': Result := comando0052(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR TAG
            '0053': Result := comando0053(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR PINPAD
            '0055': Result := comando0055(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR PINPAD
            '0057': Result := comando0057(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR CONFIGURADOR
            '0058': Result := comando0058(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR CONFIGURADOR
            '0059': Result := comando0059(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // VALIDA CHAVE CONFIGURADOR
            '0064': Result := comando0064(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR MULT-LOJA
            '0066': Result := comando0066(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR MULT-LOJA
            '0067': Result := comando0067(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR MULT-LOJA
            '0069': Result := comando0069(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR LOJA
            '006A': Result := comando006A(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR PINPAD
            '006B': Result := comando006B(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR PDV
            '0070': Result := comando0070(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID);   // PESQUISA (TABELA EM LOTE)
            '0071': Result := comando0071(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // VALIDA CHAVE MODULO_CONF
            '0072': Result := comando0072(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR MODULO_CONF
            '0073': Result := comando0073(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR MODULO_CONF
            '0074': Result := comando0074(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR MODULO
            '0075': Result := comando0075(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR MODULO
            '0077': Result := comando0077(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR BIN
            '0078': Result := comando0078(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR BIN
            '0079': Result := comando0079(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR MODULO_CONF_FUNCAO
            '007A': Result := comando007A(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Terminal_Tipo, VP_Terminal_ID, VP_DOC);
            // TRANSACAO PARA APROVACAO AUTOMATIZADA
            '007E': Result := comando007E(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR MODULO_FUNCAO
            '007F': Result := comando007F(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR MODULO_FUNCAO
            '0085': Result := comando0085(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR MODULO_CONF_FUNCAO
            '0087': Result := comando0087(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR LOJA_MODULO_CONF_FUNCAO
            '0088': Result := comando0088(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR MULTILOJA_MODULO_CONF_FUNCAO
            '008A': Result := comando008A(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR MODULO_CONF_FUNCAO
            '0096': Result := comando0096(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR MULTLOJA_MODULO
            '0099': Result := comando0099(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR MULTLOJA_MODULO
            '009A': Result := comando009A(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR MULTLOJA_MODULO
            '009B': Result := comando009B(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR LOJA_MODULO_CONF_FUNCAO
            '009D': Result := comando009D(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR MULTLOJA_FUNCAO
            '009F': Result := comando009F(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR MULTLOJA_FUNCAO
            '00A0': Result := comando00A0(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR MULTLOJA_FUNCAO
            '00AA': Result := comando00AA(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR LOJA_FUNCAO
            '00AC': Result := comando00AC(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR LOJA_FUNCAO
            '00AD': Result := comando00AD(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUI LOJA_FUNCAO
            '00AE': Result := comando00AE(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR LOJA_MODULO
            '00B0': Result := comando00B0(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR MULTILOJA_MODULO_CONF_FUNCAO
            '00B1': Result := comando00B1(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR LOJA_MODULO
            '00B2': Result := comando00B2(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR LOJA_MODULO
            '00B5': Result := comando00B5(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR PINPAD_FUNCAO
            '00B6': Result := comando00B6(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR PINPAD_FUNCAO
            '00B8': Result := comando00B8(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR PINPAD_FUNCAO
            '00B9': Result := comando00B9(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR MODULO_FUNCAO
            '00BA': Result := comando00BA(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR MODULO_CONF
            '00BB': Result := comando00BB(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR CONFIGURADOR
            '00BF': Result := comando00BF(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR LOJA_MODULO_CONF_FUNCAO
            '00C2': Result := comando00C2(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR PDV_FUNCAO
            '00C4': Result := comando00C4(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR PDV_FUNCAO
            '00C5': Result := comando00C5(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR PDV_FUNCAO
            '00C8': Result := comando00C8(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR PDV_MODULO
            '00CA': Result := comando00CA(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR MULTILOJA_MODULO_CONF_FUNCAO
            '00CB': Result := comando00CB(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR PDV_MODULO
            '00CC': Result := comando00CC(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR PDV_MODULO
            '00DB': Result := comando00DB(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR TAG
            '00DC': Result := comando00DC(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR TAG
            '00DE': Result := comando00DE(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // INCLUIR ADQUIRENTE
            '00DF': Result := comando00DF(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // ALTERAR ADQUIRENTE
            '00E0': Result := comando00E0(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Permissao);   // EXCLUIR ADQUIRENTE
            '00F3': Result := comando00F4(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Terminal_Status, VP_Terminal_Tipo,
                    VP_Terminal_ID, VP_DOC, VP_Terminal_Identificacao);
            // SOLICITA SALDO
            '00F0': Result := comando00F4(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Terminal_Status, VP_Terminal_Tipo,
                    VP_Terminal_ID, VP_DOC, VP_Terminal_Identificacao);
            // SOLICITA MENU OPERACIONAL
            '00F4': Result := comando00F4(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Terminal_Status, VP_Terminal_Tipo,
                    VP_Terminal_ID, VP_DOC, VP_Terminal_Identificacao);
            // EXECUTAR MODULO
            '00F6': Result := comando00F4(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Terminal_Status, VP_Terminal_Tipo,
                    VP_Terminal_ID, VP_DOC, VP_Terminal_Identificacao);
            // SOLICITA CANCELAMENTO DE TRANSACAO
            '00F5': Result := comando00F5(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Terminal_Status, VP_Terminal_ID);   // MENU OPERACIONAL
            '0111': Result := comando0111(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID);   // SOLICITA CHAVE PUBLICA
            else
            begin
                VL_Mensagem.Limpar;
                Result := 101;
                VL_Mensagem.AddComando('0026', '101'); // retorno com erro
                DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, 10000, False, nil, VP_Transmissao_ID,
                    VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
                Exit;
                //DComunicador.DesconectarClienteID(DComunicador, VP_Conexao_ID);
            end;
        end;

    finally
        VL_Mensagem.Free;
    end;

end;

procedure ServidorRecebimento(VP_Erro: integer; VP_Transmissao_ID, VP_DadosRecebidos: string; VP_Conexao_ID: integer;
    VP_Terminal_Tipo: string; VP_Terminal_ID: integer; VP_DOC: string; VP_Terminal_Status: TConexaoStatus; VP_Terminal_Identificacao: string;
    VP_Permissao: TPermissao; VP_ClienteIP: string);
begin
    DNucleo.comando(VP_Erro, VP_Transmissao_ID, VP_DadosRecebidos, VP_Conexao_ID, VP_Terminal_Tipo, VP_Terminal_ID, VP_DOC,
        VP_Terminal_Status, VP_Terminal_Identificacao, VP_Permissao, VP_ClienteIP);
end;

function TDNucleo.comando0021(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer): integer;
var
    VL_Dados: string;
    VL_ExpoentePublico, VL_ModuloPublico: string;
    VL_TChaves: TTChaveComunicacao;
    VL_Mensagem: TMensagem;
    VL_AContext: TIdContext;

begin
    VL_Mensagem := TMensagem.Create;
    VL_Dados := '';
    VL_TChaves.ID := 0;
    VL_TChaves.ChaveComunicacao := '';
    VL_ModuloPublico := '';
    VL_ExpoentePublico := '';
    VL_AContext := nil;
    if not DComunicador.V_ConexaoCliente.GetSocketServidor(DComunicador, VP_Conexao_ID, VL_AContext) then
    begin
        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '130920221016', 'Erro na comando0021 conexão do cliente não encontrada ', '', 99);
        Result := 99;
        Exit;
    end;

    try
        VP_Mensagem.GetTag('0023', VL_Dados);
        Result := 33;
        if TTConexao(VL_AContext.Data).Status = csDesconectado then
            Exit;
        if VL_Dados <> '' then
        begin
            VP_Mensagem.GetTag('0022', VL_TChaves.ID);
            VL_TChaves := DComunicador.V_ChavesDasConexoes.getChave((VL_TChaves.ID));
            if VL_TChaves.ID > 0 then
            begin
                TTConexao(VL_AContext.Data).setChaveComunicacao(VL_TChaves.ChaveComunicacao);
                try
                    if TTConexao(VL_AContext.Data).Aes.DecryptString(VL_Dados) = 'OK' then
                    begin
                        VL_Mensagem.AddComando('0024', '');
                        VL_Mensagem.TagToStr(VL_Dados);
                        TTConexao(VL_AContext.Data).Status := csChaveado;

                        VL_Dados := VL_Mensagem.TagsAsString;

                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('00D1', VP_Transmissao_ID);
                        VL_Mensagem.AddTag('00D2', VL_Dados);

                        VL_AContext.Connection.Socket.WriteLn(VL_Mensagem.TagsAsString);
                        Exit;
                    end;
                except
                    on e: EInOutError do
                        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '060920221730', 'Erro na comando0021 ' +
                            e.ClassName + '/' + e.Message, '', Result);
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


                VL_AContext.Connection.Socket.WriteLn(VL_Mensagem.TagsAsString);
                Exit;
            end;
        end;
        VL_Mensagem.limpar;
        VL_Mensagem.AddComando('0025', '');
        VP_Mensagem.GetTag('0008', VL_ModuloPublico);
        VP_Mensagem.GetTag('0027', VL_ExpoentePublico);

        TTConexao(VL_AContext.Data).setModuloPublico(VL_ModuloPublico);
        TTConexao(VL_AContext.Data).setExpoentePublico(VL_ExpoentePublico);

        VL_TChaves.ChaveComunicacao := TTConexao(VL_AContext.Data).getChaveComunicacao;
        VL_TChaves.ID := TTConexao(VL_AContext.Data).ChaveComunicacaoIDX;

        VL_Dados := TTConexao(VL_AContext.Data).Rsa.EncryptString(VL_TChaves.ChaveComunicacao);

        VL_Mensagem.AddTag('0009', VL_Dados);
        VL_Mensagem.AddTag('0022', VL_TChaves.ID);
        VL_Mensagem.AddTag('0008', TTConexao(VL_AContext.Data).ModuloPublico);
        VL_Mensagem.AddTag('0027', TTConexao(VL_AContext.Data).ExpoentePublico);
        VL_Mensagem.AddTag('0023', TTConexao(VL_AContext.Data).Aes.EncryptString('OK'));

        VL_Mensagem.TagToStr(VL_Dados);
        TTConexao(VL_AContext.Data).Status := csChaveado;

        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('00D1', VP_Transmissao_ID);
        VL_Mensagem.AddTag('00D2', VL_Dados);


        VL_AContext.Connection.Socket.WriteLn(VL_Mensagem.TagsAsString);

        Result := 0;


    finally
        VL_Mensagem.Free;
    end;
end;

function TDNucleo.comando0001(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer): integer;
var

    VL_Desafio, VL_ID, VL_IP, VL_TagDados: string;
    VL_Mensagem: TMensagem;
    VL_Consulta: TZQuery;
    VL_TerminalSenha: string;
    VL_Permissao: TPermissao;
    VL_AContext: TIdContext;
    VL_String: String;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_Desafio := '';
    VL_TerminalSenha := '';
    VL_TagDados := '';
    VL_ID := '';
    VL_String:='';
    VL_Permissao := pmS;


    VL_Consulta := TZQuery.Create(DComunicador);
    VL_Consulta.Connection := DNucleo.ZConexao;
    VL_AContext := nil;
    if not DComunicador.V_ConexaoCliente.GetSocketServidor(DComunicador, VP_Conexao_ID, VL_AContext) then
    begin
        GravaLog(F_ArquivoLog, 0, '', 'opentefnucleo', '130920221022', 'Erro na comando0001 conexão do cliente não encontrada '
            , '', 99);
        Result := 99;
        Exit;
    end;


    try
        //inicio do processo
        VP_Mensagem.GetTag('0106', VL_Desafio);
        VP_Mensagem.GetTag('00A3', VL_ID);
        VP_Mensagem.GetTag('0035', VL_TerminalSenha);
        VP_Mensagem.GetTag('0037', VL_TagDados);    //  TIPO DE PERMISSAO DO TERMINAL

        VL_Permissao := StrToPermissao(VL_TagDados);

        VL_IP := TTConexao(VL_AContext.Data).ClienteIp;

        VL_Consulta.Close;
        VL_String := 'SELECT S_STATUS,S_TERMINAL,S_DOC,S_CHAVE,S_IDENTIFICACAO FROM P_VAL_TERMINAL(''' + VL_IP + ''',' + VL_ID + ',''' +
            VL_TerminalSenha + ''',''' + PermissaoToStr(VL_Permissao) + ''')';
        VL_Consulta.SQL.Text:= VL_String;
        VL_Consulta.Open;

        if VL_Consulta.FieldByName('S_STATUS').AsInteger <> 0 then
        begin
            VL_Mensagem.AddComando('0029', VL_Consulta.FieldByName('S_STATUS').AsString);
            Result := VL_Consulta.FieldByName('S_STATUS').AsInteger;
        end
        else
        if VL_Consulta.FieldByName('S_CHAVE').AsString = '' then
        begin
            VL_Mensagem.AddComando('0029', '94');
            Result := 94;
        end
        else
        begin
            DNucleo.CriptoAes.GenerateKey(VL_Consulta.FieldByName('S_CHAVE').AsString);
            VL_Desafio := DNucleo.CriptoAes.DecryptString(VL_Desafio);
            VL_TagDados := VL_Desafio;
            VL_Desafio := Copy(VL_Desafio, 1, 5);
            if copy(VL_TagDados, Length(VL_Desafio) + 1, 3) = '   ' then
            begin
                TTConexao(VL_AContext.Data).Status := csLogado;
                VL_Mensagem.AddComando('0028', '');
                VL_Mensagem.AddTag('0106', VL_Desafio); // desafio
                TTConexao(VL_AContext.Data).Permissao := VL_Permissao;
                TTConexao(VL_AContext.Data).Terminal_ID := StrToInt(VL_ID);
                TTConexao(VL_AContext.Data).Terminal_Tipo := VL_Consulta.FieldByName('S_TERMINAL').AsString;
                TTConexao(VL_AContext.Data).DOC := VL_Consulta.FieldByName('S_DOC').AsString;
                TTConexao(VL_AContext.Data).Identificacao := VL_Consulta.FieldByName('S_IDENTIFICACAO').AsString;
            end
            else
            begin
                VL_Mensagem.AddComando('0029', '92');
                Result := 92;
            end;
        end;

        VL_Consulta.Close;
        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, 3000, False, nil, VP_Transmissao_ID, VL_Mensagem, VL_Mensagem, VP_Conexao_ID);

    finally
        VL_Consulta.Close;
        VL_Mensagem.Free;
        VL_Consulta.Free;
    end;

end;


function TDNucleo.comando0018(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer; VP_Terminal_Status: TConexaoStatus;
    VP_Terminal_ID: integer): integer;// menu de venda
var
    VL_Consulta: TZQuery;
    VL_I: integer;
begin
    Result := 0;
    VL_Consulta := TZQuery.Create(nil);
    try
        if VP_Terminal_Status <> csLogado then
        begin
            VP_Mensagem.AddComando('0026', '35');
            DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, 3000, False, nil, VP_Transmissao_ID, VP_Mensagem, VP_Mensagem, VP_Conexao_ID);
            exit;
        end;

        VL_Consulta.Connection := ZConexao;

        if VP_Mensagem.ComandoDados() = 'S' then
        begin
            if VF_Menu.Count = 0 then
            begin
                VP_Mensagem.AddComando('0026', '56');
                DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, 3000, False, nil, VP_Transmissao_ID, VP_Mensagem, VP_Mensagem, VP_Conexao_ID);
                exit;
            end;

            VP_Mensagem.Limpar;
            VP_Mensagem.AddComando('0018', 'R');

            VL_Consulta.Close;
            VL_Consulta.SQL.Text := 'SELECT S_TAG_DADOS, S_TAG_NUMERO,S_HABILITADO ' +
                'FROM P_TAG_FUNCAO(' + IntToStr(VP_Terminal_ID) + ',''MENU_PDV'')';

            VL_Consulta.Open;

            while not VL_Consulta.EOF do
            begin
                if VL_Consulta.FieldByName('S_HABILITADO').AsString = 'T' then
                    VF_Menu.Add(VL_Consulta.FieldByName('S_TAG_NUMERO').AsString, VL_Consulta.FieldByName('S_TAG_DADOS').AsString, 0);

                VL_Consulta.Next;
            end;

            for vl_i := 0 to VF_Menu.Count - 1 do
            begin
                if VL_Consulta.Locate('S_TAG_NUMERO', VF_Menu.GetTag(VL_I), []) then
                begin
                    if VL_Consulta.FieldByName('S_HABILITADO').AsString = 'T' then
                        VP_Mensagem.AddTag(VF_Menu.GetTag(VL_I), VF_Menu.GetTextoBotao(VL_I));
                end
                else
                    VP_Mensagem.AddTag(VF_Menu.GetTag(VL_I), VF_Menu.GetTextoBotao(VL_I));
            end;


            DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, 3000, False, nil, VP_Transmissao_ID, VP_Mensagem, VP_Mensagem, VP_Conexao_ID);
        end
        else
        begin
            VP_Mensagem.Limpar;
            VP_Mensagem.AddComando('0026', '57');
            DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, 3000, False, nil, VP_Transmissao_ID, VP_Mensagem, VP_Mensagem, VP_Conexao_ID);
            exit;
        end;

    finally
        begin
            VL_Consulta.Free;
        end;
    end;

end;

// menu de operacao
function TDNucleo.comando00F5(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer; VP_Terminal_Status: TConexaoStatus;
    VP_Terminal_ID: integer): integer;
var
    VL_Consulta: TZQuery;
    VL_I: integer;
begin
    Result := 0;
    VL_Consulta := TZQuery.Create(nil);
    try
        if VP_Terminal_Status <> csLogado then
        begin
            VP_Mensagem.AddComando('0026', '35');
            DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, 3000, False, nil, VP_Transmissao_ID, VP_Mensagem, VP_Mensagem, VP_Conexao_ID);
            exit;
        end;

        VL_Consulta.Connection := ZConexao;

        if VP_Mensagem.ComandoDados() = 'S' then
        begin
            if VF_MenuOperacional.Count = 0 then
            begin
                VP_Mensagem.AddComando('0026', '56');
                DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, 3000, False, nil, VP_Transmissao_ID, VP_Mensagem, VP_Mensagem, VP_Conexao_ID);
                exit;
            end;

            VP_Mensagem.Limpar;
            VP_Mensagem.AddComando('00F5', 'R');

            VL_Consulta.Close;
            VL_Consulta.SQL.Text := 'SELECT S_TAG_DADOS, S_TAG_NUMERO,S_HABILITADO ' +
                'FROM P_TAG_FUNCAO(' + IntToStr(VP_Terminal_ID) + ',''MENU_OPERACIONAL'')';

            VL_Consulta.Open;

            while not VL_Consulta.EOF do
            begin
                if VL_Consulta.FieldByName('S_HABILITADO').AsString = 'T' then
                    VF_MenuOperacional.Add(VL_Consulta.FieldByName('S_TAG_NUMERO').AsString, VL_Consulta.FieldByName('S_TAG_DADOS').AsString, 0);

                VL_Consulta.Next;
            end;

            for vl_i := 0 to VF_MenuOperacional.Count - 1 do
            begin
                if VL_Consulta.Locate('S_TAG_NUMERO', VF_MenuOperacional.GetTag(VL_I), []) then
                begin
                    if VL_Consulta.FieldByName('S_HABILITADO').AsString = 'T' then
                        VP_Mensagem.AddTag(VF_MenuOperacional.GetTag(VL_I), VF_MenuOperacional.GetTextoBotao(VL_I));
                end
                else
                    VP_Mensagem.AddTag(VF_MenuOperacional.GetTag(VL_I), VF_MenuOperacional.GetTextoBotao(VL_I));
            end;


            DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, 3000, False, nil, VP_Transmissao_ID, VP_Mensagem, VP_Mensagem, VP_Conexao_ID);
        end
        else
        begin
            VP_Mensagem.Limpar;
            VP_Mensagem.AddComando('0026', '57');
            DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, 3000, False, nil, VP_Transmissao_ID, VP_Mensagem, VP_Mensagem, VP_Conexao_ID);
            exit;
        end;

    finally
        begin
            VL_Consulta.Free;
        end;
    end;

end;


function TDNucleo.comando007A(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer; VP_Terminal_Tipo: string;
    VP_Terminal_ID: integer; VP_Doc: string): integer;
var
    VL_Transacao: TThTransacao;
begin
    Result := 0;
    VL_Transacao := TThTransacao.Create(True, VP_Transmissao_ID, VP_Mensagem, VP_Conexao_ID, VP_Terminal_Tipo, VP_Terminal_ID, VP_Doc);
    VL_Transacao.Start;
end;

function TDNucleo.comando000A(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer; VP_Terminal_Status: TConexaoStatus;
    VP_Terminal_ID: integer; VP_Terminal_Tipo, VP_Doc, VP_Terminal_Identificacao: string): integer;
    // SOLICITA APROVACAO DA TRANSACAO
var
    VL_Chave00F1, VL_Mensagem, VL_Transacao: TMensagem;
    VL_Consulta: TZQuery;
    VL_RecBin: TRecBin;
    VL_TempoEmperaComandao: int64;
    VL_String: string;
    VL_Erro: integer;
    VL_Adquirente_Identificacao: string;
    VL_Bin: string;
    VL_ChaveTransacao: string;
begin
    Result := 0;
    VL_TempoEmperaComandao := 0;
    VL_Transacao := TMensagem.Create;
    VL_Chave00F1 := TMensagem.Create;
    VL_Mensagem := TMensagem.Create;
    VL_Adquirente_Identificacao := '';
    VL_Bin := '';
    VL_ChaveTransacao := '';

    VL_Erro := VL_Mensagem.CarregaTags(VP_Mensagem.TagsAsString);

    if VL_Erro <> 0 then
    begin
        GravaLog(F_ArquivoLog, 0, '.comando000A', 'opentefnucleo', '240820221056', '', '', VL_Erro);
        DComunicador.DesconectarClienteID(DComunicador, VP_Conexao_ID);
        Result := VL_Erro;
        Exit;
    end;

    try
        //testa conexão devolve erro caso nao logado
        if VP_Terminal_Status <> csLogado then
        begin
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('000A', 'R'); // retorno
            VL_Mensagem.AddTag('004D', '35');  // resposta com erro
            DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, 3000, False, nil, VP_Transmissao_ID, VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
            Result := 35;
            Exit;
        end;

        // começa testar os dados e solicitar os faltantes

        VL_Erro := VL_Transacao.CarregaTags(VL_Mensagem.GetTagAsAstring('007D'));

        if VL_Erro <> 0 then
        begin
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('0026', IntToStr(VL_Erro)); // retorno com erro
            GravaLog(F_ArquivoLog, 0, '.comando000A', 'opentefnucleo', '260820220853', '', '', VL_Erro);
            DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
                VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
            Result := VL_Erro;
            Exit;
        end;

        VL_Mensagem.GetTag('0051', VL_TempoEmperaComandao);       // TEMPO DO COMANDO
        if VL_TempoEmperaComandao = 0 then
            VL_Transacao.GetTag('0051', VL_TempoEmperaComandao);
        if VL_TempoEmperaComandao = 0 then
            VL_TempoEmperaComandao := 30000;

        VL_Bin := VL_Transacao.GetTagAsAstring('0036');  // carrega bin
        VL_Adquirente_Identificacao := VL_Transacao.GetTagAsAstring('0109');  // carrega identificacao do adquirente

        if (VL_Transacao.GetTagAsAstring('00F1') <> '') and (VL_Transacao.GetTagAsAstring('00F1') <> #1) then  // verifica se possui a chave da transacao
        begin
            VL_ChaveTransacao := PChar(VL_Mensagem.GetTagAsAstring('00F1').Trim);  // eliminando espacos e formatacoes para nao ocorrer erros

            VL_Erro := VL_Chave00F1.CarregaTags(VL_ChaveTransacao); // carregando a chave como mensagem estruturada

            if VL_Erro <> 0 then
            begin
                VL_Mensagem.AddComando('000A', 'R'); // retorno
                VL_Mensagem.AddTag('004D', VL_Erro);  // retorno com erro
                Result := VL_Erro;
                GravaLog(F_ArquivoLog, 0, '.comando000A', 'opentefnucleo', '060920221622', '', '', VL_Erro);
                DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
                    VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
                Exit;
            end;

            if VL_Bin = '' then
                VL_Bin := VL_Chave00F1.GetTagAsAstring('0036');  // carrega bin

            if VL_Adquirente_Identificacao = '' then
                VL_Adquirente_Identificacao := VL_Chave00F1.GetTagAsAstring('0109');  // carrega identificacao do adquirente
        end;

        //verifica se tem o bin ou identificacao do adquirente, para mandar para a operadora

        if ((VL_Bin = '') and (VL_Transacao.GetTagAsAstring('00D5') = '') and (VL_Transacao.GetTagAsAstring('0109') = '')) then
            //NAO TEM BIN E NÃO TEM BOTAO SELECIONAO E NÃO TEM IDENTIFICACAO DO ADQUIRENTE
        begin
            // mostra menu venda
            VL_Mensagem.AddComando('0018', 'S');
            comando0018(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Terminal_Status, VP_Terminal_ID);
            Exit;
        end;

        //NAO TEM BIN NAO TEM IDENTIFICACAO DO ADQUIRENTE E VEIO TRILHA 2
        if ((VL_Bin = '') and (VL_Adquirente_Identificacao = '') and (VL_Transacao.GetTagAsAstring('004F') <> '')) then
        begin
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('008C', 'S'); // solicita atualizacao da tag
            VL_Mensagem.AddTag('00D9', VL_Transacao.GetTagAsAstring('004F'));                    // pan
            VL_Mensagem.AddTag('0062', '0000' + Copy(VL_Transacao.GetTagAsAstring('004F'), 7, 12));  //pan mascarado
            VL_Mensagem.AddTag('0036', Copy(VL_Transacao.GetTagAsAstring('004F'), 1, 6));       //bin

            DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
                VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
            Exit;

        end;

        //NAO TEM BIN NAO TEM IDENTIFICACAO DO ADQUIRENTE E SELECIONOU UMA OPÇÃO
        if ((VL_Bin = '') and (VL_Adquirente_Identificacao = '') and (VL_Transacao.GetTagAsAstring('00D5') <> '')) then
        begin
            if VL_Transacao.GetTagAsAstring('00D5') = '001D' then  // LEITURA DE CARTAO
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0048', 'S');
                VL_Mensagem.AddTag('0051', '300000');
                DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
                    VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
                Exit;
            end
            else
            if VL_Transacao.GetTagAsAstring('00D5') = '0019' then  // OPCAO DE CARTAO DIGITADO
            begin
                VL_Mensagem.Limpar;

                // INFORMA OS BOTOES DENTRO DA TAG DE COMANDO DO BOTAO 0018

                VL_Mensagem.AddComando('0000', 'S');
                VL_Mensagem.AddTag('00E7', PChar('OK'));    //BOTAO PERSONALIZADO PARA IDENTIFICAR CARTÃO DIGITADO
                VL_String := VL_Mensagem.TagsAsString;     //converte em string a mensagem
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('002A', 'S');   //solicita dados pdv
                VL_Mensagem.AddTag('00DA', 'DIGITE O CARTÃO');    //MENSAGEM A SER MOSTRADA
                VL_Mensagem.AddTag('00DD', VL_String);    //BOTOES A MOSTRAR
                VL_Mensagem.AddTag('0033', 'A');    //campo para capturar sem mascara
                DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
                    VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
                Exit;
            end
            else
            if VL_Transacao.GetTagAsAstring('00D5') = '0112' then  // OPCAO DE PAGAMENTO PIX
            begin
                VL_Mensagem.Limpar;

                // INFORMA OS BOTOES DENTRO DA TAG DE COMANDO DO BOTAO 0018

                VL_Mensagem.AddComando('0000', 'S');
                VL_Mensagem.AddTag('00E7', PChar('OK'));    //BOTAO PERSONALIZADO PARA IDENTIFICAR CARTÃO DIGITADO
                VL_String := VL_Mensagem.TagsAsString;     //converte em string a mensagem
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('002A', 'S');   //solicita dados pdv
                VL_Mensagem.AddTag('00DA', 'DIGITE O CARTÃO');    //MENSAGEM A SER MOSTRADA
                VL_Mensagem.AddTag('00DD', VL_String);    //BOTOES A MOSTRAR
                VL_Mensagem.AddTag('0033', 'A');    //campo para capturar sem mascara
                DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
                    VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
                Exit;
            end
            else
            if VL_Transacao.GetTagAsAstring('00D5') = '00E7' then  // RETONRO OPCAO DE CARTAO DIGITADO
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('008C', 'S');  // solicita atualizacao da tag
                VL_Mensagem.AddTag('00D9', VL_Transacao.GetTagAsAstring('0033'));                    // pan
                VL_Mensagem.AddTag('0062', '0000' + Copy(VL_Transacao.GetTagAsAstring('0033'), 7, 12));  //pan mascarado
                VL_Mensagem.AddTag('0036', Copy(VL_Transacao.GetTagAsAstring('0033'), 1, 6));       //bin

                DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
                    VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
                Exit;

            end;

            // mostra menu venda
            VL_Mensagem.AddComando('0018', 'S');
            comando0018(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Terminal_Status, VP_Terminal_ID);
            Exit;
        end;

        // tenta mandar a mensagem para o modulo ativo

        if (VL_Adquirente_Identificacao <> '') then // tem identificacao do adquirente então tenta localizar o modulo
        begin
            VL_Mensagem.AddComando('000A', 'S'); // retorno do comando para pdv
            VL_Mensagem.AddTag('007D', VL_Transacao.TagsAsString);        // TRANSACAO
            VL_Erro := DNucleo.ModuloAddSolicitacaoIdentificacaoAdquirente(VP_Conexao_ID, VP_Transmissao_ID, VL_TempoEmperaComandao,
                VL_Adquirente_Identificacao, VL_Mensagem, cnCaixa);

            if VL_Erro <> 0 then
            begin
                VL_Mensagem.AddComando('00F4', 'R');  // retorno
                VL_Mensagem.AddTag('004D', VL_Erro); // retorno com erro
                Result := VL_Erro;
                GravaLog(F_ArquivoLog, 0, '.comando000A', 'opentefnucleo', '290820220834', '', '', VL_Erro);
                DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
                    VL_Mensagem, VL_Mensagem, VP_Conexao_ID);

            end;
            Exit;
        end;

        if (VL_Bin <> '') then // tem bin então tenta localizar o modulo
        begin
            VL_RecBin := VF_Bin.RetornaBIN(VL_Bin);
            if VL_RecBin.ModuloConfID = -1 then                                                      //MODULO NAO CARREGADO PARA ESSE BIN
            begin
                VL_Mensagem.AddComando('000A', 'R');  // retorno
                VL_Mensagem.AddTag('004D', 79); // resposta com erro
                DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
                    VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
                Result := 79;
                Exit;
            end;

            if VP_Terminal_Tipo = 'PDV' then          // CONEXAO NÃO É DO PDV E NÃO PODE FAZER VENDA
            begin
                // VERIFICA SE ESSE PDV TEM O MODULO_CONF LIBERADO NA LOJA
                try

                    VL_Consulta := TZQuery.Create(nil);
                    VL_Consulta.Connection := ZConexao;
                    VL_Consulta.SQL.Text := 'SELECT S_HABILITADO,S_TAG_NUMERO,S_LOJA_CODIGO, S_PDV_CODIGO FROM P_TAG_FUNCAO(' +
                        StrToSql(IntToStr(VP_Terminal_ID)) +
                        ',''MODULO'')' +
                        ' WHERE S_HABILITADO=''T'' AND S_TAG_NUMERO=''' + VL_RecBin.ModuloTag + '''';
                    VL_Consulta.Open;
                    if VL_Consulta.FieldByName('S_HABILITADO').AsString <> 'T' then
                    begin
                        VL_Mensagem.AddComando('000A', 'R'); // retorno
                        VL_Mensagem.AddTag('004D', 79);  // resposta com erro
                        Result := 79;
                        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
                            VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
                        Exit;
                    end;

                    // verifica se ja tem chave
                    if VL_Transacao.GetTagAsAstring('00F1') = '' then
                    begin
                        VL_Chave00F1.AddComando('0000', '');
                        VL_Chave00F1.AddTag('00F2', VL_RecBin.ModuloTag); // tag do modulo
                        VL_Chave00F1.AddTag('0036', VL_RecBin.IIN);   // bin
                        VL_Chave00F1.AddTag('0034', VL_Transacao.GetTagAsAstring('0034'));  // id da transacao
                        VL_Chave00F1.AddTag('0091', VP_Doc);  // documento(cpf ou cnpj)
                        VL_Chave00F1.AddTag('00F9', PChar(VL_Consulta.FieldByName('S_LOJA_CODIGO').AsString)); // codigo da loja
                        VL_Chave00F1.AddTag('0107', PChar(VL_Consulta.FieldByName('S_PDV_CODIGO').AsString)); // codigo do pdv
                        VL_Chave00F1.AddTag('0108', VP_Terminal_Identificacao); // identificacao do caixa, configurador, gerenciado
                        VL_Chave00F1.AddTag('00A2', 'PDV'); // tipo do terminal

                        VL_Transacao.AddTag('00F1', VL_Chave00F1.TagsAsString);

                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('008C', 'S');  // solicita atualizacao da tag
                        VL_Mensagem.AddTag('00F1', VL_Chave00F1.TagsAsString);
                        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
                            VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
                        Exit;

                    end;
                    // encaminha para o modulo a solicitação
                    // falta fazer as outras verificacoes como
                    // venda parcelada, venda por cartao digitado...


                    VL_Mensagem.AddComando('000A', 'S');   // solicita aprovacao
                    VL_Mensagem.AddTag('007D', VL_Transacao.TagsAsString);        // TRANSACAO


                    //  function TDNucleo.ModuloAddSolicitacao(VP_SocketID: integer; VP_SocketTransmissaoID, VP_Transmissao_ID: string;
                    //    VP_TempoEspera, VP_ModuloConfig_ID: integer; VL_Mensagem: TMensagem; VP_ConexaoTipo: TConexaoTipo): integer;


                    VL_Erro := DNucleo.ModuloAddSolicitacao(VP_Conexao_ID, VP_Transmissao_ID, VL_TempoEmperaComandao,
                        VL_RecBin.ModuloConfID, VL_Mensagem, cnCaixa);

                    if VL_Erro <> 0 then
                    begin
                        VL_Mensagem.AddComando('000A', 'R'); // retorno
                        VL_Mensagem.AddTag('004D', VL_Erro); // retorno com erro
                        Result := VL_Erro;
                        GravaLog(F_ArquivoLog, 0, '.comando000A', 'opentefnucleo', '260820220854', '', '', VL_Erro);
                        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
                            VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
                        Exit;
                    end;


                finally
                    VL_Consulta.Close;
                    VL_Consulta.Free;
                end;
                Exit;
            end;

        end
        else
        begin
            VL_Mensagem.AddComando('000A', 'R');
            VL_Mensagem.AddTag('004D', 81);
            Result := 81;
            DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
                VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
            Exit;
        end;


        VL_Mensagem.AddComando('000A', 'R'); // retorno
        VL_Mensagem.AddTag('004D', 80);  // retorno com erro
        Result := 80;
        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
            VP_Mensagem, VP_Mensagem, VP_Conexao_ID);

    finally
        VL_Transacao.Free;
        VL_Chave00F1.Free;
        VL_Mensagem.Free;
    end;
end;

function TDNucleo.comando00F4(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer; VP_Terminal_Status: TConexaoStatus;
    VP_Terminal_Tipo: string; VP_Terminal_ID: integer; VP_Doc, VP_Terminal_Identificacao: string): integer;
    // EXECUTAR MODULO
var
    VL_Chave00F1, VL_Transacao, VL_Mensagem: TMensagem;
    VL_Consulta: TZQuery;
    VL_RecBin: TRecBin;
    VL_TempoEmperaComandao: int64;
    VL_String: string;
    VL_ChaveTransacao: PChar;
    VL_Bin: string;
    VL_Erro: integer;
    VL_Adquirente_Identificacao: string;
begin
    Result := 0;
    VL_TempoEmperaComandao := 0;
    VL_Transacao := TMensagem.Create;
    VL_Chave00F1 := TMensagem.Create;
    VL_Mensagem := TMensagem.Create;
    VL_ChaveTransacao := '';
    VL_Bin := '';
    VL_Adquirente_Identificacao := '';

    VL_Erro := VL_Mensagem.CarregaTags(VP_Mensagem.TagsAsString);

    if VL_Erro <> 0 then
    begin
        GravaLog(F_ArquivoLog, 0, '.comando00F4', 'opentefnucleo', '240820221028', '', '', VL_Erro);
        Result := VL_Erro;
        DComunicador.DesconectarClienteID(DComunicador, VP_Conexao_ID);
        Exit;
    end;

    try
        //testa conexão devolve erro caso nao logado
        if VP_Terminal_Status <> csLogado then
        begin
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('00F4', 'R'); // retorno
            VL_Mensagem.AddTag('004D', '35'); // retorno com erro
            DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, 3000, False, nil, VP_Transmissao_ID, VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
            Exit;
        end;

        // começa testar os dados e solicitar os faltantes
        VL_Erro := VL_Transacao.CarregaTags(VL_Mensagem.GetTagAsAstring('007D'));

        if VL_Erro <> 0 then
        begin
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('0026', IntToStr(VL_Erro)); // retorno com erro
            Result := VL_Erro;
            GravaLog(F_ArquivoLog, 0, '.comando00F4', 'opentefnucleo', '260820220848', '', '', VL_Erro);
            DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
                VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
            Exit;
        end;

        VL_Mensagem.GetTag('0051', VL_TempoEmperaComandao);       // TEMPO DO COMANDO
        if VL_TempoEmperaComandao = 0 then
            VL_Transacao.GetTag('0051', VL_TempoEmperaComandao);
        if VL_TempoEmperaComandao = 0 then
            VL_TempoEmperaComandao := 30000;

        VL_Bin := VL_Transacao.GetTagAsAstring('0036');  // carrega bin
        VL_Adquirente_Identificacao := VL_Transacao.GetTagAsAstring('0109');  // carrega identificacao do adquirente

        if (VL_Transacao.GetTagAsAstring('00F1') <> '') and (VL_Transacao.GetTagAsAstring('00F1') <> #1) then  // verifica se possui a chave da transacao
        begin
            VL_ChaveTransacao := PChar(VL_Mensagem.GetTagAsAstring('00F1').Trim);  // eliminando espacos e formatacoes para nao ocorrer erros

            VL_Erro := VL_Chave00F1.CarregaTags(VL_ChaveTransacao); // carregando a chave como mensagem estruturada

            if VL_Erro <> 0 then
            begin
                VL_Mensagem.AddComando('00F4', 'R'); // retorno
                VL_Mensagem.AddTag('004D', VL_Erro);  // retorno com erro
                Result := VL_Erro;
                GravaLog(F_ArquivoLog, 0, '.comando00F4', 'opentefnucleo', '060920221623', '', '', VL_Erro);
                DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
                    VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
                Exit;
            end;

            if VL_Bin = '' then
                VL_Bin := VL_Chave00F1.GetTagAsAstring('0036');  // carrega bin

            if VL_Adquirente_Identificacao = '' then
                VL_Adquirente_Identificacao := VL_Chave00F1.GetTagAsAstring('0109');  // carrega identificacao do adquirente
        end;

        //verifica se tem o bin ou identificacao do adquirente, para mandar para a operadora
        if ((VL_Bin = '') and (VL_Transacao.GetTagAsAstring('00D5') = '') and (VL_Adquirente_Identificacao = '')) then
            //NAO TEM BIN E NÃO TEM BOTAO SELECIONAO E NAO TEM IDENTIFICACAO DO ADQUIRENTE
        begin
            // solicita menu operacional
            VL_Mensagem.AddComando('00F5', 'S');
            comando00F5(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Terminal_Status, VP_Terminal_ID);
            Exit;
        end;

        if VL_Transacao.GetTagAsAstring('00D5') = '00D3' then  // OPCAO CANCELAMENTO DE VENDA
        begin
            if VL_Transacao.GetTagAsAstring('00F1') = '' then // verifica se possui a chave da transacao
            begin
                VL_Mensagem.Limpar;

                VL_Mensagem.AddComando(PChar('00E1'), PChar('S'));   //solicita dados da venda
                VL_Mensagem.AddTag(PChar('00F1'), PChar(''));  // solicita chave da transacao da venda

                DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
                    VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
                Exit;
            end;

            if VL_Transacao.GetTagAsAstring('00F1') = #1 then  // chave da transacao veio nula
            begin
                //VL_Mensagem.Limpar;
                VL_Mensagem.AddComando(PChar('00F4'), PChar('R'));  // retorno
                VL_Mensagem.AddTag(PChar('004D'), PChar('89')); // retorno com erro
                DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
                    VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
                Exit;
            end;

            VL_RecBin := VF_Bin.RetornaBIN(VL_Bin); // carrega dados do bin

            if VL_RecBin.ModuloConfID = -1 then  //MODULO NAO CARREGADO PARA ESSE BIN
            begin
                VL_Mensagem.AddComando('00F4', 'R'); // retorno
                VL_Mensagem.AddTag('004D', 79);  // retorno com erro
                Result := 79;
                DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
                    VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
                Exit;
            end;

            VL_Mensagem.AddComando('00F6', 'S'); // solicita cancelamento da transacao
            VL_Mensagem.AddTag('007D', VL_Transacao.TagsAsString);        // TRANSACAO

            DNucleo.ModuloAddSolicitacao(VP_Conexao_ID, VP_Transmissao_ID, VL_TempoEmperaComandao,
                VL_RecBin.ModuloConfID, VL_Mensagem, cnCaixa);
            Exit;

        end;

        //NAO TEM BIN NAO TEM IDENTIFICACAO DO ADQUIRENTE E VEIO TRILHA 2
        if ((VL_Bin = '') and (VL_Adquirente_Identificacao = '') and (VL_Transacao.GetTagAsAstring('004F') <> '')) then
        begin
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('008C', 'S'); // solicita atualizacao das tags
            VL_Mensagem.AddTag('00D9', VL_Transacao.GetTagAsAstring('004F'));                    // pan
            VL_Mensagem.AddTag('0062', '0000' + Copy(VL_Transacao.GetTagAsAstring('004F'), 7, 12));  //pan mascarado
            VL_Mensagem.AddTag('0036', Copy(VL_Transacao.GetTagAsAstring('004F'), 1, 6));       //bin

            DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
                VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
            Exit;

        end;

        //NAO TEM BIN NAO TEM IDENTIFICACAO DO ADQUIRENTE E SELECIONOU UMA OPÇÃO
        if ((VL_Bin = '') and (VL_Adquirente_Identificacao = '') and (VL_Transacao.GetTagAsAstring('00D5') <> '')) then
        begin
            if VL_Transacao.GetTagAsAstring('00D5') = '001D' then  // LEITURA DE CARTAO
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0048', 'S');
                VL_Mensagem.AddTag('0051', '300000');
                DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
                    VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
                Exit;
            end
            else
            if VL_Transacao.GetTagAsAstring('00D5') = '00F0' then  // OPCAO DE CONSULTAR SALDO
            begin
                VL_Mensagem.Limpar;

                // INFORMA OS BOTOES DENTRO DA TAG DE COMANDO DO BOTAO 0018
                VL_Mensagem.AddTag('00E7', PChar('OK'));    //BOTAO PERSONALIZADO PARA IDENTIFICAR CARTÃO DIGITADO
                VL_String := VL_Mensagem.TagsAsString;     //converte em string a mensagem
                VL_Mensagem.Limpar;

                VL_Mensagem.AddComando('002A', 'S');   //solicita dados pdv
                VL_Mensagem.AddTag('00DA', 'DIGITE O CARTÃO');    //MENSAGEM A SER MOSTRADA
                VL_Mensagem.AddTag('00DD', VL_String);    //BOTOES A MOSTRAR
                VL_Mensagem.AddTag('0033', 'A');    //campo para capturar sem mascara
                DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
                    VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
                Exit;
            end
            else
            if VL_Transacao.GetTagAsAstring('00D5') = '00E7' then  // RETORNO DO CARTAO DIGITADO
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('008C', 'S');  // solicita atualizacao da tag
                VL_Mensagem.AddTag('00D9', VL_Transacao.GetTagAsAstring('0033'));                    // pan DIGITADO
                VL_Mensagem.AddTag('0062', '0000' + Copy(VL_Transacao.GetTagAsAstring('0033'), 7, 12));  //pan mascarado
                VL_Mensagem.AddTag('0036', Copy(VL_Transacao.GetTagAsAstring('0033'), 1, 6));       //bin

                DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
                    VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
                Exit;

            end;


            // solicita menu operacional
            VL_Mensagem.AddComando('00F5', 'S');
            comando00F5(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, VP_Terminal_Status, VP_Terminal_ID);
            Exit;
        end;

        // tenta mandar a mensagem para o modulo ativo

        if (VL_Adquirente_Identificacao <> '') then // tem identificacao do adquirente então tenta localizar o modulo
        begin
            VL_Mensagem.AddComando('0105', 'R'); // retorno do comando para pdv
            VL_Mensagem.AddTag('007D', VL_Transacao.TagsAsString);        // TRANSACAO
            VL_Erro := DNucleo.ModuloAddSolicitacaoIdentificacaoAdquirente(VP_Conexao_ID, VP_Transmissao_ID, VL_TempoEmperaComandao,
                VL_Adquirente_Identificacao, VL_Mensagem, cnServico);

            if VL_Erro <> 0 then
            begin
                VL_Mensagem.AddComando('00F4', 'R');  // retorno
                VL_Mensagem.AddTag('004D', VL_Erro); // retorno com erro
                Result := VL_Erro;
                GravaLog(F_ArquivoLog, 0, '.comando00F4', 'opentefnucleo', '010920221035', '', '', VL_Erro);
                DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
                    VL_Mensagem, VL_Mensagem, VP_Conexao_ID);

            end;
            Exit;
        end;

        if (VL_Bin <> '') then // tem bin então tenta localizar o modulo
        begin
            VL_RecBin := VF_Bin.RetornaBIN(VL_Bin);
            if VL_RecBin.ModuloConfID = -1 then                                                      //MODULO NAO CARREGADO PARA ESSE BIN
            begin
                VL_Mensagem.AddComando('00F4', 'R'); // retorno
                VL_Mensagem.AddTag('004D', 79); // retorno com erro
                DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
                    VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
                Exit;
            end;

            if VP_Terminal_Tipo = 'PDV' then  // CONEXAO É DO PDV
            begin
                try

                    VL_Consulta := TZQuery.Create(nil);
                    VL_Consulta.Connection := ZConexao;
                    VL_Consulta.SQL.Text := 'SELECT S_HABILITADO,S_TAG_NUMERO,S_LOJA_CODIGO, S_PDV_CODIGO FROM P_TAG_FUNCAO(' +
                        StrToSql(IntToStr(VP_Terminal_ID)) +
                        ',''MODULO'')' +
                        ' WHERE S_HABILITADO=''T'' AND S_TAG_NUMERO=''' + VL_RecBin.ModuloTag + '''';
                    VL_Consulta.Open;
                    if VL_Consulta.FieldByName('S_HABILITADO').AsString <> 'T' then
                    begin
                        VL_Mensagem.AddComando('00F4', 'R'); // retorno
                        VL_Mensagem.AddTag('004D', 79); // retorno com erro
                        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
                            VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
                        Exit;
                    end;

                    // verifica se ja tem chave
                    if VL_Transacao.GetTagAsAstring('00F1') = '' then
                    begin

                        VL_Chave00F1.AddComando('0000', '');
                        VL_Chave00F1.AddTag('00F2', VL_RecBin.ModuloTag); // tag do modulo
                        VL_Chave00F1.AddTag('0036', VL_RecBin.IIN);   // bin
                        VL_Chave00F1.AddTag('0034', VL_Transacao.GetTagAsAstring('0034'));  // id da transacao
                        VL_Chave00F1.AddTag('0091', VP_Doc);  // documento(cpf ou cnpj)
                        VL_Chave00F1.AddTag('00F9', PChar(VL_Consulta.FieldByName('S_LOJA_CODIGO').AsString)); // codigo da loja
                        VL_Chave00F1.AddTag('0107', PChar(VL_Consulta.FieldByName('S_PDV_CODIGO').AsString)); // codigo do pdv
                        VL_Chave00F1.AddTag('0108', VP_Terminal_Identificacao); // identificacao do caixa, configurador, gerenciado
                        VL_Chave00F1.AddTag('00A2', 'PDV'); // tipo do terminal

                        VL_Transacao.AddTag('00F1', VL_Chave00F1.TagsAsString);

                        VL_Mensagem.Limpar;

                        VL_Mensagem.AddComando('008C', 'S');  // solicita atualizacao da tag
                        VL_Mensagem.AddTag('00F1', VL_Chave00F1.TagsAsString);
                        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
                            VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
                        Exit;

                    end;


                    VL_Mensagem.AddComando('00F3', 'S'); // solicita saldo
                    VL_Mensagem.AddTag('007D', VL_Transacao.TagsAsString);        // TRANSACAO
                    VL_Erro := DNucleo.ModuloAddSolicitacao(VP_Conexao_ID, VP_Transmissao_ID, VL_TempoEmperaComandao,
                        VL_RecBin.ModuloConfID, VL_Mensagem, cnCaixa);

                    if VL_Erro <> 0 then
                    begin
                        VL_Mensagem.AddComando('00F4', 'R');  // retorno
                        VL_Mensagem.AddTag('004D', VL_Erro); // retorno com erro
                        Result := VL_Erro;
                        GravaLog(F_ArquivoLog, 0, '.comando00F4', 'opentefnucleo', '260820220850', '', '', VL_Erro);
                        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
                            VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
                    end;
                    Exit;

                finally
                    VL_Consulta.Close;
                    VL_Consulta.Free;
                end;
            end
            else  // CONEXAO NÃO É DO PDV E NÃO PODE FAZER VENDA
            begin
                VL_Mensagem.AddComando('00F4', 'R'); // retorno
                VL_Mensagem.AddTag('004D', 81);  // retorno com erro
                DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
                    VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
                Exit;
            end;
            // VERIFICA SE ESSE PDV TEM O MODULO_CONF LIBERADO NA LOJA

            Exit;
        end;

        VL_Mensagem.AddComando('00F4', 'R'); // retorno
        VL_Mensagem.AddTag('004D', 80);  // retorno com erro
        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, VL_TempoEmperaComandao, False, nil, VP_Transmissao_ID,
            VL_Mensagem, VL_Mensagem, VP_Conexao_ID);

    finally
        VL_Transacao.Free;
        VL_Chave00F1.Free;
        VL_Mensagem.Free;
    end;
end;

function TDNucleo.comando0105(VP_Transmissao_ID: string; VP_Tarefa_ID, VP_ModuloProID, VP_ModuloConfigID, VP_Erro: integer;
    VP_Modulo_Tag, VP_Dados: string): integer;  // SOLICITA PARA PDV
var
    VL_Chave00F1, VL_Transacao, VL_Mensagem: TMensagem;
    VL_TempoEmperaComandao: int64;
    VL_String: string;
    VL_Identificacao: string;
    VL_TerminalTipo: string;
    VL_Erro: integer;
    VL_PRegModulo: ^TRegModulo;
    VL_Consulta: TZQuery;
    VL_PDV_ID: integer;
    VL_Documento: string;
    VL_CodigoPDV: string;
    VL_CodigoLoja: string;
begin
    Result := 0;
    VL_TempoEmperaComandao := 0;
    VL_Transacao := TMensagem.Create;
    VL_Chave00F1 := TMensagem.Create;
    VL_Mensagem := TMensagem.Create;
    VL_Identificacao := '';
    VL_String := '';
    VL_Documento := '';
    VL_CodigoLoja := '';
    VL_CodigoPDV := '';
    VL_TerminalTipo := '';


    try

        VL_PRegModulo := ModuloGetReg(VP_ModuloProID);
        VL_Erro := VL_Mensagem.CarregaTags(VP_Dados);

        if VL_Erro <> 0 then
        begin
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('0026', IntToStr(VL_Erro)); // retorno com erro
            Result := VL_Erro;
            VL_PRegModulo^.Solicitacao(VL_PRegModulo^.PModulo, PChar(VP_Transmissao_ID), PChar(VL_Mensagem.TagsAsString), nil,
                VP_Tarefa_ID, VL_TempoEmperaComandao);
            GravaLog(F_ArquivoLog, 0, '.comando0105', 'opentefnucleo', '290820221427', '', '', VL_Erro);
            Exit;
        end;

        VL_Mensagem.GetTag('0051', VL_TempoEmperaComandao);       // TEMPO DO COMANDO
        if VL_TempoEmperaComandao = 0 then
            VL_Transacao.GetTag('0051', VL_TempoEmperaComandao);
        if VL_TempoEmperaComandao = 0 then
            VL_TempoEmperaComandao := 30000;

        VL_Erro := VL_Chave00F1.CarregaTags(VL_Mensagem.GetTagAsAstring('00F1'));

        if VL_Erro <> 0 then
        begin
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('0026', IntToStr(VL_Erro)); // retorno com erro
            Result := VL_Erro;
            VL_PRegModulo^.Solicitacao(VL_PRegModulo^.PModulo, PChar(VP_Transmissao_ID), PChar(VL_Mensagem.TagsAsString), nil,
                VP_Tarefa_ID, VL_TempoEmperaComandao);
            GravaLog(F_ArquivoLog, 0, '.comando0105', 'opentefnucleo', '290820221429', '', '', VL_Erro);
            Exit;
        end;


        VL_Chave00F1.GetTag('0108', VL_Identificacao);  // identificação do terminal
        VL_Chave00F1.GetTag('00F9', VL_CodigoLoja);  // codigo da loja
        VL_Chave00F1.GetTag('0107', VL_CodigoPDV);  // codigo do pdv
        VL_Chave00F1.GetTag('00A2', VL_TerminalTipo);        // tipo terminal


        if VL_TerminalTipo <> 'PDV' then
        begin
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('0026', '1'); // retorno com erro
            VL_Mensagem.AddTag('004A', 'O tipo do terminal não é PDV'); // descricao do erro
            VL_PRegModulo := ModuloGetReg(VP_ModuloProID);
            VL_PRegModulo^.Solicitacao(VL_PRegModulo^.PModulo, PChar(VP_Transmissao_ID), PChar(VL_Mensagem.TagsAsString), nil,
                VP_Tarefa_ID, VL_TempoEmperaComandao);
            Exit;
        end;

        VL_Consulta := TZQuery.Create(nil);
        VL_Consulta.Connection := ZConexao;

        VL_Consulta.Close;
        VL_String := 'SELECT P.ID, L.DOC FROM MODULO_CONF M ' +
            ' LEFT OUTER JOIN PDV_MODULO_CONF PMC ON PMC.MODULO_CONF_ID=M.ID AND  PMC.CODIGO= ' + StrToSql(VL_CodigoPDV, True) +
            ' LEFT OUTER JOIN MULTILOJA_MODULO_CONF MMC ON MMC.MODULO_CONF_ID=M.ID ' +
            ' LEFT OUTER JOIN LOJA_MODULO_CONF LMC ON LMC.MODULO_CONF_ID=M.ID and LMC.CODIGO=' + StrToSql(VL_CodigoLoja, True) +
            ' LEFT OUTER JOIN LOJA L ON  L.ID=LMC.LOJA_ID ' +
            ' LEFT OUTER JOIN PDV P ON (P.IDENTIFICACAO=' + StrToSql(VL_Identificacao, True) +
            ' or p.id= pmc.PDV_ID) AND  P.LOJA_ID=L.ID ' +
            ' WHERE M.ID=' + StrToSql(IntToStr(VP_ModuloConfigID), True) +
            ' AND (PMC.ID IS NOT NULL OR ' + StrToSql(VL_CodigoPDV, True) + ' IS NULL)';
        VL_Consulta.SQL.Text := VL_String;
        VL_Consulta.Open;

        if VL_Consulta.RecordCount <> 1 then
        begin
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('0026', '1'); // retorno com erro
            GravaLog(F_ArquivoLog, 0, '.comando0105', 'opentefnucleo', '290820221430', '', '', 1);
            VL_Mensagem.AddTag('004A', 'PDV não encontrado com essas informações'); // descricao do erro
            VL_PRegModulo^.Solicitacao(VL_PRegModulo^.PModulo, PChar(VP_Transmissao_ID), PChar(VL_Mensagem.TagsAsString), nil,
                VP_Tarefa_ID, VL_TempoEmperaComandao);
            Exit;
        end;

        VL_PDV_ID := VL_Consulta.FieldByName('ID').AsInteger;
        VL_Documento := VL_Consulta.FieldByName('DOC').AsString;

        VL_Consulta.Close;
        VL_String := 'SELECT S_HABILITADO, S_TAG_NUMERO, S_LOJA_CODIGO, S_PDV_CODIGO FROM P_TAG_FUNCAO(' +
            StrToSql(IntToStr(VL_PDV_ID)) + ', ''MODULO'') ' +
            ' WHERE S_TAG_NUMERO = ' + StrToSql(VL_PRegModulo^.Tag);
        VL_Consulta.SQL.Text := VL_String;
        VL_Consulta.Open;

        if VL_Consulta.FieldByName('S_HABILITADO').AsString <> 'T' then
        begin
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('0026', '1'); // retorno com erro
            VL_Mensagem.AddTag('004A', 'PDV não habilitado'); // descricao do erro
            VL_PRegModulo^.Solicitacao(VL_PRegModulo^.PModulo, PChar(VP_Transmissao_ID), PChar(VL_Mensagem.TagsAsString), nil,
                VP_Tarefa_ID, VL_TempoEmperaComandao);
            Exit;
        end;


        VL_Chave00F1.AddTag('00F2', VL_PRegModulo^.Tag); // tag do modulo
        VL_Chave00F1.AddTag('0109', VL_PRegModulo^.Adquirente_Identificacao); // identificacao do adquirente
        VL_Chave00F1.AddTag('0091', VL_Documento); // documento(cpf ou cnpj do estabelecimento)


        VL_Mensagem.AddTag('00F1', VL_Chave00F1.TagsAsString);  // chave da transacao

        Result := DComunicador.ServidorTransmiteSolicitacaoIdentificacao(DComunicador, VL_TempoEmperaComandao, False, nil,
            VP_Transmissao_ID, VL_Mensagem, VL_Mensagem,
            VL_TerminalTipo, VL_Identificacao);

        if Result <> 0 then
        begin
            VL_Mensagem.Limpar;
            GravaLog(F_ArquivoLog, 0, '.comando0105', 'opentefnucleo', '050920221433', '', '', Result);
            VL_Mensagem.AddComando('0026', IntToStr(Result)); // retorno com erro
            VL_PRegModulo^.Solicitacao(VL_PRegModulo^.PModulo, PChar(VP_Transmissao_ID), PChar(VL_Mensagem.TagsAsString), nil,
                VP_Tarefa_ID, VL_TempoEmperaComandao);
            Exit;
        end;
        Exit;


    finally
        VL_Transacao.Free;
        VL_Chave00F1.Free;
        VL_Mensagem.Free;
    end;

end;

function TDNucleo.comando0111(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer): integer; // solicita chave publica
var
    VL_Mensagem: TMensagem;
    VL_Erro: integer;
    VL_Adquirente_Identificacao: string;
    VL_Consulta: TZQuery;
    VL_Bin: TRecBin;
    VL_RegModulo: TRegModulo;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_Adquirente_Identificacao := '';
    try
        VL_Erro := VL_Mensagem.CarregaTags(VP_Mensagem.GetTagAsAstring('00F1'));
        if VL_Erro <> 0 then
        begin
            VL_Mensagem.AddComando('0111', 'R');  // retorno
            VL_Mensagem.AddTag('004D', IntToStr(VL_Erro)); // resposta com erro
            Result := VL_Erro;
            GravaLog(F_ArquivoLog, 0, '.comando0111', 'opentefnucleo', '020920220840', '', '', VL_Erro);
            DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, 30000, False, nil, VP_Transmissao_ID,
                VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
        end;

        if (VL_Mensagem.GetTagAsAstring('0036') <> '') then // tem bin então tenta localizar o modulo
        begin
            VL_Bin := VF_Bin.RetornaBIN(VL_Mensagem.GetTagAsAstring('0036'));
            if VL_Bin.ModuloConfID = -1 then                                                      //MODULO NAO CARREGADO PARA ESSE BIN
            begin
                VL_Mensagem.AddComando('0111', 'R');  // retorno
                VL_Mensagem.AddTag('004D', 79); // resposta com erro
                DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, 30000, False, nil, VP_Transmissao_ID, VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
                Result := 79;
                Exit;
            end;


            VP_Mensagem.AddComando('0111', 'R');   // retorno da chave

            if VP_Mensagem.GetTagAsAstring('0110') = 'C' then // tipo caixa
                VL_Erro := DNucleo.ModuloAddSolicitacao(VP_Conexao_ID, VP_Transmissao_ID, 30000,
                    vl_bin.ModuloConfID, VP_Mensagem, cnCaixa)
            else    // tipo servico
                VL_Erro := DNucleo.ModuloAddSolicitacao(VP_Conexao_ID, VP_Transmissao_ID, 30000,
                    vl_bin.ModuloConfID, VP_Mensagem, cnServico);

            if VL_Erro <> 0 then
            begin
                VL_Mensagem.AddComando('0111', 'R'); // retorno
                VL_Mensagem.AddTag('004D', VL_Erro); // retorno com erro
                Result := VL_Erro;
                GravaLog(F_ArquivoLog, 0, '.comando0111', 'opentefnucleo', '020920220845', '', '', VL_Erro);
                DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, 30000, False, nil, VP_Transmissao_ID, VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
                Exit;
            end;
            Exit;
        end;

        if (VL_Mensagem.GetTagAsAstring('0109') <> '') then // tem identificacao do adquirente então tenta localizar o modulo
        begin

            VL_RegModulo := DNucleo.ModuloGetRegAdquirencia(VL_Mensagem.GetTagAsAstring('0109'), VL_Mensagem.GetTagAsAstring('00F2'));

            if VL_RegModulo.ModuloProcID = -1 then
            begin
                VL_Mensagem.AddComando('0111', 'R');  // retorno
                VL_Mensagem.AddTag('004D', 64); // resposta com erro
                DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, 30000, False, nil, VP_Transmissao_ID, VP_Mensagem, VP_Mensagem, VP_Conexao_ID);
                Result := 64;
                Exit;
            end;

            VL_Mensagem.GetTag('0109', VL_Adquirente_Identificacao);


            VL_Mensagem.AddComando('0111', 'R'); // retorno do comando para pdv


            if VL_Mensagem.GetTagAsAstring('0110') = 'C' then  // tipo caixa
                VL_Erro := DNucleo.ModuloAddSolicitacaoIdentificacaoAdquirente(VP_Conexao_ID, VP_Transmissao_ID, 30000,
                    VL_Adquirente_Identificacao, VP_Mensagem, cnCaixa)
            else  // tipo servico
                VL_Erro := DNucleo.ModuloAddSolicitacaoIdentificacaoAdquirente(VP_Conexao_ID, VP_Transmissao_ID, 30000,
                    VL_Adquirente_Identificacao, VP_Mensagem, cnServico);


            if VL_Erro <> 0 then
            begin
                VL_Mensagem.AddComando('0111', 'R');  // retorno
                VL_Mensagem.AddTag('004D', IntToStr(VL_Erro)); // resposta com erro
                Result := VL_Erro;
                GravaLog(F_ArquivoLog, 0, '.comando0111', 'opentefnucleo', '020920220838', '', '', VL_Erro);
                DComunicador.ServidorTransmiteSolicitacaoID(DComunicador, 30000, False, nil, VP_Transmissao_ID,
                    VP_Mensagem, VP_Mensagem, VP_Conexao_ID);
                Exit;
            end;
        end;

    finally
        VL_Mensagem.Free;
    end;
end;



{$R *.lfm}

end.
