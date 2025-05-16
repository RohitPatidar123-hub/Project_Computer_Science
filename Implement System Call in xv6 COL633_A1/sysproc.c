#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "history.h"
#include "syscall.h"
#include "fs.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "file.h"






int
sys_chmod(void)
{
  char *path;
  int minor;
  struct inode *ip;
  CHMOD();
  // Fetch arguments: file path and mode
  if(argstr(0, &path) < 0 || argint(1, &minor) < 0)
    return -1;
  
  // Only allow 3-bit values (0 to 7)
  if(minor < 0 || minor > 7)
    return -1;

  begin_op();
  if((ip = namei(path)) == 0){
    end_op();
    return -1;
  }
  ilock(ip);

  // Update the permission bits stored in the minor field.
  ip->mode = (ip->mode & ~0b111) | (ip->mode & 0b111);  // Set 3-bit mode
  iupdate(ip);
  iunlockput(ip);
  end_op();
   CHMOD();
  return 0;
}




int sys_block(int syscall_id)
{ CHMOD();
  int id;
  if(argint(0, &id) < 0)
    return -1;

  // Ensure that the syscall id is valid.
  if(id < 0 || id >= MAX_SYSCALLS)
    return -1;

  // Do not allow critical system calls to be blocked.
  if(id == SYS_fork || id == SYS_exit)
    return -1;

  // Set the current process's blocked_syscalls flag.
  myproc()->blocked_syscalls[id] = 1;
  
  cprintf("syscall %d is now blocked\n", id);
  return 0;
}

int sys_unblock(int syscall_id)
{
  int id;
  if(argint(0, &id) < 0)
    return -1;

  if(id < 0 || id >= MAX_SYSCALLS)
    return -1;

  // Remove the block.
  myproc()->blocked_syscalls[id] = 0;
  cprintf("syscall %d is now unblocked\n",id);
  return 0;
}





int
sys_gethistory(void)
{
  CHMOD();
  char *ubuf;
  int size, i, nbytes;
  CHMOD();
  // We expect two arguments: a pointer to a user buffer and its size.
  if(argptr(0, &ubuf, sizeof(char*)) < 0)
    return -1;
  if(argint(1, &size) < 0)
    return -1;
  CHMOD();
  // Compute how many bytes are available in the history buffer.
  nbytes = nhistory * sizeof(struct history_entry);
  if(nbytes > size)
    nbytes = size;
  
  // Copy out the data to user space.
  if(copyout(myproc()->pgdir, (uint)ubuf, (char*)history_list, nbytes) < 0)
    return -1;
  
  // Return the number of history entries copied.
  return nbytes / sizeof(struct history_entry);
}

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
