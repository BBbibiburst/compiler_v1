#include <stdio.h>
#include "syntax.tab.h"
#include "Tree.h"
extern int flex_error;
extern int syntax_error;
extern Tree syntax_tree;
extern int yyparse();
extern void yyrestart(FILE* f);
int main(int argc,char** argv) {
    if(argc<=1){
        printf("Error:  Input file less than 1!");
        return 0;
    }
    char* filename = argv[1];
    FILE *fp =fopen(filename,"r");
    if(!fp){
        printf("Error:  Input file not found!");
    }
    yyrestart(fp);
    yyparse();
    if(flex_error||syntax_error){
        return 1;
    }
    PreorderTraversal(syntax_tree,0);
    return 0;
}
