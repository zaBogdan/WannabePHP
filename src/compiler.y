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

%union{
    char* value;
}

%token VOID CLASA CONSTANT PUBLIC PRIVAT DECLARATION_SECTION CUSTOMTYPES_SECTION MAIN_SECTION ASSIGN PARANTEZAPATRATADESCHISA PARANTEZAPATRATAINCHISA PARANTEZAROTUNDADESCHISA PARANTEZAROTUNDAINCHISA ACOLADADESCHISA ACOLADAINCHISA PUNCTSIVIRGULA VIRGULA PUNCT IFSTMT ELSESTMT FORSTMT DOSTMT WHILESTMT RETURNSTMT PRINT BOOLEAN_AND BOOLEAN_OR BOOLEAN_NOT BOOLEAN_LT BOOLEAN_LTE BOOLEAN_GTE BOOLEAN_EQ BOOLEAN_NEQ ARITMETIC_INCREMENT ARITMETIC_DECREMENT ARITMETIC_ADD ARITMETIC_SUB ARITMETIC_DIV ARITMETIC_MUL ARITMETIC_POW

%start entry_point

%token <value> INTEGER FLOAT CHAR STRING BOOL
%token <value> BOOL_TRUE BOOL_FALSE IDENTIFIER NUME_ARBITRAR NUMAR NUMAR_FLOAT QUOTES_STRING CARACTER

%type <value> available_types
%type <value> available_values

%%

entry_point: code_structure { printf("Code syntax is correct.\n"); }
        ;

code_structure: global_scope main_scope
        ;

//here we will have the main scope
global_scope: DECLARATION_SECTION { SwitchContext("global"); } declarations PUNCTSIVIRGULA
        | global_scope declarations PUNCTSIVIRGULA
        ;

main_scope: MAIN_SECTION { SwitchContext("main"); } code_block
        ;

code_block: code_sequence PUNCTSIVIRGULA
        | code_block code_sequence PUNCTSIVIRGULA
        ;

code_sequence: declarations
        | assign_value
        | initialize_class
        ;

available_types: INTEGER { $$ = $1; }
        | FLOAT { $$ = $1; }
        | CHAR { $$ = $1; }
        | STRING { $$ = $1; }
        | BOOL { $$ = $1; }
        ;

//all of these must return strings
available_values: NUMAR { $$ = $1; }
        | NUMAR_FLOAT { $$ = $1; }
        | BOOL_TRUE { $$ = $1; }
        | BOOL_FALSE { $$ = $1; }
        | QUOTES_STRING { $$ = $1; }
        | CARACTER { $$ = $1; }
        | IDENTIFIER { $$ = $1; } //GetValueStringFromID($1)
        //function_call
        //arithemic expressions
        //boolean expressions
        ;

//to be decided what to return and how to manage it...
value_list: available_values
        | value_list VIRGULA available_values
        ;

assign_value: IDENTIFIER ASSIGN available_values { AssignValue($1, $3); } //assign normal value
        | IDENTIFIER PARANTEZAPATRATADESCHISA NUMAR PARANTEZAPATRATAINCHISA ASSIGN available_values //assign to array on pos
        | IDENTIFIER ASSIGN PARANTEZAROTUNDADESCHISA value_list PARANTEZAROTUNDAINCHISA //assign an array
        | IDENTIFIER PUNCT IDENTIFIER ASSIGN available_values //assign to class
        ;

initialize_class: NUME_ARBITRAR IDENTIFIER //init class

declarations: declaration
        | CONSTANT {EnterConstant(); } declaration {LeaveConstant();}
        ;

declaration: declare_only
        | declare_and_assign
        ;

declare_only: available_types IDENTIFIER { DeclareVariable($1, $2, "", false); } //declare, noinit 
        | available_types IDENTIFIER PARANTEZAPATRATADESCHISA PARANTEZAPATRATAINCHISA { DeclareArray($1, $2, false); }//array, no init
        ;

declare_and_assign: available_types IDENTIFIER ASSIGN available_values { DeclareVariable($1, $2, $4, true); } //declare, init
        | available_types IDENTIFIER PARANTEZAPATRATADESCHISA PARANTEZAPATRATAINCHISA ASSIGN PARANTEZAROTUNDADESCHISA value_list PARANTEZAROTUNDAINCHISA { DeclareArray($1, $2, true); } //arrays
        ;
%%

void yyerror(char * s){
     printf("Compile error at line: %d\nError: %s\n",yylineno, s);
     exit(1);
}

int main(int argc, char** argv){
     yyin=fopen(argv[1],"r");
     yyparse();
    //  FILE* variableTable = fopen("symbol_table.txt", "w");
    //  DumpVariablesToFile(variableTable);
    return 0;
} 