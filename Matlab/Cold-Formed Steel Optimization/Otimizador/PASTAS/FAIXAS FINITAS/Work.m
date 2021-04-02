

%% Modelo Teste
perfil='Placa Teste';
%COORDENADAS [mm]
%         Nó  x0    y0
coord = [ 1   0     0 ; % No 1 (Primeira Extremidade)
          2   50    0 ; % No 2
          3   100   0 ; % No 3
          4   150   0 ; % No 4
          5   200   0 ; % No 5 
          6   250   0 ; % No 6
          7   300   0 ; % No 7
          8   350   0 ; % No 8
          9   400   0 ; % No 9
         10   450   0 ; % No 10
         11   500   0]; % No 11 (Ultima Extremidade)

%ELEMENTOS E CONECTIVIDADES
%        Elemento     NO 1     NO 2    Espessura t [mm]   Material
elem = [    1          1        2        5.00                1;             
            2          2        3        5.00                1;             
            3          3        4        5.00                1;
            4          4        5        5.00                1;
            5          5        6        5.00                1;
            6          6        7        5.00                1;
            7          7        8        5.00                1;
            8          8        9        5.00                1;
            9          9       10        5.00                1;
           10         10       11        5.00                1];
        
%MATERIAL
%      Tipo   E [kN/mm2]     v
mat = [ 1     200           0.3
        2     300           0.3
        3     250           0.3]; %Obs: A numeracao deve ser de 1 ate o numero de linhas

%%

% DEFINIÇÃO DOS NÓS DE CADA ELEMENTO
no1 = elem(:,2);
no2 = elem(:,3);

xno1 = coord(no1,2); %coord(elem(:,2),1)
yno1 = coord(no1,3); %coord(elem(:,2),2)

xno2 = coord(no2,2); %coord(elem(:,3),1)
yno2 = coord(no2,3); %coord(elem(:,3),2)

% LARGURA DE CADA ELEMENTO
b = ( (xno2-xno1).^2 + (yno2-yno1).^2 ).^0.5;

% MATRIX DE ROTACAO
% co = (xno2-xno1)./b; %Coseno em relacao o primeiro ponto
% se = (yno2-yno1)./b; %Seno em relacao ao primeiro ponto
% R = [co, se, 0;
%     -se, co, 0;
%          0, 0, 1]; %Matriz de rotação
% 
%     T = [R         , zeros(3,3);
%          zeros(3,3), R         ];
% 
%     kg = T'*ke*T; %Matriz local rotacionada

t = elem(:,4); %Espessura de cada elemento

NNOS = size(coord,1); % Número de nós
NELM = size(elem,1); % Número de elementos
NGN = 2; % Numero de graus de liberdade por no
NGE = 2*NGN; % Numero de graus de liberdade por elemento (cada elemento tem 2 nos)
NGL = NNOS*NGN; % Numero de graus de liberdade

% PROPRIEDADES DE MATERIAL
E = mat(elem(:,5),2); % Modulo de Elasticidade de Cada Elemento
v = mat(elem(:,5),3); % Coeficiente de Poisson de Cada Elemento

% ÁREA DE CADA ELEMENTO
Aelem = b.*t;
A = sum(Aelem);




%% 
% syms E b t v L

% E=200
% b=300
% t=1
% v=0.3
% L=logspace(1,4,300)
% L = 10^1:100:10^4;
L=[1000]

NCOMP = length(L); % Numero de comprimentos do eixo longitudinal

%%
KE = zeros(NGL,NGL);
% KE = sym(zeros(NGL,NGL));
KGx_star = zeros(NGL,NGL);
KGy_star = zeros(NGL,NGL);
Pcr_1 = zeros(NCOMP,1);
Pcr_2 = zeros(NCOMP,1);
Pcr_3 = zeros(NCOMP,1);
sigma_1 = zeros(NCOMP,1); %Tensao Critica do 1o modo
sigma_2 = zeros(NCOMP,1); %Tensao Critica do 2o modo
sigma_3 = zeros(NCOMP,1);

for kk=1:NCOMP
    for ii=1:NELM
        kE1 = (((pi^4)*E(ii)*b(ii)*t(ii)^3)/(10080*(1-v(ii)^2)))*[156           22*b(ii)        54          -13*b(ii);
                                                                  22*b(ii)      4*b(ii)^2       13*b(ii)    -3*b(ii)^2;    
                                                                  54            13*b(ii)        156         -22*b(ii);
                                                                  -13*b(ii)     -3*b(ii)^2      -22*b(ii)   4*b(ii)^2]; %Náo esta divido por L^3. Somente dividir na equacáo final de kE

        kE2 = (((pi^2)*E(ii)*t(ii)^3)/(360*(1-v(ii)^2)*b(ii)))*[36                      (3+15*v(ii))*b(ii)      -36                     3*b(ii);
                                                                (3+15*v(ii))*b(ii)      4*b(ii)^2               -3*b(ii)                -b(ii)^2;    
                                                                -36                     -3*b(ii)                36                      -(3+15*v(ii))*b(ii);
                                                                3*b(ii)                 -b(ii)^2                -(3+15*v(ii))*b(ii)     4*b(ii)^2]; %Náo esta divido por L^2. Somente dividir na equacáo final de kE

        kE3 = ((E(ii)*t(ii)^3)/(24*(1-v(ii)^2)*b(ii)^3))*[12            6*b(ii)         -12             6*b(ii);
                                                          6*b(ii)       4*b(ii)^2       -6*b(ii)        2*b(ii)^2;    
                                                          -12           -6*b(ii)        12              -6*b(ii);
                                                          6*b(ii)       2*b(ii)^2       -6*b(ii)        4*b(ii)^2]; %Náo esta divido por L^3. Somente dividir na equacáo final de kE

        kE = kE1*(1/L(kk)^3) + kE2*(1/L(kk)) + kE3*(L(kk)); % Elastic Stiffness Matrix Dependent on the Half-Wavelength of the Buckling mode                     
        % MartixNulo=(kE-kE')


        kGx_star = (((pi^2)*b(ii)*t(ii))/(840*L(kk)))*[156          22*b(ii)        54          -13*b(ii);
                                                       22*b(ii)     4*b(ii)^2       13*b(ii)    -3*b(ii)^2;    
                                                       54           13*b(ii)        156         -22*b(ii);
                                                       -13*b(ii)    -3*b(ii)^2      -22*b(ii)   4*b(ii)^2]; % Geometrical Stiffness Matrix for unit values of stresses in X direction.
                                                                                 % ( kGx_star = kGx*(1/L)*(1/sigma_xx)

        kGy_star = ((L(kk)*t(ii))/(60*b(ii)))*[36           3*b(ii)        -36          3*b(ii);
                                           3*b(ii)      4*b(ii)^2      -3*b(ii)     -b(ii)^2;    
                                           -36          -3*b(ii)       36           -3*b(ii);
                                           3*b(ii)      -b(ii)^2       -3*b(ii)     4*b(ii)^2]; % Geometrical Stiffness Matrix for unit values of stresses in Y direction.
                                                                         % ( kGy_star = kGx*(L)*(1/sigma_yy)
        
        
        
        GL1 = [(no1(ii)*NGN-1)  (no1(ii)*NGN)    (no2(ii)*NGN-1) (no2(ii)*NGN)];
        GL2 = [(no1(ii)*NGN-1)  (no1(ii)*NGN)    (no2(ii)*NGN-1) (no2(ii)*NGN)];
        
        KE(GL1,GL2) = KE(GL1,GL2) + kE;
        
        KGx_star(GL1,GL2) = KGx_star(GL1,GL2) + kGx_star;
        
        KGy_star(GL1,GL2) = KGy_star(GL1,GL2) + kGy_star;
        
%         KE(1,1)=10E20;
% %         KE(2,2)=10E20;
%         KE(21,21)=10E20;
%         KE(22,22)=10E20;

    end
    AA=KE;
    ratio_yy_xx = 0;
    BB= KGx_star + ratio_yy_xx*KGy_star;
    [V,lamb_xx,W]=eig(AA,BB,'chol','vector');
    
    DeslY = W(1:2:end,:); % Deslocamento vertical
    [sigma, indx] = sort(lamb_xx); % Tensao critica de todos os modos ordenado do menor para o maior
    Pcr = sigma*A; %Forca Critica de todos os modos
    
    sigma_1(kk,1) = lamb_xx(1); %Tensao Critica do 1o modo
    sigma_2(kk,1) = lamb_xx(2); %Tensao Critica do 2o modo
    sigma_3(kk,1) = lamb_xx(3); %Tensao Critica do 3o modo
    Pcr_1(kk) = Pcr(1); %Forca Critica do 1o modo
    Pcr_2(kk) = Pcr(2); %Forca Critica do 2o modo
    Pcr_3(kk) = Pcr(3); %Forca Critica do 3o modo
 
    
end

mode = 1
DeforYY = coord(:,3) + DeslY(:,indx(mode));

figure (1)
plot(coord(:,2),coord(:,3),coord(:,2),DeforYY)

sigma_1

% figure (2)
% plot(L,Pcr_1)
AA*V-BB*V*diag(lamb_xx)