#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int passwd(char * username) {
	int LEN = 100;
	char string[LEN];
	char oldpass[LEN];
	char roldpass[LEN];
	char newpass[LEN];
	char curname[LEN];
	char buf[1];

	//read file - pass
  int fd = open("/pass", O_RDONLY);
  char * p = string;
  int j;
  for(j = 0; read(fd, buf, 1) == 1 && buf[0] != '\0'; ++j) {
    *p++ = buf[0];
  }
  *p = '\0';
  close(fd);

  // find username and old password
	int endpos;
	endpos = 0;
  int namepos;
  namepos = 0;
  char * ptr = curname;
  char * ropp = roldpass;
  int flag = 0;
  int counter = 0;
  int i;
  for(i = 0; string[i]; ++i) {
  	if(!counter && string[i] != ':') {
  		*ptr++ = string[i];
  	}
  	if(counter == 1 && string[i] != ':') {
  		*ropp++ = string[i];
  	}
  	if(string[i] == ':')
  		++counter;
  		if(counter == 1) {
  			*ptr++ = '\0';
  		}
  		if(counter == 2) {
  			*ropp++ = '\0';
  		}
  	if (string[i] == '\n') {
  		if(!strcmp(username, curname)) {
  			endpos = i;
  			flag = 1;
  			break;
  		}
  		ptr = curname;
  		ropp = roldpass;
  		namepos = i + 1;
  		counter = 0;
  	}
  }
  if(!flag) {
  	return -1;
	}
  //change pass
  printf(1, "enter old password for %s: ", curname);
  char * opp = oldpass;
  for(j = 0; read(0, buf, 1) == 1 && buf[0] != '\n'; ++j){
    *opp++ = buf[0];
  }
  *opp = '\0';
  if(strcmp(oldpass, roldpass)) {
  	printf(2, "passwd: wrong old password for %s\n", username);
  	return -1;
  }
  printf(1, "enter new password for %s: ", curname);
  char * npp = newpass;
  for(j = 0; read(0, buf, 1) == 1 && buf[0] != '\n'; ++j){
    *npp++ = buf[0];
  }
  *npp = '\0';

  // rewrite pass, with new password for user
  if(!fork()) {
  	char *argv[] = {"rm", "/pass"};
  	exec("rm", argv);
  	exit();
  }
  wait();
  fd = open("/pass", O_WRONLY | O_CREATE);
  write(fd, string, namepos);
  write(fd, curname, strlen(curname));
  write(fd, ":", 1);
  write(fd, newpass, strlen(newpass));
  write(fd, ":", 1);
  char * uid = &string[namepos + strlen(curname) + strlen(oldpass) + 2];
  write(fd, uid, strlen(uid) + 1);
  // write(fd, "\n", 1);
  char * end = &string[endpos + 1];
  write(fd, end, strlen(end));
  close(fd);
  return 0;
}

int
main(int argc, char *argv[])
{
    if (argc < 2){
        printf(2, "no username\n");
        exit();
    }

    if (passwd(argv[1]) < 0)
      printf(2, "passwd: password for %s failed to be changed\n", argv[1]);

    exit();
}
