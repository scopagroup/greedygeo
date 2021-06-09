function [PENset] = GeneratePen(G, F, m, Q, Whole, c)
PENset=[];
for i=1:size(Whole,1)
    if OneStepCost(Whole(i,:),G,F,m,Q)<c
        PENset=[PENset; Whole(i,:)];
    end
end


end

