%% CLASSIFICA OS MODOS DE FLAMABEGEM A PARTIR DE UMA CURVA DE ASSINATURA
function [Local,Dist]=CLASSIFICADOR(plot_ass,Py,A,L,PrG,Global)
%% I.Transforma curvade assinatura de tens�o (E=kN/mm2) para for�a (Pcr=kN)
CargaCritica=plot_ass(1,:).*A;
Comprimentos=[logspace(1,log10(L),200)];
Assinatura=[Comprimentos' CargaCritica'];

%% II.Encontrar m�nimos da curva
Minimos = nonzeros([islocalmin(CargaCritica).*CargaCritica]');

%% III.Classificar
    %1.Chute te�rico
    if isempty(Minimos)==1
    Local=min(CargaCritica);
    Dist=Py/0.5561^2;       %Escoamento puro
    else
    Local=Minimos(1);
    Dist=Py/0.5561^2;       %Escoamento puro
    end
    
    %2.Comprimentos de flamabgem
    if isempty(Minimos)==0  %Se m�nimos n�o esta vazio
    for jj=1:length(Minimos)
    Lcr (jj)=(Assinatura (find(CargaCritica==Minimos(jj)),1)); %Lcr
    end
    end
    
    %3.Apenas um m�nimo com distorcinal implicito (Global<=Local)
    if size(Minimos,1)==1 && Global<=Local
    Local=Minimos(1);
    %3.1Aproximar um comprimento de flamabgem distorcional(LcrD)    
    LcrD=4.2*Lcr(1);
    if LcrD<L   %Se comprimento estimado estiver nos limites de L
    
    v = sort(Comprimentos(:));
    vidx = find(v >= LcrD, 1, 'first');
    if ~isempty(vidx)
    Laprox = v(vidx);
    end
    
    Dist1=(Assinatura (find(Comprimentos==Laprox),2));
    Dist2=Local*0.8194+63.5;    %Fun��o de interpola��o
    Dist=min([Dist1 Dist2]);
    
    else    %Se comprimento estimado estiver fora dos limites de L       
    Dist=Local +(Local-Global); 
    end %Fim condi��o de L        
    end %Fim  condi��o principal           

    % 4.Dois minimos encontados 
    if size(Minimos,1)>=2
    Local=Minimos(1);    
    Dist=min(Minimos(2:length(Minimos)));
    end