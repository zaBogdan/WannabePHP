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

    #ifdef __DEBUG__
    printf("[VARIABLE] TYPE: %d, ID: %s, CONTEXT: %s, INTIALIZED: %d \n",
        newVariable.type,
        newVariable.name, 
        newVariable.context,
        newVariable.initialized
        );
    #endif
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

    //TODO: Check if the variable is visible in your scope.

    if(storedData[variableLocation].constant)
    {
        sprintf(error, "You can't reassign a value to a constant object `%s'.", key);
        yyerror(error);
    }
    
    //if not initialized we should allocate some memory
    if(!storedData[variableLocation].initialized)
    {
        storedData[variableLocation].charValue = malloc(1 * sizeof(char*));
        storedData[variableLocation].value = malloc(1 * sizeof(Value*));
    }

    size_t _strLen;
    _strLen = strlen(value);
    storedData[variableLocation].charValue[0] = malloc(_strLen * sizeof(char));
    strcpy(storedData[variableLocation].charValue[0], value);

    storedData[variableLocation].value[0] = GetValueFromChar(key, value,storedData[variableLocation].type);
    storedData[variableLocation].initialized = true;

    #ifdef __DEBUG__
    printf("[AssignValue] TYPE: %d, ID: %s, CONTEXT: %s, VARIABLE: %s \n",
        storedData[variableLocation].type,
        storedData[variableLocation].name, 
        storedData[variableLocation].context,
        storedData[variableLocation].charValue[0]
        );
    #endif
}

/**
 * @brief Data structures: Arrays.
*/
//some helpers for arrays
void InitializeArray()
{
    for(int idx = 0; idx < vectorListIDX; ++idx)
    {
        free(vectorList[idx]);
    }
    vectorListIDX = 0;
}

void PushElementInArray(char* value)
{
    size_t _strLen = strlen(value);
    vectorList[vectorListIDX] = malloc(_strLen * sizeof(char));
    strcpy(vectorList[vectorListIDX], value);
    vectorList[vectorListIDX][_strLen]=0;
    ++vectorListIDX;
}


//actual functions
void DeclareArray(char* type, char* key, bool _init)
{
    char error[200];

    printf("[ARRAY] Type: %s, Name: %s, Context: %s\n", type, key, currentContext);
    
    if(IsIdentifierDeclared(key) != -1)
    {
        sprintf(error, "You can't redeclare `%s`. Try to be more creative.", key);
        yyerror(error);
    }

    Object newVariable;
    size_t _strLen;

    _strLen = strlen(key);
    newVariable.name = malloc(_strLen * sizeof(char));
    strcpy(newVariable.name, key);

    _strLen = strlen(currentContext);
    newVariable.context = malloc(_strLen * sizeof(char));
    strcpy(newVariable.context, currentContext);

    //some settings
    newVariable.constant = constantContext;
    newVariable.initialized = _init;
    newVariable.isArray = true;

    //initializing some array stuff
    newVariable.maxCapacity = 150;
    newVariable.maxPosition = vectorListIDX;

    if(newVariable.maxPosition > newVariable.maxCapacity)
    {
        sprintf(error, "Object `%s` of type array must have no more then 150 elements.", newVariable.name);
        yyerror(error);
    }

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
        newVariable.charValue = malloc(vectorListIDX * sizeof(char*));
        newVariable.value = malloc(vectorListIDX * sizeof(Value));

        for(int idx = 0; idx < vectorListIDX; ++idx)
        {
            _strLen = strlen(vectorList[idx]);
            newVariable.charValue[idx] = malloc(_strLen * sizeof(char));
            strcpy(newVariable.charValue[idx], vectorList[idx]);
            char* customKey = malloc((strlen(key)+10)*sizeof(char));
            sprintf(customKey, "%s[%d]", key, idx);
            newVariable.value[0] = GetValueFromChar(customKey, vectorList[idx], newVariable.type);
        }
    }


    for(int i=0;i< vectorListIDX; ++i)
    {
        printf("[ARRAY] %s[%d] = %s\n", key, i, vectorList[i]);
    }

    PushObjectToContext(newVariable);
}


/**
 * @brief Data structures: Custom objects.
*/
