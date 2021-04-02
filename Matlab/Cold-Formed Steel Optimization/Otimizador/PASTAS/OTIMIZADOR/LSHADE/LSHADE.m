function[FobFinal,Dim]= LSHADE(Lb,Ub)
global cont MaxAva
%%  I.PR�-DEFINI��ES
    rand('seed', sum(100 * clock)); %Gerar popu��o totalmente alet�ria 
    Dimensoes = length(Lb);         %N� de dimens�es do problema
    LU = [Lb;Ub];                   %Limites do dom�nio
    FOB=@(x) OBJETIVO(x);           %Definir fun��o objetivo
    SAIDA = [];                     %Gravar melhor resultado
    
%  PAR�METROS DO LSHADE
    Taxa_Melhor = 0.1;              %Aprendizado 
    Taxa_Arco = 2;                  %Taxa similaridade 
    Tamanho_Memoria = Dimensoes;    %M�moria dedicada
    NPOP = 25;                      %Tamanho da popula��o

%%   II.INICILIZAR A POPUL��O PRINCIPAL
    popold =(repmat(LU(1, :), NPOP, 1) + rand(NPOP, Dimensoes) .* (repmat(LU(2, :) - LU(1, :), NPOP, 1)));
    % A popul��o antiga torna-se a popul��o atual 
    pop = popold; 
    % Avaliar a popul��o    
    for ii=1:size(pop,1)
    aptidao (ii) = -FOB(pop(ii,:))*Restricao(pop(ii,:));
    aptidaoreal (ii) = -FOB(pop(ii,:));
    end
    aptidao = aptidao';
    %
    nfes = 0;
    MelhorAVA = 1e+30;
    bsf_SOL = zeros(1, Dimensoes);
    
for i = 1 : NPOP
    nfes = nfes + 1;
    
    if aptidao(i) < MelhorAVA
    MelhorAVA = aptidao(i);
    MelhorAVAReal = aptidaoreal(i);
	bsf_SOL = pop(i, :);
    end	  
%   CRIT�RIO DE PARADA
    if nfes > MaxAva; break; end
end

    memoria_sf = 0.5 .* ones(Tamanho_Memoria, 1);
    memoria_cr = 0.5 .* ones(Tamanho_Memoria, 1);
    memoria_pos = 1;

    arquivo.NP = Taxa_Arco * NPOP;      % Tamanho m�ximo do arquivo
    arquivo.pop = zeros(0, Dimensoes);  % As solu��es s�o ordenadas
    arquivo.funvalues = zeros(0, 1);    % Os valores das fun��es s�o armazenados

%%  III.LOOP PRINCINPAL 
    while nfes < MaxAva 
    % A popul��o antiga torna-se a popul��o atual 
    pop = popold; 
    [temp_fit, sorted_index] = sort(aptidao, 'ascend');

    memoria_aletoria_index = ceil(Tamanho_Memoria * rand(NPOP, 1));
    mu_sf = memoria_sf(memoria_aletoria_index);
    mu_cr = memoria_cr(memoria_aletoria_index);

% TAXA DE CROSSOVER POR GERA��O
      cr = normrnd(mu_cr, 0.1);
      term_pos = find(mu_cr == -1);
      cr(term_pos) = 0;
      cr = min(cr, 1);
      cr = max(cr, 0);

%   TAXA DIMENSIONAL POR GERA��O
      sf = mu_sf + 0.1 * tan(pi * (rand(NPOP, 1) - 0.5));
      pos = find(sf <= 0);

      while ~ isempty(pos)
      sf(pos) = mu_sf(pos) + 0.1 * tan(pi * (rand(length(pos), 1) - 0.5));
      pos = find(sf <= 0);
      end
      sf = min(sf, 1); 
      
      r0 = [1 : NPOP];
      popTotal = [pop; arquivo.pop];
      [r1, r2] = gnR1R2(NPOP, size(popTotal, 1), r0);
      %Escolher as duas ultimas melhores solu��es
      pNP = max(round(Taxa_Melhor * NPOP), 2); 
      %Selecionar em  [1, 2, 3, ..., pNP]
      Aleindex = ceil(rand(1, NPOP) .* pNP); 
      % Para evitar o problema de rand = 0
      Aleindex = max(1, Aleindex); 
      % Aletoriamente escolher uma das melhores solu��es 
      pmelhor = pop(sorted_index(Aleindex), :); 

      vi = (pop + sf(:, ones(1, Dimensoes)) .* (pmelhor - pop + pop(r1, :) - popTotal(r2, :)));
      vi = boundConstraint(vi, pop, LU);
    
      % m�scara � usada para indicar quais elementos da interface do usu�rio v�m do pai
      mask = rand(NPOP, Dimensoes) > cr(:, ones(1, Dimensoes)); 
      % escolha uma posi��o em que o elemento da interface do usu�rio n�o venha do pai
      rows = (1 : NPOP)'; cols = floor(rand(NPOP, 1) * Dimensoes)+1; 
      jrand = sub2ind([NPOP Dimensoes], rows, cols); mask(jrand) = false;
      ui = vi; ui(mask) = pop(mask);
      
      for jj=1:size(ui,1)
      filho_aptidao(jj) =- FOB (ui(jj,:))*Restricao(pop(jj,:));
      filho_aptidao_real(jj) =- FOB (ui(jj,:));
      end
         
      filho_aptidao = filho_aptidao';
      filho_aptidao=reshape(filho_aptidao,1,[])';   
%   CRIT�RIO DE PARADA
	  if cont>=MaxAva; break; end
      
for i = 1 : NPOP
      nfes = nfes + 1;

      if filho_aptidao(i) < MelhorAVA
	  MelhorAVA = filho_aptidao(i);
      MelhorAVAReal = filho_aptidao_real(i);
	  bsf_SOL = ui(i, :);
      end  
      
%   CRIT�RIO DE PARADA
	  if nfes > MaxAva; break; end
end
      dif = abs(aptidao - filho_aptidao);

%   I == 1: se o pai � Melhor ; I == 2: se o filho � melhor
      I = (aptidao > filho_aptidao);
      MelhorCR = cr(I == 1);  
      MelhorF = sf(I == 1);
      dif_val = dif(I == 1);

      arquivo = atulizararquivo(arquivo, popold(I == 1, :), aptidao(I == 1));
      [aptidao, I] = min([aptidao, filho_aptidao], [], 2);
      
      popold = pop;
      popold(I == 2, :) = ui(I == 2, :);

      num_success_params = numel(MelhorCR);

  if num_success_params > 0 
	sum_dif = sum(dif_val);
	dif_val = dif_val / sum_dif;

%   ATULIZAR A MEM�RIA DO FATOR DIMENSIONAL
	memoria_sf(memoria_pos) = (dif_val' * (MelhorF .^ 2)) / (dif_val' * MelhorF);

%   ATULIZAR A MEM�RIA DO FATOR DE CROSSOVER
	if max(MelhorCR) == 0 || memoria_cr(memoria_pos)  == -1
	memoria_cr(memoria_pos)  = -1;
	else
	memoria_cr(memoria_pos) = (dif_val' * (MelhorCR .^ 2)) / (dif_val' * MelhorCR);
    end
	memoria_pos = memoria_pos + 1;
	if memoria_pos > Tamanho_Memoria;  memoria_pos = 1; end
  end
  
%   FIM DO PROGRAMA PRINCIPAL
end

    FOBFinal = abs(MelhorAVAReal);
    for kk=1:NPOP
    FINAL (kk,:)=[FOB(pop(kk,:)) pop(kk,:)];
    end
    FINAL=sortrows(FINAL,1,'descend');
    FobFinal=FINAL(1);
    Dim=[FINAL(1,2:size(FINAL,2))];
    cont=cont-NPOP;
  