clear all
g=8;
opt=setup(g);
F=opt.F;
Q=opt.Q;
m=opt.m;
M=m*Q;
H=[0.5 0.1 0.1 0.1 0.05 0.05 0.05 0.05];
G=[0.05 0.05 0.1 0.05 0.05 0.1 0.5 0.1];
%H=[0.45 0.1 0.1 0.05 0.05 0.05 0.05 0.05 0.05 0.05];
%G=[0.05 0.05 0.05 0.05 0.05 0.05 0.05 0.1 0.45 0.1];
eps=10^(-4);
S=sum(G./F);
Z=G./(F*S);

%Y(1:g-1)=round(Z(1:g-1),3);
%Y(g)=1-sum(Y(1:g-1));
%Y=[0.09 0.06 0.1 0.07 0.05 0.1 0.42 0.11];
Y=[0.085, 0.065, 0.105, 0.0688, 0.0525, 0.1, 0.42, 0.1038];
%Y=[0.09 0.06 0.1 0.07 0.05 0.1 0.42 0.11]
tic
store = cell(6,4)
i = 1
for ST= 5:1:10
[YY,GeoCost1] = Shooting(H,G,ST,Y,F,m,Q,eps);
[a b]=min(GeoCost1);
[Tra,cost_store] = ReverseGeo1(G,YY(b,:),F,m,Q,10000)
store{i,1} = ST;
store{i,2} = a;
store{i,3} = YY(b,:);
store{i,4} = Tra;
i = i + 1;
end
