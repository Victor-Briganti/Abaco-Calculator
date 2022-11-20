calc: lex.yy.c y.tab.c
	gcc lex.yy.c y.tab.c -o calc && make clean

lex.yy.c: 
	flex scanner.l

y.tab.c:
	bison -dy grammar.y

clean:
	rm -f lex.yy.c y.tab.h y.tab.c
