unit def;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils;

const
    C_Versao: array  [0..2] of integer = (1, 0, 0);
    C_Programa: string = 'mcom_lib';
    C_Mensagem = 1;

var
    C_Debug: boolean = True;
    F_NivelLog: integer = 1;


implementation

end.
