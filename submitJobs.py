from clusterlib import *
import os
import sys

bdir = os.environ['WORK'] + "/code/greedygeo"
# wdir = os.environ['SCRATCH']
wdir = os.environ['WORK'] + "/code/greedygeo"

#opt = setDefaultParameters('local');
opt = setDefaultParameters('local');

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

numnodes = 2;

for nodeID in range( 1, numnodes):

    cmd = createCMD( nodeID, numnodes, opt );


    resetOption(opt, 'task');
    opt.setdefault('task', 'geo-node-' + str(nodeID) );

#    print(cmd);
    submitJob( cmd, opt );
