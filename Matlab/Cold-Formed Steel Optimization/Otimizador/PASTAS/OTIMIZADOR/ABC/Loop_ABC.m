%% LOOP SECUNDÁRIO AG 
function [CURVAS_ABC,PARC_ABC]= Loop_ABC (Nrod,MRD,Lb,Ub,bw,bf,bs,Q,Prop)
global cont
format bank

for Run=1:Nrod    
    cont=0;
%%   I.APLICAR ALGORÍTIMO DE OTMIZAÇÃO  
    [FinalABC,DimABC,CurvaABC]=ABC(Lb,Ub);
    
%%   II.AVALIAR SE HOUVE OTIMIZAÇÃO
    if FinalABC<=MRD
        DimABC=[bw bf bs Q];
    end     
%%   III.RESULTADOS DA RODADA 

%   Curva Max.Ava. x Carga resistente (Acumulado em linhas) 
    CURVAS_ABC(Run,:)=[CurvaABC(:,2)'];

%   Análise MFF <-> MRD             (Acumulado em linhas)
    [R_PSO]=Avaliador(DimABC,Prop); 
    
    FinalABC=R_PSO(12);
    PARC_ABC(Run,:)=[R_PSO,(FinalABC-MRD)/MRD];    
    disp(['Rodada: ' num2str(Run) ' |Resultado(kN): ' num2str(FinalABC) ' |Otimização: ' num2str( 100*(FinalABC-MRD)/MRD) '%'])  
end