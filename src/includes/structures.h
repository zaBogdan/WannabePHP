#pragma once
typedef struct RealValue{
    bool binary;
    float real;
    int number;
    char character;
} Value;

typedef struct Object{
    char* name;     //the name of the object (ex: $s)
    char* context;  //the context (ex: global)
    int type;       //the type (ex: 1- Int)

    char** charValue; //the raw value (ex: "10")
    Value* value; //the actual value (ex: 10)

    //some flags
    bool constant;
    bool initialized;

    //some flags for array
    bool isArray;
    int maxPosition;
    int maxCapacity;
} Object;

typedef struct CustomObject{
    char* typeName;
    char* id;
} CustomObj;

typedef struct funcs{
    char* name;
    char* context;

    int* types;
    int* parametersIDX;

    int paramCount;

    char* returnType;
    char* functionSignature;
} Function;


typedef struct arrays{
    char* values[150];
    int currentIDX;
} Array;

typedef struct node
{
    int data;
    int type;
    struct node* left;
    struct node* right;
} Node;
