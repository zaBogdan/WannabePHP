%{
#include <stdio.h>
#include <string.h>
#include "y.tab.c"
%}

%%
"Int" {yylval.value = strdup(yytext); return INTEGER;}
"Float" {yylval.value = strdup(yytext);return FLOAT;}
"Char" {yylval.value = strdup(yytext);return CHAR;}
"String" {yylval.value = strdup(yytext);return STRING;}
"Boolean" {yylval.value = strdup(yytext);return BOOL;}
"Void" {yylval.value = strdup(yytext);return VOID;}

"Object" {return CLASA;}
"Readonly" {return CONSTANT;}
"public" {return PUBLIC;}
"private" {return PRIVAT;}

"__global__" {return DECLARATION_SECTION;}
"__custom_types__" {return CUSTOMTYPES_SECTION;}
"__main__" {return MAIN_SECTION;}

"->" {return ASSIGN;}
"[" {return PARANTEZAPATRATADESCHISA;}
"]" {return PARANTEZAPATRATAINCHISA;}
"(" {return PARANTEZAROTUNDADESCHISA;}
")" {return PARANTEZAROTUNDAINCHISA;}
"{" {return ACOLADADESCHISA;}
"}" {return ACOLADAINCHISA;}
";" {return PUNCTSIVIRGULA;}
"," {return VIRGULA;}
"." {return PUNCT;}


"daca" {return IFSTMT;}
"atunci" {return ELSESTMT;}
"pentru" {return FORSTMT;}
"executa" {return DOSTMT;}
"catTimp" {return WHILESTMT;}
"return" {return RETURNSTMT;}


"Print" {return PRINT;}

"&" {return BOOLEAN_AND;}
"|" {return BOOLEAN_OR;}
"!" {return BOOLEAN_NOT;}
"<" {return BOOLEAN_LT;}
"<=" {return BOOLEAN_LTE;}
">=" {return BOOLEAN_GTE;}
"===" {return BOOLEAN_EQ;}
"!==" {return BOOLEAN_NEQ;}


"+" {return ARITMETIC_ADD;}
"++" {return ARITMETIC_INCREMENT;}
"-" {return ARITMETIC_SUB;}
"--" {return ARITMETIC_DECREMENT;}
"/" {return ARITMETIC_DIV;}
"*" {return ARITMETIC_MUL;}
"**" {return ARITMETIC_POW;}


"True" {yylval.value=strdup(yytext);return BOOL_TRUE;}
"False" {yylval.value=strdup(yytext);return BOOL_FALSE;}
$[_a-zA-Z][_a-zA-Z0-9]* {yylval.value=strdup(yytext);return IDENTIFICATOR;}
[_a-zA-Z][_a-zA-Z0-9]* {yylval.value=strdup(yytext);return NUME_ARBITRAR;}
[0-9]+ {yylval.value=strdup(yytext); return NUMAR;}
[0-9]+.[0-9]+ {yylval.value=strdup(yytext); return NUMAR_FLOAT;}
\"[a-zA-Z0-9 ]+\" {yylval.value=strdup(yytext); return QUOTES_STRING;}
\'[a-zA-Z]\' {yylval.value=strdup(yytext); return CARACTER;}


[ \t] ;
\n {++yylineno;}
\/\/ {++yylineno;}
. {return yytext[0];}

%%