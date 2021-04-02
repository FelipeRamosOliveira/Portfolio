function [Dim,Prop]=SFIA_REF()
%% PERFIS SFIA QUE SERÃO OTIMIZADOS

%   Dimensões externas 
%Car. Per:  Fy      t   r   bw      bf     bs   fi  E
SFIA_EST=[  0.227	0.9	1.9	203.2	34.9	9.5  90 210;
            0.227	1.1	1.8	152.4	34.9	9.5  90 210;
            0.227	1.4	2.2	152.4	41.3	12.7 90 210;
            0.227	1.8	2.7	203.2	41.3	12.7 90 210;
            0.227	2.6	3.9	355.6	76.2	15.9 90 210;
            0.227	3.2	4.7	355.6	50.8	15.9 90 210]; 
        
%Perfil de calibraçã            
% SFIA_EST=[0.345 3.0 3.0 300.0   75.0    25.0 90 210;
%           0.345 3.0 3.0 300.0   75.0    25.0 90 210]; 

%   Perfil de cantos reto equivalente AISI

    fy=SFIA_EST(:,1);
    t=SFIA_EST(:,2);
    r=SFIA_EST(:,3);
    
    bw=SFIA_EST(:,4);
    bf=SFIA_EST(:,5);
    bs=SFIA_EST(:,6);
        
    fi=SFIA_EST(:,7);
    E=SFIA_EST(:,8);
    lf=bw+2*(bf+bs); 
    
%   Saída
    Prop=[E fy t  lf];
    Dim=[bw bf bs fi];
