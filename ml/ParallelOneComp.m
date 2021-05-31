function [BP,a1,CC] = ParallelOneComp(PENSET,numcores,H,G,F,Q,m)

% parallelize the computation of finding the best path from H to G on n=numcores nodes on one computer
% BP is the best path, a1 is the cost of the best path.
p = gcp();
[sepPEN] = SepPEN1(PENSET, numcores);

% to request multiple evaluations, use a loop
for idx = 1:numcores
  f(idx) = parfeval(p,@GeodesicAndCost1,6,H,G,sepPEN{idx},F,Q,m); % Square size determined by idx
end

% collect the results as they become available.
Results = cell(numcores,5);
CC=0;
%tic
for idx = 1:numcores
  % fetchNext blocks until next results are available.
  [completedIdx,GEO,COST,GEO1,COST1,Total_cost,Count] = fetchNext(f);
  Results{completedIdx,1} = GEO;
  Results{completedIdx,2} = COST;
  Results{completedIdx,3} = GEO1;
  Results{completedIdx,4} = COST1;
  Results{completedIdx,5} = Total_cost;
  Results{completedIdx,6} = Count;
  CC=CC+Count;
  fprintf('retrieved result with index: %d.\n', completedIdx);
end
%toc
minlist=zeros(numcores,2);
for i=1:numcores
    [a, b]= min(Results{i,5}(1:(Results{i,6}-1)));
    minlist(i,:)=[a b];
end
[a1, b1]=min(minlist(:,1));

%fprintf('the best path from H to G is\n')
BP=Results{b1,3}{minlist(b1,2)}(end:-1:1,:);

end

