create database AlunoExemplares
GO
use AlunoExemplares
GO
CREATE TABLE Aluno (
CPF CHAR(11) UNIQUE NOT NULL,
RA VARCHAR(15) UNIQUE NOT NULL,
Nome VARCHAR(50) NOT NULL,
Email VARCHAR(50) UNIQUE NOT NULL,
Senha VARCHAR(32) NOT NULL
);
GO
-- ////// VALIDACOES E GERACAO DE EMAIL E RA

CREATE PROCEDURE sp_validaCPF
@CPF VARCHAR(50),
@cpfvalido BIT OUTPUT
AS
BEGIN
	DECLARE @valido_cpfRepet BIT,
	@soma int,
	@digito1 int,
	@digito2 int,
	@cont int
	SET @soma = 0
	SET @cont =  1

	IF LEN(@CPF) <> 11 
	BEGIN
		SET @cpfvalido = 0
	END
	ELSE
	BEGIN
		IF (@cpf = '00000000000' OR @cpf = '11111111111' 
		OR @cpf = '22222222222' OR @cpf = '33333333333' 
		OR @cpf = '44444444444' OR @cpf = '55555555555' 
		OR @cpf = '66666666666' OR @cpf = '77777777777' 
		OR @cpf = '88888888888' OR @cpf = '99999999999')
		BEGIN
			SET @cpfvalido = 0
		END
		ELSE
		BEGIN
			WHILE (@cont < 10)
			BEGIN
				SET @soma = @soma + (CAST(SUBSTRING(@cpf,@cont,1) as INT) * (11 - @cont))
				SET  @cont = @cont + 1
			END
			IF (@soma % 11 < 2)
			BEGIN
				SET @digito1 = 0
			END
			ELSE
			BEGIN 
				SET @digito1 = 11 - @soma % 11
			END
			IF (@digito1 <> CAST(SUBSTRING(@cpf,10,1) AS INT))
			BEGIN
				SET @cpfvalido = 0
			END
			ELSE 
			BEGIN
				SET @soma = 0
				SET @cont = 1
	
				WHILE (@cont < 11)
				BEGIN
					SET @soma = @soma + (CAST(SUBSTRING(@cpf,@cont,1) as INT) * (12 - @cont))
					SET  @cont = @cont + 1
				END
				IF (@soma % 11 < 2)
				BEGIN
					SET @digito2 = 0
				END
				ELSE 
				BEGIN
					SET @digito2 = 11 - @soma % 11
				END

				IF (@digito2 = CAST(SUBSTRING(@cpf,11,1) AS INT))
				BEGIN
					SET @cpfvalido = 1
				END
				ELSE 
				BEGIN
					SET @cpfvalido  = 0
				END
			END
		END
	END
END
-- ////// -- 
GO
CREATE PROCEDURE sp_verificaAluno
@CPF VARCHAR(50),
@alunoexiste BIT OUTPUT
AS
BEGIN
	DECLARE @valor INT
	SELECT @valor = COUNT(*) FROM Aluno WHERE CPF = @CPF
	IF @valor > 0
		SET @alunoexiste = 1;
	ELSE
		SET @alunoexiste = 0
END
-- ////// -- 
GO
CREATE OR ALTER PROCEDURE sp_gerarEmail
@Nome VARCHAR(100),
@Email VARCHAR(50) OUTPUT
AS
BEGIN
	SET @Nome = TRIM(@Nome)
	DECLARE @primeiro VARCHAR(25)
	DECLARE @ultimo VARCHAR(25)
	DECLARE @emailbase VARCHAR(50)
	DECLARE @valor INT

	IF CHARINDEX(' ', @Nome) = 0
	BEGIN
		SET @emailbase = LOWER(@Nome)
		SET @valor = (SELECT count(*)  FROM Aluno WHERE Email LIKE @emailbase + '%')
        IF @valor >= 1
            SET @Email = @emailbase + CAST(@valor AS VARCHAR)
        ELSE
            SET @Email = @emailbase
        RETURN
	END

	SET @primeiro = TRIM(LEFT(@Nome, CHARINDEX(' ', @Nome) - 1))
	SET @ultimo = TRIM(RIGHT(@Nome, CHARINDEX(' ', REVERSE(@Nome)) - 1))
	SET @emailbase = LOWER(@primeiro + '.' + @ultimo);

	SET @valor = (SELECT count(*)  FROM Aluno WHERE Email LIKE @emailbase + '%')
	IF @valor >= 1
		SET @Email = @emailbase + CAST(@valor AS VARCHAR)
	ELSE
		SET @Email = @emailbase
END
-- ////// -- 

GO
CREATE PROCEDURE sp_gerarRA
@RA VARCHAR(15) OUTPUT
AS
BEGIN
	DECLARE @Ano VARCHAR(2)
	DECLARE @Semestre VARCHAR(1)
	DECLARE @RAbase VARCHAR(10)
	DECLARE @digito VARCHAR(1)

	SET @Ano = SUBSTRING(CAST(YEAR(GETDATE()) as varchar), 3, 2)
	if MONTH(GETDATE()) <= 6
		set @Semestre = 1
	else
		set @Semestre = 2
	SET @RAbase = '222' + @Ano + @Semestre + FORMAT(CAST(RAND() * 1000 AS INT), '000')
	DECLARE @soma INT = 0
	DECLARE @i INT = 1
	WHILE @i < LEN(@RAbase)
	BEGIN
		set @soma = @soma + CAST(SUBSTRING(@RAbase, @i, 1) as int)
		set @i = @i + 1
	end
	SET @digito = @soma / 4
	IF @digito >= 10 
		SET @digito = 0
	SET @RA = @RAbase + CAST(@digito as varchar)

END
-- ////// -- 

GO
CREATE PROCEDURE sp_validaSenha
	@Senha VARCHAR(20),
	@Valida BIT OUTPUT
AS
BEGIN
	set @Valida = 0
	IF LEN (@Senha) = 8 AND @Senha LIKE '%[0-9]%'
	set @Valida = 1
END
GO

-- /////// --

-- procedures seguindo o principio SRP, com cada procedure seguindo uma responsabilidade unica
-- PROCEDURES CRUD
CREATE PROCEDURE sp_inserirAluno
	@Nome VARCHAR(50),
	@CPF CHAR(11),
	@Senha VARCHAR(20)
AS 
BEGIN
	DECLARE @cpfvalido BIT, @existe BIT, @SenhaValida BIT
	DECLARE @EmailGerado VARCHAR(50), @RAGerado VARCHAR(15)
	IF @Nome IS NULL OR TRIM(@Nome) = ''
	BEGIN
		RAISERROR('Preencha o nome', 16, 1)
		RETURN
	END
	EXEC sp_validaCPF @CPF, @cpfvalido OUTPUT;
	IF @cpfvalido = 0
	BEGIN
		RAISERROR('CPF Invalido!', 16, 1) 
		RETURN
	END

	EXEC sp_verificaAluno @CPF, @existe OUTPUT
	IF @existe = 1
	BEGIN 
		RAISERROR('CPF já existente no sistema', 16, 1) 
		RETURN
	END

	EXEC sp_gerarEmail @Nome, @EmailGerado OUTPUT
	EXEC sp_gerarRA @RA = @RAGerado OUTPUT


	EXEC sp_validaSenha @Senha, @Valida = @SenhaValida OUTPUT
	IF @SenhaValida = 0
	BEGIN
		RAISERROR('Senha inválida!', 16, 1)
		RETURN
	END

INSERT INTO Aluno (Nome, CPF, Email, RA, Senha)
VALUES(@Nome, @CPF, @EmailGerado, @RAGerado, @Senha)
END
GO

CREATE PROCEDURE sp_atualizarAluno
	@CPF CHAR(11),
	@Senha VARCHAR(20),
	@null bit OUTPUT
AS
BEGIN
	DECLARE @SenhaValida BIT
    EXEC sp_validaSenha @Senha, @SenhaValida OUTPUT
    IF @Senha IS NULL OR @SenhaValida = 0
    BEGIN
        SET @null = 1
    END
	ELSE
	BEGIN
		UPDATE Aluno
		SET Senha = @Senha
		WHERE CPF = @CPF
		SET @null = 0 
	END
END
GO

-- MENU
CREATE OR ALTER PROCEDURE sp_Ger_aluno
	@opcao CHAR(1),
	@Nome VARCHAR(50) = NULL,
	@CPF CHAR(11),
	@Senha VARCHAR(32) = NULL,
	@saida VARCHAR(200) OUTPUT
AS
BEGIN
	IF @opcao = 'I' or @opcao = 'i'
	BEGIN
		exec sp_inserirAluno @Nome, @CPF, @Senha
		set @saida = 'Aluno cadastrado com sucesso!'
	END
	ELSE IF @opcao = 'U' or @opcao = 'u'
	BEGIN
		DECLARE @existe CHAR(11)
		SELECT @existe = cpf FROM aluno
		WHERE cpf = @cpf
		IF @existe IS NULL
		BEGIN
			RAISERROR('CPF não encontrado',16,1)
		END
		ELSE
		BEGIN
			DECLARE @mudou BIT
			EXEC sp_atualizarAluno @CPF, @Senha, @mudou OUTPUT
			IF @mudou = 1
			BEGIN
				RAISERROR('Senha Inválida',16,1)
			END
			ELSE
			BEGIN
				SET @saida = 'Senha alterada com sucesso!'
			END
		END
	END
	ELSE
	BEGIN
		RAISERROR('Opcão invalida', 16, 1)
		RETURN
	END
END




