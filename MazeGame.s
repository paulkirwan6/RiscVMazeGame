main:
    lui x11, 131072     #player start position x-axis
    addi x12, x0, 52    #player start position y-axis
    jal x1, createMaze
	mainLoop:
        jal x1, moveRight
        jal x1, moveRight
        jal x1, moveRight
        jal x1, moveRight
        jal x1, moveRight
        jal x1, moveRight
        jal x1, moveRight
		beq x0, x0, mainLoop # loop until reset asserted

createMaze: 
    addi x6, x0, -1         #top/bottom row of maze
    LUI x7, 524288
    addi x7, x7, 1          #rows 2-4
    LUI x8, 1048575
    addi x8, x8, 497        #row 5 (1)
    LUI x9, 524288
    addi x9, x9, 129        #rows 6-8
    LUI x10, 589823         #row 9 (2)
    addi x10, x10, 2019        
    LUI x11, 557056         # rows 10 & 11
    addi x11, x11, 1
    LUI x12, 561151         # row 12 (3_)
    addi x12, x12, 2047

    # store maze design in memory
    sw x6,  60(x0)
    sw x7,  56(x0)
    sw x7,  52(x0)
    sw x7,  48(x0)
    sw x8,  44(x0)
    sw x9,  40(x0)
    sw x9,  36(x0)
    sw x9,  32(x0)
    sw x10,  28(x0)
    sw x11,  24(x0)
    sw x11,  20(x0)
    sw x12,  16(x0)
    sw x11,  12(x0)
    sw x11,  8(x0)
    sw x11,  4(x0)
    sw x6,  0(x0)
    #store maze design in registers
    lw x16, 0(x0)     
    lw x17, 4(x0)  
    lw x18, 8(x0)    
    lw x19, 12(x0)
    lw x20, 16(x0)
    lw x21, 20(x0)
    lw x22, 24(x0)     
    lw x23, 28(x0)  
    lw x24, 32(x0)    
    lw x25, 36(x0)
    lw x26, 40(x0)
    lw x27, 44(x0)
    lw x28, 48(x0)     
    lw x29, 52(x0)  
    lw x30, 56(x0)    
    lw x31, 60(x0)
    ret              # PC -> x1 (return address)

moveRight:
    srli x11, x11, 1
    or x10, x11, x29
    sw x10, 0(x12)

moveLeft:
    slli x11, x11, 1
    or x10, x11, x29
    sw x10, 0(x12)    

moveUp:
    

moveDown:
      


# blink:
#     or x10, x11, x29
#     sw x11, 52(x0) #replace with register to keep track of player location
#     sw x0, 52(x0)

# checkMoveLeft:
#     slli x11, x11, 1
#     #bne x11, (column walls) ,moveLeft    

# moveLeft:
#     slli x11, x11, 1
#     #or x11, (current row)