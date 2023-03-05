%{
    #pragma once
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    #include "../DSTools/tools.c"
    int flex_error = 0;
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
LINE_ANNOTATION \/\/[^\n]*\n
MULTI_ANNOTATION \/\*([^\*]|\*[^\/])*\*\/
ANNOTATION {LINE_ANNOTATION}|{MULTI_ANNOTATION}
BLANK [ \t\n]+
%%
{INT} {printf("INT:\t\t%s\t\t%d\n",yytext,yylineno);}
{FLOAT} {printf("FLOAT:\t\t%s\t\t%d\n",yytext,yylineno);}
{SEMI} {printf("SEMI:\t\t%s\t\t%d\n",yytext,yylineno);}
{COMMA} {printf("COMMA:\t\t%s\t\t%d\n",yytext,yylineno);}
{ASSIGNOP} {printf("AOP:\t\t%s\t\t%d\n",yytext,yylineno);}
{RELOP} {printf("RELOP:\t\t%s\t\t%d\n",yytext,yylineno);}
{PLUS} {printf("PLUS:\t\t%s\t\t%d\n",yytext,yylineno);}
{MINUS} {printf("MINUS:\t\t%s\t\t%d\n",yytext,yylineno);}
{STAR} {printf("STAR:\t\t%s\t\t%d\n",yytext,yylineno);}
{DIV} {printf("DIV:\t\t%s\t\t%d\n",yytext,yylineno);}
{AND} {printf("AND:\t\t%s\t\t%d\n",yytext,yylineno);}
{OR} {printf("OR:\t\t%s\t\t%d\n",yytext,yylineno);}
{DOT} {printf("DOT:\t\t%s\t\t%d\n",yytext,yylineno);}
{NOT} {printf("NOT:\t\t%s\t\t%d\n",yytext,yylineno);}
{TYPE} {printf("TYPE:\t\t%s\t\t%d\n",yytext,yylineno);}
{LP} {printf("LP:\t\t%s\t\t%d\n",yytext,yylineno);}
{RP} {printf("RP:\t\t%s\t\t%d\n",yytext,yylineno);}
{LB} {printf("LB:\t\t%s\t\t%d\n",yytext,yylineno);}
{RB} {printf("RB:\t\t%s\t\t%d\n",yytext,yylineno);}
{LC} {printf("LC:\t\t%s\t\t%d\n",yytext,yylineno);}
{RC} {printf("RC:\t\t%s\t\t%d\n",yytext,yylineno);}
{STRUCT} {printf("STRUCT:\t\t%s\t\t%d\n",yytext,yylineno);}
{RETURN} {printf("RETURN:\t\t%s\t\t%d\n",yytext,yylineno);}
{IF} {printf("IF:\t\t%s\t\t%d\n",yytext,yylineno);}
{ELSE} {printf("ELSE:\t\t%s\t\t%d\n",yytext,yylineno);}
{WHILE} {printf("WHILE:\t\t%s\t\t%d\n",yytext,yylineno);}
{ID} {printf("ID:\t\t%s\t\t%d\n",yytext,yylineno);}
{OCT_ERROR} {printf("Error type A at Line %d: Illegal octal number \'%s\'\n",yylineno, yytext);}
{HEX_ERROR} {printf("Error type A at Line %d: Illegal hexadecimal number \'%s\'\n",yylineno, yytext);}
{FLOAT_ERROR} {printf("Error type A at Line %d: Illegal hexadecimal number \'%s\'\n",yylineno, yytext);}
{BLANK} {}
{ANNOTATION} {}
. {printf("Error type A at Line %d:  Illegal floating point number \'%s\'\n",yylineno, yytext);}
%%
//辅助函数部分
void flex_analyse(FILE *fp){
    yyin=fp;
    yylex();
}
int yywrap(){
    return 1;
}