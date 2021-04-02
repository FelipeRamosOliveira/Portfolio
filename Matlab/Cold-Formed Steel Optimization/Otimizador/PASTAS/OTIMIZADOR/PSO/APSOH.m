%% 1.PRINCIPAL 
function [FobFinal,Dim,CurvaAPSO]=APSOH(Lb,Ub,DimP,FobFinalP)
%Passo 1.1:   Parâmetros do PSO  
    
Nint=100;               % INTERAÇÕE
Npop=18*length(Lb);     % POPULAÇÃO DO ENXAME  
Nrod=1;                 % NÚMERO DE RODADAS
Gamma=0.95;             % FATOR DE ACELERAÇÃO 
    
para=[Npop Nint Gamma];       %Parâmetros básicos 
fot=[FobFinalP];               %Otímo arbítrio | x=fot || Maximização
% gb=[zeros(length(Lb),1)'];  %Posição do otímo arbitrário 
gb=DimP;

%Passo 1.2:   Chamar APSO
for i=1:Nrod
[gb,fot,CurvaAPSO]=pso_pri(@fob,@ctr,Lb,Ub,para,fot,gb);
%Resultados 
FobFinal(i,1)=fot;   %Valor da função otmizada  
Dim(i,:)=[gb];       %Dimensões otimizadas 
end


%% 2.FUNÇÃO OJETIVO-(fob|fval|u)
function f=fob(x)
%Passo 2.1: Definir a entrada a função f(X) onde X(x(1),x(2)...x(n))
f = @(x) OBJETIVO(x);
%Passo 2.2: Calcular f(X) pro veto X
f = OBJETIVO(x);

%% 3.RESTRIÇÕES-(ctr)
function [g,FacEsp]=ctr(x)
global Lf
%% Inequações e equações
%
bf=x(1);
bs= x(2);
bw=Lf-2.*bs-2.*bf;
%
%Restrições baseados nas limitações do calculo de Matsubara
g(1)=bs./abs(bw)>=0.10;        
g(2)=bs./abs(bw)<=0.40;        

g(3)=bf./abs(bw)>=0.25;     
g(4)=bf./abs(bw)<=1.05;     

g(5)=bw>=0;
g(6)=bs./abs(bw)<=0.43;

%Se verdadeiro g(i)=1 se falso g(i)=0
%Restrição especial (quando uma restrição gera elimanção sumária do perfil)
pg(1)=g(5);
pg(2)=g(6);
pg(3)=g(4);
FacEsp=prod(pg);

%% 4.PSO 
function [gb,fot,CurvaAPSO]=pso_pri(fob,ctr,Lb,Ub,para,fot,gb)
global cont MaxAva Perc
%Passo 4.1: Decompor o vetor de parâmetros do PSO
% Amplitude de particulas alfa=[0,1]
% Velocidade de conv (0->1)=(lento->rápido) || beta=0.5 
npart=para(1); ints=para(2); gamma=para(3);
alfa=0.2; beta=0.5;   
  
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

%Passo 4.8:     Critério de parada (Critério absoluto Média=Máximo)

Minimo=mean(fval);
Maximo=max(fval);

if Maximo~=0 && t>2
   Conrv=abs(Maximo-Minimo);
if Conrv <=0.5 || cont>=MaxAva*Perc
   break
end 
end
end

%% 5.SUBFUNÇÕES

%Subfunção  5.1 |Passo 4.2: Posição inicial das particulas
function [chute]=ini_pso(n,Lb,Ub)
ndim=length(Lb);                   %Nº de dimensões do problema
chute=round(Lb+rand(n,ndim).*(Ub-Lb));  %Chutar dentro de (Ub-Lb)

%Subfunção  5.2 |Passo 4.4: Aplicar as restrições 
function [z,y]=Fun(fob,ctr,u)
[g,FacEsp]=ctr(u);                              %Call crt. vec
Peso=1./length(g);                              %Calc. peso do erro 
FacRedu=sum(ones((length(g)-sum(g)),1).*Peso);  %Fator de redução
Penalidade=(1-FacRedu).*FacEsp;                 %Penalidade total 
%
y=fob(u);       %Chamar a Função Objetivo
z=y*Penalidade; %Aplicar penalidade sobre fob 

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