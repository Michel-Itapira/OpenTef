unit tef;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils, comunicador, funcoes, def, LbRSA, LbAsym;

{ TDTef }
type

    TSolicitaDadosPDV = function(VP_Menu: PChar; var VO_Botao, VO_Dados: PChar): integer; stdcall;
    TSolicitaDadosTransacao = function(VP_Mensagem: PChar; var VO_Dados: PChar): integer; stdcall;
    TImprime = function(VP_Dados: PChar): integer; stdcall;
    TMostraMenu = function(VP_Dados: PChar; var VO_Selecionado: PChar): integer; stdcall;
    TMensagemOperador = function(VP_Dados: PChar): integer; stdcall;

    TPinPadDescarrega = function(): integer; stdcall;
    TPinPadCarrega = function(VP_PinPadModelo: TPinPadModelo; VP_PinPadModeloLib, VP_PinPadModeloPorta: PChar;
        VP_RespostaPinPad: TRespostaPinPad): integer; stdcall;
    TPinPadConectar = function(var VO_Mensagem: PChar): integer; stdcall;
    TPinPadDesconectar = function(VL_Mensagem: PChar): integer; stdcall;
    TPinPadMensagem = function(VL_Mensagem: PChar): integer; stdcall;
    TPinPadComando = function(VP_Processo_ID: integer; VP_Mensagem: PChar; var VO_Mensagem: PChar; VP_RespostaPinPad: TRespostaPinPad): integer; stdcall;

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

    { ThTransacao }

    { TThTransacao }

    TThTransacao = class(TThread)
    private
        ftransacao: TTransacao;
        ftempo: integer;
        fID: integer;
        ftransmissaoID: string;
    protected
        procedure Execute; override;
    public
        constructor Create(VP_Suspenso: boolean; VP_Transmissao_ID: string; VP_Transacao: TTransacao; VP_TempoAguarda: integer);
        destructor Destroy; override;

    end;



    TDTef = class(TDataModule)
        CriptoRsa: TLbRSA;
    private
    public
    end;

function inicializar(VP_PinPadModelo: integer; VP_PinPadModeloLib, VP_PinPadModeloPorta, VP_PinPadLib, VP_ArquivoLog: PChar;
    VP_Procedimento: TRetorno; VP_SolicitaDadosTransacao: TSolicitaDadosTransacao; VP_SolicitaDadosPDV: TSolicitaDadosPDV;
    VP_Imprime: TImprime; VP_MostraMenu: TMostraMenu; VP_MensagemOperador: TMensagemOperador; VP_AmbienteTeste: integer): integer; stdcall;
function finalizar(): integer; stdcall;
function login(VP_Host: PChar; VP_Porta: integer; VP_ChaveTerminal: PChar; VP_Versao_Comunicacao: integer): integer; stdcall;
function solicitacao(VP_Transmissao_ID, VP_Dados: PChar; VP_Procedimento: TRetorno; VP_TempoAguarda: integer): integer; stdcall;
function solicitacaoblocante(var VO_Transmissao_ID, VP_Dados: PChar; var VO_Retorno: PChar; VP_TempoAguarda: integer): integer; stdcall;
function opentefstatus(var VO_StatusRetorno: integer): integer; stdcall;
function transacaocreate(VP_IdentificadorCaixa: PChar; var VO_TransacaoID: PChar; VP_TempoAguarda: integer): integer; stdcall;
function transacaostatus(var VO_Status: integer;var VO_TransacaoChave:PChar; VP_TransacaoID: PChar): integer; stdcall;
function transacaostatusdescricao(var VO_Status: PChar; VP_TransacaoID: PChar): integer; stdcall;
function transacaocancela(var VO_Resposta: integer; VL_TransacaoChave, VP_TransacaoID: PChar): integer; stdcall;
procedure transacaofree(VP_TransacaoID: PChar); stdcall;

procedure RespostaPinPad(VP_Processo_ID: integer; VP_Mensagem: TMensagem);


var
    DTef: TDTef;
    V_Inicializado: boolean = False;
    F_ChaveTerminal: ansistring;
    F_Versao_Comunicacao: integer;
    F_DComunicador: TDComunicador;
    F_ListaTransacao: TList;
    F_SolicitaDadosPDV: TSolicitaDadosPDV;
    F_SolicitaDadosTransacao: TSolicitaDadosTransacao;
    F_Imprime: TImprime;
    F_MostraMenu: TMostraMenu;
    F_MensagemOperador: TMensagemOperador;


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

    F_AmbienteTeste: integer = 0;



implementation

{$R *.lfm}


procedure RespostaPinPad(VP_Processo_ID: integer; VP_Mensagem: TMensagem);
begin

end;


{ ThTransacao }

procedure TThTransacao.Execute;
var
    VL_Dados: PChar;
    VL_Botao: PChar;
    VL_Erro: integer;
    VL_I: integer;
    VL_Mensagem, VL_TransacaoDadosPublicos: TMensagem;
    VL_Tag, VL_TagDados, VL_String: string;
    VL_PinPadCarregado: boolean;
    VL_Criptografa: boolean;
    VL_ChaveTamanho: integer;
    VL_ChaveExpoente: string;
    VL_ChaveModulo: string;

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
        VL_ChaveExpoente := '';
        VL_ChaveModulo := '';
        VL_ChaveTamanho := 0;
        VL_Criptografa := False;
        VL_Dados := '';
        VL_Botao := '';
        VL_Tag := '';
        VL_String := '';
        VL_TagDados := '';
        VL_Mensagem := TMensagem.Create;
        VL_TransacaoDadosPublicos := TMensagem.Create;
        VL_Erro := 0;
        VL_PinPadCarregado := False;
     {
     1º recebe uma transacao tag 007A
     solicitar o menu no open tef
     havendo erro suspende
     mostrar o menu no pdv e para

     2º recebe tag 00E3 então operadora quer que criptografe dados
      }

        ftransacao.STATUS := tsProcessando;
        while not Terminated do
        begin
            if VL_Erro <> 0 then
            begin
                ftransacao.erro := VL_Erro;
                ftransacao.STATUS := tsComErro;
                Exit;
            end;

            VL_Erro := VL_Mensagem.GetTagAsInteger('004D'); // TESTA SE VEIO ERRO

            if VL_Erro <> 0 then
            begin
                ftransacao.erro := VL_Erro;
                ftransacao.STATUS := tsComErro;
                Exit;
            end;
            VL_TagDados := '';

            VL_ChaveTamanho := VL_Mensagem.GetTagAsInteger('00E4');
            VL_ChaveExpoente := VL_Mensagem.GetTagAsAstring('0027');
            VL_ChaveModulo := VL_Mensagem.GetTagAsAstring('0008');

            ftransacao.fMensagem.AddTag('00E4', VL_ChaveTamanho);
            ftransacao.fMensagem.AddTag('0027', VL_ChaveExpoente);
            ftransacao.fMensagem.AddTag('0008', VL_ChaveModulo);

            //  DTef.CriptoRsa.KeySize := TLbAsymKeySize(VL_ChaveTamanho);
            DTef.CriptoRsa.PublicKey.ExponentAsString := VL_ChaveExpoente;
            DTef.CriptoRsa.PublicKey.ModulusAsString := VL_ChaveModulo;




            if not VL_Criptografa then
            begin
                VL_Criptografa := (VL_Mensagem.GetTag('00E3', VL_TagDados) = 0); // verifica se precisar responder criptografado

                if VL_Criptografa then // verifica se veio as chaves da criptografia
                begin

                    if (trim(VL_ChaveExpoente) = '') or
                        (trim(VL_ChaveModulo) = '') then
                    begin
                        ftransacao.erro := 184;
                        ftransacao.STATUS := tsComErro;
                        Exit;

                    end;
                end;
            end
            else
                VL_Mensagem.GetTag('00E3', VL_TagDados);

            if VL_TagDados <> '' then
            begin
                VL_TagDados := DTef.CriptoRsa.DecryptString(VL_TagDados);
                VL_Erro := VL_Mensagem.CarregaTags(VL_TagDados);

                if VL_Erro <> 0 then
                begin
                    ftransacao.erro := VL_Erro;
                    ftransacao.STATUS := tsComErro;
                    Exit;
                end;
            end;



            if (VL_Mensagem.Comando() = '0018') then  // SOLICITACAO DE CAPTURA OPÇÃO DO MENU
            begin
                VL_Erro := F_MostraMenu(PChar(VL_Mensagem.TagsAsString), VL_Botao);
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
                    ftransacao.fMensagem.AddTag('00D5', VL_Botao);
                    ftransacao.fMensagem.AddTag('0033', VL_Dados);
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
                        Exit;
                    end;
                    ftransacao.fMensagem.AddTag(VL_Tag, VL_TagDados);
                end;
                VL_Mensagem.Limpar;
            end
            else
            if (VL_Mensagem.Comando() = '00E1') then  // SOLICITACAO DE DADOS DA VENDA
            begin
                VL_Erro := F_SolicitaDadosTransacao(PChar(VL_Mensagem.TagsAsString), VL_Dados);
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
                    ftransacao.fMensagem.AddTag(VL_Tag, VL_TagDados);
                end;
                VL_Mensagem.Limpar;
            end
            else
            if (VL_Mensagem.Comando() = '0048') then  // SOLICITACAO DE CAPTURA DO CARTÃO
            begin
                if ftransacao.fMensagem.GetTagAsAstring('00CE') = '' then
                begin
                    if VL_PinPadCarregado then
                    else
                    begin
                        VL_Erro := F_PinPadCarrega(F_PinPadModelo, PChar(F_PinPadModeloLib), PChar(F_PinPadModeloPorta), @RespostaPinPad);
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
                    ftransacao.fMensagem.AddTag('00CE', Copy(VL_Mensagem.GetTagAsAstring('004F'), 1, 6));       //bin dado "publico"
                end;

            end
            else
            if (VL_Mensagem.Comando() = '005A') then  // SOLICITACAO DE CAPTURA DE SENHA
            begin

                if VL_PinPadCarregado then
                else
                begin

                    VL_Erro := F_PinPadCarrega(F_PinPadModelo, PChar(F_PinPadModeloLib), PChar(F_PinPadModeloPorta), @RespostaPinPad);
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

                //                F_PinPadMensagem('Aguarde...');

                //                while TempoPassouMiliSegundos(VL_TempoSenha)<20000 do
                //                Sleep(100);

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
                ftransacao.fMensagem.AddTag('0060', VL_Mensagem.GetTagAsAstring('0060'));
            end
            else
            if (VL_Mensagem.Comando() = '008C') then  // SOLICITACAO ATUALIZAÇÃO DE TAGS
            begin
                for VL_I := 1 to VL_Mensagem.TagCount do
                begin
                    VL_Erro := VL_Mensagem.GetTag(VL_I, VL_Tag, VL_TagDados);
                    if VL_Erro <> 0 then
                    begin
                        ftransacao.erro := VL_Erro;
                        ftransacao.STATUS := tsComErro;
                        Exit;
                    end;
                    ftransacao.fMensagem.AddTag(VL_Tag, VL_TagDados);
                end;
                VL_Mensagem.Limpar;
            end
            else
            if (VL_Mensagem.Comando() = '002C') then  // mensagem ao operador
            begin
                ftransacao.STATUS := IntToTransacaoStatus(VL_Mensagem.GetTagAsInteger('004A'));
                F_MensagemOperador(PChar(VL_Mensagem.GetTagAsAstring('00DA')));

                if (ftransacao.STATUS <> tsProcessando) and (ftransacao.STATUS <> tsAguardandoComando) then
                    Exit;
            end;

            VL_Mensagem.AddComando('000A', 'S');

            if VL_Criptografa then
            begin
                VL_String := DTef.CriptoRsa.EncryptString(ftransacao.fMensagem.TagsAsString);
                VL_Mensagem.AddTag('00E3', VL_String);
                VL_TransacaoDadosPublicos.AddComando('000A', ftransacao.fMensagem.ComandoDados());
                VL_TransacaoDadosPublicos.AddTag('00CE', ftransacao.fMensagem.GetTagAsAstring('00CE'));
                VL_TransacaoDadosPublicos.AddTag('0051', ftransacao.fMensagem.GetTagAsAstring('0051'));
                VL_Mensagem.AddTag('007D', VL_TransacaoDadosPublicos.TagsAsString);
            end
            else
                VL_Mensagem.AddTag('007D', ftransacao.fMensagem.TagsAsString);

            VL_Mensagem.AddTag('00E4', F_TamanhoPublico);        //tamanho chave
            VL_Mensagem.AddTag('0027', F_ExpoentePublico);        //expoente
            VL_Mensagem.AddTag('0008', F_ModuloPublico);        //modulos


            if F_AmbienteTeste = 1 then
            begin

                if (ftransacao.fMensagem.GetTagAsAstring('00CE') = '') and (ftransacao.fMensagem.GetTagAsAstring('00D5') = '') then  // TESTE DE MENU
                    // mostra menu por que nao tem cartão e nao selecionou menu
                begin
                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('0018', 'S');
                    VL_Mensagem.AddTag('0019', 'CARTÃO DIGITADO');
                end
                else
                if (ftransacao.fMensagem.GetTagAsAstring('00CE') = '') and (ftransacao.fMensagem.GetTagAsAstring('00D5') <> '') then
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
                        VL_Mensagem.AddTag('00CE', Copy(ftransacao.fMensagem.GetTagAsAstring('0033'), 1, 6));       //bin
                        VL_Mensagem.AddTag('00D5', '');       //limpar botao
                    end;

                end
                else
                if (ftransacao.fMensagem.GetTagAsAstring('00E8') = '') and (ftransacao.fMensagem.GetTagAsAstring('00D5') = '') then
                    //NAO TEM SENNHA E NAO SELECIONOU BOTAO DA SENHA
                begin
                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('0000', 'S');
                    VL_Mensagem.AddTag('00E8', PChar('OK'));    //BOTAO PERSONALIZADO PARA IDENTIFICAR CARTÃO DIGITADO
                    VL_String := VL_Mensagem.TagsAsString;     //converte em string a mensagem
                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('002A', 'S');   //solicita dados pdv
                    VL_Mensagem.AddTag('00DA', 'DIGITE O SENHA DO CARTÃO');    //MENSAGEM A SER MOSTRADA
                    VL_Mensagem.AddTag('00DD', VL_String);    //BOTOES A MOSTRAR
                    // mostra imagem
                    VL_Mensagem.AddTag('002E','89504E470D0A1A0A0000000D494844520000012C0000012C0806000000797D8E750000000467414D410000B18F0BFC6105000000206348524D00007A26000080840000FA00000080E8000075300000EA6000003A98000017709CBA513C00000006624B4744000000000000F943BB7F0000000970485973000000600000006000F06B42CF00000E694944415478DAEDDD6152E348D685E164166111B52C60150E9643B0882A8A6515824D787ECCD0D1DD61E42B747CF39ED4FB44F8D7379F9D9912A7AACCE9AB9BD3E9746A0060E03FBD170000510416001B0416001B0416001B0416001B0416001B0416001B0416001B0416001B0416001B0416001B0416001B0416001B0416001B0416001B0416001B0416001B0416001B0416001B0416001B0416001B0416001B0416001B0416001B0416001B0416001B0416001B0416001B0416001B0416001B0416001B0416001B0416001B0416001B0416001B0416001B25036B9AA6767373B3CB57C4AF5FBFBE3CA3699ADAEFDFBF2DDF67EB67455E6BD6C37D58D0A9A0C3E1706AADEDF2A5389FC3E160F93E59F7866A5F23BFAABA399D4EA7ABA7E24AD334B58F8F8FDECBE8227239227F023ABE4F84EA4FFFC87AB80FEB29F94F42003887C0026083C0026083C0026083C03274381C16FFEFB7B7B717DFE3EDED2DF459EFEFEF29EFA3DA3BC64660197A7E7EFEF207F7F6F6B63D3D3D2DFEFFBFBDBDB5C7C7C7D0671D8FC72FC346F53EAABD63077AF72ACE89F45FE679EEBDCCABEC4BE5E7CF9F363DA2C3E1707A7979D9BCE7799E4F777777697D37EEC37CFC0D6B508F8F8F361DA28F8F8F763C1E37BFCF344DEDF9F9B9F776704504D6A05CC24ABDDE699A7A6F0557446001B0416001B0416001B0416001B041600D285AE61C95A2588B9A08ACC1AC29738E6A6BB11685F52E829DA32AEC5D7A0FE54BB5AF88CC52E8C3C3C3A672A4BACCB9B477550175CDF5DAF37DD843C99571A36C7F1FD54BD1E49EE739ED0CB3A79BEEF93EEC817F121ACA2C852A8A98CA32E7A5BDBB1566B10E8105C0068105C0068105C0068105C006818514995352312E020B2932A7A4625C0416368B3CAAFEFEFEBEBDBFBFB7D3FFBA7FFF78BDBDBDB5FBFBFBC5F7F9F1E3477B7D7DEDBD5574466061B3A5E9A66BA6893A4D49451F041636539539092B5C426001B0416001B0416001B0416001B04160E14BD9654ED5139D154F98464D0416CEEA51E6543D86FE783C125AA3EA3D90EB1C06A76DDFD7D649A19F54D34DB75A33B974E9B5662A29F7613D37FF3FD052A669BAD8C999E7F9E260B89B9B9BB435478E31B2AFC8FB44F615399F88C89A55E773C9FBFBBBE4011287C321F43730EEC37AF827E1A054533E2B953947DC13D621B000D820B000D820B000D820B000D820B00C653D8A5D550AADB61EF822B00C653C8A5D550AADB61E98EB5D043B4755D8ABA65A614F550AAD56528DBC54D78BFB30177FC3DA31D584CFA7A72749478A89A3B884C0DA31553850E84416020B800D020B800D020B800D020B800D020B9BA84AA1400481856F53954281B0DE45B073B2CA83155F114B05CB35133523EB899442ABAC67CD5452EE43CFE2A8EDC4D151452EC7A5F3894ED4544D2EADB49EE85452C5398FAC602CB4D65A23B08A895C8EC80F36EFB3FD7DB80FEBE13B2C0036082C0036082C0036082C0036082C435913472BBAF4DB46A6928E8DC032943171B4AAA5C7D03395747C256B0DC851AD4650ED09C9A887BF6101B0416001B0416001B0416001B0416001B0416001B041606151642C8C5B91B5DA7A10476061D15251F3935391B5DA7AB052EF0982E7643EB27CE9B5665AE6D67DADF9ACCC099F99E713F9CCC804D4CC33DCFA593DEED5CCBDAB950CAC0A61F5F70B98B5AFE867A9DEA7DAF9443E4F1156CA33547C56F6BD9AB977B592FF694EE67FA211A13AA251FF53986AE7E3F8592A99F74F0F7C8705C0068105C0068105C0068105C046C9C0BA5444CCA42C192A0A96D5266A563B9F88EC33CCBA9FF750882D19584B45C44CEA92E1D68265B5899AD5CE27A2C71966DCCFBB29C4F6EE55ACB5E671E49197AA88A8A22A1946A8CE67B412E69A33742C61AAF6DE43C91ED625D1C79147441EC59E49F5B4E1C865ADF6A8FACCF389889C61E6DE559C7B589681D55ABDD2A3E3BEAA15592328616EE7B8E64F25BFC3028073082C0036082C0036082C00362C03AB5A795249D5D7513DD2BDDAC4514A98DBB8FFECD80556B5F2A49AAA64A87AA47BB589A39430BF6F889F9DDE45B0739CCA81AA57A464A82ECD66AC597586A39730AB4CD95DB3E61E4AF6B0DCCA812A9192A1B2349BB5E6D6346738720933F39E8F28180BADB5A2C551C772E0A8EBA9B6E66AB76BB5E9AF2AD5CEF993DD775800F68BC0026083C0026083C0026063F781A52846AA447FFB5761B8618F3557FAED68745F15D7EC6CF781B5B518A9B2A6ACE8389175EB9AAB9639334BB368351B62AD4071AE5DA1CC9931BD73CF13599D8BAC19D76BCDBD5155C995F50EAA7FDF9897CCF31C7AAFC80FBEE231E2D1F5A8D69C49F5987545AB5CF948F7ACEB15BD37AADA7D7134227244D5A67752D4DCFE3E11AAF3719C34DBC3EEBFC302E083C0026083C0026083C00260A3646055E818FDDDA8D33BDD549C96A91877A3DA57E4DEA87886ABF4FE35E5392F2F2FA58699DDDDDD7DF9EBE23F7FFE84BB2D4BEF13D9FBEDED6DB8FBA3DA7B156BCE39F37C22D754B5AFA557E4DE509F610F7557F6856A533755AFAA45C408C76999BDD7F89DD7D6E2B1E31F54FF56B2877549B5A99B2ACA899A99BD1EC76999D5BA7E11F33CB7699A16FF37AA6B5135162C03AB35CF1B2E427539AA15113339AEB9DABEAAC642C92FDD01E01C020B800D020B800D020B800D02AB906ABFF96402AA9F5127BB7E22B08AA8369D9209A89E469DECFA97DE45B0EF6A1B8B763D0AA899D33BABAD67897A6A6BE67A32EF439816475B8BF54D2E15EDB20BA891E25FA5F3C914BD16596B56DE1BAAFBD0F447556AE8C08A6CADDA63E8551CA74A565B73B5F26DB5EBD503DF6101B0416001B0416001B0416001B0B1FBC0AAF618FAAC7D552E0756A1BA3754136B4160957B0C7DC6BECA97038B50DD1BC7E3F1CBD07A7B7B6B8F8F8FBDB7EAA37711ECBB9A61D1AEDAE3D133F6B566CD99D774EB9A7B148FABECBDA7DDF7B03229A6412AA79266ED2BBAE6CC6BAA587376F1B8D2DE7B21B08AAD39C2715F9135675ED33D178F1D7F763EEDFE3B2C003E082C0036082C0036082C00366C03CBB11839EA3448D5B5C8BAA6CAA2A65BF1D8BDA46A1B588EC5C851A741AAAE45C6355517359D8AC74394547B17C1CE5115DB328B9AD5CA78198F8FAF5A321CFD71ED7BDE7BC91E96AAD89659D4AC56C6CB7A7C7CC592E1E88F6BDFF3DE4B0656B5529FEAB3328FDAB1D0586DEFD5F6C5DE8DBFC302B03F0416001B0416001B0416001B2503AB5A2954353132F3B769233ED5385BB5DF7E66A9584EFE5432B0AA954255132397DE476DD447B167CABC5E55542D27FFA57711EC9A5AE234C82AAF1ED33223324BBCBDAFC1B5F6A5DAFBC3C3C3699EE7EBFDE05D51C91E964A6617A992EC6999915B28B3C4EB76DD95E5DBC8DEE7796ED334F5DEF6F7F647608D297259AB156BAB7D5626D58F61B502B35AC9EFB000E01C020B800D020B800D020B808DA1038B1ED278467DECBBEAB784D54AD76A430716E5C9F18CFAD8775549B55AE95AAE77110C716B0A9F1191F7A9F659AA57467932F371F655A7BFAA0DDDC31A51B4F019B9AC7BEE46659527331F675F71FAAB1A816568D489AC99326FFB3D4F7F551BFA3B2C006321B000D820B000D820B000D820B00C29CA81AA8265E667E1B2D17F4B486019DA5A0E54152C333F0B31C34F49ED5D043BE7DA8F58AFFC52513DB23C52B0547DD6D6F5A88BB54BFB524F4055ED6BEBAB7A0195C02AF6AA7686913678E6F5BAB49E799E65E77C695F87C321F43E99FB52855655258BA38A71BAAE549763D452A86A3DA3BE8F4AC15868ADF11D1600230416001B0416001B0416001B0416AC644E1CAD36BD9361940416CC644E1CAD36BD9309BA45E761456A0D8E4FAF8DEC8B5A438ECCDB3EE3E1A6EFEFEFED783CB6D7D757C99A0BC6426B8DBF61014398A6A93D3F3FF75EC6D51158C020DCFEC5F11D0416001B0416001B0416001B0416001B04163673EC06650DB9CB9EB6EA782DD620B0B09963A1316332678F69AB8ED76295DE03B9CE890C848B0C96BBF41ECA976A5F2A99FBDA2A73A266D557C4D609A8EA89AC3D0CDD74AF36F06CD4A6BB42E623DD2B52DC3F9147D547CFB9602CB4D6F827218AD843E971AB4B7FD845A6F4BA9F338105C0068105C0068105C0068105C006813528451767CFBFB5CB16E9842926A0661759D508AC416D2D10F698A8B9679122EBD609A83D8AAC72BD8B60E7501C5DA67A847AB5CFCABC5E4EAF35E7BC74BDD4F7730F14474522C7A82A8E2A0A8451999FE5386A394BF49C554F4D2F180BAD35FE4968495120ACF859F85AF49C47BF1E0416001B0416001B0416001B0416001B04D6A054BFB9CB7C5CFBD083E7042E5D535529B4726198C01A946AA266E6E3DA879F96B9D1D235559542CB17867B17C1CEA138DA7F5FD50AA86BA6653E3C3C84EE0FC5676D5D4F8F69AB5BCFA727028BC05A0CADAC6B1AF9AC799E43EB56FC30463F4BB11EE567659D4F2F34DD4522C7A86ABA57DB574464CDAABD67AE3962D46BDA03DF6101B0416001B0416001B0416001B041606151B502AA639155314D54E9DA4FBCBE26020B8BAA15501D8BAC5BA789AAA9AE6917BD7B15E7A87A58D564F6B032CA8AEA72A9936A67586D3DD732740FAB9ACC1ED6A5F3513D1A5E3971D44DB533ACB69E6B20B08AED4B1558AAF78928780BA5A97686D5D6A3C67758006C1058006C1058006C1058006C1058D8A4F274CA0C8AEE94EA0CDD1F431F4160E1DBCA4FA74CB0B5F0A93AC3211E431FD1BB08768EE251DBAEAF88CCF7C99C4EB9752AA9FA7D32A91E319F791FF660DBC31A55E47264F6B032FB6E97AEBBEA71ED158B91D5EEF982B1D05A332E8E8EAA5A6065DE1EA3EE4BB5F74CD5CEE713DF6101B0416001B0416001B0416001B0416019729CDEB9E77D29D69CA9E2F97C22B00C394EEFDCF3BEB6AE3953D5F3F954B2D60000E7F0372C0036082C0036082C0036082C0036082C0036082C0036082C0036082C0036082C0036082C0036082C0036082C0036082C0036082C0036082C0036082C0036082C0036082C0036082C0036082C0036082C0036082C0036082C0036082C0036082C0036082C0036082C0036082C0036082C0036082C0036082C0036082C0036082C0036082C0036082C0036082C0036082C0036FE0B5FE2CADFF5B9D6F10000002574455874646174653A63726561746500323032322D30362D31355431383A31333A32392B30303A303078E7A6420000002574455874646174653A6D6F6469667900323032322D30362D31355431383A31333A32392B30303A303009BA1EFE0000000049454E44AE426082');

                    VL_Mensagem.AddTag('0033', 'M');    //campo para capturar com mascara
                end
                else
                if (ftransacao.fMensagem.GetTagAsAstring('00E8') = '') and (ftransacao.fMensagem.GetTagAsAstring('00D5') = '00E8') then
                begin
                    ftransacao.fMensagem.AddTag('00E8', ftransacao.fMensagem.GetTagAsAstring('0033'));
                    ftransacao.fMensagem.AddTag('00D5','');
                end
                else
                if (ftransacao.fMensagem.GetTagAsAstring('0013') = '') then
                begin
                    VL_Mensagem.AddComando('00E1', 'S');
                    VL_Mensagem.AddTag('0013', '');    //SOLICITA VALOR DOS ITENS
                end
                else
                begin
                    F_MensagemOperador(PChar('Obrigado<br>'+'Cartão/bin:'+ftransacao.fMensagem.GetTagAsAstring('00CE')));
                    F_Imprime(Pchar('Comprovante<br>Autorizacao 123<br>Valor:'+ftransacao.fMensagem.GetTagAsAstring('0013')));
                    ftransacao.STATUS:=tsEfetivada;
                    Exit;
                end;
            end
            else
                VL_Erro := F_DComunicador.ClienteTransmiteSolicitacao(ftransmissaoID, VL_Mensagem, VL_Mensagem, nil, ftempo, True);

            if VL_Erro <> 0 then
            begin
                ftransacao.erro := VL_Erro;
                ftransacao.STATUS := tsComErro;
                Exit;
            end;

        end;

    finally
        begin
            if VL_PinPadCarregado then
            begin
                F_PinPadDesconectar('    OpenTef    ');
                F_PinPadDescarrega;

            end;
            VL_Mensagem.Free;
            VL_TransacaoDadosPublicos.Free;
        end;
    end;

end;

constructor TThTransacao.Create(VP_Suspenso: boolean; VP_Transmissao_ID: string; VP_Transacao: TTransacao; VP_TempoAguarda: integer);
begin
    fID := F_Processo_ID;
    F_Processo_ID := F_Processo_ID + 1;
    ftempo := VP_TempoAguarda;
    ftransacao := VP_Transacao;
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
begin
    VL_Mensagem := TMensagem.Create;
    try
        VL_Mensagem.CarregaTags(fdados);
        VL_Erro := F_DComunicador.ClienteTransmiteSolicitacao(ftransmissaoID, VL_Mensagem, VL_Mensagem, nil, ftempo, True);
        fprocedimento(PChar(ftransmissaoID), 0, VL_Erro, PChar(VL_Mensagem.TagsAsString));
    finally
        VL_Mensagem.Free;
    end;
end;

function inicializar(VP_PinPadModelo: integer; VP_PinPadModeloLib, VP_PinPadModeloPorta, VP_PinPadLib, VP_ArquivoLog: PChar;
    VP_Procedimento: TRetorno; VP_SolicitaDadosTransacao: TSolicitaDadosTransacao; VP_SolicitaDadosPDV: TSolicitaDadosPDV;
    VP_Imprime: TImprime; VP_MostraMenu: TMostraMenu; VP_MensagemOperador: TMensagemOperador; VP_AmbienteTeste: integer): integer; stdcall;
begin

    DTef := TDTef.Create(nil);

    if not Assigned(F_DComunicador) then
        F_DComunicador := TDComunicador.Create(nil);

    DTef.CriptoRsa.KeySize := F_DComunicador.CriptoRsa.KeySize;
    DTef.CriptoRsa.GenerateKeyPair;

    F_ModuloPublico := DTef.CriptoRsa.PublicKey.ModulusAsString;
    F_ExpoentePublico := DTef.CriptoRsa.PublicKey.ExponentAsString;
    F_TamanhoPublico := Ord(DTef.CriptoRsa.PublicKey.KeySize);

    F_DComunicador.V_ConexaoCliente := TTConexao.Create(@F_DComunicador);
    F_DComunicador.V_ThRecebeEscuta := TThRecebe.Create(True, @F_DComunicador, VP_ArquivoLog);
    F_DComunicador.V_ThRecebeEscuta.Start;

    F_DComunicador.V_ClienteRecebimento := VP_Procedimento;
    F_ListaTransacao := TList.Create;
    F_SolicitaDadosPDV := VP_SolicitaDadosPDV;
    F_SolicitaDadosTransacao := VP_SolicitaDadosTransacao;
    F_Imprime := VP_Imprime;
    F_MostraMenu := VP_MostraMenu;
    F_MensagemOperador := VP_MensagemOperador;
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

function finalizar(): integer; stdcall;
begin
    if Assigned(F_DComunicador.V_ThRecebeEscuta) then
    begin
        F_DComunicador.V_ConexaoCliente.ConexaoAtivadada := False;
        F_DComunicador.V_ThRecebeEscuta.Parar;
        F_DComunicador.V_ThRecebeEscuta.Terminate;
    end;
    F_ListaTransacao.Free;
    F_DComunicador.Free;

    if F_PinPadModelo <> pNDF then
    begin
        F_PinPadDesconectar('    OpenTef    ');
        F_PinPadDescarrega;
        UnloadLibrary(F_PinPad);
    end;

    DTef.Free;
    Result := 0;
end;

function login(VP_Host: PChar; VP_Porta: integer; VP_ChaveTerminal: PChar; VP_Versao_Comunicacao: integer): integer; stdcall;
var
    VL_Mensagem: TMensagem;
    VL_S, VL_Dados: ansistring;
    VL_DadosI: int64;
    VL_Transmissao_ID: string;
begin
    VL_S := '';
    VL_Dados := '';
    VL_Transmissao_ID := '';
    VL_Mensagem := TMensagem.Create;
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
        if length(VP_ChaveTerminal) = 0 then
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
            (F_ChaveTerminal <> VP_ChaveTerminal) or
            (F_Versao_Comunicacao <> VP_Versao_Comunicacao)) then
        begin
            F_DComunicador.DesconectarCliente;
            F_DComunicador.V_ConexaoCliente.ServidorHost := VP_Host;
            F_DComunicador.V_ConexaoCliente.ServidorPorta := VP_Porta;
            F_ChaveTerminal := VP_ChaveTerminal;
            F_Versao_Comunicacao := VP_Versao_Comunicacao;
        end;

        F_DComunicador.V_ConexaoCliente.ConexaoAtivadada := True;
        Result := F_DComunicador.ConectarCliente;

        if Result <> 0 then
            Exit;

        if F_DComunicador.V_ConexaoCliente.Status = csLogado then
        begin
            Result := 0;
            Exit;
        end;

        if F_DComunicador.V_ConexaoCliente.Status = csChaveado then
        begin
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('0001', '');
            VL_Mensagem.AddTag('0002', VP_ChaveTerminal);
            VL_Mensagem.AddTag('0005', IntToStr(C_versao[0]) + '.' + IntToStr(C_versao[1]) + '.' + IntToStr(C_versao[2]));
            VL_Mensagem.AddTag('0006', IntToStr(C_mensagem));
            VL_Mensagem.AddTag('0037', 'S');

            Result := F_DComunicador.ClienteTransmiteSolicitacao(VL_Transmissao_ID, VL_Mensagem, VL_Mensagem, nil, 10000, True);
            if Result <> 0 then
                Exit;
            VL_Mensagem.GetComando(VL_S, VL_Dados);
            VL_S := VL_Mensagem.Comando;
            if VL_S = '0028' then
                F_DComunicador.V_ConexaoCliente.Status := csLogado
            else
            if VL_S = '0029' then
            begin
                VL_DadosI := 0;
                VL_Mensagem.GetTag('0036', VL_DadosI);
                Result := VL_DadosI;
            end
            else
                Result := 34;

        end;

    finally
        VL_Mensagem.Free;
    end;

end;

function solicitacao(VP_Transmissao_ID, VP_Dados: PChar; VP_Procedimento: TRetorno; VP_TempoAguarda: integer): integer; stdcall;
var
    VL_Th: TThProcesso;
begin
    Result := 0;
    VL_Th := TThProcesso.Create(True, VP_Transmissao_ID, VP_Dados, VP_Procedimento, VP_TempoAguarda);
    VL_Th.Start;

end;

function solicitacaoblocante(var VO_Transmissao_ID, VP_Dados: PChar; var VO_Retorno: PChar; VP_TempoAguarda: integer): integer; stdcall;
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
        Result := F_DComunicador.ClienteTransmiteSolicitacao(VL_Transmissao_ID, VL_MensagensOUT, VL_MensagensIN, nil, VP_TempoAguarda, True);

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

function opentefstatus(var VO_StatusRetorno: integer): integer; stdcall;
begin
    Result := 0;
    VO_StatusRetorno := Ord(F_DComunicador.V_ConexaoCliente.Status);
    if not F_DComunicador.V_ConexaoCliente.ConexaoAtivadada then
        VO_StatusRetorno := Ord(csNaoInicializado);
end;

function transacaocreate(VP_IdentificadorCaixa: PChar; var VO_TransacaoID: PChar; VP_TempoAguarda: integer): integer; stdcall;
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
            VL_Mensagem.AddComando('007A', 'S');
            VL_Mensagem.AddTag('00A6', VP_IdentificadorCaixa);


            if (F_AmbienteTeste <> 1) then
                Result := F_DComunicador.ClienteTransmiteSolicitacao(VL_Transmissao_ID, VL_Mensagem, VL_Mensagem, nil, 10000, True)
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
                VL_Transacao := TTransacao.Create('', 0, VL_String);
                VO_TransacaoID := StrAlloc(Length(VL_Transacao.ID) + 1);
                StrPCopy(VO_TransacaoID, VL_Transacao.ID);
                VL_Transacao.fMensagem.AddComando('0042', '');
                VL_Transacao.fMensagem.AddTag('007D', VL_Mensagem.TagsAsString);
                VL_ThTransacao := TThTransacao.Create(True, VO_TransacaoID, VL_Transacao, VP_TempoAguarda);
                F_ListaTransacao.Add(VL_Transacao);
                VL_ThTransacao.Start;
            end
            else
                Result := 61;
        except
            on e: EInOutError do
            begin
                Result := 58;
                GravaLog(F_ArquivoLog, 0, '', 'tef_lib', '140520221140', 'Erro na transacaocreate ' + e.ClassName + '/' + e.Message, '', 58);
            end;

        end;

    finally
        VL_Mensagem.Free;
    end;
end;

function transacaostatus(var VO_Status: integer;var VO_TransacaoChave:PChar; VP_TransacaoID: PChar): integer; stdcall;
var
    VL_Transacao: TTransacao;
    VL_I: integer;
begin
    Result := 0;

    VO_Status := Ord(tsNaoLocalizada);
    try
        for VL_I := 0 to F_ListaTransacao.Count - 1 do
        begin
            Pointer(VL_Transacao) := F_ListaTransacao.Items[VL_I];
            if VL_Transacao.ID = VP_TransacaoID then
            begin
                Result := VL_Transacao.Erro;
                VO_Status := Ord(VL_Transacao.Status);
                Exit;
            end;
        end;
    except
        on e: EInOutError do
        begin
            Result := 59;
            GravaLog(F_ArquivoLog, 0, '', 'tef_lib', '140520221200', 'Erro na transacaostatus ' + e.ClassName + '/' + e.Message, '', 59);
        end;
    end;

end;

function transacaostatusdescricao(var VO_Status: PChar; VP_TransacaoID: PChar): integer; stdcall;
var
    VL_Transacao: TTransacao;
    VL_I: integer;
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
        on e: EInOutError do
        begin
            Result := 59;
            GravaLog(F_ArquivoLog, 0, '', 'tef_lib', '140520221200', 'Erro na transacaostatus ' + e.ClassName + '/' + e.Message, '', 59);
        end;
    end;

end;


function transacaocancela(var VO_Resposta: integer;VP_TransacaoChave, VP_TransacaoID: PChar): integer; stdcall;
begin
    Result := 0;
end;

procedure transacaofree(VP_TransacaoID: PChar); stdcall;
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
                VL_Transacao.Free;
                Exit;
            end;
        end;
    except
        on e: EInOutError do
        begin
            GravaLog(F_ArquivoLog, 0, '', 'tef_lib', '140520221225', 'Erro na transacaofree ' + e.ClassName + '/' + e.Message, '', 60);
        end;
    end;

end;



end.
