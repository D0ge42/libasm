default rel
global ft_atoi_base
extern printf

section .rodata
  fmt db "%p", 0xA


ft_atoi_base:
  push rbp
  mov rbp, rsp

  sub rsp, 8
  call printf wrt ..plt
  add rsp, 8

  call f_skip_wspaces

  sub rsp, 8

  mov rsi, rdi
  lea rdx,fmt
  call printf wrt ..plt

  add rsp, 8

  mov rsp, rbp
  pop rbp
  ret


  f_skip_wspaces:
  l1:
  mov al, [rdi]
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
  inc rdi
  jmp l1


section .note.GNU-stack
