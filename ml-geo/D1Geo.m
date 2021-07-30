function [DDX] = D1Geo(y,z,F,m,Q)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
g=size(y,2);
X=zeros(1,g);
for s=1:g
    X(s)=y(s)/F(s)*exp(F(s)/(F*y')-z(s)/y(s));
end
hx=X./(sum(X));
DX=zeros(g,g-1);
for s=1:g
    for k=1:g-1
        if s~=k
            DX(s,k)=y(s)*(F(g)-F(k))*exp(F(s)/(F*y')-z(s)/y(s))/(F*y')^2;
        else
            DX(s,k)=exp(F(s)/(F*y')-z(s)/y(s))*(1/F(s)+z(s)/(F(s)*y(s))-y(s)*(F(s)-F(g))/(F*y')^2);
        end
    end
end


DSX=zeros(1,g-1);
for k=1:g-1
    DSX(k)=exp(F(k)/(F*y')-z(k)/y(k))*(1/F(k)+z(k)/(F(k)*y(k))-y(k)*(F(k)-F(g))/(F*y')^2);
    for s=1:g
        if s~=k
            DSX(k)=DSX(k)+exp(F(s)/(F*y')-z(s)/y(s))*y(s)*(F(g)-F(k))/(F*y')^2;
        end
    end
end


DHXY=zeros(g,g-1);
for s=1:g
    for n=1:g-1
        DHXY(s,n)=(DX(s,n)*sum(X)-X(s)*DSX(n))/(sum(X))^2;
    end
end

e=zeros(g,g);
f=zeros(g,g);
for s=1:g
    for k=1:g
        e(s,k)=exp(-y(s)/(F(s)*hx(s))+y(k)/(F(k)*hx(k)));
        f(s,k)=exp(-z(s)/(F(s)*y(s))+z(k)/(F(k)*y(k)));
    end
end

DeY=zeros(g,g,g-1);
for s=1:g
    for k=1:g
        for l=1:g-1
            if s==l
                DeY(s,k,l)=e(s,k)*((-F(s)*hx(s)+y(s)*F(s)*DHXY(s,s))/(F(s)*hx(s))^2-y(k)*DHXY(k,s)/(F(k)*hx(k)^2));
            elseif k==l
                DeY(s,k,l)=e(s,k)*(y(s)*DHXY(s,k)/(F(s)*hx(s)^2)+(F(k)*hx(k)-y(k)*F(k)*DHXY(k,k))/(F(k)*hx(k)^2));
            else
                DeY(s,k,l)=e(s,k)*(y(s)*DHXY(s,l)/(F(s)*hx(s)^2)-y(k)*DHXY(k,l)/(F(k)*hx(k)^2));   
            end
        end
    end
end

DaY=zeros(g,g-1);
for s=1:g
    for l=1:g-1
        if l==s
            day=0;
            for k=1:g
                if k~=s
                    day=day+DeY(s,k,s)*Q(s,k)-Q(k,s)*F(k)*(e(k,s)*(DX(k,s)*X(s)-X(k)*DX(s,s))/X(s)^2+X(k)*DeY(k,s,s)/X(s));
                end
            end
            DaY(s,l)=day;
        else
            day=0;
            for k=1:g
                if k~=s
                    day=day+Q(s,k)*DeY(s,k,l)-F(k)*Q(k,s)*(e(k,s)*(DX(k,l)*X(s)-X(k)*DX(s,l))/X(s)^2+X(k)*DeY(k,s,l)/X(s));
                end
            end
            DaY(s,l)=day;
        end
    end
end


DfY=zeros(g,g,g-1);
for s=1:g
    for k=1:g
        for l=1:g-1
            if s==l
                DfY(s,k,l)=f(s,k)*z(s)/(F(s)*y(s)^2);
            elseif k==l
                DfY(s,k,l)=-f(s,k)*z(k)/(F(k)*y(k)^2);
            end
        end
    end
end


DbY=zeros(g,g-1);
for s=1:g
    for l=1:g-1
        if s==l
            dby=0;
            for k=1:g
                dby=dby+z(s)*f(s,k)*Q(s,k)/y(s)^2-(F(s)+z(s)/y(s))*(Q(s,k)*DfY(s,k,s))+2*z(s)*F(k)*y(k)*Q(k,s)*f(k,s)/(F(s)*y(s)^3)-z(s)*F(k)*y(k)*Q(k,s)*DfY(k,s,s)/(F(s)*y(s)^2);
            end
            DbY(s,l)=dby;
        else
            DbY(s,l)=-(F(s)+z(s)/y(s))*Q(s,l)*DfY(s,l,l)-z(s)*F(l)*y(l)*Q(l,s)*DfY(l,s,l)/(F(s)*y(s)^2)-z(s)*F(l)*Q(l,s)*f(l,s)/(F(s)*y(s)^2);
        end
    end
end
      


alpha=zeros(1,g);
beta=zeros(1,g);
for s=1:g
    for k=1:g
        if k~=s
            alpha(s)=alpha(s)+Q(s,k)*e(s,k)-F(k)*X(k)*Q(k,s)*e(k,s)/(F(s)*X(s));
            beta(s)=beta(s)+F(s)*Q(s,k)-(F(s)+z(s)/y(s))*f(s,k)*Q(s,k)-z(s)*F(k)*y(k)*Q(k,s)*f(k,s)/(f(s)*y(s)^2);
        end
    end
end

DSXab=zeros(1,g-1);
for s=1:g-1
    for t=1:g
        DSXab(s)=DSXab(s)+DHXY(t,s)*(alpha(t)+beta(t))+hx(t)*(DaY(t,s)+DbY(t,s));
    end
end

w=alpha+beta-hx*(alpha+beta)';
DWY=zeros(g,g-1);
for s=1:g
    for l=1:g-1
        DWY(s,l)=DaY(s,l)+DbY(s,l)-DSXab(l);
    end
end

DDX=zeros(g-1,g-1);
for s=1:g-1
    for l=1:g-1
        DDX(s,l)=DHXY(s,l)*(1+m*w(s))+m*hx(s)*DWY(s,l);
    end
end

           

end

