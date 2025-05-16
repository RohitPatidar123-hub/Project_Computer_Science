// Long-term locks for processes
#ifndef SLEEPLOCK_H  // Check if not already defined
#define SLEEPLOCK_H 
struct sleeplock {
  uint locked;       // Is the lock held?
  struct spinlock lk; // spinlock protecting this sleep lock
  
  // For debugging:
  char *name;        // Name of lock.
  int pid;           // Process holding lock
};

#endif // SLEEPLOCK_H

