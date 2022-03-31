unit pinpad;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type

  { TDPinPad }

  TDPinPad = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
  private

  public

  end;

var
  DPinPad: TDPinPad;
  FPinPadLib      : THandle;

function CarregaLibPinPad(): boolean;

implementation

{$R *.lfm}


function CarregaLibPinPad(): boolean;
begin

  FPinPadLib := LoadLibrary(pChar(ExtractFilePath(ParamStr(0))+'gpinpad3.dll');

//
//  if LibHandle <= HINSTANCE_ERROR then
//    exit(false);
//
//  // Carregando as funções
//  pcl_exception_set_uncaught_handler := GetProcAddress(LibHandle, 'pcl_exception_set_uncaught_handler');
//  abecs_comm_open                    := GetProcAddress(LibHandle, 'abecs_comm_open');
//  abecs_cmd_opn                      := GetProcAddress(LibHandle, 'abecs_cmd_opn');
//  abecs_cmd_dsp                      := GetProcAddress(LibHandle, 'abecs_cmd_dsp');
//  abecs_cmd_clo                      := GetProcAddress(LibHandle, 'abecs_cmd_clo');
//  abecs_comm_close                   := GetProcAddress(LibHandle, 'abecs_comm_close');
//  // Gertec - Manipulação de mapas e leitura de resposta de CEX
//  abecs_rsp_param_map_new   := GetProcAddress(LibHandle, 'abecs_rsp_param_map_new');
//  abecs_rsp_param_map_begin := GetProcAddress(LibHandle, 'abecs_rsp_param_map_begin');
//  abecs_rsp_param_map_get   := GetProcAddress(LibHandle, 'abecs_rsp_param_map_get');
//  abecs_rsp_param_map_next  := GetProcAddress(LibHandle, 'abecs_rsp_param_map_next');
//
//  abecs_cmd_gcx_builder_new     := GetProcAddress(LibHandle, 'abecs_cmd_gcx_builder_new');
//  abecs_cmd_gcx_builder_delete  := GetProcAddress(LibHandle, 'abecs_cmd_gcx_builder_delete');
//  abecs_cmd_gcx_builder_gcxopt  := GetProcAddress(LibHandle, 'abecs_cmd_gcx_builder_gcxopt');
//  abecs_cmd_gcx_builder_aidlist := GetProcAddress(LibHandle, 'abecs_cmd_gcx_builder_aidlist');
//  abecs_cmd_gcx_builder_amount  := GetProcAddress(LibHandle, 'abecs_cmd_gcx_builder_amount');
//  abecs_cmd_gcx_builder_taglist := GetProcAddress(LibHandle, 'abecs_cmd_gcx_builder_taglist');
//  pcl_map_delete                := GetProcAddress(LibHandle, 'pcl_map_delete');
//  abecs_cmd_cex_response        := GetProcAddress(LibHandle, 'abecs_cmd_cex_response');
//  abecs_cmd_gcx_response        := GetProcAddress(LibHandle, 'abecs_cmd_gcx_response');
//  abecs_cmd_gox_response        := GetProcAddress(LibHandle, 'abecs_cmd_gox_response');
//  abecs_cmd_fcx_response        := GetProcAddress(LibHandle, 'abecs_cmd_fcx_response');
//  abecs_cmd_gpn_response        := GetProcAddress(LibHandle, 'abecs_cmd_gpn_response');
//  // michel
//  abecs_cmd_cex                      := GetProcAddress(LibHandle, 'abecs_cmd_cex');
//  abecs_cmd_gcx                      := GetProcAddress(LibHandle, 'abecs_cmd_gcx');
//  abecs_cmd_gox                      := GetProcAddress(LibHandle, 'abecs_cmd_gox');
//  abecs_cmd_fcx                      := GetProcAddress(LibHandle, 'abecs_cmd_fcx');
//  abecs_cmd_gpn                      := GetProcAddress(LibHandle, 'abecs_cmd_gpn');
//  abecs_cmd_cex_response_get_trk2inc := GetProcAddress(LibHandle, 'abecs_cmd_cex_response_get_trk2inc');
//  abecs_cmd_cex_response_get_event   := GetProcAddress(LibHandle, 'abecs_cmd_cex_response_get_event');
//  abecs_cmd_tli                      := GetProcAddress(LibHandle, 'abecs_cmd_tli');
//  abecs_cmd_tlr                      := GetProcAddress(LibHandle, 'abecs_cmd_tlr');
//  abecs_cmd_tle                      := GetProcAddress(LibHandle, 'abecs_cmd_tle');
//
//  abecs_cmd_gox_builder_new    := GetProcAddress(LibHandle, 'abecs_cmd_gox_builder_new');
//  abecs_cmd_gox_builder_delete := GetProcAddress(LibHandle, 'abecs_cmd_gox_builder_delete');
//
//  abecs_cmd_fcx_builder_new    := GetProcAddress(LibHandle, 'abecs_cmd_fcx_builder_new');
//  abecs_cmd_fcx_builder_delete := GetProcAddress(LibHandle, 'abecs_cmd_fcx_builder_delete');
//  abecs_cmd_fcx_builder_arc    := GetProcAddress(LibHandle, 'abecs_cmd_fcx_builder_arc');
//
  result := true;
end;

{ TDPinPad }

procedure TDPinPad.DataModuleCreate(Sender: TObject);
begin
  CarregaLibPinPad();
end;


end.

