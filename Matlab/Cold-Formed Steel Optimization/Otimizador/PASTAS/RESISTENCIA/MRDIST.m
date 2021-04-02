function [Mrdist]=MRDIST(Md,Wc,fy)
LambdaD=(Wc*fy./Md).^0.5;
LambdaD<=0.673;
        Mrdist=Wc*fy;
LambdaD>0.673;
       Mrdist=(1-(0.22./LambdaD)).*(Wc*fy/LambdaD); 

  