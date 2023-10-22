function x= OneStepGeo(y,z,m,Q,F)
% this function computes the reverse geodesic x=H_T, given H_{t+1}=y and
% H_{T+2}=z

g=length(y);


alpha=zeros(1,g);
beta=zeros(1,g);
w=zeros(1,g);
e=zeros(g,g);
f=zeros(g,g);

X=(y./F).*exp(F./(F*y')-z./y);
sum1=sum(X);
xx=X./sum1;

for s=1:g
    for k=1:g
        e(s,k)=exp(-y(s)/(F(s)*xx(s))+y(k)/(F(k)*xx(k)));
        f(s,k)=exp(-z(s)/(F(s)*y(s))+z(k)/(F(k)*y(k)));
    end
end

for s=1:g
   
    
    sum3=sum(Q(s,:));
    sum4=sum(f(s,:).*Q(s,:));
    sum5=0;
    for k=1:g
        alpha(s)=alpha(s)+Q(s,k)*e(s,k)-(F(k)*X(k)*Q(k,s)*e(k,s))/(F(s)*X(s));
        
        sum5=sum5+F(k)*y(k)*Q(k,s)*f(k,s);
        
    end
    
    
    beta(s)=F(s)*sum3-(F(s)+z(s)/y(s))*sum4-z(s)*sum5/(F(s)*(y(s))^2);
end

w=alpha+beta-xx*(alpha'+beta');


x=xx+m*(xx.*w);

if isinf(any(x)) || isnan(any(x))|| ~isreal(all(x)) || min(x)<0 ||max(x)>1
    x=zeros(1,g);
end


end

