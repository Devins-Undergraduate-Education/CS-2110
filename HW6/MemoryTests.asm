.orig x3000
    AND R0, R0, 0
    ADD R0, R0, 7
    JSR FOO
    ADD R0, R1, R0
    AND R1, R1, 0
    HALT
.end

.orig x300F
FOO     NOT R0, R0
        ADD R0, R0, 1
        LD R1, MYLABEL
        ADD R7, R7, R1
        NOT R1, R1
        ADD R1, R1, 1
        RET
MYLABEL .fill x0002
.end