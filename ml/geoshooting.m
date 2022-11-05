function [geo] = geoshooting(H,G,Y,STS, STE)
% H, starting histogram
% G, last histogram
% Y, initial penultimate histogram
% STS, smallest length -1
% STE, largest length -1
g = size(H,2);
opt=setup(g);
F=opt.F;
Q=opt.Q;
m=opt.m;
M=m*Q;
eps=10^(-4);
S=sum(G./F);
Z=G./(F*S);
store = cell(STE-STS+1,4)
i = 1
costlist= []
for ST= STS:1:STE
[YY,GeoCost1] = Shooting(H,G,ST,Y,F,m,Q,eps);
[a b]=min(GeoCost1);
[Tra,cost_store] = ReverseGeo1(G,YY(b,:),F,m,Q,10000);
costlist = [costlist a];
store{i,1} = ST;
store{i,2} = a;
store{i,3} = YY(b,:);
store{i,4} = Tra;
i = i + 1;
end
[l1,l2] = min(costlist);
geo{1,1} = store{l2,1}+1;
geo{1,2}= [H;store{l2,4}(store{l2,1}:-1:1,:)]
geo{1,3} = store{l2,2};
geo{1,4} = store{l2,3};
geo{1,5} = store{l2,4};
geo{1,6} = norm(H - store{l2,4}(store{l2,1}+1,:));
% geo{1,1}, geodesic length
% geo{1,2}, geodesic
% geo{1,3}, cost of geodesic
% geo{1,4}, penultimate histogram
% geo{1,5}, whole resever geodesic
% geo{1,6}, ||H -H'||
end

