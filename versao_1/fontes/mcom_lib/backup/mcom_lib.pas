library mcom_lib;

{$mode objfpc}{$H+}

uses
    Interfaces,
    Classes,
    mcom,
    zcomponent,
    rxnew,
    funcoes,
    comunicador,
    def { you can add units after this };

exports
    iniciarconexao,
    finalizaconexao,
    respondecaixa,
    respondeservico,

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
    mensagemtagtostr;

begin

end.
