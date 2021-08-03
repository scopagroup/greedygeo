clear all
g=4;
opt=setup(g);
F=opt.F;
Q=opt.Q;
m=opt.m;
M=m*Q;
H=[0.7 0.1 0.1 0.1];
G=[0.1 0.1 0.7 0.1];
eps=10^(-4);
para=10^(-8);
tic
[FGEO] = Shooting(H,G,F,m,Q,eps,para);
toc
