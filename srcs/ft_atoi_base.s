global ft_atoi_base
default rel

section .text
  ft_atoi_base:

  ; prologue: + 8 bytes
  push rbp
  mov rbp, rsp

  call skip_white_spaces

  call check_base

  cmp rax, -1
  je ft_atoi_base_err


  ; epilogue: -8 bytes
  mov rsp, rbp
  pop rbp

  ret

  ft_atoi_base_err:

  ; epilogue: -8 bytes
  mov rsp, rbp
  pop rbp
  ret

  ; @brief Function used to skip white spaces
  ; @args register where pointer to string is saved
  ; @Return the incremented pointer to string, to the first non-white space char

  skip_white_spaces:
    loop:
      mov al, [rdi] ; move current char inside al
      test al, al ; check for null
      je done_skipping
      cmp al, 0x20 ; check for space
      je skip
      cmp al, 0x9  ; check for horizontal tab
      je skip
      cmp al, 0xA ; check for new line
      je skip
      cmp al, 0xB ; check for  vertical tab
      je skip
      cmp al, 0xC ; check for form feed
      je skip
      cmp al, 0xD ; check for carriage ret
      je skip
      ret ; increased rdi

      done_skipping:
      ret

      skip:
        inc rdi
        jmp loop

  ; @brief Function to check given base
  ; @args registers where base is stored (rsi)
  ; @return --> 0 if no invalid chars were found, else 1

  check_base:
    loop_1:
      mov r8, rsi ; store copy of rsi inside r8 (needed for inner loop)
      xor al, al ; clear previously used register
      mov al, [rsi] ; curr char is stored inside al
      test al, al ; check for null
      je done

      cmp al, 0x2D ; check for minus in base
      je invalid_base
      cmp al, 0x2B ; check for plus in base
      je invalid_base
      cmp al, 0x20 ; check for space in base
      je invalid_base

        inner_loop:
          inc r8
          mov bl, [r8] ; copy char inside bl
          test bl, bl ; check for null
          je inc
          cmp bl, al ; compare if two char in base are equal
          je invalid_base ; if so base is invalid
          jmp inner_loop ; loop again

      inc:
        inc rsi ; loop again
        jmp loop_1

    done:
      ret

    invalid_base:
    mov rax, 1 ; write syscall
    mov rdi, 2 ; fd err
    lea rsi, INV_BASE ; use lea to avoid compile time error PIE
    mov rdx, INV_BASE_LEN
    syscall
    ret -1




section .rodata
  INV_BASE db "Error: Invalid base", 0xA
  INV_BASE_LEN equ $ - INV_BASE


section .note.GNU-stack
