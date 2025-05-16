#include "types.h"
#include "stat.h"
#include "user.h"

int main(void) {
    int pid1, pid2;

    // Child 1 with exec_time 30 ticks (should terminate sooner)
    pid1 = custom_fork(1, 30);
    if(pid1 < 0) {
        printf(1, "Fork failed for child 1\n");
        exit();
    }
    if(pid1 == 0) {
        printf(1, "[Child 1] (PID: %d) started\n", getpid());
        // Do some work
        // while(1);
        exit();
    }

    // Child 2 with exec_time 70 ticks (runs longer)
    pid2 = custom_fork(1, 70);
    if(pid2 < 0) {
        printf(1, "Fork failed for child 2\n");
        exit();
    }
    if(pid2 == 0) {
        printf(1, "[Child 2] (PID: %d) started\n", getpid());
        // Do some work
        // while(1);
        exit();
    }
    
    printf(1, "[Parent] Created child PID %d with 30 ticks and PID %d with 70 ticks\n", pid1, pid2);
    sleep(300);
    scheduler_start();
    wait();
    wait();
    printf(1, "[Parent] All child processes completed.\n");
    exit();
}
