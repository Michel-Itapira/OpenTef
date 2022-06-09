unit DaemonUnit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DaemonApp;

type
  TDaemon1 = class(TDaemon)
  private

  public

  end;

var
  Daemon1: TDaemon1;

implementation

procedure RegisterDaemon;
begin
  RegisterDaemonClass(TDaemon1)
end;

{$R *.lfm}


initialization
  RegisterDaemon;
end.

