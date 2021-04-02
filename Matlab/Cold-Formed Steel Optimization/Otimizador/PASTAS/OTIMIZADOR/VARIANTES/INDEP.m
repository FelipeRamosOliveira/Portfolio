function [DimAG,FinalAG,TempoAG,DimAPSO,FinalAPSO,TempoAPSO,DimDE,FinalDE,TempoDE,DimABC,FinalABC,TempoABC]=INDEP(Lb,Ub)
global  cont
%%  AG
   tic 
   cont=0;
   [FinalAG,DimAG,CurvaAG]=AG(Lb,Ub);
    %
   TempoAG=toc/cont;    
   disp(['AG-Acessos a FOB: ' num2str(cont) ' - Tempo por Iterção: ' num2str(TempoAG)])
   save('Curva-AG','CurvaAG')
%% APSO 
    tic 
    cont=0;
   [FinalAPSO,DimAPSO,CurvaAPSO]=APSO(Lb,Ub);
    %
   TempoAPSO=toc/cont;
   disp(['APSO-Acessos a FOB: ' num2str(cont) ' - Tempo por Iterção: ' num2str(TempoAPSO)])   
   save('Curva-APSO','CurvaAPSO')
%% DE 
   tic 
   cont=0;
   [FinalDE,DimDE,CurvaDE]=DE(Lb,Ub);
    %
   TempoDE=toc/cont;
   disp(['DE-Acessos a FOB: ' num2str(cont) ' - Tempo por Iterção: ' num2str(TempoDE)])   
   save('Curva-DE','CurvaDE')
   
%% ABC   
   tic 
   cont=0;
   [FinalABC,DimABC,CurvaABC]=ABC(Lb,Ub);
    %
   TempoABC=toc/cont;
   disp(['ABC-Acessos a FOB: ' num2str(cont) ' - Tempo por Iterção: ' num2str(TempoABC)])    
   save('Curva-ABC','CurvaABC')   
   
 disp(['-------------------------------------------------------------------'])  