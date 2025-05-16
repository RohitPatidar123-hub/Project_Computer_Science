// history.h
#ifndef HISTORY_H
#define HISTORY_H

#define MAX_HISTORY 200    // maximum number of history entries
#define MAX_CMD_LEN 16    // maximum command name length

// Define the structure to store a history entry.
struct history_entry {
    int pid;                    // process id
    char name[MAX_CMD_LEN];     // process name
    int mem_usage;              // total memory usage (text, data, bss, stack, heap)
    uint ctime;                 // timestamp (for sorting, if needed)
};

// Declare the global history array and the count of entries.
extern struct history_entry history_list[MAX_HISTORY];
extern int nhistory;


#endif // HISTORY_H
