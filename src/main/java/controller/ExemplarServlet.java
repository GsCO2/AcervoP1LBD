package controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Exemplar;
import model.Livro;
import model.Revista;
import persistence.ExemplarDao;
import persistence.GenericDao;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
/*
SRP -> Principio da Responsabilidade Única, o 
Exemplar Servlet lida apenas com a parte dos exemplares.
*/
@WebServlet("/admexemplar")
public class ExemplarServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String acao = request.getParameter("acao");
		String saida = "";
		String codigo = request.getParameter("codigo");
		Exemplar exemplar = null;
		String erro = "";
		List<Exemplar> exemplares = new ArrayList<>();
		try {
			if (acao != null) {
				GenericDao gDao = new GenericDao();
				ExemplarDao eDao = new ExemplarDao(gDao);
				Livro busc = new Livro();
				busc.setCodigo(Integer.parseInt(codigo));
				if (acao.equalsIgnoreCase("excluir")) {
					saida = eDao.excluir(busc);
					exemplares = eDao.listar();
					exemplar = null;
				} else {
					exemplar = eDao.buscar(busc);
					exemplares = null;
				}
			}
		} catch (SQLException | ClassNotFoundException e) {
			erro = e.getMessage();
		} finally {
			request.setAttribute("saida", saida);
			request.setAttribute("erro", erro);
			request.setAttribute("exemplar", exemplar);
			request.setAttribute("exemplares", exemplares);
			RequestDispatcher dispatcher = request.getRequestDispatcher("admexemplar.jsp");
			dispatcher.forward(request, response);
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		Exemplar exemplar = null;
		List<Exemplar> exemplares = new ArrayList<>();
		String erro = "";
		String saida = "";
		String cmd = "";
		try {
			String codigo = request.getParameter("codigo");
			String doc = request.getParameter("doc");
			String nome = request.getParameter("nome");
			String qtdPagSt = request.getParameter("qtdPag");
			String edicaoSt = request.getParameter("edicao");
			cmd = request.getParameter("botao");
			GenericDao gDao = new GenericDao();
			ExemplarDao eDao = new ExemplarDao(gDao);
			if (cmd.equalsIgnoreCase("Inserir") || cmd.equalsIgnoreCase("Alterar")) {
				if(doc.trim().length() == 8) {
					edicaoSt = "0";
				}
				int qtdPag = Integer.parseInt(qtdPagSt);
				if (doc != null && doc.length() == 13) {
					Livro livro = new Livro();
					livro.setISBN(doc);
					livro.setEdicao(Integer.parseInt(edicaoSt));
					exemplar = livro;
				} else if (doc != null && doc.length() == 8) {
					Revista revista = new Revista();
					revista.setISSN(doc);
					exemplar = revista;
				} else {
					erro = "ISBN/ISSN inválido.";
				}
				if (exemplar != null) {
					exemplar.setNome(nome);
					exemplar.setQtdPag(qtdPag);
					if (cmd.equalsIgnoreCase("Inserir")) {
						saida = eDao.inserir(exemplar);
					} else {
						exemplar.setCodigo(Integer.parseInt(codigo));
						saida = eDao.alterar(exemplar);
					}
				}
			}

			if (cmd.equalsIgnoreCase("Buscar")) {
				Exemplar busca = new Livro();
				busca.setCodigo(Integer.parseInt(codigo));
				exemplar = eDao.buscar(busca);
			}

			if (cmd.equalsIgnoreCase("Excluir")) {
				Exemplar del = new Livro();
				del.setCodigo(Integer.parseInt(codigo));
				saida = eDao.excluir(del);
			}

			if (cmd.equalsIgnoreCase("Listar")) {
				exemplares = eDao.listar();
			}

		} catch (SQLException | ClassNotFoundException | NumberFormatException e) {
			saida = "";
			erro = e.getMessage();
			if (erro.contains("input string") || erro.contains("null")) {
				erro = "Preencha os campos";
			}
		} finally {
			if (!cmd.equalsIgnoreCase("Buscar")) {
				exemplar = null;
			}
			if (!cmd.equalsIgnoreCase("Listar")) {
				exemplares = null;
			}
			request.setAttribute("erro", erro);
			request.setAttribute("saida", saida);
			request.setAttribute("exemplar", exemplar);
			request.setAttribute("exemplares", exemplares);
			RequestDispatcher dispatcher = request.getRequestDispatcher("admexemplar.jsp");
			dispatcher.forward(request, response);
		}
	}
}
