function [PENset] = GeneratePen(I, G, F, m, Q, Whole, c)

if I==2
   PENset=[]; 
for i=1:size(Whole,1)
    if OneStepCost(Whole(i,:),G,F,m,Q)<=1.5*c && OneStepCost(Whole(i,:),G,F,m,Q)>0
        PENset=[PENset; Whole(i,:)];
    end
end
elseif I==1
    PENset=Whole(vecnorm(Whole-G, Inf, 2)<=1.5*c,:);

else
    l=size(Whole,1);
    LG=zeros(1,l);
    for i=1:l
        LG(i)=OneStepCost(Whole(i,:),G,F,m,Q);
    end
    Quan=quantile(LG,c);
    LL=find(LG<Quan & LG>0);
    PENset=Whole(LL,:);
        
end


end

