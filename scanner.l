/* *************************************
 * Abaco Calculator. A simple calculator
 *
 * Name: abaco
 * Author: John Mago0
 * Date: 2022-12-11
 * Version: 1.0 
 * ************************************
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <https://www.gnu.org/licenses/>
 */

%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"

// The option yywrap is for more than one file as a input(not the case here)
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
