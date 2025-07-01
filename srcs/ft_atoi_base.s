global ft_atoi_base
extern ft_strlen
default rel                 ; since its PIE code, we don't know the address of msg at compile time.
                            ; for that reason we use REL plus LEA which access RIP at run time.

section .text

  ; @Brief convert a string in a given base to int
  ; @Args 1st arg is string to convert, 2nd is base
  ; return --> int converted number

  ft_atoi_base:

  push rbp                  ; prologue + 8 bytes on stack
  mov rbp, rsp

  test rdi, rdi             ; check if str to convert is null
  je ft_atoi_base_str_err

  test rsi, rsi             ; check if str to convert is null
  je ft_atoi_base_b_err

  call skip_white_spaces

  mov r15, rsi              ; save original base
  call check_base

  cmp rax, -1               ; check if base is valid
  je ft_atoi_base_b_err

  sub rsp, 24               ; +24 bytes allocated for variables on stack
  mov r9, rdi               ; save string to convert on r9
  mov rdi, r15              ; copy base on first arg

    ; @brief label that convert string to num in given base
    ; We first take len of the base and store inside a stack variable
    ; We multiply it by current number
    ; We add the index of char in given base to the num
    ; loop

    calculate:

      mov qword[rbp - 8], 0   ; num
      mov qword[rbp - 16], 1  ; sign
      mov qword[rbp - 24], 0  ; base len

      call ft_strlen          ; call strlen on "base" rdi

      cmp rax, 1              ; check if base is <= 1
      jle ft_atoi_base_b_err

      mov rdi, r9             ; restore rdi to be string to convert
      mov dword[rbp -24], eax ; store base len inside r9
      xor r9, r9              ; clear r9 register.

    ; @brief main loop is used to iterate over the string.
    ; checks for sign and handles it when its '-'
    ; checks if the current char is present in a given base
    ; eventually enter the conversion loop if char is present

    main_loop:

      xor al, al              ; clear al register
      mov al, [rdi]           ; store curr char inside al
      test al, al             ; check for null
      je conv_done

      cmp al, 0x2D            ; check for minus
      je sign                 ; if equal jump to sign label and handles it

      call has_char           ; call has_char function
      mov rsi, r15            ; restore base to original state

      cmp rax, -1             ;if rax contains -1 it means "has char" failed
      je go_next

        ; @brief conversion loop is the core of the program.
        ; call the has_char function to retrieve index of a char in a given base
        ; multiply number by the base
        ; eventually add the index to current number
        ; loop again until curr char is no longer present in given base / end of string

        conversion_loop:

        mov al, [rdi]           ; move current char of to_convert(rdi reg) inside al

        test al, al             ; classic null check
        je end

        call has_char           ; call has_char func
        mov r10, rax            ; store idx of given char inside r10

        cmp r10, -1             ; check for error
        je end

        mov rax, qword[rbp - 8] ; move current num inside rax
        mul qword[rbp - 24]     ; multiply num by base len
        add rax, r10            ; add index inside base to num
        mov [rbp - 8], rax      ; store result of rax inside current num
        inc rdi                 ; increase rdi reg
        jmp conversion_loop     ; loop again

    end:
      mov rax, [rbp - 8]  ; store num inside rax
      mul qword[rbp - 16] ; multiply rax by sign
      jmp conv_done       ; end conversion

    conv_done:
      add rsp, 24         ; free stack variables space
      mov rsp, rbp        ; epilogue
      pop rbp
      ret                 ; pop return address

    sign:
      mov eax, dword[rbp - 16]  ; store current sign inside eax
      neg eax                   ; multiply eax by  - 1
      mov dword[rbp - 16], eax  ; store result inside rpb - 16, namely sign
      inc rdi                   ; go to next character in string to convert
      jmp main_loop             ; jump to initial loop

    go_next:
      inc rdi                   ; go to next iteration
      jmp main_loop             ; jmp back to the main loop

    ft_atoi_base_str_err:
      mov rsp, rbp              ; epilogue in case of error
      pop rbp
      mov rax, 1                ; write syscall
      mov rdi, 2                ; fd err
      lea rsi, INV_STR          ; use lea to avoid compile time error PIE
      mov rdx, INV_STR_LEN      ; get len of string to write
      syscall                   ; write syscall
      mov rax, -1               ; return -1 on error
      ret

    ft_atoi_base_b_err:
      mov rsp, rbp              ; epilogue in case of error
      pop rbp
      mov rax, 1                ; write syscall
      mov rdi, 2                ; fd err
      lea rsi, INV_BASE         ; use lea to avoid compile time error PIE
      mov rdx, INV_BASE_LEN     ; get len of string to write
      syscall                   ; write syscall
      mov rax, -1               ; return -1 on error
      ret


  ; @brief function to check if a char is present in a certain base
  ; @args rdi, char to check
  ;       rsi, base to check against
  ; @return index on success else 0

  has_char:
    mov rsi, r15                ; restore original base
    xor ecx, ecx                ; xor rcx register and use it as index
    loop_has_char:
      xor bl, bl                ; xor bl register and use it as single byte container
      mov bl, [rsi]             ; mov curr base char inside bl

      test bl, bl               ; null check
      je not_found              ; if end is reached, no match was found

      cmp al, bl                ; check if curr char of rdi is inside given base rsi
      je found                  ; if cmp sets 0 flag to 1, a match was found
      inc ecx                   ; else we increase idx and check next byte
      inc rsi                   ; we increase rsi register to access next byte
      jmp loop_has_char         ; loop again

    found:
      mov eax, ecx              ; if a match was found, we store it inside eax (lower 32bits of rax)
      ret                       ; pop return address

    not_found:
      mov eax, -1               ; on error, we set eax to -1 and return
      ret

  ; @brief Function used to skip white spaces
  ; @args register where pointer to string is saved
  ; @Return the incremented pointer to string, to the first non-white space char

  skip_white_spaces:
    loop:
      mov al, [rdi]             ; move current char inside al
      test al, al               ; check for null
      je done_skipping
      cmp al, 0x20              ; check for space
      je skip
      cmp al, 0x9               ; check for horizontal tab
      je skip
      cmp al, 0xA               ; check for new line
      je skip
      cmp al, 0xB               ; check for  vertical tab
      je skip
      cmp al, 0xC               ; check for form feed
      je skip
      cmp al, 0xD               ; check for carriage ret
      je skip
      ret

      done_skipping:            ; we pop the return address and rdi is incremented at this point
      ret

      skip:
        inc rdi                 ; if a match was found, we skip and loop again
        jmp loop

  ; @brief Function to check given base
  ; @args registers where base is stored (rsi)
  ; @return --> 0 if no invalid chars were found, else 1

  check_base:
    loop_1:
      mov r8, rsi               ; store copy of rsi inside r8 (needed for inner loop)
      xor al, al                ; clear previously used register
      mov al, [rsi]             ; curr char is stored inside al
      test al, al               ; check for null
      je done

      cmp al, 0x2D              ; check for minus in base
      je invalid_base
      cmp al, 0x2B              ; check for plus in base
      je invalid_base
      cmp al, 0x20              ; check for space in base
      je invalid_base

        inner_loop:
          inc r8
          mov bl, [r8]          ; copy char inside bl
          test bl, bl           ; check for null
          je inc
          cmp bl, al            ; compare if two char in base are equal
          je invalid_base       ; if so base is invalid
          jmp inner_loop        ; loop again

      inc:
        inc rsi                 ; loop again
        jmp loop_1

    done:
      ret

    invalid_base:
    mov rax, 1                  ; write syscall
    mov rdi, 2                  ; fd err
    lea rsi, INV_BASE           ; use lea to avoid compile time error PIE
    mov rdx, INV_BASE_LEN
    syscall
    mov rax, -1
    ret

section .rodata
  INV_BASE db "Error: Invalid base", 0xA
  INV_BASE_LEN equ $ - INV_BASE

  INV_STR db "Error: Invalid string", 0xA
  INV_STR_LEN equ $ - INV_STR

section .note.GNU-stack       ; this avoid this error -> .note.GNU-stack section implies executable stack
