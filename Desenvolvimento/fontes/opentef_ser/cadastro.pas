unit cadastro;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils, IniFiles, comunicador, ZConnection, ZDataset, funcoes, rxmemds, StrUtils, IdContext, SyncObjs;

function comando002B(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //excluir modulo
function comando0039(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //incluir Loja
function comando003F(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //alterar Loja
function comando0044(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //incluir PDV
function comando0045(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //valida chave PDV
function comando004B(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //alterar PDV
function comando0052(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //incluir TAG
function comando0053(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //incluir PinPad
function comando0055(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //alterar PinPad
function comando0057(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //incluir CONFIGURADOR
function comando0058(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //alterar CONFIGURADOR
function comando0059(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //valida chave do CONFIGURADOR
function comando0064(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //incluir MultLoja
function comando0066(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //excluir MultLoja
function comando0067(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //alterar MultLoja
function comando0069(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //excluir Loja
function comando006A(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //excluir PinPad
function comando006B(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //excluir PDV
function comando0070(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //pesquisar Tabelas(pesquisa em lote)
function comando0071(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //VALIDA CHAVE MODULO_CONF
function comando0072(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //alterar MODULO_CONF
function comando0073(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //incluir MODULO_CONF
function comando0074(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //incluir MODULO
function comando0075(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //alterar MODULO
function comando0077(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //incluir BIN
function comando0078(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //excluir BIN
function comando0079(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //incluir MODULO_CONF_FUNCAO
function comando007E(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //incluir MODULO_FUNCAO
function comando007F(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //excluir MODULO_FUNCAO
function comando0085(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //alterar MODULO_CONF_FUNCAO
function comando0087(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //excluir LOJA_MODULO_CONF_FUNCAO
function comando0088(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //excluir MULTILOJA_MODULO_CONF_FUNCAO
function comando008A(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //excluir MODULO_CONF_FUNCAO
function comando0096(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //incluir MULTLOJA_MODULO
function comando0099(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //excluir MULTLOJA_MODULO
function comando009A(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //alterar MULTLOJA_MODULO
function comando009B(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //incluir LOJA_MODULO_CONF_FUNCAO
function comando009D(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //incluir MULTLOJA_FUNCAO
function comando009F(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //alterar MULTLOJA_FUNCAO
function comando00A0(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //excluir MULTLOJA_FUNCAO
function comando00AA(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //incluir LOJA_FUNCAO
function comando00AC(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //alterar LOJA_FUNCAO
function comando00AD(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //excluir LOJA_FUNCAO
function comando00AE(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //incluir LOJA_MODULO
function comando00B0(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //alterar MULTILOJA_MODULO_CONF_FUNCAO
function comando00B1(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //alterar LOJA_MODULO
function comando00B2(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //excluir LOJA_MODULO
function comando00B5(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //incluir PINPAD_FUNCAO
function comando00B6(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //alterar PINPAD_FUNCAO
function comando00B8(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //excluir PINPAD_FUNCAO
function comando00B9(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //alterar MODULO_FUNCAO
function comando00BA(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //excluir MODULO_CONF
function comando00BB(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //excluir CONFIGURADOR
function comando00BF(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //alterar LOJA_MODULO_CONF_FUNCAO
function comando00C2(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //incluir PDV_FUNCAO
function comando00C4(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //alterar PDV_FUNCAO
function comando00C5(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //excluir PDV_FUNCAO
function comando00C8(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //incluir PDV_MODULO
function comando00CA(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //incluir MULTILOJA_MODULO_CONF_FUNCAO
function comando00CB(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //alterar PDV_MODULO
function comando00CC(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //excluir PDV_MODULO
function comando00DB(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //alterar TAG
function comando00DC(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //excluir TAG
function comando00DE(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //incluir ADQUIRENTE
function comando00DF(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //alterar ADQUIRENTE
function comando00E0(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //excluir ADQUIRENTE


const
      C_TempoAguarda=3000;

implementation

uses opentefnucleo;

function comando0039(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;   //loja incluir
var
    VL_Mensagem: TMensagem;
    VL_Tabela: TRxMemoryData;
    VL_TLoja: TZQuery;
    VL_Tag: ansistring;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_Tabela := TRxMemoryData.Create(nil);
    VL_TLoja := TZQuery.Create(DComunicador);
    VL_TLoja.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Linha := '';
    VL_Erro := 0;
    try
        try
            //verifica permissao
            if ((TTConexao(VP_AContext.Data).Permissao = pmU) or (TTConexao(VP_AContext.Data).Permissao = pmS)) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0039', 'R');
                VL_Mensagem.AddTag('004D', '45');  //sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '040520221522';
                GravaLog(F_ArquivoLog, 0, '0039', 'cadastro', VL_Linha, 'sem permissao para incluir registro na tabela Loja', '', VL_Erro);
                Exit;
            end;
            //VERIFICA PARAMETROS
            VP_Mensagem.GetTag('003E', VL_Tag);  //carrega tabela LOJA
            if Length(VL_Tag) = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0039', 'R');
                VL_Mensagem.Addtag('004D', '47');  //sem REGISTRO
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '300520221116';
                GravaLog(F_ArquivoLog, 0, '0039', 'cadastro', VL_Linha, 'Parametro informado na tag:003E esta em branco ou nula', '', VL_Erro);
                Exit;
            end;
            StrToRxMemData(VL_Tag, VL_Tabela);
            VL_Tabela.Open;

            if VL_Tabela.RecordCount = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0039', 'R');
                VL_Mensagem.Addtag('004D', '47');  //sem REGISTRO
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '300520221203';
                GravaLog(F_ArquivoLog, 0, '0039', 'cadastro', VL_Linha, 'Parametro informado na tag:003E esta em branco ou nula', '', VL_Erro);
                Exit;
            end;
            VL_Tabela.First;
            while not VL_Tabela.EOF do
            begin
                if VL_Tabela.FieldByName('ID').AsInteger = 0 then
                begin
                    //verifica se existe a loja ja cadastrada com o mesmo cnpj
                    VL_TLoja.Close;
                    VL_TLoja.SQL.Text := 'SELECT * FROM LOJA WHERE DOC=''' + VL_Tabela.FieldByName('DOC').AsString + '''';
                    VL_Erro := 55;
                    VL_Linha := '300520221119';
                    VL_TLoja.Open;
                    if VL_TLoja.RecordCount > 0 then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('0039', 'R');
                        VL_Mensagem.Addtag('004D', '43');//registro em duplicidade
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        VL_Erro := 43;
                        VL_Linha := '040520221525';
                        GravaLog(F_ArquivoLog, 0, '0039', 'cadastro', VL_Linha, 'registro em duplicidade na tabela Loja (DOC:' +
                            VL_Tabela.FieldByName('DOC').AsString + ' já cadastrado)', '', VL_Erro);
                        Exit;
                    end;
                    //COMEÇA A INCLUSÃO
                    VL_TLoja.Close;
                    VL_TLoja.SQL.Text := 'INSERT INTO LOJA(DOC,RAZAO,FANTASIA,MULTILOJA_ID,HABILITADO)VALUES(''' + VL_Tabela.FieldByName(
                        'DOC').AsString + ''',''' + VL_Tabela.FieldByName('RAZAO').AsString + ''',''' +
                        VL_Tabela.FieldByName('FANTASIA').AsString + ''',' +
                        IntToStr(VL_Tabela.FieldByName('MULTILOJA_ID').AsInteger) + ',''' +
                        VL_Tabela.FieldByName('HABILITADO').AsString + ''')';
                    VL_Erro := 44;
                    VL_Linha := '300520221119';
                    VL_TLoja.ExecSQL;

                    VL_TLoja.Close;
                    VL_TLoja.SQL.Text := 'SELECT * FROM LOJA WHERE DOC=''' + VL_Tabela.FieldByName('DOC').AsString + '''';
                    VL_Erro := 55;
                    VL_Linha := '020620221219';
                    VL_TLoja.Open;

                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('0039', 'R');
                    VL_Mensagem.AddTag('004D', '0');
                    VL_Mensagem.AddTag('003C', VL_TLoja.FieldByName('ID').AsString);
                    DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                    Exit;
                end;
                VL_Tabela.Next;
            end;
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('0039', 'R');
            VL_Mensagem.AddTag('004D', '44');
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '0039', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '0039', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_Tabela.Free;
            VL_TLoja.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '0039', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;


function comando003F(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //alterar loja
var
    VL_Mensagem: TMensagem;
    VL_Loja: TZQuery;
    VL_Tabela: TRxMemoryData;
    VL_Tag: ansistring;
    VL_ID: int64;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_Loja := TZQuery.Create(DComunicador);
    VL_Loja.Connection := DNucleo.ZConexao;
    VL_Tabela := TRxMemoryData.Create(nil);
    VL_Tag := '';
    VL_ID := 0;
    VL_Erro := 0;
    VL_Linha := '';
    try
        try
            //verifica permissão
            if ((TTConexao(VP_AContext.Data).Permissao = pmU) or (TTConexao(VP_AContext.Data).Permissao = pmS)) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('003F', 'R');
                VL_Mensagem.AddTag('004D', '45'); //sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '050520221219';
                GravaLog(F_ArquivoLog, 0, '003F', 'cadastro', VL_Linha, 'sem permissão para gerenciar a alteração de dados da tabela loja', '', VL_Erro);
                Exit;
            end;
            VP_Mensagem.GetTag('003E', VL_Tag); //carrega tabela loja
            if LENGTH(VL_Tag) = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('003F', 'R');
                VL_Mensagem.AddTag('004D', '47');  //sem DADOS
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '300520221123';
                GravaLog(F_ArquivoLog, 0, '003F', 'cadastro', VL_Linha, 'Parametro informado na tag:003E esta em branco ou nula', '', VL_Erro);
                Exit;
            end;
            StrToRxMemData(VL_Tag, VL_Tabela);
            VL_Tabela.Open;

            VP_Mensagem.GetTag('003C', VL_ID); //loja_id
            if VL_ID < 1 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0026', '47');//dados informado não pode ser zero
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '050520221222';
                GravaLog(F_ArquivoLog, 0, '003F', 'cadastro', VL_Linha, 'alteração não executada, o id informado da loja não pode ser zero', '', VL_Erro);
                Exit;
            end;
            //verifica se existe o registro para alterar
            VL_Loja.Close;
            VL_Loja.SQL.Text := 'SELECT * FROM LOJA WHERE ID=' + IntToStr(VL_ID);
            VL_Erro := 55;
            VL_Linha := '300520221125';
            VL_Loja.Open;

            if VL_Loja.RecordCount = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('003F', 'R');
                VL_Mensagem.AddTag('004D', '48'); //registro não localizado
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 48;
                VL_Linha := '050520221228';
                GravaLog(F_ArquivoLog, 0, '003F', 'cadastro', VL_Linha, 'o registro numero:' + IntToStr(VL_ID) +
                    ' informado não foi encontrado na tabela loja',
                    '', VL_Erro);
                Exit;
            end;
            //LOCALIZA ID PARA ALTERAR
            if VL_Tabela.Locate('ID', VL_ID, []) then
            begin
                if ((VL_Tabela.FieldByName('ID').AsInteger <> VL_Loja.FieldByName('ID').AsInteger) or
                    ((VL_Tabela.FieldByName('DOC').AsString <> VL_Loja.FieldByName('DOC').AsString) and
                    (VL_Loja.FieldByName('DOC').AsString <> ''))) then
                begin
                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('003F', 'R');
                    VL_Mensagem.AddTag('004D', '49'); //dados chaves não podem sofer alteração
                    DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                    VL_Erro := 49;
                    VL_Linha := '050520221230';
                    GravaLog(F_ArquivoLog, 0, '003F', 'cadastro', VL_Linha,
                        'dados chaves não podem sofer alteração(id/doc) na tabela loja não pode alterar',
                        '', VL_Erro);
                    Exit;
                end;
                VL_Loja.Close;
                VL_Loja.SQL.Text := 'UPDATE LOJA SET ' + 'DOC=''' + VL_Tabela.FieldByName('DOC').AsString + ''',' +
                    'RAZAO=''' + VL_Tabela.FieldByName('RAZAO').AsString + ''',' +
                    'MULTILOJA_ID=''' + IntToStr(VL_Tabela.FieldByName('MULTILOJA_ID').AsInteger) + ''',' + 'FANTASIA=''' +
                    VL_Tabela.FieldByName('FANTASIA').AsString + ''',' + 'HABILITADO=''' +
                    VL_Tabela.FieldByName('HABILITADO').AsString + ''' WHERE ' + 'ID=' + IntToStr(VL_ID);
                VL_Erro := 46;
                VL_Linha := '300520221127';
                VL_Loja.ExecSQL;

                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('003F', 'R');//retorno do comando
                VL_Mensagem.AddTag('004D', '0');
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
            end;
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('003F', 'R');//retorno do comando
            VL_Mensagem.AddTag('004D', '46');
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '003F', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '003F', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_Tabela.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '003F', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando0044(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //INCLUIR PDV
var
    VL_Mensagem: TMensagem;
    VL_Tabela: TRxMemoryData;
    VL_TPdv: TZQuery;
    VL_Tag: ansistring;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_Tabela := TRxMemoryData.Create(nil);
    VL_TPdv := TZQuery.Create(DComunicador);
    VL_TPdv.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Linha := '';
    VL_Erro := 0;
    try
        try
            //verifica permissao
            if ((TTConexao(VP_AContext.Data).Permissao = pmU) or (TTConexao(VP_AContext.Data).Permissao = pmS)) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0044', 'R');
                VL_Mensagem.AddTag('004D', '45'); //SEM PERMISSAO
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '040520221539';
                GravaLog(F_ArquivoLog, 0, '0044', 'cadastro', VL_Linha, 'sem permissao para incluir registro na tabela PDV', '', VL_Erro);
                Exit;
            end;
            //VERIFICA PARAMETROS
            VP_Mensagem.GetTag('008E', VL_Tag); //tabela pdv
            if Length(VL_Tag) = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0044', 'R');
                VL_Mensagem.AddTag('004D', '47');  //sem dados
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '300520221134';
                GravaLog(F_ArquivoLog, 0, '0044', 'cadastro', VL_Linha, 'Parametro informado na tag:008E esta em branco ou nula', '', VL_Erro);
                Exit;
            end;
            StrToRxMemData(VL_Tag, VL_Tabela);
            VL_Tabela.Open;

            VL_Tabela.First;
            while not VL_Tabela.EOF do
            begin
                if VL_Tabela.FieldByName('ID').AsInteger = 0 then
                begin
                    //verifica se o pdv ja foi cadastrado
                    VL_TPdv.Close;
                    VL_TPdv.SQL.Text := 'SELECT FIRST 1 ID FROM PDV WHERE DESCRICAO=''' + VL_Tabela.FieldByName('DESCRICAO').AsString + ''' AND ' +
                        'LOJA_ID=' + IntToStr(VL_Tabela.FieldByName('LOJA_ID').AsInteger) + ' AND CHAVE=''' + VL_Tabela.FieldByName('CHAVE').AsString + '''';
                    VL_Erro := 55;
                    VL_Linha := '300520221135';
                    VL_TPdv.Open;

                    if VL_TPdv.RecordCount > 0 then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('0044', 'R');
                        VL_Mensagem.Addtag('004D', '43');//registro em duplicidade
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        VL_Erro := 43;
                        VL_Linha := '040520221541';
                        GravaLog(F_ArquivoLog, 0, '0044', 'cadastro', VL_Linha, 'registro em duplicidade na tabela PDV (chave ja cadastrada)', '', VL_Erro);
                        Exit;
                    end;

                    VL_TPdv.Close;
                    VL_TPdv.SQL.Text := 'INSERT INTO PDV(LOJA_ID,DESCRICAO,IP,PINPAD_ID,PINPAD_COM,HABILITADO,CHAVE)VALUES(''' + VL_Tabela.FieldByName(
                        'LOJA_ID').AsString + ''',''' + VL_Tabela.FieldByName('DESCRICAO').AsString + ''',''' +
                        VL_Tabela.FieldByName('IP').AsString + ''',''' +
                        IntToStr(VL_Tabela.FieldByName('PINPAD_ID').AsInteger) + ',''' +
                        VL_Tabela.FieldByName('PINPAD_COM').AsString + ''',''' +
                        VL_Tabela.FieldByName('HABILITADO').AsString + ''',''' +
                        VL_Tabela.FieldByName('CHAVE').AsString + ''')';
                    VL_Erro := 44;
                    VL_Linha := '300520221136';
                    VL_TPdv.ExecSQL;

                    VL_TPdv.Close;
                    VL_TPdv.SQL.Text := 'SELECT FIRST 1 ID FROM PDV WHERE DESCRICAO=''' + VL_Tabela.FieldByName('DESCRICAO').AsString + ''' AND ' +
                        'LOJA_ID=' + IntToStr(VL_Tabela.FieldByName('LOJA_ID').AsInteger) + ' AND CHAVE=''' + VL_Tabela.FieldByName('CHAVE').AsString + '''';
                    VL_Erro := 55;
                    VL_Linha := '060620221653';
                    VL_TPdv.Open;

                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('0044', 'R');
                    VL_Mensagem.AddTag('004D', '0');
                    VL_Mensagem.AddTag('0043', VL_TPdv.FieldByName('ID').AsString);
                    DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                    exit;
                end;
                VL_Tabela.Next;
            end;
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('0044', 'R');
            VL_Mensagem.AddTag('004D', '44');
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                        DNucleo.FreeOnRelease;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '0044', 'cadastro', VL_Linha, 'erro inesperado na classe:' + e.ClassName +
                            '/ mensagem:' + e.Message, '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '0044', 'cadastro', VL_Linha, 'erro inesperado na classe:' + e.ClassName + '/ mensagem:' + e.Message, '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_Tabela.Free;
            VL_TPdv.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                    DNucleo.FreeOnRelease;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '0044', 'cadastro', VL_Linha, 'erro inesperado na classe:' + e.ClassName + '/ mensagem:' +
                        e.Message, '', VL_Erro);
            end;
        end;
    end;
end;

function comando0045(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //VALIDA CHAVE NO PDV
var
    VL_Mensagem: TMensagem;
    VL_TPdv: TZQuery;
    VL_Tag: ansistring;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TPdv := TZQuery.Create(DComunicador);
    VL_TPdv.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Linha := '';
    VL_Erro := 0;
    try
        try
            //verifica permissao
            if ((TTConexao(VP_AContext.Data).Permissao = pmU) or (TTConexao(VP_AContext.Data).Permissao = pmS)) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0045', 'R');
                VL_Mensagem.AddTag('004D', '45'); //SEM PERMISSAO
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '060620221704';
                GravaLog(F_ArquivoLog, 0, '0045', 'cadastro', VL_Linha, 'sem permissao para incluir chave no PDV', '', VL_Erro);
                Exit;
            end;
            //VERIFICA PARAMETROS
            VP_Mensagem.GetTag('003B', VL_Tag); //chave pdv
            if Length(VL_Tag) = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0045', 'R');
                VL_Mensagem.AddTag('004D', '47');  //sem dados
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '060620221706';
                GravaLog(F_ArquivoLog, 0, '0045', 'cadastro', VL_Linha, 'Parametro informado na tag:003B esta em branco ou nula', '', VL_Erro);
                Exit;
            end;
            VL_TPdv.Close;
            VL_TPdv.SQL.Text := 'SELECT FIRST 1 ID FROM PDV WHERE CHAVE=''' + VL_Tag + '''';
            VL_Erro := 55;
            VL_Linha := '060620221707';
            VL_TPdv.Open;
            if VL_TPdv.RecordCount > 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0045', 'R');
                VL_Mensagem.AddTag('004D', '43');
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 43;
                VL_Linha := '060620221708';
                GravaLog(F_ArquivoLog, 0, '0045', 'cadastro', VL_Linha, 'Registro em duplicidade, a chave ja esta cadastrada para o pdv', '', VL_Erro);
                Exit;
            end;
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('0045', 'R');
            VL_Mensagem.AddTag('004D', '0');
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                        DNucleo.FreeOnRelease;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '0045', 'cadastro', VL_Linha, 'erro inesperado na classe:' + e.ClassName +
                            '/ mensagem:' + e.Message, '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '0045', 'cadastro', VL_Linha, 'erro inesperado na classe:' + e.ClassName + '/ mensagem:' + e.Message, '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                    DNucleo.FreeOnRelease;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '0045', 'cadastro', VL_Linha, 'erro inesperado na classe:' + e.ClassName +
                        '/ mensagem:' + e.Message, '', VL_Erro);
            end;
        end;
    end;
end;

function comando004B(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; // ALTERAR PDV
var
    VL_Mensagem: TMensagem;
    VL_Tabela: TRxMemoryData;
    VL_TPdv: TZQuery;
    VL_Tag: ansistring;
    VL_ID: int64;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_Tabela := TRxMemoryData.Create(nil);
    VL_TPdv := TZQuery.Create(DComunicador);
    VL_TPdv.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_ID := 0;
    VL_Erro := 0;
    VL_Linha := '';
    try
        try
            //verifica permissao
            if ((TTConexao(VP_AContext.Data).Permissao = pmU) or (TTConexao(VP_AContext.Data).Permissao = pmS)) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('004B', 'R');
                VL_Mensagem.Addtag('004D', '45');//sem permissão
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '050520221600';
                GravaLog(F_ArquivoLog, 0, '004B', 'cadastro', VL_Linha, ' sem permissão para gerenciar alteração na tabela pdv', '', VL_Erro);
                Exit;
            end;
            //verifica parametros
            VP_Mensagem.GetTag('0043', VL_ID);// pdv id
            if VL_ID = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('004B', 'R');
                VL_Mensagem.AddTag('004D', '47');//campo zerado
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '050520221556';
                GravaLog(F_ArquivoLog, 0, '004B', 'cadastro', VL_Linha, 'id informado para alteração na tabela pdv não pode ser zero', '', VL_Erro);
                Exit;
            end;
            VP_Mensagem.GetTag('008E', VL_Tag); //tabela pdv
            if LENGTH(VL_Tag) = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('004B', 'R');
                VL_Mensagem.Addtag('004D', '47');  //sem DADOS
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '300520221142';
                GravaLog(F_ArquivoLog, 0, '004B', 'cadastro', VL_Linha, 'Parametro informado na tag:008E esta em branco ou nula', '', VL_Erro);
                Exit;
            end;
            StrToRxMemData(VL_Tag, VL_Tabela);
            VL_Tabela.Open;

            //verifica se existe o id pra amodificação
            VL_TPdv.Close;
            VL_TPdv.SQL.Text := 'SELECT * FROM PDV WHERE ID=' + IntToStr(VL_ID);
            VL_Erro := 55;
            VL_Linha := '300520221143';
            VL_TPdv.Open;
            //VERIFICA SE EXISTE DADOS NA TABELA
            if VL_TPdv.RecordCount = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('004B', 'R');
                VL_Mensagem.Addtag('004D', '48');//registro não encontrado
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 48;
                VL_Linha := '050520221601';
                GravaLog(F_ArquivoLog, 0, '004B', 'cadastro', VL_Linha, 'registro não encontrado para alteração na tabela pdv com este parametro',
                    '', VL_Erro);
                Exit;
            end;
            //COMEÇA A ALTERAÇÃO
            if VL_Tabela.Locate('ID', VL_ID, []) then
            begin
                if ((VL_Tabela.FieldByName('ID').AsInteger <> VL_TPdv.FieldByName('ID').AsInteger) or
                    ((VL_Tabela.FieldByName('CHAVE').AsString <> VL_TPdv.FieldByName('CHAVE').AsString) and
                    (VL_TPdv.FieldByName('CHAVE').AsString <> ''))) then
                begin
                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('004B', 'R');
                    VL_Mensagem.AddTag('004D', '49');//campos chaves
                    DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                    VL_Erro := 49;
                    VL_Linha := '050520221604';
                    GravaLog(F_ArquivoLog, 0, '004B', 'cadastro', VL_Linha, 'campos chave (id/chave) não podem sofrer alteração na tabela pdv',
                        '', VL_Erro);
                    Exit;
                end;
                //ALTERA
                VL_TPdv.Close;
                VL_TPdv.SQL.Text := 'UPDATE PDV SET ' + 'LOJA_ID=''' + VL_Tabela.FieldByName('LOJA_ID').AsString + ''',' +
                    'DESCRICAO=''' + VL_Tabela.FieldByName('DESCRICAO').AsString + ''',' +
                    'IP=''' + VL_Tabela.FieldByName('IP').AsString + ''',' +
                    'PINPAD_ID=''' + VL_Tabela.FieldByName('PINPAD_ID').AsString + ''',' +
                    'PINPAD_COM=''' + VL_Tabela.FieldByName('PINPAD_COM').AsString + ''',' +
                    'HABILITADO=''' + VL_Tabela.FieldByName('HABILITADO').AsString + ''',' +
                    'CHAVE=''' + VL_Tabela.FieldByName('CHAVE').AsString + ''' WHERE ' + 'ID=' + IntToStr(VL_ID);
                VL_Erro := 46;
                VL_Linha := '300520221144';
                VL_TPdv.ExecSQL;

                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('004B', 'R');
                VL_Mensagem.AddTag('004D', '0');
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                Exit;
            end
            else
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('004B', 'R');
                VL_Mensagem.AddTag('004D', '46');
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
            end;
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '004B', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '004B', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_Tabela.Free;
            VL_TPdv.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '004B', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando0052(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; // CADASTRO TAG INCLUIR
var
    VL_Mensagem: TMensagem;
    VL_Tabela: TRxMemoryData;
    VL_TTag: TZQuery;
    VL_Tag: ansistring;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_Tabela := TRxMemoryData.Create(nil);
    VL_TTag := TZQuery.Create(DComunicador);
    VL_TTag.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Linha := '';
    VL_Erro := 0;
    try
        try
            //verifica permissao
            if (TTConexao(VP_AContext.Data).Permissao <> pmC) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0052', 'R');
                VL_Mensagem.AddTag('004D', '45');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '270520221617';
                GravaLog(F_ArquivoLog, 0, '0052', 'CADASTRO', VL_Linha, 'sem permissao para incluir registro na tabela Tag', '', VL_Erro);
                Exit;
            end;
            //CARREGA TABELA
            VP_Mensagem.GetTag('0081', VL_Tag);
            if Length(VL_Tag) = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0052', 'R');
                VL_Mensagem.AddTag('004D', '47');//DADOS INFORMADOS VAZIO
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '270520221618';
                GravaLog(F_ArquivoLog, 0, '0052', 'CADASTRO', VL_Linha, 'parametro informado na Tag:0081 esta vazia ou zerada', '', VL_Erro);
                Exit;
            end;
            StrToRxMemData(VL_Tag, VL_Tabela);
            VL_Tabela.Open;

            VL_Tabela.First;
            while not VL_Tabela.EOF do
            begin
                if VL_Tabela.FieldByName('ID').AsInteger = 0 then
                begin
                    //valida campos necessários
                    if ((VL_Tabela.FieldByName('TAG_NUMERO').AsString = '') or
                        (VL_Tabela.FieldByName('TAG_TIPO').AsString = '') or
                        (VL_Tabela.FieldByName('DEFINICAO').AsString = '') or
                        (VL_Tabela.FieldByName('TIPO_DADOS').AsString = '')) then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('0052', 'R');
                        VL_Mensagem.AddTag('004D', '52');//DADOS INFORMADOS VAZIO
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        VL_Erro := 52;
                        VL_Linha := '270520221619';
                        GravaLog(F_ArquivoLog, 0, '0052', 'CADASTRO', VL_Linha, 'campos obrigatórios vazio(tag_numero/tag_tipo/definicao/tipo_dados) na ' +
                            'tabela Tag', '', VL_Erro);
                        Exit;
                    end;
                    //verifica tamanho da tag_numero
                    if length(VL_Tabela.FieldByName('TAG_NUMERO').AsString) <> 4 then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('0052', 'R');
                        VL_Mensagem.AddTag('004D', '28');//parametros nulo ou diferente da estrutura da tag
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        VL_Erro := 28;
                        VL_Linha := '270520221702';
                        GravaLog(F_ArquivoLog, 0, '0052', 'CADASTRO', VL_Linha, 'Tag_numero nulo ou diferente da estrutura da tag', '', VL_Erro);
                        Exit;
                    end;
                    try
                        VL_Erro := Hex2Dec(VL_Tabela.FieldByName('TAG_NUMERO').AsString);
                    except
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('0052', 'R');
                        VL_Mensagem.AddTag('004D', '88');//Tag não é um numero hexadecimal
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        VL_Erro := 88;
                        VL_Linha := '270520221703';
                        GravaLog(F_ArquivoLog, 0, '0052', 'CADASTRO', VL_Linha, 'Tag_numero não é um valor hexadecimal', '', VL_Erro);
                        Exit;
                    end;

                    //VERIFICA SE EXISTE O TAG_NUMERO CADASTRADO
                    VL_TTag.Close;
                    VL_TTag.SQL.Text := 'SELECT * FROM TAG WHERE TAG_NUMERO=''' + VL_Tabela.FieldByName('TAG_NUMERO').AsString + '''';
                    VL_Erro := 55;
                    VL_Linha := '270520221715';
                    VL_TTag.Open;

                    if VL_TTag.RecordCount > 0 then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('0052', 'R');
                        VL_Mensagem.AddTag('004D', '43');
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        VL_Erro := 43;
                        VL_Linha := '270520221721';
                        GravaLog(F_ArquivoLog, 0, '0052', 'cadastro', VL_Linha, 'ja existe um registro cadastrado com esta tag_numero:' +
                            VL_Tabela.FieldByName('TAG_NUMERO').AsString + ' na tabela de Tag', '', VL_Erro);
                        Exit;
                    end
                    else
                    begin
                        VL_TTag.Close;
                        VL_TTag.SQL.Text := 'INSERT INTO TAG(' +
                            'TAG_NUMERO,' +
                            'TAG_TIPO,' +
                            'DEFINICAO,' +
                            'TIPO_DADOS,' +
                            'PADRAO,' +
                            'OBS,' +
                            'DADOS)VALUES(''' +
                            VL_Tabela.FieldByName('TAG_NUMERO').AsString + ''',''' +
                            VL_Tabela.FieldByName('TAG_TIPO').AsString + ''',''' +
                            VL_Tabela.FieldByName('DEFINICAO').AsString + ''',''' +
                            VL_Tabela.FieldByName('TIPO_DADOS').AsString + ''',''' +
                            VL_Tabela.FieldByName('PADRAO').AsString + ''',''' +
                            VL_Tabela.FieldByName('OBS').AsString + ''',''' +
                            VL_Tabela.FieldByName('DADOS').AsString + ''')';

                        VL_Erro := 44;
                        VL_Linha := '270520221716';
                        VL_TTag.ExecSQL;
                    end;
                    //carrega ID Tag
                    VL_TTag.Close;
                    VL_TTag.SQL.Text := 'SELECT * FROM TAG WHERE TAG_NUMERO=''' + VL_Tabela.FieldByName('TAG_NUMERO').AsString + '''';
                    VL_Erro := 55;
                    VL_Linha := '290720221657';
                    VL_TTag.Open;

                    if VL_TTag.RecordCount = 0 then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('0052', 'R');
                        VL_Mensagem.AddTag('004D', '48'); //registro não localizado
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        VL_Erro := 48;
                        VL_Linha := '290720221700';
                        GravaLog(F_ArquivoLog, 0, '0052', 'cadastro', VL_Linha, 'a Tag numero:' + VL_Tabela.FieldByName('TAG_NUMERO').AsString +
                            ' informado não foi gravada na tabela tag',
                            '', VL_Erro);
                        Exit;
                    end;
                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('0052', 'R');
                    VL_Mensagem.AddTag('004D', '0');
                    VL_Mensagem.AddTag('006E', VL_TTag.FieldByName('ID').AsString);
                    DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                    exit;
                end;
                VL_Tabela.Next;
            end;
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('0052', 'R');
            VL_Mensagem.AddTag('004D', '48');
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '0052', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '0052', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_Tabela.Free;
            VL_TTag.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '0052', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando0053(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //CADASTRO PINPAD INCLUIR
var
    VL_Mensagem: TMensagem;
    VL_Tabela: TRxMemoryData;
    VL_TPinPad: TZQuery;
    VL_Tag: ansistring;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_Tabela := TRxMemoryData.Create(nil);
    VL_TPinPad := TZQuery.Create(DComunicador);
    VL_TPinPad.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Linha := '';
    VL_Erro := 0;
    try
        try
            //verifica permissao
            if ((TTConexao(VP_AContext.Data).Permissao = pmU) or (TTConexao(VP_AContext.Data).Permissao = pmS)) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0053', 'R');
                VL_Mensagem.Addtag('004D', '45');// sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '040520221507';
                GravaLog(F_ArquivoLog, 0, '0053', 'cadastro', VL_Linha, 'sem permissao para incluir registro na tabela PinPad', '', VL_Erro);
                Exit;
            end;
            //VERIFICA PARAMETROS
            VP_Mensagem.GetTag('008D', VL_Tag); // TABELA PINPAD
            if Length(VL_Tag) = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0053', 'R');
                VL_Mensagem.AddTag('004D', '47');//DADOS INFORMADOS VAZIO
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '300520221148';
                GravaLog(F_ArquivoLog, 0, '0053', 'CADASTRO', VL_Linha, 'parametro informado na Tag:008D esta vazia ou zerada', '', VL_Erro);
                Exit;
            end;
            StrToRxMemData(VL_Tag, VL_Tabela);
            VL_Tabela.Open;
            if VL_Tabela.RecordCount = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0053', 'R');
                VL_Mensagem.AddTag('004D', '47');//DADOS INFORMADOS VAZIO
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '300520221208';
                GravaLog(F_ArquivoLog, 0, '0053', 'CADASTRO', VL_Linha, 'parametro informado na Tag:008D esta vazia ou zerada', '', VL_Erro);
                Exit;
            end;

            VL_Tabela.First;
            while not VL_Tabela.EOF do
            begin
                if VL_Tabela.FieldByName('ID').AsInteger = 0 then
                begin
                    VL_TPinPad.Close;
                    VL_TPinPad.SQL.Text := 'INSERT INTO PINPAD(FABRICANTE_MODELO)VALUES(''' + VL_Tabela.FieldByName(
                        'FABRICANTE_MODELO').AsString + ''')';
                    VL_Erro := 44;
                    VL_Linha := '300520221150';
                    VL_TPinPad.ExecSQL;

                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('0053', 'R');
                    VL_Mensagem.AddTag('004D', '0');
                    VL_Mensagem.AddTag('0054', VL_TPinPad.FieldByName('ID').AsString);
                    DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                    exit;
                end;
                VL_Tabela.Next;
            end;
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('0053', 'R');
            VL_Mensagem.AddTag('004D', '44');
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '0053', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '0053', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_Tabela.Free;
            VL_TPinPad.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '0053', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando0055(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //altera pinpad
var
    VL_Mensagem: TMensagem;
    VL_Tabela: TRxMemoryData;
    VL_TPinPad: TZQuery;
    VL_Tag: ansistring;
    VL_ID: int64;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_Tabela := TRxMemoryData.Create(nil);
    VL_TPinPad := TZQuery.Create(DComunicador);
    VL_TPinPad.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_ID := 0;
    VL_Erro := 0;
    VL_Linha := '';
    try
        try
            //verifica permissao
            if ((TTConexao(VP_AContext.Data).Permissao = pmU) or (TTConexao(VP_AContext.Data).Permissao = pmS)) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0055', 'R');
                VL_Mensagem.Addtag('004D', '45');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '050520221434';
                GravaLog(F_ArquivoLog, 0, '0055', 'cadastro', VL_Linha, 'sem permissao para gerenciar alteração na tabela pinpad', '', VL_Erro);
                Exit;
            end;
            //verifica parametros
            VP_Mensagem.GetTag('0054', VL_ID); //pinpad_id
            if VL_ID = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0055', 'R');
                VL_Mensagem.Addtag('004D', '47');//dados zeradoS
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '050520221433';
                GravaLog(F_ArquivoLog, 0, '0055', 'cadastro', VL_Linha, 'id do pinpad não informado para a alteração na tabela pinpad', '', VL_Erro);
                Exit;
            end;
            VP_Mensagem.GetTag('008D', VL_Tag); // TABELA PINPAD
            if Length(VL_Tag) = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0055', 'R');
                VL_Mensagem.AddTag('004D', '47');//DADOS INFORMADOS VAZIO
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '300520221154';
                GravaLog(F_ArquivoLog, 0, '0055', 'CADASTRO', VL_Linha, 'parametro informado na Tag:008D esta vazia ou zerada', '', VL_Erro);
                Exit;
            end;
            StrToRxMemData(VL_Tag, VL_Tabela);
            VL_Tabela.Open;

            //verifica se existe o id pra a modificação
            VL_TPinPad.Close;
            VL_TPinPad.SQL.Text := 'SELECT * FROM PINPAD WHERE ID=' + IntToStr(VL_ID);
            VL_Erro := 55;
            VL_Linha := '300520221155';
            VL_TPinPad.Open;

            if VL_TPinPad.RecordCount = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0055', 'R');
                VL_Mensagem.Addtag('004D', '48');//tabela vazia
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 48;
                VL_Linha := '050520221438';
                GravaLog(F_ArquivoLog, 0, '0055', 'cadastro', VL_Linha, 'id informado não foi localizado na tabela pinpad para a alteração', '', VL_Erro);
                Exit;
            end;

            if VL_Tabela.Locate('ID', VL_ID, []) then
            begin
                if (VL_Tabela.FieldByName('ID').AsInteger <> VL_TPinPad.FieldByName('ID').AsInteger) then
                begin
                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('0055', 'R');
                    VL_Mensagem.Addtag('004D', '49');//dados chaves não podem sofer alteração
                    DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                    VL_Erro := 49;
                    VL_Linha := '050520221440';
                    GravaLog(F_ArquivoLog, 0, '0055', 'cadastro', VL_Linha, 'dados chave não podem ser modificados (id) na tabela pinpad', '', VL_Erro);
                    Exit;
                end;

                VL_TPinPad.Close;
                VL_TPinPad.SQL.Text := 'UPDATE PINPAD SET ' + 'FABRICANTE_MODELO=''' + VL_Tabela.FieldByName(
                    'FABRICANTE_MODELO').AsString + '''' + ' WHERE ' + 'ID=' + IntToStr(VL_ID);
                VL_Erro := 46;
                VL_Linha := '300520221156';
                VL_TPinPad.ExecSQL;

                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0055', 'R'); //aceito
                VL_Mensagem.AddTag('004D', '0'); //aceito
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                Exit;
            end;
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('0055', 'R');
            VL_Mensagem.AddTag('004D', '46');
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '0055', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '0055', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_Tabela.Free;
            VL_TPinPad.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '0055', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando0057(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //INCLUI CONFIGURADOR
var
    VL_Mensagem: TMensagem;
    VL_Tabela: TRxMemoryData;
    VL_TConfigurador: TZQuery;
    VL_Tag: ansistring;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_Tabela := TRxMemoryData.Create(nil);
    VL_TConfigurador := TZQuery.Create(DComunicador);
    VL_TConfigurador.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Linha := '';
    VL_Erro := 0;
    try
        try
            //verifica permissao
            if TTConexao(VP_AContext.Data).Permissao <> pmC then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0057', 'R');
                VL_Mensagem.Addtag('004D', '45'); //SEM PERMISSAO DE INCLUSAO
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '040520221554';
                GravaLog(F_ArquivoLog, 0, '0057', 'cadastro', VL_Linha, 'sem permissao para incluir registro na tabela configurador', '', VL_Erro);
                Exit;
            end;
            //VERIFICA PARAMENTROS
            VP_Mensagem.GetTag('008F', VL_Tag); // tabela configurador
            if Length(VL_Tag) < 1 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0057', 'R');
                VL_Mensagem.AddTag('004D', '47');//DADOS INFORMADOS VAZIO
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '300520221159';
                GravaLog(F_ArquivoLog, 0, '0057', 'CADASTRO', VL_Linha, 'parametro informado na Tag:008F esta vazia ou zerada', '', VL_Erro);
                Exit;
            end;
            StrToRxMemData(VL_Tag, VL_Tabela);
            VL_Tabela.Open;

            VL_Tabela.First;
            while not VL_Tabela.EOF do
            begin
                if VL_Tabela.FieldByName('ID').AsInteger = 0 then
                begin
                    //verifica se o configurador ja foi cadastrado
                    VL_TConfigurador.Close;
                    VL_TConfigurador.SQL.Text := 'SELECT FIRST 1 ID FROM CONFIGURADOR WHERE CHAVE=''' +
                        VL_Tabela.FieldByName('CHAVE').AsString + '''';
                    VL_Erro := 55;
                    VL_Linha := '300520221210';
                    VL_TConfigurador.Open;

                    if VL_TConfigurador.RecordCount > 0 then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('0057', 'R');
                        VL_Mensagem.Addtag('004D', '43');//duplicidade no registro
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        VL_Erro := 43;
                        VL_Linha := '040520221556';
                        GravaLog(F_ArquivoLog, 0, '0057', 'cadastro', VL_Linha, 'registro em duplicidade na tabela configurador(chave ja cadastrada)',
                            '', VL_Erro);
                        Exit;
                    end;
                    //TESTA CAMPOS OBRIGATORIOS
                    if ((length(VL_Tabela.FieldByName('DESCRICAO').AsString) = 0) or
                        ((length(VL_Tabela.FieldByName('SENHA_ADMINISTRADOR').AsString) = 0) and
                        (length(VL_Tabela.FieldByName('SENHA_CONFIGURADOR').AsString) = 0) and
                        (length(VL_Tabela.FieldByName('SENHA_USUARIO').AsString) = 0))) then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('0057', 'R');
                        VL_Mensagem.Addtag('004D', '52');//campos obrigatorios
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        VL_Erro := 52;
                        VL_Linha := '040520221557';
                        GravaLog(F_ArquivoLog, 0, '0057', 'cadastro', VL_Linha, 'campos obrigatórios não podem estar zerado ou nulo na tabela configurador',
                            '', VL_Erro);
                        Exit;
                    end;
                    //COMEÇA A INCLUSÃO
                    VL_TConfigurador.Close;
                    VL_TConfigurador.SQL.Text := 'INSERT INTO CONFIGURADOR(DESCRICAO,IP,CHAVE,SENHA_CONFIGURADOR,' +
                        'SENHA_ADMINISTRADOR,SENHA_USUARIO)VALUES(''' + VL_Tabela.FieldByName('DESCRICAO').AsString +
                        ''',''' + VL_Tabela.FieldByName('IP').AsString + ''',''' + VL_Tabela.FieldByName('CHAVE').AsString +
                        ''',''' + VL_Tabela.FieldByName('SENHA_CONFIGURADOR').AsString + ''',''' +
                        VL_Tabela.FieldByName('SENHA_ADMINISTRADOR').AsString + ''',''' + VL_Tabela.FieldByName(
                        'SENHA_USUARIO').AsString + ''')';
                    VL_Erro := 44;
                    VL_Linha := '030620221039';
                    VL_TConfigurador.ExecSQL;

                    VL_TConfigurador.Close;
                    VL_TConfigurador.SQL.Text := 'SELECT * FROM CONFIGURADOR WHERE CHAVE=''' + VL_Tabela.FieldByName('CHAVE').AsString + '''';
                    VL_Erro := 55;
                    VL_Linha := '030620221040';
                    VL_TConfigurador.Open;

                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('0057', 'R');
                    VL_Mensagem.AddTag('004D', '0');
                    VL_Mensagem.AddTag('0056', VL_TConfigurador.FieldByName('ID').AsString);
                    DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                    exit;
                end;
                VL_Tabela.Next;
            end;
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('0057', 'R');
            VL_Mensagem.AddTag('004D', '44');
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '0057', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '0057', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_Tabela.Free;
            VL_TConfigurador.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '0057', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando0058(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;  //alterar configurador
var
    VL_Mensagem: TMensagem;
    VL_Tabela: TRxMemoryData;
    VL_TConfigurador: TZQuery;
    VL_Tag: ansistring;
    VL_ID: int64;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_Tabela := TRxMemoryData.Create(nil);
    VL_TConfigurador := TZQuery.Create(DComunicador);
    VL_TConfigurador.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_ID := 0;
    VL_Erro := 0;
    VL_Linha := '';
    try
        try
            //verifica permissao
            if TTConexao(VP_AContext.Data).Permissao <> pmC then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0058', 'R');
                VL_Mensagem.AddTag('004D', '45');//sem permissão
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '050520221629';
                GravaLog(F_ArquivoLog, 0, '0058', 'cadastro', VL_Linha, 'sem permissão para gerenciar alteração na tabela configurador', '', VL_Erro);
                Exit;
            end;
            //verifica parametros
            VP_Mensagem.GetTag('0056', VL_ID); //configurador_id
            if VL_ID = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0058', 'R');
                VL_Mensagem.AddTag('004D', '47');//campo zerado
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '050520221624';
                GravaLog(F_ArquivoLog, 0, '0058', 'cadastro', VL_Linha, 'para alterar a tabela configurador o id informado não pode ser zero', '', VL_Erro);
                Exit;
            end;
            VP_Mensagem.GetTag('008F', VL_Tag); //tabela configurador

            if Length(VL_Tag) = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0058', 'R');
                VL_Mensagem.AddTag('004D', '47');//campo zerado
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '030620221052';
                GravaLog(F_ArquivoLog, 0, '0058', 'cadastro', VL_Linha, 'o parametro informado na Tag:008F esta nulo ou zerado', '', VL_Erro);
                Exit;
            end;
            StrToRxMemData(VL_Tag, VL_Tabela);
            VL_Tabela.Open;

            //verifica se existe o id pra modificação
            VL_TConfigurador.Close;
            VL_TConfigurador.SQL.Text := 'SELECT * FROM CONFIGURADOR WHERE ID=' + IntToStr(VL_ID);
            VL_Erro := 55;
            VL_Linha := '030620221053';
            VL_TConfigurador.Open;

            if VL_TConfigurador.RecordCount = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0058', 'R');
                VL_Mensagem.AddTag('004D', '48');//registro não localizado
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 48;
                VL_Linha := '050520221631';
                GravaLog(F_ArquivoLog, 0, '0058', 'cadastro', VL_Linha, 'registro não localizado para alteração na tabela configurador', '', VL_Erro);
                Exit;
            end;
            if VL_Tabela.Locate('ID', VL_ID, []) then
            begin
                if ((VL_Tabela.FieldByName('ID').AsInteger <> VL_TConfigurador.FieldByName('ID').AsInteger) or
                    ((VL_Tabela.FieldByName('CHAVE').AsString <> VL_TConfigurador.FieldByName('CHAVE').AsString) and
                    (VL_TConfigurador.FieldByName('CHAVE').AsString <> ''))) then
                begin
                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('0058', 'R');
                    VL_Mensagem.AddTag('004D', '49');//campo não pode sofrer alteração
                    DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                    VL_Erro := 49;
                    VL_Linha := '050520221632';
                    GravaLog(F_ArquivoLog, 0, '0058', 'cadastro', VL_Linha,
                        'campos chaves (id/chave) no cadastro não podem ser alterado na tabel configurador',
                        '', VL_Erro);
                    Exit;
                end;
                //COMEÇA A ALTERAÇÃO
                VL_TConfigurador.Close;
                VL_TConfigurador.SQL.Text := 'UPDATE CONFIGURADOR SET ' + 'DESCRICAO=''' + VL_Tabela.FieldByName(
                    'DESCRICAO').AsString + ''',' + 'IP=''' + VL_Tabela.FieldByName('IP').AsString + ''',' + 'CHAVE=''' +
                    VL_Tabela.FieldByName('CHAVE').AsString + ''',' + 'SENHA_CONFIGURADOR=''' + VL_Tabela.FieldByName('SENHA_CONFIGURADOR').AsString +
                    ''',' + 'SENHA_ADMINISTRADOR=''' + VL_Tabela.FieldByName('SENHA_ADMINISTRADOR').AsString + ''',' +
                    'SENHA_USUARIO=''' + VL_Tabela.FieldByName('SENHA_USUARIO').AsString + ''' WHERE ' + 'ID=' + IntToStr(VL_ID);
                VL_Erro := 46;
                VL_Linha := '030620221056';
                VL_TConfigurador.ExecSQL;

                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0058', 'R');
                VL_Mensagem.AddTag('004D', '0');
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                Exit;
            end
            else
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0058', 'R');
                VL_Mensagem.AddTag('004D', '46');
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
            end;
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '0058', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '0058', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_Tabela.Free;
            VL_TConfigurador.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '0058', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando0059(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;
var
    VL_Mensagem: TMensagem;
    VL_TConfigurador: TZQuery;
    VL_Tag: ansistring;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TConfigurador := TZQuery.Create(DComunicador);
    VL_TConfigurador.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Erro := 0;
    VL_Linha := '';
    try
        try
            //verifica permissao
            if ((TTConexao(VP_AContext.Data).Permissao = pmU) or (TTConexao(VP_AContext.Data).Permissao = pmS)) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0059', 'R');
                VL_Mensagem.AddTag('004D', '45'); //SEM PERMISSAO
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '060620221725';
                GravaLog(F_ArquivoLog, 0, '0059', 'cadastro', VL_Linha, 'sem permissao para incluir chave no Concentrador', '', VL_Erro);
                Exit;
            end;
            //VERIFICA PARAMETROS
            VP_Mensagem.GetTag('003D', VL_Tag); //chave concentrador
            if Length(VL_Tag) = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0059', 'R');
                VL_Mensagem.AddTag('004D', '47');  //sem dados
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '060620221726';
                GravaLog(F_ArquivoLog, 0, '0059', 'cadastro', VL_Linha, 'Parametro informado na tag:003D esta em branco ou nula', '', VL_Erro);
                Exit;
            end;
            VL_TConfigurador.Close;
            VL_TConfigurador.SQL.Text := 'SELECT FIRST 1 ID FROM CONFIGURADOR WHERE CHAVE=''' + VL_Tag + '''';
            VL_Erro := 55;
            VL_Linha := '060620221727';
            VL_TConfigurador.Open;

            if VL_TConfigurador.RecordCount > 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0059', 'R');
                VL_Mensagem.AddTag('004D', '43');  //duplicidade
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '060620221729';
                GravaLog(F_ArquivoLog, 0, '0059', 'cadastro', VL_Linha, 'chave informada para cadastro no concentrador ja existe', '', VL_Erro);
                Exit;
            end;
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('0059', 'R');
            VL_Mensagem.AddTag('004D', '0');
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                        DNucleo.FreeOnRelease;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '0059', 'cadastro', VL_Linha, 'erro inesperado na classe:' +
                            e.ClassName + '/ mensagem:' + e.Message, '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '0059', 'cadastro', VL_Linha, 'erro inesperado na classe:' + e.ClassName + '/ mensagem:' + e.Message, '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                    DNucleo.FreeOnRelease;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '0059', 'cadastro', VL_Linha, 'erro inesperado na classe:' + e.ClassName + '/ mensagem:' +
                        e.Message, '', VL_Erro);
            end;
        end;
    end;
end;

function comando0064(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;   //incluir mult-loja
var
    VL_Mensagem: TMensagem;
    VL_Tabela: TRxMemoryData;
    VL_TMultLoja: TZQuery;
    VL_Tag: ansistring;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_Tabela := TRxMemoryData.Create(nil);
    VL_TMultLoja := TZQuery.Create(DComunicador);
    VL_TMultLoja.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    try
        try
            //verifica permissao
            if ((TTConexao(VP_AContext.Data).Permissao = pmU) or (TTConexao(VP_AContext.Data).Permissao = pmS)) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0064', 'R');
                VL_Mensagem.AddTag('004D', '45');  //permissao não autorizada;
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '040520220950';
                GravaLog(F_ArquivoLog, 0, '0064', 'cadastro', VL_Linha, 'nao tem permissao para dar manutencao ao cadastro de mult-loja', '', VL_Erro);
                Exit;
            end;
            //VERIFICA PARAMETROS
            VP_Mensagem.GetTag('0080', VL_Tag); //tabela mult-loja
            if LENGTH(VL_Tag) = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0064', 'R');
                VL_Mensagem.AddTag('004D', '47');//DADOS INFORMADO ZERADO
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '020620220813';
                GravaLog(F_ArquivoLog, 0, '0064', 'cadastro', VL_Linha, 'parametro informado na Tag:0080 não pode ser nulo ou zerado', '', VL_Erro);
                Exit;
            end;
            StrToRxMemData(VL_Tag, VL_Tabela);
            VL_Tabela.Open;
            VL_Tabela.First;
            while not VL_Tabela.EOF do
            begin
                if VL_Tabela.FieldByName('ID').AsInteger = 0 then
                begin
                    //verifica se a loja ja esta cadastrada como multiloja
                    VL_TMultLoja.Close;
                    VL_TMultLoja.SQL.Text := 'SELECT * FROM MULTILOJA WHERE LOJA_ID=''' + VL_Tabela.FieldByName('LOJA_ID').AsString + '''';
                    VL_Erro := 55;
                    VL_Linha := '020620220814';
                    VL_TMultLoja.Open;

                    if VL_TMultLoja.RecordCount > 0 then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('0026', '43');//REGISTRO EM DUPLICIDADE
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        VL_Erro := 43;
                        VL_Linha := '020520220822';
                        GravaLog(F_ArquivoLog, 0, '0064', 'cadastro', VL_Linha, 'a loja informada com o codigo:' + VL_Tabela.FieldByName('LOJA_ID').AsString +
                            ' ja esta cadastrada na tabela multiloja', '', VL_Erro);
                        Exit;
                    end;
                    //começa a inclusão
                    VL_TMultLoja.Close;
                    VL_TMultLoja.SQL.Text := 'INSERT INTO MULTILOJA(LOJA_ID,HABILITADO)VALUES' +
                        '(''' + VL_Tabela.FieldByName('LOJA_ID').AsString + ''',''' +
                        VL_Tabela.FieldByName('HABILITADO').AsString + ''')';
                    VL_Erro := 44;
                    VL_Linha := '020620220825';
                    VL_TMultLoja.ExecSQL;

                    VL_TMultLoja.Close;
                    VL_TMultLoja.SQL.Text := 'SELECT * FROM MULTILOJA WHERE LOJA_ID=''' + VL_Tabela.FieldByName('LOJA_ID').AsString + '''';
                    VL_Erro := 55;
                    VL_Linha := '020620220826';
                    VL_TMultLoja.Open;

                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('0064', 'R');
                    VL_Mensagem.AddTag('004D', '0');
                    VL_Mensagem.AddTag('0065', VL_TMultLoja.FieldByName('ID').AsInteger);
                    DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                    exit;
                end;
                VL_Tabela.Next;
            end;
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('0064', 'R');
            VL_Mensagem.AddTag('004D', '44');
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                        DNucleo.FreeOnRelease;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '0064', 'cadastro', VL_Linha, 'erro inesperado na classe:' +
                            e.ClassName + '/ mensagem:' + e.Message, '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '0064', 'cadastro', VL_Linha, 'erro inesperado na classe:' + e.ClassName + '/ mensagem:' + e.Message, '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_Tabela.Free;
            VL_TMultLoja.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                    DNucleo.FreeOnRelease;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '0064', 'cadastro', VL_Linha, 'erro inesperado na classe:' + e.ClassName + '/ mensagem:' +
                        e.Message, '', VL_Erro);
            end;
        end;
    end;
end;

function comando0066(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //excluir mult-loja
var
    VL_Mensagem: TMensagem;
    VL_TMultLoja: TZQuery;
    VL_Tag: ansistring;
    VL_ID: int64;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TMultLoja := TZQuery.Create(DComunicador);
    VL_TMultLoja.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_ID := 0;
    VL_Erro := 0;
    VL_Linha := '';
    try
        try
            //verifica parametros
            VP_Mensagem.GetTag('0065', VL_ID);  //ID da multloja
            if VL_ID = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0066', 'R');
                VL_Mensagem.AddTag('004D', '47'); //dados informado não pode ser nulo
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 28;
                VL_Linha := '040520221028';
                GravaLog(F_ArquivoLog, 0, '0066', 'cadastro', VL_Linha, 'ID da mult-loja não pode ser zero  para a exclusão do registro', '', VL_Erro);
                Exit;
            end;
            //verifica permissao
            if ((TTConexao(VP_AContext.Data).Permissao = pmU) or (TTConexao(VP_AContext.Data).Permissao = pmS)) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0066', 'R');
                VL_Mensagem.AddTag('004D', '45'); //permissao não autorizada
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '040520221036';
                GravaLog(F_ArquivoLog, 0, '0066', 'cadastro', VL_Linha, 'não tem permissão para a exclusão do registro na tabela multloja', '', VL_Erro);
                Exit;
            end;
            //verifica se existe o id pra exclusão
            VL_TMultLoja.Close;
            VL_TMultLoja.SQL.Text := 'SELECT * FROM MULTILOJA WHERE ID=' + IntToStr(VL_ID);
            VL_Erro := 55;
            VL_Linha := '020620220842';
            VL_TMultLoja.Open;

            if VL_TMultLoja.RecordCount = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0066', 'R');
                VL_Mensagem.AddTag('004D', '48'); //tabela vazia
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 48;
                VL_Linha := '040520221040';
                GravaLog(F_ArquivoLog, 0, '0066', 'cadastro', VL_Linha, 'o id ' + IntToStr(VL_ID) + ' não foi localizado na tabela multloja para a exclusão',
                    '', VL_Erro);
                Exit;
            end;
            //exclui multloja
            VL_TMultLoja.Close;
            VL_TMultLoja.SQL.Text := 'DELETE FROM MULTILOJA WHERE ' + 'ID=' + IntToStr(VL_ID);
            VL_Erro := 82;
            VL_Linha := '020620220849';
            VL_TMultLoja.ExecSQL;

            //atualiza loja
            VL_TMultLoja.Close;
            VL_TMultLoja.SQL.Text := 'UPDATE LOJA SET MULTILOJA_ID=NULL WHERE MULTILOJA_ID=' + IntToStr(VL_ID);
            VL_Erro := 46;
            VL_Linha := '020620220850';
            VL_TMultLoja.ExecSQL;

            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('0066', 'R');
            VL_Mensagem.AddTag('004D', '0');

            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);

        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                        DNucleo.FreeOnRelease;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '0066', 'cadastro', VL_Linha, 'erro inesperado na classe:' +
                            e.ClassName + '/ mensagem:' + e.Message, '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '0066', 'cadastro', VL_Linha, 'erro inesperado na classe:' + e.ClassName + '/ mensagem:' + e.Message, '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_TMultLoja.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                    DNucleo.FreeOnRelease;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '0066', 'cadastro', VL_Linha, 'erro inesperado na classe:' + e.ClassName +
                        '/ mensagem:' + e.Message, '', VL_Erro);
            end;
        end;
    end;
end;

function comando0067(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //alterar mult-loja
var
    VL_Mensagem: TMensagem;
    VL_MultiLoja: TZQuery;
    VL_Tabela: TRxMemoryData;
    VL_Tag: ansistring;
    VL_ID: int64;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_MultiLoja := TZQuery.Create(DComunicador);
    VL_MultiLoja.Connection := DNucleo.ZConexao;
    VL_Tabela := TRxMemoryData.Create(nil);
    VL_Tag := '';
    VL_ID := 0;
    VL_Erro := 0;
    VL_Linha := '';
    try
        try
            //verifica permissão
            if ((TTConexao(VP_AContext.Data).Permissao = pmU) or (TTConexao(VP_AContext.Data).Permissao = pmS)) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0067', 'R');
                VL_Mensagem.AddTag('004D', '45'); //sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '230520221108';
                GravaLog(F_ArquivoLog, 0, '0067', 'cadastro', VL_Linha, 'sem permissão para gerenciar a alteração de dados da tabela multiloja',
                    '', VL_Erro);
                Exit;
            end;
            //VERIFICA PARAMETROS
            VP_Mensagem.GetTag('0080', VL_Tag); //carrega tabela multiloja
            if Length(VL_TAG) = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0067', 'R');
                VL_Mensagem.AddTag('004D', '47'); //TABELA VAZIA
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '020620220912';
                GravaLog(F_ArquivoLog, 0, '0067', 'cadastro', VL_Linha, 'o parametro informado na Tag:0080 esta nula ou zerada',
                    '', VL_Erro);
                Exit;
            end;
            StrToRxMemData(VL_Tag, VL_Tabela);
            VL_Tabela.Open;

            VP_Mensagem.GetTag('0065', VL_ID); //multiloja_id
            if VL_ID < 1 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0067', 'R');
                VL_Mensagem.AddTag('004D', '47');//dados informado não pode ser zero
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '230520221110';
                GravaLog(F_ArquivoLog, 0, '0067', 'cadastro', VL_Linha, 'alteração não executada, o id informado da multiloja não pode ser zero',
                    '', VL_Erro);
                Exit;
            end;
            //verifica se existe o registro para alterar
            VL_MultiLoja.Close;
            VL_MultiLoja.SQL.Text := 'SELECT * FROM MULTILOJA WHERE ID=' + IntToStr(VL_ID);
            VL_Erro := 55;
            VL_Linha := '020620220915';
            VL_MultiLoja.Open;

            if VL_MultiLoja.RecordCount = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0067', 'R');
                VL_Mensagem.AddTag('004D', '48'); //registro não localizado
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 48;
                VL_Linha := '230520221111';
                GravaLog(F_ArquivoLog, 0, '0067', 'cadastro', VL_Linha, 'o registro numero:' + IntToStr(VL_ID) +
                    ' informado não foi encontrado na tabela multiloja',
                    '', VL_Erro);
                Exit;
            end;

            if VL_Tabela.Locate('ID', VL_ID, []) then
            begin
                if (VL_Tabela.FieldByName('LOJA_ID').AsInteger <> VL_MultiLoja.FieldByName('LOJA_ID').AsInteger) then
                begin
                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('0067', 'R');
                    VL_Mensagem.AddTag('004D', '49'); //dados chaves não podem sofer alteração
                    DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                    VL_Erro := 49;
                    VL_Linha := '230520221112';
                    GravaLog(F_ArquivoLog, 0, '0067', 'cadastro', VL_Linha,
                        'dados chaves não podem sofer alteração(loja_id) na tabela multiloja não pode alterar',
                        '', VL_Erro);
                    Exit;
                end;
                VL_MultiLoja.Close;
                VL_MultiLoja.SQL.Text := 'UPDATE MULTILOJA SET ' + 'HABILITADO=''' + VL_Tabela.FieldByName('HABILITADO').AsString + ''' WHERE ' +
                    'ID=' + IntToStr(VL_ID);
                VL_Erro := 46;
                VL_Linha := '020620220919';
                VL_MultiLoja.ExecSQL;

                VL_MultiLoja.Close;
                VL_MultiLoja.SQL.Text := 'SELECT * FROM MULTILOJA WHERE ID=' + IntToStr(VL_ID);
                VL_Erro := 55;
                VL_Linha := '020620220920';
                VL_MultiLoja.Open;

                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0067', 'R');
                VL_Mensagem.AddTag('004D', '0');
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                Exit;
            end
            else
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0026', '46');//46 erro na alteração do registro
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                Exit;
            end;
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                        DNucleo.FreeOnRelease;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '0067', 'cadastro', VL_Linha, 'erro inesperado na classe:' +
                            e.ClassName + '/ mensagem:' + e.Message, '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '0067', 'cadastro', VL_Linha, 'erro inesperado na classe:' + e.ClassName + '/ mensagem:' + e.Message, '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_Tabela.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                    DNucleo.FreeOnRelease;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '0067', 'cadastro', VL_Linha, 'erro inesperado na classe:' + e.ClassName + '/ mensagem:' +
                        e.Message, '', VL_Erro);
            end;
        end;
    end;
end;

function comando0069(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;  //excluir loja
var
    VL_Mensagem: TMensagem;
    VL_TLoja: TZQuery;
    VL_Tag: ansistring;
    VL_ID: int64;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TLoja := TZQuery.Create(DComunicador);
    VL_TLoja.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_ID := 0;
    VL_Erro := 0;
    VL_Linha := '';
    try
        try
            //verifica parametros
            VP_Mensagem.GetTag('003C', VL_ID);  //id da loja
            if VL_ID = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0069', 'R');
                VL_Mensagem.AddTag('004D', '47');//campo não pode ser zero
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '060520221144';
                GravaLog(F_ArquivoLog, 0, '0069', 'cadastro', VL_Linha, 'campo id para exclusão na tabela loja não pode ser zero', '', VL_Erro);
                Exit;
            end;
            //verifica permissao
            if ((TTConexao(VP_AContext.Data).Permissao = pmU) or (TTConexao(VP_AContext.Data).Permissao = pmS)) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0069', 'R');
                VL_Mensagem.AddTag('004D', '45');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '060520221147';
                GravaLog(F_ArquivoLog, 0, '0069', 'cadastro', VL_Linha, 'sem permissão para gerenciar exclusão na tabela loja', '', VL_Erro);
                Exit;
            end;
            //verifica se existe o id pra exclusão
            VL_TLoja.Close;
            VL_TLoja.SQL.Text := 'SELECT * FROM LOJA WHERE ID=' + IntToStr(VL_ID);
            VL_Erro := 55;
            VL_Linha := '020620221233';
            VL_TLoja.Open;

            if VL_TLoja.RecordCount = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0069', 'R');
                VL_Mensagem.AddTag('004D', '48'); // id não encontrado na tabela
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 48;
                VL_Linha := '060520221148';
                GravaLog(F_ArquivoLog, 0, '0069', 'cadastro', VL_Linha, 'campo informado ID numero:' + IntToStr(VL_ID) +
                    ' para exclusão não foi localizado na tabela loja', '', VL_Erro);
                Exit;
            end;
            //exclui loja
            VL_TLoja.Close;
            VL_TLoja.SQL.Text := 'DELETE FROM LOJA WHERE ' + 'ID=' + IntToStr(VL_ID);
            VL_Erro := 82;
            VL_Linha := '020620221234';
            VL_TLoja.ExecSQL;

            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('0069', 'R');
            VL_Mensagem.AddTag('004D', '0');
            VL_Mensagem.AddTag('003C', VL_ID); // loja_id
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);

        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                        DNucleo.FreeOnRelease;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '0069', 'cadastro', VL_Linha, 'erro inesperado na classe:' +
                            e.ClassName + '/ mensagem:' + e.Message, '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '0069', 'cadastro', VL_Linha, 'erro inesperado na classe:' + e.ClassName + '/ mensagem:' + e.Message, '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_TLoja.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                    DNucleo.FreeOnRelease;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '0069', 'cadastro', VL_Linha, 'erro inesperado na classe:' + e.ClassName +
                        '/ mensagem:' + e.Message, '', VL_Erro);
            end;
        end;
    end;
end;

function comando006A(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //excluir pinpad
var
    VL_Mensagem: TMensagem;
    VL_TPinPad: TZQuery;
    VL_Tag: ansistring;
    VL_ID: int64;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TPinPad := TZQuery.Create(DComunicador);
    VL_TPinPad.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_ID := 0;
    VL_Erro := 0;
    VL_Linha := '';
    try
        try
            //verifica parametros
            VP_Mensagem.GetTag('0054', VL_ID); //id do pinpad
            if VL_ID = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('006A', 'R');
                VL_Mensagem.AddTag('004D', '47');//nulo
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '050520221533';
                GravaLog(F_ArquivoLog, 0, '006A', 'cadastro', VL_Linha, 'id informado não pode ser zero para a exclusão do registro na tabela pinpad',
                    '', VL_Erro);
                Exit;
            end;
            //verifica permissao
            if ((TTConexao(VP_AContext.Data).Permissao = pmU) or (TTConexao(VP_AContext.Data).Permissao = pmS)) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('006A', 'R');
                VL_Mensagem.AddTag('004D', '45');//sem permissão
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '050520221537';
                GravaLog(F_ArquivoLog, 0, '006A', 'cadastro', VL_Linha, 'sem permissão para gerenciar a exclusão do registro na tabela pinpad', '', VL_Erro);
                Exit;
            end;
            //verifica se existe o id pra exclusão
            VL_TPinPad.Close;
            VL_TPinPad.SQL.Text := 'SELECT * FROM PINPAD WHERE ID=' + IntToStr(VL_ID);
            VL_Erro := 55;
            VL_Linha := '020620221710';
            VL_TPinPad.Open;

            if VL_TPinPad.RecordCount = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('006A', 'R');
                VL_Mensagem.AddTag('004D', '48');//id não encontrado
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 48;
                VL_Linha := '050520221538';
                GravaLog(F_ArquivoLog, 0, '006A', 'cadastro', VL_Linha, 'id informado não encontrado para exclusão do registro na tabela pinpad',
                    '', VL_Erro);
                Exit;
            end;
            //exclui PINPAD
            VL_TPinPad.Close;
            VL_TPinPad.SQL.Text := 'DELETE FROM PINPAD WHERE ' + 'ID=' + IntToStr(VL_ID);
            VL_Erro := 82;
            VL_Linha := '020620221711';
            VL_TPinPad.ExecSQL;

            //ATUALIZA PDV
            //atualiza loja
            VL_TPinPad.Close;
            VL_TPinPad.SQL.Text := 'UPDATE PDV SET PINPAD_ID=NULL WHERE PINPAD_ID=' + IntToStr(VL_ID);
            VL_Erro := 46;
            VL_Linha := '020620221712';
            VL_TPinPad.ExecSQL;

            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('006A', 'R');
            VL_Mensagem.AddTag('004D', '0');
            VL_Mensagem.AddTag('0054', VL_ID);
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                        DNucleo.FreeOnRelease;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '006A', 'cadastro', VL_Linha, 'erro inesperado na classe:' +
                            e.ClassName + '/ mensagem:' + e.Message, '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '006A', 'cadastro', VL_Linha, 'erro inesperado na classe:' + e.ClassName + '/ mensagem:' + e.Message, '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_TPinPad.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                    DNucleo.FreeOnRelease;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '006A', 'cadastro', VL_Linha, 'erro inesperado na classe:' + e.ClassName + '/ mensagem:' +
                        e.Message, '', VL_Erro);
            end;
        end;
    end;
end;

function comando006B(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;  //excluir pdv
var
    VL_Mensagem: TMensagem;
    VL_TPdv: TZQuery;
    VL_Tag: ansistring;
    VL_ID: int64;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TPdv := TZQuery.Create(DComunicador);
    VL_TPdv.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_ID := 0;
    VL_Erro := 0;
    VL_Linha := '';
    try
        try
            //verifica parametros
            VP_Mensagem.GetTag('0043', VL_ID); //pdv_id
            if VL_ID = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('006B', 'R');
                VL_Mensagem.AddTag('004D', '47');//campo zerado
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '060520221417';
                GravaLog(F_ArquivoLog, 0, '006B', 'cadastro', VL_Linha, 'campo id da tabela pdv não pode ser zero para exclusão', '', VL_Erro);
                Exit;
            end;
            //verifica permissao
            if ((TTConexao(VP_AContext.Data).Permissao = pmU) or (TTConexao(VP_AContext.Data).Permissao = pmS)) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('006B', 'R');
                VL_Mensagem.AddTag('004D', '45');//sem permissão
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '060520221420';
                GravaLog(F_ArquivoLog, 0, '006B', 'cadastro', VL_Linha, 'sem permissõa para gerenciar exclusão de registro na tabela pdv', '', VL_Erro);
                Exit;
            end;
            //verifica se existe o id pra exclusão
            VL_TPdv.Close;
            VL_TPdv.SQL.Text := 'SELECT * FROM PDV WHERE ID=' + IntToStr(VL_ID);
            VL_Erro := 55;
            VL_Linha := '030620220913';
            VL_TPdv.Open;

            if VL_TPdv.RecordCount = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('006B', 'R');
                VL_Mensagem.AddTag('004D', '48');//registro não localizado
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 48;
                VL_Linha := '060520221421';
                GravaLog(F_ArquivoLog, 0, '006B', 'cadastro', VL_Linha, 'não localizado na tabela pdv o registro numero:' + IntToStr(VL_ID), '', VL_Erro);
                Exit;
            end;
            //exclui PDV
            VL_TPdv.Close;
            VL_TPdv.SQL.Text := 'DELETE FROM PDV WHERE ' + 'ID=' + IntToStr(VL_ID);
            VL_Erro := 82;
            VL_Linha := '030620220915';
            VL_TPdv.ExecSQL;

            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('006B', 'R');
            VL_Mensagem.AddTag('004D', '0');
            VL_Mensagem.AddTag('0043', VL_ID);
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);

        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                        DNucleo.FreeOnRelease;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '006B', 'cadastro', VL_Linha, 'erro inesperado na classe:' +
                            e.ClassName + '/ mensagem:' + e.Message, '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '006B', 'cadastro', VL_Linha, 'erro inesperado na classe:' + e.ClassName + '/ mensagem:' + e.Message, '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_TPdv.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                    DNucleo.FreeOnRelease;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '006B', 'cadastro', VL_Linha, 'erro inesperado na classe:' + e.ClassName +
                        '/ mensagem:' + e.Message, '', VL_Erro);
            end;
        end;
    end;
end;

function comando0070(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;   //pesquisa tabelas em lote
var
    VL_Mensagem: TMensagem;
    VL_Dados: int64;
    VL_TTabela: TZQuery;
    VL_Tag: string;
    VL_Linha: string;
    VL_Erro: integer;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TTabela := TZQuery.Create(DComunicador);
    VL_TTabela.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Dados := 0;
    VL_Linha := '';
    VL_Erro := 0;
    try
        try
            VL_Mensagem.Limpar;
            try
                VL_Mensagem.AddComando('0070', 'R');
                VL_Mensagem.AddTag('004D', '0');
                //pesquisa tabela loja
                if VP_Mensagem.GetTag('003C', VL_Dados) = 0 then //pesquisa a loja pelo campo loja_ID 0=todas
                begin
                    VL_TTabela.Close;
                    VL_TTabela.SQL.Text :=
                        'SELECT L.*, case WHEN (SELECT m.LOJA_ID from MULTILOJA m where m.LOJA_ID=l.ID) ' +
                        'is null then ''F'' else ''T'' end AS MULT FROM LOJA L WHERE ((ID=' + IntToStr(VL_Dados) + ') or (' + IntToStr(VL_Dados) +
                        ' is not null) and ((' + IntToStr(VL_Dados) + ' is null) or (' + IntToStr(VL_Dados) + '=0)))';
                    VL_TTabela.Open;

                    VL_Tag := ZQueryToStrRxMemData(VL_TTabela);

                    VL_Mensagem.AddTag('003E', VL_Tag); //TABELA LOJA

                    VL_TTabela.Close;

                    VL_TTabela.SQL.Text := 'SELECT L.*,M.DESCRICAO AS MODULO,MC.DESCRICAO AS MODULO_CONF FROM ' +
                        'LOJA_MODULO_CONF L LEFT OUTER JOIN MODULO_CONF MC ON MC.ID=L.MODULO_CONF_ID ' +
                        'LEFT OUTER JOIN MODULO M ON M.ID=MC.MODULO_ID ' +
                        'WHERE L.LOJA_ID=' + IntToStr(VL_Dados);

                    VL_TTabela.Open;
                    VL_Tag := ZQueryToStrRxMemData(VL_TTabela);
                    VL_Mensagem.AddTag('00A7', VL_TAG); //TABELA LOJA_MODULO

                    VL_TTabela.Close;
                    VL_TTabela.SQL.Text :=
                        'SELECT (CASE WHEN (LF.TAG_NUMERO) IS NULL THEN  ''F'' ELSE ''T'' END) AS VALIDADO,LF.ID,LF.LOJA_ID,' +
                        'T.ID AS TAG_ID,T.TAG_NUMERO,T.DEFINICAO,LF.HABILITADO,T.TAG_TIPO FROM TAG T, LOJA_FUNCAO LF where LF.TAG_NUMERO=T.TAG_NUMERO and ' +
                        'T.TAG_TIPO<>''DADOS'' AND T.PADRAO=''T'' AND LF.LOJA_ID=' + IntToStr(VL_Dados) +
                        ' UNION ALL SELECT ''F'', NULL, NULL, T.ID AS TAG_ID, T.TAG_NUMERO, T.DEFINICAO,''F'',T.TAG_TIPO FROM TAG T where ' +
                        'T.TAG_TIPO<>''DADOS'' AND (select COUNT(*) FROM LOJA_FUNCAO LF2,TAG T2 where T.TAG_NUMERO=T2.TAG_NUMERO AND ' +
                        'LF2.LOJA_ID=' + IntToStr(VL_Dados) +
                        ' AND T2.TAG_TIPO<>''DADOS'' AND T2.PADRAO=''T'' AND  LF2.TAG_NUMERO=T2.TAG_NUMERO )=0 ORDER BY 4 desc ';

                    VL_TTabela.Open;
                    VL_Tag := ZQueryToStrRxMemData(VL_TTabela);
                    VL_Mensagem.AddTag('00A9', VL_TAG); //TABELA LOJA_FUNCAO

                end;
                //pesquisa tabela mult-loja
                if VP_Mensagem.GetTag('0065', VL_Dados) = 0 then //pesquisa a mult-loja pelo MULT-LOJA_ID 0=todas
                begin
                    VL_TTabela.Close;
                    VL_TTabela.SQL.Text := 'SELECT M.*,L.DOC,L.RAZAO FROM MULTILOJA M ' +
                        ' LEFT OUTER JOIN LOJA L ON L.ID=M.LOJA_ID WHERE ((M.ID=' + IntToStr(VL_Dados) + ') or (' + IntToStr(VL_Dados) +
                        ' is not null) and ' + '((' + IntToStr(VL_Dados) + ' is null) or (' + IntToStr(VL_Dados) + '=0)))';
                    VL_TTabela.Open;

                    VL_Tag := ZQueryToStrRxMemData(VL_TTabela);

                    VL_Mensagem.AddTag('0080', VL_Tag); //TABELA MULTILOJA
                    //NOVO
                    VL_TTabela.Close;
                    VL_TTabela.SQL.Text := 'SELECT ML.*,M.DESCRICAO AS MODULO,MC.DESCRICAO AS MODULO_CONF FROM ' +
                        'MULTILOJA_MODULO_CONF ML LEFT OUTER JOIN MODULO_CONF MC ON MC.ID=ML.MODULO_CONF_ID ' +
                        'LEFT OUTER JOIN MODULO M ON M.ID=MC.MODULO_ID ' +
                        'WHERE ML.MULTILOJA_ID=' + IntToStr(VL_Dados);

                    VL_TTabela.Open;
                    VL_Tag := ZQueryToStrRxMemData(VL_TTabela);
                    VL_Mensagem.AddTag('0094', VL_TAG); //TABELA MULTILOJA_MODULO

                    VL_TTabela.Close;
                    VL_TTabela.SQL.Text := 'SELECT (CASE WHEN (M.TAG_NUMERO) IS NULL THEN  ''F'' ELSE ''T'' END) AS VALIDADO,M.ID,M.MULTILOJA_ID,' +
                        'T.ID AS TAG_ID,T.TAG_NUMERO,T.DEFINICAO,M.HABILITADO,T.TAG_TIPO from TAG T, MULTILOJA_FUNCAO M where M.TAG_NUMERO=T.TAG_NUMERO and ' +
                        'T.TAG_TIPO<>''DADOS'' AND T.PADRAO=''T'' AND M.MULTILOJA_ID=' + IntToStr(VL_Dados) +
                        ' UNION ALL SELECT ''F'', NULL, NULL, T.ID AS TAG_ID, T.TAG_NUMERO, T.DEFINICAO,''F'',T.TAG_TIPO from TAG T where ' +
                        'T.TAG_TIPO<>''DADOS'' AND (select COUNT(*) from MULTILOJA_FUNCAO M2,TAG T2 where T.TAG_NUMERO=T2.TAG_NUMERO AND T2.PADRAO=''T'' AND '
                        +
                        'M2.MULTILOJA_ID=' + IntToStr(VL_Dados) + ' AND T2.TAG_TIPO<>''DADOS'' AND  M2.TAG_NUMERO=T2.TAG_NUMERO )=0 ORDER BY 4 desc ';

                    VL_TTabela.Open;
                    VL_Tag := ZQueryToStrRxMemData(VL_TTabela);
                    VL_Mensagem.AddTag('009C', VL_TAG); //TABELA MULTILOJA_FUNCAO

                end;
                //pesquisa tabela multloja_modulo_conf_funcao
                if VP_Mensagem.GetTag('0097', VL_Dados) = 0 then //pesquisa a multloja_modulo_conf_funcao pelo MULTILOJA_MODULO_CONF_ID 0=todas
                begin
                    VL_TTabela.Close;
                    VL_TTabela.SQL.Text := 'SELECT (CASE WHEN (M.TAG_NUMERO) IS NULL THEN  ''F'' ELSE ''T'' END) AS VALIDADO,M.ID,' +
                        'M.MULTILOJA_MODULO_CONF_ID,T.ID AS TAG_ID,T.TAG_NUMERO,T.DEFINICAO,M.HABILITADO,T.TAG_TIPO from TAG T, ' +
                        'MULTILOJA_MODULO_CONF_FUNCAO M where M.TAG_NUMERO=T.TAG_NUMERO and T.TAG_TIPO<>''DADOS'' AND T.PADRAO=''T'' AND ' +
                        'M.MULTILOJA_MODULO_CONF_ID=' + IntToStr(VL_Dados) + ' UNION ALL SELECT ''F'', NULL, NULL, T.ID AS TAG_ID, T.TAG_NUMERO, ' +
                        'T.DEFINICAO,''F'',T.TAG_TIPO from TAG T where T.TAG_TIPO<>''DADOS'' AND (select COUNT(*) from MULTILOJA_MODULO_CONF_FUNCAO M2,TAG T2 '
                        +
                        'where T.TAG_NUMERO=T2.TAG_NUMERO AND M2.MULTILOJA_MODULO_CONF_ID=' + IntToStr(VL_Dados) + ' AND T2.TAG_TIPO<>''DADOS'' AND ' +
                        'T2.PADRAO=''T'' AND M2.TAG_NUMERO=T2.TAG_NUMERO )=0 ORDER BY 4 desc ';

                    VL_TTabela.Open;
                    VL_Tag := ZQueryToStrRxMemData(VL_TTabela);
                    VL_Mensagem.AddTag('00D0', VL_TAG); //TABELA MULTILOJA_CONF_FUNCAO
                end;
                //pesquisa tabela loja_modulo_conf_funcao
                if VP_Mensagem.GetTag('00AF', VL_Dados) = 0 then //pesquisa a loja_modulo_conf_funcao pelo LOJA_MODULO_CONF_ID 0=todas
                begin
                    VL_TTabela.Close;
                    VL_TTabela.SQL.Text := 'SELECT (CASE WHEN (M.TAG_NUMERO) IS NULL THEN  ''F'' ELSE ''T'' END) AS VALIDADO,M.ID,M.LOJA_MODULO_CONF_ID,' +
                        'T.ID AS TAG_ID,T.TAG_NUMERO,T.DEFINICAO,M.HABILITADO,T.TAG_TIPO from TAG T, LOJA_MODULO_CONF_FUNCAO M where ' +
                        'M.TAG_NUMERO=T.TAG_NUMERO and T.TAG_TIPO<>''DADOS'' AND T.PADRAO=''T'' AND M.LOJA_MODULO_CONF_ID=' + IntToStr(VL_Dados) +
                        ' UNION ALL SELECT ''F'', NULL, NULL, T.ID AS TAG_ID, T.TAG_NUMERO, T.DEFINICAO,''F'',T.TAG_TIPO from TAG T where ' +
                        'T.TAG_TIPO<>''DADOS'' AND (select COUNT(*) from LOJA_MODULO_CONF_FUNCAO M2,TAG T2 where T.TAG_NUMERO=T2.TAG_NUMERO AND ' +
                        'M2.LOJA_MODULO_CONF_ID=' + IntToStr(VL_Dados) + ' AND T2.TAG_TIPO<>''DADOS'' AND T2.PADRAO=''T'' AND ' +
                        'M2.TAG_NUMERO=T2.TAG_NUMERO )=0 ORDER BY 4 desc ';

                    VL_TTabela.Open;
                    VL_Tag := ZQueryToStrRxMemData(VL_TTabela);
                    VL_Mensagem.AddTag('0098', VL_TAG); //TABELA LOJA_CONF_FUNCAO
                end;
                //pesquisa tabela tag
                if VP_Mensagem.GetTag('006E', VL_Dados) = 0 then //pesquisa a tag pelo TAG_ID 0=todas
                begin
                    VL_TTabela.Close;
                    VL_TTabela.SQL.Text := 'SELECT T.*,CAST(T.DADOS AS VARCHAR(500)) AS DADOS_F FROM TAG T WHERE ((ID=' +
                        IntToStr(VL_Dados) + ') or (' + IntToStr(VL_Dados) + ' is not null) and ' +
                        '((' + IntToStr(VL_Dados) + ' is null) or (' + IntToStr(VL_Dados) + '=0)))';
                    VL_TTabela.Open;

                    VL_Tag := ZQueryToStrRxMemData(VL_TTabela);
                    VL_Mensagem.AddTag('0081', VL_Tag); //TABELA TAGS
                end;
                //pesquisa tabela adquirente
                if VP_Mensagem.GetTag('006F', VL_Dados) = 0 then //pesquisa a adquirente pelo ADQUIRENTE_ID 0=todas
                begin
                    VL_TTabela.Close;
                    VL_TTabela.SQL.Text := 'SELECT * FROM ADQUIRENTE WHERE ((ID=' +
                        IntToStr(VL_Dados) + ') or (' + IntToStr(VL_Dados) + ' is not null) and ' + '((' + IntToStr(VL_Dados) +
                        ' is null) or (' + IntToStr(VL_Dados) + '=0)))';
                    VL_TTabela.Open;

                    VL_Tag := ZQueryToStrRxMemData(VL_TTabela);
                    VL_Mensagem.AddTag('0082', VL_Tag); //TABELA ADQUIRENTE
                end;
                //pesquisa tabela bin
                if VP_Mensagem.GetTag('0076', VL_Dados) = 0 then //bin_ID 0=todas
                begin
                    VL_TTabela.Close;
                    VL_TTabela.SQL.Text := 'SELECT * FROM BIN WHERE ((ID=' + IntToStr(VL_Dados) + ') or (' + IntToStr(VL_Dados) +
                        ' is not null) and ((' + IntToStr(VL_Dados) + ' is null) or (' + IntToStr(VL_Dados) + '=0)))';
                    VL_TTabela.Open;

                    VL_Tag := ZQueryToStrRxMemData(VL_TTabela);
                    VL_Mensagem.AddTag('0083', VL_TAG); //TABELA BIN
                end;
                //pesquisa PinPad
                if VP_Mensagem.GetTag('0054', VL_Dados) = 0 then //pesquisa a pinpad pelo PINPAD_ID 0=todas
                begin
                    VL_TTabela.Close;
                    VL_TTabela.SQL.Text := 'SELECT * FROM PINPAD WHERE ((ID=' + IntToStr(VL_Dados) + ') or (' + IntToStr(VL_Dados) + ' is not null) and ((' +
                        IntToStr(VL_Dados) + ' is null) or (' + IntToStr(VL_Dados) + '=0)))';
                    VL_TTabela.Open;

                    VL_Tag := ZQueryToStrRxMemData(VL_TTabela);
                    VL_Mensagem.AddTag('008D', VL_TAG); //TABELA PINPAD

                    VL_TTabela.Close;
                    VL_TTabela.SQL.Text := 'SELECT (CASE WHEN (PF.TAG_NUMERO) IS NULL THEN  ''F'' ELSE ''T'' END) AS VALIDADO,PF.ID,PF.PINPAD_ID,' +
                        'T.ID AS TAG_ID,T.TAG_NUMERO,T.DEFINICAO,PF.HABILITADO,T.TAG_TIPO FROM TAG T, PINPAD_FUNCAO PF where PF.TAG_NUMERO=T.TAG_NUMERO and ' +
                        'T.TAG_TIPO<>''DADOS'' AND T.PADRAO=''T'' AND PF.PINPAD_ID=' + IntToStr(VL_Dados) +
                        ' UNION ALL SELECT ''F'', NULL, NULL, T.ID AS TAG_ID, T.TAG_NUMERO, T.DEFINICAO,''F'',T.TAG_TIPO FROM TAG T where ' +
                        'T.TAG_TIPO<>''DADOS'' AND (select COUNT(*) FROM PINPAD_FUNCAO PF2,TAG T2 where T.TAG_NUMERO=T2.TAG_NUMERO AND PF2.PINPAD_ID=' +
                        IntToStr(VL_Dados) + ' AND T2.TAG_TIPO<>''DADOS'' AND T2.PADRAO=''T'' AND PF2.TAG_NUMERO=T2.TAG_NUMERO )=0 ORDER BY 4 desc ';

                    VL_TTabela.Open;
                    VL_Tag := ZQueryToStrRxMemData(VL_TTabela);
                    VL_Mensagem.AddTag('00B4', VL_TAG); //TABELA PINPAD_FUNCAO

                end;
                //pesquisa Pdv
                if VP_Mensagem.GetTag('0043', VL_Dados) = 0 then //pesquisa o pdv pelo PDV_ID 0=todas
                begin
                    VL_TTabela.Close;
                    VL_TTabela.SQL.Text := 'SELECT * FROM PDV WHERE ((ID=' + IntToStr(VL_Dados) + ') or (' + IntToStr(VL_Dados) + ' is not null) and ((' +
                        IntToStr(VL_Dados) + ' is null) or (' + IntToStr(VL_Dados) + '=0)))';
                    VL_TTabela.Open;

                    VL_Tag := ZQueryToStrRxMemData(VL_TTabela);
                    VL_Mensagem.AddTag('008E', VL_TAG); //TABELA PDV

                    VL_TTabela.Close;
                    VL_TTabela.SQL.Text := 'SELECT P.*,M.DESCRICAO AS MODULO,MC.DESCRICAO AS MODULO_CONF,T.TAG_NUMERO,T.DEFINICAO FROM ' +
                        'PDV_MODULO_CONF P LEFT OUTER JOIN MODULO_CONF MC ON MC.ID=P.MODULO_CONF_ID ' +
                        'LEFT OUTER JOIN MODULO M ON M.ID=MC.MODULO_ID LEFT OUTER JOIN TAG T ON T.TAG_NUMERO=P.TAG_NUMERO ' +
                        'WHERE P.PDV_ID=' + IntToStr(VL_Dados);

                    VL_TTabela.Open;
                    VL_Tag := ZQueryToStrRxMemData(VL_TTabela);
                    VL_Mensagem.AddTag('00C7', VL_TAG); //TABELA PDV_MODULO


                    VL_TTabela.Close;
                    VL_TTabela.SQL.Text := 'SELECT (CASE WHEN (PF.TAG_NUMERO) IS NULL THEN  ''F'' ELSE ''T'' END) AS VALIDADO,PF.ID,PF.PDV_ID,' +
                        'T.ID AS TAG_ID,T.TAG_NUMERO,T.DEFINICAO,PF.HABILITADO,T.TAG_TIPO FROM TAG T, PDV_FUNCAO PF where PF.TAG_NUMERO=T.TAG_NUMERO and ' +
                        'T.TAG_TIPO<>''DADOS'' AND T.PADRAO=''T'' AND PF.PDV_ID=' + IntToStr(VL_Dados) +
                        ' UNION ALL SELECT ''F'', NULL, NULL, T.ID AS TAG_ID, T.TAG_NUMERO, T.DEFINICAO,''F'',T.TAG_TIPO FROM TAG T where ' +
                        'T.TAG_TIPO<>''DADOS'' AND (select COUNT(*) FROM PDV_FUNCAO PF2,TAG T2 where T.TAG_NUMERO=T2.TAG_NUMERO AND PF2.PDV_ID=' +
                        IntToStr(VL_Dados) + ' AND ' +
                        'T2.TAG_TIPO<>''DADOS'' AND T2.PADRAO=''T'' AND PF2.TAG_NUMERO=T2.TAG_NUMERO )=0 ORDER BY 4 desc ';

                    VL_TTabela.Open;
                    VL_Tag := ZQueryToStrRxMemData(VL_TTabela);
                    VL_Mensagem.AddTag('00C1', VL_TAG); //TABELA PDV_FUNCAO

                end;
                //pesquisa configurador
                if VP_Mensagem.GetTag('0056', VL_Dados) = 0 then //pesquisa o CONFIGURADOR pelo CONFIGURADOR_ID 0=todas
                begin
                    VL_TTabela.Close;
                    VL_TTabela.SQL.Text := 'SELECT * FROM CONFIGURADOR WHERE ((ID=' + IntToStr(VL_Dados) + ') or (' + IntToStr(VL_Dados) +
                        ' is not null) and ((' + IntToStr(VL_Dados) + ' is null) or (' + IntToStr(VL_Dados) + '=0)))';
                    VL_TTabela.Open;
                    VL_Tag := ZQueryToStrRxMemData(VL_TTabela);
                    VL_Mensagem.AddTag('008F', VL_TAG); //TABELA CONFIGURADOR
                end;
                //pesquisa modulo
                if VP_Mensagem.GetTag('006C', VL_Dados) = 0 then //pesquisa o modulo pelo MODULO_ID 0=todas
                begin
                    VL_TTabela.Close;
                    VL_TTabela.SQL.Text := 'SELECT * FROM MODULO WHERE ((ID=' + IntToStr(VL_Dados) + ') or (' + IntToStr(VL_Dados) + ' is not null) and ' +
                        '((' + IntToStr(VL_Dados) + ' is null) or (' + IntToStr(VL_Dados) + '=0)))';
                    VL_TTabela.Open;
                    VL_Tag := ZQueryToStrRxMemData(VL_TTabela);
                    VL_Mensagem.AddTag('0090', VL_TAG); //TABELA MODULO

                    VL_TTabela.Close;
                    VL_TTabela.SQL.Text := 'SELECT M.ID,M.DESCRICAO AS MODULO_DESCRICAO,MC.ID AS MODULO_CONF_ID,MC.DESCRICAO AS MODULO_CONF_DESCRICAO,' +
                        'MC.ADQUIRENTE_ID,A.DESCRICAO AS ADQUIRENTE_DESCRICAO,MC.HABILITADO FROM MODULO M LEFT OUTER JOIN MODULO_CONF MC on MC.MODULO_ID=M.ID'
                        +
                        ' LEFT OUTER JOIN ADQUIRENTE A ON A.ID=MC.ADQUIRENTE_ID WHERE MC.HABILITADO=''T''';
                    VL_TTabela.Open;
                    VL_Tag := ZQueryToStrRxMemData(VL_TTabela);
                    VL_Mensagem.AddTag('0095', VL_TAG); //TABELA PESQUISA_MODULO


                    VL_TTabela.Close;
                    VL_TTabela.SQL.Text := 'SELECT MC.*,AD.DESCRICAO AS ADQUIRENTE_DESCRICAO FROM MODULO_CONF MC ' +
                        'LEFT OUTER JOIN ADQUIRENTE AD ON AD.ID=MC.ADQUIRENTE_ID WHERE ' +
                        '((MC.MODULO_ID=' + IntToStr(VL_Dados) + ') or (' + IntToStr(VL_Dados) + ' is not null) and ' + '((' +
                        IntToStr(VL_Dados) + ' is null) or (' + IntToStr(VL_Dados) + '=0)))';

                    VL_TTabela.Open;
                    VL_Tag := ZQueryToStrRxMemData(VL_TTabela);
                    VL_Mensagem.AddTag('003A', VL_TAG); //RETORNO DE TABELA MODULO_CONF

                    VL_TTabela.Close;
                    VL_TTabela.SQL.Text :=
                        'SELECT (CASE WHEN (M.TAG_NUMERO) IS NULL THEN  ''F'' ELSE ''T'' END) AS VALIDADO,M.ID,M.MODULO_ID AS MODULO_ID,' +
                        'T.ID AS TAG_ID,T.TAG_NUMERO,T.DEFINICAO,M.HABILITADO,T.TAG_TIPO from TAG T, MODULO_FUNCAO M where ' +
                        'M.TAG_NUMERO=T.TAG_NUMERO and T.TAG_TIPO<>''DADOS'' AND T.PADRAO=''T'' AND M.MODULO_ID=' + IntToStr(VL_Dados) +
                        ' UNION ALL SELECT ''F'', NULL, NULL, T.ID AS TAG_ID, T.TAG_NUMERO, T.DEFINICAO,''F'',T.TAG_TIPO from TAG T where ' +
                        't.TAG_TIPO<>''DADOS'' AND (select COUNT(*) from MODULO_FUNCAO M2,TAG T2 where T.TAG_NUMERO=T2.TAG_NUMERO AND M2.MODULO_ID=' +
                        IntToStr(VL_Dados) + ' AND t2.TAG_TIPO<>''DADOS'' AND T.PADRAO=''T'' AND M2.TAG_NUMERO=t2.TAG_NUMERO )=0 ORDER BY 4 desc ';
                    VL_TTabela.Open;
                    VL_Tag := ZQueryToStrRxMemData(VL_TTabela);
                    VL_Mensagem.AddTag('0092', VL_TAG); //TABELA MODULO_FUNCAO
                end;
                if VP_Mensagem.GetTag('007B', VL_Dados) = 0 then //pesquisa o modulo pelo MODULO_CONF_ID 0=todas
                begin
                    VL_TTabela.Close;
                    VL_TTabela.SQL.Text :=
                        'SELECT (CASE WHEN (M.TAG_NUMERO) IS NULL THEN  ''F'' ELSE ''T'' END) AS VALIDADO,M.ID,M.MODULO_CONF_ID AS MODULO_CONF_ID,' +
                        'T.ID AS TAG_ID,T.TAG_NUMERO,T.DEFINICAO,M.HABILITADO,T.TAG_TIPO from TAG T, MODULO_CONF_FUNCAO M where M.TAG_NUMERO=T.TAG_NUMERO and '
                        +
                        'T.TAG_TIPO<>''DADOS'' AND T.PADRAO=''T'' AND M.MODULO_CONF_ID=' + IntToStr(VL_Dados) +
                        ' UNION ALL SELECT ''F'', NULL, NULL, T.ID AS TAG_ID, T.TAG_NUMERO, T.DEFINICAO,''F'',T.TAG_TIPO from TAG T where ' +
                        't.TAG_TIPO<>''DADOS'' AND (select COUNT(*) from MODULO_CONF_FUNCAO M2,TAG T2 where T.TAG_NUMERO=T2.TAG_NUMERO AND M2.MODULO_CONF_ID='
                        +
                        IntToStr(VL_Dados) + ' AND t2.TAG_TIPO<>''DADOS'' AND T2.PADRAO=''T'' AND M2.TAG_NUMERO=t2.TAG_NUMERO )=0 ORDER BY 4 desc ';

                    VL_TTabela.Open;
                    VL_Tag := ZQueryToStrRxMemData(VL_TTabela);
                    VL_Mensagem.AddTag('0093', VL_TAG); //TABELA MODULOCONF_FUNCAO

                end;

                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);

            except
                VL_Mensagem.AddComando('0026', '55');
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
            end;
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                        DNucleo.FreeOnRelease;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '0070', 'cadastro', VL_Linha, 'erro inesperado classe: ' + e.ClassName +
                            '/ menssagem:' + e.Message, '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '0070', 'cadastro', VL_Linha, 'erro inesperado classe: ' + e.ClassName + '/ menssagem:' + e.Message, '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_TTabela.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                    DNucleo.FreeOnRelease;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '0070', 'cadastro', VL_Linha, 'erro inesperado classe: ' + e.ClassName +
                        '/ menssagem:' + e.Message, '', VL_Erro);
            end;
        end;
    end;
end;

function comando0071(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;
var
    VL_Mensagem: TMensagem;
    VL_TModuloConf: TZQuery;
    VL_Tag: ansistring;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TModuloConf := TZQuery.Create(DComunicador);
    VL_TModuloConf.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Linha := '';
    VL_Erro := 0;
    try
        try
            //verifica permissao
            if TTConexao(VP_AContext.Data).Permissao <> pmC then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0071', 'R');
                VL_Mensagem.AddTag('004D', '45'); //sem permissão
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '070620220858';
                GravaLog(F_ArquivoLog, 0, '0071', 'cadastro', VL_Linha, 'sem permissão para gerenciar a alteração da chave na tabela modulo_conf',
                    '', VL_Erro);
                Exit;
            end;
            //verifica parametros
            VP_Mensagem.GetTag('0041', VL_Tag); // chave do modulo_conf
            if length(VL_Tag) < 1 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0071', 'R');
                VL_Mensagem.AddTag('004D', '47');//registro zerado
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '070620220859';
                GravaLog(F_ArquivoLog, 0, '0071', 'cadastro', VL_Linha, 'o parametro informado na Tag:0041 esta nulo ou zerado', '', VL_Erro);
                Exit;
            end;
            VL_TModuloConf.Close;
            VL_TModuloConf.SQL.Text := 'SELECT FIRST 1 ID FROM MODULO_CONF WHERE CHAVE=''' + VL_Tag + '''';
            VL_Erro := 55;
            VL_Linha := '070620220900';
            VL_TModuloConf.Open;

            if VL_TModuloConf.RecordCount > 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0071', 'R');
                VL_Mensagem.AddTag('004D', '43');//duplicidade
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 43;
                VL_Linha := '070620220901';
                GravaLog(F_ArquivoLog, 0, '0071', 'cadastro', VL_Linha, 'a chave informada ja esta cadastrada para outro registro', '', VL_Erro);
                Exit;
            end;
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('0071', 'R');
            VL_Mensagem.AddTag('004D', '0');
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                        DNucleo.FreeOnRelease;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '0071', 'cadastro', VL_Linha, 'erro inesperado na classe:' +
                            e.ClassName + '/ mensagem:' + e.Message, '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '0071', 'cadastro', VL_Linha, 'erro inesperado na classe:' + e.ClassName + '/ mensagem:' + e.Message, '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                    DNucleo.FreeOnRelease;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '0071', 'cadastro', VL_Linha, 'erro inesperado na classe:' + e.ClassName + '/ mensagem:' +
                        e.Message, '', VL_Erro);
            end;
        end;
    end;
end;

function comando0072(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;    //alterar modulo_conf
var
    VL_Mensagem: TMensagem;
    VL_Tabela: TRxMemoryData;
    VL_TModuloConf: TZQuery;
    VL_Linha: string;
    VL_Tag: ansistring;
    VL_ID: int64;
    VL_Erro: integer;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_Tabela := TRxMemoryData.Create(nil);
    VL_TModuloConf := TZQuery.Create(DComunicador);
    VL_TModuloConf.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_ID := 0;
    VL_Erro := 0;
    VL_Linha := '';
    try
        try
            //verifica permissao
            if TTConexao(VP_AContext.Data).Permissao <> pmC then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0072', 'R');
                VL_Mensagem.AddTag('004D', '45'); //sem permissão
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '050520221708';
                GravaLog(F_ArquivoLog, 0, '0072', 'cadastro', VL_Linha, 'sem permissão para gerenciar a alteração na tabela modulo_conf', '', VL_Erro);
                Exit;
            end;
            //verifica parametros
            VP_Mensagem.GetTag('007B', VL_ID); // modulo_conf_id
            if VL_ID < 1 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0072', 'R');
                VL_Mensagem.AddTag('004D', '47');//registro zerado
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '050520221706';
                GravaLog(F_ArquivoLog, 0, '0072', 'cadastro', VL_Linha, 'o parametro informado na Tag:007B esta nulo ou zerado', '', VL_Erro);
                Exit;
            end;
            VP_Mensagem.GetTag('003A', VL_Tag);  //tabela modulo_conf
            if Length(VL_Tag) = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0072', 'R');
                VL_Mensagem.AddTag('004D', '47');//registro zerado
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '030620221205';
                GravaLog(F_ArquivoLog, 0, '0072', 'cadastro', VL_Linha, 'o parametro informado na Tag:003A esta nulo ou zerado', '', VL_Erro);
                Exit;
            end;
            StrToRxMemData(VL_Tag, VL_Tabela);
            VL_Tabela.Open;

            //verifica se existe o id pra modificação
            VL_TModuloConf.Close;
            VL_TModuloConf.SQL.Text := 'SELECT * FROM MODULO_CONF WHERE ID=' + IntToStr(VL_ID);
            VL_Erro := 55;
            VL_Linha := '030620221206';
            VL_TModuloConf.Open;

            if VL_TModuloConf.RecordCount = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0072', 'R');
                VL_Mensagem.AddTag('004D', '48');//registro não localizado
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 48;
                VL_Linha := '050520221709';
                GravaLog(F_ArquivoLog, 0, '0072', 'cadastro', VL_Linha, 'registro numero ' + IntToStr(VL_ID) +
                    ' não localizado para alteração na tabela modulo_conf', '', VL_Erro);
                Exit;
            end;

            if VL_Tabela.Locate('ID', VL_ID, []) then
            begin
                if ((VL_Tabela.FieldByName('ID').AsInteger <> VL_TModuloConf.FieldByName('ID').AsInteger) or
                    (VL_Tabela.FieldByName('MODULO_ID').AsInteger <> VL_TModuloConf.FieldByName('MODULO_ID').AsInteger) or
                    ((VL_Tabela.FieldByName('CHAVE').AsString <> VL_TModuloConf.FieldByName('CHAVE').AsString) and
                    (VL_TModuloConf.FieldByName('CHAVE').AsString <> ''))) then
                begin
                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('0072', 'R');
                    VL_Mensagem.AddTag('004D', '49');//campos chaves não pode alterar
                    DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                    VL_Erro := 49;
                    VL_Linha := '050520221711';
                    GravaLog(F_ArquivoLog, 0, '0072', 'cadastro', VL_Linha,
                        'campos chaves(id,modulo_id,chave) não podem sofrer alteração na tabela modulo_conf',
                        '', VL_Erro);
                    Exit;
                end;
                //COMEÇA A ALTERAÇÃO
                VL_TModuloConf.Close;
                VL_TModuloConf.SQL.Text := 'UPDATE MODULO_CONF SET ' +
                    'DESCRICAO=''' + VL_Tabela.FieldByName('DESCRICAO').AsString + ''',' +
                    'CHAVE=''' + VL_Tabela.FieldByName('CHAVE').AsString + ''',' +
                    'ADQUIRENTE_ID=''' + VL_Tabela.FieldByName('ADQUIRENTE_ID').AsString + ''',' +
                    'SERVICO_HOST=''' + VL_Tabela.FieldByName('SERVICO_HOST').AsString + ''',' +
                    'SERVICO_PORTA=''' + VL_Tabela.FieldByName('SERVICO_PORTA').AsString + ''',' +
                    'CAIXA_HOST=''' + VL_Tabela.FieldByName('CAIXA_HOST').AsString + ''',' +
                    'CAIXA_PORTA=''' + VL_Tabela.FieldByName('CAIXA_PORTA').AsString + ''',' +
                    'BIN_ESTATICO=''' + VL_Tabela.FieldByName('BIN_ESTATICO').AsString + ''',' +
                    'MENU_ESTATICO=''' + VL_Tabela.FieldByName('MENU_ESTATICO').AsString + ''',' +
                    'MENU_ESTATICO_OPERACIONAL=''' + VL_Tabela.FieldByName('MENU_ESTATICO_OPERACIONAL').AsString + ''',' +
                    'HABILITADO=''' + VL_Tabela.FieldByName('HABILITADO').AsString + ''' WHERE ' +
                    'ID=' + IntToStr(VL_ID);
                VL_Erro := 46;
                VL_Linha := '030620221210';
                VL_TModuloConf.ExecSQL;

                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0072', 'R');
                VL_Mensagem.AddTag('004D', '0');
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                Exit;
            end
            else
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0072', 'R');
                VL_Mensagem.AddTag('004D', '46');
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
            end;
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                        DNucleo.FreeOnRelease;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '0072', 'cadastro', VL_Linha, 'erro inesperado na classe:' +
                            e.ClassName + '/ mensagem:' + e.Message, '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '0072', 'cadastro', VL_Linha, 'erro inesperado na classe:' + e.ClassName + '/ mensagem:' + e.Message, '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_Tabela.Free;
            VL_TModuloConf.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                    DNucleo.FreeOnRelease;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '0072', 'cadastro', VL_Linha, 'erro inesperado na classe:' + e.ClassName + '/ mensagem:' +
                        e.Message, '', VL_Erro);
            end;
        end;
    end;
end;

function comando0073(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;  //INCLUIR MODULO_CONF
var
    VL_Mensagem: TMensagem;
    VL_Tabela: TRxMemoryData;
    VL_TModuloConf: TZQuery;
    VL_Tag: ansistring;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_Tabela := TRxMemoryData.Create(nil);
    VL_TModuloConf := TZQuery.Create(DComunicador);
    VL_TModuloConf.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Erro := 0;
    VL_Linha := '';
    try
        try
            //verifica permissao
            if (TTConexao(VP_AContext.Data).Permissao <> pmC) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0073', 'R');
                VL_Mensagem.AddTag('004D', '45');//SEM PERMISSAO
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '050520220840';
                GravaLog(F_ArquivoLog, 0, '0073', 'cadastro', VL_Linha, 'sem permissão para gerenciar a inclusão de registro na tabela modulo_conf',
                    '', VL_Erro);
                Exit;
            end;
            //VERIFICA PARAMETROS
            VP_Mensagem.GetTag('003A', VL_Tag); //TABELA MODULO_CONFIG
            if Length(VL_Tag) = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0073', 'R');
                VL_Mensagem.AddTag('004D', '47');//PARAMETRO NULO
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '030620221151';
                GravaLog(F_ArquivoLog, 0, '0073', 'cadastro', VL_Linha, 'o parametro informado na Tag:003A esta nulo ou zerado', '', VL_Erro);
                Exit;
            end;
            StrToRxMemData(VL_Tag, VL_Tabela);
            VL_Tabela.Open;

            VL_Tabela.First;
            while not VL_Tabela.EOF do
            begin
                if VL_Tabela.FieldByName('ID').AsInteger = 0 then
                begin
                    //verifica se o modulo_conf ja foi cadastrado
                    VL_TModuloConf.Close;
                    VL_TModuloConf.SQL.Text := 'SELECT FIRST 1 ID FROM MODULO_CONF WHERE MODULO_ID=' +
                        IntToStr(VL_Tabela.FieldByName('MODULO_ID').AsInteger) + ' AND DESCRICAO=''' +
                        VL_Tabela.FieldByName('DESCRICAO').AsString + ''' OR (CHAVE=''' +
                        VL_Tabela.FieldByName('CHAVE').AsString + ''' AND ''' +
                        VL_Tabela.FieldByName('CHAVE').AsString + ''' <> '''')';
                    VL_Erro := 55;
                    VL_Linha := '030620221152';
                    VL_TModuloConf.Open;

                    if VL_TModuloConf.RecordCount > 0 then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('0073', 'R');
                        VL_Mensagem.AddTag('004D', '43');//registro em duplicidade
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        VL_Erro := 43;
                        VL_Linha := '050520220842';
                        GravaLog(F_ArquivoLog, 0, '0073', 'cadastro', VL_Linha, 'registro em duplicidade (chave ja cadastrada) na tabela modulo_conf',
                            '', VL_Erro);
                        Exit;
                    end;
                    //TESTA CAMPOS OBRIGATORIOS
                    if ((length(VL_Tabela.FieldByName('DESCRICAO').AsString) = 0) or
                        (VL_Tabela.FieldByName('MODULO_ID').AsInteger = 0) or
                        (VL_Tabela.FieldByName('ADQUIRENTE_ID').AsInteger = 0)) then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('0073', 'R');
                        VL_Mensagem.AddTag('004D', '52');//CAMPO OBRIGATORIO NULO
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        VL_Erro := 52;
                        VL_Linha := '050520220850';
                        GravaLog(F_ArquivoLog, 0, '0073', 'cadastro', VL_Linha,
                            'campos obrigatórios não podem ser nulos para inclusão de registro na tabela modulo_conf', '', VL_Erro);
                        Exit;
                    end;
                    //COMEÇA A INCLUSÃO
                    VL_TModuloConf.Close;
                    VL_TModuloConf.SQL.Text := 'INSERT INTO MODULO_CONF(' +
                        'MODULO_ID,' +
                        'ADQUIRENTE_ID,' +
                        'SERVICO_HOST,' +
                        'SERVICO_PORTA,' +
                        'CAIXA_HOST,' +
                        'CAIXA_PORTA,' +
                        'CHAVE,' +
                        'DESCRICAO,' +
                        'BIN_ESTATICO,' +
                        'MENU_ESTATICO,' +
                        'MENU_ESTATICO_OPERACIONAL,' +
                        'HABILITADO)VALUES(' +
                        IntToStr(VL_Tabela.FieldByName('MODULO_ID').AsInteger) + ',' +
                        IntToStr(VL_Tabela.FieldByName('ADQUIRENTE_ID').AsInteger) + ',''' +
                        VL_Tabela.FieldByName('SERVICO_HOST').AsString + ''',' +
                        VL_Tabela.FieldByName('SERVICO_PORTA').AsString + ',''' +
                        VL_Tabela.FieldByName('CAIXA_HOST').AsString + ''',' +
                        VL_Tabela.FieldByName('CAIXA_PORTA').AsString + ',''' +
                        VL_Tabela.FieldByName('CHAVE').AsString + ''',''' +
                        VL_Tabela.FieldByName('DESCRICAO').AsString + ''',''' +
                        VL_Tabela.FieldByName('BIN_ESTATICO').AsString + ''',''' +
                        VL_Tabela.FieldByName('MENU_ESTATICO').AsString + ''',''' +
                        VL_Tabela.FieldByName('MENU_ESTATICO_OPERACIONAL').AsString + ''',''' +
                        VL_Tabela.FieldByName('HABILITADO').AsString + ''')';
                    VL_Erro := 44;
                    VL_Linha := '030620221154';
                    VL_TModuloConf.ExecSQL;

                    VL_TModuloConf.Close;
                    VL_TModuloConf.SQL.Text := 'SELECT * FROM MODULO_CONF WHERE MODULO_ID=' +
                        IntToStr(VL_Tabela.FieldByName('MODULO_ID').AsInteger) + ' AND DESCRICAO=''' +
                        VL_Tabela.FieldByName('DESCRICAO').AsString + ''' AND CHAVE=''' + VL_Tabela.FieldByName('CHAVE').AsString + '''';
                    VL_Erro := 55;
                    VL_Linha := '030620221155';
                    VL_TModuloConf.Open;

                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('0073', 'R');
                    VL_Mensagem.AddTag('004D', '0');
                    VL_Mensagem.AddTag('007B', VL_TModuloConf.FieldByName('ID').AsString);
                    DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                    exit;
                end;
                VL_Tabela.Next;
            end;
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('0073', 'R');
            VL_Mensagem.AddTag('004D', '44');
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                        DNucleo.FreeOnRelease;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '0073', 'cadastro', VL_Linha, 'erro inesperado na classe:' +
                            e.ClassName + '/ mensagem:' + e.Message, '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '0073', 'cadastro', VL_Linha, 'erro inesperado na classe:' + e.ClassName + '/ mensagem:' + e.Message, '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_Tabela.Free;
            VL_TModuloConf.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                    DNucleo.FreeOnRelease;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '0073', 'cadastro', VL_Linha, 'erro inesperado na classe:' + e.ClassName + '/ mensagem:' +
                        e.Message, '', VL_Erro);
            end;
        end;
    end;
end;

function comando0074(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;    //INCLUIR MODULO
var
    VL_Mensagem: TMensagem;
    VL_Tabela: TRxMemoryData;
    VL_TModulo: TZQuery;
    VL_Tag: ansistring;
    VL_Linha: string;
    VL_Erro: integer;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_Tabela := TRxMemoryData.Create(nil);
    VL_TModulo := TZQuery.Create(DComunicador);
    VL_TModulo.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Linha := '';
    VL_Erro := 0;
    try
        try
            //verifica permissao
            if TTConexao(VP_AContext.Data).Permissao <> pmC then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0074', 'R');
                VL_Mensagem.AddTag('004D', '45');//SEM PERMISSAO DE ACESSO
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '050520220820';
                GravaLog(F_ArquivoLog, 0, '0074', 'cadastro', VL_Linha, 'sem permissao para gerenciar inclusão de módulos', '', VL_Erro);
                Exit;
            end;
            //VERIFICA PARAMETROS
            VP_Mensagem.GetTag('0090', VL_Tag);  //tabela modulo
            if Length(VL_TAG) = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0074', 'R');
                VL_Mensagem.AddTag('004D', '47');//PARAMETRO VAZIO
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '030620221110';
                GravaLog(F_ArquivoLog, 0, '0074', 'cadastro', VL_Linha, 'o parametro informado na Tag:0090 esta nulo ou zerado', '', VL_Erro);
                Exit;
            end;
            StrToRxMemData(VL_Tag, VL_Tabela);
            VL_Tabela.Open;

            VL_Tabela.First;
            while not VL_Tabela.EOF do
            begin
                if VL_Tabela.FieldByName('ID').AsInteger = 0 then
                begin
                    //TESTA CAMPOS OBRIGATORIOS
                    if length(VL_Tabela.FieldByName('DESCRICAO').AsString) = 0 then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('0074', 'R');
                        VL_Mensagem.AddTag('004D', '52');//52 campos obrigatório não pode ser nulo
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        VL_Erro := 52;
                        VL_Linha := '050520220824';
                        GravaLog(F_ArquivoLog, 0, '0074', 'cadastro', VL_Linha, 'campo descrição é obrigatório para a inclusão do módulo', '', VL_Erro);
                        Exit;
                    end;
                    //verifica se o modulo ja foi cadastrado
                    VL_TModulo.Close;
                    VL_TModulo.SQL.Text := 'SELECT FIRST 1 ID FROM MODULO WHERE TAG_NUMERO=''' + VL_Tabela.FieldByName('TAG_NUMERO').AsString + '''';
                    VL_Erro := 55;
                    VL_Linha := '030620221112';
                    VL_TModulo.Open;

                    if VL_TModulo.RecordCount > 0 then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('0074', 'R');
                        VL_Mensagem.AddTag('004D', '43');//registro em duplicidade
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        VL_Erro := 43;
                        VL_Linha := '050520220826';
                        GravaLog(F_ArquivoLog, 0, '0074', 'cadastro', VL_Linha,
                            'registro em duplicidade,módulo ja cadastrado com essa TAG na tabela módulo',
                            '', VL_Erro);
                        Exit;
                    end;

                    VL_TModulo.Close;
                    VL_TModulo.SQL.Text := 'INSERT INTO MODULO(' +
                        'DESCRICAO,' +
                        'TAG_NUMERO)VALUES(''' +
                        VL_Tabela.FieldByName('DESCRICAO').AsString + ''',''' +
                        VL_Tabela.FieldByName('TAG_NUMERO').AsString + ''')';
                    VL_Erro := 44;
                    VL_Linha := '030620221113';
                    VL_TModulo.ExecSQL;

                    VL_TModulo.Close;
                    VL_TModulo.SQL.Text := 'SELECT * FROM MODULO WHERE DESCRICAO=''' + VL_Tabela.FieldByName('DESCRICAO').AsString + '''';
                    VL_Erro := 55;
                    VL_Linha := '030620221114';
                    VL_TModulo.Open;

                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('0074', 'R');
                    VL_Mensagem.AddTag('004D', '0');
                    VL_Mensagem.AddTag('006C', VL_TModulo.FieldByName('ID').AsString);
                    DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                    exit;
                end;
                VL_Tabela.Next;
            end;
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('0074', 'R');
            VL_Mensagem.AddTag('004D', '44');
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                        DNucleo.FreeOnRelease;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '0074', 'cadastro', VL_Linha, 'erro inesperado na classe:' +
                            e.ClassName + '/ mensagem:' + e.Message, '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '0074', 'cadastro', VL_Linha, 'erro inesperado na classe:' + e.ClassName + '/ mensagem:' + e.Message, '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_Tabela.Free;
            VL_TModulo.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                    DNucleo.FreeOnRelease;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '0074', 'cadastro', VL_Linha, 'erro inesperado na classe:' + e.ClassName + '/ mensagem:' +
                        e.Message, '', VL_Erro);
            end;
        end;
    end;
end;

function comando0075(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;  //alterar modulo
var
    VL_Mensagem: TMensagem;
    VL_Tabela: TRxMemoryData;
    VL_TModulo: TZQuery;
    VL_Tag: ansistring;
    VL_ID: int64;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_Tabela := TRxMemoryData.Create(nil);
    VL_TModulo := TZQuery.Create(DComunicador);
    VL_TModulo.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_ID := 0;
    VL_Erro := 0;
    VL_Linha := '';
    try
        try
            //verifica permissao
            if TTConexao(VP_AContext.Data).Permissao <> pmC then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0075', 'R');
                VL_Mensagem.AddTag('004D', '45');//sem permissão
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '050520221650';
                GravaLog(F_ArquivoLog, 0, '0075', 'cadastro', VL_Linha, 'sem permissão para gerenciar a alteração da tabela modulo', '', VL_Erro);
                Exit;
            end;
            //verifica parametros
            VP_Mensagem.GetTag('006C', VL_ID);  //modulo_id
            if VL_ID = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0075', 'R');
                VL_Mensagem.AddTag('004D', '47');//campo zerado
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '050520221646';
                GravaLog(F_ArquivoLog, 0, '0075', 'cadastro', VL_Linha, 'o parametro informado na Tag:006C esta nulo ou zerado', '', VL_Erro);
                Exit;
            end;
            VP_Mensagem.GetTag('0090', VL_Tag); // tabela modulo
            if Length(VL_Tag) = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0075', 'R');
                VL_Mensagem.AddTag('004D', '47');//campo zerado
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '030620221124';
                GravaLog(F_ArquivoLog, 0, '0075', 'cadastro', VL_Linha, 'o parametro informado na Tag:0090 esta nulo ou zerado', '', VL_Erro);
                Exit;
            end;
            StrToRxMemData(VL_Tag, VL_Tabela);
            VL_Tabela.Open;

            //verifica se existe o id pra modificação
            VL_TModulo.Close;
            VL_TModulo.SQL.Text := 'SELECT * FROM MODULO WHERE ID=' + IntToStr(VL_ID);
            VL_Erro := 55;
            VL_Linha := '030620221125';
            VL_TModulo.Open;

            if VL_TModulo.RecordCount = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0075', 'R');
                VL_Mensagem.AddTag('004D', '48');//registro não localizado
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 48;
                VL_Linha := '050520221654';
                GravaLog(F_ArquivoLog, 0, '0075', 'cadastro', VL_Linha, 'registro não localizado na tabela modulo com o parametro informado(id)',
                    '', VL_Erro);
                Exit;
            end;

            if VL_Tabela.Locate('ID', VL_ID, []) then
            begin
                if (VL_Tabela.FieldByName('ID').AsInteger <> VL_TModulo.FieldByName('ID').AsInteger) then
                begin
                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('0075', 'R');
                    VL_Mensagem.AddTag('004D', '49');//campos chave não pode alterar
                    DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                    VL_Erro := 49;
                    VL_Linha := '050520221658';
                    GravaLog(F_ArquivoLog, 0, '0075', 'cadastro', VL_Linha, 'campo chave (id) não pode sofrer alteração na tabela modulo', '', VL_Erro);
                    Exit;
                end;
                //COMEÇA A ALTERAÇÃO
                VL_TModulo.Close;
                VL_TModulo.SQL.Text := 'UPDATE MODULO SET ' +
                    'DESCRICAO=''' + VL_Tabela.FieldByName('DESCRICAO').AsString + ''',' +
                    'TAG_NUMERO=''' + VL_Tabela.FieldByName('TAG_NUMERO').AsString + ''' WHERE ' +
                    'ID=' + IntToStr(VL_ID);
                VL_Erro := 46;
                VL_Linha := '030620221126';
                VL_TModulo.ExecSQL;

                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0075', 'R');
                VL_Mensagem.AddTag('004D', '0');
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                Exit;
            end
            else
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0075', 'R');
                VL_Mensagem.AddTag('004D', '46');
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
            end;
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                        DNucleo.FreeOnRelease;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '0075', 'cadastro', VL_Linha, 'erro inesperado na classe:' +
                            e.ClassName + '/ mensagem:' + e.Message, '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '0075', 'cadastro', VL_Linha, 'erro inesperado na classe:' + e.ClassName + '/ mensagem:' + e.Message, '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_Tabela.Free;
            VL_TModulo.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                    DNucleo.FreeOnRelease;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '0075', 'cadastro', VL_Linha, 'erro inesperado na classe:' + e.ClassName + '/ mensagem:' +
                        e.Message, '', VL_Erro);
            end;
        end;
    end;
end;

function comando0077(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer; //incluir bin
var
    VL_Mensagem: TMensagem;
    VL_Tabela: TRxMemoryData;
    VL_TBin: TZQuery;
    VL_Tag: ansistring;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_Tabela := TRxMemoryData.Create(nil);
    VL_TBin := TZQuery.Create(DComunicador);
    VL_TBin.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Linha := '';
    VL_Erro := 0;
    try
        try
            //verifica permissao
            if TTConexao(VP_AContext.Data).Permissao <> pmC then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0077', 'R');
                VL_Mensagem.AddTag('004D', '45');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '050520220909';
                GravaLog(F_ArquivoLog, 0, '0077', 'cadastro', VL_Linha, 'sem permissão pra gerenciar a inclusão de registro na tabela BIN', '', VL_Erro);
                Exit;
            end;
            //VERIFICA PARAMETRO
            VP_Mensagem.GetTag('0083', VL_Tag); //tabela bin
            if Length(VL_Tag) = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0077', 'R');
                VL_Mensagem.AddTag('004D', '47');//PARAMETRO NULO
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '030620221221';
                GravaLog(F_ArquivoLog, 0, '0077', 'cadastro', VL_Linha, 'o parametro informado na Tag:0083 esta nulo ou zerado', '', VL_Erro);
                Exit;
            end;
            StrToRxMemData(VL_Tag, VL_Tabela);
            VL_Tabela.Open;

            VL_Tabela.First;
            while not VL_Tabela.EOF do
            begin
                if VL_Tabela.FieldByName('ID').AsInteger = 0 then
                begin
                    //verifica se o bin ja foi cadastrado
                    VL_TBin.Close;
                    VL_TBin.SQL.Text := 'SELECT FIRST 1 ID,MODULO_CONF_ID FROM BIN WHERE (IIN=''' + VL_Tabela.FieldByName('IIN').AsString + ''')';
                    VL_Erro := 55;
                    VL_Linha := '030620221222';
                    VL_TBin.Open;

                    if VL_TBin.RecordCount > 0 then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('0077', 'R');
                        VL_Mensagem.AddTag('004D', '43');//duplicidade
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        VL_Erro := 43;
                        VL_Linha := '050520220911';
                        GravaLog(F_ArquivoLog, 0, '0077', 'cadastro', VL_Linha,
                            'registro em duplicidade na tabela BIN, este numero de Bin ja esta cadastrado para o modulo_conf_id:' +
                            VL_TBin.FieldByName('MODULO_CONF_ID').AsString, '', VL_Erro);
                        Exit;
                    end;
                    //TESTA CAMPOS OBRIGATORIOS
                    if ((length(VL_Tabela.FieldByName('IIN').AsString) = 0) or
                        (length(VL_Tabela.FieldByName('MODULO_CONF_ID').AsString) = 0)) then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('0077', 'R');
                        VL_Mensagem.AddTag('004D', '52');//campos obrigatorios
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        VL_Erro := 52;
                        VL_Linha := '050520220913';
                        GravaLog(F_ArquivoLog, 0, '0077', 'cadastro', VL_Linha,
                            'campos obrigatórios não podem ser nulos na inclusão do registro na tabela BIN',
                            '', VL_Erro);
                        Exit;
                    end;
                    VL_TBin.Close;
                    VL_TBin.SQL.Text := 'INSERT INTO BIN(' +
                        'MODULO_CONF_ID,' +
                        'IIN)VALUES(''' +
                        VL_Tabela.FieldByName('MODULO_CONF_ID').AsString + ''',''' +
                        VL_Tabela.FieldByName('IIN').AsString + ''')';
                    VL_Erro := 44;
                    VL_Linha := '030620221224';
                    VL_TBin.ExecSQL;

                    VL_TBin.Close;
                    VL_TBin.SQL.Text := 'SELECT FIRST 1 ID FROM BIN WHERE ((IIN=''' + VL_Tabela.FieldByName('IIN').AsString + ''') AND ' +
                        '(MODULO_CONF_ID=''' + VL_Tabela.FieldByName('MODULO_CONF_ID').AsString + '''))';
                    VL_Erro := 55;
                    VL_Linha := '030620221225';
                    VL_TBin.Open;

                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('0077', 'R');
                    VL_Mensagem.AddTag('004D', '0');
                    VL_Mensagem.AddTag('0076', VL_TBin.FieldByName('ID').AsString);
                    DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                    exit;
                end;
                VL_Tabela.Next;
            end;
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('0077', 'R');
            VL_Mensagem.AddTag('004D', '44');
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                        DNucleo.FreeOnRelease;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '0077', 'cadastro', VL_Linha, 'erro inesperado classe: ' + e.ClassName +
                            '/ menssagem:' + e.Message, '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '0077', 'cadastro', VL_Linha, 'erro inesperado classe: ' + e.ClassName + '/ menssagem:' + e.Message, '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_Tabela.Free;
            VL_TBin.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                    DNucleo.FreeOnRelease;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '0077', 'cadastro', VL_Linha, 'erro inesperado classe: ' + e.ClassName +
                        '/ menssagem:' + e.Message, '', VL_Erro);
            end;
        end;
    end;
end;

function comando0078(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;   //cadastro EXCLUIR BIN
var
    VL_Mensagem: TMensagem;
    VL_TBin: TZQuery;
    VL_Tag: ansistring;
    VL_ID: int64;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TBin := TZQuery.Create(DComunicador);
    VL_TBin.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_ID := 0;
    VL_Erro := 0;
    VL_Linha := '';
    try
        try
            //verifica parametros
            VP_Mensagem.GetTag('0076', VL_ID);  //BIN_ID
            if VL_ID < 1 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0078', 'R');
                VL_Mensagem.AddTag('004D', '47');//campo obrigatorio não pode ser zero
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '050520221722';
                GravaLog(F_ArquivoLog, 0, '0078', 'cadastro', VL_Linha, 'para excluir o bin da configuração o campo id não pode ser zero', '', VL_Erro);
                Exit;
            end;
            //verifica permissao
            if ((TTConexao(VP_AContext.Data).Permissao = pmU) or (TTConexao(VP_AContext.Data).Permissao = pmS)) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0078', 'R');
                VL_Mensagem.AddTag('004D', '45');//sem permissão
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '050520221725';
                GravaLog(F_ArquivoLog, 0, '0078', 'cadastro', VL_Linha, 'sem permissão para excluir registro da tabela BIN', '', VL_Erro);
                Exit;
            end;
            //verifica se existe o id pra exclusão
            VL_TBin.Close;
            VL_TBin.SQL.Text := 'SELECT * FROM BIN WHERE ID=' + IntToStr(VL_ID);
            VL_Erro := 55;
            VL_Linha := '030620221229';
            VL_TBin.Open;

            if VL_TBin.RecordCount = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0078', 'R');
                VL_Mensagem.AddTag('004D', '48');//id não localizado
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 48;
                VL_Linha := '050520221726';
                GravaLog(F_ArquivoLog, 0, '0078', 'cadastro', VL_Linha, 'não foi possivel localizar o id numero ' + IntToStr(VL_ID) +
                    ' para excluir na tabela bin', '', VL_Erro);
            end
            else
            begin
                //exclui BIN
                VL_TBin.Close;
                VL_TBin.SQL.Text := 'DELETE FROM BIN WHERE ' + 'ID=' + IntToStr(VL_ID);
                VL_Erro := 82;
                VL_Linha := '030620221231';
                VL_TBin.ExecSQL;

                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0078', 'R');
                VL_Mensagem.AddTag('004D', '0');
                VL_Mensagem.AddTag('0076', VL_ID);  //ID DO BIN
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
            end;
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                        DNucleo.FreeOnRelease;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '0078', 'cadastro', VL_Linha, 'erro inesperado classe: ' + e.ClassName +
                            '/ menssagem:' + e.Message, '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '0078', 'cadastro', VL_Linha, 'erro inesperado classe: ' + e.ClassName + '/ menssagem:' + e.Message, '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_TBin.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                    DNucleo.FreeOnRelease;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '0078', 'cadastro', VL_Linha, 'erro inesperado classe: ' + e.ClassName +
                        '/ menssagem:' + e.Message, '', VL_Erro);
            end;
        end;
    end;
end;

function comando0079(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;  //INCLUIR MODULO_CONF_FUNC
var
    VL_Mensagem: TMensagem;
    VL_Tabela: TRxMemoryData;
    VL_TModuloConfFuncao: TZQuery;
    VL_Tag: ansistring;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_Tabela := TRxMemoryData.Create(nil);
    VL_TModuloConfFuncao := TZQuery.Create(DComunicador);
    VL_TModuloConfFuncao.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Linha := '';
    VL_Erro := 0;
    try
        try
            //verifica permissao
            if TTConexao(VP_AContext.Data).Permissao <> pmC then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0079', 'R');
                VL_Mensagem.AddTag('004D', '45');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '250520220852';
                GravaLog(F_ArquivoLog, 0, '0079', 'cadastro', VL_Linha, 'sem permissão para gerenciar a inclusão de registro na tabela modulo_conf_funcao',
                    '', VL_Erro);
                Exit;
            end;
            //VERIFICA PAREMETROS
            VP_Mensagem.GetTag('0093', VL_Tag); //tabela modulo_conf_funcao
            if LENGTH(VL_TAG) = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0079', 'R');
                VL_Mensagem.AddTag('004D', '47');//PARAMETRO NULO
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '030620221431';
                GravaLog(F_ArquivoLog, 0, '0079', 'cadastro', VL_Linha, 'o parametro informado na Tag:0093 esta nulo ou zerado', '', VL_Erro);
                Exit;
            end;
            StrToRxMemData(VL_Tag, VL_Tabela);
            VL_Tabela.Open;

            VL_Tabela.First;
            while not VL_Tabela.EOF do
            begin
                if ((VL_Tabela.FieldByName('VALIDADO').AsBoolean = True) and (VL_Tabela.FieldByName('ID').AsInteger = 0)) then
                begin
                    //verifica se o modulo_conf_func ja foi cadastrado
                    VL_TModuloConfFuncao.Close;
                    VL_TModuloConfFuncao.SQL.Text := 'SELECT FIRST 1 ID FROM MODULO_CONF_FUNCAO WHERE MODULO_CONF_ID=''' +
                        VL_Tabela.FieldByName('MODULO_CONF_ID').AsString + ''' AND TAG_NUMERO=''' +
                        VL_Tabela.FieldByName('TAG_NUMERO').AsString + '''';
                    VL_Erro := 55;
                    VL_Linha := '030620221431';
                    VL_TModuloConfFuncao.Open;

                    if VL_TModuloConfFuncao.RecordCount > 0 then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('0079', 'R');
                        VL_Mensagem.AddTag('004D', '43');//duplicidade
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        VL_Erro := 43;
                        VL_Linha := '250520220854';
                        GravaLog(F_ArquivoLog, 0, '0079', 'cadastro', VL_Linha,
                            'registro em duplicidade na tabela modulo_conf_funcao, ja existe uma função cadastrada com este modulo_conf e esta tag',
                            '', VL_Erro);
                        Exit;
                    end;
                    //TESTA CAMPOS OBRIGATORIOS
                    if ((length(VL_Tabela.FieldByName('MODULO_CONF_ID').AsString) = 0) or
                        (length(VL_Tabela.FieldByName('TAG_NUMERO').AsString) = 0)) then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('0079', 'R');
                        VL_Mensagem.AddTag('004D', '52');//campos nulos
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        VL_Erro := 52;
                        VL_Linha := '250520220855';
                        GravaLog(F_ArquivoLog, 0, '0079', 'cadastro', VL_Linha,
                            'campos obrigatório não pode ser nulo na inclusão de registro na tabela modulo_conf_funcao',
                            '', VL_Erro);
                        Exit;
                    end;
                    //COMEÇA A INCLUSÃO
                    VL_TModuloConfFuncao.Close;
                    VL_TModuloConfFuncao.SQL.Text := 'INSERT INTO MODULO_CONF_FUNCAO(' +
                        'MODULO_CONF_ID,' +
                        'TAG_NUMERO)VALUES(' +
                        IntToStr(VL_Tabela.FieldByName('MODULO_CONF_ID').AsInteger) + ',''' +
                        VL_Tabela.FieldByName('TAG_NUMERO').AsString + ''')';
                    VL_Erro := 44;
                    VL_Linha := '030620221435';
                    VL_TModuloConfFuncao.ExecSQL;

                    VL_TModuloConfFuncao.Close;
                    VL_TModuloConfFuncao.SQL.Text := 'SELECT * FROM MODULO_CONF_FUNCAO WHERE MODULO_CONF_ID=' + VL_Tabela.FieldByName(
                        'MODULO_CONF_ID').AsString + ' AND TAG_NUMERO=''' + VL_Tabela.FieldByName('TAG_NUMERO').AsString + '''';
                    VL_Erro := 55;
                    VL_Linha := '030620221437';
                    VL_TModuloConfFuncao.Open;

                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('0079', 'R');
                    VL_Mensagem.AddTag('004D', '0');
                    VL_Mensagem.AddTag('006D', VL_TModuloConfFuncao.FieldByName('ID').AsString);
                    DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                    exit;
                end;
                VL_Tabela.Next;
            end;
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('0079', 'R');
            VL_Mensagem.AddTag('004D', '44');
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '0079', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '0079', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_Tabela.Free;
            VL_TModuloConfFuncao.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '0079', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando007E(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;  //INCLUIR MODULO_FUNC
var
    VL_Mensagem: TMensagem;
    VL_Tabela: TRxMemoryData;
    VL_TModuloFunc: TZQuery;
    VL_Tag: ansistring;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_Tabela := TRxMemoryData.Create(nil);
    VL_TModuloFunc := TZQuery.Create(DComunicador);
    VL_TModuloFunc.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Linha := '';
    VL_Erro := 0;
    try
        try
            //verifica permissao
            if TTConexao(VP_AContext.Data).Permissao <> pmC then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('007E', 'R');
                VL_Mensagem.AddTag('004D', '45');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '050520220925';
                GravaLog(F_ArquivoLog, 0, '007E', 'cadastro', VL_Linha, 'sem permissão para gerenciar a inclusão de registro na tabela modulo_func',
                    '', VL_Erro);
                Exit;
            end;
            //VERIFICA PARAMETRO DE ENTRADA
            VP_Mensagem.GetTag('0092', VL_Tag); //tabela modulo_funcao
            if Length(VL_Tag) = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('007E', 'R');
                VL_Mensagem.Addtag('004D', '47');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '270520221111';
                GravaLog(F_ArquivoLog, 0, '007E', 'cadastro', VL_Linha,
                    'dados informado na TAG 0092 não pode estar zerado ou nulo',
                    '', VL_Erro);
                Exit;
            end;
            StrToRxMemData(VL_Tag, VL_Tabela);
            VL_Tabela.Open;

            VL_Tabela.First;
            while not VL_Tabela.EOF do
            begin
                if ((VL_Tabela.FieldByName('VALIDADO').AsBoolean = True) and (VL_Tabela.FieldByName('ID').AsInteger = 0)) then
                begin
                    //verifica se o modulo_func ja foi cadastrado
                    VL_TModuloFunc.Close;
                    VL_TModuloFunc.SQL.Text := 'SELECT FIRST 1 ID FROM MODULO_FUNCAO WHERE MODULO_ID=''' +
                        VL_Tabela.FieldByName('MODULO_ID').AsString + ''' AND TAG_NUMERO=''' +
                        VL_Tabela.FieldByName('TAG_NUMERO').AsString + '''';
                    VL_Erro := 55;
                    VL_Linha := '270520221115';
                    VL_TModuloFunc.Open;

                    if VL_TModuloFunc.RecordCount > 0 then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('007E', 'R');
                        VL_Mensagem.AddTag('004D', '43');//duplicidade
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        VL_Erro := 43;
                        VL_Linha := '050520220928';
                        GravaLog(F_ArquivoLog, 0, '007E', 'cadastro', VL_Linha,
                            'registro em duplicidade na tabela modulo_func, ja existe uma função cadastrada com este modulo e esta tag', '', VL_Erro);
                        Exit;
                    end;
                    //TESTA CAMPOS OBRIGATORIOS
                    if ((length(VL_Tabela.FieldByName('MODULO_ID').AsString) = 0) or
                        (length(VL_Tabela.FieldByName('TAG_NUMERO').AsString) = 0)) then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('007E', 'R');
                        VL_Mensagem.AddTag('004D', '52');//campos nulos
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        VL_Erro := 52;
                        VL_Linha := '050520220929';
                        GravaLog(F_ArquivoLog, 0, '007E', 'cadastro', VL_Linha,
                            'campos obrigatório não pode ser nulo na inclusão de registro na tabela modulo_func',
                            '', VL_Erro);
                        Exit;
                    end;
                    //COMEÇA A INSERIR
                    VL_TModuloFunc.Close;
                    VL_TModuloFunc.SQL.Text := 'INSERT INTO MODULO_FUNCAO(' +
                        'MODULO_ID,' +
                        'TAG_NUMERO)VALUES(' +
                        IntToStr(VL_Tabela.FieldByName('MODULO_ID').AsInteger) + ',''' +
                        VL_Tabela.FieldByName('TAG_NUMERO').AsString + ''')';
                    VL_Erro := 44;
                    VL_Linha := '270520221120';
                    VL_TModuloFunc.ExecSQL;

                    //CARREGA TABELA CADASTRADA
                    VL_TModuloFunc.Close;
                    VL_TModuloFunc.SQL.Text := 'SELECT FIRST 1 ID FROM MODULO_FUNCAO WHERE MODULO_ID=''' +
                        VL_Tabela.FieldByName('MODULO_ID').AsString + ''' AND TAG_NUMERO=''' +
                        VL_Tabela.FieldByName('TAG_NUMERO').AsString + '''';
                    VL_Erro := 55;
                    VL_Linha := '310520221230';
                    VL_TModuloFunc.Open;

                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('007E', 'R');
                    VL_Mensagem.AddTag('004D', '0');
                    VL_Mensagem.AddTag('008B', VL_TModuloFunc.FieldByName('ID').AsString);
                    DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                    exit;
                end;
                VL_Tabela.Next;
            end;
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('007E', 'R');
            VL_Mensagem.AddTag('004D', '44');
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '007E', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '007E', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_Tabela.Free;
            VL_TModuloFunc.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '007E', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando007F(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro MODULO_FUNC EXCLUIR
var
    VL_Mensagem: TMensagem;
    VL_TModuloFunc: TZQuery;
    VL_Tag: ansistring;
    VL_MODULO_FUNCAO_ID: int64;
    VL_Linha: string;
    VL_Erro: integer;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TModuloFunc := TZQuery.Create(DComunicador);
    VL_TModuloFunc.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Linha := '';
    VL_Erro := 0;
    VL_MODULO_FUNCAO_ID := 0;
    try
        try
            //verifica parametros
            VP_Mensagem.GetTag('008B', VL_MODULO_FUNCAO_ID);  // ID DA TABELA  MODULO_FUNCAO

            if VL_MODULO_FUNCAO_ID = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('007F', 'R');
                VL_Mensagem.AddTag('004D', '47'); //DADOS INFORMADO NULO
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '270520221203';
                GravaLog(F_ArquivoLog, 0, '007F', 'CADASTRO', VL_Linha, 'parametro informado na Tag: 007F não pode estar zerada ou nula', '', VL_Erro);
                Exit;
            end;
            //verifica permissao
            if TTConexao(VP_AContext.Data).Permissao <> pmC then   // nao tem permissao para dar manutencao ao cadastro de modulo funcao
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('007F', 'R');
                VL_Mensagem.AddTag('004D', '45');  //sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '030520221235';
                GravaLog(F_ArquivoLog, 0, '007F', 'CADASTRO', VL_Linha, 'nao tem permissao para dar manutencao ao cadastro de modulo funcao', '', VL_Erro);
                Exit;
            end;
            //verifica se existe o id pra modulo_função
            VL_TModuloFunc.Close;
            VL_TModuloFunc.SQL.Text := 'SELECT * FROM MODULO_FUNCAO WHERE ID=' + IntToStr(VL_MODULO_FUNCAO_ID);
            VL_Erro := 55;
            VL_Linha := '270520221205';
            VL_TModuloFunc.Open;

            if VL_TModuloFunc.RecordCount > 0 then
            begin
                //exclui o modulo_func
                VL_TModuloFunc.Close;
                VL_TModuloFunc.SQL.Text := 'DELETE FROM MODULO_FUNCAO WHERE ' +
                    'ID=' + IntToStr(VL_MODULO_FUNCAO_ID);
                VL_Erro := 46;
                VL_Linha := '270520221206';
                VL_TModuloFunc.ExecSQL;

                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('007F', 'R');
                VL_Mensagem.AddTag('004D', '0');
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
            end
            else
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('007F', 'R');
                VL_Mensagem.AddTag('004D', '48');
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 48;
                VL_Linha := '270520221208';
                GravaLog(F_ArquivoLog, 0, '007F', 'cadastro', VL_Linha, 'não foi encontrado o registro numero:' + IntToStr(VL_MODULO_FUNCAO_ID) +
                    ' na tabela modulo_funcao', '', VL_Erro);
            end;
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '007F', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '007F', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_TModuloFunc.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '007F', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando0085(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro MODULO_CONF_FUNC ALTERAR
var
    VL_Mensagem: TMensagem;
    VL_TModulo_Conf_Funcao: TZQuery;
    VL_Tag: ansistring;
    VL_Modulo_Conf_Funcao_ID: int64;
    VL_Linha: string;
    VL_Erro: integer;
    VL_Habilitado: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TModulo_Conf_Funcao := TZQuery.Create(DComunicador);
    VL_TModulo_Conf_Funcao.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Linha := '';
    VL_Habilitado := '';
    VL_Erro := 0;
    VL_Modulo_Conf_Funcao_ID := 0;
    try
        try
            //verifica parametros
            VP_Mensagem.GetTag('006D', VL_Modulo_Conf_Funcao_ID);  // ID DA TABELA  MODULO_CONF_FUNCAO
            VP_Mensagem.GetTag('0086', VL_Habilitado);  // HABILITADO DA TABELA  MODULO_CONF_FUNCAO

            if VL_Modulo_Conf_Funcao_ID = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0085', 'R');
                VL_Mensagem.AddTag('004D', '47');//PARAMETRO VAZIO
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '030620221448';
                GravaLog(F_ArquivoLog, 0, '0085', 'CADASTRO', VL_Linha, 'o parametro informado na Tag:006D esta nulo ou zerado', '', VL_Erro);
                Exit;
            end;
            //verifica permissao
            if TTConexao(VP_AContext.Data).Permissao <> pmC then   // nao tem permissao para dar manutencao ao cadastro de modulo_conf_funcao
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0085', 'R');
                VL_Mensagem.AddTag('004D', '45');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '260520220850';
                GravaLog(F_ArquivoLog, 0, '0085', 'CADASTRO', VL_Linha, 'nao tem permissao para dar manutencao ao cadastro de modulo_conf_funcao',
                    '', VL_Erro);
                Exit;
            end;
            //verifica se existe o id pra modulo_conf_funcao
            VL_TModulo_Conf_Funcao.Close;
            VL_TModulo_Conf_Funcao.SQL.Text := 'SELECT * FROM MODULO_CONF_FUNCAO WHERE ID=' + IntToStr(VL_Modulo_Conf_Funcao_ID);
            VL_Erro := 55;
            VL_Linha := '030620221449';
            VL_TModulo_Conf_Funcao.Open;

            if VL_TModulo_Conf_Funcao.RecordCount > 0 then
            begin
                //ALTERA o modulo_conf_funcao
                VL_TModulo_Conf_Funcao.Close;
                VL_TModulo_Conf_Funcao.SQL.Text := 'UPDATE MODULO_CONF_FUNCAO SET HABILITADO=''' + VL_HABILITADO + ''' WHERE ' +
                    'ID=' + IntToStr(VL_Modulo_Conf_Funcao_ID);
                VL_Erro := 46;
                VL_Linha := '030620221450';
                VL_TModulo_Conf_Funcao.ExecSQL;

                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0085', 'R');
                VL_Mensagem.AddTag('004D', '0');
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
            end
            else
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0085', 'R');
                VL_Mensagem.AddTag('004D', '48');
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
            end;
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '0085', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '0085', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_TModulo_Conf_Funcao.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '0085', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando0087(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro LOJA_MODULO_CONF_FUNCAO EXCLUIR
var
    VL_Mensagem: TMensagem;
    VL_TLoja_Modulo_Conf_Funcao: TZQuery;
    VL_Tag: ansistring;
    VL_Loja_Modulo_Conf_Funcao_ID: int64;
    VL_Linha: string;
    VL_Erro: integer;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TLoja_Modulo_Conf_Funcao := TZQuery.Create(DComunicador);
    VL_TLoja_Modulo_Conf_Funcao.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Linha := '';
    VL_Erro := 0;
    VL_Loja_Modulo_Conf_Funcao_ID := 0;
    try
        try
            //verifica parametros
            VP_Mensagem.GetTag('00BC', VL_Loja_Modulo_Conf_Funcao_ID);  // ID DA TABELA  LOJA_MODULO_CONF_FUNCAO

            if VL_Loja_Modulo_Conf_Funcao_ID = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0087', 'R');
                VL_Mensagem.AddTag('004D', '47');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '020620221534';
                GravaLog(F_ArquivoLog, 0, '0087', 'CADASTRO', VL_Linha, 'o parametro informado na Tag:00BC esta nulo ou zerado', '', VL_Erro);
                Exit;
            end;
            //verifica permissao
            if TTConexao(VP_AContext.Data).Permissao <> pmC then   // nao tem permissao para dar manutencao ao cadastro de modulo funcao
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0087', 'R');
                VL_Mensagem.AddTag('004D', '45');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '260520221727';
                GravaLog(F_ArquivoLog, 0, '0087', 'CADASTRO', VL_Linha, 'nao tem permissao para dar manutencao ao cadastro de loja_modulo_conf_funcao',
                    '', VL_Erro);
                Exit;
            end;

            //verifica se existe o id pra modulo_função
            VL_TLoja_Modulo_Conf_Funcao.Close;
            VL_TLoja_Modulo_Conf_Funcao.SQL.Text := 'SELECT * FROM LOJA_MODULO_CONF_FUNCAO WHERE ID=' + IntToStr(VL_Loja_Modulo_Conf_Funcao_ID);
            VL_Erro := 55;
            VL_Linha := '020620221536';
            VL_TLoja_Modulo_Conf_Funcao.Open;

            if VL_TLoja_Modulo_Conf_Funcao.RecordCount > 0 then
            begin
                //exclui a loja_modulo_conf_funcao
                VL_TLoja_Modulo_Conf_Funcao.Close;
                VL_TLoja_Modulo_Conf_Funcao.SQL.Text := 'DELETE FROM LOJA_MODULO_CONF_FUNCAO WHERE ID=' + IntToStr(VL_Loja_Modulo_Conf_Funcao_ID);
                VL_Erro := 82;
                VL_Linha := '020620221537';
                VL_TLoja_Modulo_Conf_Funcao.ExecSQL;
            end;
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('0087', 'R');
            VL_Mensagem.AddTag('004D', '0');
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '0087', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '0087', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_TLoja_Modulo_Conf_Funcao.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '0087', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando0088(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro MULTLOJA_MODULO_CONF_FUNCAO EXCLUIR
var
    VL_Mensagem: TMensagem;
    VL_TMultiLoja_Modulo_Conf_Funcao: TZQuery;
    VL_Tag: ansistring;
    VL_MultiLoja_Modulo_Conf_Funcao_ID: int64;
    VL_Linha: string;
    VL_Erro: integer;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TMultiLoja_Modulo_Conf_Funcao := TZQuery.Create(DComunicador);
    VL_TMultiLoja_Modulo_Conf_Funcao.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Linha := '';
    VL_Erro := 0;
    VL_MultiLoja_Modulo_Conf_Funcao_ID := 0;
    try
        try
            //verifica parametros de entrada
            VP_Mensagem.GetTag('00BD', VL_MultiLoja_Modulo_Conf_Funcao_ID);  // ID DA TABELA  LOJA_MODULO_CONF_FUNCAO

            if (VL_MultiLoja_Modulo_Conf_Funcao_ID = 0) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0088', 'R');
                VL_Mensagem.Addtag('004D', '47'); //dados informados não podem ser zero 0
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '270520220933';
                GravaLog(F_ArquivoLog, 0, '0088', 'CADASTRO', VL_Linha,
                    'o parametro informado na tag 00BD(multiloja_modulo_conf_funcao_id) não pode ser zero ou nulo',
                    '', VL_Erro);
                exit;
            end;
            //verifica permissao
            if TTConexao(VP_AContext.Data).Permissao <> pmC then   // nao tem permissao para dar manutencao ao cadastro de modulo funcao
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0088', 'R');
                VL_Mensagem.Addtag('004D', '45'); //permissao não autorizada
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '270520220938';
                GravaLog(F_ArquivoLog, 0, '0088', 'CADASTRO', VL_Linha, 'nao tem permissao para dar manutencao ao cadastro de multiloja_modulo_conf_funcao',
                    '', VL_Erro);
                Exit;
            end;

            //verifica se existe o id pra multiloja_modulo_conf_função
            VL_TMultiLoja_Modulo_Conf_Funcao.Close;
            VL_TMultiLoja_Modulo_Conf_Funcao.SQL.Text := 'SELECT * FROM MULTILOJA_MODULO_CONF_FUNCAO WHERE ID=' + IntToStr(VL_MultiLoja_Modulo_Conf_Funcao_ID);
            VL_Erro := 55;
            VL_Linha := '270520220942';
            VL_TMultiLoja_Modulo_Conf_Funcao.Open;

            if VL_TMultiLoja_Modulo_Conf_Funcao.RecordCount > 0 then
            begin
                //exclui a multiloja_modulo_conf_funcao
                VL_TMultiLoja_Modulo_Conf_Funcao.Close;
                VL_TMultiLoja_Modulo_Conf_Funcao.SQL.Text := 'DELETE FROM MULTILOJA_MODULO_CONF_FUNCAO WHERE ' +
                    'ID=' + IntToStr(VL_MultiLoja_Modulo_Conf_Funcao_ID);
                VL_Erro := 82;
                VL_Linha := '270520220943';
                VL_TMultiLoja_Modulo_Conf_Funcao.ExecSQL;
            end
            else
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0088', 'R');
                VL_Mensagem.AddTag('004D', '48'); //TABELA SEM REGISTRO
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 48;
                VL_Linha := '270520220947';
                GravaLog(F_ArquivoLog, 0, '0088', 'CADASTRO',
                    VL_Linha, 'não existe registro na tabela multilolja_modulo_conf_funcao com o parametro informado ID:' +
                    IntToStr(VL_MultiLoja_Modulo_Conf_Funcao_ID), '', VL_Erro);
                exit;
            end;
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('0088', 'R');
            VL_Mensagem.AddTag('004D', '0');
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
            Exit;
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                        //FreeAndNil(DNucleo);
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '0088', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '0088', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_TMultiLoja_Modulo_Conf_Funcao.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                    //FreeAndNil(DNucleo);
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '0088', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando008A(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro MODULO_CONF_FUNCAO EXCLUIR
var
    VL_Mensagem: TMensagem;
    VL_TModulo_Conf_Funcao: TZQuery;
    VL_Tag: ansistring;
    VL_Modulo_Conf_Funcao_ID: int64;
    VL_Linha: string;
    VL_Erro: integer;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TModulo_Conf_Funcao := TZQuery.Create(DComunicador);
    VL_TModulo_Conf_Funcao.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Linha := '';
    VL_Erro := 0;
    VL_Modulo_Conf_Funcao_ID := 0;
    try
        try
            //verifica parametros de entrada
            VP_Mensagem.GetTag('006D', VL_Modulo_Conf_Funcao_ID);  // ID DA TABELA  MODULO_CONF_FUNCAO

            if (VL_Modulo_Conf_Funcao_ID = 0) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('008A', 'R');
                VL_Mensagem.Addtag('004D', '47'); //dados informados não podem ser zero 0
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '270520221237';
                GravaLog(F_ArquivoLog, 0, '008A', 'CADASTRO', VL_Linha,
                    'o parametro informado na Tag: 006D não pode ser zero ou nulo',
                    '', VL_Erro);
                exit;
            end;
            //verifica permissao
            if TTConexao(VP_AContext.Data).Permissao <> pmC then   // nao tem permissao para dar manutencao ao cadastro de modulo funcao
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('008A', 'R');
                VL_Mensagem.Addtag('004D', '45'); //permissao não autorizada
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '270520221238';
                GravaLog(F_ArquivoLog, 0, '008A', 'CADASTRO', VL_Linha, 'nao tem permissao para dar manutencao ao cadastro de modulo_conf_funcao',
                    '', VL_Erro);
                Exit;
            end;
            //verifica se existe o id pra modulo_conf_função
            VL_TModulo_Conf_Funcao.Close;
            VL_TModulo_Conf_Funcao.SQL.Text := 'SELECT * FROM MODULO_CONF_FUNCAO WHERE ID=' + IntToStr(VL_Modulo_Conf_Funcao_ID);
            VL_Erro := 55;
            VL_Linha := '270520221239';
            VL_TModulo_Conf_Funcao.Open;

            if VL_TModulo_Conf_Funcao.RecordCount > 0 then
            begin
                //exclui a modulo_conf_funcao
                VL_TModulo_Conf_Funcao.Close;
                VL_TModulo_Conf_Funcao.SQL.Text := 'DELETE FROM MODULO_CONF_FUNCAO WHERE ' +
                    'ID=' + IntToStr(VL_Modulo_Conf_Funcao_ID);
                VL_Erro := 82;
                VL_Linha := '270520221240';
                VL_TModulo_Conf_Funcao.ExecSQL;

                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('008A', 'R');
                VL_Mensagem.AddTag('004D', '0');
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                Exit;
            end
            else
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('008A', 'R');
                VL_Mensagem.AddTag('004D', '48');//TABELA SEM REGISTRO
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 48;
                VL_Linha := '270520221241';
                GravaLog(F_ArquivoLog, 0, '008A', 'CADASTRO',
                    VL_Linha, 'não existe registro na tabela modulo_conf_funcao com o parametro informado ID:' +
                    IntToStr(VL_Modulo_Conf_Funcao_ID), '', VL_Erro);
            end;
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '008A', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '008A', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_TModulo_Conf_Funcao.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '008A', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando0096(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro MULTLOJA_MODULO INCLUIR
var
    VL_Mensagem: TMensagem;
    VL_Tabela: TRxMemoryData;
    VL_TMultLojaModulo: TZQuery;
    VL_Tag: ansistring;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_Tabela := TRxMemoryData.Create(nil);
    VL_TMultLojaModulo := TZQuery.Create(DComunicador);
    VL_TMultLojaModulo.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Linha := '';
    VL_Erro := 0;
    try
        try
            //verifica permissao
            if ((TTConexao(VP_AContext.Data).Permissao = pmU) or (TTConexao(VP_AContext.Data).Permissao = pmS)) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0096', 'R');
                VL_Mensagem.AddTag('004D', '45');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '120520220818';
                GravaLog(F_ArquivoLog, 0, '0096', 'cadastro', VL_Linha, 'sem permissão para gerenciar a inclusão de registro na tabela multloja_modulo',
                    '', VL_Erro);
                Exit;
            end;
            VP_Mensagem.GetTag('0094', VL_Tag); //CARREGA TABELA MULTILOJA_MODULO_CONF
            if Length(VL_TAG) = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0096', 'R');
                VL_Mensagem.AddTag('004D', '47');//PARAMETRO ZERADO
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '020620220929';
                GravaLog(F_ArquivoLog, 0, '0096', 'cadastro', VL_Linha, 'parametro informado na Tag:0094 esta nulo ou zerado', '', VL_Erro);
                Exit;
            end;
            StrToRxMemData(VL_Tag, VL_Tabela);
            VL_Tabela.Open;
            VL_Tabela.First;
            while not VL_Tabela.EOF do
            begin
                if (VL_Tabela.FieldByName('ID').AsInteger = 0) then
                begin
                    //verifica se o modulo_func ja foi cadastrado
                    VL_TMultLojaModulo.Close;
                    VL_TMultLojaModulo.SQL.Text := 'SELECT FIRST 1 ID FROM MULTILOJA_MODULO_CONF WHERE MODULO_CONF_ID=''' +
                        VL_Tabela.FieldByName('MODULO_CONF_ID').AsString + ''' AND CODIGO=''' +
                        VL_Tabela.FieldByName('CODIGO').AsString + '''';
                    VL_Erro := 55;
                    VL_Linha := '020620220931';
                    VL_TMultLojaModulo.Open;
                    if VL_TMultLojaModulo.RecordCount > 0 then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('0096', 'R');
                        VL_Mensagem.AddComando('004D', '43');//duplicidade
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        VL_Erro := 43;
                        VL_Linha := '120520220819';
                        GravaLog(F_ArquivoLog, 0, '0096', 'cadastro', VL_Linha,
                            'registro em duplicidade na tabela multloja_modulo, ja existe um modulo config cadastrada com este ID:' +
                            VL_Tabela.FieldByName('MULTILOJA_ID').AsString, '', VL_Erro);
                        Exit;
                    end;
                    VL_TMultLojaModulo.Close;
                    VL_TMultLojaModulo.SQL.Text := 'INSERT INTO MULTILOJA_MODULO_CONF(' +
                        'MULTILOJA_ID,' +
                        'HABILITADO,' +
                        'MODULO_CONF_ID,' +
                        'CODIGO)VALUES(' +
                        IntToStr(VL_Tabela.FieldByName('MULTILOJA_ID').AsInteger) + ',''' +
                        VL_Tabela.FieldByName('HABILITADO').AsString + ''',' +
                        IntToStr(VL_Tabela.FieldByName('MODULO_CONF_ID').AsInteger) + ',''' +
                        VL_Tabela.FieldByName('CODIGO').AsString + ''')';
                    VL_Erro := 44;
                    VL_Linha := '020620220934';
                    VL_TMultLojaModulo.ExecSQL;

                    VL_TMultLojaModulo.Close;
                    VL_TMultLojaModulo.SQL.Text := 'SELECT * FROM MULTILOJA_MODULO_CONF WHERE MODULO_CONF_ID=''' +
                        VL_Tabela.FieldByName('MODULO_CONF_ID').AsString + ''' AND CODIGO=''' +
                        VL_Tabela.FieldByName('CODIGO').AsString + '''';
                    VL_Erro := 55;
                    VL_Linha := '020620220935';
                    VL_TMultLojaModulo.Open;

                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('0096', 'R');
                    VL_Mensagem.AddTag('004D', '0');
                    VL_Mensagem.AddTag('0097', VL_TMultLojaModulo.FieldByName('ID').AsString); //MULTLOJA_MODULO_ID
                    DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                    exit;
                end;
                VL_Tabela.Next;
            end;
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('0096', 'R');
            VL_Mensagem.AddTag('004D', '44');
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '0096', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '0096', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_Tabela.Free;
            VL_TMultLojaModulo.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '0096', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando0099(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro MULTLOJA_MODULO EXCLUIR
var
    VL_Mensagem: TMensagem;
    VL_TMultLoja_Modulo: TZQuery;
    VL_Tag: ansistring;
    VL_ID: int64;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TMultLoja_Modulo := TZQuery.Create(DComunicador);
    VL_TMultLoja_Modulo.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_ID := 0;
    VL_Erro := 0;
    VL_Linha := '';
    try
        try
            //verifica parametros
            VP_Mensagem.GetTag('0097', VL_ID); // multloja_modulo_id
            if VL_ID = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0099', 'R');
                VL_Mensagem.AddTag('004D', '47');//campo não pode ser zero
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '120520221012';
                GravaLog(F_ArquivoLog, 0, '0099', 'cadastro', VL_Linha, 'campo id para exclusão na tabela multloja_modulo não pode ser zero', '', VL_Erro);
                Exit;
            end;
            //verifica permissao
            if ((TTConexao(VP_AContext.Data).Permissao = pmU) or (TTConexao(VP_AContext.Data).Permissao = pmS)) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0099', 'R');
                VL_Mensagem.AddTag('004D', '45');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '120520221013';
                GravaLog(F_ArquivoLog, 0, '0099', 'cadastro', VL_Linha, 'sem permissão para gerenciar exclusão na tabela multloja_modulo', '', VL_Erro);
                Exit;
            end;
            //verifica se existe o id pra exclusão
            VL_TMultLoja_Modulo.Close;
            VL_TMultLoja_Modulo.SQL.Text := 'SELECT * FROM MULTILOJA_MODULO_CONF WHERE ID=' + IntToStr(VL_ID);
            VL_Erro := 55;
            VL_Linha := '020620221007';
            VL_TMultLoja_Modulo.Open;

            if VL_TMultLoja_Modulo.RecordCount = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('0099', 'R');
                VL_Mensagem.AddTag('004D', '48'); // id não encontrado na tabela
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 48;
                VL_Linha := '120520221014';
                GravaLog(F_ArquivoLog, 0, '0099', 'cadastro', VL_Linha, 'campo informado ID numero:' + IntToStr(VL_ID) +
                    ' para exclusão não foi localizado na tabela multiloja_modulo', '', VL_Erro);
                Exit;
            end;
            //exclui multloja_modulo
            VL_TMultLoja_Modulo.Close;
            VL_TMultLoja_Modulo.SQL.Text := 'DELETE FROM MULTILOJA_MODULO_CONF WHERE ' + 'ID=' + IntToStr(VL_ID);
            VL_Erro := 82;
            VL_Linha := '020620221008';
            VL_TMultLoja_Modulo.ExecSQL;

            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('0099', 'R');
            VL_Mensagem.AddTag('004D', '0');
            VL_Mensagem.AddTag('0097', VL_ID); //multloja_modulo_id
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '0099', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '0099', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_TMultLoja_Modulo.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '0099', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando009A(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro MULTLOJA_MODULO ALTERAR
var
    VL_Mensagem: TMensagem;
    VL_TMultLoja_Modulo: TZQuery;
    VL_Tabela: TRxMemoryData;
    VL_Tag: ansistring;
    VL_ID: int64;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TMultLoja_Modulo := TZQuery.Create(DComunicador);
    VL_TMultLoja_Modulo.Connection := DNucleo.ZConexao;
    VL_Tabela := TRxMemoryData.Create(nil);
    VL_Tag := '';
    VL_ID := 0;
    VL_Erro := 0;
    VL_Linha := '';
    try
        try
            //verifica permissão
            if ((TTConexao(VP_AContext.Data).Permissao = pmU) or (TTConexao(VP_AContext.Data).Permissao = pmS)) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('009A', 'R');
                VL_Mensagem.AddTag('004D', '45'); //sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '120520221034';
                GravaLog(F_ArquivoLog, 0, '009A', 'cadastro', VL_Linha, 'sem permissão para gerenciar a alteração de dados da tabela multloja_modulo_conf',
                    '', VL_Erro);
                Exit;
            end;
            VP_Mensagem.GetTag('0094', VL_Tag); //carrega tabela multloja_modulo
            if Length(VL_Tag) = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('009A', 'R');
                VL_Mensagem.AddTag('004D', '47'); //PARAMETRO INFORMADO NULO
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '020620220953';
                GravaLog(F_ArquivoLog, 0, '009A', 'cadastro', VL_Linha, 'parametro informado na Tag:0094 esta nulo ou zerado', '', VL_Erro);
                Exit;
            end;
            StrToRxMemData(VL_Tag, VL_Tabela);
            VL_Tabela.Open;

            VP_Mensagem.GetTag('0097', VL_ID); //multloja_modulo_id
            if VL_ID < 1 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('009A', 'R');
                VL_Mensagem.AddTag('004D', '47');//dados informado não pode ser zero
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '120520221222';
                GravaLog(F_ArquivoLog, 0, '009A', 'cadastro', VL_Linha,
                    'alteração não executada, o id informado da multloja_modulo_conf não pode ser zero', '', VL_Erro);
                Exit;
            end;
            //verifica se existe o registro para alterar
            VL_TMultLoja_Modulo.Close;
            VL_TMultLoja_Modulo.SQL.Text := 'SELECT * FROM MULTILOJA_MODULO_CONF WHERE ID=' + IntToStr(VL_ID);
            VL_Erro := 55;
            VL_Linha := '020620220956';
            VL_TMultLoja_Modulo.Open;

            if VL_TMultLoja_Modulo.RecordCount = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('009A', 'R');
                VL_Mensagem.AddTag('004D', '48'); //registro não localizado
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 48;
                VL_Linha := '120520221037';
                GravaLog(F_ArquivoLog, 0, '009A', 'cadastro', VL_Linha, 'o registro numero:' + IntToStr(VL_ID) +
                    ' informado não foi encontrado na tabela multloja_modulo_conf',
                    '', VL_Erro);
                Exit;
            end;
            if VL_Tabela.Locate('ID', VL_ID, []) then
            begin
                if ((VL_Tabela.FieldByName('ID').AsInteger <> VL_TMultLoja_Modulo.FieldByName('ID').AsInteger) or
                    (VL_Tabela.FieldByName('MULTILOJA_ID').AsInteger <> VL_TMultLoja_Modulo.FieldByName('MULTILOJA_ID').AsInteger)) then
                begin
                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('009A', 'R');
                    VL_Mensagem.AddTag('004D', '49'); //dados chaves não podem sofer alteração
                    DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                    VL_Erro := 49;
                    VL_Linha := '120520221038';
                    GravaLog(F_ArquivoLog, 0, '003F', 'cadastro', VL_Linha,
                        'dados chaves não podem sofer alteração(id/multiloja_id) na tabela multloja_modulo_conf não pode alterar',
                        '', VL_Erro);
                    Exit;
                end;
                VL_TMultLoja_Modulo.Close;
                VL_TMultLoja_Modulo.SQL.Text := 'UPDATE MULTILOJA_MODULO_CONF SET ' + 'HABILITADO=''' + VL_Tabela.FieldByName('HABILITADO').AsString + ''',' +
                    'MODULO_CONF_ID=''' + IntToStr(VL_Tabela.FieldByName('MODULO_CONF_ID').AsInteger) + ''',' + 'CODIGO=''' +
                    VL_Tabela.FieldByName('CODIGO').AsString + ''' WHERE ' + 'ID=' + IntToStr(VL_ID);
                VL_Erro := 46;
                VL_Linha := '020620221000';
                VL_TMultLoja_Modulo.ExecSQL;

                VL_TMultLoja_Modulo.Close;
                VL_TMultLoja_Modulo.SQL.Text := 'SELECT * FROM MULTILOJA_MODULO_CONF WHERE ID=' + IntToStr(VL_ID);
                VL_Erro := 55;
                VL_Linha := '020620221001';
                VL_TMultLoja_Modulo.Open;

                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('009A', 'R');
                VL_Mensagem.AddTag('004D', '0');
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
            end;
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('009A', 'R');
            VL_Mensagem.AddTag('004D', '46');
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '009A', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '009A', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_Tabela.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '009A', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando009B(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro LOJA_MODULO_CONF_FUNCAO INCLUIR
var
    VL_Mensagem: TMensagem;
    VL_Tabela: TRxMemoryData;
    VL_TLojaModuloConfFuncao: TZQuery;
    VL_Tag: ansistring;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_Tabela := TRxMemoryData.Create(nil);
    VL_TLojaModuloConfFuncao := TZQuery.Create(DComunicador);
    VL_TLojaModuloConfFuncao.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Linha := '';
    VL_Erro := 0;
    try
        try
            //verifica permissao
            if TTConexao(VP_AContext.Data).Permissao <> pmC then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('009B', 'R');
                VL_Mensagem.Addtag('004D', '45');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '260520221653';
                GravaLog(F_ArquivoLog, 0, '009B', 'cadastro', VL_Linha,
                    'sem permissão para gerenciar a inclusão de registro na tabela loja_modulo_conf_funcao',
                    '', VL_Erro);
                Exit;
            end;
            //verifica parametros
            VP_Mensagem.GetTag('0098', VL_Tag); //tabela loja_modulo_conf_funcao
            if Length(VL_Tag) = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('009B', 'R');
                VL_Mensagem.Addtag('004D', '47');//PARAMETRO VAZIO
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '010620220835';
                GravaLog(F_ArquivoLog, 0, '009B', 'cadastro', VL_Linha, 'parametro informado na Tag:0098 está nula ou vazia', '', VL_Erro);
            end;
            StrToRxMemData(VL_Tag, VL_Tabela);
            VL_Tabela.Open;

            VL_Tabela.First;
            while not VL_Tabela.EOF do
            begin
                if ((VL_Tabela.FieldByName('VALIDADO').AsBoolean = True) and (VL_Tabela.FieldByName('ID').AsInteger = 0)) then
                begin
                    //verifica se a loja_modulo_conf_func ja foi cadastrado
                    VL_TLojaModuloConfFuncao.Close;
                    VL_TLojaModuloConfFuncao.SQL.Text := 'SELECT FIRST 1 ID FROM LOJA_MODULO_CONF_FUNCAO WHERE LOJA_MODULO_CONF_ID=''' +
                        VL_Tabela.FieldByName('LOJA_MODULO_CONF_ID').AsString + ''' AND TAG_NUMERO=''' +
                        VL_Tabela.FieldByName('TAG_NUMERO').AsString + '''';
                    VL_Erro := 55;
                    VL_Linha := '010620220836';
                    VL_TLojaModuloConfFuncao.Open;

                    if VL_TLojaModuloConfFuncao.RecordCount > 0 then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('009B', 'R');
                        VL_Mensagem.AddTag('004D', '43');//duplicidade
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        VL_Erro := 43;
                        VL_Linha := '260520221656';
                        GravaLog(F_ArquivoLog, 0, '009B', 'cadastro', VL_Linha,
                            'registro em duplicidade na tabela loja_modulo_conf_funcao, ja existe uma função cadastrada com este loja_modulo_conf e esta tag',
                            '', VL_Erro);
                        Exit;
                    end;
                    //TESTA CAMPOS OBRIGATORIOS
                    if ((length(VL_Tabela.FieldByName('LOJA_MODULO_CONF_ID').AsString) = 0) or
                        (length(VL_Tabela.FieldByName('TAG_NUMERO').AsString) = 0)) then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('009B', 'R');
                        VL_Mensagem.AddComando('004D', '52');//campos nulos
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        VL_Erro := 52;
                        VL_Linha := '260520221657';
                        GravaLog(F_ArquivoLog, 0, '009B', 'cadastro', VL_Linha,
                            'campos obrigatório não pode ser nulo na inclusão de registro na tabela loja_modulo_conf_funcao',
                            '', VL_Erro);
                        Exit;
                    end;
                    //COMEÇA A INSERIR
                    VL_TLojaModuloConfFuncao.Close;
                    VL_TLojaModuloConfFuncao.SQL.Text := 'INSERT INTO LOJA_MODULO_CONF_FUNCAO(' +
                        'LOJA_MODULO_CONF_ID,' +
                        'TAG_NUMERO)VALUES(' +
                        IntToStr(VL_Tabela.FieldByName('LOJA_MODULO_CONF_ID').AsInteger) + ',''' +
                        VL_Tabela.FieldByName('TAG_NUMERO').AsString + ''')';
                    VL_Erro := 44;
                    VL_Linha := '010620220837';
                    VL_TLojaModuloConfFuncao.ExecSQL;

                    VL_TLojaModuloConfFuncao.Close;
                    VL_TLojaModuloConfFuncao.SQL.Text := 'SELECT * FROM LOJA_MODULO_CONF_FUNCAO WHERE LOJA_MODULO_CONF_ID=' + VL_Tabela.FieldByName(
                        'LOJA_MODULO_CONF_ID').AsString + ' AND TAG_NUMERO=''' + VL_Tabela.FieldByName('TAG_NUMERO').AsString + '''';
                    VL_Erro := 55;
                    VL_Linha := '010620220838';
                    VL_TLojaModuloConfFuncao.Open;

                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('009B', 'R');
                    VL_Mensagem.AddTag('004D', '0');
                    VL_Mensagem.AddTag('00BC', VL_TLojaModuloConfFuncao.FieldByName('ID').AsString);
                    DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                    exit;
                end;
                VL_Tabela.Next;
            end;
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('009B', 'R');
            VL_Mensagem.AddTag('004D', '44');
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '009B', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '009B', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_Tabela.Free;
            VL_TLojaModuloConfFuncao.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '009B', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando009D(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro MULTLOJA_FUNCAO INCLUIR
var
    VL_Mensagem: TMensagem;
    VL_Tabela: TRxMemoryData;
    VL_TMultLoja_Funcao: TZQuery;
    VL_Tag: ansistring;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_Tabela := TRxMemoryData.Create(nil);
    VL_TMultLoja_Funcao := TZQuery.Create(DComunicador);
    VL_TMultLoja_Funcao.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Linha := '';
    VL_Erro := 0;
    try
        try
            //verifica permissao
            if ((TTConexao(VP_AContext.Data).Permissao = pmU) or (TTConexao(VP_AContext.Data).Permissao = pmS)) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('009D', 'R');
                VL_Mensagem.AddTag('004D', '45');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '120520221407';
                GravaLog(F_ArquivoLog, 0, '009D', 'cadastro', VL_Linha, 'sem permissão para gerenciar a inclusão de registro na tabela multloja_funcao',
                    '', VL_Erro);
                Exit;
            end;
            //testa parametros
            VP_Mensagem.GetTag('009C', VL_Tag); //CARREGA TABELA MULTILOJA_FUNCAO
            if Length(VL_Tag) = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('009D', 'R');
                VL_Mensagem.AddTag('004D', '47');//PARAMETRO VAZIO
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '020620221120';
                GravaLog(F_ArquivoLog, 0, '009D', 'cadastro', VL_Linha, 'o parametro informado na Tag:009C esta nulo ou zerado', '', VL_Erro);
                Exit;
            end;
            StrToRxMemData(VL_Tag, VL_Tabela);
            VL_Tabela.Open;

            VL_Tabela.First;
            while not VL_Tabela.EOF do
            begin
                if (((VL_Tabela.FieldByName('VALIDADO').AsBoolean = True) or
                    (VL_Tabela.FieldByName('HABILITADO').AsBoolean = True)) and (VL_Tabela.FieldByName('ID').AsInteger = 0)) then
                begin
                    //verifica se o multloja_funcao ja foi cadastrado
                    VL_TMultLoja_Funcao.Close;
                    VL_TMultLoja_Funcao.SQL.Text := 'SELECT FIRST 1 ID FROM MULTILOJA_FUNCAO WHERE MULTILOJA_ID=''' +
                        VL_Tabela.FieldByName('MULTILOJA_ID').AsString + ''' AND TAG_NUMERO=''' +
                        VL_Tabela.FieldByName('TAG_NUMERO').AsString + '''';
                    VL_Erro := 55;
                    VL_Linha := '020620221122';
                    VL_TMultLoja_Funcao.Open;

                    if VL_TMultLoja_Funcao.RecordCount > 0 then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('009D', 'R');
                        VL_Mensagem.AddTag('004D', '43');//duplicidade
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        VL_Erro := 43;
                        VL_Linha := '120520221410';
                        GravaLog(F_ArquivoLog, 0, '009D', 'cadastro', VL_Linha,
                            'registro em duplicidade na tabela multloja_funcao, ja existe uma função cadastrada com esta mult-loja e esta tag', '', VL_Erro);
                        Exit;
                    end;
                    //TESTA CAMPOS OBRIGATORIOS
                    if ((length(VL_Tabela.FieldByName('MULTILOJA_ID').AsString) = 0) or
                        (length(VL_Tabela.FieldByName('TAG_NUMERO').AsString) = 0)) then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('009D', 'R');
                        VL_Mensagem.AddTag('004D', '52');//campos nulos
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        VL_Erro := 52;
                        VL_Linha := '120520221411';
                        GravaLog(F_ArquivoLog, 0, '009D', 'cadastro', VL_Linha,
                            'campos obrigatório não pode ser nulo na inclusão de registro na tabela multloja_funcao',
                            '', VL_Erro);
                        Exit;
                    end;
                    //COMEÇA A INCLUSAO
                    VL_TMultLoja_Funcao.Close;
                    VL_TMultLoja_Funcao.SQL.Text := 'INSERT INTO MULTILOJA_FUNCAO(' +
                        'MULTILOJA_ID,' +
                        'TAG_NUMERO)VALUES(' +
                        IntToStr(VL_Tabela.FieldByName('MULTILOJA_ID').AsInteger) + ',''' +
                        VL_Tabela.FieldByName('TAG_NUMERO').AsString + ''')';
                    VL_Erro := 44;
                    VL_Linha := '020620221125';
                    VL_TMultLoja_Funcao.ExecSQL;

                    VL_TMultLoja_Funcao.Close;
                    VL_TMultLoja_Funcao.SQL.Text := 'SELECT * FROM MULTILOJA_FUNCAO WHERE MULTILOJA_ID=' + VL_Tabela.FieldByName(
                        'MULTILOJA_ID').AsString + ' AND TAG_NUMERO=''' + VL_Tabela.FieldByName('TAG_NUMERO').AsString + '''';
                    VL_Erro := 55;
                    VL_Linha := '020620221126';
                    VL_TMultLoja_Funcao.Open;

                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('009D', 'R');
                    VL_Mensagem.AddTag('004D', '0');
                    VL_Mensagem.AddTag('009E', VL_TMultLoja_Funcao.FieldByName('ID').AsString);
                    DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                    exit;
                end;
                VL_Tabela.Next;
            end;
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '009D', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '009D', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_Tabela.Free;
            VL_TMultLoja_Funcao.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '009D', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando009F(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro MULTLOJA_FUNCAO ALTERAR
var
    VL_Mensagem: TMensagem;
    VL_TMultLoja_Funcao: TZQuery;
    VL_Tag: ansistring;
    VL_MultLoja_Funcao_ID: int64;
    VL_Linha: string;
    VL_Erro: integer;
    VL_Habilitado: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TMultLoja_Funcao := TZQuery.Create(DComunicador);
    VL_TMultLoja_Funcao.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Linha := '';
    VL_Habilitado := '';
    VL_Erro := 0;
    VL_MultLoja_Funcao_ID := 0;
    try
        try
            //verifica parametros
            VP_Mensagem.GetTag('009E', VL_MultLoja_Funcao_ID);  // ID DA TABELA  MODULO_FUNCAO
            VP_Mensagem.GetTag('00A1', VL_Habilitado);  // HABILITADO DA TABELA  MODULO_FUNCAO

            if VL_MultLoja_Funcao_ID = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('009F', 'R');
                VL_Mensagem.AddTag('004D', '47');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '020620221132';
                GravaLog(F_ArquivoLog, 0, '009F', 'CADASTRO', VL_Linha, 'o parametro informado na Tag:009E esta nulo ou zerado', '', VL_Erro);
                Exit;
            end;
            //verifica permissao
            if TTConexao(VP_AContext.Data).Permissao <> pmC then   // nao tem permissao para dar manutencao ao cadastro de modulo funcao
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('009F', 'R');
                VL_Mensagem.AddTag('004D', '45');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '230520221702';
                GravaLog(F_ArquivoLog, 0, '009F', 'CADASTRO', VL_Linha, 'nao tem permissao para dar manutencao ao cadastro de multloja funcao', '', VL_Erro);
                Exit;
            end;
            //verifica se existe o id pra modulo_função
            VL_TMultLoja_Funcao.Close;
            VL_TMultLoja_Funcao.SQL.Text := 'SELECT * FROM MULTILOJA_FUNCAO WHERE ID=' + IntToStr(VL_MultLoja_Funcao_ID);
            VL_Erro := 55;
            VL_Linha := '020620221134';
            VL_TMultLoja_Funcao.Open;

            if VL_TMultLoja_Funcao.RecordCount > 0 then
            begin
                //ALTERA o modulo_func
                VL_TMultLoja_Funcao.Close;
                VL_TMultLoja_Funcao.SQL.Text := 'UPDATE MULTILOJA_FUNCAO SET HABILITADO=''' + VL_HABILITADO + ''' WHERE ' +
                    'ID=' + IntToStr(VL_MultLoja_Funcao_ID);
                VL_Erro := 46;
                VL_Linha := '020620221135';
                VL_TMultLoja_Funcao.ExecSQL;
            end;
            VL_TMultLoja_Funcao.Close;
            VL_TMultLoja_Funcao.SQL.Text := 'SELECT * FROM MULTILOJA_FUNCAO WHERE ID=' + IntToStr(VL_MultLoja_Funcao_ID);
            VL_Erro := 55;
            VL_Linha := '020620221136';
            VL_TMultLoja_Funcao.Open;

            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('009F', 'R');
            VL_Mensagem.AddTag('004D', '0');
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
            Exit;
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '009F', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '009F', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_TMultLoja_Funcao.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '009F', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando00A0(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro MULTLOJA_FUNCAO EXCLUIR
var
    VL_Mensagem: TMensagem;
    VL_TMultLoja_Funcao: TZQuery;
    VL_Tag: ansistring;
    VL_MultLoja_Funcao_ID: int64;
    VL_Linha: string;
    VL_Erro: integer;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TMultLoja_Funcao := TZQuery.Create(DComunicador);
    VL_TMultLoja_Funcao.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Linha := '';
    VL_Erro := 0;
    VL_MultLoja_Funcao_ID := 0;
    try
        try
            //verifica parametros
            VP_Mensagem.GetTag('009E', VL_MultLoja_Funcao_ID);  // ID DA TABELA  MODULO_FUNCAO

            if VL_MultLoja_Funcao_ID = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00A0', 'R');
                VL_Mensagem.AddTag('004D', '47');//parametro nulo
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '020620221141';
                GravaLog(F_ArquivoLog, 0, '00A0', 'CADASTRO', VL_Linha, 'o parametro informado na Tag:009E esta nulo ou zerado', '', VL_Erro);
                Exit;
            end;
            //verifica permissao
            if TTConexao(VP_AContext.Data).Permissao <> pmC then   // nao tem permissao para dar manutencao ao cadastro de modulo funcao
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00A0', 'R');
                VL_Mensagem.AddTag('004D', '45');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '120520221423';
                GravaLog(F_ArquivoLog, 0, '00A0', 'CADASTRO', VL_Linha, 'nao tem permissao para dar manutencao ao cadastro de multloja funcao', '', VL_Erro);
                Exit;
            end;
            //verifica se existe o id pra modulo_função
            VL_TMultLoja_Funcao.Close;
            VL_TMultLoja_Funcao.SQL.Text := 'SELECT * FROM MULTILOJA_FUNCAO WHERE ID=' + IntToStr(VL_MultLoja_Funcao_ID);
            VL_Erro := 55;
            VL_Linha := '020620221143';
            VL_TMultLoja_Funcao.Open;

            if VL_TMultLoja_Funcao.RecordCount > 0 then
            begin
                //exclui o modulo_func
                VL_TMultLoja_Funcao.Close;
                VL_TMultLoja_Funcao.SQL.Text := 'DELETE FROM MULTILOJA_FUNCAO WHERE ' +
                    'ID=' + IntToStr(VL_MultLoja_Funcao_ID);
                VL_Erro := 82;
                VL_Linha := '020620221144';
                VL_TMultLoja_Funcao.ExecSQL;
            end;
            VL_TMultLoja_Funcao.Close;
            VL_TMultLoja_Funcao.SQL.Text := 'SELECT * FROM MULTILOJA_FUNCAO WHERE ID=' + IntToStr(VL_MultLoja_Funcao_ID);
            VL_Erro := 55;
            VL_Linha := '020620221145';
            VL_TMultLoja_Funcao.Open;

            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('00A0', 'R');
            VL_Mensagem.AddTag('004D', '0');
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
            Exit;
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '00A0', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '00A0', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_TMultLoja_Funcao.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '00A0', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando00AA(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro LOJA_FUNCAO INCLUIR
var
    VL_Mensagem: TMensagem;
    VL_Tabela: TRxMemoryData;
    VL_TLoja_Funcao: TZQuery;
    VL_Tag: ansistring;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_Tabela := TRxMemoryData.Create(nil);
    VL_TLoja_Funcao := TZQuery.Create(DComunicador);
    VL_TLoja_Funcao.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Linha := '';
    VL_Erro := 0;
    try
        try
            //verifica permissao
            if ((TTConexao(VP_AContext.Data).Permissao = pmU) or (TTConexao(VP_AContext.Data).Permissao = pmS)) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00AA', 'R');
                VL_Mensagem.AddTag('004D', '45');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '160520221608';
                GravaLog(F_ArquivoLog, 0, '00AA', 'cadastro', VL_Linha, 'sem permissão para gerenciar a inclusão de registro na tabela loja_funcao',
                    '', VL_Erro);
                Exit;
            end;
            //VERIFICA PARAMETROS
            VP_Mensagem.GetTag('00A7', VL_Tag); //tabela loja_modulo
            if Length(VL_Tag) = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00AA', 'R');
                VL_Mensagem.AddTag('004D', '47');//parametro vazio
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '020620221551';
                GravaLog(F_ArquivoLog, 0, '00AA', 'cadastro', VL_Linha, 'o parametro informado na Tag:00A7 esta nulo ou zerado', '', VL_Erro);
                Exit;
            end;
            StrToRxMemData(VL_Tag, VL_Tabela);
            VL_Tabela.Open;

            VL_Tabela.First;
            while not VL_Tabela.EOF do
            begin
                if ((VL_Tabela.FieldByName('VALIDADO').AsBoolean = True) and (VL_Tabela.FieldByName('ID').AsInteger = 0)) then
                begin
                    //verifica se o loja_funcao ja foi cadastrado
                    VL_TLoja_Funcao.Close;
                    VL_TLoja_Funcao.SQL.Text := 'SELECT FIRST 1 ID FROM LOJA_FUNCAO WHERE LOJA_ID=''' +
                        VL_Tabela.FieldByName('LOJA_ID').AsString + ''' AND TAG_NUMERO=''' +
                        VL_Tabela.FieldByName('TAG_NUMERO').AsString + '''';
                    VL_Erro := 55;
                    VL_Linha := '020620221553';
                    VL_TLoja_Funcao.Open;

                    if VL_TLoja_Funcao.RecordCount > 0 then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('00AA', 'R');
                        VL_Mensagem.AddTag('004D', '43');//duplicidade
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        VL_Erro := 43;
                        VL_Linha := '160520221609';
                        GravaLog(F_ArquivoLog, 0, '00AA', 'cadastro', VL_Linha,
                            'registro em duplicidade na tabela loja_funcao, ja existe uma função cadastrada com esta loja e esta tag', '', VL_Erro);
                        Exit;
                    end;
                    //TESTA CAMPOS OBRIGATORIOS
                    if ((length(VL_Tabela.FieldByName('LOJA_ID').AsString) = 0) or
                        (length(VL_Tabela.FieldByName('TAG_NUMERO').AsString) = 0)) then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('00AA', 'R');
                        VL_Mensagem.AddTag('004D', '52');//campos nulos
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        VL_Erro := 52;
                        VL_Linha := '160520221610';
                        GravaLog(F_ArquivoLog, 0, '00AA', 'cadastro', VL_Linha,
                            'campos obrigatório não pode ser nulo na inclusão de registro na tabela loja_funcao',
                            '', VL_Erro);
                        Exit;
                    end;
                    //FAZ A INCLUSÃO
                    VL_TLoja_Funcao.Close;
                    VL_TLoja_Funcao.SQL.Text := 'INSERT INTO LOJA_FUNCAO(' +
                        'LOJA_ID,' +
                        'TAG_NUMERO)VALUES(' +
                        IntToStr(VL_Tabela.FieldByName('LOJA_ID').AsInteger) + ',''' +
                        VL_Tabela.FieldByName('TAG_NUMERO').AsString + ''')';
                    VL_Erro := 44;
                    VL_Linha := '020620221555';
                    VL_TLoja_Funcao.ExecSQL;

                    VL_TLoja_Funcao.Close;
                    VL_TLoja_Funcao.SQL.Text := 'SELECT * FROM LOJA_FUNCAO WHERE LOJA_ID=' + VL_Tabela.FieldByName(
                        'LOJA_ID').AsString + ' AND TAG_NUMERO=''' + VL_Tabela.FieldByName('TAG_NUMERO').AsString + '''';
                    VL_Erro := 55;
                    VL_Linha := '020620221556';
                    VL_TLoja_Funcao.Open;

                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('00AA', 'R');
                    VL_Mensagem.AddTag('004D', '0');
                    VL_Mensagem.AddTag('00AB', VL_TLoja_Funcao.FieldByName('ID').AsString);
                    DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                    exit;
                end;
                VL_Tabela.Next;
            end;
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('00AA', 'R');
            VL_Mensagem.AddTag('004D', '44');
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '00AA', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '00AA', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_Tabela.Free;
            VL_TLoja_Funcao.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '00AA', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando00AC(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro LOJA_FUNCAO ALTERAR
var
    VL_Mensagem: TMensagem;
    VL_TLoja_Funcao: TZQuery;
    VL_Tag: ansistring;
    VL_Loja_Funcao_ID: int64;
    VL_Linha: string;
    VL_Erro: integer;
    VL_Habilitado: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TLoja_Funcao := TZQuery.Create(DComunicador);
    VL_TLoja_Funcao.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Linha := '';
    VL_Habilitado := '';
    VL_Erro := 0;
    VL_Loja_Funcao_ID := 0;
    try
        try
            //verifica parametros
            VP_Mensagem.GetTag('00AB', VL_Loja_Funcao_ID);  // ID DA TABELA  LOJA_FUNCAO
            VP_Mensagem.GetTag('00A8', VL_Habilitado);  // HABILITADO DA TABELA  LOJA_FUNCAO

            if VL_Loja_Funcao_ID < 1 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00AC', 'R');
                VL_Mensagem.Addtag('004D', '47'); //PARAMETRO VAZIO
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '010620220922';
                GravaLog(F_ArquivoLog, 0, '00AC', 'CADASTRO', VL_Linha, 'parametro informado na Tag:00AB esta nula ou zerada', '', VL_Erro);
                Exit;
            end;
            //verifica permissao
            if TTConexao(VP_AContext.Data).Permissao <> pmC then   // nao tem permissao para dar manutencao ao cadastro de loja funcao
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00AC', 'R');  //sem permissao
                VL_Mensagem.Addtag('004D', '45');  //sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '240520221019';
                GravaLog(F_ArquivoLog, 0, '00AC', 'CADASTRO', VL_Linha, 'nao tem permissao para dar manutencao ao cadastro de loja funcao', '', VL_Erro);
                Exit;
            end;
            //verifica se existe o id pra loja_funcao
            VL_TLoja_Funcao.Close;
            VL_TLoja_Funcao.SQL.Text := 'SELECT * FROM LOJA_FUNCAO WHERE ID=' + IntToStr(VL_Loja_Funcao_ID);
            VL_Erro := 55;
            VL_Linha := '010520220924';
            VL_TLoja_Funcao.Open;

            if VL_TLoja_Funcao.RecordCount > 0 then
            begin
                //ALTERA o modulo_func
                VL_TLoja_Funcao.Close;
                VL_TLoja_Funcao.SQL.Text := 'UPDATE LOJA_FUNCAO SET HABILITADO=''' + VL_HABILITADO + ''' WHERE ' +
                    'ID=' + IntToStr(VL_Loja_Funcao_ID);
                VL_Erro := 46;
                VL_Linha := '010520220926';
                VL_TLoja_Funcao.ExecSQL;

                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00AC', 'R');
                VL_Mensagem.AddTag('004D', '0');
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                Exit;
            end;
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('00AC', 'R');
            VL_Mensagem.AddTag('004D', '46');
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '00AC', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '00AC', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_TLoja_Funcao.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '00AC', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando00AD(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro LOJA_FUNCAO EXCLUIR
var
    VL_Mensagem: TMensagem;
    VL_TLoja_Funcao: TZQuery;
    VL_Tag: ansistring;
    VL_Loja_Funcao_ID: int64;
    VL_Linha: string;
    VL_Erro: integer;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TLoja_Funcao := TZQuery.Create(DComunicador);
    VL_TLoja_Funcao.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Linha := '';
    VL_Erro := 0;
    VL_Loja_Funcao_ID := 0;
    try
        try
            //verifica parametros
            VP_Mensagem.GetTag('00AB', VL_Loja_Funcao_ID);  // ID DA TABELA  MODULO_FUNCAO
            if VL_Loja_Funcao_ID = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00AD', 'R');
                VL_Mensagem.AddTag('004D', '47');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '020620221643';
                GravaLog(F_ArquivoLog, 0, '00AD', 'CADASTRO', VL_Linha, 'o parametro informado na Tag:00AB esta nulo ou zerado', '', VL_Erro);
                Exit;
            end;
            //verifica permissao
            if TTConexao(VP_AContext.Data).Permissao <> pmC then   // nao tem permissao para dar manutencao ao cadastro de modulo funcao
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00AD', 'R');
                VL_Mensagem.AddTag('004D', '45');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '160520221704';
                GravaLog(F_ArquivoLog, 0, '00AD', 'CADASTRO', VL_Linha, 'nao tem permissao para dar manutencao ao cadastro de loja funcao', '', VL_Erro);
                Exit;
            end;

            //verifica se existe o id pra modulo_função
            VL_TLoja_Funcao.Close;
            VL_TLoja_Funcao.SQL.Text := 'SELECT * FROM LOJA_FUNCAO WHERE ID=' + IntToStr(VL_Loja_Funcao_ID);
            VL_Erro := 55;
            VL_Linha := '020620221646';
            VL_TLoja_Funcao.Open;

            if VL_TLoja_Funcao.RecordCount > 0 then
            begin
                //exclui o modulo_func
                VL_TLoja_Funcao.Close;
                VL_TLoja_Funcao.SQL.Text := 'DELETE FROM LOJA_FUNCAO WHERE ' +
                    'ID=' + IntToStr(VL_Loja_Funcao_ID);
                VL_Erro := 82;
                VL_Linha := '020620221647';
                VL_TLoja_Funcao.ExecSQL;

                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00AD', 'R');
                VL_Mensagem.AddTag('004D', '0');
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                Exit;
            end;
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('00AD', 'R');
            VL_Mensagem.AddTag('004D', '82');
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                        //FreeAndNil(DNucleo);
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '00AD', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '00AD', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            //    VL_Tabela.Free;
            VL_TLoja_Funcao.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                    //FreeAndNil(DNucleo);
                end;

            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '00AD', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando00AE(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro LOJA_MODULO INCLUIR
var
    VL_Mensagem: TMensagem;
    VL_Tabela: TRxMemoryData;
    VL_TLojaModulo: TZQuery;
    VL_Tag: ansistring;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_Tabela := TRxMemoryData.Create(nil);
    VL_TLojaModulo := TZQuery.Create(DComunicador);
    VL_TLojaModulo.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Linha := '';
    VL_Erro := 0;
    try
        try
            //verifica permissao
            if ((TTConexao(VP_AContext.Data).Permissao = pmU) or (TTConexao(VP_AContext.Data).Permissao = pmS)) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00AE', 'R');
                VL_Mensagem.AddTag('004D', '45');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '170520220901';
                GravaLog(F_ArquivoLog, 0, '00AE', 'cadastro', VL_Linha, 'sem permissão para gerenciar a inclusão de registro na tabela loja_modulo',
                    '', VL_Erro);
                Exit;
            end;
            //VERIFICA PARAMETROS
            VP_Mensagem.GetTag('00A7', VL_Tag); //TABELA LOJA_MODULO
            if Length(VL_Tag) = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00AE', 'R');
                VL_Mensagem.AddTag('004D', '47');//parametro vazio
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '020620221434';
                GravaLog(F_ArquivoLog, 0, '00AE', 'cadastro', VL_Linha, 'o parametro informado na Tag:00A7 esta nulo ou zerado', '', VL_Erro);
                Exit;
            end;
            StrToRxMemData(VL_Tag, VL_Tabela);
            VL_Tabela.Open;

            VL_Tabela.First;
            while not VL_Tabela.EOF do
            begin
                if (VL_Tabela.FieldByName('ID').AsInteger = 0) then
                begin
                    //verifica se o modulo_func ja foi cadastrado
                    VL_TLojaModulo.Close;
                    VL_TLojaModulo.SQL.Text := 'SELECT FIRST 1 ID FROM LOJA_MODULO_CONF WHERE MODULO_CONF_ID=''' +
                        VL_Tabela.FieldByName('MODULO_CONF_ID').AsString + ''' AND LOJA_ID=' +
                        IntToStr(VL_Tabela.FieldByName('LOJA_ID').AsInteger);
                    VL_Erro := 55;
                    VL_Linha := '020620221436';
                    VL_TLojaModulo.Open;

                    if VL_TLojaModulo.RecordCount > 0 then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('00AE', 'R');
                        VL_Mensagem.AddTag('004D', '43');//duplicidade
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        VL_Erro := 43;
                        VL_Linha := '170520220904';
                        GravaLog(F_ArquivoLog, 0, '00AE', 'cadastro', VL_Linha,
                            'registro em duplicidade na tabela loja_modulo_conf, ja existe um modulo config cadastrada com esta configuracao: ' +
                            '(modulo_conf = ' + VL_Tabela.FieldByName('MODULO_CONF_ID').AsString + ') (loja_id =' +
                            VL_Tabela.FieldByName('LOJA_ID').AsString + ')', '', VL_Erro);
                        Exit;
                    end;
                    //COMEÇA A INSERIR
                    VL_TLojaModulo.Close;
                    VL_TLojaModulo.SQL.Text := 'INSERT INTO LOJA_MODULO_CONF(' +
                        'LOJA_ID,' +
                        'HABILITADO,' +
                        'MODULO_CONF_ID,' +
                        'CODIGO)VALUES(' +
                        IntToStr(VL_Tabela.FieldByName('LOJA_ID').AsInteger) + ',''' +
                        VL_Tabela.FieldByName('HABILITADO').AsString + ''',' +
                        IntToStr(VL_Tabela.FieldByName('MODULO_CONF_ID').AsInteger) + ',''' +
                        VL_Tabela.FieldByName('CODIGO').AsString + ''')';
                    VL_Erro := 44;
                    VL_Linha := '020620221439';
                    VL_TLojaModulo.ExecSQL;
                    VL_TLojaModulo.Close;

                    VL_TLojaModulo.SQL.Text := 'SELECT * FROM LOJA_MODULO_CONF WHERE MODULO_CONF_ID=''' +
                        VL_Tabela.FieldByName('MODULO_CONF_ID').AsString + ''' AND LOJA_ID=' +
                        IntToStr(VL_Tabela.FieldByName('LOJA_ID').AsInteger);
                    VL_Erro := 55;
                    VL_Linha := '020620221440';
                    VL_TLojaModulo.Open;

                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('00AE', 'R');
                    VL_Mensagem.Addtag('004D', '0');
                    VL_Mensagem.AddTag('00AF', VL_TLojaModulo.FieldByName('ID').AsString);
                    DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                    exit;
                end;
                VL_Tabela.Next;
            end;
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('00AE', 'R');
            VL_Mensagem.Addtag('004D', '44');
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '00AE', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '00AE', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_Tabela.Free;
            VL_TLojaModulo.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '00AE', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando00B0(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro MULTILOJA_MODULO_CONF_FUNCAO ALTERAR
var
    VL_Mensagem: TMensagem;
    VL_TMultiLoja_Modulo_Conf_Funcao: TZQuery;
    VL_Tag: ansistring;
    VL_MultiLoja_Modulo_Conf_Funcao_ID: int64;
    VL_Linha: string;
    VL_Erro: integer;
    VL_Habilitado: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TMultiLoja_Modulo_Conf_Funcao := TZQuery.Create(DComunicador);
    VL_TMultiLoja_Modulo_Conf_Funcao.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Linha := '';
    VL_Habilitado := '';
    VL_Erro := 0;
    VL_MultiLoja_Modulo_Conf_Funcao_ID := 0;
    try
        try
            //verifica parametros
            VP_Mensagem.GetTag('00BD', VL_MultiLoja_Modulo_Conf_Funcao_ID);  // ID DA TABELA  MODULO_CONF_FUNCAO
            VP_Mensagem.GetTag('0084', VL_Habilitado);  // HABILITADO DA TABELA  MODULO_CONF_FUNCAO

            if VL_MultiLoja_Modulo_Conf_Funcao_ID <= 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00B0', 'R');
                VL_Mensagem.AddTag('004D', '47');  //sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '020620221043';
                GravaLog(F_ArquivoLog, 0, '00B0', 'CADASTRO', VL_Linha, 'o parametro informado na Tag:00B0 esta nulo ou zerado', '', VL_Erro);
                Exit;
            end;
            //verifica permissao
            if TTConexao(VP_AContext.Data).Permissao <> pmC then   // nao tem permissao para dar manutencao ao cadastro de modulo_conf_funcao
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00B0', 'R');
                VL_Mensagem.AddTag('004D', '45');  //sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '270520220912';
                GravaLog(F_ArquivoLog, 0, '00B0', 'CADASTRO', VL_Linha, 'nao tem permissao para dar manutencao ao cadastro de multiloja_modulo_conf_funcao',
                    '', VL_Erro);
                Exit;
            end;
            //verifica se existe o id pra loja_modulo_conf_funcao
            VL_TMultiLoja_Modulo_Conf_Funcao.Close;
            VL_TMultiLoja_Modulo_Conf_Funcao.SQL.Text := 'SELECT * FROM MULTILOJA_MODULO_CONF_FUNCAO WHERE ID=' + IntToStr(VL_MultiLoja_Modulo_Conf_Funcao_ID);
            VL_Erro := 55;
            VL_Linha := '310520221611';
            VL_TMultiLoja_Modulo_Conf_Funcao.Open;

            if VL_TMultiLoja_Modulo_Conf_Funcao.RecordCount > 0 then
            begin
                //ALTERA o multiloja_modulo_conf_funcao
                VL_TMultiLoja_Modulo_Conf_Funcao.Close;
                VL_TMultiLoja_Modulo_Conf_Funcao.SQL.Text := 'UPDATE MULTILOJA_MODULO_CONF_FUNCAO SET HABILITADO=''' + VL_HABILITADO + ''' WHERE ' +
                    'ID=' + IntToStr(VL_MultiLoja_Modulo_Conf_Funcao_ID);
                VL_Erro := 46;
                VL_Linha := '270520220915';
                VL_TMultiLoja_Modulo_Conf_Funcao.ExecSQL;
            end
            else
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00B0', 'R');
                VL_Mensagem.AddTag('004D', '48');  //erro registro não encontrado
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 48;
                VL_Linha := '310520221615';
                GravaLog(F_ArquivoLog, 0, '00B0', 'cadastro', VL_Linha, 'não encontrado o registro numero:' +
                    IntToStr(VL_MultiLoja_Modulo_Conf_Funcao_ID) + ' na tabela multiloja_modulo_conf_funcao', '', VL_Erro);
                Exit;
            end;
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('00B0', 'R');
            VL_Mensagem.AddTag('004D', '0');
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '00B0', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '00B0', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_TMultiLoja_Modulo_Conf_Funcao.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '00B0', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando00B1(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro LOJA_MODULO ALTERAR
var
    VL_Mensagem: TMensagem;
    VL_TLoja_Modulo: TZQuery;
    VL_Tabela: TRxMemoryData;
    VL_Tag: ansistring;
    VL_ID: int64;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TLoja_Modulo := TZQuery.Create(DComunicador);
    VL_TLoja_Modulo.Connection := DNucleo.ZConexao;
    VL_Tabela := TRxMemoryData.Create(nil);
    VL_Tag := '';
    VL_ID := 0;
    VL_Erro := 0;
    VL_Linha := '';
    try
        try
            //verifica permissão
            if ((TTConexao(VP_AContext.Data).Permissao = pmU) or (TTConexao(VP_AContext.Data).Permissao = pmS)) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00B1', 'R');
                VL_Mensagem.AddTag('004D', '45');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '170520221109';
                GravaLog(F_ArquivoLog, 0, '00B1', 'cadastro', VL_Linha, 'sem permissão para gerenciar a alteração de dados da tabela loja_modulo',
                    '', VL_Erro);
                Exit;
            end;
            //VERIFICA PARAMETROS
            VP_Mensagem.GetTag('00A7', VL_Tag); //carrega tabela LOJA_MODULO
            if Length(VL_Tag) = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00B1', 'R');
                VL_Mensagem.AddTag('004D', '47');//parametro vazio
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '020620221444';
                GravaLog(F_ArquivoLog, 0, '00B1', 'cadastro', VL_Linha, 'o parametro informado na Tag:00A7 esta nulo ou zerado', '', VL_Erro);
                Exit;
            end;
            StrToRxMemData(VL_Tag, VL_Tabela);
            VL_Tabela.Open;

            VP_Mensagem.GetTag('00AF', VL_ID); //loja_modulo_id
            if VL_ID < 1 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00B1', 'R');
                VL_Mensagem.AddTag('004D', '47');//dados informado não pode ser zero
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '170520221111';
                GravaLog(F_ArquivoLog, 0, '00B1', 'cadastro', VL_Linha, 'alteração não executada, o id informado da loja_modulo não pode ser zero',
                    '', VL_Erro);
                Exit;
            end;
            //verifica se existe o registro para alterar
            VL_TLoja_Modulo.Close;
            VL_TLoja_Modulo.SQL.Text := 'SELECT * FROM LOJA_MODULO_CONF WHERE ID=' + IntToStr(VL_ID);
            VL_Erro := 55;
            VL_Linha := '020620221446';
            VL_TLoja_Modulo.Open;

            if VL_TLoja_Modulo.RecordCount = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00B1', 'R');
                VL_Mensagem.AddTag('004D', '48');//registro não localizado
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 48;
                VL_Linha := '170520221112';
                GravaLog(F_ArquivoLog, 0, '00B1', 'cadastro', VL_Linha, 'o registro numero:' + IntToStr(VL_ID) +
                    ' informado não foi encontrado na tabela loja_modulo_conf',
                    '', VL_Erro);
                Exit;
            end;
            if VL_Tabela.Locate('ID', VL_ID, []) then
            begin
                if ((VL_Tabela.FieldByName('ID').AsInteger <> VL_TLoja_Modulo.FieldByName('ID').AsInteger) or
                    (VL_Tabela.FieldByName('LOJA_ID').AsInteger <> VL_TLoja_Modulo.FieldByName('LOJA_ID').AsInteger)) then
                begin
                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('00B1', 'R');
                    VL_Mensagem.AddTag('004D', '49'); //dados chaves não podem sofer alteração
                    DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                    VL_Erro := 49;
                    VL_Linha := '170520221113';
                    GravaLog(F_ArquivoLog, 0, '00B1', 'cadastro', VL_Linha,
                        'dados chaves não podem sofer alteração(id/loja_id) na tabela loja_modulo_conf não pode alterar',
                        '', VL_Erro);
                    Exit;
                end;

                VL_TLoja_Modulo.Close;
                VL_TLoja_Modulo.SQL.Text := 'UPDATE LOJA_MODULO_CONF SET ' + 'HABILITADO=''' + VL_Tabela.FieldByName('HABILITADO').AsString + ''',' +
                    'MODULO_CONF_ID=''' + IntToStr(VL_Tabela.FieldByName('MODULO_CONF_ID').AsInteger) + ''',' + 'CODIGO=''' +
                    VL_Tabela.FieldByName('CODIGO').AsString + ''' WHERE ' + 'ID=' + IntToStr(VL_ID);
                VL_Erro := 46;
                VL_Linha := '020620221449';
                VL_TLoja_Modulo.ExecSQL;

                VL_TLoja_Modulo.Close;
                VL_TLoja_Modulo.SQL.Text := 'SELECT * FROM LOJA_MODULO_CONF WHERE ID=' + IntToStr(VL_ID);
                VL_Erro := 55;
                VL_Linha := '020620221450';
                VL_TLoja_Modulo.Open;

                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00B1', 'R');//alteração aceita
                VL_Mensagem.AddTag('004D', '0');
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                Exit;
            end
            else
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00B1', 'R');//alteração recusada
                VL_Mensagem.AddTag('004D', '46');
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
            end;
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '00B1', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '00B1', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_Tabela.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '00B1', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando00B2(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro LOJA_MODULO EXCLUIR
var
    VL_Mensagem: TMensagem;
    VL_TLoja_Modulo: TZQuery;
    VL_Tag: ansistring;
    VL_ID: int64;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TLoja_Modulo := TZQuery.Create(DComunicador);
    VL_TLoja_Modulo.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_ID := 0;
    VL_Erro := 0;
    VL_Linha := '';
    try
        try
            //verifica parametros
            VP_Mensagem.GetTag('00AF', VL_ID); //LOJA_MODULO_ID
            if VL_ID = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00B2', 'R');
                VL_Mensagem.AddTag('004D', '47');//campo não pode ser zero
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '170520221128';
                GravaLog(F_ArquivoLog, 0, '00B2', 'cadastro', VL_Linha, 'campo id para exclusão na tabela loja_modulo não pode ser zero', '', VL_Erro);
                Exit;
            end;
            //verifica permissao
            if ((TTConexao(VP_AContext.Data).Permissao = pmU) or (TTConexao(VP_AContext.Data).Permissao = pmS)) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00B2', 'R');
                VL_Mensagem.AddTag('004D', '45');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '170520221129';
                GravaLog(F_ArquivoLog, 0, '00B2', 'cadastro', VL_Linha, 'sem permissão para gerenciar exclusão na tabela loja_modulo_conf', '', VL_Erro);
                Exit;
            end;
            //verifica se existe o id pra exclusão
            VL_TLoja_Modulo.Close;
            VL_TLoja_Modulo.SQL.Text := 'SELECT * FROM LOJA_MODULO_CONF WHERE ID=' + IntToStr(VL_ID);
            VL_Erro := 55;
            VL_Linha := '020620221500';
            VL_TLoja_Modulo.Open;

            if VL_TLoja_Modulo.RecordCount = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00B2', 'R');
                VL_Mensagem.AddTag('004D', '48'); // id não encontrado na tabela
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 48;
                VL_Linha := '170520221130';
                GravaLog(F_ArquivoLog, 0, '00B2', 'cadastro', VL_Linha, 'campo informado ID numero:' + IntToStr(VL_ID) +
                    ' para exclusão não foi localizado na tabela loja_modulo_conf', '', VL_Erro);
                Exit;
            end;
            //exclui loja_modulo
            VL_TLoja_Modulo.Close;
            VL_TLoja_Modulo.SQL.Text := 'DELETE FROM LOJA_MODULO_CONF WHERE ' + 'ID=' + IntToStr(VL_ID);
            VL_Erro := 82;
            VL_Linha := '020620221502';
            VL_TLoja_Modulo.ExecSQL;

            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('00B2', 'R');
            VL_Mensagem.AddTag('004D', '0');
            VL_Mensagem.AddTag('00AF', VL_ID); //retorno loja_id
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '00B2', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '00B2', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_TLoja_Modulo.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;

            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '00B2', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando00B5(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro PINPAD_FUNCAO INCLUIR
var
    VL_Mensagem: TMensagem;
    VL_Tabela: TRxMemoryData;
    VL_TPinPad_Funcao: TZQuery;
    VL_Tag: ansistring;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_Tabela := TRxMemoryData.Create(nil);
    VL_TPinPad_Funcao := TZQuery.Create(DComunicador);
    VL_TPinPad_Funcao.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Linha := '';
    VL_Erro := 0;
    try
        try
            //verifica permissao
            if ((TTConexao(VP_AContext.Data).Permissao = pmU) or (TTConexao(VP_AContext.Data).Permissao = pmS)) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00B5', 'R');
                VL_Mensagem.AddTag('004D', '45');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '180520220854';
                GravaLog(F_ArquivoLog, 0, '00B5', 'cadastro', VL_Linha, 'sem permissão para gerenciar a inclusão de registro na tabela pinpad_funcao',
                    '', VL_Erro);
                Exit;
            end;
            //VERIFICA PARAMETRO
            VP_Mensagem.GetTag('00B4', VL_Tag); // tabela pinpad_funcao
            if Length(VL_Tag) = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00B5', 'R');
                VL_Mensagem.AddTag('004D', '47');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '060220221721';
                GravaLog(F_ArquivoLog, 0, '00B5', 'cadastro', VL_Linha, 'o parametro informado na Tag:00B4 esta nulo ou zerado', '', VL_Erro);
                Exit;
            end;
            StrToRxMemData(VL_Tag, VL_Tabela);
            VL_Tabela.Open;

            VL_Tabela.First;
            while not VL_Tabela.EOF do
            begin
                if ((VL_Tabela.FieldByName('VALIDADO').AsBoolean = True) and (VL_Tabela.FieldByName('ID').AsInteger = 0)) then
                begin
                    //verifica se o pinpad_funcao ja foi cadastrado
                    VL_TPinPad_Funcao.Close;
                    VL_TPinPad_Funcao.SQL.Text := 'SELECT FIRST 1 ID FROM PINPAD_FUNCAO WHERE PINPAD_ID=''' +
                        VL_Tabela.FieldByName('PINPAD_ID').AsString + ''' AND TAG_NUMERO=''' +
                        VL_Tabela.FieldByName('TAG_NUMERO').AsString + '''';
                    VL_Erro := 55;
                    VL_Linha := '060220221722';
                    VL_TPinPad_Funcao.Open;

                    if VL_TPinPad_Funcao.RecordCount > 0 then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('00B5', 'R');
                        VL_Mensagem.AddTag('004D', '43');//duplicidade
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        VL_Erro := 43;
                        VL_Linha := '180520220856';
                        GravaLog(F_ArquivoLog, 0, '00B5', 'cadastro', VL_Linha,
                            'registro em duplicidade na tabela pinpad_funcao, ja existe uma função cadastrada com este pinpad e esta tag', '', VL_Erro);
                        Exit;
                    end;
                    //TESTA CAMPOS OBRIGATORIOS
                    if ((length(VL_Tabela.FieldByName('PINPAD_ID').AsString) = 0) or
                        (length(VL_Tabela.FieldByName('TAG_NUMERO').AsString) = 0)) then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('00B5', 'R');//campos nulos
                        VL_Mensagem.AddTag('004D', '52');//campos nulos
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        VL_Erro := 52;
                        VL_Linha := '180520220857';
                        GravaLog(F_ArquivoLog, 0, '00B5', 'cadastro', VL_Linha,
                            'campos obrigatório não pode ser nulo na inclusão de registro na tabela pinpad_funcao',
                            '', VL_Erro);
                        Exit;
                    end;
                    //COMEÇA A INCLUSÃO
                    VL_TPinPad_Funcao.Close;
                    VL_TPinPad_Funcao.SQL.Text := 'INSERT INTO PINPAD_FUNCAO(' +
                        'PINPAD_ID,' +
                        'TAG_NUMERO)VALUES(' +
                        IntToStr(VL_Tabela.FieldByName('PINPAD_ID').AsInteger) + ',''' +
                        VL_Tabela.FieldByName('TAG_NUMERO').AsString + ''')';
                    VL_Erro := 44;
                    VL_Linha := '020620221724';
                    VL_TPinPad_Funcao.ExecSQL;

                    VL_TPinPad_Funcao.Close;
                    VL_TPinPad_Funcao.SQL.Text := 'SELECT * FROM PINPAD_FUNCAO WHERE PINPAD_ID=' + VL_Tabela.FieldByName(
                        'PINPAD_ID').AsString + ' AND TAG_NUMERO=''' + VL_Tabela.FieldByName('TAG_NUMERO').AsString + '''';
                    VL_Erro := 55;
                    VL_Linha := '020620221725';
                    VL_TPinPad_Funcao.Open;

                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('00B5', 'R');
                    VL_Mensagem.AddTag('004D', '0');
                    VL_Mensagem.AddTag('00B7', VL_TPinPad_Funcao.FieldByName('ID').AsString);
                    DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                    exit;
                end;
                VL_Tabela.Next;
            end;
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('00B5', 'R');
            VL_Mensagem.AddTag('004D', '44');
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '00B5', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '00B5', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_Tabela.Free;
            VL_TPinPad_Funcao.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '00B5', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando00B6(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro PINPAD_FUNCAO ALTERAR
var
    VL_Mensagem: TMensagem;
    VL_TPinPad_Funcao: TZQuery;
    VL_Tag: ansistring;
    VL_PinPad_Funcao_ID: int64;
    VL_Linha: string;
    VL_Erro: integer;
    VL_Habilitado: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TPinPad_Funcao := TZQuery.Create(DComunicador);
    VL_TPinPad_Funcao.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Linha := '';
    VL_Habilitado := '';
    VL_Erro := 0;
    VL_PinPad_Funcao_ID := 0;
    try
        try
            //verifica parametros
            VP_Mensagem.GetTag('00B7', VL_PinPad_Funcao_ID);  // ID DA TABELA  PINPAD_FUNCAO
            VP_Mensagem.GetTag('00B3', VL_Habilitado);  // HABILITADO DA TABELA  PINPAD_FUNCAO

            if VL_PinPad_Funcao_ID < 1 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00B6', 'R');
                VL_Mensagem.AddTag('004D', '47');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '010620220936';
                GravaLog(F_ArquivoLog, 0, '00B6', 'CADASTRO', VL_Linha, 'parametro informado na Tag:00B7 esta nula ou zerada', '', VL_Erro);
                Exit;
            end;

            //verifica permissao
            if TTConexao(VP_AContext.Data).Permissao <> pmC then   // nao tem permissao para dar manutencao ao cadastro de pinpad funcao
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00B', 'R');
                VL_Mensagem.AddTag('004D', '45');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '240520221047';
                GravaLog(F_ArquivoLog, 0, '00B6', 'CADASTRO', VL_Linha, 'nao tem permissao para dar manutencao ao cadastro de pinpad funcao', '', VL_Erro);
                Exit;
            end;

            //verifica se existe o id pra pinpad_funcao
            VL_TPinPad_Funcao.Close;
            VL_TPinPad_Funcao.SQL.Text := 'SELECT * FROM PINPAD_FUNCAO WHERE ID=' + IntToStr(VL_PinPad_Funcao_ID);
            VL_Erro := 55;
            VL_Linha := '010620220946';
            VL_TPinPad_Funcao.Open;

            if VL_TPinPad_Funcao.RecordCount > 0 then
            begin
                //ALTERA o PINPAD_FUNC
                VL_TPinPad_Funcao.Close;
                VL_TPinPad_Funcao.SQL.Text := 'UPDATE PINPAD_FUNCAO SET HABILITADO=''' + VL_HABILITADO + ''' WHERE ' +
                    'ID=' + IntToStr(VL_PinPad_Funcao_ID);
                VL_Erro := 46;
                VL_Linha := '010620220947';
                VL_TPinPad_Funcao.ExecSQL;

                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00B6', 'R');
                VL_Mensagem.AddTag('004D', '0');
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
            end
            else
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00B6', 'R');
                VL_Mensagem.AddTag('004D', '46');
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
            end;
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '00B6', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '00B6', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_TPinPad_Funcao.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '00B6', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando00B8(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro PINPAD_FUNCAO EXCLUIR
var
    VL_Mensagem: TMensagem;
    VL_TPinPad_Funcao: TZQuery;
    VL_Tag: ansistring;
    VL_PinPad_Funcao_ID: int64;
    VL_Linha: string;
    VL_Erro: integer;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TPinPad_Funcao := TZQuery.Create(DComunicador);
    VL_TPinPad_Funcao.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Linha := '';
    VL_Erro := 0;
    VL_PinPad_Funcao_ID := 0;
    try
        try
            //verifica permissao
            if TTConexao(VP_AContext.Data).Permissao <> pmC then   // nao tem permissao para dar manutencao ao cadastro de modulo funcao
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00B8', 'R');
                VL_Mensagem.AddComando('004D', '45');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '180520220906';
                GravaLog(F_ArquivoLog, 0, '00B8', 'CADASTRO', VL_Linha, 'nao tem permissao para dar manutencao ao cadastro de pinpad funcao', '', VL_Erro);
                Exit;
            end;
            //verifica parametros
            VP_Mensagem.GetTag('00B7', VL_PinPad_Funcao_ID);  // ID DA TABELA  PINPAD_FUNCAO
            if VL_PinPad_Funcao_ID = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00B8', 'R');
                VL_Mensagem.AddTag('004D', '47');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '030620220815';
                GravaLog(F_ArquivoLog, 0, '00B8', 'CADASTRO', VL_Linha, 'o parametro informado na Tag:00B7 esta nulo ou zerado', '', VL_Erro);
                Exit;
            end;
            //verifica se existe o id pra pinpad_função
            VL_TPinPad_Funcao.Close;
            VL_TPinPad_Funcao.SQL.Text := 'SELECT * FROM PINPAD_FUNCAO WHERE ID=' + IntToStr(VL_PinPad_Funcao_ID);
            VL_Erro := 55;
            VL_Linha := '030620220817';
            VL_TPinPad_Funcao.Open;

            if VL_TPinPad_Funcao.RecordCount > 0 then
            begin
                //exclui o pinpad_funcao
                VL_TPinPad_Funcao.Close;
                VL_TPinPad_Funcao.SQL.Text := 'DELETE FROM PINPAD_FUNCAO WHERE ' +
                    'ID=' + IntToStr(VL_PinPad_Funcao_ID);
                VL_Erro := 82;
                VL_Linha := '030620220818';
                VL_TPinPad_Funcao.ExecSQL;

                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00B8', 'R');
                VL_Mensagem.AddTag('004D', '0');
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
            end
            else
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00B8', 'R');
                VL_Mensagem.AddTag('004D', '82');
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
            end;
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                        //FreeAndNil(DNucleo);
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '00B8', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '00B8', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_TPinPad_Funcao.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                    //FreeAndNil(DNucleo);
                end;

            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '00B8', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando00B9(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro MODULO_FUNCAO ALTERAR
var
    VL_Mensagem: TMensagem;
    VL_TModulo_Funcao: TZQuery;
    VL_Tag: ansistring;
    VL_Modulo_Funcao_ID: int64;
    VL_Linha: string;
    VL_Erro: integer;
    VL_Habilitado: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TModulo_Funcao := TZQuery.Create(DComunicador);
    VL_TModulo_Funcao.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Linha := '';
    VL_Habilitado := '';
    VL_Erro := 0;
    VL_Modulo_Funcao_ID := 0;
    try
        try
            //verifica parametros
            VP_Mensagem.GetTag('008B', VL_Modulo_Funcao_ID);  // ID DA TABELA  MODULO_FUNCAO
            VP_Mensagem.GetTag('00C6', VL_Habilitado);  // HABILITADO DA TABELA  MODULO_FUNCAO

            if VL_Modulo_Funcao_ID = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00B9', 'R');
                VL_Mensagem.AddTag('004D', '47');  //DADOS INFORMADO ZERADO
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '270520221144';
                GravaLog(F_ArquivoLog, 0, '00B9', 'CADASTRO', VL_Linha, 'dados informado na Tag:008B não pode estar nula ou zerada',
                    '', VL_Erro);
                Exit;
            end;

            if LENGTH(VL_Habilitado) = 0 then
                VL_Habilitado := 'F';

            //verifica permissao
            if TTConexao(VP_AContext.Data).Permissao <> pmC then   // nao tem permissao para dar manutencao ao cadastro de modulo_conf_funcao
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00B9', 'R');
                VL_Mensagem.AddTag('004D', '45');  //sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '270520221147';
                GravaLog(F_ArquivoLog, 0, '00B9', 'CADASTRO', VL_Linha, 'nao tem permissao para dar manutencao ao cadastro de modulo_funcao',
                    '', VL_Erro);
                Exit;
            end;

            //verifica se existe o id pra modulo_conf_funcao
            VL_TModulo_Funcao.Close;
            VL_TModulo_Funcao.SQL.Text := 'SELECT * FROM MODULO_FUNCAO WHERE ID=' + IntToStr(VL_Modulo_Funcao_ID);
            VL_Erro := 55;
            VL_Linha := '270520221148';
            VL_TModulo_Funcao.Open;

            if VL_TModulo_Funcao.RecordCount > 0 then
            begin
                //ALTERA o modulo_conf_funcao
                VL_TModulo_Funcao.Close;
                VL_TModulo_Funcao.SQL.Text := 'UPDATE MODULO_FUNCAO SET HABILITADO=''' + VL_HABILITADO + ''' WHERE ' +
                    'ID=' + IntToStr(VL_Modulo_Funcao_ID);
                VL_Erro := 46;
                VL_Linha := '270520221149';
                VL_TModulo_Funcao.ExecSQL;

                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00B9', 'R');
                VL_Mensagem.AddTag('004D', '0');
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
            end
            else
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00B9', 'R');//erro na exclusao
                VL_Mensagem.AddTag('004D', '48');//TABELA SEM REGISTRO
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 48;
                VL_Linha := '270520221152';
                GravaLog(F_ArquivoLog, 0, '00B9', 'cadastro', VL_Linha, 'não foi encontrado o registro numero:' + IntToStr(VL_Modulo_Funcao_ID) +
                    ' na tabela modulo_funcao', '', VL_Erro);
                Exit;
            end;
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '00B9', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '00B9', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_TModulo_Funcao.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '00B9', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando00BA(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro MODULO_CONF EXCLUIR
var
    VL_Mensagem: TMensagem;
    VL_TModulo_Conf: TZQuery;
    VL_Tag: ansistring;
    VL_Modulo_Conf_ID: int64;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TModulo_Conf := TZQuery.Create(DComunicador);
    VL_TModulo_Conf.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Modulo_Conf_ID := 0;
    VL_Erro := 0;
    VL_Linha := '';
    try
        try
            //verifica parametros
            VP_Mensagem.GetTag('007B', VL_Modulo_Conf_ID); //configurador_id
            if VL_Modulo_Conf_ID < 1 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00BA', 'R');
                VL_Mensagem.AddTag('004D', '47');// campo zerado
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '270520221514';
                GravaLog(F_ArquivoLog, 0, '00BA', 'cadastro', VL_Linha, 'parametro informado na Tag:' + IntToStr(VL_Modulo_Conf_ID) +
                    ' não pode estar zerado ou nulo para exclusão na tabela modulo_conf', '', VL_Erro);
                Exit;
            end;
            //verifica permissao
            if (TTConexao(VP_AContext.Data).Permissao <> pmC) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00BA', 'R');
                VL_Mensagem.AddTag('004D', '45');//sem permissão
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '270520221515';
                GravaLog(F_ArquivoLog, 0, '00BA', 'cadastro', VL_Linha, 'sem permissõa para gerenciar exclusão de registro na tabela modulo_conf',
                    '', VL_Erro);
                Exit;
            end;
            //verifica se existe o id pra exclusão
            VL_TModulo_Conf.Close;
            VL_TModulo_Conf.SQL.Text := 'SELECT * FROM MODULO_CONF WHERE ID=' + IntToStr(VL_Modulo_Conf_ID);
            VL_Erro := 55;
            VL_Linha := '270520221516';
            VL_TModulo_Conf.Open;

            if VL_TModulo_Conf.RecordCount > 0 then
            begin
                //exclui MODULO_CONF
                VL_TModulo_Conf.Close;
                VL_TModulo_Conf.SQL.Text := 'DELETE FROM MODULO_CONF WHERE ' + 'ID=' + IntToStr(VL_Modulo_Conf_ID);
                VL_Erro := 82;
                VL_Linha := '270520221517';
                VL_TModulo_Conf.ExecSQL;

                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00BA', 'R');
                VL_Mensagem.AddTag('004D', '0');
                VL_Mensagem.AddTag('007B', VL_Modulo_Conf_ID);
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
            end
            else
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00BA', 'R');
                VL_Mensagem.AddTag('004D', '48');//registro não localizado
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 48;
                VL_Linha := '270520221518';
                GravaLog(F_ArquivoLog, 0, '00BA', 'cadastro', VL_Linha, 'não localizado na tabela modulo_conf o registro numero:' +
                    IntToStr(VL_Modulo_Conf_ID), '', VL_Erro);
                Exit;
            end;
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '00BA', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '00BA', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_TModulo_Conf.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '00BA', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando00BB(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro CONFIGURADOR EXCLUIR
var
    VL_Mensagem: TMensagem;
    VL_TConfigurador: TZQuery;
    VL_Tag: ansistring;
    VL_Configurador_ID: int64;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TConfigurador := TZQuery.Create(DComunicador);
    VL_TConfigurador.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Configurador_ID := 0;
    VL_Erro := 0;
    VL_Linha := '';
    try
        try
            //verifica parametros
            VP_Mensagem.GetTag('0056', VL_Configurador_ID); //configurador_id
            if VL_Configurador_ID = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00BB', 'R');
                VL_Mensagem.AddTag('004D', '47');// campo zerado
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '270520221446';
                GravaLog(F_ArquivoLog, 0, '00BB', 'cadastro', VL_Linha, 'parametro informado na Tag:' + IntToStr(VL_Configurador_ID) +
                    ' não pode estar zerado ou nulo para exclusão na tabela configurador', '', VL_Erro);
                Exit;
            end;
            //verifica permissao
            if (TTConexao(VP_AContext.Data).Permissao <> pmC) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00BB', 'R');
                VL_Mensagem.AddTag('004D', '45');//sem permissão
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '270520221451';
                GravaLog(F_ArquivoLog, 0, '00BB', 'cadastro', VL_Linha, 'sem permissõa para gerenciar exclusão de registro na tabela configurador',
                    '', VL_Erro);
                Exit;
            end;
            //verifica se existe o id pra exclusão
            VL_TConfigurador.Close;
            VL_TConfigurador.SQL.Text := 'SELECT * FROM CONFIGURADOR WHERE ID=' + IntToStr(VL_Configurador_ID);
            VL_Erro := 55;
            VL_Linha := '270520221454';
            VL_TConfigurador.Open;

            if VL_TConfigurador.RecordCount > 0 then
            begin
                //exclui CONFIGURADOR
                VL_TConfigurador.Close;
                VL_TConfigurador.SQL.Text := 'DELETE FROM CONFIGURADOR WHERE ' + 'ID=' + IntToStr(VL_Configurador_ID);
                VL_Erro := 82;
                VL_Linha := '270520221456';
                VL_TConfigurador.ExecSQL;

                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00BB', 'R');
                VL_Mensagem.AddTag('004D', '0');
                VL_Mensagem.AddTag('0056', VL_Configurador_ID);
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                EXIT;
            end
            else
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00BB', 'R');
                VL_Mensagem.AddTag('004D', '48');//registro não localizado
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 48;
                VL_Linha := '270520221458';
                GravaLog(F_ArquivoLog, 0, '00BB', 'cadastro', VL_Linha, 'não localizado na tabela configurador o registro numero:' +
                    IntToStr(VL_Configurador_ID), '', VL_Erro);
                Exit;
            end;
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '00BB', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '00BB', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_TConfigurador.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '00BB', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando002B(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro MODULO EXCLUIR
var
    VL_Mensagem: TMensagem;
    VL_TModulo: TZQuery;
    VL_Tag: ansistring;
    VL_Modulo_ID: int64;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TModulo := TZQuery.Create(DComunicador);
    VL_TModulo.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Modulo_ID := 0;
    VL_Erro := 0;
    VL_Linha := '';
    try
        try
            //verifica parametros
            VP_Mensagem.GetTag('006C', VL_Modulo_ID); //modulo_id
            if VL_Modulo_ID = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('002B', 'R');
                VL_Mensagem.AddTag('004D', '47');// campo zerado
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '270520221538';
                GravaLog(F_ArquivoLog, 0, '002B', 'cadastro', VL_Linha, 'parametro informado na Tag:' + IntToStr(VL_Modulo_ID) +
                    ' não pode estar zerado ou nulo para exclusão na tabela modulo', '', VL_Erro);
                Exit;
            end;
            //verifica permissao
            if (TTConexao(VP_AContext.Data).Permissao <> pmC) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('002B', 'R');
                VL_Mensagem.AddTag('004D', '45');//sem permissão
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '270520221539';
                GravaLog(F_ArquivoLog, 0, '002B', 'cadastro', VL_Linha, 'sem permissõa para gerenciar exclusão de registro na tabela modulo',
                    '', VL_Erro);
                Exit;
            end;
            //verifica se existe o id pra exclusão
            VL_TModulo.Close;
            VL_TModulo.SQL.Text := 'SELECT * FROM MODULO WHERE ID=' + IntToStr(VL_Modulo_ID);
            VL_Erro := 55;
            VL_Linha := '270520221540';
            VL_TModulo.Open;

            if VL_TModulo.RecordCount > 0 then
            begin
                //exclui MODULO
                VL_TModulo.Close;
                VL_TModulo.SQL.Text := 'DELETE FROM MODULO WHERE ' + 'ID=' + IntToStr(VL_Modulo_ID);
                VL_Erro := 82;
                VL_Linha := '270520221541';
                VL_TModulo.ExecSQL;

                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('002B', 'R');
                VL_Mensagem.AddTag('004D', '0');
                VL_Mensagem.AddTag('006C', VL_Modulo_ID);
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
            end
            else
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('002B', 'R');
                VL_Mensagem.AddTag('004D', '48');//registro não localizado
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 48;
                VL_Linha := '270520221542';
                GravaLog(F_ArquivoLog, 0, '002B', 'cadastro', VL_Linha, 'não localizado na tabela modulo o registro numero:' +
                    IntToStr(VL_Modulo_ID), '', VL_Erro);
                Exit;
            end;
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                        DNucleo.FreeOnRelease;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '002B', 'cadastro', VL_Linha, 'erro inesperado classe: ' + e.ClassName +
                            '/ menssagem:' + e.Message, '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '002B', 'cadastro', VL_Linha, 'erro inesperado classe: ' + e.ClassName + '/ menssagem:' + e.Message, '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_TModulo.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                    DNucleo.FreeOnRelease;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '002B', 'cadastro', VL_Linha, 'erro inesperado classe: ' + e.ClassName +
                        '/ menssagem:' + e.Message, '', VL_Erro);
            end;
        end;
    end;
end;

function comando00BF(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro LOJA_MODULO_CONF_FUNCAO ALTERAR
var
    VL_Mensagem: TMensagem;
    VL_TLoja_Modulo_Conf_Funcao: TZQuery;
    VL_Tag: ansistring;
    VL_Loja_Modulo_Conf_Funcao_ID: int64;
    VL_Linha: string;
    VL_Erro: integer;
    VL_Habilitado: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TLoja_Modulo_Conf_Funcao := TZQuery.Create(DComunicador);
    VL_TLoja_Modulo_Conf_Funcao.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Linha := '';
    VL_Habilitado := '';
    VL_Erro := 0;
    VL_Loja_Modulo_Conf_Funcao_ID := 0;
    try
        try
            //verifica parametros
            VP_Mensagem.GetTag('00BC', VL_Loja_Modulo_Conf_Funcao_ID);  // ID DA TABELA  MODULO_CONF_FUNCAO
            VP_Mensagem.GetTag('0089', VL_Habilitado);  // HABILITADO DA TABELA  MODULO_CONF_FUNCAO

            if VL_Loja_Modulo_Conf_Funcao_ID < 1 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00BF', 'R');
                VL_Mensagem.Addtag('004D', '45');  //parametro vazio
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '010620220856';
                GravaLog(F_ArquivoLog, 0, '00BF', 'CADASTRO', VL_Linha, 'parametro informado na Tag:00BC esta nula ou zerada', '', VL_Erro);
                Exit;
            end;
            //verifica permissao
            if TTConexao(VP_AContext.Data).Permissao <> pmC then   // nao tem permissao para dar manutencao ao cadastro de modulo_conf_funcao
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00BF', 'R');
                VL_Mensagem.Addtag('004D', '45');  //sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '260520221715';
                GravaLog(F_ArquivoLog, 0, '00BF', 'CADASTRO', VL_Linha, 'nao tem permissao para dar manutencao ao cadastro de loja_modulo_conf_funcao',
                    '', VL_Erro);
                Exit;
            end;

            //verifica se existe o id pra loja_modulo_conf_funcao
            VL_TLoja_Modulo_Conf_Funcao.Close;
            VL_TLoja_Modulo_Conf_Funcao.SQL.Text := 'SELECT * FROM LOJA_MODULO_CONF_FUNCAO WHERE ID=' + IntToStr(VL_Loja_Modulo_Conf_Funcao_ID);
            VL_Erro := 55;
            VL_Linha := '010620220857';
            VL_TLoja_Modulo_Conf_Funcao.Open;

            if VL_TLoja_Modulo_Conf_Funcao.RecordCount > 0 then
            begin
                //ALTERA o loja_modulo_conf_funcao
                VL_TLoja_Modulo_Conf_Funcao.Close;
                VL_TLoja_Modulo_Conf_Funcao.SQL.Text := 'UPDATE LOJA_MODULO_CONF_FUNCAO SET HABILITADO=''' + VL_HABILITADO + ''' WHERE ' +
                    'ID=' + IntToStr(VL_Loja_Modulo_Conf_Funcao_ID);
                VL_Erro := 46;
                VL_Linha := '010620220858';
                VL_TLoja_Modulo_Conf_Funcao.ExecSQL;

                VL_TLoja_Modulo_Conf_Funcao.Close;
                VL_TLoja_Modulo_Conf_Funcao.SQL.Text := 'SELECT * FROM LOJA_MODULO_CONF_FUNCAO WHERE ID=' + IntToStr(VL_Loja_Modulo_Conf_Funcao_ID);
                VL_Erro := 55;
                VL_Linha := '010620220859';
                VL_TLoja_Modulo_Conf_Funcao.Open;

                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00BF', 'R');
                VL_Mensagem.AddTag('004D', '0');
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                exit;
            end;
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('00BF', 'R');
            VL_Mensagem.AddTag('004D', '46');
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '00BF', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '00BF', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_TLoja_Modulo_Conf_Funcao.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '00BF', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando00C2(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro PDV_FUNCAO INCLUIR
var
    VL_Mensagem: TMensagem;
    VL_Tabela: TRxMemoryData;
    VL_TPdv_Funcao: TZQuery;
    VL_Tag: ansistring;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_Tabela := TRxMemoryData.Create(nil);
    VL_TPdv_Funcao := TZQuery.Create(DComunicador);
    VL_TPdv_Funcao.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Linha := '';
    VL_Erro := 0;
    try
        try
            //verifica permissao
            if ((TTConexao(VP_AContext.Data).Permissao = pmU) or (TTConexao(VP_AContext.Data).Permissao = pmS)) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00C2', 'R');
                VL_Mensagem.AddTag('004D', '45');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '180520221133';
                GravaLog(F_ArquivoLog, 0, '00C2', 'cadastro', VL_Linha, 'sem permissão para gerenciar a inclusão de registro na tabela pdv_funcao',
                    '', VL_Erro);
                Exit;
            end;
            //VERIFICA PARAMETROS
            VP_Mensagem.GetTag('00C1', VL_Tag); // tabela pdv_funcao
            if Length(VL_Tag) = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00C2', 'R');
                VL_Mensagem.AddTag('004D', '47');//PARAMETRO VAZIO
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '030620220957';
                GravaLog(F_ArquivoLog, 0, '00C2', 'cadastro', VL_Linha, 'o parametro informado na Tag:00C1 esta nulo ou zerado', '', VL_Erro);
                Exit;
            end;
            StrToRxMemData(VL_Tag, VL_Tabela);
            VL_Tabela.Open;

            VL_Tabela.First;
            while not VL_Tabela.EOF do
            begin
                if ((VL_Tabela.FieldByName('VALIDADO').AsBoolean = True) and (VL_Tabela.FieldByName('ID').AsInteger = 0)) then
                begin
                    //verifica se o pdv_funcao ja foi cadastrado
                    VL_TPdv_Funcao.Close;
                    VL_TPdv_Funcao.SQL.Text := 'SELECT FIRST 1 ID FROM PDV_FUNCAO WHERE PDV_ID=''' +
                        VL_Tabela.FieldByName('PDV_ID').AsString + ''' AND TAG_NUMERO=''' +
                        VL_Tabela.FieldByName('TAG_NUMERO').AsString + '''';
                    VL_Erro := 55;
                    VL_Linha := '030620220958';
                    VL_TPdv_Funcao.Open;

                    if VL_TPdv_Funcao.RecordCount > 0 then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('00C2', 'R');
                        VL_Mensagem.AddTag('004D', '43');//duplicidade
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        VL_Erro := 43;
                        VL_Linha := '180520221134';
                        GravaLog(F_ArquivoLog, 0, '00C2', 'cadastro', VL_Linha,
                            'registro em duplicidade na tabela pdv_funcao, ja existe uma função cadastrada com este pdv e esta tag', '', VL_Erro);
                        Exit;
                    end;
                    //TESTA CAMPOS OBRIGATORIOS
                    if ((length(VL_Tabela.FieldByName('PDV_ID').AsString) = 0) or
                        (length(VL_Tabela.FieldByName('TAG_NUMERO').AsString) = 0)) then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('00C2', 'R');
                        VL_Mensagem.AddTag('004D', '52');//campos nulos
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        VL_Erro := 52;
                        VL_Linha := '180520221135';
                        GravaLog(F_ArquivoLog, 0, '00C2', 'cadastro', VL_Linha,
                            'campos obrigatório não pode ser nulo na inclusão de registro na tabela pdv_funcao',
                            '', VL_Erro);
                        Exit;
                    end;
                    //COMEÇA A INCLUSÃO
                    VL_TPdv_Funcao.Close;
                    VL_TPdv_Funcao.SQL.Text := 'INSERT INTO PDV_FUNCAO(' +
                        'PDV_ID,' +
                        'TAG_NUMERO)VALUES(' +
                        IntToStr(VL_Tabela.FieldByName('PDV_ID').AsInteger) + ',''' +
                        VL_Tabela.FieldByName('TAG_NUMERO').AsString + ''')';
                    VL_Erro := 44;
                    VL_Linha := '030620221001';
                    VL_TPdv_Funcao.ExecSQL;

                    VL_TPdv_Funcao.Close;
                    VL_TPdv_Funcao.SQL.Text := 'SELECT * FROM PDV_FUNCAO WHERE PDV_ID=''' +
                        VL_Tabela.FieldByName('PDV_ID').AsString + ''' AND TAG_NUMERO=''' +
                        VL_Tabela.FieldByName('TAG_NUMERO').AsString + '''';
                    VL_Erro := 55;
                    VL_Linha := '030620221003';
                    VL_TPdv_Funcao.Open;

                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('00C2', 'R');
                    VL_Mensagem.AddTag('004D', '0');
                    VL_Mensagem.AddTag('00C3', VL_TPdv_Funcao.FieldByName('ID').AsString);
                    DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                    exit;
                end;
                VL_Tabela.Next;
            end;
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('00C2', 'R');
            VL_Mensagem.AddTag('004D', '44');
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '00C2', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '00C2', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_Tabela.Free;
            VL_TPdv_Funcao.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '00C2', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando00C4(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro PDV_FUNCAO ALTERAR
var
    VL_Mensagem: TMensagem;
    VL_TPdv_Funcao: TZQuery;
    VL_Tag: ansistring;
    VL_Pdv_Funcao_ID: int64;
    VL_Linha: string;
    VL_Erro: integer;
    VL_Habilitado: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TPdv_Funcao := TZQuery.Create(DComunicador);
    VL_TPdv_Funcao.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Linha := '';
    VL_Habilitado := '';
    VL_Erro := 0;
    VL_Pdv_Funcao_ID := 0;
    try
        try
            //verifica parametros
            VP_Mensagem.GetTag('00C3', VL_Pdv_Funcao_ID);  // ID DA TABELA  PDV_FUNCAO
            VP_Mensagem.GetTag('00C0', VL_Habilitado);  // HABILITADO DA TABELA  PDV_FUNCAO

            if VL_Pdv_Funcao_ID = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00C4', 'R');
                VL_Mensagem.AddTag('004D', '47');//PARAMETRO VAZIO
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '030620221012';
                GravaLog(F_ArquivoLog, 0, '00C4', 'CADASTRO', VL_Linha, 'o parametro informado na Tag:00C3 esta nulo ou zerado', '', VL_Erro);
                Exit;
            end;
            //verifica permissao
            if TTConexao(VP_AContext.Data).Permissao <> pmC then   // nao tem permissao para dar manutencao ao cadastro de pinpad funcao
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00C4', 'R');
                VL_Mensagem.AddTag('004D', '45');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '240520221143';
                GravaLog(F_ArquivoLog, 0, '00C4', 'CADASTRO', VL_Linha, 'nao tem permissao para dar manutencao ao cadastro de pdv funcao', '', VL_Erro);
                Exit;
            end;

            //verifica se existe o id pra pdv_funcao
            VL_TPdv_Funcao.Close;
            VL_TPdv_Funcao.SQL.Text := 'SELECT * FROM PDV_FUNCAO WHERE ID=' + IntToStr(VL_Pdv_Funcao_ID);
            VL_Erro := 55;
            VL_Linha := '030620221013';
            VL_TPdv_Funcao.Open;

            if VL_TPdv_Funcao.RecordCount > 0 then
            begin
                //ALTERA o PINPAD_FUNC
                VL_TPdv_Funcao.Close;
                VL_TPdv_Funcao.SQL.Text := 'UPDATE PDV_FUNCAO SET HABILITADO=''' + VL_HABILITADO + ''' WHERE ' +
                    'ID=' + IntToStr(VL_Pdv_Funcao_ID);
                VL_Erro := 46;
                VL_Linha := '030620221015';
                VL_TPdv_Funcao.ExecSQL;

                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00C4', 'R');
                VL_Mensagem.AddTag('004D', '0');
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                Exit;
            end
            else
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00C4', 'R');
                VL_Mensagem.AddTag('004D', '46');
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
            end;
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '00C4', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '00C4', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_TPdv_Funcao.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '00C4', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando00C5(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro PDV_FUNCAO EXCLUIR
var
    VL_Mensagem: TMensagem;
    VL_TPdv_Funcao: TZQuery;
    VL_Tag: ansistring;
    VL_Pdv_Funcao_ID: int64;
    VL_Linha: string;
    VL_Erro: integer;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TPdv_Funcao := TZQuery.Create(DComunicador);
    VL_TPdv_Funcao.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Linha := '';
    VL_Erro := 0;
    VL_Pdv_Funcao_ID := 0;
    try
        try
            //verifica parametros
            VP_Mensagem.GetTag('00C3', VL_Pdv_Funcao_ID);  // ID DA TABELA  PDV_FUNCAO
            if VL_Pdv_Funcao_ID = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00C5', 'R');
                VL_Mensagem.AddTag('004D', '47');//PARAMETRO NULO
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '030620221022';
                GravaLog(F_ArquivoLog, 0, '00C5', 'CADASTRO', VL_Linha, 'o parametro informado na Tag:00C3 esta nulo ou zerado', '', VL_Erro);
                Exit;
            end;
            //verifica permissao
            if TTConexao(VP_AContext.Data).Permissao <> pmC then   // nao tem permissao para dar manutencao ao cadastro de modulo funcao
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00C5', 'R');
                VL_Mensagem.AddTag('004D', '45');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '180520221142';
                GravaLog(F_ArquivoLog, 0, '00C5', 'CADASTRO', VL_Linha, 'nao tem permissao para dar manutencao ao cadastro de pdv funcao', '', VL_Erro);
                Exit;
            end;
            //verifica se existe o id pra pdv_função
            VL_TPdv_Funcao.Close;
            VL_TPdv_Funcao.SQL.Text := 'SELECT * FROM PDV_FUNCAO WHERE ID=' + IntToStr(VL_Pdv_Funcao_ID);
            VL_Erro := 55;
            VL_Linha := '030620221023';
            VL_TPdv_Funcao.Open;

            if VL_TPdv_Funcao.RecordCount > 0 then
            begin
                //exclui o pdv_funcao
                VL_TPdv_Funcao.Close;
                VL_TPdv_Funcao.SQL.Text := 'DELETE FROM PDV_FUNCAO WHERE ' +
                    'ID=' + IntToStr(VL_Pdv_Funcao_ID);
                VL_Erro := 82;
                VL_Linha := '030620221024';
                VL_TPdv_Funcao.ExecSQL;

                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00C5', 'R');
                VL_Mensagem.AddTag('004D', '0');
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
            end
            else
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00C5', 'R');
                VL_Mensagem.AddTag('004D', '82');
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
            end;
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '00C5', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '00C5', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_TPdv_Funcao.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '00C5', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando00C8(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro PDV_MODULO INCLUIR
var
    VL_Mensagem: TMensagem;
    VL_Tabela: TRxMemoryData;
    VL_TPdvModulo: TZQuery;
    VL_Tag: ansistring;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_Tabela := TRxMemoryData.Create(nil);
    VL_TPdvModulo := TZQuery.Create(DComunicador);
    VL_TPdvModulo.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Linha := '';
    VL_Erro := 0;
    try
        try
            //verifica permissao
            if ((TTConexao(VP_AContext.Data).Permissao = pmU) or (TTConexao(VP_AContext.Data).Permissao = pmS)) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00C8', 'R');
                VL_Mensagem.AddTag('004D', '45');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '180520221451';
                GravaLog(F_ArquivoLog, 0, '00C8', 'cadastro', VL_Linha, 'sem permissão para gerenciar a inclusão de registro na tabela pdv_modulo_conf',
                    '', VL_Erro);
                Exit;
            end;
            //VERIFICA PARAMETROS
            VP_Mensagem.GetTag('00C7', VL_Tag); //tabela pdv_modulo
            if Length(VL_Tag) = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00C8', 'R');
                VL_Mensagem.AddTag('004D', '47');//PARAMETRO VAZIO
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '030620220922';
                GravaLog(F_ArquivoLog, 0, '00C8', 'cadastro', VL_Linha, 'sem permissão para gerenciar a inclusão de registro na tabela pdv_modulo_conf',
                    '', VL_Erro);
                Exit;
            end;
            StrToRxMemData(VL_Tag, VL_Tabela);
            VL_Tabela.Open;

            VL_Tabela.First;
            while not VL_Tabela.EOF do
            begin
                if (VL_Tabela.FieldByName('ID').AsInteger = 0) then
                begin
                    //verifica se o pdv_modulo ja foi cadastrado
                    VL_TPdvModulo.Close;
                    VL_TPdvModulo.SQL.Text := 'SELECT FIRST 1 ID FROM PDV_MODULO_CONF WHERE MODULO_CONF_ID=''' +
                        VL_Tabela.FieldByName('MODULO_CONF_ID').AsString + ''' AND TAG_NUMERO=''' +
                        VL_Tabela.FieldByName('TAG_NUMERO').AsString + '''';
                    VL_Erro := 55;
                    VL_Linha := '030620220923';
                    VL_TPdvModulo.Open;

                    if VL_TPdvModulo.RecordCount > 0 then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('00C8', 'R');
                        VL_Mensagem.AddTag('004D', '43');//duplicidade
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        VL_Erro := 43;
                        VL_Linha := '180520221452';
                        GravaLog(F_ArquivoLog, 0, '00C8', 'cadastro', VL_Linha,
                            'registro em duplicidade na tabela pdv_modulo_conf, ja existe um modulo config cadastrada com esta configuracao: (modulo_conf = ' +
                            VL_Tabela.FieldByName('MODULO_CONF_ID').AsString + ') (pdv_id =' +
                            VL_Tabela.FieldByName('PDV_ID').AsString + ')', '', VL_Erro);
                        Exit;
                    end;

                    VL_TPdvModulo.Close;
                    VL_TPdvModulo.SQL.Text := 'INSERT INTO PDV_MODULO_CONF(' +
                        'PDV_ID,' +
                        'TAG_NUMERO,' +
                        'CODIGO,' +
                        'HABILITADO,' +
                        'MODULO_CONF_ID)VALUES(' +
                        IntToStr(VL_Tabela.FieldByName('PDV_ID').AsInteger) + ',''' +
                        VL_Tabela.FieldByName('TAG_NUMERO').AsString + ''',''' +
                        VL_Tabela.FieldByName('CODIGO').AsString + ''',''' +
                        VL_Tabela.FieldByName('HABILITADO').AsString + ''',' +
                        IntToStr(VL_Tabela.FieldByName('MODULO_CONF_ID').AsInteger) + ')';
                    VL_Erro := 44;
                    VL_Linha := '030620220924';
                    VL_TPdvModulo.ExecSQL;

                    VL_TPdvModulo.Close;
                    VL_TPdvModulo.SQL.Text := 'SELECT * FROM PDV_MODULO_CONF WHERE MODULO_CONF_ID=''' +
                        VL_Tabela.FieldByName('MODULO_CONF_ID').AsString + ''' AND TAG_NUMERO=''' +
                        VL_Tabela.FieldByName('TAG_NUMERO').AsString + '''';
                    VL_Erro := 55;
                    VL_Linha := '030620220925';
                    VL_TPdvModulo.Open;

                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('00C8', 'R');
                    VL_Mensagem.AddTag('004D', '0');
                    VL_Mensagem.AddTag('00C9', VL_TPdvModulo.FieldByName('ID').AsString);
                    DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                    exit;
                end;
                VL_Tabela.Next;
            end;
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('00C8', 'R');
            VL_Mensagem.AddTag('004D', '44');
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '00C8', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '00C8', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_Tabela.Free;
            VL_TPdvModulo.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '00C8', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando00CA(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro MULTILOJA_MODULO_CONF_FUNCAO INCLUIR
var
    VL_Mensagem: TMensagem;
    VL_Tabela: TRxMemoryData;
    VL_TMultiLojaModuloConfFuncao: TZQuery;
    VL_Tag: ansistring;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_Tabela := TRxMemoryData.Create(nil);
    VL_TMultiLojaModuloConfFuncao := TZQuery.Create(DComunicador);
    VL_TMultiLojaModuloConfFuncao.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Linha := '';
    VL_Erro := 0;
    try
        try
            //verifica permissao
            if TTConexao(VP_AContext.Data).Permissao <> pmC then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00CA', 'R');
                VL_Mensagem.AddTag('004D', '45');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '270520220856';
                GravaLog(F_ArquivoLog, 0, '00CA', 'cadastro', VL_Linha,
                    'sem permissão para gerenciar a inclusão de registro na tabela multiloja_modulo_conf_funcao',
                    '', VL_Erro);
                Exit;
            end;
            //verifica parametro
            VP_Mensagem.GetTag('00D0', VL_Tag); //tabela multiloja_modulo_conf_funcao
            if Length(vl_tag) = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00CA', 'R');
                VL_Mensagem.AddTag('004D', '47');//dados zerados
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '020620221027';
                GravaLog(F_ArquivoLog, 0, '00CA', 'cadastro', VL_Linha, 'o parametro informado na Tag:00D0 está nulo ou zerado', '', VL_Erro);
                Exit;
            end;
            StrToRxMemData(VL_Tag, VL_Tabela);
            VL_Tabela.Open;
            VL_Tabela.First;
            while not VL_Tabela.EOF do
            begin
                if ((VL_Tabela.FieldByName('VALIDADO').AsBoolean = True) and (VL_Tabela.FieldByName('ID').AsInteger = 0)) then
                begin
                    //verifica se a loja_modulo_conf_func ja foi cadastrado
                    VL_TMultiLojaModuloConfFuncao.Close;
                    VL_TMultiLojaModuloConfFuncao.SQL.Text := 'SELECT FIRST 1 ID FROM MULTILOJA_MODULO_CONF_FUNCAO WHERE MULTILOJA_MODULO_CONF_ID=''' +
                        VL_Tabela.FieldByName('MULTILOJA_MODULO_CONF_ID').AsString + ''' AND TAG_NUMERO=''' +
                        VL_Tabela.FieldByName('TAG_NUMERO').AsString + '''';
                    VL_Erro := 55;
                    VL_Linha := '020620221028';
                    VL_TMultiLojaModuloConfFuncao.Open;

                    if VL_TMultiLojaModuloConfFuncao.RecordCount > 0 then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('00CA', 'R');
                        VL_Mensagem.AddTag('004D', '43');
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        VL_Erro := 43;
                        VL_Linha := '270520220859';
                        GravaLog(F_ArquivoLog, 0, '00CA', 'cadastro', VL_Linha,
                            'registro em duplicidade na tabela multiloja_modulo_conf_funcao, ja existe uma função cadastrada com este multiloja_modulo_conf e esta tag',
                            '', VL_Erro);
                        Exit;
                    end;
                    //TESTA CAMPOS OBRIGATORIOS
                    if ((length(VL_Tabela.FieldByName('MULTILOJA_MODULO_CONF_ID').AsString) = 0) or
                        (length(VL_Tabela.FieldByName('TAG_NUMERO').AsString) = 0)) then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('00CA', 'R');
                        VL_Mensagem.AddTag('004D', '52');//campos nulos
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        VL_Erro := 52;
                        VL_Linha := '270520220900';
                        GravaLog(F_ArquivoLog, 0, '00CA', 'cadastro', VL_Linha,
                            'campos obrigatório não pode ser nulo na inclusão de registro na tabela multiloja_modulo_conf_funcao',
                            '', VL_Erro);
                        Exit;
                    end;
                    //começa a inclusão
                    VL_TMultiLojaModuloConfFuncao.Close;
                    VL_TMultiLojaModuloConfFuncao.SQL.Text := 'INSERT INTO MULTILOJA_MODULO_CONF_FUNCAO(' +
                        'MULTILOJA_MODULO_CONF_ID,' +
                        'TAG_NUMERO)VALUES(' +
                        IntToStr(VL_Tabela.FieldByName('MULTILOJA_MODULO_CONF_ID').AsInteger) + ',''' +
                        VL_Tabela.FieldByName('TAG_NUMERO').AsString + ''')';
                    VL_Erro := 44;
                    VL_Linha := '020620221033';
                    VL_TMultiLojaModuloConfFuncao.ExecSQL;
                    VL_TMultiLojaModuloConfFuncao.Close;

                    VL_TMultiLojaModuloConfFuncao.SQL.Text := 'SELECT * FROM MULTILOJA_MODULO_CONF_FUNCAO WHERE MULTILOJA_MODULO_CONF_ID=' +
                        VL_Tabela.FieldByName(
                        'MULTILOJA_MODULO_CONF_ID').AsString + ' AND TAG_NUMERO=''' + VL_Tabela.FieldByName('TAG_NUMERO').AsString + '''';
                    VL_Erro := 55;
                    VL_Linha := '020620221034';
                    VL_TMultiLojaModuloConfFuncao.Open;

                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('00CA', 'R');
                    VL_Mensagem.AddTag('004D', '0');
                    VL_Mensagem.AddTag('00BD', VL_TMultiLojaModuloConfFuncao.FieldByName('ID').AsString);
                    DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                    exit;
                end;
                VL_Tabela.Next;
            end;
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '00CA', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '00CA', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_Tabela.Free;
            VL_TMultiLojaModuloConfFuncao.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '00CA', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando00CB(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro PDV_MODULO ALTERAR
var
    VL_Mensagem: TMensagem;
    VL_TPdv_Modulo: TZQuery;
    VL_Tabela: TRxMemoryData;
    VL_Tag: ansistring;
    VL_ID: int64;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TPdv_Modulo := TZQuery.Create(DComunicador);
    VL_TPdv_Modulo.Connection := DNucleo.ZConexao;
    VL_Tabela := TRxMemoryData.Create(nil);
    VL_Tag := '';
    VL_ID := 0;
    VL_Erro := 0;
    VL_Linha := '';
    try
        try
            //verifica permissão
            if ((TTConexao(VP_AContext.Data).Permissao = pmU) or (TTConexao(VP_AContext.Data).Permissao = pmS)) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00CB', 'R');
                VL_Mensagem.AddTag('004D', '45');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '180520221507';
                GravaLog(F_ArquivoLog, 0, '00CB', 'cadastro', VL_Linha, 'sem permissão para gerenciar a alteração de dados da tabela pdv_modulo_conf',
                    '', VL_Erro);
                Exit;
            end;
            //VERIFICA PARAMETROS
            VP_Mensagem.GetTag('00C7', VL_Tag); //carrega tabela pdv_modulo
            if Length(VL_Tag) = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00CB', 'R');
                VL_Mensagem.AddTag('004D', '47');//PARAMETRO VAZIO
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '030620220936';
                GravaLog(F_ArquivoLog, 0, '00CB', 'cadastro', VL_Linha, 'o parametro informado na Tag:00C7 esta nulo ou zerado', '', VL_Erro);
                Exit;
            end;
            StrToRxMemData(VL_Tag, VL_Tabela);
            VL_Tabela.Open;

            VP_Mensagem.GetTag('00C9', VL_ID); //pdv_modulo_id
            if VL_ID < 1 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00CB', 'R');
                VL_Mensagem.AddTag('004D', '47');//dados informado não pode ser zero
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '180520221508';
                GravaLog(F_ArquivoLog, 0, '00CB', 'cadastro', VL_Linha, 'alteração não executada, o id informado da pdv_modulo_conf não pode ser zero',
                    '', VL_Erro);
                Exit;
            end;
            //verifica se existe o registro para alterar
            VL_TPdv_Modulo.Close;
            VL_TPdv_Modulo.SQL.Text := 'SELECT * FROM PDV_MODULO_CONF WHERE ID=' + IntToStr(VL_ID);
            VL_Erro := 55;
            VL_Linha := '030620220937';
            VL_TPdv_Modulo.Open;

            if VL_TPdv_Modulo.RecordCount = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00CB', 'R');
                VL_Mensagem.AddTag('004D', '48');//registro não localizado
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 48;
                VL_Linha := '180520221509';
                GravaLog(F_ArquivoLog, 0, '00CB', 'cadastro', VL_Linha, 'o registro numero:' + IntToStr(VL_ID) +
                    ' informado não foi encontrado na tabela pdv_modulo_conf',
                    '', VL_Erro);
                Exit;
            end;

            if VL_Tabela.Locate('ID', VL_ID, []) then
            begin
                if ((VL_Tabela.FieldByName('ID').AsInteger <> VL_TPdv_Modulo.FieldByName('ID').AsInteger) or
                    (VL_Tabela.FieldByName('PDV_ID').AsInteger <> VL_TPdv_Modulo.FieldByName('PDV_ID').AsInteger)) then
                begin
                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('00CB', 'R');
                    VL_Mensagem.AddTag('004D', '49');//dados chaves não podem sofer alteração
                    DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                    VL_Erro := 49;
                    VL_Linha := '180520221510';
                    GravaLog(F_ArquivoLog, 0, '00CB', 'cadastro', VL_Linha,
                        'dados chaves não podem sofer alteração(id/pdv_id) na tabela pdv_modulo_conf não pode alterar',
                        '', VL_Erro);
                    Exit;
                end;
                //COMEÇA A ALTERAÇÃO
                VL_TPdv_Modulo.Close;
                VL_TPdv_Modulo.SQL.Text := 'UPDATE PDV_MODULO_CONF SET ' +
                    'TAG_NUMERO=''' + VL_Tabela.FieldByName('TAG_NUMERO').AsString + ''',' +
                    'CODIGO=''' + VL_Tabela.FieldByName('CODIGO').AsString + ''',' +
                    'HABILITADO=''' + VL_Tabela.FieldByName('HABILITADO').AsString + ''',' +
                    'MODULO_CONF_ID=' + IntToStr(VL_Tabela.FieldByName('MODULO_CONF_ID').AsInteger) + ' WHERE ' +
                    'ID=' + IntToStr(VL_ID);
                VL_Erro := 46;
                VL_Linha := '030620220940';
                VL_TPdv_Modulo.ExecSQL;

                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00CB', 'R');//alteração aceita
                VL_Mensagem.AddTag('004D', '0');
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                Exit;
            end
            else
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00CB', 'R');
                VL_Mensagem.AddComando('004D', '46');//46 erro na alteração do registro
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
            end;
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '00CB', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '00CB', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_Tabela.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '00CB', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando00CC(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro PDV_MODULO EXCLUIR
var
    VL_Mensagem: TMensagem;
    VL_TPdv_Modulo: TZQuery;
    VL_ID: int64;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TPdv_Modulo := TZQuery.Create(DComunicador);
    VL_TPdv_Modulo.Connection := DNucleo.ZConexao;
    VL_ID := 0;
    VL_Erro := 0;
    VL_Linha := '';
    try
        try
            //verifica parametros
            VP_Mensagem.GetTag('00C9', VL_ID); //pdv_modulo_id
            if VL_ID < 1 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00CC', 'R');
                VL_Mensagem.AddTag('004D', '47');//campo não pode ser zero
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '180520221525';
                GravaLog(F_ArquivoLog, 0, '00CC', 'cadastro', VL_Linha, 'campo id para exclusão na tabela pdv_modulo_conf não pode ser zero', '', VL_Erro);
                Exit;
            end;
            //verifica permissao
            if ((TTConexao(VP_AContext.Data).Permissao = pmU) or (TTConexao(VP_AContext.Data).Permissao = pmS)) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00CC', 'R');
                VL_Mensagem.AddTag('004D', '45');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '180520221526';
                GravaLog(F_ArquivoLog, 0, '00CC', 'cadastro', VL_Linha, 'sem permissão para gerenciar exclusão na tabela pdv_modulo_conf', '', VL_Erro);
                Exit;
            end;
            //verifica se existe o id pra exclusão
            VL_TPdv_Modulo.Close;
            VL_TPdv_Modulo.SQL.Text := 'SELECT * FROM PDV_MODULO_CONF WHERE ID=' + IntToStr(VL_ID);
            VL_Erro := 55;
            VL_Linha := '030620220947';
            VL_TPdv_Modulo.Open;

            if VL_TPdv_Modulo.RecordCount = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00CC', 'R');
                VL_Mensagem.AddTag('004D', '48');//id não encontrado na tabela
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 48;
                VL_Linha := '180520221527';
                GravaLog(F_ArquivoLog, 0, '00CC', 'cadastro', VL_Linha, 'campo informado ID numero:' + IntToStr(VL_ID) +
                    ' para exclusão não foi localizado na tabela pdv_modulo_conf', '', VL_Erro);
                Exit;
            end;
            //exclui pdv_modulo
            VL_TPdv_Modulo.Close;
            VL_TPdv_Modulo.SQL.Text := 'DELETE FROM PDV_MODULO_CONF WHERE ' + 'ID=' + IntToStr(VL_ID);
            VL_Erro := 82;
            VL_Linha := '030620220948';
            VL_TPdv_Modulo.ExecSQL;

            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('00CC', 'R');
            VL_Mensagem.AddTag('004D', '0');
            VL_Mensagem.AddTag('00C9', VL_ID); //retorno pdv_id
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '00CC', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '00CC', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_TPdv_Modulo.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '00CC', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando00DB(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro TAG ALTERAR
var
    VL_Mensagem: TMensagem;
    VL_TTag: TZQuery;
    VL_Tabela: TRxMemoryData;
    VL_Tag: ansistring;
    VL_ID: int64;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TTag := TZQuery.Create(DComunicador);
    VL_TTag.Connection := DNucleo.ZConexao;
    VL_Tabela := TRxMemoryData.Create(nil);
    VL_Tag := '';
    VL_ID := 0;
    VL_Erro := 0;
    VL_Linha := '';
    try
        try
            //verifica permissão
            if (TTConexao(VP_AContext.Data).Permissao <> pmC) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00DB', 'R');
                VL_Mensagem.Addtag('004D', '45'); //sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '300520220826';
                GravaLog(F_ArquivoLog, 0, '00DB', 'cadastro', VL_Linha, 'sem permissão para gerenciar a alteração de dados da tabela tag',
                    '', VL_Erro);
                Exit;
            end;
            //verifica parametros
            VP_Mensagem.GetTag('0081', VL_Tag); //carrega tabela tag
            if Length(VL_Tag) = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00DB', 'R');
                VL_Mensagem.AddTag('004D', '47');//DADOS INFORMADOS VAZIO
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '300520220830';
                GravaLog(F_ArquivoLog, 0, '00DB', 'CADASTRO', VL_Linha, 'parametro informado na Tag:0081 esta vazia ou zerada', '', VL_Erro);
                Exit;
            end;
            StrToRxMemData(VL_Tag, VL_Tabela);
            VL_Tabela.Open;

            VP_Mensagem.GetTag('006E', VL_ID); //tag_id
            if VL_ID < 1 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00DB', 'R');
                VL_Mensagem.AddTag('004D', '47');//dados informado não pode ser zero
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '300520220832';
                GravaLog(F_ArquivoLog, 0, '00DB', 'cadastro', VL_Linha, 'alteração não executada, o id informado da tag não pode ser zero',
                    '', VL_Erro);
                Exit;
            end;
            //verifica se existe o registro para alterar
            VL_TTag.Close;
            VL_TTag.SQL.Text := 'SELECT * FROM TAG WHERE ID=' + IntToStr(VL_ID);
            VL_Erro := 55;
            VL_Linha := '300520220836';
            VL_TTag.Open;

            if VL_TTag.RecordCount = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00DB', 'R');
                VL_Mensagem.AddTag('004D', '48'); //registro não localizado
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 48;
                VL_Linha := '300520220837';
                GravaLog(F_ArquivoLog, 0, '00DB', 'cadastro', VL_Linha, 'o registro numero:' + IntToStr(VL_ID) +
                    ' informado não foi encontrado na tabela tag',
                    '', VL_Erro);
                Exit;
            end;

            if VL_Tabela.Locate('ID', VL_ID, []) then
            begin
                if ((VL_Tabela.FieldByName('ID').AsInteger <> VL_TTag.FieldByName('ID').AsInteger) or
                    (VL_Tabela.FieldByName('TAG_NUMERO').AsString <> VL_TTag.FieldByName('TAG_NUMERO').AsString)) then
                begin
                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('00DB', 'R');
                    VL_Mensagem.AddTag('004D', '49'); //dados chaves não podem sofer alteração
                    DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                    VL_Erro := 49;
                    VL_Linha := '300520220841';
                    GravaLog(F_ArquivoLog, 0, '00DB', 'cadastro', VL_Linha,
                        'dados chaves não podem sofer alteração(id/tag_numero) na tabela tag não pode alterar',
                        '', VL_Erro);
                    Exit;
                end;
                VL_TTag.Close;
                VL_TTag.SQL.Text := 'UPDATE TAG SET ' +
                    'TAG_NUMERO=''' + VL_Tabela.FieldByName('TAG_NUMERO').AsString + ''',' +
                    'TAG_TIPO=''' + VL_Tabela.FieldByName('TAG_TIPO').AsString + ''',' +
                    'DEFINICAO=''' + VL_Tabela.FieldByName('DEFINICAO').AsString + ''',' +
                    'TIPO_DADOS=''' + VL_Tabela.FieldByName('TIPO_DADOS').AsString + ''',' +
                    'OBS=''' + VL_Tabela.FieldByName('OBS').AsString + ''',' +
                    'PADRAO=''' + VL_Tabela.FieldByName('PADRAO').AsString + ''',' +
                    'DADOS=''' + VL_Tabela.FieldByName('DADOS').AsString + '''' +
                    ' WHERE ' +
                    'ID=' + IntToStr(VL_ID);
                VL_Erro := 46;
                VL_Linha := '300520220847';
                VL_TTag.ExecSQL;

                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00DB', 'R');//alteração aceita
                VL_Mensagem.AddTag('004D', '0');
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
            end
            else
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00DB', 'R');
                VL_Mensagem.AddTag('004D', '46');
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
            end;
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                        //FreeAndNil(DNucleo);
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '00DB', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '00DB', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_Tabela.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                    //FreeAndNil(DNucleo);
                end;

            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '00DB', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando00DC(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro TAG EXCLUIR
var
    VL_Mensagem: TMensagem;
    VL_TTag: TZQuery;
    VL_ID: int64;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TTag := TZQuery.Create(DComunicador);
    VL_TTag.Connection := DNucleo.ZConexao;
    VL_ID := 0;
    VL_Erro := 0;
    VL_Linha := '';
    try
        try
            //verifica parametros
            VP_Mensagem.GetTag('006E', VL_ID); //tag_id
            if VL_ID = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00DC', 'R');
                VL_Mensagem.Addtag('004D', '47');//campo não pode ser zero
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '300520220907';
                GravaLog(F_ArquivoLog, 0, '00DC', 'cadastro', VL_Linha, 'campo id para exclusão na tabela tag não pode ser zero', '', VL_Erro);
                Exit;
            end;
            //verifica permissao
            if (TTConexao(VP_AContext.Data).Permissao <> pmC) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00DC', 'R');
                VL_Mensagem.Addtag('004D', '45');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '300520220909';
                GravaLog(F_ArquivoLog, 0, '00DC', 'cadastro', VL_Linha, 'sem permissão para gerenciar exclusão na tabela tag', '', VL_Erro);
                Exit;
            end;
            //verifica se existe o id pra exclusão
            VL_TTag.Close;
            VL_TTag.SQL.Text := 'SELECT * FROM TAG WHERE ID=' + IntToStr(VL_ID);
            VL_Erro := 55;
            VL_Linha := '300520220910';
            VL_TTag.Open;

            if VL_TTag.RecordCount = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00DC', 'R');
                VL_Mensagem.Addtag('004D', '48');// id não encontrado na tabela
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 48;
                VL_Linha := '300520220911';
                GravaLog(F_ArquivoLog, 0, '00DC', 'cadastro', VL_Linha, 'campo informado ID numero:' + IntToStr(VL_ID) +
                    ' para exclusão não foi localizado na tabela tag', '', VL_Erro);
                Exit;
            end
            else
            begin
                //verifica se a Tag não é de uso exclusivo do open-tef tag oficiais (só exclui tag proprietarias)
                if Hex2Dec64(VL_TTag.FieldByName('TAG_NUMERO').AsString) < 65280 then  //INTERVALO DE TAG PROPRIETARIA FF00(65280) A FFFF(65535)
                begin
                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('00DC', 'R');
                    VL_Mensagem.Addtag('004D', '87');// erro na exclusao na tabela
                    DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                    VL_Erro := 87;
                    VL_Linha := '290720221515';
                    GravaLog(F_ArquivoLog, 0, '00DC', 'cadastro', VL_Linha, 'a Tag: ' + VL_TTag.FieldByName('TAG_NUMERO').AsString +
                        ' é oficial de uso exclusivo do Open-Tef, não podera ser excluida.', '', VL_Erro);
                    Exit;
                end;

                //exclui tag
                VL_TTag.Close;
                VL_TTag.SQL.Text := 'DELETE FROM TAG WHERE ' + 'ID=' + IntToStr(VL_ID);
                VL_Erro := 46;
                VL_Linha := '300520220913';
                VL_TTag.ExecSQL;

                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00DC', 'R');
                VL_Mensagem.AddTag('004D', '0');
                VL_Mensagem.AddTag('006E', VL_ID); //retorno tag_id
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
            end;
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '00DC', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '00DC', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_TTag.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '00DC', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando00DE(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro ADQUIRENTE INCLUIR
var
    VL_Mensagem: TMensagem;
    VL_Tabela: TRxMemoryData;
    VL_TAdquirente: TZQuery;
    VL_Tag: ansistring;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_Tabela := TRxMemoryData.Create(nil);
    VL_TAdquirente := TZQuery.Create(DComunicador);
    VL_TAdquirente.Connection := DNucleo.ZConexao;
    VL_Tag := '';
    VL_Linha := '';
    VL_Erro := 0;
    try
        try
            //verifica permissao
            if (TTConexao(VP_AContext.Data).Permissao <> pmC) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00DE', 'R');
                VL_Mensagem.AddTag('004D', '45');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '300520221006';
                GravaLog(F_ArquivoLog, 0, '00DE', 'CADASTRO', VL_Linha, 'sem permissao para incluir registro na tabela Adquirente', '', VL_Erro);
                Exit;
            end;
            //CARREGA TABELA
            VP_Mensagem.GetTag('0082', VL_Tag);
            if Length(VL_Tag) = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00DE', 'R');
                VL_Mensagem.AddTag('004D', '47');//DADOS INFORMADOS VAZIO
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '300520221007';
                GravaLog(F_ArquivoLog, 0, '00DE', 'CADASTRO', VL_Linha, 'parametro informado na Tag:0082 esta vazia ou zerada', '', VL_Erro);
                Exit;
            end;
            StrToRxMemData(VL_Tag, VL_Tabela);
            VL_Tabela.Open;

            VL_Tabela.First;
            while not VL_Tabela.EOF do
            begin
                if VL_Tabela.FieldByName('ID').AsInteger = 0 then
                begin
                    //valida campos necessários
                    if (VL_Tabela.FieldByName('DESCRICAO').AsString = '') then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('00DE', 'R');
                        VL_Mensagem.AddTag('004D', '52');//DADOS INFORMADOS VAZIO
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        VL_Erro := 52;
                        VL_Linha := '300520221009';
                        GravaLog(F_ArquivoLog, 0, '00DE', 'CADASTRO', VL_Linha, 'campos obrigatórios vazio(descrição) na ' +
                            'tabela Adquirente', '', VL_Erro);
                        Exit;
                    end;
                    //VERIFICA SE EXISTE O ADQUIRENTE CADASTRADO
                    VL_TAdquirente.Close;
                    VL_TAdquirente.SQL.Text := 'SELECT * FROM ADQUIRENTE WHERE DESCRICAO=''' + VL_Tabela.FieldByName('DESCRICAO').AsString + '''';
                    VL_Erro := 55;
                    VL_Linha := '300520221012';
                    VL_TAdquirente.Open;

                    if VL_TAdquirente.RecordCount > 0 then
                    begin
                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('0052', 'R');
                        VL_Mensagem.AddTag('004D', '43');
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        VL_Erro := 43;
                        VL_Linha := '300520221013';
                        GravaLog(F_ArquivoLog, 0, '00DE', 'cadastro', VL_Linha, 'ja existe um registro cadastrado com esta descrição:' +
                            VL_Tabela.FieldByName('DESCRICAO').AsString + ' na tabela de Adquirente', '', VL_Erro);
                        Exit;
                    end
                    else
                    begin
                        VL_TAdquirente.Close;
                        VL_TAdquirente.SQL.Text := 'INSERT INTO ADQUIRENTE(' +
                            'DESCRICAO,' +
                            'CONTATO) VALUES(''' +
                            VL_Tabela.FieldByName('DESCRICAO').AsString + ''',''' +
                            VL_Tabela.FieldByName('CONTATO').AsString + ''')';
                        VL_Erro := 44;
                        VL_Linha := '300520221014';
                        VL_TAdquirente.ExecSQL;

                        VL_TAdquirente.Close;
                        VL_TAdquirente.SQL.Text := 'SELECT * FROM ADQUIRENTE WHERE DESCRICAO=''' + VL_Tabela.FieldByName('DESCRICAO').AsString + '''';
                        VL_Erro := 55;
                        VL_Linha := '060620220948';
                        VL_TAdquirente.Open;

                        VL_Mensagem.Limpar;
                        VL_Mensagem.AddComando('00DE', 'R');
                        VL_Mensagem.AddTag('004D', '0');
                        VL_Mensagem.AddTag('006F', VL_TAdquirente.FieldByName('ID').AsString);
                        DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                        exit;
                    end;
                end;
                VL_Tabela.Next;
            end;
            VL_Mensagem.Limpar;
            VL_Mensagem.AddComando('00DE', 'R');
            VL_Mensagem.AddTag('004D', '44');
            DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '00DE', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '00DE', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_Tabela.Free;
            VL_TAdquirente.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '00DE', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando00DF(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro ADQUIRENTE ALTERAR
var
    VL_Mensagem: TMensagem;
    VL_TAdquirente: TZQuery;
    VL_Tabela: TRxMemoryData;
    VL_Tag: ansistring;
    VL_ID: int64;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TAdquirente := TZQuery.Create(DComunicador);
    VL_TAdquirente.Connection := DNucleo.ZConexao;
    VL_Tabela := TRxMemoryData.Create(nil);
    VL_Tag := '';
    VL_ID := 0;
    VL_Erro := 0;
    VL_Linha := '';
    try
        try
            //verifica permissão
            if (TTConexao(VP_AContext.Data).Permissao <> pmC) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00DF', 'R');
                VL_Mensagem.Addtag('004D', '45'); //sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '300520221027';
                GravaLog(F_ArquivoLog, 0, '00DF', 'cadastro', VL_Linha, 'sem permissão para gerenciar a alteração de dados da tabela adquirente',
                    '', VL_Erro);
                Exit;
            end;
            //verifica parametros
            VP_Mensagem.GetTag('0082', VL_Tag); //carrega tabela adquirente

            if Length(VL_Tag) = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00DF', 'R');
                VL_Mensagem.AddTag('004D', '47');//DADOS INFORMADOS VAZIO
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '300520221028';
                GravaLog(F_ArquivoLog, 0, '00DF', 'CADASTRO', VL_Linha, 'parametro informado na Tag:0082 esta vazia ou zerada', '', VL_Erro);
                Exit;
            end;
            StrToRxMemData(VL_Tag, VL_Tabela);
            VL_Tabela.Open;

            VP_Mensagem.GetTag('006F', VL_ID); //adquirente_id

            if VL_ID < 1 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00DF', 'R');
                VL_Mensagem.AddTag('004D', '47');//dados informado não pode ser zero
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '300520221029';
                GravaLog(F_ArquivoLog, 0, '00DF', 'cadastro', VL_Linha, 'alteração não executada, o id informado da adquirente não pode ser zero',
                    '', VL_Erro);
                Exit;
            end;
            //verifica se existe o registro para alterar
            VL_TAdquirente.Close;
            VL_TAdquirente.SQL.Text := 'SELECT * FROM ADQUIRENTE WHERE ID=' + IntToStr(VL_ID);
            VL_Erro := 55;
            VL_Linha := '300520221030';
            VL_TAdquirente.Open;

            if VL_TAdquirente.RecordCount = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00DF', 'R');
                VL_Mensagem.AddTag('004D', '48'); //registro não localizado
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 48;
                VL_Linha := '300520221031';
                GravaLog(F_ArquivoLog, 0, '00DF', 'cadastro', VL_Linha, 'o registro numero:' + IntToStr(VL_ID) +
                    ' informado não foi encontrado na tabela adquirente',
                    '', VL_Erro);
                Exit;
            end;

            if VL_Tabela.Locate('ID', VL_ID, []) then
            begin
                if ((VL_Tabela.FieldByName('ID').AsInteger <> VL_TAdquirente.FieldByName('ID').AsInteger) or
                    (VL_Tabela.FieldByName('DESCRICAO').AsString <> VL_TAdquirente.FieldByName('DESCRICAO').AsString)) then
                begin
                    VL_Mensagem.Limpar;
                    VL_Mensagem.AddComando('00DF', 'R');
                    VL_Mensagem.AddTag('004D', '49'); //dados chaves não podem sofer alteração
                    DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                    VL_Erro := 49;
                    VL_Linha := '300520221032';
                    GravaLog(F_ArquivoLog, 0, '00DF', 'cadastro', VL_Linha,
                        'dados chaves não podem sofer alteração(id/descrição) na tabela adquirente não pode alterar',
                        '', VL_Erro);
                    Exit;
                end;
                VL_TAdquirente.Close;
                VL_TAdquirente.SQL.Text := 'UPDATE ADQUIRENTE SET ' +
                    'DESCRICAO=''' + VL_Tabela.FieldByName('DESCRICAO').AsString + ''',' +
                    'CONTATO=''' + VL_Tabela.FieldByName('CONTATO').AsString + '''' +
                    ' WHERE ' +
                    'ID=' + IntToStr(VL_ID);
                VL_Erro := 46;
                VL_Linha := '300520221033';
                VL_TAdquirente.ExecSQL;

                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00DF', 'R');//alteração aceita
                VL_Mensagem.AddTag('004D', '0');
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
            end
            else
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00DF', 'R');
                VL_Mensagem.AddTag('004D', '46');
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
            end;
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '00DF', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '00DF', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_Tabela.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '00DF', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

function comando00E0(VP_Transmissao_ID: string; VP_Mensagem: TMensagem; VP_AContext: TIdContext): integer;     //cadastro ADQUIRENTE EXCLUIR
var
    VL_Mensagem: TMensagem;
    VL_TAdquirente: TZQuery;
    VL_ID: int64;
    VL_Erro: integer;
    VL_Linha: string;
begin
    Result := 0;
    VL_Mensagem := TMensagem.Create;
    VL_TAdquirente := TZQuery.Create(DComunicador);
    VL_TAdquirente.Connection := DNucleo.ZConexao;
    VL_ID := 0;
    VL_Erro := 0;
    VL_Linha := '';
    try
        try
            //verifica parametros
            VP_Mensagem.GetTag('006F', VL_ID); //adquirente_id
            if VL_ID = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00E0', 'R');
                VL_Mensagem.Addtag('004D', '47');//campo não pode ser zero
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 47;
                VL_Linha := '300520221042';
                GravaLog(F_ArquivoLog, 0, '00E0', 'cadastro', VL_Linha, 'campo id para exclusão na tabela adquirente não pode ser zero', '', VL_Erro);
                Exit;
            end;
            //verifica permissao
            if (TTConexao(VP_AContext.Data).Permissao <> pmC) then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00E0', 'R');
                VL_Mensagem.Addtag('004D', '45');//sem permissao
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 45;
                VL_Linha := '300520221043';
                GravaLog(F_ArquivoLog, 0, '00E0', 'cadastro', VL_Linha, 'sem permissão para gerenciar exclusão na tabela adquirente', '', VL_Erro);
                Exit;
            end;
            //verifica se existe o id pra exclusão
            VL_TAdquirente.Close;
            VL_TAdquirente.SQL.Text := 'SELECT * FROM ADQUIRENTE WHERE ID=' + IntToStr(VL_ID);
            VL_Erro := 55;
            VL_Linha := '300520221044';
            VL_TAdquirente.Open;

            if VL_TAdquirente.RecordCount = 0 then
            begin
                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00E0', 'R');
                VL_Mensagem.Addtag('004D', '48');// id não encontrado na tabela
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
                VL_Erro := 48;
                VL_Linha := '300520221045';
                GravaLog(F_ArquivoLog, 0, '00E0', 'cadastro', VL_Linha, 'campo informado ID numero:' + IntToStr(VL_ID) +
                    ' para exclusão não foi localizado na tabela adquirente', '', VL_Erro);
            end
            else
            begin
                //exclui adquirente
                VL_TAdquirente.Close;
                VL_TAdquirente.SQL.Text := 'DELETE FROM ADQUIRENTE WHERE ' + 'ID=' + IntToStr(VL_ID);
                VL_Erro := 46;
                VL_Linha := '300520221046';
                VL_TAdquirente.ExecSQL;

                VL_Mensagem.Limpar;
                VL_Mensagem.AddComando('00E0', 'R');
                VL_Mensagem.AddTag('004D', '0');
                VL_Mensagem.AddTag('006F', VL_ID); //retorno tag_id
                DComunicador.ServidorTransmiteSolicitacao(C_TempoAguarda, False, nil, VP_Transmissao_ID, VL_Mensagem, VP_Mensagem, VP_AContext);
            end;
        except
            on E: Exception do
            begin
                try
                    if Assigned(DNucleo) then
                    begin
                        if DNucleo.ZConexao.Connected then
                            if DNucleo.ZConexao.InTransaction then
                                DNucleo.ZConexao.Rollback;
                    end;
                except
                    on E: Exception do
                        GravaLog(F_ArquivoLog, 0, '00E0', 'cadastro', VL_Linha, '', '', VL_Erro);
                end;
                GravaLog(F_ArquivoLog, 0, '00E0', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    finally
        begin
            VL_Mensagem.Free;
            VL_TAdquirente.Free;
            try
                if Assigned(DNucleo) then
                begin
                    if DNucleo.ZConexao.Connected then
                        if DNucleo.ZConexao.InTransaction then
                            DNucleo.ZConexao.Commit;
                end;
            except
                on E: Exception do
                    GravaLog(F_ArquivoLog, 0, '00E0', 'cadastro', VL_Linha, '', '', VL_Erro);
            end;
        end;
    end;
end;

end.
