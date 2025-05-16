// login.c
#include "types.h"
#include "stat.h"
#include "user.h"

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
    printf(1, "Enter Username: ");
    gets(username, sizeof(username));
    trim(username);

    if(strcmp(username, USERNAME) == 0) {
      printf(1, "Enter Password: ");
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
