library modulo_padrao;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
    CThreads,
  {$ENDIF}
  Interfaces, Classes, modulo
  { you can add units after this };
  exports
inicializar,
finalizar,
login,
solicitacao,
solicitacaoblocante,
modulostatus;

begin
end.

