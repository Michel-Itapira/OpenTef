unit comunicador;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LbRSA, LbClass;

type

  { TDComunicador }

  TDComunicador = class(TDataModule)
    LbRijndael1: TLbRijndael;
    RsaServidor: TLbRSA;
    RsaCliente: TLbRSA;
  private

  public

  end;

var
  DComunicador: TDComunicador;

implementation

{$R *.lfm}

end.

