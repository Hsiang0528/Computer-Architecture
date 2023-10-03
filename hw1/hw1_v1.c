#include <stdio.h>
#include <stdint.h>

int main(){
    uint64_t x = 0x1111111100000011;
    x |= (x >> 1);
    x |= (x >> 2);
    x |= (x >> 4);
    x |= (x >> 8);
    x |= (x >> 16);
    x |= (x >> 32);
    x -= ((x >> 1) & 0x5555555555555555);
    x = ((x >> 2) & 0x3333333333333333) + (x & 0x3333333333333333);
    x = ((x >> 4) + x) & 0x0f0f0f0f0f0f0f0f;
    x += (x >> 8);
    x += (x >> 16);
    x += (x >> 32);
    printf("%llx\n",(x & 0x7f));
    printf("%d\n",64 - (x & 0x7f));
    return 0;
}