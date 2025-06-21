global ft_write

section .data
  err_msg db "NULL string can't be written", 0xa
  err_length equ $ - err_msg

section .text
  ft_write:
    test rsi,rsi ; check for null string
    jz err ; go err label if its null
    mov rax, 0x1
    syscall
    ret

  err:
    mov rax, 1
    mov rdi, 2
    mov rsi, err_msg
    mov rdx, err_length
    syscall

    mov rax, 60
    mov rdi, 0x1
    syscall

section .note.GNU-stack
