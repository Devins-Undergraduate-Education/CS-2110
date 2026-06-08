.orig x3000
    AND R0, R0, 0
    AND R1, R1, 0
HERE ADD R0, R0, -1
    BRzp 5
    ADD R1, R1, 4
SKIP LEA R2, A
    LD R3, B
    ADD R4, R3, R1
    BRnp END
    ST R4, A
END TRAP x25

A .fill 12
B .fill -3
.end