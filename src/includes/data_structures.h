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

void SwitchToContextOfIdentifer(char* id)
{
    char error[200];
    size_t classLocation = -1;
    
    for(int idx = 0;idx < customObjectsIDX; ++idx)
    {
        if(!strcmp(customObjects[idx].id, id))
        {
            classLocation = idx;
            break;
        }
    }


    if(classLocation == -1)
    {
        sprintf(error, "You can't assign a value to an undeclared object `%s`. Declare it first.", id);
        yyerror(error);
    }

    if(strcmp(currentContext, "main"))
    {
        sprintf(error, "Variable '%s' is only visible in main context. (Current context: '%s')", id, currentContext);
        yyerror(error);
    }

    char* changingContext = malloc(strlen(customObjects[classLocation].typeName+2)*sizeof(char));
    strcpy(changingContext, customObjects[classLocation].typeName);
    strcat(changingContext, ".");
    SwitchContext(changingContext);
}


void AssignValue(char* key, char* value, int pos)
{
    char error[200];
    int variableLocation = IsIdentifierDeclared(key);
    
    if(variableLocation == -1)
    {
        sprintf(error, "You can't assign a value to an undeclared object `%s`. Declare it first.", key);
        yyerror(error);
    }

    //Check if the variable is visible in your scope.
    if(!IsInScope(storedData[variableLocation].context) && !AssignValueIgnoreContext)
    {
        sprintf(error, "Variabile '%s' was declared in '%s' context. We are in: %s",key,storedData[variableLocation].context, currentContext);
        yyerror(error);
    }

    if(storedData[variableLocation].constant)
    {
        sprintf(error, "You can't reassign a value to a constant object `%s'.", key);
        yyerror(error);
    }
    
    //if not initialized we should allocate some memory
    if(!storedData[variableLocation].initialized)
    {
        if(storedData[variableLocation].isArray)
        {
            storedData[variableLocation].charValue = malloc(storedData[variableLocation].maxCapacity * sizeof(char*));
            storedData[variableLocation].value = malloc(storedData[variableLocation].maxCapacity * sizeof(Value*));
        }else{
            storedData[variableLocation].charValue = malloc(1 * sizeof(char*));
            storedData[variableLocation].value = malloc(1 * sizeof(Value*));
        }
    }

    if(storedData[variableLocation].isArray)
    {
        storedData[variableLocation].maxPosition = max(storedData[variableLocation].maxPosition, pos+1);
    }

    size_t _strLen;
    _strLen = strlen(value);
    storedData[variableLocation].charValue[pos] = malloc(_strLen * sizeof(char));
    strcpy(storedData[variableLocation].charValue[pos], value);

    storedData[variableLocation].value[pos] = GetValueFromChar(key, value,storedData[variableLocation].type);
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
        newVariable.charValue = malloc(newVariable.maxCapacity * sizeof(char*));
        newVariable.value = malloc(newVariable.maxCapacity * sizeof(Value));

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

    PushObjectToContext(newVariable);
}


/**
 * @brief Data structures: Custom objects.
*/

bool isTypeDeclared(char* type)
{
    for(int idx = 0;idx < customTypesIDX; ++idx)
    {
        if(!strcmp(customTypes[idx], type))
            return true;
    }
    return false;
}

void DeclareType(char* type)
{
    strcpy(customTypes[customTypesIDX], type);
    ++customTypesIDX;
}

void DeclareClass(char* type, char* id)
{
    char error[200];
    if(!isTypeDeclared(type))
    {
        sprintf(error, "You can't declare `%s` object with an unknown type `%s`. Try to declare the object first.", id, type);
        yyerror(error);
    }

    if(IsIdentifierDeclared(id) != -1)
    {
        sprintf(error, "You can't redeclare `%s`. Try to be more creative.", id);
        yyerror(error);
    }
 
    CustomObj cls;
    size_t _strLen = strlen(type);

    cls.typeName = malloc(_strLen * sizeof(char));
    strcpy(cls.typeName, type);

    _strLen = strlen(id);
    cls.id = malloc(_strLen * sizeof(char));
    strcpy(cls.id, id);

    PushIdentifier(id);

    customObjects[customObjectsIDX] = cls;
    ++customObjectsIDX;

}

//operations with variables
char* GetValueFromIdentifier(char* key, int pos)
{
    char error[200];
    int variableLocation = IsIdentifierDeclared(key);
    
    if(variableLocation == -1)
    {
        sprintf(error, "You can't assign a value to an undeclared object `%s`. Declare it first.", key);
        yyerror(error);
    }

    //TODO: Check the scope
    if(!IsInScope(storedData[variableLocation].context))
    {
        sprintf(error, "Variabile '%s' was declared in '%s' context. We are in: %s",key,storedData[variableLocation].context, currentContext);
        yyerror(error);
    }

    bool arrayCheck = storedData[variableLocation].isArray && pos > storedData[variableLocation].maxPosition;
    bool notArray = !storedData[variableLocation].isArray && pos != 0;
    if(arrayCheck || notArray)
    {
        sprintf(error, "You are trying to access an illegal value. Max declared position is: %d.", storedData[variableLocation].maxPosition);
        yyerror(error);
    }

    
    return storedData[variableLocation].charValue[pos];
}