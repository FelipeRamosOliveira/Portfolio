%% CÁLCULO DE RESISTÊNCIA À COMPRESSÃO CENTRADA (MRD)
clc
%Propriedades geométricas e do material 
global A xcg zcg I11 I22 Cw J Xs Ys prop 
%Forças criticas e curva de assintaura 
global CURVA Pcr Nl Nd Ncre Ncrl Ncrd L fy

%% 1.PROPRIEDADES

%Curva de assinatura 
%Menor valor de autovalor pra cada comprimento
for i=1:length(CURVA) 
Comprimento_Pcr(i,:)=min(CURVA{1,i}); 
end

%Material
E=prop(1,2);         %N/mm2
G=prop(1,6);         %N/mm2
fy=345;              %N/mm2
v=0.3;

%Geometria
r1=(I11/A)^0.5; %mm2
r2=(I22/A)^0.5; %mm2
x0=xcg-Xs;      %mm
y0=zcg-Ys;      %mm
r0=sqrt(r1^2+r2^2+x0^2+y0^2); %mm
L=max(Comprimento_Pcr(:,1));  %mm


%% 2.RESISTÊNCIA À FLAMBAGEM GLOBAL 
[Ncre,Nex,Ney,Nez,Nexz,Neyz,Ne]=NCRE(L,E,I11,I22,r0,x0,y0,Cw,G,J,A,fy);


%% 3. CLASSIFICAR OS TIPOS DE FLAMBAGEM
%Vetor cargas crítcas
Pcr=Comprimento_Pcr(:,2);

%Classificador elegante
%msuggest %---->classificador alternativo

%Classificador não elgante
for i=2:length(Pcr)-1
if Pcr (i)<Pcr (i-1)& Pcr(i)<Pcr (i+1);
   Minimos(i)=Pcr (i);
   Minimos=nonzeros(Minimos);
end
end
Nl=Minimos(1)*1000;
n=length(Minimos);
Nd=min(Minimos(2:n))*1000;

%Menor carga critica absoluta
%NcAb=min(Pcr);
%
%% 4.RESISTÊNCIA À FLAMBAGEM LOCAL
if isempty(Nl);
   Nl=Ne;
end
[Ncrl]=NCRL(Ncre,Nl);
%
%% 5.RESISTÊNCIA À FLAMBAGEM DISTORCIONAL
if isempty(Nd);
   Nd=Nl;
end
[Ncrd]=NCRD(A,fy,Nd);


%% 6.RESISTÊNCIA CARCTERISTICA 
for i=1:length(Ncre)
Ncrk(i)=min(Ncre(i),Ncrl(i));
if Ncrk(i)>Ncrd;
   Ncrk(i)=Ncrd;
end
RESULTADO(i,:)=[Ncre(i) Ncrl(i) Ncrd Ncrk(i)]./1000;
end
% Nl/1000
% Nd/1000
% display(RESULTADO,'    Ncre      Ncrl      Ncrd     Ncrk')
