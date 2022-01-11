#pragma once
#include <stdlib.h>
#include <sys/time.h>
#include "definitions.h"

char* CastIntToAscii(int __a)
{
    char* newInt = malloc(32*sizeof(char));
    sprintf(newInt, "%d", __a);
    return newInt;
}

bool GetIntFromAscii(char* _a, char* _b, int *__a, int *__b)
{
    Value x = GetValueFromChar("_a", _a, TYPE_INTEGER);
    *__a = x.number;
    
    x = GetValueFromChar("__b", _b, TYPE_INTEGER);
    *__b = x.number;
    return true;
}


char* predefined_max(char* __a, char* __b)
{
    int a,b;
    GetIntFromAscii(__a,__b, &a, &b);
    return CastIntToAscii( ( (a > b) ? a : b ) );
}

char* predefined_min(char* __a, char* __b)
{
    int a,b;
    GetIntFromAscii(__a,__b, &a, &b);
    return CastIntToAscii( ( (a < b) ? a : b ) );
}

char* predefined_len(char* __a)
{
    if(strcmp(DecideValueType(__a), "String"))
    {
        char error[200];
        sprintf(error,"Predefined LEN function takes only `String` as argument");
        yyerror(error);
    }
    return CastIntToAscii(strlen(RemoveQuotesFromString(__a)));
}

char* predefined_gcd(char* __a, char* __b)
{
    int a,b;
    GetIntFromAscii(__a,__b, &a, &b);
    
    int r, i;
    while(b){
        r = a % b;
        a = b;
        b = r;
    }

    return CastIntToAscii(a);
}

char* predefined_random()
{
    time_t t;
    srand((unsigned) time(&t));
    return CastIntToAscii(rand() % 1024);
}