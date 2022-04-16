#!/usr/bin/bash

# The program name
export PROG=prog.mpi

# Directory in which to store log files
export LOGDIR=scaling_data

mkdir $LOGDIR

# Define the problem sizes we want to run at (this is global value of Y)
export NY=(48 192 768)
let MAXNP=$SLURM_NTASKS+1
echo "MAXNP is: "$MAXNP
# Strong scaling at multiple problem sizes

# Strong scaling.  Keep Y fixed and vary N
# The code's output is redirected and appended
# to a log file for each value of NY used
for i in ${NY[*]}; do

  export SCALE_LOG=$LOGDIR/strong_nn_$i
  echo $i
  COUNTER=2
  rm -f $SCALE_LOG

  while [  $COUNTER -lt $MAXNP ]; do
    mpirun -np $COUNTER ./$PROG -ny $i >> $SCALE_LOG
    let COUNTER=COUNTER+1
  done

done

# Weak scaling.   Keep Y/N fixed and vary N
# NY now represents the LOCAL number of points to run at
export NY=(4 64 256)  
for i in ${NY[*]}; do
  
  export SCALE_LOG=$LOGDIR/weak_nn_$i
  echo $i
  COUNTER=2
  rm -f $SCALE_LOG

  while [  $COUNTER -lt $MAXNP ]; do
    let GLOBALNY=$COUNTER*$i
    mpirun -np $COUNTER ./$PROG -ny $GLOBALNY >> $SCALE_LOG
    let COUNTER=COUNTER+1
  done

done


  
