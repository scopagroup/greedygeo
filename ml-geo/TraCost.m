function [cost] = TraCost(tra, F,m,Q)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
n=size(tra, 1);
cost=zeros(n,1);
for i=2:n
    cost(i)=OneStepCost(tra(i-1,:),tra(i,:),F, m,Q);
end
    
end

