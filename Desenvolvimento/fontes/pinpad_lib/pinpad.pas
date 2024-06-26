unit pinpad;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils, funcoes;

type


    { TTPinPad }

    TTPinPad = class(TThread)
        fMensagem: TMensagem;
        FProcessoID: integer;
        fRespostaPinPad: TRespostaPinPad;
        fPinPad:Pointer;
    protected
        procedure Execute; override;
    public
        constructor Create(VP_PinPad:Pointer; VP_Processo_ID: integer; VP_CreateSuspended: boolean; VP_Mensagem: TMensagem; var VO_TRespostaPinPad: TRespostaPinPad);

    end;

    { TPinPad }
    TPinPad = class
    private
        fRespostaPinPad: TRespostaPinPad;
        F_ArquivoLog: string;
    public
        F_PinPadComOpen: boolean;
        F_PinPadConectado: boolean;
        F_PinPaExecutando: boolean;
        function CarregaLib(): integer; virtual; abstract;
        function DescarregaLib(): integer; virtual; abstract;
        procedure SetConfig(VP_PinPad: TPinPadModelo; VP_CaminhoLib: ansistring; VP_Porta: ansistring); virtual; abstract;
        procedure PinPadErro(errCode: int16; msg: pansichar);
        function PinPadConecta(VO_Mensagem: TMensagem): integer; virtual; abstract;
        function PinPadDesconectar(VL_Mensagem: string): integer; virtual; abstract;
        function PinPadMensagem(VP_Mensagem: string): integer; virtual; abstract;
        function PinPadImagem(VP_Mensagem: string): integer; virtual; abstract;
        function PinPadLerTarja(var VO_Tarja1, VO_Tarja2, VO_Tarja3: string; VP_TempoEspera: integer; var VO_Mensagem: TMensagem): integer; virtual; abstract;
        function PinPadLerSenha(var VO_Senha: string; VP_KW_Index: integer; VP_KW, VP_Pan: string; VP_DigMin, VP_DigMax: integer;
            VP_Mensagem: string; var VO_Mensagem: TMensagem; VP_TempoEspera: integer): integer; virtual; abstract;
    end;


    { TDPinPad }

    TDPinPad = class(TDataModule)

    private

    public

    end;

var
    D_PinPad: TDPinPad;



function PinPadCarrega(var VO_PinPad:Pointer; VP_PinPadModelo: TPinPadModelo; VP_PinPadModeloLib, VP_PinPadModeloPorta: PChar; VP_RespostaPinPad: TRespostaPinPad; VP_ArquivoLog: PChar): integer; cdecl;
function PinPadDescarrega(var VO_PinPad:Pointer): integer; cdecl;
function PinPadConectar(VP_PinPad:Pointer;var VO_Mensagem: PChar): integer; cdecl;
function PinPadDesconectar(VP_PinPad:Pointer;VL_Mensagem: PChar): integer; cdecl;
function PinPadMensagem(VP_PinPad:Pointer;VL_Mensagem: PChar): integer; cdecl;
function PinPadImagem(VP_PinPad:Pointer;VL_Mensagem: PChar): integer; cdecl;
function PinPadComando(VP_PinPad:Pointer;VP_Processo_ID: integer; VP_Mensagem: PChar; var VO_Mensagem: PChar; VP_RespostaPinPad: TRespostaPinPad): integer; cdecl;
function PinPadExecutaComando(VP_PinPad:Pointer;VP_Mensagem: TMensagem; var VO_Mensagem: TMensagem): integer;


implementation

{$R *.lfm}

uses
    gertec_ppc930,ingenico_lane3000;

{ TPinPad }



function PinPadCarrega(var VO_PinPad:Pointer;VP_PinPadModelo: TPinPadModelo; VP_PinPadModeloLib, VP_PinPadModeloPorta: PChar; VP_RespostaPinPad: TRespostaPinPad; VP_ArquivoLog: PChar): integer; cdecl;
begin
    Result := 0;
    if VO_PinPad<>nil then
    begin
       Exit;
    end;
    Result := 77;
    if VP_PinPadModelo = pGERTEC_PPC930 then
    begin
        VO_PinPad := TGertec_ppc930.Create;
        TPinPad(VO_PinPad).SetConfig(VP_PinPadModelo, VP_PinPadModeloLib, VP_PinPadModeloPorta);
        TPinPad(VO_PinPad).fRespostaPinPad := VP_RespostaPinPad;
        Result := TPinPad(VO_PinPad).CarregaLib();
        TPinPad(VO_PinPad).F_PinPaExecutando := False;
        TPinPad(VO_PinPad).F_ArquivoLog := VP_ArquivoLog;

    end;
    if VP_PinPadModelo = pINGENICO_LANE3000 then
    begin
        VO_PinPad := TGertec_ppc930.Create;
        TPinPad(VO_PinPad).SetConfig(VP_PinPadModelo, VP_PinPadModeloLib, VP_PinPadModeloPorta);
        TPinPad(VO_PinPad).fRespostaPinPad := VP_RespostaPinPad;
        Result := TPinPad(VO_PinPad).CarregaLib();
        TPinPad(VO_PinPad).F_PinPaExecutando := False;
        TPinPad(VO_PinPad).F_ArquivoLog := VP_ArquivoLog;
    end;

end;

function PinPadDescarrega(var VO_PinPad:Pointer): integer; cdecl;
begin
    if VO_PinPad=nil then
       exit;
    TPinPad(VO_PinPad).PinPadDesconectar('Open Tef');
    Result := TPinPad(VO_PinPad).DescarregaLib();
    TPinPad(VO_PinPad).Free;
    VO_PinPad:=nil;
end;

function PinPadConectar(VP_PinPad:Pointer;var VO_Mensagem: PChar): integer; cdecl;
var
    VL_Mensgem: TMensagem;
begin
    if VP_PinPad=nil then
       exit;
    try
        VL_Mensgem := TMensagem.Create;
        Result := TPinPad(VP_PinPad).PinPadConecta(VL_Mensgem);
        VO_Mensagem := StrAlloc(Length(VL_Mensgem.TagsAsString) + 1);
        StrPCopy(VO_Mensagem, VL_Mensgem.TagsAsString);
        TPinPad(VP_PinPad).F_PinPaExecutando := False;

    finally
        VL_Mensgem.Free;
    end;
end;

function PinPadDesconectar(VP_PinPad:Pointer;VL_Mensagem: PChar): integer; cdecl;
begin
    if VP_PinPad=nil then
       exit;

    Result := TPinPad(VP_PinPad).PinPadDesconectar(VL_Mensagem);
end;

function PinPadMensagem(VP_PinPad:Pointer;VL_Mensagem: PChar): integer; cdecl;
begin
   if VP_PinPad=nil then
       exit;

    Result := TPinPad(VP_PinPad).PinPadMensagem(VL_Mensagem);
end;

function PinPadImagem(VP_PinPad:Pointer;VL_Mensagem: PChar): integer; cdecl;
begin
   if VP_PinPad=nil then
      exit;
   Result := TPinPad(VP_PinPad).PinPadImagem(VL_Mensagem);
end;

function PinPadComando(VP_PinPad:Pointer;VP_Processo_ID: integer; VP_Mensagem: PChar; var VO_Mensagem: PChar; VP_RespostaPinPad: TRespostaPinPad): integer; cdecl;
var
    VL_Mensagem: TMensagem;
    VL_Dados, VL_Comando: string;
    VL_TPinPad: TTPinPad;
    VL_MensagemO: TMensagem;
    VL_Linha: string;
begin
if VP_PinPad=nil then
   exit;

   try
        try
            VL_Linha := '041220231443';
            VL_Mensagem := TMensagem.Create;
            VL_MensagemO := TMensagem.Create;
            VL_Mensagem.CarregaTags(VP_Mensagem);
            VL_Comando := '';
            VL_Dados := '';
            Result := 0;
            VL_Mensagem.GetComando(VL_Comando, VL_Dados);
            case VL_Comando of
                '0047':                 // MOSTRA MENSAGEM TEXTO
                begin
                    VL_Linha := '041220231444';
                    Result := TPinPad(VP_PinPad).PinPadMensagem(VL_Dados);
                end;
                '00FC':                 // MOSTRA IMAGEM
                begin
                    VL_Linha := '041220231445';
                    Result := TPinPad(VP_PinPad).PinPadImagem(VL_Mensagem.GetTagAsAstring('00FE'));
                end;
                '0048': // PINPAD SOLICITA TARJA CARTAO
                begin
                    VL_Linha := '041220231446';
                    if VP_Processo_ID = -1 then
                    begin
                        Result := PinPadExecutaComando(VP_PinPad,VL_Mensagem, VL_MensagemO);
                        VO_Mensagem := StrAlloc(Length(VL_MensagemO.TagsAsString) + 1);
                        StrPCopy(VO_Mensagem, VL_MensagemO.TagsAsString);
                    end
                    else
                    begin
                        VL_TPinPad := TTPinPad.Create(VP_PinPad, VP_Processo_ID, True, VL_Mensagem, VP_RespostaPinPad);
                        VL_TPinPad.Start;
                    end;
                end;
                '005A':  // captura da senha
                begin
                    if VP_Processo_ID = -1 then
                    begin
                        VL_Linha := '041220231448';
                        Result := PinPadExecutaComando(VP_PinPad, VL_Mensagem, VL_MensagemO);
                        VO_Mensagem := StrAlloc(Length(VL_MensagemO.TagsAsString) + 1);
                        StrPCopy(VO_Mensagem, VL_MensagemO.TagsAsString);
                        VL_Linha := '041220231449';
                    end
                    else
                    begin
                        VL_Linha := '041220231450';
                        VL_TPinPad := TTPinPad.Create(VP_PinPad,VP_Processo_ID, True, VL_Mensagem, VP_RespostaPinPad);
                        VL_TPinPad.Start;
                        VL_Linha := '041220231451';
                    end;
                end
                else
                begin
                    VL_MensagemO.AddComando('0026', 'R');
                    VL_MensagemO.AddTag('004D', 78);
                    VO_Mensagem := StrAlloc(Length(VL_MensagemO.TagsAsString) + 1);
                    StrPCopy(VO_Mensagem, VL_MensagemO.TagsAsString);
                end;
            end;

        except
            on e: Exception do
            begin
                Result := 124;
                GravaLog(TPinPad(VP_PinPad).F_ArquivoLog, 0, '', 'pinpad_lib', VL_Linha, 'Erro de excecao na PinPadComando ' + e.ClassName +
                    '/' + e.Message, VP_Mensagem, 124, 1);
            end;
        end;
    finally
        VL_Mensagem.Free;
        VL_MensagemO.Free;
    end;
end;


function PinPadExecutaComando(VP_PinPad:Pointer;VP_Mensagem: TMensagem; var VO_Mensagem: TMensagem): integer;
var
    VL_Comando, VL_Dados: string;
    VL_Tk1, VL_Tk2, VL_Tk3: string;
    VL_Linha: string;
begin
    if VP_PinPad=nil then
       exit;
    Result := 0;
    VL_Linha := '041220231508';
    try
        VL_Dados := '';
        VL_Comando := '';
        VL_Tk1 := '';
        VL_Tk2 := '';
        VL_Tk3 := '';
        VP_Mensagem.GetComando(VL_Comando, VL_Dados);
        VO_Mensagem.Limpar;
        if VL_Comando = '0048' then     //ler tarja magnetica
        begin
            VO_Mensagem.AddComando('0048', 'R');
            while True do
            begin
                if VL_Dados = 'S' then
                begin
                    TPinPad(VP_PinPad).PinPadMensagem(' Passe o cartao');
                    Result := TPinPad(VP_PinPad).PinPadLerTarja(VL_Tk1, VL_Tk2, VL_Tk3, VP_Mensagem.GetTagAsInteger('0051'), VO_Mensagem);
                    if Result <> 0 then
                    begin
                        VO_Mensagem.AddTag('004D', Result);
                        TPinPad(VP_PinPad).PinPadMensagem('    Operacao       cancelada    ');
                        sleep(2000);
                        TPinPad(VP_PinPad).PinPadMensagem('    OpenTef    ');
                        Exit;
                    end;
                    VO_Mensagem.AddTag('004D', 0);
                    VO_Mensagem.AddTag('0046', Result);
                    VO_Mensagem.AddTag('004E', VL_Tk1);
                    VO_Mensagem.AddTag('004F', VL_Tk2);
                    VO_Mensagem.AddTag('0050', VL_Tk3);
                    Exit;
                end
                else
                begin
                    VO_Mensagem.AddComando('004D', '51');
                    Exit;
                end;
            end;
        end;
        if VL_Comando = '005A' then     //ler senha
        begin
            VL_Linha := '041220231509';
            VO_Mensagem.AddComando('005A', 'R');
            while True do
            begin
                VL_Linha := '041220231510';
                Result := TPinPad(VP_PinPad).PinPadLerSenha(VL_Dados, VP_Mensagem.GetTagAsInteger('005B'), VP_Mensagem.GetTagAsAstring(
                    '005F'), VP_Mensagem.GetTagAsAstring('00D9'), VP_Mensagem.GetTagAsInteger('005D'), VP_Mensagem.GetTagAsInteger('005E'),
                    VP_Mensagem.GetTagAsAstring('005C'), VO_Mensagem, VP_Mensagem.GetTagAsInteger('0051'));
                if Result <> 0 then
                begin
                    VO_Mensagem.AddTag('0046', Result);
                    VO_Mensagem.AddTag('004D', '6');
                    Exit;
                end;
                VL_Linha := '041220231511';
                VO_Mensagem.AddTag('0046', Result);
                VO_Mensagem.AddTag('004D', 0);
                VO_Mensagem.AddTag('0060', VL_Dados);
                TPinPad(VP_PinPad).PinPadMensagem('    OpenTef    ');
                Exit;
            end;
        end;
        if VL_Comando = '00FC' then     //mostrar imagem
        begin
            VO_Mensagem.AddComando('00FC', 'R');
            Result := TPinPad(VP_PinPad).PinPadImagem(VP_Mensagem.GetTagAsAstring('00FE'));
            if Result <> 0 then
            begin
                VO_Mensagem.AddTag('0046', Result);
                VO_Mensagem.AddTag('004D', '6');
                Exit;
            end;
        end;
    except
        on e: Exception do
        begin
            Result := 124;
            GravaLog(TPinPad(VP_PinPad).F_ArquivoLog, 0, '', 'pinpad_lib', VL_Linha, 'Erro de excecao na PinPadExecutaComando ' + e.ClassName +
                '/' + e.Message, VP_Mensagem.TagsAsString, 124, 1);
        end;
    end;
end;


{ TTPinPad }



procedure TTPinPad.Execute;
var
    VL_Comando, VL_Dados: string;
    VL_Tk1, VL_Tk2, VL_Tk3: string;
    VL_Retorno: integer;
    VL_Mensagem: TMensagem;
begin
    try
        VL_Mensagem := TMensagem.Create;
        VL_Dados := '';
        VL_Comando := '';
        VL_Tk1 := '';
        VL_Tk2 := '';
        VL_Tk3 := '';
        VL_Retorno := 0;
        fMensagem.GetComando(VL_Comando, VL_Dados);
        if VL_Comando = '0048' then     //ler tarja magnetica
        begin
            while True do
            begin
                if VL_Dados = 'S' then
                begin
                    TPinPad(fPinPad).PinPadMensagem(' Passe o cartao');
                    VL_Retorno := TPinPad(fPinPad).PinPadLerTarja(VL_Tk1, VL_Tk2, VL_Tk3, fMensagem.GetTagAsInteger('0051'), VL_Mensagem);
                    if VL_Retorno <> 0 then
                    begin
                        fMensagem.CarregaTags(VL_Mensagem.TagsAsString);
                        if Assigned(fRespostaPinPad) then
                            fRespostaPinPad(FProcessoID, fMensagem);
                        TPinPad(fPinPad).PinPadMensagem('    Operacao       cancelada    ');
                        sleep(2000);
                        TPinPad(fPinPad).PinPadMensagem('    OpenTef    ');
                        Exit;
                    end;

                    fMensagem.AddComando('0052', VL_Comando);
                    fMensagem.AddTag('004D', VL_Retorno);
                    fMensagem.AddTag('004E', VL_Tk1);
                    fMensagem.AddTag('004F', VL_Tk2);
                    fMensagem.AddTag('0050', VL_Tk3);
                    if Assigned(fRespostaPinPad) then
                        fRespostaPinPad(FProcessoID, fMensagem);
                    TPinPad(fPinPad).PinPadMensagem('    OpenTef    ');
                    Exit;
                end
                else
                begin
                    fMensagem.AddComando('004D', '51');
                    if Assigned(fRespostaPinPad) then
                        fRespostaPinPad(FProcessoID, fMensagem);
                    Exit;
                end;
            end;
        end;
        if VL_Comando = '005A' then     //ler senha
        begin
            while True do
            begin
                VL_Retorno := TPinPad(fPinPad).PinPadLerSenha(VL_Dados, fMensagem.GetTagAsInteger('005B'), fMensagem.GetTagAsAstring(
                    '005F'), fMensagem.GetTagAsAstring('00D9'), fMensagem.GetTagAsInteger('005D'), fMensagem.GetTagAsInteger('005E'),
                    fMensagem.GetTagAsAstring('005C'), VL_Mensagem, fMensagem.GetTagAsInteger('0051'));

                if VL_Retorno <> 0 then
                begin
                    fMensagem.CarregaTags(VL_Mensagem.TagsAsString);
                    if Assigned(fRespostaPinPad) then
                        fRespostaPinPad(FProcessoID, fMensagem);
                    TPinPad(fPinPad).PinPadMensagem('    Operacao       cancelada    ');
                    sleep(2000);
                    TPinPad(fPinPad).PinPadMensagem('    OpenTef    ');
                    Exit;
                end;

                fMensagem.AddComando('0052', VL_Comando);
                fMensagem.AddTag('004D', VL_Retorno);
                fMensagem.AddTag('0060', VL_Dados);
                if Assigned(fRespostaPinPad) then
                    fRespostaPinPad(FProcessoID, fMensagem);
                TPinPad(fPinPad).PinPadMensagem('    OpenTef    ');
                Exit;
            end;
        end;
        if VL_Comando = '00FC' then     //MOSTRAR IMAGEM
        begin
            VL_Retorno := TPinPad(fPinPad).PinPadImagem(fMensagem.GetTagAsAstring('00FE'));

            if VL_Retorno <> 0 then
            begin
                fMensagem.CarregaTags(VL_Mensagem.TagsAsString);
                if Assigned(fRespostaPinPad) then
                    fRespostaPinPad(FProcessoID, fMensagem);
                TPinPad(fPinPad).PinPadMensagem('    Operacao       cancelada    ');
                sleep(2000);
                TPinPad(fPinPad).PinPadMensagem('    OpenTef    ');
                Exit;
            end;

            fMensagem.AddComando('0052', VL_Comando);
            fMensagem.AddTag('004D', VL_Retorno);
            if Assigned(fRespostaPinPad) then
                fRespostaPinPad(FProcessoID, fMensagem);
            TPinPad(fPinPad).PinPadMensagem('    OpenTef    ');
            Exit;
        end;


    finally
        VL_Mensagem.Free;
        fMensagem.Free;
    end;
end;


constructor TTPinPad.Create(VP_PinPad:Pointer; VP_Processo_ID: integer; VP_CreateSuspended: boolean; VP_Mensagem: TMensagem; var VO_TRespostaPinPad: TRespostaPinPad);
begin
    fMensagem := TMensagem.Create;
    fMensagem.CarregaTags(VP_Mensagem.TagsAsString);
    fProcessoID := VP_Processo_ID;
    fRespostaPinPad := VO_TRespostaPinPad;
    FreeOnTerminate := True;
    inherited Create(VP_CreateSuspended);
end;

procedure TPinPad.PinPadErro(errCode: int16; msg: pansichar);
var
    VL_Mensagem: TMensagem;
begin
    VL_Mensagem := TMensagem.Create;
    try
        VL_Mensagem.AddComando('0049', IntToStr(errCode));
        VL_Mensagem.AddTag('004A', msg);
        if Assigned(fRespostaPinPad) then
            fRespostaPinPad(0, VL_Mensagem);
    finally
        VL_Mensagem.Free;
    end;

end;

end.
