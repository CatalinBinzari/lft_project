/* Fisierul calc3.y pentru bison. */
%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "calc3.h"


extern FILE *yyin;
extern FILE *yyout;

/* prototypes */
nodeType *opr(int oper, int nops, ...);
nodeType *id(int vaue);
nodeType *con(char *str);
void freeNode(nodeType *p);
int ex(nodeType *p);
int yylex(void);

void yyerror(char *s);
int sym[26]; /* symbol table */
%}
%union {
	char* strval;
	char* strval1;
	int iValue;
	int intval;
	char sIndex;
	nodeType *nPtr;

};
%token <strval> STRING
%token <intval> CINT
%token <sIndex> VAR
%right EQUAL NOTEQUAL GREATER LESS GREATEREQUAL LESSEQUAL
%left '+' '-'
%left '*' '/' '#'
%right DECREMENT INCREMENT SIMBOL_PUTERE SIMBOL_APROXIMARE 
%nonassoc VIRGULA SEMICOLON OTHER
%type <nPtr> stmt expr
%%

program: function { exit(0); }
		 ;
function:
		 function stmt { ex($2); freeNode($2);}
		 | /* NULL */
		 ;

stmt:
	SEMICOLON									{$$ = opr(SEMICOLON, 2, NULL, NULL); }
	| expr SEMICOLON							{$$ = $1; }
	| VAR '=' expr SEMICOLON		 			{$$ = opr('=', 2, id($1), $3); }
	;

expr:
	  STRING					 { $$ = con($1);}
	| CINT						 { char* str; asprintf (&str, "%i", $1);$$ = con(str);}
	| VAR  						 { $$ = id($1); }
	| expr '+' expr         	 { $$ = opr('+', 2, $1, $3); }
	| expr '-' expr          	 { $$ = opr('-', 2, $1, $3); }
	| expr '*' expr        	 	 { $$ = opr('*', 2, $1, $3); }
	| expr '/' expr         	 { $$ = opr('/', 2, $1, $3); }
	| expr LESS    expr     	 { $$ = opr('<', 2, $1, $3); }
	| expr GREATER expr     	 { $$ = opr('>', 2, $1, $3); }
	| expr GREATEREQUAL expr     { $$ = opr(GREATEREQUAL, 2, $1, $3); }
	| expr LESSEQUAL expr        { $$ = opr(LESSEQUAL, 2, $1, $3); }
	| expr EQUAL expr        	 { $$ = opr(EQUAL, 2, $1, $3); }
	| expr NOTEQUAL expr         { $$ = opr(NOTEQUAL, 2, $1, $3); }
	| expr '#' expr				 { $$ = opr('#', 2, $1, $3);}
	| SIMBOL_APROXIMARE expr	 { $$ = opr('~', 1, $2);}
	| SIMBOL_PUTERE expr	 	 { $$ = opr('^', 1, $2);}
	| INCREMENT expr			 { $$ = opr(INCREMENT, 1, $2);}
	| expr INCREMENT			 { $$ = opr(INCREMENT, 1, $1);}
	| DECREMENT expr			 { $$ = opr(DECREMENT, 1, $2);}
	| expr DECREMENT			 { $$ = opr(DECREMENT, 1, $1);}
	| '(' expr ')'		         { $$ = $2; }
	;
%%

nodeType *con(char *str) {
	//se aloca in nod valoarea constantei int value si tipul nodului typeCon, adica constanta
	nodeType *p;
	/* allocate node */
	if ((p = malloc(sizeof(nodeType))) == NULL)
		yyerror("out of memory");
	/* copy information */
	p->type = typeCon;
	p->con.value = str;

	return p;
}

nodeType *id(int i) {
	//primeste un int, de exemplu ptr a=0, b=1,c=2...
	nodeType *p; //se creaza un not 
	/* allocate node */
	if ((p = malloc(sizeof(nodeType))) == NULL)
	yyerror("out of memory");
	/* copy information */
	p->type = typeId; //se indica tipul nodului fiind typeId
	p->id.i = i; //se indica indice acel int

	return p;//returneaza nodul
}

nodeType *opr(int oper, int nops, ...) {
	va_list ap;
	nodeType *p;
	int i;
	/* allocate node, extending op array */
	if ((p = malloc(sizeof(nodeType) + (nops-1) * sizeof(nodeType *))) ==
	NULL)
		yyerror("out of memory");
	/* copy information */
	p->type = typeOpr;  // tip operator?
	p->opr.oper = oper; 
	p->opr.nops = nops; 
	va_start(ap, nops);
	for (i = 0; i < nops; i++)
	p->opr.op[i] = va_arg(ap, nodeType*);
	va_end(ap);
	return p;
}

void freeNode(nodeType *p) {
	int i;
	if (!p) return;
	if (p->type == typeOpr) {
	for (i = 0; i < p->opr.nops; i++)
	freeNode(p->opr.op[i]);
	}
	free (p);
}
void yyerror(char *s) {
	fprintf(stdout, "%s\n", s);
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
}
