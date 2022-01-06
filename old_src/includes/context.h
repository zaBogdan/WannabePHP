#pragma once
#include "constants.h"

/**
 * @brief Context related function are below
 */
void switchContext(char* name)
{
     strcpy(oldScope, currentScope);
     strcpy(currentScope, name);
}

void revertContext()
{
     char copy[200];
     strcpy(copy, oldScope);
     switchContext(copy);
}

//for classes
void class_enter(char* className)
{
     strncat(className, ".",1);
     strcpy(oldScope, currentScope);
     strcpy(currentScope, className);
}

void class_leave()
{
     strcpy(currentScope, oldScope);
}

//for functions
void function_enter(char* functionName)
{
     strcpy(oldScope, currentScope);
     int len = strlen(currentScope);
     if(currentScope[len-1] == '.')
     {
          //we are inside of a class
          strncat(currentScope, functionName, strlen(functionName));
     }else{
          strcpy(currentScope, functionName);
     }
}

void function_leave()
{
     int len = strlen(currentScope);
     for(int i=0;i<len;i++)
     {
          if(currentScope[i] == '.')
          {
               //we are inside a class.
               char* newScope = malloc(100*sizeof(char));
               newScope = strtok(currentScope, ".");
               strncat(newScope, ".", 1);
               return;
          }
     }
     strcpy(currentScope, oldScope);
}

void enter_array(char* type)
{
     printf("Entering in context array : %s\n", type);
     strcpy(arrayType, type);
}

void leave_array()
{
     strcpy(arrayType, "");
}

/**
 * @brief Get the Current Context object
 *
 * @return 0 - if we are in a global context
 * @return 1 - if we are in a class context
 * @return 2 - if we are in a function context
 */
int GetCurrentContext()
{
     if(!strcmp(currentScope, "global"))
          return 0;
     for(int i=0;i<strlen(currentScope);i++)
          if(currentScope[i] == '.')
               return 1;
     return 2;
}