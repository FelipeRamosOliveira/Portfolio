%%  FLAMBAGEM LOCAL
function [Mcrl]=MCRL(Ml,Mcre) 
%MOMENTO FLETOR DE FLAMBAGEM LOCAL EL�STICA

%Esbeltez
Lambda0=(Mcre./Ml)^0.5;

if Lambda0<=0.776
    Mcrl=Mcre;
else
    Mcrl=(1- 0.15./(Lambda0^0.8)).*(Mcre./(Lambda0^0.8));
end