function Salvar_Curvas (Curvas,Algor)
    
%%  TABELAS EM EXCEL    
%   Titulo     
     if     Algor==1
         TEXTO='CAG';
     elseif Algor==2
         TEXTO='CDE';
     elseif Algor==3
         TEXTO='CPSO';  
     elseif Algor==4
         TEXTO='CABC';        
     end
    %
    Titulo=[TEXTO,'-', date,'.csv'];    
    csvwrite(Titulo,Curvas)