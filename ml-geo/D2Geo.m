function [DD] = D2Geo(y,z,F,m,Q)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
g=size(y,2);
X=zeros(1,g);
for s=1:g
    X(s)=y(s)/F(s)*exp(F(s)/(F*y')-z(s)/y(s));
end
hx=X./(sum(X));
DX=zeros(g,g-1);
for s=1:g-1
    DX(s,s)=-1/F(s)*exp(F(s)/(F*y')-z(s)/y(s));
end

DHXZ=zeros(g,g-1);
for s=1:g
    for l=1:g-1
        if l==s
            DHXZ(s,l)= (DX(s,s)*sum(X)-X(s)*DX(s,s))/(sum(X))^2;
        else
            DHXZ(s,l)= -X(s)*DX(l,l)/(sum(X))^2;
        end
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

DEZ=zeros(g,g,g-1);
for s=1:g
    for k=1:g
        for l=1:g-1
            DEZ(s,k,l)=e(s,k)*(y(s)*DHXZ(s,l)/(F(s)*hx(s)^2)-y(k)*DHXZ(k,l)/(F(k)*hx(k)^2));
        end
    end
end

DaZ=zeros(g,g-1);
for s=1:g
    for l=1:g-1
        if l==s
            daz=0;
            for k=1:g
                if k~=s
                    daz=daz+Q(s,k)*DEZ(s,k,s)-F(k)*X(k)*Q(k,s)*(DEZ(k,s,s)*X(s)-e(k,s)*DX(s,s)/(F(s)*X(s)^2));
                end
            end
            DaZ(s,l)=daz;
        else
            daz=Q(s,l)*DEZ(s,l,l)-F(l)*Q(l,s)*(DX(l,l)*e(l,s)+X(l)*DEZ(l,s,l))/(F(s)*X(s));
            for k=1:g
                if k~=s && k~=l
                    daz=daz+Q(s,k)*DEZ(s,k,l)-F(k)*X(k)*Q(k,s)*DEZ(k,s,l)/(F(s)*X(s));
                end
            end
            DaZ(s,l)=daz;
        end
    end
end

DfZ=zeros(g,g,g-1);
for s=1:g
    for k=1:g
        for l=1:g-1
            if s==l
                DfZ(s,k,l)=-f(s,k)/(F(s)*y(s));
            elseif k==l
                DfZ(s,k,l)=f(s,k)/(F(k)*y(k));
            end
        end
    end
end

               
DbZ=zeros(g,g-1);
for s=1:g
    for l=1:g-1
        if l==s
            dbz=0;
            for k=1:g
                dbz=-f(s,k)*Q(s,k)/y(s)-(F(s)+z(s)/y(s))*(Q(s,k)*DfZ(s,k,s))-F(k)*y(k)*Q(k,s)*f(k,s)/(F(s)*y(s)^2)-z(s)*F(k)*y(k)*Q(k,s)*DfZ(k,s,s)/(F(s)*y(s)^2);
            end
            DbZ(s,l)=dbz;
        else
            dbz=0;
            for k=1:g
                if k~=s
                    dbz=dbz-(F(s)+z(s)/y(s))*Q(s,k)*DfZ(s,k,l)-z(s)/(F(s)*y(s)^2)*F(k)*y(k)*Q(k,s)*DfZ(k,s,l);
                end
            end
            DbZ(s,l)=dbz;
        end
    end
end

alpha=zeros(1,g);
beta=zeros(1,g);
for s=1:g
    for k=1:g
        if k~=s
            alpha(s)=alpha(s)+Q(s,k)*e(s,k)-F(k)*X(k)*Q(k,s)*e(k,s)/(F(s)*X(s));
            beta(s)=F(s)*Q(s,k)-(F(s)+z(s)/y(s))*f(s,k)*Q(s,k)-z(s)*F(k)*y(k)*Q(k,s)*f(k,s)/(f(s)*y(s)^2);
        end
    end
end

DSHXab=zeros(1,g-1);
for s=1:g-1
    for t=1:g
        DSHXab(s)=DSHXab(s)+DHXZ(t,s)*(alpha(t)+beta(t))+hx(t)*(DaZ(t,s)+DbZ(t,s));
    end
end
        
DWZ=zeros(g,g-1);
for s=1:g
    for l=1:g-1
        DWZ(s,l)=DaZ(s,l)+DbZ(s,l)-DSHXab(l);
    end
end
w=alpha+beta-hx*(alpha+beta)';
DD=zeros(g-1,g-1);
for s=1:g-1
    for l=1:g-1
        DD(s,l)=DHXZ(s,l)*(1+m*w(s))+hx(s)*m*DWZ(s,l);
    end
end

          
end

