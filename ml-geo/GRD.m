function [grd] = GRD( H, BG, F, m, Q)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
G=BG(1,:);
g=size(G,2);

Y=BG(2,:);
K=OneStepGeo(BG(end,:),BG(end-1,:),m,Q,F);
n=size(BG,1);
DGY=zeros( g-1,g-1,n );
DGY(:,:,2)= eye(g-1);
DGY(:,:,3)=D1Geo(Y,G,F,m,Q);
for k=4:n
    DGY(:,:,k)=D1Geo(BG(k-1,:),BG(k-2,:),F,m,Q)*DGY(:,:,k-1)+D2Geo(BG(k-1,:),BG(k-2,:),F,m,Q)*DGY(:,:,k-2);
end
DC=zeros(n+1,g-1);

for k=2:n
    DC(k,:)=D1COST(BG(k,:),BG(k-1,:),F,m,Q)*DGY(:,:,k)+D2COST(BG(k,:),BG(k-1,:),F,m,Q)*DGY(:,:,k-1);
end
DC(n+1,:)=D2COST(H,BG(n,:),F,m,Q)*DGY(:,:,n);

%DKY= D1Geo(BG(n,:),BG(n-1,:),F,m,Q)*DGY(:,:,n)+D2Geo(BG(n,:),BG(n-1,:),F,m,Q)*DGY(:,:,n-1);
%grd=D2COST(H,K,F,m,Q)*DKY;
grd=sum(DC,1);

end

