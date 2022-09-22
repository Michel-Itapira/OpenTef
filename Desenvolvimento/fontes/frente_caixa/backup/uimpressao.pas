unit uimpressao;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TFImpressao }

  TFImpressao = class(TForm)
    MImpressao: TMemo;
  private

  public

  end;

var
  FImpressao: TFImpressao;

implementation

{$R *.lfm}

end.

