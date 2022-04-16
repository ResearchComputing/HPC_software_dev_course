PROGRAM hello_world_mpi
include 'mpif.h'

integer rank, numprocs, recieved, ierr
integer stat(MPI_STATUS_SIZE)

CALL MPI_INIT(ierr)
CALL MPI_COMM_SIZE(MPI_COMM_WORLD, numprocs, ierr)
CALL MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)

IF(rank == 0) THEN
    CALL MPI_SEND(rank, 1, MPI_INTEGER, 1, 0, MPI_COMM_WORLD)
    CALL MPI_RECV(recieved, 1, MPI_INTEGER, 3, 3, MPI_COMM_WORLD)
ELSE IF(rank == 1) THEN
    CALL MPI_SEND(rank, 1, MPI_INTEGER, 2, 1, MPI_COMM_WORLD)
    CALL MPI_RECV(recieved, 1, MPI_INTEGER, 0, 0, MPI_COMM_WORLD)
ELSE IF(rank == 2) THEN
    CALL MPI_SEND(rank, 1, MPI_INTEGER, 3, 2, MPI_COMM_WORLD)
    CALL MPI_RECV(recieved, 1, MPI_INTEGER, 1, 1, MPI_COMM_WORLD)
ELSE
    CALL MPI_SEND(rank, 1, MPI_INTEGER, 0, 3, MPI_COMM_WORLD)
    CALL MPI_RECV(recieved, 1, MPI_INTEGER, 2, 2, MPI_COMM_WORLD)
END IF

print *, 'Rank: ', rank, 'recieved a message from ', recieved

CALL MPI_FINALIZE(ierr)
END PROGRAM
