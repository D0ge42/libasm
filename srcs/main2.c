#include <stdio.h>

extern int ft_atoi_base(const char *str, const char *base);
// int ft_atoi_base(char *str, char *base);

int main(int ac, char **av)
{
  int result = ft_atoi_base(av[1], "0123456789ABCDEF");
  printf("%i\n",result);
  return 0;
}

// #include <stdio.h>
//
// int	sanitized_base(char *base)
// {
// 	char	*buffer;
// 	int		n;
//
// 	n = 0;
// 	while (*base)
// 	{
// 		if (*base == '+' || *base == '-' || *base == ' ')
// 			return (0);
// 		buffer = base;
// 		while (*buffer++)
// 		{
// 			if (*buffer == *base)
// 				return (0);
// 		}
// 		n++;
// 		base++;
// 	}
// 	return (n);
// }
// int	find_index(char c, char *str)
// {
// 	int	index;
//
// 	index = 0;
// 	while (*str)
// 	{
// 		if (c == *str)
// 			return (index);
// 		str++;
// 		index++;
// 	}
// 	return (-1);
// }
//
// int	has_char(char c, char *str)
// {
// 	while (*str)
// 	{
// 		if (c == *str)
// 			return (1);
// 		str++;
// 	}
// 	return (0);
// }
//
// int	ft_atoi_base(char *str, char *base)
// {
// 	int		sign;
// 	int		number;
// 	int		n;
//
// 	n = sanitized_base(base);
// 	if (n < 2)
// 		return (0);
// 	sign = 1;
// 	number = 0;
// 	while (*str)
// 	{
// 		if (*str == '-')
// 			sign *= -1;
// 		else if (has_char(*str, base))
// 		{
// 			while (has_char(*str, base))
// 			{
// 				number = n * number + find_index(*str, base);
// 				str++;
// 			}
// 			break ;
// 		}
// 		str++;
// 	}
// 	return (sign * number);
// }
