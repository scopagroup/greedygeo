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


%  Check the result for OneStepCost function
H=[0.8 0.05 0.05 0.05 0.05];
G=[0.1 0.1 0.2 0.5 0.1];
OneStepCost(H,G,F,m,Q);
fprintf('the result for OneStepCost(H,G) is: %s\n', OneStepCost(H,G,F,m,Q) )

% check the result for OneStepGeo function
H=[0.8,0.05,0.05,0.05,0.05];
G=[0.6,0.1,0.1,0.1,0.1];
fprintf('the result for OneStepGeo is: \n')
OneStepGeo(H,G,m,Q,F)

% check the result for ReverseGeo function
G=[0.1,0.1,0.2,0.5,0.1];
pen=[0.15,0.15,0.15,0.4,0.15];
fprintf('the result for ReverseGeo is: \n'  )
ReverseGeo(G,pen,F,m,Q,1)

% check the result for mean_trajectory function
H=[0.8,0.05,0.05,0.05,0.05];
fprintf('the result for mean_trajectory is: \n' )
mean_trajectory(H,F,m,Q)

% check the result for condition function
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
condition(Mean, Tra,F,Q,m,0.01);
fprintf('the result for condition is: \n')
 condition(Mean, Tra,F,Q,m,0.01)
 
 
% check the result for PENset function
PENSET=PENset(PEN,mesh);
fprintf('the size of the PENSET is: \n' )
size(PENSET,1)
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
fprintf('the result for BrokenGeo is:\n' )
BrokenGeo(Tra,Mean,cost_store,F,m,Q,eps)

% check the result for GeodesicAndCost function    
H=[0.8 0.05 0.05 0.05 0.05];
G=[0.1 0.1 0.2 0.5 0.1];
[GEO,COST,GEO1,COST1,Total_cost,Count]=GeodesicAndCost(H,G,PEN,0.005,F,Q,m);
[a b]=min(Total_cost(1:Count-1));
fprintf('the best path from H to G is: \n' )
GEO1{b}



