// // Project: xv6
// #include "kbd.h"
// #include "types.h"
// #include "defs.h"
// #include "param.h"
// #include "traps.h"
// #include "spinlock.h"
// #include "fs.h"
// #include "file.h"
// #include "memlayout.h"
// #include "mmu.h"
// #include "proc.h"
// #include "x86.h"
// #include "sleeplock.h"







// int
// kbdgetc(void)
// {
//   static uint shift;
//   static uchar *charcode[4] = {
//     normalmap, shiftmap, ctlmap, ctlmap
//   };
//   uint st, data, c;

//   st = inb(KBSTATP);
//   if((st & KBS_DIB) == 0)
//     return -1;
//   data = inb(KBDATAP);

//   if(data == 0xE0){
//     shift |= E0ESC;
//     return 0;
//   } else if(data & 0x80){
//     // Key released
//     data = (shift & E0ESC ? data : data & 0x7F);
//     shift &= ~(shiftcode[data] | E0ESC);
//     return 0;
//   } else if(shift & E0ESC){
//     // Last character was an E0 escape; or with 0x80
//     data |= 0x80;
//     shift &= ~E0ESC;
//   }

//   shift |= shiftcode[data];
//   shift ^= togglecode[data];
//   c = charcode[shift & (CTL | SHIFT)][data];
//   if(shift & CAPSLOCK){
//     if('a' <= c && c <= 'z')
//       c += 'A' - 'a';
//     else if('A' <= c && c <= 'Z')
//       c += 'a' - 'A';
//   }
//   return c;
// }

// // void
// // kbdintr(void)
// // {
// //   consoleintr(kbdgetc);

// // }

// void kbdintr(void) {
//   uchar c;

 
//   //  acquire(&cons.lock);
//   c = kbdgetc();
//   if(c == 0){
//     //  release(&cons.lock);
//     return;
//   }

//   switch(c){
//         case 0x03: // Ctrl+C
//             cprintf("Ctrl -C is detected by xv6\n");
//             send_signal_to_all(SIGINT);
//             break;

//         case 0x02: // Ctrl+B
//             cprintf("Ctrl -B is detected by xv6\n");
//             send_signal_to_all(SIGBG);
     
//             break;

//         // case 0x1A: // Ctrl+Z
//         //     cprintf("Ctrl -Z is detected by xv6\n");
//         //     send_signal_to_all(SIGSTP);
//         //     break;

//         case 0x06: // Ctrl+F
//             cprintf("Ctrl -F is detected by xv6\n");
//             send_signal_to_all(SIGFG);
//             break;

//         case 0x07: // Ctrl+G
//             cprintf("Ctrl -G is detected by xv6\n");
//             send_signal_to_all(SIGCUSTOM);
//             break;

//         default:
//             consoleintr(kbdgetc);
//             break;
//     }
//   //  release(&cons.lock);
// }



// #include "types.h"
// #include "x86.h"
// #include "defs.h"
#include "kbd.h"
// #include "proc.h"
#include "types.h"
#include "defs.h"
#include "param.h"
#include "traps.h"
#include "spinlock.h"
#include "fs.h"
#include "file.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "sleeplock.h"

// extern struct {
//     struct spinlock lock;
//     int locking;
// } cons;

// #include "sleeplock.h
int
kbdgetc(void)
{
  static uint shift;
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}

void
kbdintr(void)
{
   consoleintr(kbdgetc);
}
