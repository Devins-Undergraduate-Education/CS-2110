#include <stdio.h>

int main() {
    char *ptr1 = (char *)0x401E;
    char *ptr2 = (char *)0x4009;
    char *ptr3 = (char *)((int *)0x4005 + 2);
    char *ptr4 = (char *)((short *)ptr2 + 3);

    // Test for each expression

    printf("ptr1 + 4: %p\n\n\n", ptr1 + 4);
    printf("\n\n");
    printf("(int *)ptr1 + 4: %p\n", (int *)ptr1 + 4);
    printf("(int *)ptr1 + 1: %p\n", (int *)ptr1 + 1);
    printf("(short *)ptr1 + 2: %p\n", (short *)ptr1 + 2);
    printf("&ptr1[4]: %p\n", &ptr1[4]);
    //printf("ptr1[4]: %d\n", ptr1[4]);

    return 0;
}
