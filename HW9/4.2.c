#include <stdio.h>

int main(void) {
    int a = 1;
    int b = 0;
    int c = (a&&b) || (b) ? (a&&b) : (a||b);
    printf("%c", 'a');
    printf("%d", c); 
}