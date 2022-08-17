unit uconf;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, uprincipal;

type

    { TForm1 }

    TForm1 = class(TForm)
        BInicializar: TButton;
        BLogin: TButton;
        cbxAmbienteTeste: TCheckBox;
        EChave: TMemo;
        EHost: TEdit;
        EPinPadLib: TEdit;
        EPinPadModelo: TEdit;
        EPinPadModeloLib: TEdit;
        EPinPadModeloPorta: TEdit;
        EPorta: TEdit;
        ETefLib: TEdit;
        GroupBox1: TGroupBox;
        GroupBox4: TGroupBox;
        Label20: TLabel;
        Label21: TLabel;
        Label22: TLabel;
        Label23: TLabel;
        Label4: TLabel;
        Label5: TLabel;
        Label6: TLabel;
        Label7: TLabel;
        procedure BInicializarClick(Sender: TObject);
        procedure BLoginClick(Sender: TObject);
    private

    public

    end;

    TTefInicializar = function(VP_PinPadModelo: integer; VP_PinPadModeloLib, VP_PinPadModeloPorta, VP_PinPadLib, VP_ArquivoLog: PChar;
        VP_Procedimento: TRetorno; VP_SolicitaDadosTransacao: TSolicitaDadosTransacao; VP_SolicitaDadosPDV: TSolicitaDadosPDV;
        VP_Imprime: TImprime; VP_MostraMenu: TMostraMenu; VP_MensagemOperador: TMensagemOperador; VP_AmbienteTeste: integer): integer; stdcall;
    TTLogin = function(VP_Host: PChar; VP_Porta: integer; VP_Chave: PChar; VP_Versao_Comunicacao: integer): integer; stdcall;

    TTSolicitacao = function(VP_Transmissao_ID, VP_Dados: PChar; VP_Procedimento: TRetorno; VP_TempoAguarda: integer): integer; stdcall;
    TTSolicitacaoBlocante = function(var VO_Transmissao_ID, VP_Dados: PChar; var VO_Retorno: PChar; VP_TempoAguarda: integer): integer; stdcall;
    TTOpenTefStatus = function(var VO_StatusRetorno: integer): integer; stdcall;
    TTMensagemCreate = function(var VO_Mensagem: Pointer): integer; stdcall;
    TTMensagemCarregaTags = function(VP_Mensagem: Pointer; VP_Dados: PChar): integer; stdcall;
    TTMensagemComando = function(VP_Mensagem: Pointer; var VP_Dados: PChar): integer; stdcall;
    TTMensagemComandoDados = function(VP_Mensagem: Pointer; var VP_Dados: PChar): integer; stdcall;
    TTMensagemFree = procedure(VP_Mensagem: Pointer); stdcall;
    TTMensagemAddtag = function(VP_Mensagem: Pointer; VP_Tag, VP_Dados: PChar): integer; stdcall;
    TTMensagemAddcomando = function(VP_Mensagem: Pointer; VP_Tag, VP_Dados: PChar): integer; stdcall;
    TTMensagemTagAsString = function(VP_Mensagem: Pointer; var VO_PChar: PChar): integer; stdcall;
    TTMensagemTagCount = function(VO_Mensagem: Pointer): integer; stdcall;
    TTMensagemGetTag = function(VO_Mensagem: Pointer; VP_Tag: PChar; var VO_Dados: PChar): integer; stdcall;
    TTMensagemGetTagIdx = function(VO_Mensagem: Pointer; VL_Idx: integer; var VO_Tag: PChar; var VO_Dados: PChar): integer; stdcall;
    TTMensagemTagToStr = function(VO_Mensagem: Pointer; var VO_Dados: PChar): integer; stdcall;
    TTMensagemerro = function(VP_CodigoErro: integer; var VO_RespostaMensagem: PChar): integer; stdcall;

    TTransacaocreate = function(VP_Comando, VP_IdentificadorCaixa: PChar; var VO_TransacaID: PChar; VP_TempoAguarda: integer): integer; stdcall;
    TTransacaostatus = function(var VO_Status: integer; var VO_TransacaoChave: PChar; VP_TransacaoID: PChar): integer; stdcall;
    TTransacaostatusdescricao = function(var VO_Status: PChar; VP_TransacaoID: PChar): integer; stdcall;
    TTransacaocancela = function(var VO_Resposta: integer; VP_TransacaoChave, VP_TransacaoID: PChar): integer; stdcall;
    TTransacaofree = procedure(VP_TransacaoID: PChar); stdcall;


var
    Form1: TForm1;

    F_SolicitacaoBlocante: TTSolicitacaoBlocante;
    F_TefLib: THandle;
    F_TefInicializar: TTefInicializar;
    F_Login: TTLogin;
    F_StatusOpenTef: TTOpenTefStatus;
    F_MensagemCreate: TTMensagemcreate;
    F_MensagemCarregaTags: TTMensagemCarregaTags;
    F_MensagemComando: TTMensagemComando;
    F_MensagemComandoDados: TTMensagemComandoDados;
    F_MensagemFree: TTMensagemFree;
    F_MensagemAddTag: TTMensagemaddtag;
    F_MensagemAddComando: TTMensagemaddcomando;
    F_MensagemTagAsString: TTMensagemTagAsString;
    F_MensagemTagCount: TTMensagemTagCount;
    F_MensagemGetTag: TTMensagemGetTag;
    F_MensagemGetTagIdx: TTMensagemGetTagIdx;
    F_MensagemTagToStr: TTMensagemTagToStr;

    F_TransacaoCancela: TTransacaocancela;
    F_TransacaoCreate: TTransacaocreate;
    F_TransacaoFree: TTransacaofree;
    F_TransacaoStatus: TTransacaostatus;
    F_TransacaoStatusDescricao: TTransacaostatusdescricao;

    F_Mensagem: Pointer;
    F_ArquivoLog: string;

    F_Erro: TTMensagemerro;

implementation

{$R *.lfm}

procedure TForm1.BInicializarClick(Sender: TObject);
var
    VL_Codigo: integer;
    VL_AmbienteTeste: integer;
    VL_DescricaoErro: PChar;
begin
    try
        VL_DescricaoErro := '';

        if cbxAmbienteTeste.Checked then // ambiente de teste
        begin
            VL_AmbienteTeste := 1; // ativado
        end
        else
        begin
            VL_AmbienteTeste := 0; // desativado
        end;

        F_TefLib := LoadLibrary(PChar(ExtractFilePath(ParamStr(0)) + ETefLib.Text));

        Pointer(F_TefInicializar) := GetProcAddress(F_TefLib, 'inicializar');
        Pointer(F_Login) := GetProcAddress(F_TefLib, 'login');
        Pointer(F_SolicitacaoBlocante) := GetProcAddress(F_TefLib, 'solicitacaoblocante');
        Pointer(F_StatusOpenTef) := GetProcAddress(F_TefLib, 'opentefstatus');

        Pointer(F_MensagemCreate) := GetProcAddress(F_TefLib, 'mensagemcreate');
        Pointer(F_MensagemCarregaTags) := GetProcAddress(F_TefLib, 'mensagemcarregatags');
        Pointer(F_MensagemComando) := GetProcAddress(F_TefLib, 'mensagemcomando');
        Pointer(F_MensagemComandoDados) := GetProcAddress(F_TefLib, 'mensagemcomandodados');
        Pointer(F_MensagemFree) := GetProcAddress(F_TefLib, 'mensagemfree');
        Pointer(F_Mensagemaddtag) := GetProcAddress(F_TefLib, 'mensagemaddtag');
        Pointer(F_Mensagemaddcomando) := GetProcAddress(F_TefLib, 'mensagemaddcomando');
        Pointer(F_MensagemTagAsString) := GetProcAddress(F_TefLib, 'mensagemtagasstring');
        Pointer(F_MensagemTagCount) := GetProcAddress(F_TefLib, 'mensagemtagcount');
        Pointer(F_MensagemGetTag) := GetProcAddress(F_TefLib, 'mensagemgettag');
        Pointer(F_MensagemGetTagIdx) := GetProcAddress(F_TefLib, 'mensagemgettagidx');
        Pointer(F_MensagemTagToStr) := GetProcAddress(F_TefLib, 'mensagemtagtostr');
        Pointer(F_Erro) := GetProcAddress(F_TefLib, 'mensagemerro');

        Pointer(F_TransacaoCancela) := GetProcAddress(F_TefLib, 'transacaocancela');
        Pointer(F_TransacaoCreate) := GetProcAddress(F_TefLib, 'transacaocreate');
        Pointer(F_TransacaoFree) := GetProcAddress(F_TefLib, 'transacaofree');
        Pointer(F_TransacaoStatus) := GetProcAddress(F_TefLib, 'transacaostatus');
        Pointer(F_TransacaoStatusDescricao) := GetProcAddress(F_TefLib, 'transacaostatusdescricao');


        VL_Codigo := F_TefInicializar(StrToPinPadModelo(EPinPadModelo.Text), PChar(ExtractFilePath(ParamStr(0)) +
            EPinPadModeloLib.Text), PChar(EPinPadModeloPorta.Text), PChar(ExtractFilePath(ParamStr(0)) + EPinPadLib.Text),
            PChar(F_ArquivoLog), @P_Retorno, @solicitadadostransacao, @solicitadadospdv, @imprime, @mostramenu, @mensagemoperador, VL_AmbienteTeste);

        if VL_Codigo <> 0 then
        begin
            F_Erro(VL_Codigo, VL_DescricaoErro);
            ShowMessage('erro ' + IntToStr(VL_Codigo) + #13 + 'descrição:' + VL_DescricaoErro);
            exit;
        end;
        F_MensagemCreate(F_Mensagem);
        F_Transacao := TTransacao.Create;

    except
        ShowMessage('Erro ao carregar a Lib');
    end;
end;

procedure TForm1.BLoginClick(Sender: TObject);
  var
    VL_Codigo: integer;
    VL_DescricaoErro: PChar;
begin
    VL_DescricaoErro := '';

    VL_Codigo := F_Login(PChar(EHost.Text), StrToInt(EPorta.Text), PChar(Trim(EChave.Lines.Text)), C_mensagem);

    if VL_Codigo <> 0 then
    begin
        F_Erro(VL_Codigo, VL_DescricaoErro);
        ShowMessage('erro: ' + IntToStr(VL_Codigo) + #13 + 'descrição: ' + VL_DescricaoErro);
        exit;
    end;
    ShowMessage('Logado');
end;

end.
