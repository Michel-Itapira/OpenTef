unit uprincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  DateTimePicker;

type

  { TFprincipal }
  TResposta = record
    Codigo:Integer;
    Dados:String;
  end;
   PResposta=^TResposta;

   TPResposta = procedure (codigo:integer;dados:ansistring);stdcall;


  TFprincipal = class(TForm)
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
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
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
begin
    libtef := LoadLibrary(pChar(Trim('tef_lib.dll')));

    Pointer(Login) := GetProcAddress (Libtef, 'login');
    Pointer(VSolicitacao) := GetProcAddress (Libtef, 'solicitacao');


    Codigo:=Login('1',0,'1',1);

    new(V_Resposta);

    VProcedure:= TPResposta(@p_retorno);



    codigo:= VSolicitacao('teste', VProcedure);
    if Codigo=0 then


 //   MStatus.Lines.Add(inttostr(codigo));
end;

end.

