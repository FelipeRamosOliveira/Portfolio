function [DimH,FobFinalC,TempoC]=COMPETITIVO(Lb,Ub)     
global cont MaxAva Perc contAC
%%  CLASSIFICAR MELHOR ALGORITIMO
    [MELHOR_ALG,FobFinalC,DimH]=TORNEIO_ALGO(Lb,Ub);
    MELHOR_ALG=sortrows(MELHOR_ALG,2,'descend');
    MaxAva=2500;cont=0;
    tic
%% UTLIZAR APENAS O MELHOR ALGORÍTIMO
    Perc=1;
    if     MELHOR_ALG(1,1)==1
    [FobFinalC,DimH,~]=AGH(Lb,Ub,DimH,FobFinalC);
        
    elseif MELHOR_ALG(1,1)==2  
    [FobFinalC,DimH,~]=APSOH(Lb,Ub,DimH,FobFinalC);
        
    elseif MELHOR_ALG(1,1)==3
    [FobFinalC,DimH,~]=DEH(Lb,Ub,FobFinalC,DimH);

    elseif MELHOR_ALG(1,1)==4
    [FobFinalC,DimH,~]=ABCH(Lb,Ub,FobFinalC,DimH);    
    end    
 %% RESULTADOS
   TempoC=toc/cont;
   disp(['COMPETIÇÃO-Acessos a FOB: ' num2str(cont+contAC) ' - Tempo por Iterção: ' num2str(TempoC)])  
   disp(['------------------------------------------------------------------'])  
    