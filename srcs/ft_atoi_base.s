; when we call a non-internal function the stack must be 16 bytes aligned.
; since at the start we push rbp, stack is now 8 bytes misaligned.
; but then we call printf and "call" pushes the return address on the stack, making it aligned for a
; function call.

section .text
  default rel
  global ft_atoi_base
  extern printf

ft_atoi_base:
  push rbp ; +8
  mov rbp, rsp

  mov rsi, rdi ; store str in 2nd arg of printf
  mov r12, rdi ; save string in calle-saved register.

  lea rdi, [fmt] ; put fmt value inside rdi
  call printf wrt ..plt ; call printf + 8 but -8 when ret

  mov rsi, r12 ;
  call f_skip_wspaces ; this should return updated pointer to rsi

  lea rdi, [fmt]

  call printf wrt ..plt

  mov rsp, rbp
  pop rbp
  ret


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


section .rodata
  fmt db "%s", 0xA

section .note.GNU-stack
