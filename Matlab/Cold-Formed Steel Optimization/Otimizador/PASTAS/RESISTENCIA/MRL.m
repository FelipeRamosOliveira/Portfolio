function [Mrl]=MRL(Ml,Mre)
LambdaL=(Mre./Ml).^0.5;
for i=1:length(Mre)
    if LambdaL(i)<=0.776;
        Mrl(i)=Mre(i);
    else LambdaL(i)>0.776;
       Mrl(i)=(1-(0.15./LambdaL(i).^0.8)).*(Mre(i)./LambdaL(i).^0.8); 
    end
end
