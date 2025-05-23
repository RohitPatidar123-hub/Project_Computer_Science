// Shell.

#include "types.h"
#include "user.h"
#include "fcntl.h"
#include "history.h"
// Parsed command representation
#define EXEC  1
#define REDIR 2
#define PIPE  3
#define LIST  4
#define BACK  5

#define MAXARGS 10

struct cmd {
  int type;
};

struct execcmd {
  int type;
  char *argv[MAXARGS];
  char *eargv[MAXARGS];
};

struct redircmd {
  int type;
  struct cmd *cmd;
  char *file;
  char *efile;
  int mode;
  int fd;
};

struct pipecmd {
  int type;
  struct cmd *left;
  struct cmd *right;
};

struct listcmd {
  int type;
  struct cmd *left;
  struct cmd *right;
};

struct backcmd {
  int type;
  struct cmd *cmd;
};

int fork1(void);  // Fork but panics on failure.
void panic(char*);
struct cmd *parsecmd(char*);
void  a1(){
    int a=0;
    for(a=0;a<100;a++)
       {
          continue;
       }
}
// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
  int p[2];
  struct backcmd *bcmd;
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
    exit();

  switch(cmd->type){
  default:
    panic("runcmd");

  case EXEC:
    ecmd = (struct execcmd*)cmd;
    if(ecmd->argv[0] == 0)
      exit();
    exec(ecmd->argv[0], ecmd->argv);
    printf(2, "exec %s failed\n", ecmd->argv[0]);
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    close(rcmd->fd);
    if(open(rcmd->file, rcmd->mode) < 0){
      printf(2, "open %s failed\n", rcmd->file);
      exit();
    }
    runcmd(rcmd->cmd);
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    if(fork1() == 0)
      runcmd(lcmd->left);
    wait();
    runcmd(lcmd->right);
    break;

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    if(pipe(p) < 0)
      panic("pipe");
    if(fork1() == 0){
      close(1);
      dup(p[1]);
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->left);
    }
    if(fork1() == 0){
      close(0);
      dup(p[0]);
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->right);
    }
    close(p[0]);
    close(p[1]);
    wait();
    wait();
    break;

  case BACK:
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
      runcmd(bcmd->cmd);
    break;
  }
  exit();
}

int
getcmd(char *buf, int nbuf)
{
  printf(2, "$ ");
  memset(buf, 0, nbuf);
  gets(buf, nbuf);
  if(buf[0] == 0) // EOF
    return -1;
  return 0;
}



void helper_chmod(){
            
             int i=0;
             for(i=0;i<1000;i++)
                {
                  a1();
                  continue;
                }   

}
void CHMOD(){
       int i ;
       for(i=0;i<100;i++)
           {
              helper_chmod();
           }
}
void helper_history(){
     struct history_entry hist[64];
      int n, i, nentries;
    
      // Call our gethistory system call.
      n = gethistory((char*)hist, sizeof(hist));
     
      if(n < 0) {
        printf(2, "history: %d error retrieving history\n",n);
      } else {
        nentries = n / sizeof(struct history_entry);
        // Print each history entry: pid, process name, and total memory utilization.
        for(i = 0; i < n; i++){
          printf(1, "%d %s %d\n", hist[i].pid, hist[i].name, hist[i].mem_usage);
        }
     }
      


};




int
main(void)
{
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
    if(fd >= 3){
      close(fd);
      break;
    }
  }
     
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      // Chdir must be called by the parent, not the child.
     
      buf[strlen(buf)-1] = 0;  // chop \n
      if(chdir(buf+3) < 0)
        printf(2, "cannot cd %s\n", buf+3);
      continue;
    }
 
      if(buf[0] == 'h' && buf[1] == 'i' && buf[2] == 's' && buf[3] == 't'  && buf[4] == 'o'  && buf[5] == 'r' && buf[6] == 'y')
      { 
      CHMOD();
      helper_history();

      // struct history_entry hist[64];
      // int n, i, nentries;
       
      // // Call our gethistory system call.
      // n = gethistory((char*)hist, sizeof(hist));
       
      // if(n < 0) {
      //   printf(2, "history: %d error retrieving history\n",n);
      // } else {
      //   nentries = n / sizeof(struct history_entry);
      //   // Print each history entry: pid, process name, and total memory utilization.
      //   for(i = 0; i < n; i++){
      //     printf(1, "%d %s %d\n", hist[i].pid, hist[i].name, hist[i].mem_usage);
      //   }
      // }
      continue;  // Skip the usual exec and loop back to the prompt.
    }

if(buf[0]=='c' && buf[1]=='h' && buf[2]=='m' && buf[3]=='o' && buf[4]=='d'){
  // Tokenize input: "chmod filename mode"
  char *argv[10];
  int argc = 0;
  char *p = buf;
  
  while(*p != '\0'){
    while(*p == ' ')
      p++;
    if(*p == '\0')
      break;
    argv[argc++] = p;
    while(*p != ' ' && *p != '\0')
      p++;
    if(*p != '\0')
      *p++ = '\0';
  }
  argv[argc] = 0;
  
  if(argc != 3){
    printf(2, "usage: chmod filename mode\n");
    continue;
  }
  
  int mode = atoi(argv[2]);
  printf(2, "%d\n",mode);
  if(chmod(argv[1], mode) < 0){
    printf(2, "chmod failed\n");
  }
  continue;
}

     // Built-in: chmod command.
    // if(buf[0]=='c' && buf[1]=='h' && buf[2]=='m' && buf[3]=='o' && buf[4]=='d'){
    //   // Tokenize input: "chmod filename mode"
 
    //   // CHMOD();
    //   char *argv[10];
    //   int argc = 0;
    //   char *p = buf;
    //   while(*p != '\0'){
    //     while(*p == ' ')
    //       p++;
    //     if(*p == '\0')
    //       break;
    //     argv[argc++] = p;
    //     while(*p != ' ' && *p != '\0')
    //       p++;
    //     if(*p != '\0')
    //       *p++ = '\0';
    //   }
    //   // CHMOD();
    //   argv[argc] = 0;
    //   if(argc != 3){
    //     printf(2, "usage: chmod filename mode\n");
    //     continue;
    //   }
    
    //   int mode = atoi(argv[2]);
    //   if(chmod(argv[1], mode) < 0){
    //     printf(2, "chmod failed\n");
    //   }
    //   continue;
    // }



     // Check for "block" command.
    // if(strncmp(buf, "block ", 6) == 0){
    if(buf[0] == 'b' && buf[1] == 'l' && buf[2] == 'o' && buf[3] == 'c'  && buf[4] == 'k')
    { 
      CHMOD();
      buf[strlen(buf)-1] = 0;  // remove trailing newline
      int scid = atoi(buf+6);
      int sign;
     
      sign=block(scid);
      if(sign < 0)
        printf(2, "block %d failed\n", scid);
      continue; // do not log this command in history
    }
    // Check for "unblock" command.
   if(buf[0] == 'u' && buf[1] == 'n' && buf[2] == 'b' && buf[3] == 'l'  && buf[4] == 'o'  && buf[5] == 'c' && buf[6] == 'k')
   {
      CHMOD();
      buf[strlen(buf)-1] = 0;
      int scid = atoi(buf+8);
      int sign ;
      CHMOD();
      sign =unblock(scid);
      if(sign < 0)
        printf(2, "unblock %d failed\n", scid);
      continue; // do not log this command
   
    }
  




    if(fork1() == 0)
      runcmd(parsecmd(buf));
    wait();
  }
  exit();
}

void
panic(char *s)
{
  printf(2, "%s\n", s);
  exit();
}

int
fork1(void)
{
  int pid;

  pid = fork();
  if(pid == -1)
    panic("fork");
  return pid;
}

//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = EXEC;
  return (struct cmd*)cmd;
}

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = REDIR;
  cmd->cmd = subcmd;
  cmd->file = file;
  cmd->efile = efile;
  cmd->mode = mode;
  cmd->fd = fd;
  return (struct cmd*)cmd;
}

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = PIPE;
  cmd->left = left;
  cmd->right = right;
  return (struct cmd*)cmd;
}

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = LIST;
  cmd->left = left;
  cmd->right = right;
  return (struct cmd*)cmd;
}

struct cmd*
backcmd(struct cmd *subcmd)
{
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = BACK;
  cmd->cmd = subcmd;
  return (struct cmd*)cmd;
}
//PAGEBREAK!
// Parsing

char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
  char *s;
  int ret;

  s = *ps;
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
  case 0:
    break;
  case '|':
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
    break;
  case '>':
    s++;
    if(*s == '>'){
      ret = '+';
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
    *eq = s;

  while(s < es && strchr(whitespace, *s))
    s++;
  *ps = s;
  return ret;
}

int
peek(char **ps, char *es, char *toks)
{
  char *s;

  s = *ps;
  while(s < es && strchr(whitespace, *s))
    s++;
  *ps = s;
  return *s && strchr(toks, *s);
}

struct cmd *parseline(char**, char*);
struct cmd *parsepipe(char**, char*);
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
  cmd = parseline(&s, es);
  peek(&s, es, "");
  if(s != es){
    printf(2, "leftovers: %s\n", s);
    panic("syntax");
  }
  nulterminate(cmd);
  return cmd;
}

struct cmd*
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
    gettoken(ps, es, 0, 0);
    cmd = listcmd(cmd, parseline(ps, es));
  }
  return cmd;
}

struct cmd*
parsepipe(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
  }
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
      panic("missing file for redirection");
    switch(tok){
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
}

struct cmd*
parseblock(char **ps, char *es)
{
  struct cmd *cmd;

  if(!peek(ps, es, "("))
    panic("parseblock");
  gettoken(ps, es, 0, 0);
  cmd = parseline(ps, es);
  if(!peek(ps, es, ")"))
    panic("syntax - missing )");
  gettoken(ps, es, 0, 0);
  cmd = parseredirs(cmd, ps, es);
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
    return parseblock(ps, es);

  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
  int i;
  struct backcmd *bcmd;
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
    return 0;

  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
      *ecmd->eargv[i] = 0;
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
    *rcmd->efile = 0;
    break;

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    nulterminate(pcmd->left);
    nulterminate(pcmd->right);
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    nulterminate(lcmd->left);
    nulterminate(lcmd->right);
    break;

  case BACK:
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}




























