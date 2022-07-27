unit mcom;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils, comunicador, Idcontext, funcoes, LbRSA,LbAsym;

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
      CriptoRsa: TLbRSA;
    private

    public
        VF_Chave, VF_IP_Caixa, VF_IP_Servico: string;
        VF_PortaCaixa, VF_PortaServico: integer;

        ModuloPublico: ansistring;
        ExpoentePublico: ansistring;
        TamanhoPublico: integer;


        function iniciar(VP_Chave, VP_IP_Caixa, VP_IP_Servico: string; VP_PortaCaixa, VP_PortaServico: integer): integer;
        function RecebeComandoCaixa(VP_Codigo: integer; VP_Transmissao_ID, VP_DadosRecebidos: string; VP_AContext: TIdContext): integer;
        function RecebeComandoServico(VP_Codigo: integer; VP_Transmissao_ID, VP_DadosRecebidos: string; VP_AContext: TIdContext): integer;

        function comando0001(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext; VP_DComunicador: TDComunicador): integer;
        function comando0021(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext; VP_DComunicador: TDComunicador): integer;


    end;

function iniciarconexao(VP_ArquivoLog, VP_Chave, VP_IP_Caixa, VP_IP_Servico: PChar; VP_PortaCaixa, VP_PortaServico: integer;
    VO_RetornoCaixa, VO_RetornoServico: TServidorRecebimentoLib): integer; stdcall;
function finalizaconexao(): integer; stdcall;
function respondecaixa(VP_Transmissao_ID, VP_Dados: PChar; VP_ID: integer): integer; stdcall;
function respondeservico(VP_Transmissao_ID, VP_Dados: PChar; VP_ID: integer): integer; stdcall;


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

procedure ComandoCaixa(VP_Codigo: integer; VP_Transmissao_ID, VP_DadosRecebidos: string; var VP_AContext: TIdContext);
procedure ComandoServico(VP_Codigo: integer; VP_Transmissao_ID, VP_DadosRecebidos: string; var VP_AContext: TIdContext);

implementation


{$R *.lfm}


function iniciarconexao(VP_ArquivoLog, VP_Chave, VP_IP_Caixa, VP_IP_Servico: PChar; VP_PortaCaixa, VP_PortaServico: integer;
    VO_RetornoCaixa, VO_RetornoServico: TServidorRecebimentoLib): integer; stdcall;
begin
    F_ArquivoLog := VP_ArquivoLog;
    DMCom := TDMCom.Create(nil);
    Result := DMCom.iniciar(VP_Chave, VP_IP_Caixa, VP_IP_Servico, VP_PortaCaixa, VP_PortaServico);
    F_ServidorRecebimentoLibCaixa := VO_RetornoCaixa;
    F_ServidorRecebimentoLibServico := VO_RetornoServico;
end;

function finalizaconexao: integer; stdcall;
begin

    if Assigned(F_ComunicadorCaixa.V_ThRecebeEscuta) then
    begin
        F_ComunicadorCaixa.V_ThRecebeEscuta.Parar;
        F_ComunicadorCaixa.V_ThRecebeEscuta.Terminate;
    end;

    if Assigned(F_ComunicadorServico.V_ThRecebeEscuta) then
    begin
        F_ComunicadorServico.V_ThRecebeEscuta.Parar;
        F_ComunicadorServico.V_ThRecebeEscuta.Terminate;
    end;


    F_ComunicadorCaixa.DesconectarCliente;
    F_ComunicadorServico.DesconectarCliente;

    F_ComunicadorServico.Free;
    F_ComunicadorCaixa.Free;
    DMCom.Free;
    F_Mensagem.Free;
    Result := 0;

end;

function respondecaixa(VP_Transmissao_ID, VP_Dados: PChar; VP_ID: integer): integer; stdcall;
var
    VL_Mensagem: TMensagem;
    VL_TagDados: string;
    VL_ModuloPublico: ansistring;
    VL_ExpoentePublico: ansistring;
    VL_TamanhoPublico: Int64;
    VL_Rsa:TLbRSA;

begin
    try
        VL_TagDados := '';
        VL_Mensagem := TMensagem.Create;
        VL_Rsa:=TLbRSA.Create(NIL);
        Result := VL_Mensagem.CarregaTags(VP_Dados);
        VL_ModuloPublico:='';
        VL_ExpoentePublico:='';
        VL_TamanhoPublico:=0;


        if VL_Mensagem.GetTag('00E3', VL_TagDados) = 0 then
        begin

            VL_Mensagem.GetTag('00E4',VL_TamanhoPublico);        //tamanho chave
            VL_Mensagem.GetTag('0027', VL_ExpoentePublico);        //expoente
            VL_Mensagem.GetTag('0008',VL_ModuloPublico);        //modulos


            VL_Mensagem.AddTag('00E4',DMCom.TamanhoPublico);        //tamanho chave
            VL_Mensagem.AddTag('0027', DMCom.ExpoentePublico);        //expoente
            VL_Mensagem.AddTag('0008', DMCom.ModuloPublico);        //modulos


            VL_Rsa.PublicKey.KeySize:=TLbAsymKeySize(VL_TamanhoPublico);
            VL_Rsa.PublicKey.ExponentAsString:=VL_ExpoentePublico;
            VL_Rsa.PublicKey.ModulusAsString:=VL_ModuloPublico;

            if VL_TagDados<>'' then
            VL_TagDados:=VL_Rsa.EncryptString(VL_TagDados);
            VL_Mensagem.AddTag('00E3', VL_TagDados);        //modulos


        end;
        if Result <> 0 then
            Exit;
        Result := F_ComunicadorCaixa.ServidorTransmiteSolicitacaoID(3000, False, nil, VP_Transmissao_ID, VL_Mensagem, F_Mensagem, VP_ID);
    finally
        VL_Mensagem.Free;
        VL_Rsa.Free;
    end;
end;

function respondeservico(VP_Transmissao_ID, VP_Dados: PChar; VP_ID: integer): integer; stdcall;
var
    VL_Mensagem: TMensagem;
    VL_TagDados: string;
    VL_ModuloPublico: ansistring;
    VL_ExpoentePublico: ansistring;
    VL_TamanhoPublico: Int64;
    VL_Rsa:TLbRSA;

begin
    try
        VL_TagDados := '';
        VL_Mensagem := TMensagem.Create;
        VL_Rsa:=TLbRSA.Create(NIL);
        Result := VL_Mensagem.CarregaTags(VP_Dados);
        VL_ModuloPublico:='';
        VL_ExpoentePublico:='';
        VL_TamanhoPublico:=0;



        if VL_Mensagem.GetTag('00E3', VL_TagDados) = 0 then
        begin

            VL_Mensagem.GetTag('00E4',VL_TamanhoPublico);        //tamanho chave
            VL_Mensagem.GetTag('0027', VL_ExpoentePublico);        //expoente
            VL_Mensagem.GetTag('0008',VL_ModuloPublico);        //modulos


            VL_Mensagem.AddTag('00E4',DMCom.TamanhoPublico);        //tamanho chave
            VL_Mensagem.AddTag('0027', DMCom.ExpoentePublico);        //expoente
            VL_Mensagem.AddTag('0008', DMCom.ModuloPublico);        //modulos


            VL_Rsa.PublicKey.KeySize:=TLbAsymKeySize(VL_TamanhoPublico);
            VL_Rsa.PublicKey.ExponentAsString:=VL_ExpoentePublico;
            VL_Rsa.PublicKey.ModulusAsString:=VL_ModuloPublico;


            VL_TagDados:=VL_Rsa.EncryptString(VL_TagDados);
            VL_Mensagem.AddTag('00E3', VL_TagDados);        //modulos


        end;
        if Result <> 0 then
            Exit;
        Result := F_ComunicadorServico.ServidorTransmiteSolicitacaoID(3000, False, nil, VP_Transmissao_ID, VL_Mensagem, F_Mensagem, VP_ID);
    finally
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

procedure ComandoCaixa(VP_Codigo: integer; VP_Transmissao_ID, VP_DadosRecebidos: string; var VP_AContext: TIdContext);
begin
    DMCom.RecebeComandoCaixa(VP_Codigo, VP_Transmissao_ID, VP_DadosRecebidos, VP_AContext);
end;

procedure ComandoServico(VP_Codigo: integer; VP_Transmissao_ID, VP_DadosRecebidos: string; var VP_AContext: TIdContext);
begin
    DMCom.RecebeComandoServico(VP_Codigo, VP_Transmissao_ID, VP_DadosRecebidos, VP_AContext);
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

    self.CriptoRsa.KeySize:=F_ComunicadorCaixa.CriptoRsa.KeySize;
    self.CriptoRsa.GenerateKeyPair;


    self.ModuloPublico := self.CriptoRsa.PublicKey.ModulusAsString;
    self.ExpoentePublico := self.CriptoRsa.PublicKey.ExponentAsString;
    self.TamanhoPublico := Ord(self.CriptoRsa.PublicKey.KeySize);




    F_ComunicadorCaixa.V_ServidorRecebimento := @ComandoCaixa;
    F_ComunicadorCaixa.V_ArquivoLog := F_ArquivoLog;
    F_ComunicadorServico.V_ServidorRecebimento := @ComandoServico;
    F_ComunicadorServico.V_ArquivoLog := F_ArquivoLog;

    F_ComunicadorCaixa.CriptoRsa.GenerateKeyPair;
    F_ComunicadorCaixa.IdTCPServidor.DefaultPort := VP_PortaCaixa;
    F_ComunicadorCaixa.IdTCPServidor.Active := True;

    F_ComunicadorServico.CriptoRsa.GenerateKeyPair;
    F_ComunicadorServico.IdTCPServidor.DefaultPort := VP_PortaServico;
    F_ComunicadorServico.IdTCPServidor.Active := True;

    F_Mensagem := TMensagem.Create;

    Result := 0;
end;

function TDMCom.RecebeComandoCaixa(VP_Codigo: integer; VP_Transmissao_ID, VP_DadosRecebidos: string; VP_AContext: TIdContext): integer;
var
    VL_Mensagem: TMensagem;
    VL_DadosCriptografados: string;

begin
    VL_DadosCriptografados := '';
    VL_Mensagem := TMensagem.Create;

    if VL_Mensagem.CarregaTags(VP_DadosRecebidos) <> 0 then
    begin
        VP_AContext.Connection.Disconnect;
        Exit;
    end;
    if VF_IP_Caixa <> '' then
    begin
        if VF_IP_Caixa <> TTConexao(VP_AContext.Data).ClienteIp then
        begin
            VP_AContext.Connection.Disconnect;
            Exit;
        end;
    end;

    VL_DadosCriptografados := VL_Mensagem.GetTagAsAstring('00E3');
    if VL_DadosCriptografados <> '' then
    begin
        VL_DadosCriptografados := CriptoRsa.DecryptString(VL_DadosCriptografados);
        VL_Mensagem.AddTag('00E3', VL_DadosCriptografados);
        VP_DadosRecebidos := VL_Mensagem.TagsAsString;
    end;


    case VL_Mensagem.Comando() of
        '0001': comando0001(VP_Transmissao_ID, VL_Mensagem, VP_AContext, F_ComunicadorCaixa);
        '0021': comando0021(VP_Transmissao_ID, VL_Mensagem, VP_AContext, F_ComunicadorCaixa);
        else
            F_ServidorRecebimentoLibCaixa(VP_Codigo, PChar(VP_Transmissao_ID), PChar(VP_DadosRecebidos), PChar(TTConexao(VP_AContext.Data).ClienteIp),
                TTConexao(VP_AContext.Data).ID);
    end;
    VL_Mensagem.Free;

    Result := 0;

end;

function TDMCom.RecebeComandoServico(VP_Codigo: integer; VP_Transmissao_ID, VP_DadosRecebidos: string; VP_AContext: TIdContext): integer;
var
    VL_Mensagem: TMensagem;
    VL_DadosCriptografados: string;
begin
    VL_DadosCriptografados := '';
    VL_Mensagem := TMensagem.Create;

    if VL_Mensagem.CarregaTags(VP_DadosRecebidos) <> 0 then
    begin
        VP_AContext.Connection.Disconnect;
        Exit;
    end;
    if VF_IP_Servico <> '' then
    begin
        if VF_IP_Servico <> TTConexao(VP_AContext.Data).ClienteIp then
        begin
            VP_AContext.Connection.Disconnect;
            Exit;
        end;
    end;

    VL_DadosCriptografados := VL_Mensagem.GetTagAsAstring('00E3');
    if VL_DadosCriptografados <> '' then
    begin
        VL_DadosCriptografados := CriptoRsa.DecryptString(VL_DadosCriptografados);
        VL_Mensagem.AddTag('00E3', VL_DadosCriptografados);
        VP_DadosRecebidos := VL_Mensagem.TagsAsString;
    end;

    case VL_Mensagem.Comando() of
        '0001': comando0001(VP_Transmissao_ID, VL_Mensagem, VP_AContext, F_ComunicadorServico);
        '0021': comando0021(VP_Transmissao_ID, VL_Mensagem, VP_AContext, F_ComunicadorServico);
        else
            F_ServidorRecebimentoLibServico(VP_Codigo, PChar(VP_Transmissao_ID), PChar(VP_DadosRecebidos), PChar(TTConexao(VP_AContext.Data).ClienteIp),
                TTConexao(VP_AContext.Data).ID);
    end;
    VL_Mensagem.Free;

    Result := 0;

end;

function TDMCom.comando0001(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext; VP_DComunicador: TDComunicador): integer;
var

    VL_ChaveTerminal: string;
    VL_Mensagem: TMensagem;

begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_ChaveTerminal := '';
    try
        //inicio do processo
        VP_Mensagem.GetTag('0002', VL_ChaveTerminal);

        if DMCom.VF_Chave <> VL_ChaveTerminal then
        begin
            VL_Mensagem.AddComando('0029', '');
        end
        else
        begin
            TTConexao(VP_AContext.Data).Status := csLogado;
            VL_Mensagem.AddComando('0028', 'OK');
        end;

        VP_DComunicador.ServidorTransmiteSolicitacao(3000, False, nil, VP_Transmissao_ID, VL_Mensagem, F_Mensagem, VP_AContext);

    finally
        VL_Mensagem.Free;
    end;

end;

function TDMCom.comando0021(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext; VP_DComunicador: TDComunicador): integer;
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
            VL_TChaves := VP_DComunicador.V_ChavesDasConexoes.getChave((VL_TChaves.ID));
            if VL_TChaves.ID > 0 then
            begin
                TTConexao(VP_AContext.Data).setChaveComunicacao(VL_TChaves.ChaveComunicacao);
                try
                    if TTConexao(VP_AContext.Data).Aes.DecryptString(VL_Dados) = 'OK' then
                    begin
                        VL_Mensagem.AddComando('0024', '');
                        VL_Mensagem.TagToStr(VL_Dados);

                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('00D1', VP_Transmissao_ID);
                        VL_Mensagem.AddTag('00D2', VL_Dados);

                        TTConexao(VP_AContext.Data).Status := csChaveado;
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




end.
