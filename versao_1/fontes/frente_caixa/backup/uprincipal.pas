unit uprincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBGrids,
  funcoes, StrUtils, BufDataset, DB, DateTimePicker;

type
  { TFprincipal }
  tTipoComando = (tcLogin,tcVenda);

  tConteudo = array of string;

  TResposta = record
    Codigo:Integer;
    Dados:String;

  end;
   PResposta=^TResposta;

   TPResposta = procedure (codigo:integer;dados:ansistring);stdcall;


  TFprincipal = class(TForm)
    BLogin: TButton;
    BVenda: TButton;
    DBGrid1: TDBGrid;
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
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    MStatus: TMemo;
    procedure BLoginClick(Sender: TObject);
    procedure BVendaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

  TLogin = function (host : AnsiString; porta : integer; chave : AnsiString; versao_comunicacao : integer) : integer;  stdcall;
  TSolicitacao = function (dados : AnsiString; procedimento:TPResposta):Integer;  stdcall;

procedure p_retorno(codigo:integer;dados:ansistring); stdcall;
var
  Fprincipal: TFprincipal;
  VSolicitacao:TSolicitacao;
  V_Resposta:PResposta;
  VProcedure:TPResposta;
  VMensagem : TMensagem;
const
  vVersao_TefLib = '1.1.1';
  vVersao_Mensagem = '1.1.1';


implementation

{$R *.lfm}

{ TFprincipal }

procedure TFprincipal.FormShow(Sender: TObject);
var
   i : integer;
begin
  with self do
  begin
    for i := 0 to ComponentCount -1 do
    begin
       if Components[i] is TEdit then
          TEdit(Components[i]).Text := '';
       if Components[i] is TMemo then
          TMemo(Components[i]).Text:='';
    end;
  end;
EHost.Text:='127.0.0.1';
EPorta.Text:='1000';
EDataHora.DateTime:=now;
end;


procedure p_retorno(codigo:integer;dados:ansistring); stdcall;
var
   s:AnsiString;

begin
  s:=dados;
   Fprincipal.Caption:=s;

  //V_Resposta^.Dados:=s^;
  //V_Resposta^.Codigo:=  LongInt(@V_Resposta);
  //Fprincipal.MStatus.Lines.Add('retornoI:'+PResposta(teste)^.Dados +IntToStr(V_Resposta^.Codigo)+V_Resposta^.Dados);


end;

procedure TFprincipal.BLoginClick(Sender: TObject);
var
   LibTef : THandle;
   Login : TLogin;
   Codigo:Integer;
   p:pointer;
   vErro : integer;
   vTag : string;
begin
 //monta Tag login
 MStatus.Clear;
 MStatus.Lines.add('Iniciando login...');
 VMensagem.AddComando('0001','');
 VMensagem.AddTag('0002',EChave.Lines.Text);
 VMensagem.AddTag('0003',EHost.Text);
 VMensagem.AddTag('0004',EPorta.Text);
 VMensagem.AddTag('0005',vVersao_TefLib);
 VMensagem.AddTag('0006',vVersao_Mensagem);

 vErro:=VMensagem.TagToStr(vTag);

 if vErro <> 0 then
  begin
  ShowMessage('erro '+inttostr(vErro));
  MStatus.Lines.add('erro na montagem do pacote');
  Exit;
 end;
 MStatus.Lines.add(vTag);
 MStatus.Lines.add('pacote montado...');

 vErro:=VMensagem.CarregaTags(vTag);
 if vErro <> 0 then
   begin
   ShowMessage('erro '+inttostr(vErro));
   MStatus.Lines.add('erro ao carregar pacote');
   Exit;
  end;
 MStatus.Lines.add('pacote carregado...');

 VMensagem.Free;

 {
    libtef := LoadLibrary(pChar(Trim('tef_lib.dll')));

    Pointer(VSolicitacao) := GetProcAddress (Libtef, 'solicitacao');

    new(V_Resposta);

    VProcedure:= TPResposta(@p_retorno);

    codigo:= VSolicitacao('teste', VProcedure);

    }
 end;

procedure TFprincipal.BVendaClick(Sender: TObject);
var
   vParametro : tConteudo;
begin


 //prepara a tag venda
 SetLength(vParametro,12);
 vParametro[0] := ensu.Text;
 vParametro[1] := DateToStr(EDataHora.Date);
 vParametro[2] := TimeToStr(EDataHora.Time);
// vParametro[3] := Format('#.00',EValor.text);
end;

procedure TFprincipal.FormCreate(Sender: TObject);
begin
 VMensagem:=TMensagem.Create;
end;

end.

