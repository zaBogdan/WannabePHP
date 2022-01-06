#pragma once
#include "definitions.h"


/**
 * @brief Global helper functions for Data structures
 * 
 */

void PushIdentifier(char* id)
{
    strcpy(identifiers[identifiersIDX], id);
    ++identifiersIDX;
}

void PushObjectToContext(Object newObj)
{
    PushIdentifier(newObj.name);
    storedData[storedDataIDX] = newObj;
    ++storedDataIDX;
}

int IsIdentifierDeclared(char* name)
{
    for(int idx = 0;idx<identifiersIDX;++idx)
    {
        if(!strcmp(name, identifiers[idx]))
            return idx;
    }

    return -1;
}

/**
 * @brief Data structures: Variables.
*/

void DeclareVariable(char* type, char* key, char* value, bool _init)
{
    char error[200];
    if(IsIdentifierDeclared(key) != -1)
    {
        sprintf(error, "You can't redeclare `%s`. Try to be more creative.", key);
        yyerror(error);
    }
    Object newVariable;

    //setting the context
    size_t _strLen = strlen(key);
    newVariable.name = malloc(_strLen * sizeof(char));
    strcpy(newVariable.name, key);

    //setting the name
    _strLen = strlen(currentContext);
    newVariable.context = malloc(_strLen * sizeof(char));
    strcpy(newVariable.context, currentContext);

    //setting some atributes
    newVariable.constant = constantContext;
    newVariable.initialized = _init;
    newVariable.isArray = false;

    //setting the type
    newVariable.type = GetTypeFromString(type);

    //checking for missmatches
    if(newVariable.constant && !newVariable.initialized)
    {
        sprintf(error, "You can't declare `%s` as constant object without initializing it.", newVariable.name);
        yyerror(error);
    }

    if(newVariable.initialized)
    {
        //setting the raw variable
        _strLen = strlen(value);
        newVariable.charValue = malloc(1 * sizeof(char*));
        newVariable.charValue[0] = malloc(_strLen * sizeof(char));
        strcpy(newVariable.charValue[0], value);

        //getting the real value (easier for calculus)
        newVariable.value = malloc(1 * sizeof(Value*));
        newVariable.value[0] = GetValueFromChar(key, value, newVariable.type);
    }


    printf("[VARIABLE] TYPE: %d, ID: %s, CONTEXT: %s, INTIALIZED: %d \n",
        newVariable.type,
        newVariable.name, 
        newVariable.context,
        newVariable.initialized
        );
    PushObjectToContext(newVariable);


}

void AssignValue(char* key, char* value)
{
    char error[200];
    int variableLocation = IsIdentifierDeclared(key);
    if(variableLocation == -1)
    {
        sprintf(error, "You can't assign a value to an undeclared object `%s`. Declare it first.", key);
        yyerror(error);
    }
}

/**
 * @brief Data structures: Arrays.
*/
void DeclareArray(char* type, char* key, bool _init)
{
    printf("[ARRAY] Type: %s, Name: %s, Context: %s\n", type, key, currentContext);
}


/**
 * @brief Data structures: Custom objects.
*/
