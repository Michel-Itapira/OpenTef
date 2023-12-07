unit uprodutos;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils;

type
    TProduto = record
        codigo: integer;
        descricao: string;
        valor: double;
    end;

const
    C_PRODUTOS: array[0 .. 2] of TProduto = (
        (codigo: 1; descricao: 'Pão'; valor: 1),
        (codigo: 2; descricao: 'Arroz'; valor: 10),
        (codigo: 3; descricao: 'Uva'; valor: 8)
        );

function getProduto(codigo: integer): TProduto;

implementation

function getProduto(codigo: integer): TProduto;
var
    I: integer;
begin
    Result.codigo := 0;
    Result.descricao := '';
    Result.valor := 0;

    for I := 0 to C_PRODUTOS - 1 do
    begin
        if C_PRODUTOS[I].codigo = codigo then
            Result := C_PRODUTOS[I];
    end;
end;

end.
