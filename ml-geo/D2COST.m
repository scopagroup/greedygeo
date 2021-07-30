function [D2Cost] = D2COST(H,G,F,m,Q)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
g=size(H,2);
phi=F.*H/ (F*H');
U= exp(G./(F.*H));
DKL=zeros(1,g-1);
for i=1:g-1
    DKL(i)=log(G(i)/phi(i))-log(G(g)/phi(g));
end
DSS=zeros(1,g-1);
for l=1:g-1
    dss=0;
    for k=1:g-1
        if k~=l
            dss=dss-m*Q(l,k)*U(k)/U(l)+ m*F(k)*H(k)*Q(k,l)*U(l)/(U(k)*F(l)*H(l));
        end
    end
    for k=1:g-1
        dss=dss+m*U(k)*Q(g,k)/U(g)-m*F(k)*H(k)*Q(k,g)*U(g)/(U(k)*F(g)*H(g));
    end
    DSS(l)=dss;
end
D2Cost=DKL-DSS;

end

