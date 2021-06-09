-- SELECIONAR BANCO DE DADOS 
USE VENDAS_SUCOS;

-- INSERIR 1 DADO  EM 1 TABELA 
INSERT INTO PRODUTOS (CODIGO, DESCRITOR, SABOR, TAMANHO, EMBALAGEM, PRECO_LISTA)
VALUES ('1040107', 'Light - 350 ml - Melância', 'Melância', '350 ml', 'Lata', 4.56);
-- EXIBIR 
SELECT * FROM PRODUTOS;
------------------------------------------------------------------------------------------------------------------------------
-- INSERIR 1 DADO  EM 1 TABELA (COM LABELS)
INSERT INTO PRODUTOS (CODIGO, DESCRITOR, SABOR, TAMANHO, EMBALAGEM, PRECO_LISTA)
VALUES ('1040108', 'Light - 350 ml - Graviola', 'Graviola', '350 ml', 'Lata', 4.00);
-- EXIBIR 
SELECT * FROM PRODUTOS;
------------------------------------------------------------------------------------------------------------------------------
-- INSERIR 1 DADO  EM 1 TABELA (RESPEITANDO A ORDEM DA TABELA)
INSERT INTO PRODUTOS
VALUES ('1040109', 'Light - 350 ml - Açai', 'Açai', '350 ml', 'Lata', 5.60);
-- EXIBIR 
SELECT * FROM PRODUTOS;
-------------------------------------------------------------------------------------------------------------------------------
-- INSERIR 2 DADOS  EM 1 TABELA (RESPEITANDO A ORDEM DA TABELA)
INSERT INTO PRODUTOS
VALUES ('1040110', 'Light - 350 ml - Jaca', 'Jaca', '350 ml', 'Lata', 6.00),
       ('1040111', 'Light - 350 ml - Manga', 'Manga', '350 ml', 'Lata', 3.50);
SELECT * FROM PRODUTOS;
-------------------------------------------------------------------------------------------------------------------------------
