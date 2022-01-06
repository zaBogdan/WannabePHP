#pragma once
#include "definitions.h"

void PrintFunction(char* str1, char* str2)
{
    printf("%s %s\n", RemoveQuotesFromString(str1), str2);
}