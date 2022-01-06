#pragma once
#include "definitions.h"

void FormatMessage(char* msg, Object obj)
{
    sprintf(msg, "[%s] Identifier: %s, Type:", obj.context, obj.name);
    if(obj.constant)
    {
        sprintf(msg, "%s constant", msg);
    }
    if(obj.isArray)
    {
        sprintf(msg, "%s Array", msg);
    }

    sprintf(msg, "%s %s,", msg, types[obj.type-1]);
    if(obj.initialized)
    {
        if(obj.isArray)
        {

        }else{
            sprintf(msg, "%s Value: %s", msg, obj.charValue[0]);
        }
    }else{
        sprintf(msg, "%s Value: (uninitialized)", msg);
    }

    sprintf(msg, "%s\n", msg);
}

void DumpObjectsToFile(FILE* file)
{
    char msg[200];
    for(int idx = 0;idx < storedDataIDX; ++idx)
    {
        FormatMessage(msg, storedData[idx]);
        fprintf(file,"%s",msg);
    }
}