Program opentef;

Uses
{$IFDEF UNIX}
  CThreads,
{$ENDIF}
 DaemonApp, lazdaemonapp, mapeador, servico, comunicador, opentefnucleo,
 Interfaces,
 Classes;

begin
  Application.Initialize;
  Application.Run;
end.
