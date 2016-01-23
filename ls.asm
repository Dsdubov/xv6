
_ls:     формат файла elf32-i386


Дизассемблирование раздела .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 14             	sub    $0x14,%esp
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   7:	83 ec 0c             	sub    $0xc,%esp
   a:	ff 75 08             	pushl  0x8(%ebp)
   d:	e8 12 04 00 00       	call   424 <strlen>
  12:	83 c4 10             	add    $0x10,%esp
  15:	89 c2                	mov    %eax,%edx
  17:	8b 45 08             	mov    0x8(%ebp),%eax
  1a:	01 d0                	add    %edx,%eax
  1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1f:	eb 04                	jmp    25 <fmtname+0x25>
  21:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  28:	3b 45 08             	cmp    0x8(%ebp),%eax
  2b:	72 0a                	jb     37 <fmtname+0x37>
  2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  30:	0f b6 00             	movzbl (%eax),%eax
  33:	3c 2f                	cmp    $0x2f,%al
  35:	75 ea                	jne    21 <fmtname+0x21>
    ;
  p++;
  37:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  3b:	83 ec 0c             	sub    $0xc,%esp
  3e:	ff 75 f4             	pushl  -0xc(%ebp)
  41:	e8 de 03 00 00       	call   424 <strlen>
  46:	83 c4 10             	add    $0x10,%esp
  49:	83 f8 0d             	cmp    $0xd,%eax
  4c:	76 05                	jbe    53 <fmtname+0x53>
    return p;
  4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  51:	eb 60                	jmp    b3 <fmtname+0xb3>
  memmove(buf, p, strlen(p));
  53:	83 ec 0c             	sub    $0xc,%esp
  56:	ff 75 f4             	pushl  -0xc(%ebp)
  59:	e8 c6 03 00 00       	call   424 <strlen>
  5e:	83 c4 10             	add    $0x10,%esp
  61:	83 ec 04             	sub    $0x4,%esp
  64:	50                   	push   %eax
  65:	ff 75 f4             	pushl  -0xc(%ebp)
  68:	68 38 0e 00 00       	push   $0xe38
  6d:	e8 2f 05 00 00       	call   5a1 <memmove>
  72:	83 c4 10             	add    $0x10,%esp
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  75:	83 ec 0c             	sub    $0xc,%esp
  78:	ff 75 f4             	pushl  -0xc(%ebp)
  7b:	e8 a4 03 00 00       	call   424 <strlen>
  80:	83 c4 10             	add    $0x10,%esp
  83:	ba 0e 00 00 00       	mov    $0xe,%edx
  88:	89 d3                	mov    %edx,%ebx
  8a:	29 c3                	sub    %eax,%ebx
  8c:	83 ec 0c             	sub    $0xc,%esp
  8f:	ff 75 f4             	pushl  -0xc(%ebp)
  92:	e8 8d 03 00 00       	call   424 <strlen>
  97:	83 c4 10             	add    $0x10,%esp
  9a:	05 38 0e 00 00       	add    $0xe38,%eax
  9f:	83 ec 04             	sub    $0x4,%esp
  a2:	53                   	push   %ebx
  a3:	6a 20                	push   $0x20
  a5:	50                   	push   %eax
  a6:	e8 a0 03 00 00       	call   44b <memset>
  ab:	83 c4 10             	add    $0x10,%esp
  return buf;
  ae:	b8 38 0e 00 00       	mov    $0xe38,%eax
}
  b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  b6:	c9                   	leave  
  b7:	c3                   	ret    

000000b8 <ls>:

void
ls(char *path)
{
  b8:	55                   	push   %ebp
  b9:	89 e5                	mov    %esp,%ebp
  bb:	57                   	push   %edi
  bc:	56                   	push   %esi
  bd:	53                   	push   %ebx
  be:	81 ec 3c 02 00 00    	sub    $0x23c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
  c4:	83 ec 08             	sub    $0x8,%esp
  c7:	6a 00                	push   $0x0
  c9:	ff 75 08             	pushl  0x8(%ebp)
  cc:	e8 55 05 00 00       	call   626 <open>
  d1:	83 c4 10             	add    $0x10,%esp
  d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  db:	79 1a                	jns    f7 <ls+0x3f>
    printf(2, "ls: cannot open %s\n", path);
  dd:	83 ec 04             	sub    $0x4,%esp
  e0:	ff 75 08             	pushl  0x8(%ebp)
  e3:	68 33 0b 00 00       	push   $0xb33
  e8:	6a 02                	push   $0x2
  ea:	e8 8e 06 00 00       	call   77d <printf>
  ef:	83 c4 10             	add    $0x10,%esp
    return;
  f2:	e9 2c 02 00 00       	jmp    323 <ls+0x26b>
  }
  
  if(fstat(fd, &st) < 0){
  f7:	83 ec 08             	sub    $0x8,%esp
  fa:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 100:	50                   	push   %eax
 101:	ff 75 e4             	pushl  -0x1c(%ebp)
 104:	e8 35 05 00 00       	call   63e <fstat>
 109:	83 c4 10             	add    $0x10,%esp
 10c:	85 c0                	test   %eax,%eax
 10e:	79 28                	jns    138 <ls+0x80>
    printf(2, "ls: cannot stat %s\n", path);
 110:	83 ec 04             	sub    $0x4,%esp
 113:	ff 75 08             	pushl  0x8(%ebp)
 116:	68 47 0b 00 00       	push   $0xb47
 11b:	6a 02                	push   $0x2
 11d:	e8 5b 06 00 00       	call   77d <printf>
 122:	83 c4 10             	add    $0x10,%esp
    close(fd);
 125:	83 ec 0c             	sub    $0xc,%esp
 128:	ff 75 e4             	pushl  -0x1c(%ebp)
 12b:	e8 de 04 00 00       	call   60e <close>
 130:	83 c4 10             	add    $0x10,%esp
    return;
 133:	e9 eb 01 00 00       	jmp    323 <ls+0x26b>
  }
  
  switch(st.type){
 138:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 13f:	98                   	cwtl   
 140:	83 f8 02             	cmp    $0x2,%eax
 143:	74 13                	je     158 <ls+0xa0>
 145:	83 f8 04             	cmp    $0x4,%eax
 148:	74 4d                	je     197 <ls+0xdf>
 14a:	83 f8 01             	cmp    $0x1,%eax
 14d:	0f 84 83 00 00 00    	je     1d6 <ls+0x11e>
 153:	e9 bd 01 00 00       	jmp    315 <ls+0x25d>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 158:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 15e:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 164:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 16b:	0f bf d8             	movswl %ax,%ebx
 16e:	83 ec 0c             	sub    $0xc,%esp
 171:	ff 75 08             	pushl  0x8(%ebp)
 174:	e8 87 fe ff ff       	call   0 <fmtname>
 179:	83 c4 10             	add    $0x10,%esp
 17c:	83 ec 08             	sub    $0x8,%esp
 17f:	57                   	push   %edi
 180:	56                   	push   %esi
 181:	53                   	push   %ebx
 182:	50                   	push   %eax
 183:	68 5b 0b 00 00       	push   $0xb5b
 188:	6a 01                	push   $0x1
 18a:	e8 ee 05 00 00       	call   77d <printf>
 18f:	83 c4 20             	add    $0x20,%esp
    break;
 192:	e9 7e 01 00 00       	jmp    315 <ls+0x25d>
  
  case T_FIFO:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 197:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 19d:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 1a3:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 1aa:	0f bf d8             	movswl %ax,%ebx
 1ad:	83 ec 0c             	sub    $0xc,%esp
 1b0:	ff 75 08             	pushl  0x8(%ebp)
 1b3:	e8 48 fe ff ff       	call   0 <fmtname>
 1b8:	83 c4 10             	add    $0x10,%esp
 1bb:	83 ec 08             	sub    $0x8,%esp
 1be:	57                   	push   %edi
 1bf:	56                   	push   %esi
 1c0:	53                   	push   %ebx
 1c1:	50                   	push   %eax
 1c2:	68 5b 0b 00 00       	push   $0xb5b
 1c7:	6a 01                	push   $0x1
 1c9:	e8 af 05 00 00       	call   77d <printf>
 1ce:	83 c4 20             	add    $0x20,%esp
    break;
 1d1:	e9 3f 01 00 00       	jmp    315 <ls+0x25d>

  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 1d6:	83 ec 0c             	sub    $0xc,%esp
 1d9:	ff 75 08             	pushl  0x8(%ebp)
 1dc:	e8 43 02 00 00       	call   424 <strlen>
 1e1:	83 c4 10             	add    $0x10,%esp
 1e4:	83 c0 10             	add    $0x10,%eax
 1e7:	3d 00 02 00 00       	cmp    $0x200,%eax
 1ec:	76 17                	jbe    205 <ls+0x14d>
      printf(1, "ls: path too long\n");
 1ee:	83 ec 08             	sub    $0x8,%esp
 1f1:	68 68 0b 00 00       	push   $0xb68
 1f6:	6a 01                	push   $0x1
 1f8:	e8 80 05 00 00       	call   77d <printf>
 1fd:	83 c4 10             	add    $0x10,%esp
      break;
 200:	e9 10 01 00 00       	jmp    315 <ls+0x25d>
    }
    strcpy(buf, path);
 205:	83 ec 08             	sub    $0x8,%esp
 208:	ff 75 08             	pushl  0x8(%ebp)
 20b:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 211:	50                   	push   %eax
 212:	e8 9e 01 00 00       	call   3b5 <strcpy>
 217:	83 c4 10             	add    $0x10,%esp
    p = buf+strlen(buf);
 21a:	83 ec 0c             	sub    $0xc,%esp
 21d:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 223:	50                   	push   %eax
 224:	e8 fb 01 00 00       	call   424 <strlen>
 229:	83 c4 10             	add    $0x10,%esp
 22c:	89 c2                	mov    %eax,%edx
 22e:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 234:	01 d0                	add    %edx,%eax
 236:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
 239:	8b 45 e0             	mov    -0x20(%ebp),%eax
 23c:	8d 50 01             	lea    0x1(%eax),%edx
 23f:	89 55 e0             	mov    %edx,-0x20(%ebp)
 242:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 245:	e9 aa 00 00 00       	jmp    2f4 <ls+0x23c>
      if(de.inum == 0)
 24a:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
 251:	66 85 c0             	test   %ax,%ax
 254:	75 05                	jne    25b <ls+0x1a3>
        continue;
 256:	e9 99 00 00 00       	jmp    2f4 <ls+0x23c>
      memmove(p, de.name, DIRSIZ);
 25b:	83 ec 04             	sub    $0x4,%esp
 25e:	6a 0e                	push   $0xe
 260:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 266:	83 c0 02             	add    $0x2,%eax
 269:	50                   	push   %eax
 26a:	ff 75 e0             	pushl  -0x20(%ebp)
 26d:	e8 2f 03 00 00       	call   5a1 <memmove>
 272:	83 c4 10             	add    $0x10,%esp
      p[DIRSIZ] = 0;
 275:	8b 45 e0             	mov    -0x20(%ebp),%eax
 278:	83 c0 0e             	add    $0xe,%eax
 27b:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
 27e:	83 ec 08             	sub    $0x8,%esp
 281:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 287:	50                   	push   %eax
 288:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 28e:	50                   	push   %eax
 28f:	e8 73 02 00 00       	call   507 <stat>
 294:	83 c4 10             	add    $0x10,%esp
 297:	85 c0                	test   %eax,%eax
 299:	79 1b                	jns    2b6 <ls+0x1fe>
        printf(1, "ls: cannot stat %s\n", buf);
 29b:	83 ec 04             	sub    $0x4,%esp
 29e:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 2a4:	50                   	push   %eax
 2a5:	68 47 0b 00 00       	push   $0xb47
 2aa:	6a 01                	push   $0x1
 2ac:	e8 cc 04 00 00       	call   77d <printf>
 2b1:	83 c4 10             	add    $0x10,%esp
        continue;
 2b4:	eb 3e                	jmp    2f4 <ls+0x23c>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 2b6:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 2bc:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 2c2:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 2c9:	0f bf d8             	movswl %ax,%ebx
 2cc:	83 ec 0c             	sub    $0xc,%esp
 2cf:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 2d5:	50                   	push   %eax
 2d6:	e8 25 fd ff ff       	call   0 <fmtname>
 2db:	83 c4 10             	add    $0x10,%esp
 2de:	83 ec 08             	sub    $0x8,%esp
 2e1:	57                   	push   %edi
 2e2:	56                   	push   %esi
 2e3:	53                   	push   %ebx
 2e4:	50                   	push   %eax
 2e5:	68 5b 0b 00 00       	push   $0xb5b
 2ea:	6a 01                	push   $0x1
 2ec:	e8 8c 04 00 00       	call   77d <printf>
 2f1:	83 c4 20             	add    $0x20,%esp
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 2f4:	83 ec 04             	sub    $0x4,%esp
 2f7:	6a 10                	push   $0x10
 2f9:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 2ff:	50                   	push   %eax
 300:	ff 75 e4             	pushl  -0x1c(%ebp)
 303:	e8 f6 02 00 00       	call   5fe <read>
 308:	83 c4 10             	add    $0x10,%esp
 30b:	83 f8 10             	cmp    $0x10,%eax
 30e:	0f 84 36 ff ff ff    	je     24a <ls+0x192>
        printf(1, "ls: cannot stat %s\n", buf);
        continue;
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
 314:	90                   	nop
  }
  close(fd);
 315:	83 ec 0c             	sub    $0xc,%esp
 318:	ff 75 e4             	pushl  -0x1c(%ebp)
 31b:	e8 ee 02 00 00       	call   60e <close>
 320:	83 c4 10             	add    $0x10,%esp
}
 323:	8d 65 f4             	lea    -0xc(%ebp),%esp
 326:	5b                   	pop    %ebx
 327:	5e                   	pop    %esi
 328:	5f                   	pop    %edi
 329:	5d                   	pop    %ebp
 32a:	c3                   	ret    

0000032b <main>:

int
main(int argc, char *argv[])
{
 32b:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 32f:	83 e4 f0             	and    $0xfffffff0,%esp
 332:	ff 71 fc             	pushl  -0x4(%ecx)
 335:	55                   	push   %ebp
 336:	89 e5                	mov    %esp,%ebp
 338:	53                   	push   %ebx
 339:	51                   	push   %ecx
 33a:	83 ec 10             	sub    $0x10,%esp
 33d:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
 33f:	83 3b 01             	cmpl   $0x1,(%ebx)
 342:	7f 15                	jg     359 <main+0x2e>
    ls(".");
 344:	83 ec 0c             	sub    $0xc,%esp
 347:	68 7b 0b 00 00       	push   $0xb7b
 34c:	e8 67 fd ff ff       	call   b8 <ls>
 351:	83 c4 10             	add    $0x10,%esp
    exit();
 354:	e8 8d 02 00 00       	call   5e6 <exit>
  }
  for(i=1; i<argc; i++)
 359:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 360:	eb 21                	jmp    383 <main+0x58>
    ls(argv[i]);
 362:	8b 45 f4             	mov    -0xc(%ebp),%eax
 365:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 36c:	8b 43 04             	mov    0x4(%ebx),%eax
 36f:	01 d0                	add    %edx,%eax
 371:	8b 00                	mov    (%eax),%eax
 373:	83 ec 0c             	sub    $0xc,%esp
 376:	50                   	push   %eax
 377:	e8 3c fd ff ff       	call   b8 <ls>
 37c:	83 c4 10             	add    $0x10,%esp

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 37f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 383:	8b 45 f4             	mov    -0xc(%ebp),%eax
 386:	3b 03                	cmp    (%ebx),%eax
 388:	7c d8                	jl     362 <main+0x37>
    ls(argv[i]);
  exit();
 38a:	e8 57 02 00 00       	call   5e6 <exit>

0000038f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 38f:	55                   	push   %ebp
 390:	89 e5                	mov    %esp,%ebp
 392:	57                   	push   %edi
 393:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 394:	8b 4d 08             	mov    0x8(%ebp),%ecx
 397:	8b 55 10             	mov    0x10(%ebp),%edx
 39a:	8b 45 0c             	mov    0xc(%ebp),%eax
 39d:	89 cb                	mov    %ecx,%ebx
 39f:	89 df                	mov    %ebx,%edi
 3a1:	89 d1                	mov    %edx,%ecx
 3a3:	fc                   	cld    
 3a4:	f3 aa                	rep stos %al,%es:(%edi)
 3a6:	89 ca                	mov    %ecx,%edx
 3a8:	89 fb                	mov    %edi,%ebx
 3aa:	89 5d 08             	mov    %ebx,0x8(%ebp)
 3ad:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 3b0:	90                   	nop
 3b1:	5b                   	pop    %ebx
 3b2:	5f                   	pop    %edi
 3b3:	5d                   	pop    %ebp
 3b4:	c3                   	ret    

000003b5 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 3b5:	55                   	push   %ebp
 3b6:	89 e5                	mov    %esp,%ebp
 3b8:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 3bb:	8b 45 08             	mov    0x8(%ebp),%eax
 3be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 3c1:	90                   	nop
 3c2:	8b 45 08             	mov    0x8(%ebp),%eax
 3c5:	8d 50 01             	lea    0x1(%eax),%edx
 3c8:	89 55 08             	mov    %edx,0x8(%ebp)
 3cb:	8b 55 0c             	mov    0xc(%ebp),%edx
 3ce:	8d 4a 01             	lea    0x1(%edx),%ecx
 3d1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 3d4:	0f b6 12             	movzbl (%edx),%edx
 3d7:	88 10                	mov    %dl,(%eax)
 3d9:	0f b6 00             	movzbl (%eax),%eax
 3dc:	84 c0                	test   %al,%al
 3de:	75 e2                	jne    3c2 <strcpy+0xd>
    ;
  return os;
 3e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3e3:	c9                   	leave  
 3e4:	c3                   	ret    

000003e5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3e5:	55                   	push   %ebp
 3e6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3e8:	eb 08                	jmp    3f2 <strcmp+0xd>
    p++, q++;
 3ea:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3ee:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3f2:	8b 45 08             	mov    0x8(%ebp),%eax
 3f5:	0f b6 00             	movzbl (%eax),%eax
 3f8:	84 c0                	test   %al,%al
 3fa:	74 10                	je     40c <strcmp+0x27>
 3fc:	8b 45 08             	mov    0x8(%ebp),%eax
 3ff:	0f b6 10             	movzbl (%eax),%edx
 402:	8b 45 0c             	mov    0xc(%ebp),%eax
 405:	0f b6 00             	movzbl (%eax),%eax
 408:	38 c2                	cmp    %al,%dl
 40a:	74 de                	je     3ea <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 40c:	8b 45 08             	mov    0x8(%ebp),%eax
 40f:	0f b6 00             	movzbl (%eax),%eax
 412:	0f b6 d0             	movzbl %al,%edx
 415:	8b 45 0c             	mov    0xc(%ebp),%eax
 418:	0f b6 00             	movzbl (%eax),%eax
 41b:	0f b6 c0             	movzbl %al,%eax
 41e:	29 c2                	sub    %eax,%edx
 420:	89 d0                	mov    %edx,%eax
}
 422:	5d                   	pop    %ebp
 423:	c3                   	ret    

00000424 <strlen>:

uint
strlen(char *s)
{
 424:	55                   	push   %ebp
 425:	89 e5                	mov    %esp,%ebp
 427:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 42a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 431:	eb 04                	jmp    437 <strlen+0x13>
 433:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 437:	8b 55 fc             	mov    -0x4(%ebp),%edx
 43a:	8b 45 08             	mov    0x8(%ebp),%eax
 43d:	01 d0                	add    %edx,%eax
 43f:	0f b6 00             	movzbl (%eax),%eax
 442:	84 c0                	test   %al,%al
 444:	75 ed                	jne    433 <strlen+0xf>
    ;
  return n;
 446:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 449:	c9                   	leave  
 44a:	c3                   	ret    

0000044b <memset>:

void*
memset(void *dst, int c, uint n)
{
 44b:	55                   	push   %ebp
 44c:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 44e:	8b 45 10             	mov    0x10(%ebp),%eax
 451:	50                   	push   %eax
 452:	ff 75 0c             	pushl  0xc(%ebp)
 455:	ff 75 08             	pushl  0x8(%ebp)
 458:	e8 32 ff ff ff       	call   38f <stosb>
 45d:	83 c4 0c             	add    $0xc,%esp
  return dst;
 460:	8b 45 08             	mov    0x8(%ebp),%eax
}
 463:	c9                   	leave  
 464:	c3                   	ret    

00000465 <strchr>:

char*
strchr(const char *s, char c)
{
 465:	55                   	push   %ebp
 466:	89 e5                	mov    %esp,%ebp
 468:	83 ec 04             	sub    $0x4,%esp
 46b:	8b 45 0c             	mov    0xc(%ebp),%eax
 46e:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 471:	eb 14                	jmp    487 <strchr+0x22>
    if(*s == c)
 473:	8b 45 08             	mov    0x8(%ebp),%eax
 476:	0f b6 00             	movzbl (%eax),%eax
 479:	3a 45 fc             	cmp    -0x4(%ebp),%al
 47c:	75 05                	jne    483 <strchr+0x1e>
      return (char*)s;
 47e:	8b 45 08             	mov    0x8(%ebp),%eax
 481:	eb 13                	jmp    496 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 483:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 487:	8b 45 08             	mov    0x8(%ebp),%eax
 48a:	0f b6 00             	movzbl (%eax),%eax
 48d:	84 c0                	test   %al,%al
 48f:	75 e2                	jne    473 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 491:	b8 00 00 00 00       	mov    $0x0,%eax
}
 496:	c9                   	leave  
 497:	c3                   	ret    

00000498 <gets>:

char*
gets(char *buf, int max)
{
 498:	55                   	push   %ebp
 499:	89 e5                	mov    %esp,%ebp
 49b:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 49e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 4a5:	eb 42                	jmp    4e9 <gets+0x51>
    cc = read(0, &c, 1);
 4a7:	83 ec 04             	sub    $0x4,%esp
 4aa:	6a 01                	push   $0x1
 4ac:	8d 45 ef             	lea    -0x11(%ebp),%eax
 4af:	50                   	push   %eax
 4b0:	6a 00                	push   $0x0
 4b2:	e8 47 01 00 00       	call   5fe <read>
 4b7:	83 c4 10             	add    $0x10,%esp
 4ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 4bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4c1:	7e 33                	jle    4f6 <gets+0x5e>
      break;
    buf[i++] = c;
 4c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c6:	8d 50 01             	lea    0x1(%eax),%edx
 4c9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4cc:	89 c2                	mov    %eax,%edx
 4ce:	8b 45 08             	mov    0x8(%ebp),%eax
 4d1:	01 c2                	add    %eax,%edx
 4d3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4d7:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 4d9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4dd:	3c 0a                	cmp    $0xa,%al
 4df:	74 16                	je     4f7 <gets+0x5f>
 4e1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4e5:	3c 0d                	cmp    $0xd,%al
 4e7:	74 0e                	je     4f7 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ec:	83 c0 01             	add    $0x1,%eax
 4ef:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4f2:	7c b3                	jl     4a7 <gets+0xf>
 4f4:	eb 01                	jmp    4f7 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 4f6:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4fa:	8b 45 08             	mov    0x8(%ebp),%eax
 4fd:	01 d0                	add    %edx,%eax
 4ff:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 502:	8b 45 08             	mov    0x8(%ebp),%eax
}
 505:	c9                   	leave  
 506:	c3                   	ret    

00000507 <stat>:

int
stat(char *n, struct stat *st)
{
 507:	55                   	push   %ebp
 508:	89 e5                	mov    %esp,%ebp
 50a:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY | O_NBLOCK);
 50d:	83 ec 08             	sub    $0x8,%esp
 510:	6a 10                	push   $0x10
 512:	ff 75 08             	pushl  0x8(%ebp)
 515:	e8 0c 01 00 00       	call   626 <open>
 51a:	83 c4 10             	add    $0x10,%esp
 51d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 520:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 524:	79 07                	jns    52d <stat+0x26>
    return -1;
 526:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 52b:	eb 25                	jmp    552 <stat+0x4b>
  r = fstat(fd, st);
 52d:	83 ec 08             	sub    $0x8,%esp
 530:	ff 75 0c             	pushl  0xc(%ebp)
 533:	ff 75 f4             	pushl  -0xc(%ebp)
 536:	e8 03 01 00 00       	call   63e <fstat>
 53b:	83 c4 10             	add    $0x10,%esp
 53e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 541:	83 ec 0c             	sub    $0xc,%esp
 544:	ff 75 f4             	pushl  -0xc(%ebp)
 547:	e8 c2 00 00 00       	call   60e <close>
 54c:	83 c4 10             	add    $0x10,%esp
  return r;
 54f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 552:	c9                   	leave  
 553:	c3                   	ret    

00000554 <atoi>:

int
atoi(const char *s)
{
 554:	55                   	push   %ebp
 555:	89 e5                	mov    %esp,%ebp
 557:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 55a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 561:	eb 25                	jmp    588 <atoi+0x34>
    n = n*10 + *s++ - '0';
 563:	8b 55 fc             	mov    -0x4(%ebp),%edx
 566:	89 d0                	mov    %edx,%eax
 568:	c1 e0 02             	shl    $0x2,%eax
 56b:	01 d0                	add    %edx,%eax
 56d:	01 c0                	add    %eax,%eax
 56f:	89 c1                	mov    %eax,%ecx
 571:	8b 45 08             	mov    0x8(%ebp),%eax
 574:	8d 50 01             	lea    0x1(%eax),%edx
 577:	89 55 08             	mov    %edx,0x8(%ebp)
 57a:	0f b6 00             	movzbl (%eax),%eax
 57d:	0f be c0             	movsbl %al,%eax
 580:	01 c8                	add    %ecx,%eax
 582:	83 e8 30             	sub    $0x30,%eax
 585:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 588:	8b 45 08             	mov    0x8(%ebp),%eax
 58b:	0f b6 00             	movzbl (%eax),%eax
 58e:	3c 2f                	cmp    $0x2f,%al
 590:	7e 0a                	jle    59c <atoi+0x48>
 592:	8b 45 08             	mov    0x8(%ebp),%eax
 595:	0f b6 00             	movzbl (%eax),%eax
 598:	3c 39                	cmp    $0x39,%al
 59a:	7e c7                	jle    563 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 59c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 59f:	c9                   	leave  
 5a0:	c3                   	ret    

000005a1 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 5a1:	55                   	push   %ebp
 5a2:	89 e5                	mov    %esp,%ebp
 5a4:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 5a7:	8b 45 08             	mov    0x8(%ebp),%eax
 5aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 5ad:	8b 45 0c             	mov    0xc(%ebp),%eax
 5b0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 5b3:	eb 17                	jmp    5cc <memmove+0x2b>
    *dst++ = *src++;
 5b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5b8:	8d 50 01             	lea    0x1(%eax),%edx
 5bb:	89 55 fc             	mov    %edx,-0x4(%ebp)
 5be:	8b 55 f8             	mov    -0x8(%ebp),%edx
 5c1:	8d 4a 01             	lea    0x1(%edx),%ecx
 5c4:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 5c7:	0f b6 12             	movzbl (%edx),%edx
 5ca:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5cc:	8b 45 10             	mov    0x10(%ebp),%eax
 5cf:	8d 50 ff             	lea    -0x1(%eax),%edx
 5d2:	89 55 10             	mov    %edx,0x10(%ebp)
 5d5:	85 c0                	test   %eax,%eax
 5d7:	7f dc                	jg     5b5 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 5d9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5dc:	c9                   	leave  
 5dd:	c3                   	ret    

000005de <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5de:	b8 01 00 00 00       	mov    $0x1,%eax
 5e3:	cd 40                	int    $0x40
 5e5:	c3                   	ret    

000005e6 <exit>:
SYSCALL(exit)
 5e6:	b8 02 00 00 00       	mov    $0x2,%eax
 5eb:	cd 40                	int    $0x40
 5ed:	c3                   	ret    

000005ee <wait>:
SYSCALL(wait)
 5ee:	b8 03 00 00 00       	mov    $0x3,%eax
 5f3:	cd 40                	int    $0x40
 5f5:	c3                   	ret    

000005f6 <pipe>:
SYSCALL(pipe)
 5f6:	b8 04 00 00 00       	mov    $0x4,%eax
 5fb:	cd 40                	int    $0x40
 5fd:	c3                   	ret    

000005fe <read>:
SYSCALL(read)
 5fe:	b8 05 00 00 00       	mov    $0x5,%eax
 603:	cd 40                	int    $0x40
 605:	c3                   	ret    

00000606 <write>:
SYSCALL(write)
 606:	b8 10 00 00 00       	mov    $0x10,%eax
 60b:	cd 40                	int    $0x40
 60d:	c3                   	ret    

0000060e <close>:
SYSCALL(close)
 60e:	b8 15 00 00 00       	mov    $0x15,%eax
 613:	cd 40                	int    $0x40
 615:	c3                   	ret    

00000616 <kill>:
SYSCALL(kill)
 616:	b8 06 00 00 00       	mov    $0x6,%eax
 61b:	cd 40                	int    $0x40
 61d:	c3                   	ret    

0000061e <exec>:
SYSCALL(exec)
 61e:	b8 07 00 00 00       	mov    $0x7,%eax
 623:	cd 40                	int    $0x40
 625:	c3                   	ret    

00000626 <open>:
SYSCALL(open)
 626:	b8 0f 00 00 00       	mov    $0xf,%eax
 62b:	cd 40                	int    $0x40
 62d:	c3                   	ret    

0000062e <mknod>:
SYSCALL(mknod)
 62e:	b8 11 00 00 00       	mov    $0x11,%eax
 633:	cd 40                	int    $0x40
 635:	c3                   	ret    

00000636 <unlink>:
SYSCALL(unlink)
 636:	b8 12 00 00 00       	mov    $0x12,%eax
 63b:	cd 40                	int    $0x40
 63d:	c3                   	ret    

0000063e <fstat>:
SYSCALL(fstat)
 63e:	b8 08 00 00 00       	mov    $0x8,%eax
 643:	cd 40                	int    $0x40
 645:	c3                   	ret    

00000646 <link>:
SYSCALL(link)
 646:	b8 13 00 00 00       	mov    $0x13,%eax
 64b:	cd 40                	int    $0x40
 64d:	c3                   	ret    

0000064e <mkdir>:
SYSCALL(mkdir)
 64e:	b8 14 00 00 00       	mov    $0x14,%eax
 653:	cd 40                	int    $0x40
 655:	c3                   	ret    

00000656 <chdir>:
SYSCALL(chdir)
 656:	b8 09 00 00 00       	mov    $0x9,%eax
 65b:	cd 40                	int    $0x40
 65d:	c3                   	ret    

0000065e <dup>:
SYSCALL(dup)
 65e:	b8 0a 00 00 00       	mov    $0xa,%eax
 663:	cd 40                	int    $0x40
 665:	c3                   	ret    

00000666 <getpid>:
SYSCALL(getpid)
 666:	b8 0b 00 00 00       	mov    $0xb,%eax
 66b:	cd 40                	int    $0x40
 66d:	c3                   	ret    

0000066e <sbrk>:
SYSCALL(sbrk)
 66e:	b8 0c 00 00 00       	mov    $0xc,%eax
 673:	cd 40                	int    $0x40
 675:	c3                   	ret    

00000676 <sleep>:
SYSCALL(sleep)
 676:	b8 0d 00 00 00       	mov    $0xd,%eax
 67b:	cd 40                	int    $0x40
 67d:	c3                   	ret    

0000067e <uptime>:
SYSCALL(uptime)
 67e:	b8 0e 00 00 00       	mov    $0xe,%eax
 683:	cd 40                	int    $0x40
 685:	c3                   	ret    

00000686 <mkfifo>:
SYSCALL(mkfifo)
 686:	b8 16 00 00 00       	mov    $0x16,%eax
 68b:	cd 40                	int    $0x40
 68d:	c3                   	ret    

0000068e <up>:
SYSCALL(up)
 68e:	b8 18 00 00 00       	mov    $0x18,%eax
 693:	cd 40                	int    $0x40
 695:	c3                   	ret    

00000696 <down>:
SYSCALL(down)
 696:	b8 17 00 00 00       	mov    $0x17,%eax
 69b:	cd 40                	int    $0x40
 69d:	c3                   	ret    

0000069e <setuid>:
 69e:	b8 19 00 00 00       	mov    $0x19,%eax
 6a3:	cd 40                	int    $0x40
 6a5:	c3                   	ret    

000006a6 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 6a6:	55                   	push   %ebp
 6a7:	89 e5                	mov    %esp,%ebp
 6a9:	83 ec 18             	sub    $0x18,%esp
 6ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 6af:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 6b2:	83 ec 04             	sub    $0x4,%esp
 6b5:	6a 01                	push   $0x1
 6b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
 6ba:	50                   	push   %eax
 6bb:	ff 75 08             	pushl  0x8(%ebp)
 6be:	e8 43 ff ff ff       	call   606 <write>
 6c3:	83 c4 10             	add    $0x10,%esp
}
 6c6:	90                   	nop
 6c7:	c9                   	leave  
 6c8:	c3                   	ret    

000006c9 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6c9:	55                   	push   %ebp
 6ca:	89 e5                	mov    %esp,%ebp
 6cc:	53                   	push   %ebx
 6cd:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6d0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6d7:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6db:	74 17                	je     6f4 <printint+0x2b>
 6dd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6e1:	79 11                	jns    6f4 <printint+0x2b>
    neg = 1;
 6e3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 6ed:	f7 d8                	neg    %eax
 6ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6f2:	eb 06                	jmp    6fa <printint+0x31>
  } else {
    x = xx;
 6f4:	8b 45 0c             	mov    0xc(%ebp),%eax
 6f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 701:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 704:	8d 41 01             	lea    0x1(%ecx),%eax
 707:	89 45 f4             	mov    %eax,-0xc(%ebp)
 70a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 70d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 710:	ba 00 00 00 00       	mov    $0x0,%edx
 715:	f7 f3                	div    %ebx
 717:	89 d0                	mov    %edx,%eax
 719:	0f b6 80 24 0e 00 00 	movzbl 0xe24(%eax),%eax
 720:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 724:	8b 5d 10             	mov    0x10(%ebp),%ebx
 727:	8b 45 ec             	mov    -0x14(%ebp),%eax
 72a:	ba 00 00 00 00       	mov    $0x0,%edx
 72f:	f7 f3                	div    %ebx
 731:	89 45 ec             	mov    %eax,-0x14(%ebp)
 734:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 738:	75 c7                	jne    701 <printint+0x38>
  if(neg)
 73a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 73e:	74 2d                	je     76d <printint+0xa4>
    buf[i++] = '-';
 740:	8b 45 f4             	mov    -0xc(%ebp),%eax
 743:	8d 50 01             	lea    0x1(%eax),%edx
 746:	89 55 f4             	mov    %edx,-0xc(%ebp)
 749:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 74e:	eb 1d                	jmp    76d <printint+0xa4>
    putc(fd, buf[i]);
 750:	8d 55 dc             	lea    -0x24(%ebp),%edx
 753:	8b 45 f4             	mov    -0xc(%ebp),%eax
 756:	01 d0                	add    %edx,%eax
 758:	0f b6 00             	movzbl (%eax),%eax
 75b:	0f be c0             	movsbl %al,%eax
 75e:	83 ec 08             	sub    $0x8,%esp
 761:	50                   	push   %eax
 762:	ff 75 08             	pushl  0x8(%ebp)
 765:	e8 3c ff ff ff       	call   6a6 <putc>
 76a:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 76d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 771:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 775:	79 d9                	jns    750 <printint+0x87>
    putc(fd, buf[i]);
}
 777:	90                   	nop
 778:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 77b:	c9                   	leave  
 77c:	c3                   	ret    

0000077d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 77d:	55                   	push   %ebp
 77e:	89 e5                	mov    %esp,%ebp
 780:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 783:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 78a:	8d 45 0c             	lea    0xc(%ebp),%eax
 78d:	83 c0 04             	add    $0x4,%eax
 790:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 793:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 79a:	e9 59 01 00 00       	jmp    8f8 <printf+0x17b>
    c = fmt[i] & 0xff;
 79f:	8b 55 0c             	mov    0xc(%ebp),%edx
 7a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a5:	01 d0                	add    %edx,%eax
 7a7:	0f b6 00             	movzbl (%eax),%eax
 7aa:	0f be c0             	movsbl %al,%eax
 7ad:	25 ff 00 00 00       	and    $0xff,%eax
 7b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 7b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7b9:	75 2c                	jne    7e7 <printf+0x6a>
      if(c == '%'){
 7bb:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7bf:	75 0c                	jne    7cd <printf+0x50>
        state = '%';
 7c1:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7c8:	e9 27 01 00 00       	jmp    8f4 <printf+0x177>
      } else {
        putc(fd, c);
 7cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7d0:	0f be c0             	movsbl %al,%eax
 7d3:	83 ec 08             	sub    $0x8,%esp
 7d6:	50                   	push   %eax
 7d7:	ff 75 08             	pushl  0x8(%ebp)
 7da:	e8 c7 fe ff ff       	call   6a6 <putc>
 7df:	83 c4 10             	add    $0x10,%esp
 7e2:	e9 0d 01 00 00       	jmp    8f4 <printf+0x177>
      }
    } else if(state == '%'){
 7e7:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7eb:	0f 85 03 01 00 00    	jne    8f4 <printf+0x177>
      if(c == 'd'){
 7f1:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7f5:	75 1e                	jne    815 <printf+0x98>
        printint(fd, *ap, 10, 1);
 7f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7fa:	8b 00                	mov    (%eax),%eax
 7fc:	6a 01                	push   $0x1
 7fe:	6a 0a                	push   $0xa
 800:	50                   	push   %eax
 801:	ff 75 08             	pushl  0x8(%ebp)
 804:	e8 c0 fe ff ff       	call   6c9 <printint>
 809:	83 c4 10             	add    $0x10,%esp
        ap++;
 80c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 810:	e9 d8 00 00 00       	jmp    8ed <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 815:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 819:	74 06                	je     821 <printf+0xa4>
 81b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 81f:	75 1e                	jne    83f <printf+0xc2>
        printint(fd, *ap, 16, 0);
 821:	8b 45 e8             	mov    -0x18(%ebp),%eax
 824:	8b 00                	mov    (%eax),%eax
 826:	6a 00                	push   $0x0
 828:	6a 10                	push   $0x10
 82a:	50                   	push   %eax
 82b:	ff 75 08             	pushl  0x8(%ebp)
 82e:	e8 96 fe ff ff       	call   6c9 <printint>
 833:	83 c4 10             	add    $0x10,%esp
        ap++;
 836:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 83a:	e9 ae 00 00 00       	jmp    8ed <printf+0x170>
      } else if(c == 's'){
 83f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 843:	75 43                	jne    888 <printf+0x10b>
        s = (char*)*ap;
 845:	8b 45 e8             	mov    -0x18(%ebp),%eax
 848:	8b 00                	mov    (%eax),%eax
 84a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 84d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 851:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 855:	75 25                	jne    87c <printf+0xff>
          s = "(null)";
 857:	c7 45 f4 7d 0b 00 00 	movl   $0xb7d,-0xc(%ebp)
        while(*s != 0){
 85e:	eb 1c                	jmp    87c <printf+0xff>
          putc(fd, *s);
 860:	8b 45 f4             	mov    -0xc(%ebp),%eax
 863:	0f b6 00             	movzbl (%eax),%eax
 866:	0f be c0             	movsbl %al,%eax
 869:	83 ec 08             	sub    $0x8,%esp
 86c:	50                   	push   %eax
 86d:	ff 75 08             	pushl  0x8(%ebp)
 870:	e8 31 fe ff ff       	call   6a6 <putc>
 875:	83 c4 10             	add    $0x10,%esp
          s++;
 878:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 87c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87f:	0f b6 00             	movzbl (%eax),%eax
 882:	84 c0                	test   %al,%al
 884:	75 da                	jne    860 <printf+0xe3>
 886:	eb 65                	jmp    8ed <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 888:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 88c:	75 1d                	jne    8ab <printf+0x12e>
        putc(fd, *ap);
 88e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 891:	8b 00                	mov    (%eax),%eax
 893:	0f be c0             	movsbl %al,%eax
 896:	83 ec 08             	sub    $0x8,%esp
 899:	50                   	push   %eax
 89a:	ff 75 08             	pushl  0x8(%ebp)
 89d:	e8 04 fe ff ff       	call   6a6 <putc>
 8a2:	83 c4 10             	add    $0x10,%esp
        ap++;
 8a5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8a9:	eb 42                	jmp    8ed <printf+0x170>
      } else if(c == '%'){
 8ab:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8af:	75 17                	jne    8c8 <printf+0x14b>
        putc(fd, c);
 8b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8b4:	0f be c0             	movsbl %al,%eax
 8b7:	83 ec 08             	sub    $0x8,%esp
 8ba:	50                   	push   %eax
 8bb:	ff 75 08             	pushl  0x8(%ebp)
 8be:	e8 e3 fd ff ff       	call   6a6 <putc>
 8c3:	83 c4 10             	add    $0x10,%esp
 8c6:	eb 25                	jmp    8ed <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8c8:	83 ec 08             	sub    $0x8,%esp
 8cb:	6a 25                	push   $0x25
 8cd:	ff 75 08             	pushl  0x8(%ebp)
 8d0:	e8 d1 fd ff ff       	call   6a6 <putc>
 8d5:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 8d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8db:	0f be c0             	movsbl %al,%eax
 8de:	83 ec 08             	sub    $0x8,%esp
 8e1:	50                   	push   %eax
 8e2:	ff 75 08             	pushl  0x8(%ebp)
 8e5:	e8 bc fd ff ff       	call   6a6 <putc>
 8ea:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 8ed:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8f4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8f8:	8b 55 0c             	mov    0xc(%ebp),%edx
 8fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8fe:	01 d0                	add    %edx,%eax
 900:	0f b6 00             	movzbl (%eax),%eax
 903:	84 c0                	test   %al,%al
 905:	0f 85 94 fe ff ff    	jne    79f <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 90b:	90                   	nop
 90c:	c9                   	leave  
 90d:	c3                   	ret    

0000090e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 90e:	55                   	push   %ebp
 90f:	89 e5                	mov    %esp,%ebp
 911:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 914:	8b 45 08             	mov    0x8(%ebp),%eax
 917:	83 e8 08             	sub    $0x8,%eax
 91a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 91d:	a1 50 0e 00 00       	mov    0xe50,%eax
 922:	89 45 fc             	mov    %eax,-0x4(%ebp)
 925:	eb 24                	jmp    94b <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 927:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92a:	8b 00                	mov    (%eax),%eax
 92c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 92f:	77 12                	ja     943 <free+0x35>
 931:	8b 45 f8             	mov    -0x8(%ebp),%eax
 934:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 937:	77 24                	ja     95d <free+0x4f>
 939:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93c:	8b 00                	mov    (%eax),%eax
 93e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 941:	77 1a                	ja     95d <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 943:	8b 45 fc             	mov    -0x4(%ebp),%eax
 946:	8b 00                	mov    (%eax),%eax
 948:	89 45 fc             	mov    %eax,-0x4(%ebp)
 94b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 94e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 951:	76 d4                	jbe    927 <free+0x19>
 953:	8b 45 fc             	mov    -0x4(%ebp),%eax
 956:	8b 00                	mov    (%eax),%eax
 958:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 95b:	76 ca                	jbe    927 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 95d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 960:	8b 40 04             	mov    0x4(%eax),%eax
 963:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 96a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 96d:	01 c2                	add    %eax,%edx
 96f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 972:	8b 00                	mov    (%eax),%eax
 974:	39 c2                	cmp    %eax,%edx
 976:	75 24                	jne    99c <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 978:	8b 45 f8             	mov    -0x8(%ebp),%eax
 97b:	8b 50 04             	mov    0x4(%eax),%edx
 97e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 981:	8b 00                	mov    (%eax),%eax
 983:	8b 40 04             	mov    0x4(%eax),%eax
 986:	01 c2                	add    %eax,%edx
 988:	8b 45 f8             	mov    -0x8(%ebp),%eax
 98b:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 98e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 991:	8b 00                	mov    (%eax),%eax
 993:	8b 10                	mov    (%eax),%edx
 995:	8b 45 f8             	mov    -0x8(%ebp),%eax
 998:	89 10                	mov    %edx,(%eax)
 99a:	eb 0a                	jmp    9a6 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 99c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99f:	8b 10                	mov    (%eax),%edx
 9a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a4:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 9a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a9:	8b 40 04             	mov    0x4(%eax),%eax
 9ac:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b6:	01 d0                	add    %edx,%eax
 9b8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9bb:	75 20                	jne    9dd <free+0xcf>
    p->s.size += bp->s.size;
 9bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c0:	8b 50 04             	mov    0x4(%eax),%edx
 9c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9c6:	8b 40 04             	mov    0x4(%eax),%eax
 9c9:	01 c2                	add    %eax,%edx
 9cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ce:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9d4:	8b 10                	mov    (%eax),%edx
 9d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d9:	89 10                	mov    %edx,(%eax)
 9db:	eb 08                	jmp    9e5 <free+0xd7>
  } else
    p->s.ptr = bp;
 9dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9e3:	89 10                	mov    %edx,(%eax)
  freep = p;
 9e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e8:	a3 50 0e 00 00       	mov    %eax,0xe50
}
 9ed:	90                   	nop
 9ee:	c9                   	leave  
 9ef:	c3                   	ret    

000009f0 <morecore>:

static Header*
morecore(uint nu)
{
 9f0:	55                   	push   %ebp
 9f1:	89 e5                	mov    %esp,%ebp
 9f3:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9f6:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9fd:	77 07                	ja     a06 <morecore+0x16>
    nu = 4096;
 9ff:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a06:	8b 45 08             	mov    0x8(%ebp),%eax
 a09:	c1 e0 03             	shl    $0x3,%eax
 a0c:	83 ec 0c             	sub    $0xc,%esp
 a0f:	50                   	push   %eax
 a10:	e8 59 fc ff ff       	call   66e <sbrk>
 a15:	83 c4 10             	add    $0x10,%esp
 a18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a1b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a1f:	75 07                	jne    a28 <morecore+0x38>
    return 0;
 a21:	b8 00 00 00 00       	mov    $0x0,%eax
 a26:	eb 26                	jmp    a4e <morecore+0x5e>
  hp = (Header*)p;
 a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a31:	8b 55 08             	mov    0x8(%ebp),%edx
 a34:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a3a:	83 c0 08             	add    $0x8,%eax
 a3d:	83 ec 0c             	sub    $0xc,%esp
 a40:	50                   	push   %eax
 a41:	e8 c8 fe ff ff       	call   90e <free>
 a46:	83 c4 10             	add    $0x10,%esp
  return freep;
 a49:	a1 50 0e 00 00       	mov    0xe50,%eax
}
 a4e:	c9                   	leave  
 a4f:	c3                   	ret    

00000a50 <malloc>:

void*
malloc(uint nbytes)
{
 a50:	55                   	push   %ebp
 a51:	89 e5                	mov    %esp,%ebp
 a53:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a56:	8b 45 08             	mov    0x8(%ebp),%eax
 a59:	83 c0 07             	add    $0x7,%eax
 a5c:	c1 e8 03             	shr    $0x3,%eax
 a5f:	83 c0 01             	add    $0x1,%eax
 a62:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a65:	a1 50 0e 00 00       	mov    0xe50,%eax
 a6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a6d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a71:	75 23                	jne    a96 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a73:	c7 45 f0 48 0e 00 00 	movl   $0xe48,-0x10(%ebp)
 a7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a7d:	a3 50 0e 00 00       	mov    %eax,0xe50
 a82:	a1 50 0e 00 00       	mov    0xe50,%eax
 a87:	a3 48 0e 00 00       	mov    %eax,0xe48
    base.s.size = 0;
 a8c:	c7 05 4c 0e 00 00 00 	movl   $0x0,0xe4c
 a93:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a96:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a99:	8b 00                	mov    (%eax),%eax
 a9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa1:	8b 40 04             	mov    0x4(%eax),%eax
 aa4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 aa7:	72 4d                	jb     af6 <malloc+0xa6>
      if(p->s.size == nunits)
 aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aac:	8b 40 04             	mov    0x4(%eax),%eax
 aaf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ab2:	75 0c                	jne    ac0 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab7:	8b 10                	mov    (%eax),%edx
 ab9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 abc:	89 10                	mov    %edx,(%eax)
 abe:	eb 26                	jmp    ae6 <malloc+0x96>
      else {
        p->s.size -= nunits;
 ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac3:	8b 40 04             	mov    0x4(%eax),%eax
 ac6:	2b 45 ec             	sub    -0x14(%ebp),%eax
 ac9:	89 c2                	mov    %eax,%edx
 acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ace:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad4:	8b 40 04             	mov    0x4(%eax),%eax
 ad7:	c1 e0 03             	shl    $0x3,%eax
 ada:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 add:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae0:	8b 55 ec             	mov    -0x14(%ebp),%edx
 ae3:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 ae6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ae9:	a3 50 0e 00 00       	mov    %eax,0xe50
      return (void*)(p + 1);
 aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af1:	83 c0 08             	add    $0x8,%eax
 af4:	eb 3b                	jmp    b31 <malloc+0xe1>
    }
    if(p == freep)
 af6:	a1 50 0e 00 00       	mov    0xe50,%eax
 afb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 afe:	75 1e                	jne    b1e <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 b00:	83 ec 0c             	sub    $0xc,%esp
 b03:	ff 75 ec             	pushl  -0x14(%ebp)
 b06:	e8 e5 fe ff ff       	call   9f0 <morecore>
 b0b:	83 c4 10             	add    $0x10,%esp
 b0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b15:	75 07                	jne    b1e <malloc+0xce>
        return 0;
 b17:	b8 00 00 00 00       	mov    $0x0,%eax
 b1c:	eb 13                	jmp    b31 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b21:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b27:	8b 00                	mov    (%eax),%eax
 b29:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b2c:	e9 6d ff ff ff       	jmp    a9e <malloc+0x4e>
}
 b31:	c9                   	leave  
 b32:	c3                   	ret    
