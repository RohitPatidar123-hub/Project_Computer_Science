
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    return 1;
  else
    return 0;
}

int main(void) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   f:	83 ec 08             	sub    $0x8,%esp
  12:	6a 02                	push   $0x2
  14:	68 ba 09 00 00       	push   $0x9ba
  19:	e8 05 05 00 00       	call   523 <open>
  1e:	83 c4 10             	add    $0x10,%esp
  21:	85 c0                	test   %eax,%eax
  23:	0f 88 98 00 00 00    	js     c1 <main+0xc1>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  29:	83 ec 0c             	sub    $0xc,%esp
  2c:	6a 00                	push   $0x0
  2e:	e8 28 05 00 00       	call   55b <dup>
  dup(0);  // stderr
  33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  3a:	e8 1c 05 00 00       	call   55b <dup>
  if(login() == 1)
  3f:	e8 0c 01 00 00       	call   150 <login>
  44:	83 c4 10             	add    $0x10,%esp
  47:	83 f8 01             	cmp    $0x1,%eax
  4a:	74 2c                	je     78 <main+0x78>

  // Check login credentials before launching the shell.
  if(checkAuthentication() == 0) {
    printf(1, "Authentication failed. Exiting init.\n");
  4c:	50                   	push   %eax
  4d:	50                   	push   %eax
  4e:	68 48 0a 00 00       	push   $0xa48
  53:	6a 01                	push   $0x1
  55:	e8 f6 05 00 00       	call   650 <printf>
  5a:	83 c4 10             	add    $0x10,%esp
  5d:	8d 76 00             	lea    0x0(%esi),%esi
     while(1) {
        sleep(1000);
  60:	83 ec 0c             	sub    $0xc,%esp
  63:	68 e8 03 00 00       	push   $0x3e8
  68:	e8 06 05 00 00       	call   573 <sleep>
  6d:	83 c4 10             	add    $0x10,%esp
  70:	eb ee                	jmp    60 <main+0x60>
  72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
  }

  // Authentication succeeded; launch the shell.
  for(;;) {
    printf(1, "init: starting sh\n");
  78:	83 ec 08             	sub    $0x8,%esp
  7b:	68 c2 09 00 00       	push   $0x9c2
  80:	6a 01                	push   $0x1
  82:	e8 c9 05 00 00       	call   650 <printf>
    pid = fork();
  87:	e8 4f 04 00 00       	call   4db <fork>
    if(pid < 0){
  8c:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  8f:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
  91:	85 c0                	test   %eax,%eax
  93:	78 51                	js     e6 <main+0xe6>
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0){
  95:	74 62                	je     f9 <main+0xf9>
  97:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  9e:	00 
  9f:	90                   	nop
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid = wait()) >= 0 && wpid != pid)
  a0:	e8 46 04 00 00       	call   4eb <wait>
  a5:	85 c0                	test   %eax,%eax
  a7:	78 cf                	js     78 <main+0x78>
  a9:	39 c3                	cmp    %eax,%ebx
  ab:	74 cb                	je     78 <main+0x78>
      printf(1, "zombie!\n");
  ad:	83 ec 08             	sub    $0x8,%esp
  b0:	68 01 0a 00 00       	push   $0xa01
  b5:	6a 01                	push   $0x1
  b7:	e8 94 05 00 00       	call   650 <printf>
  bc:	83 c4 10             	add    $0x10,%esp
  bf:	eb df                	jmp    a0 <main+0xa0>
    mknod("console", 1, 1);
  c1:	50                   	push   %eax
  c2:	6a 01                	push   $0x1
  c4:	6a 01                	push   $0x1
  c6:	68 ba 09 00 00       	push   $0x9ba
  cb:	e8 5b 04 00 00       	call   52b <mknod>
    open("console", O_RDWR);
  d0:	58                   	pop    %eax
  d1:	5a                   	pop    %edx
  d2:	6a 02                	push   $0x2
  d4:	68 ba 09 00 00       	push   $0x9ba
  d9:	e8 45 04 00 00       	call   523 <open>
  de:	83 c4 10             	add    $0x10,%esp
  e1:	e9 43 ff ff ff       	jmp    29 <main+0x29>
      printf(1, "init: fork failed\n");
  e6:	53                   	push   %ebx
  e7:	53                   	push   %ebx
  e8:	68 d5 09 00 00       	push   $0x9d5
  ed:	6a 01                	push   $0x1
  ef:	e8 5c 05 00 00       	call   650 <printf>
      exit();
  f4:	e8 ea 03 00 00       	call   4e3 <exit>
      exec("sh", argv);
  f9:	50                   	push   %eax
  fa:	50                   	push   %eax
  fb:	68 d8 0d 00 00       	push   $0xdd8
 100:	68 e8 09 00 00       	push   $0x9e8
 105:	e8 11 04 00 00       	call   51b <exec>
      printf(1, "init: exec sh failed\n");
 10a:	5a                   	pop    %edx
 10b:	59                   	pop    %ecx
 10c:	68 eb 09 00 00       	push   $0x9eb
 111:	6a 01                	push   $0x1
 113:	e8 38 05 00 00       	call   650 <printf>
      exit();
 118:	e8 c6 03 00 00       	call   4e3 <exit>
 11d:	66 90                	xchg   %ax,%ax
 11f:	90                   	nop

00000120 <trim>:
void trim(char *s) {
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	8b 45 08             	mov    0x8(%ebp),%eax
  for(i = 0; s[i] != '\0'; i++){
 126:	0f b6 10             	movzbl (%eax),%edx
 129:	84 d2                	test   %dl,%dl
 12b:	75 0e                	jne    13b <trim+0x1b>
 12d:	eb 14                	jmp    143 <trim+0x23>
 12f:	90                   	nop
 130:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 134:	83 c0 01             	add    $0x1,%eax
 137:	84 d2                	test   %dl,%dl
 139:	74 08                	je     143 <trim+0x23>
    if(s[i] == '\n'){
 13b:	80 fa 0a             	cmp    $0xa,%dl
 13e:	75 f0                	jne    130 <trim+0x10>
      s[i] = '\0';
 140:	c6 00 00             	movb   $0x0,(%eax)
}
 143:	5d                   	pop    %ebp
 144:	c3                   	ret
 145:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 14c:	00 
 14d:	8d 76 00             	lea    0x0(%esi),%esi

00000150 <login>:
int login(void) {
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	57                   	push   %edi
 154:	56                   	push   %esi
 155:	be 03 00 00 00       	mov    $0x3,%esi
 15a:	53                   	push   %ebx
 15b:	8d 5d a8             	lea    -0x58(%ebp),%ebx
 15e:	83 ec 4c             	sub    $0x4c,%esp
    printf(1, "Enter username: ");
 161:	83 ec 08             	sub    $0x8,%esp
 164:	68 58 09 00 00       	push   $0x958
 169:	6a 01                	push   $0x1
 16b:	e8 e0 04 00 00       	call   650 <printf>
    gets(username, sizeof(username));
 170:	59                   	pop    %ecx
 171:	5f                   	pop    %edi
 172:	6a 20                	push   $0x20
 174:	53                   	push   %ebx
 175:	e8 46 02 00 00       	call   3c0 <gets>
  for(i = 0; s[i] != '\0'; i++){
 17a:	0f b6 45 a8          	movzbl -0x58(%ebp),%eax
 17e:	83 c4 10             	add    $0x10,%esp
 181:	84 c0                	test   %al,%al
 183:	74 1d                	je     1a2 <login+0x52>
 185:	89 da                	mov    %ebx,%edx
 187:	eb 12                	jmp    19b <login+0x4b>
 189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 190:	0f b6 42 01          	movzbl 0x1(%edx),%eax
 194:	83 c2 01             	add    $0x1,%edx
 197:	84 c0                	test   %al,%al
 199:	74 07                	je     1a2 <login+0x52>
    if(s[i] == '\n'){
 19b:	3c 0a                	cmp    $0xa,%al
 19d:	75 f1                	jne    190 <login+0x40>
      s[i] = '\0';
 19f:	c6 02 00             	movb   $0x0,(%edx)
    if(strcmp(username, USERNAME) == 0) {
 1a2:	83 ec 08             	sub    $0x8,%esp
 1a5:	68 69 09 00 00       	push   $0x969
 1aa:	53                   	push   %ebx
 1ab:	e8 20 01 00 00       	call   2d0 <strcmp>
 1b0:	83 c4 10             	add    $0x10,%esp
 1b3:	85 c0                	test   %eax,%eax
 1b5:	74 39                	je     1f0 <login+0xa0>
      printf(1, "Incorrect username\n");
 1b7:	83 ec 08             	sub    $0x8,%esp
 1ba:	68 a6 09 00 00       	push   $0x9a6
 1bf:	6a 01                	push   $0x1
 1c1:	e8 8a 04 00 00       	call   650 <printf>
 1c6:	83 c4 10             	add    $0x10,%esp
  while(attempts < ATTEMP) {
 1c9:	83 ee 01             	sub    $0x1,%esi
 1cc:	75 93                	jne    161 <login+0x11>
  printf(1, "Maximum login attempts exceeded. Login disabled.\n");
 1ce:	83 ec 08             	sub    $0x8,%esp
 1d1:	68 14 0a 00 00       	push   $0xa14
 1d6:	6a 01                	push   $0x1
 1d8:	e8 73 04 00 00       	call   650 <printf>
  return 0;  // Invalid login
 1dd:	83 c4 10             	add    $0x10,%esp
 1e0:	31 c0                	xor    %eax,%eax
}
 1e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1e5:	5b                   	pop    %ebx
 1e6:	5e                   	pop    %esi
 1e7:	5f                   	pop    %edi
 1e8:	5d                   	pop    %ebp
 1e9:	c3                   	ret
 1ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      printf(1, "Enter password: ");
 1f0:	83 ec 08             	sub    $0x8,%esp
      gets(password, sizeof(password));
 1f3:	8d 7d c8             	lea    -0x38(%ebp),%edi
      printf(1, "Enter password: ");
 1f6:	68 6f 09 00 00       	push   $0x96f
 1fb:	6a 01                	push   $0x1
 1fd:	e8 4e 04 00 00       	call   650 <printf>
      gets(password, sizeof(password));
 202:	58                   	pop    %eax
 203:	5a                   	pop    %edx
 204:	6a 20                	push   $0x20
 206:	57                   	push   %edi
 207:	e8 b4 01 00 00       	call   3c0 <gets>
  for(i = 0; s[i] != '\0'; i++){
 20c:	0f b6 45 c8          	movzbl -0x38(%ebp),%eax
 210:	83 c4 10             	add    $0x10,%esp
 213:	84 c0                	test   %al,%al
 215:	74 1b                	je     232 <login+0xe2>
 217:	89 fa                	mov    %edi,%edx
 219:	eb 10                	jmp    22b <login+0xdb>
 21b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 220:	0f b6 42 01          	movzbl 0x1(%edx),%eax
 224:	83 c2 01             	add    $0x1,%edx
 227:	84 c0                	test   %al,%al
 229:	74 07                	je     232 <login+0xe2>
    if(s[i] == '\n'){
 22b:	3c 0a                	cmp    $0xa,%al
 22d:	75 f1                	jne    220 <login+0xd0>
      s[i] = '\0';
 22f:	c6 02 00             	movb   $0x0,(%edx)
      if(strcmp(password, PASSWORD) == 0) {
 232:	83 ec 08             	sub    $0x8,%esp
 235:	68 69 09 00 00       	push   $0x969
 23a:	57                   	push   %edi
 23b:	e8 90 00 00 00       	call   2d0 <strcmp>
 240:	83 c4 10             	add    $0x10,%esp
 243:	85 c0                	test   %eax,%eax
 245:	74 17                	je     25e <login+0x10e>
        printf(1, "Incorrect password\n");
 247:	83 ec 08             	sub    $0x8,%esp
 24a:	68 92 09 00 00       	push   $0x992
 24f:	6a 01                	push   $0x1
 251:	e8 fa 03 00 00       	call   650 <printf>
        attempts++;
 256:	83 c4 10             	add    $0x10,%esp
 259:	e9 6b ff ff ff       	jmp    1c9 <login+0x79>
        printf(1, "Login successful\n");
 25e:	83 ec 08             	sub    $0x8,%esp
 261:	68 80 09 00 00       	push   $0x980
 266:	6a 01                	push   $0x1
 268:	e8 e3 03 00 00       	call   650 <printf>
        return 1;  // Valid login
 26d:	83 c4 10             	add    $0x10,%esp
 270:	b8 01 00 00 00       	mov    $0x1,%eax
 275:	e9 68 ff ff ff       	jmp    1e2 <login+0x92>
 27a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000280 <checkAuthentication>:
int checkAuthentication(void) {
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	83 ec 08             	sub    $0x8,%esp
  if(login() == 1)
 286:	e8 c5 fe ff ff       	call   150 <login>
}
 28b:	c9                   	leave
  if(login() == 1)
 28c:	83 f8 01             	cmp    $0x1,%eax
 28f:	0f 94 c0             	sete   %al
 292:	0f b6 c0             	movzbl %al,%eax
}
 295:	c3                   	ret
 296:	66 90                	xchg   %ax,%ax
 298:	66 90                	xchg   %ax,%ax
 29a:	66 90                	xchg   %ax,%ax
 29c:	66 90                	xchg   %ax,%ax
 29e:	66 90                	xchg   %ax,%ax

000002a0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 2a0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2a1:	31 c0                	xor    %eax,%eax
{
 2a3:	89 e5                	mov    %esp,%ebp
 2a5:	53                   	push   %ebx
 2a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 2ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 2b0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 2b4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 2b7:	83 c0 01             	add    $0x1,%eax
 2ba:	84 d2                	test   %dl,%dl
 2bc:	75 f2                	jne    2b0 <strcpy+0x10>
    ;
  return os;
}
 2be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2c1:	89 c8                	mov    %ecx,%eax
 2c3:	c9                   	leave
 2c4:	c3                   	ret
 2c5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2cc:	00 
 2cd:	8d 76 00             	lea    0x0(%esi),%esi

000002d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	53                   	push   %ebx
 2d4:	8b 55 08             	mov    0x8(%ebp),%edx
 2d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 2da:	0f b6 02             	movzbl (%edx),%eax
 2dd:	84 c0                	test   %al,%al
 2df:	75 17                	jne    2f8 <strcmp+0x28>
 2e1:	eb 3a                	jmp    31d <strcmp+0x4d>
 2e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 2e8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 2ec:	83 c2 01             	add    $0x1,%edx
 2ef:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 2f2:	84 c0                	test   %al,%al
 2f4:	74 1a                	je     310 <strcmp+0x40>
 2f6:	89 d9                	mov    %ebx,%ecx
 2f8:	0f b6 19             	movzbl (%ecx),%ebx
 2fb:	38 c3                	cmp    %al,%bl
 2fd:	74 e9                	je     2e8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 2ff:	29 d8                	sub    %ebx,%eax
}
 301:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 304:	c9                   	leave
 305:	c3                   	ret
 306:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 30d:	00 
 30e:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
 310:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 314:	31 c0                	xor    %eax,%eax
 316:	29 d8                	sub    %ebx,%eax
}
 318:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 31b:	c9                   	leave
 31c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 31d:	0f b6 19             	movzbl (%ecx),%ebx
 320:	31 c0                	xor    %eax,%eax
 322:	eb db                	jmp    2ff <strcmp+0x2f>
 324:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 32b:	00 
 32c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000330 <strlen>:

uint
strlen(const char *s)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 336:	80 3a 00             	cmpb   $0x0,(%edx)
 339:	74 15                	je     350 <strlen+0x20>
 33b:	31 c0                	xor    %eax,%eax
 33d:	8d 76 00             	lea    0x0(%esi),%esi
 340:	83 c0 01             	add    $0x1,%eax
 343:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 347:	89 c1                	mov    %eax,%ecx
 349:	75 f5                	jne    340 <strlen+0x10>
    ;
  return n;
}
 34b:	89 c8                	mov    %ecx,%eax
 34d:	5d                   	pop    %ebp
 34e:	c3                   	ret
 34f:	90                   	nop
  for(n = 0; s[n]; n++)
 350:	31 c9                	xor    %ecx,%ecx
}
 352:	5d                   	pop    %ebp
 353:	89 c8                	mov    %ecx,%eax
 355:	c3                   	ret
 356:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 35d:	00 
 35e:	66 90                	xchg   %ax,%ax

00000360 <memset>:

void*
memset(void *dst, int c, uint n)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	57                   	push   %edi
 364:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 367:	8b 4d 10             	mov    0x10(%ebp),%ecx
 36a:	8b 45 0c             	mov    0xc(%ebp),%eax
 36d:	89 d7                	mov    %edx,%edi
 36f:	fc                   	cld
 370:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 372:	8b 7d fc             	mov    -0x4(%ebp),%edi
 375:	89 d0                	mov    %edx,%eax
 377:	c9                   	leave
 378:	c3                   	ret
 379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000380 <strchr>:

char*
strchr(const char *s, char c)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	8b 45 08             	mov    0x8(%ebp),%eax
 386:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 38a:	0f b6 10             	movzbl (%eax),%edx
 38d:	84 d2                	test   %dl,%dl
 38f:	75 12                	jne    3a3 <strchr+0x23>
 391:	eb 1d                	jmp    3b0 <strchr+0x30>
 393:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 398:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 39c:	83 c0 01             	add    $0x1,%eax
 39f:	84 d2                	test   %dl,%dl
 3a1:	74 0d                	je     3b0 <strchr+0x30>
    if(*s == c)
 3a3:	38 d1                	cmp    %dl,%cl
 3a5:	75 f1                	jne    398 <strchr+0x18>
      return (char*)s;
  return 0;
}
 3a7:	5d                   	pop    %ebp
 3a8:	c3                   	ret
 3a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 3b0:	31 c0                	xor    %eax,%eax
}
 3b2:	5d                   	pop    %ebp
 3b3:	c3                   	ret
 3b4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 3bb:	00 
 3bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003c0 <gets>:

char*
gets(char *buf, int max)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	57                   	push   %edi
 3c4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 3c5:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 3c8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 3c9:	31 db                	xor    %ebx,%ebx
{
 3cb:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 3ce:	eb 27                	jmp    3f7 <gets+0x37>
    cc = read(0, &c, 1);
 3d0:	83 ec 04             	sub    $0x4,%esp
 3d3:	6a 01                	push   $0x1
 3d5:	56                   	push   %esi
 3d6:	6a 00                	push   $0x0
 3d8:	e8 1e 01 00 00       	call   4fb <read>
    if(cc < 1)
 3dd:	83 c4 10             	add    $0x10,%esp
 3e0:	85 c0                	test   %eax,%eax
 3e2:	7e 1d                	jle    401 <gets+0x41>
      break;
    buf[i++] = c;
 3e4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3e8:	8b 55 08             	mov    0x8(%ebp),%edx
 3eb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 3ef:	3c 0a                	cmp    $0xa,%al
 3f1:	74 10                	je     403 <gets+0x43>
 3f3:	3c 0d                	cmp    $0xd,%al
 3f5:	74 0c                	je     403 <gets+0x43>
  for(i=0; i+1 < max; ){
 3f7:	89 df                	mov    %ebx,%edi
 3f9:	83 c3 01             	add    $0x1,%ebx
 3fc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3ff:	7c cf                	jl     3d0 <gets+0x10>
 401:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 403:	8b 45 08             	mov    0x8(%ebp),%eax
 406:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 40a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 40d:	5b                   	pop    %ebx
 40e:	5e                   	pop    %esi
 40f:	5f                   	pop    %edi
 410:	5d                   	pop    %ebp
 411:	c3                   	ret
 412:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 419:	00 
 41a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000420 <stat>:

int
stat(const char *n, struct stat *st)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	56                   	push   %esi
 424:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 425:	83 ec 08             	sub    $0x8,%esp
 428:	6a 00                	push   $0x0
 42a:	ff 75 08             	push   0x8(%ebp)
 42d:	e8 f1 00 00 00       	call   523 <open>
  if(fd < 0)
 432:	83 c4 10             	add    $0x10,%esp
 435:	85 c0                	test   %eax,%eax
 437:	78 27                	js     460 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 439:	83 ec 08             	sub    $0x8,%esp
 43c:	ff 75 0c             	push   0xc(%ebp)
 43f:	89 c3                	mov    %eax,%ebx
 441:	50                   	push   %eax
 442:	e8 f4 00 00 00       	call   53b <fstat>
  close(fd);
 447:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 44a:	89 c6                	mov    %eax,%esi
  close(fd);
 44c:	e8 ba 00 00 00       	call   50b <close>
  return r;
 451:	83 c4 10             	add    $0x10,%esp
}
 454:	8d 65 f8             	lea    -0x8(%ebp),%esp
 457:	89 f0                	mov    %esi,%eax
 459:	5b                   	pop    %ebx
 45a:	5e                   	pop    %esi
 45b:	5d                   	pop    %ebp
 45c:	c3                   	ret
 45d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 460:	be ff ff ff ff       	mov    $0xffffffff,%esi
 465:	eb ed                	jmp    454 <stat+0x34>
 467:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 46e:	00 
 46f:	90                   	nop

00000470 <atoi>:

int
atoi(const char *s)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	53                   	push   %ebx
 474:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 477:	0f be 02             	movsbl (%edx),%eax
 47a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 47d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 480:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 485:	77 1e                	ja     4a5 <atoi+0x35>
 487:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 48e:	00 
 48f:	90                   	nop
    n = n*10 + *s++ - '0';
 490:	83 c2 01             	add    $0x1,%edx
 493:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 496:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 49a:	0f be 02             	movsbl (%edx),%eax
 49d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 4a0:	80 fb 09             	cmp    $0x9,%bl
 4a3:	76 eb                	jbe    490 <atoi+0x20>
  return n;
}
 4a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4a8:	89 c8                	mov    %ecx,%eax
 4aa:	c9                   	leave
 4ab:	c3                   	ret
 4ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000004b0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	57                   	push   %edi
 4b4:	8b 45 10             	mov    0x10(%ebp),%eax
 4b7:	8b 55 08             	mov    0x8(%ebp),%edx
 4ba:	56                   	push   %esi
 4bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4be:	85 c0                	test   %eax,%eax
 4c0:	7e 13                	jle    4d5 <memmove+0x25>
 4c2:	01 d0                	add    %edx,%eax
  dst = vdst;
 4c4:	89 d7                	mov    %edx,%edi
 4c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 4cd:	00 
 4ce:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 4d0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 4d1:	39 f8                	cmp    %edi,%eax
 4d3:	75 fb                	jne    4d0 <memmove+0x20>
  return vdst;
}
 4d5:	5e                   	pop    %esi
 4d6:	89 d0                	mov    %edx,%eax
 4d8:	5f                   	pop    %edi
 4d9:	5d                   	pop    %ebp
 4da:	c3                   	ret

000004db <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4db:	b8 01 00 00 00       	mov    $0x1,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret

000004e3 <exit>:
SYSCALL(exit)
 4e3:	b8 02 00 00 00       	mov    $0x2,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret

000004eb <wait>:
SYSCALL(wait)
 4eb:	b8 03 00 00 00       	mov    $0x3,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret

000004f3 <pipe>:
SYSCALL(pipe)
 4f3:	b8 04 00 00 00       	mov    $0x4,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret

000004fb <read>:
SYSCALL(read)
 4fb:	b8 05 00 00 00       	mov    $0x5,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret

00000503 <write>:
SYSCALL(write)
 503:	b8 10 00 00 00       	mov    $0x10,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret

0000050b <close>:
SYSCALL(close)
 50b:	b8 15 00 00 00       	mov    $0x15,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret

00000513 <kill>:
SYSCALL(kill)
 513:	b8 06 00 00 00       	mov    $0x6,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret

0000051b <exec>:
SYSCALL(exec)
 51b:	b8 07 00 00 00       	mov    $0x7,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret

00000523 <open>:
SYSCALL(open)
 523:	b8 0f 00 00 00       	mov    $0xf,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret

0000052b <mknod>:
SYSCALL(mknod)
 52b:	b8 11 00 00 00       	mov    $0x11,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret

00000533 <unlink>:
SYSCALL(unlink)
 533:	b8 12 00 00 00       	mov    $0x12,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret

0000053b <fstat>:
SYSCALL(fstat)
 53b:	b8 08 00 00 00       	mov    $0x8,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret

00000543 <link>:
SYSCALL(link)
 543:	b8 13 00 00 00       	mov    $0x13,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret

0000054b <mkdir>:
SYSCALL(mkdir)
 54b:	b8 14 00 00 00       	mov    $0x14,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret

00000553 <chdir>:
SYSCALL(chdir)
 553:	b8 09 00 00 00       	mov    $0x9,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret

0000055b <dup>:
SYSCALL(dup)
 55b:	b8 0a 00 00 00       	mov    $0xa,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret

00000563 <getpid>:
SYSCALL(getpid)
 563:	b8 0b 00 00 00       	mov    $0xb,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret

0000056b <sbrk>:
SYSCALL(sbrk)
 56b:	b8 0c 00 00 00       	mov    $0xc,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret

00000573 <sleep>:
SYSCALL(sleep)
 573:	b8 0d 00 00 00       	mov    $0xd,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret

0000057b <uptime>:
SYSCALL(uptime)
 57b:	b8 0e 00 00 00       	mov    $0xe,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret

00000583 <gethistory>:
SYSCALL(gethistory)
 583:	b8 16 00 00 00       	mov    $0x16,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret

0000058b <block>:
SYSCALL(block)
 58b:	b8 17 00 00 00       	mov    $0x17,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret

00000593 <unblock>:
SYSCALL(unblock)
 593:	b8 18 00 00 00       	mov    $0x18,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret

0000059b <chmod>:
SYSCALL(chmod)
 59b:	b8 19 00 00 00       	mov    $0x19,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret
 5a3:	66 90                	xchg   %ax,%ax
 5a5:	66 90                	xchg   %ax,%ax
 5a7:	66 90                	xchg   %ax,%ax
 5a9:	66 90                	xchg   %ax,%ax
 5ab:	66 90                	xchg   %ax,%ax
 5ad:	66 90                	xchg   %ax,%ax
 5af:	90                   	nop

000005b0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 5b0:	55                   	push   %ebp
 5b1:	89 e5                	mov    %esp,%ebp
 5b3:	57                   	push   %edi
 5b4:	56                   	push   %esi
 5b5:	53                   	push   %ebx
 5b6:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 5b8:	89 d1                	mov    %edx,%ecx
{
 5ba:	83 ec 3c             	sub    $0x3c,%esp
 5bd:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 5c0:	85 d2                	test   %edx,%edx
 5c2:	0f 89 80 00 00 00    	jns    648 <printint+0x98>
 5c8:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 5cc:	74 7a                	je     648 <printint+0x98>
    x = -xx;
 5ce:	f7 d9                	neg    %ecx
    neg = 1;
 5d0:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 5d5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 5d8:	31 f6                	xor    %esi,%esi
 5da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 5e0:	89 c8                	mov    %ecx,%eax
 5e2:	31 d2                	xor    %edx,%edx
 5e4:	89 f7                	mov    %esi,%edi
 5e6:	f7 f3                	div    %ebx
 5e8:	8d 76 01             	lea    0x1(%esi),%esi
 5eb:	0f b6 92 c8 0a 00 00 	movzbl 0xac8(%edx),%edx
 5f2:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 5f6:	89 ca                	mov    %ecx,%edx
 5f8:	89 c1                	mov    %eax,%ecx
 5fa:	39 da                	cmp    %ebx,%edx
 5fc:	73 e2                	jae    5e0 <printint+0x30>
  if(neg)
 5fe:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 601:	85 c0                	test   %eax,%eax
 603:	74 07                	je     60c <printint+0x5c>
    buf[i++] = '-';
 605:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 60a:	89 f7                	mov    %esi,%edi
 60c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 60f:	8b 75 c0             	mov    -0x40(%ebp),%esi
 612:	01 df                	add    %ebx,%edi
 614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 618:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 61b:	83 ec 04             	sub    $0x4,%esp
 61e:	88 45 d7             	mov    %al,-0x29(%ebp)
 621:	8d 45 d7             	lea    -0x29(%ebp),%eax
 624:	6a 01                	push   $0x1
 626:	50                   	push   %eax
 627:	56                   	push   %esi
 628:	e8 d6 fe ff ff       	call   503 <write>
  while(--i >= 0)
 62d:	89 f8                	mov    %edi,%eax
 62f:	83 c4 10             	add    $0x10,%esp
 632:	83 ef 01             	sub    $0x1,%edi
 635:	39 c3                	cmp    %eax,%ebx
 637:	75 df                	jne    618 <printint+0x68>
}
 639:	8d 65 f4             	lea    -0xc(%ebp),%esp
 63c:	5b                   	pop    %ebx
 63d:	5e                   	pop    %esi
 63e:	5f                   	pop    %edi
 63f:	5d                   	pop    %ebp
 640:	c3                   	ret
 641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 648:	31 c0                	xor    %eax,%eax
 64a:	eb 89                	jmp    5d5 <printint+0x25>
 64c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000650 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 650:	55                   	push   %ebp
 651:	89 e5                	mov    %esp,%ebp
 653:	57                   	push   %edi
 654:	56                   	push   %esi
 655:	53                   	push   %ebx
 656:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 659:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 65c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 65f:	0f b6 1e             	movzbl (%esi),%ebx
 662:	83 c6 01             	add    $0x1,%esi
 665:	84 db                	test   %bl,%bl
 667:	74 67                	je     6d0 <printf+0x80>
 669:	8d 4d 10             	lea    0x10(%ebp),%ecx
 66c:	31 d2                	xor    %edx,%edx
 66e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 671:	eb 34                	jmp    6a7 <printf+0x57>
 673:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 678:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 67b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 680:	83 f8 25             	cmp    $0x25,%eax
 683:	74 18                	je     69d <printf+0x4d>
  write(fd, &c, 1);
 685:	83 ec 04             	sub    $0x4,%esp
 688:	8d 45 e7             	lea    -0x19(%ebp),%eax
 68b:	88 5d e7             	mov    %bl,-0x19(%ebp)
 68e:	6a 01                	push   $0x1
 690:	50                   	push   %eax
 691:	57                   	push   %edi
 692:	e8 6c fe ff ff       	call   503 <write>
 697:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 69a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 69d:	0f b6 1e             	movzbl (%esi),%ebx
 6a0:	83 c6 01             	add    $0x1,%esi
 6a3:	84 db                	test   %bl,%bl
 6a5:	74 29                	je     6d0 <printf+0x80>
    c = fmt[i] & 0xff;
 6a7:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 6aa:	85 d2                	test   %edx,%edx
 6ac:	74 ca                	je     678 <printf+0x28>
      }
    } else if(state == '%'){
 6ae:	83 fa 25             	cmp    $0x25,%edx
 6b1:	75 ea                	jne    69d <printf+0x4d>
      if(c == 'd'){
 6b3:	83 f8 25             	cmp    $0x25,%eax
 6b6:	0f 84 04 01 00 00    	je     7c0 <printf+0x170>
 6bc:	83 e8 63             	sub    $0x63,%eax
 6bf:	83 f8 15             	cmp    $0x15,%eax
 6c2:	77 1c                	ja     6e0 <printf+0x90>
 6c4:	ff 24 85 70 0a 00 00 	jmp    *0xa70(,%eax,4)
 6cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6d3:	5b                   	pop    %ebx
 6d4:	5e                   	pop    %esi
 6d5:	5f                   	pop    %edi
 6d6:	5d                   	pop    %ebp
 6d7:	c3                   	ret
 6d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 6df:	00 
  write(fd, &c, 1);
 6e0:	83 ec 04             	sub    $0x4,%esp
 6e3:	8d 55 e7             	lea    -0x19(%ebp),%edx
 6e6:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 6ea:	6a 01                	push   $0x1
 6ec:	52                   	push   %edx
 6ed:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 6f0:	57                   	push   %edi
 6f1:	e8 0d fe ff ff       	call   503 <write>
 6f6:	83 c4 0c             	add    $0xc,%esp
 6f9:	88 5d e7             	mov    %bl,-0x19(%ebp)
 6fc:	6a 01                	push   $0x1
 6fe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 701:	52                   	push   %edx
 702:	57                   	push   %edi
 703:	e8 fb fd ff ff       	call   503 <write>
        putc(fd, c);
 708:	83 c4 10             	add    $0x10,%esp
      state = 0;
 70b:	31 d2                	xor    %edx,%edx
 70d:	eb 8e                	jmp    69d <printf+0x4d>
 70f:	90                   	nop
        printint(fd, *ap, 16, 0);
 710:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 713:	83 ec 0c             	sub    $0xc,%esp
 716:	b9 10 00 00 00       	mov    $0x10,%ecx
 71b:	8b 13                	mov    (%ebx),%edx
 71d:	6a 00                	push   $0x0
 71f:	89 f8                	mov    %edi,%eax
        ap++;
 721:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 724:	e8 87 fe ff ff       	call   5b0 <printint>
        ap++;
 729:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 72c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 72f:	31 d2                	xor    %edx,%edx
 731:	e9 67 ff ff ff       	jmp    69d <printf+0x4d>
        s = (char*)*ap;
 736:	8b 45 d0             	mov    -0x30(%ebp),%eax
 739:	8b 18                	mov    (%eax),%ebx
        ap++;
 73b:	83 c0 04             	add    $0x4,%eax
 73e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 741:	85 db                	test   %ebx,%ebx
 743:	0f 84 87 00 00 00    	je     7d0 <printf+0x180>
        while(*s != 0){
 749:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 74c:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 74e:	84 c0                	test   %al,%al
 750:	0f 84 47 ff ff ff    	je     69d <printf+0x4d>
 756:	8d 55 e7             	lea    -0x19(%ebp),%edx
 759:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 75c:	89 de                	mov    %ebx,%esi
 75e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 760:	83 ec 04             	sub    $0x4,%esp
 763:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 766:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 769:	6a 01                	push   $0x1
 76b:	53                   	push   %ebx
 76c:	57                   	push   %edi
 76d:	e8 91 fd ff ff       	call   503 <write>
        while(*s != 0){
 772:	0f b6 06             	movzbl (%esi),%eax
 775:	83 c4 10             	add    $0x10,%esp
 778:	84 c0                	test   %al,%al
 77a:	75 e4                	jne    760 <printf+0x110>
      state = 0;
 77c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 77f:	31 d2                	xor    %edx,%edx
 781:	e9 17 ff ff ff       	jmp    69d <printf+0x4d>
        printint(fd, *ap, 10, 1);
 786:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 789:	83 ec 0c             	sub    $0xc,%esp
 78c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 791:	8b 13                	mov    (%ebx),%edx
 793:	6a 01                	push   $0x1
 795:	eb 88                	jmp    71f <printf+0xcf>
        putc(fd, *ap);
 797:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 79a:	83 ec 04             	sub    $0x4,%esp
 79d:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 7a0:	8b 03                	mov    (%ebx),%eax
        ap++;
 7a2:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 7a5:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 7a8:	6a 01                	push   $0x1
 7aa:	52                   	push   %edx
 7ab:	57                   	push   %edi
 7ac:	e8 52 fd ff ff       	call   503 <write>
        ap++;
 7b1:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 7b4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7b7:	31 d2                	xor    %edx,%edx
 7b9:	e9 df fe ff ff       	jmp    69d <printf+0x4d>
 7be:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 7c0:	83 ec 04             	sub    $0x4,%esp
 7c3:	88 5d e7             	mov    %bl,-0x19(%ebp)
 7c6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 7c9:	6a 01                	push   $0x1
 7cb:	e9 31 ff ff ff       	jmp    701 <printf+0xb1>
 7d0:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 7d5:	bb 0a 0a 00 00       	mov    $0xa0a,%ebx
 7da:	e9 77 ff ff ff       	jmp    756 <printf+0x106>
 7df:	90                   	nop

000007e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e1:	a1 e0 0d 00 00       	mov    0xde0,%eax
{
 7e6:	89 e5                	mov    %esp,%ebp
 7e8:	57                   	push   %edi
 7e9:	56                   	push   %esi
 7ea:	53                   	push   %ebx
 7eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 7ee:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f8:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7fa:	39 c8                	cmp    %ecx,%eax
 7fc:	73 32                	jae    830 <free+0x50>
 7fe:	39 d1                	cmp    %edx,%ecx
 800:	72 04                	jb     806 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 802:	39 d0                	cmp    %edx,%eax
 804:	72 32                	jb     838 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 806:	8b 73 fc             	mov    -0x4(%ebx),%esi
 809:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 80c:	39 fa                	cmp    %edi,%edx
 80e:	74 30                	je     840 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 810:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 813:	8b 50 04             	mov    0x4(%eax),%edx
 816:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 819:	39 f1                	cmp    %esi,%ecx
 81b:	74 3a                	je     857 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 81d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 81f:	5b                   	pop    %ebx
  freep = p;
 820:	a3 e0 0d 00 00       	mov    %eax,0xde0
}
 825:	5e                   	pop    %esi
 826:	5f                   	pop    %edi
 827:	5d                   	pop    %ebp
 828:	c3                   	ret
 829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 830:	39 d0                	cmp    %edx,%eax
 832:	72 04                	jb     838 <free+0x58>
 834:	39 d1                	cmp    %edx,%ecx
 836:	72 ce                	jb     806 <free+0x26>
{
 838:	89 d0                	mov    %edx,%eax
 83a:	eb bc                	jmp    7f8 <free+0x18>
 83c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 840:	03 72 04             	add    0x4(%edx),%esi
 843:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 846:	8b 10                	mov    (%eax),%edx
 848:	8b 12                	mov    (%edx),%edx
 84a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 84d:	8b 50 04             	mov    0x4(%eax),%edx
 850:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 853:	39 f1                	cmp    %esi,%ecx
 855:	75 c6                	jne    81d <free+0x3d>
    p->s.size += bp->s.size;
 857:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 85a:	a3 e0 0d 00 00       	mov    %eax,0xde0
    p->s.size += bp->s.size;
 85f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 862:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 865:	89 08                	mov    %ecx,(%eax)
}
 867:	5b                   	pop    %ebx
 868:	5e                   	pop    %esi
 869:	5f                   	pop    %edi
 86a:	5d                   	pop    %ebp
 86b:	c3                   	ret
 86c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000870 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 870:	55                   	push   %ebp
 871:	89 e5                	mov    %esp,%ebp
 873:	57                   	push   %edi
 874:	56                   	push   %esi
 875:	53                   	push   %ebx
 876:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 879:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 87c:	8b 15 e0 0d 00 00    	mov    0xde0,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 882:	8d 78 07             	lea    0x7(%eax),%edi
 885:	c1 ef 03             	shr    $0x3,%edi
 888:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 88b:	85 d2                	test   %edx,%edx
 88d:	0f 84 8d 00 00 00    	je     920 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 893:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 895:	8b 48 04             	mov    0x4(%eax),%ecx
 898:	39 f9                	cmp    %edi,%ecx
 89a:	73 64                	jae    900 <malloc+0x90>
  if(nu < 4096)
 89c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 8a1:	39 df                	cmp    %ebx,%edi
 8a3:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 8a6:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 8ad:	eb 0a                	jmp    8b9 <malloc+0x49>
 8af:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8b2:	8b 48 04             	mov    0x4(%eax),%ecx
 8b5:	39 f9                	cmp    %edi,%ecx
 8b7:	73 47                	jae    900 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8b9:	89 c2                	mov    %eax,%edx
 8bb:	3b 05 e0 0d 00 00    	cmp    0xde0,%eax
 8c1:	75 ed                	jne    8b0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 8c3:	83 ec 0c             	sub    $0xc,%esp
 8c6:	56                   	push   %esi
 8c7:	e8 9f fc ff ff       	call   56b <sbrk>
  if(p == (char*)-1)
 8cc:	83 c4 10             	add    $0x10,%esp
 8cf:	83 f8 ff             	cmp    $0xffffffff,%eax
 8d2:	74 1c                	je     8f0 <malloc+0x80>
  hp->s.size = nu;
 8d4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 8d7:	83 ec 0c             	sub    $0xc,%esp
 8da:	83 c0 08             	add    $0x8,%eax
 8dd:	50                   	push   %eax
 8de:	e8 fd fe ff ff       	call   7e0 <free>
  return freep;
 8e3:	8b 15 e0 0d 00 00    	mov    0xde0,%edx
      if((p = morecore(nunits)) == 0)
 8e9:	83 c4 10             	add    $0x10,%esp
 8ec:	85 d2                	test   %edx,%edx
 8ee:	75 c0                	jne    8b0 <malloc+0x40>
        return 0;
  }
}
 8f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 8f3:	31 c0                	xor    %eax,%eax
}
 8f5:	5b                   	pop    %ebx
 8f6:	5e                   	pop    %esi
 8f7:	5f                   	pop    %edi
 8f8:	5d                   	pop    %ebp
 8f9:	c3                   	ret
 8fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 900:	39 cf                	cmp    %ecx,%edi
 902:	74 4c                	je     950 <malloc+0xe0>
        p->s.size -= nunits;
 904:	29 f9                	sub    %edi,%ecx
 906:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 909:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 90c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 90f:	89 15 e0 0d 00 00    	mov    %edx,0xde0
}
 915:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 918:	83 c0 08             	add    $0x8,%eax
}
 91b:	5b                   	pop    %ebx
 91c:	5e                   	pop    %esi
 91d:	5f                   	pop    %edi
 91e:	5d                   	pop    %ebp
 91f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 920:	c7 05 e0 0d 00 00 e4 	movl   $0xde4,0xde0
 927:	0d 00 00 
    base.s.size = 0;
 92a:	b8 e4 0d 00 00       	mov    $0xde4,%eax
    base.s.ptr = freep = prevp = &base;
 92f:	c7 05 e4 0d 00 00 e4 	movl   $0xde4,0xde4
 936:	0d 00 00 
    base.s.size = 0;
 939:	c7 05 e8 0d 00 00 00 	movl   $0x0,0xde8
 940:	00 00 00 
    if(p->s.size >= nunits){
 943:	e9 54 ff ff ff       	jmp    89c <malloc+0x2c>
 948:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 94f:	00 
        prevp->s.ptr = p->s.ptr;
 950:	8b 08                	mov    (%eax),%ecx
 952:	89 0a                	mov    %ecx,(%edx)
 954:	eb b9                	jmp    90f <malloc+0x9f>
