function [b,A,xg,yg,J,Ixg,Iyg,Ixyg,teta,I11,I22,xc,yc,wc,Cw,x0,y0,r0,WxC,WyC] = prop_geom_PFF(coord,elem)
%PROP_GEOM_PFF Propriedades geométricas de perfis formados a frio
%
%   - ENTRADA:
%   coord: É a coordenada de cada nó do perfil.
%   elem:  Matriz com os elementos, e conectividade de cada elemento, alem
%          da espessura e raio de concordância entre os elementos
%   - SAÍDA:
%   b:    Comprimento de cada elemento
%   A:    Área da seção
%   xg:   Posição do centro de gravidade em X em relação ao ponto 0
%   yg:   Posição do centro de gravidade em Y em relação ao ponto 0
%   J:    Constante de Torção do Perfil
%   Ixg:  Momento de Segunda ordem em relação ao eixo central xg
%   Iyg:  Momento de Segunda ordem em relação ao eixo central yg
%   Ixyg: Produto de Inercia em relação ao eixo central xg e yg
%   teta: Posição do eixo central principal, medido em relação ao eixo x
%         (eixo y é teta + 90)
%   I1:   Momento de Segunda ordem central principal máximo
%   I2:   Momento de Segunda ordem central principal mínimo
%   xc:   Posição do centro de cisalhamento em X em relação ao ponto 0
%   yc:   Posição do centro de cisalhamento em Y em relação ao ponto 0
%   Cw:   Constante de Empenamento
%
%   - VARIÁVEIS AUXILIARES:
%   no1:       Vetor com os primeiros nós de cada elemento
%   no2:       Vetor com os segundos nós de cada elemento
%   xno1:      Coordenada em x do primeiro nó
%   yno1:      Coordenada em y do primeiro nó
%   xno2:      Coordenada em x do segundo nó
%   yno2:      Coordenada em y do segundo nó
%   t:         Vetor com Espessura de cada elemento
%   NOS:       Número total de nós
%   NEL        Número total de elementos
%   Aelem:     Vetor com área de cada elemento
%   xmed:      Posição em X do centro de gravidade de cada elemento
%   ymed:      Posição em Y do centro de gravidade de cada elemento
%   Sy:        Momento Estático de Primeira ordem em relação ao eixo Y
%   Sx:        Momento Estático de Primeira ordem em relação ao eixo X   
%   Ix0:       Momento de Segunda ordem em relação ao eixo x0
%   Iy0:       Momento de Segunda ordem em relação ao eixo y0
%   Ixy0:      Produto de Inercia em relação ao eixo x0 e y0
%   coordwb:   Coordenada
%   wmed:      Coordenada setorial média no elemento
%   seno:      Seno do angulo formado com o elmento e o eixo X
%   cosseno:   Cosseno do angulo formado com o elmento e o eixo X
%   h:         Altura da área do triangulo da área setorial
%   Sw:        Momento estático de primeira ordem relacionado a
%              coordenada setorial
%   w0:        Coordenada setorial equivalente, para polo no ponto 0
%   coordwb_g: Coordenadas setoriais com o polo no ponto 0, referentes ao
%              centro de gravidade
%   coord_g:   Coordenadas X e Y dos nós em relação ao centro de grtavidade
%   wb1_g:     Coordenada setorial do primeiro nó no referencial central xg e yg
%   wb2_g:     Coordenada setorial do segundo nó no referencial central xg e yg
%   xno1_g:    Coordenada X do primeiro nó no referencial central xg e yg
%   yno1_g:    Coordenada Y do primeiro nó no referencial central xg e yg
%   xno2_g:    Coordenada X do segundo nó no referencial central xg e yg
%   yno2_g:    Coordenada Y do segundo nó no referencial central xg e yg
%   Iywb_g:    Produto setorial de área relativo ao eixo Yg
%   Ixwb_g:    Produto setorial de área relativo ao eixo Xg
%   Iwb_g:     Constante de Empenamento em relação ao eixo xg e yg
%   wc:        Função de Empenamento em relação ao polo do centro de
%              cisalhamento
%
% João Alfredo de Lazzari, 27 de Setembro de 2018

%_________________________________________________________________________%


% DEFINIÇÃO DOS NÓS DE CADA ELEMENTO
no1 = elem(:,2);
no2 = elem(:,3);

xno1 = coord(no1,2); %coord(elem(:,2),1)
yno1 = coord(no1,3); %coord(elem(:,2),2)

xno2 = coord(no2,2); %coord(elem(:,3),1)
yno2 = coord(no2,3); %coord(elem(:,3),2)

t = elem(:,4); %Espessura de cada elemento

NOS = size(coord,1); % Número de nós
NEL = size(elem,1); % Número de elementos

% COMPRIMENTO DE CADA ELEMENTO
b = ( (xno2-xno1).^2 + (yno2-yno1).^2 ).^0.5;

% ÁREA DO PERFIL
Aelem = b.*t;
A = sum(Aelem);

% CENTRO DE GRAVIDADE
xmed = (xno2+xno1)./2; %Posição em X do centro de gravidade de cada elemento
ymed = (yno2+yno1)./2; %Posição em Y do centro de gravidade de cada elemento

Sy = dot(xmed,Aelem);% Momento Estático de Primeira ordem em relação ao eixo Y
Sx = dot(ymed,Aelem);% Momento Estático de Primeira ordem em relação ao eixo X
xg = Sy./A; % Posição do centro de gravidade em X em relação ao ponto 0
yg = Sx./A;% Posição do centro de gravidade em Y em relação ao ponto 0

% CONSTANTE DE TORÇÃO (Saint Venant)
J = (1./3).*(dot(b,t.^3));

% MOMENTO DE SEGUNDA ORDEM EM RELAÇÃO AO CENTRO 0
Ix0 = sum(( t.*b./12 ).*((yno2-yno1).^2 ) + Aelem.*ymed.^2 );
Iy0 = sum(( t.*b./12 ).*((xno2-xno1).^2 ) + Aelem.*xmed.^2 );
Ixy0 = sum(( t.*b./12 ).*((xno2-xno1).*(yno2-yno1)) + Aelem.*xmed.*ymed );

% MOMENTO DE SEGUNDA ORDEM EM RELAÇÃO AO CENTRO DE GRAVIDADE
Ixg = Ix0 - A.*yg.^2;
Iyg = Iy0 - A.*xg.^2;
Ixyg = Ixy0 - A.*xg.*yg;

% POSIÇÃO DO EIXO CENTRAL PRINCIPAL (em relação ao eixo x)
teta = radtodeg(atan(-2.*Ixyg./(Ixg - Iyg))./2); % Angulo de rotação do eixo x em gruas

% MOMENTO DE SEGUNDA ORDEM CENTRAIS PRINCIPAIS
I11 = (Ixg + Iyg)./2 + sqrt( ((Ixg - Iyg)./2).^2 + Ixyg.^2 );
I22 = (Ixg + Iyg)./2 - sqrt( ((Ixg - Iyg)./2).^2 + Ixyg.^2 );

% COORDENADA SETORIAL EM RELAÇÃO AO PONTO B
coordwb = zeros(NOS,1);
wmed = zeros(NEL,1);
seno = (yno2 - yno1)./b;
cosseno = (xno1 - xno2)./b;
h = xno1.*seno + yno1.*cosseno; % Altura da área do triangulo da área setorial
Sw=0;
for ii=1:NEL
    coordwb(no2(ii)) = coordwb(no1(ii)) + h(ii).*b(ii);
    wmed(ii) = ( coordwb(no2(ii)) + coordwb(no1(ii)) )./2;
    Sw = Sw + Aelem(ii).*wmed(ii);
end
w0 = Sw./A;

% COORDENADA SETORIAL EM RELAÇÃO AO CENTRO DE GRAVIDADE
coordwb_g = coordwb - w0; % Transferência do sistema de eixos x0 e y0 para o eixo xg e yg
coord_g(:,1) = coord(:,1);
coord_g(:,2) = coord(:,2) - xg;
coord_g(:,3) = coord(:,3) - yg;

wb1_g = coordwb_g(no1); %Coordenada setorial do primeiro nó no referencial central xg e yg
wb2_g = coordwb_g(no2); %Coordenada setorial do segundo nó no referencial central xg e yg
xno1_g = coord_g(no1,2); %Coordenada X do primeiro nó no referencial central xg e yg
yno1_g = coord_g(no1,3); %Coordenada Y do primeiro nó no referencial central xg e yg
xno2_g = coord_g(no2,2); %Coordenada X do segundo nó no referencial central xg e yg
yno2_g = coord_g(no2,3); %Coordenada Y do segundo nó no referencial central xg e yg

% PRODUTO SETORIAL DE ÁREA EM RELAÇÃO A X E Y E CONSTANTE DE
% EMPENAMENTO RELATIVA AO POLO NO CENTRO DE GRAVIDADE
Iywb_g = sum( (1./6).*( 2.*xno1_g.*wb1_g + 2.*xno2_g.*wb2_g + xno1_g.*wb2_g + xno2_g.*wb1_g ).*b.*t );
Ixwb_g = sum( (1./6).*( 2.*yno1_g.*wb1_g + 2.*yno2_g.*wb2_g + yno1_g.*wb2_g + yno2_g.*wb1_g ).*b.*t );
Iwb_g = sum( (1./3).*( wb1_g.^2 + wb2_g.^2 +  wb1_g.*wb2_g ).*b.*t );

% CENTRO DE CISALHAMENTO
xc = ( Ixwb_g.*Iyg - Iywb_g.*Ixyg )./( Ixg.*Iyg - Ixyg.^2 );
yc = ( Ixwb_g.*Ixyg - Iywb_g.*Ixg )./( Ixg.*Iyg - Ixyg.^2 );

% FUNÇÃO DE EMPENAMENTO COM O POLO NO CENTRO DE CISALHAMENTO
wc = coordwb_g + yc.*coord_g(:,2) - xc.*coord_g(:,3);

% CONSTANTE DE EMPENAMENTO RELATIVA AO POLO DO CENTRO DE CISALHAMENTO
Cw = Iwb_g + yc.*Iywb_g - xc.*Ixwb_g;

% RAIO DE GIRAÇÃO POLAR DA SEÇÃO BRUTA EM RELAÇÃO AOS EIXOS PRINCIPAIS DE
% INÉRCIA X E Y
r1 = sqrt(I11./A); % Raio de giração em relação ao eixo central principal 1
r2 = sqrt(I22./A); % Raio de giração em relação ao eixo central principal 2
x0 = abs(xg - xc); % Distancia em x entre o centro de cisalhamento (torção) ao centro de gravidade
y0 = abs(yg - yc); % Distancia em y entre o centro de cisalhamento (torção) ao centro de gravidade
r0 = sqrt(r1.^2 + r2.^2 + x0.^2 + y0.^2);

% MÓDULO DE RESISTÊNCIA A FLEXÃO (Considerando carregamento aplicado no
% eixo 1).
coordPrincipal(:,1) = coord_g(:,1); %Coordenadas do perfil rotacionado
coordPrincipal(:,2) = coord_g(:,2).*cos(degtorad(teta)) - coord_g(:,3).*sin(degtorad(teta)); %Coordenadas do perfil rotacionado
coordPrincipal(:,3) = coord_g(:,2).*sin(degtorad(teta)) + coord_g(:,3).*cos(degtorad(teta)); %Coordenadas do perfil rotacionado

ymaxC = abs(max(coordPrincipal(:,3))); % Distancia Máxima em y de compressão. Considerando Distancia no eixo central princiapal
xmaxC = abs(max(coordPrincipal(:,2))); % Distancia Máxima em x de compressão. Considerando Distancia no eixo central princiapal
ymaxT = abs(min(coordPrincipal(:,3))); % Distancia Máxima em y de Tração. Considerando Distancia no eixo central princiapal
xmaxT = abs(min(coordPrincipal(:,2))); % Distancia Máxima em x de Tração. Considerando Distancia no eixo central princiapal
W1C = I11./ymaxC; % Modulo de resistencia a flexao em torno do eixo principal 1, com a borda superior comprimida
W2C = I22./xmaxC; % Modulo de resistencia a flexao em torno do eixo principal 2, com a borda a direita comprimida
W1T = I11./ymaxT; % Modulo de resistencia a flexao em torno do eixo principal 1, com a borda inferior tracionada
W2T = I22./xmaxT; % Modulo de resistencia a flexao em torno do eixo principal 2, com a borda a esquerda tracionada

ycgmaxC = abs(max(coord_g(:,3)))+ t(1)./2; % Distancia Máxima em y de compressão. Considerando Distancia no eixo y
xcgmaxC = abs(max(coord_g(:,2))); % Distancia Máxima em x de compressão. Considerando Distancia no eixo x
ycgmaxT = abs(min(coord_g(:,3)))+ t(1)./2; % Distancia Máxima em y de Tração. Considerando Distancia no eixo central
xcgmaxT = abs(min(coord_g(:,2))); % Distancia Máxima em x de Tração. Considerando Distancia no eixo central
WxC = Ixg./ycgmaxC; % Modulo de resistencia a flexao em torno do eixo x, com a borda superior comprimida
WyC = Iyg./xcgmaxC; % Modulo de resistencia a flexao em torno do eixo y, com a borda a direita comprimida
WxT = Ixg./ycgmaxT; % Modulo de resistencia a flexao em torno do eixo x, com a borda inferior tracionada
WyT = Iyg./xcgmaxT; % Modulo de resistencia a flexao em torno do eixo y, com a borda a esquerda tracionada
end
