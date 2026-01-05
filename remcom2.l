%{
#include <stdio.h>
%}

%option noyywrap


%x SINGLELINECOMMENTS
%x MULTILINECOMMENTS

%%
	

"//"					{ BEGIN(SINGLELINECOMMENTS); }
<SINGLELINECOMMENTS>\n  { BEGIN(INITIAL); printf("\n"); }
<SINGLELINECOMMENTS>.	;

"/*"					{ BEGIN(MULTILINECOMMENTS); }
<MULTILINECOMMENTS>"*/"	{ BEGIN(INITIAL); }
<MULTILINECOMMENTS>\n   { printf("\n"); }
<MULTILINECOMMENTS>.    ;



.						{ECHO;}
\n						{ECHO;}		

%%

int main(int argc, char **argv) {

	yyin = fopen("testcode.cpp", "r");
	if (!yyin) {
		yyin = stdin;
	}
	
	yylex();
	return 0;
		
}