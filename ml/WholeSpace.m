function [Whole] = WholeSpace(G,mesh)
% this function returns all the penultimate histograms by using mesh to
% discretize PEN.
g=size(G,2);
sets=cell(1,g-1);
Leng=1;

for i=1:g-1
    sets{i}=min(G(i)+0.5,0.99):-mesh:max(G(i)-0.5,0.01);
    Leng=Leng* size(sets{i},2);
    
end

c = cell(1, numel(sets));
[c{:}] = ndgrid( sets{:} );
result = cell2mat( cellfun(@(v)v(:), c, 'UniformOutput',false) );
rrr=result(sum(result,2)<0.95,:);
y=1-sum(rrr,2);
Whole= [rrr y];


end