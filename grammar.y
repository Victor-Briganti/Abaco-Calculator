%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>


void yyerror(const char *str)
{
	fprintf(stderr, "error: %s\n", str);
}

main()
{
	yyparse();
}

%}

%union {
	int i;
	double f;
}

%token<i> I_NUM
%token<f> F_NUM
%token ADD SUB MULT DIV
%token POW
%token SIN COS TAN PI
%token LOG LN
%token P_LEFT P_RIGHT
%token EOL

%left ADD SUB
%left MULT DIV
%right POW
%left SIN COS TAN ATAN ASIN ACOS LOG LN

%type<i> int_expr
%type<f> float_expr

%%

input:
	|  input line 
	;

line: EOL	{ printf("Enter a expression\n"); return; }
	| int_expr EOL { printf("= %d\n", $1); return; }
	| float_expr EOL { printf("= %f\n", $1); return; }
	| error EOL { }
;

int_expr: I_NUM { $$ = $1; }
	| int_expr ADD int_expr { $$ = $1 + $3; }
	| int_expr SUB int_expr { $$ = $1 - $3; }
	| int_expr MULT int_expr { $$ = $1 * $3; }
	| P_LEFT int_expr P_RIGHT { $$ = $2; }
	| SUB int_expr { $$ = -$2; }
	
	/* SPECIAL */
	| int_expr POW int_expr { $$ = pow($1, $3); }
;

float_expr: F_NUM { $$ = $1; }
	| float_expr ADD float_expr { $$ = $1 + $3; }
	| float_expr SUB float_expr { $$ = $1 - $3; }
	| float_expr MULT float_expr { $$ = $1 * $3; }
	| float_expr DIV float_expr { $$ = $1 / $3; }
	| P_LEFT float_expr P_RIGHT { $$ = $2; }
	| SUB float_expr { $$ = -$2; }
	
	/* SPECIAL */
	| LOG P_LEFT float_expr P_RIGHT { $$ = log10($3); } 
	| LN P_LEFT float_expr P_RIGHT { $$ = log($3); }
	| LOG P_LEFT int_expr P_RIGHT { $$ = log10($3); } 
	| LN P_LEFT int_expr P_RIGHT { $$ = log($3); }
	
	// TRIGONOMETRY
	| PI { $$ = 3.141592; }
	| SIN P_LEFT int_expr P_RIGHT { $$ = sin($3); }
	| COS P_LEFT int_expr P_RIGHT { $$ = cos($3); }
	| TAN P_LEFT int_expr P_RIGHT { $$ = tan($3); }
	| SIN P_LEFT float_expr P_RIGHT { $$ = sin($3); }
	| COS P_LEFT float_expr P_RIGHT { $$ = cos($3); }
	| TAN P_LEFT float_expr P_RIGHT { $$ = tan($3); }
	| ASIN P_LEFT int_expr P_RIGHT { $$ = asin($3); }
	| ACOS P_LEFT int_expr P_RIGHT { $$ = acos($3); }
	| ATAN P_LEFT int_expr P_RIGHT { $$ = atan($3); }
	| ASIN P_LEFT float_expr P_RIGHT { $$ = asin($3); }
	| ACOS P_LEFT float_expr P_RIGHT { $$ = acos($3); }
	| ATAN P_LEFT float_expr P_RIGHT { $$ = atan($3); }

	/* Mixed Expressions */
	// INT and DOUBLE
	| int_expr ADD float_expr { $$ = $1 + $3; }
	| int_expr SUB float_expr { $$ = $1 - $3; }
	| int_expr MULT float_expr { $$ = $1 * $3; }
	| int_expr DIV float_expr { $$ = $1 / $3; }

	// DOUBLE and INT
	| float_expr ADD int_expr { $$ = $1 + $3; }
	| float_expr SUB int_expr { $$ = $1 - $3; }
	| float_expr MULT int_expr { $$ = $1 * $3; }
	| float_expr DIV int_expr { $$ = $1 / $3; }
	| float_expr POW int_expr { $$ = pow($1, $3); }
	
	// INT / INT
	| int_expr DIV int_expr { $$ = $1 / (double)$3; }
;
%%
