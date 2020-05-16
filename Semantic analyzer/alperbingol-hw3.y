%{
#include <stdio.h>

extern int line;

void show_error(int x){
    if(x == 1){
        printf("ERROR 1: ");
        printf("%d", line);
        printf(" inconsistent matrix size\n");
}
    else if(x == 2){
        printf("ERROR 2: ");
        printf("%d", line);
        printf(" dimension mismatch\n");
    }
    return;
}

void yyerror (const char *s) 
{
	printf ("%s\n", s); 
}


%}

%token tINTTYPE tINTVECTORTYPE tINTMATRIXTYPE tREALTYPE tREALVECTORTYPE tREALMATRIXTYPE tTRANSPOSE tIDENT tDOTPROD tIF tENDIF tREALNUM tINTNUM tAND tOR tGT tLT tGTE tLTE tNE tEQ

%left '='
%left tOR
%left tAND
%left tEQ tNE
%left tLTE tGTE tLT tGT
%left '+' '-'
%left '*' '/'
%left tDOTPROD
%left '(' ')'
%left tTRANSPOSE

%start prog

%union{
    int count;
    struct{
        int row;
        int column;
        int scalar;
    } node;
    int scalar;
}

%type <count> row
%type <node> rows
%type <node> matrixLit
%type <node> vectorLit
%type <node> expr
%type <node> transpose
%type <scalar> value


%%
prog: 		stmtlst
;
stmtlst:	stmtlst stmt 
			| stmt
;
stmt:       decl
            | asgn
            | if   
;
decl:		type vars '=' expr ';'
;
asgn:		tIDENT '=' expr ';'
;
if:			tIF '(' bool ')' stmtlst tENDIF
;
type:		tINTTYPE
			| tINTVECTORTYPE
            | tINTMATRIXTYPE
            | tREALTYPE
            | tREALVECTORTYPE    
            | tREALMATRIXTYPE
;
vars:		vars ',' tIDENT
			| tIDENT
;
expr:		value{$$.scalar=1;}
			| vectorLit
  			| matrixLit
| expr	'*' expr {
    if($1.scalar == 0 && $3.scalar == 0){
        if($1.column != $3.row){
            show_error(2);YYABORT;
        }
        else{
            $$.row = $1.row;
            $$.column = $3.column;
            $$.scalar = 0;
        }
    }
    else if($1.scalar == 1 && $3.scalar == 1){
        $$.scalar = 1;
    }
    else if($1.scalar == 0 && $3.scalar == 1){
        $$.row = $1.row;
        $$.column = $1.column;
        $$.scalar = 0;
    }
    else{
        $$.row = $3.row;
        $$.column = $3.column;
        $$.scalar = 0;
    }
}
| expr	'/' expr {
    if($1.scalar == 0 && $3.scalar == 0){
        if($1.column != $3.row){
            show_error(2);YYABORT;
        }
        if($3.column != $3.row){
            show_error(2);YYABORT;
        }
        else{
            $$.row = $1.row;
            $$.column = $3.column;
            $$.scalar = 0;
        }
    }
    else if($1.scalar == 1 && $3.scalar == 1){
        $$.scalar = 1;
    }
    else if($1.scalar == 0 && $3.scalar == 1){
        $$.row = $1.row;
        $$.column = $1.column;
        $$.scalar = 0;
    }
    else{
        if($3.row != $3.column){
            show_error(2);YYABORT;
        }
        else{
            $$.row = $3.row;
            $$.column = $3.column;
            $$.scalar = 0;
        }
        
    }
}
| expr	'+' expr {
    if($1.scalar == 0 && $3.scalar == 0){
        if($1.column != $3.column){
            show_error(2);YYABORT;
        }
        if($1.row != $3.row){
            show_error(2);YYABORT;
        }
        else{
            $$.row = $1.row;
            $$.column = $3.column;
            $$.scalar = 0;
        }
    }
    else if($1.scalar == 1 && $3.scalar == 1){
        $$.scalar = 1;
    }
    else if($1.scalar == 0 && $3.scalar == 1){
        show_error(2);YYABORT;

    }
    else{
        show_error(2);YYABORT;
    }
}
| expr	'-' expr {
    if($1.scalar == 0 && $3.scalar == 0){
        if($1.column != $3.column){
            show_error(2);YYABORT;
        }
        if($1.row != $3.row){
            show_error(2);YYABORT;
        }
        else{
            $$.row = $1.row;
            $$.column = $3.column;
            $$.scalar = 0;
        }
    }
    else if($1.scalar == 1 && $3.scalar == 1){
        $$.scalar = 1;
    }
    else if($1.scalar == 0 && $3.scalar == 1){
        show_error(2);YYABORT;

    }
    else{
        show_error(2);YYABORT;
    }
}
| expr tDOTPROD expr {
    if($1.scalar == 1 || $3.scalar == 1){
        show_error(2);YYABORT;
    }
    if($1.row != 1 || $3.row != 1){
        show_error(2);YYABORT;
    }
    if($1.column != $3.column){
        show_error(2);YYABORT;
    }
    else{
        $$.scalar = 1;
    }
}
			| transpose 
;    
transpose: 	tTRANSPOSE '(' expr ')' {
    if($3.scalar == 1){
        $3.scalar = 1;
    }
    else{
        int a = $3.column;
        $3.column = $3.row;
        $3.row = a;
    }
}
;
vectorLit:	'[' row ']' {
    $$.row = 1;
    $$.column = $2;
    $$.scalar = 0;
}
;
row:		row ',' value {
    $$ = $1 + 1;
}
| value {
    $$ = 1;
}
;
matrixLit: 	'[' rows ']' {
    $$.row = $2.row;
    $$.column = $2.column;
    $$.scalar = 0;
}
;
rows:		row ';' row {
    if($1 != $3){  show_error(1);YYABORT;
	}
    else{
        $$.column = $1;
        $$.row = 2;
    }
}
| rows ';' row{
    if($1.column != $3){ show_error(1);YYABORT;}
    else{
        $$.column = $3;
        $$.row = $1.row + 1;
    }
}
;
value:		tINTNUM {
    $$ = 1;
}
| tREALNUM {
    $$ = 1;
}
;
bool: 		comp
			| bool tAND bool
			| bool tOR bool
;
comp:		tIDENT relation tIDENT
;
relation:	tGT
			| tLT
			| tGTE
            | tLTE
			| tEQ
			| tNE
;

%%
int main ()
{
   if (yyparse()) {
   // parse error
       return 1;
   }
   else {
   // successful parsing
      printf("OK\n");
      return 0;
   }
}


