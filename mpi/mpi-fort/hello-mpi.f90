PROGRAM hello_world_mpi
include 'mpif.h'

integer rank, numprocs, ierr

call MPI_INIT(ierr)
call MPI_COMM_SIZE(MPI_COMM_WORLD, numprocs, ierr)
call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)

print *, 'Hello World from process: ', rank, 'of ', numprocs

call MPI_FINALIZE(ierr)
END PROGRAM
