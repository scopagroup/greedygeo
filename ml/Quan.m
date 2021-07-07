function [quan] = Quan(G,g,F,m,Q,p)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

C=[];
H=[];
for i=1:1000000
    h=zeros(1,g);
    h(1:g-1)=unifrnd(0.05,0.95,1,g-1);
    h=round(h,5);
    if sum(h)<0.95
       
       h(g)=1-sum(h);
       
       H=[H;h];
       C=[C;OneStepCost(h,G,F,m,Q)];     
    end
end
quan=quantile(C,p);
    
            


end

