.orig x3000
        
        ; Clear used registers
        AND R0, R0, 0 ; R0 WILL STORE THE LENGTH
        AND R1, R1, 0 ; R1 WILL STORE THE ADDERESS
        AND R2, R2, 0 ; R2 WILL STORE THE DATA
        
        LD R0, LENGTH   ; Load the length of the array into R0
        LD R1, ARRAY   ; Load the base address of the array into R1
        ADD R1, R1, -1 ; subtract one to get the correct adderess 
        ADD R1, R1, R0  ; Move R1 to the last element (R1 = ARRAY + LENGTH)
        LDR R2, R1, 0  ; Load the value of the last element into R2

        BRzp POSITIVE   ; Branch if the last value is positive or zero
            NOT R2, R2      ; Flip the sign of R2 (take 2's complement)
            ADD R2, R2, 1  ; Add 1 to complete the 2's complement negation
            STR R2, R1, 0
            BR END 
        POSITIVE AND R2, R2, 0 ; else
        STR R2, R1, 0 
    
    END HALT

LENGTH  .fill 6
ARRAY   .fill x3100
.end

.orig x3100
        .fill 4
        .fill -8
        .fill -3
        .fill 7
        .fill 2
        .fill -6 ; if this number is negative, flip it. If it is positive or zero, make it zero.
.end