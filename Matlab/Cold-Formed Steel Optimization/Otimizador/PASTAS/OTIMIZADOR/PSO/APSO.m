%% 1.PRINCIPAL 
function [FobFinal,Dim,CurvaAPSO]=APSO(Lb,Ub)
global Lf
%Passo 1.1:   Parâmetros do PSO  
    
Nint=10^6;           % INTERAÇÕE
Npop=100;             % POPULAÇÃO DO ENXAME  
Nrod=1;              % NÚMERO DE RODADAS
Gamma=0.85;          % FATOR DE ACELERAÇÃO 
    
para=[Npop Nint Gamma];       %Parâmetros básicos 
fot=[-Inf];                   %Otímo arbítrio | x=fot || Maximização
gb=Lb;

%Passo 1.2:   Chamar APSO
for i=1:Nrod
[gb,fot,CurvaAPSO]=pso_pri(@fob,@ctr,Lb,Ub,para,fot,gb);
%Resultados 
FobFinal(i,1)=fot;   %Valor da função otmizada  

Rel=[gb];
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


%% 2.FUNÇÃO OJETIVO-(fob|fval|u)
function f=fob(x)
%Passo 2.1: Definir a entrada a função f(X) onde X(x(1),x(2)...x(n))
f = @(x) OBJETIVO_S(x);
%Passo 2.2: Calcular f(X) pro veto X
f = OBJETIVO_S(x);

%% 3.RESTRIÇÕES-(ctr)
function [P]=ctr(x)
global Lf LD LL PCONT
%   Definir constante de penalidade
    Constante=10^3;
%%  I.TORNAR VETOR DE VARIÁVEIS EM PARÂMETROS GEOMÉTRICOS 
    bf=round(Lf*x(2),1);    %Mesa
    bs=round(bf*x(1),1);    %Enrijecedor de borda
    bw=Lf-2*bf-2*bs;        %Alma
    Q=x(3);                 %Ãngulo de abertura

%%   II.PARÂMETROS INDIRETOS  
    Neta=bf/bw;
    Mi=bs/bw;
    Beta=bs/bf;
    Lambda_Max=max([LD LL]);
%%  III.Inequações
%   Restrições de fabricação
    
    c(1)=0;
    if bw>400 || bw<100
    c(1)=abs(Lf-bw)*Constante;
    end
    
    c(2)=0;
    if bf>400 || bf<30
    c(2)=abs(Lf-bf)*Constante;
    end
    
    c(3)=0;   
    if bs>40 || bs<10
    c(3)=abs(Lf-bs)*Constante;
    end
    
    c(3)=0;   
    if bs>40 || bs<10
    c(3)=abs(Lf-bs)*Constante;
    end
    
    c(4)=0;
    if mod(Q,15)>0
    c(4)=abs(90-Q)*Constante/100;
    end    
    
%   Restrições normativas e logicas 

    c(5)=0;
if Neta>1 || Neta <0.3
    c(5)=Neta*Lf*Constante;
end

    c(6)=0;
if  Mi>0.4 ||Mi<0.1
    c(6)=Mi*Lf^2*Constante;
end

    c(7)=0;
if  Beta>0.7 ||Beta<0.2
    c(7)=Beta*Lf*Constante;
end

    c(8)=0;   
if Lambda_Max>2.5
    c(8)=abs(Lambda_Max-2.5)*Constante;
end   

    c(9)=0;   
if PCONT>10^6
    c(8)=10^10;
end   

%% CALCULAR PENALIDADE
P=abs(sum(c));
P=-P;

%% 4.PSO 
function [gb,fot,CurvaAPSO]=pso_pri(fob,ctr,Lb,Ub,para,fot,gb)
global cont MaxAva
%Passo 4.1: Decompor o vetor de parâmetros do PSO
% Amplitude de particulas alfa=[0,1]
% Velocidade de conv (0->1)=(lento->rápido) || beta=0.5 
npart=para(1); ints=para(2); gamma=para(3);
alfa=0.2; beta=0.7;   
  
%Passo 4.2:   Posição inicial das particulas
% O otímo inicial é um chute dentro de (UB-Lb)||otm=chute
otm=ini_pso(npart,Lb,Ub);   

%Passo 4.3:     Processo de avalição de fob emovimentção das particulas 
for t=1:ints    %Dentro do pseudo-tempo (t)|Nº de iterções
    
    
%Passo 4.4:     Calcular fob e, caso necessário, aplicar as punições 
%por restrição violada    
for i=1:npart
[z,y]=Fun(fob,ctr,otm(i,:));
fval (i)=z;
freal(i)=y;
end

%Passo 4.5:     Atulizar melhor particula 
indice=min(find(fval == max(fval(:)))); %calcular indice da a particula melhor posicionada 
if fval(indice)>=fot                    %avaliar  valor da função para cada particula  
gb=otm(indice,:);                       %se fval>fot | gb=chute -> vetor de parâmetros   
fot=freal(indice);                      %um novo ótimo é estabelecido 
end                  
CurvaAPSO(t,:)=[cont fot];

%Passo 4.6:     Redução de aletoriedade  
alfa=newPara(alfa,gamma);

%Passo 4.7:     Mover particulas para melhor posição     
otm=pso_move(otm,gb,alfa,beta,Lb,Ub);  
%disp([ 'Iteração: ' num2str(t) ' |Melhor: ' num2str(fot)])

%Passo 4.8:     Critério de parada (Critério absoluto Média=Máximo)
if cont>=MaxAva,break,end
end

%% 5.SUBFUNÇÕES

%Subfunção  5.1 |Passo 4.2: Posição inicial das particulas
function [chute]=ini_pso(n,Lb,Ub)
ndim=length(Lb);                   %Nº de dimensões do problema
chute=(Lb+rand(n,ndim).*(Ub-Lb));  %Chutar dentro de (Ub-Lb)

%Subfunção  5.2 |Passo 4.4: Aplicar as restrições 
function [z,y]=Fun(fob,ctr,u)
[Penalidade]=ctr(u);                %Call crt. vec
y=fob(u);                           %Chamar a Função Objetivo
z=y+Penalidade;                     %Aplicar penalidade sobre fob 

%Subfunção  5.3 |Passo 4.6: Reduzir a aletoriedade 
function alfa=newPara(alfa,gamma)
alfa=alfa.*gamma;

%Subfunção  5.4 |Passo 4.7: Mover particulas  
function ns=pso_move(otm,gb,alf,beta,Lb,Ub)
n=size(otm,1); ndim=size(otm,2);esc=(Ub-Lb);
ns=round(otm+beta.*(gb-otm)+alf.*rand(n,ndim).*esc);%Equ.de movimento

%Impor limites (Volta ao domínio de soluções)
ns=max(ns,Lb);
ns=min(ns,Ub);