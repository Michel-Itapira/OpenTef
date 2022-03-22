unit funcoes;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils,StrUtils, DCPdes;

type

  TTag = record
    Tag:String;
    Qt:string;
    Tamanho:LongInt;
    Dados:String;
  end;

  TMensagem = class
   private
   fTags : Array of TTag;
   public
   function CarregaTags(dados:string):Integer;
   function TagToStr(var dados:string):Integer;
   function GetComando(var tag:string):Integer;
   function GetTag(tag:string;var dados :string):Integer;
   function AddTag(tag,dados:string):integer;
  end;

  { TDataModule1 }

  TDataModule1 = class(TDataModule)
    DFuncoes: TDCP_3des;
  private

  public

  end;

var
  DataModule1: TDataModule1;

implementation

{$R *.lfm}


function TMensagem.GetComando(var tag:string):Integer;
begin
 if Length(fTags)>0 then
 tag:=fTags[0].Tag;
 result:=0;
end;

function TMensagem.CarregaTags(dados:string):Integer;
var
   vQtd,
   vResto,
   vTamanho : LongInt;

begin
  try
   // zera tags
   SetLength(fTags,0);

   // testa pacote
   if Copy(dados,1,4)<>'0000' then
   begin
    Result := 18;
    Exit;
   end;

   //tamanho de digitos do tamanho total do pacote
   vQtd:= Hex2Dec(copy(dados,5,1));

   // tamanho na mensagem completa
   vTamanho:= StrToInt64(copy(dados,6,vQtd));

   if vTamanho=0 then
   begin
    Result:=19;
    Exit;
   end;

   if vTamanho<>Length(dados) then
   begin
    Result:=20;
    Exit;
   end;

   dados:=Copy(dados,vQtd+6,Length(dados)-(5+vQtd));

   vResto:=Length(dados);

   while true do
   begin
     SetLength(fTags,Length(fTags)+1);
     fTags[Length(fTags)-1].Tag:=Copy(dados,1,4);
     fTags[Length(fTags)-1].Qt:=Copy(dados,5,1);
     fTags[Length(fTags)-1].Tamanho:=StrToInt64(Copy(dados,6, Hex2Dec(fTags[Length(fTags)-1].Qt)));
     fTags[Length(fTags)-1].Dados:=Copy(dados,6+Hex2Dec(fTags[Length(fTags)-1].Qt) ,fTags[Length(fTags)-1].Tamanho);

     dados:=Copy(dados,6+Hex2Dec(fTags[Length(fTags)-1].Qt)+fTags[Length(fTags)-1].Tamanho,MaxInt);

     if Length(dados)>=vResto then
     begin
      Result:=21;
      Exit;
     end;
     vResto:=Length(dados);

     if vResto=0 then
     Break;

   end;
   Result := 0;

  except
    Result:=30;
  end;
end;

function TMensagem.TagToStr(var dados:string):Integer;
var
 i : Integer;
 vTamanhoPacote : LongInt;
 vDados : String;

begin
 if length(fTags)=0 then
 begin
  Result:=23;
  Exit;
 end;
 vDados:='';
 for i := 0 to length(fTags)-1 do
 begin
  vDados:=vDados+fTags[i].Tag+fTags[i].Qt+inttostr(fTags[i].Tamanho)+fTags[i].Dados;
 end;
 vTamanhoPacote:=length(vDados)+5;
 vTamanhoPacote:=vTamanhoPacote+length(inttostr(vTamanhoPacote));
 vDados:='0000'+HexStr(length(inttostr(vTamanhoPacote)),1)+inttostr(vTamanhoPacote)+vDados;
 dados := vDados;
 result := 0;
end;

function TMensagem.GetTag(tag:string;var dados :string):Integer;
var
   i : integer;
begin
 //Verifica se existe o pacote
 if length(fTags)=0 then
 begin
  Result:=22;
  Exit;
 end;
 if Length(tag)=0 then
 begin
  Result:=28;
  Exit;
 end;
 for i := 0 to length(fTags)-1 do
 begin
  if fTags[i].Tag=tag then
  begin
   dados := fTags[i].Dados;
   Result :=0;
   Exit;
  end;
 end;
 //Tag não encontrada no pacote
 Result:=29;
end;


function TMensagem.AddTag(tag,dados:string):integer;
var
   i : Integer;
procedure incluir(posicao:Integer);
begin
     if Length(fTags[posicao].Tag)=0 then
     begin
      Result:=25;
      Exit;
     end;
     fTags[posicao].Tag:=tag;
     fTags[posicao].Qt:=HexStr(length(inttostr(Length(dados))),1);
     fTags[posicao].Tamanho:=Length(dados);
     fTags[posicao].Dados:=dados;
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
  if fTags[i].Tag=tag then
  begin
   incluir(i);
   Result :=0;
   Exit;
  end;
 end;
 SetLength(fTags,Length(fTags)+1);
 incluir(Length(fTags));

end;

function Des3_128(Acao,Pin,WK: string): string;
var
    DFuncoes: TDCP_3des;
    Key: array [1..16] of Byte;
    Dados: array [1..8] of Byte;
    Resultado: array [1..8] of Byte;
    p,i:integer;


begin
Result:='';



 DFuncoes:=TDCP_3des.Create(nil);
 try
  p:=1;

   for I := 1 to 16 do
    key[i]:=0;

  for I := 1 to Length(key) do
  begin
    Key[I]:=   strutils.Hex2Dec(Copy(WK,p,2));
    p:=p+2;
  end;

 for I := 1 to 8 do
   Dados[i]:=0;

 for I := 1 to 8 do
   Resultado[i]:=0;

 DFuncoes.Init(key,length(key)*8,nil);

 Result:='';

 p:=1;

  for I := 1 to 8  do
  begin
    if Copy(Pin,p,2)<>'' then
    Dados[I]:= strutils.Hex2Dec(Copy(Pin,p,2));
    p:=p+2;
  end;


 if Acao='D' then
 DFuncoes.DecryptECB(dados,Resultado)
 else
 DFuncoes.EncryptECB(dados,Resultado);


 for I := 1 to Length(Resultado) do
  begin
    Result:=Result+IntToHex(Resultado[i],2);
  end;


 for I := 1 to 8 do
   Dados[i]:=0;

 for I := 1 to 8 do
   Resultado[i]:=0;

 p:=17;

  for I := 1 to 8  do
  begin
   if Copy(Pin,p,2)<>'' then
    Dados[I]:= strutils.Hex2Dec(Copy(Pin,p,2));
    p:=p+2;
  end;


 if Acao='D' then
 DFuncoes.DecryptECB(dados,Resultado)
 else
 DFuncoes.EncryptECB(dados,Resultado);


 for I := 1 to 8 do
  begin
    Result:=Result+IntToHex(Resultado[i],2);
  end;




 finally
  DFuncoes.Free;
 end;
end;

end.

