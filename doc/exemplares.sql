USE AlunoExemplares
CREATE TABLE Exemplar (
codigo INT NOT NULL IDENTITY(1,1),
nome VARCHAR(200) NOT NULL,
tipo CHAR(1) NOT NULL,
qtdPag INT NOT NULL
PRIMARY KEY(codigo)
)
GO
CREATE TABLE livro (
codigo INT NOT NULL,
isbn CHAR(13) NOT NULL,
edicao INT NOT NULL
PRIMARY KEY(codigo),
FOREIGN KEY(codigo) REFERENCES Exemplar(codigo) ON DELETE CASCADE
)
GO
CREATE TABLE Revista(
codigo INT NOT NULL,
issn CHAR(8) NOT NULL,
PRIMARY KEY(codigo),
FOREIGN KEY(codigo) REFERENCES Exemplar(codigo) ON DELETE CASCADE
)
GO
CREATE PROCEDURE sp_tipoExp
	@doc VARCHAR(13),
	@tipo bit OUTPUT
AS
BEGIN
	IF LEN(@doc) = 8
	BEGIN
		SET @tipo = 0
	END
	ELSE IF LEN(@doc) = 13
	BEGIN
		SET @tipo =  1
	END
	ELSE
	BEGIN
		RAISERROR('ISSN/ISBN inválido',16,1)
		RETURN
	END
END
GO
CREATE PROCEDURE sp_inserirExemplar
	@nome VARCHAR(200),
	@doc VARCHAR(13),
	@qtdPagina int,
	@edicao int,
	@cod int OUTPUT
AS
BEGIN
	DECLARE @docval bit
	exec sp_tipoExp @doc, @docval OUTPUT
	IF(@docval = 1 AND @edicao IS NULL)
	BEGIN
		RAISERROR('Insira a Edição',16,1)
		RETURN
	END
	ELSE 
	BEGIN
		IF(@docval = 1 AND @edicao IS NOT NULL)
		BEGIN
			INSERT INTO exemplar VALUES (@nome, 'L', @qtdPagina)
			SET @cod = SCOPE_IDENTITY()
			INSERT INTO livro VALUES(@cod, @doc, @edicao)
			RETURN @cod
		END
		ELSE
		BEGIN
			INSERT INTO exemplar VALUES(@nome, 'R', @qtdPagina)
			SET @cod = SCOPE_IDENTITY()
			INSERT INTO revista VALUES(@cod, @doc)
			RETURN @cod
		END
	END
END
GO
CREATE PROCEDURE sp_alterarExemplar
	@nome VARCHAR(200),
	@cod INT,
	@qtdPag int,
	@edicao int
AS
BEGIN
	DECLARE @tipo CHAR(1)
	SET @tipo = (SELECT tipo FROM exemplar WHERE codigo = @cod)
	IF (@TIPO IS NULL)
	BEGIN
		RAISERROR('Exemplar não encontrado', 16, 1)
		RETURN
	END

	IF(@TIPO = 'L' AND @edicao IS NULL)
	BEGIN
		RAISERROR('Digite a edicao do livro', 16,1)
		RETURN
	END
	ELSE
	BEGIN
		UPDATE exemplar SET nome = @nome, qtdPag = @qtdPag
		WHERE codigo = @cod
		IF(@TIPO = 'L' AND @edicao IS NOT NULL)
		BEGIN
			UPDATE livro SET edicao = @edicao
			WHERE codigo = @cod
		END
	END
END
GO
CREATE PROCEDURE sp_deletaExemplar
	@cod INT
AS
BEGIN
	DECLARE @tipo CHAR(1)
	SET @tipo = (SELECT tipo FROM exemplar WHERE codigo = @cod)
	IF (@TIPO IS NULL)
	BEGIN
		RAISERROR('Exemplar não encontrado', 16, 1)
		RETURN
	END
	DELETE FROM exemplar WHERE codigo = @cod
END
GO
CREATE VIEW selectGeral
AS
	SELECT ex.codigo, ex.nome, ex.qtdPag, 'Livro' AS tipo, lv.isbn AS ISBN_ISSN, lv.edicao
	FROM exemplar ex, livro lv
	WHERE ex.codigo = lv.codigo
	UNION ALL
	SELECT ex.codigo, ex.nome, ex.qtdPag, 'Revista' AS tipo, rv.issn AS ISBN_ISSN, 0
	FROM exemplar ex, revista rv
	WHERE ex.codigo = rv.codigo
GO
CREATE PROCEDURE sp_Ger_exemplar
	@opc CHAR(1),
	@cod INT,
	@nome VARCHAR(200),
	@doc VARCHAR(13),
	@qtdPagina int,
	@edicao int,
	@saida VARCHAR(200) OUTPUT
AS
BEGIN
	IF (UPPER(@opc) = 'I')
	BEGIN
		DECLARE @codigo INT
		exec sp_inserirExemplar @nome, @doc, @qtdPagina, @edicao, @codigo OUTPUT
		SET @saida = 'Exemplar inserido com sucesso, seu codigo = ' + CAST((@codigo) AS VARCHAR(10))
	END
	ELSE 
	BEGIN
		IF(UPPER(@opc) = 'U')
		BEGIN
			exec sp_alterarExemplar @nome, @cod, @qtdPagina, @edicao
			SET @saida = 'Exemplar alterado com sucesso!'
		END
		ELSE
		BEGIN
			IF(UPPER(@opc) = 'D')
			BEGIN
				exec sp_deletaExemplar @cod
				SET @saida = 'Exemplar deletado com sucesso!'
			END
		END
	END
END
SELECT * FROM Exemplar
SELECT * FROM Revista
SELECT * FROM Livro