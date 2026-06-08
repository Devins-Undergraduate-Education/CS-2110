#include <stdio.h>

int main(void) {
    int x = 4;
    int y = (++x) - 2;
    int z = x + (y++);

    printf("%d", x);
    printf("%d", y);
    printf("%d", z);
}