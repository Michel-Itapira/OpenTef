library modulo_padrao;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
    CThreads,
  {$ENDIF}
  Interfaces,
  Classes,
  funcoes,
  modulo { you can add units after this };

exports
  inicializar,
  finalizar,
  login,
  solicitacao,
  solicitacaoblocante,
  modulostatus,
  alterarnivellog,
  mensagemdispose;

begin
end.
