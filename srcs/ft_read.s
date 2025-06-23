; in this case its a basic read function from man 2 read.
; We're also using function prologue and epilogue.

; From Wikipedia
; A function prologue typically does the following actions if the architecture has a base pointer (also known as frame pointer) and a stack pointer:

; Pushes current base pointer onto the stack, so it can be restored later.
; Value of base pointer is set to the address of stack pointer (which is pointed to the top of the stack) so that the base pointer will point to the top of the stack.

; So basically it works as a bookmark that sticks to the top of the rsp.

; From Wikipedia
; Function epilogue reverses the actions of the function prologue and returns control to the calling function. It typically does the following actions (this procedure may differ from one architecture to another):

;Pops the base pointer off the stack, so it is restored to its value before the prologue.
;Returns to the calling function, by popping the previous frame's program counter off the stack and jumping to it.

;errno works with 32 bit signed integers i believe, so we must set dword[rax](value pointed by the
;memory address) to a 32bit positive integer, indicating the error.



global ft_read
extern __errno_location

section .text
ft_read:
  push rbp      ; prologue
  mov rbp, rsp  ; prologue
  movsx rdi,edi
  cmp rdi,0
  jl err_fd

  movsx rdx,edx
  cmp rdx,0
  jl enegcount

  mov rax, 0  ; read
  syscall

  mov rsp, rbp ; epilogue
  pop rbp      ; epilogue
  ret

err_fd:
  call __errno_location wrt ..plt
  mov dword[rax], 0x9
  mov rax, -1
  mov rsp, rbp ; epilogue
  pop rbp      ; epilogue
  ret
enegcount:
  call __errno_location wrt ..plt
  mov dword[rax], 0x16
  mov rax, -1
  mov rsp, rbp ; overwrite the stack pointer with  base pointer
  pop rbp   ; pop base pointer to original state
  ret

section .note.GNU-stack

