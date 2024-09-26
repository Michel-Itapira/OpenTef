unit modulo;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils,def,funcoes;

type
  TDModulo = class(TDataModule)
  private

  end;

  function inicializar(VP_ModuloProcID: integer; var VO_Modulo: Pointer; VP_Recebimento: TRetornoModulo; VP_ModuloConf_ID: integer; VP_ArquivoLog: PChar): integer; cdecl;
  function finalizar(VP_Modulo: Pointer): integer; cdecl;
  function login(VP_Modulo: Pointer; VP_Host: PChar; VP_Porta: integer; VP_ChaveComunicacao, VP_TipoConexao, VP_Identificacao: PChar): integer; cdecl;
  function solicitacao(VP_Modulo: Pointer; VP_Transmissao_ID, VP_Dados: PChar; VP_Procedimento: TRetornoModulo; VP_TarefaID, VP_TempoAguarda: integer): integer; cdecl;
  function solicitacaoblocante(VP_Modulo: Pointer; VP_Transmissao_ID, VP_Dados: PChar; var VO_Retorno: PChar; VP_TempoAguarda: integer): integer; cdecl;
  function modulostatus(VP_Modulo: Pointer; var VO_Versao: PChar; var VO_VersaoMensagem: integer; var VO_StatusRetorno: integer): integer; cdecl;
  procedure Retorno(VP_Transmissao_ID: PChar; VP_TarefaID, VP_ModuloProcID, VP_Erro: integer; VP_Dados: PChar; VP_Modulo: Pointer); cdecl;
  procedure alterarnivellog(VP_Nivel: integer); cdecl;

implementation

{$R *.lfm}

function inicializar(VP_ModuloProcID: integer; var VO_Modulo: Pointer; VP_Recebimento: TRetornoModulo; VP_ModuloConf_ID: integer; VP_ArquivoLog: PChar): integer; cdecl;
begin
  Result := 0;
end;

function finalizar(VP_Modulo: Pointer): integer; cdecl;
begin
  Result := 0;
end;

function login(VP_Modulo: Pointer; VP_Host: PChar; VP_Porta: integer; VP_ChaveComunicacao, VP_TipoConexao, VP_Identificacao: PChar): integer; cdecl;
begin
  Result := 0;
end;

function solicitacao(VP_Modulo: Pointer; VP_Transmissao_ID, VP_Dados: PChar; VP_Procedimento: TRetornoModulo; VP_TarefaID, VP_TempoAguarda: integer): integer; cdecl;
begin
  Result := 0;
end;

function solicitacaoblocante(VP_Modulo: Pointer; VP_Transmissao_ID, VP_Dados: PChar; var VO_Retorno: PChar; VP_TempoAguarda: integer): integer; cdecl;
begin
  Result := 0;
end;

function modulostatus(VP_Modulo: Pointer; var VO_Versao: PChar; var VO_VersaoMensagem: integer; var VO_StatusRetorno: integer): integer; cdecl;
begin
  Result := 0;
end;

procedure Retorno(VP_Transmissao_ID: PChar; VP_TarefaID, VP_ModuloProcID, VP_Erro: integer; VP_Dados: PChar; VP_Modulo: Pointer); cdecl;
begin
  sleep(5);
end;

procedure alterarnivellog(VP_Nivel: integer); cdecl;
begin
  sleep(5);
end;

end.

