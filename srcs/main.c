#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int ft_strcmp(const char *s1, const char *s2);

int main(int ac, char **av)
{
  int i = 0;
  int res = ft_strcmp(av[1],av[2]);
  printf("%i\n",res);
}
