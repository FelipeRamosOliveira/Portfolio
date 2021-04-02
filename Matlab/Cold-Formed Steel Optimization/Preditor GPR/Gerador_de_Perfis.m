function[Lf,t,L,l_log,E,fy,Dim]=PFFAle()  
%LOCALIZAR PARÂMETROS NA MATRIZ DE COMBINÇÃO

     Lf=100+rand*(700-100);         %Laguras das bobinas (mm)
     t=0.75+rand*(4-0.75);          %Epessuras (mm)
     L=750+rand*(4000-750);         %Comprimentos de vão/coluna (mm)
     l_log=log10(L);                %Log do vão 
     E=179-rand*(213.30-179);       %Modulo de Young (kN/mm)
     fy=0.209+rand*(0.615-0.209);   %Resistência ao escoamento (N/mm)
     q=90;

     bw=50+rand*(Lf-50); 
     bf=bw*(0.5+rand*(1.1-0.5));
     bs=bw*(0.1+rand*(0.44-0.1));

     Lf=bw+(2*bf)+(2*bs);
     
         Dim=[bf bs q];
     
    
