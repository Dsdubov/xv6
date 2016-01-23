
_useradd:     формат файла elf32-i386


Дизассемблирование раздела .text:

00000000 <finduid>:
#include "stat.h"
#include "user.h"
#include "fcntl.h"
#include "x86.h"

char * finduid(char * file) {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	83 ec 30             	sub    $0x30,%esp
   8:	89 e0                	mov    %esp,%eax
   a:	89 c6                	mov    %eax,%esi
	int LEN = 1000;
   c:	c7 45 e0 e8 03 00 00 	movl   $0x3e8,-0x20(%ebp)
	char lastuid[LEN];
  13:	8b 45 e0             	mov    -0x20(%ebp),%eax
  16:	8d 50 ff             	lea    -0x1(%eax),%edx
  19:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1c:	89 c2                	mov    %eax,%edx
  1e:	b8 10 00 00 00       	mov    $0x10,%eax
  23:	83 e8 01             	sub    $0x1,%eax
  26:	01 d0                	add    %edx,%eax
  28:	bb 10 00 00 00       	mov    $0x10,%ebx
  2d:	ba 00 00 00 00       	mov    $0x0,%edx
  32:	f7 f3                	div    %ebx
  34:	6b c0 10             	imul   $0x10,%eax,%eax
  37:	29 c4                	sub    %eax,%esp
  39:	89 e0                	mov    %esp,%eax
  3b:	83 c0 00             	add    $0x0,%eax
  3e:	89 45 d8             	mov    %eax,-0x28(%ebp)
	char res[LEN];
  41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  44:	8d 50 ff             	lea    -0x1(%eax),%edx
  47:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  4a:	89 c2                	mov    %eax,%edx
  4c:	b8 10 00 00 00       	mov    $0x10,%eax
  51:	83 e8 01             	sub    $0x1,%eax
  54:	01 d0                	add    %edx,%eax
  56:	bb 10 00 00 00       	mov    $0x10,%ebx
  5b:	ba 00 00 00 00       	mov    $0x0,%edx
  60:	f7 f3                	div    %ebx
  62:	6b c0 10             	imul   $0x10,%eax,%eax
  65:	29 c4                	sub    %eax,%esp
  67:	89 e0                	mov    %esp,%eax
  69:	83 c0 00             	add    $0x0,%eax
  6c:	89 45 d0             	mov    %eax,-0x30(%ebp)
	char * p = lastuid;
  6f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  72:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int counter = 0;
  75:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int i;
	for(i = 0; file[i]; ++i) {
  7c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  83:	eb 57                	jmp    dc <finduid+0xdc>
		if (file[i] == '\n') {
  85:	8b 55 ec             	mov    -0x14(%ebp),%edx
  88:	8b 45 08             	mov    0x8(%ebp),%eax
  8b:	01 d0                	add    %edx,%eax
  8d:	0f b6 00             	movzbl (%eax),%eax
  90:	3c 0a                	cmp    $0xa,%al
  92:	75 09                	jne    9d <finduid+0x9d>
			counter = 0;
  94:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			continue;
  9b:	eb 3b                	jmp    d8 <finduid+0xd8>
		}
		if (counter == 2)
  9d:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  a1:	75 16                	jne    b9 <finduid+0xb9>
			*p++=file[i];
  a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  a6:	8d 50 01             	lea    0x1(%eax),%edx
  a9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  ac:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  af:	8b 55 08             	mov    0x8(%ebp),%edx
  b2:	01 ca                	add    %ecx,%edx
  b4:	0f b6 12             	movzbl (%edx),%edx
  b7:	88 10                	mov    %dl,(%eax)
		if (file[i] == ':') {
  b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  bc:	8b 45 08             	mov    0x8(%ebp),%eax
  bf:	01 d0                	add    %edx,%eax
  c1:	0f b6 00             	movzbl (%eax),%eax
  c4:	3c 3a                	cmp    $0x3a,%al
  c6:	75 10                	jne    d8 <finduid+0xd8>
			++counter;
  c8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			if (counter == 2)
  cc:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  d0:	75 06                	jne    d8 <finduid+0xd8>
				p = lastuid;
  d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	char lastuid[LEN];
	char res[LEN];
	char * p = lastuid;
	int counter = 0;
	int i;
	for(i = 0; file[i]; ++i) {
  d8:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  df:	8b 45 08             	mov    0x8(%ebp),%eax
  e2:	01 d0                	add    %edx,%eax
  e4:	0f b6 00             	movzbl (%eax),%eax
  e7:	84 c0                	test   %al,%al
  e9:	75 9a                	jne    85 <finduid+0x85>
			++counter;
			if (counter == 2)
				p = lastuid;
		}
	}
	*p++ = '\0';
  eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  ee:	8d 50 01             	lea    0x1(%eax),%edx
  f1:	89 55 f4             	mov    %edx,-0xc(%ebp)
  f4:	c6 00 00             	movb   $0x0,(%eax)
	int uid = atoi(lastuid);
  f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  fa:	83 ec 0c             	sub    $0xc,%esp
  fd:	50                   	push   %eax
  fe:	e8 64 04 00 00       	call   567 <atoi>
 103:	83 c4 10             	add    $0x10,%esp
 106:	89 45 e8             	mov    %eax,-0x18(%ebp)
	++uid;
 109:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
	char * ptr = res;
 10d:	8b 45 d0             	mov    -0x30(%ebp),%eax
 110:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	while (uid) {
 113:	eb 4e                	jmp    163 <finduid+0x163>
    *ptr++ = '0' + uid % 10;
 115:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
 118:	8d 43 01             	lea    0x1(%ebx),%eax
 11b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 11e:	8b 4d e8             	mov    -0x18(%ebp),%ecx
 121:	ba 67 66 66 66       	mov    $0x66666667,%edx
 126:	89 c8                	mov    %ecx,%eax
 128:	f7 ea                	imul   %edx
 12a:	c1 fa 02             	sar    $0x2,%edx
 12d:	89 c8                	mov    %ecx,%eax
 12f:	c1 f8 1f             	sar    $0x1f,%eax
 132:	29 c2                	sub    %eax,%edx
 134:	89 d0                	mov    %edx,%eax
 136:	c1 e0 02             	shl    $0x2,%eax
 139:	01 d0                	add    %edx,%eax
 13b:	01 c0                	add    %eax,%eax
 13d:	29 c1                	sub    %eax,%ecx
 13f:	89 ca                	mov    %ecx,%edx
 141:	89 d0                	mov    %edx,%eax
 143:	83 c0 30             	add    $0x30,%eax
 146:	88 03                	mov    %al,(%ebx)
    uid /= 10;
 148:	8b 4d e8             	mov    -0x18(%ebp),%ecx
 14b:	ba 67 66 66 66       	mov    $0x66666667,%edx
 150:	89 c8                	mov    %ecx,%eax
 152:	f7 ea                	imul   %edx
 154:	c1 fa 02             	sar    $0x2,%edx
 157:	89 c8                	mov    %ecx,%eax
 159:	c1 f8 1f             	sar    $0x1f,%eax
 15c:	29 c2                	sub    %eax,%edx
 15e:	89 d0                	mov    %edx,%eax
 160:	89 45 e8             	mov    %eax,-0x18(%ebp)
	}
	*p++ = '\0';
	int uid = atoi(lastuid);
	++uid;
	char * ptr = res;
	while (uid) {
 163:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 167:	75 ac                	jne    115 <finduid+0x115>
    *ptr++ = '0' + uid % 10;
    uid /= 10;
  }
  ptr = res;
 169:	8b 45 d0             	mov    -0x30(%ebp),%eax
 16c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	return ptr;
 16f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 172:	89 f4                	mov    %esi,%esp
}
 174:	8d 65 f8             	lea    -0x8(%ebp),%esp
 177:	5b                   	pop    %ebx
 178:	5e                   	pop    %esi
 179:	5d                   	pop    %ebp
 17a:	c3                   	ret    

0000017b <useradd>:

int useradd(char *name) {
 17b:	55                   	push   %ebp
 17c:	89 e5                	mov    %esp,%ebp
 17e:	53                   	push   %ebx
 17f:	83 ec 34             	sub    $0x34,%esp
 182:	89 e0                	mov    %esp,%eax
 184:	89 c3                	mov    %eax,%ebx
	int LEN = 1000;
 186:	c7 45 e4 e8 03 00 00 	movl   $0x3e8,-0x1c(%ebp)
	int j;
	char string[LEN];
 18d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 190:	8d 50 ff             	lea    -0x1(%eax),%edx
 193:	89 55 e0             	mov    %edx,-0x20(%ebp)
 196:	89 c2                	mov    %eax,%edx
 198:	b8 10 00 00 00       	mov    $0x10,%eax
 19d:	83 e8 01             	sub    $0x1,%eax
 1a0:	01 d0                	add    %edx,%eax
 1a2:	b9 10 00 00 00       	mov    $0x10,%ecx
 1a7:	ba 00 00 00 00       	mov    $0x0,%edx
 1ac:	f7 f1                	div    %ecx
 1ae:	6b c0 10             	imul   $0x10,%eax,%eax
 1b1:	29 c4                	sub    %eax,%esp
 1b3:	89 e0                	mov    %esp,%eax
 1b5:	83 c0 00             	add    $0x0,%eax
 1b8:	89 45 dc             	mov    %eax,-0x24(%ebp)
	char buf[1];
	int fd = open("/pass", O_RDONLY);
 1bb:	83 ec 08             	sub    $0x8,%esp
 1be:	6a 00                	push   $0x0
 1c0:	68 48 0b 00 00       	push   $0xb48
 1c5:	e8 6f 04 00 00       	call   639 <open>
 1ca:	83 c4 10             	add    $0x10,%esp
 1cd:	89 45 d8             	mov    %eax,-0x28(%ebp)

  char * p = string;
 1d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
 1d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(j = 0; read(fd, buf, 1) == 1 && buf[0] != '\0'; ++j) {
 1d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1dd:	eb 13                	jmp    1f2 <useradd+0x77>
    *p++ = buf[0];
 1df:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1e2:	8d 50 01             	lea    0x1(%eax),%edx
 1e5:	89 55 f0             	mov    %edx,-0x10(%ebp)
 1e8:	0f b6 55 d3          	movzbl -0x2d(%ebp),%edx
 1ec:	88 10                	mov    %dl,(%eax)
	char string[LEN];
	char buf[1];
	int fd = open("/pass", O_RDONLY);

  char * p = string;
  for(j = 0; read(fd, buf, 1) == 1 && buf[0] != '\0'; ++j) {
 1ee:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1f2:	83 ec 04             	sub    $0x4,%esp
 1f5:	6a 01                	push   $0x1
 1f7:	8d 45 d3             	lea    -0x2d(%ebp),%eax
 1fa:	50                   	push   %eax
 1fb:	ff 75 d8             	pushl  -0x28(%ebp)
 1fe:	e8 0e 04 00 00       	call   611 <read>
 203:	83 c4 10             	add    $0x10,%esp
 206:	83 f8 01             	cmp    $0x1,%eax
 209:	75 08                	jne    213 <useradd+0x98>
 20b:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
 20f:	84 c0                	test   %al,%al
 211:	75 cc                	jne    1df <useradd+0x64>
    *p++ = buf[0];
  }
  *p = '\0';
 213:	8b 45 f0             	mov    -0x10(%ebp),%eax
 216:	c6 00 00             	movb   $0x0,(%eax)
  close(fd);
 219:	83 ec 0c             	sub    $0xc,%esp
 21c:	ff 75 d8             	pushl  -0x28(%ebp)
 21f:	e8 fd 03 00 00       	call   621 <close>
 224:	83 c4 10             	add    $0x10,%esp
  
  if(!fork()) {
 227:	e8 c5 03 00 00       	call   5f1 <fork>
 22c:	85 c0                	test   %eax,%eax
 22e:	75 27                	jne    257 <useradd+0xdc>
  	char *argv[] = {"rm", "/pass"};
 230:	c7 45 c8 4e 0b 00 00 	movl   $0xb4e,-0x38(%ebp)
 237:	c7 45 cc 48 0b 00 00 	movl   $0xb48,-0x34(%ebp)
  	exec("rm", argv);
 23e:	83 ec 08             	sub    $0x8,%esp
 241:	8d 45 c8             	lea    -0x38(%ebp),%eax
 244:	50                   	push   %eax
 245:	68 4e 0b 00 00       	push   $0xb4e
 24a:	e8 e2 03 00 00       	call   631 <exec>
 24f:	83 c4 10             	add    $0x10,%esp
  	exit();
 252:	e8 a2 03 00 00       	call   5f9 <exit>
  }
  wait();
 257:	e8 a5 03 00 00       	call   601 <wait>

  char * newuid = finduid(string);
 25c:	8b 45 dc             	mov    -0x24(%ebp),%eax
 25f:	83 ec 0c             	sub    $0xc,%esp
 262:	50                   	push   %eax
 263:	e8 98 fd ff ff       	call   0 <finduid>
 268:	83 c4 10             	add    $0x10,%esp
 26b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  char * ptr = name;
 26e:	8b 45 08             	mov    0x8(%ebp),%eax
 271:	89 45 ec             	mov    %eax,-0x14(%ebp)

  while(*ptr != '\0') {
 274:	eb 17                	jmp    28d <useradd+0x112>
  	*p++ = *ptr++;
 276:	8b 45 f0             	mov    -0x10(%ebp),%eax
 279:	8d 50 01             	lea    0x1(%eax),%edx
 27c:	89 55 f0             	mov    %edx,-0x10(%ebp)
 27f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 282:	8d 4a 01             	lea    0x1(%edx),%ecx
 285:	89 4d ec             	mov    %ecx,-0x14(%ebp)
 288:	0f b6 12             	movzbl (%edx),%edx
 28b:	88 10                	mov    %dl,(%eax)
  wait();

  char * newuid = finduid(string);
  char * ptr = name;

  while(*ptr != '\0') {
 28d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 290:	0f b6 00             	movzbl (%eax),%eax
 293:	84 c0                	test   %al,%al
 295:	75 df                	jne    276 <useradd+0xfb>
  	*p++ = *ptr++;
  }
  *p++ = ':';
 297:	8b 45 f0             	mov    -0x10(%ebp),%eax
 29a:	8d 50 01             	lea    0x1(%eax),%edx
 29d:	89 55 f0             	mov    %edx,-0x10(%ebp)
 2a0:	c6 00 3a             	movb   $0x3a,(%eax)
  *p++ = ':';
 2a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2a6:	8d 50 01             	lea    0x1(%eax),%edx
 2a9:	89 55 f0             	mov    %edx,-0x10(%ebp)
 2ac:	c6 00 3a             	movb   $0x3a,(%eax)
  int i;
  for(i = 0; newuid[i] != '\0'; ++i) {
 2af:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
 2b6:	eb 1a                	jmp    2d2 <useradd+0x157>
	  *p++ = newuid[i];
 2b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2bb:	8d 50 01             	lea    0x1(%eax),%edx
 2be:	89 55 f0             	mov    %edx,-0x10(%ebp)
 2c1:	8b 4d e8             	mov    -0x18(%ebp),%ecx
 2c4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 2c7:	01 ca                	add    %ecx,%edx
 2c9:	0f b6 12             	movzbl (%edx),%edx
 2cc:	88 10                	mov    %dl,(%eax)
  	*p++ = *ptr++;
  }
  *p++ = ':';
  *p++ = ':';
  int i;
  for(i = 0; newuid[i] != '\0'; ++i) {
 2ce:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
 2d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
 2d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 2d8:	01 d0                	add    %edx,%eax
 2da:	0f b6 00             	movzbl (%eax),%eax
 2dd:	84 c0                	test   %al,%al
 2df:	75 d7                	jne    2b8 <useradd+0x13d>
	  *p++ = newuid[i];
  }
  *p++ = '\n';
 2e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2e4:	8d 50 01             	lea    0x1(%eax),%edx
 2e7:	89 55 f0             	mov    %edx,-0x10(%ebp)
 2ea:	c6 00 0a             	movb   $0xa,(%eax)
  *p++ = '\0';
 2ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2f0:	8d 50 01             	lea    0x1(%eax),%edx
 2f3:	89 55 f0             	mov    %edx,-0x10(%ebp)
 2f6:	c6 00 00             	movb   $0x0,(%eax)
  fd = open("/pass", O_WRONLY | O_CREATE);
 2f9:	83 ec 08             	sub    $0x8,%esp
 2fc:	68 01 02 00 00       	push   $0x201
 301:	68 48 0b 00 00       	push   $0xb48
 306:	e8 2e 03 00 00       	call   639 <open>
 30b:	83 c4 10             	add    $0x10,%esp
 30e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  write(fd, string, strlen(string) + 1);
 311:	8b 45 dc             	mov    -0x24(%ebp),%eax
 314:	83 ec 0c             	sub    $0xc,%esp
 317:	50                   	push   %eax
 318:	e8 1a 01 00 00       	call   437 <strlen>
 31d:	83 c4 10             	add    $0x10,%esp
 320:	83 c0 01             	add    $0x1,%eax
 323:	89 c2                	mov    %eax,%edx
 325:	8b 45 dc             	mov    -0x24(%ebp),%eax
 328:	83 ec 04             	sub    $0x4,%esp
 32b:	52                   	push   %edx
 32c:	50                   	push   %eax
 32d:	ff 75 d8             	pushl  -0x28(%ebp)
 330:	e8 e4 02 00 00       	call   619 <write>
 335:	83 c4 10             	add    $0x10,%esp
  return 0;
 338:	b8 00 00 00 00       	mov    $0x0,%eax
 33d:	89 dc                	mov    %ebx,%esp
}
 33f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 342:	c9                   	leave  
 343:	c3                   	ret    

00000344 <main>:

int
main(int argc, char *argv[])
{
 344:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 348:	83 e4 f0             	and    $0xfffffff0,%esp
 34b:	ff 71 fc             	pushl  -0x4(%ecx)
 34e:	55                   	push   %ebp
 34f:	89 e5                	mov    %esp,%ebp
 351:	51                   	push   %ecx
 352:	83 ec 04             	sub    $0x4,%esp
 355:	89 c8                	mov    %ecx,%eax
  if(argc < 2){
 357:	83 38 01             	cmpl   $0x1,(%eax)
 35a:	7f 17                	jg     373 <main+0x2f>
    printf(2, "Usage: useradd files...\n");
 35c:	83 ec 08             	sub    $0x8,%esp
 35f:	68 51 0b 00 00       	push   $0xb51
 364:	6a 02                	push   $0x2
 366:	e8 25 04 00 00       	call   790 <printf>
 36b:	83 c4 10             	add    $0x10,%esp
    exit();
 36e:	e8 86 02 00 00       	call   5f9 <exit>
  }

	if(useradd(argv[1]) < 0){
 373:	8b 40 04             	mov    0x4(%eax),%eax
 376:	83 c0 04             	add    $0x4,%eax
 379:	8b 00                	mov    (%eax),%eax
 37b:	83 ec 0c             	sub    $0xc,%esp
 37e:	50                   	push   %eax
 37f:	e8 f7 fd ff ff       	call   17b <useradd>
 384:	83 c4 10             	add    $0x10,%esp
 387:	85 c0                	test   %eax,%eax
 389:	79 12                	jns    39d <main+0x59>
	  printf(2, "useradd: %s failed to add user\n");
 38b:	83 ec 08             	sub    $0x8,%esp
 38e:	68 6c 0b 00 00       	push   $0xb6c
 393:	6a 02                	push   $0x2
 395:	e8 f6 03 00 00       	call   790 <printf>
 39a:	83 c4 10             	add    $0x10,%esp
	}

  exit();
 39d:	e8 57 02 00 00       	call   5f9 <exit>

000003a2 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 3a2:	55                   	push   %ebp
 3a3:	89 e5                	mov    %esp,%ebp
 3a5:	57                   	push   %edi
 3a6:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 3a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3aa:	8b 55 10             	mov    0x10(%ebp),%edx
 3ad:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b0:	89 cb                	mov    %ecx,%ebx
 3b2:	89 df                	mov    %ebx,%edi
 3b4:	89 d1                	mov    %edx,%ecx
 3b6:	fc                   	cld    
 3b7:	f3 aa                	rep stos %al,%es:(%edi)
 3b9:	89 ca                	mov    %ecx,%edx
 3bb:	89 fb                	mov    %edi,%ebx
 3bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
 3c0:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 3c3:	90                   	nop
 3c4:	5b                   	pop    %ebx
 3c5:	5f                   	pop    %edi
 3c6:	5d                   	pop    %ebp
 3c7:	c3                   	ret    

000003c8 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 3c8:	55                   	push   %ebp
 3c9:	89 e5                	mov    %esp,%ebp
 3cb:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 3ce:	8b 45 08             	mov    0x8(%ebp),%eax
 3d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 3d4:	90                   	nop
 3d5:	8b 45 08             	mov    0x8(%ebp),%eax
 3d8:	8d 50 01             	lea    0x1(%eax),%edx
 3db:	89 55 08             	mov    %edx,0x8(%ebp)
 3de:	8b 55 0c             	mov    0xc(%ebp),%edx
 3e1:	8d 4a 01             	lea    0x1(%edx),%ecx
 3e4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 3e7:	0f b6 12             	movzbl (%edx),%edx
 3ea:	88 10                	mov    %dl,(%eax)
 3ec:	0f b6 00             	movzbl (%eax),%eax
 3ef:	84 c0                	test   %al,%al
 3f1:	75 e2                	jne    3d5 <strcpy+0xd>
    ;
  return os;
 3f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3f6:	c9                   	leave  
 3f7:	c3                   	ret    

000003f8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3f8:	55                   	push   %ebp
 3f9:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3fb:	eb 08                	jmp    405 <strcmp+0xd>
    p++, q++;
 3fd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 401:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 405:	8b 45 08             	mov    0x8(%ebp),%eax
 408:	0f b6 00             	movzbl (%eax),%eax
 40b:	84 c0                	test   %al,%al
 40d:	74 10                	je     41f <strcmp+0x27>
 40f:	8b 45 08             	mov    0x8(%ebp),%eax
 412:	0f b6 10             	movzbl (%eax),%edx
 415:	8b 45 0c             	mov    0xc(%ebp),%eax
 418:	0f b6 00             	movzbl (%eax),%eax
 41b:	38 c2                	cmp    %al,%dl
 41d:	74 de                	je     3fd <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 41f:	8b 45 08             	mov    0x8(%ebp),%eax
 422:	0f b6 00             	movzbl (%eax),%eax
 425:	0f b6 d0             	movzbl %al,%edx
 428:	8b 45 0c             	mov    0xc(%ebp),%eax
 42b:	0f b6 00             	movzbl (%eax),%eax
 42e:	0f b6 c0             	movzbl %al,%eax
 431:	29 c2                	sub    %eax,%edx
 433:	89 d0                	mov    %edx,%eax
}
 435:	5d                   	pop    %ebp
 436:	c3                   	ret    

00000437 <strlen>:

uint
strlen(char *s)
{
 437:	55                   	push   %ebp
 438:	89 e5                	mov    %esp,%ebp
 43a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 43d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 444:	eb 04                	jmp    44a <strlen+0x13>
 446:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 44a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 44d:	8b 45 08             	mov    0x8(%ebp),%eax
 450:	01 d0                	add    %edx,%eax
 452:	0f b6 00             	movzbl (%eax),%eax
 455:	84 c0                	test   %al,%al
 457:	75 ed                	jne    446 <strlen+0xf>
    ;
  return n;
 459:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 45c:	c9                   	leave  
 45d:	c3                   	ret    

0000045e <memset>:

void*
memset(void *dst, int c, uint n)
{
 45e:	55                   	push   %ebp
 45f:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 461:	8b 45 10             	mov    0x10(%ebp),%eax
 464:	50                   	push   %eax
 465:	ff 75 0c             	pushl  0xc(%ebp)
 468:	ff 75 08             	pushl  0x8(%ebp)
 46b:	e8 32 ff ff ff       	call   3a2 <stosb>
 470:	83 c4 0c             	add    $0xc,%esp
  return dst;
 473:	8b 45 08             	mov    0x8(%ebp),%eax
}
 476:	c9                   	leave  
 477:	c3                   	ret    

00000478 <strchr>:

char*
strchr(const char *s, char c)
{
 478:	55                   	push   %ebp
 479:	89 e5                	mov    %esp,%ebp
 47b:	83 ec 04             	sub    $0x4,%esp
 47e:	8b 45 0c             	mov    0xc(%ebp),%eax
 481:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 484:	eb 14                	jmp    49a <strchr+0x22>
    if(*s == c)
 486:	8b 45 08             	mov    0x8(%ebp),%eax
 489:	0f b6 00             	movzbl (%eax),%eax
 48c:	3a 45 fc             	cmp    -0x4(%ebp),%al
 48f:	75 05                	jne    496 <strchr+0x1e>
      return (char*)s;
 491:	8b 45 08             	mov    0x8(%ebp),%eax
 494:	eb 13                	jmp    4a9 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 496:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 49a:	8b 45 08             	mov    0x8(%ebp),%eax
 49d:	0f b6 00             	movzbl (%eax),%eax
 4a0:	84 c0                	test   %al,%al
 4a2:	75 e2                	jne    486 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 4a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
 4a9:	c9                   	leave  
 4aa:	c3                   	ret    

000004ab <gets>:

char*
gets(char *buf, int max)
{
 4ab:	55                   	push   %ebp
 4ac:	89 e5                	mov    %esp,%ebp
 4ae:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 4b8:	eb 42                	jmp    4fc <gets+0x51>
    cc = read(0, &c, 1);
 4ba:	83 ec 04             	sub    $0x4,%esp
 4bd:	6a 01                	push   $0x1
 4bf:	8d 45 ef             	lea    -0x11(%ebp),%eax
 4c2:	50                   	push   %eax
 4c3:	6a 00                	push   $0x0
 4c5:	e8 47 01 00 00       	call   611 <read>
 4ca:	83 c4 10             	add    $0x10,%esp
 4cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 4d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4d4:	7e 33                	jle    509 <gets+0x5e>
      break;
    buf[i++] = c;
 4d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d9:	8d 50 01             	lea    0x1(%eax),%edx
 4dc:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4df:	89 c2                	mov    %eax,%edx
 4e1:	8b 45 08             	mov    0x8(%ebp),%eax
 4e4:	01 c2                	add    %eax,%edx
 4e6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4ea:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 4ec:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4f0:	3c 0a                	cmp    $0xa,%al
 4f2:	74 16                	je     50a <gets+0x5f>
 4f4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4f8:	3c 0d                	cmp    $0xd,%al
 4fa:	74 0e                	je     50a <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ff:	83 c0 01             	add    $0x1,%eax
 502:	3b 45 0c             	cmp    0xc(%ebp),%eax
 505:	7c b3                	jl     4ba <gets+0xf>
 507:	eb 01                	jmp    50a <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 509:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 50a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 50d:	8b 45 08             	mov    0x8(%ebp),%eax
 510:	01 d0                	add    %edx,%eax
 512:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 515:	8b 45 08             	mov    0x8(%ebp),%eax
}
 518:	c9                   	leave  
 519:	c3                   	ret    

0000051a <stat>:

int
stat(char *n, struct stat *st)
{
 51a:	55                   	push   %ebp
 51b:	89 e5                	mov    %esp,%ebp
 51d:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY | O_NBLOCK);
 520:	83 ec 08             	sub    $0x8,%esp
 523:	6a 10                	push   $0x10
 525:	ff 75 08             	pushl  0x8(%ebp)
 528:	e8 0c 01 00 00       	call   639 <open>
 52d:	83 c4 10             	add    $0x10,%esp
 530:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 533:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 537:	79 07                	jns    540 <stat+0x26>
    return -1;
 539:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 53e:	eb 25                	jmp    565 <stat+0x4b>
  r = fstat(fd, st);
 540:	83 ec 08             	sub    $0x8,%esp
 543:	ff 75 0c             	pushl  0xc(%ebp)
 546:	ff 75 f4             	pushl  -0xc(%ebp)
 549:	e8 03 01 00 00       	call   651 <fstat>
 54e:	83 c4 10             	add    $0x10,%esp
 551:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 554:	83 ec 0c             	sub    $0xc,%esp
 557:	ff 75 f4             	pushl  -0xc(%ebp)
 55a:	e8 c2 00 00 00       	call   621 <close>
 55f:	83 c4 10             	add    $0x10,%esp
  return r;
 562:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 565:	c9                   	leave  
 566:	c3                   	ret    

00000567 <atoi>:

int
atoi(const char *s)
{
 567:	55                   	push   %ebp
 568:	89 e5                	mov    %esp,%ebp
 56a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 56d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 574:	eb 25                	jmp    59b <atoi+0x34>
    n = n*10 + *s++ - '0';
 576:	8b 55 fc             	mov    -0x4(%ebp),%edx
 579:	89 d0                	mov    %edx,%eax
 57b:	c1 e0 02             	shl    $0x2,%eax
 57e:	01 d0                	add    %edx,%eax
 580:	01 c0                	add    %eax,%eax
 582:	89 c1                	mov    %eax,%ecx
 584:	8b 45 08             	mov    0x8(%ebp),%eax
 587:	8d 50 01             	lea    0x1(%eax),%edx
 58a:	89 55 08             	mov    %edx,0x8(%ebp)
 58d:	0f b6 00             	movzbl (%eax),%eax
 590:	0f be c0             	movsbl %al,%eax
 593:	01 c8                	add    %ecx,%eax
 595:	83 e8 30             	sub    $0x30,%eax
 598:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 59b:	8b 45 08             	mov    0x8(%ebp),%eax
 59e:	0f b6 00             	movzbl (%eax),%eax
 5a1:	3c 2f                	cmp    $0x2f,%al
 5a3:	7e 0a                	jle    5af <atoi+0x48>
 5a5:	8b 45 08             	mov    0x8(%ebp),%eax
 5a8:	0f b6 00             	movzbl (%eax),%eax
 5ab:	3c 39                	cmp    $0x39,%al
 5ad:	7e c7                	jle    576 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 5af:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 5b2:	c9                   	leave  
 5b3:	c3                   	ret    

000005b4 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 5b4:	55                   	push   %ebp
 5b5:	89 e5                	mov    %esp,%ebp
 5b7:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 5ba:	8b 45 08             	mov    0x8(%ebp),%eax
 5bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 5c0:	8b 45 0c             	mov    0xc(%ebp),%eax
 5c3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 5c6:	eb 17                	jmp    5df <memmove+0x2b>
    *dst++ = *src++;
 5c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5cb:	8d 50 01             	lea    0x1(%eax),%edx
 5ce:	89 55 fc             	mov    %edx,-0x4(%ebp)
 5d1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 5d4:	8d 4a 01             	lea    0x1(%edx),%ecx
 5d7:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 5da:	0f b6 12             	movzbl (%edx),%edx
 5dd:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5df:	8b 45 10             	mov    0x10(%ebp),%eax
 5e2:	8d 50 ff             	lea    -0x1(%eax),%edx
 5e5:	89 55 10             	mov    %edx,0x10(%ebp)
 5e8:	85 c0                	test   %eax,%eax
 5ea:	7f dc                	jg     5c8 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 5ec:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5ef:	c9                   	leave  
 5f0:	c3                   	ret    

000005f1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5f1:	b8 01 00 00 00       	mov    $0x1,%eax
 5f6:	cd 40                	int    $0x40
 5f8:	c3                   	ret    

000005f9 <exit>:
SYSCALL(exit)
 5f9:	b8 02 00 00 00       	mov    $0x2,%eax
 5fe:	cd 40                	int    $0x40
 600:	c3                   	ret    

00000601 <wait>:
SYSCALL(wait)
 601:	b8 03 00 00 00       	mov    $0x3,%eax
 606:	cd 40                	int    $0x40
 608:	c3                   	ret    

00000609 <pipe>:
SYSCALL(pipe)
 609:	b8 04 00 00 00       	mov    $0x4,%eax
 60e:	cd 40                	int    $0x40
 610:	c3                   	ret    

00000611 <read>:
SYSCALL(read)
 611:	b8 05 00 00 00       	mov    $0x5,%eax
 616:	cd 40                	int    $0x40
 618:	c3                   	ret    

00000619 <write>:
SYSCALL(write)
 619:	b8 10 00 00 00       	mov    $0x10,%eax
 61e:	cd 40                	int    $0x40
 620:	c3                   	ret    

00000621 <close>:
SYSCALL(close)
 621:	b8 15 00 00 00       	mov    $0x15,%eax
 626:	cd 40                	int    $0x40
 628:	c3                   	ret    

00000629 <kill>:
SYSCALL(kill)
 629:	b8 06 00 00 00       	mov    $0x6,%eax
 62e:	cd 40                	int    $0x40
 630:	c3                   	ret    

00000631 <exec>:
SYSCALL(exec)
 631:	b8 07 00 00 00       	mov    $0x7,%eax
 636:	cd 40                	int    $0x40
 638:	c3                   	ret    

00000639 <open>:
SYSCALL(open)
 639:	b8 0f 00 00 00       	mov    $0xf,%eax
 63e:	cd 40                	int    $0x40
 640:	c3                   	ret    

00000641 <mknod>:
SYSCALL(mknod)
 641:	b8 11 00 00 00       	mov    $0x11,%eax
 646:	cd 40                	int    $0x40
 648:	c3                   	ret    

00000649 <unlink>:
SYSCALL(unlink)
 649:	b8 12 00 00 00       	mov    $0x12,%eax
 64e:	cd 40                	int    $0x40
 650:	c3                   	ret    

00000651 <fstat>:
SYSCALL(fstat)
 651:	b8 08 00 00 00       	mov    $0x8,%eax
 656:	cd 40                	int    $0x40
 658:	c3                   	ret    

00000659 <link>:
SYSCALL(link)
 659:	b8 13 00 00 00       	mov    $0x13,%eax
 65e:	cd 40                	int    $0x40
 660:	c3                   	ret    

00000661 <mkdir>:
SYSCALL(mkdir)
 661:	b8 14 00 00 00       	mov    $0x14,%eax
 666:	cd 40                	int    $0x40
 668:	c3                   	ret    

00000669 <chdir>:
SYSCALL(chdir)
 669:	b8 09 00 00 00       	mov    $0x9,%eax
 66e:	cd 40                	int    $0x40
 670:	c3                   	ret    

00000671 <dup>:
SYSCALL(dup)
 671:	b8 0a 00 00 00       	mov    $0xa,%eax
 676:	cd 40                	int    $0x40
 678:	c3                   	ret    

00000679 <getpid>:
SYSCALL(getpid)
 679:	b8 0b 00 00 00       	mov    $0xb,%eax
 67e:	cd 40                	int    $0x40
 680:	c3                   	ret    

00000681 <sbrk>:
SYSCALL(sbrk)
 681:	b8 0c 00 00 00       	mov    $0xc,%eax
 686:	cd 40                	int    $0x40
 688:	c3                   	ret    

00000689 <sleep>:
SYSCALL(sleep)
 689:	b8 0d 00 00 00       	mov    $0xd,%eax
 68e:	cd 40                	int    $0x40
 690:	c3                   	ret    

00000691 <uptime>:
SYSCALL(uptime)
 691:	b8 0e 00 00 00       	mov    $0xe,%eax
 696:	cd 40                	int    $0x40
 698:	c3                   	ret    

00000699 <mkfifo>:
SYSCALL(mkfifo)
 699:	b8 16 00 00 00       	mov    $0x16,%eax
 69e:	cd 40                	int    $0x40
 6a0:	c3                   	ret    

000006a1 <up>:
SYSCALL(up)
 6a1:	b8 18 00 00 00       	mov    $0x18,%eax
 6a6:	cd 40                	int    $0x40
 6a8:	c3                   	ret    

000006a9 <down>:
SYSCALL(down)
 6a9:	b8 17 00 00 00       	mov    $0x17,%eax
 6ae:	cd 40                	int    $0x40
 6b0:	c3                   	ret    

000006b1 <setuid>:
 6b1:	b8 19 00 00 00       	mov    $0x19,%eax
 6b6:	cd 40                	int    $0x40
 6b8:	c3                   	ret    

000006b9 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 6b9:	55                   	push   %ebp
 6ba:	89 e5                	mov    %esp,%ebp
 6bc:	83 ec 18             	sub    $0x18,%esp
 6bf:	8b 45 0c             	mov    0xc(%ebp),%eax
 6c2:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 6c5:	83 ec 04             	sub    $0x4,%esp
 6c8:	6a 01                	push   $0x1
 6ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
 6cd:	50                   	push   %eax
 6ce:	ff 75 08             	pushl  0x8(%ebp)
 6d1:	e8 43 ff ff ff       	call   619 <write>
 6d6:	83 c4 10             	add    $0x10,%esp
}
 6d9:	90                   	nop
 6da:	c9                   	leave  
 6db:	c3                   	ret    

000006dc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6dc:	55                   	push   %ebp
 6dd:	89 e5                	mov    %esp,%ebp
 6df:	53                   	push   %ebx
 6e0:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6e3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6ea:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6ee:	74 17                	je     707 <printint+0x2b>
 6f0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6f4:	79 11                	jns    707 <printint+0x2b>
    neg = 1;
 6f6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6fd:	8b 45 0c             	mov    0xc(%ebp),%eax
 700:	f7 d8                	neg    %eax
 702:	89 45 ec             	mov    %eax,-0x14(%ebp)
 705:	eb 06                	jmp    70d <printint+0x31>
  } else {
    x = xx;
 707:	8b 45 0c             	mov    0xc(%ebp),%eax
 70a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 70d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 714:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 717:	8d 41 01             	lea    0x1(%ecx),%eax
 71a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 71d:	8b 5d 10             	mov    0x10(%ebp),%ebx
 720:	8b 45 ec             	mov    -0x14(%ebp),%eax
 723:	ba 00 00 00 00       	mov    $0x0,%edx
 728:	f7 f3                	div    %ebx
 72a:	89 d0                	mov    %edx,%eax
 72c:	0f b6 80 2c 0e 00 00 	movzbl 0xe2c(%eax),%eax
 733:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 737:	8b 5d 10             	mov    0x10(%ebp),%ebx
 73a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 73d:	ba 00 00 00 00       	mov    $0x0,%edx
 742:	f7 f3                	div    %ebx
 744:	89 45 ec             	mov    %eax,-0x14(%ebp)
 747:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 74b:	75 c7                	jne    714 <printint+0x38>
  if(neg)
 74d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 751:	74 2d                	je     780 <printint+0xa4>
    buf[i++] = '-';
 753:	8b 45 f4             	mov    -0xc(%ebp),%eax
 756:	8d 50 01             	lea    0x1(%eax),%edx
 759:	89 55 f4             	mov    %edx,-0xc(%ebp)
 75c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 761:	eb 1d                	jmp    780 <printint+0xa4>
    putc(fd, buf[i]);
 763:	8d 55 dc             	lea    -0x24(%ebp),%edx
 766:	8b 45 f4             	mov    -0xc(%ebp),%eax
 769:	01 d0                	add    %edx,%eax
 76b:	0f b6 00             	movzbl (%eax),%eax
 76e:	0f be c0             	movsbl %al,%eax
 771:	83 ec 08             	sub    $0x8,%esp
 774:	50                   	push   %eax
 775:	ff 75 08             	pushl  0x8(%ebp)
 778:	e8 3c ff ff ff       	call   6b9 <putc>
 77d:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 780:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 784:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 788:	79 d9                	jns    763 <printint+0x87>
    putc(fd, buf[i]);
}
 78a:	90                   	nop
 78b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 78e:	c9                   	leave  
 78f:	c3                   	ret    

00000790 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 790:	55                   	push   %ebp
 791:	89 e5                	mov    %esp,%ebp
 793:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 796:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 79d:	8d 45 0c             	lea    0xc(%ebp),%eax
 7a0:	83 c0 04             	add    $0x4,%eax
 7a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 7a6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 7ad:	e9 59 01 00 00       	jmp    90b <printf+0x17b>
    c = fmt[i] & 0xff;
 7b2:	8b 55 0c             	mov    0xc(%ebp),%edx
 7b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b8:	01 d0                	add    %edx,%eax
 7ba:	0f b6 00             	movzbl (%eax),%eax
 7bd:	0f be c0             	movsbl %al,%eax
 7c0:	25 ff 00 00 00       	and    $0xff,%eax
 7c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 7c8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7cc:	75 2c                	jne    7fa <printf+0x6a>
      if(c == '%'){
 7ce:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7d2:	75 0c                	jne    7e0 <printf+0x50>
        state = '%';
 7d4:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7db:	e9 27 01 00 00       	jmp    907 <printf+0x177>
      } else {
        putc(fd, c);
 7e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7e3:	0f be c0             	movsbl %al,%eax
 7e6:	83 ec 08             	sub    $0x8,%esp
 7e9:	50                   	push   %eax
 7ea:	ff 75 08             	pushl  0x8(%ebp)
 7ed:	e8 c7 fe ff ff       	call   6b9 <putc>
 7f2:	83 c4 10             	add    $0x10,%esp
 7f5:	e9 0d 01 00 00       	jmp    907 <printf+0x177>
      }
    } else if(state == '%'){
 7fa:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7fe:	0f 85 03 01 00 00    	jne    907 <printf+0x177>
      if(c == 'd'){
 804:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 808:	75 1e                	jne    828 <printf+0x98>
        printint(fd, *ap, 10, 1);
 80a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80d:	8b 00                	mov    (%eax),%eax
 80f:	6a 01                	push   $0x1
 811:	6a 0a                	push   $0xa
 813:	50                   	push   %eax
 814:	ff 75 08             	pushl  0x8(%ebp)
 817:	e8 c0 fe ff ff       	call   6dc <printint>
 81c:	83 c4 10             	add    $0x10,%esp
        ap++;
 81f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 823:	e9 d8 00 00 00       	jmp    900 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 828:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 82c:	74 06                	je     834 <printf+0xa4>
 82e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 832:	75 1e                	jne    852 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 834:	8b 45 e8             	mov    -0x18(%ebp),%eax
 837:	8b 00                	mov    (%eax),%eax
 839:	6a 00                	push   $0x0
 83b:	6a 10                	push   $0x10
 83d:	50                   	push   %eax
 83e:	ff 75 08             	pushl  0x8(%ebp)
 841:	e8 96 fe ff ff       	call   6dc <printint>
 846:	83 c4 10             	add    $0x10,%esp
        ap++;
 849:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 84d:	e9 ae 00 00 00       	jmp    900 <printf+0x170>
      } else if(c == 's'){
 852:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 856:	75 43                	jne    89b <printf+0x10b>
        s = (char*)*ap;
 858:	8b 45 e8             	mov    -0x18(%ebp),%eax
 85b:	8b 00                	mov    (%eax),%eax
 85d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 860:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 864:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 868:	75 25                	jne    88f <printf+0xff>
          s = "(null)";
 86a:	c7 45 f4 8c 0b 00 00 	movl   $0xb8c,-0xc(%ebp)
        while(*s != 0){
 871:	eb 1c                	jmp    88f <printf+0xff>
          putc(fd, *s);
 873:	8b 45 f4             	mov    -0xc(%ebp),%eax
 876:	0f b6 00             	movzbl (%eax),%eax
 879:	0f be c0             	movsbl %al,%eax
 87c:	83 ec 08             	sub    $0x8,%esp
 87f:	50                   	push   %eax
 880:	ff 75 08             	pushl  0x8(%ebp)
 883:	e8 31 fe ff ff       	call   6b9 <putc>
 888:	83 c4 10             	add    $0x10,%esp
          s++;
 88b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 88f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 892:	0f b6 00             	movzbl (%eax),%eax
 895:	84 c0                	test   %al,%al
 897:	75 da                	jne    873 <printf+0xe3>
 899:	eb 65                	jmp    900 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 89b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 89f:	75 1d                	jne    8be <printf+0x12e>
        putc(fd, *ap);
 8a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8a4:	8b 00                	mov    (%eax),%eax
 8a6:	0f be c0             	movsbl %al,%eax
 8a9:	83 ec 08             	sub    $0x8,%esp
 8ac:	50                   	push   %eax
 8ad:	ff 75 08             	pushl  0x8(%ebp)
 8b0:	e8 04 fe ff ff       	call   6b9 <putc>
 8b5:	83 c4 10             	add    $0x10,%esp
        ap++;
 8b8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8bc:	eb 42                	jmp    900 <printf+0x170>
      } else if(c == '%'){
 8be:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8c2:	75 17                	jne    8db <printf+0x14b>
        putc(fd, c);
 8c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8c7:	0f be c0             	movsbl %al,%eax
 8ca:	83 ec 08             	sub    $0x8,%esp
 8cd:	50                   	push   %eax
 8ce:	ff 75 08             	pushl  0x8(%ebp)
 8d1:	e8 e3 fd ff ff       	call   6b9 <putc>
 8d6:	83 c4 10             	add    $0x10,%esp
 8d9:	eb 25                	jmp    900 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8db:	83 ec 08             	sub    $0x8,%esp
 8de:	6a 25                	push   $0x25
 8e0:	ff 75 08             	pushl  0x8(%ebp)
 8e3:	e8 d1 fd ff ff       	call   6b9 <putc>
 8e8:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 8eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8ee:	0f be c0             	movsbl %al,%eax
 8f1:	83 ec 08             	sub    $0x8,%esp
 8f4:	50                   	push   %eax
 8f5:	ff 75 08             	pushl  0x8(%ebp)
 8f8:	e8 bc fd ff ff       	call   6b9 <putc>
 8fd:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 900:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 907:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 90b:	8b 55 0c             	mov    0xc(%ebp),%edx
 90e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 911:	01 d0                	add    %edx,%eax
 913:	0f b6 00             	movzbl (%eax),%eax
 916:	84 c0                	test   %al,%al
 918:	0f 85 94 fe ff ff    	jne    7b2 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 91e:	90                   	nop
 91f:	c9                   	leave  
 920:	c3                   	ret    

00000921 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 921:	55                   	push   %ebp
 922:	89 e5                	mov    %esp,%ebp
 924:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 927:	8b 45 08             	mov    0x8(%ebp),%eax
 92a:	83 e8 08             	sub    $0x8,%eax
 92d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 930:	a1 48 0e 00 00       	mov    0xe48,%eax
 935:	89 45 fc             	mov    %eax,-0x4(%ebp)
 938:	eb 24                	jmp    95e <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 93a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93d:	8b 00                	mov    (%eax),%eax
 93f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 942:	77 12                	ja     956 <free+0x35>
 944:	8b 45 f8             	mov    -0x8(%ebp),%eax
 947:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 94a:	77 24                	ja     970 <free+0x4f>
 94c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94f:	8b 00                	mov    (%eax),%eax
 951:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 954:	77 1a                	ja     970 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 956:	8b 45 fc             	mov    -0x4(%ebp),%eax
 959:	8b 00                	mov    (%eax),%eax
 95b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 95e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 961:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 964:	76 d4                	jbe    93a <free+0x19>
 966:	8b 45 fc             	mov    -0x4(%ebp),%eax
 969:	8b 00                	mov    (%eax),%eax
 96b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 96e:	76 ca                	jbe    93a <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 970:	8b 45 f8             	mov    -0x8(%ebp),%eax
 973:	8b 40 04             	mov    0x4(%eax),%eax
 976:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 97d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 980:	01 c2                	add    %eax,%edx
 982:	8b 45 fc             	mov    -0x4(%ebp),%eax
 985:	8b 00                	mov    (%eax),%eax
 987:	39 c2                	cmp    %eax,%edx
 989:	75 24                	jne    9af <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 98b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 98e:	8b 50 04             	mov    0x4(%eax),%edx
 991:	8b 45 fc             	mov    -0x4(%ebp),%eax
 994:	8b 00                	mov    (%eax),%eax
 996:	8b 40 04             	mov    0x4(%eax),%eax
 999:	01 c2                	add    %eax,%edx
 99b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 99e:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 9a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a4:	8b 00                	mov    (%eax),%eax
 9a6:	8b 10                	mov    (%eax),%edx
 9a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9ab:	89 10                	mov    %edx,(%eax)
 9ad:	eb 0a                	jmp    9b9 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 9af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b2:	8b 10                	mov    (%eax),%edx
 9b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9b7:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 9b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9bc:	8b 40 04             	mov    0x4(%eax),%eax
 9bf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c9:	01 d0                	add    %edx,%eax
 9cb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9ce:	75 20                	jne    9f0 <free+0xcf>
    p->s.size += bp->s.size;
 9d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d3:	8b 50 04             	mov    0x4(%eax),%edx
 9d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9d9:	8b 40 04             	mov    0x4(%eax),%eax
 9dc:	01 c2                	add    %eax,%edx
 9de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e1:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9e7:	8b 10                	mov    (%eax),%edx
 9e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ec:	89 10                	mov    %edx,(%eax)
 9ee:	eb 08                	jmp    9f8 <free+0xd7>
  } else
    p->s.ptr = bp;
 9f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f3:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9f6:	89 10                	mov    %edx,(%eax)
  freep = p;
 9f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9fb:	a3 48 0e 00 00       	mov    %eax,0xe48
}
 a00:	90                   	nop
 a01:	c9                   	leave  
 a02:	c3                   	ret    

00000a03 <morecore>:

static Header*
morecore(uint nu)
{
 a03:	55                   	push   %ebp
 a04:	89 e5                	mov    %esp,%ebp
 a06:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a09:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a10:	77 07                	ja     a19 <morecore+0x16>
    nu = 4096;
 a12:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a19:	8b 45 08             	mov    0x8(%ebp),%eax
 a1c:	c1 e0 03             	shl    $0x3,%eax
 a1f:	83 ec 0c             	sub    $0xc,%esp
 a22:	50                   	push   %eax
 a23:	e8 59 fc ff ff       	call   681 <sbrk>
 a28:	83 c4 10             	add    $0x10,%esp
 a2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a2e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a32:	75 07                	jne    a3b <morecore+0x38>
    return 0;
 a34:	b8 00 00 00 00       	mov    $0x0,%eax
 a39:	eb 26                	jmp    a61 <morecore+0x5e>
  hp = (Header*)p;
 a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a41:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a44:	8b 55 08             	mov    0x8(%ebp),%edx
 a47:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a4d:	83 c0 08             	add    $0x8,%eax
 a50:	83 ec 0c             	sub    $0xc,%esp
 a53:	50                   	push   %eax
 a54:	e8 c8 fe ff ff       	call   921 <free>
 a59:	83 c4 10             	add    $0x10,%esp
  return freep;
 a5c:	a1 48 0e 00 00       	mov    0xe48,%eax
}
 a61:	c9                   	leave  
 a62:	c3                   	ret    

00000a63 <malloc>:

void*
malloc(uint nbytes)
{
 a63:	55                   	push   %ebp
 a64:	89 e5                	mov    %esp,%ebp
 a66:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a69:	8b 45 08             	mov    0x8(%ebp),%eax
 a6c:	83 c0 07             	add    $0x7,%eax
 a6f:	c1 e8 03             	shr    $0x3,%eax
 a72:	83 c0 01             	add    $0x1,%eax
 a75:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a78:	a1 48 0e 00 00       	mov    0xe48,%eax
 a7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a80:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a84:	75 23                	jne    aa9 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a86:	c7 45 f0 40 0e 00 00 	movl   $0xe40,-0x10(%ebp)
 a8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a90:	a3 48 0e 00 00       	mov    %eax,0xe48
 a95:	a1 48 0e 00 00       	mov    0xe48,%eax
 a9a:	a3 40 0e 00 00       	mov    %eax,0xe40
    base.s.size = 0;
 a9f:	c7 05 44 0e 00 00 00 	movl   $0x0,0xe44
 aa6:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aac:	8b 00                	mov    (%eax),%eax
 aae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab4:	8b 40 04             	mov    0x4(%eax),%eax
 ab7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 aba:	72 4d                	jb     b09 <malloc+0xa6>
      if(p->s.size == nunits)
 abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 abf:	8b 40 04             	mov    0x4(%eax),%eax
 ac2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ac5:	75 0c                	jne    ad3 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aca:	8b 10                	mov    (%eax),%edx
 acc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 acf:	89 10                	mov    %edx,(%eax)
 ad1:	eb 26                	jmp    af9 <malloc+0x96>
      else {
        p->s.size -= nunits;
 ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad6:	8b 40 04             	mov    0x4(%eax),%eax
 ad9:	2b 45 ec             	sub    -0x14(%ebp),%eax
 adc:	89 c2                	mov    %eax,%edx
 ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae7:	8b 40 04             	mov    0x4(%eax),%eax
 aea:	c1 e0 03             	shl    $0x3,%eax
 aed:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af3:	8b 55 ec             	mov    -0x14(%ebp),%edx
 af6:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 af9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 afc:	a3 48 0e 00 00       	mov    %eax,0xe48
      return (void*)(p + 1);
 b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b04:	83 c0 08             	add    $0x8,%eax
 b07:	eb 3b                	jmp    b44 <malloc+0xe1>
    }
    if(p == freep)
 b09:	a1 48 0e 00 00       	mov    0xe48,%eax
 b0e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b11:	75 1e                	jne    b31 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 b13:	83 ec 0c             	sub    $0xc,%esp
 b16:	ff 75 ec             	pushl  -0x14(%ebp)
 b19:	e8 e5 fe ff ff       	call   a03 <morecore>
 b1e:	83 c4 10             	add    $0x10,%esp
 b21:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b28:	75 07                	jne    b31 <malloc+0xce>
        return 0;
 b2a:	b8 00 00 00 00       	mov    $0x0,%eax
 b2f:	eb 13                	jmp    b44 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b34:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b3a:	8b 00                	mov    (%eax),%eax
 b3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b3f:	e9 6d ff ff ff       	jmp    ab1 <malloc+0x4e>
}
 b44:	c9                   	leave  
 b45:	c3                   	ret    
