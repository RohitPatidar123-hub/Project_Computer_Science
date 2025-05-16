// init.c: The initial user-level program
#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
//#include "login.h"   // Include our login() declaration



char *argv[] = { "sh", 0 };



#define ATTEMP 3

// A helper to remove the trailing newline from gets()
void trim(char *s) {
  int i;
  for(i = 0; s[i] != '\0'; i++){
    if(s[i] == '\n'){
      s[i] = '\0';
      break;
    }
  }
}

int login(void) {
  char username[32];
  char password[32];
  int attempts = 0;

  while(attempts < ATTEMP) {
    printf(1, "Enter username: ");
    gets(username, sizeof(username));
    trim(username);

    if(strcmp(username, USERNAME) == 0) {
      printf(1, "Enter password: ");
      gets(password, sizeof(password));
      trim(password);

      if(strcmp(password, PASSWORD) == 0) {
        printf(1, "Login successful\n");
        return 1;  // Valid login
      } else {
        printf(1, "Incorrect password\n");
        attempts++;
      }
    } else {
      printf(1, "Incorrect username\n");
      attempts++;
    }
  }

  printf(1, "Maximum login attempts exceeded. Login disabled.\n");
  return 0;  // Invalid login
}

int checkAuthentication(void) {
  if(login() == 1)
    return 1;
  else
    return 0;
}

int main(void) {
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  dup(0);  // stderr

  // Check login credentials before launching the shell.
  if(checkAuthentication() == 0) {
    printf(1, "Authentication failed. Exiting init.\n");
     while(1) {
        sleep(1000);
    }
    exit();
  }

  // Authentication succeeded; launch the shell.
  for(;;) {
    printf(1, "init: starting sh\n");
    pid = fork();
    if(pid < 0){
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid = wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  }
}
