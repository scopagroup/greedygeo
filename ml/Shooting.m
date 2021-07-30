function [FGEO] = Shooting(H,G,F,m,Q,eps,para)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
g=size(H,2);
S=sum(G./F);
Z=G./(F*S);
Y(1:g-1)=round(Z(1:g-1),3);
Y(g)=1-sum(Y(1:g-1));
%Y=[0.3 0.43 0.27];
[Tra,cost_store] = ReverseGeo1(G,Y,F,m,Q,100);

HH=H;

Mean=zeros(15,g);
Mean(1,:)=H;
for i=2:15
    [HH]= mean_trajectory(HH,F,m,Q);
    if min(HH)>0.005
       Mean(i,:)=HH;
    else
        Mean=Mean(1:i-1,:);
        break;
    end
end
[Tra1,cost_store1,comp] = BrokenGeo(Tra,Mean,cost_store,F,m,Q,0.01);
BG=Tra1(1:end-1,:);
K=OneStepGeo(BG(end,:),BG(end-1,:),m,Q,F);
i=1;
hkcost=OneStepCost(H,K,F,m,Q);
HKcost=[hkcost];
GeoCost=[comp];
GeoCost1=GeoCost;
GRDN=[];
while hkcost> eps && i<200000
    [grd] = GRD( H, BG, F, m, Q);
    
    Y(1:g-1)= Y(1:g-1)-para* grd;
    Y(g)=1-sum(Y(1:g-1));
    [Tra,cost_store] = ReverseGeo1(G,Y,F,m,Q,100);
    [Tra1,cost_store1,comp] = BrokenGeo(Tra,Mean,cost_store,F,m,Q,0.01);
    BG=Tra1(1:end-1,:);
    K=OneStepGeo(BG(end,:),BG(end-1,:),m,Q,F);
    hkcost=OneStepCost(H,K,F,m,Q);
    
    geo=[H;K;BG(end:-1:1,:)];
    if rem(i,100)==0
        GRDN=[GRDN norm(grd)];
    HKcost=[HKcost;hkcost];
    geocost=TraCost(geo,F,m,Q);
    GeoCost1=[GeoCost1;comp];
    GeoCost=[GeoCost;sum(geocost)];
    end
    i=i+1;
end
subplot(1,3,1)
plot(HKcost)
title('Cost(H,K)')
subplot(1,3,2)
plot(GRDN)
title('Norm of GRD')
subplot(1,3,3)
plot(GeoCost)
title('Cost of geodesic')
FGEO=geo;
end

