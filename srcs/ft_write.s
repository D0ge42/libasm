; since rdi            0xffffffff          4294967295 is treated as positive
; only in 64 bit, but negative in 32 bit
; when we do cmp rdi, 0 the less zero flag won't be set.
; to fix that we perform a Sign extension.

; It is the process of converting a smaller signed value into a larger signed value (Example from 32-bit to 64-bit) while preserving its sign (positive or negative).
;without Sign extension
;mov rdi, edi
; rdi = 0x00000000FFFFFFFF   → this is +4294967295 in 64-bit (-1 in 32 bit not considering the
; zeroes)

;with sign extension
;movsx rdi, edi
; rdi = 0xFFFFFFFFFFFFFFFF   → this is -1 in 64-bit

global ft_write
default rel
extern __errno_location

section .data
  err_msg db "NULL string can't be written", 0xa
  err_length equ $ - err_msg

section .text
  ft_write:
    push rbp
    mov rbp, rsp
    test rsi,rsi ; check for null string
    jz err ; go err label if its null

    movsx rdi, edi  ; Sign-extend 32-bit `edi` into 64-bit `rdi`
    cmp rdi, 0 ; check for negative value
    jl err_fd ; if sign flag is set, jump to err_fd

    movsx rdx, edx
    cmp rdx, 0
    jl enegcount


    mov rax, 0x1
    syscall
    mov rsp, rbp ; overwrite the stack pointer with  base pointer
    pop rbp   ; pop base pointer to original state
    ret

  err:
    mov rax, 1
    mov rdi, 2
    lea rsi, err_msg
    mov rdx, err_length
    syscall

    mov rax, 60
    mov rdi, 0x1
    mov rsp, rbp ; overwrite the stack pointer with  base pointer
    pop rbp   ; pop base pointer to original state
    syscall
  err_fd:
    call __errno_location wrt ..plt
    mov dword[rax], 0x9
    mov rax, -1
    mov rsp, rbp ; overwrite the stack pointer with  base pointer
    pop rbp   ; pop base pointer to original state
    ret
  enegcount:
    call __errno_location wrt ..plt
    mov dword[rax], 0x16
    mov rsp, rbp ; overwrite the stack pointer with  base pointer
    pop rbp   ; pop base pointer to original state
    mov rax, -1
    ret



section .note.GNU-stack
