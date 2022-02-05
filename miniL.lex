   /* cs152-miniL phase2 */
   
%{   
	int currline = 1;
	int currpos = 1;
%}

   /* some common rules */
DIGIT		[0-9]
ALPHA		[A-Za-z]
ALPHANUM	{ALPHA}|{DIGIT}
VALIDID		{ALPHA}({ALPHANUM}|_+{ALPHANUM})* 
INVALIDSTART	[0-9_][A-Za-z0-9_]*
INVALIDEND	[A-Za-z][A-Za-z0-9_]*_

%%
   /* specific lexer rules in regex */
"function"	{currpos += yyleng; return FUNCTION;}
"beginparams"	{currpos += yyleng; return BEGINPARAMS}
"endparams"	{currpos += yyleng; return ENDPARAMS}
"beginlocals"	{currpos += yyleng; return BEGINLOCALS}
"endlocals"	{currpost += yyleng; return END_LOCALS;}
"beginbody"	{currpost += yyleng; return BEGIN_BODY;}
"endbody"	{currpost += yyleng; return END_BODY;}
"integer"	{currpost += yyleng; return INTEGER;}
"array"		{currpost += yyleng; return ARRAY;}
"of"		{currpost += yyleng; return OF;}
"if"		{currpost += yyleng; return IF;}
"then"		{currpost += yyleng; return THEN;}
"endif"		{currpost += yyleng; return ENDIF;}
"else"		{currpost += yyleng; return ELSE;}
"while"		{currpost += yyleng; return WHILE;}
"do"		{currpost += yyleng; return DO;}
"for"		{currpost += yyleng; return FOR;}
"beginloop"	{currpost += yyleng; return BEGINLOOP;}
"endloop"	{currpost += yyleng; return ENDLOOP;}
"continue"	{currpost += yyleng; return CONTINUE;}
"break"		{currpost += yyleng; return BREAK;}
"read"		{currpost += yyleng; return READ;}
"write"		{currpost += yyleng; return WRITE;}
"not"		{currpost += yyleng; return NOT;}
"and"		{currpost += yyleng; return AND;}
"or"		{currpost += yyleng; return OR;}
"true"		{currpost += yyleng; return TRUE;}
"false"		{currpost += yyleng; return FALSE;}
"return"	{currpost += yyleng; return RETURN;}
"-"		{currpost += yyleng; return SUB;}
"+"		{currpost += yyleng; return ADD;}
"*"		{currpost += yyleng; return MULT;}
"/"		{currpost += yyleng; return DIV;}
"%"		{currpost += yyleng; return MOD;}
"=="		{currpost += yyleng; return EQ;}
"<>"		{currpost += yyleng; return NEQ;}
"<"		{currpost += yyleng; return LT;}
"<="		{currpost += yyleng; return LTE;}
">"		{currpost += yyleng; return GT;}
">="		{currpost += yyleng; return GTE;}
";"		{currpost += yyleng; return SEMICOLON;}
":"		{currpost += yyleng; return COLON;}
","		{currpost += yyleng; return COMMA;}
";"		{currpost += yyleng; return SEMICOLON;}
":"		{currpost += yyleng; return COLON;}
","		{currpost += yyleng; return COMMA;}
"("		{currpost += yyleng; return L_PAREN;}
")"		{currpost += yyleng; return R_PAREN;}
"["		{currpost += yyleng; return L_SQUARE_BRACKET;}
"]"		{currpost += yyleng; return R_SQUARE_BRACKET;}
":="		{currpost += yyleng; return ASSIGN;}

{DIGIT}+        {/*special case*/ printf("NUMBER %s\n", yytext); currpos += yyleng;}
[ \t]+		{currpos += yyleng;}
"\n"		{currline += 1;}		
(##).* 		{currline++; currpos = 1;}

{INVALIDSTART}	{printf("Error at line %d, column %d: identifier \"%s\" must begin with a letter\n" , currline, currpos, yytext); exit(0);} 
{INVALIDEND}	{printf("Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n" , currline, currpos, yytext); exit(0);}
{VALIDID} 	{/* special case*/ printf("IDENT %s\n", yytext); currpos += yyleng;}
. 		{printf("Error at line %d. column %d: unrecognized symbol \"%s\"\n", currline, currpos, yytext); exit(0);}
%%
	/* C functions used in lexer */

int main(int argc, char ** argv)
{
   yylex();
}
