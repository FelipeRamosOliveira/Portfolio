function []=propplot(coord,elem,xg,yg,teta)
%BWS
%October 2001
%September 2018 (last modified)
%João Alfredo de Lazzari, 27 de Setembro de 2018
% axes(axesnum)

%_________________________________________________________________________%
cla
%
%plot the nodes
plot(coord(:,2),coord(:,3),'b.')
axis('equal')
axis('off')
hold on
%
%plot the elements
for i=1:length(elem(:,1))
   %Get element geometry
	nodei = elem(i,2);	nodej = elem(i,3);
	   xi = coord(nodei,2);	   xj = coord(nodej,2);
	   yi = coord(nodei,3);	   yj = coord(nodej,3);
       theta = atan2((yj-yi),(xj-xi));
       t=elem(i,4);
       %plot the cross-section with appropriate thickness shown
       xpatch=[
        ([xi xj]+[-1 -1]*sin(theta)*t/2)',
        ([xj xi]+[1 1]*sin(theta)*t/2)'];%,
       ypatch=[
        ([yi yj]+[1 1]*cos(theta)*t/2)',
        ([yj yi]+[-1 -1]*cos(theta)*t/2)'];%,
       patch(xpatch,ypatch,'c')
       hold on
       plot([xi xj],[yi yj],'b.');
       %plot( ([xi xj]+[-1 -1]*sin(theta)*t/2),[zi zj]+[1 1]*cos(theta)*t/2 , 'k')
       %plot( ([xi xj]+[1 1]*sin(theta)*t/2),[zi zj]+[-1 -1]*cos(theta)*t/2 , 'k')
       %plot( ([xi xi]+[-1 1]*sin(theta)*t/2),[zi zi]+[1 -1]*cos(theta)*t/2 , 'k')
       %plot( ([xj xj]+[-1 1]*sin(theta)*t/2),[zj zj]+[1 -1]*cos(theta)*t/2 , 'k')
end
%
%plot the origin
plot(0,0,'k.')
text(0,0,' O')
plot([0 min(1/4*max(coord(:,3)),1/4*max(coord(:,2)))],[0 0],'k:')
plot([0 0],[0 min(1/4*max(coord(:,3)),1/4*max(coord(:,2)))],'k:')
%plot the centroid
plot(xg,yg,'g.')
text(xg,yg,' CG')
%
%Plot the Global XX and ZZ Axes
XX=[min(coord(:,2))-0.1*(max(coord(:,2))-min(coord(:,2))) , yg
    max(coord(:,2))+0.1*(max(coord(:,2))-min(coord(:,2))) , yg];
YY=[xg , min(coord(:,3)-0.1*(max(coord(:,3))-min(coord(:,3))))
    xg , max(coord(:,3)+0.1*(max(coord(:,3))-min(coord(:,3))))];
plot(XX(:,1),XX(:,2),'g--')
plot(YY(:,1),YY(:,2),'g--')
text(XX(1,1),XX(1,2),'x_g     ')
text(XX(2,1),XX(2,2),'     x_g')
text(YY(1,1),YY(1,2),'y_g')
text(YY(2,1),YY(2,2),'y_g')
%
%Plot the principal axis
%make the centroid 0,0 temporarily
XX_11=XX-[xg yg ; xg yg];
YY_22=YY-[xg yg ; xg yg];
%find the minimum arm length
arm=0.75*min(abs([XX_11(1,1);XX_11(2,1);YY_22(1,2);YY_22(2,2)]));
%set the lengths to the minimum length
XX_11=[-arm 0 ; arm 0];
YY_22=[0 -arm ; 0 arm];
%rotate
dx=arm-arm*cos(teta*pi/180);
dy=arm*sin(teta*pi/180);
XX_11=XX_11+[ dx -dy ; -dx  dy ];
YY_22=YY_22+[ dy  dx ; -dy -dx ];
%center at cg
XX_11=XX_11+[xg yg ; xg yg];
YY_22=YY_22+[xg yg ; xg yg];
%plot
plot(XX_11(:,1),XX_11(:,2),'r-.')
plot(YY_22(:,1),YY_22(:,2),'r-.')
text(XX_11(1,1),XX_11(1,2),'   1')
text(XX_11(2,1),XX_11(2,2),'1   ')
text(YY_22(1,1),YY_22(1,2),' 2 ')
text(YY_22(2,1),YY_22(2,2),' 2 ')
title({'Seção Geométrica de ';'Perfil Formado a Frio'});
hold off