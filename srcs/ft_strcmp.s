global ft_strcmp

section .data
  err dw "Please, provide two args", 0xA
  err_len equ $ - err

section .text
ft_strcmp:
  test rdi,rdi
  jz error
  test rsi,rsi
  jz error
  l1:
    mov al,[rdi]
    mov cl,[rsi]
    cmp al,cl
    jne done
    test al,al
    je done
    inc rdi
    inc rsi
    jmp l1

    done:
    movzx eax,al
    movzx ecx,cl
    sub eax, ecx
    ret

    error:
    mov rax, 1
    mov rdi, 2
    mov rsi, err
    mov rdx, err_len
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall



section .note.GNU-stack
