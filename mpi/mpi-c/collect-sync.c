#include <stdio.h>
#include "mpi.h"

int main(int argv, char* argc[]){

    MPI_Init(&argv, &argc);

    int rank, numprocs;

    MPI_Comm_size(MPI_COMM_WORLD, &numprocs);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    for(int i = 0; i < numprocs; i++){
        if(rank == i){
            printf("Hello World from process %d of %d\n", rank, numprocs);
        }
        MPI_Barrier(MPI_COMM_WORLD);
    }

    MPI_Finalize();
}
