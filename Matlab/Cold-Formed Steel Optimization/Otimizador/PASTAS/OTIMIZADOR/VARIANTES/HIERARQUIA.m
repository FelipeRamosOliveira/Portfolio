function [DimH,FobFinalH,TempoH]=HIERARQUIA(Lb,Ub)     
global cont MaxAva Perc 
%%  CLASSIFICAR MELHOR ALGORITIMO
        [MELHOR_ALG,FobFinalH,DimH]=TORNEIO_ALGO(Lb,Ub);
        MaxAva=1500;cont=0;
        tic
%% 4 COLOCAÇÃO
    Perc=0.05;
    if     MELHOR_ALG(1,1)==1
        [FobFinalH,DimH,~]=AGH(Lb,Ub,DimH,FobFinalH);
        
    elseif MELHOR_ALG(1,1)==2  
        [FobFinalH,DimH,~]=APSOH(Lb,Ub,DimH,FobFinalH);
        
    elseif MELHOR_ALG(1,1)==3
        [FobFinalH,DimH,~]=DEH(Lb,Ub,FobFinalH,DimH);

    elseif MELHOR_ALG(1,1)==4
        [FobFinalH,DimH,~]=ABCH(Lb,Ub,FobFinalH,DimH);    
    end

%% 3 COLOCAÇÃO
    Perc=0.15;
    if     MELHOR_ALG(2,1)==1
        [FobFinalH,DimH,~]=AGH(Lb,Ub,DimH,FobFinalH);
        
    elseif MELHOR_ALG(2,1)==2  
        [FobFinalH,DimH,~]=APSOH(Lb,Ub,DimH,FobFinalH);
        
    elseif MELHOR_ALG(2,1)==3
        [FobFinalH,DimH,~]=DEH(Lb,Ub,FobFinalH,DimH);

    elseif MELHOR_ALG(2,1)==4
        [FobFinalH,DimH,~]=ABCH(Lb,Ub,FobFinalH,DimH);    
    end
%% 2 COLOCAÇÃO
    Perc=0.30;
    if     MELHOR_ALG(3,1)==1
        [FobFinalH,DimH,~]=AGH(Lb,Ub,DimH,FobFinalH);
        
    elseif MELHOR_ALG(3,1)==2  
        [FobFinalH,DimH,~]=APSOH(Lb,Ub,DimH,FobFinalH);
        
    elseif MELHOR_ALG(3,1)==3
        [FobFinalH,DimH,~]=DEH(Lb,Ub,FobFinalH,DimH);

    elseif MELHOR_ALG(3,1)==4
        [FobFinalH,DimH,~]=ABCH(Lb,Ub,FobFinalH,DimH);    
    end
 %% 1 COLOCAÇÃO
    Perc=0.50;
    if     MELHOR_ALG(4,1)==1
        [FobFinalH,DimH,~]=AGH(Lb,Ub,DimH,FobFinalH);
        
    elseif MELHOR_ALG(4,1)==2  
        [FobFinalH,DimH,~]=APSOH(Lb,Ub,DimH,FobFinalH);
        
    elseif MELHOR_ALG(4,1)==3
        [FobFinalH,DimH,~]=DEH(Lb,Ub,FobFinalH,DimH);

    elseif MELHOR_ALG(4,1)==4
        [FobFinalH,DimH,~]=ABCH(Lb,Ub,FobFinalH,DimH);    
    end  
    
 %% RESULTADOS
   TempoH=toc/cont;
   disp(['HIERARQUIA a FOB: ' num2str(cont) ' - Tempo por Iterção: ' num2str(TempoH)])  
   disp(['------------------------------------------------------------------'])  
    