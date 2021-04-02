%% ROTINA QUE TRANSFORMA PARÂMETROS EM COORDENADAS (X,Y)
%Rotina feita especificamente para o perfil Ue e Ze de cantos retos

function [node,elem]=para_coord(h,b1,b2,d1,d2,q1,q2,t)
%Determina se o perfil é Ue (1) ou Ze (-1)
cz=1;
%   Converter graus em radianos
q1=q1*pi/180;
q2=q2*pi/180;

%   Cantos totalmennte retos (Nº fixo de elementos)    
        geom=[ 1    b1+d1*cos(q1)                   d1*sin(q1)
               2    b1+(d1/2)*cos(q1)              (d1/2)*sin(q1)
               3    b1                              0
               4    b1*(3/4)                        0
               5    b1*(1/2)                        0
               6    b1*(1/4)                        0
               7    0                               0
               8    0                               h*(1/4)
               9    0                               h*(1/2)
               10   0                               h*(3/4)
               11   0                               h
               12   cz*b2*(1/4)                     h
               13   cz*b2*(1/2)                     h
               14   cz*b2*(3/4)                     h
               15   cz*b2                           h
               16   cz*(b2+(d2/2)*cos(q2))          h-(d2/2)*sin(q2)
               17   cz*(b2+d2*cos(q2))              h-d2*sin(q2)      ];
%   Coordenadas            
for i=1:length(geom)
   node(i,:)=[geom(i,1) geom(i,2) geom(i,3) 1 1 1 1 1.0];    
end
%   Elementos
for i=1:size(node,1)-1
   elem(i,:)=[i i i+1 t 100];     
end