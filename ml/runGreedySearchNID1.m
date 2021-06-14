function runGreedySearchNID1( nodeID, numnodes, outdir )
% RUNGREEDYSEARCHNID runs the greedy search on a single node and stores
% result in mat-file
%
% input:
%   numodes     total number of nodes considered
%   nodeID      id of particular node

% setup for problem
 load HGpair.mat TAR
 load CompareTask4.mat Compare4
 Compare=Compare4;
 %Compare=ones(400,2)*0.14;
 g=3;
 opt=setup(g);
 F=opt.F;
 Q=opt.Q;
 m=opt.m;
 M=m*Q;
 mesh=0.001;
 tic
        
 sepTAR = SepTAR( TAR, numnodes ); 
 sepCom= SepTAR(Compare,numnodes);
fprintf('executing search on node %d\n', nodeID);
tic
        
       
    
       
[Results] = ParallelOnTar(sepTAR{nodeID},10,F,Q,m,mesh,sepCom{nodeID});
    
time=toc
resultname = [outdir,'/','Task6-result-for-node', num2str(nodeID) '.mat' ];

% save to file
save( resultname, 'Results','F', 'time')






end
