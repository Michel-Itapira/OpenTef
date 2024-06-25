library modulo_padrao;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}
    CThreads,
   {$ENDIF}
    Interfaces,
    Classes,
    modulo, unit1 { you can add units after this };

exports
    inicializar,
    finalizar,
    login,
    solicitacao,
    solicitacaoblocante,
    modulostatus,
    alterarnivellog;

begin
end.
