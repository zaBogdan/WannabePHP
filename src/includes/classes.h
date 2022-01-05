#pragma once
#include "constants.h"


bool isClassDeclared(char* className)
{
     for(int idx = 0; idx < allClassesIDX; ++idx)
     {
          printf("Checking %s == %s\n", allClasses[idx], className);

          if(!strcmp(allClasses[idx], className))
               return true;
     }
     return false;
}

void DeclareClass(char* name)
{
     char error[200];
     sprintf(error, "Class called '%s' has already been declared. Try a more creative name.", name);
     
     if(isClassDeclared(name))
          yyerror(error);
     
     printf("Declaring class: %s\n", name);
     allClasses[allClassesIDX] = malloc(strlen(name)*sizeof(char));
     strcpy(allClasses[allClassesIDX], name);
     ++allClassesIDX;
}

void SetVariabileInClassContext(struct ClassInfo newClass)
{
     AddIdentifier(newClass.identifierName);
     classDetails[classDetailsIDX] = newClass;
     ++classDetailsIDX;
}

void InitializeClass(char* className, char* identifier)
{
     char error[200];
     sprintf(error, "Class called '%s' hasn't been declared. You must first declare it.", className);
     printf("Checking if the class is declared.\n");
     if(!isClassDeclared(className))
          yyerror(error);

     struct ClassInfo newClass;

     //getting the class name
     size_t _len = strlen(className);
     newClass.className = malloc(_len *sizeof(char));
     strcpy(newClass.className, className);
     
     //getting the identifier
     _len = strlen(identifier);
     newClass.identifierName = malloc(_len * sizeof(char));
     strcpy(newClass.identifierName, identifier);

     //setting the classs
     SetVariabileInClassContext(newClass);    
}

char* GetClassNameFromIdentifier(char* Identifier)
{
     char error[200];
     if(!CheckIdentifier(Identifier,false))
     {
          sprintf(error, "Found an undeclared identifier '%s'. You first have to declare before initialize a value.", Identifier);
          yyerror(error);
     }
     for(int idx=0;idx<classDetailsIDX;++idx)
     {
          if(!strcmp(classDetails[idx].identifierName, Identifier))
          {
               size_t _len = strlen(classDetails[idx].className) + 2;
               char* tempClass = malloc(sizeof(char)*_len);
               strcpy(tempClass, classDetails[idx].className);
               strcat(tempClass, ".");
               return tempClass;
          }
     }

     return "global";
}


