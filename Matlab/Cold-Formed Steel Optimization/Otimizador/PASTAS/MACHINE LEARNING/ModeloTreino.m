clc,clear all
%FORMAR TABELA
%  TABELA = readtable('TR2.xlsx');
%  save('TABELA','TABELA')

%TABELA PRONTA
load('TABELA.mat')
load('MODELO.mat');
load('SIMPLIFICADO.mat');
TABELA=TABELA{:,:};

cont=0;
T1=isoutlier(TABELA,8);    

for kk=1:size(TABELA,1)
%A=sum(T1(kk,:));
if T1(kk,6)<1 && T1(kk,7)<1 && T1(kk,8)<1 
cont=cont+1;    
TABELAv(cont,:)=TABELA(kk,:);
end
end

t=TABELAv(:,1);
bf=TABELAv(:,2);
bs=TABELAv(:,3);
bw=TABELAv(:,4);
PY=TABELAv(:,5);
PL=TABELAv(:,6);
PG=TABELAv(:,7);
PD=TABELAv(:,8);
%% TREINADOR
%[trainedModel, validationRMSE] = AlgTreino(TABELAv);
%% TREINADO
X=[TABELAv(1,1:5)];
%ypred = trainedModel.predictFcn(X)
PD=TimoshenkoGaussian.predictFcn(X)
PD2=M_SIMP.predictFcn(X)