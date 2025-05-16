#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  p->suspended=0;

//...................................................
 



//.............................................................................


  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

 //.............................................................................

np->creation_time = ticks;
np->has_started = 0;
np->total_run_time = 0;
np->total_wait_time = 0;
np->context_switches = 0;
np->total_sleeping_time = 0;
np->start_run_tick = 0;
np->exec_time = -1;
np->backup_eip=0xFFFFFFF;


//............................................................................. 



  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;

  release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;
  // cprintf("exit(): process %d (%s) exiting\n", curproc->pid, curproc->name);
  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;
  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

//............................................................................. 

curproc->end_time = ticks;

int tat = curproc->end_time - curproc->creation_time;
int wt = tat - curproc->total_run_time - curproc->total_sleeping_time;
int rt = curproc->first_run_time - curproc->creation_time;
int cs = curproc->context_switches-1;

// int first_run = curproc->first_run_time;
// int end_time = curproc->end_time;

// cprintf("total run time : %d\n", curproc->total_run_time);
// cprintf("Creation Time: %d\n", curproc->creation_time);
// cprintf("First Run Time: %d\n", first_run);
// cprintf("End Time: %d\n", end_time);

cprintf("PID: %d\n", curproc->pid);
cprintf("TAT: %d\n", tat);
cprintf("WT: %d\n", wt);
cprintf("RT: %d\n", rt);
cprintf("#CS: %d\n", cs);
cprintf("Sleeping Time: %d\n", curproc->total_sleeping_time);
    
  if(curproc->state == ZOMBIE) {
    cprintf("exit(): process %d already zombie, panic!\n", curproc->pid);
    panic("zombie exit");
  }  


//.............................................................................

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.

void
yield(void)
{
 
  acquire(&ptable.lock);  //DOC: yieldlock
  if(myproc()->state == SUSPENDED){
    sched();
  }else{
    myproc()->state = RUNNABLE;
    sched();
  }
  release(&ptable.lock);
}
// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  } 

  int sleep_start_tick=ticks;
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();
   // When the process wakes up, update the total_sleep_time.
  p->total_sleeping_time += (ticks - sleep_start_tick);
  // Tidy up.
  p->chan = 0;

   if(p->killed){
        release(&ptable.lock);
        exit();
    }

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
   { 
          if(p->state == SLEEPING && p->chan == chan && !p->suspended)
             {   
               p->state = RUNNABLE;
             }
   }   
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [WAITING_TO_START]  "wait_to_start ",
  [RUNNABLE]  "runnble",
  [RUNNING]   "running   ",
  [ZOMBIE]    "zombie",
  [STOPPED]   "stopped",
  [SUSPENDED] "suspended"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

//..........................................................

int sys_custom_fork(void) {
    int start_later, exec_time;
    if (argint(0, &start_later) < 0 || argint(1, &exec_time) < -1)
        return -1;

    int pid = fork();
    if (pid < 0) return -1;
    if (pid == 0) return 0; 
   
    
    struct proc *p;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->pid == pid) {
            p->start_later = start_later;
            p->exec_time = exec_time;
            // acquire(&ptable.lock);
            if (start_later == 1)
                p->state = WAITING_TO_START ;  
            else
                p->state = RUNNABLE;
            // release(&ptable.lock);
            break;
        }
    }
    return pid;
}


int sys_scheduler_start(void) {
    struct proc *p;
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
         if(p->start_later == 1 && p->state == WAITING_TO_START) {
              p->state = RUNNABLE;
              p->start_later = 0;
          }

    }
    release(&ptable.lock);
    return 0;
}


//..........................................................




// void wakeup_shell(void) {
//   struct proc *p;
//   acquire(&ptable.lock);
//   for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
//     if(p->pid == 2){  // shell is typically pid 2
//       p->state = RUNNABLE;
//       cprintf("Shell (pid=%d) explicitly woken up\n", p->pid);
//       break;
//     }
//   }
//   release(&ptable.lock);
// }


void send_signal_to_all(int sig){
    struct proc *p;
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
         if (p->pid == 1 ) continue;
         if (p->pid == 2){
            p->suspended = 0;
            p->state = RUNNABLE;
            continue;
         }
         if(p->state == UNUSED ){
            continue;
         }

          switch(sig) {
            case SIGINT:
                p->killed = 1;   
                if(p->state == SLEEPING || p->state == SUSPENDED || p->state == WAITING_TO_START  || p->state == RUNNABLE)
                    p->state = RUNNABLE; 

                break;

            case SIGBG:
                  if(p->state == RUNNING || p->state == RUNNABLE || p->state == SLEEPING || p->state == WAITING_TO_START || p->state == STOPPED){
                      p->state = SUSPENDED;
                      p->suspended = 1;

                    }
                    struct proc *itr;
                    for(itr = ptable.proc; itr < &ptable.proc[NPROC]; itr++){
                      if(itr->pid > 2 ){
                        itr->parent = initproc;
                      }
                    }
                  break;

            case SIGFG:
                  if(p->state == SUSPENDED)
                    { 
                     p->suspended = 0;  
                     p->state = RUNNABLE;  
  
                    }
                  break;

            case SIGCUSTOM:
                 if(p->signal_handler){
                     p->pending_signal = SIGCUSTOM;
                     if(p->state == SLEEPING)
                        p->state = RUNNABLE;
                }
                break;
        }       
    }
   wakeup1(ptable.proc+1);// wake up shell
   
    release(&ptable.lock);
}



void scheduler(void)
{
  struct proc *p, *chosen = 0;
  struct proc * previous_process = 0;
  struct cpu *c = mycpu();
  // int best_priority = -1000000000;
  // int dynamic_priority;
  c->proc = 0;
  
  for(;;)
  {
           int best_priority = -1000000000;
           int dynamic_priority;
          sti();
          acquire(&ptable.lock);
          for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
          {
                   
                   
                    if(p->state != RUNNABLE)
                           continue;
                    if(p->suspended == 1 || p->state == SUSPENDED)
                           continue;
                    if(p->state == WAITING_TO_START)
                           continue;
                    
                    if(p->has_started == 0) 
                          {
                            p->first_run_time = ticks;
                            p->has_started = 1;
                          }
                   
                    int tat =ticks - p->creation_time ;
                    int wt = tat - p->total_run_time-p->total_sleeping_time;
                      
                    // cprintf("total sleep time : %d ....%d \n", p->total_sleeping_time,p->pid);
                    dynamic_priority = INIT_PRIORITY - ALPHA * p->total_run_time + BETA * wt;
                    if(dynamic_priority > best_priority ||
                      (dynamic_priority == best_priority && chosen && p->pid < chosen->pid)) {
                      best_priority = dynamic_priority;
                      chosen = p;
                    }
                  //  int end_wait = ticks ;
                   
                  //  p->total_wait_time += (end_wait - start_wait);
                  //  if(p->pid!=1 || p->pid!=2) 
                  //       cprintf("total>wait_time :%d",p->total_wait_time);
                    
          }
          
          // cprintf("best_priority : %d...p->pid\n",best_priority,p->pid);
          best_priority = -1000000;

          if(chosen)
          {
                  chosen->start_run_tick = ticks;
                  if(previous_process != chosen || previous_process==0)
                  {
                          chosen->context_switches++;
                  }
                  
                  c->proc = chosen;
                  switchuvm(chosen);
                  chosen->state = RUNNING;
                  swtch(&(c->scheduler), chosen->context);
                  switchkvm();
                  chosen->total_run_time += (ticks - chosen->start_run_tick);
                  if (chosen->exec_time > 0 && chosen->total_run_time >= chosen->exec_time)
                  {
                        chosen->killed = 1;
                    }
                  c->proc = 0;
                  
                  previous_process = chosen ; 
                  chosen = 0 ;
          }
             release(&ptable.lock);
  }  
          // release(&ptable.lock);
  }






// void
// scheduler(void)
// {
//   struct proc *p, *chosen = 0;
//   struct cpu *c = mycpu();
//   c->proc = 0;
  
//   for(;;){
//     // Enable interrupts on this processor.
//     sti();

//     acquire(&ptable.lock);
    
//     // PROFILER: For every RUNNABLE process (that is not suspended),
//     // increment its total_wait_time.
//     // (This loop ensures all processes waiting get a wait tick.)
//     // for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
//     //   // Skip processes that are not runnable or that are suspended.
//     //   if(p->state == RUNNABLE && !(p->suspended == 1 || p->state == SUSPENDED))
//     //       p->total_wait_time++;
//     // }
    
//     // Now select a process to run.
//     for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
//       // Skip UNUSED processes.
//       if(p->state == UNUSED)
//         continue;
//       // Skip suspended processes.
//       if(p->suspended == 1 || p->state == SUSPENDED)
//         continue;
//       // We are only interested in RUNNABLE processes.
//       if(p->state != RUNNABLE)
//         continue;
//       if(p->state==WAITING_TO_START){
//            continue; // Skip processes that are waiting to start
//       }  

//       // PROFILER: If this process hasn't started running before,
//       // record its first run time.
//       if(p->has_started == 0) {
//         p->first_run_time = ticks;
//         p->has_started = 1;
//       }
//       // PROFILER: Increment context switch counter for this process.
//       p->context_switches++;
      
//       chosen = p;  // Select the first RUNNABLE process.
//       break;
//     }
    
//     if(chosen){
//       chosen->start_run_tick = ticks;
//       c->proc = chosen;
//       switchuvm(chosen);
//       chosen->state = RUNNING;
      
//       // Context switch: scheduler yields control to the chosen process.
//       swtch(&(c->scheduler), chosen->context);
//       switchkvm();

//       // PROFILER: After the process yields (i.e. its time slice ends),
//       // increment its total run time (assume one tick per yield for simplicity).
//      chosen->total_run_time += (ticks - chosen->start_run_tick);
      
//       // Reset current CPU's proc pointer.
//       c->proc = 0;
//       chosen = 0;
//     }
    
//     release(&ptable.lock);
//   }
// }


























































































// void
// scheduler(void)
// {
//   struct proc *p,*chosen =0;
//   struct cpu *c = mycpu();
//   c->proc = 0;
  
//   for(;;)
//   {
//           // Enable interrupts on this processor.
//           sti();

//           // Loop over process table looking for process to run.
//           acquire(&ptable.lock);
//           for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
//               {
//                             if(p->state == UNUSED ){
//                               continue;
//                             }
                            
//                             if(p->suspended == 1 || p->state == SUSPENDED){
//                               continue;
//                             }
                              
//                             if(p->state != RUNNABLE){ 
//                               //cprintf("Scheduler skipping suspended pid=%d name=%s  state=%d\n", p->pid, p->name , p->state);
//                               continue;
//                             }       
//                             //............................
                         
                         
//                           if(p->has_started == 0) {
//                             p->first_run_time = ticks;
//                             p->has_started = 1;
//                           }
//                           p->context_switches++;     // PROFILER: Increment context switch count for each time a process is scheduled
//                           chosen = p;
//                           break;                     // select the first RUNNABLE process   


//                                                     if(chosen){
//                           for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
//                             if(p->state == RUNNABLE && p != chosen)
//                               p->total_wait_time++;
//                           }
//                         } 

//                           //............................




//                             // Check pending signals
//                             if(p->pending_signal == SIGINT){
//                               p->killed = 1; 
//                               p->pending_signal = 0;
//                               continue; // Process killed
//                             }
//                             else if(p->pending_signal == SIGBG){
//                               p->state = SUSPENDED; 
//                               cprintf("in sigb pending signal");
//                               p->suspended = 1;
//                               p->pending_signal = 0;
//                               continue;
//                             }
//                             else if(p->pending_signal == SIGFG){
//                               cprintf("in sigf pending signal");
//                               p->state = RUNNABLE; // Resume process
//                               p->pending_signal = 0;
//                             }
//                             else if(p->pending_signal == SIGCUSTOM){
//                               p->tf->eip = (uint)p->signal_handler;
//                               p->tf->esp -= 4;
//                               *(uint*)p->tf->esp = p->tf->eip;
//                               p->pending_signal = 0;
//                             }
//                           // Switch to chosen process.  It is the process's job
//                           // to release ptable.lock and then reacquire it
//                           // before jumping back to us.
//                         //   //............................
                         
                         
//                         //   if(p->has_started == 0) {
//                         //     p->first_run_time = ticks;
//                         //     p->has_started = 1;
//                         //   }
//                         //   p->context_switches++;     // PROFILER: Increment context switch count for each time a process is scheduled
//                         //   chosen = p;
//                         //   break;                     // select the first RUNNABLE process   


//                         //                             if(chosen){
//                         //   for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
//                         //     if(p->state == RUNNABLE && p != chosen)
//                         //       p->total_wait_time++;
//                         //   }
//                         // } 

//                         //   //............................



        
      
//             }


//           if(chosen)
//           {
//                       c->proc = chosen;
//                       switchuvm(chosen);
//                       chosen->state = RUNNING;
                      
//                       // Context switch: scheduler yields control to chosen process.
//                       swtch(&(c->scheduler), chosen->context);
//                       switchkvm();

//                       // PROFILER: After the process yields (its time slice ends),
//                       // increment its total run time (assume one tick per slice for simplicity).
//                       chosen->total_run_time++;

//                       // Process is done running for now.
//                       c->proc = 0;
//                       chosen = 0; // reset chosen pointer for the next iteration
//           }


//           release(&ptable.lock);

//   }
// }


// void scheduler(void)
// {
//   struct proc *p, *chosen = 0;
//   struct cpu *c = mycpu();
//   c->proc = 0;

//   for(;;){
//     // Enable interrupts on this processor.
//     sti();

//     // Acquire ptable.lock to scan the process table.
//     acquire(&ptable.lock);

//     // First, select one RUNNABLE process to run.
//     for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
//       // if(p->state != RUNNABLE)
//       //   continue;
//        if(p->state == UNUSED ){
//           continue;
//         }
        
//         if(p->suspended == 1 || p->state == SUSPENDED){
//           continue;
//         }
          
//         if(p->state != RUNNABLE){ 
//           //cprintf("Scheduler skipping suspended pid=%d name=%s  state=%d\n", p->pid, p->name , p->state);
//           continue;
//         }
//       // PROFILER: For the chosen process, if it hasn't started yet, record its first run time.
//       if(p->has_started == 0) {
//         p->first_run_time = ticks;
//         p->has_started = 1;
//       }
//       // PROFILER: Increment context switch count for each time a process is scheduled.
//       p->context_switches++;

//       chosen = p;
//       break;  // select the first RUNNABLE process
//     }

//     // PROFILER: For every process in RUNNABLE state that was not chosen,
//     // increment its waiting time (this represents the passage of one scheduler tick).
//     if(chosen){
//       for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
//         if(p->state == RUNNABLE && p != chosen)
//           p->total_wait_time++;
//       }
//     }

//     // If a process was selected, switch to it.
//     if(chosen){
//       c->proc = chosen;
//       switchuvm(chosen);
//       chosen->state = RUNNING;
      
//       // Context switch: scheduler yields control to chosen process.
//       swtch(&(c->scheduler), chosen->context);
//       switchkvm();

//       // PROFILER: After the process yields (its time slice ends),
//       // increment its total run time (assume one tick per slice for simplicity).
//       chosen->total_run_time++;

//       // Process is done running for now.
//       c->proc = 0;
//       chosen = 0; // reset chosen pointer for the next iteration
//     }
//     release(&ptable.lock);
//   }
// }

// void scheduler(void)
// {
//   struct proc *p, *chosen = 0;
//   struct cpu *c = mycpu();
//   c->proc = 0;
  
//   for(;;){
//     // Enable interrupts on this processor.
//     sti();

//     // Acquire ptable.lock to scan the process table.
//     acquire(&ptable.lock);

//         // int max_priority = -100000; // large negative initial value
//         // chosen = 0;
//         // Update waiting ticks for all RUNNABLE processes
//         // for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
//         //     if(p->state == RUNNABLE)
//         //         p->wait_ticks++;
//         // }


//     // First, select one RUNNABLE process to run.
//     for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
//       if(p->state != RUNNABLE)
//         continue;
       
//       // int dynamic_priority = p->initial_priority - ALPHA * p->cpu_ticks + BETA * p->wait_ticks;
//       //  if(chosen == 0 || dynamic_priority > max_priority || (dynamic_priority == max_priority && p->pid < chosen->pid)){
//       //           chosen = p;
//       //           max_priority = dynamic_priority;
//       //       }

//        if(chosen){
//             // chosen->wait_ticks = 0; // reset wait_ticks after being scheduled
//             c->proc = chosen;
//             switchuvm(chosen);
//             chosen->state = RUNNING;
          
//             swtch(&(c->scheduler), chosen->context);
//             switchkvm();

//             // Increment CPU ticks after running
//             // chosen->cpu_ticks++;

//             c->proc = 0;
//         }
//       // PROFILER: For the chosen process, if it hasn't started yet, record its first run time.
//       if(p->has_started == 0) {
//         p->first_run_time = ticks;
//         p->has_started = 1;
//       }
//       // PROFILER: Increment context switch count for each time a process is scheduled.
//       p->context_switches++;
      
//       chosen = p;
//       break;  // select the first RUNNABLE process
//     }

//     // PROFILER: For every process in RUNNABLE state that was not chosen,
//     // increment its waiting time (this represents the passage of one scheduler tick).
//     if(chosen){
//       for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
//         if(p->state == RUNNABLE && p != chosen)
//           p->total_wait_time++;
//       }
//     }

//     // If a process was selected, switch to it.
//     if(chosen){
//       c->proc = chosen;
//       switchuvm(chosen);
//       chosen->state = RUNNING;

//       // Context switch: scheduler yields control to chosen process.
//       swtch(&(c->scheduler), chosen->context);
//       switchkvm();

//       // PROFILER: After the process yields (its time slice ends),
//       // increment its total run time (assume one tick per slice for simplicity).
//       chosen->total_run_time++;

//       // Process is done running for now.
//       c->proc = 0;
//       chosen = 0; // reset chosen pointer for the next iteration
//     }
//     release(&ptable.lock);
//   }
// }











// void
// scheduler(void)
// {
//   struct proc *p;
//   struct cpu *c = mycpu();
//   c->proc = 0;
  
//   for(;;){
//     // Enable interrupts on this processor.
//     sti();

//     // Loop over process table looking for process to run.
//     acquire(&ptable.lock);
//     for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
//       if(p->state == UNUSED )
//         continue;
//       if(p->state != RUNNABLE || p->suspended )
//         { 
//                  //cprintf("Scheduler skipping suspended pid=%d name=%s  state=%d\n", p->pid, p->name , p->state);
//                  continue;
//         }        
      

//     // Check pending signals
//       if(p->pending_signal == SIGINT){
//         p->killed = 1; 
//         p->pending_signal = 0;
//         continue; // Process killed
//       }
//       else if(p->pending_signal == SIGBG){
//         cprintf("reached sigbg\n");
//         p->state = SUSPENDED; 
//         p->pending_signal = 1;

//         continue; // Process suspended
//       }
//       else if(p->pending_signal == SIGFG){
//         p->state = RUNNABLE; // Resume process
//         p->pending_signal = 0;
//       }
      
//       // SIGCUSTOM handled differently (user-defined handler in trap.c)
//       else if(p->pending_signal == SIGCUSTOM){
//         p->tf->eip = (uint)p->signal_handler;
//         p->tf->esp -= 4;
//         *(uint*)p->tf->esp = p->tf->eip;
//         p->pending_signal = 0;
//       }





//       // Switch to chosen process.  It is the process's job
//       // to release ptable.lock and then reacquire it
//       // before jumping back to us.
//       c->proc = p;
//       switchuvm(p);
//       p->state = RUNNING;

//       swtch(&(c->scheduler), p->context);
//       switchkvm();

//       // Process is done running for now.
//       // It should have changed its p->state before coming back.
//       c->proc = 0;
//     }
//     release(&ptable.lock);

//   }
// }

















































































