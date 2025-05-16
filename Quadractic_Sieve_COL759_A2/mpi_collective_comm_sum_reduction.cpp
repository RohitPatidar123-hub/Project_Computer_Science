

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

#include <algorithm>
#include <iostream>
#include <memory>
#include <mpi.h>
#include <numeric>
#include <random>

int main(int argc, char *argv[]) {
  MPI_Init(&argc, &argv);

  int num_tasks;
  MPI_Comm_size(MPI_COMM_WORLD, &num_tasks);

  // calculate chunk size
  // assume this divides equally
  //
  const int num_elements =
      1 << 10; // bit left shift 10 times so we have 2^10 elements
  const int chunk_size = num_elements / num_tasks;

  // get task id
  int task_id;
  MPI_Comm_rank(MPI_COMM_WORLD, &task_id);

  // create buffer for send (only initialized in rank 0)
  std::unique_ptr<int[]> send_ptr; // task 0 generates random data

  // generate random numbers from rank/tast 0
  if (task_id == 0) {
    // allocate memory for send buffer
    send_ptr = std::make_unique<int[]>(
        num_elements); // size of array is of num_elements

    // create random number generator
    std::random_device rd;
    std::mt19937 mt(rd());
    std::uniform_int_distribution dist(
        1, 100); // values between 1 and 1, so all values are 1

    // create random data

    std::generate(send_ptr.get(), send_ptr.get() + num_elements,
                  [&] { return dist(mt); });
  }

  // receive buffer created by all other ranks excpet rank 0
  auto recv_buffer =
      std::make_unique<int[]>(chunk_size); // size is of chunk_size

  // perform scatter of data to different threads
  MPI_Scatter(send_ptr.get(), chunk_size, MPI_INT, recv_buffer.get(),
              chunk_size, MPI_INT, 0, MPI_COMM_WORLD);
  // Scatter distribute distinct message from a single source task to each task
  // in group
  //  sending chunk_size elements of type MPI_INT
  //  all this data going into the recv_buffer
  //  0 : root for our scatter data comes from rank 0

  // calculate partial result in each thread
  auto local_result =
      std::reduce(recv_buffer.get(), recv_buffer.get() + chunk_size);

  // perform the reduction
  int global_result;
  MPI_Reduce(&local_result, &global_result, 1, MPI_INT, MPI_SUM, 0,
             MPI_COMM_WORLD); // address of sender, address of receiver
  // 1 is the count of data which is just 1
  // MPI_SUM is the operation we want to perform
  // 0 is the root where our final answer is going to go

  // print the result from rank 0
  if (task_id == 0) {
    std::cout << global_result << "\n";
  }

  // finish our mpi work
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
