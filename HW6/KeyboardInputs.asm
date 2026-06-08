.orig x3000
    LEA R1, BUFFER ; load the address of the 100 memory locations into R1
START
    LDI R1, KBSRADDR ; get a char from keyboard and store in R0
    
    BRzp START ; char cannot be a number
    
    LD R0, KBDRADDR
    
    STR R0, R1, 0 ; the value of R0 is stored in the address of R1
    
    LD R2, TERMINATOR 
    NOT R2, R2
    ADD R2, R2, 1 ; ends with R2 = 0xFF85 = -123
    
    ADD R0, R0, R2 ; adds -123 to R0
    BRz END
    ADD R1, R1, 1
    BR START
END
HALT

KBSRADDR .fill xFE00
KBDRADDR .fill xFE02
TERMINATOR .fill x7A
BUFFER .blkw 100 ; reserve 100 locations for memory at R0...? 
.end