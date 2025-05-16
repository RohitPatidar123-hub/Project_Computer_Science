
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:



int
main(void)
{
       0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
       4:	83 e4 f0             	and    $0xfffffff0,%esp
       7:	ff 71 fc             	push   -0x4(%ecx)
       a:	55                   	push   %ebp
       b:	89 e5                	mov    %esp,%ebp
       d:	53                   	push   %ebx
       e:	51                   	push   %ecx
       f:	83 ec 30             	sub    $0x30,%esp
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
      12:	eb 0d                	jmp    21 <main+0x21>
      14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(fd >= 3){
      18:	83 f8 02             	cmp    $0x2,%eax
      1b:	0f 8f fe 02 00 00    	jg     31f <main+0x31f>
  while((fd = open("console", O_RDWR)) >= 0){
      21:	83 ec 08             	sub    $0x8,%esp
      24:	6a 02                	push   $0x2
      26:	68 a3 16 00 00       	push   $0x16a3
      2b:	e8 93 11 00 00       	call   11c3 <open>
      30:	83 c4 10             	add    $0x10,%esp
      33:	85 c0                	test   %eax,%eax
      35:	79 e1                	jns    18 <main+0x18>
      37:	eb 42                	jmp    7b <main+0x7b>
      39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(chdir(buf+3) < 0)
        printf(2, "cannot cd %s\n", buf+3);
      continue;
    }
 
      if(buf[0] == 'h' && buf[1] == 'i' && buf[2] == 's' && buf[3] == 't'  && buf[4] == 'o'  && buf[5] == 'r' && buf[6] == 'y')
      40:	3c 68                	cmp    $0x68,%al
      42:	0f 84 b0 01 00 00    	je     1f8 <main+0x1f8>



     // Check for "block" command.
    // if(strncmp(buf, "block ", 6) == 0){
    if(buf[0] == 'b' && buf[1] == 'l' && buf[2] == 'o' && buf[3] == 'c'  && buf[4] == 'k')
      48:	3c 62                	cmp    $0x62,%al
      4a:	0f 85 00 01 00 00    	jne    150 <main+0x150>
      50:	80 3d 21 1e 00 00 6c 	cmpb   $0x6c,0x1e21
      57:	0f 84 4b 02 00 00    	je     2a8 <main+0x2a8>
      5d:	8d 76 00             	lea    0x0(%esi),%esi
int
fork1(void)
{
  int pid;

  pid = fork();
      60:	e8 16 11 00 00       	call   117b <fork>
  if(pid == -1)
      65:	83 f8 ff             	cmp    $0xffffffff,%eax
      68:	0f 84 56 03 00 00    	je     3c4 <main+0x3c4>
    if(fork1() == 0)
      6e:	85 c0                	test   %eax,%eax
      70:	0f 84 ba 02 00 00    	je     330 <main+0x330>
    wait();
      76:	e8 10 11 00 00       	call   118b <wait>
  printf(2, "$ ");
      7b:	83 ec 08             	sub    $0x8,%esp
      7e:	68 f8 15 00 00       	push   $0x15f8
      83:	6a 02                	push   $0x2
      85:	e8 66 12 00 00       	call   12f0 <printf>
  memset(buf, 0, nbuf);
      8a:	83 c4 0c             	add    $0xc,%esp
      8d:	6a 64                	push   $0x64
      8f:	6a 00                	push   $0x0
      91:	68 20 1e 00 00       	push   $0x1e20
      96:	e8 65 0f 00 00       	call   1000 <memset>
  gets(buf, nbuf);
      9b:	58                   	pop    %eax
      9c:	5a                   	pop    %edx
      9d:	6a 64                	push   $0x64
      9f:	68 20 1e 00 00       	push   $0x1e20
      a4:	e8 b7 0f 00 00       	call   1060 <gets>
  if(buf[0] == 0) // EOF
      a9:	0f b6 05 20 1e 00 00 	movzbl 0x1e20,%eax
      b0:	83 c4 10             	add    $0x10,%esp
      b3:	84 c0                	test   %al,%al
      b5:	0f 84 5f 02 00 00    	je     31a <main+0x31a>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      bb:	3c 63                	cmp    $0x63,%al
      bd:	75 81                	jne    40 <main+0x40>
      bf:	0f b6 05 21 1e 00 00 	movzbl 0x1e21,%eax
      c6:	3c 64                	cmp    $0x64,%al
      c8:	0f 84 82 01 00 00    	je     250 <main+0x250>
if(buf[0]=='c' && buf[1]=='h' && buf[2]=='m' && buf[3]=='o' && buf[4]=='d'){
      ce:	3c 68                	cmp    $0x68,%al
      d0:	75 8e                	jne    60 <main+0x60>
      d2:	80 3d 22 1e 00 00 6d 	cmpb   $0x6d,0x1e22
      d9:	75 85                	jne    60 <main+0x60>
      db:	80 3d 23 1e 00 00 6f 	cmpb   $0x6f,0x1e23
      e2:	0f 85 78 ff ff ff    	jne    60 <main+0x60>
      e8:	80 3d 24 1e 00 00 64 	cmpb   $0x64,0x1e24
      ef:	0f 85 6b ff ff ff    	jne    60 <main+0x60>
  char *p = buf;
      f5:	b8 20 1e 00 00       	mov    $0x1e20,%eax
  int argc = 0;
      fa:	31 c9                	xor    %ecx,%ecx
  while(*p != '\0'){
      fc:	0f b6 10             	movzbl (%eax),%edx
      ff:	84 d2                	test   %dl,%dl
     101:	0f 84 3e 02 00 00    	je     345 <main+0x345>
    while(*p == ' ')
     107:	80 fa 20             	cmp    $0x20,%dl
     10a:	0f 85 56 02 00 00    	jne    366 <main+0x366>
     110:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p++;
     114:	83 c0 01             	add    $0x1,%eax
    while(*p == ' ')
     117:	80 fa 20             	cmp    $0x20,%dl
     11a:	74 f4                	je     110 <main+0x110>
    if(*p == '\0')
     11c:	84 d2                	test   %dl,%dl
     11e:	0f 84 21 02 00 00    	je     345 <main+0x345>
    argv[argc++] = p;
     124:	83 c1 01             	add    $0x1,%ecx
     127:	89 44 8d cc          	mov    %eax,-0x34(%ebp,%ecx,4)
    while(*p != ' ' && *p != '\0')
     12b:	f6 c2 df             	test   $0xdf,%dl
     12e:	74 0c                	je     13c <main+0x13c>
     130:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p++;
     134:	83 c0 01             	add    $0x1,%eax
    while(*p != ' ' && *p != '\0')
     137:	f6 c2 df             	test   $0xdf,%dl
     13a:	75 f4                	jne    130 <main+0x130>
    if(*p != '\0')
     13c:	84 d2                	test   %dl,%dl
     13e:	74 bc                	je     fc <main+0xfc>
      *p++ = '\0';
     140:	c6 00 00             	movb   $0x0,(%eax)
     143:	83 c0 01             	add    $0x1,%eax
     146:	eb b4                	jmp    fc <main+0xfc>
     148:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     14f:	00 
   if(buf[0] == 'u' && buf[1] == 'n' && buf[2] == 'b' && buf[3] == 'l'  && buf[4] == 'o'  && buf[5] == 'c' && buf[6] == 'k')
     150:	3c 75                	cmp    $0x75,%al
     152:	0f 85 08 ff ff ff    	jne    60 <main+0x60>
     158:	80 3d 21 1e 00 00 6e 	cmpb   $0x6e,0x1e21
     15f:	0f 85 fb fe ff ff    	jne    60 <main+0x60>
     165:	80 3d 22 1e 00 00 62 	cmpb   $0x62,0x1e22
     16c:	0f 85 ee fe ff ff    	jne    60 <main+0x60>
     172:	80 3d 23 1e 00 00 6c 	cmpb   $0x6c,0x1e23
     179:	0f 85 e1 fe ff ff    	jne    60 <main+0x60>
     17f:	80 3d 24 1e 00 00 6f 	cmpb   $0x6f,0x1e24
     186:	0f 85 d4 fe ff ff    	jne    60 <main+0x60>
     18c:	80 3d 25 1e 00 00 63 	cmpb   $0x63,0x1e25
     193:	0f 85 c7 fe ff ff    	jne    60 <main+0x60>
     199:	80 3d 26 1e 00 00 6b 	cmpb   $0x6b,0x1e26
     1a0:	0f 85 ba fe ff ff    	jne    60 <main+0x60>
      buf[strlen(buf)-1] = 0;
     1a6:	83 ec 0c             	sub    $0xc,%esp
     1a9:	68 20 1e 00 00       	push   $0x1e20
     1ae:	e8 1d 0e 00 00       	call   fd0 <strlen>
      int scid = atoi(buf+8);
     1b3:	c7 04 24 28 1e 00 00 	movl   $0x1e28,(%esp)
      buf[strlen(buf)-1] = 0;
     1ba:	c6 80 1f 1e 00 00 00 	movb   $0x0,0x1e1f(%eax)
      int scid = atoi(buf+8);
     1c1:	e8 4a 0f 00 00       	call   1110 <atoi>
      sign =unblock(scid);
     1c6:	89 04 24             	mov    %eax,(%esp)
      int scid = atoi(buf+8);
     1c9:	89 c3                	mov    %eax,%ebx
      sign =unblock(scid);
     1cb:	e8 63 10 00 00       	call   1233 <unblock>
      if(sign < 0)
     1d0:	83 c4 10             	add    $0x10,%esp
     1d3:	85 c0                	test   %eax,%eax
     1d5:	0f 89 a0 fe ff ff    	jns    7b <main+0x7b>
        printf(2, "unblock %d failed\n", scid);
     1db:	51                   	push   %ecx
     1dc:	53                   	push   %ebx
     1dd:	68 e3 16 00 00       	push   $0x16e3
     1e2:	6a 02                	push   $0x2
     1e4:	e8 07 11 00 00       	call   12f0 <printf>
     1e9:	83 c4 10             	add    $0x10,%esp
     1ec:	e9 8a fe ff ff       	jmp    7b <main+0x7b>
     1f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(buf[0] == 'h' && buf[1] == 'i' && buf[2] == 's' && buf[3] == 't'  && buf[4] == 'o'  && buf[5] == 'r' && buf[6] == 'y')
     1f8:	80 3d 21 1e 00 00 69 	cmpb   $0x69,0x1e21
     1ff:	0f 85 5b fe ff ff    	jne    60 <main+0x60>
     205:	80 3d 22 1e 00 00 73 	cmpb   $0x73,0x1e22
     20c:	0f 85 4e fe ff ff    	jne    60 <main+0x60>
     212:	80 3d 23 1e 00 00 74 	cmpb   $0x74,0x1e23
     219:	0f 85 41 fe ff ff    	jne    60 <main+0x60>
     21f:	80 3d 24 1e 00 00 6f 	cmpb   $0x6f,0x1e24
     226:	0f 85 34 fe ff ff    	jne    60 <main+0x60>
     22c:	80 3d 25 1e 00 00 72 	cmpb   $0x72,0x1e25
     233:	0f 85 27 fe ff ff    	jne    60 <main+0x60>
     239:	80 3d 26 1e 00 00 79 	cmpb   $0x79,0x1e26
     240:	0f 85 1a fe ff ff    	jne    60 <main+0x60>
      helper_history();
     246:	e8 05 02 00 00       	call   450 <helper_history>
      continue;  // Skip the usual exec and loop back to the prompt.
     24b:	e9 2b fe ff ff       	jmp    7b <main+0x7b>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     250:	80 3d 22 1e 00 00 20 	cmpb   $0x20,0x1e22
     257:	0f 85 03 fe ff ff    	jne    60 <main+0x60>
      buf[strlen(buf)-1] = 0;  // chop \n
     25d:	83 ec 0c             	sub    $0xc,%esp
     260:	68 20 1e 00 00       	push   $0x1e20
     265:	e8 66 0d 00 00       	call   fd0 <strlen>
      if(chdir(buf+3) < 0)
     26a:	c7 04 24 23 1e 00 00 	movl   $0x1e23,(%esp)
      buf[strlen(buf)-1] = 0;  // chop \n
     271:	c6 80 1f 1e 00 00 00 	movb   $0x0,0x1e1f(%eax)
      if(chdir(buf+3) < 0)
     278:	e8 76 0f 00 00       	call   11f3 <chdir>
     27d:	83 c4 10             	add    $0x10,%esp
     280:	85 c0                	test   %eax,%eax
     282:	0f 89 f3 fd ff ff    	jns    7b <main+0x7b>
        printf(2, "cannot cd %s\n", buf+3);
     288:	50                   	push   %eax
     289:	68 23 1e 00 00       	push   $0x1e23
     28e:	68 ab 16 00 00       	push   $0x16ab
     293:	6a 02                	push   $0x2
     295:	e8 56 10 00 00       	call   12f0 <printf>
     29a:	83 c4 10             	add    $0x10,%esp
     29d:	e9 d9 fd ff ff       	jmp    7b <main+0x7b>
     2a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(buf[0] == 'b' && buf[1] == 'l' && buf[2] == 'o' && buf[3] == 'c'  && buf[4] == 'k')
     2a8:	80 3d 22 1e 00 00 6f 	cmpb   $0x6f,0x1e22
     2af:	0f 85 ab fd ff ff    	jne    60 <main+0x60>
     2b5:	80 3d 23 1e 00 00 63 	cmpb   $0x63,0x1e23
     2bc:	0f 85 9e fd ff ff    	jne    60 <main+0x60>
     2c2:	80 3d 24 1e 00 00 6b 	cmpb   $0x6b,0x1e24
     2c9:	0f 85 91 fd ff ff    	jne    60 <main+0x60>
      buf[strlen(buf)-1] = 0;  // remove trailing newline
     2cf:	83 ec 0c             	sub    $0xc,%esp
     2d2:	68 20 1e 00 00       	push   $0x1e20
     2d7:	e8 f4 0c 00 00       	call   fd0 <strlen>
      int scid = atoi(buf+6);
     2dc:	c7 04 24 26 1e 00 00 	movl   $0x1e26,(%esp)
      buf[strlen(buf)-1] = 0;  // remove trailing newline
     2e3:	c6 80 1f 1e 00 00 00 	movb   $0x0,0x1e1f(%eax)
      int scid = atoi(buf+6);
     2ea:	e8 21 0e 00 00       	call   1110 <atoi>
      sign=block(scid);
     2ef:	89 04 24             	mov    %eax,(%esp)
      int scid = atoi(buf+6);
     2f2:	89 c3                	mov    %eax,%ebx
      sign=block(scid);
     2f4:	e8 32 0f 00 00       	call   122b <block>
      if(sign < 0)
     2f9:	83 c4 10             	add    $0x10,%esp
     2fc:	85 c0                	test   %eax,%eax
     2fe:	0f 89 77 fd ff ff    	jns    7b <main+0x7b>
        printf(2, "block %d failed\n", scid);
     304:	50                   	push   %eax
     305:	53                   	push   %ebx
     306:	68 e5 16 00 00       	push   $0x16e5
     30b:	6a 02                	push   $0x2
     30d:	e8 de 0f 00 00       	call   12f0 <printf>
     312:	83 c4 10             	add    $0x10,%esp
     315:	e9 61 fd ff ff       	jmp    7b <main+0x7b>
  exit();
     31a:	e8 64 0e 00 00       	call   1183 <exit>
      close(fd);
     31f:	83 ec 0c             	sub    $0xc,%esp
     322:	50                   	push   %eax
     323:	e8 83 0e 00 00       	call   11ab <close>
      break;
     328:	83 c4 10             	add    $0x10,%esp
     32b:	e9 4b fd ff ff       	jmp    7b <main+0x7b>
      runcmd(parsecmd(buf));
     330:	83 ec 0c             	sub    $0xc,%esp
     333:	68 20 1e 00 00       	push   $0x1e20
     338:	e8 93 0b 00 00       	call   ed0 <parsecmd>
     33d:	89 04 24             	mov    %eax,(%esp)
     340:	e8 db 01 00 00       	call   520 <runcmd>
  argv[argc] = 0;
     345:	31 db                	xor    %ebx,%ebx
     347:	89 5c 8d d0          	mov    %ebx,-0x30(%ebp,%ecx,4)
  if(argc != 3){
     34b:	83 f9 03             	cmp    $0x3,%ecx
     34e:	74 2b                	je     37b <main+0x37b>
    printf(2, "usage: chmod filename mode\n");
     350:	51                   	push   %ecx
     351:	51                   	push   %ecx
     352:	68 b9 16 00 00       	push   $0x16b9
     357:	6a 02                	push   $0x2
     359:	e8 92 0f 00 00       	call   12f0 <printf>
    continue;
     35e:	83 c4 10             	add    $0x10,%esp
     361:	e9 15 fd ff ff       	jmp    7b <main+0x7b>
    argv[argc++] = p;
     366:	83 c1 01             	add    $0x1,%ecx
    while(*p != ' ' && *p != '\0')
     369:	80 e2 df             	and    $0xdf,%dl
    argv[argc++] = p;
     36c:	89 44 8d cc          	mov    %eax,-0x34(%ebp,%ecx,4)
    while(*p != ' ' && *p != '\0')
     370:	0f 85 ba fd ff ff    	jne    130 <main+0x130>
     376:	e9 c5 fd ff ff       	jmp    140 <main+0x140>
  int mode = atoi(argv[2]);
     37b:	83 ec 0c             	sub    $0xc,%esp
     37e:	ff 75 d8             	push   -0x28(%ebp)
     381:	e8 8a 0d 00 00       	call   1110 <atoi>
  printf(2, "%d\n",mode);
     386:	83 c4 0c             	add    $0xc,%esp
     389:	50                   	push   %eax
  int mode = atoi(argv[2]);
     38a:	89 c3                	mov    %eax,%ebx
  printf(2, "%d\n",mode);
     38c:	68 01 16 00 00       	push   $0x1601
     391:	6a 02                	push   $0x2
     393:	e8 58 0f 00 00       	call   12f0 <printf>
  if(chmod(argv[1], mode) < 0){
     398:	58                   	pop    %eax
     399:	5a                   	pop    %edx
     39a:	53                   	push   %ebx
     39b:	ff 75 d4             	push   -0x2c(%ebp)
     39e:	e8 98 0e 00 00       	call   123b <chmod>
     3a3:	83 c4 10             	add    $0x10,%esp
     3a6:	85 c0                	test   %eax,%eax
     3a8:	0f 89 cd fc ff ff    	jns    7b <main+0x7b>
    printf(2, "chmod failed\n");
     3ae:	50                   	push   %eax
     3af:	50                   	push   %eax
     3b0:	68 d5 16 00 00       	push   $0x16d5
     3b5:	6a 02                	push   $0x2
     3b7:	e8 34 0f 00 00       	call   12f0 <printf>
     3bc:	83 c4 10             	add    $0x10,%esp
     3bf:	e9 b7 fc ff ff       	jmp    7b <main+0x7b>
    panic("fork");
     3c4:	83 ec 0c             	sub    $0xc,%esp
     3c7:	68 05 16 00 00       	push   $0x1605
     3cc:	e8 0f 01 00 00       	call   4e0 <panic>
     3d1:	66 90                	xchg   %ax,%ax
     3d3:	66 90                	xchg   %ax,%ax
     3d5:	66 90                	xchg   %ax,%ax
     3d7:	66 90                	xchg   %ax,%ax
     3d9:	66 90                	xchg   %ax,%ax
     3db:	66 90                	xchg   %ax,%ax
     3dd:	66 90                	xchg   %ax,%ax
     3df:	90                   	nop

000003e0 <a1>:
}
     3e0:	c3                   	ret
     3e1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     3e8:	00 
     3e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000003f0 <getcmd>:
{
     3f0:	55                   	push   %ebp
     3f1:	89 e5                	mov    %esp,%ebp
     3f3:	56                   	push   %esi
     3f4:	53                   	push   %ebx
     3f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
     3f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  printf(2, "$ ");
     3fb:	83 ec 08             	sub    $0x8,%esp
     3fe:	68 f8 15 00 00       	push   $0x15f8
     403:	6a 02                	push   $0x2
     405:	e8 e6 0e 00 00       	call   12f0 <printf>
  memset(buf, 0, nbuf);
     40a:	83 c4 0c             	add    $0xc,%esp
     40d:	56                   	push   %esi
     40e:	6a 00                	push   $0x0
     410:	53                   	push   %ebx
     411:	e8 ea 0b 00 00       	call   1000 <memset>
  gets(buf, nbuf);
     416:	58                   	pop    %eax
     417:	5a                   	pop    %edx
     418:	56                   	push   %esi
     419:	53                   	push   %ebx
     41a:	e8 41 0c 00 00       	call   1060 <gets>
  if(buf[0] == 0) // EOF
     41f:	83 c4 10             	add    $0x10,%esp
     422:	80 3b 01             	cmpb   $0x1,(%ebx)
     425:	19 c0                	sbb    %eax,%eax
}
     427:	8d 65 f8             	lea    -0x8(%ebp),%esp
     42a:	5b                   	pop    %ebx
     42b:	5e                   	pop    %esi
     42c:	5d                   	pop    %ebp
     42d:	c3                   	ret
     42e:	66 90                	xchg   %ax,%ax

00000430 <helper_chmod>:
void helper_chmod(){
     430:	c3                   	ret
     431:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     438:	00 
     439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000440 <CHMOD>:
void CHMOD(){
     440:	c3                   	ret
     441:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     448:	00 
     449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000450 <helper_history>:
void helper_history(){
     450:	55                   	push   %ebp
     451:	89 e5                	mov    %esp,%ebp
     453:	57                   	push   %edi
     454:	56                   	push   %esi
      n = gethistory((char*)hist, sizeof(hist));
     455:	8d 85 e8 f8 ff ff    	lea    -0x718(%ebp),%eax
void helper_history(){
     45b:	53                   	push   %ebx
     45c:	81 ec 14 07 00 00    	sub    $0x714,%esp
      n = gethistory((char*)hist, sizeof(hist));
     462:	68 00 07 00 00       	push   $0x700
     467:	50                   	push   %eax
     468:	e8 b6 0d 00 00       	call   1223 <gethistory>
      if(n < 0) {
     46d:	83 c4 10             	add    $0x10,%esp
      n = gethistory((char*)hist, sizeof(hist));
     470:	89 c7                	mov    %eax,%edi
      if(n < 0) {
     472:	85 c0                	test   %eax,%eax
     474:	78 42                	js     4b8 <helper_history+0x68>
        for(i = 0; i < n; i++){
     476:	8d 9d ec f8 ff ff    	lea    -0x714(%ebp),%ebx
     47c:	be 00 00 00 00       	mov    $0x0,%esi
     481:	74 28                	je     4ab <helper_history+0x5b>
     483:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
          printf(1, "%d %s %d\n", hist[i].pid, hist[i].name, hist[i].mem_usage);
     488:	83 ec 0c             	sub    $0xc,%esp
     48b:	ff 73 10             	push   0x10(%ebx)
        for(i = 0; i < n; i++){
     48e:	83 c6 01             	add    $0x1,%esi
          printf(1, "%d %s %d\n", hist[i].pid, hist[i].name, hist[i].mem_usage);
     491:	53                   	push   %ebx
        for(i = 0; i < n; i++){
     492:	83 c3 1c             	add    $0x1c,%ebx
          printf(1, "%d %s %d\n", hist[i].pid, hist[i].name, hist[i].mem_usage);
     495:	ff 73 e0             	push   -0x20(%ebx)
     498:	68 fb 15 00 00       	push   $0x15fb
     49d:	6a 01                	push   $0x1
     49f:	e8 4c 0e 00 00       	call   12f0 <printf>
        for(i = 0; i < n; i++){
     4a4:	83 c4 20             	add    $0x20,%esp
     4a7:	39 f7                	cmp    %esi,%edi
     4a9:	75 dd                	jne    488 <helper_history+0x38>
};
     4ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
     4ae:	5b                   	pop    %ebx
     4af:	5e                   	pop    %esi
     4b0:	5f                   	pop    %edi
     4b1:	5d                   	pop    %ebp
     4b2:	c3                   	ret
     4b3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        printf(2, "history: %d error retrieving history\n",n);
     4b8:	83 ec 04             	sub    $0x4,%esp
     4bb:	50                   	push   %eax
     4bc:	68 00 17 00 00       	push   $0x1700
     4c1:	6a 02                	push   $0x2
     4c3:	e8 28 0e 00 00       	call   12f0 <printf>
     4c8:	83 c4 10             	add    $0x10,%esp
};
     4cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
     4ce:	5b                   	pop    %ebx
     4cf:	5e                   	pop    %esi
     4d0:	5f                   	pop    %edi
     4d1:	5d                   	pop    %ebp
     4d2:	c3                   	ret
     4d3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     4da:	00 
     4db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

000004e0 <panic>:
{
     4e0:	55                   	push   %ebp
     4e1:	89 e5                	mov    %esp,%ebp
     4e3:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
     4e6:	ff 75 08             	push   0x8(%ebp)
     4e9:	68 9f 16 00 00       	push   $0x169f
     4ee:	6a 02                	push   $0x2
     4f0:	e8 fb 0d 00 00       	call   12f0 <printf>
  exit();
     4f5:	e8 89 0c 00 00       	call   1183 <exit>
     4fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000500 <fork1>:
{
     500:	55                   	push   %ebp
     501:	89 e5                	mov    %esp,%ebp
     503:	83 ec 08             	sub    $0x8,%esp
  pid = fork();
     506:	e8 70 0c 00 00       	call   117b <fork>
  if(pid == -1)
     50b:	83 f8 ff             	cmp    $0xffffffff,%eax
     50e:	74 02                	je     512 <fork1+0x12>
  return pid;
}
     510:	c9                   	leave
     511:	c3                   	ret
    panic("fork");
     512:	83 ec 0c             	sub    $0xc,%esp
     515:	68 05 16 00 00       	push   $0x1605
     51a:	e8 c1 ff ff ff       	call   4e0 <panic>
     51f:	90                   	nop

00000520 <runcmd>:
{
     520:	55                   	push   %ebp
     521:	89 e5                	mov    %esp,%ebp
     523:	53                   	push   %ebx
     524:	83 ec 14             	sub    $0x14,%esp
     527:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(cmd == 0)
     52a:	85 db                	test   %ebx,%ebx
     52c:	74 42                	je     570 <runcmd+0x50>
  switch(cmd->type){
     52e:	83 3b 05             	cmpl   $0x5,(%ebx)
     531:	0f 87 e3 00 00 00    	ja     61a <runcmd+0xfa>
     537:	8b 03                	mov    (%ebx),%eax
     539:	ff 24 85 28 17 00 00 	jmp    *0x1728(,%eax,4)
    if(ecmd->argv[0] == 0)
     540:	8b 43 04             	mov    0x4(%ebx),%eax
     543:	85 c0                	test   %eax,%eax
     545:	74 29                	je     570 <runcmd+0x50>
    exec(ecmd->argv[0], ecmd->argv);
     547:	8d 53 04             	lea    0x4(%ebx),%edx
     54a:	51                   	push   %ecx
     54b:	51                   	push   %ecx
     54c:	52                   	push   %edx
     54d:	50                   	push   %eax
     54e:	e8 68 0c 00 00       	call   11bb <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
     553:	83 c4 0c             	add    $0xc,%esp
     556:	ff 73 04             	push   0x4(%ebx)
     559:	68 11 16 00 00       	push   $0x1611
     55e:	6a 02                	push   $0x2
     560:	e8 8b 0d 00 00       	call   12f0 <printf>
    break;
     565:	83 c4 10             	add    $0x10,%esp
     568:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     56f:	00 
    exit();
     570:	e8 0e 0c 00 00       	call   1183 <exit>
    if(fork1() == 0)
     575:	e8 86 ff ff ff       	call   500 <fork1>
     57a:	85 c0                	test   %eax,%eax
     57c:	75 f2                	jne    570 <runcmd+0x50>
     57e:	e9 8c 00 00 00       	jmp    60f <runcmd+0xef>
    if(pipe(p) < 0)
     583:	83 ec 0c             	sub    $0xc,%esp
     586:	8d 45 f0             	lea    -0x10(%ebp),%eax
     589:	50                   	push   %eax
     58a:	e8 04 0c 00 00       	call   1193 <pipe>
     58f:	83 c4 10             	add    $0x10,%esp
     592:	85 c0                	test   %eax,%eax
     594:	0f 88 a2 00 00 00    	js     63c <runcmd+0x11c>
    if(fork1() == 0){
     59a:	e8 61 ff ff ff       	call   500 <fork1>
     59f:	85 c0                	test   %eax,%eax
     5a1:	0f 84 a2 00 00 00    	je     649 <runcmd+0x129>
    if(fork1() == 0){
     5a7:	e8 54 ff ff ff       	call   500 <fork1>
     5ac:	85 c0                	test   %eax,%eax
     5ae:	0f 84 c3 00 00 00    	je     677 <runcmd+0x157>
    close(p[0]);
     5b4:	83 ec 0c             	sub    $0xc,%esp
     5b7:	ff 75 f0             	push   -0x10(%ebp)
     5ba:	e8 ec 0b 00 00       	call   11ab <close>
    close(p[1]);
     5bf:	58                   	pop    %eax
     5c0:	ff 75 f4             	push   -0xc(%ebp)
     5c3:	e8 e3 0b 00 00       	call   11ab <close>
    wait();
     5c8:	e8 be 0b 00 00       	call   118b <wait>
    wait();
     5cd:	e8 b9 0b 00 00       	call   118b <wait>
    break;
     5d2:	83 c4 10             	add    $0x10,%esp
     5d5:	eb 99                	jmp    570 <runcmd+0x50>
    if(fork1() == 0)
     5d7:	e8 24 ff ff ff       	call   500 <fork1>
     5dc:	85 c0                	test   %eax,%eax
     5de:	74 2f                	je     60f <runcmd+0xef>
    wait();
     5e0:	e8 a6 0b 00 00       	call   118b <wait>
    runcmd(lcmd->right);
     5e5:	83 ec 0c             	sub    $0xc,%esp
     5e8:	ff 73 08             	push   0x8(%ebx)
     5eb:	e8 30 ff ff ff       	call   520 <runcmd>
    close(rcmd->fd);
     5f0:	83 ec 0c             	sub    $0xc,%esp
     5f3:	ff 73 14             	push   0x14(%ebx)
     5f6:	e8 b0 0b 00 00       	call   11ab <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     5fb:	58                   	pop    %eax
     5fc:	5a                   	pop    %edx
     5fd:	ff 73 10             	push   0x10(%ebx)
     600:	ff 73 08             	push   0x8(%ebx)
     603:	e8 bb 0b 00 00       	call   11c3 <open>
     608:	83 c4 10             	add    $0x10,%esp
     60b:	85 c0                	test   %eax,%eax
     60d:	78 18                	js     627 <runcmd+0x107>
      runcmd(bcmd->cmd);
     60f:	83 ec 0c             	sub    $0xc,%esp
     612:	ff 73 04             	push   0x4(%ebx)
     615:	e8 06 ff ff ff       	call   520 <runcmd>
    panic("runcmd");
     61a:	83 ec 0c             	sub    $0xc,%esp
     61d:	68 0a 16 00 00       	push   $0x160a
     622:	e8 b9 fe ff ff       	call   4e0 <panic>
      printf(2, "open %s failed\n", rcmd->file);
     627:	51                   	push   %ecx
     628:	ff 73 08             	push   0x8(%ebx)
     62b:	68 21 16 00 00       	push   $0x1621
     630:	6a 02                	push   $0x2
     632:	e8 b9 0c 00 00       	call   12f0 <printf>
      exit();
     637:	e8 47 0b 00 00       	call   1183 <exit>
      panic("pipe");
     63c:	83 ec 0c             	sub    $0xc,%esp
     63f:	68 31 16 00 00       	push   $0x1631
     644:	e8 97 fe ff ff       	call   4e0 <panic>
      close(1);
     649:	83 ec 0c             	sub    $0xc,%esp
     64c:	6a 01                	push   $0x1
     64e:	e8 58 0b 00 00       	call   11ab <close>
      dup(p[1]);
     653:	58                   	pop    %eax
     654:	ff 75 f4             	push   -0xc(%ebp)
     657:	e8 9f 0b 00 00       	call   11fb <dup>
      close(p[0]);
     65c:	58                   	pop    %eax
     65d:	ff 75 f0             	push   -0x10(%ebp)
     660:	e8 46 0b 00 00       	call   11ab <close>
      close(p[1]);
     665:	58                   	pop    %eax
     666:	ff 75 f4             	push   -0xc(%ebp)
     669:	e8 3d 0b 00 00       	call   11ab <close>
      runcmd(pcmd->left);
     66e:	5a                   	pop    %edx
     66f:	ff 73 04             	push   0x4(%ebx)
     672:	e8 a9 fe ff ff       	call   520 <runcmd>
      close(0);
     677:	83 ec 0c             	sub    $0xc,%esp
     67a:	6a 00                	push   $0x0
     67c:	e8 2a 0b 00 00       	call   11ab <close>
      dup(p[0]);
     681:	5a                   	pop    %edx
     682:	ff 75 f0             	push   -0x10(%ebp)
     685:	e8 71 0b 00 00       	call   11fb <dup>
      close(p[0]);
     68a:	59                   	pop    %ecx
     68b:	ff 75 f0             	push   -0x10(%ebp)
     68e:	e8 18 0b 00 00       	call   11ab <close>
      close(p[1]);
     693:	58                   	pop    %eax
     694:	ff 75 f4             	push   -0xc(%ebp)
     697:	e8 0f 0b 00 00       	call   11ab <close>
      runcmd(pcmd->right);
     69c:	58                   	pop    %eax
     69d:	ff 73 08             	push   0x8(%ebx)
     6a0:	e8 7b fe ff ff       	call   520 <runcmd>
     6a5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     6ac:	00 
     6ad:	8d 76 00             	lea    0x0(%esi),%esi

000006b0 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     6b0:	55                   	push   %ebp
     6b1:	89 e5                	mov    %esp,%ebp
     6b3:	53                   	push   %ebx
     6b4:	83 ec 10             	sub    $0x10,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     6b7:	6a 54                	push   $0x54
     6b9:	e8 52 0e 00 00       	call   1510 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     6be:	83 c4 0c             	add    $0xc,%esp
     6c1:	6a 54                	push   $0x54
  cmd = malloc(sizeof(*cmd));
     6c3:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     6c5:	6a 00                	push   $0x0
     6c7:	50                   	push   %eax
     6c8:	e8 33 09 00 00       	call   1000 <memset>
  cmd->type = EXEC;
     6cd:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd*)cmd;
}
     6d3:	89 d8                	mov    %ebx,%eax
     6d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     6d8:	c9                   	leave
     6d9:	c3                   	ret
     6da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000006e0 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     6e0:	55                   	push   %ebp
     6e1:	89 e5                	mov    %esp,%ebp
     6e3:	53                   	push   %ebx
     6e4:	83 ec 10             	sub    $0x10,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     6e7:	6a 18                	push   $0x18
     6e9:	e8 22 0e 00 00       	call   1510 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     6ee:	83 c4 0c             	add    $0xc,%esp
     6f1:	6a 18                	push   $0x18
  cmd = malloc(sizeof(*cmd));
     6f3:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     6f5:	6a 00                	push   $0x0
     6f7:	50                   	push   %eax
     6f8:	e8 03 09 00 00       	call   1000 <memset>
  cmd->type = REDIR;
  cmd->cmd = subcmd;
     6fd:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = REDIR;
     700:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
     706:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
     709:	8b 45 0c             	mov    0xc(%ebp),%eax
     70c:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
     70f:	8b 45 10             	mov    0x10(%ebp),%eax
     712:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
     715:	8b 45 14             	mov    0x14(%ebp),%eax
     718:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
     71b:	8b 45 18             	mov    0x18(%ebp),%eax
     71e:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
     721:	89 d8                	mov    %ebx,%eax
     723:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     726:	c9                   	leave
     727:	c3                   	ret
     728:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     72f:	00 

00000730 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     730:	55                   	push   %ebp
     731:	89 e5                	mov    %esp,%ebp
     733:	53                   	push   %ebx
     734:	83 ec 10             	sub    $0x10,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     737:	6a 0c                	push   $0xc
     739:	e8 d2 0d 00 00       	call   1510 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     73e:	83 c4 0c             	add    $0xc,%esp
     741:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     743:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     745:	6a 00                	push   $0x0
     747:	50                   	push   %eax
     748:	e8 b3 08 00 00       	call   1000 <memset>
  cmd->type = PIPE;
  cmd->left = left;
     74d:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = PIPE;
     750:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
     756:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     759:	8b 45 0c             	mov    0xc(%ebp),%eax
     75c:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     75f:	89 d8                	mov    %ebx,%eax
     761:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     764:	c9                   	leave
     765:	c3                   	ret
     766:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     76d:	00 
     76e:	66 90                	xchg   %ax,%ax

00000770 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     770:	55                   	push   %ebp
     771:	89 e5                	mov    %esp,%ebp
     773:	53                   	push   %ebx
     774:	83 ec 10             	sub    $0x10,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     777:	6a 0c                	push   $0xc
     779:	e8 92 0d 00 00       	call   1510 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     77e:	83 c4 0c             	add    $0xc,%esp
     781:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     783:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     785:	6a 00                	push   $0x0
     787:	50                   	push   %eax
     788:	e8 73 08 00 00       	call   1000 <memset>
  cmd->type = LIST;
  cmd->left = left;
     78d:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = LIST;
     790:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
     796:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     799:	8b 45 0c             	mov    0xc(%ebp),%eax
     79c:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     79f:	89 d8                	mov    %ebx,%eax
     7a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     7a4:	c9                   	leave
     7a5:	c3                   	ret
     7a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     7ad:	00 
     7ae:	66 90                	xchg   %ax,%ax

000007b0 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     7b0:	55                   	push   %ebp
     7b1:	89 e5                	mov    %esp,%ebp
     7b3:	53                   	push   %ebx
     7b4:	83 ec 10             	sub    $0x10,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     7b7:	6a 08                	push   $0x8
     7b9:	e8 52 0d 00 00       	call   1510 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     7be:	83 c4 0c             	add    $0xc,%esp
     7c1:	6a 08                	push   $0x8
  cmd = malloc(sizeof(*cmd));
     7c3:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     7c5:	6a 00                	push   $0x0
     7c7:	50                   	push   %eax
     7c8:	e8 33 08 00 00       	call   1000 <memset>
  cmd->type = BACK;
  cmd->cmd = subcmd;
     7cd:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = BACK;
     7d0:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
     7d6:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
     7d9:	89 d8                	mov    %ebx,%eax
     7db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     7de:	c9                   	leave
     7df:	c3                   	ret

000007e0 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     7e0:	55                   	push   %ebp
     7e1:	89 e5                	mov    %esp,%ebp
     7e3:	57                   	push   %edi
     7e4:	56                   	push   %esi
     7e5:	53                   	push   %ebx
     7e6:	83 ec 0c             	sub    $0xc,%esp
  char *s;
  int ret;

  s = *ps;
     7e9:	8b 45 08             	mov    0x8(%ebp),%eax
{
     7ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     7ef:	8b 75 10             	mov    0x10(%ebp),%esi
  s = *ps;
     7f2:	8b 38                	mov    (%eax),%edi
  while(s < es && strchr(whitespace, *s))
     7f4:	39 df                	cmp    %ebx,%edi
     7f6:	72 0f                	jb     807 <gettoken+0x27>
     7f8:	eb 25                	jmp    81f <gettoken+0x3f>
     7fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    s++;
     800:	83 c7 01             	add    $0x1,%edi
  while(s < es && strchr(whitespace, *s))
     803:	39 fb                	cmp    %edi,%ebx
     805:	74 18                	je     81f <gettoken+0x3f>
     807:	0f be 07             	movsbl (%edi),%eax
     80a:	83 ec 08             	sub    $0x8,%esp
     80d:	50                   	push   %eax
     80e:	68 fc 1d 00 00       	push   $0x1dfc
     813:	e8 08 08 00 00       	call   1020 <strchr>
     818:	83 c4 10             	add    $0x10,%esp
     81b:	85 c0                	test   %eax,%eax
     81d:	75 e1                	jne    800 <gettoken+0x20>
  if(q)
     81f:	85 f6                	test   %esi,%esi
     821:	74 02                	je     825 <gettoken+0x45>
    *q = s;
     823:	89 3e                	mov    %edi,(%esi)
  ret = *s;
     825:	0f b6 07             	movzbl (%edi),%eax
  switch(*s){
     828:	3c 3c                	cmp    $0x3c,%al
     82a:	0f 8f c8 00 00 00    	jg     8f8 <gettoken+0x118>
     830:	3c 3a                	cmp    $0x3a,%al
     832:	7f 5a                	jg     88e <gettoken+0xae>
     834:	84 c0                	test   %al,%al
     836:	75 48                	jne    880 <gettoken+0xa0>
     838:	31 f6                	xor    %esi,%esi
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     83a:	8b 4d 14             	mov    0x14(%ebp),%ecx
     83d:	85 c9                	test   %ecx,%ecx
     83f:	74 05                	je     846 <gettoken+0x66>
    *eq = s;
     841:	8b 45 14             	mov    0x14(%ebp),%eax
     844:	89 38                	mov    %edi,(%eax)

  while(s < es && strchr(whitespace, *s))
     846:	39 df                	cmp    %ebx,%edi
     848:	72 0d                	jb     857 <gettoken+0x77>
     84a:	eb 23                	jmp    86f <gettoken+0x8f>
     84c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s++;
     850:	83 c7 01             	add    $0x1,%edi
  while(s < es && strchr(whitespace, *s))
     853:	39 fb                	cmp    %edi,%ebx
     855:	74 18                	je     86f <gettoken+0x8f>
     857:	0f be 07             	movsbl (%edi),%eax
     85a:	83 ec 08             	sub    $0x8,%esp
     85d:	50                   	push   %eax
     85e:	68 fc 1d 00 00       	push   $0x1dfc
     863:	e8 b8 07 00 00       	call   1020 <strchr>
     868:	83 c4 10             	add    $0x10,%esp
     86b:	85 c0                	test   %eax,%eax
     86d:	75 e1                	jne    850 <gettoken+0x70>
  *ps = s;
     86f:	8b 45 08             	mov    0x8(%ebp),%eax
     872:	89 38                	mov    %edi,(%eax)
  return ret;
}
     874:	8d 65 f4             	lea    -0xc(%ebp),%esp
     877:	89 f0                	mov    %esi,%eax
     879:	5b                   	pop    %ebx
     87a:	5e                   	pop    %esi
     87b:	5f                   	pop    %edi
     87c:	5d                   	pop    %ebp
     87d:	c3                   	ret
     87e:	66 90                	xchg   %ax,%ax
  switch(*s){
     880:	78 22                	js     8a4 <gettoken+0xc4>
     882:	3c 26                	cmp    $0x26,%al
     884:	74 08                	je     88e <gettoken+0xae>
     886:	8d 48 d8             	lea    -0x28(%eax),%ecx
     889:	80 f9 01             	cmp    $0x1,%cl
     88c:	77 16                	ja     8a4 <gettoken+0xc4>
  ret = *s;
     88e:	0f be f0             	movsbl %al,%esi
    s++;
     891:	83 c7 01             	add    $0x1,%edi
    break;
     894:	eb a4                	jmp    83a <gettoken+0x5a>
     896:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     89d:	00 
     89e:	66 90                	xchg   %ax,%ax
  switch(*s){
     8a0:	3c 7c                	cmp    $0x7c,%al
     8a2:	74 ea                	je     88e <gettoken+0xae>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     8a4:	39 df                	cmp    %ebx,%edi
     8a6:	72 27                	jb     8cf <gettoken+0xef>
     8a8:	e9 87 00 00 00       	jmp    934 <gettoken+0x154>
     8ad:	8d 76 00             	lea    0x0(%esi),%esi
     8b0:	0f be 07             	movsbl (%edi),%eax
     8b3:	83 ec 08             	sub    $0x8,%esp
     8b6:	50                   	push   %eax
     8b7:	68 f4 1d 00 00       	push   $0x1df4
     8bc:	e8 5f 07 00 00       	call   1020 <strchr>
     8c1:	83 c4 10             	add    $0x10,%esp
     8c4:	85 c0                	test   %eax,%eax
     8c6:	75 1f                	jne    8e7 <gettoken+0x107>
      s++;
     8c8:	83 c7 01             	add    $0x1,%edi
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     8cb:	39 fb                	cmp    %edi,%ebx
     8cd:	74 4d                	je     91c <gettoken+0x13c>
     8cf:	0f be 07             	movsbl (%edi),%eax
     8d2:	83 ec 08             	sub    $0x8,%esp
     8d5:	50                   	push   %eax
     8d6:	68 fc 1d 00 00       	push   $0x1dfc
     8db:	e8 40 07 00 00       	call   1020 <strchr>
     8e0:	83 c4 10             	add    $0x10,%esp
     8e3:	85 c0                	test   %eax,%eax
     8e5:	74 c9                	je     8b0 <gettoken+0xd0>
    ret = 'a';
     8e7:	be 61 00 00 00       	mov    $0x61,%esi
     8ec:	e9 49 ff ff ff       	jmp    83a <gettoken+0x5a>
     8f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  switch(*s){
     8f8:	3c 3e                	cmp    $0x3e,%al
     8fa:	75 a4                	jne    8a0 <gettoken+0xc0>
    if(*s == '>'){
     8fc:	80 7f 01 3e          	cmpb   $0x3e,0x1(%edi)
     900:	74 0d                	je     90f <gettoken+0x12f>
    s++;
     902:	83 c7 01             	add    $0x1,%edi
  ret = *s;
     905:	be 3e 00 00 00       	mov    $0x3e,%esi
     90a:	e9 2b ff ff ff       	jmp    83a <gettoken+0x5a>
      s++;
     90f:	83 c7 02             	add    $0x2,%edi
      ret = '+';
     912:	be 2b 00 00 00       	mov    $0x2b,%esi
     917:	e9 1e ff ff ff       	jmp    83a <gettoken+0x5a>
  if(eq)
     91c:	8b 45 14             	mov    0x14(%ebp),%eax
     91f:	85 c0                	test   %eax,%eax
     921:	74 05                	je     928 <gettoken+0x148>
    *eq = s;
     923:	8b 45 14             	mov    0x14(%ebp),%eax
     926:	89 18                	mov    %ebx,(%eax)
  while(s < es && strchr(whitespace, *s))
     928:	89 df                	mov    %ebx,%edi
    ret = 'a';
     92a:	be 61 00 00 00       	mov    $0x61,%esi
     92f:	e9 3b ff ff ff       	jmp    86f <gettoken+0x8f>
  if(eq)
     934:	8b 55 14             	mov    0x14(%ebp),%edx
     937:	85 d2                	test   %edx,%edx
     939:	74 ef                	je     92a <gettoken+0x14a>
    *eq = s;
     93b:	8b 45 14             	mov    0x14(%ebp),%eax
     93e:	89 38                	mov    %edi,(%eax)
  while(s < es && strchr(whitespace, *s))
     940:	eb e8                	jmp    92a <gettoken+0x14a>
     942:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     949:	00 
     94a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000950 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     950:	55                   	push   %ebp
     951:	89 e5                	mov    %esp,%ebp
     953:	57                   	push   %edi
     954:	56                   	push   %esi
     955:	53                   	push   %ebx
     956:	83 ec 0c             	sub    $0xc,%esp
     959:	8b 7d 08             	mov    0x8(%ebp),%edi
     95c:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
     95f:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
     961:	39 f3                	cmp    %esi,%ebx
     963:	72 12                	jb     977 <peek+0x27>
     965:	eb 28                	jmp    98f <peek+0x3f>
     967:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     96e:	00 
     96f:	90                   	nop
    s++;
     970:	83 c3 01             	add    $0x1,%ebx
  while(s < es && strchr(whitespace, *s))
     973:	39 de                	cmp    %ebx,%esi
     975:	74 18                	je     98f <peek+0x3f>
     977:	0f be 03             	movsbl (%ebx),%eax
     97a:	83 ec 08             	sub    $0x8,%esp
     97d:	50                   	push   %eax
     97e:	68 fc 1d 00 00       	push   $0x1dfc
     983:	e8 98 06 00 00       	call   1020 <strchr>
     988:	83 c4 10             	add    $0x10,%esp
     98b:	85 c0                	test   %eax,%eax
     98d:	75 e1                	jne    970 <peek+0x20>
  *ps = s;
     98f:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
     991:	0f be 03             	movsbl (%ebx),%eax
     994:	31 d2                	xor    %edx,%edx
     996:	84 c0                	test   %al,%al
     998:	75 0e                	jne    9a8 <peek+0x58>
}
     99a:	8d 65 f4             	lea    -0xc(%ebp),%esp
     99d:	89 d0                	mov    %edx,%eax
     99f:	5b                   	pop    %ebx
     9a0:	5e                   	pop    %esi
     9a1:	5f                   	pop    %edi
     9a2:	5d                   	pop    %ebp
     9a3:	c3                   	ret
     9a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return *s && strchr(toks, *s);
     9a8:	83 ec 08             	sub    $0x8,%esp
     9ab:	50                   	push   %eax
     9ac:	ff 75 10             	push   0x10(%ebp)
     9af:	e8 6c 06 00 00       	call   1020 <strchr>
     9b4:	83 c4 10             	add    $0x10,%esp
     9b7:	31 d2                	xor    %edx,%edx
     9b9:	85 c0                	test   %eax,%eax
     9bb:	0f 95 c2             	setne  %dl
}
     9be:	8d 65 f4             	lea    -0xc(%ebp),%esp
     9c1:	5b                   	pop    %ebx
     9c2:	89 d0                	mov    %edx,%eax
     9c4:	5e                   	pop    %esi
     9c5:	5f                   	pop    %edi
     9c6:	5d                   	pop    %ebp
     9c7:	c3                   	ret
     9c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     9cf:	00 

000009d0 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     9d0:	55                   	push   %ebp
     9d1:	89 e5                	mov    %esp,%ebp
     9d3:	57                   	push   %edi
     9d4:	56                   	push   %esi
     9d5:	53                   	push   %ebx
     9d6:	83 ec 2c             	sub    $0x2c,%esp
     9d9:	8b 75 0c             	mov    0xc(%ebp),%esi
     9dc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     9df:	90                   	nop
     9e0:	83 ec 04             	sub    $0x4,%esp
     9e3:	68 53 16 00 00       	push   $0x1653
     9e8:	53                   	push   %ebx
     9e9:	56                   	push   %esi
     9ea:	e8 61 ff ff ff       	call   950 <peek>
     9ef:	83 c4 10             	add    $0x10,%esp
     9f2:	85 c0                	test   %eax,%eax
     9f4:	0f 84 f6 00 00 00    	je     af0 <parseredirs+0x120>
    tok = gettoken(ps, es, 0, 0);
     9fa:	6a 00                	push   $0x0
     9fc:	6a 00                	push   $0x0
     9fe:	53                   	push   %ebx
     9ff:	56                   	push   %esi
     a00:	e8 db fd ff ff       	call   7e0 <gettoken>
     a05:	89 c7                	mov    %eax,%edi
    if(gettoken(ps, es, &q, &eq) != 'a')
     a07:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     a0a:	50                   	push   %eax
     a0b:	8d 45 e0             	lea    -0x20(%ebp),%eax
     a0e:	50                   	push   %eax
     a0f:	53                   	push   %ebx
     a10:	56                   	push   %esi
     a11:	e8 ca fd ff ff       	call   7e0 <gettoken>
     a16:	83 c4 20             	add    $0x20,%esp
     a19:	83 f8 61             	cmp    $0x61,%eax
     a1c:	0f 85 d9 00 00 00    	jne    afb <parseredirs+0x12b>
      panic("missing file for redirection");
    switch(tok){
     a22:	83 ff 3c             	cmp    $0x3c,%edi
     a25:	74 69                	je     a90 <parseredirs+0xc0>
     a27:	83 ff 3e             	cmp    $0x3e,%edi
     a2a:	74 05                	je     a31 <parseredirs+0x61>
     a2c:	83 ff 2b             	cmp    $0x2b,%edi
     a2f:	75 af                	jne    9e0 <parseredirs+0x10>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     a31:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     a34:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  cmd = malloc(sizeof(*cmd));
     a37:	83 ec 0c             	sub    $0xc,%esp
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     a3a:	89 55 d0             	mov    %edx,-0x30(%ebp)
     a3d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  cmd = malloc(sizeof(*cmd));
     a40:	6a 18                	push   $0x18
     a42:	e8 c9 0a 00 00       	call   1510 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     a47:	83 c4 0c             	add    $0xc,%esp
     a4a:	6a 18                	push   $0x18
  cmd = malloc(sizeof(*cmd));
     a4c:	89 c7                	mov    %eax,%edi
  memset(cmd, 0, sizeof(*cmd));
     a4e:	6a 00                	push   $0x0
     a50:	50                   	push   %eax
     a51:	e8 aa 05 00 00       	call   1000 <memset>
  cmd->type = REDIR;
     a56:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  cmd->cmd = subcmd;
     a5c:	8b 45 08             	mov    0x8(%ebp),%eax
      break;
     a5f:	83 c4 10             	add    $0x10,%esp
  cmd->cmd = subcmd;
     a62:	89 47 04             	mov    %eax,0x4(%edi)
  cmd->file = file;
     a65:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
     a68:	89 4f 08             	mov    %ecx,0x8(%edi)
  cmd->efile = efile;
     a6b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  cmd->mode = mode;
     a6e:	c7 47 10 01 02 00 00 	movl   $0x201,0x10(%edi)
  cmd->efile = efile;
     a75:	89 57 0c             	mov    %edx,0xc(%edi)
  cmd->fd = fd;
     a78:	c7 47 14 01 00 00 00 	movl   $0x1,0x14(%edi)
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     a7f:	89 7d 08             	mov    %edi,0x8(%ebp)
      break;
     a82:	e9 59 ff ff ff       	jmp    9e0 <parseredirs+0x10>
     a87:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     a8e:	00 
     a8f:	90                   	nop
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     a90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     a93:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  cmd = malloc(sizeof(*cmd));
     a96:	83 ec 0c             	sub    $0xc,%esp
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     a99:	89 55 d0             	mov    %edx,-0x30(%ebp)
     a9c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  cmd = malloc(sizeof(*cmd));
     a9f:	6a 18                	push   $0x18
     aa1:	e8 6a 0a 00 00       	call   1510 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     aa6:	83 c4 0c             	add    $0xc,%esp
     aa9:	6a 18                	push   $0x18
  cmd = malloc(sizeof(*cmd));
     aab:	89 c7                	mov    %eax,%edi
  memset(cmd, 0, sizeof(*cmd));
     aad:	6a 00                	push   $0x0
     aaf:	50                   	push   %eax
     ab0:	e8 4b 05 00 00       	call   1000 <memset>
  cmd->cmd = subcmd;
     ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->file = file;
     ab8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      break;
     abb:	83 c4 10             	add    $0x10,%esp
  cmd->efile = efile;
     abe:	8b 55 d0             	mov    -0x30(%ebp),%edx
  cmd->type = REDIR;
     ac1:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  cmd->cmd = subcmd;
     ac7:	89 47 04             	mov    %eax,0x4(%edi)
  cmd->file = file;
     aca:	89 4f 08             	mov    %ecx,0x8(%edi)
  cmd->efile = efile;
     acd:	89 57 0c             	mov    %edx,0xc(%edi)
  cmd->mode = mode;
     ad0:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
  cmd->fd = fd;
     ad7:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     ade:	89 7d 08             	mov    %edi,0x8(%ebp)
      break;
     ae1:	e9 fa fe ff ff       	jmp    9e0 <parseredirs+0x10>
     ae6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     aed:	00 
     aee:	66 90                	xchg   %ax,%ax
    }
  }
  return cmd;
}
     af0:	8b 45 08             	mov    0x8(%ebp),%eax
     af3:	8d 65 f4             	lea    -0xc(%ebp),%esp
     af6:	5b                   	pop    %ebx
     af7:	5e                   	pop    %esi
     af8:	5f                   	pop    %edi
     af9:	5d                   	pop    %ebp
     afa:	c3                   	ret
      panic("missing file for redirection");
     afb:	83 ec 0c             	sub    $0xc,%esp
     afe:	68 36 16 00 00       	push   $0x1636
     b03:	e8 d8 f9 ff ff       	call   4e0 <panic>
     b08:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     b0f:	00 

00000b10 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     b10:	55                   	push   %ebp
     b11:	89 e5                	mov    %esp,%ebp
     b13:	57                   	push   %edi
     b14:	56                   	push   %esi
     b15:	53                   	push   %ebx
     b16:	83 ec 30             	sub    $0x30,%esp
     b19:	8b 5d 08             	mov    0x8(%ebp),%ebx
     b1c:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     b1f:	68 56 16 00 00       	push   $0x1656
     b24:	56                   	push   %esi
     b25:	53                   	push   %ebx
     b26:	e8 25 fe ff ff       	call   950 <peek>
     b2b:	83 c4 10             	add    $0x10,%esp
     b2e:	85 c0                	test   %eax,%eax
     b30:	0f 85 aa 00 00 00    	jne    be0 <parseexec+0xd0>
  cmd = malloc(sizeof(*cmd));
     b36:	83 ec 0c             	sub    $0xc,%esp
     b39:	89 c7                	mov    %eax,%edi
     b3b:	6a 54                	push   $0x54
     b3d:	e8 ce 09 00 00       	call   1510 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     b42:	83 c4 0c             	add    $0xc,%esp
     b45:	6a 54                	push   $0x54
     b47:	6a 00                	push   $0x0
     b49:	89 45 d0             	mov    %eax,-0x30(%ebp)
     b4c:	50                   	push   %eax
     b4d:	e8 ae 04 00 00       	call   1000 <memset>
  cmd->type = EXEC;
     b52:	8b 45 d0             	mov    -0x30(%ebp),%eax

  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     b55:	83 c4 0c             	add    $0xc,%esp
  cmd->type = EXEC;
     b58:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  ret = parseredirs(ret, ps, es);
     b5e:	56                   	push   %esi
     b5f:	53                   	push   %ebx
     b60:	50                   	push   %eax
     b61:	e8 6a fe ff ff       	call   9d0 <parseredirs>
  while(!peek(ps, es, "|)&;")){
     b66:	83 c4 10             	add    $0x10,%esp
  ret = parseredirs(ret, ps, es);
     b69:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
     b6c:	eb 15                	jmp    b83 <parseexec+0x73>
     b6e:	66 90                	xchg   %ax,%ax
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
     b70:	83 ec 04             	sub    $0x4,%esp
     b73:	56                   	push   %esi
     b74:	53                   	push   %ebx
     b75:	ff 75 d4             	push   -0x2c(%ebp)
     b78:	e8 53 fe ff ff       	call   9d0 <parseredirs>
     b7d:	83 c4 10             	add    $0x10,%esp
     b80:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
     b83:	83 ec 04             	sub    $0x4,%esp
     b86:	68 6d 16 00 00       	push   $0x166d
     b8b:	56                   	push   %esi
     b8c:	53                   	push   %ebx
     b8d:	e8 be fd ff ff       	call   950 <peek>
     b92:	83 c4 10             	add    $0x10,%esp
     b95:	85 c0                	test   %eax,%eax
     b97:	75 5f                	jne    bf8 <parseexec+0xe8>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     b99:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     b9c:	50                   	push   %eax
     b9d:	8d 45 e0             	lea    -0x20(%ebp),%eax
     ba0:	50                   	push   %eax
     ba1:	56                   	push   %esi
     ba2:	53                   	push   %ebx
     ba3:	e8 38 fc ff ff       	call   7e0 <gettoken>
     ba8:	83 c4 10             	add    $0x10,%esp
     bab:	85 c0                	test   %eax,%eax
     bad:	74 49                	je     bf8 <parseexec+0xe8>
    if(tok != 'a')
     baf:	83 f8 61             	cmp    $0x61,%eax
     bb2:	75 62                	jne    c16 <parseexec+0x106>
    cmd->argv[argc] = q;
     bb4:	8b 45 e0             	mov    -0x20(%ebp),%eax
     bb7:	8b 55 d0             	mov    -0x30(%ebp),%edx
     bba:	89 44 ba 04          	mov    %eax,0x4(%edx,%edi,4)
    cmd->eargv[argc] = eq;
     bbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     bc1:	89 44 ba 2c          	mov    %eax,0x2c(%edx,%edi,4)
    argc++;
     bc5:	83 c7 01             	add    $0x1,%edi
    if(argc >= MAXARGS)
     bc8:	83 ff 0a             	cmp    $0xa,%edi
     bcb:	75 a3                	jne    b70 <parseexec+0x60>
      panic("too many args");
     bcd:	83 ec 0c             	sub    $0xc,%esp
     bd0:	68 5f 16 00 00       	push   $0x165f
     bd5:	e8 06 f9 ff ff       	call   4e0 <panic>
     bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return parseblock(ps, es);
     be0:	89 75 0c             	mov    %esi,0xc(%ebp)
     be3:	89 5d 08             	mov    %ebx,0x8(%ebp)
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     be6:	8d 65 f4             	lea    -0xc(%ebp),%esp
     be9:	5b                   	pop    %ebx
     bea:	5e                   	pop    %esi
     beb:	5f                   	pop    %edi
     bec:	5d                   	pop    %ebp
    return parseblock(ps, es);
     bed:	e9 ae 01 00 00       	jmp    da0 <parseblock>
     bf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  cmd->argv[argc] = 0;
     bf8:	8b 45 d0             	mov    -0x30(%ebp),%eax
     bfb:	c7 44 b8 04 00 00 00 	movl   $0x0,0x4(%eax,%edi,4)
     c02:	00 
  cmd->eargv[argc] = 0;
     c03:	c7 44 b8 2c 00 00 00 	movl   $0x0,0x2c(%eax,%edi,4)
     c0a:	00 
}
     c0b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     c0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c11:	5b                   	pop    %ebx
     c12:	5e                   	pop    %esi
     c13:	5f                   	pop    %edi
     c14:	5d                   	pop    %ebp
     c15:	c3                   	ret
      panic("syntax");
     c16:	83 ec 0c             	sub    $0xc,%esp
     c19:	68 58 16 00 00       	push   $0x1658
     c1e:	e8 bd f8 ff ff       	call   4e0 <panic>
     c23:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     c2a:	00 
     c2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

00000c30 <parsepipe>:
{
     c30:	55                   	push   %ebp
     c31:	89 e5                	mov    %esp,%ebp
     c33:	57                   	push   %edi
     c34:	56                   	push   %esi
     c35:	53                   	push   %ebx
     c36:	83 ec 14             	sub    $0x14,%esp
     c39:	8b 75 08             	mov    0x8(%ebp),%esi
     c3c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parseexec(ps, es);
     c3f:	57                   	push   %edi
     c40:	56                   	push   %esi
     c41:	e8 ca fe ff ff       	call   b10 <parseexec>
  if(peek(ps, es, "|")){
     c46:	83 c4 0c             	add    $0xc,%esp
     c49:	68 72 16 00 00       	push   $0x1672
  cmd = parseexec(ps, es);
     c4e:	89 c3                	mov    %eax,%ebx
  if(peek(ps, es, "|")){
     c50:	57                   	push   %edi
     c51:	56                   	push   %esi
     c52:	e8 f9 fc ff ff       	call   950 <peek>
     c57:	83 c4 10             	add    $0x10,%esp
     c5a:	85 c0                	test   %eax,%eax
     c5c:	75 12                	jne    c70 <parsepipe+0x40>
}
     c5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c61:	89 d8                	mov    %ebx,%eax
     c63:	5b                   	pop    %ebx
     c64:	5e                   	pop    %esi
     c65:	5f                   	pop    %edi
     c66:	5d                   	pop    %ebp
     c67:	c3                   	ret
     c68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     c6f:	00 
    gettoken(ps, es, 0, 0);
     c70:	6a 00                	push   $0x0
     c72:	6a 00                	push   $0x0
     c74:	57                   	push   %edi
     c75:	56                   	push   %esi
     c76:	e8 65 fb ff ff       	call   7e0 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     c7b:	58                   	pop    %eax
     c7c:	5a                   	pop    %edx
     c7d:	57                   	push   %edi
     c7e:	56                   	push   %esi
     c7f:	e8 ac ff ff ff       	call   c30 <parsepipe>
  cmd = malloc(sizeof(*cmd));
     c84:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
    cmd = pipecmd(cmd, parsepipe(ps, es));
     c8b:	89 c7                	mov    %eax,%edi
  cmd = malloc(sizeof(*cmd));
     c8d:	e8 7e 08 00 00       	call   1510 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     c92:	83 c4 0c             	add    $0xc,%esp
     c95:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     c97:	89 c6                	mov    %eax,%esi
  memset(cmd, 0, sizeof(*cmd));
     c99:	6a 00                	push   $0x0
     c9b:	50                   	push   %eax
     c9c:	e8 5f 03 00 00       	call   1000 <memset>
  cmd->left = left;
     ca1:	89 5e 04             	mov    %ebx,0x4(%esi)
  cmd->right = right;
     ca4:	83 c4 10             	add    $0x10,%esp
    cmd = pipecmd(cmd, parsepipe(ps, es));
     ca7:	89 f3                	mov    %esi,%ebx
  cmd->type = PIPE;
     ca9:	c7 06 03 00 00 00    	movl   $0x3,(%esi)
}
     caf:	89 d8                	mov    %ebx,%eax
  cmd->right = right;
     cb1:	89 7e 08             	mov    %edi,0x8(%esi)
}
     cb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
     cb7:	5b                   	pop    %ebx
     cb8:	5e                   	pop    %esi
     cb9:	5f                   	pop    %edi
     cba:	5d                   	pop    %ebp
     cbb:	c3                   	ret
     cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000cc0 <parseline>:
{
     cc0:	55                   	push   %ebp
     cc1:	89 e5                	mov    %esp,%ebp
     cc3:	57                   	push   %edi
     cc4:	56                   	push   %esi
     cc5:	53                   	push   %ebx
     cc6:	83 ec 24             	sub    $0x24,%esp
     cc9:	8b 75 08             	mov    0x8(%ebp),%esi
     ccc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parsepipe(ps, es);
     ccf:	57                   	push   %edi
     cd0:	56                   	push   %esi
     cd1:	e8 5a ff ff ff       	call   c30 <parsepipe>
  while(peek(ps, es, "&")){
     cd6:	83 c4 10             	add    $0x10,%esp
  cmd = parsepipe(ps, es);
     cd9:	89 c3                	mov    %eax,%ebx
  while(peek(ps, es, "&")){
     cdb:	eb 3b                	jmp    d18 <parseline+0x58>
     cdd:	8d 76 00             	lea    0x0(%esi),%esi
    gettoken(ps, es, 0, 0);
     ce0:	6a 00                	push   $0x0
     ce2:	6a 00                	push   $0x0
     ce4:	57                   	push   %edi
     ce5:	56                   	push   %esi
     ce6:	e8 f5 fa ff ff       	call   7e0 <gettoken>
  cmd = malloc(sizeof(*cmd));
     ceb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     cf2:	e8 19 08 00 00       	call   1510 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     cf7:	83 c4 0c             	add    $0xc,%esp
     cfa:	6a 08                	push   $0x8
     cfc:	6a 00                	push   $0x0
     cfe:	50                   	push   %eax
     cff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
     d02:	e8 f9 02 00 00       	call   1000 <memset>
  cmd->type = BACK;
     d07:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  cmd->cmd = subcmd;
     d0a:	83 c4 10             	add    $0x10,%esp
  cmd->type = BACK;
     d0d:	c7 02 05 00 00 00    	movl   $0x5,(%edx)
  cmd->cmd = subcmd;
     d13:	89 5a 04             	mov    %ebx,0x4(%edx)
    cmd = backcmd(cmd);
     d16:	89 d3                	mov    %edx,%ebx
  while(peek(ps, es, "&")){
     d18:	83 ec 04             	sub    $0x4,%esp
     d1b:	68 74 16 00 00       	push   $0x1674
     d20:	57                   	push   %edi
     d21:	56                   	push   %esi
     d22:	e8 29 fc ff ff       	call   950 <peek>
     d27:	83 c4 10             	add    $0x10,%esp
     d2a:	85 c0                	test   %eax,%eax
     d2c:	75 b2                	jne    ce0 <parseline+0x20>
  if(peek(ps, es, ";")){
     d2e:	83 ec 04             	sub    $0x4,%esp
     d31:	68 70 16 00 00       	push   $0x1670
     d36:	57                   	push   %edi
     d37:	56                   	push   %esi
     d38:	e8 13 fc ff ff       	call   950 <peek>
     d3d:	83 c4 10             	add    $0x10,%esp
     d40:	85 c0                	test   %eax,%eax
     d42:	75 0c                	jne    d50 <parseline+0x90>
}
     d44:	8d 65 f4             	lea    -0xc(%ebp),%esp
     d47:	89 d8                	mov    %ebx,%eax
     d49:	5b                   	pop    %ebx
     d4a:	5e                   	pop    %esi
     d4b:	5f                   	pop    %edi
     d4c:	5d                   	pop    %ebp
     d4d:	c3                   	ret
     d4e:	66 90                	xchg   %ax,%ax
    gettoken(ps, es, 0, 0);
     d50:	6a 00                	push   $0x0
     d52:	6a 00                	push   $0x0
     d54:	57                   	push   %edi
     d55:	56                   	push   %esi
     d56:	e8 85 fa ff ff       	call   7e0 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     d5b:	58                   	pop    %eax
     d5c:	5a                   	pop    %edx
     d5d:	57                   	push   %edi
     d5e:	56                   	push   %esi
     d5f:	e8 5c ff ff ff       	call   cc0 <parseline>
  cmd = malloc(sizeof(*cmd));
     d64:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
    cmd = listcmd(cmd, parseline(ps, es));
     d6b:	89 c7                	mov    %eax,%edi
  cmd = malloc(sizeof(*cmd));
     d6d:	e8 9e 07 00 00       	call   1510 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     d72:	83 c4 0c             	add    $0xc,%esp
     d75:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     d77:	89 c6                	mov    %eax,%esi
  memset(cmd, 0, sizeof(*cmd));
     d79:	6a 00                	push   $0x0
     d7b:	50                   	push   %eax
     d7c:	e8 7f 02 00 00       	call   1000 <memset>
  cmd->left = left;
     d81:	89 5e 04             	mov    %ebx,0x4(%esi)
  cmd->right = right;
     d84:	83 c4 10             	add    $0x10,%esp
    cmd = listcmd(cmd, parseline(ps, es));
     d87:	89 f3                	mov    %esi,%ebx
  cmd->type = LIST;
     d89:	c7 06 04 00 00 00    	movl   $0x4,(%esi)
}
     d8f:	89 d8                	mov    %ebx,%eax
  cmd->right = right;
     d91:	89 7e 08             	mov    %edi,0x8(%esi)
}
     d94:	8d 65 f4             	lea    -0xc(%ebp),%esp
     d97:	5b                   	pop    %ebx
     d98:	5e                   	pop    %esi
     d99:	5f                   	pop    %edi
     d9a:	5d                   	pop    %ebp
     d9b:	c3                   	ret
     d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000da0 <parseblock>:
{
     da0:	55                   	push   %ebp
     da1:	89 e5                	mov    %esp,%ebp
     da3:	57                   	push   %edi
     da4:	56                   	push   %esi
     da5:	53                   	push   %ebx
     da6:	83 ec 10             	sub    $0x10,%esp
     da9:	8b 5d 08             	mov    0x8(%ebp),%ebx
     dac:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(!peek(ps, es, "("))
     daf:	68 56 16 00 00       	push   $0x1656
     db4:	56                   	push   %esi
     db5:	53                   	push   %ebx
     db6:	e8 95 fb ff ff       	call   950 <peek>
     dbb:	83 c4 10             	add    $0x10,%esp
     dbe:	85 c0                	test   %eax,%eax
     dc0:	74 4a                	je     e0c <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
     dc2:	6a 00                	push   $0x0
     dc4:	6a 00                	push   $0x0
     dc6:	56                   	push   %esi
     dc7:	53                   	push   %ebx
     dc8:	e8 13 fa ff ff       	call   7e0 <gettoken>
  cmd = parseline(ps, es);
     dcd:	58                   	pop    %eax
     dce:	5a                   	pop    %edx
     dcf:	56                   	push   %esi
     dd0:	53                   	push   %ebx
     dd1:	e8 ea fe ff ff       	call   cc0 <parseline>
  if(!peek(ps, es, ")"))
     dd6:	83 c4 0c             	add    $0xc,%esp
     dd9:	68 92 16 00 00       	push   $0x1692
  cmd = parseline(ps, es);
     dde:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
     de0:	56                   	push   %esi
     de1:	53                   	push   %ebx
     de2:	e8 69 fb ff ff       	call   950 <peek>
     de7:	83 c4 10             	add    $0x10,%esp
     dea:	85 c0                	test   %eax,%eax
     dec:	74 2b                	je     e19 <parseblock+0x79>
  gettoken(ps, es, 0, 0);
     dee:	6a 00                	push   $0x0
     df0:	6a 00                	push   $0x0
     df2:	56                   	push   %esi
     df3:	53                   	push   %ebx
     df4:	e8 e7 f9 ff ff       	call   7e0 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     df9:	83 c4 0c             	add    $0xc,%esp
     dfc:	56                   	push   %esi
     dfd:	53                   	push   %ebx
     dfe:	57                   	push   %edi
     dff:	e8 cc fb ff ff       	call   9d0 <parseredirs>
}
     e04:	8d 65 f4             	lea    -0xc(%ebp),%esp
     e07:	5b                   	pop    %ebx
     e08:	5e                   	pop    %esi
     e09:	5f                   	pop    %edi
     e0a:	5d                   	pop    %ebp
     e0b:	c3                   	ret
    panic("parseblock");
     e0c:	83 ec 0c             	sub    $0xc,%esp
     e0f:	68 76 16 00 00       	push   $0x1676
     e14:	e8 c7 f6 ff ff       	call   4e0 <panic>
    panic("syntax - missing )");
     e19:	83 ec 0c             	sub    $0xc,%esp
     e1c:	68 81 16 00 00       	push   $0x1681
     e21:	e8 ba f6 ff ff       	call   4e0 <panic>
     e26:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     e2d:	00 
     e2e:	66 90                	xchg   %ax,%ax

00000e30 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     e30:	55                   	push   %ebp
     e31:	89 e5                	mov    %esp,%ebp
     e33:	53                   	push   %ebx
     e34:	83 ec 04             	sub    $0x4,%esp
     e37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     e3a:	85 db                	test   %ebx,%ebx
     e3c:	74 29                	je     e67 <nulterminate+0x37>
    return 0;

  switch(cmd->type){
     e3e:	83 3b 05             	cmpl   $0x5,(%ebx)
     e41:	77 24                	ja     e67 <nulterminate+0x37>
     e43:	8b 03                	mov    (%ebx),%eax
     e45:	ff 24 85 40 17 00 00 	jmp    *0x1740(,%eax,4)
     e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    nulterminate(pcmd->right);
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    nulterminate(lcmd->left);
     e50:	83 ec 0c             	sub    $0xc,%esp
     e53:	ff 73 04             	push   0x4(%ebx)
     e56:	e8 d5 ff ff ff       	call   e30 <nulterminate>
    nulterminate(lcmd->right);
     e5b:	58                   	pop    %eax
     e5c:	ff 73 08             	push   0x8(%ebx)
     e5f:	e8 cc ff ff ff       	call   e30 <nulterminate>
    break;
     e64:	83 c4 10             	add    $0x10,%esp
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     e67:	89 d8                	mov    %ebx,%eax
     e69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     e6c:	c9                   	leave
     e6d:	c3                   	ret
     e6e:	66 90                	xchg   %ax,%ax
    nulterminate(bcmd->cmd);
     e70:	83 ec 0c             	sub    $0xc,%esp
     e73:	ff 73 04             	push   0x4(%ebx)
     e76:	e8 b5 ff ff ff       	call   e30 <nulterminate>
}
     e7b:	89 d8                	mov    %ebx,%eax
    break;
     e7d:	83 c4 10             	add    $0x10,%esp
}
     e80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     e83:	c9                   	leave
     e84:	c3                   	ret
     e85:	8d 76 00             	lea    0x0(%esi),%esi
    for(i=0; ecmd->argv[i]; i++)
     e88:	8b 4b 04             	mov    0x4(%ebx),%ecx
     e8b:	85 c9                	test   %ecx,%ecx
     e8d:	74 d8                	je     e67 <nulterminate+0x37>
     e8f:	8d 43 08             	lea    0x8(%ebx),%eax
     e92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      *ecmd->eargv[i] = 0;
     e98:	8b 50 24             	mov    0x24(%eax),%edx
    for(i=0; ecmd->argv[i]; i++)
     e9b:	83 c0 04             	add    $0x4,%eax
      *ecmd->eargv[i] = 0;
     e9e:	c6 02 00             	movb   $0x0,(%edx)
    for(i=0; ecmd->argv[i]; i++)
     ea1:	8b 50 fc             	mov    -0x4(%eax),%edx
     ea4:	85 d2                	test   %edx,%edx
     ea6:	75 f0                	jne    e98 <nulterminate+0x68>
}
     ea8:	89 d8                	mov    %ebx,%eax
     eaa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     ead:	c9                   	leave
     eae:	c3                   	ret
     eaf:	90                   	nop
    nulterminate(rcmd->cmd);
     eb0:	83 ec 0c             	sub    $0xc,%esp
     eb3:	ff 73 04             	push   0x4(%ebx)
     eb6:	e8 75 ff ff ff       	call   e30 <nulterminate>
    *rcmd->efile = 0;
     ebb:	8b 43 0c             	mov    0xc(%ebx),%eax
    break;
     ebe:	83 c4 10             	add    $0x10,%esp
    *rcmd->efile = 0;
     ec1:	c6 00 00             	movb   $0x0,(%eax)
}
     ec4:	89 d8                	mov    %ebx,%eax
     ec6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     ec9:	c9                   	leave
     eca:	c3                   	ret
     ecb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

00000ed0 <parsecmd>:
{
     ed0:	55                   	push   %ebp
     ed1:	89 e5                	mov    %esp,%ebp
     ed3:	57                   	push   %edi
     ed4:	56                   	push   %esi
  cmd = parseline(&s, es);
     ed5:	8d 7d 08             	lea    0x8(%ebp),%edi
{
     ed8:	53                   	push   %ebx
     ed9:	83 ec 18             	sub    $0x18,%esp
  es = s + strlen(s);
     edc:	8b 5d 08             	mov    0x8(%ebp),%ebx
     edf:	53                   	push   %ebx
     ee0:	e8 eb 00 00 00       	call   fd0 <strlen>
  cmd = parseline(&s, es);
     ee5:	59                   	pop    %ecx
     ee6:	5e                   	pop    %esi
  es = s + strlen(s);
     ee7:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
     ee9:	53                   	push   %ebx
     eea:	57                   	push   %edi
     eeb:	e8 d0 fd ff ff       	call   cc0 <parseline>
  peek(&s, es, "");
     ef0:	83 c4 0c             	add    $0xc,%esp
     ef3:	68 04 16 00 00       	push   $0x1604
  cmd = parseline(&s, es);
     ef8:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
     efa:	53                   	push   %ebx
     efb:	57                   	push   %edi
     efc:	e8 4f fa ff ff       	call   950 <peek>
  if(s != es){
     f01:	8b 45 08             	mov    0x8(%ebp),%eax
     f04:	83 c4 10             	add    $0x10,%esp
     f07:	39 d8                	cmp    %ebx,%eax
     f09:	75 13                	jne    f1e <parsecmd+0x4e>
  nulterminate(cmd);
     f0b:	83 ec 0c             	sub    $0xc,%esp
     f0e:	56                   	push   %esi
     f0f:	e8 1c ff ff ff       	call   e30 <nulterminate>
}
     f14:	8d 65 f4             	lea    -0xc(%ebp),%esp
     f17:	89 f0                	mov    %esi,%eax
     f19:	5b                   	pop    %ebx
     f1a:	5e                   	pop    %esi
     f1b:	5f                   	pop    %edi
     f1c:	5d                   	pop    %ebp
     f1d:	c3                   	ret
    printf(2, "leftovers: %s\n", s);
     f1e:	52                   	push   %edx
     f1f:	50                   	push   %eax
     f20:	68 94 16 00 00       	push   $0x1694
     f25:	6a 02                	push   $0x2
     f27:	e8 c4 03 00 00       	call   12f0 <printf>
    panic("syntax");
     f2c:	c7 04 24 58 16 00 00 	movl   $0x1658,(%esp)
     f33:	e8 a8 f5 ff ff       	call   4e0 <panic>
     f38:	66 90                	xchg   %ax,%ax
     f3a:	66 90                	xchg   %ax,%ax
     f3c:	66 90                	xchg   %ax,%ax
     f3e:	66 90                	xchg   %ax,%ax

00000f40 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
     f40:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     f41:	31 c0                	xor    %eax,%eax
{
     f43:	89 e5                	mov    %esp,%ebp
     f45:	53                   	push   %ebx
     f46:	8b 4d 08             	mov    0x8(%ebp),%ecx
     f49:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
     f50:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
     f54:	88 14 01             	mov    %dl,(%ecx,%eax,1)
     f57:	83 c0 01             	add    $0x1,%eax
     f5a:	84 d2                	test   %dl,%dl
     f5c:	75 f2                	jne    f50 <strcpy+0x10>
    ;
  return os;
}
     f5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     f61:	89 c8                	mov    %ecx,%eax
     f63:	c9                   	leave
     f64:	c3                   	ret
     f65:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     f6c:	00 
     f6d:	8d 76 00             	lea    0x0(%esi),%esi

00000f70 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     f70:	55                   	push   %ebp
     f71:	89 e5                	mov    %esp,%ebp
     f73:	53                   	push   %ebx
     f74:	8b 55 08             	mov    0x8(%ebp),%edx
     f77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
     f7a:	0f b6 02             	movzbl (%edx),%eax
     f7d:	84 c0                	test   %al,%al
     f7f:	75 17                	jne    f98 <strcmp+0x28>
     f81:	eb 3a                	jmp    fbd <strcmp+0x4d>
     f83:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
     f88:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
     f8c:	83 c2 01             	add    $0x1,%edx
     f8f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
     f92:	84 c0                	test   %al,%al
     f94:	74 1a                	je     fb0 <strcmp+0x40>
     f96:	89 d9                	mov    %ebx,%ecx
     f98:	0f b6 19             	movzbl (%ecx),%ebx
     f9b:	38 c3                	cmp    %al,%bl
     f9d:	74 e9                	je     f88 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
     f9f:	29 d8                	sub    %ebx,%eax
}
     fa1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     fa4:	c9                   	leave
     fa5:	c3                   	ret
     fa6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     fad:	00 
     fae:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
     fb0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
     fb4:	31 c0                	xor    %eax,%eax
     fb6:	29 d8                	sub    %ebx,%eax
}
     fb8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     fbb:	c9                   	leave
     fbc:	c3                   	ret
  return (uchar)*p - (uchar)*q;
     fbd:	0f b6 19             	movzbl (%ecx),%ebx
     fc0:	31 c0                	xor    %eax,%eax
     fc2:	eb db                	jmp    f9f <strcmp+0x2f>
     fc4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     fcb:	00 
     fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000fd0 <strlen>:

uint
strlen(const char *s)
{
     fd0:	55                   	push   %ebp
     fd1:	89 e5                	mov    %esp,%ebp
     fd3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
     fd6:	80 3a 00             	cmpb   $0x0,(%edx)
     fd9:	74 15                	je     ff0 <strlen+0x20>
     fdb:	31 c0                	xor    %eax,%eax
     fdd:	8d 76 00             	lea    0x0(%esi),%esi
     fe0:	83 c0 01             	add    $0x1,%eax
     fe3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
     fe7:	89 c1                	mov    %eax,%ecx
     fe9:	75 f5                	jne    fe0 <strlen+0x10>
    ;
  return n;
}
     feb:	89 c8                	mov    %ecx,%eax
     fed:	5d                   	pop    %ebp
     fee:	c3                   	ret
     fef:	90                   	nop
  for(n = 0; s[n]; n++)
     ff0:	31 c9                	xor    %ecx,%ecx
}
     ff2:	5d                   	pop    %ebp
     ff3:	89 c8                	mov    %ecx,%eax
     ff5:	c3                   	ret
     ff6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     ffd:	00 
     ffe:	66 90                	xchg   %ax,%ax

00001000 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	57                   	push   %edi
    1004:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    1007:	8b 4d 10             	mov    0x10(%ebp),%ecx
    100a:	8b 45 0c             	mov    0xc(%ebp),%eax
    100d:	89 d7                	mov    %edx,%edi
    100f:	fc                   	cld
    1010:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    1012:	8b 7d fc             	mov    -0x4(%ebp),%edi
    1015:	89 d0                	mov    %edx,%eax
    1017:	c9                   	leave
    1018:	c3                   	ret
    1019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001020 <strchr>:

char*
strchr(const char *s, char c)
{
    1020:	55                   	push   %ebp
    1021:	89 e5                	mov    %esp,%ebp
    1023:	8b 45 08             	mov    0x8(%ebp),%eax
    1026:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
    102a:	0f b6 10             	movzbl (%eax),%edx
    102d:	84 d2                	test   %dl,%dl
    102f:	75 12                	jne    1043 <strchr+0x23>
    1031:	eb 1d                	jmp    1050 <strchr+0x30>
    1033:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    1038:	0f b6 50 01          	movzbl 0x1(%eax),%edx
    103c:	83 c0 01             	add    $0x1,%eax
    103f:	84 d2                	test   %dl,%dl
    1041:	74 0d                	je     1050 <strchr+0x30>
    if(*s == c)
    1043:	38 d1                	cmp    %dl,%cl
    1045:	75 f1                	jne    1038 <strchr+0x18>
      return (char*)s;
  return 0;
}
    1047:	5d                   	pop    %ebp
    1048:	c3                   	ret
    1049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
    1050:	31 c0                	xor    %eax,%eax
}
    1052:	5d                   	pop    %ebp
    1053:	c3                   	ret
    1054:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    105b:	00 
    105c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001060 <gets>:

char*
gets(char *buf, int max)
{
    1060:	55                   	push   %ebp
    1061:	89 e5                	mov    %esp,%ebp
    1063:	57                   	push   %edi
    1064:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    1065:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
    1068:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
    1069:	31 db                	xor    %ebx,%ebx
{
    106b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
    106e:	eb 27                	jmp    1097 <gets+0x37>
    cc = read(0, &c, 1);
    1070:	83 ec 04             	sub    $0x4,%esp
    1073:	6a 01                	push   $0x1
    1075:	56                   	push   %esi
    1076:	6a 00                	push   $0x0
    1078:	e8 1e 01 00 00       	call   119b <read>
    if(cc < 1)
    107d:	83 c4 10             	add    $0x10,%esp
    1080:	85 c0                	test   %eax,%eax
    1082:	7e 1d                	jle    10a1 <gets+0x41>
      break;
    buf[i++] = c;
    1084:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    1088:	8b 55 08             	mov    0x8(%ebp),%edx
    108b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
    108f:	3c 0a                	cmp    $0xa,%al
    1091:	74 10                	je     10a3 <gets+0x43>
    1093:	3c 0d                	cmp    $0xd,%al
    1095:	74 0c                	je     10a3 <gets+0x43>
  for(i=0; i+1 < max; ){
    1097:	89 df                	mov    %ebx,%edi
    1099:	83 c3 01             	add    $0x1,%ebx
    109c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    109f:	7c cf                	jl     1070 <gets+0x10>
    10a1:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
    10a3:	8b 45 08             	mov    0x8(%ebp),%eax
    10a6:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
    10aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
    10ad:	5b                   	pop    %ebx
    10ae:	5e                   	pop    %esi
    10af:	5f                   	pop    %edi
    10b0:	5d                   	pop    %ebp
    10b1:	c3                   	ret
    10b2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    10b9:	00 
    10ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000010c0 <stat>:

int
stat(const char *n, struct stat *st)
{
    10c0:	55                   	push   %ebp
    10c1:	89 e5                	mov    %esp,%ebp
    10c3:	56                   	push   %esi
    10c4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    10c5:	83 ec 08             	sub    $0x8,%esp
    10c8:	6a 00                	push   $0x0
    10ca:	ff 75 08             	push   0x8(%ebp)
    10cd:	e8 f1 00 00 00       	call   11c3 <open>
  if(fd < 0)
    10d2:	83 c4 10             	add    $0x10,%esp
    10d5:	85 c0                	test   %eax,%eax
    10d7:	78 27                	js     1100 <stat+0x40>
    return -1;
  r = fstat(fd, st);
    10d9:	83 ec 08             	sub    $0x8,%esp
    10dc:	ff 75 0c             	push   0xc(%ebp)
    10df:	89 c3                	mov    %eax,%ebx
    10e1:	50                   	push   %eax
    10e2:	e8 f4 00 00 00       	call   11db <fstat>
  close(fd);
    10e7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    10ea:	89 c6                	mov    %eax,%esi
  close(fd);
    10ec:	e8 ba 00 00 00       	call   11ab <close>
  return r;
    10f1:	83 c4 10             	add    $0x10,%esp
}
    10f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
    10f7:	89 f0                	mov    %esi,%eax
    10f9:	5b                   	pop    %ebx
    10fa:	5e                   	pop    %esi
    10fb:	5d                   	pop    %ebp
    10fc:	c3                   	ret
    10fd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
    1100:	be ff ff ff ff       	mov    $0xffffffff,%esi
    1105:	eb ed                	jmp    10f4 <stat+0x34>
    1107:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    110e:	00 
    110f:	90                   	nop

00001110 <atoi>:

int
atoi(const char *s)
{
    1110:	55                   	push   %ebp
    1111:	89 e5                	mov    %esp,%ebp
    1113:	53                   	push   %ebx
    1114:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1117:	0f be 02             	movsbl (%edx),%eax
    111a:	8d 48 d0             	lea    -0x30(%eax),%ecx
    111d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
    1120:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
    1125:	77 1e                	ja     1145 <atoi+0x35>
    1127:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    112e:	00 
    112f:	90                   	nop
    n = n*10 + *s++ - '0';
    1130:	83 c2 01             	add    $0x1,%edx
    1133:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
    1136:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
    113a:	0f be 02             	movsbl (%edx),%eax
    113d:	8d 58 d0             	lea    -0x30(%eax),%ebx
    1140:	80 fb 09             	cmp    $0x9,%bl
    1143:	76 eb                	jbe    1130 <atoi+0x20>
  return n;
}
    1145:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1148:	89 c8                	mov    %ecx,%eax
    114a:	c9                   	leave
    114b:	c3                   	ret
    114c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001150 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1150:	55                   	push   %ebp
    1151:	89 e5                	mov    %esp,%ebp
    1153:	57                   	push   %edi
    1154:	8b 45 10             	mov    0x10(%ebp),%eax
    1157:	8b 55 08             	mov    0x8(%ebp),%edx
    115a:	56                   	push   %esi
    115b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    115e:	85 c0                	test   %eax,%eax
    1160:	7e 13                	jle    1175 <memmove+0x25>
    1162:	01 d0                	add    %edx,%eax
  dst = vdst;
    1164:	89 d7                	mov    %edx,%edi
    1166:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    116d:	00 
    116e:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
    1170:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
    1171:	39 f8                	cmp    %edi,%eax
    1173:	75 fb                	jne    1170 <memmove+0x20>
  return vdst;
}
    1175:	5e                   	pop    %esi
    1176:	89 d0                	mov    %edx,%eax
    1178:	5f                   	pop    %edi
    1179:	5d                   	pop    %ebp
    117a:	c3                   	ret

0000117b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    117b:	b8 01 00 00 00       	mov    $0x1,%eax
    1180:	cd 40                	int    $0x40
    1182:	c3                   	ret

00001183 <exit>:
SYSCALL(exit)
    1183:	b8 02 00 00 00       	mov    $0x2,%eax
    1188:	cd 40                	int    $0x40
    118a:	c3                   	ret

0000118b <wait>:
SYSCALL(wait)
    118b:	b8 03 00 00 00       	mov    $0x3,%eax
    1190:	cd 40                	int    $0x40
    1192:	c3                   	ret

00001193 <pipe>:
SYSCALL(pipe)
    1193:	b8 04 00 00 00       	mov    $0x4,%eax
    1198:	cd 40                	int    $0x40
    119a:	c3                   	ret

0000119b <read>:
SYSCALL(read)
    119b:	b8 05 00 00 00       	mov    $0x5,%eax
    11a0:	cd 40                	int    $0x40
    11a2:	c3                   	ret

000011a3 <write>:
SYSCALL(write)
    11a3:	b8 10 00 00 00       	mov    $0x10,%eax
    11a8:	cd 40                	int    $0x40
    11aa:	c3                   	ret

000011ab <close>:
SYSCALL(close)
    11ab:	b8 15 00 00 00       	mov    $0x15,%eax
    11b0:	cd 40                	int    $0x40
    11b2:	c3                   	ret

000011b3 <kill>:
SYSCALL(kill)
    11b3:	b8 06 00 00 00       	mov    $0x6,%eax
    11b8:	cd 40                	int    $0x40
    11ba:	c3                   	ret

000011bb <exec>:
SYSCALL(exec)
    11bb:	b8 07 00 00 00       	mov    $0x7,%eax
    11c0:	cd 40                	int    $0x40
    11c2:	c3                   	ret

000011c3 <open>:
SYSCALL(open)
    11c3:	b8 0f 00 00 00       	mov    $0xf,%eax
    11c8:	cd 40                	int    $0x40
    11ca:	c3                   	ret

000011cb <mknod>:
SYSCALL(mknod)
    11cb:	b8 11 00 00 00       	mov    $0x11,%eax
    11d0:	cd 40                	int    $0x40
    11d2:	c3                   	ret

000011d3 <unlink>:
SYSCALL(unlink)
    11d3:	b8 12 00 00 00       	mov    $0x12,%eax
    11d8:	cd 40                	int    $0x40
    11da:	c3                   	ret

000011db <fstat>:
SYSCALL(fstat)
    11db:	b8 08 00 00 00       	mov    $0x8,%eax
    11e0:	cd 40                	int    $0x40
    11e2:	c3                   	ret

000011e3 <link>:
SYSCALL(link)
    11e3:	b8 13 00 00 00       	mov    $0x13,%eax
    11e8:	cd 40                	int    $0x40
    11ea:	c3                   	ret

000011eb <mkdir>:
SYSCALL(mkdir)
    11eb:	b8 14 00 00 00       	mov    $0x14,%eax
    11f0:	cd 40                	int    $0x40
    11f2:	c3                   	ret

000011f3 <chdir>:
SYSCALL(chdir)
    11f3:	b8 09 00 00 00       	mov    $0x9,%eax
    11f8:	cd 40                	int    $0x40
    11fa:	c3                   	ret

000011fb <dup>:
SYSCALL(dup)
    11fb:	b8 0a 00 00 00       	mov    $0xa,%eax
    1200:	cd 40                	int    $0x40
    1202:	c3                   	ret

00001203 <getpid>:
SYSCALL(getpid)
    1203:	b8 0b 00 00 00       	mov    $0xb,%eax
    1208:	cd 40                	int    $0x40
    120a:	c3                   	ret

0000120b <sbrk>:
SYSCALL(sbrk)
    120b:	b8 0c 00 00 00       	mov    $0xc,%eax
    1210:	cd 40                	int    $0x40
    1212:	c3                   	ret

00001213 <sleep>:
SYSCALL(sleep)
    1213:	b8 0d 00 00 00       	mov    $0xd,%eax
    1218:	cd 40                	int    $0x40
    121a:	c3                   	ret

0000121b <uptime>:
SYSCALL(uptime)
    121b:	b8 0e 00 00 00       	mov    $0xe,%eax
    1220:	cd 40                	int    $0x40
    1222:	c3                   	ret

00001223 <gethistory>:
SYSCALL(gethistory)
    1223:	b8 16 00 00 00       	mov    $0x16,%eax
    1228:	cd 40                	int    $0x40
    122a:	c3                   	ret

0000122b <block>:
SYSCALL(block)
    122b:	b8 17 00 00 00       	mov    $0x17,%eax
    1230:	cd 40                	int    $0x40
    1232:	c3                   	ret

00001233 <unblock>:
SYSCALL(unblock)
    1233:	b8 18 00 00 00       	mov    $0x18,%eax
    1238:	cd 40                	int    $0x40
    123a:	c3                   	ret

0000123b <chmod>:
SYSCALL(chmod)
    123b:	b8 19 00 00 00       	mov    $0x19,%eax
    1240:	cd 40                	int    $0x40
    1242:	c3                   	ret
    1243:	66 90                	xchg   %ax,%ax
    1245:	66 90                	xchg   %ax,%ax
    1247:	66 90                	xchg   %ax,%ax
    1249:	66 90                	xchg   %ax,%ax
    124b:	66 90                	xchg   %ax,%ax
    124d:	66 90                	xchg   %ax,%ax
    124f:	90                   	nop

00001250 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    1250:	55                   	push   %ebp
    1251:	89 e5                	mov    %esp,%ebp
    1253:	57                   	push   %edi
    1254:	56                   	push   %esi
    1255:	53                   	push   %ebx
    1256:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    1258:	89 d1                	mov    %edx,%ecx
{
    125a:	83 ec 3c             	sub    $0x3c,%esp
    125d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
    1260:	85 d2                	test   %edx,%edx
    1262:	0f 89 80 00 00 00    	jns    12e8 <printint+0x98>
    1268:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    126c:	74 7a                	je     12e8 <printint+0x98>
    x = -xx;
    126e:	f7 d9                	neg    %ecx
    neg = 1;
    1270:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
    1275:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    1278:	31 f6                	xor    %esi,%esi
    127a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
    1280:	89 c8                	mov    %ecx,%eax
    1282:	31 d2                	xor    %edx,%edx
    1284:	89 f7                	mov    %esi,%edi
    1286:	f7 f3                	div    %ebx
    1288:	8d 76 01             	lea    0x1(%esi),%esi
    128b:	0f b6 92 b0 17 00 00 	movzbl 0x17b0(%edx),%edx
    1292:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
    1296:	89 ca                	mov    %ecx,%edx
    1298:	89 c1                	mov    %eax,%ecx
    129a:	39 da                	cmp    %ebx,%edx
    129c:	73 e2                	jae    1280 <printint+0x30>
  if(neg)
    129e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
    12a1:	85 c0                	test   %eax,%eax
    12a3:	74 07                	je     12ac <printint+0x5c>
    buf[i++] = '-';
    12a5:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
    12aa:	89 f7                	mov    %esi,%edi
    12ac:	8d 5d d8             	lea    -0x28(%ebp),%ebx
    12af:	8b 75 c0             	mov    -0x40(%ebp),%esi
    12b2:	01 df                	add    %ebx,%edi
    12b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
    12b8:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
    12bb:	83 ec 04             	sub    $0x4,%esp
    12be:	88 45 d7             	mov    %al,-0x29(%ebp)
    12c1:	8d 45 d7             	lea    -0x29(%ebp),%eax
    12c4:	6a 01                	push   $0x1
    12c6:	50                   	push   %eax
    12c7:	56                   	push   %esi
    12c8:	e8 d6 fe ff ff       	call   11a3 <write>
  while(--i >= 0)
    12cd:	89 f8                	mov    %edi,%eax
    12cf:	83 c4 10             	add    $0x10,%esp
    12d2:	83 ef 01             	sub    $0x1,%edi
    12d5:	39 c3                	cmp    %eax,%ebx
    12d7:	75 df                	jne    12b8 <printint+0x68>
}
    12d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
    12dc:	5b                   	pop    %ebx
    12dd:	5e                   	pop    %esi
    12de:	5f                   	pop    %edi
    12df:	5d                   	pop    %ebp
    12e0:	c3                   	ret
    12e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    12e8:	31 c0                	xor    %eax,%eax
    12ea:	eb 89                	jmp    1275 <printint+0x25>
    12ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000012f0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    12f0:	55                   	push   %ebp
    12f1:	89 e5                	mov    %esp,%ebp
    12f3:	57                   	push   %edi
    12f4:	56                   	push   %esi
    12f5:	53                   	push   %ebx
    12f6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    12f9:	8b 75 0c             	mov    0xc(%ebp),%esi
{
    12fc:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
    12ff:	0f b6 1e             	movzbl (%esi),%ebx
    1302:	83 c6 01             	add    $0x1,%esi
    1305:	84 db                	test   %bl,%bl
    1307:	74 67                	je     1370 <printf+0x80>
    1309:	8d 4d 10             	lea    0x10(%ebp),%ecx
    130c:	31 d2                	xor    %edx,%edx
    130e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
    1311:	eb 34                	jmp    1347 <printf+0x57>
    1313:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    1318:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    131b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
    1320:	83 f8 25             	cmp    $0x25,%eax
    1323:	74 18                	je     133d <printf+0x4d>
  write(fd, &c, 1);
    1325:	83 ec 04             	sub    $0x4,%esp
    1328:	8d 45 e7             	lea    -0x19(%ebp),%eax
    132b:	88 5d e7             	mov    %bl,-0x19(%ebp)
    132e:	6a 01                	push   $0x1
    1330:	50                   	push   %eax
    1331:	57                   	push   %edi
    1332:	e8 6c fe ff ff       	call   11a3 <write>
    1337:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
    133a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    133d:	0f b6 1e             	movzbl (%esi),%ebx
    1340:	83 c6 01             	add    $0x1,%esi
    1343:	84 db                	test   %bl,%bl
    1345:	74 29                	je     1370 <printf+0x80>
    c = fmt[i] & 0xff;
    1347:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    134a:	85 d2                	test   %edx,%edx
    134c:	74 ca                	je     1318 <printf+0x28>
      }
    } else if(state == '%'){
    134e:	83 fa 25             	cmp    $0x25,%edx
    1351:	75 ea                	jne    133d <printf+0x4d>
      if(c == 'd'){
    1353:	83 f8 25             	cmp    $0x25,%eax
    1356:	0f 84 04 01 00 00    	je     1460 <printf+0x170>
    135c:	83 e8 63             	sub    $0x63,%eax
    135f:	83 f8 15             	cmp    $0x15,%eax
    1362:	77 1c                	ja     1380 <printf+0x90>
    1364:	ff 24 85 58 17 00 00 	jmp    *0x1758(,%eax,4)
    136b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1370:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1373:	5b                   	pop    %ebx
    1374:	5e                   	pop    %esi
    1375:	5f                   	pop    %edi
    1376:	5d                   	pop    %ebp
    1377:	c3                   	ret
    1378:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    137f:	00 
  write(fd, &c, 1);
    1380:	83 ec 04             	sub    $0x4,%esp
    1383:	8d 55 e7             	lea    -0x19(%ebp),%edx
    1386:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    138a:	6a 01                	push   $0x1
    138c:	52                   	push   %edx
    138d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    1390:	57                   	push   %edi
    1391:	e8 0d fe ff ff       	call   11a3 <write>
    1396:	83 c4 0c             	add    $0xc,%esp
    1399:	88 5d e7             	mov    %bl,-0x19(%ebp)
    139c:	6a 01                	push   $0x1
    139e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
    13a1:	52                   	push   %edx
    13a2:	57                   	push   %edi
    13a3:	e8 fb fd ff ff       	call   11a3 <write>
        putc(fd, c);
    13a8:	83 c4 10             	add    $0x10,%esp
      state = 0;
    13ab:	31 d2                	xor    %edx,%edx
    13ad:	eb 8e                	jmp    133d <printf+0x4d>
    13af:	90                   	nop
        printint(fd, *ap, 16, 0);
    13b0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
    13b3:	83 ec 0c             	sub    $0xc,%esp
    13b6:	b9 10 00 00 00       	mov    $0x10,%ecx
    13bb:	8b 13                	mov    (%ebx),%edx
    13bd:	6a 00                	push   $0x0
    13bf:	89 f8                	mov    %edi,%eax
        ap++;
    13c1:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
    13c4:	e8 87 fe ff ff       	call   1250 <printint>
        ap++;
    13c9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
    13cc:	83 c4 10             	add    $0x10,%esp
      state = 0;
    13cf:	31 d2                	xor    %edx,%edx
    13d1:	e9 67 ff ff ff       	jmp    133d <printf+0x4d>
        s = (char*)*ap;
    13d6:	8b 45 d0             	mov    -0x30(%ebp),%eax
    13d9:	8b 18                	mov    (%eax),%ebx
        ap++;
    13db:	83 c0 04             	add    $0x4,%eax
    13de:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    13e1:	85 db                	test   %ebx,%ebx
    13e3:	0f 84 87 00 00 00    	je     1470 <printf+0x180>
        while(*s != 0){
    13e9:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
    13ec:	31 d2                	xor    %edx,%edx
        while(*s != 0){
    13ee:	84 c0                	test   %al,%al
    13f0:	0f 84 47 ff ff ff    	je     133d <printf+0x4d>
    13f6:	8d 55 e7             	lea    -0x19(%ebp),%edx
    13f9:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    13fc:	89 de                	mov    %ebx,%esi
    13fe:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
    1400:	83 ec 04             	sub    $0x4,%esp
    1403:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
    1406:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
    1409:	6a 01                	push   $0x1
    140b:	53                   	push   %ebx
    140c:	57                   	push   %edi
    140d:	e8 91 fd ff ff       	call   11a3 <write>
        while(*s != 0){
    1412:	0f b6 06             	movzbl (%esi),%eax
    1415:	83 c4 10             	add    $0x10,%esp
    1418:	84 c0                	test   %al,%al
    141a:	75 e4                	jne    1400 <printf+0x110>
      state = 0;
    141c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
    141f:	31 d2                	xor    %edx,%edx
    1421:	e9 17 ff ff ff       	jmp    133d <printf+0x4d>
        printint(fd, *ap, 10, 1);
    1426:	8b 5d d0             	mov    -0x30(%ebp),%ebx
    1429:	83 ec 0c             	sub    $0xc,%esp
    142c:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1431:	8b 13                	mov    (%ebx),%edx
    1433:	6a 01                	push   $0x1
    1435:	eb 88                	jmp    13bf <printf+0xcf>
        putc(fd, *ap);
    1437:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
    143a:	83 ec 04             	sub    $0x4,%esp
    143d:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
    1440:	8b 03                	mov    (%ebx),%eax
        ap++;
    1442:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
    1445:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    1448:	6a 01                	push   $0x1
    144a:	52                   	push   %edx
    144b:	57                   	push   %edi
    144c:	e8 52 fd ff ff       	call   11a3 <write>
        ap++;
    1451:	89 5d d0             	mov    %ebx,-0x30(%ebp)
    1454:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1457:	31 d2                	xor    %edx,%edx
    1459:	e9 df fe ff ff       	jmp    133d <printf+0x4d>
    145e:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
    1460:	83 ec 04             	sub    $0x4,%esp
    1463:	88 5d e7             	mov    %bl,-0x19(%ebp)
    1466:	8d 55 e7             	lea    -0x19(%ebp),%edx
    1469:	6a 01                	push   $0x1
    146b:	e9 31 ff ff ff       	jmp    13a1 <printf+0xb1>
    1470:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
    1475:	bb f6 16 00 00       	mov    $0x16f6,%ebx
    147a:	e9 77 ff ff ff       	jmp    13f6 <printf+0x106>
    147f:	90                   	nop

00001480 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1480:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1481:	a1 84 1e 00 00       	mov    0x1e84,%eax
{
    1486:	89 e5                	mov    %esp,%ebp
    1488:	57                   	push   %edi
    1489:	56                   	push   %esi
    148a:	53                   	push   %ebx
    148b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
    148e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1498:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    149a:	39 c8                	cmp    %ecx,%eax
    149c:	73 32                	jae    14d0 <free+0x50>
    149e:	39 d1                	cmp    %edx,%ecx
    14a0:	72 04                	jb     14a6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    14a2:	39 d0                	cmp    %edx,%eax
    14a4:	72 32                	jb     14d8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
    14a6:	8b 73 fc             	mov    -0x4(%ebx),%esi
    14a9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    14ac:	39 fa                	cmp    %edi,%edx
    14ae:	74 30                	je     14e0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    14b0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    14b3:	8b 50 04             	mov    0x4(%eax),%edx
    14b6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    14b9:	39 f1                	cmp    %esi,%ecx
    14bb:	74 3a                	je     14f7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    14bd:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
    14bf:	5b                   	pop    %ebx
  freep = p;
    14c0:	a3 84 1e 00 00       	mov    %eax,0x1e84
}
    14c5:	5e                   	pop    %esi
    14c6:	5f                   	pop    %edi
    14c7:	5d                   	pop    %ebp
    14c8:	c3                   	ret
    14c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    14d0:	39 d0                	cmp    %edx,%eax
    14d2:	72 04                	jb     14d8 <free+0x58>
    14d4:	39 d1                	cmp    %edx,%ecx
    14d6:	72 ce                	jb     14a6 <free+0x26>
{
    14d8:	89 d0                	mov    %edx,%eax
    14da:	eb bc                	jmp    1498 <free+0x18>
    14dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
    14e0:	03 72 04             	add    0x4(%edx),%esi
    14e3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    14e6:	8b 10                	mov    (%eax),%edx
    14e8:	8b 12                	mov    (%edx),%edx
    14ea:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    14ed:	8b 50 04             	mov    0x4(%eax),%edx
    14f0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    14f3:	39 f1                	cmp    %esi,%ecx
    14f5:	75 c6                	jne    14bd <free+0x3d>
    p->s.size += bp->s.size;
    14f7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
    14fa:	a3 84 1e 00 00       	mov    %eax,0x1e84
    p->s.size += bp->s.size;
    14ff:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1502:	8b 4b f8             	mov    -0x8(%ebx),%ecx
    1505:	89 08                	mov    %ecx,(%eax)
}
    1507:	5b                   	pop    %ebx
    1508:	5e                   	pop    %esi
    1509:	5f                   	pop    %edi
    150a:	5d                   	pop    %ebp
    150b:	c3                   	ret
    150c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001510 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1510:	55                   	push   %ebp
    1511:	89 e5                	mov    %esp,%ebp
    1513:	57                   	push   %edi
    1514:	56                   	push   %esi
    1515:	53                   	push   %ebx
    1516:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1519:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    151c:	8b 15 84 1e 00 00    	mov    0x1e84,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1522:	8d 78 07             	lea    0x7(%eax),%edi
    1525:	c1 ef 03             	shr    $0x3,%edi
    1528:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
    152b:	85 d2                	test   %edx,%edx
    152d:	0f 84 8d 00 00 00    	je     15c0 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1533:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    1535:	8b 48 04             	mov    0x4(%eax),%ecx
    1538:	39 f9                	cmp    %edi,%ecx
    153a:	73 64                	jae    15a0 <malloc+0x90>
  if(nu < 4096)
    153c:	bb 00 10 00 00       	mov    $0x1000,%ebx
    1541:	39 df                	cmp    %ebx,%edi
    1543:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
    1546:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
    154d:	eb 0a                	jmp    1559 <malloc+0x49>
    154f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1550:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    1552:	8b 48 04             	mov    0x4(%eax),%ecx
    1555:	39 f9                	cmp    %edi,%ecx
    1557:	73 47                	jae    15a0 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1559:	89 c2                	mov    %eax,%edx
    155b:	3b 05 84 1e 00 00    	cmp    0x1e84,%eax
    1561:	75 ed                	jne    1550 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
    1563:	83 ec 0c             	sub    $0xc,%esp
    1566:	56                   	push   %esi
    1567:	e8 9f fc ff ff       	call   120b <sbrk>
  if(p == (char*)-1)
    156c:	83 c4 10             	add    $0x10,%esp
    156f:	83 f8 ff             	cmp    $0xffffffff,%eax
    1572:	74 1c                	je     1590 <malloc+0x80>
  hp->s.size = nu;
    1574:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    1577:	83 ec 0c             	sub    $0xc,%esp
    157a:	83 c0 08             	add    $0x8,%eax
    157d:	50                   	push   %eax
    157e:	e8 fd fe ff ff       	call   1480 <free>
  return freep;
    1583:	8b 15 84 1e 00 00    	mov    0x1e84,%edx
      if((p = morecore(nunits)) == 0)
    1589:	83 c4 10             	add    $0x10,%esp
    158c:	85 d2                	test   %edx,%edx
    158e:	75 c0                	jne    1550 <malloc+0x40>
        return 0;
  }
}
    1590:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    1593:	31 c0                	xor    %eax,%eax
}
    1595:	5b                   	pop    %ebx
    1596:	5e                   	pop    %esi
    1597:	5f                   	pop    %edi
    1598:	5d                   	pop    %ebp
    1599:	c3                   	ret
    159a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
    15a0:	39 cf                	cmp    %ecx,%edi
    15a2:	74 4c                	je     15f0 <malloc+0xe0>
        p->s.size -= nunits;
    15a4:	29 f9                	sub    %edi,%ecx
    15a6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    15a9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    15ac:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
    15af:	89 15 84 1e 00 00    	mov    %edx,0x1e84
}
    15b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    15b8:	83 c0 08             	add    $0x8,%eax
}
    15bb:	5b                   	pop    %ebx
    15bc:	5e                   	pop    %esi
    15bd:	5f                   	pop    %edi
    15be:	5d                   	pop    %ebp
    15bf:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
    15c0:	c7 05 84 1e 00 00 88 	movl   $0x1e88,0x1e84
    15c7:	1e 00 00 
    base.s.size = 0;
    15ca:	b8 88 1e 00 00       	mov    $0x1e88,%eax
    base.s.ptr = freep = prevp = &base;
    15cf:	c7 05 88 1e 00 00 88 	movl   $0x1e88,0x1e88
    15d6:	1e 00 00 
    base.s.size = 0;
    15d9:	c7 05 8c 1e 00 00 00 	movl   $0x0,0x1e8c
    15e0:	00 00 00 
    if(p->s.size >= nunits){
    15e3:	e9 54 ff ff ff       	jmp    153c <malloc+0x2c>
    15e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    15ef:	00 
        prevp->s.ptr = p->s.ptr;
    15f0:	8b 08                	mov    (%eax),%ecx
    15f2:	89 0a                	mov    %ecx,(%edx)
    15f4:	eb b9                	jmp    15af <malloc+0x9f>
