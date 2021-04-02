%%  FUNÇÃO OBJETIVO SUBISTITUTA
function out=OBJETIVO_S(x)
%Varivéis globais de entrada
global cont fy E L Lf t FSU PCONT
%Varivés globais de saida
global LG LD LL
cont=cont+1;
%%  CHAMAR PREDITOR 
% load('SIMPLIFICADO.mat');
%%  I.TORNAR VETOR DE VARIÁVEIS EM PARÂMETROS GEOMÉTRICOS 
    bf=round(Lf*x(2),1);    %Mesa
    bs=round(bf*x(1),1);    %Enrijecedor de borda
    bw=Lf-2*bf-2*bs;        %Alma
    Q=x(3);                 %Ãngulo de abertura
%   O ângulo só pde variar em intervalos iguais de 15º
    if Q>75,        Q=90;
    elseif Q>60,    Q=75;
    elseif Q>45,    Q=60;
    elseif Q>30,    Q=45;
    elseif Q>15,    Q=15;
    end     
%Garantia que não haverá erro por dimesões nulas
    if bf==0||bs==0||bw==0
       bf=600;bs=5;bw=500;
    end

    [coord,elem]=para_coord(bw,bf,bf,bs,bs,Q,Q,t);  
%%  II.CÁLCULO DE RESISTÊNCIA À COMPRESSÃO CENTRADA (MRD)
%   PROPRIEDADES
%   Propriedades geométricas e do material 
    v=0.3;
    G =E./(2.*(1+v));
%   Seção transversal
    [~,A,~,~,J,~,~,~,~,I11,I22,~,~,~,Cw,x0,y0,r0,~,~] = prop_geom_PFF(coord,elem);
    Py=A*fy;

%   RESISTÊNCIA À FLAMBAGEM GLOBAL
[Ncre,~,~,~,~,~,~,LG]=NCRE(L,E,I11,I22,r0,x0,y0,Cw,G,J,A,fy);
%   RESISTÊNCIA À FLAMBAGEM LOCAL
Neta=bf/bw;
kl=6.8-5.8*Neta+9.2*Neta^2-6*Neta^3;
PcrL=kl*(((pi^2*E)/(12*(1-v^2)*(bw/t)^2)))*A;
[Ncrl,LL]=NCRL(Ncre,PcrL);

%   RESISTÊNCIA À FLAMBAGEM DISTORCIONAL
X1=[t bf bs bw Py];
PcrD=feval(FSU,X1);
PcrD=feval(PcrD,X1);
[Ncrd,LD]=NCRD(Py,PcrD);

%%RESISTÊNCIA CARCTERISTICA
Ncrk=min([Ncre Ncrl Ncrd]);
%% III.RESISTÊNCIA
PCONT=Ncrk;
out=Ncrk;
