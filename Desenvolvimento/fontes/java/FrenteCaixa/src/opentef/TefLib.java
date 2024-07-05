/* 

package opentef;

import com.sun.jna.Library;
import com.sun.jna.Native;
import com.sun.jna.Callback;
import com.sun.jna.Pointer;
import com.sun.jna.ptr.PointerByReference;

public interface TefLib extends Library {
		TefLib INSTANCE = Native.load("E:\\Lazarus\\OpenTef\\publica\\binarios\\tef_lib\\win64\\tef_lib.dll", TefLib.class);
	
	   interface RetornoCliente extends com.sun.jna.Callback {
	   	int callbackRetornoCliente(String dadosEntrada, String dadosSaida);
	   }
	   
	   interface SolicitaDadosPDV extends com.sun.jna.Callback {
		   	int callbackSolicitaDadosPDV(String menu, String botao, String dadosSaida);
	   }
	   
	   interface SolicitaDadosTransacao extends com.sun.jna.Callback {
		   	int callbackSolicitaDadosTransacao(String dadosEntrada, String dadosSaida);
	   }
	   
	   interface Imprimir extends com.sun.jna.Callback {
		   	int callbackImprimir(String mensagem);
	   }
	   
	   interface MostraMenu extends com.sun.jna.Callback {
		   	int callbackMostraMenu(String dados, String botaoSelecionado);
	   }
	   
	   interface MensagemOperador extends com.sun.jna.Callback {
		   	int callbackMensagemOperador(String mensagem);
	   }
	   
	   interface RetornoSolicitacao extends com.sun.jna.Callback {
		   	int callbackRetornoSolicitacao(String transmissao_ID, int procID, int erro, String dados);
	   }

	   
	   int inicializar(int pinPadModelo, String pinPadModeloLib, String pinPadModeloPorta, String VP_PinPadLib, String arquivoLog,
			   RetornoCliente retornoCliente,SolicitaDadosTransacao solicitaDadosTransacao,SolicitaDadosPDV solicitaDadosPDV,
			   Imprimir imprimir, MostraMenu mostraMenu,MensagemOperador mensagemOperador,int ambienteTeste);	   
	   int finalizar();
	   int login(String host, int porta, int id, String chave, int versaoComunicao, String identificador);
	   int solicitacao(String transmissao_id, String dados,RetornoSolicitacao retornoSolicitacao, int tempoAguarda);
	   int solicitacaoblocante(String transmissao_id, String dadosEnviados, String dadosRecebidos, int tempoAguarda);
	   int opentefstatus(int status);
	   
	   int transacaocreate(String comando, String identificadorCaixa, String transacaoID, int tempoAguarda);
	   int transacaostatus(int status, String transacaoChave, String transacaoID);
	   int transacaostatusdescricao(String status, String transacaoID);
	   int transacaogettag(String transacao_id, String tag, String dados);
	   int transacaocancela(int resposta, String transacaoChave, String transacaoID);
	   void transacaofree(int transacao_id);
	   
	   void alterarnivellog(int nivel);
	   int versao(String dados);
	   
	   int mensagemcreate(PointerByReference ponteiro);
	   int mensagemcreate_id();
	   int mensagemcarregatags(Pointer ponteiro, String dados);
	   int mensagemcomando(Pointer ponteiro, PointerByReference dados);
	   int mensagemcomandodados(Pointer ponteiro,PointerByReference dados);
	   void mensagemfree(Pointer ponteiro);
	   int mensagemaddtag(Pointer ponteiro, String tag, String dados);
	   int mensagemaddcomando(Pointer ponteiro, String tag, String dados);
	   int mensagemaddtagposicao(Pointer ponteiro,int posicao, String tag, String dados);
	   int mensagemtagasstring(Pointer ponteiro,String dados);
	   int mensagemtagcount(Pointer ponteiro);
	   int mensagemgettag(Pointer ponteiro, String tag, PointerByReference dados);
	   int mensagemgettagposicao(Pointer ponteiro, int posicao, String tag, String dados);	
	   int mensagemgettagidx(Pointer ponteiro,int indice, String tag, String dados); 
	   int mensagemtagtostr(Pointer ponteiro, String dados);
	   void mensagemlimpar(Pointer ponteiro);
	   int mensagemerro(int codigo, String mensagem);
}

*/