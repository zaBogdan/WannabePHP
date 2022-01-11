#pragma once
#include "definitions.h"

void AddFunction(Function func)
{
    functionSignatures[functionSignaturesIDX] = func;
    ++functionSignaturesIDX;
}

int GetFunction(char* signature)
{
    for(int idx=0;idx<functionSignaturesIDX;++idx)
    {
        if(!strcmp(signature, functionSignatures[idx].functionSignature))
            return idx;
    }
    return -1;
}

char* GetValueFromFunctionCall(int functionPos)
{
    return DefaultValueForType(functionSignatures[functionPos].returnType);
}

void DeclareFunction(char* type, char* name, int arguments)
{
    //build signature & construct new Object
    char signature[400];
    Function func;

    func.name = malloc(strlen(name) * sizeof(char));
    strcpy(func.name, name);

    func.context = malloc(strlen(oldContext)*sizeof(char));
    strcpy(func.context, oldContext);

    // func.returnType = GetTypeFromString(type);
    func.returnType = malloc(strlen(type)*sizeof(type));
    strcpy(func.returnType, type);

    sprintf(signature, "%s(", name);
    
    func.types = malloc((identifiersIDX-arguments)*sizeof(int));
    func.parametersIDX = malloc(arguments*sizeof(int));
    func.paramCount = arguments;
    uint8_t counter = 0;
    for(int idx = identifiersIDX - arguments; idx < identifiersIDX; ++idx)
    {
        func.types[idx] = storedData[idx].type;
        func.parametersIDX[counter++] = idx;
        sprintf(signature,"%s%s",signature, GetTypeFromInt(storedData[idx].type));
        if(idx == identifiersIDX-1)
        {
            sprintf(signature,"%s%s", signature, ")");
        }else{
            sprintf(signature,"%s%s", signature, ",");

        }
    
    }

    func.functionSignature = malloc(strlen(signature)*sizeof(char));
    strcpy(func.functionSignature, signature);
    //check if the signature is already defined
    char error[200];
    if(GetFunction(func.functionSignature) != -1)
    {
        sprintf(error,"A function with the same signature has been already declared. (Signature: '%s')", func.functionSignature);
        yyerror(error);
    }

    //check the current context

    AddFunction(func);
}

Array InitializeCallStackArray()
{
    Array data;
    data.currentIDX = 0;
    return data;
}

void PushValueToCallStack(Array* arr, char* value)
{
    arr->values[arr->currentIDX] = malloc(strlen(value) * sizeof(value[0]));
    strcpy(arr->values[arr->currentIDX], value);
    ++arr->currentIDX;
}

int FunctionCall(char* name, Array values)
{
    //build function signature
    char signature[400], error[200];

    sprintf(signature, "%s(", name);

    for(int idx=0;idx<values.currentIDX;++idx)
    {
        // printf("Type of value '%s' is '%s'\n", values.values[idx], DecideValueType(values.values[idx]));
        if(idx+1 != values.currentIDX)
        {
            sprintf(signature, "%s%s,", signature, DecideValueType(values.values[idx]));
        }else{
            sprintf(signature, "%s%s)", signature, DecideValueType(values.values[idx]));

        }
    }

    int functionPos = GetFunction(signature);

    if(functionPos == -1)
    {
        sprintf(error, "No function with signature '%s' has been found.", signature);
        yyerror(error);
    }

    //checking the context
    if(!IsInScope(functionSignatures[functionPos].context))
    {
        sprintf(error, "Function '%s' is only available in %s context. (Current: %s)", signature, functionSignatures[functionPos].context, currentContext);
        yyerror(error);
    }

    AssignValueIgnoreContext = true;
    //assign the values to the variables
    for(int idx = 0; idx < functionSignatures[functionPos].paramCount; ++idx)
    {
        #ifdef __DEBUG__
        printf("[ %s ]Assigning to %s=%s\n",functionSignatures[functionPos].name, storedData[functionSignatures[functionPos].parametersIDX[idx]].name, values.values[idx]);
        #endif
        AssignValue(storedData[functionSignatures[functionPos].parametersIDX[idx]].name, values.values[idx],0);
    }
    AssignValueIgnoreContext = false;

    return functionPos;
}