
<%
if (session.getAttribute("alunoLogado") == null) {
	response.sendRedirect("login.jsp");
	return;
}
%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Acervo</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB"
	crossorigin="anonymous">
<link rel="stylesheet" href="./css/styles.css">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI"
	crossorigin="anonymous"></script>
</head>
<body>
	<nav class="navbar navbar-expand-lg navbar-cor navbar-dark">
		<div class="container-fluid">
			<a class="navbar-brand navbar-titulocor" href="index.jsp?logout=true">Acervo
				FZLBD</a>
			<button class="navbar-toggler" type="button"
				data-bs-toggle="collapse" data-bs-target="#navbarNav"
				aria-controls="navbarNav" aria-expanded="false"
				aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarNav">
				<ul class="navbar-nav">
					<li class="nav-item"><a class="nav-link active"
						aria-current="page" href="index.jsp?logout=true">Inicio</a></li>
				</ul>
			</div>
			<form action="logout" method="get" class="d-flex">
				<button class="btn btn-outline-light" type="submit">Sair</button>
			</form>
		</div>
	</nav>
	<div class="alert alert-light text-start">
		Bem-vindo, ${alunoLogado.nome}<br /> RA: ${alunoLogado.ra}
	</div>
	<div class="conteiner mt-4 w-75 mx-auto" align="center">
			<table class="table table-secondary table-striped-columns">
				<thead>
					<tr>
						<th>ISBN/ISSN</th>
						<th>Nome</th>
						<th>Quantidade de Páginas</th>
						<th>Edição</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="e" items="${exemplaresAcervo }">
						<tr>
							<td>${e.doc }</td>
							<td>${e.nome }</td>
							<td>${e.qtdPag }</td>
							<td><c:if test="${fn:length(e.doc) == 13}"> 
									${e.edicao} 
								</c:if>
								<c:if test="${fn:length(e.doc) == 8}"> 
									Não Possui
								</c:if>
								</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
	</div>
</body>
</html>