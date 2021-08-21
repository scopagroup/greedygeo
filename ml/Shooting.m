function [FGEO] = Shooting(H,G,F,m,Q,eps)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
ST=7;
g=size(H,2);
S=sum(G./F);
Z=G./(F*S);
%Y=[0.19 0.11 0.59 0.11];
Y(1:g-1)=round(Z(1:g-1),3);
Y(g)=1-sum(Y(1:g-1));
[f,df,BG] = objShooting( Y, H, G, F, m, Q, ST )
objfun=@(Y) objShooting(Y, H,G,F,m,Q,ST)

HH=H;

Mean=zeros(15,g);
Mean(1,:)=H;
for i=2:15
    [HH]= mean_trajectory(HH,F,m,Q);
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
HKcost=[hkcost];
%geo=[H;BG(end:-1:1,:)];
%geocost=TraCost(geo,F,m,Q);
GeoCost1=[f];
YY=[Y];
GRDN=[];
I=0;
distY=[];
flag=1;
while hkcost> eps && I<2000 && flag==1
    I=I+1
    [grd] = GRD( H, BG, F, m, Q);
    
    sdir = -grd;

    % do line search
    tc = doLineSearch( objfun, Y, sdir );
    if tc ~= 0.0
        NY(1:g-1) = Y(1:g-1) + tc*sdir;
        
    else, break;
    end
    
    if sum(NY(1:g-1))<0.995
    NY(g)=1-sum(NY(1:g-1));
    Y=NY;
    YY=[YY;Y];
    distY=[distY; norm(YY(end,:)-YY(end-1,:),2)];
    [fc, dfc,BG] = objfun( Y );
    if fc==0
         flag=0;
    else
         geo=[H;BG(end:-1:1,:)];
         K=OneStepGeo(BG(end,:),BG(end-1,:),m,Q,F);
         hkcost=norm(H-K,2)^2;
         GRDN=[GRDN norm(dfc)];
         HKcost=[HKcost;hkcost];
         GeoCost1=[GeoCost1; fc];
         i=i+1;
    end
    else
        break;
    end
end
subplot(2,2,1)
plot(HKcost)
title('||H-K||^2')
subplot(2,2,2)
plot(GRDN)
title('Norm of GRDFULL')
subplot(2,2,3)
plot(GeoCost1)
title('Cost of geodesic')
subplot(2,2,4)
plot(distY)
title('||Y_n-Y_{n-1}||')
FGEO=geo;
end

