function [KE,KG] = Matriz_Rig_Geo(KE,KG,  Ex,Ey,vx,vy,G,t,  Ty1,Ty2,   phy,a,b,CC,onda,NNOS,no1,no2)
%MATRIZ_RIG_GEO 
% 
%
%   INPUT:
%   Ex,Ey,vx,vy,G: Propriedades do material
%   t: Espessura da faixa (elemento)
%   Ty1, Ty2: tensões nos nós
%   phy: Angulo entre elementos da secao
%   a: Comprimento da faixa no eixo longitudinal
%   b: Largura da faixa no eixo transversal
%   CC: ['A-A'] string especificando o tipo de apoios:
%       'A-A' apoiado-apoiado nas extrmidades onde sao carrregadas
%       'E-E' engastado-engastado nas extrmidades onde sao carrregadas
%   onda: termos longitudinais (ou numero de meias-ondas) para cada
%   comprimento
%   NNOS: quantidade de nos na secao
%   no1,no2: Indices do primeiro e segundo no do elemento
%
%
%   OUTPUT:
%
%   KE: Matriz de Rigidez Elastica em coordenadas globais, sendo 
%   NONDA*NGN*NNOS x NONDA*NGN*NNOS com submatrizes de 8 x 8 que formam um bloco, assim
%   cada bloco tem NONDA x NONDA, distribuidos em seus respectivos graus de
%   liberdade
%   KE=[kMF_pq]NONDA x NONDA bloco de matrizes
%   cada kMF_pq é 8 x 8 relacionado a cada DOF [u1 v1 u2 v2 w1 theta1 w2 theta2]';
%
%   KG: Matriz de Rigidez Geometrica em coordenadas globais, sendo 
%   NONDA*NGN*NNOS x NONDA*NGN*NNOS com submatrizes de 8 x 8 que formam um bloco, assim
%   cada bloco tem NONDA x NONDA , distribuidos em seus respectivos graus de
%   liberdade
%   KG=[kgMF_pq]NONDA x NONDA bloco de matrizes
%   cada kgMF_pq é 8 x 8 relacionado a cada DOF [u1 v1 u2 v2 w1 theta1 w2 theta2]';
%
%   João Alfredo de Lazzari, Fevereiro 2019  (fonte: Z. Li, June 2010)

NONDA = length(onda); % Numero total de termos longitudinais

KsomaRig = zeros(4*NNOS*NONDA,4*NNOS*NONDA);
KsomaGeo = zeros(4*NNOS*NONDA,4*NNOS*NONDA);

% Constantes das relações constitutivas da membrana e flexao
E1=Ex/(1-vx*vy);
E2=Ey/(1-vx*vy);
Dx=Ex*t^3/(12*(1-vx*vy));
Dy=Ey*t^3/(12*(1-vx*vy));
D1=vx*Ey*t^3/(12*(1-vx*vy));
Dxy=G*t^3/12;

for pp=1:NONDA
    for qq=1:NONDA
        
        % Calculo das Integrais I(1), I(2), I(3), I(4) e I(5) referente as condições
        % de contorno
        [I] = Condicao_Contorno(CC,a,pp,qq);
        
        % Matriz de Rotacao de coordenadas locais para globais
        [gamma,~] = Rotacao8(phy);

    % MATRIZ DE RIGIDEZ
        lambda_p=onda(pp)*pi/a;
        lambda_q=onda(qq)*pi/a;
        
        % Matriz elastica de rigidez da membrana e de flexao para um 
        % elemento em coordenadas locais
        [kmf_pq] = Rig_MF(E1,E2,Dx,Dy,D1,Dxy,G,vx,I,t,b,lambda_p,lambda_q);
               
        % Matriz elastica de rigidez da membrana e de flexao
        % para um elemento em coordenadas globais  
        KMF_pq = gamma*kmf_pq*gamma'; 

        % Montagem da matriz de rigigez em seu grau de liberdade e
        % comprimento de onda específico
        [KsomaRig] = Montar(KsomaRig,KMF_pq,pp,qq,NNOS,no1,no2);
        
    % MATRIZ GEOMÉTRICA
        
        % Montanto a matriz geometrica de rigidez da membrana e de flexao 
        % para um elemento.
        [kgmf_pq] = Geo_MF(Ty1,Ty2,a,b,I,lambda_p,lambda_q);
        
        % Matriz rigidez geometrica da membrana e de flexao
        % para um elemento em coordenadas globais 
        
        KgMF_pq = gamma*kgmf_pq*gamma';

        % Montagem da matriz geométrica em seu grau de liberdade e
        % comprimento de onda específico
        [KsomaGeo] = Montar(KsomaGeo,KgMF_pq,pp,qq,NNOS,no1,no2);

    end
end

KE = KsomaRig + KE; %Montagem da matriz do elemento na matriz global
KG = KsomaGeo + KG; %Montagem da matriz do elemento na matriz global

end

