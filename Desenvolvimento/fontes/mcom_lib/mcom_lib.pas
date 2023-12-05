library mcom_lib;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}
      CThreads,
     {$ENDIF}

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
    mensagemtagtostr,
    mensagemlimpar,
    mensagemerro,
    mensagemgettagposicao,
    mensagemaddtagposicao,

    alterarnivellog,
    versao;

begin

end.
