#pragma once
#include "definitions.h"

void SwitchContext(char* name)
{
    char copyContext[50]; 
    strcpy(copyContext, currentContext);
    strcpy(oldContext, copyContext);
    strcpy(currentContext, name);
    #ifdef __DEBUG__
    printf("[ CONTEXT ] We are currently in '%s'. The old context was: '%s'\n",currentContext, oldContext);
    #endif
}

void ExitContext()
{
    char copyContext[50]; 
    strcpy(copyContext, currentContext);
    strcpy(currentContext, oldContext);
    strcpy(oldContext, copyContext);
    #ifdef __DEBUG__
    printf("[ CONTEXT ] We are currently in '%s'. The old context was: '%s'\n",currentContext, oldContext);
    #endif

}

void ClassContext(char* name)
{
    strcat(name, ".");
    SwitchContext(name);
}

void FunctionContext(char* name)
{
    char funcName[150];
    if(currentContext[strlen(currentContext)-1] == '.')
    {
        strcpy(funcName, currentContext);
        strcat(funcName, name);
    }else{
        strcpy(funcName, name);
    }
    SwitchContext(funcName);
}

bool IsInScope(char* scope)
{
    size_t _len = strlen(currentContext);
    
    //checking if variabile is global
    if(!strcmp(scope, "global"))
        return true;

    //checking if the scope matches
    if(!strcmp(currentContext, scope))
        return true;

    //doing further checking for object variables
    for(int idx=0;idx<_len;++idx)
    {
        //if we find . we are inside a class
        if(currentContext[idx]=='.')
        {
            char* classContext = malloc((idx+2)*sizeof(char));
            strncpy(classContext, currentContext, idx+1);
            classContext[idx+2] = 0;
            if(!strcmp(classContext, scope))
                return true;
            break;
        }
    }

    return false;
}

void EnterConstant()
{
    constantContext = true;
}

void LeaveConstant()
{
    constantContext = false;
}