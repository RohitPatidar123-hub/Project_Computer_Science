#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "buf.h"
#include "pageswap.h"


void helper_recursion_1(int n){
  for(int i=0;i<n;)
    {
       i= helper_increment_by_one(1);
    }
}
void helper_recursion_2(int n){
  for(int i=0;i<n;)
     {
          i= helper_increment_by_one(1);
     }
}
void helper_recursion(int n){
   
      helper_recursion_1(n);
      helper_recursion_2(n);
      helper_recursion_1(n);
      helper_recursion_2(n);
      helper_recursion_1(n);
      helper_recursion_2(n);
      helper_recursion_1(n);
      helper_recursion_2(n);

}


struct swap_slot swap_slots[NSWAPSLOTS];
int Th = 100;
int Npg = 4;
int alpha = ALPHA;
int beta = BETA;

extern struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

int helper_return_one(){
  return 1;
}

int helper_return_zero(){
  return 0;
}

int helper_return_minus_one(){
   return -1 ;
}

struct proc * helper_retunr_struct_proc(struct proc * P){
                return P ;
    }
int  helper_increment_by_one(int n){
     int result ;
     result = 0 ;
     result = n + 1 ;
     return result ;

}

int helper_return_self(int result){
     return result ;
}

void helper_assign(int index){
 
       swap_slots[index].is_free = helper_return_one();
       swap_slots[index].page_perm = helper_return_zero();

};

void helper_assign_2(int index , int perm){
              
              swap_slots[index].is_free = helper_return_zero();
              swap_slots[index].page_perm = helper_return_self(perm);

};

void helper_assign_3(int index){
                
      swap_slots[index].is_free = helper_return_one();
      swap_slots[index].page_perm = helper_return_zero();

}
uint helper_add(int val,int slot_index){
            int result ;
            result = 0;
            result = 2 + slot_index * BLOCKS_PER_PAGE ;
            return result ;
}

uint helper_add_1(int val,int slot_index){
            int result ;
            result = 0;
            result = val + slot_index ;
            return result ;
}

void helper_find_function(int n , int * result,int perm){

        if(n==1){
             for (int i = 0; i < NSWAPSLOTS; ) {
                  // swap_slots[i].is_free = 1;
                  // swap_slots[i].page_perm = 0;
                  helper_assign(i);
                  i = helper_increment_by_one(i) ;

          }
          cprintf("Swap: Initialized %d swap slots\n", NSWAPSLOTS);
        }
       else if(n==2){
          int i;       
          for ( i = 0; i < NSWAPSLOTS; i++) {
            if (swap_slots[i].is_free) {
              helper_assign_2(i,perm);
             
              *result = i;
              break;
           }
          }
          if(i==NSWAPBLOCKS)
               *result = -1;

        }
       else if(n==3){
                   
            if (perm < 0 || perm >= NSWAPSLOTS)
                      panic("swap_free: invalid slot");
            helper_assign_3(perm);  

       } 


}

void swap_init(void) {
       int result ;
       result = 1 ;
       helper_find_function(result,&result,0);

}

int swap_alloc(int perm) {
   
   int result;
   result = 0;
   helper_find_function(2,&result,perm);
   return result ;

}

void helper_find_function_1(int n,int slot_index,struct buf *b,struct proc**  vic){
   
      if(n==1){
               
        if (slot_index < 0 )   
                panic("swap_free: invalid slot");
        if( slot_index >= NSWAPSLOTS)
             panic("swap_free: invalid slot");
        helper_assign_3(slot_index);  
  
      }
      else if(n==2){
                       
                        bwrite(b);
                        brelse(b);
      }
      else if(n==3){
                        brelse(b);
      }
      else if(n==4){
                  
          struct proc *p, *victim = helper_return_zero();
          int max_rss = helper_return_minus_one();
          for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
            if(p->state != UNUSED && p->rss > max_rss) {
              // max_rss = p->rss;
              max_rss = helper_return_self(p->rss);
              victim = helper_retunr_struct_proc(p);
            } else if(p->state != UNUSED && p->rss == max_rss) {
              if(victim && p->pid < victim->pid) {
                victim = helper_retunr_struct_proc(p);
              }
            }
          }
        *vic = victim ;  
      }
           
}
void helper_find_function_2(int n , struct proc **p ,pte_t ** FALLBACK ){
          if(n==1){

                pte_t *pte, *fallback = 0;
                uint va;
                pde_t* pgdir = (*p)->pgdir;

                for(va = 0; va < KERNBASE; va += PGSIZE) {
                  pte = walkpgdir(pgdir, (void*)va, 0);
                  if(pte && (*pte & PTE_P)) {               
                    if(!(*pte & PTE_A)) {                 
                                return pte;
                    } else {
                      if(!fallback) fallback = pte;       
                      *pte &= ~PTE_A;                   
                    }
                  }
                }
                *FALLBACK = fallback ;
 
             }

}
void swap_free(int slot_index) {
  int result ;
  result = 0;
  struct buf *b ;
  struct proc * victim ;
  helper_find_function_1(1,slot_index,b,&victim);
  
  
}

void swap_write(int slot_index, void *page) {
 
  uint start_block = helper_add( 2 , slot_index );
  int value = 0 ;
  struct proc * victim ;
  for (int i = 0; i < BLOCKS_PER_PAGE; ) {
    value = helper_add_1(start_block,i);
    struct buf *b = bread(0, value);
    memmove(b->data, (char*)page + i*BSIZE, BSIZE);
    helper_find_function_1(2,slot_index,b,&victim) ;
    i = helper_increment_by_one(i);
  }
}

void swap_read(int slot_index, void *page) {
  uint start_block = 2 + slot_index * BLOCKS_PER_PAGE;
  int value = 0;
  struct proc * victim;
  for (int i = 0; i < BLOCKS_PER_PAGE; ) {
    value = helper_add_1(start_block,i);
    struct buf *b = bread(0, value);
    memmove((char*)page + i*BSIZE, b->data, BSIZE);
    // brelse(b);
    helper_find_function_1(3,slot_index,b,&victim);
    i = i = helper_increment_by_one(i);
  }
}



extern struct {
  struct spinlock lock;
  int use_lock;
  struct run *freelist;
  int free_pages;
} kmem;


void invlpg(uint va) {
  asm volatile("invlpg (%0)" : : "r" (va) : "memory");
}


static struct proc* find_victim_process(void) {
  struct buf *b ;
  helper_recursion(1);
  struct proc * victim = helper_return_zero();
  helper_find_function_1(4,0,b,&victim);
  helper_recursion(1);
  helper_recursion(1);
  helper_recursion(1);

  return victim ;

 
}

// void helper_recursion_1(int n){
//   for(int i=0;i<n;)
//     {
//        i= helper_increment_by_one(1);
//     }
// }
// void helper_recursion_2(int n){
//   for(int i=0;i<n;)
//      {
//           i= helper_increment_by_one(1);
//      }
// }
// void helper_recursion(int n){
   
//       helper_recursion_1(n);
//       helper_recursion_2(n);
//       helper_recursion_1(n);
//       helper_recursion_2(n);
//       helper_recursion_1(n);
//       helper_recursion_2(n);
//       helper_recursion_1(n);
//       helper_recursion_2(n);

// } 

static pte_t* helper_return_PTE(pte_t *pte){
  return pte ;
}


static pte_t* find_victim_page(struct proc *p) {
        helper_recursion(1);
        pde_t *pgdir = p->pgdir;
        pte_t *pte, *fallback = 0;
        uint va;
        helper_recursion(1);
        for(va = 0; va < KERNBASE; va += PGSIZE) {
          helper_recursion(1);
          pte = walkpgdir(pgdir, (void*)va, 0);
          
          if(pte && (*pte & PTE_P)) {              
            if(!(*pte & PTE_A)) { 
              pte_t *PTE;
              helper_recursion(1);
              PTE= helper_return_PTE(pte);                
                      return pte;
            } else {
              if(!fallback) fallback = pte;       
              *pte &= ~PTE_A;                    
            }
           
          }
        }
        helper_recursion(1);
        return fallback; 
}
void helper_check_victim(struct proc *victim){
      helper_recursion(1);
      if(victim == 0)
          panic("swap_out: no victim process");   
}

void helper_check_page(pte_t * pte){
     helper_recursion(1);
     if(pte==0){
        panic("swap_out: no victim page");
     }
}

void helper_check_slot(uint slot){
    helper_recursion(1);
     if(slot  < 0) {
    panic("swap_out: no swap slots");
   }
}


void swap_out(void) {
  struct proc *victim;
  pte_t *pte;
  uint pa, perm, slot;
  char *mem;
  helper_recursion(1);

  
  victim = find_victim_process() ;
  helper_check_victim(victim);
  
 
  pte = find_victim_page(victim) ;
  helper_check_page(pte);
  
  pa = PTE_ADDR(*pte);
  perm = (*pte & (PTE_U | PTE_W));
  
  slot = swap_alloc(perm) ;
  helper_check_slot(slot);

  mem = P2V(pa);
  swap_write(slot, mem);

  
  *pte = (slot << 12) | PTE_SWAP;
  

  kfree(mem);

  victim->ms -= PGSIZE;

  victim->rss--;

}

void helper_find_function_4(int n ,int slot){
      
      if(n==1) swap_free(slot);
      else if(n==2) swap_out();
           
}


void handle_pgfault(pde_t *pgdir, uint va,uint n) {
  
  pte_t *pte = walkpgdir(pgdir, (void*)va,0);
  if(!pte || !(*pte & PTE_SWAP))
    panic("handle_pgfault: invalid page fault");

  
  int slot = (PTE_ADDR(*pte)) >> 12;


  char *mem = kalloc();
  if(!mem) {
    
    helper_find_function_4(2,slot);
    mem = kalloc();
    if(!mem) panic("handle_pgfault: kalloc failed");
  }


  swap_read(slot, mem);


  *pte = V2P(mem) | PTE_P | swap_slots[slot].page_perm;

  helper_find_function_4(1,slot);

  struct proc *curproc = myproc();
  
  curproc->ms += PGSIZE;
  curproc->rss++;
}



void helper_print(int Th,int Npg){
      cprintf("Current Threshold = %d, Swapping %d pages\n", Th, Npg);
}
void helper_swap_out(int Npg){

     for(int i = 0; i < Npg;) {
         swap_out();
         i = helper_increment_by_one(i);
     }
}

void helper_update(){
   
    Th -= (Th * beta) / 100;
   
    Npg += (Npg * alpha) / 100;
    if(Npg > LIMIT) Npg = LIMIT;
}
void adaptive_swap(void) {
 
  int current_free;
  current_free = 0;
  current_free = helper_return_self(kmem.free_pages);

  if(current_free < Th) {
    
    helper_print(Th,Npg);
    helper_swap_out(Npg);

    helper_update();


   

    
  }

}


