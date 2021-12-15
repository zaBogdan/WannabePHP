%{
#include <stdio.h>
extern FILE* yyin;
extern char* yytext;
extern int yylineno;
%}
%{
int yylex();
void yyerror(char *s);
%}
%union {
int intval;
char* strval;
}

%token ID TIP BGIN END ASSIGN NR CHAR BOOLEAN
%token <strval>STRING 
%start progr
%%
progr: declaratii bloc {printf("program corect sintactic\n");}
     ;

declaratii :  declaratie ';'
	   | declaratii declaratie ';'
	   ;
declaratie : TIP ID 
           | TIP ID '(' lista_param ')'
           | TIP ID '(' ')'
           ;
lista_param : param
            | lista_param ','  param 
            ;
            
param : TIP ID
      ; 
      
/* bloc */
bloc : BGIN list END  
     ;
     
/* lista instructiuni */
list :  statement ';' 
     | arithmetic_operations';'
     | list arithmetic_operations';'
     | list statement ';'
     ;

/* instructiune */
statement: ID ASSIGN ID
         | ID ASSIGN NR 
         | ID ASSIGN BOOLEAN 		 
         | ID ASSIGN STRING 		 
         | ID '(' lista_apel ')'
         ;

arithemtic_param : ID 
                 | arithmetic_operations
                 | NR
                 ;

/* inmultire si adunare */
arithmetic_operations : '(' arithemtic_param '+' arithemtic_param ')' 
                      | '(' arithemtic_param '*' arithemtic_param ')'
                      | '(' arithemtic_param '-' arithemtic_param ')'
                      | '(' arithemtic_param '/' arithemtic_param ')'
                      ;

lista_apel : NR
           | lista_apel ',' NR
           ;
%%
void yyerror(char * s){
printf("eroare: %s la linia:%d\n",s,yylineno);
}

int main(int argc, char** argv){
yyin=fopen(argv[1],"r");
yyparse();
} 