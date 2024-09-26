package opentef;

import java.io.UnsupportedEncodingException;



import com.sun.jna.*;
import com.sun.jna.Pointer;
import com.sun.jna.ptr.PointerByReference;
import com.sun.jna.ptr.IntByReference;


    




public interface TefLib extends Library {
	
	   public enum OpenTefConexao{csNaoInicializado, csDesconectado, csLink, csChaveado, csChaveadoAssinado, csLogado};
	   public enum OpenTefTransacaoStatus{tsEfetivada, tsNegada, tsCancelada, tsProcessando,tsAguardandoComando, tsNaoLocalizada, tsInicializada,
			    						tsComErro, tsAbortada, tsAguardandoDadosPDV};	   
		
		   
	   interface Retorno extends com.sun.jna.Callback {
	   	int callbackRetorno(String dadosEntrada, PointerByReference dadosSaida);
	   }
	   
	   interface SolicitaDadosPDV extends com.sun.jna.Callback {
		   	int callbackSolicitaDadosPDV(String VP_Mensagem, PointerByReference botao, PointerByReference dadosSaida);
	   }
	   
	   interface SolicitaDadosTransacao extends com.sun.jna.Callback {
		   	int callbackSolicitaDadosTransacao(String dadosEntrada, PointerByReference dadosSaida);
	   }
	   
	   interface Imprimir extends com.sun.jna.Callback {
		   	int callbackImprimir(String mensagem);
	   }
	   
	   interface MostraMenu extends com.sun.jna.Callback {
		   	int callbackMostraMenu(String dados, PointerByReference botaoSelecionado);
	   }
	   
	   interface MensagemOperador extends com.sun.jna.Callback {
		   	int callbackMensagemOperador(String mensagem);
	   }
	   
	   interface RetornoSolicitacao extends com.sun.jna.Callback {
		   	int callbackRetornoSolicitacao(PointerByReference VP_CLassePai, String transmissao_ID, int procID, int erro, String dados);
	   }
	   
	   interface StrDispose extends com.sun.jna.Callback {
		   	void callbackStrDispose(Pointer dados);
	   }
	   

	   
	   int inicializar(PointerByReference tef, int pinPadModelo, String pinPadModeloLib, String pinPadModeloPorta, String VP_PinPadLib, String arquivoLog,
			   StrDispose strdispose, Retorno retorno,SolicitaDadosTransacao solicitaDadosTransacao,SolicitaDadosPDV solicitaDadosPDV,
			   Imprimir imprimir, MostraMenu mostraMenu,MensagemOperador mensagemOperador,int ambienteTeste);
	   
	  
	   
	 
	   int finalizar(Pointer VP_Tef);
	   int login(Pointer VP_Tef,String VP_Host,int VP_Porta,int VP_ID,String VP_ChaveComunicacao,int VP_Versao_Comunicacao,String VP_Identificador);
	   int desconectar(Pointer VP_Tef);
	   int solicitacao(Pointer VP_Tef, String VP_Transmissao_ID, String VP_Dados,RetornoSolicitacao VP_Procedimento,int VP_TempoAguarda);
	   int solicitacaoblocante(Pointer VP_Tef, PointerByReference VO_Transmissao_ID, PointerByReference VP_Dados,PointerByReference VO_Retorno, int VP_TempoAguarda);
	   int opentefstatus(Pointer VP_Tef, IntByReference VO_StatusRetorno);
	   int transacaocreate(Pointer VP_Tef,String VP_Comando, String VP_IdentificadorCaixa, PointerByReference VO_TransacaoID, int VP_TempoAguarda);
	   int transacaostatus(Pointer VP_Tef, IntByReference VO_Status, PointerByReference VO_TransacaoChave, String VP_TransacaoID);
	   int transacaostatusdescricao(Pointer VP_Tef, PointerByReference VO_Status,String VP_TransacaoID);
	   int transacaogettag(Pointer VP_Tef, String VP_TransacaoID, String VP_Tag, PointerByReference VO_Dados);
	   int transacaocancela(IntByReference VO_Resposta, String VP_TransacaoChave, String VP_TransacaoID);
	   void transacaofree(Pointer VP_Tef, String VP_TransacaoID); 
	   void alterarnivellog(int VP_Nivel);

	   int versao(PointerByReference dados);
	   
	   int mensagemcreate(PointerByReference VO_Mensagem);
	   int mensagemcreate_id(IntByReference VO_ID);
	   int mensagemcarregatags(Pointer ponteiro, String dados);
	   int mensagemcomando(Pointer ponteiro, PointerByReference dados);
	   int mensagemcomandodados(Pointer ponteiro,PointerByReference dados);
	   void mensagemfree(Pointer ponteiro);
	   int mensagemaddtag(Pointer ponteiro, String tag, String dados);
	   int mensagemaddcomando(Pointer ponteiro, String tag, String dados);
	   int mensagemaddtagposicao(Pointer ponteiro,int posicao, String tag, String dados);
	   int mensagemtagasstring(Pointer ponteiro,PointerByReference dados);
	   int mensagemtagcount(Pointer ponteiro);
	   int mensagemgettag(Pointer ponteiro, String tag, PointerByReference dados);
	   int mensagemgettagposicao(Pointer ponteiro, int posicao, String tag, PointerByReference dados);	
	   int mensagemgettagidx(Pointer ponteiro,int indice, PointerByReference tag, PointerByReference dados); 
	   int mensagemtagtostr(Pointer ponteiro, PointerByReference dados);
	   void mensagemlimpar(Pointer ponteiro);
	   void mensagemdispose(Pointer dados);
	   int mensagemerro(int codigo, PointerByReference mensagem);
	   
	   
	   default String corrigirAcentos(String dados) {
		   
			byte[] bytes;
			try {
				bytes = dados.getBytes("windows-1252");
			} catch (UnsupportedEncodingException e) {
				// TODO Auto-generated catch block
				return "";
			}

			// Converter os bytes para uma string 
			String string = new String(bytes);

			return string;
			}
	   
	   default int j_mensagemerro(int erro, String[] mensagem) {
		   
			PointerByReference pointerByReference = new PointerByReference();
			int i;
			i=mensagemerro(erro, pointerByReference);
			mensagem[0]=corrigirAcentos(pointerByReference.getValue().getString(0));
		    mensagemdispose(pointerByReference.getValue());
 		    return i;
	   }
	   
	   default int j_transacaocreate(Pointer VP_Tef,String VP_Comando, String VP_IdentificadorCaixa, String[] VO_TransacaoID, int VP_TempoAguarda) {
		   
			PointerByReference pointerByReference = new PointerByReference();
			int i;
			i=transacaocreate(VP_Tef,VP_Comando,VP_IdentificadorCaixa,pointerByReference,VP_TempoAguarda);
			VO_TransacaoID[0]=pointerByReference.getValue().getString(0);
			mensagemdispose(pointerByReference.getValue());			
		    return i;		   

		   
	   }
  
	   
}


