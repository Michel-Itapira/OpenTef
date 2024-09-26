package opentef;

import java.awt.EventQueue;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JPasswordField;
import javax.swing.border.EmptyBorder;
import javax.swing.JTabbedPane;
import javax.swing.JScrollPane;
import javax.swing.JButton;
import java.awt.BorderLayout;
import java.awt.event.ActionListener;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.awt.event.ActionEvent;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JTextField;
import javax.swing.JSpinner;
import javax.swing.SpinnerNumberModel;
import javax.swing.border.TitledBorder;
import javax.swing.event.DocumentEvent;
import javax.swing.event.DocumentListener;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.util.Base64;
import javax.imageio.ImageIO;
import java.io.IOException;
import java.lang.classfile.ClassFile;
import java.io.File;
import java.net.URISyntaxException;

import com.sun.jna.Native;
import com.sun.jna.Pointer;
import com.sun.jna.ptr.PointerByReference;
import javax.swing.ImageIcon;

import opentef.TefLib.OpenTefConexao;
import opentef.TefLib.OpenTefTransacaoStatus;

import javax.swing.JTextArea;
import javax.swing.SwingConstants;
import javax.swing.border.EtchedBorder;
import java.awt.Color;
import javax.swing.JComboBox;
import javax.swing.JComponent;
import javax.swing.JDialog;
import javax.swing.Box;
import javax.swing.BoxLayout;
import javax.swing.DefaultComboBoxModel;
import com.sun.jna.ptr.IntByReference;
import java.awt.Font;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import javax.swing.JSeparator;

import com.sun.jna.*;

public class FInterface extends JFrame {

	private static final long serialVersionUID = 1L;
	private static String caminho = null;
	private static JPanel panelPrincipal;
	private JTextField textHost;
	private JTextField textTefLib;
	private JTextField textPinPadLib;
	private JTextField textPinPadLibHashMd5;
	private JTextField textPinPadModeloLib;
	private JTextField textPinPadModeloLibHashMd5;
	private JTextField textPinPadModeloPorta;
	private JTextField textTempo;

	static JLabel lblConexao = new JLabel("Desconectado");
	static JTextArea textEventos = new JTextArea();
	static JTextField textVendaCaixa;
	static JTextField textVendaData;
	static JTextField textVendaNsu;
	static JTextField textVendaDesconto;
	static JTextField textVendaObs;
	static JTextField textVendaValorParcela;
	static JTextField textVendaParcela;
	static JTextField textVendaValorTotal;
	static JTextField textVendaOperador;
	static JTextField textVendaAlimentacao;
	static JTextField textVendaRefeicao;
	static JTextField textVendaCultura;
	static JTextField textVendaCupom;
	static JTextArea textVendaXml;
	static JTextField textVendaLink;
	static JTextArea textChave;

	private static TefLib teflib;
	private static PointerByReference tef;
	private static Pointer pointTef;
	private static RetornoImpl retornoImpl;
	private static SolicitaDadosPDVImpl solicitaDadosPDVImpl;
	private static SolicitaDadosTransacaoImpl solicitaDadosTransacaoImpl;
	private static ImprimirImpl imprimirImpl;
	private static MostraMenuImpl mostraMenuImpl;
	private static StrDisposeImpl strDisposeImpl;
	private static MensagemOperadorImple mensagemOperadorImple;
	private JTextField textLog;
	private JTextField textNivelLog;

	public static class JButtonOpeTef extends JButton {

		public JButtonOpeTef(String label, String Tag) {
			tag = Tag;
			setText(label);
		}

		private static final long serialVersionUID = 1L;

		public String tag;

	}

	public static class JMenuOpenTef extends JDialog {
		/**
		 * 
		 */
		private static final long serialVersionUID = 1L;
		public String BotaoSelecionado;
		public String[] DadosCapturados = { "" };

		public JMenuOpenTef(JFrame parent) {

			super(parent, "Menu OpenTef", true);

			setLayout(new BoxLayout(getContentPane(), BoxLayout.Y_AXIS));

		}

		public JPanel createCenteredPanel(JButton button) {
			JPanel panel = new JPanel();
			panel.setLayout(new BoxLayout(panel, BoxLayout.X_AXIS));
			panel.add(Box.createHorizontalGlue());
			panel.add(button);
			panel.add(Box.createHorizontalGlue());
			return panel;
		}

		public JPanel createCenteredPanelI(JLabel imagem) {
			JPanel panel = new JPanel();
			panel.setLayout(new BoxLayout(panel, BoxLayout.X_AXIS));
			panel.add(Box.createHorizontalGlue());
			panel.add(imagem);
			panel.add(Box.createHorizontalGlue());
			return panel;
		}

	}

	public static class RetornoImpl implements TefLib.Retorno {

		@Override
		public int callbackRetorno(String dadosEntrada, PointerByReference dadosSaida) {

			PointerByReference VL_Retorno = new PointerByReference();

			String VL_Dados = "";
			String VL_Comando = "";
			String VL_ComandoDados = "";
			Pointer VL_Mensagem = null;
			String[] VL_String = new String[1];

			int VL_Erro = 0;
			String VL_DescricaoErro = "";
			String VL_TransacaoID = "";
			String VL_DescricaoErroTransacao = "";
			String VL_TransacaoChave = "";
			String VL_Bin = "";
			int VL_TransacaoStatus = 0;

			String hora = new SimpleDateFormat("HH:mm:ss").format(new Date());

			try {

				VL_Erro = teflib.mensagemcreate(VL_Retorno);
				VL_Mensagem = VL_Retorno.getValue();
				VL_Erro = teflib.mensagemcarregatags(VL_Mensagem, dadosEntrada);
				if (VL_Erro != 0) {
					// retorno com erro
					teflib.mensagemaddcomando(VL_Mensagem, "0026", Integer.toString(VL_Erro));
					teflib.mensagemtagasstring(VL_Mensagem, VL_Retorno);
					VL_String[0] = VL_Retorno.getValue().getString(0);
					teflib.mensagemdispose(VL_Retorno.getValue());

					dadosSaida.setValue(new Memory(VL_String[0].length() + 1));
					dadosSaida.getValue().setString(0, VL_String[0]);

					return 0;

				}

				teflib.mensagemcomando(VL_Mensagem, VL_Retorno);

				VL_Comando = VL_Retorno.getValue().getString(0);
				teflib.mensagemdispose(VL_Retorno.getValue());

				teflib.mensagemcomandodados(VL_Mensagem, VL_Retorno);

				VL_ComandoDados = VL_Retorno.getValue().getString(0);
				teflib.mensagemdispose(VL_Retorno.getValue());

				if (VL_Comando.equals("0026")) // retorno com erro
				{
					if (VL_ComandoDados.equals("96")) // desconectado
					{
						lblConexao.setText("Desconectado");
						lblConexao.setForeground(new Color(255, 0, 0));
					}

					teflib.j_mensagemerro(Integer.valueOf(VL_ComandoDados), VL_String);

					VL_DescricaoErro = VL_Retorno.getValue().getString(0);
					teflib.mensagemdispose(VL_Retorno.getValue());
					JOptionPane.showMessageDialog(null,
							"Erro: " + VL_ComandoDados + "\n" + "Descrição: " + VL_DescricaoErro, "OpenTef",
							JOptionPane.ERROR_MESSAGE);
					return 0;

				}

				if (VL_Comando.equals("0018")) // Veio pedido de mostrar menu de venda
				{
					// monta o menu e aguarda a escolha pelo operador
					int i;
					i = mostraMenuImpl.callbackMostraMenu(dadosEntrada, dadosSaida);
					return i;

				}

				if (VL_Comando.equals("010C")) // solicitacao de atualizacao da lib do tef,
				// ATENÇÃO APÓS BAIXAR O ARQUIVO O FRENTE DE CAIXA FICA RESPONSAVEL POR
				// SUBSTITUIR A BIBLIOTECA PELA QUE FOI BAIXADA NO DIRETÓRIO/PASTA INDICADOS
				{

					teflib.mensagemgettag(VL_Mensagem, "00FD", VL_Retorno); // atualizacao obrigatoria

					VL_Dados = VL_Retorno.getValue().getString(0);
					teflib.mensagemdispose(VL_Retorno.getValue());

					if (VL_Dados.equals("S"))

						teflib.mensagemaddcomando(VL_Mensagem, "010C", "c:\\temp\\"); // informe o caminho onde vai ser
																						// baixado a lib
					// comando de retorno com o caminho sem o nome do arquivo

					teflib.mensagemtagasstring(VL_Mensagem, VL_Retorno);

					VL_String[0] = VL_Retorno.getValue().getString(0);
					teflib.mensagemdispose(VL_Retorno.getValue());

					dadosSaida.setValue(new Memory(VL_String[0].length() + 1));
					dadosSaida.getValue().setString(0, VL_String[0]);

					teflib.mensagemgettag(VL_Mensagem, "010A", VL_Retorno); // atualizacao opcional

					VL_Dados = VL_Retorno.getValue().getString(0);
					teflib.mensagemdispose(VL_Retorno.getValue());

					if (VL_Dados.equals("S")) {

						// o frente de caixa deve tomar a descisão se vai ou nao atualizar, se sim
						// executa o codigo abaixo

						teflib.mensagemaddcomando(VL_Mensagem, "010C", "c:\\temp\\"); // informe o caminho onde vai ser
																						// baixado a lib
						// comando de retorno com o caminho sem o nome do arquivo

						teflib.mensagemtagasstring(VL_Mensagem, VL_Retorno);

						VL_String[0] = VL_Retorno.getValue().getString(0);
						teflib.mensagemdispose(VL_Retorno.getValue());

						dadosSaida.setValue(new Memory(VL_String[0].length() + 1));
						dadosSaida.getValue().setString(0, VL_String[0]);

					}
				}

				if (VL_Comando.equals("00A4")) // status da transacao
				{
					VL_TransacaoStatus = Integer.parseInt(VL_ComandoDados);

					teflib.mensagemgettag(VL_Mensagem, "0034", VL_Retorno); // transacao id

					VL_TransacaoID = VL_Retorno.getValue().getString(0);
					teflib.mensagemdispose(VL_Retorno.getValue());

					teflib.mensagemgettag(VL_Mensagem, "00F1", VL_Retorno); // chave da transacao

					VL_TransacaoChave = VL_Retorno.getValue().getString(0);
					teflib.mensagemdispose(VL_Retorno.getValue());

					if (VL_TransacaoStatus == OpenTefTransacaoStatus.tsComErro.ordinal()) {

						VL_Erro = teflib.transacaostatusdescricao(pointTef, VL_Retorno, VL_TransacaoID);

						VL_DescricaoErroTransacao = VL_Retorno.getValue().getString(0);
						teflib.mensagemdispose(VL_Retorno.getValue());

						teflib.j_mensagemerro(VL_Erro, VL_String);

						VL_DescricaoErro = VL_String[0];

						textEventos.insert(hora + " :Transação com erro " + VL_TransacaoID + ' ' + VL_DescricaoErro,
								textEventos.getCaretPosition());
						teflib.transacaofree(pointTef, VL_TransacaoID);

						return 0;
					}

					if (VL_TransacaoStatus == OpenTefTransacaoStatus.tsCancelada.ordinal()) {

						VL_Erro = teflib.transacaostatusdescricao(pointTef, VL_Retorno, VL_TransacaoID);
						VL_DescricaoErroTransacao = VL_Retorno.getValue().getString(0);
						teflib.mensagemdispose(VL_Retorno.getValue());

						teflib.j_mensagemerro(VL_Erro, VL_String);

						VL_DescricaoErro = VL_String[0];

						textEventos.insert(hora + "Transação cancelada " + VL_TransacaoID + " " + VL_DescricaoErro + " "
								+ VL_DescricaoErroTransacao, textEventos.getCaretPosition());

						teflib.transacaofree(pointTef, VL_TransacaoID);

						return 0;

					}

					if (VL_TransacaoStatus == OpenTefTransacaoStatus.tsNegada.ordinal()) {

						VL_Erro = teflib.transacaostatusdescricao(pointTef, VL_Retorno, VL_TransacaoID);

						VL_DescricaoErroTransacao = VL_Retorno.getValue().getString(0);
						teflib.mensagemdispose(VL_Retorno.getValue());

						teflib.j_mensagemerro(VL_Erro, VL_String);

						VL_DescricaoErro = VL_String[0];

						textEventos.insert(hora + "Transação negada " + VL_TransacaoID + " " + VL_DescricaoErro + " "
								+ VL_DescricaoErroTransacao, textEventos.getCaretPosition());

						teflib.transacaofree(pointTef, VL_TransacaoID);

						return 0;

					}

					if (VL_TransacaoStatus == OpenTefTransacaoStatus.tsNaoLocalizada.ordinal()) {
						VL_Erro = teflib.transacaostatusdescricao(pointTef, VL_Retorno, VL_TransacaoID);

						VL_DescricaoErroTransacao = VL_Retorno.getValue().getString(0);
						teflib.mensagemdispose(VL_Retorno.getValue());

						teflib.j_mensagemerro(VL_Erro, VL_String);

						VL_DescricaoErro = VL_String[0];

						textEventos.insert(hora + " Transação Não localizada " + VL_TransacaoID + " " + VL_DescricaoErro
								+ " " + VL_DescricaoErroTransacao, textEventos.getCaretPosition());

						teflib.transacaofree(pointTef, VL_TransacaoID);

						return 0;

					}

					if (VL_TransacaoStatus == OpenTefTransacaoStatus.tsAbortada.ordinal()) {
						VL_Erro = teflib.transacaostatusdescricao(pointTef, VL_Retorno, VL_TransacaoID);

						VL_DescricaoErroTransacao = VL_Retorno.getValue().getString(0);
						teflib.mensagemdispose(VL_Retorno.getValue());

						teflib.j_mensagemerro(VL_Erro, VL_String);

						VL_DescricaoErro = VL_String[0];

						textEventos.insert(hora + " Transação Abortada " + VL_TransacaoID + " " + VL_DescricaoErro + " "
								+ VL_DescricaoErroTransacao, textEventos.getCaretPosition());

						teflib.transacaofree(pointTef, VL_TransacaoID);

						return 0;

					}

					if (VL_TransacaoStatus == OpenTefTransacaoStatus.tsEfetivada.ordinal()) {

						textEventos.insert(hora + " Transação aprovada " + VL_TransacaoID,
								textEventos.getCaretPosition());

						textEventos.insert(hora + " Chave: " + VL_TransacaoChave, textEventos.getCaretPosition());

						teflib.transacaogettag(pointTef, VL_TransacaoID, "0036", VL_Retorno);

						VL_Bin = VL_Retorno.getValue().getString(0);
						teflib.mensagemdispose(VL_Retorno.getValue());

						textEventos.insert(hora + " Bin: " + VL_Bin, textEventos.getCaretPosition());

						VL_Erro = teflib.transacaostatusdescricao(pointTef, VL_Retorno, VL_TransacaoID);

						VL_DescricaoErroTransacao = VL_Retorno.getValue().getString(0);
						teflib.mensagemdispose(VL_Retorno.getValue());

						teflib.j_mensagemerro(VL_Erro, VL_String);

						VL_DescricaoErro = VL_String[0];

						textEventos.insert(hora + " Transação Aprovada " + VL_TransacaoID + " " + VL_DescricaoErro + " "
								+ VL_DescricaoErroTransacao, textEventos.getCaretPosition());

						teflib.transacaofree(pointTef, VL_TransacaoID);

						return 0;

					}

					OpenTefTransacaoStatus openTefTransacaoStatus = OpenTefTransacaoStatus.values()[VL_TransacaoStatus];
					switch (openTefTransacaoStatus) {
					case OpenTefTransacaoStatus.tsProcessando:
						textEventos.insert(hora + " Transacao ID:" + VL_TransacaoID + "Estado de processamento",
								textEventos.getCaretPosition());
						break;
					case OpenTefTransacaoStatus.tsInicializada:
						textEventos.insert(hora + " Transacao ID:" + VL_TransacaoID + "Estado de inicializada",
								textEventos.getCaretPosition());
						break;
					case OpenTefTransacaoStatus.tsAguardandoComando:
						textEventos.insert(hora + " Transacao ID:" + VL_TransacaoID + "Estado de aguardando comando",
								textEventos.getCaretPosition());
						break;
					case OpenTefTransacaoStatus.tsAguardandoDadosPDV:
						textEventos.insert(
								hora + " Transacao ID:" + VL_TransacaoID + "Estado de aguardando dados do pdv",
								textEventos.getCaretPosition());
					default:
						break;
					}

				}
			}

			finally {
				teflib.mensagemfree(VL_Mensagem);

			}
			return 0;

		}
	}

	public static class SolicitaDadosPDVImpl implements TefLib.SolicitaDadosPDV {

		@Override
		public int callbackSolicitaDadosPDV(String VP_Mensagem, PointerByReference botaoSelecionado,
				PointerByReference dadosSaida) {

			JFrame frame = new JFrame("");
			frame.getContentPane().setLayout(new java.awt.FlowLayout());
			PointerByReference F_Mensagem = new PointerByReference();
			PointerByReference F_RTag = new PointerByReference();
			PointerByReference F_RDados = new PointerByReference();
			JLabel mensagemPDV = new JLabel("");
			JComponent capturadados;

			String F_String = "";
			int contador;
			int F_Erro;

			JMenuOpenTef formulario = new JMenuOpenTef(frame);
			formulario.setSize(600, 200);
			formulario.setLocationRelativeTo(panelPrincipal);
			teflib.mensagemcreate(F_Mensagem);
			teflib.mensagemcarregatags(F_Mensagem.getValue(), VP_Mensagem);

			// Sempre criamos o botao cancelar

			JButtonOpeTef botaocancela = new JButtonOpeTef("Cancelar", "0030"); // tag 0030 = cancelar
			botaocancela.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e) {
					formulario.BotaoSelecionado = botaocancela.tag;
					formulario.dispose();
				}
			});

			// verifica se veio mensagem a ser mostrada na tela

			F_Erro = teflib.mensagemgettag(F_Mensagem.getValue(), "00DA", F_RDados);
			F_String = F_RDados.getValue().getString(0);
			teflib.mensagemdispose(F_RDados.getValue());
			mensagemPDV.setText(teflib.corrigirAcentos(F_String));
			if ((F_Erro == 0) & (mensagemPDV.getText().length() > 0)) {
				formulario.getContentPane().add(Box.createVerticalGlue());
				formulario.getContentPane().add(Box.createVerticalStrut(10));
				formulario.getContentPane().add(mensagemPDV);
				formulario.getContentPane().add(Box.createVerticalStrut(10));
				formulario.getContentPane().add(Box.createVerticalGlue());
			}

			// verifica se é para capturar alguma informação digitada

			F_Erro = teflib.mensagemgettag(F_Mensagem.getValue(), "0033", F_RDados);
			F_String = F_RDados.getValue().getString(0);
			teflib.mensagemdispose(F_RDados.getValue());

			if ((F_Erro == 0) & (F_String.length() > 0)) {

				if (F_String.equals("M")) {
					capturadados = new JPasswordField();
				} else {
					capturadados = new JTextField();
				}

				capturadados.setBounds(-1, -1, 260, 20);

				if (capturadados instanceof JTextField) {
					((JTextField) capturadados).getDocument().addDocumentListener(new DocumentListener() {
						@Override
						public void insertUpdate(DocumentEvent e) {
							formulario.DadosCapturados[0] = ((JTextField) capturadados).getText();
						}

						@Override
						public void removeUpdate(DocumentEvent e) {
							formulario.DadosCapturados[0] = ((JTextField) capturadados).getText();
						}

						@Override
						public void changedUpdate(DocumentEvent e) {
							formulario.DadosCapturados[0] = ((JTextField) capturadados).getText();
						}
					});
				} else {
					((JPasswordField) capturadados).getDocument().addDocumentListener(new DocumentListener() {
						@Override
						public void insertUpdate(DocumentEvent e) {
							formulario.DadosCapturados[0] = new String(((JPasswordField) capturadados).getPassword());
						}

						@Override
						public void removeUpdate(DocumentEvent e) {
							formulario.DadosCapturados[0] = new String(((JPasswordField) capturadados).getPassword());
						}

						@Override
						public void changedUpdate(DocumentEvent e) {
							formulario.DadosCapturados[0] = new String(((JPasswordField) capturadados).getPassword());
						}
					});

				}

				formulario.getContentPane().add(Box.createVerticalGlue());
				formulario.getContentPane().add(Box.createVerticalStrut(10));
				formulario.getContentPane().add(capturadados);
				formulario.getContentPane().add(Box.createVerticalStrut(10));
				formulario.getContentPane().add(Box.createVerticalGlue());
			}

			// mostra imagem se veio alguma
			F_Erro = teflib.mensagemgettag(F_Mensagem.getValue(), "002E", F_RDados);
			F_String = F_RDados.getValue().getString(0);
			teflib.mensagemdispose(F_RDados.getValue());

			if (F_Erro == 0) {

				byte[] imageBytes = Base64.getDecoder().decode(F_String);
				BufferedImage image = null;
				try (ByteArrayInputStream bis = new ByteArrayInputStream(imageBytes)) {
					image = ImageIO.read(bis);
					JLabel label = new JLabel(new ImageIcon(image));
					label.setBounds(0,0,image.getWidth(),image.getHeight());
					formulario.getContentPane().add(Box.createVerticalGlue());
					formulario.getContentPane().add(Box.createVerticalStrut(10));
					formulario.getContentPane().add(formulario.createCenteredPanelI(label));
					formulario.getContentPane().add(Box.createVerticalStrut(10));
					formulario.getContentPane().add(Box.createVerticalGlue());
					formulario.setSize(formulario.getWidth(),formulario.getHeight()+image.getHeight());


				} catch (IOException e) {
					e.printStackTrace();
				}

			}

			// cria os botoes

			F_Erro = teflib.mensagemgettag(F_Mensagem.getValue(), "00DD", F_RDados);
			F_String = F_RDados.getValue().getString(0);
			teflib.mensagemdispose(F_RDados.getValue());

			F_Erro = teflib.mensagemcarregatags(F_Mensagem.getValue(), F_String);

			if (F_Erro == 0) {

				contador = teflib.mensagemtagcount(F_Mensagem.getValue());

				formulario.getContentPane().add(Box.createVerticalGlue());
				for (int i = 1; i <= contador; i++) {

					teflib.mensagemgettagidx(F_Mensagem.getValue(), i, F_RTag, F_RDados);

					if (!F_RTag.getValue().getString(0).equals("0030")) {
						JButtonOpeTef botao = new JButtonOpeTef(
								teflib.corrigirAcentos(F_RDados.getValue().getString(0)),
								F_RTag.getValue().getString(0));

						botao.addActionListener(new ActionListener() {
							public void actionPerformed(ActionEvent e) {
								formulario.BotaoSelecionado = botao.tag;
								formulario.dispose();
							}
						});

						formulario.getContentPane().add(formulario.createCenteredPanel(botao));
						formulario.getContentPane().add(Box.createVerticalStrut(10));
					}
					teflib.mensagemdispose(F_RTag.getValue());
					teflib.mensagemdispose(F_RDados.getValue());
				}

				formulario.getContentPane().add(formulario.createCenteredPanel(botaocancela));
				formulario.getContentPane().add(Box.createVerticalStrut(10));

				formulario.getContentPane().add(Box.createVerticalGlue());

				formulario.setVisible(true);
				String resultado = formulario.BotaoSelecionado;

				if (resultado == null) {
					resultado = "0030"; // se nao selecionar nada então considera cancelado
				}

				botaoSelecionado.setValue(new Memory(resultado.length() + 1));
				botaoSelecionado.getValue().setString(0, resultado);
				dadosSaida.setValue(new Memory(formulario.DadosCapturados[0].length() + 1));
				dadosSaida.getValue().setString(0, formulario.DadosCapturados[0]);

				teflib.mensagemfree(F_Mensagem.getValue());
			}

			return 0;

		}

	}

	public static class SolicitaDadosTransacaoImpl implements TefLib.SolicitaDadosTransacao {

		@Override
		public int callbackSolicitaDadosTransacao(String VP_Mensagem, PointerByReference VO_Mensagem) {

			PointerByReference FP_Mensagem = new PointerByReference();
			PointerByReference FO_Mensagem = new PointerByReference();
			PointerByReference F_RTag = new PointerByReference();
			PointerByReference F_RDados = new PointerByReference();
			int contador;
			int F_Erro;
			String hora = new SimpleDateFormat("HH:mm:ss").format(new Date());

			try {
				teflib.mensagemcreate(FP_Mensagem);
				teflib.mensagemcreate(FO_Mensagem);
				teflib.mensagemaddcomando(FO_Mensagem.getValue(), "00E1", "R");

				F_Erro = teflib.mensagemcarregatags(FP_Mensagem.getValue(), VP_Mensagem);

				if (F_Erro == 0) {

					contador = teflib.mensagemtagcount(FP_Mensagem.getValue());
					for (int i = 1; i <= contador; i++) {

						teflib.mensagemgettagidx(FP_Mensagem.getValue(), i, F_RTag, F_RDados);

						if (F_RTag.getValue().getString(0).equals("0011")) {
							teflib.mensagemaddtag(FO_Mensagem.getValue(), "0011", textVendaCaixa.getText());
						}
						if (F_RTag.getValue().getString(0).equals("0012")) {
							teflib.mensagemaddtag(FO_Mensagem.getValue(), "0012", textVendaOperador.getText());
						}
						if (F_RTag.getValue().getString(0).equals("0010")) {
							teflib.mensagemaddtag(FO_Mensagem.getValue(), "0010", textVendaCupom.getText());
						}
						if (F_RTag.getValue().getString(0).equals("000E")) {
							teflib.mensagemaddtag(FO_Mensagem.getValue(), "000E", textVendaValorParcela.getText());
						}
						if (F_RTag.getValue().getString(0).equals("000F")) {
							teflib.mensagemaddtag(FO_Mensagem.getValue(), "000F", textVendaParcela.getText());
						}
						if (F_RTag.getValue().getString(0).equals("0013")) {
							teflib.mensagemaddtag(FO_Mensagem.getValue(), "0013", textVendaValorTotal.getText());
						}
						if (F_RTag.getValue().getString(0).equals("0014")) {
							teflib.mensagemaddtag(FO_Mensagem.getValue(), "0014", textVendaAlimentacao.getText());
						}
						if (F_RTag.getValue().getString(0).equals("0015")) {
							teflib.mensagemaddtag(FO_Mensagem.getValue(), "0015", textVendaRefeicao.getText());
						}
						if (F_RTag.getValue().getString(0).equals("0016")) {
							teflib.mensagemaddtag(FO_Mensagem.getValue(), "0016", textVendaCultura.getText());
						}
						if (F_RTag.getValue().getString(0).equals("0017")) {
							teflib.mensagemaddtag(FO_Mensagem.getValue(), "0017", textVendaXml.getText());
						}
						if (F_RTag.getValue().getString(0).equals("000B")) {
							teflib.mensagemaddtag(FO_Mensagem.getValue(), "000B", textVendaNsu.getText());
						}
						if (F_RTag.getValue().getString(0).equals("000C")) {
							teflib.mensagemaddtag(FO_Mensagem.getValue(), "000C", textVendaData.getText());
						}
						if (F_RTag.getValue().getString(0).equals("000D")) {
							teflib.mensagemaddtag(FO_Mensagem.getValue(), "000D", hora);
						}
						if (F_RTag.getValue().getString(0).equals("00E5")) {
							teflib.mensagemaddtag(FO_Mensagem.getValue(), "00E5", textVendaLink.getText());
						}
						if (F_RTag.getValue().getString(0).equals("00E6")) {
							teflib.mensagemaddtag(FO_Mensagem.getValue(), "00E6", textVendaDesconto.getText());
						}
						if (F_RTag.getValue().getString(0).equals("0040")) {
							teflib.mensagemaddtag(FO_Mensagem.getValue(), "0040", textVendaObs.getText());
						}
						if (F_RTag.getValue().getString(0).equals("00F1")) {
							teflib.mensagemaddtag(FO_Mensagem.getValue(), "00F1", textChave.getText());
						}

						teflib.mensagemdispose(F_RTag.getValue());
						teflib.mensagemdispose(F_RDados.getValue());
					}

					teflib.mensagemtagasstring(FO_Mensagem.getValue(), F_RDados);

					VO_Mensagem.setValue(new Memory(F_RDados.getValue().getString(0).length() + 1));
					VO_Mensagem.getValue().setString(0, F_RDados.getValue().getString(0));
					teflib.mensagemdispose(F_RDados.getValue());

				}
			} finally {
				teflib.mensagemfree(FP_Mensagem.getValue());
				teflib.mensagemfree(FO_Mensagem.getValue());
			}

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
		public int callbackMostraMenu(String dados, PointerByReference botaoSelecionado) {

			JFrame frame = new JFrame("");
			frame.getContentPane().setLayout(new java.awt.FlowLayout());
			PointerByReference F_Mensagem = new PointerByReference();
			PointerByReference F_RTag = new PointerByReference();
			PointerByReference F_RDados = new PointerByReference();
			int contador;

			JMenuOpenTef formulario = new JMenuOpenTef(frame);
			formulario.setSize(600, 200);
			formulario.setLocationRelativeTo(panelPrincipal);
			teflib.mensagemcreate(F_Mensagem);
			teflib.mensagemcarregatags(F_Mensagem.getValue(), dados);

			// Sempre criamos o botao cancelar

			JButtonOpeTef botaocancela = new JButtonOpeTef("Cancelar", "0030"); // tag 0030 = cancelar
			botaocancela.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e) {
					formulario.BotaoSelecionado = botaocancela.tag;
					formulario.dispose();
				}
			});

			contador = teflib.mensagemtagcount(F_Mensagem.getValue());

			formulario.getContentPane().add(Box.createVerticalGlue());
			for (int i = 1; i <= contador; i++) {

				teflib.mensagemgettagidx(F_Mensagem.getValue(), i, F_RTag, F_RDados);

				if (!F_RTag.getValue().getString(0).equals("0030")) {
					JButtonOpeTef botao = new JButtonOpeTef(teflib.corrigirAcentos(F_RDados.getValue().getString(0)),
							F_RTag.getValue().getString(0));

					botao.addActionListener(new ActionListener() {
						public void actionPerformed(ActionEvent e) {
							formulario.BotaoSelecionado = botao.tag;
							formulario.dispose();
						}
					});
					formulario.getContentPane().add(formulario.createCenteredPanel(botao));
					formulario.getContentPane().add(Box.createVerticalStrut(10));

				}
				teflib.mensagemdispose(F_RTag.getValue());
				teflib.mensagemdispose(F_RDados.getValue());

			}
			formulario.getContentPane().add(formulario.createCenteredPanel(botaocancela));
			formulario.getContentPane().add(Box.createVerticalStrut(10));

			formulario.getContentPane().add(Box.createVerticalGlue());

			formulario.setVisible(true);
			String resultado = formulario.BotaoSelecionado;

			if (resultado == null) {
				resultado = "0030"; // se nao selecionar nada então considera cancelado
			}

			botaoSelecionado.setValue(new Memory(resultado.length() + 1));
			botaoSelecionado.getValue().setString(0, resultado);
			teflib.mensagemfree(F_Mensagem.getValue());
			return 0;

		}

	}

	public static class StrDisposeImpl implements TefLib.StrDispose {

		@Override
		public void callbackStrDispose(Pointer dados) {
			dados = null;

		}

	}

	public static class MensagemOperadorImple implements TefLib.MensagemOperador {

		@Override
		public int callbackMensagemOperador(String mensagem) {
			JOptionPane.showMessageDialog(null, teflib.corrigirAcentos(mensagem.replaceAll("(?i)<br\\s*/?>", "\n")));
			return 0;
		}

	}

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					FInterface frame = new FInterface();
					frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Create the frame.
	 */
	public FInterface() {

		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 940, 600);

		panelPrincipal = new JPanel();
		panelPrincipal.setBorder(new EmptyBorder(5, 5, 5, 5));

		setContentPane(panelPrincipal);
		panelPrincipal.setLayout(new BorderLayout(0, 0));

		JTabbedPane tabbedPane = new JTabbedPane(JTabbedPane.TOP);
		panelPrincipal.add(tabbedPane);

		JScrollPane scrollPaneConfiguracao = new JScrollPane();
		tabbedPane.addTab("Configuração", null, scrollPaneConfiguracao, null);

		JPanel panelConfiguracao = new JPanel();
		scrollPaneConfiguracao.setViewportView(panelConfiguracao);
		panelConfiguracao.setLayout(null);

		JPanel panelLogin = new JPanel();
		panelLogin.setBorder(new TitledBorder(null, "Login", TitledBorder.LEADING, TitledBorder.TOP, null, null));
		panelLogin.setBounds(562, 11, 315, 334);
		panelConfiguracao.add(panelLogin);
		panelLogin.setLayout(null);

		JLabel labelHost = new JLabel("Host");
		labelHost.setHorizontalAlignment(SwingConstants.RIGHT);
		labelHost.setBounds(20, 34, 70, 14);
		panelLogin.add(labelHost);

		textHost = new JTextField();
		 textHost.setText("homologacao.opentef.com.br");
		//textHost.setText("127.0.0.1");
		textHost.setColumns(10);
		textHost.setBounds(97, 31, 201, 20);
		panelLogin.add(textHost);

		JLabel labelPorta = new JLabel("Porta");
		labelPorta.setHorizontalAlignment(SwingConstants.RIGHT);
		labelPorta.setBounds(20, 62, 70, 14);
		panelLogin.add(labelPorta);

		JSpinner spinnerPorta = new JSpinner();
		spinnerPorta.setModel(new SpinnerNumberModel(Integer.valueOf(39001), null, null, Integer.valueOf(1)));
		spinnerPorta.setBounds(97, 59, 78, 20);
		panelLogin.add(spinnerPorta);

		JLabel labelID = new JLabel("ID");
		labelID.setBounds(210, 62, 11, 14);
		panelLogin.add(labelID);

		JSpinner spinnerID = new JSpinner();
		spinnerID.setModel(new SpinnerNumberModel(Integer.valueOf(0), null, null, Integer.valueOf(1)));
		spinnerID.setBounds(231, 59, 67, 20);
		panelLogin.add(spinnerID);

		textChave = new JTextArea();
		textChave.setBounds(97, 90, 201, 49);
		panelLogin.add(textChave);

		JLabel labelChave = new JLabel("Chave");
		labelChave.setHorizontalAlignment(SwingConstants.RIGHT);
		labelChave.setBounds(20, 106, 70, 14);
		panelLogin.add(labelChave);

		JLabel labelIdentificador = new JLabel("Identificador");
		labelIdentificador.setHorizontalAlignment(SwingConstants.RIGHT);
		labelIdentificador.setBounds(10, 166, 80, 14);
		panelLogin.add(labelIdentificador);

		JTextArea textIdentificador = new JTextArea();
		textIdentificador.setBounds(97, 150, 201, 49);
		panelLogin.add(textIdentificador);

		JPanel panelLibs = new JPanel();
		panelLibs.setLayout(null);
		panelLibs.setBorder(new TitledBorder(
				new EtchedBorder(EtchedBorder.LOWERED, new Color(255, 255, 255), new Color(160, 160, 160)),
				"Inicializa\u00E7\u00E3o das Libs", TitledBorder.LEADING, TitledBorder.TOP, null, new Color(0, 0, 0)));
		panelLibs.setBounds(10, 11, 544, 334);
		panelConfiguracao.add(panelLibs);

		JLabel lblTeflibcaminhoApp = new JLabel("Tef_lib (Caminho App+):");
		lblTeflibcaminhoApp.setHorizontalAlignment(SwingConstants.LEFT);
		lblTeflibcaminhoApp.setBounds(20, 34, 163, 14);
		panelLibs.add(lblTeflibcaminhoApp);

		textTefLib = new JTextField();
		textTefLib.setText(
				"..\\..\\..\\..\\..\\binarios\\tef_lib\\win64\\tef_lib.dll");
		textTefLib.setColumns(10);
		textTefLib.setBounds(193, 31, 282, 20);
		panelLibs.add(textTefLib);

		lblConexao.setForeground(new Color(255, 0, 0));
		lblConexao.setFont(new Font("Tahoma", Font.BOLD, 11));
		lblConexao.setHorizontalAlignment(SwingConstants.RIGHT);
		lblConexao.setBounds(177, 309, 121, 14);
		panelLogin.add(lblConexao);

		JComboBox<String> comboBoxPinPad = new JComboBox<String>();
		comboBoxPinPad.setModel(new DefaultComboBoxModel<String>(new String[] { "SEM PINPAD", "GERTEC_PPC930" }));
		comboBoxPinPad.setSelectedIndex(0);
		comboBoxPinPad.setBounds(193, 175, 282, 22);
		panelLibs.add(comboBoxPinPad);

		addWindowListener(new WindowAdapter() {
			@Override
			public void windowClosing(WindowEvent e) {
				if (pointTef != null) {
					teflib.finalizar(pointTef);
					Native.unregister(TefLib.class);
					pointTef = null;
					teflib = null;

				}
				System.gc();

			}
		});

		JButton btnIniciaLib = new JButton("Inicializar Libs");
		
		btnIniciaLib.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {

				try {
					File baseDir = new File(FInterface.class.getResource("FInterface.class").toURI());
					caminho=baseDir.getParent();
					
					
					File dllFile = new File(caminho, textTefLib.getText());
					try {
					caminho=dllFile.getCanonicalPath();
					}
					catch(IOException ee)  {
						// TODO Auto-generated catch block
					
					}
					
				} catch (URISyntaxException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
			
				
				teflib = Native.load(caminho, TefLib.class);

				retornoImpl = new RetornoImpl();
				solicitaDadosPDVImpl = new SolicitaDadosPDVImpl();
				solicitaDadosTransacaoImpl = new SolicitaDadosTransacaoImpl();
				imprimirImpl = new ImprimirImpl();
				mostraMenuImpl = new MostraMenuImpl();
				strDisposeImpl = new StrDisposeImpl();
				mensagemOperadorImple = new MensagemOperadorImple();
				tef = new PointerByReference();
				int erro = teflib.inicializar(tef, comboBoxPinPad.getSelectedIndex(), textPinPadModeloLib.getText(),
						textPinPadModeloPorta.getText(), textPinPadLib.getText(), textLog.getText(), strDisposeImpl,
						retornoImpl, solicitaDadosTransacaoImpl, solicitaDadosPDVImpl, imprimirImpl, mostraMenuImpl,
						mensagemOperadorImple, 0);

				if (erro != 0) {

					String[] mensagem = new String[1];
					teflib.j_mensagemerro(erro, mensagem);
					JOptionPane.showMessageDialog(null, mensagem[0]);
				} else {
					pointTef = tef.getValue();
					teflib.alterarnivellog(Integer.valueOf(textNivelLog.getText()));
				}

			}
		});
		btnIniciaLib.setBounds(191, 300, 130, 23);
		panelLibs.add(btnIniciaLib);

		JButton btnLogin = new JButton("Login");
		btnLogin.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				int erro;

				erro = teflib.login(pointTef, textHost.getText(), (int) spinnerPorta.getValue(),
						(int) spinnerID.getValue(), textChave.getText(), 1, textIdentificador.getText());
				if (erro != 0) {

					String[] mensagem = new String[1];
					teflib.j_mensagemerro(erro, mensagem);
					JOptionPane.showMessageDialog(null, "Erro:" + erro + " - " + mensagem[0]);

				} else {
					lblConexao.setText("Conectado");
					lblConexao.setForeground(new Color(0, 0, 255));
				}

			}
		});
		btnLogin.setBounds(97, 212, 201, 23);
		panelLogin.add(btnLogin);

		JButton btnDesconectar = new JButton("Desconectar");
		btnDesconectar.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				teflib.desconectar(pointTef);
				lblConexao.setText("Desconectado");
				lblConexao.setForeground(new Color(255, 0, 0));

			}
		});
		btnDesconectar.setBounds(97, 246, 201, 23);
		panelLogin.add(btnDesconectar);

		JButton btnFinalizar = new JButton("Finalizar");
		btnFinalizar.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {

				int erro;
				erro = teflib.finalizar(pointTef);
				Native.unregister(TefLib.class);
				pointTef = null;
				teflib = null;
				System.gc();
				if (erro != 0) {

					String[] mensagem = new String[1];
					teflib.j_mensagemerro(erro, mensagem);
					JOptionPane.showMessageDialog(null, "Erro:" + erro + " - " + mensagem[0]);

				}
			}
		});
		btnFinalizar.setBounds(344, 300, 131, 23);
		panelLibs.add(btnFinalizar);

		JLabel lblPinpadlibcaminhoApp = new JLabel("Pinpad_lib(Caminho App+):");
		lblPinpadlibcaminhoApp.setHorizontalAlignment(SwingConstants.LEFT);
		lblPinpadlibcaminhoApp.setBounds(20, 64, 163, 14);
		panelLibs.add(lblPinpadlibcaminhoApp);

		textPinPadLib = new JTextField();
		textPinPadLib.setText("..\\..\\pinpad_lib\\win64\\pinpad_lib.dll");
		textPinPadLib.setColumns(10);
		textPinPadLib.setBounds(193, 61, 282, 20);
		panelLibs.add(textPinPadLib);

		JLabel lblLibModeloPinPad = new JLabel("Modelo_lib(Caminho App+):");
		lblLibModeloPinPad.setHorizontalAlignment(SwingConstants.LEFT);
		lblLibModeloPinPad.setBounds(20, 122, 163, 14);
		panelLibs.add(lblLibModeloPinPad);

		JLabel lblPinpadlibhashMd = new JLabel("Pinpad_lib(HASH MD5):");
		lblPinpadlibhashMd.setHorizontalAlignment(SwingConstants.LEFT);
		lblPinpadlibhashMd.setBounds(20, 92, 163, 14);
		panelLibs.add(lblPinpadlibhashMd);

		textPinPadLibHashMd5 = new JTextField();
		textPinPadLibHashMd5.setColumns(10);
		textPinPadLibHashMd5.setBounds(193, 89, 282, 20);
		panelLibs.add(textPinPadLibHashMd5);

		textPinPadModeloLib = new JTextField();
		textPinPadModeloLib.setText("..\\..\\pinpad_lib\\win64\\");
		textPinPadModeloLib.setColumns(10);
		textPinPadModeloLib.setBounds(193, 119, 282, 20);
		panelLibs.add(textPinPadModeloLib);

		JLabel lblModelolibhashMd = new JLabel("Modelo_lib(HASH MD5):");
		lblModelolibhashMd.setHorizontalAlignment(SwingConstants.LEFT);
		lblModelolibhashMd.setBounds(20, 150, 163, 14);
		panelLibs.add(lblModelolibhashMd);

		textPinPadModeloLibHashMd5 = new JTextField();
		textPinPadModeloLibHashMd5.setColumns(10);
		textPinPadModeloLibHashMd5.setBounds(193, 147, 282, 20);
		panelLibs.add(textPinPadModeloLibHashMd5);

		textPinPadModeloPorta = new JTextField();
		textPinPadModeloPorta.setText("COM4");
		textPinPadModeloPorta.setColumns(10);
		textPinPadModeloPorta.setBounds(193, 205, 282, 20);
		panelLibs.add(textPinPadModeloPorta);

		textTempo = new JTextField();
		textTempo.setText("60000");
		textTempo.setColumns(10);
		textTempo.setBounds(193, 235, 66, 20);
		panelLibs.add(textTempo);

		JLabel lblTempoEspera = new JLabel("Tempo de espera em ms ");
		lblTempoEspera.setHorizontalAlignment(SwingConstants.LEFT);
		lblTempoEspera.setBounds(20, 238, 163, 14);
		panelLibs.add(lblTempoEspera);

		JLabel lblPortaPinPad = new JLabel("Porta Pin Pad");
		lblPortaPinPad.setHorizontalAlignment(SwingConstants.LEFT);
		lblPortaPinPad.setBounds(20, 208, 163, 14);
		panelLibs.add(lblPortaPinPad);

		JLabel lblModeloPinPad = new JLabel("Modelo Pin Pad:");
		lblModeloPinPad.setHorizontalAlignment(SwingConstants.LEFT);
		lblModeloPinPad.setBounds(20, 180, 163, 14);
		panelLibs.add(lblModeloPinPad);

		textLog = new JTextField();
		textLog.setText("E:\\temp\\log.log");
		textLog.setColumns(10);
		textLog.setBounds(193, 263, 282, 20);
		panelLibs.add(textLog);

		JLabel lblArquivoLog = new JLabel("Arquivo de Logs");
		lblArquivoLog.setHorizontalAlignment(SwingConstants.LEFT);
		lblArquivoLog.setBounds(20, 266, 163, 14);
		panelLibs.add(lblArquivoLog);

		JLabel lblNvelDeLog = new JLabel("Nível de log");
		lblNvelDeLog.setHorizontalAlignment(SwingConstants.LEFT);
		lblNvelDeLog.setBounds(362, 238, 66, 14);
		panelLibs.add(lblNvelDeLog);

		textNivelLog = new JTextField();
		textNivelLog.setText("3");
		textNivelLog.setColumns(10);
		textNivelLog.setBounds(438, 235, 37, 20);
		panelLibs.add(textNivelLog);

		JScrollPane scrollPaneCaixa = new JScrollPane();
		tabbedPane.addTab("Caixa", null, scrollPaneCaixa, null);

		JPanel panelCaixa = new JPanel();
		scrollPaneCaixa.setViewportView(panelCaixa);
		panelCaixa.setLayout(null);

		JPanel panelDadosTransacao = new JPanel();
		panelDadosTransacao.setLayout(null);
		panelDadosTransacao.setBorder(new TitledBorder(
				new EtchedBorder(EtchedBorder.LOWERED, new Color(255, 255, 255), new Color(160, 160, 160)),
				"Dados da Transa\u00E7\u00E3o", TitledBorder.LEADING, TitledBorder.TOP, null, new Color(0, 0, 0)));
		panelDadosTransacao.setBounds(10, 11, 400, 472);
		panelCaixa.add(panelDadosTransacao);

		JLabel lblDataDaVenda = new JLabel("Data da venda");
		lblDataDaVenda.setHorizontalAlignment(SwingConstants.LEFT);
		lblDataDaVenda.setBounds(11, 37, 77, 14);
		panelDadosTransacao.add(lblDataDaVenda);

		textVendaData = new JTextField();
		textVendaData.setText("18/09/2024");
		textVendaData.setColumns(10);
		textVendaData.setBounds(98, 34, 86, 20);
		panelDadosTransacao.add(textVendaData);

		JLabel lblNsuLocal = new JLabel("NSU Local");
		lblNsuLocal.setHorizontalAlignment(SwingConstants.LEFT);
		lblNsuLocal.setBounds(11, 68, 68, 14);
		panelDadosTransacao.add(lblNsuLocal);

		textVendaNsu = new JTextField();
		textVendaNsu.setText("123456");
		textVendaNsu.setColumns(10);
		textVendaNsu.setBounds(98, 65, 86, 20);
		panelDadosTransacao.add(textVendaNsu);

		JLabel lblCaixa = new JLabel("Caixa");
		lblCaixa.setHorizontalAlignment(SwingConstants.LEFT);
		lblCaixa.setBounds(11, 130, 38, 14);
		panelDadosTransacao.add(lblCaixa);

		JLabel lblDesconto = new JLabel("Desconto");
		lblDesconto.setHorizontalAlignment(SwingConstants.LEFT);
		lblDesconto.setBounds(11, 99, 61, 14);
		panelDadosTransacao.add(lblDesconto);

		textVendaDesconto = new JTextField();
		textVendaDesconto.setText("0%");
		textVendaDesconto.setColumns(10);
		textVendaDesconto.setBounds(98, 96, 86, 20);
		panelDadosTransacao.add(textVendaDesconto);

		textVendaCaixa = new JTextField();
		textVendaCaixa.setText("pdv10");
		textVendaCaixa.setColumns(10);
		textVendaCaixa.setBounds(98, 127, 86, 20);
		panelDadosTransacao.add(textVendaCaixa);

		JLabel lblObs = new JLabel("Observação");
		lblObs.setHorizontalAlignment(SwingConstants.LEFT);
		lblObs.setBounds(11, 161, 77, 14);
		panelDadosTransacao.add(lblObs);

		textVendaObs = new JTextField();
		textVendaObs.setColumns(10);
		textVendaObs.setBounds(98, 158, 282, 20);
		panelDadosTransacao.add(textVendaObs);

		JLabel lblValorDaParcela = new JLabel("Valor da Parcela");
		lblValorDaParcela.setHorizontalAlignment(SwingConstants.LEFT);
		lblValorDaParcela.setBounds(194, 40, 90, 14);
		panelDadosTransacao.add(lblValorDaParcela);

		textVendaValorParcela = new JTextField();
		textVendaValorParcela.setText("R$ 12,23");
		textVendaValorParcela.setColumns(10);
		textVendaValorParcela.setBounds(294, 37, 86, 20);
		panelDadosTransacao.add(textVendaValorParcela);

		textVendaParcela = new JTextField();
		textVendaParcela.setText("1");
		textVendaParcela.setColumns(10);
		textVendaParcela.setBounds(294, 68, 86, 20);
		panelDadosTransacao.add(textVendaParcela);

		JLabel lblNumeroDeParcelas = new JLabel("Nº de Parcelas");
		lblNumeroDeParcelas.setHorizontalAlignment(SwingConstants.LEFT);
		lblNumeroDeParcelas.setBounds(194, 71, 90, 14);
		panelDadosTransacao.add(lblNumeroDeParcelas);

		JLabel lblOperador = new JLabel("Operador");
		lblOperador.setHorizontalAlignment(SwingConstants.LEFT);
		lblOperador.setBounds(194, 130, 61, 14);
		panelDadosTransacao.add(lblOperador);

		textVendaOperador = new JTextField();
		textVendaOperador.setText("Fulano");
		textVendaOperador.setColumns(10);
		textVendaOperador.setBounds(294, 127, 86, 20);
		panelDadosTransacao.add(textVendaOperador);

		JPanel panelValorProgramaSocial = new JPanel();
		panelValorProgramaSocial.setBorder(new TitledBorder(null, "Valor Total de Itens por Tipo de Programa social",
				TitledBorder.LEADING, TitledBorder.TOP, null, null));
		panelValorProgramaSocial.setBounds(11, 199, 373, 97);
		panelDadosTransacao.add(panelValorProgramaSocial);
		panelValorProgramaSocial.setLayout(null);

		JLabel lblAlimentao = new JLabel("Alimentação");
		lblAlimentao.setHorizontalAlignment(SwingConstants.CENTER);
		lblAlimentao.setBounds(49, 29, 85, 14);
		panelValorProgramaSocial.add(lblAlimentao);

		textVendaAlimentacao = new JTextField();
		textVendaAlimentacao.setText("R$ 15,00");
		textVendaAlimentacao.setColumns(10);
		textVendaAlimentacao.setBounds(49, 52, 86, 20);
		panelValorProgramaSocial.add(textVendaAlimentacao);

		textVendaRefeicao = new JTextField();
		textVendaRefeicao.setText("R$ 15,00");
		textVendaRefeicao.setColumns(10);
		textVendaRefeicao.setBounds(144, 52, 86, 20);
		panelValorProgramaSocial.add(textVendaRefeicao);

		JLabel lblRefeio = new JLabel("Refeição");
		lblRefeio.setHorizontalAlignment(SwingConstants.CENTER);
		lblRefeio.setBounds(144, 29, 85, 14);
		panelValorProgramaSocial.add(lblRefeio);

		textVendaCultura = new JTextField();
		textVendaCultura.setText("R$ 15,00");
		textVendaCultura.setColumns(10);
		textVendaCultura.setBounds(240, 52, 86, 20);
		panelValorProgramaSocial.add(textVendaCultura);

		JLabel lblValeCultura = new JLabel("Vale Cultura");
		lblValeCultura.setHorizontalAlignment(SwingConstants.CENTER);
		lblValeCultura.setBounds(240, 29, 85, 14);
		panelValorProgramaSocial.add(lblValeCultura);

		JPanel panelCupomFiscal = new JPanel();
		panelCupomFiscal.setLayout(null);
		panelCupomFiscal.setBorder(new TitledBorder(
				new EtchedBorder(EtchedBorder.LOWERED, new Color(255, 255, 255), new Color(160, 160, 160)),
				"Cupom Fiscal", TitledBorder.LEADING, TitledBorder.TOP, null, new Color(0, 0, 0)));
		panelCupomFiscal.setBounds(11, 307, 373, 154);
		panelDadosTransacao.add(panelCupomFiscal);

		JLabel lblCupomFiscal = new JLabel("Cupom Fiscal");
		lblCupomFiscal.setHorizontalAlignment(SwingConstants.LEFT);
		lblCupomFiscal.setBounds(10, 29, 85, 14);
		panelCupomFiscal.add(lblCupomFiscal);

		textVendaCupom = new JTextField();
		textVendaCupom.setText("123");
		textVendaCupom.setColumns(10);
		textVendaCupom.setBounds(96, 26, 55, 20);
		panelCupomFiscal.add(textVendaCupom);

		JLabel lblXmlNota = new JLabel("XML Nota");
		lblXmlNota.setHorizontalAlignment(SwingConstants.LEFT);
		lblXmlNota.setBounds(10, 83, 70, 14);
		panelCupomFiscal.add(lblXmlNota);

		JScrollPane scrollXml = new JScrollPane();
		scrollXml.setBounds(94, 57, 269, 86);
		panelCupomFiscal.add(scrollXml);

		textVendaXml = new JTextArea();
		textVendaXml.setText(
				"<NFe xmlns=\"http://www.portalfiscal.inf.br/nfe\">\r\n\r\n    <infNFe Id=\"NFe35080599999090910270550010000000015180051273\" versao=\"1.10\">\r\n        <ide>\r\n            <cUF>35</cUF>\r\n            <cNF>518005127</cNF>\r\n            <natOp>Venda a vista</natOp>\r\n            <indPag>0</indPag>\r\n            <mod>55</mod>\r\n            <serie>1</serie>\r\n            <nNF>1</nNF>\r\n            <dEmi>2008-05-06</dEmi>\r\n            <dSaiEnt>2008-05-06</dSaiEnt>\r\n            <tpNF>0</tpNF>\r\n            <cMunFG>3550308</cMunFG>\r\n            <tpImp>1</tpImp>\r\n            <tpEmis>1</tpEmis>\r\n            <cDV>3</cDV>\r\n            <tpAmb>2</tpAmb>\r\n            <finNFe>1</finNFe>\r\n            <procEmi>0</procEmi>\r\n            <verProc>NF-eletronica.com</verProc> </ide>\r\n        <emit>\r\n            <CNPJ>99999090910270</CNPJ>\r\n            <xNome>NF-e Associacao NF-e</xNome>\r\n            <xFant>NF-e</xFant>\r\n            <enderEmit>\r\n                <xLgr>Rua Central</xLgr>\r\n                <nro>100</nro>\r\n                <xCpl>Fundos</xCpl>\r\n                <xBairro>Distrito Industrial</xBairro>\r\n                <cMun>3502200</cMun>\r\n                <xMun>Angatuba</xMun>\r\n                <UF>SP</UF>\r\n                <CEP>17100171</CEP>\r\n                <cPais>1058</cPais>\r\n                <xPais>Brasil</xPais>\r\n                <fone>1733021717</fone> </enderEmit>\r\n            <IE>123456789012</IE> </emit>\r\n        <dest>\r\n            <CNPJ>00000000000191</CNPJ>\r\n            <xNome>DISTRIBUIDORA DE AGUAS MINERAIS</xNome>\r\n            <enderDest>\r\n                <xLgr>AV DAS FONTES</xLgr>\r\n                <nro>1777</nro>\r\n                <xCpl>10 ANDAR</xCpl>\r\n                <xBairro>PARQUE FONTES</xBairro>\r\n                <cMun>5030801</cMun>\r\n                <xMun>Sao Paulo</xMun>\r\n                <UF>SP</UF>\r\n                <CEP>13950000</CEP>\r\n                <cPais>1058</cPais>\r\n                <xPais>BRASIL</xPais>\r\n                <fone>1932011234</fone> </enderDest>\r\n            <IE> </IE> </dest>\r\n        <retirada>\r\n            <CNPJ>99171171000194</CNPJ>\r\n            <xLgr>AV PAULISTA</xLgr>\r\n            <nro>12345</nro>\r\n            <xCpl>TERREO</xCpl>\r\n            <xBairro>CERQUEIRA CESAR</xBairro>\r\n            <cMun>3550308</cMun>\r\n            <xMun>SAO PAULO</xMun>\r\n            <UF>SP</UF> </retirada>\r\n        <entrega>\r\n            <CNPJ>99299299000194</CNPJ>\r\n            <xLgr>AV FARIA LIMA</xLgr>\r\n            <nro>1500</nro>\r\n            <xCpl>15 ANDAR</xCpl>\r\n            <xBairro>PINHEIROS</xBairro>\r\n            <cMun>3550308</cMun>\r\n            <xMun>SAO PAULO</xMun>\r\n            <UF>SP</UF> </entrega>\r\n        <det nItem=\"1\">\r\n            <prod>\r\n                <cProd>00001</cProd>\r\n                <cEAN></cEAN>\r\n                <xProd>Agua Mineral</xProd>\r\n                <CFOP>5101</CFOP>\r\n                <uCom>dz</uCom>\r\n                <qCom>1000000.0000</qCom>\r\n                <vUnCom>1</vUnCom>\r\n                <vProd>10000000.00</vProd>\r\n                <cEANTrib></cEANTrib>\r\n                <uTrib>und</uTrib>\r\n                <qTrib>12000000.0000</qTrib>\r\n                <vUnTrib>1</vUnTrib> </prod>\r\n            <imposto>\r\n                <ICMS>\r\n                    <ICMS00>\r\n                        <orig>0</orig>\r\n                        <CST>00</CST>\r\n                        <modBC>0</modBC>\r\n                        <vBC>10000000.00</vBC>\r\n                        <pICMS>18.00</pICMS>\r\n                        <vICMS>1800000.00</vICMS> </ICMS00> </ICMS>\r\n                <PIS>\r\n                    <PISAliq>\r\n                        <CST>01</CST>\r\n                        <vBC>10000000.00</vBC>\r\n                        <pPIS>0.65</pPIS>\r\n                        <vPIS>65000</vPIS> </PISAliq> </PIS>\r\n                <COFINS>\r\n                    <COFINSAliq>\r\n                        <CST>01</CST>\r\n                        <vBC>10000000.00</vBC>\r\n                        <pCOFINS>2.00</pCOFINS>\r\n                        <vCOFINS>200000.00</vCOFINS> </COFINSAliq> </COFINS> </imposto> </det>\r\n        <det nItem=\"2\">\r\n            <prod>\r\n                <cProd>00002</cProd>\r\n                <cEAN></cEAN>\r\n                <xProd>Agua Mineral</xProd>\r\n                <CFOP>5101</CFOP>\r\n                <uCom>pack</uCom>\r\n                <qCom>5000000.0000</qCom>\r\n                <vUnCom>2</vUnCom>\r\n                <vProd>10000000.00</vProd>\r\n                <cEANTrib></cEANTrib>\r\n                <uTrib>und</uTrib>\r\n                <qTrib>3000000.0000</qTrib>\r\n                <vUnTrib>0.3333</vUnTrib> </prod>\r\n            <imposto>\r\n                <ICMS>\r\n                    <ICMS00>\r\n                        <orig>0</orig>\r\n                        <CST>00</CST>\r\n                        <modBC>0</modBC>\r\n                        <vBC>10000000.00</vBC>\r\n                        <pICMS>18.00</pICMS>\r\n                        <vICMS>1800000.00</vICMS> </ICMS00> </ICMS>\r\n                <PIS>\r\n                    <PISAliq>\r\n                        <CST>01</CST>\r\n                        <vBC>10000000.00</vBC>\r\n                        <pPIS>0.65</pPIS>\r\n                        <vPIS>65000</vPIS> </PISAliq> </PIS>\r\n                <COFINS>\r\n                    <COFINSAliq>\r\n                        <CST>01</CST>\r\n                        <vBC>10000000.00</vBC>\r\n                        <pCOFINS>2.00</pCOFINS>\r\n                        <vCOFINS>200000.00</vCOFINS> </COFINSAliq> </COFINS> </imposto> </det>\r\n        <total>\r\n            <ICMSTot>\r\n                <vBC>20000000.00</vBC>\r\n                <vICMS>18.00</vICMS>\r\n                <vBCST>0</vBCST>\r\n                <vST>0</vST>\r\n                <vProd>20000000.00</vProd>\r\n                <vFrete>0</vFrete>\r\n                <vSeg>0</vSeg>\r\n                <vDesc>0</vDesc>\r\n                <vII>0</vII>\r\n                <vIPI>0</vIPI>\r\n                <vPIS>130000.00</vPIS>\r\n                <vCOFINS>400000.00</vCOFINS>\r\n                <vOutro>0</vOutro>\r\n                <vNF>20000000.00</vNF> </ICMSTot> </total>\r\n        <transp>\r\n            <modFrete>0</modFrete>\r\n            <transporta>\r\n                <CNPJ>99171171000191</CNPJ>\r\n                <xNome>Distribuidora de Bebidas Fazenda de SP Ltda.</xNome>\r\n                <IE>171999999119</IE>\r\n                <xEnder>Rua Central 100 - Fundos - Distrito Industrial</xEnder>\r\n                <xMun>SAO PAULO</xMun>\r\n                <UF>SP</UF> </transporta>\r\n            <veicTransp>\r\n                <placa>BXI1717</placa>\r\n                <UF>SP</UF>\r\n                <RNTC>123456789</RNTC> </veicTransp>\r\n            <reboque>\r\n                <placa>BXI1818</placa>\r\n                <UF>SP</UF>\r\n                <RNTC>123456789</RNTC> </reboque>\r\n            <vol>\r\n                <qVol>10000</qVol>\r\n                <esp>CAIXA</esp>\r\n                <marca>LINDOYA</marca>\r\n                <nVol>500</nVol>\r\n                <pesoL>1000000000.000</pesoL>\r\n                <pesoB>1200000000.000</pesoB>\r\n                <lacres>\r\n                    <nLacre>XYZ10231486</nLacre> </lacres> </vol> </transp>\r\n        <infAdic>\r\n            <infAdFisco>Nota Fiscal de exemplo NF-eletronica.com</infAdFisco> </infAdic> </infNFe>\r\n\r\n    <Signature xmlns=\"http://www.w3.org/2000/09/xmldsig#\">\r\n        <SignedInfo>\r\n            <CanonicalizationMethod Algorithm=\"http://www.w3.org/TR/2001/REC-xml-c14n-20010315\"></CanonicalizationMethod>\r\n            <SignatureMethod Algorithm=\"http://www.w3.org/2000/09/xmldsig#rsa-sha1\"></SignatureMethod>\r\n            <Reference URI=\"#NFe35080599999090910270550010000000015180051273\">\r\n                <Transforms>\r\n                    <Transform Algorithm=\"http://www.w3.org/2000/09/xmldsig#enveloped-signature\"></Transform>\r\n                    <Transform Algorithm=\"http://www.w3.org/TR/2001/REC-xml-c14n-20010315\"></Transform> </Transforms>\r\n                <DigestMethod Algorithm=\"http://www.w3.org/2000/09/xmldsig#sha1\"></DigestMethod>\r\n                <DigestValue>xhTSDMH61e9uqe04lnoHT4ZzLSY=</DigestValue> </Reference> </SignedInfo>\r\n        <SignatureValue>Iz5Z3PLQbzZt9jnBtr6xsmHZMOu/3plXG9xxfFjRCQYGnD1rjlhzBGrqt026Ca2VHHM/bHNepi6FuFkAi595GScKVuHREUotzifE2OIjgavvTOrMwbXG7+0LYgkwPFiPCao2S33UpZe7MneaxcmKQGKQZw1fP8fsWmaQ4cczZT8=</SignatureValue>\r\n        <KeyInfo>\r\n            <X509Data>\r\n                <X509Certificate>MIIEuzCCA6OgAwIBAgIDMTMxMA0GCSqGSIb3DQEBBQUAMIGSMQswCQYDVQQGEwJCUjELMAkGA1UECBMCUlMxFTATBgNVBAcTDFBvcnRvIEFsZWdyZTEdMBsGA1UEChMUVGVzdGUgUHJvamV0byBORmUgUlMxHTAbBgNVBAsTFFRlc3RlIFByb2pldG8gTkZlIFJTMSEwHwYDVQQDExhORmUgLSBBQyBJbnRlcm1lZGlhcmlhIDEwHhcNMDgwNDI4MDkwMTAyWhcNMDkwNDMwMjM1OTU5WjCBnjELMAkGA1UECBMCUlMxHTAbBgNVBAsTFFRlc3RlIFByb2pldG8gTkZlIFJTMR0wGwYDVQQKExRUZXN0ZSBQcm9qZXRvIE5GZSBSUzEVMBMGA1UEBxMMUE9SVE8gQUxFR1JFMQswCQYDVQQGEwJCUjEtMCsGA1UEAxMkTkZlIC0gQXNzb2NpYWNhbyBORi1lOjk5OTk5MDkwOTEwMjcwMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDh6RRv0bj4RYX+tDQrZRb5opa77LBVVs+6LphIfSF3TSWPfnKh0+xLlBFdmnB5YGgbbW9Uon6pZQTfaC8jZhRhI5eFRRofY/Ugoeo0NGt6PcIQNZQd6lLQ/ASd1qWwjqJoEa7udriKjy3h351Mf1bng1VxS1urqC3Dn39ZWIEwQIDAQABo4IBjjCCAYowIgYDVR0jAQEABBgwFoAUPT5TqhNWAm+ZpcVsvB7malDBjEQwDwYDVR0TAQH/BAUwAwEBADAPBgNVHQ8BAf8EBQMDAOAAMAwGA1UdIAEBAAQCMAAwgbwGA1UdEQEBAASBsTCBrqA4BgVgTAEDBKAvBC0wNzA4MTk1MTE1MTk0NTMxMDg3MDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDCgHQYFYEwBAwKgFAQSRmVybmFuZG8gQ2FudG8gQWx0oBkGBWBMAQMDoBAEDjk5OTk5MDkwOTEwMjcwoBcGBWBMAQMHoA4EDDAwMDAwMDAwMDAwMIEfZmVybmFuZG8tYWx0QHByb2NlcmdzLnJzLmdvdi5icjAgBgNVHSUBAf8EFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwUwYDVR0fAQEABEkwRzBFoEOgQYY/aHR0cDovL25mZWNlcnRpZmljYWRvLnNlZmF6LnJzLmdvdi5ici9MQ1IvQUNJbnRlcm1lZGlhcmlhMzguY3JsMA0GCSqGSIb3DQEBBQUAA4IBAQCNPpaZ3Byu3/70nObXE8NiM53j1ddIFXsb+v2ghCVd4ffExv3hYc+/a3lfgV8H/WfQsdSCTzS2cHrd4Aasr/eXfclVDmf2hcWz+R7iysOHuT6B6r+DvV3JcMdJJCDdynR5REa+zViMnVZo1G3KuceQ7/y5X3WFNVq4kwHvonJ9oExsWyw8rTwUK5bsjz0A2yEwXkmkJIngnF41sP31+9jCImiqkXcmsesFhxzX7iurAQAQCZOm7iwMWxQKcAjXCZrgSZWRQy6mU224sX3HTArHahmLJ9Iw+WYAua5qBJsiN6PC7v5tfhrEQFpcG39yMnOecxvkkPolDUyBa7d7xwgm</X509Certificate> </X509Data> </KeyInfo> </Signature>\r\n\r\n</NFe> \r\n");
		scrollXml.setViewportView(textVendaXml);

		JLabel lblLinkNf = new JLabel("Link NF");
		lblLinkNf.setHorizontalAlignment(SwingConstants.LEFT);
		lblLinkNf.setBounds(161, 29, 42, 14);
		panelCupomFiscal.add(lblLinkNf);

		textVendaLink = new JTextField();
		textVendaLink.setText("https://www.validador.com.br/?nota=123");
		textVendaLink.setColumns(10);
		textVendaLink.setBounds(199, 26, 164, 20);
		panelCupomFiscal.add(textVendaLink);

		JLabel lblValorTotal = new JLabel("Valor Total");
		lblValorTotal.setHorizontalAlignment(SwingConstants.LEFT);
		lblValorTotal.setBounds(194, 99, 90, 14);
		panelDadosTransacao.add(lblValorTotal);

		textVendaValorTotal = new JTextField();
		textVendaValorTotal.setText("R$ 12,23");
		textVendaValorTotal.setColumns(10);
		textVendaValorTotal.setBounds(294, 96, 86, 20);
		panelDadosTransacao.add(textVendaValorTotal);

		JButton btnNewButton = new JButton("Solicita Aprovação da Transação Pelo OpenTef");
		btnNewButton.setBounds(420, 17, 303, 52);
		panelCaixa.add(btnNewButton);

		JButton btnMenuOperacional = new JButton("Menu Operacional");
		btnMenuOperacional.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {

				String hora = new SimpleDateFormat("HH:mm:ss").format(new Date());
				OpenTefConexao openTefConexao = OpenTefConexao.csLogado;
				int VL_Erro = 0;
				IntByReference VL_Status = new IntByReference();
				String VL_TransacaoID = "";
				String[] VL_Retorno = new String[1];
				int VL_Tempo = Integer.valueOf(textTempo.getText());

				textEventos.setText("");

				if (pointTef == null) {
					textEventos.insert(hora + ", Erro: Inicialize a lib\n", textEventos.getCaretPosition());
					JOptionPane.showMessageDialog(null, "Inicialize a lib", "OpenTef", JOptionPane.WARNING_MESSAGE);
					return;
				}

				VL_Erro = teflib.opentefstatus(pointTef, VL_Status);

				if (VL_Erro != 0) {
					teflib.j_mensagemerro(VL_Erro, VL_Retorno);
					textEventos.insert(hora + ", Erro: " + VL_Erro + " " + VL_Retorno[0] + "\n",
							textEventos.getCaretPosition());
					JOptionPane.showMessageDialog(null, "Erro:" + VL_Erro + " " + VL_Retorno[0], "OpenTef",
							JOptionPane.ERROR_MESSAGE);

					return;

				}

				if (VL_Status.getValue() != openTefConexao.ordinal()) {
					textEventos.insert(hora + ", Erro: Faça o login\n", textEventos.getCaretPosition());
					JOptionPane.showMessageDialog(null, "Faça o login", "OpenTef", JOptionPane.ERROR_MESSAGE);
					return;

				}

				textEventos.insert(hora + " : Início da transação\n", textEventos.getCaretPosition());

				VL_Erro = teflib.j_transacaocreate(pointTef, "00F5", textVendaCaixa.getText(), VL_Retorno, VL_Tempo);
				VL_TransacaoID = VL_Retorno[0];
				VL_Retorno[0] = "";

				if (VL_Erro != 0) {

					teflib.j_mensagemerro(VL_Erro, VL_Retorno);
					textEventos.insert(hora + ", Erro: " + VL_Erro + " " + VL_Retorno[0] + "\n",
							textEventos.getCaretPosition());
					JOptionPane.showMessageDialog(null, "Erro:" + VL_Erro + " " + VL_Retorno[0], "OpenTef",
							JOptionPane.ERROR_MESSAGE);
					return;

				}

				textEventos.insert(hora + " : Transacao em processamento: ID =" + VL_TransacaoID + "\n",
						textEventos.getCaretPosition());

			}
		});

		btnMenuOperacional.setBounds(733, 17, 164, 52);
		panelCaixa.add(btnMenuOperacional);

		JSeparator separator = new JSeparator();
		separator.setBounds(420, 98, 477, 2);
		panelCaixa.add(separator);

		JLabel lblChaveDaTrancao = new JLabel("Chave da Trancação");
		lblChaveDaTrancao.setHorizontalAlignment(SwingConstants.LEFT);
		lblChaveDaTrancao.setBounds(420, 111, 112, 14);
		panelCaixa.add(lblChaveDaTrancao);

		JScrollPane scrollPane = new JScrollPane();
		scrollPane.setBounds(420, 134, 477, 63);
		panelCaixa.add(scrollPane);

		JTextArea textChaveTransacao = new JTextArea();
		scrollPane.setViewportView(textChaveTransacao);
		textChaveTransacao.setLineWrap(true);

		JSeparator separator_1 = new JSeparator();
		separator_1.setBounds(420, 208, 477, 2);
		panelCaixa.add(separator_1);

		JLabel lblEventos = new JLabel("Eventos");
		lblEventos.setHorizontalAlignment(SwingConstants.LEFT);
		lblEventos.setBounds(420, 221, 112, 14);
		panelCaixa.add(lblEventos);

		JScrollPane scrollEventos = new JScrollPane();
		scrollEventos.setBounds(420, 244, 477, 236);
		panelCaixa.add(scrollEventos);

		textEventos.setLineWrap(true);
		scrollEventos.setViewportView(textEventos);

		btnNewButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				String hora = new SimpleDateFormat("HH:mm:ss").format(new Date());
				OpenTefConexao openTefConexao = OpenTefConexao.csLogado;
				int VL_Erro = 0;
				IntByReference VL_Status = new IntByReference();
				String VL_TransacaoID = "";
				String[] VL_Retorno = new String[1];
				int VL_Tempo = Integer.valueOf(textTempo.getText());

				textEventos.setText("");

				if (pointTef == null) {
					textEventos.insert(hora + ", Erro: Inicialize a lib\n", textEventos.getCaretPosition());
					JOptionPane.showMessageDialog(null, "Inicialize a lib", "OpenTef", JOptionPane.WARNING_MESSAGE);
					return;
				}

				VL_Erro = teflib.opentefstatus(pointTef, VL_Status);

				if (VL_Erro != 0) {
					teflib.j_mensagemerro(VL_Erro, VL_Retorno);
					textEventos.insert(hora + ", Erro: " + VL_Erro + " " + VL_Retorno[0] + "\n",
							textEventos.getCaretPosition());
					JOptionPane.showMessageDialog(null, "Erro:" + VL_Erro + " " + VL_Retorno[0], "OpenTef",
							JOptionPane.ERROR_MESSAGE);

					return;

				}

				if (VL_Status.getValue() != openTefConexao.ordinal()) {
					textEventos.insert(hora + ", Erro: Faça o login\n", textEventos.getCaretPosition());
					JOptionPane.showMessageDialog(null, "Faça o login", "OpenTef", JOptionPane.ERROR_MESSAGE);
					return;

				}

				textEventos.insert(hora + " : Início da transação\n", textEventos.getCaretPosition());

				VL_Erro = teflib.j_transacaocreate(pointTef, "000A", textVendaCaixa.getText(), VL_Retorno, VL_Tempo);
				VL_TransacaoID = VL_Retorno[0];
				VL_Retorno[0] = "";

				if (VL_Erro != 0) {

					teflib.j_mensagemerro(VL_Erro, VL_Retorno);
					textEventos.insert(hora + ", Erro: " + VL_Erro + " " + VL_Retorno[0] + "\n",
							textEventos.getCaretPosition());
					JOptionPane.showMessageDialog(null, "Erro:" + VL_Erro + " " + VL_Retorno[0], "OpenTef",
							JOptionPane.ERROR_MESSAGE);
					return;

				}

				textEventos.insert(hora + " : Transacao em processamento: ID =" + VL_TransacaoID + "\n",
						textEventos.getCaretPosition());

			}
		});
	}
}
