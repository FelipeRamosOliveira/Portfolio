function [Mcrk]=MRDM (plot_ass,coord,elem)
%% C�LCULO DE RESIST�NCIA � FLEX�O SIMPLES (MRD)
%Propriedades geom�tricas e do material 
global fy E L
%% 1.PROPRIEDADES
%Geometricas
[b,A,xg,yg,J,Ixg,Iyg,Ixyg,teta,I11,I22,xc,yc,wc,Cw,x0,y0,r0,WxC,WyC] = prop_geom_PFF(coord,elem); %JO�O 

%Material
v=0.3;
G =E./(2.*(1+v));   %kN/mm2

%Estabelecer a curva de assinatura
Assinatura=plot_ass(1,:); 

%% 2.RESIST�NCIA � FLAMBAGEM GLOBAL 
%(COMPRES�O)
[Ncre,Nex,Ney,Nez,Nexz,Neyz,Ne]=NCRE(L,E,I11,I22,r0,x0,y0,Cw,G,J,A,fy);

%(FLEX�O SIMPLES)
[Mcre,Me]=MCRE(Ney,Nez,WxC,fy,r0);

%% 3. CLASSIFICAR OS TIPOS DE FLAMBAGEM
%Vetor momentos cr�tcos
Mcr=Assinatura;
%Classificador n�o elgante

%
Minimos = [islocalmin(Assinatura).*Assinatura]';
Minimos =[nonzeros(Minimos)];
%
if isempty(Minimos)
Ml=Me;
Md=Me;
else
Ml=Minimos(1);
end
%
if length(Minimos)>=2
    Md=min(Minimos(2:length(Minimos)));
else
    Md=5.*Ml;
end
%
%% 4.RESIST�NCIA � FLAMBAGEM LOCAL
[Mcrl]=MCRL(Ml,Mcre); 
%
%% 5.RESIST�NCIA � FLAMBAGEM DISTORCIONAL
[Mcrd]=MCRD(WxC,fy,Md); 

%% 6.RESIST�NCIA CARCTERISTICA
Mcrk=min([Mcre Mcrl Mcrd]);
