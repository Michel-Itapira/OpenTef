library tef_lib;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}
    cthreads,
      {$ENDIF}
    Interfaces,
    Classes,
    tef,
    zcomponent,
    rxnew,
    funcoes,
    comunicador,
    def { you can add units after this };

exports
    inicializar,
    finalizar,
    login,
    desconectar,
    solicitacao,
    solicitacaoblocante,
    opentefstatus,

    mensagemcreate,
    mensagemcarregatags,
    mensagemcomando,
    mensagemfree,
    mensagemaddtag,
    mensagemaddcomando,
    mensagemcomandodados,
    mensagemtagasstring,
    mensagemtagcount,
    mensagemgettag,
    mensagemgettagidx,
    mensagemtagtostr,
    mensagemerro,
    mensagemgettagposicao,
    mensagemaddtagposicao,

    mensagemcreate_id,
    mensagemfree_id,

    transacaocreate,
    transacaofree,
    transacaostatus,
    transacaostatusdescricao,
    transacaogettag,
    transacaocancela,

    alterarnivellog,
    versao;



begin

end.
