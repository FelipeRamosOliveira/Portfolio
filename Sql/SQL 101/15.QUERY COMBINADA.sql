
SELECT * FROM tbproduto;

SELECT * FROM tbproduto WHERE PRECO_LISTA BETWEEN 16.007 AND 16.009;
SELECT * FROM tbproduto WHERE PRECO_LISTA >= 16.007;
SELECT * FROM tbproduto WHERE PRECO_LISTA <= 16.009;

SELECT * FROM tbproduto WHERE PRECO_LISTA >= 16.007 AND PRECO_LISTA <= 16.009;

SELECT * FROM tbcliente;

SELECT * FROM tbcliente WHERE IDADE >= 18 AND IDADE <= 22;

SELECT * FROM tbcliente WHERE IDADE >= 18 AND IDADE <= 22 AND SEXO = 'M';

SELECT * FROM tbcliente WHERE cidade = 'Rio de Janeiro' OR BAIRRO = 'Jardins';

SELECT * FROM tbcliente WHERE (IDADE >= 18 AND IDADE <= 22 AND SEXO = 'M')
 OR (cidade = 'Rio de Janeiro' OR BAIRRO = 'Jardins');

