function [Ncre,Nex,Ney,Nez,Nexz,Neyz,Ne,LambdaG]=NCRE(L,E,I1,I2,r0,x0,y0,Cw,G,J,A,fy)
%Comprimento efetivo de flambagem
kx=1;ky=1;kz=1;
%% Força critica de flambagem (Simetrica ou monossimetrica)
Nex=(E.*I1.*pi.^2)./(kx.*L.^2);
Ney=(E.*I2.*pi.^2)./(ky.*L.^2);
Nez= (1/r0.^2).*((E.*Cw.*pi.^2)./(kz.*L.^2)+G.*J);
%
Nexz= (Nex+Nez)./(2-2.*(x0/r0).^2)...
    .*(1-(1-(4.*Nex.*Nez.*(1-(x0/r0).^2)./(Nex+Nez).^2)).^0.5);
%Só teórico
Neyz= (Ney+Nez)./(2-2.*(x0/r0).^2)...
    .*(1-(1-(4.*Ney.*Nez.*(1-(x0/r0).^2)./(Ney+Nez).^2)).^0.5);
%----------------------------------------------------------------------- 
%% Polinômio (Qualquer seção)
for i=1:length(L)
a3 = (r0.^2) - (x0.^2) - (y0.^2);
a2 = (r0.^2).*(-Ney(i)-Nex(i)-Nez(i)) + (x0.^2).*Ney(i) + (y0.^2).*Nex(i);
a1 = (r0.^2).*(Nex(i).*Ney(i) + Ney(i).*Nez(i) + Nex(i).*Nez(i));
a0 = -(r0.^2).*Nex(i).*Nez(i).*Ney(i);
p = [a3 a2 a1 a0];
Ne_prov = roots(p);
Ne_prov = Ne_prov(imag(Ne_prov)==0); % Só raizes reais 
Ne(i,1) = min(Ne_prov);     
LambdaG = (A.*fy./Ne).^0.5;   
end
%-----------------------------------------------------------------------
%% Resistência carcteristica á flambagem global
 for j=1:length(Ne)
     if LambdaG(j)<=1.5;
         Ncre(j)=(0.658.^(LambdaG(j).^2)).*A.*fy;
   else LambdaG(j)>1.5;
         Ncre(j)=(0.877./(LambdaG(j).^2)).*A.*fy;     
     end
 end
  Ncre=Ncre';
end