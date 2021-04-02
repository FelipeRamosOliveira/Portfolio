%%  FLAMBAGEM LATERAL COM TORÇÃO
function [Mcre,Me]=MCRE(Ney,Nez,WxC,fy,r0) 
%Fator de modificação para momento fletor uniforme
Cb=1;

%% MOMENTO FLETOR DE FLAMBAGEM LATERAL COM TORÇÃO 
%Barras com seção duplamente simétrica ou monossimétrica
Me=Cb.*r0.*(Ney.*Nez).^0.5;

%Barras com seção Z ponto-simétrica
%Me=0.5.*Cb.*r0.*(Ney.*Nez).^0.5;

%% RESITÊNCIA CARCTERÍSTICA 

%Esbeltez
Lambda0=(WxC.*fy./Me)^0.5;

if Lambda0 <=0.6;
    Mcre=WxC.*fy;
elseif Lambda0<1.336;
    Mcre=1.11.*(1-0.278.*Lambda0^2).*WxC.*fy;
else Lambda0>=1.336;
    Mcre=(WxC.*fy)./(Lambda0^2);
end