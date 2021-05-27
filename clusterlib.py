import os, warnings, time
from subprocess import call




##########################################################################
# create command
##########################################################################
def createCMD(ids,ide,length,opt):
    outDir = opt['output_directory'];

    cmd = 'matlab -nodesktop -nodisplay -nosplash';
    cmd = cmd + ' -r \"isetup; genTrajectoriesSubset(';
    cmd = cmd + str(ids) + ',' + str(ide) + ',' + str(length);
    cmd = cmd + ',\'' + outDir +'\'); quit;\"'
#    cmd = cmd + ' > ' + outDir + '/log.txt'
    return cmd;




##########################################################################
# set default parameters
##########################################################################
def setDefaultParameters(compute_sys):
    if compute_sys == 'opuntia':
        num_nodes = 1;
        mpi_pernode = 1;
    elif compute_sys == 'local':
        num_nodes = 1;
        mpi_pernode = 1;
    else:
        warnings.warn('system ' + compute_sys + ' not supported');
        quit(); # if file does not exist, go home


    parameters = {};
    # WARNING: label map transport currently works only on
    # one mpi task and one node
    parameters.setdefault('num_nodes', num_nodes);
    parameters.setdefault('num_mpitasks', num_nodes*mpi_pernode);
    parameters.setdefault('compute_sys', compute_sys);

    # set run time
    parameters.setdefault('wtime_h', '10');
    parameters.setdefault('wtime_m', '00');

    return parameters;




##########################################################################
# get the subdirectories within a global directory
##########################################################################
def getSubDir(global_dir):
    return [name for name in os.listdir(global_dir)
            if os.path.isdir(os.path.join(global_dir, name))]




##########################################################################
# get all file names in directory
##########################################################################
def getFileNames(data_dir):
    f = []
    for (dirpath, dirnames, filenames) in os.walk(data_dir):
        f.extend(filenames)
        break

    return f;




##########################################################################
# function to reset ann option in the dictionary
##########################################################################
def resetOption(opt, flag):
    if flag in opt:
        del opt[flag];




##########################################################################
# function to reset ann option in the dictionary
##########################################################################
def fileExists(filename):
    if not os.path.isfile(filename):
        warnings.warn('file ' + filename + ' does not exist');
        quit(); # if file does not exist, go home




##########################################################################
# function to create job submission file for rcdc resources
##########################################################################
def createJobSubFile(cmd, opt):
    # construct bash file name
    if 'output_prefix' in opt:
        bash_filename = opt['output_prefix'];
        bash_filename = bash_filename + opt['task'] + "-job-submission.sh";
    else:
        bash_filename = opt['task'] + "-job-submission.sh";

    bash_filename = opt['output_directory'] + "/" + bash_filename;

    # if output tab line exists, delete it
    if os.path.isfile(bash_filename):
        os.remove(bash_filename);

    # create bash file
    print("creating", bash_filename)
    bash_file = open(bash_filename,'w');

    # heading
    bash_file.write("#!/bin/bash\n\n");
    bash_file.write("#### sbatch parameters\n");

    # job name
    bash_file.write("#SBATCH -J " + opt['task'] + "\n");

    # total number of nodes
    bash_file.write("#SBATCH -N " + str(opt['num_nodes']) + "\n");

    # total number of tasks
    bash_file.write("#SBATCH -n " + str(opt['num_mpitasks']) + "\n");

    # max wall clock time
    bash_file.write("#SBATCH -t " + opt['wtime_h'] + ":" + opt['wtime_m'] + ":00\n");

    # mail settings
    #bash_file.write("#SBATCH --mail-user=amang@uh.edu\n");
    bash_file.write("#SBATCH --mail-user=ysu3@uh.edu\n");
    bash_file.write("#SBATCH --mail-type=begin\n");
    bash_file.write("#SBATCH --mail-type=end\n");
    bash_file.write("#SBATCH --mail-type=fail\n");

    bash_file.write("\n");
    bash_file.write("cd " + opt['code_directory'] + "\n");

    bash_file.write("\n");
    bash_file.write("module load matlab\n");
    bash_file.write("\n");
    bash_file.write("\n");
    bash_file.write("#### submitt job\n");
    bash_file.write(cmd);
    bash_file.write("\n");

    # write out done
    bash_file.close();

    return bash_filename;




##########################################################################
# submit the job
##########################################################################
def submitJob(cmd, opt):
    if opt['compute_sys'] == 'opuntia':
        bash_filename = createJobSubFile(cmd, opt);
        os.chdir(opt['output_directory']);
        call(["sbatch", bash_filename]);
        time.sleep(3);
    elif opt['compute_sys'] == 'local':
        os.chdir(opt['output_directory']);
        rc = call(cmd, shell=True);
        time.sleep(3);
    else:
        warnings.warn('system ' + opt['compute_sys'] + ' not supported');
        quit(); # if file does not exist, go home
