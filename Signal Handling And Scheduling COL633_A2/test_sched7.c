#include "types.h"
#include "stat.h"
#include "user.h"

#define NUM_CHILDREN 4

int main(void) {
    int i, pid;
    
    // Create two processes that start immediately and two that are delayed.
    for (i = 0; i < NUM_CHILDREN; i++){
        if (i < 2)
            pid = custom_fork(0, 50);  // Immediate start
        else
            pid = custom_fork(1, 50);  // Delayed start
        
        if(pid < 0) {
            printf(1, "Failed to fork child %d\n", i);
            exit();
        }
        if(pid == 0) {
            // Child process: do some dummy work.
            printf(1, "[Child %d] (PID: %d) started\n", i, getpid());
            int j;
            for(j = 0; j < 100000000; j++) ;  // Busy loop
            exit();
        }
    }
    printf(1, "[Parent] All child processes created\n");

    // Wait a bit before starting delayed processes.
    sleep(300);
    printf(1, "[Parent] Calling scheduler_start() to allow delayed processes to run\n");
    scheduler_start();

    // Wait for all children to exit.
    for(i = 0; i < NUM_CHILDREN; i++){
        wait();
    }
    printf(1, "[Parent] All child processes completed.\n");
    exit();
}
