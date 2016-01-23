#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
#include "x86.h"

char * finduid(char * file) {
	int LEN = 1000;
	char lastuid[LEN];
	char res[LEN];
	char * p = lastuid;
	int counter = 0;
	int i;
	for(i = 0; file[i]; ++i) {
		if (file[i] == '\n') {
			counter = 0;
			continue;
		}
		if (counter == 2)
			*p++=file[i];
		if (file[i] == ':') {
			++counter;
			if (counter == 2)
				p = lastuid;
		}
	}
	*p++ = '\0';
	int uid = atoi(lastuid);
	++uid;
	char * ptr = res;
	while (uid) {
    *ptr++ = '0' + uid % 10;
    uid /= 10;
  }
  ptr = res;
	return ptr;
}

int useradd(char *name) {
	int LEN = 1000;
	int j;
	char string[LEN];
	char buf[1];
	int fd = open("/pass", O_RDONLY);

  char * p = string;
  for(j = 0; read(fd, buf, 1) == 1 && buf[0] != '\0'; ++j) {
    *p++ = buf[0];
  }
  *p = '\0';
  close(fd);
  
  if(!fork()) {
  	char *argv[] = {"rm", "/pass"};
  	exec("rm", argv);
  	exit();
  }
  wait();

  char * newuid = finduid(string);
  char * ptr = name;

  while(*ptr != '\0') {
  	*p++ = *ptr++;
  }
  *p++ = ':';
  *p++ = ':';
  int i;
  for(i = 0; newuid[i] != '\0'; ++i) {
	  *p++ = newuid[i];
  }
  *p++ = '\n';
  *p++ = '\0';
  fd = open("/pass", O_WRONLY | O_CREATE);
  write(fd, string, strlen(string) + 1);
  return 0;
}

int
main(int argc, char *argv[])
{
  if(argc < 2){
    printf(2, "Usage: useradd files...\n");
    exit();
  }

	if(useradd(argv[1]) < 0){
	  printf(2, "useradd: %s failed to add user\n");
	}

  exit();
}