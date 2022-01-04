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

struct Identifier* GetVariabileFromContext(char* key)
{
     //no matter of context we first check global variables
     for(int idx=0;idx<globalScopeIDX;++idx)
     {
          if(!strcmp(globalScope[idx].name, key))
               return &globalScope[idx];
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
               if(strcmp(objectScope[idx].name, key))
                    continue;
               if(!strcmp(currentScope, objectScope[idx].scopeName))
                    return &objectScope[idx];
               
               //checking for the function not be inside a class
               char* root = GetRootScope(currentScope);
               if(root == NULL)
                    continue;
               if(!strcmp(root,objectScope[idx].scopeName))
                    return &objectScope[idx];
               
          }
          yyerror(error);

     //function context
     case 2:
          for(int idx=0;idx<functionScopeIDX;++idx)
          {
               //also checking the name and the scope
               if(strcmp(functionScope[idx].name, key))
                    continue;
               //checking for scope name
               if(!strcmp(currentScope, functionScope[idx].scopeName))
                    return &functionScope[idx];
          }
          yyerror(error);

     default:
          yyerror(error);
     }
     return &globalScope[0];
}

void AssignVariable(char* key, char* value)
{
     char error[200];
     if(!CheckIdentifier(key, false))
     {
          sprintf(error, "Found an undeclared identifier '%s'. You first have to declare before initialize a value.", key);
          yyerror(error);
     }
     struct Identifier* currentVariable = GetVariabileFromContext(key);

     if(currentVariable->isConstant == true)
     {
          sprintf(error, "You can't modify a constant type (Readonly)");
          yyerror(error);
     }
     //here i will 100% need to split it into 3 contexts again->... 
     printf("[ AssignVariable ] Current variable is: %s with type: %d \n", currentVariable->name, currentVariable->type);
     long int tempValue;
     float tempFloatVal;
     size_t size = strlen(value);

     switch(currentVariable->type)
     {
          case TYPE_INTEGER:
               tempValue = strtol(value, NULL,10);
               if(tempValue == 0L)
               {
                    sprintf(error, "Invalid type assigned to variable '%s' (required type: integer)", key);
                    yyerror(error);
               }
               currentVariable->value.number = tempValue;
               break;
          case TYPE_FLOAT:
               tempFloatVal = strtof(value, NULL);
               if(tempFloatVal == 0.0F)
               {
                    sprintf(error, "Invalid type assigned to variable '%s' (required type: float)", key);
                    yyerror(error);
               }
               currentVariable->value.decimal = tempFloatVal;
               break;
          case TYPE_CHAR:
               if(value[1] != 0)
               {
                    sprintf(error, "Invalid type assigned to variable '%s' (required type: char)", key);
                    yyerror(error);
               }
               currentVariable->value.character = value[0];
               break;
          case TYPE_STRING:
               if(value[0] != '"')
               {
                    sprintf(error, "Invalid type assigned to variable '%s' (required type: string)", key);
                    yyerror(error);
               }
               currentVariable->value.string = malloc(size*sizeof(char));
               strncpy(currentVariable->value.string, value+1, size-2);
               break;

          case TYPE_BOOL:
               if(!strcmp(value, "True"))
               {
                    currentVariable->value.binar = true;
                    break;
               }
               if(!strcmp(value, "False"))
               {
                    currentVariable->value.binar = false;
                    break;
               }
               sprintf(error, "Invalid type assigned to variable '%s' (required type: boolean)", key);
               yyerror(error);
          default:
               sprintf(error, "You are trying to assign to an invalid type.");
               yyerror(error);
     }
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