function runGreedySearchNID( nodeID, numnodes, outdir )
% RUNGREEDYSEARCHNID runs the greedy search on a single node and stores
% result in mat-file
%
% input:
%   numodes     total number of nodes considered
%   nodeID      id of particular node

% setup for problem

g=7;
opt=setup(g);
F=opt.F;
Q=opt.Q;
m=opt.m;
M=m*Q;
%H=[0.8 0.05 0.05 0.05 0.05];
%G=[0.1 0.1 0.2 0.5 0.1];
H=[0.6, 0.1,0.1, 0.05, 0.05, 0.05, 0.05];
G=[0.1, 0.1, 0.1, 0.1,0.1 , 0.5, 0.1];
mesh=0.01;
PEN=[0.1 0.9;0.1 0.9;0.1 0.9;0.1 0.9;0.1 0.9;0.1 0.9];
p= 0.1;
[quan] = Quan(G,g,F,m,Q,p);


%  construct the subsets of the search grid for the greedy algorithm
tic
PENSET1= SepPEN(PEN, numnodes);

% execute greedy search on one node (with 10 parallel procs)

fprintf('executing search on node %d\n', nodeID);
[BP, cost_BP,Count] = ParallelOneComp(PENSET1{nodeID}, 10, H, G, F, Q, m, mesh, quan );
time=toc;
% construct file name for output
resultname = [outdir,'/','dim7quan0.1result-for-node', num2str(nodeID) '.mat' ];

% save to file
save( resultname, 'BP', 'cost_BP', 'Count', 'time','H','G')



end
