#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern long ft_strlen(const char *str);
extern char *ft_strcpy(char *dst, const char *src);

int main()
{
  const char *src = "String copied :)\n";
  char *dest = malloc(ft_strlen(src) + 1);
  printf("%s",ft_strcpy(dest,src));
}
