unit uPesquisaTags;

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
    StdCtrls,
    Buttons,
    rxmemds,
    RxDBGrid,
    funcoes;

type

    { TFTags }

    TFTags = class(TForm)
        BSair: TBitBtn;
        BCarregar: TBitBtn;
        BPesquisar: TBitBtn;
        DSTags: TDataSource;
        ETag: TEdit;
        EDefinicao: TEdit;
        LTipoFuncao: TLabel;
        LPesquisaTags: TLabel;
        LTag: TLabel;
        LDefinicao: TLabel;
        pnlPrincipal: TPanel;
        pnlTopo: TPanel;
        pnlBase: TPanel;
        GridPrincipal: TRxDBGrid;
        MDTags: TRxMemoryData;
        ETipoFuncao: TComboBox;
        procedure BCarregarClick(Sender: TObject);
        procedure BPesquisarClick(Sender: TObject);
        procedure BSairClick(Sender: TObject);
        procedure FormShow(Sender: TObject);
    private
        procedure LimpaTela;
    public
        F_Tabela: string;
        F_Carregado: boolean;
        F_TagTipo: string;
    end;


var
    FTags: TFTags;

implementation

{$R *.lfm}

{ TFTags }

procedure TFTags.BSairClick(Sender: TObject);
begin
    Close;
end;

procedure TFTags.BPesquisarClick(Sender: TObject);
var
    VL_Filtro: string;
begin
    case ETipoFuncao.ItemIndex of
      1: F_TagTipo:='COMANDO';
      2: F_TagTipo:='MENU_PDV';
      3: F_TagTipo:='MENU_OPERACIONAL';
      4: F_TagTipo:='PINPAD_FUNC';
    ELSE
      if F_TagTipo = '' then
          VL_Filtro:='';
    end;
    if F_TagTipo = '' then
        VL_Filtro := ''
    else
        VL_Filtro := 'TAG_TIPO=(''*' + F_TagTipo + '*'')';

    if MDTags.Active then
        MDTags.EmptyTable;
    StrToRxMemData(F_Tabela, MDTags);
    MDTags.Open;

    if length(ETag.Text) > 0 then
        if VL_Filtro = '' then
            VL_Filtro := 'TAG_NUMERO=(''*' + ETag.Text + '*'')'
        else
            VL_Filtro := VL_Filtro + ' and TAG_NUMERO=(''*' + ETag.Text + '*'')';
    if length(EDefinicao.Text) > 0 then
        if VL_Filtro = '' then
            VL_Filtro := 'DEFINICAO=(''*' + EDefinicao.Text + '*'')'
        else
            VL_Filtro := VL_Filtro + ' and DEFINICAO=(''*' + EDefinicao.Text + '*'')';
    MDTags.Filter := VL_Filtro;
    MDTags.Filtered := True;
end;

procedure TFTags.BCarregarClick(Sender: TObject);
begin
    F_Carregado := True;
    Close;
end;

procedure TFTags.FormShow(Sender: TObject);
begin
    LimpaTela;
    F_Carregado := False;
end;

procedure TFTags.LimpaTela;
begin
    ETag.Text := '';
    EDefinicao.Text := '';
    ETipoFuncao.ItemIndex := 0;
    if MDTags.Active then
        MDTags.EmptyTable;
end;

end.
