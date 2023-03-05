#include <stdio.h>
#include "../flex_analyse/lex.yy.c"
extern int flex_error;
int main(int argc,char** argv) {
    if(argc<=1){
        printf("Compile Error:  Input file less than 1!");
        return 0;
    }
    char* filename = argv[1];
    FILE *fp =fopen(filename,"r");
    if(!fp){
        printf("Compile Error:  Input file not found!");
    }
    flex_analyse(fp);
    return 0;
}
