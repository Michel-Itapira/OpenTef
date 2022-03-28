unit funcoes;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils,StrUtils, DCPdes;

type

  TTag = record
    Tag:String;
    Qt:String;
    Tamanho:LongInt;
    Dados:String;
  end;

  TMensagem = class
   private
   fTags : Array of TTag;
   public
   function CarregaTags(VP_Dados:string):Integer;
   function TagToStr(var VO_Dados:string):Integer;
   function AddComando(VP_Tag,VP_Dados:string):Integer;
   function GetComando(var VO_Tag:string):Integer;
   function GetComandoInt(var VO_Tag:Integer):Integer;
   function GetTag(VP_Tag:string;var VO_Dados :string):Integer;
   function AddTag(VP_Tag,VP_Dados:string):Integer;
   procedure Limpar;
  end;

  { TDFuncoes }

  TDFuncoes = class(TDataModule)
  private

  public

  end;

var
  Des: TDFuncoes;

implementation

{$R *.lfm}


function TMensagem.GetComando(var VO_Tag:string):Integer;
begin
 if Length(fTags)>0 then
 VO_Tag:=fTags[0].Tag;
 result:=0;
end;

function TMensagem.GetComandoInt(var VO_Tag:Integer):Integer;
begin
 if Length(fTags)>0 then
 VO_Tag:=Hex2Dec(fTags[0].Tag);
 result:=0;
end;


function TMensagem.CarregaTags(VP_Dados:string):Integer;
var
   VL_Qtd,
   VL_Resto,
   VL_Tamanho : LongInt;

begin
  try
   // zera tags
   SetLength(fTags,0);

   // testa pacote
   if Copy(VP_Dados,1,4)<>'0000' then
   begin
    Result := 18;
    Exit;
   end;

   //tamanho de digitos do tamanho total do pacote
   VL_Qtd:= Hex2Dec(copy(VP_Dados,5,1));

   // tamanho na mensagem completa
   VL_Tamanho:= StrToInt64(copy(VP_Dados,6,VL_Qtd));

   if VL_Tamanho=0 then
   begin
    Result:=19;
    Exit;
   end;

   if VL_Tamanho<>Length(VP_Dados) then
   begin
    Result:=20;
    Exit;
   end;

   VP_Dados:=Copy(VP_Dados,VL_Qtd+6,Length(VP_Dados)-(5+VL_Qtd));

   VL_Resto:=Length(VP_Dados);

   while true do
   begin
     SetLength(fTags,Length(fTags)+1);
     fTags[Length(fTags)-1].Tag:=Copy(VP_Dados,1,4);
     fTags[Length(fTags)-1].Qt:=Copy(VP_Dados,5,1);
     fTags[Length(fTags)-1].Tamanho:=StrToInt64Def(Copy(VP_Dados,6, Hex2Dec(fTags[Length(fTags)-1].Qt)),0);
     fTags[Length(fTags)-1].Dados:=Copy(VP_Dados,6+Hex2Dec(fTags[Length(fTags)-1].Qt) ,fTags[Length(fTags)-1].Tamanho);

     VP_Dados:=Copy(VP_Dados,6+Hex2Dec(fTags[Length(fTags)-1].Qt)+fTags[Length(fTags)-1].Tamanho,MaxInt);

     if Length(VP_Dados)>=VL_Resto then
     begin
      Result:=21;
      Exit;
     end;
     VL_Resto:=Length(VP_Dados);

     if VL_Resto=0 then
     Break;

   end;
   Result := 0;

  except
    Result:=30;
  end;
end;

function TMensagem.TagToStr(var VO_Dados:string):Integer;
var
 i : Integer;
 VL_TamanhoPacote : LongInt;
 VL_Dados : String;

begin
 if length(fTags)=0 then
 begin
  Result:=23;
  Exit;
 end;
 VL_Dados:='';
 for i := 0 to length(fTags)-1 do
 begin
  VL_Dados:=VL_Dados+fTags[i].Tag+fTags[i].Qt+inttostr(fTags[i].Tamanho)+fTags[i].Dados;
 end;
 VL_TamanhoPacote:=length(VL_Dados)+5;
 VL_TamanhoPacote:=VL_TamanhoPacote+length(inttostr(VL_TamanhoPacote));
 VL_Dados:='0000'+HexStr(length(inttostr(VL_TamanhoPacote)),1)+inttostr(VL_TamanhoPacote)+VL_Dados;
 VO_Dados := VL_Dados;
 result := 0;
end;

function TMensagem.GetTag(VP_Tag:string;var VO_Dados :string):Integer;
var
   i : integer;
begin
 //Verifica se existe o pacote
 if length(fTags)=0 then
 begin
  Result:=22;
  Exit;
 end;
 //Verifica se o parametro é nulo ou diferente da estrutura
 if Length(VP_Tag)<>4 then
 begin
  Result:=28;
  Exit;
 end;
 for i := 0 to length(fTags)-1 do
 begin
  if fTags[i].Tag=VP_Tag then
  begin
   VO_Dados := fTags[i].Dados;
   Result :=0;
   Exit;
  end;
 end;
 //Tag não encontrada no pacote
 Result:=29;
end;


function TMensagem.AddTag(VP_Tag,VP_Dados:string):Integer;
var
   i : Integer;
procedure incluir(VP_Posicao:Integer);
begin
     fTags[VP_Posicao].Tag:=VP_Tag;
     fTags[VP_Posicao].Qt:=HexStr(length(inttostr(Length(VP_Dados))),1);
     fTags[VP_Posicao].Tamanho:=Length(VP_Dados);
     fTags[VP_Posicao].Dados:=VP_Dados;
end;

begin

 //Verifica se existe o pacote
 if length(fTags)=0 then
 begin
  Result:=27;
  Exit;
 end;
 //verifica se o parametro dados contem valor
 for i := 0 to length(fTags)-1 do
 begin
  if fTags[i].Tag=VP_Tag then
  begin
   incluir(i);
   Result :=0;
   Exit;
  end;
 end;
 SetLength(fTags,Length(fTags)+1);
 incluir(Length(fTags)-1);

end;

procedure TMensagem.Limpar;
begin
 SetLength(fTags,0);
end;

function TMensagem.AddComando(VP_Tag,VP_Dados:string):Integer;
begin

 //Verifica se existe o pacote
 if length(fTags)=0 then
 SetLength(fTags,Length(fTags)+1);

 fTags[0].Tag:=VP_Tag;
 fTags[0].Qt:=HexStr(length(inttostr(Length(VP_Dados))),1);
 fTags[0].Tamanho:=Length(VP_Dados);
 fTags[0].Dados:=VP_Dados;

 Result:=0;
end;


//function Des3(Acao,Pin,WK: string): string;
//var
//    Des: TDCP_3des;
//    Key: array [1..16] of Byte;
//    Dados: array [1..8] of Byte;
//    Resultado: array [1..8] of Byte;
//    p,i:integer;
//
//
//begin
//Result:='';
//
// Des:=TDCP_3des.Create(nil);
// try
//  p:=1;
//
//   for I := 1 to 16 do
//    key[i]:=0;
//
//  for I := 1 to Length(key) do
//  begin
//    Key[I]:=   strutils.Hex2Dec(Copy(WK,p,2));
//    p:=p+2;
//  end;
//
// for I := 1 to 8 do
//   Dados[i]:=0;
//
// for I := 1 to 8 do
//   Resultado[i]:=0;
//
// Des.Init(key,length(key)*8,nil);
//
// Result:='';
//
// p:=1;
//
//  for I := 1 to 8  do
//  begin
//    if Copy(Pin,p,2)<>'' then
//    Dados[I]:= strutils.Hex2Dec(Copy(Pin,p,2));
//    p:=p+2;
//  end;
//
//
// if Acao='D' then
// Des.DecryptECB(dados,Resultado)
// else
// Des.EncryptECB(dados,Resultado);
//
//
// for I := 1 to Length(Resultado) do
//  begin
//    Result:=Result+IntToHex(Resultado[i],2);
//  end;
//
//
// for I := 1 to 8 do
//   Dados[i]:=0;
//
// for I := 1 to 8 do
//   Resultado[i]:=0;
//
// p:=17;
//
//  for I := 1 to 8  do
//  begin
//   if Copy(Pin,p,2)<>'' then
//    Dados[I]:= strutils.Hex2Dec(Copy(Pin,p,2));
//    p:=p+2;
//  end;
//
//
// if Acao='D' then
// Des.DecryptECB(dados,Resultado)
// else
// Des.EncryptECB(dados,Resultado);
//
//
// for I := 1 to 8 do
//  begin
//    Result:=Result+IntToHex(Resultado[i],2);
//  end;
//
// finally
//  Des.Free;
// end;
//end;
//
end.

