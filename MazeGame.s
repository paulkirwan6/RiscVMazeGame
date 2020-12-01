# Maze Game by Paul Kirwan and Mollie Fairclough Nov 2020
# For EE451 System On Chip
# Uses Risc V architecture and used with Vicilogic
# Traverse through the maze from the top left to the bottom right to win
# Hitting into walls will cause you to lose

# Dedicated Registers
# These should be used for one purpose only (until WIN or LOSE screen)!
# x4 and x5 - user input
# x6-x9 - user controls
# x14 and x15 - zone to win
# x11 and x12 - player position

lui x11, 131072     #player start position x-axis
addi x12, x0, 52    #player start position y-axis
jal x1, createMaze
addi x14, x0, 13     # winning y
addi x15, x0, 33     # winning x 
addi x6, x0, 1       #move right
addi x7, x0, 0b10    #move left
addi x8, x0 0b100    #move down
addi x9, x0 0b1000   #move up

#Runs the whole game until win/lose
mainLoop:
    jal x1, userInput
    jal x1, checkWin
    beq x0, x0, mainLoop

#Initialises maze in memory
createMaze: 
    addi x16, x0, -1 
    LUI x17, 524288
    addi x17, x17, 1 
    LUI x18, 1048575
    addi x18, x18, 497   
    LUI x19, 524288
    addi x19, x19, 129    
    LUI x20, 589823       
    addi x20, x20, 2019   
    LUI x21, 557056       
    addi x21, x21, 1
    LUI x22, 561151       
    addi x22, x22, 2047
    LUI x23, 557056       
    addi x23, x23, 5

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
    sw x23,  8(x0)
    sw x21,  4(x0)
    sw x16,  0(x0)
    ret

# Takes 16-bit user input and stores in x4
userInput:
    lui x5 0x10
    lw x4, 0xc(x5)
    beq x4, x6, moveRight
    beq x4, x7, moveLeft
    beq x4, x8, moveDown
    beq x4, x9, moveUp
    ret

# Moves user representation to the right and checks for collision
moveRight:
    lw x3 0(x12)
    xor x10, x11, x3 
    srli x11, x11, 1   
    and x13, x11, x10 
    bge x13, x6, lose
    or x10, x11, x10  
    sw x10, 0(x12)              
    ret

# Moves user representation to the left and checks for collision
moveLeft:
    lw x3 0(x12)
    xor x10, x11, x3
    slli x11, x11, 1  
    and x13, x11, x10 
    bge x13, x6, lose
    or x10, x11, x10  
    sw x10, 0(x12)              
    ret

# Moves user representation down and checks for collision
moveDown:
    lw x13, -4(x12)
    lw x3, 0(x12)
    and x16, x13, x11 
    bge x16, x6 lose 
    xor x3, x11, x3 
    sw x3 0(x12) 
    or x13, x11, x13 
    sw x13 -4(x12) 
    addi x12, x12, -4 
    ret

# Moves user representation up and checks for collision
moveUp:
    lw x13, 4(x12)
    lw x3, 0(x12)  
    and x16, x13, x11   
    bge x16, x6 lose 
    xor x3, x11, x3
    sw x3 0(x12)  
    or x13, x11, x13 
    sw x13 4(x12) 
    addi x12, x12, 4
    ret

#check if player is in the win zone (bottom right)
checkWin:
    bge x11, x15, mainLoop
    bge x12, x14, mainLoop
    jal x16, win

# display WIN on screen and do not return to the main loop
win:
    sw x0, 60(x0)
    sw x0, 56(x0)
    sw x0, 52(x0)
    sw x0, 48(x0)
    lui x10, 0b01001001011111010001
    sw x10, 44(x0)
    lui x10, 0b01001001000100011001
    sw x10, 40(x0)
    lui x10, 0b01001001000100011101
    sw x10, 36(x0)
    lui x10, 0b01001001000100010111
    sw x10, 32(x0)
    lui x10, 0b01001001000100010011
    sw x10, 28(x0)
    lui x10, 0b01001001000100010011
    sw x10, 24(x0)
    lui x10, 0b00111110011111010001
    sw x10, 24(x0)
    sw x0, 20(x0)
    sw x0, 16(x0)
    sw x0, 12(x0)
    sw x0, 8(x0)
    sw x0, 4(x0)
    sw x0, 0(x0)


# Display lose sad face on screen :( and do not return to the main loop
lose:
    sw x0, 60(x0)
    sw x0, 56(x0)
    sw x0, 52(x0)
    lui x10, 0b00010000000000010000
    sw x10, 48(x0)
    sw x0, 44(x0)
    sw x0, 40(x0)
    sw x0, 36(x0)
    lui x10, 0b00001111111111100000
    sw x10, 32(x0)
    lui x10, 0b00010000000000010000
    sw x10, 28(x0)
    lui x10, 0b00100000000000001000
    sw x10, 24(x0)
    lui x10, 0b01000000000000000100
    sw x10, 20(x0)
    sw x10, 16(x0)
    sw x10, 12(x0)
    sw x0, 8(x0)
    sw x0, 4(x0)
    sw x0, 0(x0)