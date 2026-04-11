#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>

typedef int (*fptr)(int, int);  
                    

int main() {

    char op[6]; // 5+1 for \0
    int num1, num2;

    while (scanf("%s %d %d", op, &num1, &num2)==3) {

        char libname[15];
        strcpy(libname, "./lib");
        strcat(libname, op);
        strcat(libname, ".so");

        void* handle = dlopen(libname, RTLD_LAZY); 
        
        fptr func = dlsym(handle, op);     
        int result = func(num1, num2);

        printf("%d\n", result);

        dlclose(handle);

    }

    
    return 0;
}