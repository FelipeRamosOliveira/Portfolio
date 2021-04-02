%% CONTROLE DE RESTRIÇÕES PELO METÓDO DA PENALIDADE
function [P]= PENALIDADE(x)
global Lf LD LL PCONT
%   Definir constante de penalidade
    Constante=10^3;
%%  I.TORNAR VETOR DE VARIÁVEIS EM PARÂMETROS GEOMÉTRICOS 
    bf=round(Lf*x(2),1);    %Mesa
    bs=round(bf*x(1),1);    %Enrijecedor de borda
    bw=Lf-2*bf-2*bs;        %Alma
    Q=x(3);                 %Ãngulo de abertura

%%   II.PARÂMETROS INDIRETOS  
    Neta=bf/bw;
    Mi=bs/bw;
    Beta=bs/bf;
    Lambda_Max=max([LD LL]);
%%  III.Inequações
%   Restrições de fabricação
    
    c(1)=0;
    if bw>400 || bw<100
    c(1)=abs(Lf-bw)*Constante;
    end
    
    c(2)=0;
    if bf>400 || bf<30
    c(2)=abs(Lf-bf)*Constante;
    end
    
    c(3)=0;   
    if bs>40 || bs<10
    c(3)=abs(Lf-bs)*Constante;
    end
    
    c(3)=0;   
    if bs>40 || bs<10
    c(3)=abs(Lf-bs)*Constante;
    end
    
    c(4)=0;
    if mod(Q,15)>0
    c(4)=abs(90-Q)*Constante/50;
    end    
    
%   Restrições normativas e logicas 

    c(5)=0;
if Neta>1 || Neta <0.3
    c(5)=Neta*Lf*Constante;
end

    c(6)=0;
if  Mi>0.4 ||Mi<0.1
    c(6)=Mi*Lf^2*Constante;
end

    c(7)=0;
if  Beta>0.7 ||Beta<0.2
    c(7)=Beta*Lf*Constante;
end

    c(8)=0;   
if Lambda_Max>2.5
    c(8)=abs(Lambda_Max-2.5)*Constante;
end   

    c(9)=0;   
if PCONT>10^6
    c(8)=10^10;
end   

%% CALCULATE PENALTY
P=abs(sum(c));
P=-P;