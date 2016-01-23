#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int
main()
{
    int LEN = 10;
    char string[LEN * 2 + 3];
    char login[LEN];
    char password[LEN];
    char * passwd_passwd;
    char buf[1];
    int j;
    int flag;
    int fd = open("/pass", O_RDONLY);

    char * p = string;
    for(j = 0; read(fd, buf, 1) == 1 && buf[0] != '\n'; ++j) {
      *p++ = buf[0];
    }
    *p = '\0';

    // parse string
    char * passwd_login = string;
    flag = 0;
    for (j = 0; string[j]; ++j) {
        if (string[j] == ':' && !flag) {
            string[j] = '\0';
            passwd_passwd = &string[j + 1];
            flag = 1;
        } else if (string[j] == ':') {
            string[j] = '\0';
            break;
        }
    }

    //read username
    printf(1, "username: ");
    char * p_login = login;
    for(j = 0; read(0, buf, 1) == 1 && buf[0] != '\n'; ++j){
      *p_login++ = buf[0];
    }
    *p_login = '\0';

    if (strcmp(passwd_login, login) != 0) {
        printf(2, "failed to login as %s\n", login);
        printf(2, "real username is %s\n", passwd_login);
        exit();
    }

    // read pass from consol
    printf(1, "password: ");
    char * p_psswd = password;
    for(j = 0; read(0, buf, 1) == 1 && buf[0] != '\n'; ++j){
      *p_psswd++ = buf[0];
    }
    *p_psswd = '\0';

    if (strcmp(password, passwd_passwd) != 0) {
        printf(2, "wrong password\n");
        printf(2, "real passwd is %s\n", passwd_passwd);
        exit();
    }
    char *argv[] = { "sh", 0 };
    setuid(0);
    exec("sh", argv);
    exit();
}