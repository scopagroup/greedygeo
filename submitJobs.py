from clusterlib import *
import os
import sys

bdir = os.environ['WORK'] + "/code"
wdir = os.environ['SCRATCH'] + "/trajres"

#opt = setDefaultParameters('local');
opt = setDefaultParameters('opuntia');

resetOption(opt,'output_directory');
opt.setdefault('output_directory', wdir);

resetOption(opt,'code_directory');
opt.setdefault('code_directory', bdir);


# make output directory
if not os.path.exists(wdir):
    os.makedirs(wdir);
else:
    print("results already computed: ", wdir)
#    quit(); # if already computed, go home


Num     = 50000000; # total number of trajectories
NumPerC = 1000000;  # number of trajectories per compute node
length  = 10;

for i in range( 1, Num, NumPerC):

    ids = i;
    ide = i+NumPerC - 1;

    cmd = createCMD( ids, ide, length, opt );


    resetOption(opt, 'task');
    opt.setdefault('task', 'trj' + str(ids) + '-' + str(ide) );

#    print(cmd);
    submitJob( cmd, opt );
