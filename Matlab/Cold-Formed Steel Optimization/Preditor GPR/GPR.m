clc,clear all
%%  1.LER TABELA XLSX COM PERFIS ALEATÓRIOS
    TABELA = readtable('data_frame.xlsx');
    save('TABELA','TABELA')

%% 2.COVERTER TABELA
    load('TABELA.mat')
    load('MODELO.mat');
    load('SIMPLIFICADO.mat');
    TABELA=TABELA{:,:};

%%  3.TRATAR DADOS
cont=0;
Teste_outlier=isoutlier(TABELA,8);    

for kk=1:size(TABELA,1)
if Teste_outlier(kk,6)<1 && Teste_outlier(kk,7)<1 && Teste_outlier(kk,8)<1 
cont=cont+1;    
Tabela_Tratada(cont,:)=TABELA(kk,:);
end
end

t=Tabela_Tratada(:,1);
bf=Tabela_Tratada(:,2);
bs=Tabela_Tratada(:,3);
bw=Tabela_Tratada(:,4);
PY=Tabela_Tratada(:,5);
PL=Tabela_Tratada(:,6);
PG=Tabela_Tratada(:,7);
PD=Tabela_Tratada(:,8);
%% 4.TREINAR MODELO DE PREDIÇÃO
%Só utilizar quando o modelo não estiver treinado ou for inserido um 
%novo data frame
%[trainedModel, validationRMSE] = AlgTreino(TABELAv);
%% 5.AVALIAR MODELO TREINADO
for i=1:500
X=[Tabela_Tratada(i,1:5)];
PD1(i)=TimoshenkoGaussian.predictFcn(X)+10*rand()
PD2(i)=M_SIMP.predictFcn(X)
end

Matriz_Comparativa=[PD(1:500) PD1' PD2'];
csvwrite('Resultados_comparados.csv',Matriz_Comparativa)


