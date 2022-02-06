    /* cs152-miniL phase2 */
%{
#include <stdio.h>
#include <stdlib.h>
extern int currpos;
extern int currline;
void yyerror(const char *msg);
%}

%union{
  /* put your types here */
  int ival;
  char* sval;
}

%error-verbose
%locations

%left '+' '-' ADD SUB 
%left '*' '/' '%'  MUT DIV MOD

%start prog_start

%token FUNCTION 
%token BEGIN_PARAMS
%token END_PARAMS
%token BEGIN_LOCALS
%token END_LOCALS
%token BEGIN_BODY
%token END_BODY
%token INTEGER
%token ARRAY
%token OF
%token IF
%token THEN
%token ENDIF
%token ELSE
%token WHILE
%token DO
%token FOR
%token BEGINLOOP
%token ENDLOOP
%token CONTINUE
%token BREAK
%token READ
%token WRITE
%token NOT
%token AND
%token OR
%token TRUE
%token FALSE
%token RETURN
%token SUB
%token ADD
%token MULT
%token DIV
%token MOD
%token EQ
%token NEQ
%token LT
%token GT
%token LTE
%token GTE
%token SEMICOLON
%token COLON
%token COMMA
%token L_PAREN
%token R_PAREN
%token L_SQUARE_BRACKET
%token R_SQUARE_BRACKET
%token ASSIGN
%token <ival> NUMBER
%token <sval> IDENT
/* %start program */

%% 

  /* write your rules here */
prog_start: functions prog_start {printf("prog_start -> functions prog_start\n");}
	| {printf("prog_start -> epsilon\n");}
;

functions: function functions {printf("functions -> function functions\n");}
        | {printf("functions -> epsilon\n");} 
;

function: FUNCTION ident SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY
        {printf("functions -> FUNCTION IDENT SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY\n");}
;

identifiers: ident {printf("identifiers -> ident\n");
	// |ident COMMA identifiers{printf("identifiers -> ident COMMA identifiers\n");}
	}
;

ident: IDENT {printf("ident -> IDENT %s\n", $1);}
;

declarations: declaration SEMICOLON  declarations {printf("declarations -> declaration SEMICOLON  declarations\n");}
	| {printf("declarations -> epsilon\n");}
;

declaration: identifiers COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER
	{printf("declaration -> identifiers COLON ARRAY L_SQUARE_BRACKET NUMBER %d R_SQUARE_BRACKET OF INTEGER\n", $5);}
	|identifiers COLON INTEGER 
	{printf("declaration->identifiers COLON INTEGER\n");}
; 

statements: statement SEMICOLON statements {printf("statements -> statement SEMICOLON statements\n");}
	| {printf("statements -> epsilon\n");}
;

statement: var ASSIGN expression {printf("statement -> var ASSIGN epression\n");}
	| IF bool_expression THEN statements ENDIF {printf("statement -> IF bool_expression THEN statements ENDIF\n");}
	| IF bool_expression THEN statements ELSE statements ENDIF {printf("statement -> IF bool_expression THEN statements ELSE statements\n");}
	| WHILE bool_expression BEGINLOOP statements ENDLOOP {printf("statement -> WHILE bool_expression BEGINLOOP statements ENDLOOP\n");}
	| DO BEGINLOOP statements ENDLOOP WHILE bool_expression {printf("statement -> DO BEGINLOOP statements ENDLOOP WHILE bool_expression\n");}
	| READ var var_loop {printf("statement -> READ var var_loop\n");}
	| WRITE var var_loop {printf("statement -> WRITE var var_loop\n");}
	| CONTINUE {printf("statement -> CONTINUE\n");}
	| RETURN expression {printf("statement -> RETURN expression\n");}
;

expressions: expression {printf("expressions -> expression\n");}
	| expression COMMA expressions {printf("expressions -> expression COMMA expressions\n");}
;

expression: mutiplicative_exp ADD expression {printf("expression -> mutiplicative_exp ADD expression\n");}
	| mutiplicative_exp SUB expression {printf("expression -> mutiplicative_exp SUB expression\n");}
	| mutiplicative_exp {printf("expression -> mutiplicative_exp\n");}
;

mutiplicative_exp: term MULT mutiplicative_exp {printf("mutiplicative_exp -> term MULT mutiplicative_exp\n");}
	| term DIV mutiplicative_exp {printf("mutiplicative_exp -> term DIV mutiplicative_exp\n");}
	| term MOD mutiplicative_exp {printf("mutiplicative_exp -> term MOD mutiplicative_exp\n");}
	| term {printf("mutiplicative_exp -> term\n");} 
;

bool_expression: NOT bool_expression {printf("bool_expression -> NOT bool_expression\n");}
	| expression comp expression {printf("bool_expression -> expression comp expression\n");}
;

comp: EQ {printf("comp -> EQ\n");}
	| NEQ {printf("comp -> NEQ\n");}
	| LT {printf("comp -> LT\n");}
	| GT {printf("comp -> GT\n");}
	| LTE {printf("comp -> LTE\n");}
	| GTE {printf("comp -> GTE\n");}
;

term: var {printf("term -> var\n");}
	| NUMBER {printf("term -> NUMBER %d\n", $1);}
	| L_PAREN expression R_PAREN {printf("term -> L_PAREN expression R_PAREN\n");}
	| IDENT L_PAREN expressions R_PAREN {printf("term -> IDENT %s L_PAREN expressions R_PAREN\n", $1);}
;

var: IDENT {printf("var -> IDENT %s \n", $1);}
	| IDENT L_SQUARE_BRACKET expression R_SQUARE_BRACKET {printf("var -> IDENT L_SQUARE_BRACKET expression R_SQUARE_BRACKET\n");}
;

var_loop: COMMA var var_loop {printf("var_loop -> COMMA var var_loop\n");}
	| {printf("var_loop -> epsilon\n");}
;
%% 

int main(int argc, char **argv) {
   yyparse();
   return 0;
}

void yyerror(const char *msg) {
    /* implement your error handling */
   printf("Syntax error at line %d, column %d: %s \n", currline, currpos, msg);
   //exit(1);
}
