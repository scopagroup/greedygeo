function [Tra,cost_store] = ReverseGeo(Y,y,F,m,Q,Compare)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
M=m*Q;
g=size(Y,2);
Tra=zeros(30,g);
cost_store=zeros(30,1);
Tra(1:2,:)=[Y;y];
len=2;
cost_store(1:2,:)=[0;OneStepCost(y,Y,F,m,Q)];
z=Y;
store=y;
y=OneStepGeo(y,z,m,Q,F);
cc=OneStepCost(y,store,F,m,Q);
Flag=1;
while min(y)>0.001 && max(y)<1 && cc>0
    len=len+1;
    Tra(len,:)=y;
    cost_store(len)=cc;
    if len==3 && sum(cost_store)>Compare
        Flag=0;
        break;
    end
    z=store;
    store=y;
    y=OneStepGeo(y,z,m,Q,F);
    if ~all(y)
        break;
    else
        cc=OneStepCost(y,store,F,m,Q);
        if cc==0
            break;
        end
    end
end
 Tra=Tra(1:len,:);
 cost_store=cost_store(1:len);
if Flag==0
    Tra=zeros(1,g);
end
end

