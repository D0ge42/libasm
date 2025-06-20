; We first copy pointer from rdi to rsi, since rdi is where the first argument will be stored.
; We then xor the rcx register to set it at 0. This will be our counter. we could use any register
; but rcx in 16/32-bit x86 was used as a loop counter.
; we decleare a loop lable, and we start by comparing the current byte with a null byte
; if condition is satisfied (jump if equal = je) then we jump to the done label.
; else we keep going by incrementing pointer value by 1, and rcx (loop counter ) by 1 aswell and we loop again
; once condition is satisfied (current byte is null byte) we jump to the done label.
; in here we move the counter value (stored in rcx) into rdi. and we make the syscall
; in this case we don't use syscall since we let the caller decide what he wants to do with the
; result.
; if we used a syscall with 60 (exit) the value of len would be stored as exit code

global ft_strlen

section .text
ft_strlen:
  mov rsi, rdi
  xor rcx, rcx

  loop_start:
    cmp byte[rsi],0
    je done
    add rsi,1
    inc rcx
    jmp loop_start

  done:
    mov rax,rcx

section .note.GNU-stack
