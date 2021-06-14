function [PENset] = GeneratePen(I, G, F, m, Q, Whole, c)

if I==2
   PENset=[]; 
for i=1:size(Whole,1)
    if OneStepCost(Whole(i,:),G,F,m,Q)<=1.1*c && OneStepCost(Whole(i,:),G,F,m,Q)>0
        PENset=[PENset; Whole(i,:)];
    end
end
else
    PENset=Whole(vecnorm(Whole-G, Inf, 2)<=1.1*c,:);
end
    


end

