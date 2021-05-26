
% TASK A) 

p = gcp();


numcores = 10

% to request multiple evaluations, use a loop
for idx = 1:numcores
  f(idx) = parfeval(p,@magic,1,idx); % Square size determined by idx
end

% collect the results as they become available.
magicResults 	= cell(1,10);
for idx = 1:numcores
  % fetchNext blocks until next results are available.
  [completedIdx,value] = fetchNext(f);
  magicResults{completedIdx} = value;
  fprintf('Got result with index: %d.\n', completedIdx);
end

% we want to split PEN up to run on
% individual nodes (computers); now
% we can have say 40 computers; this 
% would give us a speedup of 40x 
% (actually less than that); however,
% we can also run the code in parallel on
% a single computer; this will give us 
% another speedup (hopefully); so we have
% 40 computers each of which executes 10 
% processes, so, overall, ~10*40 faster  

% each node (computer) on opuntia has 20 
% cores; we want to use all 20 cores in parallel


% TASK B)

% B.1) create a function that takes an array b (vector of dim nx1) as input (corresponds to PEN)
% B.2) within function create a matrix A of size n x n that is invertible
% B.3) invert the linear system A*x = b (or compute an SVD of a and use this to invert A*x = b)
% B.4) make sure the function returns ARRAYS and numbers (corresponds to GEO1, Total_cost, Count); you can return x (GEO1) and a random vector (Total_cost) and a random number 

% B.5) See if this works in general
% B.6) as you increse the number of cores from 2, 4, 8, 20 does the time go down (which should exclude the setup costs); notice: it uses 4 WORKERS in my example, which means that it actually only uses for CORES


% THREE OPTIONS: parfor, pareval, spmd

% https://www.mathworks.com/help/parallel-computing/choosing-a-parallel-computing-solution.html

% https://www.mathworks.com/help/parallel-computing/simple-parfeval-example.html
% https://www.mathworks.com/help/parallel-computing/execute-simultaneously-on-multiple-data-sets.html

% Starting parallel pool (parpool) using the 'local' profile ...
% Connected to the parallel pool (number of workers: 4).

return;
% TASK C): COMPLETE CODE BELOW

%%%%%%%%% NOT WORKING (this is just a recipe for you to set things up)
p = gcp();

numcores = 10

geo = @(x) GeodesicAndCost(H,G,x,mesh_size2,F,Q,m);

% CHANGE RETURN TO BE THIS
%[GEO1,Total_cost,Count]=GeodesicAndCost(H,G,PEN,0.005,F,Q,m);

PENSET=PENset(PEN,mesh);

out = cell(1,numcores)

% to request multiple evaluations, use a loop
for idx = 1:numcores
  out{idx} = parfeval(p,@geo,3,PENSET(idx,:)); % Square size determined by idx
end

% collect the results as they become available.
results = cell(1,numcores);
for idx = 1:numcores
  % fetchNext blocks until next results are available.
  [completedIdx,value] = fetchNext(geo);
  magicResults{completedIdx,:} = value;
  fprintf('Got result with index: %d.\n', completedIdx);
end
