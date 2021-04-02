%% LOOP SECUND�RIO AG 
function [CURVAS_AC,PARC_AG]= Loop_AG (Nrod,MRD,Lb,Ub,bw,bf,bs,Q,Prop)
global cont
format bank

for Run=1:Nrod    
    cont=0;
%%   I.APLICAR ALGOR�TIMO DE OTMIZA��O  
    [FinalAG,DimAG,CurvaAG]=AG(Lb,Ub);
    
%%   II.AVALIAR SE HOUVE OTIMIZA��O
    if FinalAG<=MRD
        DimAG=[bw bf bs Q];
    end     
%%   III.RESULTADOS DA RODADA 

%   Curva Max.Ava. x Carga resistente (Acumulado em linhas) 
    CURVAS_AC(Run,:)=[CurvaAG(20:200,2)'];

%   An�lise MFF <-> MRD             (Acumulado em linhas)
    [R_AG]=Avaliador(DimAG,Prop); 
    
    FinalAG=R_AG(12);
    PARC_AG(Run,:)=[R_AG,(FinalAG-MRD)/MRD];    
    disp(['Rodada: ' num2str(Run) ' |Resultado(kN): ' num2str(FinalAG) ' |Otimiza��o: ' num2str( 100*(FinalAG-MRD)/MRD) '%'])  
end