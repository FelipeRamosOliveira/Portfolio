%%  MULTI OBJECTIVE PARTICLE SWARM OPTIMIZATION (MPSO)
%% 1.PRINCIPAL 
function [Pcr,Dim,Lb,Ub]=PSO3(Lb,Ub,Nint,Npop,Gamma,Nrod)
%Passo 1.1:   Iniciar contador
global cont Contagem
cont=0;

%Passo 1.2:   Par�metros do PSO  
para=[Npop Nint Gamma];     %Par�metros b�sicos 
fot=[0];                    %Ot�mo arb�trio | x=fot || Maximiza��o
gb=[zeros(length(Lb),1)'];  %Posi��o do ot�mo arbitr�rio 

%Passo 1.3:   Chamar PSO
%Nessa vers�o o c�digo aprende com as rodas anteriores atulizando fot e gb
%por rodada 

for i=1:Nrod
[gb,fot]=pso_pri(@fob,@ctr,Lb,Ub,para,fot,gb);
%Resultados 
Pcr(i,1)=fot;   %Valor da fun��o otmizada  
Dim(i,:)=[gb];  %Dimens�es otimizadas 
%Carga_min=min(Pcr)
end

Contagem=cont;

%% 2.FUN��O OJETIVO-(fob|fval|u)
function f=fob(x)
global cont 
%Passo 2.1: Definir a entrada a fun��o f(X) onde X(x(1),x(2)...x(n))
f = @(x) OBJETIVO(x);
%Passo 2.2: Calcular f(X) pro veto X
f = OBJETIVO(x);
%Passo 2.3: Contar os acessos a fun��o obejetivo
 cont=1+cont;

%% 3.RESTRI��ES-(ctr)
function [g,FacEsp]=ctr(x)
global Lf
%% Inequa��es e equa��es
%%Aumento de eros�o 
%
bf=x(1);
bs= x(2);
bw=Lf-2.*bs-2.*bf;
%
%Restri��es baseados nas limita��es do calculo de Matsubara
g(1)=bs./abs(bw)>=0.1;        
g(2)=bs./abs(bw)<=0.3;        

g(3)=bf./abs(bw)>=0.4;     
g(4)=bf./abs(bw)<=1.0;     

g(5)=bw>=0;

%Se verdadeiro g(i)=1 se falso g(i)=0
%Restri��o especial (quando uma restri��o gera eliman��o sum�ria do perfil)
pg(1)=g(1);
pg(2)=g(2);
pg(3)=g(3);
pg(4)=g(4);
pg(5)=g(5);
FacEsp=prod(pg);

%% 4.PSO 
function [gb,fot]=pso_pri(fob,ctr,Lb,Ub,para,fot,gb)
%Passo 4.1: Decompor o vetor de par�metros do PSO
% Amplitude de particulas alfa=[0,1]
% Velocidade de conv (0->1)=(lento->r�pido) || beta=0.5 
npart=para(1); ints=para(2); gamma=para(3);
alfa=0.2; beta=0.5;   
  
%Passo 4.2:   Posi��o inicial das particulas
% O ot�mo inicial � um chute dentro de (UB-Lb)||otm=chute
otm=ini_pso(npart,Lb,Ub);   

%Passo 4.3:     Processo de avali��o de fob emoviment��o das particulas 
for t=1:ints    %Dentro do pseudo-tempo (t)|N� de iter��es
    
    
%Passo 4.4:     Calcular fob e, caso necess�rio, aplicar as puni��es 
%por restri��o violada    
for i=1:npart
[z,y]=Fun(fob,ctr,otm(i,:));
fval (i)=z;
freal(i)=y;
end

%Passo 4.5:     Atulizar melhor particula 
indice=min(find(fval == max(fval(:)))); %calcular indice da a particula melhor posicionada 
if fval(indice)>=fot               %avaliar  valor da fun��o para cada particula  
gb=otm(indice,:);                  %se fval>fot | gb=chute -> vetor de par�metros   
fot=freal(indice);                  %um novo �timo � estabelecido 
end                  

%Passo 4.6:     Redu��o de aletoriedade  
alfa=newPara(alfa,gamma);

%Passo 4.7:     Mover particulas para melhor posi��o     
otm=pso_move(otm,gb,alfa,beta,Lb,Ub);  

%Passo 4.8:     Curva de conveg�ncia(Opcional)
% global Conver
% Conver(t,:)=[t fot];
end

%% 5.SUBFUN��ES
%Subfun��o 5.1 |Passo 4.2: Posi��o inicial das particulas
function [chute]=ini_pso(n,Lb,Ub)
ndim=length(Lb);                        %N� de dimens�es do problema
chute=(Lb+rand(n,ndim).*(Ub-Lb));  %Chutar dentro de (Ub-Lb)

%Subfun��o  5.2 |Passo 4.4: Aplicar as restri��es 
function [z,y]=Fun(fob,ctr,u)
[g,FacEsp]=ctr(u);                              %Call crt. vec
Peso=1./length(g);                              %Calc. peso do erro 
FacRedu=sum(ones((length(g)-sum(g)),1).*Peso);  %Fator de redu��o
Penalidade=(1-FacRedu).*FacEsp;                 %Penalidade total 
%
y=fob(u);       %Chamar a Fun��o Objetivo
z=y*Penalidade; %Aplicar penalidade sobre fob 

%Subfun��o  5.3 |Passo 4.6: Reduzir a aletoriedade 
function alfa=newPara(alfa,gamma)
alfa=alfa.*gamma;

%Subfun��o  5.4 |Passo 4.7: Mover particulas  
function ns=pso_move(otm,gb,alf,beta,Lb,Ub)
n=size(otm,1); ndim=size(otm,2);esc=(Ub-Lb);
ns=(otm+beta.*(gb-otm)+alf.*randn(n,ndim).*esc);%Equ.de movimento
%Impor limites (Se a particula ultrapassar um dos limites ela volta pro Lb)
Inferior=ns>=Lb;Superior=ns<=Ub;

VoltaInferior=Inferior==0;
RepoI=VoltaInferior.*Lb;

VoltaSuperior=Superior==0;
RepoS=VoltaSuperior.*Lb;

ns=ns.*Inferior.*Superior+RepoI+RepoS;
%% ----------------------------FIM DO PSO----------------------------