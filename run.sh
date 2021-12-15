#!/bin/bash

lex $1.l
yacc $1.y
gcc lex.yy.c -ll -o compiler