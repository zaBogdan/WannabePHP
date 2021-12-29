%{
#define _GNU_SOURCE
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include "functions.h"
extern FILE* yyin;
extern char* yytext;
extern int yylineno;
%}

%union {
     int num;
     char* value;
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

%%
corect: program {printf("program corect sintactic\n");}
     ;


program: declaratii_globale declaratii_tipuri_custom main
     | declaratii_globale main
     | declaratii_tipuri_custom main
     | main 
     ;

//__global__
declaratii_globale : {switchContext("global");} DECLARATION_SECTION declaratie 
     | declaratii_globale declaratie
     ;

//__custom_types__
declaratii_tipuri_custom : CUSTOMTYPES_SECTION clasa
     | CUSTOMTYPES_SECTION functii
     | declaratii_tipuri_custom clasa
     | declaratii_tipuri_custom functii
     ;

//main
main : {switchContext("main");} MAIN_SECTION bloc_cod


//Object data {cod}
clasa: CLASA NUME_ARBITRAR {class_enter($2);} ACOLADADESCHISA declaratie_clasa ACOLADAINCHISA PUNCTSIVIRGULA {class_leave();} 
     ;

//descriem declaratia unei clase:
declaratie_clasa: declaratie_in_clasa multiple_functions
               | declaratie_in_clasa
               | multiple_functions
               ;

multiple_functions: multiple_functions functii
               | functii
               ;

functii: INTEGER NUME_ARBITRAR {function_enter($2);} PARANTEZAPATRATADESCHISA lista_argumente PARANTEZAPATRATAINCHISA 
ACOLADADESCHISA bloc_cod ACOLADAINCHISA {function_leave();}

lista_argumente: declaratie_tip
               | lista_argumente VIRGULA declaratie_tip
               ;

//to be updated
bloc_cod: bloc
     | bloc_cod bloc

bloc: asginare_variabila
     | declaratie

asginare_variabila: IDENTIFICATOR ASSIGN NUMAR PUNCTSIVIRGULA    {AssignVariable($1, $3);}
     | IDENTIFICATOR ASSIGN NUMAR_FLOAT PUNCTSIVIRGULA           {AssignVariable($1, $3);}
     | IDENTIFICATOR ASSIGN CARACTER PUNCTSIVIRGULA              {AssignVariable($1, $3);}
     | IDENTIFICATOR ASSIGN QUOTES_STRING PUNCTSIVIRGULA         {AssignVariable($1, $3);}
     | IDENTIFICATOR ASSIGN BOOL_FALSE PUNCTSIVIRGULA            {AssignVariable($1, $3);}
     | IDENTIFICATOR ASSIGN BOOL_TRUE PUNCTSIVIRGULA             {AssignVariable($1, $3);}

// Readonly sau declaratie_tip;
declaratie: CONSTANT {constat_enter();} declaratie_tip {constat_leave();} PUNCTSIVIRGULA
          | declaratie_tip PUNCTSIVIRGULA
          ;

//avem de tipul public/privat
declaratie_in_clasa: PUBLIC declaratie
          | PRIVAT declaratie
          | declaratie_in_clasa PUBLIC declaratie
          | declaratie_in_clasa PRIVAT declaratie
          ;

// Int $x -> 10 (la fel pentru float, string, char, bool)
declaratie_tip: INTEGER IDENTIFICATOR                  { DeclareValue($1, $2, "", false); }
          | INTEGER IDENTIFICATOR ASSIGN NUMAR         { DeclareValue($1, $2, $4, true); }
          | FLOAT IDENTIFICATOR                        { DeclareValue($1, $2, "", false); }
          | FLOAT IDENTIFICATOR ASSIGN NUMAR_FLOAT     { DeclareValue($1, $2, $4, true); }
          | CHAR IDENTIFICATOR                         { DeclareValue($1, $2, "", false); }
          | CHAR IDENTIFICATOR ASSIGN CARACTER         { DeclareValue($1, $2, $4, true); }
          | STRING IDENTIFICATOR                       { DeclareValue($1, $2, "", false); }
          | STRING IDENTIFICATOR ASSIGN QUOTES_STRING  { DeclareValue($1, $2, $4, true); }
          | BOOL IDENTIFICATOR                         { DeclareValue($1, $2, "", false); }
          | BOOL IDENTIFICATOR ASSIGN BOOL_FALSE       { DeclareValue($1, $2, $4, true); }
          | BOOL IDENTIFICATOR ASSIGN BOOL_TRUE        { DeclareValue($1, $2, $4, true); }
          ;
%%
void yyerror(char * s){
     printf("Compile error at line: %d\nError: %s\n",yylineno, s);
     exit(1);
}

int main(int argc, char** argv){
     yyin=fopen(argv[1],"r");
     yyparse();
     FILE* variableTable = fopen("symbol_table.txt", "w");
     DumpVariablesToFile(variableTable);
} 