unit app;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, opentefnucleo, ubarcodes, funcoes,
    ZConnection, ZDataset,
    rxmemds, IdContext, cadastro, LbClass, md5, base64, FMTBcd, DB, comunicador;

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
        Button10: TButton;
        Button2: TButton;
        Button3: TButton;
        Button4: TButton;
        Button5: TButton;
        Button6: TButton;
        Button7: TButton;
        Button8: TButton;
        Button9: TButton;
        Edit1: TEdit;
        Image2: TImage;
        MMenu: TMemo;
        MBIN: TMemo;
        MMenuOperacional: TMemo;
        procedure BIniciarClick(Sender: TObject);
        procedure BMenuOperacionaClick(Sender: TObject);
        procedure BPararClick(Sender: TObject);
        procedure BMenuClick(Sender: TObject);
        procedure BBinClick(Sender: TObject);
        procedure Button10Click(Sender: TObject);
        procedure Button1Click(Sender: TObject);
        procedure Button2Click(Sender: TObject);
        procedure Button3Click(Sender: TObject);
        procedure Button4Click(Sender: TObject);
        procedure Button5Click(Sender: TObject);
        procedure Button6Click(Sender: TObject);
        procedure Button7Click(Sender: TObject);
        procedure Button8Click(Sender: TObject);
        procedure Button9Click(Sender: TObject);
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

procedure TFApp.Button10Click(Sender: TObject);
var
    VL_Clientes: TIdContextList;
    VL_I: integer;
begin
    MBIN.Lines.Clear;

    if not Assigned(DComunicador) then
        exit;

    VL_Clientes := DComunicador.IdTCPServidor.Contexts.LockList;
    try
        for VL_I := 0 to VL_Clientes.Count - 1 do
        begin
            MBIN.Lines.Add('--------------------');
            MBIN.Lines.Add(IntToStr(TTConexao(TIdContext(VL_Clientes.Items[VL_I]).Data).ID));
            MBIN.Lines.Add(TTConexao(TIdContext(VL_Clientes.Items[VL_I]).Data).getChaveComunicacao);
            MBIN.Lines.Add(TTConexao(TIdContext(VL_Clientes.Items[VL_I]).Data).Terminal_Tipo);
            MBIN.Lines.Add(IntToStr(TTConexao(TIdContext(VL_Clientes.Items[VL_I]).Data).Terminal_ID));
            MBIN.Lines.Add(DateTimeToStr(TTConexao(TIdContext(VL_Clientes.Items[VL_I]).Data).Hora));
        end;
    finally
      DComunicador.IdTCPServidor.Contexts.UnlockList;
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

    DComunicador.ServidorTransmiteSolicitacaoIdentificacao(DComunicador, 30000, False, nil, '122', VL_Mensagem, VL_Mensagem,
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

procedure TFApp.Button4Click(Sender: TObject);
begin
    BarcodeQR1.SaveToFile('qrcode.png');
end;

procedure TFApp.Button5Click(Sender: TObject);
var

    JPEG: TJPEGImage;

begin
    JPEG := TJPEGImage.Create;
    JPEG.Assign(Image2.Picture.Graphic);
    JPEG.GrayScale := True;
    JPEG.CompressionQuality := 5;

    JPEG.Compress;
    JPEG.SaveToFile('qrcode.jpg');
    JPEG.Free;
end;

procedure TFApp.Button6Click(Sender: TObject);
var
    R: TRect;
    png: TPortableNetworkGraphic;
    s: string;
begin
    s := '';
    BarcodeToStr(s, BarcodeQR1);
    StrToImagem(s, Image2, TI_Png);

    Image2.Picture.SaveToFile('qrcode.png');
    exit;



    png := TPortableNetworkGraphic.Create;
    try
        R := Rect(0, 0, BarcodeQR1.Width, BarcodeQR1.Height);
        png.SetSize(BarcodeQR1.Width, BarcodeQR1.Height);
        png.Monochrome := True;
        png.Canvas.Brush.Color := clWhite;
        png.Canvas.FillRect(R);

        BarcodeQR1.PaintOnCanvas(png.Canvas, R);

        png.SaveToFile('qrcode.png');

    finally
        png.Free;
    end;

end;

procedure TFApp.Button7Click(Sender: TObject);
begin
    StrToImagem(GerarQRCodeAsString(Edit1.Text), Image2, TI_Png);
    Image2.Picture.SaveToFile('qrcode.png');
end;

procedure TFApp.Button8Click(Sender: TObject);
var
    VL_Mensagem: TMensagem;
    VL_Dados: TBytes;
    VL_Consulta: TZQuery;
    VL_String: string;
    VL_I: integer;
    VL_Arquivo: TMemoryStream;
    vl_blob: TBlobField;
    BlobStream: TStream;
    FileStream: TFileStream;
begin
    try


        DNucleo := TDNucleo.Create(nil);

        DNucleo.ZConexao.Database := ExtractFilePath(ParamStr(0)) + 'opentef.fdb';
        DNucleo.ZConexao.HostName := 'localhost';
        DNucleo.ZConexao.Port := 25050;
        DNucleo.ZConexao.Password := '2844';



        VL_Consulta := TZQuery.Create(DComunicador);
        VL_Consulta.Connection := DNucleo.ZConexao;


        //VL_Arquivo:=TMemoryStream.Create;
        //VL_Arquivo.LoadFromFile('E:\arquivo\o.dll');
        //VL_Arquivo.Position:=0;



        VL_Consulta.Close;
        VL_Consulta.SQL.Text :=
            'SELECT * FROM VERSAO WHERE id=2  ';
        VL_Consulta.Open;
        //        VL_Consulta.Edit;



        //        EncodeStringBase64(VL_Consulta.FieldByName('ARQUIVO').AsString)); // arquivo do programa
        ///      VL_Dados := VL_Consulta.FieldByName('ARQUIVO').AsBytes;

        //        (VL_Consulta.FieldByName('ARQUIVO') as TBlobField).LoadFromFile('E:\arquivo\o.dll');
        //        (VL_Consulta.FieldByName('ARQUIVO') as TBlobField).SaveToFile('E:\arquivo\d3.dll');
        //      VL_Consulta.Cancel;
        //        VL_Consulta.close;
        //      DNucleo.ZConexao.Commit;

        //        exit;
        //VL_Arquivo.SaveToFile('E:\arquivo\d2.dll');
        //VL_Arquivo.free;
        //       exit;

        TBlobField(VL_Consulta.FieldByName('ARQUIVO')).SaveToFile('E:\arquivo\d.dll');

        //        BlobStream := VL_Consulta.CreateBlobStream(VL_Consulta.FieldByName('ARQUIVO'), bmRead);

        //        BlobStream.Position:=0;
        //        FileStream := TFileStream.Create('E:\arquivo\d.dll', fmCreate);
        //        FileStream.CopyFrom(BlobStream, BlobStream.Size);
        //        FileStream.Free;
        //        FileStream.Free;
        //        BlobStream.Free;


        //vl_blob := TBlobField.Create(nil);
        //vl_blob := TBlobField(VL_Consulta.FieldByName('ARQUIVO'));
        //vl_blob.SaveToFile('E:\Lazarus\OpenTef\publica\binarios\tef_lib\win32\TESTE.DLLOPEN');
        //vl_blob.Free;




        // VL_String:= DecodeStringBase64(VL_String);

        //  VL_Arquivo := TMemoryStream.Create;
        //  VL_Arquivo.SetSize(Length(VL_Dados));
        //  VL_Arquivo.Position:=0;
        //  VL_Arquivo.Write(VL_Dados[0],Length(VL_Dados));

        //  vl_blob:=TBlobField.cr

        //VL_Arquivo.SaveToFile(PChar('E:\Lazarus\OpenTef\publica\binarios\tef_lib\win32\TESTE.DLLOPEN'));
        //VL_Arquivo.Free;




        //        VL_I := Length(VL_Dados);

        //        DComunicador.ServidorTransmiteSolicitacaoID(DComunicador,
        //            30000 + VL_I, False, nil, VP_Transmissao_ID,
        //            VL_Mensagem, VL_Mensagem, VP_Conexao_ID);

    finally
        DNucleo.Free;
        VL_Consulta.Close;
        VL_Consulta.Free;
    end;

end;

procedure TFApp.Button9Click(Sender: TObject);
var
    VL_RecDLL: ^TRecDLL;
    i: integer;
begin
    for i := 0 to DNucleo.VF_DLL.ListaDLL.Count - 1 do
    begin
        VL_RecDLL := DNucleo.VF_DLL.ListaDLL[i];
        MBIN.Lines.Add(FloatToStr(VL_RecDLL^.handle));
        MBIN.Lines.Add(VL_RecDLL^.nome);
    end;

end;



procedure TFApp.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
    if Assigned(DNucleo) then
        DNucleo.parar;
end;


end.
