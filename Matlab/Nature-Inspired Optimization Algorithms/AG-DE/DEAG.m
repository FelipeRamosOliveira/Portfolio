function [popDe]=DEAG(nVar,CustoFunction,varargin)
global contador
%% I.CARCTERISTICAS DO PROLEMA
MaxIt=2;
nPop=10;

VarMin=-100;
VarMax=100;
VarSize=[1 nVar];   % Decision Variables Matrix Size
%% II.PARÂMETROS DO DE 
beta_min=0.2;   % Lower Bound of Scaling Factor
beta_max=0.8;   % Upper Bound of Scaling Factor
pCR=0.3;        % Crossover Probability

%% II.INICIALIZAR
vazio_individual.Posicao=[];
vazio_individual.Custo=[];
MelhorSol.Custo=inf;
popDe=repmat(vazio_individual,nPop,1);

for i=1:nPop
    contador=contador+1;
    popDe(i).Posicao=unifrnd(VarMin,VarMax,VarSize);
    popDe(i).Custo=feval(CustoFunction,[(popDe(i).Posicao)]',varargin{:});
    if popDe(i).Custo<MelhorSol.Custo
        MelhorSol=popDe(i);
    end   
end
MlehorCusto=ones(MaxIt,1).*Inf;

%% IV.LOOP DO DE
for it=1:MaxIt    
    for i=1:nPop      
        x=popDe(i).Posicao;        
        A=randperm(nPop);        
        A(A==i)=[];
        
        a=A(1);
        b=A(2);
        c=A(3);
        
        % Mutação
        beta=unifrnd(beta_min,beta_max,VarSize);
        y=popDe(a).Posicao+beta.*(popDe(b).Posicao-popDe(c).Posicao);
        y = max(y, VarMin);
		y = min(y, VarMax);
		
        % Crossover
        z=zeros(size(x));
        j0=randi([1 numel(x)]);
        for j=1:numel(x)
            if j==j0 || rand<=pCR
                z(j)=y(j);
            else
                z(j)=x(j);
            end
        end
        
        NewSol.Posicao=z;
        contador=contador+1;
        NewSol.Custo=feval(CustoFunction,[NewSol.Posicao]',varargin{:});
        
        if NewSol.Custo<=popDe(i).Custo
            popDe(i)=NewSol;
            
            if popDe(i).Custo<=MelhorSol.Custo
               MelhorSol=popDe(i);
            end
        end
        
    end
    
    % Update Best Custo
    MlehorCusto(it)=MelhorSol.Custo;
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Melhor Custo(De)= ' num2str(MlehorCusto(it))]);
    
    if it>5
    if abs(MlehorCusto(it)-MlehorCusto(it-4))<=0.01
    pCR=0.6;
    else
    pCR=0.3;
    end
    end
end
contador
