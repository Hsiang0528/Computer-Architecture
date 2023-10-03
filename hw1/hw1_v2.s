.data
    # num: .word 0x11111111 0x00000011 # big endian
    # num: .word 0x00000000 0x00000010 # big endian num =16
    # num: .word 0x00000000 0x00000021 # big endian num =33
    num: .word 0x01000F00 0x00000021
.text

main:
    la a0, num
    # load num
    lw t0,0(a0)
    lw t1,4(a0)
    # x = x | x >> 1
    slli t2,t0,31
    srli t3,t0,1
    srli t4,t1,1
    or   t4,t4,t2
    or   t0,t0,t3
    or   t1,t1,t4
    # x |= (x >> 2);
    slli t2,t0,30
    srli t3,t0,2
    srli t4,t1,2
    or   t4,t4,t2
    or   t0,t0,t3
    or   t1,t1,t4
    # x |= (x >> 4);
    slli t2,t0,28
    srli t3,t0,4
    srli t4,t1,4
    or   t4,t4,t2
    or   t0,t0,t3
    or   t1,t1,t4
    #x |= (x >> 8);
    slli t2,t0,16
    srli t3,t0,8
    srli t4,t1,8
    or   t4,t4,t2
    or   t0,t0,t3
    or   t1,t1,t4
    # x |= (x >> 16); can improve
    slli t2,t0,16
    srli t3,t0,16
    srli t4,t1,16
    or   t4,t4,t2
    or   t0,t0,t3
    or   t1,t1,t4
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
    li   a0,64
    sub  a0,a0,t1
    
print:
    li a7,1
    ecall
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    