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

char* GetRootScope(char* currentScope)
{
     size_t len = strlen(currentScope);
     char* data;
     for(int i=0;i<len;++i)
     {
          if(currentScope[i] == '.')
          {
               data = malloc((i+2)*sizeof(char));
               strncpy(data, currentScope, i+1);
               data[i+2] = 0;
               return data;
          }
     }
     return NULL;
}