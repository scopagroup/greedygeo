function [f,df,BG] = objShooting( Y, H, G, F, m, Q, ST )
%OBJFUNRLSQ implementation of objective function for
%regularized least squares problem
%
% inputs:
%   A          n x m matrix
%   b          right hand side (vector)
%   x          current iterate
%   L          regularization operator
%   alpha      regularization parameter
%
% outputs:
%    f         objective value
%    df        gradient
%    d2f       hessian

% evaluate objective functional
% f(x) = 0.5*||Ax-y||^2_2 + ||L*(x-xref)||^2_2
[Tra,cost_store] = ReverseGeo1(G,Y,F,m,Q,100);
if size(Tra,1)>ST || size(Tra,1)==ST
    BG=Tra(1:ST,:);
    K=OneStepGeo(BG(end,:),BG(end-1,:),m,Q,F);
    hkcost=norm(H-K,2);
    HKcost=[hkcost];
    geo=[H;BG(end:-1:1,:)];
    geocost=TraCost(geo,F,m,Q);
    f=sum(geocost);
    [df] = GRD( H, BG, F, m, Q);
else
    f=0;
    df=0;
    BG=0;
end
    

end % end function
