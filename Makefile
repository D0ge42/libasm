NAME = libasm.a

ASM = nasm
ASMFLAGS = -f elf64
CC = gcc

SRC_DIR = srcs
OBJ_DIR = objs
EXEC = program.c

SRC = srcs/ft_strlen.s
CSRCS = srcs/main.c

OBJ = $(SRC:$(SRC_DIR)/%.s=$(OBJ_DIR)/%.o)

AR = ar rcs

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.s
	@mkdir -p $(dir $@)
	$(ASM) $(ASMFLAGS) -o $@ $<

$(NAME): $(OBJ)
	$(AR) $@ $^

exec: $(NAME)
	$(CC) $(CFLAGS) $(TEST_SRC) -L. -lasm -o $(EXEC)

all: $(NAME)

clean:
	rm -rf $(OBJ_DIR)

fclean: clean
	rm -f $(NAME)

re: fclean all

.PHONY: all clean fclean re

