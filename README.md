# lft_project

compilabil cu:

flex val.l && bison -d val.y && gcc -o myexe val.tab.c lex.yy.c -lfl && ./myexe


Se citeste din input.txt doar un singur rand si se stocheaza rezultatul in output.txt
In consola se vor afisa doar mesajele de debug
