%%  MULTI OBJECTIVE PARTICLE SWARM OPTIMIZATION (MPSO)
%% I.PRINCIPAL 
function [Pcr,Dim]=PSO(Lb,Ub,Nint,Npop,Gamma,Nrod)
%Passo 1:   Iniciar contador
global cont Contagem
cont=0;
%Passo 2:   Limites  
Lb=Lb;
Ub=Ub;
%Passo 3:   N� Particulas, N� de Inter��es e Peso  
para=[Npop Nint Gamma];
fot=0; %Ot�mo arb�trio | x=fot || Maximiza��o
gb=0;
%Passo 4:   Chamar rotina de PSO

for i=1:Nrod%N� de rodadas || Vers�o autoajustav�l
[gb,fot]=pso_pri(@fob,@ctr,Lb,Ub,para,fot,gb);

%1.3.1. Resultados 
Pcr(i,1)=fot;   %Valor da fun��o otmizada  
Dim(i,:)=[gb];  %Dimens�es otimizadas 
end
%Carga_min=min(Pcr)
Contagem=cont;
%--------------------------------------------------------------------------

%% II.FUN��O OJETIVO-(fob)
function f=fob(x)
global cont 
f = @(x) OBJETIVO(x);
f = OBJETIVO(x);
%Contador de acessos a fun��o obejetivo
 cont=1+cont;
%--------------------------------------------------------------------------

%% III.RESTRI��ES-(ctr)
function [g,geq,pg,pgeq]=ctr(x)
global Lf
%% Crit�rios 
%%Inequa��es
g=[];
%
bf=x(1);
D= x(2);
bw=Lf-2.*D-2.*bf;
%
%Restri��es baseados no Professor Edurado 
% g(1)=D/(bw)-0.6;        % |D<0.6*bw| Garante um trabalho razo�vel do enrijecedor 
% g(2)=2*D/abs(bw)-1;     % Garante o n�o fechamento da se��o 
% g(3)=bf/abs(bw)-0.9;    % |bf<0.9bw| Garante mesas n�o maiores que a alma 

%Restri��es baseados nas limita��es do calculo de Matsubara
g(1)=D./(bw)-0.3;           % |D<0.6*bw| Garante a validade das equa��es  
g(2)=2.*D./abs(bw)-0.6;     % Garante o n�o fechamento da se��o
g(3)=bf./abs(bw)-1;         % |bf<=bw| Garante a validade das equa��es 

%Cada erro tem impacto diferente sobre o problema ,nesse casso n�o
%adimite-se o erro erro de fechamento ent�o s�o atribuidos pesos diferentes
%para diferentes tipos de erros : se o erro � inadimiss�vel=1 at� 
%toler�vel=0 | elimin��o=1

%Peso do erro 
pg(1)=1.00;
pg(2)=1.00;
pg(3)=1.00;

%%Equa��es
geq=[];
%geq(1)=bs>0;
geq(1)=bw>=0;
%Peso do erro 
pgeq=[];
pgeq(1)=1;
%pgeq(2)=0.5;
%--------------------------------------------------------------------------

%% IV.PSO 
function [gb,fot]=pso_pri(fob,ctr,Lb,Ub,para,fot,gb)
%Passo 5:   Par�metros do PSO
% Amplitude de particulas alfa=[0,1]
% Velocidade de conv (0->1)=(lento->r�pido) || beta=0.5 
npart=para(1); ints=para(2); gamma=para(3);
alfa=0.2; beta=0.5;   
  
%Passo 6:   Posi��o inicial das particulas 
otm=ini_pso(npart,Lb,Ub);   % otm=chute

%Passo 7:   Melhor arbit�rio (Altera��o)
%fot=0;      %Se x>0 | x=fot || Maximiza��o 

%Passo 8:   Processo iterativo e avalitivo

%Sub-passo 8.1:   Pseudo tempo
%Todos os passos seguintes est�o dentro do n�mero de intera��es
%por conveni�ncia foram separados

for t=1:ints,
%Sub-passo 8.2:   N� de particulas
for i=1:npart,
    
%Sub-passo 8.3:   Aplicar as resrti��es n-dimensionias (+SCOMPLEXO)
fval=Fun(fob,ctr,otm(i,:)); %otm=u ||z=fval-> valor da fun��o objetivo 

%Sub-passo 8.4:   Atulizar melhor particula 
if fval>=fot,     %avaliar  valor da fun��o para cada particula  
gb=otm(i,:);      %se fval>fot | gb=chute -> vetor de par�metros   
fot=fval;         %um novo �timo � estabelecido 
else 
fot=fot;
gb=gb;
end   
end               %fim da avali��o das particulas

%Sub-passo 8.5:   Redu��o de aletoriedade  
alfa=newPara(alfa,gamma);

%Sub-passo 8.6:   Mover particulas para melhor posi��o     
otm=pso_move(otm,gb,alfa,beta,Lb,Ub);  

%Curva de conveg�ncia
global Conver
Conver(t,:)=[t fot];
end
%Fim do programa principal 
%--------------------------------------------------------------------------

%% V.SUBFUN��ES

%Passo 6: Posi��o inicial das particulas
function [chute]=ini_pso(n,Lb,Ub)
%Sub-passo 6.1:N� de dimens�es do problema
ndim=length(Lb);
%Sub-passo 6.2:Chutar valores inicias dos par�metros dentro do limites 
for i=1:n,
chute(i,1:ndim)=round(Lb+rand(1,ndim).*(Ub-Lb));
end

%Sub-passo 8.6: Mover todas as particulas 
function ns=pso_move(otm,gb,alf,beta,Lb,Ub)
%Sub-passo 8.6.1:Equ��o de movimento 
n=size(otm,1); 
ndim=size(otm,2);
esc=(Ub-Lb);
for i=1:n,
ns(i,:)=round(otm(i,:)+beta.*(gb-otm(i,:))+alf.*randn(1,ndim).*esc);
end
ns=range(ns,Lb,Ub);

%Sub-passo 8.6.1:Limites 
function ns=range(ns,Lb,Ub)
Ajuste=ns(:,1);
n=length(Ajuste);
%n=2;% Linhas da Matriz de limites 
for i=1:n,
  %Sub-passo 8.6.1.1:Limite inferior 
  ns_tmp=ns(i,:);
  I=ns_tmp<Lb;
  ns_tmp(I)=Lb(I);
  
  %Sub-passo 8.6.1.2:Limite superior  
  J=ns_tmp>Ub;
  ns_tmp(J)=Ub(J);
  %Sub-passo 8.6.1.3:Atulizar as posi��es  
  ns(i,:)=ns_tmp;
end

%Sub-passo 8.5:Redu��o da aleatoriedade 
function alfa=newPara(alfa,gamma);
alfa=alfa.*gamma;

%Sub-passo 8.3: Aplicar as resrti��es n-dimensionias 
function z=Fun(fob,ctr,u)
%Sub-passo 8.3.1:Chamar a Fun��o Objetivo
z=fob(u); %u=otm
%Sub-passo 8.3.2:M�todo das penalidades (PROBLEMA ATUAL)
Penalidade=rest(ctr,u);
if z==inf
    z=0;
end
 z=z*Penalidade; % Z=rest(ctr,u) 
 %Se o problema � maximiza��o o ideal � punir o valor da fun�� que 
 %desrespeitou as restri��e 
 
%Sub-passo 8.3.2:Penalidade 
function Z=rest(ctr,u)

%Sub-passo 8.3.2.1:Cte. de penalidae >> 1
Igualdade=0.25;      %Penalidade caso desobede�a uma igualdade
Desigualdade=0.25;   %Penalidade caso desobede�a uma desigualdade
%
lam=Igualdade; 
lameq=Desigualdade;
%
Erro1=0;
Erro2=0;
%Sub-passo 8.3.2.2:N-lineares crt.
[g,geq,pg,pgeq]=ctr(u);

%Sub-passo 8.3.2.3:Aplicar penalidades as inequa��es 
for k=1:length(g),
    Erro1=Erro1+(lam+pg(k)).*Ineq(g(k));
    
    if Erro1>1;
        Erro1=1;
    end
end
%Sub-passo 8.3.2.4:Aplicar penalidades as equa��es
for k=1:length(geq),
   Erro2=Erro2+(lameq+pgeq(k)).*Eq(geq(k));
  
   if Erro2>1;
      Erro2=1;
   end
   
end
Z=(1-Erro1).*(1-Erro2);
%Sub-passo 8.3.2.3:Testar inequa��es (Penaliza n�meros positivos)
function H=Ineq(g)
if g<=0, 
H=0; 
else
H=1; 
end

%Sub-passo 8.3.2.4:Teste das equa��es (Penaliza se falso)
function H=Eq(geq)
if geq==0,
    H=1;
else
    H=0; 
end
%--------------------------------------------------------------------------