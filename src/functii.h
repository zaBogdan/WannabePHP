#pragma once
#define TYPE_INTEGER 1
#define TYPE_FLOAT 2
#define TYPE_CHAR 3
#define TYPE_STRING 4
#define TYPE_BOOL 5
#define TYPE_VOID 6

int yylex();
void yyerror(char *s);

struct memValue{
     char* name;
     //void type is not ok.
     unsigned int type;

     //for functions and objects
     char* scopeName;

     //all supported datatypes
     int number;
     char character;
     char* value;
     float floating;
     bool boolean;

     //some data
     bool isConstant;
     bool isIntialized;

};

char currentScope[100];
struct memValue globalScope[250], functionScope[250], objectScope[250];

struct memValue constructValue(char* tipDate , char* nume, char* initializam)
{
     struct memValue definedType;
     printf("Current scope is: %s and ", currentScope);
     //setting the name
     int nameLength = strlen(nume);
     definedType.name = malloc(nameLength*sizeof(char)+1);
     strcpy(definedType.name, nume);
     printf("The name is: %s\n", nume);
     
     //by default we set them as initialized
     definedType.isIntialized = true;

     //and not constant
     definedType.isConstant = false;

     if(strcmp(tipDate, "Int") == 0)
     {
          definedType.type = TYPE_INTEGER;
          if(initializam == 0)
          {
               definedType.number = 0;
          }else{
               definedType.number = atoi(initializam);
          }
          return definedType;
     }
     if(strcmp(tipDate, "Float") == 0)
     {
          definedType.type = TYPE_FLOAT;
          if(initializam == 0)
          {
               definedType.floating = 0;
          }else{
               definedType.floating = atof(initializam);
          }
          return definedType;
     }
     if(strcmp(tipDate, "Char") == 0)
     {
          definedType.type = TYPE_CHAR;
          if(initializam == 0)
          {
               definedType.isIntialized = false;
          }
          definedType.character = initializam[0];
          return definedType;
     }
     if(strcmp(tipDate, "String") == 0)
     {
          definedType.type = TYPE_STRING;
          if(initializam == 0)
          {
               definedType.isIntialized = false;
          }
          int leng = strlen(initializam);
          definedType.value = malloc(leng*sizeof(char)+1);
          strcpy(definedType.value, initializam); 
          return definedType;
     }
     if(strcmp(tipDate, "Boolean") == 0)
     {
          definedType.type = TYPE_BOOL;
          definedType.boolean = false;
          if(strcmp(initializam, "True") == 0)
          {
               definedType.boolean = true;
          }
          return definedType;
     }
     printf("Unknown Data type. Exiting...");
     exit(0);

     return definedType;
}

struct memValue setConstant(struct memValue a)
{
     a.isConstant = true;
     return a;
}