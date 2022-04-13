unit funcoes;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils, StrUtils, DCPdes, ZDataset,rxmemds;
type

    TPinPadModelo = (pNDF, pGERTEC_PPC930);

    TTag = record
        Tag: string;
        Qt: string;
        Tamanho: longint;
        Dados: string;
    end;

    { TMensagem }

    TMensagem = class
    private
        fTags: array of TTag;
    public
        function CarregaTags(VP_Dados: string): integer;
        function TagToStr(var VO_Dados: string): integer;
        function AddComando(VP_Tag, VP_Dados: string): integer;
        function GetComando(var VO_Tag: string; var VO_Dados: string): integer;
        function GetComandoInt(var VO_Tag: integer; var VO_Dados: string): integer;
        function GetTag(VP_Tag: string; var VO_Dados: string): integer;
        function GetTag(VP_Tag: string; var VO_Dados: integer): integer;
        function GetTagAsAstring(VP_Tag: string): string;
        function GetTagAsInteger(VP_Tag: string): integer;
        function AddTag(VP_Tag, VP_Dados: string): integer;
        function AddTag(VP_Tag: string; VP_Dados: integer): integer;
        procedure Limpar;
    end;

    { TDFuncoes }

    TDFuncoes = class(TDataModule)
      RxMemoryData1: TRxMemoryData;
    private

    public
        procedure StrToRxMemData(VP_Dados: string; var VO_MemDataSet: TRxMemoryData);
        function RxMemDataToStr(VO_MemDataSet: TRxMemoryData): string;
        function ZQueryToStrRxMemData(VO_ZQuery: TZQuery): string;
        procedure CriarChaveTerminal(var VO_Chave: string);
    end;

var
    Des: TDFuncoes;


implementation

{$R *.lfm}

{ TDFuncoes }



function TDFuncoes.RxMemDataToStr(VO_MemDataSet: TRxMemoryData): string;
var
    VL_MemString: TStringStream;
    VL_Mem: TMemoryStream;
    VL_String: string;
    VL_bytes: array of byte;
    VL_i: integer;
begin
    VL_bytes := nil;

    VL_MemString := TStringStream.Create;
    VL_Mem := TMemoryStream.Create;

    VO_MemDataSet.SaveToStream(VL_Mem);

    VL_Mem.SaveToStream(VL_MemString);

    VL_String := VL_MemString.DataString;

    //  converte em bytes
    for VL_i := 0 to Length(VL_String) - 1 do
    begin
        SetLength(VL_bytes, Length(VL_bytes) + 1);
        VL_bytes[VL_i] := Ord(VL_String[VL_i]);
    end;
    // converte em hex
    VL_String := '';
    for VL_i := 0 to Length(VL_bytes) - 1 do
        VL_String := VL_String + HexStr(VL_bytes[VL_i], 2);

    Result := VL_String;
    VL_MemString.Free;
    VL_Mem.Free;
end;

procedure TDFuncoes.StrToRxMemData(VP_Dados: string; var VO_MemDataSet: TRxMemoryData);
var
    VL_bytes: array of byte;
    VL_i: integer;
    VL_String: string;
    VL_MemString: TStringStream;
    VL_Mem: TMemoryStream;
begin

    VL_bytes := nil;
    // converte em bytes
    if VP_Dados = '' then
        exit;

    for VL_i := 0 to (Length(VP_Dados) div 2) - 1 do
    begin
        SetLength(VL_bytes, Length(VL_bytes) + 1);
        VL_bytes[VL_i] := Hex2Dec(copy(VP_Dados, ((VL_i + 1) * 2) - 1, 2));
    end;

    VL_String := '';


    for VL_i := 0 to Length(VL_bytes) - 1 do
    begin
        SetLength(VL_String, Length(VL_String) + 1);
        VL_String[VL_i] := char(VL_bytes[VL_i]);
    end;

    VL_MemString := TStringStream.Create(VL_String);
    VL_Mem:= TMemoryStream.Create;

    VL_MemString.SaveToStream(VL_Mem);

    VO_MemDataSet.LoadFromStream(VL_Mem);
    VL_MemString.Free;
    VL_Mem.Free;

end;


function TDFuncoes.ZQueryToStrRxMemData(VO_ZQuery: TZQuery): string;
var
    VL_MemDataset: TRxMemoryData;
begin
    VL_MemDataset := TRxMemoryData.Create(nil);
    try
       VO_ZQuery.First;
        VL_MemDataset.LoadFromDataSet(VO_ZQuery,MaxInt,lmCopy);
        Result := RxMemDataToStr(VL_MemDataset);
    finally
        VL_MemDataset.Free;
    end;
end;


procedure TDFuncoes.CriarChaveTerminal(var VO_Chave: string);
var
    VL_Chave: string;
    I: integer;
begin
    VL_Chave := '';
    Randomize;
    for I := 0 to 50 do
    begin
        if Length(VL_Chave) < 50 then
            VL_Chave := VL_Chave + IntToStr(Random(999));
    end;
    VO_Chave := Copy(VL_Chave, 1, 50);
end;


function TMensagem.GetComando(var VO_Tag: string; var VO_Dados: string): integer;
begin
    if Length(fTags) > 0 then
    begin
        VO_Tag := fTags[0].Tag;
        self.GetTag(VO_Tag, VO_Dados);
    end;
    Result := 0;
end;

function TMensagem.GetComandoInt(var VO_Tag: integer; var VO_Dados: string): integer;
begin
    if Length(fTags) > 0 then
    begin
        VO_Tag := Hex2Dec(fTags[0].Tag);
        self.GetTag(fTags[0].Tag, VO_Dados);
    end;
    Result := 0;
end;


function TMensagem.CarregaTags(VP_Dados: string): integer;
var
    VL_Qtd, VL_Resto, VL_Tamanho: longint;

begin
    try
        // zera tags
        SetLength(fTags, 0);

        // testa pacote
        if Copy(VP_Dados, 1, 4) <> '0000' then
        begin
            Result := 18;
            Exit;
        end;

        //tamanho de digitos do tamanho total do pacote
        VL_Qtd := Hex2Dec(copy(VP_Dados, 5, 1));

        // tamanho na mensagem completa
        VL_Tamanho := StrToInt64(copy(VP_Dados, 6, VL_Qtd));

        if VL_Tamanho = 0 then
        begin
            Result := 19;
            Exit;
        end;

        if VL_Tamanho <> Length(VP_Dados) then
        begin
            Result := 20;
            Exit;
        end;

        VP_Dados := Copy(VP_Dados, VL_Qtd + 6, Length(VP_Dados) - (5 + VL_Qtd));

        VL_Resto := Length(VP_Dados);

        while True do
        begin
            SetLength(fTags, Length(fTags) + 1);
            fTags[Length(fTags) - 1].Tag := Copy(VP_Dados, 1, 4);
            fTags[Length(fTags) - 1].Qt := Copy(VP_Dados, 5, 1);
            fTags[Length(fTags) - 1].Tamanho :=
                StrToInt64Def(Copy(VP_Dados, 6, Hex2Dec(fTags[Length(fTags) - 1].Qt)), 0);
            fTags[Length(fTags) - 1].Dados :=
                Copy(VP_Dados, 6 + Hex2Dec(fTags[Length(fTags) - 1].Qt), fTags[Length(fTags) - 1].Tamanho);

            VP_Dados := Copy(VP_Dados, 6 + Hex2Dec(fTags[Length(fTags) - 1].Qt) + fTags[Length(fTags) - 1].Tamanho, MaxInt);

            if Length(VP_Dados) >= VL_Resto then
            begin
                Result := 21;
                Exit;
            end;
            VL_Resto := Length(VP_Dados);

            if VL_Resto = 0 then
                Break;

        end;
        Result := 0;

    except
        Result := 30;
    end;
end;

function TMensagem.TagToStr(var VO_Dados: string): integer;
var
    VL_Digitos, i: integer;
    VL_TamanhoPacote: longint;
    VL_Dados: string;

begin
    if length(fTags) = 0 then
    begin
        Result := 23;
        Exit;
    end;
    VL_Dados := '';
    for i := 0 to length(fTags) - 1 do
    begin
        VL_Dados := VL_Dados + fTags[i].Tag + fTags[i].Qt + IntToStr(fTags[i].Tamanho) + fTags[i].Dados;
    end;
    VL_TamanhoPacote := length(VL_Dados) + 5;

    VL_Digitos := Length(IntToStr(VL_TamanhoPacote));

    VL_Digitos := Length(IntToStr(VL_TamanhoPacote + VL_Digitos));

    VL_TamanhoPacote := VL_TamanhoPacote + VL_Digitos;

    VL_Dados := '0000' + HexStr((VL_Digitos), 1) + IntToStr(VL_TamanhoPacote) + VL_Dados;
    VO_Dados := VL_Dados;
    Result := 0;
end;

function TMensagem.GetTag(VP_Tag: string; var VO_Dados: string): integer;
var
    i: integer;
begin
    //Verifica se existe o pacote
    if length(fTags) = 0 then
    begin
        Result := 22;
        Exit;
    end;
    //Verifica se o parametro é nulo ou diferente da estrutura
    if Length(VP_Tag) <> 4 then
    begin
        Result := 28;
        Exit;
    end;
    for i := 0 to length(fTags) - 1 do
    begin
        if fTags[i].Tag = VP_Tag then
        begin
            VO_Dados := fTags[i].Dados;
            Result := 0;
            Exit;
        end;
    end;
    //Tag não encontrada no pacote
    Result := 29;
end;

function TMensagem.GetTag(VP_Tag: string; var VO_Dados: integer): integer;
var
    i: integer;
begin
    //Verifica se existe o pacote
    if length(fTags) = 0 then
    begin
        Result := 22;
        Exit;
    end;
    //Verifica se o parametro é nulo ou diferente da estrutura
    if Length(VP_Tag) <> 4 then
    begin
        Result := 28;
        Exit;
    end;
    for i := 0 to length(fTags) - 1 do
    begin
        if fTags[i].Tag = VP_Tag then
        begin
            VO_Dados := StrToInt(fTags[i].Dados);
            Result := 0;
            Exit;
        end;
    end;
    //Tag não encontrada no pacote
    Result := 29;
end;

function TMensagem.GetTagAsAstring(VP_Tag: string): string;
var
    VL_String: string;
begin
    Result := '';
    if GetTag(VP_Tag, VL_String) = 0 then
        Result := VL_String;
end;

function TMensagem.GetTagAsInteger(VP_Tag: string): integer;
var
    VL_String: string;
begin
    Result := 0;
    if GetTag(VP_Tag, VL_String) = 0 then
        if VL_String <> '' then
            Result := StrToInt(VL_String);
end;


function TMensagem.AddTag(VP_Tag, VP_Dados: string): integer;
var
    i: integer;

    procedure incluir(VP_Posicao: integer);
    begin
        fTags[VP_Posicao].Tag := VP_Tag;
        fTags[VP_Posicao].Qt := HexStr(length(IntToStr(Length(VP_Dados))), 1);
        fTags[VP_Posicao].Tamanho := Length(VP_Dados);
        fTags[VP_Posicao].Dados := VP_Dados;
    end;

begin

    //Verifica se existe o pacote
    if length(fTags) = 0 then
    begin
        Result := 27;
        Exit;
    end;
    //verifica se o parametro dados contem valor
    for i := 0 to length(fTags) - 1 do
    begin
        if fTags[i].Tag = VP_Tag then
        begin
            incluir(i);
            Result := 0;
            Exit;
        end;
    end;
    SetLength(fTags, Length(fTags) + 1);
    incluir(Length(fTags) - 1);

end;

function TMensagem.AddTag(VP_Tag: string; VP_Dados: integer): integer;
var
    i: integer;

    procedure incluir(VP_Posicao: integer);
    begin
        fTags[VP_Posicao].Tag := VP_Tag;
        fTags[VP_Posicao].Qt := HexStr(length(IntToStr(Length(IntToStr(VP_Dados)))), 1);
        fTags[VP_Posicao].Tamanho := Length(IntToStr(VP_Dados));
        fTags[VP_Posicao].Dados := IntToStr(VP_Dados);
    end;

begin

    //Verifica se existe o pacote
    if length(fTags) = 0 then
    begin
        Result := 27;
        Exit;
    end;
    //verifica se o parametro dados contem valor
    for i := 0 to length(fTags) - 1 do
    begin
        if fTags[i].Tag = VP_Tag then
        begin
            incluir(i);
            Result := 0;
            Exit;
        end;
    end;
    SetLength(fTags, Length(fTags) + 1);
    incluir(Length(fTags) - 1);

end;

procedure TMensagem.Limpar;
begin
    SetLength(fTags, 0);
end;

function TMensagem.AddComando(VP_Tag, VP_Dados: string): integer;
begin

    //Verifica se existe o pacote
    if length(fTags) = 0 then
        SetLength(fTags, Length(fTags) + 1);

    fTags[0].Tag := VP_Tag;
    fTags[0].Qt := HexStr(length(IntToStr(Length(VP_Dados))), 1);
    fTags[0].Tamanho := Length(VP_Dados);
    fTags[0].Dados := VP_Dados;

    Result := 0;
end;


//function Des3(Acao,Pin,WK: string): string;
//var
//    Des: TDCP_3des;
//    Key: array [1..16] of Byte;
//    Dados: array [1..8] of Byte;
//    Resultado: array [1..8] of Byte;
//    p,i:integer;


//begin
//Result:='';

// Des:=TDCP_3des.Create(nil);
// try
//  p:=1;

//   for I := 1 to 16 do
//    key[i]:=0;

//  for I := 1 to Length(key) do
//  begin
//    Key[I]:=   strutils.Hex2Dec(Copy(WK,p,2));
//    p:=p+2;
//  end;

// for I := 1 to 8 do
//   Dados[i]:=0;

// for I := 1 to 8 do
//   Resultado[i]:=0;

// Des.Init(key,length(key)*8,nil);

// Result:='';

// p:=1;

//  for I := 1 to 8  do
//  begin
//    if Copy(Pin,p,2)<>'' then
//    Dados[I]:= strutils.Hex2Dec(Copy(Pin,p,2));
//    p:=p+2;
//  end;


// if Acao='D' then
// Des.DecryptECB(dados,Resultado)
// else
// Des.EncryptECB(dados,Resultado);


// for I := 1 to Length(Resultado) do
//  begin
//    Result:=Result+IntToHex(Resultado[i],2);
//  end;


// for I := 1 to 8 do
//   Dados[i]:=0;

// for I := 1 to 8 do
//   Resultado[i]:=0;

// p:=17;

//  for I := 1 to 8  do
//  begin
//   if Copy(Pin,p,2)<>'' then
//    Dados[I]:= strutils.Hex2Dec(Copy(Pin,p,2));
//    p:=p+2;
//  end;


// if Acao='D' then
// Des.DecryptECB(dados,Resultado)
// else
// Des.EncryptECB(dados,Resultado);


// for I := 1 to 8 do
//  begin
//    Result:=Result+IntToHex(Resultado[i],2);
//  end;

// finally
//  Des.Free;
// end;
//end;

end.
