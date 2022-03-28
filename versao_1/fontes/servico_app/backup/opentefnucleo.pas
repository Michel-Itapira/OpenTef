unit opentefnucleo;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils,IniFiles,comunicador;

type
  TDNucleo = class(TDataModule)
  private

  public
  procedure iniciar;
  end;

var
  DNucleo: TDNucleo;
  Conf:TIniFile;

implementation

procedure TDNucleo.iniciar;
begin
     DComunicador:=TDComunicador.Create(Self);

     DComunicador.CriptoRsa.GenerateKeyPair;

     if not FileExists(ExtractFilePath(ParamStr(0))+'open_tef.ini') then
     begin
          Conf:=TIniFile.Create(pChar(ExtractFilePath(ParamStr(0))+'open_tef.ini'));
          Conf.WriteInteger('Servidor','CaixaPorta',0);
          Conf.WriteBool('Servidor','CaixaAtiva',True);
          Conf.WriteInteger('Servidor','LibPorta',0);
          Conf.WriteBool('Servidor','LibAtiva',False);
          Conf.Free;
     end;

     Conf:=TIniFile.Create(pChar(ExtractFilePath(ParamStr(0))+'open_tef.ini'));

     if Conf.ReadInteger('Servidor','CaixaPorta',0)<>0 then
     begin
          DComunicador.IdTCPServerCaixa.DefaultPort:=Conf.ReadInteger('Servidor','CaixaPorta',0);
       //   DComunicador.IdTCPServerCaixa.Active:= Conf.ReadBool('Servidor','CaixaAtiva',False);
     end;
     if Conf.ReadInteger('Servidor','LibPorta',0)<>0 then
     begin
          DComunicador.IdTCPServerLib.DefaultPort:=Conf.ReadInteger('Servidor','LibPorta',0);
          DComunicador.IdTCPServerLib.Active:=Conf.ReadBool('Servidor','LibAtiva',False);
     end;


end;

{$R *.lfm}

end.

