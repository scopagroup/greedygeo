function [opt] = setup(g)

if g==3
    %F1
    %opt.F=[200,200^1.08,200^1.12];
    %F2
    %opt.F=[200,200^1.07,200^1.12];
    %F3
    %opt.F=[200,200^1.08,200^1.11];
    %F4
    %opt.F=[200,200^1.09,200^1.12];
    %F5
    %opt.F=[200,200^1.08,200^1.10];
    %F6
    opt.F=[200,200^1.1,200^1.12];
    
    opt.Q=[0 0.5 0.5
       0.5 0 0.5
       0.5 0.5 0];
    
    opt.m=1/10^8;
    
elseif g==4
    opt.F=[200,200^1.08,200^1.1,200^1.12]; 
    opt.Q=[0 1/3 1/3 1/3
       1/3 0 1/3 1/3
       1/3 1/3 0 1/3
       1/3 1/3 1/3 0];
    
    opt.m=1/10^8;
    
elseif g==5
    opt.F=[200,200^1.08,200^1.1,200^1.11,200^1.12];
    opt.Q=[0 0.25 0.25 0.25 0.25
           0.25 0 0.25 0.25 0.25
           0.25 0.25 0 0.25 0.25
           0.25 0.25 0.25 0 0.25
           0.25 0.25 0.25 0.25 0];

    opt.m=1/10^8;
end

end
