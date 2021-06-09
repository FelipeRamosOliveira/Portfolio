-- FUNÇÃO BASICAS 
CALL OLA_MARILENE();
CALL MOSTRA_NUMERO();
CALL OLA_MARILENE_2();
CALL exibe_variavel();
CALL tipo_de_dados();

-- CALL QUE USA UMA FUNÇÃO INTERNA
CALL agora();

-- CALL MANIPULACAO DO BANCO
CALL manipulacao_dados();

-- CALL COM PARAMETROS 
CALL inclui_novo_produto_parametro('4000001', 'Sabor do Pantanal 1 Litro - Melancia',
'Melancia', '1 Litro', 'PET', 4.76);

-- ERRO (PRODUTO DUPLICADO)
CALL inclui_novo_produto_parametro('4000002', 'Sabor do Pantanal 1 Litro - Melancia',
'Melancia', '1 Litro', 'PET', 4.76);

-- PRPBLEMA RESOLVIDO
SELECT SABOR FROM tabela_de_produtos where CODIGO_DO_PRODUTO='4000001';
CALL acha_sabor('4000001');

-- FUNÇÃO COM IF E ELSE 
CALL cliente_novo_velho ('19290992743');

-- FUNÇÃO COM IF, ELSEIF E ELSE 
Call acha_status_preco ('1000889');

-- FUNÇÃO COM CASE
CALL acha_tipo_sabor('1000889');

-- FUNÇÃO COM CASE (ERRO)
CALL acha_tipo_sabor_erro('1004327');

-- FUNÇÃO COM CASE (ERRO-CORREÇÃO)
CALL acha_tipo_sabor_erro('1004327');

-- EQUIVALENTE AO UNIQUE
select distinct sabor from tabela_de_produtos; 
-- LOOP 
call loop_1(1,10);

-- CURSORES
Call todos_clientes_cursor();

-- CURSOR COM LOOP 
call cursor_looping();

-- CURSOR COM LOOP MULTIPLAC CONSULTAS cursor_looping
call looping_cursor_multiplas_colunas();

-- PERMITIR CRIA RFUNÇÕES 
SET GLOBAL log_bin_trust_function_creators=1;

-- USAR UMA FUNÇÃO 
select f_acha_tipo_sabor ('Laranja');
SELECT NOME_DO_PRODUTO, SABOR, f_acha_tipo_sabor (SABOR) as TIPO FROM tabela_de_produtos;