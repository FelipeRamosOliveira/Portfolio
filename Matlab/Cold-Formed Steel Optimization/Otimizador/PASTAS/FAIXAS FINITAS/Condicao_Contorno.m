function [I] = Condicao_Contorno(CC,a,pp,qq)
%CONDICAO_CONTORNO Calculo das integrais referente aos apoios
%   Calculo das Integrais I(1), I(2), I(3), I(4) e I(5) referente as condições
%   de contorno
%
% INPUT
%    CC: ['A-A'] string especificando o tipo de apoios:
%        'A-A' apoiado-apoiado nas extrmidades onde sao carrregadas
%        'E-E' engastado-engastado nas extrmidades onde sao carrregadas
%     a: comprimento no eixo longitudinal
% pp,qq: termos de meias-ondas.
%
% OUTPUT:
% I(1),I(2),I(3),I(4),I(5):
%   I(1) integração de Yp*Yq de 0 à a
%   I(2) integração de Yp"*Yq  de 0 à a
%   I(3) integração de Yp*Yq"  de 0 à a
%   I(4) integração de Yp"*Yq" f de 0 à a
%   I(5) integração de Yp'*Yq'  de 0 à a
%
%   João Alfredo de Lazzari, Abril 2019

I=zeros(1,5);
if strcmp(CC,'A-A')
    % Para condicoes de contorno apoiado-apoiado
    if pp==qq
        I(1)=a/2;
        I(2)=-(pp^2*pi^2)/(2*a);
        I(3)=I(2);
        I(4)=(pi^4*pp^4)/(2*a^3);
        I(5)=(pi^2*pp^2)/(2*a);
    end
elseif strcmp(CC,'E-E')
    % Para condicoes de contorno engastado-engastado
    if pp==qq
        if pp==1
            I(1)=3*a/8;
        else
            I(1)=a/4;
        end
        I(2)=-(pp^2+1)*pi^2/4/a;
        I(3)=-(qq^2+1)*pi^2/4/a;
        I(4)=pi^4*((pp^2+1)^2+4*pp^2)/4/a^3;
        I(5)=(1+pp^2)*pi^2/4/a;
    else
        if pp-qq==2
            I(1)=-a/8;
            I(2)=(pp^2+1)*pi^2/8/a-pp*pi^2/4/a;
            I(3)=(qq^2+1)*pi^2/8/a+qq*pi^2/4/a;
            I(4)=-(pp-1)^2*(qq+1)^2*pi^4/8/a^3;
            I(5)=-(1+pp*qq)*pi^2/8/a;
        elseif pp-qq==-2
            I(1)=-a/8;
            I(2)=(pp^2+1)*pi^2/8/a+pp*pi^2/4/a;
            I(3)=(qq^2+1)*pi^2/8/a-qq*pi^2/4/a;
            I(4)=-(pp+1)^2*(qq-1)^2*pi^4/8/a^3;
            I(5)=-(1+pp*qq)*pi^2/8/a;
        end
    end
    
else
    % Para as demais condições de contorno  
    disp('ATENÇÃO: A condição de contorno informada não está implementada, ou não existe!')
    return
end


end

