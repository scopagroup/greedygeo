function [pen] = GeneratePEN1(PEN, G, F,m,Q, quan)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
pen=[];
for i=1:size(PEN,1)
    if OneStepCost(PEN(i,:),G,F,m,Q)< quan
        pen=[pen;PEN(i,:)];
    end
end
end

