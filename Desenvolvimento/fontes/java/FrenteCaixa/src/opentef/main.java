package opentef;

import java.awt.GridBagLayout;
import java.nio.charset.StandardCharsets;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextField;

/* 
import com.sun.jna.Library;
import com.sun.jna.Native;
import com.sun.jna.Callback;
import com.sun.jna.Pointer;
import com.sun.jna.Memory;
import com.sun.jna.WString;
import com.sun.jna.ptr.*;
*/

public class main {

	/* 
	public static class RetornoClienteImpl implements TefLib.RetornoCliente {

		@Override
		public int callbackRetornoCliente(String dadosEntrada, String dadosSaida) {
			// TODO Auto-generated method stub
			return 0;
		}
	}

	public static class SolicitaDadosPDVImpl implements TefLib.SolicitaDadosPDV {

		@Override
		public int callbackSolicitaDadosPDV(String menu, String botao, String dadosSaida) {
			// TODO Auto-generated method stub
			return 0;
		}

	}

	public static class SolicitaDadosTransacaoImpl implements TefLib.SolicitaDadosTransacao {

		@Override
		public int callbackSolicitaDadosTransacao(String dadosEntrada, String dadosSaida) {
			// TODO Auto-generated method stub
			return 0;
		}

	}

	public static class ImprimirImpl implements TefLib.Imprimir {

		@Override
		public int callbackImprimir(String mensagem) {
			// TODO Auto-generated method stub
			return 0;
		}

	}

	public static class MostraMenuImpl implements TefLib.MostraMenu {

		@Override
		public int callbackMostraMenu(String dados, String botaoSelecionado) {
			// TODO Auto-generated method stub
			return 0;
		}

	}

	public static class MensagemOperadorImple implements TefLib.MensagemOperador {

		@Override
		public int callbackMensagemOperador(String mensagem) {
			// TODO Auto-generated method stub
			return 0;
		}

	}
	*/

	/* 
	private static TefLib teflib;
	private static RetornoClienteImpl retornoClienteImpl;
	private static SolicitaDadosPDVImpl solicitaDadosPDVImpl;
	private static SolicitaDadosTransacaoImpl solicitaDadosTransacaoImpl;
	private static ImprimirImpl imprimirImpl;
	private static MostraMenuImpl mostraMenuImpl;
	private static MensagemOperadorImple mensagemOperadorImple;
	*/

	public static void main(String[] args) {

		//teflib = TefLib.INSTANCE;

		JFrame miJFrame = new JFrame("Frente de caixa");
		miJFrame.setSize(500, 300);

		JPanel miJPanel = new JPanel();
		miJPanel.setSize(300, 300);

		miJPanel.setLayout(new GridBagLayout());

		JLabel lblHost = new JLabel();
		lblHost.setText("Host");
		lblHost.setBounds(10, 60, 100, 30);

		JTextField edtHost = new JTextField();
		edtHost.setText("127.0.0.1");
		edtHost.setBounds(10, 100, 100, 30);

		JLabel lblPorta = new JLabel();
		lblPorta.setText("Porta");
		lblPorta.setBounds(10, 60, 100, 30);

		JTextField edtPorta = new JTextField();
		edtPorta.setText("1000");
		edtPorta.setBounds(10, 100, 100, 30);

		JLabel lblID = new JLabel();
		lblID.setText("ID");
		lblID.setBounds(10, 60, 100, 30);

		JTextField edtID = new JTextField();
		edtID.setText("22");
		edtID.setBounds(10, 100, 100, 30);

		JLabel lblChave = new JLabel();
		lblChave.setText("Chave");
		lblChave.setBounds(10, 60, 100, 30);

		JTextField edtChave = new JTextField();
		edtChave.setText("29565");
		edtChave.setBounds(10, 100, 100, 30);

		JLabel lblIdentificador = new JLabel();
		lblIdentificador.setText("Identificador");
		lblIdentificador.setBounds(10, 60, 100, 30);

		JTextField edtIdentificador = new JTextField();
		edtIdentificador.setText("12316");
		edtIdentificador.setBounds(10, 100, 100, 30);

		JButton btnTeste = new JButton();
		btnTeste.setText("Teste");
		btnTeste.addActionListener(e -> {
			int erro = 0;
			try {
				String comando = "";
				String comandoDados = "";
				String tag = "";
				String tagDados = "";				
				
				/* 
				PointerByReference pointerByReference = new PointerByReference();
				erro = teflib.mensagemcreate(pointerByReference);
				
				Pointer mensagem = pointerByReference.getValue();
				erro = teflib.mensagemaddcomando(mensagem, "0001", "S");
				erro = teflib.mensagemaddtag(mensagem, "0004", "ABC");
				
				erro = teflib.mensagemcomando(mensagem, pointerByReference);
				
				comando = pointerByReference.getValue().getString(0);
				
				erro = teflib.mensagemcomandodados(mensagem, pointerByReference);
				
				comandoDados = pointerByReference.getValue().getString(0);
				
				erro = teflib.mensagemgettag(mensagem, "0004", pointerByReference);
				
				tagDados = pointerByReference.getValue().getString(0);
						
				lblIdentificador.setText(comando);
				lblChave.setText(comandoDados);
				
				teflib.mensagemfree(mensagem);
				*/
			} catch (Throwable ee) {
				lblIdentificador.setText(ee.getMessage());
			}

		});

		JButton btnInicializar = new JButton();
		btnInicializar.setText("Inicializar");
		btnInicializar.setBounds(10, 10, 100, 50);
		btnInicializar.addActionListener(e -> {
			/* 
			retornoClienteImpl = new RetornoClienteImpl();
			solicitaDadosPDVImpl = new SolicitaDadosPDVImpl();
			solicitaDadosTransacaoImpl = new SolicitaDadosTransacaoImpl();
			imprimirImpl = new ImprimirImpl();
			mostraMenuImpl = new MostraMenuImpl();
			mensagemOperadorImple = new MensagemOperadorImple();

			int erro = teflib.inicializar(0, "", "", "",
					"E:\\Lazarus\\OpenTef\\publica\\fontes\\java\\FrenteCaixa\\tef.log", retornoClienteImpl,
					solicitaDadosTransacaoImpl, solicitaDadosPDVImpl, imprimirImpl, mostraMenuImpl,
					mensagemOperadorImple, 0);
			if (erro != 0) {
				String erroDescricao = "";
				teflib.mensagemerro(erro, erroDescricao);
				JOptionPane.showMessageDialog(null, erroDescricao);
			}

			*/
		});

		JButton btnLogin = new JButton();
		btnLogin.setText("Login");
		btnLogin.setBounds(10, 150, 100, 50);
		btnLogin.addActionListener(e -> {
			String host = edtHost.getText();
			int porta = Integer.parseInt(edtPorta.getText());
			int id = Integer.parseInt(edtID.getText());
			String chave = edtChave.getText();
			String identificador = edtIdentificador.getText();

			/*
			int erro = teflib.login(host, porta, id, chave, 1, identificador);
			if (erro != 0) {
				String erroDescricao = "";
				teflib.mensagemerro(erro, erroDescricao);
				JOptionPane.showMessageDialog(null, erroDescricao);
			}
			*/
		});

		miJPanel.add(btnInicializar);
		miJPanel.add(lblHost);
		miJPanel.add(edtHost);
		miJPanel.add(lblPorta);
		miJPanel.add(edtPorta);
		miJPanel.add(lblID);
		miJPanel.add(edtID);
		miJPanel.add(lblChave);
		miJPanel.add(edtChave);
		miJPanel.add(lblIdentificador);
		miJPanel.add(edtIdentificador);
		miJPanel.add(btnLogin);
		miJPanel.add(btnTeste);

		miJFrame.add(miJPanel);

		miJFrame.setVisible(true);
	}
}