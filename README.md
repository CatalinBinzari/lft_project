# lft_project

flex val.l 
bison -d val.y 
gcc -o myexe val.tab.c lex.yy.c -lfl 
./myexe




flex val.l && bison -d val.y && gcc -o myexe val.tab.c lex.yy.c -lfl && ./myexe
