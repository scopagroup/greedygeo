clear all
numnodes=10;
tic
for i=1:numnodes
    %exec( i, numnodes );
    ExecTar( i, numnodes );
end
toc