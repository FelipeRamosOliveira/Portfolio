% Programa de faixas finitas para perfis formados a frio de seções abertas
% quaisquer, submetidos a tensões quaisquer nas extremidades.
%Autor: João Lazzari
 function [modo_carga_critico,plot_ass,onda,CC]=faixas(coord,elem,mat,L);
%% 1.CRITÉRIOS DE ANÁLISE
% CONDIÇÃO DE CONTORNO
CC = 'A-A'; 
%'E-E' engastado-engastado
%'A-A' apoiado-apoiado

% MEIAS-ONDA (QUANTIDADE DE MEIAS-ONDA LONGITUDINAIS)
onda = [1];
%% 2.ANÁLISE EM FAIXAS FINITAS (PRÉ-PROCESSAMENTO DOS DADOS e FORMAÇÃO DAS MATRISES DE RIGIDEZ E SOLVER)
% Formação das matrizes de rigidez elastica e geometrica, e calculo das
% cargas críticas e modos críticos com um solver para problema de autovalor
% e Organização dos dados de entrada para processar a análise
warning off
[modo_carga_critico,plot_ass] = faixas_finitas(elem,coord,mat,CC,onda,L);

