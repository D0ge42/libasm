section .data

  msg dw "Hello world", 0xA
  msg_l equ $ - msg

section .text
  global _start

_start:
  mov rax, 1 ;write syscall
  mov rdi, 1 ;stdout fd
  mov rsi, msg ; message to be printed
  mov rdx, msg_l ; message len
  SYSCALL

  mov rax, 60
  xor rdi, rdi
  SYSCALL
