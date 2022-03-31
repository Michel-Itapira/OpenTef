unit opentefnucleo;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils,IniFiles,comunicador, ZConnection, ZDataset;

type

  { TDNucleo }

  TMenuCompativel = function (VP_Menu:String;var VO_Compativel:Boolean):Integer; stdcall;
  TGetFuncao     = function (VP_TagFuncao:String; var VO_Implementada:Boolean):Integer; stdcall;

  TRegModulo = record
    Tag:String;
    Handle:THandle;
    Biblioteca:String;
    ModuloConfig_ID:Integer;
    MenuCompativel:TMenuCompativel;
    GetFuncoes:TGetFuncao;

  end;

  { TModulos }

  TModulos = class
  private
  fModulos: array of TRegModulo;
  public
  function AddModulo(ModuloConfig_ID:Integer):Integer;


  end;

  TDNucleo = class(TDataModule)
    ZConexao: TZConnection;
    ZConsulta: TZQuery;
    procedure DataModuleDestroy(Sender: TObject);
  private

  public
  procedure iniciar;
  end;



var
  DNucleo: TDNucleo;
  Conf:TIniFile;
  VMenuCompativel:TMenuCompativel;

implementation

{ TModulos }

function TModulos.AddModulo(ModuloConfig_ID: Integer): Integer;
begin
  //
end;

procedure TDNucleo.DataModuleDestroy(Sender: TObject);
begin
  //for DComunicador.IdTCPServerCaixa.Contexts.;
end;

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
          DComunicador.IdTCPServerCaixa.Active:= Conf.ReadBool('Servidor','CaixaAtiva',False);
     end;
     if Conf.ReadInteger('Servidor','LibPorta',0)<>0 then
     begin
          DComunicador.IdTCPServerLib.DefaultPort:=Conf.ReadInteger('Servidor','LibPorta',0);
          DComunicador.IdTCPServerLib.Active:=Conf.ReadBool('Servidor','LibAtiva',False);
     end;

     ZConexao.LibraryLocation:=pChar(ExtractFilePath(ParamStr(0))+'firebird\fbclient.dll');
     ZConexao.Database:=pChar(ExtractFilePath(ParamStr(0))+'opentef.fdb');
     ZConexao.Connect;


     {
     var
        VL_Codigo:Integer;
     begin

      TefLib:= LoadLibrary(pChar(ExtractFilePath(ParamStr(0))+'modulo\tef_lib.dll'));

      Pointer(TefInicializar) := GetProcAddress (TefLib, 'inicializar');
      Pointer(TLogin) := GetProcAddress (TefLib, 'login');
      Pointer(v_SolicitacaoBlocante):=GetProcAddress (TefLib, 'solicitacaoblocante');
      Pointer(VStatusOpenTef):=GetProcAddress(TefLib,'opentefstatus');

    }


end;

{$R *.lfm}

end.

