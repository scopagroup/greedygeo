clear all
g=4;
opt=setup(g);
F=opt.F;
Q=opt.Q;
m=opt.m;
M=m*Q;
H=[0.7 0.1 0.1 0.1];
G=[0.2 0.2 0.5 0.1];
eps=10^(-4);
ST=3
S=sum(G./F);
Z=G./(F*S);

Y(1:g-1)=round(Z(1:g-1),3);
Y(g)=1-sum(Y(1:g-1));
tic
[YY,GeoCost1] = Shooting(H,G,ST,Y,F,m,Q,eps)
toc