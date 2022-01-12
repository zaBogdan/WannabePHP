#pragma once
#include <math.h>
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
        // Assign data to this node
        node->data = strtol(data, NULL, 10);
    }

    if(!strcmp(dataType, "Bool"))
    {
        node->type = 1;
        node->data = (!strcmp(dataType, "True") ? 1 : 0);
    }

    if(strchr("+-/*", data[0]) != NULL)
    {
        node->type = 2;
        if(data[1] == '*')
            node->type = 3;
        node->data = data[0];
    }

    if(node->type == -1)
    {
        printf("Value is: %s\n",data);
        sprintf(error, "Expression can only have int/float (casted as int) type. You passed %s type.", dataType);
        yyerror(error);
    }
 
    // Initialize left and
    // right children as NULL
    node->left = NULL;
    node->right = NULL;

    return (node);
}


Node* BuildAst(Node* root, Node* left, Node* right)
{
    root->left = left;
    root->right = right;
    return root;
}

void printInorder(Node* node)
{
    if (node == NULL)
        return;
 
    /* first recur on left child */
    printInorder(node->left);
 
    /* then print the data of node */
    if(node->type == 1)
    {
        printf("%d ", node->data);
    }else{
        printf("%c ", node->data);
    }
 
    /* now recur on right child */
    printInorder(node->right);
}

int EvalASTRecursive(Node* root)
{

    if(root == NULL)
        return 0;
    
    if(!root->left && !root->right)
        return root->data;

    int left = EvalASTRecursive(root->left);
    int right = EvalASTRecursive(root->right);

    if(root->data == '+')
        return left+right;
    
    if(root->data == '-')
        return left-right;
    
    if(root->data == '*')
        return left*right;
    
    if(root->data == '/')
    {
        if(right == 0)
        {
            char error[200];
            sprintf(error,"You can't divide by 0!");
            yyerror(error);
        }
    }
    if(root->type == 3)
        return (int)pow(left,right);
    return 0;
}


char* EvalAST(Node* root)
{
    char* response = malloc(64 * sizeof(char));
    sprintf(response,"%d", EvalASTRecursive(root));
    return response;
}