function [PENSET] = PENset(PEN,mesh)
% this function returns all the penultimate histograms by using mesh to
% discretize PEN.
sets=cell(1,size(PEN,1));
Leng=1;

for i=1:size(PEN,1)
    sets{i}=PEN(i,2):-mesh:PEN(i,1);
    Leng=Leng* size(sets{i},2);
    
end
PENSET=zeros(Leng,size(PEN,1)+1);
c = cell(1, numel(sets));
[c{:}] = ndgrid( sets{:} );
result = cell2mat( cellfun(@(v)v(:), c, 'UniformOutput',false) );
Count=0;
for i=1:Leng
    if sum(result(i,:))<0.999
        Count=Count+1;
        PENSET(Count,:)=[result(i,:) 1-sum(result(i,:))];
        
    end
end
PENSET=PENSET(1:Count,:);

end

