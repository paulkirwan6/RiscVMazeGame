lui x11, 131072     #player start position x-axis
addi x12, x0, 52    #player start position y-axis
jal x1, createMaze
addi x6, x0, 1
mainLoop:
    #jal x1, userInput
    jal x1, moveRight
    jal x1, moveRight
    jal x1, moveRight
    jal x1, moveRight
	beq x0, x0, mainLoop # loop until reset asserted

createMaze: 
    addi x16, x0, -1         #top/bottom row of maze
    LUI x17, 524288
    addi x17, x17, 1          #rows 2-4
    LUI x18, 1048575
    addi x18, x18, 497        #row 5 (1)
    LUI x19, 524288
    addi x19, x19, 129        #rows 6-8
    LUI x20, 589823         #row 9 (2)
    addi x20, x20, 2019        
    LUI x21, 557056         # rows 10 & 11
    addi x21, x21, 1
    LUI x22, 561151         # row 12 (3_)
    addi x22, x22, 2047
    # store maze design in memory
    sw x16,  60(x0)
    sw x17,  56(x0)
    sw x17,  52(x0)
    sw x17,  48(x0)
    sw x18,  44(x0)
    sw x19,  40(x0)
    sw x19,  36(x0)
    sw x19,  32(x0)
    sw x20,  28(x0)
    sw x21,  24(x0)
    sw x21,  20(x0)
    sw x22,  16(x0)
    sw x21,  12(x0)
    sw x21,  8(x0)
    sw x21,  4(x0)
    sw x16,  0(x0)
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

# Takes 16-bit user input and stores in x4
userInput:
    lui x5 0x10
    lw x4, 0xc(x5)
    beq x4, x6, moveRight
    ret

moveRight:
    srli x11, x11, 1
    or x10, x11, x29
    sw x10, 0(x12)
    ret

moveLeft:
    slli x11, x11, 1
    or x10, x11, x29
    sw x10, 0(x12)
    ret

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