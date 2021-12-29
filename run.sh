#!/bin/bash

rootDir=src/
buildDir=build/

lex -t $rootDir$1.l > build/lex.yy.c
yacc $rootDir$1.y -o build/y.tab.c
gcc -Wmacro-redefined -ll -o compiler -I${rootDir} ${buildDir}lex.yy.c 