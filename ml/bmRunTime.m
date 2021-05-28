clear
format long;

F=[200,200^1.08,200^1.1,200^1.11,200^1.12]; 
Q=[0 0.25 0.25 0.25 0.25
   0.25 0 0.25 0.25 0.25
   0.25 0.25 0 0.25 0.25
   0.25 0.25 0.25 0 0.25
   0.25 0.25 0.25 0.25 0];
    
m=1/10^6;
M=m*Q;
mesh=0.005;
PEN=[0.1 0.2;0.1 0.12;0.15 0.25;0.42 0.46];


% computing time for OneStepCost function
H=[0.8 0.05 0.05 0.05 0.05];
G=[0.1 0.1 0.2 0.5 0.1];
tic
for i=1:1000
    OneStepCost(H,G,F,m,Q);
end
fprintf('Execution time in seconds for OneStepCost function 1000 times: %s\n', toc )

% computing time for OneStepGeo function
H=[0.8,0.05,0.05,0.05,0.05];
G=[0.6,0.1,0.1,0.1,0.1];
tic
for i=1:1000
    OneStepGeo(H,G,m,Q,F);
end
fprintf('Execution time in seconds for OneStepGeo function 1000 times: %s\n', toc )


% computing time for ReverseGeo function
G=[0.1,0.1,0.2,0.5,0.1];
pen=[0.15,0.15,0.15,0.4,0.15];
tic
for i=1:1000
    ReverseGeo(G,pen,F,m,Q,1);
end
fprintf('Execution time in seconds for ReverseGeo function 1000 times: %s\n', toc )

% computing time for mean_trajectory function
H=[0.8,0.05,0.05,0.05,0.05];
tic
for i=1:1000
    mean_trajectory(H,F,m,Q);
end
fprintf('Execution time in seconds for mean_trajectory function 1000 times: %s\n', toc )

% computing time for condition function
H=[0.8,0.05,0.05,0.05,0.05];
HH=H;
g=size(H,2);
Mean=zeros(15,g);
Mean(1,:)=H;
for i=2:15
    [HH]= mean_trajectory(HH,F,m,Q);
    Mean(i,:)=HH;
end
G=[0.1,0.1,0.2,0.5,0.1];
pen=[0.15,0.15,0.15,0.4,0.15];
Tra = ReverseGeo(G,pen,F,m,Q,1);
tic
for i=1:1000
    condition(Mean, Tra,F,Q,m,0.01);
end
fprintf('Execution time in seconds for condition function 1000 times: %s\n', toc )

% computing time for PENset function
tic
for i=1:10
    PENset(PEN,mesh);
end
fprintf('Execution time in seconds for PENset function 10 times: %s\n', toc)

% computing time for BrokenGeo funciton
G=[0.1,0.1,0.2,0.5,0.1];
pen=[0.15,0.15,0.15,0.4,0.15];
H=[0.8,0.05,0.05,0.05,0.05];
HH=H;
Mean=zeros(15,g);
Mean(1,:)=H;
for i=2:15
    [HH]= mean_trajectory(HH,F,m,Q);
    Mean(i,:)=HH;
end
[Tra,cost_store] = ReverseGeo(G,pen,F,m,Q,1);
tic
for i=1:1000
    BrokenGeo(Tra,Mean,cost_store,F,m,Q,eps);
end
fprintf('Execution time in seconds for BrokenGeo function 1000 times: %s\n', toc)

% computing time for GeodesicAndCost function    
H=[0.8 0.05 0.05 0.05 0.05];
G=[0.1 0.1 0.2 0.5 0.1];
tic
 [GEO,COST,GEO1,COST1,Total_cost,Count]=GeodesicAndCost(H,G,PEN,0.005,F,Q,m);
fprintf('Execution time in seconds for GeodesicAndCost function: %s\n', toc)



