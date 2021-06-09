 -- SELECIONAR BANCO DE DADOS 
USE vendas_sucos;
-- INSERIR DADOS ALETÓRIOS 
 INSERT INTO PRODUTOS (CODIGO,DESCRITOR,SABOR,TAMANHO,EMBALAGEM,PRECO_LISTA)
     VALUES ('1001001','Sabor dos Alpes 700 ml - Manga','Manga','700 ml','Garrafa',7.50),
			('1001000','Sabor dos Alpes 700 ml - Melão','Melão','700 ml','Garrafa',7.50),
			('1001002','Sabor dos Alpes 700 ml - Graviola','Graviola','700 ml','Garrafa',7.50),
			('1001003','Sabor dos Alpes 700 ml - Tangerina','Tangerina','700 ml','Garrafa',7.50),
			('1001004','Sabor dos Alpes 700 ml - Abacate','Abacate','700 ml','Garrafa',7.50	),
			('1001005','Sabor dos Alpes 700 ml - Açai','Açai','700 ml','Garrafa',7.50),
			('1001006','Sabor dos Alpes 1 Litro - Manga','Manga','1 Litro','Garrafa',7.50),
			('1001007','Sabor dos Alpes 1 Litro - Melão','Melão','1 Litro','Garrafa',7.50),
			('1001008','Sabor dos Alpes 1 Litro - Graviola','Graviola','1 Litro','Garrafa',7.50),
			('1001009','Sabor dos Alpes 1 Litro - Tangerina','Tangerina','1 Litro','Garrafa',7.50),
			('1001010','Sabor dos Alpes 1 Litro - Abacate','Abacate','1 Litro','Garrafa',7.50),
			('1001011','Sabor dos Alpes 1 Litro - Açai','Açai','1 Litro','Garrafa',7.50);
-- EXIBIR 
SELECT * FROM produtos WHERE CODIGO = '1001011'

-- DELETAR 1 REGISTRO 
DELETE FROM PRODUTOS WHERE CODIGO = '1001000' ;

-- DELATAR COM UM CRITÉRIO 
DELETE FROM PRODUTOS WHERE TAMANHO = '1 Litro' AND SUBSTRING(DESCRITOR,1,15) = 'Sabor dos Alpes';

-- DELETAR DADOS QUE ESTÃO EM UMA TEBALE MAS NÃO ESTÃO EM OUTRA 
DELETE FROM PRODUTOS WHERE CODIGO NOT IN ( SELECT CODIGO_DO_PRODUTO FROM SUCOS_VENDAS.TABELA_DE_PRODUTOS);

-- CRIAR UMA  TABELA POR STATEMENT (Send to SQL Editor )
CREATE TABLE `produtos2` (
  `CODIGO` varchar(10) NOT NULL,
  `DESCRITOR` varchar(100) DEFAULT NULL,
  `SABOR` varchar(50) DEFAULT NULL,
  `TAMANHO` varchar(50) DEFAULT NULL,
  `EMBALAGEM` varchar(50) DEFAULT NULL,
  `PRECO_LISTA` float DEFAULT NULL,
  PRIMARY KEY (`CODIGO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- COPIAR DADOS DE UMA TABELA EM OUTRA 
INSERT INTO produtos2 SELECT * FROM produtos;
-- ALTERAR DE FORMA IGUAL 1 VARIÁVEL EM TODOS REGISTROS 
UPDATE produtos2 SET preco_lista = 8;
-- DELETAR TODOS OS REGISTROS DE UMA TABELA 
DELETE FROM produtos2;
