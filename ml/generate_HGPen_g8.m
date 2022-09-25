% g = 8 
% first pair
clear all
H=[0.5 0.1 0.1 0.1 0.05 0.05 0.05 0.05];
g = size(H,2);
G=[0.05 0.05 0.1 0.05 0.05 0.1 0.5 0.1];
Y=[0.085, 0.065, 0.105, 0.0688, 0.0525, 0.1, 0.42, 0.1038];
YY = Y;
HG8PenSet = cell(6,3);
k = 1;
for ind = 2:7
    
    GG = G;
    YY = Y;
    tem1 = GG(ind);
    GG(ind) = 0.5;
    GG(7) = tem1;
    tem2 = YY(ind);
    YY(ind) = 0.42;
    YY(7) = tem2;
    PenSet = [YY];
    for eps = 0.001: 0.002:0.004
        for i = 1 :3: g
            for j = i+1:3:g
                YY = Y;
                YY(i) = YY(i) - eps;
                YY(j) = YY(j) + eps;
                PenSet = [PenSet; YY];
                
         end
        end
    end
 HG8PenSet{k,1} = H;
 HG8PenSet{k,2} = GG;
 HG8PenSet{k,3} = PenSet;
 k = k + 1;        
end
save HG8PenSet.mat HG8PenSet 

 