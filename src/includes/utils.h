#pragma once
#include "definitions.h"

Value GetValueFromChar(char* key, char* value, int type)
{
    char error[200];
    Value newValue;
    int tempValue;
    float tempFloatVal;

    switch(type)
    {
        case TYPE_INTEGER:
                tempValue = strtol(value, NULL,10);
                if(tempValue == 0L)
                {
                    sprintf(error, "Invalid type assigned to variable '%s' (required type: integer)", key);
                    yyerror(error);
                }
                newValue.number = tempValue;
                break;
        case TYPE_FLOAT:
            tempFloatVal = strtof(value, NULL);
            if(tempFloatVal == 0.0F)
            {
                sprintf(error, "Invalid type assigned to variable '%s' (required type: float)", key);
                yyerror(error);
            }
            newValue.real = tempFloatVal;
            break;
        case TYPE_CHAR:
            if(value[0] != '\'')
            {
                sprintf(error, "Invalid type assigned to variable '%s' (required type: char)", key);
                yyerror(error);
            }
            newValue.character = value[1];
            break;
        case TYPE_BOOL:
            if(!strcmp(value, "True"))
            {
                newValue.binary = true;
                break;
            }
            if(!strcmp(value, "False"))
            {
                newValue.binary = false;
                break;
            }
            sprintf(error, "Invalid type assigned to variable '%s' (required type: boolean)", key);
            yyerror(error);
        case TYPE_STRING:
            break;
        default:
            sprintf(error, "You are trying to assign to an invalid type.");
            yyerror(error);

    }

    return newValue;
}

int GetTypeFromString(char* strType)
{
    char types[10][10] = {
        "Int", "Float", "Char", "String", "Boolean", "Void"
    };
    for(int idx = 0;idx < 6;++idx)
    {
        if(!strcmp(strType, types[idx]))
            return idx+1;
    }
    return -1;
}