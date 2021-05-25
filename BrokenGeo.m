function [Tra1,cost_store1,comp] = BrokenGeo(Tra,Mean,cost_store,F,m,Q,eps)
% Given a reverse geodesic Tra, mean trajectory Mean, and the one step cost cost_store for every step in Tra
% BrokenGeo returns a complete path from H to G by truncating Tra and connecting it to Mean.

G=Tra;
C=cost_store;
comp=100;
[flag] = condition(Mean,G,F,Q,m, eps);
if flag(1)==1 || flag(2)==1
    J=flag(2);
    for j=min(flag(3)+1,size(G,1)):-1:max(1,flag(3)-1)
        
        C1=sum(C(1:j))+OneStepCost(Mean(J,:),G(j,:),F,m,Q);
        if C1<comp && C1>0
            comp=C1;
            Tra1=[G(1:j,:);Mean(J,:)];
            cost_store1=[C(1:j);C1];
        end
    end
else
    J=flag(2);
    I=flag(3);
    cc=OneStepCost(Mean(J,:),G(I,:),F,m,Q);
    C1=sum(C(1:I))+cc;
    if cc>0
        comp=C1;
        Tra1=[G(1:I,:);Mean(J,:)];
        cost_store1=[C(1:I);comp];
    else
        Tra1=[];
        cost_store1=[];
    end
end
end

