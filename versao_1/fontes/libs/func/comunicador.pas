unit comunicador;


{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LbRSA,StrUtils, LbClass, IdTCPClient, IdTCPServer,ZDataset, IdComponent,
  IdCustomTCPServer,funcoes, IdContext,LbAsym,DB,rxmemds;

type

  { TDComunicador }

 TRecebe = procedure (VP_Dados:String);
 TKey = array [0..31] of Byte;
 TConexaoStatus= (csDesconectado,csLink,csChaveado,csLogado);
 TTConexaoTipo = (cFConexaoEscuta,cFConexaoSolicita);

 TTChaveComunicacao = record
  ID:Integer;
  ChaveComunicacao :String;
 end;

 TTChaveConexao = class
   private
   fChaveComunicacao : array of TTChaveComunicacao;
   fContador:Integer;
   public
    constructor Create;
    function getChave(VP_ID:Integer):TTChaveComunicacao;
    function addChave(VP_ChaveComunicacao:String):Integer;

 end;

 TTConexao = class
   Aes:TLbRijndael;
   Rsa:TLbRSA;
   ClienteIp:String;
   ClientePorta:Integer;
   ServidorHost:String;
   ServidorPorta:Integer;
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
     procedure setChaveComunicacao(VP_Chave:string);
     function getChavePublica:string;
     function getChaveComunicacao:String;
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
    V_Chave_Terminal : String;
    V_Versao_Comunicacao : Integer;
    V_ThRecebe:TThRecebe;
    V_ConexaoEscuta,V_ConexaoSolicita:TTConexao;
    V_ChavesDasConexoes:TTChaveConexao;

    function DesconectarSolicitacao:Integer;
    function ConectarSolicitacao:Integer;
    function TransmiteSolicitacaoCliente(var VO_Dados:TMensagem;var VO_Retorno:TMensagem; VP_Procedimento:TRecebe):Integer;
    procedure iniciaescuta(VP_Procedimento:TRecebe);
    function conectaescuta:Integer;
    function MenuCompativel(VP_Menu:String;VPModulo:String;var VO_Compativel:Boolean):Integer;
    function EnviarCliente(VL_Mensage:TMensagem;VP_AContext:TIdContext):Integer;

    {$IFNDEF CLIENTE}
    function comando0001(VP_Mensagem: TMensagem;VP_AContext:TIdContext): Integer;
    function comando0021(VP_Mensagem: TMensagem;VP_AContext:TIdContext): Integer;
    function comando000A(VP_Mensagem: TMensagem;VP_AContext:TIdContext): Integer;
    function comando0018(VP_Mensagem: TMensagem;VP_AContext:TIdContext): Integer;
    function comando0039(VP_Mensagem: TMensagem;VP_AContext:TIdContext): Integer;
    function comando003C(VP_Mensagem: TMensagem;VP_AContext:TIdContext): Integer;
    function comando003F(VP_Mensagem: TMensagem;VP_AContext:TIdContext): Integer;
    function comando0043(VP_Mensagem: TMensagem;VP_AContext:TIdContext): Integer;
    function comando0044(VP_Mensagem: TMensagem;VP_AContext:TIdContext): Integer;
    function comando0045(VP_Mensagem: TMensagem;VP_AContext:TIdContext): Integer;
    function comando004B(VP_Mensagem: TMensagem;VP_AContext:TIdContext): Integer;
    function comando0053(VP_Mensagem: TMensagem;VP_AContext:TIdContext): Integer;
    function comando0054(VP_Mensagem: TMensagem;VP_AContext:TIdContext): Integer;
    function comando0055(VP_Mensagem: TMensagem;VP_AContext:TIdContext): Integer;
    function comando0056(VP_Mensagem: TMensagem;VP_AContext:TIdContext): Integer;
    function comando0057(VP_Mensagem: TMensagem;VP_AContext:TIdContext): Integer;
    function comando0058(VP_Mensagem: TMensagem;VP_AContext:TIdContext): Integer;
    function comando0059(VP_Mensagem: TMensagem;VP_AContext:TIdContext): Integer;
    {$ENDIF CLIENTE}


  end;

var
  DComunicador: TDComunicador;
  F : TDFuncoes;
implementation


  {$IFNDEF CLIENTE}
  USES
  opentefnucleo;
  {$ELSE}

  {$ENDIF CLIENTE}


{$R *.lfm}

{ TDComunicador }

function TDComunicador.ConectarSolicitacao:Integer;
var
  VL_Mensagem:TMensagem;
  VL_S:String;
  VL_Comando : String;
  VL_Dados:String;
  VL_ChaveComunicacao:String;
  VL_OK:String;
  VL_ChaveComunicacaoIDX:String;
  VL_ExpoentePublico,VL_ModuloPublico:String;

begin

VL_Mensagem:=TMensagem.Create;
VL_S:='';
VL_ModuloPublico:='';
VL_ExpoentePublico:='';
VL_ChaveComunicacao:='';
VL_ChaveComunicacaoIDX:='';
VL_OK:='';
VL_Dados:='';
VL_Comando:='';
try
 if (V_ConexaoSolicita.Status=csChaveado) or (V_ConexaoSolicita.Status=csLogado) then
 begin
  Result:=0;
  exit;
 end;


 if DComunicador.IdTCPSolicita.Connected then
 DComunicador.IdTCPSolicita.Disconnect;

 DComunicador.IdTCPSolicita.Host:=V_ConexaoSolicita.ServidorHost;
 DComunicador.IdTCPSolicita.Port:=V_ConexaoSolicita.ServidorPorta;

 DComunicador.IdTCPSolicita.Connect;

 if DComunicador.IdTCPSolicita.Connected=False then
 begin
   Result:=26;
   Exit;
 end;

 VL_Mensagem.Limpar;

 VL_Mensagem.AddComando('0021','');
 VL_Mensagem.AddTag('0022',IntToStr(V_ConexaoSolicita.ChaveComunicacaoIDX));
 VL_Mensagem.AddTag('0008',V_ConexaoSolicita.ModuloPublico);
 VL_Mensagem.AddTag('0027',V_ConexaoSolicita.ExpoentePublico);

 if V_ConexaoSolicita.ChaveComunicacaoIDX>0 then
 VL_Mensagem.AddTag('0023',V_ConexaoSolicita.Aes.EncryptString('OK'));

 Result:=VL_Mensagem.TagToStr(VL_S);
 if Result<>0 then
 Exit;

 DComunicador.IdTCPSolicita.Socket.WriteLn(VL_S);

 VL_S:=DComunicador.IdTCPSolicita.Socket.ReadLn;

 Result:=VL_Mensagem.CarregaTags(VL_S);

 if Result<>0 then
  Exit;

 VL_Mensagem.GetComando(VL_Comando,VL_Dados);

 if VL_Comando='0024' then
 begin
   V_ConexaoSolicita.Status:=csChaveado;
   Result:=0;
   Exit;
 end;

 if VL_Comando='0026' then
  begin
    VL_Mensagem.GetTag('0026',VL_Comando);
    Result:=StrToInt(VL_Comando);
    Exit;
  end;

 if VL_Comando='0025' then
  begin
  VL_Mensagem.GetTag('0008',VL_ModuloPublico);
  VL_Mensagem.GetTag('0027',VL_ExpoentePublico);
  VL_Mensagem.GetTag('0009',VL_ChaveComunicacao);
  VL_Mensagem.GetTag('0022',VL_ChaveComunicacaoIDX);
  VL_Mensagem.GetTag('0023',VL_OK);

  V_ConexaoSolicita.setExpoentePublico(VL_ExpoentePublico);
  V_ConexaoSolicita.setModuloPublico(VL_ModuloPublico);
  VL_ChaveComunicacao:=V_ConexaoSolicita.Rsa.DecryptString(VL_ChaveComunicacao);
  V_ConexaoSolicita.setChaveComunicacao(VL_ChaveComunicacao);
  V_ConexaoSolicita.ChaveComunicacaoIDX:=StrToInt(VL_ChaveComunicacaoIDX);
  VL_OK:=V_ConexaoSolicita.Aes.DecryptString(VL_OK);


  if VL_OK<>'OK' then
   begin
   Result:=32;
   Exit
   end;
  V_ConexaoSolicita.Status:=csChaveado;
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



function TTChaveConexao.getChave(VP_ID:Integer):TTChaveComunicacao;
var
i:Integer;
begin
 for i:=0 to Length(fChaveComunicacao)-1 do
 begin
  if VP_ID=fChaveComunicacao[i].ID then
  begin
   Result:=fChaveComunicacao[i];
   Exit;
  end;
 end;
end;

function TTChaveConexao.addChave(VP_ChaveComunicacao:String):Integer;
begin
 fContador:=fContador+1;
 SetLength(fChaveComunicacao,Length(fChaveComunicacao)+1);
 fChaveComunicacao[Length(fChaveComunicacao)-1].ID:=fContador;
 fChaveComunicacao[Length(fChaveComunicacao)-1].ChaveComunicacao:=VP_ChaveComunicacao;
 Result:=fContador;

end;


constructor TTConexao.Create;
var
  VL_Key:TMemoryStream;
begin
  Status:=csDesconectado;

  ServidorHost:='';
  ServidorPorta:=0;

  ClienteIp:='';
  ClientePorta:=0;


  VL_Key:=TMemoryStream.Create;
  Aes:=TLbRijndael.Create(nil);
  Rsa:=TLbRSA.Create(nil);

  Aes.KeySize:=DComunicador.CriptoAes.KeySize;
  Aes.CipherMode:=DComunicador.CriptoAes.CipherMode;
  Aes.GenerateRandomKey;

  Rsa.KeySize:=DComunicador.CriptoRsa.KeySize;


  DComunicador.CriptoRsa.PrivateKey.StoreToStream(VL_Key);
  VL_Key.Position:=0;
  Rsa.PrivateKey.LoadFromStream(VL_Key);

  ExpoentePublico:=DComunicador.CriptoRsa.PublicKey.ExponentAsString;
  ModuloPublico:=DComunicador.CriptoRsa.PublicKey.ModulusAsString;

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


function TTConexao.getChaveComunicacao:String;
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

procedure TTConexao.setChaveComunicacao(VP_Chave:string);
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
  V_ChavesDasConexoes:=TTChaveConexao.Create;
end;

procedure TDComunicador.DataModuleDestroy(Sender: TObject);
begin
  if IdTCPSolicita.Connected then
  IdTCPSolicita.Disconnect;

  V_ChavesDasConexoes.free;
  V_ConexaoEscuta.Free;
  V_ConexaoSolicita.Free;


  if Assigned(V_ThRecebe) then
  V_ThRecebe.Terminate;

end;

procedure TDComunicador.IdTCPEscutaConnected(Sender: TObject);
begin
  V_ConexaoEscuta.Status:=csLink;
end;

procedure TDComunicador.IdTCPEscutaDisconnected(Sender: TObject);
begin
   V_ConexaoSolicita.Status:=csDesconectado;
end;

procedure TDComunicador.IdTCPServerCaixaConnect(AContext: TIdContext);
var
 TConexao: TTConexao;
begin
 TConexao:=TTConexao.Create;
 TConexao.Hora:=Now;
 TConexao.ClienteIp:=AContext.Connection.Socket.Binding.PeerIP;
 TConexao.ClientePorta:=AContext.Connection.Socket.Binding.PeerPort;
 TConexao.Status:=csLink;
 TConexao.ChaveComunicacaoIDX:=V_ChavesDasConexoes.addChave(TConexao.getChaveComunicacao);
 AContext.Data:=TConexao;
 end;


procedure TDComunicador.IdTCPServerCaixaExecute(AContext: TIdContext);
var
 VL_DadosRecebidos:String;
 VL_Comando:String;
 VL_Mensagem:TMensagem;
 VL_Dados : string;

begin
 VL_Comando:='';
 VL_Dados:='';
 VL_Mensagem:=TMensagem.Create;

 VL_DadosRecebidos:=AContext.Connection.Socket.ReadLn;

 if (TTConexao(AContext.Data).Status=csChaveado) or (TTConexao(AContext.Data).Status=csLogado) then
 VL_DadosRecebidos:=Copy(VL_DadosRecebidos,1,5)+TTConexao(AContext.Data).Aes.DecryptString(Copy(VL_DadosRecebidos,6,MaxInt));

 if VL_Mensagem.CarregaTags(VL_DadosRecebidos)<>0 then
 begin
  AContext.Connection.Disconnect;
  Exit;
 end;

 if VL_Mensagem.GetComando(VL_Comando,VL_Dados)<>0 then
 begin
  AContext.Connection.Disconnect;
  Exit;
 end;
 {$IFNDEF CLIENTE}
 case VL_Comando of
   '0001': comando0001(VL_Mensagem,AContext);
   '0021': comando0021(VL_Mensagem,AContext);
   '000A': comando000A(VL_Mensagem,AContext);
   '0039': comando0039(VL_Mensagem,AContext);
   '003C': comando003C(VL_Mensagem,AContext);
   '003F': comando003F(VL_Mensagem,AContext);
   '0043': comando0043(VL_Mensagem,AContext);
   '0044': comando0044(VL_Mensagem,AContext);
   '0045': comando0045(VL_Mensagem,AContext);
   '004B': comando004B(VL_Mensagem,AContext);
   '0053': comando0053(VL_Mensagem,AContext);
   '0054': comando0054(VL_Mensagem,AContext);
   '0055': comando0055(VL_Mensagem,AContext);
   '0056': comando0056(VL_Mensagem,AContext);
   '0057': comando0057(VL_Mensagem,AContext);
   '0058': comando0058(VL_Mensagem,AContext);
   '0059': comando0059(VL_Mensagem,AContext);
 else
   AContext.Connection.Disconnect;
 end;
{$ENDIF CLIENTE}


 VL_Mensagem.Free;
end;

procedure TDComunicador.IdTCPServerLibConnect(AContext: TIdContext);
var
 TConexao: TTConexao;
begin
 TConexao:=TTConexao.Create;
 TConexao.Hora:=Now;
 TConexao.ClienteIp:=AContext.Connection.Socket.Binding.PeerIP;
 TConexao.ClientePorta:=AContext.Connection.Socket.Binding.PeerPort;
 AContext.Data:=TConexao;
 end;

procedure TDComunicador.IdTCPServerLibExecute(AContext: TIdContext);
begin
    AContext.Connection.Socket.ReadByte;
end;

procedure TDComunicador.IdTCPSolicitaConnected(Sender: TObject);
begin
   V_ConexaoSolicita.Status:=csLink;
end;

procedure TDComunicador.IdTCPSolicitaDisconnected(Sender: TObject);
begin
   V_ConexaoSolicita.Status:=csDesconectado;
end;

function TDComunicador.DesconectarSolicitacao: Integer;
begin
 if DComunicador.IdTCPSolicita.Connected then
    DComunicador.IdTCPSolicita.Disconnect;
end;

function TDComunicador.TransmiteSolicitacaoCliente(var VO_Dados:TMensagem;var VO_Retorno:TMensagem; VP_Procedimento:TRecebe):Integer;
var
 VL_DadosCriptografado:String;
 VL_Dados:String;
begin
  Result:=0;
  VL_Dados:='';
  try
  if (V_ConexaoSolicita.Status<>csChaveado) and (V_ConexaoSolicita.Status<>csLogado) then
  begin
       Result:=DComunicador.ConectarSolicitacao;
       if Result<>0 then
       Exit;
  end;
  Result:=VO_Dados.TagToStr(VL_Dados);
  if Result<>0 then
  Exit;
  VL_DadosCriptografado:=Copy(VL_Dados,1,5)+DComunicador.V_ConexaoSolicita.Aes.EncryptString(Copy(VL_Dados,6,MaxInt));
  IdTCPSolicita.Socket.WriteLn(VL_DadosCriptografado);
  VL_Dados:=IdTCPSolicita.Socket.ReadLn;
  VL_Dados:=Copy(VL_Dados,1,5)+DComunicador.V_ConexaoSolicita.Aes.DecryptString(Copy(VL_Dados,6,MaxInt));
  VO_Retorno.CarregaTags(VL_Dados);
  if Assigned(VP_Procedimento) then
  VP_Procedimento(VL_Dados);
  except
    Begin
    Result:=24;
    V_ConexaoSolicita.Status:=csDesconectado;
    if DComunicador.IdTCPSolicita.Connected then
    DComunicador.IdTCPSolicita.Disconnect(False);
    end;
  end;
end;

procedure TDComunicador.iniciaescuta(VP_Procedimento:TRecebe);
begin
 V_ThRecebe:=TThRecebe.Create(True,VP_Procedimento);
 V_ThRecebe.Start;
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

function TDComunicador.MenuCompativel(VP_Menu: String; VPModulo: String;
  var VO_Compativel: Boolean): Integer;
begin
   // listar todos modulos
end;

function TDComunicador.EnviarCliente(VL_Mensage: TMensagem; VP_AContext: TIdContext): Integer;
var
 VL_Dados:String;
begin
Result:=0;
VL_Dados:='';
VL_Mensage.TagToStr(VL_Dados);

VL_Dados:= Copy(VL_Dados,1,5)+TTConexao(VP_AContext.Data).Aes.EncryptString(Copy(VL_Dados,6,MaxInt));

VP_AContext.Connection.Socket.WriteLn(VL_Dados);

end;

{$IFNDEF CLIENTE}
function TDComunicador.comando0021(VP_Mensagem: TMensagem;VP_AContext:TIdContext): Integer;
var
 VL_Dados:String;
 VL_ExpoentePublico,VL_ModuloPublico:String;
 VL_TChaves:TTChaveComunicacao;
 VL_Mensage:TMensagem;

begin
VL_Mensage:=TMensagem.Create;
VL_Dados:='';
VL_TChaves.ID:=0;
VL_TChaves.ChaveComunicacao:='';
VL_ModuloPublico:='';
VL_ExpoentePublico:='';
try
  VP_Mensagem.GetTag('0023',VL_Dados);
  Result:=33;
  if TTConexao(VP_AContext.Data).Status=csDesconectado then
  Exit;
  if VL_Dados<>'' then
  begin
    VP_Mensagem.GetTag('0022',VL_TChaves.ID);
    VL_TChaves:= V_ChavesDasConexoes.getChave((VL_TChaves.ID));
    if VL_TChaves.ID>0 then
    begin
     TTConexao(VP_AContext.Data).setChaveComunicacao(VL_TChaves.ChaveComunicacao);
     try
       if TTConexao(VP_AContext.Data).Aes.DecryptString(VL_Dados)='OK' then
       begin
        VL_Mensage.AddComando('0024','');
        VL_Mensage.TagToStr(VL_Dados);
        TTConexao(VP_AContext.Data).Status:=csChaveado;
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

    VL_TChaves.ChaveComunicacao:=TTConexao(VP_AContext.Data).getChaveComunicacao;
    VL_TChaves.ID:=TTConexao(VP_AContext.Data).ChaveComunicacaoIDX;

    VL_Dados:=TTConexao(VP_AContext.Data).Rsa.EncryptString(VL_TChaves.ChaveComunicacao);

    VL_Mensage.AddTag('0009',VL_Dados);
    VL_Mensage.AddTag('0022',VL_TChaves.ID);
    VL_Mensage.AddTag('0008',TTConexao(VP_AContext.Data).ModuloPublico);
    VL_Mensage.AddTag('0027',TTConexao(VP_AContext.Data).ExpoentePublico);
    VL_Mensage.AddTag('0023',TTConexao(VP_AContext.Data).Aes.EncryptString('OK'));

    VL_Mensage.TagToStr(VL_Dados);
    TTConexao(VP_AContext.Data).Status:=csChaveado;
    VP_AContext.Connection.Socket.WriteLn(VL_Dados);
    Result:=0;


finally
  VL_Mensage.Free;
end;

end;

function TDComunicador.comando0001(VP_Mensagem: TMensagem;VP_AContext:TIdContext): Integer;
var

 VL_ChaveTerminal,VL_IP:String;
 VL_Mensagem:TMensagem;
 VL_Consulta : TZQuery;
 VL_TerminalSenha : string;
 VL_TerminalTipo : string;

begin
Result:=0;
VL_Mensagem:=TMensagem.Create;
VL_ChaveTerminal:='';
VL_TerminalSenha:='';
VL_TerminalTipo:='';
VL_Consulta := TZQuery.Create(DComunicador);
VL_Consulta.Connection := DNucleo.ZConexao;
try
  //inicio do processo
  VP_Mensagem.GetTag('0002',VL_ChaveTerminal);
  VP_Mensagem.GetTag('0035',VL_TerminalSenha);
  VP_Mensagem.GetTag('0037',VL_TerminalTipo);

  VL_IP:= TTConexao(VP_AContext.Data).ClienteIp;

  VL_Consulta.Close;
  VL_Consulta.SQL.Text:='SELECT * FROM P_VAL_TERMINAL('''+VL_IP+''','''+VL_ChaveTerminal+''','''+
                                VL_TerminalSenha+''','''+VL_TerminalTipo+''')';
  VL_Consulta.Open;

  if VL_Consulta.FieldByName('S_STATUS').AsInteger<>0 then
  begin
   VL_Mensagem.AddComando('0029','OK');
   VL_Mensagem.AddTag('0036',IntToStr(VL_Consulta.FieldByName('S_STATUS').AsInteger));
   result:=VL_Consulta.FieldByName('S_STATUS').AsInteger;
  end
  else
  begin
   TTConexao(VP_AContext.Data).Status:=csLogado;
   VL_Mensagem.AddComando('0028','OK');
   VL_Mensagem.AddTag('0038',VL_Consulta.FieldByName('S_TIPO').AsString);
  end;

  EnviarCliente(VL_Mensagem,VP_AContext);

finally
  VL_Mensagem.Free;
  VL_Consulta.Free;
end;


end;

function TDComunicador.comando000A(VP_Mensagem: TMensagem;VP_AContext:TIdContext): Integer;
var
 VL_Dados:String;
 VL_Transacao : string;
begin
Result:=0;
VL_Dados:='';
VL_Transacao:='';
 //testa conexão
 if TTConexao(VP_AContext.Data).Status<>csLogado then
 begin
   VP_Mensagem.Limpar;
   VP_Mensagem.AddComando('0026','35');
   EnviarCliente(VP_Mensagem,VP_AContext);
   exit;
 end;


 // criar transacao
 // consultar com os modulos os menus solicitado e compativel com caixa


  //CRIAR FUNCÇÃO QUE RETORNA MENU COMPATIVEL





  EnviarCliente(VP_Mensagem,VP_AContext);


end;

function TDComunicador.comando0018(VP_Mensagem: TMensagem;VP_AContext: TIdContext): Integer;
var
 VL_Mensagem : TMensagem;
 VL_DadosMenu : string;
begin
  Result := 0;
  VL_DadosMenu:='';
  VL_Mensagem := TMensagem.Create;
  try
    if TTConexao(VP_AContext.Data).Status<>csLogado then
    begin
     VP_Mensagem.Limpar;
     VP_Mensagem.AddComando('0026','35');
     EnviarCliente(VP_Mensagem,VP_AContext);
     exit;
    end;
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0018','');

    //VP_Mensagem.GetTag(VL_DadosMenu);
              {
    case VL_DadosMenu of
      '0019' :


    end;
    if Length(VL_TextoMenu)>0 then
    begin
     VL_Mensagem.AddTag('0019',VL_DadosMenu);
    end;

    VP_Mensagem.GetTag('0019',VL_DadosMenu);
    if Length(VL_TextoMenu)>0 then
    begin
     VL_Mensagem.AddTag('0019',VL_DadosMenu);
    end;

    EnviarCliente(VL_Mensagem,VP_AContext);
                     }
  finally
    VL_Mensagem.Free;
  end;


end;
function TDComunicador.comando0039(VP_Mensagem: TMensagem;VP_AContext: TIdContext): Integer;
var
 VL_Mensagem : TMensagem;
 VL_Tabela : TRxMemoryData;
 VL_TLoja : TZQuery;
 VL_Tag : AnsiString;
 VL_Permissao : String;
begin
  Result := 0;
  VL_Mensagem := TMensagem.Create;
  VL_Tabela:= TRxMemoryData.Create(nil);
  VL_TLoja := TZQuery.Create(DComunicador);
  VL_TLoja.Connection := DNucleo.ZConexao;
  VL_Tag:='';
  VL_Permissao:='U';
  try
    if TTConexao(VP_AContext.Data).Status<>csLogado then
    begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('0026','35');
     EnviarCliente(VL_Mensagem,VP_AContext);
     exit;
    end;
    //verifica permissao
    VP_Mensagem.GetTag('0037',VL_Tag);
    if Length(VL_Tag)=0 then
    begin
      VL_Mensagem.Limpar;
      VL_Mensagem.AddComando('0026','28');
      EnviarCliente(VL_Mensagem,VP_AContext);
      Exit;
    end;
    VL_Permissao:=VL_Tag;
    If VL_Permissao='U' then
    begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('0026','45');
     EnviarCliente(VL_Mensagem,VP_AContext);
     Exit;
    end;
    VP_Mensagem.GetTag('003A',VL_Tag);
    if Length(VL_Tag)=0 then
    begin
      VL_Mensagem.Limpar;
      VL_Mensagem.AddComando('0026','28');
      EnviarCliente(VL_Mensagem,VP_AContext);
      Exit;
    end;
    F.StrToRxMemData(VL_Tag,VL_Tabela);
    VL_Tabela.Open;
    VL_Tabela.First;
    while not VL_Tabela.eof do
    begin
      if VL_Tabela.FieldByName('ID').AsInteger=0 then
      begin
       VL_TLoja.Close;
       VL_TLoja.SQL.Text:='SELECT * FROM LOJA WHERE CNPJ='''+VL_Tabela.FieldByName('CNPJ').AsString+'''';
       VL_TLoja.Open;
       if VL_TLoja.RecordCount>0 then
       begin
        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('0026','43');
        EnviarCliente(VL_Mensagem,VP_AContext);
        Exit;
       end;
       VL_TLoja.Close;
       VL_TLoja.SQL.Text:='INSERT INTO LOJA(CNPJ,RAZAO,FANTASIA)VALUES('''+
                                  VL_Tabela.FieldByName('CNPJ').AsString+''','''+
                                  VL_Tabela.FieldByName('RAZAO').AsString+''','''+
                                  VL_Tabela.FieldByName('FANTASIA').AsString+''')';
       VL_TLoja.ExecSQL;
       VL_TLoja.Close;
       VL_TLoja.SQL.Text:='SELECT * FROM LOJA WHERE CNPJ='''+VL_Tabela.FieldByName('CNPJ').AsString+'''';
       VL_TLoja.Open;
       if VL_TLoja.RecordCount=0 then
       begin
        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('0026','44');
        EnviarCliente(VL_Mensagem,VP_AContext);
        Exit;
       end;
       VL_Mensagem.Limpar;
       VL_Mensagem.AddComando('003B','');
       VL_Mensagem.AddTag('0036',VL_TLoja.FieldByName('ID').AsString);
       EnviarCliente(VL_Mensagem,VP_AContext);
       Exit;
      end;
      VL_Tabela.Next;
    end;
  finally
    DNucleo.ZConexao.Commit;
    VL_Mensagem.Free;
    VL_Tabela.Free;
    VL_TLoja.Free;
  end;
end;
function TDComunicador.comando003C(VP_Mensagem: TMensagem;VP_AContext: TIdContext): Integer;
var
 VL_Mensagem : TMensagem;
 VL_TLoja : TZQuery;
 VL_Tag : AnsiString;
 VL_Dados : AnsiString;
 VL_TipoPesquisa : AnsiString;
begin
 Result:=0;
 VL_Mensagem := TMensagem.Create;
 VL_TLoja := TZQuery.Create(DComunicador);
 VL_TLoja.Connection := DNucleo.ZConexao;
 VL_Tag:='';
 VL_Dados:='0';
 VL_TipoPesquisa:='';
 try
   if TTConexao(VP_AContext.Data).Status<>csLogado then
   begin
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0026','35');
    EnviarCliente(VL_Mensagem,VP_AContext);
    Exit;
   end;
   VP_Mensagem.GetTag('0040',VL_Tag);
   if Length(VL_Tag)=0 then
   begin
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0026','28');
    EnviarCliente(VL_Mensagem,VP_AContext);
    Exit;
   end;
   VL_TipoPesquisa:=VL_Tag;
   VP_Mensagem.GetTag('003D',VL_Tag);
   if Length(VL_Tag)=0 then
   begin
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0026','28');
    EnviarCliente(VL_Mensagem,VP_AContext);
    Exit;
   end;
   VL_Dados:= VL_Tag;

   //pesquisa por ID
   if VL_TipoPesquisa='ID' then
   begin
    VL_TLoja.Close;
    VL_TLoja.SQL.Text:='SELECT * FROM LOJA WHERE ((ID='+VL_Dados+') or ('+VL_Dados+' is not null) and (('+VL_Dados+' is null) or ('+VL_Dados+'=0)))';
    VL_TLoja.Open;

    VL_Tag:=F.ZQueryToStrRxMemData(VL_TLoja);

    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('003E','');
    VL_Mensagem.AddTag('0038',VL_Tag);
    EnviarCliente(VL_Mensagem,VP_AContext);
   end;

 finally
    VL_Mensagem.Free;
    VL_TLoja.Free;
 end;
end;
function TDComunicador.comando003F(VP_Mensagem: TMensagem;VP_AContext: TIdContext): Integer;
var
 VL_Mensagem : TMensagem;
 VL_Loja : TZQuery;
 VL_Tabela : TRxMemoryData;
 VL_Tag : AnsiString;
 VL_ID  : Int64;
 VL_Permissao : String;
begin
 Result:=0;
 VL_Mensagem := TMensagem.Create;
 VL_Loja := TZQuery.Create(DComunicador);
 VL_Loja.Connection := DNucleo.ZConexao;
 VL_Tabela := TRxMemoryData.Create(nil);
 VL_Tag:='';
 VL_ID:=0;
 VL_Permissao:='U';
 try
   if TTConexao(VP_AContext.Data).Status<>csLogado then
   begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('0026','35');
     EnviarCliente(VL_Mensagem,VP_AContext);
     exit;
   end;
   VP_Mensagem.GetTag('003A',VL_Tag);
   if Length(VL_Tag)=0 then
   begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('0026','28');
     EnviarCliente(VL_Mensagem,VP_AContext);
     Exit;
   end;
   F.StrToRxMemData(VL_Tag,VL_Tabela);
   VL_Tabela.Open;

   VP_Mensagem.GetTag('003D',VL_Tag);
   if Length(VL_Tag)=0 then
   begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('0026','28');
     EnviarCliente(VL_Mensagem,VP_AContext);
     Exit;
   end;
   VL_ID:=StrToInt(VL_Tag);
   if VL_ID=0 then
   begin
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0026','47');
    EnviarCliente(VL_Mensagem,VP_AContext);
    Exit;
   end;
   VP_Mensagem.GetTag('0037',VL_Tag);
   if Length(VL_Tag)=0 then
   begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('0026','28');
     EnviarCliente(VL_Mensagem,VP_AContext);
     Exit;
   end;
   VL_Permissao:=VL_Tag;
   If VL_Permissao='U' then
   begin
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0026','45');
    EnviarCliente(VL_Mensagem,VP_AContext);
    Exit;
   end;
   VL_Loja.close;
   VL_Loja.SQL.Text:='SELECT * FROM LOJA WHERE ID='+INTTOSTR(VL_ID);
   VL_Loja.Open;

   if VL_Loja.RecordCount=0 then
   begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('0026','48');
     EnviarCliente(VL_Mensagem,VP_AContext);
     Exit;
   end;
   if VL_Tabela.Locate('ID',VL_ID,[]) then
   BEGIN
    if ((VL_Tabela.FieldByName('ID').AsInteger<>VL_Loja.FieldByName('ID').AsInteger)OR
       (VL_Tabela.FieldByName('CNPJ').AsString<>VL_Loja.FieldByName('CNPJ').AsString))then
    begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('0026','49');
     EnviarCliente(VL_Mensagem,VP_AContext);
     Exit;
    end;
    VL_Loja.Close;
    VL_Loja.SQL.Text:='UPDATE LOJA SET '+
                              'RAZAO='''+VL_Tabela.FieldByName('RAZAO').AsString+''','+
                              'FANTASIA='''+VL_Tabela.FieldByName('FANTASIA').AsString+''' WHERE '+
                              'ID='+IntToStr(VL_ID);
    VL_Loja.ExecSQL;
    VL_Loja.Close;
    VL_Loja.SQL.Text:='SELECT * FROM LOJA WHERE ID='+INTTOSTR(VL_ID);
    VL_Loja.Open;
    if VL_Loja.RecordCount=0 then
    begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('0026','46');
     EnviarCliente(VL_Mensagem,VP_AContext);
     Exit;
    end;
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0042','');
    EnviarCliente(VL_Mensagem,VP_AContext);
    Exit;
   end
   else
   begin
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0026','46');
    EnviarCliente(VL_Mensagem,VP_AContext);
    Exit;
   end;
 finally
    DNucleo.ZConexao.Commit;
    VL_Mensagem.Free;
    VL_Loja.Free;
    VL_Tabela.Free;
 end;
end;
function TDComunicador.comando0043(VP_Mensagem: TMensagem;VP_AContext: TIdContext): Integer;
var
 VL_Mensagem : TMensagem;
 VL_TPdv : TZQuery;
 VL_Tag : AnsiString;
 VL_Dados : AnsiString;
 VL_TipoPesquisa : AnsiString;
begin
 Result:=0;
 VL_Mensagem := TMensagem.Create;
 VL_TPdv := TZQuery.Create(DComunicador);
 VL_TPdv.Connection := DNucleo.ZConexao;
 VL_Tag:='';
 VL_Dados:='0';
 VL_TipoPesquisa:='';
 try
   if TTConexao(VP_AContext.Data).Status<>csLogado then
   begin
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0026','35');
    EnviarCliente(VL_Mensagem,VP_AContext);
    Exit;
   end;
   VP_Mensagem.GetTag('0040',VL_Tag);
   if Length(VL_Tag)=0 then
   begin
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0026','28');
    EnviarCliente(VL_Mensagem,VP_AContext);
    Exit;
   end;
   VL_TipoPesquisa:=VL_Tag;
   VP_Mensagem.GetTag('003D',VL_Tag);
   if Length(VL_Tag)=0 then
   begin
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0026','28');
    EnviarCliente(VL_Mensagem,VP_AContext);
    Exit;
   end;

   VL_Dados:= VL_Tag;

   //pesquisa por ID
   if VL_TipoPesquisa='ID' then
   begin
    VL_TPdv.Close;
    VL_TPdv.SQL.Text:='SELECT * FROM PDV WHERE ((ID='+VL_Dados+') or ('+VL_Dados+' is not null) and (('+VL_Dados+' is null) or ('+VL_Dados+'=0)))';
    VL_TPdv.Open;

    VL_Tag:=F.ZQueryToStrRxMemData(VL_TPdv);

    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('003E','');
    VL_Mensagem.AddTag('0038',VL_Tag);
    EnviarCliente(VL_Mensagem,VP_AContext);
   end;

 finally
    VL_Mensagem.Free;
    VL_TPdv.Free;
 end;

end;
function TDComunicador.comando0044(VP_Mensagem: TMensagem;VP_AContext: TIdContext): Integer;
var
 VL_Mensagem :TMensagem;
 VL_Tabela : TRxMemoryData;
 VL_TPdv : TZQuery;
 VL_Permissao : string;
 VL_Tag : AnsiString;
begin
 Result:=0;
 VL_Mensagem := TMensagem.Create;
 VL_Tabela := TRxMemoryData.Create(nil);
 VL_TPdv := TZQuery.Create(DComunicador);
 VL_TPdv.Connection := DNucleo.ZConexao;
 VL_Permissao:='U';
 VL_Tag:='';
 try
   if TTConexao(VP_AContext.Data).Status<>csLogado then
   begin
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0026','35');
    EnviarCliente(VL_Mensagem,VP_AContext);
    Exit;
   end;
   //verifica permissao
   VP_Mensagem.GetTag('0037',VL_Tag);
   if Length(VL_Tag)=0 then
   begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('0026','28');
     EnviarCliente(VL_Mensagem,VP_AContext);
     Exit;
   end;
   VL_Permissao:=VL_Tag;
   If VL_Permissao='U' then
   begin
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0026','45');
    EnviarCliente(VL_Mensagem,VP_AContext);
    Exit;
   end;
   VP_Mensagem.GetTag('003A',VL_Tag);
   if Length(VL_Tag)=0 then
   begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('0026','28');
     EnviarCliente(VL_Mensagem,VP_AContext);
     Exit;
   end;
   f.StrToRxMemData(VL_Tag,VL_Tabela);
   VL_Tabela.open;
   VL_Tabela.First;
   while not VL_Tabela.EOF do
   begin
    if VL_Tabela.FieldByName('ID').AsInteger=0 then
    begin
     //verifica se o pdv ja foi cadastrado
     VL_TPdv.Close;
     VL_TPdv.SQL.Text:='SELECT FIRST 1 ID FROM PDV WHERE CHAVE='''+VL_Tabela.FieldByName('CHAVE').AsString+'''';
     VL_TPdv.Open;
     if VL_TPdv.RecordCount>0then
     begin
      VL_Mensagem.Limpar;
      VL_Mensagem.AddComando('0026','43');
      EnviarCliente(VL_Mensagem,VP_AContext);
      Exit;
     end;
     VL_TPdv.Close;
     VL_TPdv.SQL.Text:='INSERT INTO PDV(LOJA_ID,DESCRICAO,IP,CHAVE)VALUES('''+
                                VL_Tabela.FieldByName('LOJA_ID').AsString+''','''+
                                VL_Tabela.FieldByName('DESCRICAO').AsString+''','''+
                                VL_Tabela.FieldByName('IP').AsString+''','''+
                                VL_Tabela.FieldByName('CHAVE').AsString+''')';
     VL_TPdv.ExecSQL;
     VL_TPdv.Close;
     VL_TPdv.SQL.Text:='SELECT * FROM PDV WHERE CHAVE='''+VL_Tabela.FieldByName('CHAVE').AsString+'''';
     VL_TPdv.Open;
     if VL_TPdv.RecordCount=0 then
     begin
      VL_Mensagem.Limpar;
      VL_Mensagem.AddComando('0026','44');
      EnviarCliente(VL_Mensagem,VP_AContext);
      Exit;
     end
     else
     begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('003B','');
     VL_Mensagem.AddTag('0036',VL_TPdv.FieldByName('ID').AsString);
     EnviarCliente(VL_Mensagem,VP_AContext);
     exit;
     end;
    end;
    VL_Tabela.Next;
   end;
 finally
    DNucleo.ZConexao.Commit;
    VL_Mensagem.Free;
    VL_Tabela.Free;
    VL_TPdv.Free;
 end;

end;
function TDComunicador.comando0045(VP_Mensagem: TMensagem;VP_AContext: TIdContext): Integer;
var
 VL_Mensagem : TMensagem;
 VL_TPdv : TZQuery;
 VL_Tag : AnsiString;
begin
 Result:=0;
 VL_Mensagem := TMensagem.Create;
 VL_TPdv := TZQuery.Create(DComunicador);
 VL_TPdv.Connection := DNucleo.ZConexao;
 VL_Tag:='';
 try
    if TTConexao(VP_AContext.Data).Status <> csLogado then
    begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('0026','35');
     EnviarCliente(VL_Mensagem,VP_AContext);
     Exit;
    end;
    VP_Mensagem.GetTag('0041',VL_Tag);
    if Length(VL_Tag)=0 then
    begin
     result:=47;
     Exit;
    end;
    VL_TPdv.Close;
    VL_TPdv.SQL.Text:='SELECT FIRST 1 ID FROM PDV WHERE CHAVE='''+VL_Tag+'''';
    VL_TPdv.Open;
    if VL_TPdv.RecordCount>0then
    begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('0026','43');
     EnviarCliente(VL_Mensagem,VP_AContext);
     Exit;
    end;
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0046','ok');
    EnviarCliente(VL_Mensagem,VP_AContext);
 finally
    VL_Mensagem.Free;
 end;

end;
function TDComunicador.comando004B(VP_Mensagem: TMensagem;VP_AContext: TIdContext): Integer;
var
 VL_Mensagem :TMensagem;
 VL_Tabela : TRxMemoryData;
 VL_TPdv : TZQuery;
 VL_Permissao : string;
 VL_Tag : AnsiString;
 VL_ID : Int64;
begin
 Result:=0;
 VL_Mensagem := TMensagem.Create;
 VL_Tabela := TRxMemoryData.Create(nil);
 VL_TPdv := TZQuery.Create(DComunicador);
 VL_TPdv.Connection := DNucleo.ZConexao;
 VL_Permissao:='U';
 VL_Tag:='';
 VL_ID:=0;
 try
   if TTConexao(VP_AContext.Data).Status<>csLogado then
   begin
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0026','35');
    EnviarCliente(VL_Mensagem,VP_AContext);
    Exit;
   end;
   //verifica parametros
   VP_Mensagem.GetTag('003D',VL_Tag);
   if Length(VL_Tag)=0 then
   begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('0026','28');
     EnviarCliente(VL_Mensagem,VP_AContext);
     Exit;
   end;
   VL_ID:=StrToInt(VL_Tag);
   if VL_ID=0 then
   begin
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0026','47');
    EnviarCliente(VL_Mensagem,VP_AContext);
    Exit;
   end;
   //verifica permissao
   VP_Mensagem.GetTag('0037',VL_Tag);
   if Length(VL_Tag)=0 then
   begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('0026','28');
     EnviarCliente(VL_Mensagem,VP_AContext);
     Exit;
   end;
   VL_Permissao:=VL_Tag;
   If VL_Permissao='U' then
   begin
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0026','45');
    EnviarCliente(VL_Mensagem,VP_AContext);
    Exit;
   end;
   VP_Mensagem.GetTag('003A',VL_Tag);
   if Length(VL_Tag)=0 then
   begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('0026','28');
     EnviarCliente(VL_Mensagem,VP_AContext);
     Exit;
   end;
   F.StrToRxMemData(VL_Tag,VL_Tabela);
   VL_Tabela.Open;
   //verifica se existe o id pra amodificação
   VL_TPdv.close;
   VL_TPdv.SQL.Text:='SELECT * FROM PDV WHERE ID='+INTTOSTR(VL_ID);
   VL_TPdv.Open;

   if VL_TPdv.RecordCount=0 then
   begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('0026','48');
     EnviarCliente(VL_Mensagem,VP_AContext);
     Exit;
   end;
   if VL_Tabela.Locate('ID',VL_ID,[]) then
   BEGIN
    if ((VL_Tabela.FieldByName('ID').AsInteger<>VL_TPdv.FieldByName('ID').AsInteger)OR
       ((VL_Tabela.FieldByName('CHAVE').AsString<>VL_TPdv.FieldByName('CHAVE').AsString) AND
       (VL_TPdv.FieldByName('CHAVE').AsString<>'')))then
    begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('0026','49');
     EnviarCliente(VL_Mensagem,VP_AContext);
     Exit;
    end;

    VL_TPdv.Close;
    VL_TPdv.SQL.Text:='UPDATE PDV SET '+
                              'LOJA_ID='''+VL_Tabela.FieldByName('LOJA_ID').AsString+''','+
                              'DESCRICAO='''+VL_Tabela.FieldByName('DESCRICAO').AsString+''','+
                              'IP='''+VL_Tabela.FieldByName('IP').AsString+''','+
                              'CHAVE='''+VL_Tabela.FieldByName('CHAVE').AsString+''' WHERE '+
                              'ID='+IntToStr(VL_ID);
    VL_TPdv.ExecSQL;
    VL_TPdv.Close;
    VL_TPdv.SQL.Text:='SELECT * FROM PDV WHERE ID='+INTTOSTR(VL_ID);
    VL_TPdv.Open;
    if VL_TPdv.RecordCount=0 then
    begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('0026','46');
     EnviarCliente(VL_Mensagem,VP_AContext);
     Exit;
    end;
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0042','');
    EnviarCliente(VL_Mensagem,VP_AContext);
    Exit;
   end
   else
   begin
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0026','46');
    EnviarCliente(VL_Mensagem,VP_AContext);
    Exit;
   end;

 finally
    DNucleo.ZConexao.Commit;
    VL_Mensagem.Free;
    VL_Tabela.Free;
    VL_TPdv.Free;
 end;

end;
function TDComunicador.comando0053(VP_Mensagem: TMensagem;VP_AContext: TIdContext): Integer;
var
 VL_Mensagem :TMensagem;
 VL_Tabela : TRxMemoryData;
 VL_TPinPad : TZQuery;
 VL_Permissao : string;
 VL_Tag : AnsiString;
begin
 Result:=0;
 VL_Mensagem := TMensagem.Create;
 VL_Tabela := TRxMemoryData.Create(nil);
 VL_TPinPad := TZQuery.Create(DComunicador);
 VL_TPinPad.Connection := DNucleo.ZConexao;
 VL_Permissao:='U';
 VL_Tag:='';
 try
   if TTConexao(VP_AContext.Data).Status<>csLogado then
   begin
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0026','35');
    EnviarCliente(VL_Mensagem,VP_AContext);
    Exit;
   end;
   //verifica permissao
   VP_Mensagem.GetTag('0037',VL_Tag);
   if Length(VL_Tag)=0 then
   begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('0026','28');
     EnviarCliente(VL_Mensagem,VP_AContext);
     Exit;
   end;
   VL_Permissao:=VL_Tag;
   If VL_Permissao='U' then
   begin
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0026','45');
    EnviarCliente(VL_Mensagem,VP_AContext);
    Exit;
   end;
   VP_Mensagem.GetTag('003A',VL_Tag);
   if Length(VL_Tag)=0 then
   begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('0026','28');
     EnviarCliente(VL_Mensagem,VP_AContext);
     Exit;
   end;
   f.StrToRxMemData(VL_Tag,VL_Tabela);
   VL_Tabela.open;
   VL_Tabela.First;
   while not VL_Tabela.EOF do
   begin
    if VL_Tabela.FieldByName('ID').AsInteger=0 then
    begin
     VL_TPinPad.Close;
     VL_TPinPad.SQL.Text:='INSERT INTO PINPAD(FABRICANTE_MODELO)VALUES('''+
                                VL_Tabela.FieldByName('FABRICANTE_MODELO').AsString+''')';
     VL_TPinPad.ExecSQL;
     VL_TPinPad.Close;
     VL_TPinPad.SQL.Text:='SELECT * FROM PINPAD WHERE FABRICANTE_MODELO='''+VL_Tabela.FieldByName('FABRICANTE_MODELO').AsString+'''';
     VL_TPinPad.Open;
     if VL_TPinPad.RecordCount=0 then
     begin
      VL_Mensagem.Limpar;
      VL_Mensagem.AddComando('0026','44');
      EnviarCliente(VL_Mensagem,VP_AContext);
      Exit;
     end
     else
     begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('003B','');
     VL_Mensagem.AddTag('0036',VL_TPinPad.FieldByName('ID').AsString);
     EnviarCliente(VL_Mensagem,VP_AContext);
     exit;
     end;
    end;
    VL_Tabela.Next;
   end;
 finally
    DNucleo.ZConexao.Commit;
    VL_Mensagem.Free;
    VL_Tabela.Free;
    VL_TPinPad.Free;
 end;

end;
function TDComunicador.comando0054(VP_Mensagem: TMensagem;VP_AContext: TIdContext): Integer;
var
 VL_Mensagem : TMensagem;
 VL_TPinPad : TZQuery;
 VL_Tag : AnsiString;
 VL_Dados : AnsiString;
 VL_TipoPesquisa : AnsiString;
begin
 Result:=0;
 VL_Mensagem := TMensagem.Create;
 VL_TPinPad := TZQuery.Create(DComunicador);
 VL_TPinPad.Connection := DNucleo.ZConexao;
 VL_Tag:='';
 VL_Dados:='0';
 VL_TipoPesquisa:='';
 try
   if TTConexao(VP_AContext.Data).Status<>csLogado then
   begin
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0026','35');
    EnviarCliente(VL_Mensagem,VP_AContext);
    Exit;
   end;
   VP_Mensagem.GetTag('0040',VL_Tag);
   if Length(VL_Tag)=0 then
   begin
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0026','28');
    EnviarCliente(VL_Mensagem,VP_AContext);
    Exit;
   end;
   VL_TipoPesquisa:=VL_Tag;
   VP_Mensagem.GetTag('003D',VL_Tag);
   if Length(VL_Tag)=0 then
   begin
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0026','28');
    EnviarCliente(VL_Mensagem,VP_AContext);
    Exit;
   end;

   VL_Dados:= VL_Tag;

   //pesquisa por ID
   if VL_TipoPesquisa='ID' then
   begin
    VL_TPinPad.Close;
    VL_TPinPad.SQL.Text:='SELECT * FROM PINPAD WHERE ((ID='+VL_Dados+') or ('+VL_Dados+' is not null) and (('+VL_Dados+' is null) or ('+VL_Dados+'=0)))';
    VL_TPinPad.Open;

    VL_Tag:=F.ZQueryToStrRxMemData(VL_TPinPad);

    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('003E','');
    VL_Mensagem.AddTag('0038',VL_Tag);
    EnviarCliente(VL_Mensagem,VP_AContext);
   end;

 finally
    VL_Mensagem.Free;
    VL_TPinPad.Free;
 end;
end;
function TDComunicador.comando0055(VP_Mensagem: TMensagem;VP_AContext: TIdContext): Integer;
var
 VL_Mensagem :TMensagem;
 VL_Tabela : TRxMemoryData;
 VL_TPinPad : TZQuery;
 VL_Permissao : string;
 VL_Tag : AnsiString;
 VL_ID : Int64;
begin
 Result:=0;
 VL_Mensagem := TMensagem.Create;
 VL_Tabela := TRxMemoryData.Create(nil);
 VL_TPinPad := TZQuery.Create(DComunicador);
 VL_TPinPad.Connection := DNucleo.ZConexao;
 VL_Permissao:='U';
 VL_Tag:='';
 VL_ID:=0;
 try
   if TTConexao(VP_AContext.Data).Status<>csLogado then
   begin
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0026','35');
    EnviarCliente(VL_Mensagem,VP_AContext);
    Exit;
   end;
   //verifica parametros
   VP_Mensagem.GetTag('003D',VL_Tag);
   if Length(VL_Tag)=0 then
   begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('0026','28');
     EnviarCliente(VL_Mensagem,VP_AContext);
     Exit;
   end;
   VL_ID:=StrToInt(VL_Tag);
   if VL_ID=0 then
   begin
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0026','47');
    EnviarCliente(VL_Mensagem,VP_AContext);
    Exit;
   end;
   //verifica permissao
   VP_Mensagem.GetTag('0037',VL_Tag);
   if Length(VL_Tag)=0 then
   begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('0026','28');
     EnviarCliente(VL_Mensagem,VP_AContext);
     Exit;
   end;
   VL_Permissao:=VL_Tag;
   If VL_Permissao='U' then
   begin
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0026','45');
    EnviarCliente(VL_Mensagem,VP_AContext);
    Exit;
   end;
   VP_Mensagem.GetTag('003A',VL_Tag);
   if Length(VL_Tag)=0 then
   begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('0026','28');
     EnviarCliente(VL_Mensagem,VP_AContext);
     Exit;
   end;
   F.StrToRxMemData(VL_Tag,VL_Tabela);
   VL_Tabela.Open;
   //verifica se existe o id pra amodificação
   VL_TPinPad.close;
   VL_TPinPad.SQL.Text:='SELECT * FROM PINPAD WHERE ID='+INTTOSTR(VL_ID);
   VL_TPinPad.Open;

   if VL_TPinPad.RecordCount=0 then
   begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('0026','48');
     EnviarCliente(VL_Mensagem,VP_AContext);
     Exit;
   end;
   if VL_Tabela.Locate('ID',VL_ID,[]) then
   BEGIN
    if (VL_Tabela.FieldByName('ID').AsInteger<>VL_TPinPad.FieldByName('ID').AsInteger)then
    begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('0026','49');
     EnviarCliente(VL_Mensagem,VP_AContext);
     Exit;
    end;

    VL_TPinPad.Close;
    VL_TPinPad.SQL.Text:='UPDATE PINPAD SET '+
                              'FABRICANTE_MODELO='''+VL_Tabela.FieldByName('FABRICANTE_MODELO').AsString+''''+
                              ' WHERE '+
                              'ID='+IntToStr(VL_ID);
    VL_TPinPad.ExecSQL;
    VL_TPinPad.Close;
    VL_TPinPad.SQL.Text:='SELECT * FROM PINPAD WHERE ID='+INTTOSTR(VL_ID);
    VL_TPinPad.Open;
    if VL_TPinPad.RecordCount=0 then
    begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('0026','46');
     EnviarCliente(VL_Mensagem,VP_AContext);
     Exit;
    end;
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0042','');
    EnviarCliente(VL_Mensagem,VP_AContext);
    Exit;
   end
   else
   begin
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0026','46');
    EnviarCliente(VL_Mensagem,VP_AContext);
    Exit;
   end;

 finally
    DNucleo.ZConexao.Commit;
    VL_Mensagem.Free;
    VL_Tabela.Free;
    VL_TPinPad.Free;
 end;

end;
function TDComunicador.comando0056(VP_Mensagem: TMensagem;VP_AContext: TIdContext): Integer;
var
 VL_Mensagem : TMensagem;
 VL_TConfigurador : TZQuery;
 VL_Tag : AnsiString;
 VL_Dados : AnsiString;
 VL_TipoPesquisa : AnsiString;
begin
 Result:=0;
 VL_Mensagem := TMensagem.Create;
 VL_TConfigurador := TZQuery.Create(DComunicador);
 VL_TConfigurador.Connection := DNucleo.ZConexao;
 VL_Tag:='';
 VL_Dados:='0';
 VL_TipoPesquisa:='';
 try
   if TTConexao(VP_AContext.Data).Status<>csLogado then
   begin
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0026','35');
    EnviarCliente(VL_Mensagem,VP_AContext);
    Exit;
   end;
   VP_Mensagem.GetTag('0040',VL_Tag);
   if Length(VL_Tag)=0 then
   begin
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0026','28');
    EnviarCliente(VL_Mensagem,VP_AContext);
    Exit;
   end;
   VL_TipoPesquisa:=VL_Tag;
   VP_Mensagem.GetTag('003D',VL_Tag);
   if Length(VL_Tag)=0 then
   begin
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0026','28');
    EnviarCliente(VL_Mensagem,VP_AContext);
    Exit;
   end;

   VL_Dados:= VL_Tag;

   //pesquisa por ID
   if VL_TipoPesquisa='ID' then
   begin
    VL_TConfigurador.Close;
    VL_TConfigurador.SQL.Text:='SELECT * FROM CONFIGURADOR WHERE ((ID='+VL_Dados+') or ('+VL_Dados+' is not null) and (('+VL_Dados+' is null) or ('+VL_Dados+'=0)))';
    VL_TConfigurador.Open;

    VL_Tag:=F.ZQueryToStrRxMemData(VL_TConfigurador);

    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('003E','');
    VL_Mensagem.AddTag('0038',VL_Tag);
    EnviarCliente(VL_Mensagem,VP_AContext);
   end;

 finally
    VL_Mensagem.Free;
    VL_TConfigurador.Free;
 end;

end;
function TDComunicador.comando0057(VP_Mensagem: TMensagem;VP_AContext: TIdContext): Integer;
var
 VL_Mensagem :TMensagem;
 VL_Tabela : TRxMemoryData;
 VL_TConfigurador : TZQuery;
 VL_Permissao : string;
 VL_Tag : AnsiString;
begin
 Result:=0;
 VL_Mensagem := TMensagem.Create;
 VL_Tabela := TRxMemoryData.Create(nil);
 VL_TConfigurador := TZQuery.Create(DComunicador);
 VL_TConfigurador.Connection := DNucleo.ZConexao;
 VL_Permissao:='U';
 VL_Tag:='';
 try
   if TTConexao(VP_AContext.Data).Status<>csLogado then
   begin
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0026','35');
    EnviarCliente(VL_Mensagem,VP_AContext);
    Exit;
   end;
   //verifica permissao
   VP_Mensagem.GetTag('0037',VL_Tag);
   if Length(VL_Tag)=0 then
   begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('0026','28');
     EnviarCliente(VL_Mensagem,VP_AContext);
     Exit;
   end;
   VL_Permissao:=VL_Tag;
   If VL_Permissao<>'C' then
   begin
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0026','45');
    EnviarCliente(VL_Mensagem,VP_AContext);
    Exit;
   end;
   VP_Mensagem.GetTag('003A',VL_Tag);
   if Length(VL_Tag)=0 then
   begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('0026','28');
     EnviarCliente(VL_Mensagem,VP_AContext);
     Exit;
   end;
   f.StrToRxMemData(VL_Tag,VL_Tabela);
   VL_Tabela.open;
   VL_Tabela.First;
   while not VL_Tabela.EOF do
   begin
    if VL_Tabela.FieldByName('ID').AsInteger=0 then
    begin
     //verifica se o configurador ja foi cadastrado
     VL_TConfigurador.Close;
     VL_TConfigurador.SQL.Text:='SELECT FIRST 1 ID FROM CONFIGURADOR WHERE CHAVE='''+VL_Tabela.FieldByName('CHAVE').AsString+'''';
     VL_TConfigurador.Open;
     if VL_TConfigurador.RecordCount>0then
     begin
      VL_Mensagem.Limpar;
      VL_Mensagem.AddComando('0026','43');
      EnviarCliente(VL_Mensagem,VP_AContext);
      Exit;
     end;
     VL_TConfigurador.Close;
     VL_TConfigurador.SQL.Text:='INSERT INTO CONFIGURADOR(DESCRICAO,IP,CHAVE,SENHA_CONFIGURADOR,'+
                                'SENHA_ADMINISTRADOR,SENHA_USUARIO)VALUES('''+
                                VL_Tabela.FieldByName('DESCRICAO').AsString+''','''+
                                VL_Tabela.FieldByName('IP').AsString+''','''+
                                VL_Tabela.FieldByName('CHAVE').AsString+''','''+
                                VL_Tabela.FieldByName('SENHA_CONFIGURADOR').AsString+''','''+
                                VL_Tabela.FieldByName('SENHA_ADMINISTRADOR').AsString+''','''+
                                VL_Tabela.FieldByName('SENHA_USUARIO').AsString+''')';

     VL_TConfigurador.ExecSQL;
     VL_TConfigurador.Close;
     VL_TConfigurador.SQL.Text:='SELECT * FROM CONFIGURADOR WHERE CHAVE='''+VL_Tabela.FieldByName('CHAVE').AsString+'''';
     VL_TConfigurador.Open;
     if VL_TConfigurador.RecordCount=0 then
     begin
      VL_Mensagem.Limpar;
      VL_Mensagem.AddComando('0026','44');
      EnviarCliente(VL_Mensagem,VP_AContext);
      Exit;
     end
     else
     begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('003B','');
     VL_Mensagem.AddTag('0036',VL_TConfigurador.FieldByName('ID').AsString);
     EnviarCliente(VL_Mensagem,VP_AContext);
     exit;
     end;
    end;
    VL_Tabela.Next;
   end;
 finally
    DNucleo.ZConexao.Commit;
    VL_Mensagem.Free;
    VL_Tabela.Free;
    VL_TConfigurador.Free;
 end;


end;
function TDComunicador.comando0058(VP_Mensagem: TMensagem;VP_AContext: TIdContext): Integer;
var
 VL_Mensagem :TMensagem;
 VL_Tabela : TRxMemoryData;
 VL_TConfigurador : TZQuery;
 VL_Permissao : string;
 VL_Tag : AnsiString;
 VL_ID : Int64;
begin
 Result:=0;
 VL_Mensagem := TMensagem.Create;
 VL_Tabela := TRxMemoryData.Create(nil);
 VL_TConfigurador := TZQuery.Create(DComunicador);
 VL_TConfigurador.Connection := DNucleo.ZConexao;
 VL_Permissao:='U';
 VL_Tag:='';
 VL_ID:=0;
 try
   if TTConexao(VP_AContext.Data).Status<>csLogado then
   begin
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0026','35');
    EnviarCliente(VL_Mensagem,VP_AContext);
    Exit;
   end;
   //verifica parametros
   VP_Mensagem.GetTag('003D',VL_Tag);
   if Length(VL_Tag)=0 then
   begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('0026','28');
     EnviarCliente(VL_Mensagem,VP_AContext);
     Exit;
   end;
   VL_ID:=StrToInt(VL_Tag);
   if VL_ID=0 then
   begin
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0026','47');
    EnviarCliente(VL_Mensagem,VP_AContext);
    Exit;
   end;
   //verifica permissao
   VP_Mensagem.GetTag('0037',VL_Tag);
   if Length(VL_Tag)=0 then
   begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('0026','28');
     EnviarCliente(VL_Mensagem,VP_AContext);
     Exit;
   end;
   VL_Permissao:=VL_Tag;
   If VL_Permissao<>'C' then
   begin
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0026','45');
    EnviarCliente(VL_Mensagem,VP_AContext);
    Exit;
   end;
   VP_Mensagem.GetTag('003A',VL_Tag);
   if Length(VL_Tag)=0 then
   begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('0026','28');
     EnviarCliente(VL_Mensagem,VP_AContext);
     Exit;
   end;
   F.StrToRxMemData(VL_Tag,VL_Tabela);
   VL_Tabela.Open;
   //verifica se existe o id pra modificação
   VL_TConfigurador.close;
   VL_TConfigurador.SQL.Text:='SELECT * FROM CONFIGURADOR WHERE ID='+INTTOSTR(VL_ID);
   VL_TConfigurador.Open;

   if VL_TConfigurador.RecordCount=0 then
   begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('0026','48');
     EnviarCliente(VL_Mensagem,VP_AContext);
     Exit;
   end;
   if VL_Tabela.Locate('ID',VL_ID,[]) then
   BEGIN
    if ((VL_Tabela.FieldByName('ID').AsInteger<>VL_TConfigurador.FieldByName('ID').AsInteger)OR
       ((VL_Tabela.FieldByName('CHAVE').AsString<>VL_TConfigurador.FieldByName('CHAVE').AsString) AND
       (VL_TConfigurador.FieldByName('CHAVE').AsString<>'')))then
    begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('0026','49');
     EnviarCliente(VL_Mensagem,VP_AContext);
     Exit;
    end;

    VL_TConfigurador.Close;
    VL_TConfigurador.SQL.Text:='UPDATE CONFIGURADOR SET '+
                              'DESCRICAO='''+VL_Tabela.FieldByName('DESCRICAO').AsString+''','+
                              'IP='''+VL_Tabela.FieldByName('IP').AsString+''','+
                              'CHAVE='''+VL_Tabela.FieldByName('CHAVE').AsString+''','+
                              'SENHA_CONFIGURADOR='''+VL_Tabela.FieldByName('SENHA_CONFIGURADOR').AsString+''','+
                              'SENHA_ADMINISTRADOR='''+VL_Tabela.FieldByName('SENHA_ADMINISTRADOR').AsString+''','+
                              'SENHA_USUARIO='''+VL_Tabela.FieldByName('SENHA_USUARIO').AsString+''' WHERE '+
                              'ID='+IntToStr(VL_ID);
    VL_TConfigurador.ExecSQL;
    VL_TConfigurador.Close;
    VL_TConfigurador.SQL.Text:='SELECT * FROM CONFIGURADOR WHERE ID='+INTTOSTR(VL_ID);
    VL_TConfigurador.Open;
    if VL_TConfigurador.RecordCount=0 then
    begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('0026','46');
     EnviarCliente(VL_Mensagem,VP_AContext);
     Exit;
    end;
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0042','');
    EnviarCliente(VL_Mensagem,VP_AContext);
    Exit;
   end
   else
   begin
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0026','46');
    EnviarCliente(VL_Mensagem,VP_AContext);
    Exit;
   end;

 finally
    DNucleo.ZConexao.Commit;
    VL_Mensagem.Free;
    VL_Tabela.Free;
    VL_TConfigurador.Free;
 end;


end;
function TDComunicador.comando0059(VP_Mensagem: TMensagem;VP_AContext: TIdContext): Integer;
var
 VL_Mensagem : TMensagem;
 VL_TConfigurador : TZQuery;
 VL_Tag : AnsiString;
begin
 Result:=0;
 VL_Mensagem := TMensagem.Create;
 VL_TConfigurador := TZQuery.Create(DComunicador);
 VL_TConfigurador.Connection := DNucleo.ZConexao;
 VL_Tag:='';
 try
    if TTConexao(VP_AContext.Data).Status <> csLogado then
    begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('0026','35');
     EnviarCliente(VL_Mensagem,VP_AContext);
     Exit;
    end;
    VP_Mensagem.GetTag('0041',VL_Tag);
    if Length(VL_Tag)=0 then
    begin
     result:=47;
     Exit;
    end;
    VL_TConfigurador.Close;
    VL_TConfigurador.SQL.Text:='SELECT FIRST 1 ID FROM CONFIGURADOR WHERE CHAVE='''+VL_Tag+'''';
    VL_TConfigurador.Open;
    if VL_TConfigurador.RecordCount>0then
    begin
     VL_Mensagem.Limpar;
     VL_Mensagem.AddComando('0026','43');
     EnviarCliente(VL_Mensagem,VP_AContext);
     Exit;
    end;
    VL_Mensagem.Limpar;
    VL_Mensagem.AddComando('0046','ok');
    EnviarCliente(VL_Mensagem,VP_AContext);
 finally
    VL_Mensagem.Free;
 end;


end;

{$ENDIF CLIENTE}

end.

