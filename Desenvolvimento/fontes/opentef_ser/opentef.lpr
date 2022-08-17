Program opentef;

Uses
{$IFDEF UNIX}
  CThreads,
{$ENDIF}
  Interfaces,
  Classes,
 DaemonApp, lazdaemonapp, mapeador, servico, comunicador, opentefnucleo;

begin
  Application.Initialize;
  Application.Run;
end.
