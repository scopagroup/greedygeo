function runGreedySearchNID( nodeID, numnodes, outdir )
% RUNGREEDYSEARCHNID runs the greedy search on a single node and stores
% result in mat-file
%
% input:
%   numodes     total number of nodes considered
%   nodeID      id of particular node

% setup for problem
g=5;
opt=setup(g);
F=opt.F;
Q=opt.Q;
m=opt.m;
M=m*Q;
H=[0.8, 0.05, 0.05, 0.05, 0.05];
G=[0.1, 0.1, 0.2, 0.5, 0.1];
mesh=0.001;
PEN=[0.1 0.2;0.1 0.12;0.15 0.25;0.42 0.46];

%H=[0.8 0.05 0.05 0.05 0.05];
%G=[0.1 0.2 0.2 0.4 0.1];
%mesh=0.005;
%PEN=[0.05 0.2;0.1 0.3;0.1 0.3;0.3 0.4];

%  construct the subsets of the search grid for the greedy algorithm
PENSET=PENset(PEN,mesh);
sepPEN = SepPEN1( PENSET, numnodes );

% execute greedy search on one node (with 10 parallel procs)

fprintf('executing search on node %d\n', nodeID);
[BP, cost_BP] = ParallelOneComp(sepPEN{nodeID}, 10, H, G, F, Q, m );

% construct file name for output
resultname = [outdir,'/','result-for-node', num2str(nodeID) '.mat' ];

% save to file
save( resultname, 'BP', 'cost_BP' )

end
