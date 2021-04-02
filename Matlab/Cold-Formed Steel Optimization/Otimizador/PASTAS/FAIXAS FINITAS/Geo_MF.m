function [kgmf_pq] = Geo_MF(Ty1,Ty2,a,b,I,lam_p,lam_q)
%GEO_MF Matriz geométrica da membrana e de flexao
%   Detailed explanation goes here
%
%   João Alfredo de Lazzari, Fevereiro 2019  (fonte: Z. Li, June 2010)

% Montagem da Matriz referente a Estabilidade da Membrana (symmetric membrane stability matrix)
kgm_pq = (b/12)*[ (3*Ty1+Ty2)*I(5)   ,                0                    ,     (Ty1+Ty2)*I(5)    ,                 0                  ;
                        0            ,  (3*Ty1+Ty2)*I(4)/(lam_p*lam_q)     ,          0            ,  (Ty1+Ty2)*I(4)/(lam_p*lam_q)      ;   
                   (Ty1+Ty2)*I(5)    ,                0                    ,    (Ty1+3*Ty2)*I(5)   ,                 0                  ;
                        0            ,  (Ty1+Ty2)*I(4)/(lam_p*lam_q)       ,          0            ,  (Ty1+3*Ty2)*I(4)/(lam_p*lam_q) ]  ;

% Montagem da Matriz referente a Estabilidade da Flexão (symmetric flexural stability matrix)
kgf_pq = (b*I(5)/35)*[  10*Ty1+3*Ty2        ,   (15*Ty1+7*Ty2)*b/12      ,   (Ty1+Ty2)*9/4        ,  -(7*Ty1+6*Ty2)*b/12      ;
                     (15*Ty1+7*Ty2)*b/12  ,   (5*Ty1+3*Ty2)*(b^2)/24   ,   (6*Ty1+7*Ty2)*b/12   ,  -(Ty1+Ty2)*(b^2)/8       ;   
                     (Ty1+Ty2)*9/4        ,   (6*Ty1+7*Ty2)*b/12       ,    3*Ty1+10*Ty2        ,  -(7*Ty1+15*Ty2)*b/12     ;
                    -(7*Ty1+6*Ty2)*b/12   ,  -(Ty1+Ty2)*(b^2)/8        ,  -(7*Ty1+15*Ty2)*b/12  ,   (3*Ty1+5*Ty2)*(b^2)/24 ]; 


% Montanto a matriz geometrica de rigidez da membrana 
% e de flexao para um elemento.
NULO = zeros(4,4);
kgmf_pq = [ kgm_pq  NULO    ;
            NULO    kgf_pq ]; %8x8
end

