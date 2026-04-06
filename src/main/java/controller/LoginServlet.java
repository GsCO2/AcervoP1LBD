package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Aluno;
import persistence.AlunoDao;
import persistence.GenericDao;

import java.io.IOException;
/*
 SRP -> Principio da Responsabilidade Única, o 
 Login Servlet lida apenas com a parte da autenticação.
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	    response.sendRedirect("login.jsp");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String email = request.getParameter("email");
		String senha = request.getParameter("senha");
		String erro = "";
		
		try {
			Aluno aLogin = new Aluno();
			aLogin.setEmail(email);
			aLogin.setSenha(senha);
			GenericDao gDao = new GenericDao();
			AlunoDao aDao = new AlunoDao(gDao);
			aLogin = aDao.login(aLogin);
			if (aLogin != null) {
				HttpSession session = request.getSession();
				session.setAttribute("alunoLogado", aLogin);
				response.sendRedirect("acervo");
			} else {
				erro = "Email ou senha inválidos";
				request.setAttribute("erro", erro);
				request.getRequestDispatcher("login.jsp").forward(request, response);
			} 
		} catch (Exception e) {
			erro = e.getMessage();
			request.setAttribute("erro", erro);
			request.getRequestDispatcher("login.jsp").forward(request, response);
		}
	}
}
