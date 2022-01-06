#pragma once
#include "structures.h"
#define TYPE_INTEGER 1
#define TYPE_FLOAT 2
#define TYPE_CHAR 3
#define TYPE_STRING 4
#define TYPE_BOOL 5
#define TYPE_VOID 6

//global variables
char currentContext[50], oldContext[50];
bool constantContext = false;
Object storedData[1000];

char identifiers[1000][100];

uint16_t identifiersIDX = 0, storedDataIDX = 0;
//bsion definitions
int yylex();
void yyerror(char *s);

//utility function
Value GetValueFromChar(char* key, char* value, int type);
int GetTypeFromString(char* strType);

// context functions
void SwitchContext(char* name);
void ExitContext();
void ClassContext(char* name);
void EnterConstant();
void LeaveConstant();

//Data structures (global helper functions)
void PushIdentifier(char* id);
void PushObjectToContext(Object newObj);
int IsIdentifierDeclared(char* name);

//Data structures (implementations)
void DeclareVariable(char* type, char* key, char* value, bool _init);
void AssignValue(char* key, char* value);
void DeclareArray(char* type, char* key, bool _init);