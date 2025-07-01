#include <stdio.h>

// extern int ft_atoi_base(const char *str, const char *base);
int ft_atoi_base(char *str, char *base);

int main(int ac, char **av)
{
  int result = ft_atoi_base(av[1], "01");
  printf("%i\n",result);
  return 0;
}
