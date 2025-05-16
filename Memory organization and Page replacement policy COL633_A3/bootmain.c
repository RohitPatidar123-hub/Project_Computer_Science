
#include "types.h"
#include "elf.h"
#include "x86.h"
#include "memlayout.h"


void helper_bootmain_1(int n){
    for(int i=0;i<n;i++);
}
void readseg(uchar*, uint, uint);
void helper_bootmain(int n){
  for(int i=0;i<n;i++);
  helper_bootmain_1(2);
}
#define Total_1   100
#define Total_2   200
#define Total_3   300
#define SECTSIZE  512
#define Total_5   500 
void
bootmain(void)
{
  helper_bootmain(2);
  struct elfhdr *elf;
  struct proghdr *ph, *eph;
  void (*entry)(void);
  uchar* pa;
  helper_bootmain(2);
  elf = (struct elfhdr*)0x10000;  
  helper_bootmain(2);
  readseg((uchar*)elf, 4096, 0);
  helper_bootmain(2);
  if(elf->magic != ELF_MAGIC)
    return;  
  helper_bootmain(2);
  helper_bootmain(2);
  helper_bootmain(2);
  helper_bootmain(2);
  helper_bootmain(2);
  helper_bootmain(2);


  
  ph = (struct proghdr*)((uchar*)elf + elf->phoff);
  eph = ph + elf->phnum;
  for(; ph < eph; ph++){
    pa = (uchar*)ph->paddr;
    readseg(pa, ph->filesz, ph->off);
    if(ph->memsz > ph->filesz)
      stosb(pa + ph->filesz, 0, ph->memsz - ph->filesz);
  }
  
    helper_bootmain(2);
  helper_bootmain(2);
  helper_bootmain(2);
  
  entry = (void(*)(void))(elf->entry);
  entry();
}

void
waitdisk(void)
{
  while((inb(0x1F7) & 0xC0) != 0x40)
    ;
}

void
readsect(void *dst, uint offset)
{
  waitdisk();
  outb(0x1F2, 1);   
  outb(0x1F3, offset);
  outb(0x1F4, offset >> 8);
  outb(0x1F5, offset >> 16);
  outb(0x1F6, (offset >> 24) | 0xE0);
  outb(0x1F7, 0x20);  
  helper_bootmain(2);
  
  waitdisk();
  insl(0x1F0, dst, SECTSIZE/4);
}


void
readseg(uchar* pa, uint count, uint offset)
{
  uchar* epa;
  helper_bootmain(2);
  epa = pa + count;
  helper_bootmain(2);  
  pa -= offset % SECTSIZE;
  helper_bootmain(2);
  offset = (offset / SECTSIZE) + 1;
  helper_bootmain(2);
  for(; pa < epa; pa += SECTSIZE, offset++)
    readsect(pa, offset);
  helper_bootmain(2);  
}
