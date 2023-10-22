function [D1cost] = D1COST(H,G,F,m,Q)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
g=size(H,2);
phi=F.*H/ (F*H');
U= exp(G./(F.*H));
DPH=zeros(g,g-1);
for j=1:g-1
    for k=1:g-1
        if j==k
            DPH(j,k)=(F(j)*(F*H')-F(j)*H(j)*(F(j)-F(g)))/(F*H')^2;
        else
            DPH(j,k)=-F(j)*H(j)*(F(k)-F(g))/(F*H')^2;
        end
    end
end
for k=1:g-1
    DPH(g,k)=(-F(g)*(F*H')-F(g)*H(g)*(F(k)-F(g)))/(F*H')^2;
end
    
DKL=zeros(1,g-1);
for k=1:g-1
    for j=1:g
        DKL(k)=DKL(k)-G(j)*DPH(j,k)/phi(j);
    end
end
DU=zeros(g,g-1);
for j=1:g-1
    DU(j,j)=-U(j)*G(j)/(F(j)*H(j)^2);
    DU(g,j)=U(g)*G(g)/(F(g)*H(g)^2);
end
DSS=zeros(1,g-1);
for s=1:g-1
    DSS(s)=m*F(g)*Q(g,s)*(-U(s)/U(g)+H(g)*(DU(s,s)*U(g)-U(s)*DU(g,s))/U(g)^2)+m*F(s)*Q(s,g)*(U(g)/U(s)+H(s)*(DU(g,s)*U(s)-U(g)*DU(s,s))/U(s)^2);
    for k=1:g-1
        if k~=s
            DSS(s)=DSS(s)+m*F(s)*Q(s,k)*(U(k)/U(s)-H(s)*U(k)*DU(s,s)/U(s)^2);
            DSS(s)=DSS(s)+m*F(k)*H(k)*Q(k,s)*DU(s,s)/U(k);
            DSS(s)=DSS(s)+m*F(g)*Q(g,k)*U(k)*(-1/U(g)-H(g)*DU(g,s)/U(g)^2);
            DSS(s)=DSS(s)+m*F(k)*H(k)*Q(k,g)*DU(g,s)/U(k);
        end
    end
end
D1cost=DKL-DSS;
end



