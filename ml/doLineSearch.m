function [t] = doLineSearch( objfun, xc, sdir )
%DOLINESEARCH perform backtracking linesearch
%
% input:
%   objfun   function handle for objective function
%   xc       current iterate
%   sdir     search direction
%
% output:
%   t        lin search parameter

%if nargin < 4, lstype = 'armijo'; end
%if strcmp( lstype, 'none' ), t = 1; return; end

% evaluate objective function
g=size(xc,2);
[fc, dfc] = objfun( xc );

% initialize flag
success = false;

% set max number of linesearch iterations
maxit = 10;

% set initial step size
t = 0.001;
c = 1e-4;
descent = dfc(:)'*sdir(:);

% do linesearch
for i = 1 : maxit
    % evaluate objective function
    xcc(1:g-1)=xc(1:g-1)+t*sdir;
    xcc(g)=1-sum(xcc(1:g-1));
    ftrial = objfun( xcc );

    % make sure that we have a descent direction
    if ( ftrial < fc + c*t*descent )
        success = true;
        break;
    end

    % divide step size by 2
    t = t / 2;
end

% display message to user
if ~success, disp('line search failed'); gamma = 0.0; end

end % end of function




%######################################################
% This code is part of the Matlab-based toolbox
% OPTIK --- Optimization Toolkit
% For details see https://github.com/andreasmang/optik
%######################################################
