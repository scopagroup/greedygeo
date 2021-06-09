function [sepPEN] = SepTAR(PEN, num)
% separate TAR to n=num sets
l= size(PEN,1);

s= floor(l/num);
sepPEN=cell(1,num);
for i=1:num-1
    sepPEN{i} = PEN(1+(i-1)*s:i*s,:);
    
end
sepPEN{num}=PEN(s*(num-1)+1:end,:);

end
