function output = MAX_MIN(x,y,s,Range)
%output = fpeak(x,y,s,range)
%       x e y , comprimento (L) e carga crtica (Pcr)
%       s: sensibilidade da função (default=1)
%       Range (pocional): intervalo [ xmin xmax ymin ymax] 
%       output: mínímos e máximos loccais do vetor

rx = size(x,1);
ry = size(y,1);
if  rx==1
    x = x';
    rx = length(x);
end
if  ry==1;
    y = y';
    ry = length(y);
end
if  rx~=ry
    fprintf('%s','Os vetores tem que ter o mesmo tamanho!');
    return
end
s(2) = 0;
if ~s(1)
    s(1) = 1;
end
s(2) = [];
numP = 1;
Data = sortrows([x,y]);
for i=1:rx
    isP = picos(Data,i,s);
    if  sum(isnan(isP))==0
        output(numP,:) = isP; %#ok
        numP = numP + 1;
    end
end
if nargin == 4
    index_ = output(:,1)>=Range(1) & output(:,1)<=Range(2);
    output = output(index_,:);
    clear index_
    index_ = output(:,2)>=Range(3) & output(:,2)<=Range(4);
    output = output(index_,:);
end

%-------------------------------------------
function p = picos(Data,i,s)
%Seleção de pontos por sensibilidade 
if i-s<1
    crist = 1;
else
    crist = i-s;
end
y = Data(:,2);
if i+s>length(y)
    vale = length(y);
else
    vale = i + s;
end
tP = (sum(y(crist:vale)>=y(i))==1);
bP = (sum(y(crist:vale)<=y(i))==1);
if tP==1 || bP==1
    p = Data(i,:);
else
    p = [nan,nan];
end