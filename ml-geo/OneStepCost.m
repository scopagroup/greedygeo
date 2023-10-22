function [cost]= OneStepCost(H,G,F,m,Q)
% Given H,G, cost is the one step cost from H to G
% if the cost is not a real value or negative, cost=0
g=length(H);
E=zeros(g,g);


M=m*Q;
q=F.*H/(F*H');

for j=1:g
    
    for k=1:g
        E(j,k)=exp(G(k)/(F(k)*H(k))-G(j)/(F(j)*H(j)));
    end
end


sum2=0;
sum1=sum(G.*log(G./q));


for j=1:g
    
    for k=1:g
        sum2=sum2+M(j,k)*F(j)*H(j)*(1-E(j,k));
    end
end                        
cost=sum1+sum2;
if isinf(cost)|| isnan(cost) || ~isreal(cost) || cost<0
    cost=0;
end

end
