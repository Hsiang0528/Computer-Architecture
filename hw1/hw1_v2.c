#include <stdio.h>
#include <stdint.h>

void print_binary(uint64_t a){
    uint64_t b = 0x8000000000000000;
    while(b){
        if(b&a) printf("%d",1);
        else    printf("%d",0);
        b >>= 1;
    }
    return;
}

uint16_t count_leading_zeros(uint64_t x){
    for(int i = 1;i < 32;i <<= 1){
        x |= (x >> i);
    }
    x |= (x >> 32);

    x -= ((x >> 1) & 0x5555555555555555);
    x = ((x >> 2) & 0x3333333333333333) + (x & 0x3333333333333333);
    x = ((x >> 4) + x) & 0x0f0f0f0f0f0f0f0f;
    x += (x >> 8);
    x += (x >> 16);
    x += (x >> 32);

    return (64 - (x & 0x7f));
}

int int_log2(uint16_t clz){
    return 63 - clz;
}

int main(){
    uint64_t x = 0x1111111100000011;
    // uint64_t x = 0x0000000000000010;
    // uint64_t x = 0x0000000000000021;
    uint16_t clz = count_leading_zeros(x);
    int result = int_log2(clz);
    printf("%d\n",result);
    return 0;
}