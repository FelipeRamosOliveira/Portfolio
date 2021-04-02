function [coord]=gerten(coord,elem)
%
[b,A,xg,yg,J,Ixg,Iyg,Ixyg,teta,I11,I22,xc,yc,wc,Cw,x0,y0,r0,WxC,WyC] = prop_geom_PFF(coord,elem);
%
 Mxx=1;xcg=xg;Ixx=Ixg;M11=0;
 Mzz=0;zcg=yg;Izz=Iyg;M22=0;
%
Ixz=Ixyg;thetap=teta;
Py=345;
P=0;
node=coord(:,1:3);
unsymm=0; 
% 
[coord]=stresgen(coord,P,Mxx,Mzz,M11,M22,A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22,unsymm);
%
coord(:,4)=coord(:,8);
coord=coord(:,1:4);