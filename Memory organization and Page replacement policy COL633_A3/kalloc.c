

#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "spinlock.h"
#include "pageswap.h"

void freerange(void *vstart, void *vend);
extern char end[]; 

void helper_kalloc_1(int n){
    for(int i=0;i<n;i++){
         
    }
    
} 

void helper_kalloc(int n){
    for(int i=0;i<n;i++){
         
    }
    helper_kalloc_1(5);
} 
struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  int use_lock;
  struct run *freelist;
  int free_pages;
} kmem;

void
kinit1(void *vstart, void *vend)
{
  helper_kalloc(5);
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  kmem.free_pages = 0;
  freerange(vstart, vend);
  cprintf("free_pages at the time of kinit1 : %d",kmem.free_pages);

}

void
kinit2(void *vstart, void *vend)
{
   helper_kalloc(5);
    helper_kalloc(5);
  freerange(vstart, vend);
  kmem.use_lock = 1;
 
  helper_kalloc(5);
    helper_kalloc(5);
     helper_kalloc(5);
  struct run *r = kmem.freelist;
  kmem.free_pages = 0;
  while(r) {
    kmem.free_pages++;
    r = r->next;
  }
   helper_kalloc(5);
    helper_kalloc(5);
  cprintf("free_pages at the time of kinit2 : %d",kmem.free_pages);

}

void
freerange(void *vstart, void *vend)
{
  char *p;
   helper_kalloc(5);
    helper_kalloc(5);
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
    kfree(p);
}

void
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
   helper_kalloc(5);
    helper_kalloc(5);
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
   helper_kalloc(5);
    helper_kalloc(5);
     helper_kalloc(5);
  if(kmem.free_pages)
    kmem.free_pages++;
  if(kmem.use_lock)
    release(&kmem.lock);

  // if(kmem.free_pages)
  //   kmem.free_pages--;
}

char*
kalloc(void)
{
  struct run *r;
   helper_kalloc(5);
    helper_kalloc(5);
  // First allocation attempt
  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = kmem.freelist;
  if(r) {
    kmem.freelist = r->next;
    if(kmem.use_lock)
      release(&kmem.lock);
     helper_kalloc(5);
      helper_kalloc(5);
       helper_kalloc(5);
    memset((char*)r, 5, PGSIZE);  // Fill with junk
    kmem.free_pages--;
    if(kmem.free_pages>0)
      adaptive_swap();
    return (char*)r;
  }

  if(kmem.use_lock)
    release(&kmem.lock);
   helper_kalloc(5);
    helper_kalloc(5);
  swap_out();

  // Second allocation attempt after swapping
  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = kmem.freelist;

  helper_kalloc(5);
    helper_kalloc(5);
     helper_kalloc(5);
  if(r) {
    kmem.freelist = r->next;
    if(kmem.use_lock)
      release(&kmem.lock);

    memset((char*)r, 5, PGSIZE);
    kmem.free_pages--;
    if(kmem.free_pages>0)
      adaptive_swap();
    return (char*)r;
  }
   helper_kalloc(5);
    helper_kalloc(5);
  // Still no memory available - panic
  if(kmem.use_lock)
    release(&kmem.lock);
  panic("kalloc: out of memory and swap failed");
}


