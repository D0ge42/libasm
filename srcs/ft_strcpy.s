;section text is basically the section where the actual code will be.
;is is a read only section, meaning the code cannot be overwritten
;instead .data section is where we store our variables. it is both readable and writable.
;.rodata is used in this case because the string we wanna copy is const and i want it to be read only.
;since the function takes (dst and src) in this order, we want src (in the register that holds 2nd
;argument) to be in a section where it is read only, so we avoid modifiying its value.

; mov rdx, rsi --> moves srcs (held into 2nd register rsi, into rdx)
; mov rcx, rdi --> moves dest (held into 1st register rdi, into rcx)
; we enter the .text section
; mov al, byte[rdx] --> first we move one byte into al which is an accumulator general purpose register. Often used to store a single byte.
; mov [rcx], al Once we stored that byte, we can safely copy it into rcx register.
; inc rdx --> we increment both rdx and rcx pointers;
; inc rcx --> we increment both rdx and rcx pointers;
; test al, al we use test (which is basically an & operator on al)
; it sets the cpu flag to 1 if both values are 0

;0x00 & 0x00 = 0x00	ZF = 1	jne does NOT jump
;0x41 & 0x41 = 0x41	ZF = 0	jne does jump

global ft_strcpy

section .text
ft_strcpy:
  test rsi, rsi
  je err
  mov rdx, rsi ; move 2nd arg (src) into rdx.
  mov rcx, rdi ; move 1st arg (dest) into rcx.

  loop_start:
    mov al, byte[rdx]
    mov [rcx], al
    inc rdx
    inc rcx
    test al, al
    jne loop_start

    mov rax,rdi
    ret
  err:
    mov rax, 0
    ret

section .note.GNU-stack
