function [REF]=Avaliador(Dim,Prop) 
%% AVALIADOR
%   Faz uma an�lise do CFS combinando MFF e MRD
    global l_log L A
%%  1.Transformar par�metros em um vetor x atribuir material
    x=[Dim];
    t=Prop(3);
    E=Prop(1);
    mat=[100 E E 0.3 0.3];
    Comp=logspace(1,l_log,200);
    fy=Prop(2);
%%  2.Tranformar vetor em coordenadas    
    h=x(1);         %bw
    b1=x(2);b2=x(2);%bf
    d1=x(3);d2=x(3);%bs
    q1=x(4);q2=q1;  %q
    [coord,elem]=para_coord(h,b1,b2,d1,d2,q1,q2,t);  
%%  3.An�lise de flambagem el�stica    
    [~,plot_ass]=faixas(coord,elem,mat,Comp);     
%%  4.Resist�ncia pelo MRD    
    [MRD,LG,~,~]=MRDN (plot_ass,coord,elem);
%%  5.Resist�ncia por Matsubara    
    [RLD,LL,LD]=INT_L_D (x,plot_ass,coord,elem);
%As formulas de Matsubra n�o podem dar valores maiores que o MDR
    if RLD>MRD
        RLD=MRD;
    end
%%  6.Saida
    Lf=Prop(4);
    Py=A*fy;    %Carga de cr�tica de escoamento
    PL=Py/LL^2; %Carga de cr�tica de flambagem LOCAL
    PD=Py/LD^2; %Carga de cr�tica de flambagem DISTORCIONAL
    PG=Py/LG^2; %Carga de cr�tica de flambagem GLOBAL    
    
%   Matriz de valores de refer�ncia
    REF=[L E fy A Py Lf t h b1 d1 q1 MRD RLD PL LL PD LD PG LG ];
    
    