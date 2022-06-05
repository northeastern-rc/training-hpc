# hpc-102021
Introduction to HPC Parallel Programming material - training session October 2021.

## What's in this training?
* Training PowerPoint slides "Introduction_to_HPC_Parallel_Programming.pptx".
* Exercises - practical examples on how to run parallel workloads on Discovery.
  * Exercise 1 - Shared Memory Parallelization using OpenMP.
  * Exercise 2 - Distributed Parallelization using MPI.
  * Exercise 3 - Distributed data parallelization (using data parallel approaches with Slurm Job arrays).
  * Exercise 4 (optional) - Evaluating advanced performance metrics such as Speedup and Efficiency.
  * Exercise 5 (optional) - Increase performance with InfiniBand MPI and test perfroamnce.

## Overview:
This this session covers:
* Introduction to HPC Parallel Programming
* What is HPC?
* Penalization approaches (shared memory, distributed memory, data parallel)
* Optimization approaches
* Shared memory C++ example with OpenMP
* Distributed memory Python example with MPI (mpi4py)
* Data parallel example with Slurm job arrays
Optional material covered:
* Parallel computing models
* Parallel architectures 
* OpenMP & MPI basics
* Evaluating advanced performance metrics (Speedup and Efficiency)
* Evaluating weak and strong scaling (Amdahl’s Law, Gustafson’s Law)
* Increase MPI performance with the InfiniBand network

## Steps to use these training scripts on Discovery:
1. Login to a Discovery shell or use the [Discovery OnDemand interface](https://rc-docs.northeastern.edu/en/latest/first_steps/connect_ood.html).
2. Enter your desired directory within Discovery and download the training material. For example:
```bash
cd $HOME
git clone git@github.com:NURC-Training/hpc-102021.git
cd hpc-102021
```
3. Download the training slides to your local computer, where you have access to PowerPoint to open the slides. Follow the slides to execute the different scripts.
4. Example:
```bash
cd Exercise_1
sbatch submit.bash
```
