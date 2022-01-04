#pragma once
#include "constants.h"

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

