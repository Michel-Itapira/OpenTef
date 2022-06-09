unit servico;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DaemonApp,opentefnucleo;

type

  TThExecuta = class(TThread)
       private
       protected
         procedure Execute; override;
       public
   end;


  { TDServico }

  TDServico = class(TDaemon)
    procedure DataModuleShutDown(Sender: TCustomDaemon);
    procedure DataModuleStart(Sender: TCustomDaemon; var OK: Boolean);
    procedure DataModuleStop(Sender: TCustomDaemon; var OK: Boolean);

  private

  public

  end;

var
  DServico: TDServico;
  ThExecuta:TThExecuta;

implementation

procedure RegisterDaemon;
begin
  RegisterDaemonClass(TDServico)
end;

{$R *.lfm}

{ TDServico }


procedure TThExecuta.Execute;
begin

   DNucleo:=TDNucleo.Create(nil);
   DNucleo.iniciar;

   while not Terminated do
   sleep(10);

   DNucleo.Free;

end;

procedure TDServico.DataModuleShutDown(Sender: TCustomDaemon);
begin
   self.Stop;
end;

procedure TDServico.DataModuleStart(Sender: TCustomDaemon; var OK: Boolean);
begin
  ThExecuta:=TThExecuta.Create(True);
  ThExecuta.FreeOnTerminate := False;
  ThExecuta.Start;
  OK := True;
end;

procedure TDServico.DataModuleStop(Sender: TCustomDaemon; var OK: Boolean);
begin
  // stop and terminate the worker
  if assigned(ThExecuta) then
  begin
    ThExecuta.Terminate;
    // Wait for the thread to terminate.
    ThExecuta.WaitFor;
    FreeAndNil(ThExecuta);
  end;
  OK := True;
end;

{ TDServico }



initialization
  RegisterDaemon;
end.

