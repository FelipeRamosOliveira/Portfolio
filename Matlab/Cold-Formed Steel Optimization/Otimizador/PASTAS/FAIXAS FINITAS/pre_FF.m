function [no1,no2,b,t,alpha,Ty1,Ty2,A,xg,yg,teta,Ixg,Iyg] = pre_FF(elem,coord)
%PRE_FF Pre-processamento para metodo das faixas finitas
% Organização dos dados de entrada para processar a análise
%
%   João Alfredo de Lazzari, Abril 2019

% DEFINIÇÃO DOS NÓS DE CADA ELEMENTO
no1 = elem(:,2);
no2 = elem(:,3);

xno1 = coord(no1,2); %coord(elem(:,2),1)
yno1 = coord(no1,3); %coord(elem(:,2),2)

xno2 = coord(no2,2); %coord(elem(:,3),1)
yno2 = coord(no2,3); %coord(elem(:,3),2)

xmed = (xno2+xno1)/2; %Posição em X do centro de gravidade de cada elemento
ymed = (yno2+yno1)/2; %Posição em Y do centro de gravidade de cada elemento

dx = xno2-xno1; %Variacao das coordenadas na direcao x
dy = yno2-yno1; %Variacao das coordenadas na direcao y

% DADOS DOS ELEMETNOS 
b = ( dx.^2 + dy.^2 ).^0.5; % Largura de cada elemento
t = elem(:,4); %Espessura de cada elemento
Aelem = b.*t;  % Área de cada elemento
alpha = atan2(dy,dx); % Angulo entre elementos
Ty1 = coord(no1,4).*t;  % Tensões nodal do elemento no no1
Ty2 = coord(no2,4).*t;  % Tensões nodal do elemento no no2

% CENTRO DE GRAVIDADE
Sy = dot(xmed,Aelem);% Momento Estático de Primeira ordem em relação ao eixo Y
Sx = dot(ymed,Aelem);% Momento Estático de Primeira ordem em relação ao eixo X
A = sum(Aelem); % Área total
xg = Sy/A; % Posição do centro de gravidade em X em relação ao ponto 0
yg = Sx/A; % Posição do centro de gravidade em Y em relação ao ponto 0

% MOMENTO DE SEGUNDA ORDEM EM RELAÇÃO AO CENTRO 0
Ix0 = sum(( t.*b./12 ).*((yno2-yno1).^2 ) + Aelem.*ymed.^2 );
Iy0 = sum(( t.*b./12 ).*((xno2-xno1).^2 ) + Aelem.*xmed.^2 );
Ixy0 = sum(( t.*b./12 ).*((xno2-xno1).*(yno2-yno1)) + Aelem.*xmed.*ymed );

% MOMENTO DE SEGUNDA ORDEM EM RELAÇÃO AO CENTRO DE GRAVIDADE
Ixg = Ix0 - A*yg^2;
Iyg = Iy0 - A*xg^2;
Ixyg = Ixy0 - A*xg*yg;

% POSIÇÃO DO EIXO CENTRAL PRINCIPAL (em relação ao eixo x)
teta = radtodeg(atan(-2*Ixyg/(Ixg - Iyg))/2); % Angulo de rotação do eixo x em gruas

end

