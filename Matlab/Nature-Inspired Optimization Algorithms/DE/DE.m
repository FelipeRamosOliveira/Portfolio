function [HistErro]=DE(D,FOB,varargin)       
global contador MaxAva
%% I.CARCTERISTICAS DO PROLEMA
MaxIt=100000;
nPop=200;

VarMin=-100;
VarMax=100;
VarSize=[1 D];   % Decision Variables Matrix Size
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
    popDe(i).Custo=feval(FOB,[(popDe(i).Posicao)]',varargin{:});
    if popDe(i).Custo<MelhorSol.Custo
        MelhorSol=popDe(i);
    end   
end
MelhorCusto=ones(MaxIt,1).*Inf;

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
        NewSol.Custo=feval(FOB,[NewSol.Posicao]',varargin{:});
        
        if NewSol.Custo<=popDe(i).Custo
            popDe(i)=NewSol;
            
            if popDe(i).Custo<=MelhorSol.Custo
               MelhorSol=popDe(i);
            end
        end
        
    end
    
    % Update Best Custo
    MelhorCusto(it)=MelhorSol.Custo;
    
    % Show Iteration Information
%     disp(['Iteraçõa ' num2str(it) ': Melhor Custo(De)= ' num2str(MelhorCusto(it))]);
    
    if it>5
    if abs(MelhorCusto(it)-MelhorCusto(it-4))<=0.01
    pCR=0.6;
    else
    pCR=0.3;
    end
    end
    
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

%% V.Historico das rodadas 
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
