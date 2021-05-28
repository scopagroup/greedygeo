function [GEO,COST,GEO1,COST1,Total_cost,Count] = GeodesicAndCost1(H,G,PEN,F,Q,m)
%H is the starting histogram, G is the target histogram.

%PEN is a matrix storing the intervals of all possible penultimate point
%where PEN(i,1) < penultimate point (i)< PEN(i,2).

%mesh_size2 is the mesh on PEN.

%F is the growth vector, Q is the mutation matrix. m is the mutation rate.

%GEO stores all the reverse geodesics. GEO1 stores all the completed reverse geodesic.

%COST stores the one step cost of every step of every reverse geodesic

%COST1 stores the ons step cost of every truncated reverse geodesic and the
%cost of jump from H.

%Total_cost stores the rate function of the trajectories containing the jump and
%the truncated reverse geodesic
% Count is the total number of reverse geodesics
%mesh=mesh_size2;
M=m*Q;
g=size(H,2);
HH=H;
%PENSET=PENset(PEN,mesh);
Mean=zeros(15,g);
Mean(1,:)=H;
for i=2:15
    [HH]= mean_trajectory(HH,F,m,Q);
    Mean(i,:)=HH;
end
PENSET=PEN;
Leng=size(PENSET,1);
GEO=cell(1,Leng);
GEO1=cell(1,Leng);
COST=cell(1,Leng);
COST1=cell(1,Leng);
Total_cost=zeros(1,Leng);

Y=G;
Compare=100;
Count=1;
for i=i:Leng
    y=PENSET(i,:);%y is the penultimate point
    [Tra,cost_store]=ReverseGeo(Y,y,F,m,Q,Compare);

    if any(any(Tra))
        [Tra1,cost_store1,comp] = BrokenGeo(Tra,Mean,cost_store,F,m,Q,0.01);

        GEO{Count}=Tra;
        COST{Count}=cost_store;
        GEO1{Count}=Tra1;
        COST1{Count}=cost_store1;
        Total_cost(Count)=comp;
        Count=Count+1;
        if rem(Count,100)==0
            Compare=min(Total_cost(1:Count-1));
        end
    end
end

end
