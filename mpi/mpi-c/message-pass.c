#include <stdio.h>
#include "mpi.h"

int main(int argv, char* argc[]){

    MPI_Init(&argv, &argc);

    int rank, numprocs, storedrank;
    MPI_Status status;

    MPI_Comm_size(MPI_COMM_WORLD, &numprocs);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    if(rank == 0){
        MPI_Send(&rank, 1, MPI_INT, 1, 0, MPI_COMM_WORLD);
        MPI_Recv(&storedrank, 1, MPI_INT, 3, 3, MPI_COMM_WORLD, &status);
    }
    else if(rank == 1){
        MPI_Send(&rank, 1, MPI_INT, 2, 1, MPI_COMM_WORLD);
        MPI_Recv(&storedrank, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, &status);
    }
    else if(rank == 2){
        MPI_Send(&rank, 1, MPI_INT, 3, 2, MPI_COMM_WORLD);
        MPI_Recv(&storedrank, 1, MPI_INT, 1, 1, MPI_COMM_WORLD, &status);
    }
    else{
        MPI_Send(&rank, 1, MPI_INT, 0, 3, MPI_COMM_WORLD);
        MPI_Recv(&storedrank, 1, MPI_INT, 2, 2, MPI_COMM_WORLD, &status);
    }

    printf("Rank %d received a message from %d\n", rank, storedrank);

    MPI_Finalize();

}
