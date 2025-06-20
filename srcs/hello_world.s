; rax (Accumulator register) often used for return values and
;; some arithmetic operations.
; in 64-byt systems, rax is the 64 bit extension of the ax
; register (which in turn is part of older eax,ax,al,ah reg hierarchy.)

;rdi (Destination index): often used to hold first arg
; passed to a function

;rsi (Source index) often used to hold second arg
; passed to a function

;rdx (Data register) often used to hold third argument
; passed to a function.

;in x86-64 System V calling convention (commonly used on Linux and maxOs)
;the first six integer or pointer args to function are passed in registers:
;rdi,rsi,rdx,rcx,r8,r9.
; the return value is tipically stored in rax

global _start

section .text

_start:
  mov rax, 1        ; write(
  mov rdi, 1        ;   STDOUT_FILENO,
  mov rsi, msg      ;   "Hello, world!\n",
  mov rdx, msglen   ;   sizeof("Hello, world!\n")
  syscall           ; );

  mov rax, 60       ; exit(
  mov rdi, 0        ;   EXIT_SUCCESS
  syscall           ; );

section .rodata
  msg: db "Hello, world!", 10
  msglen: equ $ - msg
