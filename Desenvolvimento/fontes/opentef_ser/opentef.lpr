Program opentef;

Uses
{$IFDEF UNIX}{$IFDEF UseCThreads}
  CThreads,
{$ENDIF}{$ENDIF}
   DaemonApp, lazdaemonapp, mapeador, servico, comunicador, opentefnucleo;

begin
  Application.Initialize;
  Application.Run;
end.
