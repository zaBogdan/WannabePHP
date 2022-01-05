#pragma once

struct suportedTypes{
     int number;
     char character;
     char* string;
     float decimal;
     bool binar;
};

struct Identifier{
     //identifiers
     char* name;
     char* scopeName;
     unsigned int type;
     
     //value that it holds
     struct suportedTypes value;
     
     //characteristics
     bool isPrivate;
     bool isConstant;
     bool isInitialized;
};

struct ClassInfo{
     char* identifierName;
     char* className;
};