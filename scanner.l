%{
#include <stdio.h>
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
\n	{ return EOL; }
[ \t] { }
.	{ yyerror("Undefined Symbol!"); }
%%
