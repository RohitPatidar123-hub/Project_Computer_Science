
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  }
}

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 18             	sub    $0x18,%esp
  14:	8b 01                	mov    (%ecx),%eax
  16:	8b 59 04             	mov    0x4(%ecx),%ebx
  19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int fd, i;
  char *pattern;

  if(argc <= 1){
  1c:	83 f8 01             	cmp    $0x1,%eax
  1f:	7e 6f                	jle    90 <main+0x90>
    printf(2, "usage: grep pattern [file ...]\n");
    exit();
  }
  pattern = argv[1];
  21:	8b 43 04             	mov    0x4(%ebx),%eax
  24:	83 c3 08             	add    $0x8,%ebx

  if(argc <= 2){
  27:	83 7d e4 02          	cmpl   $0x2,-0x1c(%ebp)
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
  2b:	be 02 00 00 00       	mov    $0x2,%esi
  pattern = argv[1];
  30:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(argc <= 2){
  33:	75 2d                	jne    62 <main+0x62>
  35:	eb 6c                	jmp    a3 <main+0xa3>
  37:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  3e:	00 
  3f:	90                   	nop
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "grep: cannot open %s\n", argv[i]);
      exit();
    }
    grep(pattern, fd);
  40:	83 ec 08             	sub    $0x8,%esp
  for(i = 2; i < argc; i++){
  43:	83 c6 01             	add    $0x1,%esi
  46:	83 c3 04             	add    $0x4,%ebx
    grep(pattern, fd);
  49:	50                   	push   %eax
  4a:	ff 75 e0             	push   -0x20(%ebp)
  4d:	e8 9e 01 00 00       	call   1f0 <grep>
    close(fd);
  52:	89 3c 24             	mov    %edi,(%esp)
  55:	e8 b1 05 00 00       	call   60b <close>
  for(i = 2; i < argc; i++){
  5a:	83 c4 10             	add    $0x10,%esp
  5d:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  60:	7e 29                	jle    8b <main+0x8b>
    if((fd = open(argv[i], 0)) < 0){
  62:	83 ec 08             	sub    $0x8,%esp
  65:	6a 00                	push   $0x0
  67:	ff 33                	push   (%ebx)
  69:	e8 b5 05 00 00       	call   623 <open>
  6e:	83 c4 10             	add    $0x10,%esp
  71:	89 c7                	mov    %eax,%edi
  73:	85 c0                	test   %eax,%eax
  75:	79 c9                	jns    40 <main+0x40>
      printf(1, "grep: cannot open %s\n", argv[i]);
  77:	50                   	push   %eax
  78:	ff 33                	push   (%ebx)
  7a:	68 78 0a 00 00       	push   $0xa78
  7f:	6a 01                	push   $0x1
  81:	e8 ca 06 00 00       	call   750 <printf>
      exit();
  86:	e8 58 05 00 00       	call   5e3 <exit>
  }
  exit();
  8b:	e8 53 05 00 00       	call   5e3 <exit>
    printf(2, "usage: grep pattern [file ...]\n");
  90:	51                   	push   %ecx
  91:	51                   	push   %ecx
  92:	68 58 0a 00 00       	push   $0xa58
  97:	6a 02                	push   $0x2
  99:	e8 b2 06 00 00       	call   750 <printf>
    exit();
  9e:	e8 40 05 00 00       	call   5e3 <exit>
    grep(pattern, 0);
  a3:	52                   	push   %edx
  a4:	52                   	push   %edx
  a5:	6a 00                	push   $0x0
  a7:	50                   	push   %eax
  a8:	e8 43 01 00 00       	call   1f0 <grep>
    exit();
  ad:	e8 31 05 00 00       	call   5e3 <exit>
  b2:	66 90                	xchg   %ax,%ax
  b4:	66 90                	xchg   %ax,%ax
  b6:	66 90                	xchg   %ax,%ax
  b8:	66 90                	xchg   %ax,%ax
  ba:	66 90                	xchg   %ax,%ax
  bc:	66 90                	xchg   %ax,%ax
  be:	66 90                	xchg   %ax,%ax

000000c0 <matchhere>:
  return 0;
}

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	57                   	push   %edi
  c4:	56                   	push   %esi
  c5:	53                   	push   %ebx
  c6:	83 ec 0c             	sub    $0xc,%esp
  c9:	8b 7d 08             	mov    0x8(%ebp),%edi
  cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(re[0] == '\0')
  cf:	0f b6 0f             	movzbl (%edi),%ecx
  d2:	84 c9                	test   %cl,%cl
  d4:	0f 84 96 00 00 00    	je     170 <matchhere+0xb0>
    return 1;
  if(re[1] == '*')
  da:	0f b6 47 01          	movzbl 0x1(%edi),%eax
  de:	3c 2a                	cmp    $0x2a,%al
  e0:	74 2d                	je     10f <matchhere+0x4f>
  e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return matchstar(re[0], re+2, text);
  if(re[0] == '$' && re[1] == '\0')
    return *text == '\0';
  e8:	0f b6 33             	movzbl (%ebx),%esi
  if(re[0] == '$' && re[1] == '\0')
  eb:	80 f9 24             	cmp    $0x24,%cl
  ee:	74 50                	je     140 <matchhere+0x80>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  f0:	89 f2                	mov    %esi,%edx
  f2:	84 d2                	test   %dl,%dl
  f4:	74 6e                	je     164 <matchhere+0xa4>
  f6:	80 f9 2e             	cmp    $0x2e,%cl
  f9:	75 65                	jne    160 <matchhere+0xa0>
    return matchhere(re+1, text+1);
  fb:	83 c3 01             	add    $0x1,%ebx
  fe:	83 c7 01             	add    $0x1,%edi
  if(re[0] == '\0')
 101:	84 c0                	test   %al,%al
 103:	74 6b                	je     170 <matchhere+0xb0>
{
 105:	89 c1                	mov    %eax,%ecx
  if(re[1] == '*')
 107:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 10b:	3c 2a                	cmp    $0x2a,%al
 10d:	75 d9                	jne    e8 <matchhere+0x28>
    return matchstar(re[0], re+2, text);
 10f:	8d 77 02             	lea    0x2(%edi),%esi
 112:	0f be f9             	movsbl %cl,%edi
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
 115:	8d 76 00             	lea    0x0(%esi),%esi
{
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 118:	83 ec 08             	sub    $0x8,%esp
 11b:	53                   	push   %ebx
 11c:	56                   	push   %esi
 11d:	e8 9e ff ff ff       	call   c0 <matchhere>
 122:	83 c4 10             	add    $0x10,%esp
 125:	85 c0                	test   %eax,%eax
 127:	75 47                	jne    170 <matchhere+0xb0>
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
 129:	0f be 13             	movsbl (%ebx),%edx
 12c:	84 d2                	test   %dl,%dl
 12e:	74 45                	je     175 <matchhere+0xb5>
 130:	83 c3 01             	add    $0x1,%ebx
 133:	39 fa                	cmp    %edi,%edx
 135:	74 e1                	je     118 <matchhere+0x58>
 137:	83 ff 2e             	cmp    $0x2e,%edi
 13a:	74 dc                	je     118 <matchhere+0x58>
 13c:	eb 37                	jmp    175 <matchhere+0xb5>
 13e:	66 90                	xchg   %ax,%ax
  if(re[0] == '$' && re[1] == '\0')
 140:	84 c0                	test   %al,%al
 142:	74 39                	je     17d <matchhere+0xbd>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 144:	89 f2                	mov    %esi,%edx
 146:	84 d2                	test   %dl,%dl
 148:	74 1a                	je     164 <matchhere+0xa4>
 14a:	80 fa 24             	cmp    $0x24,%dl
 14d:	75 15                	jne    164 <matchhere+0xa4>
    return matchhere(re+1, text+1);
 14f:	83 c3 01             	add    $0x1,%ebx
 152:	83 c7 01             	add    $0x1,%edi
{
 155:	89 c1                	mov    %eax,%ecx
 157:	eb ae                	jmp    107 <matchhere+0x47>
 159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 160:	38 ca                	cmp    %cl,%dl
 162:	74 97                	je     fb <matchhere+0x3b>
}
 164:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
 167:	31 c0                	xor    %eax,%eax
}
 169:	5b                   	pop    %ebx
 16a:	5e                   	pop    %esi
 16b:	5f                   	pop    %edi
 16c:	5d                   	pop    %ebp
 16d:	c3                   	ret
 16e:	66 90                	xchg   %ax,%ax
    return 1;
 170:	b8 01 00 00 00       	mov    $0x1,%eax
}
 175:	8d 65 f4             	lea    -0xc(%ebp),%esp
 178:	5b                   	pop    %ebx
 179:	5e                   	pop    %esi
 17a:	5f                   	pop    %edi
 17b:	5d                   	pop    %ebp
 17c:	c3                   	ret
    return *text == '\0';
 17d:	89 f0                	mov    %esi,%eax
 17f:	84 c0                	test   %al,%al
 181:	0f 94 c0             	sete   %al
 184:	0f b6 c0             	movzbl %al,%eax
 187:	eb ec                	jmp    175 <matchhere+0xb5>
 189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000190 <match>:
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	56                   	push   %esi
 194:	53                   	push   %ebx
 195:	8b 5d 08             	mov    0x8(%ebp),%ebx
 198:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(re[0] == '^')
 19b:	80 3b 5e             	cmpb   $0x5e,(%ebx)
 19e:	75 11                	jne    1b1 <match+0x21>
 1a0:	eb 2e                	jmp    1d0 <match+0x40>
 1a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }while(*text++ != '\0');
 1a8:	83 c6 01             	add    $0x1,%esi
 1ab:	80 7e ff 00          	cmpb   $0x0,-0x1(%esi)
 1af:	74 16                	je     1c7 <match+0x37>
    if(matchhere(re, text))
 1b1:	83 ec 08             	sub    $0x8,%esp
 1b4:	56                   	push   %esi
 1b5:	53                   	push   %ebx
 1b6:	e8 05 ff ff ff       	call   c0 <matchhere>
 1bb:	83 c4 10             	add    $0x10,%esp
 1be:	85 c0                	test   %eax,%eax
 1c0:	74 e6                	je     1a8 <match+0x18>
      return 1;
 1c2:	b8 01 00 00 00       	mov    $0x1,%eax
}
 1c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1ca:	5b                   	pop    %ebx
 1cb:	5e                   	pop    %esi
 1cc:	5d                   	pop    %ebp
 1cd:	c3                   	ret
 1ce:	66 90                	xchg   %ax,%ax
    return matchhere(re+1, text);
 1d0:	83 c3 01             	add    $0x1,%ebx
 1d3:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
 1d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1d9:	5b                   	pop    %ebx
 1da:	5e                   	pop    %esi
 1db:	5d                   	pop    %ebp
    return matchhere(re+1, text);
 1dc:	e9 df fe ff ff       	jmp    c0 <matchhere>
 1e1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 1e8:	00 
 1e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001f0 <grep>:
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	57                   	push   %edi
  m = 0;
 1f4:	31 ff                	xor    %edi,%edi
{
 1f6:	56                   	push   %esi
 1f7:	53                   	push   %ebx
 1f8:	83 ec 1c             	sub    $0x1c,%esp
 1fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 1fe:	89 7d e0             	mov    %edi,-0x20(%ebp)
    return matchhere(re+1, text);
 201:	8d 43 01             	lea    0x1(%ebx),%eax
 204:	89 45 dc             	mov    %eax,-0x24(%ebp)
 207:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 20e:	00 
 20f:	90                   	nop
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 210:	8b 4d e0             	mov    -0x20(%ebp),%ecx
 213:	b8 ff 03 00 00       	mov    $0x3ff,%eax
 218:	83 ec 04             	sub    $0x4,%esp
 21b:	29 c8                	sub    %ecx,%eax
 21d:	50                   	push   %eax
 21e:	8d 81 80 0e 00 00    	lea    0xe80(%ecx),%eax
 224:	50                   	push   %eax
 225:	ff 75 0c             	push   0xc(%ebp)
 228:	e8 ce 03 00 00       	call   5fb <read>
 22d:	83 c4 10             	add    $0x10,%esp
 230:	85 c0                	test   %eax,%eax
 232:	0f 8e fd 00 00 00    	jle    335 <grep+0x145>
    m += n;
 238:	01 45 e0             	add    %eax,-0x20(%ebp)
 23b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    buf[m] = '\0';
 23e:	bf 80 0e 00 00       	mov    $0xe80,%edi
 243:	89 de                	mov    %ebx,%esi
 245:	c6 81 80 0e 00 00 00 	movb   $0x0,0xe80(%ecx)
    while((q = strchr(p, '\n')) != 0){
 24c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 250:	83 ec 08             	sub    $0x8,%esp
 253:	6a 0a                	push   $0xa
 255:	57                   	push   %edi
 256:	e8 25 02 00 00       	call   480 <strchr>
 25b:	83 c4 10             	add    $0x10,%esp
 25e:	89 c2                	mov    %eax,%edx
 260:	85 c0                	test   %eax,%eax
 262:	0f 84 88 00 00 00    	je     2f0 <grep+0x100>
      *q = 0;
 268:	c6 02 00             	movb   $0x0,(%edx)
  if(re[0] == '^')
 26b:	80 3e 5e             	cmpb   $0x5e,(%esi)
 26e:	74 58                	je     2c8 <grep+0xd8>
 270:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 273:	89 d3                	mov    %edx,%ebx
 275:	eb 12                	jmp    289 <grep+0x99>
 277:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 27e:	00 
 27f:	90                   	nop
  }while(*text++ != '\0');
 280:	83 c7 01             	add    $0x1,%edi
 283:	80 7f ff 00          	cmpb   $0x0,-0x1(%edi)
 287:	74 37                	je     2c0 <grep+0xd0>
    if(matchhere(re, text))
 289:	83 ec 08             	sub    $0x8,%esp
 28c:	57                   	push   %edi
 28d:	56                   	push   %esi
 28e:	e8 2d fe ff ff       	call   c0 <matchhere>
 293:	83 c4 10             	add    $0x10,%esp
 296:	85 c0                	test   %eax,%eax
 298:	74 e6                	je     280 <grep+0x90>
        write(1, p, q+1 - p);
 29a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 29d:	89 da                	mov    %ebx,%edx
 29f:	8d 5b 01             	lea    0x1(%ebx),%ebx
 2a2:	89 d8                	mov    %ebx,%eax
 2a4:	83 ec 04             	sub    $0x4,%esp
        *q = '\n';
 2a7:	c6 02 0a             	movb   $0xa,(%edx)
        write(1, p, q+1 - p);
 2aa:	29 f8                	sub    %edi,%eax
 2ac:	50                   	push   %eax
 2ad:	57                   	push   %edi
 2ae:	89 df                	mov    %ebx,%edi
 2b0:	6a 01                	push   $0x1
 2b2:	e8 4c 03 00 00       	call   603 <write>
 2b7:	83 c4 10             	add    $0x10,%esp
 2ba:	eb 94                	jmp    250 <grep+0x60>
 2bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2c0:	8d 7b 01             	lea    0x1(%ebx),%edi
      p = q+1;
 2c3:	eb 8b                	jmp    250 <grep+0x60>
 2c5:	8d 76 00             	lea    0x0(%esi),%esi
    return matchhere(re+1, text);
 2c8:	83 ec 08             	sub    $0x8,%esp
 2cb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 2ce:	57                   	push   %edi
 2cf:	ff 75 dc             	push   -0x24(%ebp)
 2d2:	e8 e9 fd ff ff       	call   c0 <matchhere>
        write(1, p, q+1 - p);
 2d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    return matchhere(re+1, text);
 2da:	83 c4 10             	add    $0x10,%esp
        write(1, p, q+1 - p);
 2dd:	8d 5a 01             	lea    0x1(%edx),%ebx
      if(match(pattern, p)){
 2e0:	85 c0                	test   %eax,%eax
 2e2:	75 be                	jne    2a2 <grep+0xb2>
        write(1, p, q+1 - p);
 2e4:	89 df                	mov    %ebx,%edi
 2e6:	e9 65 ff ff ff       	jmp    250 <grep+0x60>
 2eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p == buf)
 2f0:	89 f3                	mov    %esi,%ebx
 2f2:	81 ff 80 0e 00 00    	cmp    $0xe80,%edi
 2f8:	74 2f                	je     329 <grep+0x139>
    if(m > 0){
 2fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
 2fd:	85 c0                	test   %eax,%eax
 2ff:	0f 8e 0b ff ff ff    	jle    210 <grep+0x20>
      m -= p - buf;
 305:	89 f8                	mov    %edi,%eax
      memmove(buf, p, m);
 307:	83 ec 04             	sub    $0x4,%esp
      m -= p - buf;
 30a:	2d 80 0e 00 00       	sub    $0xe80,%eax
 30f:	29 45 e0             	sub    %eax,-0x20(%ebp)
 312:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      memmove(buf, p, m);
 315:	51                   	push   %ecx
 316:	57                   	push   %edi
 317:	68 80 0e 00 00       	push   $0xe80
 31c:	e8 8f 02 00 00       	call   5b0 <memmove>
 321:	83 c4 10             	add    $0x10,%esp
 324:	e9 e7 fe ff ff       	jmp    210 <grep+0x20>
      m = 0;
 329:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 330:	e9 db fe ff ff       	jmp    210 <grep+0x20>
}
 335:	8d 65 f4             	lea    -0xc(%ebp),%esp
 338:	5b                   	pop    %ebx
 339:	5e                   	pop    %esi
 33a:	5f                   	pop    %edi
 33b:	5d                   	pop    %ebp
 33c:	c3                   	ret
 33d:	8d 76 00             	lea    0x0(%esi),%esi

00000340 <matchstar>:
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	57                   	push   %edi
 344:	56                   	push   %esi
 345:	53                   	push   %ebx
 346:	83 ec 0c             	sub    $0xc,%esp
 349:	8b 5d 08             	mov    0x8(%ebp),%ebx
 34c:	8b 75 0c             	mov    0xc(%ebp),%esi
 34f:	8b 7d 10             	mov    0x10(%ebp),%edi
 352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(matchhere(re, text))
 358:	83 ec 08             	sub    $0x8,%esp
 35b:	57                   	push   %edi
 35c:	56                   	push   %esi
 35d:	e8 5e fd ff ff       	call   c0 <matchhere>
 362:	83 c4 10             	add    $0x10,%esp
 365:	85 c0                	test   %eax,%eax
 367:	75 1f                	jne    388 <matchstar+0x48>
  }while(*text!='\0' && (*text++==c || c=='.'));
 369:	0f be 17             	movsbl (%edi),%edx
 36c:	84 d2                	test   %dl,%dl
 36e:	74 0c                	je     37c <matchstar+0x3c>
 370:	83 c7 01             	add    $0x1,%edi
 373:	83 fb 2e             	cmp    $0x2e,%ebx
 376:	74 e0                	je     358 <matchstar+0x18>
 378:	39 da                	cmp    %ebx,%edx
 37a:	74 dc                	je     358 <matchstar+0x18>
}
 37c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 37f:	5b                   	pop    %ebx
 380:	5e                   	pop    %esi
 381:	5f                   	pop    %edi
 382:	5d                   	pop    %ebp
 383:	c3                   	ret
 384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 388:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 1;
 38b:	b8 01 00 00 00       	mov    $0x1,%eax
}
 390:	5b                   	pop    %ebx
 391:	5e                   	pop    %esi
 392:	5f                   	pop    %edi
 393:	5d                   	pop    %ebp
 394:	c3                   	ret
 395:	66 90                	xchg   %ax,%ax
 397:	66 90                	xchg   %ax,%ax
 399:	66 90                	xchg   %ax,%ax
 39b:	66 90                	xchg   %ax,%ax
 39d:	66 90                	xchg   %ax,%ax
 39f:	90                   	nop

000003a0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 3a0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3a1:	31 c0                	xor    %eax,%eax
{
 3a3:	89 e5                	mov    %esp,%ebp
 3a5:	53                   	push   %ebx
 3a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 3ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 3b0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 3b4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 3b7:	83 c0 01             	add    $0x1,%eax
 3ba:	84 d2                	test   %dl,%dl
 3bc:	75 f2                	jne    3b0 <strcpy+0x10>
    ;
  return os;
}
 3be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3c1:	89 c8                	mov    %ecx,%eax
 3c3:	c9                   	leave
 3c4:	c3                   	ret
 3c5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 3cc:	00 
 3cd:	8d 76 00             	lea    0x0(%esi),%esi

000003d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	53                   	push   %ebx
 3d4:	8b 55 08             	mov    0x8(%ebp),%edx
 3d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 3da:	0f b6 02             	movzbl (%edx),%eax
 3dd:	84 c0                	test   %al,%al
 3df:	75 17                	jne    3f8 <strcmp+0x28>
 3e1:	eb 3a                	jmp    41d <strcmp+0x4d>
 3e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 3e8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 3ec:	83 c2 01             	add    $0x1,%edx
 3ef:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 3f2:	84 c0                	test   %al,%al
 3f4:	74 1a                	je     410 <strcmp+0x40>
 3f6:	89 d9                	mov    %ebx,%ecx
 3f8:	0f b6 19             	movzbl (%ecx),%ebx
 3fb:	38 c3                	cmp    %al,%bl
 3fd:	74 e9                	je     3e8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 3ff:	29 d8                	sub    %ebx,%eax
}
 401:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 404:	c9                   	leave
 405:	c3                   	ret
 406:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 40d:	00 
 40e:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
 410:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 414:	31 c0                	xor    %eax,%eax
 416:	29 d8                	sub    %ebx,%eax
}
 418:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 41b:	c9                   	leave
 41c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 41d:	0f b6 19             	movzbl (%ecx),%ebx
 420:	31 c0                	xor    %eax,%eax
 422:	eb db                	jmp    3ff <strcmp+0x2f>
 424:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 42b:	00 
 42c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000430 <strlen>:

uint
strlen(const char *s)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 436:	80 3a 00             	cmpb   $0x0,(%edx)
 439:	74 15                	je     450 <strlen+0x20>
 43b:	31 c0                	xor    %eax,%eax
 43d:	8d 76 00             	lea    0x0(%esi),%esi
 440:	83 c0 01             	add    $0x1,%eax
 443:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 447:	89 c1                	mov    %eax,%ecx
 449:	75 f5                	jne    440 <strlen+0x10>
    ;
  return n;
}
 44b:	89 c8                	mov    %ecx,%eax
 44d:	5d                   	pop    %ebp
 44e:	c3                   	ret
 44f:	90                   	nop
  for(n = 0; s[n]; n++)
 450:	31 c9                	xor    %ecx,%ecx
}
 452:	5d                   	pop    %ebp
 453:	89 c8                	mov    %ecx,%eax
 455:	c3                   	ret
 456:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 45d:	00 
 45e:	66 90                	xchg   %ax,%ax

00000460 <memset>:

void*
memset(void *dst, int c, uint n)
{
 460:	55                   	push   %ebp
 461:	89 e5                	mov    %esp,%ebp
 463:	57                   	push   %edi
 464:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 467:	8b 4d 10             	mov    0x10(%ebp),%ecx
 46a:	8b 45 0c             	mov    0xc(%ebp),%eax
 46d:	89 d7                	mov    %edx,%edi
 46f:	fc                   	cld
 470:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 472:	8b 7d fc             	mov    -0x4(%ebp),%edi
 475:	89 d0                	mov    %edx,%eax
 477:	c9                   	leave
 478:	c3                   	ret
 479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000480 <strchr>:

char*
strchr(const char *s, char c)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	8b 45 08             	mov    0x8(%ebp),%eax
 486:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 48a:	0f b6 10             	movzbl (%eax),%edx
 48d:	84 d2                	test   %dl,%dl
 48f:	75 12                	jne    4a3 <strchr+0x23>
 491:	eb 1d                	jmp    4b0 <strchr+0x30>
 493:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 498:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 49c:	83 c0 01             	add    $0x1,%eax
 49f:	84 d2                	test   %dl,%dl
 4a1:	74 0d                	je     4b0 <strchr+0x30>
    if(*s == c)
 4a3:	38 d1                	cmp    %dl,%cl
 4a5:	75 f1                	jne    498 <strchr+0x18>
      return (char*)s;
  return 0;
}
 4a7:	5d                   	pop    %ebp
 4a8:	c3                   	ret
 4a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 4b0:	31 c0                	xor    %eax,%eax
}
 4b2:	5d                   	pop    %ebp
 4b3:	c3                   	ret
 4b4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 4bb:	00 
 4bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000004c0 <gets>:

char*
gets(char *buf, int max)
{
 4c0:	55                   	push   %ebp
 4c1:	89 e5                	mov    %esp,%ebp
 4c3:	57                   	push   %edi
 4c4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 4c5:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 4c8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 4c9:	31 db                	xor    %ebx,%ebx
{
 4cb:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 4ce:	eb 27                	jmp    4f7 <gets+0x37>
    cc = read(0, &c, 1);
 4d0:	83 ec 04             	sub    $0x4,%esp
 4d3:	6a 01                	push   $0x1
 4d5:	56                   	push   %esi
 4d6:	6a 00                	push   $0x0
 4d8:	e8 1e 01 00 00       	call   5fb <read>
    if(cc < 1)
 4dd:	83 c4 10             	add    $0x10,%esp
 4e0:	85 c0                	test   %eax,%eax
 4e2:	7e 1d                	jle    501 <gets+0x41>
      break;
    buf[i++] = c;
 4e4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 4e8:	8b 55 08             	mov    0x8(%ebp),%edx
 4eb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 4ef:	3c 0a                	cmp    $0xa,%al
 4f1:	74 10                	je     503 <gets+0x43>
 4f3:	3c 0d                	cmp    $0xd,%al
 4f5:	74 0c                	je     503 <gets+0x43>
  for(i=0; i+1 < max; ){
 4f7:	89 df                	mov    %ebx,%edi
 4f9:	83 c3 01             	add    $0x1,%ebx
 4fc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 4ff:	7c cf                	jl     4d0 <gets+0x10>
 501:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 503:	8b 45 08             	mov    0x8(%ebp),%eax
 506:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 50a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 50d:	5b                   	pop    %ebx
 50e:	5e                   	pop    %esi
 50f:	5f                   	pop    %edi
 510:	5d                   	pop    %ebp
 511:	c3                   	ret
 512:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 519:	00 
 51a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000520 <stat>:

int
stat(const char *n, struct stat *st)
{
 520:	55                   	push   %ebp
 521:	89 e5                	mov    %esp,%ebp
 523:	56                   	push   %esi
 524:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 525:	83 ec 08             	sub    $0x8,%esp
 528:	6a 00                	push   $0x0
 52a:	ff 75 08             	push   0x8(%ebp)
 52d:	e8 f1 00 00 00       	call   623 <open>
  if(fd < 0)
 532:	83 c4 10             	add    $0x10,%esp
 535:	85 c0                	test   %eax,%eax
 537:	78 27                	js     560 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 539:	83 ec 08             	sub    $0x8,%esp
 53c:	ff 75 0c             	push   0xc(%ebp)
 53f:	89 c3                	mov    %eax,%ebx
 541:	50                   	push   %eax
 542:	e8 f4 00 00 00       	call   63b <fstat>
  close(fd);
 547:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 54a:	89 c6                	mov    %eax,%esi
  close(fd);
 54c:	e8 ba 00 00 00       	call   60b <close>
  return r;
 551:	83 c4 10             	add    $0x10,%esp
}
 554:	8d 65 f8             	lea    -0x8(%ebp),%esp
 557:	89 f0                	mov    %esi,%eax
 559:	5b                   	pop    %ebx
 55a:	5e                   	pop    %esi
 55b:	5d                   	pop    %ebp
 55c:	c3                   	ret
 55d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 560:	be ff ff ff ff       	mov    $0xffffffff,%esi
 565:	eb ed                	jmp    554 <stat+0x34>
 567:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 56e:	00 
 56f:	90                   	nop

00000570 <atoi>:

int
atoi(const char *s)
{
 570:	55                   	push   %ebp
 571:	89 e5                	mov    %esp,%ebp
 573:	53                   	push   %ebx
 574:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 577:	0f be 02             	movsbl (%edx),%eax
 57a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 57d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 580:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 585:	77 1e                	ja     5a5 <atoi+0x35>
 587:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 58e:	00 
 58f:	90                   	nop
    n = n*10 + *s++ - '0';
 590:	83 c2 01             	add    $0x1,%edx
 593:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 596:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 59a:	0f be 02             	movsbl (%edx),%eax
 59d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 5a0:	80 fb 09             	cmp    $0x9,%bl
 5a3:	76 eb                	jbe    590 <atoi+0x20>
  return n;
}
 5a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5a8:	89 c8                	mov    %ecx,%eax
 5aa:	c9                   	leave
 5ab:	c3                   	ret
 5ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000005b0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 5b0:	55                   	push   %ebp
 5b1:	89 e5                	mov    %esp,%ebp
 5b3:	57                   	push   %edi
 5b4:	8b 45 10             	mov    0x10(%ebp),%eax
 5b7:	8b 55 08             	mov    0x8(%ebp),%edx
 5ba:	56                   	push   %esi
 5bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5be:	85 c0                	test   %eax,%eax
 5c0:	7e 13                	jle    5d5 <memmove+0x25>
 5c2:	01 d0                	add    %edx,%eax
  dst = vdst;
 5c4:	89 d7                	mov    %edx,%edi
 5c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 5cd:	00 
 5ce:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 5d0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 5d1:	39 f8                	cmp    %edi,%eax
 5d3:	75 fb                	jne    5d0 <memmove+0x20>
  return vdst;
}
 5d5:	5e                   	pop    %esi
 5d6:	89 d0                	mov    %edx,%eax
 5d8:	5f                   	pop    %edi
 5d9:	5d                   	pop    %ebp
 5da:	c3                   	ret

000005db <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5db:	b8 01 00 00 00       	mov    $0x1,%eax
 5e0:	cd 40                	int    $0x40
 5e2:	c3                   	ret

000005e3 <exit>:
SYSCALL(exit)
 5e3:	b8 02 00 00 00       	mov    $0x2,%eax
 5e8:	cd 40                	int    $0x40
 5ea:	c3                   	ret

000005eb <wait>:
SYSCALL(wait)
 5eb:	b8 03 00 00 00       	mov    $0x3,%eax
 5f0:	cd 40                	int    $0x40
 5f2:	c3                   	ret

000005f3 <pipe>:
SYSCALL(pipe)
 5f3:	b8 04 00 00 00       	mov    $0x4,%eax
 5f8:	cd 40                	int    $0x40
 5fa:	c3                   	ret

000005fb <read>:
SYSCALL(read)
 5fb:	b8 05 00 00 00       	mov    $0x5,%eax
 600:	cd 40                	int    $0x40
 602:	c3                   	ret

00000603 <write>:
SYSCALL(write)
 603:	b8 10 00 00 00       	mov    $0x10,%eax
 608:	cd 40                	int    $0x40
 60a:	c3                   	ret

0000060b <close>:
SYSCALL(close)
 60b:	b8 15 00 00 00       	mov    $0x15,%eax
 610:	cd 40                	int    $0x40
 612:	c3                   	ret

00000613 <kill>:
SYSCALL(kill)
 613:	b8 06 00 00 00       	mov    $0x6,%eax
 618:	cd 40                	int    $0x40
 61a:	c3                   	ret

0000061b <exec>:
SYSCALL(exec)
 61b:	b8 07 00 00 00       	mov    $0x7,%eax
 620:	cd 40                	int    $0x40
 622:	c3                   	ret

00000623 <open>:
SYSCALL(open)
 623:	b8 0f 00 00 00       	mov    $0xf,%eax
 628:	cd 40                	int    $0x40
 62a:	c3                   	ret

0000062b <mknod>:
SYSCALL(mknod)
 62b:	b8 11 00 00 00       	mov    $0x11,%eax
 630:	cd 40                	int    $0x40
 632:	c3                   	ret

00000633 <unlink>:
SYSCALL(unlink)
 633:	b8 12 00 00 00       	mov    $0x12,%eax
 638:	cd 40                	int    $0x40
 63a:	c3                   	ret

0000063b <fstat>:
SYSCALL(fstat)
 63b:	b8 08 00 00 00       	mov    $0x8,%eax
 640:	cd 40                	int    $0x40
 642:	c3                   	ret

00000643 <link>:
SYSCALL(link)
 643:	b8 13 00 00 00       	mov    $0x13,%eax
 648:	cd 40                	int    $0x40
 64a:	c3                   	ret

0000064b <mkdir>:
SYSCALL(mkdir)
 64b:	b8 14 00 00 00       	mov    $0x14,%eax
 650:	cd 40                	int    $0x40
 652:	c3                   	ret

00000653 <chdir>:
SYSCALL(chdir)
 653:	b8 09 00 00 00       	mov    $0x9,%eax
 658:	cd 40                	int    $0x40
 65a:	c3                   	ret

0000065b <dup>:
SYSCALL(dup)
 65b:	b8 0a 00 00 00       	mov    $0xa,%eax
 660:	cd 40                	int    $0x40
 662:	c3                   	ret

00000663 <getpid>:
SYSCALL(getpid)
 663:	b8 0b 00 00 00       	mov    $0xb,%eax
 668:	cd 40                	int    $0x40
 66a:	c3                   	ret

0000066b <sbrk>:
SYSCALL(sbrk)
 66b:	b8 0c 00 00 00       	mov    $0xc,%eax
 670:	cd 40                	int    $0x40
 672:	c3                   	ret

00000673 <sleep>:
SYSCALL(sleep)
 673:	b8 0d 00 00 00       	mov    $0xd,%eax
 678:	cd 40                	int    $0x40
 67a:	c3                   	ret

0000067b <uptime>:
SYSCALL(uptime)
 67b:	b8 0e 00 00 00       	mov    $0xe,%eax
 680:	cd 40                	int    $0x40
 682:	c3                   	ret

00000683 <gethistory>:
SYSCALL(gethistory)
 683:	b8 16 00 00 00       	mov    $0x16,%eax
 688:	cd 40                	int    $0x40
 68a:	c3                   	ret

0000068b <block>:
SYSCALL(block)
 68b:	b8 17 00 00 00       	mov    $0x17,%eax
 690:	cd 40                	int    $0x40
 692:	c3                   	ret

00000693 <unblock>:
SYSCALL(unblock)
 693:	b8 18 00 00 00       	mov    $0x18,%eax
 698:	cd 40                	int    $0x40
 69a:	c3                   	ret

0000069b <chmod>:
SYSCALL(chmod)
 69b:	b8 19 00 00 00       	mov    $0x19,%eax
 6a0:	cd 40                	int    $0x40
 6a2:	c3                   	ret
 6a3:	66 90                	xchg   %ax,%ax
 6a5:	66 90                	xchg   %ax,%ax
 6a7:	66 90                	xchg   %ax,%ax
 6a9:	66 90                	xchg   %ax,%ax
 6ab:	66 90                	xchg   %ax,%ax
 6ad:	66 90                	xchg   %ax,%ax
 6af:	90                   	nop

000006b0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 6b0:	55                   	push   %ebp
 6b1:	89 e5                	mov    %esp,%ebp
 6b3:	57                   	push   %edi
 6b4:	56                   	push   %esi
 6b5:	53                   	push   %ebx
 6b6:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 6b8:	89 d1                	mov    %edx,%ecx
{
 6ba:	83 ec 3c             	sub    $0x3c,%esp
 6bd:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 6c0:	85 d2                	test   %edx,%edx
 6c2:	0f 89 80 00 00 00    	jns    748 <printint+0x98>
 6c8:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 6cc:	74 7a                	je     748 <printint+0x98>
    x = -xx;
 6ce:	f7 d9                	neg    %ecx
    neg = 1;
 6d0:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 6d5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 6d8:	31 f6                	xor    %esi,%esi
 6da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 6e0:	89 c8                	mov    %ecx,%eax
 6e2:	31 d2                	xor    %edx,%edx
 6e4:	89 f7                	mov    %esi,%edi
 6e6:	f7 f3                	div    %ebx
 6e8:	8d 76 01             	lea    0x1(%esi),%esi
 6eb:	0f b6 92 f0 0a 00 00 	movzbl 0xaf0(%edx),%edx
 6f2:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 6f6:	89 ca                	mov    %ecx,%edx
 6f8:	89 c1                	mov    %eax,%ecx
 6fa:	39 da                	cmp    %ebx,%edx
 6fc:	73 e2                	jae    6e0 <printint+0x30>
  if(neg)
 6fe:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 701:	85 c0                	test   %eax,%eax
 703:	74 07                	je     70c <printint+0x5c>
    buf[i++] = '-';
 705:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 70a:	89 f7                	mov    %esi,%edi
 70c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 70f:	8b 75 c0             	mov    -0x40(%ebp),%esi
 712:	01 df                	add    %ebx,%edi
 714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 718:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 71b:	83 ec 04             	sub    $0x4,%esp
 71e:	88 45 d7             	mov    %al,-0x29(%ebp)
 721:	8d 45 d7             	lea    -0x29(%ebp),%eax
 724:	6a 01                	push   $0x1
 726:	50                   	push   %eax
 727:	56                   	push   %esi
 728:	e8 d6 fe ff ff       	call   603 <write>
  while(--i >= 0)
 72d:	89 f8                	mov    %edi,%eax
 72f:	83 c4 10             	add    $0x10,%esp
 732:	83 ef 01             	sub    $0x1,%edi
 735:	39 c3                	cmp    %eax,%ebx
 737:	75 df                	jne    718 <printint+0x68>
}
 739:	8d 65 f4             	lea    -0xc(%ebp),%esp
 73c:	5b                   	pop    %ebx
 73d:	5e                   	pop    %esi
 73e:	5f                   	pop    %edi
 73f:	5d                   	pop    %ebp
 740:	c3                   	ret
 741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 748:	31 c0                	xor    %eax,%eax
 74a:	eb 89                	jmp    6d5 <printint+0x25>
 74c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000750 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 750:	55                   	push   %ebp
 751:	89 e5                	mov    %esp,%ebp
 753:	57                   	push   %edi
 754:	56                   	push   %esi
 755:	53                   	push   %ebx
 756:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 759:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 75c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 75f:	0f b6 1e             	movzbl (%esi),%ebx
 762:	83 c6 01             	add    $0x1,%esi
 765:	84 db                	test   %bl,%bl
 767:	74 67                	je     7d0 <printf+0x80>
 769:	8d 4d 10             	lea    0x10(%ebp),%ecx
 76c:	31 d2                	xor    %edx,%edx
 76e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 771:	eb 34                	jmp    7a7 <printf+0x57>
 773:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 778:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 77b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 780:	83 f8 25             	cmp    $0x25,%eax
 783:	74 18                	je     79d <printf+0x4d>
  write(fd, &c, 1);
 785:	83 ec 04             	sub    $0x4,%esp
 788:	8d 45 e7             	lea    -0x19(%ebp),%eax
 78b:	88 5d e7             	mov    %bl,-0x19(%ebp)
 78e:	6a 01                	push   $0x1
 790:	50                   	push   %eax
 791:	57                   	push   %edi
 792:	e8 6c fe ff ff       	call   603 <write>
 797:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 79a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 79d:	0f b6 1e             	movzbl (%esi),%ebx
 7a0:	83 c6 01             	add    $0x1,%esi
 7a3:	84 db                	test   %bl,%bl
 7a5:	74 29                	je     7d0 <printf+0x80>
    c = fmt[i] & 0xff;
 7a7:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 7aa:	85 d2                	test   %edx,%edx
 7ac:	74 ca                	je     778 <printf+0x28>
      }
    } else if(state == '%'){
 7ae:	83 fa 25             	cmp    $0x25,%edx
 7b1:	75 ea                	jne    79d <printf+0x4d>
      if(c == 'd'){
 7b3:	83 f8 25             	cmp    $0x25,%eax
 7b6:	0f 84 04 01 00 00    	je     8c0 <printf+0x170>
 7bc:	83 e8 63             	sub    $0x63,%eax
 7bf:	83 f8 15             	cmp    $0x15,%eax
 7c2:	77 1c                	ja     7e0 <printf+0x90>
 7c4:	ff 24 85 98 0a 00 00 	jmp    *0xa98(,%eax,4)
 7cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7d3:	5b                   	pop    %ebx
 7d4:	5e                   	pop    %esi
 7d5:	5f                   	pop    %edi
 7d6:	5d                   	pop    %ebp
 7d7:	c3                   	ret
 7d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 7df:	00 
  write(fd, &c, 1);
 7e0:	83 ec 04             	sub    $0x4,%esp
 7e3:	8d 55 e7             	lea    -0x19(%ebp),%edx
 7e6:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 7ea:	6a 01                	push   $0x1
 7ec:	52                   	push   %edx
 7ed:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 7f0:	57                   	push   %edi
 7f1:	e8 0d fe ff ff       	call   603 <write>
 7f6:	83 c4 0c             	add    $0xc,%esp
 7f9:	88 5d e7             	mov    %bl,-0x19(%ebp)
 7fc:	6a 01                	push   $0x1
 7fe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 801:	52                   	push   %edx
 802:	57                   	push   %edi
 803:	e8 fb fd ff ff       	call   603 <write>
        putc(fd, c);
 808:	83 c4 10             	add    $0x10,%esp
      state = 0;
 80b:	31 d2                	xor    %edx,%edx
 80d:	eb 8e                	jmp    79d <printf+0x4d>
 80f:	90                   	nop
        printint(fd, *ap, 16, 0);
 810:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 813:	83 ec 0c             	sub    $0xc,%esp
 816:	b9 10 00 00 00       	mov    $0x10,%ecx
 81b:	8b 13                	mov    (%ebx),%edx
 81d:	6a 00                	push   $0x0
 81f:	89 f8                	mov    %edi,%eax
        ap++;
 821:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 824:	e8 87 fe ff ff       	call   6b0 <printint>
        ap++;
 829:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 82c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 82f:	31 d2                	xor    %edx,%edx
 831:	e9 67 ff ff ff       	jmp    79d <printf+0x4d>
        s = (char*)*ap;
 836:	8b 45 d0             	mov    -0x30(%ebp),%eax
 839:	8b 18                	mov    (%eax),%ebx
        ap++;
 83b:	83 c0 04             	add    $0x4,%eax
 83e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 841:	85 db                	test   %ebx,%ebx
 843:	0f 84 87 00 00 00    	je     8d0 <printf+0x180>
        while(*s != 0){
 849:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 84c:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 84e:	84 c0                	test   %al,%al
 850:	0f 84 47 ff ff ff    	je     79d <printf+0x4d>
 856:	8d 55 e7             	lea    -0x19(%ebp),%edx
 859:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 85c:	89 de                	mov    %ebx,%esi
 85e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 860:	83 ec 04             	sub    $0x4,%esp
 863:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 866:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 869:	6a 01                	push   $0x1
 86b:	53                   	push   %ebx
 86c:	57                   	push   %edi
 86d:	e8 91 fd ff ff       	call   603 <write>
        while(*s != 0){
 872:	0f b6 06             	movzbl (%esi),%eax
 875:	83 c4 10             	add    $0x10,%esp
 878:	84 c0                	test   %al,%al
 87a:	75 e4                	jne    860 <printf+0x110>
      state = 0;
 87c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 87f:	31 d2                	xor    %edx,%edx
 881:	e9 17 ff ff ff       	jmp    79d <printf+0x4d>
        printint(fd, *ap, 10, 1);
 886:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 889:	83 ec 0c             	sub    $0xc,%esp
 88c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 891:	8b 13                	mov    (%ebx),%edx
 893:	6a 01                	push   $0x1
 895:	eb 88                	jmp    81f <printf+0xcf>
        putc(fd, *ap);
 897:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 89a:	83 ec 04             	sub    $0x4,%esp
 89d:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 8a0:	8b 03                	mov    (%ebx),%eax
        ap++;
 8a2:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 8a5:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 8a8:	6a 01                	push   $0x1
 8aa:	52                   	push   %edx
 8ab:	57                   	push   %edi
 8ac:	e8 52 fd ff ff       	call   603 <write>
        ap++;
 8b1:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 8b4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 8b7:	31 d2                	xor    %edx,%edx
 8b9:	e9 df fe ff ff       	jmp    79d <printf+0x4d>
 8be:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 8c0:	83 ec 04             	sub    $0x4,%esp
 8c3:	88 5d e7             	mov    %bl,-0x19(%ebp)
 8c6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 8c9:	6a 01                	push   $0x1
 8cb:	e9 31 ff ff ff       	jmp    801 <printf+0xb1>
 8d0:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 8d5:	bb 8e 0a 00 00       	mov    $0xa8e,%ebx
 8da:	e9 77 ff ff ff       	jmp    856 <printf+0x106>
 8df:	90                   	nop

000008e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8e0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e1:	a1 80 12 00 00       	mov    0x1280,%eax
{
 8e6:	89 e5                	mov    %esp,%ebp
 8e8:	57                   	push   %edi
 8e9:	56                   	push   %esi
 8ea:	53                   	push   %ebx
 8eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 8ee:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8f8:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8fa:	39 c8                	cmp    %ecx,%eax
 8fc:	73 32                	jae    930 <free+0x50>
 8fe:	39 d1                	cmp    %edx,%ecx
 900:	72 04                	jb     906 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 902:	39 d0                	cmp    %edx,%eax
 904:	72 32                	jb     938 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 906:	8b 73 fc             	mov    -0x4(%ebx),%esi
 909:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 90c:	39 fa                	cmp    %edi,%edx
 90e:	74 30                	je     940 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 910:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 913:	8b 50 04             	mov    0x4(%eax),%edx
 916:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 919:	39 f1                	cmp    %esi,%ecx
 91b:	74 3a                	je     957 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 91d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 91f:	5b                   	pop    %ebx
  freep = p;
 920:	a3 80 12 00 00       	mov    %eax,0x1280
}
 925:	5e                   	pop    %esi
 926:	5f                   	pop    %edi
 927:	5d                   	pop    %ebp
 928:	c3                   	ret
 929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 930:	39 d0                	cmp    %edx,%eax
 932:	72 04                	jb     938 <free+0x58>
 934:	39 d1                	cmp    %edx,%ecx
 936:	72 ce                	jb     906 <free+0x26>
{
 938:	89 d0                	mov    %edx,%eax
 93a:	eb bc                	jmp    8f8 <free+0x18>
 93c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 940:	03 72 04             	add    0x4(%edx),%esi
 943:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 946:	8b 10                	mov    (%eax),%edx
 948:	8b 12                	mov    (%edx),%edx
 94a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 94d:	8b 50 04             	mov    0x4(%eax),%edx
 950:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 953:	39 f1                	cmp    %esi,%ecx
 955:	75 c6                	jne    91d <free+0x3d>
    p->s.size += bp->s.size;
 957:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 95a:	a3 80 12 00 00       	mov    %eax,0x1280
    p->s.size += bp->s.size;
 95f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 962:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 965:	89 08                	mov    %ecx,(%eax)
}
 967:	5b                   	pop    %ebx
 968:	5e                   	pop    %esi
 969:	5f                   	pop    %edi
 96a:	5d                   	pop    %ebp
 96b:	c3                   	ret
 96c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000970 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 970:	55                   	push   %ebp
 971:	89 e5                	mov    %esp,%ebp
 973:	57                   	push   %edi
 974:	56                   	push   %esi
 975:	53                   	push   %ebx
 976:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 979:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 97c:	8b 15 80 12 00 00    	mov    0x1280,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 982:	8d 78 07             	lea    0x7(%eax),%edi
 985:	c1 ef 03             	shr    $0x3,%edi
 988:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 98b:	85 d2                	test   %edx,%edx
 98d:	0f 84 8d 00 00 00    	je     a20 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 993:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 995:	8b 48 04             	mov    0x4(%eax),%ecx
 998:	39 f9                	cmp    %edi,%ecx
 99a:	73 64                	jae    a00 <malloc+0x90>
  if(nu < 4096)
 99c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 9a1:	39 df                	cmp    %ebx,%edi
 9a3:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 9a6:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 9ad:	eb 0a                	jmp    9b9 <malloc+0x49>
 9af:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 9b2:	8b 48 04             	mov    0x4(%eax),%ecx
 9b5:	39 f9                	cmp    %edi,%ecx
 9b7:	73 47                	jae    a00 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9b9:	89 c2                	mov    %eax,%edx
 9bb:	3b 05 80 12 00 00    	cmp    0x1280,%eax
 9c1:	75 ed                	jne    9b0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 9c3:	83 ec 0c             	sub    $0xc,%esp
 9c6:	56                   	push   %esi
 9c7:	e8 9f fc ff ff       	call   66b <sbrk>
  if(p == (char*)-1)
 9cc:	83 c4 10             	add    $0x10,%esp
 9cf:	83 f8 ff             	cmp    $0xffffffff,%eax
 9d2:	74 1c                	je     9f0 <malloc+0x80>
  hp->s.size = nu;
 9d4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 9d7:	83 ec 0c             	sub    $0xc,%esp
 9da:	83 c0 08             	add    $0x8,%eax
 9dd:	50                   	push   %eax
 9de:	e8 fd fe ff ff       	call   8e0 <free>
  return freep;
 9e3:	8b 15 80 12 00 00    	mov    0x1280,%edx
      if((p = morecore(nunits)) == 0)
 9e9:	83 c4 10             	add    $0x10,%esp
 9ec:	85 d2                	test   %edx,%edx
 9ee:	75 c0                	jne    9b0 <malloc+0x40>
        return 0;
  }
}
 9f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 9f3:	31 c0                	xor    %eax,%eax
}
 9f5:	5b                   	pop    %ebx
 9f6:	5e                   	pop    %esi
 9f7:	5f                   	pop    %edi
 9f8:	5d                   	pop    %ebp
 9f9:	c3                   	ret
 9fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 a00:	39 cf                	cmp    %ecx,%edi
 a02:	74 4c                	je     a50 <malloc+0xe0>
        p->s.size -= nunits;
 a04:	29 f9                	sub    %edi,%ecx
 a06:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 a09:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 a0c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 a0f:	89 15 80 12 00 00    	mov    %edx,0x1280
}
 a15:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 a18:	83 c0 08             	add    $0x8,%eax
}
 a1b:	5b                   	pop    %ebx
 a1c:	5e                   	pop    %esi
 a1d:	5f                   	pop    %edi
 a1e:	5d                   	pop    %ebp
 a1f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 a20:	c7 05 80 12 00 00 84 	movl   $0x1284,0x1280
 a27:	12 00 00 
    base.s.size = 0;
 a2a:	b8 84 12 00 00       	mov    $0x1284,%eax
    base.s.ptr = freep = prevp = &base;
 a2f:	c7 05 84 12 00 00 84 	movl   $0x1284,0x1284
 a36:	12 00 00 
    base.s.size = 0;
 a39:	c7 05 88 12 00 00 00 	movl   $0x0,0x1288
 a40:	00 00 00 
    if(p->s.size >= nunits){
 a43:	e9 54 ff ff ff       	jmp    99c <malloc+0x2c>
 a48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 a4f:	00 
        prevp->s.ptr = p->s.ptr;
 a50:	8b 08                	mov    (%eax),%ecx
 a52:	89 0a                	mov    %ecx,(%edx)
 a54:	eb b9                	jmp    a0f <malloc+0x9f>
