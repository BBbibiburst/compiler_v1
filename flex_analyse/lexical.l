%{
    #pragma once
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    #include "../DSTools/tools.c"
    int flex_error = 0;
%}
%option yylineno
INT [1-9][0-9]*|0[1-7][0-7]*|0(X|x)[1-9a-fA-F][0-9a-fA-F]*|0(X|x)0|00|0
FLOAT [0-9]*\.[0-9]*((E|e)(\+|-)?[0-9]+)?
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
{BLANK} {}
%%
//辅助函数部分
void flex_analyse(FILE *fp){
    yyin=fp;
    yylex();
}
int yywrap(){
    return 1;
}