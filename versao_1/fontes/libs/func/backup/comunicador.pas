unit comunicador;


{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LbRSA,StrUtils, LbClass, IdTCPClient, IdTCPServer, IdComponent,
  IdCustomTCPServer,funcoes, IdContext,LbAsym;

type

  { TDComunicador }

 TRecebe = procedure (VP_Dados:String);
 TKey = array [0..31] of Byte;
 TConexaoStatus= (csDesconectado,csLink,csAutenticado);

 TTChaves = record
  ID:Integer;
  Key :TKey;
 end;

 TTChaveConexao = class
   private
   fChaves : array of TTChaves;
   fContador:Integer;
   public
    constructor Create;
    function getChave(VP_ID:Integer):TTChaves;
    function addChave(VP_Key:TKey):Integer;

 end;

 TTConexao = class
   Aes:TLbRijndael;
   Rsa:TLbRSA;
   Ip:String;
   Porta:Integer;
   Hora:TDateTime;
   ID:Integer;
   ChaveComunicacaoIDX:Integer;
   ModuloPublico:String;
   ExpoentePublico:String;
   Status:TConexaoStatus;
   public
     constructor Create;
     destructor Destroy; override;
     procedure setModuloPublico(VP_Dados:string);
     procedure setExpoentePublico(VP_Dados:string);
     procedure setChaveConexao(VP_Chave:string);
     function getChavePublica:string;
     function getChaveConexao:String;
 end;

 TThRecebe = class(TThread)
      private
       fdados : AnsiString;
       fprocedimento:TRecebe;
      protected
        procedure Execute; override;
      public
        constructor Create(VP_Suspenso:Boolean;VP_Procedimento:TRecebe);
  end;

  TDComunicador = class(TDataModule)
    IdTCPServerCaixa: TIdTCPServer;
    IdTCPServerLib: TIdTCPServer;
    IdTCPSolicita: TIdTCPClient;
    IdTCPEscuta: TIdTCPClient;
    CriptoAes: TLbRijndael;
    CriptoRsa: TLbRSA;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure IdTCPEscutaConnected(Sender: TObject);
    procedure IdTCPEscutaDisconnected(Sender: TObject);
    procedure IdTCPServerCaixaConnect(AContext: TIdContext);
    procedure IdTCPServerCaixaExecute(AContext: TIdContext);
    procedure IdTCPServerLibConnect(AContext: TIdContext);
    procedure IdTCPServerLibExecute(AContext: TIdContext);
    procedure IdTCPSolicitaConnected(Sender: TObject);
    procedure IdTCPSolicitaDisconnected(Sender: TObject);
  private

  public
    v_Chave_Terminal : String;
    v_Versao_Comunicacao : Integer;
    function Conectar(VP_Host : AnsiString; VP_Porta: Integer):Integer;
    function enviar(VP_Dados:AnsiString;var VO_Retorno:AnsiString):Integer;
    procedure iniciaescuta(VP_Procedimento:TRecebe);
    function conectaescuta:Integer;
    function comando0021(VP_Mensagem: TMensagem;VP_AContext:TIdContext): Integer;

  end;

var
  DComunicador: TDComunicador;
  ThRecebe:TThRecebe;
  V_NumeroConexoes:Integer = 0;
  bConexaoEscuta,ConexaoSolicita:TTConexao;
  FChaveConexao:TTChaveConexao;
implementation

{$R *.lfm}

{ TDComunicador }

function TDComunicador.Conectar(VP_Host : AnsiString; VP_Porta : Integer):Integer;
var
  VL_Mensagem:TMensagem;
  VL_S:String;
  VL_Dados:String;
  VL_ChaveSimetrica:String;
  VL_OK:String;
  VL_ChaveSimetricaIDX:String;
  VL_ExpoentePublico,VL_ModuloPublico:String;
  VL_Key:TKey;
begin

VL_Mensagem:=TMensagem.Create;
VL_S:='';
VL_ModuloPublico:='';
VL_ExpoentePublico:='';
VL_ChaveSimetrica:='';
VL_ChaveSimetricaIDX:='';
VL_OK:='';
VL_Dados:='';
try
 if ConexaoSolicita.Status=csAutenticado then
 begin
  Result:=0;
  exit;
 end;

 if DComunicador.IdTCPSolicita.Connected then
 DComunicador.IdTCPSolicita.Disconnect;

 DComunicador.IdTCPSolicita.Host:=VP_Host;
 DComunicador.IdTCPSolicita.Port:=VP_Porta;

 if DComunicador.IdTCPEscuta.Connected then
  DComunicador.IdTCPEscuta.Disconnect;

  DComunicador.IdTCPEscuta.Host:=VP_Host;
  DComunicador.IdTCPEscuta.Port:=VP_Porta;


 DComunicador.IdTCPSolicita.Connect;

 if DComunicador.IdTCPSolicita.Connected=False then
 begin
   Result:=26;
   Exit;
 end;

 VL_Mensagem.Limpar;

 VL_Mensagem.AddComando('0021','');
 VL_Mensagem.AddTag('0022',IntToStr(ConexaoSolicita.ChaveComunicacaoIDX));
 VL_Mensagem.AddTag('0008',ConexaoSolicita.ModuloPublico);
 VL_Mensagem.AddTag('0027',ConexaoSolicita.ExpoentePublico);

 if ConexaoSolicita.ChaveComunicacaoIDX>0 then
 VL_Mensagem.AddTag('0023',ConexaoSolicita.Aes.EncryptString('OK'));

 Result:=VL_Mensagem.TagToStr(VL_S);
 if Result<>0 then
 Exit;

 DComunicador.IdTCPSolicita.Socket.WriteLn(VL_S);

 VL_S:=DComunicador.IdTCPSolicita.Socket.ReadLn;

 Result:=VL_Mensagem.CarregaTags(VL_S);

 if Result<>0 then
  Exit;

 VL_Mensagem.GetComando(VL_Dados);

 if VL_Dados='0024' then
 begin
   ConexaoSolicita.Status:=csAutenticado;
   Result:=0;
   Exit;
 end;

 if VL_Dados='0026' then
  begin
    VL_Mensagem.GetTag('0026',VL_Dados);
    Result:=StrToInt(VL_Dados);
    Exit;
  end;

 if VL_Dados='0025' then
  begin
  VL_Mensagem.GetTag('0008',VL_ModuloPublico);
  VL_Mensagem.GetTag('0027',VL_ExpoentePublico);
  VL_Mensagem.GetTag('0009',VL_ChaveSimetrica);
  VL_Mensagem.GetTag('0022',VL_ChaveSimetricaIDX);
  VL_Mensagem.GetTag('0023',VL_OK);

  ConexaoSolicita.ChaveComunicacaoIDX:=StrToInt(VL_ChaveSimetricaIDX);
  ConexaoSolicita.setExpoentePublico(VL_ExpoentePublico);
  ConexaoSolicita.setModuloPublico(VL_ModuloPublico);
  VL_ChaveSimetrica:=ConexaoSolicita.Rsa.DecryptString(VL_ChaveSimetrica);
  ConexaoSolicita.setChaveConexao(VL_ChaveSimetrica);
  VL_OK:=ConexaoSolicita.Aes.DecryptString(VL_OK);


  if VL_OK<>'OK' then
   begin
   Result:=32;
   Exit
   end;
  end;


finally
  VL_Mensagem.Free;
end;

end;


constructor TTChaveConexao.Create;
begin
  fContador:=0;
  inherited Create;
end;



function TTChaveConexao.getChave(VP_ID:Integer):TTChaves;
var
i:Integer;
begin
 for i:=0 to Length(fChaves)-1 do
 begin
  if VP_ID=fChaves[i].ID then
  begin
   Result:=fChaves[i];
   Exit;
  end;
 end;
end;

function TTChaveConexao.addChave(VP_Key:TKey):Integer;
begin
 fContador:=fContador+1;
 SetLength(fChaves,Length(fChaves)+1);
 fChaves[Length(fChaves)-1].ID:=fContador;
 fChaves[Length(fChaves)-1].Key:=VP_Key;
 Result:=fContador;

end;


constructor TTConexao.Create;
var
  VL_Key:TMemoryStream;
begin
  Status:=csDesconectado;

  Ip:='';
  Porta:=0;

  V_NumeroConexoes:=V_NumeroConexoes+1;
  ID:=V_NumeroConexoes;


  VL_Key:=TMemoryStream.Create;
  Aes:=TLbRijndael.Create(nil);
  Rsa:=TLbRSA.Create(nil);

  Rsa.KeySize:=DComunicador.CriptoRsa.KeySize;


  DComunicador.CriptoRsa.PrivateKey.StoreToStream(VL_Key);
  VL_Key.Position:=0;
  Rsa.PrivateKey.LoadFromStream(VL_Key);

  ExpoentePublico:=DComunicador.CriptoRsa.PublicKey.ExponentAsString;
  ModuloPublico:=DComunicador.CriptoRsa.PublicKey.ModulusAsString;

  Aes.KeySize:=DComunicador.CriptoAes.KeySize;
  Aes.GenerateRandomKey;

  inherited Create;
end;

destructor TTConexao.Destroy;
begin

  Aes.Free;
  Rsa.Free;
  inherited Destroy;
end;


procedure TTConexao.setModuloPublico(VP_Dados:string);
begin
 Rsa.PublicKey.ModulusAsString:=VP_Dados;
end;

procedure TTConexao.setExpoentePublico(VP_Dados:string);
begin
 Rsa.PublicKey.ExponentAsString:=VP_Dados;
end;

function TTConexao.getChavePublica:String;
var
 i:Integer;
 h:Array of byte;
 s:string;
 Key:TMemoryStream;
begin
 Key:=TMemoryStream.Create;

 Rsa.PublicKey.StoreToStream(Key);

 if Key.Size>0 then
 SetLength(h,Key.Size);
 Key.Position:=0;
 Key.ReadBuffer(pointer(h)^,Key.Size);

 s:='';
 for i:=0 to Length(h)-1 do
 begin
  s:=s+HexStr(h[i],2);
 end;
 Result:=s;
 Key.Free;

end;


function TTConexao.getChaveConexao:String;
var
 s:string;
 i:Integer;
 Key : array [0..31] of Byte;
begin
  s:='';
  Aes.GetKey(Key);
  for i:=0 to Length(key)-1 do
  begin
   s:=s+HexStr(key[i],2);
  end;
  Result:=s;
end;

procedure TTConexao.setChaveConexao(VP_Chave:string);
var
 i:Integer;
 c:string;
 Key : array [0..31] of Byte;
begin
 if not Length(VP_Chave)>0 then
 Exit;
 for i:=0 to Length(VP_Chave)div 2 -1 do
 begin
  c:=copy(VP_Chave,((1+i)*2)-1,2);
  Key[i]:=Hex2Dec(c);
 end;
 Aes.SetKey(Key);
end;


constructor TThRecebe.Create(VP_Suspenso:Boolean; VP_Procedimento:TRecebe);
begin
  FreeOnTerminate := True;
  fprocedimento:=VP_Procedimento;
  inherited Create(VP_Suspenso);
end;

procedure TThRecebe.Execute;
begin
 while not Terminated do
 begin
  sleep(100);
  if Assigned(fprocedimento) then
  if DComunicador.IdTCPEscuta.Connected then
  begin
   fprocedimento(DComunicador.IdTCPEscuta.Socket.ReadLn);
  end
  else
  begin
   sleep(5000);
   DComunicador.conectaescuta;
  end;
 end;
 if DComunicador.IdTCPEscuta.Connected then
 DComunicador.IdTCPEscuta.Disconnect;

end;

procedure TDComunicador.DataModuleCreate(Sender: TObject);
begin
  FChaveConexao:=TTChaveConexao.Create;
end;

procedure TDComunicador.DataModuleDestroy(Sender: TObject);
begin
  if IdTCPSolicita.Connected then
  IdTCPSolicita.Disconnect;

  FChaveConexao.free;
  BConexaoEscuta.Free;
  ConexaoSolicita.Free;


  if Assigned(ThRecebe) then
  ThRecebe.Terminate;

end;

procedure TDComunicador.IdTCPEscutaConnected(Sender: TObject);
begin
  bConexaoEscuta.Status:=csLink;
end;

procedure TDComunicador.IdTCPEscutaDisconnected(Sender: TObject);
begin
   ConexaoSolicita.Status:=csDesconectado;
end;

procedure TDComunicador.IdTCPServerCaixaConnect(AContext: TIdContext);
var
 TConexao: TTConexao;
begin
 TConexao:=TTConexao.Create;
 TConexao.Hora:=Now;
 TConexao.Ip:=AContext.Connection.Socket.Binding.PeerIP;
 TConexao.Porta:=AContext.Connection.Socket.Binding.PeerPort;
 AContext.Data:=TConexao;
 end;


procedure TDComunicador.IdTCPServerCaixaExecute(AContext: TIdContext);
var
 VL_DadosRecebidos:String;
 VL_Comando:String;
 VL_Mensagem:TMensagem;
 VL_Dados:String;

begin

 VL_Mensagem:=TMensagem.Create;

 VL_DadosRecebidos:=AContext.Connection.Socket.ReadLn;

 if VL_Mensagem.CarregaTags(VL_DadosRecebidos)<>0 then
 begin
  AContext.Connection.Disconnect;
  Exit;
 end;

 if VL_Mensagem.GetComando(VL_Comando)<>0 then
 begin
  AContext.Connection.Disconnect;
  Exit;
 end;

 case VL_Comando of
   '0021': comando0021(VL_Mensagem,AContext);
 else ;
   AContext.Connection.Disconnect;
 end;
 VL_Mensagem.Free;
end;

procedure TDComunicador.IdTCPServerLibConnect(AContext: TIdContext);
var
 TConexao: TTConexao;
begin
 TConexao:=TTConexao.Create;
 TConexao.Hora:=Now;
 TConexao.Ip:=AContext.Connection.Socket.Binding.PeerIP;
 TConexao.Porta:=AContext.Connection.Socket.Binding.PeerPort;
 AContext.Data:=TConexao;
 end;

procedure TDComunicador.IdTCPServerLibExecute(AContext: TIdContext);
begin
    AContext.Connection.Socket.ReadByte;
end;

procedure TDComunicador.IdTCPSolicitaConnected(Sender: TObject);
begin

   ConexaoSolicita.Status:=csLink;

end;

procedure TDComunicador.IdTCPSolicitaDisconnected(Sender: TObject);
begin
     ConexaoSolicita.Status:=csDesconectado;
end;

function TDComunicador.enviar(VP_Dados:AnsiString;var VO_Retorno:AnsiString):Integer;
begin
  Result:=0;
  try
  IdTCPSolicita.Socket.WriteLn(VP_Dados);
  IdTCPSolicita.Socket.ReadLn(VO_Retorno);
  except
    Result:=24;
  end;
end;

procedure TDComunicador.iniciaescuta(VP_Procedimento:TRecebe);
begin
 ThRecebe:=TThRecebe.Create(True,VP_Procedimento);
 ThRecebe.Start;
end;

function TDComunicador.conectaescuta:Integer;
begin
 Result:=0;
 //try
 // IdTCPEscuta.Connect(host,porta);
 // except
 //  Result:=25;
 // end;
 //

end;

function TDComunicador.comando0021(VP_Mensagem: TMensagem;VP_AContext:TIdContext): Integer;
var
 VL_Dados:String;
 VL_ChaveSimetrica:String;
 VL_ExpoentePublico,VL_ModuloPublico:String;
 VL_ChaveIDX:String;
 VL_TChaves:TTChaves;
 VL_Mensage:TMensagem;
 VL_Key:TKey;
begin
VL_Mensage:=TMensagem.Create;
try
  VP_Mensagem.GetTag('0023',VL_Dados);

  if VL_Dados<>'' then
  begin
    VP_Mensagem.GetTag('0022',VL_ChaveIDX);
    VL_TChaves:= FChaveConexao.getChave(StrToInt(VL_ChaveIDX));
    if VL_TChaves.ID>0 then
    begin
     CriptoAes.SetKey(VL_TChaves.Key);
     try
       if CriptoAes.DecryptString(VL_Dados)='OK' then
       begin
        VL_Mensage.AddComando('0024','');
        TTConexao(VP_AContext.Data).Aes.SetKey(VL_TChaves.Key);
        VL_Mensage.TagToStr(VL_Dados);
        VP_AContext.Connection.Socket.WriteLn(VL_Dados);
        Exit;
       end;
     except

     end;
    end;
    VP_Mensagem.GetTag('0008',VL_ModuloPublico);
    VP_Mensagem.GetTag('0027',VL_ExpoentePublico);
    if VL_ExpoentePublico='' then
    begin
     VL_Mensage.AddComando('0026','31');
     VL_Mensage.TagToStr(VL_Dados);
     VP_AContext.Connection.Socket.WriteLn(VL_Dados);
     Exit;
    end;
   end;
    VL_Mensage.limpar;
    VL_Mensage.AddComando('0025','');
    VP_Mensagem.GetTag('0008',VL_ModuloPublico);
    VP_Mensagem.GetTag('0027',VL_ExpoentePublico);

    TTConexao(VP_AContext.Data).setModuloPublico(VL_ModuloPublico);
    TTConexao(VP_AContext.Data).setExpoentePublico(VL_ExpoentePublico);

    VL_ChaveSimetrica:=TTConexao(VP_AContext.Data).getChaveConexao;

    VL_Dados:=TTConexao(VP_AContext.Data).Rsa.EncryptString(VL_ChaveSimetrica);

    VL_ChaveIDX:=IntToStr(FChaveConexao.addChave(VL_Key));

    VL_Mensage.AddTag('0009',VL_Dados);
    TTConexao(VP_AContext.Data).Aes.SetKey(VL_Key);
    TTConexao(VP_AContext.Data).ChaveComunicacaoIDX:=StrToInt(VL_ChaveIDX);
    VL_Mensage.AddTag('0022',VL_ChaveIDX);
    VL_Mensage.AddTag('0008',TTConexao(VP_AContext.Data).ModuloPublico);
    VL_Mensage.AddTag('0027',TTConexao(VP_AContext.Data).ExpoentePublico);
    VL_Mensage.AddTag('0023',TTConexao(VP_AContext.Data).Aes.EncryptString('OK'));
    VL_Mensage.TagToStr(VL_Dados);


    VP_AContext.Connection.Socket.WriteLn(VL_Dados);
    Result:=0;


finally
  VL_Mensage.Free;
end;

end;



end.

