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

/**
 * @brief Checks if the key of an identifier is already declared
 * 
 * @param key the name
 * @return true if the key exists
 * @return false otherwise
 */
bool CheckIdentifier(char* key, bool throwError)
{
     for(int idx = 0; idx < allKeysIDX; idx++)
     {
          if(!strcmp(allKeys[idx], key))
          {
                    return true;
          }
     }
     return false;
}


/**
 * @brief Adds an identifier to the global list
 * 
 * @param key the name of the identifier
 */
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
     //add the identifier to the list
     AddIdentifier(id.name);
     
     globalScope[globalScopeIDX] = id;
     ++globalScopeIDX;
}

void SetVariabileInObjectContext(struct Identifier id)
{
     AddIdentifier(id.name);
     objectScope[objectScopeIDX] = id;
     ++objectScopeIDX;
     
}

void SetVariabileInFunctionContext(struct Identifier id)
{
     AddIdentifier(id.name);
     functionScope[functionScopeIDX] = id;
     ++functionScopeIDX;
}


char* GetTypeFromInt(int type)
{
     switch(type)
     {
          case TYPE_INTEGER:
               return "integer";
          case TYPE_FLOAT:
               return "float";
          case TYPE_CHAR:
               return "character";
          case TYPE_BOOL:
               return "bool";
          case TYPE_STRING:
               return "string";
          default:
               return "VOID";
     }
}

struct Identifier GetVariabileFromContext(char* key)
{
     //no matter of context we first check global variables
     for(int idx=0;idx<globalScopeIDX;++idx)
     {
          if(!strcmp(globalScope[idx].name, key))
               return globalScope[idx];
     }
     char error[200];
     sprintf(error,"Couldn't the identifier '%s' in the current context (%s)", key, currentScope);

     switch (GetCurrentContext())
     {
     //object context
     case 1:
          for(int idx=0;idx<objectScopeIDX;++idx)
          {
               //checking the name and the scope to!
               if(!strcmp(objectScope[idx].name, key) && !strcmp(currentScope, objectScope[idx].scopeName))
                    return objectScope[idx];
          }
          yyerror(error);

     //function context
     case 2:
          for(int idx=0;idx<functionScopeIDX;++idx)
          {
               //also checking the name and the scope
               if(!strcmp(functionScope[idx].name, key) && !strcmp(currentScope, functionScope[idx].scopeName))
                    return functionScope[idx];
          }
          yyerror(error);

     default:
          yyerror(error);
     }
     return globalScope[0];
}

void AssignVariable(char* key, char* value)
{
     if(!CheckIdentifier(key, false))
     {
          char error[200];
          sprintf(error, "Found an undeclared identifier '%s'. You first have to declare before initialize a value.", key);
          yyerror(error);
     }
     struct Identifier currentVariable = GetVariabileFromContext(key);
     //here i will 100% need to split it into 3 contexts again.... 

     
}

void DeclareValue(char* dataType, char* key, char* value, bool _isIntialized)
{
     //checking if in the same scope we have this variable declared.
     if(CheckIdentifier(key, true))
     {
          char error[200];
          sprintf(error, "Identifier '%s' has been already declared. Try to be more creative!", key);
          yyerror(error);
     }

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


void StandardFormat(struct Identifier current, char* msg)
{
     char type[200] = "";
     if(current.isPrivate)
     {
          strncat(type, "private ",7);
     }
     if(current.isConstant)
     {
          strncat(type, "constant ",9);
     }
     char* strType = GetTypeFromInt(current.type);
     strncat(type, strType, strlen(strType));
     sprintf(msg, "[%s] Name: %s, Type: %s\n",current.scopeName,current.name, type);
}

void DumpVariablesToFile(FILE* file)
{
     char msg[200];
     for(int idx=0;idx<globalScopeIDX;++idx)
     {
          StandardFormat(globalScope[idx], msg);
          fprintf(file,"%s",msg);
     }
     for(int idx=0;idx<objectScopeIDX;++idx)
     {
          StandardFormat(objectScope[idx], msg);
          fprintf(file,"%s",msg);
     }
     for(int idx=0;idx<functionScopeIDX;++idx)
     {
          StandardFormat(functionScope[idx], msg);
          fprintf(file,"%s",msg);
     }
}