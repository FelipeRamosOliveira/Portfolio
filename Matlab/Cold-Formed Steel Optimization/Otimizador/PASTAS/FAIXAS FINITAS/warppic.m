function []=warppic(node,elem,scale,Xs,Ys,w,perfil)
%Badri Hiriyur
%2002
% João Alfredo de Lazzari, 27 de Setembro de 2018
%node: [node# x z dofx dofz dofy dofrot stress] nnodes x 8;
%elem: [elem# nodei nodej t] nelems x 4;
%axes(axesnum)
%[A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22]=grosprop(node,elem);

%_________________________________________________________________________%
cla
%
maxwarp=max(abs(w(1,:)));
warp=[node(:,1) w/maxwarp];
maxoffset=scale*1/10*max(max(abs(node(:,2:3))));
for i=1:length(warp(:,1))
   warpcoord(i,1:3)=[node(i,1) node(i,2)+maxoffset*warp(i,2)...
         node(i,3)-maxoffset*warp(i,2)];
end
%
%
%
axis('equal')
axis('off')
%title('Warping function Distribution')
hold on
for i=1:length(elem(:,1))
   nodei = elem(i,2);
   nodej = elem(i,3);
   xi = node(find(node(:,1)==nodei),2);
   yi = node(find(node(:,1)==nodei),3);
   xj = node(find(node(:,1)==nodej),2);
   yj = node(find(node(:,1)==nodej),3);
%
        theta = atan2((yj-yi),(xj-xi));
       t=elem(i,4);
       %plot the cross-section with appropriate thickness shown
       xpatch=[
        ([xi xj]+[-1 -1]*sin(theta)*t/2)',
        ([xj xi]+[1 1]*sin(theta)*t/2)'];%,
       zpatch=[
        ([yi yj]+[1 1]*cos(theta)*t/2)',
        ([yj yi]+[-1 -1]*cos(theta)*t/2)'];%,
       patch(xpatch,zpatch,'c')
       hold on
       %plot([xi xj],[zi zj],'b.');
%
    snodei = elem(i,2);
   snodej = elem(i,3);
   sxi = warpcoord(find(node(:,1)==nodei),2);
   szi = warpcoord(find(node(:,1)==nodei),3);
   sxj = warpcoord(find(node(:,1)==nodej),2);
   szj = warpcoord(find(node(:,1)==nodej),3);
   plot([xi xj],[yi yj],'k',[sxi sxj],[szi szj],'r',...
      [xi sxi],[yi szi],'r',[xj sxj],[yj szj],'r')
end

for i=1:length(node(:,1))
   if w(i)>=0
      plot(node(i,2),node(i,3),'r.','markersize',12)
      hold on
   else
      plot(node(i,2),node(i,3),'b.','markersize',12)
      hold on
   end
end


x0=Xs;%+xcg;
y0=Ys;%+zcg;
plot(x0,y0,'m+');
text(x0-0.2*(max(node(:,2))-min(node(:,2))),y0,'CC');

plot(0,0,'k.')
text(0,0,' O')
plot([0 min(1/4*max(node(:,3)),1/4*max(node(:,2)))],[0 0],'k:')
plot([0 0],[0 min(1/4*max(node(:,3)),1/4*max(node(:,2)))],'k:')


plot([0 x0],[0 0],'g--')
plot([x0 x0],[0 y0],'g--')
plot(x0,0,'x');
text(x0/2,0,'x_c');
text(x0,y0/2,'y_c');

title({'Coordenada Setorial';' (Função de Empenamento) \omega'});
hold off
