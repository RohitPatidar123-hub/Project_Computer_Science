
// serial code
// ...
// ...
// Initialize MPI environment : parallet code begins
// ...
// ...
// Do work, make message passing calls
// ...
// ...
// Terminate MPI environment
// ... Serial code
// ...
// Program ends
//
// mpirun --version

#include <iostream>
#include <mpi.h>
#include <sstream>

int main(int argc, char *argv[]) {
  MPI_Init(&argc, &argv);

  int task_id;
  MPI_Comm_rank(MPI_COMM_WORLD, &task_id);

  // rank 0 coordinates work
  if (task_id == 0) {
    int num_tasks;

    // get total number of number of tasks
    MPI_Comm_size(MPI_COMM_WORLD, &num_tasks);

    // send an integer to each thread
    for (int i = 1; i < num_tasks; i++) {
      MPI_Send(&i, 1, MPI_INT, i, 0, MPI_COMM_WORLD); // this is a blocking send
      // 1 : passing single int
      // MPI_INT : type of data we are passing is an integer
      // integer we are sending is &i : so the iterator i is being sent
      // we are sending it to rank/task i with tag 0
    }

    // receive integer from each thread
    for (int i = 1; i < num_tasks; i++) {
      int recv;
      MPI_Recv(&recv, 1, MPI_INT, i, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
      // store the received data into recv buffer
      // 1 is the count , MPI_INT is the type of the data
      // i is the source that we are receving from
      // 0 is the tag

      // print received value
      std::cout << "Received " << recv << " from rank " << i << "\n";
    }
  } else { // other process
    // receive an integer from rank/task 0
    int recv;
    MPI_Recv(&recv, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);

    // square the value;
    recv *= recv;
    MPI_Send(&recv, 1, MPI_INT, 0, 0, MPI_COMM_WORLD);
  }
  MPI_Finalize();

  return 0;
}

// MPI_COMM_WORLD : includes all of our mpi processes, these are not multiples
// threads in a single process but multiple different process that are
// communication together MPI_COMM_WORLD will contain all of our MPI processes,
// rank is an id of a process inside MPI_COMM_WORLD
// Between the MPI_INIT and MPI_FINALIZE we define our code, parallel code
// MPI_Comm_size : the total number of processes
// MPI_Comm_rank : to get task id
//
// To compile : mpic++ mpi_test.cpp -o test_mpi
// To run : mpirun -n 8 ./test_mpi
// 8 specifies the number of process
// next concept : blocking and non-blocking sends & blocking and non-blocking
// receives blocking send means we are going to wait until the message is
// actually sent before continuing our task/rank
//
