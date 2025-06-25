NAME = libasm.a

ASM = nasm
ASMFLAGS = -f elf64 -g -F dwarf
CFLAGS = -g
CC = gcc

SRC_DIR = srcs
OBJ_DIR = objs
EXEC = test

SRC = srcs/ft_strlen.s \
	  srcs/ft_strcpy.s \
	  srcs/ft_strdup.s \
	  srcs/ft_strcpy.s \
	  srcs/ft_strcmp.s \
	  srcs/ft_write.s \
	  srcs/ft_read.s \
	  srcs/ft_atoi_base.s \

CSRCS = srcs/main2.c

OBJ = $(SRC:$(SRC_DIR)/%.s=$(OBJ_DIR)/%.o)

AR = ar rcs

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.s
	@mkdir -p $(dir $@)
	$(ASM) $(ASMFLAGS) -o $@ $<

$(NAME): $(OBJ)
	$(AR) $@ $^

exec: $(NAME)
	$(CC) $(CFLAGS) $(CSRCS) -L. -lasm -o $(EXEC)

all: $(NAME) exec

run: $(EXEC)
	./$(EXEC)

clean:
	rm -rf $(OBJ_DIR)

fclean: clean
	rm -f $(NAME)
	rm -f $(EXEC)

re: fclean all

.PHONY: all clean fclean re

