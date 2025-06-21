#include <stddef.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>

size_t ft_read(int fd, const char *c, size_t count);


int main(int ac, char **av)
{
  int fd = open("hello_world.s", O_RDONLY);
  char str[11];
  printf("%zu\n",ft_read(fd,str,10));
  printf("%s\n",str);
  return 0;
}
