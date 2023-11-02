#include<stdint.h>

uint16_t count_leading_zeros(uint64_t x){

    x |= (x >> 1);
    x |= (x >> 2);
    x |= (x >> 4);
    x |= (x >> 8);
    x |= (x >> 16);
    x |= (x >> 32);

    /* count ones (population count) */
    x -= ((x >> 1) & 0x5555555555555555 );
    x = ((x >> 2) & 0x3333333333333333) + (x & 0x3333333333333333);
    x = ((x >> 4) + x) & 0x0f0f0f0f0f0f0f0f;
    x += (x >> 8);
    x += (x >> 16);
    x += (x >> 32);

    return (64 - (x & 0x7f));
}

int main(){
    uint64_t test_data1 = 0x0010111001001000;
    uint64_t test_data2 = 0x1100000800000000;
    uint64_t test_data3 = 0x0000000000000000;
    print("Find first set is %2d.\n", 64 - count_leading_zeros(test_data1 & -test_data1));
    print("Find first set is %2d.\n", 64 - count_leading_zeros(test_data2 & -test_data2));
    print("Find first set is %2d.\n", 64 - count_leading_zeros(test_data3 & -test_data3));
    return 0;
}