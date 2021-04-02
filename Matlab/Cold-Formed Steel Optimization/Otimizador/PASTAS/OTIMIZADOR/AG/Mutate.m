
function y=Mutate(x,mu,VarMin,VarMax)

    nVar=numel(x);
    j=randi([1 nVar],1);
    
    sigma=0.1*(VarMax-VarMin);
    
    y=x;
    y(j)=round(x(j)+sigma(j).*randn(1));
    
    y=max(y,VarMin);
    y=min(y,VarMax);

end