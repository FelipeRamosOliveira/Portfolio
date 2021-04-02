function [Ksoma] = Montar(Ksoma,K_pq,pp,qq,NNOS,no1,no2)
%MONTAR Monta as matrizes de rigidez e geometrica considerando cada grau de
% liberdade e o os comprimentos de onda.
%   Detailed explanation goes here
%
% GL [u1 v1 u2 v2 w1 theta1 w2 theta2]'
% vetor de deslocamentos nodais global GL [u1 v1 u2 v2...un vn   w1 01 w2 02...wn 0n]'
%
%
%   João Alfredo de Lazzari, Fevereiro 2019  (fonte: Z. Li, June 2010)

p1 = 2*NNOS*(2*(pp-1)); % Acessa os graus de liberdade u e v do modo pp.
q1 = 2*NNOS*(2*(qq-1)); % Acessa os graus de liberdade u e v do modo qq.
p2 = 2*NNOS*(2*(pp-1) + 1); % Acessa os graus de liberdade w e theta do modo pp.
q2 = 2*NNOS*(2*(qq-1) + 1); % Acessa os graus de liberdade w e theta do modo qq.

no11 = 2*no1 - 1; % Acessa os graus de liberdade u1 e w1
no12 = 2*no1;     % Acessa os graus de liberdade v1 e theta1
no21 = 2*no2 - 1; % Acessa os graus de liberdade u2 e w2
no22 = 2*no2;     % Acessa os graus de liberdade v2 e theta2

u1_p = p1 + no11; % Acessa o grau de liberdade u1 para o modo pp
v1_p = p1 + no12; % Acessa o grau de liberdade v1 para o modo pp
u2_p = p1 + no21; % Acessa o grau de liberdade u2 para o modo pp
v2_p = p1 + no22; % Acessa o grau de liberdade v2 para o modo pp
w1_p = p2 + no11; % Acessa o grau de liberdade w1 para o modo pp
O1_p = p2 + no12; % Acessa o grau de liberdade theta1 para o modo pp
w2_p = p2 + no21; % Acessa o grau de liberdade w2 para o modo pp
O2_p = p2 + no22; % Acessa o grau de liberdade theta2 para o modo pp

u1_q = q1 + no11; % Acessa o grau de liberdade u1 para o modo qq
v1_q = q1 + no12; % Acessa o grau de liberdade v1 para o modo qq
u2_q = q1 + no21; % Acessa o grau de liberdade u2 para o modo qq
v2_q = q1 + no22; % Acessa o grau de liberdade v2 para o modo qq
w1_q = q2 + no11; % Acessa o grau de liberdade w1 para o modo qq
O1_q = q2 + no12; % Acessa o grau de liberdade theta1 para o modo qq
w2_q = q2 + no21; % Acessa o grau de liberdade w2 para o modo qq
O2_q = q2 + no22; % Acessa o grau de liberdade theta2 para o modo qq

                                                  % MODO:   pp       qq
Ksoma(u1_p : v1_p , u1_q : v1_q) = K_pq(1:2,1:2); %K11 - [u1 v1] e [u1 v1]
Ksoma(u1_p : v1_p , u2_q : v2_q) = K_pq(1:2,3:4); %K12 - [u1 v1] e [u2 v2]
Ksoma(u2_p : v2_p , u1_q : v1_q) = K_pq(3:4,1:2); %K21 - [u2 v2] e [u1 v1]
Ksoma(u2_p : v2_p , u2_q : v2_q) = K_pq(3:4,3:4); %K22 - [u2 v2] e [u2 v2]

Ksoma(w1_p : O1_p , w1_q : O1_q) = K_pq(5:6,5:6); %K33 - [w1 01] e [w1 01]
Ksoma(w1_p : O1_p , w2_q : O2_q) = K_pq(5:6,7:8); %K34 - [w1 01] e [w2 02]
Ksoma(w2_p : O2_p , w1_q : O1_q) = K_pq(7:8,5:6); %K43 - [w2 02] e [w1 01]
Ksoma(w2_p : O2_p , w2_q : O2_q) = K_pq(7:8,7:8); %K44 - [w2 02] e [w2 02]
%
Ksoma(u1_p : v1_p , w1_q : O1_q) = K_pq(1:2,5:6); %K13 - [u1 v1] e [w1 01]
Ksoma(u1_p : v1_p , w2_q : O2_q) = K_pq(1:2,7:8); %K14 - [u1 v1] e [w2 02]
Ksoma(u2_p : v2_p , w1_q : O1_q) = K_pq(3:4,5:6); %K23 - [u2 v2] e [w1 01]
Ksoma(u2_p : v2_p , w2_q : O2_q) = K_pq(3:4,7:8); %K24 - [u2 v2] e [w2 02]
%                                                                                                                                         
Ksoma(w1_p : O1_p , u1_q : v1_q) = K_pq(5:6,1:2); %K31 - [w1 01] e [u1 v1]
Ksoma(w1_p : O1_p , u2_q : v2_q) = K_pq(5:6,3:4); %K32 - [w1 01] e [u2 v2]
Ksoma(w2_p : O2_p , u1_q : v1_q) = K_pq(7:8,1:2); %K41 - [w2 02] e [u1 v1]
Ksoma(w2_p : O2_p , u2_q : v2_q) = K_pq(7:8,3:4); %K42 - [w2 02] e [u2 v2]

%          u1   v1   u2   v2   w1   01   w2  02
%    
%          k11 k12 | k13 k14 | k15 k16 | k17 k18   u1  % K11 | K12 | K13 | K14
%          k21 k22 | k23 k24 | k25 k26 | k27 k28   v1  %     |     |     | 
%          --------|---------|---------|--------       % ----|-----|-----|----
%          k31 k32 | k33 k34 | k35 k36 | k37 k38   u2  % K21 | K22 | K23 | K24 
% K_pq  =  k41 k42 | k43 k44 | k45 k46 | k47 k48   v2  %     |     |     |  
%          --------|---------|---------|--------       % ----|-----|-----|----
%          k51 k52 | k53 k54 | k55 k56 | k57 k58   w1  % K31 | K32 | K33 | K34 
%          k61 k62 | k63 k64 | k65 k66 | k67 k68   01  %     |     |     |  
%          --------|---------|---------|--------       % ----|-----|-----|----
%          k71 k72 | k73 k74 | k75 k76 | k77 k78   w2  % K41 | K42 | K43 | K44 
%          k81 k82 | k83 k84 | k85 k86 | k87 k88   02  %     |     |     |   
%         

end

