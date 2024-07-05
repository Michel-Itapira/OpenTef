unit uprincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  Forms,
  Controls,
  Graphics,
  Dialogs,
  StdCtrls,
  DBGrids,
  ExtCtrls,
  Menus,
  ActnList,
  ComCtrls,
  DateTimePicker,
  StrUtils,
  def,
  md5,
  base64, DB,
  uimpressao,
  rxmemds,
  LCLType,
  Types;

type

  TConexaoStatus = (csNaoInicializado, csDesconectado, csLink,
    csChaveado, csChaveadoAssinado, csLogado);
  TransacaoStatus = (tsEfetivada, tsNegada, tsCancelada, tsProcessando,
    tsAguardandoComando, tsNaoLocalizada, tsInicializada,
    tsComErro, tsAbortada, tsAguardandoDadosPDV);

  TRetorno = function(VP_DadosEntrada: PChar; var VO_DadosSaida: PChar): integer; cdecl;
  TSolicitaDadosPDV = function(VP_Menu: PChar; var VO_Botao, VO_Dados: PChar): integer; cdecl;
  TSolicitaDadosTransacao = function(VP_Mensagem: PChar; var VO_Dados: PChar): integer; cdecl;
  TImprime = function(VP_Dados: PChar): integer; cdecl;
  TMostraMenu = function(VP_Menu: PChar; var VO_Botao: PChar): integer; cdecl;
  TMensagemOperador = function(VP_Dados: PChar): integer; cdecl;
  TVersao = function(var VO_Dados: PChar): integer; cdecl;



  { TF_Principal }

  TF_Principal = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    BAlterarNivelLog: TButton;
    BDesconectar: TButton;
    BSolicitacao: TButton;
    BInicializar: TButton;
    BLogin: TButton;
    BMenuOperacional: TButton;
    BSolicitacaoBlocante: TButton;
    Button1: TButton;
    BFinalizarTef: TButton;
    Button2: TButton;
    BTestaTag: TButton;
    BVenda: TButton;
    cbxAmbienteTeste: TCheckBox;
    CSalvarCSV: TCheckBox;
    DConciliacao: TDataSource;
    GConciliacao: TDBGrid;
    ECaixa: TEdit;
    EChave: TMemo;
    ELogNivel: TEdit;
    EIdentificador: TMemo;
    ECupomFiscal: TEdit;
    EDataHora: TDateTimePicker;
    EDesconto: TEdit;
    EHost: TEdit;
    ELink: TEdit;
    ENSU: TEdit;
    EObservacao: TEdit;
    EOperador: TEdit;
    EParcela: TEdit;
    EPinPadLib: TEdit;
    EPinPadLibHashMd5: TEdit;
    EPinPadModeloLibHashMd5: TEdit;
    EPinPadModelo: TEdit;
    EPinPadModeloLib: TEdit;
    EPinPadModeloPorta: TEdit;
    EPorta: TEdit;
    EID: TEdit;
    ETefLib: TEdit;
    ETempo: TEdit;
    EValorAlimentacao: TEdit;
    EValorItens: TEdit;
    EValorParcela: TEdit;
    EValorRefeicao: TEdit;
    EValorValeCultura: TEdit;
    EXml: TMemo;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label24: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label31: TLabel;
    lblStatusConexao: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label29: TLabel;
    Label3: TLabel;
    Label30: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    MChave: TMemo;
    MDConciliacao: TRxMemoryData;
    MDConciliacaoS_BIN: TStringField;
    MDConciliacaoS_ERRO: TStringField;
    MDConciliacaoS_NSU: TStringField;
    MDConciliacaoS_PARCELA: TStringField;
    MDConciliacaoS_VALOR: TStringField;
    Memo1: TMemo;
    MStatus: TMemo;
    PageControl1: TPageControl;
    Panel1: TPanel;
    RServidorOficial: TRadioButton;
    RServidorLocal: TRadioButton;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    procedure BAlterarNivelLogClick(Sender: TObject);
    procedure BDesconectarClick(Sender: TObject);
    procedure BFinalizarTefClick(Sender: TObject);
    procedure BInicializarClick(Sender: TObject);
    procedure BLoginClick(Sender: TObject);
    procedure BMenuOperacionalClick(Sender: TObject);
    procedure BSolicitacaoBlocanteClick(Sender: TObject);
    procedure BSolicitacaoClick(Sender: TObject);
    procedure BTestaTagClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure BVendaClick(Sender: TObject);
    procedure cbxAmbienteTesteChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Label20Click(Sender: TObject);
    procedure MontarMenu(VP_Mensagem: Pointer);
    procedure RServidorLocalChange(Sender: TObject);
    procedure RServidorOficialChange(Sender: TObject);
  private
    procedure CliqueDoBotao(VP_Botao: TObject);
  public
    procedure retornoConciliacao(VP_Dados: PChar);
    procedure mostramensagem(Data: PtrInt);
    procedure MostraCaixaPergunta(Data: PtrInt);
    procedure mostraImpressao(Data: PtrInt);
  end;


  TTefInicializar = function(var VO_Tef: Pointer; VP_PinPadModelo: integer; VP_PinPadModeloLib, VP_PinPadModeloPorta, VP_PinPadLib, VP_ArquivoLog: PChar;
    VP_RetornoCliente: TRetorno; VP_SolicitaDadosTransacao: TSolicitaDadosTransacao; VP_SolicitaDadosPDV: TSolicitaDadosPDV; VP_Imprime: TImprime;
    VP_MostraMenu: TMostraMenu; VP_MensagemOperador: TMensagemOperador; VP_AmbienteTeste: integer): integer; cdecl;
  TTLogin = function(VP_Tef: pointer; VP_Host: PChar; VP_Porta, VP_ID: integer; VP_Chave: PChar; VP_Versao_Comunicacao: integer; VP_Identificador: PChar): integer; cdecl;
  TTFinalizar = function(VP_Tef: pointer): integer; cdecl;
  TTDesconectar = function(VP_Tef: pointer): integer; cdecl;
  TTSolicitacao = function(VP_Tef: pointer; VP_Transmissao_ID, VP_Dados: PChar; VP_Procedimento: TRetorno; VP_TempoAguarda: integer): integer; cdecl;
  TTSolicitacaoBlocante = function(VP_Tef: pointer; var VO_Transmissao_ID, VP_Dados: PChar; var VO_Retorno: PChar; VP_TempoAguarda: integer): integer; cdecl;
  TTOpenTefStatus = function(VP_Tef: pointer; var VO_StatusRetorno: integer): integer; cdecl;

  TTMensagemCreate = function(var VO_Mensagem: Pointer): integer; cdecl;
  TTMensagemCarregaTags = function(VP_Mensagem: Pointer; VP_Dados: PChar): integer; cdecl;
  TTMensagemComando = function(VP_Mensagem: Pointer; var VP_Dados: PChar): integer; cdecl;
  TTMensagemComandoDados = function(VP_Mensagem: Pointer; var VP_Dados: PChar): integer; cdecl;
  TTMensagemFree = procedure(VP_Mensagem: Pointer); cdecl;
  TTMensagemLimpar = procedure(VP_Mensagem: Pointer); cdecl;
  TTMensagemAddtag = function(VP_Mensagem: Pointer; VP_Tag, VP_Dados: PChar): integer; cdecl;
  TTMensagemAddcomando = function(VP_Mensagem: Pointer; VP_Tag, VP_Dados: PChar): integer; cdecl;
  TTMensagemTagAsString = function(VP_Mensagem: Pointer; var VO_PChar: PChar): integer; cdecl;
  TTMensagemTagCount = function(VO_Mensagem: Pointer): integer; cdecl;
  TTMensagemGetTag = function(VO_Mensagem: Pointer; VP_Tag: PChar; var VO_Dados: PChar): integer; cdecl;
  TTMensagemGetTagIdx = function(VO_Mensagem: Pointer; VL_Idx: integer; var VO_Tag: PChar; var VO_Dados: PChar): integer; cdecl;
  TTMensagemTagToStr = function(VO_Mensagem: Pointer; var VO_Dados: PChar): integer; cdecl;
  TTMensagemerro = function(VP_CodigoErro: integer; var VO_RespostaMensagem: PChar): integer; cdecl;
  TTMensagemGetTagPosicao = function(VP_Mensagem: Pointer; VP_Posicao: integer; VP_Tag: PChar; var VO_Dados: PChar): integer; cdecl;
  TTMensagemAddTagPosicao = function(VP_Mensagem: Pointer; VP_Posicao: integer; VP_Tag, VP_Dados: PChar): integer; cdecl;

  TTransacaocreate = function(VP_Tef: pointer; VP_Comando, VP_IdentificadorCaixa: PChar; var VO_TransacaID: PChar; VP_TempoAguarda: integer): integer; cdecl;
  TTransacaostatus = function(VP_Tef: pointer; var VO_Status: integer; var VO_TransacaoChave: PChar; VP_TransacaoID: PChar): integer; cdecl;
  TTransacaostatusdescricao = function(VP_Tef: pointer; var VO_Status: PChar; VP_TransacaoID: PChar): integer; cdecl;
  TTransacaocancela = function(var VO_Resposta: integer; VP_TransacaoChave, VP_TransacaoID: PChar): integer; cdecl;
  TTransacaofree = procedure(VP_Tef: pointer; VP_TransacaoID: PChar); cdecl;

  TTransacaogettag = function(VP_Tef: pointer; VP_TransacaoID, VP_Tag: PChar; var VO_Dados: PChar): integer; cdecl;

  TTAlterarNilveLog = procedure(VP_Nivel: integer); cdecl;

  TLogMsgData = record
    Text: string;
  end;
  PLogMsgData = ^TLogMsgData;

  TCaixaPergunta = record
    mensagem: string;
    Caption: string;
    botoes: integer;
    botaoSelecionado: integer;
    aguardando: boolean;
    pointer: pointer;
  end;
  PCaixaPergunta = ^TCaixaPergunta;

  TImpressaoDados = record
    mensagem: string;
  end;

  PImpressaoDados = ^TImpressaoDados;

function Retorno(VP_DadosEntrada: PChar; var VO_DadosSaida: PChar): integer; cdecl;
function solicitadadospdv(VP_Mensagem: PChar; var VO_Botao, VO_Dados: PChar): integer; cdecl;
function solicitadadostransacao(VP_Mensagem: PChar; var VO_Dados: PChar): integer; cdecl;
function imprime(VP_Dados: PChar): integer; cdecl;
function mostramenu(VP_Menu: PChar; var VO_Botao: PChar): integer; cdecl;
function mensagemoperador(VP_Dados: PChar): integer; cdecl;

var
  F_Principal: TF_Principal;
  F_SolicitacaoBlocante: TTSolicitacaoBlocante;
  F_Solicitacao: TTSolicitacao;
  F_TefLib: THandle;
  F_TefInicializar: TTefInicializar;
  F_Login: TTLogin;
  F_Desconectar: TTDesconectar;
  F_Finalizar: TTFinalizar;
  F_StatusOpenTef: TTOpenTefStatus;
  F_MensagemCreate: TTMensagemcreate;
  F_MensagemCarregaTags: TTMensagemCarregaTags;
  F_MensagemComando: TTMensagemComando;
  F_MensagemComandoDados: TTMensagemComandoDados;
  F_MensagemFree: TTMensagemFree;
  F_MensagemLimpar: TTMensagemLimpar;
  F_MensagemAddTag: TTMensagemaddtag;
  F_MensagemAddComando: TTMensagemaddcomando;
  F_MensagemTagAsString: TTMensagemTagAsString;
  F_MensagemTagCount: TTMensagemTagCount;
  F_MensagemGetTag: TTMensagemGetTag;
  F_MensagemGetTagIdx: TTMensagemGetTagIdx;
  F_MensagemTagToStr: TTMensagemTagToStr;
  F_MensagemGetTagPosicao: TTMensagemGetTagPosicao;
  F_MensagemAddTagPosicao: TTMensagemAddTagPosicao;

  F_TransacaoCancela: TTransacaocancela;
  F_TransacaoCreate: TTransacaocreate;
  F_TransacaoFree: TTransacaofree;
  F_TransacaoStatus: TTransacaostatus;
  F_TransacaoStatusDescricao: TTransacaostatusdescricao;
  F_TransacaoGetTag: TTransacaogettag;

  F_Mensagem: Pointer;
  F_ArquivoLog: ansistring;

  F_Erro: TTMensagemerro;

  F_Versao: TVersao;
  F_AlterarNivelLog: TTAlterarNilveLog;

  F_CaminhoDownload: ansistring;
  F_Tef: Pointer;

const
  C_VersaoConciliacao: ansistring = '1.0.0';

function StrToPinPadModelo(VP_PinPadModelo: ansistring): integer;

implementation

{$R *.lfm}

{ TF_Principal }

uses
  umenuvenda;

procedure TF_Principal.mostramensagem(Data: PtrInt);
var // called from main thread after all other messages have been processed to allow thread safe TMemo access
  ReceivedLogMsg: TLogMsgData;
begin
  ReceivedLogMsg := PLogMsgData(Data)^;
  try
    if (not Application.Terminated) then
    begin
      ShowMessage(ReceivedLogMsg.Text);
    end;
  finally
    Dispose(PLogMsgData(Data));
  end;
end;


procedure mensagem(s: string);
var
  LogMsgToSend: PLogMsgData;
begin
  New(LogMsgToSend);
  LogMsgToSend^.Text := s;
  Application.QueueAsyncCall(@F_Principal.mostramensagem, PtrInt(LogMsgToSend));
end;

procedure TF_Principal.mostraImpressao(Data: PtrInt);
var // called from main thread after all other messages have been processed to allow thread safe TMemo access
  ReceivedLogMsg: TImpressaoDados;
begin
  ReceivedLogMsg := PImpressaoDados(Data)^;
  try
    if (not Application.Terminated) then
    begin
      Application.CreateForm(TFImpressao, FImpressao);

      FImpressao.MImpressao.Lines.Text := ReceivedLogMsg.mensagem;
      FImpressao.ShowModal;
      FImpressao.Free;
    end;
  finally
    Dispose(PLogMsgData(Data));
  end;
end;

procedure impressao(s: string);
var
  LogMsgToSend: PImpressaoDados;
begin
  New(LogMsgToSend);
  LogMsgToSend^.mensagem := s;
  Application.QueueAsyncCall(@F_Principal.mostraImpressao, PtrInt(LogMsgToSend));
end;

procedure CaixaPergunta(VP_Mensagem, VP_Caption: string; VP_Botoes: integer; var VO_BotaoSelecionado: integer);
var
  LogMsgToSend: PCaixaPergunta;
begin
  New(LogMsgToSend);
  try
    LogMsgToSend^.mensagem := VP_Mensagem;
    LogMsgToSend^.Caption := VP_Caption;
    LogMsgToSend^.botoes := VP_Botoes;
    LogMsgToSend^.botaoSelecionado := 0;
    LogMsgToSend^.aguardando := True;
    LogMsgToSend^.pointer := Pointer(LogMsgToSend);

    Application.QueueAsyncCall(@F_Principal.MostraCaixaPergunta, PtrInt(LogMsgToSend));

    while LogMsgToSend^.aguardando do
    begin
      sleep(10);
    end;

    VO_BotaoSelecionado := LogMsgToSend^.botaoSelecionado;
  finally
    Dispose(LogMsgToSend);
  end;
end;

procedure TF_Principal.MostraCaixaPergunta(Data: PtrInt);
var // called from main thread after all other messages have been processed to allow thread safe TMemo access
  ReceivedLogMsg: TCaixaPergunta;
begin
  ReceivedLogMsg := PCaixaPergunta(Data)^;
  if (not Application.Terminated) then
  begin
    ReceivedLogMsg.botaoSelecionado :=
      Application.MessageBox(PChar(ReceivedLogMsg.mensagem), PChar(ReceivedLogMsg.Caption), MB_ICONQUESTION + MB_YESNO);
  end;

  PCaixaPergunta(Data)^.aguardando := False;
  PCaixaPergunta(PCaixaPergunta(Data)^.pointer)^.aguardando := False;
  PCaixaPergunta(PCaixaPergunta(Data)^.pointer)^.botaoSelecionado :=
    ReceivedLogMsg.botaoSelecionado;
end;


function Retorno(VP_DadosEntrada: PChar; var VO_DadosSaida: PChar): integer; cdecl;
var
  VL_Dados: PChar;
  VL_Comando: PChar;
  VL_ComandoDados: PChar;
  VL_Mensagem: Pointer;
  VL_String: ansistring;
  VL_Erro: integer;
  VL_DescricaoErro: PChar;
  VL_TransacaoID: PChar;
  VL_DescricaoErroTransacao: PChar;
  VL_TransacaoChave: PChar;
  VL_Bin: PChar;
  VL_TransacaoStatus: integer;
  VL_BotaoSelecionado: integer;
begin
  Result := 0;
  VL_Erro := 0;
  VL_String := '';
  VL_Mensagem := nil;
  VL_Dados := '';
  VL_DescricaoErro := '';
  VL_Comando := '';
  VL_ComandoDados := '';
  VL_Comando := '';
  VL_TransacaoID := '';
  VL_DescricaoErroTransacao := '';
  VL_TransacaoChave := '';
  VL_Bin := '';
  VL_BotaoSelecionado := 0;
  try
    F_MensagemCreate(VL_Mensagem);

    VL_Erro := F_MensagemCarregaTags(VL_Mensagem, VP_DadosEntrada);
    F_Principal.Memo1.Lines.Text := VP_DadosEntrada;
    if VL_Erro <> 0 then
    begin
      F_MensagemAddComando(VL_Mensagem, '0026', PChar(IntToStr(VL_Erro)));
      // retorno com erro
      F_MensagemTagAsString(VL_Mensagem, VL_Dados);
      VL_String := VL_Dados;

      VO_DadosSaida := StrAlloc(Length(VL_String) + 1);
      StrPCopy(VO_DadosSaida, VL_String);
      Exit;
    end;

    F_MensagemComando(VL_Mensagem, VL_Comando);
    F_MensagemComandoDados(VL_Mensagem, VL_ComandoDados);

    if VL_Comando = '0026' then  // retorno com erro
    begin
      if VL_ComandoDados = '96' then // desconectado
      begin
        F_Principal.lblStatusConexao.Caption := 'Desconectado';
        F_Principal.lblStatusConexao.Font.Color := clRed;
      end;

      F_Erro(StrToInt(VL_ComandoDados), VL_DescricaoErro);
      Mensagem('Erro: ' + VL_ComandoDados + #13 + 'Descrição: ' + VL_DescricaoErro);
      exit;
    end;

    if VL_Comando = '0018' then //Veio pedido de mostrar menu de venda
    begin
      // monta o menu e aguarda a escolha pelo operador
      F_Principal.MontarMenu(VL_Mensagem);
      exit;
    end;

    if VL_Comando = '010C' then // solicitacao de atualizacao do tef
    begin
      new(VL_Dados);
     // VL_Dados:='';
      F_MensagemGetTag(VL_Mensagem, PChar('00FD'), VL_Dados);  // atualizacao obrigatoria

      if VL_Dados = 'S' then
      begin
        F_MensagemAddComando(VL_Mensagem, '010C',
          PChar(ExtractFilePath(ParamStr(0)) + '..\..\tef_lib\win64\'));
        // comando de retorno com o caminho

        F_MensagemTagAsString(VL_Mensagem, VL_Dados);
        VL_String := VL_Dados;

        VO_DadosSaida := StrAlloc(Length(VL_String) + 1);
        StrPCopy(VO_DadosSaida, VL_String);
      end;

      //VL_Dados:='';

      F_MensagemGetTag(VL_Mensagem, PChar('010A'), VL_Dados); // atualizacao opcional
      if VL_Dados = 'S' then
      begin

        CaixaPergunta('Nova atualização do tef, deseja atualizar?',
          'PDV', MB_ICONQUESTION + MB_YESNO, VL_BotaoSelecionado);
        if VL_BotaoSelecionado = idYes then
        begin
          F_MensagemAddComando(VL_Mensagem, '010C',
            PChar(ExtractFilePath(ParamStr(0)) + '..\..\tef_lib\win64\'));
          // comando de retorno com o caminho

          F_MensagemTagAsString(VL_Mensagem, VL_Dados);
          VL_String := VL_Dados;

          VO_DadosSaida := StrAlloc(Length(VL_String) + 1);
          StrPCopy(VO_DadosSaida, VL_String);
        end;
      end;
      StrDispose(VL_Dados);
      exit;
    end;

    if VL_Comando = '00A4' then // status da transacao
    begin
      VL_TransacaoStatus := StrToInt(VL_ComandoDados);
      F_MensagemGetTag(VL_Mensagem, '0034', VL_TransacaoID);  // transacao id
      F_MensagemGetTag(VL_Mensagem, '00F1', VL_TransacaoChave); // chave da transacao

      if Ord(tsComErro) = VL_TransacaoStatus then
      begin
        VL_Erro := F_TransacaoStatusDescricao(F_Tef, VL_DescricaoErroTransacao, VL_TransacaoID);
        F_Erro(VL_Erro, VL_DescricaoErro);
        Mensagem('Transação com erro ' + VL_TransacaoID + ' ' + VL_DescricaoErro);
        F_Principal.MStatus.Lines.Add('Transação com erro ' + VL_TransacaoID + ' ' + VL_DescricaoErro);
        F_TransacaoFree(F_Tef, VL_TransacaoID);
        Exit;
      end;

      if Ord(tsCancelada) = VL_TransacaoStatus then
      begin
        VL_Erro := F_TransacaoStatusDescricao(F_Tef, VL_DescricaoErroTransacao, VL_TransacaoID);
        F_Erro(VL_Erro, VL_DescricaoErro);
        Mensagem('Transação cancelada ' + VL_TransacaoID + ' ' + VL_DescricaoErro);
        F_Principal.MStatus.Lines.Add('Transação cancelada ' + VL_TransacaoID + ' ' + VL_DescricaoErro);
        F_TransacaoFree(F_Tef, VL_TransacaoID);
        Exit;
      end;

      if Ord(tsNegada) = VL_TransacaoStatus then
      begin
        VL_Erro := F_TransacaoStatusDescricao(F_Tef, VL_DescricaoErroTransacao, VL_TransacaoID);
        F_Erro(VL_Erro, VL_DescricaoErro);
        Mensagem('Transação negada ' + VL_TransacaoID + ' ' + VL_DescricaoErro);
        F_Principal.MStatus.Lines.Add('Transação negada ' + VL_TransacaoID + ' ' + VL_DescricaoErro);
        F_TransacaoFree(F_Tef, VL_TransacaoID);
        Exit;
      end;


      if Ord(tsNaoLocalizada) = VL_TransacaoStatus then
      begin
        VL_Erro := F_TransacaoStatusDescricao(F_Tef, VL_DescricaoErroTransacao, VL_TransacaoID);
        F_Erro(VL_Erro, VL_DescricaoErro);
        Mensagem('Transação não localizada ' + VL_TransacaoID + ' ' + VL_DescricaoErro);
        F_Principal.MStatus.Lines.Add('Transação não localizada ' + VL_TransacaoID + ' ' + VL_DescricaoErro);
        F_TransacaoFree(F_Tef, VL_TransacaoID);
        Exit;
      end;

      if Ord(tsEfetivada) = VL_TransacaoStatus then
      begin
        Mensagem('Transação aprovada ' + VL_TransacaoID);
        F_Principal.MChave.Lines.Add(VL_TransacaoChave);
        F_Principal.MStatus.Lines.Add('Transacao ID: ' + VL_TransacaoID + ' Efetivada');
        F_TransacaoGetTag(F_Tef, VL_TransacaoID, '0036', VL_Bin);
        F_Principal.MStatus.Lines.Add('Bin: ' + VL_Bin);
        F_TransacaoFree(F_Tef, VL_TransacaoID);
        Exit;
      end;

      if Ord(tsAbortada) = VL_TransacaoStatus then
      begin
        VL_Erro := F_TransacaoStatusDescricao(F_Tef, VL_DescricaoErroTransacao, VL_TransacaoID);
        F_Erro(VL_Erro, VL_DescricaoErro);
        Mensagem('Transação abortada ' + VL_TransacaoID + ' ' + VL_DescricaoErro);
        F_Principal.MStatus.Lines.Add('Transação abortada ' + VL_TransacaoID + ' ' + VL_DescricaoErro);
        F_TransacaoFree(F_Tef, VL_TransacaoID);
        Exit;
      end;

      case VL_TransacaoStatus of
        Ord(tsProcessando): F_Principal.MStatus.Lines.Add('Transacao ID:' + VL_TransacaoID + 'Estado de processamento');
        Ord(tsInicializada): F_Principal.MStatus.Lines.Add('Transacao ID:' + VL_TransacaoID + 'Estado de inicializada');
        Ord(tsAguardandoComando): F_Principal.MStatus.Lines.Add(
            'Transacao ID:' + VL_TransacaoID + 'Estado de aguardando comando');
        Ord(tsAguardandoDadosPDV): F_Principal.MStatus.Lines.Add(
            'Transacao ID:' + VL_TransacaoID + 'Estado de aguardando dados do pdv');
      end;

      exit;
    end;

    if (VL_Comando = '0118') and (VL_ComandoDados = 'CONCILIACAO') then
    begin
      F_Principal.retornoConciliacao(VP_DadosEntrada);
      exit;
    end;

    F_MensagemAddComando(VL_Mensagem, '0026', '1'); // retorno com erro

    F_MensagemTagAsString(VL_Mensagem, VL_Dados);
    VL_String := VL_Dados;

    vo_DadosSaida := StrAlloc(Length(VL_String) + 1);
    StrPCopy(VO_DadosSaida, VL_String);

  finally
    F_MensagemFree(VL_Mensagem);
  end;
end;

function solicitadadospdv(VP_Mensagem: PChar; var VO_Botao, VO_Dados: PChar): integer; cdecl;
var
  VL_btn: TMButton;
  VL_I: integer;
  VL_Tag: PChar;
  VL_Dados: PChar;
  VL_String: ansistring;
  VL_MenuVenda: TF_MenuVenda;
  VL_Imagem: ansistring;


  procedure StrToImagem(Dados: ansistring; var Imagem: Timage);
  var
    JP: TJPEGImage;
    PNG: TPortableNetworkGraphic;
    BPM: TBitmap;
    Sm: TStringStream;
    i: integer;
    Tipo_Imagem, S, L: ansistring;
  begin
    s := '';
    L := '';
    Tipo_Imagem := 'TI_JPG';
    if Dados = '' then
    begin
      Imagem.Picture.Graphic := nil;
      exit;
    end;

    //for i := 0 to Length(Dados) div 2 - 1 do
    //begin
    //    L := copy(Dados, ((1 + i) * 2) - 1, 2);
    //    s := s + char(Hex2Dec(L));
    //end;


    s := DecodeStringBase64(Dados);

    Sm := TStringStream.Create(s);


    if Length(s) > 5 then
    begin
      if ((char(s[2]) = 'P') and (char(s[3]) = 'N') and (char(s[4]) = 'G')) then
        Tipo_Imagem := 'TI_Png';
      if ((char(s[1]) = 'B') and (char(s[2]) = 'M')) then
        Tipo_Imagem := 'TI_BMP';
    end;


    if Tipo_Imagem = 'TI_JPG' then
    begin
      JP := TJPEGImage.Create;
      JP.LoadFromStream(Sm);
      Imagem.Picture.Assign(JP);
      JP.Free;
      Sm.Free;
    end
    else
    if Tipo_Imagem = 'TI_Png' then
    begin
      PNG := TPortableNetworkGraphic.Create;
      PNG.LoadFromStream(Sm);
      Imagem.Picture.Assign(PNG);
      PNG.Free;
      Sm.Free;
    end
    else
    if Tipo_Imagem = 'TI_BMP' then
    begin
      BPM := TBitmap.Create;
      BPM.LoadFromStream(Sm);
      Imagem.Picture.Assign(BPM);
      BPM.Free;
      Sm.Free;
    end;

  end;

begin

  Result := 0;
  VL_Tag := '';
  VL_Dados := '';
  VL_String := '';
  F_MensagemCarregaTags(F_Mensagem, VP_Mensagem);


  VL_MenuVenda := TF_MenuVenda.Create(F_Principal);

  VL_MenuVenda.Height := 120;

  F_MensagemGetTag(F_Mensagem, '00DA', VL_Dados);
  // verifica se veio mensagem a ser mostrada
  if VL_Dados <> '' then
  begin
    VL_MenuVenda.PMensagem.Visible := True;
    VL_MenuVenda.LMensagem.Caption := VL_Dados;
    VL_MenuVenda.Height := VL_MenuVenda.Height + 100;
  end;

  VL_Dados := '';
  VL_I := F_MensagemGetTag(F_Mensagem, '0033', VL_Dados);
  // VERIFICA SE É PARA CAPTURAR ALGUMA INFORMAÇÃO
  if (VL_I = 0) and (VL_Dados <> '') then
  begin
    if VL_Dados = 'M' then
      // VERIFICA SE É PARA ESCONDER A DIGITAÇÃO "SENHA POR EXEMPLO"
      VL_MenuVenda.EDados.PasswordChar := '*';
    VL_MenuVenda.PDados.Visible := True;
    VL_MenuVenda.Height := VL_MenuVenda.Height + 80;
  end;

  VL_Dados := '';
  VL_I := F_MensagemGetTag(F_Mensagem, '002E', VL_Dados);
  // VERIFICA SE VEIO IMAGEM A SER MOSTRADA "QR CODE, FOTO..."
  if (VL_I = 0) and (VL_Dados <> '') then
  begin
    VL_Imagem := VL_Dados;
    StrToImagem(VL_Imagem, VL_MenuVenda.Imagem);
    VL_MenuVenda.PImagem.Visible := True;
    VL_MenuVenda.Height := VL_MenuVenda.Height + 300;
  end;

  VL_Dados := '';
  F_MensagemGetTag(F_Mensagem, '00DD', VL_Dados);    // CONTEM A LISTA DE BOTOES
  F_MensagemCarregaTags(F_Mensagem, VL_Dados);

  VL_btn := TMButton.Create(VL_MenuVenda.PBotao);
  // SEMPRE COLOCAR BOTAO DE CANCELAMENTO
  VL_btn.V_tag := '0030';
  VL_btn.Caption := 'Cancela';
  VL_btn.Align := alTop;
  VL_btn.Height := 20;
  VL_btn.BorderSpacing.Around := 20;
  VL_btn.Parent := VL_MenuVenda.PBotao;
  VL_btn.TabOrder := 0;
  VL_btn.OnClick := @F_Principal.CliqueDoBotao;

  for VL_I := 1 to F_MensagemTagCount(F_Mensagem) do
  begin
    F_MensagemGetTagIdx(F_Mensagem, VL_i, VL_Tag, VL_Dados);
    if VL_Tag <> '0030' then
      //PULA SE TIVER BOTAO DE CANCELAMENTO POIS JA FOI COLOCADO ACIMA
    begin
      VL_btn := TMButton.Create(VL_MenuVenda.PBotao);
      F_MensagemGetTagIdx(F_Mensagem, VL_i, VL_Tag, VL_Dados);
      VL_btn.V_tag := VL_tag;
      VL_btn.Caption := VL_Dados;
      VL_btn.Align := alTop;
      VL_btn.Height := 20;
      VL_btn.BorderSpacing.Around := 20;
      VL_btn.Parent := VL_MenuVenda.PBotao;
      VL_btn.TabOrder := 0;
      VL_MenuVenda.Height := VL_MenuVenda.Height + 40;
      VL_btn.OnClick := @F_Principal.CliqueDoBotao;
    end;
  end;
  VL_MenuVenda.Height := VL_MenuVenda.Height + 40;

  F_MensagemComandoDados(F_Mensagem, VL_Dados);
  VL_MenuVenda.ShowModal;

  VO_Dados := StrAlloc(Length(VL_MenuVenda.EDados.Text) + 1);
  StrPCopy(VO_Dados, VL_MenuVenda.EDados.Text);

  VO_Botao := StrAlloc(Length(VL_MenuVenda.V_Botao) + 1);
  StrPCopy(VO_Botao, VL_MenuVenda.V_Botao);

  VL_MenuVenda.Free;

end;

function solicitadadostransacao(VP_Mensagem: PChar; var VO_Dados: PChar): integer; cdecl;
var
  VL_I: integer;
  VL_Tag: PChar;
  VL_Dados: PChar;
  VL_PChar: PChar;
  VL_Resposta, VL_TagConciliacao: Pointer;
  VL_DadosEnviados: PChar;
begin

  Result := 0;
  VL_Tag := '';
  VL_Dados := '';
  VL_PChar := '';
  VL_DadosEnviados := '';
  VL_Resposta := nil;
  F_MensagemCreate(VL_Resposta);
  F_MensagemAddComando(VL_Resposta, '00E1', 'R');
  F_MensagemCarregaTags(F_Mensagem, VP_Mensagem);

  for vl_i := 1 to F_MensagemTagCount(F_Mensagem) do
    // A OPERADORA DE CARTÃO POR SOLICITAR OS DADOS PARA APROVAÇÃO
  begin
    // DEVE TESTAR TODOS OS POSSIVEIS DADOS SOLICITADOS PARA RESPONDER A OPERADORA
    F_MensagemGetTagIdx(F_Mensagem, VL_I, VL_Tag, VL_Dados);
    // SE ALGUM DADO SOLICITADO NÃO FOR RESPONDIDO PODE HAVER A NEGAÇÃO DA TRANSAÇÃO PELA OPERADORA
    if VL_Tag = '0011' then
      // IDENTIFICAÇÃO DO CAIXA
      F_MensagemAddTag(VL_Resposta, '0011',
        PChar(F_Principal.ECaixa.Text));
    if VL_Tag = '0012' then
      // IDENTIFICAÇÃO DO OPERADOR DO CAIXA
      F_MensagemAddTag(VL_Resposta, '0012',
        PChar(F_Principal.EOperador.Text));
    if VL_Tag = '0010' then
      // NUMERO DO CUPOM FISCAL
      F_MensagemAddTag(VL_Resposta, '0010',
        PChar(F_Principal.ECupomFiscal.Text));
    if VL_Tag = '000E' then
      // VALOR DA PARCELA
      F_MensagemAddTag(VL_Resposta, '000E',
        PChar(F_Principal.EValorParcela.Text));
    if VL_Tag = '000F' then
      // NUMERO DE PARCELAS
      F_MensagemAddTag(VL_Resposta, '000F',
        PChar(F_Principal.EParcela.Text));
    if VL_Tag = '0013' then
      // VALOR TOTAL
      F_MensagemAddTag(VL_Resposta, '0013',
        PChar(F_Principal.EValorItens.Text));
    if VL_Tag = '0014' then
      // VALOR TOTAL REFERENTE A PRODUTOS PERTECENTES AO PAT ALIMENTO IN NATURA
      F_MensagemAddTag(VL_Resposta, '0014',
        PChar(F_Principal.EValorAlimentacao.Text));
    if VL_Tag = '0015' then
      // VALOR TOTAL REFERENTE A PRODUTOS PERTECENTES AO PAT ALIMENTO PRONTO
      F_MensagemAddTag(VL_Resposta, '0015',
        PChar(F_Principal.EValorRefeicao.Text));
    if VL_Tag = '0016' then
      // VALOR TOTAL REFERENTE A PRODUTOS PERTECENTES AO VALE CULTURA
      F_MensagemAddTag(VL_Resposta, '0016',
        PChar(F_Principal.EValorValeCultura.Text));
    if VL_Tag = '0017' then
      // XML DO CUPOM FISCAL NÃO PRECISA ASSINAR E A FORMATAÇÃO É LIVRE
      F_MensagemAddTag(VL_Resposta, '0017',
        PChar(F_Principal.EXml.Lines.Text));
    if VL_Tag = '000B' then
      // NSU OU IDENTIFICADOR DA TRANSAÇÃO GERADO PELO PDV
      F_MensagemAddTag(VL_Resposta, '000B',
        PChar(F_Principal.ENSU.Text));
    if VL_Tag = '000C' then
      // DATA DA VENDA
      F_MensagemAddTag(VL_Resposta, '000C',
        PChar(DateToStr(F_Principal.EDataHora.Date)));
    if VL_Tag = '000D' then
      // HORA DA VENDA
      F_MensagemAddTag(VL_Resposta, '000D',
        PChar(TimeToStr(F_Principal.EDataHora.Time)));
    if VL_Tag = '00E5' then
      // LINK DA VALIDAÇÃO DA NOTA/CUPOM FISCAL
      F_MensagemAddTag(VL_Resposta, '00E5',
        PChar(F_Principal.ELink.Text));
    if VL_Tag = '00E6' then
      // VALOR DO DESCONTO
      F_MensagemAddTag(VL_Resposta, '00E6',
        PChar(F_Principal.EDesconto.Text));
    if VL_Tag = '0040' then
      // OBSERVAÇÃO SOBRE A VENDA
      F_MensagemAddTag(VL_Resposta, '0040',
        PChar(F_Principal.EObservacao.Text));
    if VL_Tag = '00F1' then
      // CHAVE DA TRANSACAO
      F_MensagemAddTag(VL_Resposta, '00F1',
        PChar(F_Principal.MChave.Text));
    if VL_Tag = '0114' then
      // VERSAO DA CONCILIACAO
      F_MensagemAddTag(VL_Resposta, '0114', PChar(C_VersaoConciliacao));
    if VL_Tag = '0117' then  // DADOS DA CONCILIACAO
    begin
      F_MensagemCreate(VL_TagConciliacao);
      F_MensagemAddComando(VL_TagConciliacao, '0118', 'CONCILIACAO');
      // indice que e uma tabela de dados
      F_MensagemAddTag(VL_TagConciliacao, '0119', '1'); // quantidade

      F_MensagemAddTagPosicao(VL_TagConciliacao, 1, '0036', ''); // bin
      F_MensagemAddTagPosicao(VL_TagConciliacao, 1, '000C', '12/12/2023');
      // data da venda
      F_MensagemAddTagPosicao(VL_TagConciliacao, 1, '000F', '');
      // quantidade de parcela
      F_MensagemAddTagPosicao(VL_TagConciliacao, 1, '000B', ''); // nsu
      F_MensagemAddTagPosicao(VL_TagConciliacao, 1, '000E', '');
      // valor da parcela

      F_MensagemTagAsString(VL_TagConciliacao, VL_DadosEnviados);

      F_MensagemAddTag(VL_Resposta, '0117', VL_DadosEnviados);
      // DADOS DA CONCILIACAO

      F_MensagemFree(VL_TagConciliacao);
    end;
  end;

  F_MensagemTagAsString(VL_Resposta, VO_Dados);
  F_MensagemFree(VL_Resposta);

end;

function imprime(VP_Dados: PChar): integer; cdecl;
var
  VL_Texto: string;
begin
  Result := 0;
  VL_Texto := VP_Dados;
  VL_Texto := ReplaceStr(VL_Texto, '<br>', #13); // quebra de linha
  impressao(VL_Texto);
end;

function mostramenu(VP_Menu: PChar; var VO_Botao: PChar): integer; cdecl;
var
  VL_btn: TMButton;
  VL_I: integer;
  VL_Tag: PChar;
  VL_Dados: PChar;
  VL_MenuVenda: TF_MenuVenda;
begin
  Result := 0;

  VL_Tag := '';
  VL_Dados := '';
  VO_Botao := '';

  F_MensagemCarregaTags(F_Mensagem, VP_Menu);

  VL_MenuVenda := TF_MenuVenda.Create(F_Principal);
  VL_MenuVenda.Height := 170;

  VL_btn := TMButton.Create(VL_MenuVenda.PBotao);
  VL_btn.V_tag := '0030';
  VL_btn.Caption := 'Cancela';
  VL_btn.Align := alTop;
  VL_btn.Height := 20;
  VL_btn.BorderSpacing.Around := 20;
  VL_btn.Parent := VL_MenuVenda.PBotao;
  VL_btn.TabOrder := 0;
  VL_btn.OnClick := @F_Principal.CliqueDoBotao;

  for VL_I := 1 to F_MensagemTagCount(F_Mensagem) do
  begin
    F_MensagemGetTagIdx(F_Mensagem, VL_i, VL_Tag, VL_Dados);
    if VL_Tag <> '0030' then
      //pula se tiver tag 0030 que é de cancelamento pois ja foi criada acima
    begin
      VL_btn := TMButton.Create(VL_MenuVenda.PBotao);
      F_MensagemGetTagIdx(F_Mensagem, VL_i, VL_Tag, VL_Dados);
      VL_btn.V_tag := VL_tag;
      VL_btn.Caption := VL_Dados;
      VL_btn.Align := alTop;
      VL_btn.Height := 20;
      VL_btn.BorderSpacing.Around := 20;
      VL_btn.Parent := VL_MenuVenda.PBotao;
      VL_btn.TabOrder := 0;
      VL_MenuVenda.Height := VL_MenuVenda.Height + 40;
      VL_btn.OnClick := @F_Principal.CliqueDoBotao;
    end;
  end;

  VL_MenuVenda.Height := VL_MenuVenda.Height + 40;
  F_MensagemComandoDados(F_Mensagem, VL_Dados);

  VL_MenuVenda.ShowModal;

  {01/07/2024 17:31}
  VO_Botao := StrAlloc(Length(VL_MenuVenda.V_Botao) + 1);
  StrPCopy(VO_Botao, VL_MenuVenda.V_Botao);


  VL_MenuVenda.Free;
end;

function mensagemoperador(VP_Dados: PChar): integer; cdecl;
var
  VL_String: string;
begin

  Result := 0;
  EXIT;
  VL_String := VP_Dados;
  VL_String := ReplaceStr(VL_String, '<br>', #13); // quebra de linha
  Mensagem(VL_String);
end;


procedure TF_Principal.CliqueDoBotao(VP_Botao: TObject);
var
  VL_Botao: string;
begin

  VL_Botao := TMButton(VP_Botao).v_tag;
  TF_MenuVenda(TPanel(TMButton(VP_Botao).Parent).Parent).V_Botao := VL_Botao;
  TForm(TPanel(TMButton(VP_Botao).Parent).Parent).Close;

end;

procedure TF_Principal.FormShow(Sender: TObject);
begin
  EDataHora.DateTime := now;
end;

procedure TF_Principal.Label20Click(Sender: TObject);
begin

end;

procedure TF_Principal.MontarMenu(VP_Mensagem: Pointer);
var
  VL_btn: TMButton;
  VL_I: integer;
  VL_Tag: PChar;
  VL_Dados: PChar;
begin
  VL_Tag := '';
  VL_Dados := '';
  F_MenuVenda := TF_MenuVenda.Create(F_Principal);
  F_MenuVenda.V_Mensagem := VP_Mensagem;
  VL_btn := TMButton.Create(F_MenuVenda.PBotao);
  VL_btn.V_tag := '0030';
  VL_btn.Caption := 'Cancela';
  VL_btn.Align := alTop;
  VL_btn.Height := 20;
  VL_btn.BorderSpacing.Around := 20;
  VL_btn.Parent := F_MenuVenda.PBotao;
  VL_btn.TabOrder := 0;
  VL_btn.OnClick := @CliqueDoBotao;

  for VL_I := 1 to F_MensagemTagCount(VP_Mensagem) do
  begin
    F_MensagemGetTagIdx(VP_Mensagem, VL_i, VL_Tag, VL_Dados);
    if VL_Tag <> '0030' then
    begin
      VL_btn := TMButton.Create(F_MenuVenda.PBotao);
      F_MensagemGetTagIdx(VP_Mensagem, VL_i, VL_Tag, VL_Dados);
      VL_btn.V_tag := VL_tag;
      VL_btn.Caption := VL_Dados;
      VL_btn.Align := alTop;
      VL_btn.Height := 20;
      VL_btn.BorderSpacing.Around := 20;
      VL_btn.Parent := F_MenuVenda.PBotao;
      VL_btn.TabOrder := 0;
      VL_btn.OnClick := @CliqueDoBotao;
      F_MenuVenda.Height := F_MenuVenda.Height + 40;
    end;
  end;
  F_MenuVenda.Height := F_MenuVenda.Height + 40;
  F_MensagemComandoDados(VP_Mensagem, VL_Dados);
  //MStatus.Lines.Add('TransacaoID:' + VL_Dados);
  F_MenuVenda.Position := poDesktopCenter;
  F_MenuVenda.ShowModal;
  F_MenuVenda.Free;

end;

procedure TF_Principal.RServidorLocalChange(Sender: TObject);
begin
  EHost.Caption := '127.0.0.1';
  EPorta.Caption := '39001';
end;

procedure TF_Principal.RServidorOficialChange(Sender: TObject);
begin
  EHost.Caption := 'opentef.ioiosoftware.com.br';
  EPorta.Caption := '39001';
end;


procedure TF_Principal.BMenuOperacionalClick(Sender: TObject);
var
  VL_Erro: integer;
  VL_Transacao_ID: PChar;
  VL_Status: integer;
  VL_DescricaoErro: PChar;
  VL_Tempo: integer;
begin
  VL_Transacao_ID := '';
  VL_Status := 0;
  VL_DescricaoErro := '';
  VL_Tempo := StrToInt(ETempo.Text);

  if not Assigned(F_StatusOpenTef) then
  begin
    ShowMessage('Inicialize a lib');
    Exit;
  end;

  VL_Erro := F_StatusOpenTef(F_Tef, VL_Status);

  if VL_Erro <> 0 then
  begin
    F_Erro(VL_Erro, VL_DescricaoErro);
    ShowMessage('Erro: ' + IntToStr(VL_Erro) + #13 + 'Descrição:' + VL_DescricaoErro);
    Exit;
  end;

  if VL_Status <> Ord(csLogado) then
  begin
    MStatus.Lines.Add('Faça o login');
    exit;
  end;

  if not Assigned(F_TransacaoCreate) then
  begin
    ShowMessage('Inicialize a lib');
    Exit;
  end;

  // SOLICITA MENU OPERACIONAL
  VL_Erro := F_TransacaoCreate(F_Tef, PChar('00F5'), PChar(ECaixa.Text), VL_Transacao_ID, VL_Tempo);

  if VL_Erro <> 0 then
  begin
    F_Erro(VL_Erro, VL_DescricaoErro);
    ShowMessage('Erro: ' + IntToStr(VL_Erro) + #13 + 'Descrição:' + VL_DescricaoErro);
    Exit;
  end;

  MStatus.Clear;
  MStatus.Lines.add('Inicia transacao');

    {
    while ((TimeStampToMSecs(DateTimeToTimeStamp(now)) - TimeStampToMSecs(DateTimeToTimeStamp(VL_Data))) < VL_Tempo) do
    begin
        VL_Erro := F_TransacaoStatus(VL_TransacaoStatus, VL_TransacaoChave, VL_Transacao_ID);

        if VL_Erro <> 0 then
        begin
            F_Erro(VL_Erro, VL_StatusDescricao);
            F_TransacaoStatusDescricao(VL_DescricaoErroTransacao, VL_Transacao_ID);
            ShowMessage('Erro: ' + IntToStr(VL_Erro) + #13 + 'Descrição:' + VL_StatusDescricao + ' ' + VL_DescricaoErroTransacao);
            //F_TransacaoFree(VL_Transacao_ID);
            Exit;
        end;

        if Ord(tsCancelada) = VL_TransacaoStatus then
        begin
            F_TransacaoStatusDescricao(VL_DescricaoErroTransacao, VL_Transacao_ID);
            ShowMessage('Transação cancelada ' + VL_Transacao_ID + ' ' + VL_DescricaoErroTransacao);
            MStatus.Lines.Add('Transacao cancelada ' + VL_Transacao_ID + ' ' + VL_DescricaoErroTransacao);
            //F_TransacaoFree(VL_Transacao_ID);
            Exit;
        end;

        if Ord(tsNaoLocalizada) = VL_TransacaoStatus then
        begin
            F_TransacaoStatusDescricao(VL_DescricaoErroTransacao, VL_Transacao_ID);
            ShowMessage('Transação não localizada ' + VL_Transacao_ID + ' ' + VL_DescricaoErroTransacao);
            MStatus.Lines.Add('Transacao não localizada ' + VL_Transacao_ID + ' ' + VL_DescricaoErroTransacao);
            F_TransacaoFree(VL_Transacao_ID);
            Exit;
        end;

        if Ord(tsNegada) = VL_TransacaoStatus then
        begin
            F_TransacaoStatusDescricao(VL_DescricaoErroTransacao, VL_Transacao_ID);
            ShowMessage('Transação negada ' + VL_Transacao_ID + ' ' + VL_DescricaoErroTransacao);
            MStatus.Lines.Add('Transacao negada ' + VL_Transacao_ID + ' ' + VL_DescricaoErroTransacao);
            //F_TransacaoFree(VL_Transacao_ID);
            Exit;
        end;

        if Ord(tsEfetivada) = VL_TransacaoStatus then
        begin
            ShowMessage('Transação aprovada ' + VL_Transacao_ID);
            MStatus.Lines.Add('Transacao ID: ' + VL_Transacao_ID + ' efetivada');
            F_TransacaoFree(VL_Transacao_ID);
            Exit;
        end;

        if Ord(tsAbortada) = VL_TransacaoStatus then
        begin
            F_TransacaoStatusDescricao(VL_DescricaoErroTransacao, VL_Transacao_ID);
            ShowMessage('Transação abortada ' + VL_Transacao_ID + ' ' + VL_DescricaoErroTransacao);
            MStatus.Lines.Add('Transacao abortada ' + VL_Transacao_ID + ' ' + VL_DescricaoErroTransacao);
            //F_TransacaoFree(VL_Transacao_ID);
            Exit;
        end;


        Application.ProcessMessages;
        sleep(30);
        case VL_TransacaoStatus of
            Ord(tsProcessando): MStatus.Lines.Add('Transacao ID:' + VL_Transacao_ID + 'Estado de processamento');
            Ord(tsInicializada): MStatus.Lines.Add('Transacao ID:' + VL_Transacao_ID + 'Estado de inicializada');
            Ord(tsAguardandoComando): MStatus.Lines.Add('Transacao ID:' + VL_Transacao_ID + 'Estado de aguardando comando');
        end;
    end;

    if ((TimeStampToMSecs(DateTimeToTimeStamp(now)) - TimeStampToMSecs(DateTimeToTimeStamp(VL_Data))) > 5000) then
    begin
        MStatus.Lines.Add('Transacao ID:' + VL_Transacao_ID + 'Não foi respondida em tempo hábil');
        //F_TransacaoFree(VL_Transacao_ID);
    end;
    }
end;

procedure TF_Principal.BSolicitacaoBlocanteClick(Sender: TObject);
begin

end;

procedure TF_Principal.BSolicitacaoClick(Sender: TObject);
begin

end;

procedure TF_Principal.BTestaTagClick(Sender: TObject);
var
  VL_Mensagem: pointer;
  vl_dados: pansichar;
begin
  F_MensagemCreate(VL_Mensagem);
  vl_dados := '';
  F_MensagemCarregaTags(VL_Mensagem, PChar(trim(Memo1.Lines.Text)));
  F_MensagemGetTag(VL_Mensagem, PChar('010A'), VL_Dados);
  Caption := vl_dados;
  F_MensagemFree(VL_Mensagem);
end;

procedure TF_Principal.Button1Click(Sender: TObject);
var
  VL_Erro: integer;
  VL_Status: integer;
  VL_DescricaoErro: PChar;
begin

  VL_Status := 0;
  VL_DescricaoErro := '';

  if not Assigned(F_StatusOpenTef) then
  begin
    ShowMessage('Inicialize a lib');
    Exit;
  end;

  VL_Erro := F_StatusOpenTef(F_Tef, VL_Status);

  if VL_Erro <> 0 then
  begin
    F_Erro(VL_Erro, VL_DescricaoErro);
    ShowMessage('Erro: ' + IntToStr(VL_Erro) + #13 + 'Descrição:' + VL_DescricaoErro);
    lblStatusConexao.Caption := 'Desconectado';
    lblStatusConexao.Font.Color := clRed;
    Exit;
  end;

  if VL_Status = Ord(csLogado) then
  begin
    lblStatusConexao.Caption := 'Conectado';
    lblStatusConexao.Font.Color := clGreen;
  end
  else
  begin
    lblStatusConexao.Caption := 'Desconectado';
    lblStatusConexao.Font.Color := clRed;
  end;

end;

procedure TF_Principal.Button2Click(Sender: TObject);
var
  VL_Erro: integer;
  VL_Status: integer;
  VL_TransacaoID: PChar;
  VL_DescricaoErro: PChar;
  VL_Tempo: integer;
begin
  VL_TransacaoID := '';
  VL_Status := 0;
  VL_DescricaoErro := '';
  VL_Tempo := StrToInt(ETempo.Text); // tempo de espera

  if not Assigned(F_StatusOpenTef) then
  begin
    ShowMessage('Inicialize a lib');
    Exit;
  end;

  VL_Erro := F_StatusOpenTef(F_Tef, VL_Status);

  if VL_Erro <> 0 then
  begin
    F_Erro(VL_Erro, VL_DescricaoErro);
    ShowMessage('Erro: ' + IntToStr(VL_Erro) + #13 + 'Descrição: ' + VL_DescricaoErro);
    Exit;
  end;

  if VL_Status <> Ord(csLogado) then
  begin
    MStatus.Lines.Add('Faça o login');
    exit;
  end;

  if not Assigned(F_TransacaoCreate) then
  begin
    ShowMessage('Inicialize a lib');
    Exit;
  end;

  MStatus.Clear;
  MStatus.Lines.add('Inicia transacao de conciliacao');

  // SOLICITA APROVAÇÃO
  VL_Erro := F_TransacaoCreate(F_Tef, PChar('0113'), PChar(ECaixa.Text), VL_TransacaoID, VL_Tempo);

  if VL_Erro <> 0 then
  begin
    F_Erro(VL_Erro, VL_DescricaoErro);
    ShowMessage('Erro: ' + IntToStr(VL_Erro) + #13 + 'Descrição:' + VL_DescricaoErro);
    Exit;
  end;

  MChave.Lines.Clear;  // limpando memo para nao gerar conflitos entre chaves
end;

procedure TF_Principal.Button3Click(Sender: TObject);
begin

end;


procedure TF_Principal.BInicializarClick(Sender: TObject);
var
  VL_Codigo: integer;
  VL_AmbienteTeste: integer;
  VL_DescricaoErro: PChar;
begin
  try

    VL_DescricaoErro := '';

    if cbxAmbienteTeste.Checked then // ambiente de teste
      VL_AmbienteTeste := 1 // ativado
    else
      VL_AmbienteTeste := 0; // desativado

    if EPinPadLibHashMd5.Text <> '' then
    begin
      if EPinPadLibHashMd5.Text <> md5.MDPrint(md5.MD5File(ExtractFilePath(ParamStr(0)) + ETefLib.Text)) then
        ShowMessage('O Arquivo PinPad lib não esta com o Hash Válido');
    end
    else
      EPinPadLibHashMd5.Text :=
        md5.MDPrint(md5.MD5File(ExtractFilePath(ParamStr(0)) + ETefLib.Text));


    if EPinPadModeloLibHashMd5.Text <> '' then
    begin
      if EPinPadModeloLibHashMd5.Text <> md5.MDPrint(md5.MD5File(ExtractFilePath(ParamStr(0)) + EPinPadLib.Text)) then
        ShowMessage('O Arquivo Modelo lib não esta com o Hash Válido');
    end
    else
      EPinPadModeloLibHashMd5.Text :=
        md5.MDPrint(md5.MD5File(ExtractFilePath(ParamStr(0)) + EPinPadLib.Text));

    F_TefLib := LoadLibrary(PChar(ExtractFilePath(ParamStr(0)) + ETefLib.Text));

    Pointer(F_TefInicializar) := GetProcAddress(F_TefLib, 'inicializar');
    Pointer(F_Login) := GetProcAddress(F_TefLib, 'login');
    Pointer(F_Desconectar) := GetProcAddress(F_TefLib, 'desconectar');
    Pointer(F_SolicitacaoBlocante) :=
      GetProcAddress(F_TefLib, 'solicitacaoblocante');
    Pointer(F_Solicitacao) := GetProcAddress(F_TefLib, 'solicitacao');
    Pointer(F_StatusOpenTef) := GetProcAddress(F_TefLib, 'opentefstatus');
    Pointer(F_Finalizar) := GetProcAddress(F_TefLib, 'finalizar');

    Pointer(F_MensagemCreate) := GetProcAddress(F_TefLib, 'mensagemcreate');
    Pointer(F_MensagemCarregaTags) :=
      GetProcAddress(F_TefLib, 'mensagemcarregatags');
    Pointer(F_MensagemComando) := GetProcAddress(F_TefLib, 'mensagemcomando');
    Pointer(F_MensagemComandoDados) :=
      GetProcAddress(F_TefLib, 'mensagemcomandodados');
    Pointer(F_MensagemFree) := GetProcAddress(F_TefLib, 'mensagemfree');
    Pointer(F_MensagemLimpar) := GetProcAddress(F_TefLib, 'mensagemlimpar');
    Pointer(F_Mensagemaddtag) := GetProcAddress(F_TefLib, 'mensagemaddtag');
    Pointer(F_Mensagemaddcomando) := GetProcAddress(F_TefLib, 'mensagemaddcomando');
    Pointer(F_MensagemTagAsString) :=
      GetProcAddress(F_TefLib, 'mensagemtagasstring');
    Pointer(F_MensagemTagCount) := GetProcAddress(F_TefLib, 'mensagemtagcount');
    Pointer(F_MensagemGetTag) := GetProcAddress(F_TefLib, 'mensagemgettag');
    Pointer(F_MensagemGetTagIdx) := GetProcAddress(F_TefLib, 'mensagemgettagidx');
    Pointer(F_MensagemTagToStr) := GetProcAddress(F_TefLib, 'mensagemtagtostr');
    Pointer(F_Erro) := GetProcAddress(F_TefLib, 'mensagemerro');
    Pointer(F_MensagemGetTagPosicao) :=
      GetProcAddress(F_TefLib, 'mensagemgettagposicao');
    Pointer(F_MensagemAddTagPosicao) :=
      GetProcAddress(F_TefLib, 'mensagemaddtagposicao');

    Pointer(F_TransacaoCancela) := GetProcAddress(F_TefLib, 'transacaocancela');
    Pointer(F_TransacaoCreate) := GetProcAddress(F_TefLib, 'transacaocreate');
    Pointer(F_TransacaoFree) := GetProcAddress(F_TefLib, 'transacaofree');
    Pointer(F_TransacaoStatus) := GetProcAddress(F_TefLib, 'transacaostatus');
    Pointer(F_TransacaoStatusDescricao) :=
      GetProcAddress(F_TefLib, 'transacaostatusdescricao');
    Pointer(F_TransacaoGetTag) := GetProcAddress(F_TefLib, 'transacaogettag');


    Pointer(F_AlterarNivelLog) := GetProcAddress(F_TefLib, 'alterarnivellog');
    Pointer(F_Versao) := GetProcAddress(F_TefLib, 'versao');

    VL_Codigo := F_TefInicializar(F_Tef, StrToPinPadModelo(EPinPadModelo.Text), PChar(ExtractFilePath(ParamStr(0)) + EPinPadModeloLib.Text),
      PChar(EPinPadModeloPorta.Text), PChar(ExtractFilePath(ParamStr(0)) + EPinPadLib.Text), PChar(F_ArquivoLog),
      @uprincipal.Retorno, @uprincipal.solicitadadostransacao, @uprincipal.solicitadadospdv, @uprincipal.imprime, @uprincipal.mostramenu, @uprincipal.mensagemoperador, VL_AmbienteTeste);

    if VL_Codigo <> 0 then
    begin
      F_Erro(VL_Codigo, VL_DescricaoErro);
      ShowMessage('Erro: ' + IntToStr(VL_Codigo) + #13 + 'Descrição:' + VL_DescricaoErro);
      exit;
    end;

    F_MensagemCreate(F_Mensagem);

  except
    on e: Exception do
      ShowMessage('Erro ao carregar a Lib ' + e.Message);
  end;
end;

procedure TF_Principal.BFinalizarTefClick(Sender: TObject);
var
  VL_Codigo: integer;
  VL_DescricaoErro: PChar;
begin
  VL_DescricaoErro := '';

  if not Assigned(F_Finalizar) then
  begin
    ShowMessage('Inicialize a lib');
    Exit;
  end;

  VL_Codigo := F_Finalizar(F_Tef);

  if VL_Codigo <> 0 then
  begin
    F_Erro(VL_Codigo, VL_DescricaoErro);
    ShowMessage('Erro: ' + IntToStr(VL_Codigo) + #13 + 'Descrição: ' + VL_DescricaoErro);
    exit;
  end;

  if Assigned(F_Mensagem) then
    F_MensagemFree(F_Mensagem);

  UnloadLibrary(F_TefLib);
end;

procedure TF_Principal.BAlterarNivelLogClick(Sender: TObject);
begin
  if not Assigned(F_AlterarNivelLog) then
  begin
    ShowMessage('Inicialize a lib');
    Exit;
  end;

  F_AlterarNivelLog(StrToInt(ELogNivel.Text));
end;

procedure TF_Principal.BDesconectarClick(Sender: TObject);
var
  VL_Codigo: integer;
  VL_DescricaoErro: PChar;
begin
  VL_Codigo := F_Desconectar(F_Tef);

  if VL_Codigo <> 0 then
  begin
    F_Erro(VL_Codigo, VL_DescricaoErro);
    ShowMessage('Erro: ' + IntToStr(VL_Codigo) + #13 + 'Descrição: ' + VL_DescricaoErro);
    exit;
  end;

  lblStatusConexao.Caption := 'Desconectado';
  lblStatusConexao.Font.Color := clRed;
end;

procedure TF_Principal.BLoginClick(Sender: TObject);
var
  VL_Codigo: integer;
  VL_DescricaoErro: PChar;
begin
  VL_DescricaoErro := '';

  if not Assigned(F_Login) then
  begin
    ShowMessage('Inicialize a lib');
    Exit;
  end;

  VL_Codigo := F_Login(F_Tef, PChar(EHost.Text), StrToInt(EPorta.Text), StrToInt(EID.Text), PChar(Trim(EChave.Lines.Text)), C_mensagem, PChar(trim(EIdentificador.Lines.Text)));

  if VL_Codigo <> 0 then
  begin
    F_Erro(VL_Codigo, VL_DescricaoErro);
    ShowMessage('Erro: ' + IntToStr(VL_Codigo) + #13 + 'Descrição: ' + VL_DescricaoErro);
    exit;
  end;

  lblStatusConexao.Caption := 'Conectado';
  lblStatusConexao.Font.Color := clGreen;
end;

procedure TF_Principal.BVendaClick(Sender: TObject);
var
  VL_Erro: integer;
  VL_Status: integer;
  VL_TransacaoID: PChar;
  VL_DescricaoErro: PChar;
  VL_Tempo: integer;
begin
  VL_TransacaoID := '';
  VL_Status := 0;
  VL_DescricaoErro := '';
  VL_Tempo := StrToInt(ETempo.Text); // tempo de espera

  if not Assigned(F_StatusOpenTef) then
  begin
    ShowMessage('Inicialize a lib');
    Exit;
  end;

  VL_Erro := F_StatusOpenTef(F_Tef, VL_Status);

  if VL_Erro <> 0 then
  begin
    F_Erro(VL_Erro, VL_DescricaoErro);
    ShowMessage('Erro: ' + IntToStr(VL_Erro) + #13 + 'Descrição: ' + VL_DescricaoErro);
    Exit;
  end;

  if VL_Status <> Ord(csLogado) then
  begin
    MStatus.Lines.Add('Faça o login');
    exit;
  end;

  if not Assigned(F_TransacaoCreate) then
  begin
    ShowMessage('Inicialize a lib');
    Exit;
  end;

  MStatus.Clear;
  MStatus.Lines.add('Inicia transacao de venda');

  // SOLICITA APROVAÇÃO
  VL_Erro := F_TransacaoCreate(F_Tef, PChar('000A'), PChar(ECaixa.Text), VL_TransacaoID, VL_Tempo);

  if VL_Erro <> 0 then
  begin
    F_Erro(VL_Erro, VL_DescricaoErro);
    ShowMessage('Erro: ' + IntToStr(VL_Erro) + #13 + 'Descrição:' + VL_DescricaoErro);
    Exit;
  end;

  MChave.Lines.Clear;  // limpando memo para nao gerar conflitos entre chaves
  MChave.Lines.Text := VL_TransacaoID;
    {
    while ((TimeStampToMSecs(DateTimeToTimeStamp(now)) - TimeStampToMSecs(DateTimeToTimeStamp(VL_Data))) < VL_Tempo) do
    begin
        VL_Erro := F_TransacaoStatus(VL_TransacaoStatus, VL_TransacaoChave, VL_TransacaoID);

        if VL_Erro <> 0 then
        begin
            F_Erro(VL_Erro, VL_DescricaoErro);
            F_TransacaoStatusDescricao(VL_DescricaoErroTransacao, VL_TransacaoID);
            ShowMessage('Erro: ' + IntToStr(VL_Erro) + #13 + 'Descrição:' + VL_DescricaoErro + '  ' + VL_DescricaoErroTransacao);
            F_TransacaoFree(VL_TransacaoID);
            Exit;
        end;

        if Ord(tsCancelada) = VL_TransacaoStatus then
        begin
            F_TransacaoStatusDescricao(VL_DescricaoErroTransacao, VL_TransacaoID);
            ShowMessage('Transação cancelada ' + VL_TransacaoID + ' ' + VL_DescricaoErroTransacao);
            MStatus.Lines.Add('Transação cancelada ' + VL_TransacaoID + ' ' + VL_DescricaoErroTransacao);
            F_TransacaoFree(VL_TransacaoID);
            Exit;
        end;

        if Ord(tsNegada) = VL_TransacaoStatus then
        begin
            F_TransacaoStatusDescricao(VL_DescricaoErroTransacao, VL_TransacaoID);
            ShowMessage('Transação negada ' + VL_TransacaoID + ' ' + VL_DescricaoErroTransacao);
            MStatus.Lines.Add('Transação negada ' + VL_TransacaoID + ' ' + VL_DescricaoErroTransacao);
            F_TransacaoFree(VL_TransacaoID);
            Exit;
        end;


        if Ord(tsNaoLocalizada) = VL_TransacaoStatus then
        begin
            F_TransacaoStatusDescricao(VL_DescricaoErroTransacao, VL_TransacaoID);
            ShowMessage('Transação não localizada ' + VL_TransacaoID + ' ' + VL_DescricaoErroTransacao);
            MStatus.Lines.Add('Transação não localizada ' + VL_TransacaoID + ' ' + VL_DescricaoErroTransacao);
            F_TransacaoFree(VL_TransacaoID);
            Exit;
        end;


        if Ord(tsEfetivada) = VL_TransacaoStatus then
        begin
            ShowMessage('Transação aprovada ' + VL_TransacaoID);
            MChave.Lines.Add(VL_TransacaoChave);
            MStatus.Lines.Add('Transacao ID: ' + VL_TransacaoID + ' Efetivada');
            F_TransacaoFree(VL_TransacaoID);
            Exit;
        end;

        if Ord(tsAbortada) = VL_TransacaoStatus then
        begin
            F_TransacaoStatusDescricao(VL_DescricaoErroTransacao, VL_TransacaoID);
            ShowMessage('Transação abortada ' + VL_TransacaoID + ' ' + VL_DescricaoErroTransacao);
            MStatus.Lines.Add('Transação abortada ' + VL_TransacaoID + ' ' + VL_DescricaoErroTransacao);
            F_TransacaoFree(VL_TransacaoID);
            Exit;
        end;


        Application.ProcessMessages;
        sleep(100);
        case VL_TransacaoStatus of
            Ord(tsProcessando): MStatus.Lines.Add('Transacao ID:' + VL_TransacaoID + 'Estado de processamento');
            Ord(tsInicializada): MStatus.Lines.Add('Transacao ID:' + VL_TransacaoID + 'Estado de inicializada');
            Ord(tsAguardandoComando): MStatus.Lines.Add('Transacao ID:' + VL_TransacaoID + 'Estado de aguardando comando');
        end;
    end;

    if ((TimeStampToMSecs(DateTimeToTimeStamp(now)) - TimeStampToMSecs(DateTimeToTimeStamp(VL_Data))) > 5000) then
    begin
        MStatus.Lines.Add('Transacao ID:' + VL_TransacaoID + 'Não foi respondida em tempo hábil');
        F_TransacaoFree(VL_TransacaoID);
    end;

    }
end;

procedure TF_Principal.cbxAmbienteTesteChange(Sender: TObject);
begin
    {
    if cbxAmbienteTeste.Checked then
    begin
        ETefLib.Text := 'tef_lib.dll';
        EPinPadModelo.Text := 'NDF';
    end
    else
    begin
        ETefLib.Text := '..\tef_lib\win64\tef_lib.dll';
        EPinPadModelo.Text := 'GERTEC_PPC930';
    end;
    }
end;

procedure TF_Principal.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if Assigned(F_Mensagem) then
    F_MensagemFree(F_Mensagem);

  if Assigned(F_Finalizar) then
    F_Finalizar(F_Tef);

  if F_TefLib <> 0 then
    UnloadLibrary(F_TefLib);

end;

procedure TF_Principal.FormCreate(Sender: TObject);
begin
  F_Mensagem := nil;
  F_Tef := nil;
  F_ArquivoLog := ExtractFilePath(ParamStr(0)) + 'appopentef.log';

  {$IF DEFINED(WIN64)}
         ETefLib.Text := '..\..\tef_lib\win64\tef_lib.dll';
         EPinPadLib.Text := '..\..\pinpad_lib\win64\pinpad_lib.dll';
         EPinPadModeloLib.Text := '..\..\pinpad_lib\win64\';
  {$ENDIF}

  {$IF DEFINED(WIN32)}
         ETefLib.Text := '..\..\tef_lib\win32\tef_lib.dll';
         EPinPadLib.Text := '..\..\pinpad_lib\win32\pinpad_lib.dll';
         EPinPadModeloLib.Text := '..\..\pinpad_lib\win32\';
  {$ENDIF}

  {$IF DEFINED(LINUX64)}
         ETefLib.Text := '../../tef_lib/linux64/libtef_lib.so';
         EPinPadLib.Text := '../../pinpad_lib/linux64/libpinpad_lib.so';
         EPinPadModeloLib.Text := '../../pinpad_lib/linux64/';
  {$ENDIF}

  {$IF DEFINED(LINUX32)}
         ETefLib.Text := '../../tef_lib/linux32/tef_lib.so';
         EPinPadLib.Text := '../../pinpad_lib/linux32/pinpad_lib.so';
         EPinPadModeloLib.Text := '../../pinpad_lib/linux32/';
  {$ENDIF}

end;

procedure TF_Principal.FormDestroy(Sender: TObject);
begin

end;

function StrToPinPadModelo(VP_PinPadModelo: ansistring): integer;
begin
  VP_PinPadModelo := UpperCase(VP_PinPadModelo);
  case VP_PinPadModelo of
    'NDF': Result := 0;
    'GERTEC_PPC930': Result := 1;
    else
      Result := 0
  end;

end;

procedure TF_Principal.retornoConciliacao(VP_Dados: PChar);
var
  VL_PosicaoConciliacao, VL_PosicaoVenda, VL_ConciliacaoQuantidade, VL_VendaQuantidade: integer;
  VL_Erro: integer;
  VL_Mensagem, VL_Venda: Pointer;
  VL_String, VL_Bin, VL_DescricaoErro: PChar;
  VL_Arquivo_Nome: ansistring;
  VL_Arquivo: Text;
begin
  VL_DescricaoErro := '';
  VL_String := '';
  VL_Bin := '';
  VL_Arquivo_Nome := '';
  VL_Mensagem := nil;
  VL_Venda := nil;
  VL_PosicaoVenda := 0;

  F_MensagemCreate(VL_Mensagem);
  F_MensagemCreate(VL_Venda);

  VL_Erro := F_MensagemCarregaTags(VL_Mensagem, VP_Dados);

  if VL_Erro <> 0 then
  begin
    F_Erro(VL_Erro, VL_DescricaoErro);
    ShowMessage('Erro: ' + IntToStr(VL_Erro) + #13 + 'Descrição: ' + VL_DescricaoErro);
    Exit;
  end;

  F_MensagemGetTag(VL_Mensagem, '0119', VL_String); // quantidade de linha na tabela
  VL_ConciliacaoQuantidade := StrToInt(VL_String);

  MDConciliacao.EmptyTable;

  for VL_PosicaoConciliacao := 1 to VL_ConciliacaoQuantidade do
  begin
    F_MensagemGetTagPosicao(VL_Mensagem, VL_PosicaoConciliacao, '0036', VL_Bin);
    // bin

    F_MensagemGetTagPosicao(VL_Mensagem, VL_PosicaoConciliacao, '004D', VL_String);
    // mensagem com erro

    if VL_String <> '' then
      VL_Erro := StrToInt(VL_String);

    if VL_Erro <> 0 then
    begin
      MDConciliacao.Insert;
      MDConciliacao.FieldByName('S_BIN').AsString := VL_Bin;

      MDConciliacao.FieldByName('S_NSU').AsString := '';
      MDConciliacao.FieldByName('S_PARCELA').AsString := '';
      MDConciliacao.FieldByName('S_VALOR').AsString := '';
      MDConciliacao.FieldByName('S_ERRO').AsString := IntToStr(VL_Erro);

      MDConciliacao.Post;
      continue;
    end;

    F_MensagemGetTagPosicao(VL_Mensagem, VL_PosicaoConciliacao, '004A', VL_String);
    // mensagem com erro
    VL_String := PChar(trim(VL_String));

    if VL_String <> '' then
    begin
      MDConciliacao.Insert;
      MDConciliacao.FieldByName('S_BIN').AsString := VL_Bin;

      MDConciliacao.FieldByName('S_NSU').AsString := '';
      MDConciliacao.FieldByName('S_PARCELA').AsString := '';
      MDConciliacao.FieldByName('S_VALOR').AsString := '';
      MDConciliacao.FieldByName('S_ERRO').AsString := VL_String;

      MDConciliacao.Post;
      continue;
    end;

    F_MensagemGetTagPosicao(VL_Mensagem, VL_PosicaoConciliacao, '0117', VL_String);
    // dados da conciliacao

    VL_Erro := F_MensagemCarregaTags(VL_Venda, VL_String);

    if VL_Erro <> 0 then
    begin
      MDConciliacao.Insert;
      MDConciliacao.FieldByName('S_BIN').AsString := VL_Bin;

      MDConciliacao.FieldByName('S_NSU').AsString := '';
      MDConciliacao.FieldByName('S_PARCELA').AsString := '';
      MDConciliacao.FieldByName('S_VALOR').AsString := '';
      MDConciliacao.FieldByName('S_ERRO').AsString := IntToStr(VL_Erro);

      MDConciliacao.Post;
      continue;
    end;

    F_MensagemGetTag(VL_Venda, '0119', VL_String); // quantidade de linha na tabela
    VL_VendaQuantidade := StrToInt(VL_String);

    for VL_PosicaoVenda := 1 to VL_VendaQuantidade do
    begin
      MDConciliacao.Insert;
      MDConciliacao.FieldByName('S_BIN').AsString := VL_Bin;

      F_MensagemGetTagPosicao(VL_Venda, VL_PosicaoVenda, '000B', VL_String); // nsu
      MDConciliacao.FieldByName('S_NSU').AsString := VL_String;

      F_MensagemGetTagPosicao(VL_Venda, VL_PosicaoVenda, '000F', VL_String);
      // parcela
      MDConciliacao.FieldByName('S_PARCELA').AsString := VL_String;

      F_MensagemGetTagPosicao(VL_Venda, VL_PosicaoVenda, '000E', VL_String);
      // VALOR
      MDConciliacao.FieldByName('S_VALOR').AsString := VL_String;

      MDConciliacao.FieldByName('S_ERRO').AsString := '';

      MDConciliacao.Post;
      continue;
    end;
  end;

  if CSalvarCSV.Checked then
  begin
    VL_Arquivo_Nome := ExtractFilePath(ParamStr(0)) + 'conciliacao.csv';

    if FileExists(VL_Arquivo_Nome) then
      DeleteFile(VL_Arquivo_Nome);

    AssignFile(VL_Arquivo, VL_Arquivo_Nome);
    Rewrite(VL_Arquivo);

    // CABECALHO
    Write(VL_Arquivo, 'BIN');
    Write(VL_Arquivo, ';');
    Write(VL_Arquivo, 'NSU');
    Write(VL_Arquivo, ';');
    Write(VL_Arquivo, 'PARCELA');
    Write(VL_Arquivo, ';');
    Write(VL_Arquivo, 'VALOR');
    Write(VL_Arquivo, ';');
    Write(VL_Arquivo, 'ERRO');

    // corpo
    for VL_PosicaoConciliacao := 1 to VL_ConciliacaoQuantidade do
    begin
      F_MensagemGetTagPosicao(VL_Mensagem, VL_PosicaoConciliacao, '0036', VL_Bin);
      // bin
      F_MensagemGetTagPosicao(VL_Mensagem, VL_PosicaoConciliacao,
        '004D', VL_String);
      // mensagem com erro

      if VL_String <> '' then
        VL_Erro := StrToInt(VL_String);

      if VL_Erro <> 0 then
      begin
        Writeln(VL_Arquivo);
        Write(VL_Arquivo, VL_Bin);
        Write(VL_Arquivo, ';');

        Write(VL_Arquivo, ''); // nsu
        Write(VL_Arquivo, ';');

        Write(VL_Arquivo, ''); // parcela
        Write(VL_Arquivo, ';');

        Write(VL_Arquivo, ''); // VALOR
        Write(VL_Arquivo, ';');

        Write(VL_Arquivo, IntToStr(VL_Erro)); // erro
        continue;
      end;

      F_MensagemGetTagPosicao(VL_Mensagem, VL_PosicaoConciliacao,
        '004A', VL_String);
      // mensagem com erro
      VL_String := PChar(trim(VL_String));

      if VL_String <> '' then
      begin
        Writeln(VL_Arquivo);
        Write(VL_Arquivo, VL_Bin);
        Write(VL_Arquivo, ';');

        Write(VL_Arquivo, ''); // nsu
        Write(VL_Arquivo, ';');

        Write(VL_Arquivo, ''); // parcela
        Write(VL_Arquivo, ';');

        Write(VL_Arquivo, ''); // VALOR
        Write(VL_Arquivo, ';');

        Write(VL_Arquivo, VL_String); // erro
        continue;
      end;

      F_MensagemGetTagPosicao(VL_Mensagem, VL_PosicaoConciliacao,
        '0117', VL_String);
      // dados da conciliacao

      VL_Erro := F_MensagemCarregaTags(VL_Venda, VL_String);

      if VL_Erro <> 0 then
      begin
        Writeln(VL_Arquivo);
        Write(VL_Arquivo, VL_Bin);
        Write(VL_Arquivo, ';');

        Write(VL_Arquivo, ''); // nsu
        Write(VL_Arquivo, ';');

        Write(VL_Arquivo, ''); // parcela
        Write(VL_Arquivo, ';');

        Write(VL_Arquivo, ''); // VALOR
        Write(VL_Arquivo, ';');

        Write(VL_Arquivo, IntToStr(VL_Erro)); // erro
        continue;
      end;

      F_MensagemGetTag(VL_Venda, '0119', VL_String);
      // quantidade de linha na tabela
      VL_VendaQuantidade := StrToInt(VL_String);

      for VL_PosicaoVenda := 1 to VL_VendaQuantidade do
      begin
        Writeln(VL_Arquivo);
        Write(VL_Arquivo, VL_Bin);
        Write(VL_Arquivo, ';');

        F_MensagemGetTagPosicao(VL_Venda, VL_PosicaoVenda, '000B', VL_String);
        // nsu
        Write(VL_Arquivo, VL_String);
        Write(VL_Arquivo, ';');

        F_MensagemGetTagPosicao(VL_Venda, VL_PosicaoVenda, '000F', VL_String);
        // parcela
        Write(VL_Arquivo, VL_String);
        Write(VL_Arquivo, ';');

        F_MensagemGetTagPosicao(VL_Venda, VL_PosicaoVenda, '000E', VL_String);
        // VALOR
        Write(VL_Arquivo, VL_String);
      end;
    end;

    Flush(VL_Arquivo);
    CloseFile(VL_Arquivo);
  end;

  F_MensagemFree(VL_Mensagem);
  F_MensagemFree(VL_Venda);
end;


end.
