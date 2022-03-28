unit uprincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBGrids,
  funcoes, StrUtils, BufDataset, DB, DateTimePicker;

type
  { TFprincipal }

   TResposta = record
    Codigo:Integer;
    Dados:String;

  end;
   PResposta=^TResposta;

   TPResposta = procedure (VP_Codigo:integer;VP_Dados:ansistring);stdcall;


  TFprincipal = class(TForm)
    BInicializar: TButton;
    BLogin: TButton;
    BVenda: TButton;
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
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    EXml: TMemo;
    MStatus: TMemo;
    procedure BInicializarClick(Sender: TObject);
    procedure BLoginClick(Sender: TObject);
    procedure BVendaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

  TTefInicializar = function () : integer;  stdcall;
  TTLogin = function (VP_Host : AnsiString; VP_Porta : integer; VP_Chave : AnsiString;
                     VP_Versao_Comunicacao : integer) : integer;  stdcall;

  TTSolicitacao = function (VP_Dados : AnsiString; VP_Procedimento:TPResposta):Integer;  stdcall;
  TTSolicitacaoBlocante = function (VP_Dados : AnsiString; var VO_Retorno:AnsiString):Integer;  stdcall;

procedure P_Retorno(VP_Codigo:integer;VP_Dados:ansistring); stdcall;

var
  Fprincipal: TFprincipal;
  v_Solicitacao:TTSolicitacao;
  v_Resposta:PResposta;
  V_Procedure:TPResposta;
  V_Mensagem : TMensagem;
  TefLib:THandle;
  TefInicializar:TTefInicializar;
  TLogin:TTLogin;

const
  c_Versao_TefLib = '1.1.1';
  c_Versao_Mensagem = 1;



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
    end;
  end;
EHost.Text:='127.0.0.1';
EPorta.Text:='1000';
EChave.Text:='OK';
EDataHora.DateTime:=now;
end;


procedure P_Retorno(VP_Codigo:integer;VP_Dados:ansistring); stdcall;
var
   VL_S:AnsiString;

begin
  VL_S:=vp_Dados;
   Fprincipal.Caption:=VL_S;

  //V_Resposta^.Dados:=s^;
  //V_Resposta^.Codigo:=  LongInt(@V_Resposta);
  //Fprincipal.MStatus.Lines.Add('retornoI:'+PResposta(teste)^.Dados +IntToStr(V_Resposta^.Codigo)+V_Resposta^.Dados);


end;

procedure TFprincipal.BLoginClick(Sender: TObject);
var
   VL_Codigo:Integer;
   VL_P:pointer;
   VL_Erro : integer;
   VL_Tag : string;
begin
 MStatus.Clear;
 MStatus.Lines.add('Iniciando login...');

 VL_Codigo:=TLogin(EHost.Text,StrToInt(EPorta.text),EChave.Lines.Text,c_Versao_Mensagem);

 if VL_Codigo<>0 then
 begin
 MStatus.Lines.add('erro:'+IntToStr(VL_Codigo));
 exit;
 end;


 //monta TAG
 V_Mensagem.AddComando('0001','');
 V_Mensagem.AddTag('0002',EChave.Lines.Text);
 V_Mensagem.AddTag('0003',EHost.Text);
 V_Mensagem.AddTag('0004',EPorta.Text);
 V_Mensagem.AddTag('0005',c_Versao_TefLib);
 //VMensagem.AddTag('0006',vVersao_Mensagem);
 //VMensagem.AddTag('0007',vVersao_Mensagem);
 //VMensagem.AddTag('0008',vVersao_Mensagem);
 //VMensagem.AddTag('0009',vVersao_Mensagem);
 //
 VL_Erro:=V_Mensagem.TagToStr(VL_Tag);

 if VL_Erro <> 0 then
  begin
  ShowMessage('erro '+inttostr(VL_Erro));
  MStatus.Lines.add('erro na montagem do pacote');
  Exit;
 end;

 MStatus.Lines.add(VL_Tag);
 MStatus.Lines.add('pacote montado...');

 VL_Erro:=V_Mensagem.CarregaTags(VL_Tag);
 if VL_Erro <> 0 then
   begin
   ShowMessage('erro '+inttostr(VL_Erro));
   MStatus.Lines.add('erro ao carregar pacote');
   Exit;
  end;
 MStatus.Lines.add('pacote carregado...');


  {  libtef := LoadLibrary(pChar(Trim('tef_lib.dll')));

    Pointer(VSolicitacao) := GetProcAddress (Libtef, 'solicitacao');

    new(V_Resposta);

    VProcedure:= TPResposta(@p_retorno);

    codigo:= VSolicitacao('teste', VProcedure);
     }

 end;

procedure TFprincipal.BInicializarClick(Sender: TObject);
var
   VL_Codigo:Integer;
begin

 TefLib:= LoadLibrary(pChar(ExtractFilePath(ParamStr(0))+'..\lib\tef_lib.dll'));

 Pointer(TefInicializar) := GetProcAddress (TefLib, 'inicializar');
 Pointer(TLogin) := GetProcAddress (TefLib, 'login');

 VL_Codigo:=TefInicializar();

 if VL_Codigo<>0 then
 begin
   ShowMessage('erro '+inttostr(VL_Codigo));
   exit;
 end;

end;

procedure TFprincipal.BVendaClick(Sender: TObject);
var
   VL_Tag : String;
   VL_Erro : integer;
begin

 MStatus.Clear;
 MStatus.Lines.add('Inicia tag venda');
 //prepara a tag venda
 V_Mensagem.AddComando('000A','');
 V_Mensagem.AddTag('000B',ensu.Text);
 V_Mensagem.AddTag('000C',DateToStr(EDataHora.Date));
 V_Mensagem.AddTag('000D',Timetostr(EDataHora.Time));
 V_Mensagem.AddTag('000E',EValor.Text);
 V_Mensagem.AddTag('000F',EParcela.Text);
 V_Mensagem.AddTag('0010',ECupomFiscal.Text);
 V_Mensagem.AddTag('0011',ECaixa.Text);
 V_Mensagem.AddTag('0012',EOperador.Text);
 V_Mensagem.AddTag('0013',EValorItens.Text);
 V_Mensagem.AddTag('0014',EValorAlimentacao.Text);
 V_Mensagem.AddTag('0015',EValorRefeicao.text);
 V_Mensagem.AddTag('0016',EValorValeCultura.Text);
 V_Mensagem.AddTag('0017',EXml.lines.Text);

 VL_Erro:=V_Mensagem.TagToStr(VL_Tag);
 MStatus.Lines.Add(VL_Tag);
 if VL_Erro <> 0 then
 begin
  ShowMessage('erro '+inttostr(VL_Erro));
  MStatus.Lines.add('erro na montagem do pacote');
  Exit;
 end;
 MStatus.Lines.add(VL_Tag);
 MStatus.Lines.add('pacote montado...');

 VL_Erro:=V_Mensagem.CarregaTags(VL_Tag);

 if VL_Erro <> 0 then
 begin
  ShowMessage('erro '+inttostr(VL_Erro));
  MStatus.Lines.add('erro ao carregar pacote');
  Exit;
 end;
 MStatus.Lines.add('pacote carregado...');
 MStatus.Lines.add('encerra tag venda');

end;

procedure TFprincipal.FormCreate(Sender: TObject);
begin
 V_Mensagem:=TMensagem.Create;
end;

end.

