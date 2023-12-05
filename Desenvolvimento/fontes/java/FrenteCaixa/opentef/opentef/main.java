package opentef;


import java.awt.GridBagLayout;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextField;

import com.sun.jna.Library;
import com.sun.jna.Native;
import com.sun.jna.Callback;
import com.sun.jna.Pointer;
import com.sun.jna.Memory;
import com.sun.jna.WString;
import com.sun.jna.ptr.*;

public class main {


	public static class RetornoClienteImpl implements TefLib.RetornoCliente {

		@Override
		public int callbackRetornoCliente(String dadosEntrada, String dadosSaida) {
			/*
			int erro = 0;
			String comando = "";
			String comandoDados = "";
			
			Pointer mensagem = new Pointer(4);
			teflib.mensagemcreate(mensagem);
			erro = teflib.mensagemcarregatags(mensagem, dadosEntrada);
			
			if(erro != 0) {
				JOptionPane.showMessageDialog(null,"Erro ao carregar tag");
				return erro;
			}
			
			/*
			teflib.mensagemcomando(mensagem, comando);
			teflib.mensagemcomandodados(mensagem, comandoDados);
			
			if(comando.equals("0026")) {
				if(comandoDados.equals("96")) {
					JOptionPane.showMessageDialog(null,"Servidor desconcetado");
				}
				
				JOptionPane.showMessageDialog(null,"erro");
			}
			*/
			
			//teflib.mensagemfree(mensagem);
			
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
	   
    public static class SolicitaDadosTransacaoImpl implements TefLib.SolicitaDadosTransacao{

		@Override
		public int callbackSolicitaDadosTransacao(String dadosEntrada, String dadosSaida) {
			// TODO Auto-generated method stub
			return 0;
		}
    	
    }
    
    public static class ImprimirImpl implements TefLib.Imprimir{

		@Override
		public int callbackImprimir(String mensagem) {
			// TODO Auto-generated method stub
			return 0;
		}
    	
    }
    
    public static class MostraMenuImpl implements TefLib.MostraMenu{

		@Override
		public int callbackMostraMenu(String dados, String botaoSelecionado) {
			// TODO Auto-generated method stub
			return 0;
		}
    	
    }
    
    public static class MensagemOperadorImple implements TefLib.MensagemOperador{

		@Override
		public int callbackMensagemOperador(String mensagem) {
			// TODO Auto-generated method stub
			return 0;
		}
    	
    }
	
	private static TefLib teflib;
	private static RetornoClienteImpl retornoClienteImpl;
	private static SolicitaDadosPDVImpl solicitaDadosPDVImpl;
	private static SolicitaDadosTransacaoImpl solicitaDadosTransacaoImpl;
	private static ImprimirImpl imprimirImpl;
	private static MostraMenuImpl mostraMenuImpl;
	private static MensagemOperadorImple mensagemOperadorImple;
	
    public static void main(String[] args){
        // componente JFrame
        JFrame miJFrame = new JFrame("Frente de caixa");
        miJFrame.setSize(500,300); 

        // componente JPanel
        JPanel miJPanel = new JPanel();
        miJPanel.setSize(300, 300);

        // usamos este diseño para centrar los componentes de JPanel
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
        	try
        	{
        	
        	String comando = "";
        	Pointer mensagem = new Memory(42);
        	teflib.mensagemcreate(mensagem);
			teflib.mensagemfree(mensagem);
			//erro = teflib.mensagemaddcomando(mensagem, "0001", "0012");
			//erro = teflib.mensagemcomando(mensagem, comando);
			lblIdentificador.setText(comando);
        	}
        	catch (Throwable ee) {
				// TODO: handle exception
        		lblIdentificador.setText(ee.getMessage());
			}
        	
        });
        	

        JButton btnInicializar = new JButton();
        btnInicializar.setText("Inicializar");
        btnInicializar.setBounds(10, 10, 100,50);
        btnInicializar.addActionListener(e ->
        {
        	teflib = TefLib.INSTANCE;
			retornoClienteImpl = new RetornoClienteImpl();
			solicitaDadosPDVImpl = new SolicitaDadosPDVImpl();
			solicitaDadosTransacaoImpl = new SolicitaDadosTransacaoImpl();
			imprimirImpl = new ImprimirImpl();
			mostraMenuImpl = new MostraMenuImpl();
			mensagemOperadorImple = new MensagemOperadorImple();
			
			int erro = teflib.inicializar(0, "", "", "", "", retornoClienteImpl, solicitaDadosTransacaoImpl, solicitaDadosPDVImpl, imprimirImpl, mostraMenuImpl, mensagemOperadorImple, 0);
			if(erro != 0) {
				String erroDescricao = "";
				teflib.mensagemerro(erro, erroDescricao);
				JOptionPane.showMessageDialog(null,erroDescricao);
			}
        });
        
        JButton btnLogin = new JButton();
        btnLogin.setText("Login");
        btnLogin.setBounds(10, 150, 100, 50);
        btnLogin.addActionListener(e ->
        {
        	String host = edtHost.getText();
        	int porta = Integer.parseInt(edtPorta.getText());
        	int id = Integer.parseInt(edtID.getText());
        	String chave = edtChave.getText();
        	String identificador = edtIdentificador.getText();
        	
        	int erro = teflib.login(host, porta, id,chave, 1, identificador);
        	if(erro != 0) {
				String erroDescricao = "";
				teflib.mensagemerro(erro, erroDescricao);
				JOptionPane.showMessageDialog(null,erroDescricao);
			}
        });
        
        // conecta los componentes JLabel y JTextField en JPanel
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
        

        // conectar Jpanel a JFrame
        miJFrame.add(miJPanel);

        // hacer visible JFrame
        miJFrame.setVisible(true);
    }
}