#!/bin/bash 

##### Use outside training ########
##SBATCH --partition=short
##### Use during training #########
#SBATCH --partition=reservation
#SBATCH --reservation=HPC-training
###################################

#SBATCH --job-name=exercise3_2
#SBATCH --ntasks=128
#SBATCH --time=04:00:00

######## Weak Scaling - define initial data size: #########
initDataSize=100

######## change number of MPI tasks here: #################
mpiNtasks=128
##########################

#Load the python environment to run MPI with python:
module load anaconda3/2019.10-HPCtraining

#Test number of MPI tasks between 1 and 128 (mult by 2):
for (( nTasks=1; nTasks<=$mpiNtasks; nTasks=$nTasks*2 ))
do

	##set input data size:
	inputDataSize=$((initDataSize*2))	

	# check what time it is before the job starts
	STARTT=`date +%s%N | cut -b1-13`
	# run the parallel code "calcMatrix.py" using the openmpi libraries: 
	mpirun -n $nTasks python calcMatrix.py $inputDataSize

	# check what time it is when the command finishes
	ENDT=`date +%s%N | cut -b1-13`
	ELAPSED=`echo 0 | awk -v e=$ENDT -v s=$STARTT '{print e-s}'`

	echo "MPI-tasks: $nTasks , run-time: $ELAPSED ms" > performance.$nTasks.log

	initDataSize=$inputDataSize
done

cat performance.* | awk '{print $2,$5}' | sort -nk1 > performance.all
