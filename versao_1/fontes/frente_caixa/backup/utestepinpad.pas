unit utestepinpad;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,Funcoes;
type

    { TFTestePinPad }
    TRespostaPinPad = procedure(VP_Processo_ID:Integer; VP_Mensagem: TMensagem);
    TPinPadCarrega = function(VP_PinPadModelo: TPinPadModelo; VP_PinPadModeloLib, VP_PinPadModeloPorta: PChar; VP_RespostaPinPad: TRespostaPinPad): integer; stdcall;
    TPinPadConectar = function(var VO_Mensagem: PChar): integer; stdcall;
    TPinPadDesconectar = function(): integer; stdcall;
    TPinPadComando = function(VP_Processo_ID: integer; VP_Mensagem: PChar; var VO_Mensagem: PChar; VP_RespostaPinPad: TRespostaPinPad): integer; stdcall;

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

procedure Resposta(VP_Processo_ID:Integer;VP_Mensagem: TMensagem);

var
    F_TestePinPad: TFTestePinPad;
    F_PinPad: THandle;
    F_PPinPad:Pointer;
    F_Key: THandle;
    F_PinPadCarrega: TPinPadCarrega;
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


procedure Resposta(VP_Processo_ID:Integer;VP_Mensagem: TMensagem);
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


procedure TFTestePinPad.BCarregaPinPadClick(Sender: TObject);
var
    VL_Caminho: ansistring;
begin

    VL_Caminho := PChar(ExtractFilePath(ParamStr(0)) + '..\pinpad_lib\win64\');
    F_PinPad := LoadLibrary(VL_Caminho + 'pinpad_lib.dll');
    if F_PinPad = 0 then
        exit;
    Pointer(F_PinPadCarrega) := GetProcAddress(F_PinPad, 'pinpadcarrega');
    Pointer(F_PinPadConectar) := GetProcAddress(F_PinPad, 'pinpadconectar');
    Pointer(F_PinPadDesconectar) := GetProcAddress(F_PinPad, 'pinpaddesconectar');
    Pointer(F_PinPadComando) := GetProcAddress(F_PinPad, 'pinpadcomando');
//    F_RespostaPinPad := @Resposta;
    F_PinPadCarrega(pGERTEC_PPC930,Pchar(VL_Caminho),Pchar(EPorta.Text), @Resposta);

    VL_Caminho := PChar(ExtractFilePath(ParamStr(0)) + '..\key_lib\win64\');

    F_Key := LoadLibrary(VL_Caminho + 'key_lib.dll');

    Pointer(F_DescriptaSenha3Des) := GetProcAddress(F_Key, 'DescriptaSenha3Des');
    Pointer(F_EncriptaSenha3Des) := GetProcAddress(F_Key, 'EncriptaSenha3Des');
    Pointer(F_Wk) := GetProcAddress(F_Key, 'wkc');
    Pointer(F_Imk) := GetProcAddress(F_Key, 'imk');


end;

procedure TFTestePinPad.BConectarClick(Sender: TObject);
    var
        VO_Mensagem: PChar;
begin
    VO_Mensagem:='';
    F_PinPadConectar(VO_Mensagem);

    Memo1.Lines.Add(VO_Mensagem);
end;

procedure TFTestePinPad.BDesconectarClick(Sender: TObject);
begin
    F_PinPadDesconectar();
end;

procedure TFTestePinPad.BMostrarClick(Sender: TObject);
var
    VL_Mensagem: TMensagem;
    VL_String: string;
    VL_Char:PChar;
begin
    VL_String := '';
    VL_Mensagem := TMensagem.Create;
    VL_Mensagem.AddComando('0047', EMostrar.Text);
    VL_Mensagem.TagToStr(VL_String);
    F_PinPadComando(1,Pchar( VL_String),VL_Char, @Resposta);
end;

procedure TFTestePinPad.BSenhaClick(Sender: TObject);
var
    VL_Mensagem: TMensagem;
    VL_String: string;
    VL_Char:PChar;
begin
    VL_String := '';
    VL_Char:='';
    VL_Mensagem := TMensagem.Create;
    VL_Mensagem.AddComando('005A', 'S');
    VL_Mensagem.AddTag('005B', IntToStr(F_Imk()));
    VL_Mensagem.AddTag('005C', ' DIGITE A SENHA');
    VL_Mensagem.AddTag('005D', '4');
    VL_Mensagem.AddTag('005E', '8');
    VL_Mensagem.AddTag('005F', F_Wk());
    VL_Mensagem.AddTag('0062', EPan.Text);
    VL_Mensagem.TagToStr(VL_String);
    F_PinPadComando(-1,Pchar( VL_String),VL_Char, @Resposta);

end;

procedure TFTestePinPad.BTarjaClick(Sender: TObject);
var
    VL_Mensagem: TMensagem;
    VL_String: string;
    VL_Char:PChar;
begin
    VL_String := '';
    VL_Char:='';
    VL_Mensagem := TMensagem.Create;
    VL_Mensagem.AddComando('0048', '0');
    VL_Mensagem.AddTag('0051', '60');
    VL_Mensagem.TagToStr(VL_String);
    F_PinPadComando(-1,Pchar( VL_String),VL_Char, @Resposta);

end;


end.
