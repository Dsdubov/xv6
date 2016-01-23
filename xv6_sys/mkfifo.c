#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  int i;

  if(argc < 2){
    printf(2, "Usage: mkfifo files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
    if(mkfifo(argv[i]) < 0){
      printf(2, "mkfifo: %s failed to create\n", argv[i]);
      break;
    }
  }

  exit();
}