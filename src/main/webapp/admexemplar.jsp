<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
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
		<a href="admaluno.jsp" class="link-dark text-decoration-none fs-5">ALUNO</a>
		<a class="link-dark text-decoration-none fs-5"> | </a> <a
			class="link-success text-decoration-none fs-5">EXEMPLAR</a>
	</div>
	<div class="conteiner" align="center">
		<h1>Manutenção de Exemplares</h1>
		<br />
		<form action="admexemplar" method="post">
			<table>
				<tr style="border-bottom: solid white 12px;">
					<td colspan="3"><input type="text" name="codigo" id="codigo"
						placeholder="Codigo(auto gerado)"
						value='<c:out value = "${exemplar.codigo }" />'></td>
					<td><input type="submit" id="botao" name="botao"
						value="Buscar" class="btn btn-primary"></td>
				</tr>
				<tr style="border-bottom: solid white 12px;">
					<td colspan="4"><input type="text" name="doc" id="doc"
						placeholder="ISBN/ISSN(nao alteravel)" maxlength="13"
						value='<c:out value = "${exemplar.doc }" />'></td>
				</tr>
				<tr style="border-bottom: solid white 12px;">
					<td colspan="4"><input type="text" name="nome" id="nome"
						placeholder="Nome" value='<c:out value = "${exemplar.nome }" />'></td>
				</tr>
				<tr style="border-bottom: solid white 12px;">
					<td colspan="4"><input type="number" step="1" min="1"
						name="qtdPag" id="qtdPag" placeholder="Quantidade de Páginas"
						value='<c:out value = "${exemplar.qtdPag }" />'></td>
				</tr>
				<tr id="edc" style="border-bottom: solid white 12px; display: none;">
					<td colspan="4"><input type="number" step="1" min="1"
						name="edicao" id="edicao" placeholder="Edicao"
						value='<c:out value = "${exemplar.edicao }" />'></td>
				</tr>
				<tr style="border-bottom: solid white 12px;">
					<td><input style="margin: 0 2px;" type="submit" id="botao"
						name="botao" value="Inserir" class="btn btn-primary"></td>
					<td><input style="margin: 0 2px;" type="submit" id="botao"
						name="botao" value="Alterar" class="btn btn-primary"></td>
					<td><input style="margin: 0 2px;" type="submit" id="botao"
						name="botao" value="Excluir" class="btn btn-primary"></td>
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
		<c:if test="${not empty exemplares}">
			<table class="table table-secondary table-striped-columns">
				<thead>
					<tr>
						<th>Codigo</th>
						<th>ISBN/ISSN</th>
						<th>Nome</th>
						<th>Qtd Páginas</th>
						<th>Edição</th>
						<th></th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="e" items="${exemplares }">
						<tr>
							<td>${e.codigo }</td>
							<td>${e.doc }</td>
							<td>${e.nome }</td>
							<td>${e.qtdPag }</td>
							<td><c:if test="${fn:length(e.doc) == 13}"> 
									${e.edicao} 
								</c:if>
								<c:if test="${fn:length(e.doc) == 8}"> 
									Não possui
								</c:if></td>
							<td><a
								href="${pageContext.request.contextPath }/admexemplar?acao=editar&codigo=${e.codigo }">EDITAR</a></td>
							<td><a
								href="${pageContext.request.contextPath }/admexemplar?acao=excluir&codigo=${e.codigo }">EXCLUIR</a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</c:if>
	</div>
	<script>
		document.addEventListener("DOMContentLoaded", function() {
			const doc = document.getElementById("doc");
			const edc = document.getElementById("edc");
			function verificar() {
				if (doc.value.trim().length === 13) {
					edc.style.display = "table-row";
					document.getElementById("edicao").disabled = false;
				} else {
					edc.style.display = "none";
					document.getElementById("edicao").disabled = true;
				}
			}

			doc.addEventListener("input", function() {
				let input = doc.value.toUpperCase().replace(/[^0-9X]/g, "");
				if (input.includes("X")) {
					input = input.replace(/X/g, "");
					input = input.substring(0, 7) + "X";
				}

				doc.value = input;
				verificar();
			});

			verificar();
		});
	</script>
</body>
</html>