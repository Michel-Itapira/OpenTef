unit uprincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBGrids,
  ExtCtrls, funcoes, StrUtils, BufDataset, DB, DateTimePicker;

type
  { TF_Principal }

   TResposta = record
    Codigo:Integer;
    Dados:String;

  end;
   TConexaoStatus= (csDesconectado,csLink,csChaveado,csLogado);

   PResposta=^TResposta;

   TPResposta = procedure (VP_Codigo:integer;VP_Dados:ansistring);stdcall;


  TF_Principal = class(TForm)
    BInicializar: TButton;
    BLogin: TButton;
    BTestePinPad: TButton;
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
    Panel1: TPanel;
    procedure BInicializarClick(Sender: TObject);
    procedure BLoginClick(Sender: TObject);
    procedure BTestePinPadClick(Sender: TObject);
    procedure BVendaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

  TTefInicializar = function () : integer;  stdcall;
  TTLogin = function (VP_Host : AnsiString; VP_Porta : integer; VP_Chave : AnsiString;
                     VP_Versao_Comunicacao : integer) : integer;  stdcall;

  TTSolicitacao = function (VP_Dados : AnsiString; VP_Procedimento:TPResposta):Integer;  stdcall;
  TTSolicitacaoBlocante = function (VP_Dados : AnsiString; var VO_Retorno:AnsiString):Integer;  stdcall;
  TTOpenTefStatus =  function (var VO_StatusRetorno : integer): Integer; stdcall;

procedure P_Retorno(VP_Codigo:integer;VP_Dados:ansistring); stdcall;

var
  F_Principal: TF_Principal;
  v_SolicitacaoBlocante:TTSolicitacaoBlocante;
  v_Resposta:PResposta;
  V_Procedure:TPResposta;
  TefLib:THandle;
  TefInicializar:TTefInicializar;
  TLogin:TTLogin;
  VStatusOpenTef:TTOpenTefStatus;

const
  c_Versao_TefLib = '1.1.1';
  c_Versao_Mensagem = 1;

implementation

{$R *.lfm}

{ TF_Principal }

uses
  utestepinpad;


procedure TF_Principal.FormShow(Sender: TObject);
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
   F_Principal.Caption:=VL_S;

  //V_Resposta^.Dados:=s^;
  //V_Resposta^.Codigo:=  LongInt(@V_Resposta);
  //F_Principal.MStatus.Lines.Add('retornoI:'+PResposta(teste)^.Dados +IntToStr(V_Resposta^.Codigo)+V_Resposta^.Dados);


end;

procedure TF_Principal.BLoginClick(Sender: TObject);
var
   VL_Codigo:Integer;
 begin
 MStatus.Clear;
 MStatus.Lines.add('Iniciando login...');

// VL_Codigo:=TLogin(EHost.Text,StrToInt(EPorta.text),EChave.Lines.Text,c_Versao_Mensagem);

 if VL_Codigo<>0 then
 begin
 MStatus.Lines.add('erro:'+IntToStr(VL_Codigo));
 exit;
 end;
 MStatus.Lines.add('Logado');
 end;

procedure TF_Principal.BTestePinPadClick(Sender: TObject);
begin
   F_TestePinPad.Show;
end;

procedure TF_Principal.BInicializarClick(Sender: TObject);
var
   VL_Codigo:Integer;
begin

 TefLib:= LoadLibrary(pChar(ExtractFilePath(ParamStr(0))+'..\tef_lib\win64\tef_lib.dll'));

 Pointer(TefInicializar) := GetProcAddress (TefLib, 'inicializar');
 Pointer(TLogin) := GetProcAddress (TefLib, 'login');
 Pointer(v_SolicitacaoBlocante):=GetProcAddress (TefLib, 'solicitacaoblocante');
 Pointer(VStatusOpenTef):=GetProcAddress(TefLib,'opentefstatus');

 VL_Codigo:=TefInicializar();

 if VL_Codigo<>0 then
 begin
   ShowMessage('erro '+inttostr(VL_Codigo));
   exit;
 end;

end;

procedure TF_Principal.BVendaClick(Sender: TObject);
var
VL_Tag : String;
VL_Erro : integer;
VL_Status : Integer;
VL_Mensagem:TMensagem;
begin
 VL_Tag:='';
 VL_Mensagem:=TMensagem.Create;

 try
 VL_Erro:=VStatusOpenTef(VL_Status);

 if VL_Erro <> 0 then
 begin
  ShowMessage('erro '+inttostr(VL_Erro));
  Exit;
 end;

 if VL_Status<>ord(csLogado) then
 begin
   MStatus.Lines.Add('faça o login');
   exit;
 end;


 MStatus.Clear;
 MStatus.Lines.add('Inicia tag venda');
 //prepara a tag venda
 VL_Mensagem.AddComando('000A','');
 VL_Mensagem.AddTag('000B',ensu.Text);
 VL_Mensagem.AddTag('000C',DateToStr(EDataHora.Date));
 VL_Mensagem.AddTag('000D',Timetostr(EDataHora.Time));
 VL_Mensagem.AddTag('000E',EValor.Text);
 VL_Mensagem.AddTag('000F',EParcela.Text);
 VL_Mensagem.AddTag('0010',ECupomFiscal.Text);
 VL_Mensagem.AddTag('0011',ECaixa.Text);
 VL_Mensagem.AddTag('0012',EOperador.Text);
 VL_Mensagem.AddTag('0013',EValorItens.Text);
 VL_Mensagem.AddTag('0014',EValorAlimentacao.Text);
 VL_Mensagem.AddTag('0015',EValorRefeicao.text);
 VL_Mensagem.AddTag('0016',EValorValeCultura.Text);
 VL_Mensagem.AddTag('0017',EXml.lines.Text);

 // menus que o caixa aceita
 VL_Mensagem.AddTag('0019','');
 VL_Mensagem.AddTag('001A','');
 VL_Mensagem.AddTag('001B','');




 VL_Erro:=VL_Mensagem.TagToStr(VL_Tag);
 MStatus.Lines.Add(VL_Tag);
 if VL_Erro <> 0 then
 begin
  ShowMessage('erro '+inttostr(VL_Erro));
  MStatus.Lines.add('erro na montagem do pacote');
  Exit;
 end;

 VL_Erro:=v_SolicitacaoBlocante(VL_Tag,VL_Tag);

 if VL_Erro <> 0 then
 begin
  ShowMessage('erro '+inttostr(VL_Erro));
  MStatus.Lines.add('erro na montagem do pacote');
  Exit;
 end;

 VL_Mensagem.CarregaTags(VL_Tag);

 MStatus.Lines.add('Recebendo'+VL_Tag);


 finally
   VL_Mensagem.Free;
 end;

end;



end.

