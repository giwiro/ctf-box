;; This version includes a "hack" in order to persist the message
;; in the stack. That's why we pop and store it in ecx (2nd parameter
;; of sys_write)

global _start
    section .text

_start:

    jmp short call_str

    starter:
        xor eax, eax
        xor ebx, ebx
        xor ecx, ecx
        xor edx, edx

        pop ecx

        mov al, 0x4
        mov bl, 0x1
        mov dl, 0x20

        int 0x80

        xor eax, eax
        xor ebx, ebx

        mov al, 0x1

        int 0x80

    call_str:
        call starter
        message db "Welcome back 31337 h4x0r g1w1r0", 0xA

