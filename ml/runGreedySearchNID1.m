function runGreedySearchNID1( nodeID, numnodes, outdir )
% RUNGREEDYSEARCHNID runs the greedy search on a single node and stores
% result in mat-file
%
% input:
%   numodes     total number of nodes considered
%   nodeID      id of particular node

% setup for problem
%g=3;
%opt=setup(g);
%F=opt.F;
%Q=opt.Q;
%m=opt.m;
%M=m*Q;
%delta=0.02;
%TAR=[0.05 0.5;0.2 0.7];
%[TARSET] = TarSet(TAR,delta);
%H=[0.99, 0.005,0.005];
%mesh=0.001;
%fprintf('executing search on node %d\n', nodeID);

g=4;
opt=setup(g);
F=opt.F;
Q=opt.Q;
m=opt.m;
M=m*Q;
delta=0.05;
TAR=[0.05 0.5;0.2 0.7;0.2 0.7];
[TARSET] = TarSet(TAR,delta);
H=[0.9, 1/30, 1/30, 1/30];
mesh=0.001;


tic
        
       
sepTAR = SepTAR( TARSET, numnodes );     
       
[Results] = ParallelOnTar(sepTAR{nodeID},10,H,F,Q,m,mesh);
    
time=toc
resultname = [outdir,'/','F1-result-for-node', num2str(nodeID) '.mat' ];

% save to file
save( resultname, 'Results','F', 'H', 'time')






end
