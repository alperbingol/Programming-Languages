%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "alperbingol-ex1.h"

void yyerror (const char *s) 
{
	 printf("ERROR\n");
}

int scope = 0;
int globalScope = 0;

int Redefinition(char *Name, int lines, int Scope)
{ 
    int finale = 0;
    Pushing(Name, lines, &finale);
    if (finale == 0)
    {
        printf("%d Redefinition of variable\n", lines); 
        return 1;      
    }
    return 0;
}

int Undefined(char *Name, int lines)
{ 
    int Redef = 0;
    Control(Name, &Redef);
    if (Redef == 0)
    {
        printf("%d Undefined variable\n", lines);
        return 1;
    }       
    return 0;
}

%}
%union{
    struct{
        char* name;
        int count;
    }identifier;
}

%token tINT tSTRING tRETURN tPRINT 
%token tMINUS tPLUS tDIV tSTAR tMOD tASSIGNM tINTVAL tSTRINGVAL
%token tCOMMA tSEMI tLBRAC tRBRAC tLPAR tRPAR 
%token <identifier>tIDENT 
%type <identifier> declaration
%type <identifier> fndefinition

%left tASSIGNM
%left tPLUS tMINUS
%left tSTAR tDIV tMOD
%left tLPAR tRPAR
%left tLBRAC tRBRAC 

%start program
%%

program: 	    statements
;
statements:	    statements statement 
			    | statement
;
statement:      declaration     {
                                    
                                    if(Redefinition($1.name, $1.count, 0))
                                        YYERROR;
                                }
                | assign
                | printstatement
                | fndefinition  {
                                    Popping($1.count);
                                }
;   
declaration:	type tIDENT tASSIGNM expression tSEMI   {
                                                            $$.name = $2.name;
                                                            $$.count = $2.count;
                                                        }
;
assign:		    tIDENT tASSIGNM expression tSEMI    {  
                                                        if(Undefined($1.name, $1.count))
                                                            YYERROR;
                                                    }
;
type:		tINT
			| tSTRING
;
expression:         value                           
                    | fncall
                    | expression tSTAR expression
                    | expression tPLUS expression
                    | expression tMINUS expression
                    | expression tDIV expression
                    | expression tMOD expression
;
value:		tIDENT                  {   
                                        if(Undefined($1.name, $1.count))
                                            YYERROR;
                                    }
			| tINTVAL       
            | tSTRINGVAL
;
fndefinition:   type tIDENT tLPAR tRPAR tLBRAC body tRBRAC          {   
                                                                        $$.count = $2.count;
                                                                        scope = 1; 
                                                                    }
            | type tIDENT tLPAR parameters tRPAR tLBRAC body tRBRAC {  
                                                                        $$.count = $2.count;
                                                                        scope = 1; 
                                                                    }
;
parameters:     parameter                                       
                | parameter tCOMMA parameters                   
;
parameter:      type tIDENT                 {   
                                                if(Redefinition($2.name, $2.count, 1))
                                                    YYERROR;
                                            }
;
body:       fnstmtlist rtrnstmt     
            | rtrnstmt
;
fnstmtlist: fnstmtlist declaration      {
                                            if(Redefinition($2.name, $2.count, 1))
                                                YYERROR;
                                        }
            | fnstmtlist assign
            | fnstmtlist printstatement
            | declaration               {
                                            
                                            if(Redefinition($1.name, $1.count, 1))
                                                YYERROR;
                                        }
            | assign
            | printstatement
;
rtrnstmt:   tRETURN expression tSEMI    
;
printstatement:     tPRINT tLPAR expression tRPAR tSEMI
;
fncall:     tIDENT tLPAR actuals tRPAR  
            | tIDENT tLPAR tRPAR
;
actuals:    value
            | value tCOMMA actuals
;
%%
int main ()
{
    first();
    if (yyparse()) {
        return 1;
    }
    else {
        printf("OK\n");
        return 0;
    }
}

