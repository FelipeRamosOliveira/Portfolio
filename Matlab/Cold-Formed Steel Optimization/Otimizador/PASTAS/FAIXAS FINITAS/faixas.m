% Programa de faixas finitas para perfis formados a frio de se��es abertas
% quaisquer, submetidos a tens�es quaisquer nas extremidades.
%Autor: Jo�o Lazzari
 function [modo_carga_critico,plot_ass,onda,CC]=faixas(coord,elem,mat,L);
%% 1.CRIT�RIOS DE AN�LISE
% CONDI��O DE CONTORNO
CC = 'A-A'; 
%'E-E' engastado-engastado
%'A-A' apoiado-apoiado

% MEIAS-ONDA (QUANTIDADE DE MEIAS-ONDA LONGITUDINAIS)
onda = [1];
%% 2.AN�LISE EM FAIXAS FINITAS (PR�-PROCESSAMENTO DOS DADOS e FORMA��O DAS MATRISES DE RIGIDEZ E SOLVER)
% Forma��o das matrizes de rigidez elastica e geometrica, e calculo das
% cargas cr�ticas e modos cr�ticos com um solver para problema de autovalor
% e Organiza��o dos dados de entrada para processar a an�lise
warning off
[modo_carga_critico,plot_ass] = faixas_finitas(elem,coord,mat,CC,onda,L);

