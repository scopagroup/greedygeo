function [GEOSET,RevGEO, COSTSET] = GeoAndCost(H, TAR, F, m, Q, mesh)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
n=size(TAR,1);
GEOSET=cell(1,n);
RevGEO=cell(1,n);
COSTSET=cell(1,n);
for i=1:size(TAR,1)
    G=TAR(i,:);
    [Tra1, cost_store1, comp] = PreTest(H,G,F,m,Q);
    Whole=WholeSpace(H,mesh);
    [PENset] = GeneratePen(G, F, m, Q, Whole, comp);
    [GEO,COST,GEO1,COST1,Total_cost,Count] = GeodesicAndCost2(H,G,PENset,F,Q,m,comp);
    [a b]=min(Total_cost(1:Count-1));
    RevGEO{i}=GEO{b};
    GEOSET{i}= GEO1{b};
    COSTSET{i}= COST1{b};
end
    
end

