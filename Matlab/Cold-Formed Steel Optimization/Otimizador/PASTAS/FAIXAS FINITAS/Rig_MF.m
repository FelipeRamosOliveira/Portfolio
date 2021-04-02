function [kmf_pq] = Rig_MF(E1,E2,Dx,Dy,D1,Dxy,G,vx,I,t,b,lp,lq)
%RIG_MF Matriz elastica de rigidez da membrana e de flexao
%   Detailed explanation goes here
%
%
%   João Alfredo de Lazzari, Fevereiro 2019  (fonte: Z. Li, June 2010)

% Matriz elastica de rigidez correspondente à membrana (estado
% plano de tensao)
km_pq = t*[ E1*I(1)/b + G*b*I(5)/3              ,      -E2*vx*I(3)/(2*lq) - G*I(5)/(2*lq)       ,   -E1*I(1)/b + G*b*I(5)/6               ,    -E2*vx*I(3)/(2*lq) + G*I(5)/(2*lq)      ;
           -E2*vx*I(2)/(2*lp) - G*I(5)/(2*lp)   ,       E2*b*I(4)/(3*lp*lq) + G*I(5)/(b*lp*lq)  ,    E2*vx*I(2)/(2*lp) - G*I(5)/(2*lp)    ,     E2*b*I(4)/(6*lp*lq) - G*I(5)/(b*lp*lq) ;
           -E1*I(1)/b + G*b*I(5)/6              ,       E2*vx*I(3)/(2*lq) - G*I(5)/(2*lq)       ,    E1*I(1)/b + G*b*I(5)/3               ,     E2*vx*I(3)/(2*lq) + G*I(5)/(2*lq)      ;                                                                            
           -E2*vx*I(2)/(2*lp) + G*I(5)/(2*lp)   ,       E2*b*I(4)/(6*lp*lq) - G*I(5)/(b*lp*lq)  ,    E2*vx*I(2)/(2*lp) + G*I(5)/(2*lp)    ,     E2*b*I(4)/(3*lp*lq) + G*I(5)/(b*lp*lq)];

% Matriz elastica de rigidez correspondente a flexao
kf_pq_1 = Dx*I(1)*840*[      +6         ,  +3*b         ,  -6          ,   +3*b           ;
                             +3*b       ,  +2*b^2       ,  -3*b        ,   +1*b^2         ;
                             -6         ,  -3*b         ,  +6          ,   -3*b           ;
                             +3*b       ,  +1*b^2       ,  -3*b        ,   +2*b^2 ]       ;  %Symetric

kf_pq_2 = D1*b^2*14*[        -36*I(2)   ,  -33*b*I(2)   ,  +36*I(2)    ,   -3*b*I(2)      ;
                             -33*b*I(3) ,  -4*b^2*I(2)  ,  +3*b*I(2)   ,   +1*b^2*I(2)    ;
                             +36*I(2)   ,  +3*b*I(2)    ,  -36*I(2)    ,   +33*b*I(2)     ;
                             -3*b*I(2)  ,  +1*b^2*I(2)  ,  +33*b*I(3)  ,   -4*b^2*I(2) ]  ;  %Non Symetric 14

kf_pq_3 = D1*b^2*14*[        -36*I(3)   ,  -3*b*I(3)    ,  +36*I(3)    ,   -3*b*I(3)      ;
                             -3*b*I(2)  ,  -4*b^2*I(3)  ,  +3*b*I(3)   ,   +1*b^2*I(3)    ;
                             +36*I(3)   ,  +3*b*I(3)    ,  -36*I(3)    ,   +3*b*I(3)      ;
                             -3*b*I(3)  ,  +1*b^2*I(3)  ,  +3*b*I(2)   ,   -4*b^2*I(3) ]  ;  %Non Symetric 14

kf_pq_4 = Dy*I(4)*b^4*[      +156       ,   +22*b       ,    +54       ,  -13*b           ;
                             +22*b      ,  +4*b^2       ,  +13*b       , -3*b^2           ;
                             +54        ,   +13*b       ,   +156       ,  -22*b           ;
                             -13*b      , -3*b^2        , -22*b        ,  +4*b^2  ]       ;  %Symetric

kf_pq_5 = Dxy*I(5)*b^2*56*[  +36        ,   +3*b        ,  -36         ,   +3*b           ;
                             +3*b       , +4*b^2        , -3*b         ,  -b^2            ;
                             -36        ,  -3*b         ,   +36        ,  -3*b            ;
                             +3*b       ,  -b^2         , -3*b         , +4*b^2  ]        ;  %Symetric

kf_pq = (kf_pq_1 + kf_pq_2 + kf_pq_3 + kf_pq_4 + kf_pq_5)/(420*b^3);

% Montanto a Matriz elastica de rigidez da membrana e de flexao
% para um elemento em coordenadas locais
NULO = zeros(4,4);
kmf_pq = [ km_pq  NULO
           NULO   kf_pq ]; %8x8

end

