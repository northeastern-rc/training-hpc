#!/bin/bash
#SBATCH -J getMax 		##set job name 
#SBATCH --partition=debug	#set partition name to "debug" (very short runs)
#SBATCH --nodes=1		#set node number to 1
#SBATCH --ntasks=1		#set number of tasks (CPUs) to 1
#SBATCH --array=1-4%4 		#create 4 array jobs, run all 4 at a time.
#SBATCH --output=%A-%a.out	#set output filename with main job ID and task array ID
#SBATCH --error=%A-%a.err	#set error filename with main job ID and task array ID

#Clean env of other conda modules or installations:
## Deactivate your existing conda environment - uncomment the below line if you have a conda environemnt automatically loaded through your ~/.bashrc
#conda deactivate
module purge

# Load a python environment
module load discovery anaconda3/2021.05 
source activate 

# Run the python code on a particular list, output into a particular file:
python getMax.py list$SLURM_ARRAY_TASK_ID > output.list$SLURM_ARRAY_TASK_ID

#######################################################################################
## Alternatively, all file names to be processed could be read from a file (all-lists).
## Each job task array would process a different row:
## Uncomment the following to test:

# list_name=`sed "${SLURM_ARRAY_TASK_ID}q;d" all-lists`  ## get current row from file
# python getMax.py $list_name > output.$list_name        ## process current filename
