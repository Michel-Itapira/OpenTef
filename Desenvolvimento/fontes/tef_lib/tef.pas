unit tef;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils, comunicador, funcoes, def, LbRSA, LbAsym, LbClass, md5, base64;

{ TDTef }
type

    TSolicitaDadosPDV = function(VP_Menu: PChar; var VO_Botao, VO_Dados: PChar): integer; cdecl;
    TSolicitaDadosTransacao = function(VP_Mensagem: PChar; var VO_Dados: PChar): integer; cdecl;
    TImprime = function(VP_Dados: PChar): integer; cdecl;
    TMostraMenu = function(VP_Dados: PChar; var VO_Selecionado: PChar): integer; cdecl;
    TMensagemOperador = function(VP_Dados: PChar): integer; cdecl;


    TPinPadDescarrega = function(): integer; cdecl;
    TPinPadCarrega = function(VP_PinPadModelo: TPinPadModelo; VP_PinPadModeloLib, VP_PinPadModeloPorta: PChar;
        VP_RespostaPinPad: TRespostaPinPad; VP_ArquivoLog: PChar): integer; cdecl;
    TPinPadConectar = function(var VO_Mensagem: PChar): integer; cdecl;
    TPinPadDesconectar = function(VL_Mensagem: PChar): integer; cdecl;
    TPinPadMensagem = function(VL_Mensagem: PChar): integer; cdecl;
    TPinPadComando = function(VP_Processo_ID: integer; VP_Mensagem: PChar; var VO_Mensagem: PChar; VP_RespostaPinPad: TRespostaPinPad): integer; cdecl;

    TThProcesso = class(TThread)
    private
        fdados: ansistring;
        fprocedimento: TRetorno;
        ftempo: integer;
        ftransmissaoID: string;
    protected
        procedure Execute; override;
    public
        constructor Create(VP_Suspenso: boolean; VP_Transmissao_ID, VP_Dados: string; VP_Procedimento: TRetorno; VP_TempoAguarda: integer);

    end;

    { TErroMensagem }



    { ThTransacao }

    { TThTransacao }

    TThTransacao = class(TThread)
    private
        ftransacao: TTransacao;
        fcomando: string;
        ftempo: integer;
        fID: integer;
        ftransmissaoID: string;
    protected
        procedure Execute; override;
    public
        constructor Create(VP_Suspenso: boolean; VP_Comando, VP_Transmissao_ID: string; VP_Transacao: TTransacao; VP_TempoAguarda: integer);
        destructor Destroy; override;

    end;



    TDTef = class(TDataModule)
        CriptoAes: TLbRijndael;
        CriptoRsa: TLbRSA;
        procedure DataModuleDestroy(Sender: TObject);
    private
    public
    end;

function inicializar(VP_PinPadModelo: integer; VP_PinPadModeloLib, VP_PinPadModeloPorta, VP_PinPadLib, VP_ArquivoLog: PChar;
    VP_RetornoCliente: TRetornoDoCliente; VP_SolicitaDadosTransacao: TSolicitaDadosTransacao; VP_SolicitaDadosPDV: TSolicitaDadosPDV;
    VP_Imprime: TImprime; VP_MostraMenu: TMostraMenu; VP_MensagemOperador: TMensagemOperador; VP_AmbienteTeste: integer): integer; cdecl;
function finalizar(): integer; cdecl;
function login(VP_Host: PChar; VP_Porta, VP_ID: integer; VP_ChaveComunicacao: PChar; VP_Versao_Comunicacao: integer; VP_Identificador: PChar): integer; cdecl;
function desconectar(): integer; cdecl;
function solicitacao(VP_Transmissao_ID, VP_Dados: PChar; VP_Procedimento: TRetorno; VP_TempoAguarda: integer): integer; cdecl;
function solicitacaoblocante(var VO_Transmissao_ID, VP_Dados: PChar; var VO_Retorno: PChar; VP_TempoAguarda: integer): integer; cdecl;
function opentefstatus(var VO_StatusRetorno: integer): integer; cdecl;
function transacaocreate(VP_Comando, VP_IdentificadorCaixa: PChar; var VO_TransacaoID: PChar; VP_TempoAguarda: integer): integer; cdecl;
function transacaostatus(var VO_Status: integer; var VO_TransacaoChave: PChar; VP_TransacaoID: PChar): integer; cdecl;
function transacaostatusdescricao(var VO_Status: PChar; VP_TransacaoID: PChar): integer; cdecl;
function transacaogettag(VP_TransacaoID, VP_Tag: PChar; var VO_Dados: PChar): integer; cdecl;
function transacaocancela(var VO_Resposta: integer; VP_TransacaoChave, VP_TransacaoID: PChar): integer; cdecl;
procedure transacaofree(VP_TransacaoID: PChar); cdecl;
procedure alterarnivellog(VP_Nivel: integer); cdecl;

procedure SolicitaParaCliente(VP_Transmissao_ID: PChar; VP_ProcID, VP_Erro: integer; VP_Dados: PChar); cdecl;

procedure RespostaPinPad(VP_Processo_ID: integer; VP_Mensagem: TMensagem);
procedure TransacaoStatusAtualizarPDV(VP_TTransacao: TTransacao);

var
    DTef: TDTef;
    F_Identificador: ansistring;
    F_Versao_Comunicacao: integer;
    F_DComunicador: TDComunicador;
    F_ListaTransacao: TList;
    F_SolicitaDadosPDV: TSolicitaDadosPDV;
    F_SolicitaDadosTransacao: TSolicitaDadosTransacao;
    F_Imprime: TImprime;
    F_MostraMenu: TMostraMenu;
    F_MensagemOperador: TMensagemOperador;
    F_RetornoCliente: TRetornoDoCliente;

    F_PinPadModelo: TPinPadModelo;
    F_PinPadLib, F_PinPadModeloLib, F_PinPadModeloPorta: string;

    F_PinPadCarrega: TPinPadCarrega;
    F_PinPadDescarrega: TPinPadDescarrega;
    F_PinPadConectar: TPinPadConectar;
    F_PinPadDesconectar: TPinPadDesconectar;
    F_PinPadMensagem: TPinPadMensagem;
    F_PinPadComando: TPinPadComando;

    F_ArquivoLog: string;
    F_Processo_ID: integer;

    F_PinPad: THandle;

    F_ModuloPublico: ansistring;
    F_ExpoentePublico: ansistring;
    F_TamanhoPublico: integer;
    F_ChaveComunicacao: ansistring;

    F_Inicializado: boolean = False;


implementation

{$R *.lfm}

procedure SolicitaParaCliente(VP_Transmissao_ID: PChar; VP_ProcID, VP_Erro: integer; VP_Dados: PChar); cdecl;
var
    VL_Dados: PChar;
    VL_Botao: PChar;
    VL_Erro: integer;
    VL_I: integer;
    VL_DiretoOpeTef: boolean;
    VL_Mensagem, VL_TransacaoDadosPublicos, VL_Chave: TMensagem;
    VL_Tag, VL_TagDados, VL_String: string;
    VL_PinPadCarregado: boolean;
    VL_Criptografa: boolean;
    VL_ChaveTamanho: integer;
    VL_ChaveExpoente: string;
    VL_ChaveModulo: string;
    VL_Comando: string;
    VL_Chave_00F1: string;
    VL_ChaveComunicacao: string;
    VL_Transmissao_ID: string;
    VL_Rsa: TLbRSA;
    VL_Aes: TLbRijndael;
    VL_Status: integer;

    //function tmkEY(VP_Tamanho: Integer): TLbAsymKeySize;
    //begin
    //    Result := aks128;
    //    case VP_Tamanho of
    //        0: Result := aks128;
    //        1: Result := aks256;
    //        2: Result := aks512;
    //        3: Result := aks768;
    //        4: Result := aks1024;
    //    end;

    //end;

begin
    try
        try
            VL_Transmissao_ID := VP_Transmissao_ID;
            VL_ChaveExpoente := '';
            VL_ChaveModulo := '';
            VL_ChaveTamanho := 0;
            VL_Criptografa := False;
            VL_Dados := '';
            VL_Botao := '';
            VL_Tag := '';
            VL_String := '';
            VL_TagDados := '';
            VL_Comando := '';
            VL_ChaveComunicacao := '';
            VL_Mensagem := TMensagem.Create;
            VL_Chave := TMensagem.Create;
            VL_TransacaoDadosPublicos := TMensagem.Create;
            VL_Erro := 0;
            VL_PinPadCarregado := False;
            VL_Rsa := TLbRSA.Create(nil);

            VL_Aes := TLbRijndael.Create(nil);
            VL_Aes.KeySize := F_DComunicador.CriptoAes.KeySize;
            VL_Aes.CipherMode := F_DComunicador.CriptoAes.CipherMode;

            VL_Status := TransacaoStatusToInt(tsProcessando);

     {
     1º recebe uma transacao tag 007A
     solicitar o menu no open tef
     havendo erro suspende
     mostrar o menu no pdv e para

     2º recebe tag 00E3 então operadora quer que criptografe dados
      }




            //VL_DiretoOpeTef := True;

            GravaLog(F_ArquivoLog, 0, '', 'tef', '091120230930', 'Mensagem recebida no solicitaParaCliente', VP_Dados, VP_Erro, 2);


            if VP_Erro = 96 then // desconectado
            begin
                VL_Mensagem.AddComando('0026', '96');
                VL_Erro := F_RetornoCliente(PChar(VL_Mensagem.TagsAsString()), VL_Dados);
                Exit;
            end;


            vl_erro := VL_Mensagem.CarregaTags(VP_Dados);
            if VL_Erro <> 0 then
            begin
                GravaLog(F_ArquivoLog, 0, '', 'tef', '230820221655', 'Erro na SolicitaParaCliente ', '', VL_Erro, 1);
                Exit;
            end;

            VL_Mensagem.GetTag('00A4', VL_TagDados);
            if VL_TagDados <> '' then
                VL_Status := VL_Mensagem.GetTagAsInteger('00A4');

            if VL_Status = TransacaoStatusToInt(tsEfetivada) then
            begin
                Exit;
            end;

            VL_TagDados := '';
            if (VL_Mensagem.Comando() = '0111') and (VL_Mensagem.ComandoDados = 'S') then  // solicita chave publica
            begin
                VL_Mensagem.AddComando('0111', 'R'); // retorno da chave publica
                VL_Mensagem.AddTag('0024', DTef.CriptoRsa.PublicKey.ModulusAsString); //modulos
                VL_Mensagem.AddTag('0023', DTef.CriptoRsa.PublicKey.ExponentAsString);  //expoente
                VL_Mensagem.AddTag('0028', Ord(DTef.CriptoRsa.PublicKey.KeySize));   //tamanho chave

                GravaLog(F_ArquivoLog, 0, '', 'tef', '091120230941', 'Mensagem enviada no SolicitaParaCliente', VL_Mensagem.TagsAsString, 0, 2);

                VL_Erro := F_DComunicador.ClienteTransmiteSolicitacao(F_DComunicador, VL_Transmissao_ID, VL_Mensagem, VL_Mensagem, nil, 30000, False);
                if VL_Erro <> 0 then
                    GravaLog(F_ArquivoLog, 0, '', 'tef', '310820221757', 'Erro na SolicitaParaCliente ', '', VL_Erro, 1);
                Exit;
            end;

            if VL_Mensagem.Comando() = '0026' then  // comando com erro
            begin
                VL_String := VL_Mensagem.ComandoDados();
                GravaLog(F_ArquivoLog, 0, '', 'tef', '210920221056', 'SolicitaParaCliente recebeu comando com erro', '', StrToInt(VL_String), 1);
                Exit;
            end;

            if VL_Mensagem.GetTagAsAstring('00F8') = 'F' then // mensagem vinda do openTef
                VL_DiretoOpeTef := False
            else
                VL_DiretoOpeTef := True;

            VL_Comando := VL_Mensagem.Comando();
            VL_Chave_00F1 := VL_Mensagem.GetTagAsAstring('00F1'); //chave da transacao

            if not VL_DiretoOpeTef then
            begin
                VL_ChaveTamanho := VL_Mensagem.GetTagAsInteger('0028'); // chave publica tamanho MODULO,MCOM
                VL_ChaveExpoente := VL_Mensagem.GetTagAsAstring('0023'); // chave publica expoente MODULO,MCOM
                VL_ChaveModulo := VL_Mensagem.GetTagAsAstring('0024');  // chave publica modulo MODULO,MCOM

                VL_Rsa.PublicKey.KeySize := TLbAsymKeySize(VL_ChaveTamanho);
                VL_Rsa.PublicKey.ExponentAsString := VL_ChaveExpoente;
                VL_Rsa.PublicKey.ModulusAsString := VL_ChaveModulo;

                if VL_Mensagem.GetTagAsAstring('010E') <> '' then // chave de comunicacao criptografada aes da solicitação
                begin
                    VL_ChaveComunicacao := DTef.CriptoRsa.DecryptString(VL_Mensagem.GetTagAsAstring('010E'));
                    VL_TransacaoDadosPublicos.AddTag('010F', VL_Mensagem.GetTagAsAstring('010E'));
                    VL_TransacaoDadosPublicos.AddTag('010E', '');
                end
                else
                if VL_Mensagem.GetTagAsAstring('010F') <> '' then // chave de comunicacao criptografada aes da resposta
                begin
                    VL_ChaveComunicacao := F_ChaveComunicacao;
                    VL_TransacaoDadosPublicos.AddTag('010E', VL_Rsa.EncryptString(VL_ChaveComunicacao));
                    VL_TransacaoDadosPublicos.AddTag('010F', '');
                end;


                if VL_ChaveComunicacao = '' then
                begin
                    GravaLog(F_ArquivoLog, 0, '', 'tef', '240820220911', 'Erro na ThTransacao.execute', '', 84, 1);
                    Exit;
                end;

                VL_Criptografa := (VL_Mensagem.GetTag('00E3', VL_TagDados) = 0); // verifica se precisar responder criptografado

                VL_Aes.GenerateKey(VL_ChaveComunicacao);

                VL_Mensagem.GetTag('00E3', VL_TagDados);

                if VL_TagDados <> '' then
                    VL_TagDados := VL_Aes.DecryptString(VL_TagDados);

                VL_Erro := VL_Mensagem.CarregaTags(VL_TagDados);

                if VL_Erro <> 0 then
                begin
                    GravaLog(F_ArquivoLog, 0, '', 'tef', '230820221655', 'Erro na SolicitaParaCliente ', '', VL_Erro, 1);
                end;

                GravaLog(F_ArquivoLog, 0, '', 'tef', '091120231037', 'Mensagem descriptografada recebida no SolicitaParaCliente',
                    VL_Mensagem.TagsAsString, VP_Erro, 2);
            end;

            if Assigned(F_RetornoCliente) then
            begin
                VL_Erro := F_RetornoCliente(PChar(VL_Mensagem.TagsAsString()), VL_Dados);
                if VL_Erro <> 0 then
                    VL_Mensagem.AddComando('0026', PChar(IntToStr(VL_Erro))) // retorno com erro
                else
                if Assigned(VL_Dados) then
                    VL_Erro := VL_Mensagem.CarregaTags(VL_Dados);
                if VL_Erro <> 0 then
                    VL_Mensagem.AddComando('0026', PChar(IntToStr(VL_Erro))); // retorno com erro

                if VL_Mensagem.Comando() <> '' then
                begin
                    VL_String := '';

                    if VL_Criptografa then
                    begin
                        GravaLog(F_ArquivoLog, 0, '', 'tef', '091120231038', 'Mensagem descriptografada enviada no SolicitaParaCliente',
                            VL_Mensagem.TagsAsString, VP_Erro, 2);
                        VL_String := VL_Aes.EncryptString(VL_Mensagem.TagsAsString);
                    end;

                    VL_Mensagem.Limpar;

                    VL_Comando := VL_Mensagem.Comando();
                    VL_Mensagem.AddComando(VL_Comando, 'R');
                    VL_Mensagem.AddTag('00E3', VL_String);
                    VL_Mensagem.AddTag('0028', F_TamanhoPublico);        //tamanho chave
                    VL_Mensagem.AddTag('0023', F_ExpoentePublico);        //expoente
                    VL_Mensagem.AddTag('0024', F_ModuloPublico);        //modulos
                    VL_Mensagem.AddTag('00F1', VL_Chave_00F1);        // chave da transacao
                    VL_Mensagem.AddTag('010E', VL_TransacaoDadosPublicos.GetTagAsAstring('010E')); // chave de comunicacao solicitacao
                    VL_Mensagem.AddTag('010F', VL_TransacaoDadosPublicos.GetTagAsAstring('010F')); // chave de comunicacao reposta

                    GravaLog(F_ArquivoLog, 0, '', 'tef', '091120230944', 'Mensagem enviada no SolicitaParaCliente', VL_Mensagem.TagsAsString, 0, 2);

                    VL_Erro := F_DComunicador.ClienteTransmiteSolicitacao(F_DComunicador, VL_Transmissao_ID, VL_Mensagem, VL_Mensagem, nil, 30000, False);

                    if VL_Erro <> 0 then
                    begin
                        GravaLog(F_ArquivoLog, 0, '', 'tef', '230820221732', 'Erro na SolicitaParaCliente ', '', VL_Erro, 1);
                        Exit;
                    end;

                end;
            end;

        except
            on e: Exception do
            begin
                GravaLog(F_ArquivoLog, 0, '', 'tef_lib', '091120231022', 'Erro na SolicitaParaCliente ' + e.ClassName + '/' + e.Message, VP_Dados, 1, 1);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_TransacaoDadosPublicos.Free;
            VL_Chave.Free;
            VL_Aes.Free;
            VL_Rsa.Free;
        end;
    end;

end;

procedure RespostaPinPad(VP_Processo_ID: integer; VP_Mensagem: TMensagem);
begin

end;

procedure TransacaoStatusAtualizarPDV(VP_TTransacao: TTransacao);
var
    VL_Mensagem: TMensagem;
    VL_DadosSaida: PChar;
begin
    VL_Mensagem := TMensagem.Create;
    try
        try
            VL_Mensagem.AddComando('00A4', IntToStr(TransacaoStatusToInt(VP_TTransacao.STATUS)));
            VL_Mensagem.AddTag('0034', VP_TTransacao.GetID);
            VL_Mensagem.AddTag('00F1', VP_TTransacao.chaveTransacao);

            F_RetornoCliente(PChar(VL_Mensagem.TagsAsString), VL_DadosSaida);
        except
            on e: Exception do
            begin
                GravaLog(F_ArquivoLog, 0, '', 'tef_lib', '131120231502', 'Erro na VL_Mensagem ' + e.ClassName + '/' + e.Message, VP_TTransacao.AsString, 1, 1);
            end;
        end;
    finally
        VL_Mensagem.Free;
    end;
end;

{ TDTef }

procedure TDTef.DataModuleDestroy(Sender: TObject);
begin
    F_DComunicador.Free;
    DFuncoes.Free;
    F_ListaTransacao.Free;
    if F_PinPadModelo <> pNDF then
    begin
        F_PinPadDesconectar('    OpenTef    ');
        F_PinPadDescarrega;
        UnloadLibrary(F_PinPad);
    end;

end;


{ ThTransacao }

procedure TThTransacao.Execute;
var
    VL_Dados: PChar;
    VL_Botao: PChar;
    VL_Erro: integer;
    VL_I: integer;
    VL_DiretoOpeTef: boolean;
    VL_Mensagem, VL_TransacaoDadosPublicos, VL_Chave, VL_MensagemRetornada, VL_Conciliacao: TMensagem;
    VL_Tag, VL_TagDados, VL_String: string;
    VL_DadosEnviados, VL_DadosRecebidos: ansistring;
    VL_PinPadCarregado: boolean;
    VL_Criptografa: boolean;
    VL_ChaveTamanho: integer;
    VL_ChaveExpoente: string;
    VL_ChaveModulo: string;
    VL_ChaveComunicacao: string;
    VL_Rsa: TLbRSA;
    VL_Aes: TLbRijndael;
    VL_Transacao: TTransacao;
    VL_TempoLimite: longint;
    VL_Linha: string;

    //function tmkEY(VP_Tamanho: Integer): TLbAsymKeySize;
    //begin
    //    Result := aks128;
    //    case VP_Tamanho of
    //        0: Result := aks128;
    //        1: Result := aks256;
    //        2: Result := aks512;
    //        3: Result := aks768;
    //        4: Result := aks1024;
    //    end;

    //end;

begin
    try
        try
            VL_Linha := '091120231023';
            VL_ChaveExpoente := '';
            VL_ChaveModulo := '';
            VL_ChaveTamanho := 0;
            VL_Criptografa := False;
            VL_Dados := '';
            VL_Botao := '';
            VL_Tag := '';
            VL_String := '';
            VL_TagDados := '';
            VL_ChaveComunicacao := '';
            VL_DadosEnviados := '';
            VL_DadosRecebidos := '';
            VL_Mensagem := TMensagem.Create;
            VL_Chave := TMensagem.Create;
            VL_TransacaoDadosPublicos := TMensagem.Create;
            VL_MensagemRetornada := TMensagem.Create;
            VL_Conciliacao := TMensagem.Create;
            VL_Erro := 0;
            VL_PinPadCarregado := False;
            VL_Transacao := nil;

            VL_Rsa := TLbRSA.Create(nil);

            VL_Aes := TLbRijndael.Create(nil);
            VL_Aes.KeySize := F_DComunicador.CriptoAes.KeySize;
            VL_Aes.CipherMode := F_DComunicador.CriptoAes.CipherMode;

            VL_Transacao := TTransacao.Create(ftransacao.fcomando, '', '', 0, ftransacao.fMensagem.TagsAsString);
            VL_Aes.GenerateKey(F_ChaveComunicacao);

            VL_TempoLimite := DateTimeToTimeStamp(now).Time + ftempo;

     {
     1º recebe uma transacao tag 007A
     solicitar o menu no open tef
     havendo erro suspende
     mostrar o menu no pdv e para

     2º recebe tag 00E3 então operadora quer que criptografe dados
      }

            while not Terminated do
            begin

                if ftransacao.fAbortada then
                    Exit;


                VL_DiretoOpeTef := True;

                GravaLog(F_ArquivoLog, 0, '', 'tef', '091120230933', 'Mensagem recebida no TThTransacao.Execute', VL_Mensagem.TagsAsString, VL_Erro, 2);

                if VL_Erro <> 0 then
                begin
                    GravaLog(F_ArquivoLog, 0, '', 'tef', '241120231547', 'Erro na transacao', '', VL_Erro, 1);
                    ftransacao.erro := VL_Erro;
                    ftransacao.STATUS := tsComErro;
                    Exit;
                end;

                VL_Erro := VL_Mensagem.GetTagAsInteger('004D'); // TESTA SE VEIO ERRO

                if VL_Erro <> 0 then
                begin
                    GravaLog(F_ArquivoLog, 0, '', 'tef', '241120231546', 'Mensagem com erro', '', VL_Erro, 1);
                    ftransacao.erro := VL_Erro;
                    ftransacao.STATUS := tsComErro;
                    Exit;
                end;

                if DateTimeToTimeStamp(now).Time > VL_TempoLimite then // verifica se o tempo de espera foi ultrapassado
                begin
                    ftransacao.erro := 67;
                    ftransacao.STATUS := tsCancelada;
                    Exit;
                end;

                VL_TagDados := '';

                if VL_Mensagem.GetTagAsAstring('00F8') = 'F' then // mensagem de fora do opentef
                    VL_DiretoOpeTef := False
                else
                    VL_DiretoOpeTef := True;

                if not VL_DiretoOpeTef then
                begin
                    VL_ChaveTamanho := VL_Mensagem.GetTagAsInteger('0028'); // chave publica tamanho MODULO,MCOM
                    VL_ChaveExpoente := VL_Mensagem.GetTagAsAstring('0023'); // chave publica expoente MODULO,MCOM
                    VL_ChaveModulo := VL_Mensagem.GetTagAsAstring('0024');  // chave publica modulo MODULO,MCOM

                    VL_Rsa.PublicKey.KeySize := TLbAsymKeySize(VL_ChaveTamanho);
                    VL_Rsa.PublicKey.ExponentAsString := VL_ChaveExpoente;
                    VL_Rsa.PublicKey.ModulusAsString := VL_ChaveModulo;

                    if VL_Mensagem.GetTagAsAstring('010E') <> '' then // chave de comunicacao criptografada aes da solicitação
                    begin
                        VL_ChaveComunicacao := DTef.CriptoRsa.DecryptString(VL_Mensagem.GetTagAsAstring('010E'));
                        VL_TransacaoDadosPublicos.AddTag('010F', VL_Mensagem.GetTagAsAstring('010E'));
                        VL_TransacaoDadosPublicos.AddTag('010E', '');
                    end
                    else
                    if VL_Mensagem.GetTagAsAstring('010F') <> '' then // chave de comunicacao criptografada aes da resposta
                    begin
                        VL_ChaveComunicacao := F_ChaveComunicacao;
                        VL_TransacaoDadosPublicos.AddTag('010E', VL_Rsa.EncryptString(VL_ChaveComunicacao));
                        VL_TransacaoDadosPublicos.AddTag('010F', '');
                    end;

                    if VL_ChaveComunicacao = '' then
                    begin
                        ftransacao.erro := 84;
                        ftransacao.STATUS := tsComErro;
                        GravaLog(F_ArquivoLog, 0, '', 'tef', '240820220911', 'Erro na ThTransacao.execute', '', 84, 1);
                        Exit;
                    end;

                    VL_Criptografa := (VL_Mensagem.GetTag('00E3', VL_TagDados) = 0); // verifica se precisar responder criptografado

                    VL_Aes.GenerateKey(VL_ChaveComunicacao);

                    VL_Mensagem.GetTag('00E3', VL_TagDados);

                    if VL_TagDados <> '' then
                    begin
                        VL_TagDados := VL_Aes.DecryptString(VL_TagDados);

                        VL_Erro := VL_Mensagem.CarregaTags(VL_TagDados);

                        if VL_Erro <> 0 then
                        begin
                            GravaLog(F_ArquivoLog, 0, '', 'tef', '241120231548', 'Erro ao carregar a mensagem descriptografada', VL_TagDados, VL_Erro, 1);
                            ftransacao.erro := VL_Erro;
                            ftransacao.STATUS := tsComErro;
                            Exit;
                        end;
                    end;

                    GravaLog(F_ArquivoLog, 0, '', 'tef', '091120231031', 'Mensagem descriptografada recebida no TTHTransacaoExecute',
                        VL_Mensagem.TagsAsString, 0, 2);
                end;

                if ((VL_Mensagem.Comando() = '0113') and (VL_Mensagem.ComandoDados() = 'R')) then  // RETORNO DA CONCILIACAO
                begin
                    VL_Erro := VL_Conciliacao.CarregaTags(VL_Mensagem.GetTagAsAstring('0117')); // dados da conciliacao

                    if VL_Erro <> 0 then
                    begin
                        GravaLog(F_ArquivoLog, 0, '', 'tef', '241120231545', 'Erro ao carregar os dados da conciliacao',
                            VL_Mensagem.GetTagAsAstring('0117'), 0, 1);
                        ftransacao.erro := VL_Erro;
                        ftransacao.STATUS := tsComErro;
                        Exit;
                    end;

                    VL_Aes.GenerateKey(F_ChaveComunicacao);

                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('0118', 'CONCILIACAO'); // RETORNO DA CONCILIACAO
                    VL_Mensagem.AddTag('0119', VL_Conciliacao.GetTagAsInteger('0119'));

                    for VL_I := 1 to VL_Conciliacao.GetTagAsInteger('0119') do // quantidade de linha
                    begin
                        VL_Conciliacao.GetTagTabelaPosicao(VL_I, '0036', VL_TagDados); // comando com erro
                        VL_Mensagem.AddTag(VL_I, '0036', VL_TagDados);

                        VL_Erro := 0;
                        VL_Conciliacao.GetTagTabelaPosicao(VL_I, '004D', VL_TagDados); // comando com erro

                        if VL_TagDados <> '' then
                            VL_Erro := StrToInt(VL_TagDados);

                        if VL_Erro <> 0 then
                        begin
                            VL_Mensagem.AddTag(VL_I, '004D', VL_TagDados);
                            continue;
                        end;

                        VL_Conciliacao.GetTagTabelaPosicao(VL_I, '004A', VL_TagDados); // mensagem de erro
                        VL_TagDados := trim(VL_TagDados);

                        if VL_TagDados <> '' then
                        begin
                            VL_Mensagem.AddTag(VL_I, '004A', VL_TagDados);
                            continue;
                        end;

                        VL_MensagemRetornada.Limpar;

                        VL_Conciliacao.GetTagTabelaPosicao(VL_I, '00E3', VL_TagDados); // dados criptografado

                        if VL_TagDados <> '' then
                        begin
                            VL_TagDados := VL_Aes.DecryptString(VL_TagDados);
                            VL_Erro := VL_MensagemRetornada.CarregaTags(VL_TagDados);

                            if VL_Erro <> 0 then
                            begin
                                GravaLog(F_ArquivoLog, 0, '', 'tef', '241120231607', 'Erro ao carregar a mensagem descriptografada', VL_TagDados, VL_Erro, 1);
                                continue;
                                // tratar erro
                            end;

                            VL_MensagemRetornada.GetTag('004D', VL_TagDados); // comando com erro

                            if VL_TagDados <> '' then
                                VL_Erro := StrToInt(VL_TagDados);

                            if VL_Erro <> 0 then
                            begin
                                VL_Mensagem.AddTag(VL_I, '004D', VL_TagDados);
                                continue;
                            end;

                            VL_MensagemRetornada.GetTag('004A', VL_TagDados); // mensagem de erro
                            VL_TagDados := trim(VL_TagDados);

                            if VL_TagDados <> '' then
                            begin
                                VL_Mensagem.AddTag(VL_I, '004A', VL_TagDados);
                                continue;
                            end;

                            VL_MensagemRetornada.GetTag('0117', VL_TagDados); // dados da conciliacao
                        end
                        else
                        begin
                            VL_Conciliacao.GetTag('0117', VL_TagDados);  // dados da conciliacao
                        end;

                        VL_Erro := VL_MensagemRetornada.CarregaTags(VL_TagDados);

                        if VL_Erro <> 0 then
                        begin
                            GravaLog(F_ArquivoLog, 0, '', 'tef', '241120231608', 'Erro ao carregar a mensagem', VL_TagDados, VL_Erro, 1);
                            VL_Mensagem.AddTag(VL_I, '004D', IntToStr(VL_Erro));
                            continue;
                        end;

                        VL_Mensagem.AddTag(VL_I, '0117', VL_MensagemRetornada.TagsAsString); // dados da conciliacao

                    end;

                    F_RetornoCliente(PChar(VL_Mensagem.TagsAsString), VL_Dados);
                    ftransacao.STATUS := tsEfetivada;
                    exit;
                end;

                if (VL_Mensagem.Comando() = '00F5') then  // SOLICITACAO DE CAPTURA OPÇÃO DO MENU OPERACIONAL
                begin
                    VL_Erro := F_MostraMenu(PChar(VL_Mensagem.TagsAsString), VL_Botao);
                    if ftransacao.fAbortada then
                    begin
                        F_MensagemOperador(PChar('A transação foi abortada'));
                        Exit;
                    end;
                    if VL_Erro <> 0 then
                    begin
                        ftransacao.erro := VL_Erro;
                        ftransacao.STATUS := tsComErro;
                        Exit;
                    end;
                    if ((VL_Botao = '0030') or (VL_Botao = '')) then  // botao cancela
                    begin
                        ftransacao.STATUS := tsCancelada;
                        exit;
                    end
                    else
                    begin
                        ftransacao.fMensagem.AddTag('00D5', VL_Botao);
                    end;
                end
                else
                if (VL_Mensagem.Comando() = '0018') then  // SOLICITACAO DE CAPTURA OPÇÃO DO MENU DE VENDA
                begin
                    VL_Erro := F_MostraMenu(PChar(VL_Mensagem.TagsAsString), VL_Botao);
                    if ftransacao.fAbortada then
                    begin
                        F_MensagemOperador(PChar('A transação foi abortada'));
                        Exit;
                    end;
                    if VL_Erro <> 0 then
                    begin
                        ftransacao.erro := VL_Erro;
                        ftransacao.STATUS := tsComErro;
                        Exit;
                    end;
                    if ((VL_Botao = '0030') or (VL_Botao = '')) then  // botao cancela
                    begin
                        ftransacao.STATUS := tsCancelada;
                        exit;
                    end
                    else
                    begin
                        ftransacao.fMensagem.AddTag('00D5', VL_Botao);
                    end;
                end
                else
                if (VL_Mensagem.Comando() = '002A') then  // SOLICITACAO DE CAPTURA DE DADOS NO PDV
                begin
                    VL_Erro := F_SolicitaDadosPDV(PChar(VL_Mensagem.TagsAsString), VL_Botao, VL_Dados);
                    if ftransacao.fAbortada then
                    begin
                        F_MensagemOperador(PChar('A transação foi abortada'));
                        Exit;
                    end;
                    VL_Mensagem.Limpar;
                    if VL_Erro <> 0 then
                    begin
                        ftransacao.erro := VL_Erro;
                        ftransacao.STATUS := tsComErro;
                        Exit;
                    end;
                    if (VL_Botao = '0030') then  // botao cancela
                    begin
                        ftransacao.STATUS := tsCancelada;
                        exit;
                    end
                    else
                    begin
                        ftransacao.fMensagem.AddTag('00D5', VL_Botao); // botao selecionado
                        ftransacao.fMensagem.AddTag('0033', VL_Dados); // dados capturados
                    end;
                end
                else
                if (VL_Mensagem.Comando() = '008C') then  // solicitacao atualiza das tags
                begin
                    for VL_I := 1 to VL_Mensagem.TagCount do
                    begin
                        VL_Erro := VL_Mensagem.GetTag(VL_I, VL_Tag, VL_TagDados);
                        if VL_Erro <> 0 then
                        begin
                            ftransacao.erro := VL_Erro;
                            ftransacao.STATUS := tsComErro;
                            GravaLog(F_ArquivoLog, 0, '', 'tef', '240820220837', 'Erro na ThTransacao.execute', '', VL_Erro, 1);
                            Exit;
                        end;

                        if VL_Tag = '011B' then // modulo do pinpad
                        begin
                            ftransacao.fMensagem.AddTag('011B', PinPadModeloTipoToStr(F_PinPadModelo)); // modulo do pinpad
                            continue;
                        end;

                        if VL_DiretoOpeTef then
                            ftransacao.fMensagem.AddTag(VL_Tag, VL_TagDados)
                        else
                        begin
                            if VL_Tag = '00F7' then // autorizacao da venda
                            begin
                                if VL_Chave.CarregaTags(ftransacao.fMensagem.GetTagAsAstring('00F1')) = 0 then // chave da transacao
                                begin
                                    VL_Chave.AddTag(VL_Tag, VL_TagDados);
                                    ftransacao.fMensagem.AddTag('00F1', VL_Chave.TagsAsString); // chave da transacao
                                end;
                            end
                            else
                                ftransacao.fMensagem.AddTag(VL_Tag, VL_TagDados);
                        end;
                    end;
                    VL_Mensagem.Limpar;
                end
                else
                if (VL_Mensagem.Comando() = '00E1') then  // SOLICITACAO DE DADOS DA VENDA
                begin
                    VL_Erro := F_SolicitaDadosTransacao(PChar(VL_Mensagem.TagsAsString), VL_Dados);
                    if (ftransacao.fAbortada) and (F_AmbienteTeste <> 1) then
                    begin
                        F_MensagemOperador(PChar('A transação foi abortada'));
                        Exit;
                    end;
                    VL_Mensagem.Limpar;
                    if VL_Erro <> 0 then
                    begin
                        ftransacao.erro := VL_Erro;
                        ftransacao.STATUS := tsComErro;
                        Exit;
                    end;
                    VL_Erro := VL_Mensagem.CarregaTags(VL_Dados);
                    if VL_Erro <> 0 then
                    begin
                        ftransacao.erro := VL_Erro;
                        ftransacao.STATUS := tsComErro;
                        Exit;
                    end;
                    for VL_I := 1 to VL_Mensagem.TagCount do
                    begin
                        VL_Mensagem.GetTag(VL_I, VL_Tag, VL_TagDados);

                        // corrigir dados invalidos
                        if fcomando = '000A' then   // impede insersao de dados errados na aprovação da venda
                        begin
                            if (VL_Tag = '00F1') or (VL_Tag = '0028') or (VL_Tag = '0023') or (VL_Tag = '0024') or
                                (VL_Tag = '0036') or (VL_Tag = '010E') or (VL_Tag = '010F') then
                                continue;
                        end;

                        if VL_TagDados = '' then
                            ftransacao.fMensagem.AddTag(VL_Tag, PChar(#1))
                        else
                            ftransacao.fMensagem.AddTag(VL_Tag, VL_TagDados);
                    end;
                    VL_Mensagem.Limpar;
                end
                else
                if (VL_Mensagem.Comando() = '0048') then  // SOLICITACAO DE CAPTURA DO CARTÃO
                begin
                    if ftransacao.fMensagem.GetTagAsAstring('0036') = '' then
                    begin
                        if VL_PinPadCarregado then
                        else
                        begin
                            VL_Erro := F_PinPadCarrega(F_PinPadModelo, PChar(F_PinPadModeloLib), PChar(F_PinPadModeloPorta),
                                @RespostaPinPad, PChar(F_ArquivoLog));
                            if ftransacao.fAbortada then
                            begin
                                F_MensagemOperador(PChar('A transação foi abortada'));
                                Exit;
                            end;
                            if VL_Erro <> 0 then
                            begin
                                ftransacao.erro := VL_Erro;
                                ftransacao.STATUS := tsComErro;
                                Exit;
                            end;

                            VL_Erro := F_PinPadConectar(VL_Dados);
                            if VL_Erro <> 0 then
                            begin
                                ftransacao.erro := VL_Erro;
                                ftransacao.STATUS := tsComErro;
                                VL_Mensagem.CarregaTags(VL_Dados);
                                ftransacao.erroDescricao := VL_Mensagem.GetTagAsAstring('004A');
                                Exit;
                            end;

                            VL_PinPadCarregado := True;
                        end;
                        VL_Erro := F_PinPadComando(-1, PChar(VL_Mensagem.TagsAsString), VL_Dados, nil);
                        if VL_Erro <> 0 then
                        begin
                            ftransacao.erro := VL_Erro;
                            ftransacao.STATUS := tsComErro;
                            VL_Mensagem.CarregaTags(VL_Dados);
                            ftransacao.erroDescricao := VL_Mensagem.GetTagAsAstring('004A');
                            Exit;
                        end;

                        F_PinPadMensagem('    OpenTef    ');

                        VL_Erro := VL_Mensagem.CarregaTags(VL_Dados);
                        if VL_Erro <> 0 then
                        begin
                            ftransacao.erro := VL_Erro;
                            ftransacao.STATUS := tsComErro;
                            Exit;
                        end;


                        ftransacao.fMensagem.AddTag('004D', 0);
                        ftransacao.fMensagem.AddTag('0046', VL_Mensagem.GetTagAsAstring('0046'));
                        ftransacao.fMensagem.AddTag('004E', VL_Mensagem.GetTagAsAstring('004E'));
                        ftransacao.fMensagem.AddTag('004F', VL_Mensagem.GetTagAsAstring('004F'));
                        ftransacao.fMensagem.AddTag('0050', VL_Mensagem.GetTagAsAstring('0050'));
                    end;

                end
                else
                if (VL_Mensagem.Comando() = '005A') then  // SOLICITACAO DE CAPTURA DE SENHA
                begin
                    VL_Linha := '041220231333';

                    if VL_PinPadCarregado then
                    else
                    begin
                        VL_Linha := '041220231336';

                        VL_Erro := F_PinPadCarrega(F_PinPadModelo, PChar(F_PinPadModeloLib), PChar(F_PinPadModeloPorta), @RespostaPinPad, PChar(F_ArquivoLog));
                        if ftransacao.fAbortada then
                        begin
                            F_MensagemOperador(PChar('A transação foi abortada'));
                            Exit;
                        end;
                        if VL_Erro <> 0 then
                        begin
                            ftransacao.erro := VL_Erro;
                            ftransacao.STATUS := tsComErro;
                            Exit;
                        end;
                        VL_Erro := F_PinPadConectar(VL_Dados);
                        if ftransacao.fAbortada then
                        begin
                            F_MensagemOperador(PChar('A transação foi abortada'));
                            Exit;
                        end;
                        if VL_Erro <> 0 then
                        begin
                            ftransacao.erro := VL_Erro;
                            ftransacao.STATUS := tsComErro;
                            VL_Mensagem.CarregaTags(VL_Dados);
                            ftransacao.erroDescricao := VL_Mensagem.GetTagAsAstring('004A');
                            Exit;
                        end;

                        VL_PinPadCarregado := True;
                    end;

                    VL_Linha := '041220231334';

                    VL_Erro := F_PinPadComando(-1, PChar(VL_Mensagem.TagsAsString), VL_Dados, nil);
                    if VL_Erro <> 0 then
                    begin
                        ftransacao.erro := VL_Erro;
                        ftransacao.STATUS := tsComErro;
                        VL_Mensagem.CarregaTags(VL_Dados);
                        ftransacao.erroDescricao := VL_Mensagem.GetTagAsAstring('004A');
                        Exit;
                    end;

                    VL_Linha := '041220231335';

                    F_PinPadMensagem('    OpenTef    ');
                    VL_Erro := VL_Mensagem.CarregaTags(VL_Dados);
                    if VL_Erro <> 0 then
                    begin
                        ftransacao.erro := VL_Erro;
                        ftransacao.STATUS := tsComErro;
                        Exit;
                    end;

                    ftransacao.fMensagem.AddTag('004D', 0);
                    ftransacao.fMensagem.AddTag('0060', VL_Mensagem.GetTagAsAstring('0060'));
                end
                else
                if (VL_Mensagem.Comando() = '00FC') then  // MOSTRA IMAGEM PINPAD
                begin
                    if VL_PinPadCarregado then
                    else
                    begin
                        VL_Erro := F_PinPadCarrega(F_PinPadModelo, PChar(F_PinPadModeloLib), PChar(F_PinPadModeloPorta), @RespostaPinPad, PChar(F_ArquivoLog));
                        if ftransacao.fAbortada then
                        begin
                            F_MensagemOperador(PChar('A transação foi abortada'));
                            Exit;
                        end;
                        if VL_Erro <> 0 then
                        begin
                            ftransacao.erro := VL_Erro;
                            ftransacao.STATUS := tsComErro;
                            Exit;
                        end;
                        VL_Erro := F_PinPadConectar(VL_Dados);
                        if ftransacao.fAbortada then
                        begin
                            F_MensagemOperador(PChar('A transação foi abortada'));
                            Exit;
                        end;
                        if VL_Erro <> 0 then
                        begin
                            ftransacao.erro := VL_Erro;
                            ftransacao.STATUS := tsComErro;
                            VL_Mensagem.CarregaTags(VL_Dados);
                            ftransacao.erroDescricao := VL_Mensagem.GetTagAsAstring('004A');
                            Exit;
                        end;
                        VL_PinPadCarregado := True;
                    end;
                    F_PinPadMensagem('Aguarde... gerando QRCODE!');

                    VL_Erro := F_PinPadComando(-1, PChar(VL_Mensagem.TagsAsString), VL_Dados, nil);
                    if VL_Erro <> 0 then
                    begin
                        ftransacao.erro := VL_Erro;
                        ftransacao.STATUS := tsComErro;
                        VL_Mensagem.CarregaTags(VL_Dados);
                        ftransacao.erroDescricao := VL_Mensagem.GetTagAsAstring('004A');
                        Exit;
                    end;
                    VL_Erro := VL_Mensagem.CarregaTags(VL_Dados);
                    if VL_Erro <> 0 then
                    begin
                        ftransacao.erro := VL_Erro;
                        ftransacao.STATUS := tsComErro;
                        Exit;
                    end;
                    ftransacao.fMensagem.AddTag('004D', 0);
                    ftransacao.fMensagem.AddTag('00FF', 'T');
                end
                else
                if (VL_Mensagem.Comando() = '002C') then  // mensagem ao operador
                begin
                    F_MensagemOperador(PChar(VL_Mensagem.GetTagAsAstring('00DA'))); // mensagem a ser mostrada
                    if ftransacao.fAbortada then
                    begin
                        F_MensagemOperador(PChar('A transação foi abortada'));
                        Exit;
                    end;
                end;

                VL_Mensagem.GetTag('002D', VL_TagDados); // texto a ser impresso
                if VL_TagDados <> '' then // verifica se precisa imprimir
                begin
                    F_Imprime(PChar(VL_TagDados));
                    if ftransacao.fAbortada then
                    begin
                        F_MensagemOperador(PChar('A transação foi abortada'));
                        Exit;
                    end;
                end;

                if (ftransacao.fMensagem.GetTagAsAstring('0036') <> '') and (ftransacao.fMensagem.GetTagAsAstring('00F1') <> '') and
                    (VL_ChaveModulo = '') and (VL_ChaveExpoente = '') and (F_AmbienteTeste <> 1) then
                begin
                    VL_Mensagem.AddComando('0111', 'S'); // solicita troca da chave publica
                    VL_Mensagem.AddTag('0036', ftransacao.fMensagem.GetTagAsAstring('0036')); // bin
                    VL_Mensagem.AddTag('00F1', ftransacao.fMensagem.GetTagAsAstring('00F1')); // chave da transacao
                    VL_Mensagem.AddTag('0110', 'C'); // tipo de conexao

                    VL_DadosEnviados := VL_Mensagem.TagsAsString;

                    GravaLog(F_ArquivoLog, 0, '', 'tef', '091120230945', 'Mensagem enviada no TThTransacaoExecute', VL_DadosEnviados, 0, 2);

                    VL_Erro := F_DComunicador.ClienteTransmiteDados(F_DComunicador, ftransmissaoID, VL_DadosEnviados, VL_DadosRecebidos, ftempo, True);

                    if VL_Erro <> 0 then
                    begin
                        ftransacao.erro := VL_Erro;
                        ftransacao.STATUS := tsComErro;
                        GravaLog(F_ArquivoLog, 0, '', 'tef', '240820220911', 'Erro na ThTransacao.execute', '', ftransacao.erro, 1);
                        Exit;
                    end;

                    VL_Erro := VL_MensagemRetornada.CarregaTags(VL_DadosRecebidos);

                    if VL_Erro <> 0 then
                    begin
                        ftransacao.erro := VL_Erro;
                        ftransacao.STATUS := tsComErro;
                        Exit;
                    end;

                    if (VL_MensagemRetornada.Comando <> '0111') and (VL_MensagemRetornada.ComandoDados <> 'R') then
                    begin
                        ftransacao.erro := 98;
                        ftransacao.STATUS := tsComErro;
                        GravaLog(F_ArquivoLog, 0, '', 'tef', '240820220911', 'Erro na ThTransacao.execute', '', 98, 1);
                        Exit;
                    end;

                    if (VL_MensagemRetornada.GetTagAsAstring('004D') <> '0') and (VL_MensagemRetornada.GetTagAsAstring('004D') <> '') then
                    begin
                        ftransacao.erro := StrToInt(VL_MensagemRetornada.GetTagAsAstring('004D'));
                        ftransacao.STATUS := tsComErro;
                        GravaLog(F_ArquivoLog, 0, '', 'tef', '240820220911', 'Erro na ThTransacao.execute', '', ftransacao.erro, 1);
                        Exit;
                    end;

                    if (VL_MensagemRetornada.GetTagAsAstring('0023') = '') or (VL_MensagemRetornada.GetTagAsAstring('0024') = '') then
                    begin
                        ftransacao.erro := 98;
                        ftransacao.STATUS := tsComErro;
                        GravaLog(F_ArquivoLog, 0, '', 'tef', '240820220911', 'Erro na ThTransacao.execute', '', 98, 1);
                        Exit;
                    end;

                    VL_ChaveTamanho := VL_MensagemRetornada.GetTagAsInteger('0028'); // chave publica tamanho
                    VL_ChaveExpoente := VL_MensagemRetornada.GetTagAsAstring('0023'); // chave publica expoente
                    VL_ChaveModulo := VL_MensagemRetornada.GetTagAsAstring('0024');  // chave publica modulo

                    VL_Rsa.PublicKey.KeySize := TLbAsymKeySize(VL_ChaveTamanho);
                    VL_Rsa.PublicKey.ExponentAsString := VL_ChaveExpoente;
                    VL_Rsa.PublicKey.ModulusAsString := VL_ChaveModulo;

                    VL_ChaveComunicacao := F_ChaveComunicacao;
                    VL_TransacaoDadosPublicos.AddTag('010E', VL_Rsa.EncryptString(VL_ChaveComunicacao));
                    VL_TransacaoDadosPublicos.AddTag('010F', '');

                    VL_Criptografa := True;
                end;

                VL_Mensagem.AddComando(fcomando, 'S');

                if VL_Criptografa then
                begin
                    GravaLog(F_ArquivoLog, 0, '', 'tef', '091120231035', 'Mensagem descriptografada enviada no TThTransacaoExecute',
                        ftransacao.fMensagem.TagsAsString, 0, 2);

                    VL_String := VL_Aes.EncryptString(ftransacao.fMensagem.TagsAsString);

                    VL_Mensagem.AddTag('00E3', VL_String); // mensagem criptografada
                    VL_TransacaoDadosPublicos.AddComando('000A', ftransacao.fMensagem.ComandoDados());
                    VL_TransacaoDadosPublicos.AddTag('0051', ftransacao.fMensagem.GetTagAsAstring('0051'));  // tempo de espera
                    VL_TransacaoDadosPublicos.AddTag('0036', ftransacao.fMensagem.GetTagAsAstring('0036')); //  bin
                    VL_TransacaoDadosPublicos.AddTag('00F1', ftransacao.fMensagem.GetTagAsAstring('00F1')); //  chave da transacao
                    VL_Mensagem.AddTag('007D', VL_TransacaoDadosPublicos.TagsAsString);
                end
                else
                    VL_Mensagem.AddTag('007D', ftransacao.fMensagem.TagsAsString);

                VL_Mensagem.AddTag('0028', F_TamanhoPublico);        //tamanho chave
                VL_Mensagem.AddTag('0023', F_ExpoentePublico);        //expoente
                VL_Mensagem.AddTag('0024', F_ModuloPublico);        //modulos
                VL_Mensagem.AddTag('0036', ftransacao.fMensagem.GetTagAsAstring('0036')); //  bin
                VL_Mensagem.AddTag('00F1', ftransacao.fMensagem.GetTagAsAstring('00F1')); //  chave de transacao
                VL_Mensagem.AddTag('010E', VL_TransacaoDadosPublicos.GetTagAsAstring('010E')); // chave de comunicacao solicitacao
                VL_Mensagem.AddTag('010F', VL_TransacaoDadosPublicos.GetTagAsAstring('010F')); // chave de comunicacao reposta

                VL_Mensagem.GetTag('00A4', VL_TagDados);
                if VL_TagDados <> '' then
                    ftransacao.STATUS := IntToTransacaoStatus(VL_Mensagem.GetTagAsInteger('00A4'));

                if (ftransacao.STATUS <> tsProcessando) and (ftransacao.STATUS <> tsAguardandoComando) then
                begin
                    ftransacao.erroDescricao := VL_Mensagem.GetTagAsAstring('004A');
                    Exit;
                end;

                if F_AmbienteTeste = 1 then // ambiente de teste ativo
                begin

                    if (ftransacao.fMensagem.GetTagAsAstring('0036') = '') and (ftransacao.fMensagem.GetTagAsAstring('00D5') = '') then  // TESTE DE MENU
                        // mostra menu por que nao tem cartão e nao selecionou menu
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('0018', 'S'); // solicita mostra menu
                        VL_Mensagem.AddTag('0019', 'CARTÃO DIGITADO'); // menu cartao digitado
                    end
                    else
                    if (ftransacao.fMensagem.GetTagAsAstring('0036') = '') and (ftransacao.fMensagem.GetTagAsAstring('00D5') <> '') then
                        // TESTE DE CAPTURA DE DADOS DO PDV
                        // mostra menu por que nao tem cartão e nao selecionou menu
                    begin
                        if ftransacao.fMensagem.GetTagAsAstring('00D5') = '0019' then  // botao de cartao digitado
                        begin
                            VL_Mensagem.Limpar;
                            VL_Mensagem.AddComando('0000', 'S');
                            VL_Mensagem.AddTag('00E7', PChar('OK'));    //BOTAO PERSONALIZADO PARA IDENTIFICAR CARTÃO DIGITADO
                            VL_String := VL_Mensagem.TagsAsString;     //converte em string a mensagem
                            VL_Mensagem.Limpar;
                            VL_Mensagem.AddComando('002A', 'S');   //solicita dados pdv
                            VL_Mensagem.AddTag('00DA', 'DIGITE O CARTÃO');    //MENSAGEM A SER MOSTRADA
                            VL_Mensagem.AddTag('00DD', VL_String);    //BOTOES A MOSTRAR
                            VL_Mensagem.AddTag('0033', 'A');    //campo para capturar sem mascara
                        end;

                        if ftransacao.fMensagem.GetTagAsAstring('00D5') = '00E7' then  // RETONRO OPCAO DE CARTAO DIGITADO
                        begin
                            VL_Mensagem.Limpar;
                            VL_Mensagem.AddComando('008C', 'S');
                            VL_Mensagem.AddTag('00D9', ftransacao.fMensagem.GetTagAsAstring('0033'));                    // pan
                            VL_Mensagem.AddTag('0062', '0000' + Copy(ftransacao.fMensagem.GetTagAsAstring('0033'), 7, 12));  //pan mascarado
                            VL_Mensagem.AddTag('0036', Copy(ftransacao.fMensagem.GetTagAsAstring('0033'), 1, 6));       //bin
                            VL_Mensagem.AddTag('00D5', '');       //limpar botao
                        end;
                    {
                    VL_Mensagem.AddComando('002A', 'S');   //solicita dados pdv
                    VL_Mensagem.AddTag('00DA', 'DIGITE O SENHA DO CARTÃO');    //MENSAGEM A SER MOSTRADA
                    VL_Mensagem.AddTag('00DD', VL_String);    //BOTOES A MOSTRAR
                    }
                    end
                    else
                    if (ftransacao.fMensagem.GetTagAsAstring('00E8') = '') and (ftransacao.fMensagem.GetTagAsAstring('00D5') = '') then
                        //NAO TEM SENHA E NAO SELECIONOU BOTAO DA SENHA
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('0000', 'S');
                        VL_Mensagem.AddTag('00E8', PChar('OK'));    //BOTAO PERSONALIZADO PARA IDENTIFICAR CARTÃO DIGITADO
                        VL_String := VL_Mensagem.TagsAsString;     //converte em string a mensagem
                        VL_Mensagem.Limpar;
                        // mostra imagem
                        VL_Mensagem.AddComando('002A', 'S');   //solicita dados pdv
                        VL_Mensagem.AddTag('00DD', VL_String);    //BOTOES A MOSTRAR
                        VL_Mensagem.AddTag('00DA', 'DIGITE A SENHA DO CARTÃO');    //MENSAGEM A SER MOSTRADA
                        VL_Mensagem.AddTag('002E',
                            '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');

                        VL_Mensagem.AddTag('0033', 'M');    //campo para capturar com mascara
                    end
                    else
                    if (ftransacao.fMensagem.GetTagAsAstring('00E8') = '') and (ftransacao.fMensagem.GetTagAsAstring('00D5') = '00E8') then
                    begin
                        ftransacao.fMensagem.AddTag('00E8', ftransacao.fMensagem.GetTagAsAstring('0033'));
                        ftransacao.fMensagem.AddTag('00D5', '');
                    end
                    else
                    if (ftransacao.fMensagem.GetTagAsAstring('0013') = '') then
                    begin
                        VL_Mensagem.AddComando('00E1', 'S');
                        VL_Mensagem.AddTag('0013', '');    //SOLICITA VALOR DOS ITENS
                    end
                    else
                    begin
                        F_MensagemOperador(PChar('Obrigado<br>' + 'Cartão/bin:' + ftransacao.fMensagem.GetTagAsAstring('0036')));
                        if ftransacao.fAbortada then
                        begin
                            F_MensagemOperador(PChar('A transação foi abortada'));
                            Exit;
                        end;
                        F_Imprime(PChar('Comprovante<br>Autorizacao 123<br>Valor:' + ftransacao.fMensagem.GetTagAsAstring('0013')));
                        if ftransacao.fAbortada then
                        begin
                            F_MensagemOperador(PChar('A transação foi abortada'));
                            Exit;
                        end;
                        ftransacao.STATUS := tsEfetivada;
                        Exit;
                    end;
                end
                else
                begin
                    GravaLog(F_ArquivoLog, 0, '', 'tef', '091120230946', 'Mensagem enviada no TThTransacaoExecute', VL_Mensagem.TagsAsString, 0, 2);

                    VL_Erro := F_DComunicador.ClienteTransmiteSolicitacao(F_DComunicador, ftransmissaoID, VL_Mensagem, VL_Mensagem, nil, ftempo, True);
                end;

                if VL_Erro <> 0 then
                begin
                    ftransacao.erro := VL_Erro;
                    ftransacao.STATUS := tsComErro;
                    Exit;
                end;

            end;
        except
            on e: Exception do
            begin
                GravaLog(F_ArquivoLog, 0, '', 'tef_lib', VL_Linha, 'Erro de excecao na TThTransacaoExecute ' + e.ClassName + '/' + e.Message, '', 1, 1);
                ftransacao.erro := 1;
                ftransacao.STATUS := tsComErro;
            end;
        end;
    finally
        begin
            if VL_PinPadCarregado then
            begin
                F_PinPadDesconectar('    OpenTef    ');
                F_PinPadDescarrega;
            end;
            if Assigned(VL_Transacao) then
                VL_Transacao.Free;

            if ftransacao.fAbortada then
                ftransacao.Free;

            VL_Mensagem.Free;
            VL_TransacaoDadosPublicos.Free;
            VL_Chave.Free;
            VL_Rsa.Free;
            VL_Aes.Free;
            VL_MensagemRetornada.Free;
            VL_Conciliacao.Free;

            TransacaoStatusAtualizarPDV(ftransacao);
        end;
    end;
end;

constructor TThTransacao.Create(VP_Suspenso: boolean; VP_Comando, VP_Transmissao_ID: string; VP_Transacao: TTransacao; VP_TempoAguarda: integer);
begin
    fID := F_Processo_ID;
    F_Processo_ID := F_Processo_ID + 1;
    fcomando := VP_Comando;
    ftempo := VP_TempoAguarda;
    ftransacao := VP_Transacao;
    ftransacao.STATUS := tsProcessando;
    FreeOnTerminate := True;
    ftransmissaoID := VP_Transmissao_ID;
    inherited Create(VP_Suspenso);
end;

destructor TThTransacao.Destroy;
begin
    inherited Destroy;
end;

{ TDTef }


constructor TThProcesso.Create(VP_Suspenso: boolean; VP_Transmissao_ID, VP_Dados: string; VP_Procedimento: TRetorno; VP_TempoAguarda: integer);

begin
    FreeOnTerminate := True;
    fdados := VP_Dados;
    fprocedimento := VP_Procedimento;
    ftempo := VP_TempoAguarda;
    ftransmissaoID := VP_Transmissao_ID;
    inherited Create(VP_Suspenso);

end;

procedure TThProcesso.Execute;
var
    VL_Mensagem: TMensagem;
    VL_Erro: integer;
    VL_DadosSaida: PChar;
    VL_Arquivo_Dados: string;
    VL_Arquivo: TStringStream;
    VL_Comando_Dados: string;
begin
    VL_Mensagem := TMensagem.Create;
    VL_DadosSaida := '';
    VL_Arquivo_Dados := '';
    VL_Comando_Dados := '';
    VL_Arquivo := nil;
    try
        try
            VL_Erro := VL_Mensagem.CarregaTags(fdados);

            if VL_Erro <> 0 then
            begin
                GravaLog(F_ArquivoLog, 0, '', 'tef', '051220231737', 'erro ao carregar a mensagem', '', VL_Erro, 1);
                Exit;
            end;

            if VL_Mensagem.Comando = '010C' then // solicita atualizacao
            begin
                VL_Erro := F_RetornoCliente(PChar(VL_Mensagem.TagsAsString), VL_DadosSaida);
                if VL_Erro <> 0 then
                begin
                    GravaLog(F_ArquivoLog, 0, '', 'tef', '051220231736', 'erro no retornoCliente', '', VL_Erro, 1);
                    Exit;
                end;

                VL_Mensagem.Limpar;
                VL_Erro := VL_Mensagem.CarregaTags(VL_DadosSaida);
                if VL_Erro <> 0 then
                begin
                    GravaLog(F_ArquivoLog, 0, '', 'tef', '051220231713', 'erro ao carregar a mensagem', '', VL_Erro, 1);
                    Exit;
                end;

                if VL_Mensagem.ComandoDados <> '' then // caminho para salvar o tef
                begin
                    VL_Comando_Dados := VL_Mensagem.ComandoDados;
                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('010D', C_TEF_NOME); // solicita arquivo

                    GravaLog(F_ArquivoLog, 0, '', 'tef', '091120230947', 'Mensagem enviada no TThProcesso.Execute', VL_Mensagem.TagsAsString, 0, 2);

                    VL_Erro := F_DComunicador.ClienteTransmiteSolicitacao(F_DComunicador, ftransmissaoID, VL_Mensagem, VL_Mensagem, nil, 300000, True);

                    if VL_Erro <> 0 then
                    begin
                        GravaLog(F_ArquivoLog, 0, '', 'tef', '051220231710', 'Erro no TThProcesso.Execute', '', VL_Erro, 1);
                        Exit;
                    end;

                    if VL_Mensagem.Comando = '0029' then
                    begin
                        GravaLog(F_ArquivoLog, 0, '', 'tef', '051220231711', 'comando com erro no TThProcesso.Execute', '',
                            StrToInt(VL_Mensagem.ComandoDados()), 1);
                        Exit;
                    end;

                    VL_Mensagem.GetTag('010B', VL_Arquivo_Dados); // arquivo do tef
                    VL_Arquivo_Dados := DecodeStringBase64(VL_Arquivo_Dados);
                    VL_Arquivo := TStringStream.Create(VL_Arquivo_Dados);
                    VL_Arquivo.SaveToFile(PChar(VL_Comando_Dados + 'tef_lib_atualizado.' + C_TEF_EXTENSAO));
                    VL_Arquivo.Free;
                end;

                Exit;
            end;

            GravaLog(F_ArquivoLog, 0, '', 'tef', '091120230948', 'Mensagem enviada no TThProcesso.Execute', VL_Mensagem.TagsAsString, 0, 2);

            VL_Erro := F_DComunicador.ClienteTransmiteSolicitacao(F_DComunicador, ftransmissaoID, VL_Mensagem, VL_Mensagem, nil, ftempo, True);
            fprocedimento(PChar(ftransmissaoID), 0, VL_Erro, PChar(VL_Mensagem.TagsAsString));

        except
            on e: Exception do
            begin
                GravaLog(F_ArquivoLog, 0, '', 'tef_lib', '051220231712', 'Erro de excecao no TThProcesso.Execute' + e.ClassName + '/' + e.Message, '', 1, 1);
            end;

        end;
    finally
        VL_Mensagem.Free;
    end;
end;

function inicializar(VP_PinPadModelo: integer; VP_PinPadModeloLib, VP_PinPadModeloPorta, VP_PinPadLib, VP_ArquivoLog: PChar;
    VP_RetornoCliente: TRetornoDoCliente; VP_SolicitaDadosTransacao: TSolicitaDadosTransacao; VP_SolicitaDadosPDV: TSolicitaDadosPDV;
    VP_Imprime: TImprime; VP_MostraMenu: TMostraMenu; VP_MensagemOperador: TMensagemOperador; VP_AmbienteTeste: integer): integer; cdecl;
begin
    if F_Inicializado then
    begin
        Result := 112;
        Exit;
    end;

    if not Assigned(VP_RetornoCliente) then
    begin
        Result := 113;
        Exit;
    end;

    if not Assigned(VP_SolicitaDadosPDV) then
    begin
        Result := 114;
        Exit;
    end;

    if not Assigned(VP_SolicitaDadosTransacao) then
    begin
        Result := 115;
        Exit;
    end;

    if not Assigned(VP_Imprime) then
    begin
        Result := 116;
        Exit;
    end;

    if not Assigned(VP_MostraMenu) then
    begin
        Result := 117;
        Exit;
    end;

    if not Assigned(VP_MensagemOperador) then
    begin
        Result := 118;
        Exit;
    end;

    F_RetornoCliente := VP_RetornoCliente;
    F_SolicitaDadosPDV := VP_SolicitaDadosPDV;
    F_SolicitaDadosTransacao := VP_SolicitaDadosTransacao;
    F_Imprime := VP_Imprime;
    F_MostraMenu := VP_MostraMenu;
    F_MensagemOperador := VP_MensagemOperador;

    DTef := TDTef.Create(nil);
    DFuncoes := TDFuncoes.Create(nil);
    F_DComunicador := TDComunicador.Create(nil);
    F_Inicializado := True;

    DTef.CriptoRsa.KeySize := F_DComunicador.CriptoRsa.KeySize;
    DTef.CriptoRsa.GenerateKeyPair;

    F_ModuloPublico := DTef.CriptoRsa.PublicKey.ModulusAsString;
    F_ExpoentePublico := DTef.CriptoRsa.PublicKey.ExponentAsString;
    F_TamanhoPublico := Ord(DTef.CriptoRsa.PublicKey.KeySize);

    DTef.CriptoAes.KeySize := F_DComunicador.CriptoAes.KeySize;
    DTef.CriptoAes.CipherMode := F_DComunicador.CriptoAes.CipherMode;
    F_ChaveComunicacao := CriaChave(50);
    DTef.CriptoAes.GenerateKey(F_ChaveComunicacao);

    F_DComunicador.V_ClienteRecebimento := @SolicitaParaCliente;
    F_ListaTransacao := TList.Create;

    F_ArquivoLog := VP_ArquivoLog;
    F_AmbienteTeste := VP_AmbienteTeste;
    F_Processo_ID := 0;

    F_PinPadLib := VP_PinPadLib;
    F_PinPadModeloLib := VP_PinPadModeloLib;
    F_PinPadModelo := IntToPinPadModelo(VP_PinPadModelo);
    F_PinPadModeloPorta := VP_PinPadModeloPorta;


    if F_PinPadModelo <> pNDF then
    begin
        F_PinPad := LoadLibrary(PChar(F_PinPadLib));

        if F_PinPad = 0 then
        begin
            Result := 77;
            Exit;
        end;

        Pointer(F_PinPadCarrega) := GetProcAddress(F_PinPad, 'pinpadcarrega');
        Pointer(F_PinPadDescarrega) := GetProcAddress(F_PinPad, 'pinpaddescarrega');
        Pointer(F_PinPadConectar) := GetProcAddress(F_PinPad, 'pinpadconectar');
        Pointer(F_PinPadDesconectar) := GetProcAddress(F_PinPad, 'pinpaddesconectar');
        Pointer(F_PinPadComando) := GetProcAddress(F_PinPad, 'pinpadcomando');
        Pointer(F_PinPadMensagem) := GetProcAddress(F_PinPad, 'pinpadmensagem');

        Result := 0;
        // Result := F_PinPadCarrega(F_PinPadModelo,Pchar(F_PinPadModeloLib), PChar(F_PinPadModeloPorta), nil);
        // F_PinPadDescarrega;
    end
    else
        Result := 0;

end;

function finalizar(): integer; cdecl;
begin
    if not F_Inicializado then
    begin
        Result := 119;
        exit;
    end;

    DTef.Free;
    F_Inicializado := False;
    Result := 0;
end;

function login(VP_Host: PChar; VP_Porta, VP_ID: integer; VP_ChaveComunicacao: PChar; VP_Versao_Comunicacao: integer; VP_Identificador: PChar): integer; cdecl;
var
    VL_Mensagem: TMensagem;
    VL_Dados: ansistring;
    VL_Transmissao_ID: string;
    VL_Erro: ansistring;
begin
    Result := 0;
    VL_Dados := '';
    VL_Transmissao_ID := '';
    VL_Erro := '';
    VL_Mensagem := TMensagem.Create;
    try
        try
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

            if F_AmbienteTeste = 1 then      // ambiente de teste apenas faz simulação
            begin
                Result := 0;
                F_DComunicador.V_ConexaoCliente.Status := csLogado;
                F_DComunicador.V_ConexaoCliente.ConexaoAtivadada := True;
                Exit;
            end;

            if ((F_DComunicador.V_ConexaoCliente.ServidorHost <> VP_Host) or
                (F_DComunicador.V_ConexaoCliente.ServidorPorta <> VP_Porta) or
                (F_DComunicador.V_ConexaoCliente.Chave_Comunicacao <> VP_ChaveComunicacao) or
                (F_DComunicador.V_ConexaoCliente.Identificacao <> VP_Identificador) or
                (F_DComunicador.V_Versao_Comunicacao <> VP_Versao_Comunicacao)) then
            begin
                F_DComunicador.DesconectarCliente(F_DComunicador);
                F_DComunicador.V_ConexaoCliente.ServidorHost := VP_Host;
                F_DComunicador.V_ConexaoCliente.ServidorPorta := VP_Porta;
                F_DComunicador.V_ConexaoCliente.setChaveComunicacao(VP_ChaveComunicacao);
                F_DComunicador.V_ConexaoCliente.Identificacao := VP_Identificador;
                F_DComunicador.V_Versao_Comunicacao := VP_Versao_Comunicacao;
            end;

            F_DComunicador.V_ConexaoCliente.Aes.GenerateKey(VP_ChaveComunicacao);

            if F_DComunicador.V_ConexaoCliente.Status = csLogado then
            begin
                Result := 0;
                Exit;
            end;



            Result := F_DComunicador.ConectarCliente(F_DComunicador);

            if Result <> 0 then
            begin
                GravaLog(F_ArquivoLog, 0, '', 'tef_lib', '190920220851', 'Erro no login', '', Result, 1);
                Exit;
            end;



            if F_DComunicador.V_ConexaoCliente.Status > csLink then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0001', 'S'); // login
                VL_Mensagem.AddTag('00A3', IntToStr(VP_ID)); // ID
                VL_Mensagem.AddTag('0005', IntToStr(C_versao[0]) + '.' + IntToStr(C_versao[1]) + '.' + IntToStr(C_versao[2])); // versao do tef
                VL_Mensagem.AddTag('0006', IntToStr(C_mensagem)); // versao da mensageira
                VL_Mensagem.AddTag('0037', 'S');  // permissao do terminal
                VL_Mensagem.AddTag('003D', C_Programa); // NOME DA DLL

                GravaLog(F_ArquivoLog, 0, '', 'tef', '091120230949', 'Mensagem enviada no login', VL_Mensagem.TagsAsString, 0, 2);

                Result := F_DComunicador.ClienteTransmiteSolicitacao(F_DComunicador, VL_Transmissao_ID, VL_Mensagem, VL_Mensagem, nil, 10000, True);

                if Result <> 0 then
                begin
                    GravaLog(F_ArquivoLog, 0, '', 'tef_lib', '190920220849', 'Erro no login', '', Result, 1);
                    Exit;
                end;

                VL_Mensagem.GetTag('004D', VL_Erro);

                if VL_Erro <> '0' then
                begin
                    Result := StrToInt(VL_Erro);
                    Exit;
                end;

                F_DComunicador.V_ConexaoCliente.Status := csLogado;
                F_DComunicador.V_ConexaoCliente.ConexaoAtivadada := True;

                if (VL_Mensagem.GetTagAsAstring('00FD') = 'S') then  // atualizacao obrigatoria
                begin
                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('010C', 'S'); // solicita atualizacao
                    VL_Mensagem.AddTag('00FD', 'S');  // atualizacao obrigatoria

                    TThProcesso.Create(False, VL_Transmissao_ID, VL_Mensagem.TagsAsString, nil, 60000);
                end;

                if (VL_Mensagem.GetTagAsAstring('010A') = 'S') then  // atualizacao opcional
                begin

                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('010C', 'S'); // solicita atualizacao
                    VL_Mensagem.AddTag('010A', 'S');  // atualizacao obrigatoria

                    TThProcesso.Create(False, VL_Transmissao_ID, VL_Mensagem.TagsAsString, nil, 60000);
                end;

            end;
        except
            on e: Exception do
            begin
                Result := 1;
                GravaLog(F_ArquivoLog, 0, '', 'tef_lib', '271120231102', 'Erro na login ' + e.ClassName + '/' + e.Message, '', 1, 1);
            end;
        end;
    finally
        VL_Mensagem.Free;
    end;
end;

function desconectar(): integer; cdecl;
begin
    Result := F_DComunicador.DesconectarCliente(F_DComunicador);
end;

function solicitacao(VP_Transmissao_ID, VP_Dados: PChar; VP_Procedimento: TRetorno; VP_TempoAguarda: integer): integer; cdecl;
var
    VL_Th: TThProcesso;
begin
    Result := 0;
    VL_Th := TThProcesso.Create(True, VP_Transmissao_ID, VP_Dados, VP_Procedimento, VP_TempoAguarda);
    VL_Th.Start;
end;

function solicitacaoblocante(var VO_Transmissao_ID, VP_Dados: PChar; var VO_Retorno: PChar; VP_TempoAguarda: integer): integer; cdecl;
var
    VL_Transmissao_ID, VL_String: ansistring;
    VL_MensagensOUT, VL_MensagensIN: TMensagem;
begin
    VL_String := '';
    VL_Transmissao_ID := VO_Transmissao_ID;
    try
        VL_MensagensOUT := TMensagem.Create;
        VL_MensagensOUT.CarregaTags(VP_Dados);
        VL_MensagensIN := TMensagem.Create;

        GravaLog(F_ArquivoLog, 0, '', 'tef', '091120230950', 'Mensagem enviada no solicitacaoblocante', VP_Dados, 0, 2);

        Result := F_DComunicador.ClienteTransmiteSolicitacao(F_DComunicador, VL_Transmissao_ID, VL_MensagensOUT, VL_MensagensIN, nil, VP_TempoAguarda, True);

        VO_Transmissao_ID := StrAlloc(Length(VL_Transmissao_ID) + 1);
        StrPCopy(VO_Transmissao_ID, VL_Transmissao_ID);


        VL_MensagensIN.TagToStr(VL_String);

        VO_Retorno := StrAlloc(Length(VL_String) + 1);
        StrPCopy(VO_Retorno, VL_String);

    finally
        VL_MensagensIN.Free;
        VL_MensagensOUT.Free;
    end;

end;

function opentefstatus(var VO_StatusRetorno: integer): integer; cdecl;
begin
    Result := 0;
    VO_StatusRetorno := Ord(F_DComunicador.V_ConexaoCliente.Status);
    if (VO_StatusRetorno = Ord(csLogado)) and (F_AmbienteTeste <> 1) then
        Result := F_DComunicador.ClienteVerificaConexao(F_DComunicador);

    if not F_DComunicador.V_ConexaoCliente.ConexaoAtivadada then
        VO_StatusRetorno := Ord(csNaoInicializado);
end;

function transacaocreate(VP_Comando, VP_IdentificadorCaixa: PChar; var VO_TransacaoID: PChar; VP_TempoAguarda: integer): integer; cdecl;
var
    VL_Transacao: TTransacao;
    VL_Mensagem: TMensagem;
    VL_ThTransacao: TThTransacao;
    VL_Transmissao_ID, VL_Tag, VL_TagDados, VL_String: string;
    VL_I: integer;
begin
    Result := 0;
    VL_Transmissao_ID := '';
    VL_Tag := '';
    VL_TagDados := '';
    VL_String := '';
    try
        try
            VL_Mensagem := TMensagem.Create;
            VL_Mensagem.AddComando('007A', 'S');                   // cria transacao
            VL_Mensagem.AddTag('00A6', VP_IdentificadorCaixa);     // id gerado pelo pdv


            if (F_AmbienteTeste <> 1) then
            begin
                GravaLog(F_ArquivoLog, 0, '', 'tef', '091120230951', 'Mensagem enviada no transacaocreate', VL_Mensagem.TagsAsString, 0, 2);

                Result := F_DComunicador.ClienteTransmiteSolicitacao(F_DComunicador, VL_Transmissao_ID, VL_Mensagem, VL_Mensagem, nil, 10000, True);
                if Result <> 0 then
                    GravaLog(F_ArquivoLog, 0, '', 'tef_lib', '190920220854', 'Erro na transacaocreate', '', Result, 1);
            end
            else
            begin
                for VL_I := 1 to VL_Mensagem.TagCount do
                begin
                    VL_Mensagem.GetTag(VL_I, VL_Tag, VL_TagDados);

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
            end;

            VL_String := VL_Mensagem.TagsAsString;
            if F_AmbienteTeste = 1 then
                VL_String := '';
            if Result <> 0 then
                Exit;

            if (VL_Mensagem.Comando() = '007A') and (VL_Mensagem.ComandoDados() = 'R') then
            begin
                VL_Transacao := TTransacao.Create(VP_Comando, '', '', 0, VL_String);
                VO_TransacaoID := StrAlloc(Length(VL_Transacao.ID) + 1);
                StrPCopy(VO_TransacaoID, VL_Transacao.ID);
                VL_Transacao.fMensagem.AddComando('0042', '');
                VL_Transacao.fMensagem.AddTag('007D', VL_Mensagem.TagsAsString);
                VL_ThTransacao := TThTransacao.Create(True, VP_Comando, VO_TransacaoID, VL_Transacao, VP_TempoAguarda);
                F_ListaTransacao.Add(VL_Transacao);
                VL_ThTransacao.Start;
            end
            else
                Result := 61;
        except
            on e: Exception do
            begin
                Result := 58;
                GravaLog(F_ArquivoLog, 0, '', 'tef_lib', '140520221140', 'Erro na transacaocreate ' + e.ClassName + '/' + e.Message, '', 58, 1);
            end;

        end;

    finally
        VL_Mensagem.Free;
    end;
end;

function transacaostatus(var VO_Status: integer; var VO_TransacaoChave: PChar; VP_TransacaoID: PChar): integer; cdecl;
var
    VL_Transacao: TTransacao;
    VL_I: integer;
begin

    VO_Status := Ord(tsNaoLocalizada);

    if F_AmbienteTeste = 1 then // ambiente de teste ativado
    begin
        Result := opentefstatus(VO_Status);
        if VO_Status <> Ord(csLogado) then
            Exit;
    end
    else // ambiente de teste desativado
    begin
        Result := F_DComunicador.ClienteVerificaConexao(F_DComunicador);
    end;

    if Result <> 0 then
        Exit;

    try
        for VL_I := 0 to F_ListaTransacao.Count - 1 do
        begin
            Pointer(VL_Transacao) := F_ListaTransacao.Items[VL_I];
            if VL_Transacao.ID = VP_TransacaoID then
            begin
                Result := VL_Transacao.Erro;
                VO_Status := Ord(VL_Transacao.Status);
                VO_TransacaoChave := PChar(VL_Transacao.ChaveTransacao);
                Exit;
            end;
        end;

    except
        on e: Exception do
        begin
            Result := 59;
            GravaLog(F_ArquivoLog, 0, '', 'tef_lib', '140520221200', 'Erro na transacaostatus ' + e.ClassName + '/' + e.Message, '', 59, 1);
        end;
    end;

end;

function transacaostatusdescricao(var VO_Status: PChar; VP_TransacaoID: PChar): integer; cdecl;
var
    VL_Transacao: TTransacao;
    VL_I: integer;
    //   VL_Codigo: integer;
begin
    Result := 0;

    VO_Status := StrAlloc(2);
    StrPCopy(VO_Status, '');
    try
        for VL_I := 0 to F_ListaTransacao.Count - 1 do
        begin
            Pointer(VL_Transacao) := F_ListaTransacao.Items[VL_I];
            if VL_Transacao.ID = VP_TransacaoID then
            begin
                Result := VL_Transacao.Erro;
                VO_Status := StrAlloc(Length(VL_Transacao.erroDescricao) + 1);
                StrPCopy(VO_Status, VL_Transacao.erroDescricao);
                Exit;
            end;
        end;
    except
        on e: Exception do
        begin
            Result := 59;
            GravaLog(F_ArquivoLog, 0, '', 'tef_lib', '140520221200', 'Erro na transacaostatus ' + e.ClassName + '/' + e.Message, '', 59, 1);
        end;
    end;

end;

function transacaogettag(VP_TransacaoID, VP_Tag: PChar; var VO_Dados: PChar): integer; cdecl;
var
    VL_Transacao: TTransacao;
    VL_I: integer;
begin
    Result := 0;

    VO_Dados := StrAlloc(2);
    StrPCopy(VO_Dados, '');

    if ((VP_Tag = '00E8') or (VP_Tag = '00E7')) then
    begin
        Result := 120;
        Exit;
    end;

    try
        for VL_I := 0 to F_ListaTransacao.Count - 1 do
        begin
            Pointer(VL_Transacao) := F_ListaTransacao.Items[VL_I];
            if VL_Transacao.ID = VP_TransacaoID then
            begin
                VO_Dados := StrAlloc(Length(VL_Transacao.fMensagem.GetTagAsAstring(VP_Tag)) + 1);
                StrPCopy(VO_Dados, VL_Transacao.fMensagem.GetTagAsAstring(VP_Tag));
                Exit;
            end;
        end;
    except
        on e: Exception do
        begin
            Result := 119;
            GravaLog(F_ArquivoLog, 0, '', 'tef_lib', '142921112023', 'Erro na transacaogettag ' + e.ClassName + '/' + e.Message, '', 119, 1);
        end;
    end;
end;

function transacaocancela(var VO_Resposta: integer; VP_TransacaoChave, VP_TransacaoID: PChar): integer; cdecl;
begin
    Result := 0;

    //try

    //except
    //    on e: Exception do
    //    begin
    //        Result := 86;
    //        GravaLog(F_ArquivoLog, 0, '', 'tef_lib', '140520221200', 'Erro na transacaocancela ' + e.ClassName + '/' + e.Message, '', 86);
    //    end;
    //end;

end;

procedure transacaofree(VP_TransacaoID: PChar); cdecl;
var
    VL_I: integer;
    VL_Transacao: TTransacao;
begin
    try
        for VL_I := 0 to F_ListaTransacao.Count - 1 do
        begin
            Pointer(VL_Transacao) := F_ListaTransacao.Items[VL_I];
            if VL_Transacao.ID = VP_TransacaoID then
            begin
                F_ListaTransacao.Remove(VL_Transacao);
                if ((VL_Transacao.STATUS <> tsProcessando) and (VL_Transacao.STATUS <> tsAguardandoComando)) then
                    VL_Transacao.Free
                else
                    VL_Transacao.fAbortada := True;
                Exit;
            end;
        end;
    except
        on e: Exception do
        begin
            GravaLog(F_ArquivoLog, 0, '', 'tef_lib', '140520221225', 'Erro na transacaofree ' + e.ClassName + '/' + e.Message, '', 60, 1);
        end;
    end;

end;

procedure alterarnivellog(VP_Nivel: integer); cdecl;
begin
    F_NivelLog := VP_Nivel;
end;

end.
