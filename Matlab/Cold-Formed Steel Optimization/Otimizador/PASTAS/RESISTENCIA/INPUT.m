function [coord,elem,fy,fu,E,v,G,gama,bf,bw,tipo,t] = INPUT(perfil)
%% DADOS DE ENTRADA DO PROGRAMA
% MATERIAL - AÇO ASTM A572 grau 50 
t=1.00;      %Espessura do Perfil   
fy = 0.345;  % Tensao de Escoamento [GPa == kN/mm2]
fu = 0.450;  % Tensao de Ruptura [GPa == kN/mm2]
E = 220;  % Módulo de elasticidade de Young [MPa == N/mm2]
v = 0.3;  % Coeficiente de Poisson
G = E/(2*(1+v)); % Modulo de Elasticidade Transversal [MPa == N/mm2]
gama = 1.2;  % Coeficiente de Minoração da Força Axial de Compressão Resistente Característica 
%
%   PERFIL: Indicação do perfil a ser escolhido
%          (1) PERFIL U 100 X 50 X 1.00 
switch perfil
    case (1) 
%%(A) PERFIL U 100 X 50 X 1.00
bf=50;
bw=100;
tipo=1;
%COORDENADAS [mm]
%         Nó  x0    y0
coord = [  1    bf          0 ; 
           2    (3*bf/4)    0 ; 
           3    (bf/2)      0 ; 
           4    (bf/4)      0 ;
           5    0           0 ;
           6    0      (bw/4) ;
           7    0      (bw/2) ;
           8    0    (3*bw/4) ;
           9    0          bw ;
          10    (bf/4)     bw ;
          11    (bf/2)     bw ;
          12    (3*bf/4)   bw ;
          13    bf         bw] ;

%ELEMENTOS E CONECTIVIDADES       
    n=length(coord)-1;
for i=1:n
    elem(i,1)=i;
    elem(i,2)=elem(i,1)+1;
    elem(i,3)=t;
end
end
end
