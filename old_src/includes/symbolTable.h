#pragma once
#include "constants.h"

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
     sprintf(msg, "[%s] Name: %s, Type: %s, Value:",current.scopeName,current.name, type);
     switch(current.type)
     {
          case TYPE_INTEGER:
               sprintf(msg, "%s %d",msg, current.value[0].number);
               break;
          case TYPE_FLOAT:
               sprintf(msg, "%s %.4f",msg, current.value[0].decimal);
               break;
          case TYPE_CHAR:
               sprintf(msg, "%s '%c'",msg, current.value[0].character);
               break;
          case TYPE_STRING:
               sprintf(msg, "%s \"%s\"",msg, current.value[0].string);
               break;
          case TYPE_BOOL:
               sprintf(msg, "%s %s",msg, (current.value[0].decimal == true ? "True" : "False"));
               break;
          default:
               return;
     }
     if(!current.isInitialized)
     {
          sprintf(msg, "%s (uninitialized)", msg);
     }
     sprintf(msg, "%s\n",msg);
}

void ClassFormat(struct ClassInfo current, char* msg)
{
    sprintf(msg, "[%s][Custom Type] Name: %s, Type: %s\n",current.scopeName, current.identifierName, current.className);
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
     for(int idx=0;idx<classDetailsIDX;++idx)
     {
          ClassFormat(classDetails[idx], msg);
          fprintf(file,"%s",msg);
     }
}

void DumpFunctions(FILE* file)
{
     for(int idx)
}