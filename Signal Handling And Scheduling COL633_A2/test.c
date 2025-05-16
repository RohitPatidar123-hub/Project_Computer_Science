#include "types.h"
#include "stat.h"
#include "user.h"

int main(void) {
    int count = 0;
    while (1) {
        printf(1, "Hello %d \n", count);
        count++;
        sleep(100);
    }
}


