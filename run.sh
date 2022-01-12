#!/bin/bash

rootDir=src/
buildDir=build/
tabelsDir=tabels

mkdir -p ${buildDir}
mkdir -p ${tabelsDir}

lex -t $rootDir$1.l > ${buildDir}/lex.yy.c
yacc -d -v $rootDir$1.y -o ${buildDir}/y.tab.c 
# 2>/dev/null
gcc -Wmacro-redefined -ll -o compiler -I${rootDir}/includes ${buildDir}lex.yy.c 