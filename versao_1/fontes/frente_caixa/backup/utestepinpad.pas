unit utestepinpad;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, funcoes;
type

    { TFTestePinPad }
    TRespostaPinPad = procedure(VP_Mensagem: TMensagem);
    TCarregaPinPad = function(VP_PinPad: TPinPadModelo; VP_CaminhoLib: ansistring; VP_Porta: ansistring;
        var VO_RespostaPinPad: TRespostaPinPad): boolean; stdcall;
    TPinPadConectar = function(): integer; stdcall;
    TPinPadDesconectar = function(): integer; stdcall;
    TPinPadComando = function(VP_Mensagem: ansistring; var VO_RespostaPinPad: TRespostaPinPad): integer; stdcall;

    TDescriptaSenha3Des = function(VP_Wk, VP_pan, VP_Senha: ansistring): ansistring; stdcall;
    TEncriptaSenha3Des = function(VP_Wk, VP_pan, VP_Senha: ansistring): ansistring; stdcall;
    Twkc=function (): ansistring; stdcall;
    Timk=function (): integer; stdcall;



    TFTestePinPad = class(TForm)
        BCarregaPinPad: TButton;
        BConectar: TButton;
        BDesconectar: TButton;
        BMostrar: TButton;
        BTarja: TButton;
        BSenha: TButton;
        EPan: TEdit;
        EMostrar: TEdit;
        EPorta: TEdit;
        Label1: TLabel;
        Memo1: TMemo;
        procedure BCarregaPinPadClick(Sender: TObject);
        procedure BConectarClick(Sender: TObject);
        procedure BDesconectarClick(Sender: TObject);
        procedure BMostrarClick(Sender: TObject);
        procedure BSenhaClick(Sender: TObject);
        procedure BTarjaClick(Sender: TObject);
    private

    public

    end;

procedure Resposta(VP_Mensagem: TMensagem);

var
    F_TestePinPad: TFTestePinPad;
    F_PinPad: THandle;
    F_Key: THandle;
    F_CarregaPinPad: TCarregaPinPad;
    F_PinPadConectar: TPinPadConectar;
    F_PinPadDesconectar: TPinPadDesconectar;
    F_RespostaPinPad: TRespostaPinPad;
    F_PinPadComando: TPinPadComando;
    F_DescriptaSenha3Des:TDescriptaSenha3Des;
    F_EncriptaSenha3Des:TEncriptaSenha3Des;
    F_Wk:Twkc;
    F_Imk:Timk;


implementation

{$R *.lfm}

{ TFTestePinPad }

procedure TFTestePinPad.BCarregaPinPadClick(Sender: TObject);
var
    VL_Caminho: ansistring;
begin

    VL_Caminho := PChar(ExtractFilePath(ParamStr(0)) + '..\pinpad_lib\win64\');
    F_PinPad := LoadLibrary(VL_Caminho + 'pinpad_lib.dll');
    if F_PinPad = 0 then
        exit;
    Pointer(F_CarregaPinPad) := GetProcAddress(F_PinPad, 'CarregaPinPad');
    Pointer(F_PinPadConectar) := GetProcAddress(F_PinPad, 'PinPadConectar');
    Pointer(F_PinPadDesconectar) := GetProcAddress(F_PinPad, 'PinPadDesconectar');
    Pointer(F_PinPadComando) := GetProcAddress(F_PinPad, 'PinPadComando');
    F_RespostaPinPad := @Resposta;
    F_CarregaPinPad(pGERTEC_PPC930, VL_Caminho, EPorta.Text, F_RespostaPinPad);

    VL_Caminho := PChar(ExtractFilePath(ParamStr(0)) + '..\key_lib\win64\');

    F_Key := LoadLibrary(VL_Caminho + 'key_lib.dll');

    Pointer(F_DescriptaSenha3Des) := GetProcAddress(F_Key, 'DescriptaSenha3Des');
    Pointer(F_EncriptaSenha3Des) := GetProcAddress(F_Key, 'EncriptaSenha3Des');
    Pointer(F_Wk) := GetProcAddress(F_Key, 'wkc');
    Pointer(F_Imk) := GetProcAddress(F_Key, 'imk');


end;

procedure TFTestePinPad.BConectarClick(Sender: TObject);
begin
    F_PinPadConectar;
end;

procedure TFTestePinPad.BDesconectarClick(Sender: TObject);
begin
    F_PinPadDesconectar;
end;

procedure TFTestePinPad.BMostrarClick(Sender: TObject);
var
    VL_Mensagem: TMensagem;
    VL_String: string;
begin
    VL_String := '';
    VL_Mensagem := TMensagem.Create;
    VL_Mensagem.AddComando('0047', EMostrar.Text);
    VL_Mensagem.TagToStr(VL_String);
    F_PinPadComando(VL_String, F_RespostaPinPad);
end;

procedure TFTestePinPad.BSenhaClick(Sender: TObject);
var
    VL_Mensagem: TMensagem;
    VL_String: string;
begin
    VL_String := '';
    VL_Mensagem := TMensagem.Create;
    VL_Mensagem.AddComando('005A', '0');
    VL_Mensagem.AddTag('005B', IntToStr(F_Imk()));
    VL_Mensagem.AddTag('005C', ' DIGITE A SENHA');
    VL_Mensagem.AddTag('005D', '4');
    VL_Mensagem.AddTag('005E', '8');
    VL_Mensagem.AddTag('005F', F_Wk());
    VL_Mensagem.AddTag('0062', EPan.Text);
    VL_Mensagem.TagToStr(VL_String);
    F_PinPadComando(VL_String, F_RespostaPinPad);

end;

procedure TFTestePinPad.BTarjaClick(Sender: TObject);
var
    VL_Mensagem: TMensagem;
    VL_String: string;
begin
    VL_String := '';
    VL_Mensagem := TMensagem.Create;
    VL_Mensagem.AddComando('0048', '0');
    VL_Mensagem.AddTag('0051', '10');
    VL_Mensagem.TagToStr(VL_String);
    F_PinPadComando(VL_String, F_RespostaPinPad);

end;

procedure Resposta(VP_Mensagem: TMensagem);
var
    VL_Comando, VL_Dados: string;
begin
    VP_Mensagem.GetComando(VL_Comando, VL_Dados);
    if VL_Comando = '004D' then
        F_TestePinPad.Memo1.Lines.Add('Erro comando:' + VL_Dados);
    if VL_Comando = '0049' then
        F_TestePinPad.Memo1.Lines.Add('Erro no pinpad:' + VL_Dados);


    if VL_Comando = '0052' then
        if VL_Dados = '0048' then
        begin
            F_TestePinPad.Memo1.Lines.Add('Retorno de leitura de tarja:');
            F_TestePinPad.Memo1.Lines.Add('Track 1:' + VP_Mensagem.GetTagAsAstring('004E'));
            F_TestePinPad.Memo1.Lines.Add('Track 2:' + VP_Mensagem.GetTagAsAstring('004F'));
            F_TestePinPad.Memo1.Lines.Add('Track 3:' + VP_Mensagem.GetTagAsAstring('0050'));
        end;
    if VL_Dados = '005A' then
        begin
            F_TestePinPad.Memo1.Lines.Add('Retorno de leitura de SENHA');
            F_TestePinPad.Memo1.Lines.Add('SENHA CRIPTOGRAFADA:' + VP_Mensagem.GetTagAsAstring('0060'));
            F_TestePinPad.Memo1.Lines.Add('SENHA' +F_DescriptaSenha3Des('', VP_Mensagem.GetTagAsAstring('0062'),VP_Mensagem.GetTagAsAstring('0060')));
        end;


end;

end.
