#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "traps.h"
#include "spinlock.h"
#include "signal.h"
#include "pageswap.h"


 static int
count_user_pages_in_RAM(struct proc *p)
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

struct gatedesc idt[256];
extern uint vectors[];  
struct spinlock tickslock;
uint ticks;

extern struct {
    struct spinlock lock;
    struct proc proc[NPROC];
} ptable;


#define USERTOP KERNBASE

 

void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)  
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);     // Definition of SETGATE is in x86.h
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  lidt(idt, sizeof(idt));
}


void
trap(struct trapframe *tf)
{  
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();   
    lapiceoi();  
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
    break;
  
  case T_PGFLT:
    uint va = rcr2();
    struct proc *curproc = myproc();

    if(va >= curproc->sz || !curproc->pgdir)
      goto kill;

    pte_t *pte = walkpgdir(curproc->pgdir, (void*)va, 0);
    if(pte && (*pte & PTE_SWAP)) {
      handle_pgfault(curproc->pgdir, va,0);
    } else {
  kill:
      curproc->killed = 1;
    }
    break;

  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    
    cprintf("pid %d %s: trap %d err %d on cpu %d "
            "eip 0x%x addr 0x%x--kill proc\n",myproc()->pid, myproc()->name, tf->trapno,tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
  }
  
if(myproc() && myproc()->pending_signals) {
  if(myproc()->pending_signals & (1 << (SIGCUSTOM - 1))) {
    if(myproc()->sighandler) {
    uint handler_addr = (uint)myproc()->sighandler;

                if ((tf->cs & 3) == DPL_USER) {
                    tf->eip = handler_addr;

                    myproc()->pending_signals &= ~(1 << (SIGCUSTOM - 1));
                }
        }
  }

}
  
	void handle_ctrl_i(void) {
	  struct proc *p;

	  acquire(&ptable.lock); // Ensure safe access to process table

	  cprintf("Ctrl+I is detected by xv6\n");
	  cprintf("PID NUM_PAGES\n");

	  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
		if(p->pid >= 1 && (p->state == SLEEPING || p->state == RUNNING || p->state == RUNNABLE)) {
		  int num_pages = count_user_pages_in_RAM(p);
		  cprintf("%d %d\n", p->pid, num_pages);
		}
	  }

	  release(&ptable.lock);
	}
	
	struct proc *p = 0; 
	
	for(p=ptable.proc;p<&ptable.proc[NPROC];p++){
		if(p->pid == 2)
			break;
		}


	if(myproc() && myproc()->pending_suspend) {
		acquire(&ptable.lock);
		myproc()->state = SUSPENDED;
		myproc()->pending_suspend = 0;
		sched();
		release(&ptable.lock);
    
		wakeup(p);
	}
	
  struct proc *newp;
  static char *states[] = {
	  [UNUSED]    "unused",
	  [EMBRYO]    "embryo",
	  [SLEEPING]  "sleep ",
	  [RUNNABLE]  "runble",
	  [RUNNING]   "run   ",
	  [ZOMBIE]    "zombie",
	  [SUSPENDED] "suspended"
  };
  
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER){
	  exit();
	  }

  if(myproc() && myproc()->state == RUNNING &&
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
