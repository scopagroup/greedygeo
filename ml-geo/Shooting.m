function [YY,GeoCost1] = Shooting(H,G,ST,Y,F,m,Q,eps)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
%ST=6;
g=size(H,2);
%S=sum(G./F);
%Z=G./(F*S);
%Y=[0.19 0.11 0.59 0.11];
%Y(1:g-1)=round(Z(1:g-1),3);
%Y(g)=1-sum(Y(1:g-1));
[f,df,BG] = objShooting( Y, H, G, F, m, Q, ST );
if size(BG,1) > 1
objfun = @(Y) objShooting(Y, H,G,F,m,Q,ST);

HH = H;

Mean = zeros(15,g);
Mean(1,:) = H;
for i=2:15
    [HH] = mean_trajectory(HH,F,m,Q);
    if min(HH)>0.005
       Mean(i,:)=HH;
    else
        Mean=Mean(1:i-1,:);
        break;
    end
end

%[Tra1,cost_store1,comp] = BrokenGeoShooting(Tra,Mean,cost_store,F,m,Q);
%BG=Tra(1:ST,:);
K=OneStepGeo(BG(end,:),BG(end-1,:),m,Q,F);
i=1;
hkcost=norm(H-K,2);
HKcost = [hkcost];
%geo=[H;BG(end:-1:1,:)];
%geocost=TraCost(geo,F,m,Q);
GeoCost1=[f];
YY=[Y];
GRDN=[];
I = 0;
distY = [];
flag = 1;

stop = false;

fprintf('--------------------------------------------------------------------------\n')
fprintf('%-5s %-13s %-13s %-13s %-13s %-13s\n', 'iter', 'obj', '||g||', '||g||_rel', 'hkcost', 'step');
fprintf('--------------------------------------------------------------------------\n')
while ~stop
    I = I+1;

    % compute gradient
    [grd] = GRD( H, BG, F, m, Q);

    if I == 1
        ng0 = norm( grd(:) );
    end


    sdir = -grd;

    if sdir(:)'*grd(:) > 0
        %fprintf('search direction is not a descent direction');
        return;
    end

    % do line search
    tc = doLineSearch( objfun, Y, sdir );

    if tc == 0.0
        %warning('line search failed');
        return;
    end

    % update
    NY(1:g-1) = Y(1:g-1) + tc*sdir;

    if sum(NY(1:g-1))<0.995
        NY(g)=1-sum(NY(1:g-1));
        Y=NY;
        YY=[YY;Y];
        distY=[distY; norm(YY(end,:)-YY(end-1,:),2)];
        [fc, dfc,BG] = objfun( Y );
        if fc == 0
            fprintf('fc = 0.0\n');
            flag = 0;
        else
             geo = [H;BG(end:-1:1,:)];
             K = OneStepGeo(BG(end,:),BG(end-1,:),m,Q,F);
             hkcost = OneStepCost(H,K,F,m,Q);
             GRDN = [GRDN norm(dfc)];
             HKcost = [HKcost;hkcost];
             GeoCost1 = [GeoCost1; fc];
             i = i+1;
        end
    else
        %fprintf('sum NY > 0.955: %e\n', sum(NY(1:g-1)) );
        break;
    end

    %fprintf('%-4d  %-12e  %-12e  %-12e  %-12e  %-12e\n', I, fc, norm( grd(:) ), norm( grd(:) ) / ng0, hkcost, tc);

    stop = checkStopCond( hkcost, eps, I, flag );

end

subplot(2,2,1)
plot(HKcost)
title('C(H,K_t)')
xlabel('iteraions t')
ylabel('C(H,K_t)')
subplot(2,2,2)
plot(GRDN)
title('Norm of GRD_t')
xlabel('iteraions t')
ylabel('Norm of GRD_t')
subplot(2,2,3)
plot(GeoCost1)
title('Rate function of FP_t')
xlabel('iteraions t')
ylabel('Rate function of FP_t')
subplot(2,2,4)
plot(distY)
title('||Y_t-Y_{t-1}||')
xlabel('iteraions t')
ylabel('||Y_t-Y_{t-1}||')
%FGEO=geo;
else
    YY = 0;
    GeoCost1 = 10000;
end
end



function stop = checkStopCond(hkcost, eps, I, flag)

stop = false;
% stopping conditions
STOP(1) = hkcost < eps;
STOP(2) = flag == 0;       % bound
STOP(3) = I > 500;

% check for convergence / divergence
if any(STOP), stop = true; end


if stop
    fprintf('--------------------------------------------------------------------------\n')
    fprintf('stopping conditions\n');
    fprintf('--------------------------------------------------------------------------\n')
    fprintf('%d : %-8s = %14.8e <= %14.8e = %-7s\n',STOP(1), 'hkost ',  hkcost, eps, 'tol');
    fprintf('%d : %-8s = %14d == %14d = %-7s\n',STOP(2), 'flag ',  flag, 0, 'flag');
    fprintf('%d : %-8s = %-13d  >= %-13d  = %-7s\n',STOP(3), 'iter  ', I, 2000, 'maxiter');
    fprintf('--------------------------------------------------------------------------\n')
end

end