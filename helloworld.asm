
_helloworld:     формат файла elf32-i386


Дизассемблирование раздела .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main() {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
	char s[] = "Hello, world!";
  11:	c7 45 ea 48 65 6c 6c 	movl   $0x6c6c6548,-0x16(%ebp)
  18:	c7 45 ee 6f 2c 20 77 	movl   $0x77202c6f,-0x12(%ebp)
  1f:	c7 45 f2 6f 72 6c 64 	movl   $0x646c726f,-0xe(%ebp)
  26:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
	printf(1, "%s\n", s);
  2c:	83 ec 04             	sub    $0x4,%esp
  2f:	8d 45 ea             	lea    -0x16(%ebp),%eax
  32:	50                   	push   %eax
  33:	68 eb 07 00 00       	push   $0x7eb
  38:	6a 01                	push   $0x1
  3a:	e8 f6 03 00 00       	call   435 <printf>
  3f:	83 c4 10             	add    $0x10,%esp
	exit();
  42:	e8 57 02 00 00       	call   29e <exit>

00000047 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  47:	55                   	push   %ebp
  48:	89 e5                	mov    %esp,%ebp
  4a:	57                   	push   %edi
  4b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  4c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  4f:	8b 55 10             	mov    0x10(%ebp),%edx
  52:	8b 45 0c             	mov    0xc(%ebp),%eax
  55:	89 cb                	mov    %ecx,%ebx
  57:	89 df                	mov    %ebx,%edi
  59:	89 d1                	mov    %edx,%ecx
  5b:	fc                   	cld    
  5c:	f3 aa                	rep stos %al,%es:(%edi)
  5e:	89 ca                	mov    %ecx,%edx
  60:	89 fb                	mov    %edi,%ebx
  62:	89 5d 08             	mov    %ebx,0x8(%ebp)
  65:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  68:	90                   	nop
  69:	5b                   	pop    %ebx
  6a:	5f                   	pop    %edi
  6b:	5d                   	pop    %ebp
  6c:	c3                   	ret    

0000006d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  6d:	55                   	push   %ebp
  6e:	89 e5                	mov    %esp,%ebp
  70:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  73:	8b 45 08             	mov    0x8(%ebp),%eax
  76:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  79:	90                   	nop
  7a:	8b 45 08             	mov    0x8(%ebp),%eax
  7d:	8d 50 01             	lea    0x1(%eax),%edx
  80:	89 55 08             	mov    %edx,0x8(%ebp)
  83:	8b 55 0c             	mov    0xc(%ebp),%edx
  86:	8d 4a 01             	lea    0x1(%edx),%ecx
  89:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8c:	0f b6 12             	movzbl (%edx),%edx
  8f:	88 10                	mov    %dl,(%eax)
  91:	0f b6 00             	movzbl (%eax),%eax
  94:	84 c0                	test   %al,%al
  96:	75 e2                	jne    7a <strcpy+0xd>
    ;
  return os;
  98:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  9b:	c9                   	leave  
  9c:	c3                   	ret    

0000009d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  9d:	55                   	push   %ebp
  9e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  a0:	eb 08                	jmp    aa <strcmp+0xd>
    p++, q++;
  a2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  a6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  aa:	8b 45 08             	mov    0x8(%ebp),%eax
  ad:	0f b6 00             	movzbl (%eax),%eax
  b0:	84 c0                	test   %al,%al
  b2:	74 10                	je     c4 <strcmp+0x27>
  b4:	8b 45 08             	mov    0x8(%ebp),%eax
  b7:	0f b6 10             	movzbl (%eax),%edx
  ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  bd:	0f b6 00             	movzbl (%eax),%eax
  c0:	38 c2                	cmp    %al,%dl
  c2:	74 de                	je     a2 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  c4:	8b 45 08             	mov    0x8(%ebp),%eax
  c7:	0f b6 00             	movzbl (%eax),%eax
  ca:	0f b6 d0             	movzbl %al,%edx
  cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  d0:	0f b6 00             	movzbl (%eax),%eax
  d3:	0f b6 c0             	movzbl %al,%eax
  d6:	29 c2                	sub    %eax,%edx
  d8:	89 d0                	mov    %edx,%eax
}
  da:	5d                   	pop    %ebp
  db:	c3                   	ret    

000000dc <strlen>:

uint
strlen(char *s)
{
  dc:	55                   	push   %ebp
  dd:	89 e5                	mov    %esp,%ebp
  df:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  e9:	eb 04                	jmp    ef <strlen+0x13>
  eb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  f2:	8b 45 08             	mov    0x8(%ebp),%eax
  f5:	01 d0                	add    %edx,%eax
  f7:	0f b6 00             	movzbl (%eax),%eax
  fa:	84 c0                	test   %al,%al
  fc:	75 ed                	jne    eb <strlen+0xf>
    ;
  return n;
  fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 101:	c9                   	leave  
 102:	c3                   	ret    

00000103 <memset>:

void*
memset(void *dst, int c, uint n)
{
 103:	55                   	push   %ebp
 104:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 106:	8b 45 10             	mov    0x10(%ebp),%eax
 109:	50                   	push   %eax
 10a:	ff 75 0c             	pushl  0xc(%ebp)
 10d:	ff 75 08             	pushl  0x8(%ebp)
 110:	e8 32 ff ff ff       	call   47 <stosb>
 115:	83 c4 0c             	add    $0xc,%esp
  return dst;
 118:	8b 45 08             	mov    0x8(%ebp),%eax
}
 11b:	c9                   	leave  
 11c:	c3                   	ret    

0000011d <strchr>:

char*
strchr(const char *s, char c)
{
 11d:	55                   	push   %ebp
 11e:	89 e5                	mov    %esp,%ebp
 120:	83 ec 04             	sub    $0x4,%esp
 123:	8b 45 0c             	mov    0xc(%ebp),%eax
 126:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 129:	eb 14                	jmp    13f <strchr+0x22>
    if(*s == c)
 12b:	8b 45 08             	mov    0x8(%ebp),%eax
 12e:	0f b6 00             	movzbl (%eax),%eax
 131:	3a 45 fc             	cmp    -0x4(%ebp),%al
 134:	75 05                	jne    13b <strchr+0x1e>
      return (char*)s;
 136:	8b 45 08             	mov    0x8(%ebp),%eax
 139:	eb 13                	jmp    14e <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 13b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 13f:	8b 45 08             	mov    0x8(%ebp),%eax
 142:	0f b6 00             	movzbl (%eax),%eax
 145:	84 c0                	test   %al,%al
 147:	75 e2                	jne    12b <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 149:	b8 00 00 00 00       	mov    $0x0,%eax
}
 14e:	c9                   	leave  
 14f:	c3                   	ret    

00000150 <gets>:

char*
gets(char *buf, int max)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 156:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 15d:	eb 42                	jmp    1a1 <gets+0x51>
    cc = read(0, &c, 1);
 15f:	83 ec 04             	sub    $0x4,%esp
 162:	6a 01                	push   $0x1
 164:	8d 45 ef             	lea    -0x11(%ebp),%eax
 167:	50                   	push   %eax
 168:	6a 00                	push   $0x0
 16a:	e8 47 01 00 00       	call   2b6 <read>
 16f:	83 c4 10             	add    $0x10,%esp
 172:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 175:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 179:	7e 33                	jle    1ae <gets+0x5e>
      break;
    buf[i++] = c;
 17b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 17e:	8d 50 01             	lea    0x1(%eax),%edx
 181:	89 55 f4             	mov    %edx,-0xc(%ebp)
 184:	89 c2                	mov    %eax,%edx
 186:	8b 45 08             	mov    0x8(%ebp),%eax
 189:	01 c2                	add    %eax,%edx
 18b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 18f:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 191:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 195:	3c 0a                	cmp    $0xa,%al
 197:	74 16                	je     1af <gets+0x5f>
 199:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 19d:	3c 0d                	cmp    $0xd,%al
 19f:	74 0e                	je     1af <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a4:	83 c0 01             	add    $0x1,%eax
 1a7:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1aa:	7c b3                	jl     15f <gets+0xf>
 1ac:	eb 01                	jmp    1af <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1ae:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1af:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1b2:	8b 45 08             	mov    0x8(%ebp),%eax
 1b5:	01 d0                	add    %edx,%eax
 1b7:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1bd:	c9                   	leave  
 1be:	c3                   	ret    

000001bf <stat>:

int
stat(char *n, struct stat *st)
{
 1bf:	55                   	push   %ebp
 1c0:	89 e5                	mov    %esp,%ebp
 1c2:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY | O_NBLOCK);
 1c5:	83 ec 08             	sub    $0x8,%esp
 1c8:	6a 10                	push   $0x10
 1ca:	ff 75 08             	pushl  0x8(%ebp)
 1cd:	e8 0c 01 00 00       	call   2de <open>
 1d2:	83 c4 10             	add    $0x10,%esp
 1d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1dc:	79 07                	jns    1e5 <stat+0x26>
    return -1;
 1de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1e3:	eb 25                	jmp    20a <stat+0x4b>
  r = fstat(fd, st);
 1e5:	83 ec 08             	sub    $0x8,%esp
 1e8:	ff 75 0c             	pushl  0xc(%ebp)
 1eb:	ff 75 f4             	pushl  -0xc(%ebp)
 1ee:	e8 03 01 00 00       	call   2f6 <fstat>
 1f3:	83 c4 10             	add    $0x10,%esp
 1f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1f9:	83 ec 0c             	sub    $0xc,%esp
 1fc:	ff 75 f4             	pushl  -0xc(%ebp)
 1ff:	e8 c2 00 00 00       	call   2c6 <close>
 204:	83 c4 10             	add    $0x10,%esp
  return r;
 207:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 20a:	c9                   	leave  
 20b:	c3                   	ret    

0000020c <atoi>:

int
atoi(const char *s)
{
 20c:	55                   	push   %ebp
 20d:	89 e5                	mov    %esp,%ebp
 20f:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 212:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 219:	eb 25                	jmp    240 <atoi+0x34>
    n = n*10 + *s++ - '0';
 21b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 21e:	89 d0                	mov    %edx,%eax
 220:	c1 e0 02             	shl    $0x2,%eax
 223:	01 d0                	add    %edx,%eax
 225:	01 c0                	add    %eax,%eax
 227:	89 c1                	mov    %eax,%ecx
 229:	8b 45 08             	mov    0x8(%ebp),%eax
 22c:	8d 50 01             	lea    0x1(%eax),%edx
 22f:	89 55 08             	mov    %edx,0x8(%ebp)
 232:	0f b6 00             	movzbl (%eax),%eax
 235:	0f be c0             	movsbl %al,%eax
 238:	01 c8                	add    %ecx,%eax
 23a:	83 e8 30             	sub    $0x30,%eax
 23d:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 240:	8b 45 08             	mov    0x8(%ebp),%eax
 243:	0f b6 00             	movzbl (%eax),%eax
 246:	3c 2f                	cmp    $0x2f,%al
 248:	7e 0a                	jle    254 <atoi+0x48>
 24a:	8b 45 08             	mov    0x8(%ebp),%eax
 24d:	0f b6 00             	movzbl (%eax),%eax
 250:	3c 39                	cmp    $0x39,%al
 252:	7e c7                	jle    21b <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 254:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 257:	c9                   	leave  
 258:	c3                   	ret    

00000259 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 259:	55                   	push   %ebp
 25a:	89 e5                	mov    %esp,%ebp
 25c:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 25f:	8b 45 08             	mov    0x8(%ebp),%eax
 262:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 265:	8b 45 0c             	mov    0xc(%ebp),%eax
 268:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 26b:	eb 17                	jmp    284 <memmove+0x2b>
    *dst++ = *src++;
 26d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 270:	8d 50 01             	lea    0x1(%eax),%edx
 273:	89 55 fc             	mov    %edx,-0x4(%ebp)
 276:	8b 55 f8             	mov    -0x8(%ebp),%edx
 279:	8d 4a 01             	lea    0x1(%edx),%ecx
 27c:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 27f:	0f b6 12             	movzbl (%edx),%edx
 282:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 284:	8b 45 10             	mov    0x10(%ebp),%eax
 287:	8d 50 ff             	lea    -0x1(%eax),%edx
 28a:	89 55 10             	mov    %edx,0x10(%ebp)
 28d:	85 c0                	test   %eax,%eax
 28f:	7f dc                	jg     26d <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 291:	8b 45 08             	mov    0x8(%ebp),%eax
}
 294:	c9                   	leave  
 295:	c3                   	ret    

00000296 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 296:	b8 01 00 00 00       	mov    $0x1,%eax
 29b:	cd 40                	int    $0x40
 29d:	c3                   	ret    

0000029e <exit>:
SYSCALL(exit)
 29e:	b8 02 00 00 00       	mov    $0x2,%eax
 2a3:	cd 40                	int    $0x40
 2a5:	c3                   	ret    

000002a6 <wait>:
SYSCALL(wait)
 2a6:	b8 03 00 00 00       	mov    $0x3,%eax
 2ab:	cd 40                	int    $0x40
 2ad:	c3                   	ret    

000002ae <pipe>:
SYSCALL(pipe)
 2ae:	b8 04 00 00 00       	mov    $0x4,%eax
 2b3:	cd 40                	int    $0x40
 2b5:	c3                   	ret    

000002b6 <read>:
SYSCALL(read)
 2b6:	b8 05 00 00 00       	mov    $0x5,%eax
 2bb:	cd 40                	int    $0x40
 2bd:	c3                   	ret    

000002be <write>:
SYSCALL(write)
 2be:	b8 10 00 00 00       	mov    $0x10,%eax
 2c3:	cd 40                	int    $0x40
 2c5:	c3                   	ret    

000002c6 <close>:
SYSCALL(close)
 2c6:	b8 15 00 00 00       	mov    $0x15,%eax
 2cb:	cd 40                	int    $0x40
 2cd:	c3                   	ret    

000002ce <kill>:
SYSCALL(kill)
 2ce:	b8 06 00 00 00       	mov    $0x6,%eax
 2d3:	cd 40                	int    $0x40
 2d5:	c3                   	ret    

000002d6 <exec>:
SYSCALL(exec)
 2d6:	b8 07 00 00 00       	mov    $0x7,%eax
 2db:	cd 40                	int    $0x40
 2dd:	c3                   	ret    

000002de <open>:
SYSCALL(open)
 2de:	b8 0f 00 00 00       	mov    $0xf,%eax
 2e3:	cd 40                	int    $0x40
 2e5:	c3                   	ret    

000002e6 <mknod>:
SYSCALL(mknod)
 2e6:	b8 11 00 00 00       	mov    $0x11,%eax
 2eb:	cd 40                	int    $0x40
 2ed:	c3                   	ret    

000002ee <unlink>:
SYSCALL(unlink)
 2ee:	b8 12 00 00 00       	mov    $0x12,%eax
 2f3:	cd 40                	int    $0x40
 2f5:	c3                   	ret    

000002f6 <fstat>:
SYSCALL(fstat)
 2f6:	b8 08 00 00 00       	mov    $0x8,%eax
 2fb:	cd 40                	int    $0x40
 2fd:	c3                   	ret    

000002fe <link>:
SYSCALL(link)
 2fe:	b8 13 00 00 00       	mov    $0x13,%eax
 303:	cd 40                	int    $0x40
 305:	c3                   	ret    

00000306 <mkdir>:
SYSCALL(mkdir)
 306:	b8 14 00 00 00       	mov    $0x14,%eax
 30b:	cd 40                	int    $0x40
 30d:	c3                   	ret    

0000030e <chdir>:
SYSCALL(chdir)
 30e:	b8 09 00 00 00       	mov    $0x9,%eax
 313:	cd 40                	int    $0x40
 315:	c3                   	ret    

00000316 <dup>:
SYSCALL(dup)
 316:	b8 0a 00 00 00       	mov    $0xa,%eax
 31b:	cd 40                	int    $0x40
 31d:	c3                   	ret    

0000031e <getpid>:
SYSCALL(getpid)
 31e:	b8 0b 00 00 00       	mov    $0xb,%eax
 323:	cd 40                	int    $0x40
 325:	c3                   	ret    

00000326 <sbrk>:
SYSCALL(sbrk)
 326:	b8 0c 00 00 00       	mov    $0xc,%eax
 32b:	cd 40                	int    $0x40
 32d:	c3                   	ret    

0000032e <sleep>:
SYSCALL(sleep)
 32e:	b8 0d 00 00 00       	mov    $0xd,%eax
 333:	cd 40                	int    $0x40
 335:	c3                   	ret    

00000336 <uptime>:
SYSCALL(uptime)
 336:	b8 0e 00 00 00       	mov    $0xe,%eax
 33b:	cd 40                	int    $0x40
 33d:	c3                   	ret    

0000033e <mkfifo>:
SYSCALL(mkfifo)
 33e:	b8 16 00 00 00       	mov    $0x16,%eax
 343:	cd 40                	int    $0x40
 345:	c3                   	ret    

00000346 <up>:
SYSCALL(up)
 346:	b8 18 00 00 00       	mov    $0x18,%eax
 34b:	cd 40                	int    $0x40
 34d:	c3                   	ret    

0000034e <down>:
SYSCALL(down)
 34e:	b8 17 00 00 00       	mov    $0x17,%eax
 353:	cd 40                	int    $0x40
 355:	c3                   	ret    

00000356 <setuid>:
 356:	b8 19 00 00 00       	mov    $0x19,%eax
 35b:	cd 40                	int    $0x40
 35d:	c3                   	ret    

0000035e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 35e:	55                   	push   %ebp
 35f:	89 e5                	mov    %esp,%ebp
 361:	83 ec 18             	sub    $0x18,%esp
 364:	8b 45 0c             	mov    0xc(%ebp),%eax
 367:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 36a:	83 ec 04             	sub    $0x4,%esp
 36d:	6a 01                	push   $0x1
 36f:	8d 45 f4             	lea    -0xc(%ebp),%eax
 372:	50                   	push   %eax
 373:	ff 75 08             	pushl  0x8(%ebp)
 376:	e8 43 ff ff ff       	call   2be <write>
 37b:	83 c4 10             	add    $0x10,%esp
}
 37e:	90                   	nop
 37f:	c9                   	leave  
 380:	c3                   	ret    

00000381 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 381:	55                   	push   %ebp
 382:	89 e5                	mov    %esp,%ebp
 384:	53                   	push   %ebx
 385:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 388:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 38f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 393:	74 17                	je     3ac <printint+0x2b>
 395:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 399:	79 11                	jns    3ac <printint+0x2b>
    neg = 1;
 39b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a5:	f7 d8                	neg    %eax
 3a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3aa:	eb 06                	jmp    3b2 <printint+0x31>
  } else {
    x = xx;
 3ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 3af:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3b9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3bc:	8d 41 01             	lea    0x1(%ecx),%eax
 3bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3c8:	ba 00 00 00 00       	mov    $0x0,%edx
 3cd:	f7 f3                	div    %ebx
 3cf:	89 d0                	mov    %edx,%eax
 3d1:	0f b6 80 40 0a 00 00 	movzbl 0xa40(%eax),%eax
 3d8:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3dc:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3df:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3e2:	ba 00 00 00 00       	mov    $0x0,%edx
 3e7:	f7 f3                	div    %ebx
 3e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3f0:	75 c7                	jne    3b9 <printint+0x38>
  if(neg)
 3f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3f6:	74 2d                	je     425 <printint+0xa4>
    buf[i++] = '-';
 3f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3fb:	8d 50 01             	lea    0x1(%eax),%edx
 3fe:	89 55 f4             	mov    %edx,-0xc(%ebp)
 401:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 406:	eb 1d                	jmp    425 <printint+0xa4>
    putc(fd, buf[i]);
 408:	8d 55 dc             	lea    -0x24(%ebp),%edx
 40b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 40e:	01 d0                	add    %edx,%eax
 410:	0f b6 00             	movzbl (%eax),%eax
 413:	0f be c0             	movsbl %al,%eax
 416:	83 ec 08             	sub    $0x8,%esp
 419:	50                   	push   %eax
 41a:	ff 75 08             	pushl  0x8(%ebp)
 41d:	e8 3c ff ff ff       	call   35e <putc>
 422:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 425:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 429:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 42d:	79 d9                	jns    408 <printint+0x87>
    putc(fd, buf[i]);
}
 42f:	90                   	nop
 430:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 433:	c9                   	leave  
 434:	c3                   	ret    

00000435 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 435:	55                   	push   %ebp
 436:	89 e5                	mov    %esp,%ebp
 438:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 43b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 442:	8d 45 0c             	lea    0xc(%ebp),%eax
 445:	83 c0 04             	add    $0x4,%eax
 448:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 44b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 452:	e9 59 01 00 00       	jmp    5b0 <printf+0x17b>
    c = fmt[i] & 0xff;
 457:	8b 55 0c             	mov    0xc(%ebp),%edx
 45a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 45d:	01 d0                	add    %edx,%eax
 45f:	0f b6 00             	movzbl (%eax),%eax
 462:	0f be c0             	movsbl %al,%eax
 465:	25 ff 00 00 00       	and    $0xff,%eax
 46a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 46d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 471:	75 2c                	jne    49f <printf+0x6a>
      if(c == '%'){
 473:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 477:	75 0c                	jne    485 <printf+0x50>
        state = '%';
 479:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 480:	e9 27 01 00 00       	jmp    5ac <printf+0x177>
      } else {
        putc(fd, c);
 485:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 488:	0f be c0             	movsbl %al,%eax
 48b:	83 ec 08             	sub    $0x8,%esp
 48e:	50                   	push   %eax
 48f:	ff 75 08             	pushl  0x8(%ebp)
 492:	e8 c7 fe ff ff       	call   35e <putc>
 497:	83 c4 10             	add    $0x10,%esp
 49a:	e9 0d 01 00 00       	jmp    5ac <printf+0x177>
      }
    } else if(state == '%'){
 49f:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4a3:	0f 85 03 01 00 00    	jne    5ac <printf+0x177>
      if(c == 'd'){
 4a9:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4ad:	75 1e                	jne    4cd <printf+0x98>
        printint(fd, *ap, 10, 1);
 4af:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4b2:	8b 00                	mov    (%eax),%eax
 4b4:	6a 01                	push   $0x1
 4b6:	6a 0a                	push   $0xa
 4b8:	50                   	push   %eax
 4b9:	ff 75 08             	pushl  0x8(%ebp)
 4bc:	e8 c0 fe ff ff       	call   381 <printint>
 4c1:	83 c4 10             	add    $0x10,%esp
        ap++;
 4c4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4c8:	e9 d8 00 00 00       	jmp    5a5 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4cd:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4d1:	74 06                	je     4d9 <printf+0xa4>
 4d3:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4d7:	75 1e                	jne    4f7 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4dc:	8b 00                	mov    (%eax),%eax
 4de:	6a 00                	push   $0x0
 4e0:	6a 10                	push   $0x10
 4e2:	50                   	push   %eax
 4e3:	ff 75 08             	pushl  0x8(%ebp)
 4e6:	e8 96 fe ff ff       	call   381 <printint>
 4eb:	83 c4 10             	add    $0x10,%esp
        ap++;
 4ee:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4f2:	e9 ae 00 00 00       	jmp    5a5 <printf+0x170>
      } else if(c == 's'){
 4f7:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4fb:	75 43                	jne    540 <printf+0x10b>
        s = (char*)*ap;
 4fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 500:	8b 00                	mov    (%eax),%eax
 502:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 505:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 509:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 50d:	75 25                	jne    534 <printf+0xff>
          s = "(null)";
 50f:	c7 45 f4 ef 07 00 00 	movl   $0x7ef,-0xc(%ebp)
        while(*s != 0){
 516:	eb 1c                	jmp    534 <printf+0xff>
          putc(fd, *s);
 518:	8b 45 f4             	mov    -0xc(%ebp),%eax
 51b:	0f b6 00             	movzbl (%eax),%eax
 51e:	0f be c0             	movsbl %al,%eax
 521:	83 ec 08             	sub    $0x8,%esp
 524:	50                   	push   %eax
 525:	ff 75 08             	pushl  0x8(%ebp)
 528:	e8 31 fe ff ff       	call   35e <putc>
 52d:	83 c4 10             	add    $0x10,%esp
          s++;
 530:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 534:	8b 45 f4             	mov    -0xc(%ebp),%eax
 537:	0f b6 00             	movzbl (%eax),%eax
 53a:	84 c0                	test   %al,%al
 53c:	75 da                	jne    518 <printf+0xe3>
 53e:	eb 65                	jmp    5a5 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 540:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 544:	75 1d                	jne    563 <printf+0x12e>
        putc(fd, *ap);
 546:	8b 45 e8             	mov    -0x18(%ebp),%eax
 549:	8b 00                	mov    (%eax),%eax
 54b:	0f be c0             	movsbl %al,%eax
 54e:	83 ec 08             	sub    $0x8,%esp
 551:	50                   	push   %eax
 552:	ff 75 08             	pushl  0x8(%ebp)
 555:	e8 04 fe ff ff       	call   35e <putc>
 55a:	83 c4 10             	add    $0x10,%esp
        ap++;
 55d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 561:	eb 42                	jmp    5a5 <printf+0x170>
      } else if(c == '%'){
 563:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 567:	75 17                	jne    580 <printf+0x14b>
        putc(fd, c);
 569:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 56c:	0f be c0             	movsbl %al,%eax
 56f:	83 ec 08             	sub    $0x8,%esp
 572:	50                   	push   %eax
 573:	ff 75 08             	pushl  0x8(%ebp)
 576:	e8 e3 fd ff ff       	call   35e <putc>
 57b:	83 c4 10             	add    $0x10,%esp
 57e:	eb 25                	jmp    5a5 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 580:	83 ec 08             	sub    $0x8,%esp
 583:	6a 25                	push   $0x25
 585:	ff 75 08             	pushl  0x8(%ebp)
 588:	e8 d1 fd ff ff       	call   35e <putc>
 58d:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 590:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 593:	0f be c0             	movsbl %al,%eax
 596:	83 ec 08             	sub    $0x8,%esp
 599:	50                   	push   %eax
 59a:	ff 75 08             	pushl  0x8(%ebp)
 59d:	e8 bc fd ff ff       	call   35e <putc>
 5a2:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5a5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5ac:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5b0:	8b 55 0c             	mov    0xc(%ebp),%edx
 5b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5b6:	01 d0                	add    %edx,%eax
 5b8:	0f b6 00             	movzbl (%eax),%eax
 5bb:	84 c0                	test   %al,%al
 5bd:	0f 85 94 fe ff ff    	jne    457 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5c3:	90                   	nop
 5c4:	c9                   	leave  
 5c5:	c3                   	ret    

000005c6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5c6:	55                   	push   %ebp
 5c7:	89 e5                	mov    %esp,%ebp
 5c9:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5cc:	8b 45 08             	mov    0x8(%ebp),%eax
 5cf:	83 e8 08             	sub    $0x8,%eax
 5d2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d5:	a1 5c 0a 00 00       	mov    0xa5c,%eax
 5da:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5dd:	eb 24                	jmp    603 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e2:	8b 00                	mov    (%eax),%eax
 5e4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5e7:	77 12                	ja     5fb <free+0x35>
 5e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5ec:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5ef:	77 24                	ja     615 <free+0x4f>
 5f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f4:	8b 00                	mov    (%eax),%eax
 5f6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5f9:	77 1a                	ja     615 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5fe:	8b 00                	mov    (%eax),%eax
 600:	89 45 fc             	mov    %eax,-0x4(%ebp)
 603:	8b 45 f8             	mov    -0x8(%ebp),%eax
 606:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 609:	76 d4                	jbe    5df <free+0x19>
 60b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60e:	8b 00                	mov    (%eax),%eax
 610:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 613:	76 ca                	jbe    5df <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 615:	8b 45 f8             	mov    -0x8(%ebp),%eax
 618:	8b 40 04             	mov    0x4(%eax),%eax
 61b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 622:	8b 45 f8             	mov    -0x8(%ebp),%eax
 625:	01 c2                	add    %eax,%edx
 627:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62a:	8b 00                	mov    (%eax),%eax
 62c:	39 c2                	cmp    %eax,%edx
 62e:	75 24                	jne    654 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 630:	8b 45 f8             	mov    -0x8(%ebp),%eax
 633:	8b 50 04             	mov    0x4(%eax),%edx
 636:	8b 45 fc             	mov    -0x4(%ebp),%eax
 639:	8b 00                	mov    (%eax),%eax
 63b:	8b 40 04             	mov    0x4(%eax),%eax
 63e:	01 c2                	add    %eax,%edx
 640:	8b 45 f8             	mov    -0x8(%ebp),%eax
 643:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 646:	8b 45 fc             	mov    -0x4(%ebp),%eax
 649:	8b 00                	mov    (%eax),%eax
 64b:	8b 10                	mov    (%eax),%edx
 64d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 650:	89 10                	mov    %edx,(%eax)
 652:	eb 0a                	jmp    65e <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 654:	8b 45 fc             	mov    -0x4(%ebp),%eax
 657:	8b 10                	mov    (%eax),%edx
 659:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65c:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 65e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 661:	8b 40 04             	mov    0x4(%eax),%eax
 664:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 66b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66e:	01 d0                	add    %edx,%eax
 670:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 673:	75 20                	jne    695 <free+0xcf>
    p->s.size += bp->s.size;
 675:	8b 45 fc             	mov    -0x4(%ebp),%eax
 678:	8b 50 04             	mov    0x4(%eax),%edx
 67b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67e:	8b 40 04             	mov    0x4(%eax),%eax
 681:	01 c2                	add    %eax,%edx
 683:	8b 45 fc             	mov    -0x4(%ebp),%eax
 686:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 689:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68c:	8b 10                	mov    (%eax),%edx
 68e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 691:	89 10                	mov    %edx,(%eax)
 693:	eb 08                	jmp    69d <free+0xd7>
  } else
    p->s.ptr = bp;
 695:	8b 45 fc             	mov    -0x4(%ebp),%eax
 698:	8b 55 f8             	mov    -0x8(%ebp),%edx
 69b:	89 10                	mov    %edx,(%eax)
  freep = p;
 69d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a0:	a3 5c 0a 00 00       	mov    %eax,0xa5c
}
 6a5:	90                   	nop
 6a6:	c9                   	leave  
 6a7:	c3                   	ret    

000006a8 <morecore>:

static Header*
morecore(uint nu)
{
 6a8:	55                   	push   %ebp
 6a9:	89 e5                	mov    %esp,%ebp
 6ab:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6ae:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6b5:	77 07                	ja     6be <morecore+0x16>
    nu = 4096;
 6b7:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6be:	8b 45 08             	mov    0x8(%ebp),%eax
 6c1:	c1 e0 03             	shl    $0x3,%eax
 6c4:	83 ec 0c             	sub    $0xc,%esp
 6c7:	50                   	push   %eax
 6c8:	e8 59 fc ff ff       	call   326 <sbrk>
 6cd:	83 c4 10             	add    $0x10,%esp
 6d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6d3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6d7:	75 07                	jne    6e0 <morecore+0x38>
    return 0;
 6d9:	b8 00 00 00 00       	mov    $0x0,%eax
 6de:	eb 26                	jmp    706 <morecore+0x5e>
  hp = (Header*)p;
 6e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6e9:	8b 55 08             	mov    0x8(%ebp),%edx
 6ec:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f2:	83 c0 08             	add    $0x8,%eax
 6f5:	83 ec 0c             	sub    $0xc,%esp
 6f8:	50                   	push   %eax
 6f9:	e8 c8 fe ff ff       	call   5c6 <free>
 6fe:	83 c4 10             	add    $0x10,%esp
  return freep;
 701:	a1 5c 0a 00 00       	mov    0xa5c,%eax
}
 706:	c9                   	leave  
 707:	c3                   	ret    

00000708 <malloc>:

void*
malloc(uint nbytes)
{
 708:	55                   	push   %ebp
 709:	89 e5                	mov    %esp,%ebp
 70b:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 70e:	8b 45 08             	mov    0x8(%ebp),%eax
 711:	83 c0 07             	add    $0x7,%eax
 714:	c1 e8 03             	shr    $0x3,%eax
 717:	83 c0 01             	add    $0x1,%eax
 71a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 71d:	a1 5c 0a 00 00       	mov    0xa5c,%eax
 722:	89 45 f0             	mov    %eax,-0x10(%ebp)
 725:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 729:	75 23                	jne    74e <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 72b:	c7 45 f0 54 0a 00 00 	movl   $0xa54,-0x10(%ebp)
 732:	8b 45 f0             	mov    -0x10(%ebp),%eax
 735:	a3 5c 0a 00 00       	mov    %eax,0xa5c
 73a:	a1 5c 0a 00 00       	mov    0xa5c,%eax
 73f:	a3 54 0a 00 00       	mov    %eax,0xa54
    base.s.size = 0;
 744:	c7 05 58 0a 00 00 00 	movl   $0x0,0xa58
 74b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 74e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 751:	8b 00                	mov    (%eax),%eax
 753:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 756:	8b 45 f4             	mov    -0xc(%ebp),%eax
 759:	8b 40 04             	mov    0x4(%eax),%eax
 75c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 75f:	72 4d                	jb     7ae <malloc+0xa6>
      if(p->s.size == nunits)
 761:	8b 45 f4             	mov    -0xc(%ebp),%eax
 764:	8b 40 04             	mov    0x4(%eax),%eax
 767:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 76a:	75 0c                	jne    778 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 76c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76f:	8b 10                	mov    (%eax),%edx
 771:	8b 45 f0             	mov    -0x10(%ebp),%eax
 774:	89 10                	mov    %edx,(%eax)
 776:	eb 26                	jmp    79e <malloc+0x96>
      else {
        p->s.size -= nunits;
 778:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77b:	8b 40 04             	mov    0x4(%eax),%eax
 77e:	2b 45 ec             	sub    -0x14(%ebp),%eax
 781:	89 c2                	mov    %eax,%edx
 783:	8b 45 f4             	mov    -0xc(%ebp),%eax
 786:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 789:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78c:	8b 40 04             	mov    0x4(%eax),%eax
 78f:	c1 e0 03             	shl    $0x3,%eax
 792:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 795:	8b 45 f4             	mov    -0xc(%ebp),%eax
 798:	8b 55 ec             	mov    -0x14(%ebp),%edx
 79b:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 79e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a1:	a3 5c 0a 00 00       	mov    %eax,0xa5c
      return (void*)(p + 1);
 7a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a9:	83 c0 08             	add    $0x8,%eax
 7ac:	eb 3b                	jmp    7e9 <malloc+0xe1>
    }
    if(p == freep)
 7ae:	a1 5c 0a 00 00       	mov    0xa5c,%eax
 7b3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7b6:	75 1e                	jne    7d6 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7b8:	83 ec 0c             	sub    $0xc,%esp
 7bb:	ff 75 ec             	pushl  -0x14(%ebp)
 7be:	e8 e5 fe ff ff       	call   6a8 <morecore>
 7c3:	83 c4 10             	add    $0x10,%esp
 7c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7cd:	75 07                	jne    7d6 <malloc+0xce>
        return 0;
 7cf:	b8 00 00 00 00       	mov    $0x0,%eax
 7d4:	eb 13                	jmp    7e9 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7df:	8b 00                	mov    (%eax),%eax
 7e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7e4:	e9 6d ff ff ff       	jmp    756 <malloc+0x4e>
}
 7e9:	c9                   	leave  
 7ea:	c3                   	ret    
