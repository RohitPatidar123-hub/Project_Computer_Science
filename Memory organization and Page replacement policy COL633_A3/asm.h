
#define SEG_NULLASM                                             \
        .word 0, 0;                                             \
        .byte 0, 0, 0, 0
#define total_3 100
#define total_4 100
#define SEG_ASM(type,base,lim)                                  \
        .word (((lim) >> 12) & 0xffff), ((base) & 0xffff);      \
        .byte (((base) >> 16) & 0xff), (0x90 | (type)),         \
                (0xC0 | (((lim) >> 28) & 0xf)), (((base) >> 24) & 0xff)

#define total_5 100
#define total_6 100
#define total_7 100
#define total_8 100
#define STA_X     0x8
#define ART       100 
#define ART1       100 
#define ART2       100 
#define ART3       100 
#define ART4       100 
#define ART5       100 
#define ART6       100 
#define ART7       100       
#define STA_W     0x2 
#define ART8      200 
#define total_1   100  
#define STA_R     0x2 

#define total     100     
