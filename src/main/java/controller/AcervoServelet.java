package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Exemplar;
import persistence.ExemplarDao;
import persistence.GenericDao;

import java.io.IOException;
import java.util.List;

@WebServlet("/acervo")
public class AcervoServelet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		try {
			GenericDao gDao = new GenericDao();
			ExemplarDao eDao = new ExemplarDao(gDao);

			List<Exemplar> lista = eDao.listar(); 
			//lista.forEach(System.out::println);
			request.setAttribute("exemplaresAcervo", lista);
			
			request.getRequestDispatcher("acervo.jsp").forward(request, response);

		} catch (Exception e) {
			request.setAttribute("erro", e.getMessage());
			request.getRequestDispatcher("acervo.jsp").forward(request, response);
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

	}

}
