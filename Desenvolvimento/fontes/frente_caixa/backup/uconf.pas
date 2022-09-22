unit uconf;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

    TRetorno = procedure(VP_Transmissao_ID: PChar; VP_ProcID, VP_Codigo: integer; VP_Dados: PChar); stdcall;
    TSolicitaDadosPDV = function(VP_Menu: PChar; var VO_Botao, VO_Dados: PChar): integer; stdcall;
    TSolicitaDadosTransacao = function(VP_Mensagem: PChar; var VO_Dados: PChar): integer; stdcall;
    TImprime = function(VP_Dados: PChar): integer; stdcall;
    TMostraMenu = function(VP_Menu: PChar; var VO_Botao: PChar): integer; stdcall;
    TMensagemOperador = function(VP_Dados: PChar): integer; stdcall;

    { TTransacao }

    TTransacao = class
        ID: ansistring;
        ModuloConfig_ID: int64;
        Terminal_Tipo: ansistring;
        Terminal_ID: int64;
        DataHora: TDateTime;
        Mensagem: Pointer;
        TempoAguarda: integer;
        Erro: integer;
    public
        constructor Create;
        destructor Destroy; override;
    end;

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
        ETempo: TEdit;
        GroupBox1: TGroupBox;
        GroupBox4: TGroupBox;
        Label19: TLabel;
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
        procedure cbxAmbienteTesteChange(Sender: TObject);
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
    TFormConf: TForm1;

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
    F_Transacao: TTransacao;

    F_Erro: TTMensagemerro;

function StrToPinPadModelo(VP_PinPadModelo: string): integer;

implementation

{$R *.lfm}

uses uprincipal;

{ TTransacao }

constructor TTransacao.Create;
begin
    inherited Create;
    F_MensagemCreate(Mensagem);
end;

destructor TTransacao.Destroy;
begin
    F_MensagemFree(Mensagem);
    inherited Destroy;
end;

procedure TForm1.BInicializarClick(Sender: TObject);


procedure TForm1.BLoginClick(Sender: TObject);
var
    VL_Codigo: integer;
    VL_DescricaoErro: PChar;
begin
    VL_DescricaoErro := '';

    //VL_Codigo := F_Login(PChar(EHost.Text), StrToInt(EPorta.Text), PChar(Trim(EChave.Lines.Text)), C_mensagem);
    VL_Codigo := F_Login(PChar(EHost.Text), StrToInt(EPorta.Text), PChar(Trim(EChave.Lines.Text)), 1);

    if VL_Codigo <> 0 then
    begin
        F_Erro(VL_Codigo, VL_DescricaoErro);
        ShowMessage('erro: ' + IntToStr(VL_Codigo) + #13 + 'descrição: ' + VL_DescricaoErro);
        exit;
    end;
end;

procedure TForm1.cbxAmbienteTesteChange(Sender: TObject);
begin

end;



end.
