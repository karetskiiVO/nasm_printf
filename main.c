//#include "asmprint.h"
#include <stdio.h>

//extern int __CRTDECL printf_ (_In_z_ _Printf_format_string_ char const* const format, ...);
extern int printf_ (const char* format, ...);

int main () {
    printf("%d aboba %s\n", 145, "dodido");
    printf_("%d aboba %s\n", 145, "dodido");
    return 0;
}