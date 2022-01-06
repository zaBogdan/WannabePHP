%{
#define _GNU_SOURCE
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include "main.h"
extern FILE* yyin;
extern char* yytext;
extern int yylineno;
%}

%union {
     struct suportedTypes* valori;
     char* value;
}

%token STRING CARACTER INTEGER FLOAT CHAR BOOL VOID CLASA CONSTANT PUBLIC PRIVAT DECLARATION_SECTION CUSTOMTYPES_SECTION MAIN_SECTION ASIGNARE PARANTEZAPATRATADESCHISA PARANTEZAPATRATAINCHISA PARANTEZAROTUNDADESCHISA PARANTEZAROTUNDAINCHISA PUNCTSIVIRGULA VIRGULA IFSTMT ELSESTMT FORSTMT DOSTMT WHILESTMT RETURNSTMT PRINT BOOLEAN_AND BOOLEAN_OR BOOLEAN_NOT BOOLEAN_LT BOOLEAN_LTE BOOLEAN_GTE BOOLEAN_EQ BOOLEAN_NEQ ARITMETIC_ADD ARITMETIC_INCREMENT ARITMETIC_SUB ARITMETIC_DECREMENT ARITMETIC_DIV ARITMETIC_MUL ARITMETIC_POW IDENTIFICATOR BOOL_TRUE BOOL_FALSE QUOTES_STRING ACOLADADESCHISA ACOLADAINCHISA ASSIGN NUME_ARBITRAR  PUNCT

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

%type <value> tipuri_de_argumente

%%
corect: program {printf("program corect sintactic\n");}
     ;


program: declaratii_globale declaratii_tipuri_custom main
     | declaratii_globale main
     | declaratii_tipuri_custom main
     | main 
     ;

//__global__
declaratii_globale : {switchContext("global");} DECLARATION_SECTION declaratie PUNCTSIVIRGULA
     | declaratii_globale declaratie PUNCTSIVIRGULA
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
clasa: CLASA NUME_ARBITRAR {DeclareClass($2); class_enter($2);} ACOLADADESCHISA declaratie_clasa ACOLADAINCHISA PUNCTSIVIRGULA {class_leave();} 
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

bloc: asginare_variabila PUNCTSIVIRGULA
     | apel_functie_din_clasa PUNCTSIVIRGULA
     | apel_functie PUNCTSIVIRGULA
     | declaratie PUNCTSIVIRGULA
     | print_function PUNCTSIVIRGULA
     | intializare_clasa PUNCTSIVIRGULA
     | asignare_variabila_din_clasa PUNCTSIVIRGULA
     ;

intializare_clasa: NUME_ARBITRAR IDENTIFICATOR { InitializeClass($1, $2); }
               ;

asignare_variabila_din_clasa: IDENTIFICATOR {switchContext(GetClassNameFromIdentifier($1));} PUNCT asginare_variabila {revertContext();}
     ;


apel_functie_din_clasa: NUME_ARBITRAR PUNCT apel_functie


apel_functie: NUME_ARBITRAR PARANTEZAPATRATADESCHISA list_arg_apel_functie PARANTEZAPATRATAINCHISA


list_arg_apel_functie: tipuri_de_argumente
          | list_arg_apel_functie VIRGULA tipuri_de_argumente
          ;


tipuri_de_argumente: NUMAR { $$ = $1; }
               | NUMAR_FLOAT { $$ = $1; }
               | QUOTES_STRING { $$ = $1; }
               | BOOL_FALSE { $$ = $1; }
               | BOOL_TRUE { $$ = $1; }
               | CARACTER { $$ = $1; }
               // | apel_functie
               // | IDENTIFICATOR
               ;

asginare_variabila: IDENTIFICATOR ASSIGN NUMAR    {AssignVariable($1, $3);}
     | IDENTIFICATOR ASSIGN NUMAR_FLOAT           {AssignVariable($1, $3);}
     | IDENTIFICATOR ASSIGN CARACTER              {AssignVariable($1, $3);}
     | IDENTIFICATOR ASSIGN QUOTES_STRING         {AssignVariable($1, $3);}
     | IDENTIFICATOR ASSIGN BOOL_FALSE            {AssignVariable($1, $3);}
     | IDENTIFICATOR ASSIGN BOOL_TRUE             {AssignVariable($1, $3);}

// Readonly sau declaratie_tip;
declaratie: CONSTANT {constat_enter();} tipuri_de_declaratii {constat_leave();} 
          | tipuri_de_declaratii
          ;

tipuri_de_declaratii: declaratie_tip
          | declaratie_array
          ;

//avem de tipul public/privat
declaratie_in_clasa: PUBLIC declaratie PUNCTSIVIRGULA
          | PRIVAT declaratie PUNCTSIVIRGULA
          | declaratie_in_clasa PUBLIC declaratie PUNCTSIVIRGULA
          | declaratie_in_clasa PRIVAT declaratie PUNCTSIVIRGULA
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

// Int[] $x -> (12,20,30,40)
declaratie_array: INTEGER IDENTIFICATOR PARANTEZAPATRATADESCHISA PARANTEZAPATRATAINCHISA
     | INTEGER IDENTIFICATOR PARANTEZAPATRATADESCHISA PARANTEZAPATRATAINCHISA ASSIGN {enter_array($1);} lista_array
     | FLOAT IDENTIFICATOR PARANTEZAPATRATADESCHISA PARANTEZAPATRATAINCHISA
     | FLOAT IDENTIFICATOR PARANTEZAPATRATADESCHISA PARANTEZAPATRATAINCHISA ASSIGN {enter_array($1);} lista_array
     | CHAR IDENTIFICATOR PARANTEZAPATRATADESCHISA PARANTEZAPATRATAINCHISA
     | CHAR IDENTIFICATOR PARANTEZAPATRATADESCHISA PARANTEZAPATRATAINCHISA ASSIGN {enter_array($1);} lista_array
     | STRING IDENTIFICATOR PARANTEZAPATRATADESCHISA PARANTEZAPATRATAINCHISA
     | STRING IDENTIFICATOR PARANTEZAPATRATADESCHISA PARANTEZAPATRATAINCHISA ASSIGN {enter_array($1);} lista_array
     | BOOL IDENTIFICATOR PARANTEZAPATRATADESCHISA PARANTEZAPATRATAINCHISA
     | BOOL IDENTIFICATOR PARANTEZAPATRATADESCHISA PARANTEZAPATRATAINCHISA ASSIGN {enter_array($1);} lista_array
     ;



lista_array: PARANTEZAROTUNDADESCHISA lista_valori_array PARANTEZAROTUNDAINCHISA 
     ;

lista_valori_array: tipuri_de_argumente { InitializeVector($1);}
     | lista_valori_array VIRGULA tipuri_de_argumente { AddValueToArray($3); }
     ;

print_function: PRINT PARANTEZAPATRATADESCHISA QUOTES_STRING VIRGULA NUMAR PARANTEZAPATRATAINCHISA { PrintValue($3, $5); }
     | PRINT PARANTEZAPATRATADESCHISA QUOTES_STRING VIRGULA NUMAR_FLOAT PARANTEZAPATRATAINCHISA { PrintValue($3, $5); }
     | PRINT PARANTEZAPATRATADESCHISA QUOTES_STRING VIRGULA BOOL_TRUE PARANTEZAPATRATAINCHISA { PrintValue($3, $5); }
     | PRINT PARANTEZAPATRATADESCHISA QUOTES_STRING VIRGULA BOOL_FALSE PARANTEZAPATRATAINCHISA { PrintValue($3, $5); }
     | PRINT PARANTEZAPATRATADESCHISA QUOTES_STRING VIRGULA IDENTIFICATOR PARANTEZAPATRATAINCHISA { PrintIdentifier($3, $5); }
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