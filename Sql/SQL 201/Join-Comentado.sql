SELECT COUNT(*) FROM tabela_de_clientes;

SELECT CPF, COUNT(*) FROM notas_fiscais GROUP BY CPF;

SELECT  A.CPF, A.NOME, B.CPF FROM tabela_de_clientes A
INNER JOIN notas_fiscais B ON A.CPF = B.CPF GROUP BY B.MATRICULA;

SELECT  distinct A.CPF, A.NOME, B.CPF FROM tabela_de_clientes A
INNER JOIN notas_fiscais B ON A.CPF = B.CPF;

SELECT DISTINCT A.CPF, A.NOME, B.CPF FROM tabela_de_clientes A
LEFT JOIN notas_fiscais B ON A.CPF = B.CPF 
WHERE B.CPF IS NULL;

SELECT DISTINCT A.CPF, A.NOME, B.CPF FROM tabela_de_clientes A
LEFT JOIN notas_fiscais B ON A.CPF = B.CPF
WHERE B.CPF IS NULL AND YEAR(B.DATA_VENDA) = 2015;

SELECT  A.CPF, A.NOME, B.CPF, B.DATA_VENDA FROM tabela_de_clientes A
INNER JOIN notas_fiscais B ON A.CPF = B.CPF GROUP BY B.DATA_VENDA;
