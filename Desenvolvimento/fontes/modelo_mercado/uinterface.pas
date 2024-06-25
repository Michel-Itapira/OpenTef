unit uinterface;

{$mode objfpc}{$H+}

interface

uses
    Classes,
    SysUtils,
    base64,
    DB,
    Forms,
    Controls,
    Graphics,
    Dialogs,
    StdCtrls,
    DBGrids,
    Buttons,
    ExtCtrls,
    ComCtrls,
    rxmemds,
    RxDBGrid,
    StrUtils,
    LCLType;

type

    { TFInterface }

    TFInterface = class(TForm)
      BDinheiro: TBitBtn;
      BDinheiro1: TBitBtn;
      BOpentef: TBitBtn;
      GProdutos: TDBGrid;
      DProdutos: TDataSource;
      ECodigo: TEdit;
      EDescricao: TEdit;
      EQuantidade: TEdit;
      EValorTotal: TEdit;
      EValorTotalProduto: TEdit;
      EValorUnitario: TEdit;
      IFundo: TImage;
      LCodigo: TLabel;
      LDescricao: TLabel;
      LQuantidade: TLabel;
      LTitulo: TLabel;
      LValorTotal: TLabel;
      LValorTotal1: TLabel;
      LValorTotalProduto: TLabel;
      LValorUnitario: TLabel;
      MDProdutos: TRxMemoryData;
      MDProdutosDESCRICAO: TStringField;
      MDProdutosDESCRICAO1: TStringField;
      MDProdutosQUANTIDADE: TLongintField;
      MDProdutosQUANTIDADE1: TLongintField;
      MDProdutosVALOR_TOTAL: TCurrencyField;
      MDProdutosVALOR_TOTAL1: TCurrencyField;
      Panel1: TPanel;
      Panel2: TPanel;
      BAdicionar: TSpeedButton;
      Panel3: TPanel;
      SpeedButton1: TSpeedButton;
      UpQuantidade: TUpDown;
        procedure FormDestroy(Sender: TObject);
        procedure BOpentefClick(Sender: TObject);
        procedure ECodigoExit(Sender: TObject);
        procedure EQuantidadeChange(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure BAdicionarClick(Sender: TObject);
    private
        procedure CliqueDoBotao(VP_Botao: TObject);
    public

    end;

function Retorno(VP_DadosEntrada: PChar; var VO_DadosSaida: PChar): integer;
    cdecl;                         //quando o opentef envia alguma solicitação ao PDV
function solicitadadospdv(VP_Mensagem: PChar; var VO_Botao, VO_Dados: PChar): integer;
    cdecl;               //quando o opentef pede informação ao operador do caixa
function solicitadadostransacao(VP_Mensagem: PChar; var VO_Dados: PChar): integer;
    cdecl;                   //quando o opentef pede dados da venda para concluir a transação
function imprime(VP_Dados: PChar): integer; cdecl;
//quando o opentef solicita que seja impresso alguma coisa
function mostramenu(VP_Menu: PChar; var VO_Botao: PChar): integer;
    cdecl;                                   //quando o opentef quer que seja exibido o menu dinâmico
function mensagemoperador(VP_Dados: PChar): integer; cdecl;
//quando o opentef quer exibir alguma informação ao operador do caixa


function formataDinheiro(VP_Dados: string): string;

var
    FInterface: TFInterface;

implementation

uses
    uprodutos,
    uopentef,
    umenuvenda,
    uimpressao;

{$R *.lfm}

{ TFInterface }

function Retorno(VP_DadosEntrada: PChar; var VO_DadosSaida: PChar): integer; cdecl;
var
    VL_Dados: PChar;
    VL_Comando: PChar;
    VL_ComandoDados: PChar;
    VL_Mensagem: Pointer;
    VL_String: string;
    VL_Erro: integer;
    VL_DescricaoErro: PChar;
    VL_TransacaoID: PChar;
    VL_DescricaoErroTransacao: PChar;
    VL_TransacaoChave: PChar;
    VL_Bin: PChar;
    VL_Estilos: integer;
    VL_TransacaoStatus: integer; //  numerador  (tsEfetivada,tsNegada,tsCancelada,tsProcessando,tsNaoLocalizada,tsInicializada);
begin
    Result := 0;
    VL_Erro := 0;
    VL_String := '';
    VL_Mensagem := nil;
    F_MensagemCreate(VL_Mensagem);
    VL_Dados := '';
    VL_DescricaoErro := '';
    VL_Comando := '';
    VL_ComandoDados := '';
    VL_Comando := '';
    VL_TransacaoID := '';
    VL_DescricaoErroTransacao := '';
    VL_TransacaoChave := '';
    VL_Bin := '';
    VL_Estilos := MB_ICONQUESTION + MB_YESNO;

    VL_Erro := F_MensagemCarregaTags(VL_Mensagem, PChar(VP_DadosEntrada));
    if VL_Erro <> 0 then
    begin
        F_MensagemAddComando(VL_Mensagem, '0026', PChar(IntToStr(VL_Erro))); // retorno com erro
        F_MensagemTagAsString(VL_Mensagem, VL_Dados);
        VL_String := VL_Dados;

        VO_DadosSaida := StrAlloc(Length(VL_String) + 1);
        StrPCopy(VO_DadosSaida, VL_String);
        Exit;
    end;


    F_MensagemComando(VL_Mensagem, VL_Comando);
    F_MensagemComandoDados(VL_Mensagem, VL_ComandoDados);

    if VL_Comando = '00A4' then // status da transacao
    begin
        VL_TransacaoStatus := StrToInt(VL_ComandoDados);
        F_MensagemGetTag(VL_Mensagem, '0034', VL_TransacaoID);  // transacao id
        F_MensagemGetTag(VL_Mensagem, '00F1', VL_TransacaoChave); // chave da transacao

        if Ord(tsComErro) = VL_TransacaoStatus then
        begin
            VL_Erro := F_TransacaoStatusDescricao(VL_DescricaoErroTransacao, VL_TransacaoID);
            F_Erro(VL_Erro, VL_DescricaoErro);
            ShowMessage('Transação com erro ' + VL_TransacaoID + ' ' + VL_DescricaoErro);
            F_TransacaoFree(VL_TransacaoID);
            Exit;
        end;

        if Ord(tsCancelada) = VL_TransacaoStatus then
        begin
            VL_Erro := F_TransacaoStatusDescricao(VL_DescricaoErroTransacao, VL_TransacaoID);
            F_Erro(VL_Erro, VL_DescricaoErro);
            ShowMessage('Transação cancelada ' + VL_TransacaoID + ' ' + VL_DescricaoErro);
            F_TransacaoFree(VL_TransacaoID);
            Exit;
        end;

        if Ord(tsNegada) = VL_TransacaoStatus then
        begin
            VL_Erro := F_TransacaoStatusDescricao(VL_DescricaoErroTransacao, VL_TransacaoID);
            F_Erro(VL_Erro, VL_DescricaoErro);
            ShowMessage('Transação negada ' + VL_TransacaoID + ' ' + VL_DescricaoErro);
            F_TransacaoFree(VL_TransacaoID);
            Exit;
        end;


        if Ord(tsNaoLocalizada) = VL_TransacaoStatus then
        begin
            VL_Erro := F_TransacaoStatusDescricao(VL_DescricaoErroTransacao, VL_TransacaoID);
            F_Erro(VL_Erro, VL_DescricaoErro);
            ShowMessage('Transação não localizada ' + VL_TransacaoID + ' ' + VL_DescricaoErro);
            F_TransacaoFree(VL_TransacaoID);
            Exit;
        end;

        if Ord(tsEfetivada) = VL_TransacaoStatus then
        begin
            ShowMessage('Transação aprovada ' + VL_TransacaoID);
            F_TransacaoGetTag(VL_TransacaoID, '0036', VL_Bin);
            F_TransacaoFree(VL_TransacaoID);
            Exit;
        end;

        if Ord(tsAbortada) = VL_TransacaoStatus then
        begin
            VL_Erro := F_TransacaoStatusDescricao(VL_DescricaoErroTransacao, VL_TransacaoID);
            F_Erro(VL_Erro, VL_DescricaoErro);
            ShowMessage('Transação abortada ' + VL_TransacaoID + ' ' + VL_DescricaoErro);
            F_TransacaoFree(VL_TransacaoID);
            Exit;
        end;
    end
    else
    if VL_Comando = '010C' then // solicitacao de atualizacao do tef
    begin
        VL_Dados := '';
        F_MensagemGetTag(VL_Mensagem, '00FD', VL_Dados);  // atualizacao obrigatoria

        if VL_Dados = 'S' then
        begin
            F_MensagemAddComando(VL_Mensagem, '010C', PChar(ExtractFilePath(ParamStr(0)) + '..\..\tef_lib\win64\')); // comando de retorno com o caminho

            F_MensagemTagAsString(VL_Mensagem, VL_Dados);
            VL_String := VL_Dados;

            VO_DadosSaida := StrAlloc(Length(VL_String) + 1);
            StrPCopy(VO_DadosSaida, VL_String);
        end;

        VL_Dados := '';
        F_MensagemGetTag(VL_Mensagem, '010A', VL_Dados); // atualizacao opcional
        if VL_Dados = 'S' then
        begin

            if Application.MessageBox('Nova atualização do tef, deseja atualizar?', 'PDV', VL_Estilos) = idYes then
            begin
                F_MensagemAddComando(VL_Mensagem, '010C', PChar(ExtractFilePath(ParamStr(0)) + '..\..\tef_lib\win64\')); // comando de retorno com o caminho

                F_MensagemTagAsString(VL_Mensagem, VL_Dados);
                VL_String := VL_Dados;

                VO_DadosSaida := StrAlloc(Length(VL_String) + 1);
                StrPCopy(VO_DadosSaida, VL_String);
            end;

        end;

    end;
end;

function solicitadadospdv(VP_Mensagem: PChar; var VO_Botao, VO_Dados: PChar): integer; cdecl;
var
    VL_btn: TMButton;
    VL_I: integer;
    VL_Tag: PChar;
    VL_Dados: PChar;
    VL_String: string;
    VL_MenuVenda: TFMenuVenda;
    VL_Imagem: string;
    VL_Mensagem: Pointer;

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
    VL_Mensagem := nil;

    F_MensagemCreate(VL_Mensagem);

    F_MensagemCarregaTags(VL_Mensagem, VP_Mensagem);

    VL_MenuVenda := TFMenuVenda.Create(FInterface);

    VL_MenuVenda.Height := 120;

    F_MensagemGetTag(VL_Mensagem, '00DA', VL_Dados);   // verifica se veio mensagem a ser mostrada
    if VL_Dados <> '' then
    begin
        VL_MenuVenda.PMensagem.Visible := True;
        VL_MenuVenda.LMensagem.Caption := VL_Dados;
        VL_MenuVenda.Height := VL_MenuVenda.Height + 100;
    end;

    VL_Dados := '';
    VL_I := F_MensagemGetTag(VL_Mensagem, '0033', VL_Dados);  // VERIFICA SE É PARA CAPTURAR ALGUMA INFORMAÇÃO
    if VL_I = 0 then
    begin
        if VL_Dados = 'M' then                              // VERIFICA SE É PARA ESCONDER A DIGITAÇÃO "SENHA POR EXEMPLO"  "mascara a digitação"
            VL_MenuVenda.EDados.PasswordChar := '*';
        VL_MenuVenda.PDados.Visible := True;
        VL_MenuVenda.Height := VL_MenuVenda.Height + 80;
    end;

    VL_Dados := '';
    VL_I := F_MensagemGetTag(VL_Mensagem, '002E', VL_Dados);  // VERIFICA SE VEIO IMAGEM A SER MOSTRADA "QR CODE, FOTO..."
    if VL_I = 0 then
    begin
        VL_Imagem := VL_Dados;
        StrToImagem(VL_Imagem, VL_MenuVenda.Imagem);
        VL_MenuVenda.PImagem.Visible := True;
        VL_MenuVenda.Height := VL_MenuVenda.Height + 300;
    end;

    VL_Dados := '';
    F_MensagemGetTag(VL_Mensagem, '00DD', VL_Dados);    // CONTEM A LISTA DE BOTOES e CARREGA EM VL_Mensagem
    F_MensagemCarregaTags(VL_Mensagem, VL_Dados);

    VL_btn := TMButton.Create(VL_MenuVenda.PBotao);    // SEMPRE COLOCAR BOTAO DE CANCELAMENTO
    VL_btn.V_tag := '0030';
    VL_btn.Caption := 'Cancela';
    VL_btn.Align := alTop;
    VL_btn.Height := 20;
    VL_btn.BorderSpacing.Around := 20;
    VL_btn.Parent := VL_MenuVenda.PBotao;
    VL_btn.TabOrder := 0;
    VL_btn.OnClick := @FInterface.CliqueDoBotao;

    for VL_I := 1 to F_MensagemTagCount(VL_Mensagem) do
    begin
        F_MensagemGetTagIdx(VL_Mensagem, VL_i, VL_Tag, VL_Dados);
        if VL_Tag <> '0030' then                                     //PULA SE TIVER BOTAO DE CANCELAMENTO POIS JA FOI COLOCADO ACIMA
        begin
            VL_btn := TMButton.Create(VL_MenuVenda.PBotao);
            F_MensagemGetTagIdx(VL_Mensagem, VL_i, VL_Tag, VL_Dados);
            VL_btn.V_tag := VL_tag;
            VL_btn.Caption := VL_Dados;
            VL_btn.Align := alTop;
            VL_btn.Height := 20;
            VL_btn.BorderSpacing.Around := 20;
            VL_btn.Parent := VL_MenuVenda.PBotao;
            VL_btn.TabOrder := 0;
            VL_MenuVenda.Height := VL_MenuVenda.Height + 40;
            VL_btn.OnClick := @FInterface.CliqueDoBotao;
        end;
    end;
    VL_MenuVenda.Height := VL_MenuVenda.Height + 40;

    F_MensagemComandoDados(VL_Mensagem, VL_Dados);
    VL_MenuVenda.ShowModal;

    VO_Dados := StrAlloc(Length(VL_MenuVenda.EDados.Text) + 1);
    StrPCopy(VO_Dados, VL_MenuVenda.EDados.Text);

    VO_Botao := StrAlloc(Length(VL_MenuVenda.V_Botao) + 1);
    StrPCopy(VO_Botao, VL_MenuVenda.V_Botao);

    VL_MenuVenda.Free;

    F_MensagemFree(VL_Mensagem);

end;

procedure TFInterface.CliqueDoBotao(VP_Botao: TObject);
var
    VL_Botao: ansistring;
begin
    VL_Botao := TMButton(VP_Botao).v_tag;
    TFMenuVenda(TPanel(TMButton(VP_Botao).Parent).Parent).V_Botao := VL_Botao;
    TForm(TPanel(TMButton(VP_Botao).Parent).Parent).Close;
end;

function solicitadadostransacao(VP_Mensagem: PChar; var VO_Dados: PChar): integer; cdecl;
var
    VL_I: integer;
    VL_Tag: PChar;
    VL_Dados: PChar;
    VL_PChar: PChar;
    VL_Resposta: Pointer;
    VL_Mensagem: Pointer;
begin
    Result := 0;
    VL_Tag := '';
    VL_Dados := '';
    VL_PChar := '';
    VL_Resposta := nil;
    VL_Mensagem := nil;

    F_MensagemCreate(VL_Resposta);
    F_MensagemCreate(VL_Mensagem);
    F_MensagemAddComando(VL_Resposta, '00E1', 'R');
    F_MensagemCarregaTags(VL_Mensagem, VP_Mensagem);

    for vl_i := 1 to F_MensagemTagCount(VL_Mensagem) do                // A OPERADORA DE CARTÃO POR SOLICITAR OS DADOS PARA APROVAÇÃO
    begin                                                             // DEVE TESTAR TODOS OS POSSIVEIS DADOS SOLICITADOS PARA RESPONDER A OPERADORA
        F_MensagemGetTagIdx(VL_Mensagem, VL_I, VL_Tag, VL_Dados);
        // SE ALGUM DADO SOLICITADO NÃO FOR RESPONDIDO PODE HAVER A NEGAÇÃO DA TRANSAÇÃO PELA OPERADORA
        if VL_Tag = '0011' then                                                         // IDENTIFICAÇÃO DO CAIXA
            F_MensagemAddTag(VL_Resposta, '0011', PChar('CX10'));
        if VL_Tag = '0012' then                                                         // IDENTIFICAÇÃO DO OPERADOR DO CAIXA
            F_MensagemAddTag(VL_Resposta, '0012', PChar('NOME DO OPERADOR'));
        if VL_Tag = '0010' then                                                         // NUMERO DO CUPOM FISCAL
            F_MensagemAddTag(VL_Resposta, '0010', PChar('123'));
        if VL_Tag = '000E' then                                                         // VALOR DA PARCELA
            F_MensagemAddTag(VL_Resposta, '000E', PChar(FormataDinheiro(FInterface.EValorTotal.Text)));
        if VL_Tag = '0013' then                                                         // VALOR TOTAL
            F_MensagemAddTag(VL_Resposta, '0013', PChar(FormataDinheiro(FInterface.EValorTotal.Text)));
        if VL_Tag = '0014' then
            // VALOR TOTAL REFERENTE A PRODUTOS PERTECENTES AO PAT ALIMENTO IN NATURA
            F_MensagemAddTag(VL_Resposta, '0014', PChar('0'));
        if VL_Tag = '0015' then                                                         // VALOR TOTAL REFERENTE A PRODUTOS PERTECENTES AO PAT ALIMENTO PRONTO
            F_MensagemAddTag(VL_Resposta, '0015', PChar('0'));
        if VL_Tag = '0016' then                                                         // VALOR TOTAL REFERENTE A PRODUTOS PERTECENTES AO VALE CULTURA
            F_MensagemAddTag(VL_Resposta, '0016', PChar('0'));
        if VL_Tag = '000F' then                                                         // NUMERO DE PARCELAS
            F_MensagemAddTag(VL_Resposta, '000F', PChar('1'));
        if VL_Tag = '0017' then                                                          // XML DO CUPOM FISCAL NÃO PRECISA ASSINAR E A FORMATAÇÃO É LIVRE
            F_MensagemAddTag(VL_Resposta, '0017', PChar(''));
        if VL_Tag = '000B' then                                                          // NSU OU IDENTIFICADOR DA TRANSAÇÃO GERADO PELO PDV
            F_MensagemAddTag(VL_Resposta, '000B', PChar('123654'));
        if VL_Tag = '000C' then                                                          // DATA DA VENDA
            F_MensagemAddTag(VL_Resposta, '000C', PChar(DateToStr(now)));
        if VL_Tag = '000D' then                                                          // HORA DA VENDA
            F_MensagemAddTag(VL_Resposta, '000D', PChar(TimeToStr(now)));
        if VL_Tag = '00E5' then                                                          // LINK DA VALIDAÇÃO DA NOTA/CUPOM FISCAL
            F_MensagemAddTag(VL_Resposta, '00E5', PChar('ADICIONE O XML DA VENDA'));
        if VL_Tag = '00E6' then                                                          // VALOR DO DESCONTO
            F_MensagemAddTag(VL_Resposta, '00E6', PChar('0'));
        if VL_Tag = '0040' then                                                          // OBSERVAÇÃO SOBRE A VENDA
            F_MensagemAddTag(VL_Resposta, '0040', PChar('VENDA PELO OPENTEF'));
    end;

    F_MensagemTagAsString(VL_Resposta, VL_PChar);
    F_MensagemFree(VL_Resposta);

    VO_Dados := StrAlloc(Length(VL_PChar) + 1);
    StrPCopy(VO_Dados, VL_PChar);

    F_MensagemFree(VL_Mensagem);
end;

function imprime(VP_Dados: PChar): integer; cdecl;
var
    VL_Texto: string;
begin
    Result := 0;
    VL_Texto := VP_Dados;
    VL_Texto := ReplaceStr(VL_Texto, '<br>', #13); // quebra de linha

    Application.CreateForm(TFImpressao, FImpressao);

    FImpressao.MImpressao.Lines.Text := VL_Texto;
    FImpressao.ShowModal;
    FImpressao.Free;
end;

function mostramenu(VP_Menu: PChar; var VO_Botao: PChar): integer; cdecl;
var
    VL_btn: TMButton;
    VL_I: integer;
    VL_Tag: PChar;
    VL_Dados: PChar;
    VL_MenuVenda: TFMenuVenda;
    VL_Mensagem: Pointer;
begin
    Result := 0;
    VL_Tag := '';
    VL_Dados := '';
    VL_Mensagem := nil;

    F_MensagemCreate(VL_Mensagem);

    F_MensagemCarregaTags(VL_Mensagem, VP_Menu);
    VL_MenuVenda := TFMenuVenda.Create(FInterface);
    VL_MenuVenda.Height := 170;
    VL_btn := TMButton.Create(VL_MenuVenda.PBotao);
    VL_btn.V_tag := '0030';
    VL_btn.Caption := 'Cancela';
    VL_btn.Align := alTop;
    VL_btn.Height := 20;
    VL_btn.BorderSpacing.Around := 20;
    VL_btn.Parent := VL_MenuVenda.PBotao;
    VL_btn.TabOrder := 0;
    VL_btn.OnClick := @FInterface.CliqueDoBotao;

    for VL_I := 1 to F_MensagemTagCount(VL_Mensagem) do
    begin
        F_MensagemGetTagIdx(VL_Mensagem, VL_i, VL_Tag, VL_Dados);
        if VL_Tag <> '0030' then      //pula se tiver tag 0030 que é de cancelamento pois ja foi criada acima
        begin
            VL_btn := TMButton.Create(VL_MenuVenda.PBotao);
            F_MensagemGetTagIdx(VL_Mensagem, VL_i, VL_Tag, VL_Dados);
            VL_btn.V_tag := VL_tag;
            VL_btn.Caption := VL_Dados;
            VL_btn.Align := alTop;
            VL_btn.Height := 20;
            VL_btn.BorderSpacing.Around := 20;
            VL_btn.Parent := VL_MenuVenda.PBotao;
            VL_btn.TabOrder := 0;
            VL_MenuVenda.Height := VL_MenuVenda.Height + 40;
            VL_btn.OnClick := @FInterface.CliqueDoBotao;
        end;
    end;
    VL_MenuVenda.Height := VL_MenuVenda.Height + 40;
    F_MensagemComandoDados(VL_Mensagem, VL_Dados);
    VL_MenuVenda.ShowModal;

    VO_Botao := StrAlloc(Length(VL_MenuVenda.V_Botao) + 1);
    StrPCopy(VO_Botao, VL_MenuVenda.V_Botao);
    VL_MenuVenda.Free;

    F_MensagemFree(VL_Mensagem);
end;

function mensagemoperador(VP_Dados: PChar): integer; cdecl;
var
    VL_String: string;
begin
    Result := 0;
    VL_String := VP_Dados;
    VL_String := ReplaceStr(VL_String, '<br>', #13); // quebra de linha

    ShowMessage(VL_String);
end;


procedure TFInterface.FormCreate(Sender: TObject);
begin
    uopentef.incializar;
end;

procedure TFInterface.FormDestroy(Sender: TObject);
begin
   uopentef.finalizar;
end;


procedure TFInterface.FormShow(Sender: TObject);
begin
    uopentef.login;
end;

procedure TFInterface.BAdicionarClick(Sender: TObject);
var
    total: double;

begin
    MDProdutos.Insert;
    MDProdutos.FieldByName('DESCRICAO').AsString := EDescricao.Text;
    MDProdutos.FieldByName('QUANTIDADE').AsString := EQuantidade.Text;
    MDProdutos.FieldByName('VALOR_TOTAL').AsString := EValorTotalProduto.Text;
    MDProdutos.Post;

    total := 0;
    DProdutos.Enabled := False;
    MDProdutos.First;
    while not MDProdutos.EOF do
    begin
        total := total + MDProdutos.FieldByName('VALOR_TOTAL').AsFloat;
        MDProdutos.Next;
    end;

    EValorTotal.Text := CurrToStrF(total, ffCurrency, 2);
    DProdutos.Enabled := True;
end;



procedure TFInterface.BOpentefClick(Sender: TObject);
var
    VL_Erro: integer;
    VL_TransacaoID: PChar;
    VL_DescricaoErro: PChar;
begin
    VL_TransacaoID := '';
    VL_DescricaoErro := '';

    VL_Erro := F_TransacaoCreate(PChar('000A'), PChar(CAIXA), VL_TransacaoID, TEMPO_ESPERA);

    if VL_Erro <> 0 then
    begin
        F_Erro(VL_Erro, VL_DescricaoErro);
        ShowMessage('Erro: ' + IntToStr(VL_Erro) + #13 + 'Descrição:' + VL_DescricaoErro);
        Exit;
    end;
end;

procedure TFInterface.ECodigoExit(Sender: TObject);
var
    produto: TProduto;
begin
    produto := getProduto(StrToInt(ECodigo.Text));

    EDescricao.Text := produto.descricao;
    EValorUnitario.Text := FloatToStr(produto.valor);
    EQuantidade.Text := '1';
    EQuantidade.OnChange(self);
end;

procedure TFInterface.EQuantidadeChange(Sender: TObject);
begin
    EValorTotalProduto.Text := FloatToStr(StrToInt(EQuantidade.Text) * StrToFloat(EValorUnitario.Text));
end;

function formataDinheiro(VP_Dados: string): string;
begin
    Result := trim(VP_Dados);
    Result := StringReplace(Result, '.', '', [rfReplaceAll]);
    Result := StringReplace(Result, ',', '.', [rfReplaceAll]);
    Result := StringReplace(Result, 'R$', '', [rfReplaceAll]);
end;


end.
