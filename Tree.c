#include "Tree.h"
#define MAXNODES 10
int is_terminal_symbol(char* str){
    char* text[21] = {"Program","ExtDefList","ExtDef","ExtDecList", "Specifier", "StructSpecifier", "OptTag", "Tag", "VarDec", "FunDec", "VarList", "ParamDec", "CompSt", "StmtList", "Stmt", "DefList", "Def", "Dec", "DecList", "Exp", "Args"};
    for(int i = 0;i<21;i++){
        if(!strcmp(text[i],str)){
            return 0;
        }
    }
    return 1;
}
node_val val(char* lexical_name,char* val,int location){
    node_val nodeVal;
    nodeVal.lexical_name = lexical_name;
    nodeVal.val.type_string = val;
    nodeVal.location = location;
    return nodeVal;
}
Tree CreateTreeNode(node_val val){
    Tree tree = (Tree)malloc(sizeof(TreeNode));
    tree->val = val;
    tree->child_num = 0;
    tree->childList = NULL;
    return tree;
}
void AddChild(Tree root,Tree child){
    if(root->child_num>=MAXNODES){
        printf("Assert Error:Max Nodes Arrived!");
        return;
    }
    root->child_num++;
    if(root->childList==NULL){
        root->childList = (Tree*)malloc(MAXNODES*sizeof(Tree));
    }
    root->childList[root->child_num-1] = child;
}
void PrintTreeNodeMessage(Tree root,int col){
    for(int i = 0;i<col;i++){
        printf(" ");
        printf(" ");
    }
    printf("%s",root->val.lexical_name);
    if(!strcmp("INT",root->val.lexical_name))
        printf(": %d\n",root->val.val.type_int);
    else if(!strcmp("FLOAT",root->val.lexical_name))
        printf(": %f\n",root->val.val.type_float);
    else if(!strcmp("TYPE",root->val.lexical_name)||!strcmp("ID",root->val.lexical_name)){
        printf(": %s\n",root->val.val.type_string);
    }
    else if (is_terminal_symbol(root->val.lexical_name)){
        printf("\n");
    }
    else
        printf(" (%d)\n",root->val.location);
}
void PreorderTraversal(Tree root,int col){
    if(root){
        if (is_terminal_symbol(root->val.lexical_name)||root->child_num!=0)
            PrintTreeNodeMessage(root,col);
        for(int i =0;i<root->child_num;i++){
            PreorderTraversal(root->childList[i],col+1);
        }
    }
}
int HexParser(char* str){
    int res = 0;
    int i = 2;
    while(str[i]!='\0'){
        res*=16;
        if(str[i]>='0'&&str[i]<='9'){
            res+=str[i]-'0';
        }
        else if(str[i]>='a'&&str[i]<='f'){
            res+=str[i]-'a' + 10;
        }
        else if(str[i]>='A'&&str[i]<='F'){
            res+=str[i]-'A'+ 10;
        }
        i++;
    }
    return res;
}
int OctParser(char* str){
    int res = 0;
    int i = 1;
    while(str[i]!='\0'){
        res*=8;
        res+=str[i]-'0';
        i++;
    }
    return res;
}
int IntegerParser(char* str){
    int str_len = strlen(str);
    if(str_len>1&&str[0]=='0'){
        if(str[1]=='x'||str[1]=='X'){
            return HexParser(str);
        }
        else{
            return OctParser(str);
        }
    }
    return atoi(str);
}
