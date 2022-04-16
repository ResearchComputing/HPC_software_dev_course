#!/bin/bash
#SBATCH --nodes=2                    	#Number of requested nodes
#SBATCH --time=0:10:00               	# Max wall time
#SBATCH --partition=shas             	# Specify Summit haswell nodes
#SBATCH --ntasks-per-node=24     	# Number of MPI tasks or cores per node
#SBATCH --job-name=scaling_tutorial     # Job submission name
#SBATCH --output=scaling.%j.out         # Output file name with Job ID
#SBATCH --reservation=hpc_tutorial2

# purge all existing modules
module purge

# load the compiler and mpi
module load intel impi


#
bash scaling_script.sh
