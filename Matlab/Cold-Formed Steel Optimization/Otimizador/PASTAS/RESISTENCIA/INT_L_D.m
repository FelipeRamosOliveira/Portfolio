%% CÁCULO DE RESISTÊNCIA CONSIDERANDO A INTERAÇÃO L/D
%Gustavo Y. Matsubara, Eduardo de M. Batista, Guilherme C.  Salles
function [Ncrk,LambdaL,LambdaD]=INT_L_D (x,plot_ass,coord,elem)
global fy Lf E L
%%  1.PROPRIEDADES
%Propiedades da seção e material 
bf=x(1);
bs=x(2);
bw=Lf-2*bf-2*bs;

v=0.3;
G =E./(2.*(1+v));

%Seção transversal
[~,A,~,~,J,~,~,~,~,I11,I22,~,~,~,Cw,x0,y0,r0,~,~] = prop_geom_PFF(coord,elem);
Py=A.*fy;                    

%%  2.RESISTÊNCIA À FLAMBAGEM GLOBAL 
[Ncre,~,~,~,~,~,PcrG,~]=NCRE(L,E,I11,I22,r0,x0,y0,Cw,G,J,A,fy);
%% 3.CLASSIFICAR OS TIPOS DE FLAMBAGEM
[Local,Dist]=CLASSIFICADOR(plot_ass,Py,A,L,Ncre,PcrG);

%% 4.CÁCULO DE RESISTÊNCIA 
%Esbeltez e razão D/L
LambdaL=(Py./Local).^0.5;
LambdaD=(Py./Dist).^0.5;
LambdaMAX=max(LambdaL,LambdaD);
RDL=LambdaD/LambdaL;

 if bf/bw<0.65
%------------------------------------------------
%Primeiro Par de equações 
%Parâmetro A
if RDL < 0.8,       A=0.15;
elseif RDL<1.1,     A=(-7.79.*RDL.^3)+(22.48.*RDL.^2)+(-21.1.*RDL)+6.62;
else,               A=0.25;
end
%Parâmetro B
if RDL < 0.55,      B=0.80;
elseif RDL<1.05,    B=(-12.86.*RDL.^3)+(27.17.*RDL.^2)+(-17.03.*RDL)+4;
else,               B=1.20;
end
%--------------------------------------------------------------
 elseif bf/bw>=0.65
%--------------------------------------------------------------     
%Segundo par de equações 
%Parâmetro A
if RDL < 0.6,       A=0.15;
elseif RDL<=1.0,    A=(1.89.*RDL.^3)+(-4.09.*RDL.^2)+(3.1.*RDL)-0.65;
else,               A=0.25;
end
%Parâmetro B
if RDL < 0.25,      B=0.80;
elseif RDL<1.20,    B=(-2.28.*RDL.^3)+(3.65.*RDL.^2)+(-0.78.*RDL)+0.8;
else,               B=1.20;
end
%-------------------------------------------------------------- 
end  
%Curva de Winter 
PnDL=(1-(A./LambdaMAX.^B)).*(Py./(LambdaMAX.^B));
%-----------------------------------------------------
Ncrk=PnDL;




