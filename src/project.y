%{
#define _GNU_SOURCE
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include "functii.h"
extern FILE* yyin;
extern char* yytext;
extern int yylineno;
%}

%union {
     int num;
     char* value;
     struct memValue returnData;
}

%token STRING CARACTER INTEGER FLOAT CHAR BOOL VOID CLASA CONSTANT PUBLIC PRIVAT DECLARATION_SECTION CUSTOMTYPES_SECTION MAIN_SECTION ASIGNARE PARANTEZAPATRATADESCHISA PARANTEZAPATRATAINCHISA PARANTEZAROTUNDADESCHISA PARANTEZAROTUNDAINCHISA PUNCTSIVIRGULA VIRGULA IFSTMT ELSESTMT FORSTMT DOSTMT WHILESTMT RETURNSTMT PRINT BOOLEAN_AND BOOLEAN_OR BOOLEAN_NOT BOOLEAN_LT BOOLEAN_LTE BOOLEAN_GTE BOOLEAN_EQ BOOLEAN_NEQ ARITMETIC_ADD ARITMETIC_INCREMENT ARITMETIC_SUB ARITMETIC_DECREMENT ARITMETIC_DIV ARITMETIC_MUL ARITMETIC_POW IDENTIFICATOR BOOL_TRUE BOOL_FALSE QUOTES_STRING ACOLADADESCHISA ACOLADAINCHISA ASSIGN NUME_ARBITRAR

%start corect

%type <value> STRING
%type <value> CARACTER 
%type <value> CHAR 
%type <value> BOOL 
%type <value> FLOAT 
%type <value> IDENTIFICATOR
%type <value> INTEGER
%type <value> NUME_ARBITRAR 

%token <value> NUMAR 
%type <value> BOOL_TRUE
%type <value> BOOL_FALSE
%token <value> NUMAR_FLOAT
%type <value> QUOTES_STRING

%type <returnData> declaratie_tip
%type <returnData> declaratie


%%
corect: program {printf("program corect sintactic\n");}
     ;


program: declaratii_globale declaratii_tipuri_custom main
     | declaratii_globale main
     | declaratii_tipuri_custom main
     | main 
     ;

//__global__
declaratii_globale : {strcpy(currentScope, "global");} DECLARATION_SECTION declaratie 
     | declaratii_globale declaratie
     ;

//__custom_types__
declaratii_tipuri_custom : CUSTOMTYPES_SECTION clasa
     | CUSTOMTYPES_SECTION functii
     | declaratii_tipuri_custom clasa
     | declaratii_tipuri_custom functii
     ;

//main
main : {strcpy(currentScope, "main");} MAIN_SECTION bloc_cod


//Object data {cod}
clasa: CLASA NUME_ARBITRAR {strcpy(currentScope, $2);} ACOLADADESCHISA declaratie_clasa ACOLADAINCHISA PUNCTSIVIRGULA
     ;

//descriem declaratia unei clase:
declaratie_clasa: declaratie_in_clasa functii
               | declaratie_in_clasa
               | functii
               ;

functii: INTEGER NUME_ARBITRAR {strcpy(currentScope, $2);} PARANTEZAPATRATADESCHISA lista_argumente PARANTEZAPATRATAINCHISA 
ACOLADADESCHISA bloc_cod ACOLADAINCHISA

lista_argumente: declaratie_tip
               | lista_argumente VIRGULA declaratie_tip
               ;

//to be updated
bloc_cod: declaratie
     ;

// Readonly sau declaratie_tip;
declaratie: CONSTANT declaratie_tip PUNCTSIVIRGULA {$$ = setConstant($2);}
          | declaratie_tip PUNCTSIVIRGULA {$$ = $1;}
          ;

//avem de tipul public/privat
declaratie_in_clasa: PUBLIC declaratie
          | PRIVAT declaratie
          | declaratie_in_clasa PUBLIC declaratie
          | declaratie_in_clasa PRIVAT declaratie
          ;

// Int $x -> 10 (la fel pentru float, string, char, bool)
declaratie_tip: INTEGER IDENTIFICATOR { $$ = constructValue($1, $2, 0); }
          | INTEGER IDENTIFICATOR ASSIGN NUMAR { $$ = constructValue($1, $2, $4); }
          | FLOAT IDENTIFICATOR { $$ = constructValue($1, $2, 0); }
          | FLOAT IDENTIFICATOR ASSIGN NUMAR_FLOAT { $$ = constructValue($1, $2, $4); }
          | CHAR IDENTIFICATOR { $$ = constructValue($1, $2, 0); }
          | CHAR IDENTIFICATOR ASSIGN CARACTER { $$ = constructValue($1, $2, $4); }
          | STRING IDENTIFICATOR { $$ = constructValue($1, $2, 0); }
          | STRING IDENTIFICATOR ASSIGN QUOTES_STRING { $$ = constructValue($1, $2, $4); }
          | BOOL IDENTIFICATOR { $$ = constructValue($1, $2, 0); }
          | BOOL IDENTIFICATOR ASSIGN BOOL_FALSE { $$ = constructValue($1, $2, $4); }
          | BOOL IDENTIFICATOR ASSIGN BOOL_TRUE { $$ = constructValue($1, $2, $4); }
          ;
%%
void yyerror(char * s){
     printf("eroare: %s la linia:%d\n",s,yylineno);
}

int main(int argc, char** argv){
     yyin=fopen(argv[1],"r");
     yyparse();
} 