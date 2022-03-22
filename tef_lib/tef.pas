unit tef;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, IdTCPClient;

  { TDTef }
  type
  TRetorno = procedure(codigo:integer;dados:string);  stdcall;

  ThProcesso = class(TThread)
      private
       fdados : AnsiString;
       fprocedimento:TRetorno;
      protected
        procedure Execute; override;
      public
       constructor Create(Suspenso:Boolean;dados : AnsiString; procedimento:TRetorno);

  end;



  TDTef = class(TDataModule)
    IdTCPClient1: TIdTCPClient;
  private

  public

  end;

function login(host : AnsiString; porta : integer; chave : AnsiString; versao_comunicacao : integer) : integer;  stdcall;
function solicitacao(dados : AnsiString; procedimento:TRetorno) : Integer;  stdcall;

var
  DTef: TDTef;

implementation

{$R *.lfm}
{ TDTef }

constructor ThProcesso.Create(Suspenso:Boolean;dados : AnsiString; procedimento:TRetorno);

begin
  FreeOnTerminate := True;
  fdados:=dados;
  fprocedimento:=procedimento;
  inherited Create(Suspenso);

end;

procedure ThProcesso.Execute;

begin
  sleep(5000);
  fprocedimento(1,'tok'+fdados);
end;



function login(host : AnsiString; porta : integer; chave : AnsiString; versao_comunicacao : integer) : integer; stdcall;
begin
  //testa parametros do login
  if Length(host)=0 then
  begin
     result :=9;
     exit;
  end;
  if porta < 1 then
  begin
     result :=11;
     exit;
  end;
  if versao_comunicacao=0 then
  begin
     result := 13;
     exit;
  end;
  if length(chave)=0 then
  begin
     result :=15;
     exit;
  end;


  //valida parametros


  result :=0;

end;
function solicitacao(dados : AnsiString; procedimento:TRetorno):Integer;  stdcall;
var

  //v_d:^TResposta;
  //v_p:TRetorno;
  //i:PInteger;
  //i:integer;

 Th:ThProcesso;
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

  th:=ThProcesso.Create(True,dados,procedimento);
  th.Start;

end;



end.

