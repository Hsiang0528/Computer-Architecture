.data 
test_data1: .word 0x00101110 0x01001000
test_data2: .word 0x11000008 0x00000000
test_data3: .word 0x00000000 0x00000000
const_1: .word 0x55555555
const_2: .word 0x33333333
const_3: .word 0x0f0f0f0f
str: .string "\nThe first set of test_data is "
# s1 : unsigned int 64 high 32 bits
# s2 : unsigned int 64 low 32 bits
# s3 : 64 or 32
# s4 : test_data select

# t1 : unsigned int 64 high 32 bits (tmp)
# t2 : unsigned int 64 low 32 bits (tmp)
# t3 : init=1, *2 until x = 32

.text 
data_select:
    jal ra, load_data1
    jal ra, load_data2
    jal ra, load_data3
exit:
    li a7, 10
    ecall

load_data1:
    la t1, test_data1
    j main

load_data2:
    la t1, test_data2
    j main

load_data3:
    la t1, test_data3

main:
# load x
    lw s1, 0(t1)
    lw s2, 4(t1)

    lw t3, 0(t1)
    lw t4, 4(t1)

    addi sp, sp, -4
    sw ra, 0(sp)
# -x
    sub t4,x0,t4
    li t5, -1
    xor t3, t3, t5
    addi t5, x0, 1
    sltu t0, t4, t5
    add t3, t3, t0 

    and s1, s1, t3
    and s2, s2, t4

shift_with_or_loop_unrolling:
    # x |= (x >> 1);
    slli t0, s1, 31
    srli t1, s1, 1    
    srli t2, s2, 1
    or t2, t2, t0
    or s1, s1, t1
    or s2, s2, t2
    
    # x |= (x >> 2);
    slli t0, s1, 30
    srli t1, s1, 2   
    srli t2, s2, 2
    or t2, t2, t0
    or s1, s1, t1
    or s2, s2, t2
    
    # x |= (x >> 4);
    slli t0, s1, 28
    srli t1, s1, 4   
    srli t2, s2, 4
    or t2, t2, t0
    or s1, s1, t1
    or s2, s2, t2
    
    # x |= (x >> 8);
    slli t0, s1, 24
    srli t1, s1, 8   
    srli t2, s2, 8
    or t2, t2, t0
    or s1, s1, t1
    or s2, s2, t2
    
    # x |= (x >> 16);
    slli t0, s1, 16
    srli t1, s1, 16   
    srli t2, s2, 16
    or t2, t2, t0
    or s1, s1, t1
    or s2, s2, t2
    
    # x |= (x >> 32);
    or s2, s1, s2
    
count_ones:
    # x -= ((x >> 1) & 0x5555555555555555);
    slli t0, s1, 31
    srli t1, s1, 1
    srli t2, s2, 1
    or t2, t2, t0
    lw t3, const_1
    and t1, t1, t3
    and t2, t2, t3
    
    sub s2, s2, t2
    sub s1, s1, t1

    # x = ((x >> 2) & 0x3333333333333333) + (x & 0x3333333333333333);
    slli t0, s1, 30
    srli t1, s1, 2
    srli t2, s2, 2
    or t2, t2, t0
    lw t3, const_2 
    and t1, t1, t3
    and t2, t2, t3
    
    and t4, s1, t3
    and t5, s2, t3
    
    add s2, t2, t5
    add s1, t1, t4
    
    # x = ((x >> 4) + x) & 0x0f0f0f0f0f0f0f0f;
    slli t0, s1, 28
    srli t1, s1, 4
    srli t2, s2, 4
    or t2, t2, t0
    add t2, t2, s2
    add t1, t1, s1
    lw t3, const_3
    and s1, t1, t3
    and s2, t2, t3
    
    # x += (x >> 8);
    slli t0, s1, 24
    srli t1, s1, 8
    srli t2, s2, 8
    or t2, t2, t0
    add s2, t2, s2
    add s1, t1, s1
    
    # x += (x >> 16);
    slli t0, s1, 16
    srli t1, s1, 16
    srli t2, s2, 16
    or t2, t2, t0
    add s2, t2, s2
    add s1, t1, s1
    
    # x += (x >> 32);
    add s2, s2, s1
    
    # x & 0x7f
    andi s2, s2, 0x7f
    jal ra, printResult
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra

printResult:
    # print string
    la a0, str
    li a7, 4 
    ecall
    # print result
    li a7, 1
    mv a0, s2
    ecall
    jr ra