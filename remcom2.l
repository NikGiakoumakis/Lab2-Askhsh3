%{
#include <stdio.h>
%}

%option noyywrap


%x SINGLELINECOMMENTS
%x MULTILINECOMMENTS

%%
	

"//"					{ BEGIN(SINGLELINECOMMENTS); }
<SINGLELINECOMMENTS>\n  { BEGIN(INITIAL); fprintf(yyout, "\n"); }
<SINGLELINECOMMENTS>.	;

"/*"					{ BEGIN(MULTILINECOMMENTS); }
<MULTILINECOMMENTS>"*/"	{ BEGIN(INITIAL); }
<MULTILINECOMMENTS>\n   { fprintf(yyout, "\n"); }
<MULTILINECOMMENTS>.    ;



.						{ fprintf(yyout, "%s", yytext); }
\n						{ fprintf(yyout, "%s", yytext); }		

%%
		
int main(int argc, char **argv) {
if(argc < 2) {
		printf("Usage: %s file1, file2 ... \n", argv[0]);
		return 1;
	}

	yyout = fopen("no_comments.c", "w");
	if(!yyout) {
		printf("Could not open output file: no_comments.c\n");
		return 1;
	}

	for(int i = 1; i < argc; i++) {
		yyin = fopen(argv[i], "r");
		if (!yyin) {
			printf("Could not open file: %s\n", argv[i]);
			continue;
		}
		
		fprintf(yyout, "/* Processing file: %s */\n", argv[i]);
		yyrestart(yyin);
		yylex();
		fclose(yyin);
			
	}
	fclose(yyout);
	return 0;
		
}