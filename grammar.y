%{
#include <stdio.h>
#include <stdlib.h>

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
%token P_LEFT P_RIGHT
%token EOL

%left ADD SUB
%left MULT DIV


%type<i> int_expr
%type<f> float_expr

%%

input:
	|  input line 
	;

line: EOL	{ printf("Enter a expression!"); }
	| int_expr EOL { printf("= %d\n", $1); }
	| float_expr EOL { printf("= %f\n", $1); }
;

int_expr: I_NUM { $$ = $1; }
	| int_expr ADD int_expr { $$ = $1 + $3; }
	| int_expr SUB int_expr { $$ = $1 - $3; }
	| int_expr MULT int_expr { $$ = $1 * $3; }
	| P_LEFT int_expr P_RIGHT { $$ = $2; }
	| SUB int_expr { $$ = -$2; }
;

float_expr: F_NUM { $$ = $1; }
	| float_expr ADD float_expr { $$ = $1 + $3; }
	| float_expr SUB float_expr { $$ = $1 - $3; }
	| float_expr MULT float_expr { $$ = $1 * $3; }
	| float_expr DIV float_expr { $$ = $1 / $3; }
	| P_LEFT float_expr P_RIGHT { $$ = $2; }
	| SUB float_expr { $$ = -$2; }
	
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
	
	// INT / INT
	| int_expr DIV int_expr { $$ = $1 / (double)$3; }
;
%%
