-- EXERC�CIO

-- CRIAR UMA TABELA DE PEDIDOS E UMA DE ESTOQUE
-- NA TABELA DE PEDIDOS EU VOU RECEBER O
-- ITEM E QUANTIDADE VENDIDA
-- NO MESMO PROCESSO EU DEVO ATUALIZAR A TABELA DE ESTOQUE
-- VOC� DEVE TER UMA DATA PARA O PEDIDO E UMA PARA A ULTIMA
-- ATUALIZA��O DO ITEM NO ESTOQUE
CREATE DATABASE VENDAS;

GO

USE VENDAS;

GO

CREATE TABLE ESTOQUE (
	IDITEM INT IDENTITY(1, 1) NOT NULL CONSTRAINT PK_ESTOQUE PRIMARY KEY,
	ITEM VARCHAR(250),
	QTDE INT,
	DATAATUALIZACAO DATETIME
)

GO

CREATE TABLE PEDIDOS (
	IDPEDIDOS INT IDENTITY(1, 1) NOT NULL CONSTRAINT PK_PEDIDOS PRIMARY KEY,
	IDITEM INT,
	DATAPEDIDO DATETIME,
	QTDEVENDIDA INT
	CONSTRAINT FK_PEDIDOS_ESTOQUE FOREIGN KEY (IDITEM) REFERENCES ESTOQUE (IDITEM)
)

GO

INSERT ESTOQUE (ITEM, QTDE, DATAATUALIZACAO) VALUES
('ARROZ', 50, GETDATE()),
('FEIJ�O', 30, GETDATE()),
('MACARR�O', 10, GETDATE())

--UPDATE ESTOQUE SET QTDE = 30 WHERE IDITEM = 1

GO

/*DECLARE @PK INT
SET @PK = (SELECT @@IDENTITY)

SELECT @PK AS ID*/

CREATE PROCEDURE procRealizaPedido
@IDESTOQUE INT, @QTDE INT
AS
BEGIN
	DECLARE @QTDEDISPONIVEL INT
	SET @QTDEDISPONIVEL = (SELECT QTDE FROM ESTOQUE WHERE IDITEM = @IDESTOQUE);

	IF (@QTDEDISPONIVEL >= @QTDE) BEGIN
		INSERT PEDIDOS (IDITEM, DATAPEDIDO, QTDEVENDIDA) VALUES (@IDESTOQUE, GETDATE(), @QTDE);
		UPDATE ESTOQUE SET QTDE = QTDE - @QTDE, DATAATUALIZACAO = GETDATE() WHERE IDITEM = @IDESTOQUE;
			END
	ELSE BEGIN
		DECLARE @NOMEITEM VARCHAR(250);
		SET @NOMEITEM = (SELECT ITEM FROM ESTOQUE WHERE IDITEM = @IDESTOQUE);
		PRINT 'SEM ESTOQUE DISPON�VEL PARA: ' + @NOMEITEM;
	END

END;

GO

EXEC procRealizaPedido 1, 20;
EXEC procRealizaPedido 3, 20;

GO

SELECT * FROM ESTOQUE;
SELECT * FROM PEDIDOS;

--DELETE FROM PEDIDOS WHERE IDPEDIDOS IN (3, 4, 5);
