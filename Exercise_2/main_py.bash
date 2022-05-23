#!/bin/bash 
#SBATCH --job-name=exercise2	## set job name
##SBATCH --nodes=1		## uncomment this line - does performance improve?
#SBATCH --ntasks=128		#request 128 tasks that will allocate 1 cpu per task 
#SBATCH --time=00:20:00		#request 20 minutes job time limit
#SBATCH --partition=express	#run on partition "express"

######## change number of MPI tasks here: #################
mpiNtasks=128
##########################

#Clean env of other conda modules or installations:
conda deactivate
module purge

#Load the python environment to run MPI with python:
module load discovery anaconda3/2019.10-HPCtraining

#Test number of MPI tasks between 1 and 128 (mult by 2):
for (( nTasks=1; nTasks<=$mpiNtasks; nTasks=$nTasks*2 ))
do
#####!!!!!! NOTE MODIFIED TO SECONDS from MS
	# check what time it is before the job starts (in seconds):
	STARTT=`date +%s`
	# run the parallel code "calcMatrix.py" using the openmpi libraries: 
	mpirun -n $nTasks python calcMatrix.py

	# check what time it is when the command finishes (in seconds):
	ENDT=`date +%s`
	ELAPSED=`echo 0 | awk -v e=$ENDT -v s=$STARTT '{print e-s}'`

	echo "MPI-tasks: $nTasks , run-time: $ELAPSED ms" > performance.$nTasks.log
done

cat performance.* | awk '{print $2,$5}' | sort -nk1 > performance.all
