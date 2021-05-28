clear all
p = gcp();
numcores = 8
g=5;
F=[200,200^1.08,200^1.1,200^1.11,200^1.12]; 
Q=[0 0.25 0.25 0.25 0.25
   0.25 0 0.25 0.25 0.25
   0.25 0.25 0 0.25 0.25
   0.25 0.25 0.25 0 0.25
   0.25 0.25 0.25 0.25 0];
   
m=1/10^6;
M=m*Q;
H=[0.8 0.05 0.05 0.05 0.05];
G=[0.1 0.1 0.1 0.6 0.1];
mesh=0.003;
PEN=[0.05 0.2;0.05 0.2;0.05 0.2;0.5 0.6];
PENSET = PENset(PEN,mesh);
[sepPEN] = SepPEN1(PENSET, numcores);

% to request multiple evaluations, use a loop
for idx = 1:numcores
  f(idx) = parfeval(p,@GeodesicAndCost1,6,H,G,sepPEN{idx},F,Q,m); % Square size determined by idx
end

% collect the results as they become available.
Results = cell(numcores,5);
tic
for idx = 1:numcores
  % fetchNext blocks until next results are available.
  [completedIdx,GEO,COST,GEO1,COST1,Total_cost,Count] = fetchNext(f);
  Results{completedIdx,1} = GEO;
  Results{completedIdx,2} = COST;
  Results{completedIdx,3} = GEO1;
  Results{completedIdx,4} = COST1;
  Results{completedIdx,5} = Total_cost;
  Results{completedIdx,6} = Count;
  %fprintf('Got result with index: %d.\n', completedIdx);
end
toc
minlist=zeros(numcores,2);
for i=1:numcores
    
    [a, b]= min(Results{i,5}(1:(Results{i,6}-1)));
    minlist(i,:)=[a b];
end
[a1, b1]=min(minlist(:,1));
fprintf('the best path from H to G is\n')
Results{b1,3}{minlist(b1,2)}(end:-1:1,:)

