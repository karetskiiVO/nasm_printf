#include "asmprint.h"
#include <stdio.h>

int main () {
    const char* b = "aboba %s\n";
    printf("%p %d\n", b, print_(0, 0, 0, 0, 0, 0, b, 14, "biba"));
    //prtf(b, "biba");
    

    return 0;
}