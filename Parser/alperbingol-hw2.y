%{
	#include <stdio.h>
	void yyerror (const char *s) /* Called by yyparse on error */ 
	{
 	printf("%s\n", s);
	}
%}

%token tINTTYPE tINTVECTORTYPE tINTMATRIXTYPE tREALTYPE tREALVECTORTYPE tREALMATRIXTYPE tIF tENDIF tTRANPOSE tEQ tLT tGT tAND tDOTPROD tNE tLTE tGTE tOR tIDENT tINTNUM tREALNUM
%left '+' '-'
%left '*' '/'
%left tDOTPROD tTRANSPOSE

%%
 
prog: stmtlst 
;

stmtlst: stmt
	| stmtlst stmt
;

stmt:  asgn | decl | if
;

decl: type asgn
;

type: tINTTYPE | tINTVECTORTYPE | tINTMATRIXTYPE | tREALTYPE | tREALVECTORTYPE | tREALMATRIXTYPE 
;

asgn: vars '=' expr ';' 
;

vars: tIDENT | vars ',' tIDENT
;

if: tIF '(' bool ')' stmtlst tENDIF
;

expr: tIDENT |  tINTNUM | tREALNUM | vectorLit | matrixLit |  expr '*' expr | expr '+' expr  | expr  '-' expr | expr  '/' expr  |  expr tDOTPROD expr		 | transpose;

vectorLit: '[' row ']'
;

matrixLit: '[' rows ';' row ']'   
;

row: value | row ',' value
;

rows: row | rows ';' row 
;

transpose: tTRANSPOSE '(' expr ')'
;

bool: comp | bool tAND comp | bool tOR comp
;

comp: tIDENT relation tIDENT
;

relation: tLT | tGT | tLTE | tGTE | tNE | tEQ
;

value: tIDENT | tINTNUM | tREALNUM
;

 

%%
int main()
{
   if (yyparse()) {
	// yyparse returns 1 if thers is an error
	// parse error
	printf("ERROR\n");
	return 1;
	}
   else {
	// yyparse returns 0 if the parsing is completed successfully
	// successful parsing
	printf("OK\n");
	return 0;
	}
}
