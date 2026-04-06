<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Administrativo</title>
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
	<div class="container mt-3">
		<a class="link-success text-decoration-none fs-5">ALUNO</a> <a
			class="link-dark text-decoration-none fs-5"> | </a> <a
			href="admexemplar.jsp" class="link-dark text-decoration-none fs-5">EXEMPLAR</a>
	</div>
	<div class="conteiner" align="center">
		<h1>Manutenção de Alunos</h1>
		<br />
		<form action="admaluno" method="post">
			<table>
				<tr style="border-bottom: solid white 12px;">
					<td colspan="3"><input type="text" name="cpf" maxlength="11"
						oninput="this.value = this.value.replace(/[^0-9]/g, '')" id="cpf" placeholder="CPF(nao alteravel)"
						value='<c:out value = "${aluno.cpf }" />'></td>
					<td><input type="submit" id="botao" name="botao"
						value="Buscar" class="btn btn-primary"></td>
				</tr>
				<tr style="border-bottom: solid white 12px;">
					<td colspan="4"><input type="text" name="nome" id="nome"
						placeholder="Nome(nao alteravel)" value='<c:out value = "${aluno.nome }" />'></td>
				</tr>
				<tr style="border-bottom: solid white 12px;">
					<td colspan="4"><input type="text" name="senha" id="senha"
						placeholder="Senha(min/max = 8)" value='<c:out value = "${aluno.senha }" />'></td>
				</tr>
				<tr style="border-bottom: solid white 12px;">
					<td colspan="4"><input type="text" name="ra" id="ra"
						placeholder="RA" readonly value='<c:out value = "${aluno.ra }" />'></td>
				</tr>
				<tr style="border-bottom: solid white 12px;">
					<td colspan="4"><input type="text" name="email" id="email"
						placeholder="Email" readonly
						value='<c:out value = "${aluno.email }" />'></td>
				</tr>
				<tr style="border-bottom: solid white 12px;">
					<td><input style="margin: 0 2px;" type="submit" id="botao"
						name="botao" value="Inserir" class="btn btn-primary"></td>
					<td><input style="margin: 0 2px;" type="submit" id="botao"
						name="botao" value="Alterar" class="btn btn-primary"></td>
					<td><input style="margin: 0 2px;" type="submit" id="botao"
						name="botao" value="Listar" class="btn btn-primary"></td>
				</tr>
			</table>
		</form>
	</div>
	<br />
	<div class="conteiner" align="center">
		<c:if test="${not empty saida}">
			<h2 style="color: green;">
				<c:out value="${saida }" />
			</h2>
		</c:if>
	</div>

	<div class="conteiner" align="center">
		<c:if test="${not empty erro}">
			<h2 style="color: red;">
				<c:out value="${erro }" />
			</h2>
		</c:if>
	</div>

	<div class="conteiner mt-4 w-75 mx-auto" align="center">
		<c:if test="${not empty alunos}">
			<table class="table table-secondary table-striped-columns">
				<thead>
					<tr>
						<th>CPF</th>
						<th>Nome</th>
						<th>Senha</th>
						<th>RA</th>
						<th>Email</th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="a" items="${alunos }">
						<tr>
							<td>${a.cpf }</td>
							<td>${a.nome }</td>
							<td>${a.senha }</td>
							<td>${a.ra }</td>
							<td>${a.email }</td>
							<td><a
								href="${pageContext.request.contextPath }/admaluno?acao=editar&cpf=${a.cpf}">EDITAR</a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</c:if>
	</div>
</body>
</html>