;; In this version we place the literal string into the stack like a real men

global _start
    section .text

_start:
    
    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx

    push eax
    push 0x00646C7
    push 0x6F57206F
    push 0x6C6C6548

    xor eax, eax

    mov al, 0x4
    mov bl, 0x1
    mov ecx, esp
    mov dl, 0xC

    int 0x80

    xor eax, eax
    xor ebx, ebx

    mov al, 0x1

    int 0x80

