unit ulogin;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,funcoes;

type


    { TFLogin }

    TFLogin = class(TForm)
        BConectar: TBitBtn;
        BDesconectar: TBitBtn;
        CTipo: TComboBox;
        ESenha: TEdit;
        LSenha: TLabel;
        LTipo: TLabel;
        procedure BDesconectarClick(Sender: TObject);
        procedure BConectarClick(Sender: TObject);
    private
      procedure VerificaConexao(VP_Status: integer);

    public
        V_Conectar : Boolean;
        V_Tipo : string;
        constructor Create(AOwner: TComponent; VP_PermissaoFormatada: string);
            reintroduce; overload;

    end;

var
    FLogin: TFLogin;

implementation

uses
    uinterface;

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

procedure TFLogin.BDesconectarClick(Sender: TObject);
begin
  V_Conectar:=false;
  close;
end;
procedure TFLogin.VerificaConexao(VP_Status:integer);
begin
    if VP_Status = Ord(csLogado) then
    begin
       BConectar.Enabled:=false;
       CTipo.Enabled:=false;
       Esenha.Text:='***';
       ESenha.Enabled:=false;
    end
    else
    begin
        BConectar.Enabled:=true;
        CTipo.Enabled:=true;
        Esenha.Text:='';
        ESenha.Enabled:=true;
    end;
end;


constructor TFLogin.Create(AOwner: TComponent; VP_PermissaoFormatada: string);
var
   VL_Status : integer;
begin
    inherited Create(AOwner);
    ESenha.Text := '';
    CTipo.Items.Text := VP_PermissaoFormatada;
    CTipo.ItemIndex:=1;
    F_OpenTefStatus(F_Com, VL_Status);
    VerificaConexao(VL_Status);

end;

end.
