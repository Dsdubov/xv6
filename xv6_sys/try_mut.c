#include "types.h"
#include "stat.h"
#include "user.h"
int
main(int argc, char *argv[])
{
  if (!fork()) {
    char s1[] = "In son1, some big text, some big text, some big text, some big text, some big text\n!";
    down(0);
    printf(1, "%s\n", s1);
    up(0);
    exit();
  } else {
    if (!fork()) {
      char s2[] = "In son2, SOME BIG TEXT, SOME BIG TEXT, SOME BIG TEXT, SOME BIG TEXT, SOME BIG TEXT\n!";
      down(0);
      printf(1, "%s\n", s2);
      up(0);
      exit();
    }
    wait();
    wait();
  }
  exit();
}