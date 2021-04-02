function [HistErro]=FA(D,FOB,varargin) 
global contador MaxAva
%% Problem Definition
nVar=D;                 % Number of Decision Variables

VarSize=[1 nVar];       % Decision Variables Matrix Size

VarMin=-100;            % Decision Variables Lower Bound
VarMax= 100;             % Decision Variables Upper Bound

%% vagalume Algorithm Parameters

MaxIt=1000;         % Maximum Number of Iterations
nPop=18*D;          % Number of Fireflies (Swarm Size)
gamma=1;            % Light Absorption Coefficient
beta0=2;            % Attraction Coefficient Base Value
alpha=0.2;          % Mutation Coefficient
alpha_damp=0.98;    % Mutation Coefficient Damping Ratio
delta=0.05*(VarMax-VarMin);     % Uniform Mutation Range
m=2;
if isscalar(VarMin) && isscalar(VarMax)
    dmax = (VarMax-VarMin)*sqrt(nVar);
else
    dmax = norm(VarMax-VarMin);
end

%% Initialization

% Empty vagalume Structure
vagalume.Posicao=[];
vagalume.Custo=[];

% Initialize Population Array
pop=repmat(vagalume,nPop,1);

% Initialize Melhor Solution Ever Found
MelhorSol.Custo=inf;

% Create Initial Fireflies
for i=1:nPop
   pop(i).Posicao=unifrnd(VarMin,VarMax,VarSize);
   pop(i).Custo= feval (FOB,[pop(i).Posicao]',varargin{:});   
   if pop(i).Custo<=MelhorSol.Custo
   MelhorSol=pop(i);
   end
end

% Array to Hold Melhor Custo Values
MelhorCusto=zeros(MaxIt,1);

%% vagalume Algorithm Main Loop

for it=1:MaxIt
    
    novapop=repmat(vagalume,nPop,1);
    for i=1:nPop
    novapop(i).Custo = inf;
    for j=1:nPop
    if pop(j).Custo < pop(i).Custo
    rij=norm(pop(i).Posicao-pop(j).Posicao)/dmax;
    beta=beta0*exp(-gamma*rij^m);
    e=delta*unifrnd(-1,+1,VarSize);
                
    novasol.Posicao = pop(i).Posicao ...
    + beta*rand(VarSize).*(pop(j).Posicao-pop(i).Posicao) ...
    + alpha*e;
                
    novasol.Posicao=max(novasol.Posicao,VarMin);
    novasol.Posicao=min(novasol.Posicao,VarMax);
       
    novasol.Custo= feval (FOB,[novasol.Posicao]',varargin{:});   
                
    if novasol.Custo <= novapop(i).Custo
    novapop(i) = novasol;
    if novapop(i).Custo<=MelhorSol.Custo
    MelhorSol=novapop(i);
    end
    end          
    end
    end
    end
    
    % Merge
    pop=[pop
         novapop];  %#ok
    
    % Sort
    [~, SortOrder]=sort([pop.Custo]);
    pop=pop(SortOrder);
    
    % Truncate
    pop=pop(1:nPop);
    
    % Store Melhor Custo Ever Found
    MelhorCusto(it)=MelhorSol.Custo;
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Melhor Custo = ' num2str(MelhorCusto(it))]);
    
    % Damp Mutation Coefficient
    alpha = alpha*alpha_damp;
    
   %Erro
    NunFun=varargin;
    fmim=NunFun{1}.*100;
    Erro=abs(MelhorCusto(it)-fmim);
    
    %Historico do erro
    He(it)=abs(MelhorCusto(it)-fmim);
    
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
