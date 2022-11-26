%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
%}

%option noyywrap

%%
[0-9]+ { yylval.i = atoi(yytext); return I_NUM; }
[0-9]+[.][0-9]+ { yylval.f = atof(yytext); return F_NUM; }
"+"	{ return ADD; }
"-"	{ return SUB; }
"*" { return MULT; }
"/" { return DIV; }
"(" { return P_LEFT; }
")" { return P_RIGHT; }
"^" { return POW; }
"tan" { return TAN; }
"sin" { return SIN; }
"cos" { return COS; }
"atan" { return ATAN; }
"asin" { return ASIN; }
"acos" { return ACOS; }
"log" { return LOG; }
"ln" { return LN; }
"sqrt" { return SQRT; }
"e" { return EUL; }
"pi" { return PI; }
\n	{ return EOL; }
[ \t] { }
.	{ yyerror("Undefined Symbol:"); printf("'%s'\n", yytext); }
%%
