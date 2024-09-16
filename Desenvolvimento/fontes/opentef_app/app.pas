unit app;

{$mode objfpc}{$H+}{$RANGECHECKS OFF}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, opentefnucleo, ubarcodes, funcoes,
  ZConnection, ZDataset,
  rxmemds, IdContext, cadastro, LbClass, md5, base64, FMTBcd, DB, comunicador, bancodados;

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
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
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
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
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
  VL_RecModulo: TRecModulo;
begin
  MBIN.Lines.Clear;

  if not Assigned(DNucleo) then
    Exit;

  if DNucleo.VF_Modulo.Count = 0 then
    Exit;

  for VL_I := 0 to DNucleo.VF_Modulo.Count - 1 do
  begin
    VL_RecModulo := DNucleo.VF_Modulo.Get(VL_I);
    MBIN.Lines.Add('BIN:' + VL_RecModulo.IIN + ' ModuloConf_ID:' + IntToStr(VL_RecModulo.ModuloConfID));
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

procedure TFApp.Button11Click(Sender: TObject);
var
  lib: TLibHandle;
  Finalizar: TFinalizar;
  Inicializar: TModuloInicializar;
  PModulo: Pointer;
begin
  lib := LoadLibrary(PChar(ExtractFilePath(ParamStr(0)) + 'modulo\0068.dll'));

  Pointer(Finalizar) := GetProcAddress(lib, 'finalizar');
  Pointer(Inicializar) := GetProcAddress(lib, 'inicializar');

  Inicializar(1, PModulo, nil, 1, PChar(ExtractFilePath(ParamStr(0)) + 'teste.log'));
  Finalizar(PModulo);

  UnloadLibrary(lib);
end;

procedure TFApp.Button12Click(Sender: TObject);
var
  VL_BancoDados: TDBancoDados;
begin
  MMenu.Lines.Clear;

  VL_BancoDados := TDBancoDados.Create(nil);

  VL_BancoDados.ConsultaA.Close;
  VL_BancoDados.ConsultaA.SQL.Text := 'SELECT DADOS FROM TAG WHERE TAG_TIPO = ''MENU_PDV'' ';
  VL_BancoDados.ConsultaA.Open;

  VL_BancoDados.ConsultaA.First;
  while not VL_BancoDados.ConsultaA.EOF do
  begin
    MMenu.Lines.Add(VL_BancoDados.ConsultaA.FieldByName('DADOS').AsString);
    VL_BancoDados.ConsultaA.Next;
  end;

  VL_BancoDados.Free;
end;

procedure TFApp.Button13Click(Sender: TObject);
var
  s: TLBytes;
begin
  s := nil;
  setlength(s, 3);
  s[0] := 65;
  s[1] := 65;
  s[2] := 65;
  // mmenu.lines.add(inttostr(crc16(s,length(s))));

end;

procedure recebimento(VP_Transmissao_ID: PUtf8Char; VP_Tarefa_ID, VP_ModuloProcID, VP_Erro: integer; VP_Dados: PUtf8Char; VP_Modulo: Pointer); cdecl;
begin
  sleep(5);
end;

procedure dll;
type
  TLogin = function(VP_Modulo: Pointer; VP_Host: PUtf8Char; VP_Porta: integer; VP_ChaveComunicacao, VP_TipoConexao, VP_Identificacao: PUtf8Char): integer; cdecl;
  TFinalizar = function(VP_Modulo: Pointer): integer; cdecl;
  TModuloInicializar = function(VP_ModuloProcID: integer; var VO_Modulo: Pointer; VP_Recebimento: TRetornoModulo; VP_Modulo_ID: integer; VP_ArquivoLog: PUtf8Char): integer; cdecl;
  TModuloStatus = function(VP_Modulo: Pointer; var VO_Versao: PUtf8Char; var VO_VersaoMensagem: integer; var VO_StatusRetorno: integer): integer; cdecl;
  TStrDispose = procedure(VP_PChar: PChar); cdecl;
var
  lib: TLibHandle;
  inicializar: TModuloInicializar;
  finalizar: TFinalizar;
  moduloStatus: TModuloStatus;
  strDispose: TStrDispose;
  login: TLogin;

  moduloServico: pointer;
  moduloCaixa: pointer;
  erro: integer;
  retorno: PUtf8Char;

  VL_VersaoModulo: string;
  VL_VersaoMensagem: integer;
  VL_DadosInteger: integer;
begin
  erro := 0;
  retorno := nil;
  VL_VersaoModulo := '';

  lib := LoadLibrary(PChar(ExtractFilePath(ParamStr(0)) + 'modulo/0068.dll'));

  if lib <= 0 then
    Exit;

  Pointer(login) := GetProcAddress(lib, 'login');
  Pointer(finalizar) := GetProcAddress(lib, 'finalizar');
  Pointer(inicializar) := GetProcAddress(lib, 'inicializar');
  Pointer(moduloStatus) := GetProcAddress(lib, 'modulostatus');
  Pointer(strDispose) := GetProcAddress(lib, 'mensagemdispose');

  inicializar(1, moduloCaixa, @recebimento, 6, PUtf8Char('E:\Projetos\Desenvolvedor\Thiago\Lazarus\OpenTef\publica\binarios\opentef\win32\0068_servico.txt'));

  erro := moduloStatus(moduloCaixa, retorno, VL_VersaoMensagem, VL_DadosInteger);

  VL_VersaoModulo := retorno;
  strDispose(retorno);

  erro := login(moduloCaixa, PUtf8Char('127.0.0.1'), 555, PUtf8Char('321'), PUtf8Char('C'), PUtf8Char('21644664'));

  inicializar(1, moduloServico, @recebimento, 6, PUtf8Char('E:\Projetos\Desenvolvedor\Thiago\Lazarus\OpenTef\publica\binarios\opentef\win32\0068_servico.txt'));

  erro := moduloStatus(moduloServico, retorno, VL_VersaoMensagem, VL_DadosInteger);

  VL_VersaoModulo := retorno;
  strDispose(retorno);

  erro := login(moduloServico, PUtf8Char('127.0.0.1'), 555, PUtf8Char('321'), PUtf8Char('C'), PUtf8Char('21644664'));

  erro := finalizar(moduloCaixa);
  erro := finalizar(moduloServico);

  UnloadLibrary(lib);

end;

procedure TFApp.Button14Click(Sender: TObject);
begin
  with TThread.CreateAnonymousThread(TProcedure(@dll)) do
  begin
    FreeOnTerminate := True;
    start;
  end;
end;

procedure TFApp.Button15Click(Sender: TObject);
var
  VL_TTabela: TDBancoDados;
begin
  MBin.Lines.Clear;

  VL_TTabela := TDBancoDados.Create(nil);

  VL_TTabela.ConsultaA.Close;
  VL_TTabela.ConsultaA.SQL.Text := 'SELECT T.ID,T.TAG_NUMERO,T.TAG_TIPO,T.TIPO_DADOS,T.DEFINICAO FROM TAG T';
  VL_TTabela.ConsultaA.Open;

  VL_TTabela.ConsultaA.First;
  while not VL_TTabela.ConsultaA.EOF do
  begin
    MBin.Lines.Add(VL_TTabela.ConsultaA.FieldByName('DEFINICAO').AsString);
    VL_TTabela.ConsultaA.Next;
  end;

  VL_TTabela.Free;
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

  DComunicador.ServidorTransmiteSolicitacaoIdentificacao(DComunicador,
    30000, False, nil, '122', VL_Mensagem, VL_Mensagem,
    'L01C001');

end;

procedure TFApp.Button3Click(Sender: TObject);
var
  VL_Mensagem: TMensagem;
begin
  VL_Mensagem := TMensagem.Create;
  try
    VL_Mensagem.AddComando('00CD', 'S'); //SOLICITA BINS
    DNucleo.ModuloAddSolicitacaoIdentificacaoAdquirente(0, '',
      10000, '1', VL_Mensagem, cnServico);

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
  MBIN.Lines.Clear;

  if not Assigned(DNucleo) then
    Exit;

  if DNucleo.VF_DLL.ListaDLL.Count = 0 then
    Exit;

  for i := 0 to DNucleo.VF_DLL.ListaDLL.Count - 1 do
  begin
    VL_RecDLL := DNucleo.VF_DLL.ListaDLL[i];
    MBIN.Lines.Add(IntToStr(VL_RecDLL^.handle));
    MBIN.Lines.Add(VL_RecDLL^.nome);
  end;

end;



procedure TFApp.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if Assigned(DNucleo) then
    DNucleo.parar;
end;


end.
