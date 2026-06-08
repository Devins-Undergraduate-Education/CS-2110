.orig x3000
    LD R4, LENGTH
HALT
    
LENGTH .fill 6
ARRAY .fill x3100
.end

.orig x3100
    .fill 4
    .fill -8
    .fill -3
    .fill 7
    .fill 2
    .fill -6
.end