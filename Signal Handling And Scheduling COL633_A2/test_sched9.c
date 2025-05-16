#include "types.h"
#include "stat.h"
#include "user.h"

#define NUM_CHILDREN 4

int main(void) {
    int i, pid;
    
    for (i = 0; i < NUM_CHILDREN; i++){
        pid = custom_fork(0, 10);  // All delayed start, exec_time = 50
        if(pid < 0) {
            printf(1, "Failed to fork child %d\n", i);
            exit();
        }
        if(pid == 0) {
            printf(1, "[Child %d] (PID: %d) started\n", i, getpid());
            int j;
            for(j = 0; j < 100000000; j++) ;  // Busy loop to simulate work.
            exit();
        }
    }
    printf(1, "[Parent] All child processes created.\n");
    sleep(400);
    printf(1, "[Parent] Calling scheduler_start()\n");
    scheduler_start();
    for(i = 0; i < NUM_CHILDREN; i++){
        wait();
    }
    printf(1, "[Parent] All child processes completed.\n");
    exit();
}
