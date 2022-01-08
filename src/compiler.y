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
    int num;
    char* value;
}

%token VOID CLASA CONSTANT PUBLIC PRIVAT DECLARATION_SECTION CUSTOMTYPES_SECTION MAIN_SECTION ASSIGN PARANTEZAPATRATADESCHISA PARANTEZAPATRATAINCHISA PARANTEZAROTUNDADESCHISA PARANTEZAROTUNDAINCHISA ACOLADADESCHISA ACOLADAINCHISA PUNCTSIVIRGULA VIRGULA PUNCT IFSTMT ELSESTMT FORSTMT DOSTMT WHILESTMT RETURNSTMT PRINT BOOLEAN_AND BOOLEAN_OR BOOLEAN_NOT BOOLEAN_LT BOOLEAN_LTE BOOLEAN_GTE BOOLEAN_EQ BOOLEAN_NEQ ARITMETIC_INCREMENT ARITMETIC_DECREMENT ARITMETIC_ADD ARITMETIC_SUB ARITMETIC_DIV  BOOLEAN_GT ARITMETIC_MUL ARITMETIC_POW

%start entry_point

%token <value> INTEGER FLOAT CHAR STRING BOOL
%token <value> BOOL_TRUE BOOL_FALSE IDENTIFIER NUME_ARBITRAR NUMAR NUMAR_FLOAT QUOTES_STRING CARACTER

%type <value> available_types
%type <value> available_values
%type <value> custom_available_values

%type <num> function_argument_list

%left ARITMETIC_ADD ARITMETIC_SUB ARITMETIC_DIV ARITMETIC_MUL ARITMETIC_POW
%left BOOLEAN_AND BOOLEAN_OR BOOLEAN_LT BOOLEAN_LTE BOOLEAN_GTE BOOLEAN_EQ BOOLEAN_NEQ BOOLEAN_GT

%right BOOLEAN_NOT 
%%

entry_point: code_structure { printf("Code syntax is correct.\n"); }
        ;

code_structure: global_scope custom_scope main_scope
        | global_scope main_scope
        | custom_scope main_scope
        | main_scope
        ;

custom_scope: CUSTOMTYPES_SECTION declare_object
        | CUSTOMTYPES_SECTION declare_function
        | custom_scope declare_object
        | custom_scope declare_function
        ;

//the scope should be class name ($2)
declare_object: CLASA NUME_ARBITRAR {DeclareType($2); ClassContext($2);} ACOLADADESCHISA object_block ACOLADAINCHISA PUNCTSIVIRGULA {ExitContext();}

object_block: object_code 
        | object_block object_code 
        ;

object_code: PUBLIC declarations PUNCTSIVIRGULA
        | PRIVAT declarations PUNCTSIVIRGULA
        | declare_function
        ;

//the scope should be either class_name.function_name or function_name (declared in global context) 
declare_function: available_types NUME_ARBITRAR {FunctionContext($2);} PARANTEZAROTUNDADESCHISA function_argument_list PARANTEZAROTUNDAINCHISA {DeclareFunction($1, $2, $5);} ACOLADADESCHISA code_block ACOLADAINCHISA { ExitContext(); }
        ;

//use the identifiersIDX and count how many args do you have. Just subtract it and you have it all.
function_argument_list: declare_only { $$ = 1; }
        | function_argument_list VIRGULA declare_only { $$++; }

//here we will have the main scope
global_scope: DECLARATION_SECTION { SwitchContext("global"); } declarations PUNCTSIVIRGULA
        | global_scope declarations PUNCTSIVIRGULA
        ;

main_scope: MAIN_SECTION { SwitchContext("main"); } code_block
        ;

code_block: code_sequence
        | code_block code_sequence 
        ;

code_sequence: declarations PUNCTSIVIRGULA
        | assign_value PUNCTSIVIRGULA
        | initialize_class PUNCTSIVIRGULA
        | print_function PUNCTSIVIRGULA
        | function_call PUNCTSIVIRGULA
        | stmt_instructions
        ;

stmt_instructions: IFSTMT PARANTEZAROTUNDADESCHISA boolean_expression PARANTEZAROTUNDAINCHISA stmt_code_format
        | IFSTMT PARANTEZAROTUNDADESCHISA boolean_expression PARANTEZAROTUNDAINCHISA stmt_code_format ELSESTMT stmt_code_format
        | DOSTMT stmt_code_format WHILESTMT PARANTEZAROTUNDADESCHISA boolean_expression PARANTEZAROTUNDAINCHISA
        | WHILESTMT PARANTEZAROTUNDADESCHISA boolean_expression PARANTEZAROTUNDAINCHISA stmt_code_format
        | FORSTMT PARANTEZAROTUNDADESCHISA assign_value PUNCTSIVIRGULA boolean_expression PUNCTSIVIRGULA assign_value PARANTEZAROTUNDAINCHISA stmt_code_format
        ;

stmt_code_format: ACOLADADESCHISA code_block ACOLADAINCHISA

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
        | IDENTIFIER { $$ = GetValueFromIdentifier($1,0); } 
        | IDENTIFIER PARANTEZAPATRATADESCHISA NUMAR PARANTEZAPATRATAINCHISA { $$ = GetValueFromIdentifier($1,atoi($3)); } 
        | function_call { $$ = "0"; } //ValidateFunctionCall
        | arithemtic_expression { $$ = "1"; } //evaluate expression
        | boolean_expression { $$ = "1"; } //evaluate boolean
        ;

function_call: NUME_ARBITRAR PARANTEZAROTUNDADESCHISA function_call_args_list PARANTEZAROTUNDAINCHISA
        ;


function_call_args_list: available_values
        | function_call_args_list VIRGULA available_values
        ;

//all thepossible arithemtic expressions
arithemtic_expression: custom_available_values ARITMETIC_ADD custom_available_values 
        | custom_available_values ARITMETIC_SUB custom_available_values
        | custom_available_values ARITMETIC_DIV custom_available_values
        | custom_available_values ARITMETIC_POW custom_available_values
        | custom_available_values ARITMETIC_MUL custom_available_values
        | PARANTEZAROTUNDADESCHISA arithemtic_expression PARANTEZAROTUNDAINCHISA
        ;


boolean_expression: custom_available_values BOOLEAN_AND custom_available_values
        | custom_available_values BOOLEAN_OR custom_available_values
        | custom_available_values BOOLEAN_LT custom_available_values
        | custom_available_values BOOLEAN_LTE custom_available_values
        | custom_available_values BOOLEAN_GT custom_available_values
        | custom_available_values BOOLEAN_GTE custom_available_values
        | custom_available_values BOOLEAN_EQ custom_available_values
        | custom_available_values BOOLEAN_NEQ custom_available_values
        | BOOLEAN_NOT custom_available_values
        | PARANTEZAROTUNDADESCHISA boolean_expression PARANTEZAROTUNDAINCHISA
        ;

//to be decided what to return and how to manage it...
value_list: {InitializeArray();} available_values { PushElementInArray($2); }
        | value_list VIRGULA available_values { PushElementInArray($3); }
        ;

assign_value: IDENTIFIER ASSIGN available_values { AssignValue($1, $3, 0); } //assign normal value
        | IDENTIFIER PARANTEZAPATRATADESCHISA NUMAR PARANTEZAPATRATAINCHISA ASSIGN available_values { AssignValue($1, $6, atoi($3)); }//assign to array on pos
        | IDENTIFIER { SwitchToContextOfIdentifer($1); } PUNCT IDENTIFIER ASSIGN available_values { AssignValue($4, $6, 0); ExitContext(); } //assign to class
        ;//TODO: Switch context to type of identifer $1

initialize_class: NUME_ARBITRAR IDENTIFIER { DeclareClass($1,$2); }//init class

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

custom_available_values: NUMAR { $$ = $1; }
        | NUMAR_FLOAT { $$ = $1; }
        | IDENTIFIER { $$ = GetValueFromIdentifier($1,0); } 
        | IDENTIFIER PARANTEZAPATRATADESCHISA NUMAR PARANTEZAPATRATAINCHISA { $$ = GetValueFromIdentifier($1,atoi($3)); }
        | function_call { $$ = "0"; } //ValidateFunctionCall
        | arithemtic_expression { $$ = "0"; } //evaluate expression
        | boolean_expression { $$ = "1"; } //evaluate boolean
        ;


print_function: PRINT PARANTEZAROTUNDADESCHISA QUOTES_STRING VIRGULA custom_available_values PARANTEZAROTUNDAINCHISA {PrintFunction($3, $5); }
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
     DumpObjectsToFile(variableTable);

     FILE* functionTable = fopen("symbol_table_functions.txt", "w");
     DumpFunctionsToFile(functionTable);

return 0;
} 