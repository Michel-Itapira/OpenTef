Program opentef;

Uses
{$IFDEF UNIX}
  CThreads,
{$ENDIF}

  Classes,
 DaemonApp, lazdaemonapp, mapeador, servico, comunicador, opentefnucleo;

begin
  Application.Initialize;
  Application.Run;
end.
