unit servico;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, DaemonApp, opentefnucleo, IniFiles,LazFileUtils;

type

    TThExecuta = class(TThread)
    private
    protected
        procedure Execute; override;
    public
    end;


    { TDServico }

    TDServico = class(TDaemon)
        procedure DataModuleAfterInstall(Sender: TCustomDaemon);
        procedure DataModuleBeforeUnInstall(Sender: TCustomDaemon);
        procedure DataModuleShutDown(Sender: TCustomDaemon);
        procedure DataModuleStart(Sender: TCustomDaemon; var OK: boolean);
        procedure DataModuleStop(Sender: TCustomDaemon; var OK: boolean);

    private

    public

    end;

  {$IFDEF UNIX}

  function GetSystemdControlFilePath(aDaemonName: string): string;
  function CreateSystemdControlFile(aDaemon: TCustomDaemon; aFilePath: string): boolean;
  function RemoveSystemdControlFile(aFilePath: string): boolean;
  procedure LogToFile(aMessage: string);

  const
    DAEMON_CONFIG_FILE_PATH = '/lib/systemd/system';

  {$ENDIF}


var
    DServico: TDServico;
    ThExecuta: TThExecuta;
    LogToFileCriticalSection: TRTLCriticalSection;


implementation

procedure RegisterDaemon;
begin
    RegisterDaemonClass(TDServico);
end;

{$R *.lfm}

{$IFDEF UNIX}

procedure LogToFile(aMessage: string);
// create a daily log file in the .exe directory

  function TimeStamped(S: string): string;
  // Return a timestamped copy of a string

  begin
    Result := FormatDateTime('hh:mm:ss', now) + ' ' + S;
  end;

var
  f: Text;
  LogFilePath: string;

begin
  LogFilePath := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) +
    FormatDateTime('YYYYMMDD', now) + '.log';
  AssignFile(f, LogFilePath);
  try
    if FileExists(LogFilePath) then
      Append(f)
    else
    begin
      Rewrite(f);
      writeln(f, TimeStamped('Log created'));
    end;
    Writeln(f, TimeStamped(aMessage));
  finally
    CloseFile(f);
  end;
end;


function GetSystemdControlFilePath(aDaemonName: string): string;

begin
  Result := IncludetrailingBackslash(DAEMON_CONFIG_FILE_PATH) + aDaemonName + '.service';
end;

function CreateSystemdControlFile(aDaemon: TCustomDaemon; aFilePath: string): boolean;

var
  f: TIniFile;

begin
  Result := False;
  try
    f := TIniFile.Create(aFilePath, []);
    // The mapper class used to create the daemon is accessible through the "Definition" property of the daemon object
    // We use it to populate a very basic .service file. Consult the systemd documentation for more options
    f.WriteString('Unit', 'Description', aDaemon.Definition.Description);
    f.WriteString('Unit', 'After', 'network.target');
    f.WriteString('Service', 'Type', 'simple');
    f.WriteString('Service', 'ExecStart', Application.ExeName + ' -r');
    f.WriteString('Install', 'WantedBy', 'multi-user.target');
    Result := True;
  finally
    f.Free;
  end;
end;

function RemoveSystemdControlFile(aFilePath: string): boolean;

  // Remove the control file, if it does exist

begin
  Result := True;
  if FileExists(aFilePath) then
    Result := DeleteFile(aFilePath);
end;

{$ENDIF}

{ TDServico }


procedure TThExecuta.Execute;
begin

    DNucleo := TDNucleo.Create(nil);
    DNucleo.iniciar;

    while not Terminated do
        sleep(10);

    DNucleo.Free;

end;

procedure TDServico.DataModuleAfterInstall(Sender: TCustomDaemon);
  {$IFDEF UNIX}
  var
   isInstalled: boolean = True;
   FilePath: string;
    {$ENDIF}


 begin
   {$IFDEF UNIX}
   LogToFile('Daemon installing');

   FilePath := GetSystemdControlFilePath(Self.Definition.Name);
   isInstalled := CreateSystemdControlFile(self, FilePath);
   LogToFile('File:'+FilePath);
   if not isInstalled then
     LogToFile('Error creating systemd control file: ' + FilePath);

   if isInstalled then
     LogToFile('Daemon installed');
   {$ENDIF}

end;

procedure TDServico.DataModuleBeforeUnInstall(Sender: TCustomDaemon);
  {$IFDEF UNIX}
  var
  FilePath: string;
  {$ENDIF}
begin
  {$IFDEF UNIX}
  FilePath := GetSystemdControlFilePath(Self.Definition.Name);
  RemoveSystemdControlFile(FilePath);
  {$ENDIF}
end;


procedure TDServico.DataModuleShutDown(Sender: TCustomDaemon);
begin
    self.Stop;
end;

procedure TDServico.DataModuleStart(Sender: TCustomDaemon; var OK: boolean);
begin
    ThExecuta := TThExecuta.Create(True);
    ThExecuta.FreeOnTerminate := False;
    ThExecuta.Start;
    OK := True;
end;

procedure TDServico.DataModuleStop(Sender: TCustomDaemon; var OK: boolean);
begin
    // stop and terminate the worker
    if assigned(ThExecuta) then
    begin
        ThExecuta.Terminate;
        // Wait for the thread to terminate.
        ThExecuta.WaitFor;
        ThExecuta.Free;
        ThExecuta := nil;
    end;
    OK := True;
end;

{ TDServico }



initialization
    RegisterDaemon;
    InitCriticalSection(LogToFileCriticalSection);

finalization
  DoneCriticalSection(LogToFileCriticalSection);


end.
