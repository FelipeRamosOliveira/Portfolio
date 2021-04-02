function [Mre]=MRE(L,E,I1,I2,r0,x0,y0,Cw,G,J,A,fy,Wc)
%% Cb - Fator de Modificação para Momento Fletor não Uniforme
%Momento fletor constante, M0, ao longo da viga
Cb = 1.00;
%% Momento fletor de flambagem lateral com torção
[Ncre,Nex,Ney,Nez,Nexz,Neyz]=NCRE(L,E,I1,I2,r0,x0,y0,Cw,G,J,A,fy);
 Me=Cb.*r0.*(Ney.*Nez).^0.5;
 Lambda0=(Wc.*fy./Me).^0.5;
 for i=1:length(Lambda0)
     if Lambda0(i)<=0.6;
     Mre(i)=Wc*fy;
     elseif Lambda0(i)<1.336;
      Mre(i)=1.11.*(1-0.278.*Lambda0(i).^2).*Wc.*fy;
     else Lambda0(i)>=1.336;
         Mre(i)=W.*fy./ Lambda0(i);
     end
 end   
