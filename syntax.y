%{
#include <stdio.h>
#include "Tree.h"
#define YYSTYPE Tree
#include "lex.yy.c"
void yyerror(char* msg);
int syntax_error = 0;
Tree syntax_tree;
%}

%token  INT
%token  FLOAT
%token  ID ID_ERROR
%token  RELOP
%token  TYPE
%token  ASSIGNOP
%token  PLUS MINUS STAR DIV
%token  AND OR NOT
%token  DOT SEMI COMMA LP RP LB RB LC RC
%token  STRUCT RETURN IF ELSE WHILE

%type  Program ExtDefList ExtDef ExtDecList
%type  Specifier StructSpecifier OptTag Tag
%type  VarDec FunDec VarList ParamDec
%type  CompSt StmtList Stmt
%type  DefList Def Dec DecList
%type  Exp Args

%start Program
%right ASSIGNOP
%left OR
%left AND
%left RELOP
%left PLUS MINUS
%left STAR DIV
%right NOT // single_minus
%left DOT
%left LB RB
%left LP RP
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%
Program : ExtDefList {$$=CreateTreeNode(val("Program",0,@$.first_line));syntax_tree=$$;AddChild($$,$1);}
;//程序->全局变量、结构体或函数的定义列表
ExtDefList : ExtDef ExtDefList {$$=CreateTreeNode(val("ExtDefList",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);}
| /* empty */ {$$=CreateTreeNode(val("ExtDefList",0,@$.first_line));}
;//全局变量、结构体或函数的定义列表->若干全局变量、结构体或函数的定义
ExtDef : Specifier ExtDecList SEMI {$$=CreateTreeNode(val("ExtDef",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);AddChild($$,$3);}//全局变量
| Specifier SEMI {$$=CreateTreeNode(val("ExtDef",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);}//结构体等类型定义
| Specifier FunDec CompSt {$$=CreateTreeNode(val("ExtDef",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);AddChild($$,$3);}//函数定义
| error SEMI {yyerror("syntax error");}
;//全局变量、结构体或函数的定义
ExtDecList : VarDec {$$=CreateTreeNode(val("ExtDecList",0,@$.first_line));AddChild($$,$1);}
| VarDec COMMA ExtDecList {$$=CreateTreeNode(val("ExtDecList",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);AddChild($$,$3);}
;//全局变量，全局数组变量列表
Specifier : TYPE {$$=CreateTreeNode(val("Specifier",0,@$.first_line));AddChild($$,$1);}
| StructSpecifier {$$=CreateTreeNode(val("Specifier",0,@$.first_line));AddChild($$,$1);}
;//标准类型和结构体
StructSpecifier : STRUCT OptTag LC DefList RC {$$=CreateTreeNode(val("StructSpecifier",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);AddChild($$,$3);AddChild($$,$4);AddChild($$,$5);}
| STRUCT Tag {$$=CreateTreeNode(val("StructSpecifier",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);}
;//结构体定义
OptTag : ID {$$=CreateTreeNode(val("OptTag",0,@$.first_line));AddChild($$,$1);}
| ID_ERROR {yyerror("syntax error");}
| /* empty */ {$$=CreateTreeNode(val("OptTag",0,@$.first_line));}
;//结构体名可省略
Tag : ID {$$=CreateTreeNode(val("Tag",0,@$.first_line));}
| ID_ERROR {yyerror("syntax error");}
;//标识
VarDec : ID {$$=CreateTreeNode(val("VarDec",0,@$.first_line));AddChild($$,$1);}
| ID_ERROR {yyerror("syntax error");}
| VarDec LB INT RB {$$=CreateTreeNode(val("VarDec",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);AddChild($$,$3);AddChild($$,$4);}
| error RB {yyerror("syntax error");}
;//变量或数组变量
FunDec : ID LP VarList RP {$$=CreateTreeNode(val("FunDec",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);AddChild($$,$3);AddChild($$,$4);}
| ID LP RP {$$=CreateTreeNode(val("FunDec",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);AddChild($$,$3);}
| error RP {yyerror("syntax error");}
;//函数头
VarList : ParamDec COMMA VarList {$$=CreateTreeNode(val("VarList",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);AddChild($$,$3);}
| ParamDec {$$=CreateTreeNode(val("VarList",0,@$.first_line));AddChild($$,$1);}
;//函数参数列表
ParamDec : Specifier VarDec {$$=CreateTreeNode(val("ParamDec",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);}
;//函数参数
CompSt : LC DefList StmtList RC {$$=CreateTreeNode(val("CompSt",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);AddChild($$,$3);AddChild($$,$4);}
|  error RC {yyerror("syntax error");}
;//函数体（先定义在使用）
StmtList : Stmt StmtList {$$=CreateTreeNode(val("StmtList",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);}
| /* empty */ {$$=CreateTreeNode(val("StmtList",0,@$.first_line));}
;//语句列表
Stmt : Exp SEMI {$$=CreateTreeNode(val("Stmt",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);}
| CompSt {$$=CreateTreeNode(val("Stmt",0,@$.first_line));AddChild($$,$1);}
| RETURN Exp SEMI {$$=CreateTreeNode(val("Stmt",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);AddChild($$,$3);}
| IF LP Exp RP Stmt %prec LOWER_THAN_ELSE {$$=CreateTreeNode(val("Stmt",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);AddChild($$,$3);AddChild($$,$4);AddChild($$,$5);}
| IF LP Exp RP Stmt ELSE Stmt {$$=CreateTreeNode(val("Stmt",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);AddChild($$,$3);AddChild($$,$4);AddChild($$,$5);AddChild($$,$6);AddChild($$,$7);}
| WHILE LP Exp RP Stmt {$$=CreateTreeNode(val("Stmt",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);AddChild($$,$3);AddChild($$,$4);AddChild($$,$5);}
| IF error {yyerror("syntax error");}
| RETURN error {yyerror("syntax error");}
| WHILE error {yyerror("syntax error");}
| error SEMI {yyerror("syntax error");}
;//语句
DefList : Def DefList {$$=CreateTreeNode(val("DefList",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);}
| /* empty */ {$$=CreateTreeNode(val("DefList",0,@$.first_line));}
;
Def : Specifier DecList SEMI {$$=CreateTreeNode(val("Def",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);AddChild($$,$3);}
| Specifier error SEMI {yyerror("syntax error");}
| Specifier DecList error {yyerror("syntax error");}
;//TODO
DecList : Dec {$$=CreateTreeNode(val("DecList",0,@$.first_line));AddChild($$,$1);}
| Dec COMMA DecList {$$=CreateTreeNode(val("DecList",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);AddChild($$,$3);}
;
Dec : VarDec {$$=CreateTreeNode(val("Dec",0,@$.first_line));AddChild($$,$1);}
| VarDec ASSIGNOP Exp {$$=CreateTreeNode(val("Dec",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);AddChild($$,$3);}
;
Exp : Exp ASSIGNOP Exp {$$=CreateTreeNode(val("Exp",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);AddChild($$,$3);}
| Exp AND Exp {$$=CreateTreeNode(val("Exp",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);AddChild($$,$3);}
| Exp OR Exp {$$=CreateTreeNode(val("Exp",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);AddChild($$,$3);}
| Exp RELOP Exp {$$=CreateTreeNode(val("Exp",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);AddChild($$,$3);}
| Exp PLUS Exp {$$=CreateTreeNode(val("Exp",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);AddChild($$,$3);}
| Exp MINUS Exp {$$=CreateTreeNode(val("Exp",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);AddChild($$,$3);}
| Exp STAR Exp {$$=CreateTreeNode(val("Exp",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);AddChild($$,$3);}
| Exp DIV Exp {$$=CreateTreeNode(val("Exp",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);AddChild($$,$3);}
| LP Exp RP {$$=CreateTreeNode(val("Exp",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);AddChild($$,$3);}
| MINUS Exp {$$=CreateTreeNode(val("Exp",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);}
| NOT Exp {$$=CreateTreeNode(val("Exp",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);}
| ID LP Args RP {$$=CreateTreeNode(val("Exp",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);AddChild($$,$3);AddChild($$,$4);}
| ID LP RP {$$=CreateTreeNode(val("Exp",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);AddChild($$,$3);}
| Exp LB Exp RB {$$=CreateTreeNode(val("Exp",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);AddChild($$,$3);AddChild($$,$4);}
| Exp DOT ID {$$=CreateTreeNode(val("Exp",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);AddChild($$,$3);}
| ID {$$=CreateTreeNode(val("Exp",0,@$.first_line));AddChild($$,$1);}
| INT {$$=CreateTreeNode(val("Exp",0,@$.first_line));AddChild($$,$1);}
| FLOAT {$$=CreateTreeNode(val("Exp",0,@$.first_line));AddChild($$,$1);}
| error RP {yyerror("syntax error");}
| Exp DOT ID_ERROR {yyerror("syntax error");}
| ID_ERROR {yyerror("syntax error");}
;//表达式
Args : Exp COMMA Args {$$=CreateTreeNode(val("Args",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);AddChild($$,$3);}
| Exp {$$=CreateTreeNode(val("Args",0,@$.first_line));AddChild($$,$1);}
;
%%
void yyerror(char* msg) {
    syntax_error = 1;
    fprintf(stderr, "Error type B at Line %d: %s.\n",yylineno, msg);
}