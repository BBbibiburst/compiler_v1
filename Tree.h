#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#pragma once
union lexical_type{
    int type_int;
    float type_float;
    char* type_string;
};
typedef union lexical_type lexical_type;
struct lexical_message{
    char* lexical_name;
    lexical_type val;
    int location;
};
typedef struct lexical_message node_val;
struct Node{
    node_val val;
    int child_num;
    struct Node** childList;
};
node_val val(char* lexical_name,char* val,int location);
typedef struct Node TreeNode;
typedef TreeNode* Tree;
Tree CreateTreeNode(node_val val);
void AddChild(Tree root,Tree child);
void PrintTreeNodeMessage(Tree root,int col);
void PreorderTraversal(Tree root,int col);
int IntegerParser(char* str);
int OctParser(char* str);
int HexParser(char* str);

