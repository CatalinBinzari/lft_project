%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

#define YYERROR_VERBOSE
extern int yylex();
extern FILE *yyin;
extern FILE *yyout;


char* increment_first_char(char *str);
char* decrement_first_char(char *str);
char* strvrs(char *str);
char* string_repeat(const char *str, int n);
char*  get_last_chars(const char *str, int n);
char*  get_first_chars(const char *str, int n);
char* str_remove(char *str, const char *sub);
void yyerror(char *s);
char sym_c[26][14];
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

%right EQUAL NOTEQUAL GREATER LESS GREATEREQUAL LESSEQUAL
%left '+' '-'
%left '*' '/' '#'
%right DECREMENT INCREMENT SIMBOL_PUTERE SIMBOL_APROXIMARE 
%nonassoc VIRGULA SEMICOLON OTHER
 
%%
prog:
  stmts
;
stmts :
    | statement SEMICOLON stmts 
    | statement VIRGULA stmts 
    | SEMICOLON stmts

;
statement : 
        expression { fprintf(yyout, "%s\n",$1); }
        |VAR '=' expression { strcpy(sym_c[$1], $3); /*printf("sym[%d]=[%s]\n", $1,$3);*/}
        |OTHER

;

expression:  
      VAR { $$ = strdup(sym_c[$1]); /*printf("scot din sym[%d] valoarea %s\n", $1,$$);*/}
    | expression '+' expression {char* s=strdup($1);strcat(s,$3);$$=s;}
    | expression '-' expression {$$=str_remove($1,$3);}
    | INCREMENT expression {$$=increment_first_char($2);}
    | DECREMENT expression {$$=decrement_first_char($2);}
    | SIMBOL_PUTERE expression {$$=strvrs($2);}
    | SIMBOL_APROXIMARE expression {asprintf (&$$, "%i", strlen($2));}
	| expression '*' CINT  {$$=string_repeat($1,$3);}
	| expression '/' CINT  {$$=get_last_chars($1,$3);}
	| expression '#' CINT  {$$=get_first_chars($1,$3);}
	| expression EQUAL expression {asprintf (&$$, "%i", !strcmp($1, $3));}
	| expression NOTEQUAL expression {int tmp=0; if(strcmp($1, $3)!=0) tmp=1; asprintf (&$$, "%i", tmp);}
	| expression GREATER expression {$$=(strlen($1)>strlen($3)) ? "1" : "0";}
	| expression LESS expression {$$=(strlen($1)<strlen($3)) ? "1" : "0";}
	| expression GREATEREQUAL expression {$$=(strlen($1)>=strlen($3)) ? "1" : "0";}
	| expression LESSEQUAL expression {$$=(strlen($1)<=strlen($3)) ? "1" : "0";}
	| '(' expression ')' { $$ = $2; }
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
   //printf("%s\n",str);
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
   //printf("%s\n",str);
   return str;
}
char* strvrs(char *str)
{
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
char*  get_first_chars(const char *str, int n)
{
	/*   "ertyu"#3="ert"   */
	char *dest = malloc(n+1);
	strncpy(dest, str, n);
	dest[n] = '\0';
	return dest;
}
char* str_remove(char *str, const char *sub)
{
    size_t len = strlen(sub);
    if (len > 0) {
        char *p = str;
        while ((p = strstr(p, sub)) != NULL) {
            memmove(p, p + len, strlen(p + len) + 1);
        }
    }
    return str;
}

int main(int argc, char *argv[]) {
    //printf("%d",argc);
    if (argc==1)
    {
      yyin = stdin;
      while (!feof(yyin)){
        yyparse();
      }
    }
    else if(argc==2)
    { 
      //printf("\n%s\n",argv[1]);
      FILE *myfile = fopen(argv[1], "r");
      if (!myfile) {
          printf("Nu exista fisierul de input: %s\n",argv[1]);
          return 1;
      }
      yyin = myfile;
      do {
          yyparse();
      } while (!feof(yyin));
      fclose(yyin);
    }
    else if(argc==3)
      { 
        //printf("\n%s\n",argv[1]);
        FILE *myfile = fopen(argv[1], "r");
        FILE *output = fopen(argv[2], "w");
        if (!myfile) {
            printf("Nu exista fisierul de input: %s\n",argv[1]);
            return 1;
        }
        yyin = myfile;
        yyout = output;
        do {
            yyparse();
        } while (!feof(yyin));
        fclose(yyout);
        fclose(yyin);
      }
}

void yyerror(char *s) {
    printf("\nParse error!  Message:%s\n",s);
    exit(1);
}
