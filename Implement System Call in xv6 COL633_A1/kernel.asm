
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 92 11 80       	mov    $0x801192d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 a0 30 10 80       	mov    $0x801030a0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 00 76 10 80       	push   $0x80107600
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 d5 44 00 00       	call   80104530 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 07 76 10 80       	push   $0x80107607
80100097:	50                   	push   %eax
80100098:	e8 63 43 00 00       	call   80104400 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave
801000c2:	c3                   	ret
801000c3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801000ca:	00 
801000cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 37 46 00 00       	call   80104720 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 59 45 00 00       	call   801046c0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ce 42 00 00       	call   80104440 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 af 21 00 00       	call   80102340 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 0e 76 10 80       	push   $0x8010760e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 1d 43 00 00       	call   801044e0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave
  iderw(b);
801001d4:	e9 67 21 00 00       	jmp    80102340 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 1f 76 10 80       	push   $0x8010761f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801001ed:	00 
801001ee:	66 90                	xchg   %ax,%ax

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 dc 42 00 00       	call   801044e0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 8c 42 00 00       	call   801044a0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 00 45 00 00       	call   80104720 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2c                	jne    8010025c <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 53 54             	mov    0x54(%ebx),%edx
80100233:	8b 43 50             	mov    0x50(%ebx),%eax
80100236:	89 42 50             	mov    %eax,0x50(%edx)
    b->prev->next = b->next;
80100239:	8b 53 54             	mov    0x54(%ebx),%edx
8010023c:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
8010023f:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100244:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024b:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
8010024e:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100253:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100256:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025c:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100263:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100266:	5b                   	pop    %ebx
80100267:	5e                   	pop    %esi
80100268:	5d                   	pop    %ebp
  release(&bcache.lock);
80100269:	e9 52 44 00 00       	jmp    801046c0 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 26 76 10 80       	push   $0x80107626
80100276:	e8 05 01 00 00       	call   80100380 <panic>
8010027b:	66 90                	xchg   %ax,%ax
8010027d:	66 90                	xchg   %ax,%ax
8010027f:	90                   	nop

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 37 16 00 00       	call   801018d0 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 7b 44 00 00       	call   80104720 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 9c 00 00 00    	jle    8010034c <consoleread+0xcc>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 61                	jmp    80100320 <consoleread+0xa0>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 be 3e 00 00       	call   80104190 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 3e                	jne    80100320 <consoleread+0xa0>
      if(myproc()->killed){
801002e2:	e8 f9 36 00 00       	call   801039e0 <myproc>
801002e7:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
801002ed:	85 c9                	test   %ecx,%ecx
801002ef:	74 cf                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002f1:	83 ec 0c             	sub    $0xc,%esp
801002f4:	68 20 ff 10 80       	push   $0x8010ff20
801002f9:	e8 c2 43 00 00       	call   801046c0 <release>
        ilock(ip);
801002fe:	5a                   	pop    %edx
801002ff:	ff 75 08             	push   0x8(%ebp)
80100302:	e8 e9 14 00 00       	call   801017f0 <ilock>
        return -1;
80100307:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010030a:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100312:	5b                   	pop    %ebx
80100313:	5e                   	pop    %esi
80100314:	5f                   	pop    %edi
80100315:	5d                   	pop    %ebp
80100316:	c3                   	ret
80100317:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010031e:	00 
8010031f:	90                   	nop
    c = input.buf[input.r++ % INPUT_BUF];
80100320:	8d 50 01             	lea    0x1(%eax),%edx
80100323:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100329:	89 c2                	mov    %eax,%edx
8010032b:	83 e2 7f             	and    $0x7f,%edx
8010032e:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
    if(c == C('D')){  // EOF
80100335:	80 f9 04             	cmp    $0x4,%cl
80100338:	74 37                	je     80100371 <consoleread+0xf1>
    *dst++ = c;
8010033a:	83 c6 01             	add    $0x1,%esi
    --n;
8010033d:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100340:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
80100343:	83 f9 0a             	cmp    $0xa,%ecx
80100346:	0f 85 5c ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
8010034c:	83 ec 0c             	sub    $0xc,%esp
8010034f:	68 20 ff 10 80       	push   $0x8010ff20
80100354:	e8 67 43 00 00       	call   801046c0 <release>
  ilock(ip);
80100359:	58                   	pop    %eax
8010035a:	ff 75 08             	push   0x8(%ebp)
8010035d:	e8 8e 14 00 00       	call   801017f0 <ilock>
  return target - n;
80100362:	89 f8                	mov    %edi,%eax
80100364:	83 c4 10             	add    $0x10,%esp
}
80100367:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010036a:	29 d8                	sub    %ebx,%eax
}
8010036c:	5b                   	pop    %ebx
8010036d:	5e                   	pop    %esi
8010036e:	5f                   	pop    %edi
8010036f:	5d                   	pop    %ebp
80100370:	c3                   	ret
      if(n < target){
80100371:	39 fb                	cmp    %edi,%ebx
80100373:	73 d7                	jae    8010034c <consoleread+0xcc>
        input.r--;
80100375:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
8010037a:	eb d0                	jmp    8010034c <consoleread+0xcc>
8010037c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli
  cons.locking = 0;
80100389:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 a2 25 00 00       	call   80102940 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 2d 76 10 80       	push   $0x8010762d
801003a7:	e8 04 03 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 fb 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 47 7b 10 80 	movl   $0x80107b47,(%esp)
801003bc:	e8 ef 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 83 41 00 00       	call   80104550 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 41 76 10 80       	push   $0x80107641
801003dd:	e8 ce 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801003fc:	00 
801003fd:	8d 76 00             	lea    0x0(%esi),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
80100409:	3d 00 01 00 00       	cmp    $0x100,%eax
8010040e:	0f 84 cc 00 00 00    	je     801004e0 <consputc.part.0+0xe0>
    uartputc(c);
80100414:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100417:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010041c:	89 c3                	mov    %eax,%ebx
8010041e:	50                   	push   %eax
8010041f:	e8 1c 5d 00 00       	call   80106140 <uartputc>
80100424:	b8 0e 00 00 00       	mov    $0xe,%eax
80100429:	89 fa                	mov    %edi,%edx
8010042b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042c:	be d5 03 00 00       	mov    $0x3d5,%esi
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100434:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100437:	89 fa                	mov    %edi,%edx
80100439:	b8 0f 00 00 00       	mov    $0xf,%eax
8010043e:	c1 e1 08             	shl    $0x8,%ecx
80100441:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100442:	89 f2                	mov    %esi,%edx
80100444:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100445:	0f b6 c0             	movzbl %al,%eax
  if(c == '\n')
80100448:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT+1);
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	75 76                	jne    801004c8 <consputc.part.0+0xc8>
    pos += 80 - pos%80;
80100452:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100457:	f7 e2                	mul    %edx
80100459:	c1 ea 06             	shr    $0x6,%edx
8010045c:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010045f:	c1 e0 04             	shl    $0x4,%eax
80100462:	8d 70 50             	lea    0x50(%eax),%esi
  if(pos < 0 || pos > 25*80)
80100465:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
8010046b:	0f 8f 2f 01 00 00    	jg     801005a0 <consputc.part.0+0x1a0>
  if((pos/80) >= 24){  // Scroll up.
80100471:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100477:	0f 8f c3 00 00 00    	jg     80100540 <consputc.part.0+0x140>
  outb(CRTPORT+1, pos>>8);
8010047d:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
8010047f:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100486:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100489:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010048c:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100491:	b8 0e 00 00 00       	mov    $0xe,%eax
80100496:	89 da                	mov    %ebx,%edx
80100498:	ee                   	out    %al,(%dx)
80100499:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010049e:	89 f8                	mov    %edi,%eax
801004a0:	89 ca                	mov    %ecx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b8 0f 00 00 00       	mov    $0xf,%eax
801004a8:	89 da                	mov    %ebx,%edx
801004aa:	ee                   	out    %al,(%dx)
801004ab:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004af:	89 ca                	mov    %ecx,%edx
801004b1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004b2:	b8 20 07 00 00       	mov    $0x720,%eax
801004b7:	66 89 06             	mov    %ax,(%esi)
}
801004ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004bd:	5b                   	pop    %ebx
801004be:	5e                   	pop    %esi
801004bf:	5f                   	pop    %edi
801004c0:	5d                   	pop    %ebp
801004c1:	c3                   	ret
801004c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801004c8:	0f b6 db             	movzbl %bl,%ebx
801004cb:	8d 70 01             	lea    0x1(%eax),%esi
801004ce:	80 cf 07             	or     $0x7,%bh
801004d1:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
801004d8:	80 
801004d9:	eb 8a                	jmp    80100465 <consputc.part.0+0x65>
801004db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e0:	83 ec 0c             	sub    $0xc,%esp
801004e3:	be d4 03 00 00       	mov    $0x3d4,%esi
801004e8:	6a 08                	push   $0x8
801004ea:	e8 51 5c 00 00       	call   80106140 <uartputc>
801004ef:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f6:	e8 45 5c 00 00       	call   80106140 <uartputc>
801004fb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100502:	e8 39 5c 00 00       	call   80106140 <uartputc>
80100507:	b8 0e 00 00 00       	mov    $0xe,%eax
8010050c:	89 f2                	mov    %esi,%edx
8010050e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010050f:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100514:	89 da                	mov    %ebx,%edx
80100516:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100517:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010051a:	89 f2                	mov    %esi,%edx
8010051c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100521:	c1 e1 08             	shl    $0x8,%ecx
80100524:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100525:	89 da                	mov    %ebx,%edx
80100527:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100528:	0f b6 f0             	movzbl %al,%esi
    if(pos > 0) --pos;
8010052b:	83 c4 10             	add    $0x10,%esp
8010052e:	09 ce                	or     %ecx,%esi
80100530:	74 5e                	je     80100590 <consputc.part.0+0x190>
80100532:	83 ee 01             	sub    $0x1,%esi
80100535:	e9 2b ff ff ff       	jmp    80100465 <consputc.part.0+0x65>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 4a 43 00 00       	call   801048b0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 a5 42 00 00       	call   80104820 <memset>
  outb(CRTPORT+1, pos);
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 06 ff ff ff       	jmp    8010048c <consputc.part.0+0x8c>
80100586:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010058d:	00 
8010058e:	66 90                	xchg   %ax,%ax
80100590:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
80100594:	be 00 80 0b 80       	mov    $0x800b8000,%esi
80100599:	31 ff                	xor    %edi,%edi
8010059b:	e9 ec fe ff ff       	jmp    8010048c <consputc.part.0+0x8c>
    panic("pos under/overflow");
801005a0:	83 ec 0c             	sub    $0xc,%esp
801005a3:	68 45 76 10 80       	push   $0x80107645
801005a8:	e8 d3 fd ff ff       	call   80100380 <panic>
801005ad:	8d 76 00             	lea    0x0(%esi),%esi

801005b0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005b0:	55                   	push   %ebp
801005b1:	89 e5                	mov    %esp,%ebp
801005b3:	57                   	push   %edi
801005b4:	56                   	push   %esi
801005b5:	53                   	push   %ebx
801005b6:	83 ec 18             	sub    $0x18,%esp
801005b9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005bc:	ff 75 08             	push   0x8(%ebp)
801005bf:	e8 0c 13 00 00       	call   801018d0 <iunlock>
  acquire(&cons.lock);
801005c4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005cb:	e8 50 41 00 00       	call   80104720 <acquire>
  for(i = 0; i < n; i++)
801005d0:	83 c4 10             	add    $0x10,%esp
801005d3:	85 f6                	test   %esi,%esi
801005d5:	7e 25                	jle    801005fc <consolewrite+0x4c>
801005d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005da:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005dd:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i] & 0xff);
801005e3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005e6:	85 d2                	test   %edx,%edx
801005e8:	74 06                	je     801005f0 <consolewrite+0x40>
  asm volatile("cli");
801005ea:	fa                   	cli
    for(;;)
801005eb:	eb fe                	jmp    801005eb <consolewrite+0x3b>
801005ed:	8d 76 00             	lea    0x0(%esi),%esi
801005f0:	e8 0b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005f5:	83 c3 01             	add    $0x1,%ebx
801005f8:	39 fb                	cmp    %edi,%ebx
801005fa:	75 e1                	jne    801005dd <consolewrite+0x2d>
  release(&cons.lock);
801005fc:	83 ec 0c             	sub    $0xc,%esp
801005ff:	68 20 ff 10 80       	push   $0x8010ff20
80100604:	e8 b7 40 00 00       	call   801046c0 <release>
  ilock(ip);
80100609:	58                   	pop    %eax
8010060a:	ff 75 08             	push   0x8(%ebp)
8010060d:	e8 de 11 00 00       	call   801017f0 <ilock>

  return n;
}
80100612:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100615:	89 f0                	mov    %esi,%eax
80100617:	5b                   	pop    %ebx
80100618:	5e                   	pop    %esi
80100619:	5f                   	pop    %edi
8010061a:	5d                   	pop    %ebp
8010061b:	c3                   	ret
8010061c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100620 <printint>:
{
80100620:	55                   	push   %ebp
80100621:	89 e5                	mov    %esp,%ebp
80100623:	57                   	push   %edi
80100624:	56                   	push   %esi
80100625:	53                   	push   %ebx
80100626:	89 d3                	mov    %edx,%ebx
80100628:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010062b:	85 c0                	test   %eax,%eax
8010062d:	79 05                	jns    80100634 <printint+0x14>
8010062f:	83 e1 01             	and    $0x1,%ecx
80100632:	75 64                	jne    80100698 <printint+0x78>
    x = xx;
80100634:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
8010063b:	89 c1                	mov    %eax,%ecx
  i = 0;
8010063d:	31 f6                	xor    %esi,%esi
8010063f:	90                   	nop
    buf[i++] = digits[x % base];
80100640:	89 c8                	mov    %ecx,%eax
80100642:	31 d2                	xor    %edx,%edx
80100644:	89 f7                	mov    %esi,%edi
80100646:	f7 f3                	div    %ebx
80100648:	8d 76 01             	lea    0x1(%esi),%esi
8010064b:	0f b6 92 98 7b 10 80 	movzbl -0x7fef8468(%edx),%edx
80100652:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
80100656:	89 ca                	mov    %ecx,%edx
80100658:	89 c1                	mov    %eax,%ecx
8010065a:	39 da                	cmp    %ebx,%edx
8010065c:	73 e2                	jae    80100640 <printint+0x20>
  if(sign)
8010065e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80100661:	85 c9                	test   %ecx,%ecx
80100663:	74 07                	je     8010066c <printint+0x4c>
    buf[i++] = '-';
80100665:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
  while(--i >= 0)
8010066a:	89 f7                	mov    %esi,%edi
8010066c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
8010066f:	01 df                	add    %ebx,%edi
  if(panicked){
80100671:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i]);
80100677:	0f be 07             	movsbl (%edi),%eax
  if(panicked){
8010067a:	85 d2                	test   %edx,%edx
8010067c:	74 0a                	je     80100688 <printint+0x68>
8010067e:	fa                   	cli
    for(;;)
8010067f:	eb fe                	jmp    8010067f <printint+0x5f>
80100681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100688:	e8 73 fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
8010068d:	8d 47 ff             	lea    -0x1(%edi),%eax
80100690:	39 df                	cmp    %ebx,%edi
80100692:	74 11                	je     801006a5 <printint+0x85>
80100694:	89 c7                	mov    %eax,%edi
80100696:	eb d9                	jmp    80100671 <printint+0x51>
    x = -xx;
80100698:	f7 d8                	neg    %eax
  if(sign && (sign = xx < 0))
8010069a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    x = -xx;
801006a1:	89 c1                	mov    %eax,%ecx
801006a3:	eb 98                	jmp    8010063d <printint+0x1d>
}
801006a5:	83 c4 2c             	add    $0x2c,%esp
801006a8:	5b                   	pop    %ebx
801006a9:	5e                   	pop    %esi
801006aa:	5f                   	pop    %edi
801006ab:	5d                   	pop    %ebp
801006ac:	c3                   	ret
801006ad:	8d 76 00             	lea    0x0(%esi),%esi

801006b0 <cprintf>:
{
801006b0:	55                   	push   %ebp
801006b1:	89 e5                	mov    %esp,%ebp
801006b3:	57                   	push   %edi
801006b4:	56                   	push   %esi
801006b5:	53                   	push   %ebx
801006b6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006b9:	8b 3d 54 ff 10 80    	mov    0x8010ff54,%edi
  if (fmt == 0)
801006bf:	8b 75 08             	mov    0x8(%ebp),%esi
  if(locking)
801006c2:	85 ff                	test   %edi,%edi
801006c4:	0f 85 06 01 00 00    	jne    801007d0 <cprintf+0x120>
  if (fmt == 0)
801006ca:	85 f6                	test   %esi,%esi
801006cc:	0f 84 b7 01 00 00    	je     80100889 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d2:	0f b6 06             	movzbl (%esi),%eax
801006d5:	85 c0                	test   %eax,%eax
801006d7:	74 5f                	je     80100738 <cprintf+0x88>
  argp = (uint*)(void*)(&fmt + 1);
801006d9:	8d 55 0c             	lea    0xc(%ebp),%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006dc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801006df:	31 db                	xor    %ebx,%ebx
801006e1:	89 d7                	mov    %edx,%edi
    if(c != '%'){
801006e3:	83 f8 25             	cmp    $0x25,%eax
801006e6:	75 58                	jne    80100740 <cprintf+0x90>
    c = fmt[++i] & 0xff;
801006e8:	83 c3 01             	add    $0x1,%ebx
801006eb:	0f b6 0c 1e          	movzbl (%esi,%ebx,1),%ecx
    if(c == 0)
801006ef:	85 c9                	test   %ecx,%ecx
801006f1:	74 3a                	je     8010072d <cprintf+0x7d>
    switch(c){
801006f3:	83 f9 70             	cmp    $0x70,%ecx
801006f6:	0f 84 b4 00 00 00    	je     801007b0 <cprintf+0x100>
801006fc:	7f 72                	jg     80100770 <cprintf+0xc0>
801006fe:	83 f9 25             	cmp    $0x25,%ecx
80100701:	74 4d                	je     80100750 <cprintf+0xa0>
80100703:	83 f9 64             	cmp    $0x64,%ecx
80100706:	75 76                	jne    8010077e <cprintf+0xce>
      printint(*argp++, 10, 1);
80100708:	8d 47 04             	lea    0x4(%edi),%eax
8010070b:	b9 01 00 00 00       	mov    $0x1,%ecx
80100710:	ba 0a 00 00 00       	mov    $0xa,%edx
80100715:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100718:	8b 07                	mov    (%edi),%eax
8010071a:	e8 01 ff ff ff       	call   80100620 <printint>
8010071f:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100722:	83 c3 01             	add    $0x1,%ebx
80100725:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	75 b6                	jne    801006e3 <cprintf+0x33>
8010072d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(locking)
80100730:	85 ff                	test   %edi,%edi
80100732:	0f 85 bb 00 00 00    	jne    801007f3 <cprintf+0x143>
}
80100738:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010073b:	5b                   	pop    %ebx
8010073c:	5e                   	pop    %esi
8010073d:	5f                   	pop    %edi
8010073e:	5d                   	pop    %ebp
8010073f:	c3                   	ret
  if(panicked){
80100740:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
80100746:	85 c9                	test   %ecx,%ecx
80100748:	74 19                	je     80100763 <cprintf+0xb3>
8010074a:	fa                   	cli
    for(;;)
8010074b:	eb fe                	jmp    8010074b <cprintf+0x9b>
8010074d:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100750:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
80100756:	85 c9                	test   %ecx,%ecx
80100758:	0f 85 f2 00 00 00    	jne    80100850 <cprintf+0x1a0>
8010075e:	b8 25 00 00 00       	mov    $0x25,%eax
80100763:	e8 98 fc ff ff       	call   80100400 <consputc.part.0>
      break;
80100768:	eb b8                	jmp    80100722 <cprintf+0x72>
8010076a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
80100770:	83 f9 73             	cmp    $0x73,%ecx
80100773:	0f 84 8f 00 00 00    	je     80100808 <cprintf+0x158>
80100779:	83 f9 78             	cmp    $0x78,%ecx
8010077c:	74 32                	je     801007b0 <cprintf+0x100>
  if(panicked){
8010077e:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100784:	85 d2                	test   %edx,%edx
80100786:	0f 85 b8 00 00 00    	jne    80100844 <cprintf+0x194>
8010078c:	b8 25 00 00 00       	mov    $0x25,%eax
80100791:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100794:	e8 67 fc ff ff       	call   80100400 <consputc.part.0>
80100799:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
8010079e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801007a1:	85 c0                	test   %eax,%eax
801007a3:	0f 84 cd 00 00 00    	je     80100876 <cprintf+0x1c6>
801007a9:	fa                   	cli
    for(;;)
801007aa:	eb fe                	jmp    801007aa <cprintf+0xfa>
801007ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      printint(*argp++, 16, 0);
801007b0:	8d 47 04             	lea    0x4(%edi),%eax
801007b3:	31 c9                	xor    %ecx,%ecx
801007b5:	ba 10 00 00 00       	mov    $0x10,%edx
801007ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
801007bd:	8b 07                	mov    (%edi),%eax
801007bf:	e8 5c fe ff ff       	call   80100620 <printint>
801007c4:	8b 7d e0             	mov    -0x20(%ebp),%edi
      break;
801007c7:	e9 56 ff ff ff       	jmp    80100722 <cprintf+0x72>
801007cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007d0:	83 ec 0c             	sub    $0xc,%esp
801007d3:	68 20 ff 10 80       	push   $0x8010ff20
801007d8:	e8 43 3f 00 00       	call   80104720 <acquire>
  if (fmt == 0)
801007dd:	83 c4 10             	add    $0x10,%esp
801007e0:	85 f6                	test   %esi,%esi
801007e2:	0f 84 a1 00 00 00    	je     80100889 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007e8:	0f b6 06             	movzbl (%esi),%eax
801007eb:	85 c0                	test   %eax,%eax
801007ed:	0f 85 e6 fe ff ff    	jne    801006d9 <cprintf+0x29>
    release(&cons.lock);
801007f3:	83 ec 0c             	sub    $0xc,%esp
801007f6:	68 20 ff 10 80       	push   $0x8010ff20
801007fb:	e8 c0 3e 00 00       	call   801046c0 <release>
80100800:	83 c4 10             	add    $0x10,%esp
80100803:	e9 30 ff ff ff       	jmp    80100738 <cprintf+0x88>
      if((s = (char*)*argp++) == 0)
80100808:	8b 17                	mov    (%edi),%edx
8010080a:	8d 47 04             	lea    0x4(%edi),%eax
8010080d:	85 d2                	test   %edx,%edx
8010080f:	74 27                	je     80100838 <cprintf+0x188>
      for(; *s; s++)
80100811:	0f b6 0a             	movzbl (%edx),%ecx
      if((s = (char*)*argp++) == 0)
80100814:	89 d7                	mov    %edx,%edi
      for(; *s; s++)
80100816:	84 c9                	test   %cl,%cl
80100818:	74 68                	je     80100882 <cprintf+0x1d2>
8010081a:	89 5d e0             	mov    %ebx,-0x20(%ebp)
8010081d:	89 fb                	mov    %edi,%ebx
8010081f:	89 f7                	mov    %esi,%edi
80100821:	89 c6                	mov    %eax,%esi
80100823:	0f be c1             	movsbl %cl,%eax
  if(panicked){
80100826:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
8010082c:	85 d2                	test   %edx,%edx
8010082e:	74 28                	je     80100858 <cprintf+0x1a8>
80100830:	fa                   	cli
    for(;;)
80100831:	eb fe                	jmp    80100831 <cprintf+0x181>
80100833:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100838:	b9 28 00 00 00       	mov    $0x28,%ecx
        s = "(null)";
8010083d:	bf 58 76 10 80       	mov    $0x80107658,%edi
80100842:	eb d6                	jmp    8010081a <cprintf+0x16a>
80100844:	fa                   	cli
    for(;;)
80100845:	eb fe                	jmp    80100845 <cprintf+0x195>
80100847:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010084e:	00 
8010084f:	90                   	nop
80100850:	fa                   	cli
80100851:	eb fe                	jmp    80100851 <cprintf+0x1a1>
80100853:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100858:	e8 a3 fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
8010085d:	0f be 43 01          	movsbl 0x1(%ebx),%eax
80100861:	83 c3 01             	add    $0x1,%ebx
80100864:	84 c0                	test   %al,%al
80100866:	75 be                	jne    80100826 <cprintf+0x176>
      if((s = (char*)*argp++) == 0)
80100868:	89 f0                	mov    %esi,%eax
8010086a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
8010086d:	89 fe                	mov    %edi,%esi
8010086f:	89 c7                	mov    %eax,%edi
80100871:	e9 ac fe ff ff       	jmp    80100722 <cprintf+0x72>
80100876:	89 c8                	mov    %ecx,%eax
80100878:	e8 83 fb ff ff       	call   80100400 <consputc.part.0>
      break;
8010087d:	e9 a0 fe ff ff       	jmp    80100722 <cprintf+0x72>
      if((s = (char*)*argp++) == 0)
80100882:	89 c7                	mov    %eax,%edi
80100884:	e9 99 fe ff ff       	jmp    80100722 <cprintf+0x72>
    panic("null fmt");
80100889:	83 ec 0c             	sub    $0xc,%esp
8010088c:	68 5f 76 10 80       	push   $0x8010765f
80100891:	e8 ea fa ff ff       	call   80100380 <panic>
80100896:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010089d:	00 
8010089e:	66 90                	xchg   %ax,%ax

801008a0 <consoleintr>:
{
801008a0:	55                   	push   %ebp
801008a1:	89 e5                	mov    %esp,%ebp
801008a3:	57                   	push   %edi
  int c, doprocdump = 0;
801008a4:	31 ff                	xor    %edi,%edi
{
801008a6:	56                   	push   %esi
801008a7:	53                   	push   %ebx
801008a8:	83 ec 18             	sub    $0x18,%esp
801008ab:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
801008ae:	68 20 ff 10 80       	push   $0x8010ff20
801008b3:	e8 68 3e 00 00       	call   80104720 <acquire>
  while((c = getc()) >= 0){
801008b8:	83 c4 10             	add    $0x10,%esp
801008bb:	ff d6                	call   *%esi
801008bd:	89 c3                	mov    %eax,%ebx
801008bf:	85 c0                	test   %eax,%eax
801008c1:	78 22                	js     801008e5 <consoleintr+0x45>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 47                	je     8010090f <consoleintr+0x6f>
801008c8:	7f 76                	jg     80100940 <consoleintr+0xa0>
801008ca:	83 fb 08             	cmp    $0x8,%ebx
801008cd:	74 76                	je     80100945 <consoleintr+0xa5>
801008cf:	83 fb 10             	cmp    $0x10,%ebx
801008d2:	0f 85 f8 00 00 00    	jne    801009d0 <consoleintr+0x130>
  while((c = getc()) >= 0){
801008d8:	ff d6                	call   *%esi
    switch(c){
801008da:	bf 01 00 00 00       	mov    $0x1,%edi
  while((c = getc()) >= 0){
801008df:	89 c3                	mov    %eax,%ebx
801008e1:	85 c0                	test   %eax,%eax
801008e3:	79 de                	jns    801008c3 <consoleintr+0x23>
  release(&cons.lock);
801008e5:	83 ec 0c             	sub    $0xc,%esp
801008e8:	68 20 ff 10 80       	push   $0x8010ff20
801008ed:	e8 ce 3d 00 00       	call   801046c0 <release>
  if(doprocdump) {
801008f2:	83 c4 10             	add    $0x10,%esp
801008f5:	85 ff                	test   %edi,%edi
801008f7:	0f 85 4b 01 00 00    	jne    80100a48 <consoleintr+0x1a8>
}
801008fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100900:	5b                   	pop    %ebx
80100901:	5e                   	pop    %esi
80100902:	5f                   	pop    %edi
80100903:	5d                   	pop    %ebp
80100904:	c3                   	ret
80100905:	b8 00 01 00 00       	mov    $0x100,%eax
8010090a:	e8 f1 fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
8010090f:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100914:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
8010091a:	74 9f                	je     801008bb <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010091c:	83 e8 01             	sub    $0x1,%eax
8010091f:	89 c2                	mov    %eax,%edx
80100921:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100924:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
8010092b:	74 8e                	je     801008bb <consoleintr+0x1b>
  if(panicked){
8010092d:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.e--;
80100933:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100938:	85 d2                	test   %edx,%edx
8010093a:	74 c9                	je     80100905 <consoleintr+0x65>
8010093c:	fa                   	cli
    for(;;)
8010093d:	eb fe                	jmp    8010093d <consoleintr+0x9d>
8010093f:	90                   	nop
    switch(c){
80100940:	83 fb 7f             	cmp    $0x7f,%ebx
80100943:	75 2b                	jne    80100970 <consoleintr+0xd0>
      if(input.e != input.w){
80100945:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
8010094a:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
80100950:	0f 84 65 ff ff ff    	je     801008bb <consoleintr+0x1b>
        input.e--;
80100956:	83 e8 01             	sub    $0x1,%eax
80100959:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
8010095e:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100963:	85 c0                	test   %eax,%eax
80100965:	0f 84 ce 00 00 00    	je     80100a39 <consoleintr+0x199>
8010096b:	fa                   	cli
    for(;;)
8010096c:	eb fe                	jmp    8010096c <consoleintr+0xcc>
8010096e:	66 90                	xchg   %ax,%ax
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100970:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100975:	89 c2                	mov    %eax,%edx
80100977:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
8010097d:	83 fa 7f             	cmp    $0x7f,%edx
80100980:	0f 87 35 ff ff ff    	ja     801008bb <consoleintr+0x1b>
  if(panicked){
80100986:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
8010098c:	8d 50 01             	lea    0x1(%eax),%edx
8010098f:	83 e0 7f             	and    $0x7f,%eax
80100992:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
80100998:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  if(panicked){
8010099e:	85 c9                	test   %ecx,%ecx
801009a0:	0f 85 ae 00 00 00    	jne    80100a54 <consoleintr+0x1b4>
801009a6:	89 d8                	mov    %ebx,%eax
801009a8:	e8 53 fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009ad:	83 fb 0a             	cmp    $0xa,%ebx
801009b0:	74 68                	je     80100a1a <consoleintr+0x17a>
801009b2:	83 fb 04             	cmp    $0x4,%ebx
801009b5:	74 63                	je     80100a1a <consoleintr+0x17a>
801009b7:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801009bc:	83 e8 80             	sub    $0xffffff80,%eax
801009bf:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
801009c5:	0f 85 f0 fe ff ff    	jne    801008bb <consoleintr+0x1b>
801009cb:	eb 52                	jmp    80100a1f <consoleintr+0x17f>
801009cd:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009d0:	85 db                	test   %ebx,%ebx
801009d2:	0f 84 e3 fe ff ff    	je     801008bb <consoleintr+0x1b>
801009d8:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009dd:	89 c2                	mov    %eax,%edx
801009df:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
801009e5:	83 fa 7f             	cmp    $0x7f,%edx
801009e8:	0f 87 cd fe ff ff    	ja     801008bb <consoleintr+0x1b>
        input.buf[input.e++ % INPUT_BUF] = c;
801009ee:	8d 50 01             	lea    0x1(%eax),%edx
  if(panicked){
801009f1:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
801009f7:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801009fa:	83 fb 0d             	cmp    $0xd,%ebx
801009fd:	75 93                	jne    80100992 <consoleintr+0xf2>
        input.buf[input.e++ % INPUT_BUF] = c;
801009ff:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
80100a05:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
  if(panicked){
80100a0c:	85 c9                	test   %ecx,%ecx
80100a0e:	75 44                	jne    80100a54 <consoleintr+0x1b4>
80100a10:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a15:	e8 e6 f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a1a:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
          wakeup(&input.r);
80100a1f:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a22:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80100a27:	68 00 ff 10 80       	push   $0x8010ff00
80100a2c:	e8 2f 38 00 00       	call   80104260 <wakeup>
80100a31:	83 c4 10             	add    $0x10,%esp
80100a34:	e9 82 fe ff ff       	jmp    801008bb <consoleintr+0x1b>
80100a39:	b8 00 01 00 00       	mov    $0x100,%eax
80100a3e:	e8 bd f9 ff ff       	call   80100400 <consputc.part.0>
80100a43:	e9 73 fe ff ff       	jmp    801008bb <consoleintr+0x1b>
}
80100a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a4b:	5b                   	pop    %ebx
80100a4c:	5e                   	pop    %esi
80100a4d:	5f                   	pop    %edi
80100a4e:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a4f:	e9 ec 38 00 00       	jmp    80104340 <procdump>
80100a54:	fa                   	cli
    for(;;)
80100a55:	eb fe                	jmp    80100a55 <consoleintr+0x1b5>
80100a57:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100a5e:	00 
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 68 76 10 80       	push   $0x80107668
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 bb 3a 00 00       	call   80104530 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c 09 11 80 b0 	movl   $0x801005b0,0x8011090c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 32 1a 00 00       	call   801024d0 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave
80100aa2:	c3                   	ret
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "sleeplock.h"
#include "file.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 1f 2f 00 00       	call   801039e0 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 e4 22 00 00       	call   80102db0 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 19 16 00 00       	call   801020f0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 5e 03 00 00    	je     80100e40 <exec+0x390>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c7                	mov    %eax,%edi
80100ae7:	50                   	push   %eax
80100ae8:	e8 03 0d 00 00       	call   801017f0 <ilock>
  if (!(ip->mode & 0b100)) {
80100aed:	83 c4 10             	add    $0x10,%esp
80100af0:	f6 47 50 04          	testb  $0x4,0x50(%edi)
80100af4:	0f 84 00 03 00 00    	je     80100dfa <exec+0x34a>
  pgdir = 0;
  


  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100afa:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100b00:	6a 34                	push   $0x34
80100b02:	6a 00                	push   $0x0
80100b04:	50                   	push   %eax
80100b05:	57                   	push   %edi
80100b06:	e8 05 10 00 00       	call   80101b10 <readi>
80100b0b:	83 c4 10             	add    $0x10,%esp
80100b0e:	83 f8 34             	cmp    $0x34,%eax
80100b11:	0f 85 fc 00 00 00    	jne    80100c13 <exec+0x163>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b17:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b1e:	45 4c 46 
80100b21:	0f 85 ec 00 00 00    	jne    80100c13 <exec+0x163>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b27:	e8 84 67 00 00       	call   801072b0 <setupkvm>
80100b2c:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b32:	85 c0                	test   %eax,%eax
80100b34:	0f 84 d9 00 00 00    	je     80100c13 <exec+0x163>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b3a:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b41:	00 
80100b42:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b48:	0f 84 a0 02 00 00    	je     80100dee <exec+0x33e>
  sz = 0;
80100b4e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b55:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b58:	31 db                	xor    %ebx,%ebx
80100b5a:	e9 87 00 00 00       	jmp    80100be6 <exec+0x136>
80100b5f:	90                   	nop
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100b60:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b67:	75 6c                	jne    80100bd5 <exec+0x125>
      continue;
    if(ph.memsz < ph.filesz)
80100b69:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b6f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b75:	0f 82 87 00 00 00    	jb     80100c02 <exec+0x152>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b7b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b81:	72 7f                	jb     80100c02 <exec+0x152>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b83:	83 ec 04             	sub    $0x4,%esp
80100b86:	50                   	push   %eax
80100b87:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b8d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100b93:	e8 48 65 00 00       	call   801070e0 <allocuvm>
80100b98:	83 c4 10             	add    $0x10,%esp
80100b9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100ba1:	85 c0                	test   %eax,%eax
80100ba3:	74 5d                	je     80100c02 <exec+0x152>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100ba5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bab:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bb0:	75 50                	jne    80100c02 <exec+0x152>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bb2:	83 ec 0c             	sub    $0xc,%esp
80100bb5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bbb:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bc1:	57                   	push   %edi
80100bc2:	50                   	push   %eax
80100bc3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bc9:	e8 42 64 00 00       	call   80107010 <loaduvm>
80100bce:	83 c4 20             	add    $0x20,%esp
80100bd1:	85 c0                	test   %eax,%eax
80100bd3:	78 2d                	js     80100c02 <exec+0x152>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bd5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bdc:	83 c3 01             	add    $0x1,%ebx
80100bdf:	83 c6 20             	add    $0x20,%esi
80100be2:	39 d8                	cmp    %ebx,%eax
80100be4:	7e 4a                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100be6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bec:	6a 20                	push   $0x20
80100bee:	56                   	push   %esi
80100bef:	50                   	push   %eax
80100bf0:	57                   	push   %edi
80100bf1:	e8 1a 0f 00 00       	call   80101b10 <readi>
80100bf6:	83 c4 10             	add    $0x10,%esp
80100bf9:	83 f8 20             	cmp    $0x20,%eax
80100bfc:	0f 84 5e ff ff ff    	je     80100b60 <exec+0xb0>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100c02:	83 ec 0c             	sub    $0xc,%esp
80100c05:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c0b:	e8 20 66 00 00       	call   80107230 <freevm>
  if(ip){
80100c10:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100c13:	83 ec 0c             	sub    $0xc,%esp
80100c16:	57                   	push   %edi
80100c17:	e8 64 0e 00 00       	call   80101a80 <iunlockput>
    end_op();
80100c1c:	e8 ff 21 00 00       	call   80102e20 <end_op>
80100c21:	83 c4 10             	add    $0x10,%esp
80100c24:	e9 e2 00 00 00       	jmp    80100d0b <exec+0x25b>
80100c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
80100c30:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c36:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100c3c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	57                   	push   %edi
80100c4c:	e8 2f 0e 00 00       	call   80101a80 <iunlockput>
  end_op();
80100c51:	e8 ca 21 00 00       	call   80102e20 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	53                   	push   %ebx
80100c5a:	56                   	push   %esi
80100c5b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c61:	56                   	push   %esi
80100c62:	e8 79 64 00 00       	call   801070e0 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c7                	mov    %eax,%edi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 86 00 00 00    	je     80100cfa <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  sp = sz;
80100c7d:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 c8 66 00 00       	call   80107350 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8b 10                	mov    (%eax),%edx
80100c90:	85 d2                	test   %edx,%edx
80100c92:	0f 84 84 01 00 00    	je     80100e1c <exec+0x36c>
80100c98:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80100c9e:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100ca1:	eb 23                	jmp    80100cc6 <exec+0x216>
80100ca3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100ca8:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
80100cab:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80100cb2:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100cb8:	8b 14 87             	mov    (%edi,%eax,4),%edx
80100cbb:	85 d2                	test   %edx,%edx
80100cbd:	74 59                	je     80100d18 <exec+0x268>
    if(argc >= MAXARG)
80100cbf:	83 f8 20             	cmp    $0x20,%eax
80100cc2:	74 36                	je     80100cfa <exec+0x24a>
80100cc4:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cc6:	83 ec 0c             	sub    $0xc,%esp
80100cc9:	52                   	push   %edx
80100cca:	e8 41 3d 00 00       	call   80104a10 <strlen>
80100ccf:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cd1:	58                   	pop    %eax
80100cd2:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cd5:	83 eb 01             	sub    $0x1,%ebx
80100cd8:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cdb:	e8 30 3d 00 00       	call   80104a10 <strlen>
80100ce0:	83 c0 01             	add    $0x1,%eax
80100ce3:	50                   	push   %eax
80100ce4:	ff 34 b7             	push   (%edi,%esi,4)
80100ce7:	53                   	push   %ebx
80100ce8:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100cee:	e8 2d 68 00 00       	call   80107520 <copyout>
80100cf3:	83 c4 20             	add    $0x20,%esp
80100cf6:	85 c0                	test   %eax,%eax
80100cf8:	79 ae                	jns    80100ca8 <exec+0x1f8>
    freevm(pgdir);
80100cfa:	83 ec 0c             	sub    $0xc,%esp
80100cfd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d03:	e8 28 65 00 00       	call   80107230 <freevm>
80100d08:	83 c4 10             	add    $0x10,%esp
    return -1;
80100d0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80100d10:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d13:	5b                   	pop    %ebx
80100d14:	5e                   	pop    %esi
80100d15:	5f                   	pop    %edi
80100d16:	5d                   	pop    %ebp
80100d17:	c3                   	ret
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d18:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
80100d1f:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100d25:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100d2b:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
80100d2e:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80100d31:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80100d38:	00 00 00 00 
  ustack[1] = argc;
80100d3c:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
80100d42:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d49:	ff ff ff 
  ustack[1] = argc;
80100d4c:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d52:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
80100d54:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d56:	29 d0                	sub    %edx,%eax
80100d58:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d5e:	56                   	push   %esi
80100d5f:	51                   	push   %ecx
80100d60:	53                   	push   %ebx
80100d61:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d67:	e8 b4 67 00 00       	call   80107520 <copyout>
80100d6c:	83 c4 10             	add    $0x10,%esp
80100d6f:	85 c0                	test   %eax,%eax
80100d71:	78 87                	js     80100cfa <exec+0x24a>
  for(last=s=path; *s; s++)
80100d73:	8b 45 08             	mov    0x8(%ebp),%eax
80100d76:	8b 55 08             	mov    0x8(%ebp),%edx
80100d79:	0f b6 00             	movzbl (%eax),%eax
80100d7c:	84 c0                	test   %al,%al
80100d7e:	74 17                	je     80100d97 <exec+0x2e7>
80100d80:	89 d1                	mov    %edx,%ecx
80100d82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80100d88:	83 c1 01             	add    $0x1,%ecx
80100d8b:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d8d:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d90:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d93:	84 c0                	test   %al,%al
80100d95:	75 f1                	jne    80100d88 <exec+0x2d8>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d97:	83 ec 04             	sub    $0x4,%esp
80100d9a:	6a 10                	push   $0x10
80100d9c:	52                   	push   %edx
80100d9d:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100da3:	8d 86 cc 00 00 00    	lea    0xcc(%esi),%eax
80100da9:	50                   	push   %eax
80100daa:	e8 21 3c 00 00       	call   801049d0 <safestrcpy>
  curproc->pgdir = pgdir;
80100daf:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100db5:	89 f0                	mov    %esi,%eax
80100db7:	8b 76 64             	mov    0x64(%esi),%esi
  curproc->tf->eip = elf.entry;  // main
80100dba:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  curproc->sz = sz;
80100dc0:	89 78 60             	mov    %edi,0x60(%eax)
  curproc->pgdir = pgdir;
80100dc3:	89 48 64             	mov    %ecx,0x64(%eax)
  curproc->tf->eip = elf.entry;  // main
80100dc6:	89 c1                	mov    %eax,%ecx
80100dc8:	8b 40 78             	mov    0x78(%eax),%eax
80100dcb:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dce:	8b 41 78             	mov    0x78(%ecx),%eax
80100dd1:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dd4:	89 0c 24             	mov    %ecx,(%esp)
80100dd7:	e8 a4 60 00 00       	call   80106e80 <switchuvm>
  freevm(oldpgdir);
80100ddc:	89 34 24             	mov    %esi,(%esp)
80100ddf:	e8 4c 64 00 00       	call   80107230 <freevm>
  return 0;
80100de4:	83 c4 10             	add    $0x10,%esp
80100de7:	31 c0                	xor    %eax,%eax
80100de9:	e9 22 ff ff ff       	jmp    80100d10 <exec+0x260>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dee:	bb 00 20 00 00       	mov    $0x2000,%ebx
80100df3:	31 f6                	xor    %esi,%esi
80100df5:	e9 4e fe ff ff       	jmp    80100c48 <exec+0x198>
      cprintf("Operation execute failed\n");
80100dfa:	83 ec 0c             	sub    $0xc,%esp
80100dfd:	68 7c 76 10 80       	push   $0x8010767c
80100e02:	e8 a9 f8 ff ff       	call   801006b0 <cprintf>
      iunlockput(ip);
80100e07:	89 3c 24             	mov    %edi,(%esp)
80100e0a:	e8 71 0c 00 00       	call   80101a80 <iunlockput>
      end_op();
80100e0f:	e8 0c 20 00 00       	call   80102e20 <end_op>
      return -1;
80100e14:	83 c4 10             	add    $0x10,%esp
80100e17:	e9 ef fe ff ff       	jmp    80100d0b <exec+0x25b>
  for(argc = 0; argv[argc]; argc++) {
80100e1c:	be 10 00 00 00       	mov    $0x10,%esi
80100e21:	ba 04 00 00 00       	mov    $0x4,%edx
80100e26:	b8 03 00 00 00       	mov    $0x3,%eax
80100e2b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100e32:	00 00 00 
80100e35:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100e3b:	e9 f1 fe ff ff       	jmp    80100d31 <exec+0x281>
    end_op();
80100e40:	e8 db 1f 00 00       	call   80102e20 <end_op>
    cprintf("exec: fail\n");
80100e45:	83 ec 0c             	sub    $0xc,%esp
80100e48:	68 70 76 10 80       	push   $0x80107670
80100e4d:	e8 5e f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100e52:	83 c4 10             	add    $0x10,%esp
80100e55:	e9 b1 fe ff ff       	jmp    80100d0b <exec+0x25b>
80100e5a:	66 90                	xchg   %ax,%ax
80100e5c:	66 90                	xchg   %ax,%ax
80100e5e:	66 90                	xchg   %ax,%ax

80100e60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e60:	55                   	push   %ebp
80100e61:	89 e5                	mov    %esp,%ebp
80100e63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e66:	68 96 76 10 80       	push   $0x80107696
80100e6b:	68 60 ff 10 80       	push   $0x8010ff60
80100e70:	e8 bb 36 00 00       	call   80104530 <initlock>
}
80100e75:	83 c4 10             	add    $0x10,%esp
80100e78:	c9                   	leave
80100e79:	c3                   	ret
80100e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e80:	55                   	push   %ebp
80100e81:	89 e5                	mov    %esp,%ebp
80100e83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e84:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100e89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e8c:	68 60 ff 10 80       	push   $0x8010ff60
80100e91:	e8 8a 38 00 00       	call   80104720 <acquire>
80100e96:	83 c4 10             	add    $0x10,%esp
80100e99:	eb 10                	jmp    80100eab <filealloc+0x2b>
80100e9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ea0:	83 c3 18             	add    $0x18,%ebx
80100ea3:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100ea9:	74 25                	je     80100ed0 <filealloc+0x50>
    if(f->ref == 0){
80100eab:	8b 43 04             	mov    0x4(%ebx),%eax
80100eae:	85 c0                	test   %eax,%eax
80100eb0:	75 ee                	jne    80100ea0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100eb2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100eb5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100ebc:	68 60 ff 10 80       	push   $0x8010ff60
80100ec1:	e8 fa 37 00 00       	call   801046c0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100ec6:	89 d8                	mov    %ebx,%eax
      return f;
80100ec8:	83 c4 10             	add    $0x10,%esp
}
80100ecb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ece:	c9                   	leave
80100ecf:	c3                   	ret
  release(&ftable.lock);
80100ed0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100ed3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100ed5:	68 60 ff 10 80       	push   $0x8010ff60
80100eda:	e8 e1 37 00 00       	call   801046c0 <release>
}
80100edf:	89 d8                	mov    %ebx,%eax
  return 0;
80100ee1:	83 c4 10             	add    $0x10,%esp
}
80100ee4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ee7:	c9                   	leave
80100ee8:	c3                   	ret
80100ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	53                   	push   %ebx
80100ef4:	83 ec 10             	sub    $0x10,%esp
80100ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100efa:	68 60 ff 10 80       	push   $0x8010ff60
80100eff:	e8 1c 38 00 00       	call   80104720 <acquire>
  if(f->ref < 1)
80100f04:	8b 43 04             	mov    0x4(%ebx),%eax
80100f07:	83 c4 10             	add    $0x10,%esp
80100f0a:	85 c0                	test   %eax,%eax
80100f0c:	7e 1a                	jle    80100f28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100f0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100f11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100f14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100f17:	68 60 ff 10 80       	push   $0x8010ff60
80100f1c:	e8 9f 37 00 00       	call   801046c0 <release>
  return f;
}
80100f21:	89 d8                	mov    %ebx,%eax
80100f23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f26:	c9                   	leave
80100f27:	c3                   	ret
    panic("filedup");
80100f28:	83 ec 0c             	sub    $0xc,%esp
80100f2b:	68 9d 76 10 80       	push   $0x8010769d
80100f30:	e8 4b f4 ff ff       	call   80100380 <panic>
80100f35:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100f3c:	00 
80100f3d:	8d 76 00             	lea    0x0(%esi),%esi

80100f40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	57                   	push   %edi
80100f44:	56                   	push   %esi
80100f45:	53                   	push   %ebx
80100f46:	83 ec 28             	sub    $0x28,%esp
80100f49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f4c:	68 60 ff 10 80       	push   $0x8010ff60
80100f51:	e8 ca 37 00 00       	call   80104720 <acquire>
  if(f->ref < 1)
80100f56:	8b 53 04             	mov    0x4(%ebx),%edx
80100f59:	83 c4 10             	add    $0x10,%esp
80100f5c:	85 d2                	test   %edx,%edx
80100f5e:	0f 8e a5 00 00 00    	jle    80101009 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f64:	83 ea 01             	sub    $0x1,%edx
80100f67:	89 53 04             	mov    %edx,0x4(%ebx)
80100f6a:	75 44                	jne    80100fb0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f6c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f70:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f73:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f75:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f7b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f7e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f81:	8b 43 10             	mov    0x10(%ebx),%eax
80100f84:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f87:	68 60 ff 10 80       	push   $0x8010ff60
80100f8c:	e8 2f 37 00 00       	call   801046c0 <release>

  if(ff.type == FD_PIPE)
80100f91:	83 c4 10             	add    $0x10,%esp
80100f94:	83 ff 01             	cmp    $0x1,%edi
80100f97:	74 57                	je     80100ff0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f99:	83 ff 02             	cmp    $0x2,%edi
80100f9c:	74 2a                	je     80100fc8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fa1:	5b                   	pop    %ebx
80100fa2:	5e                   	pop    %esi
80100fa3:	5f                   	pop    %edi
80100fa4:	5d                   	pop    %ebp
80100fa5:	c3                   	ret
80100fa6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100fad:	00 
80100fae:	66 90                	xchg   %ax,%ax
    release(&ftable.lock);
80100fb0:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100fb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fba:	5b                   	pop    %ebx
80100fbb:	5e                   	pop    %esi
80100fbc:	5f                   	pop    %edi
80100fbd:	5d                   	pop    %ebp
    release(&ftable.lock);
80100fbe:	e9 fd 36 00 00       	jmp    801046c0 <release>
80100fc3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
80100fc8:	e8 e3 1d 00 00       	call   80102db0 <begin_op>
    iput(ff.ip);
80100fcd:	83 ec 0c             	sub    $0xc,%esp
80100fd0:	ff 75 e0             	push   -0x20(%ebp)
80100fd3:	e8 48 09 00 00       	call   80101920 <iput>
    end_op();
80100fd8:	83 c4 10             	add    $0x10,%esp
}
80100fdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fde:	5b                   	pop    %ebx
80100fdf:	5e                   	pop    %esi
80100fe0:	5f                   	pop    %edi
80100fe1:	5d                   	pop    %ebp
    end_op();
80100fe2:	e9 39 1e 00 00       	jmp    80102e20 <end_op>
80100fe7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100fee:	00 
80100fef:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80100ff0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ff4:	83 ec 08             	sub    $0x8,%esp
80100ff7:	53                   	push   %ebx
80100ff8:	56                   	push   %esi
80100ff9:	e8 72 25 00 00       	call   80103570 <pipeclose>
80100ffe:	83 c4 10             	add    $0x10,%esp
}
80101001:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101004:	5b                   	pop    %ebx
80101005:	5e                   	pop    %esi
80101006:	5f                   	pop    %edi
80101007:	5d                   	pop    %ebp
80101008:	c3                   	ret
    panic("fileclose");
80101009:	83 ec 0c             	sub    $0xc,%esp
8010100c:	68 a5 76 10 80       	push   $0x801076a5
80101011:	e8 6a f3 ff ff       	call   80100380 <panic>
80101016:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010101d:	00 
8010101e:	66 90                	xchg   %ax,%ax

80101020 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	53                   	push   %ebx
80101024:	83 ec 04             	sub    $0x4,%esp
80101027:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010102a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010102d:	75 31                	jne    80101060 <filestat+0x40>
    ilock(f->ip);
8010102f:	83 ec 0c             	sub    $0xc,%esp
80101032:	ff 73 10             	push   0x10(%ebx)
80101035:	e8 b6 07 00 00       	call   801017f0 <ilock>
    stati(f->ip, st);
8010103a:	58                   	pop    %eax
8010103b:	5a                   	pop    %edx
8010103c:	ff 75 0c             	push   0xc(%ebp)
8010103f:	ff 73 10             	push   0x10(%ebx)
80101042:	e8 89 0a 00 00       	call   80101ad0 <stati>
    iunlock(f->ip);
80101047:	59                   	pop    %ecx
80101048:	ff 73 10             	push   0x10(%ebx)
8010104b:	e8 80 08 00 00       	call   801018d0 <iunlock>
    return 0;
  }
  return -1;
}
80101050:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101053:	83 c4 10             	add    $0x10,%esp
80101056:	31 c0                	xor    %eax,%eax
}
80101058:	c9                   	leave
80101059:	c3                   	ret
8010105a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101060:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101063:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101068:	c9                   	leave
80101069:	c3                   	ret
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101070 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101070:	55                   	push   %ebp
80101071:	89 e5                	mov    %esp,%ebp
80101073:	57                   	push   %edi
80101074:	56                   	push   %esi
80101075:	53                   	push   %ebx
80101076:	83 ec 0c             	sub    $0xc,%esp
80101079:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010107c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010107f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101082:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101086:	74 60                	je     801010e8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101088:	8b 03                	mov    (%ebx),%eax
8010108a:	83 f8 01             	cmp    $0x1,%eax
8010108d:	74 41                	je     801010d0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010108f:	83 f8 02             	cmp    $0x2,%eax
80101092:	75 5b                	jne    801010ef <fileread+0x7f>
    ilock(f->ip);
80101094:	83 ec 0c             	sub    $0xc,%esp
80101097:	ff 73 10             	push   0x10(%ebx)
8010109a:	e8 51 07 00 00       	call   801017f0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010109f:	57                   	push   %edi
801010a0:	ff 73 14             	push   0x14(%ebx)
801010a3:	56                   	push   %esi
801010a4:	ff 73 10             	push   0x10(%ebx)
801010a7:	e8 64 0a 00 00       	call   80101b10 <readi>
801010ac:	83 c4 20             	add    $0x20,%esp
801010af:	89 c6                	mov    %eax,%esi
801010b1:	85 c0                	test   %eax,%eax
801010b3:	7e 03                	jle    801010b8 <fileread+0x48>
      f->off += r;
801010b5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801010b8:	83 ec 0c             	sub    $0xc,%esp
801010bb:	ff 73 10             	push   0x10(%ebx)
801010be:	e8 0d 08 00 00       	call   801018d0 <iunlock>
    return r;
801010c3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801010c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c9:	89 f0                	mov    %esi,%eax
801010cb:	5b                   	pop    %ebx
801010cc:	5e                   	pop    %esi
801010cd:	5f                   	pop    %edi
801010ce:	5d                   	pop    %ebp
801010cf:	c3                   	ret
    return piperead(f->pipe, addr, n);
801010d0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010d3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d9:	5b                   	pop    %ebx
801010da:	5e                   	pop    %esi
801010db:	5f                   	pop    %edi
801010dc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010dd:	e9 4e 26 00 00       	jmp    80103730 <piperead>
801010e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010e8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010ed:	eb d7                	jmp    801010c6 <fileread+0x56>
  panic("fileread");
801010ef:	83 ec 0c             	sub    $0xc,%esp
801010f2:	68 af 76 10 80       	push   $0x801076af
801010f7:	e8 84 f2 ff ff       	call   80100380 <panic>
801010fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101100 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	57                   	push   %edi
80101104:	56                   	push   %esi
80101105:	53                   	push   %ebx
80101106:	83 ec 1c             	sub    $0x1c,%esp
80101109:	8b 45 0c             	mov    0xc(%ebp),%eax
8010110c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010110f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101112:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101115:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101119:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010111c:	0f 84 bb 00 00 00    	je     801011dd <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
80101122:	8b 03                	mov    (%ebx),%eax
80101124:	83 f8 01             	cmp    $0x1,%eax
80101127:	0f 84 bf 00 00 00    	je     801011ec <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010112d:	83 f8 02             	cmp    $0x2,%eax
80101130:	0f 85 c8 00 00 00    	jne    801011fe <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101136:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101139:	31 f6                	xor    %esi,%esi
    while(i < n){
8010113b:	85 c0                	test   %eax,%eax
8010113d:	7f 30                	jg     8010116f <filewrite+0x6f>
8010113f:	e9 94 00 00 00       	jmp    801011d8 <filewrite+0xd8>
80101144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101148:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010114b:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
8010114e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101151:	ff 73 10             	push   0x10(%ebx)
80101154:	e8 77 07 00 00       	call   801018d0 <iunlock>
      end_op();
80101159:	e8 c2 1c 00 00       	call   80102e20 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010115e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101161:	83 c4 10             	add    $0x10,%esp
80101164:	39 c7                	cmp    %eax,%edi
80101166:	75 5c                	jne    801011c4 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101168:	01 fe                	add    %edi,%esi
    while(i < n){
8010116a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010116d:	7e 69                	jle    801011d8 <filewrite+0xd8>
      int n1 = n - i;
8010116f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
80101172:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
80101177:	29 f7                	sub    %esi,%edi
      if(n1 > max)
80101179:	39 c7                	cmp    %eax,%edi
8010117b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010117e:	e8 2d 1c 00 00       	call   80102db0 <begin_op>
      ilock(f->ip);
80101183:	83 ec 0c             	sub    $0xc,%esp
80101186:	ff 73 10             	push   0x10(%ebx)
80101189:	e8 62 06 00 00       	call   801017f0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010118e:	57                   	push   %edi
8010118f:	ff 73 14             	push   0x14(%ebx)
80101192:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101195:	01 f0                	add    %esi,%eax
80101197:	50                   	push   %eax
80101198:	ff 73 10             	push   0x10(%ebx)
8010119b:	e8 70 0a 00 00       	call   80101c10 <writei>
801011a0:	83 c4 20             	add    $0x20,%esp
801011a3:	85 c0                	test   %eax,%eax
801011a5:	7f a1                	jg     80101148 <filewrite+0x48>
801011a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801011aa:	83 ec 0c             	sub    $0xc,%esp
801011ad:	ff 73 10             	push   0x10(%ebx)
801011b0:	e8 1b 07 00 00       	call   801018d0 <iunlock>
      end_op();
801011b5:	e8 66 1c 00 00       	call   80102e20 <end_op>
      if(r < 0)
801011ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011bd:	83 c4 10             	add    $0x10,%esp
801011c0:	85 c0                	test   %eax,%eax
801011c2:	75 14                	jne    801011d8 <filewrite+0xd8>
        panic("short filewrite");
801011c4:	83 ec 0c             	sub    $0xc,%esp
801011c7:	68 b8 76 10 80       	push   $0x801076b8
801011cc:	e8 af f1 ff ff       	call   80100380 <panic>
801011d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
801011d8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801011db:	74 05                	je     801011e2 <filewrite+0xe2>
801011dd:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
801011e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011e5:	89 f0                	mov    %esi,%eax
801011e7:	5b                   	pop    %ebx
801011e8:	5e                   	pop    %esi
801011e9:	5f                   	pop    %edi
801011ea:	5d                   	pop    %ebp
801011eb:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
801011ec:	8b 43 0c             	mov    0xc(%ebx),%eax
801011ef:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011f5:	5b                   	pop    %ebx
801011f6:	5e                   	pop    %esi
801011f7:	5f                   	pop    %edi
801011f8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011f9:	e9 12 24 00 00       	jmp    80103610 <pipewrite>
  panic("filewrite");
801011fe:	83 ec 0c             	sub    $0xc,%esp
80101201:	68 be 76 10 80       	push   $0x801076be
80101206:	e8 75 f1 ff ff       	call   80100380 <panic>
8010120b:	66 90                	xchg   %ax,%ax
8010120d:	66 90                	xchg   %ax,%ax
8010120f:	90                   	nop

80101210 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101210:	55                   	push   %ebp
80101211:	89 e5                	mov    %esp,%ebp
80101213:	57                   	push   %edi
80101214:	56                   	push   %esi
80101215:	53                   	push   %ebx
80101216:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101219:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
8010121f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101222:	85 c9                	test   %ecx,%ecx
80101224:	0f 84 8c 00 00 00    	je     801012b6 <balloc+0xa6>
8010122a:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
8010122c:	89 f8                	mov    %edi,%eax
8010122e:	83 ec 08             	sub    $0x8,%esp
80101231:	89 fe                	mov    %edi,%esi
80101233:	c1 f8 0c             	sar    $0xc,%eax
80101236:	03 05 cc 25 11 80    	add    0x801125cc,%eax
8010123c:	50                   	push   %eax
8010123d:	ff 75 dc             	push   -0x24(%ebp)
80101240:	e8 8b ee ff ff       	call   801000d0 <bread>
80101245:	83 c4 10             	add    $0x10,%esp
80101248:	89 7d d8             	mov    %edi,-0x28(%ebp)
8010124b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010124e:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80101253:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101256:	31 c0                	xor    %eax,%eax
80101258:	eb 32                	jmp    8010128c <balloc+0x7c>
8010125a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101260:	89 c1                	mov    %eax,%ecx
80101262:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101267:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
8010126a:	83 e1 07             	and    $0x7,%ecx
8010126d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010126f:	89 c1                	mov    %eax,%ecx
80101271:	c1 f9 03             	sar    $0x3,%ecx
80101274:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
80101279:	89 fa                	mov    %edi,%edx
8010127b:	85 df                	test   %ebx,%edi
8010127d:	74 49                	je     801012c8 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010127f:	83 c0 01             	add    $0x1,%eax
80101282:	83 c6 01             	add    $0x1,%esi
80101285:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010128a:	74 07                	je     80101293 <balloc+0x83>
8010128c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010128f:	39 d6                	cmp    %edx,%esi
80101291:	72 cd                	jb     80101260 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101293:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101296:	83 ec 0c             	sub    $0xc,%esp
80101299:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010129c:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
801012a2:	e8 49 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012a7:	83 c4 10             	add    $0x10,%esp
801012aa:	3b 3d b4 25 11 80    	cmp    0x801125b4,%edi
801012b0:	0f 82 76 ff ff ff    	jb     8010122c <balloc+0x1c>
  }
  panic("balloc: out of blocks");
801012b6:	83 ec 0c             	sub    $0xc,%esp
801012b9:	68 c8 76 10 80       	push   $0x801076c8
801012be:	e8 bd f0 ff ff       	call   80100380 <panic>
801012c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
801012c8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012cb:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012ce:	09 da                	or     %ebx,%edx
801012d0:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012d4:	57                   	push   %edi
801012d5:	e8 b6 1c 00 00       	call   80102f90 <log_write>
        brelse(bp);
801012da:	89 3c 24             	mov    %edi,(%esp)
801012dd:	e8 0e ef ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801012e2:	58                   	pop    %eax
801012e3:	5a                   	pop    %edx
801012e4:	56                   	push   %esi
801012e5:	ff 75 dc             	push   -0x24(%ebp)
801012e8:	e8 e3 ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801012ed:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801012f0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801012f2:	8d 40 5c             	lea    0x5c(%eax),%eax
801012f5:	68 00 02 00 00       	push   $0x200
801012fa:	6a 00                	push   $0x0
801012fc:	50                   	push   %eax
801012fd:	e8 1e 35 00 00       	call   80104820 <memset>
  log_write(bp);
80101302:	89 1c 24             	mov    %ebx,(%esp)
80101305:	e8 86 1c 00 00       	call   80102f90 <log_write>
  brelse(bp);
8010130a:	89 1c 24             	mov    %ebx,(%esp)
8010130d:	e8 de ee ff ff       	call   801001f0 <brelse>
}
80101312:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101315:	89 f0                	mov    %esi,%eax
80101317:	5b                   	pop    %ebx
80101318:	5e                   	pop    %esi
80101319:	5f                   	pop    %edi
8010131a:	5d                   	pop    %ebp
8010131b:	c3                   	ret
8010131c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101320 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101320:	55                   	push   %ebp
80101321:	89 e5                	mov    %esp,%ebp
80101323:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101324:	31 ff                	xor    %edi,%edi
{
80101326:	56                   	push   %esi
80101327:	89 c6                	mov    %eax,%esi
80101329:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010132a:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
8010132f:	83 ec 28             	sub    $0x28,%esp
80101332:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101335:	68 60 09 11 80       	push   $0x80110960
8010133a:	e8 e1 33 00 00       	call   80104720 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010133f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101342:	83 c4 10             	add    $0x10,%esp
80101345:	eb 1b                	jmp    80101362 <iget+0x42>
80101347:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010134e:	00 
8010134f:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101350:	39 33                	cmp    %esi,(%ebx)
80101352:	74 6c                	je     801013c0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101354:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010135a:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101360:	74 26                	je     80101388 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101362:	8b 43 08             	mov    0x8(%ebx),%eax
80101365:	85 c0                	test   %eax,%eax
80101367:	7f e7                	jg     80101350 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101369:	85 ff                	test   %edi,%edi
8010136b:	75 e7                	jne    80101354 <iget+0x34>
8010136d:	85 c0                	test   %eax,%eax
8010136f:	75 76                	jne    801013e7 <iget+0xc7>
      empty = ip;
80101371:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101373:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101379:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
8010137f:	75 e1                	jne    80101362 <iget+0x42>
80101381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101388:	85 ff                	test   %edi,%edi
8010138a:	74 79                	je     80101405 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010138c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010138f:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
80101391:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
80101394:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
8010139b:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
801013a2:	68 60 09 11 80       	push   $0x80110960
801013a7:	e8 14 33 00 00       	call   801046c0 <release>

  return ip;
801013ac:	83 c4 10             	add    $0x10,%esp
}
801013af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013b2:	89 f8                	mov    %edi,%eax
801013b4:	5b                   	pop    %ebx
801013b5:	5e                   	pop    %esi
801013b6:	5f                   	pop    %edi
801013b7:	5d                   	pop    %ebp
801013b8:	c3                   	ret
801013b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013c0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013c3:	75 8f                	jne    80101354 <iget+0x34>
      ip->ref++;
801013c5:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
801013c8:	83 ec 0c             	sub    $0xc,%esp
      return ip;
801013cb:	89 df                	mov    %ebx,%edi
      ip->ref++;
801013cd:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801013d0:	68 60 09 11 80       	push   $0x80110960
801013d5:	e8 e6 32 00 00       	call   801046c0 <release>
      return ip;
801013da:	83 c4 10             	add    $0x10,%esp
}
801013dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e0:	89 f8                	mov    %edi,%eax
801013e2:	5b                   	pop    %ebx
801013e3:	5e                   	pop    %esi
801013e4:	5f                   	pop    %edi
801013e5:	5d                   	pop    %ebp
801013e6:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013e7:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013ed:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013f3:	74 10                	je     80101405 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f5:	8b 43 08             	mov    0x8(%ebx),%eax
801013f8:	85 c0                	test   %eax,%eax
801013fa:	0f 8f 50 ff ff ff    	jg     80101350 <iget+0x30>
80101400:	e9 68 ff ff ff       	jmp    8010136d <iget+0x4d>
    panic("iget: no inodes");
80101405:	83 ec 0c             	sub    $0xc,%esp
80101408:	68 de 76 10 80       	push   $0x801076de
8010140d:	e8 6e ef ff ff       	call   80100380 <panic>
80101412:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101419:	00 
8010141a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101420 <bfree>:
{
80101420:	55                   	push   %ebp
80101421:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
80101423:	89 d0                	mov    %edx,%eax
80101425:	c1 e8 0c             	shr    $0xc,%eax
{
80101428:	89 e5                	mov    %esp,%ebp
8010142a:	56                   	push   %esi
8010142b:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
8010142c:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
80101432:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101434:	83 ec 08             	sub    $0x8,%esp
80101437:	50                   	push   %eax
80101438:	51                   	push   %ecx
80101439:	e8 92 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010143e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101440:	c1 fb 03             	sar    $0x3,%ebx
80101443:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101446:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101448:	83 e1 07             	and    $0x7,%ecx
8010144b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101450:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101456:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101458:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010145d:	85 c1                	test   %eax,%ecx
8010145f:	74 23                	je     80101484 <bfree+0x64>
  bp->data[bi/8] &= ~m;
80101461:	f7 d0                	not    %eax
  log_write(bp);
80101463:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101466:	21 c8                	and    %ecx,%eax
80101468:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010146c:	56                   	push   %esi
8010146d:	e8 1e 1b 00 00       	call   80102f90 <log_write>
  brelse(bp);
80101472:	89 34 24             	mov    %esi,(%esp)
80101475:	e8 76 ed ff ff       	call   801001f0 <brelse>
}
8010147a:	83 c4 10             	add    $0x10,%esp
8010147d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101480:	5b                   	pop    %ebx
80101481:	5e                   	pop    %esi
80101482:	5d                   	pop    %ebp
80101483:	c3                   	ret
    panic("freeing free block");
80101484:	83 ec 0c             	sub    $0xc,%esp
80101487:	68 ee 76 10 80       	push   $0x801076ee
8010148c:	e8 ef ee ff ff       	call   80100380 <panic>
80101491:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101498:	00 
80101499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801014a0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801014a0:	55                   	push   %ebp
801014a1:	89 e5                	mov    %esp,%ebp
801014a3:	57                   	push   %edi
801014a4:	56                   	push   %esi
801014a5:	89 c6                	mov    %eax,%esi
801014a7:	53                   	push   %ebx
801014a8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801014ab:	83 fa 0a             	cmp    $0xa,%edx
801014ae:	0f 86 8c 00 00 00    	jbe    80101540 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801014b4:	8d 5a f5             	lea    -0xb(%edx),%ebx

  if(bn < NINDIRECT){
801014b7:	83 fb 7f             	cmp    $0x7f,%ebx
801014ba:	0f 87 a0 00 00 00    	ja     80101560 <bmap+0xc0>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801014c0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801014c6:	85 c0                	test   %eax,%eax
801014c8:	74 5e                	je     80101528 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801014ca:	83 ec 08             	sub    $0x8,%esp
801014cd:	50                   	push   %eax
801014ce:	ff 36                	push   (%esi)
801014d0:	e8 fb eb ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801014d5:	83 c4 10             	add    $0x10,%esp
801014d8:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
801014dc:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
801014de:	8b 3b                	mov    (%ebx),%edi
801014e0:	85 ff                	test   %edi,%edi
801014e2:	74 1c                	je     80101500 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801014e4:	83 ec 0c             	sub    $0xc,%esp
801014e7:	52                   	push   %edx
801014e8:	e8 03 ed ff ff       	call   801001f0 <brelse>
801014ed:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014f3:	89 f8                	mov    %edi,%eax
801014f5:	5b                   	pop    %ebx
801014f6:	5e                   	pop    %esi
801014f7:	5f                   	pop    %edi
801014f8:	5d                   	pop    %ebp
801014f9:	c3                   	ret
801014fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101500:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101503:	8b 06                	mov    (%esi),%eax
80101505:	e8 06 fd ff ff       	call   80101210 <balloc>
      log_write(bp);
8010150a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010150d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101510:	89 03                	mov    %eax,(%ebx)
80101512:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101514:	52                   	push   %edx
80101515:	e8 76 1a 00 00       	call   80102f90 <log_write>
8010151a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010151d:	83 c4 10             	add    $0x10,%esp
80101520:	eb c2                	jmp    801014e4 <bmap+0x44>
80101522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101528:	8b 06                	mov    (%esi),%eax
8010152a:	e8 e1 fc ff ff       	call   80101210 <balloc>
8010152f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101535:	eb 93                	jmp    801014ca <bmap+0x2a>
80101537:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010153e:	00 
8010153f:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
80101540:	8d 5a 18             	lea    0x18(%edx),%ebx
80101543:	8b 3c 98             	mov    (%eax,%ebx,4),%edi
80101546:	85 ff                	test   %edi,%edi
80101548:	75 a6                	jne    801014f0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010154a:	8b 00                	mov    (%eax),%eax
8010154c:	e8 bf fc ff ff       	call   80101210 <balloc>
80101551:	89 04 9e             	mov    %eax,(%esi,%ebx,4)
80101554:	89 c7                	mov    %eax,%edi
}
80101556:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101559:	5b                   	pop    %ebx
8010155a:	89 f8                	mov    %edi,%eax
8010155c:	5e                   	pop    %esi
8010155d:	5f                   	pop    %edi
8010155e:	5d                   	pop    %ebp
8010155f:	c3                   	ret
  panic("bmap: out of range");
80101560:	83 ec 0c             	sub    $0xc,%esp
80101563:	68 01 77 10 80       	push   $0x80107701
80101568:	e8 13 ee ff ff       	call   80100380 <panic>
8010156d:	8d 76 00             	lea    0x0(%esi),%esi

80101570 <readsb>:
{
80101570:	55                   	push   %ebp
80101571:	89 e5                	mov    %esp,%ebp
80101573:	56                   	push   %esi
80101574:	53                   	push   %ebx
80101575:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101578:	83 ec 08             	sub    $0x8,%esp
8010157b:	6a 01                	push   $0x1
8010157d:	ff 75 08             	push   0x8(%ebp)
80101580:	e8 4b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101585:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101588:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010158a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010158d:	6a 1c                	push   $0x1c
8010158f:	50                   	push   %eax
80101590:	56                   	push   %esi
80101591:	e8 1a 33 00 00       	call   801048b0 <memmove>
  brelse(bp);
80101596:	83 c4 10             	add    $0x10,%esp
80101599:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010159c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010159f:	5b                   	pop    %ebx
801015a0:	5e                   	pop    %esi
801015a1:	5d                   	pop    %ebp
  brelse(bp);
801015a2:	e9 49 ec ff ff       	jmp    801001f0 <brelse>
801015a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801015ae:	00 
801015af:	90                   	nop

801015b0 <iinit>:
{
801015b0:	55                   	push   %ebp
801015b1:	89 e5                	mov    %esp,%ebp
801015b3:	53                   	push   %ebx
801015b4:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
801015b9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801015bc:	68 14 77 10 80       	push   $0x80107714
801015c1:	68 60 09 11 80       	push   $0x80110960
801015c6:	e8 65 2f 00 00       	call   80104530 <initlock>
  for(i = 0; i < NINODE; i++) {
801015cb:	83 c4 10             	add    $0x10,%esp
801015ce:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801015d0:	83 ec 08             	sub    $0x8,%esp
801015d3:	68 1b 77 10 80       	push   $0x8010771b
801015d8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801015d9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801015df:	e8 1c 2e 00 00       	call   80104400 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015e4:	83 c4 10             	add    $0x10,%esp
801015e7:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
801015ed:	75 e1                	jne    801015d0 <iinit+0x20>
  bp = bread(dev, 1);
801015ef:	83 ec 08             	sub    $0x8,%esp
801015f2:	6a 01                	push   $0x1
801015f4:	ff 75 08             	push   0x8(%ebp)
801015f7:	e8 d4 ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015fc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015ff:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101601:	8d 40 5c             	lea    0x5c(%eax),%eax
80101604:	6a 1c                	push   $0x1c
80101606:	50                   	push   %eax
80101607:	68 b4 25 11 80       	push   $0x801125b4
8010160c:	e8 9f 32 00 00       	call   801048b0 <memmove>
  brelse(bp);
80101611:	89 1c 24             	mov    %ebx,(%esp)
80101614:	e8 d7 eb ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101619:	ff 35 cc 25 11 80    	push   0x801125cc
8010161f:	ff 35 c8 25 11 80    	push   0x801125c8
80101625:	ff 35 c4 25 11 80    	push   0x801125c4
8010162b:	ff 35 c0 25 11 80    	push   0x801125c0
80101631:	ff 35 bc 25 11 80    	push   0x801125bc
80101637:	ff 35 b8 25 11 80    	push   0x801125b8
8010163d:	ff 35 b4 25 11 80    	push   0x801125b4
80101643:	68 ac 7b 10 80       	push   $0x80107bac
80101648:	e8 63 f0 ff ff       	call   801006b0 <cprintf>
}
8010164d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101650:	83 c4 30             	add    $0x30,%esp
80101653:	c9                   	leave
80101654:	c3                   	ret
80101655:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010165c:	00 
8010165d:	8d 76 00             	lea    0x0(%esi),%esi

80101660 <ialloc>:
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	57                   	push   %edi
80101664:	56                   	push   %esi
80101665:	53                   	push   %ebx
80101666:	83 ec 1c             	sub    $0x1c,%esp
80101669:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010166c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101673:	8b 75 08             	mov    0x8(%ebp),%esi
80101676:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101679:	0f 86 9a 00 00 00    	jbe    80101719 <ialloc+0xb9>
8010167f:	bf 01 00 00 00       	mov    $0x1,%edi
80101684:	eb 21                	jmp    801016a7 <ialloc+0x47>
80101686:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010168d:	00 
8010168e:	66 90                	xchg   %ax,%ax
    brelse(bp);
80101690:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101693:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101696:	53                   	push   %ebx
80101697:	e8 54 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010169c:	83 c4 10             	add    $0x10,%esp
8010169f:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
801016a5:	73 72                	jae    80101719 <ialloc+0xb9>
    bp = bread(dev, IBLOCK(inum, sb));
801016a7:	89 f8                	mov    %edi,%eax
801016a9:	83 ec 08             	sub    $0x8,%esp
801016ac:	c1 e8 03             	shr    $0x3,%eax
801016af:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801016b5:	50                   	push   %eax
801016b6:	56                   	push   %esi
801016b7:	e8 14 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801016bc:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801016bf:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801016c1:	89 f8                	mov    %edi,%eax
801016c3:	83 e0 07             	and    $0x7,%eax
801016c6:	c1 e0 06             	shl    $0x6,%eax
801016c9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801016cd:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016d1:	75 bd                	jne    80101690 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016d3:	83 ec 04             	sub    $0x4,%esp
801016d6:	6a 40                	push   $0x40
801016d8:	6a 00                	push   $0x0
801016da:	51                   	push   %ecx
801016db:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016de:	e8 3d 31 00 00       	call   80104820 <memset>
      dip->type = type;
801016e3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016e6:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016ea:	66 89 01             	mov    %ax,(%ecx)
      dip->mode=0b111;
801016ed:	b8 07 00 00 00       	mov    $0x7,%eax
801016f2:	66 89 41 02          	mov    %ax,0x2(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016f6:	89 1c 24             	mov    %ebx,(%esp)
801016f9:	e8 92 18 00 00       	call   80102f90 <log_write>
      brelse(bp);
801016fe:	89 1c 24             	mov    %ebx,(%esp)
80101701:	e8 ea ea ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80101706:	83 c4 10             	add    $0x10,%esp
}
80101709:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
8010170c:	89 fa                	mov    %edi,%edx
}
8010170e:	5b                   	pop    %ebx
      return iget(dev, inum);
8010170f:	89 f0                	mov    %esi,%eax
}
80101711:	5e                   	pop    %esi
80101712:	5f                   	pop    %edi
80101713:	5d                   	pop    %ebp
      return iget(dev, inum);
80101714:	e9 07 fc ff ff       	jmp    80101320 <iget>
  panic("ialloc: no inodes");
80101719:	83 ec 0c             	sub    $0xc,%esp
8010171c:	68 21 77 10 80       	push   $0x80107721
80101721:	e8 5a ec ff ff       	call   80100380 <panic>
80101726:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010172d:	00 
8010172e:	66 90                	xchg   %ax,%ax

80101730 <iupdate>:
{
80101730:	55                   	push   %ebp
80101731:	89 e5                	mov    %esp,%ebp
80101733:	56                   	push   %esi
80101734:	53                   	push   %ebx
80101735:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101738:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010173b:	83 c3 60             	add    $0x60,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010173e:	83 ec 08             	sub    $0x8,%esp
80101741:	c1 e8 03             	shr    $0x3,%eax
80101744:	03 05 c8 25 11 80    	add    0x801125c8,%eax
8010174a:	50                   	push   %eax
8010174b:	ff 73 a0             	push   -0x60(%ebx)
8010174e:	e8 7d e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101753:	0f b7 53 f2          	movzwl -0xe(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101757:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010175a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010175c:	8b 43 a4             	mov    -0x5c(%ebx),%eax
8010175f:	83 e0 07             	and    $0x7,%eax
80101762:	c1 e0 06             	shl    $0x6,%eax
80101765:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101769:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010176c:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101770:	83 c0 10             	add    $0x10,%eax
  dip->major = ip->major;
80101773:	66 89 50 f4          	mov    %dx,-0xc(%eax)
  dip->minor = ip->minor;
80101777:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
8010177b:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->nlink = ip->nlink;
8010177f:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101783:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->size = ip->size;
80101787:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010178a:	89 50 fc             	mov    %edx,-0x4(%eax)
  dip->mode=ip->mode;
8010178d:	0f b7 53 f0          	movzwl -0x10(%ebx),%edx
80101791:	66 89 50 f2          	mov    %dx,-0xe(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101795:	6a 30                	push   $0x30
80101797:	53                   	push   %ebx
80101798:	50                   	push   %eax
80101799:	e8 12 31 00 00       	call   801048b0 <memmove>
  log_write(bp);
8010179e:	89 34 24             	mov    %esi,(%esp)
801017a1:	e8 ea 17 00 00       	call   80102f90 <log_write>
  brelse(bp);
801017a6:	83 c4 10             	add    $0x10,%esp
801017a9:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017af:	5b                   	pop    %ebx
801017b0:	5e                   	pop    %esi
801017b1:	5d                   	pop    %ebp
  brelse(bp);
801017b2:	e9 39 ea ff ff       	jmp    801001f0 <brelse>
801017b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801017be:	00 
801017bf:	90                   	nop

801017c0 <idup>:
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	53                   	push   %ebx
801017c4:	83 ec 10             	sub    $0x10,%esp
801017c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801017ca:	68 60 09 11 80       	push   $0x80110960
801017cf:	e8 4c 2f 00 00       	call   80104720 <acquire>
  ip->ref++;
801017d4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017d8:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801017df:	e8 dc 2e 00 00       	call   801046c0 <release>
}
801017e4:	89 d8                	mov    %ebx,%eax
801017e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017e9:	c9                   	leave
801017ea:	c3                   	ret
801017eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801017f0 <ilock>:
{
801017f0:	55                   	push   %ebp
801017f1:	89 e5                	mov    %esp,%ebp
801017f3:	56                   	push   %esi
801017f4:	53                   	push   %ebx
801017f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017f8:	85 db                	test   %ebx,%ebx
801017fa:	0f 84 bf 00 00 00    	je     801018bf <ilock+0xcf>
80101800:	8b 53 08             	mov    0x8(%ebx),%edx
80101803:	85 d2                	test   %edx,%edx
80101805:	0f 8e b4 00 00 00    	jle    801018bf <ilock+0xcf>
  acquiresleep(&ip->lock);
8010180b:	83 ec 0c             	sub    $0xc,%esp
8010180e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101811:	50                   	push   %eax
80101812:	e8 29 2c 00 00       	call   80104440 <acquiresleep>
  if(ip->valid == 0){
80101817:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010181a:	83 c4 10             	add    $0x10,%esp
8010181d:	85 c0                	test   %eax,%eax
8010181f:	74 0f                	je     80101830 <ilock+0x40>
}
80101821:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101824:	5b                   	pop    %ebx
80101825:	5e                   	pop    %esi
80101826:	5d                   	pop    %ebp
80101827:	c3                   	ret
80101828:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010182f:	00 
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101830:	8b 43 04             	mov    0x4(%ebx),%eax
80101833:	83 ec 08             	sub    $0x8,%esp
80101836:	c1 e8 03             	shr    $0x3,%eax
80101839:	03 05 c8 25 11 80    	add    0x801125c8,%eax
8010183f:	50                   	push   %eax
80101840:	ff 33                	push   (%ebx)
80101842:	e8 89 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101847:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010184a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010184c:	8b 43 04             	mov    0x4(%ebx),%eax
8010184f:	83 e0 07             	and    $0x7,%eax
80101852:	c1 e0 06             	shl    $0x6,%eax
80101855:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101859:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010185c:	83 c0 10             	add    $0x10,%eax
    ip->type = dip->type;
8010185f:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->major = dip->major;
80101863:	0f b7 50 f4          	movzwl -0xc(%eax),%edx
80101867:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->minor = dip->minor;
8010186b:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
8010186f:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->nlink = dip->nlink;
80101873:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101877:	66 89 53 58          	mov    %dx,0x58(%ebx)
    ip->size = dip->size;
8010187b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010187e:	89 53 5c             	mov    %edx,0x5c(%ebx)
    ip->mode=dip->mode;
80101881:	0f b7 50 f2          	movzwl -0xe(%eax),%edx
80101885:	66 89 53 50          	mov    %dx,0x50(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101889:	6a 30                	push   $0x30
8010188b:	50                   	push   %eax
8010188c:	8d 43 60             	lea    0x60(%ebx),%eax
8010188f:	50                   	push   %eax
80101890:	e8 1b 30 00 00       	call   801048b0 <memmove>
    brelse(bp);
80101895:	89 34 24             	mov    %esi,(%esp)
80101898:	e8 53 e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
8010189d:	83 c4 10             	add    $0x10,%esp
801018a0:	66 83 7b 52 00       	cmpw   $0x0,0x52(%ebx)
    ip->valid = 1;
801018a5:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801018ac:	0f 85 6f ff ff ff    	jne    80101821 <ilock+0x31>
      panic("ilock: no type");
801018b2:	83 ec 0c             	sub    $0xc,%esp
801018b5:	68 39 77 10 80       	push   $0x80107739
801018ba:	e8 c1 ea ff ff       	call   80100380 <panic>
    panic("ilock");
801018bf:	83 ec 0c             	sub    $0xc,%esp
801018c2:	68 33 77 10 80       	push   $0x80107733
801018c7:	e8 b4 ea ff ff       	call   80100380 <panic>
801018cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018d0 <iunlock>:
{
801018d0:	55                   	push   %ebp
801018d1:	89 e5                	mov    %esp,%ebp
801018d3:	56                   	push   %esi
801018d4:	53                   	push   %ebx
801018d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801018d8:	85 db                	test   %ebx,%ebx
801018da:	74 28                	je     80101904 <iunlock+0x34>
801018dc:	83 ec 0c             	sub    $0xc,%esp
801018df:	8d 73 0c             	lea    0xc(%ebx),%esi
801018e2:	56                   	push   %esi
801018e3:	e8 f8 2b 00 00       	call   801044e0 <holdingsleep>
801018e8:	83 c4 10             	add    $0x10,%esp
801018eb:	85 c0                	test   %eax,%eax
801018ed:	74 15                	je     80101904 <iunlock+0x34>
801018ef:	8b 43 08             	mov    0x8(%ebx),%eax
801018f2:	85 c0                	test   %eax,%eax
801018f4:	7e 0e                	jle    80101904 <iunlock+0x34>
  releasesleep(&ip->lock);
801018f6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018ff:	e9 9c 2b 00 00       	jmp    801044a0 <releasesleep>
    panic("iunlock");
80101904:	83 ec 0c             	sub    $0xc,%esp
80101907:	68 48 77 10 80       	push   $0x80107748
8010190c:	e8 6f ea ff ff       	call   80100380 <panic>
80101911:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101918:	00 
80101919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101920 <iput>:
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	57                   	push   %edi
80101924:	56                   	push   %esi
80101925:	53                   	push   %ebx
80101926:	83 ec 28             	sub    $0x28,%esp
80101929:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010192c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010192f:	57                   	push   %edi
80101930:	e8 0b 2b 00 00       	call   80104440 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101935:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101938:	83 c4 10             	add    $0x10,%esp
8010193b:	85 d2                	test   %edx,%edx
8010193d:	74 07                	je     80101946 <iput+0x26>
8010193f:	66 83 7b 58 00       	cmpw   $0x0,0x58(%ebx)
80101944:	74 32                	je     80101978 <iput+0x58>
  releasesleep(&ip->lock);
80101946:	83 ec 0c             	sub    $0xc,%esp
80101949:	57                   	push   %edi
8010194a:	e8 51 2b 00 00       	call   801044a0 <releasesleep>
  acquire(&icache.lock);
8010194f:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101956:	e8 c5 2d 00 00       	call   80104720 <acquire>
  ip->ref--;
8010195b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010195f:	83 c4 10             	add    $0x10,%esp
80101962:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
80101969:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010196c:	5b                   	pop    %ebx
8010196d:	5e                   	pop    %esi
8010196e:	5f                   	pop    %edi
8010196f:	5d                   	pop    %ebp
  release(&icache.lock);
80101970:	e9 4b 2d 00 00       	jmp    801046c0 <release>
80101975:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101978:	83 ec 0c             	sub    $0xc,%esp
8010197b:	68 60 09 11 80       	push   $0x80110960
80101980:	e8 9b 2d 00 00       	call   80104720 <acquire>
    int r = ip->ref;
80101985:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101988:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010198f:	e8 2c 2d 00 00       	call   801046c0 <release>
    if(r == 1){
80101994:	83 c4 10             	add    $0x10,%esp
80101997:	83 fe 01             	cmp    $0x1,%esi
8010199a:	75 aa                	jne    80101946 <iput+0x26>
8010199c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801019a2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801019a5:	8d 73 60             	lea    0x60(%ebx),%esi
801019a8:	89 df                	mov    %ebx,%edi
801019aa:	89 cb                	mov    %ecx,%ebx
801019ac:	eb 09                	jmp    801019b7 <iput+0x97>
801019ae:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801019b0:	83 c6 04             	add    $0x4,%esi
801019b3:	39 de                	cmp    %ebx,%esi
801019b5:	74 19                	je     801019d0 <iput+0xb0>
    if(ip->addrs[i]){
801019b7:	8b 16                	mov    (%esi),%edx
801019b9:	85 d2                	test   %edx,%edx
801019bb:	74 f3                	je     801019b0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801019bd:	8b 07                	mov    (%edi),%eax
801019bf:	e8 5c fa ff ff       	call   80101420 <bfree>
      ip->addrs[i] = 0;
801019c4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801019ca:	eb e4                	jmp    801019b0 <iput+0x90>
801019cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801019d0:	89 fb                	mov    %edi,%ebx
801019d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019d5:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801019db:	85 c0                	test   %eax,%eax
801019dd:	75 2d                	jne    80101a0c <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801019df:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801019e2:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
  iupdate(ip);
801019e9:	53                   	push   %ebx
801019ea:	e8 41 fd ff ff       	call   80101730 <iupdate>
      ip->type = 0;
801019ef:	31 c0                	xor    %eax,%eax
801019f1:	66 89 43 52          	mov    %ax,0x52(%ebx)
      iupdate(ip);
801019f5:	89 1c 24             	mov    %ebx,(%esp)
801019f8:	e8 33 fd ff ff       	call   80101730 <iupdate>
      ip->valid = 0;
801019fd:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101a04:	83 c4 10             	add    $0x10,%esp
80101a07:	e9 3a ff ff ff       	jmp    80101946 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101a0c:	83 ec 08             	sub    $0x8,%esp
80101a0f:	50                   	push   %eax
80101a10:	ff 33                	push   (%ebx)
80101a12:	e8 b9 e6 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
80101a17:	83 c4 10             	add    $0x10,%esp
80101a1a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101a1d:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101a23:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101a26:	8d 70 5c             	lea    0x5c(%eax),%esi
80101a29:	89 cf                	mov    %ecx,%edi
80101a2b:	eb 0a                	jmp    80101a37 <iput+0x117>
80101a2d:	8d 76 00             	lea    0x0(%esi),%esi
80101a30:	83 c6 04             	add    $0x4,%esi
80101a33:	39 fe                	cmp    %edi,%esi
80101a35:	74 0f                	je     80101a46 <iput+0x126>
      if(a[j])
80101a37:	8b 16                	mov    (%esi),%edx
80101a39:	85 d2                	test   %edx,%edx
80101a3b:	74 f3                	je     80101a30 <iput+0x110>
        bfree(ip->dev, a[j]);
80101a3d:	8b 03                	mov    (%ebx),%eax
80101a3f:	e8 dc f9 ff ff       	call   80101420 <bfree>
80101a44:	eb ea                	jmp    80101a30 <iput+0x110>
    brelse(bp);
80101a46:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101a49:	83 ec 0c             	sub    $0xc,%esp
80101a4c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a4f:	50                   	push   %eax
80101a50:	e8 9b e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a55:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a5b:	8b 03                	mov    (%ebx),%eax
80101a5d:	e8 be f9 ff ff       	call   80101420 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a62:	83 c4 10             	add    $0x10,%esp
80101a65:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a6c:	00 00 00 
80101a6f:	e9 6b ff ff ff       	jmp    801019df <iput+0xbf>
80101a74:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101a7b:	00 
80101a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a80 <iunlockput>:
{
80101a80:	55                   	push   %ebp
80101a81:	89 e5                	mov    %esp,%ebp
80101a83:	56                   	push   %esi
80101a84:	53                   	push   %ebx
80101a85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a88:	85 db                	test   %ebx,%ebx
80101a8a:	74 34                	je     80101ac0 <iunlockput+0x40>
80101a8c:	83 ec 0c             	sub    $0xc,%esp
80101a8f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a92:	56                   	push   %esi
80101a93:	e8 48 2a 00 00       	call   801044e0 <holdingsleep>
80101a98:	83 c4 10             	add    $0x10,%esp
80101a9b:	85 c0                	test   %eax,%eax
80101a9d:	74 21                	je     80101ac0 <iunlockput+0x40>
80101a9f:	8b 43 08             	mov    0x8(%ebx),%eax
80101aa2:	85 c0                	test   %eax,%eax
80101aa4:	7e 1a                	jle    80101ac0 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101aa6:	83 ec 0c             	sub    $0xc,%esp
80101aa9:	56                   	push   %esi
80101aaa:	e8 f1 29 00 00       	call   801044a0 <releasesleep>
  iput(ip);
80101aaf:	83 c4 10             	add    $0x10,%esp
80101ab2:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101ab5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ab8:	5b                   	pop    %ebx
80101ab9:	5e                   	pop    %esi
80101aba:	5d                   	pop    %ebp
  iput(ip);
80101abb:	e9 60 fe ff ff       	jmp    80101920 <iput>
    panic("iunlock");
80101ac0:	83 ec 0c             	sub    $0xc,%esp
80101ac3:	68 48 77 10 80       	push   $0x80107748
80101ac8:	e8 b3 e8 ff ff       	call   80100380 <panic>
80101acd:	8d 76 00             	lea    0x0(%esi),%esi

80101ad0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101ad0:	55                   	push   %ebp
80101ad1:	89 e5                	mov    %esp,%ebp
80101ad3:	8b 55 08             	mov    0x8(%ebp),%edx
80101ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101ad9:	8b 0a                	mov    (%edx),%ecx
80101adb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101ade:	8b 4a 04             	mov    0x4(%edx),%ecx
80101ae1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101ae4:	0f b7 4a 52          	movzwl 0x52(%edx),%ecx
80101ae8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101aeb:	0f b7 4a 58          	movzwl 0x58(%edx),%ecx
80101aef:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101af3:	8b 4a 5c             	mov    0x5c(%edx),%ecx
80101af6:	89 48 10             	mov    %ecx,0x10(%eax)
  st->mode=ip->mode;
80101af9:	0f b7 52 50          	movzwl 0x50(%edx),%edx
80101afd:	66 89 50 14          	mov    %dx,0x14(%eax)
}
80101b01:	5d                   	pop    %ebp
80101b02:	c3                   	ret
80101b03:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101b0a:	00 
80101b0b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101b10 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101b10:	55                   	push   %ebp
80101b11:	89 e5                	mov    %esp,%ebp
80101b13:	57                   	push   %edi
80101b14:	56                   	push   %esi
80101b15:	53                   	push   %ebx
80101b16:	83 ec 1c             	sub    $0x1c,%esp
80101b19:	8b 75 08             	mov    0x8(%ebp),%esi
80101b1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b1f:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b22:	66 83 7e 52 03       	cmpw   $0x3,0x52(%esi)
{
80101b27:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101b2a:	89 75 d8             	mov    %esi,-0x28(%ebp)
80101b2d:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80101b30:	0f 84 aa 00 00 00    	je     80101be0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101b36:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101b39:	8b 56 5c             	mov    0x5c(%esi),%edx
80101b3c:	39 fa                	cmp    %edi,%edx
80101b3e:	0f 82 bd 00 00 00    	jb     80101c01 <readi+0xf1>
80101b44:	89 f9                	mov    %edi,%ecx
80101b46:	31 db                	xor    %ebx,%ebx
80101b48:	01 c1                	add    %eax,%ecx
80101b4a:	0f 92 c3             	setb   %bl
80101b4d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101b50:	0f 82 ab 00 00 00    	jb     80101c01 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b56:	89 d3                	mov    %edx,%ebx
80101b58:	29 fb                	sub    %edi,%ebx
80101b5a:	39 ca                	cmp    %ecx,%edx
80101b5c:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b5f:	85 c0                	test   %eax,%eax
80101b61:	74 73                	je     80101bd6 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101b63:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101b66:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b70:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b73:	89 fa                	mov    %edi,%edx
80101b75:	c1 ea 09             	shr    $0x9,%edx
80101b78:	89 d8                	mov    %ebx,%eax
80101b7a:	e8 21 f9 ff ff       	call   801014a0 <bmap>
80101b7f:	83 ec 08             	sub    $0x8,%esp
80101b82:	50                   	push   %eax
80101b83:	ff 33                	push   (%ebx)
80101b85:	e8 46 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b8a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b8d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b92:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b94:	89 f8                	mov    %edi,%eax
80101b96:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b9b:	29 f3                	sub    %esi,%ebx
80101b9d:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b9f:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101ba3:	39 d9                	cmp    %ebx,%ecx
80101ba5:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101ba8:	83 c4 0c             	add    $0xc,%esp
80101bab:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bac:	01 de                	add    %ebx,%esi
80101bae:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101bb0:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101bb3:	50                   	push   %eax
80101bb4:	ff 75 e0             	push   -0x20(%ebp)
80101bb7:	e8 f4 2c 00 00       	call   801048b0 <memmove>
    brelse(bp);
80101bbc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101bbf:	89 14 24             	mov    %edx,(%esp)
80101bc2:	e8 29 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bc7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101bca:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101bcd:	83 c4 10             	add    $0x10,%esp
80101bd0:	39 de                	cmp    %ebx,%esi
80101bd2:	72 9c                	jb     80101b70 <readi+0x60>
80101bd4:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80101bd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bd9:	5b                   	pop    %ebx
80101bda:	5e                   	pop    %esi
80101bdb:	5f                   	pop    %edi
80101bdc:	5d                   	pop    %ebp
80101bdd:	c3                   	ret
80101bde:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101be0:	0f bf 56 54          	movswl 0x54(%esi),%edx
80101be4:	66 83 fa 09          	cmp    $0x9,%dx
80101be8:	77 17                	ja     80101c01 <readi+0xf1>
80101bea:	8b 14 d5 00 09 11 80 	mov    -0x7feef700(,%edx,8),%edx
80101bf1:	85 d2                	test   %edx,%edx
80101bf3:	74 0c                	je     80101c01 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101bf5:	89 45 10             	mov    %eax,0x10(%ebp)
}
80101bf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bfb:	5b                   	pop    %ebx
80101bfc:	5e                   	pop    %esi
80101bfd:	5f                   	pop    %edi
80101bfe:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101bff:	ff e2                	jmp    *%edx
      return -1;
80101c01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c06:	eb ce                	jmp    80101bd6 <readi+0xc6>
80101c08:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101c0f:	00 

80101c10 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101c10:	55                   	push   %ebp
80101c11:	89 e5                	mov    %esp,%ebp
80101c13:	57                   	push   %edi
80101c14:	56                   	push   %esi
80101c15:	53                   	push   %ebx
80101c16:	83 ec 1c             	sub    $0x1c,%esp
80101c19:	8b 45 08             	mov    0x8(%ebp),%eax
80101c1c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101c1f:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c22:	66 83 78 52 03       	cmpw   $0x3,0x52(%eax)
{
80101c27:	89 7d dc             	mov    %edi,-0x24(%ebp)
80101c2a:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101c2d:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80101c30:	0f 84 ba 00 00 00    	je     80101cf0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c36:	39 78 5c             	cmp    %edi,0x5c(%eax)
80101c39:	0f 82 ea 00 00 00    	jb     80101d29 <writei+0x119>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c3f:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101c42:	89 f2                	mov    %esi,%edx
80101c44:	01 fa                	add    %edi,%edx
80101c46:	0f 82 dd 00 00 00    	jb     80101d29 <writei+0x119>
80101c4c:	81 fa 00 16 01 00    	cmp    $0x11600,%edx
80101c52:	0f 87 d1 00 00 00    	ja     80101d29 <writei+0x119>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c58:	85 f6                	test   %esi,%esi
80101c5a:	0f 84 85 00 00 00    	je     80101ce5 <writei+0xd5>
80101c60:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101c67:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c70:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101c73:	89 fa                	mov    %edi,%edx
80101c75:	c1 ea 09             	shr    $0x9,%edx
80101c78:	89 f0                	mov    %esi,%eax
80101c7a:	e8 21 f8 ff ff       	call   801014a0 <bmap>
80101c7f:	83 ec 08             	sub    $0x8,%esp
80101c82:	50                   	push   %eax
80101c83:	ff 36                	push   (%esi)
80101c85:	e8 46 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c8a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101c8d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c90:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c95:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c97:	89 f8                	mov    %edi,%eax
80101c99:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c9e:	29 d3                	sub    %edx,%ebx
80101ca0:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101ca2:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101ca6:	39 d9                	cmp    %ebx,%ecx
80101ca8:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101cab:	83 c4 0c             	add    $0xc,%esp
80101cae:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101caf:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80101cb1:	ff 75 dc             	push   -0x24(%ebp)
80101cb4:	50                   	push   %eax
80101cb5:	e8 f6 2b 00 00       	call   801048b0 <memmove>
    log_write(bp);
80101cba:	89 34 24             	mov    %esi,(%esp)
80101cbd:	e8 ce 12 00 00       	call   80102f90 <log_write>
    brelse(bp);
80101cc2:	89 34 24             	mov    %esi,(%esp)
80101cc5:	e8 26 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cca:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101ccd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101cd0:	83 c4 10             	add    $0x10,%esp
80101cd3:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101cd6:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101cd9:	39 d8                	cmp    %ebx,%eax
80101cdb:	72 93                	jb     80101c70 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101cdd:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101ce0:	39 78 5c             	cmp    %edi,0x5c(%eax)
80101ce3:	72 33                	jb     80101d18 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101ce5:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101ce8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ceb:	5b                   	pop    %ebx
80101cec:	5e                   	pop    %esi
80101ced:	5f                   	pop    %edi
80101cee:	5d                   	pop    %ebp
80101cef:	c3                   	ret
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101cf0:	0f bf 40 54          	movswl 0x54(%eax),%eax
80101cf4:	66 83 f8 09          	cmp    $0x9,%ax
80101cf8:	77 2f                	ja     80101d29 <writei+0x119>
80101cfa:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101d01:	85 c0                	test   %eax,%eax
80101d03:	74 24                	je     80101d29 <writei+0x119>
    return devsw[ip->major].write(ip, src, n);
80101d05:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101d08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d0b:	5b                   	pop    %ebx
80101d0c:	5e                   	pop    %esi
80101d0d:	5f                   	pop    %edi
80101d0e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101d0f:	ff e0                	jmp    *%eax
80101d11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80101d18:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101d1b:	89 78 5c             	mov    %edi,0x5c(%eax)
    iupdate(ip);
80101d1e:	50                   	push   %eax
80101d1f:	e8 0c fa ff ff       	call   80101730 <iupdate>
80101d24:	83 c4 10             	add    $0x10,%esp
80101d27:	eb bc                	jmp    80101ce5 <writei+0xd5>
      return -1;
80101d29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d2e:	eb b8                	jmp    80101ce8 <writei+0xd8>

80101d30 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101d30:	55                   	push   %ebp
80101d31:	89 e5                	mov    %esp,%ebp
80101d33:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101d36:	6a 0e                	push   $0xe
80101d38:	ff 75 0c             	push   0xc(%ebp)
80101d3b:	ff 75 08             	push   0x8(%ebp)
80101d3e:	e8 dd 2b 00 00       	call   80104920 <strncmp>
}
80101d43:	c9                   	leave
80101d44:	c3                   	ret
80101d45:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101d4c:	00 
80101d4d:	8d 76 00             	lea    0x0(%esi),%esi

80101d50 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d50:	55                   	push   %ebp
80101d51:	89 e5                	mov    %esp,%ebp
80101d53:	57                   	push   %edi
80101d54:	56                   	push   %esi
80101d55:	53                   	push   %ebx
80101d56:	83 ec 1c             	sub    $0x1c,%esp
80101d59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d5c:	66 83 7b 52 01       	cmpw   $0x1,0x52(%ebx)
80101d61:	0f 85 85 00 00 00    	jne    80101dec <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d67:	8b 53 5c             	mov    0x5c(%ebx),%edx
80101d6a:	31 ff                	xor    %edi,%edi
80101d6c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d6f:	85 d2                	test   %edx,%edx
80101d71:	74 3e                	je     80101db1 <dirlookup+0x61>
80101d73:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d78:	6a 10                	push   $0x10
80101d7a:	57                   	push   %edi
80101d7b:	56                   	push   %esi
80101d7c:	53                   	push   %ebx
80101d7d:	e8 8e fd ff ff       	call   80101b10 <readi>
80101d82:	83 c4 10             	add    $0x10,%esp
80101d85:	83 f8 10             	cmp    $0x10,%eax
80101d88:	75 55                	jne    80101ddf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d8a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d8f:	74 18                	je     80101da9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d91:	83 ec 04             	sub    $0x4,%esp
80101d94:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d97:	6a 0e                	push   $0xe
80101d99:	50                   	push   %eax
80101d9a:	ff 75 0c             	push   0xc(%ebp)
80101d9d:	e8 7e 2b 00 00       	call   80104920 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101da2:	83 c4 10             	add    $0x10,%esp
80101da5:	85 c0                	test   %eax,%eax
80101da7:	74 17                	je     80101dc0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101da9:	83 c7 10             	add    $0x10,%edi
80101dac:	3b 7b 5c             	cmp    0x5c(%ebx),%edi
80101daf:	72 c7                	jb     80101d78 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101db1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101db4:	31 c0                	xor    %eax,%eax
}
80101db6:	5b                   	pop    %ebx
80101db7:	5e                   	pop    %esi
80101db8:	5f                   	pop    %edi
80101db9:	5d                   	pop    %ebp
80101dba:	c3                   	ret
80101dbb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(poff)
80101dc0:	8b 45 10             	mov    0x10(%ebp),%eax
80101dc3:	85 c0                	test   %eax,%eax
80101dc5:	74 05                	je     80101dcc <dirlookup+0x7c>
        *poff = off;
80101dc7:	8b 45 10             	mov    0x10(%ebp),%eax
80101dca:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101dcc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101dd0:	8b 03                	mov    (%ebx),%eax
80101dd2:	e8 49 f5 ff ff       	call   80101320 <iget>
}
80101dd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dda:	5b                   	pop    %ebx
80101ddb:	5e                   	pop    %esi
80101ddc:	5f                   	pop    %edi
80101ddd:	5d                   	pop    %ebp
80101dde:	c3                   	ret
      panic("dirlookup read");
80101ddf:	83 ec 0c             	sub    $0xc,%esp
80101de2:	68 62 77 10 80       	push   $0x80107762
80101de7:	e8 94 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101dec:	83 ec 0c             	sub    $0xc,%esp
80101def:	68 50 77 10 80       	push   $0x80107750
80101df4:	e8 87 e5 ff ff       	call   80100380 <panic>
80101df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e00 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101e00:	55                   	push   %ebp
80101e01:	89 e5                	mov    %esp,%ebp
80101e03:	57                   	push   %edi
80101e04:	56                   	push   %esi
80101e05:	53                   	push   %ebx
80101e06:	89 c3                	mov    %eax,%ebx
80101e08:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101e0b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101e0e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e11:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101e14:	0f 84 ae 01 00 00    	je     80101fc8 <namex+0x1c8>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101e1a:	e8 c1 1b 00 00       	call   801039e0 <myproc>
  acquire(&icache.lock);
80101e1f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101e22:	8b b0 c8 00 00 00    	mov    0xc8(%eax),%esi
  acquire(&icache.lock);
80101e28:	68 60 09 11 80       	push   $0x80110960
80101e2d:	e8 ee 28 00 00       	call   80104720 <acquire>
  ip->ref++;
80101e32:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101e36:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101e3d:	e8 7e 28 00 00       	call   801046c0 <release>
80101e42:	83 c4 10             	add    $0x10,%esp
80101e45:	eb 0c                	jmp    80101e53 <namex+0x53>
80101e47:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101e4e:	00 
80101e4f:	90                   	nop
    path++;
80101e50:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e53:	0f b6 03             	movzbl (%ebx),%eax
80101e56:	3c 2f                	cmp    $0x2f,%al
80101e58:	74 f6                	je     80101e50 <namex+0x50>
  if(*path == 0)
80101e5a:	84 c0                	test   %al,%al
80101e5c:	0f 84 0e 01 00 00    	je     80101f70 <namex+0x170>
  while(*path != '/' && *path != 0)
80101e62:	0f b6 03             	movzbl (%ebx),%eax
80101e65:	84 c0                	test   %al,%al
80101e67:	0f 84 18 01 00 00    	je     80101f85 <namex+0x185>
80101e6d:	89 df                	mov    %ebx,%edi
80101e6f:	3c 2f                	cmp    $0x2f,%al
80101e71:	0f 84 0e 01 00 00    	je     80101f85 <namex+0x185>
80101e77:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101e7e:	00 
80101e7f:	90                   	nop
80101e80:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e84:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e87:	3c 2f                	cmp    $0x2f,%al
80101e89:	74 04                	je     80101e8f <namex+0x8f>
80101e8b:	84 c0                	test   %al,%al
80101e8d:	75 f1                	jne    80101e80 <namex+0x80>
  len = path - s;
80101e8f:	89 f8                	mov    %edi,%eax
80101e91:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e93:	83 f8 0d             	cmp    $0xd,%eax
80101e96:	0f 8e ac 00 00 00    	jle    80101f48 <namex+0x148>
    memmove(name, s, DIRSIZ);
80101e9c:	83 ec 04             	sub    $0x4,%esp
80101e9f:	6a 0e                	push   $0xe
80101ea1:	53                   	push   %ebx
80101ea2:	89 fb                	mov    %edi,%ebx
80101ea4:	ff 75 e4             	push   -0x1c(%ebp)
80101ea7:	e8 04 2a 00 00       	call   801048b0 <memmove>
80101eac:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101eaf:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101eb2:	75 0c                	jne    80101ec0 <namex+0xc0>
80101eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101eb8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ebb:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101ebe:	74 f8                	je     80101eb8 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101ec0:	83 ec 0c             	sub    $0xc,%esp
80101ec3:	56                   	push   %esi
80101ec4:	e8 27 f9 ff ff       	call   801017f0 <ilock>
    if(ip->type != T_DIR){
80101ec9:	83 c4 10             	add    $0x10,%esp
80101ecc:	66 83 7e 52 01       	cmpw   $0x1,0x52(%esi)
80101ed1:	0f 85 b7 00 00 00    	jne    80101f8e <namex+0x18e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101ed7:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101eda:	85 c0                	test   %eax,%eax
80101edc:	74 09                	je     80101ee7 <namex+0xe7>
80101ede:	80 3b 00             	cmpb   $0x0,(%ebx)
80101ee1:	0f 84 f7 00 00 00    	je     80101fde <namex+0x1de>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101ee7:	83 ec 04             	sub    $0x4,%esp
80101eea:	6a 00                	push   $0x0
80101eec:	ff 75 e4             	push   -0x1c(%ebp)
80101eef:	56                   	push   %esi
80101ef0:	e8 5b fe ff ff       	call   80101d50 <dirlookup>
80101ef5:	83 c4 10             	add    $0x10,%esp
80101ef8:	89 c7                	mov    %eax,%edi
80101efa:	85 c0                	test   %eax,%eax
80101efc:	0f 84 8c 00 00 00    	je     80101f8e <namex+0x18e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f02:	83 ec 0c             	sub    $0xc,%esp
80101f05:	8d 4e 0c             	lea    0xc(%esi),%ecx
80101f08:	51                   	push   %ecx
80101f09:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101f0c:	e8 cf 25 00 00       	call   801044e0 <holdingsleep>
80101f11:	83 c4 10             	add    $0x10,%esp
80101f14:	85 c0                	test   %eax,%eax
80101f16:	0f 84 02 01 00 00    	je     8010201e <namex+0x21e>
80101f1c:	8b 56 08             	mov    0x8(%esi),%edx
80101f1f:	85 d2                	test   %edx,%edx
80101f21:	0f 8e f7 00 00 00    	jle    8010201e <namex+0x21e>
  releasesleep(&ip->lock);
80101f27:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101f2a:	83 ec 0c             	sub    $0xc,%esp
80101f2d:	51                   	push   %ecx
80101f2e:	e8 6d 25 00 00       	call   801044a0 <releasesleep>
  iput(ip);
80101f33:	89 34 24             	mov    %esi,(%esp)
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101f36:	89 fe                	mov    %edi,%esi
  iput(ip);
80101f38:	e8 e3 f9 ff ff       	call   80101920 <iput>
80101f3d:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101f40:	e9 0e ff ff ff       	jmp    80101e53 <namex+0x53>
80101f45:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101f48:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f4b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    memmove(name, s, len);
80101f4e:	83 ec 04             	sub    $0x4,%esp
80101f51:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101f54:	50                   	push   %eax
80101f55:	53                   	push   %ebx
    name[len] = 0;
80101f56:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101f58:	ff 75 e4             	push   -0x1c(%ebp)
80101f5b:	e8 50 29 00 00       	call   801048b0 <memmove>
    name[len] = 0;
80101f60:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101f63:	83 c4 10             	add    $0x10,%esp
80101f66:	c6 01 00             	movb   $0x0,(%ecx)
80101f69:	e9 41 ff ff ff       	jmp    80101eaf <namex+0xaf>
80101f6e:	66 90                	xchg   %ax,%ax
  }
  if(nameiparent){
80101f70:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f73:	85 c0                	test   %eax,%eax
80101f75:	0f 85 93 00 00 00    	jne    8010200e <namex+0x20e>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f7e:	89 f0                	mov    %esi,%eax
80101f80:	5b                   	pop    %ebx
80101f81:	5e                   	pop    %esi
80101f82:	5f                   	pop    %edi
80101f83:	5d                   	pop    %ebp
80101f84:	c3                   	ret
  while(*path != '/' && *path != 0)
80101f85:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f88:	89 df                	mov    %ebx,%edi
80101f8a:	31 c0                	xor    %eax,%eax
80101f8c:	eb c0                	jmp    80101f4e <namex+0x14e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f8e:	83 ec 0c             	sub    $0xc,%esp
80101f91:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f94:	53                   	push   %ebx
80101f95:	e8 46 25 00 00       	call   801044e0 <holdingsleep>
80101f9a:	83 c4 10             	add    $0x10,%esp
80101f9d:	85 c0                	test   %eax,%eax
80101f9f:	74 7d                	je     8010201e <namex+0x21e>
80101fa1:	8b 4e 08             	mov    0x8(%esi),%ecx
80101fa4:	85 c9                	test   %ecx,%ecx
80101fa6:	7e 76                	jle    8010201e <namex+0x21e>
  releasesleep(&ip->lock);
80101fa8:	83 ec 0c             	sub    $0xc,%esp
80101fab:	53                   	push   %ebx
80101fac:	e8 ef 24 00 00       	call   801044a0 <releasesleep>
  iput(ip);
80101fb1:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101fb4:	31 f6                	xor    %esi,%esi
  iput(ip);
80101fb6:	e8 65 f9 ff ff       	call   80101920 <iput>
      return 0;
80101fbb:	83 c4 10             	add    $0x10,%esp
}
80101fbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fc1:	89 f0                	mov    %esi,%eax
80101fc3:	5b                   	pop    %ebx
80101fc4:	5e                   	pop    %esi
80101fc5:	5f                   	pop    %edi
80101fc6:	5d                   	pop    %ebp
80101fc7:	c3                   	ret
    ip = iget(ROOTDEV, ROOTINO);
80101fc8:	ba 01 00 00 00       	mov    $0x1,%edx
80101fcd:	b8 01 00 00 00       	mov    $0x1,%eax
80101fd2:	e8 49 f3 ff ff       	call   80101320 <iget>
80101fd7:	89 c6                	mov    %eax,%esi
80101fd9:	e9 75 fe ff ff       	jmp    80101e53 <namex+0x53>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fde:	83 ec 0c             	sub    $0xc,%esp
80101fe1:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101fe4:	53                   	push   %ebx
80101fe5:	e8 f6 24 00 00       	call   801044e0 <holdingsleep>
80101fea:	83 c4 10             	add    $0x10,%esp
80101fed:	85 c0                	test   %eax,%eax
80101fef:	74 2d                	je     8010201e <namex+0x21e>
80101ff1:	8b 7e 08             	mov    0x8(%esi),%edi
80101ff4:	85 ff                	test   %edi,%edi
80101ff6:	7e 26                	jle    8010201e <namex+0x21e>
  releasesleep(&ip->lock);
80101ff8:	83 ec 0c             	sub    $0xc,%esp
80101ffb:	53                   	push   %ebx
80101ffc:	e8 9f 24 00 00       	call   801044a0 <releasesleep>
}
80102001:	83 c4 10             	add    $0x10,%esp
}
80102004:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102007:	89 f0                	mov    %esi,%eax
80102009:	5b                   	pop    %ebx
8010200a:	5e                   	pop    %esi
8010200b:	5f                   	pop    %edi
8010200c:	5d                   	pop    %ebp
8010200d:	c3                   	ret
    iput(ip);
8010200e:	83 ec 0c             	sub    $0xc,%esp
80102011:	56                   	push   %esi
      return 0;
80102012:	31 f6                	xor    %esi,%esi
    iput(ip);
80102014:	e8 07 f9 ff ff       	call   80101920 <iput>
    return 0;
80102019:	83 c4 10             	add    $0x10,%esp
8010201c:	eb a0                	jmp    80101fbe <namex+0x1be>
    panic("iunlock");
8010201e:	83 ec 0c             	sub    $0xc,%esp
80102021:	68 48 77 10 80       	push   $0x80107748
80102026:	e8 55 e3 ff ff       	call   80100380 <panic>
8010202b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102030 <dirlink>:
{
80102030:	55                   	push   %ebp
80102031:	89 e5                	mov    %esp,%ebp
80102033:	57                   	push   %edi
80102034:	56                   	push   %esi
80102035:	53                   	push   %ebx
80102036:	83 ec 20             	sub    $0x20,%esp
80102039:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010203c:	6a 00                	push   $0x0
8010203e:	ff 75 0c             	push   0xc(%ebp)
80102041:	53                   	push   %ebx
80102042:	e8 09 fd ff ff       	call   80101d50 <dirlookup>
80102047:	83 c4 10             	add    $0x10,%esp
8010204a:	85 c0                	test   %eax,%eax
8010204c:	75 67                	jne    801020b5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010204e:	8b 7b 5c             	mov    0x5c(%ebx),%edi
80102051:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102054:	85 ff                	test   %edi,%edi
80102056:	74 29                	je     80102081 <dirlink+0x51>
80102058:	31 ff                	xor    %edi,%edi
8010205a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010205d:	eb 09                	jmp    80102068 <dirlink+0x38>
8010205f:	90                   	nop
80102060:	83 c7 10             	add    $0x10,%edi
80102063:	3b 7b 5c             	cmp    0x5c(%ebx),%edi
80102066:	73 19                	jae    80102081 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102068:	6a 10                	push   $0x10
8010206a:	57                   	push   %edi
8010206b:	56                   	push   %esi
8010206c:	53                   	push   %ebx
8010206d:	e8 9e fa ff ff       	call   80101b10 <readi>
80102072:	83 c4 10             	add    $0x10,%esp
80102075:	83 f8 10             	cmp    $0x10,%eax
80102078:	75 4e                	jne    801020c8 <dirlink+0x98>
    if(de.inum == 0)
8010207a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010207f:	75 df                	jne    80102060 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102081:	83 ec 04             	sub    $0x4,%esp
80102084:	8d 45 da             	lea    -0x26(%ebp),%eax
80102087:	6a 0e                	push   $0xe
80102089:	ff 75 0c             	push   0xc(%ebp)
8010208c:	50                   	push   %eax
8010208d:	e8 de 28 00 00       	call   80104970 <strncpy>
  de.inum = inum;
80102092:	8b 45 10             	mov    0x10(%ebp),%eax
80102095:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102099:	6a 10                	push   $0x10
8010209b:	57                   	push   %edi
8010209c:	56                   	push   %esi
8010209d:	53                   	push   %ebx
8010209e:	e8 6d fb ff ff       	call   80101c10 <writei>
801020a3:	83 c4 20             	add    $0x20,%esp
801020a6:	83 f8 10             	cmp    $0x10,%eax
801020a9:	75 2a                	jne    801020d5 <dirlink+0xa5>
  return 0;
801020ab:	31 c0                	xor    %eax,%eax
}
801020ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020b0:	5b                   	pop    %ebx
801020b1:	5e                   	pop    %esi
801020b2:	5f                   	pop    %edi
801020b3:	5d                   	pop    %ebp
801020b4:	c3                   	ret
    iput(ip);
801020b5:	83 ec 0c             	sub    $0xc,%esp
801020b8:	50                   	push   %eax
801020b9:	e8 62 f8 ff ff       	call   80101920 <iput>
    return -1;
801020be:	83 c4 10             	add    $0x10,%esp
801020c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020c6:	eb e5                	jmp    801020ad <dirlink+0x7d>
      panic("dirlink read");
801020c8:	83 ec 0c             	sub    $0xc,%esp
801020cb:	68 71 77 10 80       	push   $0x80107771
801020d0:	e8 ab e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
801020d5:	83 ec 0c             	sub    $0xc,%esp
801020d8:	68 e4 79 10 80       	push   $0x801079e4
801020dd:	e8 9e e2 ff ff       	call   80100380 <panic>
801020e2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801020e9:	00 
801020ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801020f0 <namei>:

struct inode*
namei(char *path)
{
801020f0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020f1:	31 d2                	xor    %edx,%edx
{
801020f3:	89 e5                	mov    %esp,%ebp
801020f5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020f8:	8b 45 08             	mov    0x8(%ebp),%eax
801020fb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020fe:	e8 fd fc ff ff       	call   80101e00 <namex>
}
80102103:	c9                   	leave
80102104:	c3                   	ret
80102105:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010210c:	00 
8010210d:	8d 76 00             	lea    0x0(%esi),%esi

80102110 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102110:	55                   	push   %ebp
  return namex(path, 1, name);
80102111:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102116:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102118:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010211b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010211e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010211f:	e9 dc fc ff ff       	jmp    80101e00 <namex>
80102124:	66 90                	xchg   %ax,%ax
80102126:	66 90                	xchg   %ax,%ax
80102128:	66 90                	xchg   %ax,%ax
8010212a:	66 90                	xchg   %ax,%ax
8010212c:	66 90                	xchg   %ax,%ax
8010212e:	66 90                	xchg   %ax,%ax

80102130 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102130:	55                   	push   %ebp
80102131:	89 e5                	mov    %esp,%ebp
80102133:	57                   	push   %edi
80102134:	56                   	push   %esi
80102135:	53                   	push   %ebx
80102136:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102139:	85 c0                	test   %eax,%eax
8010213b:	0f 84 b4 00 00 00    	je     801021f5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102141:	8b 70 08             	mov    0x8(%eax),%esi
80102144:	89 c3                	mov    %eax,%ebx
80102146:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010214c:	0f 87 96 00 00 00    	ja     801021e8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102152:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102157:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010215e:	00 
8010215f:	90                   	nop
80102160:	89 ca                	mov    %ecx,%edx
80102162:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102163:	83 e0 c0             	and    $0xffffffc0,%eax
80102166:	3c 40                	cmp    $0x40,%al
80102168:	75 f6                	jne    80102160 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010216a:	31 ff                	xor    %edi,%edi
8010216c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102171:	89 f8                	mov    %edi,%eax
80102173:	ee                   	out    %al,(%dx)
80102174:	b8 01 00 00 00       	mov    $0x1,%eax
80102179:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010217e:	ee                   	out    %al,(%dx)
8010217f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102184:	89 f0                	mov    %esi,%eax
80102186:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102187:	89 f0                	mov    %esi,%eax
80102189:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010218e:	c1 f8 08             	sar    $0x8,%eax
80102191:	ee                   	out    %al,(%dx)
80102192:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102197:	89 f8                	mov    %edi,%eax
80102199:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010219a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010219e:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021a3:	c1 e0 04             	shl    $0x4,%eax
801021a6:	83 e0 10             	and    $0x10,%eax
801021a9:	83 c8 e0             	or     $0xffffffe0,%eax
801021ac:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801021ad:	f6 03 04             	testb  $0x4,(%ebx)
801021b0:	75 16                	jne    801021c8 <idestart+0x98>
801021b2:	b8 20 00 00 00       	mov    $0x20,%eax
801021b7:	89 ca                	mov    %ecx,%edx
801021b9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801021ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021bd:	5b                   	pop    %ebx
801021be:	5e                   	pop    %esi
801021bf:	5f                   	pop    %edi
801021c0:	5d                   	pop    %ebp
801021c1:	c3                   	ret
801021c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021c8:	b8 30 00 00 00       	mov    $0x30,%eax
801021cd:	89 ca                	mov    %ecx,%edx
801021cf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801021d0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801021d5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801021d8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021dd:	fc                   	cld
801021de:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801021e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021e3:	5b                   	pop    %ebx
801021e4:	5e                   	pop    %esi
801021e5:	5f                   	pop    %edi
801021e6:	5d                   	pop    %ebp
801021e7:	c3                   	ret
    panic("incorrect blockno");
801021e8:	83 ec 0c             	sub    $0xc,%esp
801021eb:	68 87 77 10 80       	push   $0x80107787
801021f0:	e8 8b e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021f5:	83 ec 0c             	sub    $0xc,%esp
801021f8:	68 7e 77 10 80       	push   $0x8010777e
801021fd:	e8 7e e1 ff ff       	call   80100380 <panic>
80102202:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102209:	00 
8010220a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102210 <ideinit>:
{
80102210:	55                   	push   %ebp
80102211:	89 e5                	mov    %esp,%ebp
80102213:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102216:	68 99 77 10 80       	push   $0x80107799
8010221b:	68 00 26 11 80       	push   $0x80112600
80102220:	e8 0b 23 00 00       	call   80104530 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102225:	58                   	pop    %eax
80102226:	a1 84 27 11 80       	mov    0x80112784,%eax
8010222b:	5a                   	pop    %edx
8010222c:	83 e8 01             	sub    $0x1,%eax
8010222f:	50                   	push   %eax
80102230:	6a 0e                	push   $0xe
80102232:	e8 99 02 00 00       	call   801024d0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102237:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010223a:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
8010223f:	90                   	nop
80102240:	89 ca                	mov    %ecx,%edx
80102242:	ec                   	in     (%dx),%al
80102243:	83 e0 c0             	and    $0xffffffc0,%eax
80102246:	3c 40                	cmp    $0x40,%al
80102248:	75 f6                	jne    80102240 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010224a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010224f:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102254:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102255:	89 ca                	mov    %ecx,%edx
80102257:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102258:	84 c0                	test   %al,%al
8010225a:	75 1e                	jne    8010227a <ideinit+0x6a>
8010225c:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
80102261:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102266:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010226d:	00 
8010226e:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102270:	83 e9 01             	sub    $0x1,%ecx
80102273:	74 0f                	je     80102284 <ideinit+0x74>
80102275:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102276:	84 c0                	test   %al,%al
80102278:	74 f6                	je     80102270 <ideinit+0x60>
      havedisk1 = 1;
8010227a:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
80102281:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102284:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102289:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010228e:	ee                   	out    %al,(%dx)
}
8010228f:	c9                   	leave
80102290:	c3                   	ret
80102291:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102298:	00 
80102299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801022a0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801022a0:	55                   	push   %ebp
801022a1:	89 e5                	mov    %esp,%ebp
801022a3:	57                   	push   %edi
801022a4:	56                   	push   %esi
801022a5:	53                   	push   %ebx
801022a6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801022a9:	68 00 26 11 80       	push   $0x80112600
801022ae:	e8 6d 24 00 00       	call   80104720 <acquire>

  if((b = idequeue) == 0){
801022b3:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
801022b9:	83 c4 10             	add    $0x10,%esp
801022bc:	85 db                	test   %ebx,%ebx
801022be:	74 63                	je     80102323 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801022c0:	8b 43 58             	mov    0x58(%ebx),%eax
801022c3:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801022c8:	8b 33                	mov    (%ebx),%esi
801022ca:	f7 c6 04 00 00 00    	test   $0x4,%esi
801022d0:	75 2f                	jne    80102301 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022d2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801022de:	00 
801022df:	90                   	nop
801022e0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022e1:	89 c1                	mov    %eax,%ecx
801022e3:	83 e1 c0             	and    $0xffffffc0,%ecx
801022e6:	80 f9 40             	cmp    $0x40,%cl
801022e9:	75 f5                	jne    801022e0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801022eb:	a8 21                	test   $0x21,%al
801022ed:	75 12                	jne    80102301 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801022ef:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801022f2:	b9 80 00 00 00       	mov    $0x80,%ecx
801022f7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022fc:	fc                   	cld
801022fd:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801022ff:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102301:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102304:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102307:	83 ce 02             	or     $0x2,%esi
8010230a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010230c:	53                   	push   %ebx
8010230d:	e8 4e 1f 00 00       	call   80104260 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102312:	a1 e4 25 11 80       	mov    0x801125e4,%eax
80102317:	83 c4 10             	add    $0x10,%esp
8010231a:	85 c0                	test   %eax,%eax
8010231c:	74 05                	je     80102323 <ideintr+0x83>
    idestart(idequeue);
8010231e:	e8 0d fe ff ff       	call   80102130 <idestart>
    release(&idelock);
80102323:	83 ec 0c             	sub    $0xc,%esp
80102326:	68 00 26 11 80       	push   $0x80112600
8010232b:	e8 90 23 00 00       	call   801046c0 <release>

  release(&idelock);
}
80102330:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102333:	5b                   	pop    %ebx
80102334:	5e                   	pop    %esi
80102335:	5f                   	pop    %edi
80102336:	5d                   	pop    %ebp
80102337:	c3                   	ret
80102338:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010233f:	00 

80102340 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102340:	55                   	push   %ebp
80102341:	89 e5                	mov    %esp,%ebp
80102343:	53                   	push   %ebx
80102344:	83 ec 10             	sub    $0x10,%esp
80102347:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010234a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010234d:	50                   	push   %eax
8010234e:	e8 8d 21 00 00       	call   801044e0 <holdingsleep>
80102353:	83 c4 10             	add    $0x10,%esp
80102356:	85 c0                	test   %eax,%eax
80102358:	0f 84 c3 00 00 00    	je     80102421 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010235e:	8b 03                	mov    (%ebx),%eax
80102360:	83 e0 06             	and    $0x6,%eax
80102363:	83 f8 02             	cmp    $0x2,%eax
80102366:	0f 84 a8 00 00 00    	je     80102414 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010236c:	8b 53 04             	mov    0x4(%ebx),%edx
8010236f:	85 d2                	test   %edx,%edx
80102371:	74 0d                	je     80102380 <iderw+0x40>
80102373:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80102378:	85 c0                	test   %eax,%eax
8010237a:	0f 84 87 00 00 00    	je     80102407 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102380:	83 ec 0c             	sub    $0xc,%esp
80102383:	68 00 26 11 80       	push   $0x80112600
80102388:	e8 93 23 00 00       	call   80104720 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010238d:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
80102392:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102399:	83 c4 10             	add    $0x10,%esp
8010239c:	85 c0                	test   %eax,%eax
8010239e:	74 60                	je     80102400 <iderw+0xc0>
801023a0:	89 c2                	mov    %eax,%edx
801023a2:	8b 40 58             	mov    0x58(%eax),%eax
801023a5:	85 c0                	test   %eax,%eax
801023a7:	75 f7                	jne    801023a0 <iderw+0x60>
801023a9:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801023ac:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801023ae:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
801023b4:	74 3a                	je     801023f0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023b6:	8b 03                	mov    (%ebx),%eax
801023b8:	83 e0 06             	and    $0x6,%eax
801023bb:	83 f8 02             	cmp    $0x2,%eax
801023be:	74 1b                	je     801023db <iderw+0x9b>
    sleep(b, &idelock);
801023c0:	83 ec 08             	sub    $0x8,%esp
801023c3:	68 00 26 11 80       	push   $0x80112600
801023c8:	53                   	push   %ebx
801023c9:	e8 c2 1d 00 00       	call   80104190 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023ce:	8b 03                	mov    (%ebx),%eax
801023d0:	83 c4 10             	add    $0x10,%esp
801023d3:	83 e0 06             	and    $0x6,%eax
801023d6:	83 f8 02             	cmp    $0x2,%eax
801023d9:	75 e5                	jne    801023c0 <iderw+0x80>
  }


  release(&idelock);
801023db:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
801023e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023e5:	c9                   	leave
  release(&idelock);
801023e6:	e9 d5 22 00 00       	jmp    801046c0 <release>
801023eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    idestart(b);
801023f0:	89 d8                	mov    %ebx,%eax
801023f2:	e8 39 fd ff ff       	call   80102130 <idestart>
801023f7:	eb bd                	jmp    801023b6 <iderw+0x76>
801023f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102400:	ba e4 25 11 80       	mov    $0x801125e4,%edx
80102405:	eb a5                	jmp    801023ac <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102407:	83 ec 0c             	sub    $0xc,%esp
8010240a:	68 c8 77 10 80       	push   $0x801077c8
8010240f:	e8 6c df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
80102414:	83 ec 0c             	sub    $0xc,%esp
80102417:	68 b3 77 10 80       	push   $0x801077b3
8010241c:	e8 5f df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
80102421:	83 ec 0c             	sub    $0xc,%esp
80102424:	68 9d 77 10 80       	push   $0x8010779d
80102429:	e8 52 df ff ff       	call   80100380 <panic>
8010242e:	66 90                	xchg   %ax,%ax

80102430 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102430:	55                   	push   %ebp
80102431:	89 e5                	mov    %esp,%ebp
80102433:	56                   	push   %esi
80102434:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102435:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
8010243c:	00 c0 fe 
  ioapic->reg = reg;
8010243f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102446:	00 00 00 
  return ioapic->data;
80102449:	8b 15 34 26 11 80    	mov    0x80112634,%edx
8010244f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102452:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102458:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010245e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102465:	c1 ee 10             	shr    $0x10,%esi
80102468:	89 f0                	mov    %esi,%eax
8010246a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010246d:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102470:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102473:	39 c2                	cmp    %eax,%edx
80102475:	74 16                	je     8010248d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102477:	83 ec 0c             	sub    $0xc,%esp
8010247a:	68 00 7c 10 80       	push   $0x80107c00
8010247f:	e8 2c e2 ff ff       	call   801006b0 <cprintf>
  ioapic->reg = reg;
80102484:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010248a:	83 c4 10             	add    $0x10,%esp
{
8010248d:	ba 10 00 00 00       	mov    $0x10,%edx
80102492:	31 c0                	xor    %eax,%eax
80102494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
80102498:	89 13                	mov    %edx,(%ebx)
8010249a:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
8010249d:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801024a3:	83 c0 01             	add    $0x1,%eax
801024a6:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
801024ac:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
801024af:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
801024b2:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
801024b5:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
801024b7:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
801024bd:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
801024c4:	39 c6                	cmp    %eax,%esi
801024c6:	7d d0                	jge    80102498 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801024c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024cb:	5b                   	pop    %ebx
801024cc:	5e                   	pop    %esi
801024cd:	5d                   	pop    %ebp
801024ce:	c3                   	ret
801024cf:	90                   	nop

801024d0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801024d0:	55                   	push   %ebp
  ioapic->reg = reg;
801024d1:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
801024d7:	89 e5                	mov    %esp,%ebp
801024d9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801024dc:	8d 50 20             	lea    0x20(%eax),%edx
801024df:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801024e3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024e5:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024eb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801024ee:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024f4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024f6:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024fb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024fe:	89 50 10             	mov    %edx,0x10(%eax)
}
80102501:	5d                   	pop    %ebp
80102502:	c3                   	ret
80102503:	66 90                	xchg   %ax,%ax
80102505:	66 90                	xchg   %ax,%ax
80102507:	66 90                	xchg   %ax,%ax
80102509:	66 90                	xchg   %ax,%ax
8010250b:	66 90                	xchg   %ax,%ax
8010250d:	66 90                	xchg   %ax,%ax
8010250f:	90                   	nop

80102510 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102510:	55                   	push   %ebp
80102511:	89 e5                	mov    %esp,%ebp
80102513:	53                   	push   %ebx
80102514:	83 ec 04             	sub    $0x4,%esp
80102517:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010251a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102520:	75 76                	jne    80102598 <kfree+0x88>
80102522:	81 fb d0 92 11 80    	cmp    $0x801192d0,%ebx
80102528:	72 6e                	jb     80102598 <kfree+0x88>
8010252a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102530:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102535:	77 61                	ja     80102598 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102537:	83 ec 04             	sub    $0x4,%esp
8010253a:	68 00 10 00 00       	push   $0x1000
8010253f:	6a 01                	push   $0x1
80102541:	53                   	push   %ebx
80102542:	e8 d9 22 00 00       	call   80104820 <memset>

  if(kmem.use_lock)
80102547:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010254d:	83 c4 10             	add    $0x10,%esp
80102550:	85 d2                	test   %edx,%edx
80102552:	75 1c                	jne    80102570 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102554:	a1 78 26 11 80       	mov    0x80112678,%eax
80102559:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010255b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102560:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102566:	85 c0                	test   %eax,%eax
80102568:	75 1e                	jne    80102588 <kfree+0x78>
    release(&kmem.lock);
}
8010256a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010256d:	c9                   	leave
8010256e:	c3                   	ret
8010256f:	90                   	nop
    acquire(&kmem.lock);
80102570:	83 ec 0c             	sub    $0xc,%esp
80102573:	68 40 26 11 80       	push   $0x80112640
80102578:	e8 a3 21 00 00       	call   80104720 <acquire>
8010257d:	83 c4 10             	add    $0x10,%esp
80102580:	eb d2                	jmp    80102554 <kfree+0x44>
80102582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102588:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010258f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102592:	c9                   	leave
    release(&kmem.lock);
80102593:	e9 28 21 00 00       	jmp    801046c0 <release>
    panic("kfree");
80102598:	83 ec 0c             	sub    $0xc,%esp
8010259b:	68 e6 77 10 80       	push   $0x801077e6
801025a0:	e8 db dd ff ff       	call   80100380 <panic>
801025a5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801025ac:	00 
801025ad:	8d 76 00             	lea    0x0(%esi),%esi

801025b0 <freerange>:
{
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	56                   	push   %esi
801025b4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025b5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801025bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025cd:	39 de                	cmp    %ebx,%esi
801025cf:	72 23                	jb     801025f4 <freerange+0x44>
801025d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025d8:	83 ec 0c             	sub    $0xc,%esp
801025db:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025e7:	50                   	push   %eax
801025e8:	e8 23 ff ff ff       	call   80102510 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ed:	83 c4 10             	add    $0x10,%esp
801025f0:	39 de                	cmp    %ebx,%esi
801025f2:	73 e4                	jae    801025d8 <freerange+0x28>
}
801025f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025f7:	5b                   	pop    %ebx
801025f8:	5e                   	pop    %esi
801025f9:	5d                   	pop    %ebp
801025fa:	c3                   	ret
801025fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102600 <kinit2>:
{
80102600:	55                   	push   %ebp
80102601:	89 e5                	mov    %esp,%ebp
80102603:	56                   	push   %esi
80102604:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102605:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102608:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010260b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102611:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102617:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010261d:	39 de                	cmp    %ebx,%esi
8010261f:	72 23                	jb     80102644 <kinit2+0x44>
80102621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102628:	83 ec 0c             	sub    $0xc,%esp
8010262b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102631:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102637:	50                   	push   %eax
80102638:	e8 d3 fe ff ff       	call   80102510 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010263d:	83 c4 10             	add    $0x10,%esp
80102640:	39 de                	cmp    %ebx,%esi
80102642:	73 e4                	jae    80102628 <kinit2+0x28>
  kmem.use_lock = 1;
80102644:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010264b:	00 00 00 
}
8010264e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102651:	5b                   	pop    %ebx
80102652:	5e                   	pop    %esi
80102653:	5d                   	pop    %ebp
80102654:	c3                   	ret
80102655:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010265c:	00 
8010265d:	8d 76 00             	lea    0x0(%esi),%esi

80102660 <kinit1>:
{
80102660:	55                   	push   %ebp
80102661:	89 e5                	mov    %esp,%ebp
80102663:	56                   	push   %esi
80102664:	53                   	push   %ebx
80102665:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102668:	83 ec 08             	sub    $0x8,%esp
8010266b:	68 ec 77 10 80       	push   $0x801077ec
80102670:	68 40 26 11 80       	push   $0x80112640
80102675:	e8 b6 1e 00 00       	call   80104530 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010267a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010267d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102680:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102687:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010268a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102690:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102696:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010269c:	39 de                	cmp    %ebx,%esi
8010269e:	72 1c                	jb     801026bc <kinit1+0x5c>
    kfree(p);
801026a0:	83 ec 0c             	sub    $0xc,%esp
801026a3:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026a9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026af:	50                   	push   %eax
801026b0:	e8 5b fe ff ff       	call   80102510 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026b5:	83 c4 10             	add    $0x10,%esp
801026b8:	39 de                	cmp    %ebx,%esi
801026ba:	73 e4                	jae    801026a0 <kinit1+0x40>
}
801026bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026bf:	5b                   	pop    %ebx
801026c0:	5e                   	pop    %esi
801026c1:	5d                   	pop    %ebp
801026c2:	c3                   	ret
801026c3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801026ca:	00 
801026cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801026d0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801026d0:	55                   	push   %ebp
801026d1:	89 e5                	mov    %esp,%ebp
801026d3:	53                   	push   %ebx
801026d4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801026d7:	a1 74 26 11 80       	mov    0x80112674,%eax
801026dc:	85 c0                	test   %eax,%eax
801026de:	75 20                	jne    80102700 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
801026e0:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801026e6:	85 db                	test   %ebx,%ebx
801026e8:	74 07                	je     801026f1 <kalloc+0x21>
    kmem.freelist = r->next;
801026ea:	8b 03                	mov    (%ebx),%eax
801026ec:	a3 78 26 11 80       	mov    %eax,0x80112678
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801026f1:	89 d8                	mov    %ebx,%eax
801026f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026f6:	c9                   	leave
801026f7:	c3                   	ret
801026f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801026ff:	00 
    acquire(&kmem.lock);
80102700:	83 ec 0c             	sub    $0xc,%esp
80102703:	68 40 26 11 80       	push   $0x80112640
80102708:	e8 13 20 00 00       	call   80104720 <acquire>
  r = kmem.freelist;
8010270d:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(kmem.use_lock)
80102713:	a1 74 26 11 80       	mov    0x80112674,%eax
  if(r)
80102718:	83 c4 10             	add    $0x10,%esp
8010271b:	85 db                	test   %ebx,%ebx
8010271d:	74 08                	je     80102727 <kalloc+0x57>
    kmem.freelist = r->next;
8010271f:	8b 13                	mov    (%ebx),%edx
80102721:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
80102727:	85 c0                	test   %eax,%eax
80102729:	74 c6                	je     801026f1 <kalloc+0x21>
    release(&kmem.lock);
8010272b:	83 ec 0c             	sub    $0xc,%esp
8010272e:	68 40 26 11 80       	push   $0x80112640
80102733:	e8 88 1f 00 00       	call   801046c0 <release>
}
80102738:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
8010273a:	83 c4 10             	add    $0x10,%esp
}
8010273d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102740:	c9                   	leave
80102741:	c3                   	ret
80102742:	66 90                	xchg   %ax,%ax
80102744:	66 90                	xchg   %ax,%ax
80102746:	66 90                	xchg   %ax,%ax
80102748:	66 90                	xchg   %ax,%ax
8010274a:	66 90                	xchg   %ax,%ax
8010274c:	66 90                	xchg   %ax,%ax
8010274e:	66 90                	xchg   %ax,%ax

80102750 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102750:	ba 64 00 00 00       	mov    $0x64,%edx
80102755:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102756:	a8 01                	test   $0x1,%al
80102758:	0f 84 c2 00 00 00    	je     80102820 <kbdgetc+0xd0>
{
8010275e:	55                   	push   %ebp
8010275f:	ba 60 00 00 00       	mov    $0x60,%edx
80102764:	89 e5                	mov    %esp,%ebp
80102766:	53                   	push   %ebx
80102767:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102768:	8b 1d 7c 26 11 80    	mov    0x8011267c,%ebx
  data = inb(KBDATAP);
8010276e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102771:	3c e0                	cmp    $0xe0,%al
80102773:	74 5b                	je     801027d0 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102775:	89 da                	mov    %ebx,%edx
80102777:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010277a:	84 c0                	test   %al,%al
8010277c:	78 62                	js     801027e0 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010277e:	85 d2                	test   %edx,%edx
80102780:	74 09                	je     8010278b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102782:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102785:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102788:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010278b:	0f b6 91 60 7e 10 80 	movzbl -0x7fef81a0(%ecx),%edx
  shift ^= togglecode[data];
80102792:	0f b6 81 60 7d 10 80 	movzbl -0x7fef82a0(%ecx),%eax
  shift |= shiftcode[data];
80102799:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010279b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010279d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010279f:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  c = charcode[shift & (CTL | SHIFT)][data];
801027a5:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801027a8:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801027ab:	8b 04 85 40 7d 10 80 	mov    -0x7fef82c0(,%eax,4),%eax
801027b2:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801027b6:	74 0b                	je     801027c3 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
801027b8:	8d 50 9f             	lea    -0x61(%eax),%edx
801027bb:	83 fa 19             	cmp    $0x19,%edx
801027be:	77 48                	ja     80102808 <kbdgetc+0xb8>
      c += 'A' - 'a';
801027c0:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801027c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027c6:	c9                   	leave
801027c7:	c3                   	ret
801027c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801027cf:	00 
    shift |= E0ESC;
801027d0:	83 cb 40             	or     $0x40,%ebx
    return 0;
801027d3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801027d5:	89 1d 7c 26 11 80    	mov    %ebx,0x8011267c
}
801027db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027de:	c9                   	leave
801027df:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
801027e0:	83 e0 7f             	and    $0x7f,%eax
801027e3:	85 d2                	test   %edx,%edx
801027e5:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
801027e8:	0f b6 81 60 7e 10 80 	movzbl -0x7fef81a0(%ecx),%eax
801027ef:	83 c8 40             	or     $0x40,%eax
801027f2:	0f b6 c0             	movzbl %al,%eax
801027f5:	f7 d0                	not    %eax
801027f7:	21 d8                	and    %ebx,%eax
801027f9:	a3 7c 26 11 80       	mov    %eax,0x8011267c
    return 0;
801027fe:	31 c0                	xor    %eax,%eax
80102800:	eb d9                	jmp    801027db <kbdgetc+0x8b>
80102802:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102808:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010280b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010280e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102811:	c9                   	leave
      c += 'a' - 'A';
80102812:	83 f9 1a             	cmp    $0x1a,%ecx
80102815:	0f 42 c2             	cmovb  %edx,%eax
}
80102818:	c3                   	ret
80102819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102820:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102825:	c3                   	ret
80102826:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010282d:	00 
8010282e:	66 90                	xchg   %ax,%ax

80102830 <kbdintr>:

void
kbdintr(void)
{
80102830:	55                   	push   %ebp
80102831:	89 e5                	mov    %esp,%ebp
80102833:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102836:	68 50 27 10 80       	push   $0x80102750
8010283b:	e8 60 e0 ff ff       	call   801008a0 <consoleintr>
}
80102840:	83 c4 10             	add    $0x10,%esp
80102843:	c9                   	leave
80102844:	c3                   	ret
80102845:	66 90                	xchg   %ax,%ax
80102847:	66 90                	xchg   %ax,%ax
80102849:	66 90                	xchg   %ax,%ax
8010284b:	66 90                	xchg   %ax,%ax
8010284d:	66 90                	xchg   %ax,%ax
8010284f:	90                   	nop

80102850 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102850:	a1 80 26 11 80       	mov    0x80112680,%eax
80102855:	85 c0                	test   %eax,%eax
80102857:	0f 84 c3 00 00 00    	je     80102920 <lapicinit+0xd0>
  lapic[index] = value;
8010285d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102864:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102867:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010286a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102871:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102874:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102877:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010287e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102881:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102884:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010288b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010288e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102891:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102898:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010289b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010289e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801028a5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028a8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801028ab:	8b 50 30             	mov    0x30(%eax),%edx
801028ae:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
801028b4:	75 72                	jne    80102928 <lapicinit+0xd8>
  lapic[index] = value;
801028b6:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801028bd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028c3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028ca:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028cd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028d0:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028d7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028da:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028dd:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028e4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028e7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ea:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801028f1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028f4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028f7:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028fe:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102901:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102908:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010290e:	80 e6 10             	and    $0x10,%dh
80102911:	75 f5                	jne    80102908 <lapicinit+0xb8>
  lapic[index] = value;
80102913:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010291a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010291d:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102920:	c3                   	ret
80102921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102928:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010292f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102932:	8b 50 20             	mov    0x20(%eax),%edx
}
80102935:	e9 7c ff ff ff       	jmp    801028b6 <lapicinit+0x66>
8010293a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102940 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102940:	a1 80 26 11 80       	mov    0x80112680,%eax
80102945:	85 c0                	test   %eax,%eax
80102947:	74 07                	je     80102950 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102949:	8b 40 20             	mov    0x20(%eax),%eax
8010294c:	c1 e8 18             	shr    $0x18,%eax
8010294f:	c3                   	ret
    return 0;
80102950:	31 c0                	xor    %eax,%eax
}
80102952:	c3                   	ret
80102953:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010295a:	00 
8010295b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102960 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102960:	a1 80 26 11 80       	mov    0x80112680,%eax
80102965:	85 c0                	test   %eax,%eax
80102967:	74 0d                	je     80102976 <lapiceoi+0x16>
  lapic[index] = value;
80102969:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102970:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102973:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102976:	c3                   	ret
80102977:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010297e:	00 
8010297f:	90                   	nop

80102980 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102980:	c3                   	ret
80102981:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102988:	00 
80102989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102990 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102990:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102991:	b8 0f 00 00 00       	mov    $0xf,%eax
80102996:	ba 70 00 00 00       	mov    $0x70,%edx
8010299b:	89 e5                	mov    %esp,%ebp
8010299d:	53                   	push   %ebx
8010299e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801029a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801029a4:	ee                   	out    %al,(%dx)
801029a5:	b8 0a 00 00 00       	mov    $0xa,%eax
801029aa:	ba 71 00 00 00       	mov    $0x71,%edx
801029af:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801029b0:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
801029b2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801029b5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801029bb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801029bd:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
801029c0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
801029c2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
801029c5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801029c8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801029ce:	a1 80 26 11 80       	mov    0x80112680,%eax
801029d3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029d9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029dc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801029e3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029e6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029e9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029f0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029f3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029f6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029fc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029ff:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a05:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a08:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a0e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a11:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a17:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102a1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a1d:	c9                   	leave
80102a1e:	c3                   	ret
80102a1f:	90                   	nop

80102a20 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102a20:	55                   	push   %ebp
80102a21:	b8 0b 00 00 00       	mov    $0xb,%eax
80102a26:	ba 70 00 00 00       	mov    $0x70,%edx
80102a2b:	89 e5                	mov    %esp,%ebp
80102a2d:	57                   	push   %edi
80102a2e:	56                   	push   %esi
80102a2f:	53                   	push   %ebx
80102a30:	83 ec 4c             	sub    $0x4c,%esp
80102a33:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a34:	ba 71 00 00 00       	mov    $0x71,%edx
80102a39:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102a3a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a3d:	bf 70 00 00 00       	mov    $0x70,%edi
80102a42:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a45:	8d 76 00             	lea    0x0(%esi),%esi
80102a48:	31 c0                	xor    %eax,%eax
80102a4a:	89 fa                	mov    %edi,%edx
80102a4c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a4d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a52:	89 ca                	mov    %ecx,%edx
80102a54:	ec                   	in     (%dx),%al
80102a55:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a58:	89 fa                	mov    %edi,%edx
80102a5a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a5f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a60:	89 ca                	mov    %ecx,%edx
80102a62:	ec                   	in     (%dx),%al
80102a63:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a66:	89 fa                	mov    %edi,%edx
80102a68:	b8 04 00 00 00       	mov    $0x4,%eax
80102a6d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a6e:	89 ca                	mov    %ecx,%edx
80102a70:	ec                   	in     (%dx),%al
80102a71:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a74:	89 fa                	mov    %edi,%edx
80102a76:	b8 07 00 00 00       	mov    $0x7,%eax
80102a7b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a7c:	89 ca                	mov    %ecx,%edx
80102a7e:	ec                   	in     (%dx),%al
80102a7f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a82:	89 fa                	mov    %edi,%edx
80102a84:	b8 08 00 00 00       	mov    $0x8,%eax
80102a89:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8a:	89 ca                	mov    %ecx,%edx
80102a8c:	ec                   	in     (%dx),%al
80102a8d:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a8f:	89 fa                	mov    %edi,%edx
80102a91:	b8 09 00 00 00       	mov    $0x9,%eax
80102a96:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a97:	89 ca                	mov    %ecx,%edx
80102a99:	ec                   	in     (%dx),%al
80102a9a:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a9d:	89 fa                	mov    %edi,%edx
80102a9f:	b8 0a 00 00 00       	mov    $0xa,%eax
80102aa4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa5:	89 ca                	mov    %ecx,%edx
80102aa7:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102aa8:	84 c0                	test   %al,%al
80102aaa:	78 9c                	js     80102a48 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102aac:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102ab0:	89 f2                	mov    %esi,%edx
80102ab2:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80102ab5:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab8:	89 fa                	mov    %edi,%edx
80102aba:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102abd:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102ac1:	89 75 c8             	mov    %esi,-0x38(%ebp)
80102ac4:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102ac7:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102acb:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102ace:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102ad2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102ad5:	31 c0                	xor    %eax,%eax
80102ad7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad8:	89 ca                	mov    %ecx,%edx
80102ada:	ec                   	in     (%dx),%al
80102adb:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ade:	89 fa                	mov    %edi,%edx
80102ae0:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102ae3:	b8 02 00 00 00       	mov    $0x2,%eax
80102ae8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae9:	89 ca                	mov    %ecx,%edx
80102aeb:	ec                   	in     (%dx),%al
80102aec:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aef:	89 fa                	mov    %edi,%edx
80102af1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102af4:	b8 04 00 00 00       	mov    $0x4,%eax
80102af9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102afa:	89 ca                	mov    %ecx,%edx
80102afc:	ec                   	in     (%dx),%al
80102afd:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b00:	89 fa                	mov    %edi,%edx
80102b02:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102b05:	b8 07 00 00 00       	mov    $0x7,%eax
80102b0a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b0b:	89 ca                	mov    %ecx,%edx
80102b0d:	ec                   	in     (%dx),%al
80102b0e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b11:	89 fa                	mov    %edi,%edx
80102b13:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102b16:	b8 08 00 00 00       	mov    $0x8,%eax
80102b1b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b1c:	89 ca                	mov    %ecx,%edx
80102b1e:	ec                   	in     (%dx),%al
80102b1f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b22:	89 fa                	mov    %edi,%edx
80102b24:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102b27:	b8 09 00 00 00       	mov    $0x9,%eax
80102b2c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b2d:	89 ca                	mov    %ecx,%edx
80102b2f:	ec                   	in     (%dx),%al
80102b30:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b33:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102b36:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b39:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b3c:	6a 18                	push   $0x18
80102b3e:	50                   	push   %eax
80102b3f:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b42:	50                   	push   %eax
80102b43:	e8 18 1d 00 00       	call   80104860 <memcmp>
80102b48:	83 c4 10             	add    $0x10,%esp
80102b4b:	85 c0                	test   %eax,%eax
80102b4d:	0f 85 f5 fe ff ff    	jne    80102a48 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b53:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
80102b57:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b5a:	89 f0                	mov    %esi,%eax
80102b5c:	84 c0                	test   %al,%al
80102b5e:	75 78                	jne    80102bd8 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b60:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b63:	89 c2                	mov    %eax,%edx
80102b65:	83 e0 0f             	and    $0xf,%eax
80102b68:	c1 ea 04             	shr    $0x4,%edx
80102b6b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b6e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b71:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b74:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b77:	89 c2                	mov    %eax,%edx
80102b79:	83 e0 0f             	and    $0xf,%eax
80102b7c:	c1 ea 04             	shr    $0x4,%edx
80102b7f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b82:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b85:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b88:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b8b:	89 c2                	mov    %eax,%edx
80102b8d:	83 e0 0f             	and    $0xf,%eax
80102b90:	c1 ea 04             	shr    $0x4,%edx
80102b93:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b96:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b99:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b9c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b9f:	89 c2                	mov    %eax,%edx
80102ba1:	83 e0 0f             	and    $0xf,%eax
80102ba4:	c1 ea 04             	shr    $0x4,%edx
80102ba7:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102baa:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bad:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102bb0:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bb3:	89 c2                	mov    %eax,%edx
80102bb5:	83 e0 0f             	and    $0xf,%eax
80102bb8:	c1 ea 04             	shr    $0x4,%edx
80102bbb:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bbe:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bc1:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102bc4:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bc7:	89 c2                	mov    %eax,%edx
80102bc9:	83 e0 0f             	and    $0xf,%eax
80102bcc:	c1 ea 04             	shr    $0x4,%edx
80102bcf:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bd2:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bd5:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102bd8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102bdb:	89 03                	mov    %eax,(%ebx)
80102bdd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102be0:	89 43 04             	mov    %eax,0x4(%ebx)
80102be3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102be6:	89 43 08             	mov    %eax,0x8(%ebx)
80102be9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bec:	89 43 0c             	mov    %eax,0xc(%ebx)
80102bef:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bf2:	89 43 10             	mov    %eax,0x10(%ebx)
80102bf5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bf8:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
80102bfb:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102c02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c05:	5b                   	pop    %ebx
80102c06:	5e                   	pop    %esi
80102c07:	5f                   	pop    %edi
80102c08:	5d                   	pop    %ebp
80102c09:	c3                   	ret
80102c0a:	66 90                	xchg   %ax,%ax
80102c0c:	66 90                	xchg   %ax,%ax
80102c0e:	66 90                	xchg   %ax,%ax

80102c10 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c10:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102c16:	85 c9                	test   %ecx,%ecx
80102c18:	0f 8e 8a 00 00 00    	jle    80102ca8 <install_trans+0x98>
{
80102c1e:	55                   	push   %ebp
80102c1f:	89 e5                	mov    %esp,%ebp
80102c21:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102c22:	31 ff                	xor    %edi,%edi
{
80102c24:	56                   	push   %esi
80102c25:	53                   	push   %ebx
80102c26:	83 ec 0c             	sub    $0xc,%esp
80102c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c30:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102c35:	83 ec 08             	sub    $0x8,%esp
80102c38:	01 f8                	add    %edi,%eax
80102c3a:	83 c0 01             	add    $0x1,%eax
80102c3d:	50                   	push   %eax
80102c3e:	ff 35 e4 26 11 80    	push   0x801126e4
80102c44:	e8 87 d4 ff ff       	call   801000d0 <bread>
80102c49:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c4b:	58                   	pop    %eax
80102c4c:	5a                   	pop    %edx
80102c4d:	ff 34 bd ec 26 11 80 	push   -0x7feed914(,%edi,4)
80102c54:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c5a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c5d:	e8 6e d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c62:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c65:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c67:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c6a:	68 00 02 00 00       	push   $0x200
80102c6f:	50                   	push   %eax
80102c70:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c73:	50                   	push   %eax
80102c74:	e8 37 1c 00 00       	call   801048b0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c79:	89 1c 24             	mov    %ebx,(%esp)
80102c7c:	e8 2f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c81:	89 34 24             	mov    %esi,(%esp)
80102c84:	e8 67 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c89:	89 1c 24             	mov    %ebx,(%esp)
80102c8c:	e8 5f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c91:	83 c4 10             	add    $0x10,%esp
80102c94:	39 3d e8 26 11 80    	cmp    %edi,0x801126e8
80102c9a:	7f 94                	jg     80102c30 <install_trans+0x20>
  }
}
80102c9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c9f:	5b                   	pop    %ebx
80102ca0:	5e                   	pop    %esi
80102ca1:	5f                   	pop    %edi
80102ca2:	5d                   	pop    %ebp
80102ca3:	c3                   	ret
80102ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ca8:	c3                   	ret
80102ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102cb0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102cb0:	55                   	push   %ebp
80102cb1:	89 e5                	mov    %esp,%ebp
80102cb3:	53                   	push   %ebx
80102cb4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102cb7:	ff 35 d4 26 11 80    	push   0x801126d4
80102cbd:	ff 35 e4 26 11 80    	push   0x801126e4
80102cc3:	e8 08 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102cc8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ccb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102ccd:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102cd2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102cd5:	85 c0                	test   %eax,%eax
80102cd7:	7e 19                	jle    80102cf2 <write_head+0x42>
80102cd9:	31 d2                	xor    %edx,%edx
80102cdb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102ce0:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102ce7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102ceb:	83 c2 01             	add    $0x1,%edx
80102cee:	39 d0                	cmp    %edx,%eax
80102cf0:	75 ee                	jne    80102ce0 <write_head+0x30>
  }
  bwrite(buf);
80102cf2:	83 ec 0c             	sub    $0xc,%esp
80102cf5:	53                   	push   %ebx
80102cf6:	e8 b5 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102cfb:	89 1c 24             	mov    %ebx,(%esp)
80102cfe:	e8 ed d4 ff ff       	call   801001f0 <brelse>
}
80102d03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d06:	83 c4 10             	add    $0x10,%esp
80102d09:	c9                   	leave
80102d0a:	c3                   	ret
80102d0b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102d10 <initlog>:
{
80102d10:	55                   	push   %ebp
80102d11:	89 e5                	mov    %esp,%ebp
80102d13:	53                   	push   %ebx
80102d14:	83 ec 2c             	sub    $0x2c,%esp
80102d17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102d1a:	68 f1 77 10 80       	push   $0x801077f1
80102d1f:	68 a0 26 11 80       	push   $0x801126a0
80102d24:	e8 07 18 00 00       	call   80104530 <initlock>
  readsb(dev, &sb);
80102d29:	58                   	pop    %eax
80102d2a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102d2d:	5a                   	pop    %edx
80102d2e:	50                   	push   %eax
80102d2f:	53                   	push   %ebx
80102d30:	e8 3b e8 ff ff       	call   80101570 <readsb>
  log.start = sb.logstart;
80102d35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102d38:	59                   	pop    %ecx
  log.dev = dev;
80102d39:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
80102d3f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d42:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
80102d47:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  struct buf *buf = bread(log.dev, log.start);
80102d4d:	5a                   	pop    %edx
80102d4e:	50                   	push   %eax
80102d4f:	53                   	push   %ebx
80102d50:	e8 7b d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d55:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d58:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d5b:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102d61:	85 db                	test   %ebx,%ebx
80102d63:	7e 1d                	jle    80102d82 <initlog+0x72>
80102d65:	31 d2                	xor    %edx,%edx
80102d67:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102d6e:	00 
80102d6f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102d70:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d74:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d7b:	83 c2 01             	add    $0x1,%edx
80102d7e:	39 d3                	cmp    %edx,%ebx
80102d80:	75 ee                	jne    80102d70 <initlog+0x60>
  brelse(buf);
80102d82:	83 ec 0c             	sub    $0xc,%esp
80102d85:	50                   	push   %eax
80102d86:	e8 65 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d8b:	e8 80 fe ff ff       	call   80102c10 <install_trans>
  log.lh.n = 0;
80102d90:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102d97:	00 00 00 
  write_head(); // clear the log
80102d9a:	e8 11 ff ff ff       	call   80102cb0 <write_head>
}
80102d9f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102da2:	83 c4 10             	add    $0x10,%esp
80102da5:	c9                   	leave
80102da6:	c3                   	ret
80102da7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102dae:	00 
80102daf:	90                   	nop

80102db0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102db0:	55                   	push   %ebp
80102db1:	89 e5                	mov    %esp,%ebp
80102db3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102db6:	68 a0 26 11 80       	push   $0x801126a0
80102dbb:	e8 60 19 00 00       	call   80104720 <acquire>
80102dc0:	83 c4 10             	add    $0x10,%esp
80102dc3:	eb 18                	jmp    80102ddd <begin_op+0x2d>
80102dc5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102dc8:	83 ec 08             	sub    $0x8,%esp
80102dcb:	68 a0 26 11 80       	push   $0x801126a0
80102dd0:	68 a0 26 11 80       	push   $0x801126a0
80102dd5:	e8 b6 13 00 00       	call   80104190 <sleep>
80102dda:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102ddd:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102de2:	85 c0                	test   %eax,%eax
80102de4:	75 e2                	jne    80102dc8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102de6:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102deb:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102df1:	83 c0 01             	add    $0x1,%eax
80102df4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102df7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102dfa:	83 fa 1e             	cmp    $0x1e,%edx
80102dfd:	7f c9                	jg     80102dc8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102dff:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102e02:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102e07:	68 a0 26 11 80       	push   $0x801126a0
80102e0c:	e8 af 18 00 00       	call   801046c0 <release>
      break;
    }
  }
}
80102e11:	83 c4 10             	add    $0x10,%esp
80102e14:	c9                   	leave
80102e15:	c3                   	ret
80102e16:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e1d:	00 
80102e1e:	66 90                	xchg   %ax,%ax

80102e20 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102e20:	55                   	push   %ebp
80102e21:	89 e5                	mov    %esp,%ebp
80102e23:	57                   	push   %edi
80102e24:	56                   	push   %esi
80102e25:	53                   	push   %ebx
80102e26:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102e29:	68 a0 26 11 80       	push   $0x801126a0
80102e2e:	e8 ed 18 00 00       	call   80104720 <acquire>
  log.outstanding -= 1;
80102e33:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102e38:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
80102e3e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e41:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e44:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
80102e4a:	85 f6                	test   %esi,%esi
80102e4c:	0f 85 22 01 00 00    	jne    80102f74 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e52:	85 db                	test   %ebx,%ebx
80102e54:	0f 85 f6 00 00 00    	jne    80102f50 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e5a:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102e61:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e64:	83 ec 0c             	sub    $0xc,%esp
80102e67:	68 a0 26 11 80       	push   $0x801126a0
80102e6c:	e8 4f 18 00 00       	call   801046c0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e71:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102e77:	83 c4 10             	add    $0x10,%esp
80102e7a:	85 c9                	test   %ecx,%ecx
80102e7c:	7f 42                	jg     80102ec0 <end_op+0xa0>
    acquire(&log.lock);
80102e7e:	83 ec 0c             	sub    $0xc,%esp
80102e81:	68 a0 26 11 80       	push   $0x801126a0
80102e86:	e8 95 18 00 00       	call   80104720 <acquire>
    log.committing = 0;
80102e8b:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102e92:	00 00 00 
    wakeup(&log);
80102e95:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102e9c:	e8 bf 13 00 00       	call   80104260 <wakeup>
    release(&log.lock);
80102ea1:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102ea8:	e8 13 18 00 00       	call   801046c0 <release>
80102ead:	83 c4 10             	add    $0x10,%esp
}
80102eb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eb3:	5b                   	pop    %ebx
80102eb4:	5e                   	pop    %esi
80102eb5:	5f                   	pop    %edi
80102eb6:	5d                   	pop    %ebp
80102eb7:	c3                   	ret
80102eb8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102ebf:	00 
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ec0:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102ec5:	83 ec 08             	sub    $0x8,%esp
80102ec8:	01 d8                	add    %ebx,%eax
80102eca:	83 c0 01             	add    $0x1,%eax
80102ecd:	50                   	push   %eax
80102ece:	ff 35 e4 26 11 80    	push   0x801126e4
80102ed4:	e8 f7 d1 ff ff       	call   801000d0 <bread>
80102ed9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102edb:	58                   	pop    %eax
80102edc:	5a                   	pop    %edx
80102edd:	ff 34 9d ec 26 11 80 	push   -0x7feed914(,%ebx,4)
80102ee4:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102eea:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102eed:	e8 de d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102ef2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ef5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ef7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102efa:	68 00 02 00 00       	push   $0x200
80102eff:	50                   	push   %eax
80102f00:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f03:	50                   	push   %eax
80102f04:	e8 a7 19 00 00       	call   801048b0 <memmove>
    bwrite(to);  // write the log
80102f09:	89 34 24             	mov    %esi,(%esp)
80102f0c:	e8 9f d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102f11:	89 3c 24             	mov    %edi,(%esp)
80102f14:	e8 d7 d2 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102f19:	89 34 24             	mov    %esi,(%esp)
80102f1c:	e8 cf d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f21:	83 c4 10             	add    $0x10,%esp
80102f24:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102f2a:	7c 94                	jl     80102ec0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102f2c:	e8 7f fd ff ff       	call   80102cb0 <write_head>
    install_trans(); // Now install writes to home locations
80102f31:	e8 da fc ff ff       	call   80102c10 <install_trans>
    log.lh.n = 0;
80102f36:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102f3d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f40:	e8 6b fd ff ff       	call   80102cb0 <write_head>
80102f45:	e9 34 ff ff ff       	jmp    80102e7e <end_op+0x5e>
80102f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f50:	83 ec 0c             	sub    $0xc,%esp
80102f53:	68 a0 26 11 80       	push   $0x801126a0
80102f58:	e8 03 13 00 00       	call   80104260 <wakeup>
  release(&log.lock);
80102f5d:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102f64:	e8 57 17 00 00       	call   801046c0 <release>
80102f69:	83 c4 10             	add    $0x10,%esp
}
80102f6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f6f:	5b                   	pop    %ebx
80102f70:	5e                   	pop    %esi
80102f71:	5f                   	pop    %edi
80102f72:	5d                   	pop    %ebp
80102f73:	c3                   	ret
    panic("log.committing");
80102f74:	83 ec 0c             	sub    $0xc,%esp
80102f77:	68 f5 77 10 80       	push   $0x801077f5
80102f7c:	e8 ff d3 ff ff       	call   80100380 <panic>
80102f81:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102f88:	00 
80102f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102f90 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f90:	55                   	push   %ebp
80102f91:	89 e5                	mov    %esp,%ebp
80102f93:	53                   	push   %ebx
80102f94:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f97:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
80102f9d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fa0:	83 fa 1d             	cmp    $0x1d,%edx
80102fa3:	7f 7d                	jg     80103022 <log_write+0x92>
80102fa5:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102faa:	83 e8 01             	sub    $0x1,%eax
80102fad:	39 c2                	cmp    %eax,%edx
80102faf:	7d 71                	jge    80103022 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102fb1:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102fb6:	85 c0                	test   %eax,%eax
80102fb8:	7e 75                	jle    8010302f <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102fba:	83 ec 0c             	sub    $0xc,%esp
80102fbd:	68 a0 26 11 80       	push   $0x801126a0
80102fc2:	e8 59 17 00 00       	call   80104720 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fc7:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102fca:	83 c4 10             	add    $0x10,%esp
80102fcd:	31 c0                	xor    %eax,%eax
80102fcf:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102fd5:	85 d2                	test   %edx,%edx
80102fd7:	7f 0e                	jg     80102fe7 <log_write+0x57>
80102fd9:	eb 15                	jmp    80102ff0 <log_write+0x60>
80102fdb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80102fe0:	83 c0 01             	add    $0x1,%eax
80102fe3:	39 c2                	cmp    %eax,%edx
80102fe5:	74 29                	je     80103010 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fe7:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
80102fee:	75 f0                	jne    80102fe0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102ff0:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
80102ff7:	39 c2                	cmp    %eax,%edx
80102ff9:	74 1c                	je     80103017 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102ffb:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102ffe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80103001:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80103008:	c9                   	leave
  release(&log.lock);
80103009:	e9 b2 16 00 00       	jmp    801046c0 <release>
8010300e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80103010:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
    log.lh.n++;
80103017:	83 c2 01             	add    $0x1,%edx
8010301a:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
80103020:	eb d9                	jmp    80102ffb <log_write+0x6b>
    panic("too big a transaction");
80103022:	83 ec 0c             	sub    $0xc,%esp
80103025:	68 04 78 10 80       	push   $0x80107804
8010302a:	e8 51 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010302f:	83 ec 0c             	sub    $0xc,%esp
80103032:	68 1a 78 10 80       	push   $0x8010781a
80103037:	e8 44 d3 ff ff       	call   80100380 <panic>
8010303c:	66 90                	xchg   %ax,%ax
8010303e:	66 90                	xchg   %ax,%ax

80103040 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	53                   	push   %ebx
80103044:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103047:	e8 74 09 00 00       	call   801039c0 <cpuid>
8010304c:	89 c3                	mov    %eax,%ebx
8010304e:	e8 6d 09 00 00       	call   801039c0 <cpuid>
80103053:	83 ec 04             	sub    $0x4,%esp
80103056:	53                   	push   %ebx
80103057:	50                   	push   %eax
80103058:	68 35 78 10 80       	push   $0x80107835
8010305d:	e8 4e d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103062:	e8 e9 2c 00 00       	call   80105d50 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103067:	e8 f4 08 00 00       	call   80103960 <mycpu>
8010306c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010306e:	b8 01 00 00 00       	mov    $0x1,%eax
80103073:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010307a:	e8 81 0c 00 00       	call   80103d00 <scheduler>
8010307f:	90                   	nop

80103080 <mpenter>:
{
80103080:	55                   	push   %ebp
80103081:	89 e5                	mov    %esp,%ebp
80103083:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103086:	e8 e5 3d 00 00       	call   80106e70 <switchkvm>
  seginit();
8010308b:	e8 50 3d 00 00       	call   80106de0 <seginit>
  lapicinit();
80103090:	e8 bb f7 ff ff       	call   80102850 <lapicinit>
  mpmain();
80103095:	e8 a6 ff ff ff       	call   80103040 <mpmain>
8010309a:	66 90                	xchg   %ax,%ax
8010309c:	66 90                	xchg   %ax,%ax
8010309e:	66 90                	xchg   %ax,%ax

801030a0 <main>:
{
801030a0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801030a4:	83 e4 f0             	and    $0xfffffff0,%esp
801030a7:	ff 71 fc             	push   -0x4(%ecx)
801030aa:	55                   	push   %ebp
801030ab:	89 e5                	mov    %esp,%ebp
801030ad:	53                   	push   %ebx
801030ae:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801030af:	83 ec 08             	sub    $0x8,%esp
801030b2:	68 00 00 40 80       	push   $0x80400000
801030b7:	68 d0 92 11 80       	push   $0x801192d0
801030bc:	e8 9f f5 ff ff       	call   80102660 <kinit1>
  kvmalloc();      // kernel page table
801030c1:	e8 6a 42 00 00       	call   80107330 <kvmalloc>
  mpinit();        // detect other processors
801030c6:	e8 85 01 00 00       	call   80103250 <mpinit>
  lapicinit();     // interrupt controller
801030cb:	e8 80 f7 ff ff       	call   80102850 <lapicinit>
  seginit();       // segment descriptors
801030d0:	e8 0b 3d 00 00       	call   80106de0 <seginit>
  picinit();       // disable pic
801030d5:	e8 86 03 00 00       	call   80103460 <picinit>
  ioapicinit();    // another interrupt controller
801030da:	e8 51 f3 ff ff       	call   80102430 <ioapicinit>
  consoleinit();   // console hardware
801030df:	e8 7c d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801030e4:	e8 67 2f 00 00       	call   80106050 <uartinit>
  pinit();         // process table
801030e9:	e8 52 08 00 00       	call   80103940 <pinit>
  tvinit();        // trap vectors
801030ee:	e8 dd 2b 00 00       	call   80105cd0 <tvinit>
  binit();         // buffer cache
801030f3:	e8 48 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030f8:	e8 63 dd ff ff       	call   80100e60 <fileinit>
  ideinit();       // disk 
801030fd:	e8 0e f1 ff ff       	call   80102210 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103102:	83 c4 0c             	add    $0xc,%esp
80103105:	68 8a 00 00 00       	push   $0x8a
8010310a:	68 8c b4 10 80       	push   $0x8010b48c
8010310f:	68 00 70 00 80       	push   $0x80007000
80103114:	e8 97 17 00 00       	call   801048b0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103119:	83 c4 10             	add    $0x10,%esp
8010311c:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103123:	00 00 00 
80103126:	05 a0 27 11 80       	add    $0x801127a0,%eax
8010312b:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
80103130:	76 7e                	jbe    801031b0 <main+0x110>
80103132:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
80103137:	eb 20                	jmp    80103159 <main+0xb9>
80103139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103140:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103147:	00 00 00 
8010314a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103150:	05 a0 27 11 80       	add    $0x801127a0,%eax
80103155:	39 c3                	cmp    %eax,%ebx
80103157:	73 57                	jae    801031b0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103159:	e8 02 08 00 00       	call   80103960 <mycpu>
8010315e:	39 c3                	cmp    %eax,%ebx
80103160:	74 de                	je     80103140 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103162:	e8 69 f5 ff ff       	call   801026d0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103167:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010316a:	c7 05 f8 6f 00 80 80 	movl   $0x80103080,0x80006ff8
80103171:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103174:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010317b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010317e:	05 00 10 00 00       	add    $0x1000,%eax
80103183:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103188:	0f b6 03             	movzbl (%ebx),%eax
8010318b:	68 00 70 00 00       	push   $0x7000
80103190:	50                   	push   %eax
80103191:	e8 fa f7 ff ff       	call   80102990 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103196:	83 c4 10             	add    $0x10,%esp
80103199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031a0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801031a6:	85 c0                	test   %eax,%eax
801031a8:	74 f6                	je     801031a0 <main+0x100>
801031aa:	eb 94                	jmp    80103140 <main+0xa0>
801031ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801031b0:	83 ec 08             	sub    $0x8,%esp
801031b3:	68 00 00 00 8e       	push   $0x8e000000
801031b8:	68 00 00 40 80       	push   $0x80400000
801031bd:	e8 3e f4 ff ff       	call   80102600 <kinit2>
  userinit();      // first user process
801031c2:	e8 49 08 00 00       	call   80103a10 <userinit>
  mpmain();        // finish this processor's setup
801031c7:	e8 74 fe ff ff       	call   80103040 <mpmain>
801031cc:	66 90                	xchg   %ax,%ax
801031ce:	66 90                	xchg   %ax,%ax

801031d0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031d0:	55                   	push   %ebp
801031d1:	89 e5                	mov    %esp,%ebp
801031d3:	57                   	push   %edi
801031d4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031d5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801031db:	53                   	push   %ebx
  e = addr+len;
801031dc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801031df:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031e2:	39 de                	cmp    %ebx,%esi
801031e4:	72 10                	jb     801031f6 <mpsearch1+0x26>
801031e6:	eb 50                	jmp    80103238 <mpsearch1+0x68>
801031e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801031ef:	00 
801031f0:	89 fe                	mov    %edi,%esi
801031f2:	39 df                	cmp    %ebx,%edi
801031f4:	73 42                	jae    80103238 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031f6:	83 ec 04             	sub    $0x4,%esp
801031f9:	8d 7e 10             	lea    0x10(%esi),%edi
801031fc:	6a 04                	push   $0x4
801031fe:	68 49 78 10 80       	push   $0x80107849
80103203:	56                   	push   %esi
80103204:	e8 57 16 00 00       	call   80104860 <memcmp>
80103209:	83 c4 10             	add    $0x10,%esp
8010320c:	85 c0                	test   %eax,%eax
8010320e:	75 e0                	jne    801031f0 <mpsearch1+0x20>
80103210:	89 f2                	mov    %esi,%edx
80103212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103218:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010321b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010321e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103220:	39 fa                	cmp    %edi,%edx
80103222:	75 f4                	jne    80103218 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103224:	84 c0                	test   %al,%al
80103226:	75 c8                	jne    801031f0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103228:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010322b:	89 f0                	mov    %esi,%eax
8010322d:	5b                   	pop    %ebx
8010322e:	5e                   	pop    %esi
8010322f:	5f                   	pop    %edi
80103230:	5d                   	pop    %ebp
80103231:	c3                   	ret
80103232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103238:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010323b:	31 f6                	xor    %esi,%esi
}
8010323d:	5b                   	pop    %ebx
8010323e:	89 f0                	mov    %esi,%eax
80103240:	5e                   	pop    %esi
80103241:	5f                   	pop    %edi
80103242:	5d                   	pop    %ebp
80103243:	c3                   	ret
80103244:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010324b:	00 
8010324c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103250 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103250:	55                   	push   %ebp
80103251:	89 e5                	mov    %esp,%ebp
80103253:	57                   	push   %edi
80103254:	56                   	push   %esi
80103255:	53                   	push   %ebx
80103256:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103259:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103260:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103267:	c1 e0 08             	shl    $0x8,%eax
8010326a:	09 d0                	or     %edx,%eax
8010326c:	c1 e0 04             	shl    $0x4,%eax
8010326f:	75 1b                	jne    8010328c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103271:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103278:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010327f:	c1 e0 08             	shl    $0x8,%eax
80103282:	09 d0                	or     %edx,%eax
80103284:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103287:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010328c:	ba 00 04 00 00       	mov    $0x400,%edx
80103291:	e8 3a ff ff ff       	call   801031d0 <mpsearch1>
80103296:	89 c3                	mov    %eax,%ebx
80103298:	85 c0                	test   %eax,%eax
8010329a:	0f 84 58 01 00 00    	je     801033f8 <mpinit+0x1a8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032a0:	8b 73 04             	mov    0x4(%ebx),%esi
801032a3:	85 f6                	test   %esi,%esi
801032a5:	0f 84 3d 01 00 00    	je     801033e8 <mpinit+0x198>
  if(memcmp(conf, "PCMP", 4) != 0)
801032ab:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032ae:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801032b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801032b7:	6a 04                	push   $0x4
801032b9:	68 4e 78 10 80       	push   $0x8010784e
801032be:	50                   	push   %eax
801032bf:	e8 9c 15 00 00       	call   80104860 <memcmp>
801032c4:	83 c4 10             	add    $0x10,%esp
801032c7:	85 c0                	test   %eax,%eax
801032c9:	0f 85 19 01 00 00    	jne    801033e8 <mpinit+0x198>
  if(conf->version != 1 && conf->version != 4)
801032cf:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801032d6:	3c 01                	cmp    $0x1,%al
801032d8:	74 08                	je     801032e2 <mpinit+0x92>
801032da:	3c 04                	cmp    $0x4,%al
801032dc:	0f 85 06 01 00 00    	jne    801033e8 <mpinit+0x198>
  if(sum((uchar*)conf, conf->length) != 0)
801032e2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801032e9:	66 85 d2             	test   %dx,%dx
801032ec:	74 22                	je     80103310 <mpinit+0xc0>
801032ee:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801032f1:	89 f0                	mov    %esi,%eax
  sum = 0;
801032f3:	31 d2                	xor    %edx,%edx
801032f5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801032f8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801032ff:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103302:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103304:	39 f8                	cmp    %edi,%eax
80103306:	75 f0                	jne    801032f8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103308:	84 d2                	test   %dl,%dl
8010330a:	0f 85 d8 00 00 00    	jne    801033e8 <mpinit+0x198>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103310:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103316:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103319:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
8010331c:	a3 80 26 11 80       	mov    %eax,0x80112680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103321:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103328:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
8010332e:	01 d7                	add    %edx,%edi
80103330:	89 fa                	mov    %edi,%edx
  ismp = 1;
80103332:	bf 01 00 00 00       	mov    $0x1,%edi
80103337:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010333e:	00 
8010333f:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103340:	39 d0                	cmp    %edx,%eax
80103342:	73 19                	jae    8010335d <mpinit+0x10d>
    switch(*p){
80103344:	0f b6 08             	movzbl (%eax),%ecx
80103347:	80 f9 02             	cmp    $0x2,%cl
8010334a:	0f 84 80 00 00 00    	je     801033d0 <mpinit+0x180>
80103350:	77 6e                	ja     801033c0 <mpinit+0x170>
80103352:	84 c9                	test   %cl,%cl
80103354:	74 3a                	je     80103390 <mpinit+0x140>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103356:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103359:	39 d0                	cmp    %edx,%eax
8010335b:	72 e7                	jb     80103344 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010335d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103360:	85 ff                	test   %edi,%edi
80103362:	0f 84 dd 00 00 00    	je     80103445 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103368:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
8010336c:	74 15                	je     80103383 <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010336e:	b8 70 00 00 00       	mov    $0x70,%eax
80103373:	ba 22 00 00 00       	mov    $0x22,%edx
80103378:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103379:	ba 23 00 00 00       	mov    $0x23,%edx
8010337e:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010337f:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103382:	ee                   	out    %al,(%dx)
  }
}
80103383:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103386:	5b                   	pop    %ebx
80103387:	5e                   	pop    %esi
80103388:	5f                   	pop    %edi
80103389:	5d                   	pop    %ebp
8010338a:	c3                   	ret
8010338b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(ncpu < NCPU) {
80103390:	8b 0d 84 27 11 80    	mov    0x80112784,%ecx
80103396:	83 f9 07             	cmp    $0x7,%ecx
80103399:	7f 19                	jg     801033b4 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010339b:	69 f1 b0 00 00 00    	imul   $0xb0,%ecx,%esi
801033a1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801033a5:	83 c1 01             	add    $0x1,%ecx
801033a8:	89 0d 84 27 11 80    	mov    %ecx,0x80112784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033ae:	88 9e a0 27 11 80    	mov    %bl,-0x7feed860(%esi)
      p += sizeof(struct mpproc);
801033b4:	83 c0 14             	add    $0x14,%eax
      continue;
801033b7:	eb 87                	jmp    80103340 <mpinit+0xf0>
801033b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(*p){
801033c0:	83 e9 03             	sub    $0x3,%ecx
801033c3:	80 f9 01             	cmp    $0x1,%cl
801033c6:	76 8e                	jbe    80103356 <mpinit+0x106>
801033c8:	31 ff                	xor    %edi,%edi
801033ca:	e9 71 ff ff ff       	jmp    80103340 <mpinit+0xf0>
801033cf:	90                   	nop
      ioapicid = ioapic->apicno;
801033d0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801033d4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801033d7:	88 0d 80 27 11 80    	mov    %cl,0x80112780
      continue;
801033dd:	e9 5e ff ff ff       	jmp    80103340 <mpinit+0xf0>
801033e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801033e8:	83 ec 0c             	sub    $0xc,%esp
801033eb:	68 53 78 10 80       	push   $0x80107853
801033f0:	e8 8b cf ff ff       	call   80100380 <panic>
801033f5:	8d 76 00             	lea    0x0(%esi),%esi
{
801033f8:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801033fd:	eb 0b                	jmp    8010340a <mpinit+0x1ba>
801033ff:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
80103400:	89 f3                	mov    %esi,%ebx
80103402:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103408:	74 de                	je     801033e8 <mpinit+0x198>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010340a:	83 ec 04             	sub    $0x4,%esp
8010340d:	8d 73 10             	lea    0x10(%ebx),%esi
80103410:	6a 04                	push   $0x4
80103412:	68 49 78 10 80       	push   $0x80107849
80103417:	53                   	push   %ebx
80103418:	e8 43 14 00 00       	call   80104860 <memcmp>
8010341d:	83 c4 10             	add    $0x10,%esp
80103420:	85 c0                	test   %eax,%eax
80103422:	75 dc                	jne    80103400 <mpinit+0x1b0>
80103424:	89 da                	mov    %ebx,%edx
80103426:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010342d:	00 
8010342e:	66 90                	xchg   %ax,%ax
    sum += addr[i];
80103430:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103433:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103436:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103438:	39 d6                	cmp    %edx,%esi
8010343a:	75 f4                	jne    80103430 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010343c:	84 c0                	test   %al,%al
8010343e:	75 c0                	jne    80103400 <mpinit+0x1b0>
80103440:	e9 5b fe ff ff       	jmp    801032a0 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103445:	83 ec 0c             	sub    $0xc,%esp
80103448:	68 34 7c 10 80       	push   $0x80107c34
8010344d:	e8 2e cf ff ff       	call   80100380 <panic>
80103452:	66 90                	xchg   %ax,%ax
80103454:	66 90                	xchg   %ax,%ax
80103456:	66 90                	xchg   %ax,%ax
80103458:	66 90                	xchg   %ax,%ax
8010345a:	66 90                	xchg   %ax,%ax
8010345c:	66 90                	xchg   %ax,%ax
8010345e:	66 90                	xchg   %ax,%ax

80103460 <picinit>:
80103460:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103465:	ba 21 00 00 00       	mov    $0x21,%edx
8010346a:	ee                   	out    %al,(%dx)
8010346b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103470:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103471:	c3                   	ret
80103472:	66 90                	xchg   %ax,%ax
80103474:	66 90                	xchg   %ax,%ax
80103476:	66 90                	xchg   %ax,%ax
80103478:	66 90                	xchg   %ax,%ax
8010347a:	66 90                	xchg   %ax,%ax
8010347c:	66 90                	xchg   %ax,%ax
8010347e:	66 90                	xchg   %ax,%ax

80103480 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103480:	55                   	push   %ebp
80103481:	89 e5                	mov    %esp,%ebp
80103483:	57                   	push   %edi
80103484:	56                   	push   %esi
80103485:	53                   	push   %ebx
80103486:	83 ec 0c             	sub    $0xc,%esp
80103489:	8b 75 08             	mov    0x8(%ebp),%esi
8010348c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010348f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80103495:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010349b:	e8 e0 d9 ff ff       	call   80100e80 <filealloc>
801034a0:	89 06                	mov    %eax,(%esi)
801034a2:	85 c0                	test   %eax,%eax
801034a4:	0f 84 a5 00 00 00    	je     8010354f <pipealloc+0xcf>
801034aa:	e8 d1 d9 ff ff       	call   80100e80 <filealloc>
801034af:	89 07                	mov    %eax,(%edi)
801034b1:	85 c0                	test   %eax,%eax
801034b3:	0f 84 84 00 00 00    	je     8010353d <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801034b9:	e8 12 f2 ff ff       	call   801026d0 <kalloc>
801034be:	89 c3                	mov    %eax,%ebx
801034c0:	85 c0                	test   %eax,%eax
801034c2:	0f 84 a0 00 00 00    	je     80103568 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
801034c8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801034cf:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801034d2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801034d5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801034dc:	00 00 00 
  p->nwrite = 0;
801034df:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034e6:	00 00 00 
  p->nread = 0;
801034e9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034f0:	00 00 00 
  initlock(&p->lock, "pipe");
801034f3:	68 6b 78 10 80       	push   $0x8010786b
801034f8:	50                   	push   %eax
801034f9:	e8 32 10 00 00       	call   80104530 <initlock>
  (*f0)->type = FD_PIPE;
801034fe:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103500:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103503:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103509:	8b 06                	mov    (%esi),%eax
8010350b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010350f:	8b 06                	mov    (%esi),%eax
80103511:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103515:	8b 06                	mov    (%esi),%eax
80103517:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010351a:	8b 07                	mov    (%edi),%eax
8010351c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103522:	8b 07                	mov    (%edi),%eax
80103524:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103528:	8b 07                	mov    (%edi),%eax
8010352a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010352e:	8b 07                	mov    (%edi),%eax
80103530:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
80103533:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103535:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103538:	5b                   	pop    %ebx
80103539:	5e                   	pop    %esi
8010353a:	5f                   	pop    %edi
8010353b:	5d                   	pop    %ebp
8010353c:	c3                   	ret
  if(*f0)
8010353d:	8b 06                	mov    (%esi),%eax
8010353f:	85 c0                	test   %eax,%eax
80103541:	74 1e                	je     80103561 <pipealloc+0xe1>
    fileclose(*f0);
80103543:	83 ec 0c             	sub    $0xc,%esp
80103546:	50                   	push   %eax
80103547:	e8 f4 d9 ff ff       	call   80100f40 <fileclose>
8010354c:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010354f:	8b 07                	mov    (%edi),%eax
80103551:	85 c0                	test   %eax,%eax
80103553:	74 0c                	je     80103561 <pipealloc+0xe1>
    fileclose(*f1);
80103555:	83 ec 0c             	sub    $0xc,%esp
80103558:	50                   	push   %eax
80103559:	e8 e2 d9 ff ff       	call   80100f40 <fileclose>
8010355e:	83 c4 10             	add    $0x10,%esp
  return -1;
80103561:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103566:	eb cd                	jmp    80103535 <pipealloc+0xb5>
  if(*f0)
80103568:	8b 06                	mov    (%esi),%eax
8010356a:	85 c0                	test   %eax,%eax
8010356c:	75 d5                	jne    80103543 <pipealloc+0xc3>
8010356e:	eb df                	jmp    8010354f <pipealloc+0xcf>

80103570 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103570:	55                   	push   %ebp
80103571:	89 e5                	mov    %esp,%ebp
80103573:	56                   	push   %esi
80103574:	53                   	push   %ebx
80103575:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103578:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010357b:	83 ec 0c             	sub    $0xc,%esp
8010357e:	53                   	push   %ebx
8010357f:	e8 9c 11 00 00       	call   80104720 <acquire>
  if(writable){
80103584:	83 c4 10             	add    $0x10,%esp
80103587:	85 f6                	test   %esi,%esi
80103589:	74 65                	je     801035f0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010358b:	83 ec 0c             	sub    $0xc,%esp
8010358e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103594:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010359b:	00 00 00 
    wakeup(&p->nread);
8010359e:	50                   	push   %eax
8010359f:	e8 bc 0c 00 00       	call   80104260 <wakeup>
801035a4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801035a7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801035ad:	85 d2                	test   %edx,%edx
801035af:	75 0a                	jne    801035bb <pipeclose+0x4b>
801035b1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801035b7:	85 c0                	test   %eax,%eax
801035b9:	74 15                	je     801035d0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801035bb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801035be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035c1:	5b                   	pop    %ebx
801035c2:	5e                   	pop    %esi
801035c3:	5d                   	pop    %ebp
    release(&p->lock);
801035c4:	e9 f7 10 00 00       	jmp    801046c0 <release>
801035c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801035d0:	83 ec 0c             	sub    $0xc,%esp
801035d3:	53                   	push   %ebx
801035d4:	e8 e7 10 00 00       	call   801046c0 <release>
    kfree((char*)p);
801035d9:	83 c4 10             	add    $0x10,%esp
801035dc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801035df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035e2:	5b                   	pop    %ebx
801035e3:	5e                   	pop    %esi
801035e4:	5d                   	pop    %ebp
    kfree((char*)p);
801035e5:	e9 26 ef ff ff       	jmp    80102510 <kfree>
801035ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035f0:	83 ec 0c             	sub    $0xc,%esp
801035f3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035f9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103600:	00 00 00 
    wakeup(&p->nwrite);
80103603:	50                   	push   %eax
80103604:	e8 57 0c 00 00       	call   80104260 <wakeup>
80103609:	83 c4 10             	add    $0x10,%esp
8010360c:	eb 99                	jmp    801035a7 <pipeclose+0x37>
8010360e:	66 90                	xchg   %ax,%ax

80103610 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103610:	55                   	push   %ebp
80103611:	89 e5                	mov    %esp,%ebp
80103613:	57                   	push   %edi
80103614:	56                   	push   %esi
80103615:	53                   	push   %ebx
80103616:	83 ec 28             	sub    $0x28,%esp
80103619:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010361c:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
8010361f:	53                   	push   %ebx
80103620:	e8 fb 10 00 00       	call   80104720 <acquire>
  for(i = 0; i < n; i++){
80103625:	83 c4 10             	add    $0x10,%esp
80103628:	85 ff                	test   %edi,%edi
8010362a:	0f 8e ce 00 00 00    	jle    801036fe <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103630:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103636:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103639:	89 7d 10             	mov    %edi,0x10(%ebp)
8010363c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010363f:	8d 34 39             	lea    (%ecx,%edi,1),%esi
80103642:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103645:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010364b:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103651:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103657:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
8010365d:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
80103660:	0f 85 b6 00 00 00    	jne    8010371c <pipewrite+0x10c>
80103666:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103669:	eb 3e                	jmp    801036a9 <pipewrite+0x99>
8010366b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103670:	e8 6b 03 00 00       	call   801039e0 <myproc>
80103675:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
8010367b:	85 c9                	test   %ecx,%ecx
8010367d:	75 34                	jne    801036b3 <pipewrite+0xa3>
      wakeup(&p->nread);
8010367f:	83 ec 0c             	sub    $0xc,%esp
80103682:	56                   	push   %esi
80103683:	e8 d8 0b 00 00       	call   80104260 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103688:	58                   	pop    %eax
80103689:	5a                   	pop    %edx
8010368a:	53                   	push   %ebx
8010368b:	57                   	push   %edi
8010368c:	e8 ff 0a 00 00       	call   80104190 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103691:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103697:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010369d:	83 c4 10             	add    $0x10,%esp
801036a0:	05 00 02 00 00       	add    $0x200,%eax
801036a5:	39 c2                	cmp    %eax,%edx
801036a7:	75 27                	jne    801036d0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801036a9:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801036af:	85 c0                	test   %eax,%eax
801036b1:	75 bd                	jne    80103670 <pipewrite+0x60>
        release(&p->lock);
801036b3:	83 ec 0c             	sub    $0xc,%esp
801036b6:	53                   	push   %ebx
801036b7:	e8 04 10 00 00       	call   801046c0 <release>
        return -1;
801036bc:	83 c4 10             	add    $0x10,%esp
801036bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801036c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036c7:	5b                   	pop    %ebx
801036c8:	5e                   	pop    %esi
801036c9:	5f                   	pop    %edi
801036ca:	5d                   	pop    %ebp
801036cb:	c3                   	ret
801036cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036d0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036d3:	8d 42 01             	lea    0x1(%edx),%eax
801036d6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
801036dc:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036df:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801036e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801036e8:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
801036ec:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801036f3:	39 c1                	cmp    %eax,%ecx
801036f5:	0f 85 50 ff ff ff    	jne    8010364b <pipewrite+0x3b>
801036fb:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036fe:	83 ec 0c             	sub    $0xc,%esp
80103701:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103707:	50                   	push   %eax
80103708:	e8 53 0b 00 00       	call   80104260 <wakeup>
  release(&p->lock);
8010370d:	89 1c 24             	mov    %ebx,(%esp)
80103710:	e8 ab 0f 00 00       	call   801046c0 <release>
  return n;
80103715:	83 c4 10             	add    $0x10,%esp
80103718:	89 f8                	mov    %edi,%eax
8010371a:	eb a8                	jmp    801036c4 <pipewrite+0xb4>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010371c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010371f:	eb b2                	jmp    801036d3 <pipewrite+0xc3>
80103721:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103728:	00 
80103729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103730 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103730:	55                   	push   %ebp
80103731:	89 e5                	mov    %esp,%ebp
80103733:	57                   	push   %edi
80103734:	56                   	push   %esi
80103735:	53                   	push   %ebx
80103736:	83 ec 18             	sub    $0x18,%esp
80103739:	8b 75 08             	mov    0x8(%ebp),%esi
8010373c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010373f:	56                   	push   %esi
80103740:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103746:	e8 d5 0f 00 00       	call   80104720 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010374b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103751:	83 c4 10             	add    $0x10,%esp
80103754:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010375a:	74 32                	je     8010378e <piperead+0x5e>
8010375c:	eb 3a                	jmp    80103798 <piperead+0x68>
8010375e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103760:	e8 7b 02 00 00       	call   801039e0 <myproc>
80103765:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
8010376b:	85 c0                	test   %eax,%eax
8010376d:	0f 85 8d 00 00 00    	jne    80103800 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103773:	83 ec 08             	sub    $0x8,%esp
80103776:	56                   	push   %esi
80103777:	53                   	push   %ebx
80103778:	e8 13 0a 00 00       	call   80104190 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010377d:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103783:	83 c4 10             	add    $0x10,%esp
80103786:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010378c:	75 0a                	jne    80103798 <piperead+0x68>
8010378e:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103794:	85 d2                	test   %edx,%edx
80103796:	75 c8                	jne    80103760 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103798:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010379b:	31 db                	xor    %ebx,%ebx
8010379d:	85 c9                	test   %ecx,%ecx
8010379f:	7f 2b                	jg     801037cc <piperead+0x9c>
801037a1:	eb 31                	jmp    801037d4 <piperead+0xa4>
801037a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801037a8:	8d 48 01             	lea    0x1(%eax),%ecx
801037ab:	25 ff 01 00 00       	and    $0x1ff,%eax
801037b0:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801037b6:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801037bb:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037be:	83 c3 01             	add    $0x1,%ebx
801037c1:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801037c4:	74 0e                	je     801037d4 <piperead+0xa4>
801037c6:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
801037cc:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801037d2:	75 d4                	jne    801037a8 <piperead+0x78>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801037d4:	83 ec 0c             	sub    $0xc,%esp
801037d7:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801037dd:	50                   	push   %eax
801037de:	e8 7d 0a 00 00       	call   80104260 <wakeup>
  release(&p->lock);
801037e3:	89 34 24             	mov    %esi,(%esp)
801037e6:	e8 d5 0e 00 00       	call   801046c0 <release>
  return i;
801037eb:	83 c4 10             	add    $0x10,%esp
}
801037ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037f1:	89 d8                	mov    %ebx,%eax
801037f3:	5b                   	pop    %ebx
801037f4:	5e                   	pop    %esi
801037f5:	5f                   	pop    %edi
801037f6:	5d                   	pop    %ebp
801037f7:	c3                   	ret
801037f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801037ff:	00 
      release(&p->lock);
80103800:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103803:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103808:	56                   	push   %esi
80103809:	e8 b2 0e 00 00       	call   801046c0 <release>
      return -1;
8010380e:	83 c4 10             	add    $0x10,%esp
}
80103811:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103814:	89 d8                	mov    %ebx,%eax
80103816:	5b                   	pop    %ebx
80103817:	5e                   	pop    %esi
80103818:	5f                   	pop    %edi
80103819:	5d                   	pop    %ebp
8010381a:	c3                   	ret
8010381b:	66 90                	xchg   %ax,%ax
8010381d:	66 90                	xchg   %ax,%ax
8010381f:	90                   	nop

80103820 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103824:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103829:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010382c:	68 20 2d 11 80       	push   $0x80112d20
80103831:	e8 ea 0e 00 00       	call   80104720 <acquire>
80103836:	83 c4 10             	add    $0x10,%esp
80103839:	eb 13                	jmp    8010384e <allocproc+0x2e>
8010383b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103840:	81 c3 dc 00 00 00    	add    $0xdc,%ebx
80103846:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
8010384c:	74 7a                	je     801038c8 <allocproc+0xa8>
    if(p->state == UNUSED)
8010384e:	8b 43 6c             	mov    0x6c(%ebx),%eax
80103851:	85 c0                	test   %eax,%eax
80103853:	75 eb                	jne    80103840 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103855:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
8010385a:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010385d:	c7 43 6c 01 00 00 00 	movl   $0x1,0x6c(%ebx)
  p->pid = nextpid++;
80103864:	89 43 70             	mov    %eax,0x70(%ebx)
80103867:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
8010386a:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
8010386f:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103875:	e8 46 0e 00 00       	call   801046c0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010387a:	e8 51 ee ff ff       	call   801026d0 <kalloc>
8010387f:	83 c4 10             	add    $0x10,%esp
80103882:	89 43 68             	mov    %eax,0x68(%ebx)
80103885:	85 c0                	test   %eax,%eax
80103887:	74 58                	je     801038e1 <allocproc+0xc1>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103889:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010388f:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103892:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103897:	89 53 78             	mov    %edx,0x78(%ebx)
  *(uint*)sp = (uint)trapret;
8010389a:	c7 40 14 c2 5c 10 80 	movl   $0x80105cc2,0x14(%eax)
  p->context = (struct context*)sp;
801038a1:	89 43 7c             	mov    %eax,0x7c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801038a4:	6a 14                	push   $0x14
801038a6:	6a 00                	push   $0x0
801038a8:	50                   	push   %eax
801038a9:	e8 72 0f 00 00       	call   80104820 <memset>
  p->context->eip = (uint)forkret;
801038ae:	8b 43 7c             	mov    0x7c(%ebx),%eax

  return p;
801038b1:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801038b4:	c7 40 10 f0 38 10 80 	movl   $0x801038f0,0x10(%eax)
}
801038bb:	89 d8                	mov    %ebx,%eax
801038bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038c0:	c9                   	leave
801038c1:	c3                   	ret
801038c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801038c8:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801038cb:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801038cd:	68 20 2d 11 80       	push   $0x80112d20
801038d2:	e8 e9 0d 00 00       	call   801046c0 <release>
  return 0;
801038d7:	83 c4 10             	add    $0x10,%esp
}
801038da:	89 d8                	mov    %ebx,%eax
801038dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038df:	c9                   	leave
801038e0:	c3                   	ret
    p->state = UNUSED;
801038e1:	c7 43 6c 00 00 00 00 	movl   $0x0,0x6c(%ebx)
  return 0;
801038e8:	31 db                	xor    %ebx,%ebx
801038ea:	eb ee                	jmp    801038da <allocproc+0xba>
801038ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038f0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038f6:	68 20 2d 11 80       	push   $0x80112d20
801038fb:	e8 c0 0d 00 00       	call   801046c0 <release>

  if (first) {
80103900:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103905:	83 c4 10             	add    $0x10,%esp
80103908:	85 c0                	test   %eax,%eax
8010390a:	75 04                	jne    80103910 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010390c:	c9                   	leave
8010390d:	c3                   	ret
8010390e:	66 90                	xchg   %ax,%ax
    first = 0;
80103910:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103917:	00 00 00 
    iinit(ROOTDEV);
8010391a:	83 ec 0c             	sub    $0xc,%esp
8010391d:	6a 01                	push   $0x1
8010391f:	e8 8c dc ff ff       	call   801015b0 <iinit>
    initlog(ROOTDEV);
80103924:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010392b:	e8 e0 f3 ff ff       	call   80102d10 <initlog>
}
80103930:	83 c4 10             	add    $0x10,%esp
80103933:	c9                   	leave
80103934:	c3                   	ret
80103935:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010393c:	00 
8010393d:	8d 76 00             	lea    0x0(%esi),%esi

80103940 <pinit>:
{
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103946:	68 70 78 10 80       	push   $0x80107870
8010394b:	68 20 2d 11 80       	push   $0x80112d20
80103950:	e8 db 0b 00 00       	call   80104530 <initlock>
}
80103955:	83 c4 10             	add    $0x10,%esp
80103958:	c9                   	leave
80103959:	c3                   	ret
8010395a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103960 <mycpu>:
{
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	56                   	push   %esi
80103964:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103965:	9c                   	pushf
80103966:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103967:	f6 c4 02             	test   $0x2,%ah
8010396a:	75 46                	jne    801039b2 <mycpu+0x52>
  apicid = lapicid();
8010396c:	e8 cf ef ff ff       	call   80102940 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103971:	8b 35 84 27 11 80    	mov    0x80112784,%esi
80103977:	85 f6                	test   %esi,%esi
80103979:	7e 2a                	jle    801039a5 <mycpu+0x45>
8010397b:	31 d2                	xor    %edx,%edx
8010397d:	eb 08                	jmp    80103987 <mycpu+0x27>
8010397f:	90                   	nop
80103980:	83 c2 01             	add    $0x1,%edx
80103983:	39 f2                	cmp    %esi,%edx
80103985:	74 1e                	je     801039a5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103987:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010398d:	0f b6 99 a0 27 11 80 	movzbl -0x7feed860(%ecx),%ebx
80103994:	39 c3                	cmp    %eax,%ebx
80103996:	75 e8                	jne    80103980 <mycpu+0x20>
}
80103998:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010399b:	8d 81 a0 27 11 80    	lea    -0x7feed860(%ecx),%eax
}
801039a1:	5b                   	pop    %ebx
801039a2:	5e                   	pop    %esi
801039a3:	5d                   	pop    %ebp
801039a4:	c3                   	ret
  panic("unknown apicid\n");
801039a5:	83 ec 0c             	sub    $0xc,%esp
801039a8:	68 77 78 10 80       	push   $0x80107877
801039ad:	e8 ce c9 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
801039b2:	83 ec 0c             	sub    $0xc,%esp
801039b5:	68 54 7c 10 80       	push   $0x80107c54
801039ba:	e8 c1 c9 ff ff       	call   80100380 <panic>
801039bf:	90                   	nop

801039c0 <cpuid>:
cpuid() {
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801039c6:	e8 95 ff ff ff       	call   80103960 <mycpu>
}
801039cb:	c9                   	leave
  return mycpu()-cpus;
801039cc:	2d a0 27 11 80       	sub    $0x801127a0,%eax
801039d1:	c1 f8 04             	sar    $0x4,%eax
801039d4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801039da:	c3                   	ret
801039db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801039e0 <myproc>:
myproc(void) {
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
801039e3:	53                   	push   %ebx
801039e4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801039e7:	e8 e4 0b 00 00       	call   801045d0 <pushcli>
  c = mycpu();
801039ec:	e8 6f ff ff ff       	call   80103960 <mycpu>
  p = c->proc;
801039f1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039f7:	e8 24 0c 00 00       	call   80104620 <popcli>
}
801039fc:	89 d8                	mov    %ebx,%eax
801039fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a01:	c9                   	leave
80103a02:	c3                   	ret
80103a03:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103a0a:	00 
80103a0b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103a10 <userinit>:
{
80103a10:	55                   	push   %ebp
80103a11:	89 e5                	mov    %esp,%ebp
80103a13:	53                   	push   %ebx
80103a14:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103a17:	e8 04 fe ff ff       	call   80103820 <allocproc>
80103a1c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103a1e:	a3 40 7a 11 80       	mov    %eax,0x80117a40
  if((p->pgdir = setupkvm()) == 0)
80103a23:	e8 88 38 00 00       	call   801072b0 <setupkvm>
80103a28:	89 43 64             	mov    %eax,0x64(%ebx)
80103a2b:	85 c0                	test   %eax,%eax
80103a2d:	0f 84 c4 00 00 00    	je     80103af7 <userinit+0xe7>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a33:	83 ec 04             	sub    $0x4,%esp
80103a36:	68 2c 00 00 00       	push   $0x2c
80103a3b:	68 60 b4 10 80       	push   $0x8010b460
80103a40:	50                   	push   %eax
80103a41:	e8 4a 35 00 00       	call   80106f90 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a46:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a49:	c7 43 60 00 10 00 00 	movl   $0x1000,0x60(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a50:	6a 4c                	push   $0x4c
80103a52:	6a 00                	push   $0x0
80103a54:	ff 73 78             	push   0x78(%ebx)
80103a57:	e8 c4 0d 00 00       	call   80104820 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a5c:	8b 43 78             	mov    0x78(%ebx),%eax
80103a5f:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a64:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a67:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a6c:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a70:	8b 43 78             	mov    0x78(%ebx),%eax
80103a73:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a77:	8b 43 78             	mov    0x78(%ebx),%eax
80103a7a:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a7e:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a82:	8b 43 78             	mov    0x78(%ebx),%eax
80103a85:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a89:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a8d:	8b 43 78             	mov    0x78(%ebx),%eax
80103a90:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a97:	8b 43 78             	mov    0x78(%ebx),%eax
80103a9a:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103aa1:	8b 43 78             	mov    0x78(%ebx),%eax
80103aa4:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103aab:	8d 83 cc 00 00 00    	lea    0xcc(%ebx),%eax
80103ab1:	6a 10                	push   $0x10
80103ab3:	68 a0 78 10 80       	push   $0x801078a0
80103ab8:	50                   	push   %eax
80103ab9:	e8 12 0f 00 00       	call   801049d0 <safestrcpy>
  p->cwd = namei("/");
80103abe:	c7 04 24 a9 78 10 80 	movl   $0x801078a9,(%esp)
80103ac5:	e8 26 e6 ff ff       	call   801020f0 <namei>
80103aca:	89 83 c8 00 00 00    	mov    %eax,0xc8(%ebx)
  acquire(&ptable.lock);
80103ad0:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ad7:	e8 44 0c 00 00       	call   80104720 <acquire>
  p->state = RUNNABLE;
80103adc:	c7 43 6c 03 00 00 00 	movl   $0x3,0x6c(%ebx)
  release(&ptable.lock);
80103ae3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103aea:	e8 d1 0b 00 00       	call   801046c0 <release>
}
80103aef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103af2:	83 c4 10             	add    $0x10,%esp
80103af5:	c9                   	leave
80103af6:	c3                   	ret
    panic("userinit: out of memory?");
80103af7:	83 ec 0c             	sub    $0xc,%esp
80103afa:	68 87 78 10 80       	push   $0x80107887
80103aff:	e8 7c c8 ff ff       	call   80100380 <panic>
80103b04:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103b0b:	00 
80103b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103b10 <a1>:
}
80103b10:	c3                   	ret
80103b11:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103b18:	00 
80103b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103b20 <helper_chmod>:
void helper_chmod(){
80103b20:	c3                   	ret
80103b21:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103b28:	00 
80103b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103b30 <CHMOD>:
void CHMOD(){
80103b30:	c3                   	ret
80103b31:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103b38:	00 
80103b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103b40 <curr>:
void curr(){
80103b40:	c3                   	ret
80103b41:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103b48:	00 
80103b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103b50 <growproc>:
{
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	56                   	push   %esi
80103b54:	53                   	push   %ebx
80103b55:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103b58:	e8 73 0a 00 00       	call   801045d0 <pushcli>
  c = mycpu();
80103b5d:	e8 fe fd ff ff       	call   80103960 <mycpu>
  p = c->proc;
80103b62:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b68:	e8 b3 0a 00 00       	call   80104620 <popcli>
  sz = curproc->sz;
80103b6d:	8b 43 60             	mov    0x60(%ebx),%eax
  if(n > 0){
80103b70:	85 f6                	test   %esi,%esi
80103b72:	7f 1c                	jg     80103b90 <growproc+0x40>
  } else if(n < 0){
80103b74:	75 3a                	jne    80103bb0 <growproc+0x60>
  switchuvm(curproc);
80103b76:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103b79:	89 43 60             	mov    %eax,0x60(%ebx)
  switchuvm(curproc);
80103b7c:	53                   	push   %ebx
80103b7d:	e8 fe 32 00 00       	call   80106e80 <switchuvm>
  return 0;
80103b82:	83 c4 10             	add    $0x10,%esp
80103b85:	31 c0                	xor    %eax,%eax
}
80103b87:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b8a:	5b                   	pop    %ebx
80103b8b:	5e                   	pop    %esi
80103b8c:	5d                   	pop    %ebp
80103b8d:	c3                   	ret
80103b8e:	66 90                	xchg   %ax,%ax
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b90:	83 ec 04             	sub    $0x4,%esp
80103b93:	01 c6                	add    %eax,%esi
80103b95:	56                   	push   %esi
80103b96:	50                   	push   %eax
80103b97:	ff 73 64             	push   0x64(%ebx)
80103b9a:	e8 41 35 00 00       	call   801070e0 <allocuvm>
80103b9f:	83 c4 10             	add    $0x10,%esp
80103ba2:	85 c0                	test   %eax,%eax
80103ba4:	75 d0                	jne    80103b76 <growproc+0x26>
      return -1;
80103ba6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103bab:	eb da                	jmp    80103b87 <growproc+0x37>
80103bad:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103bb0:	83 ec 04             	sub    $0x4,%esp
80103bb3:	01 c6                	add    %eax,%esi
80103bb5:	56                   	push   %esi
80103bb6:	50                   	push   %eax
80103bb7:	ff 73 64             	push   0x64(%ebx)
80103bba:	e8 41 36 00 00       	call   80107200 <deallocuvm>
80103bbf:	83 c4 10             	add    $0x10,%esp
80103bc2:	85 c0                	test   %eax,%eax
80103bc4:	75 b0                	jne    80103b76 <growproc+0x26>
80103bc6:	eb de                	jmp    80103ba6 <growproc+0x56>
80103bc8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103bcf:	00 

80103bd0 <fork>:
{
80103bd0:	55                   	push   %ebp
80103bd1:	89 e5                	mov    %esp,%ebp
80103bd3:	57                   	push   %edi
80103bd4:	56                   	push   %esi
80103bd5:	53                   	push   %ebx
80103bd6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103bd9:	e8 f2 09 00 00       	call   801045d0 <pushcli>
  c = mycpu();
80103bde:	e8 7d fd ff ff       	call   80103960 <mycpu>
  p = c->proc;
80103be3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103be9:	e8 32 0a 00 00       	call   80104620 <popcli>
  if((np = allocproc()) == 0){
80103bee:	e8 2d fc ff ff       	call   80103820 <allocproc>
80103bf3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103bf6:	85 c0                	test   %eax,%eax
80103bf8:	0f 84 f0 00 00 00    	je     80103cee <fork+0x11e>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103bfe:	83 ec 08             	sub    $0x8,%esp
80103c01:	ff 73 60             	push   0x60(%ebx)
80103c04:	89 c7                	mov    %eax,%edi
80103c06:	ff 73 64             	push   0x64(%ebx)
80103c09:	e8 92 37 00 00       	call   801073a0 <copyuvm>
80103c0e:	83 c4 10             	add    $0x10,%esp
80103c11:	89 47 64             	mov    %eax,0x64(%edi)
80103c14:	85 c0                	test   %eax,%eax
80103c16:	0f 84 b3 00 00 00    	je     80103ccf <fork+0xff>
  np->sz = curproc->sz;
80103c1c:	8b 43 60             	mov    0x60(%ebx),%eax
80103c1f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103c22:	89 41 60             	mov    %eax,0x60(%ecx)
  *np->tf = *curproc->tf;
80103c25:	8b 79 78             	mov    0x78(%ecx),%edi
  np->parent = curproc;
80103c28:	89 c8                	mov    %ecx,%eax
80103c2a:	89 59 74             	mov    %ebx,0x74(%ecx)
  *np->tf = *curproc->tf;
80103c2d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103c32:	8b 73 78             	mov    0x78(%ebx),%esi
80103c35:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103c37:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103c39:	8b 40 78             	mov    0x78(%eax),%eax
80103c3c:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103c43:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103c48:	8b 84 b3 88 00 00 00 	mov    0x88(%ebx,%esi,4),%eax
80103c4f:	85 c0                	test   %eax,%eax
80103c51:	74 16                	je     80103c69 <fork+0x99>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103c53:	83 ec 0c             	sub    $0xc,%esp
80103c56:	50                   	push   %eax
80103c57:	e8 94 d2 ff ff       	call   80100ef0 <filedup>
80103c5c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103c5f:	83 c4 10             	add    $0x10,%esp
80103c62:	89 84 b2 88 00 00 00 	mov    %eax,0x88(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103c69:	83 c6 01             	add    $0x1,%esi
80103c6c:	83 fe 10             	cmp    $0x10,%esi
80103c6f:	75 d7                	jne    80103c48 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103c71:	83 ec 0c             	sub    $0xc,%esp
80103c74:	ff b3 c8 00 00 00    	push   0xc8(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c7a:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
  np->cwd = idup(curproc->cwd);
80103c80:	e8 3b db ff ff       	call   801017c0 <idup>
80103c85:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c88:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103c8b:	89 87 c8 00 00 00    	mov    %eax,0xc8(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c91:	8d 87 cc 00 00 00    	lea    0xcc(%edi),%eax
80103c97:	6a 10                	push   $0x10
80103c99:	53                   	push   %ebx
80103c9a:	50                   	push   %eax
80103c9b:	e8 30 0d 00 00       	call   801049d0 <safestrcpy>
  pid = np->pid;
80103ca0:	8b 5f 70             	mov    0x70(%edi),%ebx
  acquire(&ptable.lock);
80103ca3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103caa:	e8 71 0a 00 00       	call   80104720 <acquire>
  np->state = RUNNABLE;
80103caf:	c7 47 6c 03 00 00 00 	movl   $0x3,0x6c(%edi)
  release(&ptable.lock);
80103cb6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103cbd:	e8 fe 09 00 00       	call   801046c0 <release>
  return pid;
80103cc2:	83 c4 10             	add    $0x10,%esp
}
80103cc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cc8:	89 d8                	mov    %ebx,%eax
80103cca:	5b                   	pop    %ebx
80103ccb:	5e                   	pop    %esi
80103ccc:	5f                   	pop    %edi
80103ccd:	5d                   	pop    %ebp
80103cce:	c3                   	ret
    kfree(np->kstack);
80103ccf:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103cd2:	83 ec 0c             	sub    $0xc,%esp
80103cd5:	ff 73 68             	push   0x68(%ebx)
80103cd8:	e8 33 e8 ff ff       	call   80102510 <kfree>
    np->kstack = 0;
80103cdd:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
    return -1;
80103ce4:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103ce7:	c7 43 6c 00 00 00 00 	movl   $0x0,0x6c(%ebx)
    return -1;
80103cee:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103cf3:	eb d0                	jmp    80103cc5 <fork+0xf5>
80103cf5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103cfc:	00 
80103cfd:	8d 76 00             	lea    0x0(%esi),%esi

80103d00 <scheduler>:
{
80103d00:	55                   	push   %ebp
80103d01:	89 e5                	mov    %esp,%ebp
80103d03:	57                   	push   %edi
80103d04:	56                   	push   %esi
80103d05:	53                   	push   %ebx
80103d06:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103d09:	e8 52 fc ff ff       	call   80103960 <mycpu>
  c->proc = 0;
80103d0e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103d15:	00 00 00 
  struct cpu *c = mycpu();
80103d18:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103d1a:	8d 78 04             	lea    0x4(%eax),%edi
80103d1d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103d20:	fb                   	sti
    acquire(&ptable.lock);
80103d21:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d24:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103d29:	68 20 2d 11 80       	push   $0x80112d20
80103d2e:	e8 ed 09 00 00       	call   80104720 <acquire>
80103d33:	83 c4 10             	add    $0x10,%esp
80103d36:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103d3d:	00 
80103d3e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103d40:	83 7b 6c 03          	cmpl   $0x3,0x6c(%ebx)
80103d44:	75 33                	jne    80103d79 <scheduler+0x79>
      switchuvm(p);
80103d46:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103d49:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103d4f:	53                   	push   %ebx
80103d50:	e8 2b 31 00 00       	call   80106e80 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103d55:	58                   	pop    %eax
80103d56:	5a                   	pop    %edx
80103d57:	ff 73 7c             	push   0x7c(%ebx)
80103d5a:	57                   	push   %edi
      p->state = RUNNING;
80103d5b:	c7 43 6c 04 00 00 00 	movl   $0x4,0x6c(%ebx)
      swtch(&(c->scheduler), p->context);
80103d62:	e8 c4 0c 00 00       	call   80104a2b <swtch>
      switchkvm();
80103d67:	e8 04 31 00 00       	call   80106e70 <switchkvm>
      c->proc = 0;
80103d6c:	83 c4 10             	add    $0x10,%esp
80103d6f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103d76:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d79:	81 c3 dc 00 00 00    	add    $0xdc,%ebx
80103d7f:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
80103d85:	75 b9                	jne    80103d40 <scheduler+0x40>
    release(&ptable.lock);
80103d87:	83 ec 0c             	sub    $0xc,%esp
80103d8a:	68 20 2d 11 80       	push   $0x80112d20
80103d8f:	e8 2c 09 00 00       	call   801046c0 <release>
    sti();
80103d94:	83 c4 10             	add    $0x10,%esp
80103d97:	eb 87                	jmp    80103d20 <scheduler+0x20>
80103d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103da0 <sched>:
{
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	56                   	push   %esi
80103da4:	53                   	push   %ebx
  pushcli();
80103da5:	e8 26 08 00 00       	call   801045d0 <pushcli>
  c = mycpu();
80103daa:	e8 b1 fb ff ff       	call   80103960 <mycpu>
  p = c->proc;
80103daf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103db5:	e8 66 08 00 00       	call   80104620 <popcli>
  if(!holding(&ptable.lock))
80103dba:	83 ec 0c             	sub    $0xc,%esp
80103dbd:	68 20 2d 11 80       	push   $0x80112d20
80103dc2:	e8 b9 08 00 00       	call   80104680 <holding>
80103dc7:	83 c4 10             	add    $0x10,%esp
80103dca:	85 c0                	test   %eax,%eax
80103dcc:	74 4f                	je     80103e1d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103dce:	e8 8d fb ff ff       	call   80103960 <mycpu>
80103dd3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103dda:	75 68                	jne    80103e44 <sched+0xa4>
  if(p->state == RUNNING)
80103ddc:	83 7b 6c 04          	cmpl   $0x4,0x6c(%ebx)
80103de0:	74 55                	je     80103e37 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103de2:	9c                   	pushf
80103de3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103de4:	f6 c4 02             	test   $0x2,%ah
80103de7:	75 41                	jne    80103e2a <sched+0x8a>
  intena = mycpu()->intena;
80103de9:	e8 72 fb ff ff       	call   80103960 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103dee:	83 c3 7c             	add    $0x7c,%ebx
  intena = mycpu()->intena;
80103df1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103df7:	e8 64 fb ff ff       	call   80103960 <mycpu>
80103dfc:	83 ec 08             	sub    $0x8,%esp
80103dff:	ff 70 04             	push   0x4(%eax)
80103e02:	53                   	push   %ebx
80103e03:	e8 23 0c 00 00       	call   80104a2b <swtch>
  mycpu()->intena = intena;
80103e08:	e8 53 fb ff ff       	call   80103960 <mycpu>
}
80103e0d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103e10:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103e16:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e19:	5b                   	pop    %ebx
80103e1a:	5e                   	pop    %esi
80103e1b:	5d                   	pop    %ebp
80103e1c:	c3                   	ret
    panic("sched ptable.lock");
80103e1d:	83 ec 0c             	sub    $0xc,%esp
80103e20:	68 ab 78 10 80       	push   $0x801078ab
80103e25:	e8 56 c5 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103e2a:	83 ec 0c             	sub    $0xc,%esp
80103e2d:	68 d7 78 10 80       	push   $0x801078d7
80103e32:	e8 49 c5 ff ff       	call   80100380 <panic>
    panic("sched running");
80103e37:	83 ec 0c             	sub    $0xc,%esp
80103e3a:	68 c9 78 10 80       	push   $0x801078c9
80103e3f:	e8 3c c5 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103e44:	83 ec 0c             	sub    $0xc,%esp
80103e47:	68 bd 78 10 80       	push   $0x801078bd
80103e4c:	e8 2f c5 ff ff       	call   80100380 <panic>
80103e51:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e58:	00 
80103e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e60 <exit>:
{
80103e60:	55                   	push   %ebp
80103e61:	89 e5                	mov    %esp,%ebp
80103e63:	57                   	push   %edi
80103e64:	56                   	push   %esi
80103e65:	53                   	push   %ebx
80103e66:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103e69:	e8 72 fb ff ff       	call   801039e0 <myproc>
  if(curproc == initproc)
80103e6e:	39 05 40 7a 11 80    	cmp    %eax,0x80117a40
80103e74:	0f 84 71 01 00 00    	je     80103feb <exit+0x18b>
80103e7a:	89 c3                	mov    %eax,%ebx
80103e7c:	8d b0 88 00 00 00    	lea    0x88(%eax),%esi
80103e82:	8d b8 c8 00 00 00    	lea    0xc8(%eax),%edi
80103e88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e8f:	00 
    if(curproc->ofile[fd]){
80103e90:	8b 06                	mov    (%esi),%eax
80103e92:	85 c0                	test   %eax,%eax
80103e94:	74 12                	je     80103ea8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103e96:	83 ec 0c             	sub    $0xc,%esp
80103e99:	50                   	push   %eax
80103e9a:	e8 a1 d0 ff ff       	call   80100f40 <fileclose>
      curproc->ofile[fd] = 0;
80103e9f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103ea5:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103ea8:	83 c6 04             	add    $0x4,%esi
80103eab:	39 f7                	cmp    %esi,%edi
80103ead:	75 e1                	jne    80103e90 <exit+0x30>
  begin_op();
80103eaf:	e8 fc ee ff ff       	call   80102db0 <begin_op>
  iput(curproc->cwd);
80103eb4:	83 ec 0c             	sub    $0xc,%esp
80103eb7:	ff b3 c8 00 00 00    	push   0xc8(%ebx)
80103ebd:	e8 5e da ff ff       	call   80101920 <iput>
  end_op();
80103ec2:	e8 59 ef ff ff       	call   80102e20 <end_op>
  curproc->cwd = 0;
80103ec7:	c7 83 c8 00 00 00 00 	movl   $0x0,0xc8(%ebx)
80103ece:	00 00 00 
  acquire(&ptable.lock);
80103ed1:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ed8:	e8 43 08 00 00       	call   80104720 <acquire>
  wakeup1(curproc->parent);
80103edd:	8b 53 74             	mov    0x74(%ebx),%edx
80103ee0:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ee3:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103ee8:	eb 12                	jmp    80103efc <exit+0x9c>
80103eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103ef0:	05 dc 00 00 00       	add    $0xdc,%eax
80103ef5:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80103efa:	74 21                	je     80103f1d <exit+0xbd>
    if(p->state == SLEEPING && p->chan == chan)
80103efc:	83 78 6c 02          	cmpl   $0x2,0x6c(%eax)
80103f00:	75 ee                	jne    80103ef0 <exit+0x90>
80103f02:	3b 90 80 00 00 00    	cmp    0x80(%eax),%edx
80103f08:	75 e6                	jne    80103ef0 <exit+0x90>
      p->state = RUNNABLE;
80103f0a:	c7 40 6c 03 00 00 00 	movl   $0x3,0x6c(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f11:	05 dc 00 00 00       	add    $0xdc,%eax
80103f16:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80103f1b:	75 df                	jne    80103efc <exit+0x9c>
      p->parent = initproc;
80103f1d:	8b 0d 40 7a 11 80    	mov    0x80117a40,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f23:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103f28:	eb 14                	jmp    80103f3e <exit+0xde>
80103f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103f30:	81 c2 dc 00 00 00    	add    $0xdc,%edx
80103f36:	81 fa 54 64 11 80    	cmp    $0x80116454,%edx
80103f3c:	74 3d                	je     80103f7b <exit+0x11b>
    if(p->parent == curproc){
80103f3e:	39 5a 74             	cmp    %ebx,0x74(%edx)
80103f41:	75 ed                	jne    80103f30 <exit+0xd0>
      if(p->state == ZOMBIE)
80103f43:	83 7a 6c 05          	cmpl   $0x5,0x6c(%edx)
      p->parent = initproc;
80103f47:	89 4a 74             	mov    %ecx,0x74(%edx)
      if(p->state == ZOMBIE)
80103f4a:	75 e4                	jne    80103f30 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f4c:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103f51:	eb 11                	jmp    80103f64 <exit+0x104>
80103f53:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f58:	05 dc 00 00 00       	add    $0xdc,%eax
80103f5d:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80103f62:	74 cc                	je     80103f30 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
80103f64:	83 78 6c 02          	cmpl   $0x2,0x6c(%eax)
80103f68:	75 ee                	jne    80103f58 <exit+0xf8>
80103f6a:	3b 88 80 00 00 00    	cmp    0x80(%eax),%ecx
80103f70:	75 e6                	jne    80103f58 <exit+0xf8>
      p->state = RUNNABLE;
80103f72:	c7 40 6c 03 00 00 00 	movl   $0x3,0x6c(%eax)
80103f79:	eb dd                	jmp    80103f58 <exit+0xf8>
  if(nhistory < MAX_HISTORY){
80103f7b:	a1 54 64 11 80       	mov    0x80116454,%eax
80103f80:	3d c7 00 00 00       	cmp    $0xc7,%eax
80103f85:	7e 19                	jle    80103fa0 <exit+0x140>
  curproc->state = ZOMBIE;
80103f87:	c7 43 6c 05 00 00 00 	movl   $0x5,0x6c(%ebx)
  sched();
80103f8e:	e8 0d fe ff ff       	call   80103da0 <sched>
  panic("zombie exit");
80103f93:	83 ec 0c             	sub    $0xc,%esp
80103f96:	68 f8 78 10 80       	push   $0x801078f8
80103f9b:	e8 e0 c3 ff ff       	call   80100380 <panic>
    history_list[nhistory].pid = curproc->pid;
80103fa0:	6b c0 1c             	imul   $0x1c,%eax,%eax
80103fa3:	8b 53 70             	mov    0x70(%ebx),%edx
80103fa6:	89 90 60 64 11 80    	mov    %edx,-0x7fee9ba0(%eax)
    safestrcpy(history_list[nhistory].name, curproc->name, MAX_CMD_LEN);
80103fac:	05 64 64 11 80       	add    $0x80116464,%eax
80103fb1:	52                   	push   %edx
80103fb2:	8d 93 cc 00 00 00    	lea    0xcc(%ebx),%edx
80103fb8:	6a 10                	push   $0x10
80103fba:	52                   	push   %edx
80103fbb:	50                   	push   %eax
80103fbc:	e8 0f 0a 00 00       	call   801049d0 <safestrcpy>
    history_list[nhistory].mem_usage = curproc->sz; // sz is total bytes allocated
80103fc1:	a1 54 64 11 80       	mov    0x80116454,%eax
80103fc6:	8b 4b 60             	mov    0x60(%ebx),%ecx
    nhistory++;
80103fc9:	83 c4 10             	add    $0x10,%esp
    history_list[nhistory].mem_usage = curproc->sz; // sz is total bytes allocated
80103fcc:	6b d0 1c             	imul   $0x1c,%eax,%edx
    nhistory++;
80103fcf:	83 c0 01             	add    $0x1,%eax
80103fd2:	a3 54 64 11 80       	mov    %eax,0x80116454
    history_list[nhistory].mem_usage = curproc->sz; // sz is total bytes allocated
80103fd7:	89 8a 74 64 11 80    	mov    %ecx,-0x7fee9b8c(%edx)
    history_list[nhistory].ctime = ticks; // or any timestamp/sequence number
80103fdd:	8b 0d 60 7a 11 80    	mov    0x80117a60,%ecx
80103fe3:	89 8a 78 64 11 80    	mov    %ecx,-0x7fee9b88(%edx)
    helper_chmod();
80103fe9:	eb 9c                	jmp    80103f87 <exit+0x127>
    panic("init exiting");
80103feb:	83 ec 0c             	sub    $0xc,%esp
80103fee:	68 eb 78 10 80       	push   $0x801078eb
80103ff3:	e8 88 c3 ff ff       	call   80100380 <panic>
80103ff8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103fff:	00 

80104000 <wait>:
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	56                   	push   %esi
80104004:	53                   	push   %ebx
  pushcli();
80104005:	e8 c6 05 00 00       	call   801045d0 <pushcli>
  c = mycpu();
8010400a:	e8 51 f9 ff ff       	call   80103960 <mycpu>
  p = c->proc;
8010400f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104015:	e8 06 06 00 00       	call   80104620 <popcli>
  acquire(&ptable.lock);
8010401a:	83 ec 0c             	sub    $0xc,%esp
8010401d:	68 20 2d 11 80       	push   $0x80112d20
80104022:	e8 f9 06 00 00       	call   80104720 <acquire>
80104027:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010402a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010402c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80104031:	eb 13                	jmp    80104046 <wait+0x46>
80104033:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104038:	81 c3 dc 00 00 00    	add    $0xdc,%ebx
8010403e:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
80104044:	74 1e                	je     80104064 <wait+0x64>
      if(p->parent != curproc)
80104046:	39 73 74             	cmp    %esi,0x74(%ebx)
80104049:	75 ed                	jne    80104038 <wait+0x38>
      if(p->state == ZOMBIE){
8010404b:	83 7b 6c 05          	cmpl   $0x5,0x6c(%ebx)
8010404f:	74 6f                	je     801040c0 <wait+0xc0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104051:	81 c3 dc 00 00 00    	add    $0xdc,%ebx
      havekids = 1;
80104057:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010405c:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
80104062:	75 e2                	jne    80104046 <wait+0x46>
    if(!havekids || curproc->killed){
80104064:	85 c0                	test   %eax,%eax
80104066:	0f 84 b0 00 00 00    	je     8010411c <wait+0x11c>
8010406c:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
80104072:	85 c0                	test   %eax,%eax
80104074:	0f 85 a2 00 00 00    	jne    8010411c <wait+0x11c>
  pushcli();
8010407a:	e8 51 05 00 00       	call   801045d0 <pushcli>
  c = mycpu();
8010407f:	e8 dc f8 ff ff       	call   80103960 <mycpu>
  p = c->proc;
80104084:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010408a:	e8 91 05 00 00       	call   80104620 <popcli>
  if(p == 0)
8010408f:	85 db                	test   %ebx,%ebx
80104091:	0f 84 9c 00 00 00    	je     80104133 <wait+0x133>
  p->chan = chan;
80104097:	89 b3 80 00 00 00    	mov    %esi,0x80(%ebx)
  p->state = SLEEPING;
8010409d:	c7 43 6c 02 00 00 00 	movl   $0x2,0x6c(%ebx)
  sched();
801040a4:	e8 f7 fc ff ff       	call   80103da0 <sched>
  p->chan = 0;
801040a9:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
801040b0:	00 00 00 
}
801040b3:	e9 72 ff ff ff       	jmp    8010402a <wait+0x2a>
801040b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801040bf:	00 
        kfree(p->kstack);
801040c0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801040c3:	8b 73 70             	mov    0x70(%ebx),%esi
        kfree(p->kstack);
801040c6:	ff 73 68             	push   0x68(%ebx)
801040c9:	e8 42 e4 ff ff       	call   80102510 <kfree>
        p->kstack = 0;
801040ce:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
        freevm(p->pgdir);
801040d5:	5a                   	pop    %edx
801040d6:	ff 73 64             	push   0x64(%ebx)
801040d9:	e8 52 31 00 00       	call   80107230 <freevm>
        p->pid = 0;
801040de:	c7 43 70 00 00 00 00 	movl   $0x0,0x70(%ebx)
        p->parent = 0;
801040e5:	c7 43 74 00 00 00 00 	movl   $0x0,0x74(%ebx)
        p->name[0] = 0;
801040ec:	c6 83 cc 00 00 00 00 	movb   $0x0,0xcc(%ebx)
        p->killed = 0;
801040f3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
801040fa:	00 00 00 
        p->state = UNUSED;
801040fd:	c7 43 6c 00 00 00 00 	movl   $0x0,0x6c(%ebx)
        release(&ptable.lock);
80104104:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010410b:	e8 b0 05 00 00       	call   801046c0 <release>
        return pid;
80104110:	83 c4 10             	add    $0x10,%esp
}
80104113:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104116:	89 f0                	mov    %esi,%eax
80104118:	5b                   	pop    %ebx
80104119:	5e                   	pop    %esi
8010411a:	5d                   	pop    %ebp
8010411b:	c3                   	ret
      release(&ptable.lock);
8010411c:	83 ec 0c             	sub    $0xc,%esp
      return -1;
8010411f:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104124:	68 20 2d 11 80       	push   $0x80112d20
80104129:	e8 92 05 00 00       	call   801046c0 <release>
      return -1;
8010412e:	83 c4 10             	add    $0x10,%esp
80104131:	eb e0                	jmp    80104113 <wait+0x113>
    panic("sleep");
80104133:	83 ec 0c             	sub    $0xc,%esp
80104136:	68 04 79 10 80       	push   $0x80107904
8010413b:	e8 40 c2 ff ff       	call   80100380 <panic>

80104140 <yield>:
{
80104140:	55                   	push   %ebp
80104141:	89 e5                	mov    %esp,%ebp
80104143:	53                   	push   %ebx
80104144:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104147:	68 20 2d 11 80       	push   $0x80112d20
8010414c:	e8 cf 05 00 00       	call   80104720 <acquire>
  pushcli();
80104151:	e8 7a 04 00 00       	call   801045d0 <pushcli>
  c = mycpu();
80104156:	e8 05 f8 ff ff       	call   80103960 <mycpu>
  p = c->proc;
8010415b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104161:	e8 ba 04 00 00       	call   80104620 <popcli>
  myproc()->state = RUNNABLE;
80104166:	c7 43 6c 03 00 00 00 	movl   $0x3,0x6c(%ebx)
  sched();
8010416d:	e8 2e fc ff ff       	call   80103da0 <sched>
  release(&ptable.lock);
80104172:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104179:	e8 42 05 00 00       	call   801046c0 <release>
}
8010417e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104181:	83 c4 10             	add    $0x10,%esp
80104184:	c9                   	leave
80104185:	c3                   	ret
80104186:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010418d:	00 
8010418e:	66 90                	xchg   %ax,%ax

80104190 <sleep>:
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	57                   	push   %edi
80104194:	56                   	push   %esi
80104195:	53                   	push   %ebx
80104196:	83 ec 0c             	sub    $0xc,%esp
80104199:	8b 7d 08             	mov    0x8(%ebp),%edi
8010419c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010419f:	e8 2c 04 00 00       	call   801045d0 <pushcli>
  c = mycpu();
801041a4:	e8 b7 f7 ff ff       	call   80103960 <mycpu>
  p = c->proc;
801041a9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041af:	e8 6c 04 00 00       	call   80104620 <popcli>
  if(p == 0)
801041b4:	85 db                	test   %ebx,%ebx
801041b6:	0f 84 95 00 00 00    	je     80104251 <sleep+0xc1>
  if(lk == 0)
801041bc:	85 f6                	test   %esi,%esi
801041be:	0f 84 80 00 00 00    	je     80104244 <sleep+0xb4>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801041c4:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
801041ca:	74 54                	je     80104220 <sleep+0x90>
    acquire(&ptable.lock);  //DOC: sleeplock1
801041cc:	83 ec 0c             	sub    $0xc,%esp
801041cf:	68 20 2d 11 80       	push   $0x80112d20
801041d4:	e8 47 05 00 00       	call   80104720 <acquire>
    release(lk);
801041d9:	89 34 24             	mov    %esi,(%esp)
801041dc:	e8 df 04 00 00       	call   801046c0 <release>
  p->chan = chan;
801041e1:	89 bb 80 00 00 00    	mov    %edi,0x80(%ebx)
  p->state = SLEEPING;
801041e7:	c7 43 6c 02 00 00 00 	movl   $0x2,0x6c(%ebx)
  sched();
801041ee:	e8 ad fb ff ff       	call   80103da0 <sched>
  p->chan = 0;
801041f3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
801041fa:	00 00 00 
    release(&ptable.lock);
801041fd:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104204:	e8 b7 04 00 00       	call   801046c0 <release>
    acquire(lk);
80104209:	83 c4 10             	add    $0x10,%esp
8010420c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010420f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104212:	5b                   	pop    %ebx
80104213:	5e                   	pop    %esi
80104214:	5f                   	pop    %edi
80104215:	5d                   	pop    %ebp
    acquire(lk);
80104216:	e9 05 05 00 00       	jmp    80104720 <acquire>
8010421b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104220:	89 bb 80 00 00 00    	mov    %edi,0x80(%ebx)
  p->state = SLEEPING;
80104226:	c7 43 6c 02 00 00 00 	movl   $0x2,0x6c(%ebx)
  sched();
8010422d:	e8 6e fb ff ff       	call   80103da0 <sched>
  p->chan = 0;
80104232:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80104239:	00 00 00 
}
8010423c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010423f:	5b                   	pop    %ebx
80104240:	5e                   	pop    %esi
80104241:	5f                   	pop    %edi
80104242:	5d                   	pop    %ebp
80104243:	c3                   	ret
    panic("sleep without lk");
80104244:	83 ec 0c             	sub    $0xc,%esp
80104247:	68 0a 79 10 80       	push   $0x8010790a
8010424c:	e8 2f c1 ff ff       	call   80100380 <panic>
    panic("sleep");
80104251:	83 ec 0c             	sub    $0xc,%esp
80104254:	68 04 79 10 80       	push   $0x80107904
80104259:	e8 22 c1 ff ff       	call   80100380 <panic>
8010425e:	66 90                	xchg   %ax,%ax

80104260 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
80104263:	53                   	push   %ebx
80104264:	83 ec 10             	sub    $0x10,%esp
80104267:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010426a:	68 20 2d 11 80       	push   $0x80112d20
8010426f:	e8 ac 04 00 00       	call   80104720 <acquire>
80104274:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104277:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010427c:	eb 0e                	jmp    8010428c <wakeup+0x2c>
8010427e:	66 90                	xchg   %ax,%ax
80104280:	05 dc 00 00 00       	add    $0xdc,%eax
80104285:	3d 54 64 11 80       	cmp    $0x80116454,%eax
8010428a:	74 21                	je     801042ad <wakeup+0x4d>
    if(p->state == SLEEPING && p->chan == chan)
8010428c:	83 78 6c 02          	cmpl   $0x2,0x6c(%eax)
80104290:	75 ee                	jne    80104280 <wakeup+0x20>
80104292:	3b 98 80 00 00 00    	cmp    0x80(%eax),%ebx
80104298:	75 e6                	jne    80104280 <wakeup+0x20>
      p->state = RUNNABLE;
8010429a:	c7 40 6c 03 00 00 00 	movl   $0x3,0x6c(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042a1:	05 dc 00 00 00       	add    $0xdc,%eax
801042a6:	3d 54 64 11 80       	cmp    $0x80116454,%eax
801042ab:	75 df                	jne    8010428c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
801042ad:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
801042b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042b7:	c9                   	leave
  release(&ptable.lock);
801042b8:	e9 03 04 00 00       	jmp    801046c0 <release>
801042bd:	8d 76 00             	lea    0x0(%esi),%esi

801042c0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	53                   	push   %ebx
801042c4:	83 ec 10             	sub    $0x10,%esp
801042c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801042ca:	68 20 2d 11 80       	push   $0x80112d20
801042cf:	e8 4c 04 00 00       	call   80104720 <acquire>
801042d4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042d7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801042dc:	eb 0e                	jmp    801042ec <kill+0x2c>
801042de:	66 90                	xchg   %ax,%ax
801042e0:	05 dc 00 00 00       	add    $0xdc,%eax
801042e5:	3d 54 64 11 80       	cmp    $0x80116454,%eax
801042ea:	74 34                	je     80104320 <kill+0x60>
    if(p->pid == pid){
801042ec:	39 58 70             	cmp    %ebx,0x70(%eax)
801042ef:	75 ef                	jne    801042e0 <kill+0x20>
      p->killed = 1;
801042f1:	c7 80 84 00 00 00 01 	movl   $0x1,0x84(%eax)
801042f8:	00 00 00 
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801042fb:	83 78 6c 02          	cmpl   $0x2,0x6c(%eax)
801042ff:	75 07                	jne    80104308 <kill+0x48>
        p->state = RUNNABLE;
80104301:	c7 40 6c 03 00 00 00 	movl   $0x3,0x6c(%eax)
      release(&ptable.lock);
80104308:	83 ec 0c             	sub    $0xc,%esp
8010430b:	68 20 2d 11 80       	push   $0x80112d20
80104310:	e8 ab 03 00 00       	call   801046c0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104315:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104318:	83 c4 10             	add    $0x10,%esp
8010431b:	31 c0                	xor    %eax,%eax
}
8010431d:	c9                   	leave
8010431e:	c3                   	ret
8010431f:	90                   	nop
  release(&ptable.lock);
80104320:	83 ec 0c             	sub    $0xc,%esp
80104323:	68 20 2d 11 80       	push   $0x80112d20
80104328:	e8 93 03 00 00       	call   801046c0 <release>
}
8010432d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104330:	83 c4 10             	add    $0x10,%esp
80104333:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104338:	c9                   	leave
80104339:	c3                   	ret
8010433a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104340 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	57                   	push   %edi
80104344:	56                   	push   %esi
80104345:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104348:	53                   	push   %ebx
80104349:	bb 20 2e 11 80       	mov    $0x80112e20,%ebx
8010434e:	83 ec 3c             	sub    $0x3c,%esp
80104351:	eb 27                	jmp    8010437a <procdump+0x3a>
80104353:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104358:	83 ec 0c             	sub    $0xc,%esp
8010435b:	68 47 7b 10 80       	push   $0x80107b47
80104360:	e8 4b c3 ff ff       	call   801006b0 <cprintf>
80104365:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104368:	81 c3 dc 00 00 00    	add    $0xdc,%ebx
8010436e:	81 fb 20 65 11 80    	cmp    $0x80116520,%ebx
80104374:	0f 84 7e 00 00 00    	je     801043f8 <procdump+0xb8>
    if(p->state == UNUSED)
8010437a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010437d:	85 c0                	test   %eax,%eax
8010437f:	74 e7                	je     80104368 <procdump+0x28>
      state = "???";
80104381:	ba 1b 79 10 80       	mov    $0x8010791b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104386:	83 f8 05             	cmp    $0x5,%eax
80104389:	77 11                	ja     8010439c <procdump+0x5c>
8010438b:	8b 14 85 60 7f 10 80 	mov    -0x7fef80a0(,%eax,4),%edx
      state = "???";
80104392:	b8 1b 79 10 80       	mov    $0x8010791b,%eax
80104397:	85 d2                	test   %edx,%edx
80104399:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010439c:	53                   	push   %ebx
8010439d:	52                   	push   %edx
8010439e:	ff 73 a4             	push   -0x5c(%ebx)
801043a1:	68 1f 79 10 80       	push   $0x8010791f
801043a6:	e8 05 c3 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
801043ab:	83 c4 10             	add    $0x10,%esp
801043ae:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801043b2:	75 a4                	jne    80104358 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801043b4:	83 ec 08             	sub    $0x8,%esp
801043b7:	8d 45 c0             	lea    -0x40(%ebp),%eax
801043ba:	8d 7d c0             	lea    -0x40(%ebp),%edi
801043bd:	50                   	push   %eax
801043be:	8b 43 b0             	mov    -0x50(%ebx),%eax
801043c1:	8b 40 0c             	mov    0xc(%eax),%eax
801043c4:	83 c0 08             	add    $0x8,%eax
801043c7:	50                   	push   %eax
801043c8:	e8 83 01 00 00       	call   80104550 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801043cd:	83 c4 10             	add    $0x10,%esp
801043d0:	8b 17                	mov    (%edi),%edx
801043d2:	85 d2                	test   %edx,%edx
801043d4:	74 82                	je     80104358 <procdump+0x18>
        cprintf(" %p", pc[i]);
801043d6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801043d9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801043dc:	52                   	push   %edx
801043dd:	68 41 76 10 80       	push   $0x80107641
801043e2:	e8 c9 c2 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801043e7:	83 c4 10             	add    $0x10,%esp
801043ea:	39 f7                	cmp    %esi,%edi
801043ec:	75 e2                	jne    801043d0 <procdump+0x90>
801043ee:	e9 65 ff ff ff       	jmp    80104358 <procdump+0x18>
801043f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  }
}
801043f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043fb:	5b                   	pop    %ebx
801043fc:	5e                   	pop    %esi
801043fd:	5f                   	pop    %edi
801043fe:	5d                   	pop    %ebp
801043ff:	c3                   	ret

80104400 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	53                   	push   %ebx
80104404:	83 ec 0c             	sub    $0xc,%esp
80104407:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010440a:	68 52 79 10 80       	push   $0x80107952
8010440f:	8d 43 04             	lea    0x4(%ebx),%eax
80104412:	50                   	push   %eax
80104413:	e8 18 01 00 00       	call   80104530 <initlock>
  lk->name = name;
80104418:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010441b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104421:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104424:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010442b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010442e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104431:	c9                   	leave
80104432:	c3                   	ret
80104433:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010443a:	00 
8010443b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104440 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	56                   	push   %esi
80104444:	53                   	push   %ebx
80104445:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104448:	8d 73 04             	lea    0x4(%ebx),%esi
8010444b:	83 ec 0c             	sub    $0xc,%esp
8010444e:	56                   	push   %esi
8010444f:	e8 cc 02 00 00       	call   80104720 <acquire>
  while (lk->locked) {
80104454:	8b 13                	mov    (%ebx),%edx
80104456:	83 c4 10             	add    $0x10,%esp
80104459:	85 d2                	test   %edx,%edx
8010445b:	74 16                	je     80104473 <acquiresleep+0x33>
8010445d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104460:	83 ec 08             	sub    $0x8,%esp
80104463:	56                   	push   %esi
80104464:	53                   	push   %ebx
80104465:	e8 26 fd ff ff       	call   80104190 <sleep>
  while (lk->locked) {
8010446a:	8b 03                	mov    (%ebx),%eax
8010446c:	83 c4 10             	add    $0x10,%esp
8010446f:	85 c0                	test   %eax,%eax
80104471:	75 ed                	jne    80104460 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104473:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104479:	e8 62 f5 ff ff       	call   801039e0 <myproc>
8010447e:	8b 40 70             	mov    0x70(%eax),%eax
80104481:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104484:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104487:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010448a:	5b                   	pop    %ebx
8010448b:	5e                   	pop    %esi
8010448c:	5d                   	pop    %ebp
  release(&lk->lk);
8010448d:	e9 2e 02 00 00       	jmp    801046c0 <release>
80104492:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104499:	00 
8010449a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044a0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	56                   	push   %esi
801044a4:	53                   	push   %ebx
801044a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801044a8:	8d 73 04             	lea    0x4(%ebx),%esi
801044ab:	83 ec 0c             	sub    $0xc,%esp
801044ae:	56                   	push   %esi
801044af:	e8 6c 02 00 00       	call   80104720 <acquire>
  lk->locked = 0;
801044b4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801044ba:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801044c1:	89 1c 24             	mov    %ebx,(%esp)
801044c4:	e8 97 fd ff ff       	call   80104260 <wakeup>
  release(&lk->lk);
801044c9:	83 c4 10             	add    $0x10,%esp
801044cc:	89 75 08             	mov    %esi,0x8(%ebp)
}
801044cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044d2:	5b                   	pop    %ebx
801044d3:	5e                   	pop    %esi
801044d4:	5d                   	pop    %ebp
  release(&lk->lk);
801044d5:	e9 e6 01 00 00       	jmp    801046c0 <release>
801044da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044e0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	57                   	push   %edi
801044e4:	31 ff                	xor    %edi,%edi
801044e6:	56                   	push   %esi
801044e7:	53                   	push   %ebx
801044e8:	83 ec 18             	sub    $0x18,%esp
801044eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801044ee:	8d 73 04             	lea    0x4(%ebx),%esi
801044f1:	56                   	push   %esi
801044f2:	e8 29 02 00 00       	call   80104720 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801044f7:	8b 03                	mov    (%ebx),%eax
801044f9:	83 c4 10             	add    $0x10,%esp
801044fc:	85 c0                	test   %eax,%eax
801044fe:	75 18                	jne    80104518 <holdingsleep+0x38>
  release(&lk->lk);
80104500:	83 ec 0c             	sub    $0xc,%esp
80104503:	56                   	push   %esi
80104504:	e8 b7 01 00 00       	call   801046c0 <release>
  return r;
}
80104509:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010450c:	89 f8                	mov    %edi,%eax
8010450e:	5b                   	pop    %ebx
8010450f:	5e                   	pop    %esi
80104510:	5f                   	pop    %edi
80104511:	5d                   	pop    %ebp
80104512:	c3                   	ret
80104513:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
80104518:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010451b:	e8 c0 f4 ff ff       	call   801039e0 <myproc>
80104520:	39 58 70             	cmp    %ebx,0x70(%eax)
80104523:	0f 94 c0             	sete   %al
80104526:	0f b6 c0             	movzbl %al,%eax
80104529:	89 c7                	mov    %eax,%edi
8010452b:	eb d3                	jmp    80104500 <holdingsleep+0x20>
8010452d:	66 90                	xchg   %ax,%ax
8010452f:	90                   	nop

80104530 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104536:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104539:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010453f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104542:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104549:	5d                   	pop    %ebp
8010454a:	c3                   	ret
8010454b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104550 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	53                   	push   %ebx
80104554:	8b 45 08             	mov    0x8(%ebp),%eax
80104557:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010455a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010455d:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
80104562:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
80104567:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010456c:	76 10                	jbe    8010457e <getcallerpcs+0x2e>
8010456e:	eb 28                	jmp    80104598 <getcallerpcs+0x48>
80104570:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104576:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010457c:	77 1a                	ja     80104598 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010457e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104581:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104584:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104587:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104589:	83 f8 0a             	cmp    $0xa,%eax
8010458c:	75 e2                	jne    80104570 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010458e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104591:	c9                   	leave
80104592:	c3                   	ret
80104593:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104598:	8d 04 81             	lea    (%ecx,%eax,4),%eax
8010459b:	83 c1 28             	add    $0x28,%ecx
8010459e:	89 ca                	mov    %ecx,%edx
801045a0:	29 c2                	sub    %eax,%edx
801045a2:	83 e2 04             	and    $0x4,%edx
801045a5:	74 11                	je     801045b8 <getcallerpcs+0x68>
    pcs[i] = 0;
801045a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801045ad:	83 c0 04             	add    $0x4,%eax
801045b0:	39 c1                	cmp    %eax,%ecx
801045b2:	74 da                	je     8010458e <getcallerpcs+0x3e>
801045b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
801045b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801045be:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
801045c1:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
801045c8:	39 c1                	cmp    %eax,%ecx
801045ca:	75 ec                	jne    801045b8 <getcallerpcs+0x68>
801045cc:	eb c0                	jmp    8010458e <getcallerpcs+0x3e>
801045ce:	66 90                	xchg   %ax,%ax

801045d0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	53                   	push   %ebx
801045d4:	83 ec 04             	sub    $0x4,%esp
801045d7:	9c                   	pushf
801045d8:	5b                   	pop    %ebx
  asm volatile("cli");
801045d9:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801045da:	e8 81 f3 ff ff       	call   80103960 <mycpu>
801045df:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801045e5:	85 c0                	test   %eax,%eax
801045e7:	74 17                	je     80104600 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801045e9:	e8 72 f3 ff ff       	call   80103960 <mycpu>
801045ee:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801045f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045f8:	c9                   	leave
801045f9:	c3                   	ret
801045fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104600:	e8 5b f3 ff ff       	call   80103960 <mycpu>
80104605:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010460b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104611:	eb d6                	jmp    801045e9 <pushcli+0x19>
80104613:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010461a:	00 
8010461b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104620 <popcli>:

void
popcli(void)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104626:	9c                   	pushf
80104627:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104628:	f6 c4 02             	test   $0x2,%ah
8010462b:	75 35                	jne    80104662 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010462d:	e8 2e f3 ff ff       	call   80103960 <mycpu>
80104632:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104639:	78 34                	js     8010466f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010463b:	e8 20 f3 ff ff       	call   80103960 <mycpu>
80104640:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104646:	85 d2                	test   %edx,%edx
80104648:	74 06                	je     80104650 <popcli+0x30>
    sti();
}
8010464a:	c9                   	leave
8010464b:	c3                   	ret
8010464c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104650:	e8 0b f3 ff ff       	call   80103960 <mycpu>
80104655:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010465b:	85 c0                	test   %eax,%eax
8010465d:	74 eb                	je     8010464a <popcli+0x2a>
  asm volatile("sti");
8010465f:	fb                   	sti
}
80104660:	c9                   	leave
80104661:	c3                   	ret
    panic("popcli - interruptible");
80104662:	83 ec 0c             	sub    $0xc,%esp
80104665:	68 5d 79 10 80       	push   $0x8010795d
8010466a:	e8 11 bd ff ff       	call   80100380 <panic>
    panic("popcli");
8010466f:	83 ec 0c             	sub    $0xc,%esp
80104672:	68 74 79 10 80       	push   $0x80107974
80104677:	e8 04 bd ff ff       	call   80100380 <panic>
8010467c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104680 <holding>:
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	56                   	push   %esi
80104684:	53                   	push   %ebx
80104685:	8b 75 08             	mov    0x8(%ebp),%esi
80104688:	31 db                	xor    %ebx,%ebx
  pushcli();
8010468a:	e8 41 ff ff ff       	call   801045d0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010468f:	8b 06                	mov    (%esi),%eax
80104691:	85 c0                	test   %eax,%eax
80104693:	75 0b                	jne    801046a0 <holding+0x20>
  popcli();
80104695:	e8 86 ff ff ff       	call   80104620 <popcli>
}
8010469a:	89 d8                	mov    %ebx,%eax
8010469c:	5b                   	pop    %ebx
8010469d:	5e                   	pop    %esi
8010469e:	5d                   	pop    %ebp
8010469f:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
801046a0:	8b 5e 08             	mov    0x8(%esi),%ebx
801046a3:	e8 b8 f2 ff ff       	call   80103960 <mycpu>
801046a8:	39 c3                	cmp    %eax,%ebx
801046aa:	0f 94 c3             	sete   %bl
  popcli();
801046ad:	e8 6e ff ff ff       	call   80104620 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801046b2:	0f b6 db             	movzbl %bl,%ebx
}
801046b5:	89 d8                	mov    %ebx,%eax
801046b7:	5b                   	pop    %ebx
801046b8:	5e                   	pop    %esi
801046b9:	5d                   	pop    %ebp
801046ba:	c3                   	ret
801046bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801046c0 <release>:
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	56                   	push   %esi
801046c4:	53                   	push   %ebx
801046c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801046c8:	e8 03 ff ff ff       	call   801045d0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801046cd:	8b 03                	mov    (%ebx),%eax
801046cf:	85 c0                	test   %eax,%eax
801046d1:	75 15                	jne    801046e8 <release+0x28>
  popcli();
801046d3:	e8 48 ff ff ff       	call   80104620 <popcli>
    panic("release");
801046d8:	83 ec 0c             	sub    $0xc,%esp
801046db:	68 7b 79 10 80       	push   $0x8010797b
801046e0:	e8 9b bc ff ff       	call   80100380 <panic>
801046e5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801046e8:	8b 73 08             	mov    0x8(%ebx),%esi
801046eb:	e8 70 f2 ff ff       	call   80103960 <mycpu>
801046f0:	39 c6                	cmp    %eax,%esi
801046f2:	75 df                	jne    801046d3 <release+0x13>
  popcli();
801046f4:	e8 27 ff ff ff       	call   80104620 <popcli>
  lk->pcs[0] = 0;
801046f9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104700:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104707:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010470c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104712:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104715:	5b                   	pop    %ebx
80104716:	5e                   	pop    %esi
80104717:	5d                   	pop    %ebp
  popcli();
80104718:	e9 03 ff ff ff       	jmp    80104620 <popcli>
8010471d:	8d 76 00             	lea    0x0(%esi),%esi

80104720 <acquire>:
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	53                   	push   %ebx
80104724:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104727:	e8 a4 fe ff ff       	call   801045d0 <pushcli>
  if(holding(lk))
8010472c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010472f:	e8 9c fe ff ff       	call   801045d0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104734:	8b 03                	mov    (%ebx),%eax
80104736:	85 c0                	test   %eax,%eax
80104738:	0f 85 b2 00 00 00    	jne    801047f0 <acquire+0xd0>
  popcli();
8010473e:	e8 dd fe ff ff       	call   80104620 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104743:	b9 01 00 00 00       	mov    $0x1,%ecx
80104748:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010474f:	00 
  while(xchg(&lk->locked, 1) != 0)
80104750:	8b 55 08             	mov    0x8(%ebp),%edx
80104753:	89 c8                	mov    %ecx,%eax
80104755:	f0 87 02             	lock xchg %eax,(%edx)
80104758:	85 c0                	test   %eax,%eax
8010475a:	75 f4                	jne    80104750 <acquire+0x30>
  __sync_synchronize();
8010475c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104761:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104764:	e8 f7 f1 ff ff       	call   80103960 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104769:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
8010476c:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
8010476e:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104771:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
80104777:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
8010477c:	77 32                	ja     801047b0 <acquire+0x90>
  ebp = (uint*)v - 2;
8010477e:	89 e8                	mov    %ebp,%eax
80104780:	eb 14                	jmp    80104796 <acquire+0x76>
80104782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104788:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010478e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104794:	77 1a                	ja     801047b0 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
80104796:	8b 58 04             	mov    0x4(%eax),%ebx
80104799:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010479d:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801047a0:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801047a2:	83 fa 0a             	cmp    $0xa,%edx
801047a5:	75 e1                	jne    80104788 <acquire+0x68>
}
801047a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047aa:	c9                   	leave
801047ab:	c3                   	ret
801047ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047b0:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
801047b4:	83 c1 34             	add    $0x34,%ecx
801047b7:	89 ca                	mov    %ecx,%edx
801047b9:	29 c2                	sub    %eax,%edx
801047bb:	83 e2 04             	and    $0x4,%edx
801047be:	74 10                	je     801047d0 <acquire+0xb0>
    pcs[i] = 0;
801047c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801047c6:	83 c0 04             	add    $0x4,%eax
801047c9:	39 c1                	cmp    %eax,%ecx
801047cb:	74 da                	je     801047a7 <acquire+0x87>
801047cd:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
801047d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801047d6:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
801047d9:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
801047e0:	39 c1                	cmp    %eax,%ecx
801047e2:	75 ec                	jne    801047d0 <acquire+0xb0>
801047e4:	eb c1                	jmp    801047a7 <acquire+0x87>
801047e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801047ed:	00 
801047ee:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
801047f0:	8b 5b 08             	mov    0x8(%ebx),%ebx
801047f3:	e8 68 f1 ff ff       	call   80103960 <mycpu>
801047f8:	39 c3                	cmp    %eax,%ebx
801047fa:	0f 85 3e ff ff ff    	jne    8010473e <acquire+0x1e>
  popcli();
80104800:	e8 1b fe ff ff       	call   80104620 <popcli>
    panic("acquire");
80104805:	83 ec 0c             	sub    $0xc,%esp
80104808:	68 83 79 10 80       	push   $0x80107983
8010480d:	e8 6e bb ff ff       	call   80100380 <panic>
80104812:	66 90                	xchg   %ax,%ax
80104814:	66 90                	xchg   %ax,%ax
80104816:	66 90                	xchg   %ax,%ax
80104818:	66 90                	xchg   %ax,%ax
8010481a:	66 90                	xchg   %ax,%ax
8010481c:	66 90                	xchg   %ax,%ax
8010481e:	66 90                	xchg   %ax,%ax

80104820 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	57                   	push   %edi
80104824:	8b 55 08             	mov    0x8(%ebp),%edx
80104827:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010482a:	89 d0                	mov    %edx,%eax
8010482c:	09 c8                	or     %ecx,%eax
8010482e:	a8 03                	test   $0x3,%al
80104830:	75 1e                	jne    80104850 <memset+0x30>
    c &= 0xFF;
80104832:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104836:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
80104839:	89 d7                	mov    %edx,%edi
8010483b:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
80104841:	fc                   	cld
80104842:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104844:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104847:	89 d0                	mov    %edx,%eax
80104849:	c9                   	leave
8010484a:	c3                   	ret
8010484b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104850:	8b 45 0c             	mov    0xc(%ebp),%eax
80104853:	89 d7                	mov    %edx,%edi
80104855:	fc                   	cld
80104856:	f3 aa                	rep stos %al,%es:(%edi)
80104858:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010485b:	89 d0                	mov    %edx,%eax
8010485d:	c9                   	leave
8010485e:	c3                   	ret
8010485f:	90                   	nop

80104860 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	56                   	push   %esi
80104864:	8b 75 10             	mov    0x10(%ebp),%esi
80104867:	8b 45 08             	mov    0x8(%ebp),%eax
8010486a:	53                   	push   %ebx
8010486b:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010486e:	85 f6                	test   %esi,%esi
80104870:	74 2e                	je     801048a0 <memcmp+0x40>
80104872:	01 c6                	add    %eax,%esi
80104874:	eb 14                	jmp    8010488a <memcmp+0x2a>
80104876:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010487d:	00 
8010487e:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104880:	83 c0 01             	add    $0x1,%eax
80104883:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104886:	39 f0                	cmp    %esi,%eax
80104888:	74 16                	je     801048a0 <memcmp+0x40>
    if(*s1 != *s2)
8010488a:	0f b6 08             	movzbl (%eax),%ecx
8010488d:	0f b6 1a             	movzbl (%edx),%ebx
80104890:	38 d9                	cmp    %bl,%cl
80104892:	74 ec                	je     80104880 <memcmp+0x20>
      return *s1 - *s2;
80104894:	0f b6 c1             	movzbl %cl,%eax
80104897:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104899:	5b                   	pop    %ebx
8010489a:	5e                   	pop    %esi
8010489b:	5d                   	pop    %ebp
8010489c:	c3                   	ret
8010489d:	8d 76 00             	lea    0x0(%esi),%esi
801048a0:	5b                   	pop    %ebx
  return 0;
801048a1:	31 c0                	xor    %eax,%eax
}
801048a3:	5e                   	pop    %esi
801048a4:	5d                   	pop    %ebp
801048a5:	c3                   	ret
801048a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801048ad:	00 
801048ae:	66 90                	xchg   %ax,%ax

801048b0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	57                   	push   %edi
801048b4:	8b 55 08             	mov    0x8(%ebp),%edx
801048b7:	8b 45 10             	mov    0x10(%ebp),%eax
801048ba:	56                   	push   %esi
801048bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801048be:	39 d6                	cmp    %edx,%esi
801048c0:	73 26                	jae    801048e8 <memmove+0x38>
801048c2:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
801048c5:	39 ca                	cmp    %ecx,%edx
801048c7:	73 1f                	jae    801048e8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
801048c9:	85 c0                	test   %eax,%eax
801048cb:	74 0f                	je     801048dc <memmove+0x2c>
801048cd:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
801048d0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801048d4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801048d7:	83 e8 01             	sub    $0x1,%eax
801048da:	73 f4                	jae    801048d0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801048dc:	5e                   	pop    %esi
801048dd:	89 d0                	mov    %edx,%eax
801048df:	5f                   	pop    %edi
801048e0:	5d                   	pop    %ebp
801048e1:	c3                   	ret
801048e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
801048e8:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
801048eb:	89 d7                	mov    %edx,%edi
801048ed:	85 c0                	test   %eax,%eax
801048ef:	74 eb                	je     801048dc <memmove+0x2c>
801048f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801048f8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801048f9:	39 ce                	cmp    %ecx,%esi
801048fb:	75 fb                	jne    801048f8 <memmove+0x48>
}
801048fd:	5e                   	pop    %esi
801048fe:	89 d0                	mov    %edx,%eax
80104900:	5f                   	pop    %edi
80104901:	5d                   	pop    %ebp
80104902:	c3                   	ret
80104903:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010490a:	00 
8010490b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104910 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104910:	eb 9e                	jmp    801048b0 <memmove>
80104912:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104919:	00 
8010491a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104920 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	53                   	push   %ebx
80104924:	8b 55 10             	mov    0x10(%ebp),%edx
80104927:	8b 45 08             	mov    0x8(%ebp),%eax
8010492a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
8010492d:	85 d2                	test   %edx,%edx
8010492f:	75 16                	jne    80104947 <strncmp+0x27>
80104931:	eb 2d                	jmp    80104960 <strncmp+0x40>
80104933:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104938:	3a 19                	cmp    (%ecx),%bl
8010493a:	75 12                	jne    8010494e <strncmp+0x2e>
    n--, p++, q++;
8010493c:	83 c0 01             	add    $0x1,%eax
8010493f:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104942:	83 ea 01             	sub    $0x1,%edx
80104945:	74 19                	je     80104960 <strncmp+0x40>
80104947:	0f b6 18             	movzbl (%eax),%ebx
8010494a:	84 db                	test   %bl,%bl
8010494c:	75 ea                	jne    80104938 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010494e:	0f b6 00             	movzbl (%eax),%eax
80104951:	0f b6 11             	movzbl (%ecx),%edx
}
80104954:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104957:	c9                   	leave
  return (uchar)*p - (uchar)*q;
80104958:	29 d0                	sub    %edx,%eax
}
8010495a:	c3                   	ret
8010495b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104960:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80104963:	31 c0                	xor    %eax,%eax
}
80104965:	c9                   	leave
80104966:	c3                   	ret
80104967:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010496e:	00 
8010496f:	90                   	nop

80104970 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	57                   	push   %edi
80104974:	56                   	push   %esi
80104975:	8b 75 08             	mov    0x8(%ebp),%esi
80104978:	53                   	push   %ebx
80104979:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010497c:	89 f0                	mov    %esi,%eax
8010497e:	eb 15                	jmp    80104995 <strncpy+0x25>
80104980:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104984:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104987:	83 c0 01             	add    $0x1,%eax
8010498a:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
8010498e:	88 48 ff             	mov    %cl,-0x1(%eax)
80104991:	84 c9                	test   %cl,%cl
80104993:	74 13                	je     801049a8 <strncpy+0x38>
80104995:	89 d3                	mov    %edx,%ebx
80104997:	83 ea 01             	sub    $0x1,%edx
8010499a:	85 db                	test   %ebx,%ebx
8010499c:	7f e2                	jg     80104980 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
8010499e:	5b                   	pop    %ebx
8010499f:	89 f0                	mov    %esi,%eax
801049a1:	5e                   	pop    %esi
801049a2:	5f                   	pop    %edi
801049a3:	5d                   	pop    %ebp
801049a4:	c3                   	ret
801049a5:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
801049a8:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
801049ab:	83 e9 01             	sub    $0x1,%ecx
801049ae:	85 d2                	test   %edx,%edx
801049b0:	74 ec                	je     8010499e <strncpy+0x2e>
801049b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
801049b8:	83 c0 01             	add    $0x1,%eax
801049bb:	89 ca                	mov    %ecx,%edx
801049bd:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
801049c1:	29 c2                	sub    %eax,%edx
801049c3:	85 d2                	test   %edx,%edx
801049c5:	7f f1                	jg     801049b8 <strncpy+0x48>
}
801049c7:	5b                   	pop    %ebx
801049c8:	89 f0                	mov    %esi,%eax
801049ca:	5e                   	pop    %esi
801049cb:	5f                   	pop    %edi
801049cc:	5d                   	pop    %ebp
801049cd:	c3                   	ret
801049ce:	66 90                	xchg   %ax,%ax

801049d0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	56                   	push   %esi
801049d4:	8b 55 10             	mov    0x10(%ebp),%edx
801049d7:	8b 75 08             	mov    0x8(%ebp),%esi
801049da:	53                   	push   %ebx
801049db:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801049de:	85 d2                	test   %edx,%edx
801049e0:	7e 25                	jle    80104a07 <safestrcpy+0x37>
801049e2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801049e6:	89 f2                	mov    %esi,%edx
801049e8:	eb 16                	jmp    80104a00 <safestrcpy+0x30>
801049ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801049f0:	0f b6 08             	movzbl (%eax),%ecx
801049f3:	83 c0 01             	add    $0x1,%eax
801049f6:	83 c2 01             	add    $0x1,%edx
801049f9:	88 4a ff             	mov    %cl,-0x1(%edx)
801049fc:	84 c9                	test   %cl,%cl
801049fe:	74 04                	je     80104a04 <safestrcpy+0x34>
80104a00:	39 d8                	cmp    %ebx,%eax
80104a02:	75 ec                	jne    801049f0 <safestrcpy+0x20>
    ;
  *s = 0;
80104a04:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104a07:	89 f0                	mov    %esi,%eax
80104a09:	5b                   	pop    %ebx
80104a0a:	5e                   	pop    %esi
80104a0b:	5d                   	pop    %ebp
80104a0c:	c3                   	ret
80104a0d:	8d 76 00             	lea    0x0(%esi),%esi

80104a10 <strlen>:

int
strlen(const char *s)
{
80104a10:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104a11:	31 c0                	xor    %eax,%eax
{
80104a13:	89 e5                	mov    %esp,%ebp
80104a15:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104a18:	80 3a 00             	cmpb   $0x0,(%edx)
80104a1b:	74 0c                	je     80104a29 <strlen+0x19>
80104a1d:	8d 76 00             	lea    0x0(%esi),%esi
80104a20:	83 c0 01             	add    $0x1,%eax
80104a23:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104a27:	75 f7                	jne    80104a20 <strlen+0x10>
    ;
  return n;
}
80104a29:	5d                   	pop    %ebp
80104a2a:	c3                   	ret

80104a2b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104a2b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104a2f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104a33:	55                   	push   %ebp
  pushl %ebx
80104a34:	53                   	push   %ebx
  pushl %esi
80104a35:	56                   	push   %esi
  pushl %edi
80104a36:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104a37:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104a39:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104a3b:	5f                   	pop    %edi
  popl %esi
80104a3c:	5e                   	pop    %esi
  popl %ebx
80104a3d:	5b                   	pop    %ebx
  popl %ebp
80104a3e:	5d                   	pop    %ebp
  ret
80104a3f:	c3                   	ret

80104a40 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	53                   	push   %ebx
80104a44:	83 ec 04             	sub    $0x4,%esp
80104a47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104a4a:	e8 91 ef ff ff       	call   801039e0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a4f:	8b 40 60             	mov    0x60(%eax),%eax
80104a52:	39 c3                	cmp    %eax,%ebx
80104a54:	73 1a                	jae    80104a70 <fetchint+0x30>
80104a56:	8d 53 04             	lea    0x4(%ebx),%edx
80104a59:	39 d0                	cmp    %edx,%eax
80104a5b:	72 13                	jb     80104a70 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104a5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a60:	8b 13                	mov    (%ebx),%edx
80104a62:	89 10                	mov    %edx,(%eax)
  return 0;
80104a64:	31 c0                	xor    %eax,%eax
}
80104a66:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a69:	c9                   	leave
80104a6a:	c3                   	ret
80104a6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80104a70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a75:	eb ef                	jmp    80104a66 <fetchint+0x26>
80104a77:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a7e:	00 
80104a7f:	90                   	nop

80104a80 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	53                   	push   %ebx
80104a84:	83 ec 04             	sub    $0x4,%esp
80104a87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104a8a:	e8 51 ef ff ff       	call   801039e0 <myproc>

  if(addr >= curproc->sz)
80104a8f:	3b 58 60             	cmp    0x60(%eax),%ebx
80104a92:	73 2c                	jae    80104ac0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104a94:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a97:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104a99:	8b 50 60             	mov    0x60(%eax),%edx
  for(s = *pp; s < ep; s++){
80104a9c:	39 d3                	cmp    %edx,%ebx
80104a9e:	73 20                	jae    80104ac0 <fetchstr+0x40>
80104aa0:	89 d8                	mov    %ebx,%eax
80104aa2:	eb 0b                	jmp    80104aaf <fetchstr+0x2f>
80104aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104aa8:	83 c0 01             	add    $0x1,%eax
80104aab:	39 d0                	cmp    %edx,%eax
80104aad:	73 11                	jae    80104ac0 <fetchstr+0x40>
    if(*s == 0)
80104aaf:	80 38 00             	cmpb   $0x0,(%eax)
80104ab2:	75 f4                	jne    80104aa8 <fetchstr+0x28>
      return s - *pp;
80104ab4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104ab6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ab9:	c9                   	leave
80104aba:	c3                   	ret
80104abb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104ac0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104ac3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ac8:	c9                   	leave
80104ac9:	c3                   	ret
80104aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ad0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	56                   	push   %esi
80104ad4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ad5:	e8 06 ef ff ff       	call   801039e0 <myproc>
80104ada:	8b 55 08             	mov    0x8(%ebp),%edx
80104add:	8b 40 78             	mov    0x78(%eax),%eax
80104ae0:	8b 40 44             	mov    0x44(%eax),%eax
80104ae3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ae6:	e8 f5 ee ff ff       	call   801039e0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104aeb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104aee:	8b 40 60             	mov    0x60(%eax),%eax
80104af1:	39 c6                	cmp    %eax,%esi
80104af3:	73 1b                	jae    80104b10 <argint+0x40>
80104af5:	8d 53 08             	lea    0x8(%ebx),%edx
80104af8:	39 d0                	cmp    %edx,%eax
80104afa:	72 14                	jb     80104b10 <argint+0x40>
  *ip = *(int*)(addr);
80104afc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104aff:	8b 53 04             	mov    0x4(%ebx),%edx
80104b02:	89 10                	mov    %edx,(%eax)
  return 0;
80104b04:	31 c0                	xor    %eax,%eax
}
80104b06:	5b                   	pop    %ebx
80104b07:	5e                   	pop    %esi
80104b08:	5d                   	pop    %ebp
80104b09:	c3                   	ret
80104b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104b10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b15:	eb ef                	jmp    80104b06 <argint+0x36>
80104b17:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b1e:	00 
80104b1f:	90                   	nop

80104b20 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	57                   	push   %edi
80104b24:	56                   	push   %esi
80104b25:	53                   	push   %ebx
80104b26:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104b29:	e8 b2 ee ff ff       	call   801039e0 <myproc>
80104b2e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b30:	e8 ab ee ff ff       	call   801039e0 <myproc>
80104b35:	8b 55 08             	mov    0x8(%ebp),%edx
80104b38:	8b 40 78             	mov    0x78(%eax),%eax
80104b3b:	8b 40 44             	mov    0x44(%eax),%eax
80104b3e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b41:	e8 9a ee ff ff       	call   801039e0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b46:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b49:	8b 40 60             	mov    0x60(%eax),%eax
80104b4c:	39 c7                	cmp    %eax,%edi
80104b4e:	73 30                	jae    80104b80 <argptr+0x60>
80104b50:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104b53:	39 c8                	cmp    %ecx,%eax
80104b55:	72 29                	jb     80104b80 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104b57:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104b5a:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104b5d:	85 d2                	test   %edx,%edx
80104b5f:	78 1f                	js     80104b80 <argptr+0x60>
80104b61:	8b 56 60             	mov    0x60(%esi),%edx
80104b64:	39 d0                	cmp    %edx,%eax
80104b66:	73 18                	jae    80104b80 <argptr+0x60>
80104b68:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104b6b:	01 c3                	add    %eax,%ebx
80104b6d:	39 da                	cmp    %ebx,%edx
80104b6f:	72 0f                	jb     80104b80 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104b71:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b74:	89 02                	mov    %eax,(%edx)
  return 0;
80104b76:	31 c0                	xor    %eax,%eax
}
80104b78:	83 c4 0c             	add    $0xc,%esp
80104b7b:	5b                   	pop    %ebx
80104b7c:	5e                   	pop    %esi
80104b7d:	5f                   	pop    %edi
80104b7e:	5d                   	pop    %ebp
80104b7f:	c3                   	ret
    return -1;
80104b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b85:	eb f1                	jmp    80104b78 <argptr+0x58>
80104b87:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b8e:	00 
80104b8f:	90                   	nop

80104b90 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	56                   	push   %esi
80104b94:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b95:	e8 46 ee ff ff       	call   801039e0 <myproc>
80104b9a:	8b 55 08             	mov    0x8(%ebp),%edx
80104b9d:	8b 40 78             	mov    0x78(%eax),%eax
80104ba0:	8b 40 44             	mov    0x44(%eax),%eax
80104ba3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ba6:	e8 35 ee ff ff       	call   801039e0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bab:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bae:	8b 40 60             	mov    0x60(%eax),%eax
80104bb1:	39 c6                	cmp    %eax,%esi
80104bb3:	73 43                	jae    80104bf8 <argstr+0x68>
80104bb5:	8d 53 08             	lea    0x8(%ebx),%edx
80104bb8:	39 d0                	cmp    %edx,%eax
80104bba:	72 3c                	jb     80104bf8 <argstr+0x68>
  *ip = *(int*)(addr);
80104bbc:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104bbf:	e8 1c ee ff ff       	call   801039e0 <myproc>
  if(addr >= curproc->sz)
80104bc4:	3b 58 60             	cmp    0x60(%eax),%ebx
80104bc7:	73 2f                	jae    80104bf8 <argstr+0x68>
  *pp = (char*)addr;
80104bc9:	8b 55 0c             	mov    0xc(%ebp),%edx
80104bcc:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104bce:	8b 50 60             	mov    0x60(%eax),%edx
  for(s = *pp; s < ep; s++){
80104bd1:	39 d3                	cmp    %edx,%ebx
80104bd3:	73 23                	jae    80104bf8 <argstr+0x68>
80104bd5:	89 d8                	mov    %ebx,%eax
80104bd7:	eb 0e                	jmp    80104be7 <argstr+0x57>
80104bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104be0:	83 c0 01             	add    $0x1,%eax
80104be3:	39 d0                	cmp    %edx,%eax
80104be5:	73 11                	jae    80104bf8 <argstr+0x68>
    if(*s == 0)
80104be7:	80 38 00             	cmpb   $0x0,(%eax)
80104bea:	75 f4                	jne    80104be0 <argstr+0x50>
      return s - *pp;
80104bec:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104bee:	5b                   	pop    %ebx
80104bef:	5e                   	pop    %esi
80104bf0:	5d                   	pop    %ebp
80104bf1:	c3                   	ret
80104bf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104bf8:	5b                   	pop    %ebx
    return -1;
80104bf9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bfe:	5e                   	pop    %esi
80104bff:	5d                   	pop    %ebp
80104c00:	c3                   	ret
80104c01:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c08:	00 
80104c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104c10 <syscall>:
//   }
// }

void
syscall(void)
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	53                   	push   %ebx
80104c14:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *p = myproc();
80104c17:	e8 c4 ed ff ff       	call   801039e0 <myproc>
80104c1c:	89 c3                	mov    %eax,%ebx

  num = p->tf->eax;  // retrieve the syscall number
80104c1e:	8b 40 78             	mov    0x78(%eax),%eax
80104c21:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104c24:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c27:	83 fa 18             	cmp    $0x18,%edx
80104c2a:	77 24                	ja     80104c50 <syscall+0x40>
80104c2c:	8b 14 85 80 7f 10 80 	mov    -0x7fef8080(,%eax,4),%edx
80104c33:	85 d2                	test   %edx,%edx
80104c35:	74 19                	je     80104c50 <syscall+0x40>
    if(p->blocked_syscalls[num] == 1) {   // check the block flag
80104c37:	83 3c 83 01          	cmpl   $0x1,(%ebx,%eax,4)
80104c3b:	74 43                	je     80104c80 <syscall+0x70>
      cprintf("syscall %d is blocked\n", num);
      p->tf->eax = -1;   // return error code
      return;
    }
    p->tf->eax = syscalls[num]();
80104c3d:	ff d2                	call   *%edx
80104c3f:	89 c2                	mov    %eax,%edx
80104c41:	8b 43 78             	mov    0x78(%ebx),%eax
80104c44:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    p->tf->eax = -1;
  }
}
80104c47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c4a:	c9                   	leave
80104c4b:	c3                   	ret
80104c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n", p->pid, p->name, num);
80104c50:	50                   	push   %eax
80104c51:	8d 83 cc 00 00 00    	lea    0xcc(%ebx),%eax
80104c57:	50                   	push   %eax
80104c58:	ff 73 70             	push   0x70(%ebx)
80104c5b:	68 a2 79 10 80       	push   $0x801079a2
80104c60:	e8 4b ba ff ff       	call   801006b0 <cprintf>
    p->tf->eax = -1;
80104c65:	8b 43 78             	mov    0x78(%ebx),%eax
80104c68:	83 c4 10             	add    $0x10,%esp
80104c6b:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104c72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c75:	c9                   	leave
80104c76:	c3                   	ret
80104c77:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c7e:	00 
80104c7f:	90                   	nop
      cprintf("syscall %d is blocked\n", num);
80104c80:	83 ec 08             	sub    $0x8,%esp
80104c83:	50                   	push   %eax
80104c84:	68 8b 79 10 80       	push   $0x8010798b
80104c89:	e8 22 ba ff ff       	call   801006b0 <cprintf>
      p->tf->eax = -1;   // return error code
80104c8e:	8b 43 78             	mov    0x78(%ebx),%eax
      return;
80104c91:	83 c4 10             	add    $0x10,%esp
      p->tf->eax = -1;   // return error code
80104c94:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
      return;
80104c9b:	eb d5                	jmp    80104c72 <syscall+0x62>
80104c9d:	66 90                	xchg   %ax,%ax
80104c9f:	90                   	nop

80104ca0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ca0:	55                   	push   %ebp
80104ca1:	89 e5                	mov    %esp,%ebp
80104ca3:	57                   	push   %edi
80104ca4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104ca5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104ca8:	53                   	push   %ebx
80104ca9:	83 ec 34             	sub    $0x34,%esp
80104cac:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104caf:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104cb2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104cb5:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104cb8:	57                   	push   %edi
80104cb9:	50                   	push   %eax
80104cba:	e8 51 d4 ff ff       	call   80102110 <nameiparent>
80104cbf:	83 c4 10             	add    $0x10,%esp
80104cc2:	85 c0                	test   %eax,%eax
80104cc4:	74 5e                	je     80104d24 <create+0x84>
    return 0;
  ilock(dp);
80104cc6:	83 ec 0c             	sub    $0xc,%esp
80104cc9:	89 c3                	mov    %eax,%ebx
80104ccb:	50                   	push   %eax
80104ccc:	e8 1f cb ff ff       	call   801017f0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104cd1:	83 c4 0c             	add    $0xc,%esp
80104cd4:	6a 00                	push   $0x0
80104cd6:	57                   	push   %edi
80104cd7:	53                   	push   %ebx
80104cd8:	e8 73 d0 ff ff       	call   80101d50 <dirlookup>
80104cdd:	83 c4 10             	add    $0x10,%esp
80104ce0:	89 c6                	mov    %eax,%esi
80104ce2:	85 c0                	test   %eax,%eax
80104ce4:	74 4a                	je     80104d30 <create+0x90>
    iunlockput(dp);
80104ce6:	83 ec 0c             	sub    $0xc,%esp
80104ce9:	53                   	push   %ebx
80104cea:	e8 91 cd ff ff       	call   80101a80 <iunlockput>
    ilock(ip);
80104cef:	89 34 24             	mov    %esi,(%esp)
80104cf2:	e8 f9 ca ff ff       	call   801017f0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104cf7:	83 c4 10             	add    $0x10,%esp
80104cfa:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104cff:	75 17                	jne    80104d18 <create+0x78>
80104d01:	66 83 7e 52 02       	cmpw   $0x2,0x52(%esi)
80104d06:	75 10                	jne    80104d18 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104d08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d0b:	89 f0                	mov    %esi,%eax
80104d0d:	5b                   	pop    %ebx
80104d0e:	5e                   	pop    %esi
80104d0f:	5f                   	pop    %edi
80104d10:	5d                   	pop    %ebp
80104d11:	c3                   	ret
80104d12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80104d18:	83 ec 0c             	sub    $0xc,%esp
80104d1b:	56                   	push   %esi
80104d1c:	e8 5f cd ff ff       	call   80101a80 <iunlockput>
    return 0;
80104d21:	83 c4 10             	add    $0x10,%esp
}
80104d24:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104d27:	31 f6                	xor    %esi,%esi
}
80104d29:	5b                   	pop    %ebx
80104d2a:	89 f0                	mov    %esi,%eax
80104d2c:	5e                   	pop    %esi
80104d2d:	5f                   	pop    %edi
80104d2e:	5d                   	pop    %ebp
80104d2f:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80104d30:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104d34:	83 ec 08             	sub    $0x8,%esp
80104d37:	50                   	push   %eax
80104d38:	ff 33                	push   (%ebx)
80104d3a:	e8 21 c9 ff ff       	call   80101660 <ialloc>
80104d3f:	83 c4 10             	add    $0x10,%esp
80104d42:	89 c6                	mov    %eax,%esi
80104d44:	85 c0                	test   %eax,%eax
80104d46:	0f 84 bc 00 00 00    	je     80104e08 <create+0x168>
  ilock(ip);
80104d4c:	83 ec 0c             	sub    $0xc,%esp
80104d4f:	50                   	push   %eax
80104d50:	e8 9b ca ff ff       	call   801017f0 <ilock>
  ip->major = major;
80104d55:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104d59:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->minor = minor;
80104d5d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104d61:	66 89 46 56          	mov    %ax,0x56(%esi)
  ip->nlink = 1;
80104d65:	b8 01 00 00 00       	mov    $0x1,%eax
80104d6a:	66 89 46 58          	mov    %ax,0x58(%esi)
  iupdate(ip);
80104d6e:	89 34 24             	mov    %esi,(%esp)
80104d71:	e8 ba c9 ff ff       	call   80101730 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104d76:	83 c4 10             	add    $0x10,%esp
80104d79:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104d7e:	74 30                	je     80104db0 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80104d80:	83 ec 04             	sub    $0x4,%esp
80104d83:	ff 76 04             	push   0x4(%esi)
80104d86:	57                   	push   %edi
80104d87:	53                   	push   %ebx
80104d88:	e8 a3 d2 ff ff       	call   80102030 <dirlink>
80104d8d:	83 c4 10             	add    $0x10,%esp
80104d90:	85 c0                	test   %eax,%eax
80104d92:	78 67                	js     80104dfb <create+0x15b>
  iunlockput(dp);
80104d94:	83 ec 0c             	sub    $0xc,%esp
80104d97:	53                   	push   %ebx
80104d98:	e8 e3 cc ff ff       	call   80101a80 <iunlockput>
  return ip;
80104d9d:	83 c4 10             	add    $0x10,%esp
}
80104da0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104da3:	89 f0                	mov    %esi,%eax
80104da5:	5b                   	pop    %ebx
80104da6:	5e                   	pop    %esi
80104da7:	5f                   	pop    %edi
80104da8:	5d                   	pop    %ebp
80104da9:	c3                   	ret
80104daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104db0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104db3:	66 83 43 58 01       	addw   $0x1,0x58(%ebx)
    iupdate(dp);
80104db8:	53                   	push   %ebx
80104db9:	e8 72 c9 ff ff       	call   80101730 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104dbe:	83 c4 0c             	add    $0xc,%esp
80104dc1:	ff 76 04             	push   0x4(%esi)
80104dc4:	68 da 79 10 80       	push   $0x801079da
80104dc9:	56                   	push   %esi
80104dca:	e8 61 d2 ff ff       	call   80102030 <dirlink>
80104dcf:	83 c4 10             	add    $0x10,%esp
80104dd2:	85 c0                	test   %eax,%eax
80104dd4:	78 18                	js     80104dee <create+0x14e>
80104dd6:	83 ec 04             	sub    $0x4,%esp
80104dd9:	ff 73 04             	push   0x4(%ebx)
80104ddc:	68 d9 79 10 80       	push   $0x801079d9
80104de1:	56                   	push   %esi
80104de2:	e8 49 d2 ff ff       	call   80102030 <dirlink>
80104de7:	83 c4 10             	add    $0x10,%esp
80104dea:	85 c0                	test   %eax,%eax
80104dec:	79 92                	jns    80104d80 <create+0xe0>
      panic("create dots");
80104dee:	83 ec 0c             	sub    $0xc,%esp
80104df1:	68 cd 79 10 80       	push   $0x801079cd
80104df6:	e8 85 b5 ff ff       	call   80100380 <panic>
    panic("create: dirlink");
80104dfb:	83 ec 0c             	sub    $0xc,%esp
80104dfe:	68 dc 79 10 80       	push   $0x801079dc
80104e03:	e8 78 b5 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104e08:	83 ec 0c             	sub    $0xc,%esp
80104e0b:	68 be 79 10 80       	push   $0x801079be
80104e10:	e8 6b b5 ff ff       	call   80100380 <panic>
80104e15:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104e1c:	00 
80104e1d:	8d 76 00             	lea    0x0(%esi),%esi

80104e20 <sys_dup>:
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	56                   	push   %esi
80104e24:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e25:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104e28:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e2b:	50                   	push   %eax
80104e2c:	6a 00                	push   $0x0
80104e2e:	e8 9d fc ff ff       	call   80104ad0 <argint>
80104e33:	83 c4 10             	add    $0x10,%esp
80104e36:	85 c0                	test   %eax,%eax
80104e38:	78 39                	js     80104e73 <sys_dup+0x53>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e3a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e3e:	77 33                	ja     80104e73 <sys_dup+0x53>
80104e40:	e8 9b eb ff ff       	call   801039e0 <myproc>
80104e45:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e48:	8b b4 90 88 00 00 00 	mov    0x88(%eax,%edx,4),%esi
80104e4f:	85 f6                	test   %esi,%esi
80104e51:	74 20                	je     80104e73 <sys_dup+0x53>
  struct proc *curproc = myproc();
80104e53:	e8 88 eb ff ff       	call   801039e0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104e58:	31 db                	xor    %ebx,%ebx
80104e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80104e60:	8b 94 98 88 00 00 00 	mov    0x88(%eax,%ebx,4),%edx
80104e67:	85 d2                	test   %edx,%edx
80104e69:	74 1d                	je     80104e88 <sys_dup+0x68>
  for(fd = 0; fd < NOFILE; fd++){
80104e6b:	83 c3 01             	add    $0x1,%ebx
80104e6e:	83 fb 10             	cmp    $0x10,%ebx
80104e71:	75 ed                	jne    80104e60 <sys_dup+0x40>
}
80104e73:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104e76:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104e7b:	89 d8                	mov    %ebx,%eax
80104e7d:	5b                   	pop    %ebx
80104e7e:	5e                   	pop    %esi
80104e7f:	5d                   	pop    %ebp
80104e80:	c3                   	ret
80104e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  filedup(f);
80104e88:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104e8b:	89 b4 98 88 00 00 00 	mov    %esi,0x88(%eax,%ebx,4)
  filedup(f);
80104e92:	56                   	push   %esi
80104e93:	e8 58 c0 ff ff       	call   80100ef0 <filedup>
  return fd;
80104e98:	83 c4 10             	add    $0x10,%esp
}
80104e9b:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e9e:	89 d8                	mov    %ebx,%eax
80104ea0:	5b                   	pop    %ebx
80104ea1:	5e                   	pop    %esi
80104ea2:	5d                   	pop    %ebp
80104ea3:	c3                   	ret
80104ea4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104eab:	00 
80104eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104eb0 <sys_read>:
{
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
80104eb3:	56                   	push   %esi
80104eb4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104eb5:	8d 75 f4             	lea    -0xc(%ebp),%esi
{
80104eb8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104ebb:	56                   	push   %esi
80104ebc:	6a 00                	push   $0x0
80104ebe:	e8 0d fc ff ff       	call   80104ad0 <argint>
80104ec3:	83 c4 10             	add    $0x10,%esp
80104ec6:	85 c0                	test   %eax,%eax
80104ec8:	78 76                	js     80104f40 <sys_read+0x90>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104eca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ece:	77 70                	ja     80104f40 <sys_read+0x90>
80104ed0:	e8 0b eb ff ff       	call   801039e0 <myproc>
80104ed5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ed8:	8b 9c 90 88 00 00 00 	mov    0x88(%eax,%edx,4),%ebx
80104edf:	85 db                	test   %ebx,%ebx
80104ee1:	74 5d                	je     80104f40 <sys_read+0x90>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ee3:	83 ec 08             	sub    $0x8,%esp
80104ee6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ee9:	50                   	push   %eax
80104eea:	6a 02                	push   $0x2
80104eec:	e8 df fb ff ff       	call   80104ad0 <argint>
80104ef1:	83 c4 10             	add    $0x10,%esp
80104ef4:	85 c0                	test   %eax,%eax
80104ef6:	78 48                	js     80104f40 <sys_read+0x90>
80104ef8:	83 ec 04             	sub    $0x4,%esp
80104efb:	ff 75 f0             	push   -0x10(%ebp)
80104efe:	56                   	push   %esi
80104eff:	6a 01                	push   $0x1
80104f01:	e8 1a fc ff ff       	call   80104b20 <argptr>
80104f06:	83 c4 10             	add    $0x10,%esp
80104f09:	85 c0                	test   %eax,%eax
80104f0b:	78 33                	js     80104f40 <sys_read+0x90>
  if (!(f->ip->mode & (1<<0))) {
80104f0d:	8b 43 10             	mov    0x10(%ebx),%eax
80104f10:	f6 40 50 01          	testb  $0x1,0x50(%eax)
80104f14:	74 1a                	je     80104f30 <sys_read+0x80>
  return fileread(f, p, n);
80104f16:	83 ec 04             	sub    $0x4,%esp
80104f19:	ff 75 f0             	push   -0x10(%ebp)
80104f1c:	ff 75 f4             	push   -0xc(%ebp)
80104f1f:	53                   	push   %ebx
80104f20:	e8 4b c1 ff ff       	call   80101070 <fileread>
80104f25:	83 c4 10             	add    $0x10,%esp
}
80104f28:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f2b:	5b                   	pop    %ebx
80104f2c:	5e                   	pop    %esi
80104f2d:	5d                   	pop    %ebp
80104f2e:	c3                   	ret
80104f2f:	90                   	nop
      cprintf("Operation read failed\n");
80104f30:	83 ec 0c             	sub    $0xc,%esp
80104f33:	68 ec 79 10 80       	push   $0x801079ec
80104f38:	e8 73 b7 ff ff       	call   801006b0 <cprintf>
      return -1;
80104f3d:	83 c4 10             	add    $0x10,%esp
    return -1;
80104f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f45:	eb e1                	jmp    80104f28 <sys_read+0x78>
80104f47:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104f4e:	00 
80104f4f:	90                   	nop

80104f50 <sys_write>:
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	56                   	push   %esi
80104f54:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f55:	8d 75 f4             	lea    -0xc(%ebp),%esi
{
80104f58:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f5b:	56                   	push   %esi
80104f5c:	6a 00                	push   $0x0
80104f5e:	e8 6d fb ff ff       	call   80104ad0 <argint>
80104f63:	83 c4 10             	add    $0x10,%esp
80104f66:	85 c0                	test   %eax,%eax
80104f68:	78 76                	js     80104fe0 <sys_write+0x90>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f6a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f6e:	77 70                	ja     80104fe0 <sys_write+0x90>
80104f70:	e8 6b ea ff ff       	call   801039e0 <myproc>
80104f75:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f78:	8b 9c 90 88 00 00 00 	mov    0x88(%eax,%edx,4),%ebx
80104f7f:	85 db                	test   %ebx,%ebx
80104f81:	74 5d                	je     80104fe0 <sys_write+0x90>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f83:	83 ec 08             	sub    $0x8,%esp
80104f86:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f89:	50                   	push   %eax
80104f8a:	6a 02                	push   $0x2
80104f8c:	e8 3f fb ff ff       	call   80104ad0 <argint>
80104f91:	83 c4 10             	add    $0x10,%esp
80104f94:	85 c0                	test   %eax,%eax
80104f96:	78 48                	js     80104fe0 <sys_write+0x90>
80104f98:	83 ec 04             	sub    $0x4,%esp
80104f9b:	ff 75 f0             	push   -0x10(%ebp)
80104f9e:	56                   	push   %esi
80104f9f:	6a 01                	push   $0x1
80104fa1:	e8 7a fb ff ff       	call   80104b20 <argptr>
80104fa6:	83 c4 10             	add    $0x10,%esp
80104fa9:	85 c0                	test   %eax,%eax
80104fab:	78 33                	js     80104fe0 <sys_write+0x90>
  if (!(f->ip->mode & (1<<1))) {
80104fad:	8b 43 10             	mov    0x10(%ebx),%eax
80104fb0:	f6 40 50 02          	testb  $0x2,0x50(%eax)
80104fb4:	74 1a                	je     80104fd0 <sys_write+0x80>
  return filewrite(f, p, n);
80104fb6:	83 ec 04             	sub    $0x4,%esp
80104fb9:	ff 75 f0             	push   -0x10(%ebp)
80104fbc:	ff 75 f4             	push   -0xc(%ebp)
80104fbf:	53                   	push   %ebx
80104fc0:	e8 3b c1 ff ff       	call   80101100 <filewrite>
80104fc5:	83 c4 10             	add    $0x10,%esp
}
80104fc8:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fcb:	5b                   	pop    %ebx
80104fcc:	5e                   	pop    %esi
80104fcd:	5d                   	pop    %ebp
80104fce:	c3                   	ret
80104fcf:	90                   	nop
      cprintf("Operation write failed\n");
80104fd0:	83 ec 0c             	sub    $0xc,%esp
80104fd3:	68 03 7a 10 80       	push   $0x80107a03
80104fd8:	e8 d3 b6 ff ff       	call   801006b0 <cprintf>
      return -1;
80104fdd:	83 c4 10             	add    $0x10,%esp
    return -1;
80104fe0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fe5:	eb e1                	jmp    80104fc8 <sys_write+0x78>
80104fe7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104fee:	00 
80104fef:	90                   	nop

80104ff0 <sys_close>:
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	56                   	push   %esi
80104ff4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ff5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104ff8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104ffb:	50                   	push   %eax
80104ffc:	6a 00                	push   $0x0
80104ffe:	e8 cd fa ff ff       	call   80104ad0 <argint>
80105003:	83 c4 10             	add    $0x10,%esp
80105006:	85 c0                	test   %eax,%eax
80105008:	78 3e                	js     80105048 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010500a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010500e:	77 38                	ja     80105048 <sys_close+0x58>
80105010:	e8 cb e9 ff ff       	call   801039e0 <myproc>
80105015:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105018:	8d 5a 20             	lea    0x20(%edx),%ebx
8010501b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010501f:	85 f6                	test   %esi,%esi
80105021:	74 25                	je     80105048 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105023:	e8 b8 e9 ff ff       	call   801039e0 <myproc>
  fileclose(f);
80105028:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010502b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105032:	00 
  fileclose(f);
80105033:	56                   	push   %esi
80105034:	e8 07 bf ff ff       	call   80100f40 <fileclose>
  return 0;
80105039:	83 c4 10             	add    $0x10,%esp
8010503c:	31 c0                	xor    %eax,%eax
}
8010503e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105041:	5b                   	pop    %ebx
80105042:	5e                   	pop    %esi
80105043:	5d                   	pop    %ebp
80105044:	c3                   	ret
80105045:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105048:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010504d:	eb ef                	jmp    8010503e <sys_close+0x4e>
8010504f:	90                   	nop

80105050 <sys_fstat>:
{
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
80105053:	56                   	push   %esi
80105054:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105055:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105058:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010505b:	53                   	push   %ebx
8010505c:	6a 00                	push   $0x0
8010505e:	e8 6d fa ff ff       	call   80104ad0 <argint>
80105063:	83 c4 10             	add    $0x10,%esp
80105066:	85 c0                	test   %eax,%eax
80105068:	78 46                	js     801050b0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010506a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010506e:	77 40                	ja     801050b0 <sys_fstat+0x60>
80105070:	e8 6b e9 ff ff       	call   801039e0 <myproc>
80105075:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105078:	8b b4 90 88 00 00 00 	mov    0x88(%eax,%edx,4),%esi
8010507f:	85 f6                	test   %esi,%esi
80105081:	74 2d                	je     801050b0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105083:	83 ec 04             	sub    $0x4,%esp
80105086:	6a 18                	push   $0x18
80105088:	53                   	push   %ebx
80105089:	6a 01                	push   $0x1
8010508b:	e8 90 fa ff ff       	call   80104b20 <argptr>
80105090:	83 c4 10             	add    $0x10,%esp
80105093:	85 c0                	test   %eax,%eax
80105095:	78 19                	js     801050b0 <sys_fstat+0x60>
  return filestat(f, st);
80105097:	83 ec 08             	sub    $0x8,%esp
8010509a:	ff 75 f4             	push   -0xc(%ebp)
8010509d:	56                   	push   %esi
8010509e:	e8 7d bf ff ff       	call   80101020 <filestat>
801050a3:	83 c4 10             	add    $0x10,%esp
}
801050a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050a9:	5b                   	pop    %ebx
801050aa:	5e                   	pop    %esi
801050ab:	5d                   	pop    %ebp
801050ac:	c3                   	ret
801050ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801050b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050b5:	eb ef                	jmp    801050a6 <sys_fstat+0x56>
801050b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801050be:	00 
801050bf:	90                   	nop

801050c0 <sys_link>:
{
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	57                   	push   %edi
801050c4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050c5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801050c8:	53                   	push   %ebx
801050c9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050cc:	50                   	push   %eax
801050cd:	6a 00                	push   $0x0
801050cf:	e8 bc fa ff ff       	call   80104b90 <argstr>
801050d4:	83 c4 10             	add    $0x10,%esp
801050d7:	85 c0                	test   %eax,%eax
801050d9:	0f 88 fb 00 00 00    	js     801051da <sys_link+0x11a>
801050df:	83 ec 08             	sub    $0x8,%esp
801050e2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801050e5:	50                   	push   %eax
801050e6:	6a 01                	push   $0x1
801050e8:	e8 a3 fa ff ff       	call   80104b90 <argstr>
801050ed:	83 c4 10             	add    $0x10,%esp
801050f0:	85 c0                	test   %eax,%eax
801050f2:	0f 88 e2 00 00 00    	js     801051da <sys_link+0x11a>
  begin_op();
801050f8:	e8 b3 dc ff ff       	call   80102db0 <begin_op>
  if((ip = namei(old)) == 0){
801050fd:	83 ec 0c             	sub    $0xc,%esp
80105100:	ff 75 d4             	push   -0x2c(%ebp)
80105103:	e8 e8 cf ff ff       	call   801020f0 <namei>
80105108:	83 c4 10             	add    $0x10,%esp
8010510b:	89 c3                	mov    %eax,%ebx
8010510d:	85 c0                	test   %eax,%eax
8010510f:	0f 84 df 00 00 00    	je     801051f4 <sys_link+0x134>
  ilock(ip);
80105115:	83 ec 0c             	sub    $0xc,%esp
80105118:	50                   	push   %eax
80105119:	e8 d2 c6 ff ff       	call   801017f0 <ilock>
  if(ip->type == T_DIR){
8010511e:	83 c4 10             	add    $0x10,%esp
80105121:	66 83 7b 52 01       	cmpw   $0x1,0x52(%ebx)
80105126:	0f 84 b5 00 00 00    	je     801051e1 <sys_link+0x121>
  iupdate(ip);
8010512c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010512f:	66 83 43 58 01       	addw   $0x1,0x58(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105134:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105137:	53                   	push   %ebx
80105138:	e8 f3 c5 ff ff       	call   80101730 <iupdate>
  iunlock(ip);
8010513d:	89 1c 24             	mov    %ebx,(%esp)
80105140:	e8 8b c7 ff ff       	call   801018d0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105145:	58                   	pop    %eax
80105146:	5a                   	pop    %edx
80105147:	57                   	push   %edi
80105148:	ff 75 d0             	push   -0x30(%ebp)
8010514b:	e8 c0 cf ff ff       	call   80102110 <nameiparent>
80105150:	83 c4 10             	add    $0x10,%esp
80105153:	89 c6                	mov    %eax,%esi
80105155:	85 c0                	test   %eax,%eax
80105157:	74 5b                	je     801051b4 <sys_link+0xf4>
  ilock(dp);
80105159:	83 ec 0c             	sub    $0xc,%esp
8010515c:	50                   	push   %eax
8010515d:	e8 8e c6 ff ff       	call   801017f0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105162:	8b 03                	mov    (%ebx),%eax
80105164:	83 c4 10             	add    $0x10,%esp
80105167:	39 06                	cmp    %eax,(%esi)
80105169:	75 3d                	jne    801051a8 <sys_link+0xe8>
8010516b:	83 ec 04             	sub    $0x4,%esp
8010516e:	ff 73 04             	push   0x4(%ebx)
80105171:	57                   	push   %edi
80105172:	56                   	push   %esi
80105173:	e8 b8 ce ff ff       	call   80102030 <dirlink>
80105178:	83 c4 10             	add    $0x10,%esp
8010517b:	85 c0                	test   %eax,%eax
8010517d:	78 29                	js     801051a8 <sys_link+0xe8>
  iunlockput(dp);
8010517f:	83 ec 0c             	sub    $0xc,%esp
80105182:	56                   	push   %esi
80105183:	e8 f8 c8 ff ff       	call   80101a80 <iunlockput>
  iput(ip);
80105188:	89 1c 24             	mov    %ebx,(%esp)
8010518b:	e8 90 c7 ff ff       	call   80101920 <iput>
  end_op();
80105190:	e8 8b dc ff ff       	call   80102e20 <end_op>
  return 0;
80105195:	83 c4 10             	add    $0x10,%esp
80105198:	31 c0                	xor    %eax,%eax
}
8010519a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010519d:	5b                   	pop    %ebx
8010519e:	5e                   	pop    %esi
8010519f:	5f                   	pop    %edi
801051a0:	5d                   	pop    %ebp
801051a1:	c3                   	ret
801051a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801051a8:	83 ec 0c             	sub    $0xc,%esp
801051ab:	56                   	push   %esi
801051ac:	e8 cf c8 ff ff       	call   80101a80 <iunlockput>
    goto bad;
801051b1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801051b4:	83 ec 0c             	sub    $0xc,%esp
801051b7:	53                   	push   %ebx
801051b8:	e8 33 c6 ff ff       	call   801017f0 <ilock>
  ip->nlink--;
801051bd:	66 83 6b 58 01       	subw   $0x1,0x58(%ebx)
  iupdate(ip);
801051c2:	89 1c 24             	mov    %ebx,(%esp)
801051c5:	e8 66 c5 ff ff       	call   80101730 <iupdate>
  iunlockput(ip);
801051ca:	89 1c 24             	mov    %ebx,(%esp)
801051cd:	e8 ae c8 ff ff       	call   80101a80 <iunlockput>
  end_op();
801051d2:	e8 49 dc ff ff       	call   80102e20 <end_op>
  return -1;
801051d7:	83 c4 10             	add    $0x10,%esp
    return -1;
801051da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051df:	eb b9                	jmp    8010519a <sys_link+0xda>
    iunlockput(ip);
801051e1:	83 ec 0c             	sub    $0xc,%esp
801051e4:	53                   	push   %ebx
801051e5:	e8 96 c8 ff ff       	call   80101a80 <iunlockput>
    end_op();
801051ea:	e8 31 dc ff ff       	call   80102e20 <end_op>
    return -1;
801051ef:	83 c4 10             	add    $0x10,%esp
801051f2:	eb e6                	jmp    801051da <sys_link+0x11a>
    end_op();
801051f4:	e8 27 dc ff ff       	call   80102e20 <end_op>
    return -1;
801051f9:	eb df                	jmp    801051da <sys_link+0x11a>
801051fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105200 <sys_unlink>:
{
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	57                   	push   %edi
80105204:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105205:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105208:	53                   	push   %ebx
80105209:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010520c:	50                   	push   %eax
8010520d:	6a 00                	push   $0x0
8010520f:	e8 7c f9 ff ff       	call   80104b90 <argstr>
80105214:	83 c4 10             	add    $0x10,%esp
80105217:	85 c0                	test   %eax,%eax
80105219:	0f 88 54 01 00 00    	js     80105373 <sys_unlink+0x173>
  begin_op();
8010521f:	e8 8c db ff ff       	call   80102db0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105224:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105227:	83 ec 08             	sub    $0x8,%esp
8010522a:	53                   	push   %ebx
8010522b:	ff 75 c0             	push   -0x40(%ebp)
8010522e:	e8 dd ce ff ff       	call   80102110 <nameiparent>
80105233:	83 c4 10             	add    $0x10,%esp
80105236:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105239:	85 c0                	test   %eax,%eax
8010523b:	0f 84 58 01 00 00    	je     80105399 <sys_unlink+0x199>
  ilock(dp);
80105241:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105244:	83 ec 0c             	sub    $0xc,%esp
80105247:	57                   	push   %edi
80105248:	e8 a3 c5 ff ff       	call   801017f0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010524d:	58                   	pop    %eax
8010524e:	5a                   	pop    %edx
8010524f:	68 da 79 10 80       	push   $0x801079da
80105254:	53                   	push   %ebx
80105255:	e8 d6 ca ff ff       	call   80101d30 <namecmp>
8010525a:	83 c4 10             	add    $0x10,%esp
8010525d:	85 c0                	test   %eax,%eax
8010525f:	0f 84 fb 00 00 00    	je     80105360 <sys_unlink+0x160>
80105265:	83 ec 08             	sub    $0x8,%esp
80105268:	68 d9 79 10 80       	push   $0x801079d9
8010526d:	53                   	push   %ebx
8010526e:	e8 bd ca ff ff       	call   80101d30 <namecmp>
80105273:	83 c4 10             	add    $0x10,%esp
80105276:	85 c0                	test   %eax,%eax
80105278:	0f 84 e2 00 00 00    	je     80105360 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010527e:	83 ec 04             	sub    $0x4,%esp
80105281:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105284:	50                   	push   %eax
80105285:	53                   	push   %ebx
80105286:	57                   	push   %edi
80105287:	e8 c4 ca ff ff       	call   80101d50 <dirlookup>
8010528c:	83 c4 10             	add    $0x10,%esp
8010528f:	89 c3                	mov    %eax,%ebx
80105291:	85 c0                	test   %eax,%eax
80105293:	0f 84 c7 00 00 00    	je     80105360 <sys_unlink+0x160>
  ilock(ip);
80105299:	83 ec 0c             	sub    $0xc,%esp
8010529c:	50                   	push   %eax
8010529d:	e8 4e c5 ff ff       	call   801017f0 <ilock>
  if(ip->nlink < 1)
801052a2:	83 c4 10             	add    $0x10,%esp
801052a5:	66 83 7b 58 00       	cmpw   $0x0,0x58(%ebx)
801052aa:	0f 8e 0a 01 00 00    	jle    801053ba <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
801052b0:	66 83 7b 52 01       	cmpw   $0x1,0x52(%ebx)
801052b5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801052b8:	74 66                	je     80105320 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801052ba:	83 ec 04             	sub    $0x4,%esp
801052bd:	6a 10                	push   $0x10
801052bf:	6a 00                	push   $0x0
801052c1:	57                   	push   %edi
801052c2:	e8 59 f5 ff ff       	call   80104820 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801052c7:	6a 10                	push   $0x10
801052c9:	ff 75 c4             	push   -0x3c(%ebp)
801052cc:	57                   	push   %edi
801052cd:	ff 75 b4             	push   -0x4c(%ebp)
801052d0:	e8 3b c9 ff ff       	call   80101c10 <writei>
801052d5:	83 c4 20             	add    $0x20,%esp
801052d8:	83 f8 10             	cmp    $0x10,%eax
801052db:	0f 85 cc 00 00 00    	jne    801053ad <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
801052e1:	66 83 7b 52 01       	cmpw   $0x1,0x52(%ebx)
801052e6:	0f 84 94 00 00 00    	je     80105380 <sys_unlink+0x180>
  iunlockput(dp);
801052ec:	83 ec 0c             	sub    $0xc,%esp
801052ef:	ff 75 b4             	push   -0x4c(%ebp)
801052f2:	e8 89 c7 ff ff       	call   80101a80 <iunlockput>
  ip->nlink--;
801052f7:	66 83 6b 58 01       	subw   $0x1,0x58(%ebx)
  iupdate(ip);
801052fc:	89 1c 24             	mov    %ebx,(%esp)
801052ff:	e8 2c c4 ff ff       	call   80101730 <iupdate>
  iunlockput(ip);
80105304:	89 1c 24             	mov    %ebx,(%esp)
80105307:	e8 74 c7 ff ff       	call   80101a80 <iunlockput>
  end_op();
8010530c:	e8 0f db ff ff       	call   80102e20 <end_op>
  return 0;
80105311:	83 c4 10             	add    $0x10,%esp
80105314:	31 c0                	xor    %eax,%eax
}
80105316:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105319:	5b                   	pop    %ebx
8010531a:	5e                   	pop    %esi
8010531b:	5f                   	pop    %edi
8010531c:	5d                   	pop    %ebp
8010531d:	c3                   	ret
8010531e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105320:	83 7b 5c 20          	cmpl   $0x20,0x5c(%ebx)
80105324:	76 94                	jbe    801052ba <sys_unlink+0xba>
80105326:	be 20 00 00 00       	mov    $0x20,%esi
8010532b:	eb 0b                	jmp    80105338 <sys_unlink+0x138>
8010532d:	8d 76 00             	lea    0x0(%esi),%esi
80105330:	83 c6 10             	add    $0x10,%esi
80105333:	3b 73 5c             	cmp    0x5c(%ebx),%esi
80105336:	73 82                	jae    801052ba <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105338:	6a 10                	push   $0x10
8010533a:	56                   	push   %esi
8010533b:	57                   	push   %edi
8010533c:	53                   	push   %ebx
8010533d:	e8 ce c7 ff ff       	call   80101b10 <readi>
80105342:	83 c4 10             	add    $0x10,%esp
80105345:	83 f8 10             	cmp    $0x10,%eax
80105348:	75 56                	jne    801053a0 <sys_unlink+0x1a0>
    if(de.inum != 0)
8010534a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010534f:	74 df                	je     80105330 <sys_unlink+0x130>
    iunlockput(ip);
80105351:	83 ec 0c             	sub    $0xc,%esp
80105354:	53                   	push   %ebx
80105355:	e8 26 c7 ff ff       	call   80101a80 <iunlockput>
    goto bad;
8010535a:	83 c4 10             	add    $0x10,%esp
8010535d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105360:	83 ec 0c             	sub    $0xc,%esp
80105363:	ff 75 b4             	push   -0x4c(%ebp)
80105366:	e8 15 c7 ff ff       	call   80101a80 <iunlockput>
  end_op();
8010536b:	e8 b0 da ff ff       	call   80102e20 <end_op>
  return -1;
80105370:	83 c4 10             	add    $0x10,%esp
    return -1;
80105373:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105378:	eb 9c                	jmp    80105316 <sys_unlink+0x116>
8010537a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105380:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105383:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105386:	66 83 68 58 01       	subw   $0x1,0x58(%eax)
    iupdate(dp);
8010538b:	50                   	push   %eax
8010538c:	e8 9f c3 ff ff       	call   80101730 <iupdate>
80105391:	83 c4 10             	add    $0x10,%esp
80105394:	e9 53 ff ff ff       	jmp    801052ec <sys_unlink+0xec>
    end_op();
80105399:	e8 82 da ff ff       	call   80102e20 <end_op>
    return -1;
8010539e:	eb d3                	jmp    80105373 <sys_unlink+0x173>
      panic("isdirempty: readi");
801053a0:	83 ec 0c             	sub    $0xc,%esp
801053a3:	68 2d 7a 10 80       	push   $0x80107a2d
801053a8:	e8 d3 af ff ff       	call   80100380 <panic>
    panic("unlink: writei");
801053ad:	83 ec 0c             	sub    $0xc,%esp
801053b0:	68 3f 7a 10 80       	push   $0x80107a3f
801053b5:	e8 c6 af ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
801053ba:	83 ec 0c             	sub    $0xc,%esp
801053bd:	68 1b 7a 10 80       	push   $0x80107a1b
801053c2:	e8 b9 af ff ff       	call   80100380 <panic>
801053c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801053ce:	00 
801053cf:	90                   	nop

801053d0 <sys_open>:

int
sys_open(void)
{
801053d0:	55                   	push   %ebp
801053d1:	89 e5                	mov    %esp,%ebp
801053d3:	57                   	push   %edi
801053d4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053d5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801053d8:	53                   	push   %ebx
801053d9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053dc:	50                   	push   %eax
801053dd:	6a 00                	push   $0x0
801053df:	e8 ac f7 ff ff       	call   80104b90 <argstr>
801053e4:	83 c4 10             	add    $0x10,%esp
801053e7:	85 c0                	test   %eax,%eax
801053e9:	0f 88 95 00 00 00    	js     80105484 <sys_open+0xb4>
801053ef:	83 ec 08             	sub    $0x8,%esp
801053f2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801053f5:	50                   	push   %eax
801053f6:	6a 01                	push   $0x1
801053f8:	e8 d3 f6 ff ff       	call   80104ad0 <argint>
801053fd:	83 c4 10             	add    $0x10,%esp
80105400:	85 c0                	test   %eax,%eax
80105402:	0f 88 7c 00 00 00    	js     80105484 <sys_open+0xb4>
    return -1;

  begin_op();
80105408:	e8 a3 d9 ff ff       	call   80102db0 <begin_op>

  if(omode & O_CREATE){
8010540d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105411:	0f 84 79 00 00 00    	je     80105490 <sys_open+0xc0>
    ip = create(path, T_FILE, 0, 6);
80105417:	83 ec 0c             	sub    $0xc,%esp
8010541a:	31 c9                	xor    %ecx,%ecx
8010541c:	ba 02 00 00 00       	mov    $0x2,%edx
80105421:	6a 06                	push   $0x6
80105423:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105426:	e8 75 f8 ff ff       	call   80104ca0 <create>
    if(ip == 0){
8010542b:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 6);
8010542e:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105430:	85 c0                	test   %eax,%eax
80105432:	0f 84 38 01 00 00    	je     80105570 <sys_open+0x1a0>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105438:	e8 43 ba ff ff       	call   80100e80 <filealloc>
8010543d:	89 c7                	mov    %eax,%edi
8010543f:	85 c0                	test   %eax,%eax
80105441:	74 30                	je     80105473 <sys_open+0xa3>
  struct proc *curproc = myproc();
80105443:	e8 98 e5 ff ff       	call   801039e0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105448:	31 db                	xor    %ebx,%ebx
8010544a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105450:	8b 94 98 88 00 00 00 	mov    0x88(%eax,%ebx,4),%edx
80105457:	85 d2                	test   %edx,%edx
80105459:	0f 84 91 00 00 00    	je     801054f0 <sys_open+0x120>
  for(fd = 0; fd < NOFILE; fd++){
8010545f:	83 c3 01             	add    $0x1,%ebx
80105462:	83 fb 10             	cmp    $0x10,%ebx
80105465:	75 e9                	jne    80105450 <sys_open+0x80>
    if(f)
      fileclose(f);
80105467:	83 ec 0c             	sub    $0xc,%esp
8010546a:	57                   	push   %edi
8010546b:	e8 d0 ba ff ff       	call   80100f40 <fileclose>
80105470:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105473:	83 ec 0c             	sub    $0xc,%esp
80105476:	56                   	push   %esi
80105477:	e8 04 c6 ff ff       	call   80101a80 <iunlockput>
    end_op();
8010547c:	e8 9f d9 ff ff       	call   80102e20 <end_op>
    return -1;
80105481:	83 c4 10             	add    $0x10,%esp
    return -1;
80105484:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105489:	e9 9e 00 00 00       	jmp    8010552c <sys_open+0x15c>
8010548e:	66 90                	xchg   %ax,%ax
    if((ip = namei(path)) == 0){
80105490:	83 ec 0c             	sub    $0xc,%esp
80105493:	ff 75 e0             	push   -0x20(%ebp)
80105496:	e8 55 cc ff ff       	call   801020f0 <namei>
8010549b:	83 c4 10             	add    $0x10,%esp
8010549e:	89 c6                	mov    %eax,%esi
801054a0:	85 c0                	test   %eax,%eax
801054a2:	0f 84 c8 00 00 00    	je     80105570 <sys_open+0x1a0>
    ilock(ip);
801054a8:	83 ec 0c             	sub    $0xc,%esp
801054ab:	50                   	push   %eax
801054ac:	e8 3f c3 ff ff       	call   801017f0 <ilock>
    if((omode == O_RDONLY || omode == O_RDWR) && !(ip->mode & (1<<0))) {
801054b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801054b4:	83 c4 10             	add    $0x10,%esp
801054b7:	a9 fd ff ff ff       	test   $0xfffffffd,%eax
801054bc:	0f 85 7e 00 00 00    	jne    80105540 <sys_open+0x170>
801054c2:	0f b7 56 50          	movzwl 0x50(%esi),%edx
801054c6:	f6 c2 01             	test   $0x1,%dl
801054c9:	0f 84 ab 00 00 00    	je     8010557a <sys_open+0x1aa>
  if((omode == O_WRONLY || omode == O_RDWR) && !(ip->mode & (1<<1))) {
801054cf:	83 f8 02             	cmp    $0x2,%eax
801054d2:	0f 85 60 ff ff ff    	jne    80105438 <sys_open+0x68>
801054d8:	83 e2 02             	and    $0x2,%edx
801054db:	74 71                	je     8010554e <sys_open+0x17e>
    if(ip->type == T_DIR && omode != O_RDONLY){
801054dd:	66 83 7e 52 01       	cmpw   $0x1,0x52(%esi)
801054e2:	0f 85 50 ff ff ff    	jne    80105438 <sys_open+0x68>
801054e8:	eb 89                	jmp    80105473 <sys_open+0xa3>
801054ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  iunlock(ip);
801054f0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801054f3:	89 bc 98 88 00 00 00 	mov    %edi,0x88(%eax,%ebx,4)
  iunlock(ip);
801054fa:	56                   	push   %esi
801054fb:	e8 d0 c3 ff ff       	call   801018d0 <iunlock>
  end_op();
80105500:	e8 1b d9 ff ff       	call   80102e20 <end_op>

  f->type = FD_INODE;
80105505:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010550b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010550e:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105511:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105514:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105516:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010551d:	f7 d0                	not    %eax
8010551f:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105522:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105525:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105528:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010552c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010552f:	89 d8                	mov    %ebx,%eax
80105531:	5b                   	pop    %ebx
80105532:	5e                   	pop    %esi
80105533:	5f                   	pop    %edi
80105534:	5d                   	pop    %ebp
80105535:	c3                   	ret
80105536:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010553d:	00 
8010553e:	66 90                	xchg   %ax,%ax
  if((omode == O_WRONLY || omode == O_RDWR) && !(ip->mode & (1<<1))) {
80105540:	83 e8 01             	sub    $0x1,%eax
80105543:	83 f8 01             	cmp    $0x1,%eax
80105546:	77 95                	ja     801054dd <sys_open+0x10d>
    if((omode == O_RDONLY || omode == O_RDWR) && !(ip->mode & (1<<0))) {
80105548:	0f b7 56 50          	movzwl 0x50(%esi),%edx
8010554c:	eb 8a                	jmp    801054d8 <sys_open+0x108>
    iunlockput(ip);
8010554e:	83 ec 0c             	sub    $0xc,%esp
80105551:	56                   	push   %esi
80105552:	e8 29 c5 ff ff       	call   80101a80 <iunlockput>
    cprintf("Operation write failed\n");
80105557:	c7 04 24 03 7a 10 80 	movl   $0x80107a03,(%esp)
8010555e:	e8 4d b1 ff ff       	call   801006b0 <cprintf>
    end_op();
80105563:	e8 b8 d8 ff ff       	call   80102e20 <end_op>
    return -1;
80105568:	83 c4 10             	add    $0x10,%esp
8010556b:	e9 14 ff ff ff       	jmp    80105484 <sys_open+0xb4>
      end_op();
80105570:	e8 ab d8 ff ff       	call   80102e20 <end_op>
      return -1;
80105575:	e9 0a ff ff ff       	jmp    80105484 <sys_open+0xb4>
    iunlockput(ip);
8010557a:	83 ec 0c             	sub    $0xc,%esp
8010557d:	56                   	push   %esi
8010557e:	e8 fd c4 ff ff       	call   80101a80 <iunlockput>
    cprintf("Operation read failed\n");
80105583:	c7 04 24 ec 79 10 80 	movl   $0x801079ec,(%esp)
8010558a:	e8 21 b1 ff ff       	call   801006b0 <cprintf>
    end_op();
8010558f:	e8 8c d8 ff ff       	call   80102e20 <end_op>
    return -1;
80105594:	83 c4 10             	add    $0x10,%esp
80105597:	e9 e8 fe ff ff       	jmp    80105484 <sys_open+0xb4>
8010559c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055a0 <sys_mkdir>:

int
sys_mkdir(void)
{
801055a0:	55                   	push   %ebp
801055a1:	89 e5                	mov    %esp,%ebp
801055a3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801055a6:	e8 05 d8 ff ff       	call   80102db0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801055ab:	83 ec 08             	sub    $0x8,%esp
801055ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055b1:	50                   	push   %eax
801055b2:	6a 00                	push   $0x0
801055b4:	e8 d7 f5 ff ff       	call   80104b90 <argstr>
801055b9:	83 c4 10             	add    $0x10,%esp
801055bc:	85 c0                	test   %eax,%eax
801055be:	78 30                	js     801055f0 <sys_mkdir+0x50>
801055c0:	83 ec 0c             	sub    $0xc,%esp
801055c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055c6:	31 c9                	xor    %ecx,%ecx
801055c8:	ba 01 00 00 00       	mov    $0x1,%edx
801055cd:	6a 00                	push   $0x0
801055cf:	e8 cc f6 ff ff       	call   80104ca0 <create>
801055d4:	83 c4 10             	add    $0x10,%esp
801055d7:	85 c0                	test   %eax,%eax
801055d9:	74 15                	je     801055f0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801055db:	83 ec 0c             	sub    $0xc,%esp
801055de:	50                   	push   %eax
801055df:	e8 9c c4 ff ff       	call   80101a80 <iunlockput>
  end_op();
801055e4:	e8 37 d8 ff ff       	call   80102e20 <end_op>
  return 0;
801055e9:	83 c4 10             	add    $0x10,%esp
801055ec:	31 c0                	xor    %eax,%eax
}
801055ee:	c9                   	leave
801055ef:	c3                   	ret
    end_op();
801055f0:	e8 2b d8 ff ff       	call   80102e20 <end_op>
    return -1;
801055f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055fa:	c9                   	leave
801055fb:	c3                   	ret
801055fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105600 <sys_mknod>:

int
sys_mknod(void)
{
80105600:	55                   	push   %ebp
80105601:	89 e5                	mov    %esp,%ebp
80105603:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105606:	e8 a5 d7 ff ff       	call   80102db0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010560b:	83 ec 08             	sub    $0x8,%esp
8010560e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105611:	50                   	push   %eax
80105612:	6a 00                	push   $0x0
80105614:	e8 77 f5 ff ff       	call   80104b90 <argstr>
80105619:	83 c4 10             	add    $0x10,%esp
8010561c:	85 c0                	test   %eax,%eax
8010561e:	78 60                	js     80105680 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105620:	83 ec 08             	sub    $0x8,%esp
80105623:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105626:	50                   	push   %eax
80105627:	6a 01                	push   $0x1
80105629:	e8 a2 f4 ff ff       	call   80104ad0 <argint>
  if((argstr(0, &path)) < 0 ||
8010562e:	83 c4 10             	add    $0x10,%esp
80105631:	85 c0                	test   %eax,%eax
80105633:	78 4b                	js     80105680 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105635:	83 ec 08             	sub    $0x8,%esp
80105638:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010563b:	50                   	push   %eax
8010563c:	6a 02                	push   $0x2
8010563e:	e8 8d f4 ff ff       	call   80104ad0 <argint>
     argint(1, &major) < 0 ||
80105643:	83 c4 10             	add    $0x10,%esp
80105646:	85 c0                	test   %eax,%eax
80105648:	78 36                	js     80105680 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010564a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010564e:	83 ec 0c             	sub    $0xc,%esp
80105651:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105655:	ba 03 00 00 00       	mov    $0x3,%edx
8010565a:	50                   	push   %eax
8010565b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010565e:	e8 3d f6 ff ff       	call   80104ca0 <create>
     argint(2, &minor) < 0 ||
80105663:	83 c4 10             	add    $0x10,%esp
80105666:	85 c0                	test   %eax,%eax
80105668:	74 16                	je     80105680 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010566a:	83 ec 0c             	sub    $0xc,%esp
8010566d:	50                   	push   %eax
8010566e:	e8 0d c4 ff ff       	call   80101a80 <iunlockput>
  end_op();
80105673:	e8 a8 d7 ff ff       	call   80102e20 <end_op>
  return 0;
80105678:	83 c4 10             	add    $0x10,%esp
8010567b:	31 c0                	xor    %eax,%eax
}
8010567d:	c9                   	leave
8010567e:	c3                   	ret
8010567f:	90                   	nop
    end_op();
80105680:	e8 9b d7 ff ff       	call   80102e20 <end_op>
    return -1;
80105685:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010568a:	c9                   	leave
8010568b:	c3                   	ret
8010568c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105690 <sys_chdir>:

int
sys_chdir(void)
{
80105690:	55                   	push   %ebp
80105691:	89 e5                	mov    %esp,%ebp
80105693:	56                   	push   %esi
80105694:	53                   	push   %ebx
80105695:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105698:	e8 43 e3 ff ff       	call   801039e0 <myproc>
8010569d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010569f:	e8 0c d7 ff ff       	call   80102db0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801056a4:	83 ec 08             	sub    $0x8,%esp
801056a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056aa:	50                   	push   %eax
801056ab:	6a 00                	push   $0x0
801056ad:	e8 de f4 ff ff       	call   80104b90 <argstr>
801056b2:	83 c4 10             	add    $0x10,%esp
801056b5:	85 c0                	test   %eax,%eax
801056b7:	78 77                	js     80105730 <sys_chdir+0xa0>
801056b9:	83 ec 0c             	sub    $0xc,%esp
801056bc:	ff 75 f4             	push   -0xc(%ebp)
801056bf:	e8 2c ca ff ff       	call   801020f0 <namei>
801056c4:	83 c4 10             	add    $0x10,%esp
801056c7:	89 c3                	mov    %eax,%ebx
801056c9:	85 c0                	test   %eax,%eax
801056cb:	74 63                	je     80105730 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801056cd:	83 ec 0c             	sub    $0xc,%esp
801056d0:	50                   	push   %eax
801056d1:	e8 1a c1 ff ff       	call   801017f0 <ilock>
  if(ip->type != T_DIR){
801056d6:	83 c4 10             	add    $0x10,%esp
801056d9:	66 83 7b 52 01       	cmpw   $0x1,0x52(%ebx)
801056de:	75 30                	jne    80105710 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801056e0:	83 ec 0c             	sub    $0xc,%esp
801056e3:	53                   	push   %ebx
801056e4:	e8 e7 c1 ff ff       	call   801018d0 <iunlock>
  iput(curproc->cwd);
801056e9:	58                   	pop    %eax
801056ea:	ff b6 c8 00 00 00    	push   0xc8(%esi)
801056f0:	e8 2b c2 ff ff       	call   80101920 <iput>
  end_op();
801056f5:	e8 26 d7 ff ff       	call   80102e20 <end_op>
  curproc->cwd = ip;
801056fa:	89 9e c8 00 00 00    	mov    %ebx,0xc8(%esi)
  return 0;
80105700:	83 c4 10             	add    $0x10,%esp
80105703:	31 c0                	xor    %eax,%eax
}
80105705:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105708:	5b                   	pop    %ebx
80105709:	5e                   	pop    %esi
8010570a:	5d                   	pop    %ebp
8010570b:	c3                   	ret
8010570c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
80105710:	83 ec 0c             	sub    $0xc,%esp
80105713:	53                   	push   %ebx
80105714:	e8 67 c3 ff ff       	call   80101a80 <iunlockput>
    end_op();
80105719:	e8 02 d7 ff ff       	call   80102e20 <end_op>
    return -1;
8010571e:	83 c4 10             	add    $0x10,%esp
    return -1;
80105721:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105726:	eb dd                	jmp    80105705 <sys_chdir+0x75>
80105728:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010572f:	00 
    end_op();
80105730:	e8 eb d6 ff ff       	call   80102e20 <end_op>
    return -1;
80105735:	eb ea                	jmp    80105721 <sys_chdir+0x91>
80105737:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010573e:	00 
8010573f:	90                   	nop

80105740 <sys_exec>:

int
sys_exec(void)
{
80105740:	55                   	push   %ebp
80105741:	89 e5                	mov    %esp,%ebp
80105743:	57                   	push   %edi
80105744:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105745:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010574b:	53                   	push   %ebx
8010574c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105752:	50                   	push   %eax
80105753:	6a 00                	push   $0x0
80105755:	e8 36 f4 ff ff       	call   80104b90 <argstr>
8010575a:	83 c4 10             	add    $0x10,%esp
8010575d:	85 c0                	test   %eax,%eax
8010575f:	0f 88 87 00 00 00    	js     801057ec <sys_exec+0xac>
80105765:	83 ec 08             	sub    $0x8,%esp
80105768:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010576e:	50                   	push   %eax
8010576f:	6a 01                	push   $0x1
80105771:	e8 5a f3 ff ff       	call   80104ad0 <argint>
80105776:	83 c4 10             	add    $0x10,%esp
80105779:	85 c0                	test   %eax,%eax
8010577b:	78 6f                	js     801057ec <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010577d:	83 ec 04             	sub    $0x4,%esp
80105780:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105786:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105788:	68 80 00 00 00       	push   $0x80
8010578d:	6a 00                	push   $0x0
8010578f:	56                   	push   %esi
80105790:	e8 8b f0 ff ff       	call   80104820 <memset>
80105795:	83 c4 10             	add    $0x10,%esp
80105798:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010579f:	00 
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801057a0:	83 ec 08             	sub    $0x8,%esp
801057a3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801057a9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801057b0:	50                   	push   %eax
801057b1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801057b7:	01 f8                	add    %edi,%eax
801057b9:	50                   	push   %eax
801057ba:	e8 81 f2 ff ff       	call   80104a40 <fetchint>
801057bf:	83 c4 10             	add    $0x10,%esp
801057c2:	85 c0                	test   %eax,%eax
801057c4:	78 26                	js     801057ec <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801057c6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801057cc:	85 c0                	test   %eax,%eax
801057ce:	74 30                	je     80105800 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801057d0:	83 ec 08             	sub    $0x8,%esp
801057d3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801057d6:	52                   	push   %edx
801057d7:	50                   	push   %eax
801057d8:	e8 a3 f2 ff ff       	call   80104a80 <fetchstr>
801057dd:	83 c4 10             	add    $0x10,%esp
801057e0:	85 c0                	test   %eax,%eax
801057e2:	78 08                	js     801057ec <sys_exec+0xac>
  for(i=0;; i++){
801057e4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801057e7:	83 fb 20             	cmp    $0x20,%ebx
801057ea:	75 b4                	jne    801057a0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801057ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801057ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057f4:	5b                   	pop    %ebx
801057f5:	5e                   	pop    %esi
801057f6:	5f                   	pop    %edi
801057f7:	5d                   	pop    %ebp
801057f8:	c3                   	ret
801057f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105800:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105807:	00 00 00 00 
  return exec(path, argv);
8010580b:	83 ec 08             	sub    $0x8,%esp
8010580e:	56                   	push   %esi
8010580f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105815:	e8 96 b2 ff ff       	call   80100ab0 <exec>
8010581a:	83 c4 10             	add    $0x10,%esp
}
8010581d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105820:	5b                   	pop    %ebx
80105821:	5e                   	pop    %esi
80105822:	5f                   	pop    %edi
80105823:	5d                   	pop    %ebp
80105824:	c3                   	ret
80105825:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010582c:	00 
8010582d:	8d 76 00             	lea    0x0(%esi),%esi

80105830 <sys_pipe>:

int
sys_pipe(void)
{
80105830:	55                   	push   %ebp
80105831:	89 e5                	mov    %esp,%ebp
80105833:	57                   	push   %edi
80105834:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105835:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105838:	53                   	push   %ebx
80105839:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010583c:	6a 08                	push   $0x8
8010583e:	50                   	push   %eax
8010583f:	6a 00                	push   $0x0
80105841:	e8 da f2 ff ff       	call   80104b20 <argptr>
80105846:	83 c4 10             	add    $0x10,%esp
80105849:	85 c0                	test   %eax,%eax
8010584b:	0f 88 8e 00 00 00    	js     801058df <sys_pipe+0xaf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105851:	83 ec 08             	sub    $0x8,%esp
80105854:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105857:	50                   	push   %eax
80105858:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010585b:	50                   	push   %eax
8010585c:	e8 1f dc ff ff       	call   80103480 <pipealloc>
80105861:	83 c4 10             	add    $0x10,%esp
80105864:	85 c0                	test   %eax,%eax
80105866:	78 77                	js     801058df <sys_pipe+0xaf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105868:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010586b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010586d:	e8 6e e1 ff ff       	call   801039e0 <myproc>
    if(curproc->ofile[fd] == 0){
80105872:	8b b4 98 88 00 00 00 	mov    0x88(%eax,%ebx,4),%esi
80105879:	85 f6                	test   %esi,%esi
8010587b:	74 16                	je     80105893 <sys_pipe+0x63>
8010587d:	8d 76 00             	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105880:	83 c3 01             	add    $0x1,%ebx
80105883:	83 fb 10             	cmp    $0x10,%ebx
80105886:	74 40                	je     801058c8 <sys_pipe+0x98>
    if(curproc->ofile[fd] == 0){
80105888:	8b b4 98 88 00 00 00 	mov    0x88(%eax,%ebx,4),%esi
8010588f:	85 f6                	test   %esi,%esi
80105891:	75 ed                	jne    80105880 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105893:	8d 73 20             	lea    0x20(%ebx),%esi
80105896:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010589a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010589d:	e8 3e e1 ff ff       	call   801039e0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801058a2:	31 d2                	xor    %edx,%edx
801058a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801058a8:	8b 8c 90 88 00 00 00 	mov    0x88(%eax,%edx,4),%ecx
801058af:	85 c9                	test   %ecx,%ecx
801058b1:	74 3d                	je     801058f0 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
801058b3:	83 c2 01             	add    $0x1,%edx
801058b6:	83 fa 10             	cmp    $0x10,%edx
801058b9:	75 ed                	jne    801058a8 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
801058bb:	e8 20 e1 ff ff       	call   801039e0 <myproc>
801058c0:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801058c7:	00 
    fileclose(rf);
801058c8:	83 ec 0c             	sub    $0xc,%esp
801058cb:	ff 75 e0             	push   -0x20(%ebp)
801058ce:	e8 6d b6 ff ff       	call   80100f40 <fileclose>
    fileclose(wf);
801058d3:	58                   	pop    %eax
801058d4:	ff 75 e4             	push   -0x1c(%ebp)
801058d7:	e8 64 b6 ff ff       	call   80100f40 <fileclose>
    return -1;
801058dc:	83 c4 10             	add    $0x10,%esp
    return -1;
801058df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058e4:	eb 1e                	jmp    80105904 <sys_pipe+0xd4>
801058e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801058ed:	00 
801058ee:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801058f0:	89 bc 90 88 00 00 00 	mov    %edi,0x88(%eax,%edx,4)
  }
  fd[0] = fd0;
801058f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
801058fa:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801058fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801058ff:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105902:	31 c0                	xor    %eax,%eax
}
80105904:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105907:	5b                   	pop    %ebx
80105908:	5e                   	pop    %esi
80105909:	5f                   	pop    %edi
8010590a:	5d                   	pop    %ebp
8010590b:	c3                   	ret
8010590c:	66 90                	xchg   %ax,%ax
8010590e:	66 90                	xchg   %ax,%ax

80105910 <sys_chmod>:



int
sys_chmod(void)
{
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	53                   	push   %ebx
80105914:	83 ec 14             	sub    $0x14,%esp
  char *path;
  int minor;
  struct inode *ip;
  CHMOD();
80105917:	e8 14 e2 ff ff       	call   80103b30 <CHMOD>
  // Fetch arguments: file path and mode
  if(argstr(0, &path) < 0 || argint(1, &minor) < 0)
8010591c:	83 ec 08             	sub    $0x8,%esp
8010591f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105922:	50                   	push   %eax
80105923:	6a 00                	push   $0x0
80105925:	e8 66 f2 ff ff       	call   80104b90 <argstr>
8010592a:	83 c4 10             	add    $0x10,%esp
8010592d:	85 c0                	test   %eax,%eax
8010592f:	78 6f                	js     801059a0 <sys_chmod+0x90>
80105931:	83 ec 08             	sub    $0x8,%esp
80105934:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105937:	50                   	push   %eax
80105938:	6a 01                	push   $0x1
8010593a:	e8 91 f1 ff ff       	call   80104ad0 <argint>
8010593f:	83 c4 10             	add    $0x10,%esp
80105942:	85 c0                	test   %eax,%eax
80105944:	78 5a                	js     801059a0 <sys_chmod+0x90>
    return -1;
  
  // Only allow 3-bit values (0 to 7)
  if(minor < 0 || minor > 7)
80105946:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
8010594a:	77 54                	ja     801059a0 <sys_chmod+0x90>
    return -1;

  begin_op();
8010594c:	e8 5f d4 ff ff       	call   80102db0 <begin_op>
  if((ip = namei(path)) == 0){
80105951:	83 ec 0c             	sub    $0xc,%esp
80105954:	ff 75 f0             	push   -0x10(%ebp)
80105957:	e8 94 c7 ff ff       	call   801020f0 <namei>
8010595c:	83 c4 10             	add    $0x10,%esp
8010595f:	89 c3                	mov    %eax,%ebx
80105961:	85 c0                	test   %eax,%eax
80105963:	74 2d                	je     80105992 <sys_chmod+0x82>
    end_op();
    return -1;
  }
  ilock(ip);
80105965:	83 ec 0c             	sub    $0xc,%esp
80105968:	50                   	push   %eax
80105969:	e8 82 be ff ff       	call   801017f0 <ilock>

  // Update the permission bits stored in the minor field.
  ip->mode = (ip->mode & ~0b111) | (ip->mode & 0b111);  // Set 3-bit mode
  iupdate(ip);
8010596e:	89 1c 24             	mov    %ebx,(%esp)
80105971:	e8 ba bd ff ff       	call   80101730 <iupdate>
  iunlockput(ip);
80105976:	89 1c 24             	mov    %ebx,(%esp)
80105979:	e8 02 c1 ff ff       	call   80101a80 <iunlockput>
  end_op();
8010597e:	e8 9d d4 ff ff       	call   80102e20 <end_op>
   CHMOD();
80105983:	e8 a8 e1 ff ff       	call   80103b30 <CHMOD>
  return 0;
80105988:	83 c4 10             	add    $0x10,%esp
8010598b:	31 c0                	xor    %eax,%eax
}
8010598d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105990:	c9                   	leave
80105991:	c3                   	ret
    end_op();
80105992:	e8 89 d4 ff ff       	call   80102e20 <end_op>
    return -1;
80105997:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010599e:	00 
8010599f:	90                   	nop
    return -1;
801059a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059a5:	eb e6                	jmp    8010598d <sys_chmod+0x7d>
801059a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801059ae:	00 
801059af:	90                   	nop

801059b0 <sys_block>:




int sys_block(int syscall_id)
{ CHMOD();
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	83 ec 18             	sub    $0x18,%esp
801059b6:	e8 75 e1 ff ff       	call   80103b30 <CHMOD>
  int id;
  if(argint(0, &id) < 0)
801059bb:	83 ec 08             	sub    $0x8,%esp
801059be:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059c1:	50                   	push   %eax
801059c2:	6a 00                	push   $0x0
801059c4:	e8 07 f1 ff ff       	call   80104ad0 <argint>
801059c9:	83 c4 10             	add    $0x10,%esp
801059cc:	85 c0                	test   %eax,%eax
801059ce:	78 40                	js     80105a10 <sys_block+0x60>
    return -1;

  // Ensure that the syscall id is valid.
  if(id < 0 || id >= MAX_SYSCALLS)
801059d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059d3:	83 f8 17             	cmp    $0x17,%eax
801059d6:	77 38                	ja     80105a10 <sys_block+0x60>
    return -1;

  // Do not allow critical system calls to be blocked.
  if(id == SYS_fork || id == SYS_exit)
801059d8:	83 e8 01             	sub    $0x1,%eax
801059db:	83 f8 01             	cmp    $0x1,%eax
801059de:	76 30                	jbe    80105a10 <sys_block+0x60>
    return -1;

  // Set the current process's blocked_syscalls flag.
  myproc()->blocked_syscalls[id] = 1;
801059e0:	e8 fb df ff ff       	call   801039e0 <myproc>
801059e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  
  cprintf("syscall %d is now blocked\n", id);
801059e8:	83 ec 08             	sub    $0x8,%esp
  myproc()->blocked_syscalls[id] = 1;
801059eb:	c7 04 90 01 00 00 00 	movl   $0x1,(%eax,%edx,4)
  cprintf("syscall %d is now blocked\n", id);
801059f2:	ff 75 f4             	push   -0xc(%ebp)
801059f5:	68 4e 7a 10 80       	push   $0x80107a4e
801059fa:	e8 b1 ac ff ff       	call   801006b0 <cprintf>
  return 0;
801059ff:	83 c4 10             	add    $0x10,%esp
80105a02:	31 c0                	xor    %eax,%eax
}
80105a04:	c9                   	leave
80105a05:	c3                   	ret
80105a06:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a0d:	00 
80105a0e:	66 90                	xchg   %ax,%ax
80105a10:	c9                   	leave
    return -1;
80105a11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a16:	c3                   	ret
80105a17:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a1e:	00 
80105a1f:	90                   	nop

80105a20 <sys_unblock>:

int sys_unblock(int syscall_id)
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	83 ec 20             	sub    $0x20,%esp
  int id;
  if(argint(0, &id) < 0)
80105a26:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a29:	50                   	push   %eax
80105a2a:	6a 00                	push   $0x0
80105a2c:	e8 9f f0 ff ff       	call   80104ad0 <argint>
80105a31:	83 c4 10             	add    $0x10,%esp
80105a34:	85 c0                	test   %eax,%eax
80105a36:	78 30                	js     80105a68 <sys_unblock+0x48>
    return -1;

  if(id < 0 || id >= MAX_SYSCALLS)
80105a38:	83 7d f4 17          	cmpl   $0x17,-0xc(%ebp)
80105a3c:	77 2a                	ja     80105a68 <sys_unblock+0x48>
    return -1;

  // Remove the block.
  myproc()->blocked_syscalls[id] = 0;
80105a3e:	e8 9d df ff ff       	call   801039e0 <myproc>
80105a43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  cprintf("syscall %d is now unblocked\n",id);
80105a46:	83 ec 08             	sub    $0x8,%esp
  myproc()->blocked_syscalls[id] = 0;
80105a49:	c7 04 90 00 00 00 00 	movl   $0x0,(%eax,%edx,4)
  cprintf("syscall %d is now unblocked\n",id);
80105a50:	ff 75 f4             	push   -0xc(%ebp)
80105a53:	68 69 7a 10 80       	push   $0x80107a69
80105a58:	e8 53 ac ff ff       	call   801006b0 <cprintf>
  return 0;
80105a5d:	83 c4 10             	add    $0x10,%esp
80105a60:	31 c0                	xor    %eax,%eax
}
80105a62:	c9                   	leave
80105a63:	c3                   	ret
80105a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a68:	c9                   	leave
    return -1;
80105a69:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a6e:	c3                   	ret
80105a6f:	90                   	nop

80105a70 <sys_gethistory>:



int
sys_gethistory(void)
{
80105a70:	55                   	push   %ebp
80105a71:	89 e5                	mov    %esp,%ebp
80105a73:	56                   	push   %esi
80105a74:	53                   	push   %ebx
80105a75:	83 ec 10             	sub    $0x10,%esp
  CHMOD();
80105a78:	e8 b3 e0 ff ff       	call   80103b30 <CHMOD>
  char *ubuf;
  int size, i, nbytes;
  CHMOD();
80105a7d:	e8 ae e0 ff ff       	call   80103b30 <CHMOD>
  // We expect two arguments: a pointer to a user buffer and its size.
  if(argptr(0, &ubuf, sizeof(char*)) < 0)
80105a82:	83 ec 04             	sub    $0x4,%esp
80105a85:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a88:	6a 04                	push   $0x4
80105a8a:	50                   	push   %eax
80105a8b:	6a 00                	push   $0x0
80105a8d:	e8 8e f0 ff ff       	call   80104b20 <argptr>
80105a92:	83 c4 10             	add    $0x10,%esp
80105a95:	85 c0                	test   %eax,%eax
80105a97:	78 5f                	js     80105af8 <sys_gethistory+0x88>
    return -1;
  if(argint(1, &size) < 0)
80105a99:	83 ec 08             	sub    $0x8,%esp
80105a9c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a9f:	50                   	push   %eax
80105aa0:	6a 01                	push   $0x1
80105aa2:	e8 29 f0 ff ff       	call   80104ad0 <argint>
80105aa7:	83 c4 10             	add    $0x10,%esp
80105aaa:	85 c0                	test   %eax,%eax
80105aac:	78 4a                	js     80105af8 <sys_gethistory+0x88>
    return -1;
  CHMOD();
80105aae:	e8 7d e0 ff ff       	call   80103b30 <CHMOD>
  // Compute how many bytes are available in the history buffer.
  nbytes = nhistory * sizeof(struct history_entry);
80105ab3:	6b 15 54 64 11 80 1c 	imul   $0x1c,0x80116454,%edx
  if(nbytes > size)
80105aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
    nbytes = size;
  
  // Copy out the data to user space.
  if(copyout(myproc()->pgdir, (uint)ubuf, (char*)history_list, nbytes) < 0)
80105abd:	8b 75 f0             	mov    -0x10(%ebp),%esi
  if(nbytes > size)
80105ac0:	39 c2                	cmp    %eax,%edx
80105ac2:	0f 4e c2             	cmovle %edx,%eax
80105ac5:	89 c3                	mov    %eax,%ebx
  if(copyout(myproc()->pgdir, (uint)ubuf, (char*)history_list, nbytes) < 0)
80105ac7:	e8 14 df ff ff       	call   801039e0 <myproc>
80105acc:	53                   	push   %ebx
80105acd:	68 60 64 11 80       	push   $0x80116460
80105ad2:	56                   	push   %esi
80105ad3:	ff 70 64             	push   0x64(%eax)
80105ad6:	e8 45 1a 00 00       	call   80107520 <copyout>
80105adb:	83 c4 10             	add    $0x10,%esp
80105ade:	85 c0                	test   %eax,%eax
80105ae0:	78 16                	js     80105af8 <sys_gethistory+0x88>
    return -1;
  
  // Return the number of history entries copied.
  return nbytes / sizeof(struct history_entry);
80105ae2:	c1 eb 02             	shr    $0x2,%ebx
80105ae5:	b8 25 49 92 24       	mov    $0x24924925,%eax
80105aea:	f7 e3                	mul    %ebx
}
80105aec:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105aef:	89 d0                	mov    %edx,%eax
80105af1:	5b                   	pop    %ebx
80105af2:	5e                   	pop    %esi
80105af3:	5d                   	pop    %ebp
80105af4:	c3                   	ret
80105af5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105af8:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80105afd:	eb ed                	jmp    80105aec <sys_gethistory+0x7c>
80105aff:	90                   	nop

80105b00 <sys_fork>:

int
sys_fork(void)
{
  return fork();
80105b00:	e9 cb e0 ff ff       	jmp    80103bd0 <fork>
80105b05:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b0c:	00 
80105b0d:	8d 76 00             	lea    0x0(%esi),%esi

80105b10 <sys_exit>:
}

int
sys_exit(void)
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	83 ec 08             	sub    $0x8,%esp
  exit();
80105b16:	e8 45 e3 ff ff       	call   80103e60 <exit>
  return 0;  // not reached
}
80105b1b:	31 c0                	xor    %eax,%eax
80105b1d:	c9                   	leave
80105b1e:	c3                   	ret
80105b1f:	90                   	nop

80105b20 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105b20:	e9 db e4 ff ff       	jmp    80104000 <wait>
80105b25:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b2c:	00 
80105b2d:	8d 76 00             	lea    0x0(%esi),%esi

80105b30 <sys_kill>:
}

int
sys_kill(void)
{
80105b30:	55                   	push   %ebp
80105b31:	89 e5                	mov    %esp,%ebp
80105b33:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105b36:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b39:	50                   	push   %eax
80105b3a:	6a 00                	push   $0x0
80105b3c:	e8 8f ef ff ff       	call   80104ad0 <argint>
80105b41:	83 c4 10             	add    $0x10,%esp
80105b44:	85 c0                	test   %eax,%eax
80105b46:	78 18                	js     80105b60 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105b48:	83 ec 0c             	sub    $0xc,%esp
80105b4b:	ff 75 f4             	push   -0xc(%ebp)
80105b4e:	e8 6d e7 ff ff       	call   801042c0 <kill>
80105b53:	83 c4 10             	add    $0x10,%esp
}
80105b56:	c9                   	leave
80105b57:	c3                   	ret
80105b58:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b5f:	00 
80105b60:	c9                   	leave
    return -1;
80105b61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b66:	c3                   	ret
80105b67:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b6e:	00 
80105b6f:	90                   	nop

80105b70 <sys_getpid>:

int
sys_getpid(void)
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105b76:	e8 65 de ff ff       	call   801039e0 <myproc>
80105b7b:	8b 40 70             	mov    0x70(%eax),%eax
}
80105b7e:	c9                   	leave
80105b7f:	c3                   	ret

80105b80 <sys_sbrk>:

int
sys_sbrk(void)
{
80105b80:	55                   	push   %ebp
80105b81:	89 e5                	mov    %esp,%ebp
80105b83:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105b84:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105b87:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105b8a:	50                   	push   %eax
80105b8b:	6a 00                	push   $0x0
80105b8d:	e8 3e ef ff ff       	call   80104ad0 <argint>
80105b92:	83 c4 10             	add    $0x10,%esp
80105b95:	85 c0                	test   %eax,%eax
80105b97:	78 27                	js     80105bc0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105b99:	e8 42 de ff ff       	call   801039e0 <myproc>
  if(growproc(n) < 0)
80105b9e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105ba1:	8b 58 60             	mov    0x60(%eax),%ebx
  if(growproc(n) < 0)
80105ba4:	ff 75 f4             	push   -0xc(%ebp)
80105ba7:	e8 a4 df ff ff       	call   80103b50 <growproc>
80105bac:	83 c4 10             	add    $0x10,%esp
80105baf:	85 c0                	test   %eax,%eax
80105bb1:	78 0d                	js     80105bc0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105bb3:	89 d8                	mov    %ebx,%eax
80105bb5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105bb8:	c9                   	leave
80105bb9:	c3                   	ret
80105bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105bc0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105bc5:	eb ec                	jmp    80105bb3 <sys_sbrk+0x33>
80105bc7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105bce:	00 
80105bcf:	90                   	nop

80105bd0 <sys_sleep>:

int
sys_sleep(void)
{
80105bd0:	55                   	push   %ebp
80105bd1:	89 e5                	mov    %esp,%ebp
80105bd3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105bd4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105bd7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105bda:	50                   	push   %eax
80105bdb:	6a 00                	push   $0x0
80105bdd:	e8 ee ee ff ff       	call   80104ad0 <argint>
80105be2:	83 c4 10             	add    $0x10,%esp
80105be5:	85 c0                	test   %eax,%eax
80105be7:	78 67                	js     80105c50 <sys_sleep+0x80>
    return -1;
  acquire(&tickslock);
80105be9:	83 ec 0c             	sub    $0xc,%esp
80105bec:	68 80 7a 11 80       	push   $0x80117a80
80105bf1:	e8 2a eb ff ff       	call   80104720 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105bf6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105bf9:	8b 1d 60 7a 11 80    	mov    0x80117a60,%ebx
  while(ticks - ticks0 < n){
80105bff:	83 c4 10             	add    $0x10,%esp
80105c02:	85 d2                	test   %edx,%edx
80105c04:	75 2b                	jne    80105c31 <sys_sleep+0x61>
80105c06:	eb 58                	jmp    80105c60 <sys_sleep+0x90>
80105c08:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c0f:	00 
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105c10:	83 ec 08             	sub    $0x8,%esp
80105c13:	68 80 7a 11 80       	push   $0x80117a80
80105c18:	68 60 7a 11 80       	push   $0x80117a60
80105c1d:	e8 6e e5 ff ff       	call   80104190 <sleep>
  while(ticks - ticks0 < n){
80105c22:	a1 60 7a 11 80       	mov    0x80117a60,%eax
80105c27:	83 c4 10             	add    $0x10,%esp
80105c2a:	29 d8                	sub    %ebx,%eax
80105c2c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105c2f:	73 2f                	jae    80105c60 <sys_sleep+0x90>
    if(myproc()->killed){
80105c31:	e8 aa dd ff ff       	call   801039e0 <myproc>
80105c36:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80105c3c:	85 c0                	test   %eax,%eax
80105c3e:	74 d0                	je     80105c10 <sys_sleep+0x40>
      release(&tickslock);
80105c40:	83 ec 0c             	sub    $0xc,%esp
80105c43:	68 80 7a 11 80       	push   $0x80117a80
80105c48:	e8 73 ea ff ff       	call   801046c0 <release>
      return -1;
80105c4d:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
80105c50:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105c53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c58:	c9                   	leave
80105c59:	c3                   	ret
80105c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&tickslock);
80105c60:	83 ec 0c             	sub    $0xc,%esp
80105c63:	68 80 7a 11 80       	push   $0x80117a80
80105c68:	e8 53 ea ff ff       	call   801046c0 <release>
}
80105c6d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
80105c70:	83 c4 10             	add    $0x10,%esp
80105c73:	31 c0                	xor    %eax,%eax
}
80105c75:	c9                   	leave
80105c76:	c3                   	ret
80105c77:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c7e:	00 
80105c7f:	90                   	nop

80105c80 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
80105c83:	53                   	push   %ebx
80105c84:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105c87:	68 80 7a 11 80       	push   $0x80117a80
80105c8c:	e8 8f ea ff ff       	call   80104720 <acquire>
  xticks = ticks;
80105c91:	8b 1d 60 7a 11 80    	mov    0x80117a60,%ebx
  release(&tickslock);
80105c97:	c7 04 24 80 7a 11 80 	movl   $0x80117a80,(%esp)
80105c9e:	e8 1d ea ff ff       	call   801046c0 <release>
  return xticks;
}
80105ca3:	89 d8                	mov    %ebx,%eax
80105ca5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ca8:	c9                   	leave
80105ca9:	c3                   	ret

80105caa <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105caa:	1e                   	push   %ds
  pushl %es
80105cab:	06                   	push   %es
  pushl %fs
80105cac:	0f a0                	push   %fs
  pushl %gs
80105cae:	0f a8                	push   %gs
  pushal
80105cb0:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105cb1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105cb5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105cb7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105cb9:	54                   	push   %esp
  call trap
80105cba:	e8 c1 00 00 00       	call   80105d80 <trap>
  addl $4, %esp
80105cbf:	83 c4 04             	add    $0x4,%esp

80105cc2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105cc2:	61                   	popa
  popl %gs
80105cc3:	0f a9                	pop    %gs
  popl %fs
80105cc5:	0f a1                	pop    %fs
  popl %es
80105cc7:	07                   	pop    %es
  popl %ds
80105cc8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105cc9:	83 c4 08             	add    $0x8,%esp
  iret
80105ccc:	cf                   	iret
80105ccd:	66 90                	xchg   %ax,%ax
80105ccf:	90                   	nop

80105cd0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105cd0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105cd1:	31 c0                	xor    %eax,%eax
{
80105cd3:	89 e5                	mov    %esp,%ebp
80105cd5:	83 ec 08             	sub    $0x8,%esp
80105cd8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105cdf:	00 
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105ce0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105ce7:	c7 04 c5 c2 7a 11 80 	movl   $0x8e000008,-0x7fee853e(,%eax,8)
80105cee:	08 00 00 8e 
80105cf2:	66 89 14 c5 c0 7a 11 	mov    %dx,-0x7fee8540(,%eax,8)
80105cf9:	80 
80105cfa:	c1 ea 10             	shr    $0x10,%edx
80105cfd:	66 89 14 c5 c6 7a 11 	mov    %dx,-0x7fee853a(,%eax,8)
80105d04:	80 
  for(i = 0; i < 256; i++)
80105d05:	83 c0 01             	add    $0x1,%eax
80105d08:	3d 00 01 00 00       	cmp    $0x100,%eax
80105d0d:	75 d1                	jne    80105ce0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105d0f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d12:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105d17:	c7 05 c2 7c 11 80 08 	movl   $0xef000008,0x80117cc2
80105d1e:	00 00 ef 
  initlock(&tickslock, "time");
80105d21:	68 86 7a 10 80       	push   $0x80107a86
80105d26:	68 80 7a 11 80       	push   $0x80117a80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d2b:	66 a3 c0 7c 11 80    	mov    %ax,0x80117cc0
80105d31:	c1 e8 10             	shr    $0x10,%eax
80105d34:	66 a3 c6 7c 11 80    	mov    %ax,0x80117cc6
  initlock(&tickslock, "time");
80105d3a:	e8 f1 e7 ff ff       	call   80104530 <initlock>
}
80105d3f:	83 c4 10             	add    $0x10,%esp
80105d42:	c9                   	leave
80105d43:	c3                   	ret
80105d44:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d4b:	00 
80105d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d50 <idtinit>:

void
idtinit(void)
{
80105d50:	55                   	push   %ebp
  pd[0] = size-1;
80105d51:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105d56:	89 e5                	mov    %esp,%ebp
80105d58:	83 ec 10             	sub    $0x10,%esp
80105d5b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105d5f:	b8 c0 7a 11 80       	mov    $0x80117ac0,%eax
80105d64:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105d68:	c1 e8 10             	shr    $0x10,%eax
80105d6b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105d6f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105d72:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105d75:	c9                   	leave
80105d76:	c3                   	ret
80105d77:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d7e:	00 
80105d7f:	90                   	nop

80105d80 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105d80:	55                   	push   %ebp
80105d81:	89 e5                	mov    %esp,%ebp
80105d83:	57                   	push   %edi
80105d84:	56                   	push   %esi
80105d85:	53                   	push   %ebx
80105d86:	83 ec 1c             	sub    $0x1c,%esp
80105d89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105d8c:	8b 43 30             	mov    0x30(%ebx),%eax
80105d8f:	83 f8 40             	cmp    $0x40,%eax
80105d92:	0f 84 78 01 00 00    	je     80105f10 <trap+0x190>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105d98:	83 e8 20             	sub    $0x20,%eax
80105d9b:	83 f8 1f             	cmp    $0x1f,%eax
80105d9e:	0f 87 8c 00 00 00    	ja     80105e30 <trap+0xb0>
80105da4:	ff 24 85 e8 7f 10 80 	jmp    *-0x7fef8018(,%eax,4)
80105dab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105db0:	e8 eb c4 ff ff       	call   801022a0 <ideintr>
    lapiceoi();
80105db5:	e8 a6 cb ff ff       	call   80102960 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dba:	e8 21 dc ff ff       	call   801039e0 <myproc>
80105dbf:	85 c0                	test   %eax,%eax
80105dc1:	74 1d                	je     80105de0 <trap+0x60>
80105dc3:	e8 18 dc ff ff       	call   801039e0 <myproc>
80105dc8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80105dce:	85 d2                	test   %edx,%edx
80105dd0:	74 0e                	je     80105de0 <trap+0x60>
80105dd2:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105dd6:	f7 d0                	not    %eax
80105dd8:	a8 03                	test   $0x3,%al
80105dda:	0f 84 f8 01 00 00    	je     80105fd8 <trap+0x258>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105de0:	e8 fb db ff ff       	call   801039e0 <myproc>
80105de5:	85 c0                	test   %eax,%eax
80105de7:	74 0f                	je     80105df8 <trap+0x78>
80105de9:	e8 f2 db ff ff       	call   801039e0 <myproc>
80105dee:	83 78 6c 04          	cmpl   $0x4,0x6c(%eax)
80105df2:	0f 84 c8 00 00 00    	je     80105ec0 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105df8:	e8 e3 db ff ff       	call   801039e0 <myproc>
80105dfd:	85 c0                	test   %eax,%eax
80105dff:	74 1d                	je     80105e1e <trap+0x9e>
80105e01:	e8 da db ff ff       	call   801039e0 <myproc>
80105e06:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80105e0c:	85 c0                	test   %eax,%eax
80105e0e:	74 0e                	je     80105e1e <trap+0x9e>
80105e10:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105e14:	f7 d0                	not    %eax
80105e16:	a8 03                	test   $0x3,%al
80105e18:	0f 84 25 01 00 00    	je     80105f43 <trap+0x1c3>
    exit();
}
80105e1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e21:	5b                   	pop    %ebx
80105e22:	5e                   	pop    %esi
80105e23:	5f                   	pop    %edi
80105e24:	5d                   	pop    %ebp
80105e25:	c3                   	ret
80105e26:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105e2d:	00 
80105e2e:	66 90                	xchg   %ax,%ax
    if(myproc() == 0 || (tf->cs&3) == 0){
80105e30:	e8 ab db ff ff       	call   801039e0 <myproc>
80105e35:	8b 7b 38             	mov    0x38(%ebx),%edi
80105e38:	85 c0                	test   %eax,%eax
80105e3a:	0f 84 b2 01 00 00    	je     80105ff2 <trap+0x272>
80105e40:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105e44:	0f 84 a8 01 00 00    	je     80105ff2 <trap+0x272>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105e4a:	0f 20 d1             	mov    %cr2,%ecx
80105e4d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e50:	e8 6b db ff ff       	call   801039c0 <cpuid>
80105e55:	8b 73 30             	mov    0x30(%ebx),%esi
80105e58:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105e5b:	8b 43 34             	mov    0x34(%ebx),%eax
80105e5e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105e61:	e8 7a db ff ff       	call   801039e0 <myproc>
80105e66:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105e69:	e8 72 db ff ff       	call   801039e0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e6e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105e71:	51                   	push   %ecx
80105e72:	57                   	push   %edi
80105e73:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105e76:	52                   	push   %edx
80105e77:	ff 75 e4             	push   -0x1c(%ebp)
80105e7a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105e7b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105e7e:	81 c6 cc 00 00 00    	add    $0xcc,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e84:	56                   	push   %esi
80105e85:	ff 70 70             	push   0x70(%eax)
80105e88:	68 d4 7c 10 80       	push   $0x80107cd4
80105e8d:	e8 1e a8 ff ff       	call   801006b0 <cprintf>
    myproc()->killed = 1;
80105e92:	83 c4 20             	add    $0x20,%esp
80105e95:	e8 46 db ff ff       	call   801039e0 <myproc>
80105e9a:	c7 80 84 00 00 00 01 	movl   $0x1,0x84(%eax)
80105ea1:	00 00 00 
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ea4:	e8 37 db ff ff       	call   801039e0 <myproc>
80105ea9:	85 c0                	test   %eax,%eax
80105eab:	0f 85 12 ff ff ff    	jne    80105dc3 <trap+0x43>
80105eb1:	e9 2a ff ff ff       	jmp    80105de0 <trap+0x60>
80105eb6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105ebd:	00 
80105ebe:	66 90                	xchg   %ax,%ax
  if(myproc() && myproc()->state == RUNNING &&
80105ec0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105ec4:	0f 85 2e ff ff ff    	jne    80105df8 <trap+0x78>
    yield();
80105eca:	e8 71 e2 ff ff       	call   80104140 <yield>
80105ecf:	e9 24 ff ff ff       	jmp    80105df8 <trap+0x78>
80105ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105ed8:	8b 7b 38             	mov    0x38(%ebx),%edi
80105edb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105edf:	e8 dc da ff ff       	call   801039c0 <cpuid>
80105ee4:	57                   	push   %edi
80105ee5:	56                   	push   %esi
80105ee6:	50                   	push   %eax
80105ee7:	68 7c 7c 10 80       	push   $0x80107c7c
80105eec:	e8 bf a7 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105ef1:	e8 6a ca ff ff       	call   80102960 <lapiceoi>
    break;
80105ef6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ef9:	e8 e2 da ff ff       	call   801039e0 <myproc>
80105efe:	85 c0                	test   %eax,%eax
80105f00:	0f 85 bd fe ff ff    	jne    80105dc3 <trap+0x43>
80105f06:	e9 d5 fe ff ff       	jmp    80105de0 <trap+0x60>
80105f0b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105f10:	e8 cb da ff ff       	call   801039e0 <myproc>
80105f15:	8b b0 84 00 00 00    	mov    0x84(%eax),%esi
80105f1b:	85 f6                	test   %esi,%esi
80105f1d:	0f 85 c5 00 00 00    	jne    80105fe8 <trap+0x268>
    myproc()->tf = tf;
80105f23:	e8 b8 da ff ff       	call   801039e0 <myproc>
80105f28:	89 58 78             	mov    %ebx,0x78(%eax)
    syscall();
80105f2b:	e8 e0 ec ff ff       	call   80104c10 <syscall>
    if(myproc()->killed)
80105f30:	e8 ab da ff ff       	call   801039e0 <myproc>
80105f35:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
80105f3b:	85 c9                	test   %ecx,%ecx
80105f3d:	0f 84 db fe ff ff    	je     80105e1e <trap+0x9e>
}
80105f43:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f46:	5b                   	pop    %ebx
80105f47:	5e                   	pop    %esi
80105f48:	5f                   	pop    %edi
80105f49:	5d                   	pop    %ebp
      exit();
80105f4a:	e9 11 df ff ff       	jmp    80103e60 <exit>
80105f4f:	90                   	nop
    uartintr();
80105f50:	e8 4b 02 00 00       	call   801061a0 <uartintr>
    lapiceoi();
80105f55:	e8 06 ca ff ff       	call   80102960 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f5a:	e8 81 da ff ff       	call   801039e0 <myproc>
80105f5f:	85 c0                	test   %eax,%eax
80105f61:	0f 85 5c fe ff ff    	jne    80105dc3 <trap+0x43>
80105f67:	e9 74 fe ff ff       	jmp    80105de0 <trap+0x60>
80105f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105f70:	e8 bb c8 ff ff       	call   80102830 <kbdintr>
    lapiceoi();
80105f75:	e8 e6 c9 ff ff       	call   80102960 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f7a:	e8 61 da ff ff       	call   801039e0 <myproc>
80105f7f:	85 c0                	test   %eax,%eax
80105f81:	0f 85 3c fe ff ff    	jne    80105dc3 <trap+0x43>
80105f87:	e9 54 fe ff ff       	jmp    80105de0 <trap+0x60>
80105f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105f90:	e8 2b da ff ff       	call   801039c0 <cpuid>
80105f95:	85 c0                	test   %eax,%eax
80105f97:	0f 85 18 fe ff ff    	jne    80105db5 <trap+0x35>
      acquire(&tickslock);
80105f9d:	83 ec 0c             	sub    $0xc,%esp
80105fa0:	68 80 7a 11 80       	push   $0x80117a80
80105fa5:	e8 76 e7 ff ff       	call   80104720 <acquire>
      ticks++;
80105faa:	83 05 60 7a 11 80 01 	addl   $0x1,0x80117a60
      wakeup(&ticks);
80105fb1:	c7 04 24 60 7a 11 80 	movl   $0x80117a60,(%esp)
80105fb8:	e8 a3 e2 ff ff       	call   80104260 <wakeup>
      release(&tickslock);
80105fbd:	c7 04 24 80 7a 11 80 	movl   $0x80117a80,(%esp)
80105fc4:	e8 f7 e6 ff ff       	call   801046c0 <release>
80105fc9:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105fcc:	e9 e4 fd ff ff       	jmp    80105db5 <trap+0x35>
80105fd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105fd8:	e8 83 de ff ff       	call   80103e60 <exit>
80105fdd:	e9 fe fd ff ff       	jmp    80105de0 <trap+0x60>
80105fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105fe8:	e8 73 de ff ff       	call   80103e60 <exit>
80105fed:	e9 31 ff ff ff       	jmp    80105f23 <trap+0x1a3>
80105ff2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105ff5:	e8 c6 d9 ff ff       	call   801039c0 <cpuid>
80105ffa:	83 ec 0c             	sub    $0xc,%esp
80105ffd:	56                   	push   %esi
80105ffe:	57                   	push   %edi
80105fff:	50                   	push   %eax
80106000:	ff 73 30             	push   0x30(%ebx)
80106003:	68 a0 7c 10 80       	push   $0x80107ca0
80106008:	e8 a3 a6 ff ff       	call   801006b0 <cprintf>
      panic("trap");
8010600d:	83 c4 14             	add    $0x14,%esp
80106010:	68 8b 7a 10 80       	push   $0x80107a8b
80106015:	e8 66 a3 ff ff       	call   80100380 <panic>
8010601a:	66 90                	xchg   %ax,%ax
8010601c:	66 90                	xchg   %ax,%ax
8010601e:	66 90                	xchg   %ax,%ax

80106020 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106020:	a1 c0 82 11 80       	mov    0x801182c0,%eax
80106025:	85 c0                	test   %eax,%eax
80106027:	74 17                	je     80106040 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106029:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010602e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010602f:	a8 01                	test   $0x1,%al
80106031:	74 0d                	je     80106040 <uartgetc+0x20>
80106033:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106038:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106039:	0f b6 c0             	movzbl %al,%eax
8010603c:	c3                   	ret
8010603d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106040:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106045:	c3                   	ret
80106046:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010604d:	00 
8010604e:	66 90                	xchg   %ax,%ax

80106050 <uartinit>:
{
80106050:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106051:	31 c9                	xor    %ecx,%ecx
80106053:	89 c8                	mov    %ecx,%eax
80106055:	89 e5                	mov    %esp,%ebp
80106057:	57                   	push   %edi
80106058:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010605d:	56                   	push   %esi
8010605e:	89 fa                	mov    %edi,%edx
80106060:	53                   	push   %ebx
80106061:	83 ec 1c             	sub    $0x1c,%esp
80106064:	ee                   	out    %al,(%dx)
80106065:	be fb 03 00 00       	mov    $0x3fb,%esi
8010606a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010606f:	89 f2                	mov    %esi,%edx
80106071:	ee                   	out    %al,(%dx)
80106072:	b8 0c 00 00 00       	mov    $0xc,%eax
80106077:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010607c:	ee                   	out    %al,(%dx)
8010607d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106082:	89 c8                	mov    %ecx,%eax
80106084:	89 da                	mov    %ebx,%edx
80106086:	ee                   	out    %al,(%dx)
80106087:	b8 03 00 00 00       	mov    $0x3,%eax
8010608c:	89 f2                	mov    %esi,%edx
8010608e:	ee                   	out    %al,(%dx)
8010608f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106094:	89 c8                	mov    %ecx,%eax
80106096:	ee                   	out    %al,(%dx)
80106097:	b8 01 00 00 00       	mov    $0x1,%eax
8010609c:	89 da                	mov    %ebx,%edx
8010609e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010609f:	ba fd 03 00 00       	mov    $0x3fd,%edx
801060a4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801060a5:	3c ff                	cmp    $0xff,%al
801060a7:	0f 84 7c 00 00 00    	je     80106129 <uartinit+0xd9>
  uart = 1;
801060ad:	c7 05 c0 82 11 80 01 	movl   $0x1,0x801182c0
801060b4:	00 00 00 
801060b7:	89 fa                	mov    %edi,%edx
801060b9:	ec                   	in     (%dx),%al
801060ba:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060bf:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801060c0:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801060c3:	bf 90 7a 10 80       	mov    $0x80107a90,%edi
801060c8:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
801060cd:	6a 00                	push   $0x0
801060cf:	6a 04                	push   $0x4
801060d1:	e8 fa c3 ff ff       	call   801024d0 <ioapicenable>
801060d6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801060d9:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
801060dd:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
801060e0:	a1 c0 82 11 80       	mov    0x801182c0,%eax
801060e5:	85 c0                	test   %eax,%eax
801060e7:	74 32                	je     8010611b <uartinit+0xcb>
801060e9:	89 f2                	mov    %esi,%edx
801060eb:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801060ec:	a8 20                	test   $0x20,%al
801060ee:	75 21                	jne    80106111 <uartinit+0xc1>
801060f0:	bb 80 00 00 00       	mov    $0x80,%ebx
801060f5:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
801060f8:	83 ec 0c             	sub    $0xc,%esp
801060fb:	6a 0a                	push   $0xa
801060fd:	e8 7e c8 ff ff       	call   80102980 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106102:	83 c4 10             	add    $0x10,%esp
80106105:	83 eb 01             	sub    $0x1,%ebx
80106108:	74 07                	je     80106111 <uartinit+0xc1>
8010610a:	89 f2                	mov    %esi,%edx
8010610c:	ec                   	in     (%dx),%al
8010610d:	a8 20                	test   $0x20,%al
8010610f:	74 e7                	je     801060f8 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106111:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106116:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010611a:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
8010611b:	0f b6 47 01          	movzbl 0x1(%edi),%eax
8010611f:	83 c7 01             	add    $0x1,%edi
80106122:	88 45 e7             	mov    %al,-0x19(%ebp)
80106125:	84 c0                	test   %al,%al
80106127:	75 b7                	jne    801060e0 <uartinit+0x90>
}
80106129:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010612c:	5b                   	pop    %ebx
8010612d:	5e                   	pop    %esi
8010612e:	5f                   	pop    %edi
8010612f:	5d                   	pop    %ebp
80106130:	c3                   	ret
80106131:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106138:	00 
80106139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106140 <uartputc>:
  if(!uart)
80106140:	a1 c0 82 11 80       	mov    0x801182c0,%eax
80106145:	85 c0                	test   %eax,%eax
80106147:	74 4f                	je     80106198 <uartputc+0x58>
{
80106149:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010614a:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010614f:	89 e5                	mov    %esp,%ebp
80106151:	56                   	push   %esi
80106152:	53                   	push   %ebx
80106153:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106154:	a8 20                	test   $0x20,%al
80106156:	75 29                	jne    80106181 <uartputc+0x41>
80106158:	bb 80 00 00 00       	mov    $0x80,%ebx
8010615d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106162:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106168:	83 ec 0c             	sub    $0xc,%esp
8010616b:	6a 0a                	push   $0xa
8010616d:	e8 0e c8 ff ff       	call   80102980 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106172:	83 c4 10             	add    $0x10,%esp
80106175:	83 eb 01             	sub    $0x1,%ebx
80106178:	74 07                	je     80106181 <uartputc+0x41>
8010617a:	89 f2                	mov    %esi,%edx
8010617c:	ec                   	in     (%dx),%al
8010617d:	a8 20                	test   $0x20,%al
8010617f:	74 e7                	je     80106168 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106181:	8b 45 08             	mov    0x8(%ebp),%eax
80106184:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106189:	ee                   	out    %al,(%dx)
}
8010618a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010618d:	5b                   	pop    %ebx
8010618e:	5e                   	pop    %esi
8010618f:	5d                   	pop    %ebp
80106190:	c3                   	ret
80106191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106198:	c3                   	ret
80106199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801061a0 <uartintr>:

void
uartintr(void)
{
801061a0:	55                   	push   %ebp
801061a1:	89 e5                	mov    %esp,%ebp
801061a3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801061a6:	68 20 60 10 80       	push   $0x80106020
801061ab:	e8 f0 a6 ff ff       	call   801008a0 <consoleintr>
}
801061b0:	83 c4 10             	add    $0x10,%esp
801061b3:	c9                   	leave
801061b4:	c3                   	ret

801061b5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801061b5:	6a 00                	push   $0x0
  pushl $0
801061b7:	6a 00                	push   $0x0
  jmp alltraps
801061b9:	e9 ec fa ff ff       	jmp    80105caa <alltraps>

801061be <vector1>:
.globl vector1
vector1:
  pushl $0
801061be:	6a 00                	push   $0x0
  pushl $1
801061c0:	6a 01                	push   $0x1
  jmp alltraps
801061c2:	e9 e3 fa ff ff       	jmp    80105caa <alltraps>

801061c7 <vector2>:
.globl vector2
vector2:
  pushl $0
801061c7:	6a 00                	push   $0x0
  pushl $2
801061c9:	6a 02                	push   $0x2
  jmp alltraps
801061cb:	e9 da fa ff ff       	jmp    80105caa <alltraps>

801061d0 <vector3>:
.globl vector3
vector3:
  pushl $0
801061d0:	6a 00                	push   $0x0
  pushl $3
801061d2:	6a 03                	push   $0x3
  jmp alltraps
801061d4:	e9 d1 fa ff ff       	jmp    80105caa <alltraps>

801061d9 <vector4>:
.globl vector4
vector4:
  pushl $0
801061d9:	6a 00                	push   $0x0
  pushl $4
801061db:	6a 04                	push   $0x4
  jmp alltraps
801061dd:	e9 c8 fa ff ff       	jmp    80105caa <alltraps>

801061e2 <vector5>:
.globl vector5
vector5:
  pushl $0
801061e2:	6a 00                	push   $0x0
  pushl $5
801061e4:	6a 05                	push   $0x5
  jmp alltraps
801061e6:	e9 bf fa ff ff       	jmp    80105caa <alltraps>

801061eb <vector6>:
.globl vector6
vector6:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $6
801061ed:	6a 06                	push   $0x6
  jmp alltraps
801061ef:	e9 b6 fa ff ff       	jmp    80105caa <alltraps>

801061f4 <vector7>:
.globl vector7
vector7:
  pushl $0
801061f4:	6a 00                	push   $0x0
  pushl $7
801061f6:	6a 07                	push   $0x7
  jmp alltraps
801061f8:	e9 ad fa ff ff       	jmp    80105caa <alltraps>

801061fd <vector8>:
.globl vector8
vector8:
  pushl $8
801061fd:	6a 08                	push   $0x8
  jmp alltraps
801061ff:	e9 a6 fa ff ff       	jmp    80105caa <alltraps>

80106204 <vector9>:
.globl vector9
vector9:
  pushl $0
80106204:	6a 00                	push   $0x0
  pushl $9
80106206:	6a 09                	push   $0x9
  jmp alltraps
80106208:	e9 9d fa ff ff       	jmp    80105caa <alltraps>

8010620d <vector10>:
.globl vector10
vector10:
  pushl $10
8010620d:	6a 0a                	push   $0xa
  jmp alltraps
8010620f:	e9 96 fa ff ff       	jmp    80105caa <alltraps>

80106214 <vector11>:
.globl vector11
vector11:
  pushl $11
80106214:	6a 0b                	push   $0xb
  jmp alltraps
80106216:	e9 8f fa ff ff       	jmp    80105caa <alltraps>

8010621b <vector12>:
.globl vector12
vector12:
  pushl $12
8010621b:	6a 0c                	push   $0xc
  jmp alltraps
8010621d:	e9 88 fa ff ff       	jmp    80105caa <alltraps>

80106222 <vector13>:
.globl vector13
vector13:
  pushl $13
80106222:	6a 0d                	push   $0xd
  jmp alltraps
80106224:	e9 81 fa ff ff       	jmp    80105caa <alltraps>

80106229 <vector14>:
.globl vector14
vector14:
  pushl $14
80106229:	6a 0e                	push   $0xe
  jmp alltraps
8010622b:	e9 7a fa ff ff       	jmp    80105caa <alltraps>

80106230 <vector15>:
.globl vector15
vector15:
  pushl $0
80106230:	6a 00                	push   $0x0
  pushl $15
80106232:	6a 0f                	push   $0xf
  jmp alltraps
80106234:	e9 71 fa ff ff       	jmp    80105caa <alltraps>

80106239 <vector16>:
.globl vector16
vector16:
  pushl $0
80106239:	6a 00                	push   $0x0
  pushl $16
8010623b:	6a 10                	push   $0x10
  jmp alltraps
8010623d:	e9 68 fa ff ff       	jmp    80105caa <alltraps>

80106242 <vector17>:
.globl vector17
vector17:
  pushl $17
80106242:	6a 11                	push   $0x11
  jmp alltraps
80106244:	e9 61 fa ff ff       	jmp    80105caa <alltraps>

80106249 <vector18>:
.globl vector18
vector18:
  pushl $0
80106249:	6a 00                	push   $0x0
  pushl $18
8010624b:	6a 12                	push   $0x12
  jmp alltraps
8010624d:	e9 58 fa ff ff       	jmp    80105caa <alltraps>

80106252 <vector19>:
.globl vector19
vector19:
  pushl $0
80106252:	6a 00                	push   $0x0
  pushl $19
80106254:	6a 13                	push   $0x13
  jmp alltraps
80106256:	e9 4f fa ff ff       	jmp    80105caa <alltraps>

8010625b <vector20>:
.globl vector20
vector20:
  pushl $0
8010625b:	6a 00                	push   $0x0
  pushl $20
8010625d:	6a 14                	push   $0x14
  jmp alltraps
8010625f:	e9 46 fa ff ff       	jmp    80105caa <alltraps>

80106264 <vector21>:
.globl vector21
vector21:
  pushl $0
80106264:	6a 00                	push   $0x0
  pushl $21
80106266:	6a 15                	push   $0x15
  jmp alltraps
80106268:	e9 3d fa ff ff       	jmp    80105caa <alltraps>

8010626d <vector22>:
.globl vector22
vector22:
  pushl $0
8010626d:	6a 00                	push   $0x0
  pushl $22
8010626f:	6a 16                	push   $0x16
  jmp alltraps
80106271:	e9 34 fa ff ff       	jmp    80105caa <alltraps>

80106276 <vector23>:
.globl vector23
vector23:
  pushl $0
80106276:	6a 00                	push   $0x0
  pushl $23
80106278:	6a 17                	push   $0x17
  jmp alltraps
8010627a:	e9 2b fa ff ff       	jmp    80105caa <alltraps>

8010627f <vector24>:
.globl vector24
vector24:
  pushl $0
8010627f:	6a 00                	push   $0x0
  pushl $24
80106281:	6a 18                	push   $0x18
  jmp alltraps
80106283:	e9 22 fa ff ff       	jmp    80105caa <alltraps>

80106288 <vector25>:
.globl vector25
vector25:
  pushl $0
80106288:	6a 00                	push   $0x0
  pushl $25
8010628a:	6a 19                	push   $0x19
  jmp alltraps
8010628c:	e9 19 fa ff ff       	jmp    80105caa <alltraps>

80106291 <vector26>:
.globl vector26
vector26:
  pushl $0
80106291:	6a 00                	push   $0x0
  pushl $26
80106293:	6a 1a                	push   $0x1a
  jmp alltraps
80106295:	e9 10 fa ff ff       	jmp    80105caa <alltraps>

8010629a <vector27>:
.globl vector27
vector27:
  pushl $0
8010629a:	6a 00                	push   $0x0
  pushl $27
8010629c:	6a 1b                	push   $0x1b
  jmp alltraps
8010629e:	e9 07 fa ff ff       	jmp    80105caa <alltraps>

801062a3 <vector28>:
.globl vector28
vector28:
  pushl $0
801062a3:	6a 00                	push   $0x0
  pushl $28
801062a5:	6a 1c                	push   $0x1c
  jmp alltraps
801062a7:	e9 fe f9 ff ff       	jmp    80105caa <alltraps>

801062ac <vector29>:
.globl vector29
vector29:
  pushl $0
801062ac:	6a 00                	push   $0x0
  pushl $29
801062ae:	6a 1d                	push   $0x1d
  jmp alltraps
801062b0:	e9 f5 f9 ff ff       	jmp    80105caa <alltraps>

801062b5 <vector30>:
.globl vector30
vector30:
  pushl $0
801062b5:	6a 00                	push   $0x0
  pushl $30
801062b7:	6a 1e                	push   $0x1e
  jmp alltraps
801062b9:	e9 ec f9 ff ff       	jmp    80105caa <alltraps>

801062be <vector31>:
.globl vector31
vector31:
  pushl $0
801062be:	6a 00                	push   $0x0
  pushl $31
801062c0:	6a 1f                	push   $0x1f
  jmp alltraps
801062c2:	e9 e3 f9 ff ff       	jmp    80105caa <alltraps>

801062c7 <vector32>:
.globl vector32
vector32:
  pushl $0
801062c7:	6a 00                	push   $0x0
  pushl $32
801062c9:	6a 20                	push   $0x20
  jmp alltraps
801062cb:	e9 da f9 ff ff       	jmp    80105caa <alltraps>

801062d0 <vector33>:
.globl vector33
vector33:
  pushl $0
801062d0:	6a 00                	push   $0x0
  pushl $33
801062d2:	6a 21                	push   $0x21
  jmp alltraps
801062d4:	e9 d1 f9 ff ff       	jmp    80105caa <alltraps>

801062d9 <vector34>:
.globl vector34
vector34:
  pushl $0
801062d9:	6a 00                	push   $0x0
  pushl $34
801062db:	6a 22                	push   $0x22
  jmp alltraps
801062dd:	e9 c8 f9 ff ff       	jmp    80105caa <alltraps>

801062e2 <vector35>:
.globl vector35
vector35:
  pushl $0
801062e2:	6a 00                	push   $0x0
  pushl $35
801062e4:	6a 23                	push   $0x23
  jmp alltraps
801062e6:	e9 bf f9 ff ff       	jmp    80105caa <alltraps>

801062eb <vector36>:
.globl vector36
vector36:
  pushl $0
801062eb:	6a 00                	push   $0x0
  pushl $36
801062ed:	6a 24                	push   $0x24
  jmp alltraps
801062ef:	e9 b6 f9 ff ff       	jmp    80105caa <alltraps>

801062f4 <vector37>:
.globl vector37
vector37:
  pushl $0
801062f4:	6a 00                	push   $0x0
  pushl $37
801062f6:	6a 25                	push   $0x25
  jmp alltraps
801062f8:	e9 ad f9 ff ff       	jmp    80105caa <alltraps>

801062fd <vector38>:
.globl vector38
vector38:
  pushl $0
801062fd:	6a 00                	push   $0x0
  pushl $38
801062ff:	6a 26                	push   $0x26
  jmp alltraps
80106301:	e9 a4 f9 ff ff       	jmp    80105caa <alltraps>

80106306 <vector39>:
.globl vector39
vector39:
  pushl $0
80106306:	6a 00                	push   $0x0
  pushl $39
80106308:	6a 27                	push   $0x27
  jmp alltraps
8010630a:	e9 9b f9 ff ff       	jmp    80105caa <alltraps>

8010630f <vector40>:
.globl vector40
vector40:
  pushl $0
8010630f:	6a 00                	push   $0x0
  pushl $40
80106311:	6a 28                	push   $0x28
  jmp alltraps
80106313:	e9 92 f9 ff ff       	jmp    80105caa <alltraps>

80106318 <vector41>:
.globl vector41
vector41:
  pushl $0
80106318:	6a 00                	push   $0x0
  pushl $41
8010631a:	6a 29                	push   $0x29
  jmp alltraps
8010631c:	e9 89 f9 ff ff       	jmp    80105caa <alltraps>

80106321 <vector42>:
.globl vector42
vector42:
  pushl $0
80106321:	6a 00                	push   $0x0
  pushl $42
80106323:	6a 2a                	push   $0x2a
  jmp alltraps
80106325:	e9 80 f9 ff ff       	jmp    80105caa <alltraps>

8010632a <vector43>:
.globl vector43
vector43:
  pushl $0
8010632a:	6a 00                	push   $0x0
  pushl $43
8010632c:	6a 2b                	push   $0x2b
  jmp alltraps
8010632e:	e9 77 f9 ff ff       	jmp    80105caa <alltraps>

80106333 <vector44>:
.globl vector44
vector44:
  pushl $0
80106333:	6a 00                	push   $0x0
  pushl $44
80106335:	6a 2c                	push   $0x2c
  jmp alltraps
80106337:	e9 6e f9 ff ff       	jmp    80105caa <alltraps>

8010633c <vector45>:
.globl vector45
vector45:
  pushl $0
8010633c:	6a 00                	push   $0x0
  pushl $45
8010633e:	6a 2d                	push   $0x2d
  jmp alltraps
80106340:	e9 65 f9 ff ff       	jmp    80105caa <alltraps>

80106345 <vector46>:
.globl vector46
vector46:
  pushl $0
80106345:	6a 00                	push   $0x0
  pushl $46
80106347:	6a 2e                	push   $0x2e
  jmp alltraps
80106349:	e9 5c f9 ff ff       	jmp    80105caa <alltraps>

8010634e <vector47>:
.globl vector47
vector47:
  pushl $0
8010634e:	6a 00                	push   $0x0
  pushl $47
80106350:	6a 2f                	push   $0x2f
  jmp alltraps
80106352:	e9 53 f9 ff ff       	jmp    80105caa <alltraps>

80106357 <vector48>:
.globl vector48
vector48:
  pushl $0
80106357:	6a 00                	push   $0x0
  pushl $48
80106359:	6a 30                	push   $0x30
  jmp alltraps
8010635b:	e9 4a f9 ff ff       	jmp    80105caa <alltraps>

80106360 <vector49>:
.globl vector49
vector49:
  pushl $0
80106360:	6a 00                	push   $0x0
  pushl $49
80106362:	6a 31                	push   $0x31
  jmp alltraps
80106364:	e9 41 f9 ff ff       	jmp    80105caa <alltraps>

80106369 <vector50>:
.globl vector50
vector50:
  pushl $0
80106369:	6a 00                	push   $0x0
  pushl $50
8010636b:	6a 32                	push   $0x32
  jmp alltraps
8010636d:	e9 38 f9 ff ff       	jmp    80105caa <alltraps>

80106372 <vector51>:
.globl vector51
vector51:
  pushl $0
80106372:	6a 00                	push   $0x0
  pushl $51
80106374:	6a 33                	push   $0x33
  jmp alltraps
80106376:	e9 2f f9 ff ff       	jmp    80105caa <alltraps>

8010637b <vector52>:
.globl vector52
vector52:
  pushl $0
8010637b:	6a 00                	push   $0x0
  pushl $52
8010637d:	6a 34                	push   $0x34
  jmp alltraps
8010637f:	e9 26 f9 ff ff       	jmp    80105caa <alltraps>

80106384 <vector53>:
.globl vector53
vector53:
  pushl $0
80106384:	6a 00                	push   $0x0
  pushl $53
80106386:	6a 35                	push   $0x35
  jmp alltraps
80106388:	e9 1d f9 ff ff       	jmp    80105caa <alltraps>

8010638d <vector54>:
.globl vector54
vector54:
  pushl $0
8010638d:	6a 00                	push   $0x0
  pushl $54
8010638f:	6a 36                	push   $0x36
  jmp alltraps
80106391:	e9 14 f9 ff ff       	jmp    80105caa <alltraps>

80106396 <vector55>:
.globl vector55
vector55:
  pushl $0
80106396:	6a 00                	push   $0x0
  pushl $55
80106398:	6a 37                	push   $0x37
  jmp alltraps
8010639a:	e9 0b f9 ff ff       	jmp    80105caa <alltraps>

8010639f <vector56>:
.globl vector56
vector56:
  pushl $0
8010639f:	6a 00                	push   $0x0
  pushl $56
801063a1:	6a 38                	push   $0x38
  jmp alltraps
801063a3:	e9 02 f9 ff ff       	jmp    80105caa <alltraps>

801063a8 <vector57>:
.globl vector57
vector57:
  pushl $0
801063a8:	6a 00                	push   $0x0
  pushl $57
801063aa:	6a 39                	push   $0x39
  jmp alltraps
801063ac:	e9 f9 f8 ff ff       	jmp    80105caa <alltraps>

801063b1 <vector58>:
.globl vector58
vector58:
  pushl $0
801063b1:	6a 00                	push   $0x0
  pushl $58
801063b3:	6a 3a                	push   $0x3a
  jmp alltraps
801063b5:	e9 f0 f8 ff ff       	jmp    80105caa <alltraps>

801063ba <vector59>:
.globl vector59
vector59:
  pushl $0
801063ba:	6a 00                	push   $0x0
  pushl $59
801063bc:	6a 3b                	push   $0x3b
  jmp alltraps
801063be:	e9 e7 f8 ff ff       	jmp    80105caa <alltraps>

801063c3 <vector60>:
.globl vector60
vector60:
  pushl $0
801063c3:	6a 00                	push   $0x0
  pushl $60
801063c5:	6a 3c                	push   $0x3c
  jmp alltraps
801063c7:	e9 de f8 ff ff       	jmp    80105caa <alltraps>

801063cc <vector61>:
.globl vector61
vector61:
  pushl $0
801063cc:	6a 00                	push   $0x0
  pushl $61
801063ce:	6a 3d                	push   $0x3d
  jmp alltraps
801063d0:	e9 d5 f8 ff ff       	jmp    80105caa <alltraps>

801063d5 <vector62>:
.globl vector62
vector62:
  pushl $0
801063d5:	6a 00                	push   $0x0
  pushl $62
801063d7:	6a 3e                	push   $0x3e
  jmp alltraps
801063d9:	e9 cc f8 ff ff       	jmp    80105caa <alltraps>

801063de <vector63>:
.globl vector63
vector63:
  pushl $0
801063de:	6a 00                	push   $0x0
  pushl $63
801063e0:	6a 3f                	push   $0x3f
  jmp alltraps
801063e2:	e9 c3 f8 ff ff       	jmp    80105caa <alltraps>

801063e7 <vector64>:
.globl vector64
vector64:
  pushl $0
801063e7:	6a 00                	push   $0x0
  pushl $64
801063e9:	6a 40                	push   $0x40
  jmp alltraps
801063eb:	e9 ba f8 ff ff       	jmp    80105caa <alltraps>

801063f0 <vector65>:
.globl vector65
vector65:
  pushl $0
801063f0:	6a 00                	push   $0x0
  pushl $65
801063f2:	6a 41                	push   $0x41
  jmp alltraps
801063f4:	e9 b1 f8 ff ff       	jmp    80105caa <alltraps>

801063f9 <vector66>:
.globl vector66
vector66:
  pushl $0
801063f9:	6a 00                	push   $0x0
  pushl $66
801063fb:	6a 42                	push   $0x42
  jmp alltraps
801063fd:	e9 a8 f8 ff ff       	jmp    80105caa <alltraps>

80106402 <vector67>:
.globl vector67
vector67:
  pushl $0
80106402:	6a 00                	push   $0x0
  pushl $67
80106404:	6a 43                	push   $0x43
  jmp alltraps
80106406:	e9 9f f8 ff ff       	jmp    80105caa <alltraps>

8010640b <vector68>:
.globl vector68
vector68:
  pushl $0
8010640b:	6a 00                	push   $0x0
  pushl $68
8010640d:	6a 44                	push   $0x44
  jmp alltraps
8010640f:	e9 96 f8 ff ff       	jmp    80105caa <alltraps>

80106414 <vector69>:
.globl vector69
vector69:
  pushl $0
80106414:	6a 00                	push   $0x0
  pushl $69
80106416:	6a 45                	push   $0x45
  jmp alltraps
80106418:	e9 8d f8 ff ff       	jmp    80105caa <alltraps>

8010641d <vector70>:
.globl vector70
vector70:
  pushl $0
8010641d:	6a 00                	push   $0x0
  pushl $70
8010641f:	6a 46                	push   $0x46
  jmp alltraps
80106421:	e9 84 f8 ff ff       	jmp    80105caa <alltraps>

80106426 <vector71>:
.globl vector71
vector71:
  pushl $0
80106426:	6a 00                	push   $0x0
  pushl $71
80106428:	6a 47                	push   $0x47
  jmp alltraps
8010642a:	e9 7b f8 ff ff       	jmp    80105caa <alltraps>

8010642f <vector72>:
.globl vector72
vector72:
  pushl $0
8010642f:	6a 00                	push   $0x0
  pushl $72
80106431:	6a 48                	push   $0x48
  jmp alltraps
80106433:	e9 72 f8 ff ff       	jmp    80105caa <alltraps>

80106438 <vector73>:
.globl vector73
vector73:
  pushl $0
80106438:	6a 00                	push   $0x0
  pushl $73
8010643a:	6a 49                	push   $0x49
  jmp alltraps
8010643c:	e9 69 f8 ff ff       	jmp    80105caa <alltraps>

80106441 <vector74>:
.globl vector74
vector74:
  pushl $0
80106441:	6a 00                	push   $0x0
  pushl $74
80106443:	6a 4a                	push   $0x4a
  jmp alltraps
80106445:	e9 60 f8 ff ff       	jmp    80105caa <alltraps>

8010644a <vector75>:
.globl vector75
vector75:
  pushl $0
8010644a:	6a 00                	push   $0x0
  pushl $75
8010644c:	6a 4b                	push   $0x4b
  jmp alltraps
8010644e:	e9 57 f8 ff ff       	jmp    80105caa <alltraps>

80106453 <vector76>:
.globl vector76
vector76:
  pushl $0
80106453:	6a 00                	push   $0x0
  pushl $76
80106455:	6a 4c                	push   $0x4c
  jmp alltraps
80106457:	e9 4e f8 ff ff       	jmp    80105caa <alltraps>

8010645c <vector77>:
.globl vector77
vector77:
  pushl $0
8010645c:	6a 00                	push   $0x0
  pushl $77
8010645e:	6a 4d                	push   $0x4d
  jmp alltraps
80106460:	e9 45 f8 ff ff       	jmp    80105caa <alltraps>

80106465 <vector78>:
.globl vector78
vector78:
  pushl $0
80106465:	6a 00                	push   $0x0
  pushl $78
80106467:	6a 4e                	push   $0x4e
  jmp alltraps
80106469:	e9 3c f8 ff ff       	jmp    80105caa <alltraps>

8010646e <vector79>:
.globl vector79
vector79:
  pushl $0
8010646e:	6a 00                	push   $0x0
  pushl $79
80106470:	6a 4f                	push   $0x4f
  jmp alltraps
80106472:	e9 33 f8 ff ff       	jmp    80105caa <alltraps>

80106477 <vector80>:
.globl vector80
vector80:
  pushl $0
80106477:	6a 00                	push   $0x0
  pushl $80
80106479:	6a 50                	push   $0x50
  jmp alltraps
8010647b:	e9 2a f8 ff ff       	jmp    80105caa <alltraps>

80106480 <vector81>:
.globl vector81
vector81:
  pushl $0
80106480:	6a 00                	push   $0x0
  pushl $81
80106482:	6a 51                	push   $0x51
  jmp alltraps
80106484:	e9 21 f8 ff ff       	jmp    80105caa <alltraps>

80106489 <vector82>:
.globl vector82
vector82:
  pushl $0
80106489:	6a 00                	push   $0x0
  pushl $82
8010648b:	6a 52                	push   $0x52
  jmp alltraps
8010648d:	e9 18 f8 ff ff       	jmp    80105caa <alltraps>

80106492 <vector83>:
.globl vector83
vector83:
  pushl $0
80106492:	6a 00                	push   $0x0
  pushl $83
80106494:	6a 53                	push   $0x53
  jmp alltraps
80106496:	e9 0f f8 ff ff       	jmp    80105caa <alltraps>

8010649b <vector84>:
.globl vector84
vector84:
  pushl $0
8010649b:	6a 00                	push   $0x0
  pushl $84
8010649d:	6a 54                	push   $0x54
  jmp alltraps
8010649f:	e9 06 f8 ff ff       	jmp    80105caa <alltraps>

801064a4 <vector85>:
.globl vector85
vector85:
  pushl $0
801064a4:	6a 00                	push   $0x0
  pushl $85
801064a6:	6a 55                	push   $0x55
  jmp alltraps
801064a8:	e9 fd f7 ff ff       	jmp    80105caa <alltraps>

801064ad <vector86>:
.globl vector86
vector86:
  pushl $0
801064ad:	6a 00                	push   $0x0
  pushl $86
801064af:	6a 56                	push   $0x56
  jmp alltraps
801064b1:	e9 f4 f7 ff ff       	jmp    80105caa <alltraps>

801064b6 <vector87>:
.globl vector87
vector87:
  pushl $0
801064b6:	6a 00                	push   $0x0
  pushl $87
801064b8:	6a 57                	push   $0x57
  jmp alltraps
801064ba:	e9 eb f7 ff ff       	jmp    80105caa <alltraps>

801064bf <vector88>:
.globl vector88
vector88:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $88
801064c1:	6a 58                	push   $0x58
  jmp alltraps
801064c3:	e9 e2 f7 ff ff       	jmp    80105caa <alltraps>

801064c8 <vector89>:
.globl vector89
vector89:
  pushl $0
801064c8:	6a 00                	push   $0x0
  pushl $89
801064ca:	6a 59                	push   $0x59
  jmp alltraps
801064cc:	e9 d9 f7 ff ff       	jmp    80105caa <alltraps>

801064d1 <vector90>:
.globl vector90
vector90:
  pushl $0
801064d1:	6a 00                	push   $0x0
  pushl $90
801064d3:	6a 5a                	push   $0x5a
  jmp alltraps
801064d5:	e9 d0 f7 ff ff       	jmp    80105caa <alltraps>

801064da <vector91>:
.globl vector91
vector91:
  pushl $0
801064da:	6a 00                	push   $0x0
  pushl $91
801064dc:	6a 5b                	push   $0x5b
  jmp alltraps
801064de:	e9 c7 f7 ff ff       	jmp    80105caa <alltraps>

801064e3 <vector92>:
.globl vector92
vector92:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $92
801064e5:	6a 5c                	push   $0x5c
  jmp alltraps
801064e7:	e9 be f7 ff ff       	jmp    80105caa <alltraps>

801064ec <vector93>:
.globl vector93
vector93:
  pushl $0
801064ec:	6a 00                	push   $0x0
  pushl $93
801064ee:	6a 5d                	push   $0x5d
  jmp alltraps
801064f0:	e9 b5 f7 ff ff       	jmp    80105caa <alltraps>

801064f5 <vector94>:
.globl vector94
vector94:
  pushl $0
801064f5:	6a 00                	push   $0x0
  pushl $94
801064f7:	6a 5e                	push   $0x5e
  jmp alltraps
801064f9:	e9 ac f7 ff ff       	jmp    80105caa <alltraps>

801064fe <vector95>:
.globl vector95
vector95:
  pushl $0
801064fe:	6a 00                	push   $0x0
  pushl $95
80106500:	6a 5f                	push   $0x5f
  jmp alltraps
80106502:	e9 a3 f7 ff ff       	jmp    80105caa <alltraps>

80106507 <vector96>:
.globl vector96
vector96:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $96
80106509:	6a 60                	push   $0x60
  jmp alltraps
8010650b:	e9 9a f7 ff ff       	jmp    80105caa <alltraps>

80106510 <vector97>:
.globl vector97
vector97:
  pushl $0
80106510:	6a 00                	push   $0x0
  pushl $97
80106512:	6a 61                	push   $0x61
  jmp alltraps
80106514:	e9 91 f7 ff ff       	jmp    80105caa <alltraps>

80106519 <vector98>:
.globl vector98
vector98:
  pushl $0
80106519:	6a 00                	push   $0x0
  pushl $98
8010651b:	6a 62                	push   $0x62
  jmp alltraps
8010651d:	e9 88 f7 ff ff       	jmp    80105caa <alltraps>

80106522 <vector99>:
.globl vector99
vector99:
  pushl $0
80106522:	6a 00                	push   $0x0
  pushl $99
80106524:	6a 63                	push   $0x63
  jmp alltraps
80106526:	e9 7f f7 ff ff       	jmp    80105caa <alltraps>

8010652b <vector100>:
.globl vector100
vector100:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $100
8010652d:	6a 64                	push   $0x64
  jmp alltraps
8010652f:	e9 76 f7 ff ff       	jmp    80105caa <alltraps>

80106534 <vector101>:
.globl vector101
vector101:
  pushl $0
80106534:	6a 00                	push   $0x0
  pushl $101
80106536:	6a 65                	push   $0x65
  jmp alltraps
80106538:	e9 6d f7 ff ff       	jmp    80105caa <alltraps>

8010653d <vector102>:
.globl vector102
vector102:
  pushl $0
8010653d:	6a 00                	push   $0x0
  pushl $102
8010653f:	6a 66                	push   $0x66
  jmp alltraps
80106541:	e9 64 f7 ff ff       	jmp    80105caa <alltraps>

80106546 <vector103>:
.globl vector103
vector103:
  pushl $0
80106546:	6a 00                	push   $0x0
  pushl $103
80106548:	6a 67                	push   $0x67
  jmp alltraps
8010654a:	e9 5b f7 ff ff       	jmp    80105caa <alltraps>

8010654f <vector104>:
.globl vector104
vector104:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $104
80106551:	6a 68                	push   $0x68
  jmp alltraps
80106553:	e9 52 f7 ff ff       	jmp    80105caa <alltraps>

80106558 <vector105>:
.globl vector105
vector105:
  pushl $0
80106558:	6a 00                	push   $0x0
  pushl $105
8010655a:	6a 69                	push   $0x69
  jmp alltraps
8010655c:	e9 49 f7 ff ff       	jmp    80105caa <alltraps>

80106561 <vector106>:
.globl vector106
vector106:
  pushl $0
80106561:	6a 00                	push   $0x0
  pushl $106
80106563:	6a 6a                	push   $0x6a
  jmp alltraps
80106565:	e9 40 f7 ff ff       	jmp    80105caa <alltraps>

8010656a <vector107>:
.globl vector107
vector107:
  pushl $0
8010656a:	6a 00                	push   $0x0
  pushl $107
8010656c:	6a 6b                	push   $0x6b
  jmp alltraps
8010656e:	e9 37 f7 ff ff       	jmp    80105caa <alltraps>

80106573 <vector108>:
.globl vector108
vector108:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $108
80106575:	6a 6c                	push   $0x6c
  jmp alltraps
80106577:	e9 2e f7 ff ff       	jmp    80105caa <alltraps>

8010657c <vector109>:
.globl vector109
vector109:
  pushl $0
8010657c:	6a 00                	push   $0x0
  pushl $109
8010657e:	6a 6d                	push   $0x6d
  jmp alltraps
80106580:	e9 25 f7 ff ff       	jmp    80105caa <alltraps>

80106585 <vector110>:
.globl vector110
vector110:
  pushl $0
80106585:	6a 00                	push   $0x0
  pushl $110
80106587:	6a 6e                	push   $0x6e
  jmp alltraps
80106589:	e9 1c f7 ff ff       	jmp    80105caa <alltraps>

8010658e <vector111>:
.globl vector111
vector111:
  pushl $0
8010658e:	6a 00                	push   $0x0
  pushl $111
80106590:	6a 6f                	push   $0x6f
  jmp alltraps
80106592:	e9 13 f7 ff ff       	jmp    80105caa <alltraps>

80106597 <vector112>:
.globl vector112
vector112:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $112
80106599:	6a 70                	push   $0x70
  jmp alltraps
8010659b:	e9 0a f7 ff ff       	jmp    80105caa <alltraps>

801065a0 <vector113>:
.globl vector113
vector113:
  pushl $0
801065a0:	6a 00                	push   $0x0
  pushl $113
801065a2:	6a 71                	push   $0x71
  jmp alltraps
801065a4:	e9 01 f7 ff ff       	jmp    80105caa <alltraps>

801065a9 <vector114>:
.globl vector114
vector114:
  pushl $0
801065a9:	6a 00                	push   $0x0
  pushl $114
801065ab:	6a 72                	push   $0x72
  jmp alltraps
801065ad:	e9 f8 f6 ff ff       	jmp    80105caa <alltraps>

801065b2 <vector115>:
.globl vector115
vector115:
  pushl $0
801065b2:	6a 00                	push   $0x0
  pushl $115
801065b4:	6a 73                	push   $0x73
  jmp alltraps
801065b6:	e9 ef f6 ff ff       	jmp    80105caa <alltraps>

801065bb <vector116>:
.globl vector116
vector116:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $116
801065bd:	6a 74                	push   $0x74
  jmp alltraps
801065bf:	e9 e6 f6 ff ff       	jmp    80105caa <alltraps>

801065c4 <vector117>:
.globl vector117
vector117:
  pushl $0
801065c4:	6a 00                	push   $0x0
  pushl $117
801065c6:	6a 75                	push   $0x75
  jmp alltraps
801065c8:	e9 dd f6 ff ff       	jmp    80105caa <alltraps>

801065cd <vector118>:
.globl vector118
vector118:
  pushl $0
801065cd:	6a 00                	push   $0x0
  pushl $118
801065cf:	6a 76                	push   $0x76
  jmp alltraps
801065d1:	e9 d4 f6 ff ff       	jmp    80105caa <alltraps>

801065d6 <vector119>:
.globl vector119
vector119:
  pushl $0
801065d6:	6a 00                	push   $0x0
  pushl $119
801065d8:	6a 77                	push   $0x77
  jmp alltraps
801065da:	e9 cb f6 ff ff       	jmp    80105caa <alltraps>

801065df <vector120>:
.globl vector120
vector120:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $120
801065e1:	6a 78                	push   $0x78
  jmp alltraps
801065e3:	e9 c2 f6 ff ff       	jmp    80105caa <alltraps>

801065e8 <vector121>:
.globl vector121
vector121:
  pushl $0
801065e8:	6a 00                	push   $0x0
  pushl $121
801065ea:	6a 79                	push   $0x79
  jmp alltraps
801065ec:	e9 b9 f6 ff ff       	jmp    80105caa <alltraps>

801065f1 <vector122>:
.globl vector122
vector122:
  pushl $0
801065f1:	6a 00                	push   $0x0
  pushl $122
801065f3:	6a 7a                	push   $0x7a
  jmp alltraps
801065f5:	e9 b0 f6 ff ff       	jmp    80105caa <alltraps>

801065fa <vector123>:
.globl vector123
vector123:
  pushl $0
801065fa:	6a 00                	push   $0x0
  pushl $123
801065fc:	6a 7b                	push   $0x7b
  jmp alltraps
801065fe:	e9 a7 f6 ff ff       	jmp    80105caa <alltraps>

80106603 <vector124>:
.globl vector124
vector124:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $124
80106605:	6a 7c                	push   $0x7c
  jmp alltraps
80106607:	e9 9e f6 ff ff       	jmp    80105caa <alltraps>

8010660c <vector125>:
.globl vector125
vector125:
  pushl $0
8010660c:	6a 00                	push   $0x0
  pushl $125
8010660e:	6a 7d                	push   $0x7d
  jmp alltraps
80106610:	e9 95 f6 ff ff       	jmp    80105caa <alltraps>

80106615 <vector126>:
.globl vector126
vector126:
  pushl $0
80106615:	6a 00                	push   $0x0
  pushl $126
80106617:	6a 7e                	push   $0x7e
  jmp alltraps
80106619:	e9 8c f6 ff ff       	jmp    80105caa <alltraps>

8010661e <vector127>:
.globl vector127
vector127:
  pushl $0
8010661e:	6a 00                	push   $0x0
  pushl $127
80106620:	6a 7f                	push   $0x7f
  jmp alltraps
80106622:	e9 83 f6 ff ff       	jmp    80105caa <alltraps>

80106627 <vector128>:
.globl vector128
vector128:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $128
80106629:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010662e:	e9 77 f6 ff ff       	jmp    80105caa <alltraps>

80106633 <vector129>:
.globl vector129
vector129:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $129
80106635:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010663a:	e9 6b f6 ff ff       	jmp    80105caa <alltraps>

8010663f <vector130>:
.globl vector130
vector130:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $130
80106641:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106646:	e9 5f f6 ff ff       	jmp    80105caa <alltraps>

8010664b <vector131>:
.globl vector131
vector131:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $131
8010664d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106652:	e9 53 f6 ff ff       	jmp    80105caa <alltraps>

80106657 <vector132>:
.globl vector132
vector132:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $132
80106659:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010665e:	e9 47 f6 ff ff       	jmp    80105caa <alltraps>

80106663 <vector133>:
.globl vector133
vector133:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $133
80106665:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010666a:	e9 3b f6 ff ff       	jmp    80105caa <alltraps>

8010666f <vector134>:
.globl vector134
vector134:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $134
80106671:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106676:	e9 2f f6 ff ff       	jmp    80105caa <alltraps>

8010667b <vector135>:
.globl vector135
vector135:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $135
8010667d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106682:	e9 23 f6 ff ff       	jmp    80105caa <alltraps>

80106687 <vector136>:
.globl vector136
vector136:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $136
80106689:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010668e:	e9 17 f6 ff ff       	jmp    80105caa <alltraps>

80106693 <vector137>:
.globl vector137
vector137:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $137
80106695:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010669a:	e9 0b f6 ff ff       	jmp    80105caa <alltraps>

8010669f <vector138>:
.globl vector138
vector138:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $138
801066a1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801066a6:	e9 ff f5 ff ff       	jmp    80105caa <alltraps>

801066ab <vector139>:
.globl vector139
vector139:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $139
801066ad:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801066b2:	e9 f3 f5 ff ff       	jmp    80105caa <alltraps>

801066b7 <vector140>:
.globl vector140
vector140:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $140
801066b9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801066be:	e9 e7 f5 ff ff       	jmp    80105caa <alltraps>

801066c3 <vector141>:
.globl vector141
vector141:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $141
801066c5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801066ca:	e9 db f5 ff ff       	jmp    80105caa <alltraps>

801066cf <vector142>:
.globl vector142
vector142:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $142
801066d1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801066d6:	e9 cf f5 ff ff       	jmp    80105caa <alltraps>

801066db <vector143>:
.globl vector143
vector143:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $143
801066dd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801066e2:	e9 c3 f5 ff ff       	jmp    80105caa <alltraps>

801066e7 <vector144>:
.globl vector144
vector144:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $144
801066e9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801066ee:	e9 b7 f5 ff ff       	jmp    80105caa <alltraps>

801066f3 <vector145>:
.globl vector145
vector145:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $145
801066f5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801066fa:	e9 ab f5 ff ff       	jmp    80105caa <alltraps>

801066ff <vector146>:
.globl vector146
vector146:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $146
80106701:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106706:	e9 9f f5 ff ff       	jmp    80105caa <alltraps>

8010670b <vector147>:
.globl vector147
vector147:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $147
8010670d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106712:	e9 93 f5 ff ff       	jmp    80105caa <alltraps>

80106717 <vector148>:
.globl vector148
vector148:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $148
80106719:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010671e:	e9 87 f5 ff ff       	jmp    80105caa <alltraps>

80106723 <vector149>:
.globl vector149
vector149:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $149
80106725:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010672a:	e9 7b f5 ff ff       	jmp    80105caa <alltraps>

8010672f <vector150>:
.globl vector150
vector150:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $150
80106731:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106736:	e9 6f f5 ff ff       	jmp    80105caa <alltraps>

8010673b <vector151>:
.globl vector151
vector151:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $151
8010673d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106742:	e9 63 f5 ff ff       	jmp    80105caa <alltraps>

80106747 <vector152>:
.globl vector152
vector152:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $152
80106749:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010674e:	e9 57 f5 ff ff       	jmp    80105caa <alltraps>

80106753 <vector153>:
.globl vector153
vector153:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $153
80106755:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010675a:	e9 4b f5 ff ff       	jmp    80105caa <alltraps>

8010675f <vector154>:
.globl vector154
vector154:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $154
80106761:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106766:	e9 3f f5 ff ff       	jmp    80105caa <alltraps>

8010676b <vector155>:
.globl vector155
vector155:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $155
8010676d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106772:	e9 33 f5 ff ff       	jmp    80105caa <alltraps>

80106777 <vector156>:
.globl vector156
vector156:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $156
80106779:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010677e:	e9 27 f5 ff ff       	jmp    80105caa <alltraps>

80106783 <vector157>:
.globl vector157
vector157:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $157
80106785:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010678a:	e9 1b f5 ff ff       	jmp    80105caa <alltraps>

8010678f <vector158>:
.globl vector158
vector158:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $158
80106791:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106796:	e9 0f f5 ff ff       	jmp    80105caa <alltraps>

8010679b <vector159>:
.globl vector159
vector159:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $159
8010679d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801067a2:	e9 03 f5 ff ff       	jmp    80105caa <alltraps>

801067a7 <vector160>:
.globl vector160
vector160:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $160
801067a9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801067ae:	e9 f7 f4 ff ff       	jmp    80105caa <alltraps>

801067b3 <vector161>:
.globl vector161
vector161:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $161
801067b5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801067ba:	e9 eb f4 ff ff       	jmp    80105caa <alltraps>

801067bf <vector162>:
.globl vector162
vector162:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $162
801067c1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801067c6:	e9 df f4 ff ff       	jmp    80105caa <alltraps>

801067cb <vector163>:
.globl vector163
vector163:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $163
801067cd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801067d2:	e9 d3 f4 ff ff       	jmp    80105caa <alltraps>

801067d7 <vector164>:
.globl vector164
vector164:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $164
801067d9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801067de:	e9 c7 f4 ff ff       	jmp    80105caa <alltraps>

801067e3 <vector165>:
.globl vector165
vector165:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $165
801067e5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801067ea:	e9 bb f4 ff ff       	jmp    80105caa <alltraps>

801067ef <vector166>:
.globl vector166
vector166:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $166
801067f1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801067f6:	e9 af f4 ff ff       	jmp    80105caa <alltraps>

801067fb <vector167>:
.globl vector167
vector167:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $167
801067fd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106802:	e9 a3 f4 ff ff       	jmp    80105caa <alltraps>

80106807 <vector168>:
.globl vector168
vector168:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $168
80106809:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010680e:	e9 97 f4 ff ff       	jmp    80105caa <alltraps>

80106813 <vector169>:
.globl vector169
vector169:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $169
80106815:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010681a:	e9 8b f4 ff ff       	jmp    80105caa <alltraps>

8010681f <vector170>:
.globl vector170
vector170:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $170
80106821:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106826:	e9 7f f4 ff ff       	jmp    80105caa <alltraps>

8010682b <vector171>:
.globl vector171
vector171:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $171
8010682d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106832:	e9 73 f4 ff ff       	jmp    80105caa <alltraps>

80106837 <vector172>:
.globl vector172
vector172:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $172
80106839:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010683e:	e9 67 f4 ff ff       	jmp    80105caa <alltraps>

80106843 <vector173>:
.globl vector173
vector173:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $173
80106845:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010684a:	e9 5b f4 ff ff       	jmp    80105caa <alltraps>

8010684f <vector174>:
.globl vector174
vector174:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $174
80106851:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106856:	e9 4f f4 ff ff       	jmp    80105caa <alltraps>

8010685b <vector175>:
.globl vector175
vector175:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $175
8010685d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106862:	e9 43 f4 ff ff       	jmp    80105caa <alltraps>

80106867 <vector176>:
.globl vector176
vector176:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $176
80106869:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010686e:	e9 37 f4 ff ff       	jmp    80105caa <alltraps>

80106873 <vector177>:
.globl vector177
vector177:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $177
80106875:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010687a:	e9 2b f4 ff ff       	jmp    80105caa <alltraps>

8010687f <vector178>:
.globl vector178
vector178:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $178
80106881:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106886:	e9 1f f4 ff ff       	jmp    80105caa <alltraps>

8010688b <vector179>:
.globl vector179
vector179:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $179
8010688d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106892:	e9 13 f4 ff ff       	jmp    80105caa <alltraps>

80106897 <vector180>:
.globl vector180
vector180:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $180
80106899:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010689e:	e9 07 f4 ff ff       	jmp    80105caa <alltraps>

801068a3 <vector181>:
.globl vector181
vector181:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $181
801068a5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801068aa:	e9 fb f3 ff ff       	jmp    80105caa <alltraps>

801068af <vector182>:
.globl vector182
vector182:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $182
801068b1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801068b6:	e9 ef f3 ff ff       	jmp    80105caa <alltraps>

801068bb <vector183>:
.globl vector183
vector183:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $183
801068bd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801068c2:	e9 e3 f3 ff ff       	jmp    80105caa <alltraps>

801068c7 <vector184>:
.globl vector184
vector184:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $184
801068c9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801068ce:	e9 d7 f3 ff ff       	jmp    80105caa <alltraps>

801068d3 <vector185>:
.globl vector185
vector185:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $185
801068d5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801068da:	e9 cb f3 ff ff       	jmp    80105caa <alltraps>

801068df <vector186>:
.globl vector186
vector186:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $186
801068e1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801068e6:	e9 bf f3 ff ff       	jmp    80105caa <alltraps>

801068eb <vector187>:
.globl vector187
vector187:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $187
801068ed:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801068f2:	e9 b3 f3 ff ff       	jmp    80105caa <alltraps>

801068f7 <vector188>:
.globl vector188
vector188:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $188
801068f9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801068fe:	e9 a7 f3 ff ff       	jmp    80105caa <alltraps>

80106903 <vector189>:
.globl vector189
vector189:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $189
80106905:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010690a:	e9 9b f3 ff ff       	jmp    80105caa <alltraps>

8010690f <vector190>:
.globl vector190
vector190:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $190
80106911:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106916:	e9 8f f3 ff ff       	jmp    80105caa <alltraps>

8010691b <vector191>:
.globl vector191
vector191:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $191
8010691d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106922:	e9 83 f3 ff ff       	jmp    80105caa <alltraps>

80106927 <vector192>:
.globl vector192
vector192:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $192
80106929:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010692e:	e9 77 f3 ff ff       	jmp    80105caa <alltraps>

80106933 <vector193>:
.globl vector193
vector193:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $193
80106935:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010693a:	e9 6b f3 ff ff       	jmp    80105caa <alltraps>

8010693f <vector194>:
.globl vector194
vector194:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $194
80106941:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106946:	e9 5f f3 ff ff       	jmp    80105caa <alltraps>

8010694b <vector195>:
.globl vector195
vector195:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $195
8010694d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106952:	e9 53 f3 ff ff       	jmp    80105caa <alltraps>

80106957 <vector196>:
.globl vector196
vector196:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $196
80106959:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010695e:	e9 47 f3 ff ff       	jmp    80105caa <alltraps>

80106963 <vector197>:
.globl vector197
vector197:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $197
80106965:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010696a:	e9 3b f3 ff ff       	jmp    80105caa <alltraps>

8010696f <vector198>:
.globl vector198
vector198:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $198
80106971:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106976:	e9 2f f3 ff ff       	jmp    80105caa <alltraps>

8010697b <vector199>:
.globl vector199
vector199:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $199
8010697d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106982:	e9 23 f3 ff ff       	jmp    80105caa <alltraps>

80106987 <vector200>:
.globl vector200
vector200:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $200
80106989:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010698e:	e9 17 f3 ff ff       	jmp    80105caa <alltraps>

80106993 <vector201>:
.globl vector201
vector201:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $201
80106995:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010699a:	e9 0b f3 ff ff       	jmp    80105caa <alltraps>

8010699f <vector202>:
.globl vector202
vector202:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $202
801069a1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801069a6:	e9 ff f2 ff ff       	jmp    80105caa <alltraps>

801069ab <vector203>:
.globl vector203
vector203:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $203
801069ad:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801069b2:	e9 f3 f2 ff ff       	jmp    80105caa <alltraps>

801069b7 <vector204>:
.globl vector204
vector204:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $204
801069b9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801069be:	e9 e7 f2 ff ff       	jmp    80105caa <alltraps>

801069c3 <vector205>:
.globl vector205
vector205:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $205
801069c5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801069ca:	e9 db f2 ff ff       	jmp    80105caa <alltraps>

801069cf <vector206>:
.globl vector206
vector206:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $206
801069d1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801069d6:	e9 cf f2 ff ff       	jmp    80105caa <alltraps>

801069db <vector207>:
.globl vector207
vector207:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $207
801069dd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801069e2:	e9 c3 f2 ff ff       	jmp    80105caa <alltraps>

801069e7 <vector208>:
.globl vector208
vector208:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $208
801069e9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801069ee:	e9 b7 f2 ff ff       	jmp    80105caa <alltraps>

801069f3 <vector209>:
.globl vector209
vector209:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $209
801069f5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801069fa:	e9 ab f2 ff ff       	jmp    80105caa <alltraps>

801069ff <vector210>:
.globl vector210
vector210:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $210
80106a01:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106a06:	e9 9f f2 ff ff       	jmp    80105caa <alltraps>

80106a0b <vector211>:
.globl vector211
vector211:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $211
80106a0d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106a12:	e9 93 f2 ff ff       	jmp    80105caa <alltraps>

80106a17 <vector212>:
.globl vector212
vector212:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $212
80106a19:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106a1e:	e9 87 f2 ff ff       	jmp    80105caa <alltraps>

80106a23 <vector213>:
.globl vector213
vector213:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $213
80106a25:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106a2a:	e9 7b f2 ff ff       	jmp    80105caa <alltraps>

80106a2f <vector214>:
.globl vector214
vector214:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $214
80106a31:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106a36:	e9 6f f2 ff ff       	jmp    80105caa <alltraps>

80106a3b <vector215>:
.globl vector215
vector215:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $215
80106a3d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106a42:	e9 63 f2 ff ff       	jmp    80105caa <alltraps>

80106a47 <vector216>:
.globl vector216
vector216:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $216
80106a49:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106a4e:	e9 57 f2 ff ff       	jmp    80105caa <alltraps>

80106a53 <vector217>:
.globl vector217
vector217:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $217
80106a55:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106a5a:	e9 4b f2 ff ff       	jmp    80105caa <alltraps>

80106a5f <vector218>:
.globl vector218
vector218:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $218
80106a61:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106a66:	e9 3f f2 ff ff       	jmp    80105caa <alltraps>

80106a6b <vector219>:
.globl vector219
vector219:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $219
80106a6d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106a72:	e9 33 f2 ff ff       	jmp    80105caa <alltraps>

80106a77 <vector220>:
.globl vector220
vector220:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $220
80106a79:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106a7e:	e9 27 f2 ff ff       	jmp    80105caa <alltraps>

80106a83 <vector221>:
.globl vector221
vector221:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $221
80106a85:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106a8a:	e9 1b f2 ff ff       	jmp    80105caa <alltraps>

80106a8f <vector222>:
.globl vector222
vector222:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $222
80106a91:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106a96:	e9 0f f2 ff ff       	jmp    80105caa <alltraps>

80106a9b <vector223>:
.globl vector223
vector223:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $223
80106a9d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106aa2:	e9 03 f2 ff ff       	jmp    80105caa <alltraps>

80106aa7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $224
80106aa9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106aae:	e9 f7 f1 ff ff       	jmp    80105caa <alltraps>

80106ab3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $225
80106ab5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106aba:	e9 eb f1 ff ff       	jmp    80105caa <alltraps>

80106abf <vector226>:
.globl vector226
vector226:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $226
80106ac1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106ac6:	e9 df f1 ff ff       	jmp    80105caa <alltraps>

80106acb <vector227>:
.globl vector227
vector227:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $227
80106acd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106ad2:	e9 d3 f1 ff ff       	jmp    80105caa <alltraps>

80106ad7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $228
80106ad9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106ade:	e9 c7 f1 ff ff       	jmp    80105caa <alltraps>

80106ae3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $229
80106ae5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106aea:	e9 bb f1 ff ff       	jmp    80105caa <alltraps>

80106aef <vector230>:
.globl vector230
vector230:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $230
80106af1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106af6:	e9 af f1 ff ff       	jmp    80105caa <alltraps>

80106afb <vector231>:
.globl vector231
vector231:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $231
80106afd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106b02:	e9 a3 f1 ff ff       	jmp    80105caa <alltraps>

80106b07 <vector232>:
.globl vector232
vector232:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $232
80106b09:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106b0e:	e9 97 f1 ff ff       	jmp    80105caa <alltraps>

80106b13 <vector233>:
.globl vector233
vector233:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $233
80106b15:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106b1a:	e9 8b f1 ff ff       	jmp    80105caa <alltraps>

80106b1f <vector234>:
.globl vector234
vector234:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $234
80106b21:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106b26:	e9 7f f1 ff ff       	jmp    80105caa <alltraps>

80106b2b <vector235>:
.globl vector235
vector235:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $235
80106b2d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106b32:	e9 73 f1 ff ff       	jmp    80105caa <alltraps>

80106b37 <vector236>:
.globl vector236
vector236:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $236
80106b39:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106b3e:	e9 67 f1 ff ff       	jmp    80105caa <alltraps>

80106b43 <vector237>:
.globl vector237
vector237:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $237
80106b45:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106b4a:	e9 5b f1 ff ff       	jmp    80105caa <alltraps>

80106b4f <vector238>:
.globl vector238
vector238:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $238
80106b51:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106b56:	e9 4f f1 ff ff       	jmp    80105caa <alltraps>

80106b5b <vector239>:
.globl vector239
vector239:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $239
80106b5d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106b62:	e9 43 f1 ff ff       	jmp    80105caa <alltraps>

80106b67 <vector240>:
.globl vector240
vector240:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $240
80106b69:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106b6e:	e9 37 f1 ff ff       	jmp    80105caa <alltraps>

80106b73 <vector241>:
.globl vector241
vector241:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $241
80106b75:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106b7a:	e9 2b f1 ff ff       	jmp    80105caa <alltraps>

80106b7f <vector242>:
.globl vector242
vector242:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $242
80106b81:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106b86:	e9 1f f1 ff ff       	jmp    80105caa <alltraps>

80106b8b <vector243>:
.globl vector243
vector243:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $243
80106b8d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106b92:	e9 13 f1 ff ff       	jmp    80105caa <alltraps>

80106b97 <vector244>:
.globl vector244
vector244:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $244
80106b99:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106b9e:	e9 07 f1 ff ff       	jmp    80105caa <alltraps>

80106ba3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $245
80106ba5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106baa:	e9 fb f0 ff ff       	jmp    80105caa <alltraps>

80106baf <vector246>:
.globl vector246
vector246:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $246
80106bb1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106bb6:	e9 ef f0 ff ff       	jmp    80105caa <alltraps>

80106bbb <vector247>:
.globl vector247
vector247:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $247
80106bbd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106bc2:	e9 e3 f0 ff ff       	jmp    80105caa <alltraps>

80106bc7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $248
80106bc9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106bce:	e9 d7 f0 ff ff       	jmp    80105caa <alltraps>

80106bd3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $249
80106bd5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106bda:	e9 cb f0 ff ff       	jmp    80105caa <alltraps>

80106bdf <vector250>:
.globl vector250
vector250:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $250
80106be1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106be6:	e9 bf f0 ff ff       	jmp    80105caa <alltraps>

80106beb <vector251>:
.globl vector251
vector251:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $251
80106bed:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106bf2:	e9 b3 f0 ff ff       	jmp    80105caa <alltraps>

80106bf7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $252
80106bf9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106bfe:	e9 a7 f0 ff ff       	jmp    80105caa <alltraps>

80106c03 <vector253>:
.globl vector253
vector253:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $253
80106c05:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106c0a:	e9 9b f0 ff ff       	jmp    80105caa <alltraps>

80106c0f <vector254>:
.globl vector254
vector254:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $254
80106c11:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106c16:	e9 8f f0 ff ff       	jmp    80105caa <alltraps>

80106c1b <vector255>:
.globl vector255
vector255:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $255
80106c1d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106c22:	e9 83 f0 ff ff       	jmp    80105caa <alltraps>
80106c27:	66 90                	xchg   %ax,%ax
80106c29:	66 90                	xchg   %ax,%ax
80106c2b:	66 90                	xchg   %ax,%ax
80106c2d:	66 90                	xchg   %ax,%ax
80106c2f:	90                   	nop

80106c30 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c30:	55                   	push   %ebp
80106c31:	89 e5                	mov    %esp,%ebp
80106c33:	57                   	push   %edi
80106c34:	56                   	push   %esi
80106c35:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106c36:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106c3c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c42:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80106c45:	39 d3                	cmp    %edx,%ebx
80106c47:	73 56                	jae    80106c9f <deallocuvm.part.0+0x6f>
80106c49:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106c4c:	89 c6                	mov    %eax,%esi
80106c4e:	89 d7                	mov    %edx,%edi
80106c50:	eb 12                	jmp    80106c64 <deallocuvm.part.0+0x34>
80106c52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106c58:	83 c2 01             	add    $0x1,%edx
80106c5b:	89 d3                	mov    %edx,%ebx
80106c5d:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106c60:	39 fb                	cmp    %edi,%ebx
80106c62:	73 38                	jae    80106c9c <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
80106c64:	89 da                	mov    %ebx,%edx
80106c66:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106c69:	8b 04 96             	mov    (%esi,%edx,4),%eax
80106c6c:	a8 01                	test   $0x1,%al
80106c6e:	74 e8                	je     80106c58 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
80106c70:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106c72:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106c77:	c1 e9 0a             	shr    $0xa,%ecx
80106c7a:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106c80:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80106c87:	85 c0                	test   %eax,%eax
80106c89:	74 cd                	je     80106c58 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
80106c8b:	8b 10                	mov    (%eax),%edx
80106c8d:	f6 c2 01             	test   $0x1,%dl
80106c90:	75 1e                	jne    80106cb0 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
80106c92:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c98:	39 fb                	cmp    %edi,%ebx
80106c9a:	72 c8                	jb     80106c64 <deallocuvm.part.0+0x34>
80106c9c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106c9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ca2:	89 c8                	mov    %ecx,%eax
80106ca4:	5b                   	pop    %ebx
80106ca5:	5e                   	pop    %esi
80106ca6:	5f                   	pop    %edi
80106ca7:	5d                   	pop    %ebp
80106ca8:	c3                   	ret
80106ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80106cb0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106cb6:	74 26                	je     80106cde <deallocuvm.part.0+0xae>
      kfree(v);
80106cb8:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106cbb:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106cc1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106cc4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106cca:	52                   	push   %edx
80106ccb:	e8 40 b8 ff ff       	call   80102510 <kfree>
      *pte = 0;
80106cd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
80106cd3:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80106cd6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106cdc:	eb 82                	jmp    80106c60 <deallocuvm.part.0+0x30>
        panic("kfree");
80106cde:	83 ec 0c             	sub    $0xc,%esp
80106ce1:	68 e6 77 10 80       	push   $0x801077e6
80106ce6:	e8 95 96 ff ff       	call   80100380 <panic>
80106ceb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106cf0 <mappages>:
{
80106cf0:	55                   	push   %ebp
80106cf1:	89 e5                	mov    %esp,%ebp
80106cf3:	57                   	push   %edi
80106cf4:	56                   	push   %esi
80106cf5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106cf6:	89 d3                	mov    %edx,%ebx
80106cf8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106cfe:	83 ec 1c             	sub    $0x1c,%esp
80106d01:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106d04:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106d08:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d0d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106d10:	8b 45 08             	mov    0x8(%ebp),%eax
80106d13:	29 d8                	sub    %ebx,%eax
80106d15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d18:	eb 3f                	jmp    80106d59 <mappages+0x69>
80106d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106d20:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106d22:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106d27:	c1 ea 0a             	shr    $0xa,%edx
80106d2a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106d30:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106d37:	85 c0                	test   %eax,%eax
80106d39:	74 75                	je     80106db0 <mappages+0xc0>
    if(*pte & PTE_P)
80106d3b:	f6 00 01             	testb  $0x1,(%eax)
80106d3e:	0f 85 86 00 00 00    	jne    80106dca <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106d44:	0b 75 0c             	or     0xc(%ebp),%esi
80106d47:	83 ce 01             	or     $0x1,%esi
80106d4a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106d4c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106d4f:	39 c3                	cmp    %eax,%ebx
80106d51:	74 6d                	je     80106dc0 <mappages+0xd0>
    a += PGSIZE;
80106d53:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106d59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106d5c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106d5f:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80106d62:	89 d8                	mov    %ebx,%eax
80106d64:	c1 e8 16             	shr    $0x16,%eax
80106d67:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106d6a:	8b 07                	mov    (%edi),%eax
80106d6c:	a8 01                	test   $0x1,%al
80106d6e:	75 b0                	jne    80106d20 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106d70:	e8 5b b9 ff ff       	call   801026d0 <kalloc>
80106d75:	85 c0                	test   %eax,%eax
80106d77:	74 37                	je     80106db0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106d79:	83 ec 04             	sub    $0x4,%esp
80106d7c:	68 00 10 00 00       	push   $0x1000
80106d81:	6a 00                	push   $0x0
80106d83:	50                   	push   %eax
80106d84:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106d87:	e8 94 da ff ff       	call   80104820 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106d8c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106d8f:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106d92:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106d98:	83 c8 07             	or     $0x7,%eax
80106d9b:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106d9d:	89 d8                	mov    %ebx,%eax
80106d9f:	c1 e8 0a             	shr    $0xa,%eax
80106da2:	25 fc 0f 00 00       	and    $0xffc,%eax
80106da7:	01 d0                	add    %edx,%eax
80106da9:	eb 90                	jmp    80106d3b <mappages+0x4b>
80106dab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80106db0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106db3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106db8:	5b                   	pop    %ebx
80106db9:	5e                   	pop    %esi
80106dba:	5f                   	pop    %edi
80106dbb:	5d                   	pop    %ebp
80106dbc:	c3                   	ret
80106dbd:	8d 76 00             	lea    0x0(%esi),%esi
80106dc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106dc3:	31 c0                	xor    %eax,%eax
}
80106dc5:	5b                   	pop    %ebx
80106dc6:	5e                   	pop    %esi
80106dc7:	5f                   	pop    %edi
80106dc8:	5d                   	pop    %ebp
80106dc9:	c3                   	ret
      panic("remap");
80106dca:	83 ec 0c             	sub    $0xc,%esp
80106dcd:	68 98 7a 10 80       	push   $0x80107a98
80106dd2:	e8 a9 95 ff ff       	call   80100380 <panic>
80106dd7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106dde:	00 
80106ddf:	90                   	nop

80106de0 <seginit>:
{
80106de0:	55                   	push   %ebp
80106de1:	89 e5                	mov    %esp,%ebp
80106de3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106de6:	e8 d5 cb ff ff       	call   801039c0 <cpuid>
  pd[0] = size-1;
80106deb:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106df0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106df6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
80106dfa:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80106e01:	ff 00 00 
80106e04:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
80106e0b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106e0e:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80106e15:	ff 00 00 
80106e18:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
80106e1f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106e22:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
80106e29:	ff 00 00 
80106e2c:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
80106e33:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106e36:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
80106e3d:	ff 00 00 
80106e40:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
80106e47:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106e4a:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
80106e4f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106e53:	c1 e8 10             	shr    $0x10,%eax
80106e56:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106e5a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106e5d:	0f 01 10             	lgdtl  (%eax)
}
80106e60:	c9                   	leave
80106e61:	c3                   	ret
80106e62:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106e69:	00 
80106e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e70 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106e70:	a1 c4 82 11 80       	mov    0x801182c4,%eax
80106e75:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106e7a:	0f 22 d8             	mov    %eax,%cr3
}
80106e7d:	c3                   	ret
80106e7e:	66 90                	xchg   %ax,%ax

80106e80 <switchuvm>:
{
80106e80:	55                   	push   %ebp
80106e81:	89 e5                	mov    %esp,%ebp
80106e83:	57                   	push   %edi
80106e84:	56                   	push   %esi
80106e85:	53                   	push   %ebx
80106e86:	83 ec 1c             	sub    $0x1c,%esp
80106e89:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106e8c:	85 f6                	test   %esi,%esi
80106e8e:	0f 84 cb 00 00 00    	je     80106f5f <switchuvm+0xdf>
  if(p->kstack == 0)
80106e94:	8b 46 68             	mov    0x68(%esi),%eax
80106e97:	85 c0                	test   %eax,%eax
80106e99:	0f 84 da 00 00 00    	je     80106f79 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106e9f:	8b 46 64             	mov    0x64(%esi),%eax
80106ea2:	85 c0                	test   %eax,%eax
80106ea4:	0f 84 c2 00 00 00    	je     80106f6c <switchuvm+0xec>
  pushcli();
80106eaa:	e8 21 d7 ff ff       	call   801045d0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106eaf:	e8 ac ca ff ff       	call   80103960 <mycpu>
80106eb4:	89 c3                	mov    %eax,%ebx
80106eb6:	e8 a5 ca ff ff       	call   80103960 <mycpu>
80106ebb:	89 c7                	mov    %eax,%edi
80106ebd:	e8 9e ca ff ff       	call   80103960 <mycpu>
80106ec2:	83 c7 08             	add    $0x8,%edi
80106ec5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ec8:	e8 93 ca ff ff       	call   80103960 <mycpu>
80106ecd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106ed0:	ba 67 00 00 00       	mov    $0x67,%edx
80106ed5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106edc:	83 c0 08             	add    $0x8,%eax
80106edf:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106ee6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106eeb:	83 c1 08             	add    $0x8,%ecx
80106eee:	c1 e8 18             	shr    $0x18,%eax
80106ef1:	c1 e9 10             	shr    $0x10,%ecx
80106ef4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106efa:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106f00:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106f05:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f0c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106f11:	e8 4a ca ff ff       	call   80103960 <mycpu>
80106f16:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f1d:	e8 3e ca ff ff       	call   80103960 <mycpu>
80106f22:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106f26:	8b 5e 68             	mov    0x68(%esi),%ebx
80106f29:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f2f:	e8 2c ca ff ff       	call   80103960 <mycpu>
80106f34:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f37:	e8 24 ca ff ff       	call   80103960 <mycpu>
80106f3c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106f40:	b8 28 00 00 00       	mov    $0x28,%eax
80106f45:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106f48:	8b 46 64             	mov    0x64(%esi),%eax
80106f4b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f50:	0f 22 d8             	mov    %eax,%cr3
}
80106f53:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f56:	5b                   	pop    %ebx
80106f57:	5e                   	pop    %esi
80106f58:	5f                   	pop    %edi
80106f59:	5d                   	pop    %ebp
  popcli();
80106f5a:	e9 c1 d6 ff ff       	jmp    80104620 <popcli>
    panic("switchuvm: no process");
80106f5f:	83 ec 0c             	sub    $0xc,%esp
80106f62:	68 9e 7a 10 80       	push   $0x80107a9e
80106f67:	e8 14 94 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106f6c:	83 ec 0c             	sub    $0xc,%esp
80106f6f:	68 c9 7a 10 80       	push   $0x80107ac9
80106f74:	e8 07 94 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106f79:	83 ec 0c             	sub    $0xc,%esp
80106f7c:	68 b4 7a 10 80       	push   $0x80107ab4
80106f81:	e8 fa 93 ff ff       	call   80100380 <panic>
80106f86:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f8d:	00 
80106f8e:	66 90                	xchg   %ax,%ax

80106f90 <inituvm>:
{
80106f90:	55                   	push   %ebp
80106f91:	89 e5                	mov    %esp,%ebp
80106f93:	57                   	push   %edi
80106f94:	56                   	push   %esi
80106f95:	53                   	push   %ebx
80106f96:	83 ec 1c             	sub    $0x1c,%esp
80106f99:	8b 45 08             	mov    0x8(%ebp),%eax
80106f9c:	8b 75 10             	mov    0x10(%ebp),%esi
80106f9f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106fa2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106fa5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106fab:	77 49                	ja     80106ff6 <inituvm+0x66>
  mem = kalloc();
80106fad:	e8 1e b7 ff ff       	call   801026d0 <kalloc>
  memset(mem, 0, PGSIZE);
80106fb2:	83 ec 04             	sub    $0x4,%esp
80106fb5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106fba:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106fbc:	6a 00                	push   $0x0
80106fbe:	50                   	push   %eax
80106fbf:	e8 5c d8 ff ff       	call   80104820 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106fc4:	58                   	pop    %eax
80106fc5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106fcb:	5a                   	pop    %edx
80106fcc:	6a 06                	push   $0x6
80106fce:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106fd3:	31 d2                	xor    %edx,%edx
80106fd5:	50                   	push   %eax
80106fd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106fd9:	e8 12 fd ff ff       	call   80106cf0 <mappages>
  memmove(mem, init, sz);
80106fde:	83 c4 10             	add    $0x10,%esp
80106fe1:	89 75 10             	mov    %esi,0x10(%ebp)
80106fe4:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106fe7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106fea:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fed:	5b                   	pop    %ebx
80106fee:	5e                   	pop    %esi
80106fef:	5f                   	pop    %edi
80106ff0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106ff1:	e9 ba d8 ff ff       	jmp    801048b0 <memmove>
    panic("inituvm: more than a page");
80106ff6:	83 ec 0c             	sub    $0xc,%esp
80106ff9:	68 dd 7a 10 80       	push   $0x80107add
80106ffe:	e8 7d 93 ff ff       	call   80100380 <panic>
80107003:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010700a:	00 
8010700b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80107010 <loaduvm>:
{
80107010:	55                   	push   %ebp
80107011:	89 e5                	mov    %esp,%ebp
80107013:	57                   	push   %edi
80107014:	56                   	push   %esi
80107015:	53                   	push   %ebx
80107016:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107019:	8b 75 0c             	mov    0xc(%ebp),%esi
{
8010701c:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
8010701f:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80107025:	0f 85 a2 00 00 00    	jne    801070cd <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
8010702b:	85 ff                	test   %edi,%edi
8010702d:	74 7d                	je     801070ac <loaduvm+0x9c>
8010702f:	90                   	nop
  pde = &pgdir[PDX(va)];
80107030:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107033:	8b 55 08             	mov    0x8(%ebp),%edx
80107036:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80107038:	89 c1                	mov    %eax,%ecx
8010703a:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010703d:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
80107040:	f6 c1 01             	test   $0x1,%cl
80107043:	75 13                	jne    80107058 <loaduvm+0x48>
      panic("loaduvm: address should exist");
80107045:	83 ec 0c             	sub    $0xc,%esp
80107048:	68 f7 7a 10 80       	push   $0x80107af7
8010704d:	e8 2e 93 ff ff       	call   80100380 <panic>
80107052:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107058:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010705b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107061:	25 fc 0f 00 00       	and    $0xffc,%eax
80107066:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010706d:	85 c9                	test   %ecx,%ecx
8010706f:	74 d4                	je     80107045 <loaduvm+0x35>
    if(sz - i < PGSIZE)
80107071:	89 fb                	mov    %edi,%ebx
80107073:	b8 00 10 00 00       	mov    $0x1000,%eax
80107078:	29 f3                	sub    %esi,%ebx
8010707a:	39 c3                	cmp    %eax,%ebx
8010707c:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010707f:	53                   	push   %ebx
80107080:	8b 45 14             	mov    0x14(%ebp),%eax
80107083:	01 f0                	add    %esi,%eax
80107085:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
80107086:	8b 01                	mov    (%ecx),%eax
80107088:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010708d:	05 00 00 00 80       	add    $0x80000000,%eax
80107092:	50                   	push   %eax
80107093:	ff 75 10             	push   0x10(%ebp)
80107096:	e8 75 aa ff ff       	call   80101b10 <readi>
8010709b:	83 c4 10             	add    $0x10,%esp
8010709e:	39 d8                	cmp    %ebx,%eax
801070a0:	75 1e                	jne    801070c0 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
801070a2:	81 c6 00 10 00 00    	add    $0x1000,%esi
801070a8:	39 fe                	cmp    %edi,%esi
801070aa:	72 84                	jb     80107030 <loaduvm+0x20>
}
801070ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801070af:	31 c0                	xor    %eax,%eax
}
801070b1:	5b                   	pop    %ebx
801070b2:	5e                   	pop    %esi
801070b3:	5f                   	pop    %edi
801070b4:	5d                   	pop    %ebp
801070b5:	c3                   	ret
801070b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801070bd:	00 
801070be:	66 90                	xchg   %ax,%ax
801070c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801070c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801070c8:	5b                   	pop    %ebx
801070c9:	5e                   	pop    %esi
801070ca:	5f                   	pop    %edi
801070cb:	5d                   	pop    %ebp
801070cc:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
801070cd:	83 ec 0c             	sub    $0xc,%esp
801070d0:	68 18 7d 10 80       	push   $0x80107d18
801070d5:	e8 a6 92 ff ff       	call   80100380 <panic>
801070da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801070e0 <allocuvm>:
{
801070e0:	55                   	push   %ebp
801070e1:	89 e5                	mov    %esp,%ebp
801070e3:	57                   	push   %edi
801070e4:	56                   	push   %esi
801070e5:	53                   	push   %ebx
801070e6:	83 ec 1c             	sub    $0x1c,%esp
801070e9:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
801070ec:	85 f6                	test   %esi,%esi
801070ee:	0f 88 98 00 00 00    	js     8010718c <allocuvm+0xac>
801070f4:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
801070f6:	3b 75 0c             	cmp    0xc(%ebp),%esi
801070f9:	0f 82 a1 00 00 00    	jb     801071a0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801070ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80107102:	05 ff 0f 00 00       	add    $0xfff,%eax
80107107:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010710c:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
8010710e:	39 f0                	cmp    %esi,%eax
80107110:	0f 83 8d 00 00 00    	jae    801071a3 <allocuvm+0xc3>
80107116:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80107119:	eb 44                	jmp    8010715f <allocuvm+0x7f>
8010711b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107120:	83 ec 04             	sub    $0x4,%esp
80107123:	68 00 10 00 00       	push   $0x1000
80107128:	6a 00                	push   $0x0
8010712a:	50                   	push   %eax
8010712b:	e8 f0 d6 ff ff       	call   80104820 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107130:	58                   	pop    %eax
80107131:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107137:	5a                   	pop    %edx
80107138:	6a 06                	push   $0x6
8010713a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010713f:	89 fa                	mov    %edi,%edx
80107141:	50                   	push   %eax
80107142:	8b 45 08             	mov    0x8(%ebp),%eax
80107145:	e8 a6 fb ff ff       	call   80106cf0 <mappages>
8010714a:	83 c4 10             	add    $0x10,%esp
8010714d:	85 c0                	test   %eax,%eax
8010714f:	78 5f                	js     801071b0 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
80107151:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107157:	39 f7                	cmp    %esi,%edi
80107159:	0f 83 89 00 00 00    	jae    801071e8 <allocuvm+0x108>
    mem = kalloc();
8010715f:	e8 6c b5 ff ff       	call   801026d0 <kalloc>
80107164:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107166:	85 c0                	test   %eax,%eax
80107168:	75 b6                	jne    80107120 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010716a:	83 ec 0c             	sub    $0xc,%esp
8010716d:	68 15 7b 10 80       	push   $0x80107b15
80107172:	e8 39 95 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107177:	83 c4 10             	add    $0x10,%esp
8010717a:	3b 75 0c             	cmp    0xc(%ebp),%esi
8010717d:	74 0d                	je     8010718c <allocuvm+0xac>
8010717f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107182:	8b 45 08             	mov    0x8(%ebp),%eax
80107185:	89 f2                	mov    %esi,%edx
80107187:	e8 a4 fa ff ff       	call   80106c30 <deallocuvm.part.0>
    return 0;
8010718c:	31 d2                	xor    %edx,%edx
}
8010718e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107191:	89 d0                	mov    %edx,%eax
80107193:	5b                   	pop    %ebx
80107194:	5e                   	pop    %esi
80107195:	5f                   	pop    %edi
80107196:	5d                   	pop    %ebp
80107197:	c3                   	ret
80107198:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010719f:	00 
    return oldsz;
801071a0:	8b 55 0c             	mov    0xc(%ebp),%edx
}
801071a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071a6:	89 d0                	mov    %edx,%eax
801071a8:	5b                   	pop    %ebx
801071a9:	5e                   	pop    %esi
801071aa:	5f                   	pop    %edi
801071ab:	5d                   	pop    %ebp
801071ac:	c3                   	ret
801071ad:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801071b0:	83 ec 0c             	sub    $0xc,%esp
801071b3:	68 2d 7b 10 80       	push   $0x80107b2d
801071b8:	e8 f3 94 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
801071bd:	83 c4 10             	add    $0x10,%esp
801071c0:	3b 75 0c             	cmp    0xc(%ebp),%esi
801071c3:	74 0d                	je     801071d2 <allocuvm+0xf2>
801071c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801071c8:	8b 45 08             	mov    0x8(%ebp),%eax
801071cb:	89 f2                	mov    %esi,%edx
801071cd:	e8 5e fa ff ff       	call   80106c30 <deallocuvm.part.0>
      kfree(mem);
801071d2:	83 ec 0c             	sub    $0xc,%esp
801071d5:	53                   	push   %ebx
801071d6:	e8 35 b3 ff ff       	call   80102510 <kfree>
      return 0;
801071db:	83 c4 10             	add    $0x10,%esp
    return 0;
801071de:	31 d2                	xor    %edx,%edx
801071e0:	eb ac                	jmp    8010718e <allocuvm+0xae>
801071e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
801071eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071ee:	5b                   	pop    %ebx
801071ef:	5e                   	pop    %esi
801071f0:	89 d0                	mov    %edx,%eax
801071f2:	5f                   	pop    %edi
801071f3:	5d                   	pop    %ebp
801071f4:	c3                   	ret
801071f5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801071fc:	00 
801071fd:	8d 76 00             	lea    0x0(%esi),%esi

80107200 <deallocuvm>:
{
80107200:	55                   	push   %ebp
80107201:	89 e5                	mov    %esp,%ebp
80107203:	8b 55 0c             	mov    0xc(%ebp),%edx
80107206:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107209:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010720c:	39 d1                	cmp    %edx,%ecx
8010720e:	73 10                	jae    80107220 <deallocuvm+0x20>
}
80107210:	5d                   	pop    %ebp
80107211:	e9 1a fa ff ff       	jmp    80106c30 <deallocuvm.part.0>
80107216:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010721d:	00 
8010721e:	66 90                	xchg   %ax,%ax
80107220:	89 d0                	mov    %edx,%eax
80107222:	5d                   	pop    %ebp
80107223:	c3                   	ret
80107224:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010722b:	00 
8010722c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107230 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107230:	55                   	push   %ebp
80107231:	89 e5                	mov    %esp,%ebp
80107233:	57                   	push   %edi
80107234:	56                   	push   %esi
80107235:	53                   	push   %ebx
80107236:	83 ec 0c             	sub    $0xc,%esp
80107239:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010723c:	85 f6                	test   %esi,%esi
8010723e:	74 59                	je     80107299 <freevm+0x69>
  if(newsz >= oldsz)
80107240:	31 c9                	xor    %ecx,%ecx
80107242:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107247:	89 f0                	mov    %esi,%eax
80107249:	89 f3                	mov    %esi,%ebx
8010724b:	e8 e0 f9 ff ff       	call   80106c30 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107250:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107256:	eb 0f                	jmp    80107267 <freevm+0x37>
80107258:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010725f:	00 
80107260:	83 c3 04             	add    $0x4,%ebx
80107263:	39 fb                	cmp    %edi,%ebx
80107265:	74 23                	je     8010728a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107267:	8b 03                	mov    (%ebx),%eax
80107269:	a8 01                	test   $0x1,%al
8010726b:	74 f3                	je     80107260 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010726d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107272:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107275:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107278:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010727d:	50                   	push   %eax
8010727e:	e8 8d b2 ff ff       	call   80102510 <kfree>
80107283:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107286:	39 fb                	cmp    %edi,%ebx
80107288:	75 dd                	jne    80107267 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010728a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010728d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107290:	5b                   	pop    %ebx
80107291:	5e                   	pop    %esi
80107292:	5f                   	pop    %edi
80107293:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107294:	e9 77 b2 ff ff       	jmp    80102510 <kfree>
    panic("freevm: no pgdir");
80107299:	83 ec 0c             	sub    $0xc,%esp
8010729c:	68 49 7b 10 80       	push   $0x80107b49
801072a1:	e8 da 90 ff ff       	call   80100380 <panic>
801072a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801072ad:	00 
801072ae:	66 90                	xchg   %ax,%ax

801072b0 <setupkvm>:
{
801072b0:	55                   	push   %ebp
801072b1:	89 e5                	mov    %esp,%ebp
801072b3:	56                   	push   %esi
801072b4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801072b5:	e8 16 b4 ff ff       	call   801026d0 <kalloc>
801072ba:	85 c0                	test   %eax,%eax
801072bc:	74 5e                	je     8010731c <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
801072be:	83 ec 04             	sub    $0x4,%esp
801072c1:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801072c3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801072c8:	68 00 10 00 00       	push   $0x1000
801072cd:	6a 00                	push   $0x0
801072cf:	50                   	push   %eax
801072d0:	e8 4b d5 ff ff       	call   80104820 <memset>
801072d5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801072d8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801072db:	83 ec 08             	sub    $0x8,%esp
801072de:	8b 4b 08             	mov    0x8(%ebx),%ecx
801072e1:	8b 13                	mov    (%ebx),%edx
801072e3:	ff 73 0c             	push   0xc(%ebx)
801072e6:	50                   	push   %eax
801072e7:	29 c1                	sub    %eax,%ecx
801072e9:	89 f0                	mov    %esi,%eax
801072eb:	e8 00 fa ff ff       	call   80106cf0 <mappages>
801072f0:	83 c4 10             	add    $0x10,%esp
801072f3:	85 c0                	test   %eax,%eax
801072f5:	78 19                	js     80107310 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801072f7:	83 c3 10             	add    $0x10,%ebx
801072fa:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107300:	75 d6                	jne    801072d8 <setupkvm+0x28>
}
80107302:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107305:	89 f0                	mov    %esi,%eax
80107307:	5b                   	pop    %ebx
80107308:	5e                   	pop    %esi
80107309:	5d                   	pop    %ebp
8010730a:	c3                   	ret
8010730b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107310:	83 ec 0c             	sub    $0xc,%esp
80107313:	56                   	push   %esi
80107314:	e8 17 ff ff ff       	call   80107230 <freevm>
      return 0;
80107319:	83 c4 10             	add    $0x10,%esp
}
8010731c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
8010731f:	31 f6                	xor    %esi,%esi
}
80107321:	89 f0                	mov    %esi,%eax
80107323:	5b                   	pop    %ebx
80107324:	5e                   	pop    %esi
80107325:	5d                   	pop    %ebp
80107326:	c3                   	ret
80107327:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010732e:	00 
8010732f:	90                   	nop

80107330 <kvmalloc>:
{
80107330:	55                   	push   %ebp
80107331:	89 e5                	mov    %esp,%ebp
80107333:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107336:	e8 75 ff ff ff       	call   801072b0 <setupkvm>
8010733b:	a3 c4 82 11 80       	mov    %eax,0x801182c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107340:	05 00 00 00 80       	add    $0x80000000,%eax
80107345:	0f 22 d8             	mov    %eax,%cr3
}
80107348:	c9                   	leave
80107349:	c3                   	ret
8010734a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107350 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107350:	55                   	push   %ebp
80107351:	89 e5                	mov    %esp,%ebp
80107353:	83 ec 08             	sub    $0x8,%esp
80107356:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107359:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010735c:	89 c1                	mov    %eax,%ecx
8010735e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107361:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107364:	f6 c2 01             	test   $0x1,%dl
80107367:	75 17                	jne    80107380 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107369:	83 ec 0c             	sub    $0xc,%esp
8010736c:	68 5a 7b 10 80       	push   $0x80107b5a
80107371:	e8 0a 90 ff ff       	call   80100380 <panic>
80107376:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010737d:	00 
8010737e:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
80107380:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107383:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107389:	25 fc 0f 00 00       	and    $0xffc,%eax
8010738e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107395:	85 c0                	test   %eax,%eax
80107397:	74 d0                	je     80107369 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107399:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010739c:	c9                   	leave
8010739d:	c3                   	ret
8010739e:	66 90                	xchg   %ax,%ax

801073a0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801073a0:	55                   	push   %ebp
801073a1:	89 e5                	mov    %esp,%ebp
801073a3:	57                   	push   %edi
801073a4:	56                   	push   %esi
801073a5:	53                   	push   %ebx
801073a6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801073a9:	e8 02 ff ff ff       	call   801072b0 <setupkvm>
801073ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
801073b1:	85 c0                	test   %eax,%eax
801073b3:	0f 84 e9 00 00 00    	je     801074a2 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801073b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801073bc:	85 c9                	test   %ecx,%ecx
801073be:	0f 84 b2 00 00 00    	je     80107476 <copyuvm+0xd6>
801073c4:	31 f6                	xor    %esi,%esi
801073c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801073cd:	00 
801073ce:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
801073d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801073d3:	89 f0                	mov    %esi,%eax
801073d5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801073d8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801073db:	a8 01                	test   $0x1,%al
801073dd:	75 11                	jne    801073f0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801073df:	83 ec 0c             	sub    $0xc,%esp
801073e2:	68 64 7b 10 80       	push   $0x80107b64
801073e7:	e8 94 8f ff ff       	call   80100380 <panic>
801073ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801073f0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801073f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801073f7:	c1 ea 0a             	shr    $0xa,%edx
801073fa:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107400:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107407:	85 c0                	test   %eax,%eax
80107409:	74 d4                	je     801073df <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010740b:	8b 00                	mov    (%eax),%eax
8010740d:	a8 01                	test   $0x1,%al
8010740f:	0f 84 9f 00 00 00    	je     801074b4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107415:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107417:	25 ff 0f 00 00       	and    $0xfff,%eax
8010741c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010741f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107425:	e8 a6 b2 ff ff       	call   801026d0 <kalloc>
8010742a:	89 c3                	mov    %eax,%ebx
8010742c:	85 c0                	test   %eax,%eax
8010742e:	74 64                	je     80107494 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107430:	83 ec 04             	sub    $0x4,%esp
80107433:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107439:	68 00 10 00 00       	push   $0x1000
8010743e:	57                   	push   %edi
8010743f:	50                   	push   %eax
80107440:	e8 6b d4 ff ff       	call   801048b0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107445:	58                   	pop    %eax
80107446:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010744c:	5a                   	pop    %edx
8010744d:	ff 75 e4             	push   -0x1c(%ebp)
80107450:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107455:	89 f2                	mov    %esi,%edx
80107457:	50                   	push   %eax
80107458:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010745b:	e8 90 f8 ff ff       	call   80106cf0 <mappages>
80107460:	83 c4 10             	add    $0x10,%esp
80107463:	85 c0                	test   %eax,%eax
80107465:	78 21                	js     80107488 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107467:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010746d:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107470:	0f 82 5a ff ff ff    	jb     801073d0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107476:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107479:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010747c:	5b                   	pop    %ebx
8010747d:	5e                   	pop    %esi
8010747e:	5f                   	pop    %edi
8010747f:	5d                   	pop    %ebp
80107480:	c3                   	ret
80107481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107488:	83 ec 0c             	sub    $0xc,%esp
8010748b:	53                   	push   %ebx
8010748c:	e8 7f b0 ff ff       	call   80102510 <kfree>
      goto bad;
80107491:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107494:	83 ec 0c             	sub    $0xc,%esp
80107497:	ff 75 e0             	push   -0x20(%ebp)
8010749a:	e8 91 fd ff ff       	call   80107230 <freevm>
  return 0;
8010749f:	83 c4 10             	add    $0x10,%esp
    return 0;
801074a2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801074a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801074ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074af:	5b                   	pop    %ebx
801074b0:	5e                   	pop    %esi
801074b1:	5f                   	pop    %edi
801074b2:	5d                   	pop    %ebp
801074b3:	c3                   	ret
      panic("copyuvm: page not present");
801074b4:	83 ec 0c             	sub    $0xc,%esp
801074b7:	68 7e 7b 10 80       	push   $0x80107b7e
801074bc:	e8 bf 8e ff ff       	call   80100380 <panic>
801074c1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801074c8:	00 
801074c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801074d0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801074d0:	55                   	push   %ebp
801074d1:	89 e5                	mov    %esp,%ebp
801074d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801074d6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801074d9:	89 c1                	mov    %eax,%ecx
801074db:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801074de:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801074e1:	f6 c2 01             	test   $0x1,%dl
801074e4:	0f 84 f8 00 00 00    	je     801075e2 <uva2ka.cold>
  return &pgtab[PTX(va)];
801074ea:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801074ed:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801074f3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801074f4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801074f9:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107500:	89 d0                	mov    %edx,%eax
80107502:	f7 d2                	not    %edx
80107504:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107509:	05 00 00 00 80       	add    $0x80000000,%eax
8010750e:	83 e2 05             	and    $0x5,%edx
80107511:	ba 00 00 00 00       	mov    $0x0,%edx
80107516:	0f 45 c2             	cmovne %edx,%eax
}
80107519:	c3                   	ret
8010751a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107520 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107520:	55                   	push   %ebp
80107521:	89 e5                	mov    %esp,%ebp
80107523:	57                   	push   %edi
80107524:	56                   	push   %esi
80107525:	53                   	push   %ebx
80107526:	83 ec 0c             	sub    $0xc,%esp
80107529:	8b 75 14             	mov    0x14(%ebp),%esi
8010752c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010752f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107532:	85 f6                	test   %esi,%esi
80107534:	75 51                	jne    80107587 <copyout+0x67>
80107536:	e9 9d 00 00 00       	jmp    801075d8 <copyout+0xb8>
8010753b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
80107540:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107546:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010754c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107552:	74 74                	je     801075c8 <copyout+0xa8>
      return -1;
    n = PGSIZE - (va - va0);
80107554:	89 fb                	mov    %edi,%ebx
80107556:	29 c3                	sub    %eax,%ebx
80107558:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010755e:	39 f3                	cmp    %esi,%ebx
80107560:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107563:	29 f8                	sub    %edi,%eax
80107565:	83 ec 04             	sub    $0x4,%esp
80107568:	01 c1                	add    %eax,%ecx
8010756a:	53                   	push   %ebx
8010756b:	52                   	push   %edx
8010756c:	89 55 10             	mov    %edx,0x10(%ebp)
8010756f:	51                   	push   %ecx
80107570:	e8 3b d3 ff ff       	call   801048b0 <memmove>
    len -= n;
    buf += n;
80107575:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107578:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010757e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107581:	01 da                	add    %ebx,%edx
  while(len > 0){
80107583:	29 de                	sub    %ebx,%esi
80107585:	74 51                	je     801075d8 <copyout+0xb8>
  if(*pde & PTE_P){
80107587:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010758a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010758c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010758e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107591:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107597:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010759a:	f6 c1 01             	test   $0x1,%cl
8010759d:	0f 84 46 00 00 00    	je     801075e9 <copyout.cold>
  return &pgtab[PTX(va)];
801075a3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801075a5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801075ab:	c1 eb 0c             	shr    $0xc,%ebx
801075ae:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801075b4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801075bb:	89 d9                	mov    %ebx,%ecx
801075bd:	f7 d1                	not    %ecx
801075bf:	83 e1 05             	and    $0x5,%ecx
801075c2:	0f 84 78 ff ff ff    	je     80107540 <copyout+0x20>
  }
  return 0;
}
801075c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801075cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801075d0:	5b                   	pop    %ebx
801075d1:	5e                   	pop    %esi
801075d2:	5f                   	pop    %edi
801075d3:	5d                   	pop    %ebp
801075d4:	c3                   	ret
801075d5:	8d 76 00             	lea    0x0(%esi),%esi
801075d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801075db:	31 c0                	xor    %eax,%eax
}
801075dd:	5b                   	pop    %ebx
801075de:	5e                   	pop    %esi
801075df:	5f                   	pop    %edi
801075e0:	5d                   	pop    %ebp
801075e1:	c3                   	ret

801075e2 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801075e2:	a1 00 00 00 00       	mov    0x0,%eax
801075e7:	0f 0b                	ud2

801075e9 <copyout.cold>:
801075e9:	a1 00 00 00 00       	mov    0x0,%eax
801075ee:	0f 0b                	ud2
