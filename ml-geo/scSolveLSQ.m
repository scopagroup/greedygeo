
% contruct random PD 10 x 10 matrix
n = 10;
A = rand([n,n]);
A = A'*A + 1e-3*eye(n);
eigval = eig(A);

% generate data
xtrue = rand([n,1]);
y = A*xtrue;

% setup regularization model
L = eye(n);
alpha = 0.1;
xref = xtrue; % put true solution into kernel of regularization operator

% define objective functional
fun = @(x)  objFunLSQ( x, A, y, xref, L, alpha );

% initial guess
x0 = zeros(size(xtrue));


% setup optimization problem

% fminunc has two solvers:
% - quasi-newton (default)
% - trust-region

% we select the algorithm, set up output (for iterations) and 
% let the solver know that the gradient is provided
% the tolerances are way too small; this is rather to show
% what we can do for a simple problem with exact gradient information

%options = optimoptions('fminunc','Algorithm','trust-region','SpecifyObjectiveGradient',true);
opt = optimoptions('fminunc',...
                    'Algorithm','quasi-newton',...      % select algorithm
                    'Display','iter', ...               % show iterations (for monitoring progress)
                    'SpecifyObjectiveGradient',true,... % specify gradient of objective function
                    'StepTolerance', 1e-16, ...         % tolerance for step size
                    'OptimalityTolerance', 1e-12);      % define optimization tolerance

% show options to user (this allows us to also see what other options
% are available)
disp(opt)

% solve optimization problem
[xsol,fval] = fminunc(fun,x0,opt);

fprintf('relative error: %e\n', norm(xsol - xtrue) / norm(xtrue));