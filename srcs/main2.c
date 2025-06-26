#include <stdio.h>

extern void ft_atoi_base(const char *str);
extern char *ft_strdup(const char *str);
extern size_t ft_strlen(const char *str);
extern char *ft_strcpy(char *dest, const char *src);
extern int ft_strcmp(const char *s1, const char *s2);
extern size_t ft_write(int fd, const void *buf, size_t count);
extern size_t ft_read(int fd, const void *buf, size_t count);

int main(int ac, char **av)
{
  ft_atoi_base(av[1]);
  return 0;
}

