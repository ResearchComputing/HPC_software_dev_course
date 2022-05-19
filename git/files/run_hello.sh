#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --time=00:02:00
#SBATCH --partition=amilan-ucb
#SBATCH --job-name lbPythonDemo
#SBATCH --output loadbalance.out

module purge

module load intel impi
module load anaconda 
module load loadbalance

mpirun lb lb_cmd_file


