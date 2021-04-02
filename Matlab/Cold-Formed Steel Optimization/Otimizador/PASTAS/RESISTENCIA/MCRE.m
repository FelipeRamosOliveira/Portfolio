%%  FLAMBAGEM LATERAL COM TOR��O
function [Mcre,Me]=MCRE(Ney,Nez,WxC,fy,r0) 
%Fator de modifica��o para momento fletor uniforme
Cb=1;

%% MOMENTO FLETOR DE FLAMBAGEM LATERAL COM TOR��O 
%Barras com se��o duplamente sim�trica ou monossim�trica
Me=Cb.*r0.*(Ney.*Nez).^0.5;

%Barras com se��o Z ponto-sim�trica
%Me=0.5.*Cb.*r0.*(Ney.*Nez).^0.5;

%% RESIT�NCIA CARCTER�STICA 

%Esbeltez
Lambda0=(WxC.*fy./Me)^0.5;

if Lambda0 <=0.6;
    Mcre=WxC.*fy;
elseif Lambda0<1.336;
    Mcre=1.11.*(1-0.278.*Lambda0^2).*WxC.*fy;
else Lambda0>=1.336;
    Mcre=(WxC.*fy)./(Lambda0^2);
end