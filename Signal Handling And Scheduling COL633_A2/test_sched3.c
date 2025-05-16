#include "types.h"
#include "stat.h"
#include "user.h"

int main() {
    int pid1, pid2, pid3;
    
    // Create one immediate start process:
    pid1 = custom_fork(0, 50);  // starts immediately
    if (pid1 < 0) {
        printf(1, "Failed to fork immediate process\n");
        exit();
    } else if (pid1 == 0) {
        printf(1, "[Child] Immediate start process (PID: %d) running.\n", getpid());
        for (volatile int j = 0; j < 100000000; j++);
        exit();
    }
    
    // Create two delayed start processes:
    pid2 = custom_fork(1, 50);  // start later
    if (pid2 < 0) {
        printf(1, "Failed to fork delayed process 1\n");
        exit();
    } else if (pid2 == 0) {
        printf(1, "[Child] Delayed start process (PID: %d) running.\n", getpid());
        for (volatile int j = 0; j < 100000000; j++);
        exit();
    }
    
    pid3 = custom_fork(1, 50);  // start later
    if (pid3 < 0) {
        printf(1, "Failed to fork delayed process 2\n");
        exit();
    } else if (pid3 == 0) {
        printf(1, "[Child] Delayed start process (PID: %d) running.\n", getpid());
        for (volatile int j = 0; j < 100000000; j++);
        exit();
    }
    sleep(1000);
    // Parent branch: print the PIDs
    printf(1, "[Parent] Created immediate PID %d, and delayed PIDs %d and %d\n", pid1, pid2, pid3);
    sleep(200);  // wait before starting the delayed ones
    scheduler_start();
    // Wait for all children to finish
    wait();
    wait();
    wait();
    printf(1, "[Parent] All children done\n");
    exit();
}
