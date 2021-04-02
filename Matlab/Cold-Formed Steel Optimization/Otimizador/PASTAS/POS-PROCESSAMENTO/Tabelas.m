%% RESULTADOS
function Tabelas (Matriz_Resultado,Algor)
    %Matriz de resultados
%   [ E fy L Lf t FOB bf bs theta LambdaL LambdaD LambdaG Norma Gustavo cont temp]
%   Transforma em vetores colunas 

% 
%  REF=[L E fy A Py Lf t bw bf bs q MRD RLD PL LL PD LD PG LG ];
 
    L=Matriz_Resultado(:,1);        E=Matriz_Resultado(:,2);  
    fy=Matriz_Resultado(:,3);       A=Matriz_Resultado(:,4); 
    Py=Matriz_Resultado(:,5);       Lf=Matriz_Resultado(:,6);
    t=Matriz_Resultado(:,7);        bw=Matriz_Resultado(:,8);
    bf=Matriz_Resultado(:,9);       bs=Matriz_Resultado(:,10);
    q=Matriz_Resultado(:,11);       MRD=Matriz_Resultado(:,12);
    RDL=Matriz_Resultado(:,13);     PL=Matriz_Resultado(:,14);
    LL=Matriz_Resultado(:,15);      PD=Matriz_Resultado(:,16);
    LD=Matriz_Resultado(:,17);      PG=Matriz_Resultado(:,18);
    LG=Matriz_Resultado(:,19);      OT=Matriz_Resultado(:,20);

    
%%  TABELAS EM EXCEL    
%   Titulo     
     if     Algor==1
         TEXTO='AG';
     elseif Algor==2
         TEXTO='DE';
     elseif Algor==3
         TEXTO='PSO';  
     elseif Algor==4
         TEXTO='ABC';  
    elseif Algor==5
         TEXTO='SFIA';       
     end
    %
    Titulo=[TEXTO,'-', date,'.csv']; 
    fid = fopen(Titulo,'wt');    
    %Cabeceira
    fprintf(fid,'	L	;	E	;	fy	;	A	;	Py	;	Lf	;	t	;	bw	;	bf	;	bs	;	Q ;	MRD	;	MRD(L-D);	PL	;	LL	;	PD	;	LD	;	PG	;	LG	;	OT	');
    %Dados
    for K=1:length(Matriz_Resultado(:,1))
    fprintf(fid,'\n  %.3f;%.3f;%.3f;%.3f;%.3f;%.3f;%.3f;%.3f;%.3f;%.3f;%.3f;%.3f;%.3f;%.3f;%.3f;%.3f;%.3f;%.3f;%.3f;%.3f',...
                      L(K),E(K),fy(K),A(K,1),Py(K),Lf(K),t(K),bw(K), bf(K),bs(K),q(K),MRD(K),RDL(K),PL(K),LL(K),PD(K),LD(K),PG(K),LG(K),OT(K));
    end  
    fclose(fid);