#pragma once
#define TYPE_INTEGER 1
#define TYPE_FLOAT 2
#define TYPE_CHAR 3
#define TYPE_STRING 4
#define TYPE_BOOL 5
#define TYPE_VOID 6
#define CHECK_BREAK(cond,flag, code) {if((cond)) { if((flag==true))(code); break;}}
#include "structures.h"
#include <stdlib.h>

char currentScope[100];

//here we will keep all identifiers
char allKeys[1000][100];
struct Identifier globalScope[250], functionScope[250], objectScope[250];

//and there we will keep track of each identifier
int allKeysIDX = 0, globalScopeIDX = 0, functionScopeIDX = 0, objectScopeIDX = 0;

//this are for variable
bool constVariabile = false; 
bool privateVariabile = false; 

int yylex();
void yyerror(char *s);