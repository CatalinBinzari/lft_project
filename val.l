%{
#include <stdio.h>
#include <stdlib.h>
#include "val.tab.h"
void yyerror(char *);
%}

sir_in_ghilimele		\"([a-zA-Z])+\"

%%
[a-z]  { yylval.intval = *yytext - 'a';
			return VAR;
}
{sir_in_ghilimele} {		yylval.strval = (char*)calloc(strlen(yytext)-1, sizeof(char));
							strncpy(yylval.strval, &yytext[1], strlen(yytext)-2);
							return (STRING);			
}
[0-9]+ {
	yylval.intval = atoi(yytext);
	return CINT;
}
[-+()=/*#] { return *yytext; }
"++" {return INCREMENT;}
"--" {return DECREMENT;}
"^"  {return SIMBOL_PUTERE; }
"~"  {return SIMBOL_APROXIMARE;}

[ \t]+ ;
\n {return 0;}
. yyerror("Caracter necunoscut");
%%
int yywrap(void) {
return 1;
}