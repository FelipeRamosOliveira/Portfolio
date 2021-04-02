clc
%Geral
global prop lengths node elem
%Propriedades geométricas
global A xcg zcg I11 I22 Cw J Xs Ys thetap
global CURVA 
for i=1:length(CURVA) 
Comprimento_Pcr(i,:)=min(CURVA{1,i});
end
%% 1.PROPRIEDADES
%Material
E=prop(1,2);G=E/(2*(1+0.3));fy=345;
%Geometria
r1=(I11/A)^0.5;r2=(I22/A)^0.5;
x0=xcg-Xs;y0=zcg-Ys;
r0=sqrt(r1^2+r2^2+x0^2+y0^2);
L=Comprimento_Pcr(:,1);
Mcr=Comprimento_Pcr(:,2);
%Modulo RESITENCIA ELASTICA
%% Rotação 
coord=node(:,1:3);
co_cg(:,1)=coord(:,1);
co_cg(:,2) = coord(:,2) - xcg;
co_cg(:,3) = coord(:,3) - zcg;
%
co_p(:,1)=co_cg(:,1);
co_p(:,2)=co_cg(:,2)*cos(degtorad(thetap))- co_cg(:,3)*sin(degtorad(thetap));
co_p(:,3)=co_cg(:,3)*sin(degtorad(thetap))+ co_cg(:,3)*cos(degtorad(thetap));
%
ymaxC=abs(max(co_p(:,3)));xmaxC=abs(max(co_p(:,2)));
ymaxT=abs(min(co_p(:,3)));xmaxT=abs(min(co_p(:,2)));
Wc=I11./ymaxC;

%% 2.Flambagem com torção lateral
[Mre]=MRE(L,E,I11,I22,r0,x0,y0,Cw,G,J,A,fy,Wc);
Mre=Mre';
%% 3.Flambagem local
Ml=min(Mcr)*fy*A;
[Mrl]=MRL(Ml,Mre);
Mrl=Mrl';
%% 4.Flambagem distorcional 
MI_MA=MAX_MIN(L,Mcr,1);MI_MA=sort(MI_MA(:,2));
Md=(MI_MA(2));
[Mrdist]=MRDIST(Md,Wc,fy);

%% 5.RESISTÊNCIA CARCTERISTICA 
for i=1:length(Mre)
Mrk(i)=min(Mre(i),Mrl(i));
if Mrk(i)>Mrdist;
    Mrk(i)=Mrdist;
end
RESULTADO(i,:)=[Mre(i) Mrl(i) Mrdist Mrk(i)];
end
display(RESULTADO,'    Mre      Mrl      Mrdist      Mrk');




