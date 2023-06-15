#!/bin/bash 
#SBATCH --partition=express
#SBATCH --job-name=MPIScaling
##SBATCH --nodes=1		#uncomment and check performance
#SBATCH --ntasks=128		#request 128 tasks that will allocate 1 cpu per task 
#SBATCH --time=00:30:00
#SBATCH --constraint=ib         # Run only on nodes that support IB network

######## change number of MPI tasks here: #################
mpiNtasks=128
##########################

#Clean env of other conda modules or installations:
## Deactivate your existing conda environment - uncomment the below line if you have a conda environemnt automatically loaded through your ~/.bashrc
#conda deactivate
module purge

#Load the InfiniBand-supported MPI-library and the python environment to run MPI with python:
module load discovery gcc/7.3.0 mpich/3.3.2-skylake-gcc7.3
module load anaconda3/2019.10-HPCtraining
source activate hpc-training

#Test number of MPI tasks between 1 and 128 (mult by 2):
for (( nTasks=1; nTasks<=$mpiNtasks; nTasks=$nTasks*2 ))
do

	# check what time it is before the job starts
	STARTT=`date +%s%N | cut -b1-13`
	# run the parallel code "calcMatrix.py" using the openmpi libraries: 
	mpirun -n $nTasks python calcMatrix.py

	# check what time it is when the command finishes
	ENDT=`date +%s%N | cut -b1-13`
	ELAPSED=`echo 0 | awk -v e=$ENDT -v s=$STARTT '{print e-s}'`

	echo "MPI-tasks: $nTasks , run-time: $ELAPSED ms" > performance.$nTasks.log
done

cat performance.* | awk '{print $2,$5}' | sort -nk1 > performance.all
