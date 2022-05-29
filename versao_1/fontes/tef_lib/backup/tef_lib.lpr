library tef_lib;

{$mode objfpc}{$H+}

uses
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

    transacaoinicio,
    transacaostatus,
    transacaocancela;

begin
end.
