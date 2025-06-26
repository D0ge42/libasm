#include <stdio.h>

extern void ft_atoi_base(const char *str, char *base);

int main(int ac, char **av)
{
  ft_atoi_base(av[1],"0A");
  return 0;
}

