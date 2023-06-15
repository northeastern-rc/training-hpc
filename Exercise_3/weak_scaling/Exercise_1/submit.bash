#!/bin/bash 
#SBATCH --job-name=exercise3_1
#SBATCH --partition=short
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --time=04:00:00

######## WEAK SCALING - initial array size ####################
initArraySize=2000

######## change number of OpenMP threads here: #################
export OMP_NUM_THREADS=16
################################################################

#Clean module env:
module purge

## Load modules and compilers ##
module load discovery gcc/8.1.0

## Compile code ##
g++ -o multVec -std=c++11 -Wall -Wextra -pedantic -fopenmp vecMult.cpp

## Run code on 1,2,4,8,16 threads: ##
for nOMPThreads in 1 2 4 8 16 
do	
	#run with $nOMPThreads. 
        #Since the processor count increases exponentially, increase array size exponentially:
	inputArraySize=$((initArraySize*2))
	./multVec $nOMPThreads $inputArraySize &> OMPperformance.$nOMPThreads.log
	initArraySize=$inputArraySize
done

##produce the performance file by joining all performance files and pulling the #threads and average run time, and then sorting by #threads:
grep Average OMPperformance* | awk '{print $5,$8}' | sort -nk1 > performance.all
