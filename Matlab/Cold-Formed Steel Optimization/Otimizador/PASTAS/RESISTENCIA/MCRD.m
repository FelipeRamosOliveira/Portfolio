%%  FLAMBAGEM DISTORCIONAL
function [Mcrd]=MCRD(WxC,fy,Md); 
%% RESITÊNCIA CARCTERÍSTICA 

%Esbeltez
LambdaD=(WxC.*fy./Md)^0.5;

if LambdaD <=0.673;
    Mcrd=WxC.*fy;
else
    Mcrd=(1 - (0.22./LambdaD)).*((WxC.*fy)./LambdaD);
end