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
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include <readline/readline.h>
#include <readline/history.h>

#define HELP printf("help   display this help\n" \
                    "e		2.718281\n" \
                    "pi		3.141592\n" \
                    "log(int|float)\n" \
                    "ln(int|float)\n" \
                    "sqrt(int|float)\n" \
                    "pow(int, int)\n" \
                    "sin(int|float)\n" \
                    "cos(int|float)\n" \
                    "tan(int|float)\n" \
                    "asin(int|float)\n" \
                    "acos(int|float)\n" \
                    "atan(int|float)\n" \
                    "acos(int|float)\n");


// yyin is necessary to read the input files
// that the calculator will generate
extern FILE *yyin;

void yyerror(const char *str)
{
	fprintf(stderr, "error: %s\n", str);
}

void write (char *buffer, char template[]) {
	// Writes everything that was passed to a temporary file
	FILE *ftemp;
	ftemp = fopen(template, "w");
	fputs(buffer, ftemp);
	fclose(ftemp);

	// The Grammar needs a break of line to reconize the EOL
	ftemp = fopen(template, "a");
	fputc('\n', ftemp);
	fclose(ftemp);
}


main() {
	// Creation of the temporary file
	char template[] = "/tmp/fileXXXXXXX";
	int check;
	check = mkstemp(template);
	
	if (check) { 
		FILE *ftemp;
		printf("Abaco Calculator. A simple calculator\nTo exite press <Ctrl-C>\n");
		
		// This will remove the TAB completion of files of the Readline library
		rl_bind_key('\t', rl_insert);

		char *buffer;
		while ((buffer = readline("? ")) != 0) {
			if (strlen(buffer) > 0) {
				// Adds the expression to the history
				add_history(buffer);
			}
		
			if (!(strcmp(buffer, "help"))) { 
				HELP
				free(buffer);
			} else {

				write(buffer, template);
		
				yyin = fopen(template, "r");
				yyparse();
		
				free(buffer);
			}
		} 
	} else {
		return 0;
	}
}

%}

// Declare the types being used on the analyser
%union {
	int i;
	double f;
}

%token<i> I_NUM
%token<f> F_NUM
%token ADD SUB MULT DIV
%token POW
%token SIN COS TAN PI
%token LOG LN EUL SQRT
%token P_LEFT P_RIGHT
%token EOL

// Defines the order of precedence
// The last ones have more priority
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
	| EUL  { $$ = 2.718281; }
	| SQRT P_LEFT int_expr P_RIGHT { $$ = sqrt($3); }
	| SQRT P_LEFT float_expr P_RIGHT { $$ = sqrt($3); }

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
