PROGRAM hello_world_mpi
include 'mpif.h'

integer rank, numprocs, ierr

CALL MPI_INIT(ierr)
CALL MPI_COMM_SIZE(MPI_COMM_WORLD, numprocs, ierr)
CALL MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)

DO i = 0, numprocs, 1
    IF(rank == i) THEN
        print *, 'Hello World from process: ', rank, 'of ', numprocs
    END IF
    CALL MPI_BARRIER(MPI_COMM_WORLD, ierr)
END DO

CALL MPI_FINALIZE(ierr)
END PROGRAM
