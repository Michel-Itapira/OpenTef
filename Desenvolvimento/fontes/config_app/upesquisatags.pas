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

    TTipoTag = (ttNDF, ttCOMANDO, ttDADOS, ttMENU_PDV, ttMENU_OPERACIONAL, ttPINPAD_FUNC, ttMODULO);


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
        procedure MDTagsFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    private
        procedure LimpaTela;
    public
        F_Tabela: string;
        F_Carregado: boolean;
        F_TagTipo: ansistring;
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
        1: F_TagTipo := 'COMANDO';
        2: F_TagTipo := 'MENU_PDV';
        3: F_TagTipo := 'MENU_OPERACIONAL';
        4: F_TagTipo := 'PINPAD_FUNC';
        5: F_TagTipo := 'MODULO';
        else
            if F_TagTipo = '' then
                VL_Filtro := '';
    end;
    if ((F_TagTipo = '') or (F_TagTipo = 'NDF')) then
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
    IF MDTags.RecordCount=0 THEN
    BEGIN
       ShowMessage('Nenhum registro foi pesquisado');
       EXIT;
    end;
    F_Carregado := True;
    Close;
end;

procedure TFTags.FormShow(Sender: TObject);
var
    VL_Tipo: integer;
begin
    VL_TIPO := 0;
    LimpaTela;
    F_Carregado := False;
    vl_tipo := StrToTipoTag(F_TagTipo);
    case VL_TIPO of
        Ord(ttNDF): ETipoFuncao.ItemIndex := 0;
        Ord(ttCOMANDO): ETipoFuncao.ItemIndex := 1;
        Ord(ttMENU_PDV): ETipoFuncao.ItemIndex := 2;
        Ord(ttMENU_OPERACIONAL): ETipoFuncao.ItemIndex := 3;
        Ord(ttPINPAD_FUNC): ETipoFuncao.ItemIndex := 4;
        Ord(ttMODULO): ETipoFuncao.ItemIndex := 5;
    ELSE
        ETipoFuncao.ItemIndex := 0;
    end;
end;

procedure TFTags.MDTagsFilterRecord(DataSet: TDataSet; var Accept: Boolean);
begin

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
