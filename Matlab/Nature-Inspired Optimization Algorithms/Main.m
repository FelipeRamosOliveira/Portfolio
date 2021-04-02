%% COMPARATIVO DE OTIMIZADORES HEURISTICOS TRADICIONAIS
%Objetivo desse progrma é avaliar o desempenho de quatro otimizadores
%heuritscos diferentes  em funções do CEC 2014.Os otimizadores são eles:
%AG-DE,DE,PSO,ABC
%Autor:Felpe R.Oliveira
clc;clear;close all;                %Limpar dados pré armazenados 
%%  I.PRÉ-PROCESSAMNETO

%   1.Montar a bibliteca do CEC2014 e C++ 
%   mex cec14_func.cpp -DWINDOWS       %Montar bibliteca de funções 
    FOB=str2func('cec14_func'); %Definir FOB

%   2.Chamar pastas auxiliares
    wpath=what;
    currentlocation=wpath.path;
    addpath([currentlocation]);
    addpath([currentlocation,'\AG-DE']);
    addpath([currentlocation,'\DE']);
    addpath([currentlocation,'\PSO']);
    addpath([currentlocation,'\ABC']);
    addpath([currentlocation,'\FIREFLY']);
    addpath([currentlocation,'\POS-PROCESSAMNETO']);
 
%%  II.Definições do problemas
global MaxAva
Rodadas=51;             % N° de rodadas 
FUNFIT=[1 2 6 7 9 14];  % Funções avalidas
%%  II.Chamar OTIMIZADORES 
 global contador
 for D=[10 30]          %Loop nas Dimensões  
 for NFUN=[FUNFIT]      %Loop nas funções
 for rodada=1:Rodadas   %Loop nas rodadas
MaxAva=10^4*D;          
%%  AG-DE
%Zerar contador para cada otimizador
    contador=0;
%População externa elite
    [popDe]=DEAG(D,FOB,NFUN);   
    PopEliteDE=popDe(1:5);
%Algoritimo genético
    [ErroAG]=AG(D,FOB,PopEliteDE,NFUN);
    ErroRodadasAG(rodada,:)=[ErroAG];
    disp(['AG|FOB: ' num2str(contador) '-D' num2str(D) '-FUN' num2str(NFUN)])
    disp(['--------------------------------------------------------------_'])
%%  DE
%Zerar contador para cada otimizador
    contador=0;
%
    [ErroDE]=DE(D,FOB,NFUN);    
    ErroRodadasDE(rodada,:)=[ErroDE];  
    disp(['DE|FOB: ' num2str(contador) '-D' num2str(D) '-FUN' num2str(NFUN)])
    disp(['--------------------------------------------------------------_'])
%%  PSO
%Zerar contador para cada otimizador
    contador=0;
%
    [ErroPSO]=PSO(D,FOB,NFUN);    
    ErroRodadasPSO(rodada,:)=[ErroPSO];
    disp(['PSO|FOB: ' num2str(contador) '-D' num2str(D) '-FUN' num2str(NFUN)])
    disp(['--------------------------------------------------------------_'])
%%  ABC
%Zerar contador para cada otimizador
    contador=0;
%
    [ErroABC]=ABC(D,FOB,NFUN);    
    ErroRodadasABC(rodada,:)=[ErroABC];
    disp(['ABC|FOB: ' num2str(contador) '-D' num2str(D) '-FUN' num2str(NFUN)])
    disp(['--------------------------------------------------------------_'])    
%%  VAGA-LUMES
%Zerar contador para cada otimizador
    contador=0;
%
    [ErroFA]=FA(D,FOB,NFUN);   
    ErroRodadasFA(rodada,:)=[ErroABC];
    disp(['FA|FOB: ' num2str(contador) '-D' num2str(D) '-FUN' num2str(NFUN)])          
    disp(['--------------------------------------------------------------_'])
 end
%%  III.Montar tabelas de resultados
% %AG-DE
    ID=1;
    Tabelas (NFUN,D,ErroRodadasAG,ID)
% %DE
    ID=2;
    Tabelas (NFUN,D,ErroRodadasDE,ID)
%PSO
    ID=3;
    Tabelas (NFUN,D,ErroRodadasPSO,ID)
%ABC
    ID=4;
    Tabelas (NFUN,D,ErroRodadasABC,ID)
%VAGA-LUMES
    ID=5;
    Tabelas (NFUN,D,ErroRodadasFA,ID)    
 end
 end             