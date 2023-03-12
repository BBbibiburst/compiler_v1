%{
#include <stdio.h>
#include "lex.yy.c"
#include "Tree.h"
void yyerror(char* msg);
int syntax_error = 0;
Tree syntax_tree;
%}
/* declared types*/
%union {
    int type_int;
    float type_float;
    char* type_str;
    void* type_tree;
}
/* declared tokens */
%token <type_int> INT
%token <type_str> FLOAT
%token <type_str> ID
%token <type_str> RELOP
%token <type_str> TYPE
%token <type_str> ASSIGNOP
%token <type_str> PLUS MINUS STAR DIV
%token <type_str> AND OR NOT
%token <type_str> DOT SEMI COMMA LP RP LB RB LC RC
%token <type_str> STRUCT RETURN IF ELSE WHILE

%type <type_tree> Program ExtDefList ExtDef ExtDecList
%type <type_tree> Specifier StructSpecifier OptTag Tag
%type <type_tree> VarDec FunDec VarList ParamDec
%type <type_tree> CompSt StmtList Stmt
%type <type_tree> DefList Def Dec DecList
%type <type_tree> Exp Args

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
Program : ExtDefList {$$=CreateTreeNode(val("Program",0,@$.first_line));syntax_tree = $$;AddChild(syntax_tree,$1);}
;
ExtDefList : ExtDef ExtDefList {$$=CreateTreeNode(val("ExtDefList",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);}
| /* empty */ {$$=CreateTreeNode(val("ExtDefList",0,@$.first_line));}
;
ExtDef : Specifier ExtDecList SEMI {$$=CreateTreeNode(val("ExtDef",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);
AddChild($$,CreateTreeNode(val("SEMI",0,@3.first_line)));}
| Specifier SEMI {$$=CreateTreeNode(val("ExtDef",0,@$.first_line));AddChild($$,$1);AddChild($$,CreateTreeNode(val("SEMI",0,@2.first_line)));}
| Specifier FunDec CompSt {$$=CreateTreeNode(val("ExtDef",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);AddChild($$,$3);}
;
ExtDecList : VarDec {$$=CreateTreeNode(val("ExtDecList",0,@$.first_line));AddChild($$,$1);}
| VarDec COMMA ExtDecList {$$=CreateTreeNode(val("ExtDecList",0,@$.first_line));AddChild($$,$1);AddChild($$,CreateTreeNode(val("COMMA",0,@2.first_line)));AddChild($$,$3);}
;
Specifier : TYPE {$$=CreateTreeNode(val("Specifier",0,@$.first_line));AddChild($$,CreateTreeNode(val("TYPE",$1,@1.first_line)));}
| StructSpecifier {$$=CreateTreeNode(val("Specifier",0,@$.first_line));AddChild($$,$1);}
;
StructSpecifier : STRUCT OptTag LC DefList RC {$$=CreateTreeNode(val("StructSpecifier",0,@$.first_line));AddChild($$,CreateTreeNode(val("STRUCT",0,@1.first_line)));AddChild($$,$2);
AddChild($$,CreateTreeNode(val("LC",0,@3.first_line)));AddChild($$,$4);AddChild($$,CreateTreeNode(val("RC",0,@3.first_line)));}
| STRUCT Tag {$$=CreateTreeNode(val("StructSpecifier",0,@$.first_line));AddChild($$,CreateTreeNode(val("STRUCT",0,@1.first_line)));AddChild($$,$2);}
;
OptTag : ID {$$=CreateTreeNode(val("OptTag",0,@$.first_line));AddChild($$,CreateTreeNode(val("ID",$1,@1.first_line)));}
| /* empty */ {$$=CreateTreeNode(val("OptTag",0,@$.first_line));}
;
Tag : ID {$$=CreateTreeNode(val("Tag",0,@$.first_line));AddChild($$,CreateTreeNode(val("ID",$1,@1.first_line)));}
;
VarDec : ID {$$=CreateTreeNode(val("VarDec",0,@$.first_line));AddChild($$,CreateTreeNode(val("ID",$1,@1.first_line)));}
| VarDec LB INT RB {$$=CreateTreeNode(val("VarDec",0,@$.first_line));AddChild($$,$1);AddChild($$,CreateTreeNode(val("LB",0,@2.first_line)));AddChild($$,CreateTreeNode(val("INT",$3,@3.first_line)));AddChild($$,CreateTreeNode(val("RB",0,@4.first_line)));}
;
FunDec : ID LP VarList RP {$$=CreateTreeNode(val("FunDec",0,@$.first_line));AddChild($$,CreateTreeNode(val("ID",$1,@1.first_line)));AddChild($$,CreateTreeNode(val("LP",0,@2.first_line)));AddChild($$,$3);AddChild($$,CreateTreeNode(val("RP",0,@4.first_line)));}
| ID LP RP {$$=CreateTreeNode(val("FunDec",0,@$.first_line));
AddChild($$,CreateTreeNode(val("ID",$1,@1.first_line)));
AddChild($$,CreateTreeNode(val("LP",0,@2.first_line)));
AddChild($$,CreateTreeNode(val("RP",0,@3.first_line)));}
;
VarList : ParamDec COMMA VarList {$$=CreateTreeNode(val("VarList",0,@$.first_line));AddChild($$,$1);AddChild($$,CreateTreeNode(val("COMMA",0,@2.first_line)));AddChild($$,$3);}
| ParamDec {$$=CreateTreeNode(val("VarList",0,@$.first_line));AddChild($$,$1);}
;
ParamDec : Specifier VarDec {$$=CreateTreeNode(val("ParamDec",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);}
;
CompSt : LC DefList StmtList RC {$$=CreateTreeNode(val("CompSt",0,@$.first_line));AddChild($$,CreateTreeNode(val("LC",0,@1.first_line)));AddChild($$,$2);AddChild($$,$3);AddChild($$,CreateTreeNode(val("RC",0,@4.first_line)));}
;
StmtList : Stmt StmtList {$$=CreateTreeNode(val("StmtList",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);}
| /* empty */ {$$=CreateTreeNode(val("StmtList",0,@$.first_line));}
;
Stmt : Exp SEMI {$$=CreateTreeNode(val("Stmt",0,@$.first_line));AddChild($$,$1);AddChild($$,CreateTreeNode(val("SEMI",0,@2.first_line)));}
| CompSt {$$=CreateTreeNode(val("Stmt",0,@$.first_line));AddChild($$,$1);}
| RETURN Exp SEMI {$$=CreateTreeNode(val("Stmt",0,@$.first_line));AddChild($$,CreateTreeNode(val("RETURN",0,@1.first_line)));AddChild($$,$2);AddChild($$,CreateTreeNode(val("SEMI",0,@3.first_line)));}
| IF LP Exp RP Stmt %prec LOWER_THAN_ELSE {$$=CreateTreeNode(val("Stmt",0,@$.first_line));
AddChild($$,CreateTreeNode(val("IF",0,@1.first_line)));
AddChild($$,CreateTreeNode(val("LP",0,@2.first_line)));
AddChild($$,$3);
AddChild($$,CreateTreeNode(val("RP",0,@4.first_line)));
AddChild($$,$5);}
| IF LP Exp RP Stmt ELSE Stmt {$$=CreateTreeNode(val("Stmt",0,@$.first_line));
AddChild($$,CreateTreeNode(val("IF",0,@1.first_line)));
AddChild($$,CreateTreeNode(val("LP",0,@2.first_line)));
AddChild($$,$3);
AddChild($$,CreateTreeNode(val("RP",0,@4.first_line)));
AddChild($$,$5);
AddChild($$,CreateTreeNode(val("ELSE",0,@6.first_line)));
AddChild($$,$7);}
| WHILE LP Exp RP Stmt {$$=CreateTreeNode(val("Stmt",0,@$.first_line));
AddChild($$,CreateTreeNode(val("WHILE",0,@1.first_line)));
AddChild($$,CreateTreeNode(val("LP",0,@2.first_line)));
AddChild($$,$3);
AddChild($$,CreateTreeNode(val("RP",0,@4.first_line)));
AddChild($$,$5);}
;
DefList : Def DefList {$$=CreateTreeNode(val("DefList",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);}
| /* empty */ {$$=CreateTreeNode(val("DefList",0,@$.first_line));}
;
Def : Specifier DecList SEMI {$$=CreateTreeNode(val("Def",0,@$.first_line));AddChild($$,$1);AddChild($$,$2);AddChild($$,CreateTreeNode(val("SEMI",0,@3.first_line)));}
;
DecList : Dec {$$=CreateTreeNode(val("DecList",0,@$.first_line));AddChild($$,$1);}
| Dec COMMA DecList {$$=CreateTreeNode(val("DecList",0,@$.first_line));AddChild($$,$1);AddChild($$,CreateTreeNode(val("COMMA",0,@2.first_line)));AddChild($$,$3);}
;
Dec : VarDec {$$=CreateTreeNode(val("Dec",0,@$.first_line));AddChild($$,$1);}
| VarDec ASSIGNOP Exp {$$=CreateTreeNode(val("Dec",0,@$.first_line));AddChild($$,$1);AddChild($$,CreateTreeNode(val("ASSIGNOP",0,@2.first_line)));AddChild($$,$3);}
;
Exp : Exp ASSIGNOP Exp {$$=CreateTreeNode(val("Exp",0,@$.first_line));AddChild($$,$1);AddChild($$,CreateTreeNode(val("ASSIGNOP",0,@2.first_line)));AddChild($$,$3);}
| Exp AND Exp {$$=CreateTreeNode(val("Exp",0,@$.first_line));AddChild($$,$1);AddChild($$,CreateTreeNode(val("AND",0,@2.first_line)));AddChild($$,$3);}
| Exp OR Exp {$$=CreateTreeNode(val("Exp",0,@$.first_line));AddChild($$,$1);AddChild($$,CreateTreeNode(val("OR",0,@2.first_line)));AddChild($$,$3);}
| Exp RELOP Exp {$$=CreateTreeNode(val("Exp",0,@$.first_line));AddChild($$,$1);AddChild($$,CreateTreeNode(val("RELOP",0,@2.first_line)));AddChild($$,$3);}
| Exp PLUS Exp {$$=CreateTreeNode(val("Exp",0,@$.first_line));AddChild($$,$1);AddChild($$,CreateTreeNode(val("PLUS",0,@2.first_line)));AddChild($$,$3);}
| Exp MINUS Exp {$$=CreateTreeNode(val("Exp",0,@$.first_line));AddChild($$,$1);AddChild($$,CreateTreeNode(val("MINUS",0,@2.first_line)));AddChild($$,$3);}
| Exp STAR Exp {$$=CreateTreeNode(val("Exp",0,@$.first_line));AddChild($$,$1);AddChild($$,CreateTreeNode(val("STAR",0,@2.first_line)));AddChild($$,$3);}
| Exp DIV Exp {$$=CreateTreeNode(val("Exp",0,@$.first_line));AddChild($$,$1);AddChild($$,CreateTreeNode(val("DIV",0,@2.first_line)));AddChild($$,$3);}
| LP Exp RP {$$=CreateTreeNode(val("Exp",0,@$.first_line));AddChild($$,$1);AddChild($$,CreateTreeNode(val("EXP",0,@2.first_line)));AddChild($$,$3);}
| MINUS Exp {$$=CreateTreeNode(val("Exp",0,@$.first_line));AddChild($$,CreateTreeNode(val("MINUS",0,@1.first_line)));AddChild($$,$2);}
| NOT Exp {$$=CreateTreeNode(val("Exp",0,@$.first_line));AddChild($$,CreateTreeNode(val("NOT",0,@1.first_line)));AddChild($$,$2);}
| ID LP Args RP {$$=CreateTreeNode(val("Exp",0,@$.first_line));
AddChild($$,CreateTreeNode(val("ID",$1,@1.first_line)));
AddChild($$,CreateTreeNode(val("LP",0,@2.first_line)));
AddChild($$,$3);
AddChild($$,CreateTreeNode(val("RP",0,@4.first_line)));}
| ID LP RP {$$=CreateTreeNode(val("Exp",0,@$.first_line));
AddChild($$,CreateTreeNode(val("ID",$1,@1.first_line)));
AddChild($$,CreateTreeNode(val("LP",0,@2.first_line)));
AddChild($$,CreateTreeNode(val("RP",0,@3.first_line)));}
| Exp LB Exp RB {$$=CreateTreeNode(val("Exp",0,@$.first_line));AddChild($$,$1);AddChild($$,CreateTreeNode(val("LB",0,@2.first_line)));AddChild($$,$3);AddChild($$,CreateTreeNode(val("RP",0,@4.first_line)));}
| Exp DOT ID {$$=CreateTreeNode(val("Exp",0,@$.first_line));AddChild($$,$1);
AddChild($$,CreateTreeNode(val("DOT",0,@2.first_line)));AddChild($$,CreateTreeNode(val("ID",$3,@3.first_line)));}
| ID {$$=CreateTreeNode(val("Exp",0,@$.first_line));AddChild($$,CreateTreeNode(val("ID",$1,@1.first_line)));}
| INT {$$=CreateTreeNode(val("Exp",0,@$.first_line));AddChild($$,CreateTreeNode(val("INT",$1,@1.first_line)));}
| FLOAT {$$=CreateTreeNode(val("Exp",0,@$.first_line));Tree float_tree =CreateTreeNode(val("FLOAT",$1,@1.first_line));AddChild($$,float_tree);float_tree->val.val.type_float=(float)atof(float_tree->val.val.type_string);}
;
Args : Exp COMMA Args {$$=CreateTreeNode(val("Args",0,@$.first_line));AddChild($$,$1);AddChild($$,CreateTreeNode(val("COMMA",0,@2.first_line)));AddChild($$,$3);}
| Exp {$$=CreateTreeNode(val("Args",0,@$.first_line));AddChild($$,$1);}
;
%%
void yyerror(char* msg) {
    fprintf(stderr, "error: %s\n", msg);
}