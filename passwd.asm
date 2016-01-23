
_passwd:     формат файла elf32-i386


Дизассемблирование раздела .text:

00000000 <passwd>:
#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int passwd(char * username) {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	83 ec 70             	sub    $0x70,%esp
   8:	89 e0                	mov    %esp,%eax
   a:	89 c6                	mov    %eax,%esi
	int LEN = 100;
   c:	c7 45 c8 64 00 00 00 	movl   $0x64,-0x38(%ebp)
	char string[LEN];
  13:	8b 45 c8             	mov    -0x38(%ebp),%eax
  16:	8d 50 ff             	lea    -0x1(%eax),%edx
  19:	89 55 c4             	mov    %edx,-0x3c(%ebp)
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
  3e:	89 45 c0             	mov    %eax,-0x40(%ebp)
	char oldpass[LEN];
  41:	8b 45 c8             	mov    -0x38(%ebp),%eax
  44:	8d 50 ff             	lea    -0x1(%eax),%edx
  47:	89 55 bc             	mov    %edx,-0x44(%ebp)
  4a:	89 c2                	mov    %eax,%edx
  4c:	b8 10 00 00 00       	mov    $0x10,%eax
  51:	83 e8 01             	sub    $0x1,%eax
  54:	01 d0                	add    %edx,%eax
  56:	b9 10 00 00 00       	mov    $0x10,%ecx
  5b:	ba 00 00 00 00       	mov    $0x0,%edx
  60:	f7 f1                	div    %ecx
  62:	6b c0 10             	imul   $0x10,%eax,%eax
  65:	29 c4                	sub    %eax,%esp
  67:	89 e0                	mov    %esp,%eax
  69:	83 c0 00             	add    $0x0,%eax
  6c:	89 45 b8             	mov    %eax,-0x48(%ebp)
	char roldpass[LEN];
  6f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  72:	8d 50 ff             	lea    -0x1(%eax),%edx
  75:	89 55 b4             	mov    %edx,-0x4c(%ebp)
  78:	89 c2                	mov    %eax,%edx
  7a:	b8 10 00 00 00       	mov    $0x10,%eax
  7f:	83 e8 01             	sub    $0x1,%eax
  82:	01 d0                	add    %edx,%eax
  84:	bb 10 00 00 00       	mov    $0x10,%ebx
  89:	ba 00 00 00 00       	mov    $0x0,%edx
  8e:	f7 f3                	div    %ebx
  90:	6b c0 10             	imul   $0x10,%eax,%eax
  93:	29 c4                	sub    %eax,%esp
  95:	89 e0                	mov    %esp,%eax
  97:	83 c0 00             	add    $0x0,%eax
  9a:	89 45 b0             	mov    %eax,-0x50(%ebp)
	char newpass[LEN];
  9d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  a0:	8d 50 ff             	lea    -0x1(%eax),%edx
  a3:	89 55 ac             	mov    %edx,-0x54(%ebp)
  a6:	89 c2                	mov    %eax,%edx
  a8:	b8 10 00 00 00       	mov    $0x10,%eax
  ad:	83 e8 01             	sub    $0x1,%eax
  b0:	01 d0                	add    %edx,%eax
  b2:	b9 10 00 00 00       	mov    $0x10,%ecx
  b7:	ba 00 00 00 00       	mov    $0x0,%edx
  bc:	f7 f1                	div    %ecx
  be:	6b c0 10             	imul   $0x10,%eax,%eax
  c1:	29 c4                	sub    %eax,%esp
  c3:	89 e0                	mov    %esp,%eax
  c5:	83 c0 00             	add    $0x0,%eax
  c8:	89 45 a8             	mov    %eax,-0x58(%ebp)
	char curname[LEN];
  cb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  ce:	8d 50 ff             	lea    -0x1(%eax),%edx
  d1:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  d4:	89 c2                	mov    %eax,%edx
  d6:	b8 10 00 00 00       	mov    $0x10,%eax
  db:	83 e8 01             	sub    $0x1,%eax
  de:	01 d0                	add    %edx,%eax
  e0:	bb 10 00 00 00       	mov    $0x10,%ebx
  e5:	ba 00 00 00 00       	mov    $0x0,%edx
  ea:	f7 f3                	div    %ebx
  ec:	6b c0 10             	imul   $0x10,%eax,%eax
  ef:	29 c4                	sub    %eax,%esp
  f1:	89 e0                	mov    %esp,%eax
  f3:	83 c0 00             	add    $0x0,%eax
  f6:	89 45 a0             	mov    %eax,-0x60(%ebp)
	char buf[1];

	//read file - pass
  int fd = open("/pass", O_RDONLY);
  f9:	83 ec 08             	sub    $0x8,%esp
  fc:	6a 00                	push   $0x0
  fe:	68 0c 0d 00 00       	push   $0xd0c
 103:	e8 f7 06 00 00       	call   7ff <open>
 108:	83 c4 10             	add    $0x10,%esp
 10b:	89 45 9c             	mov    %eax,-0x64(%ebp)
  char * p = string;
 10e:	8b 45 c0             	mov    -0x40(%ebp),%eax
 111:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int j;
  for(j = 0; read(fd, buf, 1) == 1 && buf[0] != '\0'; ++j) {
 114:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 11b:	eb 13                	jmp    130 <passwd+0x130>
    *p++ = buf[0];
 11d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 120:	8d 50 01             	lea    0x1(%eax),%edx
 123:	89 55 f4             	mov    %edx,-0xc(%ebp)
 126:	0f b6 55 93          	movzbl -0x6d(%ebp),%edx
 12a:	88 10                	mov    %dl,(%eax)

	//read file - pass
  int fd = open("/pass", O_RDONLY);
  char * p = string;
  int j;
  for(j = 0; read(fd, buf, 1) == 1 && buf[0] != '\0'; ++j) {
 12c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 130:	83 ec 04             	sub    $0x4,%esp
 133:	6a 01                	push   $0x1
 135:	8d 45 93             	lea    -0x6d(%ebp),%eax
 138:	50                   	push   %eax
 139:	ff 75 9c             	pushl  -0x64(%ebp)
 13c:	e8 96 06 00 00       	call   7d7 <read>
 141:	83 c4 10             	add    $0x10,%esp
 144:	83 f8 01             	cmp    $0x1,%eax
 147:	75 08                	jne    151 <passwd+0x151>
 149:	0f b6 45 93          	movzbl -0x6d(%ebp),%eax
 14d:	84 c0                	test   %al,%al
 14f:	75 cc                	jne    11d <passwd+0x11d>
    *p++ = buf[0];
  }
  *p = '\0';
 151:	8b 45 f4             	mov    -0xc(%ebp),%eax
 154:	c6 00 00             	movb   $0x0,(%eax)
  close(fd);
 157:	83 ec 0c             	sub    $0xc,%esp
 15a:	ff 75 9c             	pushl  -0x64(%ebp)
 15d:	e8 85 06 00 00       	call   7e7 <close>
 162:	83 c4 10             	add    $0x10,%esp

  // find username and old password
	int endpos;
	endpos = 0;
 165:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int namepos;
  namepos = 0;
 16c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  char * ptr = curname;
 173:	8b 45 a0             	mov    -0x60(%ebp),%eax
 176:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char * ropp = roldpass;
 179:	8b 45 b0             	mov    -0x50(%ebp),%eax
 17c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  int flag = 0;
 17f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  int counter = 0;
 186:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  int i;
  for(i = 0; string[i]; ++i) {
 18d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 194:	e9 e1 00 00 00       	jmp    27a <passwd+0x27a>
  	if(!counter && string[i] != ':') {
 199:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
 19d:	75 25                	jne    1c4 <passwd+0x1c4>
 19f:	8b 55 c0             	mov    -0x40(%ebp),%edx
 1a2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1a5:	01 d0                	add    %edx,%eax
 1a7:	0f b6 00             	movzbl (%eax),%eax
 1aa:	3c 3a                	cmp    $0x3a,%al
 1ac:	74 16                	je     1c4 <passwd+0x1c4>
  		*ptr++ = string[i];
 1ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1b1:	8d 50 01             	lea    0x1(%eax),%edx
 1b4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 1b7:	8b 4d c0             	mov    -0x40(%ebp),%ecx
 1ba:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 1bd:	01 ca                	add    %ecx,%edx
 1bf:	0f b6 12             	movzbl (%edx),%edx
 1c2:	88 10                	mov    %dl,(%eax)
  	}
  	if(counter == 1 && string[i] != ':') {
 1c4:	83 7d d8 01          	cmpl   $0x1,-0x28(%ebp)
 1c8:	75 25                	jne    1ef <passwd+0x1ef>
 1ca:	8b 55 c0             	mov    -0x40(%ebp),%edx
 1cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1d0:	01 d0                	add    %edx,%eax
 1d2:	0f b6 00             	movzbl (%eax),%eax
 1d5:	3c 3a                	cmp    $0x3a,%al
 1d7:	74 16                	je     1ef <passwd+0x1ef>
  		*ropp++ = string[i];
 1d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1dc:	8d 50 01             	lea    0x1(%eax),%edx
 1df:	89 55 e0             	mov    %edx,-0x20(%ebp)
 1e2:	8b 4d c0             	mov    -0x40(%ebp),%ecx
 1e5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 1e8:	01 ca                	add    %ecx,%edx
 1ea:	0f b6 12             	movzbl (%edx),%edx
 1ed:	88 10                	mov    %dl,(%eax)
  	}
  	if(string[i] == ':')
 1ef:	8b 55 c0             	mov    -0x40(%ebp),%edx
 1f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1f5:	01 d0                	add    %edx,%eax
 1f7:	0f b6 00             	movzbl (%eax),%eax
 1fa:	3c 3a                	cmp    $0x3a,%al
 1fc:	75 04                	jne    202 <passwd+0x202>
  		++counter;
 1fe:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
  		if(counter == 1) {
 202:	83 7d d8 01          	cmpl   $0x1,-0x28(%ebp)
 206:	75 0c                	jne    214 <passwd+0x214>
  			*ptr++ = '\0';
 208:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 20b:	8d 50 01             	lea    0x1(%eax),%edx
 20e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 211:	c6 00 00             	movb   $0x0,(%eax)
  		}
  		if(counter == 2) {
 214:	83 7d d8 02          	cmpl   $0x2,-0x28(%ebp)
 218:	75 0c                	jne    226 <passwd+0x226>
  			*ropp++ = '\0';
 21a:	8b 45 e0             	mov    -0x20(%ebp),%eax
 21d:	8d 50 01             	lea    0x1(%eax),%edx
 220:	89 55 e0             	mov    %edx,-0x20(%ebp)
 223:	c6 00 00             	movb   $0x0,(%eax)
  		}
  	if (string[i] == '\n') {
 226:	8b 55 c0             	mov    -0x40(%ebp),%edx
 229:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 22c:	01 d0                	add    %edx,%eax
 22e:	0f b6 00             	movzbl (%eax),%eax
 231:	3c 0a                	cmp    $0xa,%al
 233:	75 41                	jne    276 <passwd+0x276>
  		if(!strcmp(username, curname)) {
 235:	8b 45 a0             	mov    -0x60(%ebp),%eax
 238:	83 ec 08             	sub    $0x8,%esp
 23b:	50                   	push   %eax
 23c:	ff 75 08             	pushl  0x8(%ebp)
 23f:	e8 7a 03 00 00       	call   5be <strcmp>
 244:	83 c4 10             	add    $0x10,%esp
 247:	85 c0                	test   %eax,%eax
 249:	75 0f                	jne    25a <passwd+0x25a>
  			endpos = i;
 24b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 24e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  			flag = 1;
 251:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
  			break;
 258:	eb 33                	jmp    28d <passwd+0x28d>
  		}
  		ptr = curname;
 25a:	8b 45 a0             	mov    -0x60(%ebp),%eax
 25d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  		ropp = roldpass;
 260:	8b 45 b0             	mov    -0x50(%ebp),%eax
 263:	89 45 e0             	mov    %eax,-0x20(%ebp)
  		namepos = i + 1;
 266:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 269:	83 c0 01             	add    $0x1,%eax
 26c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  		counter = 0;
 26f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  char * ptr = curname;
  char * ropp = roldpass;
  int flag = 0;
  int counter = 0;
  int i;
  for(i = 0; string[i]; ++i) {
 276:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
 27a:	8b 55 c0             	mov    -0x40(%ebp),%edx
 27d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 280:	01 d0                	add    %edx,%eax
 282:	0f b6 00             	movzbl (%eax),%eax
 285:	84 c0                	test   %al,%al
 287:	0f 85 0c ff ff ff    	jne    199 <passwd+0x199>
  		ropp = roldpass;
  		namepos = i + 1;
  		counter = 0;
  	}
  }
  if(!flag) {
 28d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
 291:	75 0a                	jne    29d <passwd+0x29d>
  	return -1;
 293:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 298:	e9 5d 02 00 00       	jmp    4fa <passwd+0x4fa>
	}
  //change pass
  printf(1, "enter old password for %s: ", curname);
 29d:	8b 45 a0             	mov    -0x60(%ebp),%eax
 2a0:	83 ec 04             	sub    $0x4,%esp
 2a3:	50                   	push   %eax
 2a4:	68 12 0d 00 00       	push   $0xd12
 2a9:	6a 01                	push   $0x1
 2ab:	e8 a6 06 00 00       	call   956 <printf>
 2b0:	83 c4 10             	add    $0x10,%esp
  char * opp = oldpass;
 2b3:	8b 45 b8             	mov    -0x48(%ebp),%eax
 2b6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  for(j = 0; read(0, buf, 1) == 1 && buf[0] != '\n'; ++j){
 2b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 2c0:	eb 13                	jmp    2d5 <passwd+0x2d5>
    *opp++ = buf[0];
 2c2:	8b 45 d0             	mov    -0x30(%ebp),%eax
 2c5:	8d 50 01             	lea    0x1(%eax),%edx
 2c8:	89 55 d0             	mov    %edx,-0x30(%ebp)
 2cb:	0f b6 55 93          	movzbl -0x6d(%ebp),%edx
 2cf:	88 10                	mov    %dl,(%eax)
  	return -1;
	}
  //change pass
  printf(1, "enter old password for %s: ", curname);
  char * opp = oldpass;
  for(j = 0; read(0, buf, 1) == 1 && buf[0] != '\n'; ++j){
 2d1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 2d5:	83 ec 04             	sub    $0x4,%esp
 2d8:	6a 01                	push   $0x1
 2da:	8d 45 93             	lea    -0x6d(%ebp),%eax
 2dd:	50                   	push   %eax
 2de:	6a 00                	push   $0x0
 2e0:	e8 f2 04 00 00       	call   7d7 <read>
 2e5:	83 c4 10             	add    $0x10,%esp
 2e8:	83 f8 01             	cmp    $0x1,%eax
 2eb:	75 08                	jne    2f5 <passwd+0x2f5>
 2ed:	0f b6 45 93          	movzbl -0x6d(%ebp),%eax
 2f1:	3c 0a                	cmp    $0xa,%al
 2f3:	75 cd                	jne    2c2 <passwd+0x2c2>
    *opp++ = buf[0];
  }
  *opp = '\0';
 2f5:	8b 45 d0             	mov    -0x30(%ebp),%eax
 2f8:	c6 00 00             	movb   $0x0,(%eax)
  if(strcmp(oldpass, roldpass)) {
 2fb:	8b 55 b0             	mov    -0x50(%ebp),%edx
 2fe:	8b 45 b8             	mov    -0x48(%ebp),%eax
 301:	83 ec 08             	sub    $0x8,%esp
 304:	52                   	push   %edx
 305:	50                   	push   %eax
 306:	e8 b3 02 00 00       	call   5be <strcmp>
 30b:	83 c4 10             	add    $0x10,%esp
 30e:	85 c0                	test   %eax,%eax
 310:	74 1f                	je     331 <passwd+0x331>
  	printf(2, "passwd: wrong old password for %s\n", username);
 312:	83 ec 04             	sub    $0x4,%esp
 315:	ff 75 08             	pushl  0x8(%ebp)
 318:	68 30 0d 00 00       	push   $0xd30
 31d:	6a 02                	push   $0x2
 31f:	e8 32 06 00 00       	call   956 <printf>
 324:	83 c4 10             	add    $0x10,%esp
  	return -1;
 327:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 32c:	e9 c9 01 00 00       	jmp    4fa <passwd+0x4fa>
  }
  printf(1, "enter new password for %s: ", curname);
 331:	8b 45 a0             	mov    -0x60(%ebp),%eax
 334:	83 ec 04             	sub    $0x4,%esp
 337:	50                   	push   %eax
 338:	68 53 0d 00 00       	push   $0xd53
 33d:	6a 01                	push   $0x1
 33f:	e8 12 06 00 00       	call   956 <printf>
 344:	83 c4 10             	add    $0x10,%esp
  char * npp = newpass;
 347:	8b 45 a8             	mov    -0x58(%ebp),%eax
 34a:	89 45 cc             	mov    %eax,-0x34(%ebp)
  for(j = 0; read(0, buf, 1) == 1 && buf[0] != '\n'; ++j){
 34d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 354:	eb 13                	jmp    369 <passwd+0x369>
    *npp++ = buf[0];
 356:	8b 45 cc             	mov    -0x34(%ebp),%eax
 359:	8d 50 01             	lea    0x1(%eax),%edx
 35c:	89 55 cc             	mov    %edx,-0x34(%ebp)
 35f:	0f b6 55 93          	movzbl -0x6d(%ebp),%edx
 363:	88 10                	mov    %dl,(%eax)
  	printf(2, "passwd: wrong old password for %s\n", username);
  	return -1;
  }
  printf(1, "enter new password for %s: ", curname);
  char * npp = newpass;
  for(j = 0; read(0, buf, 1) == 1 && buf[0] != '\n'; ++j){
 365:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 369:	83 ec 04             	sub    $0x4,%esp
 36c:	6a 01                	push   $0x1
 36e:	8d 45 93             	lea    -0x6d(%ebp),%eax
 371:	50                   	push   %eax
 372:	6a 00                	push   $0x0
 374:	e8 5e 04 00 00       	call   7d7 <read>
 379:	83 c4 10             	add    $0x10,%esp
 37c:	83 f8 01             	cmp    $0x1,%eax
 37f:	75 08                	jne    389 <passwd+0x389>
 381:	0f b6 45 93          	movzbl -0x6d(%ebp),%eax
 385:	3c 0a                	cmp    $0xa,%al
 387:	75 cd                	jne    356 <passwd+0x356>
    *npp++ = buf[0];
  }
  *npp = '\0';
 389:	8b 45 cc             	mov    -0x34(%ebp),%eax
 38c:	c6 00 00             	movb   $0x0,(%eax)

  // rewrite pass, with new password for user
  if(!fork()) {
 38f:	e8 23 04 00 00       	call   7b7 <fork>
 394:	85 c0                	test   %eax,%eax
 396:	75 27                	jne    3bf <passwd+0x3bf>
  	char *argv[] = {"rm", "/pass"};
 398:	c7 45 88 6f 0d 00 00 	movl   $0xd6f,-0x78(%ebp)
 39f:	c7 45 8c 0c 0d 00 00 	movl   $0xd0c,-0x74(%ebp)
  	exec("rm", argv);
 3a6:	83 ec 08             	sub    $0x8,%esp
 3a9:	8d 45 88             	lea    -0x78(%ebp),%eax
 3ac:	50                   	push   %eax
 3ad:	68 6f 0d 00 00       	push   $0xd6f
 3b2:	e8 40 04 00 00       	call   7f7 <exec>
 3b7:	83 c4 10             	add    $0x10,%esp
  	exit();
 3ba:	e8 00 04 00 00       	call   7bf <exit>
  }
  wait();
 3bf:	e8 03 04 00 00       	call   7c7 <wait>
  fd = open("/pass", O_WRONLY | O_CREATE);
 3c4:	83 ec 08             	sub    $0x8,%esp
 3c7:	68 01 02 00 00       	push   $0x201
 3cc:	68 0c 0d 00 00       	push   $0xd0c
 3d1:	e8 29 04 00 00       	call   7ff <open>
 3d6:	83 c4 10             	add    $0x10,%esp
 3d9:	89 45 9c             	mov    %eax,-0x64(%ebp)
  write(fd, string, namepos);
 3dc:	8b 45 c0             	mov    -0x40(%ebp),%eax
 3df:	83 ec 04             	sub    $0x4,%esp
 3e2:	ff 75 e8             	pushl  -0x18(%ebp)
 3e5:	50                   	push   %eax
 3e6:	ff 75 9c             	pushl  -0x64(%ebp)
 3e9:	e8 f1 03 00 00       	call   7df <write>
 3ee:	83 c4 10             	add    $0x10,%esp
  write(fd, curname, strlen(curname));
 3f1:	8b 45 a0             	mov    -0x60(%ebp),%eax
 3f4:	83 ec 0c             	sub    $0xc,%esp
 3f7:	50                   	push   %eax
 3f8:	e8 00 02 00 00       	call   5fd <strlen>
 3fd:	83 c4 10             	add    $0x10,%esp
 400:	89 c2                	mov    %eax,%edx
 402:	8b 45 a0             	mov    -0x60(%ebp),%eax
 405:	83 ec 04             	sub    $0x4,%esp
 408:	52                   	push   %edx
 409:	50                   	push   %eax
 40a:	ff 75 9c             	pushl  -0x64(%ebp)
 40d:	e8 cd 03 00 00       	call   7df <write>
 412:	83 c4 10             	add    $0x10,%esp
  write(fd, ":", 1);
 415:	83 ec 04             	sub    $0x4,%esp
 418:	6a 01                	push   $0x1
 41a:	68 72 0d 00 00       	push   $0xd72
 41f:	ff 75 9c             	pushl  -0x64(%ebp)
 422:	e8 b8 03 00 00       	call   7df <write>
 427:	83 c4 10             	add    $0x10,%esp
  write(fd, newpass, strlen(newpass));
 42a:	8b 45 a8             	mov    -0x58(%ebp),%eax
 42d:	83 ec 0c             	sub    $0xc,%esp
 430:	50                   	push   %eax
 431:	e8 c7 01 00 00       	call   5fd <strlen>
 436:	83 c4 10             	add    $0x10,%esp
 439:	89 c2                	mov    %eax,%edx
 43b:	8b 45 a8             	mov    -0x58(%ebp),%eax
 43e:	83 ec 04             	sub    $0x4,%esp
 441:	52                   	push   %edx
 442:	50                   	push   %eax
 443:	ff 75 9c             	pushl  -0x64(%ebp)
 446:	e8 94 03 00 00       	call   7df <write>
 44b:	83 c4 10             	add    $0x10,%esp
  write(fd, ":", 1);
 44e:	83 ec 04             	sub    $0x4,%esp
 451:	6a 01                	push   $0x1
 453:	68 72 0d 00 00       	push   $0xd72
 458:	ff 75 9c             	pushl  -0x64(%ebp)
 45b:	e8 7f 03 00 00       	call   7df <write>
 460:	83 c4 10             	add    $0x10,%esp
  char * uid = &string[namepos + strlen(curname) + strlen(oldpass) + 2];
 463:	8b 45 a0             	mov    -0x60(%ebp),%eax
 466:	83 ec 0c             	sub    $0xc,%esp
 469:	50                   	push   %eax
 46a:	e8 8e 01 00 00       	call   5fd <strlen>
 46f:	83 c4 10             	add    $0x10,%esp
 472:	89 c2                	mov    %eax,%edx
 474:	8b 45 e8             	mov    -0x18(%ebp),%eax
 477:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
 47a:	8b 45 b8             	mov    -0x48(%ebp),%eax
 47d:	83 ec 0c             	sub    $0xc,%esp
 480:	50                   	push   %eax
 481:	e8 77 01 00 00       	call   5fd <strlen>
 486:	83 c4 10             	add    $0x10,%esp
 489:	01 d8                	add    %ebx,%eax
 48b:	8d 50 02             	lea    0x2(%eax),%edx
 48e:	8b 45 c0             	mov    -0x40(%ebp),%eax
 491:	01 d0                	add    %edx,%eax
 493:	89 45 98             	mov    %eax,-0x68(%ebp)
  write(fd, uid, strlen(uid) + 1);
 496:	83 ec 0c             	sub    $0xc,%esp
 499:	ff 75 98             	pushl  -0x68(%ebp)
 49c:	e8 5c 01 00 00       	call   5fd <strlen>
 4a1:	83 c4 10             	add    $0x10,%esp
 4a4:	83 c0 01             	add    $0x1,%eax
 4a7:	83 ec 04             	sub    $0x4,%esp
 4aa:	50                   	push   %eax
 4ab:	ff 75 98             	pushl  -0x68(%ebp)
 4ae:	ff 75 9c             	pushl  -0x64(%ebp)
 4b1:	e8 29 03 00 00       	call   7df <write>
 4b6:	83 c4 10             	add    $0x10,%esp
  // write(fd, "\n", 1);
  char * end = &string[endpos + 1];
 4b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4bc:	8d 50 01             	lea    0x1(%eax),%edx
 4bf:	8b 45 c0             	mov    -0x40(%ebp),%eax
 4c2:	01 d0                	add    %edx,%eax
 4c4:	89 45 94             	mov    %eax,-0x6c(%ebp)
  write(fd, end, strlen(end));
 4c7:	83 ec 0c             	sub    $0xc,%esp
 4ca:	ff 75 94             	pushl  -0x6c(%ebp)
 4cd:	e8 2b 01 00 00       	call   5fd <strlen>
 4d2:	83 c4 10             	add    $0x10,%esp
 4d5:	83 ec 04             	sub    $0x4,%esp
 4d8:	50                   	push   %eax
 4d9:	ff 75 94             	pushl  -0x6c(%ebp)
 4dc:	ff 75 9c             	pushl  -0x64(%ebp)
 4df:	e8 fb 02 00 00       	call   7df <write>
 4e4:	83 c4 10             	add    $0x10,%esp
  close(fd);
 4e7:	83 ec 0c             	sub    $0xc,%esp
 4ea:	ff 75 9c             	pushl  -0x64(%ebp)
 4ed:	e8 f5 02 00 00       	call   7e7 <close>
 4f2:	83 c4 10             	add    $0x10,%esp
  return 0;
 4f5:	b8 00 00 00 00       	mov    $0x0,%eax
 4fa:	89 f4                	mov    %esi,%esp
}
 4fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
 4ff:	5b                   	pop    %ebx
 500:	5e                   	pop    %esi
 501:	5d                   	pop    %ebp
 502:	c3                   	ret    

00000503 <main>:

int
main(int argc, char *argv[])
{
 503:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 507:	83 e4 f0             	and    $0xfffffff0,%esp
 50a:	ff 71 fc             	pushl  -0x4(%ecx)
 50d:	55                   	push   %ebp
 50e:	89 e5                	mov    %esp,%ebp
 510:	53                   	push   %ebx
 511:	51                   	push   %ecx
 512:	89 cb                	mov    %ecx,%ebx
    if (argc < 2){
 514:	83 3b 01             	cmpl   $0x1,(%ebx)
 517:	7f 17                	jg     530 <main+0x2d>
        printf(2, "no username\n");
 519:	83 ec 08             	sub    $0x8,%esp
 51c:	68 74 0d 00 00       	push   $0xd74
 521:	6a 02                	push   $0x2
 523:	e8 2e 04 00 00       	call   956 <printf>
 528:	83 c4 10             	add    $0x10,%esp
        exit();
 52b:	e8 8f 02 00 00       	call   7bf <exit>
    }

    if (passwd(argv[1]) < 0)
 530:	8b 43 04             	mov    0x4(%ebx),%eax
 533:	83 c0 04             	add    $0x4,%eax
 536:	8b 00                	mov    (%eax),%eax
 538:	83 ec 0c             	sub    $0xc,%esp
 53b:	50                   	push   %eax
 53c:	e8 bf fa ff ff       	call   0 <passwd>
 541:	83 c4 10             	add    $0x10,%esp
 544:	85 c0                	test   %eax,%eax
 546:	79 1b                	jns    563 <main+0x60>
      printf(2, "passwd: password for %s failed to be changed\n", argv[1]);
 548:	8b 43 04             	mov    0x4(%ebx),%eax
 54b:	83 c0 04             	add    $0x4,%eax
 54e:	8b 00                	mov    (%eax),%eax
 550:	83 ec 04             	sub    $0x4,%esp
 553:	50                   	push   %eax
 554:	68 84 0d 00 00       	push   $0xd84
 559:	6a 02                	push   $0x2
 55b:	e8 f6 03 00 00       	call   956 <printf>
 560:	83 c4 10             	add    $0x10,%esp

    exit();
 563:	e8 57 02 00 00       	call   7bf <exit>

00000568 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 568:	55                   	push   %ebp
 569:	89 e5                	mov    %esp,%ebp
 56b:	57                   	push   %edi
 56c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 56d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 570:	8b 55 10             	mov    0x10(%ebp),%edx
 573:	8b 45 0c             	mov    0xc(%ebp),%eax
 576:	89 cb                	mov    %ecx,%ebx
 578:	89 df                	mov    %ebx,%edi
 57a:	89 d1                	mov    %edx,%ecx
 57c:	fc                   	cld    
 57d:	f3 aa                	rep stos %al,%es:(%edi)
 57f:	89 ca                	mov    %ecx,%edx
 581:	89 fb                	mov    %edi,%ebx
 583:	89 5d 08             	mov    %ebx,0x8(%ebp)
 586:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 589:	90                   	nop
 58a:	5b                   	pop    %ebx
 58b:	5f                   	pop    %edi
 58c:	5d                   	pop    %ebp
 58d:	c3                   	ret    

0000058e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 58e:	55                   	push   %ebp
 58f:	89 e5                	mov    %esp,%ebp
 591:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 594:	8b 45 08             	mov    0x8(%ebp),%eax
 597:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 59a:	90                   	nop
 59b:	8b 45 08             	mov    0x8(%ebp),%eax
 59e:	8d 50 01             	lea    0x1(%eax),%edx
 5a1:	89 55 08             	mov    %edx,0x8(%ebp)
 5a4:	8b 55 0c             	mov    0xc(%ebp),%edx
 5a7:	8d 4a 01             	lea    0x1(%edx),%ecx
 5aa:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 5ad:	0f b6 12             	movzbl (%edx),%edx
 5b0:	88 10                	mov    %dl,(%eax)
 5b2:	0f b6 00             	movzbl (%eax),%eax
 5b5:	84 c0                	test   %al,%al
 5b7:	75 e2                	jne    59b <strcpy+0xd>
    ;
  return os;
 5b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 5bc:	c9                   	leave  
 5bd:	c3                   	ret    

000005be <strcmp>:

int
strcmp(const char *p, const char *q)
{
 5be:	55                   	push   %ebp
 5bf:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 5c1:	eb 08                	jmp    5cb <strcmp+0xd>
    p++, q++;
 5c3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 5c7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 5cb:	8b 45 08             	mov    0x8(%ebp),%eax
 5ce:	0f b6 00             	movzbl (%eax),%eax
 5d1:	84 c0                	test   %al,%al
 5d3:	74 10                	je     5e5 <strcmp+0x27>
 5d5:	8b 45 08             	mov    0x8(%ebp),%eax
 5d8:	0f b6 10             	movzbl (%eax),%edx
 5db:	8b 45 0c             	mov    0xc(%ebp),%eax
 5de:	0f b6 00             	movzbl (%eax),%eax
 5e1:	38 c2                	cmp    %al,%dl
 5e3:	74 de                	je     5c3 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 5e5:	8b 45 08             	mov    0x8(%ebp),%eax
 5e8:	0f b6 00             	movzbl (%eax),%eax
 5eb:	0f b6 d0             	movzbl %al,%edx
 5ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 5f1:	0f b6 00             	movzbl (%eax),%eax
 5f4:	0f b6 c0             	movzbl %al,%eax
 5f7:	29 c2                	sub    %eax,%edx
 5f9:	89 d0                	mov    %edx,%eax
}
 5fb:	5d                   	pop    %ebp
 5fc:	c3                   	ret    

000005fd <strlen>:

uint
strlen(char *s)
{
 5fd:	55                   	push   %ebp
 5fe:	89 e5                	mov    %esp,%ebp
 600:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 603:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 60a:	eb 04                	jmp    610 <strlen+0x13>
 60c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 610:	8b 55 fc             	mov    -0x4(%ebp),%edx
 613:	8b 45 08             	mov    0x8(%ebp),%eax
 616:	01 d0                	add    %edx,%eax
 618:	0f b6 00             	movzbl (%eax),%eax
 61b:	84 c0                	test   %al,%al
 61d:	75 ed                	jne    60c <strlen+0xf>
    ;
  return n;
 61f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 622:	c9                   	leave  
 623:	c3                   	ret    

00000624 <memset>:

void*
memset(void *dst, int c, uint n)
{
 624:	55                   	push   %ebp
 625:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 627:	8b 45 10             	mov    0x10(%ebp),%eax
 62a:	50                   	push   %eax
 62b:	ff 75 0c             	pushl  0xc(%ebp)
 62e:	ff 75 08             	pushl  0x8(%ebp)
 631:	e8 32 ff ff ff       	call   568 <stosb>
 636:	83 c4 0c             	add    $0xc,%esp
  return dst;
 639:	8b 45 08             	mov    0x8(%ebp),%eax
}
 63c:	c9                   	leave  
 63d:	c3                   	ret    

0000063e <strchr>:

char*
strchr(const char *s, char c)
{
 63e:	55                   	push   %ebp
 63f:	89 e5                	mov    %esp,%ebp
 641:	83 ec 04             	sub    $0x4,%esp
 644:	8b 45 0c             	mov    0xc(%ebp),%eax
 647:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 64a:	eb 14                	jmp    660 <strchr+0x22>
    if(*s == c)
 64c:	8b 45 08             	mov    0x8(%ebp),%eax
 64f:	0f b6 00             	movzbl (%eax),%eax
 652:	3a 45 fc             	cmp    -0x4(%ebp),%al
 655:	75 05                	jne    65c <strchr+0x1e>
      return (char*)s;
 657:	8b 45 08             	mov    0x8(%ebp),%eax
 65a:	eb 13                	jmp    66f <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 65c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 660:	8b 45 08             	mov    0x8(%ebp),%eax
 663:	0f b6 00             	movzbl (%eax),%eax
 666:	84 c0                	test   %al,%al
 668:	75 e2                	jne    64c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 66a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 66f:	c9                   	leave  
 670:	c3                   	ret    

00000671 <gets>:

char*
gets(char *buf, int max)
{
 671:	55                   	push   %ebp
 672:	89 e5                	mov    %esp,%ebp
 674:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 677:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 67e:	eb 42                	jmp    6c2 <gets+0x51>
    cc = read(0, &c, 1);
 680:	83 ec 04             	sub    $0x4,%esp
 683:	6a 01                	push   $0x1
 685:	8d 45 ef             	lea    -0x11(%ebp),%eax
 688:	50                   	push   %eax
 689:	6a 00                	push   $0x0
 68b:	e8 47 01 00 00       	call   7d7 <read>
 690:	83 c4 10             	add    $0x10,%esp
 693:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 696:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 69a:	7e 33                	jle    6cf <gets+0x5e>
      break;
    buf[i++] = c;
 69c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 69f:	8d 50 01             	lea    0x1(%eax),%edx
 6a2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6a5:	89 c2                	mov    %eax,%edx
 6a7:	8b 45 08             	mov    0x8(%ebp),%eax
 6aa:	01 c2                	add    %eax,%edx
 6ac:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 6b0:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 6b2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 6b6:	3c 0a                	cmp    $0xa,%al
 6b8:	74 16                	je     6d0 <gets+0x5f>
 6ba:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 6be:	3c 0d                	cmp    $0xd,%al
 6c0:	74 0e                	je     6d0 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 6c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c5:	83 c0 01             	add    $0x1,%eax
 6c8:	3b 45 0c             	cmp    0xc(%ebp),%eax
 6cb:	7c b3                	jl     680 <gets+0xf>
 6cd:	eb 01                	jmp    6d0 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 6cf:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 6d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
 6d3:	8b 45 08             	mov    0x8(%ebp),%eax
 6d6:	01 d0                	add    %edx,%eax
 6d8:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 6db:	8b 45 08             	mov    0x8(%ebp),%eax
}
 6de:	c9                   	leave  
 6df:	c3                   	ret    

000006e0 <stat>:

int
stat(char *n, struct stat *st)
{
 6e0:	55                   	push   %ebp
 6e1:	89 e5                	mov    %esp,%ebp
 6e3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY | O_NBLOCK);
 6e6:	83 ec 08             	sub    $0x8,%esp
 6e9:	6a 10                	push   $0x10
 6eb:	ff 75 08             	pushl  0x8(%ebp)
 6ee:	e8 0c 01 00 00       	call   7ff <open>
 6f3:	83 c4 10             	add    $0x10,%esp
 6f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 6f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6fd:	79 07                	jns    706 <stat+0x26>
    return -1;
 6ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 704:	eb 25                	jmp    72b <stat+0x4b>
  r = fstat(fd, st);
 706:	83 ec 08             	sub    $0x8,%esp
 709:	ff 75 0c             	pushl  0xc(%ebp)
 70c:	ff 75 f4             	pushl  -0xc(%ebp)
 70f:	e8 03 01 00 00       	call   817 <fstat>
 714:	83 c4 10             	add    $0x10,%esp
 717:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 71a:	83 ec 0c             	sub    $0xc,%esp
 71d:	ff 75 f4             	pushl  -0xc(%ebp)
 720:	e8 c2 00 00 00       	call   7e7 <close>
 725:	83 c4 10             	add    $0x10,%esp
  return r;
 728:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 72b:	c9                   	leave  
 72c:	c3                   	ret    

0000072d <atoi>:

int
atoi(const char *s)
{
 72d:	55                   	push   %ebp
 72e:	89 e5                	mov    %esp,%ebp
 730:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 733:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 73a:	eb 25                	jmp    761 <atoi+0x34>
    n = n*10 + *s++ - '0';
 73c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 73f:	89 d0                	mov    %edx,%eax
 741:	c1 e0 02             	shl    $0x2,%eax
 744:	01 d0                	add    %edx,%eax
 746:	01 c0                	add    %eax,%eax
 748:	89 c1                	mov    %eax,%ecx
 74a:	8b 45 08             	mov    0x8(%ebp),%eax
 74d:	8d 50 01             	lea    0x1(%eax),%edx
 750:	89 55 08             	mov    %edx,0x8(%ebp)
 753:	0f b6 00             	movzbl (%eax),%eax
 756:	0f be c0             	movsbl %al,%eax
 759:	01 c8                	add    %ecx,%eax
 75b:	83 e8 30             	sub    $0x30,%eax
 75e:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 761:	8b 45 08             	mov    0x8(%ebp),%eax
 764:	0f b6 00             	movzbl (%eax),%eax
 767:	3c 2f                	cmp    $0x2f,%al
 769:	7e 0a                	jle    775 <atoi+0x48>
 76b:	8b 45 08             	mov    0x8(%ebp),%eax
 76e:	0f b6 00             	movzbl (%eax),%eax
 771:	3c 39                	cmp    $0x39,%al
 773:	7e c7                	jle    73c <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 775:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 778:	c9                   	leave  
 779:	c3                   	ret    

0000077a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 77a:	55                   	push   %ebp
 77b:	89 e5                	mov    %esp,%ebp
 77d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 780:	8b 45 08             	mov    0x8(%ebp),%eax
 783:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 786:	8b 45 0c             	mov    0xc(%ebp),%eax
 789:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 78c:	eb 17                	jmp    7a5 <memmove+0x2b>
    *dst++ = *src++;
 78e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 791:	8d 50 01             	lea    0x1(%eax),%edx
 794:	89 55 fc             	mov    %edx,-0x4(%ebp)
 797:	8b 55 f8             	mov    -0x8(%ebp),%edx
 79a:	8d 4a 01             	lea    0x1(%edx),%ecx
 79d:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 7a0:	0f b6 12             	movzbl (%edx),%edx
 7a3:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 7a5:	8b 45 10             	mov    0x10(%ebp),%eax
 7a8:	8d 50 ff             	lea    -0x1(%eax),%edx
 7ab:	89 55 10             	mov    %edx,0x10(%ebp)
 7ae:	85 c0                	test   %eax,%eax
 7b0:	7f dc                	jg     78e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 7b2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 7b5:	c9                   	leave  
 7b6:	c3                   	ret    

000007b7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 7b7:	b8 01 00 00 00       	mov    $0x1,%eax
 7bc:	cd 40                	int    $0x40
 7be:	c3                   	ret    

000007bf <exit>:
SYSCALL(exit)
 7bf:	b8 02 00 00 00       	mov    $0x2,%eax
 7c4:	cd 40                	int    $0x40
 7c6:	c3                   	ret    

000007c7 <wait>:
SYSCALL(wait)
 7c7:	b8 03 00 00 00       	mov    $0x3,%eax
 7cc:	cd 40                	int    $0x40
 7ce:	c3                   	ret    

000007cf <pipe>:
SYSCALL(pipe)
 7cf:	b8 04 00 00 00       	mov    $0x4,%eax
 7d4:	cd 40                	int    $0x40
 7d6:	c3                   	ret    

000007d7 <read>:
SYSCALL(read)
 7d7:	b8 05 00 00 00       	mov    $0x5,%eax
 7dc:	cd 40                	int    $0x40
 7de:	c3                   	ret    

000007df <write>:
SYSCALL(write)
 7df:	b8 10 00 00 00       	mov    $0x10,%eax
 7e4:	cd 40                	int    $0x40
 7e6:	c3                   	ret    

000007e7 <close>:
SYSCALL(close)
 7e7:	b8 15 00 00 00       	mov    $0x15,%eax
 7ec:	cd 40                	int    $0x40
 7ee:	c3                   	ret    

000007ef <kill>:
SYSCALL(kill)
 7ef:	b8 06 00 00 00       	mov    $0x6,%eax
 7f4:	cd 40                	int    $0x40
 7f6:	c3                   	ret    

000007f7 <exec>:
SYSCALL(exec)
 7f7:	b8 07 00 00 00       	mov    $0x7,%eax
 7fc:	cd 40                	int    $0x40
 7fe:	c3                   	ret    

000007ff <open>:
SYSCALL(open)
 7ff:	b8 0f 00 00 00       	mov    $0xf,%eax
 804:	cd 40                	int    $0x40
 806:	c3                   	ret    

00000807 <mknod>:
SYSCALL(mknod)
 807:	b8 11 00 00 00       	mov    $0x11,%eax
 80c:	cd 40                	int    $0x40
 80e:	c3                   	ret    

0000080f <unlink>:
SYSCALL(unlink)
 80f:	b8 12 00 00 00       	mov    $0x12,%eax
 814:	cd 40                	int    $0x40
 816:	c3                   	ret    

00000817 <fstat>:
SYSCALL(fstat)
 817:	b8 08 00 00 00       	mov    $0x8,%eax
 81c:	cd 40                	int    $0x40
 81e:	c3                   	ret    

0000081f <link>:
SYSCALL(link)
 81f:	b8 13 00 00 00       	mov    $0x13,%eax
 824:	cd 40                	int    $0x40
 826:	c3                   	ret    

00000827 <mkdir>:
SYSCALL(mkdir)
 827:	b8 14 00 00 00       	mov    $0x14,%eax
 82c:	cd 40                	int    $0x40
 82e:	c3                   	ret    

0000082f <chdir>:
SYSCALL(chdir)
 82f:	b8 09 00 00 00       	mov    $0x9,%eax
 834:	cd 40                	int    $0x40
 836:	c3                   	ret    

00000837 <dup>:
SYSCALL(dup)
 837:	b8 0a 00 00 00       	mov    $0xa,%eax
 83c:	cd 40                	int    $0x40
 83e:	c3                   	ret    

0000083f <getpid>:
SYSCALL(getpid)
 83f:	b8 0b 00 00 00       	mov    $0xb,%eax
 844:	cd 40                	int    $0x40
 846:	c3                   	ret    

00000847 <sbrk>:
SYSCALL(sbrk)
 847:	b8 0c 00 00 00       	mov    $0xc,%eax
 84c:	cd 40                	int    $0x40
 84e:	c3                   	ret    

0000084f <sleep>:
SYSCALL(sleep)
 84f:	b8 0d 00 00 00       	mov    $0xd,%eax
 854:	cd 40                	int    $0x40
 856:	c3                   	ret    

00000857 <uptime>:
SYSCALL(uptime)
 857:	b8 0e 00 00 00       	mov    $0xe,%eax
 85c:	cd 40                	int    $0x40
 85e:	c3                   	ret    

0000085f <mkfifo>:
SYSCALL(mkfifo)
 85f:	b8 16 00 00 00       	mov    $0x16,%eax
 864:	cd 40                	int    $0x40
 866:	c3                   	ret    

00000867 <up>:
SYSCALL(up)
 867:	b8 18 00 00 00       	mov    $0x18,%eax
 86c:	cd 40                	int    $0x40
 86e:	c3                   	ret    

0000086f <down>:
SYSCALL(down)
 86f:	b8 17 00 00 00       	mov    $0x17,%eax
 874:	cd 40                	int    $0x40
 876:	c3                   	ret    

00000877 <setuid>:
 877:	b8 19 00 00 00       	mov    $0x19,%eax
 87c:	cd 40                	int    $0x40
 87e:	c3                   	ret    

0000087f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 87f:	55                   	push   %ebp
 880:	89 e5                	mov    %esp,%ebp
 882:	83 ec 18             	sub    $0x18,%esp
 885:	8b 45 0c             	mov    0xc(%ebp),%eax
 888:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 88b:	83 ec 04             	sub    $0x4,%esp
 88e:	6a 01                	push   $0x1
 890:	8d 45 f4             	lea    -0xc(%ebp),%eax
 893:	50                   	push   %eax
 894:	ff 75 08             	pushl  0x8(%ebp)
 897:	e8 43 ff ff ff       	call   7df <write>
 89c:	83 c4 10             	add    $0x10,%esp
}
 89f:	90                   	nop
 8a0:	c9                   	leave  
 8a1:	c3                   	ret    

000008a2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 8a2:	55                   	push   %ebp
 8a3:	89 e5                	mov    %esp,%ebp
 8a5:	53                   	push   %ebx
 8a6:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 8a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 8b0:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 8b4:	74 17                	je     8cd <printint+0x2b>
 8b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 8ba:	79 11                	jns    8cd <printint+0x2b>
    neg = 1;
 8bc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 8c3:	8b 45 0c             	mov    0xc(%ebp),%eax
 8c6:	f7 d8                	neg    %eax
 8c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 8cb:	eb 06                	jmp    8d3 <printint+0x31>
  } else {
    x = xx;
 8cd:	8b 45 0c             	mov    0xc(%ebp),%eax
 8d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 8d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 8da:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 8dd:	8d 41 01             	lea    0x1(%ecx),%eax
 8e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8e3:	8b 5d 10             	mov    0x10(%ebp),%ebx
 8e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8e9:	ba 00 00 00 00       	mov    $0x0,%edx
 8ee:	f7 f3                	div    %ebx
 8f0:	89 d0                	mov    %edx,%eax
 8f2:	0f b6 80 34 10 00 00 	movzbl 0x1034(%eax),%eax
 8f9:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 8fd:	8b 5d 10             	mov    0x10(%ebp),%ebx
 900:	8b 45 ec             	mov    -0x14(%ebp),%eax
 903:	ba 00 00 00 00       	mov    $0x0,%edx
 908:	f7 f3                	div    %ebx
 90a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 90d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 911:	75 c7                	jne    8da <printint+0x38>
  if(neg)
 913:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 917:	74 2d                	je     946 <printint+0xa4>
    buf[i++] = '-';
 919:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91c:	8d 50 01             	lea    0x1(%eax),%edx
 91f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 922:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 927:	eb 1d                	jmp    946 <printint+0xa4>
    putc(fd, buf[i]);
 929:	8d 55 dc             	lea    -0x24(%ebp),%edx
 92c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92f:	01 d0                	add    %edx,%eax
 931:	0f b6 00             	movzbl (%eax),%eax
 934:	0f be c0             	movsbl %al,%eax
 937:	83 ec 08             	sub    $0x8,%esp
 93a:	50                   	push   %eax
 93b:	ff 75 08             	pushl  0x8(%ebp)
 93e:	e8 3c ff ff ff       	call   87f <putc>
 943:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 946:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 94a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 94e:	79 d9                	jns    929 <printint+0x87>
    putc(fd, buf[i]);
}
 950:	90                   	nop
 951:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 954:	c9                   	leave  
 955:	c3                   	ret    

00000956 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 956:	55                   	push   %ebp
 957:	89 e5                	mov    %esp,%ebp
 959:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 95c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 963:	8d 45 0c             	lea    0xc(%ebp),%eax
 966:	83 c0 04             	add    $0x4,%eax
 969:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 96c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 973:	e9 59 01 00 00       	jmp    ad1 <printf+0x17b>
    c = fmt[i] & 0xff;
 978:	8b 55 0c             	mov    0xc(%ebp),%edx
 97b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 97e:	01 d0                	add    %edx,%eax
 980:	0f b6 00             	movzbl (%eax),%eax
 983:	0f be c0             	movsbl %al,%eax
 986:	25 ff 00 00 00       	and    $0xff,%eax
 98b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 98e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 992:	75 2c                	jne    9c0 <printf+0x6a>
      if(c == '%'){
 994:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 998:	75 0c                	jne    9a6 <printf+0x50>
        state = '%';
 99a:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 9a1:	e9 27 01 00 00       	jmp    acd <printf+0x177>
      } else {
        putc(fd, c);
 9a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9a9:	0f be c0             	movsbl %al,%eax
 9ac:	83 ec 08             	sub    $0x8,%esp
 9af:	50                   	push   %eax
 9b0:	ff 75 08             	pushl  0x8(%ebp)
 9b3:	e8 c7 fe ff ff       	call   87f <putc>
 9b8:	83 c4 10             	add    $0x10,%esp
 9bb:	e9 0d 01 00 00       	jmp    acd <printf+0x177>
      }
    } else if(state == '%'){
 9c0:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 9c4:	0f 85 03 01 00 00    	jne    acd <printf+0x177>
      if(c == 'd'){
 9ca:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 9ce:	75 1e                	jne    9ee <printf+0x98>
        printint(fd, *ap, 10, 1);
 9d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9d3:	8b 00                	mov    (%eax),%eax
 9d5:	6a 01                	push   $0x1
 9d7:	6a 0a                	push   $0xa
 9d9:	50                   	push   %eax
 9da:	ff 75 08             	pushl  0x8(%ebp)
 9dd:	e8 c0 fe ff ff       	call   8a2 <printint>
 9e2:	83 c4 10             	add    $0x10,%esp
        ap++;
 9e5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 9e9:	e9 d8 00 00 00       	jmp    ac6 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 9ee:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 9f2:	74 06                	je     9fa <printf+0xa4>
 9f4:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 9f8:	75 1e                	jne    a18 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 9fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9fd:	8b 00                	mov    (%eax),%eax
 9ff:	6a 00                	push   $0x0
 a01:	6a 10                	push   $0x10
 a03:	50                   	push   %eax
 a04:	ff 75 08             	pushl  0x8(%ebp)
 a07:	e8 96 fe ff ff       	call   8a2 <printint>
 a0c:	83 c4 10             	add    $0x10,%esp
        ap++;
 a0f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a13:	e9 ae 00 00 00       	jmp    ac6 <printf+0x170>
      } else if(c == 's'){
 a18:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 a1c:	75 43                	jne    a61 <printf+0x10b>
        s = (char*)*ap;
 a1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a21:	8b 00                	mov    (%eax),%eax
 a23:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 a26:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 a2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a2e:	75 25                	jne    a55 <printf+0xff>
          s = "(null)";
 a30:	c7 45 f4 b2 0d 00 00 	movl   $0xdb2,-0xc(%ebp)
        while(*s != 0){
 a37:	eb 1c                	jmp    a55 <printf+0xff>
          putc(fd, *s);
 a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3c:	0f b6 00             	movzbl (%eax),%eax
 a3f:	0f be c0             	movsbl %al,%eax
 a42:	83 ec 08             	sub    $0x8,%esp
 a45:	50                   	push   %eax
 a46:	ff 75 08             	pushl  0x8(%ebp)
 a49:	e8 31 fe ff ff       	call   87f <putc>
 a4e:	83 c4 10             	add    $0x10,%esp
          s++;
 a51:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a58:	0f b6 00             	movzbl (%eax),%eax
 a5b:	84 c0                	test   %al,%al
 a5d:	75 da                	jne    a39 <printf+0xe3>
 a5f:	eb 65                	jmp    ac6 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 a61:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 a65:	75 1d                	jne    a84 <printf+0x12e>
        putc(fd, *ap);
 a67:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a6a:	8b 00                	mov    (%eax),%eax
 a6c:	0f be c0             	movsbl %al,%eax
 a6f:	83 ec 08             	sub    $0x8,%esp
 a72:	50                   	push   %eax
 a73:	ff 75 08             	pushl  0x8(%ebp)
 a76:	e8 04 fe ff ff       	call   87f <putc>
 a7b:	83 c4 10             	add    $0x10,%esp
        ap++;
 a7e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a82:	eb 42                	jmp    ac6 <printf+0x170>
      } else if(c == '%'){
 a84:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 a88:	75 17                	jne    aa1 <printf+0x14b>
        putc(fd, c);
 a8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a8d:	0f be c0             	movsbl %al,%eax
 a90:	83 ec 08             	sub    $0x8,%esp
 a93:	50                   	push   %eax
 a94:	ff 75 08             	pushl  0x8(%ebp)
 a97:	e8 e3 fd ff ff       	call   87f <putc>
 a9c:	83 c4 10             	add    $0x10,%esp
 a9f:	eb 25                	jmp    ac6 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 aa1:	83 ec 08             	sub    $0x8,%esp
 aa4:	6a 25                	push   $0x25
 aa6:	ff 75 08             	pushl  0x8(%ebp)
 aa9:	e8 d1 fd ff ff       	call   87f <putc>
 aae:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 ab1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 ab4:	0f be c0             	movsbl %al,%eax
 ab7:	83 ec 08             	sub    $0x8,%esp
 aba:	50                   	push   %eax
 abb:	ff 75 08             	pushl  0x8(%ebp)
 abe:	e8 bc fd ff ff       	call   87f <putc>
 ac3:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 ac6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 acd:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 ad1:	8b 55 0c             	mov    0xc(%ebp),%edx
 ad4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ad7:	01 d0                	add    %edx,%eax
 ad9:	0f b6 00             	movzbl (%eax),%eax
 adc:	84 c0                	test   %al,%al
 ade:	0f 85 94 fe ff ff    	jne    978 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 ae4:	90                   	nop
 ae5:	c9                   	leave  
 ae6:	c3                   	ret    

00000ae7 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ae7:	55                   	push   %ebp
 ae8:	89 e5                	mov    %esp,%ebp
 aea:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 aed:	8b 45 08             	mov    0x8(%ebp),%eax
 af0:	83 e8 08             	sub    $0x8,%eax
 af3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 af6:	a1 50 10 00 00       	mov    0x1050,%eax
 afb:	89 45 fc             	mov    %eax,-0x4(%ebp)
 afe:	eb 24                	jmp    b24 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b00:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b03:	8b 00                	mov    (%eax),%eax
 b05:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 b08:	77 12                	ja     b1c <free+0x35>
 b0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b0d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 b10:	77 24                	ja     b36 <free+0x4f>
 b12:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b15:	8b 00                	mov    (%eax),%eax
 b17:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 b1a:	77 1a                	ja     b36 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b1f:	8b 00                	mov    (%eax),%eax
 b21:	89 45 fc             	mov    %eax,-0x4(%ebp)
 b24:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b27:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 b2a:	76 d4                	jbe    b00 <free+0x19>
 b2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b2f:	8b 00                	mov    (%eax),%eax
 b31:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 b34:	76 ca                	jbe    b00 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 b36:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b39:	8b 40 04             	mov    0x4(%eax),%eax
 b3c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 b43:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b46:	01 c2                	add    %eax,%edx
 b48:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b4b:	8b 00                	mov    (%eax),%eax
 b4d:	39 c2                	cmp    %eax,%edx
 b4f:	75 24                	jne    b75 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 b51:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b54:	8b 50 04             	mov    0x4(%eax),%edx
 b57:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b5a:	8b 00                	mov    (%eax),%eax
 b5c:	8b 40 04             	mov    0x4(%eax),%eax
 b5f:	01 c2                	add    %eax,%edx
 b61:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b64:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 b67:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b6a:	8b 00                	mov    (%eax),%eax
 b6c:	8b 10                	mov    (%eax),%edx
 b6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b71:	89 10                	mov    %edx,(%eax)
 b73:	eb 0a                	jmp    b7f <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 b75:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b78:	8b 10                	mov    (%eax),%edx
 b7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b7d:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 b7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b82:	8b 40 04             	mov    0x4(%eax),%eax
 b85:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 b8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b8f:	01 d0                	add    %edx,%eax
 b91:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 b94:	75 20                	jne    bb6 <free+0xcf>
    p->s.size += bp->s.size;
 b96:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b99:	8b 50 04             	mov    0x4(%eax),%edx
 b9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b9f:	8b 40 04             	mov    0x4(%eax),%eax
 ba2:	01 c2                	add    %eax,%edx
 ba4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ba7:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 baa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bad:	8b 10                	mov    (%eax),%edx
 baf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bb2:	89 10                	mov    %edx,(%eax)
 bb4:	eb 08                	jmp    bbe <free+0xd7>
  } else
    p->s.ptr = bp;
 bb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bb9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 bbc:	89 10                	mov    %edx,(%eax)
  freep = p;
 bbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bc1:	a3 50 10 00 00       	mov    %eax,0x1050
}
 bc6:	90                   	nop
 bc7:	c9                   	leave  
 bc8:	c3                   	ret    

00000bc9 <morecore>:

static Header*
morecore(uint nu)
{
 bc9:	55                   	push   %ebp
 bca:	89 e5                	mov    %esp,%ebp
 bcc:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 bcf:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 bd6:	77 07                	ja     bdf <morecore+0x16>
    nu = 4096;
 bd8:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 bdf:	8b 45 08             	mov    0x8(%ebp),%eax
 be2:	c1 e0 03             	shl    $0x3,%eax
 be5:	83 ec 0c             	sub    $0xc,%esp
 be8:	50                   	push   %eax
 be9:	e8 59 fc ff ff       	call   847 <sbrk>
 bee:	83 c4 10             	add    $0x10,%esp
 bf1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 bf4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 bf8:	75 07                	jne    c01 <morecore+0x38>
    return 0;
 bfa:	b8 00 00 00 00       	mov    $0x0,%eax
 bff:	eb 26                	jmp    c27 <morecore+0x5e>
  hp = (Header*)p;
 c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 c07:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c0a:	8b 55 08             	mov    0x8(%ebp),%edx
 c0d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 c10:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c13:	83 c0 08             	add    $0x8,%eax
 c16:	83 ec 0c             	sub    $0xc,%esp
 c19:	50                   	push   %eax
 c1a:	e8 c8 fe ff ff       	call   ae7 <free>
 c1f:	83 c4 10             	add    $0x10,%esp
  return freep;
 c22:	a1 50 10 00 00       	mov    0x1050,%eax
}
 c27:	c9                   	leave  
 c28:	c3                   	ret    

00000c29 <malloc>:

void*
malloc(uint nbytes)
{
 c29:	55                   	push   %ebp
 c2a:	89 e5                	mov    %esp,%ebp
 c2c:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c2f:	8b 45 08             	mov    0x8(%ebp),%eax
 c32:	83 c0 07             	add    $0x7,%eax
 c35:	c1 e8 03             	shr    $0x3,%eax
 c38:	83 c0 01             	add    $0x1,%eax
 c3b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 c3e:	a1 50 10 00 00       	mov    0x1050,%eax
 c43:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c46:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 c4a:	75 23                	jne    c6f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 c4c:	c7 45 f0 48 10 00 00 	movl   $0x1048,-0x10(%ebp)
 c53:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c56:	a3 50 10 00 00       	mov    %eax,0x1050
 c5b:	a1 50 10 00 00       	mov    0x1050,%eax
 c60:	a3 48 10 00 00       	mov    %eax,0x1048
    base.s.size = 0;
 c65:	c7 05 4c 10 00 00 00 	movl   $0x0,0x104c
 c6c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c72:	8b 00                	mov    (%eax),%eax
 c74:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c7a:	8b 40 04             	mov    0x4(%eax),%eax
 c7d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 c80:	72 4d                	jb     ccf <malloc+0xa6>
      if(p->s.size == nunits)
 c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c85:	8b 40 04             	mov    0x4(%eax),%eax
 c88:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 c8b:	75 0c                	jne    c99 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c90:	8b 10                	mov    (%eax),%edx
 c92:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c95:	89 10                	mov    %edx,(%eax)
 c97:	eb 26                	jmp    cbf <malloc+0x96>
      else {
        p->s.size -= nunits;
 c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c9c:	8b 40 04             	mov    0x4(%eax),%eax
 c9f:	2b 45 ec             	sub    -0x14(%ebp),%eax
 ca2:	89 c2                	mov    %eax,%edx
 ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ca7:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cad:	8b 40 04             	mov    0x4(%eax),%eax
 cb0:	c1 e0 03             	shl    $0x3,%eax
 cb3:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cb9:	8b 55 ec             	mov    -0x14(%ebp),%edx
 cbc:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 cbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cc2:	a3 50 10 00 00       	mov    %eax,0x1050
      return (void*)(p + 1);
 cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cca:	83 c0 08             	add    $0x8,%eax
 ccd:	eb 3b                	jmp    d0a <malloc+0xe1>
    }
    if(p == freep)
 ccf:	a1 50 10 00 00       	mov    0x1050,%eax
 cd4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 cd7:	75 1e                	jne    cf7 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 cd9:	83 ec 0c             	sub    $0xc,%esp
 cdc:	ff 75 ec             	pushl  -0x14(%ebp)
 cdf:	e8 e5 fe ff ff       	call   bc9 <morecore>
 ce4:	83 c4 10             	add    $0x10,%esp
 ce7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 cea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 cee:	75 07                	jne    cf7 <malloc+0xce>
        return 0;
 cf0:	b8 00 00 00 00       	mov    $0x0,%eax
 cf5:	eb 13                	jmp    d0a <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
 cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d00:	8b 00                	mov    (%eax),%eax
 d02:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 d05:	e9 6d ff ff ff       	jmp    c77 <malloc+0x4e>
}
 d0a:	c9                   	leave  
 d0b:	c3                   	ret    
