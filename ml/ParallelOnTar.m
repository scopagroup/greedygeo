function [Results] = ParallelOnTar(TARSET,numcores,F,Q,m,mesh,Compare)
% parallelize the computation of finding the best path from H to G on n=numcores nodes on one computer
% BP is the best path, a1 is the cost of the best path.
p = gcp();
[sepTAR] = SepTAR(TARSET, numcores);
sepCOM= SepTAR(Compare, numcores);



for idx = 1:numcores
  f(idx) = parfeval(p,@GeoAndCost,5, sepTAR{idx}, F, m, Q, mesh, sepCOM{idx}); % Square size determined by idx
end

% collect the results as they become available.
Results = cell(numcores,5);
%tic
for idx = 1:numcores
  % fetchNext blocks until next results are available.
  [completedIdx,GEOSET,RevGEO,COSTSET,HG, DistAndCost] = fetchNext(f);
  Results{completedIdx,1} = GEOSET;
  Results{completedIdx,2} = RevGEO;
  Results{completedIdx,3} = COSTSET;
  Results{completedIdx,4} = HG;
  Results{completedIdx,5} = DistAndCost;
  
  
  %fprintf('Got result with index: %d.\n', completedIdx);
end
%toc

end

