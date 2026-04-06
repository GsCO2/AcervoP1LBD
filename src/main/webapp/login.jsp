<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login</title>
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
			<a class="navbar-brand navbar-titulocor" href="index.jsp">Acervo
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
						aria-current="page" href="index.jsp">Inicio</a></li>
				</ul>
			</div>
		</div>
	</nav>
	<div class="conteiner" align="center">
		<h1>Realize o Login</h1>
		<br />
		<form action="login" method="post">
			<table>
				<tr style="border-bottom: solid white 12px;">
					<td colspan="4"><input type="text" name="email" id="email"
						placeholder="Usuario"></td>
				</tr>
				<tr style="border-bottom: solid white 12px;">
					<td colspan="4"><input type="password" name="senha" id="senha"
						placeholder="Senha"></td>
				</tr>
				<tr style="border-bottom: solid white 12px;">
					<td colspan="4" class="text-center"><input type="submit"
						id="botao" name="botao" value="Login" class="btn btn-primary">
					</td>
				</tr>
			</table>
		</form>
	</div>
	<br />
	<div class="conteiner" align="center">
		<c:if test="${not empty erro}">
			<h2 style="color: red;">
				<c:out value="${erro }" />
			</h2>
		</c:if>
	</div>
</body>
</html>