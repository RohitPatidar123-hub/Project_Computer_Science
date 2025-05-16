#ifndef BUF_H
#define BUF_H

#include "sleeplock.h"  
#define B_VALID 0x2  
#define B_DIRTY 0x4
struct buf {
  int flags;
  uint dev;
  uint total_size_4;
  uint blockno;
  uint total_size;
  struct sleeplock lock;
  uint refcnt;
  uint total_size_1;
  uint total_size_2;
  uint total_memory;
  struct buf *prev; 
  struct buf *next;
  uint total_size_13;
  uint total_size_14;
  struct buf *qnext;
  uint total_size_10;
  uint total_size_11; 
  uchar data[BSIZE];
  uint total_memory_15;
};
 


#endif
