function runGreedySearchNID1( nodeID, numnodes, outdir )
% RUNGREEDYSEARCHNID runs the greedy search on a single node and stores
% result in mat-file
%
% input:
%   numodes     total number of nodes considered
%   nodeID      id of particular node

% setup for problem
 load HGpair400dim5.mat TAR
 TAR=TAR(1:240,:);
 %load CompareTask1.mat Compare1
 %Compare=Compare1;
 Compare=ones(240,3)*0.25;
 g=5;
 opt=setup(g);
 F=opt.F;
 Q=opt.Q;
 m=opt.m;
 M=m*Q;
 mesh=0.01;
 tic
        
 sepTAR = SepTAR( TAR, numnodes ); 
 sepCom= SepTAR(Compare,numnodes);
fprintf('executing search on node %d\n', nodeID);
tic
        
       
    
       
[Results] = ParallelOnTar(sepTAR{nodeID},12,F,Q,m,mesh,sepCom{nodeID});
    
time=toc
resultname = [outdir,'/','Quan0.25dim5New1-result-for-node', num2str(nodeID) '.mat' ];

% save to file
save( resultname, 'Results','F', 'time')






end
