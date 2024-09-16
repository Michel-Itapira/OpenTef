unit vbi;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, funcoes, comunicadorVbi;

type
  TVBIMenu = record
    tag: string;
    nome_vbi: string;
    mensagem_cliente: string;
  end;

  TVBIMenuArray = array of TVBIMenu;

  TVBI = class
  private
    function iniciarComunicacao(VP_Comunicador: TComunicadorVBI): TVBIRetorno;
    function formatarMenuEmTag(VP_Menu: TStringArray): TVBIMenuArray;
  public
    V_Estabelecimento: string;
    V_Loja: string;
    V_Terminal: string;
    V_Aplicacao: string;

    constructor Create(VP_Estabelecimento, VP_Loja, VP_Terminal, VP_Aplicacao: string);
    function consultarMenu(VP_Comunicador: TComunicadorVBI; var VO_Menu: TVBIMenuArray): TVBIRetorno;
  end;

const
  C_AplicacaoTelaPinpad: string = 'OpenTef';
  C_CAMPOS_VENDAS: TVBIMenuArray = (
    (Tag: '011E'; nome_vbi: 'Administracao Pendente'; mensagem_cliente: 'Vendas Pedentes'),
    (Tag: '011F'; nome_vbi: 'Administracao Extrato Transacao'; mensagem_cliente: 'Extrato'),
    (Tag: '0120'; nome_vbi: 'Administracao Cancelar'; mensagem_cliente: 'Cancelamento de Venda'),
    (Tag: '0121'; nome_vbi: 'Administracao Cartao Consultar'; mensagem_cliente: 'Consultar cartão'),
    (Tag: '0122'; nome_vbi: 'Administracao Cartao Resgatar'; mensagem_cliente: 'Resgatar'),
    (Tag: '0123'; nome_vbi: 'Administracao Manutencao Rede Consultar'; mensagem_cliente: 'Consultar Rede'),
    (Tag: '0124'; nome_vbi: 'Administracao Reimprimir'; mensagem_cliente: 'Reimprimir'),
    (Tag: '0125'; nome_vbi: 'Cartao Consultar Financiado'; mensagem_cliente: 'Consultar Financiado'),
    (Tag: '0126'; nome_vbi: 'Cartao Moeda Consultar'; mensagem_cliente: 'Consultar Moeda'),
    (Tag: '0127'; nome_vbi: 'Cartao Pre-autorizacao Solicitar'; mensagem_cliente: 'Venda pre-autorizada'),
    (Tag: '0128'; nome_vbi: 'Cartao Vender'; mensagem_cliente: 'Venda Cartão Bandeirado')
    );

implementation

constructor TVBI.Create(VP_Estabelecimento, VP_Loja, VP_Terminal, VP_Aplicacao: string);
begin
  V_Estabelecimento := VP_Estabelecimento;
  V_Loja := VP_Loja;
  V_Terminal := VP_Terminal;
  V_Aplicacao := VP_Aplicacao;

  inherited Create;
end;

function TVBI.consultarMenu(VP_Comunicador: TComunicadorVBI; var VO_Menu: TVBIMenuArray): TVBIRetorno;
var
  VL_DadosEnviados, VL_DadosRecebidos: TTagVBI;
  VL_Menu: TStringArray;
begin
  limparRetornoVBI(Result);

  VL_DadosEnviados := TTagVBI.Create;
  VL_DadosRecebidos := TTagVBI.Create;
  try
    Result := iniciarComunicacao(VP_Comunicador);

    if Result.erro <> 0 then
      Exit;

    VL_DadosEnviados.limpar;
    VL_DadosEnviados.addTag('servico', 'consultar');
    VL_DadosEnviados.addTag('retorno', '1');

    Result := VP_Comunicador.enviarMensagem(VL_DadosEnviados, VL_DadosRecebidos);

    if Result.erro <> 0 then
      Exit;

    VL_Menu := VL_DadosRecebidos.getTagAsArray('transacao');
    VO_Menu := formatarMenuEmTag(VL_Menu);
  finally
    VL_DadosEnviados.Free;
    VL_DadosRecebidos.Free;
  end;
end;

function TVBI.iniciarComunicacao(VP_Comunicador: TComunicadorVBI): TVBIRetorno;
var
  VL_DadosEnviados, VL_DadosRecebidos: TTagVBI;
begin
  limparRetornoVBI(Result);

  VL_DadosEnviados := TTagVBI.Create;
  VL_DadosRecebidos := TTagVBI.Create;
  try
    VL_DadosEnviados.addTag('versao', versaoAsString);
    VL_DadosEnviados.addTag('retorno', '1');
    VL_DadosEnviados.addTag('servico', 'iniciar');
    VL_DadosEnviados.addTag('aplicacao', V_Aplicacao);
    VL_DadosEnviados.addTag('aplicacao_tela', C_AplicacaoTelaPinpad);
    VL_DadosEnviados.addTag('estabelecimento', V_Estabelecimento);
    VL_DadosEnviados.addTag('loja', V_Loja);
    VL_DadosEnviados.addTag('terminal', V_Terminal);

    Result := VP_Comunicador.enviarMensagem(VL_DadosEnviados, VL_DadosRecebidos);
  finally
    VL_DadosEnviados.Free;
    VL_DadosRecebidos.Free;
  end;
end;

function TVBI.formatarMenuEmTag(VP_Menu: TStringArray): TVBIMenuArray;
var
  VL_I: integer;
  VL_II: integer;
begin
  SetLength(Result, 0);

  for VL_I := 0 to Length(C_CAMPOS_VENDAS) - 1 do
  begin
    for VL_II := 0 to Length(VP_Menu) - 1 do
    begin
      if VP_Menu[VL_II] = C_CAMPOS_VENDAS[VL_I].nome_vbi then
      begin
        SetLength(Result, Length(Result) + 1);
        Result[Length(Result) -1] := C_CAMPOS_VENDAS[VL_I];
        continue;
      end;
    end;
  end;
end;

end.
