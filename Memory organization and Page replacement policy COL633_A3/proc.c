#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "signal.h"
#include "pageswap.h"




void helper_proc_1(int n){
  for(int i=0;i<n;i++);

}
void helper_proc(int n){
  for(int i=0;i<n;i++);
  helper_proc_1(5);
}
struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

static int myval = 0;

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

int
cpuid() {
  return mycpu()-cpus;
}

struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

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
  p->ctrl_i_pending = 0;
  
  release(&ptable.lock);

  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}

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
  p->ms = PGSIZE;
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

  acquire(&ptable.lock);

  p->state = RUNNABLE;

  release(&ptable.lock);
}

int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();
  helper_proc(4);
  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n,curproc)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n,curproc)) == 0)
      return -1;
  }
  helper_proc(4);
  helper_proc(4);
  helper_proc(4);
  helper_proc(4);
  curproc->ms += curproc->sz - sz;
  curproc->sz = sz;
  helper_proc(4);
  helper_proc(4);
  helper_proc(4);
  switchuvm(curproc);
  return 0;
}

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

  np->rss = 0; 
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz , np)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->ms = curproc->ms;
  np->parent = curproc;
  *np->tf = *curproc->tf;

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

void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;
  uint a;
  helper_proc(4);
  helper_proc(4);
  helper_proc(4);
  helper_proc(4);
  if(curproc == initproc)
    panic("init exiting");
  helper_proc(4);
  helper_proc(4);
  helper_proc(4);
  helper_proc(4);
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }
  helper_proc(4);
  helper_proc(4);
  helper_proc(4);
  helper_proc(4);
  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  if(curproc->pgdir) {
    deallocuvm(curproc->pgdir, 0, curproc->sz, curproc);

    for(a = 0; a < curproc->sz; a += PGSIZE) {
      pte_t *pte = walkpgdir(curproc->pgdir, (void*)a, 0);
      if(pte && (*pte & PTE_SWAP)) {
        int slot = (PTE_ADDR(*pte)) >> 12;  
        swap_free(slot);                    
        *pte = 0;                           
      }
    }
     helper_proc(4);
     helper_proc(4);
     helper_proc(4);
     helper_proc(4);
    curproc->rss = 0;
  }

  acquire(&ptable.lock);

  wakeup1(curproc->parent);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
       
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir,p);
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

void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
  
  for(;;){
    sti();

    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
		
	  
      if(p->state != RUNNABLE)
        continue;

      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
      switchkvm();

      c->proc = 0;
      
    }
    release(&ptable.lock);
    

  }
}

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

void
yield(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie",
  [SUSPENDED] "suspended"
  };
  
  
  acquire(&ptable.lock);  
  if(myproc()->state == SUSPENDED){
	
	 myval = 1;  
	 sched();
	 
	  }
  else{
	  myproc()->state = RUNNABLE;
	  sched();
	  }
  release(&ptable.lock);
}


void
forkret(void)
{
  static int first = 1;
  
  release(&ptable.lock);

  if (first) {
    
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  
}

void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie",
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




int count_user_pages_in_RAM(struct proc *p)
{
  int pages = 0;
  pde_t *pgdir = p->pgdir;
  if(pgdir == 0)       
    return 0;

  
  for(uint va = 0; va < p->sz; va += PGSIZE){
    pde_t *pde = &pgdir[PDX(va)];
    if(!(*pde & PTE_P))
      continue;
    pte_t *pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
    pte_t pte = pgtab[PTX(va)];
    if((pte & PTE_P) && !(pte & PTE_PS))  
      pages++;
  }
  
  return pages;
}




void handle_signal(int signum) {
    struct proc *p;
    struct proc *shell = 0;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
        if(p->pid == 2)
            shell = p;

    switch(signum) {
        
            
         case SIGP:
			
			  acquire(&ptable.lock);  
              cprintf("PID NUM_PAGES\n");
			  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
				if(p->pid >= 1 && (p->state == SLEEPING || p->state == RUNNING || p->state == RUNNABLE)) {
			
				  // int num_pages = (p->sz + PGSIZE - 1) / PGSIZE;
          int num_pages = count_user_pages_in_RAM(p);
				  cprintf("%d %d\n", p->pid, num_pages);
				}
			  }
			  // 
        release(&ptable.lock);
			  break;
    }

    
}

