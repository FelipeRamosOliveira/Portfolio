%% CÁLCULO DAS PROPRIEDADES GOMÉTRICAS DA SEÇÃO
function [A,xg,yg,I1,I2,Cw,J,x0,y0,r0,teta,xc,yc,wc]=PropSec(node,elem)
%% VETORES AUXILIARES
noi = elem(:,2);noj = elem(:,3);xi = node(noi,2);yi = node(noi,3);xj = node(noj,2); 
yj = node(noj,3);dx=(xj-xi);dy=(yj-yi);xmed = (xj+xi)/2;ymed = (yj+yi)/2;
t = elem(:,3);nn = size(node,1);nel = size(elem,1); 

%% PROPRIEDADES DOS ELEMNETOS DA SEÇÃO
%Comprimento dos elementos da seção(l)
l = ( dx.^2 + dy.^2 ).^0.5;
%Senos e Cossenos dos elementos da seção
sen = (yj-yi)./l;
cos = (xi-xj)./l;
%Área dos elementos (Ai) e total da seção (A)
Ai = l.*t;
A = sum(Ai);

%% CONSTANTE DE TORÇÃO (Jp)
J = (1/3)*(dot(l,t.^3));

%% CENTRO DE GRAVIDADE (CG)
%Primeiro momento estático de área em relação ao eixo Y (Iy)
Sy = dot(xmed,Ai);
%Primeiro momento estático de área em relação ao eixo X (Ix)
Sx = dot(ymed,Ai);
%Centro de gravidade 
xg = Sy/A;
yg = Sx/A;

%% MOMENTOS DE INERCIA (Segundo momento estático de área)
% Momento de inercia em relação ao pornto "o" 
Ixo = sum(( t.*l./12 ).*(dy.^2 ) + Ai.*ymed.^2 );
Iyo = sum(( t.*l./12 ).*(dx.^2 ) + Ai.*xmed.^2 );
Ixyo = sum(( t.*l./12 ).*(dx.*dy) + Ai.*xmed.*ymed );

% Momento de incercia em relação ao CG
Ixg = Ixo - A*yg^2;
Iyg = Iyo - A*xg^2;
Ixyg = Ixyo - A*xg*yg;

% Posição do eixo principal em relação ao eixo X
teta = radtodeg(atan(-2*Ixyg/(Ixg - Iyg))/2);

% Momentos de inercias principais (Imax,Imin)
I1 = (Ixg + Iyg)/2 + sqrt( ((Ixg - Iyg)/2)^2 + Ixyg^2 );
I2 = (Ixg + Iyg)/2 - sqrt( ((Ixg - Iyg)/2)^2 + Ixyg^2 );

%% nodeENADAS SETORIAIS
nodewb = zeros(nn,1);
wmed = zeros(nel,1);
% Altura da área do triangulo da área setorial
h = xi.*sen + yi.*cos;
Sw=0;
for k=1:nel
    nodewb(noj(k)) = nodewb(noi(k)) + h(k)*l(k);
    wmed(k) = ( nodewb(noj(k)) + nodewb(noi(k)) )/2;
    Sw = Sw + Ai(k)*wmed(k);
end
w0 = Sw/A;
%%nodeenada global em relação ao centro de gravidade 
% Transferência do sistema de eixos xo e yo para o eixo xg e yg
Wcg = nodewb - w0; 
co_cg(:,2) = node(:,2) - xg;
co_cg(:,3) = node(:,3) - yg;
 %nodeenada setorial do primeiro nó no referencial central xg e yg
wbi = Wcg(noi);
 %nodeenada setorial do segundo nó no referencial central xg e yg
wbj = Wcg(noj);
%nodeenada X do primeiro nó no referencial central xg e yg
xwi = co_cg(noi,2);
 %nodeenada Y do primeiro nó no referencial central xg e yg
ywi = co_cg(noi,3);
 %nodeenada X do segundo nó no referencial central xg e yg
xwj = co_cg(noj,2);
 %nodeenada Y do segundo nó no referencial central xg e yg
ywj = co_cg(noj,3);

%% PRODUTO SETORIAL DE ÁREA EM RELAÇÃO A X E Y E CONSTANTE DE 
%%EMPENAMENTO RELATIVA AO POLO NO CENTRO DE GRAVIDADE

Iwy_cg = sum( (1/6)*( 2*xwi.*wbi + 2*xwj.*wbj + xwi.*wbj + xwj.*wbi ).*l.*t );
Iwx_cg = sum( (1/6)*( 2*ywi.*wbi + 2*ywj.*wbj + ywi.*wbj + ywj.*wbi ).*l.*t );
Iww_cg = sum( (1/3)*( wbi.^2 + wbj.^2 +  wbi.*wbj ).*l.*t );

%% CENTRO DE CISALHAMENTO (CC)
xc = ( Iwx_cg*Iyg - Iwy_cg*Ixyg )/( Ixg*Iyg - Ixyg^2 );
yc = ( Iwx_cg*Ixyg - Iwy_cg*Ixg )/( Ixg*Iyg - Ixyg^2 );
%Função de empanamento  relativa o polo de cisalhamento
wc = Wcg + yc*co_cg(:,2) - xc*co_cg(:,3);

%% CONSTANTE DE EMPENAMENTO 
Cw = Iww_cg + yc*Iwy_cg - xc*Iwx_cg;

%% RAIO POLAR DE GIRAÇÃO
r1=(I1/A)^0.5;
r2=(I2/A)^0.5;
x0=xg-xc;
y0=yg-yc;
r0=sqrt(r1^2+r2^2+x0^2+y0^2);

% %% PLOT DA SEÇÃO
% %Plotar seção
% if plotar==1
% figure (1)
% subplot(4,4,[1 2 5 6 9 10 13 14])
% plotsec(node,elem,xg,yg,teta) 
% %Plotar empenamento
% subplot(4,4,[3 4 7 8 11 12 15 16])
% scale=1;
% plotwarp(node,elem,scale,xc,yc,wc)
% end




