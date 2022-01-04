#pragma once
#include "constants.h"

char* RemoveQuotesFromString(char* _s)
{
    size_t _len = strlen(_s);
    char* _new_s = malloc(_len * sizeof(_s[0]));
    strncpy(_new_s, _s+1, _len-2);
    _new_s[_len-2] = 0;
    return _new_s;
}

void PrintValue(char* str, char* x)
{
    printf("%s %s\n",RemoveQuotesFromString(str), x);
}

void PrintIdentifier(char* str, char* identifier)
{
    char error[200];
    struct Identifier* id = GetVariabileFromContext(identifier);
    switch(id->type)
    {
        case TYPE_INTEGER:
            printf("%s %d\n", RemoveQuotesFromString(str), id->value.number);
            break;
        case TYPE_FLOAT:
            printf("%s %.4f\n", RemoveQuotesFromString(str), id->value.decimal);
            break;
        case TYPE_BOOL:
            printf("%s %s\n", RemoveQuotesFromString(str), ((id->value.binar == true) ? "true" : "false"));
            break;
        default:
            sprintf(error, "You can only print integers, floats, booleans.");
            yyerror(error);
    }
}

