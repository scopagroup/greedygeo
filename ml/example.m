clear
format long;tic
g=5;
opt=setup(g);
F=opt.F;
Q=opt.Q;
m=opt.m;
M=m*Q;

%H=[0.8 0.05 0.05 0.05 0.05];
%G=[0.1 0.2 0.2 0.4 0.1];
%mesh=0.005;
%PEN=[0.05 0.2;0.1 0.3;0.1 0.3;0.3 0.4];
H=[0.8, 0.05, 0.05, 0.05, 0.05];
G=[0.1, 0.1, 0.2, 0.5, 0.1];
mesh=0.002;
PEN=[0.1 0.2;0.1 0.12;0.15 0.25;0.42 0.46];

PENSET=PENset(PEN,mesh);
tic
numcores=10
[BP,a1,CC] = ParallelOneComp(PENSET,numcores,H,G,F,Q,m)
toc
tic
[GEO COST GEO1 COST1 COSTT C] = GeodesicAndCost1(H,G,PENSET,F,Q,m);
toc
[a b]=min(COSTT(1:C-1))
fprintf('the best path from H to G is')
GEO1{b}(end:-1:1,:)

%tic
%[geo cost geo1 cost1 COST c] = GeodesicAndCost(H,G,PEN,mesh,F,Q,m);
%fprintf('computing times is %s\n',toc)
%[a1 b1]=min(COST(1:c-1));
%fprintf('the best path from H to G is')
%geo1{b}(end:-1:1,:)
%toc

