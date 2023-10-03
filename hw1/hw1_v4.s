.data
    num0: .word 0x11111111 0x00000011 # big endian
    num1: .word 0x00000000 0x00000010 # big endian num =16
    num2: .word 0x00000000 0x00000021 # big endian num =33
    str:  .string "\nint(log2(num"
    str0: .string ")):"
.text

main:
    # times
    li   a2,0
    li   a3,1
    jal  ra,func
func:
    blt,  a2,a3,load_num0
    beq   a2,a3,load_num1
    bgt   a2,a3,load_num2
load_num0:
    la   a0, num0
    j    load_num
load_num1:
    la   a0, num1
    j    load_num
load_num2:
    la   a0, num2
    jal  ra,load_num
    j    exit
exit:
    li   a7, 10 # exit
	ecall
load_num:
    # load num
    lw   t0,0(a0)
    lw   t1,4(a0)
    li   t5,1
    li   t6,31

    # x = x | x >> 1,2,4,8,16
loop:
    sll  t2,t0,t6
    srl  t3,t0,t5
    srl  t4,t1,t5
    or   t4,t4,t2
    or   t0,t0,t3
    or   t1,t1,t4
    sub  t6,t6,t5
    slli t5,t5,1
    bge  t6,t5,loop

    # x = x | (x >> 32);
    or   t1,t1,t0
    # x -= ((x >> 1) & 0x5555555555555555);
    
    # y = (x >> 1) & 0x5555555555555555;
    slli t2,t0,31
    srli t3,t0,1
    srli t4,t1,1
    or   t4,t4,t2
    li   t5,0x55555555
    and  t3,t3,t5
    and  t4,t4,t5
    # x -= y
    sub  t0,t0,t3
    sub  t1,t1,t4
    # x = ((x >> 2) & 0x3333333333333333) + (x & 0x3333333333333333);
    
    # y = (x >> 2) & 0x3333333333333333;
    slli t2,t0,30
    srli t3,t0,2
    srli t4,t1,2
    or   t4,t4,t2
    li   t5,0x33333333
    and  t3,t3,t5
    and  t4,t4,t5
    # a = x & 0x3333333333333333;
    and  a0,t0,t5
    and  a1,t1,t5
    add  t0,t3,a0
    add  t1,t4,a1
    # x = ((x >> 4) + x) & 0x0f0f0f0f0f0f0f0f;
    
    # t = x >> 4
    slli t2,t0,28
    srli t3,t0,4
    srli t4,t1,4
    or   t4,t4,t2
    # x = x + t
    add  t0,t0,t3
    add  t1,t1,t4
    # x = x & 0x0f0f0f0f0f0f0f0f;
    li   t5,0x0f0f0f0f
    and  t0,t0,t5
    and  t1,t1,t5
    
    # x = x + (x >> 8);
    
    # t = x >> 8
    slli t2,t0,24
    srli t3,t0,8
    srli t4,t1,8
    or   t4,t4,t2
    # x = x + t
    add  t0,t0,t3
    add  t1,t1,t4
    
    # x = x + (x >> 16);
    
    # t = x >> 16
    slli t2,t0,16
    srli t3,t0,16
    srli t4,t1,16
    or   t4,t4,t2
    # x = x + t
    add  t0,t0,t3
    add  t1,t1,t4
    
    # x += (x >> 32);
    add  t1,t1,t0
    # return 64 - (x & 0x7f)
    andi t1,t1,0x7f
    li   t0,64
    # t0 = leading_zeros
    sub  t0,t0,t1
int_log_num_:
    # int(log(num)) = 63 - leading zeros
    li   t1,63
    sub  t0,t1,t0
    
print:
    la a0, str
    li a7, 4
    ecall
    mv a0,a2
    li a7,1
    ecall
    la a0, str0
    li a7, 4
    ecall
    mv a0,t0
    li a7,1
    ecall
times:
    addi a2,a2,1
    ret
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    