#include <stdio.h>

// JUST REMEMBER:
// If you develop a x86 asm you should compile with -m32
// If you develop a x64 asm you should make sure the compiler output is a x64 binary
// const char code[] = "\xEB\x19\x31\xC0\x31\xDB\x31\xC9\x31\xD2\x59\xB0\x04\xB3\x01\xB2\x20\xCD\x80\x31\xC0\x31\xDB\xB0\x01\xCD\x80\xE8\xE2\xFF\xFF\xFF\x57\x65\x6C\x63\x6F\x6D\x65\x20\x62\x61\x63\x6B\x20\x33\x31\x33\x33\x37\x20\x68\x34\x78\x30\x72\x20\x67\x31\x77\x31\x72\x30\x0A";
unsigned char code[] = "\x31\xC0\x31\xDB\x31\xC9\x31\xD2\x50\x68\x72\x6C\x64\x00\x68\x6F\x20\x57\x6F\x68\x48\x65\x6C\x6C\x31\xC0\xB0\x04\xB3\x01\x89\xE1\xB2\x0C\xCD\x80\x31\xC0\x31\xDB\xB0\x01\xCD\x80";

int main() {
    int (*ret)() = (int(*)())code;
    ret();
    return 0;
}
