%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
int yylex(void);
char* increment_first_char(char *str);
char* decrement_first_char(char *str);
char* strvrs(char *str);
char* string_repeat(const char *str, int n);
char*  get_last_chars(const char *str, int n);
char sym[26][14];
#define atoa(x) #x
%}
%union {
char* strval;
int	  intval;
}
%token <intval> VAR
%token <intval> CINT
%token <strval> STRING
%type <strval> expression

%left '+'

%left '*' '/' '#'
%right DECREMENT INCREMENT SIMBOL_PUTERE SIMBOL_APROXIMARE


%%
statement : 
        expression {printf("s-a recunoscut sirul:%s\n",$<strval>$);}
        |VAR '=' expression { strcpy(sym[$1], $3); printf("sym[%d]=[%s]\n", $1,$3);}
;

expression:  
      VAR { $$ = sym[$1]; printf("scot din sym[%d] valoarea %s\n", $1,$$);}
    | expression '+' expression {char* s=strdup($1);strcat(s,$3);$$=s;}
    | INCREMENT expression {$$=increment_first_char($2);}
    | DECREMENT expression {$$=decrement_first_char($2);}
    | SIMBOL_PUTERE expression {$$=strvrs($2);}
    | SIMBOL_APROXIMARE expression {asprintf (&$$, "%i", strlen($2));}
	| expression '*' CINT  {$$=string_repeat($1,$3);}
	| expression '/' CINT  {$$=get_last_chars($1,$3);}
	| STRING {$$=strdup($1);}
;

%%

char* increment_first_char(char *str) 
{  
	/* functia data incrementeaza primul char din stringul ce il primeste */
   char first_char = (*str) + 1;
   if(first_char=='[')
   	{
   		first_char='Z';printf("'Z' nu mai poate fi incrementat!\n");
   	}else if(first_char=='{')
   	{
   		first_char='z';printf("'z' nu mai poate fi incrementat!\n");
   }
   str[0]=first_char;
   printf("%s\n",str);
   return str;
}
char* decrement_first_char(char *str) 
{  
	/* functia data decrementeaza primul char din stringul ce il primeste */
   char first_char = (*str) - 1;
   if(first_char=='@')
   	{
   		first_char='A';printf("'A' nu mai poate fi decrementat!\n");
   	}else if(first_char=='`')
   	{
   		first_char='a';printf("'a' nu mai poate fi decrementat!\n");
   }
   str[0]=first_char;
   printf("%s\n",str);
   return str;
}
char* strvrs(char *str){
    char *s;
    for(s = str; *s; ++s){
        if(islower(*s))
            *s = toupper(*s);
        else if(isupper(*s))
            *s = tolower(*s);
    }
    return str;
}
char* string_repeat(const char *str, int n)
{          /*"abc"*3="abcabcabc"*/
   char *pa, *pb;
   size_t slen = strlen(str);
   char *dest = malloc(n*slen+1);
 
   pa = dest + (n-1)*slen;
   strcpy(pa, str);
   pb = --pa + slen; 
   while (pa>=dest) *pa-- = *pb--;
   return dest;
}
char*  get_last_chars(const char *str, int n)
{
	/*   "ertyu"/3="tyu"   */
	char *dest = malloc(n+1);
	strncpy(dest, str+(strlen(str)-n), n);
	dest[n] = '\0';
	return dest;
}
int main(){
while (!feof(stdin))
yyparse();
}
int yyerror (char *s)
{
fprintf(stderr,"%s\n",s);
}