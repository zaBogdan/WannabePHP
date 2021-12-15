%{
#include <stdio.h>
#include "y.tab.c"
%}
%option noyywrap
%%
"int"|"float"|"char"|"string"|"bool" {return TIP;}
"starting" {return BGIN;}
"ending" {return END;}
$[_a-zA-Z][_a-zA-Z0-9]* {return ID;}
"->" {return ASSIGN;}
"0X"|"00" {return BOOLEAN;}
[0-9]+ {return NR;}
[a-zA-Z]+ {yylval.strval=strdup(yytext); return STRING;}
[ \t] ;
\n {yylineno++;}
. {return yytext[0];}

 