#!/bin/bash

#SBATCH --job-name="message-pass"
#SBATCH --partition=shas
#SBATCH --time=00:01:00
#SBATCH --ntasks=4
###SBATCH --reservation=MPI-Spring-2020
#SBATCH --output=message.%j.out

ml purge
ml gcc/8.2.0 openmpi

mpiexec -n 4 ./message-pass.exe
