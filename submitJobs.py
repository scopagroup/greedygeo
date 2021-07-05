from clusterlib import *
import os
import sys

# folder where the code is to be found
bdir = os.environ['WORK'] + "/code/greedygeo"

# folder where the computed results are to be stored
#wdir = os.environ['SCRATCH'] + "/amang/results/greedytra"
wdir = os.environ['SCRATCH'] + "/results/greedytra"


#opt = setDefaultParameters('local');
opt = setDefaultParameters('opuntia');

resetOption(opt,'output_directory');
opt.setdefault('output_directory', wdir);

resetOption(opt,'code_directory');
opt.setdefault('code_directory', bdir);


# make output directory
#if not os.path.exists(wdir):
#    os.makedirs(wdir);
#else:
#    print("results already computed: ", wdir)
#    quit(); # if already computed, go home

numnodes = 20;

for nodeID in range(1, numnodes+1):

    # construct command
    cmd = createCMD( nodeID, numnodes, opt );
    # uncomment line below to see command that is going to be submitted
    print(cmd);

    # construct task name for job scheduler
    resetOption(opt, 'task');
    opt.setdefault('task', 'geo-node-' + str(nodeID) );

    # submit job to cluster
    submitJob( cmd, opt );
