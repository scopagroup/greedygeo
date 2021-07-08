function [sepPEN] = SepPEN(PEN, num)
% separate PEN to n=num sets

if size(PEN,1) < 4
s= (PEN(1,2)-PEN(1,1))/num;
sepPEN=cell(1,num);
for i=1:num
    sepPEN{i} = PEN;
    sepPEN{i}(1,:)=[PEN(1,1)+(i-1)*s PEN(1,1)+i*s];
end
else

n=log(num)/log(2);
SET=cell(n,2);
sets=cell(1,n);
for i=1:n
    l=(PEN(i,2)-PEN(i,1))/2;
    SET{i,1}=[PEN(i,1) PEN(i,1)+l];
    SET{i,2}=[PEN(i,1)+l PEN(i,2)];
    sets{i}=[1,2];
end
c = cell(1, numel(sets));
[c{:}] = ndgrid( sets{:} );
result = cell2mat( cellfun(@(v)v(:), c, 'UniformOutput',false) );
sepPEN=cell(1,num);
for i=1:num
    pen=PEN;
    for j=1:n
        pen(j,:)=SET{j,result(i,j)};
    end
    sepPEN{i}=pen;
end
end
end

