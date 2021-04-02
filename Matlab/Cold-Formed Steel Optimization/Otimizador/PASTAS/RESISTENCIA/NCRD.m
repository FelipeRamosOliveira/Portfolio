function [Ncrd,LambdaD]=NCRD(Py,Nd)
for i=1:length(Nd)
%Esbeltez á flambagem distorcional
LambdaD(i)=(Py./Nd(i)).^0.5;
%Resistência carcteristica á flambagem distorcional
    if LambdaD(i)<=0.561;
        Ncrd(i)=Py;
  else LambdaD(i)>0.561;   
        Ncrd(i)=(1-0.25./(LambdaD(i).^1.2)).*(Py./(LambdaD(i).^1.2));
    end
end
Ncrd=Ncrd';