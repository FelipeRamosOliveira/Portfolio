function [FobFinal,Dim,CurvaDE]=DE(Lb,Ub)
global cont MaxAva Lf
%% I.Parâmetros do DE
fob = @(x) OBJETIVO_S(x);
D=length(Lb);

MaxIt=10^6;
nPop=10;

VarSize=[1 D];   % Decision Variables Matrix Size

beta_min=0.1;       % Lower Bound of Scaling Factor
beta_max=1.922;     % Upper Bound of Scaling Factor
pCR=0.4862;         % Crossover Probability

%% II.Inicializar

empty_individual.Posicao=[];
empty_individual.Custo=[];
MelhorSol.Custo=-Inf;
popDe=repmat(empty_individual,nPop,1);

for i=1:nPop

    popDe(i).Posicao=(unifrnd(Lb,Ub,VarSize));    
    popDe(i).Custo=fob([(popDe(i).Posicao)])+PENALIDADE([(popDe(i).Posicao)]);
    popDe(i).CustoReal=fob([(popDe(i).Posicao)]); 

if popDe(i).Custo>MelhorSol.Custo
    MelhorSol=popDe(i);
end

end

MelhorCusto=ones(MaxIt,1).*MelhorSol.Custo;

%% III.Loop principal
for it=1:MaxIt
    
for i=1:nPop     
    x=popDe(i).Posicao;
    A=randperm(nPop);        
    A(A==i)=[];
    a=A(1);
    b=A(2);
    c=A(3);

    % Mutação
    beta=unifrnd(beta_min,beta_max);
    %beta=unifrnd(beta_min,beta_max,VarSize);
    y=(popDe(a).Posicao+beta.*(popDe(b).Posicao-popDe(c).Posicao));
    y = max(y, Lb);
    y = min(y, Ub);

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
%   Gerar nova solução
    NewSol.Posicao=z;
    NewSol.Custo=fob([NewSol.Posicao])+PENALIDADE([(NewSol.Posicao)]);
    NewSol.CustoReal=fob([NewSol.Posicao]);
    
%   Se a nova solução for melhor que o membro da população
    if NewSol.Custo>=popDe(i).Custo
    popDe(i)=NewSol;
    
%   Se a nova solução for a melhor solução
    if popDe(i).Custo>=MelhorSol.Custo       
    MelhorSol=popDe(i);
    end
    
    end

end 
% Atulizar Melhor Custo
MelhorCusto(it)=MelhorSol.Custo;


% Salvar melhor avaliação já feita
MelhorSol=popDe(1);
MelhorCusto(it)=MelhorSol.Custo;
CurvaDE(it,:)=[cont MelhorCusto(it)];  

%disp([ 'Iteração: ' num2str(it) ' |Melhor: ' num2str(MelhorSol.Custo)])

%Critreio de parada Parada
if cont>=MaxAva,break,end
end

%%  IV.Saida
% Ordenar populção  
Custos=[popDe.Custo];
[~, Ordem]=sort(Custos,'descend');
popDe=popDe(Ordem);
FobFinal=popDe(1).CustoReal;

%Relções ideias
Rel=[popDe(1).Posicao];
bf=round(Lf*Rel(2),1);    %Mesa
bs=round(bf*Rel(1),1);    %Enrijecedor de borda
bw=Lf-2*bf-2*bs;          %Alma
%Ângulo de abertura  
Q=Rel(3);                  
if Q>75,        Q=90;
elseif Q>60,    Q=75;
elseif Q>45,    Q=60;
elseif Q>30,    Q=45;
elseif Q>15,    Q=15;
end   
%Dimensões ideias
Dim=[bw bf bs Q];
end