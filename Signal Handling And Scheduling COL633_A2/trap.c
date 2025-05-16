#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "traps.h"
#include "spinlock.h"

// Interrupt descriptor table (shared by all CPUs).
struct gatedesc idt[256];
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  lidt(idt, sizeof(idt));
}

//PAGEBREAK: 41
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
   
    // If the process is suspended, do not increment ticks
// Current process CPU time accounting
    // if(myproc() && myproc()->state == RUNNING){
    //   struct proc *p = myproc();
    //   // The process used 1 CPU tick
    //   // p->cpu_ticks++;
       
    //   // If it has a finite time budget, decrement it
    //   if(p->exec_time != -1){
    //     p->exec_time--;
    //     if(p->exec_time <= 0){
    //       // Time is up: mark as killed
    //       p->killed = 1;
    //     }
    //   }
    // }




    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    if(myproc() && myproc()->suspended && myproc()->state == SLEEPING){
      myproc()->state = RUNNABLE;
    }
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
    break;

  // case T_PGFLT:
  //   // If this is our intentional fault for SIGCUSTOM handling,
  //   // restore the trap frame's eip to the registered signal handler.
  //   if(myproc() && (tf->cs & 3) == DPL_USER && tf->eip == MAGIC_SIGFAULT) {
  //     tf->eip = (uint)myproc()->signal_handler;
  //     break;
  //   }   

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
  }

  if(myproc() && myproc()->suspended && myproc()->pid > 2 && (tf->cs&3) ==  DPL_USER){
     yield();
     return ;
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();

     if(myproc() && (tf->cs & 3) == DPL_USER && myproc()->pending_signal == SIGCUSTOM && myproc()->signal_handler) {
      
    myproc()->pending_signal = 0;         // Clear the pending signal flag.
    myproc()->backup_eip = tf->eip;         // Backup current eip for sigreturn.
    // tf->eip = MAGIC_SIGFAULT;               // Force intentional page fault.
    tf->eip = (uint)myproc()->signal_handler;
  }




//   if(myproc() && myproc()->pending_signal == SIGCUSTOM && myproc()->signal_handler) {
//     myproc()->pending_signal = 0; // clear pending signal
//         // Save current instruction pointer (eip)
//     myproc()->backup_eip =tf->eip;
//     // Set instruction pointer to signal handler
//     tf->eip = (uint)myproc()->signal_handler;
// }



//   if (myproc() && myproc()->signal_handler) {
//     myproc()->tf->eip = (uint)myproc()->signal_handler;
// }


  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

}

























// #include "types.h"
// #include "defs.h"
// #include "param.h"
// #include "memlayout.h"
// #include "mmu.h"
// #include "proc.h"
// #include "x86.h"
// #include "traps.h"
// #include "spinlock.h"

// // Define a magic address to trigger intentional page fault for SIGCUSTOM
// #define MAGIC_SIGFAULT 0xDEADBEEF

// // Interrupt descriptor table (shared by all CPUs).
// struct gatedesc idt[256];
// extern uint vectors[];  // in vectors.S: array of 256 entry pointers
// struct spinlock tickslock;
// uint ticks;

// void
// tvinit(void)
// {
//   int i;
//   for(i = 0; i < 256; i++)
//     SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
//   SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);

//   initlock(&tickslock, "time");
// }

// void
// idtinit(void)
// {
//   lidt(idt, sizeof(idt));
// }

// //PAGEBREAK: 41
// void
// trap(struct trapframe *tf)
// {
//   if(tf->trapno == T_SYSCALL){
//     if(myproc()->killed)
//       exit();
//     myproc()->tf = tf;
//     syscall();
//     if(myproc()->killed)
//       exit();
//     return;
//   }

//   switch(tf->trapno){
  
//   case T_IRQ0 + IRQ_TIMER:
//     if(cpuid() == 0){
//       acquire(&tickslock);
//       ticks++;
//       wakeup(&ticks);
//       release(&tickslock);
//     }
//     lapiceoi();
//     break;

//   case T_IRQ0 + IRQ_IDE:
//     ideintr();
//     lapiceoi();
//     break;

//   case T_IRQ0 + IRQ_IDE+1:
//     // Bochs generates spurious IDE1 interrupts.
//     break;

//   case T_IRQ0 + IRQ_KBD:
//     kbdintr();
//     lapiceoi();
//     break;

//   case T_IRQ0 + IRQ_COM1:
//     if(myproc() && myproc()->suspended && myproc()->state == SLEEPING){
//       myproc()->state = RUNNABLE;
//     }
//     uartintr();
//     lapiceoi();
//     break;

//   case T_IRQ0 + 7:
//   case T_IRQ0 + IRQ_SPURIOUS:
//     cprintf("cpu%d: spurious interrupt at %x:%x\n",
//             cpuid(), tf->cs, tf->eip);
//     lapiceoi();
//     break;

//   case T_PGFLT:
//     // --- Handle intentional page fault caused by SIGCUSTOM ---
//     if(myproc() && (tf->cs & 3) == DPL_USER && rcr2() == MAGIC_SIGFAULT) {
//     //   cprintf("entertaing page fault, %d  %d",tf->eip, rcr2(), myproc()->signal_handler);
//       tf->eip = myproc()->backup_eip; // Restore the original instruction pointer
//       break;
//     }

//   case T_GPFLT:
//     // --- Handle intentional page fault caused by SIGCUSTOM ---
//     if(myproc() && (tf->cs & 3) == DPL_USER && rcr2() == MAGIC_SIGFAULT) {
//       tf->eip = (uint)myproc()->signal_handler;
//       break;
//     } 
//     // ----------------------------------------------------------
//     // fall through to default if it's a genuine page fault

//   default:
//     if(myproc() == 0 || (tf->cs & 3) == 0){
//       cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
//               tf->trapno, cpuid(), tf->eip, rcr2());
//       panic("trap");
//     }
//     cprintf("pid %d %s: trap %d err %d on cpu %d "
//             "eip 0x%x addr 0x%x--kill proc\n",
//             myproc()->pid, myproc()->name, tf->trapno,
//             tf->err, cpuid(), tf->eip, rcr2());
//     myproc()->killed = 1;
//   }

//   // If suspended process resumes, yield to shell
//   if(myproc() && myproc()->suspended && myproc()->pid > 2 &&
//      (tf->cs & 3) == DPL_USER) {
//     yield();
//     return;
//   }

//   // Exit if killed and currently in user mode
//   if(myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
//     exit();

//   // --- SIGCUSTOM: Force page fault if signal is pending ---
//   if(myproc() && (tf->cs & 3) == DPL_USER && myproc()->pending_signal == SIGCUSTOM && myproc()->signal_handler) {
//     myproc()->pending_signal = 0;
//     myproc()->backup_eip = tf->eip;
//     tf->eip = MAGIC_SIGFAULT;
//     // cprintf("%d", myproc()->signal_handler);
//     // cprintf("%d : ",tf->eip);
    
//     // cprintf("in sigcustom pending signal");
//     // cprintf("pid %d %s: trap %d err %d on cpu %d "
//     //         "eip 0x%x addr 0x%x--kill proc\n",
//     //         myproc()->pid, myproc()->name, tf->trapno,
//     //         tf->err, cpuid(), tf->eip, rcr2());
//              myproc()->tf->eip = (uint)myproc()->signal_handler;

//         // cprintf("%d : ,,,,%d : \n",tf->eip, myproc()->tf->eip);      
   
//   }
//   // --------------------------------------------------------

//   // Yield if time interrupt occurred and process is running
//   if(myproc() && myproc()->state == RUNNING &&
//      tf->trapno == T_IRQ0 + IRQ_TIMER)
//     yield();
// }









// #include "types.h"
// #include "defs.h"
// #include "param.h"
// #include "memlayout.h"
// #include "mmu.h"
// #include "proc.h"
// #include "x86.h"
// #include "traps.h"
// #include "spinlock.h"

// // Interrupt descriptor table (shared by all CPUs).
// struct gatedesc idt[256];
// extern uint vectors[];  // in vectors.S: array of 256 entry pointers
// struct spinlock tickslock;
// uint ticks;

// void
// tvinit(void)
// {
//   int i;

//   for(i = 0; i < 256; i++)
//     SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
//   SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

//   initlock(&tickslock, "time");
// }

// void
// idtinit(void)
// {
//   lidt(idt, sizeof(idt));
// }

// //PAGEBREAK: 41
// void
// trap(struct trapframe *tf)
// {
//   if(tf->trapno == T_SYSCALL){
//     if(myproc()->killed)
//       exit();
//     myproc()->tf = tf;
//     syscall();
//     if(myproc()->killed)
//       exit();
//     return;
//   }

//   switch(tf->trapno){
//   case T_IRQ0 + IRQ_TIMER:
//     if(cpuid() == 0){
//       acquire(&tickslock);
//       ticks++;
//       wakeup(&ticks);
//       release(&tickslock);
//     }
//     lapiceoi();
//     break;
//   case T_IRQ0 + IRQ_IDE:
//     ideintr();
//     lapiceoi();
//     break;
//   case T_IRQ0 + IRQ_IDE+1:
//     // Bochs generates spurious IDE1 interrupts.
//     break;
//   case T_IRQ0 + IRQ_KBD:
//     kbdintr();
//     lapiceoi();
//     break;
//   case T_IRQ0 + IRQ_COM1:
//     if(myproc() && myproc()->suspended && myproc()->state == SLEEPING){
//       myproc()->state = RUNNABLE;
//     }
//     uartintr();
//     lapiceoi();
//     break;
//   case T_IRQ0 + 7:
//   case T_IRQ0 + IRQ_SPURIOUS:
//     cprintf("cpu%d: spurious interrupt at %x:%x\n",
//             cpuid(), tf->cs, tf->eip);
//     lapiceoi();
//     break;

//   //PAGEBREAK: 13
//   default:
//     if(myproc() == 0 || (tf->cs&3) == 0){
//       // In kernel, it must be our mistake.
//       cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
//               tf->trapno, cpuid(), tf->eip, rcr2());
//       panic("trap");
//     }
//     // In user space, assume process misbehaved.
//     cprintf("pid %d %s: trap %d err %d on cpu %d "
//             "eip 0x%x addr 0x%x--kill proc\n",
//             myproc()->pid, myproc()->name, tf->trapno,
//             tf->err, cpuid(), tf->eip, rcr2());
//     myproc()->killed = 1;
//   }

//   if(myproc() && myproc()->suspended && myproc()->pid > 2 && (tf->cs&3) ==  DPL_USER){
//      yield();
//      return ;
//   }

//   // Force process exit if it has been killed and is in user space.
//   // (If it is still executing in the kernel, let it keep running
//   // until it gets to the regular system call return.)
//   if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
//     exit();






//   if(myproc() && myproc()->pending_signal == SIGCUSTOM && myproc()->signal_handler) {
//     myproc()->pending_signal = 0; // clear pending signal
//         // Save current instruction pointer (eip)
//     myproc()->backup_eip = myproc()->tf->eip;
//     // Set instruction pointer to signal handler
//     myproc()->tf->eip = (uint)myproc()->signal_handler;
// }



// //   if (myproc() && myproc()->signal_handler) {
// //     myproc()->tf->eip = (uint)myproc()->signal_handler;
// // }


//   // Force process to give up CPU on clock tick.
//   // If interrupts were on while locks held, would need to check nlock.
//   if(myproc() && myproc()->state == RUNNING &&
//      tf->trapno == T_IRQ0+IRQ_TIMER)
//     yield();

// }