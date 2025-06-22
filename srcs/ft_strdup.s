;the words caller and callee are used to denote the function doing the calling and the function which gets called.
;basically, since we're making different calls to function in ft_strdup, values that are situated in
;Caller-saved registers: (AKA volatile registers, or call-clobbered) might get overwritten.

;in my case the call to malloc was overwritting the rdx register (where i was saving the src string).
;Then when ft_strcpy was getting called it was causing seg fault.

; TO solve this i had to use a Callee-saved registers.
;(AKA non-volatile registers, or call-preserved) that are used to hold long-lived values that should be preserved across calls.

;This way i was able to copy back into rsi (2d registers for func param) the src string i had to
;copy.

; for external libraries function like malloc from libc, we must use
; wrt ..plt.
; basically this tells the assembler this is a special symbol and that it has to use PLT
; (procedure linkage table.) so that the dynamic linker ld.so can resolve it at runtime.
; once the ld.so found the real address of malloc, it patches the GOT (GLobal offset table).
; next calls, the PLT will directly uses updated GOT and jump straight to malloc.


global ft_strdup
extern malloc
extern ft_strlen
extern ft_strcpy
default rel

section .text

  ft_strdup:
  push rbp
  mov rbp, rsp

  test rdi,rdi
  je err

  call ft_strlen ; call strlen on the rdi string (only argument of strdup)
  mov rsi, rax ; store result of strlen inside rsi
  inc rsi ; + 1 for null terminator
  mov rbx, rdi ; move inside rdx the string so we can reuse it later for strcpy
  mov rdi, rsi ; inside rdi (first arg, we move the length)
  call  malloc wrt ..plt; call to malloc with length of string as arg
  mov rdi, rax ; move the result of malloc (dest) inside the first arg of the next function (dest)
  mov rsi, rbx ; inside rsi we move the previously saved source
  call ft_strcpy ; now the result of malloc is in rax, and we move it to first arg (rdi)

  mov rsp, rbp ; overwrite the stack pointer with  base pointer
  pop rbp   ; pop base pointer to original state
  ret

  err:
  mov rsp, rbp ; epilogue on error aswell else the function doesn't know where to jump after returning
  pop rbp
  mov rax, 0x0 ; xoring rax in this case was not working because the rax register was filled with previous values
  ret



section .note.GNU-stack

