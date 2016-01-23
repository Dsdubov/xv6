
# XV6_Dubov
## Student
Dubov Dmitry
## Group
National Research University Higher School of Economics, Faculty of computer science, Applied Mathematics and Informatics, Group 144
## The list of done Tasks
***
###1. Realize the extension of system call **exec()** for executable scripts.
In the original xv6, the system call **exec()** could work only with executable files - *elf* files, not with *scripts*. The goal was to provide the possibility to run the scripts *files* (which begins with: **#usr/bin/python ...**) using **exec()**.
Now, **exec()** can run scripts.
The checking on ***shabang*** was added in *exec.c* file:
```
...
if (readi(ip, sh, 0, 2) > 0) {
      if (sh[0] == '#' && sh[1] == '!') {
        for(j = 2; readi(ip, buf, j, 1) == 1 && buf[0] != '\n'; ++j)
...
```
For running scripts which refers to other scripts, it was crucial to allow exec work with recursion of scripts. In order to get that done, I added an extra function **_exec()**, which has limit of recursion = 5:
```
int rec_lim = 0;
const int MAX_LIM = 5;


int _exec(char * path, char ** argv){
  ++rec_lim;
  if (rec_lim < MAX_LIM)
    return exec(path, argv);
  else
    return -1;   
}
```
And if the script is correct I call this function:
```
...
int res = _exec(interp, nArgv);
...
```
***
###2. Realize the system call **mkfifo()**
**mkfifo()** create named pipes (FIFOs) with the given NAMEs.
A FIFO special file is similar to a pipe, except that it is created in a different way.
Instead of being an anonymous communications channel, a FIFO special file is entered into the filesystem by calling mkfifo().
My task was to realize the *system call* **mkfifo()** in *xv6*.
I added the new file - **mkfifo.c**, which called creation of a named pipe in a system. Also, the new system call **mkfifo()** was added in all necessary files in system:

In **syscall.c**:```extern int sys_mkfifo(void);```

In **syscall.h**:```#define SYS_mkfifo 22```

In **user.h**:```int mkfifo(char*);```

In **usys.S**:```SYSCALL(mkfifo)```

In **user.h**:```int mkfifo(char*);```

A new type of inode structure was added in **stat.h**:```#define T_FIFO 4   //Named pipe```

And the syscall itself was added in **sysfile.c**. The syscall mkfifo calls create.
For fifo's working I added new pointer to *struct file ** by the **inode struct** in **file.h**:
```
// add two fields, struct file * - pointer to write and read. 
  struct file * rf;
  struct file * wf;
//
```

For working with *fifo*, I need to change the *syscall* **sys_open()** in **sysfile.c**. The block of code, which checks whether the file is *T_FIFO* or not, and does the needable comands was added.
Firstly, I check was the *pipe* in *fifo* already initialized or not. If not, i call *pipeallock* for two *struct file* - **rf** and **wf**.
If the *pipe* was already initialized,depends on mode: *read* or *write*, i work with necessary *struct file*.
By the implementation of *fifo's* work, there were used such functions as:**acquire**, **wakeup**, **sleep**, **release**.

###3. Binary semaphore
In **sysfile.c** were added to *syscalls* - **sys_up()** and **sys_down()**. They work with *spinlock struct* and "binary" array. Using functions *acquire(), sleep() and release()* we implement the binary semaphore in our system. For waiting of necessary proc, which has upped the semaphore we use extra array - *proc*.

###4. Login, password, multiuser mode.
Added possibility to log in with username and password. Also to functions - **useradd** and **passwd** added. First makes new user, second can change the password by the user. User names and passwords contains in file *pass*. (to log in in system: **username** == *user*, **password** = *p)
Also was addedd syscall *setuid()* - for changing uid and euid int the proc.