function [K,Kg]=assemble(K,Kg,k,kg,nodei,nodej,nnodes,m_a)
%
%Add the element contribution to the global stiffness matrix

%Outputs:
% K: global elastic stiffness matrix
% Kg: global geometric stiffness matrix
% K and Kg: totalm x totalm submatrices. Each submatrix is similar to the
% one used in original CUFSM for single longitudinal term m in the DOF order
%[u1 v1...un vn w1 01...wn 0n]m'.

% Z. Li, June 2008
% modified by Z. Li, Aug. 09, 2009
% Z. Li, June 2010

totalm = length(m_a); %Total number of longitudinal terms m
K2=sparse(zeros(4*nnodes*totalm,4*nnodes*totalm));
K3=sparse(zeros(4*nnodes*totalm,4*nnodes*totalm));
skip=2*nnodes;
for i=1:1:totalm
    for j=1:1:totalm
        %Submatrices for the initial stiffness
        k11=k(8*(i-1)+1:8*(i-1)+2,8*(j-1)+1:8*(j-1)+2);
        k12=k(8*(i-1)+1:8*(i-1)+2,8*(j-1)+3:8*(j-1)+4);
        k13=k(8*(i-1)+1:8*(i-1)+2,8*(j-1)+5:8*(j-1)+6); %Zero?
        k14=k(8*(i-1)+1:8*(i-1)+2,8*(j-1)+7:8*(j-1)+8); %Zero?
        k21=k(8*(i-1)+3:8*(i-1)+4,8*(j-1)+1:8*(j-1)+2);
        k22=k(8*(i-1)+3:8*(i-1)+4,8*(j-1)+3:8*(j-1)+4);
        k23=k(8*(i-1)+3:8*(i-1)+4,8*(j-1)+5:8*(j-1)+6); %Zero?
        k24=k(8*(i-1)+3:8*(i-1)+4,8*(j-1)+7:8*(j-1)+8); %Zero?
        k31=k(8*(i-1)+5:8*(i-1)+6,8*(j-1)+1:8*(j-1)+2); %Zero?
        k32=k(8*(i-1)+5:8*(i-1)+6,8*(j-1)+3:8*(j-1)+4); %Zero?
        k33=k(8*(i-1)+5:8*(i-1)+6,8*(j-1)+5:8*(j-1)+6); 
        k34=k(8*(i-1)+5:8*(i-1)+6,8*(j-1)+7:8*(j-1)+8); 
        k41=k(8*(i-1)+7:8*(i-1)+8,8*(j-1)+1:8*(j-1)+2); %Zero?
        k42=k(8*(i-1)+7:8*(i-1)+8,8*(j-1)+3:8*(j-1)+4); %Zero?
        k43=k(8*(i-1)+7:8*(i-1)+8,8*(j-1)+5:8*(j-1)+6); 
        k44=k(8*(i-1)+7:8*(i-1)+8,8*(j-1)+7:8*(j-1)+8); 
        %
%         any(any(k13))
%         if any(any(k13))else
%             disp('Vazio')
%         end
        K2(4*nnodes*(i-1)+ nodei*2-1:4*nnodes*(i-1)+nodei*2,4*nnodes*(j-1)+nodei*2-1:4*nnodes*(j-1)+nodei*2)=k11;
        K2(4*nnodes*(i-1)+ nodei*2-1:4*nnodes*(i-1)+nodei*2,4*nnodes*(j-1)+nodej*2-1:4*nnodes*(j-1)+nodej*2)=k12;
        K2(4*nnodes*(i-1)+ nodej*2-1:4*nnodes*(i-1)+nodej*2,4*nnodes*(j-1)+nodei*2-1:4*nnodes*(j-1)+nodei*2)=k21;
        K2(4*nnodes*(i-1)+ nodej*2-1:4*nnodes*(i-1)+nodej*2,4*nnodes*(j-1)+nodej*2-1:4*nnodes*(j-1)+nodej*2)=k22;
        %
        K2(4*nnodes*(i-1)+skip+nodei*2-1:4*nnodes*(i-1)+skip+nodei*2,4*nnodes*(j-1)+skip+nodei*2-1:4*nnodes*(j-1)+skip+nodei*2)=k33;
        K2(4*nnodes*(i-1)+skip+nodei*2-1:4*nnodes*(i-1)+skip+nodei*2,4*nnodes*(j-1)+skip+nodej*2-1:4*nnodes*(j-1)+skip+nodej*2)=k34;
        K2(4*nnodes*(i-1)+skip+nodej*2-1:4*nnodes*(i-1)+skip+nodej*2,4*nnodes*(j-1)+skip+nodei*2-1:4*nnodes*(j-1)+skip+nodei*2)=k43;
        K2(4*nnodes*(i-1)+skip+nodej*2-1:4*nnodes*(i-1)+skip+nodej*2,4*nnodes*(j-1)+skip+nodej*2-1:4*nnodes*(j-1)+skip+nodej*2)=k44;
        %
        K2(4*nnodes*(i-1)+nodei*2-1:4*nnodes*(i-1)+nodei*2,4*nnodes*(j-1)+skip+nodei*2-1:4*nnodes*(j-1)+skip+nodei*2)=k13; %Zero?
        K2(4*nnodes*(i-1)+nodei*2-1:4*nnodes*(i-1)+nodei*2,4*nnodes*(j-1)+skip+nodej*2-1:4*nnodes*(j-1)+skip+nodej*2)=k14; %Zero?
        K2(4*nnodes*(i-1)+nodej*2-1:4*nnodes*(i-1)+nodej*2,4*nnodes*(j-1)+skip+nodei*2-1:4*nnodes*(j-1)+skip+nodei*2)=k23; %Zero?
        K2(4*nnodes*(i-1)+nodej*2-1:4*nnodes*(i-1)+nodej*2,4*nnodes*(j-1)+skip+nodej*2-1:4*nnodes*(j-1)+skip+nodej*2)=k24; %Zero?
        %
        K2(4*nnodes*(i-1)+skip+nodei*2-1:4*nnodes*(i-1)+skip+nodei*2,4*nnodes*(j-1)+nodei*2-1:4*nnodes*(j-1)+nodei*2)=k31; %Zero?
        K2(4*nnodes*(i-1)+skip+nodei*2-1:4*nnodes*(i-1)+skip+nodei*2,4*nnodes*(j-1)+nodej*2-1:4*nnodes*(j-1)+nodej*2)=k32; %Zero?
        K2(4*nnodes*(i-1)+skip+nodej*2-1:4*nnodes*(i-1)+skip+nodej*2,4*nnodes*(j-1)+nodei*2-1:4*nnodes*(j-1)+nodei*2)=k41; %Zero?
        K2(4*nnodes*(i-1)+skip+nodej*2-1:4*nnodes*(i-1)+skip+nodej*2,4*nnodes*(j-1)+nodej*2-1:4*nnodes*(j-1)+nodej*2)=k42; %Zero?
        %
        
        
        %Submatrices for the initial stiffness
        kg11=kg(8*(i-1)+1:8*(i-1)+2,8*(j-1)+1:8*(j-1)+2);
        kg12=kg(8*(i-1)+1:8*(i-1)+2,8*(j-1)+3:8*(j-1)+4);
        kg13=kg(8*(i-1)+1:8*(i-1)+2,8*(j-1)+5:8*(j-1)+6);
        kg14=kg(8*(i-1)+1:8*(i-1)+2,8*(j-1)+7:8*(j-1)+8);
        kg21=kg(8*(i-1)+3:8*(i-1)+4,8*(j-1)+1:8*(j-1)+2);
        kg22=kg(8*(i-1)+3:8*(i-1)+4,8*(j-1)+3:8*(j-1)+4);
        kg23=kg(8*(i-1)+3:8*(i-1)+4,8*(j-1)+5:8*(j-1)+6);
        kg24=kg(8*(i-1)+3:8*(i-1)+4,8*(j-1)+7:8*(j-1)+8);
        kg31=kg(8*(i-1)+5:8*(i-1)+6,8*(j-1)+1:8*(j-1)+2);
        kg32=kg(8*(i-1)+5:8*(i-1)+6,8*(j-1)+3:8*(j-1)+4);
        kg33=kg(8*(i-1)+5:8*(i-1)+6,8*(j-1)+5:8*(j-1)+6);
        kg34=kg(8*(i-1)+5:8*(i-1)+6,8*(j-1)+7:8*(j-1)+8);
        kg41=kg(8*(i-1)+7:8*(i-1)+8,8*(j-1)+1:8*(j-1)+2);
        kg42=kg(8*(i-1)+7:8*(i-1)+8,8*(j-1)+3:8*(j-1)+4);
        kg43=kg(8*(i-1)+7:8*(i-1)+8,8*(j-1)+5:8*(j-1)+6);
        kg44=kg(8*(i-1)+7:8*(i-1)+8,8*(j-1)+7:8*(j-1)+8);
        %
        K3(4*nnodes*(i-1)+nodei*2-1:4*nnodes*(i-1)+nodei*2,4*nnodes*(j-1)+nodei*2-1:4*nnodes*(j-1)+nodei*2)=kg11;
        K3(4*nnodes*(i-1)+nodei*2-1:4*nnodes*(i-1)+nodei*2,4*nnodes*(j-1)+nodej*2-1:4*nnodes*(j-1)+nodej*2)=kg12;
        K3(4*nnodes*(i-1)+nodej*2-1:4*nnodes*(i-1)+nodej*2,4*nnodes*(j-1)+nodei*2-1:4*nnodes*(j-1)+nodei*2)=kg21;
        K3(4*nnodes*(i-1)+nodej*2-1:4*nnodes*(i-1)+nodej*2,4*nnodes*(j-1)+nodej*2-1:4*nnodes*(j-1)+nodej*2)=kg22;
        %
        K3(4*nnodes*(i-1)+skip+nodei*2-1:4*nnodes*(i-1)+skip+nodei*2,4*nnodes*(j-1)+skip+nodei*2-1:4*nnodes*(j-1)+skip+nodei*2)=kg33;
        K3(4*nnodes*(i-1)+skip+nodei*2-1:4*nnodes*(i-1)+skip+nodei*2,4*nnodes*(j-1)+skip+nodej*2-1:4*nnodes*(j-1)+skip+nodej*2)=kg34;
        K3(4*nnodes*(i-1)+skip+nodej*2-1:4*nnodes*(i-1)+skip+nodej*2,4*nnodes*(j-1)+skip+nodei*2-1:4*nnodes*(j-1)+skip+nodei*2)=kg43;
        K3(4*nnodes*(i-1)+skip+nodej*2-1:4*nnodes*(i-1)+skip+nodej*2,4*nnodes*(j-1)+skip+nodej*2-1:4*nnodes*(j-1)+skip+nodej*2)=kg44;
        %
        K3(4*nnodes*(i-1)+nodei*2-1:4*nnodes*(i-1)+nodei*2,4*nnodes*(j-1)+skip+nodei*2-1:4*nnodes*(j-1)+skip+nodei*2)=kg13;
        K3(4*nnodes*(i-1)+nodei*2-1:4*nnodes*(i-1)+nodei*2,4*nnodes*(j-1)+skip+nodej*2-1:4*nnodes*(j-1)+skip+nodej*2)=kg14;
        K3(4*nnodes*(i-1)+nodej*2-1:4*nnodes*(i-1)+nodej*2,4*nnodes*(j-1)+skip+nodei*2-1:4*nnodes*(j-1)+skip+nodei*2)=kg23;
        K3(4*nnodes*(i-1)+nodej*2-1:4*nnodes*(i-1)+nodej*2,4*nnodes*(j-1)+skip+nodej*2-1:4*nnodes*(j-1)+skip+nodej*2)=kg24;
        %
        K3(4*nnodes*(i-1)+skip+nodei*2-1:4*nnodes*(i-1)+skip+nodei*2,4*nnodes*(j-1)+nodei*2-1:4*nnodes*(j-1)+nodei*2)=kg31;
        K3(4*nnodes*(i-1)+skip+nodei*2-1:4*nnodes*(i-1)+skip+nodei*2,4*nnodes*(j-1)+nodej*2-1:4*nnodes*(j-1)+nodej*2)=kg32;
        K3(4*nnodes*(i-1)+skip+nodej*2-1:4*nnodes*(i-1)+skip+nodej*2,4*nnodes*(j-1)+nodei*2-1:4*nnodes*(j-1)+nodei*2)=kg41;
        K3(4*nnodes*(i-1)+skip+nodej*2-1:4*nnodes*(i-1)+skip+nodej*2,4*nnodes*(j-1)+nodej*2-1:4*nnodes*(j-1)+nodej*2)=kg42;
    end
end

K=K+K2;
Kg=Kg+K3;
