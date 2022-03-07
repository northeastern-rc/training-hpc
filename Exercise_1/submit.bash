#!/bin/bash 

###################################
#SBATCH --job-name=exercise1
#SBATCH --nodes=1		#make sure to request work on the same node!
#SBATCH --ntasks=1		#define a single task associated with the main process
#SBATCH --cpus-per-task=16	#define 16 cpus allocated for the task 
#SBATCH --time=00:20:00
#SBATCH --partition=express

######## change number of OpenMP threads here: #################
export OMP_NUM_THREADS=16
################################################################

## Clean module env first:
module purge

## Load modules and compilers ##
module load discovery gcc/8.1.0

## Compile code ##
g++ -o multVec -std=c++11 -Wall -Wextra -pedantic -fopenmp vecMult.cpp

## Run code on 1,2,4,8,16 threads: ##
for nOMPThreads in 1 2 4 8 16
do	
	#run with $nOMPThreads:
	./multVec $nOMPThreads &> OMPperformance.$nOMPThreads.log
done

##produce the performance file by joining all performance files and pulling the #threads and average run time, and then sorting by #threads:
grep Average OMPperformance* | awk '{print $5,$8}' | sort -nk1 > performance.all
