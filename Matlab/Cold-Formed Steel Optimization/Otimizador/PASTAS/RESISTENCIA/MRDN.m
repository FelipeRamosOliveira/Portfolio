%%  CÁLCULO DE RESISTÊNCIA À COMPRESSÃO CENTRADA (MRD-NBR 14762)
function [Ncrk,LambdaG,LambdaL,LambdaD]=MRDN (plot_ass,coord,elem)
%%  1.PROPRIEDADES
%Propriedades geométricas e do material 
global fy E L A
v=0.3;
G =E./(2.*(1+v));
%Seção transversal
[~,A,~,~,J,~,~,~,~,I11,I22,~,~,~,Cw,x0,y0,r0,~,~] = prop_geom_PFF(coord,elem);
Py=A*fy;

%%  2.RESISTÊNCIA À FLAMBAGEM GLOBAL 
[Ncre,~,~,~,~,~,PcrG,LambdaG]=NCRE(L,E,I11,I22,r0,x0,y0,Cw,G,J,A,fy);

%%  3. CLASSIFICAR OS TIPOS DE FLAMBAGEM
[PcrL,PcrD]=CLASSIFICADOR(plot_ass,Py,A,L,Ncre,PcrG);

%%  4.RESISTÊNCIA À FLAMBAGEM LOCAL
[Ncrl,LambdaL]=NCRL(Ncre,PcrL);

%%  5.RESISTÊNCIA À FLAMBAGEM DISTORCIONAL
[Ncrd,LambdaD]=NCRD(Py,PcrD);

%%  6.RESISTÊNCIA CARCTERISTICA

Ncrk=min([Ncre Ncrl Ncrd]);
end
