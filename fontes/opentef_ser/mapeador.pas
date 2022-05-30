unit mapeador;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DaemonApp;

type
  TDMapeador = class(TDaemonMapper)
  private

  public

  end;

var
  DMapeador: TDMapeador;

implementation

procedure RegisterMapper;
begin
  RegisterDaemonMapper(TDMapeador)
end;

{$R *.lfm}


initialization
  RegisterMapper;
end.

