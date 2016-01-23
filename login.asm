
_login:     формат файла elf32-i386


Дизассемблирование раздела .text:

00000000 <main>:
#include "user.h"
#include "fcntl.h"

int
main()
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 54             	sub    $0x54,%esp
    int LEN = 10;
  11:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
    char string[LEN * 2 + 3];
  18:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1b:	01 c0                	add    %eax,%eax
  1d:	83 c0 03             	add    $0x3,%eax
  20:	8d 50 ff             	lea    -0x1(%eax),%edx
  23:	89 55 d8             	mov    %edx,-0x28(%ebp)
  26:	89 c2                	mov    %eax,%edx
  28:	b8 10 00 00 00       	mov    $0x10,%eax
  2d:	83 e8 01             	sub    $0x1,%eax
  30:	01 d0                	add    %edx,%eax
  32:	b9 10 00 00 00       	mov    $0x10,%ecx
  37:	ba 00 00 00 00       	mov    $0x0,%edx
  3c:	f7 f1                	div    %ecx
  3e:	6b c0 10             	imul   $0x10,%eax,%eax
  41:	29 c4                	sub    %eax,%esp
  43:	89 e0                	mov    %esp,%eax
  45:	83 c0 00             	add    $0x0,%eax
  48:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    char login[LEN];
  4b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  4e:	8d 50 ff             	lea    -0x1(%eax),%edx
  51:	89 55 d0             	mov    %edx,-0x30(%ebp)
  54:	89 c2                	mov    %eax,%edx
  56:	b8 10 00 00 00       	mov    $0x10,%eax
  5b:	83 e8 01             	sub    $0x1,%eax
  5e:	01 d0                	add    %edx,%eax
  60:	b9 10 00 00 00       	mov    $0x10,%ecx
  65:	ba 00 00 00 00       	mov    $0x0,%edx
  6a:	f7 f1                	div    %ecx
  6c:	6b c0 10             	imul   $0x10,%eax,%eax
  6f:	29 c4                	sub    %eax,%esp
  71:	89 e0                	mov    %esp,%eax
  73:	83 c0 00             	add    $0x0,%eax
  76:	89 45 cc             	mov    %eax,-0x34(%ebp)
    char password[LEN];
  79:	8b 45 dc             	mov    -0x24(%ebp),%eax
  7c:	8d 50 ff             	lea    -0x1(%eax),%edx
  7f:	89 55 c8             	mov    %edx,-0x38(%ebp)
  82:	89 c2                	mov    %eax,%edx
  84:	b8 10 00 00 00       	mov    $0x10,%eax
  89:	83 e8 01             	sub    $0x1,%eax
  8c:	01 d0                	add    %edx,%eax
  8e:	b9 10 00 00 00       	mov    $0x10,%ecx
  93:	ba 00 00 00 00       	mov    $0x0,%edx
  98:	f7 f1                	div    %ecx
  9a:	6b c0 10             	imul   $0x10,%eax,%eax
  9d:	29 c4                	sub    %eax,%esp
  9f:	89 e0                	mov    %esp,%eax
  a1:	83 c0 00             	add    $0x0,%eax
  a4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    char * passwd_passwd;
    char buf[1];
    int j;
    int flag;
    int fd = open("/pass", O_RDONLY);
  a7:	83 ec 08             	sub    $0x8,%esp
  aa:	6a 00                	push   $0x0
  ac:	68 95 0a 00 00       	push   $0xa95
  b1:	e8 d2 04 00 00       	call   588 <open>
  b6:	83 c4 10             	add    $0x10,%esp
  b9:	89 45 c0             	mov    %eax,-0x40(%ebp)

    char * p = string;
  bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  bf:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; read(fd, buf, 1) == 1 && buf[0] != '\n'; ++j) {
  c2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  c9:	eb 13                	jmp    de <main+0xde>
      *p++ = buf[0];
  cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  ce:	8d 50 01             	lea    0x1(%eax),%edx
  d1:	89 55 e8             	mov    %edx,-0x18(%ebp)
  d4:	0f b6 55 bb          	movzbl -0x45(%ebp),%edx
  d8:	88 10                	mov    %dl,(%eax)
    int j;
    int flag;
    int fd = open("/pass", O_RDONLY);

    char * p = string;
    for(j = 0; read(fd, buf, 1) == 1 && buf[0] != '\n'; ++j) {
  da:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  de:	83 ec 04             	sub    $0x4,%esp
  e1:	6a 01                	push   $0x1
  e3:	8d 45 bb             	lea    -0x45(%ebp),%eax
  e6:	50                   	push   %eax
  e7:	ff 75 c0             	pushl  -0x40(%ebp)
  ea:	e8 71 04 00 00       	call   560 <read>
  ef:	83 c4 10             	add    $0x10,%esp
  f2:	83 f8 01             	cmp    $0x1,%eax
  f5:	75 08                	jne    ff <main+0xff>
  f7:	0f b6 45 bb          	movzbl -0x45(%ebp),%eax
  fb:	3c 0a                	cmp    $0xa,%al
  fd:	75 cc                	jne    cb <main+0xcb>
      *p++ = buf[0];
    }
    *p = '\0';
  ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
 102:	c6 00 00             	movb   $0x0,(%eax)

    // parse string
    char * passwd_login = string;
 105:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 108:	89 45 bc             	mov    %eax,-0x44(%ebp)
    flag = 0;
 10b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (j = 0; string[j]; ++j) {
 112:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 119:	eb 57                	jmp    172 <main+0x172>
        if (string[j] == ':' && !flag) {
 11b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 11e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 121:	01 d0                	add    %edx,%eax
 123:	0f b6 00             	movzbl (%eax),%eax
 126:	3c 3a                	cmp    $0x3a,%al
 128:	75 28                	jne    152 <main+0x152>
 12a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 12e:	75 22                	jne    152 <main+0x152>
            string[j] = '\0';
 130:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 133:	8b 45 f0             	mov    -0x10(%ebp),%eax
 136:	01 d0                	add    %edx,%eax
 138:	c6 00 00             	movb   $0x0,(%eax)
            passwd_passwd = &string[j + 1];
 13b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 13e:	8d 50 01             	lea    0x1(%eax),%edx
 141:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 144:	01 d0                	add    %edx,%eax
 146:	89 45 f4             	mov    %eax,-0xc(%ebp)
            flag = 1;
 149:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
 150:	eb 1c                	jmp    16e <main+0x16e>
        } else if (string[j] == ':') {
 152:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 155:	8b 45 f0             	mov    -0x10(%ebp),%eax
 158:	01 d0                	add    %edx,%eax
 15a:	0f b6 00             	movzbl (%eax),%eax
 15d:	3c 3a                	cmp    $0x3a,%al
 15f:	75 0d                	jne    16e <main+0x16e>
            string[j] = '\0';
 161:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 164:	8b 45 f0             	mov    -0x10(%ebp),%eax
 167:	01 d0                	add    %edx,%eax
 169:	c6 00 00             	movb   $0x0,(%eax)
            break;
 16c:	eb 13                	jmp    181 <main+0x181>
    *p = '\0';

    // parse string
    char * passwd_login = string;
    flag = 0;
    for (j = 0; string[j]; ++j) {
 16e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 172:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 175:	8b 45 f0             	mov    -0x10(%ebp),%eax
 178:	01 d0                	add    %edx,%eax
 17a:	0f b6 00             	movzbl (%eax),%eax
 17d:	84 c0                	test   %al,%al
 17f:	75 9a                	jne    11b <main+0x11b>
            break;
        }
    }

    //read username
    printf(1, "username: ");
 181:	83 ec 08             	sub    $0x8,%esp
 184:	68 9b 0a 00 00       	push   $0xa9b
 189:	6a 01                	push   $0x1
 18b:	e8 4f 05 00 00       	call   6df <printf>
 190:	83 c4 10             	add    $0x10,%esp
    char * p_login = login;
 193:	8b 45 cc             	mov    -0x34(%ebp),%eax
 196:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; read(0, buf, 1) == 1 && buf[0] != '\n'; ++j){
 199:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 1a0:	eb 13                	jmp    1b5 <main+0x1b5>
      *p_login++ = buf[0];
 1a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1a5:	8d 50 01             	lea    0x1(%eax),%edx
 1a8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 1ab:	0f b6 55 bb          	movzbl -0x45(%ebp),%edx
 1af:	88 10                	mov    %dl,(%eax)
    }

    //read username
    printf(1, "username: ");
    char * p_login = login;
    for(j = 0; read(0, buf, 1) == 1 && buf[0] != '\n'; ++j){
 1b1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 1b5:	83 ec 04             	sub    $0x4,%esp
 1b8:	6a 01                	push   $0x1
 1ba:	8d 45 bb             	lea    -0x45(%ebp),%eax
 1bd:	50                   	push   %eax
 1be:	6a 00                	push   $0x0
 1c0:	e8 9b 03 00 00       	call   560 <read>
 1c5:	83 c4 10             	add    $0x10,%esp
 1c8:	83 f8 01             	cmp    $0x1,%eax
 1cb:	75 08                	jne    1d5 <main+0x1d5>
 1cd:	0f b6 45 bb          	movzbl -0x45(%ebp),%eax
 1d1:	3c 0a                	cmp    $0xa,%al
 1d3:	75 cd                	jne    1a2 <main+0x1a2>
      *p_login++ = buf[0];
    }
    *p_login = '\0';
 1d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1d8:	c6 00 00             	movb   $0x0,(%eax)

    if (strcmp(passwd_login, login) != 0) {
 1db:	8b 45 cc             	mov    -0x34(%ebp),%eax
 1de:	83 ec 08             	sub    $0x8,%esp
 1e1:	50                   	push   %eax
 1e2:	ff 75 bc             	pushl  -0x44(%ebp)
 1e5:	e8 5d 01 00 00       	call   347 <strcmp>
 1ea:	83 c4 10             	add    $0x10,%esp
 1ed:	85 c0                	test   %eax,%eax
 1ef:	74 30                	je     221 <main+0x221>
        printf(2, "failed to login as %s\n", login);
 1f1:	8b 45 cc             	mov    -0x34(%ebp),%eax
 1f4:	83 ec 04             	sub    $0x4,%esp
 1f7:	50                   	push   %eax
 1f8:	68 a6 0a 00 00       	push   $0xaa6
 1fd:	6a 02                	push   $0x2
 1ff:	e8 db 04 00 00       	call   6df <printf>
 204:	83 c4 10             	add    $0x10,%esp
        printf(2, "real username is %s\n", passwd_login);
 207:	83 ec 04             	sub    $0x4,%esp
 20a:	ff 75 bc             	pushl  -0x44(%ebp)
 20d:	68 bd 0a 00 00       	push   $0xabd
 212:	6a 02                	push   $0x2
 214:	e8 c6 04 00 00       	call   6df <printf>
 219:	83 c4 10             	add    $0x10,%esp
        exit();
 21c:	e8 27 03 00 00       	call   548 <exit>
    }

    // read pass from consol
    printf(1, "password: ");
 221:	83 ec 08             	sub    $0x8,%esp
 224:	68 d2 0a 00 00       	push   $0xad2
 229:	6a 01                	push   $0x1
 22b:	e8 af 04 00 00       	call   6df <printf>
 230:	83 c4 10             	add    $0x10,%esp
    char * p_psswd = password;
 233:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 236:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(j = 0; read(0, buf, 1) == 1 && buf[0] != '\n'; ++j){
 239:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 240:	eb 13                	jmp    255 <main+0x255>
      *p_psswd++ = buf[0];
 242:	8b 45 e0             	mov    -0x20(%ebp),%eax
 245:	8d 50 01             	lea    0x1(%eax),%edx
 248:	89 55 e0             	mov    %edx,-0x20(%ebp)
 24b:	0f b6 55 bb          	movzbl -0x45(%ebp),%edx
 24f:	88 10                	mov    %dl,(%eax)
    }

    // read pass from consol
    printf(1, "password: ");
    char * p_psswd = password;
    for(j = 0; read(0, buf, 1) == 1 && buf[0] != '\n'; ++j){
 251:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 255:	83 ec 04             	sub    $0x4,%esp
 258:	6a 01                	push   $0x1
 25a:	8d 45 bb             	lea    -0x45(%ebp),%eax
 25d:	50                   	push   %eax
 25e:	6a 00                	push   $0x0
 260:	e8 fb 02 00 00       	call   560 <read>
 265:	83 c4 10             	add    $0x10,%esp
 268:	83 f8 01             	cmp    $0x1,%eax
 26b:	75 08                	jne    275 <main+0x275>
 26d:	0f b6 45 bb          	movzbl -0x45(%ebp),%eax
 271:	3c 0a                	cmp    $0xa,%al
 273:	75 cd                	jne    242 <main+0x242>
      *p_psswd++ = buf[0];
    }
    *p_psswd = '\0';
 275:	8b 45 e0             	mov    -0x20(%ebp),%eax
 278:	c6 00 00             	movb   $0x0,(%eax)

    if (strcmp(password, passwd_passwd) != 0) {
 27b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 27e:	83 ec 08             	sub    $0x8,%esp
 281:	ff 75 f4             	pushl  -0xc(%ebp)
 284:	50                   	push   %eax
 285:	e8 bd 00 00 00       	call   347 <strcmp>
 28a:	83 c4 10             	add    $0x10,%esp
 28d:	85 c0                	test   %eax,%eax
 28f:	74 2c                	je     2bd <main+0x2bd>
        printf(2, "wrong password\n");
 291:	83 ec 08             	sub    $0x8,%esp
 294:	68 dd 0a 00 00       	push   $0xadd
 299:	6a 02                	push   $0x2
 29b:	e8 3f 04 00 00       	call   6df <printf>
 2a0:	83 c4 10             	add    $0x10,%esp
        printf(2, "real passwd is %s\n", passwd_passwd);
 2a3:	83 ec 04             	sub    $0x4,%esp
 2a6:	ff 75 f4             	pushl  -0xc(%ebp)
 2a9:	68 ed 0a 00 00       	push   $0xaed
 2ae:	6a 02                	push   $0x2
 2b0:	e8 2a 04 00 00       	call   6df <printf>
 2b5:	83 c4 10             	add    $0x10,%esp
        exit();
 2b8:	e8 8b 02 00 00       	call   548 <exit>
    }
    char *argv[] = { "sh", 0 };
 2bd:	c7 45 b0 00 0b 00 00 	movl   $0xb00,-0x50(%ebp)
 2c4:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
    setuid(0);
 2cb:	83 ec 0c             	sub    $0xc,%esp
 2ce:	6a 00                	push   $0x0
 2d0:	e8 2b 03 00 00       	call   600 <setuid>
 2d5:	83 c4 10             	add    $0x10,%esp
    exec("sh", argv);
 2d8:	83 ec 08             	sub    $0x8,%esp
 2db:	8d 45 b0             	lea    -0x50(%ebp),%eax
 2de:	50                   	push   %eax
 2df:	68 00 0b 00 00       	push   $0xb00
 2e4:	e8 97 02 00 00       	call   580 <exec>
 2e9:	83 c4 10             	add    $0x10,%esp
    exit();
 2ec:	e8 57 02 00 00       	call   548 <exit>

000002f1 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 2f1:	55                   	push   %ebp
 2f2:	89 e5                	mov    %esp,%ebp
 2f4:	57                   	push   %edi
 2f5:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 2f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2f9:	8b 55 10             	mov    0x10(%ebp),%edx
 2fc:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ff:	89 cb                	mov    %ecx,%ebx
 301:	89 df                	mov    %ebx,%edi
 303:	89 d1                	mov    %edx,%ecx
 305:	fc                   	cld    
 306:	f3 aa                	rep stos %al,%es:(%edi)
 308:	89 ca                	mov    %ecx,%edx
 30a:	89 fb                	mov    %edi,%ebx
 30c:	89 5d 08             	mov    %ebx,0x8(%ebp)
 30f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 312:	90                   	nop
 313:	5b                   	pop    %ebx
 314:	5f                   	pop    %edi
 315:	5d                   	pop    %ebp
 316:	c3                   	ret    

00000317 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 317:	55                   	push   %ebp
 318:	89 e5                	mov    %esp,%ebp
 31a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 31d:	8b 45 08             	mov    0x8(%ebp),%eax
 320:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 323:	90                   	nop
 324:	8b 45 08             	mov    0x8(%ebp),%eax
 327:	8d 50 01             	lea    0x1(%eax),%edx
 32a:	89 55 08             	mov    %edx,0x8(%ebp)
 32d:	8b 55 0c             	mov    0xc(%ebp),%edx
 330:	8d 4a 01             	lea    0x1(%edx),%ecx
 333:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 336:	0f b6 12             	movzbl (%edx),%edx
 339:	88 10                	mov    %dl,(%eax)
 33b:	0f b6 00             	movzbl (%eax),%eax
 33e:	84 c0                	test   %al,%al
 340:	75 e2                	jne    324 <strcpy+0xd>
    ;
  return os;
 342:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 345:	c9                   	leave  
 346:	c3                   	ret    

00000347 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 347:	55                   	push   %ebp
 348:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 34a:	eb 08                	jmp    354 <strcmp+0xd>
    p++, q++;
 34c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 350:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 354:	8b 45 08             	mov    0x8(%ebp),%eax
 357:	0f b6 00             	movzbl (%eax),%eax
 35a:	84 c0                	test   %al,%al
 35c:	74 10                	je     36e <strcmp+0x27>
 35e:	8b 45 08             	mov    0x8(%ebp),%eax
 361:	0f b6 10             	movzbl (%eax),%edx
 364:	8b 45 0c             	mov    0xc(%ebp),%eax
 367:	0f b6 00             	movzbl (%eax),%eax
 36a:	38 c2                	cmp    %al,%dl
 36c:	74 de                	je     34c <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 36e:	8b 45 08             	mov    0x8(%ebp),%eax
 371:	0f b6 00             	movzbl (%eax),%eax
 374:	0f b6 d0             	movzbl %al,%edx
 377:	8b 45 0c             	mov    0xc(%ebp),%eax
 37a:	0f b6 00             	movzbl (%eax),%eax
 37d:	0f b6 c0             	movzbl %al,%eax
 380:	29 c2                	sub    %eax,%edx
 382:	89 d0                	mov    %edx,%eax
}
 384:	5d                   	pop    %ebp
 385:	c3                   	ret    

00000386 <strlen>:

uint
strlen(char *s)
{
 386:	55                   	push   %ebp
 387:	89 e5                	mov    %esp,%ebp
 389:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 38c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 393:	eb 04                	jmp    399 <strlen+0x13>
 395:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 399:	8b 55 fc             	mov    -0x4(%ebp),%edx
 39c:	8b 45 08             	mov    0x8(%ebp),%eax
 39f:	01 d0                	add    %edx,%eax
 3a1:	0f b6 00             	movzbl (%eax),%eax
 3a4:	84 c0                	test   %al,%al
 3a6:	75 ed                	jne    395 <strlen+0xf>
    ;
  return n;
 3a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3ab:	c9                   	leave  
 3ac:	c3                   	ret    

000003ad <memset>:

void*
memset(void *dst, int c, uint n)
{
 3ad:	55                   	push   %ebp
 3ae:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 3b0:	8b 45 10             	mov    0x10(%ebp),%eax
 3b3:	50                   	push   %eax
 3b4:	ff 75 0c             	pushl  0xc(%ebp)
 3b7:	ff 75 08             	pushl  0x8(%ebp)
 3ba:	e8 32 ff ff ff       	call   2f1 <stosb>
 3bf:	83 c4 0c             	add    $0xc,%esp
  return dst;
 3c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3c5:	c9                   	leave  
 3c6:	c3                   	ret    

000003c7 <strchr>:

char*
strchr(const char *s, char c)
{
 3c7:	55                   	push   %ebp
 3c8:	89 e5                	mov    %esp,%ebp
 3ca:	83 ec 04             	sub    $0x4,%esp
 3cd:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d0:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 3d3:	eb 14                	jmp    3e9 <strchr+0x22>
    if(*s == c)
 3d5:	8b 45 08             	mov    0x8(%ebp),%eax
 3d8:	0f b6 00             	movzbl (%eax),%eax
 3db:	3a 45 fc             	cmp    -0x4(%ebp),%al
 3de:	75 05                	jne    3e5 <strchr+0x1e>
      return (char*)s;
 3e0:	8b 45 08             	mov    0x8(%ebp),%eax
 3e3:	eb 13                	jmp    3f8 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 3e5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3e9:	8b 45 08             	mov    0x8(%ebp),%eax
 3ec:	0f b6 00             	movzbl (%eax),%eax
 3ef:	84 c0                	test   %al,%al
 3f1:	75 e2                	jne    3d5 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 3f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
 3f8:	c9                   	leave  
 3f9:	c3                   	ret    

000003fa <gets>:

char*
gets(char *buf, int max)
{
 3fa:	55                   	push   %ebp
 3fb:	89 e5                	mov    %esp,%ebp
 3fd:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 400:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 407:	eb 42                	jmp    44b <gets+0x51>
    cc = read(0, &c, 1);
 409:	83 ec 04             	sub    $0x4,%esp
 40c:	6a 01                	push   $0x1
 40e:	8d 45 ef             	lea    -0x11(%ebp),%eax
 411:	50                   	push   %eax
 412:	6a 00                	push   $0x0
 414:	e8 47 01 00 00       	call   560 <read>
 419:	83 c4 10             	add    $0x10,%esp
 41c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 41f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 423:	7e 33                	jle    458 <gets+0x5e>
      break;
    buf[i++] = c;
 425:	8b 45 f4             	mov    -0xc(%ebp),%eax
 428:	8d 50 01             	lea    0x1(%eax),%edx
 42b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 42e:	89 c2                	mov    %eax,%edx
 430:	8b 45 08             	mov    0x8(%ebp),%eax
 433:	01 c2                	add    %eax,%edx
 435:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 439:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 43b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 43f:	3c 0a                	cmp    $0xa,%al
 441:	74 16                	je     459 <gets+0x5f>
 443:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 447:	3c 0d                	cmp    $0xd,%al
 449:	74 0e                	je     459 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 44b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 44e:	83 c0 01             	add    $0x1,%eax
 451:	3b 45 0c             	cmp    0xc(%ebp),%eax
 454:	7c b3                	jl     409 <gets+0xf>
 456:	eb 01                	jmp    459 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 458:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 459:	8b 55 f4             	mov    -0xc(%ebp),%edx
 45c:	8b 45 08             	mov    0x8(%ebp),%eax
 45f:	01 d0                	add    %edx,%eax
 461:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 464:	8b 45 08             	mov    0x8(%ebp),%eax
}
 467:	c9                   	leave  
 468:	c3                   	ret    

00000469 <stat>:

int
stat(char *n, struct stat *st)
{
 469:	55                   	push   %ebp
 46a:	89 e5                	mov    %esp,%ebp
 46c:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY | O_NBLOCK);
 46f:	83 ec 08             	sub    $0x8,%esp
 472:	6a 10                	push   $0x10
 474:	ff 75 08             	pushl  0x8(%ebp)
 477:	e8 0c 01 00 00       	call   588 <open>
 47c:	83 c4 10             	add    $0x10,%esp
 47f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 482:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 486:	79 07                	jns    48f <stat+0x26>
    return -1;
 488:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 48d:	eb 25                	jmp    4b4 <stat+0x4b>
  r = fstat(fd, st);
 48f:	83 ec 08             	sub    $0x8,%esp
 492:	ff 75 0c             	pushl  0xc(%ebp)
 495:	ff 75 f4             	pushl  -0xc(%ebp)
 498:	e8 03 01 00 00       	call   5a0 <fstat>
 49d:	83 c4 10             	add    $0x10,%esp
 4a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4a3:	83 ec 0c             	sub    $0xc,%esp
 4a6:	ff 75 f4             	pushl  -0xc(%ebp)
 4a9:	e8 c2 00 00 00       	call   570 <close>
 4ae:	83 c4 10             	add    $0x10,%esp
  return r;
 4b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4b4:	c9                   	leave  
 4b5:	c3                   	ret    

000004b6 <atoi>:

int
atoi(const char *s)
{
 4b6:	55                   	push   %ebp
 4b7:	89 e5                	mov    %esp,%ebp
 4b9:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 4bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 4c3:	eb 25                	jmp    4ea <atoi+0x34>
    n = n*10 + *s++ - '0';
 4c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4c8:	89 d0                	mov    %edx,%eax
 4ca:	c1 e0 02             	shl    $0x2,%eax
 4cd:	01 d0                	add    %edx,%eax
 4cf:	01 c0                	add    %eax,%eax
 4d1:	89 c1                	mov    %eax,%ecx
 4d3:	8b 45 08             	mov    0x8(%ebp),%eax
 4d6:	8d 50 01             	lea    0x1(%eax),%edx
 4d9:	89 55 08             	mov    %edx,0x8(%ebp)
 4dc:	0f b6 00             	movzbl (%eax),%eax
 4df:	0f be c0             	movsbl %al,%eax
 4e2:	01 c8                	add    %ecx,%eax
 4e4:	83 e8 30             	sub    $0x30,%eax
 4e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4ea:	8b 45 08             	mov    0x8(%ebp),%eax
 4ed:	0f b6 00             	movzbl (%eax),%eax
 4f0:	3c 2f                	cmp    $0x2f,%al
 4f2:	7e 0a                	jle    4fe <atoi+0x48>
 4f4:	8b 45 08             	mov    0x8(%ebp),%eax
 4f7:	0f b6 00             	movzbl (%eax),%eax
 4fa:	3c 39                	cmp    $0x39,%al
 4fc:	7e c7                	jle    4c5 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 4fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 501:	c9                   	leave  
 502:	c3                   	ret    

00000503 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 503:	55                   	push   %ebp
 504:	89 e5                	mov    %esp,%ebp
 506:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 509:	8b 45 08             	mov    0x8(%ebp),%eax
 50c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 50f:	8b 45 0c             	mov    0xc(%ebp),%eax
 512:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 515:	eb 17                	jmp    52e <memmove+0x2b>
    *dst++ = *src++;
 517:	8b 45 fc             	mov    -0x4(%ebp),%eax
 51a:	8d 50 01             	lea    0x1(%eax),%edx
 51d:	89 55 fc             	mov    %edx,-0x4(%ebp)
 520:	8b 55 f8             	mov    -0x8(%ebp),%edx
 523:	8d 4a 01             	lea    0x1(%edx),%ecx
 526:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 529:	0f b6 12             	movzbl (%edx),%edx
 52c:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 52e:	8b 45 10             	mov    0x10(%ebp),%eax
 531:	8d 50 ff             	lea    -0x1(%eax),%edx
 534:	89 55 10             	mov    %edx,0x10(%ebp)
 537:	85 c0                	test   %eax,%eax
 539:	7f dc                	jg     517 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 53b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 53e:	c9                   	leave  
 53f:	c3                   	ret    

00000540 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 540:	b8 01 00 00 00       	mov    $0x1,%eax
 545:	cd 40                	int    $0x40
 547:	c3                   	ret    

00000548 <exit>:
SYSCALL(exit)
 548:	b8 02 00 00 00       	mov    $0x2,%eax
 54d:	cd 40                	int    $0x40
 54f:	c3                   	ret    

00000550 <wait>:
SYSCALL(wait)
 550:	b8 03 00 00 00       	mov    $0x3,%eax
 555:	cd 40                	int    $0x40
 557:	c3                   	ret    

00000558 <pipe>:
SYSCALL(pipe)
 558:	b8 04 00 00 00       	mov    $0x4,%eax
 55d:	cd 40                	int    $0x40
 55f:	c3                   	ret    

00000560 <read>:
SYSCALL(read)
 560:	b8 05 00 00 00       	mov    $0x5,%eax
 565:	cd 40                	int    $0x40
 567:	c3                   	ret    

00000568 <write>:
SYSCALL(write)
 568:	b8 10 00 00 00       	mov    $0x10,%eax
 56d:	cd 40                	int    $0x40
 56f:	c3                   	ret    

00000570 <close>:
SYSCALL(close)
 570:	b8 15 00 00 00       	mov    $0x15,%eax
 575:	cd 40                	int    $0x40
 577:	c3                   	ret    

00000578 <kill>:
SYSCALL(kill)
 578:	b8 06 00 00 00       	mov    $0x6,%eax
 57d:	cd 40                	int    $0x40
 57f:	c3                   	ret    

00000580 <exec>:
SYSCALL(exec)
 580:	b8 07 00 00 00       	mov    $0x7,%eax
 585:	cd 40                	int    $0x40
 587:	c3                   	ret    

00000588 <open>:
SYSCALL(open)
 588:	b8 0f 00 00 00       	mov    $0xf,%eax
 58d:	cd 40                	int    $0x40
 58f:	c3                   	ret    

00000590 <mknod>:
SYSCALL(mknod)
 590:	b8 11 00 00 00       	mov    $0x11,%eax
 595:	cd 40                	int    $0x40
 597:	c3                   	ret    

00000598 <unlink>:
SYSCALL(unlink)
 598:	b8 12 00 00 00       	mov    $0x12,%eax
 59d:	cd 40                	int    $0x40
 59f:	c3                   	ret    

000005a0 <fstat>:
SYSCALL(fstat)
 5a0:	b8 08 00 00 00       	mov    $0x8,%eax
 5a5:	cd 40                	int    $0x40
 5a7:	c3                   	ret    

000005a8 <link>:
SYSCALL(link)
 5a8:	b8 13 00 00 00       	mov    $0x13,%eax
 5ad:	cd 40                	int    $0x40
 5af:	c3                   	ret    

000005b0 <mkdir>:
SYSCALL(mkdir)
 5b0:	b8 14 00 00 00       	mov    $0x14,%eax
 5b5:	cd 40                	int    $0x40
 5b7:	c3                   	ret    

000005b8 <chdir>:
SYSCALL(chdir)
 5b8:	b8 09 00 00 00       	mov    $0x9,%eax
 5bd:	cd 40                	int    $0x40
 5bf:	c3                   	ret    

000005c0 <dup>:
SYSCALL(dup)
 5c0:	b8 0a 00 00 00       	mov    $0xa,%eax
 5c5:	cd 40                	int    $0x40
 5c7:	c3                   	ret    

000005c8 <getpid>:
SYSCALL(getpid)
 5c8:	b8 0b 00 00 00       	mov    $0xb,%eax
 5cd:	cd 40                	int    $0x40
 5cf:	c3                   	ret    

000005d0 <sbrk>:
SYSCALL(sbrk)
 5d0:	b8 0c 00 00 00       	mov    $0xc,%eax
 5d5:	cd 40                	int    $0x40
 5d7:	c3                   	ret    

000005d8 <sleep>:
SYSCALL(sleep)
 5d8:	b8 0d 00 00 00       	mov    $0xd,%eax
 5dd:	cd 40                	int    $0x40
 5df:	c3                   	ret    

000005e0 <uptime>:
SYSCALL(uptime)
 5e0:	b8 0e 00 00 00       	mov    $0xe,%eax
 5e5:	cd 40                	int    $0x40
 5e7:	c3                   	ret    

000005e8 <mkfifo>:
SYSCALL(mkfifo)
 5e8:	b8 16 00 00 00       	mov    $0x16,%eax
 5ed:	cd 40                	int    $0x40
 5ef:	c3                   	ret    

000005f0 <up>:
SYSCALL(up)
 5f0:	b8 18 00 00 00       	mov    $0x18,%eax
 5f5:	cd 40                	int    $0x40
 5f7:	c3                   	ret    

000005f8 <down>:
SYSCALL(down)
 5f8:	b8 17 00 00 00       	mov    $0x17,%eax
 5fd:	cd 40                	int    $0x40
 5ff:	c3                   	ret    

00000600 <setuid>:
 600:	b8 19 00 00 00       	mov    $0x19,%eax
 605:	cd 40                	int    $0x40
 607:	c3                   	ret    

00000608 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 608:	55                   	push   %ebp
 609:	89 e5                	mov    %esp,%ebp
 60b:	83 ec 18             	sub    $0x18,%esp
 60e:	8b 45 0c             	mov    0xc(%ebp),%eax
 611:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 614:	83 ec 04             	sub    $0x4,%esp
 617:	6a 01                	push   $0x1
 619:	8d 45 f4             	lea    -0xc(%ebp),%eax
 61c:	50                   	push   %eax
 61d:	ff 75 08             	pushl  0x8(%ebp)
 620:	e8 43 ff ff ff       	call   568 <write>
 625:	83 c4 10             	add    $0x10,%esp
}
 628:	90                   	nop
 629:	c9                   	leave  
 62a:	c3                   	ret    

0000062b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 62b:	55                   	push   %ebp
 62c:	89 e5                	mov    %esp,%ebp
 62e:	53                   	push   %ebx
 62f:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 632:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 639:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 63d:	74 17                	je     656 <printint+0x2b>
 63f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 643:	79 11                	jns    656 <printint+0x2b>
    neg = 1;
 645:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 64c:	8b 45 0c             	mov    0xc(%ebp),%eax
 64f:	f7 d8                	neg    %eax
 651:	89 45 ec             	mov    %eax,-0x14(%ebp)
 654:	eb 06                	jmp    65c <printint+0x31>
  } else {
    x = xx;
 656:	8b 45 0c             	mov    0xc(%ebp),%eax
 659:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 65c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 663:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 666:	8d 41 01             	lea    0x1(%ecx),%eax
 669:	89 45 f4             	mov    %eax,-0xc(%ebp)
 66c:	8b 5d 10             	mov    0x10(%ebp),%ebx
 66f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 672:	ba 00 00 00 00       	mov    $0x0,%edx
 677:	f7 f3                	div    %ebx
 679:	89 d0                	mov    %edx,%eax
 67b:	0f b6 80 54 0d 00 00 	movzbl 0xd54(%eax),%eax
 682:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 686:	8b 5d 10             	mov    0x10(%ebp),%ebx
 689:	8b 45 ec             	mov    -0x14(%ebp),%eax
 68c:	ba 00 00 00 00       	mov    $0x0,%edx
 691:	f7 f3                	div    %ebx
 693:	89 45 ec             	mov    %eax,-0x14(%ebp)
 696:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 69a:	75 c7                	jne    663 <printint+0x38>
  if(neg)
 69c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6a0:	74 2d                	je     6cf <printint+0xa4>
    buf[i++] = '-';
 6a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a5:	8d 50 01             	lea    0x1(%eax),%edx
 6a8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6ab:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6b0:	eb 1d                	jmp    6cf <printint+0xa4>
    putc(fd, buf[i]);
 6b2:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6b8:	01 d0                	add    %edx,%eax
 6ba:	0f b6 00             	movzbl (%eax),%eax
 6bd:	0f be c0             	movsbl %al,%eax
 6c0:	83 ec 08             	sub    $0x8,%esp
 6c3:	50                   	push   %eax
 6c4:	ff 75 08             	pushl  0x8(%ebp)
 6c7:	e8 3c ff ff ff       	call   608 <putc>
 6cc:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6cf:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6d7:	79 d9                	jns    6b2 <printint+0x87>
    putc(fd, buf[i]);
}
 6d9:	90                   	nop
 6da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6dd:	c9                   	leave  
 6de:	c3                   	ret    

000006df <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6df:	55                   	push   %ebp
 6e0:	89 e5                	mov    %esp,%ebp
 6e2:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6e5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6ec:	8d 45 0c             	lea    0xc(%ebp),%eax
 6ef:	83 c0 04             	add    $0x4,%eax
 6f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6f5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6fc:	e9 59 01 00 00       	jmp    85a <printf+0x17b>
    c = fmt[i] & 0xff;
 701:	8b 55 0c             	mov    0xc(%ebp),%edx
 704:	8b 45 f0             	mov    -0x10(%ebp),%eax
 707:	01 d0                	add    %edx,%eax
 709:	0f b6 00             	movzbl (%eax),%eax
 70c:	0f be c0             	movsbl %al,%eax
 70f:	25 ff 00 00 00       	and    $0xff,%eax
 714:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 717:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 71b:	75 2c                	jne    749 <printf+0x6a>
      if(c == '%'){
 71d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 721:	75 0c                	jne    72f <printf+0x50>
        state = '%';
 723:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 72a:	e9 27 01 00 00       	jmp    856 <printf+0x177>
      } else {
        putc(fd, c);
 72f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 732:	0f be c0             	movsbl %al,%eax
 735:	83 ec 08             	sub    $0x8,%esp
 738:	50                   	push   %eax
 739:	ff 75 08             	pushl  0x8(%ebp)
 73c:	e8 c7 fe ff ff       	call   608 <putc>
 741:	83 c4 10             	add    $0x10,%esp
 744:	e9 0d 01 00 00       	jmp    856 <printf+0x177>
      }
    } else if(state == '%'){
 749:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 74d:	0f 85 03 01 00 00    	jne    856 <printf+0x177>
      if(c == 'd'){
 753:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 757:	75 1e                	jne    777 <printf+0x98>
        printint(fd, *ap, 10, 1);
 759:	8b 45 e8             	mov    -0x18(%ebp),%eax
 75c:	8b 00                	mov    (%eax),%eax
 75e:	6a 01                	push   $0x1
 760:	6a 0a                	push   $0xa
 762:	50                   	push   %eax
 763:	ff 75 08             	pushl  0x8(%ebp)
 766:	e8 c0 fe ff ff       	call   62b <printint>
 76b:	83 c4 10             	add    $0x10,%esp
        ap++;
 76e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 772:	e9 d8 00 00 00       	jmp    84f <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 777:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 77b:	74 06                	je     783 <printf+0xa4>
 77d:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 781:	75 1e                	jne    7a1 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 783:	8b 45 e8             	mov    -0x18(%ebp),%eax
 786:	8b 00                	mov    (%eax),%eax
 788:	6a 00                	push   $0x0
 78a:	6a 10                	push   $0x10
 78c:	50                   	push   %eax
 78d:	ff 75 08             	pushl  0x8(%ebp)
 790:	e8 96 fe ff ff       	call   62b <printint>
 795:	83 c4 10             	add    $0x10,%esp
        ap++;
 798:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 79c:	e9 ae 00 00 00       	jmp    84f <printf+0x170>
      } else if(c == 's'){
 7a1:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7a5:	75 43                	jne    7ea <printf+0x10b>
        s = (char*)*ap;
 7a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7aa:	8b 00                	mov    (%eax),%eax
 7ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7af:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7b7:	75 25                	jne    7de <printf+0xff>
          s = "(null)";
 7b9:	c7 45 f4 03 0b 00 00 	movl   $0xb03,-0xc(%ebp)
        while(*s != 0){
 7c0:	eb 1c                	jmp    7de <printf+0xff>
          putc(fd, *s);
 7c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c5:	0f b6 00             	movzbl (%eax),%eax
 7c8:	0f be c0             	movsbl %al,%eax
 7cb:	83 ec 08             	sub    $0x8,%esp
 7ce:	50                   	push   %eax
 7cf:	ff 75 08             	pushl  0x8(%ebp)
 7d2:	e8 31 fe ff ff       	call   608 <putc>
 7d7:	83 c4 10             	add    $0x10,%esp
          s++;
 7da:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e1:	0f b6 00             	movzbl (%eax),%eax
 7e4:	84 c0                	test   %al,%al
 7e6:	75 da                	jne    7c2 <printf+0xe3>
 7e8:	eb 65                	jmp    84f <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7ea:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7ee:	75 1d                	jne    80d <printf+0x12e>
        putc(fd, *ap);
 7f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7f3:	8b 00                	mov    (%eax),%eax
 7f5:	0f be c0             	movsbl %al,%eax
 7f8:	83 ec 08             	sub    $0x8,%esp
 7fb:	50                   	push   %eax
 7fc:	ff 75 08             	pushl  0x8(%ebp)
 7ff:	e8 04 fe ff ff       	call   608 <putc>
 804:	83 c4 10             	add    $0x10,%esp
        ap++;
 807:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 80b:	eb 42                	jmp    84f <printf+0x170>
      } else if(c == '%'){
 80d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 811:	75 17                	jne    82a <printf+0x14b>
        putc(fd, c);
 813:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 816:	0f be c0             	movsbl %al,%eax
 819:	83 ec 08             	sub    $0x8,%esp
 81c:	50                   	push   %eax
 81d:	ff 75 08             	pushl  0x8(%ebp)
 820:	e8 e3 fd ff ff       	call   608 <putc>
 825:	83 c4 10             	add    $0x10,%esp
 828:	eb 25                	jmp    84f <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 82a:	83 ec 08             	sub    $0x8,%esp
 82d:	6a 25                	push   $0x25
 82f:	ff 75 08             	pushl  0x8(%ebp)
 832:	e8 d1 fd ff ff       	call   608 <putc>
 837:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 83a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 83d:	0f be c0             	movsbl %al,%eax
 840:	83 ec 08             	sub    $0x8,%esp
 843:	50                   	push   %eax
 844:	ff 75 08             	pushl  0x8(%ebp)
 847:	e8 bc fd ff ff       	call   608 <putc>
 84c:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 84f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 856:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 85a:	8b 55 0c             	mov    0xc(%ebp),%edx
 85d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 860:	01 d0                	add    %edx,%eax
 862:	0f b6 00             	movzbl (%eax),%eax
 865:	84 c0                	test   %al,%al
 867:	0f 85 94 fe ff ff    	jne    701 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 86d:	90                   	nop
 86e:	c9                   	leave  
 86f:	c3                   	ret    

00000870 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 870:	55                   	push   %ebp
 871:	89 e5                	mov    %esp,%ebp
 873:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 876:	8b 45 08             	mov    0x8(%ebp),%eax
 879:	83 e8 08             	sub    $0x8,%eax
 87c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 87f:	a1 70 0d 00 00       	mov    0xd70,%eax
 884:	89 45 fc             	mov    %eax,-0x4(%ebp)
 887:	eb 24                	jmp    8ad <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 889:	8b 45 fc             	mov    -0x4(%ebp),%eax
 88c:	8b 00                	mov    (%eax),%eax
 88e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 891:	77 12                	ja     8a5 <free+0x35>
 893:	8b 45 f8             	mov    -0x8(%ebp),%eax
 896:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 899:	77 24                	ja     8bf <free+0x4f>
 89b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 89e:	8b 00                	mov    (%eax),%eax
 8a0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8a3:	77 1a                	ja     8bf <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a8:	8b 00                	mov    (%eax),%eax
 8aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8b3:	76 d4                	jbe    889 <free+0x19>
 8b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b8:	8b 00                	mov    (%eax),%eax
 8ba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8bd:	76 ca                	jbe    889 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c2:	8b 40 04             	mov    0x4(%eax),%eax
 8c5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8cf:	01 c2                	add    %eax,%edx
 8d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d4:	8b 00                	mov    (%eax),%eax
 8d6:	39 c2                	cmp    %eax,%edx
 8d8:	75 24                	jne    8fe <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8da:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8dd:	8b 50 04             	mov    0x4(%eax),%edx
 8e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e3:	8b 00                	mov    (%eax),%eax
 8e5:	8b 40 04             	mov    0x4(%eax),%eax
 8e8:	01 c2                	add    %eax,%edx
 8ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ed:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f3:	8b 00                	mov    (%eax),%eax
 8f5:	8b 10                	mov    (%eax),%edx
 8f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8fa:	89 10                	mov    %edx,(%eax)
 8fc:	eb 0a                	jmp    908 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 8fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 901:	8b 10                	mov    (%eax),%edx
 903:	8b 45 f8             	mov    -0x8(%ebp),%eax
 906:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 908:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90b:	8b 40 04             	mov    0x4(%eax),%eax
 90e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 915:	8b 45 fc             	mov    -0x4(%ebp),%eax
 918:	01 d0                	add    %edx,%eax
 91a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 91d:	75 20                	jne    93f <free+0xcf>
    p->s.size += bp->s.size;
 91f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 922:	8b 50 04             	mov    0x4(%eax),%edx
 925:	8b 45 f8             	mov    -0x8(%ebp),%eax
 928:	8b 40 04             	mov    0x4(%eax),%eax
 92b:	01 c2                	add    %eax,%edx
 92d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 930:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 933:	8b 45 f8             	mov    -0x8(%ebp),%eax
 936:	8b 10                	mov    (%eax),%edx
 938:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93b:	89 10                	mov    %edx,(%eax)
 93d:	eb 08                	jmp    947 <free+0xd7>
  } else
    p->s.ptr = bp;
 93f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 942:	8b 55 f8             	mov    -0x8(%ebp),%edx
 945:	89 10                	mov    %edx,(%eax)
  freep = p;
 947:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94a:	a3 70 0d 00 00       	mov    %eax,0xd70
}
 94f:	90                   	nop
 950:	c9                   	leave  
 951:	c3                   	ret    

00000952 <morecore>:

static Header*
morecore(uint nu)
{
 952:	55                   	push   %ebp
 953:	89 e5                	mov    %esp,%ebp
 955:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 958:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 95f:	77 07                	ja     968 <morecore+0x16>
    nu = 4096;
 961:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 968:	8b 45 08             	mov    0x8(%ebp),%eax
 96b:	c1 e0 03             	shl    $0x3,%eax
 96e:	83 ec 0c             	sub    $0xc,%esp
 971:	50                   	push   %eax
 972:	e8 59 fc ff ff       	call   5d0 <sbrk>
 977:	83 c4 10             	add    $0x10,%esp
 97a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 97d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 981:	75 07                	jne    98a <morecore+0x38>
    return 0;
 983:	b8 00 00 00 00       	mov    $0x0,%eax
 988:	eb 26                	jmp    9b0 <morecore+0x5e>
  hp = (Header*)p;
 98a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 990:	8b 45 f0             	mov    -0x10(%ebp),%eax
 993:	8b 55 08             	mov    0x8(%ebp),%edx
 996:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 999:	8b 45 f0             	mov    -0x10(%ebp),%eax
 99c:	83 c0 08             	add    $0x8,%eax
 99f:	83 ec 0c             	sub    $0xc,%esp
 9a2:	50                   	push   %eax
 9a3:	e8 c8 fe ff ff       	call   870 <free>
 9a8:	83 c4 10             	add    $0x10,%esp
  return freep;
 9ab:	a1 70 0d 00 00       	mov    0xd70,%eax
}
 9b0:	c9                   	leave  
 9b1:	c3                   	ret    

000009b2 <malloc>:

void*
malloc(uint nbytes)
{
 9b2:	55                   	push   %ebp
 9b3:	89 e5                	mov    %esp,%ebp
 9b5:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9b8:	8b 45 08             	mov    0x8(%ebp),%eax
 9bb:	83 c0 07             	add    $0x7,%eax
 9be:	c1 e8 03             	shr    $0x3,%eax
 9c1:	83 c0 01             	add    $0x1,%eax
 9c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9c7:	a1 70 0d 00 00       	mov    0xd70,%eax
 9cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9d3:	75 23                	jne    9f8 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9d5:	c7 45 f0 68 0d 00 00 	movl   $0xd68,-0x10(%ebp)
 9dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9df:	a3 70 0d 00 00       	mov    %eax,0xd70
 9e4:	a1 70 0d 00 00       	mov    0xd70,%eax
 9e9:	a3 68 0d 00 00       	mov    %eax,0xd68
    base.s.size = 0;
 9ee:	c7 05 6c 0d 00 00 00 	movl   $0x0,0xd6c
 9f5:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9fb:	8b 00                	mov    (%eax),%eax
 9fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a03:	8b 40 04             	mov    0x4(%eax),%eax
 a06:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a09:	72 4d                	jb     a58 <malloc+0xa6>
      if(p->s.size == nunits)
 a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a0e:	8b 40 04             	mov    0x4(%eax),%eax
 a11:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a14:	75 0c                	jne    a22 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a19:	8b 10                	mov    (%eax),%edx
 a1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a1e:	89 10                	mov    %edx,(%eax)
 a20:	eb 26                	jmp    a48 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a25:	8b 40 04             	mov    0x4(%eax),%eax
 a28:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a2b:	89 c2                	mov    %eax,%edx
 a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a30:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a36:	8b 40 04             	mov    0x4(%eax),%eax
 a39:	c1 e0 03             	shl    $0x3,%eax
 a3c:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a42:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a45:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a48:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a4b:	a3 70 0d 00 00       	mov    %eax,0xd70
      return (void*)(p + 1);
 a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a53:	83 c0 08             	add    $0x8,%eax
 a56:	eb 3b                	jmp    a93 <malloc+0xe1>
    }
    if(p == freep)
 a58:	a1 70 0d 00 00       	mov    0xd70,%eax
 a5d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a60:	75 1e                	jne    a80 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a62:	83 ec 0c             	sub    $0xc,%esp
 a65:	ff 75 ec             	pushl  -0x14(%ebp)
 a68:	e8 e5 fe ff ff       	call   952 <morecore>
 a6d:	83 c4 10             	add    $0x10,%esp
 a70:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a77:	75 07                	jne    a80 <malloc+0xce>
        return 0;
 a79:	b8 00 00 00 00       	mov    $0x0,%eax
 a7e:	eb 13                	jmp    a93 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a83:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a89:	8b 00                	mov    (%eax),%eax
 a8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a8e:	e9 6d ff ff ff       	jmp    a00 <malloc+0x4e>
}
 a93:	c9                   	leave  
 a94:	c3                   	ret    
