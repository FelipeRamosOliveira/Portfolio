function [b,A,xg,yg,J,Ixg,Iyg,Ixyg,teta,I11,I22,xc,yc,wc,Cw,x0,y0,r0,WxC,WyC] = prop_geom_PFF(coord,elem)
%PROP_GEOM_PFF Propriedades geom�tricas de perfis formados a frio
%
%   - ENTRADA:
%   coord: � a coordenada de cada n� do perfil.
%   elem:  Matriz com os elementos, e conectividade de cada elemento, alem
%          da espessura e raio de concord�ncia entre os elementos
%   - SA�DA:
%   b:    Comprimento de cada elemento
%   A:    �rea da se��o
%   xg:   Posi��o do centro de gravidade em X em rela��o ao ponto 0
%   yg:   Posi��o do centro de gravidade em Y em rela��o ao ponto 0
%   J:    Constante de Tor��o do Perfil
%   Ixg:  Momento de Segunda ordem em rela��o ao eixo central xg
%   Iyg:  Momento de Segunda ordem em rela��o ao eixo central yg
%   Ixyg: Produto de Inercia em rela��o ao eixo central xg e yg
%   teta: Posi��o do eixo central principal, medido em rela��o ao eixo x
%         (eixo y � teta + 90)
%   I1:   Momento de Segunda ordem central principal m�ximo
%   I2:   Momento de Segunda ordem central principal m�nimo
%   xc:   Posi��o do centro de cisalhamento em X em rela��o ao ponto 0
%   yc:   Posi��o do centro de cisalhamento em Y em rela��o ao ponto 0
%   Cw:   Constante de Empenamento
%
%   - VARI�VEIS AUXILIARES:
%   no1:       Vetor com os primeiros n�s de cada elemento
%   no2:       Vetor com os segundos n�s de cada elemento
%   xno1:      Coordenada em x do primeiro n�
%   yno1:      Coordenada em y do primeiro n�
%   xno2:      Coordenada em x do segundo n�
%   yno2:      Coordenada em y do segundo n�
%   t:         Vetor com Espessura de cada elemento
%   NOS:       N�mero total de n�s
%   NEL        N�mero total de elementos
%   Aelem:     Vetor com �rea de cada elemento
%   xmed:      Posi��o em X do centro de gravidade de cada elemento
%   ymed:      Posi��o em Y do centro de gravidade de cada elemento
%   Sy:        Momento Est�tico de Primeira ordem em rela��o ao eixo Y
%   Sx:        Momento Est�tico de Primeira ordem em rela��o ao eixo X   
%   Ix0:       Momento de Segunda ordem em rela��o ao eixo x0
%   Iy0:       Momento de Segunda ordem em rela��o ao eixo y0
%   Ixy0:      Produto de Inercia em rela��o ao eixo x0 e y0
%   coordwb:   Coordenada
%   wmed:      Coordenada setorial m�dia no elemento
%   seno:      Seno do angulo formado com o elmento e o eixo X
%   cosseno:   Cosseno do angulo formado com o elmento e o eixo X
%   h:         Altura da �rea do triangulo da �rea setorial
%   Sw:        Momento est�tico de primeira ordem relacionado a
%              coordenada setorial
%   w0:        Coordenada setorial equivalente, para polo no ponto 0
%   coordwb_g: Coordenadas setoriais com o polo no ponto 0, referentes ao
%              centro de gravidade
%   coord_g:   Coordenadas X e Y dos n�s em rela��o ao centro de grtavidade
%   wb1_g:     Coordenada setorial do primeiro n� no referencial central xg e yg
%   wb2_g:     Coordenada setorial do segundo n� no referencial central xg e yg
%   xno1_g:    Coordenada X do primeiro n� no referencial central xg e yg
%   yno1_g:    Coordenada Y do primeiro n� no referencial central xg e yg
%   xno2_g:    Coordenada X do segundo n� no referencial central xg e yg
%   yno2_g:    Coordenada Y do segundo n� no referencial central xg e yg
%   Iywb_g:    Produto setorial de �rea relativo ao eixo Yg
%   Ixwb_g:    Produto setorial de �rea relativo ao eixo Xg
%   Iwb_g:     Constante de Empenamento em rela��o ao eixo xg e yg
%   wc:        Fun��o de Empenamento em rela��o ao polo do centro de
%              cisalhamento
%
% Jo�o Alfredo de Lazzari, 27 de Setembro de 2018

%_________________________________________________________________________%


% DEFINI��O DOS N�S DE CADA ELEMENTO
no1 = elem(:,2);
no2 = elem(:,3);

xno1 = coord(no1,2); %coord(elem(:,2),1)
yno1 = coord(no1,3); %coord(elem(:,2),2)

xno2 = coord(no2,2); %coord(elem(:,3),1)
yno2 = coord(no2,3); %coord(elem(:,3),2)

t = elem(:,4); %Espessura de cada elemento

NOS = size(coord,1); % N�mero de n�s
NEL = size(elem,1); % N�mero de elementos

% COMPRIMENTO DE CADA ELEMENTO
b = ( (xno2-xno1).^2 + (yno2-yno1).^2 ).^0.5;

% �REA DO PERFIL
Aelem = b.*t;
A = sum(Aelem);

% CENTRO DE GRAVIDADE
xmed = (xno2+xno1)./2; %Posi��o em X do centro de gravidade de cada elemento
ymed = (yno2+yno1)./2; %Posi��o em Y do centro de gravidade de cada elemento

Sy = dot(xmed,Aelem);% Momento Est�tico de Primeira ordem em rela��o ao eixo Y
Sx = dot(ymed,Aelem);% Momento Est�tico de Primeira ordem em rela��o ao eixo X
xg = Sy./A; % Posi��o do centro de gravidade em X em rela��o ao ponto 0
yg = Sx./A;% Posi��o do centro de gravidade em Y em rela��o ao ponto 0

% CONSTANTE DE TOR��O (Saint Venant)
J = (1./3).*(dot(b,t.^3));

% MOMENTO DE SEGUNDA ORDEM EM RELA��O AO CENTRO 0
Ix0 = sum(( t.*b./12 ).*((yno2-yno1).^2 ) + Aelem.*ymed.^2 );
Iy0 = sum(( t.*b./12 ).*((xno2-xno1).^2 ) + Aelem.*xmed.^2 );
Ixy0 = sum(( t.*b./12 ).*((xno2-xno1).*(yno2-yno1)) + Aelem.*xmed.*ymed );

% MOMENTO DE SEGUNDA ORDEM EM RELA��O AO CENTRO DE GRAVIDADE
Ixg = Ix0 - A.*yg.^2;
Iyg = Iy0 - A.*xg.^2;
Ixyg = Ixy0 - A.*xg.*yg;

% POSI��O DO EIXO CENTRAL PRINCIPAL (em rela��o ao eixo x)
teta = radtodeg(atan(-2.*Ixyg./(Ixg - Iyg))./2); % Angulo de rota��o do eixo x em gruas

% MOMENTO DE SEGUNDA ORDEM CENTRAIS PRINCIPAIS
I11 = (Ixg + Iyg)./2 + sqrt( ((Ixg - Iyg)./2).^2 + Ixyg.^2 );
I22 = (Ixg + Iyg)./2 - sqrt( ((Ixg - Iyg)./2).^2 + Ixyg.^2 );

% COORDENADA SETORIAL EM RELA��O AO PONTO B
coordwb = zeros(NOS,1);
wmed = zeros(NEL,1);
seno = (yno2 - yno1)./b;
cosseno = (xno1 - xno2)./b;
h = xno1.*seno + yno1.*cosseno; % Altura da �rea do triangulo da �rea setorial
Sw=0;
for ii=1:NEL
    coordwb(no2(ii)) = coordwb(no1(ii)) + h(ii).*b(ii);
    wmed(ii) = ( coordwb(no2(ii)) + coordwb(no1(ii)) )./2;
    Sw = Sw + Aelem(ii).*wmed(ii);
end
w0 = Sw./A;

% COORDENADA SETORIAL EM RELA��O AO CENTRO DE GRAVIDADE
coordwb_g = coordwb - w0; % Transfer�ncia do sistema de eixos x0 e y0 para o eixo xg e yg
coord_g(:,1) = coord(:,1);
coord_g(:,2) = coord(:,2) - xg;
coord_g(:,3) = coord(:,3) - yg;

wb1_g = coordwb_g(no1); %Coordenada setorial do primeiro n� no referencial central xg e yg
wb2_g = coordwb_g(no2); %Coordenada setorial do segundo n� no referencial central xg e yg
xno1_g = coord_g(no1,2); %Coordenada X do primeiro n� no referencial central xg e yg
yno1_g = coord_g(no1,3); %Coordenada Y do primeiro n� no referencial central xg e yg
xno2_g = coord_g(no2,2); %Coordenada X do segundo n� no referencial central xg e yg
yno2_g = coord_g(no2,3); %Coordenada Y do segundo n� no referencial central xg e yg

% PRODUTO SETORIAL DE �REA EM RELA��O A X E Y E CONSTANTE DE
% EMPENAMENTO RELATIVA AO POLO NO CENTRO DE GRAVIDADE
Iywb_g = sum( (1./6).*( 2.*xno1_g.*wb1_g + 2.*xno2_g.*wb2_g + xno1_g.*wb2_g + xno2_g.*wb1_g ).*b.*t );
Ixwb_g = sum( (1./6).*( 2.*yno1_g.*wb1_g + 2.*yno2_g.*wb2_g + yno1_g.*wb2_g + yno2_g.*wb1_g ).*b.*t );
Iwb_g = sum( (1./3).*( wb1_g.^2 + wb2_g.^2 +  wb1_g.*wb2_g ).*b.*t );

% CENTRO DE CISALHAMENTO
xc = ( Ixwb_g.*Iyg - Iywb_g.*Ixyg )./( Ixg.*Iyg - Ixyg.^2 );
yc = ( Ixwb_g.*Ixyg - Iywb_g.*Ixg )./( Ixg.*Iyg - Ixyg.^2 );

% FUN��O DE EMPENAMENTO COM O POLO NO CENTRO DE CISALHAMENTO
wc = coordwb_g + yc.*coord_g(:,2) - xc.*coord_g(:,3);

% CONSTANTE DE EMPENAMENTO RELATIVA AO POLO DO CENTRO DE CISALHAMENTO
Cw = Iwb_g + yc.*Iywb_g - xc.*Ixwb_g;

% RAIO DE GIRA��O POLAR DA SE��O BRUTA EM RELA��O AOS EIXOS PRINCIPAIS DE
% IN�RCIA X E Y
r1 = sqrt(I11./A); % Raio de gira��o em rela��o ao eixo central principal 1
r2 = sqrt(I22./A); % Raio de gira��o em rela��o ao eixo central principal 2
x0 = abs(xg - xc); % Distancia em x entre o centro de cisalhamento (tor��o) ao centro de gravidade
y0 = abs(yg - yc); % Distancia em y entre o centro de cisalhamento (tor��o) ao centro de gravidade
r0 = sqrt(r1.^2 + r2.^2 + x0.^2 + y0.^2);

% M�DULO DE RESIST�NCIA A FLEX�O (Considerando carregamento aplicado no
% eixo 1).
coordPrincipal(:,1) = coord_g(:,1); %Coordenadas do perfil rotacionado
coordPrincipal(:,2) = coord_g(:,2).*cos(degtorad(teta)) - coord_g(:,3).*sin(degtorad(teta)); %Coordenadas do perfil rotacionado
coordPrincipal(:,3) = coord_g(:,2).*sin(degtorad(teta)) + coord_g(:,3).*cos(degtorad(teta)); %Coordenadas do perfil rotacionado

ymaxC = abs(max(coordPrincipal(:,3))); % Distancia M�xima em y de compress�o. Considerando Distancia no eixo central princiapal
xmaxC = abs(max(coordPrincipal(:,2))); % Distancia M�xima em x de compress�o. Considerando Distancia no eixo central princiapal
ymaxT = abs(min(coordPrincipal(:,3))); % Distancia M�xima em y de Tra��o. Considerando Distancia no eixo central princiapal
xmaxT = abs(min(coordPrincipal(:,2))); % Distancia M�xima em x de Tra��o. Considerando Distancia no eixo central princiapal
W1C = I11./ymaxC; % Modulo de resistencia a flexao em torno do eixo principal 1, com a borda superior comprimida
W2C = I22./xmaxC; % Modulo de resistencia a flexao em torno do eixo principal 2, com a borda a direita comprimida
W1T = I11./ymaxT; % Modulo de resistencia a flexao em torno do eixo principal 1, com a borda inferior tracionada
W2T = I22./xmaxT; % Modulo de resistencia a flexao em torno do eixo principal 2, com a borda a esquerda tracionada

ycgmaxC = abs(max(coord_g(:,3)))+ t(1)./2; % Distancia M�xima em y de compress�o. Considerando Distancia no eixo y
xcgmaxC = abs(max(coord_g(:,2))); % Distancia M�xima em x de compress�o. Considerando Distancia no eixo x
ycgmaxT = abs(min(coord_g(:,3)))+ t(1)./2; % Distancia M�xima em y de Tra��o. Considerando Distancia no eixo central
xcgmaxT = abs(min(coord_g(:,2))); % Distancia M�xima em x de Tra��o. Considerando Distancia no eixo central
WxC = Ixg./ycgmaxC; % Modulo de resistencia a flexao em torno do eixo x, com a borda superior comprimida
WyC = Iyg./xcgmaxC; % Modulo de resistencia a flexao em torno do eixo y, com a borda a direita comprimida
WxT = Ixg./ycgmaxT; % Modulo de resistencia a flexao em torno do eixo x, com a borda inferior tracionada
WyT = Iyg./xcgmaxT; % Modulo de resistencia a flexao em torno do eixo y, com a borda a esquerda tracionada
end
