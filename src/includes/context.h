#pragma once
#include "definitions.h"

void SwitchContext(char* name)
{
    char copyContext[50]; 
    strcpy(copyContext, currentContext);
    strcpy(oldContext, copyContext);
    strcpy(currentContext, name);
    printf("[ CONTEXT ] We are currently in %s. The old context was: %s\n",currentContext, oldContext);
}

void ExitContext()
{
    char copyContext[50]; 
    strcpy(copyContext, currentContext);
    strcpy(currentContext, oldContext);
    strcpy(oldContext, copyContext);
    printf("[ CONTEXT ] We are currently in %s. The old context was: %s\n",currentContext, oldContext);
}

void ClassContext(char* name)
{
    strcat(name, ".");
    SwitchContext(name);
}

void EnterConstant()
{
    constantContext = true;
}

void LeaveConstant()
{
    constantContext = false;
}