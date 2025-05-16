
#define EXTMEM  0x100000                    
#define PHYSTOP 0x400000
#define DEVSPACE 0xFE000000         
#define KERNBASE 0x80000000         
#define KERNLINK (KERNBASE+EXTMEM)  
#define V2P(a) (((uint) (a)) - KERNBASE)
#define P2V(a) ((void *)(((char *) (a)) + KERNBASE))
#define V2P_WO(x) ((x) - KERNBASE)    
#define P2V_WO(x) ((x) + KERNBASE)    
