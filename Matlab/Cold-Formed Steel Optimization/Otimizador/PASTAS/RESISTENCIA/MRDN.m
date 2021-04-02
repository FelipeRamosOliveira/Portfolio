%%  C�LCULO DE RESIST�NCIA � COMPRESS�O CENTRADA (MRD-NBR 14762)
function [Ncrk,LambdaG,LambdaL,LambdaD]=MRDN (plot_ass,coord,elem)
%%  1.PROPRIEDADES
%Propriedades geom�tricas e do material 
global fy E L A
v=0.3;
G =E./(2.*(1+v));
%Se��o transversal
[~,A,~,~,J,~,~,~,~,I11,I22,~,~,~,Cw,x0,y0,r0,~,~] = prop_geom_PFF(coord,elem);
Py=A*fy;

%%  2.RESIST�NCIA � FLAMBAGEM GLOBAL 
[Ncre,~,~,~,~,~,PcrG,LambdaG]=NCRE(L,E,I11,I22,r0,x0,y0,Cw,G,J,A,fy);

%%  3. CLASSIFICAR OS TIPOS DE FLAMBAGEM
[PcrL,PcrD]=CLASSIFICADOR(plot_ass,Py,A,L,Ncre,PcrG);

%%  4.RESIST�NCIA � FLAMBAGEM LOCAL
[Ncrl,LambdaL]=NCRL(Ncre,PcrL);

%%  5.RESIST�NCIA � FLAMBAGEM DISTORCIONAL
[Ncrd,LambdaD]=NCRD(Py,PcrD);

%%  6.RESIST�NCIA CARCTERISTICA

Ncrk=min([Ncre Ncrl Ncrd]);
end
