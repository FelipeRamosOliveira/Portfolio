function [HistErro]=AG(D,FOB,PopEliteDE,varargin)
global contador MaxAva
%% Parametros do AG
nPop=200;               % Tamanho da população
ItMax=10000;            % Nº max de iterações 
Lb=-100;                % Limite inferior
Ub= 100;                % Limite inferior

NunFun=varargin;
VarSize=[1 D];          %  Matriz de Decisão
pc=0.7;                 % Porcetagem de Crossover
nc=2*round(pc*nPop/2);  % Tamanho da prole
gamma=0.4;              % Fator extra de Crossover

pm=0.4;                 % Percentual de Mutação 
nm=round(pm*nPop);      % N° de Mutações 
mu=0.20;                % Taxa de mutação 

TamanhoTorneio=3;       % Tamanho do torneio
TElite=5;               % Tamanho da elite
%% Inicializar

empty_individual.Posicao=[];
empty_individual.Custo=[];
pop=repmat(empty_individual,nPop,1);

for i=1:nPop
    
    % Inicializar posição
    pop(i).Posicao=unifrnd(Lb,Ub,VarSize);% 1°Modi- Ale. dist uniforme
    
    % Avaliação 
    contador=contador+1;
    pop(i).Custo=feval(FOB,[(pop(i).Posicao)]',varargin{:});
end

% Ordenar população
Custos=[pop.Custo];
[Custos, Ordem]=sort(Custos);
pop=pop(Ordem);

%Criar uma populção de elite inicial 
pelite=PopEliteDE;

% Guardar melhor solução 
MelhorSol=pop(1);

% Vetorizar melhor solução 
MelhorCusto=zeros(ItMax,1);

% Guardar todos os custos 
PiorCusto=pop(end).Custo;

%% Loop principal
for it=1:ItMax

    % 1. CROSSOVER
    popc=repmat(empty_individual,nc/2,2);
    for k=1:nc/2

    % Selecionar pais por torneio
    i1=Torneio(pop,TamanhoTorneio);
    i2=Torneio(pop,TamanhoTorneio);
    
    p1=pop(i1);
    p2=pop(i2);
           
    % Aplicar tecnica de  Crossover
    
    %2ºModi-Crossover Heuristico
    %[popc(k,1).Posicao, popc(k,2).Posicao]=CrossHeu(i1,i2,pop,p1,p2,D,Lb,Ub);  
    [popc(k,1).Posicao, popc(k,2).Posicao]=Crossover(p1.Posicao,p2.Posicao,gamma,Lb,Ub);
    
    % Avaliar a Prole Crossover
    contador=contador+1;
    popc(k,1).Custo=feval(FOB,[(popc(k,1).Posicao)]',varargin{:});
    contador=contador+1;
    popc(k,2).Custo=feval(FOB,[(popc(k,2).Posicao)]',varargin{:});       
    end
    popc=popc(:);
      
    % 2. MUTAÇÃO
    popm=repmat(empty_individual,nm,1);
    for k=1:nm
        
    % Selecionar inviduo que vai mutar 
    i=randi([1 nPop]);
    p=pop(i);
        
    % Applicar a tecnica Mutação
    popm(k).Posicao=MUTAR(p.Posicao,mu,Lb,Ub);
        
    % Avaliar Mutante
    contador=contador+1;
    popm(k).Custo=feval(FOB,[(popm(k).Posicao)]',varargin{:});    
    end
    
    % 3. CRIAR MEETING POOL
    pop=[pop; popc; popm;pelite]; %#ok
     
    % Ordenar populção  
    Custos=[pop.Custo];
    [Custos, Ordem]=sort(Custos);
    pop=pop(Ordem);
    
    % Atulizar pior avalição
    PiorCusto=max(PiorCusto,pop(end).Custo);
    
    % 4. SELECIONAR OS MAIS APTOS
    pop=pop(1:nPop);
    Custos=Custos(1:nPop);
    
    % 5.ELITISMO 
    pelite=pop(1:TElite);
    
    %Salvar melhor avaliação já feita
    MelhorSol=pop(1);
    MelhorCusto(it)=MelhorSol.Custo;
    
    %Estratégia de separação
    %Se a repostas estiverem muito próximas aumenta a explotação
    
    %Explotação
    if it>1
    Sep=abs(MelhorCusto(it)-MelhorCusto(it-1));    
    if Sep<=10^-1     
    gamma=0.8;
    else
    gamma=0.4;
    end
    end
    
    %Exploração
    if it>50
    if abs (MelhorCusto(it)-MelhorCusto(it-49))<=0.01
        mu=0.5;
    else
        mu=0.2;
    end
    end
      
    % Mostrar relção interção melhor custo (Opcional)
%     disp(['Iteração ' num2str(it) ': Melhor avalição (AG)= ' num2str(MelhorCusto(it))]);   
    
    %Erro
    fmim=NunFun{1}.*100;
    Erro=abs(min(Custos)-fmim);
    
    %Historico do erro
    He(it)=abs(min(Custos)-fmim);
    
    %Criério de parada
    if Erro<=10^-8
    break
    end
    
    if contador>=MaxAva
    break
    end       
    
    if it>100 && abs(MelhorCusto(it)-MelhorCusto(it-100))<10^-6
    break    
    end
    
    
end
%% Historico das rodadas 
if length(He)<100
    i0=1;   i1=1;
    i2=1;   i3=1;
    i4=1;   i5=1;
    i6=1;   i7=1;
    i8=1;   i9=1;
    i10=1; i11=1;
    HistErro=[He(1) He(1) He(1) He(1) He(1) He(1) He(1) He(1) He(1) He(1) He(1) He(1)];
else
    i0=1;                       % 0.0%  -Do número máximo de interações
    i1=round(length(He)*0.01);  % 1.0%  -Do número máximo de interações
    i2=round(length(He)*0.1);   % 10.0% -Do número máximo de interações
    i3=round(length(He)*0.2);   % 20.0% -Do número máximo de interações 
    i4=round(length(He)*0.3);   % 30.0% -Do número máximo de interações
    i5=round(length(He)*0.4);   % 40.0% -Do número máximo de interações
    i6=round(length(He)*0.5);   % 50.0% -Do número máximo de interações
    i7=round(length(He)*0.6);   % 60.0% -Do número máximo de interações
    i8=round(length(He)*0.7);   % 70.0% -Do número máximo de interações
    i9=round(length(He)*0.8);   % 80.0% -Do número máximo de interações
    i10=round(length(He)*0.9);  % 90.0% -Do número máximo de interações
    i11=round(length(He));      % 100 % -Do número máximo de interações
    HistErro=[He(i0) He(i1) He(i2) He(i3) He(i4) He(i5) He(i6) He(i7) He(i8) He(i9) He(i10) He(i11)];
end

end

