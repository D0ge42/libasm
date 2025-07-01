global ft_atoi_base
extern ft_strlen
default rel

section .text
  ft_atoi_base:

  ; prologue: + 8 bytes
  push rbp
  mov rbp, rsp

  call skip_white_spaces

  mov r15, rsi ; save original base
  call check_base

  cmp rax, -1
  je ft_atoi_base_err

  sub rsp, 24 ; + 24 bytes allocated for variables on stack
  mov r9, rdi ; save string to convert on r9
  mov rdi, r15 ; copy base on first arg

  ; r9 hold string to convert
  ; r15 orig base
  ; rdi orig base

    calculate:

      mov qword[rbp - 8], 0 ; num
      mov qword[rbp - 16], 1 ; sign
      mov qword[rbp - 24], 0 ; base len


      call ft_strlen ; call strlen on "base" rdi

      cmp rax, 1
      jle ft_atoi_base_err

      mov rdi, r9 ; restore rdi to be string to convert
      mov dword[rbp -24], eax ; store base len inside r9
      xor r9, r9 ; clear r9 register.

    main_loop:

      xor al, al ; clear al register
      mov al, [rdi] ; store curr char inside al
      test al, al ; check for null
      je conv_done

      cmp al, 0x2D ; check for minus
      je sign ; if equal jump to sign label and handles it

      mov rsi, r15 ; restore rsi to original base
      mov rdx, rsi ; store current orig pointer inside rdx --> RSI IS EMPTY!!!
      call has_char ; call has_char function
      mov rsi, rdx

      cmp rax, 0x0 ; FIXED
      je go_next

        conversion_loop:
        mov al, [rdi] ; move current char of to_convert(rdi reg) inside al

        test al, al ; check for end of string --> NOT WORKING? this is going straight to end: label
        je end

        call has_char ; call has_char func
        mov rsi, rdx ; restore original base
        mov r10, rax ;store index and curr result of fchar function

        cmp r10, -1  ; THIS SHOULD NOT TRIGGER WHEN BASE IS 0.
        je end

        mov rax, qword[rbp - 8] ; move current num inside rax
        mul qword[rbp - 24] ; multiply num by base len
        add rax, r10 ; add index inside base to num
        add [rbp - 8], rax
        inc rdi
        jmp conversion_loop

    end:
    mov rax, [rbp - 8]
    mul qword[rbp - 16] ; multiply rax by sign
    jmp conv_done ; end conversion

    conv_done:
      ; epilogue: -8 bytes
      mov rsp, rbp
      pop rbp
      ret

    sign:
      mov eax, dword[rbp - 16] ; store current sign inside eax
      neg eax; multiply eax by  - 1
      mov dword[rbp - 16], eax ; store result inside rpb - 16
      inc rdi
      jmp main_loop

    go_next:
      inc rdi
      jmp main_loop

    ft_atoi_base_err:
      ; epilogue: -8 bytes
      mov rsp, rbp
      pop rbp
      mov rax, 1 ; write syscall
      mov rdi, 2 ; fd err
      lea rsi, INV_BASE_L ; use lea to avoid compile time error PIE
      mov rdx, INV_BASE_LEN_N
      syscall
      mov rax, -1
      ret


  ; @brief function to check if a char is present in a certain base
  ; @args rdi, char to check
  ;       rsi, base to check against
  ; @return index on success else 0
  has_char:
    mov ebx, 0 ; index
    loop_has_char:
      xor bl, bl ; clear bl register
      mov bl, [rsi] ; mov curr char inside rdi

      test bl, bl
      je not_found

      cmp al, bl; check if curr char is inside given base
      je found
      inc ebx
      inc rsi
      jmp loop_has_char

    found:
      mov rax, rbx
      sub rax, 48
      ret

    not_found:
      mov rax, -1
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
      ret

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
    mov rax, -1
    ret

section .rodata
  INV_BASE db "Error: Invalid base", 0xA
  INV_BASE_LEN equ $ - INV_BASE

  INV_BASE_L db "Error: Invalid base_len", 0xA
  INV_BASE_LEN_N equ $ - INV_BASE_L

section .note.GNU-stack
