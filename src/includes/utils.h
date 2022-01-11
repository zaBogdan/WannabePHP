#pragma once
#include "definitions.h"


int max(const int _a, const int _b)
{
    return _a > _b ? _a : _b;
}

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
                if(tempValue == 0L && value[0] != '0')
                {
                    sprintf(error, "Invalid type assigned to variable '%s' (required type: integer)", key);
                    yyerror(error);
                }
                newValue.number = tempValue;
                break;
        case TYPE_FLOAT:
            tempFloatVal = strtof(value, NULL);
            if(tempFloatVal == 0.0F && !(!strcmp(value, "0") || !strcmp(value, "0.0")))
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
            if(value[0] == '"')
            {
                break;
            }
            sprintf(error, "Invalid type assigned to variable '%s' (required type: string)", key);
            yyerror(error);
        default:
            sprintf(error, "You are trying to assign to an invalid type.");
            yyerror(error);

    }

    return newValue;
}

int GetTypeFromString(char* strType)
{
    for(int idx = 0;idx < 6;++idx)
    {
        if(!strcmp(strType, types[idx]))
            return idx+1;
    }
    return -1;
}
char* GetTypeFromInt(int type)
{
    return types[type-1];
}

char* RemoveQuotesFromString(char* _s)
{
    size_t _len = strlen(_s);
    char* _new_s = malloc(_len * sizeof(_s[0]));
    strncpy(_new_s, _s+1, _len-2);
    _new_s[_len-2] = 0;
    return _new_s;
}

char* DefaultValueForType(char* type)
{
    char error[200];
    switch(GetTypeFromString(type))
    {
        case TYPE_INTEGER:
            return "0";

        case TYPE_FLOAT:
            return "0.0";
        
        case TYPE_CHAR:
            return "'a'";

        case TYPE_STRING:
            return "\"(null)\"";
        
        case TYPE_BOOL:
            return "False";
        
        default:
            sprintf(error,"No type could be found for '%s'", type);
    }

    return "";
}

char* DecideValueType(char* value)
{
    int tempValue;
    float tempFloatVal;

    if(value[0]=='\'')
    {
        return "Char";
    }

    if(value[0]=='\"')
    {
         return "String";
    }   

    if(!strcmp(value, "True") || !strcmp(value, "False"))
    {
        return "Boolean";
    }

    for(int i=0;i<strlen(value);++i)
    {
        if(value[i] == '.')
        {
            if(strtof(value, NULL) != 0.0F || !strcmp(value, "0") || !strcmp(value, "0.0"))
            {
                return "Float";
            }
            break;
        }
    }

    if(strtol(value, NULL,10) != 0L || value[0] == '0')
    {
        return "Int";
    }

    return "Void";

}