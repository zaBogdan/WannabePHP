%{
#define _GNU_SOURCE
#include <stdio.h>
#include <string.h>
#include "auto.tab.h"
int yylineno;
%}

%%

"principal" { return PRINCIPAL;}
"constant" {return CONSTANT;}
"bmw"|"mini"|"mercedes"|"mercedes mercedes"|"mercedes bmw"|"mercedes mercedes bmw"|"audi"|"vw" {yylval.str = strdup(yytext); return PRODUCATOR;}
"checkEngine" { return BOOL;}
"true" { return TRUE;}
"false" { return FALSE;}
"dacia" { return DACIASTRING;}
"tesla" { return TESLACHAR;}
"if" {return IF;}
"else" {return ELSE;}
"while" {return WHILE;}
"for" {return FOR;}
"afiseaza" { return AFISEAZA;}
"clasa" { return CLASA;}
"{" {return ACOLADADESCHISA;}
"}" {return ACOLADAINCHISA;}
"(" {return ROTUNDADESCHISA;}
")" {return ROTUNDAINCHISA;}
"[" {return PATRATADESCHISA;}
"]" {return PATRATAINCHISA;}
"++" {yylval.str=strdup(yytext); return INCREMENTARE;}
"--" {yylval.str=strdup(yytext); return DECREMENTARE;}
"+=" {yylval.str=strdup(yytext); return PLUSEGAL;}
"-=" {yylval.str=strdup(yytext); return MINUSEGAL;}
"*=" {yylval.str=strdup(yytext); return INMULTIREEGAL;}
"/=" {yylval.str=strdup(yytext); return IMPARTIREEGAL;}
"||" {return SAU;}
"&&" {return SI;}
"==" {return EGALEGAL;}
"!=" {return NONEGAL;}
"<=" {return MEGAL;}
">=" {return MMEGAL;}
"<" {return M;}
">" {return MM;}
"!" {return NON;}
"=" {return EGAL;}
"+" {return PLUS;}
"-" {return MINUS;}
"*" {return INMULTIRE;}
"/" {return IMPARTIRE;}
"," {return VIRGULA;}
"." {return PUNCT;}
";" {return PUNCTVIRGULA;}
"&" {return SIB;}
"|" {return SAUB;}
"CONCAT" {return CONCATS;}
"LEN" {return LEN;}
"CMP" {return COMP;}
"IS IN" {return ISIN;}
\"[_a-zA-Z0-9 ]*\" {yylval.str=strdup(yytext); return PROPOZITIE;}
\'[a-zA-Z]\'    {yylval.str=strdup(yytext); return CARACTER;}
[_a-zA-Z][_a-zA-Z0-9]* {yylval.str=strdup(yytext); return IDENTIFICATOR;}
[0-9]+ {yylval.num = atoi(yytext); return NUMAR;}
[ \t] ;
\n {++yylineno;}
. {return yytext[0];}

%%

int yywrap() {return 1;}
