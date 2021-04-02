function [coord,elem,mat,ri,fy,fu,gama] = INPUT(perfil)
%INPUT Função com dados inicias para calculo de propriedades geometricas
%
%   ENTRADA:
%   perfil: Indicação do perfil a ser escolhido
%          (A) PERFIL U 100 X 50 X 1.00 (sem raio de concordância)
%          (B) PERFIL Ue 100 X 50 X 15 X 1.00 (sem raio de concordância)
%          (C) PERFIL Z 100 X 40 X 1.00 (sem raio de concordância)
%          (D) PERFIL Ze 100 X 40 X 20 X 1.00 (sem raio de concordância, e teta 45)
%          (E) PERFIL None 100 X 50 X 40 X 30 X 2.00 (sem raio de concordância)
%          (F) PERFIL Ue em unidade N e mm
%          (G) PERFIL Placa em unidade kN e mm
%          (H) PERFIL Direto do CUFSM
%   SAIDA:
%   coord: É a coordenada de cada nó do perfil.
%   elem:  Matriz com os elementos, e conectividade de cada elemento, alem
%          da espessura e raio de concordância entre os elementos
%
%   CONSIDERAÇÕES:
%   Para o cálculo das propriedades, é necessario que o eixo inicial de
%   coordenadas esteja na extremidade inferior a esquerda do perfil, e que 
%   o primeiro elemento começe da primeira extremidade a baixo no perfil, e
%   termine na outra e única extremidade. Sendo que o perfil será do tipo
%   PFF, assim, so terá duas extremidades possiveis.
%
% João Alfredo de Lazzari, 27 de Setembro de 2018

%_________________________________________________________________________%

switch perfil
    case ('A') 
%% (A) PERFIL U 100 X 50 X 1.00 (sem raio de concordância)
   
%COORDENADAS [mm]
%         Nó  x0    y0
coord = [ 1   50    0  1.0; % No 1 (Primeira Extremidade)
          2    0    0  1.0; % No 2
          3    0  100  1.0; % No 3
          4   50  100  1.0]; % No 4 (Ultima Extremidade)

%ELEMENTOS E CONECTIVIDADES
%        Elemento     NO 1     NO 2    Espessura t [mm]   Material
elem = [    1          1        2        1.00                1;             
            2          2        3        1.00                1;             
            3          3        4        1.00                1];
        
%MATERIAL
%      Tipo   E [kN/mm2]     v
mat = [ 1     200    200    0.3   0.3];

ri = 1.00; % Raio de Concordância
        
    case ('B')
%% (B) PERFIL Ue 100 X 50 X 15 X 1.00 (sem raio de concordância)
    
%COORDENADAS [mm]
%         Nó  x0    y0
coord = [ 1   50   15   1.0; % No 1 (Primeira Extremidade)
          2   50    0   1.0; % No 2
          3    0    0   1.0; % No 3
          4    0  100   1.0; % No 4
          5   50  100   1.0; % No 5 
          6   50   85   1.0]; % No 6 (Ultima Extremidade)

%ELEMENTOS E CONECTIVIDADES
%        Elemento     NO 1     NO 2    Espessura t [mm]   Material
elem = [    1          1        2        1.00                1;             
            2          2        3        1.00                1;             
            3          3        4        1.00                1;
            4          4        5        1.00                1;
            5          5        6        1.00                1];
        
%MATERIAL
%      Tipo   E [kN/mm2]     v
mat = [ 1     200    200    0.3   0.3];

ri = 1.00; % Raio de Concordância

    case ('C')
%% (C) PERFIL Z 100 X 40 X 1.00 (sem raio de concordância)
    
%COORDENADAS [mm]
%         Nó  x0    y0
coord = [ 1    0     0   1.0;  % No 1 (Primeira Extremidade)
          2   40     0   1.0;  % No 2
          3   40   100   1.0;  % No 3
          4   80   100   1.0]; % No 4 (Ultima Extremidade)

%ELEMENTOS E CONECTIVIDADES
%        Elemento     NO 1     NO 2    Espessura t [mm]   Material
elem = [    1          1        2        1.00                1;             
            2          2        3        1.00                1;             
            3          3        4        1.00                1];
        
%MATERIAL
%      Tipo   E [kN/mm2]     v
mat = [ 1     200    200    0.3   0.3];

ri = 1.00; % Raio de Concordância

    case ('D')
%% (D) PERFIL Ze 100 X 40 X 20 X 1.00 (sem raio de concordância, e teta 45)
    
%COORDENADAS [mm]
%         Nó         x0                    y0
coord = [ 1          0              20*(cos(pi/4))       1.0;  % No 1 (Primeira Extremidade)
          2   20*(cos(pi/4))               0             1.0;  % No 2 
          3   40+20*(cos(pi/4))            0             1.0;  % No 3
          4   40+20*(cos(pi/4))           100            1.0;  % No 4
          5   80+20*(cos(pi/4))           100            1.0;  % No 5 
          6   80+2*20*(cos(pi/4)) 100-20*(cos(pi/4))     1.0];  % No 6 (Ultima Extremidade)

%ELEMENTOS E CONECTIVIDADES
%        Elemento     NO 1     NO 2    Espessura t [mm]   Material
elem = [    1          1        2        1.00                1;             
            2          2        3        1.00                1;            
            3          3        4        1.00                1;
            4          4        5        1.00                1;
            5          5        6        1.00                1];
        
%MATERIAL
%      Tipo   E [kN/mm2]     v
mat = [ 1     200    200    0.3   0.3];

ri = 1.00; % Raio de Concordância

    case ('E')
%% (E) PERFIL None 100 X 50 X 40 X 30 X 2.00 (sem raio de concordância)
    
%COORDENADAS [mm]
%         Nó  x0    y0
coord = [ 1   40    0  1.0; % No 1 (Primeira Extremidade)
          2    0    0  1.0; % No 2
          3    0  100  1.0; % No 3
          4   50  100  1.0; % No 4 
          5   50   70  1.0]; % No 5 (Ultima Extremidade)

%ELEMENTOS E CONECTIVIDADES
%        Elemento     NO 1     NO 2    Espessura t [mm]   Material
elem = [    1          1        2        2.00                1;             
            2          2        3        2.00                1;             
            3          3        4        2.00                1;
            4          4        5        2.00                1];
        
%MATERIAL
%      Tipo   E [kN/mm2]     v
mat = [ 1     200    200    0.3   0.3];

ri = 2.00; % Raio de Concordância

    case ('F')
%% (F) PERFIL Ue em unidade N e mm
    
%COORDENADAS [mm]
%         Nó  x0    y0
coord = [   1 31.0312 4.4158  1.000  
            2 31.0312 2.2079  1.000  
            3 31.0312 0.0000  1.000  
            4 23.2734 0.0000  1.000  
            5 15.5156 0.0000  1.000  
            6 7.7578 0.0000  1.000   
            7 0.0000 0.0000  1.000   
            8 0.0000 7.8476  1.000   
            9 0.0000 15.6953  1.000  
            10 0.0000 23.5429  1.000 
            11 0.0000 31.3906  1.000 
            12 0.0000 39.2382  1.000 
            13 0.0000 47.0859  1.000 
            14 0.0000 54.9335  1.000 
            15 0.0000 62.7812  1.000 
            16 7.7578 62.7812  1.000 
            17 15.5156 62.7812  1.000
            18 23.2734 62.7812  1.000
            19 31.0312 62.7812  1.000
            20 31.0312 60.5733  1.000
            21 31.0312 58.3654  1.000];

%ELEMENTOS E CONECTIVIDADES
%        Elemento     NO 1     NO 2    Espessura t [mm]   Material
elem = [1 1 2 0.718820 100   
        2 2 3 0.718820 100   
        3 3 4 0.718820 100   
        4 4 5 0.718820 100   
        5 5 6 0.718820 100   
        6 6 7 0.718820 100   
        7 7 8 0.718820 100   
        8 8 9 0.718820 100   
        9 9 10 0.718820 100  
        10 10 11 0.718820 100
        11 11 12 0.718820 100
        12 12 13 0.718820 100
        13 13 14 0.718820 100
        14 14 15 0.718820 100
        15 15 16 0.718820 100
        16 16 17 0.718820 100
        17 17 18 0.718820 100
        18 18 19 0.718820 100
        19 19 20 0.718820 100
        20 20 21 0.718820 100];
        
%MATERIAL
%      Tipo   E [N/mm2]     v
mat = [ 100 203000.00 203000.00 0.30 0.30 ];

ri = 0; % Raio de Concordância


    case ('G')
%% (G) PERFIL Placa em unidade kN e mm

% 'Placa Teste'
%COORDENADAS [mm]
%         Nó  x0    y0   tensão (kN/mm2)
coord = [ 1   0     0    1.00;         % No 1 (Primeira Extremidade)
          2   50    0    1.00;         % No 2
          3   100   0    1.00];         % No 3
%           4   150   0    1.00;         % No 4
%           5   200   0    1.00;         % No 5 
%           6   250   0    1.00;         % No 6
%           7   300   0    1.00;         % No 7
%           8   350   0    1.00;         % No 8
%           9   400   0    1.00;         % No 9
%          10   400   0    1.00;         % No 10
%          11   400   0    1.00];        % No 11 (Ultima Extremidade)

%ELEMENTOS E CONECTIVIDADES
%        Elemento     NO 1     NO 2    Espessura t [mm]   Material
elem = [    1          1        2        5.00                1;             
            2          2        3        5.00                1];             
%             3          3        4        5.00                1;
%             4          4        5        5.00                1;
%             5          5        6        5.00                1;
%             6          6        7        5.00                1;
%             7          7        8        5.00                1;
%             8          8        9        5.00                1;
%             9          9       10        5.00                1;
%            10         10       11        5.00                1];
        
%MATERIAL
%      Tipo   Ex [kN/mm2]   Ey [kN/mm2]   vx     vy
mat = [ 1     200           200          0.3   0.3
        2     300           300          0.2   0.2
        3     250           250          0.1   0.1]; %Obs: A numeracao deve ser de 1 ate o numero de linhas

ri = 0; % Raio de Concordância


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case ('H')
%% (H) PERFIL Direto do CUFSM

% 'CUFSM Fomat'

%MATERIAL
matCUFSM = [100 200.00 200.00 0.30 0.30 76.92];

%COORDENADAS [mm]
coordCUFSM = [1 28.7500 9.3750 1 1 1 1 1.000  
2 28.7500 7.0313 1 1 1 1 1.000  
3 28.7500 4.6875 1 1 1 1 1.000  
4 28.7500 2.3438 1 1 1 1 1.000  
5 28.7500 0.0000 1 1 1 1 1.000  
6 21.5625 0.0000 1 1 1 1 1.000  
7 14.3750 0.0000 1 1 1 1 1.000  
8 7.1875 0.0000 1 1 1 1 1.000   
9 0.0000 0.0000 1 1 1 1 1.000   
10 0.0000 7.1875 1 1 1 1 1.000  
11 0.0000 14.3750 1 1 1 1 1.000 
12 0.0000 21.5625 1 1 1 1 1.000 
13 0.0000 28.7500 1 1 1 1 1.000 
14 7.1875 28.7500 1 1 1 1 1.000 
15 14.3750 28.7500 1 1 1 1 1.000
16 21.5625 28.7500 1 1 1 1 1.000
17 28.7500 28.7500 1 1 1 1 1.000
18 28.7500 26.4063 1 1 1 1 1.000
19 28.7500 24.0625 1 1 1 1 1.000
20 28.7500 21.7188 1 1 1 1 1.000
21 28.7500 19.3750 1 1 1 1 1.000
22 15       15     1 1 1 1 1.000];

%ELEMENTOS E CONECTIVIDADES
% Elemento  NO 1 NO 2 Espessura t [mm]  Material#
elemCUFSM = [1 1 2 1.250000 100   
2 2 3 1.250000 100   
3 3 4 1.250000 100   
4 4 5 1.250000 100   
5 5 6 1.250000 100   
6 6 7 1.250000 100   
7 7 8 1.250000 100   
8 8 9 1.250000 100   
9 9 10 1.250000 100  
10 10 11 1.250000 100
11 11 12 1.250000 100
12 12 13 1.250000 100
13 13 14 1.250000 100
14 14 15 1.250000 100
15 15 16 1.250000 100
16 16 17 1.250000 100
17 17 18 1.250000 100
18 18 19 1.250000 100
19 19 20 1.250000 100
20 20 21 1.250000 100
21 8 22  1.25000  100];

%%%%

%COORDENADAS [mm] 
%             Nó                 x0                 y0             tensão (kN/mm2)                                
coord = [coordCUFSM(:,1)   coordCUFSM(:,2)     coordCUFSM(:,3)    coordCUFSM(:,8)];         
%ELEMENTOS E CONECTIVIDADES
%  Elemento     NO 1     NO 2    Espessura t [mm]   Material
elem=elemCUFSM;                 
        
%MATERIAL
%      Tipo#   Ex [kN/mm2]   Ey [kN/mm2]   vx     vy
mat = matCUFSM(1:5); %Obs: A numeracao deve ser de 1 ate o numero de linhas

ri = 0; % Raio de Concordância
end

% MATERIAL - AÇO ASTM A572 grau 50 
fy = 0.345; % Tensao de Escoamento [GPa == kN/mm2]
fu = 0.450; % Tensao de Ruptura [GPa == kN/mm2]
% E = mat(2); % Módulo de elasticidade de Young [MPa == N/mm2]
% v = mat(3); % Coeficiente de Poisson
% G = E/(1+v); % Modulo de Elasticidade Transversal [MPa == N/mm2]

gama = 1.2;      % Coeficiente de Minoração da Força Axial de Compressão Resistente Característica 
end

