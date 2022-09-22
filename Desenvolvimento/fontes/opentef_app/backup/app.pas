unit app;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, opentefnucleo, ubarcodes, funcoes;

type

    { TFApp }

    TFApp = class(TForm)
        BarcodeQR1: TBarcodeQR;
        BIniciar: TButton;
        BMenuOperaciona: TButton;
        BParar: TButton;
        BMenu: TButton;
        BBin: TButton;
        Button1: TButton;
        Button2: TButton;
        Button3: TButton;
        Image2: TImage;
        MMenu: TMemo;
        MBIN: TMemo;
        MMenuOperacional: TMemo;
        procedure BIniciarClick(Sender: TObject);
        procedure BMenuOperacionaClick(Sender: TObject);
        procedure BPararClick(Sender: TObject);
        procedure BMenuClick(Sender: TObject);
        procedure BBinClick(Sender: TObject);
        procedure Button1Click(Sender: TObject);
        procedure Button2Click(Sender: TObject);
        procedure Button3Click(Sender: TObject);
        procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);

    private

    public

    end;

var
    FApp: TFApp;
    t: TTemporizador;

implementation

{$R *.lfm}

{ TFApp }

procedure TFApp.BIniciarClick(Sender: TObject);
begin
    DNucleo := TDNucleo.Create(nil);
    F_ArquivoLog := ExtractFilePath(ParamStr(0)) + 'appopentef.log';
    DNucleo.iniciar;
end;

procedure TFApp.BMenuOperacionaClick(Sender: TObject);
var
    VL_I: integer;
    VL_Menu: TRecMenu;
begin
    MMenuOperacional.Lines.Clear;

    if not Assigned(DNucleo) then
        Exit;

    if DNucleo.VF_MenuOperacional.Count = 0 then
        Exit;

    for VL_I := 0 to DNucleo.VF_MenuOperacional.Count - 1 do
    begin
        VL_Menu := DNucleo.VF_MenuOperacional.Get(VL_I);
        MMenuOperacional.Lines.Add('Menu TAG:' + VL_Menu.Tag + ' Menu Botao:' + VL_Menu.TextoBotao + ' ModuloConf_ID:' + IntToStr(VL_Menu.ModuloConfID));
    end;

end;

procedure TFApp.BPararClick(Sender: TObject);
begin
    DNucleo.parar;
end;


procedure TFApp.BMenuClick(Sender: TObject);
var
    VL_I: integer;
    VL_Menu: TRecMenu;
begin
    MMenu.Lines.Clear;

    if not Assigned(DNucleo) then
        Exit;

    if DNucleo.VF_Menu.Count = 0 then
        Exit;

    for VL_I := 0 to DNucleo.VF_Menu.Count - 1 do
    begin
        VL_Menu := DNucleo.VF_Menu.Get(VL_I);
        MMenu.Lines.Add('Menu TAG:' + VL_Menu.Tag + ' Menu Botao:' + VL_Menu.TextoBotao + ' ModuloConf_ID:' + IntToStr(VL_Menu.ModuloConfID));
    end;

end;

procedure TFApp.BBinClick(Sender: TObject);
var
    VL_I: integer;
    VL_RecBin: TRecBin;
begin
    MBIN.Lines.Clear;

    if not Assigned(DNucleo) then
        Exit;

    if DNucleo.VF_Bin.Count = 0 then
        Exit;

    for VL_I := 0 to DNucleo.VF_Bin.Count - 1 do
    begin
        VL_RecBin := DNucleo.VF_Bin.Get(VL_I);
        MBIN.Lines.Add('BIN:' + VL_RecBin.IIN + ' ModuloConf_ID:' + IntToStr(VL_RecBin.ModuloConfID));
    end;

end;

procedure TFApp.Button1Click(Sender: TObject);
var
    s: string;

begin
    s := '';

    BarcodeToStr(s, BarcodeQR1);
    StrToImagem(s, Image2);
end;

procedure TFApp.Button2Click(Sender: TObject);
var
    VL_Mensagem: TMensagem;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Mensagem.AddComando('0111', 'S');

    DComunicador.ServidorTransmiteSolicitacaoIdentificacao(@DComunicador, 30000, False, nil, '122', VL_Mensagem, VL_Mensagem,
        'PDV', 'L01C001');

end;

procedure TFApp.Button3Click(Sender: TObject);
var
    VL_Mensagem: TMensagem;
begin
    VL_Mensagem := TMensagem.Create;
    try
        VL_Mensagem.AddComando('00CD', 'S'); //SOLICITA BINS
        DNucleo.ModuloAddSolicitacaoIdentificacaoAdquirente(0, '', 10000, '1', VL_Mensagem, cnServico);

    finally
        VL_Mensagem.Free;
    end;

end;



procedure TFApp.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
    if Assigned(DNucleo) then
        DNucleo.parar;
end;



end.
