%% LOOP SECUND�RIO AG 
function [CURVAS_PSO,PARC_DE]= Loop_PSO (Nrod,MRD,Lb,Ub,bw,bf,bs,Q,Prop)
global cont
format bank

for Run=1:Nrod    
    cont=0;
%%   I.APLICAR ALGOR�TIMO DE OTMIZA��O  
    [FinalPSO,DimPSO,CurvaPSO]=APSO(Lb,Ub);
    
%%   II.AVALIAR SE HOUVE OTIMIZA��O
    if FinalPSO<=MRD
        DimPSO=[bw bf bs Q];
    end     
%%   III.RESULTADOS DA RODADA 

%   Curva Max.Ava. x Carga resistente (Acumulado em linhas) 
    CURVAS_PSO(Run,:)=[CurvaPSO(:,2)'];

%   An�lise MFF <-> MRD             (Acumulado em linhas)
    [R_PSO]=Avaliador(DimPSO,Prop); 
    
    FinalPSO=R_PSO(12);
    PARC_DE(Run,:)=[R_PSO,(FinalPSO-MRD)/MRD];    
    disp(['Rodada: ' num2str(Run) ' |Resultado(kN): ' num2str(FinalPSO) ' |Otimiza��o: ' num2str( 100*(FinalPSO-MRD)/MRD) '%'])  
end