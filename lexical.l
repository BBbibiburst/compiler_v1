%{
    #pragma once
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    #include "Tree.h"
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
BLANK [ \t]+
OTHERS [^\n\r\b]
%%
{DOT} {
#ifdef debug_opt
printf("DOT:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
return DOT;
}
{INT} {
#ifdef debug_opt
printf("INT:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
yylval = (YYSTYPE)atoi(yytext);
return INT;
}
{FLOAT} {
#ifdef debug_opt
printf("FLOAT:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
yylval = (YYSTYPE)strdup(yytext);
return FLOAT;
}
{SEMI} {
#ifdef debug_opt
printf("SEMI:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
return SEMI;
}
{COMMA} {
#ifdef debug_opt
printf("COMMA:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
return COMMA;
}
{ASSIGNOP} {
#ifdef debug_opt
printf("AOP:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
return ASSIGNOP;
}
{RELOP} {
#ifdef debug_opt
printf("RELOP:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
return RELOP;
}
{PLUS} {
#ifdef debug_opt
printf("PLUS:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
return PLUS;
}
{MINUS} {
#ifdef debug_opt
printf("MINUS:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
return MINUS;
}
{STAR} {
#ifdef debug_opt
printf("STAR:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
return STAR;
}
{DIV} {
#ifdef debug_opt
printf("DIV:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
return DIV;
}
{AND} {
#ifdef debug_opt
printf("AND:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
return AND;
}
{OR} {
#ifdef debug_opt
printf("OR:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
return OR;
}
{NOT} {
#ifdef debug_opt
printf("NOT:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
return NOT;
}
{TYPE} {
#ifdef debug_opt
printf("TYPE:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
yylval = (YYSTYPE)strdup(yytext);
return TYPE;
}
{LP} {
#ifdef debug_opt
printf("LP:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
return LP;
}
{RP} {
#ifdef debug_opt
printf("RP:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
return RP;
}
{LB} {
#ifdef debug_opt
printf("LB:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
return LB;
}
{RB} {
#ifdef debug_opt
printf("RB:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
return RB;
}
{LC} {
#ifdef debug_opt
printf("LC:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
return LC;
}
{RC} {
#ifdef debug_opt
printf("RC:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
return RC;
}
{STRUCT} {
#ifdef debug_opt
printf("STRUCT:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
return STRUCT;
}
{RETURN} {
#ifdef debug_opt
printf("RETURN:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
return RETURN;
}
{IF} {
#ifdef debug_opt
printf("IF:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
return IF;
}
{ELSE} {
#ifdef debug_opt
printf("ELSE:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
return ELSE;
}
{WHILE} {
#ifdef debug_opt
printf("WHILE:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
return WHILE;
}
{ID} {
#ifdef debug_opt
printf("ID:\t\t%s\t\t%d\n",yytext,yylineno);
#endif
yylval = (YYSTYPE)strdup(yytext);
return ID;
}
{OCT_ERROR} {printf("Error type A at Line %d: Illegal octal number \'%s\'.\n",yylineno, yytext);flex_error=1;return INT;}
{HEX_ERROR} {printf("Error type A at Line %d: Illegal hexadecimal number \'%s\'.\n",yylineno, yytext);flex_error=1;return INT;}
{FLOAT_ERROR} {printf("Error type A at Line %d:  Illegal floating point number \'%s\'.\n",yylineno, yytext);flex_error=1;return FLOAT;}
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