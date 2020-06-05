.PHONY: all compilare_proiect clean

all: compilare_proiect
compilare_proiect:
	@echo "Compilare proiect"
	@flex val.l
	@bison -d val.y
	@gcc -o myexe val.tab.c lex.yy.c -lfl
	@./myexe

clean:
	@echo "Stergere fisiere..."
	@rm val.tab.* lex.yy.c myexe