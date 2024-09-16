unit lib;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, def, funcoes, comunicadorVBI, vbi;

type

  { TDVbiLib }

  TDVbiLib = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
  public
    V_ArquivoLog: ansistring;
    V_Comunicador: TDComunicadorVBI;
  end;

function inicializar(var VO_VbiLib: Pointer; VP_ArquivoLog: PChar): integer; cdecl;
function finalizar(VP_VbiLib: Pointer): integer; cdecl;
procedure alterarnivellog(VP_Nivel: integer); cdecl;
function solicitacao(VP_VbiLib: Pointer; VP_Dados: PChar; var VO_Retorno: PChar): integer; cdecl;

function solicitarMenu(VP_VbiLib: Pointer; VP_MensagemRecebida: TMensagem; var VO_MensagemEnviada: TMensagem): integer;
function vendaCartao(VP_VbiLib: Pointer; VP_MensagemRecebida: TMensagem; var VO_MensagemEnviada: TMensagem): integer;

implementation

{$R *.lfm}

function inicializar(var VO_VbiLib: Pointer; VP_ArquivoLog: PChar): integer; cdecl;
var
  VL_VbiLib: TDVbiLib;
begin
  Result := 0;
  try

    VL_VbiLib := TDVbiLib.Create(nil);
    TDVbiLib(VL_VbiLib).V_ArquivoLog := VP_ArquivoLog;

    VO_VbiLib := Pointer(VL_VbiLib);

  except
    on e: Exception do
    begin
      Result := 1;
      GravaLog(TDVbiLib(VL_VbiLib).V_ArquivoLog, 0, '', 'vbi_lib', '220820241358', 'Erro de excecao no inicializar ' + e.ClassName + '/' + e.Message, '', 1, 1);
    end;
  end;
end;

function finalizar(VP_VbiLib: Pointer): integer; cdecl;
begin
  Result := 0;
  try
    TDVbiLib(VP_VbiLib).Free;
    VP_VbiLib := nil;
  except
    on e: Exception do
    begin
      Result := 1;
      GravaLog(TDVbiLib(VP_VbiLib).V_ArquivoLog, 0, '', 'vbi_lib', '220820241359', 'Erro no finalizar ' + e.ClassName + '/' + e.Message, '', 1, 1);
    end;
  end;
end;

function solicitacao(VP_VbiLib: Pointer; VP_Dados: PChar; var VO_Retorno: PChar): integer; cdecl;
var
  VL_MensagemEnviadas, VL_MensagemRecebidas: TMensagem;
begin
  Result := 0;
  VL_MensagemRecebidas := TMensagem.Create;
  VL_MensagemEnviadas := TMensagem.Create;
  try
    try
      Result := VL_MensagemRecebidas.CarregaTags(VP_Dados);

      if Result <> 0 then
      begin
        GravaLog(TDVbiLib(VP_VbiLib).V_ArquivoLog, 0, '', 'vbi_lib', '220820241459', 'Erro ao carregar os dados recebidos ', VP_Dados, 1, 1);
        Exit;
      end;

      case VL_MensagemRecebidas.Comando() of
        '012E': Result := solicitarMenu(VP_VbiLib, VL_MensagemRecebidas, VL_MensagemEnviadas);
        else
          Result := 101;
      end;

      if Result <> 0 then
      begin
        GravaLog(TDVbiLib(VP_VbiLib).V_ArquivoLog, 0, '', 'vbi_lib', '220820241500', 'Erro ao solicitar o comando do modulo ', VP_Dados, Result, 1);
        Exit;
      end;

      VO_Retorno := StrAlloc(Length(VL_MensagemEnviadas.TagsAsString) + 1);
      StrPCopy(VO_Retorno, VL_MensagemEnviadas.TagsAsString);

    except
      on e: Exception do
      begin
        Result := 1;
        GravaLog(TDVbiLib(VP_VbiLib).V_ArquivoLog, 0, '', 'vbi_lib', '220820241458', 'Erro de excecao no solicitacaoblocante ' + e.ClassName + '/' + e.Message, VP_Dados, 1, 1);
      end;
    end;
  finally
    VL_MensagemRecebidas.Free;
    VL_MensagemEnviadas.Free;
  end;
end;

procedure alterarnivellog(VP_Nivel: integer); cdecl;
begin
  F_NivelLog := VP_Nivel;
end;

function solicitarMenu(VP_VbiLib: Pointer; VP_MensagemRecebida: TMensagem; var VO_MensagemEnviada: TMensagem): integer;
var
  VL_VBI: TVBI;
  VL_Menu: TVBIMenuArray;
  VL_I: integer;
  VL_Retorno: TVBIRetorno;
begin
  Result := 0;
  VL_VBI := TVBI.Create(VP_MensagemRecebida.GetTagAsAstring('012A'), VP_MensagemRecebida.GetTagAsAstring('012B'), VP_MensagemRecebida.GetTagAsAstring('012C'),
    VP_MensagemRecebida.GetTagAsAstring('012D'));
  try
    TDVbiLib(VP_VbiLib).V_Comunicador.setConfig(VP_MensagemRecebida.GetTagAsAstring('0003'),VP_MensagemRecebida.GetTagAsInteger('0004'));

    VL_Retorno := VL_VBI.consultarMenu(TDVbiLib(VP_VbiLib).V_Comunicador,VL_Menu);

    if VL_Retorno.erro <> 0 then
    begin
      Result := VL_Retorno.erro;
      VO_MensagemEnviada.Limpar;
      VO_MensagemEnviada.AddComando('0026',IntToStr(Result));
      VO_MensagemEnviada.AddTag('004A',VL_Retorno.descricao);
      Exit;
    end;

    VO_MensagemEnviada.Limpar;
    VO_MensagemEnviada.AddComando('012E','R');

    for VL_I := 0 to Length(VL_Menu) - 1 do
    begin
      VO_MensagemEnviada.AddTag(VL_Menu[VL_I].tag, VL_Menu[VL_I].mensagem_cliente);
    end;

  finally
    VL_VBI.Free;
  end;
end;

function vendaCartao(VP_VbiLib: Pointer; VP_MensagemRecebida: TMensagem; var VO_MensagemEnviada: TMensagem): integer;
var
  VL_VBI: TVBI;
  VL_Retorno: TVBIRetorno;
begin
  Result := 0;
   VL_VBI := TVBI.Create(VP_MensagemRecebida.GetTagAsAstring('012A'), VP_MensagemRecebida.GetTagAsAstring('012B'), VP_MensagemRecebida.GetTagAsAstring('012C'),
    VP_MensagemRecebida.GetTagAsAstring('012D'));
  try
    TDVbiLib(VP_VbiLib).V_Comunicador.setConfig(VP_MensagemRecebida.GetTagAsAstring('0003'),VP_MensagemRecebida.GetTagAsInteger('0004'));

  finally
    VL_VBI.Free;
  end;
end;

{ TDVbiLib }

procedure TDVbiLib.DataModuleCreate(Sender: TObject);
begin
  V_Comunicador := TDComunicadorVbi.Create(nil);
end;

procedure TDVbiLib.DataModuleDestroy(Sender: TObject);
begin
 V_Comunicador.Free;
end;

end.

