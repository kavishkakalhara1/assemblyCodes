section .data          ; Initialized data section
    msg1 db 0xa, 0xd, 'Enter number between 0-9: ', 0
    msg2 db 0xa, 0xd, 'Square is: ', 0
    newln db 0xa, 0xd

section .bss           ; Uninitialized data section
    buf resb 2         ; Reserves 2 bytes

section .text          ; Code section
    global _start

_start:
    ; Display msg1 ("Enter number between 0-9:")
    mov ebx, 1         ; File descriptor 1 (stdout)
    mov edx, 29        ; Length of msg1
    mov ecx, msg1      ; Pointer to msg1
    mov eax, 4         ; System call number for sys_write
    int 0x80           ; Call kernel

    ; Read 1 byte from stdin into buf
    mov ebx, 0         ; File descriptor 0 (stdin)
    mov ecx, buf       ; Buffer to store input
    mov edx, 1         ; Number of bytes to read
    mov eax, 3         ; System call number for sys_read
    int 0x80           ; Call kernel

    ; Calculate square of input
    mov al, [buf]      ; Load the input character into AL
    sub al, '0'        ; Convert ASCII to integer (0-9)

    ; Check if input is in range 0-9
    cmp al, 9
    jae _end_program   ; If input > 9, exit program

    ; Square the number
    mov ah, 0          ; Clear AH for MUL
    mul al             ; Square: AL = AL * AL, result in AX

    ; Convert result in AX to ASCII
    mov bl, 10         ; Divisor for dividing by 10
    div bl             ; AH = remainder, AL = quotient (division result)

    add al, '0'        ; Convert quotient to ASCII
    add ah, '0'        ; Convert remainder to ASCII

    ; Store ASCII characters in buf
    mov [buf], ah      ; Tens place
    mov [buf+1], al    ; Units place

    ; Display msg2 ("Square is:")
    mov ebx, 1         ; File descriptor 1 (stdout)
    mov edx, 13        ; Length of msg2
    mov ecx, msg2      ; Pointer to msg2
    mov eax, 4         ; System call number for sys_write
    int 0x80           ; Call kernel

    ; Display the square result stored in buf
    mov ebx, 1         ; File descriptor 1 (stdout)
    mov edx, 2         ; Length of buffer (2 bytes)
    mov ecx, buf       ; Pointer to buffer containing result
    mov eax, 4         ; System call number for sys_write
    int 0x80           ; Call kernel

    ; Display newline
    mov ebx, 1         ; File descriptor 1 (stdout)
    mov edx, 2         ; Length of newline
    mov ecx, newln     ; Pointer to newline
    mov eax, 4         ; System call number for sys_write
    int 0x80           ; Call kernel

_end_program:
    ; Exit the program
    mov ebx, 0         ; Exit code 0
    mov eax, 1         ; System call number for sys_exit
    int 0x80           ; Call kernel
