%%  FUN��O OBJETIVO SUBISTITUTA
function out=OBJETIVO_S(x)
%Variv�is globais de entrada
global cont fy E L Lf t FSU PCONT
%Variv�s globais de saida
global LG LD LL
cont=cont+1;
%%  CHAMAR PREDITOR 
% load('SIMPLIFICADO.mat');
%%  I.TORNAR VETOR DE VARI�VEIS EM PAR�METROS GEOM�TRICOS 
    bf=round(Lf*x(2),1);    %Mesa
    bs=round(bf*x(1),1);    %Enrijecedor de borda
    bw=Lf-2*bf-2*bs;        %Alma
    Q=x(3);                 %�ngulo de abertura
%   O �ngulo s� pde variar em intervalos iguais de 15�
    if Q>75,        Q=90;
    elseif Q>60,    Q=75;
    elseif Q>45,    Q=60;
    elseif Q>30,    Q=45;
    elseif Q>15,    Q=15;
    end     
%Garantia que n�o haver� erro por dimes�es nulas
    if bf==0||bs==0||bw==0
       bf=600;bs=5;bw=500;
    end

    [coord,elem]=para_coord(bw,bf,bf,bs,bs,Q,Q,t);  
%%  II.C�LCULO DE RESIST�NCIA � COMPRESS�O CENTRADA (MRD)
%   PROPRIEDADES
%   Propriedades geom�tricas e do material 
    v=0.3;
    G =E./(2.*(1+v));
%   Se��o transversal
    [~,A,~,~,J,~,~,~,~,I11,I22,~,~,~,Cw,x0,y0,r0,~,~] = prop_geom_PFF(coord,elem);
    Py=A*fy;

%   RESIST�NCIA � FLAMBAGEM GLOBAL
[Ncre,~,~,~,~,~,~,LG]=NCRE(L,E,I11,I22,r0,x0,y0,Cw,G,J,A,fy);
%   RESIST�NCIA � FLAMBAGEM LOCAL
Neta=bf/bw;
kl=6.8-5.8*Neta+9.2*Neta^2-6*Neta^3;
PcrL=kl*(((pi^2*E)/(12*(1-v^2)*(bw/t)^2)))*A;
[Ncrl,LL]=NCRL(Ncre,PcrL);

%   RESIST�NCIA � FLAMBAGEM DISTORCIONAL
X1=[t bf bs bw Py];
PcrD=feval(FSU,X1);
PcrD=feval(PcrD,X1);
[Ncrd,LD]=NCRD(Py,PcrD);

%%RESIST�NCIA CARCTERISTICA
Ncrk=min([Ncre Ncrl Ncrd]);
%% III.RESIST�NCIA
PCONT=Ncrk;
out=Ncrk;
