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
            sprintf(msg, "%s Values: (", msg);
            for(int idx = 0;idx < obj.maxPosition; ++idx)
            {
                sprintf(msg,"%s%s", msg, obj.charValue[idx]);
                if(idx != obj.maxPosition-1)
                    sprintf(msg, "%s, ", msg);
            }
            sprintf(msg, "%s)", msg);

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

void DumpFunctionsToFile(FILE* file)
{
    char msg[200];
    for(int idx=0;idx<functionSignaturesIDX;++idx)
    {
        sprintf(msg, "[%s] Signature: '%s', Return type: %s, with parameters:", functionSignatures[idx].context, functionSignatures[idx].functionSignature, functionSignatures[idx].returnType);
        for(int param = 0;param<functionSignatures[idx].paramCount;++param)
        {
            int id = functionSignatures[idx].parametersIDX[param];
            if(param+1 == functionSignatures[idx].paramCount)
            {
                sprintf(msg, "%s %s", msg, storedData[id].name);
            }else{
                sprintf(msg, "%s %s,", msg, storedData[id].name);
            }
        }
        sprintf(msg, "%s\n",msg);
        fprintf(file,"%s",msg);
    }
}