unit uinterface;

{$mode objfpc}{$H+}

interface

uses
    Classes,
    SysUtils,
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
    RxDBGrid;

type

    { TFInterface }

    TFInterface = class(TForm)
        BDinheiro: TBitBtn;
        BDinheiro1: TBitBtn;
        BOpentef: TBitBtn;
        DProdutos: TDataSource;
        ECodigo: TEdit;
        EDescricao: TEdit;
        EQuantidade: TEdit;
        EValorTotal: TEdit;
        EValorTotalProduto: TEdit;
        EValorUnitario: TEdit;
        ILogo: TImage;
        IFundo: TImage;
        LCodigo: TLabel;
        LDescricao: TLabel;
        LQuantidade: TLabel;
        LTitulo1: TLabel;
        LTitulo: TLabel;
        LValorTotal: TLabel;
        LValorTotal1: TLabel;
        LValorTotalProduto: TLabel;
        LValorUnitario: TLabel;
        MDProdutos: TRxMemoryData;
        GProdutos: TRxDBGrid;
        MDProdutosDESCRICAO: TStringField;
        MDProdutosQUANTIDADE: TLongintField;
        MDProdutosVALOR_TOTAL: TCurrencyField;
        Panel1: TPanel;
        Panel2: TPanel;
        SpeedButton1: TSpeedButton;
        UpQuantidade: TUpDown;
        procedure BDinheiroClick(Sender: TObject);
        procedure ECodigoExit(Sender: TObject);
        procedure EQuantidadeChange(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure MDProdutosAfterPost(DataSet: TDataSet);
        procedure SpeedButton1Click(Sender: TObject);
    private

    public

    end;

function Retorno(VP_DadosEntrada: PChar; var VO_DadosSaida: PChar): integer; cdecl;
function solicitadadospdv(VP_Mensagem: PChar; var VO_Botao, VO_Dados: PChar): integer; cdecl;
function solicitadadostransacao(VP_Mensagem: PChar; var VO_Dados: PChar): integer; cdecl;
function imprime(VP_Dados: PChar): integer; cdecl;
function mostramenu(VP_Menu: PChar; var VO_Botao: PChar): integer; cdecl;
function mensagemoperador(VP_Dados: PChar): integer; cdecl;

var
    FInterface: TFInterface;

implementation

uses uprodutos, uopentef;

{$R *.lfm}

{ TFInterface }

function Retorno(VP_DadosEntrada: PChar; var VO_DadosSaida: PChar): integer; cdecl;
begin
    Result := 0;
end;

function solicitadadospdv(VP_Mensagem: PChar; var VO_Botao, VO_Dados: PChar): integer; cdecl;
begin
    Result := 0;
end;

function solicitadadostransacao(VP_Mensagem: PChar; var VO_Dados: PChar): integer; cdecl;
begin
    Result := 0;
end;

function imprime(VP_Dados: PChar): integer; cdecl;
begin
    Result := 0;
end;

function mostramenu(VP_Menu: PChar; var VO_Botao: PChar): integer; cdecl;
begin
    Result := 0;
end;

function mensagemoperador(VP_Dados: PChar): integer; cdecl;
begin
    Result := 0;
end;

procedure TFInterface.FormCreate(Sender: TObject);
begin
    uopentef.incializar;
    uopentef.login;
end;

procedure TFInterface.MDProdutosAfterPost(DataSet: TDataSet);
var
    total: double;
begin
    total := 0;

    MDProdutos.First;
    while not MDProdutos.EOF do
    begin
        total := total + MDProdutos.FieldByName('VALOR_TOTAL').AsFloat;
        MDProdutos.Next;
    end;

    EValorTotal.Text := FloatToStr(total);
end;

procedure TFInterface.SpeedButton1Click(Sender: TObject);
begin
    MDProdutos.Insert;
    MDProdutos.FieldByName('DESCRICAO').AsString := EDescricao.Text;
    MDProdutos.FieldByName('QUANTIDADE').AsString := EQuantidade.Text;
    MDProdutos.FieldByName('VALOR_TOTAL').AsString := EValorTotalProduto.Text;
    MDProdutos.Post;
end;

procedure TFInterface.BDinheiroClick(Sender: TObject);
begin

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

end.
