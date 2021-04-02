%%  MULTI OBJECTIVE PARTICLE SWARM OPTIMIZATION (MPSO)
%% I.PRINCIPAL 
function [Pcr,Dim,Lb,Ub]=PSO2(Lb,Ub,Nint,Npop,Gamma,Nrod)
%Passo 1:   Iniciar contador
global cont Contagem
cont=0;
%Passo 2:   Limites  
%Alterado

%Passo 3:   N� Particulas, N� de Inter��es e Peso  
para=[Npop Nint Gamma];
fot=[0];    %Ot�mo arb�trio | x=fot || Maximiza��o
gb=[zeros(1,length(Lb))];
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
function [g,FacEsp]=ctr(x)
global Lf
%% Inequa��es e equa��es
%Esse parte do c�digo � inteiramente do presente autor todos os vetores
%foram simplificados em vetores l�gicos o que elimina a necessidade de
%futuros (if)

%%Aumneto resit�ncia 
% g=[];
% %
% bf=x(1);
% D= x(2);
% bw=Lf-2.*D-2.*bf;
% %
% %Restri��es baseados nas limita��es do calculo de Matsubara
% g(1)=D./(bw)<=0.3;           % |D<0.6*bw| Garante a validade das equa��es  
% g(2)=2.*D./abs(bw)<=0.6;     % Garante o n�o fechamento da se��o
% g(3)=bf./abs(bw)<=1;         % |bf<=bw| Garante a validade das equa��es
% g(4)=bw>=0;
% %
% %Se verdadeiro g(i)=1 se falso g(i)=0
% %
% %Restri��o especial (quando uma restri��o gera eliman��o sum�ria do perfil)
% %pg(1)=1;                   %Default caso n�o exista restri��o especial
% pg(1)=g(4);
% FacEsp=prod(pg);

%%Aumento de eros�o 
g=[];
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
%pg(1)=1;                 %Default caso n�o exista restri��o especial
pg(1)=g(4);
pg(2)=g(3);
pg(3)=g(4);
FacEsp=prod(pg);


%% IV.PSO 
function [gb,fot]=pso_pri(fob,ctr,Lb,Ub,para,fot,gb)
%Passo 5:   Par�metros do PSO
% Amplitude de particulas alfa=[0,1]
% Velocidade de conv (0->1)=(lento->r�pido) || beta=0.5 
npart=para(1); ints=para(2); gamma=para(3);
alfa=0.2; beta=0.5;   
  
%Passo 6:   Posi��o inicial das particulas 
otm=ini_pso(npart,Lb,Ub);   % otm=chute

%Passo 7:   Processo iterativo e avalitivo

%Sub-passo 7.1:   Pseudo tempo
%Todos os passos seguintes est�o dentro do n�mero de intera��es
%por conveni�ncia foram separados

for t=1:ints
%Sub-passo 7.2:   N� de particulas
for i=1:npart
    
%Sub-passo 7.3:   Aplicar as resrti��es n-dimensionias (+SCOMPLEXO)
[z,y]=Fun(fob,ctr,otm(i,:));

fval=z;     %Fun��o penalizada � avalida
fotreal=y;  %Fun��o real

%Sub-passo 7.4:      Atulizar melhor particula 
if fval>=fot         %avaliar  valor da fun��o para cada particula  
gb=otm(i,:);         %se fval>fot | gb=chute -> vetor de par�metros   
fot=fotreal;         %um novo �timo � estabelecido 
end   
end                  %fim da avali��o das particulas

%Sub-passo 7.5:   Redu��o de aletoriedade  
alfa=newPara(alfa,gamma);

%Sub-passo 7.6:   Mover particulas para melhor posi��o     
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

%Original
% for i=1:n,
% chute(i,1:ndim)=round(Lb+rand(1,ndim).*(Ub-Lb));
% end

%Altera��o
chute=round(Lb+rand(n,ndim).*(Ub-Lb));


%Sub-passo 7.6: Mover todas as particulas 
function ns=pso_move(otm,gb,alf,beta,Lb,Ub)

%Sub-passo 7.6.1:Equ��o de movimento 
n=size(otm,1); 
ndim=size(otm,2);
esc=(Ub-Lb);

%Original
% for i=1:n,
% ns(i,:)=round(otm(i,:)+beta.*(gb-otm(i,:))+alf.*randn(1,ndim).*esc);
% end

%Altera��o
ns=round(otm+beta.*(gb-otm)+alf.*randn(n,ndim).*esc);
ns=range(ns,Lb,Ub);

%Sub-passo 7.6.1:Limites 
function ns=range(ns,Lb,Ub)
Ajuste=ns(:,1);
n=length(Ajuste);
%n=2;% Linhas da Matriz de limites 
for i=1:n
  %Sub-passo 7.6.1.1:Limite inferior 
  ns_tmp=ns(i,:);
  I=ns_tmp<Lb;
  ns_tmp(I)=Lb(I);
  
  %Sub-passo 7.6.1.2:Limite superior  
  J=ns_tmp>Ub;
  ns_tmp(J)=Ub(J);
  %Sub-passo 8.6.1.3:Atulizar as posi��es  
  ns(i,:)=ns_tmp;
end

%Sub-passo 8.5:Redu��o da aleatoriedade 
function alfa=newPara(alfa,gamma);
alfa=alfa.*gamma;

%Sub-passo 8.3: Aplica��o de restri��es 
function [z,y]=Fun(fob,ctr,u)
%M�todo de penaliza��o geral
[g,FacEsp]=ctr(u);
Peso=1./length(g);
FacRedu=sum(ones((length(g)-sum(g)),1).*Peso);
Penalidade=(1-FacRedu).*FacEsp;
%
%Sub-passo 8.3.1:Chamar a Fun��o Objetivo e aplicar penalidade sobre ela 
y=fob(u);      %fun��o real
z=y*Penalidade;%fun��o penalizada 