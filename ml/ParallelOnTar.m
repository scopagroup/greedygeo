function [Results] = ParallelOnTar(TARSET,numcores,H,F,Q,m,mesh)
% parallelize the computation of finding the best path from H to G on n=numcores nodes on one computer
% BP is the best path, a1 is the cost of the best path.
p = gcp();
[sepTAR] = SepTAR(TARSET, numcores);


% to request multiple evaluations, use a loop
for idx = 1:numcores
  f(idx) = parfeval(p,@GeoAndCost,3, H, sepTAR{idx}, F, m, Q, mesh); % Square size determined by idx
end

% collect the results as they become available.
Results = cell(numcores,3);
%tic
for idx = 1:numcores
  % fetchNext blocks until next results are available.
  [completedIdx,GEOSET,RevGEO,COSTSET] = fetchNext(f);
  Results{completedIdx,1} = GEOSET;
  Results{completedIdx,2} = RevGEO;
  Results{completedIdx,3} = COSTSET;
  
  %fprintf('Got result with index: %d.\n', completedIdx);
end
%toc

end

