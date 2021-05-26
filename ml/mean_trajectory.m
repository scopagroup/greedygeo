function [MT]= mean_trajectory(H,F,m,Q)
% this function computes the mean at step T+1 given H_T=H
g=length(H);
MT=zeros(1,g);
for j=1:g
    MT(j)=F(j)*H(j)/ (F*H');
    for k=1:g
        MT(j)=MT(j)-(1/(F*H')) * m*Q(j,k)*F(j)*H(j)+(1/(F*H'))*m*Q(k,j)*F(k)*H(k);
    end
end

end





