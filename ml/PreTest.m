function [Tra1, cost_store1, comp] = PreTest(H,G,F,m,Q)
g=size(G,2);
HH=H;
%PENSET=PENset(PEN,mesh);
Mean=zeros(15,g);
Mean(1,:)=H;
for i=2:15
    [HH]= mean_trajectory(HH,F,m,Q);
    Mean(i,:)=HH;
end
y1= G./F;
y2=round(y1/sum(y1),5);
y=[y2(1,1:g-1) 1-sum(y2(1,1:g-1))];

Y=G;
M=m*Q;
Tra=zeros(30,g);
cost_store=zeros(30,1);
Tra(1:2,:)=[Y;y];
len=2;
cost_store(1:2,:)=[0;OneStepCost(y,Y,F,m,Q)];
z=Y;
store=y;
y=OneStepGeo(y,z,m,Q,F);
cc=OneStepCost(y,store,F,m,Q);

while min(y)>0.001 && max(y)<1 && cc>0 
    len=len+1;
    Tra(len,:)=y;
    cost_store(len)=cc;
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
 [Tra1,cost_store1,comp] = BrokenGeo(Tra,Mean,cost_store,F,m,Q,0.01);

end

