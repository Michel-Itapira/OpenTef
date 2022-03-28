unit tef;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils,comunicador,funcoes;

  { TDTef }
  type
  TRetorno = procedure(VP_Codigo:integer;VP_Dados:string);  stdcall;

  ThProcesso = class(TThread)
      private
       fdados : AnsiString;
       fprocedimento:TRetorno;
      protected
        procedure Execute; override;
      public
       constructor Create(VP_Suspenso:Boolean;VP_Dados : AnsiString; VP_Procedimento:TRetorno);

  end;



  TDTef = class(TDataModule)
  private

  end;

function inicializar() : integer;  stdcall;
function finalizar() : integer;  stdcall;
function login(VP_Host : AnsiString; VP_Porta : integer; VP_Chave : AnsiString;
         VP_Versao_Comunicacao : integer) : integer;  stdcall;
function solicitacao(VP_Dados : AnsiString; VP_Procedimento:TRetorno) : Integer;  stdcall;
function solicitacaoblocante(VP_Dados : AnsiString; var VO_Retorno:AnsiString):Integer;  stdcall;

var
  DTef: TDTef;
  V_Inicializado:Boolean = False;

  Const
  C_lib_versao: array  [0..2] of integer = (1,0,0) ;

implementation

{$R *.lfm}
{ TDTef }


constructor ThProcesso.Create(VP_Suspenso:Boolean;VP_Dados : AnsiString; VP_Procedimento:TRetorno);

begin
  FreeOnTerminate := True;
  fdados:=VP_Dados;
  fprocedimento:=VP_Procedimento;
  inherited Create(VP_Suspenso);

end;

procedure ThProcesso.Execute;

begin
  sleep(5000);
  fprocedimento(1,'tok'+fdados);
end;

function inicializar() : integer; stdcall;
begin

 if not Assigned(DComunicador) then
 DComunicador:=TDComunicador.Create(nil);

 DComunicador.CriptoRsa.GenerateKeyPair;

 //ConexaoEscuta:=TTConexao.Create;
 ConexaoSolicita:=TTConexao.Create;


 Result:=0;

end;

function finalizar() : integer; stdcall;
begin
 DComunicador.Free;

 Result:=0;
end;

function login(VP_Host : AnsiString; VP_Porta : integer; VP_Chave : AnsiString;
         VP_Versao_Comunicacao : integer) : integer;  stdcall;
var
  VL_Mensagem:TMensagem;
  VL_S:String;
begin
 VL_Mensagem:=TMensagem.Create;
try
  //testa parametros
  if Length(VP_host)=0 then
  begin
     result :=9;
     exit;
  end;
  if VP_Porta < 1 then
  begin
     result :=11;
     exit;
  end;
  if VP_Versao_Comunicacao<1 then
  begin
     result := 13;
     exit;
  end;
  if length(VP_Chave)=0 then
  begin
     result :=15;
     exit;
  end;

  result:=DComunicador.Conectar(VP_Host,VP_Porta);

   exit;

  VL_Mensagem.AddComando('0001','');
  VL_Mensagem.AddTag('0002',VP_Chave);
  VL_Mensagem.AddTag('0005',IntToStr(C_lib_versao[0])+'.'+IntToStr(C_lib_versao[1])+'.'+IntToStr(C_lib_versao[2]));
  VL_Mensagem.AddTag('0006',IntToStr(C_lib_versao[0]));

  //DComunicador.IdTCPSolicita;



  result :=0;

finally
  VL_Mensagem.free;
end;

end;
function solicitacao(VP_Dados : AnsiString; VP_Procedimento:TRetorno):Integer;  stdcall;
var

  //v_d:^TResposta;
  //v_p:TRetorno;
  //i:PInteger;
  //i:integer;

 VL_Th:ThProcesso;
begin
  //v_d:=RetornoDados;

  //v_d^.codigo:=LongInt(@RetornoDados);
  //v_d^.Dados:='ok';

   //Result.Codigo:=1;
   //Result.Dados:='ok2';
  //v_p:=TRetorno(procedimento);

  //new(s);
  //s^:='joia';
  Result:=1;

  VL_Th:=ThProcesso.Create(True,VP_Dados,VP_Procedimento);
  VL_Th.Start;

end;

function solicitacaoblocante(VP_Dados : AnsiString; var VO_Retorno:AnsiString):Integer;  stdcall;
//var

  //v_d:^TResposta;
  //v_p:TRetorno;
  //i:PInteger;
  //i:integer;

// Th:ThProcesso;
begin
  //v_d:=RetornoDados;

  //v_d^.codigo:=LongInt(@RetornoDados);
  //v_d^.Dados:='ok';

   //Result.Codigo:=1;
   //Result.Dados:='ok2';
  //v_p:=TRetorno(procedimento);

  //new(s);
  //s^:='joia';
  Result:=1;

 // th:=ThProcesso.Create(True,dados,procedimento);
 // th.Start;

end;



end.

