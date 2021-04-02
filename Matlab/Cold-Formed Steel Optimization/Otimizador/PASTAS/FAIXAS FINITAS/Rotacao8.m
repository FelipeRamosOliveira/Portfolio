function [gamma1,gamma2] = Rotacao8(phy)
%ROTACAO8 Matriz de Rotacao de coordenadas locais para globais
%
%   gamma1: Matriz de Rotacao para Deslocamentos Nodais [u1 v1 u2 v2 w1 theta1 w2 theta2]'
%   gamma2: Matriz de Rotacao para Campo de Deslocamentos [U V W]'
%
%   João Alfredo de Lazzari, Fevereiro 2019  (fonte: Z. Li, June 2010)

% Matriz de Rotacao de coordenadas locais para globais: Deslocamentos Nodais
%            u1       v1     u2     v2     w1     O1      w2     O2
gamma1 = [ cos(phy)   0      0      0  -sin(phy)   0       0	 0   % u1
             0	      1      0      0      0       0	   0     0   % v1
             0	      0   cos(phy)  0      0	   0  -sin(phy)  0   % u2
             0	      0      0      1      0	   0	   0	 0   % v2
          sin(phy)    0      0      0   cos(phy)   0	   0	 0   % w1
             0	      0      0      0      0	   1	   0     0   % O1
             0	      0   sin(phy)  0      0	   0   cos(phy)  0   % w2
             0	      0      0      0      0	   0	   0	 1 ];% O2

% Matriz de Rotacao de coordenadas locais para globais: Campo de Deslocamentos
%            U         V       W
gamma2 = [ cos(phy)    0    -sin(phy) % U
             0	       1       0      % V
          sin(phy)     0   cos(phy)]; % W

end

