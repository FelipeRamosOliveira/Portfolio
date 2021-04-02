%%  TORNEIO DE ALGORTIMOS EVULOCIONÁRIOS
    function [MELHOR_ALG,FinalABC,Dim]=TORNEIO_ALGO(Lb,Ub)
    global   cont MaxAva contAC
    MaxAva=150;contAC=0;
%%  ALGORÍTIMOS DE OTIMIZAÇÃO    
%   AG
   tic 
   cont=0;
   [FinalAG,~,~]=AG(Lb,Ub);
   contAC=contAC+cont;
    %
   TempoR=toc/cont;    
   disp(['AG-Acessos a FOB: ' num2str(cont) ' - Tempo por Iterção: ' num2str(TempoR)])       
%   APSO 
    tic 
    cont=0;
   [FinalAPSO,~,~]=APSO(Lb,Ub);
   contAC=contAC+cont;
    %
   TempoR=toc/cont;
   disp(['APSO-Acessos a FOB: ' num2str(cont) ' - Tempo por Iterção: ' num2str(TempoR)])   
%   DE 
   tic 
   cont=0;
   [FinalDE,~,~]=DE(Lb,Ub);
   contAC=contAC+cont;
    %
   TempoR=toc/cont;
   disp(['DE-Acessos a FOB: ' num2str(cont) ' - Tempo por Iterção: ' num2str(TempoR)])   
%   ABC   
   tic 
   cont=0;
   [FinalABC,Dim,~]=ABC(Lb,Ub);
   contAC=contAC+cont;
    %
   TempoR=toc/cont;
   disp(['ABC-Acessos a FOB: ' num2str(cont) ' - Tempo por Iterção: ' num2str(TempoR)])   
%%  AVALIAR MELHOR ALGORTIMO

   MELHOR_ALG=[1 FinalAG;2 FinalAPSO;3 FinalDE;4 FinalABC]; 
   MELHOR_ALG=sortrows(MELHOR_ALG,2);
