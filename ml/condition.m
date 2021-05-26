function [flag] = condition(Mean,geo,F,Q,m, eps)
% Given the mean trajectory Mean and a reverse geodesic geo,  this function
% returns [a b c]. 
% a=1 if geo enters a small zone of any histograms in Mean, otherwise a=0
% if a=1, norm(Mean_b,geo_c) is the samllest value
% if a=0, C(Mean_b,geo_c) is the smallest value
K=size(geo,1);
dist=zeros(15,K);
%CC=zeros(15,K);
M=m*Q;
for i=1:15
    for j=1:K
        dist(i,j)=norm(Mean(i,:)-geo(j,:));
        %CC(i,j)=cost_function(Mean(i,:),geo(j,:),F,M);
    end
end
[a b]=min(dist);
[c d]=min(a);


if c<eps
    flag=[1 b(d) d];
else
    CC=zeros(15,K);
    for i=1:15
        for j=1:K
            CC(i,j)=OneStepCost(Mean(i,:),geo(j,:),F,m,Q);
        end
    end
            
    [a1 b1]=min(CC);
    [c1 d1]=min(a1);
    flag=[0 b1(d1) d1];
end
    
end

