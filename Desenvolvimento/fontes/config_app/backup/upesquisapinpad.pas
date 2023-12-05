unit upesquisapinpad;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  DBGrids, StdCtrls, rxmemds;

type

  { TFPesquisaPinPad }

  TFPesquisaPinPad = class(TForm)
    BCarregar: TBitBtn;
    BPesquisar: TBitBtn;
    BSair: TBitBtn;
    DSPesquisaPinPad: TDataSource;
    EFabricante: TEdit;
    EID: TEdit;
    Grid: TDBGrid;
    LFabricante: TLabel;
    LID: TLabel;
    LPesquisaPinPad: TLabel;
    MDPesquisaPinPad: TRxMemoryData;
    Panel1: TPanel;
    PnlBase: TPanel;
    procedure BCarregarClick(Sender: TObject);
    procedure BPesquisarClick(Sender: TObject);
    procedure BSairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MDPesquisaPinPadFilterRecord(DataSet: TDataSet;
      var Accept: Boolean);
  private
    procedure LimpaTela;
public
    F_Tabela: string;
    F_Carregado: boolean;
  end;

var
  FPesquisaPinPad: TFPesquisaPinPad;

implementation

{$R *.lfm}

{ TFPesquisaPinPad }

procedure TFPesquisaPinPad.BSairClick(Sender: TObject);
begin
  close;
end;

procedure TFPesquisaPinPad.FormShow(Sender: TObject);
begin
  LimpaTela;
  F_Carregado := False;
end;

procedure TFPesquisaPinPad.MDPesquisaPinPadFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin

end;

procedure TFPesquisaPinPad.LimpaTela;
begin
     EID.text:='';
     EFabricante.text:='';
end;

procedure TFPesquisaPinPad.BCarregarClick(Sender: TObject);
begin
  if MDPesquisaPinPad.RecordCount<1 then
  begin
    ShowMessage('Nenhum Pin-Pad encontrado para carregar o formulário');
    exit;
  end;
  F_Carregado := True;
  Close;
end;

procedure TFPesquisaPinPad.BPesquisarClick(Sender: TObject);
var
    VL_Filtro: string;
begin
    VL_Filtro := '';
    if MDPesquisaPinPad.Active then
        MDPesquisaPinPad.EmptyTable;

    StrToRxMemData(F_Tabela, MDPesquisaPinPad);
    MDPesquisaPinPad.Open;

    if Length(EID.Text) > 0 then
        if VL_Filtro = '' then
            VL_Filtro := 'ID=' + EID.Text
        else
            VL_Filtro := VL_Filtro + ' AND ID=' + EID.Text;

    if Length(EFabricante.Text) > 0 then
        if VL_Filtro = '' then
            VL_Filtro := 'FABRICANTE_MODELO=(''*' + EFabricante.Text + '*'')'
        else
            VL_Filtro := VL_Filtro + ' AND FABRICANTE_MODELO=(''*' + EFabricante.Text + '*'')';


    MDPesquisaPinPad.Filter:=VL_Filtro;
    MDPesquisaPinPad.Filtered:=TRUE;


end;

end.

