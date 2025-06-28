; when we call a non-internal function the stack must be 16 bytes aligned.
; since at the start we push rbp, stack is now 8 bytes misaligned.
; but then we call printf and "call" pushes the return address on the stack, making it aligned for a
; function call.

section .text
  default rel
  global ft_atoi_base
  extern printf
  extern ft_strlen

ft_atoi_base:
  push rbp ; +8
  mov rbp, rsp

  mov r12, rsi ; save string in calle-saved register.
  mov rsi, rdi ; store str in 2nd arg of printf
  mov r13, rdi ; save string in calle-saved register.

  lea rdi, [fmt] ; put fmt value inside rdi
  call printf wrt ..plt ; call printf + 8 but -8 when ret

  mov rsi, r13 ;
  call f_skip_wspaces ; this should return updated pointer to rsi

  lea rdi, [fmt]

  call printf wrt ..plt

  call f_check_base

  mov rsp, rbp
  pop rbp
  ret


  f_check_base:

  ; check base_len
  mov rdi, r12
  mov r14, r12
  call ft_strlen
  cmp rax, 0x1
  je l_base_len_err

  xor al, al ; clean previously used al reg

  l2:
  ;loops that check for invalid chars in the base

  ; check if end is reached
  mov al, [r12]
  test al, al
  je l_ok

  ; char comparison
  cmp al, 0x2B
  je l_base_err
  cmp al, 0x2D
  je l_base_err
  cmp al, 0x20
  je l_base_err

  ;loops to check if curr char is duplicated in the base
  l_double_check:
  mov bl, [r12 + 4]
  test bl, bl

  cmp al, bl
  je l_duplicate

  l_done_checking:
  inc r12 ; inc r12
  jmp l2 ; loop again

  l_ok:
    ret

  l_duplicate_err:
  mov rax, 0x1
  mov rdi, 0x2
  lea rsi, ERR_DUP
  mov rdx, ERR_DUP_LEN
  syscall

  mov rax, 60
  mov rdi, 1
  syscall

  l_base_err:
  mov rax, 0x1
  mov rdi, 0x2
  lea rsi, ERR_HEXA
  mov rdx, ERR_HEXA_LEN
  syscall

  mov rax, 60
  mov rdi, 1
  syscall

  l_base_len_err:
  mov rax, 0x1
  mov rdi, 0x2
  lea rsi, ERR_BTS
  mov rdx, ERR_BTS_LEN
  syscall

  mov rax, 60
  mov rdi, 1
  syscall

  f_skip_wspaces:
  l1:
  mov al, [rsi]
  cmp al, 0x9
  je l_inc
  cmp al, 0xA
  je l_inc
  cmp al, 0xB
  je l_inc
  cmp al, 0xC
  je l_inc
  cmp al, 0xD
  je l_inc
  cmp al, 0x20
  je l_inc
  ret

  l_inc:
  inc rsi
  jmp l1

section .data
  ERR_HEXA db "Error: base can only contain hexadecimal values", 0xa
  ERR_HEXA_LEN equ $- ERR_HEXA

  ERR_BTS db "Error: base has to contain at least 2 hexadecimal values", 0xa
  ERR_BTS_LEN equ $- ERR_BTS

  ERR_DUP db "Error: base has duplicates", 0xa
  ERR_DUP_LEN equ $- ERR_BTS

section .rodata
  fmt db "%s", 0xA

section .note.GNU-stack
