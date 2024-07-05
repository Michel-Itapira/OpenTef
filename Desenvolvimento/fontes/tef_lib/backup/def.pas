unit def;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

const
    C_Versao: array  [0..2] of integer = (1, 0, 1);
    C_Programa : String ='tef_lib';
    C_Mensagem = 1;

    C_Debug = False;

    {$IFDEF WIN64}
            C_TEF_NOME : String ='TEF_LIB_WIN_64';
            C_TEF_EXTENSAO : String ='dll';
    {$ENDIF}

    {$IFDEF WIN32}
            C_TEF_NOME : String ='TEF_LIB_WIN_32';
            C_TEF_EXTENSAO : String ='dll';
    {$ENDIF}

    {$IFDEF LINUX32}
            C_TEF_NOME : String ='TEF_LIB_LINUX_32';
            C_TEF_EXTENSAO : String ='so';
    {$ENDIF}

    {$IFDEF LINUX64}
            C_TEF_NOME : String ='TEF_LIB_LINUX_64';
            C_TEF_EXTENSAO : String ='so';
    {$ENDIF}

    var
     F_NivelLog: integer = 1; // 0 = sem log  1 = erro 2 = log informativo  3 = comentario 4 = evento socket;

implementation

end.

