// This file contains the structure of the process and the cpu.
#define SIGINT     1  // Ctrl+C
#define SIGBG      2  // Ctrl+B
#define SIGFG      3  // Ctrl+F
#define SIGCUSTOM  4  // Ctrl+G


struct cpu {
  uchar apicid;                // Local APIC ID
  struct context *scheduler;   // swtch() here to enter scheduler
  struct taskstate ts;         // Used by x86 to find stack for interrupt
  struct segdesc gdt[NSEGS];   // x86 global descriptor table
  volatile uint started;       // Has the CPU started?
  int ncli;                    // Depth of pushcli nesting.
  int intena;                  // Were interrupts enabled before pushcli?
  struct proc *proc;           // The process running on this cpu or null
};

extern struct cpu cpus[NCPU];
extern int ncpu;

//PAGEBREAK: 17
// Saved registers for kernel context switches.
// Don't need to save all the segment registers (%cs, etc),
// because they are constant across kernel contexts.
// Don't need to save %eax, %ecx, %edx, because the
// x86 convention is that the caller has saved them.
// Contexts are stored at the bottom of the stack they
// describe; the stack pointer is the address of the context.
// The layout of the context matches the layout of the stack in swtch.S
// at the "Switch stacks" comment. Switch doesn't save eip explicitly,
// but it is on the stack and allocproc() manipulates it.

struct context {
  uint edi;
  uint esi;
  uint ebx;
  uint ebp;
  uint eip;
}; 

enum procstate { UNUSED, EMBRYO, SLEEPING,WAITING_TO_START, RUNNABLE, RUNNING, ZOMBIE , STOPPED, SUSPENDED};

// Per-process state
struct proc {
  uint sz;                    // Size of process memory (bytes)
  int control_flag;           // Control flag for SIGBG
  int pending_signal;                  // pending signal
  void (*signal_handler)(void);        // custom signal handler
  int suspended; 
  int in_signal_handler;        // Flag to avoid reentrancy.
  uint backup_eip;              // 🔥 Save original eip here
  int in_handler;        // flag to prevent re-entering the handler
  
  //.................................
  
  // New fields for custom scheduling
    int start_later;          // 1 if process should not run until scheduler_start()
    int exec_time;            // Remaining execution time in ticks (-1 means run indefinitely)
    int start_time;           // Time when the process was actually started
  

  int creation_time;       // Time when process was created
  int end_time;            // Time when process exited
  int first_run_time;      // Time when process first got scheduled
  int total_run_time;      // Total ticks the process actually ran
  int total_wait_time;     // Accumulate when not running
  int context_switches;    // Total number of times scheduled
  int has_started;         // Flag to mark if it has started once
   int start_run_tick;          // Tick when the process started running
  int total_sleeping_time; // Total time spent sleeping

  //................................
    //part 2.3
    

  //.................................

  pde_t* pgdir;                // Page table
  char *kstack;                // Bottom of kernel stack for this process
  enum procstate state;        // Process state
  int pid;                     // Process ID
  struct proc *parent;         // Parent process
  struct trapframe *tf;        // Trap frame for current syscall
  struct context *context;     // swtch() here to run process
  void *chan;                  // If non-zero, sleeping on chan
  int killed;                  // If non-zero, have been killed
  struct file *ofile[NOFILE];  // Open files
  struct inode *cwd;           // Current directory
  char name[16];               // Process name (debugging)
};




