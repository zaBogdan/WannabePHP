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

void DeclareFunction(char* type, char* name, int arguments)
{
    //build signature & construct new Object
    char signature[400];
    Function func;

    func.name = malloc(strlen(name) * sizeof(char));
    strcpy(func.name, name);

    func.context = malloc(strlen(currentContext)*sizeof(char));
    strcpy(func.context, currentContext);

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

void FunctionCall(char* name)
{
    printf("The name of the function is: %s\n", name);
    for(int idx=0;idx<vectorListIDX;++idx)
    {
        printf("The value is: %s\n", vectorList[idx]);
    }
}