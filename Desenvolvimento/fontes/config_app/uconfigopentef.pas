unit uconfigopentef;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, IniFiles,funcoes;

type

    { TFConfigOpenTef }

    TFConfigOpenTef = class(TForm)
        BGravar: TSpeedButton;
        PPrincipal: TPageControl;
        TabConfigurador: TTabSheet;
        TabConfiguradorBGeraChave: TSpeedButton;
        TabConfiguradorEChave: TMemo;
        TabConfiguradorEHost: TEdit;
        TabConfiguradorEPorta: TEdit;
        TabConfiguradorLChave: TLabel;
        TabConfiguradorLHost: TLabel;
        TabConfiguradorLPorta: TLabel;
        TabOpenTef: TTabSheet;
        TabOpenTefCPortaAtiva: TCheckBox;
        TabOpenTefEPorta: TEdit;
        TabOpenTefLPorta: TLabel;
        TabOpenTefLTitulo: TLabel;
        procedure BGravarClick(Sender: TObject);
        procedure TabConfiguradorBGeraChaveClick(Sender: TObject);
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
    if TabOpenTef.Showing then
    begin
        if TabOpenTefEPorta.Text = '' then
        begin
            ShowMessage('Campo Porta é obrigatório,não pode estar em branco!');
            Exit;
        end;
        VL_ArqConf := TIniFile.Create(PChar(ExtractFilePath(ParamStr(0)) + '..\..\opentef\win64\open_tef.ini'));
        VL_ArqConf.WriteInteger('Servidor', 'Porta', StrToInt(TabOpenTefEPorta.Text));
        if TabOpenTefCPortaAtiva.Checked then
            VL_ArqConf.WriteBool('Servidor', 'Ativa', True)
        else
            VL_ArqConf.WriteBool('Servidor', 'Ativa', False);
        VL_ArqConf.Free;
    end
    else
    if TabConfigurador.Showing then
    begin
        //testa campos
        if TabConfiguradorEChave.Lines.Text = '' then
        begin
            ShowMessage('Campo Chave é obrigatório, gere uma chave antes de criar o arquivo!');
            Exit;
        end;
        if TabConfiguradorEHost.Text = '' then
        begin
            ShowMessage('Campo Host é obrigatório,não pode estar em branco!');
            Exit;
        end;
        if TabConfiguradorEPorta.Text = '' then
        begin
            ShowMessage('Campo Porta é obrigatório,não pode estar em branco!');
            Exit;
        end;
        //grava arquivo
        VL_ArqConf := TIniFile.Create(PChar(ExtractFilePath(ParamStr(0)) + 'config_tef.ini'));
        VL_ArqConf.WriteInteger('Servidor', 'Porta', StrToInt(TabConfiguradorEPorta.Text));
        VL_ArqConf.WriteString('Servidor', 'Host', TabConfiguradorEHost.Text);
        VL_ArqConf.WriteString('Servidor', 'Chave', TabConfiguradorEChave.Lines.Text);
        VL_ArqConf.Free;
    end;
    ShowMessage('Configuração Alterada!');
    Close;

end;

procedure TFConfigOpenTef.TabConfiguradorBGeraChaveClick(Sender: TObject);
var
    VL_Chave : string;
begin
    VL_Chave:='';
    CriarChaveTerminal(tcConfigurador, '30', VL_Chave);
    if Length(VL_Chave) = 0 then
    begin
        ShowMessage('Erro ao gerar chave');
        exit;
    end;
    TabConfiguradorEChave.Text:=vl_chave;
end;

end.
