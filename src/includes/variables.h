#pragma once
#include "constants.h"

/**
 * @brief Variable definitions are to be found here
 */

void constat_enter()
{
     constVariabile = true;
}

void constat_leave()
{
     constVariabile = false;
}

void CheckIdentifier(char* key)
{
     for(int idx = 0; idx < allKeysIDX; idx++)
     {
          if(!strcmp(allKeys[idx], key))
          {
               char error[200];
               sprintf(error, "Identifier '%s' has been already declared. Try to be more creative!", key);
               yyerror(error);
          }
     }
}

void AddIdentifier(char* key)
{
     if(allKeysIDX > 1000)
     {
          yyerror("You can have up to 1000 unique identifiers in your code.");
     }

     // here we will improve on it.
     strcpy(allKeys[allKeysIDX], key);
     ++allKeysIDX;

}
void SetVariableInGlobalContext(struct Identifier id)
{
     printf("GLOBAL Context: %s, Name: %s, Constant: %d, Initialized: %d, Type: %d\n", id.scopeName, id.name, id.isConstant, id.isInitialized, id.type);
     AddIdentifier(id.name);
}

void SetVariabileInObjectContext(struct Identifier id)
{
     AddIdentifier(id.name);
     
}

void SetVariabileInFunctionContext(struct Identifier id)
{
     AddIdentifier(id.name);
     
}


void DeclareValue(char* dataType, char* key, char* value, bool _isIntialized)
{
     //checking if in the same scope we have this variable declared.
     CheckIdentifier(key);

     struct Identifier newId;
     size_t keyLength = strlen(key);
     size_t valueLength = strlen(value);
     size_t contextLength = strlen(currentScope);
     //setting the name
     newId.name = malloc(keyLength*sizeof(char));
     strcpy(newId.name, key);

     //setting the scope
     newId.scopeName = malloc(contextLength*sizeof(char));
     strcpy(newId.scopeName, currentScope);
     
     //setting the options
     newId.isConstant = constVariabile;
     newId.isPrivate = privateVariabile;
     newId.isInitialized = _isIntialized;

     //checking for things like Readonly Int $x;
     if(newId.isConstant == true && !newId.isInitialized)
     {
          char error[200];
          sprintf(error, "Missing initialized of an object of const type '%s'.\n", newId.name);
          yyerror(error);
     }

     //deciding the data type.
     do{
          newId.type = TYPE_INTEGER;
          CHECK_BREAK(!strcmp(dataType, "Int"), newId.isInitialized, newId.value.number = atoi(value));
          newId.type = TYPE_FLOAT;
          CHECK_BREAK(!strcmp(dataType, "Float"), newId.isInitialized, newId.value.decimal = atof(value));
          newId.type = TYPE_CHAR;
          CHECK_BREAK(!strcmp(dataType, "Char"), newId.isInitialized, newId.value.character = value[0]);
          newId.type = TYPE_BOOL;
          CHECK_BREAK(!strcmp(dataType, "Boolean"), newId.isInitialized, newId.value.binar = (strcmp(value, "True") == 0));
          newId.type = TYPE_STRING;
          
          if(!strcmp(dataType, "String"))
          {
               newId.value.string = malloc(valueLength*sizeof(char));
               strcpy(newId.value.string, value);
               break;
          }

          //if we can;t map it we will error it out.
          char error[200];
          sprintf(error, "Failed to initialize object of %s (unknown) type '%s'", dataType, key);
          yyerror(error);
          break;
     }while(true);

     char error[200];

     //push the structure to it's context.
     switch(GetCurrentContext())
     {
          case 0:
               SetVariableInGlobalContext(newId);
               break;
          case 1:
               SetVariabileInObjectContext(newId);
               break;
          case 2:
               SetVariabileInFunctionContext(newId);
               break;
          default:
               sprintf(error, "Failed to switch to a specific context. We are in '%s'", currentScope);
               yyerror(error);
     }
}