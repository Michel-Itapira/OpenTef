unit uPesquisaadquirentes;

{$mode ObjFPC}{$H+}

interface

uses
    Classes,
    SysUtils,
    DB,
    Forms,
    Controls,
    Graphics,
    Dialogs,
    ExtCtrls,
    Buttons,
    StdCtrls,
    rxmemds,
    RxDBGrid,
    funcoes;

type

    { TFAdquirente }

    TFAdquirente = class(TForm)
      BCarregar: TBitBtn;
        BPesquisar: TBitBtn;
        BSair: TBitBtn;
        DSAdquirente: TDataSource;
        EDescricao: TEdit;
        EID: TEdit;
        GridPrincipal: TRxDBGrid;
        LDescricao: TLabel;
        LPesquisaAdquirente: TLabel;
        LID: TLabel;
        pnlBase: TPanel;
        pnlPrincipal: TPanel;
        pnlTopo: TPanel;
        MDAdquirente: TRxMemoryData;
        procedure BCarregarClick(Sender: TObject);
        procedure BPesquisarClick(Sender: TObject);
        procedure BSairClick(Sender: TObject);
        procedure FormShow(Sender: TObject);
    private

    public
        F_Tabela: string;
        F_Carregado: boolean;
    end;

var
    FAdquirente: TFAdquirente;

implementation

{$R *.lfm}

{ TFAdquirente }

procedure TFAdquirente.BSairClick(Sender: TObject);
begin
    Close;
end;

procedure TFAdquirente.FormShow(Sender: TObject);
begin
    EID.Text := '';
    EDescricao.Text := '';
    if MDAdquirente.Active then
        MDAdquirente.EmptyTable;
    F_Carregado := False;
end;

procedure TFAdquirente.BCarregarClick(Sender: TObject);
begin
    F_Carregado := True;
    Close;
end;

procedure TFAdquirente.BPesquisarClick(Sender: TObject);
var
    VL_Filtro: string;
begin
    VL_Filtro := '';
    if MDAdquirente.Active then
        MDAdquirente.EmptyTable;
    StrToRxMemData(F_Tabela, MDAdquirente);
    MDAdquirente.Open;

    if length(EID.Text) > 0 then
        if VL_Filtro = '' then
            VL_Filtro := 'ID=('+ EID.Text + ')'
        else
            VL_Filtro := VL_Filtro + ' and ID=('+ EID.Text + ')';
    if length(EDescricao.Text) > 0 then
        if VL_Filtro = '' then
            VL_Filtro := 'DESCRICAO=(''*' + EDescricao.Text + '*'')'
        else
            VL_Filtro := VL_Filtro + ' and DEESCRICAO=(''*' + EDescricao.Text + '*'')';
    MDAdquirente.Filter := VL_Filtro;
    MDAdquirente.Filtered := True;

end;

end.
