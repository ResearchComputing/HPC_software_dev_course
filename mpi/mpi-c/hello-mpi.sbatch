#!/bin/bash

#SBATCH --job-name="hello-mpi"
#SBATCH --partition=shas
#SBATCH --time=00:01:00
#SBATCH --ntasks=4
###SBATCH --reservation=MPI-Spring-2020
#SBATCH --output=hello.%j.out

ml purge
ml gcc/8.2.0 openmpi

mpiexec -n 4 ./hello-mpi.exe
