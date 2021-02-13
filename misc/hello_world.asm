SECTION .text
    GLOBAL _start

_start:
    xor eax, eax;       eax = 0
    xor ebx, ebx;       ebx = 0
    xor ecx, ecx;       ecx = 0
    xor edx, edx;       edx = 0

    push eax;           null terminated str
    push 0x006F7269
    push 0x77696720
    push 0x72307834
    push 0x68203733
    push 0x33313320
    push 0x6B636162
    push 0x20656D6F
    push 0x636C6557

    ;; all this pushes, increases the size of the stack by decreasing its value
    ;; so at the point esp points to the top of the stack (the last item pushed)

    mov al, 0x4;        sys_write x86
    mov bl, 0x1;        stdout
    mov ecx, esp;
    mov dl, 0x20;       0x20 => 32(base 10) is the length of the string

    int 0x80;           call interrupt 

    xor eax, eax;       eax = 0
    xor ebx, ebx;       ebx = 0

    mov al, 0x01;       sys_exit
    mov bl, 0x00;       exit code, we can ommit this, but it's for educational purposes

    int 0x80;           call interrupt


