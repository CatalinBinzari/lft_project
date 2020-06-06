.PHONY: all compile arbore clean

all: compile arbore



compile: 
	@echo "Compilare proiect"
	@bison -d -ocalc3.tab.c val.y
	@flex val.l
	@gcc -o myexe.exe calc3.tab.c lex.yy.c -lfl
arbore: 
	@echo "Compilare arbore"
	@bison -d -ocalc3.tab.c calc3.y
	@flex val.l
	@gcc -o arbore.exe calc3.tab.c lex.yy.c calc3c.c -lm -lfl


clean:
	@echo "Stergere fisiere..."
	@rm lex.yy.c myexe.exe arbore.exe calc3.tab.*
