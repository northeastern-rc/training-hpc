import numpy as np
#MPI_Init is called when mpi4py is imported
from mpi4py import MPI
import sys

#Retrieves MPI environment
comm=MPI.COMM_WORLD
#set variable "size" as the total number of MPI processes
size=comm.Get_size()
#set variable "rank" as the specific MPI rank on each MPI process
rank=comm.Get_rank()
#matrix dimension size:
#N=100
N = int(sys.argv[1])
#number of matrices created:
seeds=5000

#if the master process is executing this (rank=0), it will create the list of numbers between 0 to "seeds", and split them equally among the "size" processes. 
if rank == 0:
	#returns an array of evenly spaced values [0,1,...,"seeds"-1]:
	seeds = np.arange(seeds)
	#returns "size" number of sub-arrays of equal size:
	split_seeds = np.array_split(seeds, size, axis = 0)	
else:
	seeds = None
	split_seeds = None

##Scatter the seeds from master to each MPI process. Scatter takes an array and distributes contiguous sections of it across the ranks of a communicator. 
rank_seeds = comm.scatter(split_seeds, root = 0)
#Create an array of zeros of the length of the MPI tasks seeds:
rank_data = np.zeros(len(rank_seeds))

## Each MPI task loops through the seeds array it got, 

for i in np.arange(len(rank_seeds)):
	#get the random seed from the array:
	seed = rank_seeds[i]
	#set the random seed:
	np.random.seed(seed)
	#create a random matrix (size NXN) based on that seed
	data = np.random.rand(N,N)
	#perform the dot product on each matrix vector:
	data_mm = np.dot(data, data)
	#sum all dot products:
	rank_data[i] = sum(sum(data_mm))
rank_sum = sum(rank_data)

#takes elements from many processes and gathers them to one single process, into a collective data_gather array made out of all "rank_sum" values.
data_gather = comm.gather(rank_sum, root = 0)

#master prcoess will calculate the total sum and print it out:
if rank == 0:
	data_sum = sum(data_gather)
	print('Gathered data:', data_gather)
	print('Sum:', data_sum)

#MPI_Finalize is called when the script exits
