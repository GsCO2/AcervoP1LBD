package controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Aluno;
import persistence.AlunoDao;
import persistence.GenericDao;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
/*
SRP -> Principio da Responsabilidade Única, o 
Exemplar Servlet lida apenas com a parte do aluno.
*/
@WebServlet("/admaluno")
public class AlunoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String acao = request.getParameter("acao");
		String cpf = request.getParameter("cpf");
		Aluno a = new Aluno();
		String erro = "";
		List<Aluno> alunos = new ArrayList<>();
		try {
			if (acao != null) {
				a.setCpf(cpf);
				GenericDao gDao = new GenericDao();
				AlunoDao aDao = new AlunoDao(gDao);
				a = aDao.buscar(a);
				alunos = null;
			}
		} catch (SQLException | ClassNotFoundException e) {
			erro = e.getMessage();
		} finally {
			request.setAttribute("erro", erro);
			request.setAttribute("aluno", a);
			request.setAttribute("alunos", alunos);
			RequestDispatcher dispatcher = request.getRequestDispatcher("admaluno.jsp");
			dispatcher.forward(request, response);
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		Aluno a = new Aluno();
		List<Aluno> alunos = new ArrayList<>();
		String erro = "";
		String saida = "";
		String cmd = "";
		try {
			String cpf = request.getParameter("cpf");
			String nome = request.getParameter("nome");
			String senha = request.getParameter("senha");
			cmd = request.getParameter("botao");
			if (!cmd.equalsIgnoreCase("Listar")) {
				a.setCpf(cpf);
			}
			GenericDao gDao = new GenericDao();
			AlunoDao aDao = new AlunoDao(gDao);
			if (cmd.equalsIgnoreCase("Inserir")) {
				a.setNome(nome);
				a.setSenha(senha);
				saida = aDao.inserir(a);
			}
			if (cmd.equalsIgnoreCase("Alterar")) {
				a.setSenha(senha);
				saida = aDao.alterar(a);
			}
			if (cmd.equalsIgnoreCase("Buscar")) {
				a = aDao.buscar(a);
			}
			if (cmd.equalsIgnoreCase("Listar")) {
				alunos = aDao.listar();
			}
		} catch (SQLException | ClassNotFoundException | NumberFormatException e) {
			saida = "";
			erro = e.getMessage();
			if (erro.contains("input string") || erro.contains("null")) {
				erro = "Preencha os campos";
			}
		} finally {
			if (!cmd.equalsIgnoreCase("Buscar")) {
				a = null;
			}
			if (!cmd.equalsIgnoreCase("Listar")) {
				alunos = null;
			}
			request.setAttribute("erro", erro);
			request.setAttribute("saida", saida);
			request.setAttribute("aluno", a);
			request.setAttribute("alunos", alunos);
			RequestDispatcher dispatcher = request.getRequestDispatcher("admaluno.jsp");
			dispatcher.forward(request, response);
		}
	}

}
