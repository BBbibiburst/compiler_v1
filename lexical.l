%{
    #pragma once
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    #include "Tree.h"
    #define YYSTYPE Tree
    #include "syntax.tab.h"
    //#define debug_opt 1
    int flex_error = 0;
    int yycolumn = 1;
    #define YY_USER_ACTION \
        yylloc.first_line = yylloc.last_line = yylineno; \
        yylloc.first_column = yycolumn; \
        yylloc.last_column = yycolumn + yyleng - 1; \
        yycolumn += yyleng;
%}
%option yylineno
DEC [1-9][0-9]*|0
OCT 0[1-7][0-7]*|00
HEX 0(X|x)[1-9a-fA-F][0-9a-fA-F]*|0(X|x)0
INT {DEC}|{OCT}|{HEX}
OCT_ERROR 0[0-9]*
HEX_ERROR 0(x|X)[0-9A-Za-z]*
FLOAT [0-9]*\.[0-9]*((E|e)(\+|-)?[0-9]+)?
FLOAT_ERROR [0-9]*\.[0-9]*((E|e)(\+|-)?)
ID [A-Za-z_][A-Za-z_0-9]*
ID_ERROR [A-Za-z_0-9]+
SEMI    ;
COMMA   ,
ASSIGNOP    =
RELOP   >|<|>=|<=|==|!=
PLUS    \+
MINUS   -
STAR    \*
DIV \/
AND &&
OR  \|\|
DOT \.
NOT !
TYPE    "int"|"float"
LP  \(
RP  \)
LB  \[
RB  \]
LC  \{
RC  \}
STRUCT  "struct"
RETURN  "return"
IF  "if"
ELSE    "else"
WHILE   "while"
LINE_ANNOTATION \/\/[^\n]*
MULTI_ANNOTATION \/\*([^\*]|\*[^\/])*\*\/
ANNOTATION {LINE_ANNOTATION}|{MULTI_ANNOTATION}
BLANK [ \t]+
OTHERS [^\n\r\b]
%%
{DOT} {
#ifdef debug_opt
printf("DOT:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
yylval = CreateTreeNode(val("DOT",strdup(yytext),yylineno));
return DOT;
}
{INT} {
#ifdef debug_opt
printf("INT:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
yylval = CreateTreeNode(val("INT",strdup(yytext),yylineno));yylval->val.val.type_int = IntegerParser(strdup(yytext));
return INT;
}
{FLOAT} {
#ifdef debug_opt
printf("FLOAT:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
yylval = CreateTreeNode(val("FLOAT",strdup(yytext),yylineno));yylval->val.val.type_float = (float)atof(strdup(yytext));
return FLOAT;
}
{SEMI} {
#ifdef debug_opt
printf("SEMI:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
yylval = CreateTreeNode(val("SEMI",strdup(yytext),yylineno));
return SEMI;
}
{COMMA} {
#ifdef debug_opt
printf("COMMA:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
yylval = CreateTreeNode(val("COMMA",strdup(yytext),yylineno));
return COMMA;
}
{ASSIGNOP} {
#ifdef debug_opt
printf("AOP:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
yylval = CreateTreeNode(val("ASSIGNOP",strdup(yytext),yylineno));
return ASSIGNOP;
}
{RELOP} {
#ifdef debug_opt
printf("RELOP:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
yylval = CreateTreeNode(val("RELOP",strdup(yytext),yylineno));
return RELOP;
}
{PLUS} {
#ifdef debug_opt
printf("PLUS:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
yylval = CreateTreeNode(val("PLUS",strdup(yytext),yylineno));
return PLUS;
}
{MINUS} {
#ifdef debug_opt
printf("MINUS:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
yylval = CreateTreeNode(val("MINUS",strdup(yytext),yylineno));
return MINUS;
}
{STAR} {
#ifdef debug_opt
printf("STAR:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
yylval = CreateTreeNode(val("STAR",strdup(yytext),yylineno));
return STAR;
}
{DIV} {
#ifdef debug_opt
printf("DIV:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
yylval = CreateTreeNode(val("DIV",strdup(yytext),yylineno));
return DIV;
}
{AND} {
#ifdef debug_opt
printf("AND:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
yylval = CreateTreeNode(val("AND",strdup(yytext),yylineno));
return AND;
}
{OR} {
#ifdef debug_opt
printf("OR:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
yylval = CreateTreeNode(val("OR",strdup(yytext),yylineno));
return OR;
}
{NOT} {
#ifdef debug_opt
printf("NOT:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
yylval = CreateTreeNode(val("NOT",strdup(yytext),yylineno));
return NOT;
}
{TYPE} {
#ifdef debug_opt
printf("TYPE:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
yylval = CreateTreeNode(val("TYPE",strdup(yytext),yylineno));
return TYPE;
}
{LP} {
#ifdef debug_opt
printf("LP:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
yylval = CreateTreeNode(val("LP",strdup(yytext),yylineno));
return LP;
}
{RP} {
#ifdef debug_opt
printf("RP:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
yylval = CreateTreeNode(val("RP",strdup(yytext),yylineno));
return RP;
}
{LB} {
#ifdef debug_opt
printf("LB:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
yylval = CreateTreeNode(val("LB",strdup(yytext),yylineno));
return LB;
}
{RB} {
#ifdef debug_opt
printf("RB:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
yylval = CreateTreeNode(val("RB",strdup(yytext),yylineno));
return RB;
}
{LC} {
#ifdef debug_opt
printf("LC:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
yylval = CreateTreeNode(val("LC",strdup(yytext),yylineno));
return LC;
}
{RC} {
#ifdef debug_opt
printf("RC:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
yylval = CreateTreeNode(val("RC",strdup(yytext),yylineno));
return RC;
}
{STRUCT} {
#ifdef debug_opt
printf("STRUCT:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
yylval = CreateTreeNode(val("STRUCT",strdup(yytext),yylineno));
return STRUCT;
}
{RETURN} {
#ifdef debug_opt
printf("RETURN:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
yylval = CreateTreeNode(val("RETURN",strdup(yytext),yylineno));
return RETURN;
}
{IF} {
#ifdef debug_opt
printf("IF:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
yylval = CreateTreeNode(val("IF",strdup(yytext),yylineno));
return IF;
}
{ELSE} {
#ifdef debug_opt
printf("ELSE:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
yylval = CreateTreeNode(val("ELSE",strdup(yytext),yylineno));
return ELSE;
}
{WHILE} {
#ifdef debug_opt
printf("WHILE:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
yylval = CreateTreeNode(val("WHILE",strdup(yytext),yylineno));
return WHILE;
}
{ID} {
#ifdef debug_opt
printf("ID:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
yylval = CreateTreeNode(val("ID",strdup(yytext),yylineno));
return ID;
}
{OCT_ERROR} {
printf("Error type A at Line %d: Illegal octal number \'%s\'.\n",yylineno, yytext);flex_error=1;
yylval = CreateTreeNode(val("INT",strdup(yytext),yylineno));yylval->val.val.type_int = IntegerParser(strdup(yytext));
return INT;
}
{HEX_ERROR} {
printf("Error type A at Line %d: Illegal hexadecimal number \'%s\'.\n",yylineno, yytext);flex_error=1;
yylval = CreateTreeNode(val("INT",strdup(yytext),yylineno));yylval->val.val.type_int = IntegerParser(strdup(yytext));
return INT;
}
{FLOAT_ERROR} {
printf("Error type A at Line %d:  Illegal floating point number \'%s\'.\n",yylineno, yytext);flex_error=1;
yylval = CreateTreeNode(val("FLOAT",strdup(yytext),yylineno));yylval->val.val.type_float = (float)atof(strdup(yytext));
return FLOAT;
}
{ID_ERROR} {
#ifdef debug_opt
printf("ID_ERROR:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
yylval = CreateTreeNode(val("ID_ERROR",strdup(yytext),yylineno));
return ID_ERROR;
}
\n { yycolumn = 1; }
{BLANK} {}
{ANNOTATION} {}
{OTHERS} {printf("Error type A at Line %d: Mysterious character \"%s\".\n",yylineno, yytext);flex_error=1;}
%%
//辅助函数部分
void flex_analyse(FILE *fp){
    yyin=fp;
    yylex();
}
int yywrap(){
    return 1;
}