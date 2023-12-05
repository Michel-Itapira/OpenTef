unit bancodados;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils, ZConnection, ZDataset;

type

    { TDBancoDados }

    TDBancoDados = class(TDataModule)
        ZConexao: TZConnection;
        ConsultaA: TZQuery;
        ConsultaB: TZQuery;
        ConsultaC: TZQuery;
        ConsultaD: TZQuery;
        procedure DataModuleCreate(Sender: TObject);
        procedure DataModuleDestroy(Sender: TObject);
    private

    public

    end;

var
    DBancoDados: TDBancoDados;

implementation

uses opentefnucleo;

{$R *.lfm}

{ TDBancoDados }

procedure TDBancoDados.DataModuleCreate(Sender: TObject);
begin
    ZConexao.HostName := DNucleo.ZConexao.HostName;
    ZConexao.Database := DNucleo.ZConexao.Database;
    ZConexao.User := DNucleo.ZConexao.User;
    ZConexao.Port := DNucleo.ZConexao.Port;
    ZConexao.Password := DNucleo.ZConexao.Password;

    ZConexao.Connect;
end;

procedure TDBancoDados.DataModuleDestroy(Sender: TObject);
begin
    ConsultaA.Close;
    ConsultaB.Close;
    ConsultaC.Close;
    ConsultaD.Close;

    if ZConexao.Connected then
        if ZConexao.InTransaction then
            ZConexao.Commit;

    if ZConexao.Connected then
        ZConexao.Disconnect;
end;

end.
