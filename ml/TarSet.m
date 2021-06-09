function [TARSET] = TarSet(TAR,mesh)
% this function returns all the penultimate histograms by using mesh to
% discretize PEN.
sets=cell(1,size(TAR,1));
Leng=1;

for i=1:size(TAR,1)
    sets{i}=TAR(i,2):-mesh:TAR(i,1);
    Leng=Leng* size(sets{i},2);
    
end
c = cell(1, numel(sets));
[c{:}] = ndgrid( sets{:} );
result = cell2mat( cellfun(@(v)v(:), c, 'UniformOutput',false) );
rrr=result(find(sum(result,2)<0.95),:);
y=1-sum(rrr,2);
TARSET= [rrr y];
end

