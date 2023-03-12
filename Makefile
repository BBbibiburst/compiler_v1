parser.exe:main.c lex.yy.c syntax.tab.c Tree.c
	gcc main.c syntax.tab.c Tree.c -lfl -o parser.exe -w
lex.yy.c:lexical.l
	flex lexical.l
syntax.tab.c syntax.tab.h:syntax.y
	bison -d syntax.y
.PHONY:clean test
clean:
	rm lex.yy.c syntax.tab.c syntax.tab.h
test:
	./parser.exe ./test/1.cmm
		
