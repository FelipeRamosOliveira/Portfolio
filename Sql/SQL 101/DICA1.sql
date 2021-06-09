SELECT * FROM tbcliente;

# SELEÇÕES NUMÉRICAS

SELECT * FROM tbcliente WHERE IDADE = 22;	#igual
SELECT * FROM tbcliente WHERE IDADE > 22;	#maior
SELECT * FROM tbcliente WHERE IDADE < 22;	#menor
SELECT * FROM tbcliente WHERE IDADE <= 22;	#menor igual
SELECT * FROM tbcliente WHERE IDADE <> 22;	#diferente

# SELEÇÕES ALFABÉTICAS

SELECT * FROM tbcliente WHERE NOME >= 'Fernando Cavalcante'; # Nomes que comeccem com 'Fe'
SELECT * FROM tbcliente WHERE NOME <> 'Fernando Cavalcante';

#Obs : Float não 'aceita igual' ou 'diferente'
SELECT * FROM tbproduto WHERE PRECO_LISTA BETWEEN 16.007 AND 16.009;