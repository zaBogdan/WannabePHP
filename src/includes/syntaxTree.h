#pragma once
#include "definitions.h"

void PrintFunction(char* str1, char* str2)
{
    printf("%s %s\n", RemoveQuotesFromString(str1), str2);
}

Node* NewNode(char* data)
{
    char error[200];
    Node* node = (Node*)malloc(sizeof(Node));
 
    //check if data is int/float
    char* dataType = DecideValueType(data);
    
    node->type = -1;

    if(!strcmp(dataType, "Int") || !strcmp(dataType, "Float"))
    {
       node->type = 1;
       
    }

    if(strchr("+-/*", data[0]) != NULL)
    {
        node->type = 2;
    }

    if(node->type == -1)
    {
        sprintf(error, "Expression can only have int/float (casted as int) type. You passed %s type.", dataType);
        yyerror(error);
    }

    // Assign data to this node
    node->data = strtol(data, NULL, 10);
 
    // Initialize left and
    // right children as NULL
    node->left = NULL;
    node->right = NULL;

    return (node);
}

// char* AddOperation(char* val1, char* op, char* val2)
// {

//     return arith;
// }
