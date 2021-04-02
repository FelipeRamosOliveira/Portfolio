function [FobFinal,Dim,CurvaAG]=AG(Lb,Ub)
global cont MaxAva Lf
format bank
%% I.Parametros do AG
%Definir função objetivo
fob = @(x) OBJETIVO_S(x);

D=length(Lb);   %Dimensões
VarSize=[1 D];  %Matriz de Decisão

nPop=40;
Itera=10^6;

nc=10;          %Tamanho da prole
gamma=0.7;      %Fator extra de Crossover

nm=5;           %N° de Mutações 
mu=0.1;         %Taxa de mutação 

TTorneio=3;     %Tamanho do torneio
%% II.Inicializar
empty_individual.Posicao=[];
empty_individual.Custo=[];
pop=repmat(empty_individual,nPop,1);

for i=1:nPop
    
    % Inicializar posição
    pop(i).Posicao=(unifrnd(Lb,Ub,VarSize));
    
    % Avaliação
    x=[(pop(i).Posicao)];
    
    if fob(x)+PENALIDADE(x)>10^5
       pop(i).Custo=-(10^2);
    else
       pop(i).Custo=fob(x)+PENALIDADE(x);
    end
    
    pop(i).CustoReal=fob(x);
end

% Ordenar população
Custos=[pop.Custo];
[Custos, Ordem]=sort(Custos,'descend');
pop=pop(Ordem);

% Guardar melhor solução 
MelhorSol=pop(1);

% Vetorizar melhor solução 
MelhorCusto=zeros(Itera,1);

% Guardar todos os custos 
PiorCusto=pop(end).Custo;

%% III.Loop principal
for it=1:Itera
    %Crossever heuristc 
    % Crossover
    popc=repmat(empty_individual,nc/2,2);
    for k=1:nc/2

    i1=Torneio(pop,TTorneio);
    i2=Torneio(pop,TTorneio);
    
    % Selecionar pais 
    p1=pop(i1);
    p2=pop(i2);
        
    % Aplicar Crossover
    [popc(k,1).Posicao, popc(k,2).Posicao]=Crossover(p1.Posicao,p2.Posicao,gamma,Lb,Ub);
    % Avaliar a Prole
    x=[(popc(k,1).Posicao)];
    
    if fob([(popc(k,1).Posicao)])+PENALIDADE(x)>10^5
    popc(k,1).Custo=-(10^2);
    else
    popc(k,1).Custo=fob([(popc(k,1).Posicao)])+PENALIDADE(x);    
    end
    popc(k,1).CustoReal=fob([(popc(k,1).Posicao)]);
    
    
    if fob([(popc(k,2).Posicao)])+PENALIDADE(x)>10^5
    popc(k,2).Custo=-(10^2);
    else
    popc(k,2).Custo=fob([(popc(k,2).Posicao)])+PENALIDADE(x);    
    end
    popc(k,2).CustoReal=fob([(popc(k,2).Posicao)]);
    
           
    end
    popc=popc(:);
      
    % Mutação
    popm=repmat(empty_individual,nm,1);
    for k=1:nm
        
    % Selecionar 'pai'
    i=randi([1 nPop]);
    p=pop(i);
        
    % Applicar Mutação
    popm(k).Posicao=Mutate(p.Posicao,mu,Lb,Ub);
        
    % Avaliar Mutante
    x=[(popm(k).Posicao)];
    
    if fob([(popm(k).Posicao)])+PENALIDADE(x)>10^5
    popm(k).Custo=-(10^2);
    else     
    popm(k).Custo=fob([(popm(k).Posicao)])+PENALIDADE(x);
    end   
    popm(k).CustoReal=fob([(popm(k).Posicao)]);
    end
    
    % Criar população intermediária 
    pop=[pop; popc; popm]; %#ok
     
    % Ordenar populção  
    Custos=[pop.Custo];
    [Custos, Ordem]=sort(Custos,'descend');
    pop=pop(Ordem);
    
    % Atulizar pior avalição
    PiorCusto=max(PiorCusto,pop(end).Custo);
    
    % Truncamento
    pop=pop(1:nPop);
    Custos=Custos(1:nPop);
    
    % Salvar melhor avaliação já feita
    MelhorSol=pop(1);
    MelhorCusto(it)=MelhorSol.Custo;
    CurvaAG(it,:)=[cont MelhorCusto(it)];   
   %disp([ 'Iteração: ' num2str(it) ' |Melhor: ' num2str(MelhorSol.Custo)])
    
    % Critreio de parada Parada    
    if cont>=MaxAva,break,end    
    
end
%% IV.Saida
FobFinal=pop(1).CustoReal;
%Relções ideias
Rel=[pop(1).Posicao];
    bf=round(Lf*Rel(2),1);    %Mesa
    bs=round(bf*Rel(1),1);    %Enrijecedor de borda
    bw=Lf-2*bf-2*bs;          %Alma
%   Ãngulo de abertura
    Q=Rel(3);
    if Q>75,        Q=90;
    elseif Q>60,    Q=75;
    elseif Q>45,    Q=60;
    elseif Q>30,    Q=45;
    elseif Q>15,    Q=15;
    end   
%   Dimesões ideias    
    Dim=[bw bf bs Q];
end