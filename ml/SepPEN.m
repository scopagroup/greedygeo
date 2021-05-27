function [sepPEN] = SepPEN(PEN, num)
% separate PEN to n=num sets

s= (PEN(1,2)-PEN(1,1))/num;
sepPEN=cell(1,num);
for i=1:num
    sepPEN{i} = PEN;
    sepPEN{i}(1,:)=[PEN(1,1)+(i-1)*s PEN(1,1)+i*s];
end


end

