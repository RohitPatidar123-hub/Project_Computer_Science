#include "types.h"
#include "stat.h"
#include "user.h"
#define NUM_PROCS 3 // Number of processes to create


int main() {
           
            int pid1 = custom_fork(0, 50);  // starts immediately
            int pid2 = custom_fork(1, 50);  // start later
            int pid3 = custom_fork(1, 50);  // start later

            printf(1, "[Parent] Created PID %d (now), PID %d and %d (start later)\n", pid1, pid2, pid3);

            sleep(200);  // wait before starting delayed procs
            scheduler_start();
            wait();
            wait();
            wait();
            printf(1, "[Parent] All children done\n");
            exit();


}