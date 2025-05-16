#include "types.h"
#include "stat.h"
#include "user.h"

#define NUM_CHILDREN 3

int main(void) {
    int i, pid;
    
    // Create several children that will start later and run for 50 ticks each.
    for (i = 0; i < NUM_CHILDREN; i++) {
        pid = custom_fork(1, 50);  // Delayed start, exec_time = 50 ticks
        if (pid < 0) {
            printf(1, "Failed to fork child %d\n", i);
            exit();
        } else if (pid == 0) {
            // Child process: print a message and simulate work.
            printf(1, "Child %d (PID: %d) started but should not run yet.\n", i, getpid());
            // Simulate some work (for example, a dummy loop).
            int j;
            for (j = 0; j < 100000000; j++) {
                // Do nothing; this loop simulates computation.
            }
            exit();
        }
        // Parent continues to create the next child.
    }
    
    printf(1, "All child processes created with start_later flag set.\n");
    
    // Sleep for a while to simulate delay before starting children.
    sleep(400);
    
    printf(1, "Calling sys_scheduler_start() to allow execution.\n");
    scheduler_start();
    
    // Wait for all children to exit.
    for (i = 0; i < NUM_CHILDREN; i++) {
        wait();
    }
    
    printf(1, "All child processes completed.\n");
    exit();
}
