#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>

char *ft_strdup(char *str);


int main(int ac, char **av)
{
  printf("%s\n",ft_strdup("ciao"));
  return 0;
}
