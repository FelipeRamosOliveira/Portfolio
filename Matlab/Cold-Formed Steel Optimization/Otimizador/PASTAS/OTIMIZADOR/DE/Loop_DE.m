%% LOOP SECUND�RIO AG 
function [CURVAS_DE,PARC_DE]= Loop_DE (Nrod,MRD,Lb,Ub,bw,bf,bs,Q,Prop)
global cont
format bank

for Run=1:Nrod    
    cont=0;
%%   I.APLICAR ALGOR�TIMO DE OTMIZA��O  
    [FinalDE,DimDE,CurvaDE]=DE(Lb,Ub);
    
%%   II.AVALIAR SE HOUVE OTIMIZA��O
    if FinalDE<=MRD
        DimDE=[bw bf bs Q];
    end     
%%   III.RESULTADOS DA RODADA 

%   Curva Max.Ava. x Carga resistente (Acumulado em linhas) 
    CURVAS_DE(Run,:)=[CurvaDE(:,2)'];

%   An�lise MFF <-> MRD             (Acumulado em linhas)
    [R_DE]=Avaliador(DimDE,Prop); 
    
    FinalDE=R_DE(12);
    PARC_DE(Run,:)=[R_DE,(FinalDE-MRD)/MRD];    
    disp(['Rodada: ' num2str(Run) ' |Resultado(kN): ' num2str(FinalDE) ' |Otimiza��o: ' num2str( 100*(FinalDE-MRD)/MRD) '%'])  
end