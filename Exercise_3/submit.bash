#!/bin/bash
#SBATCH -J getMax  
#SBATCH --partition=debug
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --array=1-4%4 #create 4 array jobs, run all 4 at a time.
#SBATCH --output=%A-%a.out
#SBATCH --error=%A-%a.err

#Clean env of other conda modules or installations:
conda deactivate
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
