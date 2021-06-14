function [GEOSET,RevGEO, COSTSET, HG, DistAndCost] = GeoAndCost( HGpair, F, m, Q, mesh, Compare)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

n=size(HGpair,1);
g=size(HGpair,2)/2;
GEOSET=cell(1,n);
RevGEO=cell(1,n);
COSTSET=cell(1,n);
HG=[];
DistAndCost=[];
I=2;
for i=1:size(HGpair,1)
    H=HGpair(i,1:g);
    G=HGpair(i,g+1:2*g);
    CCC=Compare(i,I);
    [Tra1, cost_store1, comp] = PreTest(H,G,F,m,Q);
    Whole=WholeSpace(G,mesh);
    [PENset] = GeneratePen(I, G, F, m, Q, Whole, CCC);
    [GEO,COST,GEO1,COST1,Total_cost,Count] = GeodesicAndCost2(H,G,PENset,F,Q,m,comp);
    [a b]=min(Total_cost(1:Count-1));
    RevGEO{i}=GEO{b};
    GEOSET{i}= GEO1{b};
    COSTSET{i}= COST1{b};
    HG=[HG;H G];
    DistAndCost=[DistAndCost; norm(GEO1{b}(1,:)-GEO1{b}(2,:),Inf) COST1{b}(2)];
end
    
end

