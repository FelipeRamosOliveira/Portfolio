function [FobFinal,Dim,CurvaABC]=ABC(Lb,Ub)
global cont MaxAva Lf
%% I.Parâmetros do ABC
fob=@(x) OBJETIVO_S(x);   % Custo Function
nVar=length(Lb);                    % Number of Decision Variables
VarD=[1 nVar];                   % Decision Variables Matrix Size
VarMin=Lb;                          % Decision Variables Lower Bound
VarMax=Ub;                          % Decision Variables Upper Bound

MaxIt=10^6;             % Maximum Number of Iterations
nPop=15*nVar;           % Population Size (Colony Size)
nOnlooker=nPop;         % Number of Onlooker Bees
L=round(0.6*nVar*nPop); % Abandonment Limit Parameter (Trial Limit)
a=1;                    % Acceleration Coefficient Upper Bound

%% II.Inicializar
% Empty Bee Structure
empty_bee.Posicao=[];
empty_bee.Custo=[];
% Initialize Population Array
pop=repmat(empty_bee,nPop,1);
% Initialize Melhor Solution Ever Found
MelhorSol.Custo=0;
% Create Initial Population
for i=1:nPop
pop(i).Posicao=(unifrnd(VarMin,VarMax,VarD));
pop(i).Custo=fob(pop(i).Posicao)+PENALIDADE(pop(i).Posicao);
pop(i).CustoReal=fob(pop(i).Posicao);    
if pop(i).Custo>MelhorSol.Custo
MelhorSol=pop(i);
end
end
% Abandonment Counter
C=zeros(nPop,1);

% Array to Hold Melhor Custo Values
MelhorCusto=zeros(MaxIt,1);

%% III.Lopp principal
for it=1:MaxIt    
%%  Fase1:   Abelhas recrutas
    for i=1:nPop
%   Choose k randomly, not equal to i
    K=[1:i-1 i+1:nPop];
    k=K(randi([1 numel(K)]));
%   Definir coeficiente de acaleração
    phi=a*unifrnd(-1,+1,VarD);        
%   Posição das novas abaelhas
    newbee.Posicao=abs(pop(i).Posicao+phi.*(pop(i).Posicao-pop(k).Posicao));
%   Avaliar
    newbee.Custo=fob(newbee.Posicao)+PENALIDADE(newbee.Posicao);
    newbee.CustoReal=fob(newbee.Posicao);
%   Comparar
    if newbee.Custo>pop(i).Custo
    pop(i)=newbee;
    else
    C(i)=C(i)+1;
    end       
    end
    
%   Calcular função custo e probabilidade de seleção
    F=zeros(nPop,1);
    MeanCusto = mean([pop.Custo]);
    for i=1:nPop
    F(i) = exp(-pop(i).Custo/MeanCusto); % Converter custo em "fitness"
    end
    P=F/sum(F);
    
%%   Fase 2: Abelhas obeservadoras
    for m=1:nOnlooker     
%   Select Source Site
    i=RouletteWheelSelection(P);       
%   Escolher k aleatoriamente, não igual a i
      
    K=[1:i-1 i+1:nPop];
        
%   lista_randomica=round(abs([1 numel(K)]));
    COEF=round(abs(length(K)-1));
    LL=length(K);
  
    if LL<1
        K=[1:44]
    end
    
    lista_randomica=round(abs([1 COEF]));
    k=K(randi(lista_randomica));   
    
           
%   Definir coeficente de aceleração
    phi=a*unifrnd(-1,+1,VarD);       
%    Posição das novas abelhas
     X1=pop(i).Posicao;
     X2=pop(k).Posicao; 
    
     if isempty(X1)||isempty(X2)         
     X1=pop(nPop).Posicao;
     X2=pop(round(nPop/2)).Posicao;    
     end   
     
     DELTA= X1 - X2;
     
     newbee.Posicao=abs(pop(i).Posicao+phi.*(DELTA));
      
%   Avaliar
    newbee.Custo=fob(newbee.Posicao)+PENALIDADE(newbee.Posicao);
    newbee.CustoReal=fob(newbee.Posicao);        
%   Comparar
    if newbee.Custo>=pop(i).Custo
    pop(i)=newbee;
    else
    C(i)=C(i)+1;
    end
    end
%% Fase3: Abelhas exploradoras
    for i=1:nPop
            
    if C(i)>=L
    pop(i).Posicao=(unifrnd(VarMin,VarMax,VarD));
    pop(i).Custo=fob(pop(i).Posicao)+PENALIDADE(pop(i).Posicao);
    pop(i).CustoReal=fob(pop(i).Posicao);
    C(i)=0;
    end
    end  
%   Atulizar melhor solução encontrada
    for i=1:nPop
    if pop(i).Custo>MelhorSol.Custo
    MelhorSol=pop(i);
    end
    end    
%   Salvar mehor solução
    MelhorCusto(it)=MelhorSol.Custo;
    CurvaABC(it,:)=[cont MelhorSol.Custo];
 
    %disp([ 'Iteração: ' num2str(it) ' |Melhor: ' num2str(MelhorSol.Custo)])    
    
%   Critreio de parada Parada
    if cont>=MaxAva,break,end
end
%%  IV.Saida
%   Ordenar populção
    Custos=[pop.Custo];
    [Custos, Ordem]=sort(Custos,'descend');
    pop=pop(Ordem);    
    FobFinal=pop(1).CustoReal;
    
%   Relções ideias
    Rel=[pop(1).Posicao];
    bf=round(Lf*Rel(2),1);    %Mesa
    bs=round(bf*Rel(1),1);    %Enrijecedor de borda
    bw=Lf-2*bf-2*bs;          %Alma
%   Ângulo de abertura  
    Q=Rel(3);                  
    if Q>75,        Q=90;
    elseif Q>60,    Q=75;
    elseif Q>45,    Q=60;
    elseif Q>30,    Q=45;
    elseif Q>15,    Q=15;
    end   
%   Dimensões ideias
    Dim=[bw bf bs Q];    
end