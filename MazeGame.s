createMaze: 
    addi x6, x0, -1         #top/bottom row of maze
    # store maze design in memory
    sw x6,  0(x0)
    sw x6,  60(x0)
     ret              # PC -> x1 (return address)