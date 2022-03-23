unit comunicador;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LbRSA, LbClass, IdTCPClient, IdComponent;

type


  { TDComunicador }

 TRecebe = procedure (dados:string);

 TThRecebe = class(TThread)
      private
       fdados : AnsiString;
       fprocedimento:TRecebe;
      protected
        procedure Execute; override;
      public
        constructor Create(Suspenso:Boolean;procedimento:TRecebe);
  end;

  TDComunicador = class(TDataModule)
    IdTCPSolicita: TIdTCPClient;
    IdTCPEscuta: TIdTCPClient;
    LbRijndael1: TLbRijndael;
    RsaEnviar: TLbRSA;
    RsaReceber: TLbRSA;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    fchave:String;
  public
    host:string;
    porta:integer;
    chave : AnsiString;
    versao_comunicacao : integer;
    function enviar(dados:AnsiString;var retorno:AnsiString):integer;
    procedure iniciaescuta(procedimento:TRecebe);
    function conectaescuta:integer;
  end;

var
  DComunicador: TDComunicador;
  ThRecebe:TThRecebe;
implementation

{$R *.lfm}

{ TDComunicador }

constructor TThRecebe.Create(Suspenso:Boolean; procedimento:TRecebe);
begin
  FreeOnTerminate := True;
  fprocedimento:=procedimento;
  inherited Create(Suspenso);
end;

procedure TThRecebe.Execute;
begin
 while not Terminated do
 begin
  sleep(100);
  if Assigned(fprocedimento) then
  if DComunicador.IdTCPEscuta.Connected then
  begin
   fprocedimento(DComunicador.IdTCPEscuta.Socket.ReadLn);
  end
  else
  begin
   sleep(5000);
   DComunicador.conectaescuta;
  end;
 end;
 if DComunicador.IdTCPEscuta.Connected then
 DComunicador.IdTCPEscuta.Disconnect;
end;

procedure TDComunicador.DataModuleCreate(Sender: TObject);
begin
  RsaEnviar.GenerateKeyPair;
  RsaReceber.GenerateKeyPair;
end;

procedure TDComunicador.DataModuleDestroy(Sender: TObject);
begin
  if IdTCPSolicita.Connected then
  IdTCPSolicita.Disconnect;
  if Assigned(ThRecebe) then
  ThRecebe.Terminate;

end;

function TDComunicador.enviar(dados:AnsiString;var retorno:AnsiString):integer;
begin
  Result:=0;
  try
  IdTCPSolicita.Connect(host,porta);
  IdTCPSolicita.Socket.WriteLn(dados);
  IdTCPSolicita.Socket.ReadLn(retorno);
  except
    Result:=24;
  end;
end;

procedure TDComunicador.iniciaescuta(procedimento:TRecebe);
begin
 ThRecebe:=TThRecebe.Create(True,procedimento);
 ThRecebe.Start;
end;

function TDComunicador.conectaescuta:integer;
begin
 Result:=0;
 try
  IdTCPEscuta.Connect(host,porta);
  except
   Result:=25;
  end;
end;


end.

