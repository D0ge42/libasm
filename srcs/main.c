#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>

extern char *ft_strdup(const char *str);
extern size_t ft_strlen(const char *str);
extern char *ft_strcpy(char *dest, const char *src);
extern int ft_strcmp(const char *s1, const char *s2);
extern size_t ft_write(int fd, const void *buf, size_t count);
extern size_t ft_read(int fd, const void *buf, size_t count);

void test_strlen();
void test_strdup();
void test_strcpy();
void test_strcmp();
void test_write();
void test_read();

int main()
{
  printf("=== Starting Tests ===\n\n");
  test_strlen();
  printf("\n");

  test_strdup();
  printf("\n");

  test_strcpy();
  printf("\n");

  test_strcmp();
  printf("\n");

  test_write();
  printf("\n");

  test_read();
  printf("\n");

  printf("✅ All tests passed!\n");
  return 0;
}

void test_strlen()
{
  printf("Testing ft_strlen with empty string: ");
  assert(ft_strlen("") == 0);
  printf("Length = 0, Ok ✅ \n");

  printf("Testing ft_strlen with NULL string: ");
  assert(ft_strlen(NULL) == 0);
  printf("Length = 0, Ok ✅ \n");

  printf("Testing ft_strlen with normal string: ");
  assert(ft_strlen("Hello world") == strlen("Hello world"));
  printf("Length = %zu, Ok ✅ \n", ft_strlen("Hello world"));

  const char *long_str = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
  printf("Testing ft_strlen with very long string: ");
  assert(ft_strlen(long_str) == strlen(long_str));
  printf("Length = %zu, Ok ✅ \n", ft_strlen(long_str));
}

void test_strdup()
{
  printf("Testing ft_strdup with empty string: ");
  char *dup = ft_strdup("");
  assert(strcmp(dup, "") == 0);
  printf("Result = \"%s\", Ok ✅ \n", dup);
  free(dup);

  printf("Testing ft_strdup with normal string: ");
  dup = ft_strdup("Hello world");
  assert(strcmp(dup, "Hello world") == 0);
  printf("Result = \"%s\", Ok ✅ \n", dup);
  free(dup);

  printf("Testing ft_strdup with NULL string: ");
  dup = ft_strdup(NULL);
  assert(dup == NULL);
  printf("Returned NULL, Ok ✅ \n");
}

void test_strcpy()
{
  char dest[100];

  printf("Testing ft_strcpy with normal string: ");
  assert(strcmp(ft_strcpy(dest, "Hello"), "Hello") == 0);
  printf("Dest = \"%s\", Ok ✅ \n", dest);

  printf("Testing ft_strcpy with empty string: ");
  assert(strcmp(ft_strcpy(dest, ""), "") == 0);
  printf("Dest = \"%s\", Ok ✅ \n", dest);
}

void test_strcmp()
{
  printf("Testing ft_strcmp with identical strings: ");
  assert(ft_strcmp("abc", "abc") == strcmp("abc", "abc"));
  printf("Ok ✅ \n");

  printf("Testing ft_strcmp with different strings: ");
  assert(ft_strcmp("abc", "abd") == strcmp("abc", "abd"));
  printf("Ok ✅ \n");
}

void test_write()
{
  errno = 0;
  printf("Testing ft_write with STDOUT: ");
  ssize_t written = ft_write(1, "Hello from ft_write\n", 20);
  assert(written == 20);
  printf("Bytes written = %zd, errno = %i, Ok ✅ \n", written, errno);

  errno = 0;
  printf("Testing ft_write with invalid fd: ");
  written = ft_write(-1, "test", 4);
  assert(written == (size_t)-1);
  printf("Bytes written = %zd, errno = %i, Ok ✅ \n", written, errno);

  errno = 0;
  printf("Testing ft_write with negative count: ");
  written = ft_write(1, "Hello from ft_write\n", -10);
  assert(written == (size_t)-1);
  printf("Bytes written = %zd, errno = %i, Ok ✅ \n", written, errno);
}

void test_read()
{
  printf("Testing ft_read from file: ");
  char buf[100] = {0};
  int fd = open("test_read_file.txt", O_CREAT | O_WRONLY | O_TRUNC, 0644);
  write(fd, "Hello ft_read", 13);
  close(fd);

  fd = open("test_read_file.txt", O_RDONLY);
  ssize_t read_bytes = ft_read(fd, buf, 14);
  assert(read_bytes == 13);
  buf[read_bytes] = '\0';
  printf("Read content = \"%s\", errno = %i, Ok ✅ \n", buf, errno);
  close(fd);
  remove("test_read_file.txt");

  errno = 0;
  printf("Testing ft_read with invalid fd: ");
  read_bytes = ft_read(-1, buf, 10);
  assert(read_bytes == (size_t)-1);
  read_bytes = ft_read(-1, buf, 10);
  printf("Returned -1 as expected, errno = %i Ok ✅ \n",errno);

  printf("Testing ft_read with negative count: ");
  read_bytes = ft_read(1, buf, -42);
  assert(read_bytes == (size_t)-1);
  printf("Returned -1 as expected, errno = %i Ok ✅ \n",errno);
}
