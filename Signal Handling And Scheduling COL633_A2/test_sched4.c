#include "types.h"
#include "stat.h"
#include "user.h"

int main() {
    int pid = custom_fork(1, 30);  // 30 ticks of CPU time; delayed start
    if (pid < 0) {
        printf(1, "Fork failed\n");
        exit();
    } else if (pid == 0) {
        printf(1, "[Child] Running with 30-tick budget (PID: %d)\n", getpid());
        // Simulate work; child should be auto-killed once 30 ticks are consumed.
        for (volatile int j = 0; j < 100000000; j++);
        exit();
    } else {
        printf(1, "[Parent] Created child PID %d with 30 ticks budget\n", pid);
        sleep(200);
        scheduler_start();
        wait();
        printf(1, "[Parent] Child should have been auto-killed after 30 ticks\n");
    }
    exit();
}
