
function i=Torneio(pop,m)

    nPop=numel(pop);

    S=randsample(nPop,m);
    
    spop=pop(S);
    
    scosts=[spop.Custo];
    
    [~, j]=min(scosts);
    
    i=S(j);

end
