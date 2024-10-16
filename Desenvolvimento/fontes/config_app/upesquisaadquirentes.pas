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

    { TFPesquisaAdquirente }

    TFPesquisaAdquirente = class(TForm)
      BCarregar: TBitBtn;
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
        procedure EDescricaoChange(Sender: TObject);
        procedure EDescricaoClick(Sender: TObject);
        procedure EIDClick(Sender: TObject);
        procedure FormShow(Sender: TObject);
    private

    public
        F_Tabela: string;
        F_Carregado: boolean;
    end;

var
    FPesquisaAdquirente: TFPesquisaAdquirente;

implementation

uses
    ucadadquirente;

{$R *.lfm}

{ TFPesquisaAdquirente }

procedure TFPesquisaAdquirente.BSairClick(Sender: TObject);
begin
    Close;
end;

procedure TFPesquisaAdquirente.EDescricaoChange(Sender: TObject);
var
    VL_Filtro: string;
begin
    VL_Filtro := '';
    //if MDAdquirente.Active then
    //    MDAdquirente.EmptyTable;
    //StrToRxMemData(F_Tabela, MDAdquirente);
    //MDAdquirente.Open;

    if length(EID.Text) > 0 then
        if VL_Filtro = '' then
            VL_Filtro := 'ID=('+ EID.Text + ')'
        else
            VL_Filtro := VL_Filtro + ' and ID=('+ EID.Text + ')';

    if length(EDescricao.Text) > 0 then
        if VL_Filtro = '' then
            VL_Filtro := 'DESCRICAO=(''*' + EDescricao.Text + '*'')'
        else
            VL_Filtro := VL_Filtro + ' and DESCRICAO=(''*' + EDescricao.Text + '*'')';

    MDAdquirente.Filter := VL_Filtro;
    MDAdquirente.Filtered := True;
end;

procedure TFPesquisaAdquirente.EDescricaoClick(Sender: TObject);
begin
  EID.Clear;
end;

procedure TFPesquisaAdquirente.EIDClick(Sender: TObject);
begin
    EDescricao.Text:='';
end;

procedure TFPesquisaAdquirente.FormShow(Sender: TObject);
begin
    EID.Text := '';
    EDescricao.Text := '';
    if MDAdquirente.Active then
        MDAdquirente.EmptyTable;
    StrToRxMemData(F_Tabela, MDAdquirente);
    MDAdquirente.Open;

    F_Carregado := False;
end;

procedure TFPesquisaAdquirente.BCarregarClick(Sender: TObject);
begin
    if (MDAdquirente.RecordCount=0) OR (MDAdquirente.IsEmpty) then
    begin
       ShowMessage('Nenhum registro foi selecionado');
       EXIT;
    end;

    F_Carregado := True;
    Close;
end;

procedure TFPesquisaAdquirente.BPesquisarClick(Sender: TObject);
begin

end;

end.
