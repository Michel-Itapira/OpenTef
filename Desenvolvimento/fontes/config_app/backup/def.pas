unit def;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

const
    C_Versao: array  [0..2] of integer = (1, 0, 0);
    C_Programa : String ='config_app';
    C_Mensagem = 1;
    C_ArquivoLog =  ExtractFilePath(ParamStr(0)) +'appopentef.log';


implementation

end.
