
_try_mut:     формат файла elf32-i386


Дизассемблирование раздела .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"
int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 68             	sub    $0x68,%esp
  if (!fork()) {
  14:	e8 3b 03 00 00       	call   354 <fork>
  19:	85 c0                	test   %eax,%eax
  1b:	75 68                	jne    85 <main+0x85>
    char s1[] = "In son1, some big text, some big text, some big text, some big text, some big text\n!";
  1d:	8d 45 93             	lea    -0x6d(%ebp),%eax
  20:	bb b0 08 00 00       	mov    $0x8b0,%ebx
  25:	ba 55 00 00 00       	mov    $0x55,%edx
  2a:	8b 0b                	mov    (%ebx),%ecx
  2c:	89 08                	mov    %ecx,(%eax)
  2e:	8b 4c 13 fc          	mov    -0x4(%ebx,%edx,1),%ecx
  32:	89 4c 10 fc          	mov    %ecx,-0x4(%eax,%edx,1)
  36:	8d 78 04             	lea    0x4(%eax),%edi
  39:	83 e7 fc             	and    $0xfffffffc,%edi
  3c:	29 f8                	sub    %edi,%eax
  3e:	29 c3                	sub    %eax,%ebx
  40:	01 c2                	add    %eax,%edx
  42:	83 e2 fc             	and    $0xfffffffc,%edx
  45:	89 d0                	mov    %edx,%eax
  47:	c1 e8 02             	shr    $0x2,%eax
  4a:	89 de                	mov    %ebx,%esi
  4c:	89 c1                	mov    %eax,%ecx
  4e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    down(0);
  50:	83 ec 0c             	sub    $0xc,%esp
  53:	6a 00                	push   $0x0
  55:	e8 b2 03 00 00       	call   40c <down>
  5a:	83 c4 10             	add    $0x10,%esp
    printf(1, "%s\n", s1);
  5d:	83 ec 04             	sub    $0x4,%esp
  60:	8d 45 93             	lea    -0x6d(%ebp),%eax
  63:	50                   	push   %eax
  64:	68 ac 08 00 00       	push   $0x8ac
  69:	6a 01                	push   $0x1
  6b:	e8 83 04 00 00       	call   4f3 <printf>
  70:	83 c4 10             	add    $0x10,%esp
    up(0);
  73:	83 ec 0c             	sub    $0xc,%esp
  76:	6a 00                	push   $0x0
  78:	e8 87 03 00 00       	call   404 <up>
  7d:	83 c4 10             	add    $0x10,%esp
    exit();
  80:	e8 d7 02 00 00       	call   35c <exit>
  } else {
    if (!fork()) {
  85:	e8 ca 02 00 00       	call   354 <fork>
  8a:	85 c0                	test   %eax,%eax
  8c:	75 68                	jne    f6 <main+0xf6>
      char s2[] = "In son2, SOME BIG TEXT, SOME BIG TEXT, SOME BIG TEXT, SOME BIG TEXT, SOME BIG TEXT\n!";
  8e:	8d 45 93             	lea    -0x6d(%ebp),%eax
  91:	bb 08 09 00 00       	mov    $0x908,%ebx
  96:	ba 55 00 00 00       	mov    $0x55,%edx
  9b:	8b 0b                	mov    (%ebx),%ecx
  9d:	89 08                	mov    %ecx,(%eax)
  9f:	8b 4c 13 fc          	mov    -0x4(%ebx,%edx,1),%ecx
  a3:	89 4c 10 fc          	mov    %ecx,-0x4(%eax,%edx,1)
  a7:	8d 78 04             	lea    0x4(%eax),%edi
  aa:	83 e7 fc             	and    $0xfffffffc,%edi
  ad:	29 f8                	sub    %edi,%eax
  af:	29 c3                	sub    %eax,%ebx
  b1:	01 c2                	add    %eax,%edx
  b3:	83 e2 fc             	and    $0xfffffffc,%edx
  b6:	89 d0                	mov    %edx,%eax
  b8:	c1 e8 02             	shr    $0x2,%eax
  bb:	89 de                	mov    %ebx,%esi
  bd:	89 c1                	mov    %eax,%ecx
  bf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
      down(0);
  c1:	83 ec 0c             	sub    $0xc,%esp
  c4:	6a 00                	push   $0x0
  c6:	e8 41 03 00 00       	call   40c <down>
  cb:	83 c4 10             	add    $0x10,%esp
      printf(1, "%s\n", s2);
  ce:	83 ec 04             	sub    $0x4,%esp
  d1:	8d 45 93             	lea    -0x6d(%ebp),%eax
  d4:	50                   	push   %eax
  d5:	68 ac 08 00 00       	push   $0x8ac
  da:	6a 01                	push   $0x1
  dc:	e8 12 04 00 00       	call   4f3 <printf>
  e1:	83 c4 10             	add    $0x10,%esp
      up(0);
  e4:	83 ec 0c             	sub    $0xc,%esp
  e7:	6a 00                	push   $0x0
  e9:	e8 16 03 00 00       	call   404 <up>
  ee:	83 c4 10             	add    $0x10,%esp
      exit();
  f1:	e8 66 02 00 00       	call   35c <exit>
    }
    wait();
  f6:	e8 69 02 00 00       	call   364 <wait>
    wait();
  fb:	e8 64 02 00 00       	call   364 <wait>
  }
  exit();
 100:	e8 57 02 00 00       	call   35c <exit>

00000105 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 105:	55                   	push   %ebp
 106:	89 e5                	mov    %esp,%ebp
 108:	57                   	push   %edi
 109:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 10a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 10d:	8b 55 10             	mov    0x10(%ebp),%edx
 110:	8b 45 0c             	mov    0xc(%ebp),%eax
 113:	89 cb                	mov    %ecx,%ebx
 115:	89 df                	mov    %ebx,%edi
 117:	89 d1                	mov    %edx,%ecx
 119:	fc                   	cld    
 11a:	f3 aa                	rep stos %al,%es:(%edi)
 11c:	89 ca                	mov    %ecx,%edx
 11e:	89 fb                	mov    %edi,%ebx
 120:	89 5d 08             	mov    %ebx,0x8(%ebp)
 123:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 126:	90                   	nop
 127:	5b                   	pop    %ebx
 128:	5f                   	pop    %edi
 129:	5d                   	pop    %ebp
 12a:	c3                   	ret    

0000012b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 12b:	55                   	push   %ebp
 12c:	89 e5                	mov    %esp,%ebp
 12e:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 131:	8b 45 08             	mov    0x8(%ebp),%eax
 134:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 137:	90                   	nop
 138:	8b 45 08             	mov    0x8(%ebp),%eax
 13b:	8d 50 01             	lea    0x1(%eax),%edx
 13e:	89 55 08             	mov    %edx,0x8(%ebp)
 141:	8b 55 0c             	mov    0xc(%ebp),%edx
 144:	8d 4a 01             	lea    0x1(%edx),%ecx
 147:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 14a:	0f b6 12             	movzbl (%edx),%edx
 14d:	88 10                	mov    %dl,(%eax)
 14f:	0f b6 00             	movzbl (%eax),%eax
 152:	84 c0                	test   %al,%al
 154:	75 e2                	jne    138 <strcpy+0xd>
    ;
  return os;
 156:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 159:	c9                   	leave  
 15a:	c3                   	ret    

0000015b <strcmp>:

int
strcmp(const char *p, const char *q)
{
 15b:	55                   	push   %ebp
 15c:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 15e:	eb 08                	jmp    168 <strcmp+0xd>
    p++, q++;
 160:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 164:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 168:	8b 45 08             	mov    0x8(%ebp),%eax
 16b:	0f b6 00             	movzbl (%eax),%eax
 16e:	84 c0                	test   %al,%al
 170:	74 10                	je     182 <strcmp+0x27>
 172:	8b 45 08             	mov    0x8(%ebp),%eax
 175:	0f b6 10             	movzbl (%eax),%edx
 178:	8b 45 0c             	mov    0xc(%ebp),%eax
 17b:	0f b6 00             	movzbl (%eax),%eax
 17e:	38 c2                	cmp    %al,%dl
 180:	74 de                	je     160 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 182:	8b 45 08             	mov    0x8(%ebp),%eax
 185:	0f b6 00             	movzbl (%eax),%eax
 188:	0f b6 d0             	movzbl %al,%edx
 18b:	8b 45 0c             	mov    0xc(%ebp),%eax
 18e:	0f b6 00             	movzbl (%eax),%eax
 191:	0f b6 c0             	movzbl %al,%eax
 194:	29 c2                	sub    %eax,%edx
 196:	89 d0                	mov    %edx,%eax
}
 198:	5d                   	pop    %ebp
 199:	c3                   	ret    

0000019a <strlen>:

uint
strlen(char *s)
{
 19a:	55                   	push   %ebp
 19b:	89 e5                	mov    %esp,%ebp
 19d:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1a7:	eb 04                	jmp    1ad <strlen+0x13>
 1a9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1b0:	8b 45 08             	mov    0x8(%ebp),%eax
 1b3:	01 d0                	add    %edx,%eax
 1b5:	0f b6 00             	movzbl (%eax),%eax
 1b8:	84 c0                	test   %al,%al
 1ba:	75 ed                	jne    1a9 <strlen+0xf>
    ;
  return n;
 1bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1bf:	c9                   	leave  
 1c0:	c3                   	ret    

000001c1 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c1:	55                   	push   %ebp
 1c2:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1c4:	8b 45 10             	mov    0x10(%ebp),%eax
 1c7:	50                   	push   %eax
 1c8:	ff 75 0c             	pushl  0xc(%ebp)
 1cb:	ff 75 08             	pushl  0x8(%ebp)
 1ce:	e8 32 ff ff ff       	call   105 <stosb>
 1d3:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1d6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1d9:	c9                   	leave  
 1da:	c3                   	ret    

000001db <strchr>:

char*
strchr(const char *s, char c)
{
 1db:	55                   	push   %ebp
 1dc:	89 e5                	mov    %esp,%ebp
 1de:	83 ec 04             	sub    $0x4,%esp
 1e1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e4:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1e7:	eb 14                	jmp    1fd <strchr+0x22>
    if(*s == c)
 1e9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ec:	0f b6 00             	movzbl (%eax),%eax
 1ef:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1f2:	75 05                	jne    1f9 <strchr+0x1e>
      return (char*)s;
 1f4:	8b 45 08             	mov    0x8(%ebp),%eax
 1f7:	eb 13                	jmp    20c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1f9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1fd:	8b 45 08             	mov    0x8(%ebp),%eax
 200:	0f b6 00             	movzbl (%eax),%eax
 203:	84 c0                	test   %al,%al
 205:	75 e2                	jne    1e9 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 207:	b8 00 00 00 00       	mov    $0x0,%eax
}
 20c:	c9                   	leave  
 20d:	c3                   	ret    

0000020e <gets>:

char*
gets(char *buf, int max)
{
 20e:	55                   	push   %ebp
 20f:	89 e5                	mov    %esp,%ebp
 211:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 214:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 21b:	eb 42                	jmp    25f <gets+0x51>
    cc = read(0, &c, 1);
 21d:	83 ec 04             	sub    $0x4,%esp
 220:	6a 01                	push   $0x1
 222:	8d 45 ef             	lea    -0x11(%ebp),%eax
 225:	50                   	push   %eax
 226:	6a 00                	push   $0x0
 228:	e8 47 01 00 00       	call   374 <read>
 22d:	83 c4 10             	add    $0x10,%esp
 230:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 233:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 237:	7e 33                	jle    26c <gets+0x5e>
      break;
    buf[i++] = c;
 239:	8b 45 f4             	mov    -0xc(%ebp),%eax
 23c:	8d 50 01             	lea    0x1(%eax),%edx
 23f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 242:	89 c2                	mov    %eax,%edx
 244:	8b 45 08             	mov    0x8(%ebp),%eax
 247:	01 c2                	add    %eax,%edx
 249:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 24d:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 24f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 253:	3c 0a                	cmp    $0xa,%al
 255:	74 16                	je     26d <gets+0x5f>
 257:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 25b:	3c 0d                	cmp    $0xd,%al
 25d:	74 0e                	je     26d <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 25f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 262:	83 c0 01             	add    $0x1,%eax
 265:	3b 45 0c             	cmp    0xc(%ebp),%eax
 268:	7c b3                	jl     21d <gets+0xf>
 26a:	eb 01                	jmp    26d <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 26c:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 26d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 270:	8b 45 08             	mov    0x8(%ebp),%eax
 273:	01 d0                	add    %edx,%eax
 275:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 278:	8b 45 08             	mov    0x8(%ebp),%eax
}
 27b:	c9                   	leave  
 27c:	c3                   	ret    

0000027d <stat>:

int
stat(char *n, struct stat *st)
{
 27d:	55                   	push   %ebp
 27e:	89 e5                	mov    %esp,%ebp
 280:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY | O_NBLOCK);
 283:	83 ec 08             	sub    $0x8,%esp
 286:	6a 10                	push   $0x10
 288:	ff 75 08             	pushl  0x8(%ebp)
 28b:	e8 0c 01 00 00       	call   39c <open>
 290:	83 c4 10             	add    $0x10,%esp
 293:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 296:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 29a:	79 07                	jns    2a3 <stat+0x26>
    return -1;
 29c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2a1:	eb 25                	jmp    2c8 <stat+0x4b>
  r = fstat(fd, st);
 2a3:	83 ec 08             	sub    $0x8,%esp
 2a6:	ff 75 0c             	pushl  0xc(%ebp)
 2a9:	ff 75 f4             	pushl  -0xc(%ebp)
 2ac:	e8 03 01 00 00       	call   3b4 <fstat>
 2b1:	83 c4 10             	add    $0x10,%esp
 2b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2b7:	83 ec 0c             	sub    $0xc,%esp
 2ba:	ff 75 f4             	pushl  -0xc(%ebp)
 2bd:	e8 c2 00 00 00       	call   384 <close>
 2c2:	83 c4 10             	add    $0x10,%esp
  return r;
 2c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2c8:	c9                   	leave  
 2c9:	c3                   	ret    

000002ca <atoi>:

int
atoi(const char *s)
{
 2ca:	55                   	push   %ebp
 2cb:	89 e5                	mov    %esp,%ebp
 2cd:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2d7:	eb 25                	jmp    2fe <atoi+0x34>
    n = n*10 + *s++ - '0';
 2d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2dc:	89 d0                	mov    %edx,%eax
 2de:	c1 e0 02             	shl    $0x2,%eax
 2e1:	01 d0                	add    %edx,%eax
 2e3:	01 c0                	add    %eax,%eax
 2e5:	89 c1                	mov    %eax,%ecx
 2e7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ea:	8d 50 01             	lea    0x1(%eax),%edx
 2ed:	89 55 08             	mov    %edx,0x8(%ebp)
 2f0:	0f b6 00             	movzbl (%eax),%eax
 2f3:	0f be c0             	movsbl %al,%eax
 2f6:	01 c8                	add    %ecx,%eax
 2f8:	83 e8 30             	sub    $0x30,%eax
 2fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2fe:	8b 45 08             	mov    0x8(%ebp),%eax
 301:	0f b6 00             	movzbl (%eax),%eax
 304:	3c 2f                	cmp    $0x2f,%al
 306:	7e 0a                	jle    312 <atoi+0x48>
 308:	8b 45 08             	mov    0x8(%ebp),%eax
 30b:	0f b6 00             	movzbl (%eax),%eax
 30e:	3c 39                	cmp    $0x39,%al
 310:	7e c7                	jle    2d9 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 312:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 315:	c9                   	leave  
 316:	c3                   	ret    

00000317 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 317:	55                   	push   %ebp
 318:	89 e5                	mov    %esp,%ebp
 31a:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 31d:	8b 45 08             	mov    0x8(%ebp),%eax
 320:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 323:	8b 45 0c             	mov    0xc(%ebp),%eax
 326:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 329:	eb 17                	jmp    342 <memmove+0x2b>
    *dst++ = *src++;
 32b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 32e:	8d 50 01             	lea    0x1(%eax),%edx
 331:	89 55 fc             	mov    %edx,-0x4(%ebp)
 334:	8b 55 f8             	mov    -0x8(%ebp),%edx
 337:	8d 4a 01             	lea    0x1(%edx),%ecx
 33a:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 33d:	0f b6 12             	movzbl (%edx),%edx
 340:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 342:	8b 45 10             	mov    0x10(%ebp),%eax
 345:	8d 50 ff             	lea    -0x1(%eax),%edx
 348:	89 55 10             	mov    %edx,0x10(%ebp)
 34b:	85 c0                	test   %eax,%eax
 34d:	7f dc                	jg     32b <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 34f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 352:	c9                   	leave  
 353:	c3                   	ret    

00000354 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 354:	b8 01 00 00 00       	mov    $0x1,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <exit>:
SYSCALL(exit)
 35c:	b8 02 00 00 00       	mov    $0x2,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <wait>:
SYSCALL(wait)
 364:	b8 03 00 00 00       	mov    $0x3,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <pipe>:
SYSCALL(pipe)
 36c:	b8 04 00 00 00       	mov    $0x4,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <read>:
SYSCALL(read)
 374:	b8 05 00 00 00       	mov    $0x5,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <write>:
SYSCALL(write)
 37c:	b8 10 00 00 00       	mov    $0x10,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <close>:
SYSCALL(close)
 384:	b8 15 00 00 00       	mov    $0x15,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <kill>:
SYSCALL(kill)
 38c:	b8 06 00 00 00       	mov    $0x6,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <exec>:
SYSCALL(exec)
 394:	b8 07 00 00 00       	mov    $0x7,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <open>:
SYSCALL(open)
 39c:	b8 0f 00 00 00       	mov    $0xf,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <mknod>:
SYSCALL(mknod)
 3a4:	b8 11 00 00 00       	mov    $0x11,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <unlink>:
SYSCALL(unlink)
 3ac:	b8 12 00 00 00       	mov    $0x12,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <fstat>:
SYSCALL(fstat)
 3b4:	b8 08 00 00 00       	mov    $0x8,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <link>:
SYSCALL(link)
 3bc:	b8 13 00 00 00       	mov    $0x13,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <mkdir>:
SYSCALL(mkdir)
 3c4:	b8 14 00 00 00       	mov    $0x14,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <chdir>:
SYSCALL(chdir)
 3cc:	b8 09 00 00 00       	mov    $0x9,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <dup>:
SYSCALL(dup)
 3d4:	b8 0a 00 00 00       	mov    $0xa,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <getpid>:
SYSCALL(getpid)
 3dc:	b8 0b 00 00 00       	mov    $0xb,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <sbrk>:
SYSCALL(sbrk)
 3e4:	b8 0c 00 00 00       	mov    $0xc,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <sleep>:
SYSCALL(sleep)
 3ec:	b8 0d 00 00 00       	mov    $0xd,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <uptime>:
SYSCALL(uptime)
 3f4:	b8 0e 00 00 00       	mov    $0xe,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <mkfifo>:
SYSCALL(mkfifo)
 3fc:	b8 16 00 00 00       	mov    $0x16,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <up>:
SYSCALL(up)
 404:	b8 18 00 00 00       	mov    $0x18,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <down>:
SYSCALL(down)
 40c:	b8 17 00 00 00       	mov    $0x17,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <setuid>:
 414:	b8 19 00 00 00       	mov    $0x19,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 41c:	55                   	push   %ebp
 41d:	89 e5                	mov    %esp,%ebp
 41f:	83 ec 18             	sub    $0x18,%esp
 422:	8b 45 0c             	mov    0xc(%ebp),%eax
 425:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 428:	83 ec 04             	sub    $0x4,%esp
 42b:	6a 01                	push   $0x1
 42d:	8d 45 f4             	lea    -0xc(%ebp),%eax
 430:	50                   	push   %eax
 431:	ff 75 08             	pushl  0x8(%ebp)
 434:	e8 43 ff ff ff       	call   37c <write>
 439:	83 c4 10             	add    $0x10,%esp
}
 43c:	90                   	nop
 43d:	c9                   	leave  
 43e:	c3                   	ret    

0000043f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 43f:	55                   	push   %ebp
 440:	89 e5                	mov    %esp,%ebp
 442:	53                   	push   %ebx
 443:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 446:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 44d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 451:	74 17                	je     46a <printint+0x2b>
 453:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 457:	79 11                	jns    46a <printint+0x2b>
    neg = 1;
 459:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 460:	8b 45 0c             	mov    0xc(%ebp),%eax
 463:	f7 d8                	neg    %eax
 465:	89 45 ec             	mov    %eax,-0x14(%ebp)
 468:	eb 06                	jmp    470 <printint+0x31>
  } else {
    x = xx;
 46a:	8b 45 0c             	mov    0xc(%ebp),%eax
 46d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 470:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 477:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 47a:	8d 41 01             	lea    0x1(%ecx),%eax
 47d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 480:	8b 5d 10             	mov    0x10(%ebp),%ebx
 483:	8b 45 ec             	mov    -0x14(%ebp),%eax
 486:	ba 00 00 00 00       	mov    $0x0,%edx
 48b:	f7 f3                	div    %ebx
 48d:	89 d0                	mov    %edx,%eax
 48f:	0f b6 80 b8 0b 00 00 	movzbl 0xbb8(%eax),%eax
 496:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 49a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 49d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4a0:	ba 00 00 00 00       	mov    $0x0,%edx
 4a5:	f7 f3                	div    %ebx
 4a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4ae:	75 c7                	jne    477 <printint+0x38>
  if(neg)
 4b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4b4:	74 2d                	je     4e3 <printint+0xa4>
    buf[i++] = '-';
 4b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4b9:	8d 50 01             	lea    0x1(%eax),%edx
 4bc:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4bf:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4c4:	eb 1d                	jmp    4e3 <printint+0xa4>
    putc(fd, buf[i]);
 4c6:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4cc:	01 d0                	add    %edx,%eax
 4ce:	0f b6 00             	movzbl (%eax),%eax
 4d1:	0f be c0             	movsbl %al,%eax
 4d4:	83 ec 08             	sub    $0x8,%esp
 4d7:	50                   	push   %eax
 4d8:	ff 75 08             	pushl  0x8(%ebp)
 4db:	e8 3c ff ff ff       	call   41c <putc>
 4e0:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4e3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4eb:	79 d9                	jns    4c6 <printint+0x87>
    putc(fd, buf[i]);
}
 4ed:	90                   	nop
 4ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4f1:	c9                   	leave  
 4f2:	c3                   	ret    

000004f3 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4f3:	55                   	push   %ebp
 4f4:	89 e5                	mov    %esp,%ebp
 4f6:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4f9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 500:	8d 45 0c             	lea    0xc(%ebp),%eax
 503:	83 c0 04             	add    $0x4,%eax
 506:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 509:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 510:	e9 59 01 00 00       	jmp    66e <printf+0x17b>
    c = fmt[i] & 0xff;
 515:	8b 55 0c             	mov    0xc(%ebp),%edx
 518:	8b 45 f0             	mov    -0x10(%ebp),%eax
 51b:	01 d0                	add    %edx,%eax
 51d:	0f b6 00             	movzbl (%eax),%eax
 520:	0f be c0             	movsbl %al,%eax
 523:	25 ff 00 00 00       	and    $0xff,%eax
 528:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 52b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 52f:	75 2c                	jne    55d <printf+0x6a>
      if(c == '%'){
 531:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 535:	75 0c                	jne    543 <printf+0x50>
        state = '%';
 537:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 53e:	e9 27 01 00 00       	jmp    66a <printf+0x177>
      } else {
        putc(fd, c);
 543:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 546:	0f be c0             	movsbl %al,%eax
 549:	83 ec 08             	sub    $0x8,%esp
 54c:	50                   	push   %eax
 54d:	ff 75 08             	pushl  0x8(%ebp)
 550:	e8 c7 fe ff ff       	call   41c <putc>
 555:	83 c4 10             	add    $0x10,%esp
 558:	e9 0d 01 00 00       	jmp    66a <printf+0x177>
      }
    } else if(state == '%'){
 55d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 561:	0f 85 03 01 00 00    	jne    66a <printf+0x177>
      if(c == 'd'){
 567:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 56b:	75 1e                	jne    58b <printf+0x98>
        printint(fd, *ap, 10, 1);
 56d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 570:	8b 00                	mov    (%eax),%eax
 572:	6a 01                	push   $0x1
 574:	6a 0a                	push   $0xa
 576:	50                   	push   %eax
 577:	ff 75 08             	pushl  0x8(%ebp)
 57a:	e8 c0 fe ff ff       	call   43f <printint>
 57f:	83 c4 10             	add    $0x10,%esp
        ap++;
 582:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 586:	e9 d8 00 00 00       	jmp    663 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 58b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 58f:	74 06                	je     597 <printf+0xa4>
 591:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 595:	75 1e                	jne    5b5 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 597:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59a:	8b 00                	mov    (%eax),%eax
 59c:	6a 00                	push   $0x0
 59e:	6a 10                	push   $0x10
 5a0:	50                   	push   %eax
 5a1:	ff 75 08             	pushl  0x8(%ebp)
 5a4:	e8 96 fe ff ff       	call   43f <printint>
 5a9:	83 c4 10             	add    $0x10,%esp
        ap++;
 5ac:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b0:	e9 ae 00 00 00       	jmp    663 <printf+0x170>
      } else if(c == 's'){
 5b5:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5b9:	75 43                	jne    5fe <printf+0x10b>
        s = (char*)*ap;
 5bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5be:	8b 00                	mov    (%eax),%eax
 5c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5c3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5cb:	75 25                	jne    5f2 <printf+0xff>
          s = "(null)";
 5cd:	c7 45 f4 5d 09 00 00 	movl   $0x95d,-0xc(%ebp)
        while(*s != 0){
 5d4:	eb 1c                	jmp    5f2 <printf+0xff>
          putc(fd, *s);
 5d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d9:	0f b6 00             	movzbl (%eax),%eax
 5dc:	0f be c0             	movsbl %al,%eax
 5df:	83 ec 08             	sub    $0x8,%esp
 5e2:	50                   	push   %eax
 5e3:	ff 75 08             	pushl  0x8(%ebp)
 5e6:	e8 31 fe ff ff       	call   41c <putc>
 5eb:	83 c4 10             	add    $0x10,%esp
          s++;
 5ee:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f5:	0f b6 00             	movzbl (%eax),%eax
 5f8:	84 c0                	test   %al,%al
 5fa:	75 da                	jne    5d6 <printf+0xe3>
 5fc:	eb 65                	jmp    663 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5fe:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 602:	75 1d                	jne    621 <printf+0x12e>
        putc(fd, *ap);
 604:	8b 45 e8             	mov    -0x18(%ebp),%eax
 607:	8b 00                	mov    (%eax),%eax
 609:	0f be c0             	movsbl %al,%eax
 60c:	83 ec 08             	sub    $0x8,%esp
 60f:	50                   	push   %eax
 610:	ff 75 08             	pushl  0x8(%ebp)
 613:	e8 04 fe ff ff       	call   41c <putc>
 618:	83 c4 10             	add    $0x10,%esp
        ap++;
 61b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 61f:	eb 42                	jmp    663 <printf+0x170>
      } else if(c == '%'){
 621:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 625:	75 17                	jne    63e <printf+0x14b>
        putc(fd, c);
 627:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 62a:	0f be c0             	movsbl %al,%eax
 62d:	83 ec 08             	sub    $0x8,%esp
 630:	50                   	push   %eax
 631:	ff 75 08             	pushl  0x8(%ebp)
 634:	e8 e3 fd ff ff       	call   41c <putc>
 639:	83 c4 10             	add    $0x10,%esp
 63c:	eb 25                	jmp    663 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 63e:	83 ec 08             	sub    $0x8,%esp
 641:	6a 25                	push   $0x25
 643:	ff 75 08             	pushl  0x8(%ebp)
 646:	e8 d1 fd ff ff       	call   41c <putc>
 64b:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 64e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 651:	0f be c0             	movsbl %al,%eax
 654:	83 ec 08             	sub    $0x8,%esp
 657:	50                   	push   %eax
 658:	ff 75 08             	pushl  0x8(%ebp)
 65b:	e8 bc fd ff ff       	call   41c <putc>
 660:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 663:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 66a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 66e:	8b 55 0c             	mov    0xc(%ebp),%edx
 671:	8b 45 f0             	mov    -0x10(%ebp),%eax
 674:	01 d0                	add    %edx,%eax
 676:	0f b6 00             	movzbl (%eax),%eax
 679:	84 c0                	test   %al,%al
 67b:	0f 85 94 fe ff ff    	jne    515 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 681:	90                   	nop
 682:	c9                   	leave  
 683:	c3                   	ret    

00000684 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 684:	55                   	push   %ebp
 685:	89 e5                	mov    %esp,%ebp
 687:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 68a:	8b 45 08             	mov    0x8(%ebp),%eax
 68d:	83 e8 08             	sub    $0x8,%eax
 690:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 693:	a1 d4 0b 00 00       	mov    0xbd4,%eax
 698:	89 45 fc             	mov    %eax,-0x4(%ebp)
 69b:	eb 24                	jmp    6c1 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 69d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a0:	8b 00                	mov    (%eax),%eax
 6a2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6a5:	77 12                	ja     6b9 <free+0x35>
 6a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6aa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ad:	77 24                	ja     6d3 <free+0x4f>
 6af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b2:	8b 00                	mov    (%eax),%eax
 6b4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b7:	77 1a                	ja     6d3 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bc:	8b 00                	mov    (%eax),%eax
 6be:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6c7:	76 d4                	jbe    69d <free+0x19>
 6c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cc:	8b 00                	mov    (%eax),%eax
 6ce:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6d1:	76 ca                	jbe    69d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d6:	8b 40 04             	mov    0x4(%eax),%eax
 6d9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e3:	01 c2                	add    %eax,%edx
 6e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e8:	8b 00                	mov    (%eax),%eax
 6ea:	39 c2                	cmp    %eax,%edx
 6ec:	75 24                	jne    712 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f1:	8b 50 04             	mov    0x4(%eax),%edx
 6f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f7:	8b 00                	mov    (%eax),%eax
 6f9:	8b 40 04             	mov    0x4(%eax),%eax
 6fc:	01 c2                	add    %eax,%edx
 6fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
 701:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 704:	8b 45 fc             	mov    -0x4(%ebp),%eax
 707:	8b 00                	mov    (%eax),%eax
 709:	8b 10                	mov    (%eax),%edx
 70b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70e:	89 10                	mov    %edx,(%eax)
 710:	eb 0a                	jmp    71c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 712:	8b 45 fc             	mov    -0x4(%ebp),%eax
 715:	8b 10                	mov    (%eax),%edx
 717:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 71c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71f:	8b 40 04             	mov    0x4(%eax),%eax
 722:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 729:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72c:	01 d0                	add    %edx,%eax
 72e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 731:	75 20                	jne    753 <free+0xcf>
    p->s.size += bp->s.size;
 733:	8b 45 fc             	mov    -0x4(%ebp),%eax
 736:	8b 50 04             	mov    0x4(%eax),%edx
 739:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73c:	8b 40 04             	mov    0x4(%eax),%eax
 73f:	01 c2                	add    %eax,%edx
 741:	8b 45 fc             	mov    -0x4(%ebp),%eax
 744:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 747:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74a:	8b 10                	mov    (%eax),%edx
 74c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74f:	89 10                	mov    %edx,(%eax)
 751:	eb 08                	jmp    75b <free+0xd7>
  } else
    p->s.ptr = bp;
 753:	8b 45 fc             	mov    -0x4(%ebp),%eax
 756:	8b 55 f8             	mov    -0x8(%ebp),%edx
 759:	89 10                	mov    %edx,(%eax)
  freep = p;
 75b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75e:	a3 d4 0b 00 00       	mov    %eax,0xbd4
}
 763:	90                   	nop
 764:	c9                   	leave  
 765:	c3                   	ret    

00000766 <morecore>:

static Header*
morecore(uint nu)
{
 766:	55                   	push   %ebp
 767:	89 e5                	mov    %esp,%ebp
 769:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 76c:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 773:	77 07                	ja     77c <morecore+0x16>
    nu = 4096;
 775:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 77c:	8b 45 08             	mov    0x8(%ebp),%eax
 77f:	c1 e0 03             	shl    $0x3,%eax
 782:	83 ec 0c             	sub    $0xc,%esp
 785:	50                   	push   %eax
 786:	e8 59 fc ff ff       	call   3e4 <sbrk>
 78b:	83 c4 10             	add    $0x10,%esp
 78e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 791:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 795:	75 07                	jne    79e <morecore+0x38>
    return 0;
 797:	b8 00 00 00 00       	mov    $0x0,%eax
 79c:	eb 26                	jmp    7c4 <morecore+0x5e>
  hp = (Header*)p;
 79e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a7:	8b 55 08             	mov    0x8(%ebp),%edx
 7aa:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b0:	83 c0 08             	add    $0x8,%eax
 7b3:	83 ec 0c             	sub    $0xc,%esp
 7b6:	50                   	push   %eax
 7b7:	e8 c8 fe ff ff       	call   684 <free>
 7bc:	83 c4 10             	add    $0x10,%esp
  return freep;
 7bf:	a1 d4 0b 00 00       	mov    0xbd4,%eax
}
 7c4:	c9                   	leave  
 7c5:	c3                   	ret    

000007c6 <malloc>:

void*
malloc(uint nbytes)
{
 7c6:	55                   	push   %ebp
 7c7:	89 e5                	mov    %esp,%ebp
 7c9:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7cc:	8b 45 08             	mov    0x8(%ebp),%eax
 7cf:	83 c0 07             	add    $0x7,%eax
 7d2:	c1 e8 03             	shr    $0x3,%eax
 7d5:	83 c0 01             	add    $0x1,%eax
 7d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7db:	a1 d4 0b 00 00       	mov    0xbd4,%eax
 7e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7e7:	75 23                	jne    80c <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7e9:	c7 45 f0 cc 0b 00 00 	movl   $0xbcc,-0x10(%ebp)
 7f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f3:	a3 d4 0b 00 00       	mov    %eax,0xbd4
 7f8:	a1 d4 0b 00 00       	mov    0xbd4,%eax
 7fd:	a3 cc 0b 00 00       	mov    %eax,0xbcc
    base.s.size = 0;
 802:	c7 05 d0 0b 00 00 00 	movl   $0x0,0xbd0
 809:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80f:	8b 00                	mov    (%eax),%eax
 811:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 814:	8b 45 f4             	mov    -0xc(%ebp),%eax
 817:	8b 40 04             	mov    0x4(%eax),%eax
 81a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 81d:	72 4d                	jb     86c <malloc+0xa6>
      if(p->s.size == nunits)
 81f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 822:	8b 40 04             	mov    0x4(%eax),%eax
 825:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 828:	75 0c                	jne    836 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 82a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82d:	8b 10                	mov    (%eax),%edx
 82f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 832:	89 10                	mov    %edx,(%eax)
 834:	eb 26                	jmp    85c <malloc+0x96>
      else {
        p->s.size -= nunits;
 836:	8b 45 f4             	mov    -0xc(%ebp),%eax
 839:	8b 40 04             	mov    0x4(%eax),%eax
 83c:	2b 45 ec             	sub    -0x14(%ebp),%eax
 83f:	89 c2                	mov    %eax,%edx
 841:	8b 45 f4             	mov    -0xc(%ebp),%eax
 844:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 847:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84a:	8b 40 04             	mov    0x4(%eax),%eax
 84d:	c1 e0 03             	shl    $0x3,%eax
 850:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 853:	8b 45 f4             	mov    -0xc(%ebp),%eax
 856:	8b 55 ec             	mov    -0x14(%ebp),%edx
 859:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 85c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85f:	a3 d4 0b 00 00       	mov    %eax,0xbd4
      return (void*)(p + 1);
 864:	8b 45 f4             	mov    -0xc(%ebp),%eax
 867:	83 c0 08             	add    $0x8,%eax
 86a:	eb 3b                	jmp    8a7 <malloc+0xe1>
    }
    if(p == freep)
 86c:	a1 d4 0b 00 00       	mov    0xbd4,%eax
 871:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 874:	75 1e                	jne    894 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 876:	83 ec 0c             	sub    $0xc,%esp
 879:	ff 75 ec             	pushl  -0x14(%ebp)
 87c:	e8 e5 fe ff ff       	call   766 <morecore>
 881:	83 c4 10             	add    $0x10,%esp
 884:	89 45 f4             	mov    %eax,-0xc(%ebp)
 887:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 88b:	75 07                	jne    894 <malloc+0xce>
        return 0;
 88d:	b8 00 00 00 00       	mov    $0x0,%eax
 892:	eb 13                	jmp    8a7 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 894:	8b 45 f4             	mov    -0xc(%ebp),%eax
 897:	89 45 f0             	mov    %eax,-0x10(%ebp)
 89a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89d:	8b 00                	mov    (%eax),%eax
 89f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8a2:	e9 6d ff ff ff       	jmp    814 <malloc+0x4e>
}
 8a7:	c9                   	leave  
 8a8:	c3                   	ret    
