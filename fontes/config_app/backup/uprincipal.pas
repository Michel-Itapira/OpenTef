unit uPrincipal;

{$mode objfpc}{$H+}

interface

uses
    Classes,
    SysUtils,
    StrUtils,
    Forms,
    Controls,
    Graphics,
    Dialogs,
    ComCtrls,
    ExtCtrls,
    StdCtrls,
    DBGrids,
    MaskEdit,
    DBCtrls,
    Buttons,
    ZDataset,
    ZConnection,
    funcoes,
    IniFiles,
    DB,
    BufDataset,
    rxmemds,
    RxDBGrid,
    rxlookup,
    RxDBGridFooterTools,
    RxDBGridExportPdf,
    RxDBGridPrintGrid,
    uPesquisaTags,
    uPesquisaadquirentes,
    Types,
    LbRSA,
    Grids,
    uPesquisamoduloconf;

type

    { Tfprincipal }

    TResposta = record
        Codigo: integer;
        Dados: string;
    end;

    TPermissao = (pmS, pmC, pmA, pmU);

    TConexaoStatus = (csDesconectado, csLink, csChaveado, csLogado);

    PResposta = ^TResposta;

    TPResposta = procedure(VP_Transmissao_ID: PChar; VP_Codigo: integer; VP_Dados: PChar); stdcall;

    Tfprincipal = class(TForm)
        BConectar: TBitBtn;
        TabTagETagTipo: TComboBox;
        TabTagCkPadrao: TCheckBox;
        DSLojaModuloConfFuncao: TDataSource;
        DSMultiLojaModuloConfFuncao: TDataSource;
        MDLojaModuloConfFuncaoDEFINICAO: TStringField;
        MDLojaModuloConfFuncaoHABILITADO: TStringField;
        MDLojaModuloConfFuncaoHABILITADO_F: TBooleanField;
        MDLojaModuloConfFuncaoID: TLargeintField;
        MDLojaModuloConfFuncaoLOJA_MODULO_CONF_ID: TLargeintField;
        MDLojaModuloConfFuncaoTAG_NUMERO: TStringField;
        MDLojaModuloConfFuncaoVALIDADO: TStringField;
        MDLojaModuloConfFuncaoVALIDADO_F: TBooleanField;
        MDMultiLojaModuloConfFuncaoDEFINICAO: TStringField;
        MDMultiLojaModuloConfFuncaoHABILITADO: TStringField;
        MDMultiLojaModuloConfFuncaoHABILITADO_F: TBooleanField;
        MDMultiLojaModuloConfFuncaoID: TLargeintField;
        MDMultiLojaModuloConfFuncaoMULTILOJA_MODULO_CONF_ID: TLargeintField;
        MDMultiLojaModuloConfFuncaoTAG_NUMERO: TStringField;
        MDMultiLojaModuloConfFuncaoVALIDADO: TStringField;
        MDMultiLojaModuloConfFuncaoVALIDADO_F: TBooleanField;
        PageLojaVizualizarConfModuloFuncao: TPageControl;
        PageMultiLojaVisualizaConfDadosFuncao: TPageControl;
        Panel1: TPanel;
        Panel2: TPanel;
        Panel3: TPanel;
        Panel4: TPanel;
        MDLojaModuloConfFuncao: TRxMemoryData;
        MDMultiLojaModuloConfFuncao: TRxMemoryData;
        TabConfiguracaoCKMenuOp: TCheckBox;
        TabLojaBAdicionar: TBitBtn;
        TabLojaBExcluir: TBitBtn;
        TabLojaBModificar: TBitBtn;
        TabLojaCkHabilitar: TCheckBox;
        TabLojaCMultLoja: TRxDBLookupCombo;
        TabLojaECnpj: TMaskEdit;
        TabLojaEFantasia: TEdit;
        TabLojaEID: TEdit;
        TabLojaERazao: TEdit;
        TabLojaFuncaoCKSelecionada: TCheckBox;
        TabLojaFuncaoEFiltro: TEdit;
        TabLojaTabFuncaoDadosEFiltro: TEdit;
        TabLojaFuncaoGrid: TRxDBGrid;
        TabLojaTabFuncaoDadosGrid: TRxDBGrid;
        TabLojaFuncaoLFiltro: TLabel;
        TabLojaTabFuncaoDadosLFiltro: TLabel;
        TabLojaFuncaoLTitulo: TLabel;
        TabLojaTabFuncaoDadosLTitulo: TLabel;
        TabLojaFuncaoMNota: TMemo;
        TabLojaLCnpj: TLabel;
        TabLojaLFantasia: TLabel;
        TabLojaLFantasia1: TLabel;
        TabLojaLID: TLabel;
        TabLojaLRazao: TLabel;
        TabLojaLTitulo1: TLabel;
        TabLojaModuloBAdicionar: TBitBtn;
        TabLojaModuloBExcluir: TBitBtn;
        TabLojaModuloBModificar: TBitBtn;
        TabLojaModuloBPesquisaModuloConf: TBitBtn;
        TabLojaModuloCkHabilitar: TCheckBox;
        TabLojaModuloECodigo: TEdit;
        TabLojaModuloEFiltro: TEdit;
        TabLojaModuloEID: TEdit;
        TabLojaModuloEModuloConf: TEdit;
        TabLojaModuloEModuloConfID: TEdit;
        TabLojaModuloGrid: TRxDBGrid;
        TabLojaModuloLCodigo: TLabel;
        TabLojaModuloLFiltro: TLabel;
        TabLojaModuloLID: TLabel;
        TabLojaModuloLModuloConf: TLabel;
        PageLojaVisualizarModuloFuncao: TPageControl;
        TabLojaFuncao: TTabSheet;
        TabLojaTabModulo: TTabSheet;
        TabAdquirente: TTabSheet;
        TabAdquirentePnlCadastro: TPanel;
        TabAdquirentePnlFiltro: TPanel;
        TabAdquirenteBAdicionar: TBitBtn;
        TabTagBExcluir: TBitBtn;
        TabMultLojaConfFuncaoCKSelecionada: TCheckBox;
        TabLojaConfFuncaoCKSelecionada: TCheckBox;
        TabMultLojaConfFuncaoEFiltro: TEdit;
        TabMultLojaConfFuncaoGrid: TRxDBGrid;
        TabMultLojaConfFuncaoLFiltro: TLabel;
        TabMultLojaConfFuncaoLTitulo: TLabel;
        TabMultLojaModuloBAdicionar: TBitBtn;
        TabMultLojaModuloBExcluir: TBitBtn;
        TabMultLojaModuloBModificar: TBitBtn;
        TabMultLojaModuloBPesquisaModuloConf: TBitBtn;
        TabMultLojaModuloCkHabilitar: TCheckBox;
        TabMultLojaModuloECodigo: TEdit;
        TabMultLojaModuloEFiltro: TEdit;
        TabMultLojaModuloEID: TEdit;
        TabMultLojaModuloEModuloConf: TEdit;
        TabMultLojaModuloEModuloConfID: TEdit;
        TabMultLojaModuloGrid: TRxDBGrid;
        TabMultLojaModuloLCodigo: TLabel;
        TabMultLojaModuloLFiltro: TLabel;
        TabMultLojaModuloLID: TLabel;
        TabMultLojaModuloLModuloConf: TLabel;
        TabMultLojaTabModuloDados: TTabSheet;
        TabMultLojaTabFuncaoDados: TTabSheet;
        TabLojaTabModuloDados: TTabSheet;
        TabLojaTabFuncaoDados: TTabSheet;
        TabAdquirenteBExcluir: TBitBtn;
        TabAdquirenteBModificar: TBitBtn;
        TabTagCTagTipoDados: TComboBox;
        DSModuloConfFuncao: TDataSource;
        GroupBox1: TGroupBox;
        MDModuloConfFuncao: TRxMemoryData;
        MDModuloConfFuncaoDEFINICAO: TStringField;
        MDModuloConfFuncaoHABILITADO: TStringField;
        MDModuloConfFuncaoHABILITADO_F: TBooleanField;
        MDModuloConfFuncaoID: TLargeintField;
        MDModuloConfFuncaoMODULO_CONF_ID: TLargeintField;
        MDModuloConfFuncaoTAG_NUMERO: TStringField;
        MDModuloConfFuncaoVALIDADO: TStringField;
        MDModuloConfFuncaoVALIDADO_F: TBooleanField;
        MDModuloFuncHABILITADO: TStringField;
        MDModuloFuncHABILITADO_F: TBooleanField;
        TabModuloPageModuloFuncao: TPageControl;
        TabConfiguracaoBAdicionarBin: TBitBtn;
        TabConfiguracaoBExcluirBin: TBitBtn;
        TabConfiguracaoBGerarChave: TBitBtn;
        TabConfiguracaoBPesquisarAdquirente: TBitBtn;
        TabConfiguracaoCKBin: TCheckBox;
        TabConfiguracaoCKHabilitar: TCheckBox;
        TabConfiguracaoCKMenu: TCheckBox;
        TabConfiguracaoEAdquirente_ID: TEdit;
        TabConfiguracaoEAdquirente_Nome: TEdit;
        TabConfiguracaoEBin: TEdit;
        TabConfiguracaoEChave: TMemo;
        TabConfiguracaoEDescricao: TEdit;
        TabConfiguracaoEHostE: TEdit;
        TabConfiguracaoEHostS: TEdit;
        TabConfiguracaoEID: TEdit;
        TabConfiguracaoEPortaE: TEdit;
        TabConfiguracaoEPortaS: TEdit;
        TabConfiguracaoGridBin: TRxDBGrid;
        TabConfiguracaoLAdquirente: TLabel;
        TabConfiguracaoLBin: TLabel;
        TabConfiguracaoLChave: TLabel;
        TabConfiguracaoLDescricao: TLabel;
        TabConfiguracaoLHostE: TLabel;
        TabConfiguracaoLHostS: TLabel;
        TabConfiguracaoLID: TLabel;
        TabConfiguracaoLPortaE: TLabel;
        TabConfiguracaoLPortaS: TLabel;
        TabFuncaoModuloCKSelecionada: TCheckBox;
        TabModuloTabDadosFuncaoCKSelecionada: TCheckBox;
        TabModuloTabDadosFuncaoEFiltro: TEdit;
        TabModuloTabDadosFuncaoGrid: TRxDBGrid;
        TabModuloTabDadosFuncaoLFiltro: TLabel;
        TabModuloTabDadosFuncaoLTitulo: TLabel;
        TabFuncaoModuloEFiltro: TEdit;
        TabFuncaoModuloGrid: TRxDBGrid;
        TabFuncaoModuloLFiltro: TLabel;
        TabFuncaoModuloLTitulo: TLabel;
        TabMultLojaBAtualizar: TBitBtn;
        TabTagBAdicionar: TBitBtn;
        TabTagBModificar: TBitBtn;
        TabPdvCkHabilitar: TCheckBox;
        TabMultLojaCkLojaMaster: TCheckBox;
        DSPdvModulo: TDataSource;
        DSPdvFuncao: TDataSource;
        DSPinPadFuncao: TDataSource;
        DSLojaFuncao: TDataSource;
        DSLojaModuloConf: TDataSource;
        DSMultiLojaFuncao: TDataSource;
        DSPesquisaModulo: TDataSource;
        DSMultiLojaModuloConf: TDataSource;
        DSModuloFunc: TDataSource;
        DSBin: TDataSource;
        MDLojaFuncaoDEFINICAO: TStringField;
        MDLojaFuncaoHABILITADO: TStringField;
        MDLojaFuncaoHABILITADO_F: TBooleanField;
        MDLojaFuncaoID: TLargeintField;
        MDLojaFuncaoLOJA_ID: TLargeintField;
        MDLojaFuncaoTAG_NUMERO: TStringField;
        MDLojaFuncaoVALIDADO: TStringField;
        MDLojaFuncaoVALIDADO_F: TBooleanField;
        MDMultiLojaFuncaoDEFINICAO: TStringField;
        MDMultiLojaFuncaoHABILITADO: TStringField;
        MDMultiLojaFuncaoHABILITADO_F: TBooleanField;
        MDMultiLojaFuncaoID: TLargeintField;
        MDMultiLojaFuncaoMULTILOJA_ID: TLargeintField;
        MDMultiLojaFuncaoTAG_NUMERO: TStringField;
        MDMultiLojaFuncaoVALIDADO: TStringField;
        MDMultiLojaFuncaoVALIDADO_F: TBooleanField;
        MDPdvFuncaoDEFINICAO: TStringField;
        MDPdvFuncaoHABILITADO: TStringField;
        MDPdvFuncaoHABILITADO_F: TBooleanField;
        MDPdvFuncaoID: TLargeintField;
        MDPdvFuncaoPDV_ID: TLargeintField;
        MDPdvFuncaoTAG_NUMERO: TStringField;
        MDPdvFuncaoVALIDADO: TStringField;
        MDPdvFuncaoVALIDADO_F: TBooleanField;
        MDPinPadFuncaoDEFINICAO: TStringField;
        MDPinPadFuncaoHABILITADO: TStringField;
        MDPinPadFuncaoHABILITADO_F: TBooleanField;
        MDPinPadFuncaoID: TLargeintField;
        MDPinPadFuncaoPINPAD_ID: TLargeintField;
        MDPinPadFuncaoTAG_NUMERO: TStringField;
        MDPinPadFuncaoVALIDADO: TStringField;
        MDPinPadFuncaoVALIDADO_F: TBooleanField;
        MDPdvModulo: TRxMemoryData;
        MDMultiLojaModuloConf: TRxMemoryData;
        MDPesquisaModulo: TRxMemoryData;
        MDMultiLojaFuncao: TRxMemoryData;
        MDLojaModuloConf: TRxMemoryData;
        MDLojaFuncao: TRxMemoryData;
        MDPinPadFuncao: TRxMemoryData;
        MDPdvFuncao: TRxMemoryData;
        TabAdquirenteEFiltro: TEdit;
        TabAdquirenteEID: TEdit;
        TabTagETagObs: TMemo;
        TabTagETagNumero: TEdit;
        TabTagETagDefinicao: TEdit;
        TabTagEFiltro: TEdit;
        TabTagEID: TEdit;
        TabAdquirenteEContato: TMemo;
        TabAdquirenteEDescricao: TEdit;
        TabModuloTabDadosFuncaoETipoFiltro: TComboBox;
        TabTagGrid: TDBGrid;
        TabAdquirenteGrid: TDBGrid;
        TabAdquirenteLFiltro: TLabel;
        TabAdquirenteLID: TLabel;
        TabTagLTagObs: TLabel;
        TabTagLTagNumero: TLabel;
        TabTagLTagDefinicao: TLabel;
        TabTagLFiltro: TLabel;
        TabTagLID: TLabel;
        TabTagLTagObs1: TLabel;
        TabAdquirenteLContato: TLabel;
        TabTagLTagTipo: TLabel;
        TabAdquirenteLDescricao: TLabel;
        TabModuloTabDadosFuncaoLTipoFiltro: TLabel;
        TabTagLTagTipoDados: TLabel;
        TabTagLTitulo: TLabel;
        TabPdvModuloCkHabilitar: TCheckBox;
        TabPDVModuloEModuloConfID: TEdit;
        TabTagPnlCadastro: TPanel;
        TabTagPnlFiltro: TPanel;
        TabPinPadFuncaoCKSelecionada: TCheckBox;
        TabPDVFuncaoCKSelecionada: TCheckBox;
        TabPinPadFuncaoEFiltro: TEdit;
        TabPDVFuncaoEFiltro: TEdit;
        TabPinPadFuncaoGrid: TRxDBGrid;
        TabPDVFuncaoGrid: TRxDBGrid;
        TabPinPadFuncaoLFiltro: TLabel;
        TabPDVFuncaoLFiltro: TLabel;
        TabPinPadFuncaoLTitulo: TLabel;
        TabPDVFuncaoLTitulo: TLabel;
        TabPinPadFuncaoMNota: TMemo;
        TabPDVFuncaoMNota: TMemo;
        TabPDVModuloBAdicionar: TBitBtn;
        TabPDVModuloBExcluir: TBitBtn;
        TabPDVModuloBModificar: TBitBtn;
        TabPDVModuloBPesquisaModuloConf: TBitBtn;
        TabPDVModuloBPesquisaTag: TBitBtn;
        TabPDVModuloEFiltro: TEdit;
        TabPDVModuloEID: TEdit;
        TabPDVModuloEModuloConf: TEdit;
        TabPDVModuloETag: TEdit;
        TabPDVModuloETagNumero: TEdit;
        TabPDVModuloGrid: TRxDBGrid;
        TabPDVModuloLDescricao: TLabel;
        TabPDVModuloLFiltro: TLabel;
        TabPDVModuloLID: TLabel;
        TabPDVModuloLModuloConf: TLabel;
        TabMultLojaFuncaoEFiltrar: TEdit;
        TabMultLojaFuncaoLTitulo: TLabel;
        TabMultLojaFuncaoLFiltrar: TLabel;
        MDBin: TRxMemoryData;
        MDModuloFunc: TRxMemoryData;
        MDModuloFuncDEFINICAO: TStringField;
        MDModuloFuncID: TLargeintField;
        MDModuloFuncMODULO_ID: TLargeintField;
        MDModuloFuncTAG_NUMERO: TStringField;
        MDModuloFuncVALIDADO: TStringField;
        MDModuloFuncVALIDADO_F: TBooleanField;
        TabMultLojaFuncaoGrid: TRxDBGrid;
        DSAdquirente: TDataSource;
        DSModuloConfig: TDataSource;
        DSModulo: TDataSource;
        DSTags: TDataSource;
        ListaImg: TImageList;
        MDModulo: TRxMemoryData;
        MDModuloConfig: TRxMemoryData;
        MDTags: TRxMemoryData;
        MDAdquirente: TRxMemoryData;
        TabConfLSenhaConfigurador: TLabel;
        TabConfLSenhaAdministrador: TLabel;
        TabConfLSenhaUsuario: TLabel;
        TabMultLojaFuncaoCKSelecionada: TCheckBox;
        TabMultLojaLRazaoLoja: TLabel;
        TabPinPadMFabricante: TEdit;
        TabModuloBAdicionar: TBitBtn;
        TabConfiguracaoBAdicionar: TBitBtn;
        TabModuloBExcluir: TBitBtn;
        TabConfiguracaoBExcluir: TBitBtn;
        TabModuloBLocalizaTag: TBitBtn;
        TabModuloBModificar: TBitBtn;
        DSMultiLoja: TDataSource;
        DSMultiLojaLoja: TDataSource;
        DSPinPadPdv: TDataSource;
        TabConfiguracaoBModificar: TBitBtn;
        TabModuloEDescricao: TEdit;
        TabModuloEID: TEdit;
        TabModuloEPesquisaModulo: TEdit;
        TabModuloETagModulo: TEdit;
        TabModuloGrid: TRxDBGrid;
        TabConfiguracaoGridConfiguracao: TRxDBGrid;
        TabModuloLDescricao: TLabel;
        TabModuloLID: TLabel;
        TabConfiguracaoLTitulo: TLabel;
        TabModuloLPesquisaModulo: TLabel;
        TabModuloLTagModulo: TLabel;
        TabModuloLTitulo: TLabel;
        MDMultiLoja: TRxMemoryData;
        MDMultiLojaLoja: TRxMemoryData;
        MDPinPadPdv: TRxMemoryData;
        TabModuloPagePrincipal: TPageControl;
        TabModuloPnlPesquisaModulo: TPanel;
        TabModuloPnlPesquisa_Topo: TPanel;
        TabModuloPnlPrincipal: TPanel;
        TabModuloPnlPrincipal_Topo: TPanel;
        TabModuloPnlTopo: TPanel;
        TabConfiguracao: TTabSheet;
        TabModuloFuncao: TTabSheet;
        TabMultLojaBExcluir: TBitBtn;
        TabPdvBExcluir: TBitBtn;
        TabPdvCPinPad: TRxDBLookupCombo;
        TabPdvECodigo: TEdit;
        TabPdvEPinPadCom: TEdit;
        TabPdvLCodigo: TLabel;
        TabPdvLPinPadCom: TLabel;
        TabPdvLPinPad: TLabel;
        TabPinPadBExcluir: TBitBtn;
        TabConfBExcluir: TBitBtn;
        TabMultLojaGDados: TGroupBox;
        TabMultLojaLLojaMaster: TLabel;
        TabPdvLTitulo: TLabel;
        TabPinPadLTitulo: TLabel;
        TabConfLTitulo: TLabel;
        TabMultLojaMDadosLoja: TMemo;
        PageMultiLojaVisualizarModuloFuncao: TPageControl;
        TabPdvPageModuloFuncao: TPageControl;
        TabPDVModuloLTag: TLabel;
        TabPinPadPageModuloFuncao: TPageControl;
        TabPdvPnlFiltro: TPanel;
        TabPinPadPnlFiltro: TPanel;
        TabConfPnlFiltro: TPanel;
        TabMultLojaPnlPesquisa: TPanel;
        TabMultLojaPnlFiltro: TPanel;
        PnlBase: TPanel;
        TabMultLojaPnlLojaMaster: TPanel;
        TabConfBGeraChave: TSpeedButton;
        TabConfEChave: TMemo;
        TabConfEDescricao: TEdit;
        TabConfEFiltro: TEdit;
        TabConfEID: TEdit;
        TabConfEIP: TEdit;
        TabConfGrid: TDBGrid;
        TabConfLChave: TLabel;
        TabConfLDescricao: TLabel;
        TabConfLID: TLabel;
        TabConfLIP: TLabel;
        TabConfPnlCadastro: TPanel;
        TabMultLojaBAdicionar: TBitBtn;
        TabPdvBAdicionar: TBitBtn;
        CTipo: TComboBox;
        DSPinPad: TDataSource;
        DSConfigurador: TDataSource;
        MDLoja: TRxMemoryData;
        MDPdv: TRxMemoryData;
        MDPinPad: TRxMemoryData;
        MDLojaPDV: TRxMemoryData;
        MDConfigurador: TRxMemoryData;
        TabLojaPnlFiltro: TPanel;
        TabPinPadBAdicionar: TBitBtn;
        TabPdvBModificar: TBitBtn;
        TabLojaEFiltro: TEdit;
        TabMultLojaEFiltro: TEdit;
        TabLojaGrid: TDBGrid;
        TabMultLojaGridFiltro: TDBGrid;
        TabMultLojaGridLojaMaster: TDBGrid;
        TabLojaLFiltro: TLabel;
        TabMultLojaLFiltro: TLabel;
        TabConfBAdicionar: TBitBtn;
        TabPinPadBModificar: TBitBtn;
        TabPdvLFiltro: TLabel;
        TabPdvBGeraChave: TSpeedButton;
        TabPdvCLoja: TRxDBLookupCombo;
        TabPdvEChave: TMemo;
        TabPdvEDescricao: TEdit;
        TabPdvEFiltro: TEdit;
        TabPdvEID: TEdit;
        TabPdvEIP: TEdit;
        TabPdvGrid: TDBGrid;
        TabPdvLChave: TLabel;
        TabPdvLDescricao: TLabel;
        TabConfBModificar: TBitBtn;
        TabPinPadEFiltro: TEdit;
        TabPinPadGrid: TDBGrid;
        TabPinPadLFiltro: TLabel;
        TabPdvLID: TLabel;
        TabPdvLIP: TLabel;
        TabPdvLLoja: TLabel;
        TabPdvPnlCadastro: TPanel;
        TabPinPadEID: TEdit;
        TabPinPadLFabricante: TLabel;
        TabConfLFiltro: TLabel;
        TabPinPadLID: TLabel;
        TabPinPadPnlCadastro: TPanel;
        TabPinPad: TTabSheet;
        TabMultLojaModulo: TTabSheet;
        TabPdvTabDadosModulo: TTabSheet;
        TabPdvTabDadosFuncao: TTabSheet;
        TabPinPadTabDadosFuncao: TTabSheet;
        TabMultLoja: TTabSheet;
        TabPdv: TTabSheet;
        TabConf: TTabSheet;
        TabMultLojaFuncao: TTabSheet;
        DSLojaPdv: TDataSource;
        DSPdv: TDataSource;
        DSLoja: TDataSource;
        LTipo: TLabel;
        PageCadastroLoja: TPageControl;
        TabLojaPPrincipal: TPanel;
        ESenha: TEdit;
        LSenha: TLabel;
        LStatus: TLabel;
        EStatus: TLabel;
        PagePrincipal: TPageControl;
        PTopo: TPanel;
        PPrincipal: TPanel;
        PStatus: TPanel;
        TabCadastro: TTabSheet;
        TabLoja: TTabSheet;
        TabModulo: TTabSheet;
        TabModuloTabDadosModulo: TTabSheet;
        TabModuloTabDadosFuncao: TTabSheet;
        TabTag: TTabSheet;
        TabTagETagDados: TMemo;
        TabAdquirenteLTitulo: TLabel;
        TabTipoAdmESenha: TEdit;
        TabTipoConfESenha: TEdit;
        TabTipoUsuESenha: TEdit;
        procedure BConectarClick(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
        procedure MDAdquirenteAfterScroll(DataSet: TDataSet);
        procedure MDAdquirenteFilterRecord(DataSet: TDataSet; var Accept: boolean);
        procedure MDBinAfterScroll(DataSet: TDataSet);
        procedure MDLojaFilterRecord(DataSet: TDataSet; var Accept: boolean);
        procedure MDLojaFuncaoCalcFields(DataSet: TDataSet);
        procedure MDLojaModuloConfAfterScroll(DataSet: TDataSet);
        procedure MDLojaModuloConfFuncaoCalcFields(DataSet: TDataSet);
        procedure MDModuloAfterScroll(DataSet: TDataSet);
        procedure MDModuloConfigAfterScroll(DataSet: TDataSet);
        procedure MDModuloConfFuncaoCalcFields(DataSet: TDataSet);
        procedure MDModuloFuncCalcFields(DataSet: TDataSet);
        procedure MDMultiLojaAfterScroll(DataSet: TDataSet);
        procedure MDMultiLojaFuncaoCalcFields(DataSet: TDataSet);
        procedure MDMultiLojaModuloConfAfterScroll(DataSet: TDataSet);
        procedure MDMultiLojaModuloConfFuncaoCalcFields(DataSet: TDataSet);
        procedure MDPdvFuncaoCalcFields(DataSet: TDataSet);
        procedure MDPdvModuloAfterScroll(DataSet: TDataSet);
        procedure MDPinPadFuncaoCalcFields(DataSet: TDataSet);
        procedure MDTagsAfterScroll(DataSet: TDataSet);
        procedure MDTagsFilterRecord(DataSet: TDataSet; var Accept: boolean);
        procedure TabAdquirenteBAdicionarClick(Sender: TObject);
        procedure TabAdquirenteBExcluirClick(Sender: TObject);
        procedure TabAdquirenteBModificarClick(Sender: TObject);
        procedure TabAdquirenteEFiltroChange(Sender: TObject);
        procedure TabConfiguracaoContextPopup(Sender: TObject; MousePos: TPoint; var Handled: boolean);
        procedure TabFuncaoModuloConfShow(Sender: TObject);
        procedure TabLojaFuncaoCKSelecionadaChange(Sender: TObject);
        procedure TabLojaFuncaoEFiltroChange(Sender: TObject);
        procedure TabLojaFuncaoGridCellClick(Column: TColumn);
        procedure TabLojaFuncaoMNotaChange(Sender: TObject);
        procedure PTopoClick(Sender: TObject);
        procedure TabConfBExcluirClick(Sender: TObject);
        procedure TabConfiguracaoBAdicionarBinClick(Sender: TObject);
        procedure TabConfiguracaoBAdicionarClick(Sender: TObject);
        procedure TabConfiguracaoBExcluirBinClick(Sender: TObject);
        procedure TabConfiguracaoBExcluirClick(Sender: TObject);
        procedure TabConfiguracaoBGerarChaveClick(Sender: TObject);
        procedure TabConfiguracaoBModificarClick(Sender: TObject);
        procedure TabConfiguracaoBPesquisarAdquirenteClick(Sender: TObject);
        procedure TabConfiguracaoShow(Sender: TObject);
        procedure TabFuncaoModuloCKSelecionadaChange(Sender: TObject);
        procedure TabFuncaoModuloEFiltroChange(Sender: TObject);
        procedure TabFuncaoModuloGridCellClick(Column: TColumn);
        procedure TabLojaModuloEFiltroChangeBounds(Sender: TObject);
        procedure TabLojaTabFuncaoDadosEFiltroChange(Sender: TObject);
        procedure TabLojaTabFuncaoDadosGridCellClick(Column: TColumn);
        procedure TabLojaTabFuncaoDadosShow(Sender: TObject);
        procedure TabLojaTabModuloDadosShow(Sender: TObject);
        procedure TabModuloFuncaoShow(Sender: TObject);
        procedure TabLojaBExcluirClick(Sender: TObject);
        procedure TabLojaBModificarClick(Sender: TObject);
        procedure TabLojaBAdicionarClick(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure FormShow(Sender: TObject);
        function ErroLogin(VP_Erro: integer): string;
        procedure MDConfiguradorAfterScroll(DataSet: TDataSet);
        procedure MDLojaAfterScroll(DataSet: TDataSet);
        procedure MDPdvAfterScroll(DataSet: TDataSet);
        procedure MDPdvFilterRecord(DataSet: TDataSet; var Accept: boolean);
        procedure MDPinPadAfterScroll(DataSet: TDataSet);
        procedure TabConfBAdicionarClick(Sender: TObject);
        procedure TabConfBGeraChaveClick(Sender: TObject);
        procedure TabConfBModificarClick(Sender: TObject);
        procedure TabConfEFiltroChange(Sender: TObject);
        procedure TabConfGridCellClick(Column: TColumn);
        procedure TabLojaEFiltroChange(Sender: TObject);
        procedure TabLojaGridCellClick(Column: TColumn);
        procedure TabLojaGridDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: integer; Column: TColumn; State: TGridDrawState);
        procedure TabLojaModuloBAdicionarClick(Sender: TObject);
        procedure TabLojaModuloBExcluirClick(Sender: TObject);
        procedure TabLojaModuloBModificarClick(Sender: TObject);
        procedure TabLojaModuloBPesquisaModuloConfClick(Sender: TObject);
        procedure TabLojaModuloEFiltroChange(Sender: TObject);
        procedure TabLojaShow(Sender: TObject);
        procedure TabLojaFuncaoShow(Sender: TObject);
        procedure TabModuloBAdicionarClick(Sender: TObject);
        procedure TabModuloBExcluirClick(Sender: TObject);
        procedure TabModuloBLocalizaTagClick(Sender: TObject);
        procedure TabModuloBModificarClick(Sender: TObject);
        procedure TabModuloContextPopup(Sender: TObject; MousePos: TPoint; var Handled: boolean);
        procedure TabModuloEPesquisaModuloChange(Sender: TObject);
        procedure TabModuloShow(Sender: TObject);
        procedure TabModuloTabDadosFuncaoEFiltroChange(Sender: TObject);
        procedure TabModuloTabDadosFuncaoGridCellClick(Column: TColumn);
        procedure TabModuloTabDadosFuncaoShow(Sender: TObject);
        procedure TabMultLojaBAdicionarClick(Sender: TObject);
        procedure TabMultLojaBAtualizarClick(Sender: TObject);
        procedure TabMultLojaBExcluirClick(Sender: TObject);
        procedure TabMultLojaCkLojaMasterChange(Sender: TObject);
        procedure TabMultLojaConfFuncaoCKSelecionadaChange(Sender: TObject);
        procedure TabMultLojaConfFuncaoEFiltroChange(Sender: TObject);
        procedure TabMultLojaConfFuncaoGridCellClick(Column: TColumn);
        procedure TabMultLojaEFiltroChange(Sender: TObject);
        procedure TabMultLojaFuncaoCKSelecionadaChange(Sender: TObject);
        procedure TabMultLojaFuncaoEFiltrarChange(Sender: TObject);
        procedure TabMultLojaFuncaoGridCellClick(Column: TColumn);
        procedure TabMultLojaGridFiltroCellClick(Column: TColumn);
        procedure TabMultLojaModuloBAdicionarClick(Sender: TObject);
        procedure TabMultLojaModuloBExcluirClick(Sender: TObject);
        procedure TabMultLojaModuloBModificarClick(Sender: TObject);
        procedure TabMultLojaModuloBPesquisaModuloConfClick(Sender: TObject);
        procedure TabMultLojaModuloEFiltroChange(Sender: TObject);
        procedure TabMultLojaFuncaoShow(Sender: TObject);
        procedure TabMultLojaShow(Sender: TObject);
        procedure TabMultLojaTabFuncaoDadosShow(Sender: TObject);
        procedure TabMultLojaTabModuloDadosShow(Sender: TObject);
        procedure TabPdvBAdicionarClick(Sender: TObject);
        procedure TabPdvBExcluirClick(Sender: TObject);
        procedure TabPdvBGeraChaveClick(Sender: TObject);
        procedure TabPdvBModificarClick(Sender: TObject);
        procedure TabPdvEFiltroChange(Sender: TObject);
        procedure TabPDVFuncaoCKSelecionadaChange(Sender: TObject);
        procedure TabPDVFuncaoEFiltroChange(Sender: TObject);
        procedure TabPDVFuncaoGridCellClick(Column: TColumn);
        procedure TabPdvGridCellClick(Column: TColumn);
        procedure TabPDVModuloBAdicionarClick(Sender: TObject);
        procedure TabPDVModuloBExcluirClick(Sender: TObject);
        procedure TabPDVModuloBModificarClick(Sender: TObject);
        procedure TabPDVModuloBPesquisaModuloConfClick(Sender: TObject);
        procedure TabPDVModuloBPesquisaTagClick(Sender: TObject);
        procedure TabPDVModuloEFiltroChange(Sender: TObject);
        procedure TabPdvShow(Sender: TObject);
        procedure TabPdvTabDadosFuncaoShow(Sender: TObject);
        procedure TabPdvTabDadosModuloShow(Sender: TObject);
        procedure TabPinPadBAdicionarClick(Sender: TObject);
        procedure TabPinPadBExcluirClick(Sender: TObject);
        procedure TabPinPadBModificarClick(Sender: TObject);
        procedure TabPinPadEFiltroChange(Sender: TObject);
        procedure TabPinPadFuncaoCKSelecionadaChange(Sender: TObject);
        procedure TabPinPadFuncaoEFiltroChange(Sender: TObject);
        procedure TabPinPadFuncaoGridCellClick(Column: TColumn);
        procedure TabPinPadShow(Sender: TObject);
        procedure TabPinPadTabDadosFuncaoShow(Sender: TObject);
        procedure TabTagBAdicionarClick(Sender: TObject);
        procedure TabTagBExcluirClick(Sender: TObject);
        procedure TabTagBModificarClick(Sender: TObject);
        procedure TabTagEFiltroChange(Sender: TObject);
        procedure TabTagGridCellClick(Column: TColumn);
    private
        procedure Conectar;
        procedure Desconectar;
        procedure LimparTela;
        function FiltrarTabela(VP_DBGrid: TRxDBGrid; var VO_RotuloCaption: string; VP_EditFiltrado: TEdit): string;
        function FiltrarTabela(VP_DBGrid: TDBGrid; var VO_RotuloCaption: string; VP_EditFiltrado: TEdit): string;
        procedure CarregaCampos;
        procedure CarregarTabelas(VP_CarregaTodasTabelas: boolean; VP_TagTabelaEspecifica: string; VP_Tag: string; VP_DadosN: integer);
        function PesquisaTabelas(VP_TagComando, VP_DadosComando, VP_Tag: ansistring; VP_ID: integer): ansistring;
        function GravaRegistros(VP_Tab: string; VP_Incluir: boolean = False): boolean;
        function IncluirRegistro(VP_Tabela: TRxMemoryData; VP_TagComando, VP_TagComandoDados, VP_TagTabela: string; var VO_Retorno: ansistring): integer;
        procedure AlterarRegistro(VP_TagTabela: string; VP_Tabela: TRxMemoryData; VP_Tag: string; VP_ID: int64; VP_TagComando, VP_TagComandoDados: string);
        function ExcluirRegistro(VP_Tag: string; VP_ID: integer; VP_TagComando, VP_TagComandoDados: string; var VO_Retorno: ansistring): integer;
        function SolicitacaoBloc(VP_Dados: ansistring; var VO_Retorno: ansistring; VP_Tempo: integer): integer;


    public

    end;

    TTefInicializar = function(VP_Procedimento: TRetorno; VP_ArquivoLog: PChar): integer; stdcall;
    TTefFinalizar = function(): integer; stdcall;
    TTefDesconectar = function(): integer; stdcall;
    TTLogin = function(VP_Host: PChar; VP_Porta: integer; VP_Chave: PChar; VP_Versao_Comunicacao: integer; VP_Senha: PChar;
        VP_Tipo: PChar; var VO_Mensagem: PChar): integer; stdcall;
    TTOpenTefStatus = function(var VO_StatusRetorno: integer): integer; stdcall;
    TTSolicitacaoBlocante = function(VP_Dados: PChar; var VO_Retorno: PChar; VP_Tempo: integer): integer; stdcall;



procedure Retorno(VP_Tranmissao_ID: PChar; VP_PrcID, VP_Codigo: integer; VP_Dados: PChar); stdcall;

var
    F_Principal: Tfprincipal;
    F_ComLib: THandle;
    F_Inicializar: TTefInicializar;
    F_Finalizar: TTefFinalizar;
    F_Desconectar: TTefDesconectar;
    F_Login: TTLogin;
    F_OpenTefStatus: TTOpenTefStatus;
    F_SolicitacaoBlocante: TTSolicitacaoBlocante;
    F_Conf: TIniFile;
    F_Host: string;
    F_Porta: integer;
    F_Chave: string;
    F_Permissao: boolean;
    F_Navegar: boolean;
    F_TipoConfigurador: TPermissao;

const
    C_Versao_TefLib = '1.1.1';
    C_Versao_Mensagem = 1;
    {$IFDEF DEBUG}
    C_TempoSolicitacao=200000;
    {$ELSE}
    C_TempoSolicitacao = 20000;
    {$ENDIF}



implementation

procedure Retorno(VP_Tranmissao_ID: PChar; VP_PrcID, VP_Codigo: integer; VP_Dados: PChar); stdcall;
begin

end;

{$R *.lfm}

{ Tfprincipal }

procedure Tfprincipal.MDModuloAfterScroll(DataSet: TDataSet);
begin
    if ((MDModulo.Active = False) or (MDModulo.RecordCount = 0) or (F_Navegar = False)) then
        exit;

    if MDModuloConfig.Active then
    begin
        MDModuloConfig.EmptyTable;
        TabConfiguracao.OnShow(self);
    end
    else
        TabConfiguracao.OnShow(self);

    if MDModuloFunc.Active then
    begin
        MDModuloFunc.EmptyTable;
        TabModuloFuncao.OnShow(self);
    end
    else
        TabModuloFuncao.OnShow(self);

    CarregaCampos;
end;

procedure Tfprincipal.BConectarClick(Sender: TObject);
var
    VL_Codigo, VL_Status: integer;
    VL_TMensagem: TMensagem;
    VL_Tag: string;
    VL_Senha: ansistring;
    VL_Tipo: ansistring;
    VL_PMensagem, VL_PTipo, VL_PSenha, VL_PChave, VL_PHost: PChar;
begin
    if BConectar.Caption = 'Desconectar' then
    begin
        Desconectar;
        Exit;
    end;
    try
        VL_TMensagem := TMensagem.Create;
        VL_Tag := '';
        VL_Senha := '';
        VL_Tipo := '';
        New(VL_PMensagem);
        New(VL_PSenha);
        New(VL_PTipo);
        New(VL_PChave);
        New(VL_PHost);
        VL_Status := 0;
        if not FileExists(ExtractFilePath(ParamStr(0)) + 'config_tef.ini') then
        begin
            F_Conf := TIniFile.Create(PChar(ExtractFilePath(ParamStr(0)) + 'config_tef.ini'));
            F_Conf.WriteInteger('Servidor', 'Porta', 0);
            F_Conf.WriteString('Servidor', 'Host', '');
            F_Conf.WriteString('Servidor', 'Chave', '');
            F_Conf.Free;
        end;

        F_Conf := TIniFile.Create(PChar(ExtractFilePath(ParamStr(0)) + 'config_tef.ini'));

        if F_Conf.ReadInteger('Servidor', 'Porta', 0) <> 0 then
        begin
            F_Porta := F_Conf.ReadInteger('Servidor', 'Porta', 0);
            F_Host := F_Conf.ReadString('Servidor', 'Host', '');
            F_Chave := F_Conf.ReadString('Servidor', 'Chave', '');
        end;
        VL_Senha := ESenha.Text;
        case CTipo.ItemIndex of
            Ord(pmC):
            begin
                VL_Tipo := 'C';
                F_TipoConfigurador := pmC;
            end;
            Ord(pmA):
            begin
                VL_Tipo := 'A';
                F_TipoConfigurador := pmA;
            end;
            Ord(pmU):
            begin
                VL_Tipo := 'U';
                F_TipoConfigurador := pmU;
            end
            else
                VL_Tipo := 'ndf';
        end;

        if VL_Tipo = 'ndf' then
        begin
            ShowMessage('Define um tipo de configurador para logar');
            exit;
        end;
        StrPCopy(VL_PSenha, VL_Senha);
        StrPCopy(VL_PTipo, VL_Tipo);
        StrPCopy(VL_PChave, F_Chave);
        StrPCopy(VL_PHost, F_Host);
        VL_Codigo := F_Login(VL_PHost, F_Porta, VL_PChave, C_Versao_Mensagem, VL_PSenha, VL_PTipo, VL_PMensagem);

        if VL_Codigo <> 0 then
        begin
            ShowMessage(IntToStr(VL_Codigo));
            Exit;
        end;

        F_OpenTefStatus(VL_Status);

        if Ord(csLogado) = VL_Status then
        begin
            EStatus.Caption := 'Logado';
            EStatus.Font.Color := clGreen;
            BConectar.Caption := 'Desconectar';
            BConectar.ImageIndex := 4;
            F_Permissao := True;
            CarregarTabelas(True, '', '', 0);
            TabMultLojaTabModuloDados.OnShow(SELF);
            Exit;
        end;
        VL_TMensagem.GetTag('0036', VL_Tag);

        if VL_Tag <> '0' then
            ShowMessage(ErroLogin(StrToInt(vl_tag)));

    finally
        begin
            Dispose(VL_PMensagem);
            Dispose(VL_PSenha);
            Dispose(VL_PTipo);
            Dispose(VL_PChave);
            Dispose(VL_PHost);
            VL_TMensagem.Free;
        end;

    end;

end;

procedure Tfprincipal.FormDestroy(Sender: TObject);
begin
    F_Finalizar;
end;

procedure Tfprincipal.MDAdquirenteAfterScroll(DataSet: TDataSet);
begin
    if ((MDAdquirente.Active = False) or (MDAdquirente.RecordCount = 0) or (F_Navegar = False)) then
        exit;
    CarregaCampos;
end;

procedure Tfprincipal.MDAdquirenteFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin

end;

procedure Tfprincipal.MDBinAfterScroll(DataSet: TDataSet);
begin
    if ((MDBin.Active = False) or (MDBin.RecordCount = 0) or (F_Navegar = False)) then
        exit;
    CarregaCampos;
end;

procedure Tfprincipal.MDLojaFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin

end;

procedure Tfprincipal.MDLojaFuncaoCalcFields(DataSet: TDataSet);
begin
    if (F_Permissao) then
    begin
        DataSet.FieldByName('VALIDADO_F').AsBoolean := DataSet.FieldByName('VALIDADO').AsBoolean;
        DataSet.FieldByName('HABILITADO_F').AsBoolean := DataSet.FieldByName('HABILITADO').AsBoolean;
    end;
end;

procedure Tfprincipal.MDLojaModuloConfAfterScroll(DataSet: TDataSet);
begin
    if ((MDLojaModuloConf.Active = False) or (MDLojaModuloConf.RecordCount = 0) or (F_Navegar = False)) then
        exit;
    CarregaCampos;
end;

procedure Tfprincipal.MDLojaModuloConfFuncaoCalcFields(DataSet: TDataSet);
begin
    if (F_Permissao) then
    begin
        DataSet.FieldByName('VALIDADO_F').AsBoolean := DataSet.FieldByName('VALIDADO').AsBoolean;
        DataSet.FieldByName('HABILITADO_F').AsBoolean := DataSet.FieldByName('HABILITADO').AsBoolean;
    end;
end;

procedure Tfprincipal.MDModuloConfigAfterScroll(DataSet: TDataSet);
begin
    if ((MDModuloConfig.Active = False) or (MDModuloConfig.RecordCount = 0) or (F_Navegar = False)) then
        exit;

    if MDModuloConfFuncao.Active then
    begin
        MDModuloConfFuncao.EmptyTable;
        TabModuloTabDadosFuncao.OnShow(self);
    end
    else
        TabModuloTabDadosFuncao.OnShow(self);
    CarregaCampos;
end;

procedure Tfprincipal.MDModuloConfFuncaoCalcFields(DataSet: TDataSet);
begin
    if (F_Permissao) then
    begin
        DataSet.FieldByName('VALIDADO_F').AsBoolean := DataSet.FieldByName('VALIDADO').AsBoolean;
        DataSet.FieldByName('HABILITADO_F').AsBoolean := DataSet.FieldByName('HABILITADO').AsBoolean;
    end;
end;

procedure Tfprincipal.MDModuloFuncCalcFields(DataSet: TDataSet);
begin
    if (F_Permissao) then
    begin
        DataSet.FieldByName('VALIDADO_F').AsBoolean := DataSet.FieldByName('VALIDADO').AsBoolean;
        DataSet.FieldByName('HABILITADO_F').AsBoolean := DataSet.FieldByName('HABILITADO').AsBoolean;
    end;
end;


procedure Tfprincipal.MDMultiLojaAfterScroll(DataSet: TDataSet);
begin
    if ((MDMultiLoja.Active = False) or (MDMultiLoja.RecordCount = 0) or (F_Navegar = False)) then
        exit;

    if MDMultiLojaModuloConf.Active then
    begin
        MDMultiLojaModuloConf.EmptyTable;
        TabMultLojaTabModuloDados.OnShow(self);
    end
    else
        TabMultLojaTabModuloDados.OnShow(self);

    if MDMultiLojaFuncao.Active then
    begin
        MDMultiLojaFuncao.EmptyTable;
        TabMultLojaFuncao.OnShow(self);
    end
    else
        TabMultLojaFuncao.OnShow(self);

    if MDMultiLojaModuloConfFuncao.Active then
    begin
        MDMultiLojaModuloConfFuncao.EmptyTable;
        TabMultLojaTabFuncaoDados.OnShow(self);
    end
    else
        TabMultLojaTabFuncaoDados.OnShow(self);

    CarregaCampos;

end;

procedure Tfprincipal.MDMultiLojaFuncaoCalcFields(DataSet: TDataSet);
begin
    if (F_Permissao) then
    begin
        DataSet.FieldByName('VALIDADO_F').AsBoolean := DataSet.FieldByName('VALIDADO').AsBoolean;
        DataSet.FieldByName('HABILITADO_F').AsBoolean := DataSet.FieldByName('HABILITADO').AsBoolean;
    end;

end;

procedure Tfprincipal.MDMultiLojaModuloConfAfterScroll(DataSet: TDataSet);
begin
    if ((MDMultiLojaModuloConf.Active = False) or (MDMultiLojaModuloConf.RecordCount = 0) or (F_Navegar = False)) then
        exit;
    CarregaCampos;
end;

procedure Tfprincipal.MDMultiLojaModuloConfFuncaoCalcFields(DataSet: TDataSet);
begin
    if (F_Permissao) then
    begin
        DataSet.FieldByName('VALIDADO_F').AsBoolean := DataSet.FieldByName('VALIDADO').AsBoolean;
        DataSet.FieldByName('HABILITADO_F').AsBoolean := DataSet.FieldByName('HABILITADO').AsBoolean;
    end;
end;

procedure Tfprincipal.MDPdvFuncaoCalcFields(DataSet: TDataSet);
begin
    if (F_Permissao) then
    begin
        DataSet.FieldByName('VALIDADO_F').AsBoolean := DataSet.FieldByName('VALIDADO').AsBoolean;
        DataSet.FieldByName('HABILITADO_F').AsBoolean := DataSet.FieldByName('HABILITADO').AsBoolean;
    end;
end;

procedure Tfprincipal.MDPdvModuloAfterScroll(DataSet: TDataSet);
begin
    if ((MDPdvModulo.Active = False) or (MDPdvModulo.RecordCount = 0) or (F_Navegar = False)) then
        exit;
    CarregaCampos;
end;

procedure Tfprincipal.MDPinPadFuncaoCalcFields(DataSet: TDataSet);
begin
    if (F_Permissao) then
    begin
        DataSet.FieldByName('VALIDADO_F').AsBoolean := DataSet.FieldByName('VALIDADO').AsBoolean;
        DataSet.FieldByName('HABILITADO_F').AsBoolean := DataSet.FieldByName('HABILITADO').AsBoolean;
    end;
end;

procedure Tfprincipal.MDTagsAfterScroll(DataSet: TDataSet);
begin
    if ((MDTags.Active = False) or (MDTags.RecordCount = 0) or (F_Navegar = False)) then
        exit;
    CarregaCampos;
end;

procedure Tfprincipal.MDTagsFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin

end;

procedure Tfprincipal.TabAdquirenteBAdicionarClick(Sender: TObject);
var
    VL_Status: integer;
    VL_Mensagem: TMensagem;
    VL_Codigo: integer;
    VL_ID: int64;
    VL_Retorno, VL_Tag: string;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            Desconectar;
            Exit;
        end;
        if MDAdquirente.Active = False then
        begin
            ShowMessage('MDAdquirente não está ativo');
            Exit;
        end;

        if GravaRegistros('TabAdquirente', True) then
        begin
            VL_Codigo := IncluirRegistro(MDAdquirente, '00DE', 'S', '0082', VL_Tag);
            if VL_Codigo <> 0 then
            begin
                ShowMessage(IntToStr(VL_Codigo));
                exit;
            end;

            VL_Mensagem.Limpar;
            VL_Mensagem.CarregaTags(VL_Tag);
            VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

            case VL_Retorno of
                '0026':
                begin
                    VL_Mensagem.GetTag('0026', VL_Tag);
                    ShowMessage('ERRO:' + VL_Tag);
                    if MDAdquirente.Locate('ID', 0, []) then
                        MDAdquirente.Delete;
                    Exit;
                end;
                '00DE':
                begin
                    if VL_Tag <> 'R' then
                    begin
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                        Exit;
                    end;
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    if vl_tag <> '0' then
                    begin
                        ShowMessage('ERRO:' + VL_Tag);
                        if MDAdquirente.Locate('ID', 0, []) then
                            MDAdquirente.Delete;
                        Exit;
                    end;
                    VL_Mensagem.GetTag('006F', VL_ID); //RETORNO DO ID DO ADQUIRENTE
                    F_Navegar := False;
                    if MDAdquirente.Locate('ID', 0, []) then
                    begin
                        MDAdquirente.Edit;
                        MDAdquirente.FieldByName('ID').AsInteger := VL_ID;
                        MDAdquirente.Post;
                    end;
                end;
            end;
            CarregaCampos;
            ShowMessage('Registro incluido com sucesso');
        end;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;
end;

procedure Tfprincipal.TabAdquirenteBExcluirClick(Sender: TObject);
var
    VL_Status: integer;
    VL_Codigo: integer;
    VL_Mensagem: TMensagem;
    VL_Retorno, VL_Tag: string;
    VL_ID: int64;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            Desconectar;
            Exit;
        end;
        if MDAdquirente.Active = False then
        begin
            ShowMessage('MDAdquirente não está ativo');
            Exit;
        end;
        if length(TabAdquirenteEID.Text) = 0 then
        begin
            ShowMessage('Não existe registro selecionado para exclusão');
            Exit;
        end;

        VL_Codigo := ExcluirRegistro('006F', StrToInt(TabAdquirenteEID.Text), '00E0', 'S', VL_Tag);

        if VL_Codigo <> 0 then
        begin
            ShowMessage(IntToStr(VL_Codigo));
            exit;
        end;
        VL_Mensagem.Limpar;
        VL_Mensagem.CarregaTags(VL_Tag);
        VL_Mensagem.GetComando(VL_Retorno, VL_Tag);
        case VL_Retorno of
            '0026':
            begin
                VL_Mensagem.GetTag('0026', VL_ID);
                ShowMessage('ERRO:' + IntToStr(VL_ID));
                Exit;
            end;
            '00E0':
            begin
                if VL_Tag <> 'R' then
                begin
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                    Exit;
                end;
                VL_Mensagem.GetTag('004D', VL_Tag);
                if vl_tag <> '0' then
                begin
                    VL_Mensagem.GetTag('004D', VL_ID);
                    ShowMessage('ERRO:' + IntToStr(VL_ID));
                    Exit;
                end;
                VL_Mensagem.GetTag('006F', VL_ID);
                F_Navegar := False;
                if MDAdquirente.Locate('ID', VL_ID, []) then
                    MDAdquirente.Delete;
            end;
        end;
        CarregaCampos;
        ShowMessage('Registro Excluido com sucesso');
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;

end;

procedure Tfprincipal.TabAdquirenteBModificarClick(Sender: TObject);
var
    VL_Status: integer;
begin
    VL_Status := 0;
    F_OpenTefStatus(VL_Status);
    if VL_Status <> Ord(csLogado) then
    begin
        ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
        Desconectar;
        Exit;
    end;
    if MDAdquirente.Active = False then
    begin
        ShowMessage('MDAdquirente não está ativo');
        Exit;
    end;

    if GravaRegistros('TabAdquirente', False) then
        AlterarRegistro('0082', MDAdquirente, '006F', StrToInt(TabAdquirenteEID.Text), '00DF', 'S');
end;

procedure Tfprincipal.TabAdquirenteEFiltroChange(Sender: TObject);
var
    VL_Filtro: string;
begin
    VL_Filtro := '';

    MDAdquirente.Filter := FiltrarTabela(TabAdquirenteGrid, VL_Filtro, TabAdquirenteEFiltro);
    TabAdquirenteLFiltro.Caption := VL_Filtro;
    MDAdquirente.Filtered := True;

end;

procedure Tfprincipal.TabConfiguracaoContextPopup(Sender: TObject; MousePos: TPoint; var Handled: boolean);
begin

end;

procedure Tfprincipal.TabFuncaoModuloConfShow(Sender: TObject);
begin

end;

procedure Tfprincipal.TabLojaFuncaoCKSelecionadaChange(Sender: TObject);
begin
    if TabLojaFuncaoCKSelecionada.Checked then
    begin
        MDLojaFuncao.Filter := 'VALIDADO=''T''';
        MDLojaFuncao.Filtered := True;
    end
    else
    begin
        MDLojaFuncao.Filter := '';
        MDLojaFuncao.Filtered := False;
    end;
end;

procedure Tfprincipal.TabLojaFuncaoEFiltroChange(Sender: TObject);
var
    VL_Filtro: string;
begin
    if F_Permissao = False then
        EXIT;
    VL_Filtro := '';
    MDLojaFuncao.Filter := FiltrarTabela(TabLojaFuncaoGrid, VL_Filtro, TabLojaFuncaoEFiltro);
    TabLojaFuncaoLFiltro.Caption := VL_Filtro;
    MDLojaFuncao.Filtered := True;
end;

procedure Tfprincipal.TabLojaFuncaoGridCellClick(Column: TColumn);
var
    VL_Status: integer;
    VL_Mensagem: TMensagem;
    VL_Codigo: integer;
    VL_ID: int64;
    VL_Retorno, VL_Tag: string;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    if TabLojaFuncaoGrid.SelectedColumn.FieldName <> 'VALIDADO_F' then
        TabLojaFuncaoLFiltro.Caption := 'Filtrar por ' + TabLojaFuncaoGrid.SelectedColumn.Title.Caption;
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            Desconectar;
            Exit;
        end;
        if ((MDLoja.Active = False) or (MDLoja.RecordCount < 1)) then
            exit;
        if ((MDLojaFuncao.Active = False) or (MDLojaFuncao.RecordCount < 1)) then
            exit;
        F_Navegar := False;
        if ((TabLojaFuncaoGrid.SelectedColumn.FieldName = 'VALIDADO_F') or
            (TabLojaFuncaoGrid.SelectedColumn.FieldName = 'HABILITADO_F')) then
        begin
            VL_ID := MDLojaFuncaoID.AsInteger;
            if (TabLojaFuncaoGrid.SelectedColumn.FieldName = 'VALIDADO_F') then
            begin
                MDLojaFuncao.Edit;
                MDLojaFuncao.FieldByName('VALIDADO').AsBoolean := not MDLojaFuncao.FieldByName('VALIDADO').AsBoolean;
                MDLojaFuncao.Post;
            end;
            if (TabLojaFuncaoGrid.SelectedColumn.FieldName = 'HABILITADO_F') then
            begin
                MDLojaFuncao.Edit;
                MDLojaFuncao.FieldByName('HABILITADO').AsBoolean := not MDLojaFuncao.FieldByName('HABILITADO').AsBoolean;
                MDLojaFuncao.Post;
            end;

            if ((MDLojaFuncao.FieldByName('VALIDADO').AsBoolean = True) and (VL_ID < 1)) then
            begin
                MDLojaFuncao.Edit;
                MDLojaFuncao.FieldByName('LOJA_ID').AsString := MDLoja.FieldByName('ID').AsString;
                MDLojaFuncao.FieldByName('ID').AsInteger := 0;
                MDLojaFuncao.Post;
                //incluir LOJA função
                VL_Codigo := IncluirRegistro(MDLojaFuncao, '00AA', 'S', '00A7', VL_Tag);
                if VL_Codigo <> 0 then
                begin
                    ShowMessage(IntToStr(VL_Codigo));
                    exit;
                end;

                VL_Mensagem.Limpar;
                VL_Mensagem.CarregaTags(VL_Tag);
                VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

                case VL_Retorno of
                    '0026':
                    begin
                        VL_Mensagem.GetTag('0026', VL_Tag);
                        ShowMessage('ERRO:' + VL_Tag);
                        if MDLojaFuncao.Locate('ID', 0, []) then
                            MDLojaFuncao.Delete;
                        Exit;
                    end;
                    '00AA':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                            Exit;
                        end;
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        if vl_tag <> '0' then
                        begin
                            ShowMessage('ERRO:' + VL_Tag);
                            if MDLojaFuncao.Locate('ID', 0, []) then
                                MDLojaFuncao.Delete;
                            Exit;
                        end;
                        VL_Mensagem.GetTag('00AB', VL_ID); //RETORNO DO ID DO LOJA_FUNCAO
                        F_Navegar := False;
                        if MDLojaFuncao.Locate('ID', 0, []) then
                        begin
                            MDLojaFuncao.Edit;
                            MDLojaFuncao.FieldByName('ID').AsInteger := VL_ID;
                            MDLojaFuncao.Post;
                        end;
                    end;
                end;
            end
            else
            if ((MDLojaFuncao.FieldByName('VALIDADO').AsBoolean = True) and (VL_ID > 0)) then
            begin
                //ALTERA LOJA_FUNCAO
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00AC', 'S');
                VL_Mensagem.AddTag('00AB', VL_ID);
                VL_Mensagem.AddTag('00A8', MDLojaFuncao.FieldByName('HABILITADO').AsString);
                VL_Mensagem.TagToStr(VL_Tag);
                VL_Codigo := SolicitacaoBloc(VL_Tag, VL_Tag, C_TempoSolicitacao);
                if VL_Codigo <> 0 then
                begin
                    ShowMessage(IntToStr(VL_Codigo));
                    exit;
                end;

                VL_Mensagem.Limpar;
                VL_Mensagem.CarregaTags(VL_Tag);
                VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

                case VL_Retorno of
                    '0026':
                    begin
                        VL_Mensagem.GetTag('0026', VL_Tag);
                        ShowMessage('ERRO:' + VL_Tag);
                        if MDLojaFuncao.Locate('ID', 0, []) then
                            MDLojaFuncao.Delete;
                        Exit;
                    end;
                    '00AC':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                            Exit;
                        end;
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        if vl_tag <> '0' then
                        begin
                            ShowMessage('ERRO:' + VL_Tag);
                            Exit;
                        end;
                    end;
                end;
            end
            else
            begin
                //alterar multloja função
                VL_Codigo := ExcluirRegistro('00AB', VL_ID, '00AD', 'S', VL_Tag);

                if VL_Codigo <> 0 then
                begin
                    ShowMessage(IntToStr(VL_Codigo));
                    exit;
                end;
                VL_Mensagem.Limpar;
                VL_Mensagem.CarregaTags(VL_Tag);
                VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

                case VL_Retorno of
                    '0026':
                    begin
                        VL_Mensagem.GetTag('0026', VL_Tag);
                        ShowMessage('ERRO:' + VL_Tag);
                        if MDLojaFuncao.Locate('ID', 0, []) then
                            MDLojaFuncao.Delete;
                        Exit;
                    end;
                    '00AD':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                            Exit;
                        end;
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        if vl_tag <> '0' then
                        begin
                            ShowMessage('ERRO:' + VL_Tag);
                            Exit;
                        end;
                    end;
                end;
                MDLojaFuncao.Edit;
                MDLojaFuncao.FieldByName('ID').AsInteger := -1;
                MDLojaFuncao.Post;
            end;
        end;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;
end;

procedure Tfprincipal.TabLojaFuncaoMNotaChange(Sender: TObject);
begin

end;

procedure Tfprincipal.PTopoClick(Sender: TObject);
begin

end;

procedure Tfprincipal.TabConfBExcluirClick(Sender: TObject);
var
    VL_Status: integer;
    VL_Codigo: integer;
    VL_Mensagem: TMensagem;
    VL_Retorno, VL_Tag: string;
    VL_ID: int64;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            Desconectar;
            Exit;
        end;
        if MDConfigurador.Active = False then
        begin
            ShowMessage('MDConfigurador não está ativo');
            Exit;
        end;
        if length(TabConfEID.Text) = 0 then
        begin
            ShowMessage('Não existe registro selecionado para exclusão');
            Exit;
        end;

        VL_Codigo := ExcluirRegistro('0056', StrToInt(TabConfEID.Text), '00BB', 'S', VL_Tag);

        if VL_Codigo <> 0 then
        begin
            ShowMessage(IntToStr(VL_Codigo));
            exit;
        end;
        VL_Mensagem.Limpar;
        VL_Mensagem.CarregaTags(VL_Tag);
        VL_Mensagem.GetComando(VL_Retorno, VL_Tag);
        case VL_Retorno of
            '0026':
            begin
                VL_Mensagem.GetTag('0026', VL_ID);
                ShowMessage('ERRO:' + IntToStr(VL_ID));
                Exit;
            end;
            '00BB':
            begin
                if VL_Tag <> 'R' then
                begin
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                    Exit;
                end;
                VL_Mensagem.GetTag('004D', VL_Tag);
                if vl_tag <> '0' then
                begin
                    VL_Mensagem.GetTag('004D', VL_ID);
                    ShowMessage('ERRO:' + IntToStr(VL_ID));
                    Exit;
                end;
                VL_Mensagem.GetTag('0056', VL_ID);
                F_Navegar := False;
                if MDConfigurador.Locate('ID', VL_ID, []) then
                    MDConfigurador.Delete;
            end;
        end;
        CarregaCampos;
        ShowMessage('Registro Excluido com sucesso');
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;
end;


procedure Tfprincipal.TabConfiguracaoBAdicionarBinClick(Sender: TObject);
var
    VL_Status: integer;
    VL_Mensagem: TMensagem;
    VL_Codigo: integer;
    VL_ID: int64;
    VL_Retorno, VL_Tag: string;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            Desconectar;
            Exit;
        end;
        if MDBin.Active = False then
        begin
            ShowMessage('MDBin não está ativo');
            Exit;
        end;
        if TabConfiguracaoEBin.Text = '' then
        begin
            ShowMessage('Número do B.I.N é um campo obrigatório');
            exit;
        end;

        if GravaRegistros('TabBin', True) then
        begin
            VL_Codigo := IncluirRegistro(MDBin, '0077', 'S', '0083', VL_Tag);
            if VL_Codigo <> 0 then
            begin
                ShowMessage(IntToStr(VL_Codigo));
                exit;
            end;

            VL_Mensagem.Limpar;
            VL_Mensagem.CarregaTags(VL_Tag);
            VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

            case VL_Retorno of
                '0026':
                begin
                    VL_Mensagem.GetTag('0026', VL_Tag);
                    ShowMessage('ERRO:' + VL_Tag);
                    if MDBin.Locate('ID', 0, []) then
                        MDBin.Delete;
                    Exit;
                end;
                '0077':
                begin
                    if VL_Tag <> 'R' then
                    begin
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                        Exit;
                    end;

                    VL_Mensagem.GetTag('004D', VL_Tag);
                    if vl_tag <> '0' then
                    begin
                        ShowMessage('ERRO:' + VL_Tag);
                        if MDBin.Locate('ID', 0, []) then
                            MDBin.Delete;
                        Exit;
                    end;
                    VL_Mensagem.GetTag('0076', VL_ID); //RETORNO DO ID DO BIN
                    F_Navegar := False;
                    if MDBin.Locate('ID', 0, []) then
                    begin
                        MDBin.Edit;
                        MDBin.FieldByName('ID').AsInteger := VL_ID;
                        MDBin.Post;
                    end;
                end;
            end;
            CarregaCampos;
            ShowMessage('Registro incluido com sucesso');
        end;
    finally
        VL_Mensagem.Free;
        TabConfiguracaoEBin.Text := '';
        F_Navegar := True;
    end;
end;

procedure Tfprincipal.TabConfiguracaoBAdicionarClick(Sender: TObject);
var
    VL_Status: integer;
    VL_Mensagem: TMensagem;
    VL_Codigo: integer;
    VL_ID: int64;
    VL_Retorno, VL_Tag: string;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            Desconectar;
            Exit;
        end;
        if MDModuloConfig.Active = False then
        begin
            ShowMessage('MDModuloConf não está ativo');
            Exit;
        end;
        if TabConfiguracaoEDescricao.Text = '' then
        begin
            ShowMessage('Descricao é um campo obrigatório');
            exit;
        end;
        TabConfiguracaoEChave.Lines.Clear;

        if GravaRegistros('TabModuloConf', True) then
        begin
            VL_Codigo := IncluirRegistro(MDModuloConfig, '0073', 'S', '003A', VL_Tag);
            if VL_Codigo <> 0 then
            begin
                ShowMessage(IntToStr(VL_Codigo));
                exit;
            end;

            VL_Mensagem.Limpar;
            VL_Mensagem.CarregaTags(VL_Tag);
            VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

            case VL_Retorno of
                '0026':
                begin
                    VL_Mensagem.GetTag('0026', VL_Tag);
                    ShowMessage('ERRO:' + VL_Tag);
                    if MDModuloConfig.Locate('ID', 0, []) then
                        MDModuloConfig.Delete;
                    Exit;
                end;
                '0073':
                begin
                    if VL_Tag <> 'R' then
                    begin
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                        Exit;
                    end;
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    if vl_tag <> '0' then
                    begin
                        ShowMessage('ERRO:' + VL_Tag);
                        if MDModuloConfig.Locate('ID', 0, []) then
                            MDModuloConfig.Delete;
                        Exit;
                    end;
                    VL_Mensagem.GetTag('007B', VL_ID); //RETORNO DO ID DO MODULO_CONF
                    F_Navegar := False;
                    if MDModuloConfig.Locate('ID', 0, []) then
                    begin
                        MDModuloConfig.Edit;
                        MDModuloConfig.FieldByName('ID').AsInteger := VL_ID;
                        MDModuloConfig.Post;
                    end;
                end;
            end;
            CarregaCampos;
            ShowMessage('Registro incluido com sucesso');
        end;

    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;

end;

procedure Tfprincipal.TabConfiguracaoBExcluirBinClick(Sender: TObject);
var
    VL_Status: integer;
    VL_Codigo: integer;
    VL_Mensagem: TMensagem;
    VL_Retorno, VL_Tag: string;
    VL_ID: int64;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            Desconectar;
            Exit;
        end;
        if MDBin.Active = False then
        begin
            ShowMessage('MDBin não está ativo');
            Exit;
        end;
        if TabConfiguracaoGridBin.DataSource.DataSet.IsEmpty then
        begin
            ShowMessage('Não existe Bin para ser excluido');
            exit;
        end;
        VL_Codigo := ExcluirRegistro('0076', StrToInt(MDBin.FieldByName('ID').AsString), '0078', 'S', VL_Tag);

        if VL_Codigo <> 0 then
        begin
            ShowMessage(IntToStr(VL_Codigo));
            exit;
        end;
        VL_Mensagem.Limpar;
        VL_Mensagem.CarregaTags(VL_Tag);
        VL_Mensagem.GetComando(VL_Retorno, VL_Tag);
        case VL_Retorno of
            '0026':
            begin
                VL_Mensagem.GetTag('0026', VL_ID);
                ShowMessage('ERRO:' + IntToStr(VL_ID));
                Exit;
            end;
            '0078':
            begin
                if VL_Tag <> 'R' then
                begin
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                    Exit;
                end;
                VL_Mensagem.GetTag('004D', VL_Tag);
                if vl_tag <> '0' then
                begin
                    VL_Mensagem.GetTag('004D', VL_ID);
                    ShowMessage('ERRO:' + IntToStr(VL_ID));
                    Exit;
                end;
                VL_Mensagem.GetTag('0076', VL_ID); //BIN_ID
                F_Navegar := False;
                if MDBin.Locate('ID', VL_ID, []) then
                    MDBin.Delete;
            end;
        end;
        ShowMessage('Registro Excluido com sucesso');

    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;
end;

procedure Tfprincipal.TabConfiguracaoBExcluirClick(Sender: TObject);
var
    VL_Status: integer;
    VL_Codigo: integer;
    VL_Mensagem: TMensagem;
    VL_Retorno, VL_Tag: string;
    VL_ID: int64;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            Desconectar;
            Exit;
        end;
        if MDModuloConfig.Active = False then
        begin
            ShowMessage('MDModuloConfig não está ativo');
            Exit;
        end;
        if length(MDModuloConfig.FieldByName('ID').AsString) = 0 then
        begin
            ShowMessage('Não existe registro selecionado para exclusão');
            Exit;
        end;

        VL_Codigo := ExcluirRegistro('007B', StrToInt(MDModuloConfig.FieldByName('ID').AsString), '00BA', 'S', VL_Tag);

        if VL_Codigo <> 0 then
        begin
            ShowMessage(IntToStr(VL_Codigo));
            exit;
        end;
        VL_Mensagem.Limpar;
        VL_Mensagem.CarregaTags(VL_Tag);
        VL_Mensagem.GetComando(VL_Retorno, VL_Tag);
        case VL_Retorno of
            '0026':
            begin
                VL_Mensagem.GetTag('0026', VL_ID);
                ShowMessage('ERRO:' + IntToStr(VL_ID));
                Exit;
            end;
            '00BA':
            begin
                if VL_Tag <> 'R' then
                begin
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                    Exit;
                end;
                VL_Mensagem.GetTag('004D', VL_Tag);
                if vl_tag <> '0' then
                begin
                    VL_Mensagem.GetTag('004D', VL_ID);
                    ShowMessage('ERRO:' + IntToStr(VL_ID));
                    Exit;
                end;
                VL_Mensagem.GetTag('007B', VL_ID);
                F_Navegar := False;
                if MDModuloConfig.Locate('ID', VL_ID, []) then
                    MDModuloConfig.Delete;
            end;
        end;
        CarregaCampos;
        ShowMessage('Registro Excluido com sucesso');
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;

end;

procedure Tfprincipal.TabConfiguracaoBGerarChaveClick(Sender: TObject);
var
    VL_Mensagem: TMensagem;
    VL_Chave: string;
    VL_Tag: ansistring;
    VL_Codigo: integer;
    VL_Retorno: ansistring;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Tag := '';
    VL_Codigo := 0;
    try
        CriarChaveTerminal(VL_Chave);
        if Length(VL_Chave) = 0 then
        begin
            ShowMessage('Erro ao gerar chave');
            exit;
        end;
        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('0071', ''); //VALIDA CHAVE
        VL_Mensagem.AddTag('0041', VL_Chave);
        VL_Mensagem.TagToStr(VL_Tag);
        VL_Codigo := SolicitacaoBloc(VL_Tag, VL_Tag, C_TempoSolicitacao);
        if VL_Codigo <> 0 then
        begin
            ShowMessage('Erro:' + IntToStr(VL_Codigo));
            Exit;
        end;
        VL_Mensagem.Limpar;
        VL_Mensagem.CarregaTags(VL_Tag);
        VL_Mensagem.GetComando(VL_Retorno, VL_Tag);
        case VL_Retorno of
            '0026':
            begin
                VL_Mensagem.GetTag('0026', VL_Tag);
                ShowMessage('ERRO:' + VL_Tag);
                Exit;
            end;
            '004D':
            begin
                if VL_TAG <> '0' then
                begin
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    ShowMessage('ERRO:' + VL_Tag);
                    Exit;
                end;
                TabConfiguracaoEChave.Lines.Text := VL_Chave;
            end;
        end;
    finally
        VL_Mensagem.Free;
    end;

end;

procedure Tfprincipal.TabConfiguracaoBModificarClick(Sender: TObject);
var
    VL_Status: integer;
begin
    VL_Status := 0;
    F_OpenTefStatus(VL_Status);
    if VL_Status <> Ord(csLogado) then
    begin
        ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
        Desconectar;
        Exit;
    end;
    if MDModuloConfig.Active = False then
    begin
        ShowMessage('MDModuloConfig não está ativo');
        Exit;
    end;
    if ((TabConfiguracaoEID.Text = '') or (TabConfiguracaoEID.Text = '0')) then
    begin
        ShowMessage('Operação cancelada, selecione uma configuração para alterar');
        exit;
    end;
    if GravaRegistros('TabModuloConf', False) then
        AlterarRegistro('003A', MDModuloConfig, '007B', StrToInt(TabConfiguracaoEID.Text), '0072', 'S');

end;

procedure Tfprincipal.TabConfiguracaoBPesquisarAdquirenteClick(Sender: TObject);
var
    VL_FPesquisaAdquirente: TFAdquirente;
begin
    VL_FPesquisaAdquirente := TFAdquirente.Create(Self);
    VL_FPesquisaAdquirente.F_Tabela := RxMemDataToStr(MDAdquirente);
    VL_FPesquisaAdquirente.ShowModal;
    if VL_FPesquisaAdquirente.F_Carregado then
    begin
        F_Navegar := False;
        MDModuloConfig.Edit;
        MDModuloConfig.FieldByName('ADQUIRENTE_ID').AsString := VL_FPesquisaAdquirente.MDAdquirente.FieldByName('ID').AsString;
        MDModuloConfig.FieldByName('ADQUIRENTE_DESCRICAO').AsString := VL_FPesquisaAdquirente.MDAdquirente.FieldByName('DESCRICAO').AsString;
        MDModuloConfig.Post;
        F_Navegar := True;
        CarregaCampos;
    end;

end;



procedure Tfprincipal.TabConfiguracaoShow(Sender: TObject);
begin
    if ((F_Navegar) and (F_Permissao)) then
        //carrega moduloconfig
        CarregarTabelas(False, '0091', '006C', MDModulo.FieldByName('ID').AsInteger);

end;

procedure Tfprincipal.TabFuncaoModuloCKSelecionadaChange(Sender: TObject);
begin
    if TabFuncaoModuloCKSelecionada.Checked then
    begin
        MDModuloFunc.Filter := 'VALIDADO=''T''';
        MDModuloFunc.Filtered := True;
    end
    else
    begin
        MDModuloFunc.Filter := '';
        MDModuloFunc.Filtered := False;
    end;
end;

procedure Tfprincipal.TabFuncaoModuloEFiltroChange(Sender: TObject);
var
    VL_Filtro: string;
begin
    if F_Permissao = False then
        EXIT;
    VL_Filtro := '';
    MDModuloFunc.Filter := FiltrarTabela(TabFuncaoModuloGrid, VL_Filtro, TabFuncaoModuloEFiltro);
    TabFuncaoModuloLFiltro.Caption := VL_Filtro;
    MDModuloFunc.Filtered := True;
end;

procedure Tfprincipal.TabFuncaoModuloGridCellClick(Column: TColumn);
var
    VL_Status: integer;
    VL_Mensagem: TMensagem;
    VL_Codigo: integer;
    VL_ID: int64;
    VL_Retorno, VL_Tag: string;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    if TabFuncaoModuloGrid.SelectedColumn.FieldName <> 'VALIDADO_F' then
        TabFuncaoModuloLFiltro.Caption := 'Filtrar por ' + TabFuncaoModuloGrid.SelectedColumn.Title.Caption;
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            Desconectar;
            Exit;
        end;
        if ((MDModulo.Active = False) or (MDModulo.RecordCount < 1)) then
            exit;
        if ((MDModuloFunc.Active = False) or (MDModuloFunc.RecordCount < 1)) then
            exit;
        F_Navegar := False;
        if ((Column.FieldName = 'VALIDADO_F') or (Column.FieldName = 'HABILITADO_F')) then
        begin
            VL_ID := MDModuloFuncID.AsInteger;
            if (Column.FieldName = 'VALIDADO_F') then
            begin
                MDModuloFunc.Edit;
                MDModuloFunc.FieldByName('VALIDADO').AsBoolean := not MDModuloFunc.FieldByName('VALIDADO').AsBoolean;
                MDModuloFunc.Post;
            end;
            if (Column.FieldName = 'HABILITADO_F') then
            begin
                MDModuloFunc.Edit;
                MDModuloFunc.FieldByName('HABILITADO').AsBoolean := not MDModuloFunc.FieldByName('HABILITADO').AsBoolean;
                MDModuloFunc.Post;
            end;
            if ((MDModuloFunc.FieldByName('VALIDADO').AsBoolean = True) and (VL_ID < 1)) then
            begin
                MDModuloFunc.Edit;
                MDModuloFunc.FieldByName('MODULO_ID').AsString := TabModuloEID.Text;
                MDModuloFunc.FieldByName('ID').AsInteger := 0;
                MDModuloFunc.Post;
                //incluir modulo função
                VL_Codigo := IncluirRegistro(MDModuloFunc, '007E', 'S', '0092', VL_Tag);
                if VL_Codigo <> 0 then
                begin
                    ShowMessage(IntToStr(VL_Codigo));
                    exit;
                end;

                VL_Mensagem.Limpar;
                VL_Mensagem.CarregaTags(VL_Tag);
                VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

                case VL_Retorno of
                    '0026':
                    begin
                        VL_Mensagem.GetTag('0026', VL_Tag);
                        ShowMessage('ERRO:' + VL_Tag);
                        if MDModuloFunc.Locate('ID', 0, []) then
                            MDModuloFunc.Delete;
                        Exit;
                    end;
                    '007E':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                            Exit;
                        end;
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        if vl_tag <> '0' then
                        begin
                            ShowMessage('ERRO:' + VL_Tag);
                            if MDModuloFunc.Locate('ID', 0, []) then
                                MDModuloFunc.Delete;
                            Exit;
                        end;
                        VL_Mensagem.GetTag('008B', VL_ID); //RETORNO DO ID DO MODULO_FUNC
                        F_Navegar := False;
                        if MDModuloFunc.Locate('ID', 0, []) then
                        begin
                            MDModuloFunc.Edit;
                            MDModuloFunc.FieldByName('ID').AsInteger := VL_ID;
                            MDModuloFunc.Post;
                        end;
                    end;
                end;
            end
            else
            if ((MDModuloFunc.FieldByName('VALIDADO').AsBoolean = True) and (VL_ID > 0)) then
            begin
                //ALTERA MODULO_FUNCAO
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00B9', 'S');
                VL_Mensagem.AddTag('008B', VL_ID);
                VL_Mensagem.AddTag('00C6', MDModuloConfFuncao.FieldByName('HABILITADO').AsString);
                VL_Mensagem.TagToStr(VL_Tag);
                VL_Codigo := SolicitacaoBloc(VL_Tag, VL_Tag, C_TempoSolicitacao);
                if VL_Codigo <> 0 then
                begin
                    ShowMessage(IntToStr(VL_Codigo));
                    exit;
                end;
                VL_Mensagem.Limpar;
                VL_Mensagem.CarregaTags(VL_Tag);
                VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

                case VL_Retorno of
                    '0026':
                    begin
                        VL_Mensagem.GetTag('0026', VL_Tag);
                        ShowMessage('ERRO:' + VL_Tag);
                        if MDModuloConfFuncao.Locate('ID', 0, []) then
                            MDModuloConfFuncao.Delete;
                        Exit;
                    end;
                    '00B9':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                            Exit;
                        end;
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        if vl_tag <> '0' then
                        begin
                            ShowMessage('ERRO:' + VL_Tag);
                            Exit;
                        end;
                    end;
                end;
            end
            else
            begin
                //EXCLUIR modulo função
                VL_Codigo := ExcluirRegistro('008B', VL_ID, '007F', 'S', VL_Tag);

                if VL_Codigo <> 0 then
                begin
                    ShowMessage(IntToStr(VL_Codigo));
                    exit;
                end;
                VL_Mensagem.Limpar;
                VL_Mensagem.CarregaTags(VL_Tag);
                VL_Mensagem.GetComando(VL_Retorno, VL_Tag);
                case VL_Retorno of
                    '0026':
                    begin
                        VL_Mensagem.GetTag('0026', VL_Tag);
                        ShowMessage('ERRO:' + VL_Tag);
                        if MDModuloConfFuncao.Locate('ID', 0, []) then
                            MDModuloConfFuncao.Delete;
                        Exit;
                    end;
                    '007F':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                            Exit;
                        end;
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        if vl_tag <> '0' then
                        begin
                            ShowMessage('ERRO:' + VL_Tag);
                            Exit;
                        end;
                    end;
                end;
                MDModuloFunc.Edit;
                MDModuloFunc.FieldByName('ID').AsInteger := -1;
                MDModuloFunc.Post;
            end;
        end;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;
end;

procedure Tfprincipal.TabLojaModuloEFiltroChangeBounds(Sender: TObject);
begin

end;

procedure Tfprincipal.TabLojaTabFuncaoDadosEFiltroChange(Sender: TObject);
var
    VL_Filtro: string;
begin
    if F_Permissao = False then
        EXIT;
    VL_Filtro := '';
    MDLojaModuloConfFuncao.Filter := FiltrarTabela(TabLojaTabFuncaoDadosGrid, VL_Filtro, TabLojaTabFuncaoDadosEFiltro);
    TabLojaTabFuncaoDadosLFiltro.Caption := VL_Filtro;
    MDLojaModuloConfFuncao.Filtered := True;

end;

procedure Tfprincipal.TabLojaTabFuncaoDadosGridCellClick(Column: TColumn);
var
    VL_Status: integer;
    VL_Mensagem: TMensagem;
    VL_Codigo: integer;
    VL_ID: int64;
    VL_Retorno, VL_Tag: string;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';

    if TabLojaTabFuncaoDadosGrid.SelectedColumn.FieldName <> 'VALIDADO_F' then
        TabLojaTabFuncaoDadosLFiltro.Caption := 'Filtrar por ' + TabLojaTabFuncaoDadosGrid.SelectedColumn.Title.Caption;
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            Desconectar;
            Exit;
        end;
        if ((MDLojaModuloConf.Active = False) or (MDLojaModuloConf.RecordCount < 1)) then
            exit;
        if ((MDLojaModuloConfFuncao.Active = False) or (MDLojaModuloConfFuncao.RecordCount < 1)) then
            exit;
        F_Navegar := False;
        if ((TabLojaTabFuncaoDadosGrid.SelectedColumn.FieldName = 'VALIDADO_F') or
            (TabLojaTabFuncaoDadosGrid.SelectedColumn.FieldName = 'HABILITADO_F')) then
        begin
            VL_ID := MDLojaModuloConfFuncaoID.AsInteger;
            if (TabLojaTabFuncaoDadosGrid.SelectedColumn.FieldName = 'VALIDADO_F') then
            begin
                MDLojaModuloConfFuncao.Edit;
                MDLojaModuloConfFuncao.FieldByName('VALIDADO').AsBoolean := not MDLojaModuloConfFuncao.FieldByName('VALIDADO').AsBoolean;
                MDLojaModuloConfFuncao.Post;
            end;
            if (TabLojaTabFuncaoDadosGrid.SelectedColumn.FieldName = 'HABILITADO_F') then
            begin
                MDLojaModuloConfFuncao.Edit;
                MDLojaModuloConfFuncao.FieldByName('HABILITADO').AsBoolean := not MDLojaModuloConfFuncao.FieldByName('HABILITADO').AsBoolean;
                MDLojaModuloConfFuncao.Post;
            end;

            if ((MDLojaModuloConfFuncao.FieldByName('VALIDADO').AsBoolean = True) and (VL_ID < 1)) then
            begin
                MDLojaModuloConfFuncao.Edit;
                MDLojaModuloConfFuncao.FieldByName('LOJA_MODULO_CONF_ID').AsString := MDLojaModuloConf.FieldByName('ID').AsString;
                MDLojaModuloConfFuncao.FieldByName('ID').AsInteger := 0;
                MDLojaModuloConfFuncao.Post;
                //incluir loja_modulo_conf_funcao
                VL_Codigo := IncluirRegistro(MDLojaModuloConfFuncao, '009B', 'S', '0098', VL_Tag);
                if VL_Codigo <> 0 then
                begin
                    ShowMessage(IntToStr(VL_Codigo));
                    exit;
                end;

                VL_Mensagem.Limpar;
                VL_Mensagem.CarregaTags(VL_Tag);
                VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

                case VL_Retorno of
                    '0026':
                    begin
                        VL_Mensagem.GetTag('0026', VL_Tag);
                        ShowMessage('ERRO:' + VL_Tag);
                        if MDLojaModuloConfFuncao.Locate('ID', 0, []) then
                            MDLojaModuloConfFuncao.Delete;
                        Exit;
                    end;
                    '009B':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                            Exit;
                        end;
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        if vl_tag <> '0' then
                        begin
                            ShowMessage('ERRO:' + VL_Tag);
                            if MDLojaModuloConfFuncao.Locate('ID', 0, []) then
                                MDLojaModuloConfFuncao.Delete;
                            Exit;
                        end;
                        VL_Mensagem.GetTag('00BC', VL_ID); //RETORNO DO ID DO LOJA_MODULO_CONF_FUNCAO
                        F_Navegar := False;
                        if MDLojaModuloConfFuncao.Locate('ID', 0, []) then
                        begin
                            MDLojaModuloConfFuncao.Edit;
                            MDLojaModuloConfFuncao.FieldByName('ID').AsInteger := VL_ID;
                            MDLojaModuloConfFuncao.Post;
                        end;
                    end;
                end;
            end
            else
            if ((MDLojaModuloConfFuncao.FieldByName('VALIDADO').AsBoolean = True) and (VL_ID > 0)) then
            begin
                //ALTERA LOJA_MODULO_CONF_FUNCAO
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00BF', 'S');
                VL_Mensagem.AddTag('00BC', VL_ID);
                VL_Mensagem.AddTag('0089', MDLojaModuloConfFuncao.FieldByName('HABILITADO').AsString);
                VL_Mensagem.TagToStr(VL_Tag);
                VL_Codigo := SolicitacaoBloc(VL_Tag, VL_Tag, C_TempoSolicitacao);
                if VL_Codigo <> 0 then
                begin
                    ShowMessage(IntToStr(VL_Codigo));
                    exit;
                end;

                VL_Mensagem.Limpar;
                VL_Mensagem.CarregaTags(VL_Tag);
                VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

                case VL_Retorno of
                    '0026':
                    begin
                        VL_Mensagem.GetTag('0026', VL_Tag);
                        ShowMessage('ERRO:' + VL_Tag);
                        if MDLojaModuloConfFuncao.Locate('ID', 0, []) then
                            MDLojaModuloConfFuncao.Delete;
                        Exit;
                    end;
                    '00BF':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                            Exit;
                        end;
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        if vl_tag <> '0' then
                        begin
                            ShowMessage('ERRO:' + VL_Tag);
                            Exit;
                        end;
                    end;
                end;
            end
            else
            begin
                //alterar multloja função
                VL_Codigo := ExcluirRegistro('00BC', VL_ID, '0087', 'S', VL_Tag);

                if VL_Codigo <> 0 then
                begin
                    ShowMessage(IntToStr(VL_Codigo));
                    exit;
                end;
                VL_Mensagem.Limpar;
                VL_Mensagem.CarregaTags(VL_Tag);
                VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

                case VL_Retorno of
                    '0026':
                    begin
                        VL_Mensagem.GetTag('0026', VL_Tag);
                        ShowMessage('ERRO:' + VL_Tag);
                        if MDLojaModuloConfFuncao.Locate('ID', 0, []) then
                            MDLojaModuloConfFuncao.Delete;
                        Exit;
                    end;
                    '0087':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                            Exit;
                        end;
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        if vl_tag <> '0' then
                        begin
                            ShowMessage('ERRO:' + VL_Tag);
                            Exit;
                        end;
                    end;
                end;
                MDLojaModuloConfFuncao.Edit;
                MDLojaModuloConfFuncao.FieldByName('ID').AsInteger := -1;
                MDLojaModuloConfFuncao.Post;
            end;
        end;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;
end;

procedure Tfprincipal.TabLojaTabFuncaoDadosShow(Sender: TObject);
begin
    if ((F_Navegar) and (F_Permissao)) then
        //carrega LOJA_MODULO_CONF_FUNCAO
        CarregarTabelas(False, '0098', '00AF', MDLojaModuloConf.FieldByName('ID').AsInteger);
end;

procedure Tfprincipal.TabLojaTabModuloDadosShow(Sender: TObject);
begin
    if ((F_Permissao) and (F_Navegar)) then
        CarregarTabelas(False, '00A7', '003C', MDLoja.FieldByName('ID').AsInteger);
end;


procedure Tfprincipal.TabModuloFuncaoShow(Sender: TObject);
begin
    if ((F_Navegar) and (F_Permissao)) then
        //carrega moduloFUNC
        CarregarTabelas(False, '0092', '006C', MDModulo.FieldByName('ID').AsInteger);
end;

procedure Tfprincipal.TabLojaBExcluirClick(Sender: TObject);
var
    VL_Status: integer;
    VL_Codigo: integer;
    VL_Mensagem: TMensagem;
    VL_Retorno, VL_Tag: string;
    VL_ID: int64;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            Desconectar;
            Exit;
        end;
        if MDLoja.Active = False then
        begin
            ShowMessage('MDLoja não está ativo');
            Exit;
        end;
        if length(TabLojaEID.Text) = 0 then
        begin
            ShowMessage('Não existe registro selecionado para exclusão');
            Exit;
        end;

        MDLoja.Locate('ID', TabLojaEID.Text, []);

        if MDLoja.FieldByName('MULT').AsString = 'T' then
        begin
            ShowMessage('Esta Loja esta configurada como Mult-Loja Master,não podera sofrer alteração');
            exit;
        end;
        VL_Codigo := ExcluirRegistro('003C', StrToInt(TabLojaEID.Text), '0069', 'S', VL_Tag);
        if VL_Codigo <> 0 then
        begin
            ShowMessage(IntToStr(VL_Codigo));
            exit;
        end;
        VL_Mensagem.Limpar;
        VL_Mensagem.CarregaTags(VL_Tag);
        VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

        case VL_Retorno of
            '0026':
            begin
                VL_Mensagem.GetTag('0026', VL_ID);
                ShowMessage('ERRO:' + IntToStr(VL_ID));
                Exit;
            end;
            '0069':
            begin
                if VL_Tag <> 'R' then
                begin
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                    Exit;
                end;
                VL_Mensagem.GetTag('004D', VL_Tag);
                if vl_tag <> '0' then
                begin
                    VL_Mensagem.GetTag('004D', VL_ID);
                    ShowMessage('ERRO:' + IntToStr(VL_ID));
                    Exit;
                end;
                F_Navegar := False;
                if MDLoja.Locate('ID', TabLojaEID.Text, []) then
                    MDLoja.Delete;
            end;
        end;
        ShowMessage('Registro Excluido com sucesso');
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;

end;

procedure Tfprincipal.TabLojaBModificarClick(Sender: TObject);
var
    VL_Status: integer;
begin
    F_OpenTefStatus(VL_Status);
    if VL_Status <> Ord(csLogado) then
    begin
        ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
        Desconectar;
        Exit;
    end;
    if MDLoja.Active = False then
    begin
        ShowMessage('MDLoja não está ativo');
        Exit;
    end;
    if TabLojaECnpj.Text = '' then
    begin
        ShowMessage('CNPJ é um campo obrigatório');
        exit;
    end;
    if TabLojaERazao.Text = '' then
    begin
        ShowMessage('Razão é um campo obrigatório');
        exit;
    end;

    if MDLoja.FieldByName('MULT').AsString = 'T' then
    begin
        ShowMessage('Esta Loja esta configurada como Mult-Loja Master,não podera sofrer alteração');
        exit;
    end;

    if (TabLojaCMultLoja.Text = '') then
    begin
        ShowMessage('Você deve selecionar uma Mult-Loja para incluir a Loja');
        exit;
    end;

    if GravaRegistros('TabLoja', False) then
        AlterarRegistro('003E', MDLoja, '003C', StrToInt(TabLojaEID.Text), '003F', 'S');

end;

procedure Tfprincipal.TabLojaBAdicionarClick(Sender: TObject);
var
    VL_Status: integer;
    VL_Mensagem: TMensagem;
    VL_Codigo: integer;
    VL_ID: int64;
    VL_Retorno, VL_Tag: string;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            Desconectar;
            Exit;
        end;
        if MDLoja.Active = False then
        begin
            ShowMessage('MDLoja não está ativo');
            Exit;
        end;
        if TabLojaECnpj.Text = '' then
        begin
            ShowMessage('CNPJ é um campo obrigatório');
            exit;
        end;
        if TabLojaERazao.Text = '' then
        begin
            ShowMessage('Razão é um campo obrigatório');
            exit;
        end;
        if (TabLojaCMultLoja.Text = '') then
        begin
            ShowMessage('Você deve selecionar uma Mult-Loja para incluir a Loja');
            exit;
        end;

        if GravaRegistros('TabLoja', True) then
        begin
            VL_Codigo := IncluirRegistro(MDLoja, '0039', 'S', '003E', VL_Tag);

            if VL_Codigo <> 0 then
            begin
                ShowMessage(IntToStr(VL_Codigo));
                exit;
            end;

            VL_Mensagem.Limpar;
            VL_Mensagem.CarregaTags(VL_Tag);
            VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

            case VL_Retorno of
                '0026':
                begin
                    VL_Mensagem.GetTag('0026', VL_Tag);
                    ShowMessage('ERRO:' + VL_Tag);
                    if MDLoja.Locate('ID', 0, []) then
                        MDLoja.Delete;
                    Exit;
                end;
                '0039':
                begin
                    if VL_Tag <> 'R' then
                    begin
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                        Exit;
                    end;
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    if vl_tag <> '0' then
                    begin
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        ShowMessage('ERRO:' + VL_Tag);
                        if MDLoja.Locate('ID', 0, []) then
                            MDLoja.Delete;
                        Exit;
                    end;
                    VL_Mensagem.GetTag('003C', VL_ID); //RETORNO DO ID DA LOJA
                    F_Navegar := False;
                    if MDLoja.Locate('ID', 0, []) then
                    begin
                        MDLoja.Edit;
                        MDLoja.FieldByName('ID').AsInteger := VL_ID;
                        MDLoja.Post;
                    end;
                end;
            end;
            CarregaCampos;
            ShowMessage('Registro incluido com sucesso');
        end;

    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;

end;

procedure Tfprincipal.FormCreate(Sender: TObject);

begin
    F_Navegar := True;
    F_Permissao := False;
    F_TipoConfigurador := pmS;

    F_ComLib := LoadLibrary(PChar(ExtractFilePath(ParamStr(0)) + '..\..\com_lib\win64\com_lib.dll'));
    Pointer(F_Inicializar) := GetProcAddress(F_ComLib, 'inicializar');
    Pointer(F_Finalizar) := GetProcAddress(F_ComLib, 'finalizar');
    Pointer(F_Desconectar) := GetProcAddress(F_ComLib, 'desconectar');
    Pointer(F_Login) := GetProcAddress(F_ComLib, 'login');
    Pointer(F_SolicitacaoBlocante) := GetProcAddress(F_ComLib, 'solicitacaoblocante');
    Pointer(F_OpenTefStatus) := GetProcAddress(F_ComLib, 'opentefstatus');

    F_Inicializar(@Retorno, PChar(ExtractFilePath(ParamStr(0)) + 'config_app_com_lib.log'));




    MDModuloFunc.Open;
    MDMultiLojaFuncao.Open;
    MDLojaFuncao.Open;
    MDPinPadFuncao.Open;
    MDPdvFuncao.Open;
    MDModuloConfFuncao.Open;
    MDMultiLojaModuloConfFuncao.Open;
    MDLojaModuloConfFuncao.Open;
end;

procedure Tfprincipal.FormShow(Sender: TObject);
begin
    LimparTela;
    //carrega pagetag
    PagePrincipal.TabIndex := 0;
    PageCadastroLoja.TabIndex := 0;
    PageMultiLojaVisualizarModuloFuncao.TabIndex := 0;
    PageMultiLojaVisualizaConfDadosFuncao.TabIndex := 0;
    TabPinPadPageModuloFuncao.TabIndex := 0;
    TabPdvPageModuloFuncao.TabIndex := 0;
    TabConf.TabVisible := False;
    TabModulo.TabVisible := False;
    TabTag.TabVisible := False;
    TabAdquirente.TabVisible := False;
end;

function Tfprincipal.ErroLogin(VP_Erro: integer): string;
begin
    if VP_Erro = 0 then
        exit;
    Result := '';

    case VP_Erro of
        36:
            Result := 'IP não informado para o TEF';
        37:
            Result := 'Senha não informada para o TEF';
        38:
            Result := 'IP não compativel para o Terminal';
        39:
            Result := 'Senha não compativel para o Terminal';
        40:
            Result := 'Erro ao validar o Terminal';
        41:
            Result := 'Chave do Terminal não localizada';
    end;
end;

procedure Tfprincipal.MDConfiguradorAfterScroll(DataSet: TDataSet);
begin
    if ((MDConfigurador.Active = False) or (MDConfigurador.RecordCount = 0) or (F_Navegar = False)) then
        exit;
    CarregaCampos;
end;

procedure Tfprincipal.CarregaCampos;
begin
    if F_Permissao = False then
        exit;
    //monta configurador
    if ((F_Permissao) and (F_TipoConfigurador = pmC)) then
    begin
        TabConf.TabVisible := True;
        TabModulo.TabVisible := True;
        TabTag.TabVisible := True;
        TabAdquirente.TabVisible := True;
    end
    else
    begin
        TabConf.TabVisible := False;
        TabModulo.TabVisible := False;
        TabTag.TabVisible := False;
        TabAdquirente.TabVisible := False;
    end;
    //TabMultLoja
    if ((MDMultiLoja.Active) and (MDLoja.Active) and (MDMultiLojaLoja.Active)) then
    begin
        TabMultLojaMDadosLoja.Clear;
        TabMultLojaMDadosLoja.Lines.add('ID:' + MDLoja.FieldByName('ID').AsString + ' CNPJ:' + MDLoja.FieldByName('CNPJ').AsString);
        TabMultLojaMDadosLoja.Lines.add('');
        TabMultLojaMDadosLoja.Lines.add('Razão:' + MDLoja.FieldByName('RAZAO').AsString);
        TabMultLojaMDadosLoja.Lines.add('Fantasia:' + MDLoja.FieldByName('FANTASIA').AsString);
        if MDLoja.FieldByName('HABILITADO').AsString = 'T' then
            TabMultLojaMDadosLoja.Lines.add('Loja Habilitado: Sim')
        else
            TabMultLojaMDadosLoja.Lines.add('Loja Habilitado: Não');
        TabMultLojaLRazaoLoja.Caption := 'Loja: ' + MDMultiLoja.FieldByName('RAZAO').AsString;

        if MDMultiLoja.FieldByName('HABILITADO').AsString = 'T' then
            TabMultLojaCkLojaMaster.Checked := True
        else
            TabMultLojaCkLojaMaster.Checked := False;

        //MULTLOJA_MODULO
        if MDMultiLojaModuloConf.Active = False then
            TabMultLojaTabModuloDados.OnShow(self);

        TabMultLojaModuloEID.Text := MDMultiLojaModuloConf.FieldByName('ID').AsString;
        TabMultLojaModuloECodigo.Text := MDMultiLojaModuloConf.FieldByName('CODIGO').AsString;
        TabMultLojaModuloEModuloConfID.Text := MDMultiLojaModuloConf.FieldByName('MODULO_CONF_ID').AsString;
        TabMultLojaModuloEModuloConf.Text := MDMultiLojaModuloConf.FieldByName('MODULO_CONF').AsString;

        if MDMultiLojaModuloConf.FieldByName('HABILITADO').AsString = 'T' then
            TabMultLojaModuloCkHabilitar.Checked := True
        else
            TabMultLojaModuloCkHabilitar.Checked := False;

        //TabLoja
        if MDMultiLojaLoja.Locate('ID', MDLoja.FieldByName('MULTILOJA_ID').AsInteger, []) then
        begin
            TabLojaCMultLoja.KeyValue := MDMultiLojaLoja.FieldByName('RAZAO').AsVariant;
        end
        else
        begin
            TabLojaCMultLoja.KeyValue := 'Não Definido';
        end;
        if MDLoja.FieldByName('HABILITADO').AsString = 'T' then
            TabLojaCkHabilitar.Checked := True
        else
            TabLojaCkHabilitar.Checked := False;
        TabLojaEID.Text := MDLoja.FieldByName('ID').AsString;
        TabLojaECnpj.Text := MDLoja.FieldByName('CNPJ').AsString;
        TabLojaERazao.Text := MDLoja.FieldByName('RAZAO').AsString;
        TabLojaEFantasia.Text := MDLoja.FieldByName('FANTASIA').AsString;

        if MDLoja.FieldByName('MULT').AsString = 'T' then
            TabLojaPPrincipal.Color := clSkyBlue
        else
            TabLojaPPrincipal.Color := clWhite;
        //TabLojaModulo

        if MDLojaModuloConf.Active = False then
            TabLojaTabModuloDados.OnShow(self);

        TabLojaModuloEID.Text := MDLojaModuloConf.FieldByName('ID').AsString;
        TabLojaModuloECodigo.Text := MDLojaModuloConf.FieldByName('CODIGO').AsString;
        if MDLojaModuloConf.FieldByName('HABILITADO').AsString = 'T' then
            TabLojaModuloCkHabilitar.Checked := True
        else
            TabLojaModuloCkHabilitar.Checked := False;
        TabLojaModuloEModuloConfID.Text := MDLojaModuloConf.FieldByName('MODULO_CONF_ID').AsString;
        TabLojaModuloEModuloConf.Text := MDLojaModuloConf.FieldByName('MODULO_CONF').AsString;
    end;
    //TabPinPad
    if MDPinPad.Active then
    begin
        TabPinPadEID.Text := MDPinPad.FieldByName('ID').AsString;
        TabPinPadMFabricante.Text := MDPinPad.FieldByName('FABRICANTE_MODELO').AsString;

    end;
    //TabPdv
    if MDPdv.Active then
    begin
        MDLojaPdv.Locate('ID', MDPdv.FieldByName('LOJA_ID').AsInteger, []);
        TabPdvCLoja.KeyValue := MDLojaPdv.FieldByName('RAZAO').AsVariant;
        MDPinPadPdv.Locate('ID', MDPdv.FieldByName('PINPAD_ID').AsInteger, []);
        TabPdvCPinPad.KeyValue := MDPinPadPdv.FieldByName('FABRICANTE_MODELO').AsVariant;
        TabPdvEID.Text := MDPdv.FieldByName('ID').AsString;
        TabPdvEIP.Text := MDPdv.FieldByName('IP').AsString;
        TabPdvEDescricao.Text := MDPdv.FieldByName('DESCRICAO').AsString;
        TabPdvECodigo.Text := MDPdv.FieldByName('CODIGO').AsString;
        TabPdvEPinPadCom.Text := MDPdv.FieldByName('PINPAD_COM').AsString;
        TabPdvEChave.Text := MDPdv.FieldByName('CHAVE').AsString;
        if MDPdv.FieldByName('HABILITADO').AsString = 'T' then
            TabPdvCkHabilitar.Checked := True
        else
            TabPdvCkHabilitar.Checked := False;

        //TabPdvModulo
        TabPDVModuloLDescricao.Caption := MDPdv.FieldByName('DESCRICAO').AsString;

        if MDPdvModulo.Active = False then
            TabPdvTabDadosModulo.OnShow(self);

        TabPDVModuloEID.Text := MDPdvModulo.FieldByName('ID').AsString;
        TabPDVModuloETagNumero.Text := MDPdvModulo.FieldByName('TAG_NUMERO').AsString;
        TabPDVModuloETag.Text := MDPdvModulo.FieldByName('DEFINICAO').AsString;
        TabPDVModuloEModuloConfID.Text := MDPdvModulo.FieldByName('MODULO_CONF_ID').AsString;
        TabPDVModuloEModuloConf.Text := MDPdvModulo.FieldByName('MODULO_CONF').AsString;
        if MDPdvModulo.FieldByName('HABILITADO').AsString = 'T' then
            TabPdvModuloCkHabilitar.Checked := True
        else
            TabPdvModuloCkHabilitar.Checked := False;
    end;
    //TabConfigurador
    if MDConfigurador.Active then
    begin
        TabConfEID.Text := MDConfigurador.FieldByName('ID').AsString;
        TabConfEDescricao.Text := MDConfigurador.FieldByName('DESCRICAO').AsString;
        TabConfEIP.Text := MDConfigurador.FieldByName('IP').AsString;
        TabConfEChave.Lines.Text := MDConfigurador.FieldByName('CHAVE').AsString;
        TabTipoConfESenha.Text := MDConfigurador.FieldByName('SENHA_CONFIGURADOR').AsString;
        TabTipoAdmESenha.Text := MDConfigurador.FieldByName('SENHA_ADMINISTRADOR').AsString;
        TabTipoUsuESenha.Text := MDConfigurador.FieldByName('SENHA_USUARIO').AsString;
    end;
    //TabModulo
    if (MDModulo.Active) then
    begin
        TabModuloEID.Text := MDModulo.FieldByName('ID').AsString;
        TabModuloEDescricao.Text := MDModulo.FieldByName('DESCRICAO').AsString;
        TabModuloETagModulo.Text := MDModulo.FieldByName('TAG_NUMERO').AsString;
    end;
    if ((MDModuloConfig.Active) and (MDModulo.Active)) then
    begin
        //TabModuloConfig
        TabConfiguracaoEID.Text := MDModuloConfig.FieldByName('ID').AsString;
        TabConfiguracaoEAdquirente_ID.Text := MDModuloConfig.FieldByName('ADQUIRENTE_ID').AsString;
        TabConfiguracaoEAdquirente_Nome.Text := MDModuloConfig.FieldByName('ADQUIRENTE_DESCRICAO').AsString;
        TabConfiguracaoEDescricao.Text := MDModuloConfig.FieldByName('DESCRICAO').AsString;
        TabConfiguracaoEHostS.Text := MDModuloConfig.FieldByName('SERVICO_HOST').AsString;
        TabConfiguracaoEPortaS.Text := MDModuloConfig.FieldByName('SERVICO_PORTA').AsString;
        TabConfiguracaoEHostE.Text := MDModuloConfig.FieldByName('CAIXA_HOST').AsString;
        TabConfiguracaoEPortaE.Text := MDModuloConfig.FieldByName('CAIXA_PORTA').AsString;
        TabConfiguracaoEChave.Text := MDModuloConfig.FieldByName('CHAVE').AsString;
        if MDModuloConfig.FieldByName('HABILITADO').AsString = 'T' then
            TabConfiguracaoCKHabilitar.Checked := True
        else
            TabConfiguracaoCKHabilitar.Checked := False;
        if MDModuloConfig.FieldByName('BIN_ESTATICO').AsString = 'T' then
            TabConfiguracaoCKBin.Checked := True
        else
            TabConfiguracaoCKBin.Checked := False;

        if MDModuloConfig.FieldByName('MENU_ESTATICO').AsString = 'T' then
            TabConfiguracaoCKMenu.Checked := True
        else
            TabConfiguracaoCKMenu.Checked := False;

        if MDModuloConfig.FieldByName('MENU_ESTATICO_OPERACIONAL').AsString = 'T' then
            TabConfiguracaoCKMenuOp.Checked := True
        else
            TabConfiguracaoCKMenuOp.Checked := False;
    end;
    //TabBin
    if ((MDBin.Active) and (MDModulo.Active) and (MDModuloConfig.Active)) then
    begin
        if length(TabConfiguracaoEID.Text) > 0 then
            MDBin.Filter := 'MODULO_CONF_ID=' + MDModuloConfig.FieldByName('ID').AsString
        else
            MDBin.Filter := 'MODULO_CONF_ID=0';
        MDBin.Filtered := True;
    end;
    //TabTag
    if (MDTags.Active) then
    begin
        TabTagEID.Text := MDTags.FieldByName('ID').AsString;
        TabTagETagNumero.Text := MDTags.FieldByName('TAG_NUMERO').AsString;
        TabTagETagTipo.Text := MDTags.FieldByName('TAG_TIPO').AsString;
        TabTagETagDefinicao.Text := MDTags.FieldByName('DEFINICAO').AsString;
        TabTagETagObs.Lines.Text := MDTags.FieldByName('OBS').AsString;
        TabTagETagDados.Lines.Text := MDTags.FieldByName('DADOS_F').AsString;
        TabTagCTagTipoDados.Text := MDTags.FieldByName('TIPO_DADOS').AsString;
        if MDTags.FieldByName('PADRAO').AsString = 'T' then
            TabTagCkPadrao.Checked := True
        else
            TabTagCkPadrao.Checked := False;
    end;
    //TabAdquirente
    if (MDAdquirente.Active) then
    begin
        TabAdquirenteEID.Text := MDAdquirente.FieldByName('ID').AsString;
        TabAdquirenteEDescricao.Text := MDAdquirente.FieldByName('DESCRICAO').AsString;
        TabAdquirenteEContato.Lines.Text := MDAdquirente.FieldByName('CONTATO').AsString;
    end;
end;

function Tfprincipal.GravaRegistros(VP_Tab: string; VP_Incluir: boolean = False): boolean;
var
    VL_ID: integer;
    VL_Bool: string;
    VL_Tabela: string;
begin
    Result := False;
    F_Navegar := False;
    VL_Bool := 'F';
    VL_Tabela := '';
    try
        //grava TabMultLoja
        if VP_Tab = 'TabMultLoja' then
        begin
            if not (F_Permissao) then
            begin
                ShowMessage('Sem Permissão de Gravação, usuário apenas de leitura');
                F_Navegar := True;
                exit;
            end;
            if VP_Incluir then
                VL_ID := 0
            else
                VL_ID := MDMultiLoja.FieldByName('ID').AsInteger;

            if VP_Incluir then
                MDMultiLoja.Insert
            else
            begin
                //localiza loja_id
                MDLoja.Locate('ID', MDMultiLoja.FieldByName('LOJA_ID').AsInteger, []);
                MDMultiLoja.Edit;
            end;

            MDMultiLoja.FieldByName('ID').AsInteger := VL_ID;
            MDMultiLoja.FieldByName('LOJA_ID').AsString := MDLoja.FieldByName('ID').AsString;
            MDMultiLoja.FieldByName('CNPJ').AsString := MDLoja.FieldByName('CNPJ').AsString;
            MDMultiLoja.FieldByName('RAZAO').AsString := MDLoja.FieldByName('RAZAO').AsString;
            if TabMultLojaCkLojaMaster.Checked then
                MDMultiLoja.FieldByName('HABILITADO').AsString := 'T'
            else
                MDMultiLoja.FieldByName('HABILITADO').AsString := 'F';
            MDMultiLoja.Post;
            //ATUALIZA LOJA
            MDLoja.Edit;
            MDLoja.FieldByName('MULT').AsString := 'T';
            MDLoja.Post;
            //atualiza multlojaloja
            if VP_Incluir then
            begin
                VL_Tabela := RxMemDataToStr(MDMultiLoja);
                StrToRxMemData(VL_Tabela, MDMultiLojaLoja);
            end;
            Result := True;
        end
        else
        //grava TabLoja
        if VP_Tab = 'TabLoja' then
        begin
            if not (F_Permissao) then
            begin
                ShowMessage('Sem Permissão de Gravação, usuário apenas de leitura');
                F_Navegar := True;
                exit;
            end;
            if VP_Incluir then
            begin
                VL_ID := 0;
                VL_Bool := 'F';
            end
            else
            begin
                VL_ID := MDLoja.FieldByName('ID').AsInteger;
                VL_Bool := MDLoja.FieldByName('MULT').AsString;
            end;

            if VP_Incluir then
                MDLoja.Insert
            else
                MDLoja.Edit;

            MDLoja.FieldByName('ID').AsInteger := VL_ID;
            MDLoja.FieldByName('CNPJ').AsString := TabLojaECnpj.Text;
            MDLoja.FieldByName('RAZAO').AsString := TabLojaERazao.Text;
            MDLoja.FieldByName('FANTASIA').AsString := TabLojaEFantasia.Text;
            MDLoja.FieldByName('MULTILOJA_ID').AsString := MDMultiLojaLoja.FieldByName('ID').AsString;
            MDLoja.FieldByName('MULT').AsString := VL_BOOL;
            if TabLojaCkHabilitar.Checked then
                MDLoja.FieldByName('HABILITADO').AsString := 'T'
            else
                MDLoja.FieldByName('HABILITADO').AsString := 'F';
            MDLoja.Post;
            Result := True;
        end
        else
        //grava TabMultLojaModulo
        if VP_Tab = 'TabMultLojaModulo' then
        begin
            if not (F_Permissao) then
            begin
                ShowMessage('Sem Permissão de Gravação, usuário apenas de leitura');
                F_Navegar := True;
                exit;
            end;
            if VP_Incluir then
                VL_ID := 0
            else
                VL_ID := MDMultiLojaModuloConf.FieldByName('ID').AsInteger;

            if VP_Incluir then
                MDMultiLojaModuloConf.Insert
            else
                MDMultiLojaModuloConf.Edit;

            MDMultiLojaModuloConf.FieldByName('ID').AsInteger := VL_ID;
            MDMultiLojaModuloConf.FieldByName('MULTILOJA_ID').AsInteger := MDMultiLoja.FieldByName('ID').AsInteger;
            if MDPesquisaModulo.locate('MODULO_CONF_ID', TabMultLojaModuloEModuloConfID.Text, []) then
                MDMultiLojaModuloConf.FieldByName('MODULO').AsString := MDPesquisaModulo.FieldByName('MODULO_DESCRICAO').AsString;
            MDMultiLojaModuloConf.FieldByName('MODULO_CONF_ID').AsString := TabMultLojaModuloEModuloConfID.Text;
            MDMultiLojaModuloConf.FieldByName('MODULO_CONF').AsString := TabMultLojaModuloEModuloConf.Text;
            MDMultiLojaModuloConf.FieldByName('CODIGO').AsString := TabMultLojaModuloECodigo.Text;
            if TabMultLojaModuloCkHabilitar.Checked then
                MDMultiLojaModuloConf.FieldByName('HABILITADO').AsString := 'T'
            else
                MDMultiLojaModuloConf.FieldByName('HABILITADO').AsString := 'F';
            MDMultiLojaModuloConf.Post;
            Result := True;
        end
        else
        //grava TabLojaModulo
        if VP_Tab = 'TabLojaModulo' then
        begin
            if not (F_Permissao) then
            begin
                ShowMessage('Sem Permissão de Gravação, usuário apenas de leitura');
                F_Navegar := True;
                exit;
            end;
            if VP_Incluir then
                VL_ID := 0
            else
                VL_ID := MDLojaModuloConf.FieldByName('ID').AsInteger;

            if VP_Incluir then
                MDLojaModuloConf.Insert
            else
                MDLojaModuloConf.Edit;

            MDLojaModuloConf.FieldByName('ID').AsInteger := VL_ID;
            MDLojaModuloConf.FieldByName('LOJA_ID').AsInteger := MDLoja.FieldByName('ID').AsInteger;
            if MDPesquisaModulo.locate('MODULO_CONF_ID', TabLojaModuloEModuloConfID.Text, []) then
                MDLojaModuloConf.FieldByName('MODULO').AsString := MDPesquisaModulo.FieldByName('MODULO_DESCRICAO').AsString;
            MDLojaModuloConf.FieldByName('MODULO_CONF_ID').AsString := TabLojaModuloEModuloConfID.Text;
            MDLojaModuloConf.FieldByName('MODULO_CONF').AsString := TabLojaModuloEModuloConf.Text;
            MDLojaModuloConf.FieldByName('CODIGO').AsString := TabLojaModuloECodigo.Text;
            if TabLojaModuloCkHabilitar.Checked then
                MDLojaModuloConf.FieldByName('HABILITADO').AsString := 'T'
            else
                MDLojaModuloConf.FieldByName('HABILITADO').AsString := 'F';
            MDLojaModuloConf.Post;
            Result := True;
        end
        else
        //grava TabPdv
        if VP_Tab = 'TabPdv' then
        begin
            if not (F_Permissao) then
            begin
                ShowMessage('Sem Permissão de Gravação, usuário apenas de leitura');
                F_Navegar := True;
                exit;
            end;
            if VP_Incluir then
                VL_ID := 0
            else
                VL_ID := MDPdv.FieldByName('ID').AsInteger;

            if VP_Incluir then
                MDPdv.Insert
            else
                MDPdv.Edit;

            MDPdv.FieldByName('ID').AsInteger := VL_ID;
            MDLojaPDV.Locate('RAZAO', TabPdvCLoja.KeyValue, []);
            MDPdv.FieldByName('LOJA_ID').AsInteger := MDLojaPdv.FieldByName('ID').AsInteger;
            MDPinPadPdv.Locate('FABRICANTE_MODELO', TabPdvCPinPad.KeyValue, []);
            MDPdv.FieldByName('PINPAD_ID').AsInteger := MDPinPadPdv.FieldByName('ID').AsInteger;
            MDPdv.FieldByName('IP').AsString := TabPdvEIP.Text;
            MDPdv.FieldByName('DESCRICAO').AsString := TabPdvEDescricao.Text;
            MDPdv.FieldByName('CODIGO').AsString := TabPdvECodigo.Text;
            MDPdv.FieldByName('PINPAD_COM').AsString := TabPdvEPinPadCom.Text;
            MDPdv.FieldByName('CHAVE').AsString := TabPdvEChave.Text;
            if TabPdvCkHabilitar.Checked then
                MDPdv.FieldByName('HABILITADO').AsString := 'T'
            else
                MDPdv.FieldByName('HABILITADO').AsString := 'F';

            MDPdv.Post;
            Result := True;
        end
        else
        //grava TabPinPad
        if VP_Tab = 'TabPinPad' then
        begin
            if not (F_Permissao) then
            begin
                ShowMessage('Sem Permissão de Gravação, usuário apenas de leitura');
                F_Navegar := True;
                exit;
            end;
            if VP_Incluir then
                VL_ID := 0
            else
                VL_ID := MDPinPad.FieldByName('ID').AsInteger;

            if VP_Incluir then
                MDPinPad.Insert
            else
                MDPinPad.Edit;

            MDPinPad.FieldByName('ID').AsInteger := VL_ID;
            MDPinPad.FieldByName('FABRICANTE_MODELO').AsString := TabPinPadMFabricante.Text;
            MDPinPad.Post;

            //atualiza PinpadPdv
            if VP_Incluir then
            begin
                VL_Tabela := RxMemDataToStr(MDPinPad);
                StrToRxMemData(VL_Tabela, MDPinPadPdv);
            end;

            Result := True;
        end
        else
        //grava TabPdvModulo
        if VP_Tab = 'TabPdvModulo' then
        begin
            if not (F_Permissao) then
            begin
                ShowMessage('Sem Permissão de Gravação, usuário apenas de leitura');
                F_Navegar := True;
                exit;
            end;
            if VP_Incluir then
                VL_ID := 0
            else
                VL_ID := MDPdvModulo.FieldByName('ID').AsInteger;

            if VP_Incluir then
                MDPdvModulo.Insert
            else
                MDPdvModulo.Edit;

            MDPdvModulo.FieldByName('ID').AsInteger := VL_ID;
            MDPdvModulo.FieldByName('PDV_ID').AsInteger := MDPdv.FieldByName('ID').AsInteger;
            MDPdvModulo.FieldByName('TAG_NUMERO').AsString := TabPdvModuloETagNumero.Text;
            MDPdvModulo.FieldByName('DEFINICAO').AsString := TabPdvModuloETag.Text;
            if MDPesquisaModulo.locate('MODULO_CONF_ID', TabPdvModuloEModuloConfID.Text, []) then
                MDPdvModulo.FieldByName('MODULO').AsString := MDPesquisaModulo.FieldByName('MODULO_DESCRICAO').AsString;
            MDPdvModulo.FieldByName('MODULO_CONF_ID').AsString := TabPdvModuloEModuloConfID.Text;
            MDPdvModulo.FieldByName('MODULO_CONF').AsString := TabPdvModuloEModuloConf.Text;
            if TabPdvModuloCkHabilitar.Checked then
                MDPdvModulo.FieldByName('HABILITADO').AsString := 'T'
            else
                MDPdvModulo.FieldByName('HABILITADO').AsString := 'F';
            MDPdvModulo.Post;
            Result := True;
        end
        else
        //grava TabConf
        if VP_Tab = 'TabConf' then
        begin
            if not (F_Permissao) then
            begin
                ShowMessage('Sem Permissão de Gravação, usuário não é um Configurador');
                F_Navegar := True;
                exit;
            end;
            if VP_Incluir then
                VL_ID := 0
            else
                VL_ID := MDConfigurador.FieldByName('ID').AsInteger;

            if VP_Incluir then
                MDConfigurador.Insert
            else
                MDConfigurador.Edit;

            MDConfigurador.FieldByName('ID').AsInteger := VL_ID;
            MDConfigurador.FieldByName('IP').AsString := TabConfEIP.Text;
            MDConfigurador.FieldByName('DESCRICAO').AsString := TabConfEDescricao.Text;
            MDConfigurador.FieldByName('CHAVE').AsString := TabConfEChave.Lines.Text;
            MDConfigurador.FieldByName('SENHA_CONFIGURADOR').AsString := TabTipoConfESenha.Text;
            MDConfigurador.FieldByName('SENHA_ADMINISTRADOR').AsString := TabTipoAdmESenha.Text;
            MDConfigurador.FieldByName('SENHA_USUARIO').AsString := TabTipoUsuESenha.Text;
            MDConfigurador.Post;
            Result := True;
        end
        else
        //grava TabModuloConf
        if VP_Tab = 'TabModuloConf' then
        begin
            if not (F_Permissao) then
            begin
                ShowMessage('Sem Permissão de Gravação, usuário não é um Configurador');
                F_Navegar := True;
                exit;
            end;
            if VP_Incluir then
                VL_ID := 0
            else
                VL_ID := MDModuloConfig.FieldByName('ID').AsInteger;

            if VP_Incluir then
                MDModuloConfig.Insert
            else
                MDModuloConfig.Edit;

            MDModuloConfig.FieldByName('ID').AsInteger := VL_ID;
            MDModuloConfig.FieldByName('MODULO_ID').AsString := TabModuloEID.Text;
            MDModuloConfig.FieldByName('ADQUIRENTE_ID').AsString := TabConfiguracaoEAdquirente_ID.Text;
            MDModuloConfig.FieldByName('ADQUIRENTE_DESCRICAO').AsString := TabConfiguracaoEAdquirente_Nome.Text;
            MDModuloConfig.FieldByName('CHAVE').AsString := TabConfiguracaoEChave.Lines.Text;
            MDModuloConfig.FieldByName('DESCRICAO').AsString := TabConfiguracaoEDescricao.Text;
            MDModuloConfig.FieldByName('SERVICO_HOST').AsString := TabConfiguracaoEHostS.Text;
            MDModuloConfig.FieldByName('SERVICO_PORTA').AsInteger := StrToIntDef(TabConfiguracaoEPortaS.Text, 0);
            MDModuloConfig.FieldByName('CAIXA_HOST').AsString := TabConfiguracaoEHostE.Text;
            MDModuloConfig.FieldByName('CAIXA_PORTA').AsInteger := StrToIntDef(TabConfiguracaoEPortaE.Text, 0);
            if TabConfiguracaoCKBin.Checked then
                MDModuloConfig.FieldByName('BIN_ESTATICO').AsString := 'T'
            else
                MDModuloConfig.FieldByName('BIN_ESTATICO').AsString := 'F';

            if TabConfiguracaoCKMenu.Checked then
                MDModuloConfig.FieldByName('MENU_ESTATICO').AsString := 'T'
            else
                MDModuloConfig.FieldByName('MENU_ESTATICO').AsString := 'F';

            if TabConfiguracaoCKMenuOp.Checked then
                MDModuloConfig.FieldByName('MENU_ESTATICO_OPERACIONAL').AsString := 'T'
            else
                MDModuloConfig.FieldByName('MENU_ESTATICO_OPERACIONAL').AsString := 'F';

            if TabConfiguracaoCKHabilitar.Checked then
                MDModuloConfig.FieldByName('HABILITADO').AsString := 'T'
            else
                MDModuloConfig.FieldByName('HABILITADO').AsString := 'F';
            MDModuloConfig.Post;
            Result := True;
        end
        else
        //grava TabModulo
        if VP_Tab = 'TabModulo' then
        begin
            if not (F_Permissao) then
            begin
                ShowMessage('Sem Permissão de Gravação, usuário não é um Configurador');
                F_Navegar := True;
                exit;
            end;
            if VP_Incluir then
                VL_ID := 0
            else
                VL_ID := MDModulo.FieldByName('ID').AsInteger;

            if VP_Incluir then
                MDModulo.Insert
            else
                MDModulo.Edit;

            MDModulo.FieldByName('ID').AsInteger := VL_ID;
            MDModulo.FieldByName('DESCRICAO').AsString := TabModuloEDescricao.Text;
            MDModulo.FieldByName('TAG_NUMERO').AsString := TabModuloETagModulo.Text;
            MDModulo.Post;
            Result := True;
        end
        else
        //grava TabBin
        if VP_Tab = 'TabBin' then
        begin
            if not (F_Permissao) then
            begin
                ShowMessage('Sem Permissão de Gravação, usuário não é um Configurador');
                F_Navegar := True;
                exit;
            end;
            if VP_Incluir then
                VL_ID := 0
            else
                VL_ID := MDBin.FieldByName('ID').AsInteger;

            if VP_Incluir then
                MDBin.Insert
            else
                MDBin.Edit;

            MDBin.FieldByName('ID').AsInteger := VL_ID;
            MDBin.FieldByName('MODULO_CONF_ID').AsString := MDModuloConfig.FieldByName('ID').AsString;
            MDBin.FieldByName('IIN').AsString := TabConfiguracaoEBin.Text;
            MDBin.Post;
            Result := True;
        end
        else
        //grava TabTag
        if VP_Tab = 'TabTag' then
        begin
            if not (F_Permissao) then
            begin
                ShowMessage('Sem Permissão de Gravação, usuário não é um Configurador');
                F_Navegar := True;
                exit;
            end;
            if VP_Incluir then
                VL_ID := 0
            else
                VL_ID := MDTags.FieldByName('ID').AsInteger;

            if VP_Incluir then
                MDTags.Insert
            else
                MDTags.Edit;

            MDTags.FieldByName('ID').AsInteger := VL_ID;
            MDTags.FieldByName('TAG_NUMERO').AsString := TabTagETagNumero.Text;
            MDTags.FieldByName('DEFINICAO').AsString := TabTagETagDefinicao.Text;

            case TabTagETagTipo.ItemIndex of
                1: MDTags.FieldByName('TAG_TIPO').AsString := 'COMANDO';
                2: MDTags.FieldByName('TAG_TIPO').AsString := 'DADOS';
                3: MDTags.FieldByName('TAG_TIPO').AsString := 'MENU_PDV';
                4: MDTags.FieldByName('TAG_TIPO').AsString := 'MENU_OPERACIONAL';
                5: MDTags.FieldByName('TAG_TIPO').AsString := 'PINPAD_FUNC';
                6: MDTags.FieldByName('TAG_TIPO').AsString := 'MODULO';
                else
                    MDTags.FieldByName('TAG_TIPO').AsString := 'NDF';
            end;

            case TabTagCTagTipoDados.ItemIndex of
                1: MDTags.FieldByName('TIPO_DADOS').AsString := 'TEXTO';
                2: MDTags.FieldByName('TIPO_DADOS').AsString := 'NUMERICO';
                3: MDTags.FieldByName('TIPO_DADOS').AsString := 'DATA';
                4: MDTags.FieldByName('TIPO_DADOS').AsString := 'HORA';
                5: MDTags.FieldByName('TIPO_DADOS').AsString := 'DADOS';
                6: MDTags.FieldByName('TIPO_DADOS').AsString := 'BOOLEANO';
                7: MDTags.FieldByName('TIPO_DADOS').AsString := 'IMPRESSAO';
                else
                    MDTags.FieldByName('TIPO_DADOS').AsString := 'NDF';
            end;

            MDTags.FieldByName('OBS').AsString := TabTagETagObs.Lines.Text;
            MDTags.FieldByName('DADOS_F').AsString := TabTagETagDados.Lines.Text;
            MDTags.FieldByName('DADOS').AsVariant := MDTags.FieldByName('DADOS_F').AsVariant;
            if TabTagCkPadrao.Checked then
                MDTags.FieldByName('PADRAO').AsString := 'T'
            else
                MDTags.FieldByName('PADRAO').AsString := 'F';
            MDTags.Post;
            Result := True;
        end
        else
        //grava TabAdquirente
        if VP_Tab = 'TabAdquirente' then
        begin
            if not (F_Permissao) then
            begin
                ShowMessage('Sem Permissão de Gravação, usuário não é um Configurador');
                F_Navegar := True;
                exit;
            end;
            if VP_Incluir then
                VL_ID := 0
            else
                VL_ID := MDAdquirente.FieldByName('ID').AsInteger;

            if VP_Incluir then
                MDAdquirente.Insert
            else
                MDAdquirente.Edit;

            MDAdquirente.FieldByName('ID').AsInteger := VL_ID;
            MDAdquirente.FieldByName('DESCRICAO').AsString := TabAdquirenteEDescricao.Text;
            MDAdquirente.FieldByName('CONTATO').AsString := TabAdquirenteEContato.Lines.Text;
            MDAdquirente.Post;
            Result := True;
        end;
    finally
        F_Navegar := True;
    end;
end;

function Tfprincipal.IncluirRegistro(VP_Tabela: TRxMemoryData; VP_TagComando, VP_TagComandoDados, VP_TagTabela: string; var VO_Retorno: ansistring): integer;
var
    VL_Tabela: string;
    VL_Mensagem: TMensagem;
    VL_Tag: ansistring;
    VL_PTag, VL_PRetorno: PChar;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Tabela := '';
    try
        VL_Tabela := RxMemDataToStr(VP_Tabela);
        VL_Mensagem.AddComando(VP_TagComando, VP_TagComandoDados);
        VL_Mensagem.AddTag(VP_TagTabela, VL_Tabela);
        VL_Mensagem.TagToStr(VL_Tag);
        VL_PTag := PChar(VL_Tag);
        Result := F_SolicitacaoBlocante(VL_PTag, VL_PRetorno, C_TempoSolicitacao);
        VO_Retorno := VL_PRetorno;
    finally
        begin
            VL_Mensagem.Free;
            F_Navegar := True;
        end;
    end;
end;

procedure Tfprincipal.AlterarRegistro(VP_TagTabela: string; VP_Tabela: TRxMemoryData; VP_Tag: string; VP_ID: int64; VP_TagComando, VP_TagComandoDados: string);
var
    VL_Mensagem: TMensagem;
    VL_Tabela: string;
    VL_Tag: ansistring;
    VL_Codigo: integer;
    VL_Retorno: ansistring;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Tag := '';
    VL_Tabela := '';
    VL_Codigo := 0;
    VL_Retorno := '';
    F_Navegar := False;
    try
        VL_Tabela := RxMemDataToStr(VP_Tabela);
        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando(VP_TagComando, VP_TagComandoDados);
        VL_Mensagem.AddTag(VP_TagTabela, VL_Tabela);
        VL_Mensagem.AddTag(VP_Tag, VP_ID);


        VL_Mensagem.TagToStr(VL_Tag);
        VL_Codigo := SolicitacaoBloc(VL_Tag, VL_Tag, C_TempoSolicitacao);

        if VL_Codigo <> 0 then
        begin
            ShowMessage(IntToStr(VL_Codigo));
            exit;
        end;
        VL_Mensagem.Limpar;
        VL_Mensagem.CarregaTags(VL_Tag);
        VL_Mensagem.GetComando(VL_Retorno, VL_Tag);
        case VL_Retorno of
            '0026':
            begin
                VL_Mensagem.GetTag('0026', VL_Tag);
                ShowMessage('ERRO:' + VL_Tag);
                // CarregarTabelas;
                VP_Tabela.Locate('ID', VP_ID, []);
                CarregaCampos;
                F_Navegar := True;
                Exit;
            end;
            else
            begin
                if VL_Tag <> 'R' then
                begin
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                    Exit;
                end;
                VL_Mensagem.GetTag('004D', VL_Tag);
                if VL_Tag = '0' then
                    ShowMessage('Registro alterado com sucesso');
            end;
        end;
        CarregaCampos;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;
end;

function Tfprincipal.ExcluirRegistro(VP_Tag: string; VP_ID: integer; VP_TagComando, VP_TagComandoDados: string; var VO_Retorno: ansistring): integer;
var
    VL_Status: integer;
    VL_Mensagem: TMensagem;
    VL_Tag: string;
begin
    VL_Status := 0;
    VL_Mensagem := TMensagem.Create;
    try
        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando(VP_TagComando, '');
        VL_Mensagem.AddTag(VP_Tag, VP_ID);

        VL_Mensagem.TagToStr(VL_Tag);
        Result := SolicitacaoBloc(VL_Tag, VO_Retorno, C_TempoSolicitacao);
    finally
        VL_Mensagem.Free;
    end;
end;

function Tfprincipal.SolicitacaoBloc(VP_Dados: ansistring; var VO_Retorno: ansistring; VP_Tempo: integer): integer;
var
    VL_PTag, VL_PRetorno: PChar;
begin
    VL_PRetorno := '';
    VL_PTag := PChar(VP_Dados);

    Result := F_SolicitacaoBlocante(VL_PTag, VL_PRetorno, VP_Tempo);

    VO_Retorno := VL_PRetorno;
end;

procedure Tfprincipal.CarregarTabelas(VP_CarregaTodasTabelas: boolean; VP_TagTabelaEspecifica: string; VP_Tag: string; VP_DadosN: integer);
var
    VL_Mensagem: TMensagem;
    VL_Codigo: integer;
    VL_Tag: string;
    VL_Retorno: string;
    VL_Tabela: TRxMemoryData;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_Tag := '';
    VL_Retorno := '';
    VL_Tabela := TRxMemoryData.Create(nil);
    try
        if F_Permissao = False then
            exit;
        F_Navegar := False;

        //carrega tabela
        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('0070', 'S');

        if VP_CarregaTodasTabelas then
        begin
            //alimenta as tags
            VL_Mensagem.AddTag('003C', 0); //loja_id
            VL_Mensagem.AddTag('0065', 0); //multloja_id
            VL_Mensagem.AddTag('006E', 0); //tag_id
            VL_Mensagem.AddTag('006F', 0); //adquirente_id
            VL_Mensagem.AddTag('0076', 0); //bin_id
            VL_Mensagem.AddTag('0054', 0); //pinpad_id
            VL_Mensagem.AddTag('0043', 0); //pdv_id
            VL_Mensagem.AddTag('0056', 0); //configurador_id
            VL_Mensagem.AddTag('006C', 0); //modulo_id
        end
        else
            VL_Mensagem.AddTag(VP_Tag, VP_DadosN); //pesquisa tabela por id


        VL_Mensagem.TagToStr(VL_Tag);

        VL_Codigo := SolicitacaoBloc(VL_Tag, VL_Tag, C_TempoSolicitacao);

        if VL_Codigo <> 0 then
        begin
            ShowMessage(IntToStr(VL_Codigo));
            exit;
        end;
        VL_Mensagem.Limpar;
        VL_Mensagem.CarregaTags(VL_Tag);

        VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

        case VL_Retorno of
            '0026':
            begin
                VL_Mensagem.GetTag('0026', VL_Tag);
                ShowMessage('ERRO:' + VL_Tag);
                Exit;
            end;
            '0070':
            begin
                //verifica se é um retorno
                if VL_Tag <> 'R' then
                begin
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                    Exit;
                end;
                //TABELA LOJA
                if ((VP_CarregaTodasTabelas) and (VP_TagTabelaEspecifica = '')) or
                    ((VP_CarregaTodasTabelas = False) and (VP_TagTabelaEspecifica = '003E')) then
                begin
                    if VL_Mensagem.GetTag('003E', VL_Tag) = 0 then
                    begin
                        if MDLoja.Active then
                            MDLoja.EmptyTable;
                        if MDLojaPdv.Active then
                            MDLojaPdv.EmptyTable;
                        StrToRxMemData(VL_Tag, MDLoja);
                        MDLoja.Open;
                        StrToRxMemData(VL_Tag, MDLojaPdv);
                        MDLojaPdv.Open;
                    end;
                end;
                //TABELA MULT-LOJA
                if ((VP_CarregaTodasTabelas) and (VP_TagTabelaEspecifica = '')) or
                    ((VP_CarregaTodasTabelas = False) and (VP_TagTabelaEspecifica = '0080')) then
                begin
                    if VL_Mensagem.GetTag('0080', VL_Tag) = 0 then
                    begin
                        if MDMultiLoja.Active then
                            MDMultiLoja.EmptyTable;
                        if MDMultiLojaLoja.Active then
                            MDMultiLojaLoja.EmptyTable;
                        StrToRxMemData(VL_Tag, MDMultiLoja);
                        MDMultiLoja.Open;
                        StrToRxMemData(VL_Tag, MDMultiLojaLoja);
                        MDMultiLojaLoja.Open;
                        //CRIA CAMPO NDF
                        MDMultiLojaLoja.Insert;
                        MDMultiLojaLoja.FieldByName('ID').AsInteger := -1;
                        MDMultiLojaLoja.FieldByName('RAZAO').AsString := 'NÃO DEFINIDO';
                        MDMultiLojaLoja.Post;
                    end;
                end;
                //TABELA TAG
                if ((VP_CarregaTodasTabelas) and (VP_TagTabelaEspecifica = '')) or
                    ((VP_CarregaTodasTabelas = False) and (VP_TagTabelaEspecifica = '0081')) then
                begin
                    if VL_Mensagem.GetTag('0081', VL_Tag) = 0 then
                    begin
                        if MDTags.Active then
                            MDTags.EmptyTable;
                        StrToRxMemData(VL_Tag, MDTags);
                        MDTags.Open;
                    end;
                end;
                //ADQUIRENTE
                if ((VP_CarregaTodasTabelas) and (VP_TagTabelaEspecifica = '')) or
                    ((VP_CarregaTodasTabelas = False) and (VP_TagTabelaEspecifica = '0082')) then
                begin
                    if VL_Mensagem.GetTag('0082', VL_Tag) = 0 then
                    begin
                        if MDAdquirente.Active then
                            MDAdquirente.EmptyTable;
                        StrToRxMemData(VL_Tag, MDAdquirente);
                        MDAdquirente.Open;
                    end;

                end;
                //BIN
                if ((VP_CarregaTodasTabelas) and (VP_TagTabelaEspecifica = '')) or
                    ((VP_CarregaTodasTabelas = False) and (VP_TagTabelaEspecifica = '0083')) then
                begin
                    if VL_Mensagem.GetTag('0083', VL_Tag) = 0 then
                    begin
                        if MDBin.Active then
                            MDBin.EmptyTable;
                        StrToRxMemData(VL_Tag, MDBin);
                        MDBin.Open;
                    end;
                end;
                //PINPAD
                if ((VP_CarregaTodasTabelas) and (VP_TagTabelaEspecifica = '')) or
                    ((VP_CarregaTodasTabelas = False) and (VP_TagTabelaEspecifica = '008D')) then
                begin
                    if VL_Mensagem.GetTag('008D', VL_Tag) = 0 then
                    begin
                        if MDPinPad.Active then
                            MDPinPad.EmptyTable;
                        if MDPinPadPdv.Active then
                            MDPinPadPdv.EmptyTable;
                        StrToRxMemData(VL_Tag, MDPinPad);
                        MDPinPad.Open;
                        StrToRxMemData(VL_Tag, MDPinPadPdv);
                        MDPinPadPdv.Open;
                    end;
                end;
                //PDV
                if ((VP_CarregaTodasTabelas) and (VP_TagTabelaEspecifica = '')) or
                    ((VP_CarregaTodasTabelas = False) and (VP_TagTabelaEspecifica = '008E')) then
                begin
                    if VL_Mensagem.GetTag('008E', VL_Tag) = 0 then
                    begin
                        if MDPdv.Active then
                            MDPdv.EmptyTable;
                        StrToRxMemData(VL_Tag, MDPdv);
                        MDPdv.Open;
                    end;
                end;
                //configurador
                if ((VP_CarregaTodasTabelas) and (VP_TagTabelaEspecifica = '')) or
                    ((VP_CarregaTodasTabelas = False) and (VP_TagTabelaEspecifica = '008F')) then
                begin
                    if VL_Mensagem.GetTag('008F', VL_Tag) = 0 then
                    begin
                        if MDConfigurador.Active then
                            MDConfigurador.EmptyTable;
                        StrToRxMemData(VL_Tag, MDConfigurador);
                        MDConfigurador.Open;
                    end;
                end;
                //MODULO
                if ((VP_CarregaTodasTabelas) and (VP_TagTabelaEspecifica = '')) or
                    ((VP_CarregaTodasTabelas = False) and (VP_TagTabelaEspecifica = '0090')) then
                begin
                    if VL_Mensagem.GetTag('0090', VL_Tag) = 0 then
                    begin
                        if MDModulo.Active then
                            MDModulo.EmptyTable;
                        StrToRxMemData(VL_Tag, MDModulo);
                        MDModulo.Open;
                    end;

                end;
                //PESQUISA_MODULO
                if ((VP_CarregaTodasTabelas) and (VP_TagTabelaEspecifica = '')) or
                    ((VP_CarregaTodasTabelas = False) and (VP_TagTabelaEspecifica = '0095')) then
                begin
                    if VL_Mensagem.GetTag('0095', VL_Tag) = 0 then
                    begin
                        if MDPesquisaModulo.Active then
                            MDPesquisaModulo.EmptyTable;
                        StrToRxMemData(VL_Tag, MDPesquisaModulo);
                        MDPesquisaModulo.Open;
                    end;

                end;
                //MODULO_CONFIG
                if ((VP_CarregaTodasTabelas) and (VP_TagTabelaEspecifica = '')) or
                    ((VP_CarregaTodasTabelas = False) and (VP_TagTabelaEspecifica = '0091')) then
                begin
                    if VL_Mensagem.GetTag('0091', VL_Tag) = 0 then
                    begin
                        if MDModuloConfig.Active then
                            MDModuloConfig.EmptyTable;
                        StrToRxMemData(VL_Tag, MDModuloConfig);
                        MDModuloConfig.Open;
                    end;

                end;
                //MODULO_FUNC
                if ((VP_CarregaTodasTabelas) and (VP_TagTabelaEspecifica = '')) or
                    ((VP_CarregaTodasTabelas = False) and (VP_TagTabelaEspecifica = '0092')) then
                begin
                    if VL_Mensagem.GetTag('0092', VL_Tag) = 0 then
                    begin
                        if MDModuloFunc.Active then
                            MDModuloFunc.EmptyTable;

                        if VL_Tabela.Active then
                            VL_Tabela.EmptyTable;
                        StrToRxMemData(VL_Tag, VL_Tabela);
                        CopiaDadosSimples(VL_Tabela, MDModuloFunc);
                    end;
                end;
                //MODULO_CONF_FUNCAO
                if ((VP_CarregaTodasTabelas) and (VP_TagTabelaEspecifica = '')) or
                    ((VP_CarregaTodasTabelas = False) and (VP_TagTabelaEspecifica = '0093')) then
                begin
                    if VL_Mensagem.GetTag('0093', VL_Tag) = 0 then
                    begin
                        if MDModuloConfFuncao.Active then
                            MDModuloConfFuncao.EmptyTable;

                        if VL_Tabela.Active then
                            VL_Tabela.EmptyTable;
                        StrToRxMemData(VL_Tag, VL_Tabela);
                        CopiaDadosSimples(VL_Tabela, MDModuloConfFuncao);
                    end;
                end;
                //MULTLOJA_MODULO
                if ((VP_CarregaTodasTabelas) and (VP_TagTabelaEspecifica = '')) or
                    ((VP_CarregaTodasTabelas = False) and (VP_TagTabelaEspecifica = '0094')) then
                begin
                    if VL_Mensagem.GetTag('0094', VL_Tag) = 0 then
                    begin
                        if MDMultiLojaModuloConf.Active then
                            MDMultiLojaModuloConf.EmptyTable;
                        StrToRxMemData(VL_Tag, MDMultiLojaModuloConf);
                        MDMultiLojaModuloConf.Open;
                    end;
                end;
                //MULTLOJA_FUNCAO
                if ((VP_CarregaTodasTabelas) and (VP_TagTabelaEspecifica = '')) or
                    ((VP_CarregaTodasTabelas = False) and (VP_TagTabelaEspecifica = '009C')) then
                begin
                    if VL_Mensagem.GetTag('009C', VL_Tag) = 0 then
                    begin
                        if MDMultiLojaFuncao.Active then
                            MDMultiLojaFuncao.EmptyTable;

                        if VL_Tabela.Active then
                            VL_Tabela.EmptyTable;
                        StrToRxMemData(VL_Tag, VL_Tabela);
                        CopiaDadosSimples(VL_Tabela, MDMultiLojaFuncao);
                    end;
                end;
                //MULTILOJA_MODULO_CONF_FUNCAO
                if ((VP_CarregaTodasTabelas) and (VP_TagTabelaEspecifica = '')) or
                    ((VP_CarregaTodasTabelas = False) and (VP_TagTabelaEspecifica = '00D0')) then
                begin
                    if VL_Mensagem.GetTag('00D0', VL_Tag) = 0 then
                    begin
                        if MDMultiLojaModuloConfFuncao.Active then
                            MDMultiLojaModuloConfFuncao.EmptyTable;
                        if VL_Tabela.Active then
                            VL_Tabela.EmptyTable;
                        StrToRxMemData(VL_Tag, VL_Tabela);
                        CopiaDadosSimples(VL_Tabela, MDMultiLojaModuloConfFuncao);
                    end;
                end;
                //LOJA_MODULO
                if ((VP_CarregaTodasTabelas) and (VP_TagTabelaEspecifica = '')) or
                    ((VP_CarregaTodasTabelas = False) and (VP_TagTabelaEspecifica = '00A7')) then
                begin
                    if VL_Mensagem.GetTag('00A7', VL_Tag) = 0 then
                    begin
                        if MDLojaModuloConf.Active then
                            MDLojaModuloConf.EmptyTable;
                        StrToRxMemData(VL_Tag, MDLojaModuloConf);
                        MDLojaModuloConf.Open;
                    end;

                end;
                //LOJA_FUNCAO
                if ((VP_CarregaTodasTabelas) and (VP_TagTabelaEspecifica = '')) or
                    ((VP_CarregaTodasTabelas = False) and (VP_TagTabelaEspecifica = '00A9')) then
                begin
                    if VL_Mensagem.GetTag('00A9', VL_Tag) = 0 then
                    begin
                        if MDLojaFuncao.Active then
                            MDLojaFuncao.EmptyTable;

                        if VL_Tabela.Active then
                            VL_Tabela.EmptyTable;
                        StrToRxMemData(VL_Tag, VL_Tabela);
                        CopiaDadosSimples(VL_Tabela, MDLojaFuncao);
                    end;
                end;
                //LOJA_MODULO_CONF_FUNCAO
                if ((VP_CarregaTodasTabelas) and (VP_TagTabelaEspecifica = '')) or
                    ((VP_CarregaTodasTabelas = False) and (VP_TagTabelaEspecifica = '0098')) then
                begin
                    if VL_Mensagem.GetTag('0098', VL_Tag) = 0 then
                    begin
                        if MDLojaModuloConfFuncao.Active then
                            MDLojaModuloConfFuncao.EmptyTable;

                        if VL_Tabela.Active then
                            VL_Tabela.EmptyTable;
                        StrToRxMemData(VL_Tag, VL_Tabela);
                        CopiaDadosSimples(VL_Tabela, MDLojaModuloConfFuncao);
                    end;
                end;
                //PINPAD_FUNCAO
                if ((VP_CarregaTodasTabelas) and (VP_TagTabelaEspecifica = '')) or
                    ((VP_CarregaTodasTabelas = False) and (VP_TagTabelaEspecifica = '00B4')) then
                begin
                    if VL_Mensagem.GetTag('00B4', VL_Tag) = 0 then
                    begin
                        if MDPinPadFuncao.Active then
                            MDPinPadFuncao.EmptyTable;

                        if VL_Tabela.Active then
                            VL_Tabela.EmptyTable;
                        StrToRxMemData(VL_Tag, VL_Tabela);
                        CopiaDadosSimples(VL_Tabela, MDPinPadFuncao);
                    end;

                end;
                //PDV_FUNCAO
                if ((VP_CarregaTodasTabelas) and (VP_TagTabelaEspecifica = '')) or
                    ((VP_CarregaTodasTabelas = False) and (VP_TagTabelaEspecifica = '00C1')) then
                begin
                    if VL_Mensagem.GetTag('00C1', VL_Tag) = 0 then
                    begin
                        if MDPdvFuncao.Active then
                            MDPdvFuncao.EmptyTable;

                        if VL_Tabela.Active then
                            VL_Tabela.EmptyTable;
                        StrToRxMemData(VL_Tag, VL_Tabela);
                        CopiaDadosSimples(VL_Tabela, MDPdvFuncao);
                    end;

                end;
                //PDV_MODULO
                if ((VP_CarregaTodasTabelas) and (VP_TagTabelaEspecifica = '')) or
                    ((VP_CarregaTodasTabelas = False) and (VP_TagTabelaEspecifica = '00C7')) then
                begin
                    if VL_Mensagem.GetTag('00C7', VL_Tag) = 0 then
                    begin
                        if MDPdvModulo.Active then
                            MDPdvModulo.EmptyTable;
                        StrToRxMemData(VL_Tag, MDPdvModulo);
                        MDPdvModulo.Open;
                    end;

                end;
            end;
        end;
        F_Navegar := True;
        CarregaCampos;
    finally
        VL_Mensagem.Free;
    end;
end;

function Tfprincipal.PesquisaTabelas(VP_TagComando, VP_DadosComando, VP_Tag: ansistring; VP_ID: integer): ansistring;
var
    VL_Mensagem: TMensagem;
    VL_Codigo: integer;
    VL_Tag: ansistring;
    VL_Retorno: ansistring;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_Tag := '';
    VL_Retorno := '';
    try
        if F_Permissao = False then
            exit;
        F_Navegar := False;

        //carrega tabela
        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando(VP_TagComando, VP_DadosComando);
        VL_Mensagem.AddTag(VP_Tag, VP_ID);
        VL_Mensagem.TagToStr(VL_Tag);
        VL_Codigo := SolicitacaoBloc(VL_Tag, VL_Tag, C_TempoSolicitacao);
        if VL_Codigo <> 0 then
        begin
            ShowMessage(IntToStr(VL_Codigo));
            exit;
        end;
        Result := VL_Tag;
        F_Navegar := True;
        CarregaCampos;
    finally
        VL_Mensagem.Free;
    end;

end;

procedure Tfprincipal.Conectar;
var
    VL_Status: integer;
begin
    F_OpenTefStatus(VL_Status);
    if VL_Status = Ord(csLogado) then
    begin
        BConectar.Caption := 'Desconectar';
        BConectar.ImageIndex := 4;
        EStatus.Caption := 'Logado';
        EStatus.Font.Color := clGreen;
    end
    else
    begin
        BConectar.Caption := 'Conectar';
        BConectar.ImageIndex := 3;
        EStatus.Caption := 'Desconectado';
        EStatus.Font.Color := clRed;
    end;
end;

procedure Tfprincipal.Desconectar;
begin
    F_Desconectar();
    LimparTela;
    BConectar.Caption := 'Conectar';
    BConectar.ImageIndex := 3;
    EStatus.Caption := 'Desconectado';
    EStatus.Font.Color := clRed;
    PagePrincipal.TabIndex := 0;
    PageCadastroLoja.TabIndex := 0;
    PageMultiLojaVisualizarModuloFuncao.TabIndex := 0;
    PageLojaVisualizarModuloFuncao.TabIndex := 0;
    TabPinPadPageModuloFuncao.TabIndex := 0;
    TabPdvPageModuloFuncao.TabIndex := 0;
    TabConf.TabVisible := False;
    TabModulo.TabVisible := False;
    TabTag.TabVisible := False;
    TabAdquirente.TabVisible := False;
    F_Permissao := False;
    F_TipoConfigurador := pmS;
end;

procedure Tfprincipal.LimparTela;
var
    i: integer;
    VL_Nota: string;
begin
    with self do
    begin
        for i := 0 to ComponentCount - 1 do
        begin
            if Components[i] is TEdit then
                TEdit(Components[i]).Text := '';
            if Components[i] is TMaskEdit then
                tmaskedit(Components[i]).Text := '';
            if Components[i] is TComboBox then
                TComboBox(Components[i]).ItemIndex := -1;
            if Components[i] is TMemo then
                TMemo(Components[i]).Clear;
            if Components[i] is TRadioButton then
                TRadioButton(Components[i]).Checked := False;
            if Components[i] is TCheckBox then
                TCheckBox(Components[i]).Checked := False;
        end;
    end;
    //campos que não devem ser limpos
    VL_Nota := 'Para trocar o campo de filtro, clique sobre o ' + #13 +
        'campo desejado na tabela correspondente e o filtro irá mudar automaticamente.';

    TabLojaFuncaoMNota.Lines.Text := VL_Nota;
    TabPinPadFuncaoMNota.Lines.Text := VL_Nota;
    TabPDVFuncaoMNota.Lines.Text := VL_Nota;

    MDLoja.EmptyTable;
    MDLojaPdv.EmptyTable;
    MDPdv.EmptyTable;
    MDPinPad.EmptyTable;
    MDConfigurador.EmptyTable;
    MDMultiLoja.EmptyTable;
    MDModulo.EmptyTable;
    MDModuloConfig.EmptyTable;
    MDBin.EmptyTable;
    MDMultiLojaModuloConf.EmptyTable;
    MDLojaModuloConf.EmptyTable;
    MDTags.EmptyTable;
end;

function Tfprincipal.FiltrarTabela(VP_DBGrid: TRxDBGrid; var VO_RotuloCaption: string; VP_EditFiltrado: TEdit): string;
var
    VL_Filtro: string;
begin
    VL_Filtro := VP_DBGrid.SelectedColumn.FieldName;

    if VP_DBGrid.SelectedColumn.Field.DataType = ftBoolean then
        VL_Filtro := '';

    if VL_Filtro = '' then
    begin
        VL_Filtro := VP_DBGrid.Columns[1].FieldName;
        VO_RotuloCaption := 'Filtrar por ' + VP_DBGrid.Columns[1].Title.Caption;
        VP_DBGrid.SelectedIndex := 1;
    end
    else
        VO_RotuloCaption := 'Filtrar por ' + VP_DBGrid.SelectedColumn.Title.Caption;

    Result := VL_Filtro + ' = (''*' + VP_EditFiltrado.Text + '*'')';

end;

function Tfprincipal.FiltrarTabela(VP_DBGrid: TDBGrid; var VO_RotuloCaption: string; VP_EditFiltrado: TEdit): string;
var
    VL_Filtro: string;
begin
    VL_Filtro := VP_DBGrid.SelectedColumn.FieldName;

    if VL_Filtro = '' then
    begin
        VL_Filtro := VP_DBGrid.Columns[1].FieldName;
        VO_RotuloCaption := 'Filtrar por ' + VP_DBGrid.Columns[1].Title.Caption;
        VP_DBGrid.SelectedIndex := 1;
    end
    else
        VO_RotuloCaption := 'Filtrar por ' + VP_DBGrid.SelectedColumn.Title.Caption;

    Result := VL_Filtro + ' = (''*' + VP_EditFiltrado.Text + '*'')';

end;

procedure Tfprincipal.MDLojaAfterScroll(DataSet: TDataSet);
begin
    if ((MDLoja.Active = False) or (MDLoja.RecordCount = 0) or (F_Navegar = False)) then
        exit;
    if MDLojaModuloConf.Active then
    begin
        MDLojaModuloConf.EmptyTable;
        TabLojaTabModuloDados.OnShow(self);
    end
    else
        TabLojaTabModuloDados.OnShow(self);

    if MDLojaFuncao.Active then
    begin
        MDLojaFuncao.EmptyTable;
        TabLojaFuncao.OnShow(self);
    end
    else
        TabLojaFuncao.OnShow(self);

    CarregaCampos;
end;


procedure Tfprincipal.MDPdvAfterScroll(DataSet: TDataSet);
begin
    if ((MDPdv.Active = False) or (MDPdv.RecordCount = 0) or (F_Navegar = False)) then
        exit;

    if MDPdvModulo.Active then
    begin
        MDPdvModulo.EmptyTable;
        TabPdvTabDadosModulo.OnShow(self);
    end
    else
        TabPdvTabDadosModulo.OnShow(self);

    if MDPdvFuncao.Active then
    begin
        MDPdvFuncao.EmptyTable;
        TabPdvTabDadosFuncao.OnShow(self);
    end
    else
        TabPdvTabDadosFuncao.OnShow(self);

    CarregaCampos;
end;

procedure Tfprincipal.MDPdvFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin

end;

procedure Tfprincipal.MDPinPadAfterScroll(DataSet: TDataSet);
begin
    if ((MDPinPad.Active = False) or (MDPinPad.RecordCount = 0) or (F_Navegar = False)) then
        exit;
    if MDPinPadFuncao.Active then
    begin
        MDPinPadFuncao.EmptyTable;
        TabPinPadTabDadosFuncao.OnShow(self);
    end
    else
        TabPinPadTabDadosFuncao.OnShow(self);


    CarregaCampos;
end;

procedure Tfprincipal.TabConfBAdicionarClick(Sender: TObject);
var
    VL_Status: integer;
    VL_Mensagem: TMensagem;
    VL_Codigo: integer;
    VL_ID: int64;
    VL_Retorno, VL_Tag: string;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            Desconectar;
            Exit;
        end;
        if MDConfigurador.Active = False then
        begin
            ShowMessage('MDConfigurador não está ativo');
            Exit;
        end;
        if TabConfEDescricao.Text = '' then
        begin
            ShowMessage('Descricao é um campo obrigatório');
            exit;
        end;
        if ((TabTipoConfESenha.Text = '') and (TabTipoAdmESenha.Text = '') and (TabTipoUsuESenha.Text = '')) then
        begin
            ShowMessage('Senha é um campo obrigatório');
            exit;
        end;

        if GravaRegistros('TabConf', True) then
        begin
            VL_Codigo := IncluirRegistro(MDConfigurador, '0057', 'S', '008F', VL_Tag);
            if VL_Codigo <> 0 then
            begin
                ShowMessage(IntToStr(VL_Codigo));
                exit;
            end;

            VL_Mensagem.Limpar;
            VL_Mensagem.CarregaTags(VL_Tag);
            VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

            case VL_Retorno of
                '0026':
                begin
                    VL_Mensagem.GetTag('0026', VL_Tag);
                    ShowMessage('ERRO:' + VL_Tag);
                    if MDConfigurador.Locate('ID', 0, []) then
                        MDConfigurador.Delete;
                    Exit;
                end;
                '0057':
                begin
                    if VL_Tag <> 'R' then
                    begin
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                        Exit;
                    end;
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    if vl_tag <> '0' then
                    begin
                        ShowMessage('ERRO:' + VL_Tag);
                        if MDConfigurador.Locate('ID', 0, []) then
                            MDConfigurador.Delete;
                        Exit;
                    end;
                    VL_Mensagem.GetTag('0056', VL_ID); //RETORNO DO ID DO CONFIGURADOR
                    F_Navegar := False;
                    if MDConfigurador.Locate('ID', 0, []) then
                    begin
                        MDConfigurador.Edit;
                        MDConfigurador.FieldByName('ID').AsInteger := VL_ID;
                        MDConfigurador.Post;
                    end;
                end;
            end;
            CarregaCampos;
            ShowMessage('Registro incluido com sucesso');
        end;

    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;
end;

procedure Tfprincipal.TabConfBGeraChaveClick(Sender: TObject);
var
    VL_Mensagem: TMensagem;
    VL_Chave: string;
    VL_Tag: ansistring;
    VL_Codigo: integer;
    VL_Retorno: ansistring;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Tag := '';
    VL_Codigo := 0;
    try
        CriarChaveTerminal(VL_Chave);
        if Length(VL_Chave) = 0 then
        begin
            ShowMessage('Erro ao gerar chave');
            exit;
        end;
        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('0059', '');
        VL_Mensagem.AddTag('003D', VL_Chave);
        VL_Mensagem.TagToStr(VL_Tag);
        VL_Codigo := SolicitacaoBloc(VL_Tag, VL_Tag, C_TempoSolicitacao);
        if VL_Codigo <> 0 then
        begin
            ShowMessage('Erro:' + IntToStr(VL_Codigo));
            Exit;
        end;
        VL_Mensagem.Limpar;
        VL_Mensagem.CarregaTags(VL_Tag);
        VL_Mensagem.GetComando(VL_Retorno, VL_Tag);
        case VL_Retorno of
            '0026':
            begin
                VL_Mensagem.GetTag('0026', VL_Tag);
                ShowMessage('ERRO:' + VL_Tag);
                Exit;
            end;
            '004D':
            begin
                if VL_TAG <> '0' then
                begin
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    ShowMessage('ERRO:' + VL_Tag);
                    Exit;
                end;
                TabConfEChave.Lines.Text := VL_Chave;
            end;
        end;
    finally
        VL_Mensagem.Free;
    end;

end;


procedure Tfprincipal.TabConfBModificarClick(Sender: TObject);
var
    VL_Status: integer;
begin
    VL_Status := 0;
    F_OpenTefStatus(VL_Status);
    if VL_Status <> Ord(csLogado) then
    begin
        ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
        Desconectar;
        Exit;
    end;
    if MDConfigurador.Active = False then
    begin
        ShowMessage('MDConfigurador não está ativo');
        Exit;
    end;
    if TabConfEDescricao.Text = '' then
    begin
        ShowMessage('Descricao é um campo obrigatório');
        exit;
    end;
    if GravaRegistros('TabConf', False) then
        AlterarRegistro('008F', MDConfigurador, '0056', StrToInt(TabConfEID.Text), '0058', 'S');

end;

procedure Tfprincipal.TabConfEFiltroChange(Sender: TObject);
var
    VL_Filtro: string;
begin
    if F_Permissao = False then
        EXIT;
    VL_Filtro := '';
    MDConfigurador.Filter := FiltrarTabela(TabConfGrid, VL_Filtro, TabConfEFiltro);
    TabConfLFiltro.Caption := VL_Filtro;
    MDConfigurador.Filtered := True;
end;

procedure Tfprincipal.TabConfGridCellClick(Column: TColumn);
begin
    TabConfLFiltro.Caption := 'Filtrar por ' + TabConfGrid.SelectedColumn.Title.Caption;
end;

procedure Tfprincipal.TabLojaEFiltroChange(Sender: TObject);
var
    VL_Filtro: string;
begin
    if F_Permissao = False then
        EXIT;
    VL_Filtro := '';
    MDLoja.Filter := FiltrarTabela(TabLojaGrid, VL_Filtro, TabLojaEFiltro);
    TabLojaLFiltro.Caption := VL_Filtro;
    MDLoja.Filtered := True;
end;

procedure Tfprincipal.TabLojaGridCellClick(Column: TColumn);
begin
    TabLojaLFiltro.Caption := 'Filtrar por ' + TabLojaGrid.SelectedColumn.Title.Caption;
end;

procedure Tfprincipal.TabLojaGridDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: integer; Column: TColumn; State: TGridDrawState);
begin
    if MDLoja.FieldByName('MULT').AsString = 'T' then
    begin
        TDBGrid(Sender).Canvas.Brush.Color := clSkyBlue;
        TDBGrid(Sender).Canvas.Font.Color := clBlack;
    end;
    TabLojaGrid.Canvas.FillRect(Rect);
    TDBGrid(Sender).DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure Tfprincipal.TabLojaModuloBAdicionarClick(Sender: TObject);
var
    VL_Status: integer;
    VL_Mensagem: TMensagem;
    VL_Codigo: integer;
    VL_ID: int64;
    VL_Retorno, VL_Tag: string;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            Desconectar;
            Exit;
        end;
        if MDLojaModuloConf.Active = False then
        begin
            ShowMessage('MDLojaModulo não está ativo');
            Exit;
        end;
        if GravaRegistros('TabLojaModulo', True) then
        begin
            VL_Codigo := IncluirRegistro(MDLojaModuloConf, '00AE', 'S', '00A7', VL_Tag);

            if VL_Codigo <> 0 then
            begin
                ShowMessage(IntToStr(VL_Codigo));
                exit;
            end;

            VL_Mensagem.Limpar;
            VL_Mensagem.CarregaTags(VL_Tag);
            VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

            case VL_Retorno of
                '0026':
                begin
                    VL_Mensagem.GetTag('0026', VL_Tag);
                    ShowMessage('ERRO:' + VL_Tag);
                    if MDLojaModuloConf.Locate('ID', 0, []) then
                        MDLojaModuloConf.Delete;
                    Exit;
                end;
                '00AE':
                begin
                    if VL_Tag <> 'R' then
                    begin
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                        Exit;
                    end;
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    if vl_tag <> '0' then
                    begin
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        ShowMessage('ERRO:' + VL_Tag);
                        if MDLojaModuloConf.Locate('ID', 0, []) then
                            MDLojaModuloConf.Delete;
                        Exit;
                    end;
                    VL_Mensagem.GetTag('00AF', VL_ID); //RETORNO DO ID DO LOJA_MODULO_ID
                    F_Navegar := False;
                    if MDLojaModuloConf.Locate('ID', 0, []) then
                    begin
                        MDLojaModuloConf.Edit;
                        MDLojaModuloConf.FieldByName('ID').AsInteger := VL_ID;
                        MDLojaModuloConf.Post;
                    end;
                end;
            end;
            CarregaCampos;
            ShowMessage('Registro incluido com sucesso');
        end;

    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;

end;

procedure Tfprincipal.TabLojaModuloBExcluirClick(Sender: TObject);
var
    VL_Status: integer;
    VL_Codigo: integer;
    VL_Mensagem: TMensagem;
    VL_Retorno, VL_Tag: string;
    VL_ID: int64;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            Desconectar;
            Exit;
        end;
        if MDLojaModuloConf.Active = False then
        begin
            ShowMessage('MDLojaModulo não está ativo');
            Exit;
        end;
        if length(TabLojaModuloEID.Text) = 0 then
        begin
            ShowMessage('Não existe registro selecionado para exclusão');
            Exit;
        end;

        VL_Codigo := ExcluirRegistro('00AF', StrToInt(TabLojaModuloEID.Text), '00B2', 'S', VL_Tag);
        if VL_Codigo <> 0 then
        begin
            ShowMessage(IntToStr(VL_Codigo));
            exit;
        end;
        VL_Mensagem.Limpar;
        VL_Mensagem.CarregaTags(VL_Tag);
        VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

        case VL_Retorno of
            '0026':
            begin
                VL_Mensagem.GetTag('0026', VL_ID);
                ShowMessage('ERRO:' + IntToStr(VL_ID));
                Exit;
            end;
            '00B1':
            begin
                if VL_Tag <> 'R' then
                begin
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                    Exit;
                end;
                VL_Mensagem.GetTag('004D', VL_Tag);
                if vl_tag <> '0' then
                begin
                    VL_Mensagem.GetTag('004D', VL_ID);
                    ShowMessage('ERRO:' + IntToStr(VL_ID));
                    Exit;
                end;
                VL_Mensagem.GetTag('00AF', VL_ID);
                F_Navegar := False;
                if MDLojaModuloConf.Locate('ID', VL_ID, []) then
                    MDLojaModuloConf.Delete;
            end;
        end;
        ShowMessage('Registro Excluido com sucesso');
        CarregaCampos;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;

end;

procedure Tfprincipal.TabLojaModuloBModificarClick(Sender: TObject);
var
    VL_Status: integer;
begin
    F_OpenTefStatus(VL_Status);
    if VL_Status <> Ord(csLogado) then
    begin
        ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
        Desconectar;
        Exit;
    end;
    if MDLojaModuloConf.Active = False then
    begin
        ShowMessage('MDLojaModulo não está ativo');
        Exit;
    end;

    if GravaRegistros('TabLojaModulo', False) then
        AlterarRegistro('00A7', MDLojaModuloConf, '00AF', StrToInt(TabLojaModuloEID.Text), '00B1', 'S');

end;

procedure Tfprincipal.TabLojaModuloBPesquisaModuloConfClick(Sender: TObject);
var
    VL_FPesquisaModulo: TFModuloConf;
begin
    if F_Permissao = False then
        exit;
    VL_FPesquisaModulo := TFModuloConf.Create(Self);
    VL_FPesquisaModulo.F_Tabela := RxMemDataToStr(MDPesquisaModulo);
    VL_FPesquisaModulo.ShowModal;
    if VL_FPesquisaModulo.F_Carregado then
    begin
        TabLojaModuloEModuloConfID.Text := VL_FPesquisaModulo.MDPesquisaModulo.FieldByName('MODULO_CONF_ID').AsString;
        TabLojaModuloEModuloConf.Text := VL_FPesquisaModulo.MDPesquisaModulo.FieldByName('MODULO_CONF_DESCRICAO').AsString;
    end;

end;


procedure Tfprincipal.TabLojaModuloEFiltroChange(Sender: TObject);
var
    VL_Filtro: string;
begin
    if F_Permissao = False then
        EXIT;
    VL_Filtro := '';
    MDLojaModuloConf.Filter := FiltrarTabela(TabLojaModuloGrid, VL_Filtro, TabLojaModuloEFiltro);
    TabLojaModuloLFiltro.Caption := VL_Filtro;
    MDLojaModuloConf.Filtered := True;
end;

procedure Tfprincipal.TabLojaShow(Sender: TObject);
begin
    TabLojaTabModuloDados.OnShow(self);
    PageLojaVisualizarModuloFuncao.PageIndex := 0;
    PageLojaVizualizarConfModuloFuncao.PageIndex := 0;
end;

procedure Tfprincipal.TabLojaFuncaoShow(Sender: TObject);
begin
    if ((F_Navegar) and (F_Permissao)) then
        //carrega loja_funcao
        CarregarTabelas(False, '00A9', '003C', MDLoja.FieldByName('ID').AsInteger);
end;

procedure Tfprincipal.TabModuloBAdicionarClick(Sender: TObject);
var
    VL_Status: integer;
    VL_Mensagem: TMensagem;
    VL_Codigo: integer;
    VL_ID: int64;
    VL_Retorno, VL_Tag: string;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            Desconectar;
            Exit;
        end;
        if MDModulo.Active = False then
        begin
            ShowMessage('MDModulo não está ativo');
            Exit;
        end;
        if TabModuloEDescricao.Text = '' then
        begin
            ShowMessage('Descricao é um campo obrigatório');
            exit;
        end;

        if GravaRegistros('TabModulo', True) then
        begin
            VL_Codigo := IncluirRegistro(MDModulo, '0074', 'S', '0090', VL_Tag);
            if VL_Codigo <> 0 then
            begin
                ShowMessage(IntToStr(VL_Codigo));
                exit;
            end;

            VL_Mensagem.Limpar;
            VL_Mensagem.CarregaTags(VL_Tag);
            VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

            case VL_Retorno of
                '0026':
                begin
                    VL_Mensagem.GetTag('0026', VL_Tag);
                    ShowMessage('ERRO:' + VL_Tag);
                    if MDModulo.Locate('ID', 0, []) then
                        MDModulo.Delete;
                    Exit;
                end;
                '0074':
                begin
                    if VL_Tag <> 'R' then
                    begin
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                        Exit;
                    end;
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    if vl_tag <> '0' then
                    begin
                        ShowMessage('ERRO:' + VL_Tag);
                        if MDModulo.Locate('ID', 0, []) then
                            MDModulo.Delete;
                        Exit;
                    end;
                    VL_Mensagem.GetTag('006C', VL_ID); //RETORNO DO ID DO MODULO
                    F_Navegar := False;
                    if MDModulo.Locate('ID', 0, []) then
                    begin
                        MDModulo.Edit;
                        MDModulo.FieldByName('ID').AsInteger := VL_ID;
                        MDModulo.Post;
                    end;
                end;
            end;
            CarregaCampos;
            ShowMessage('Registro incluido com sucesso');
        end;

    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;
end;

procedure Tfprincipal.TabModuloBExcluirClick(Sender: TObject);
var
    VL_Status: integer;
    VL_Codigo: integer;
    VL_Mensagem: TMensagem;
    VL_Retorno, VL_Tag: string;
    VL_ID: int64;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            Desconectar;
            Exit;
        end;
        if MDModulo.Active = False then
        begin
            ShowMessage('MDModulo não está ativo');
            Exit;
        end;
        if MDModulo.RecordCount = 0 then
        begin
            ShowMessage('Não existe Módulo para ser excluido');
            exit;
        end;
        VL_Codigo := ExcluirRegistro('006C', MDModulo.FieldByName('ID').AsInteger, '008C', 'S', VL_Tag);

        if VL_Codigo <> 0 then
        begin
            ShowMessage(IntToStr(VL_Codigo));
            exit;
        end;
        VL_Mensagem.Limpar;
        VL_Mensagem.CarregaTags(VL_Tag);
        VL_Mensagem.GetComando(VL_Retorno, VL_Tag);
        case VL_Retorno of
            '0026':
            begin
                VL_Mensagem.GetTag('0026', VL_ID);
                ShowMessage('ERRO:' + IntToStr(VL_ID));
                Exit;
            end;
            '008C':
            begin
                if VL_Tag <> 'R' then
                begin
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                    Exit;
                end;
                VL_Mensagem.GetTag('004D', VL_Tag);
                if vl_tag <> '0' then
                begin
                    VL_Mensagem.GetTag('004D', VL_ID);
                    ShowMessage('ERRO:' + IntToStr(VL_ID));
                    Exit;
                end;
                VL_Mensagem.GetTag('006C', VL_ID); //MODULO_ID
                F_Navegar := False;
                if MDModulo.Locate('ID', VL_ID, []) then
                    MDModulo.Delete;
            end;
        end;
        CarregaCampos;
        ShowMessage('Registro Excluido com sucesso');
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;
end;

procedure Tfprincipal.TabModuloBLocalizaTagClick(Sender: TObject);
var
    VL_FPesquisaTag: TFTags;
begin
    VL_FPesquisaTag := TFTags.Create(Self);
    VL_FPesquisaTag.F_Tabela := RxMemDataToStr(MDTags);
    VL_FPesquisaTag.F_TagTipo := 'M'; //TIPO MODULOS
    VL_FPesquisaTag.ShowModal;
    if VL_FPesquisaTag.F_Carregado then
    begin
        F_Navegar := False;
        MDModulo.Edit;
        MDModulo.FieldByName('TAG_NUMERO').AsString := VL_FPesquisaTag.MDTags.FieldByName('TAG_NUMERO').AsString;
        MDModulo.Post;
        F_Navegar := True;
        CarregaCampos;
    end;
end;

procedure Tfprincipal.TabModuloBModificarClick(Sender: TObject);
var
    VL_Status: integer;
begin
    VL_Status := 0;
    F_OpenTefStatus(VL_Status);
    if VL_Status <> Ord(csLogado) then
    begin
        ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
        Desconectar;
        Exit;
    end;
    if MDModulo.Active = False then
    begin
        ShowMessage('MDModulo não está ativo');
        Exit;
    end;
    if ((TabModuloEID.Text = '') or (TabModuloEID.Text = '0')) then
    begin
        ShowMessage('Operação cancelada, selecione um Módulo para alterar');
        exit;
    end;
    if GravaRegistros('TabModulo', False) then
        AlterarRegistro('0090', MDModulo, '006C', StrToInt(TabModuloEID.Text), '0075', 'S');

end;

procedure Tfprincipal.TabModuloContextPopup(Sender: TObject; MousePos: TPoint; var Handled: boolean);
begin

end;

procedure Tfprincipal.TabModuloEPesquisaModuloChange(Sender: TObject);
begin
    MDModulo.Filter := 'DESCRICAO=(''*' + TabModuloEPesquisaModulo.Text + '*'')';
    MDModulo.Filtered := True;
end;

procedure Tfprincipal.TabModuloShow(Sender: TObject);
begin
    TabModuloPagePrincipal.ActivePageIndex := 0;
    TabModuloPageModuloFuncao.ActivePageIndex := 0;
    TabConfiguracao.OnShow(SELF);
end;

procedure Tfprincipal.TabModuloTabDadosFuncaoEFiltroChange(Sender: TObject);
var
    VL_Filtro: string;
begin
    if F_Permissao = False then
        EXIT;
    VL_Filtro := '';
    MDModuloConfFuncao.Filter := FiltrarTabela(TabModuloTabDadosFuncaoGrid, VL_Filtro, TabModuloTabDadosFuncaoEFiltro);
    TabModuloTabDadosFuncaoLFiltro.Caption := VL_Filtro;
    MDModuloConfFuncao.Filtered := True;
end;

procedure Tfprincipal.TabModuloTabDadosFuncaoGridCellClick(Column: TColumn);
var
    VL_Status: integer;
    VL_Mensagem: TMensagem;
    VL_Codigo: integer;
    VL_ID: int64;
    VL_Retorno, VL_Tag: string;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    if TabModuloTabDadosFuncaoGrid.SelectedColumn.FieldName <> 'VALIDADO_F' then
        TabModuloTabDadosFuncaoEFiltro.Caption := 'Filtrar por ' + TabModuloTabDadosFuncaoGrid.SelectedColumn.Title.Caption;
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            Desconectar;
            Exit;
        end;
        if ((MDModuloConfig.Active = False) or (MDModuloConfig.RecordCount < 1)) then
            exit;
        if ((MDModuloConfFuncao.Active = False) or (MDModuloConfFuncao.RecordCount < 1)) then
            exit;
        F_Navegar := False;

        if ((Column.FieldName = 'VALIDADO_F') or (Column.FieldName = 'HABILITADO_F')) then
        begin
            VL_ID := MDModuloConfFuncaoID.AsInteger;
            if (Column.FieldName = 'VALIDADO_F') then
            begin
                MDModuloConfFuncao.Edit;
                MDModuloConfFuncao.FieldByName('VALIDADO').AsBoolean := not MDModuloConfFuncao.FieldByName('VALIDADO').AsBoolean;
                MDModuloConfFuncao.Post;
            end;
            if (Column.FieldName = 'HABILITADO_F') then
            begin
                MDModuloConfFuncao.Edit;
                MDModuloConfFuncao.FieldByName('HABILITADO').AsBoolean := not MDModuloConfFuncao.FieldByName('HABILITADO').AsBoolean;
                MDModuloConfFuncao.Post;
            end;

            if ((MDModuloConfFuncao.FieldByName('VALIDADO').AsBoolean = True) and (VL_ID < 1)) then
            begin
                MDModuloConfFuncao.Edit;
                MDModuloConfFuncao.FieldByName('MODULO_CONF_ID').AsString := MDModuloConfig.FieldByName('ID').AsString;
                MDModuloConfFuncao.FieldByName('ID').AsInteger := 0;
                MDModuloConfFuncao.Post;
                //incluir modulo função
                VL_Codigo := IncluirRegistro(MDModuloConfFuncao, '0079', 'S', '0093', VL_Tag);
                if VL_Codigo <> 0 then
                begin
                    ShowMessage(IntToStr(VL_Codigo));
                    exit;
                end;

                VL_Mensagem.Limpar;
                VL_Mensagem.CarregaTags(VL_Tag);
                VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

                case VL_Retorno of
                    '0026':
                    begin
                        VL_Mensagem.GetTag('0026', VL_Tag);
                        ShowMessage('ERRO:' + VL_Tag);
                        if MDModuloConfFuncao.Locate('ID', 0, []) then
                            MDModuloConfFuncao.Delete;
                        Exit;
                    end;
                    '0079':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                            Exit;
                        end;
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        if vl_tag <> '0' then
                        begin
                            ShowMessage('ERRO:' + VL_Tag);
                            if MDModuloConfFuncao.Locate('ID', 0, []) then
                                MDModuloConfFuncao.Delete;
                            Exit;
                        end;
                        VL_Mensagem.GetTag('006D', VL_ID); //RETORNO DO ID DO MODULO_CONF_FUNC
                        F_Navegar := False;
                        if MDModuloConfFuncao.Locate('ID', 0, []) then
                        begin
                            MDModuloConfFuncao.Edit;
                            MDModuloConfFuncao.FieldByName('ID').AsInteger := VL_ID;
                            MDModuloConfFuncao.Post;
                        end;
                    end;
                end;
            end
            else
            if ((MDModuloConfFuncao.FieldByName('VALIDADO').AsBoolean = True) and (VL_ID > 0)) then
            begin
                //ALTERA MODULO_CONF_FUNCAO
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0085', 'S');
                VL_Mensagem.AddTag('006D', VL_ID);
                VL_Mensagem.AddTag('0086', MDModuloConfFuncao.FieldByName('HABILITADO').AsString);
                VL_Mensagem.TagToStr(VL_Tag);
                VL_Codigo := SolicitacaoBloc(VL_Tag, VL_Tag, C_TempoSolicitacao);
                if VL_Codigo <> 0 then
                begin
                    ShowMessage(IntToStr(VL_Codigo));
                    exit;
                end;
                VL_Mensagem.Limpar;
                VL_Mensagem.CarregaTags(VL_Tag);
                VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

                case VL_Retorno of
                    '0026':
                    begin
                        VL_Mensagem.GetTag('0026', VL_Tag);
                        ShowMessage('ERRO:' + VL_Tag);
                        if MDModuloConfFuncao.Locate('ID', 0, []) then
                            MDModuloConfFuncao.Delete;
                        Exit;
                    end;
                    '0085':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                            Exit;
                        end;
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        if vl_tag <> '0' then
                        begin
                            ShowMessage('ERRO:' + VL_Tag);
                            Exit;
                        end;
                    end;
                end;
            end
            else
            begin
                //EXCLUIR modulo_CONF_função
                VL_Codigo := ExcluirRegistro('006D', VL_ID, '008A', 'S', VL_Tag);
                if VL_Codigo <> 0 then
                begin
                    ShowMessage(IntToStr(VL_Codigo));
                    exit;
                end;
                VL_Mensagem.Limpar;
                VL_Mensagem.CarregaTags(VL_Tag);
                VL_Mensagem.GetComando(VL_Retorno, VL_Tag);
                case VL_Retorno of
                    '0026':
                    begin
                        VL_Mensagem.GetTag('0026', VL_Tag);
                        ShowMessage('ERRO:' + VL_Tag);
                        if MDModuloConfFuncao.Locate('ID', 0, []) then
                            MDModuloConfFuncao.Delete;
                        Exit;
                    end;
                    '008A':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                            Exit;
                        end;
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        if vl_tag <> '0' then
                        begin
                            ShowMessage('ERRO:' + VL_Tag);
                            Exit;
                        end;
                    end;
                end;
                MDModuloConfFuncao.Edit;
                MDModuloConfFuncao.FieldByName('ID').AsInteger := -1;
                MDModuloConfFuncao.Post;
            end;
        end;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;
end;

procedure Tfprincipal.TabModuloTabDadosFuncaoShow(Sender: TObject);
begin
    if ((F_Navegar) and (F_Permissao)) then
        //carrega ModuloFunc_conf
        CarregarTabelas(False, '0093', '007B', MDModuloConfig.FieldByName('ID').AsInteger);
end;

procedure Tfprincipal.TabMultLojaBAdicionarClick(Sender: TObject);
var
    VL_Status: integer;
    VL_Codigo: integer;
    VL_ID: int64;
    VL_Retorno: ansistring;
    VL_Tag: ansistring;
    VL_Mensagem: TMensagem;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_Status := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            Desconectar;
            Exit;
        end;
        if MDLoja.Active = False then
        begin
            ShowMessage('MDLoja não está ativo');
            Exit;
        end;
        if MDMultiLoja.Active = False then
        begin
            ShowMessage('MDMultiLoja não está ativo');
            Exit;
        end;

        if GravaRegistros('TabMultLoja', True) then
        begin
            VL_Codigo := IncluirRegistro(MDMultiLoja, '0064', 'S', '0080', VL_Tag);

            if VL_Codigo <> 0 then
            begin
                ShowMessage(IntToStr(VL_Codigo));
                exit;
            end;

            VL_Mensagem.Limpar;
            VL_Mensagem.CarregaTags(VL_Tag);
            VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

            case VL_Retorno of
                '0026':
                begin
                    VL_Mensagem.GetTag('0026', VL_Tag);
                    ShowMessage('ERRO:' + VL_Tag);
                    if MDMultiLoja.Locate('ID', 0, []) then
                        MDMultiLoja.Delete;
                    Exit;
                end;
                '0064':
                begin
                    if VL_Tag <> 'R' then
                    begin
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                        Exit;
                    end;
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    if VL_Tag <> '0' then
                    begin
                        ShowMessage('ERRO:' + VL_Tag);
                        if MDMultiLoja.Locate('ID', 0, []) then
                            MDMultiLoja.Delete;
                        Exit;
                    end;
                    VL_Mensagem.GetTag('0065', VL_ID); //MULT-LOJA_ID
                    F_Navegar := False;
                    if MDMultiLoja.Locate('ID', 0, []) then
                    begin
                        MDMultiLoja.Edit;
                        MDMultiLoja.FieldByName('ID').AsInteger := VL_ID;
                        MDMultiLoja.Post;
                        F_Navegar := True;
                    end;
                end;
            end;
            CarregaCampos;
            ShowMessage('Registro incluido com sucesso');

        end;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;

end;

procedure Tfprincipal.TabMultLojaBAtualizarClick(Sender: TObject);
var
    VL_Status, VL_Codigo: integer;
begin
    if F_Permissao = False then
        exit;

    F_OpenTefStatus(VL_Status);
    if VL_Status <> Ord(csLogado) then
    begin
        ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
        Desconectar;
        Exit;
    end;
    if MDMultiLoja.Active = False then
    begin
        ShowMessage('MDMultLoja não está ativo');
        Exit;
    end;

    if GravaRegistros('TabMultLoja', False) then
        AlterarRegistro('0080', MDMultiLoja, '0065', MDMultiLoja.FieldByName('ID').AsInteger, '0067', 'S');

end;

procedure Tfprincipal.TabMultLojaBExcluirClick(Sender: TObject);
var
    VL_Status: integer;
    VL_Codigo: integer;
    VL_Mensagem: TMensagem;
    VL_Retorno, VL_Tag: string;
    VL_ID: int64;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            Desconectar;
            Exit;
        end;
        if MDMultiLoja.Active = False then
        begin
            ShowMessage('MDMultLoja não está ativo');
            Exit;
        end;
        VL_Codigo := ExcluirRegistro('0065', MDMultiLoja.FieldByName('ID').AsInteger, '0066', 'S', VL_Tag);

        if VL_Codigo <> 0 then
        begin
            ShowMessage(IntToStr(VL_Codigo));
            exit;
        end;
        VL_Mensagem.Limpar;
        VL_Mensagem.CarregaTags(VL_Tag);
        VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

        case VL_Retorno of
            '0026':
            begin
                VL_Mensagem.GetTag('0026', VL_ID);
                ShowMessage('ERRO:' + IntToStr(VL_ID));
                Exit;
            end;
            '0066':
            begin
                if VL_Tag <> 'R' then
                begin
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                    Exit;
                end;
                VL_Mensagem.GetTag('004D', VL_TAG);
                if VL_Tag <> '0' then
                begin
                    VL_Mensagem.GetTag('004D', VL_ID);
                    ShowMessage('ERRO:' + IntToStr(VL_ID));
                    Exit;
                end;
                F_Navegar := False;
                MDMultiLoja.Delete;
            end;
        end;
        ShowMessage('Registro Excluido com sucesso');
        CarregarTabelas(True, '', '', 0);
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;
end;

procedure Tfprincipal.TabMultLojaCkLojaMasterChange(Sender: TObject);
begin
    if F_Permissao = False then
        exit;
    MDMultiLoja.Edit;
    MDMultiLoja.FieldByName('HABILITADO').AsBoolean := TabMultLojaCkLojaMaster.Checked;
    MDMultiLoja.Post;
end;

procedure Tfprincipal.TabMultLojaConfFuncaoCKSelecionadaChange(Sender: TObject);
begin
    if TabMultLojaConfFuncaoCKSelecionada.Checked then
    begin
        MDMultiLojaModuloConf.Filter := 'VALIDADO=''T''';
        MDMultiLojaModuloConf.Filtered := True;
    end
    else
    begin
        MDMultiLojaModuloConf.Filter := '';
        MDMultiLojaModuloConf.Filtered := False;
    end;
end;

procedure Tfprincipal.TabMultLojaConfFuncaoEFiltroChange(Sender: TObject);
var
    VL_Filtro: string;
begin
    if F_Permissao = False then
        EXIT;
    VL_Filtro := '';
    MDMultiLojaModuloConfFuncao.Filter := FiltrarTabela(TabMultLojaConfFuncaoGrid, VL_Filtro, TabMultLojaConfFuncaoEFiltro);
    TabMultLojaModuloLFiltro.Caption := VL_Filtro;
    MDMultiLojaModuloConfFuncao.Filtered := True;
end;

procedure Tfprincipal.TabMultLojaConfFuncaoGridCellClick(Column: TColumn);
var
    VL_Status: integer;
    VL_Mensagem: TMensagem;
    VL_Codigo: integer;
    VL_ID: int64;
    VL_Retorno, VL_Tag: string;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';

    if TabMultLojaConfFuncaoGrid.SelectedColumn.FieldName <> 'VALIDADO_F' then
        TabLojaTabFuncaoDadosLFiltro.Caption := 'Filtrar por ' + TabMultLojaConfFuncaoGrid.SelectedColumn.Title.Caption;
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            Desconectar;
            Exit;
        end;
        if ((MDMultiLojaModuloConf.Active = False) or (MDMultiLojaModuloConf.RecordCount < 1)) then
            exit;
        if ((MDMultiLojaModuloConfFuncao.Active = False) or (MDMultiLojaModuloConfFuncao.RecordCount < 1)) then
            exit;
        F_Navegar := False;
        if ((TabMultLojaConfFuncaoGrid.SelectedColumn.FieldName = 'VALIDADO_F') or
            (TabMultLojaConfFuncaoGrid.SelectedColumn.FieldName = 'HABILITADO_F')) then
        begin
            VL_ID := MDLojaModuloConfFuncaoID.AsInteger;
            if (TabMultLojaConfFuncaoGrid.SelectedColumn.FieldName = 'VALIDADO_F') then
            begin
                MDMultiLojaModuloConfFuncao.Edit;
                MDMultiLojaModuloConfFuncao.FieldByName('VALIDADO').AsBoolean := not MDMultiLojaModuloConfFuncao.FieldByName('VALIDADO').AsBoolean;
                MDMultiLojaModuloConfFuncao.Post;
            end;
            if (TabMultLojaConfFuncaoGrid.SelectedColumn.FieldName = 'HABILITADO_F') then
            begin
                MDMultiLojaModuloConfFuncao.Edit;
                MDMultiLojaModuloConfFuncao.FieldByName('HABILITADO').AsBoolean := not MDMultiLojaModuloConfFuncao.FieldByName('HABILITADO').AsBoolean;
                MDMultiLojaModuloConfFuncao.Post;
            end;

            if ((MDMultiLojaModuloConfFuncao.FieldByName('VALIDADO').AsBoolean = True) and (VL_ID < 1)) then
            begin
                MDMultiLojaModuloConfFuncao.Edit;
                MDMultiLojaModuloConfFuncao.FieldByName('MULTILOJA_MODULO_CONF_ID').AsString := MDMultiLojaModuloConf.FieldByName('ID').AsString;
                MDMultiLojaModuloConfFuncao.FieldByName('ID').AsInteger := 0;
                MDMultiLojaModuloConfFuncao.Post;
                //incluir loja_modulo_conf_funcao
                VL_Codigo := IncluirRegistro(MDMultiLojaModuloConfFuncao, '00CA', 'S', '00D0', VL_Tag);
                if VL_Codigo <> 0 then
                begin
                    ShowMessage(IntToStr(VL_Codigo));
                    exit;
                end;

                VL_Mensagem.Limpar;
                VL_Mensagem.CarregaTags(VL_Tag);
                VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

                case VL_Retorno of
                    '0026':
                    begin
                        VL_Mensagem.GetTag('0026', VL_Tag);
                        ShowMessage('ERRO:' + VL_Tag);
                        if MDMultiLojaModuloConfFuncao.Locate('ID', 0, []) then
                            MDMultiLojaModuloConfFuncao.Delete;
                        Exit;
                    end;
                    '00CA':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                            Exit;
                        end;
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        if vl_tag <> '0' then
                        begin
                            ShowMessage('ERRO:' + VL_Tag);
                            if MDMultiLojaModuloConfFuncao.Locate('ID', 0, []) then
                                MDMultiLojaModuloConfFuncao.Delete;
                            Exit;
                        end;
                        VL_Mensagem.GetTag('00BD', VL_ID); //RETORNO DO ID DO MULTILOJA_MODULO_CONF_FUNCAO
                        F_Navegar := False;
                        if MDMultiLojaModuloConfFuncao.Locate('ID', 0, []) then
                        begin
                            MDMultiLojaModuloConfFuncao.Edit;
                            MDMultiLojaModuloConfFuncao.FieldByName('ID').AsInteger := VL_ID;
                            MDMultiLojaModuloConfFuncao.Post;
                        end;
                    end;
                end;
            end
            else
            if ((MDMultiLojaModuloConfFuncao.FieldByName('VALIDADO').AsBoolean = True) and (VL_ID > 0)) then
            begin
                //ALTERA MULTILOJA_MODULO_CONF_FUNCAO
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00B0', 'S');
                VL_Mensagem.AddTag('00BD', VL_ID);
                VL_Mensagem.AddTag('0084', MDMultiLojaModuloConfFuncao.FieldByName('HABILITADO').AsString);
                VL_Mensagem.TagToStr(VL_Tag);
                VL_Codigo := SolicitacaoBloc(VL_Tag, VL_Tag, C_TempoSolicitacao);
                if VL_Codigo <> 0 then
                begin
                    ShowMessage(IntToStr(VL_Codigo));
                    exit;
                end;

                VL_Mensagem.Limpar;
                VL_Mensagem.CarregaTags(VL_Tag);
                VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

                case VL_Retorno of
                    '0026':
                    begin
                        VL_Mensagem.GetTag('0026', VL_Tag);
                        ShowMessage('ERRO:' + VL_Tag);
                        if MDMultiLojaModuloConfFuncao.Locate('ID', 0, []) then
                            MDMultiLojaModuloConfFuncao.Delete;
                        Exit;
                    end;
                    '00B0':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                            Exit;
                        end;
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        if vl_tag <> '0' then
                        begin
                            ShowMessage('ERRO:' + VL_Tag);
                            Exit;
                        end;
                    end;
                end;
            end
            else
            begin
                //excluir multloja_modulo_conf_função
                VL_Codigo := ExcluirRegistro('00BD', VL_ID, '0088', 'S', VL_Tag);

                if VL_Codigo <> 0 then
                begin
                    ShowMessage(IntToStr(VL_Codigo));
                    exit;
                end;
                VL_Mensagem.Limpar;
                VL_Mensagem.CarregaTags(VL_Tag);
                VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

                case VL_Retorno of
                    '0026':
                    begin
                        VL_Mensagem.GetTag('0026', VL_Tag);
                        ShowMessage('ERRO:' + VL_Tag);
                        if MDMultiLojaModuloConfFuncao.Locate('ID', 0, []) then
                            MDMultiLojaModuloConfFuncao.Delete;
                        Exit;
                    end;
                    '0088':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                            Exit;
                        end;
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        if vl_tag <> '0' then
                        begin
                            ShowMessage('ERRO:' + VL_Tag);
                            Exit;
                        end;
                    end;
                end;
                MDMultiLojaModuloConfFuncao.Edit;
                MDMultiLojaModuloConfFuncao.FieldByName('ID').AsInteger := -1;
                MDMultiLojaModuloConfFuncao.Post;
            end;
        end;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;
end;


procedure Tfprincipal.TabMultLojaEFiltroChange(Sender: TObject);
var
    VL_Filtro: string;
begin
    if F_Permissao = False then
        exit;
    VL_Filtro := '';
    MDLoja.Filter := FiltrarTabela(TabMultLojaGridFiltro, VL_Filtro, TabMultLojaEFiltro);
    TabMultLojaLFiltro.Caption := VL_Filtro;
    MDLoja.Filtered := True;
end;

procedure Tfprincipal.TabMultLojaFuncaoCKSelecionadaChange(Sender: TObject);
begin
    if TabMultLojaFuncaoCKSelecionada.Checked then
    begin
        MDMultiLojaFuncao.Filter := 'VALIDADO=''T''';
        MDMultiLojaFuncao.Filtered := True;
    end
    else
    begin
        MDMultiLojaFuncao.Filter := '';
        MDMultiLojaFuncao.Filtered := False;
    end;
end;

procedure Tfprincipal.TabMultLojaFuncaoEFiltrarChange(Sender: TObject);
var
    VL_Filtro: string;
begin
    if F_Permissao = False then
        exit;

    VL_Filtro := '';
    MDMultiLojaFuncao.Filter := FiltrarTabela(TabMultLojaFuncaoGrid, VL_Filtro, TabMultLojaFuncaoEFiltrar);
    TabMultLojaFuncaoLFiltrar.Caption := VL_Filtro;
    MDMultiLojaFuncao.Filtered := True;
end;

procedure Tfprincipal.TabMultLojaFuncaoGridCellClick(Column: TColumn);
var
    VL_Status: integer;
    VL_Mensagem: TMensagem;
    VL_Codigo: integer;
    VL_ID: int64;
    VL_Retorno, VL_Tag: string;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    if TabMultLojaFuncaoGrid.SelectedColumn.FieldName <> 'VALIDADO_F' then
        TabMultLojaFuncaoLFiltrar.Caption := 'Filtrar por ' + TabMultLojaFuncaoGrid.SelectedColumn.Title.Caption;
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            Desconectar;
            Exit;
        end;
        if ((MDMultiLoja.Active = False) or (MDMultiLoja.RecordCount < 1)) then
            exit;
        if ((MDMultiLojaFuncao.Active = False) or (MDMultiLojaFuncao.RecordCount < 1)) then
            exit;
        F_Navegar := False;
        if ((TabMultLojaFuncaoGrid.SelectedColumn.FieldName = 'VALIDADO_F') or
            (TabMultLojaFuncaoGrid.SelectedColumn.FieldName = 'HABILITADO_F')) then
        begin
            VL_ID := MDMultiLojaFuncaoID.AsInteger;
            if (TabMultLojaFuncaoGrid.SelectedColumn.FieldName = 'VALIDADO_F') then
            begin
                MDMultiLojaFuncao.Edit;
                MDMultiLojaFuncao.FieldByName('VALIDADO').AsBoolean := not MDMultiLojaFuncao.FieldByName('VALIDADO').AsBoolean;
                MDMultiLojaFuncao.Post;
            end;
            if (TabMultLojaFuncaoGrid.SelectedColumn.FieldName = 'HABILITADO_F') then
            begin
                MDMultiLojaFuncao.Edit;
                MDMultiLojaFuncao.FieldByName('HABILITADO').AsBoolean := not MDMultiLojaFuncao.FieldByName('HABILITADO').AsBoolean;
                MDMultiLojaFuncao.Post;
            end;

            //CLICOU NO VALIDADO A PRIMEIRA VEZ
            if ((MDMultiLojaFuncao.FieldByName('VALIDADO').AsBoolean = True) and (VL_ID < 1)) then
            begin
                MDMultiLojaFuncao.Edit;
                MDMultiLojaFuncao.FieldByName('MULTILOJA_ID').AsString := MDMultiLoja.FieldByName('ID').AsString;
                MDMultiLojaFuncao.FieldByName('ID').AsInteger := 0;
                MDMultiLojaFuncao.Post;
                //incluir MULTLOJA função
                VL_Codigo := IncluirRegistro(MDMultiLojaFuncao, '009D', 'S', '009C', VL_Tag);
                if VL_Codigo <> 0 then
                begin
                    ShowMessage(IntToStr(VL_Codigo));
                    exit;
                end;

                VL_Mensagem.Limpar;
                VL_Mensagem.CarregaTags(VL_Tag);
                VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

                case VL_Retorno of
                    '0026':
                    begin
                        VL_Mensagem.GetTag('0026', VL_Tag);
                        ShowMessage('ERRO:' + VL_Tag);
                        if MDMultiLojaFuncao.Locate('ID', 0, []) then
                            MDMultiLojaFuncao.Delete;
                        Exit;
                    end;
                    '009D':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                            Exit;
                        end;
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        if VL_Tag <> '0' then
                        begin
                            ShowMessage('ERRO:' + VL_Tag);
                            if MDMultiLojaFuncao.Locate('ID', 0, []) then
                                MDMultiLojaFuncao.Delete;
                            Exit;
                        end;
                        VL_Mensagem.GetTag('009E', VL_ID); //MULTLOJA_FUNCAO_ID
                        F_Navegar := False;
                        if MDMultiLojaFuncao.Locate('ID', 0, []) then
                        begin
                            MDMultiLojaFuncao.Edit;
                            MDMultiLojaFuncao.FieldByName('ID').AsInteger := VL_ID;
                            MDMultiLojaFuncao.Post;
                        end;
                    end;
                end;
            end
            else
            if ((MDMultiLojaFuncao.FieldByName('VALIDADO').AsBoolean = True) and (VL_ID > 0)) then
            begin
                //ALTERA MULTLOJA_FUNCAO
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('009F', 'S');
                VL_Mensagem.AddTag('009E', VL_ID);
                VL_Mensagem.AddTag('00A1', MDMultiLojaFuncao.FieldByName('HABILITADO').AsString);
                VL_Mensagem.TagToStr(VL_Tag);
                VL_Codigo := SolicitacaoBloc(VL_Tag, VL_Tag, C_TempoSolicitacao);
                if VL_Codigo <> 0 then
                begin
                    ShowMessage(IntToStr(VL_Codigo));
                    exit;
                end;

                VL_Mensagem.Limpar;
                VL_Mensagem.CarregaTags(VL_Tag);
                VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

                case VL_Retorno of
                    '0026':
                    begin
                        VL_Mensagem.GetTag('0026', VL_Tag);
                        ShowMessage('ERRO:' + VL_Tag);
                        if MDMultiLojaFuncao.Locate('ID', 0, []) then
                            MDMultiLojaFuncao.Delete;
                        Exit;
                    end;
                    '009F':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                            Exit;
                        end;
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        if VL_Tag <> '0' then
                        begin
                            ShowMessage('ERRO:' + VL_Tag);
                            Exit;
                        end;
                    end;
                end;
            end
            else
            begin
                //alterar multloja função
                VL_Codigo := ExcluirRegistro('009E', VL_ID, '00A0', 'S', VL_Tag);

                if VL_Codigo <> 0 then
                begin
                    ShowMessage(IntToStr(VL_Codigo));
                    exit;
                end;

                VL_Mensagem.Limpar;
                VL_Mensagem.CarregaTags(VL_Tag);
                VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

                case VL_Retorno of
                    '0026':
                    begin
                        VL_Mensagem.GetTag('0026', VL_Tag);
                        ShowMessage('ERRO:' + VL_Tag);
                        if MDMultiLojaFuncao.Locate('ID', 0, []) then
                            MDMultiLojaFuncao.Delete;
                        Exit;
                    end;
                    '00A0':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                            Exit;
                        end;
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        if VL_Tag <> '0' then
                        begin
                            ShowMessage('ERRO:' + VL_Tag);
                            Exit;
                        end;
                    end;
                end;
                MDMultiLojaFuncao.Edit;
                MDMultiLojaFuncao.FieldByName('ID').AsInteger := -1;
                MDMultiLojaFuncao.Post;
            end;
        end;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;

end;

procedure Tfprincipal.TabMultLojaGridFiltroCellClick(Column: TColumn);
begin
    TabMultLojaLFiltro.Caption := 'Filtrar por ' + TabMultLojaGridFiltro.SelectedColumn.Title.Caption;
end;

procedure Tfprincipal.TabMultLojaModuloBAdicionarClick(Sender: TObject);
var
    VL_Status: integer;
    VL_Mensagem: TMensagem;
    VL_Codigo: integer;
    VL_ID: int64;
    VL_Retorno, VL_Tag: string;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            Desconectar;
            Exit;
        end;
        if MDMultiLojaModuloConf.Active = False then
        begin
            ShowMessage('MDMultiLojaModulo não está ativo');
            Exit;
        end;
        if GravaRegistros('TabMultLojaModulo', True) then
        begin
            VL_Codigo := IncluirRegistro(MDMultiLojaModuloConf, '0096', 'S', '0094', VL_Tag);

            if VL_Codigo <> 0 then
            begin
                ShowMessage(IntToStr(VL_Codigo));
                exit;
            end;

            VL_Mensagem.Limpar;
            VL_Mensagem.CarregaTags(VL_Tag);
            VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

            case VL_Retorno of
                '0026':
                begin
                    VL_Mensagem.GetTag('0026', VL_Tag);
                    ShowMessage('ERRO:' + VL_Tag);
                    if MDMultiLojaModuloConf.Locate('ID', 0, []) then
                        MDMultiLojaModuloConf.Delete;
                    Exit;
                end;
                '0096':
                begin
                    if VL_Tag <> 'R' then
                    begin
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                        Exit;
                    end;
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    if VL_Tag <> '0' then
                    begin
                        ShowMessage('ERRO:' + VL_Tag);
                        if MDMultiLojaModuloConf.Locate('ID', 0, []) then
                            MDMultiLojaModuloConf.Delete;
                        Exit;
                    end;
                    VL_Mensagem.GetTag('0097', VL_ID); //MULTLOJA_MODULO_ID
                    F_Navegar := False;
                    if MDMultiLojaModuloConf.Locate('ID', 0, []) then
                    begin
                        MDMultiLojaModuloConf.Edit;
                        MDMultiLojaModuloConf.FieldByName('ID').AsInteger := VL_ID;
                        MDMultiLojaModuloConf.Post;
                    end;
                end;
            end;
            CarregaCampos;
            ShowMessage('Registro incluido com sucesso');
        end;

    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;
end;

procedure Tfprincipal.TabMultLojaModuloBExcluirClick(Sender: TObject);
var
    VL_Status: integer;
    VL_Codigo: integer;
    VL_Mensagem: TMensagem;
    VL_Retorno, VL_Tag: string;
    VL_ID: int64;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            Desconectar;
            Exit;
        end;
        if MDMultiLojaModuloConf.Active = False then
        begin
            ShowMessage('MDMultLojaModulo não está ativo');
            Exit;
        end;
        if length(TabMultLojaModuloEID.Text) = 0 then
        begin
            ShowMessage('Não existe registro selecionado para exclusão');
            Exit;
        end;

        VL_Codigo := ExcluirRegistro('0097', StrToInt(TabMultLojaModuloEID.Text), '0099', 'S', VL_Tag);
        if VL_Codigo <> 0 then
        begin
            ShowMessage(IntToStr(VL_Codigo));
            exit;
        end;
        VL_Mensagem.Limpar;
        VL_Mensagem.CarregaTags(VL_Tag);
        VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

        case VL_Retorno of
            '0026':
            begin
                VL_Mensagem.GetTag('0026', VL_ID);
                ShowMessage('ERRO:' + IntToStr(VL_ID));
                Exit;
            end;
            '0099':
            begin
                if VL_Tag <> 'R' then
                begin
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                    Exit;
                end;

                VL_Mensagem.GetTag('004D', VL_Tag);

                if vl_tag <> '0' then
                begin
                    VL_Mensagem.GetTag('004D', VL_ID);
                    ShowMessage('ERRO:' + IntToStr(VL_ID));
                    Exit;
                end;
                VL_Mensagem.GetTag('0097', VL_ID);
                F_Navegar := False;
                if MDMultiLojaModuloConf.Locate('ID', VL_ID, []) then
                    MDMultiLojaModuloConf.Delete;
            end;
        end;
        ShowMessage('Registro Excluido com sucesso');
        CarregaCampos;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;
end;

procedure Tfprincipal.TabMultLojaModuloBModificarClick(Sender: TObject);
var
    VL_Status: integer;
begin
    F_OpenTefStatus(VL_Status);
    if VL_Status <> Ord(csLogado) then
    begin
        ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
        Desconectar;
        Exit;
    end;
    if MDMultiLojaModuloConf.Active = False then
    begin
        ShowMessage('MDMultLojaModulo não está ativo');
        Exit;
    end;

    if GravaRegistros('TabMultLojaModulo', False) then
        AlterarRegistro('0094', MDMultiLojaModuloConf, '0097', StrToInt(TabMultLojaModuloEID.Text), '009A', 'S');

end;

procedure Tfprincipal.TabMultLojaModuloBPesquisaModuloConfClick(Sender: TObject);
var
    VL_FPesquisaModulo: TFModuloConf;
begin
    if F_Permissao = False then
        exit;
    VL_FPesquisaModulo := TFModuloConf.Create(Self);
    VL_FPesquisaModulo.F_Tabela := RxMemDataToStr(MDPesquisaModulo);
    VL_FPesquisaModulo.ShowModal;
    if VL_FPesquisaModulo.F_Carregado then
    begin
        TabMultLojaModuloEModuloConfID.Text := VL_FPesquisaModulo.MDPesquisaModulo.FieldByName('MODULO_CONF_ID').AsString;
        TabMultLojaModuloEModuloConf.Text := VL_FPesquisaModulo.MDPesquisaModulo.FieldByName('MODULO_CONF_DESCRICAO').AsString;
    end;

end;



procedure Tfprincipal.TabMultLojaModuloEFiltroChange(Sender: TObject);
var
    VL_Filtro: string;
begin
    if F_Permissao = False then
        EXIT;
    VL_Filtro := '';
    MDMultiLojaModuloConf.Filter := FiltrarTabela(TabMultLojaModuloGrid, VL_Filtro, TabMultLojaModuloEFiltro);
    TabMultLojaModuloLFiltro.Caption := VL_Filtro;
    MDMultiLojaModuloConf.Filtered := True;
end;

procedure Tfprincipal.TabMultLojaFuncaoShow(Sender: TObject);
begin
    if ((F_Navegar) and (F_Permissao)) then
        //carrega multloja_funcao
        CarregarTabelas(False, '009C', '0065', MDMultiLoja.FieldByName('ID').AsInteger);
end;

procedure Tfprincipal.TabMultLojaShow(Sender: TObject);
begin
    PageMultiLojaVisualizarModuloFuncao.PageIndex := 0;
    PageMultiLojaVisualizaConfDadosFuncao.PageIndex := 0;
end;

procedure Tfprincipal.TabMultLojaTabFuncaoDadosShow(Sender: TObject);
begin
    if ((F_Navegar) and (F_Permissao)) then
        //carrega multloja_CONF_funcao
        CarregarTabelas(False, '00D0', '0097', MDMultiLojaModuloConf.FieldByName('ID').AsInteger);
end;


procedure Tfprincipal.TabMultLojaTabModuloDadosShow(Sender: TObject);
begin
    if ((F_Permissao) and (F_Navegar)) then
        CarregarTabelas(False, '0094', '0065', MDMultiLoja.FieldByName('ID').AsInteger);
end;

procedure Tfprincipal.TabPdvBAdicionarClick(Sender: TObject);
var
    VL_Status: integer;
    VL_Mensagem: TMensagem;
    VL_Codigo: integer;
    VL_ID: int64;
    VL_Retorno, VL_Tag: string;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            Desconectar;
            Exit;
        end;
        if MDLoja.Active = False then
        begin
            ShowMessage('MDLoja não está ativo');
            Exit;
        end;
        if MDPdv.Active = False then
        begin
            ShowMessage('MDPdv não está ativo');
            Exit;
        end;
        if TabPdvCLoja.LookupDisplayIndex = -1 then
        begin
            ShowMessage('Voce deve selecionar uma loja para cadastrar o PDV.');
            Exit;
        end;
        if GravaRegistros('TabPdv', True) then
        begin
            VL_Codigo := IncluirRegistro(MDPdv, '0044', 'S', '008E', VL_Tag);

            if VL_Codigo <> 0 then
            begin
                ShowMessage(IntToStr(VL_Codigo));
                exit;
            end;

            VL_Mensagem.Limpar;
            VL_Mensagem.CarregaTags(VL_Tag);
            VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

            case VL_Retorno of
                '0026':
                begin
                    VL_Mensagem.GetTag('0026', VL_Tag);
                    ShowMessage('ERRO:' + VL_Tag);
                    if MDPdv.Locate('ID', 0, []) then
                        MDPdv.Delete;
                    Exit;
                end;
                '0044':
                begin
                    if VL_Tag <> 'R' then
                    begin
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                        Exit;
                    end;
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    if vl_tag <> '0' then
                    begin
                        ShowMessage('ERRO:' + VL_Tag);
                        if MDPdv.Locate('ID', 0, []) then
                            MDPdv.Delete;
                        Exit;
                    end;
                    VL_Mensagem.GetTag('0043', VL_ID); //RETORNO DO ID DO PDV
                    F_Navegar := False;
                    if MDPdv.Locate('ID', 0, []) then
                    begin
                        MDPdv.Edit;
                        MDPdv.FieldByName('ID').AsInteger := VL_ID;
                        MDPdv.Post;
                    end;
                end;
            end;
            CarregaCampos;
            ShowMessage('Registro incluido com sucesso');
        end;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;
end;

procedure Tfprincipal.TabPdvBExcluirClick(Sender: TObject);
var
    VL_Status: integer;
    VL_Codigo: integer;
    VL_Mensagem: TMensagem;
    VL_Retorno, VL_Tag: string;
    VL_ID: int64;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            Desconectar;
            Exit;
        end;
        if MDPdv.Active = False then
        begin
            ShowMessage('MDPdv não está ativo');
            Exit;
        end;
        if length(TabPdvEID.Text) = 0 then
        begin
            ShowMessage('Não existe registro selecionado para exclusão');
            Exit;
        end;

        VL_Codigo := ExcluirRegistro('0043', StrToInt(TabPdvEID.Text), '006B', 'S', VL_Tag);

        if VL_Codigo <> 0 then
        begin
            ShowMessage(IntToStr(VL_Codigo));
            exit;
        end;
        VL_Mensagem.Limpar;
        VL_Mensagem.CarregaTags(VL_Tag);
        VL_Mensagem.GetComando(VL_Retorno, VL_Tag);
        case VL_Retorno of
            '0026':
            begin
                VL_Mensagem.GetTag('0026', VL_ID);
                ShowMessage('ERRO:' + IntToStr(VL_ID));
                Exit;
            end;
            '006B':
            begin
                if VL_Tag <> 'R' then
                begin
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                    Exit;
                end;
                VL_Mensagem.GetTag('004D', VL_Tag);
                if vl_tag <> '0' then
                begin
                    VL_Mensagem.GetTag('004D', VL_ID);
                    ShowMessage('ERRO:' + IntToStr(VL_ID));
                    Exit;
                end;
                VL_Mensagem.GetTag('0043', VL_ID);
                F_Navegar := False;
                if MDPdv.Locate('ID', VL_ID, []) then
                    MDPdv.Delete;
            end;
        end;
        CarregaCampos;
        ShowMessage('Registro Excluido com sucesso');
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;
end;

procedure Tfprincipal.TabPdvBGeraChaveClick(Sender: TObject);
var
    VL_Mensagem: TMensagem;
    VL_Chave: string;
    VL_Tag: ansistring;
    VL_Codigo: integer;
    VL_Retorno: ansistring;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Tag := '';
    VL_Codigo := 0;
    VL_Chave := '';
    try
        CriarChaveTerminal(VL_Chave);
        if Length(VL_Chave) = 0 then
        begin
            ShowMessage('Erro ao gerar chave');
            exit;
        end;
        VL_Mensagem.Limpar;
        VL_Mensagem.AddComando('0045', '');
        VL_Mensagem.AddTag('003B', VL_Chave);
        VL_Mensagem.TagToStr(VL_Tag);
        VL_Codigo := SolicitacaoBloc(VL_Tag, VL_Tag, C_TempoSolicitacao);
        if VL_Codigo <> 0 then
        begin
            ShowMessage('Erro:' + IntToStr(VL_Codigo));
            Exit;
        end;
        VL_Mensagem.Limpar;
        VL_Mensagem.CarregaTags(VL_Tag);
        VL_Mensagem.GetComando(VL_Retorno, VL_Tag);
        case VL_Retorno of
            '0026':
            begin
                VL_Mensagem.GetTag('0026', VL_Tag);
                ShowMessage('ERRO:' + VL_Tag);
                Exit;
            end;
            '004D':
            begin
                if VL_TAG <> '0' then
                begin
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    ShowMessage('ERRO:' + VL_Tag);
                    Exit;
                end;
                TabPdvEChave.Text := VL_Chave;
            end;
        end;
    finally
        VL_Mensagem.Free;
    end;

end;

procedure Tfprincipal.TabPdvBModificarClick(Sender: TObject);
var
    VL_Status: integer;
begin
    VL_Status := 0;
    F_OpenTefStatus(VL_Status);
    if VL_Status <> Ord(csLogado) then
    begin
        ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
        Desconectar;
        Exit;
    end;
    if MDPdv.Active = False then
    begin
        ShowMessage('MDPdv não está ativo');
        Exit;
    end;
    if TabPdvEDescricao.Text = '' then
    begin
        ShowMessage('Descrição é um campo obrigatório');
        exit;
    end;
    if TabPdvCLoja.Text = '' then
    begin
        ShowMessage('Voce deve selecionar uma loja para incluir o Pdv, campo obrigatório');
        exit;
    end;
    if GravaRegistros('TabPdv', False) then
        AlterarRegistro('008E', MDPdv, '0043', StrToInt(TabPdvEID.Text), '004B', 'S');

end;

procedure Tfprincipal.TabPdvEFiltroChange(Sender: TObject);
var
    VL_Filtro: string;
begin
    if F_Permissao = False then
        EXIT;
    VL_Filtro := '';
    MDPdv.Filter := FiltrarTabela(TabPdvGrid, VL_Filtro, TabPdvEFiltro);
    TabPdvLFiltro.Caption := VL_Filtro;
    MDPdv.Filtered := True;
end;

procedure Tfprincipal.TabPDVFuncaoCKSelecionadaChange(Sender: TObject);
begin
    if TabPDVFuncaoCKSelecionada.Checked then
    begin
        MDPdvFuncao.Filter := 'VALIDADO=''T''';
        MDPdvFuncao.Filtered := True;
    end
    else
    begin
        MDPdvFuncao.Filter := '';
        MDPdvFuncao.Filtered := False;
    end;
end;

procedure Tfprincipal.TabPDVFuncaoEFiltroChange(Sender: TObject);
var
    VL_Filtro: string;
begin
    if F_Permissao = False then
        EXIT;
    VL_Filtro := '';
    MDPdvFuncao.Filter := FiltrarTabela(TabPDVFuncaoGrid, VL_Filtro, TabPdvFuncaoEFiltro);
    TabPDVFuncaoLFiltro.Caption := VL_Filtro;
    MDPdvFuncao.Filtered := True;
end;

procedure Tfprincipal.TabPDVFuncaoGridCellClick(Column: TColumn);
var
    VL_Status: integer;
    VL_Mensagem: TMensagem;
    VL_Codigo: integer;
    VL_ID: int64;
    VL_Retorno, VL_Tag: string;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    if TabPDVFuncaoGrid.SelectedColumn.FieldName <> 'VALIDADO_F' then
        TabPDVFuncaoLFiltro.Caption := 'Filtrar por ' + TabPDVFuncaoGrid.SelectedColumn.Title.Caption;
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            Desconectar;
            Exit;
        end;
        if ((MDPdv.Active = False) or (MDPdv.RecordCount < 1)) then
            exit;
        if ((MDPdvFuncao.Active = False) or (MDPdvFuncao.RecordCount < 1)) then
            exit;
        F_Navegar := False;
        if ((TabPDVFuncaoGrid.SelectedColumn.FieldName = 'VALIDADO_F') or
            (TabPDVFuncaoGrid.SelectedColumn.FieldName = 'HABILITADO_F')) then
        begin
            VL_ID := MDPdvFuncaoID.AsInteger;
            if (TabPDVFuncaoGrid.SelectedColumn.FieldName = 'VALIDADO_F') then
            begin
                MDPdvFuncao.Edit;
                MDPdvFuncao.FieldByName('VALIDADO').AsBoolean := not MDPdvFuncao.FieldByName('VALIDADO').AsBoolean;
                MDPdvFuncao.Post;
            end;
            if (TabPDVFuncaoGrid.SelectedColumn.FieldName = 'HABILITADO_F') then
            begin
                MDPdvFuncao.Edit;
                MDPdvFuncao.FieldByName('HABILITADO').AsBoolean := not MDPdvFuncao.FieldByName('HABILITADO').AsBoolean;
                MDPdvFuncao.Post;
            end;
            if ((MDPdvFuncao.FieldByName('VALIDADO').AsBoolean = True) and (VL_ID < 1)) then
            begin
                MDPdvFuncao.Edit;
                MDPdvFuncao.FieldByName('PDV_ID').AsString := MDPdv.FieldByName('ID').AsString;
                MDPdvFuncao.FieldByName('ID').AsInteger := 0;
                MDPdvFuncao.Post;
                //incluir PDV função
                VL_Codigo := IncluirRegistro(MDPdvFuncao, '00C2', 'S', '00C1', VL_Tag);
                if VL_Codigo <> 0 then
                begin
                    ShowMessage(IntToStr(VL_Codigo));
                    exit;
                end;

                VL_Mensagem.Limpar;
                VL_Mensagem.CarregaTags(VL_Tag);
                VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

                case VL_Retorno of
                    '0026':
                    begin
                        VL_Mensagem.GetTag('0026', VL_Tag);
                        ShowMessage('ERRO:' + VL_Tag);
                        if MDLojaFuncao.Locate('ID', 0, []) then
                            MDLojaFuncao.Delete;
                        Exit;
                    end;
                    '00C2':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                            Exit;
                        end;
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        if vl_tag <> '0' then
                        begin
                            ShowMessage('ERRO:' + VL_Tag);
                            if MDLojaFuncao.Locate('ID', 0, []) then
                                MDLojaFuncao.Delete;
                            Exit;
                        end;
                        VL_Mensagem.GetTag('00C3', VL_ID); //RETORNO DO ID DO PDV_FUNCAO
                        F_Navegar := False;
                        if MDPdvFuncao.Locate('ID', 0, []) then
                        begin
                            MDPdvFuncao.Edit;
                            MDPdvFuncao.FieldByName('ID').AsInteger := VL_ID;
                            MDPdvFuncao.Post;
                        end;
                    end;
                end;
            end
            else
            if ((MDPdvFuncao.FieldByName('VALIDADO').AsBoolean = True) and (VL_ID > 0)) then
            begin
                //ALTERA PDV_FUNCAO
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00C4', 'S');
                VL_Mensagem.AddTag('00C3', VL_ID);
                VL_Mensagem.AddTag('00C0', MDPdvFuncao.FieldByName('HABILITADO').AsString);
                VL_Mensagem.TagToStr(VL_Tag);
                VL_Codigo := SolicitacaoBloc(VL_Tag, VL_Tag, C_TempoSolicitacao);
                if VL_Codigo <> 0 then
                begin
                    ShowMessage(IntToStr(VL_Codigo));
                    exit;
                end;
                VL_Mensagem.Limpar;
                VL_Mensagem.CarregaTags(VL_Tag);
                VL_Mensagem.GetComando(VL_Retorno, VL_Tag);
                case VL_Retorno of
                    '0026':
                    begin
                        VL_Mensagem.GetTag('0026', VL_Tag);
                        ShowMessage('ERRO:' + VL_Tag);
                        if MDLojaFuncao.Locate('ID', 0, []) then
                            MDLojaFuncao.Delete;
                        Exit;
                    end;
                    '00C4':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                            Exit;
                        end;
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        if vl_tag <> '0' then
                        begin
                            ShowMessage('ERRO:' + VL_Tag);
                            Exit;
                        end;
                    end;
                end;
            end
            else
            begin
                //alterar PDV função
                VL_Codigo := ExcluirRegistro('00C3', VL_ID, '00C5', 'S', VL_Tag);

                if VL_Codigo <> 0 then
                begin
                    ShowMessage(IntToStr(VL_Codigo));
                    exit;
                end;
                VL_Mensagem.Limpar;
                VL_Mensagem.CarregaTags(VL_Tag);
                VL_Mensagem.GetComando(VL_Retorno, VL_Tag);
                case VL_Retorno of
                    '0026':
                    begin
                        VL_Mensagem.GetTag('0026', VL_Tag);
                        ShowMessage('ERRO:' + VL_Tag);
                        if MDLojaFuncao.Locate('ID', 0, []) then
                            MDLojaFuncao.Delete;
                        Exit;
                    end;
                    '00C5':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                            Exit;
                        end;
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        if vl_tag <> '0' then
                        begin
                            ShowMessage('ERRO:' + VL_Tag);
                            Exit;
                        end;
                    end;
                end;
                MDPdvFuncao.Edit;
                MDPdvFuncao.FieldByName('ID').AsInteger := -1;
                MDPdvFuncao.Post;
            end;
        end;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;

end;

procedure Tfprincipal.TabPdvGridCellClick(Column: TColumn);
begin
    TabPdvLFiltro.Caption := 'Filtrar por ' + TabPdvGrid.SelectedColumn.Title.Caption;
end;

procedure Tfprincipal.TabPDVModuloBAdicionarClick(Sender: TObject);
var
    VL_Status: integer;
    VL_Mensagem: TMensagem;
    VL_Codigo: integer;
    VL_ID: int64;
    VL_Retorno, VL_Tag: string;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            Desconectar;
            Exit;
        end;
        if MDPdvModulo.Active = False then
        begin
            ShowMessage('MDPdvModulo não está ativo');
            Exit;
        end;
        if GravaRegistros('TabPdvModulo', True) then
        begin
            VL_Codigo := IncluirRegistro(MDPdvModulo, '00C8', 'S', '00C7', VL_Tag);

            if VL_Codigo <> 0 then
            begin
                ShowMessage(IntToStr(VL_Codigo));
                exit;
            end;

            VL_Mensagem.Limpar;
            VL_Mensagem.CarregaTags(VL_Tag);
            VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

            case VL_Retorno of
                '0026':
                begin
                    VL_Mensagem.GetTag('0026', VL_Tag);
                    ShowMessage('ERRO:' + VL_Tag);
                    if MDPdvModulo.Locate('ID', 0, []) then
                        MDPdvModulo.Delete;
                    Exit;
                end;
                '00C8':
                begin
                    if VL_Tag <> 'R' then
                    begin
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                        Exit;
                    end;

                    VL_Mensagem.GetTag('004D', VL_Tag);
                    if vl_tag <> '0' then
                    begin
                        ShowMessage('ERRO:' + VL_Tag);
                        if MDPdvModulo.Locate('ID', 0, []) then
                            MDPdvModulo.Delete;
                        Exit;
                    end;
                    VL_Mensagem.GetTag('00C9', VL_ID); //RETORNO DO ID DO PDV_MODULO
                    F_Navegar := False;
                    if MDPdvModulo.Locate('ID', 0, []) then
                    begin
                        MDPdvModulo.Edit;
                        MDPdvModulo.FieldByName('ID').AsInteger := VL_ID;
                        MDPdvModulo.Post;
                    end;
                end;
            end;
            CarregaCampos;
            ShowMessage('Registro incluido com sucesso');
        end;

    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;

end;

procedure Tfprincipal.TabPDVModuloBExcluirClick(Sender: TObject);
var
    VL_Status: integer;
    VL_Codigo: integer;
    VL_Mensagem: TMensagem;
    VL_Retorno, VL_Tag: string;
    VL_ID: int64;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            Desconectar;
            Exit;
        end;
        if MDPdvModulo.Active = False then
        begin
            ShowMessage('MDPdvModulo não está ativo');
            Exit;
        end;
        if length(TabPdvModuloEID.Text) = 0 then
        begin
            ShowMessage('Não existe registro selecionado para exclusão');
            Exit;
        end;

        VL_Codigo := ExcluirRegistro('00C9', StrToInt(TabPdvModuloEID.Text), '00CC', 'S', VL_Tag);
        if VL_Codigo <> 0 then
        begin
            ShowMessage(IntToStr(VL_Codigo));
            exit;
        end;
        VL_Mensagem.Limpar;
        VL_Mensagem.CarregaTags(VL_Tag);
        VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

        case VL_Retorno of
            '0026':
            begin
                VL_Mensagem.GetTag('0026', VL_ID);
                ShowMessage('ERRO:' + IntToStr(VL_ID));
                Exit;
            end;
            '00CC':
            begin
                if VL_Tag <> 'R' then
                begin
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                    Exit;
                end;
                VL_Mensagem.GetTag('004D', VL_Tag);
                if vl_tag <> '0' then
                begin
                    VL_Mensagem.GetTag('004D', VL_ID);
                    ShowMessage('ERRO:' + IntToStr(VL_ID));
                    Exit;
                end;
                VL_Mensagem.GetTag('00C9', VL_ID);
                F_Navegar := False;
                if MDPdvModulo.Locate('ID', VL_ID, []) then
                    MDPdvModulo.Delete;
            end;
        end;
        ShowMessage('Registro Excluido com sucesso');
        CarregaCampos;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;

end;

procedure Tfprincipal.TabPDVModuloBModificarClick(Sender: TObject);
var
    VL_Status: integer;
begin
    F_OpenTefStatus(VL_Status);
    if VL_Status <> Ord(csLogado) then
    begin
        ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
        Desconectar;
        Exit;
    end;
    if MDPdvModulo.Active = False then
    begin
        ShowMessage('MDPdvModulo não está ativo');
        Exit;
    end;

    if GravaRegistros('TabPdvModulo', False) then
        AlterarRegistro('00C7', MDPdvModulo, '00C9', StrToInt(TabPdvModuloEID.Text), '00CB', 'S');

end;

procedure Tfprincipal.TabPDVModuloBPesquisaModuloConfClick(Sender: TObject);
var
    VL_FPesquisaModulo: TFModuloConf;
begin
    if F_Permissao = False then
        exit;
    VL_FPesquisaModulo := TFModuloConf.Create(Self);
    VL_FPesquisaModulo.F_Tabela := RxMemDataToStr(MDPesquisaModulo);
    VL_FPesquisaModulo.ShowModal;
    if VL_FPesquisaModulo.F_Carregado then
    begin
        TabPdvModuloEModuloConfID.Text := VL_FPesquisaModulo.MDPesquisaModulo.FieldByName('MODULO_CONF_ID').AsString;
        TabPdvModuloEModuloConf.Text := VL_FPesquisaModulo.MDPesquisaModulo.FieldByName('MODULO_CONF_DESCRICAO').AsString;
    end;

    VL_FPesquisaModulo.Free;

end;

procedure Tfprincipal.TabPDVModuloBPesquisaTagClick(Sender: TObject);
var
    VL_FPesquisaTag: TFTags;
begin
    if F_Permissao = False then
        exit;
    VL_FPesquisaTag := TFTags.Create(Self);
    VL_FPesquisaTag.F_Tabela := RxMemDataToStr(MDTags);
    VL_FPesquisaTag.F_TagTipo := 'MENU';
    VL_FPesquisaTag.ShowModal;
    if VL_FPesquisaTag.F_Carregado then
    begin
        TabPDVModuloETagNumero.Text := VL_FPesquisaTag.MDTags.FieldByName('TAG_NUMERO').AsString;
        TabPDVModuloETag.Text := VL_FPesquisaTag.MDTags.FieldByName('DEFINICAO').AsString;
    end;
    VL_FPesquisaTag.Free;

end;

procedure Tfprincipal.TabPDVModuloEFiltroChange(Sender: TObject);
var
    VL_Filtro: string;
begin
    if F_Permissao = False then
        EXIT;
    VL_Filtro := '';
    MDPdvModulo.Filter := FiltrarTabela(TabPDVModuloGrid, VL_Filtro, TabPdvModuloEFiltro);
    TabPDVModuloLFiltro.Caption := VL_Filtro;
    MDPdvModulo.Filtered := True;
end;

procedure Tfprincipal.TabPdvShow(Sender: TObject);
begin
    TabPdvTabDadosModulo.OnShow(self);
end;

procedure Tfprincipal.TabPdvTabDadosFuncaoShow(Sender: TObject);
begin
    if ((F_Navegar) and (F_Permissao)) then
        //carrega pdv_funcao
        CarregarTabelas(False, '00C1', '0043', MDPdv.FieldByName('ID').AsInteger);
end;

procedure Tfprincipal.TabPdvTabDadosModuloShow(Sender: TObject);
begin
    if ((F_Permissao) and (F_Navegar)) then
        CarregarTabelas(False, '00C7', '0043', MDPdv.FieldByName('ID').AsInteger);
end;

procedure Tfprincipal.TabPinPadBAdicionarClick(Sender: TObject);
var
    VL_Status: integer;
    VL_Mensagem: TMensagem;
    VL_Codigo: integer;
    VL_ID: int64;
    VL_Retorno, VL_Tag: string;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            Desconectar;
            Exit;
        end;
        if MDPinPad.Active = False then
        begin
            ShowMessage('MDPinPad não está ativo');
            Exit;
        end;
        if GravaRegistros('TabPinPad', True) then
        begin
            vl_codigo := IncluirRegistro(MDPinPad, '0053', 'S', '008D', VL_Tag);

            if VL_Codigo <> 0 then
            begin
                ShowMessage(IntToStr(VL_Codigo));
                exit;
            end;

            VL_Mensagem.Limpar;
            VL_Mensagem.CarregaTags(VL_Tag);
            VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

            case VL_Retorno of
                '0026':
                begin
                    VL_Mensagem.GetTag('0026', VL_Tag);
                    ShowMessage('ERRO:' + VL_Tag);
                    if MDPinPad.Locate('ID', 0, []) then
                        MDPinPad.Delete;
                    Exit;
                end;
                '0053':
                begin
                    if VL_Tag <> 'R' then
                    begin
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                        Exit;
                    end;
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    if vl_tag <> '0' then
                    begin
                        ShowMessage('ERRO:' + VL_Tag);
                        if MDPinPad.Locate('ID', 0, []) then
                            MDPinPad.Delete;
                        Exit;
                    end;
                    VL_Mensagem.GetTag('0054', VL_ID); //RETORNO DO ID DO PINPAD
                    F_Navegar := False;
                    if MDPinPad.Locate('ID', 0, []) then
                    begin
                        MDPinPad.Edit;
                        MDPinPad.FieldByName('ID').AsInteger := VL_ID;
                        MDPinPad.Post;
                    end;
                end;
            end;
            CarregaCampos;
            ShowMessage('Registro incluido com sucesso');
        end;

    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;
end;

procedure Tfprincipal.TabPinPadBExcluirClick(Sender: TObject);
var
    VL_Status: integer;
    VL_Codigo: integer;
    VL_Mensagem: TMensagem;
    VL_Retorno, VL_Tag: string;
    VL_ID: int64;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            Desconectar;
            Exit;
        end;
        if MDPinPad.Active = False then
        begin
            ShowMessage('MDPinPad não está ativo');
            Exit;
        end;
        if length(TabPinPadEID.Text) = 0 then
        begin
            ShowMessage('Não existe registro selecionado para exclusão');
            Exit;
        end;

        VL_Codigo := ExcluirRegistro('0054', StrToInt(TabPinPadEID.Text), '006A', 'S', VL_Tag);

        if VL_Codigo <> 0 then
        begin
            ShowMessage(IntToStr(VL_Codigo));
            exit;
        end;
        VL_Mensagem.Limpar;
        VL_Mensagem.CarregaTags(VL_Tag);
        VL_Mensagem.GetComando(VL_Retorno, VL_Tag);
        case VL_Retorno of
            '0026':
            begin
                VL_Mensagem.GetTag('0026', VL_ID);
                ShowMessage('ERRO:' + IntToStr(VL_ID));
                Exit;
            end;
            '006A':
            begin
                if VL_Tag <> 'R' then
                begin
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                    Exit;
                end;
                VL_Mensagem.GetTag('004D', VL_Tag);
                if vl_tag <> '0' then
                begin
                    VL_Mensagem.GetTag('004D', VL_ID);
                    ShowMessage('ERRO:' + IntToStr(VL_ID));
                    Exit;
                end;
                VL_Mensagem.GetTag('0054', VL_ID);
                F_Navegar := False;
                if MDPinPad.Locate('ID', VL_ID, []) then
                    MDPinPad.Delete;
            end;
        end;
        ShowMessage('Registro Excluido com sucesso');
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;
end;

procedure Tfprincipal.TabPinPadBModificarClick(Sender: TObject);
var
    VL_Status: integer;
begin
    VL_Status := 0;
    F_OpenTefStatus(VL_Status);
    if VL_Status <> Ord(csLogado) then
    begin
        ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
        Desconectar;
        Exit;
    end;
    if MDPinPad.Active = False then
    begin
        ShowMessage('MDPinPad não está ativo');
        Exit;
    end;
    if TabPinPadMFabricante.Text = '' then
    begin
        ShowMessage('Modelo do PinPad é um campo obrigatório');
        exit;
    end;
    if GravaRegistros('TabPinPad', False) then
        AlterarRegistro('008D', MDPinPad, '0054', StrToInt(TabPinPadEID.Text), '0055', 'S');

end;

procedure Tfprincipal.TabPinPadEFiltroChange(Sender: TObject);
begin
    MDPinPad.Filter := 'FABRICANTE_MODELO=(''*' + TabPinPadEFiltro.Text + '*'')';
    MDPinPad.Filtered := True;
end;

procedure Tfprincipal.TabPinPadFuncaoCKSelecionadaChange(Sender: TObject);
begin
    if TabPinPadFuncaoCKSelecionada.Checked then
    begin
        MDPinPadFuncao.Filter := 'VALIDADO=''T''';
        MDPinPadFuncao.Filtered := True;
    end
    else
    begin
        MDPinPadFuncao.Filter := '';
        MDPinPadFuncao.Filtered := False;
    end;
end;

procedure Tfprincipal.TabPinPadFuncaoEFiltroChange(Sender: TObject);
var
    VL_Filtro: string;
begin
    if F_Permissao = False then
        EXIT;
    VL_Filtro := '';
    MDPinPadFuncao.Filter := FiltrarTabela(TabPinPadFuncaoGrid, VL_Filtro, TabPinPadFuncaoEFiltro);
    TabPinPadFuncaoLFiltro.Caption := VL_Filtro;
    MDPinPadFuncao.Filtered := True;
end;

procedure Tfprincipal.TabPinPadFuncaoGridCellClick(Column: TColumn);
var
    VL_Status: integer;
    VL_Mensagem: TMensagem;
    VL_Codigo: integer;
    VL_ID: int64;
    VL_Retorno, VL_Tag: string;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    if TabPinPadFuncaoGrid.SelectedColumn.FieldName <> 'VALIDADO_F' then
        TabPinPadFuncaoLFiltro.Caption := 'Filtrar por ' + TabPinPadFuncaoGrid.SelectedColumn.Title.Caption;
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            Desconectar;
            Exit;
        end;
        if ((MDPinPad.Active = False) or (MDPinPad.RecordCount < 1)) then
            exit;
        if ((MDPinPadFuncao.Active = False) or (MDPinPadFuncao.RecordCount < 1)) then
            exit;
        F_Navegar := False;
        if ((TabPinPadFuncaoGrid.SelectedColumn.FieldName = 'VALIDADO_F') or
            (TabPinPadFuncaoGrid.SelectedColumn.FieldName = 'HABILITADO_F')) then
        begin
            VL_ID := MDPinPadFuncaoID.AsInteger;
            if TabPinPadFuncaoGrid.SelectedColumn.FieldName = 'VALIDADO_F' then
            begin
                MDPinPadFuncao.Edit;
                MDPinPadFuncao.FieldByName('VALIDADO').AsBoolean := not MDPINPADFuncao.FieldByName('VALIDADO').AsBoolean;
                MDPinPadFuncao.Post;
            end;
            if TabPinPadFuncaoGrid.SelectedColumn.FieldName = 'HABILITADO_F' then
            begin
                MDPinPadFuncao.Edit;
                MDPinPadFuncao.FieldByName('HABILITADO').AsBoolean := not MDPINPADFuncao.FieldByName('HABILITADO').AsBoolean;
                MDPinPadFuncao.Post;
            end;
            if ((MDPINPADFuncao.FieldByName('VALIDADO').AsBoolean = True) and (VL_ID < 1)) then
            begin
                MDPinPadFuncao.Edit;
                MDPinPadFuncao.FieldByName('PINPAD_ID').AsString := MDPinPad.FieldByName('ID').AsString;
                MDPinPadFuncao.FieldByName('ID').AsInteger := 0;
                MDPinPadFuncao.Post;
                //incluir PINPAD função
                VL_Codigo := IncluirRegistro(MDPinPadFuncao, '00B5', 'S', '00B4', VL_Tag);
                if VL_Codigo <> 0 then
                begin
                    ShowMessage(IntToStr(VL_Codigo));
                    exit;
                end;

                VL_Mensagem.Limpar;
                VL_Mensagem.CarregaTags(VL_Tag);
                VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

                case VL_Retorno of
                    '0026':
                    begin
                        VL_Mensagem.GetTag('0026', VL_Tag);
                        ShowMessage('ERRO:' + VL_Tag);
                        if MDLojaFuncao.Locate('ID', 0, []) then
                            MDLojaFuncao.Delete;
                        Exit;
                    end;
                    '00B5':
                    begin

                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                            Exit;
                        end;

                        VL_Mensagem.GetTag('004D', VL_Tag);

                        if vl_tag <> '0' then
                        begin
                            ShowMessage('ERRO:' + VL_Tag);
                            if MDLojaFuncao.Locate('ID', 0, []) then
                                MDLojaFuncao.Delete;
                            Exit;
                        end;
                        VL_Mensagem.GetTag('00B7', VL_ID); //RETORNO DO ID DO PINPAD_FUNCAO_id
                        F_Navegar := False;
                        if MDPinPadFuncao.Locate('ID', 0, []) then
                        begin
                            MDPinPadFuncao.Edit;
                            MDPinPadFuncao.FieldByName('ID').AsInteger := VL_ID;
                            MDPinPadFuncao.Post;
                        end;
                    end;
                end;
            end
            else
            if ((MDPINPADFuncao.FieldByName('VALIDADO').AsBoolean = True) and (VL_ID > 0)) then
            begin
                //ALTERA PINPAD_FUNCAO
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00B6', 'S');
                VL_Mensagem.AddTag('00B7', VL_ID);
                VL_Mensagem.AddTag('00B3', MDPinPadFuncao.FieldByName('HABILITADO').AsString);
                VL_Mensagem.TagToStr(VL_Tag);
                VL_Codigo := SolicitacaoBloc(VL_Tag, VL_Tag, C_TempoSolicitacao);
                if VL_Codigo <> 0 then
                begin
                    ShowMessage(IntToStr(VL_Codigo));
                    exit;
                end;

                VL_Mensagem.Limpar;
                VL_Mensagem.CarregaTags(VL_Tag);
                VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

                case VL_Retorno of
                    '0026':
                    begin
                        VL_Mensagem.GetTag('0026', VL_Tag);
                        ShowMessage('ERRO:' + VL_Tag);
                        if MDLojaFuncao.Locate('ID', 0, []) then
                            MDLojaFuncao.Delete;
                        Exit;
                    end;
                    '00B6':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                            Exit;
                        end;

                        VL_Mensagem.GetTag('004D', VL_Tag);

                        if vl_tag <> '0' then
                        begin
                            ShowMessage('ERRO:' + VL_Tag);
                            Exit;
                        end;
                    end;
                end;
            end
            else
            begin
                //alterar PINPAD função
                VL_Codigo := ExcluirRegistro('00B7', VL_ID, '00B8', 'S', VL_Tag);

                if VL_Codigo <> 0 then
                begin
                    ShowMessage(IntToStr(VL_Codigo));
                    exit;
                end;
                VL_Mensagem.Limpar;
                VL_Mensagem.CarregaTags(VL_Tag);
                VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

                case VL_Retorno of
                    '0026':
                    begin
                        VL_Mensagem.GetTag('0026', VL_Tag);
                        ShowMessage('ERRO:' + VL_Tag);
                        if MDLojaFuncao.Locate('ID', 0, []) then
                            MDLojaFuncao.Delete;
                        Exit;
                    end;
                    '00B8':
                    begin
                        if VL_Tag <> 'R' then
                        begin
                            VL_Mensagem.GetTag('004D', VL_Tag);
                            ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                            Exit;
                        end;

                        VL_Mensagem.GetTag('004D', VL_Tag);

                        if vl_tag <> '0' then
                        begin
                            ShowMessage('ERRO:' + VL_Tag);
                            Exit;
                        end;
                    end;
                end;
                MDPinPadFuncao.Edit;
                MDPinPadFuncao.FieldByName('ID').AsInteger := -1;
                MDPinPadFuncao.Post;
            end;
        end;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;

end;

procedure Tfprincipal.TabPinPadShow(Sender: TObject);
begin
    TabPinPadTabDadosFuncao.OnShow(self);
end;

procedure Tfprincipal.TabPinPadTabDadosFuncaoShow(Sender: TObject);
begin
    if ((F_Navegar) and (F_Permissao)) then
        //carrega pinpad_funcao
        CarregarTabelas(False, '00B4', '0054', MDPinPad.FieldByName('ID').AsInteger);

end;

procedure Tfprincipal.TabTagBAdicionarClick(Sender: TObject);
var
    VL_Status: integer;
    VL_Mensagem: TMensagem;
    VL_Codigo: integer;
    VL_ID: int64;
    VL_Retorno, VL_Tag: string;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            Desconectar;
            Exit;
        end;
        if MDTags.Active = False then
        begin
            ShowMessage('MDTags não está ativo');
            Exit;
        end;

        if GravaRegistros('TabTag', True) then
        begin
            VL_Codigo := IncluirRegistro(MDTags, '0052', 'S', '0081', VL_Tag);
            if VL_Codigo <> 0 then
            begin
                ShowMessage(IntToStr(VL_Codigo));
                exit;
            end;

            VL_Mensagem.Limpar;
            VL_Mensagem.CarregaTags(VL_Tag);
            VL_Mensagem.GetComando(VL_Retorno, VL_Tag);

            case VL_Retorno of
                '0026':
                begin
                    VL_Mensagem.GetTag('0026', VL_Tag);
                    ShowMessage('ERRO:' + VL_Tag);
                    if MDTags.Locate('ID', 0, []) then
                        MDTags.Delete;
                    Exit;
                end;
                '0052':
                begin
                    if VL_Tag <> 'R' then
                    begin
                        VL_Mensagem.GetTag('004D', VL_Tag);
                        ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                        Exit;
                    end;
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    if vl_tag <> '0' then
                    begin
                        ShowMessage('ERRO:' + VL_Tag);
                        if MDTags.Locate('ID', 0, []) then
                            MDTags.Delete;
                        Exit;
                    end;
                    VL_Mensagem.GetTag('006E', VL_ID); //RETORNO DO ID DA TAG
                    F_Navegar := False;
                    if MDTags.Locate('ID', 0, []) then
                    begin
                        MDTags.Edit;
                        MDTags.FieldByName('ID').AsInteger := VL_ID;
                        MDTags.Post;
                    end;
                end;
            end;
            CarregaCampos;
            ShowMessage('Registro incluido com sucesso');
        end;
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;
end;

procedure Tfprincipal.TabTagBExcluirClick(Sender: TObject);
var
    VL_Status: integer;
    VL_Codigo: integer;
    VL_Mensagem: TMensagem;
    VL_Retorno, VL_Tag: string;
    VL_ID: int64;
begin
    VL_Mensagem := TMensagem.Create;
    VL_Codigo := 0;
    VL_ID := 0;
    VL_Retorno := '';
    VL_Tag := '';
    try
        F_OpenTefStatus(VL_Status);
        if VL_Status <> Ord(csLogado) then
        begin
            ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
            Desconectar;
            Exit;
        end;
        if MDTags.Active = False then
        begin
            ShowMessage('MDTag não está ativo');
            Exit;
        end;
        if length(TabTagEID.Text) = 0 then
        begin
            ShowMessage('Não existe registro selecionado para exclusão');
            Exit;
        end;

        VL_Codigo := ExcluirRegistro('006E', StrToInt(TabTagEID.Text), '00DC', 'S', VL_Tag);

        if VL_Codigo <> 0 then
        begin
            ShowMessage(IntToStr(VL_Codigo));
            exit;
        end;
        VL_Mensagem.Limpar;
        VL_Mensagem.CarregaTags(VL_Tag);
        VL_Mensagem.GetComando(VL_Retorno, VL_Tag);
        case VL_Retorno of
            '0026':
            begin
                VL_Mensagem.GetTag('0026', VL_ID);
                ShowMessage('ERRO:' + IntToStr(VL_ID));
                Exit;
            end;
            '00DC':
            begin
                if VL_Tag <> 'R' then
                begin
                    VL_Mensagem.GetTag('004D', VL_Tag);
                    ShowMessage('ERRO: O Comando não é um retorno erro numero:' + VL_Tag);
                    Exit;
                end;
                VL_Mensagem.GetTag('004D', VL_Tag);
                if vl_tag <> '0' then
                begin
                    VL_Mensagem.GetTag('004D', VL_ID);
                    ShowMessage('ERRO:' + IntToStr(VL_ID));
                    Exit;
                end;
                VL_Mensagem.GetTag('006E', VL_ID);
                F_Navegar := False;
                if MDTags.Locate('ID', VL_ID, []) then
                    MDTags.Delete;
            end;
        end;
        CarregaCampos;
        ShowMessage('Registro Excluido com sucesso');
    finally
        VL_Mensagem.Free;
        F_Navegar := True;
    end;
end;

procedure Tfprincipal.TabTagBModificarClick(Sender: TObject);
var
    VL_Status: integer;
begin
    VL_Status := 0;
    F_OpenTefStatus(VL_Status);
    if VL_Status <> Ord(csLogado) then
    begin
        ShowMessage('Voce não esta logado com o terminal, efetue o login para continuar');
        Desconectar;
        Exit;
    end;
    if MDTags.Active = False then
    begin
        ShowMessage('MDTags não está ativo');
        Exit;
    end;

    if GravaRegistros('TabTag', False) then
        AlterarRegistro('0081', MDTags, '006E', StrToInt(TabTagEID.Text), '00DB', 'S');

end;

procedure Tfprincipal.TabTagEFiltroChange(Sender: TObject);
var
    VL_Filtro: string;
begin
    VL_Filtro := '';

    MDTags.Filter := FiltrarTabela(TabTagGrid, VL_Filtro, TabTagEFiltro);
    TabTagLFiltro.Caption := VL_Filtro;
    MDTags.Filtered := True;

end;

procedure Tfprincipal.TabTagGridCellClick(Column: TColumn);
begin
    TabTagLFiltro.Caption := 'Filtrar por ' + TabTagGrid.SelectedColumn.Title.Caption;
end;

end.
