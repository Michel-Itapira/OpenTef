unit uconfigopentef;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons, ExtCtrls, IniFiles;

type

    { TFConfigOpenTef }

    TFConfigOpenTef = class(TForm)
        BGravar: TSpeedButton;
        OpenTefCPortaAtiva: TCheckBox;
        OpenTefEPorta: TEdit;
        OpenTefLPorta: TLabel;
        procedure BGravarClick(Sender: TObject);
    private

    public

    end;

var
    FConfigOpenTef: TFConfigOpenTef;

implementation


{$R *.lfm}

{ TFConfigOpenTef }

procedure TFConfigOpenTef.BGravarClick(Sender: TObject);
var
    VL_ArqConf: TIniFile;
begin
    if OpenTefEPorta.Text = '' then
    begin
        ShowMessage('Campo Porta é obrigatório,não pode estar em branco!');
        Exit;
    end;
    VL_ArqConf := TIniFile.Create(PChar(ExtractFilePath(ParamStr(0)) + '..\..\opentef\win64\open_tef.ini'));
    VL_ArqConf.WriteInteger('Servidor', 'Porta', StrToInt(OpenTefEPorta.Text));
    if OpenTefCPortaAtiva.Checked then
        VL_ArqConf.WriteBool('Servidor', 'Ativa', True)
    else
        VL_ArqConf.WriteBool('Servidor', 'Ativa', False);
    VL_ArqConf.Free;

    ShowMessage('Configuração Alterada!');
    close;
end;

end.
