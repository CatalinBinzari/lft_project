%{
#include <stdio.h>
#include <stdlib.h>
#include "val.tab.h"
void showError();
%}

sir_in_ghilimele		\"([a-zA-Z0-9]|\\\\|\\\"|\\b|\\t|\\v|\\\'|\\\?|\\[0-9][0-9][0-9])+\"

%%
[a-z]  { yylval.intval = *yytext - 'a';
			return VAR;
}
{sir_in_ghilimele} {
							char *tmp_str = (char*)calloc(strlen(yytext)-1, sizeof(char));
							int tmp_str_index =0;
							for(int i = 0; i<strlen(yytext);i++)
							{		
									
									if(yytext[i]=='\\')
									{	
										//printf("backslash found\n");
										if(yytext[i+1]=='\\')
											{
												//printf("double backslash found\n");
												tmp_str[tmp_str_index]=92; // \ == 92
												++i;++tmp_str_index;
												continue;
											}
										else if(yytext[i+1]=='\"')
											{
												//printf("double quotes found\n");
												tmp_str[tmp_str_index]=34; // " == 34" 
												++i;++tmp_str_index;
												continue;
											}
										else if(yytext[i+1]=='n')
											{
												//printf("new line found\n");
												tmp_str[tmp_str_index]=10; // \n == 10
												++i;++tmp_str_index;
												continue;
											}
										else if(yytext[i+1]=='b')
											{
												//printf("backspace found\n");
												tmp_str[tmp_str_index]=8; // backspace == 8
												++i;++tmp_str_index;
												continue;
											}
										else if(yytext[i+1]=='t')
											{
												//printf("horizontal tab found\n");
												tmp_str[tmp_str_index]=9; // horizontal tab == 9
												++i;++tmp_str_index;
												continue;
											}
										else if(yytext[i+1]=='v')
											{
												//printf("vertical tab found\n");
												tmp_str[tmp_str_index]=11; // vertical tab == 11
												++i;++tmp_str_index;
												continue;
											}
										else if(yytext[i+1]=='\'')
											{
												//printf("vertical tab found\n");
												tmp_str[tmp_str_index]=39; // single quote == 39
												++i;++tmp_str_index;
												continue;
											}
										else if(yytext[i+1]=='?')
											{
												//printf("vertical tab found\n");
												tmp_str[tmp_str_index]=63; // ? == 63
												++i;++tmp_str_index;
												continue;
											}
										else if(isdigit(yytext[i+1]) && isdigit(yytext[i+2]) && isdigit(yytext[i+3]))
											{	//printf("octal found \n");
												char substr[4]="0000";
												substr[1]='0';
												substr[1]=yytext[i+1];
												substr[2]=yytext[i+2];
												substr[3]=yytext[i+3];
												//printf("mystring is \"%s\"",*substr);
												int octal_number;
												sscanf(substr, "%i", &octal_number);
												//printf("int octal:%d\n",octal_number);
												//printf("a octal: %c\n",octal_number);

												tmp_str[tmp_str_index]=octal_number; 
												++i;++i;++i;
												++tmp_str_index;
												continue;
												
											}
									}
									else
									tmp_str[tmp_str_index]=yytext[i];
									++tmp_str_index;
							}
							
							//printf("%s\n\n",tmp_str);
							yylval.strval = (char*)calloc(strlen(tmp_str)-1, sizeof(char));
							strncpy(yylval.strval, &tmp_str[1], strlen(tmp_str)-2);
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
"==" {return EQUAL;}
"!=" {return NOTEQUAL;}
">"  {return GREATER;}
"<"  {return LESS;}
">=" {return GREATEREQUAL;}
"<=" {return LESSEQUAL;}
","  {return VIRGULA;}
[ \t\n]+ ;

";" {return SEMICOLON;}
. {showError(); return(OTHER);}

%%
void showError(){
    printf("Other input");
}