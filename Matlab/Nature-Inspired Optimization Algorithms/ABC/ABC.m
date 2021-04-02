function [HistErro]=ABC(D,FOB,varargin)       
global contador MaxAva
%% Problem Definition

nVar=D;              % Number of Decision Variables
VarSize=[1 nVar];    % Decision Variables Matrix Size

VarMin=-100;         % Decision Variables Lower Bound
VarMax= 100;         % Decision Variables Upper Bound

%% ABC Settings

MaxIt=10000;             % Maximum Number of Iterations
nPop=18*D;               % Population Size (Colony Size)

nOnlooker=nPop;         % Number of Onlooker abelhas
L=round(0.6*nVar*nPop); % Abandonment Limit Parameter (Trial Limit)

a=1;                    % Acceleration Coefficient Upper Bound

%% Initialization

% Empty abelha Structure
empty_abelha.Posicao=[];
empty_abelha.Custo=[];

% Initialize Population Array
pop=repmat(empty_abelha,nPop,1);

% Initialize Melhor Solution Ever Found
MelhorSol.Custo=inf;

% Create Initial Population
for i=1:nPop
    pop(i).Posicao=unifrnd(VarMin,VarMax,VarSize);
    contador=contador+1;
    pop(i).Custo= feval (FOB,[pop(i).Posicao]',varargin{:});
    if pop(i).Custo<=MelhorSol.Custo
        MelhorSol=pop(i);
    end
end

% Abandonment Counter
C=zeros(nPop,1);

% Array to Hold Melhor Custo Values
MelhorCusto=zeros(MaxIt,1);

%% ABC Main Loop

for it=1:MaxIt
    
    % Recruited abelhas
    for i=1:nPop
        
        % Choose k randomly, not equal to i
        K=[1:i-1 i+1:nPop];
        k=K(randi([1 numel(K)]));
        
        % Define Acceleration Coeff.
        phi=a*unifrnd(-1,+1,VarSize);
        
        % nova abelha Posicao
        novaabelha.Posicao=pop(i).Posicao+phi.*(pop(i).Posicao-pop(k).Posicao);
        
        % Evaluation
        contador=contador+1;
        novaabelha.Custo= feval (FOB,[novaabelha.Posicao]',varargin{:});
        
        % Comparision
        if novaabelha.Custo<=pop(i).Custo
            pop(i)=novaabelha;
        else
            C(i)=C(i)+1;
        end
        
    end
    
    % Calculate Fitness Values and Selection Probabilities
    F=zeros(nPop,1);
    MediaCusto = mean([pop.Custo]);
    for i=1:nPop
        F(i) = exp(-pop(i).Custo/MediaCusto); % Convert Custo to Fitness
    end
    P=F/sum(F);
    
    % Onlooker abelhas
    for m=1:nOnlooker
        
        % Select Source Site
        i=RouletteWheelSelection(P);
        
        % Choose k randomly, not equal to i
        K=[1:i-1 i+1:nPop];
        k=K(randi([1 numel(K)]));
        
        % Define Acceleration Coeff.
        phi=a*unifrnd(-1,+1,VarSize);
        
        % nova abelha Posicao
        novaabelha.Posicao=pop(i).Posicao+phi.*(pop(i).Posicao-pop(k).Posicao);
        
        % Evaluation
        contador=contador+1;
        novaabelha.Custo= feval (FOB,[novaabelha.Posicao]',varargin{:});
        
        
        % Comparision
        if novaabelha.Custo<=pop(i).Custo
            pop(i)=novaabelha;
        else
            C(i)=C(i)+1;
        end
        
    end
    
    % Scout abelhas
    for i=1:nPop
        if C(i)>=L
            pop(i).Posicao=unifrnd(VarMin,VarMax,VarSize);
            contador=contador+1;
            pop(i).Custo= feval (FOB,[pop(i).Posicao]',varargin{:});
            C(i)=0;
        end
    end
    
    % Update Melhor Solution Ever Found
    for i=1:nPop
        if pop(i).Custo<=MelhorSol.Custo
            MelhorSol=pop(i);
        end
    end
    
    % Store Melhor Custo Ever Found
    MelhorCusto(it)=MelhorSol.Custo;
    
    % Display Iteration Information
%     disp(['Iteração(ABC) ' num2str(it) ': Melhor Custo = ' num2str(MelhorCusto(it))]);
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
end
