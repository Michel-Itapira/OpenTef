unit comunicador;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LbRSA;

type

  { TDComunicador }

  TDComunicador = class(TDataModule)
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

