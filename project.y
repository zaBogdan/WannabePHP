%{
#define _GNU_SOURCE
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

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

%token STRING CARACTER INTEGER FLOAT CHAR BOOL VOID CLASA CONSTANT PUBLIC PRIVAT DECLARATION_SECTION CUSTOMTYPES_SECTION MAIN_SECTION ASIGNARE PARANTEZAPATRATADESCHISA PARANTEZAPATRATAINCHISA PARANTEZAROTUNDADESCHISA PARANTEZAROTUNDAINCHISA PUNCTSIVIRGULA VIRGULA IFSTMT ELSESTMT FORSTMT DOSTMT WHILESTMT RETURNSTMT PRINT BOOLEAN_AND BOOLEAN_OR BOOLEAN_NOT BOOLEAN_LT BOOLEAN_LTE BOOLEAN_GTE BOOLEAN_EQ BOOLEAN_NEQ ARITMETIC_ADD ARITMETIC_INCREMENT ARITMETIC_SUB ARITMETIC_DECREMENT ARITMETIC_DIV ARITMETIC_MUL ARITMETIC_POW IDENTIFICATOR BOOL_TRUE BOOL_FALSE NUMAR NUMAR_FLOAT QUOTES_STRING ACOLADADESCHISA ACOLADAINCHISA ASSIGN

%start corect

%type <strval>STRING
%type <strval>CARACTER 
%type <strval>IDENTIFICATOR
%type <strval>INTEGER
%%

corect: program {printf("program corect sintactic\n");}
     ;


program: declaratii_globale declaratii_tipuri_custom
     // declaratii_globale declaratii_tipuri_custom main
     // | declaratii_globale main
     // | declaratii_tipuri_custom main
     // | main 
     ;

//__global__
declaratii_globale : DECLARATION_SECTION declaratie
     | declaratii_globale declaratie
     ;

//__custom_types__
declaratii_tipuri_custom : CUSTOMTYPES_SECTION clasa
     | declaratii_tipuri_custom clasa
     ;

//__main__


//Object data {cod}
clasa: CLASA IDENTIFICATOR ACOLADADESCHISA declaratie_clasa ACOLADAINCHISA
     ;

//descriem declaratia unei clase:
declaratie_clasa: declaratie_in_clasa ;
     //functii

// Readonly sau declaratie_tip;
declaratie: CONSTANT declaratie_tip PUNCTSIVIRGULA
          | declaratie_tip PUNCTSIVIRGULA
          ;

//avem de tipul public/privat
declaratie_in_clasa: PUBLIC declaratie
          | PRIVAT declaratie
          | declaratie_in_clasa PUBLIC declaratie
          | declaratie_in_clasa PRIVAT declaratie
          ;

// Int $x -> 10 (la fel pentru float, string, char, bool)
declaratie_tip: INTEGER IDENTIFICATOR
          | INTEGER IDENTIFICATOR ASSIGN NUMAR
          | FLOAT IDENTIFICATOR
          | FLOAT IDENTIFICATOR ASSIGN NUMAR_FLOAT
          | CHAR IDENTIFICATOR 
          | CHAR IDENTIFICATOR ASSIGN CARACTER
          | STRING IDENTIFICATOR 
          | STRING IDENTIFICATOR ASSIGN QUOTES_STRING
          | BOOL IDENTIFICATOR 
          | BOOL IDENTIFICATOR ASSIGN BOOL_FALSE
          | BOOL IDENTIFICATOR ASSIGN BOOL_TRUE
          ;
%%
void yyerror(char * s){
printf("eroare: %s la linia:%d\n",s,yylineno);
}

int main(int argc, char** argv){
yyin=fopen(argv[1],"r");
yyparse();
} 