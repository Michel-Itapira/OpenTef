unit mcom;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils, comunicador, Idcontext, funcoes, LbRSA, LbAsym, LbClass;

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
        constructor Create(VP_Suspenso: boolean; VP_Transmissao_ID, VP_Dados: ansistring; VP_Procedimento: TRetorno);

    end;


    { TDMCom }

    TDMCom = class(TDataModule)
        CriptoAes: TLbRijndael;
        CriptoRsa: TLbRSA;
    private

    public
        VF_Chave, VF_IP_Caixa, VF_IP_Servico: string;
        VF_PortaCaixa, VF_PortaServico: integer;

        ModuloPublico: ansistring;
        ExpoentePublico: ansistring;
        TamanhoPublico: integer;


        function iniciar(VP_Chave, VP_IP_Caixa, VP_IP_Servico: string; VP_PortaCaixa, VP_PortaServico: integer): integer;
        function RecebeComandoCaixa(VP_Erro: integer; VP_Transmissao_ID, VP_DadosRecebidos: string; VP_Conexao_ID: integer;
            VP_ClienteIP: string; VP_Terminal_Status: TConexaoStatus): integer;
        function RecebeComandoServico(VP_Erro: integer; VP_Transmissao_ID, VP_DadosRecebidos: string; VP_Conexao_ID: integer;
            VP_ClienteIP: string; VP_Terminal_Status: TConexaoStatus): integer;

        function comando0001(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer; VP_DComunicador: TDComunicador;
            VP_Terminal_Status: TConexaoStatus; VP_ClienteIP: string): integer;
        function comando0021(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer; VP_DComunicador: TDComunicador;
            VP_Terminal_Status: TConexaoStatus): integer;
        function comando0111(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer; VP_DComunicador: TDComunicador): integer;


    end;

function iniciarconexao(VP_ArquivoLog, VP_Chave, VP_IP_Caixa, VP_IP_Servico: PChar; VP_PortaCaixa, VP_PortaServico: integer;
    VO_RetornoCaixa, VO_RetornoServico: TServidorRecebimentoLib): integer; cdecl;
function finalizaconexao(): integer; cdecl;
function respondecaixa(VP_Transmissao_ID, VP_Dados: PChar; VP_ID: integer): integer; cdecl;
function respondeservico(VP_Transmissao_ID, VP_Dados: PChar; VP_ID: integer): integer; cdecl;


var
    DMCom: TDMCom;
    F_Mensagem: TMensagem;
    F_ArquivoLog: string;
    F_Inicializado: boolean = False;
    F_ChaveTerminal: ansistring;
    F_Versao_Comunicacao: integer;
    F_ComunicadorCaixa: TDComunicador;
    F_ComunicadorServico: TDComunicador;
    F_ServidorRecebimentoLibCaixa, F_ServidorRecebimentoLibServico: TServidorRecebimentoLib;

procedure ComandoCaixa(VP_Erro: integer; VP_Transmissao_ID, VP_DadosRecebidos: string; VP_Conexao_ID: integer;
    VP_Terminal_Tipo: string; VP_Terminal_ID: integer; VP_DOC: string; VP_Terminal_Status: TConexaoStatus;
    VP_Terminal_Identificacao: string; VP_Permissao: TPermissao; VP_ClienteIP: string);
procedure ComandoServico(VP_Erro: integer; VP_Transmissao_ID, VP_DadosRecebidos: string; VP_Conexao_ID: integer;
    VP_Terminal_Tipo: string; VP_Terminal_ID: integer; VP_DOC: string; VP_Terminal_Status: TConexaoStatus;
    VP_Terminal_Identificacao: string; VP_Permissao: TPermissao; VP_ClienteIP: string);

implementation


{$R *.lfm}


function iniciarconexao(VP_ArquivoLog, VP_Chave, VP_IP_Caixa, VP_IP_Servico: PChar; VP_PortaCaixa, VP_PortaServico: integer;
    VO_RetornoCaixa, VO_RetornoServico: TServidorRecebimentoLib): integer; cdecl;
begin
    F_ArquivoLog := VP_ArquivoLog;
    DMCom := TDMCom.Create(nil);
    Result := DMCom.iniciar(VP_Chave, VP_IP_Caixa, VP_IP_Servico, VP_PortaCaixa, VP_PortaServico);
    F_ServidorRecebimentoLibCaixa := VO_RetornoCaixa;
    F_ServidorRecebimentoLibServico := VO_RetornoServico;
end;

function finalizaconexao: integer; cdecl;
begin

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

end;

function respondecaixa(VP_Transmissao_ID, VP_Dados: PChar; VP_ID: integer): integer; cdecl;
var
    VL_Mensagem, VL_Chaves: TMensagem;
    VL_TagDados: string;
    VL_ModuloPublico: ansistring;
    VL_ExpoentePublico: ansistring;
    VL_TamanhoPublico: int64;
    VL_Rsa: TLbRSA;

begin
    try
        VL_TagDados := '';
        VL_Mensagem := TMensagem.Create;
        VL_Chaves := TMensagem.Create;
        VL_Rsa := TLbRSA.Create(nil);

        Result := VL_Mensagem.CarregaTags(VP_Dados);

        if Result <> 0 then
        begin
            GravaLog(F_ArquivoLog, 0, '', 'mcom', '290820221240', '', '', Result);
            Exit;
        end;

        VL_ModuloPublico := '';
        VL_ExpoentePublico := '';
        VL_TamanhoPublico := 0;


        if VL_Mensagem.GetTag('00E3', VL_TagDados) = 0 then
        begin

            VL_Mensagem.GetTag('00E4', VL_TamanhoPublico);        //tamanho chave
            VL_Mensagem.GetTag('0027', VL_ExpoentePublico);        //expoente
            VL_Mensagem.GetTag('0008', VL_ModuloPublico);        //modulos


            if (VL_ModuloPublico = '') or (VL_ExpoentePublico = '') then
            begin
                VL_Chaves.AddComando('0111', 'S'); // solicita chaves publicas
                VL_Chaves.AddTag('00F1', VL_Mensagem.GetTagAsAstring('00F1'));  //CHAVE

                //Result := F_ComunicadorServico.ServidorTransmiteSolicitacaoID(F_ComunicadorServico, 30000, True, nil, '', VL_Chaves, VL_Chaves, VP_ID);
                Result := F_ComunicadorCaixa.ServidorTransmiteSolicitacaoID(F_ComunicadorCaixa, 30000, True, nil, '', VL_Chaves, VL_Chaves, VP_ID);

                if Result <> 0 then
                begin
                    GravaLog(F_ArquivoLog, 0, '', 'mcom', '310820221737', '', '', Result);
                    Exit;
                end;


                VL_Chaves.GetTag('00E4', VL_TamanhoPublico);        //tamanho chave
                VL_Chaves.GetTag('0027', VL_ExpoentePublico);        //expoente
                VL_Chaves.GetTag('0008', VL_ModuloPublico);        //modulos

                if (VL_ModuloPublico = '') or (VL_ExpoentePublico = '') then
                    Result := 98;

                if Result <> 0 then
                begin
                    GravaLog(F_ArquivoLog, 0, '', 'mcom', '310820221737', '', '', Result);
                    Exit;
                end;

            end;



            VL_Mensagem.AddTag('00E4', DMCom.TamanhoPublico);        //tamanho chave
            VL_Mensagem.AddTag('0027', DMCom.ExpoentePublico);        //expoente
            VL_Mensagem.AddTag('0008', DMCom.ModuloPublico);        //modulos


            VL_Rsa.PublicKey.KeySize := TLbAsymKeySize(VL_TamanhoPublico);
            VL_Rsa.PublicKey.ExponentAsString := VL_ExpoentePublico;
            VL_Rsa.PublicKey.ModulusAsString := VL_ModuloPublico;

            if VL_TagDados <> '' then
                VL_TagDados := VL_Rsa.EncryptString(VL_TagDados);
            VL_Mensagem.AddTag('00E3', VL_TagDados);        //modulos

        end;

        Result := F_ComunicadorCaixa.ServidorTransmiteSolicitacaoID(F_ComunicadorCaixa, 3000, False, nil, VP_Transmissao_ID, VL_Mensagem, F_Mensagem, VP_ID);
        if Result <> 0 then
        begin
            GravaLog(F_ArquivoLog, 0, '', 'mcom', '200920221311', '', '', Result);
            Exit;
        end;
    finally
        VL_Mensagem.Free;
        VL_Chaves.Free;
        VL_Rsa.Free;
    end;
end;

function respondeservico(VP_Transmissao_ID, VP_Dados: PChar; VP_ID: integer): integer; cdecl;
var
    VL_Mensagem, VL_Chaves: TMensagem;
    VL_TagDados: string;
    VL_ModuloPublico: ansistring;
    VL_ExpoentePublico: ansistring;
    VL_TamanhoPublico: int64;
    VL_Rsa: TLbRSA;

begin
    try
        VL_TagDados := '';
        VL_Mensagem := TMensagem.Create;
        VL_Chaves := TMensagem.Create;
        VL_Rsa := TLbRSA.Create(nil);

        Result := VL_Mensagem.CarregaTags(VP_Dados);

        if Result <> 0 then
        begin
            GravaLog(F_ArquivoLog, 0, '', 'mcom', '290820221350', '', '', Result);
            Exit;
        end;


        VL_ModuloPublico := '';
        VL_ExpoentePublico := '';
        VL_TamanhoPublico := 0;



        if VL_Mensagem.GetTag('00E3', VL_TagDados) = 0 then
        begin

            VL_Mensagem.GetTag('00E4', VL_TamanhoPublico);        //tamanho chave
            VL_Mensagem.GetTag('0027', VL_ExpoentePublico);        //expoente
            VL_Mensagem.GetTag('0008', VL_ModuloPublico);        //modulos

            if (VL_ModuloPublico = '') or (VL_ExpoentePublico = '') then
            begin
                VL_Chaves.AddComando('0111', 'S');
                VL_Chaves.AddTag('00F1', VL_Mensagem.GetTagAsAstring('00F1'));
                Result := F_ComunicadorServico.ServidorTransmiteSolicitacaoID(F_ComunicadorServico, 30000, True, nil, '', VL_Chaves, VL_Chaves, VP_ID);

                if Result <> 0 then
                begin
                    GravaLog(F_ArquivoLog, 0, '', 'mcom', '310820221737', '', '', Result);
                    Exit;
                end;


                VL_Chaves.GetTag('00E4', VL_TamanhoPublico);        //tamanho chave
                VL_Chaves.GetTag('0027', VL_ExpoentePublico);        //expoente
                VL_Chaves.GetTag('0008', VL_ModuloPublico);        //modulos

                if (VL_ModuloPublico = '') or (VL_ExpoentePublico = '') then
                    Result := 98;

                if Result <> 0 then
                begin
                    GravaLog(F_ArquivoLog, 0, '', 'mcom', '310820221737', '', '', Result);
                    Exit;
                end;

            end;


            VL_Mensagem.AddTag('00E4', DMCom.TamanhoPublico);        //tamanho chave
            VL_Mensagem.AddTag('0027', DMCom.ExpoentePublico);        //expoente
            VL_Mensagem.AddTag('0008', DMCom.ModuloPublico);        //modulos


            VL_Rsa.PublicKey.KeySize := TLbAsymKeySize(VL_TamanhoPublico);
            VL_Rsa.PublicKey.ExponentAsString := VL_ExpoentePublico;
            VL_Rsa.PublicKey.ModulusAsString := VL_ModuloPublico;

            VL_TagDados := VL_Rsa.EncryptString(VL_TagDados);
            VL_Mensagem.AddTag('00E3', VL_TagDados);        //modulos

        end;

        Result := F_ComunicadorServico.ServidorTransmiteSolicitacaoID(F_ComunicadorServico, 3000, False, nil, VP_Transmissao_ID,
            VL_Mensagem, F_Mensagem, VP_ID);
        if Result <> 0 then
        begin
            GravaLog(F_ArquivoLog, 0, '', 'mcom', '200920221312', '', '', Result);
            Exit;
        end;
    finally
        VL_Chaves.Free;
        VL_Mensagem.Free;
        VL_Rsa.Free;
    end;
end;

{ ThProcesso }

procedure ThProcesso.Execute;
begin
    sleep(5000);
    fprocedimento(PChar(fTransmissaoID), 0, 1, PChar('tok' + fdados));
end;

constructor ThProcesso.Create(VP_Suspenso: boolean; VP_Transmissao_ID, VP_Dados: ansistring; VP_Procedimento: TRetorno);
begin
    FreeOnTerminate := True;
    fdados := VP_Dados;
    fTransmissaoID := VP_Transmissao_ID;
    fprocedimento := VP_Procedimento;
    inherited Create(VP_Suspenso);
end;

procedure ComandoCaixa(VP_Erro: integer; VP_Transmissao_ID, VP_DadosRecebidos: string; VP_Conexao_ID: integer;
    VP_Terminal_Tipo: string; VP_Terminal_ID: integer; VP_DOC: string; VP_Terminal_Status: TConexaoStatus;
    VP_Terminal_Identificacao: string; VP_Permissao: TPermissao; VP_ClienteIP: string);
begin
    DMCom.RecebeComandoCaixa(VP_Erro, VP_Transmissao_ID, VP_DadosRecebidos, VP_Conexao_ID, VP_ClienteIP, VP_Terminal_Status);
end;

procedure ComandoServico(VP_Erro: integer; VP_Transmissao_ID, VP_DadosRecebidos: string; VP_Conexao_ID: integer;
    VP_Terminal_Tipo: string; VP_Terminal_ID: integer; VP_DOC: string; VP_Terminal_Status: TConexaoStatus;
    VP_Terminal_Identificacao: string; VP_Permissao: TPermissao; VP_ClienteIP: string);
begin
    DMCom.RecebeComandoServico(VP_Erro, VP_Transmissao_ID, VP_DadosRecebidos, VP_Conexao_ID, VP_ClienteIP, VP_Terminal_Status);
end;


function TDMCom.iniciar(VP_Chave, VP_IP_Caixa, VP_IP_Servico: string; VP_PortaCaixa, VP_PortaServico: integer): integer;
begin
    Result := 1;

    VF_Chave := VP_Chave;

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



    F_ComunicadorCaixa.V_ServidorRecebimento := @ComandoCaixa;
    F_ComunicadorCaixa.V_ArquivoLog := F_ArquivoLog;
    F_ComunicadorCaixa.IdTCPServidor.DefaultPort := VP_PortaCaixa;
    F_ComunicadorCaixa.IdTCPServidor.Active := True;

    F_ComunicadorServico.V_ServidorRecebimento := @ComandoServico;
    F_ComunicadorServico.V_ArquivoLog := F_ArquivoLog;
    F_ComunicadorServico.IdTCPServidor.DefaultPort := VP_PortaServico;
    F_ComunicadorServico.IdTCPServidor.Active := True;

    F_Mensagem := TMensagem.Create;

    Result := 0;
end;

function TDMCom.RecebeComandoCaixa(VP_Erro: integer; VP_Transmissao_ID, VP_DadosRecebidos: string; VP_Conexao_ID: integer;
    VP_ClienteIP: string; VP_Terminal_Status: TConexaoStatus): integer;
var
    VL_Mensagem: TMensagem;
    VL_DadosCriptografados: string;

begin
    VL_DadosCriptografados := '';

    if VP_Erro = 96 then
    begin
        F_ServidorRecebimentoLibCaixa(VP_Erro, PChar(VP_Transmissao_ID), PChar(VP_DadosRecebidos), PChar(VP_ClienteIP),
            VP_Conexao_ID, PChar(VF_Chave));
        Exit;
    end;

    VL_Mensagem := TMensagem.Create;

    if VL_Mensagem.CarregaTags(VP_DadosRecebidos) <> 0 then
    begin
        F_ComunicadorCaixa.DesconectarClienteID(F_ComunicadorCaixa, VP_Conexao_ID);
        Exit;
    end;
    if VF_IP_Caixa <> '' then
    begin
        if VF_IP_Caixa <> VP_ClienteIP then
        begin
            F_ComunicadorCaixa.DesconectarClienteID(F_ComunicadorCaixa, VP_Conexao_ID);
            Exit;
        end;
    end;

    VL_DadosCriptografados := VL_Mensagem.GetTagAsAstring('00E3');
    if VL_DadosCriptografados <> '' then
    begin
        VL_DadosCriptografados := CriptoRsa.DecryptString(VL_DadosCriptografados);
        VL_Mensagem.AddTag('007D', VL_DadosCriptografados);
        VP_DadosRecebidos := VL_Mensagem.TagsAsString;
    end;


    case VL_Mensagem.Comando() of
        '0001': comando0001(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, F_ComunicadorCaixa, VP_Terminal_Status, VP_ClienteIP);
        '0021': comando0021(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, F_ComunicadorCaixa, VP_Terminal_Status);
        '0111': comando0111(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, F_ComunicadorCaixa);
        else
            F_ServidorRecebimentoLibCaixa(VP_Erro, PChar(VP_Transmissao_ID), PChar(VP_DadosRecebidos), PChar(VP_ClienteIP),
                VP_Conexao_ID, PChar(VF_Chave));
    end;
    VL_Mensagem.Free;

    Result := 0;

end;

function TDMCom.RecebeComandoServico(VP_Erro: integer; VP_Transmissao_ID, VP_DadosRecebidos: string; VP_Conexao_ID: integer;
    VP_ClienteIP: string; VP_Terminal_Status: TConexaoStatus): integer;
var
    VL_Mensagem: TMensagem;
    VL_DadosCriptografados: string;
begin
    VL_DadosCriptografados := '';

    if VP_Erro = 96 then
    begin
        F_ServidorRecebimentoLibServico(VP_Erro, PChar(VP_Transmissao_ID), PChar(VP_DadosRecebidos), PChar(VP_ClienteIP),
            VP_Conexao_ID, PChar(VF_Chave));
        Exit;
    end;


    VL_Mensagem := TMensagem.Create;

    if VL_Mensagem.CarregaTags(VP_DadosRecebidos) <> 0 then
    begin
        F_ComunicadorServico.DesconectarClienteID(F_ComunicadorServico, VP_Conexao_ID);
        Exit;
    end;
    if VF_IP_Servico <> '' then
    begin
        if VF_IP_Servico <> VP_ClienteIP then
        begin
            F_ComunicadorServico.DesconectarClienteID(F_ComunicadorServico, VP_Conexao_ID);
            Exit;
        end;
    end;

    VL_DadosCriptografados := VL_Mensagem.GetTagAsAstring('00E3');
    if VL_DadosCriptografados <> '' then
    begin
        VL_DadosCriptografados := CriptoRsa.DecryptString(VL_DadosCriptografados);
        VL_Mensagem.AddTag('007D', VL_DadosCriptografados);
        VP_DadosRecebidos := VL_Mensagem.TagsAsString;
    end;

    case VL_Mensagem.Comando() of
        '0001': comando0001(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, F_ComunicadorServico, VP_Terminal_Status, VP_ClienteIP);
        '0021': comando0021(VP_Transmissao_ID, VL_Mensagem, VP_Conexao_ID, F_ComunicadorServico, VP_Terminal_Status);
        else
            F_ServidorRecebimentoLibServico(VP_Erro, PChar(VP_Transmissao_ID), PChar(VP_DadosRecebidos), PChar(VP_ClienteIP),
                VP_Conexao_ID, PChar(VF_Chave));
    end;
    VL_Mensagem.Free;

    Result := 0;

end;

function TDMCom.comando0001(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer; VP_DComunicador: TDComunicador;
    VP_Terminal_Status: TConexaoStatus; VP_ClienteIP: string): integer;
var

    VL_Desafio: string;
    VL_String: string;
    VL_Mensagem: TMensagem;
    VL_TipoConexao: string;

begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_Desafio := '';
    VL_TipoConexao := '';

    try
        //inicio do processo
        VP_Mensagem.GetTag('0106', VL_Desafio);
        VP_Mensagem.GetTag('0110', VL_TipoConexao);

        Result := VL_Mensagem.CarregaTags(VP_Mensagem.TagsAsString);
        if Result <> 0 then
            Exit;

        VL_Mensagem.AddComando('0028', '');
        DMCom.CriptoAes.GenerateKey(VF_Chave);
        VL_Desafio := DMCom.CriptoAes.DecryptString(VL_Desafio);
        VL_String := VL_Desafio;
        VL_Desafio := Copy(VL_Desafio, 1, 5);
        if copy(VL_String, Length(VL_Desafio) + 1, 3) = '   ' then
        begin
            VL_Mensagem.AddComando('0028', 'OK'); // login aceito
            VL_Mensagem.AddTag('0106', VL_Desafio); // desafio

            if VL_TipoConexao = 'C' then // caixa
                Result := F_ServidorRecebimentoLibCaixa(0, PChar(VP_Transmissao_ID), PChar(VL_Mensagem.TagsAsString),
                    PChar(VP_ClienteIP),
                    VP_Conexao_ID, PChar(VF_Chave))
            else
                Result := F_ServidorRecebimentoLibServico(0, PChar(VP_Transmissao_ID), PChar(VL_Mensagem.TagsAsString),
                    PChar(VP_ClienteIP),
                    VP_Conexao_ID, PChar(VF_Chave));

            if Result = 0 then
            begin
                VP_Terminal_Status := csLogado;
            end
            else
            begin
                VL_Mensagem.AddComando('0029', '95');
                Result := 95;
            end;

        end
        else
        begin
            VL_Mensagem.AddComando('0029', '92');
            Result := 92;
        end;


        Result := VP_DComunicador.ServidorTransmiteSolicitacaoID(VP_DComunicador, 3000, False, nil, VP_Transmissao_ID, VL_Mensagem, F_Mensagem, VP_Conexao_ID);
        if Result <> 0 then
        begin
            GravaLog(F_ArquivoLog, 0, '', 'mcom', '200920221313', '', 'comando0001', Result);
            Exit;
        end;

    finally
        VL_Mensagem.Free;
    end;

end;

function TDMCom.comando0021(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer; VP_DComunicador: TDComunicador;
    VP_Terminal_Status: TConexaoStatus): integer;
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
    try
        if not VP_DComunicador.V_ConexaoCliente.GetSocketServidor(VP_DComunicador, VP_Conexao_ID, VL_AContext) then
        begin
            GravaLog(F_ArquivoLog, 0, '', 'mcom', '130920221654', 'Erro no comando0021 conexão do cliente não encontrada ', '', 99);
            Result := 99;
            Exit;
        end;

        VP_Mensagem.GetTag('0023', VL_Dados);
        Result := 33;
        if VP_Terminal_Status = csDesconectado then
            Exit;
        if VL_Dados <> '' then
        begin
            VP_Mensagem.GetTag('0022', VL_TChaves.ID);
            VL_TChaves := VP_DComunicador.V_ChavesDasConexoes.getChave((VL_TChaves.ID));
            if VL_TChaves.ID > 0 then
            begin
                TTConexao(VL_AContext.Data).setChaveComunicacao(VL_TChaves.ChaveComunicacao);
                try
                    if TTConexao(VL_AContext.Data).Aes.DecryptString(VL_Dados) = 'OK' then
                    begin
                        VL_Mensagem.AddComando('0024', '');
                        VL_Mensagem.TagToStr(VL_Dados);

                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('00D1', VP_Transmissao_ID);
                        VL_Mensagem.AddTag('00D2', VL_Dados);

                        TTConexao(VL_AContext.Data).Status := csChaveado;
                        VL_AContext.Connection.Socket.WriteLn(VL_Mensagem.TagsAsString);
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

function TDMCom.comando0111(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_Conexao_ID: integer; VP_DComunicador: TDComunicador): integer;
var
    VL_Mensagem: TMensagem;
begin
    try
        VL_Mensagem := TMensagem.Create;
        VL_Mensagem.AddComando('0111', 'R');
        VL_Mensagem.AddTag('0008', CriptoRsa.PublicKey.ModulusAsString);
        VL_Mensagem.AddTag('0027', CriptoRsa.PublicKey.ExponentAsString);
        VL_Mensagem.AddTag('00E4', Ord(CriptoRsa.PublicKey.KeySize));
        Result := VP_DComunicador.ServidorTransmiteSolicitacaoID(VP_DComunicador, 0, False, nil, VP_Transmissao_ID, VL_Mensagem, VL_Mensagem, VP_Conexao_ID);
        if Result <> 0 then
        begin
            GravaLog(F_ArquivoLog, 0, '', 'mcom', '200920221314', '', 'comando0111', Result);
            Exit;
        end;
    finally
        VL_Mensagem.Free;
    end;

end;




end.
