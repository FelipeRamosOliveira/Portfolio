%%  OTIMIZADOR DE PERFIS Ue UTILIZANDO ALGOR�TIMOS META-HEUR�STICOS
%   COPPE/UFRJ-Instituto de P�s-Gradua��o e Pesquisa de Engenharia
%   Autor:Felipe R. Oliveira
    clc; clear all; close all;
    %format shortEng
    %format compact 
    format bank
%   VARI�VEIS GLOBAIS    
    global Lf t l_log E fy L MaxAva FSU
%%  I.CHAMAR TODAS AS PASTAS AUXILIARES

%   1.PASTAS PRINCIPAIS
    wpath=what;
    currentlocation=wpath.path;
    addpath([currentlocation]);
    addpath([currentlocation,'\PASTAS']);
    addpath([currentlocation,'\PASTAS\FAIXAS FINITAS']);
    addpath([currentlocation,'\PASTAS\GENERATIVO']);
    addpath([currentlocation,'\PASTAS\RESISTENCIA']);
    addpath([currentlocation,'\PASTAS\OTIMIZADOR']);
    addpath([currentlocation,'\PASTAS\POS-PROCESSAMENTO']);
    addpath([currentlocation,'\PASTAS\MACHINE LEARNING']);
%   2.OTIMIZADORES
    addpath([currentlocation,'\PASTAS\OTIMIZADOR\AG']);
    addpath([currentlocation,'\PASTAS\OTIMIZADOR\PSO']);
    addpath([currentlocation,'\PASTAS\OTIMIZADOR\DE']);
    addpath([currentlocation,'\PASTAS\OTIMIZADOR\ABC']);
    addpath([currentlocation,'\PASTAS\OTIMIZADOR\LSHADE']);
    addpath([currentlocation,'\PASTAS\OTIMIZADOR\VARIANTES']);
%   3.CHAMAR MODELO GPR TREINADO 
    load('SIMPLIFICADO.mat');
    FSU=@(X1)M_SIMP.predictFcn;
    
%%  II.DEFINI��ES DO PROBLEMA DE OTMIZA��O

%   1.DEFINIR CARCRTER�STICAS  IMPOSTAS AO PROBLEMA      
    % Disserta��o 
    L= [1000:250:2500];Comp=L;          %Comprimentos de v�o/coluna (mm)
    MaxAva=10^4;                        %Max�mo de avalia��es permitidas
    Nrod=15;                            %N� de rodadas para um mesmo problema
    
%   LIMITES 
%       bs/bf    bf/lf    Q
    Lb=[0.1      0.1     15];    %Inferior
    Ub=[0.9      0.3     90];    %Superior
    
%   PERFIS DE REFER�NCIA (SFIA)
    [Dim,Prop]=SFIA_REF();
        
%   2.AVALIAR A RESIST�NCIA DOS PERFIS DE REF�NCIA (SFIA)
for jj=1:length(Comp)
    L=Comp(jj);

%   Propiedades dos perfis de refer�ncia
    for i=1:size(Dim,1)
        l_log=log10(L);     E=Prop(i,1);
        fy=Prop(i,2);       t=Prop(i,3);
        Lf=Prop(i,4);  

%   An�lise MFF <-> MRD
        [REF]=Avaliador(Dim(i,:),Prop(i,:)); 
        REF_P(i,:)=[REF,0];
    end

%   Acumular resultados das an�lises
    T_Ref=size(REF_P,1);
    i1=1+T_Ref*(jj-1);
    i2=T_Ref+T_Ref*(jj-1);
    REF_G(i1:i2,:)=[REF_P];
end
%   Salvar resultados dos perfis de refer�ncia 
    FLAG=5;
    Tabelas (REF_G,FLAG)
%%   III.LOOP PRINCIPAL DE OTIMIZA��O
for kk=1:size(REF_G,1)
%   1. CARCTERIZAR PROTOTIPO QUE SER� OTIMIZADO
    L=REF_G(kk,1);      E=REF_G(kk,2);  
    fy=REF_G(kk,3);     Lf=REF_G(kk,6);
    t=REF_G(kk,7);      l_log=log10(L);
    MRD=REF_G(kk,12);   bw=REF_G(kk,8);
    bf=REF_G(kk,9);     bs=REF_G(kk,10);
    Q=REF_G(kk,11);     Prop=[E fy t  Lf];
    
%   Indices de acumulo de resultados    
    i1=1+Nrod*(kk-1);
    i2=Nrod+Nrod*(kk-1);
    
%   2.IDENTIFICAR PROTOTIPO QUE SER� OTIMIZADO

    if t==3,ID='CALIBRA��O';
    elseif t==0.9,ID='800S137-33';
    elseif t==1.1,ID='600S137-43';   
    elseif t==1.4,ID='600S162-54';
    elseif t==1.8,ID='800S162-68';
    elseif t==2.6,ID='1400S300-97';   
    elseif t==3.2,ID='1400S200-118';      
    end
    disp(['____________________________________________________________________________'])    
    disp(['Total de An�lises: ' num2str(size(REF_G,1)) '|An�lise atual: ' num2str(kk)])  
    disp(['ID SFIA:' ID])  
    disp(['Valores de Refer�ncia|Comprimento(mm):' num2str(L) ' <-> Pn(kN):' num2str(MRD)])  
    disp(['____________________________________________________________________________'])  

%%   3.ALGORITIMOS DE OTMIZA��O  
%%   AG
    disp(['Otimizador: AG'])
    [CURVAS_AC,PARC_AG]= Loop_AG (Nrod,MRD,Lb,Ub,bw,bf,bs,Q,Prop);
    disp(['-'])  
%   Acumular resultados das parcias (AG)    
    REF_AG(i1:i2,:)=[PARC_AG];
    CURVAS_AG(i1:i2,:)=[CURVAS_AC];

%%  DE    
    disp(['Otimizador: DE'])
    [CURVAS_DE,PARC_DE]= Loop_DE (Nrod,MRD,Lb,Ub,bw,bf,bs,Q,Prop);
    disp(['-'])  
%   Acumular resultados das parcias (DE)     
    REF_DE(i1:i2,:)=[PARC_DE];
    CURVAS_DE(i1:i2,:)=[CURVAS_DE];   

%%  PSO    
    disp(['Otimizador: PSO'])
    [CURVAS_PSO,PARC_PSO]= Loop_PSO (Nrod,MRD,Lb,Ub,bw,bf,bs,Q,Prop);
    disp(['-'])  
%   Acumular resultados das parcias (PSO)    
    REF_PSO(i1:i2,:)=[PARC_PSO];
    CURVAS_PSO(i1:i2,:)=[CURVAS_PSO];    
    
%%  ABC    
    disp(['Otimizador: ABC'])
    [CURVAS_ABC,PARC_ABC]= Loop_ABC (Nrod,MRD,Lb,Ub,bw,bf,bs,Q,Prop);
%   Acumular resultados das parcias (ABC)    
    REF_ABC(i1:i2,:)=[PARC_ABC];
    CURVAS_ABC(i1:i2,:)=[CURVAS_ABC];      
    
%     if kk==2,break,end
end
%%  IV. SALVAR RESULTADOS GERAIS

for i=1:4  
  FLAG=i;  
  %  
  if     i==1
  RESULTADOS=REF_AG;
  CURVA=CURVAS_AG;
  elseif i==2
  RESULTADOS=REF_DE;
  CURVA=CURVAS_DE;
  elseif i==3
  RESULTADOS=REF_PSO;
  CURVA=CURVAS_PSO;
  elseif i==4
  RESULTADOS=REF_ABC;
  CURVA=CURVAS_ABC;
  end 
  % 
  Tabelas (RESULTADOS,FLAG)
  Salvar_Curvas (CURVA,FLAG) 
end