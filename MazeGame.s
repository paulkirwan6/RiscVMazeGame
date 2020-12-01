# Maze Game by Paul Kirwan and Mollie Fairclough
# Used with Vicilogic
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
addi x14, x0, 8
addi x15, x0, 15
addi x6, x0, 1       #move right
addi x7, x0, 0b10    #move left
addi x8, x0 0b100    #move down
addi x9, x0 0b1000   #move up

mainLoop:
    jal x1, userInput
    jal x1, checkWin
    beq x0, x0, mainLoop    # loop until reset asserted

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
    LUI x23, 557056         # end point
    addi x23, x23, 5
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
    sw x23,  8(x0)
    sw x21,  4(x0)
    sw x16,  0(x0)
    ret              # PC -> x1 (return address)

# Takes 16-bit user input and stores in x4
userInput:
    lui x5 0x10
    lw x4, 0xc(x5)
    beq x4, x6, moveRight
    beq x4, x7, moveLeft
    beq x4, x8, moveDown
    beq x4, x9, moveUp
    ret

#OR the players position with the row of maze and
moveRight:
    lw x3 0(x12) # x3 = 1000100000000001
    xor x10, x11, x3 # x10 = 10000000000000001
    srli x11, x11, 1   # move user location in 11 by 1
    and x13, x11, x10 # colision check
    bge x13, x6, lose
    or x10, x11, x10   # add user and maze and save in 11
    sw x10, 0(x12)              
    ret

moveLeft:
    lw x3 0(x12) # x3 = 1000100000000001
    xor x10, x11, x3 # x10 = 10000000000000001
    slli x11, x11, 1   # move user location in 11 by 1
    and x13, x11, x10 # colision check
    bge x13, x6, lose
    or x10, x11, x10   # add user and maze and save in 11
    sw x10, 0(x12)              
    ret

moveDown:
    lw x13, -4(x12) # set destination row
    lw x3, 0(x12)  # set current row
    and x16, x13, x11   #check if we will hit wall
    bge x16, x6 lose #u have bonked go to jail
    xor x3, x11, x3 # removing ourselves from current row
    sw x3 0(x12)  # saving current empty row
    or x13, x11, x13 # adding ourselves to new row
    sw x13 -4(x12)  # saving new row with us in it
    addi x12, x12, -4 # setting x12 to new current row
    ret

moveUp:
    lw x13, 4(x12) # set destination row
    lw x3, 0(x12)  # set current row
    and x16, x13, x11   #check if we will hit wall
    bge x16, x6 lose #u have bonked go to jail
    xor x3, x11, x3 # removing ourselves from current row
    sw x3 0(x12)  # saving current empty row
    or x13, x11, x13 # adding ourselves to new row
    sw x13 4(x12)  # saving new row with us in it
    addi x12, x12, 4 # setting x12 to new current row
    ret

#check if player is in bottom right zone
checkWin:
    bge x11, x15, mainLoop      # x-position
    bge x12, x14, mainLoop      # y-position
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


# Display lose sad face on screen :(
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