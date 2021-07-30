function [FGEO] = Shooting(H,G,F,m,Q,eps,para)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
S=sum(G./F);
Z=G./(F*S);
Y(1:g-1)=round(Z(1:g-1),3);
Y(g)=1-sum(Y(1:g-1));
%Y=[0.3 0.43 0.27];
[Tra,cost_store] = ReverseGeo1(G,Y,F,m,Q,100);
g=size(H,2);
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
geocost=[comp];
while hkcost> eps && i<200000
    [grd] = GRD( H, BG, F, m, Q)
    Y(1:g-1)= Y(1:g-1)-para* grd;
    Y(g)=1-sum(Y(1:g-1));
    [Tra,cost_store] = ReverseGeo1(G,Y,F,m,Q,100);
    [Tra1,cost_store1,comp] = BrokenGeo(Tra,Mean,cost_store,F,m,Q,0.01);
    BG=Tra1(1:end-1,:);
    K=OneStepGeo(BG(end,:),BG(end-1,:),m,Q,F);
    hkcost=OneStepCost(H,K,F,m,Q);
    HKcost=[HKcost;hkcost];
    geocost=[geocost;comp];
    i=i+1;
end

if i<200000
   FGEO=[H;K; BG(end:-1:1,:)];
else
    FGEO=[H;BG(end:-1:1, :)];
end

end

