function [modo_carga_critico,plot_ass] = faixas_finitas(elem,coord,mat,CC,onda,L)
%FAIXAS_FINITAS Método das Faixas Finitas
% Programa de faixas finitas para perfis formados a frio de seções abertas
% quaisquer, submetidos a tensões quaisquer nas extremidades.
%
% GL [u1 v1 u2 v2 w1 theta1 w2 theta2]'
% modo: vetor de deslocamentos nodais global GL [u1 v1...un vn w1 01...wn 0n]'

% OUTPUT:
%     modo_carga_critico{kk}{1}.........Comprimento kk (L(kk))
%     modo_carga_critico{kk}{2}.........Forma modal para cada comprimento kk (modos)
%     modo_carga_critico{kk}{3}.........Cargas criticas para cada compirmento kk (fc)
%
% Joao Alfredo de Lazzari, abril 2019.


% MÁXIMA MEIAS-ONDA
MODOMAX = 10; %Numero maximo de autovalores e modos (Atencao: Se a estrutura tiver poucos graus de liberdade, pode ser que seja calculado menos modos)

% QUANTIDADE DE CADA PARAMETRO (NUMERO INTERIRO POSITIVO) 
NNOS = size(coord,1); % Número de nós
NELM = size(elem,1); % Número de elementos
NGN = 4; % Numero de graus de liberdade por no
NGE = 2*NGN; % Numero de graus de liberdade por elemento (cada elemento tem 2 nos)
NGL = NNOS*NGN; % Numero de graus de liberdade
NONDA = length(onda); % Numero total de termos longitudinais

% QUANTIDADE DE COMPRIMENTOS DA BARRA
NCOMP = length(L); % Numero de comprimentos do eixo longitudinal

%% PRÉ-PROCESSAMENTO DOS DADOS
% Organização dos dados de entrada para processar a análise
[no1,no2,b,t,phy,Ty1,Ty2,~,~,~,~] = pre_FF(elem,coord);

%% ANÁLISE EM FAIXAS FINITAS (FORMAÇÃO DAS MATRISES DE RIGIDEZ E SOLVER)
% Formação das matrizes de rigidez elastica e geometrica, e calculo das
% cargas críticas e modos críticos com um solver para problema de autovalor

% INICIALIZANDO LOOP NOS COMPRIMENTOS E ELEMENTOS DA SECAO
plot_ass=zeros(MODOMAX,1);
modo_carga_critico = cell(1,NCOMP);
for kk=1:NCOMP %Loop nos comprimentos da barra
    Ex=zeros(NELM,1);
    Ey=zeros(NELM,1);
    vx=zeros(NELM,1);
    vy=zeros(NELM,1);
    G=zeros(NELM,1);
    KE=zeros(NGN*NNOS*NONDA,NGN*NNOS*NONDA);
    KG=zeros(NGN*NNOS*NONDA,NGN*NNOS*NONDA);
    for ii=1:NELM %Loop nos elementos da secao trasnversal
        
        % PROPRIEDADES DE MATERIAL
        matnum=elem(ii,5);
        row=find(matnum==mat(:,1));
        Ex(ii)=mat(row,2); % Modulo de Elasticidade X de Cada Elemento
        Ey(ii)=mat(row,3); % Modulo de Elasticidade y de Cada Elemento
        vx(ii)=mat(row,4); % Coeficiente de Poisson X de Cada Elemento
        vy(ii)=mat(row,5); % Coeficiente de Poisson y de Cada Elemento
        G(ii)=(Ex(ii)*Ey(ii))/(Ex(ii)*(1+2*vy(ii))+Ey(ii)); % Modulo de Elasticidade do material anisotropico de cada elemento
        
        % MONTAR A MATRIZ DE RIGIDEZ ELASTICA E GEOMÉTRICA DOS ELEMENTOS 
        % EM COORDENADAS GLOBAIS                   
        [KE,KG] = Matriz_Rig_Geo(KE,KG,Ex(ii),Ey(ii),vx(ii),vy(ii),G(ii),...
            t(ii),Ty1(ii),Ty2(ii),phy(ii),L(kk),b(ii),CC,onda,NNOS,no1(ii),no2(ii));
    end
    
    % INTRODUZINDO AS RESTRICOES (CONSTRAINT MATRIX)
    R=eye(NGN*NNOS*NONDA); %Matriz Identidade: Sem inclusao dos modo
    KEff=R'*KE*R;
    KGff=R'*KG*R;
    
%     R=gpuArray(eye(NGN*NNOS*NONDA));
%     KEff=gpuArray(R'*KE*R);
%     KGff=gpuArray(R'*KG*R);
    
%     % RESOLVENDO O PROBLEMA DE AUTOVALOR (METODO ROBUSTO)

       [modos,fc]=eig(full(KEff),full(KGff));

     
    % RESOLVENDO O PROBLEMA DE AUTOVALOR (METODO MENOS PRECISO - ITERATIVO) 
%       options.disp=0;
%       options.issym=1;
%       N=max(min(2*MODOMAX,length(KEff(1,:))),1);
%      [modos,fc]=eigs(KGff\KEff,N,'SM',options);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TIRADO DO CUFSM %%%%%%%
% rcond_num=rcond(KGff\KEff);
%     %Here, assume when rcond_num is bigger than half of the eps, eigs can provide
%     %reliable solution. Otherwise, eig, the robust solver should be used.
%     if rcond_num>=eps/2
%         eigflag=2;%eigs
%     else
%         eigflag=1;%eig
%     end
%     %determine if there is a user input neigs; otherwise set it to
%     %default 10.
%     if MODOMAX<10|isempty(MODOMAX)
%         MODOMAX=20;
%     end
%     if eigflag==1
%         [modos,fc]=eig(KEff,KGff);
%     else
%         options.disp=0;
%         options.issym=1;
%         N=max(min(2*MODOMAX,length(KEff(1,:))),1);
%         if N==1|N==length(KEff(1,:))
%             [modos,fc]=eig(KEff,KGff);
%         else
%         %pull out 10 eigenvalues
%         [modos,fc]=eigs(KGff\KEff,N,'SM',options);
%         end
%     end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    % LIMPANDO NUMEROS COMPLEXOS E ORGANIZANDO OS FATORES DE CARGAS E MODOS
    fc=diag(fc); % Vetorizando a matriz diagonal
    ind=find(fc>0 & imag(abs(fc))<0.00001); % Indices para fator de carga
                                            % maior que zero e parte 
                                            % imaginaria proximo de zero
    fc=fc(ind); % Pegando os fatores de carga para os indices definidos
    modos=modos(:,ind); % Pegando os modos para os indices definidos
    [fc,ind]=sort(fc); % Organizando do menor fator de carga para o maior
    modos=modos(:,ind); % Pegando os modos para os indices definidos novamente
    fc=real(fc); % Pegando apenas valores da parte real (o algoritmo do problema de autovalor pode gerar pequenos numeros complexos)
    modos=real(modos); % Pegando apenas valores da parte real (o algoritmo do problema de autovalor pode gerar pequenos numeros complexos)
    
    % SELECIONANDO APENAS OS MODOS RELEVANTES
    NMODOS = min([MODOMAX length(fc)]);
    
    fc=fc(1:NMODOS);
    modos=modos(:,1:NMODOS);
    
    modo_carga_critico{kk}{1}=L(kk); % Comprimento kk
    modo_carga_critico{kk}{2}=modos; % Forma modal para cada comprimento kk
    modo_carga_critico{kk}{3}=fc;    % Cargas criticas para cada compirmento kk
     
    plot_ass(1:NMODOS,kk) = modo_carga_critico{kk}{3};
end

end

