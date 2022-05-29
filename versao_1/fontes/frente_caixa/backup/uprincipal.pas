unit uprincipal;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBGrids,
    ExtCtrls, DateTimePicker, def;

type
    { TF_Principal }

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



    TResposta = record
        Codigo: integer;
        Dados: ansistring;

    end;
    TConexaoStatus = (csDesconectado, csLink, csChaveado, csLogado);
    TransacaoStatus = (tsEfetivada, tsNegada, tsCancelada, tsProcessando, tsAguardandoComando, tsNaoLocalizada, tsInicializada, tsComErro, tsAbortada);

    PResposta = ^TResposta;

    TRetorno = procedure(VP_Transmissao_ID: PChar; VP_ProcID, VP_Codigo: integer; VP_Dados: PChar); stdcall;
    TSolicitaDados = function(VP_Memsagem: PChar; var VO_Dados: PChar): integer; stdcall;
    TImprime = function(VP_Dados: PChar): integer; stdcall;
    TMostraMenu = function(VP_Dados: PChar; var VO_Selecionado: PChar): integer; stdcall;
    TMensagemOperador = function(VP_Dados: PChar): integer; stdcall;



    TF_Principal = class(TForm)
        BInicializar: TButton;
        BLogin: TButton;
        BTestePinPad: TButton;
        BVenda: TButton;
        BMenu: TButton;
        EPinPadModeloLib: TEdit;
        ETefLib: TEdit;
        EPinPadLib: TEdit;
        EPinPadModelo: TEdit;
        EPinPadModeloPorta: TEdit;
        ETempo: TEdit;
        EDataHora: TDateTimePicker;
        ECartao: TEdit;
        EChave: TMemo;
        EHost: TEdit;
        EPorta: TEdit;
        EValor: TEdit;
        EParcela: TEdit;
        ENSU: TEdit;
        ECupomFiscal: TEdit;
        ECaixa: TEdit;
        EOperador: TEdit;
        EValorAlimentacao: TEdit;
        EValorItens: TEdit;
        EValorRefeicao: TEdit;
        EValorValeCultura: TEdit;
        GroupBox1: TGroupBox;
        GroupBox2: TGroupBox;
        GroupBox3: TGroupBox;
        GroupBox4: TGroupBox;
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
        Label2: TLabel;
        Label20: TLabel;
        Label21: TLabel;
        Label22: TLabel;
        Label23: TLabel;
        Label3: TLabel;
        Label4: TLabel;
        Label5: TLabel;
        Label6: TLabel;
        Label7: TLabel;
        Label8: TLabel;
        Label9: TLabel;
        EXml: TMemo;
        MStatus: TMemo;
        Panel1: TPanel;
        procedure BInicializarClick(Sender: TObject);
        procedure BLoginClick(Sender: TObject);
        procedure BMenuClick(Sender: TObject);
        procedure BTestePinPadClick(Sender: TObject);
        procedure BVendaClick(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure MontarMenu(VP_Mensagem: Pointer);
    private
        procedure CliqueDoBotao(VP_Botao: TObject);

    public

    end;

    TTefInicializar = function(VP_PinPadModelo: integer; VP_PinPadModeloLib, VP_PinPadModeloPorta, VP_PinPadLib, VP_ArquivoLog: PChar;
        VP_Procedimento: TRetorno; VP_SolicitaDados: TSolicitaDados; VP_Imprime: TImprime; VP_MostraMenu: TMostraMenu;
        VP_MensagemOperador: TMensagemOperador): integer; stdcall;
    TTLogin = function(VP_Host: PChar; VP_Porta: integer; VP_Chave: PChar; VP_Versao_Comunicacao: integer): integer; stdcall;

    TTSolicitacao = function(VP_Transmissao_ID, VP_Dados: PChar; VP_Procedimento: TRetorno; VP_TempoAguarda: integer): integer; stdcall;
    TTSolicitacaoBlocante = function(var VO_Transmissao_ID, VP_Dados: PChar; var VO_Retorno: PChar; VP_TempoAguarda: integer): integer; stdcall;
    TTOpenTefStatus = function(var VO_StatusRetorno: integer): integer; stdcall;
    TTMensagemCreate = function(var VO_Mensagem: Pointer): integer; stdcall;
    TTMensagemCarregaTags = function(VP_Mensagem: Pointer; VP_Dados: PChar): integer; stdcall;
    TTMensagemComando = function(VP_Mensagem: Pointer): PChar; stdcall;
    TTMensagemComandoDados = function(VP_Mensagem: Pointer): PChar; stdcall;
    TTMensagemFree = procedure(VP_Mensagem: Pointer); stdcall;
    TTMensagemaddtag = function(VP_Mensagem: Pointer; VP_Tag, VP_Dados: PChar): integer; stdcall;
    TTMensagemaddcomando = function(VP_Mensagem: Pointer; VP_Tag, VP_Dados: PChar): integer; stdcall;
    TTMensagemTagAsString = function(VP_Mensagem: Pointer): PChar; stdcall;
    TTMensagemTagCount = function(VO_Mensagem: Pointer): integer; stdcall;
    TTMensagemGetTag = function(VO_Mensagem: Pointer; VP_Tag: PChar; var VO_Dados: PChar): integer; stdcall;
    TTMensagemGetTagIdx = function(VO_Mensagem: Pointer; VL_Idx: integer; var VO_Tag: PChar; var VO_Dados: PChar): integer; stdcall;
    TTMensagemTagToStr = function(VO_Mensagem: Pointer; var VO_Dados: PChar): integer; stdcall;

    TTransacaocreate = function(VP_IdentificadorCaixa: PChar; var VO_TransacaID: PChar; VP_TempoAguarda: integer): integer; stdcall;
    TTransacaostatus = function(var VO_Status: integer; VP_TransacaoID: PChar): integer; stdcall;
    TTransacaocancela = function(var VO_Resposta: integer; VP_TransacaoID: PChar): integer; stdcall;
    TTransacaofree = procedure(VP_TransacaoID: PChar); stdcall;




procedure P_Retorno(VP_Transmissao_ID: PChar; VP_ProcID, VP_Codigo: integer; VP_Dados: PChar); stdcall;

function solicitadados(VP_Memsagem: PChar; var VO_Dados: PChar): integer; stdcall;
function imprime(VP_Dados: PChar): integer; stdcall;
function mostramenu(VP_Dados: PChar; var VO_Selecionado: PChar): integer; stdcall;
function mensagemoperador(VP_Dados: PChar): integer; stdcall;

var
    F_Principal: TF_Principal;
    F_SolicitacaoBlocante: TTSolicitacaoBlocante;
    F_Resposta: PResposta;
    F_Procedure: TRetorno;
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

    F_Mensagem: Pointer;
    F_Transacao: TTransacao;
    F_ArquivoLog: string;


function StrToPinPadModelo(VP_PinPadModelo: string): integer;




implementation

{$R *.lfm}

{ TF_Principal }

uses
    utestepinpad, umenuvenda;

function StrToPinPadModelo(VP_PinPadModelo: string): integer;
begin
    VP_PinPadModelo := UpperCase(VP_PinPadModelo);
    case VP_PinPadModelo of
        'NDF': Result := 0;
        'GERTEC_PPC930': Result := 1;
        else
            Result := 0
    end;

end;


procedure P_Retorno(VP_Transmissao_ID: PChar; VP_ProcID, VP_Codigo: integer; VP_Dados: PChar); stdcall;
var

    VL_Mensagem: Pointer;
begin

    F_MensagemCreate(VL_Mensagem);

    F_MensagemCarregaTags(VL_Mensagem, PChar(VP_Dados));
    if F_MensagemComando(VL_Mensagem) = '0026' then
    begin
        ShowMessage('Erro:' + F_MensagemComandoDados(VL_Mensagem));
        F_MensagemFree(VL_Mensagem);
        Exit;
    end;


    if F_MensagemComando(VL_Mensagem) = '0018' then //Veio pedido de mostrar menu
    begin
       // monta o menu e aguarda a escolha pelo operador

        F_Principal.MontarMenu(VL_Mensagem);

    end

    else
        ShowMessage('Erro dados não esperados');

end;

function solicitadados(VP_Memsagem: PChar; var VO_Dados: PChar): integer; stdcall;
begin

end;

function imprime(VP_Dados: PChar): integer; stdcall;
begin

end;

function mostramenu(VP_Dados: PChar; var VO_Selecionado: PChar): integer; stdcall;
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
    F_MensagemCarregaTags(F_Mensagem, VP_Dados);
    VL_MenuVenda := TF_MenuVenda.Create(F_Principal);
    VL_btn := TMButton.Create(VL_MenuVenda.Painel);
    VL_btn.V_tag := '0030';
    VL_btn.Caption := 'Cancela';
    VL_btn.Align := alTop;
    VL_btn.Height := 20;
    VL_btn.BorderSpacing.Around := 20;
    VL_btn.Parent := VL_MenuVenda.Painel;
    VL_btn.TabOrder := 0;
    VL_btn.OnClick := @F_Principal.CliqueDoBotao;

    for VL_I := 1 to F_MensagemTagCount(F_Mensagem) do
    begin
        F_MensagemGetTagIdx(F_Mensagem, VL_i, VL_Tag, VL_Dados);
        if VL_Tag <> '0030' then
        begin
            VL_btn := TMButton.Create(VL_MenuVenda.Painel);
            F_MensagemGetTagIdx(F_Mensagem, VL_i, VL_Tag, VL_Dados);
            VL_btn.V_tag := VL_tag;
            VL_btn.Caption := VL_Dados;
            VL_btn.Align := alTop;
            VL_btn.Height := 20;
            VL_btn.BorderSpacing.Around := 20;
            VL_btn.Parent := VL_MenuVenda.Painel;
            VL_btn.TabOrder := 0;
            VL_MenuVenda.Height := VL_MenuVenda.Height + 40;
            VL_btn.OnClick := @F_Principal.CliqueDoBotao;
        end;
    end;
    VL_MenuVenda.Height := VL_MenuVenda.Height + 40;
    F_Principal.MStatus.Lines.Add('TransacaoID:' + F_MensagemComandoDados(F_Mensagem));
    VL_MenuVenda.ShowModal;

    VO_Selecionado := StrAlloc(Length(VL_MenuVenda.V_Botao) + 1);
    StrPCopy(VO_Selecionado, VL_MenuVenda.V_Botao);
    VL_MenuVenda.Free;

end;

function mensagemoperador(VP_Dados: PChar): integer; stdcall;
begin

end;

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


procedure TF_Principal.CliqueDoBotao(VP_Botao: TObject);
var
    VL_Botao: ansistring;
begin

    VL_Botao := TMButton(VP_Botao).v_tag;
    TF_MenuVenda(TPanel(TMButton(VP_Botao).Parent).Parent).V_Botao := VL_Botao;
    TForm(TPanel(TMButton(VP_Botao).Parent).Parent).Close;

end;

procedure TF_Principal.FormShow(Sender: TObject);
var
    i: integer;
begin
{    with self do
    begin
        for i := 0 to ComponentCount - 1 do
        begin
            if Components[i] is TEdit then
                TEdit(Components[i]).Text := '';
        end;
    end;
    EHost.Text := '127.0.0.1';
    EPorta.Text := '1000';
    ETempo.Text := '20000';    }
    EDataHora.DateTime := now;
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
    VL_btn := TMButton.Create(F_MenuVenda.Painel);
    VL_btn.V_tag := '0030';
    VL_btn.Caption := 'Cancela';
    VL_btn.Align := alTop;
    VL_btn.Height := 20;
    VL_btn.BorderSpacing.Around := 20;
    VL_btn.Parent := F_MenuVenda.Painel;
    VL_btn.TabOrder := 0;
    VL_btn.OnClick := @CliqueDoBotao;

    for VL_I := 1 to F_MensagemTagCount(VP_Mensagem) do
    begin
        F_MensagemGetTagIdx(VP_Mensagem, VL_i, VL_Tag, VL_Dados);
        if VL_Tag <> '0030' then
        begin
            VL_btn := TMButton.Create(F_MenuVenda.Painel);
            F_MensagemGetTagIdx(VP_Mensagem, VL_i, VL_Tag, VL_Dados);
            VL_btn.V_tag := VL_tag;
            VL_btn.Caption := VL_Dados;
            VL_btn.Align := alTop;
            VL_btn.Height := 20;
            VL_btn.BorderSpacing.Around := 20;
            VL_btn.Parent := F_MenuVenda.Painel;
            VL_btn.TabOrder := 0;
            VL_btn.OnClick := @CliqueDoBotao;
            F_MenuVenda.Height := F_MenuVenda.Height + 40;
        end;
    end;
    F_MenuVenda.Height := F_MenuVenda.Height + 40;
    MStatus.Lines.Add('TransacaoID:' + F_MensagemComandoDados(VP_Mensagem));
    F_MenuVenda.Position := poDesktopCenter;
    F_MenuVenda.ShowModal;
    F_MenuVenda.Free;

end;



procedure TF_Principal.BLoginClick(Sender: TObject);
var
    VL_Codigo: integer;
begin
    MStatus.Clear;
    MStatus.Lines.add('Iniciando login...');

    VL_Codigo := F_Login(PChar(EHost.Text), StrToInt(EPorta.Text), PChar(Trim(EChave.Lines.Text)), C_mensagem);

    if VL_Codigo <> 0 then
    begin
        MStatus.Lines.add('erro:' + IntToStr(VL_Codigo));
        exit;
    end;
    MStatus.Lines.add('Logado');
end;

procedure TF_Principal.BMenuClick(Sender: TObject);
var
    VL_Erro: integer;
    VL_Status: integer;
    VL_DadosOUT: PChar;
    VL_DadosIN: PChar;
    VL_Transmissao_ID: PChar;
begin
    VL_DadosOUT := '';
    VL_DadosIN := '';
    VL_Transmissao_ID := '';
    VL_Status := 0;

    VL_Erro := F_StatusOpenTef(VL_Status);

    if VL_Erro <> 0 then
    begin
        ShowMessage('erro ' + IntToStr(VL_Erro));
        Exit;
    end;

    if VL_Status <> Ord(csLogado) then
    begin
        MStatus.Lines.Add('faça o login');
        exit;
    end;


    MStatus.Clear;
    MStatus.Lines.add('Inicia transacao de venda');

    // SOLICITA MENU

    F_MensagemAddComando(F_Mensagem, PChar('0018'), PChar('S'));
    VL_Erro := F_MensagemTagToStr(F_Mensagem, VL_DadosOUT);

    if VL_Erro <> 0 then
    begin
        ShowMessage('erro ' + IntToStr(VL_Erro));
        MStatus.Lines.add('erro na montagem do pacote');
        Exit;
    end;


    VL_Erro := F_SolicitacaoBlocante(VL_Transmissao_ID, VL_DadosOUT, VL_DadosIN, 20000);

    if VL_Erro <> 0 then
    begin
        ShowMessage('erro ' + IntToStr(VL_Erro));
        MStatus.Lines.add('erro na solicitação');
        Exit;
    end;

    P_Retorno('', 0, 0, VL_DadosIN);

end;


procedure TF_Principal.BTestePinPadClick(Sender: TObject);
begin
    F_TestePinPad.Show;
end;

procedure TF_Principal.BInicializarClick(Sender: TObject);
var
    VL_Codigo: integer;
begin
    F_TefLib := LoadLibrary(PChar(ExtractFilePath(ParamStr(0)) + '..\tef_lib\win64\tef_lib.dll'));

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

    Pointer(F_TransacaoCancela) := GetProcAddress(F_TefLib, 'transacaocancela');
    Pointer(F_TransacaoCreate) := GetProcAddress(F_TefLib, 'transacaocreate');
    Pointer(F_TransacaoFree) := GetProcAddress(F_TefLib, 'transacaofree');
    Pointer(F_TransacaoStatus) := GetProcAddress(F_TefLib, 'transacaostatus');


    VL_Codigo := F_TefInicializar(StrToPinPadModelo(EPinPadModelo.Text), PChar(ExtractFilePath(ParamStr(0)) + EPinPadModeloLib.Text),Pchar(EPinPadModeloPorta.Text), PChar(ExtractFilePath(ParamStr(0)) + EPinPadLib.Text), PChar(F_ArquivoLog),
        @P_Retorno, @solicitadados, @imprime, @mostramenu, @mensagemoperador);

    if VL_Codigo <> 0 then
    begin
        ShowMessage('erro ' + IntToStr(VL_Codigo));
        exit;
    end;
    F_MensagemCreate(F_Mensagem);
    F_Transacao := TTransacao.Create;
end;

procedure TF_Principal.BVendaClick(Sender: TObject);
var
    VL_Erro: integer;
    VL_Status: integer;
    VL_TransacaoStatus: integer; //  numerador  (tsEfetivada,tsNegada,tsCancelada,tsProcessando,tsNaoLocalizada,tsInicializada);
    VL_TransacaoID: PChar;
    VL_Data: TDateTime;
begin
    VL_TransacaoID := '';
    VL_TransacaoStatus := Ord(tsInicializada);
    VL_Status := 0;

    VL_Erro := F_StatusOpenTef(VL_Status);

    if VL_Erro <> 0 then
    begin
        ShowMessage('erro ' + IntToStr(VL_Erro));
        Exit;
    end;

    if VL_Status <> Ord(csLogado) then
    begin
        MStatus.Lines.Add('faça o login');
        exit;
    end;


    MStatus.Clear;
    MStatus.Lines.add('Inicia transacao de venda');

    // SOLICITA APROVAÇÃO

    VL_Erro := F_TransacaoCreate(PChar(ENSU.Text), VL_TransacaoID, StrToInt(ETempo.Text));

    if VL_Erro <> 0 then
    begin
        ShowMessage('erro ' + IntToStr(VL_Erro));
        Exit;
    end;

    VL_Data := now;
    // aguarda 20 segundos
    while ((TimeStampToMSecs(DateTimeToTimeStamp(now)) - TimeStampToMSecs(DateTimeToTimeStamp(VL_Data))) < StrToInt(ETempo.Text)) do
    begin
        VL_Erro := F_TransacaoStatus(VL_TransacaoStatus, VL_TransacaoID);

        if VL_Erro <> 0 then
        begin
            ShowMessage('erro ' + IntToStr(VL_Erro));
            F_TransacaoFree(VL_TransacaoID);
            Exit;
        end;

        if Ord(tsCancelada) = VL_TransacaoStatus then
        begin
            ShowMessage('Transação cancelada ' + VL_TransacaoID);
            F_TransacaoFree(VL_TransacaoID);
            Exit;
        end;

        if Ord(tsNaoLocalizada) = VL_TransacaoStatus then
        begin
            ShowMessage('Transação não localizada ' + VL_TransacaoID);
            Exit;
        end;

        if Ord(tsNegada) = VL_TransacaoStatus then
        begin
            ShowMessage('Transação não aprovada ' + VL_TransacaoID);
            F_TransacaoFree(VL_TransacaoID);
            Exit;
        end;

        if Ord(tsEfetivada) = VL_TransacaoStatus then
        begin
            ShowMessage('Transação aprovada ' + VL_TransacaoID);
            F_TransacaoFree(VL_TransacaoID);
            Exit;
        end;

        if Ord(tsAbortada) = VL_TransacaoStatus then
        begin
            ShowMessage('Transação abortada ' + VL_TransacaoID);
            F_TransacaoFree(VL_TransacaoID);
            Exit;
        end;


        Application.ProcessMessages;
        sleep(30);
        case VL_TransacaoStatus of
            Ord(tsProcessando): MStatus.Lines.Add('Transacao ID:' + VL_TransacaoID + 'Estado de processamento');
            Ord(tsInicializada): MStatus.Lines.Add('Transacao ID:' + VL_TransacaoID + 'Estado de inicializada');
            Ord(tsAguardandoComando): MStatus.Lines.Add('Transacao ID:' + VL_TransacaoID + 'Estado de aguardando comsando');
        end;
    end;

    if ((TimeStampToMSecs(DateTimeToTimeStamp(now)) - TimeStampToMSecs(DateTimeToTimeStamp(VL_Data))) > 5000) then
    begin
        MStatus.Lines.Add('Transacao ID:' + VL_TransacaoID + 'Não foi respondida em tempo hábil');
        F_TransacaoFree(VL_TransacaoID);
    end;

end;

procedure TF_Principal.FormCreate(Sender: TObject);
begin
    F_ArquivoLog := ExtractFilePath(ParamStr(0)) + 'appopentef.log';
end;




end.
