function [BP,a1,CC] = ParallelOneComp(PENSET,numcores,H,G,F,Q,m, mesh,quan)
% parallelize the computation of finding the best path from H to G on n=numcores nodes on one computer
% BP is the best path, a1 is the cost of the best path.
p = gcp();
Pen= SepPEN(PENSET, numcores);
CC=0;
[Tra1, cost_store1, comp] = PreTest(H,G,F,m,Q);
% to request multiple evaluations, use a loop

for idx = 1:numcores
    sepPEN{idx}= PENset(Pen{idx},mesh);
    pen{idx} = GeneratePEN1(sepPEN{idx}, G, F,m,Q, quan);
    
    f(idx) = parfeval(p,@GeodesicAndCost2,6 ,H,G,pen{idx},F,Q,m,comp); % Square size determined by idx
end

% collect the results as they become available.
Results = cell(numcores,5);
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
  %fprintf('Got result with index: %d.\n', completedIdx);
end
%toc
minlist=zeros(numcores,2);
for i=1:numcores
    if ~isempty(Results{i,1})
    [a, b]= min(Results{i,5}(1:(Results{i,6}-1)));
    minlist(i,:)=[a b];
    else
        minlist(i,:)=[1000 1000];
    end
end
[a1, b1]=min(minlist(:,1))

%fprintf('the best path from H to G is\n')
if a1==1000
    BP=[];
else
BP=Results{b1,3}{minlist(b1,2)}(end:-1:1,:);
end
end

