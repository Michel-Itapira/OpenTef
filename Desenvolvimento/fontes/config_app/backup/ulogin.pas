unit ulogin;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons;

type

    TPermissao = (pmC, pmA, pmU, pmS);

    { TFLogin }

    TFLogin = class(TForm)
        BConectar: TBitBtn;
        BConectar1: TBitBtn;
        CTipo: TComboBox;
        ESenha: TEdit;
        LSenha: TLabel;
        LTipo: TLabel;
        procedure BConectar1Click(Sender: TObject);
        procedure BConectarClick(Sender: TObject);
        procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    private

    public
        V_Conectar : Boolean;
        V_Tipo : string;
        constructor Create(AOwner: TComponent; VP_PermissaoFormatada: string);
            reintroduce; overload;

    end;

var
    FLogin: TFLogin;

implementation

{$R *.lfm}

{ TFLogin }

procedure TFLogin.BConectarClick(Sender: TObject);
begin
    case CTipo.ItemIndex of
        Ord(pmC):
        begin
            V_Tipo := 'C';
        end;
        Ord(pmA):
        begin
            V_Tipo := 'A';
        end;
        Ord(pmU):
        begin
            V_Tipo := 'U';
        end
        else
            V_Tipo := 'ndf';
    end;

    if V_Tipo = 'ndf' then
    begin
        ShowMessage('Define um tipo de configurador para logar');
        exit;
    end;
    if Length(ESenha.Text) = 0 then
    begin
        ShowMessage('Para Logar digite uma senha.');
        exit;
    end;
    V_Conectar:=true;
    close;
end;

procedure TFLogin.BConectar1Click(Sender: TObject);
begin
  V_Conectar:=false;
  close;
end;

procedure TFLogin.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

end;

constructor TFLogin.Create(AOwner: TComponent; VP_PermissaoFormatada: string);
begin
    inherited Create(AOwner);
    ESenha.Text := '';
    CTipo.Items.Text := VP_PermissaoFormatada;
end;

end.