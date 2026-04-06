<%
    String logout = request.getParameter("logout");

    if ("true".equals(logout)) {
        session.invalidate();
    }
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="./css/styles.css">
<title>Acervo FZLBD</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB"
	crossorigin="anonymous">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI"
	crossorigin="anonymous"></script>
</head>
<body>
	<nav class="navbar navbar-expand-lg navbar-cor navbar-dark">
		<div class="container-fluid">
			<a class="navbar-brand navbar-titulocor" href="">Acervo FZLBD</a>
			<button class="navbar-toggler" type="button"
				data-bs-toggle="collapse" data-bs-target="#navbarNav"
				aria-controls="navbarNav" aria-expanded="false"
				aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarNav">
				<ul class="navbar-nav">
					<li class="nav-item"><a class="nav-link active"
						aria-current="page" href="">Inicio</a></li>
				</ul>
			</div>
		</div>
	</nav>

	<div
		class="d-flex justify-content-center align-items-center gap-5 mt-5 flex-wrap">

		<div class="card card-custom shadow-lg rounded-4">
			<img src="./imgs/mnt.png" class="card-img-top">
			<div class="card-body text-center text-white">
				<h5 class="card-title">Administrativo</h5>
				<p class="card-text">Manutenção de alunos e exemplares</p>
				<a href="admaluno.jsp" class="btn btn-light">Acessar</a>
			</div>
		</div>

		<div class="card card-custom shadow-lg rounded-4">
			<img src="./imgs/livro.png" class="card-img-top">
			<div class="card-body text-center text-white">
				<h5 class="card-title">Exemplares</h5>
				<p class="card-text">Visualização de exemplares</p>
				<a href="login.jsp" class="btn btn-light">Acessar</a>
			</div>
		</div>
	</div>
</body>
</html>