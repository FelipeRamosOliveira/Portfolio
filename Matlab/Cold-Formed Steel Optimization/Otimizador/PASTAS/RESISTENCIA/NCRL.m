function [Ncrl,LambdaL]=NCRL(Ncre,Nl)
%Esbeltez á flambagem local
LambdaL=(Ncre./Nl).^0.5;
%Resistência carcteristica á flambagem local
for i=1:length(LambdaL(:,1))
    
    if LambdaL(i)<=0.776;
        Ncrl(i)=Ncre(i);
  else LambdaL(i)>0.776;   
        Ncrl(i)=(1-0.15./(LambdaL(i).^0.8)).*(Ncre(i)./(LambdaL(i).^0.8));
    end
end
Ncrl=Ncrl';