#!/bin/bash

rootDir=src/
buildDir=build/

lex -t $rootDir$1.l > build/lex.yy.c
yacc -d -v $rootDir$1.y -o build/y.tab.c
gcc -Wmacro-redefined -ll -o compiler -I${rootDir}/includes ${buildDir}lex.yy.c 