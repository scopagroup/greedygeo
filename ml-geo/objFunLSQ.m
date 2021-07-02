function [f,df,d2f] = objFunLSQ( x, A, y, xref, L, alpha )
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
dr = A*x - y;
lx = L*(x-xref);
f  = 0.5*dr(:)'*dr(:) + 0.5*alpha*lx(:)'*lx(:);

% evaluate gradient of f(x); the gradient
% is given by A^T(Ax - y) + alpha L^T L (x-xref)
if nargout > 1
    M  = (L'*L);
    df = A'*dr + alpha*M*(x-xref);
end

% evaluate hessian matrix of f(x)
% given by A^T A + alpha*L^T L
if nargout > 2
    d2f = A'*A + alpha*M;
end

end % end function
