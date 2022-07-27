unit uprincipal;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBGrids,
    ExtCtrls, DateTimePicker, StrUtils, def, uimpressao;

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
    TransacaoStatus = (tsEfetivada, tsNegada, tsCancelada, tsProcessando, tsAguardandoComando, tsNaoLocalizada, tsInicializada,
        tsComErro, tsAbortada, tsAguardandoDadosPDV);

    PResposta = ^TResposta;

    TRetorno = procedure(VP_Transmissao_ID: PChar; VP_ProcID, VP_Codigo: integer; VP_Dados: PChar); stdcall;
    TSolicitaDadosPDV = function(VP_Menu: PChar; var VO_Botao, VO_Dados: PChar): integer; stdcall;
    TSolicitaDadosTransacao = function(VP_Mensagem: PChar; var VO_Dados: PChar): integer; stdcall;
    TImprime = function(VP_Dados: PChar): integer; stdcall;
    TMostraMenu = function(VP_Menu: PChar; var VO_Botao: PChar): integer; stdcall;
    TMensagemOperador = function(VP_Dados: PChar): integer; stdcall;



    TF_Principal = class(TForm)
        BInicializar: TButton;
        BLogin: TButton;
        BVenda: TButton;
        cbxAmbienteTeste: TCheckBox;
        EObservacao: TEdit;
        EDesconto: TEdit;
        ELink: TEdit;
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
        EValorParcela: TEdit;
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
        Label24: TLabel;
        Label25: TLabel;
        Label26: TLabel;
        Label3: TLabel;
        Label4: TLabel;
        Label5: TLabel;
        Label6: TLabel;
        Label7: TLabel;
        Label8: TLabel;
        Label9: TLabel;
        EXml: TMemo;
        MStatus: TMemo;
        procedure BInicializarClick(Sender: TObject);
        procedure BLoginClick(Sender: TObject);
        procedure BVendaClick(Sender: TObject);
        procedure cbxAmbienteTesteChange(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure MontarMenu(VP_Mensagem: Pointer);
    private
        procedure CliqueDoBotao(VP_Botao: TObject);

    public

    end;

    TTefInicializar = function(VP_PinPadModelo: integer; VP_PinPadModeloLib, VP_PinPadModeloPorta, VP_PinPadLib, VP_ArquivoLog: PChar;
        VP_Procedimento: TRetorno; VP_SolicitaDadosTransacao: TSolicitaDadosTransacao; VP_SolicitaDadosPDV: TSolicitaDadosPDV;
        VP_Imprime: TImprime; VP_MostraMenu: TMostraMenu; VP_MensagemOperador: TMensagemOperador; VP_AmbienteTeste: Integer): integer; stdcall;
    TTLogin = function(VP_Host: PChar; VP_Porta: integer; VP_Chave: PChar; VP_Versao_Comunicacao: integer): integer; stdcall;

    TTSolicitacao = function(VP_Transmissao_ID, VP_Dados: PChar; VP_Procedimento: TRetorno; VP_TempoAguarda: integer): integer; stdcall;
    TTSolicitacaoBlocante = function(var VO_Transmissao_ID, VP_Dados: PChar; var VO_Retorno: PChar; VP_TempoAguarda: integer): integer; stdcall;
    TTOpenTefStatus = function(var VO_StatusRetorno: integer): integer; stdcall;
    TTMensagemCreate = function(var VO_Mensagem: Pointer): integer; stdcall;
    TTMensagemCarregaTags = function(VP_Mensagem: Pointer; VP_Dados: PChar): integer; stdcall;
    TTMensagemComando = function(VP_Mensagem: Pointer): PChar; stdcall;
    TTMensagemComandoDados = function(VP_Mensagem: Pointer): PChar; stdcall;
    TTMensagemFree = procedure(VP_Mensagem: Pointer); stdcall;
    TTMensagemAddtag = function(VP_Mensagem: Pointer; VP_Tag, VP_Dados: PChar): integer; stdcall;
    TTMensagemAddcomando = function(VP_Mensagem: Pointer; VP_Tag, VP_Dados: PChar): integer; stdcall;
    TTMensagemTagAsString = function(VP_Mensagem: Pointer): PChar; stdcall;
    TTMensagemTagCount = function(VO_Mensagem: Pointer): integer; stdcall;
    TTMensagemGetTag = function(VO_Mensagem: Pointer; VP_Tag: PChar; var VO_Dados: PChar): integer; stdcall;
    TTMensagemGetTagIdx = function(VO_Mensagem: Pointer; VL_Idx: integer; var VO_Tag: PChar; var VO_Dados: PChar): integer; stdcall;
    TTMensagemTagToStr = function(VO_Mensagem: Pointer; var VO_Dados: PChar): integer; stdcall;

    TTransacaocreate = function(VP_IdentificadorCaixa: PChar; var VO_TransacaID: PChar; VP_TempoAguarda: integer): integer; stdcall;
    TTransacaostatus = function(var VO_Status: integer; VP_TransacaoID: PChar): integer; stdcall;
    TTransacaostatusdescricao = function(var VO_Status: PChar; VP_TransacaoID: PChar): integer; stdcall;
    TTransacaocancela = function(var VO_Resposta: integer; VP_TransacaoID: PChar): integer; stdcall;
    TTransacaofree = procedure(VP_TransacaoID: PChar); stdcall;




procedure P_Retorno(VP_Transmissao_ID: PChar; VP_ProcID, VP_Codigo: integer; VP_Dados: PChar); stdcall;

function solicitadadospdv(VP_Mensagem: PChar; var VO_Botao, VO_Dados: PChar): integer; stdcall;
function solicitadadostransacao(VP_Mensagem: PChar; var VO_Dados: PChar): integer; stdcall;
function imprime(VP_Dados: PChar): integer; stdcall;
function mostramenu(VP_Menu: PChar; var VO_Botao: PChar): integer; stdcall;
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
    F_TransacaoStatusDescricao: TTransacaostatusdescricao;

    F_Mensagem: Pointer;
    F_Transacao: TTransacao;
    F_ArquivoLog: string;


function StrToPinPadModelo(VP_PinPadModelo: string): integer;




implementation

{$R *.lfm}

{ TF_Principal }

uses
    umenuvenda;

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
    end
    else
    if F_MensagemComando(VL_Mensagem) = '0018' then //Veio pedido de mostrar menu
    begin
        // monta o menu e aguarda a escolha pelo operador

        F_Principal.MontarMenu(VL_Mensagem);

    end
    else
        ShowMessage('Erro dados não esperados');

end;

function solicitadadospdv(VP_Mensagem: PChar; var VO_Botao, VO_Dados: PChar): integer; stdcall;
var
    VL_btn: TMButton;
    VL_I: integer;
    VL_Tag: PChar;
    VL_Dados: PChar;
    VL_MenuVenda: TF_MenuVenda;
    VL_Imagem: string;


    procedure StrToImagem(Dados: string; var Imagem: Timage);
    var
        JP: TJPEGImage;
        PNG: TPortableNetworkGraphic;
        BPM: TBitmap;
        Sm: TStringStream;
        i: integer;
        Tipo_Imagem, S, L: string;

    begin
        s := '';
        L := '';
        Tipo_Imagem := 'TI_JPG';
        if Dados = '' then
        begin
            Imagem.Picture.Graphic := nil;
            exit;
        end;

        for i := 0 to Length(Dados) div 2 - 1 do
        begin
            L := copy(Dados, ((1 + i) * 2) - 1, 2);
            s := s + char(Hex2Dec(L));
        end;


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
    F_MensagemCarregaTags(F_Mensagem, VP_Mensagem);


    VL_MenuVenda := TF_MenuVenda.Create(F_Principal);

    VL_MenuVenda.Height := 120;

    F_MensagemGetTag(F_Mensagem, '00DA', VL_Dados);   // verifica se veio mensagem a ser mostrada
    if VL_Dados <> '' then
    begin
        VL_MenuVenda.PMensagem.Visible := True;
        VL_MenuVenda.LMensagem.Caption := VL_Dados;
        VL_MenuVenda.Height := VL_MenuVenda.Height + 100;
    end;

    VL_Dados := '';
    VL_I := F_MensagemGetTag(F_Mensagem, '0033', VL_Dados);  // VERIFICA SE É PARA CAPTURAR ALGUMA INFOMRAÇÃO
    if VL_I = 0 then
    begin
        if VL_Dados = 'M' then                              // VERIFICA SE É PARA ESCONDER A DIGITAÇÃO "SENHA POR EXEMPLO"
            VL_MenuVenda.EDados.PasswordChar := '*';
        VL_MenuVenda.PDados.Visible := True;
        VL_MenuVenda.Height := VL_MenuVenda.Height + 80;
    end;

    VL_Dados := '';
    VL_I := F_MensagemGetTag(F_Mensagem, '002E', VL_Dados);  // VERIFICA SE VEIO IMAGEM A SER MOSTRADA "QR CODE, FOTO..."
    if VL_I = 0 then
    begin
        VL_Imagem := VL_Dados;
        StrToImagem(VL_Imagem, VL_MenuVenda.Imagem);
        VL_MenuVenda.PImagem.Visible := True;
        VL_MenuVenda.Height := VL_MenuVenda.Height + 300;
    end;



    F_MensagemGetTag(F_Mensagem, '00DD', VL_Dados);    // CONTEM A LISTA DE BOTOES
    F_MensagemCarregaTags(F_Mensagem, VL_Dados);

    VL_btn := TMButton.Create(VL_MenuVenda.PBotao);    // SEMPRE COLOCAR BOTAO DE CANCELAMENTO
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
        if VL_Tag <> '0030' then                                     //PULA SE TIVER BOTAO DE CANCELAMENTO POIS JA FOI COLOCADO ACIMA
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
    F_Principal.MStatus.Lines.Add('TransacaoID:' + F_MensagemComandoDados(F_Mensagem));
    VL_MenuVenda.ShowModal;

    VO_Dados := StrAlloc(Length(VL_MenuVenda.EDados.Text) + 1);
    StrPCopy(VO_Dados, VL_MenuVenda.EDados.Text);

    VO_Botao := StrAlloc(Length(VL_MenuVenda.V_Botao) + 1);
    StrPCopy(VO_Botao, VL_MenuVenda.V_Botao);
    VL_MenuVenda.Free;

end;

function solicitadadostransacao(VP_Mensagem: PChar; var VO_Dados: PChar): integer; stdcall;

var
    VL_I: integer;
    VL_Tag: PChar;
    VL_Dados: PChar;
    VL_String: string;
    VL_Resposta: Pointer;

begin

    Result := 0;
    VL_Tag := '';
    VL_Dados := '';
    VL_String := '';
    VL_Resposta := nil;
    F_MensagemCreate(VL_Resposta);
    F_MensagemAddComando(VL_Resposta, '00E1', 'R');
    F_MensagemCarregaTags(F_Mensagem, VP_Mensagem);

    for vl_i := 1 to F_MensagemTagCount(F_Mensagem) do                // A OPERADORA DE CARTÃO POR SOLICITAR OS DADOS PARA APROVAÇÃO
    begin                                                             // DEVE TESTAR TODOS OS POSSIVEIS DADOS SOLICITADOS PARA RESPONDER A OPERADORA
        F_MensagemGetTagIdx(F_Mensagem, VL_I, VL_Tag, VL_Dados);
        // SE ALGUM DADO SOLICITADO NÃO FOR RESPONDIDO PODE HAVER A NEGAÇÃO DA TRANSAÇÃO PELA OPERADORA
        if VL_Tag = '0011' then                                                         // IDENTIFICAÇÃO DO CAIXA
            F_MensagemAddTag(VL_Resposta, '0011', PChar(F_Principal.ECaixa.Text));
        if VL_Tag = '0012' then                                                         // IDENTIFICAÇÃO DO OPERADOR DO CAIXA
            F_MensagemAddTag(VL_Resposta, '0012', PChar(F_Principal.EOperador.Text));
        if VL_Tag = '0010' then                                                         // NUMERO DO CUPOM FISCAL
            F_MensagemAddTag(VL_Resposta, '0010', PChar(F_Principal.ECupomFiscal.Text));
        if VL_Tag = '000E' then                                                         // VALOR DA PARCELA
            F_MensagemAddTag(VL_Resposta, '000E', PChar(F_Principal.EValorParcela.Text));
        if VL_Tag = '000F' then                                                         // NUMERO DE PARCELAS
            F_MensagemAddTag(VL_Resposta, '000F', PChar(F_Principal.EParcela.Text));
        if VL_Tag = '0013' then                                                         // VALOR TOTAL
            F_MensagemAddTag(VL_Resposta, '0013', PChar(F_Principal.EValorItens.Text));
        if VL_Tag = '0014' then
            // VALOR TOTAL REFERENTE A PROTUDOS PERTECENTES AO PAT ALIMENTO IN NATURA
            F_MensagemAddTag(VL_Resposta, '0014', PChar(F_Principal.EValorAlimentacao.Text));
        if VL_Tag = '0015' then                                                          // VALOR TOTAL REFERENTE A PROTUDOS PERTECENTES AO PAT ALIMENTO PRONTO
            F_MensagemAddTag(VL_Resposta, '0015', PChar(F_Principal.EValorRefeicao.Text));
        if VL_Tag = '0016' then                                                          // VALOR TOTAL REFERENTE A PROTUDOS PERTECENTES AO VALE CULTURA
            F_MensagemAddTag(VL_Resposta, '0016', PChar(F_Principal.EValorValeCultura.Text));
        if VL_Tag = '0017' then                                                          // XML DO CUPOM FISCAL NÃO PRECISA ASSINAR E A FORMATAÇÃO É LIVRE
            F_MensagemAddTag(VL_Resposta, '0017', PChar(F_Principal.EXml.Lines.Text));
        if VL_Tag = '000B' then                                                          // NSU OU IDENTIFICADOR DA TRANSAÇÃO GERADO PELO PDV
            F_MensagemAddTag(VL_Resposta, '000B', PChar(F_Principal.ENSU.Text));
        if VL_Tag = '000C' then                                                          // DATA DA VENDA
            F_MensagemAddTag(VL_Resposta, '000C', PChar(DateToStr(F_Principal.EDataHora.Date)));
        if VL_Tag = '000D' then                                                          // HORA DA VENDA
            F_MensagemAddTag(VL_Resposta, '000D', PChar(TimeToStr(F_Principal.EDataHora.Time)));
        if VL_Tag = '00E5' then                                                          // LINK DA VALIDAÇÃO DA NOTA/CUPOM FISCAL
            F_MensagemAddTag(VL_Resposta, '00E5', PChar(F_Principal.ELink.Text));
        if VL_Tag = '00E6' then                                                          // VALOR DO DESCONTO
            F_MensagemAddTag(VL_Resposta, '00E6', PChar(F_Principal.EDesconto.Text));
        if VL_Tag = '0040' then                                                          // OBSERVAÇÃO SOBRE A VENDA
            F_MensagemAddTag(VL_Resposta, '0040', PChar(F_Principal.EObservacao.Text));

    end;
    VL_String := F_MensagemTagAsString(VL_Resposta);
    F_MensagemFree(VL_Resposta);

    VO_Dados := StrAlloc(Length(VL_String) + 1);
    StrPCopy(VO_Dados, VL_String);

end;

function imprime(VP_Dados: PChar): integer; stdcall;
var
    VL_Texto:String;
begin
    Result := 0;
    VL_Texto:=VP_Dados;
    VL_Texto:=ReplaceStr(VL_Texto,'<br>',#13);

    Application.CreateForm(TFImpressao, FImpressao);

    FImpressao.MImpressao.Lines.Text:=VL_Texto;
    FImpressao.ShowModal;
    FImpressao.Free;
end;

function mostramenu(VP_Menu: PChar; var VO_Botao: PChar): integer; stdcall;
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
        if VL_Tag <> '0030' then      //pula se tiver tag 0030 que é de cancelamento pois ja foi criana acima
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
    F_Principal.MStatus.Lines.Add('TransacaoID:' + F_MensagemComandoDados(F_Mensagem));
    VL_MenuVenda.ShowModal;

    VO_Botao := StrAlloc(Length(VL_MenuVenda.V_Botao) + 1);
    StrPCopy(VO_Botao, VL_MenuVenda.V_Botao);
    VL_MenuVenda.Free;

end;

function mensagemoperador(VP_Dados: PChar): integer; stdcall;
var
    VL_String:string;
begin
    Result := 0;
    VL_String:=VP_Dados;
    VL_String:=ReplaceStr(VL_String,'<br>',#13);
    ShowMessage(VL_String);
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



procedure TF_Principal.BInicializarClick(Sender: TObject);
var
    VL_Codigo: integer;
    VL_AmbienteTeste: Integer;
begin
     try
    if cbxAmbienteTeste.Checked then // ambiente de teste
    begin
      VL_AmbienteTeste:= 1;
    end
    else
    begin
      VL_AmbienteTeste:= 0;
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
        ShowMessage('erro ' + IntToStr(VL_Codigo));
        exit;
    end;
    F_MensagemCreate(F_Mensagem);
    F_Transacao := TTransacao.Create;

     Except
       ShowMessage('Erro ao carregar a Lib');
     end;
end;

procedure TF_Principal.BVendaClick(Sender: TObject);
var
    VL_Erro: integer;
    VL_Status: integer;
    VL_TransacaoStatus: integer; //  numerador  (tsEfetivada,tsNegada,tsCancelada,tsProcessando,tsNaoLocalizada,tsInicializada);
    VL_TransacaoID: PChar;
    VL_Data: TDateTime;
    VL_StatusDescricao: PChar;
begin
    VL_TransacaoID := '';
    VL_StatusDescricao:='';
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

    while ((TimeStampToMSecs(DateTimeToTimeStamp(now)) - TimeStampToMSecs(DateTimeToTimeStamp(VL_Data))) < StrToInt(ETempo.Text)) do
    begin
        VL_Erro := F_TransacaoStatus(VL_TransacaoStatus, VL_TransacaoID);

        if VL_Erro <> 0 then
        begin
            F_TransacaoStatusDescricao(VL_StatusDescricao, VL_TransacaoID);
            ShowMessage('erro ' + IntToStr(VL_Erro) + #13 + 'descrição:' + VL_StatusDescricao);
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
            Ord(tsAguardandoComando): MStatus.Lines.Add('Transacao ID:' + VL_TransacaoID + 'Estado de aguardando comando');
        end;
    end;

    if ((TimeStampToMSecs(DateTimeToTimeStamp(now)) - TimeStampToMSecs(DateTimeToTimeStamp(VL_Data))) > 5000) then
    begin
        MStatus.Lines.Add('Transacao ID:' + VL_TransacaoID + 'Não foi respondida em tempo hábil');
        F_TransacaoFree(VL_TransacaoID);
    end;

end;

procedure TF_Principal.cbxAmbienteTesteChange(Sender: TObject);
begin
 if cbxAmbienteTeste.Checked then
  ETefLib.Text:='tef_lib.dll';
end;

procedure TF_Principal.FormCreate(Sender: TObject);
begin
    F_ArquivoLog := ExtractFilePath(ParamStr(0)) + 'appopentef.log';
end;




end.
